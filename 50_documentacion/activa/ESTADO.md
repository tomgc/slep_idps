---
slug: slep_idps
nombre_real: Motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS)
categoria: activo
semaforo: activo
sesion_actual: v30
ultima_actividad: 2026-09-23
maneja_sensibles: false
tipo_pendiente: cosmetica
sesion_abierta: false
maquina: MacBook-Pro-de-Tomas.local
commit_cierre: a28cbd3
traspaso_vigente: traspaso_cierre_v30.md
cierre_incompleto: no
insumos_verificados: 2026-09-17
ventana_insumos: ./20_insumos
---
## En que vamos
La sesión 31 (tres encargos autónomos y dos revisiones independientes) corrió por primera vez la compuerta de repositorio (9/9), construyó la vista histórica del panorama territorial (franja de estado en los años que lo publican y matriz de establecimiento × año con color calibrado por percentiles del país) y corrigió un defecto del motor publicado: los establecimientos con puntaje pero sin comparación publicada por la Agencia se contaban como "sin diferencia". El payload no se movió en los 19 commits y el motor quedó desplegado en `docs/index.html` (md5 `6c5feab5…`).
## Proximo paso
Los cuatro pendientes menores que la sesión dejó anotados: las dos cadenas de conteo escritas a mano (modal del comparador y tooltip de exportación), la enmienda de la decisión §3.5 (el piso real de la rampa de color es 4,58:1), el criterio de verificación del despliegue en el traspaso y el teclado del modal de territorio.
## Bloqueantes
- ninguno
