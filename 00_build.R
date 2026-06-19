# ==============================================================================
# 00_build.R — Orquestador del pipeline slep_idps (punto de entrada unico)
# ------------------------------------------------------------------------------
# Ejecuta en orden los pasos de 30_procesamiento/:
#   31. 31_depurar_directorio_oficial.R  depura el directorio (saca RUT/MRUN)
#   32. 32_censo_insumos.R               perfila las tablas IDPS (censo P5)
#   33. 33_construir_catalogos.R         catalogos territoriales + jerarquia IDPS
#   34. 34_leer_normalizar_idps.R        3 familias -> homologacion -> join ->
#                                        idps_largo.parquet (SIN agregacion)
#   35. 35_generar_motor_html.R          motor HTML autocontenido (P9, pendiente)
#
# Solo orquesta: cero logica de negocio, sin cache por timestamp. Los ids de
# paso coinciden con el prefijo del script, asi run_all(only = 35) regenera
# solo el motor sin recorrer el pipeline.
#
# NOTA DE ALCANCE (decision 2026-06-12): el motor NO agrega a nivel territorial.
# Por eso NO existe un paso de "agregacion": el dato viaja al nivel en que la
# Agencia lo publica (establecimiento). No reintroducir una etapa de agregado.
#
# Uso:
#   source(here::here("00_build.R"))
#   run_all()                   # todos los pasos disponibles, en orden
#   run_all(from = 33)          # desde catalogos (reusa directorio depurado)
#   run_all(only = 34)          # solo lectura/normalizacion
#   run_all(only = 35)          # solo el motor HTML  (= regenerar_motor())
# ==============================================================================

# ---- Anclaje de raiz (criterios .Rproj / .git / .here) ---------------------
raiz <- rprojroot::find_root(
  rprojroot::has_file(".here") |
    rprojroot::is_rstudio_project |
    rprojroot::is_git_root
)

# ---- Bootstrapping: utils y configuracion antes de cualquier library() -----
source(file.path(raiz, "10_utils", "10_utils.R"))
source(file.path(raiz, "10_utils", "10_configuracion.R"))

# ---- Precondiciones: paquetes del pipeline ---------------------------------
instalar_si_falta(c(
  "here", "fs", "readr", "readxl", "dplyr", "tidyr", "purrr",
  "tibble", "stringr", "arrow", "jsonlite", "rprojroot"
))


# ============================================================================
# Definicion de pasos
# ============================================================================
# id (coincide con el prefijo del script), etiqueta, ruta relativa a la raiz.
PASOS <- list(
  list(id = 31L, etiqueta = "Depurar directorio oficial (saca RUT/MRUN)",
       ruta = file.path("30_procesamiento", "31_depurar_directorio_oficial.R")),
  list(id = 32L, etiqueta = "Censo de insumos IDPS (perfilado)",
       ruta = file.path("30_procesamiento", "32_censo_insumos.R")),
  list(id = 33L, etiqueta = "Construir catalogos (territoriales + jerarquia IDPS)",
       ruta = file.path("30_procesamiento", "33_construir_catalogos.R")),
  list(id = 34L, etiqueta = "Leer y normalizar IDPS (3 familias -> parquet largo)",
       ruta = file.path("30_procesamiento", "34_leer_normalizar_idps.R")),
  list(id = 35L, etiqueta = "Generar motor HTML autocontenido (pendiente)",
       ruta = file.path("30_procesamiento", "35_generar_motor_html.R"))
)


# ============================================================================
# run_all()
# ============================================================================

#' Ejecutar el pipeline completo o un subconjunto de pasos.
#'
#' @param from Integer. Primer paso a ejecutar (default: el menor disponible).
#' @param to   Integer. Ultimo paso a ejecutar (default: el mayor disponible).
#' @param only Integer vector. Ejecutar exactamente estos pasos (ignora from/to).
#' @param skip Integer vector. Pasos a omitir.
#' @return Invisible NULL. Emite log de progreso y resumen final.
run_all <- function(from = NULL, to = NULL, only = NULL, skip = NULL) {

  ids_def <- vapply(PASOS, function(p) p$id, integer(1))

  ids_existentes <- ids_def[vapply(PASOS, function(p) {
    file.exists(file.path(raiz, p$ruta))
  }, logical(1))]

  ids_ausentes <- setdiff(ids_def, ids_existentes)
  for (id in ids_ausentes) {
    p <- PASOS[[which(ids_def == id)]]
    log_msg(sprintf("Paso %d ausente (aun no construido): %s", id, p$ruta),
            "WARN", "run_all")
  }

  if (!is.null(only)) {
    seleccion <- intersect(ids_existentes, only)
  } else {
    lo <- if (is.null(from)) min(ids_existentes) else from
    hi <- if (is.null(to))   max(ids_existentes) else to
    seleccion <- ids_existentes[ids_existentes >= lo & ids_existentes <= hi]
  }
  if (!is.null(skip)) seleccion <- setdiff(seleccion, skip)
  seleccion <- sort(seleccion)

  if (length(seleccion) == 0) {
    log_msg("Ningun paso seleccionado para ejecutar.", "WARN", "run_all")
    return(invisible(NULL))
  }

  t0_total <- proc.time()
  ejecutados <- integer(0)

  for (id in seleccion) {
    p <- PASOS[[which(ids_def == id)]]
    ruta_abs <- file.path(raiz, p$ruta)

    message("")
    message(strrep("=", 70))
    log_msg(sprintf("PASO %d — %s", p$id, p$etiqueta), "INFO", "run_all")
    message(strrep("=", 70))

    t0 <- proc.time()
    ok <- tryCatch({
      source(ruta_abs, echo = FALSE, chdir = TRUE)
      TRUE
    }, error = function(e) {
      log_msg(sprintf("FALLO en paso %d: %s", p$id, conditionMessage(e)),
              "ERROR", "run_all")
      FALSE
    })
    dt <- round((proc.time() - t0)[["elapsed"]], 1)
    if (!ok) {
      stop(sprintf("Pipeline detenido en el paso %d (%s).", p$id, p$etiqueta),
           call. = FALSE)
    }
    log_msg(sprintf("Paso %d OK en %.1f s.", p$id, dt), "INFO", "run_all")
    ejecutados <- c(ejecutados, id)
  }

  dt_total <- round((proc.time() - t0_total)[["elapsed"]], 1)
  saltados <- setdiff(ids_existentes, ejecutados)
  message("")
  message(strrep("=", 70))
  log_msg(sprintf("RESUMEN — ejecutados: %s", paste(ejecutados, collapse = ", ")),
          "INFO", "run_all")
  if (length(saltados) > 0) {
    log_msg(sprintf("Saltados (disponibles): %s", paste(saltados, collapse = ", ")),
            "INFO", "run_all")
  }
  if (length(ids_ausentes) > 0) {
    log_msg(sprintf("Ausentes (sin construir): %s", paste(ids_ausentes, collapse = ", ")),
            "INFO", "run_all")
  }
  log_msg(sprintf("Duracion total: %.1f s.", dt_total), "INFO", "run_all")
  message(strrep("=", 70))
  invisible(NULL)
}

#' Regenerar solo el motor HTML (atajo de run_all(only = 35)).
regenerar_motor <- function() run_all(only = 35L)


# ============================================================================
# Ejemplos de uso (comentados)
# ============================================================================
# run_all()                 # pipeline completo de cero
# run_all(from = 33)        # desde catalogos (reusa el directorio depurado)
# run_all(only = 34)        # solo lectura/normalizacion -> idps_largo.parquet
# run_all(skip = c(31, 32)) # omite depuracion y censo (reusa sus salidas)
# regenerar_motor()         # solo el motor HTML (= run_all(only = 35))
