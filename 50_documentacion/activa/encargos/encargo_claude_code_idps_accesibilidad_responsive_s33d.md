# Encargo autónomo: accesibilidad, ancho angosto y dos ajustes del modal y del comparador (s33d)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; los logs de s33, s33b y s33c en `50_documentacion/andamios/logs/` (instrumentos y líneas base); la decisión `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` (tokens `-txt`, §3.3).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33d_*`); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). **Con ventana, antes de la primera acción de cada corrida, esperar a que el motor esté montado y el elemento de la acción visible (`waitForSelector` con `visible:true`), no a `load`: en s33b y s33c la primera acción con ventana falló dos veces por esto (A-3 de s33c).** Para medir a anchos angostos, forzar remount tras cambiar el viewport (cambiar de pantalla y volver: `document.hidden` en la pestaña del pane, instrumentación s29g). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_accesibilidad_responsive_s33d_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33d` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33 (`/tmp/s33_pruebas_b.sh` o su equivalente reescrito): 0 errores de consola y 0 `pageerror`; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; **ningún color hex nuevo** (solo tokens existentes); la paleta de ESTADO y la de INDICADOR no se tocan.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. Un caso malo de FASE 0 (M5 o M6) no se reproduce → la tarea que lo corrige se omite y se registra; la otra sigue.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (filas 3 y 4 agregadas por el redactor), en un solo commit (`chore(encargo): s33d y registro del asistente s33`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33d_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `55d4701`, el `docs(log)` de s33c (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24). Motor `5825cc14c9f625287733e5780c1a0f0b`; `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor).
- El registro del asistente s33 tiene 4 filas; las filas 3 y 4 las agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- La meta del chip de un territorio termina en `" con IDPS en "+DATA.meta.grados[cmpGrado]+" "+agno`, sin marca de año preliminar; la ficha usa el sufijo `" (preliminar)"` con `PRELIM.has(String(agno))` (fuente: `grep -n` del redactor). Hoy `PRELIM` está vacío (fuente: log s33c, A-5).
- En `EntityModal`, el buscador tiene `autoFocus` y se vuelve a montar al pasar de Nacional (sin buscador, s33c T4) a otra pestaña, así que el foco salta de la pestaña al buscador (fuente: log s33c, A-6, y `grep -n autoFocus` del redactor). El origen del foco se lee en el primer render (s32e) (fuente: comentario del efecto, `grep -n` del redactor).
- Hover de los botones de quitar: `.sel-chip button:hover{color:var(--alerta);}` y `.cmp-x:hover{color:var(--alerta);}`; los dos botones están sobre chips de fondo `var(--paper)` (blanco) (fuente: `grep -n` del redactor sobre la plantilla). `--alerta` da 4,11:1 sobre blanco, bajo el 4,5 de texto (fuente: CLAUDE.md del proyecto, pendiente "Menor"; se re-mide en FASE 0, M5). El token de texto `--alerta-txt` existe (fuente: `grep -n` del redactor) y su uso sobre fondo claro es el de la decisión de contraste §3.2.
- Si s33c agregó más botones de quitar (la franja `.modal-sel` de T5) con hover en `--alerta` es hipótesis (se mide en FASE 0, M4).
- Barra de pantallas: `.app-nav-inner` (flex, `flex-wrap:wrap`, `padding:0 24px`) contiene `.screen-tabs` (flex, `flex-wrap:wrap`); cada `.screen-tab` tiene `padding:14px 18px`, `white-space:nowrap` y `font-size:var(--fs-body-lg)` (fuente: `sed` del redactor). Que bajo 425 px de ancho la página se desborde horizontalmente por esta barra (`scrollWidth` > `innerWidth`) es hipótesis (pendiente 6 del traspaso v31; se mide en FASE 0, M6).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. Dos defectos menores de accesibilidad y de ancho que quedaron en el backlog (el ✕ de quitar se vuelve rojo al pasar el ratón con un contraste bajo el mínimo de texto, y la barra de pestañas desborda en celulares angostos) y dos advertencias de s33c que el titular decidió corregir (A-5: el chip no marcaría un año preliminar; A-6: al volver de Nacional el foco salta al buscador). `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas cambiadas del diff `-U0` de la plantilla: **agregadas = 0**.
3. **`sigdifgru` intacto:** líneas cambiadas con `sigdifgru`: **0/0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Nada cambia a 1280 px:** captura de la barra de pantallas y de un chip del comparador a 1280 × 800 antes y después: `magick compare -metric AE` = 0 en la barra (T2 solo actúa bajo su media query) y en el chip sin hover.
7. **Foco y teclado de s32e, s33 y s33c siguen iguales:** los scripts de ciclo y devolución y de respaldos (líneas base del log s33c) dan lo mismo en los dos modos.

## 4. Grafo de tareas y ALCANCE

- **T1** (hover del ✕) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (barra de pestañas angosta) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente de T1 en lógica; en serie después de T1.
- **T3** (año preliminar en el chip, A-5 de s33c) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente; en serie después de T2.
- **T4** (el foco se queda en la pestaña al cambiarla, A-6 de s33c) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente; en serie después de T3.
- **T5** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere al menos una de T1 a T4.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD`; mensaje de `HEAD~1` | `HEAD~1` = `origin/main`; `0`; `1`; empieza por `docs(log): s33c` | regla 2; si solo difiere el mensaje, se registra |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*`); hash §8.2 con calibración; md5 y líneas del `:root`; md5 del motor | `eb4e00b3…4dc4`; igual con la fecha alterada; distinto con la cifra plantada | congela T3 si la calibración falla |
| M4 | `grep -n ':hover{color:var(--alerta)' ` y lista de todos los botones de quitar del motor (clase, selector de hover y fondo del contenedor) | `.sel-chip button` y `.cmp-x` (y los que s33c haya agregado, si los hay) | residual |
| M5 | **Caso malo de T1:** en Chrome, `:hover` forzado (CDP `CSS.forcePseudoState`) sobre `.sel-chip button` (con una dependencia elegida en el panorama) y sobre `.cmp-x` (con una entidad en el comparador): color calculado y contraste WCAG contra el fondo opaco del contenedor | `rgb` de `--alerta`; **4,11** (< 4,5) | regla 6 para T1 |
| M6 | **Caso malo de T2:** en las tres pantallas, a 390, 412 y 425 px de ancho (con remount): `document.documentElement.scrollWidth` frente a `innerWidth`, y el ancho de `.app-nav-inner`, `.screen-tabs` y de cada `.screen-tab` | a 390: `scrollWidth` > `innerWidth`, y el exceso sale de la barra (se registra qué elemento) | regla 6 para T2; si el desborde sale de otro elemento, se registra como duda y T2 no lo toca |
| M7 | Capturas de 🔒6 a 1280 × 800 (barra y chip sin hover) | dos PNG de referencia | congela T1 y T2 |
| M8 | Líneas base de 🔒7 en los dos modos | las del log s33c | congela T1, T2 y T4 |
| M9 | **Caso malo de T3:** en una copia en `/tmp` del motor con `anios_preliminar` del payload forzado a incluir el año del comparador (solo la copia; el árbol no se toca), texto del chip de un territorio | termina en `con IDPS en 4° básico 2025` **sin** marca de preliminar | regla 6 para T3 |
| M10 | **Caso malo de T4**, con ventana y headless: en los dos modales, ir con teclado a la pestaña Nacional y luego a Comuna; `document.activeElement` tras volver | el buscador (`INPUT.input-search`), no la pestaña | regla 6 para T4 |
| M11 | Calibración del testigo de T5 contra lo publicado: `grep -c` de cada cadena candidata en `docs/index.html` y en el motor actual | la cadena elegida da 0 en `docs/` y 0 en el motor actual (aparecerá solo tras el build) | se elige otra cadena, nueva y exclusiva, y se registra |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: el ✕ de quitar usa el token de texto al pasar el ratón

1. Paso 0: relee M4 y M5.
2. Edición: en cada regla de M4, `color:var(--alerta)` → `color:var(--alerta-txt)`. Nada más cambia. Si alguno de los botones de M4 está sobre un fondo no claro, esa regla no se toca y se registra como duda.
3. Verificación: M5 repetido: color = `rgb` de `--alerta-txt` y contraste ≥ 4,5 en cada botón; 🔒6 (chip sin hover igual); 🔒2; PRUEBAS b.
4. Commit `fix(motor): el boton de quitar usa --alerta-txt al pasar el raton (s33d T1)`.

### T2: la barra de pestañas cabe en pantallas angostas (pendiente 6)

1. Paso 0: relee M6.
2. Edición, solo si M6 confirma que la barra es la causa: una media query nueva (`@media (max-width:480px)`), junto a las demás del bloque de la barra, que reduzca el `padding` horizontal de `.app-nav-inner` y de `.screen-tab` y, si con eso no alcanza, permita el scroll horizontal **dentro** de `.screen-tabs` (`overflow-x:auto`) en vez de la página. Los valores se eligen midiendo: el mínimo cambio con el que, a 390 px, `scrollWidth` = `innerWidth` en las tres pantallas. Sin cambios de tipografía ni de color. Comentario de una línea: `/* s33d: bajo 480px la barra de pantallas no desborda la pagina (pendiente 6 de v31). */`.
3. Verificación: T2.1 a 390, 412 y 425 px, `scrollWidth` = `innerWidth` en las tres pantallas; T2.2 las pestañas siguen operables con Tab y con clic a 390 px; T2.3 🔒6 a 1280 px (AE = 0 en la barra); T2.4 caso malo: M6 sobre el motor de FASE 0 sigue desbordando.
4. Commit `fix(motor): la barra de pantallas no desborda bajo 480 px (s33d T2, pendiente 6)`.

### T3: el chip marca el año preliminar (A-5 de s33c)

1. Paso 0: relee M9.
2. Edición: al sufijo de la meta del chip se agrega `+(PRELIM.has(String(agno))?" (preliminar)":"")`, el mismo texto que usa la cabecera de la ficha. Nada más cambia.
3. Verificación: M9 repetido sobre la copia con el año forzado: el chip termina en `… 2025 (preliminar)`; sobre el motor real (sin años preliminares), el texto del chip es idéntico al de M8/M5; censo de cifras de s33c (🔒6 de s33c) sin cifras distintas; PRUEBAS b.
4. Commit `fix(motor): el chip del comparador marca el ano preliminar (s33d T3, A-5 de s33c)`.

### T4: al cambiar de pestaña, el foco se queda en la pestaña (A-6 de s33c)

1. Paso 0: relee M10 y M8.
2. Edición: el buscador recibe el foco **solo al abrir el modal**, no cada vez que se vuelve a montar por un cambio de pestaña. Mecanismo a elección (por ejemplo, una bandera por `useRef` que el primer montaje consume), con la condición de no mover la lectura del origen del foco, que sigue en el primer render (s32e). Comentario de una línea: `// s33d: el buscador toma el foco solo al abrir el modal; al cambiar de pestana el foco queda en la pestana (A-6 de s33c).`
3. Verificación (con ventana y headless): M10 repetido: el foco queda en el botón de la pestaña elegida; al abrir cada modal, el foco sigue yendo al buscador; 🔒7 (ciclo, devolución 10 de 10 y respaldos iguales a M8).
4. Commit `fix(motor): el foco se queda en la pestana al cambiarla (s33d T4, A-6 de s33c)`.

### T5: build

1. `git status --porcelain` → **solo el motor y el LOG**; otra ruta congela T5.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b; 🔒6 y 🔒7 sobre el motor commiteable; hash §8.2 = M3.
3. Testigo para el despliegue: la cadena calibrada en M11 (≥ 1 en el motor nuevo, 0 en `docs/index.html`).
4. md5 del motor nuevo registrado. Commit `build(motor): s33d accesibilidad, ancho y ajustes del modal`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M6, M9, M10, M11) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (contraste recalculado en Python desde los hex del `:root`; desborde medido además con `getBoundingClientRect().right` del último elemento de la barra; otro ancho intermedio, 400 px).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; contrastes y anchos antes y después); decisiones del titular registradas (el anillo crema de la ficha queda como está; A-5 y A-6 de s33c se corrigen; A-4 de s33c, chips una línea más altos, se acepta; A-3 de s33c se resuelve en el instrumento con la espera de POSICIÓN); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33d_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento o de persona; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33d accesibilidad y ancho"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; testigo y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; contrastes del ✕ y anchos de la barra antes y después; testigo y md5 para el despliegue; lo que queda al titular para el gate visual (abrir el motor en el celular o con la ventana a 390 px); "lo que falló o sorprendió; si nada, decirlo".
