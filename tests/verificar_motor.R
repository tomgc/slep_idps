# tests/verificar_motor.R
# -----------------------------------------------------------------------------
# Verificador versionado del motor IDPS (s33u T1; matriz de s33n §5.5).
#
# Propósito: que cualquiera compruebe, sin instrumentos externos, que el motor
# publicado (docs/index.html) y el construido (40_salidas/motor_idps.html) llevan el
# payload esperado, cuentan lo mismo que el dato y no piden nada a la red. Sale con
# código 1 ante cualquier falla y con 0 si todo cuadra.
#
# Uso, desde la raíz del proyecto (o desde cualquiera de sus subdirectorios,
# ajustando la ruta del script):
#   Rscript tests/verificar_motor.R                   # docs/index.html y el motor
#   Rscript tests/verificar_motor.R <html> [<html>]   # otros archivos (p. ej., una copia)
#
# Qué verifica, en cada HTML:
#   (i)   el hash del payload con la convención §8.2 (log de s29: la fecha de
#         generación se sustituye por 0000-00-00 y se calcula el SHA-256 del JSON en
#         UTF-8, sin salto final) contra HASH_ESPERADO;
#   (ii)  16 celdas ancla del payload frente a 40_salidas/intermedios/idps_largo.parquet:
#         puntaje (el entero de presentación, round(prom, 0)), difgru y sigdifgru, en
#         celdas elegidas por una regla determinista (verificar_motor_helpers.R) que
#         cubre los dos niveles, cuatro años, los cuatro indicadores y celdas sin
#         comparación válida (sigdifgru nulo);
#   (iii) que no pide nada a la red al abrirse: 0 `src="http`, 0 `href="http` y 0
#         `text/babel`;
# y, informativo, (iv) si los dos primeros archivos son el mismo (antes de desplegar
# difieren a propósito: eso no es falla).
#
# Qué no verifica: la pantalla, las exportaciones, la navegación, las dimensiones, los
# niveles de logro, el roster ni las etiquetas; tampoco el resto de las celdas (el hash
# §8.2 cubre el payload entero, pero contra un valor fijado, no contra el dato). No
# reemplaza la verificación de cada encargo.
#
# El valor de HASH_ESPERADO se cambia solo cuando cambia el dato publicado, en el mismo
# commit que construye el motor nuevo y con la razón en su log.
#
# No imprime RBD ni nombres de establecimiento.
# -----------------------------------------------------------------------------

suppressMessages(here::i_am("tests/verificar_motor.R"))
source(here::here("tests", "verificar_motor_helpers.R"))

HASH_ESPERADO <- "eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4"

args <- commandArgs(trailingOnly = TRUE)
rutas <- if (length(args) > 0L) {
  normalizePath(args, mustWork = FALSE)
} else {
  c(here::here("docs", "index.html"), here::here("40_salidas", "motor_idps.html"))
}
etiqueta <- \(r) if (length(args) > 0L) basename(r) else sub(paste0(here::here(), "/"), "", r, fixed = TRUE)

fallas <- 0L
informar <- function(ok, texto) {
  cat(if (ok) "[OK]    " else "[FALLA] ", texto, "\n", sep = "")
  if (!ok) fallas <<- fallas + 1L
}

# Celdas ancla: se eligen una vez, desde el parquet, y se buscan en cada payload.
ind <- leer_indicadores(here::here("40_salidas", "intermedios", "idps_largo.parquet"))
anclas <- elegir_anclas(ind)
cob <- cobertura_anclas(anclas)
informar(cob[["celdas"]] >= 12L && cob[["niveles"]] == length(NIVELES_MOTOR) && cob[["anios"]] >= 3L &&
           cob[["indicadores"]] == 4L && cob[["sigdifgru_nulo"]] >= 1L,
         sprintf("regla de anclas: %d celdas, %d niveles, %d años (%s), %d indicadores, %d con sigdifgru nulo",
                 cob[["celdas"]], cob[["niveles"]], cob[["anios"]], paste(sort(unique(anclas$agno)), collapse = ", "),
                 cob[["indicadores"]], cob[["sigdifgru_nulo"]]))

leidos <- list()   # payload ya leído, por hash (dos archivos con el mismo hash traen el mismo dato)
for (r in rutas) {
  e <- etiqueta(r)
  if (!file.exists(r)) { informar(FALSE, paste0(e, " · no existe")); next }
  html <- leer_html(r)
  json <- extraer_payload(html)
  if (is.null(json)) {
    informar(FALSE, paste0(e, " · payload: no hay exactamente uno (o quedó el marcador __JSON_DATA__)"))
  } else {
    h <- hash_82(json)
    informar(identical(h$hash, HASH_ESPERADO),
             sprintf("%s · hash §8.2 %s (%s)", e, if (is.na(h$hash)) paste0("sin calcular: ", h$n_fechas, " fechas de generación") else h$hash,
                     if (identical(h$hash, HASH_ESPERADO)) "= esperado" else paste0("esperado ", HASH_ESPERADO)))
    clave <- if (is.na(h$hash)) r else h$hash
    if (is.null(leidos[[clave]])) leidos[[clave]] <- jsonlite::fromJSON(json)$ind
    res <- comparar_anclas(leidos[[clave]], anclas)
    informar(all(res$ok), sprintf("%s · celdas ancla %d/%d iguales al parquet (puntaje, difgru, sigdifgru)", e, sum(res$ok), nrow(res)))
    for (k in which(!res$ok)) {
      x <- res[k, ]
      cat(sprintf("        celda %d (%s, %d, indicador %d, %s): %s\n", x$celda, x$grado, x$agno, x$id_indicador, x$tipo,
                  if (!x$en_payload) "no está en el payload (o está repetida)" else
                    paste(c("puntaje", "difgru", "sigdifgru")[!c(x$ok_puntaje, x$ok_difgru, x$ok_sigdifgru)], collapse = ", ")))
    }
  }
  red <- contar_red(html)
  informar(all(red == 0L), sprintf("%s · red: %d src=\"http, %d href=\"http, %d text/babel", e, red[[1]], red[[2]], red[[3]]))
}

if (length(rutas) >= 2L && all(file.exists(rutas[1:2]))) {
  m <- unname(tools::md5sum(rutas[1:2]))
  cat(sprintf("[INFO]  %s y %s: %s\n", etiqueta(rutas[1]), etiqueta(rutas[2]),
              if (identical(m[1], m[2])) paste("el mismo archivo, md5", m[1]) else paste("distintos, md5", m[1], "y", m[2])))
}

cat(if (fallas == 0L) "verificar_motor: todo cuadra\n" else sprintf("verificar_motor: %d falla(s)\n", fallas))
if (interactive()) {
  if (fallas > 0L) stop("verificar_motor: ", fallas, " falla(s)")
} else {
  quit(save = "no", status = if (fallas == 0L) 0L else 1L)
}
