# Encargo autónomo — Pestaña SLEP en el selector territorial (Panorama territorial)

> Modo autónomo, secuencial. Ejecuta TODO en este turno, sin pedir confirmación
> entre fases. Patrón: `herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md`.
> Tipo de trabajo: presentación + proyección del generador. Parquet y pipeline de
> datos (31-34) NO se tocan; build = `run_all(only = 35)`.

---

## 0. Contrato de ejecución

- **Disciplina:** modo autónomo, secuencial. Lees el estado real antes de tocar
  nada (no modificar sin leer), implementas, regeneras con `only=35`, verificas
  en navegador, commiteas por fase con mensaje temático. No fragmentas: la ruta
  ya está aprobada por el titular.
- **Regla de detención (PARA y reporta solo si):**
  1. Un invariante 🔒 te obligaría a violar el contrato de datos/gobernanza.
  2. Un dato real contradice un supuesto de este encargo (p. ej. el generador no
     arma `DATA.sleps` como aquí se describe, o `anio_traspaso` no llega).
  3. Un gate estratégico no previsto. (No hay ninguno abierto.)
  En esos casos reportas y esperas; no improvisas metodología.
- **Reglas canónicas heredadas (no se re-explican, ver política):** rutas
  absolutas siempre (`git -C /Users/tomgc/Projects/slep_idps …`); sin asumir
  `cd` previo; R-only; comentarios en español; commits atómicos temáticos (jamás
  `git add .`); `git status` revisado antes de cada `git add`; push solo con
  `git status` limpio (y solo cuando el titular lo apruebe: este encargo NO
  pushea ni despliega).

---

## 1. La meta (aprobable como un todo)

El selector de territorio del **Panorama territorial** de IDPS (componente
`EntityModal`, invocado desde la franja/picker territorial) hoy ofrece las
pestañas **Región · Comuna · Dependencia · Establecimiento**. El titular quiere
que sea como el selector del motor de categoría (`slep_categoria_desempeno`):
con una pestaña **SLEP** que liste cada SLEP y muestre su **año de traspaso**
como etiqueta a la derecha ("Traspaso 2026", "Traspaso 2025", etc.), igual que
la columna `.check-region` de las demás filas.

**Resultado esperado:** el selector territorial ofrece **Comuna · SLEP · Región ·
Dependencia · Establecimiento**. La pestaña SLEP lista los 36 SLEPs (filtrables
por el buscador), cada uno con `sub: "Traspaso " + anio_traspaso`. Seleccionar un
SLEP fija la navegación territorial a ese SLEP (igual que hoy hace el foco Costa
Central y que el comparador con `kind:"slep"`).

**Decisión de diseño ya tomada (no es gate, se declara):** NO se elimina la
pestaña **Dependencia** (IDPS la usa y categoría no la tiene; quitarla sería
regresión). Se **añade** SLEP y se **alinea el orden** a la referencia dejando
Dependencia al final del bloque territorial. Orden final de `TABS`:
`[["comuna","Comuna"],["slep","SLEP"],["region","Región"],["dependencia","Dependencia"],["establecimiento","Establecimiento"]]`.

---

## 2. Regla de dominio (🔒 — semántica del año de traspaso)

- **🔒-DOM El `anio_traspaso` es ETIQUETA DE CONTEXTO, NO filtro temporal.** Un
  SLEP agrupa TODA la serie histórica de sus establecimientos como propia,
  **incluidos los años anteriores a su traspaso**. Los resultados IDPS 2025 de un
  establecimiento traspasado en 2026 SÍ se agrupan bajo ese SLEP. El año de
  traspaso se MUESTRA en la fila del SLEP (como dato informativo) pero NUNCA
  recorta qué años se atribuyen al SLEP. Esto ya es coherente con cómo el
  comparador de IDPS agrupa por `cod_slep` sin filtrar por año (D-s8-5) y con la
  nota del motor de categoría ("las cifras previas al año de traspaso no son
  atribuibles a la gestión del SLEP, sino a la administración municipal"). **No
  introduzcas ningún filtro por `anio_traspaso` en la selección ni en la
  agregación.** La pestaña SLEP debe agrupar exactamente igual que el foco actual
  y que el comparador: por `cod_slep`, toda la serie.

---

## 3. Invariantes (🔒 — intocables)

- **🔒-1 Parquet intacto.** `idps_largo.parquet` md5 debe seguir siendo
  `50d9de4f1fc80259d29f499cdf46d9e1` antes y después. Si cambia, PARA y reporta
  (significa que tocaste el pipeline de datos, no la presentación).
- **🔒-2 Pipeline 31-34 intacto.** Solo se editan `35_generar_motor_html.R`
  (proyección del JSON) y `35_motor_template.html` (UI). Build = `run_all(only =
  35)`. NO se ejecutan ni modifican 31-34.
- **🔒-3 Cero agregación de cifras IDPS.** Esta tarea es de navegación/selección,
  no toca cómo se leen las cifras. La unidad sigue siendo el establecimiento; el
  territorio solo filtra qué establecimientos se muestran (igual que hoy).
- **🔒-4 `docs/` NO se republica.** Termina en el `motor_idps.html` regenerado +
  commits locales. El deploy a Pages espera OK visual del titular (compuerta).
- **🔒-5 Comentarios CSS sin `*/` literal** (Bug s7-1).
- **🔒-6 Sin nombres reales de EE en código** (gobernanza): no aplica cambios
  aquí, pero no introduzcas constantes con nombres de establecimientos.

---

## 4. Contexto técnico (rutas y estado real)

- **Raíz de código:** `/Users/tomgc/Projects/slep_idps`
- **Generador (se edita — proyección del JSON embebido):**
  `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`
- **Template (se edita — UI):**
  `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
- **Catálogo de SLEPs (solo lectura, fuente del dato):**
  `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/sleps_chile.parquet`
  — columnas: `cod_slep`, `nombre_slep`, `anio_traspaso` (int, constante por
  SLEP), `cod_com_rbd`, `nom_com_rbd`, `rbd`, `nom_rbd`. 36 SLEPs. Costa Central
  (`cod_slep` 503) → `anio_traspaso` 2025.
- **Build:** `source(here::here("00_build.R")); run_all(only = 35)` regenera
  `40_salidas/motor_idps.html` desde el template + el JSON que arma el generador.
- **Referencia de diseño (read-only):** el motor de categoría
  (`slep_categoria_desempeno`) muestra la pestaña SLEP con `sub: "Traspaso " +
  s.anio_traspaso`. Replica ese copy y ese formato de etiqueta.

### Estado real — lo que YA EXISTE en el template IDPS (no reconstruir)

El patrón de pestaña SLEP ya está escrito en IDPS, pero **solo en el comparador**
(pantalla 3), no en el selector territorial:

- `SLEPS_OPTS` (≈L1107): deriva conteos de EE y comunas por `cod_slep` desde
  `DATA.establecimientos`, y mapea sobre `DATA.sleps`. **Hoy proyecta**
  `{cod, nom, ee, ncom}` — NO incluye `anio_traspaso` (porque el generador no lo
  expone, ver abajo).
- `TABS_CMP` (≈L1110): `[["slep","SLEP"],["comuna","Comuna"],["region","Región"]]`
  — pestañas del **comparador**.
- La rama `tab==="slep"` de `buildListCmp` (≈L1112) ya construye
  `{kind:"slep", cod, nom:"SLEP "+nom, sub:...}`. Reusa este patrón.
- El selector **territorial** usa otro `TABS` (≈L1064, Región/Comuna/Dependencia/
  Establecimiento) y otro `buildList` (≈L1066). **Aquí** es donde hay que añadir
  la rama SLEP.
- `EntityModal` (≈L1020) es genérico y portable: recibe `tabs`, `buildList`,
  `searchPlaceholderFor`, `emptyTextFor`. NO necesita cambios estructurales; solo
  cambian los `tabs` y el `buildList` territorial que se le pasan.
- La fila renderiza `item.nom` (`.check-name`) e `item.sub` (`.check-region`).
  "Traspaso AAAA" va en `sub`.

### Estado real — el generador `35_generar_motor_html.R`

Claude Code confirmó en la verificación previa: el generador arma `DATA.sleps`
con `cod_slep`, `nombre_slep`, `cod_reg` — **NO incluye `anio_traspaso`**. El
dato existe en `sleps_chile.parquet` pero no se expone al cliente. **Paso 0 de la
Fase 1 es leer el generador** para localizar exactamente dónde se construye la
proyección de `sleps_lst` (o como se llame la lista que va a `DATA.sleps`) y
añadir `anio_traspaso` ahí. NO asumas el nombre de la variable ni la forma del
`dplyr`/`jsonlite`: léelo.

---

## 5. Fases en orden estricto

### Fase 1 — Leer el estado real (Paso 0, no modificar sin leer)

1. md5 del parquet ANTES:
   `md5 /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
   → debe ser `50d9de4f1fc80259d29f499cdf46d9e1`. Anótalo.
2. Lee `35_generar_motor_html.R`: localiza la construcción de la lista de SLEPs
   que se serializa a `DATA.sleps` (probablemente un `distinct`/`select` sobre
   `sleps_chile.parquet` o sobre un objeto ya cargado). Identifica el nombre real
   de la variable y las columnas que hoy proyecta.
3. Lee en `35_motor_template.html`: el `TABS` territorial (≈L1064), el
   `buildList` territorial (≈L1066), la rama `tab==="slep"` del comparador
   (≈L1112) como patrón, y cómo `DATA.sleps` se consume hoy (L499, L1108). Anota
   cómo se fija la navegación al elegir territorio (el handler `onSelect` del
   `EntityModal` territorial: a qué estado escribe `{kind:"slep", cod}`).

Sin commit (solo lectura).

### Fase 2 — Exponer `anio_traspaso` en el JSON (generador)

En `35_generar_motor_html.R`, añade `anio_traspaso` a la proyección de la lista
de SLEPs que alimenta `DATA.sleps` (un `dplyr::select()`/`mutate()` adicional de
la columna ya presente en `sleps_chile.parquet`). Mantén el grano: una fila por
SLEP (`distinct(cod_slep, nombre_slep, anio_traspaso, cod_reg)` o equivalente —
si hoy ya hace `distinct` por SLEP, solo agrega la columna). No cambies nada más
del generador.

**Criterio de éxito Fase 2:** tras regenerar (Fase 5), `DATA.sleps` en el motor
incluye `anio_traspaso` por SLEP. (Verificable: `grep anio_traspaso
40_salidas/motor_idps.html` > 0 tras el build, y un SLEP de muestra con su año.)

**Commit:** `feat(motor): exponer anio_traspaso en DATA.sleps (generador 35)`

### Fase 3 — Pestaña SLEP en el selector territorial (template)

1. **`SLEPS_OPTS` territorial:** asegúrate de que la proyección de SLEPs que usa
   el selector territorial lleve `anio_traspaso`. Si el `SLEPS_OPTS` existente
   (comparador) ya mapea sobre `DATA.sleps`, extiéndelo para incluir
   `anio_traspaso: s.anio_traspaso` (sin romper su uso en el comparador, que
   seguirá ignorando ese campo). Si prefieres una proyección territorial separada
   para no acoplar, justifícalo en el log.
2. **`TABS` territorial:** cambia a
   `[["comuna","Comuna"],["slep","SLEP"],["region","Región"],["dependencia","Dependencia"],["establecimiento","Establecimiento"]]`.
3. **`buildList` territorial, rama `tab==="slep"`:** añade (reusando el patrón del
   comparador L1112)
   ```js
   if(tab==="slep") return SLEPS_OPTS.filter(s=>!ql||String(s.nom).toLowerCase().includes(ql))
     .map(s=>({kind:"slep", cod:s.cod, nom:"SLEP "+s.nom, sub:"Traspaso "+s.anio_traspaso}));
   ```
   (Ajusta nombres de campo a lo que `SLEPS_OPTS` exponga realmente tras el paso
   1. El `sub` DEBE ser `"Traspaso "+anio_traspaso`, regla 🔒-DOM: es etiqueta.)
4. **Placeholder/empty del buscador** para la pestaña SLEP: añade el caso `slep`
   a `searchPlaceholderFor` (p. ej. "Buscar un SLEP…") y a `emptyTextFor` si
   aplica.
5. **Handler `onSelect`:** verifica que al elegir un `{kind:"slep", cod}` la
   navegación territorial filtre por `cod_slep` exactamente como el foco actual
   (toda la serie histórica, 🔒-DOM). Si el `onSelect` territorial ya maneja
   `kind:"slep"` (por el foco), no dupliques lógica; si no, replica el patrón del
   foco/comparador. NO introduzcas filtro por año.

**Criterio de éxito Fase 3:** el selector territorial muestra la pestaña SLEP
entre Comuna y Región; lista los 36 SLEPs con "Traspaso AAAA"; el buscador
filtra; elegir un SLEP fija la vista territorial a ese SLEP mostrando TODA su
serie (incluidos años previos al traspaso). Verificable en navegador: elegir un
SLEP traspasado en 2026 debe seguir mostrando sus datos 2022-2025.

**Commit:** `feat(motor): pestaña SLEP en selector territorial con año de traspaso como etiqueta`

### Fase 4 — Regenerar, verificar invariantes y md5

1. `source(here::here("00_build.R")); run_all(only = 35)` desde la raíz.
2. md5 del parquet DESPUÉS → debe seguir siendo
   `50d9de4f1fc80259d29f499cdf46d9e1` (🔒-1). Si cambió, PARA y reporta.
3. Abre `motor_idps.html` regenerado. Recorre Panorama territorial → abre el
   selector → pestaña SLEP. Confirma: 36 SLEPs, etiqueta "Traspaso AAAA",
   búsqueda funcional, sin errores de consola. Elige un SLEP de traspaso 2026 y
   confirma que muestra su serie histórica completa (🔒-DOM).

**Commit:** la regeneración del `motor_idps.html` puede ir en el commit de Fase 3
o como `build(motor): regenerar only=35` aparte; tú decides, documenta cuál.

---

## 6. Auto-auditoría antes de reportar

Presentación + proyección: basta el principio general + verificación en
navegador, MÁS estos checks (tocan dato y el límite del invariante de dominio):

1. **`anio_traspaso` llega al cliente:** `grep -c anio_traspaso
   40_salidas/motor_idps.html` > 0; muestra un SLEP con su año en el JSON.
2. **Etiqueta correcta:** la pestaña SLEP del render muestra "Traspaso 2025" para
   Costa Central (503) y "Traspaso 2026"/"2018"/etc. para otros, coincidiendo con
   `sleps_chile.parquet`. Spot-check 2-3 SLEPs contra el parquet.
3. **🔒-DOM (no es filtro):** elige un SLEP traspasado en 2026 en el selector y
   confirma por render que su Panorama territorial incluye años previos
   (2022-2025), NO solo 2026+. Confirma por código que `buildList`/`onSelect` no
   introdujeron ninguna comparación contra `anio_traspaso`.
4. **🔒-1 parquet:** md5 antes == después. Déjalo en el log.
5. **Dependencia sobrevive:** la pestaña Dependencia sigue presente y funcional
   (no se eliminó al reordenar).

## 7. Log de cierre (obligatorio)

Escribe `50_documentacion/andamios/logs/YYYYMMDD_pestana_slep_selector_log.md`
con la plantilla fija (sección 4 del encargo_autonomo_v1): resumen, inventario de
commits (hash + tipo + título + qué hizo), por cada cambio sustantivo (qué, por
qué, archivos, verificación, decisiones —p. ej. si extendiste `SLEPS_OPTS` o
creaste proyección territorial aparte—), verificación de cada 🔒 (incluida
🔒-DOM) con PASA/FALLA y evidencia, md5 antes/después, y notas para el revisor.
Sé honesto: incluye lo que costó. El log puede quedar sin commitear (revisión del
titular) o como `docs()` aparte; documenta cuál.

## 8. Reporte final (al titular, vía el asistente de análisis)

Reporta: estado final (hecho/parcial), inventario de commits con hash,
confirmación de los 5 checks de auto-auditoría (en especial 🔒-DOM: el SLEP de
2026 muestra serie completa), ruta del log, y si quedó algún `# REVISAR`. **NO
republiques `docs/` ni hagas push:** el deploy a Pages espera el OK visual del
titular sobre el `motor_idps.html` regenerado. Indica explícitamente que `docs/`
quedó sin tocar y que el deploy + push son el paso siguiente del titular.
