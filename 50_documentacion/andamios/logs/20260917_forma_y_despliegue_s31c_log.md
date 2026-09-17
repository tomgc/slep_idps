# Log de sesión: dos correcciones de forma y despliegue (s31c)

- **Meta:** corregir los dos defectos de forma que sobrevivieron a la verificación del motor de s31b (plural del banner; rótulo del indicador anclado a su barra), regenerar el motor sin que cambie una cifra, desplegarlo a `docs/index.html` byte a byte y hacer push.
- **Fecha:** 2026-09-17
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main`
- **HEAD al empezar:** `48d35da` (= `origin/main`, medido con `git fetch`). PUNTO DE RETORNO `<PR>` = `ab6a3c5` (commit de T0, el encargo).
- **ENTORNO:** Claude Code en la estación macOS del titular; R 4.5.2 con `renv` del proyecto; `bash -c` explícito en todo comando de shell; `Rscript` en todo cálculo sobre datos.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus 0. **Modo real de la sesión:** Opus 5 (1M), efecto de sesión `ultracode` activado por el titular pero el encargo prohíbe subagentes y workflows: se ejecuta en solo, en serie (el encargo manda).
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_forma_y_despliegue_s31c.md` (patrón v1.6). Se heredan §2 (invariantes), §4 (fidelidad), §5 (FASE R) y §6 (FASE L) del encargo s31.
- **Grafo de tareas (copiado del encargo):**

```
T0 (commit del encargo)     independiente, corre en FASE 0
T1 (plural del banner)      independiente
T2 (anclaje del rótulo)     independiente
T3 (build y auditoría)      requiere T1 y T2
T4 (despliegue a docs/)     requiere T3
FASE R y FASE L             corren siempre, al final, fuera del grafo
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando.

## J. Juicio
- Meta y resultado: dos correcciones de forma (plural del banner; rótulo anclado a su barra), motor regenerado sin cambiar una cifra, desplegado a `docs/index.html` byte a byte y pusheado → cumplida, en una línea.
- Estado por tarea: T0 completada (`ab6a3c5`) · T1 completada (`2eb0908`) · T2 completada (`58a37aa`) · T3 completada (`b3a91e7`) · T4 completada (`d03aa5b`) · T5 completada (en este log) · FASE R completada (sin reparaciones).
- Commits: 6, rango `ab6a3c5`..`<docs(log)>` (`git log --oneline`), de los cuales 0 fix(auditoria), 1 build(motor) y 1 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/2; reparados 0; abiertos 0 (A-1 🔒6 redactado como "docs/ intacto" en un encargo que despliega: se lee "docs/ solo cambia por T4"; A-2 "1 comunas" en el modal del comparador, fuera del alcance de T1, registrada como duda D-1).
- Invariantes: 8/8 PASA (🔒6 con la lectura de 0.2: el único cambio en `docs/` es `index.html`, byte a byte igual al motor; 🔒8 estático y dinámico: 92 barras del panorama y 20 del comparador con `diff` vacío); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: SHA-256 §8.2 `1e29c2b5…b5b6` en R y en `sed`+`shasum`; `final.json == fase0.json` byte a byte; `diff` vacío del volcado de 92 barras; 16/16 barras del panorama actual coinciden con `repartoInd` corrido en vm; 🔒5 = 0).
- Decisiones autónomas de mayor riesgo: (1) T2 se resuelve con `grid-template-rows:subgrid` en `.s100-wrap` (tres pistas: barra | tira | nota) y no con las dos mecánicas sugeridas por el encargo, porque ninguna de ellas da 0 px con rótulos de dos renglones (48 px), que son la mitad; bajo 760 px el contenedor vuelve a bloque (layout de una columna idéntico, medido); reversible. (2) El `row-gap` de `.pan-dist-row` pasa a 0 en escritorio (`gap:0 16px`); antes solo separaba la fila fantasma del defecto de s31b; reversible.
- Desviaciones respecto del encargo: ninguna en el grafo ni en las autorizaciones. El md5 del volcado de barras del encargo (`21f1019a…`, 92 barras) no es comparable con el de este instrumento (otro formato de volcado): el criterio aplicado es el del encargo, `diff` vacío antes/después.
- Dudas abiertas: 1 (D-1: "SLEP Santiago Centro 1 comunas · 39 establecimientos" en el tab SLEP del modal del comparador, cadena a mano de s29 fuera del banner y de las notas nacionales; y el `title` de exportación "Descarga en CSV los 1 establecimientos…"; ¿se corrigen en el próximo encargo de forma? sí/no); pendientes P-1 (enmienda §3.5), P-2 (criterio del traspaso), P-3 (teclado del modal), copiados de T5.
- Errores propios: 4 registrados, todos de instrumento (`run_all` lanzado con `cd` al scratchpad; `document` fuera de `evaluate`; `clickText` exacto sobre "volver a…"; `offsetTop` en marcos distintos); ninguno costó más de un turno.
- Qué debe verificar el revisor por sí mismo: el motor publicado en GitHub Pages (`docs/index.html`, md5 `6c5feab5428ed05dff09867f2b47bba3`) una vez propagado; el aspecto del rótulo anclado a la barra en la sección Medio del SLEP foco (las filas con nota crecen 17 px cuando el rótulo tiene dos renglones); esta sesión midió posiciones y cifras, no gusto.
- No publicado / queda al usuario: nada retenido; D-1 y los pendientes P-1..P-3 al cierre.
- Ejecución: modo de sesión ultracode (efecto) ejecutado como xhigh en solo por contrato; subagentes 0, por contrato.

## Registro por fase

### FASE 0: punto de retorno, T0 y mediciones

- **Estado:** completada.
- **Commits:** `ab6a3c5` docs(s31c): encargo de forma y despliegue (T0, dentro de esta fase).
- **PUNTO DE RETORNO `<PR>`:** `ab6a3c5`.
- **Cambios sustantivos:** ninguno en código. Se creó `/tmp/idps_s31c/` (`motor_fase0.html`, `fase0.json`, `run35_fase0.log`, `verif_fase0.json`) y, en el scratchpad de la sesión, `s31c_verif.js` (nuevo); se reutilizan `check_jsx.js` + `babel.min.js` 7.29.0, `harness.js` y `r_cifras.js` (s31b) y `fidelidad.R` / `extraer_json.R` (`/tmp/idps_s31/`).
- **Verificación:**

Paso 2 (solo lectura, antes de escribir nada):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps fetch --quiet; git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps stash list; echo "HEAD=$(git -C /Users/tomgc/Projects/slep_idps rev-parse --short HEAD) origin/main=$(git -C /Users/tomgc/Projects/slep_idps rev-parse --short origin/main)"'
```
esperado: solo `?? …encargo_claude_code_idps_forma_y_despliegue_s31c.md`; stash vacío; `HEAD` = `origin/main` = `48d35da`.
obtenido: `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_forma_y_despliegue_s31c.md` (única ruta); stash vacío; `HEAD=48d35da origin/main=48d35da`. Reglas 0.1-1 y 0.1-2 no disparan. Motor del árbol `4acb9e64cec643063dce7e1b4e1ab76b` (= HEAD); `docs/index.html` `2f34dafe1309b67e5e1e1cfb3eea47a3`.

T0:
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps add 50_documentacion/activa/encargos/encargo_claude_code_idps_forma_y_despliegue_s31c.md && git -C /Users/tomgc/Projects/slep_idps commit -m "docs(s31c): encargo de forma y despliegue" && git -C /Users/tomgc/Projects/slep_idps rev-parse --short HEAD && git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: commit creado; porcelain vacío; hash = `<PR>`.
obtenido: `ab6a3c5`; porcelain vacío.

Línea base de PRUEBAS, fidelidad §4 y sintaxis:
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31c/run35_fase0.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31c/run35_fase0.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; cd /tmp/idps_s31c && Rscript /tmp/idps_s31/fidelidad.R /tmp/idps_s31c/motor_fase0.html; Rscript /tmp/idps_s31/extraer_json.R /tmp/idps_s31c/motor_fase0.html /tmp/idps_s31c/fase0.json; cmp /tmp/idps_s31c/fase0.json /tmp/idps_s31b/final.json; node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: exit 0; 0 warnings (línea base de s31/s31b); md5 del regenerado igual al del árbol; SHA-256 `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6` sin el bloque, 59.466.778 bytes; JSON igual al final de s31b; `JSX OK`; 🔒7 = 0.
obtenido: `rc=0`; grep de warning/error vacío; `WARN: 0`; md5 `4acb9e64cec643063dce7e1b4e1ab76b` (idéntico); `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `bfcde7ac… -> DISTINTO (ok)`; `fase0.json == final.json de s31b` (byte a byte); `JSX OK — 2235 lineas de fuente -> 194500 bytes transpilados`; `0`. **Líneas base: 0 warnings, 🔒7 = 0. Regla 0.1-3 no dispara.**

Calibración de T1 y T2 (caso malo conocido; Puppeteer 25.9.0 + Chrome del sistema, `file://`, viewport 1200 y 390; `s31c_verif.js`; salida `/tmp/idps_s31c/verif_fase0.json`):
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node s31c_verif.js /tmp/idps_s31c/motor_fase0.html > /tmp/idps_s31c/verif_fase0.json'
```
esperado: T1: SLEP foco, 4b, solo "Medio alto": "1 establecimientos" en las dos vistas; T2: sección Medio, `dyLab` (centro del rótulo − centro de la barra) = +9, +17, +9, +17 px.
obtenido: T1: actual `1 establecimientos en el nivel seleccionado · 4° básico · 2 de 5 GSE · 2025 (preliminar)` (subtítulo de la sección, treinta píxeles más abajo: `1 establecimiento · grupo socioeconómico`); histórica con solo Medio alto `1 establecimientos con resultado en algún año · …`; comuna de Ollagüe (1 EE): `1 comuna · 1 establecimientos …` en 4b y 2m, actual e histórica (4 ocurrencias más). T2: Medio `dyLab` = `9, 17, 9, 17` (rótulos de 48/24/48/24 px; contenedor de 43/61/43/61 px); Bajo, Medio bajo y Medio alto `0,0,0,0`. Los criterios distinguen el caso malo.

- **Alcance:** T0 ⊆ su ALCANCE (el encargo). Este log se crea en FASE L con toda la evidencia (aparece en porcelain solo entonces).
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings (línea base).
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** el instrumento de hash corre con `cd /tmp/idps_s31c && Rscript` (fuera de `renv`, donde `digest` no está), como en s31/s31b; reversible.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T1: el banner concuerda el plural

- **Estado:** completada.
- **Commits:** `2eb0908` fix(panorama): el banner concuerda el plural de establecimiento.
- **Paso 0, revisión de cadenas de conteo a mano** (`grep -n 'establecimientos'` sobre el template, excluidos comentarios): en el banner `.pan-meta`, las dos ramas del ternario (L2910 histórica, L2911 actual) con `{fmt(n)} establecimientos` a mano; las notas de nivel nacional (L2689 histórica, L2985 actual) ya usan `nEE` desde s31b; "comuna"/"comunas" ya concuerda (L2909). Fuera del banner y de las notas quedan dos cadenas a mano que **no** se tocan (alcance de T1): el `title` del botón de exportación del panorama (L2944, "Descarga en CSV los N establecimientos de esta vista…", daría "los 1 establecimientos") y el `sub` de la lista de SLEP del modal del **comparador** (L1759, `s.ncom+" comunas · "+s.ee+" establecimientos"`, s29). Van a la duda D-1.
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +4/−3): las dos ramas del banner pasan a `{nEE(nHist)} con resultado en algún año …` y `{nEE(unidades.length)} en el nivel seleccionado …`; comentario `s31c` junto al de s31.
- **Verificación** (Babel; motor regenerado; Puppeteer, viewport 1200; `s31c_verif.js`; salida `/tmp/idps_s31c/verif_t1.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31c/run35_t1.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31c/run35_t1.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'
```
esperado: `JSX OK`; `0`; `rc=0`; 0 warnings nuevos.
obtenido: `JSX OK — 2236 lineas de fuente -> 194466 bytes transpilados`; `0`; primer intento `rc=1` (`Error: No root directory found in <scratchpad>…`: `here::here()` de `00_build.R` buscó la raíz desde el directorio de trabajo del shell, que había quedado en el scratchpad; el motor no cambió y la verificación corrió sobre el motor viejo, con el caso malo intacto; reintento desde la raíz del repo, 1 permitido por comando); segundo intento `rc=0`; `WARN: 0`; md5 `76f0de6301f7d6b0fb92fd026f04dd40` (`/tmp/idps_s31c/motor_t1.html`).
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node s31c_verif.js /tmp/idps_s31c/motor_t1.html > /tmp/idps_s31c/verif_t1.json'
```
esperado: SLEP foco, 4° básico, solo "Medio alto": "1 establecimiento" en las dos vistas, y "2 establecimientos" al encender también "Sin clasificar" en la histórica.
obtenido: actual `1 establecimiento en el nivel seleccionado · 4° básico · 2 de 5 GSE · 2025 (preliminar)`; histórica con solo Medio alto (apagando "Sin clasificar", que arranca encendido en `gseVis`) `1 establecimiento con resultado en algún año · 4° básico · 2 de 5 GSE · 2014–2025*`; al encender "Sin clasificar" `2 establecimientos con resultado en algún año · 4° básico · 2 de 5 GSE · 2014–2025*`. Subtítulos de sección `1 establecimiento · grupo socioeconómico` y `1 establecimiento · GSE de su último año con GSE publicado`. Calibración: FASE 0 daba "1 establecimientos" en las dos vistas.
esperado: 0 ocurrencias de "1 establecimientos" y de "1 comunas" en cualquier pantalla, territorio y nivel probados (incluye nacional, una región y una comuna).
obtenido: sobre `document.body.innerText` (texto renderizado, sin scripts) en 16 lecturas: SLEP foco, nacional (Chile), Región de Tarapacá y comuna de Ollagüe (1 EE) × 4° básico / 2° medio × actual / histórica → `1 establecimientos` 0, `1 comunas` 0, `1 filas` 0 en las 16 (`sweepMal: …0/0/0`); banners de la comuna `1 comuna · 1 establecimiento en el nivel seleccionado …` y `1 comuna · 1 establecimiento con resultado en algún año …` (FASE 0: 4 ocurrencias de "1 establecimientos" ahí); comparador con SLEP Costa Central: 0/0/0. Banners de referencia: nacional `346 comunas · 8.284 …` / `343 comunas · 6.717 …`; región `7 comunas · 122 …` (hist) / `103` (actual). `errs: []`.
esperado: (propio) el tab SLEP del modal del **comparador** (fuera de T1) sigue mostrando la cadena a mano de L1759 para el único SLEP de una comuna.
obtenido: `SLEP Santiago Centro 1 comunas · 39 establecimientos` (`cod_slep` 1301; una fila de 36). No se corrige (alcance de T1: banner y notas nacionales); duda D-1.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE. Motor regenerado, sin commitear hasta T3.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno en el código (1 intento).
- **Decisiones autónomas:** ninguna (el ayudante `nEE` ya existía; se usa tal cual).
- **Errores propios:** (1) `run_all` lanzado desde un shell con `cd` al scratchpad: `here::here()` no encontró la raíz; el encargo exige rutas absolutas **y** sin `cd` previo, y el `cd` del instrumento anterior seguía vigente en el mismo comando. Costo: 1 reintento (autorizado).
- **Dudas:**
  1. D-1: dos cadenas de conteo a mano fuera del banner y de las notas nacionales: `sub` de los SLEP en el modal del comparador (L1759: "SLEP Santiago Centro 1 comunas · 39 establecimientos", visible) y `title` del botón de exportación del panorama (L2944: "Descarga en CSV los 1 establecimientos de esta vista…", solo en el tooltip). Pregunta cerrada: ¿se corrigen en el próximo encargo de forma (sí/no)? Bloquea: nada.

### FASE T2: el rótulo del indicador se ancla a su barra

- **Estado:** completada.
- **Commits:** `58a37aa` fix(panorama): el rotulo del indicador se ancla a su barra.
- **Por qué no las dos mecánicas sugeridas:** los rótulos miden 24 px (un renglón: Convivencia, Hábitos) o **48 px** (dos renglones: Autoestima, Participación; medido en FASE 0, `labH`). (a) "rótulo al inicio de la fila con `min-height` de la barra" deja el contenedor centrado en la fila: con rótulo de 48 px y contenedor de 43 px, el centro de la barra cae 8,5 px arriba del centro del rótulo (Autoestima seguiría en +9). (b) "`align-items:start` y compensar en el rótulo": con `min-height:26px` el rótulo de un renglón se centra en la barra, pero el de dos renglones (48 px) queda 11 px abajo **en todas sus filas**, también en las que hoy están en 0 (caso bueno conocido). Ninguna cumple "0 px en los cuatro" ni "las filas sin nota siguen en 0". La mecánica que sí lo cumple: la fila define tres pistas (barra | tira externa | nota) y el contenedor `.s100-wrap` las hereda como **subgrid**; rótulo y barra comparten la pista 1 y ambos se centran en ella, cualquiera sea la altura del rótulo; la tira y la nota cuelgan en las pistas 2 y 3 sin mover ese centro.
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +14/−2, solo CSS):
  1. `.pan-dist-row{…;grid-template-rows:auto auto auto;align-items:center;gap:0 16px;}` (columnas `300px 1fr` intactas; `row-gap` 0 porque la tira y la nota traen su `margin-top:3px`).
  2. `.pan-dist-row > .s100-wrap{grid-column:2;grid-row:1/4;display:grid;grid-template-rows:subgrid;align-items:center;}` (columna explícita: un ítem con fila definida y columna automática se coloca antes que los automáticos y habría caído en la columna 1).
  3. `@media(max-width:760px)`: `.pan-dist-row{grid-template-columns:1fr;grid-template-rows:auto;gap:5px;}` y `.pan-dist-row > .s100-wrap{grid-column:1;grid-row:auto;display:block;}` (una columna: el contenedor vuelve a ser el bloque de s31b, apilado bajo el rótulo).
  4. Comentario CSS con la razón y las alternativas descartadas.
- **Verificación** (Babel; motor regenerado; `s31c_verif.js`; salida `/tmp/idps_s31c/verif_t2.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31c/run35_t2.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31c/run35_t2.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'
```
esperado: `JSX OK`; `0`; `rc=0`; 0 warnings nuevos.
obtenido: `JSX OK — 2236 lineas de fuente -> 194466 bytes transpilados` (el JSX no cambia); `0`; `rc=0`; `WARN: 0`; md5 `6c5feab5428ed05dff09867f2b47bba3` (`/tmp/idps_s31c/motor_t2.html`).
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node s31c_verif.js /tmp/idps_s31c/motor_t2.html > /tmp/idps_s31c/verif_t2.json'
```
esperado: sección Medio del SLEP foco, 4° básico: desviación vertical del rótulo respecto de su barra = 0 px en los cuatro indicadores, con nota y con tira.
obtenido: `dyLab` = `0, 0, 0, 0` (Autoestima: rótulo 48 px, fila 65 px, nota 14 px bajo la barra = 11 de centrado + 3 de margen; Convivencia: rótulo 24 px, fila 61 px, tira 3 px y nota 20 px bajo la barra; Participación como Autoestima; Hábitos como Convivencia). Pistas computadas de la fila: `48px 17.39px 0px` (nota sola) y `26px 17.39px 17.39px` (tira + nota); `gap: 0px 16px`; contenedor `display:grid`. Calibración: FASE 0 daba `9, 17, 9, 17`.
esperado: en las filas sin nota la desviación sigue en 0 px (caso bueno conocido), y el comparador y la franja de la vista histórica no se mueven.
obtenido: Bajo, Medio bajo y Medio alto `0,0,0,0`; geometría de esas 12 filas (`labH, labW, labLeft, barLeft, barW, barH, rowH`) **idéntica** a FASE 0 (`true`). Franja histórica del SLEP foco 4b: posiciones `(left, top, width)` de las 40 barras de las cinco secciones idénticas entre `motor_t1` y `motor_t2` (`true`; contra FASE 0 la comparación de la primera sección también es `true`; la de las cinco no es comparable porque en FASE 0 el instrumento dejó "Sin clasificar" apagado y midió 4 secciones/32 barras). Comparador (SLEP Costa Central 4b): 4 barras en `(222|457|692|927, 74, 211)` en FASE 0, T1 y T2 (`true`).
esperado: a 390 px de ancho, el layout de una columna no cambia respecto del motor actual.
obtenido: `pan390` (las 16 filas de las cuatro secciones, todos los campos: alturas y anchos de rótulo y barra, `dyLab` −42/−30, `dxSin` 0, `dySin` 20, `rowH` 114/90, `cols "300px"`, `gap 5px`, `wrapDisp block`) **idéntico** a FASE 0 (`true`); `scrollWidth 390 = innerWidth 390`. T1 sigue: `1 establecimiento …` en las dos vistas; barrido `0/0/0` en las 16 lecturas. `errs: []`.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE; la primera columna sigue en 300 px.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno (1 intento).
- **Decisiones autónomas:** (1) `subgrid` en vez de las dos mecánicas sugeridas (arriba); soporte: Chrome 117+, Firefox 71+, Safari 16+; si un navegador no lo soporta, la declaración se ignora y el contenedor queda como un grid de tres filas propias que abarca las tres pistas: degrada al centrado sobre el bloque de s31b, no rompe. Reversible (dos reglas y una línea de la media query). (2) `row-gap` 0 en escritorio: no separaba nada útil (solo la fila fantasma del defecto corregido en s31b). Reversible.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T3: regenerar y auditar

- **Estado:** completada.
- **Commits:** `b3a91e7` build(motor): regenera con las correcciones de forma.
- **Verificación:**
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31c/run35_t3.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31c/run35_t3.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; cmp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/idps_s31c/motor_t2.html; cd /tmp/idps_s31c && Rscript /tmp/idps_s31/fidelidad.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; Rscript /tmp/idps_s31/extraer_json.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/idps_s31c/final.json; cmp /tmp/idps_s31c/final.json /tmp/idps_s31c/fase0.json'
```
esperado: `rc=0`; 0 warnings nuevos; SHA-256 `1e29c2b5…b5b6` sin el bloque, 59.466.778 bytes; el JSON igual al de FASE 0.
obtenido: `rc=0`; `WARN: 0`; md5 `6c5feab5428ed05dff09867f2b47bba3` (5.463.985 bytes), byte a byte igual al motor verificado en T2; `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `DISTINTO (ok)`; `final.json == fase0.json`. **Regla 0.1-3 no dispara.**
```
bash -c 'cd <scratchpad> && for m in fase0 final; do NODE_PATH=… node r_cifras.js <motor_$m> > /tmp/idps_s31c/cifras_$m.json; done; diff /tmp/idps_s31c/cifras_pan_fase0.json /tmp/idps_s31c/cifras_pan_final.json; diff /tmp/idps_s31c/cifras_fase0.json /tmp/idps_s31c/cifras_final.json'
```
esperado: 🔒8 dinámico: `diff` vacío entre el volcado de barras de antes y el de después (SLEP foco, 4b y 2m, actual e histórica: 92 barras con `title`, `aria-label`, texto y `title` de cada segmento, tira externa y nota).
obtenido: `actual4b 16 · hist4b 40 · hist2m 24 · actual2m 12` = **92 barras**, `identico: true` en los cuatro cortes; `diff` vacío (md5 de los dos volcados `841565df4d431a25aa061c79ed3e4c08`); con el comparador (20 barras más, 112) también vacío (md5 `660ab95eae6e12e6e407a60fe887d6b7`, el mismo volcado que en s31b: ninguna cifra cambió desde entonces). El md5 `21f1019a…` del encargo corresponde al volcado del revisor (otro formato) y no es comparable; el criterio aplicado es el `diff` vacío.
- **Alcance:** `40_salidas/motor_idps.html` ⊆ ALCANCE.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** ninguna.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T4: desplegar a `docs/`

- **Estado:** completada.
- **Commits:** `d03aa5b` deploy(docs): publica la vista historica territorial.
- **Verificación** (T1 y T2 completadas y verificadas; 0.2):
```
bash -c 'cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html && md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html && cmp -s /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html && echo identicos; grep -c "sin comparación publicada" /Users/tomgc/Projects/slep_idps/docs/index.html; grep -c vt-mx /Users/tomgc/Projects/slep_idps/docs/index.html; git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: md5 iguales y `cmp -s` sin diferencia; `sin comparación publicada` ≥ 1 y `vt-mx` ≥ 1; md5 distinto de `2f34dafe1309b67e5e1e1cfb3eea47a3`; porcelain solo ` M docs/index.html`.
obtenido: `6c5feab5428ed05dff09867f2b47bba3` en los dos; `cmp -s: identicos` (5.463.985 bytes); `sin comparación publicada` **6**; `vt-mx` **14** (líneas); `Exportar CSV` 2 (el testigo viejo, presente en ambos motores); md5 ≠ `2f34dafe…` (el publicado hasta hoy, 5.431.955 bytes); porcelain ` M docs/index.html`. **Regla 0.1-7 no dispara.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps add docs/index.html && git -C /Users/tomgc/Projects/slep_idps commit -m "deploy(docs): publica la vista historica territorial" && git -C /Users/tomgc/Projects/slep_idps status --porcelain; ls /Users/tomgc/Projects/slep_idps/docs'
```
esperado: commit creado; porcelain vacío; `docs/` solo contiene `index.html`.
obtenido: `d03aa5b` (`1 file changed, 426 insertions(+), 49 deletions(-)`); porcelain vacío; `docs/`: `index.html`.
- **Alcance:** `docs/index.html` ⊆ ALCANCE.
- **Regresión:** no aplica (copia byte a byte).
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** ninguna.
- **Errores propios:** ninguno.
- **Dudas:** ninguna.

### FASE T5: pendientes anotados (sin corregir)

- **Estado:** completada (va con FASE L).
- Los tres pendientes que esta línea deja abiertos, con la medición que los sostiene (todas de s31b, reproducidas ahí con R y node):
  1. **Enmienda de la decisión §3.5.** El piso de la rampa continua de color es **4,58:1** (Autoestima `#3858A3`, k = 0,819, fondo `#5a74b3`, con la regla de `vtTexto`: mejor de `#000000`, `--gris` `#5C666E` y `#ffffff`), no 4,78:1; el 4,78 es el mínimo entre los **puntajes enteros** que hoy se muestran (4b, puntaje 81; 2m: 4,85 en el 79). Convivencia 9,60, Participación 6,85, Hábitos 11,39. Ninguna celda publicada baja de 4,5:1. Medición: `Rscript /tmp/idps_s31b/rampa_min.R` y `node r_198.js` (log s31b, T5 y FASE R R-11). Va al cierre como enmienda de la decisión.
  2. **Criterio de verificación del despliegue.** El traspaso vigente busca "Exportar CSV" en `docs/index.html`; esa cadena existe también en el motor viejo (`2f34dafe…`: 2 ocurrencias) y no distingue un despliegue del otro. Desde hoy el testigo es **"sin comparación publicada"** (motor viejo 0, motor nuevo 6; T4) y, como segundo testigo, `vt-mx` (0 → 14). Va al cierre para el traspaso.
  3. **Teclado en el modal de territorio.** Las filas del selector (`.check-row`) no son operables por teclado (preexistente, anterior a s31: divergencia 13 con el hermano, log s29 §36.7; anotado también en s31b T5). Va al backlog.
- **Alcance:** solo este log.
- **Subagentes:** sin subagentes.
- **Bugs / Decisiones autónomas / Errores propios / Dudas:** ninguno.

### FASE R: auditoría y reparación

Inventario de afirmaciones auditables, derivado del log (se anexa antes de auditar):

| id | afirmación (sección de origen) |
|---|---|
| R-01 | FASE 0: `HEAD` = `origin/main` = `48d35da`; porcelain solo el encargo; T0 = `ab6a3c5`; motor `4acb9e64…` regenerado idéntico; 0 warnings; `JSX OK`; 🔒7 = 0 |
| R-02 | FASE 0: fidelidad §4 `1e29c2b5…b5b6`, 59.466.778 bytes; `fase0.json` = `final.json` de s31b |
| R-03 | FASE 0 (calibración): "1 establecimientos" en las dos vistas con solo Medio alto (y 4 en Ollagüe); `dyLab` 9/17/9/17 en Medio |
| R-04 | T1: "1 establecimiento" en las dos vistas; "2 establecimientos" con Sin clasificar; 0 ocurrencias de "1 establecimientos"/"1 comunas" en 16 lecturas (foco, nacional, región, comuna × 4b/2m × actual/hist) y en el comparador |
| R-05 | T1: "SLEP Santiago Centro 1 comunas · 39 establecimientos" en el modal del comparador (fuera de T1) |
| R-06 | T2: `dyLab` 0/0/0/0 en Medio; 0 en las 12 filas sin nota con geometría idéntica a FASE 0; franja y comparador sin moverse; 390 px idéntico |
| R-07 | T3: motor `6c5feab5…` (5.463.985 bytes); §4 `1e29c2b5…`; `final.json == fase0.json`; 92 barras (y 112) con `diff` vacío |
| R-08 | T4: `docs/index.html` = motor (md5, `cmp -s`); testigos 6 y 14; ≠ `2f34dafe…` |
| R-09 | T5: piso de la rampa 4,58 vs 4,78; testigo viejo 2/2, nuevo 0/6 |
| R-10 | Todas las fases: `run_all(only = 35L)` exit 0 y 0 warnings (5 corridas) |
| R-11 | Alcance global: `git diff --name-only ab6a3c5..HEAD` ⊆ {template, motor, `docs/index.html`}; porcelain = este log |
| 🔒1–🔒8 | invariantes de s31/s31b |

Re-derivación independiente (comando distinto del que produjo cada cifra; salidas literales):
```
bash -c 'cd /tmp/idps_s31c && LC_ALL=C sed -E "s/,\"vista_territorial\":\{\"dominio_color\":\{[^}]*\},\"anios_estado\":\{[^}]*\},\"tinte_minimo\":0\.06\}//; s/\"fecha_generacion\":\"[0-9]{4}-[0-9]{2}-[0-9]{2}\"/\"fecha_generacion\":\"0000-00-00\"/" final.json | shasum -a 256'
```
esperado: R-02/R-07 (y 🔒2) con `sed`+`shasum` en vez de R+`digest`: `1e29c2b5…b5b6`.
obtenido: `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6` (JSON con bloque 59.467.009 bytes).
```
bash -c 'cd <scratchpad> && DATAJSON=/tmp/idps_s31c/final.json node r_s31c.js'   # estático sobre docs/index.html + JSX real en vm
```
esperado: R-04/R-08 estático: en `docs/index.html` `nEE(nHist)` 1 y `nEE(unidades.length)` 1, 0 cadenas a mano "} establecimientos en el nivel seleccionado" / "…con resultado en algún año"; R-06 estático: las tres reglas CSS del subgrid presentes (1/1/1); `nEE(1)` = "1 establecimiento"; R-07: las 16 barras del panorama actual 4b del volcado coinciden (N, bajo, neutro, sobre, sin) con `repartoInd` corrido en vm sobre `rosterTerr(SLEP 503, 4b, 2025)`.
obtenido: `R-T1 docs: nEE(nHist) 1 | nEE(unidades.length) 1 | … a mano: 0 | … a mano: 0`; `R-T2 docs: regla subgrid: 1 | gap:0 16px: 1 | media 760 vuelve a bloque: 1`; `nEE: ["1 establecimiento","2 establecimientos","60 establecimientos"]`; `R-T3 harness repartoInd vs volcado DOM (foco 4b actual): 16 de 16 barras coinciden` (primer intento con `kind:"foco"` en `rosterTerr` dio 0 de 0: esa función espera `kind:"slep"` + código; corregido, sin tocar ningún esperado).
```
bash -c 'cd <scratchpad> && NODE_PATH=… node r_s31c_browser.js /Users/tomgc/Projects/slep_idps/docs/index.html'   # sobre el motor PUBLICADO; hit-test (elementFromPoint) en vez de rectángulos; otra comuna de 1 EE (Tortel); frontera 761/760 px; secuencia distinta (2m primero)
```
esperado: R-06 por hit-test: a la altura del centro del rótulo y a ±12 px (casi el borde de la barra de 26 px), el punto sobre la columna de la barra cae dentro de `.s100` en las 16 filas ("cab"); en FASE 0, las filas de Medio fallan a un lado; contenedor con 3 pistas subgrid a 761 px y bloque a 760/390 px; R-04 con Tortel (1 EE, solo 4b): "1 comuna · 1 establecimiento …" en las dos vistas y 0 ocurrencias malas; consola 0 errores/avisos.
obtenido: `centrado1200: Bajo/Medio bajo/Medio/Medio alto: cab,cab,cab,cab` (y en 2° medio); calibración FASE 0: `Medio: ca-,-a-,ca-,-a-` (el hit-test también distingue el caso malo); `pistas1200: "subgrid [] [] [] []|grid|3"` (tres pistas heredadas; la fila declara 3); 761 px: 2 columnas, subgrid; 760 y 390 px: 1 columna, contenedor `block`, fila de 2 pistas, contenedor 5 px bajo el rótulo en las cuatro filas de Medio (FASE 0: igual); `scrollWidth = innerWidth` en 761/760/390; Tortel: `1 comuna · 1 establecimiento en el nivel seleccionado · 4° básico …`, `1 comuna · 1 establecimiento con resultado en algún año …`, `mal: 0`; 2° medio (sin datos): `0 comunas · 0 establecimientos …` con estado vacío; `errs: []`. (Dos intentos fallidos del instrumento: `document` fuera de `evaluate` y `clickText` exacto sobre "volver a Costa Central"; un tercero con `offsetTop` en marcos distintos dio cifras sin sentido y se reemplazó por el hit-test. Ningún esperado se tocó.)
```
bash -c 'shasum -a 256 /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html; git -C /Users/tomgc/Projects/slep_idps show HEAD:docs/index.html | md5 -q; git -C /Users/tomgc/Projects/slep_idps show HEAD:40_salidas/motor_idps.html | md5 -q; git -C /Users/tomgc/Projects/slep_idps show HEAD~1:docs/index.html | md5 -q; grep -o "sin comparación publicada" /Users/tomgc/Projects/slep_idps/docs/index.html | sort | uniq -c; grep -o vt-mx /Users/tomgc/Projects/slep_idps/docs/index.html | wc -l; for f in /tmp/idps_s31c/run35_*.log; do echo "$f: $(grep -ci warn "$f") warn, $(grep -c "Paso 35 OK" "$f") ok"; done'
```
esperado: R-08 con `shasum -a 256` y `git show` (lo commiteado, no el árbol): mismo SHA en los dos archivos; en HEAD `docs/index.html` = motor; en HEAD~1 `docs/index.html` = `2f34dafe…`; testigos por ocurrencia (`grep -o`): 6 y ≥ 14; R-10: 0 warn y 1 ok por corrida.
obtenido: `73e0b96343a43510e7def298b60d8c2db2384830b3fd5630b7dec5e326df8cd1` en los dos; HEAD `docs/index.html` `6c5feab5…` = HEAD motor `6c5feab5…`; HEAD~1 `docs/index.html` `2f34dafe1309b67e5e1e1cfb3eea47a3`; `6 sin comparación publicada`; `vt-mx` 17 ocurrencias (14 líneas); `run35_fase0/t1/t2/t3/faseR.log: 0 warn, 1 ok`.

Invariantes 🔒 (`<PR>` = `ab6a3c5`; corridos tras el último commit `d03aa5b`):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff ab6a3c5..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+" | grep -iE "prom" | grep -nE "\+=|reduce\(|/[[:space:]]*(n|N|len|total)\b"'
```
esperado: vacío.
obtenido: vacío (`rc=1`; 0 líneas agregadas contienen `prom`). **🔒1 PASA.** Control positivo (paso 6): copia `/tmp/idps_s31c/template_plantado.html` con `function mediaProm(items){ … suma+=d.prom; … return suma/n; }`; el mismo grep sobre `git diff --no-index template_PR.html template_plantado.html` dispara (`1:+  function mediaProm…`, `rc=0`).
```
bash -c 'cd /tmp/idps_s31c && Rscript /tmp/idps_s31/fidelidad.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'
```
esperado: `1e29c2b5…b5b6`, 59.466.778 bytes.
obtenido: `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `DISTINTO (ok)`. **🔒2 PASA** (y con `sed`+`shasum`, arriba; `final.json == fase0.json`).
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff ab6a3c5..HEAD -- 30_procesamiento | grep -nE "^[-+].*(--alerta:|--destaca:|--st-neutro:|--ind[1-4]:|INDICADOR_COLORS)"'
```
esperado: vacío.
obtenido: vacío. **🔒3 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff ab6a3c5..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+" | grep -nE "(difgru|prom_gse)[[:space:]]*[<>]"'
```
esperado: vacío.
obtenido: vacío. **🔒4 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only ab6a3c5..HEAD | grep -cE "\.(csv|xlsx|parquet|rds|json)$"'
```
esperado: `0`.
obtenido: `0`. **🔒5 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only ab6a3c5..HEAD -- docs | wc -l; git -C /Users/tomgc/Projects/slep_idps diff --name-only ab6a3c5..HEAD -- docs'
```
esperado: el comando heredado espera `0` ("docs/ intacto"); en este encargo T4 **despliega** a `docs/` por 0.2, así que la lectura válida es "docs/ solo cambia por el commit `deploy(docs)` y solo `index.html`, byte a byte igual al motor".
obtenido: `1`; `docs/index.html` (único archivo de `docs/`; cambia solo en `d03aa5b`; `cmp -s` con el motor sin diferencia). **🔒6 PASA con la lectura de 0.2**; la contradicción entre el enunciado heredado y el ALCANCE de T4 se anota como advertencia A-1.
```
bash -c 'grep -c "text-transform" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `0` (línea base de FASE 0).
obtenido: `0`. **🔒7 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff ab6a3c5..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^[-+]" | grep -nE "repartoInd|pctRound|sigdifgru|n_sin_comparacion|filasComparadorCSV"'
```
esperado: vacío.
obtenido: vacío (`rc=1`). **🔒8 PASA** (estático). Control positivo: la misma copia plantada lleva `function repartoIndFalso(items){ return items.filter(d=>d.sigdifgru===0).length; }` y el grep dispara (`20:+  function repartoIndFalso…`, `rc=0`); sobre el template real, vacío. Dinámico: `diff` vacío de 92 (y 112) barras (T3) y 16/16 contra `repartoInd` en vm (arriba). **Regla 0.1-4 no dispara.**

Alcance global (paso 4):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only ab6a3c5..HEAD; git -C /Users/tomgc/Projects/slep_idps diff --numstat ab6a3c5..HEAD; git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: ⊆ {`30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`, `docs/index.html`}; porcelain vacío antes de crear este log.
obtenido: exactamente esas tres rutas (R-11 ⊆): template `+18/−5`, motor `+18/−5`, `docs/index.html` `+426/−49`; porcelain vacío (medido antes de escribir este log; tras escribirlo, solo el log).

Regresión completa (paso 5): `run_all(only = 35L)` sobre el estado final → `rc=0`, `WARN: 0`; el motor regenerado es byte a byte el commiteado en `b3a91e7` (md5 `6c5feab5428ed05dff09867f2b47bba3`) y sigue idéntico a `docs/index.html` (`cmp -s`); porcelain sin cambios; §4 en R y en `sed`+`shasum`: `1e29c2b5…b5b6`.

Hallazgos y veredicto:

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01/02 | punto de retorno y fidelidad | `git show`, `sed`+`shasum`, `cmp` | `48d35da`; `1e29c2b5…`; JSON = s31b | iguales | — | ninguna | — | — |
| R-03/04 | plural del banner | estático en `docs/index.html`; vm `nEE`; navegador con Tortel y secuencia distinta | `nEE` en las dos ramas, 0 cadenas a mano; "1 establecimiento"; 0 malas | iguales | — | ninguna | — | — |
| R-05 | "1 comunas" en el modal del comparador | (observación fuera de T1; L1759 leída) | — | presente, 1 fila de 36 | ADVIERTE | duda D-1 (A-2) | — | — |
| R-06 | rótulo anclado a la barra | hit-test `elementFromPoint` sobre docs/; pistas del subgrid; frontera 761/760 | "cab" ×16; 3 pistas; bloque a ≤760 | iguales; FASE 0 falla en Medio | — | ninguna | — | — |
| R-07 | cifras intactas | `repartoInd` en vm vs volcado; `cmp` de JSON; `sed`+`shasum` | 16/16; iguales | 16/16; iguales | — | ninguna | — | — |
| R-08 | despliegue byte a byte | `shasum -a 256`; `git show HEAD`/`HEAD~1`; `grep -o` | mismo SHA; HEAD~1 = `2f34dafe…`; 6 / ≥14 | iguales; 6 / 17 | — | ninguna | — | — |
| R-09 | pendientes de T5 | citas al log s31b (R-11 de s31b) | 4,58 / 4,78; 2/0 vs 2/6 | iguales | — | ninguna | — | — |
| R-10 | warnings | `grep -ci warn` × 5 corridas | 0 | 0 | — | ninguna | — | — |
| R-11 | alcance | `diff --name-only`, `numstat`, porcelain | ⊆; vacío | ⊆; vacío | — | ninguna | — | — |
| A-1 | 🔒6 heredado dice "docs/ intacto" y T4 despliega | `diff --name-only -- docs` | 0 (enunciado) / solo `index.html` por T4 (0.2) | 1: `docs/index.html`, byte a byte = motor | ADVIERTE | anotar; el redactor debería reescribir 🔒6 para los encargos que despliegan | — | — |
| 🔒1–🔒8 | invariantes | comandos §2 de s31 + 🔒8 | vacíos / 0 / 0 | todos PASA (🔒6 con la lectura de 0.2); controles positivos de 🔒1 y 🔒8 disparan | — | — | — | — |

- **Ciclo de reparación:** 0 de 2 usados (ningún REPARA).
- **Veredicto global: APROBADO CON ADVERTENCIAS.** Hallazgos B/R/A = 0/0/2 (A-1 enunciado de 🔒6 vs T4; A-2 "1 comunas" en el modal del comparador, fuera de T1 → D-1); reparados 0; abiertos 0.
- **Subagentes:** sin subagentes.
- **Errores propios:** los tres del instrumento de navegador (`document` fuera de `evaluate`; `clickText` exacto; `offsetTop` en marcos distintos) y el `kind:"foco"` en `rosterTerr`; ninguno tocó un esperado ni costó más de un turno.

### FASE L: cierre del log

- **Estado:** completada.
- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este log; `main` adelantada 5 respecto de `origin/main` (`48d35da`: T0 y las cuatro tareas).
obtenido: `?? 50_documentacion/andamios/logs/20260917_forma_y_despliegue_s31c_log.md`; `## main...origin/main [ahead 5]`.
- **Paso 4, grep de privacidad:**
```
bash -c 'grep -nE "[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]" /Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260917_forma_y_despliegue_s31c_log.md'
```
esperado: vacío.
obtenido: vacío. El log no contiene nombres de establecimientos ni filas de datos; nombra comunas (Ollagüe, Tortel) y un SLEP (Santiago Centro) como territorios públicos del selector.
- **Paso 5:** `ls -l`, `wc -l` y conteos: en el reporte final (se miden tras escribir esta sección; `esperado:` = `obtenido:`, 8 `### FASE`, 1 `## J`).

## Cierre

1. **Resumen de la sesión.** Entró el encargo s31c (dos defectos de forma de la verificación de s31b + despliegue). Fases: FASE 0 (con T0), T1, T2, T3, T4, T5, R, L. Estado final del grafo: T0 completada (`ab6a3c5`) · T1 completada (`2eb0908`) · T2 completada (`58a37aa`) · T3 completada (`b3a91e7`) · T4 completada (`d03aa5b`) · T5 completada (en este log) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Sin gates del titular.
2. **Inventario de commits** (`git log 48d35da..HEAD --oneline`, HEAD antes del commit de este log):
   - `ab6a3c5` docs(s31c): encargo de forma y despliegue — FASE 0/T0 (= `<PR>`)
   - `2eb0908` fix(panorama): el banner concuerda el plural de establecimiento — T1
   - `58a37aa` fix(panorama): el rotulo del indicador se ancla a su barra — T2
   - `b3a91e7` build(motor): regenera con las correcciones de forma — T3 (motor `6c5feab5…`, 5.463.985 bytes)
   - `d03aa5b` deploy(docs): publica la vista historica territorial — T4 (`docs/index.html` = motor)
   - (este log: `docs(log): forma y despliegue s31c`, hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; hallazgos B/R/A = 0/0/2; reparados 0; abiertos 0.
4. **Invariantes:** 🔒1 PASA (grep vacío; control positivo dispara) · 🔒2 PASA (`1e29c2b5…b5b6` en R y `sed`+`shasum`; JSON byte a byte igual al de FASE 0 y al de s31b) · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA (0) · 🔒6 PASA con la lectura de 0.2 (solo `docs/index.html`, por T4, byte a byte = motor; A-1) · 🔒7 PASA (0) · 🔒8 PASA (grep vacío; control positivo dispara; 92 + 20 barras con `diff` vacío; 16/16 vs `repartoInd`). 8/8.
5. **Decisiones del usuario registradas en gates:** ninguna (FASE 0 coincidió con lo esperado).
6. **Estado de cifras/datos críticos:** payload intacto (SHA-256 §8.2 idéntico; `final.json == fase0.json`); ninguna cifra de barra, porcentaje ni CSV cambió; `idps_largo.parquet`, `20_insumos/` y `40_salidas/intermedios/` no tocados (🔒5); `docs/index.html` publicado = motor `6c5feab5428ed05dff09867f2b47bba3` (5.463.985 bytes), reemplaza a `2f34dafe…` (5.431.955 bytes).
7. **Dudas y pendientes consolidados:**
   - D-1 (T1): dos cadenas de conteo a mano fuera del banner y de las notas nacionales: `sub` de los SLEP en el modal del comparador (L1759; "SLEP Santiago Centro 1 comunas · 39 establecimientos", visible en el tab SLEP) y `title` del botón de exportación del panorama (L2944; "Descarga en CSV los 1 establecimientos de esta vista…", solo tooltip). ¿Se corrigen en el próximo encargo de forma (sí/no)? Bloquea: nada.
   - P-1 (T5.1): enmienda de la decisión §3.5 (piso real de la rampa 4,58:1; 4,78 es el mínimo sobre puntajes enteros). Cierre.
   - P-2 (T5.2): criterio del traspaso para verificar el despliegue: "sin comparación publicada" (y `vt-mx`) en vez de "Exportar CSV". Cierre.
   - P-3 (T5.3): teclado en el modal de territorio (preexistente). Backlog.
   - A-1: el enunciado heredado de 🔒6 ("docs/ intacto", esperado 0) contradice el ALCANCE de T4 en los encargos que despliegan; conviene reescribirlo como "docs/ solo cambia por el commit `deploy(docs)`, byte a byte igual al motor". Para el redactor.
   - De s31 siguen abiertas D-1 (`n_con_dato` → `n_con_comparacion`) y D-3 (chip "· sin comparación publicada"); P-4 de s31b (centrado del rótulo) queda **resuelta** por T2.
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** T1 (1): `run_all` lanzado con el `cd` del instrumento anterior vigente (`here::here()` sin raíz; 1 reintento autorizado). FASE R (4, todos de instrumento): `document` fuera de `evaluate`; `clickText` exacto sobre "volver a…"; `offsetTop` en marcos distintos (reemplazado por hit-test); `kind:"foco"` en `rosterTerr` (0 de 0 → 16 de 16). Ninguno tocó un esperado ni costó más de un turno.
9. **Notas para el revisor:** (a) en GitHub Pages, comprobar que el `index.html` servido trae "sin comparación publicada" (el testigo nuevo) una vez propagado el push; (b) en la sección Medio del SLEP foco, el rótulo del indicador queda centrado en su barra y la nota cuelga debajo: las filas con rótulo de dos renglones y nota crecen de 48 a 65 px; (c) `subgrid` requiere Chrome 117+/Firefox 71+/Safari 16+; en navegadores anteriores degrada al centrado sobre el bloque (s31b), sin romper; (d) el modal del comparador sigue diciendo "1 comunas" para SLEP Santiago Centro (D-1).
10. **Estado de cierre:** commiteados `ab6a3c5`, `2eb0908`, `58a37aa`, `b3a91e7`, `d03aa5b` y este log (commit propio). **Se publica:** `git push origin main` (FASE R en APROBADO CON ADVERTENCIAS y porcelain vacío tras el commit del log); `docs/index.html` desplegado. Queda al titular: D-1 y P-1..P-3 (más A-1 para el redactor) en el cierre.
