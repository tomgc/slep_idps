# ==============================================================================
# 33_construir_catalogos.R
# ------------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Construye los catalogos que alimentan el motor:
#            (A) Catalogos territoriales desde el directorio oficial DEPURADO
#                (publico, sin RUT): comunas_chile, sleps_chile,
#                establecimientos_chile. Permiten filtrar el motor por comuna /
#                SLEP / region (la decision 2026-06-12 los usa solo como FILTRO,
#                nunca para agregar). Replica el patron de
#                slep_simce_adecuado/30_construir_auxiliares.R, omitiendo lo
#                especifico de SIMCE (rinde_simce, anexo).
#            (B) Catalogo jerarquico IDPS de 4 niveles (indicador / dimension /
#                subdimension / actor) desde el corpus conceptual, con los ids
#                numericos de la Agencia adjuntados por match de nombre. Marca
#                que subdimensiones tienen niveles (solo actor EST) y cuantos.
#
# Insumos  : 20_insumos/auxiliares/directorio_oficial_ee_publico.csv
#            20_insumos/auxiliares/listado_slep_2026.xlsx
#            20_insumos/auxiliares/referencias_idps/idps_corpus_conceptual.json
#            10_utils/10_configuracion.R (crosswalk texto<->id)
# Salidas  : 40_salidas/intermedios/comunas_chile.parquet
#            40_salidas/intermedios/sleps_chile.parquet
#            40_salidas/intermedios/establecimientos_chile.parquet
#            40_salidas/intermedios/catalogo_idps.parquet
#
# Nota gobernanza: se usa el directorio DEPURADO (_publico.csv), nunca el crudo
# (que trae RUT_SOSTENEDOR y no se versiona).
#
# Uso:
#   source(here::here("30_procesamiento", "33_construir_catalogos.R"))
# Convencion: paquetes prefijados; library() solo para here y fs.
# ==============================================================================

library(here)
library(fs)

source(here::here("10_utils", "10_utils.R"))
instalar_si_falta(c("readr", "readxl", "dplyr", "tidyr", "purrr", "tibble",
                    "stringr", "arrow", "jsonlite"))
source(here::here("10_utils", "10_configuracion.R"))

# Ultimo anio con datos vigente (corte del directorio): gobierna las ramas de
# traspaso de SLEP (igual que el madre).
ANIO_DATOS_VIGENTE <- 2025L

dir_out <- here::here("40_salidas", "intermedios")
if (!fs::dir_exists(dir_out)) fs::dir_create(dir_out, recurse = TRUE)

escribir_parquet_atomico <- function(df, nombre) {
  final <- fs::path(dir_out, nombre)
  tmp   <- fs::path(dir_out, paste0(nombre, ".tmp"))
  arrow::write_parquet(df, tmp)
  fs::file_move(tmp, final)
  invisible(final)
}


# ============================================================================
# PARTE A — Catalogos territoriales (desde el directorio publico)
# ============================================================================

message("[A1] Leyendo directorio oficial DEPURADO (publico)...")

ruta_dir <- here::here("20_insumos", "auxiliares", "directorio_oficial_ee_publico.csv")
df_dir <- readr::read_delim(
  ruta_dir, delim = ";",
  locale = readr::locale(encoding = "UTF-8", decimal_mark = ","),
  show_col_types = FALSE, progress = FALSE
)

cols_dir_req <- c("RBD", "NOM_RBD", "COD_COM_RBD", "NOM_COM_RBD",
                  "COD_REG_RBD", "NOM_REG_RBD_A", "COD_DEPE", "COD_DEPE2",
                  "MATRICULA", "ESTADO_ESTAB")
faltan_dir <- setdiff(cols_dir_req, names(df_dir))
stopifnot("Faltan columnas en el directorio publico" = length(faltan_dir) == 0)
message(sprintf("    OK: %d filas.", nrow(df_dir)))

# ---- comunas_chile.parquet ----
message("[A2] comunas_chile.parquet...")
df_comunas <- df_dir |>
  dplyr::filter(.data$ESTADO_ESTAB == 1, .data$MATRICULA == 1) |>
  dplyr::transmute(
    cod_com_rbd = as.character(COD_COM_RBD),
    nom_com_rbd = NOM_COM_RBD,
    cod_reg_rbd = as.character(COD_REG_RBD),
    nom_reg_rbd = dplyr::recode(as.character(COD_REG_RBD), !!!NOMBRES_REGION,
                                .default = NOM_REG_RBD_A)
  ) |>
  dplyr::distinct()
escribir_parquet_atomico(df_comunas, "comunas_chile.parquet")
message(sprintf("    OK: %d comunas.", nrow(df_comunas)))

# ---- establecimientos_chile.parquet ----
message("[A3] establecimientos_chile.parquet...")
df_estab <- df_dir |>
  dplyr::filter(.data$ESTADO_ESTAB == 1, .data$MATRICULA == 1) |>
  dplyr::transmute(
    rbd         = as.character(RBD),
    nom_rbd     = NOM_RBD,
    cod_com_rbd = as.character(COD_COM_RBD),
    nom_com_rbd = NOM_COM_RBD,
    cod_depe2   = as.character(COD_DEPE2)
  ) |>
  dplyr::distinct() |>
  dplyr::arrange(cod_com_rbd, nom_rbd)
escribir_parquet_atomico(df_estab, "establecimientos_chile.parquet")
message(sprintf("    OK: %d establecimientos.", nrow(df_estab)))

# ---- sleps_chile.parquet (dos ramas: traspasados / prospectivos) ----
message("[A4] sleps_chile.parquet...")
df_sleps_raw <- readxl::read_excel(
  here::here("20_insumos", "auxiliares", "listado_slep_2026.xlsx"),
  sheet = "Listado SLEP", col_types = "text"
)
cols_slep_req <- c("COD_SLEP", "NOMBRE_SLEP_FORMATO", "AGNO_TRASPASO_EDUC", "COD_COM_RBD")
stopifnot("Faltan columnas en listado_slep_2026.xlsx" =
            length(setdiff(cols_slep_req, names(df_sleps_raw))) == 0)

df_slep_comunas <- df_sleps_raw |>
  dplyr::transmute(
    cod_slep      = as.character(COD_SLEP),
    nombre_slep   = NOMBRE_SLEP_FORMATO,
    anio_traspaso = suppressWarnings(as.integer(AGNO_TRASPASO_EDUC)),
    cod_com_rbd   = as.character(COD_COM_RBD)
  ) |>
  dplyr::distinct()

comunas_traspasadas <- df_slep_comunas |>
  dplyr::filter(.data$anio_traspaso <= ANIO_DATOS_VIGENTE) |>
  dplyr::pull(cod_com_rbd) |> unique()
comunas_prospectivas <- df_slep_comunas |>
  dplyr::filter(.data$anio_traspaso == ANIO_DATOS_VIGENTE + 1L) |>
  dplyr::pull(cod_com_rbd) |> unique()

df_dir_slep <- df_dir |>
  dplyr::filter(.data$ESTADO_ESTAB == 1, .data$MATRICULA == 1) |>
  dplyr::mutate(cod_com_rbd = as.character(COD_COM_RBD)) |>
  dplyr::filter(
    (.data$COD_DEPE == 6 & .data$cod_com_rbd %in% comunas_traspasadas) |
      (.data$COD_DEPE %in% c(1, 2) & .data$cod_com_rbd %in% comunas_prospectivas)
  ) |>
  dplyr::transmute(cod_com_rbd = cod_com_rbd, rbd = as.character(RBD), nom_rbd = NOM_RBD)

df_sleps <- dplyr::inner_join(df_slep_comunas, df_dir_slep, by = "cod_com_rbd") |>
  dplyr::left_join(dplyr::select(df_comunas, cod_com_rbd, nom_com_rbd), by = "cod_com_rbd") |>
  dplyr::select(cod_slep, nombre_slep, anio_traspaso, cod_com_rbd, nom_com_rbd, rbd, nom_rbd) |>
  dplyr::arrange(cod_slep, cod_com_rbd, rbd)
stopifnot("Join SLEP x directorio devolvio 0 filas" = nrow(df_sleps) > 0)
escribir_parquet_atomico(df_sleps, "sleps_chile.parquet")
cc <- df_sleps |> dplyr::filter(nombre_slep == "Costa Central") |> dplyr::distinct(nom_com_rbd)
message(sprintf("    OK: %d SLEPs, %d establecimientos. Costa Central: %s.",
                dplyr::n_distinct(df_sleps$cod_slep), dplyr::n_distinct(df_sleps$rbd),
                paste(cc$nom_com_rbd, collapse = ", ")))


# ============================================================================
# PARTE B — Catalogo jerarquico IDPS (corpus + ids de la Agencia)
# ============================================================================
# El corpus es la fuente de la jerarquia, los actores y los niveles. Los ids
# numericos de la Agencia (id_indicador/id_dimension/id_subdimension) se
# adjuntan por MATCH DE NOMBRE contra las etiquetas oficiales de las glosas
# (id <-> label, transcritas abajo y verificadas contra el crosswalk de config).
# Solo las 22 subdimensiones de actor EST tienen id (aparecen en la familia
# 'niveles'); las de actor DOC/PAD no tienen niveles ni id (id = NA).

message("[B1] Catalogo jerarquico IDPS desde el corpus...")

# Normalizador para emparejar nombres (corpus es ASCII; glosas con tildes).
normalizar <- function(x) {
  x <- iconv(as.character(x), to = "ASCII//TRANSLIT")
  x <- tolower(trimws(x))
  gsub("\\s+", " ", x)
}

# Etiquetas oficiales de la Agencia por id (transcritas de glosas 2024/2025;
# ids tomados de CW_* en config). Indicador:
lbl_indicador <- c(
  "1" = "Autoestima Academica y Motivacion Escolar",
  "2" = "Clima de Convivencia Escolar",
  "3" = "Participacion y Formacion Ciudadana",
  "4" = "Habitos de Vida Saludable"
)
# Dimension (id_dimension -> label oficial):
lbl_dimension <- c(
  "11" = "Autopercepcion y autovaloracion academica", "12" = "Motivacion escolar",
  "21" = "Ambiente de respeto", "22" = "Ambiente organizado", "23" = "Ambiente seguro",
  "31" = "Participacion", "32" = "Vida democratica", "33" = "Sentido de pertenencia",
  "41" = "Habitos de vida activa", "42" = "Habitos alimenticios", "43" = "Habitos de autocuidado"
)
# Subdimension EST (id_subdimension -> label oficial):
lbl_subdim <- c(
  "111" = "Autovaloracion Academica", "112" = "Promocion de la Autovaloracion Academica",
  "121" = "Interes y disposicion al aprendizaje", "122" = "Promocion de la motivacion del aprendizaje",
  "211" = "Cohesion social entre estudiantes", "212" = "Apoyo y buen trato de los docentes",
  "221" = "Ambiente organizado para el aprendizaje", "222" = "Promocion de mecanismos constructivos de resolucion de conflictos",
  "231" = "Mecanismos de prevencion y accion ante la violencia", "232" = "Testimonios de violencia personal",
  "311" = "Participacion del estudiante", "312" = "Promocion de la participacion",
  "321" = "Expresion de opiniones", "322" = "Representacion democratica", "323" = "Promocion de la deliberacion democratica",
  "331" = "Identificacion con el establecimiento",
  "411" = "Actitud frente a la actividad fisica", "412" = "Promocion de la vida activa",
  "421" = "Actitud frente a la alimentacion", "422" = "Promocion de habitos alimenticios",
  "431" = "Actitud de autocuidado", "432" = "Promocion de conductas de autocuidado"
)
# Alias corpus -> etiqueta oficial (variantes_nombre del propio corpus).
alias_subdim <- c(
  "promocion de la motivacion al aprendizaje"  = "promocion de la motivacion del aprendizaje",
  "participacion"                              = "participacion del estudiante",
  "promocion de vida activa"                   = "promocion de la vida activa"
)

# Mapas normalizados label -> id.
map_ind <- setNames(names(lbl_indicador), normalizar(lbl_indicador))
map_dim <- setNames(names(lbl_dimension), normalizar(lbl_dimension))
map_sub <- setNames(names(lbl_subdim),    normalizar(lbl_subdim))

corpus <- jsonlite::read_json(
  here::here("20_insumos", "auxiliares", "referencias_idps", "idps_corpus_conceptual.json")
)

filas <- list()
for (ind in corpus$indicadores) {
  id_ind <- unname(map_ind[normalizar(ind$nombre)])   # NA si no calza
  if (is.na(id_ind)) stop("Indicador del corpus sin id: ", ind$nombre)
  for (dim in ind$dimensiones) {
    id_dim <- unname(map_dim[normalizar(dim$nombre)])
    if (is.na(id_dim)) stop("Dimension del corpus sin id: ", dim$nombre)
    for (sub in dim$subdimensiones) {
      nom_norm <- normalizar(sub$nombre)
      if (nom_norm %in% names(alias_subdim)) nom_norm <- unname(alias_subdim[nom_norm])
      id_sub <- unname(map_sub[nom_norm])              # NA si no es EST (sin niveles)
      actores <- paste(unlist(sub$actores), collapse = ", ")
      es_est  <- "EST" %in% unlist(sub$actores)
      nb <- if (!is.null(sub$n_niveles$basica)) as.integer(sub$n_niveles$basica) else NA_integer_
      nm <- if (!is.null(sub$n_niveles$media))  as.integer(sub$n_niveles$media)  else NA_integer_
      # Texto cualitativo por ciclo y nivel (corpus). NULL -> NA: subdimensiones
      # no-EST no tienen texto; en esquemas de 2 niveles el "Medio" no existe.
      # El 8b no selecciona ciclo (ciclo_texto=NA), asi que no recibe texto.
      dn <- sub$descripcion_niveles_subdimension
      txt <- function(ciclo, nivel) {
        v <- if (is.null(dn)) NULL else dn[[ciclo]][[nivel]]
        if (is.null(v)) NA_character_ else as.character(v)
      }
      filas[[length(filas) + 1]] <- tibble::tibble(
        id_indicador     = as.integer(id_ind),
        indicador_nombre = ind$nombre,
        indicador_definicion = if (is.null(ind$definicion)) NA_character_ else as.character(ind$definicion),
        id_dimension     = as.integer(id_dim),
        dimension_nombre = dim$nombre,
        dimension_definicion = if (is.null(dim$definicion)) NA_character_ else as.character(dim$definicion),
        id_subdimension  = if (is.na(id_sub)) NA_integer_ else as.integer(id_sub),
        subdimension_nombre = sub$nombre,
        definicion       = if (is.null(sub$definicion)) NA_character_ else as.character(sub$definicion),
        actores          = actores,
        tiene_niveles    = es_est,
        n_niveles_basica = nb,
        n_niveles_media  = nm,
        nivel_basica_bajo  = txt("basica", "Bajo"),
        nivel_basica_medio = txt("basica", "Medio"),
        nivel_basica_alto  = txt("basica", "Alto"),
        nivel_media_bajo   = txt("media", "Bajo"),
        nivel_media_medio  = txt("media", "Medio"),
        nivel_media_alto   = txt("media", "Alto")
      )
    }
  }
}
catalogo <- dplyr::bind_rows(filas)

# Validaciones: la jerarquia y el emparejamiento con la Agencia deben cerrar.
n_est <- sum(catalogo$tiene_niveles)
con_id <- !is.na(catalogo$id_subdimension)
n_con_id <- sum(con_id)
stopifnot(
  "El catalogo deberia tener 30 subdimensiones" = nrow(catalogo) == 30L,
  "Deberia haber 22 subdimensiones EST con niveles" = n_est == 22L,
  "Las 22 subdimensiones EST deben tener id de la Agencia" = n_con_id == 22L,
  "Toda subdimension con id debe ser EST" =
    all(catalogo$tiene_niveles[con_id]),
  "Ninguna subdimension no-EST debe tener id" =
    all(is.na(catalogo$id_subdimension[!catalogo$tiene_niveles])),
  "Coherencia centena id_subdimension = id_indicador" =
    all(catalogo$id_subdimension[con_id] %/% 100L == catalogo$id_indicador[con_id]),
  "Coherencia (centena+decena) id_subdimension = id_dimension" =
    all(catalogo$id_subdimension[con_id] %/% 10L == catalogo$id_dimension[con_id])
)
# Nota 8b: la distribucion numerica de niveles 8b se muestra, pero el texto
# cualitativo por ciclo NO existe para 8b en los documentos 2024/2025
# (decision sesion 6). Se documenta como atributo del catalogo.
attr(catalogo, "nota_8b") <- "8b: distribucion numerica disponible; sin texto de nivel por ciclo (decision sesion 6)."

# Toda subdimension EST debe traer texto de nivel (Alto) en basica y media.
est_rows <- catalogo[catalogo$tiene_niveles, ]
stopifnot(
  "Hay subdimensiones EST sin texto de nivel (basica o media)" =
    all(!is.na(est_rows$nivel_basica_alto) & !is.na(est_rows$nivel_media_alto))
)
n_2niv <- sum(est_rows$n_niveles_basica == 2L, na.rm = TRUE)

escribir_parquet_atomico(catalogo, "catalogo_idps.parquet")
message(sprintf("    OK: %d subdimensiones (%d EST con niveles e id, %d sin niveles).",
                nrow(catalogo), n_est, nrow(catalogo) - n_est))
message(sprintf("    Textos de nivel por ciclo: %d EST con texto basica+media; %d de 2 niveles (sin 'Medio').",
                nrow(est_rows), n_2niv))


# ============================================================================
# Resumen
# ============================================================================
message("")
message("=== 33_construir_catalogos.R: OK ===")
message(sprintf("  comunas_chile.parquet:          %d", nrow(df_comunas)))
message(sprintf("  establecimientos_chile.parquet: %d", nrow(df_estab)))
message(sprintf("  sleps_chile.parquet:            %d", nrow(df_sleps)))
message(sprintf("  catalogo_idps.parquet:          %d", nrow(catalogo)))
