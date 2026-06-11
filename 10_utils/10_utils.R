# =============================================================================
# 10_utils/10_utils.R
# -----------------------------------------------------------------------------
# Proyecto : slep_idps
# Proposito: Utilidades transversales del proyecto. Bootstrapping previo a
#            cualquier library(): estas funciones NO dependen de paquetes
#            cargados (politica POLITICA_PROYECTO.md, seccion 1.4).
# Fecha    : 2026-06-11
# -----------------------------------------------------------------------------
# NOTA DE HOMOLOGACION: revisar contra 10_utils.R del proyecto madre
# slep_simce_adecuado y homologar instalar_si_falta(), log_msg() y
# agregar_ponderado() (la ponderacion territorial reutiliza ese patron).
# =============================================================================

# --- Bootstrapping: instalar paquetes faltantes ------------------------------
# Instala solo los que faltan, sin cargar nada. Usa requireNamespace para no
# depender de library(). Idempotente.
instalar_si_falta <- function(paquetes) {
  faltantes <- paquetes[
    !vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)
  ]
  if (length(faltantes) > 0) {
    message("Instalando paquetes faltantes: ", paste(faltantes, collapse = ", "))
    utils::install.packages(faltantes)
  }
  invisible(NULL)
}

# --- Logging sin dependencias ------------------------------------------------
# Formato: [YYYY-MM-DD HH:MM:SS] [origen] [NIVEL] mensaje
log_msg <- function(mensaje, nivel = c("INFO", "WARN", "ERROR"), origen = "slep_idps") {
  nivel <- match.arg(nivel)
  ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[%s] [%s] [%s] %s\n", ts, origen, nivel, mensaje))
  invisible(NULL)
}
