# Auditoría de fidelidad — Motor IDPS vs handout de diseño (revisión P3)

**Sesión 8 · 2026-06-20 · read-only (no se modificó nada).** md5 `idps_largo.parquet` =
`50d9de4f1fc80259d29f499cdf46d9e1` antes y después. Implementación auditada =
`40_salidas/motor_idps.html` (commit `1b6f03b`) + `30_procesamiento/35_motor_template.html`.
Fuente de verdad = handout en `50_documentacion/andamios/diseno/rediseno_3pantallas/`
(`Handout IDPS.html`, `Propuesta IDPS.html`, `idps-demo.js`, `PROMPT para Claude.md`,
`img/01-04`). Método: render en vivo (servr:8765) + PNGs + funciones `renderX` + handout
HTML, cruzado por 4 auditores y 1 crítico de completitud.

> El handout usa **datos sintéticos** (hash). Las diferencias de cifras/RBD/nombres concretos
> NO son divergencias. Se audita estructura, controles, copy de UI, flujo y layout.
> La **paleta de 4 indicadores** (`#EE2D49 #FFC92E #9BC93E #2A8FD9`) es **fiel**: coincide
> con el array `IND` del prototipo; no se reporta como divergencia.

---

## ESTADO DE CORRECCIÓN — lote P3 aplicado (sesión 8, 2026-06-20)

Lote aplicado SOLO en `30_procesamiento/35_motor_template.html` (+ regeneración `only=35`;
md5 parquet intacto `50d9de4f…`; `grep -c B7AC96` = 0; 0 errores de consola; `docs/` NO
republicado, lo coordina el titular). Estado por fila:

| Estado | # |
|---|---|
| **corregido** | #1, #2, #3, #4, #5, #6, #7, #8, #10, #11, #12, #13, #14, #15, #17, #18, #19, #20, #21, #22, #23, #25, #29, #30, #31, #32, #33, #34, #35, #36, **C3** |
| **corregido (parcial)** | #9 (label → "Territorio" y control tipo *select*; se **conserva el EntityModal todo-Chile** como ampliación aprobada por la auditoría, no un `<select>` plano de 4 territorios) · #24 (se añade `rcard-def` con la definición; **`rcard-alto` queda pendiente**: el dato del motor no expone un descriptor textual de "nivel alto" por indicador) |
| **mantenido (enriquecimiento / decisión)** | #16 (leyenda de indicadores con ⓘ), #26 (Vista histórica en **línea**, no barras — por decisión del titular), #27 (meta enriquecida comuna·región·dependencia), #28 (radar de 2 años; `#C77D3A` → `--cmp-year`) |
| **mantenido-por-invariante** | **C1** (sin marca "GSE n puntos" en barras, sin trazo `#B7AC96`; el 2º trazo del radar es otro año del propio EE) · **C2** (subdimensión = `DistBar` de niveles en Vista actual, ausente en histórica) |

**C3 (colores de estado):** igualados al handout — ▼ bajo `#EE2D49`, = `#8C8A86` (`--st-neutro`),
▲ sobre `#2A8FD9` — en territorial, ficha y comparar (barras + leyendas). La paleta de los 4
indicadores NO se tocó (sigue como codificación de indicador).

**Extra (hallazgo del crítico):** el estado de nivel/año se separó por pantalla
(`panGrado` vs `fichaGrado` vs `cmpGrado`, independientes como el handout). El **año dejó de
ser seleccionable** en todas las pantallas: es el más reciente del nivel, fijo en el banner
(la serie por año vive en la Vista histórica).

**Verificación (navegador, por código):** (1) md5 idéntico ✓; (2) B7AC96=0 ✓; (3) 3 ALTA —
banner territorial ✓, GSE multi-select (Bajo+Medio → 2 secciones) ✓, buscador de ficha
funcional ✓; (4) estado azul/gris/rojo en las 3 pantallas y leyendas ✓; (5) comparar abre en
blanco + invitación, sin bug de plural ✓; (6) C1/C2 sin cambios (sin marca GSE; subdim
`DistBar`/ausente en histórica; histórica en línea 15 paths/0 rects) ✓; (7) 0 errores de
consola, 3 pantallas sin regresión ✓; (8) fidelidad a los PNG confirmada en territorial,
ficha (actual+histórica) y comparar ✓.

> **Pendiente para el titular:** decidir `rcard-alto` (#24, requiere un texto de "nivel alto"
> por indicador que el dato hoy no expone) y, si se desea, un `<select>` plano de Territorio
> (#9, hoy resuelto con el modal todo-Chile). Republicar `docs/` tras aprobar.

---

## (a) Resumen

**36 divergencias** + **3 conflictos con invariantes**.

| Pantalla | ALTA | MEDIA | BAJA | Total |
|---|---|---|---|---|
| Global / Header / Nav | 0 | 3 | 4 | 7 |
| Panorama territorial | 2 | 5 | 4 | 11 |
| Ficha (Panorama IDPS) | 1 | 5 | 5 | 11 |
| Comparación territorios | 0 | 3 | 1 | 4 |
| Transversal (territorial + comparar) | 0 | 0 | 3 | 3 |
| **Subtotal divergencias** | **3** | **16** | **17** | **36** |
| Conflictos con invariante (sección aparte) | — | — | — | **3** |

Las **3 ALTA**: ① territorial sin banner oscuro de identidad (rompe la homogeneidad de las 3
pantallas exigida en el PROMPT §30); ② filtro GSE territorial single-select en vez de
multi-select; ③ ficha sin buscador de establecimiento embebido (rompe "cambiar de EE sin
volver"). Los **3 conflictos** son justamente donde el handout pide reconstruir el GSE
absoluto o tratar la subdimensión como puntaje: **no replicar**, decisión del titular.

---

## (b) Tabla de divergencias

| # | Pantalla | Elemento | Qué pide el DISEÑO (ref) | Qué hace la IMPLEMENTACIÓN | Sev. | Inv. | Corrección (1 línea, en 35_motor_template.html) |
|---|---|---|---|---|---|---|---|
| 1 | Global | Identidad del banner ("Motor IDPS" líder) | H1 grande que lidera con **"Motor IDPS — Indicadores de Desarrollo Personal y Social"** (Propuesta L311, CSS L39; los 3 PNG) | Eyebrow en 2 chips "Agencia de Calidad… · Motor IDPS" + H1 "Indicadores… — por establecimiento, leído vs su GSE"; "Motor IDPS" degradado a chip muted; el `<title>` (L6) sí lidera → incoherencia | MEDIA | no | Reescribir header L371-376 para que el H1 lidere con "Motor IDPS — …" y el resto vaya como `app-title-sub` |
| 2 | Global | Línea eyebrow de contexto | Una sola línea gris bajo el título: "Datos 2022–2025 · Lectura por establecimiento, segmentada por GSE · Agencia de Calidad de la Educación" (Propuesta L312) | Chips uppercase ARRIBA del título + subtítulo distinto "Cuestionarios de Calidad y Contexto · 4°b y 2°m · todo Chile" (L377) | BAJA | no | Sustituir `brand-eyebrow-row` (L371-375) por una línea `app-eyebrow` bajo el título con ese copy |
| 3 | Global | Párrafo lede | Un párrafo: "Esta herramienta de análisis interno del SLEP Costa Central… para cualquier territorio del país… nunca se promedia ni se agrega." (Propuesta L313) | Objetivo reescrito y partido (L378); falta la apertura "herramienta de análisis interno del SLEP Costa Central" | BAJA | no | Reemplazar `app-subtitle`+`app-objective` (L377-378) por el párrafo `app-desc` literal del diseño |
| 4 | Global | Barra de tabs (contenedor) | `<nav class="app-nav">` blanca, **full-width y sticky** bajo el header (Propuesta L316-322, CSS L44-45) | `.screen-tabs` dentro de `.wrap`, ni sticky ni full-width (L1151, CSS L63) | MEDIA | no | Mover `.screen-tabs` a una barra sticky full-width bajo el header (CSS L63 + JSX L1151) |
| 5 | Global | Acento de marca **coral** | Tab activa: texto plum + subrayado **coral #E88663**; hero con **borde inferior 4px coral** (Propuesta L37, L46-48) | Tab activa azul (`--foco`); header sin borde coral; el proyecto **no define token coral** → el acento secundario de marca está ausente en toda la UI | MEDIA | no | Definir token coral y aplicarlo a `.screen-tab.is-active` (L66) y a `header.app` (L35) |
| 6 | Global | Tipografía de tabs en reposo | Tabs siempre weight 700 / 14px; activa solo cambia color+subrayado (Propuesta L46) | Reposo weight 500 / 13px; sube a 700 solo en activa (CSS L64,66) | BAJA | no | En `.screen-tab` (L64) subir a weight 700 / 14px |
| 7 | Global | Ancho máximo del contenido | `max-width:1200px` (Propuesta L38,45) | `max-width:1320px` (L36,47) | BAJA | no | Ajustar `max-width` de `.app-header-inner` y `.wrap` a 1200px |
| 8 | Territorial | **Banner oscuro de identidad (pan-bar)** | Banner azul bajo las tabs con nombre del territorio en grande + meta ("4 comunas · 60 EE · 4°b · 5 de 5 GSE · 2025 (prelim)") + **Nivel a la derecha** (renderTerritorio L249-253; PROMPT §30 "banner primero, picker debajo, Nivel/Vista en el banner") | No existe pan-bar; nombre/meta solo en línea `.crumb` (L1192); el segmentador va en la caja `.nav` clara (L1182) | **ALTA** | no | Anteponer un bloque `.pan-bar` oscuro (nombre+meta+"N de 5 GSE" izq., Nivel der.), portando de Propuesta |
| 9 | Territorial | Control de Territorio | `<select>` nativo inline etiquetado **"Territorio"** (renderTerritorio L254-257; PNG caja "SLEP Costa Central ▾") | Botón "Explorar / cambiar selección ▾" → EntityModal + chips; label "Territorio / dependencia" (L1161-1162) | MEDIA | no | Exponer un picker `<select>` "Territorio" inline, o documentar el modal como ampliación a todo Chile y al menos renombrar el label a "Territorio" |
| 10 | Territorial | **Filtro GSE single vs multi-select** | Botones-checkbox (`.gfb`+`.gf-check ✓`), **una sección por cada GSE visible**, Set con todos por defecto (renderTerritorio L228,231,260; "muestra u oculta cada grupo") | Pills de **selección única**: "Todos" O un solo GSE (L1186-1189; estado `gse` L1081). No se puede ver, p.ej., Bajo+Alto a la vez | **ALTA** | no | Cambiar a multi-select (Set de GSE visibles con checkboxes, default todos), eliminando el pill "Todos" exclusivo |
| 11 | Territorial | Selector de Año (añadido) | renderTerritorio **no** genera selector de año; año fijo al más reciente, mostrado en la meta del banner (L251) | Segmentador "AÑO" 2022/2023/2025* (L1184-1185) | MEDIA | no | Quitar el segmentador AÑO de territorial (o documentar la divergencia) |
| 12 | Territorial | Nivel: label y ubicación | Segmentador **"Nivel"** dentro del banner oscuro, a la derecha (`seg-lvl big`; renderTerritorio L252) | Segmentador **"Grado"** en la caja `.nav` clara, junto a Año y GSE (L1182-1183) | MEDIA | no | Mover el segmentador al pan-bar (der.) y renombrar a "Nivel" |
| 13 | Territorial | Orden de bloques | pan-bar → picker Territorio → tarjeta GSE (`gse-filter-wrap`) → explain → leyenda → secciones (renderTerritorio L249-265) | picker-strip → caja `.nav` (Grado+Año+GSE juntos) → crumb → help → 2 leyendas → secciones (L1160-1228) | MEDIA | no | Reordenar y separar el GSE en su propia tarjeta `gse-filter-wrap` |
| 14 | Territorial | Tarjeta de EE: pill + CTA | Pill "▼/▲ **N indicadores** bajo/sobre su GSE" + CTA **"ver más detalles →"** (renderTerritorio L237-238) | `<Card>` con chips "▼ N bajo GSE"/"▲ N sobre GSE"/"≈ en su GSE"; **sin CTA** "ver más detalles →"; copy más corto | MEDIA | no | Alinear copy del chip y añadir el CTA "ver más detalles →" en el componente `Card` |
| 15 | Territorial | Copy de la caja explicativa | "Panorama del territorio sin agregar. El territorio acota la lista…" (renderTerritorio L263) | "El territorio acota, no agrega. …% (n)…, nunca un promedio. Cada tarjeta es un establecimiento individual…" reescrito/ampliado (`.help` L1193) | BAJA | no | Alinear el copy de `.help` al diseño (o mantener: refuerza el invariante de cero agregación) |
| 16 | Territorial | Leyenda de indicadores con ⓘ (añadida) | renderTerritorio no incluye leyenda de indicadores en esta pantalla (solo `legendStd` de estados) | Añade leyenda de los 4 indicadores con botón ⓘ + tooltip, antes de la de estado (L1194-1202) | BAJA | no | Añadido útil (aclara el color de cada indicador); conservar o notar que el diseño no lo trae aquí |
| 17 | Territorial | Copy de sub-encabezados | "**Distribución por estado vs su GSE**" sin sufijo (L242); "**Establecimientos** · clic para ver el Panorama IDPS **del establecimiento**" (L244) | Añade "· % (n) de establecimientos con dato, no promedio" (L1215); omite "del establecimiento" (L1224) | BAJA | no | Alinear ambos copys al diseño (o mantener el sufijo % (n) por refuerzo de invariante) |
| 18 | Territorial | Línea `.crumb` redundante | El diseño no tiene crumb; el contexto vive en la meta del banner | Añade `.crumb` "Panorama territorial de X · grado · año · N EE" (L1192) para suplir el banner ausente | BAJA | no | Al existir el pan-bar (#8), eliminar la crumb redundante |
| 19 | Ficha | **Buscador de establecimiento embebido** | renderFicha **siempre** muestra picker-bar "Establecimiento" + input "Buscar por nombre o RBD…" + dropdown de resultados, también con EE activo (renderFicha L377-383; Handout L170; PNG 02) | Sin EE → screen-stub con botón "Ir a Panorama territorial →" (L1235-1239); con EE → ficha-bar **sin buscador** (L791-808); el cambio de EE es por la grilla o el EntityModal global | **ALTA** | no | Añadir bajo `.ficha-bar` un picker-bar "Establecimiento" con `input.estab-search` + dropdown que setea `rbdSel`; idealmente precargar un EE para eliminar el stub vacío |
| 20 | Ficha | Tercer segmentador "Año" | ficha-tools = **2** segmentadores: "Vista" + "Nivel"; año fijo en la meta (renderFicha L372-375; PNG 02) | ficha-tools = **3**: "Vista" + "Grado" + "Año" (L797-807) | MEDIA | no | Decidir si "Año" permanece (capacidad real del motor) o se retira para igualar el diseño |
| 21 | Ficha | Label "Nivel" vs "Grado" | Segmentador etiquetado **"Nivel"** (renderFicha L374; PNG 02) | Etiquetado **"Grado"** (L803) | BAJA | no | Renombrar `nivelsel-lab` a "Nivel" (o aceptar "Grado" como vocabulario del proyecto) |
| 22 | Ficha | Botón "‹ Volver a la grilla" | renderFicha no incluye botón de volver en la ficha-bar (salida por tabs / buscador) | `.ficha-back` "‹ Volver a la grilla" como primer elemento de la ficha-id (L793) | BAJA | no | Evaluar quitarlo (o mantener como vía de salida mientras no exista el buscador #19) |
| 23 | Ficha | Picker-strip territorial visible en ficha | La ficha del diseño no lleva picker "Territorio/dependencia"; su único picker es el de Establecimiento | El picker-strip global "Territorio / dependencia" se muestra también en ficha (L1160-1168, `pantalla!=="comparar"`) | MEDIA | no | Ocultar el picker territorial en ficha (solo en territorial) y sustituirlo por el buscador de Establecimiento (#19) |
| 24 | Ficha | Tarjetas del radar (rcard): definición + "puntúan alto" | Cada rcard incluye `rcard-def` (definición del indicador) + `rcard-alto` "Los establecimientos que puntúan alto: …" (renderFicha L323-333) | rcard solo dot+nombre+valor + 2 anclas (vs GSE / vs año); la definición está más abajo, en `indp-def` (L836-848) | MEDIA | no | Añadir `rcard-def` y `rcard-alto` leyendo `ind.definicion` + texto de nivel alto |
| 25 | Ficha | Leyenda de estado vs GSE en Vista actual | renderFicha (actual) incluye `legendStd` (▼/=/▲ vs GSE) (L386; PNG 02) | Solo hay la leyenda de **niveles** "Bajo/Medio/Alto · distribución de subdimensiones" (L872); falta la de estado vs GSE | MEDIA | no | Añadir en la Vista actual la leyenda de estado vs GSE, separada de la de niveles |
| 26 | Ficha | Vista histórica: barras por año vs líneas | `barMini`: **barras verticales** por año (borde discontinuo + "*" para preliminar, valor sobre la barra, hueco omitido) (buildHist L288-291; Handout L184-185; PNG 04) | `PanelEvolucion`: **gráfico de línea** d3 (eje fijo 0–100); valor solo en tooltip; dif por año en `evol-marks` (L649-682) | MEDIA | no | Decidir barras vs línea: portar `barMini` si se busca fidelidad, o documentar la línea como mejora deliberada |
| 27 | Ficha | Meta de la ficha-bar (campos/orden) | "{comuna} · {SLEP} · GSE {N} · {nivel} · {año}" — 5 campos, sin región ni dependencia (renderFicha L370) | "{comuna} · {región} · {dependencia} · GSE {x} · {grado} · {año}" — 6 campos (L795) | BAJA | no | Aceptable como enriquecimiento; alinear orden/campos al diseño si se busca fidelidad estricta |
| 28 | Ficha | Comparador de 2 años en el radar (añadido) | renderFicha no tiene selector para comparar dos años del propio EE; el 2º trazo del radar es la referencia GSE | Añade `radar-cmp` con select "Comparar radar con" (años del propio EE), leyenda y hint (L850-864); trazo en `#C77D3A` (hardcodeado JS L835 + CSS L111) | BAJA | no | Extensión compatible (sustituye el trazo GSE prohibido por un año real); conservar y mover `#C77D3A` a `:root` para gobernarlo |
| 29 | Ficha | Copy del explain (actual e histórico) | Promete "su **referencia GSE sobre la barra**" (L385) y, en histórica, "indicador, dimensión **y subdimensión**" (L311) | Reescrito (sin prometer GSE-sobre-barra ni subdim-puntaje) (L830, L814) | BAJA | toca | Copy reescrito a propósito (correcto por invariante); verificar que no quede ninguna promesa de "referencia GSE sobre la barra" — ver Conflictos C1/C2 |
| 30 | Comparar | Eyebrow sin prefijo de territorio | "**SLEP Costa Central · Comparador IDPS**" (renderComparar L430; PNG 03) | Solo "Comparador IDPS" (L1004) | MEDIA | no | En L1004 anteponer "SLEP "+SLEP_FOCO_NOM+" · " (o el nombre del 1er chip) |
| 31 | Comparar | Chips iniciales: 1 vs 4 | Abre con **4** territorios precargados (renderComparar L407; PNG "4 de 4") | Abre con **1** (SLEP foco) + invitación "Agrega al menos un territorio más" (L1089, L1024) | MEDIA | no | **Decisión deliberada de Fase 4** (D-s8-3: foco como único chip). ¿Precargar 2-4 por defecto? — resolver con el titular |
| 32 | Comparar | Banda crema: frase de año + bug de plural | Termina en "…no una media de puntajes." (renderComparar L434) | Añade "Año 2025* · 4°b (… igual para **los 1 territorios**)." con bug de pluralización (L1011) | BAJA | no | Quitar el sufijo de año (o pluralizar: `length===1?"el territorio":"los N territorios"`) en L1011 |
| 33 | Comparar | Forma del filtro "Segmentar por GSE" | Botones **rectangulares con casilla** (`.gfb` radius 7px + `.gf-check ✓`) (Propuesta L271-275; renderComparar L410) | Pills **redondeadas** sin casilla (`.gse-pills` radius 14px; L1029-1030, CSS L58-61) | MEDIA | no | Cambiar las `gse-pills` del comparador a estilo `.gfb` (radius ~7px + checkbox `.gf-check`) |
| 34 | Transversal | Nombre de sección por GSE | Solo la etiqueta corta: "**Bajo**" (renderTerritorio L240 / renderComparar L415) | "**GSE · Bajo**" (territorial L1213 + comparar L1045); sub extendido en comparar | BAJA | no | Quitar el prefijo "GSE · " del `gse-sec-name` en L1213 y L1045; reducir el sub de comparar a "Grupo socioeconómico" |
| 35 | Transversal | Nota de ayuda del filtro GSE ausente | "Muestra u oculta cada grupo…; …incluso todos / baja para verlos todos." (renderTerritorio L260, renderComparar L438) | Solo el label, sin nota, en ambas pantallas (territorial L1186, comparar L1028) | BAJA | no | Añadir el `<span>` de ayuda tras el label en L1186 y L1028 |
| 36 | Transversal | Leyenda de estado: 4º span + alineación | 3 ítems (▼/=/▲) alineados a la derecha (`legendStd` L144-149; `.cmp-legend` flex-end Propuesta L261; Handout §375 "idéntica en las 3, alineada a la columna") | Añade 4º span "· estado leído de difgru/sigdifgru…; el color es de estado, no de indicador" y alinea a la izquierda (comparar L1038 + territorial L1207) | BAJA | toca | Quitar/mover el 4º span de L1038 y L1207 y alinear a la derecha; el aviso lee-no-deriva es prescindible dentro de la leyenda |

---

## (c) CONFLICTOS con invariantes (NO replicar a ciegas — decisión del titular)

Son los puntos donde **seguir el handout violaría un invariante de dato**. La implementación
ya se apartó del diseño **a propósito**; se listan para resolución explícita.

| # | Pantalla | Qué pide el DISEÑO | Por qué es CONFLICTO | Qué hace (correctamente) la IMPLEMENTACIÓN | Decisión sugerida |
|---|---|---|---|---|---|
| C1 | Ficha | Referencia **absoluta** del GSE en todas partes: marca "GSE n puntos" sobre cada barra 0–100 (`bar0100` L133-141), 2º trazo del radar en **`#B7AC96`** (L319), "ref. GSE X: N puntos" en el panel de indicador (L358), y anclas "vs su GSE" en **dimensión y subdimensión** (L344,350) | **Lee-no-deriva.** El puntaje absoluto del GSE no existe en el dato de la Agencia: exigiría reconstruir `prom − difgru`. Además `difgru/sigdifgru` solo se publica a **nivel indicador**, no de dimensión/subdimensión. `#B7AC96` está explícitamente prohibido | `ScoreBar` sin marca GSE (L634-640); el 2º trazo del radar es **otro año del propio EE** (no el GSE); anclas de desvío solo a nivel indicador (`difgru/sigdifgru`) | **Mantener la implementación.** No añadir "GSE n puntos" ni el trazo `#B7AC96`. Ajustar el handout, no el motor |
| C2 | Ficha | Subdimensión como **barra de puntaje 0–100** con su valor (Vista actual, `bar0100` L341-345) y como **serie histórica** de puntaje por año (buildHist L305-308; Handout L182) | **Cero agregación / modelo de dato.** En el dato real la subdimensión es **distribución de niveles** (% bajo/medio/alto), no un puntaje; graficarla como 0–100 inventaría una cifra | Subdimensión = `DistBar` (distribución de niveles) en Vista actual; **ausente** en histórica, con nota explicativa (L826) | **Mantener la implementación.** No convertir la subdimensión en puntaje 0–100 ni en serie histórica |
| C3 | Las 3 pantallas | Color de estado **"▲ sobre su GSE" = azul `#2A8FD9`** (y "▼ bajo" = `#EE2D49`, "=" = `#8C8A86`) (PROMPT §5; `legendStd` L83) | **Toca la paleta de indicadores.** `#2A8FD9` es exactamente `--ind4` y `#EE2D49` es `--ind1`: igualar el color de estado al diseño lo **solaparía con la codificación de dato** (el color de columna del indicador y el color de la barra de estado conviven en territorial y comparar) | Estado en `--alerta` (rojo ladrillo) / `--gris` / **`--destaca` verde**, deliberadamente **distintos** de la paleta | **Decisión del titular:** fidelidad cromática al handout (aceptando el solape con la paleta) **vs** mantener el verde/rojo-ladrillo del motor. El tono neutro (`#8C8A86` vs `--gris`) sí puede alinearse sin conflicto |

---

## (d) Notas de método

- Consolidado de **67 divergencias** de 4 auditores + **8** del crítico de completitud (75
  crudas) → 36 únicas + 3 conflictos, fusionando duplicados cross-screen (#34-36) y
  agrupando en C1 los 4 ítems de "GSE absoluto" (barra, radar, panel, dimensión).
- Se descartó una divergencia de "banner descriptivo ausente en ficha": el header global
  (con el título) **sí** se renderiza en las 3 pantallas; lo que difiere es su **copy/jerarquía**
  (ya cubierto en #1-3), no su presencia.
- **El crítico subió #5 (acento coral) a ALTA** por ser señal de marca sistémica ausente; aquí
  se deja en **MEDIA** según la definición del encargo (cosmético/brand, no rompe flujo ni
  sentido). Queda anotado para que el titular decida.
- Hallazgo del crítico no trivial: **el estado de Grado/Año es único de `App`** y se comparte
  entre territorial y ficha (cambiar el grado en la ficha cambia el de la grilla); el diseño
  los tiene **independientes por pantalla** (`panNivel` / `ficha.nivel`). Cubierto como
  comportamiento divergente (relacionado con #11/#20). Severidad MEDIA.

**Próximo paso (NO ejecutado):** el titular aprueba/edita esta tabla; las correcciones se
implementan después, en `35_motor_template.html`, respetando los 3 conflictos.
