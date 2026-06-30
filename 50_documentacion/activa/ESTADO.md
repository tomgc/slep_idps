---
slug: slep_idps
nombre_real: Motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS)
categoria: activo
semaforo: activo
sesion_actual: v25
ultima_actividad: 2026-06-25
maneja_sensibles: false
tipo_pendiente: deuda_tecnica
---
## En que vamos
La sesión 25 abrió con el pendiente de integrar el IDPS histórico 2014–2019 y descubrió, contrastando contra el código real, que ya estaba integrado (parquet 2014–2025, motor mostrando la serie); el trabajo se reorientó a documentar la cobertura y la razón de sus huecos. Sobre eso se hicieron cuatro mejoras de UI en la vista histórica: corrección de texto, reubicación de la leyenda de media móvil, exposición de su valor (cabecera + tooltip) con distancia vs GSE, y señalética de significancia por barra. Cierre con deploy, push de toda la sesión y working tree limpio.

## Proximo paso
Abordar la higiene de bajo riesgo no alcanzada en s25: resolver `# REVISAR (voz)` en `documentar.R` y subdividir la categoría "Rediseño UI" del backlog.

## Bloqueantes
ninguno
