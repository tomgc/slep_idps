# =============================================================================
# 10_utils/10_configuracion.R
# -----------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Rutas, constantes y resolucion de ubicaciones del proyecto.
#            RAMA A (proyecto publico): raiz unificada, datos versionados en
#            el repo. SIN variable de entorno ni data root externo
#            (POLITICA_PROYECTO.md, secciones 6.2 y 8.2).
# Fecha    : 2026-06-11
# -----------------------------------------------------------------------------
# GOBERNANZA A VERIFICAR AL ABRIR: confirmar que los xlsx idps*_rbd_* son
# agregados publicos por establecimiento (no bases por estudiante) y
# documentar la decision en 50_documentacion/activa/decisiones/. Si en algun
# punto entrara data por estudiante, el proyecto pasa a RAMA B (dos raices).
# =============================================================================

# --- Identificador del proyecto ---------------------------------------------
PROYECTO_ID <- "slep_idps"

# --- Rutas (Rama A: todo dentro del repo) -----------------------------------
ruta_insumos <- function(...) here::here("20_insumos", ...)
ruta_salidas <- function(...) here::here("40_salidas", ...)

# --- Constantes del dominio IDPS --------------------------------------------
# Comunas del SLEP Costa Central (homologar mayusculas/sin tildes al leer).
COMUNAS_SLEP_CC <- c("VINA DEL MAR", "CONCON", "QUINTERO", "PUCHUNCAVI")

# Region de referencia para comparacion (Valparaiso).
COD_REGION_REFERENCIA <- 5L

# Dependencia administrativa (cod_depe2, 4 categorias segun glosas Agencia).
# OJO: 4 = SLEP (no 3 categorias como en otros instrumentos).
DEPENDENCIAS <- c(
  "1" = "Municipal",
  "2" = "Particular subvencionado",
  "3" = "Particular pagado",
  "4" = "SLEP"
)

# Grupo socioeconomico (GSE) — segmentacion INVIOLABLE en todo output.
GSE_LABELS <- c(
  "1" = "Bajo",
  "2" = "Medio bajo",
  "3" = "Medio",
  "4" = "Medio alto",
  "5" = "Alto"
)

# Indicadores IDPS y sus dimensiones (id_indicador -> id_dimension).
INDICADOR_LABELS <- c(
  "1" = "Autoestima Academica y Motivacion Escolar",
  "2" = "Clima de Convivencia Escolar",
  "3" = "Participacion y Formacion Ciudadana",
  "4" = "Habitos de Vida Saludable"
)
INDICADOR_DIMENSIONES <- list(
  "1" = c(11L, 12L),
  "2" = c(21L, 22L, 23L),
  "3" = c(31L, 32L, 33L),
  "4" = c(41L, 42L, 43L)
)
