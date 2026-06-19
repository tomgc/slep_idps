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

# Nombres oficiales de region por codigo (para limpiar nom_reg_rbd).
NOMBRES_REGION <- c(
  "1" = "Tarapaca", "2" = "Antofagasta", "3" = "Atacama", "4" = "Coquimbo",
  "5" = "Valparaiso", "6" = "O'Higgins", "7" = "Maule", "8" = "Biobio",
  "9" = "La Araucania", "10" = "Los Lagos", "11" = "Aysen", "12" = "Magallanes",
  "13" = "Metropolitana", "14" = "Los Rios", "15" = "Arica y Parinacota",
  "16" = "Nuble"
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

# --- Grados evaluados y ciclo de reporte -------------------------------------
# Vigentes en documentacion 2024/2025: 4b, 6b, II medio (2m). El 8b solo
# figura en la metodologia de calculo 2016, pero hay datos reales 8b 2025:
# se incluye en radares y distribucion numerica (decision sesion 6).
GRADO_LABELS <- c(
  "4b" = "4° básico",
  "6b" = "6° básico",
  "8b" = "8° básico",
  "2m" = "II medio"
)

# Ciclo para SELECCIONAR el texto cualitativo de nivel (corpus): solo basica
# (4b/6b) y media (2m). El 8b NO tiene texto de nivel por ciclo en los
# documentos 2024/2025: su distribucion numerica se muestra, el texto no
# (decision sesion 6). Por eso 8b queda fuera de este mapa a proposito.
GRADO_CICLO_TEXTO <- c(
  "4b" = "basica",
  "6b" = "basica",
  "2m" = "media"
)

# --- Crosswalk de esquema por anio: texto (2022-2024) -> id numerico (2025) --
# La Agencia migro el identificador de indicador/dimension/subdimension de
# codigo de texto (ind/dim/sdim) a id numerico (id_indicador/id_dimension/
# id_subdimension) entre las ediciones 2024 y 2025. Para unir cualquier serie
# hay que homologar a un vocabulario canonico unico: se elige el ID NUMERICO
# (lo usan los datos 2025, el prototipo y este config).
#
# Provenance (NO deducido): los pares texto<->label y id<->label se leyeron de
# las glosas oficiales idps2m2024_GLOSAS_web_final.xlsx (hojas idps/dim_idps/
# idps_niveles, codigos de texto) e idps2m2025_GLOSAS_web_preliminar.xlsx
# (ids numericos), y se cruzaron POR LABEL. La estructura posicional del id
# (decena=indicador, unidad=orden de dimension; 3 digitos=ind+dim+subdim) se
# valido contra el set real de id_subdimension presente en los datos 2025
# (reproduce exactamente los 22 codigos EST, incluida la irregularidad 32->3
# y 33->1). Verificacion estructural adicional en 34_leer_normalizar_idps.R.
#
# OJO: el orden de la Agencia NO coincide con el del corpus en Habitos
# (41 = "Habitos de vida activa" = VA, no alimenticios). Por eso el crosswalk
# sale de la glosa, no del orden del corpus.
CW_INDICADOR <- c(
  "AM" = 1L, "CC" = 2L, "PF" = 3L, "HV" = 4L
)
CW_DIMENSION <- c(
  "AA" = 11L, "ME" = 12L,                 # 1 Autoestima
  "AR" = 21L, "AO" = 22L, "AS" = 23L,     # 2 Clima
  "PA" = 31L, "VD" = 32L, "SP" = 33L,     # 3 Participacion
  "VA" = 41L, "HA" = 42L, "AC" = 43L      # 4 Habitos
)
CW_SUBDIMENSION <- c(
  "AA" = 111L, "PA" = 112L,                            # 11 Autopercepcion
  "ID" = 121L, "PM" = 122L,                            # 12 Motivacion
  "CS" = 211L, "AB" = 212L,                            # 21 Ambiente de respeto
  "AO" = 221L, "PR" = 222L,                            # 22 Ambiente organizado
  "MP" = 231L, "TV" = 232L,                            # 23 Ambiente seguro
  "PE" = 311L, "PP" = 312L,                            # 31 Participacion
  "EP" = 321L, "RD" = 322L, "PD" = 323L,               # 32 Vida democratica
  "IE" = 331L,                                         # 33 Sentido de pertenencia
  "AF" = 411L, "PV" = 412L,                            # 41 Habitos de vida activa
  "AL" = 421L, "PH" = 422L,                            # 42 Habitos alimenticios
  "AC" = 431L, "PC" = 432L                             # 43 Habitos de autocuidado
)
