---
slug: slep_idps
nombre_real: Motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS)
categoria: activo
semaforo: activo
sesion_actual: v29
ultima_actividad: 2026-09-17
maneja_sensibles: false
tipo_pendiente: bloqueante
sesion_abierta: false
maquina: MacBook-Pro-de-Tomas.local
commit_cierre: 1870019
traspaso_vigente: traspaso_cierre_v29.md
cierre_incompleto: no
insumos_verificados: 2026-09-17
ventana_insumos: ./20_insumos
---
## En que vamos
Las sesiones 29 y 30 (2026-09-09 → 2026-09-17, once encargos autónomos) dejaron el motor con tres capacidades nuevas y publicadas: el comparador acepta las cinco clases de entidad (establecimiento, comuna, SLEP, región y nacional) con dependencia por entidad y clave `kind|cod|dep`, la interfaz cumple AA fuera de dos excepciones escritas y un ítem de backlog de diseño, y hay exportación en CSV (comparador, panorama y ficha) y del radar en SVG y PNG. La invariante de cero agregación no se tocó: el territorio acota la lista de establecimientos, nunca produce un puntaje propio. Todo está desplegado en `docs/index.html` y el payload no se movió en toda la línea (SHA-256 §8.2 `1e29c2b5…`).
## Proximo paso
Correr la compuerta de repositorio (`95_verificar_cierre.R`) y saldar lo que marque: es la primera vez que este proyecto se cierra bajo el régimen de nueve invariantes y este cierre no pudo ejecutarla. Recién después, P-VISTA-TERRITORIAL, que necesita mockup y una decisión previa (un territorio no tiene puntaje propio, así que su vista histórica es una serie de repartos, no una curva).
## Bloqueantes
- Compuerta de repositorio sin ejecutar (`cierre_incompleto`). Este cierre dejó preparados los dos invariantes que el proyecto nunca tuvo instrumentados: `I8` con `50_documentacion/activa/50_datos_versionados_autorizados.md` y `I9` con la llave `ventana_insumos` de este mismo archivo. Ninguno está verificado.
