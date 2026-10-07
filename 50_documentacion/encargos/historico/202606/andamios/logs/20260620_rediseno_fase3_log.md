# Log de cierre — Rediseño Fase 3: saneamiento de nombres + Panorama territorial + auditoría de cierre

Fecha: 2026-06-20 · Modo: encargo autónomo secuencial · Alcance: `only=35` (template + generador R + regeneración). **Sin commitear — para revisión del titular.**

## 1. Resumen

Tres frentes: (1) **saneamiento de nombres de establecimiento** con jerarquía de 3 capas
(caracterización curada verbatim para el SLEP Costa Central; directorio con apóstrofo/comilla
saneados por bytes para el resto; fallback idps); (2) **pantalla Panorama territorial** nueva
(secciones por GSE con barras apiladas de estado vs GSE + grilla de tarjetas mini-radar; la
grilla migró desde la pantalla ficha); (3) **auditoría de salud** + **panel adversarial**.

El trabajo tocó el generador `35_generar_motor_html.R` (donde se resuelven los nombres) y el
template `35_motor_template.html` (UI territorial + `nomEE`). Las **cifras no cambian**:
`idps_largo.parquet` intacto (md5 idéntico). 0 errores de consola.

Lo que costó: el diagnóstico del apóstrofo contradijo la premisa del encargo (no era `0x5e`),
lo que obligó a un gate de decisión del titular (ver §4 y §7).

## 2. Inventario de commits

- **Commit 1** `00e567d` — feat(motor): panorama territorial (barras apiladas estado vs GSE
  + grilla mini-radar) y saneamiento de nombres (caracterizacion para EE SLEP, apostrofo
  reparado para el resto). 3 archivos: `35_motor_template.html` + `35_generar_motor_html.R` +
  `40_salidas/motor_idps.html`. NO a `docs/`.
- **Commit 2** `c7a69c2` — docs(andamios): versiona referencia rediseno_3pantallas y logs
  fases 1-2. 10 archivos: `50_documentacion/andamios/diseno/rediseno_3pantallas/` (sin
  `.DS_Store`) + `20260620_rediseno_fase1_log.md` + `20260620_rediseno_fase2_log.md`.
  (NO el log de Fase 3, NI snapshots del escáner, NI `.claude/`.)

## 3. Cambios sustantivos (causa raíz)

**Generador R (`35_generar_motor_html.R`):**
1. Carga `caracterizacion_establecimientos.xlsx` (readxl; `Encoding<-"UTF-8"` defensivo) →
   mapa `rbd → nombre_curado` (solo los 73 RBD del SLEP CC, de los cuales 67 tienen 4b/2m en
   el motor). Causa: autoridad curada con tildes/mayúsculas/apóstrofo correctos.
2. `sanea_nombre_dir()`: reparación de codificación por codepoints (regla titular):
   `U+00B4`(´)/`U+005E`(^) → `U+0027`('); `U+0060`(`) en par → `U+0022`("); backtick impar →
   `U+0027` + anomalía logueada. Causa: el directorio usa codepoints erróneos donde va
   apóstrofo/comilla.
3. `est_attr`: jerarquía de nombre de 3 capas + flag `cur` (curado). `establecimientos_lst`
   serializa `cur`. Verificación por bytes (stopifnot: 0 nombres con U+00B4/U+005E/U+0060).

**Template (`35_motor_template.html`):**
4. `nomEE(e)`: nombre de presentación del EE — curado verbatim (cur=true; `tc()` lo rompería:
   "La Greda"→"la Greda") o `tc(nom)` para el resto. Aplicado en las 3 vías: `Card`, `Ficha`,
   `EntityModal/buildList`. Causa: el `tc()` baja conectores ("La") y rompería el nombre curado.
5. `repartoInd` + `pctRound` + `StackedBar`: barras apiladas de estado vs GSE (conteo de EE,
   no promedio); colores de ESTADO (`--alerta`/`--gris`/`--destaca`), distintos de la paleta.
   NA no cuenta (N = EE con dato). Estado leído de `sigdifgru` (reusa `alertSummary`).
6. Pantalla `territorio`: controles (grado/año/GSE siempre visible) + crumb + help no-agregación
   + leyenda indicadores + leyenda de estado + secciones por GSE (encabezado + `pan-dist` con
   4 barras + `pan-grid` de `Card`). La grilla migró de `ficha` a `territorio`.
7. `Card`: + línea RBD aparte (`.card-rbd`, sin negrita/paréntesis) + `nomEE`. Mini-radar solo
   el EE (ya sin serie GSE). Clic → `irFicha` (setea EE + salta a ficha).
8. Pantalla `ficha`: con EE → `Ficha` (Fase 2); sin EE → invitación + botón a territorial.
   `onBack` regresa a territorial. Default de la app: `territorio`.
9. Deuda de sticky resuelta: `.nav` ya no es `position:sticky` (solo vive en territorial).

## 4. Veredicto del Paso 0 (lectura del estado real)

- **¿La grilla agrupaba por GSE?** SÍ. El `grupos` useMemo agrupaba `unidades` por GSE y
  renderizaba secciones `.gse-group`. Fase 3 reusó ese agrupamiento (ahora `.gse-sec`).
- **Diagnóstico del apóstrofo POR BYTES (contradice la premisa del encargo):** la premisa decía
  `0x5e` (`^`). La realidad en `directorio_oficial_ee_publico.csv` (16.768 nombres) es una
  **familia de codepoints**:
  - `U+0060` (`` ` `` backtick): **118 nombres** — mixto: ~31 apóstrofo (entre letras) + 173
    como **comillas** que envuelven un nombre (`` `ARMANDO CARRERA GONZALEZ` ``).
  - `U+00B4` (´ acento agudo): **46 nombres** — apóstrofo (45 entre letras + 1 `DELL´ ORO`).
  - `U+005E` (^ circunflejo): **1 nombre** (RBD 1684 "O^HIGGINS") — el ÚNICO `0x5e`.
  - `U+0027` (' correcto): 15 nombres (no se tocan).
  El "O^higgins" que vio el titular es RBD 1684, **del SLEP CC** → lo resuelve la caracterización.
- **"la Greda" es artefacto de `tc()`, no del directorio:** el directorio trae "COLEGIO LA GREDA"
  (correcto); `tc()` baja "LA"→"la" (conector). Fix: nombre curado verbatim (sin `tc()`).
- **Caracterización:** hoja "Datos oficiales SLEP CC", 73 filas, columnas `RBD` +
  `Nombre del establecimiento`. Cobertura 73/73 SLEP CC, 0 fuera. Apóstrofo `U+0027`,
  "Colegio La Greda" (L=`U+004C`), tildes (á=`U+00E1`).

## 5. Saneamiento de nombres (jerarquía de 3 capas, checks por bytes)

**Decisión del titular (gate):** Opción 2 (distinguir por contexto), regla determinista:
`U+00B4`/`U+005E` → `'` siempre; `U+0060` en par → `"`; backtick impar → `'` + anomalía;
solo EE fuera del SLEP (los del SLEP usan caracterización); verificar por bytes.

**Implementación y checks por bytes (no visual; locale C / Bug 2):**
- `[NOMBRES] saneo OK: 0 nombres con U+00B4/U+005E/U+0060` (stopifnot en R, sobre los 8329 EE).
- **67 EE curados** (caracterización; de 73 RBD CC, 67 tienen 4b/2m en el motor).
- **32 nombres con backtick IMPAR** logueados y tratados como apóstrofo. Inspeccionados: TODOS
  son apóstrofos genuinos (posesivos/contracciones): "O\`HIGGINS", "ST. MARGARET\`S",
  "D\`HALMAR", "L\`ARC EN CIEL", "KIDS\` HOME", "MATEITO\`S"… → el fallback a `'` es correcto.
- Render verificado por codepoints en navegador:
  - SLEP CC (curado): "Colegio **La** Greda" (`U+004C` L mayúscula); "Escuela Libertador
    Bernardo O**'**Higgins" (apóstrofo `U+0027`, H mayúscula); tildes presentes
    (Artístico/Chacón/Básica). 0 `^`/`` ` ``/`´`.
  - No-SLEP (directorio saneado): EntityModal "higgins" → 35 resultados, **0 corruptos**,
    "O'higgins" (`U+0027`); grilla región Valparaíso 747 EE → 0 corruptos; "King Edward's",
    "St. Margaret's" (backtick→apóstrofo).
- **DATO vs GLIFO (resuelto):** el problema era el DATO (codepoints erróneos, ya reparados
  por bytes), NO el glifo. La auditoría confirmó tabla `cmap` presente en las 7 fuentes
  embebidas (gobCL/Museo Sans) y la verificación en navegador muestra "O'Higgins", "La Greda",
  "Artístico", "Chacón", "Básica" SIN carácter de reemplazo → la fuente tiene los glifos de
  apóstrofo (U+0027) y vocales acentuadas. Son dos problemas independientes; aquí solo existía
  el de dato, ya saneado.
- **Limitación documentada:** para EE FUERA del SLEP, `tc()` produce "O'higgins" (h minúscula),
  porque no se puede corregir capitalización sin fuente curada (invariante "no inventar").

## 6. Auditoría de salud (Paso 8)

4 agentes read-only auditaron 8 dimensiones. **Hallazgos clasificados:**

| Sev | Dimensión | Hallazgo | Acción |
|-----|-----------|----------|--------|
| ALTA | Nombres/encoding | Saneo implementado correctamente (0 corruptos tras saneo) | ✅ ya hecho |
| ALTA | A11y | Tarjetas eran `div` con onClick (no accesibles por teclado) | **CORREGIDO** (role=button + tabIndex + onKeyDown + aria-label + :focus-visible) |
| ALTA | A11y | StackedBar comunicaba estado solo por color en segmentos angostos | **CORREGIDO** (`role="img"` + aria-label con la distribución completa en texto; segmentos `aria-hidden`) |
| ALTA | Edge/datos | "53 RBD inaccesibles por comuna NA" | **FALSO POSITIVO**: el agente leyó idps_largo (pre-coalesce). Re-derivé post-coalesce con el directorio: **0 EE del motor con cod_com NA**; el directorio (autoridad H8) cubre el 100% de la geo. No requiere fix. |
| MEDIA | Código muerto | CSS huérfano de Fases 1-2 (.gse-group/.gse-head/.tag/.cnt/.grid/.detail/.back/.dmeta/.dcrumb/.row2/.blk/.anchor-row/.ar-*/.anclas/.go/.distrow) | **ELIMINADO** (grep confirmó 0 usos en markup; se conservaron .ancla/.arr/.bar/.actores; .actores pasó a regla standalone) |
| MEDIA | Nombres | 32 backticks impares tratados como apóstrofo | Documentado (todos apóstrofos genuinos; fallback seguro). Auditar en la Agencia (no en alcance). |
| MEDIA | A11y | Contraste `--destaca` (#3a8f4a) 4.03:1 con texto blanco 11px < 4.5:1 AA | **Pendiente Fase 4** (token global; el significado va por leyenda+aria, no solo color). |
| MEDIA | Rendimiento | ~747 mini-radares D3 en región grande (~1 s) | **Pendiente Fase 4** (lazy/virtualización). |
| MEDIA | Visual | `.seg` claro vs `.seg-lvl big` oscuro | Intencional (filtro vs identidad). Documentado. |
| MEDIA/BAJA | A11y | Tooltips D3 (radar) solo por hover | Pendiente Fase 4 (StackedBar ya expone aria/title; leyenda de indicadores ya tiene foco teclado). |
| BAJA | Edge/datos | Territorios con N=1-2; GSE ausentes; combinaciones todo-NA | Manejados (grilla N=1 OK; secciones omiten GSE vacío; reparto `sin dato`; empty state). Sin acción. |
| BAJA | Navegación | default territorio, card→ficha, invitación, volver, cambios de filtro | Sin regresiones. |

**Corregido en Fase 3 (ALTA seguros en alcance):** a11y de teclado en tarjetas; a11y de
barras apiladas; eliminación de CSS muerto. El resto quedó documentado como pendiente.

## 7. Panel adversarial de datos (Paso 9) — 5/5 PASA

5 agentes solo-lectura re-derivaron con código propio:
1. **Barras = conteo, no promedio.** PASA. Re-derivó un caso (4b/2025/GSE3/Costa Central, N=103):
   bajo=40, neutro=55, sobre=8. `repartoInd` itera EE e incrementa contadores por `sigdifgru`,
   filtra NA (`prom!=null`); `StackedBar`→`pctRound` (sin media). Comentario y UI: "% (n)…no promedio".
2. **Estado leído de difgru/sigdifgru; NA no cuenta.** PASA. `sigdifgru` se pasa directo del parquet
   (`ind$sigdifgru`), `indOf` lo lee sin aritmética; dominio {-1,0,1,NA}. NA: `prom==null` queda
   fuera de N; `sigdifgru==NA` con `prom!=null` cae a `neutro` (no a 0). Sin derivación.
3. **Sin GSE absoluto.** PASA. `#B7AC96`=0; `Card` llama `Radar` SIN `axesB`; `gseRef`/`.bar-gse`
   solo en comentario.
4. **Nombres saneados sin tocar cifras.** PASA. 8329 EE antes/después (left_join con caracterización
   estable, rbd único); `sanea_nombre_dir`/`est_attr` solo construyen `nom`, nunca prom/dif/sigdif/
   difgru; medidas leídas directas; nombres SLEP por bytes correctos; saneo deja 0 codepoints corruptos.
5. **md5 intacto.** PASA. `50d9de4f1fc80259d29f499cdf46d9e1`; `git status` sin `.parquet` modificado;
   bajo `30_procesamiento` solo `35_motor_template.html` + `35_generar_motor_html.R`.

Hallazgos con riesgo residual: **ninguno**.

## 8. Bugs (síntoma → causa → fix → verificación)

Sin bugs nuevos introducidos en Fase 3. Notas:
- Se evitó la trampa del `*/` dentro de comentario CSS (lección Fase 2): verificado que el
  bloque de comentarios nuevos no contiene `*/` espurios; el motor regenera y los estilos
  aplican (territorial renderiza con fondos/colores correctos, 0 errores de consola).
- **Falso positivo del agente de edge-cases** (no es bug del motor): reportó "53 RBD sin comuna";
  re-derivado post-coalesce del directorio → 0 EE del motor con cod_com NA. La lección: auditar
  siempre la columna FINAL (est_attr), no la cruda de idps_largo.

## 9. Invariantes 🔒 (PASA/FALLA con evidencia + md5)

- 🔒 Autoridad de nombres en dos niveles. **PASA** — caracterización para 67 EE SLEP;
  directorio saneado para el resto; no se usó caracterización fuera del SLEP; no se inventó
  ortografía fuera del SLEP (solo se reparó el apóstrofo por bytes).
- 🔒 Las cifras no cambian; md5 idéntico. **PASA** — `50d9de4f1fc80259d29f499cdf46d9e1`
  antes y después; 8329 EE sin cambio; el saneo solo construye `nom`.
- 🔒 Encoding por bytes. **PASA** — stopifnot 0 codepoints corruptos; verificación de render
  por codepoints; `Encoding<-"UTF-8"` defensivo en caracterización y `nom`.
- 🔒 Cero agregación territorial. **PASA** — barras = % (n) de EE por estado; suma 100%;
  el panel re-derivó un reparto (4b/2025/GSE3/CC, N=103: 40/55/8) y confirmó conteo, no promedio.
- 🔒 Lee, no deriva — sin GSE absoluto. **PASA** — mini-radar 1 trazo (solo EE); grep
  `#B7AC96`=0 en el HTML generado; `bar-gse`/`gseRef` solo en comentario.
- 🔒 Estado vs GSE leído de difgru/sigdifgru. **PASA** — `repartoInd` usa `sigdifgru` (reusa
  `alertSummary`).
- 🔒 Paleta de 4 indicadores intacta. **PASA** — colores de estado (alerta/gris/destaca)
  distintos de la paleta; filas de barra etiquetadas con color de indicador.
- 🔒 Significancia por texto. **PASA** — leyenda + title de segmentos con "significativo".
- 🔒 "Sin dato" ≠ cero. **PASA** — NA excluido del reparto (N = EE con dato); tarjeta "sin dato".
- 🔒 GSE inviolable, filtro siempre visible. **PASA** — pills GSE siempre renderizadas en
  territorial, no colapsables.
- 🔒 Radar solo 4 indicadores; RBD línea aparte; alcance nacional foco CC. **PASA**.
- 🔒 No tocar 34 ni regenerar parquet; only=35. **PASA**.

## 10. Decisiones en gates

- **Gate (b) apóstrofo ≠ 0x5e:** DETENIDO y reportado; el titular eligió la Opción 2 (regla
  determinista por contexto). Implementada exacta.
- **`tc()` para curados:** se omite (`nomEE` muestra curado verbatim).
- **Card meta:** se mantuvo "comuna · dependencia" (informativo) + RBD aparte; el territorio es
  contextual (picker + sección). Decisión propia documentada.
- **Default de la app → `territorio`** (entrada natural: panorama; la ficha requiere selección).
- **Coherencia de controles:** `.seg` claro = contexto de filtro (barras claras); `.seg-lvl big`
  oscuro = cabecera de identidad del EE (Fase 2). Intencionalmente distintos, mismos tokens.

## 11. Pendientes abiertos (`# REVISAR`)

- `# REVISAR` (Fase 4) Rendimiento: región grande (~747 EE) renderiza ~747 mini-radares D3
  (~1 s). Funciona, pero conviene lazy-render/virtualización.
- `# REVISAR` (Fase 4) `tc()` baja "La/El/Los" en EE fuera del SLEP ("la Greda"-like). Sin fuente
  curada nacional no se corrige (invariante). Sería resoluble con un diccionario de excepciones.
- `# REVISAR` (Fase 4) "Vista histórica deshabilitada" no demostrable en vivo (ningún grado de
  un solo año en el dato).
- `# REVISAR` (Fase 4) Contraste WCAG de `--destaca`/`--gris` con texto blanco 11px en barras
  apiladas (4.0–4.03:1 < 4.5:1). El significado va por leyenda + aria-label; el color es de
  apoyo. Fix posible: oscurecer el token `--destaca` (afecta también la ficha de Fase 2).
- `# REVISAR` (Fase 4) Tooltips D3 del radar solo por hover (no teclado). La barra apilada ya
  expone `aria-label`/`title`; la leyenda de indicadores ya tiene foco de teclado.
- `# REVISAR` (Agencia) 32 nombres con backtick impar (tratados como apóstrofo, todos genuinos);
  auditar en la fuente.
- `# REVISAR` (datos, pre-existente) RBD con `nom_rbd` NA en idps_largo que el directorio sí
  nombra: el motor los muestra bien vía directorio; confirmar que ninguno queda como "RBD x".

## 12. Estado de cifras / datos críticos

Sin cambios en cifras. `idps_largo.parquet` intacto (md5 idéntico). El saneamiento es 100%
etiquetas. 8329 EE, 67 con nombre curado. Spot-checks de nombres por bytes: correctos.

## 13. Notas para el revisor (Fase 4)

- Mirar con ojo crítico la **distinción dato-vs-glifo** (§5): el dato está reparado por bytes;
  confirmar visualmente que la fuente no muestra cuadros de reemplazo en apóstrofo/tildes.
- La **regla de backtick impar** trató 32 nombres como apóstrofo (todos verificados como
  apóstrofos genuinos), pero la heurística es por paridad; si el directorio se actualiza, revisar.
- **Coherencia visual** territorial (claro) vs ficha (oscuro): decidir en Fase 4 si se unifica.
- **Rendimiento** del panorama en regiones grandes.
