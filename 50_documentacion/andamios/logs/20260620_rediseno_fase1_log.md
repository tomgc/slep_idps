# Log — Rediseño Fase 1: andamiaje de navegación 3 pantallas

**Andamio de ejecución (registro congelado).** Material de evaluación. Honesto:
incluye lo que costó y lo que quedó abierto.

- **Fecha:** 2026-06-20.
- **Repo:** `/Users/tomgc/Projects/slep_idps` · rama `main`.
- **Alcance:** SOLO andamiaje de navegación (tabs + router + stubs). NO implementa
  las pantallas territorial/comparar como features. Trabajo `only=35` (template).
- **Commit:** `0de6647` `feat(motor): andamiaje de navegacion 3 pantallas (tabs + router + stubs territorial/comparar)`.

---

## 1. Resumen

El motor pasó de **una pantalla** (territorio→grilla→detalle) a un **andamiaje de
3 pantallas** con navegación por tabs, sin tocar la lógica de datos:

1. **Panorama territorial** — stub ("En construcción · próxima fase").
2. **Panorama IDPS por establecimiento** — la pantalla funcional actual (default).
3. **Comparación entre territorios** — stub.

El picker territorial (disparador de `EntityModal`) se movió a una **franja
persistente bajo el banner**, visible en las 3 pantallas. Grado/Año/GSE quedaron
en la pantalla ficha (son los filtros de la grilla). Todo verificado en navegador:
3 tabs conmutan, ficha idéntica a la versión previa, stubs sin datos, 0 errores de
consola, motor 4.6 MB. `idps_largo.parquet` intacto (no se tocó; `only=35`).

---

## 2. Inventario de commits

| Hash | Tipo | Título |
|------|------|--------|
| `0de6647` | feat | andamiaje de navegacion 3 pantallas (tabs + router + stubs territorial/comparar) |

Un solo commit atómico (toca sólo `30_procesamiento/35_motor_template.html` y el
regenerado `40_salidas/motor_idps.html`). **No** publica a `docs/`.

---

## 3. Cambios sustantivos (qué, por qué, causa)

Todo en `30_procesamiento/35_motor_template.html` (la UI vive ahí; el `.R` sólo
inyecta datos/libs).

1. **Estado `pantalla`** (`territorio|ficha|comparar`, default `ficha`). Por qué:
   la ficha es la única pantalla funcional hoy; el default la conserva como
   entrada. No se eliminó ningún estado existente (terr, dep, modalOpen, grado,
   agno, gse, rbdSel siguen).
2. **Barra de tabs (`.screen-tabs`/`.screen-tab`).** Reusa el lenguaje visual de
   `.modal-tab` (activo subrayado en `--foco`, inactivo `--gris`). Al tope de
   `App`, bajo el banner. El click cambia `pantalla`.
3. **Router por pantalla.** `pantalla==="ficha"` renderiza el contenido actual
   movido a una rama condicional (NO reescrito): `.nav` de grado/año/GSE +
   grilla/detalle. `territorio`/`comparar` renderizan `<ScreenStub>` (título +
   "En construcción · próxima fase"), sin datos ni cifras.
4. **Picker movido a `.picker-strip`.** El disparador de `EntityModal` + los chips
   de selección (territorio/dependencia + "volver a Costa Central") se extrajeron
   del `.nav` a una franja persistente bajo los tabs, visible en las 3 pantallas.
   `EntityModal` se monta a nivel de `App` (compartido).
5. **`onPick` de establecimiento → `setPantalla("ficha")`.** Por qué: el detalle
   (`Detalle`) sólo renderiza en la ficha; si el usuario busca un establecimiento
   desde un stub, saltar a ficha evita el "elegí un EE y no pasa nada".

**Decisión de diseño declarada (tensión Paso 4):** el encargo pide "mantener los
segmentadores de Nivel (grado) y Vista DENTRO del banner". En esta fase **grado/
año/GSE quedaron en la pantalla ficha**, no en una franja persistente, porque:
(a) son los filtros de la grilla y sólo funcionan en ficha; ponerlos persistentes
los mostraría **inertes** en los stubs territorial/comparar; (b) el banner real es
HTML estático fuera de `App` (`<header class="app">`), y los segmentadores son
componentes React gobernados por el estado de `App` — inyectarlos en el header
estático sería reescribir, no reubicar; (c) la "Vista actual/histórica" NO existe
aún como toggle (el encargo dice no inventarla). Se respeta "sólo reubica lo que
ya existe" + "lógica intacta". **El split definitivo controles-compartidos vs
controles-por-pantalla se decide en Fase 2**, cuando territorial/comparar sean
funcionales y necesiten controles propios. (Ver §5.)

---

## 4. Verificación de invariantes 🔒 (PASA/FALLA con evidencia)

| 🔒 | Resultado | Evidencia |
|----|-----------|-----------|
| Paleta 4 indicadores `#EE2D49 #FFC92E #9BC93E #2A8FD9` | **PASA** | leyenda: `rgb(238,45,73)/rgb(255,201,46)/rgb(155,201,62)/rgb(42,143,217)` exactos; radar/paneles intactos |
| Cero agregación territorial | **PASA** | stubs sin datos (0 tarjetas, 0 filtros, sin cifra); texto "no produce cifras agregadas" intacto; el stub sólo dice "En construcción" |
| Significancia por texto ("· sig."/"· n.s.") | **PASA** | doble ancla "vs su GSE ▼ -13 · sig." + "vs año anterior ▼ -14 · sig." en el detalle |
| Alcance nacional, foco Costa Central; no re-etiquetar "del SLEP CC" | **PASA** | header sin tocar ("establecimientos de todo Chile"); foco de apertura Costa Central (60 EE); tabs/stubs no re-etiquetan |
| Lógica de datos intacta (estado-vs-GSE, drill-down, EntityModal, búsqueda, preliminar, "sin dato"≠cero) | **PASA** | ficha idéntica navegando: grilla 60 → detalle → drill "Indicadores ▸ Autoestima…" → modal 4 pestañas → búsqueda; sólo se movió JSX a rama condicional |
| No tocar `34`/`idps_largo` (only=35) | **PASA** | md5 `idps_largo.parquet` = `50d9de4f1fc80259d29f499cdf46d9e1` sin cambio; sólo se editó el template |

**Sin FALLA.** Ningún invariante fue cruzado.

### Criterios de éxito
1. Regenera sin error, 4.6 MB (4 831 053 bytes) — **PASA**.
2. 0 errores de consola — **PASA**.
3. Ficha funcionalmente idéntica (verificado navegando, no por código) — **PASA**.
4. 3 tabs conmutan; territorial/comparar son stubs sin datos — **PASA**.
5. 4 colores de indicador intactos — **PASA**.
6. Commit atómico, sin publicar a `docs/` — **PASA**.

---

## 5. Lo que costó / notas honestas

- **Tensión Paso 4 (grado en el banner).** Resuelta con una decisión de diseño
  documentada (§3): grado/año/GSE quedan en ficha para no mostrar controles
  inertes en los stubs. Es la lectura conservadora ("no inventes", "lógica
  intacta"); puede revisarse en Fase 2.
- **`.nav` sticky.** El bloque de filtros grado/año/GSE conserva su
  `position:sticky;top:0` (heredado de la fase de rediseño visual). Con los tabs +
  picker-strip arriba (no sticky), al hacer scroll los filtros se fijan al tope
  mientras tabs/picker se van. Es cosmético y aceptable para andamiaje; el
  comportamiento sticky-vs-no-sticky del top se afina en Fase 2.
- **Edge de picker en stubs.** Elegir región/comuna/dependencia desde un stub
  actualiza el estado pero no muestra nada (la grilla vive en ficha). Mitigado
  para establecimientos (saltan a ficha). Region/comuna/dependencia desde un stub
  quedan aplicados cuando el usuario va a ficha. Aceptable para andamiaje.
- **Artefactos incidentales en el árbol.** Al cerrar quedaron cambios sin
  versionar en `50_documentacion/estructura/` (snapshots del escáner, ajenos a
  esta fase). No se incluyeron en el commit; se limpian en el próximo paso
  administrativo.

---

## 6. Pendientes para Fase 2 (ficha rediseñada)

1. **Ficha rediseñada** según el handoff: layout de la pantalla "Panorama IDPS por
   establecimiento" (el detalle/ficha), incluyendo el toggle **Vista
   actual/histórica** (que hoy NO existe y NO se inventó).
2. **Split de controles** banner-persistente vs por-pantalla: decidir si Nivel
   (grado) sube a una franja persistente y qué controles viven en cada pantalla
   cuando territorial/comparar sean funcionales.
3. **Pantalla territorial** (Fase posterior): la grilla pasa a ser su contenido.
4. **Pantalla comparación entre territorios** (Fase posterior): pantalla nueva,
   respetando 🔒 cero agregación (comparar distribuciones/desvíos, jamás promedios
   territoriales).
5. **Sticky del top:** afinar el comportamiento de tabs/picker/filtros al scroll.
6. Pendientes heredados (sesión 6, no de esta fase): 45 definiciones largas sin
   acentuar (sin fuente verificable); republicación de `docs/` + traspaso, a la
   espera de la revisión visual con Claude Design.

---
*Fin del log — Rediseño Fase 1.*
