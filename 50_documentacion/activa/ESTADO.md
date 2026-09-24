---
slug: slep_idps
nombre_real: Motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS)
categoria: activo
semaforo: activo
sesion_actual: v31
ultima_actividad: 2026-09-23
maneja_sensibles: false
tipo_pendiente: deuda_tecnica
sesion_abierta: false
maquina: MacBook-Pro-de-Tomas.local
commit_cierre: 47c6058
traspaso_vigente: traspaso_cierre_v31.md
cierre_incompleto: no
insumos_verificados: 2026-09-23
ventana_insumos: ./20_insumos
---
## En que vamos
La sesión 32 cerró los cuatro pendientes menores de s31, reemplazó los IDPS 2025 preliminares por los definitivos (4b, 2m y 8b, sin tocar años anteriores) y recorrió la ruta de interfaz: tabla del comparador con scroll, foco retenido en el modal, estado vacío rotulado "sin comparación válida" y §5.6 de contraste resuelta con la opción B. Todo quedó desplegado en `docs/index.html` (md5 `4b28a03f…`).
## Proximo paso
Encargo corto de limpieza: retirar `_txtOn` y `const col` sin uso, actualizar el encabezado de §5 de la decisión de contraste y dar destino al foco cuando el botón de origen del modal desaparece.
## Bloqueantes
- ninguno
