# ==============================================================================
# 34_leer_normalizar_idps.R
# ------------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Corazon del motor (P6). Lee las 3 familias de tablas IDPS de la
#            Agencia (rbd / rbd_dim / niveles) para los 4 grados (2m, 4b, 6b,
#            8b) y los anios disponibles (2022-2025), HOMOLOGA el esquema que
#            migra de codigo de texto (ind/dim/sdim, 2022-2024) a id numerico
#            (id_indicador/id_dimension/id_subdimension, 2025), TRAE el GSE y la
#            dependencia a la familia 'niveles' (que no los publica) via join
#            por rbd x agno x grado, y emite un unico parquet largo por
#            establecimiento-grado. SIN agregacion territorial (decision
#            2026-06-12: el motor muestra el dato al nivel en que la Agencia lo
#            publica, el establecimiento).
#
# Insumos  : 20_insumos/idps*.xlsx (tablas de datos; excluye glosas).
#            10_utils/10_configuracion.R (crosswalk texto<->id, grados, ciclos).
# Salidas  : 40_salidas/intermedios/idps_largo.parquet
#
# Esquema de salida (largo; una fila por establecimiento x grado x anio x
# nivel-de-jerarquia, con discriminador 'familia'):
#   rbd, agno, grado, ciclo_texto, preliminar, familia,
#   id_indicador, id_dimension, id_subdimension,
#   cod_grupo, cod_depe2,
#   cod_com_rbd, nom_com_rbd, cod_reg_rbd, nom_reg_rbd, cod_pro_rbd, nom_rbd,
#   prom, dif, sigdif, difgru, sigdifgru, mdif, mdifgru,
#   niv_bajo_por, niv_medio_por, niv_alto_por,
#   niv_mbajo_por, niv_mmedio_por, niv_malto_por
#
# Invariantes respetados (decision + traspaso v04):
#   - Cero agregacion: cada fila es dato crudo de un RBD. No se promedia ni
#     pondera entre establecimientos.
#   - Lee, no deriva: prom de indicador (rbd) y de dimension (rbd_dim) son
#     medidas INDEPENDIENTES; la distribucion es niv_*_por (niveles); la
#     significancia es dif/sigdif (vs evaluacion anterior) y difgru/sigdifgru
#     (vs mismo GSE). Todas se LEEN tal como vienen.
#   - Supresion: NA en la medida = resguardo estadistico, NUNCA cero.
#   - Llaves character; grado y agno desde el NOMBRE de archivo (la columna
#     'grado' del dato es inconsistente: "2" en 2022-2023 vs "2m" en 2024-2025).
#
# Uso:
#   source(here::here("30_procesamiento", "34_leer_normalizar_idps.R"))
#
# Convencion: paquetes prefijados; library() solo para here y fs.
# ==============================================================================

library(here)
library(fs)

# Bootstrapping para correr standalone (el orquestador ya hace esto antes).
source(here::here("10_utils", "10_utils.R"))
instalar_si_falta(c("readr", "readxl", "dplyr", "stringr", "purrr", "tibble", "tidyr", "arrow"))

# Constantes y crosswalk canonico (idempotente si el orquestador ya lo cargo).
source(here::here("10_utils", "10_configuracion.R"))


# ============================================================================
# Bloque 1 — Manifiesto de archivos de datos
# ============================================================================

message("[1] Construyendo manifiesto de xlsx IDPS...")

# Patron de nombre: idps{grado}{anio}_{fragmento}_{estado}.xlsx
PATRON_DATOS <- "^idps(2m|4b|6b|8b)(\\d{4})_(.+)_(final|preliminar)$"

# Historico 2014-2019 (P5 fase 3): nomenclatura canonica fijada en la fase 2,
# idps{grado}{anio}_rbd_historico.{xls,xlsx} en 20_insumos/historico/. Es formato
# ANCHO (indicador/dimension como columnas), se lee con su propia rama (Bloque 3b).
PATRON_HISTORICO <- "^idps(2m|4b|6b|8b)(\\d{4})_rbd_historico$"

# Fragmento intermedio del nombre -> familia logica. La de niveles cambia de
# nombre por anio (2023 *_niveles, 2024 *_rbd_niveles, 2025 *_rbd_subdim_niveles):
# se detecta por substring, jamas por nombre exacto (aprendizaje v02-7).
clasificar_familia <- function(fragmento) {
  ifelse(grepl("niveles", fragmento), "niveles",
         ifelse(grepl("rbd_dim|^dim", fragmento), "rbd_dim", "rbd"))
}

# --- Manifiesto MODERNO (raiz, 2022-2025): exactamente como antes ---
archivos <- fs::dir_ls(here::here("20_insumos"), glob = "*.xlsx", type = "file") |>
  fs::path_file() |>
  (\(x) x[grepl("^idps", x) & !grepl("GLOSAS|glosa", x)])()

manifiesto_moderno <- lapply(archivos, function(nm) {
  base <- fs::path_ext_remove(nm)
  m <- stringr::str_match(base, PATRON_DATOS)
  tibble::tibble(
    archivo = nm,
    grado   = m[, 2],
    anio    = as.integer(m[, 3]),
    familia = clasificar_familia(m[, 4]),
    estado  = m[, 5],
    regimen = "moderno"
  )
}) |> dplyr::bind_rows()

stopifnot(
  "Algun xlsx no cumple el patron idps<grado><anio>_..._<estado>" =
    !any(is.na(manifiesto_moderno$grado) | is.na(manifiesto_moderno$anio) |
           is.na(manifiesto_moderno$estado))
)

# --- Manifiesto HISTORICO (20_insumos/historico/, 2014-2019; .xls y .xlsx) ---
# Segundo dir_ls propio: NO recursivo (no entra a glosas/), sin tocar el moderno.
archivos_hist <- fs::dir_ls(here::here("20_insumos", "historico"), type = "file",
                            regexp = "\\.(xls|xlsx)$") |>
  fs::path_file() |>
  (\(x) x[grepl("^idps", x) & !grepl("GLOSAS|glosa", x)])()

manifiesto_hist <- lapply(archivos_hist, function(nm) {
  base <- fs::path_ext_remove(nm)
  m <- stringr::str_match(base, PATRON_HISTORICO)
  tibble::tibble(
    archivo = nm,
    grado   = m[, 2],
    anio    = as.integer(m[, 3]),
    familia = "rbd",        # primaria; el lector 3b deriva indicador (+ dim 2018)
    estado  = "final",      # el historico es dato final, no preliminar
    regimen = "historico"
  )
}) |> dplyr::bind_rows()

stopifnot(
  "Algun historico no cumple idps<grado><anio>_rbd_historico" =
    nrow(manifiesto_hist) == 0 ||
    !any(is.na(manifiesto_hist$grado) | is.na(manifiesto_hist$anio))
)

# Hook de verificacion (P5 fase 3): idps_solo_moderno=TRUE excluye el historico
# para aislar el efecto del dato moderno (4b2024) en la verificacion bit-a-bit.
# Default FALSE: operacion normal lee moderno + historico.
if (isTRUE(getOption("idps_solo_moderno", FALSE))) manifiesto_hist <- manifiesto_hist[0, ]

manifiesto <- dplyr::bind_rows(manifiesto_moderno, manifiesto_hist)

message(sprintf("    OK: %d archivos (moderno=%d [rbd=%d, rbd_dim=%d, niveles=%d]; historico=%d).",
                nrow(manifiesto), nrow(manifiesto_moderno),
                sum(manifiesto_moderno$familia == "rbd"),
                sum(manifiesto_moderno$familia == "rbd_dim"),
                sum(manifiesto_moderno$familia == "niveles"),
                nrow(manifiesto_hist)))


# ============================================================================
# Bloque 2 — Helpers de coercion y homologacion de codigos
# ============================================================================

# Numero defensivo: normaliza coma decimal antes de as.numeric.
to_num <- function(x) {
  suppressWarnings(as.numeric(gsub(",", ".", as.character(x), fixed = TRUE)))
}

# Columna presente -> coercion; ausente -> vector NA del tipo y largo correcto.
col_o_na <- function(df, nm, tipo = c("chr", "num", "int"), n = nrow(df)) {
  tipo <- match.arg(tipo)
  if (nm %in% names(df)) {
    x <- df[[nm]]
    switch(tipo,
           chr = as.character(x),
           num = to_num(x),
           int = as.integer(round(to_num(x))))
  } else {
    switch(tipo,
           chr = rep(NA_character_, n),
           num = rep(NA_real_, n),
           int = rep(NA_integer_, n))
  }
}

# Mapea codigos de texto a id numerico via crosswalk; falla si aparece un
# codigo que el crosswalk no conoce (no homologar a ciegas).
map_codigo <- function(valores, crosswalk, etiqueta, archivo) {
  v <- as.character(valores)
  ids <- unname(crosswalk[v])
  desconocidos <- unique(v[is.na(ids) & !is.na(v)])
  if (length(desconocidos) > 0) {
    stop(sprintf("%s: codigos de %s fuera del crosswalk: %s",
                 archivo, etiqueta, paste(desconocidos, collapse = ", ")))
  }
  as.integer(ids)
}

# id de indicador/dimension/subdimension homologado: usa el id numerico si el
# archivo ya lo trae (esquema 2025), si no mapea el codigo de texto.
homologar_id <- function(df, col_id, col_txt, crosswalk, etiqueta, archivo) {
  if (col_id %in% names(df)) {
    as.integer(round(to_num(df[[col_id]])))
  } else if (col_txt %in% names(df)) {
    map_codigo(df[[col_txt]], crosswalk, etiqueta, archivo)
  } else {
    stop(sprintf("%s: faltan %s y %s para homologar %s",
                 archivo, col_id, col_txt, etiqueta))
  }
}


# ============================================================================
# Bloque 3 — Lectura y normalizacion de un archivo a esquema canonico
# ============================================================================

# Columnas canonicas del parquet largo (orden final).
COLS_CANONICAS <- c(
  "rbd", "agno", "grado", "ciclo_texto", "preliminar", "familia",
  "id_indicador", "id_dimension", "id_subdimension",
  "cod_grupo", "cod_depe2",
  "cod_com_rbd", "nom_com_rbd", "cod_reg_rbd", "nom_reg_rbd", "cod_pro_rbd", "nom_rbd",
  "prom", "dif", "sigdif", "difgru", "sigdifgru", "mdif", "mdifgru",
  "niv_bajo_por", "niv_medio_por", "niv_alto_por",
  "niv_mbajo_por", "niv_mmedio_por", "niv_malto_por"
)

# Marca de texto vacia ("", "NA", "<NA>") -> NA real, conservando el resto.
limpiar_marca <- function(x) {
  x <- as.character(x)
  x[x %in% c("", "NA", "<NA>", "N/A")] <- NA_character_
  x
}

leer_un_archivo <- function(archivo, grado, anio, familia, estado) {
  ruta <- here::here("20_insumos", archivo)
  df <- readxl::read_excel(ruta, guess_max = 200000)
  names(df) <- trimws(tolower(names(df)))
  n <- nrow(df)

  # --- Coherencia anio: el del nombre manda; el del dato se valida ---
  if ("agno" %in% names(df)) {
    a <- unique(as.integer(to_num(df$agno))); a <- a[!is.na(a)]
    if (length(a) == 1 && a != anio) {
      warning(sprintf("%s: agno del dato (%d) != nombre (%d).", archivo, a, anio))
    }
  }

  # --- Homologacion de ids segun familia ---
  id_ind <- homologar_id(df, "id_indicador", "ind", CW_INDICADOR, "indicador", archivo)
  id_dim <- if (familia %in% c("rbd_dim", "niveles")) {
    homologar_id(df, "id_dimension", "dim", CW_DIMENSION, "dimension", archivo)
  } else rep(NA_integer_, n)
  id_sub <- if (familia == "niveles") {
    homologar_id(df, "id_subdimension", "sdim", CW_SUBDIMENSION, "subdimension", archivo)
  } else rep(NA_integer_, n)

  out <- tibble::tibble(
    rbd             = as.character(df$rbd),
    agno            = as.integer(anio),
    grado           = grado,
    ciclo_texto     = unname(GRADO_CICLO_TEXTO[grado]),  # NA para 8b (sin texto)
    preliminar      = (estado == "preliminar"),
    familia         = dplyr::recode(familia, "rbd" = "indicador", "rbd_dim" = "dimension"),
    id_indicador    = id_ind,
    id_dimension    = id_dim,
    id_subdimension = id_sub,
    # Segmentacion y geografia leidas del dato IDPS (4 categorias de cod_depe2,
    # 4=SLEP, segun glosa). Presentes en rbd/rbd_dim, ausentes en niveles. En el
    # Bloque 5 se HOMOLOGAN a un valor canonico por establecimiento (resuelve la
    # inconsistencia de cod_depe2 entre familias y completa la familia niveles).
    cod_grupo       = col_o_na(df, "cod_grupo", "chr", n),
    cod_depe2       = col_o_na(df, "cod_depe2", "chr", n),
    cod_com_rbd     = col_o_na(df, "cod_com_rbd", "chr", n),
    nom_com_rbd     = col_o_na(df, "nom_com_rbd", "chr", n),
    cod_reg_rbd     = col_o_na(df, "cod_reg_rbd", "chr", n),
    nom_reg_rbd     = col_o_na(df, "nom_reg_rbd", "chr", n),
    cod_pro_rbd     = col_o_na(df, "cod_pro_rbd", "chr", n),
    nom_rbd         = col_o_na(df, "nom_rbd", "chr", n),
    # Medidas continuas (indicador / dimension). NA = supresion, nunca cero.
    prom            = col_o_na(df, "prom", "num", n),
    dif             = col_o_na(df, "dif", "num", n),
    sigdif          = col_o_na(df, "sigdif", "int", n),
    difgru          = col_o_na(df, "difgru", "num", n),
    sigdifgru       = col_o_na(df, "sigdifgru", "int", n),
    mdif            = limpiar_marca(col_o_na(df, "mdif", "chr", n)),
    mdifgru         = limpiar_marca(col_o_na(df, "mdifgru", "chr", n)),
    # Distribucion de niveles (solo familia niveles). NA = supresion.
    niv_bajo_por    = col_o_na(df, "niv_bajo_por", "num", n),
    niv_medio_por   = col_o_na(df, "niv_medio_por", "num", n),
    niv_alto_por    = col_o_na(df, "niv_alto_por", "num", n),
    niv_mbajo_por   = limpiar_marca(col_o_na(df, "niv_mbajo_por", "chr", n)),
    niv_mmedio_por  = limpiar_marca(col_o_na(df, "niv_mmedio_por", "chr", n)),
    niv_malto_por   = limpiar_marca(col_o_na(df, "niv_malto_por", "chr", n))
  )
  out[, COLS_CANONICAS]
}


# ============================================================================
# Bloque 3b — Lectura del HISTORICO ancho 2014-2019 (P5 fase 3)
# ============================================================================
# El historico publica el dato en formato ANCHO: una fila por RBD, con el prom
# del indicador (ind_am, ind_cc, ...) y —solo 2018— de la dimension
# (dim_am_aa_rbd, ...) como COLUMNAS. Aqui se pivota a largo al esquema canonico.
# Reusa los crosswalks CW_INDICADOR/CW_DIMENSION via map_codigo (aborta si un
# sufijo no calza, igual que el moderno; NO se construye un mapeo nuevo).
# Lo que el historico NO trae (significancia, subdimension, niveles; y geo/GSE en
# 2014-2016) va NA: ausencia legitima, nunca un valor inventado.

# Inversos de etiqueta para el 2017, que trae cod_grupo/cod_depe2 en TEXTO.
# Derivados de las constantes del config (no es un crosswalk nuevo: invierte
# GSE_LABELS y DEPENDENCIAS, ya validados).
GSE_TEXTO_A_COD  <- stats::setNames(names(GSE_LABELS),  unname(GSE_LABELS))
DEPE_TEXTO_A_COD <- stats::setNames(names(DEPENDENCIAS), unname(DEPENDENCIAS))

# Normaliza un codigo que puede venir numerico (2018-2019), en texto (2017) o
# ausente (2014-2016): texto -> codigo via el inverso; numerico -> se conserva;
# vacio/NA -> NA. El dominio se valida sin relajar en el Bloque 6.2.
normalizar_cod_texto <- function(x, mapa_texto) {
  x <- limpiar_marca(x)
  es_txt <- !is.na(x) & is.na(suppressWarnings(as.numeric(x)))
  if (any(es_txt)) x[es_txt] <- unname(mapa_texto[x[es_txt]])
  as.character(x)
}

leer_un_archivo_historico <- function(archivo, grado, anio, estado) {
  ruta <- here::here("20_insumos", "historico", archivo)
  df <- readxl::read_excel(ruta, guess_max = 200000)  # primera hoja (Sheet1 en .xls)
  names(df) <- trimws(tolower(names(df)))
  n <- nrow(df)

  # Geo divergente 2018 -> canonica. nom_reg_rbd se completa luego en el Bloque
  # 5.1 desde cod_reg_rbd via NOMBRES_REGION; aqui solo nom_comuna -> nom_com_rbd
  # (y nom_regi_n por si se necesitara). cod_reg/cod_pro/cod_com/nom_rbd ya son
  # canonicos en 2018.
  if ("nom_regi_n" %in% names(df) && !("nom_reg_rbd" %in% names(df))) df$nom_reg_rbd <- df$nom_regi_n
  if ("nom_comuna" %in% names(df) && !("nom_com_rbd" %in% names(df))) df$nom_com_rbd <- df$nom_comuna

  # Atributos por RBD (una fila por RBD en el ancho). 2017: cod_grupo/cod_depe2
  # en texto -> codigo. 2014-2016: ausentes -> NA (supresion legitima).
  base <- tibble::tibble(
    rbd         = as.character(df$rbd),
    cod_grupo   = normalizar_cod_texto(col_o_na(df, "cod_grupo", "chr", n), GSE_TEXTO_A_COD),
    cod_depe2   = normalizar_cod_texto(col_o_na(df, "cod_depe2", "chr", n), DEPE_TEXTO_A_COD),
    cod_com_rbd = col_o_na(df, "cod_com_rbd", "chr", n),
    nom_com_rbd = col_o_na(df, "nom_com_rbd", "chr", n),
    cod_reg_rbd = col_o_na(df, "cod_reg_rbd", "chr", n),
    nom_reg_rbd = col_o_na(df, "nom_reg_rbd", "chr", n),
    cod_pro_rbd = col_o_na(df, "cod_pro_rbd", "chr", n),
    nom_rbd     = col_o_na(df, "nom_rbd", "chr", n)
  )

  # --- Pivote INDICADOR (todos los anios): ind_{xx} o ind_{xx}_rbd -> filas ---
  cols_ind <- names(df)[grepl("^ind_[a-z]{2}(_rbd)?$", names(df))]
  if (length(cols_ind) == 0)
    stop(sprintf("%s: sin columnas de indicador ind_* en el historico.", archivo))
  ind_long <- dplyr::bind_rows(lapply(cols_ind, function(col) {
    code <- toupper(sub("^ind_([a-z]{2})(_rbd)?$", "\\1", col))
    id   <- map_codigo(code, CW_INDICADOR, "indicador", archivo)  # aborta si no calza
    tibble::tibble(
      rbd = as.character(df$rbd), familia = "indicador",
      id_indicador = id, id_dimension = NA_integer_, id_subdimension = NA_integer_,
      prom = col_o_na(df, col, "num", n)
    )
  }))

  # --- Pivote DIMENSION (solo 2018): dim_{ind}_{dim}_rbd -> filas ---
  # El par MEDIO (dim) da id_dimension; el indicador sale de la decena (no del
  # primer par, redundante). map_codigo aborta si un sufijo de dimension no calza.
  cols_dim <- names(df)[grepl("^dim_[a-z]{2}_[a-z]{2}_rbd$", names(df))]
  dim_long <- if (length(cols_dim) > 0) {
    dplyr::bind_rows(lapply(cols_dim, function(col) {
      mid <- toupper(sub("^dim_[a-z]{2}_([a-z]{2})_rbd$", "\\1", col))
      idd <- map_codigo(mid, CW_DIMENSION, "dimension", archivo)
      tibble::tibble(
        rbd = as.character(df$rbd), familia = "dimension",
        id_indicador = idd %/% 10L, id_dimension = idd, id_subdimension = NA_integer_,
        prom = col_o_na(df, col, "num", n)
      )
    }))
  } else NULL

  largo <- dplyr::bind_rows(ind_long, dim_long)

  # Adjuntar atributos por RBD y completar el esquema canonico con NA donde el
  # historico no trae columna (significancia, niveles; tipos identicos al moderno).
  out <- largo |>
    dplyr::left_join(base, by = "rbd") |>
    dplyr::mutate(
      agno            = as.integer(anio),
      grado           = grado,
      ciclo_texto     = unname(GRADO_CICLO_TEXTO[grado]),
      preliminar      = (estado == "preliminar"),
      dif = NA_real_, sigdif = NA_integer_, difgru = NA_real_, sigdifgru = NA_integer_,
      mdif = NA_character_, mdifgru = NA_character_,
      niv_bajo_por = NA_real_, niv_medio_por = NA_real_, niv_alto_por = NA_real_,
      niv_mbajo_por = NA_character_, niv_mmedio_por = NA_character_, niv_malto_por = NA_character_
    )
  out[, COLS_CANONICAS]
}


# ============================================================================
# Bloque 4 — Iterar y consolidar por familia
# ============================================================================

message("[2] Leyendo y normalizando archivos...")

partes <- purrr::pmap(manifiesto, function(archivo, grado, anio, familia, estado, regimen) {
  df <- if (regimen == "historico") {
    leer_un_archivo_historico(archivo, grado, anio, estado)
  } else {
    leer_un_archivo(archivo, grado, anio, familia, estado)
  }
  message(sprintf("    %s%s — %s %d [%s]: %d filas",
                  ifelse(estado == "preliminar", "*", " "),
                  archivo, grado, anio, substr(regimen, 1, 4), nrow(df)))
  df
})
datos <- dplyr::bind_rows(partes)

n_ind <- sum(datos$familia == "indicador")
n_dim <- sum(datos$familia == "dimension")
n_niv <- sum(datos$familia == "niveles")
message(sprintf("    Subtotales: indicador=%d, dimension=%d, niveles=%d.",
                n_ind, n_dim, n_niv))


# ============================================================================
# Bloque 5 — Homologacion de atributos de establecimiento (dependencia/geo + GSE)
# ============================================================================
# Problema: cod_depe2 es INCONSISTENTE entre familias del propio dato IDPS
# (p.ej. 2022 rbd=1 Municipal vs rbd_dim=4 SLEP para el mismo RBD), porque la
# Agencia no actualizo la dependencia en todas las tablas. DECISION (documentar
# y confirmar con el titular): se homologa a un valor CANONICO por
# establecimiento tomado de la familia 'indicador' (la primaria) en su anio MAS
# RECIENTE, y se aplica a toda la serie. Mismo criterio que el madre (dependencia
# vigente a toda la serie: permite que un SLEP filtre "sus" establecimientos en
# todos los anios). Se mantiene el esquema de 4 categorias del IDPS (4=SLEP,
# CLAUDE.md), NO el de 5 categorias del directorio oficial. La geografia se toma
# del mismo registro canonico. El GSE (cod_grupo) es por (rbd, agno, grado),
# porque es la clasificacion del propio instrumento ese anio.

message("[3] Homologando atributos (depe2/geo canonicos por RBD; GSE por anio)...")

# 5.1 — Atributos canonicos por RBD: familia indicador, anio mas reciente.
# Resolucion por REGIMEN (P5 fase 3, invariante "el moderno no cambia"): las
# filas MODERNAS (agno>=2022) toman el atributo del indicador MODERNO mas
# reciente — asi el historico jamas altera una fila 2022-2025, ni siquiera la de
# un RBD sin indicador moderno (queda NA, como antes). Las filas HISTORICAS toman
# el indicador mas reciente GLOBAL, de modo que un RBD solo-historico recibe su
# geo/depe historica (Fase B.4). Para un RBD con dato moderno ambas resoluciones
# coinciden (el moderno es el mas reciente): atributo unico por RBD en la practica.
construir_attr <- function(d) {
  d |>
    dplyr::arrange(rbd, dplyr::desc(agno)) |>
    dplyr::distinct(rbd, .keep_all = TRUE) |>
    dplyr::transmute(
      rbd, cod_depe2,
      cod_com_rbd, nom_com_rbd, cod_reg_rbd,
      nom_reg_rbd = dplyr::coalesce(unname(NOMBRES_REGION[cod_reg_rbd]), nom_reg_rbd),
      cod_pro_rbd, nom_rbd
    )
}
ind_rows <- dplyr::filter(datos, .data$familia == "indicador")
attr_estab <- dplyr::bind_rows(
  construir_attr(dplyr::filter(ind_rows, as.integer(agno) >= 2022L)) |> dplyr::mutate(.hist = FALSE),
  construir_attr(ind_rows) |> dplyr::mutate(.hist = TRUE)
)

# 5.2 — GSE por (rbd, agno, grado) desde la familia indicador (canonica).
mapa_gse <- datos |>
  dplyr::filter(.data$familia == "indicador", !is.na(.data$cod_grupo)) |>
  dplyr::distinct(rbd, agno, grado, cod_grupo)
dup_gse <- mapa_gse |> dplyr::count(rbd, agno, grado) |> dplyr::filter(n > 1)
if (nrow(dup_gse) > 0) {
  print(utils::head(dup_gse, 10))
  stop("GSE inconsistente por (rbd, agno, grado) en la familia indicador.")
}

# 5.3 — Reemplazar depe2/geo (por rbd y regimen) y cod_grupo (por anio).
# .hist marca la fila por regimen y empalma con la resolucion correcta de 5.1
# (moderno congelado / historico global). El moderno (agno>=2022) nunca recibe
# atributo de origen historico.
n_total <- nrow(datos)
datos <- datos |>
  dplyr::mutate(.hist = as.integer(agno) <= 2019L) |>
  dplyr::select(-cod_depe2, -cod_com_rbd, -nom_com_rbd, -cod_reg_rbd,
                -nom_reg_rbd, -cod_pro_rbd, -nom_rbd) |>
  dplyr::left_join(attr_estab, by = c("rbd", ".hist")) |>
  dplyr::select(-.hist) |>
  dplyr::select(-cod_grupo) |>
  dplyr::left_join(mapa_gse, by = c("rbd", "agno", "grado"))
stopifnot("El join de atributos cambio el numero de filas" = nrow(datos) == n_total)

sin_depe <- sum(is.na(datos$cod_depe2))
sin_gse  <- sum(is.na(datos$cod_grupo))
message(sprintf("    %d filas sin depe2 (%.1f%%); %d sin GSE (supresion, %.1f%%).",
                sin_depe, 100 * sin_depe / n_total, sin_gse, 100 * sin_gse / n_total))

datos <- datos[, COLS_CANONICAS]


# ============================================================================
# Bloque 6 — Validaciones de integridad
# ============================================================================

message("[4] Validaciones...")

# 6.1 — Coherencia estructural del id numerico (decena/centena = jerarquia).
chk_dim <- datos |> dplyr::filter(!is.na(id_dimension))
stopifnot("id_dimension no respeta decena=indicador" =
            all(chk_dim$id_dimension %/% 10L == chk_dim$id_indicador))
chk_sub <- datos |> dplyr::filter(!is.na(id_subdimension))
stopifnot(
  "id_subdimension no respeta centena=indicador" =
    all(chk_sub$id_subdimension %/% 100L == chk_sub$id_indicador),
  "id_subdimension no respeta (decena+centena)=dimension" =
    all(chk_sub$id_subdimension %/% 10L == chk_sub$id_dimension)
)
message("    OK: jerarquia de ids coherente (indicador/dimension/subdimension).")

# 6.2 — Dominios de indicador, GSE y dependencia.
stopifnot(
  "id_indicador fuera de 1:4" =
    all(datos$id_indicador %in% 1:4),
  "cod_grupo fuera de {1..5, NA}" =
    all(datos$cod_grupo %in% c(as.character(1:5), NA)),
  "cod_depe2 fuera de {1..4, NA}" =
    all(datos$cod_depe2 %in% c(as.character(1:4), NA))
)
message("    OK: dominios de id_indicador, cod_grupo y cod_depe2.")

# 6.3 — Una sola fila por (familia, rbd, agno, grado, ids): sin duplicados.
llave_dups <- datos |>
  dplyr::count(familia, rbd, agno, grado, id_indicador, id_dimension, id_subdimension) |>
  dplyr::filter(n > 1)
if (nrow(llave_dups) > 0) {
  print(utils::head(llave_dups, 10))
  warning(sprintf("%d combinaciones de llave duplicadas.", nrow(llave_dups)))
} else {
  message("    OK: sin duplicados en la llave (familia, rbd, agno, grado, ids).")
}

# 6.4 — Supresion: reportar % NA en la medida por familia (NA = resguardo).
resumen_na <- datos |>
  dplyr::summarise(
    pct_na = dplyr::case_when(
      familia[1] == "niveles" ~ round(100 * mean(is.na(niv_bajo_por)), 1),
      TRUE                    ~ round(100 * mean(is.na(prom)), 1)
    ),
    .by = familia
  )
message("    % NA en la medida (supresion) por familia:")
for (i in seq_len(nrow(resumen_na))) {
  message(sprintf("      %-10s %5.1f%%", resumen_na$familia[i], resumen_na$pct_na[i]))
}


# ============================================================================
# Bloque 7 — Escritura atomica del parquet
# ============================================================================

message("[5] Escribiendo idps_largo.parquet...")

dir_out <- here::here("40_salidas", "intermedios")
if (!fs::dir_exists(dir_out)) fs::dir_create(dir_out, recurse = TRUE)
# Ruta de salida sobreescribible: por defecto el parquet canonico; el arnes de
# verificacion (P5 fase 3) la redirige a un temporal para comparar bit-a-bit el
# dato moderno ANTES de promover sobre idps_largo.parquet.
ruta_final <- getOption("idps_largo_out", default = fs::path(dir_out, "idps_largo.parquet"))
ruta_tmp   <- fs::path(paste0(ruta_final, ".tmp"))

arrow::write_parquet(datos, ruta_tmp)
fs::file_move(ruta_tmp, ruta_final)

message(sprintf("    OK: %d filas x %d columnas en %s.",
                nrow(datos), ncol(datos),
                fs::path_rel(ruta_final, here::here())))


# ============================================================================
# Bloque 8 — Resumen final
# ============================================================================

message("")
message("=== Cobertura grado x anio x familia (n filas) ===")
print(
  datos |>
    dplyr::count(grado, agno, familia) |>
    tidyr::pivot_wider(names_from = familia, values_from = n, values_fill = 0) |>
    dplyr::arrange(grado, agno),
  n = Inf
)
message("")
message(sprintf("34_leer_normalizar_idps.R: OK. %d filas en idps_largo.parquet.",
                nrow(datos)))
