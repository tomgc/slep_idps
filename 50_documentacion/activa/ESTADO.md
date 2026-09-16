---
slug: slep_idps
nombre_real: Motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS)
categoria: activo
semaforo: activo
sesion_actual: s29
ultima_actividad: 2026-09-16
maneja_sensibles: false
tipo_pendiente: deuda_tecnica
---
## En que vamos
La sesión 29 (ocho encargos, s29–s29h, 2026-09-09 → 2026-09-16) cerró y desplegó el comparador de entidades con contraste accesible, cerró con s29g la **línea de contraste** y con s29h corrigió un error de especificación propio detectado por el titular sobre el motor publicado. Comparador: entidad nacional como referencia fija **en su propio tab del modal** (s29h: antes encabezaba las listas de los cuatro tabs, incluido Establecimiento; ahora el modal lleva cinco tabs en el orden del proyecto hermano `slep_simce_adecuado` —Establecimiento · Comuna · SLEP · Región · Nacional— y abre en Establecimiento), establecimientos como filas de caso individual (glifo + puntaje, cero agregación), etiquetado adaptativo de la barra por espacio real (nunca un número truncado ni un porcentaje duplicado), aviso único de EE sin ubicación. Contraste: la paleta de ESTADO no se tocó; se separó color de barra de color de texto con tres tokens `-txt`, `--gris` se corrigió en la raíz (cumple 4,5:1 en los 15 fondos claros del CSS), y chips, anclas y la glosa de estados de la ficha pasaron a los tokens de texto (cinco usos inventariados en §3.3); `--alerta-txt` quedó en `#CE112C` con margen; el sufijo "· sig." del ancla dejó de atenuarse (3,72 → 4,61). Decisión `20260910_decision_contraste_texto_estado.md` con dos excepciones escritas (§3.4 etiqueta blanca dentro de la barra; §3.5 glifos como componente gráfico), una exención con fundamento (§5.3 c, componentes inactivos) y un solo ítem de backlog de diseño (§5.6: texto sobre color de la paleta de INDICADOR, que agrupa §5.3 b y §5.5 2 y 4). Payload byte-idéntico en toda la línea (SHA-256 §8.2 `1e29c2b5…`). **Redesplegado a `docs/index.html` el 2026-09-16** (md5 `5ab60072…`, 5.385.578 bytes; el payload no se movió en toda la línea). Backlog sin cambio de correlativo hasta el cierre.

## Proximo paso
Dos decisiones del titular, ambas con mockup previo: (1) **P-VISTA-TERRITORIAL** — selector "Vista actual / Vista histórica" en el panorama territorial, en el banner junto al de NIVEL, análogo al de la ficha (pedido el 2026-09-16; log s29 §27). No está especificado: un territorio no tiene puntaje propio (cero agregación), así que su vista histórica no puede ser la curva de la ficha; la forma compatible es una serie de repartos (% y n por estado vs GSE, por año). Entra al backlog con su correlativo en el cierre de sesión. (2) **§5.6 de la decisión de contraste** — regla general para el texto que cae sobre, o toma, un color de la paleta de INDICADOR (`.defn-title`, etiqueta de `DistBar`, vista histórica); recomendación escrita: sacar el texto del relleno. Menores: hover `✕` de `.sel-chip`/`.cmp-x` a 4,11 (sexto uso posible de `--alerta-txt`). Pendientes heredados: P-GITIGNORE-TOKEN, P-SLEPVERSE, marca de "base pequeña" (umbral metodológico sin fijar).

## Bloqueantes
ninguno
