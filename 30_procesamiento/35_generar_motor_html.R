# ==============================================================================
# 35_generar_motor_html.R
# ------------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Genera el motor HTML autocontenido (P9) a partir de idps_largo y los
#            catalogos. Replica el mecanismo del madre slep_simce_adecuado
#            (JSON -> gzip -> base64 -> placeholders; D3 y pako inline; React por
#            CDN con SRI), adaptado al MODELO NUEVO (sin agregacion territorial):
#            el dato viaja por establecimiento-grado; GSE y territorio son
#            filtros/etiquetas; la comparacion contra el GSE es difgru/sigdifgru
#            (marca de desvio), nunca una linea de puntaje agregado.
#
# ALCANCE (decision base, a ratificar): se embebe solo la Region de Valparaiso
# (cod_reg_rbd == REGION_MOTOR), universo de comparacion natural del SLEP Costa
# Central. Es un FILTRO (no agregacion): difgru viene pre-calculado por fila y no
# se altera. Ampliar a todo Chile es una decision de tamano para el encargo 2.
#
# Insumos  : 40_salidas/intermedios/idps_largo.parquet, catalogo_idps.parquet,
#            comunas_chile.parquet, sleps_chile.parquet
#            30_procesamiento/35_motor_template.html, 10_utils/{d3,pako}.min.js
# Salida   : 40_salidas/motor_idps.html  (NO docs/ en este encargo)
#
# Uso: source(here::here("30_procesamiento","35_generar_motor_html.R"))
# Convencion: paquetes prefijados; library() solo para here y fs.
# ==============================================================================

library(here)
library(fs)

source(here::here("10_utils", "10_utils.R"))
instalar_si_falta(c("dplyr", "arrow", "jsonlite"))
source(here::here("10_utils", "10_configuracion.R"))

REGION_MOTOR <- "5"   # Valparaiso

# Paleta canonica de los 4 indicadores (madre / prototipo).
INDICADOR_COLORS <- c("1" = "#EE2D49", "2" = "#FFC92E", "3" = "#9BC93E", "4" = "#2A8FD9")
# Etiquetas cortas para los ejes del radar.
INDICADOR_CORTO  <- c("1" = "Autoestima", "2" = "Convivencia",
                      "3" = "Participacion", "4" = "Habitos")


# ============================================================================
# Bloque 1 — Cargar y acotar a la region del motor
# ============================================================================
message("[1] Cargando insumos y acotando a region ", REGION_MOTOR, "...")

P   <- arrow::read_parquet(here::here("40_salidas", "intermedios", "idps_largo.parquet"))
CAT <- arrow::read_parquet(here::here("40_salidas", "intermedios", "catalogo_idps.parquet"))
COM <- arrow::read_parquet(here::here("40_salidas", "intermedios", "comunas_chile.parquet"))
SLE <- arrow::read_parquet(here::here("40_salidas", "intermedios", "sleps_chile.parquet"))

P <- dplyr::filter(P, .data$cod_reg_rbd == REGION_MOTOR)
stopifnot("Sin filas para la region del motor" = nrow(P) > 0)
rbds_region <- sort(unique(P$rbd))
message(sprintf("    %d filas, %d establecimientos en region %s.",
                nrow(P), length(rbds_region), REGION_MOTOR))


# ============================================================================
# Bloque 2 — Catalogos conceptuales
# ============================================================================
message("[2] Construyendo catalogos y datos...")

indicadores_lst <- lapply(as.character(1:4), function(id) {
  list(id = as.integer(id), nombre = unname(INDICADOR_LABELS[id]),
       corto = unname(INDICADOR_CORTO[id]), color = unname(INDICADOR_COLORS[id]))
})

dimensiones_lst <- CAT |>
  dplyr::distinct(id_dimension, id_indicador, dimension_nombre) |>
  dplyr::arrange(id_dimension) |>
  dplyr::transmute(id = as.integer(id_dimension), id_ind = as.integer(id_indicador),
                   nombre = dimension_nombre)

# Subdimensiones: jerarquia + actor + n_niveles + textos por ciclo (solo EST).
subdim_lst <- lapply(seq_len(nrow(CAT)), function(i) {
  r <- CAT[i, ]
  txt_ciclo <- function(b, m, a) {
    out <- list(bajo = r[[b]], medio = r[[m]], alto = r[[a]])
    out[!is.na(out)]  # quita niveles inexistentes (Medio en esquemas de 2)
  }
  base <- list(
    id_ind = as.integer(r$id_indicador),
    id_dim = as.integer(r$id_dimension),
    nombre = r$subdimension_nombre,
    actores = r$actores,
    tiene_niveles = isTRUE(r$tiene_niveles)
  )
  if (!is.na(r$id_subdimension)) base$id <- as.integer(r$id_subdimension)
  if (isTRUE(r$tiene_niveles)) {
    base$n_niveles <- list(basica = r$n_niveles_basica, media = r$n_niveles_media)
    base$texto <- list(basica = txt_ciclo("nivel_basica_bajo","nivel_basica_medio","nivel_basica_alto"),
                       media  = txt_ciclo("nivel_media_bajo","nivel_media_medio","nivel_media_alto"))
  }
  base
})

# Comunas y SLEPs de la region (filtros territoriales).
comunas_lst <- COM |>
  dplyr::filter(.data$cod_reg_rbd == REGION_MOTOR) |>
  dplyr::transmute(cod = cod_com_rbd, nom = nom_com_rbd) |>
  dplyr::arrange(nom)

sleps_region <- SLE |>
  dplyr::filter(.data$rbd %in% rbds_region) |>
  dplyr::distinct(cod_slep, nombre_slep, cod_com_rbd)
sleps_lst <- sleps_region |>
  dplyr::distinct(cod_slep, nombre_slep) |>
  dplyr::arrange(nombre_slep)
# Comunas foco = SLEP Costa Central.
comunas_foco <- sort(unique(SLE$cod_com_rbd[SLE$nombre_slep == "Costa Central"]))
# Mapa rbd -> cod_slep (para el filtro por SLEP en el cliente).
estab_slep <- SLE |>
  dplyr::filter(.data$rbd %in% rbds_region) |>
  dplyr::distinct(rbd, cod_slep)

# Catalogo de establecimientos de la region (atributos canonicos).
estab_lst <- P |>
  dplyr::distinct(rbd, nom_rbd, cod_com_rbd, nom_com_rbd, cod_depe2) |>
  dplyr::left_join(estab_slep, by = "rbd") |>
  dplyr::transmute(rbd, nom = nom_rbd, cod_com = cod_com_rbd,
                   nom_com = nom_com_rbd, cod_depe2, cod_slep) |>
  dplyr::arrange(nom_com, nom)


# ============================================================================
# Bloque 3 — Bloques de datos columnares por familia
# ============================================================================
# roster: una fila por (rbd, grado, agno) con su GSE -> arma la grilla.
roster <- P |>
  dplyr::filter(.data$familia == "indicador") |>
  dplyr::distinct(rbd, grado, agno, cod_grupo, cod_depe2)
roster_lst <- list(
  rows = nrow(roster), rbd = roster$rbd, grado = roster$grado,
  agno = as.integer(roster$agno), gse = roster$cod_grupo, depe2 = roster$cod_depe2
)

ind <- P |> dplyr::filter(.data$familia == "indicador") |>
  dplyr::arrange(rbd, grado, agno, id_indicador)
ind_lst <- list(
  rows = nrow(ind), rbd = ind$rbd, grado = ind$grado, agno = as.integer(ind$agno),
  ind = as.integer(ind$id_indicador), prom = round(ind$prom, 1),
  dif = ind$dif, sigdif = ind$sigdif, difgru = ind$difgru, sigdifgru = ind$sigdifgru
)

dim <- P |> dplyr::filter(.data$familia == "dimension") |>
  dplyr::arrange(rbd, grado, agno, id_dimension)
dim_lst <- list(
  rows = nrow(dim), rbd = dim$rbd, grado = dim$grado, agno = as.integer(dim$agno),
  dim = as.integer(dim$id_dimension), prom = round(dim$prom, 1),
  dif = dim$dif, sigdif = dim$sigdif
)

niv <- P |> dplyr::filter(.data$familia == "niveles") |>
  dplyr::arrange(rbd, grado, agno, id_subdimension)
niv_lst <- list(
  rows = nrow(niv), rbd = niv$rbd, grado = niv$grado, agno = as.integer(niv$agno),
  sub = as.integer(niv$id_subdimension),
  bajo = round(niv$niv_bajo_por, 1), medio = round(niv$niv_medio_por, 1),
  alto = round(niv$niv_alto_por, 1)
)

# Cobertura real de anios por grado (para deshabilitar evolucion donde no hay serie).
grado_anios <- lapply(names(GRADO_LABELS), function(g) {
  a <- sort(unique(roster$agno[roster$grado == g]))
  if (length(a) == 0) NULL else as.integer(a)
})
names(grado_anios) <- names(GRADO_LABELS)
grado_anios <- grado_anios[!vapply(grado_anios, is.null, logical(1))]

# Forzar UTF-8 en las etiquetas de grado (traen ° y á; en locale C R las marca
# "unknown" y jsonlite las degradaria a mojibake). El archivo fuente es UTF-8.
grados_lbl <- GRADO_LABELS[names(grado_anios)]
Encoding(grados_lbl) <- "UTF-8"

meta <- list(
  fecha_generacion = format(Sys.Date()),
  region_motor = REGION_MOTOR,
  region_nombre = unname(NOMBRES_REGION[REGION_MOTOR]),
  grados = as.list(grados_lbl),
  grado_anios = grado_anios,
  anios_preliminar = I(2025L),
  gse = names(GSE_LABELS),
  gse_labels = as.list(GSE_LABELS),
  depe2 = names(DEPENDENCIAS),
  depe2_labels = as.list(DEPENDENCIAS),
  comunas_foco = comunas_foco,
  nota_8b = "8b: distribucion numerica disponible; sin texto cualitativo de nivel (decision sesion 6)."
)

json_root <- list(
  meta = meta, indicadores = indicadores_lst, dimensiones = dimensiones_lst,
  subdimensiones = subdim_lst, comunas = comunas_lst, sleps = sleps_lst,
  establecimientos = estab_lst, roster = roster_lst,
  ind = ind_lst, dim = dim_lst, niv = niv_lst
)

json_str <- jsonlite::toJSON(json_root, auto_unbox = TRUE, na = "null",
                             dataframe = "rows", digits = NA)
json_str <- enc2utf8(json_str)
bytes_plano <- nchar(json_str, type = "bytes")
message(sprintf("    JSON: %.2f MB sin comprimir.", bytes_plano / 1e6))

json_gzip <- memCompress(charToRaw(json_str), type = "gzip")
json_b64  <- gsub("\n", "", jsonlite::base64_enc(json_gzip), fixed = TRUE)
message(sprintf("    JSON comprimido (gzip+base64): %.2f MB (%.1f%% del plano).",
                nchar(json_b64, type = "bytes") / 1e6,
                100 * nchar(json_b64, type = "bytes") / bytes_plano))


# ============================================================================
# Bloque 4 — Plantilla + libs inline; reemplazo de placeholders
# ============================================================================
message("[3] Plantilla, D3 y pako...")

plantilla_path <- here::here("30_procesamiento", "35_motor_template.html")
d3_path   <- here::here("10_utils", "d3.min.js")
pako_path <- here::here("10_utils", "pako.min.js")
for (p in c(plantilla_path, d3_path, pako_path)) {
  if (!file.exists(p)) stop("Falta archivo requerido: ", p)
}
plantilla <- paste(readLines(plantilla_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
d3_code   <- paste(readLines(d3_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
pako_code <- paste(readLines(pako_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")

for (ph in c("__D3_INLINE__", "__PAKO_INLINE__", "__JSON_DATA__")) {
  if (!grepl(ph, plantilla, fixed = TRUE)) stop("La plantilla no contiene ", ph)
}

message("[4] Construyendo HTML final...")
html <- sub("__D3_INLINE__",   d3_code,   plantilla, fixed = TRUE)
html <- sub("__PAKO_INLINE__", pako_code, html,      fixed = TRUE)
html <- sub("__JSON_DATA__",   json_b64,  html,      fixed = TRUE)

ruta_salida <- here::here("40_salidas", "motor_idps.html")
con <- file(ruta_salida, open = "wb", encoding = "UTF-8")
writeBin(charToRaw(enc2utf8(html)), con)
close(con)
tamano_kb <- file.info(ruta_salida)$size / 1024

n_roster <- roster_lst$rows
rm(json_str, json_gzip, json_b64, html, d3_code, pako_code, plantilla); gc(verbose = FALSE)


# ============================================================================
# Bloque 5 — Resumen
# ============================================================================
message("")
message("=== 35_generar_motor_html.R: OK ===")
message(sprintf("  Region:           %s (%s)", REGION_MOTOR, unname(NOMBRES_REGION[REGION_MOTOR])))
message(sprintf("  Establecimientos: %d", nrow(estab_lst)))
message(sprintf("  Unidades grilla:  %d (rbd x grado x anio)", n_roster))
message(sprintf("  Filas ind/dim/niv:%d / %d / %d", ind_lst$rows, dim_lst$rows, niv_lst$rows))
message(sprintf("  Peso HTML:        %.0f KB", tamano_kb))
message(sprintf("  Salida:           %s", fs::path_rel(ruta_salida, here::here())))
