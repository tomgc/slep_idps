# Traspaso de cierre — slep_idps — s27

## Resumen
P-GITIGNORE-TOKEN cerrado (comentario aclaratorio, sin cambio de patrón).
Ajuste cosmético radar (territorial ya aprobado en sesión previa; ficha EE
ajustada esta sesión: línea 1.8→1.2, punto 4/2.6→7/5 con borde oscurecido
`darker(2.5)` stroke-width 0.6).

## Commits
- `a77261d` — docs: documenta criterio de *token* en .gitignore (P-GITIGNORE-TOKEN)
- `46837cd` — style(idps-radar): linea mas delgada y puntos mas grandes con borde oscurecido (L670-671)

Ambos pusheados a `origin/main`.

## Deuda de build detectada (nueva, no capturada antes)
`00_build.R` NO genera `docs/index.html`. La fuente real de generación es
`30_procesamiento/35_generar_motor_html.R`, que escribe a
`40_salidas/motor_idps.html`. La promoción a `docs/index.html` (fuente de
GitHub Pages) es manual, sin script que la automatice. Pendiente: decidir si
se documenta el paso manual en `POLITICA_PROYECTO.md`/`README.md`, o se
agrega un paso final a `35_generar_motor_html.R` que copie directo a `docs/`.

## Pendiente inmediato (manual, tuyo)
Copiar `40_salidas/motor_idps.html` → `docs/index.html` (reemplazo directo),
luego commit + push de `docs/index.html`.

## P-SLEPVERSE
Derivado a Project propio. Ya no es pendiente de `slep_idps`.

## Pendientes de fondo (sin cambios esta sesión)
- Suite regeneration con documentación de cobertura histórica
- Item 11 (bloqueado, sin nueva información)
- Tooltip "vs evaluación anterior": de `title` a body (cosmético, menor)

## Auditoría de apertura (s27)
Estructura consistente con escáner adjunto al inicio de sesión (32 carpetas,
284 archivos), sin deuda estructural nueva más allá de la ya heredada
(espacios en `andamios/diseno/`, congelada por decisión previa).

## Estado del repo al cierre
`origin/main = 46837cd`. Pendiente: commit de `docs/index.html` tras copia
manual.
