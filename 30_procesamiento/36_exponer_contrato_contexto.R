# ==============================================================================
# 36_exponer_contrato_contexto.R
# ------------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Productor del CONTRATO DE CONTEXTO v1. Lee idps_largo.parquet y
#            expone SOLO las senales donde el establecimiento MEJORA (por sobre
#            su GSE, o respecto de su evaluacion anterior), para ser consumido
#            por slep_minuta_buenas_senales. El filtrado de "que es una mejora"
#            ocurre AQUI, en el productor; el consumidor recibe un parquet ya
#            filtrado (contrato §1, §2).
#
# Especificacion: 50_documentacion/activa/contrato_contexto_v1.md (LEER). Este
#            script implementa ese contrato; no lo repite. Esquema de 15 columnas
#            en §3; senales en §6; cobertura declarada en §8.
#
# Insumos  : 40_salidas/intermedios/idps_largo.parquet (paso 34; NO se modifica).
#            10_utils/10_configuracion.R (INDICADOR_LABELS -> eje_etiqueta).
# Salidas  : 40_salidas/publico/contexto_idps.parquet (escritura atomica; solo
#            si cambio el contenido, sin contar periodo ni fecha_calculo: s33r;
#            o siempre, con IDPS_CONTEXTO_FORZAR=1 en el entorno: s33t).
#
# Invariantes respetados (🔒):
#   - Banderas sigdif/sigdifgru leidas VERBATIM (34:273-275); aqui NO se
#     recalculan: solo se mapean a booleano (== 1L).
#   - Solo se exponen filas con mejora_sobre_gse O mejora_ano_ano == TRUE.
#   - rbd SIEMPRE character.
#   - Los booleanos de mejora NUNCA son NA (0, -1 y NA -> FALSE).
#   - No se toca idps_largo.parquet ni ningun artefacto existente.
#
# Alcance de esta version: SOLO familia == "indicador". La senal ano-ano de
# nivel dimension (solo 2025, contrato §8) se EXCLUYE en v1 para no mezclar
# granos distintos bajo la misma columna `eje` (ver log de la sesion).
#
# Fecha    : 2026-07-11
# ==============================================================================

# ---- Anclaje de raiz + bootstrap (para correr standalone o via run_all) -----
if (!exists("raiz")) {
  raiz <- rprojroot::find_root(
    rprojroot::has_file(".here") |
      rprojroot::is_rstudio_project |
      rprojroot::is_git_root
  )
}
if (!exists("log_msg"))          source(file.path(raiz, "10_utils", "10_utils.R"))
if (!exists("INDICADOR_LABELS")) source(file.path(raiz, "10_utils", "10_configuracion.R"))

instalar_si_falta(c("here", "fs", "dplyr", "arrow", "rprojroot"))


# ============================================================================
# Constantes del contrato (nombradas; el contrato es la fuente de verdad)
# ============================================================================
PROYECTO_ORIGEN   <- "slep_idps"     # contrato §3 col 12
ESCALA_IDPS       <- "idps_prom"     # contrato §5 (puntaje del indicador 0-100)
VERSION_CONTRATO  <- "contexto_v1"   # contrato §3 col 15 / §9
FAMILIA_ALCANCE   <- "indicador"     # contrato §8: la senal vs-GSE es solo indicador

# Fecha de la corrida, leida UNA sola vez (D-2 de s33r): de ella salen periodo
# ("periodo de la corrida que genero el parquet, formato AAAA-MM", contrato §3
# col 13; se deriva, no se escribe a mano: D-2 de s33q, s33r) y fecha_calculo
# (§3 col 14). Asi las dos no pueden quedar en meses distintos si la corrida
# cruza la medianoche de un fin de mes.
FECHA_CORRIDA     <- Sys.Date()
PERIODO_CORRIDA   <- format(FECHA_CORRIDA, "%Y-%m")

# Escritura forzada (D-1 de s33r): con IDPS_CONTEXTO_FORZAR=1 en el entorno, el
# parquet se reescribe aunque su contenido no haya cambiado, para renovar
# periodo y fecha_calculo (contrato §3 cols 13 y 14). Sin la variable rige la
# regla de s33r: solo se reescribe si cambio el contenido.
FORZAR_ESCRITURA  <- identical(Sys.getenv("IDPS_CONTEXTO_FORZAR"), "1")

# Orden EXACTO de las 15 columnas (contrato §3). No alterar.
COLS_CONTRATO <- c(
  "rbd", "anio", "eje", "eje_etiqueta", "segmento", "escala",
  "valor", "desvio_gse", "mejora_sobre_gse", "mejora_ano_ano",
  "cod_grupo", "proyecto_origen", "periodo", "fecha_calculo", "version_contrato"
)

# Metadatos de la corrida (contrato §3 cols 13 y 14) y llave natural (§3). Un
# parquet que solo difiere en los metadatos NO se reescribe (s33r).
COLS_METADATOS_CORRIDA <- c("periodo", "fecha_calculo")
LLAVE_CONTRATO         <- c("rbd", "anio", "eje", "segmento")

# Ruta de salida (centralizada; contrato §10).
dir_publico <- ruta_salidas("publico")
if (!fs::dir_exists(dir_publico)) fs::dir_create(dir_publico, recurse = TRUE)
RUTA_SALIDA <- fs::path(dir_publico, "contexto_idps.parquet")


# ============================================================================
# Helpers
# ============================================================================

# Escritura atomica (write -> rename), mismo idiom que los pasos 33/34.
escribir_parquet_atomico <- function(df, ruta_final) {
  tmp <- fs::path(paste0(ruta_final, ".tmp"))
  arrow::write_parquet(df, tmp)
  fs::file_move(tmp, ruta_final)
  invisible(ruta_final)
}

# Mapea una bandera tri-estado {-1,0,1,NA} al booleano de mejora del contrato:
# TRUE solo si == 1; 0, -1 y NA -> FALSE. Idioma que NO propaga NA (contrato §6).
bandera_a_mejora <- function(x) !is.na(x) & x == 1L

# Contenido del contrato sin los metadatos de la corrida: data frame base
# ordenado por la llave natural, sin nombres de fila.
sin_metadatos_corrida <- function(df) {
  df <- as.data.frame(df)[, setdiff(COLS_CONTRATO, COLS_METADATOS_CORRIDA)]
  df <- df[do.call(order, unname(as.list(df[, LLAVE_CONTRATO]))), ]
  rownames(df) <- NULL
  df
}

# TRUE si el parquet vigente trae las 15 columnas del contrato, en su orden, y
# el mismo contenido que `nuevo` salvo periodo y fecha_calculo (identical()
# estricto). Si no existe o no se puede leer: FALSE, y se escribe como siempre.
contenido_sin_cambios <- function(ruta, nuevo) {
  if (!fs::file_exists(ruta)) return(FALSE)
  previo <- tryCatch(arrow::read_parquet(ruta), error = function(e) NULL)
  if (is.null(previo) || !identical(names(previo), COLS_CONTRATO)) return(FALSE)
  identical(sin_metadatos_corrida(previo), sin_metadatos_corrida(nuevo))
}


# ============================================================================
# Flujo principal
# ============================================================================

log_msg("Leyendo idps_largo.parquet (fuente; no se modifica)...", "INFO", "36_contexto")
ruta_fuente <- ruta_salidas("intermedios", "idps_largo.parquet")
if (!fs::file_exists(ruta_fuente)) {
  stop("No existe la fuente ", ruta_fuente, ". Corre run_all(only = 34) primero.")
}
largo <- arrow::read_parquet(ruta_fuente)

# --- Filtro de alcance ANTES de transformar (contrato §8) -------------------
# Solo familia indicador: es el unico nivel con senal vs-GSE, y evita mezclar
# granos bajo `eje`.
base_ind <- dplyr::filter(largo, familia == FAMILIA_ALCANCE)

log_msg(sprintf("Filas familia '%s': %d (de %d totales).",
                FAMILIA_ALCANCE, nrow(base_ind), nrow(largo)),
        "INFO", "36_contexto")

# --- Derivacion de las 15 columnas del contrato -----------------------------
# eje_etiqueta desde INDICADOR_LABELS (glosa del productor; contrato §4).
contexto <- base_ind |>
  dplyr::mutate(
    rbd              = as.character(rbd),
    anio             = as.integer(agno),
    eje              = as.character(id_indicador),
    eje_etiqueta     = unname(INDICADOR_LABELS[as.character(id_indicador)]),
    segmento         = as.character(grado),
    escala           = ESCALA_IDPS,
    valor            = as.double(prom),
    desvio_gse       = as.double(difgru),
    mejora_sobre_gse = bandera_a_mejora(sigdifgru),
    mejora_ano_ano   = bandera_a_mejora(sigdif),
    cod_grupo        = as.character(cod_grupo),
    proyecto_origen  = PROYECTO_ORIGEN,
    periodo          = PERIODO_CORRIDA,
    fecha_calculo    = FECHA_CORRIDA,
    version_contrato = VERSION_CONTRATO
  )

# --- Guarda: glosa completa (eje_etiqueta nunca NA; §3 no admite nulos) ------
ids_sin_glosa <- sort(unique(base_ind$id_indicador[
  is.na(unname(INDICADOR_LABELS[as.character(base_ind$id_indicador)]))
]))
if (length(ids_sin_glosa) > 0) {
  stop("id_indicador sin glosa en INDICADOR_LABELS: ",
       paste(ids_sin_glosa, collapse = ", "),
       ". eje_etiqueta no puede ser NA (contrato §3/§4).")
}

# --- Regla de exposicion (🔒 §2): solo filas con alguna mejora TRUE ----------
contexto <- dplyr::filter(contexto, mejora_sobre_gse | mejora_ano_ano)

# --- Seleccion y orden EXACTO de columnas (contrato §3) ----------------------
contexto <- contexto[, COLS_CONTRATO]

# --- Guardas internas (fallan ruidosamente antes de escribir) ---------------
stopifnot(
  "eje_etiqueta con NA"          = !anyNA(contexto$eje_etiqueta),
  "mejora_sobre_gse con NA"      = !anyNA(contexto$mejora_sobre_gse),
  "mejora_ano_ano con NA"        = !anyNA(contexto$mejora_ano_ano),
  "fila sin ninguna mejora"      =
    all(contexto$mejora_sobre_gse | contexto$mejora_ano_ano),
  "llave no unica"               =
    !any(duplicated(contexto[, c("rbd", "anio", "eje", "segmento")]))
)

# --- Escritura atomica (contrato §10), solo si cambio el contenido (s33r) ----
# Si el contenido es el mismo, el archivo vigente se conserva con sus metadatos
# (periodo y fecha_calculo dicen cuando se genero ese contenido) y el build no
# ensucia el arbol; con IDPS_CONTEXTO_FORZAR=1 se reescribe igual (s33t).
sin_cambios <- contenido_sin_cambios(RUTA_SALIDA, contexto)
if (sin_cambios && !FORZAR_ESCRITURA) {
  message(sprintf(
    "[36_contexto] Contenido sin cambios (salvo periodo y fecha_calculo): se conserva %s; no se reescribe.",
    fs::path_rel(RUTA_SALIDA, here::here())))
} else {
  if (FORZAR_ESCRITURA) {
    message(sprintf(
      "[36_contexto] IDPS_CONTEXTO_FORZAR=1: se reescribe %s (contenido sin periodo ni fecha_calculo: %s; periodo %s, fecha_calculo %s).",
      fs::path_rel(RUTA_SALIDA, here::here()),
      if (sin_cambios) "igual al vigente" else "distinto del vigente",
      PERIODO_CORRIDA, format(FECHA_CORRIDA)))
  }
  escribir_parquet_atomico(contexto, RUTA_SALIDA)

  log_msg(sprintf("OK: %d filas x %d columnas en %s.",
                  nrow(contexto), ncol(contexto),
                  fs::path_rel(RUTA_SALIDA, here::here())),
          "INFO", "36_contexto")
}
