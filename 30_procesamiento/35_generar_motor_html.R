# ==============================================================================
# 35_generar_motor_html.R
# ------------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Genera el motor HTML autocontenido (producto final) a partir de
#            idps_largo y los catalogos. Replica el mecanismo del madre
#            slep_simce_adecuado (JSON -> gzip -> base64 -> placeholders; D3 y
#            pako inline; React por CDN con SRI; fuentes de marca embebidas),
#            sobre el MODELO NUEVO (sin agregacion territorial): el dato viaja por
#            establecimiento-grado; territorio y GSE son navegacion/etiqueta,
#            nunca cifra agregada; la comparacion es difgru/sigdifgru y dif/sigdif
#            (se LEEN, no se derivan; no se dibuja la linea absoluta del GSE).
#
# ALCANCE: TODO CHILE (decision titular, encargo 2). El universo embebido es
# nacional; la navegacion territorial (region -> SLEP/comuna -> establecimiento)
# acota que establecimientos se listan, sin producir cifras agregadas.
#
# Insumos  : 40_salidas/intermedios/idps_largo.parquet, catalogo_idps.parquet,
#            comunas_chile.parquet, sleps_chile.parquet
#            30_procesamiento/35_motor_template.html, 10_utils/{d3,pako}.min.js
#            50_documentacion/andamios/diseno/motor_idps/fonts/*.otf (solo lectura)
# Salida   : 40_salidas/motor_idps.html
#
# Contrato JSON (columnar, ORDENADO por rbd para que el cliente arme un indice de
# rangos por establecimiento sin materializar 1,5M de objetos):
#   meta, regiones[], sleps[], comunas[], establecimientos[],
#   indicadores[], dimensiones[], subdimensiones[] (con texto de nivel por ciclo),
#   roster{rbd,grado,agno,gse,depe2}, ind{...}, dim{...}, niv{...}
#
# Uso: source(here::here("30_procesamiento","35_generar_motor_html.R"))
# Convencion: paquetes prefijados; library() solo para here y fs.
# ==============================================================================

library(here)
library(fs)

source(here::here("10_utils", "10_utils.R"))
instalar_si_falta(c("dplyr", "arrow", "jsonlite", "readr", "readxl"))
source(here::here("10_utils", "10_configuracion.R"))

# Paleta canonica de los 4 indicadores: identidad cromatica del folleto oficial de
# la Agencia de Calidad ("¿Cuales son los Indicadores de Desarrollo Personal y
# Social?", los 4 circulos). Mapeo confirmado contra los rotulos impresos. Reemplaza
# la paleta interna previa (rojo/amarillo/verde-lima/azul). Ver decision P-PALETA
# (50_documentacion/activa/decisiones/20260622_decision_paleta_indicadores.md).
INDICADOR_COLORS <- c("1" = "#3858A3", "2" = "#61BDC6", "3" = "#4BA560", "4" = "#AACB58")
INDICADOR_CORTO  <- c("1" = "Autoestima", "2" = "Convivencia",
                      "3" = "Participación", "4" = "Hábitos")
REGION_FOCO <- "5"  # Valparaiso (default de navegacion; foco Costa Central)
# Anios sin evaluacion del sistema por pandemia (eje historico contiguo, D-s12-EJE).
ANIOS_PANDEMIA <- c(2020L, 2021L)

# Encoding UTF-8 defensivo sobre las etiquetas con tildes antes de serializar
# (regla Bug 2: literales no-ASCII pueden quedar "unknown" en locale C -> mojibake).
Encoding(INDICADOR_LABELS)    <- "UTF-8"
Encoding(INDICADOR_CORTO)     <- "UTF-8"
Encoding(DIMENSION_LABELS)    <- "UTF-8"
Encoding(SUBDIMENSION_LABELS) <- "UTF-8"


# ============================================================================
# Bloque 1 — Cargar insumos (TODO CHILE, sin filtro territorial)
# ============================================================================
message("[1] Cargando insumos (todo Chile)...")

P   <- arrow::read_parquet(here::here("40_salidas", "intermedios", "idps_largo.parquet"))
CAT <- arrow::read_parquet(here::here("40_salidas", "intermedios", "catalogo_idps.parquet"))
COM <- arrow::read_parquet(here::here("40_salidas", "intermedios", "comunas_chile.parquet"))
SLE <- arrow::read_parquet(here::here("40_salidas", "intermedios", "sleps_chile.parquet"))

# Directorio publico = AUTORIDAD de etiquetas geograficas y de nombre de EE.
# idps_largo trae nom_rbd/nom_com_rbd TRUNCADOS por el export de la Agencia
# (~37 chars en EE, ~13 en comuna) y geo NA en algunos RBD; el directorio publico
# los tiene completos y cubre el 100% de los RBD del motor. Se usa para etiquetas/
# geo/DEPENDENCIA de PRESENTACION (Hallazgos H1/H2/H8 y H6: dependencia vigente).
# Las CIFRAS NO cambian: siguen viniendo de idps_largo. Llaves character.
DIR <- readr::read_delim(
  here::here("20_insumos", "auxiliares", "directorio_oficial_ee_publico.csv"),
  delim = ";", locale = readr::locale(encoding = "UTF-8"),
  show_col_types = FALSE, progress = FALSE,
  col_types = readr::cols(.default = readr::col_character()))

# Filtro de PRESENTACION (decision de alcance): el motor expone solo GRADOS_MOTOR
# (4b/2m). El dato completo de los 4 grados permanece intacto en idps_largo.parquet;
# se acota AQUI el universo final que alimenta el motor (no a media tuberia).
P <- dplyr::filter(P, .data$grado %in% GRADOS_MOTOR)
stopifnot("Sin filas tras filtrar a GRADOS_MOTOR" = nrow(P) > 0)

# Higiene de presentacion (H-FID-1, log 20260621_display_fidelity): el crudo
# 4b/2017 trae filas con rbd=NA (sin establecimiento asociado) que se colapsaban
# en un "fantasma" rbd=null (sin nombre/geo/GSE) alcanzable por el buscador. Se
# descartan AQUI, al construir el universo que alimenta el motor; el parquet NO se
# toca (md5 intacto, el dato sigue completo en idps_largo). Solo afecta filas con
# rbd NA: ningun RBD real tiene rbd NA, asi que n_distinct(rbd real) no cambia.
n_fantasma <- sum(is.na(P$rbd))
P <- dplyr::filter(P, !is.na(.data$rbd))
message(sprintf("    [H-FID-1] descartadas %d fila(s) con rbd=NA (fantasma 4b/2017); parquet intacto.",
                n_fantasma))

message(sprintf("    %d filas, %d establecimientos (grados del motor: %s).",
                nrow(P), dplyr::n_distinct(P$rbd), paste(GRADOS_MOTOR, collapse = ", ")))


# ============================================================================
# Bloque 2 — Catalogos conceptuales (jerarquia 4 -> 11 -> 30)
# ============================================================================
message("[2] Catalogos conceptuales y territoriales...")

# Las definiciones (corpus -> catalogo) son ASCII, pero se fuerza UTF-8 de forma
# defensiva antes de serializar (regla del Bug 2: literales no-ASCII en locale C).
for (col in c("definicion", "indicador_definicion", "dimension_definicion")) {
  if (col %in% names(CAT)) Encoding(CAT[[col]]) <- "UTF-8"
}

# Definicion canonica del indicador (1 por id_indicador, desde el catalogo).
ind_def <- CAT |> dplyr::distinct(id_indicador, indicador_definicion)
indicadores_lst <- lapply(as.character(1:4), function(id) {
  d <- ind_def$indicador_definicion[ind_def$id_indicador == as.integer(id)][1]
  list(id = as.integer(id), nombre = unname(INDICADOR_LABELS[id]),
       corto = unname(INDICADOR_CORTO[id]), color = unname(INDICADOR_COLORS[id]),
       definicion = if (length(d) == 0 || is.na(d)) NULL else d)
})

# Nombre de dimension: etiqueta acentuada de presentacion (DIMENSION_LABELS),
# con fallback al nombre del catalogo (ASCII) si faltara. La definicion (P-meta)
# se conserva 1:1 desde el catalogo, sin tocar.
dimensiones_lst <- CAT |>
  dplyr::distinct(id_dimension, id_indicador, dimension_nombre, dimension_definicion) |>
  dplyr::arrange(id_dimension) |>
  dplyr::transmute(id = as.integer(id_dimension), id_ind = as.integer(id_indicador),
                   nombre = dplyr::coalesce(unname(DIMENSION_LABELS[as.character(id_dimension)]),
                                            dimension_nombre),
                   definicion = dimension_definicion)
Encoding(dimensiones_lst$nombre) <- "UTF-8"

subdim_lst <- lapply(seq_len(nrow(CAT)), function(i) {
  r <- CAT[i, ]
  txt_ciclo <- function(b, m, a) {
    out <- list(bajo = r[[b]], medio = r[[m]], alto = r[[a]]); out[!is.na(out)]
  }
  # Nombre acentuado de presentacion (SUBDIMENSION_LABELS por id; solo las 22 EST),
  # con fallback al nombre ASCII del catalogo. La definicion (P-meta) se conserva
  # 1:1 (sigue ASCII: sin fuente acentuada verificable, queda pendiente del titular).
  nom_sub <- if (!is.na(r$id_subdimension))
    unname(SUBDIMENSION_LABELS[as.character(r$id_subdimension)]) else NA_character_
  if (is.na(nom_sub)) nom_sub <- r$subdimension_nombre
  Encoding(nom_sub) <- "UTF-8"
  base <- list(
    id_ind = as.integer(r$id_indicador), id_dim = as.integer(r$id_dimension),
    nombre = nom_sub, actores = r$actores,
    tiene_niveles = isTRUE(r$tiene_niveles),
    definicion = if (is.na(r$definicion)) NULL else r$definicion
  )
  if (!is.na(r$id_subdimension)) base$id <- as.integer(r$id_subdimension)
  if (isTRUE(r$tiene_niveles)) {
    base$n_niveles <- list(basica = r$n_niveles_basica, media = r$n_niveles_media)
    base$texto <- list(
      basica = txt_ciclo("nivel_basica_bajo","nivel_basica_medio","nivel_basica_alto"),
      media  = txt_ciclo("nivel_media_bajo","nivel_media_medio","nivel_media_alto"))
  }
  base
})


# ============================================================================
# Bloque 3 — Catalogos territoriales NACIONALES (region -> SLEP/comuna -> estab)
# ============================================================================
# Solo se listan territorios CON datos IDPS (rbds presentes en P), para que la
# navegacion no ofrezca ramas vacias.
rbds_idps <- unique(P$rbd)

# Atributos de PRESENTACION por establecimiento:
#  - nombre de EE y geografia (comuna/region/provincia): del DIRECTORIO publico
#    (completos, sin truncar; H1/H2). Cubre el 100% de los RBD del motor y
#    rellena los pocos RBD con geo NA en idps_largo (H8). Llave rbd character.
#  - cod_depe2 (dependencia 4-cat): VIGENTE del directorio (H6, homologada 5->4).
#  - cod_slep: de sleps_chile.
estab_slep <- SLE |> dplyr::distinct(rbd, cod_slep, nombre_slep)
dir_attr <- DIR |>
  dplyr::transmute(rbd = as.character(RBD), nom_dir = NOM_RBD,
                   cod_com_dir = as.character(COD_COM_RBD),
                   cod_reg_dir = as.character(COD_REG_RBD),
                   cod_pro_dir = as.character(COD_PRO_RBD),
                   # Dependencia VIGENTE (actual) del directorio, homologada 5->4 (H6).
                   cod_depe2_dir = unname(CW_DEPE_DIRECTORIO_A_IDPS[as.character(COD_DEPE2)])) |>
  dplyr::distinct(rbd, .keep_all = TRUE)

# ----------------------------------------------------------------------------
# SANEAMIENTO DE NOMBRES (decision titular, Fase 3) — jerarquia de 3 capas:
#  1) EE del SLEP Costa Central -> caracterizacion_establecimientos.xlsx (autoridad
#     curada: tildes y mayusculas correctas). Se muestra VERBATIM (sin tc() en el
#     cliente; flag `cur`), porque tc() bajaria "La Greda" -> "la Greda".
#  2) Resto del pais -> nombre del directorio con apostrofo/comilla SANEADOS.
#  3) Fallback al nombre (truncado) de idps_largo solo si el directorio no cubre el
#     RBD; tambien saneado.
# Las CIFRAS NO cambian: es 100% reparacion de etiqueta de presentacion.
# ----------------------------------------------------------------------------
# Mapa curado rbd -> nombre (solo los 73 RBD del SLEP CC presentes en el xlsx).
carac_map <- readxl::read_excel(
    here::here("20_insumos", "auxiliares", "caracterizacion_establecimientos.xlsx"),
    sheet = 1, .name_repair = "minimal") |>
  dplyr::transmute(rbd = as.character(.data[["RBD"]]),
                   nom_carac = .data[["Nombre del establecimiento"]]) |>
  dplyr::filter(!is.na(rbd), !is.na(nom_carac)) |>
  dplyr::distinct(rbd, .keep_all = TRUE)
Encoding(carac_map$nom_carac) <- "UTF-8"

# REPARACION DE CODIFICACION del apostrofo/comilla del directorio (NO edicion
# ortografica). Diagnostico por bytes (Fase 3): el directorio usa codepoints
# erroneos donde va un apostrofo/comilla:
#   U+00B4 (acento agudo) y U+005E (circunflejo) -> SIEMPRE apostrofo U+0027 (').
#   U+0060 (backtick): comillas envolventes en PARES -> U+0022 ("); conteo IMPAR
#     (backtick suelto, mas probable apostrofo) -> U+0027 (') y se registra como
#     anomalia (regla titular: no adivinar). U+0027 ya correcto no se toca.
sanea_nombre_dir <- function(s) {
  if (is.na(s) || !nzchar(s)) return(s)
  Encoding(s) <- "UTF-8"; cps <- utf8ToInt(s)
  cps[cps == 0x00B4 | cps == 0x005E] <- 0x27L
  nbt <- sum(cps == 0x60)
  if (nbt > 0) cps[cps == 0x60] <- if (nbt %% 2 == 0) 0x22L else 0x27L
  out <- intToUtf8(cps); Encoding(out) <- "UTF-8"; out
}

# Anomalia de backtick IMPAR en EE fuera del SLEP (se registra; el saneo ya lo
# trata como apostrofo, fallback seguro).
bt_odd <- DIR |>
  dplyr::transmute(rbd = as.character(RBD), nom = NOM_RBD) |>
  dplyr::filter(!rbd %in% carac_map$rbd, !is.na(nom)) |>
  dplyr::mutate(nbt = vapply(nom, function(s){ Encoding(s) <- "UTF-8"; sum(utf8ToInt(s) == 0x60) }, integer(1))) |>
  dplyr::filter(nbt %% 2 == 1)
if (nrow(bt_odd)) {
  message(sprintf("[NOMBRES] %d nombre(s) con backtick IMPAR (tratados como apostrofo; revisar):", nrow(bt_odd)))
  for (i in seq_len(nrow(bt_odd))) message(sprintf("   RBD %s: %s", bt_odd$rbd[i], bt_odd$nom[i]))
} else message("[NOMBRES] sin backticks impares en EE fuera del SLEP.")

est_attr <- P |>
  # UN registro por RBD. Con la serie historica un mismo RBD puede traer atributos
  # IDPS distintos entre filas (historico vs moderno, o nombres/geo truncados de modo
  # distinto), lo que generaba establecimientos DUPLICADos (tarjetas repetidas). Se toma
  # el del año MAS RECIENTE; la geo/nombre/dependencia canonicos vienen igual del
  # directorio via coalesce mas abajo (antes, universo solo-moderno, cada RBD tenia un
  # unico combo y el distinct por columnas bastaba).
  dplyr::arrange(rbd, dplyr::desc(agno)) |>
  dplyr::distinct(rbd, .keep_all = TRUE) |>
  dplyr::select(rbd, nom_rbd, cod_com_rbd, cod_reg_rbd, cod_pro_rbd, cod_depe2) |>
  dplyr::rename(cod_depe2_idps = cod_depe2) |>
  dplyr::left_join(dir_attr, by = "rbd") |>
  dplyr::left_join(carac_map, by = "rbd") |>
  dplyr::transmute(
    rbd,
    cur = !is.na(nom_carac),   # TRUE = nombre curado (SLEP CC) -> verbatim en cliente
    # Capa 1 caracterizacion (verbatim) | Capa 2/3 directorio|idps con apostrofo saneado.
    nom = dplyr::if_else(cur, nom_carac,
                         vapply(dplyr::coalesce(nom_dir, nom_rbd), sanea_nombre_dir, character(1))),
    cod_com = dplyr::coalesce(cod_com_dir, cod_com_rbd),
    cod_reg = dplyr::coalesce(cod_reg_dir, cod_reg_rbd),
    cod_pro = dplyr::coalesce(cod_pro_dir, cod_pro_rbd),
    # Dependencia VIGENTE del directorio (H6); fallback al valor por-evaluacion
    # de idps_largo solo si el directorio no cubre el RBD.
    cod_depe2 = dplyr::coalesce(cod_depe2_dir, cod_depe2_idps)) |>
  dplyr::left_join(estab_slep, by = "rbd")
Encoding(est_attr$nom) <- "UTF-8"

# Verificacion POR BYTES del saneo (no visual; regla Bug 2 / locale C): ningun
# nombre de presentacion conserva U+00B4 / U+005E / U+0060.
nom_corrupto <- vapply(est_attr$nom, function(s){
  if (is.na(s)) return(FALSE); Encoding(s) <- "UTF-8"
  any(utf8ToInt(s) %in% c(0x00B4, 0x005E, 0x0060)) }, logical(1))
stopifnot("[NOMBRES] quedaron codepoints corruptos (U+00B4/U+005E/U+0060) tras el saneo" = sum(nom_corrupto) == 0)
message(sprintf("[NOMBRES] saneo OK: 0 nombres con U+00B4/U+005E/U+0060; %d EE con nombre curado (caracterizacion SLEP CC).",
                sum(est_attr$cur)))

# Validacion H6: reporta el delta de dependencia (vigente vs por-evaluacion) y
# asegura que ningun RBD del motor pierde dependencia (coalesce cubre los faltantes).
depe2_idps_rbd <- P |> dplyr::distinct(rbd, cod_depe2) |> dplyr::rename(depe2_idps = cod_depe2)
chk_h6 <- est_attr |> dplyr::distinct(rbd, cod_depe2) |>
  dplyr::left_join(depe2_idps_rbd, by = "rbd")
n_sin_dep <- sum(is.na(chk_h6$cod_depe2))
n_recl    <- sum(!is.na(chk_h6$cod_depe2) & !is.na(chk_h6$depe2_idps) &
                   chk_h6$cod_depe2 != chk_h6$depe2_idps)
# Con la serie historica, algunos RBD solo-historicos (cerrados; max año <=2018) no
# traen dependencia: ni el directorio publico (no lista EE cerrados) ni el dato
# 2014-2016 (sin columna cod_depe2). Es NA legitimo (no se fabrica; 🔒 "no inventar
# donde el dato trae NA"); el motor degrada a "—", mismo criterio que la geo-NA
# (D-s12-GEONA). Se REPORTA, no se aborta (el stopifnot original era valido cuando el
# universo era solo-moderno). PERO se aborta si un RBD con año MODERNO (>=2022) perdiera
# dependencia: eso seria un bug real, no NA historico legitimo.
rbd_sin_dep <- chk_h6$rbd[is.na(chk_h6$cod_depe2)]
if (length(rbd_sin_dep) > 0) {
  max_agno_sin <- P |> dplyr::filter(.data$rbd %in% rbd_sin_dep) |>
    dplyr::summarise(mx = max(as.integer(.data$agno)), .by = rbd)
  stopifnot("H6: RBD con año moderno (>=2022) sin dependencia (bug, no NA historico)" =
              sum(max_agno_sin$mx >= 2022) == 0)
  message(sprintf("[H6] %d RBD sin dependencia: NA legitimo (solo-historicos, max año <=2018); degradan a '—'.",
                  length(rbd_sin_dep)))
}
fmt_tab <- function(x) paste(sprintf("%s=%d", names(table(x)), as.integer(table(x))), collapse = ", ")
message(sprintf("[H6] Dependencia reclasificada en %d RBD (vigencia actual del directorio).", n_recl))
message(sprintf("     antes (idps): %s", fmt_tab(chk_h6$depe2_idps)))
message(sprintf("     ahora (dir):  %s", fmt_tab(chk_h6$cod_depe2)))

establecimientos_lst <- est_attr |>
  dplyr::transmute(rbd, nom, cur, cod_com, cod_reg, cod_slep, cod_depe2) |>
  dplyr::arrange(cod_reg, cod_com, nom)

# Etiqueta de region desde NOMBRES_REGION (fuente unica, con tildes). Encoding
# UTF-8 forzado antes de serializar (Bug 2).
regiones_lst <- est_attr |>
  dplyr::distinct(cod_reg) |>
  dplyr::filter(!is.na(cod_reg)) |>
  dplyr::transmute(cod = cod_reg,
                   nom = dplyr::coalesce(unname(NOMBRES_REGION[cod_reg]), cod_reg)) |>
  dplyr::arrange(suppressWarnings(as.integer(cod)))
Encoding(regiones_lst$nom) <- "UTF-8"

# Comuna: nombre COMPLETO del catalogo territorial (comunas_chile, ex-directorio),
# no la copia truncada de idps_largo (H1). Solo comunas con EE en el motor.
coms_motor <- unique(est_attr$cod_com)
comunas_lst <- COM |>
  dplyr::transmute(cod = as.character(cod_com_rbd), nom = nom_com_rbd,
                   cod_reg = as.character(cod_reg_rbd)) |>
  dplyr::filter(cod %in% coms_motor) |>
  dplyr::distinct(cod, .keep_all = TRUE) |>
  dplyr::arrange(nom)

# SLEPs con datos, con su region (via la geo del directorio) y su anio_traspaso.
# anio_traspaso es ETIQUETA DE CONTEXTO por SLEP (constante por cod_slep en el
# catalogo sleps_chile), NO un filtro temporal: el SLEP agrupa toda su serie
# historica, incluidos los años previos al traspaso. Se expone para mostrarlo en
# la fila del SLEP del selector ("Traspaso AAAA"); nunca recorta que años se
# atribuyen al SLEP.
sleps_lst <- est_attr |>
  dplyr::filter(!is.na(cod_slep)) |>
  dplyr::distinct(cod_slep, nombre_slep, cod_reg) |>
  dplyr::distinct() |>
  dplyr::left_join(dplyr::distinct(SLE, cod_slep, anio_traspaso), by = "cod_slep") |>
  dplyr::arrange(nombre_slep)

slep_foco <- unique(SLE$cod_slep[SLE$nombre_slep == "Costa Central"])
comunas_foco <- sort(unique(SLE$cod_com_rbd[SLE$nombre_slep == "Costa Central"]))


# ============================================================================
# Bloque 4 — Bloques de datos columnares (ORDENADOS por rbd) y meta
# ============================================================================
message("[3] Datos columnares (nacional, ordenados por rbd)...")

roster <- P |>
  dplyr::filter(.data$familia == "indicador") |>
  dplyr::distinct(rbd, grado, agno, cod_grupo) |>
  # Dependencia VIGENTE del directorio (H6), coherente con establecimientos_lst.
  dplyr::left_join(dplyr::distinct(est_attr, rbd, cod_depe2), by = "rbd") |>
  dplyr::arrange(rbd, grado, agno)
roster_lst <- list(rows = nrow(roster), rbd = roster$rbd, grado = roster$grado,
                   agno = as.integer(roster$agno), gse = roster$cod_grupo, depe2 = roster$cod_depe2)

ind <- P |> dplyr::filter(.data$familia == "indicador") |> dplyr::arrange(rbd, grado, agno, id_indicador)
ind_lst <- list(rows = nrow(ind), rbd = ind$rbd, grado = ind$grado, agno = as.integer(ind$agno),
                ind = as.integer(ind$id_indicador), prom = round(ind$prom, 1),
                dif = ind$dif, sigdif = ind$sigdif, difgru = ind$difgru, sigdifgru = ind$sigdifgru)

dim <- P |> dplyr::filter(.data$familia == "dimension") |> dplyr::arrange(rbd, grado, agno, id_dimension)
dim_lst <- list(rows = nrow(dim), rbd = dim$rbd, grado = dim$grado, agno = as.integer(dim$agno),
                dim = as.integer(dim$id_dimension), prom = round(dim$prom, 1),
                dif = dim$dif, sigdif = dim$sigdif)

niv <- P |> dplyr::filter(.data$familia == "niveles") |> dplyr::arrange(rbd, grado, agno, id_subdimension)
niv_lst <- list(rows = nrow(niv), rbd = niv$rbd, grado = niv$grado, agno = as.integer(niv$agno),
                sub = as.integer(niv$id_subdimension),
                bajo = round(niv$niv_bajo_por, 1), medio = round(niv$niv_medio_por, 1),
                alto = round(niv$niv_alto_por, 1))

grado_anios <- lapply(names(GRADO_LABELS), function(g) {
  a <- sort(unique(roster$agno[roster$grado == g])); if (length(a) == 0) NULL else as.integer(a)
})
names(grado_anios) <- names(GRADO_LABELS); grado_anios <- grado_anios[!vapply(grado_anios, is.null, logical(1))]

grados_lbl <- GRADO_LABELS[names(grado_anios)]; Encoding(grados_lbl) <- "UTF-8"

# Anios preliminares DERIVADOS del dato (columna preliminar), no hardcodeados:
# robusto a anios futuros (la marca preliminar/final viene del nombre de archivo
# en 34). I() fuerza array aunque sea un solo anio.
anios_prelim <- sort(unique(as.integer(P$agno[P$preliminar %in% TRUE])))

# Eje historico CONTIGUO por grado (D-s12-EJE): rango seq(min..max) de los anios con
# dato; cada anio se clasifica con_dato / pandemia (2020-2021) / no_eval (anio del
# rango sin dato que NO es pandemia, p.ej. 2019). El motivo del vacio se decide AQUI
# (server-side, con constante nombrada), no en el JS; el template solo lo pinta.
eje_historico <- lapply(names(grado_anios), function(g) {
  ad  <- grado_anios[[g]]
  eje <- seq.int(min(ad), max(ad))
  lapply(eje, function(y) {
    estado <- if (y %in% ANIOS_PANDEMIA) "pandemia"
              else if (y %in% ad)        "con_dato"
              else                       "no_eval"
    list(agno = as.integer(y), estado = estado, preliminar = y %in% anios_prelim)
  })
})
names(eje_historico) <- names(grado_anios)

# Cobertura real de anios del motor (header dinamico, en vez del literal "2022-2025").
cobertura_anios <- list(min = min(unlist(grado_anios, use.names = FALSE)),
                        max = max(unlist(grado_anios, use.names = FALSE)))

meta <- list(
  fecha_generacion = format(Sys.Date()),
  cobertura = "Todo Chile",
  region_foco = REGION_FOCO, slep_foco = if (length(slep_foco)) slep_foco else NULL,
  grados = as.list(grados_lbl), grado_anios = grado_anios, anios_preliminar = I(anios_prelim),
  eje_historico = eje_historico, cobertura_anios = cobertura_anios,
  gse = names(GSE_LABELS), gse_labels = as.list(GSE_LABELS),
  depe2 = names(DEPENDENCIAS), depe2_labels = as.list(DEPENDENCIAS),
  comunas_foco = comunas_foco,
  nota_8b = "8b: distribucion numerica disponible; sin texto cualitativo de nivel (decision sesion 6)."
)

json_root <- list(meta = meta, regiones = regiones_lst, sleps = sleps_lst, comunas = comunas_lst,
                  establecimientos = establecimientos_lst, indicadores = indicadores_lst,
                  dimensiones = dimensiones_lst, subdimensiones = subdim_lst,
                  roster = roster_lst, ind = ind_lst, dim = dim_lst, niv = niv_lst)

json_str <- enc2utf8(jsonlite::toJSON(json_root, auto_unbox = TRUE, na = "null",
                                      dataframe = "rows", digits = NA))
bytes_plano <- nchar(json_str, type = "bytes")
json_gzip <- memCompress(charToRaw(json_str), type = "gzip")
json_b64  <- gsub("\n", "", jsonlite::base64_enc(json_gzip), fixed = TRUE)
message(sprintf("    JSON: %.1f MB plano -> %.2f MB gzip+base64 (%.1f%%).",
                bytes_plano / 1e6, nchar(json_b64, type = "bytes") / 1e6,
                100 * nchar(json_b64, type = "bytes") / bytes_plano))


# ============================================================================
# Bloque 5 — Fuentes de marca embebidas (base64) -> CSS @font-face
# ============================================================================
message("[4] Embebiendo fuentes de marca...")
font_dir <- here::here("50_documentacion", "andamios", "diseno", "motor_idps", "fonts")
fuentes <- list(
  list(fam = "gobCL", w = 300, f = "gobCL_Light.otf"),
  list(fam = "gobCL", w = 400, f = "gobCL_Regular.otf"),
  list(fam = "gobCL", w = 800, f = "gobCL_Heavy.otf"),
  list(fam = "Museo Sans", w = 100, f = "MuseoSans-100.otf"),
  list(fam = "Museo Sans", w = 300, f = "MuseoSans-300.otf"),
  list(fam = "Museo Sans", w = 500, f = "MuseoSans_500.otf"),
  list(fam = "Museo Sans", w = 700, f = "MuseoSans_700.otf")
)
fonts_css <- vapply(fuentes, function(ft) {
  ruta <- fs::path(font_dir, ft$f)
  b64 <- jsonlite::base64_enc(readBin(ruta, "raw", n = file.info(ruta)$size))
  sprintf("@font-face{font-family:'%s';font-weight:%d;font-style:normal;font-display:swap;src:url(data:font/otf;base64,%s) format('opentype');}",
          ft$fam, ft$w, b64)
}, character(1)) |> paste(collapse = "\n")


# ============================================================================
# Bloque 6 — Plantilla + libs inline; reemplazo de placeholders
# ============================================================================
message("[5] Plantilla, D3 y pako...")
plantilla_path <- here::here("30_procesamiento", "35_motor_template.html")
d3_path   <- here::here("10_utils", "d3.min.js")
pako_path <- here::here("10_utils", "pako.min.js")
for (p in c(plantilla_path, d3_path, pako_path)) if (!file.exists(p)) stop("Falta: ", p)
plantilla <- paste(readLines(plantilla_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
d3_code   <- paste(readLines(d3_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
pako_code <- paste(readLines(pako_path, encoding = "UTF-8", warn = FALSE), collapse = "\n")
for (ph in c("__FONTS_CSS__", "__D3_INLINE__", "__PAKO_INLINE__", "__JSON_DATA__"))
  if (!grepl(ph, plantilla, fixed = TRUE)) stop("La plantilla no contiene ", ph)

message("[6] Construyendo HTML final...")
html <- sub("__FONTS_CSS__",   fonts_css, plantilla, fixed = TRUE)
html <- sub("__D3_INLINE__",   d3_code,   html,      fixed = TRUE)
html <- sub("__PAKO_INLINE__", pako_code, html,      fixed = TRUE)
html <- sub("__JSON_DATA__",   json_b64,  html,      fixed = TRUE)

ruta_salida <- here::here("40_salidas", "motor_idps.html")
con <- file(ruta_salida, open = "wb", encoding = "UTF-8")
writeBin(charToRaw(enc2utf8(html)), con); close(con)
tamano_kb <- file.info(ruta_salida)$size / 1024
n_roster <- roster_lst$rows; n_est <- nrow(establecimientos_lst); n_reg <- nrow(regiones_lst)
rm(json_str, json_gzip, json_b64, html, d3_code, pako_code, plantilla, fonts_css); gc(verbose = FALSE)


# ============================================================================
# Bloque 7 — Resumen
# ============================================================================
message("")
message("=== 35_generar_motor_html.R: OK (todo Chile) ===")
message(sprintf("  Regiones:         %d", n_reg))
message(sprintf("  Establecimientos: %d", n_est))
message(sprintf("  Unidades grilla:  %d (rbd x grado x anio)", n_roster))
message(sprintf("  Filas ind/dim/niv:%d / %d / %d", ind_lst$rows, dim_lst$rows, niv_lst$rows))
message(sprintf("  Peso HTML:        %.1f MB", tamano_kb / 1024))
message(sprintf("  Salida:           %s", fs::path_rel(ruta_salida, here::here())))
