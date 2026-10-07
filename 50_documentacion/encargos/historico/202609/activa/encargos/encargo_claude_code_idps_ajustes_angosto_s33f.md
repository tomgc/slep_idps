# Encargo autónomo: pestaña partible, vista histórica sin desborde y nombre del CSV histórico (s33f)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; `40_salidas/intermedios/idps_largo.parquet`; los logs de s33d y s33e en `50_documentacion/andamios/logs/` (instrumentos de ancho, de foco y de Blob, y líneas base).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33f_*`); `Rscript` para cifras sobre datos; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Con ventana, esperar el elemento visible antes de la primera acción; a anchos angostos, forzar remount tras cambiar el viewport. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. **Ningún shell en segundo plano queda corriendo al terminar** (se cierra o se espera cada uno antes de FASE L). Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_ajustes_angosto_s33f_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33f` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33: 0 errores de consola y 0 `pageerror`; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0; (d) los CSV del comparador, del panorama actual, de la ficha y **del histórico** byte-idénticos antes y después para los casos fijos de M6 (el nombre del histórico cambia solo en el caso de T3).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; ningún color hex nuevo; la paleta de ESTADO y la de INDICADOR no se tocan.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. Un caso malo de FASE 0 (M5, M6b o M7) no se reproduce → la tarea que lo corrige se omite y se registra.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (fila 5 agregada por el redactor), en un solo commit (`chore(encargo): s33f y registro del asistente s33`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33f_*`; lectura y copia de los `/tmp/s33*` y `/tmp/s30*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `2ed83f8`, el `docs(log)` de s33e (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24). Motor `977575d193e8207acc7728c8cdcbc909`; `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor y log s33e).
- El registro del asistente s33 tiene 5 filas; la fila 5 la agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- `.screen-tab` lleva `white-space:nowrap`; bajo 480 px rige `@media (max-width:480px){ .app-nav-inner{padding:0 12px;} .screen-tab{padding:14px 12px;} .screen-tabs{overflow-x:auto;max-width:100%;} }` (fuente: `sed` del redactor). A 320 px la pestaña más ancha, "Panorama IDPS por establecimiento", mide 335 px y la barra 296 px; con el rótulo partible en dos líneas bajo 480 px cabe (296 de 296) y a 390 y 480 px no cambia nada (fuente: log s33e, T1 congelada y D-1, medido en una copia).
- La vista histórica del panorama desborda la página 423 px a 390 px de ancho, también en el motor anterior a s33e, y la causa es la matriz (fuente: log s33e, A-1). La matriz ya vive dentro de `.vt-scroll{overflow-x:auto;…}` (fuente: `grep -n` del redactor). Qué ancestro impide que ese scroll actúe (por ejemplo, un ítem de grid o flex sin `min-width:0`) es hipótesis (se mide en FASE 0, M6b).
- El nombre del CSV histórico usa `sufijoGse(args.gseSel)`, que solo mira los cinco GSE de `DATA.meta.gse`; el grupo "Sin clasificar" (`"sin"`), que solo existe en la vista histórica, no entra al nombre: ocultarlo cambia el universo (61 → 60 en el caso del log) sin cambiar el nombre (fuente: `sed` del redactor y log s33e, D-3).

**Decisiones del titular que este encargo implementa (sesión 33, criterio delegado al redactor):** D-1 de s33e → sí (rótulo partible bajo 480 px); D-3 → sí (el nombre marca "Sin clasificar" excluido); A-1 → sí (la vista histórica no desborda la página); D-2 → sí (la fidelidad del CSV histórico se mide contra el entero que muestra la pantalla, `round(prom, 0)`).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. Tres ajustes chicos que dejó s33e: la pestaña más ancha no cabe a 320 px, la vista histórica empuja la página en celulares, y el nombre del CSV histórico no distingue un universo sin "Sin clasificar". `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas cambiadas del diff `-U0` de la plantilla: **agregadas = 0**.
3. **`sigdifgru` intacto:** líneas cambiadas con `sigdifgru`: **0/0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Nada cambia a 1280 px:** capturas de la barra de pantallas, de la vista actual del panorama y de la vista histórica del SLEP foco a 1280 × 800, antes y después: `magick compare -metric AE` = 0.
7. **Exportaciones intactas:** PRUEBAS d.
8. **Foco y teclado siguen iguales:** los scripts de ciclo, devolución y respaldos dan lo mismo que en el log s33e, en los dos modos.

## 4. Grafo de tareas y ALCANCE

- **T1** (rótulo partible bajo 480 px) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (la vista histórica no desborda) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente; en serie después de T1.
- **T3** (nombre del CSV histórico con "Sin clasificar" excluido) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente; en serie después de T2.
- **T4** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere al menos una de T1 a T3.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `2ed83f8` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*`); hash §8.2 con calibración; md5 y líneas del `:root`; md5 del motor | `eb4e00b3…4dc4`; igual con la fecha alterada; distinto con la cifra plantada; `977575d1…` | congela T4 si la calibración falla |
| M4 | Instrumento de Blob (copia del de s33e) con su control positivo | se captura un CSV conocido completo | congela T3 |
| M5 | **Caso malo de T1**, con ventana y headless, a 320 px (remount): ancho de la pestaña más ancha y de `.screen-tabs`; ¿cabe? | 335 y 296; no cabe | regla 6 para T1 |
| M6 | Líneas base de PRUEBAS d: md5 de los CSV de s33e M6 (comparador, panorama actual, ficha) y del CSV histórico del SLEP foco en 4° básico con todos los grupos visibles, con su nombre | cuatro md5 y un nombre | congela T3 |
| M6b | **Caso malo de T2**, con ventana y headless, a 390 y 320 px (remount), vista histórica del SLEP foco en 4° básico: `scrollWidth` frente a `innerWidth`, y para cada ancestro de `.vt-scroll` hasta `body`, su ancho, su `display` y su `min-width` calculado; identificar el primer ancestro más ancho que el viewport | desborde (≈ 423 px a 390) y el ancestro responsable, registrado | regla 6 para T2; si la causa no es un ancestro de `.vt-scroll`, se registra como duda y T2 no se toca |
| M7 | **Caso malo de T3:** en la vista histórica del SLEP foco en 4° básico (que tiene "Sin clasificar"), exportar con todos los grupos y con "Sin clasificar" oculto: nombres de los dos archivos y filas de cada uno (en R) | mismo nombre, filas distintas | regla 6 para T3 |
| M8 | Capturas de referencia de 🔒6 y líneas base de 🔒8 | PNG de referencia; valores del log s33e | congela T1 y T2 |
| M9 | Calibración del testigo de T4 contra lo publicado y el motor actual: `grep -c` de la cadena candidata `sin_clasificar_excluido` | `0` en `docs/index.html` y `0` en el motor actual | se elige otra cadena nueva y exclusiva, y se registra |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: el rótulo de la pestaña puede partirse bajo 480 px (D-1 de s33e)

1. Paso 0: relee M5.
2. Edición: dentro de la media query `@media (max-width:480px)` existente, `.screen-tab` suma `white-space:normal;` (y, si hace falta para que el rótulo parta y quede legible, `text-align:left;`). Nada más cambia; sobre 480 px la regla general con `nowrap` sigue igual.
3. Verificación (con ventana y headless): a 320 px la pestaña más ancha cabe en `.screen-tabs` (rectángulo dentro del de la barra) y `scrollWidth` = `innerWidth`; a 360, 390, 412, 425 y 480 px, `scrollWidth` = `innerWidth` y el ancho de cada pestaña igual al de M5 salvo donde el rótulo parte; 🔒6 a 1280; 🔒8.
4. Commit `fix(motor): el rotulo de la pestana puede partirse bajo 480 px (s33f T1, D-1 de s33e)`.

### T2: la vista histórica no desborda la página (A-1 de s33e)

1. Paso 0: relee M6b.
2. Edición mínima sobre el ancestro que M6b identifique: `min-width:0` (para un ítem de grid o flex) o `max-width:100%`, de modo que el `overflow-x:auto` de `.vt-scroll` actúe y la matriz haga scroll **dentro** de su contenedor, como la tabla del comparador desde s32d. Si la franja de estado (`.vt-franja`) también desborda, el mismo remedio sobre su contenedor. Comentario de una línea que nombre el ancestro y la causa. Sin cambios de tipografía, color ni tamaño de celdas.
3. Verificación (con ventana y headless): a 320, 360, 390, 412 y 425 px en la vista histórica del SLEP foco y de una comuna, `scrollWidth` = `innerWidth`, y `.vt-scroll` tiene `scrollWidth` > `clientWidth` (el scroll quedó adentro); el clic en una fila de la matriz sigue abriendo la ficha; 🔒6 a 1280 (AE = 0 en la vista histórica); 🔒8.
4. Commit `fix(motor): la vista historica hace scroll dentro de su tabla en pantallas angostas (s33f T2, A-1 de s33e)`.

### T3: el nombre del CSV histórico marca "Sin clasificar" excluido (D-3 de s33e)

1. Paso 0: relee M6 y M7; lee `descargarHistoricoCSV`, `sufijoGse` y cómo `PanoramaHistorico` recibe la selección de GSE.
2. Edición: solo en el nombre del CSV histórico (el del panorama actual no se toca: 🔒7): si en esa vista existe el grupo "Sin clasificar" y está oculto, se agrega `_sin_clasificar_excluido` después del sufijo de GSE. La información de si el grupo existe y si está visible llega por las props que ya recibe la vista o por una prop nueva, sin recalcular universos. `sufijoGse` no cambia.
3. Verificación (instrumento de M4): M7 repetido: con todos los grupos, el nombre es el de M6 y el archivo es byte-idéntico; con "Sin clasificar" oculto, el nombre termina en `_sin_clasificar_excluido.csv` y el contenido es igual al de M7 (mismo md5); en una vista sin "Sin clasificar", el nombre no cambia; 🔒7.
4. Commit `fix(motor): el nombre del CSV historico marca Sin clasificar excluido (s33f T3, D-3 de s33e)`.

### T4: build

1. `git status --porcelain` → **solo el motor y el LOG**; otra ruta congela T4.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b y d; 🔒6 y 🔒8 sobre el motor commiteable; hash §8.2 = M3.
3. Testigo para el despliegue: la cadena de M9 (≥ 1 en el motor nuevo, 0 en `docs/index.html`).
4. md5 del motor nuevo registrado. Commit `build(motor): s33f ajustes de ancho y nombre del CSV historico`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M4, M5, M6b, M7, M9) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (desborde medido además con `getBoundingClientRect().right` del elemento más a la derecha; otro ancho intermedio, 400 px; filas del CSV re-derivadas en R desde el parquet).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG, el encargo y el registro); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b, c y d sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; anchos y desbordes antes y después; nombres y md5 de los CSV); decisiones del titular registradas (D-1, D-2, D-3 y A-1 de s33e: sí); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33f_priv.sh`) → vacío, con control plantado; ningún RBD con número, nombre de establecimiento ni fila de CSV en el log; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33f ajustes de ancho y nombre del CSV historico"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; testigo y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; anchos y desbordes antes y después; nombres de los CSV; testigo y md5 para el despliegue; lo que queda al titular para el gate visual (celular o ventana a 320 y 390 px: pestañas y vista histórica); "lo que falló o sorprendió; si nada, decirlo".
