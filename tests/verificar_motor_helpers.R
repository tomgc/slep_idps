# tests/verificar_motor_helpers.R
# -----------------------------------------------------------------------------
# Funciones del verificador del motor (tests/verificar_motor.R). Separadas para que
# otros scripts (por ejemplo, un control que altera una celda ancla a propósito)
# usen exactamente la misma extracción del payload y la misma regla de anclas.
# Ninguna función imprime RBD ni nombres de establecimiento.
# -----------------------------------------------------------------------------

# Niveles que publica el motor (el generador acota el dato a estos dos grados).
NIVELES_MOTOR <- c("4b", "2m")
# Semilla de la regla de celdas ancla: fija, para que la elección sea siempre la misma.
SEMILLA_ANCLAS <- 20260925L

# Lee un HTML completo como una sola cadena, sin reinterpretar sus bytes.
leer_html <- function(ruta) {
  rawToChar(readBin(ruta, what = "raw", n = file.size(ruta)))
}

# Extrae el payload que el generador pone en lugar de __JSON_DATA__
# (`pako.inflate(Uint8Array.from(atob("<base64>"), …))`): base64 de un JSON
# comprimido con memCompress(type = "gzip"). Devuelve el JSON como texto (bytes
# UTF-8 intactos) o NULL si no hay exactamente un payload o si el marcador quedó
# sin reemplazar.
extraer_payload <- function(html) {
  if (grepl("__JSON_DATA__", html, fixed = TRUE, useBytes = TRUE)) return(NULL)
  # regmatches() con useBytes corta en bytes (el HTML trae caracteres de varios bytes antes del payload).
  m <- regmatches(html, gregexpr('Uint8Array\\.from\\(atob\\("[A-Za-z0-9+/=]+"\\)', html, useBytes = TRUE))[[1]]
  if (length(m) != 1L) return(NULL)
  b64 <- sub('"\\)$', "", sub('^Uint8Array\\.from\\(atob\\("', "", m, useBytes = TRUE), useBytes = TRUE)
  json <- rawToChar(memDecompress(jsonlite::base64_dec(b64), type = "gzip"))
  Encoding(json) <- "UTF-8"
  json
}

# Hash del payload con la convención §8.2 (log de s29): sustituir
# "fecha_generacion":"AAAA-MM-DD" por "fecha_generacion":"0000-00-00" y calcular el
# SHA-256 del JSON en UTF-8, sin salto final. Exige exactamente una fecha.
hash_82 <- function(json) {
  patron <- '"fecha_generacion":"[0-9]{4}-[0-9]{2}-[0-9]{2}"'
  n_fechas <- lengths(regmatches(json, gregexpr(patron, json, useBytes = TRUE)))
  if (n_fechas != 1L) return(list(hash = NA_character_, n_fechas = n_fechas))
  norm <- sub(patron, '"fecha_generacion":"0000-00-00"', json, useBytes = TRUE)
  # as.character() de openssl conserva la clase "hash"; unclass() deja la cadena sola, comparable con identical().
  list(hash = unclass(as.character(openssl::sha256(charToRaw(norm)))), n_fechas = n_fechas)
}

# Marcas de que el HTML pediría algo a la red al abrirse (esperado: 0 de cada una).
contar_red <- function(html) {
  marcas <- c('src="http', 'href="http', "text/babel")
  vapply(marcas, \(x) lengths(regmatches(html, gregexpr(x, html, fixed = TRUE, useBytes = TRUE))), integer(1))
}

# Filas de indicador del parquet que alimentan el motor (mismo universo que el
# generador: familia "indicador", niveles del motor, RBD no nulo).
leer_indicadores <- function(ruta_parquet) {
  arrow::read_parquet(ruta_parquet,
                      col_select = c("rbd", "agno", "grado", "familia", "id_indicador",
                                     "prom", "difgru", "sigdifgru")) |>
    dplyr::filter(.data$familia == "indicador", .data$grado %in% NIVELES_MOTOR, !is.na(.data$rbd))
}

# Regla determinista de celdas ancla (sin RBD escritos en el código). Por cada nivel
# del motor, sobre las filas con puntaje:
#   - una por indicador en el último año, con sigdifgru publicado (4);
#   - una del último año sin sigdifgru (puntaje sin comparación válida);
#   - una en el primer año, una en el año del medio y una en el penúltimo año.
# Dentro de cada estrato, las filas se ordenan por (indicador, rbd) y se toma una con
# sample.int() tras set.seed(SEMILLA_ANCLAS), en el orden fijo de los estratos.
# Devuelve 16 celdas con su valor esperado (puntaje redondeado como en el payload,
# difgru y sigdifgru del parquet).
elegir_anclas <- function(ind) {
  RNGkind("Mersenne-Twister", "Inversion", "Rejection")
  set.seed(SEMILLA_ANCLAS)
  base <- dplyr::filter(ind, !is.na(.data$prom))
  tomar <- function(estrato, tipo) {
    if (nrow(estrato) == 0L) stop("estrato vacío en la regla de anclas: ", tipo)
    estrato <- dplyr::arrange(estrato, .data$id_indicador, .data$rbd)
    dplyr::mutate(estrato[sample.int(nrow(estrato), 1L), ], tipo = tipo)
  }
  anclas <- list()
  for (g in NIVELES_MOTOR) {
    bg <- dplyr::filter(base, .data$grado == g)
    anios <- sort(unique(bg$agno))
    ultimo <- anios[length(anios)]
    for (i in sort(unique(bg$id_indicador))) {
      anclas[[length(anclas) + 1L]] <- tomar(
        dplyr::filter(bg, .data$agno == ultimo, .data$id_indicador == i, !is.na(.data$sigdifgru)),
        "último año, con comparación")
    }
    anclas[[length(anclas) + 1L]] <- tomar(
      dplyr::filter(bg, .data$agno == ultimo, is.na(.data$sigdifgru)), "último año, sin comparación")
    for (par in list(c(anios[1], "primer año"), c(anios[ceiling(length(anios) / 2)], "año del medio"),
                     c(anios[length(anios) - 1L], "penúltimo año"))) {
      anclas[[length(anclas) + 1L]] <- tomar(dplyr::filter(bg, .data$agno == as.integer(par[1])), par[2])
    }
  }
  dplyr::bind_rows(anclas) |>
    dplyr::mutate(celda = dplyr::row_number(), prom_esperado = round(.data$prom, 0)) |>
    dplyr::select("celda", "tipo", "grado", "agno", "id_indicador", "rbd", "prom_esperado", "difgru", "sigdifgru")
}

# Cobertura que la regla debe cumplir (encargo s33u T1): ≥ 12 celdas, los dos niveles,
# ≥ 3 años, los cuatro indicadores y al menos una celda con sigdifgru nulo.
cobertura_anclas <- function(anclas) {
  c(celdas = nrow(anclas), niveles = dplyr::n_distinct(anclas$grado), anios = dplyr::n_distinct(anclas$agno),
    indicadores = dplyr::n_distinct(anclas$id_indicador), sigdifgru_nulo = sum(is.na(anclas$sigdifgru)))
}

# Posición (1-based) de cada celda ancla en el bloque `ind` del payload; NA si no
# está o si está más de una vez.
ubicar_anclas <- function(ind_payload, anclas) {
  clave_p <- paste(ind_payload$rbd, ind_payload$grado, ind_payload$agno, ind_payload$ind, sep = "|")
  clave_a <- paste(anclas$rbd, anclas$grado, anclas$agno, anclas$id_indicador, sep = "|")
  vapply(clave_a, \(k) { j <- which(clave_p == k); if (length(j) == 1L) j else NA_integer_ }, integer(1), USE.NAMES = FALSE)
}

# Compara cada celda ancla con el payload: puntaje (entero de presentación),
# difgru y sigdifgru (nulo = nulo). Devuelve un data frame sin la columna rbd.
comparar_anclas <- function(ind_payload, anclas) {
  j <- ubicar_anclas(ind_payload, anclas)
  igual <- \(a, b) (is.na(a) & is.na(b)) | (!is.na(a) & !is.na(b) & abs(a - b) < 1e-9)
  en <- \(v) ifelse(is.na(j), NA, v[j])
  anclas |>
    dplyr::mutate(
      en_payload = !is.na(j),
      ok_puntaje = .data$en_payload & igual(en(ind_payload$prom), .data$prom_esperado),
      ok_difgru = .data$en_payload & igual(en(ind_payload$difgru), .data$difgru),
      ok_sigdifgru = .data$en_payload & igual(en(ind_payload$sigdifgru), .data$sigdifgru),
      ok = .data$ok_puntaje & .data$ok_difgru & .data$ok_sigdifgru
    ) |>
    dplyr::select(-"rbd")
}
