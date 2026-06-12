# ==============================================================================
# 32_censo_insumos.R
# ------------------------------------------------------------------------------
# Proposito : Censo exhaustivo de los insumos de datos IDPS (P5). Perfila las 3
#             familias de tablas (rbd / rbd_dim / niveles) para los 4 grados y
#             todos los anios disponibles. Deriva metadata del nombre de archivo,
#             la VALIDA contra el contenido real (agno y grado leidos del dato),
#             reporta n filas, columnas, % de NA en la columna de medida, y la
#             presencia de las llaves de segmentacion (cod_grupo, cod_depe2).
#             Produce el mapa de cobertura grado x anio x familia que alimenta
#             el pipeline (P6).
# Insumos   : 20_insumos/idps*.xlsx (27 tablas de datos; se excluyen glosas).
# Salidas   : 40_salidas/intermedios/censo_insumos.parquet (perfilado completo)
#             40_salidas/intermedios/censo_insumos.md       (reporte legible)
# Notas     : - La familia de "niveles" cambia de nombre por anio
#               (2023 'niveles', 2024 'rbd_niveles', 2025 'rbd_subdim_niveles');
#               el censo las normaliza a la familia logica 'niveles'.
#             - Los tipos declarados en las glosas NO son fiables (hay columnas
#               cruzadas); el censo lee los tipos reales del dato.
#             - 'niveles' NO trae cod_grupo: para segmentar por GSE habra que
#               unirla con 'rbd' por rbd x agno en P6 (se reporta aqui).
#             - 'prom' con NA por supresion se cuenta como faltante (aprendizaje
#               v01-4); jamas como cero.
# Autor     : Tomas G. Casanova
# Fecha     : 2026-06-11
# ==============================================================================

# ---- Auto-instalacion ----
.pkgs <- c("here", "fs", "readxl", "dplyr", "stringr", "purrr", "tibble", "tidyr", "arrow")
.faltan <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(.faltan)) install.packages(.faltan)

# ---- Paquetes ----
library(here)
library(fs)
library(readxl)
library(dplyr)
library(stringr)
library(purrr)
library(tibble)
library(tidyr)
library(arrow)

# ---- Rutas ----
dir_insumos     <- here::here("20_insumos")
dir_salida      <- here::here("40_salidas", "intermedios")
ruta_parquet    <- fs::path(dir_salida, "censo_insumos.parquet")
ruta_reporte    <- fs::path(dir_salida, "censo_insumos.md")
if (!fs::dir_exists(dir_salida)) fs::dir_create(dir_salida, recurse = TRUE)

# ---- Constantes ----
# Patron de nombre: idps{grado}{anio}_{resto}_{estado}.xlsx
# grado: 2m | 4b | 6b | 8b   anio: 4 digitos   estado: final | preliminar
PATRON_DATOS    <- "^idps(2m|4b|6b|8b)(\\d{4})_(.+)_(final|preliminar)$"

# Normalizacion de familia: el fragmento intermedio del nombre -> familia logica.
# Cualquier variante que contenga 'subdim_niveles', 'rbd_niveles' o 'niveles'
# colapsa a 'niveles'. 'rbd_dim' -> 'rbd_dim'. El resto ('rbd') -> 'rbd'.
clasificar_familia <- function(fragmento) {
  dplyr::case_when(
    stringr::str_detect(fragmento, "niveles")        ~ "niveles",
    stringr::str_detect(fragmento, "rbd_dim|^dim")   ~ "rbd_dim",
    TRUE                                              ~ "rbd"
  )
}

# Columna de medida por familia (donde se mide % de NA por supresion).
medida_por_familia <- function(familia) {
  dplyr::case_when(
    familia == "niveles" ~ "niv_bajo_por",  # niveles no tiene prom
    TRUE                 ~ "prom"
  )
}

# Llaves de segmentacion que se verifica esten presentes.
LLAVES_SEGMENTACION <- c("cod_grupo", "cod_depe2", "id_indicador", "id_dimension",
                         "id_subdimension", "agno", "grado", "rbd")

# ---- Funciones ----

# Deriva metadata del nombre del archivo (sin tocar el contenido).
parsear_nombre <- function(nombre_sin_ext) {
  m <- stringr::str_match(nombre_sin_ext, PATRON_DATOS)
  tibble::tibble(
    grado_nombre  = m[, 2],
    anio_nombre   = as.integer(m[, 3]),
    fragmento     = m[, 4],
    estado        = m[, 5],
    familia       = clasificar_familia(m[, 4])
  )
}

# Perfila un archivo: lee completo, valida nombre vs contenido, resume.
perfilar_archivo <- function(ruta) {
  nombre <- fs::path_ext_remove(fs::path_file(ruta))
  meta   <- parsear_nombre(nombre)

  # Lectura completa (perfilado exacto: n filas y NA reales).
  datos <- tryCatch(
    readxl::read_excel(ruta, guess_max = 100000),
    error = function(e) {
      message("ERROR leyendo ", nombre, ": ", conditionMessage(e))
      NULL
    }
  )
  if (is.null(datos)) {
    return(dplyr::mutate(meta, archivo = nombre, error = TRUE))
  }

  cols <- names(datos)
  col_medida <- medida_por_familia(meta$familia)

  # Validacion nombre vs contenido: agno y grado reales desde el dato.
  agnos_dato  <- if ("agno" %in% cols) sort(unique(datos[["agno"]])) else NA_integer_
  grado_dato  <- if ("grado" %in% cols) {
    g <- unique(datos[["grado"]])
    paste(g[!is.na(g)], collapse = "|")
  } else NA_character_

  # % NA en la columna de medida (supresion). La medida puede venir como texto
  # (cadena) por las marcas; se cuenta NA y tambien valores no numericos.
  pct_na_medida <- if (col_medida %in% cols) {
    v <- datos[[col_medida]]
    v_num <- suppressWarnings(as.numeric(as.character(v)))
    round(100 * mean(is.na(v_num)), 2)
  } else NA_real_

  tibble::tibble(
    archivo          = nombre,
    grado            = meta$grado_nombre,
    anio_nombre      = meta$anio_nombre,
    anio_dato_min    = suppressWarnings(min(agnos_dato, na.rm = TRUE)),
    anio_dato_max    = suppressWarnings(max(agnos_dato, na.rm = TRUE)),
    grado_dato       = grado_dato,
    familia          = meta$familia,
    estado           = meta$estado,
    n_filas          = nrow(datos),
    n_cols           = length(cols),
    col_medida       = col_medida,
    pct_na_medida    = pct_na_medida,
    tiene_cod_grupo  = "cod_grupo" %in% cols,
    tiene_cod_depe2  = "cod_depe2" %in% cols,
    tiene_id_dim     = "id_dimension" %in% cols,
    tiene_id_subdim  = "id_subdimension" %in% cols,
    # Coherencia nombre vs dato: el anio del nombre cae dentro del rango del dato.
    anio_coherente   = !is.na(meta$anio_nombre) &&
                       meta$anio_nombre >= suppressWarnings(min(agnos_dato, na.rm = TRUE)) &&
                       meta$anio_nombre <= suppressWarnings(max(agnos_dato, na.rm = TRUE)),
    columnas         = paste(cols, collapse = ", "),
    error            = FALSE
  )
}

# ---- Flujo principal ----

# Inventario: solo tablas de datos (excluir glosas y archivos auxiliares).
archivos <- fs::dir_ls(dir_insumos, glob = "*.xlsx", type = "file") |>
  fs::path_file() |>
  (\(x) x[stringr::str_detect(x, "^idps")])() |>
  (\(x) x[!stringr::str_detect(x, "GLOSAS|glosa")])() |>
  (\(x) fs::path(dir_insumos, x))()

message("Archivos de datos a perfilar: ", length(archivos))

# Perfilado completo de cada archivo.
censo <- purrr::map_dfr(archivos, perfilar_archivo)

# Validacion de integridad: reportar incoherencias nombre vs dato.
incoherentes <- dplyr::filter(censo, !error & !anio_coherente)
if (nrow(incoherentes) > 0) {
  warning("Archivos con anio de nombre fuera del rango del dato: ",
          paste(incoherentes$archivo, collapse = ", "))
}

# Mapa de cobertura grado x anio x familia (presencia/ausencia).
cobertura <- censo |>
  dplyr::filter(!error) |>
  dplyr::distinct(grado, anio_nombre, familia) |>
  dplyr::mutate(presente = "X") |>
  tidyr::pivot_wider(
    names_from = familia,
    values_from = presente,
    values_fill = "-"
  ) |>
  dplyr::arrange(grado, anio_nombre)

# ---- Exportacion ----

# Parquet con el perfilado completo (para reuso programatico en P6).
arrow::write_parquet(censo, ruta_parquet)

# Reporte .md legible.
con <- file(ruta_reporte, open = "w", encoding = "UTF-8")
writeLines(c(
  "# Censo de insumos IDPS (P5)",
  "",
  paste0("- Fecha: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
  paste0("- Archivos de datos perfilados: ", nrow(censo)),
  paste0("- Errores de lectura: ", sum(censo$error)),
  "",
  "## Mapa de cobertura grado x anio x familia",
  ""
), con)

# Tabla de cobertura en markdown.
cob_cols <- names(cobertura)
writeLines(paste0("| ", paste(cob_cols, collapse = " | "), " |"), con)
writeLines(paste0("|", paste(rep("---", length(cob_cols)), collapse = "|"), "|"), con)
for (i in seq_len(nrow(cobertura))) {
  fila <- vapply(cobertura[i, ], as.character, character(1))
  writeLines(paste0("| ", paste(fila, collapse = " | "), " |"), con)
}

writeLines(c("", "## Perfilado por archivo", ""), con)
detalle <- censo |>
  dplyr::filter(!error) |>
  dplyr::select(archivo, grado, anio_nombre, familia, estado, n_filas, n_cols,
                col_medida, pct_na_medida, tiene_cod_grupo, tiene_cod_depe2,
                grado_dato, anio_coherente) |>
  dplyr::arrange(familia, grado, anio_nombre)

det_cols <- names(detalle)
writeLines(paste0("| ", paste(det_cols, collapse = " | "), " |"), con)
writeLines(paste0("|", paste(rep("---", length(det_cols)), collapse = "|"), "|"), con)
for (i in seq_len(nrow(detalle))) {
  fila <- vapply(detalle[i, ], as.character, character(1))
  writeLines(paste0("| ", paste(fila, collapse = " | "), " |"), con)
}
close(con)

# ---- Resumen en consola ----
message("\n==== MAPA DE COBERTURA ====")
print(cobertura, n = Inf)
message("\n==== PERFILADO (resumen) ====")
print(
  dplyr::select(detalle, archivo, familia, grado, anio_nombre, estado,
                n_filas, pct_na_medida, tiene_cod_grupo, anio_coherente),
  n = Inf
)
message("\nParquet: ", ruta_parquet)
message("Reporte: ", ruta_reporte)
