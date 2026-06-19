# ==============================================================================
# 31_depurar_directorio_oficial.R
# ------------------------------------------------------------------------------
# Proposito : Depurar el directorio oficial de establecimientos (Mineduc),
#             eliminando columnas con datos personales identificables antes de
#             versionar el insumo. El CSV original NO se versiona (queda cubierto
#             por .gitignore); este script produce la version publica.
# Insumos   : 20_insumos/auxiliares/directorio_oficial_ee.csv (original, UTF-8,
#             delim ";", con columnas MRUN y RUT_SOSTENEDOR). El crudo viene en
#             UTF-8 (las comunas con tilde/enie traen los bytes C3xx); leerlo
#             como latin1 produciria doble codificacion al reescribir.
# Salidas   : 20_insumos/auxiliares/directorio_oficial_ee_publico.csv
#             (UTF-8, sin columnas personales; este SI se versiona).
# Gobernanza: Ley 21.719 (datos personales) y Condiciones de Uso Agencia de
#             Calidad. RUT_SOSTENEDOR es RUT de persona natural en sostenedores
#             privados; MRUN viene vacio. Ambas se eliminan en origen.
#             NOM_RBD (nombre de establecimiento) se conserva como insumo de
#             join interno: PROHIBIDO filtrarlo a cualquier output publicado.
# Autor     : Tomas G. Casanova
# Fecha     : 2026-06-11
# ==============================================================================

# ---- Auto-instalacion ----
.pkgs <- c("here", "readr", "dplyr")
.faltan <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(.faltan)) install.packages(.faltan)

# ---- Paquetes ----
library(here)
library(readr)
library(dplyr)

# ---- Rutas ----
ruta_origen  <- here::here("20_insumos", "auxiliares", "directorio_oficial_ee.csv")
ruta_destino <- here::here("20_insumos", "auxiliares", "directorio_oficial_ee_publico.csv")
ruta_tmp     <- paste0(ruta_destino, ".tmp")

# ---- Constantes ----
# Columnas con datos personales identificables: se eliminan en origen.
COLUMNAS_SENSIBLES <- c("MRUN", "RUT_SOSTENEDOR")

# ---- Flujo principal ----

# Lectura: origen en UTF-8 (verificado por bytes: las tildes vienen como C3xx),
# separador ";" (locale Mineduc).
directorio_crudo <- readr::read_delim(
  ruta_origen,
  delim = ";",
  locale = readr::locale(encoding = "UTF-8"),
  show_col_types = FALSE
)

# Validacion: confirmar que las columnas a eliminar existen antes de depurar.
faltantes <- setdiff(COLUMNAS_SENSIBLES, names(directorio_crudo))
if (length(faltantes)) {
  warning(
    "Columnas sensibles esperadas y no encontradas (revisar esquema de origen): ",
    paste(faltantes, collapse = ", ")
  )
}

# Depuracion: eliminar columnas sensibles (any_of tolera ausencias).
directorio_publico <- dplyr::select(
  directorio_crudo,
  -dplyr::any_of(COLUMNAS_SENSIBLES)
)

# Validacion post-depuracion: ninguna columna sensible debe sobrevivir.
sobrevivientes <- intersect(COLUMNAS_SENSIBLES, names(directorio_publico))
if (length(sobrevivientes)) {
  stop(
    "FALLO DE GOBERNANZA: columnas sensibles aun presentes tras la depuracion: ",
    paste(sobrevivientes, collapse = ", ")
  )
}

# Escritura atomica (write -> rename): UTF-8, separador ";" para conservar
# el formato de origen legible en Excel locale espanol.
readr::write_delim(directorio_publico, ruta_tmp, delim = ";")
file.rename(ruta_tmp, ruta_destino)

message(
  "Directorio depurado: ", ncol(directorio_crudo), " -> ",
  ncol(directorio_publico), " columnas. ",
  "Eliminadas: ", paste(COLUMNAS_SENSIBLES, collapse = ", "), ". ",
  "Escrito en: ", ruta_destino
)
