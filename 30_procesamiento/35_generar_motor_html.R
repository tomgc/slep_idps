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
instalar_si_falta(c("dplyr", "arrow", "jsonlite", "readr"))
source(here::here("10_utils", "10_configuracion.R"))

# Paleta canonica de los 4 indicadores (madre / prototipo) y etiquetas cortas.
INDICADOR_COLORS <- c("1" = "#EE2D49", "2" = "#FFC92E", "3" = "#9BC93E", "4" = "#2A8FD9")
INDICADOR_CORTO  <- c("1" = "Autoestima", "2" = "Convivencia",
                      "3" = "Participación", "4" = "Hábitos")
REGION_FOCO <- "5"  # Valparaiso (default de navegacion; foco Costa Central)

# Encoding UTF-8 defensivo sobre las etiquetas con tildes antes de serializar
# (regla Bug 2: literales no-ASCII pueden quedar "unknown" en locale C -> mojibake).
Encoding(INDICADOR_LABELS) <- "UTF-8"
Encoding(INDICADOR_CORTO)  <- "UTF-8"
Encoding(DIMENSION_LABELS) <- "UTF-8"


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
  base <- list(
    id_ind = as.integer(r$id_indicador), id_dim = as.integer(r$id_dimension),
    nombre = r$subdimension_nombre, actores = r$actores,
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

est_attr <- P |>
  dplyr::distinct(rbd, nom_rbd, cod_com_rbd, cod_reg_rbd, cod_pro_rbd, cod_depe2) |>
  dplyr::rename(cod_depe2_idps = cod_depe2) |>
  dplyr::left_join(dir_attr, by = "rbd") |>
  dplyr::transmute(
    rbd,
    # Directorio = autoridad; fallback al dato IDPS solo si faltara (no deberia).
    nom     = dplyr::coalesce(nom_dir, nom_rbd),
    cod_com = dplyr::coalesce(cod_com_dir, cod_com_rbd),
    cod_reg = dplyr::coalesce(cod_reg_dir, cod_reg_rbd),
    cod_pro = dplyr::coalesce(cod_pro_dir, cod_pro_rbd),
    # Dependencia VIGENTE del directorio (H6); fallback al valor por-evaluacion
    # de idps_largo solo si el directorio no cubre el RBD.
    cod_depe2 = dplyr::coalesce(cod_depe2_dir, cod_depe2_idps)) |>
  dplyr::left_join(estab_slep, by = "rbd")

# Validacion H6: reporta el delta de dependencia (vigente vs por-evaluacion) y
# asegura que ningun RBD del motor pierde dependencia (coalesce cubre los faltantes).
depe2_idps_rbd <- P |> dplyr::distinct(rbd, cod_depe2) |> dplyr::rename(depe2_idps = cod_depe2)
chk_h6 <- est_attr |> dplyr::distinct(rbd, cod_depe2) |>
  dplyr::left_join(depe2_idps_rbd, by = "rbd")
n_sin_dep <- sum(is.na(chk_h6$cod_depe2))
n_recl    <- sum(!is.na(chk_h6$cod_depe2) & !is.na(chk_h6$depe2_idps) &
                   chk_h6$cod_depe2 != chk_h6$depe2_idps)
stopifnot("H6: hay RBD del motor sin dependencia resuelta" = n_sin_dep == 0)
fmt_tab <- function(x) paste(sprintf("%s=%d", names(table(x)), as.integer(table(x))), collapse = ", ")
message(sprintf("[H6] Dependencia reclasificada en %d RBD (vigencia actual del directorio).", n_recl))
message(sprintf("     antes (idps): %s", fmt_tab(chk_h6$depe2_idps)))
message(sprintf("     ahora (dir):  %s", fmt_tab(chk_h6$cod_depe2)))

establecimientos_lst <- est_attr |>
  dplyr::transmute(rbd, nom, cod_com, cod_reg, cod_slep, cod_depe2) |>
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

# SLEPs con datos, con su region (via la geo del directorio).
sleps_lst <- est_attr |>
  dplyr::filter(!is.na(cod_slep)) |>
  dplyr::distinct(cod_slep, nombre_slep, cod_reg) |>
  dplyr::distinct() |>
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

meta <- list(
  fecha_generacion = format(Sys.Date()),
  cobertura = "Todo Chile",
  region_foco = REGION_FOCO, slep_foco = if (length(slep_foco)) slep_foco else NULL,
  grados = as.list(grados_lbl), grado_anios = grado_anios, anios_preliminar = I(anios_prelim),
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
