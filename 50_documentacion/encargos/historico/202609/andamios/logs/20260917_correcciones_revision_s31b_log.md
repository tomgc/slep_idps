# Log de sesión: correcciones de la revisión de s31 (s31b)

- **Meta:** corregir los cinco hallazgos de la revisión independiente del 2026-09-17 sobre el motor regenerado en s31 (nota "+N sin comparación publicada" bajo su barra; banner histórico por GSE; rótulo de sección con la regla aplicada; estado y encabezado de fila para el lector de pantalla; citas erradas del log de s31), commitear el motor regenerado (resuelve D-2 de s31) y hacer push, sin desplegar a `docs/`.
- **Fecha:** 2026-09-17
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main`
- **HEAD al empezar:** `cbcfdc8`. `origin/main` = `bc42fad` (s31 retuvo su push: seis commits locales sin publicar, `c93ea6d`..`cbcfdc8`; corregido en FASE L, ver errores propios). PUNTO DE RETORNO `<PR>` = `cbcfdc8` (FASE 0 no commitea nada).
- **ENTORNO:** Claude Code en la estación macOS del titular; R 4.5.2 con `renv` del proyecto; `bash -c` explícito en todo comando de shell; `Rscript` en todo cálculo sobre datos.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus 0. **Modo real de la sesión:** Opus 5 (1M), efecto de sesión `ultracode` activado por el titular pero el encargo prohíbe subagentes y workflows: se ejecuta en solo, en serie (el encargo manda).
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_correcciones_revision_s31b.md` (patrón v1.6). Encargo de origen: s31 (`…_vista_historica_territorial_s31.md`, §2, §4, §5 y §6 se heredan).
- **Grafo de tareas (copiado del encargo):**

```
T1 (nota +N en su columna)      independiente
T2 (banner por GSE)             independiente
T3 (rótulo de sección)          independiente
T4 (accesibilidad de la matriz) independiente
T5 (correcciones del log s31)   independiente
FASE R y FASE L                 corren siempre, al final, fuera del grafo
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando.

## J. Juicio
- Meta y resultado: corregir los cinco hallazgos de la revisión de s31 (nota bajo su barra, banner histórico por GSE, rótulo con la regla aplicada, a11y de la matriz, citas del log), commitear el motor regenerado y hacer push sin desplegar a `docs/` → cumplida, en una línea.
- Estado por tarea: T1 completada (`09ea2de`) · T2 completada (`d0614f3`) · T3 completada (`bad2309`) · T4 completada (`4c7179e` + `7350cb8` build) · T5 completada (en este log) · FASE R completada (sin reparaciones).
- Commits: 6, rango `09ea2de`..`<docs(log)>` (`git log --oneline`), de los cuales 0 fix(auditoria) y 1 build(motor).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/3; reparados 0; abiertos 0 (A-1 → P-4; A-2 previsto por el gate; A-3 cosmético).
- Invariantes: 8/8 PASA (🔒1–🔒7 de s31 + 🔒8 "ninguna cifra cambia", estático y dinámico); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: SHA-256 §8.2 `1e29c2b5…b5b6` en R y `sed`+`shasum`; `final.json == fase0.json`; 112 barras con `title`/segmentos/tira/nota/`aria` idénticos entre FASE 0 y el final; 🔒5/🔒6 = 0).
- Decisiones autónomas de mayor riesgo: (1) `align-items:center` conservado en `.pan-dist-row` (rótulo centrado sobre barra+nota, como el `<td>` del comparador; alternativa `subgrid`; reversible); (2) plural "1 establecimiento" aplicado también al subtítulo de la vista actual y a las notas nacionales (mismo rótulo; reversible); (3) glosa oculta con `EST_EE[k].lbl` y `<th scope="row">` + `<button>` en vez de `role="rowheader"` (reversible).
- Desviaciones respecto del encargo: el porcelain de FASE 0 traía el encargo sin versionar (gate: va con `docs(log)`); el push publica además los seis commits retenidos de s31; el encabezado del log corregido en FASE L (`origin/main` = `bc42fad`).
- Dudas abiertas: 0 nuevas; pendientes P-1 (enmienda §3.5: piso 4,58), P-2 (teclado del modal, backlog), P-3 (criterio del traspaso), P-4 (centrado del rótulo, gate visual); de s31 siguen D-1 y D-3, D-2 resuelta.
- Errores propios: 4 registrados (2 de instrumento en T4, 2 de forma en FASE L); ninguno costó más de un turno.
- Qué debe verificar el revisor por sí mismo: el aspecto de la nota bajo la barra y del rótulo del indicador en las filas con nota (P-4), el botón del nombre en la matriz (foco visible) y el subtítulo nuevo; esta sesión midió posiciones, árbol de accesibilidad y cifras, no gusto.
- No publicado / queda al usuario: despliegue a `docs/` pendiente del visto bueno visual; P-1, P-3 y P-4 en el cierre; D-1 y D-3 de s31.
- Ejecución: modo de sesión ultracode (efecto) ejecutado como xhigh en solo por contrato; subagentes 0, por contrato.


## Registro por fase

### FASE 0: punto de retorno y mediciones

- **Estado:** completada.
- **Commits:** ninguno.
- **PUNTO DE RETORNO `<PR>`:** `cbcfdc8`.
- **Cambios sustantivos:** ninguno en código. Se creó este log, `/tmp/idps_s31b/` (`motor_fase0.html`, `fase0.json`, `run35_fase0.log`, `t1_dx_fase0.json`) y el scratchpad de la sesión (`check_jsx.js` + `babel.min.js` 7.29.0 y `harness.js`, copiados del scratchpad de s31; `t1_dx.js`, nuevo).
- **Verificación:**

Medición previa a la creación del log (solo lectura):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps stash list; git -C /Users/tomgc/Projects/slep_idps rev-parse --short HEAD'
```
esperado: solo ` M 40_salidas/motor_idps.html`; stash vacío; `cbcfdc8`.
obtenido: ` M 40_salidas/motor_idps.html` **y** `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_correcciones_revision_s31b.md` (el encargo mismo, entregado por el redactor sin versionar; este encargo no tiene T0); stash vacío; `cbcfdc8`. Regla 0.1-1 disparada **antes de escribir nada**. Se consultó al titular (gate): eligió "Continuar; el encargo va con `docs(log)`" (patrón de s29i y s30: el encargo se versiona en el commit `docs(log)` de FASE L, con lo que el porcelain queda vacío para el push). Ver Decisiones del usuario (Cierre §5).

Línea base de PRUEBAS (motor en el árbol = regenerado por s31):
```
bash -c 'md5 -q 40_salidas/motor_idps.html; git show HEAD:40_salidas/motor_idps.html | md5 -q; Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31b/run35_fase0.log 2>&1; echo rc=$?; grep -inE "warning|advertencia|error" /tmp/idps_s31b/run35_fase0.log; grep -c WARN /tmp/idps_s31b/run35_fase0.log; md5 -q 40_salidas/motor_idps.html'
```
esperado: exit 0; 0 warnings (línea base de s31); el md5 del regenerado igual al del árbol (misma fecha de generación).
obtenido: árbol `575e50472508709b349d017227e0c767` (5.460.067 bytes; HEAD sigue en `2f34dafe1309b67e5e1e1cfb3eea47a3`); `rc=0`; grep vacío; `WARN: 0` (71 líneas; `[s31] vista_territorial: … tinte_minimo 0.06`; `Paso 35 OK en 4.3 s`); md5 después `575e50472508709b349d017227e0c767` (idéntico). **Línea base de warnings: ninguno.**

Fidelidad §4 sobre el motor de FASE 0 y extracción del JSON:
```
bash -c 'cd /tmp/idps_s31b && Rscript /tmp/idps_s31/fidelidad.R /tmp/idps_s31b/motor_fase0.html; Rscript /tmp/idps_s31/extraer_json.R /tmp/idps_s31b/motor_fase0.html /tmp/idps_s31b/fase0.json'
```
esperado: SHA-256 `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6` sin el bloque `vista_territorial`; 59.466.778 bytes; control positivo distinto.
obtenido: `JSON bytes: 59467009`; `bloque recortado: 231 chars, empieza en pos. 144459; caracter siguiente: '}'`; `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `bfcde7ac… -> DISTINTO (ok)`; `fase0.json` 59.467.009 bytes (zlib `78 9c`). **Regla 0.1-2 no dispara.**

Sintaxis y línea base de 🔒7:
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `JSX OK`; `0` (línea base de s31).
obtenido: `JSX OK — 2216 lineas de fuente -> 193255 bytes transpilados`; `0`.

Calibración de T1 (caso malo conocido, motor de FASE 0; Puppeteer 25.9.0 + Chrome del sistema, `file://`, viewport 1200):
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t1_dx.js /tmp/idps_s31b/motor_fase0.html > /tmp/idps_s31b/t1_dx_fase0.json'
```
esperado: sección Medio, SLEP foco, 4b: `dx` de la nota = −316, 0, −316, 0 (Autoestima, Convivencia, Participación, Hábitos).
obtenido: `dxSin` = `-316, 0, -316, 0`; además la **tira externa** (`.s100-ext`) de Convivencia y Hábitos cae también a −316 (misma causa: tercer ítem del grid); las cuatro barras comparten `left` 361. Franja histórica: 12 notas y 14 tiras, todas con `dx` 0; comparador (SLEP Costa Central): 4 notas y 12 tiras, todas 0. `errs: []`.

- **Alcance:** solo este log y `/tmp/idps_s31b/`.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings (línea base).
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** (1) el instrumento de hash sigue corriendo con `cd /tmp/idps_s31b && Rscript` (fuera de la activación de `renv`, donde `digest` no está), como en s31; reversible. (2) Se reutilizan `fidelidad.R` y `extraer_json.R` de `/tmp/idps_s31/` sin cambios (instrumentos, no código del repo).
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T1: la nota "+N sin comparación publicada" va bajo su barra

- **Estado:** completada.
- **Commits:** `09ea2de` fix(panorama): la nota de sin comparacion publicada va bajo su barra.
- **Causa medida:** `StackedBar` devolvía un Fragment; en `.pan-dist-row` (grid `300px 1fr`, `gap:16px`) sus hijos entraban como ítems sueltos: sin tira externa, la nota era el tercer ítem y caía en la celda del rótulo (fila 2, columna 1); con tira externa, era la **tira** la que caía ahí y la nota quedaba bajo la barra (cuarto ítem). Por eso la nota saltaba de columna entre filas. En la celda de la franja histórica (`.vt-franja-cell`) y en el `<td>` del comparador ya existía un contenedor y no pasaba.
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +18/−4):
  1. `StackedBar` devuelve `<div className="s100-wrap">…</div>` en sus dos retornos (barra "sin dato" y barra con segmentos): barra, tira externa y nota viven en el mismo contenedor en las tres pantallas.
  2. CSS `.s100-wrap{min-width:0;}` (misma razón que `.s100-seg`: que la columna `1fr` pueda encoger), con comentario que documenta la causa.
- **Verificación** (Babel 7.29.0 en node; motor regenerado; Puppeteer 25.9.0 + Chrome del sistema, `file://`, viewport 1200; script `t1_dx.js` del scratchpad; salida `/tmp/idps_s31b/t1_dx_t1.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `JSX OK`; `0`.
obtenido: `JSX OK — 2218 lineas de fuente -> 193461 bytes transpilados`; `0`.
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31b/run35_t1.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31b/run35_t1.log; md5 -q 40_salidas/motor_idps.html'
```
esperado: `rc=0`; 0 warnings nuevos.
obtenido: `rc=0`; `WARN: 0`; grep de warning/error vacío; md5 del motor `17765cf3ed464b17623ff172e0b7274e` (copia en `/tmp/idps_s31b/motor_t1.html`).
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t1_dx.js /tmp/idps_s31b/motor_t1.html > /tmp/idps_s31b/t1_dx_t1.json'
```
esperado: sección Medio del SLEP foco, 4° básico: `dx` = 0 px en los cuatro indicadores (la nota empieza donde empieza la barra).
obtenido: `dxSin` = `0, 0, 0, 0` (Autoestima, Convivencia, Participación, Hábitos); la tira externa de Convivencia y Hábitos también en `0` (antes −316). Calibración: el mismo instrumento sobre el motor de FASE 0 da `-316, 0, -316, 0` (registrado en FASE 0); el criterio distingue los dos motores.
esperado: en el comparador y en la franja de la vista histórica la nota sigue bajo su barra (0 px) y ninguna barra se desalinea.
obtenido: franja (SLEP foco, 4b, histórica): 12 notas y 14 tiras, todas `dx` 0; columnas de barras en `left` 319 (2024) y 744 (2025), un solo valor por columna. Comparador (SLEP Costa Central agregado): 4 notas y 12 tiras, todas `dx` 0; barras en 247/482/717/952 por indicador. Panorama: las 16 barras comparten `left` 361 y ancho 794. Comparando `(left, width)` de **todas** las barras de las tres pantallas entre `t1_dx_fase0.json` y `t1_dx_t1.json`: `identicas: true`. `errs: []`.
esperado (propio): la nota queda 3 px bajo la barra (o bajo la tira), `margin-top` de `.s100-sin`.
obtenido: `dySin` (top de la nota − bottom de la barra) = 3 px sin tira y 20 px con tira (la tira mide 17 px). Rótulos: `dyLab` (centro del rótulo − centro de la barra) = 0 en las 12 filas sin nota; 9 px (rótulo de dos líneas + nota) y 17 px (rótulo de una línea + tira + nota) en las 4 filas de Medio, porque `.pan-dist-row{align-items:center}` centra el rótulo sobre el bloque barra+tira+nota (antes del fix, la tira o la nota caían bajo el rótulo y el centrado era 0 por accidente). Ver decisión autónoma 1.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE. `40_salidas/motor_idps.html` regenerado, sin commitear todavía (va en el commit `build(motor)` tras la última tarea de código, 0.2).
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno (1 intento).
- **Decisiones autónomas:** (1) Se conserva `align-items:center` en `.pan-dist-row`: en las filas con nota el rótulo del indicador se centra sobre el bloque barra+nota (9–17 px bajo el centro de la barra), igual que el `<td>` del comparador (`vertical-align:middle`) centra el nombre del territorio sobre el mismo bloque. Alternativas descartadas: `align-items:start` + `min-height` del rótulo (deja 11 px de desfase en **todas** las filas con rótulo de dos líneas, que son la mitad: Autoestima y Participación miden 48 px); `grid-template-rows:subgrid` en `.s100-wrap` (centra siempre, pero es una regla más y un mecanismo nuevo en el motor). Reversible; se anota para el revisor visual. (2) `min-width:0` en el contenedor, por analogía con `.s100-seg`; no cambió ningún ancho medido.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T2: el banner de la vista histórica cuenta comunas del mismo universo que establecimientos

- **Estado:** completada.
- **Commits:** `d0614f3` fix(panorama): el banner historico cuenta comunas del universo filtrado.
- **Causa medida:** `univBanner=isHistPan?rosterHist:unidades` (R-25 de s31) tomaba el roster histórico **sin** filtrar por `gseVis`, mientras `nHist` sí filtraba: dos universos para dos conteos del mismo banner.
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +10/−3, `App`):
  1. `rosterHistVis=useMemo(()=>rosterHist.filter(r=>gseVis.has(r.gse||"sin")),[rosterHist,gseVis])`: **una sola expresión** filtrada por GSE.
  2. `nHist=rosterHistVis.length` y `univBanner=isHistPan?rosterHistVis:unidades`: establecimientos y comunas (`panComunas`, `panComunasNoms`) cuentan sobre el mismo arreglo. `PanoramaHistorico` sigue recibiendo `rosterHist` completo (filtra al armar sus secciones, sin cambio).
- **Verificación** (Babel; motor regenerado; Puppeteer, viewport 1200; script `t2_banner.js`; salida `/tmp/idps_s31b/t2_banner_t2.json`; reconteo `Rscript /tmp/idps_s31b/t2_comunas.R` sobre `fase0.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31b/run35_t2.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31b/run35_t2.log; md5 -q 40_salidas/motor_idps.html'
```
esperado: `JSX OK`; `rc=0`; 0 warnings nuevos.
obtenido: `JSX OK — 2225 lineas de fuente -> 194100 bytes transpilados`; `rc=0`; `WARN: 0`; md5 `b1cf25da6073730219e5477e0b5ad54f` (`/tmp/idps_s31b/motor_t2.html`).
```
bash -c 'cd /tmp/idps_s31b && Rscript /tmp/idps_s31b/t2_comunas.R /tmp/idps_s31b/fase0.json 4b; Rscript /tmp/idps_s31b/t2_comunas.R /tmp/idps_s31b/fase0.json 2m'
```
esperado: reconteo independiente: comunas distintas de los RBD con GSE vigente "5" en 4b = 96, con 555 EE; total 4b 8.284 EE en 346 comunas; vista actual 2025: 6.717 EE en 343 comunas.
obtenido: `GSE vigente 5 (Alto): 555 EE en 96 comunas`; `TOTAL: 8284 EE en 346 comunas`; `vista actual (2025): 6717 EE en 343 comunas`; por GSE vigente en 4b: 2141/280 · 2573/319 · 1868/314 · 789/188 · 555/96 · sin 358/162. En 2m: Alto `478 EE en 84 comunas`; total `3178 EE en 335 comunas`; actual `2999 EE en 335 comunas`.
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t2_banner.js /tmp/idps_s31b/motor_t2.html > /tmp/idps_s31b/t2_banner_t2.json'
```
esperado: Nacional, 4° básico, histórica, solo "Alto": "96 comunas · 555 establecimientos…".
obtenido: `96 comunas · 555 establecimientos con resultado en algún año · 4° básico · 1 de 5 GSE · 2014–2025*` (una sola sección, `Alto:555`; filtro `✓Alto[on]` y los demás apagados). Calibración: el mismo instrumento sobre el motor de FASE 0 (`t2_banner_fase0.json`) da `346 comunas · 555 establecimientos …` (caso malo conocido).
esperado: con los cinco GSE encendidos: "346 comunas · 8.284 establecimientos…".
obtenido: `346 comunas · 8.284 establecimientos con resultado en algún año · 4° básico · 5 de 5 GSE · 2014–2025*` (secciones 2.141/2.573/1.868/789/555/358); igual al volver a encender todo tras alternar vistas (`nac_hist_5_otraVez`).
esperado: vista actual sin cambios: "343 comunas · 6.717 establecimientos en el nivel seleccionado".
obtenido: `343 comunas · 6.717 establecimientos en el nivel seleccionado · 4° básico · 5 de 5 GSE · 2025 (preliminar)`; con solo "Alto" en la vista actual `90 comunas · 517 establecimientos` (ya era consistente: `unidades` filtra por GSE).
esperado (propio): sin "Sin clasificar" en nacional 4b histórica: 8.284 − 358 = 7.926 EE y comunas del universo filtrado (< 346 si alguna comuna solo aporta EE sin clasificar); 2° medio solo "Alto": 478 EE en 84 comunas (R).
obtenido: `345 comunas · 7.926 establecimientos …` (FASE 0 decía 346 con 7.926); 2m `84 comunas · 478 establecimientos …` (FASE 0: 335). SLEP foco: banner `61 … 5 de 5 GSE`, solo Medio `28 … 1 de 5 GSE`, lista de comunas `Concón, Puchuncaví, Quintero y Viña del Mar` en los tres estados (los 28 EE de Medio cubren las cuatro comunas). `errs: []`.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE. Motor regenerado, sin commitear todavía.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno (1 intento).
- **Decisiones autónomas:** `rosterHistVis` en `useMemo` con dependencias `[rosterHist,gseVis]` (`toggleGse` crea un `Set` nuevo por cambio, así que la dependencia es válida). Reversible.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T3: el rótulo de sección dice la regla que el código aplica

- **Estado:** completada.
- **Commits:** `bad2309` fix(vista-historica): el rotulo de seccion nombra la regla aplicada.
- **Paso 0, inventario** (`grep -n -iE 'último año|ultimo anio|con resultado'` sobre el template): una sola ocurrencia de la regla vieja, L2662 (subtítulo de sección de `PanoramaHistorico`). La ayuda (`.help`: "Cada fila es un establecimiento con su propio puntaje en cada año…") y el pie de la franja (`.vt-franja-foot`: "…el estado de un establecimiento se mide contra el GSE que tenía ese año") no la repiten; el banner dice "con resultado en algún año", que es otra afirmación (roster de todos los años) y es correcta. Plurales fijos: subtítulo de sección (histórica L2662 y actual L2956), nota nacional (L2680 y L2969) y pie de la matriz "filas" (L2708).
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +8/−5):
  1. Subtítulo de la vista histórica: "GSE de su último año con **GSE publicado**" (decisión §3.1; `rosterHistorico` no se toca).
  2. `nEE(n)` (junto a `listaY`): "1 establecimiento" / "n establecimientos", usado en el subtítulo de sección (histórica **y** actual: mismo rótulo) y en la nota nacional de ambas vistas; pie de la matriz "1 fila" / "n filas".
- **Verificación** (Babel; motor regenerado; Puppeteer, viewport 1200; `t3_rotulos.js`; salida `/tmp/idps_s31b/t3_rotulos_t3.json`; reconteo `Rscript /tmp/idps_s31b/t3_secciones.R` y `t3_198.R` sobre `fase0.json`):
```
bash -c 'grep -c "último año con resultado" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `0` ocurrencias; `JSX OK`; `0`.
obtenido: `0`; `JSX OK — 2228 lineas de fuente -> 194341 bytes transpilados`; `0`.
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31b/run35_t3.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31b/run35_t3.log; md5 -q 40_salidas/motor_idps.html'
```
esperado: `rc=0`; 0 warnings nuevos.
obtenido: `rc=0`; `WARN: 0`; md5 `c4ed5a2af4df08723d0cfffb2be6ff1c` (`/tmp/idps_s31b/motor_t3.html`).
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t3_rotulos.js /tmp/idps_s31b/motor_t3.html > /tmp/idps_s31b/t3_rotulos_t3.json'
```
esperado: el conteo de secciones y de filas por sección no cambia: SLEP foco 4b 10/21/28/1/1 = 61; 2m 3/7/3 = 13; nacional 4b, 6 secciones (2.141/2.573/1.868/789/555/358).
obtenido: 4b histórica `Bajo 10 · Medio bajo 21 · Medio 28 · Medio alto 1 · Sin clasificar 1` (filas de la matriz), banner `61 …`; 2m `3 · 7 · 3`, banner `13 …`; nacional 4b `2.141 · 2.573 · 1.868 · 789 · 555 · 358` (0 tablas, 6 notas). Vista actual 4b intacta: `10 · 21 · 28 · 1` tarjetas (60) y nacional `1.408 · 2.343 · 1.736 · 713 · 517` (6.717).
esperado: subtítulo "GSE de su último año con GSE publicado"; 0 ocurrencias de "último año con resultado" en la página; "1 establecimiento" y "1 fila" en las secciones de un elemento.
obtenido: subtítulos `n establecimientos · GSE de su último año con GSE publicado` (y `· sin GSE publicado en ningún año` en Sin clasificar; `· grupo socioeconómico` en la actual); `viejo: 0` en las cinco pantallas leídas; Medio alto y Sin clasificar: `1 establecimiento · …` y pie `1 fila · orden alfabético …`; vista actual Medio alto `1 establecimiento · grupo socioeconómico`. El contador de "1 establecimientos|filas|comunas" sobre `body.textContent` da 1 en todas las pantallas: es el **comentario de código** de `nEE` dentro del `<script>` (verificado con `t3_plural_ctx.js`: el único elemento hoja que lo contiene es el `SCRIPT`); en ningún elemento visible. `errs: []`.
```
bash -c 'cd /tmp/idps_s31b && Rscript t3_secciones.R fase0.json 4b nacional; Rscript t3_secciones.R fase0.json 4b 503; Rscript t3_secciones.R fase0.json 2m 503; Rscript t3_198.R'
```
esperado (propio, premisa del encargo): en nacional 4b, 198 de 8.284 EE quedan en una sección cuyo GSE viene de un año sin puntaje; en el SLEP foco, 0.
obtenido: R reproduce las secciones (nacional 2141/2573/1868/789/555/358; SLEP 10/21/28/1/1 y 3/7/3). 535 de 7.926 EE con GSE vigente tienen su último año con GSE publicado **sin ningún puntaje** ese año; de ellos, **198** tienen además un GSE distinto en su último año con puntaje (variante (e) de `t3_198.R`: son los que cambiarían de sección bajo la regla vieja del rótulo). SLEP foco: `0 de 60` (4b) y `0 de 13` (2m). La cifra del encargo se reproduce con esa lectura.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE. Motor regenerado, sin commitear todavía.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno (1 intento).
- **Decisiones autónomas:** (1) el plural se corrige también en el subtítulo de la **vista actual** y en las dos notas nacionales, porque es el mismo rótulo (`.gse-sec-sub`) y la misma cadena; reversible. (2) "1 fila" en el pie de la matriz, por el mismo motivo. (3) El subtítulo de "Sin clasificar" ("sin GSE publicado en ningún año") se conserva: ya nombra la regla aplicada.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T4: el estado y la fila llegan al lector de pantalla

- **Estado:** completada.
- **Commits:** `4c7179e` fix(a11y): la matriz historica expone estado y encabezado de fila; `7350cb8` build(motor): regenera con las correcciones de la revision (0.2: el motor regenerado va en un commit propio junto con la última tarea de código; resuelve D-2 de s31).
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +24/−11, patrón que el motor ya usa en `CeldaEE`: glifo `aria-hidden` + texto con la glosa de `EST_EE`):
  1. Celda con estado: `<span className="vt-gl" aria-hidden="true" title=…>▼</span>` seguido de `<span className="vt-sr">, {EST_EE[k].lbl} en {y}</span>` (texto solo para el lector: `.vt-sr` comparte la regla de `.vt-mx caption`). Sin `sigdifgru` no se agrega nada (no se afirma estado).
  2. Celda del nombre: `<th className="vt-c-ee" scope="row">` con `<button type="button" className="vt-ee-btn" title="Ver Panorama IDPS de este establecimiento" onClick=…>` adentro (nombre, RBD y "· hasta AAAA: GSE"). Desaparecen `role="button"`, `tabIndex` y el `onKeyDown` a mano: Enter y Espacio son nativos del botón.
  3. CSS: `.vt-mx tbody th.vt-c-ee` hereda la caja de la celda anterior (padding, `min/max-width`, `font-weight:var(--fw-regular)` para anular la negrita del `th`); `.vt-ee-btn` (bloque, 100 %, `font:inherit`, sin borde ni fondo); hover y `:focus-visible` pasan del `td` al botón; la regla de 640 px pasa a `th`.
- **Verificación** (Babel; motor regenerado; Puppeteer + CDP `DOM.querySelector` → `Accessibility.getPartialAXTree` (`fetchRelatives:true` para las filas); eventos de teclado reales `page.keyboard.press`; `t4_a11y.js`; salidas `/tmp/idps_s31b/t4_a11y_fase0.json` y `t4_a11y_t4.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c "role=\"button\"" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `JSX OK`; `0`; `role="button"` solo en `Card` (1) además del comentario nuevo.
obtenido: `JSX OK — 2235 lineas de fuente -> 194500 bytes transpilados`; `0`; `role="button"` en L942 (`Card`) y en dos comentarios (CSS L718, JSX L2704); ninguno en la matriz.
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31b/run35_t4.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31b/run35_t4.log; md5 -q 40_salidas/motor_idps.html'
```
esperado: `rc=0`; 0 warnings nuevos.
obtenido: `rc=0`; `WARN: 0`; md5 `4acb9e64cec643063dce7e1b4e1ab76b` (5.462.798 bytes; `/tmp/idps_s31b/motor_t4.html`; es el motor commiteado en `7350cb8`).
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t4_a11y.js /tmp/idps_s31b/motor_t4.html > /tmp/idps_s31b/t4_a11y_t4.json'
```
esperado: el nombre accesible de una celda con estado incluye el puntaje, el año y la glosa del estado.
obtenido: primera celda con glifo (SLEP foco, 4b, Bajo): `role: cell`, `name: "77 , Sin diferencia significativa con su GSE en 2024"` (DOM: `77<span class="vt-gl" aria-hidden="true" title="sin diferencia con su GSE de 2024">=</span><span class="vt-sr">, Sin diferencia significativa con su GSE en 2024</span>`; `title` de la celda `2024: 77 · GSE Medio bajo`, intacto). Las **114** celdas con glifo de las cinco tablas: **114** con puntaje + año + glosa en el nombre accesible (ejemplos: `63 , Bajo su GSE (diferencia significativa) en 2025`, `68 , Bajo su GSE (diferencia significativa) en 2024`).
esperado: cada fila expone su encabezado.
obtenido: fila con estado: `role: row`, hijos `rowheader, cell ×10` (11 celdas), primer hijo `rowheader` con nombre `Colegio Artístico Costa Mauco RBD 1853 · hasta 2024: Medio bajo`; `filasConEncabezado: 61 de 61`; DOM de la celda del nombre `TH scope="row"`, sin `role` ni `tabindex`, con `button` adentro; AX `rowheader`.
esperado: Enter y Espacio sobre el nombre abren la ficha.
obtenido: foco en `BUTTON.vt-ee-btn` → `Enter` → pestaña `Panorama IDPS por establecimiento`, ficha `Colegio Artístico Costa Mauco…`; vuelta al panorama, foco, `Space` → ídem. `Tab` desde el último botón de orden del encabezado llega a `BUTTON.vt-ee-btn` del primer nombre de esa tabla.
esperado: calibración: la misma sonda sobre el motor actual devuelve "63▼" sin glosa y sin encabezado de fila.
obtenido (`t4_a11y_fase0.json`): celda `name: "77="` y ejemplos `63▼`, `68▼` (0 de 114 con glosa); fila: primer hijo `button` (no `rowheader`), `0 de 61` filas con encabezado; celda del nombre `TD role="button" tabindex="0"`. El criterio distingue los dos motores.
esperado (propio): aspecto de la primera columna sin cambio.
obtenido: caja `352×53`, padding `5px 10px 5px 12px`, pesos 400 (celda) / 700 (nombre) / 400 (RBD), `text-align:left`, `position:sticky`, fondo blanco, `cursor:pointer`, alturas de fila 53, ancho de tabla 1108: **idénticos** en FASE 0 y T4. `errs: []` en ambos.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE (T4) y `40_salidas/motor_idps.html` (0.2, commit `build(motor)`).
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno en el código (1 intento). Instrumento: (1) `DOM.describeNode` con un `objectId` de otra sesión CDP falló ("Could not find object with given id"); se pasó a `DOM.querySelector` en la misma sesión (1 rehecho). (2) `getPartialAXTree` sin `fetchRelatives` no devuelve los hijos de la fila (contaba "0 de 61" también donde no correspondía); corregido antes de usarlo como criterio (la calibración de FASE 0 se repitió con el instrumento corregido).
- **Decisiones autónomas:** (1) La glosa oculta usa `EST_EE[k].lbl` (la frase completa: "Bajo su GSE (diferencia significativa)", "Sin diferencia significativa con su GSE") y no `.txt`, porque "sin diferencia" a secas no dice con qué; formato `, <glosa> en <año>`. Reversible. (2) `<th scope="row">` + `<button>` (primera opción del encargo) en vez de `role="rowheader"` con `tabIndex`: foco y teclado nativos, sin handler a mano. (3) `.vt-sr` se define junto a `.vt-mx caption` (misma regla) y no como utilidad global: es la única clase de texto oculto del motor y vive con la matriz. (4) El nombre accesible lleva un espacio antes de la coma (`77 , Sin diferencia…`) porque Chrome separa los nodos de texto; no se corrige (cosmético para el lector, invisible en pantalla).
- **Errores propios:** los dos del instrumento, arriba; ninguno en el código.
- **Dudas:** ninguna.

### FASE T5: correcciones de forma del log de s31

- **Estado:** completada (se commitea junto con FASE L, `docs(log)`).
- **Regla:** el log de s31 (`20260917_vista_historica_territorial_s31_log.md`, commiteado en `cbcfdc8`) **no se edita**; cada corrección es una línea nueva aquí que cita la línea anterior, con el `grep -n` que la produce. Los templates citados se extrajeron con `git show <hash>:30_procesamiento/35_motor_template.html` a `/tmp/idps_s31b/template_<hash>.html` (`c93ea6d` = `<PR>` de s31, "template base"; `f2aecd5` = `<PR>`+T1, el que el paso 0 de T3 dice haber leído).

**Corrección 1 — líneas de los dos `esperado (propio…)`.** El log de s31 (L450–L452, "Corrección de forma") dice que están en las líneas 154 y 266.
```
bash -c 'grep -n "^esperado (propio" /Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md'
```
esperado: dos líneas, en 167 y 279 (hallazgo de la revisión).
obtenido: `167:esperado (propio, para el cambio 5): en la sección Medio del SLEP foco, 4b, 2 tarjetas …` y `279:esperado (propio): orden por 2025: \`aria-sort="descending"\` …`. Corrección (cita L450–L452 del log s31): donde dice "las líneas 154 (…, T1) y 266 (…, T3)" léase **167** (T1) y **279** (T3); las citas `(cita L154)` y `(cita L266)` de L451–L452 apuntan a esas mismas líneas 167 y 279. El texto citado es correcto; solo el número de línea estaba errado (el log siguió creciendo después de anotarlas).

**Corrección 2 — línea de `tokenCSS`.** El log de s31 (L226, T3 paso 0) dice "`tokenCSS` ya existía en L2311 (s30, …)".
```
bash -c 'grep -n "const tokenCSS\|const COL_FONDO" /tmp/idps_s31b/template_c93ea6d.html; grep -n "const tokenCSS\|const COL_FONDO" /tmp/idps_s31b/template_f2aecd5.html'
```
esperado: en el template base `tokenCSS` en L2206 y L2311 = `COL_FONDO` (hallazgo de la revisión).
obtenido: `c93ea6d`: `2206:  const tokenCSS=n=>getComputedStyle(document.documentElement).getPropertyValue(n).trim();` y `2311:    const COL_FONDO=tokenCSS("--panel")||"#fffdf7";`; `f2aecd5`: `2248` y `2353`. Corrección (cita L226 del log s31): `tokenCSS` se define en **L2206** del template base (`c93ea6d`); L2311 es la línea de `COL_FONDO`, que lo **usa**. (En `<PR>`+T1, el template que ese paso dice haber leído, es L2248; las cifras de L226 provienen del template base, no de `<PR>`+T1.)

**Corrección 3 — líneas de la barra de exportación del panorama.** El log de s31 (L226) dice "barra de exportación L2547–L2556 dentro de `.gse-filter-wrap`".
```
bash -c 'grep -n "gse-filter-wrap\|className=\"export-bar\"\|descargarPanoramaCSV({" /tmp/idps_s31b/template_c93ea6d.html; sed -n "2547,2556p" /tmp/idps_s31b/template_c93ea6d.html | cut -c1-60'
```
esperado: `.gse-filter-wrap` del panorama en L2579 y su `export-bar` desde L2583 (hallazgo de la revisión: L2579–L2583); L2547–L2556 es otra cosa.
obtenido: `c93ea6d`: `2579:            <div className="gse-filter-wrap">`, `2583:              <div className="export-bar">` (el `<div>` corre hasta L2593; `descargarPanoramaCSV({` en L2589); L2547–L2556 son los dos `EntityModal` y el router de pantalla (`{modalOpen && <EntityModal …`, `{pantalla==="comparar" && <Comparador …`). En `f2aecd5`: L2621 y L2625–L2635. Corrección (cita L226 del log s31): la barra de exportación del panorama está en **L2579–L2583** del template base (apertura de `.gse-filter-wrap` en L2579 y de `.export-bar` en L2583; el bloque completo de la barra llega a L2593), no en L2547–L2556.

**Advertencias que no se corrigen aquí** (con su porqué):

1. **Piso de la rampa de color: 4,58:1, no 4,78:1.** La decisión §3.5 dice "En toda la rampa posible, el mínimo es 4,78:1". Re-derivado en R desde los hex del payload con la regla de `vtTexto` (`Rscript /tmp/idps_s31b/rampa_min.R`):
```
bash -c 'cd /tmp/idps_s31b && Rscript rampa_min.R'
```
esperado: rampa completa (k ∈ [0,1], paso 0,001) de Autoestima con mínimo 4,58; sobre los puntajes enteros del dominio calibrado, 4,78 en 4b|1 (R-16 de s31).
obtenido: `calibracion: #000/#fff = 21.00 ; #777/#fff = 4.48`; `ind 1 #3858A3: minimo de la rampa completa 4.58 en k=0.819 (fondo #5a74b3)`; Convivencia 9,60, Participación 6,85, Hábitos 11,39 (mínimo en k≈1); sobre puntajes enteros 0..100: `4b|1: 4.78 (puntaje 81)`, `2m|1: 4.85 (puntaje 79)`, y los demás cortes 9,60 / 6,85 / 11,39. Es decir: el 4,78 es el mínimo de los **puntajes que hoy se muestran** (enteros dentro del dominio 65–84 de 4b; el tramo k=0,819 cae entre 80 y 81 y ningún puntaje entero lo pisa); el piso real de la rampa continua es 4,58:1 (≥ 4,5:1 igual). No se corrige aquí porque la decisión no está en el ALCANCE de ninguna tarea: queda como **enmienda de la decisión §3.5 en el cierre**.
2. **El modal de territorio no es operable por teclado.** Preexistente (s29; anotado como divergencia 13 con el hermano en el log s29 §36.7 y en `CLAUDE.md`), fuera de alcance de este encargo (§5). Va al **backlog**.
3. **El criterio del traspaso para verificar el despliegue busca "Exportar CSV"**, cadena que también existe en el motor viejo:
```
bash -c 'md5 -q docs/index.html; grep -c "Exportar CSV" docs/index.html; grep -c "sin comparación publicada" docs/index.html; grep -c "Exportar CSV" 40_salidas/motor_idps.html; grep -c "sin comparación publicada" 40_salidas/motor_idps.html'
```
esperado: `docs/index.html` = motor viejo (`2f34dafe…`) con "Exportar CSV" presente y "sin comparación publicada" ausente; el regenerado con ambas.
obtenido: `2f34dafe1309b67e5e1e1cfb3eea47a3`; docs: `Exportar CSV` 2, `sin comparación publicada` 0 (sí tiene 1 "sin comparación vs GSE publicada", la constante del CSV de s30); motor regenerado: 2 y 6. El criterio no distingue el despliegue viejo del nuevo; **se reemplaza por "sin comparación publicada" en el cierre de esta sesión** (el traspaso no está en el ALCANCE de este encargo).
- **Alcance:** solo este log.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** ninguna.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE R: auditoría y reparación

Inventario de afirmaciones auditables, derivado del log (se anexa antes de auditar):

| id | afirmación (sección de origen) |
|---|---|
| R-01 | FASE 0: motor del árbol `575e5047…` (5.460.067 bytes), regenerado idéntico; 0 warnings; `JSX OK`; 🔒7 = 0 |
| R-02 | FASE 0: fidelidad §4 del motor de FASE 0: SHA-256 `1e29c2b5…b5b6`, 59.466.778 bytes sin el bloque |
| R-03 | FASE 0 (calibración T1): `dxSin` −316/0/−316/0 en Medio; tira externa a −316 en Convivencia y Hábitos |
| R-04 | T1: `dxSin` 0/0/0/0 y tiras 0 en el panorama; franja 12 notas + 14 tiras en 0; comparador 4 + 12 en 0; `(left,width)` de todas las barras idénticos a FASE 0 |
| R-05 | T1: `dySin` 3 px (20 con tira); `dyLab` 0 en 12 filas y 9/17 en las 4 de Medio |
| R-06 | T2 (R): 4b GSE vigente Alto 555 EE en 96 comunas; total 8.284/346; actual 2025 6.717/343; 2m Alto 478/84, total 3.178/335 |
| R-07 | T2 (navegador): "96 comunas · 555 …" con solo Alto; "346 · 8.284" con los cinco; actual "343 · 6.717"; sin Sin clasificar 345/7.926; 2m solo Alto 84/478; FASE 0 daba 346/555 |
| R-08 | T3: 0 ocurrencias de "último año con resultado"; secciones 10/21/28/1/1 = 61, 3/7/3 = 13, nacional 2.141/2.573/1.868/789/555/358; "1 establecimiento", "1 fila" |
| R-09 | T3 (R): 535 EE con último año con GSE sin puntaje, 198 de ellos con GSE distinto en su último año con puntaje; 0 en el SLEP foco |
| R-10 | T4: nombre accesible con puntaje+año+glosa en 114/114 celdas con glifo; `rowheader` en 61/61 filas; Enter y Espacio abren la ficha; aspecto de la primera columna idéntico; FASE 0: 0/114 y 0/61 |
| R-11 | T5: `esperado (propio` en L167/L279; `tokenCSS` L2206 y `COL_FONDO` L2311 (`c93ea6d`); `.gse-filter-wrap` L2579 y `.export-bar` L2583; rampa 4,58 vs 4,78; docs 2/0 y motor 2/6 |
| R-12 | Todas las fases: `run_all(only = 35L)` exit 0 y 0 warnings (5 corridas) |
| R-13 | Alcance global: `git diff --name-only cbcfdc8..HEAD` ⊆ {template, motor}; porcelain = log + encargo |
| 🔒1–🔒8 | invariantes §2 de s31 más 🔒8 de s31b |

Re-derivación independiente (comando distinto del que produjo cada cifra; salidas literales):

```
bash -c 'cd /tmp/idps_s31b && Rscript /tmp/idps_s31/extraer_json.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/idps_s31b/final.json && LC_ALL=C sed -E "s/,\"vista_territorial\":\{\"dominio_color\":\{[^}]*\},\"anios_estado\":\{[^}]*\},\"tinte_minimo\":0\.06\}//; s/\"fecha_generacion\":\"[0-9]{4}-[0-9]{2}-[0-9]{2}\"/\"fecha_generacion\":\"0000-00-00\"/" final.json | shasum -a 256; cmp final.json fase0.json && echo iguales'
```
esperado: R-01/R-02 (y 🔒2) con `sed`+`shasum` en vez de R+`digest`: `1e29c2b5…b5b6`, 59.466.778 bytes; sin quitar el bloque, otro hash; el JSON del motor final byte a byte igual al de FASE 0 (esta sesión no toca R ni el payload).
obtenido: `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; `59466778`; control sin quitar el bloque `900913c1…8878b4` (mismo control que en s31); `cmp -l` contra `/tmp/idps_s31/base.json` solo en los offsets 30–39 (`fecha_generacion`); `final.json == fase0.json (byte a byte)`; md5 del motor en el árbol = HEAD = `4acb9e64cec643063dce7e1b4e1ab76b`.
```
bash -c 'cd <scratchpad> && DATAJSON=/tmp/idps_s31b/final.json node r_harness.js'   # JSX real transpilado en vm sobre el payload real, sin navegador
```
esperado: R-04 `StackedBar` devuelve una raíz `div.s100-wrap` con hijos `s100`, `s100-ext` (si hay) y `s100-sin`, también con N = 0; R-06/R-07 `rosterHistorico` nacional 4b: Alto 555/96, total 8.284/346, sin "Sin clasificar" 7.926/345, 2m Alto 478/84 y total 3.178/335; `rosterTerr` 2025: 6.717/343; R-08 foco 4b {10,21,28,1,sin 1} = 61 y 2m {3,7,3} = 13; `nEE(1)` = "1 establecimiento"; R-10 en el motor: `th.vt-c-ee scope="row"` 1, `vt-ee-btn` 1, `vt-gl aria-hidden` 1, `vt-sr` 1, `td.vt-c-ee role="button"` 0; "último año con resultado" 0 y "…con GSE publicado" 1.
obtenido: `R-04 StackedBar(Medio/Autoestima): raiz div s100-wrap | hijos: ["s100","s100-ext","s100-sin"]`; `(N=0,sin=3): raiz div s100-wrap | hijos: ["s100 s100-empty","s100-sin"] | nota: ["+3 sin comparación publicada"]`; `(Bajo, sin=0): ["s100","s100-ext"]` (la tira aparece porque el stub mide el texto a 7 px por carácter y la barra a 430 px; sin efecto sobre la estructura). `R-06/07 nacional 4b: {"1":"2141/280","2":"2573/319","3":"1868/314","4":"789/188","5":"555/96","sin":"358/162","total":"8284/346","sinSinClasificar":"7926/345"}`; `2m: {"alto":"478/84","total":"3178/335"}`; `vista actual nacional 4b 2025 (rosterTerr): 6717/343`; `foco 4b {"c":{"1":10,"2":21,"3":28,"4":1,"sin":1},"total":61}`; `foco 2m {"c":{"1":3,"2":7,"3":3},"total":13}`; `nEE(1)= "1 establecimiento" nEE(28)= "28 establecimientos" nEE(2141)= "2.141 establecimientos"`; `R-10 motor: … scope="row" 1 | vt-ee-btn: 1 | vt-gl aria-hidden: 1 | vt-sr: 1 | role="button" en la matriz: 0`; `"último año con resultado": 0 | "último año con GSE publicado": 1`.
```
bash -c 'cd <scratchpad> && NODE_PATH=… node r_browser.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'   # medidas distintas: hijos directos del grid, .s100-sin sueltos, scrollWidth de segmentos, snapshot de accesibilidad (getFullAXTree), elementHandle.press, secuencia distinta
```
esperado: R-03/R-04 a 1200 y 430 px: 16 filas `.pan-dist-row`, todas con 2 hijos directos, 0 `.s100`/`.s100-ext`/`.s100-sin` sueltos, 16 `.s100-wrap`, las 4 notas dentro de un `.s100-wrap` hijo de la fila; 0 segmentos truncados (38 spans a 1200, 30 a 430, como R-08 de s31); sin desborde a 430 ni 390; R-10 con `page.accessibility.snapshot()` sobre la primera tabla (Bajo, 10 filas): 10 `rowheader`, 10 filas con `rowheader`, 20 celdas con glosa, 0 nombres "NN▼"; Enter y Espacio vía `elementHandle.press` abren la ficha; R-07 en otra secuencia (2m primero): 84/478, 96/555, estado vacío 0/0, 346/8.284; R-08 subtítulos y 0 texto viejo; consola 0 errores/avisos.
obtenido: `r04_1200 {rows 16, hijos [2], sueltos 0, wraps 16, cols [2], notasEnCol2 true, nNotas 4, trunc {0, 38}}`; `r04_430 {rows 16, hijos [2], sueltos 0, wraps 16, cols [1], notasEnCol2 true, nNotas 4, trunc {0, 30}, overflow {sw 430, iw 430}}`; `r04_390 {sw 390, iw 390}`; `r10_snapshot {rows 11, rowheaders 10, filasConRowheader 10, cells 100, celdasConGlosa 20, ejemploCelda "77 , Sin diferencia significativa con su GSE en 2024", ejemploRowheader "Colegio Artístico Costa Mauco RBD 1853 · hasta 2024: Medio bajo", glifosSueltos 0}`; `r10_enter` y `r10_espacio` = `Panorama IDPS por establecimiento`; `r07_2m_soloAlto "84 comunas · 478 …"`, `r07_4b_soloAlto "96 comunas · 555 …"`, `r07_4b_ninguno {meta "0 comunas · 0 establecimientos … 0 de 5 GSE", empty 1, secs 0}`, `r07_4b_todos "346 comunas · 8.284 …"`; `r08 {subs ["GSE de su último año con GSE publicado","sin GSE publicado en ningún año"], viejo 0}`; `errs: []`.
```
bash -c 'cd <scratchpad> && node r_198.js; sed -n "167p;279p" <log s31> | cut -c1-60; sed -n "2206p;2311p;2579p;2583p;2593p" /tmp/idps_s31b/template_c93ea6d.html | cut -c1-70; awk "/className=\"export-bar\"/{print NR}" /tmp/idps_s31b/template_c93ea6d.html; for f in /tmp/idps_s31b/run35_*.log; do echo "$f: $(grep -ci warn "$f") warn, $(grep -c "Paso 35 OK" "$f") ok"; done'
```
esperado: R-09 en node (otro lenguaje): 7.926 con GSE vigente, 535 y 198; R-11 rampa en node: 4,58 en k = 0,819 y 4,78 en el puntaje 81, calibración 21,00 / 4,48; `sed -n` imprime los dos `esperado (propio` en 167/279 (y otra cosa en 154/266), `tokenCSS` en 2206, `COL_FONDO` en 2311, `.gse-filter-wrap` 2579, `.export-bar` 2583 y su cierre 2593; `awk`: las `export-bar` del template base están en 1787 (comparador) y 2583 (panorama); R-12: 0 warn y 1 ok en cada corrida.
obtenido: `R-09 node: EE 4b con GSE vigente 7926 | ultimo anio con GSE sin puntaje 535 | de ellos con GSE distinto en su ultimo anio con puntaje 198`; `R-11 node: rampa completa Autoestima min 4.58 en k= 0.819 | sobre puntajes enteros 4b|1 min 4.78 en 81 | calibracion 21.00 4.48`; `sed -n 167p;279p` → `esperado (propio, para el cambio 5): …` y `esperado (propio): orden por 2025: …`; `154p;266p` → una línea de cierre de bloque de código y un `obtenido: \`2024: 100% = 10 …\``; 2206 `const tokenCSS=…`, 2311 `const COL_FONDO=tokenCSS("--panel")…`, 2579 `<div className="gse-filter-wrap">`, 2583 `<div className="export-bar">`, 2593 `</div>`; `awk`: `1787`, `2583`; `run35_fase0/t1/t2/t3/t4.log: 0 warn, 1 ok` (más `run35_faseR.log`: rc=0, 0 WARN).
```
bash -c 'cd <scratchpad> && NODE_PATH=… node r_cifras.js <motor> > r_cifras_<m>.json'   # sobre motor_fase0.html y el motor final; 🔒8 dinámico
```
esperado (🔒8 dinámico): `title`, segmentos (`title` + texto), tira externa, nota y `aria-label` de **todas** las barras del panorama (foco 4b y 2m, actual e histórica) y del comparador (SLEP Costa Central 4b) idénticos entre el motor de FASE 0 y el final.
obtenido: `actual4b 16 barras | identico: true` (4 notas, 2 tiras); `hist4b 40 | true` (12 notas, 14 tiras); `hist2m 24 | true`; `actual2m 12 | true`; `cmp 20 | true` (4 notas, 12 tiras); md5 de los dos JSON `660ab95eae6e12e6e407a60fe887d6b7` (iguales). 112 barras sin una cifra distinta.

Invariantes 🔒 (`<PR>` = `cbcfdc8`; corridos tras el último commit `7350cb8`):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff cbcfdc8..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+" | grep -iE "prom" | grep -nE "\+=|reduce\(|/[[:space:]]*(n|N|len|total)\b"'
```
esperado: vacío.
obtenido: vacío (`rc=1`). **🔒1 PASA.** Una sola línea agregada contiene `prom` (`{fmt(d.prom)}{s!=null && <>`, T4: lectura, no suma). Control positivo (paso 6): copia `/tmp/idps_s31b/template_plantado.html` con `function mediaProm(items){ … suma+=d.prom; … return suma/n; }` insertada antes de `pasaTerr`; el mismo grep sobre `git diff --no-index template_PR.html template_plantado.html` dispara: `1:+  function mediaProm(items){ let suma=0,n=0; … suma+=d.prom; …` (`rc=0`); sobre el template real con el mismo método: vacío (`rc=1`).
```
bash -c 'cd /tmp/idps_s31b && Rscript /tmp/idps_s31/fidelidad.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'
```
esperado: `1e29c2b5…b5b6`, 59.466.778 bytes.
obtenido: `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `bfcde7ac… -> DISTINTO (ok)`. **🔒2 PASA** (y con `sed`+`shasum`, arriba).
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff cbcfdc8..HEAD -- 30_procesamiento | grep -nE "^[-+].*(--alerta:|--destaca:|--st-neutro:|--ind[1-4]:|INDICADOR_COLORS)"'
```
esperado: vacío.
obtenido: vacío. **🔒3 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff cbcfdc8..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+" | grep -nE "(difgru|prom_gse)[[:space:]]*[<>]"'
```
esperado: vacío.
obtenido: vacío. **🔒4 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only cbcfdc8..HEAD | grep -cE "\.(csv|xlsx|parquet|rds|json)$"'
```
esperado: `0`.
obtenido: `0`. **🔒5 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only cbcfdc8..HEAD -- docs | wc -l'
```
esperado: `0`.
obtenido: `0`. **🔒6 PASA.**
```
bash -c 'grep -c "text-transform" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `0` (línea base de FASE 0).
obtenido: `0`. **🔒7 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff cbcfdc8..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^[-+]" | grep -nE "repartoInd|pctRound|sigdifgru|n_sin_comparacion|filasComparadorCSV"'
```
esperado: vacío.
obtenido: vacío (`rc=1`). **🔒8 PASA.** Control positivo: la misma copia plantada lleva además `function repartoIndFalso(items){ return items.filter(d=>d.sigdifgru===0).length; }`; el grep de 🔒8 sobre `git diff --no-index` dispara (`41:+  function repartoIndFalso…`, `rc=0`); sobre el template real: vacío. Re-derivación dinámica: `r_cifras.js` (112 barras idénticas, arriba).

Alcance global (paso 4):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only cbcfdc8..HEAD; git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps diff --stat cbcfdc8..HEAD | tail -1'
```
esperado: ⊆ {`30_procesamiento/35_motor_template.html`} ∪ {`40_salidas/motor_idps.html` (0.2)}; porcelain: este log y el encargo (gate de FASE 0).
obtenido: exactamente `30_procesamiento/35_motor_template.html` y `40_salidas/motor_idps.html` (R-13 ⊆; `2 files changed, 467 insertions(+), 70 deletions(-)`: template +56/−23, motor +411/−47); porcelain: `?? …encargo_claude_code_idps_correcciones_revision_s31b.md` y `?? …_s31b_log.md` (previstos: van en el commit `docs(log)` de FASE L por decisión del titular en el gate).

Regresión completa (paso 5): `run_all(only = 35L)` sobre el estado final → `rc=0`, `WARN: 0`, grep de warning/error vacío; el motor regenerado es byte a byte el commiteado en `7350cb8` (md5 `4acb9e64cec643063dce7e1b4e1ab76b`; porcelain sin cambios); §4 en R y en `sed`+`shasum`: `1e29c2b5…b5b6`.

Hallazgos y veredicto:

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01/02 | motor y fidelidad de FASE 0 | `sed`+`shasum`, `cmp` | `1e29c2b5…`; JSON = FASE 0 | igual; `final.json == fase0.json` | — | ninguna | — | — |
| R-03/04 | nota y tira bajo la barra | harness vm (estructura) + hijos directos del grid a 1200/430 | raíz `div.s100-wrap`; 2 hijos por fila; 0 sueltos | igual; 16/16 wraps; 0 sueltos; 0 truncados | — | ninguna | — | — |
| R-05 | `dyLab` 9/17 px en filas con nota | (no re-derivada: es una medida de la decisión autónoma T1-1, no un `esperado:` del encargo) | — | — | ADVIERTE | anotar (A-1) para el gate visual | — | — |
| R-06/07 | banner histórico por GSE | `rosterHistorico` del template en vm; navegador en otra secuencia | 555/96, 8.284/346, 6.717/343, 478/84 | iguales; estado vacío 0/0 coherente | — | ninguna | — | — |
| R-08 | rótulo y secciones | vm (`rosterHistorico`, `nEE`); grep en el motor; navegador | 61 = 10/21/28/1/1; 13 = 3/7/3; 0 texto viejo | iguales | — | ninguna | — | — |
| R-09 | 535 / 198 / 0 | `node r_198.js` | 535, 198 | 535, 198 | — | ninguna | — | — |
| R-10 | a11y de la matriz | `page.accessibility.snapshot()` + `elementHandle.press`; grep en el motor | rowheader por fila; glosa en celdas; Enter/Espacio | 10/10; 20/20; ambos abren la ficha; 0 `role="button"` en la matriz | — | ninguna | — | — |
| R-11 | citas de T5 y rampa | `sed -n`, `awk`, node | 167/279; 2206/2311; 2579/2583; 4,58/4,78 | iguales | — | ninguna | — | — |
| R-12 | warnings | `grep -ci warn` × 6 corridas | 0 | 0 | — | ninguna | — | — |
| R-13 | alcance | `diff --name-only`, porcelain | ⊆; log + encargo | ⊆; log + encargo | ADVIERTE | anotar (A-2): previsto por el gate | — | — |
| A-3 | nombre accesible con espacio antes de la coma (`77 , Sin diferencia…`) | snapshot AX | — | cosmético (Chrome separa nodos de texto) | ADVIERTE | anotar; no se repara | — | — |
| 🔒1–🔒8 | invariantes | comandos §2 de s31 + 🔒8 | vacíos / 0 / 0 / 0 / vacío | todos PASA; controles positivos de 🔒1 y 🔒8 disparan | — | — | — | — |

- **Ciclo de reparación:** 0 de 2 usados (ningún REPARA).
- **Veredicto global: APROBADO CON ADVERTENCIAS.** Hallazgos B/R/A = 0/0/3 (A-1 centrado vertical del rótulo en las filas con nota, decisión autónoma T1-1 para el gate visual; A-2 porcelain con el log y el encargo, previsto; A-3 espacio antes de la coma en el nombre accesible, cosmético); reparados 0; abiertos 0. Las tres advertencias de T5 (rampa 4,58, teclado del modal, criterio del traspaso) no son hallazgos de esta sesión: están fuera de alcance por contrato y van a pendientes.
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno en FASE R.

### FASE L: cierre del log

- **Estado:** completada.
- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps fetch --quiet; git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: vacío, o solo el log (más el encargo, por el gate de FASE 0); `main` adelantada respecto de `origin/main`.
obtenido: `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_correcciones_revision_s31b.md` y `?? 50_documentacion/andamios/logs/20260917_correcciones_revision_s31b_log.md`; `## main...origin/main [ahead 11]`: `origin/main` = `bc42fad`, porque **s31 retuvo su push** (árbol con el motor regenerado, D-2). El `git push` de esta FASE L publica los seis commits de s31 (`c93ea6d`..`cbcfdc8`) más los seis de s31b (cinco de código y este log). Corrección del encabezado de este log (decía `cbcfdc8 (= origin/main)`): editado en el encabezado, que es metadato y no evidencia de fase; se declara en errores propios.
- **Corrección de forma (4.3 regla 4, se cita, no se edita):** cuatro líneas `esperado (propio…)` de este log (L119 en T1, L157 en T2, L196 en T3, L236 en T4) se escribieron con un paréntesis tras la palabra y el conteo del paso 5 (`grep -c '^esperado:'`) no las ve; se re-declaran aquí citando su línea:
esperado: (cita L119) la nota queda 3 px bajo la barra (o bajo la tira), `margin-top` de `.s100-sin`.
esperado: (cita L157) sin "Sin clasificar" en nacional 4b histórica: 8.284 − 358 = 7.926 EE y comunas del universo filtrado; 2° medio solo "Alto": 478 EE en 84 comunas.
esperado: (cita L196) en nacional 4b, 198 de 8.284 EE quedan en una sección cuyo GSE viene de un año sin puntaje; en el SLEP foco, 0.
esperado: (cita L236) aspecto de la primera columna sin cambio.
- **Paso 4, grep de privacidad:**
```
bash -c 'grep -nE "[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]" /Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260917_correcciones_revision_s31b_log.md'
```
esperado: vacío.
obtenido: vacío. El log contiene un nombre de establecimiento (el primero de la sección Bajo del SLEP foco, `Colegio Artístico Costa Mauco`, RBD 1853) como salida literal del árbol de accesibilidad en T4 y FASE R: es el nombre público de la Agencia que el propio motor muestra, no una fila de datos personales.
- **Paso 5:** `ls -l`, `wc -l` y conteos: en el reporte final (se miden tras escribir esta sección).

## Cierre

1. **Resumen de la sesión.** Entró el encargo s31b (cinco hallazgos de la revisión independiente de s31). Fases: FASE 0, T1, T2, T3, T4, T5, R, L. Estado final del grafo: T1 completada (`09ea2de`) · T2 completada (`d0614f3`) · T3 completada (`bad2309`) · T4 completada (`4c7179e`, más `7350cb8` build del motor) · T5 completada (en este log) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Gate del titular al inicio (encargo sin versionar en el porcelain).
2. **Inventario de commits** (`git log cbcfdc8..HEAD --oneline`, HEAD antes del commit de este log):
   - `09ea2de` fix(panorama): la nota de sin comparacion publicada va bajo su barra — T1
   - `d0614f3` fix(panorama): el banner historico cuenta comunas del universo filtrado — T2
   - `bad2309` fix(vista-historica): el rotulo de seccion nombra la regla aplicada — T3
   - `4c7179e` fix(a11y): la matriz historica expone estado y encabezado de fila — T4
   - `7350cb8` build(motor): regenera con las correcciones de la revision — 0.2 (motor `4acb9e64…`, 5.462.798 bytes; resuelve D-2 de s31)
   - (este log + el encargo: `docs(log): correcciones de la revision s31b`, hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; hallazgos B/R/A = 0/0/3; reparados 0; abiertos 0 (A-1 → P-4; A-2 previsto; A-3 cosmético).
4. **Invariantes:** 🔒1 PASA (grep vacío; control positivo plantado dispara) · 🔒2 PASA (SHA-256 `1e29c2b5…b5b6`, 59.466.778 bytes sin el bloque, en R y en `sed`+`shasum`; el JSON del motor final es byte a byte el de FASE 0) · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA (0) · 🔒6 PASA (0) · 🔒7 PASA (0 = línea base) · 🔒8 PASA (grep vacío; control positivo dispara; 112 barras con cifras idénticas entre FASE 0 y el final). 8/8.
5. **Decisiones del usuario registradas en gates:** (1) 2026-09-17, FASE 0: ante `?? …encargo_…_s31b.md` (el encargo mismo, sin versionar; regla 0.1-1), el titular eligió "Continuar; el encargo va con `docs(log)`" (patrón s29i/s30). Ninguna otra.
6. **Estado de cifras/datos críticos:** payload intacto (SHA-256 §8.2 idéntico; `final.json == fase0.json`); ninguna cifra de barra, porcentaje ni CSV cambió (🔒8 estático y dinámico); `idps_largo.parquet` y `20_insumos/` no tocados (🔒5); `docs/` intacto (🔒6; sigue en `2f34dafe…`). Motor versionado en HEAD: `4acb9e64cec643063dce7e1b4e1ab76b` (5.462.798 bytes).
7. **Dudas y pendientes consolidados:**
   - P-1 (T5, advertencia 1): enmienda de la decisión §3.5: el piso de la rampa continua es 4,58:1 (Autoestima, k = 0,819); 4,78:1 es el mínimo sobre los puntajes enteros que hoy se muestran. Ambos ≥ 4,5. Va al cierre.
   - P-2 (T5, advertencia 2): el modal de territorio no es operable por teclado (preexistente; divergencia 13 del log s29 §36.7). Backlog.
   - P-3 (T5, advertencia 3): el criterio del traspaso para verificar el despliegue ("Exportar CSV") no distingue el motor viejo del nuevo; reemplazar por "sin comparación publicada" en el cierre.
   - P-4 (A-1, T1 decisión 1): en las filas del panorama con nota (y tira), el rótulo del indicador se centra sobre el bloque barra+nota (9–17 px bajo el centro de la barra), como hace el `<td>` del comparador. Si el titular prefiere el rótulo centrado en la barra, la alternativa es `grid-template-rows:subgrid` en `.s100-wrap` dentro de `.pan-dist-row` (una regla). Gate visual.
   - De s31 siguen abiertas D-1 (`n_con_dato` → `n_con_comparacion`, sí/no) y D-3 (chip "· sin comparación publicada", sí/no); D-2 queda **resuelta** por 0.2 de este encargo (motor commiteado en `7350cb8`).
   - Despliegue a `docs/` pendiente del visto bueno visual del titular sobre `40_salidas/motor_idps.html` (§5).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** FASE 0–T3: ninguno (T2: el diffstat del log decía +9/−2 y era +10/−3; corregido en el acto). T4 (2, instrumento): `objectId` de otra sesión CDP (1 rehecho); `getPartialAXTree` sin `fetchRelatives` (corregido antes de usarlo como criterio). FASE R: ninguno. FASE L (2): cuatro `esperado (propio…)` que el conteo no ve (mismo desliz que s31; corregidos por cita); el encabezado decía `cbcfdc8 (= origin/main)` cuando `origin/main` era `bc42fad` (editado en el encabezado y declarado aquí). Ninguno costó más de un turno.
9. **Notas para el revisor:** (a) mirar en el panorama, SLEP foco 4b, sección Medio, la nota "+N sin comparación publicada" bajo su barra y la posición del rótulo del indicador (P-4); (b) en la vista histórica, el subtítulo "GSE de su último año con GSE publicado" y "1 establecimiento" en Medio alto y Sin clasificar; (c) la matriz: el nombre del establecimiento es ahora un botón dentro de un `th` (aspecto medido idéntico: misma caja, pesos y cursor; el foco visible pasa al botón); el texto oculto de la glosa (`.vt-sr`) viaja también en el `textContent` de la celda (copiar y pegar la tabla lo incluye; cosmético); (d) el banner histórico nacional con un solo GSE encendido cuenta las comunas de ese universo (96 con Alto); con ningún GSE, "0 comunas · 0 establecimientos"; (e) el push de esta sesión publica también los seis commits de s31 que quedaron retenidos.
10. **Estado de cierre:** commiteados `09ea2de`, `d0614f3`, `bad2309`, `4c7179e`, `7350cb8` y el log (commit propio, con el encargo). **Se publica:** `git push origin main` (FASE R en APROBADO CON ADVERTENCIAS y porcelain vacío tras el commit del log); `docs/` **no** se tocó. Queda al titular: revisar `40_salidas/motor_idps.html` (md5 `4acb9e64cec643063dce7e1b4e1ab76b`) y decidir el despliegue; P-1, P-3 y P-4 en el cierre; D-1 y D-3 de s31.
