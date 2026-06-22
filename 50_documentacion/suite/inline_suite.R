# ============================================================================
#  inline_suite.R — vuelve AUTOCONTENIDOS los HTML de una suite `suitedoc`
# ----------------------------------------------------------------------------
#  Problema que resuelve: generar_suite() produce HTML que enlazan el tema por
#  ruta relativa (<link rel="stylesheet" href="suite_estilos.css">, y el CSS a
#  su vez referencia fonts/*.otf y assets/*.png con url(...)). Al compartir un
#  HTML suelto, sin la carpeta del tema al lado, se ve sin estilos.
#
#  Este script toma los 4 HTML de la suite y produce versiones autocontenidas
#  (sufijo _standalone.html) con TODO embebido en base64: el CSS inline en un
#  <style>, y dentro de ese CSS las fuentes y logos como data: URIs. El HTML
#  resultante se abre con estilo completo desde cualquier carpeta, sin depender
#  del tema. Mismo patrón de embebido que usa 35_generar_motor_html.R para las
#  fuentes del motor.
#
#  Uso (desde la raíz del proyecto, con el tema ya en la carpeta de la suite):
#      source(here::here("50_documentacion", "suite", "inline_suite.R"))
#  o, si se copia a herramientas_dev/, llamando inline_suite(dir_suite).
#
#  Reutilizable en cualquier proyecto con suitedoc: solo cambia el directorio.
# ============================================================================

library(here)

# ---- Parámetros ------------------------------------------------------------
# Directorio donde viven los HTML + suite_estilos.css + fonts/ + assets/.
DIR_SUITE <- here::here("50_documentacion", "suite")

# MIME por extensión (para el data: URI).
.mime <- function(ext) {
  switch(tolower(ext),
    otf = "font/otf", ttf = "font/ttf", woff = "font/woff", woff2 = "font/woff2",
    png = "image/png", jpg = "image/jpeg", jpeg = "image/jpeg",
    svg = "image/svg+xml", gif = "image/gif", webp = "image/webp",
    "application/octet-stream")
}

# Codifica un archivo local a data: URI base64. Devuelve NA si no existe.
.data_uri <- function(ruta) {
  if (!file.exists(ruta)) {
    warning(sprintf("No existe (se deja la url tal cual): %s", ruta))
    return(NA_character_)
  }
  bytes <- readBin(ruta, what = "raw", n = file.info(ruta)$size)
  # base64_enc envuelve en lineas de 76 chars (estilo MIME); un salto de linea
  # dentro de url('data:...') INVALIDA la regla CSS (el navegador deja de parsear).
  # Se quitan los saltos -> data URI de una sola linea, como hace 35 con el JSON.
  b64   <- gsub("[\r\n]", "", jsonlite::base64_enc(bytes))
  ext   <- tools::file_ext(ruta)
  sprintf("data:%s;base64,%s", .mime(ext), b64)
}

# Reescribe todas las url(...) locales de un bloque CSS a data: URIs. Las rutas
# del CSS son relativas al propio CSS (que vive en dir_tema).
.inline_css_urls <- function(css, dir_tema) {
  # Captura url( opcional comillas  ruta  opcional comillas ). Ignora data: y http.
  patron <- "url\\(\\s*['\"]?([^'\")]+)['\"]?\\s*\\)"
  m <- gregexpr(patron, css, perl = TRUE)
  refs <- regmatches(css, m)[[1]]
  if (length(refs) == 0) return(css)
  for (ref in unique(refs)) {
    ruta_rel <- sub(patron, "\\1", ref, perl = TRUE)
    if (grepl("^(data:|https?:|//)", ruta_rel)) next     # ya embebido o remoto
    ruta_abs <- file.path(dir_tema, ruta_rel)
    uri <- .data_uri(ruta_abs)
    if (is.na(uri)) next
    # Reemplazo literal del bloque url(...) completo por url('data:...').
    css <- gsub(ref, sprintf("url('%s')", uri), css, fixed = TRUE)
  }
  css
}

# Procesa un HTML: reemplaza el <link rel=stylesheet> por <style> con el CSS
# embebido (y sus url() inline), y embebe cualquier <img src> / logo local.
.inline_html <- function(ruta_html, dir_tema) {
  html <- paste(readLines(ruta_html, warn = FALSE, encoding = "UTF-8"),
                collapse = "\n")

  # 1) Localizar y leer el CSS enlazado.
  link_pat <- "<link[^>]*rel=[\"']stylesheet[\"'][^>]*href=[\"']([^\"']+)[\"'][^>]*>"
  # Extraer el href del grupo de captura con regexec (NO con
  # sub('.*'+pat+'.*','\\1',...): en PCRE '.*' no cruza saltos de linea y el HTML
  # es multilinea, asi que sub solo reemplazaba la linea del <link> y dejaba el
  # resto del documento dentro de href -> "CSS no encontrado: <doc completo>").
  mm   <- regmatches(html, regexec(link_pat, html, perl = TRUE))[[1]]
  href <- if (length(mm) >= 2) mm[2] else ""
  if (!nzchar(href)) {
    message(sprintf("  (%s) sin <link stylesheet>; se deja igual.", basename(ruta_html)))
  } else {
    ruta_css <- file.path(dir_tema, href)
    if (!file.exists(ruta_css)) {
      stop(sprintf("CSS no encontrado: %s", ruta_css))
    }
    css <- paste(readLines(ruta_css, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
    css <- .inline_css_urls(css, dir_tema)            # fuentes/logos del CSS -> base64
    style_block <- sprintf("<style>\n%s\n</style>", css)
    # Reemplazar el <link...> por el <style> embebido.
    html <- sub(link_pat, style_block, html, perl = TRUE)
  }

  # 2) Embeber <img src="..."> locales (logos referenciados directo en el HTML).
  img_pat <- "(<img[^>]*src=[\"'])([^\"']+)([\"'][^>]*>)"
  repeat {
    m <- regexpr(img_pat, html, perl = TRUE)
    if (m == -1) break
    full <- regmatches(html, m)
    src  <- sub(img_pat, "\\2", full, perl = TRUE)
    if (grepl("^(data:|https?:|//)", src)) {
      # ya embebido/remoto: marcar para no reprocesar (placeholder temporal)
      html <- sub(img_pat, "\\1__KEEP__\\2\\3", html, perl = TRUE)
      next
    }
    uri <- .data_uri(file.path(dir_tema, src))
    repl <- if (is.na(uri)) src else uri
    html <- sub(img_pat, paste0("\\1", repl, "\\3"), html, perl = TRUE)
  }
  html <- gsub("__KEEP__", "", html, fixed = TRUE)     # limpiar placeholders

  html
}

#' Vuelve autocontenidos todos los HTML de una suite suitedoc.
#' @param dir_suite carpeta con los *.html + suite_estilos.css + fonts/ + assets/
#' @param sufijo    sufijo del archivo de salida (default "_standalone")
inline_suite <- function(dir_suite = DIR_SUITE, sufijo = "_standalone") {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("Falta jsonlite (base64_enc). install.packages('jsonlite').")
  }
  htmls <- list.files(dir_suite, pattern = "\\.html$", full.names = TRUE)
  htmls <- htmls[!grepl(paste0(sufijo, "\\.html$"), htmls)]   # no reprocesar salidas
  if (length(htmls) == 0) stop("No hay HTML en ", dir_suite)

  generados <- character(0)
  for (h in htmls) {
    message(sprintf("Inline: %s", basename(h)))
    out_html <- .inline_html(h, dir_suite)
    destino  <- sub("\\.html$", paste0(sufijo, ".html"), h)
    writeLines(out_html, destino, useBytes = TRUE)
    generados <- c(generados, destino)
    message(sprintf("  -> %s (%.0f KB)", basename(destino),
                    file.info(destino)$size / 1024))
  }
  message(sprintf("\nListo: %d HTML autocontenidos en %s",
                  length(generados), dir_suite))
  message("Verificación: ábrelos desde CUALQUIER carpeta; deben verse con estilo.")
  invisible(generados)
}

# Ejecutar al hacer source().
inline_suite()
