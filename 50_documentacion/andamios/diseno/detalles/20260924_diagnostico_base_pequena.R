# 20260924_diagnostico_base_pequena.R — s33m T1 (pendiente 5)
#
# Diagnóstico de "base pequeña" en las barras 0–100 del comparador (decisión de
# contraste, §5.2). Réplica en R de la cadena del motor
# (30_procesamiento/35_motor_template.html):
#   rosterTerr(t, grado, agno)   -> EE del roster del nivel y año que caen en la entidad
#                                   (comuna / SLEP / región acotan; nacional no filtra)
#   repartoInd(items, ind, ...)  -> por GSE e indicador: N = bajo + neutro + sobre
#                                   (prom no nulo y sigdifgru en {-1, 0, 1});
#                                   sin = prom no nulo y sigdifgru nulo (fuera del 100 %)
# y de cómo 35_generar_motor_html.R arma DATA.roster, DATA.ind y DATA.establecimientos
# (comuna y región del directorio público con respaldo en idps_largo; SLEP de
# sleps_chile; prom redondeado a entero, s14).
#
# Solo lectura: no escribe en 40_salidas ni en docs/. Sin nombres de establecimiento
# ni RBD en la salida: la unidad del informe es la barra (entidad × GSE × indicador).
#
# Uso (desde la raíz del repositorio):
#   Rscript 50_documentacion/andamios/diseno/detalles/20260924_diagnostico_base_pequena.R
#       -> escribe el informe .md junto a este script
#   Rscript <este archivo> --solo-barras <ruta.csv>
#       -> solo vuelca todas las barras a <ruta.csv> (control contra el motor, M4)

suppressMessages({
  library(arrow)
  library(dplyr)
})
stopifnot("dplyr >= 1.1 (usa .by= y cross_join)" = utils::packageVersion("dplyr") >= "1.1.0")
source(here::here("10_utils", "10_configuracion.R"))

args <- commandArgs(trailingOnly = TRUE)
solo_barras <- length(args) >= 2 && args[1] == "--solo-barras"

# ---------------------------------------------------------------------------
# 1. Insumos (los mismos que lee 35_generar_motor_html.R)
# ---------------------------------------------------------------------------
ruta_largo <- here::here("40_salidas", "intermedios", "idps_largo.parquet")
P <- arrow::read_parquet(ruta_largo) |>
  # Universo del motor: solo GRADOS_MOTOR y sin la fila fantasma rbd = NA (H-FID-1).
  filter(grado %in% GRADOS_MOTOR, !is.na(rbd))
SLE <- arrow::read_parquet(here::here("40_salidas", "intermedios", "sleps_chile.parquet"))
COM <- arrow::read_parquet(here::here("40_salidas", "intermedios", "comunas_chile.parquet"))
DIR <- readr::read_delim(
  here::here("20_insumos", "auxiliares", "directorio_oficial_ee_publico.csv"),
  delim = ";", locale = readr::locale(encoding = "UTF-8"),
  show_col_types = FALSE, progress = FALSE,
  col_types = readr::cols(.default = readr::col_character()))

# ---------------------------------------------------------------------------
# 2. Atributos territoriales por RBD (espejo de est_attr del generador)
# ---------------------------------------------------------------------------
dir_attr <- DIR |>
  transmute(rbd = as.character(RBD),
            cod_com_dir = as.character(COD_COM_RBD),
            cod_reg_dir = as.character(COD_REG_RBD)) |>
  distinct(rbd, .keep_all = TRUE)

est <- P |>
  # Un registro por RBD: el del año más reciente (igual que el generador).
  arrange(rbd, desc(agno)) |>
  distinct(rbd, .keep_all = TRUE) |>
  select(rbd, cod_com_rbd, cod_reg_rbd) |>
  left_join(dir_attr, by = "rbd") |>
  transmute(rbd,
            cod_com = coalesce(cod_com_dir, cod_com_rbd),
            cod_reg = coalesce(cod_reg_dir, cod_reg_rbd)) |>
  left_join(distinct(SLE, rbd, cod_slep) |> mutate(cod_slep = as.character(cod_slep)),
            by = "rbd")

# ---------------------------------------------------------------------------
# 3. Roster e indicadores (espejo de DATA.roster y DATA.ind)
# ---------------------------------------------------------------------------
roster <- P |>
  filter(familia == "indicador") |>
  distinct(rbd, grado, agno, cod_grupo) |>
  mutate(agno = as.integer(agno))

ind <- P |>
  filter(familia == "indicador") |>
  transmute(rbd, grado, agno = as.integer(agno), ind = as.integer(id_indicador),
            prom = round(prom, 0), sigdifgru)

# ---------------------------------------------------------------------------
# 4. Barras: nivel (año más reciente) × tipo × entidad × GSE × indicador
# ---------------------------------------------------------------------------
TIPOS <- c(comuna = "cod_com", slep = "cod_slep", region = "cod_reg", nacional = "cod_nac")

barras_nivel <- function(g) {
  y <- max(roster$agno[roster$grado == g])
  largo <- roster |>
    filter(grado == g, agno == y, cod_grupo %in% names(GSE_LABELS)) |>
    # rosterTerr: un RBD sin atributos no entra (if(!e) continue).
    inner_join(est, by = "rbd") |>
    mutate(cod_nac = "CL") |>
    cross_join(tibble(ind = 1:4)) |>
    left_join(filter(ind, grado == g, agno == y) |> select(rbd, ind, prom, sigdifgru),
              by = c("rbd", "ind")) |>
    # repartoInd: sin fila o prom nulo -> no cuenta; el resto se clasifica por sigdifgru.
    mutate(estado = case_when(is.na(prom)      ~ "fuera",
                              sigdifgru == -1L ~ "bajo",
                              sigdifgru ==  0L ~ "neutro",
                              sigdifgru ==  1L ~ "sobre",
                              is.na(sigdifgru) ~ "sin"))
  stopifnot("estado sin clasificar" = !anyNA(largo$estado))
  bind_rows(lapply(names(TIPOS), function(tp) {
    largo |>
      mutate(cod = .data[[TIPOS[[tp]]]]) |>
      filter(!is.na(cod)) |>
      summarise(total  = n(),
                bajo   = sum(estado == "bajo"),
                neutro = sum(estado == "neutro"),
                sobre  = sum(estado == "sobre"),
                sin    = sum(estado == "sin"),
                .by = c(cod, cod_grupo, ind)) |>
      mutate(tipo = tp, .before = 1)
  })) |>
    mutate(nivel = g, agno = y, N = bajo + neutro + sobre, .before = 1) |>
    rename(gse = cod_grupo)
}

nombre_entidad <- function(tipo, cod) {
  com <- distinct(COM, cod = as.character(cod_com_rbd), nom = nom_com_rbd) |>
    distinct(cod, .keep_all = TRUE)
  slp <- distinct(SLE, cod = as.character(cod_slep), nom = nombre_slep) |>
    distinct(cod, .keep_all = TRUE)
  tipo <- rep_len(tipo, length(cod))
  out <- rep(NA_character_, length(cod))
  out[tipo == "comuna"]   <- com$nom[match(cod[tipo == "comuna"], com$cod)]
  out[tipo == "slep"]     <- paste("SLEP", slp$nom[match(cod[tipo == "slep"], slp$cod)])
  out[tipo == "region"]   <- unname(NOMBRES_REGION[cod[tipo == "region"]])
  out[tipo == "nacional"] <- "Chile"
  out
}

barras <- bind_rows(lapply(GRADOS_MOTOR, barras_nivel)) |>
  mutate(nombre = nombre_entidad(tipo, cod), .after = cod) |>
  arrange(match(nivel, GRADOS_MOTOR), match(tipo, names(TIPOS)), cod, gse, ind) |>
  select(nivel, agno, tipo, cod, nombre, gse, ind, total, N, bajo, neutro, sobre, sin)

if (solo_barras) {
  readr::write_csv(barras, args[2], na = "")
  message(sprintf("barras: %d filas -> %s", nrow(barras), args[2]))
  quit(save = "no", status = 0)
}

# ---------------------------------------------------------------------------
# 5. Informe (Markdown). Sin fecha de corrida: dos corridas dan el mismo archivo.
# ---------------------------------------------------------------------------
UMBRALES <- c(5L, 10L, 15L, 20L, 30L)
TIPO_LBL <- c(comuna = "Comuna", slep = "SLEP", region = "Región", nacional = "Nacional")
IND_CORTO <- c("1" = "Autoestima", "2" = "Convivencia", "3" = "Participación", "4" = "Hábitos")
TERR <- c("comuna", "slep", "region")

fmt_n <- function(x) formatC(x, format = "d", big.mark = ".", decimal.mark = ",")
fmt_p <- function(x) paste0(formatC(x, format = "f", digits = 1, decimal.mark = ","), " %")
nivel_lbl <- function(g) vapply(g, function(x) paste0(GRADO_LABELS[[x]], " ", max(barras$agno[barras$nivel == x])),
                                 character(1), USE.NAMES = FALSE)
md_tabla <- function(df) {
  c(paste0("| ", paste(names(df), collapse = " | "), " |"),
    paste0("|", paste(ifelse(names(df) %in% c("Nivel", "Tipo", "GSE"), "---", "---:"), collapse = "|"), "|"),
    apply(df, 1, function(f) paste0("| ", paste(f, collapse = " | "), " |")))
}

# 5.1 Barras por tipo y nivel
t_barras <- barras |>
  summarise(entidades = n_distinct(cod), barras = n(),
            n0 = sum(N == 0L), n0_sin = sum(N == 0L & sin > 0L), con_sin = sum(sin > 0L),
            .by = c(nivel, tipo)) |>
  arrange(match(nivel, GRADOS_MOTOR), match(tipo, names(TIPOS)))

# 5.2 Distribución de N (cuartiles type = 1: valores observados)
cuart <- function(x) quantile(x, c(.25, .5, .75), type = 1, names = FALSE)
t_dist <- bind_rows(
  barras |> mutate(grupo = nivel_lbl(nivel)),
  barras |> mutate(grupo = "ambos niveles")) |>
  summarise(barras = n(), minimo = min(N), q1 = cuart(N)[1], mediana = cuart(N)[2],
            q3 = cuart(N)[3], maximo = max(N), .by = c(grupo, tipo)) |>
  arrange(match(grupo, c(sapply(GRADOS_MOTOR, nivel_lbl), "ambos niveles")), match(tipo, names(TIPOS)))

# 5.3 Umbrales: marcada = 1 <= N < u (N = 0 ya se dibuja como "sin dato", sin barra)
marca <- function(df, grupo) {
  bind_rows(lapply(UMBRALES, function(u) df |>
    summarise(barras = n(), n0 = sum(N == 0L), marcadas = sum(N >= 1L & N < u),
              igual_u = sum(N == u), .by = all_of(grupo)) |>
    mutate(u = u)))
}
t_umb <- bind_rows(
  marca(barras, c("nivel", "tipo")),
  marca(filter(barras, tipo %in% TERR) |> mutate(tipo = "terr"), c("nivel", "tipo"))) |>
  mutate(pct = 100 * marcadas / barras)

# 5.4 N distinto entre los cuatro indicadores de una fila (entidad × GSE)
t_fila <- barras |>
  summarise(rango = max(N) - min(N), .by = c(nivel, tipo, cod, gse)) |>
  summarise(filas = n(), distintas = sum(rango > 0L), rango_max = max(rango), .by = c(nivel, tipo)) |>
  arrange(match(nivel, GRADOS_MOTOR), match(tipo, names(TIPOS)))

# 5.5 SLEP foco y sus comunas
foco_slep <- as.character(unique(SLE$cod_slep[SLE$nombre_slep == "Costa Central"]))
foco_com  <- as.character(sort(unique(SLE$cod_com_rbd[SLE$nombre_slep == "Costa Central"])))
tabla_entidad <- function(g, tp, cd) {
  b <- filter(barras, nivel == g, tipo == tp, cod == cd)
  filas <- lapply(names(GSE_LABELS), function(k) {
    x <- filter(b, gse == k)
    if (nrow(x) == 0L) return(c(unname(GSE_LABELS[k]), "0", rep("—", 4)))
    celdas <- vapply(1:4, function(i) { y <- filter(x, ind == i)
      paste0(y$N, if (y$sin > 0L) paste0(" (+", y$sin, ")") else "") }, character(1))
    c(unname(GSE_LABELS[k]), fmt_n(x$total[1]), celdas)
  })
  df <- as.data.frame(do.call(rbind, filas))
  names(df) <- c("GSE", "EE en el roster", unname(IND_CORTO))
  md_tabla(df)
}

# 5.6 Insumos (reproducibilidad)
md5_in <- unname(tools::md5sum(ruta_largo))

tot <- function(g, tps) sum(t_barras$barras[t_barras$nivel == g & t_barras$tipo %in% tps])
L <- c(
  "# Diagnóstico de base pequeña en las barras del comparador (s33m T1, pendiente 5)",
  "",
  "> Documento **generado** por `20260924_diagnostico_base_pequena.R` (misma carpeta); no se edita a mano.",
  "> Presenta evidencia para la decisión metodológica de §5.2 de `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`",
  "> (marca de \"base pequeña\"). **No recomienda un umbral**: la decisión es del titular.",
  "",
  "## 1. Qué es N y de dónde sale",
  "",
  "- En cada barra 0–100 de una entidad del comparador, `N` = establecimientos del roster del nivel y del año de esa entidad, en ese GSE,",
  "  con puntaje (`prom` no nulo) **y** comparación válida con su GSE (`sigdifgru` en −1, 0 o 1). Los que tienen puntaje pero `sigdifgru`",
  "  nulo se cuentan aparte (`sin`) y no entran en el 100 % (la nota \"+k sin comparación válida\" bajo la barra).",
  "- Hoy `N` solo se lee en el `title` de la barra (\"100% = N establecimientos con comparación válida\"). §5.2 describe dos piezas: el `N`",
  "  visible bajo el nombre de la entidad y una marca cuando `N` cae bajo un umbral.",
  "- El cálculo replica en R `rosterTerr` y `repartoInd` del motor (`30_procesamiento/35_motor_template.html`) y el armado de",
  "  `DATA.roster`, `DATA.ind` y `DATA.establecimientos` (`30_procesamiento/35_generar_motor_html.R`). La réplica se validó contra la",
  "  pantalla del motor (`40_salidas/motor_idps.html`, md5 `7ad76f36e42d66c4da2d71aa28a558eb`) con Puppeteer: 12 barras de control",
  "  iguales en `N` y `sin` (log `50_documentacion/andamios/logs/20260924_preparacion_decisiones_s33m_log.md`, M4); la auditoría del",
  "  mismo log (FASE R) contrasta barras adicionales.",
  paste0("- Insumo: `40_salidas/intermedios/idps_largo.parquet` (md5 `", md5_in, "`), más el directorio público, `sleps_chile` y `comunas_chile`."),
  paste0("- Universo: para cada nivel del motor, su año más reciente (", paste(sapply(GRADOS_MOTOR, nivel_lbl), collapse = " y "),
         "; el comparador no tiene selector de año); entidades sin dependencia de los tipos comuna, SLEP y región, y la entidad nacional",
         " aparte; cada GSE con al menos un establecimiento en el roster de la entidad; los cuatro indicadores. Una **barra** es una",
         " celda entidad × GSE × indicador."),
  "- **Barra marcada con el umbral u**: `1 ≤ N < u` (\"cae bajo un umbral\", §5.2). Las barras con `N = 0` ya se dibujan como \"sin dato\"",
  "  (no hay barra que marcar) y se cuentan en su propia columna.",
  "",
  "## 2. Barras por tipo y nivel",
  "",
  md_tabla(transmute(t_barras, Nivel = sapply(nivel, nivel_lbl), Tipo = TIPO_LBL[tipo],
                     `Entidades con barras` = fmt_n(entidades), Barras = fmt_n(barras),
                     `Con N = 0` = fmt_n(n0), `Con sin > 0` = fmt_n(con_sin))),
  "",
  paste0("Total sin la entidad nacional: ", paste(sapply(GRADOS_MOTOR, function(g)
    paste0(fmt_n(tot(g, TERR)), " barras en ", nivel_lbl(g))), collapse = " y "), "."),
  "",
  "## 3. Distribución de N por tipo",
  "",
  "Cuartiles con `quantile(type = 1)` (valores observados de N).",
  "",
  md_tabla(transmute(t_dist, Nivel = grupo, Tipo = TIPO_LBL[tipo], Barras = fmt_n(barras),
                     `Mínimo` = fmt_n(minimo), Q1 = fmt_n(q1), Mediana = fmt_n(mediana),
                     Q3 = fmt_n(q3), `Máximo` = fmt_n(maximo))),
  "",
  "## 4. Barras que quedarían marcadas según el umbral",
  "",
  "Cada celda: barras con `1 ≤ N < u` y su porcentaje sobre todas las barras de la fila (incluidas las de `N = 0`).",
  "La fila \"Comuna + SLEP + Región\" excluye la entidad nacional.",
  "",
  md_tabla({
    w <- t_umb |>
      mutate(celda = paste0(fmt_n(marcadas), " (", fmt_p(pct), ")")) |>
      select(nivel, tipo, barras, n0, u, celda) |>
      tidyr::pivot_wider(names_from = u, values_from = celda, names_prefix = "u = ") |>
      arrange(match(nivel, GRADOS_MOTOR), match(tipo, c(TERR, "terr", "nacional")))
    transmute(w, Nivel = sapply(nivel, nivel_lbl),
              Tipo = ifelse(tipo == "terr", "Comuna + SLEP + Región", TIPO_LBL[tipo]),
              Barras = fmt_n(barras), `N = 0` = fmt_n(n0),
              !!!rlang::set_names(lapply(paste0("u = ", UMBRALES), as.name), paste0("u = ", UMBRALES)))
  }),
  "",
  "Barras con `N` exactamente igual al umbral (lo que agregaría leer la marca como `N ≤ u` en lugar de `N < u`):",
  "",
  md_tabla({
    w <- t_umb |> select(nivel, tipo, u, igual_u) |> mutate(igual_u = fmt_n(igual_u)) |>
      tidyr::pivot_wider(names_from = u, values_from = igual_u, names_prefix = "N = ") |>
      arrange(match(nivel, GRADOS_MOTOR), match(tipo, c(TERR, "terr", "nacional")))
    w |> mutate(nivel = sapply(nivel, nivel_lbl),
                tipo = ifelse(tipo == "terr", "Comuna + SLEP + Región", TIPO_LBL[tipo])) |>
      rename(Nivel = nivel, Tipo = tipo)
  }),
  "",
  "## 5. El SLEP foco y sus cuatro comunas, barra por barra",
  "",
  "Cada celda: `N` y, entre paréntesis, los establecimientos con puntaje sin comparación válida (`+sin`). \"EE en el roster\": establecimientos",
  "de la entidad en ese GSE, nivel y año (con o sin puntaje). Una fila con 0 no tiene barra (el motor dice \"sin dato\"). La barra del SLEP",
  "cuenta solo los establecimientos del SLEP; la de cada comuna cuenta todos los de la comuna, de cualquier dependencia.",
  "",
  unlist(lapply(GRADOS_MOTOR, function(g) c(
    paste0("### ", nivel_lbl(g)), "",
    unlist(lapply(c(paste0("slep:", foco_slep), paste0("comuna:", foco_com[order(nombre_entidad("comuna", foco_com))])), function(k) {
      tp <- sub(":.*", "", k); cd <- sub(".*:", "", k)
      c(paste0("**", nombre_entidad(tp, cd), "**"), "", tabla_entidad(g, tp, cd), "")
    }))))),
  "## 6. Barras con N = 0",
  "",
  md_tabla(transmute(t_barras, Nivel = sapply(nivel, nivel_lbl), Tipo = TIPO_LBL[tipo],
                     `Con N = 0` = fmt_n(n0), `De ellas, con sin > 0` = fmt_n(n0_sin),
                     `De ellas, sin = 0 (ningún EE con puntaje)` = fmt_n(n0 - n0_sin))),
  "",
  "## 7. N distinto entre los cuatro indicadores de una misma fila",
  "",
  "§5.2 habla del \"N de la fila\" bajo el nombre de la entidad. Una fila del comparador (entidad × GSE) tiene cuatro barras, y su `N`",
  "puede diferir entre indicadores (puntaje o comparación publicados para unos indicadores y no para otros).",
  "",
  md_tabla(transmute(t_fila, Nivel = sapply(nivel, nivel_lbl), Tipo = TIPO_LBL[tipo], Filas = fmt_n(filas),
                     `Filas con N distinto entre indicadores` = fmt_n(distintas),
                     `Diferencia máxima (máx − mín) en una fila` = fmt_n(rango_max))),
  "",
  "## 8. Alcance y límites",
  "",
  "- Solo entidades **sin dependencia**. El comparador también admite la misma entidad acotada a una dependencia (clave `kind|cod|dep`);",
  "  ahí `N` es igual o menor que el de la entidad completa. No se midió.",
  "- Solo el año más reciente de cada nivel, que es el único que muestra el comparador.",
  "- La misma barra (`StackedBar` con `repartoInd`) aparece en el panorama territorial (Vista actual, por GSE) y en la franja de la vista",
  "  histórica del panorama (por año). Este diagnóstico cuenta las barras del comparador; no midió esas dos pantallas.",
  "",
  "## 9. Lo que el titular decide",
  "",
  "Ninguna de estas preguntas se responde aquí; cada una con sus alternativas cerradas.",
  "",
  "1. **El umbral u.** ¿Qué valor fija la decisión de proyecto que pide §5.2? La tabla de §4 muestra qué fracción de barras marcaría",
  "   cada valor medido (5, 10, 15, 20, 30) por tipo y nivel; otro valor exige volver a correr el script.",
  "2. **La desigualdad.** ¿La marca aplica con `N < u` (lectura literal de \"cae bajo un umbral\", la usada en §4) o con `N ≤ u`",
  "   (la tabla de §4 da cuántas barras agrega)?",
  "3. **El alcance por tipo.** ¿El mismo umbral para comuna, SLEP, región y nacional, y para las entidades con dependencia, o umbrales",
  "   distintos por tipo?",
  "4. **El N visible de la fila (pieza 1 de §5.2).** Como el `N` difiere entre indicadores en parte de las filas (§7), ¿qué se muestra",
  "   bajo el nombre: (a) los establecimientos del roster de la fila; (b) el `N` de cada barra, junto a la barra; (c) el mínimo de la fila?",
  "5. **Las otras pantallas.** ¿La marca se limita al comparador o alcanza también las barras del panorama (Vista actual y vista histórica)?",
  "6. **Las barras con N = 0.** Hoy dicen \"sin dato\" (y la nota `sin` cuando corresponde). ¿Quedan así o reciben la misma marca?",
  ""
)

ruta_md <- here::here("50_documentacion", "andamios", "diseno", "detalles", "20260924_diagnostico_base_pequena.md")
con <- file(ruta_md, open = "w", encoding = "UTF-8")
writeLines(L, con)
close(con)
message(sprintf("informe: %d líneas -> %s", length(L), sub(paste0(here::here(), "/"), "", ruta_md)))
