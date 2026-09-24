# Encargo autónomo: la vista histórica no desborda la página (s33g)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (una edición y un build en serie; `encargo_autonomo_claude_code_v1.md` §2.12, fila 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; el log `50_documentacion/andamios/logs/20260924_ajustes_angosto_s33f_log.md` (M6b, R-14, R-15 e instrumentos `/tmp/s33f_*`).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33g_*`); `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Con ventana, esperar el elemento visible antes de la primera acción; a anchos angostos, forzar remount tras cambiar el viewport. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_vista_historica_ancho_s33g_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33g` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33: 0 errores de consola y 0 `pageerror`; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0; (d) los cuatro CSV de s33f M6 byte-idénticos.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; ningún color hex nuevo.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. M5 no reproduce el caso malo, o la calibración de 🔒6 (M7) no separa el suavizado de un cambio visible → congela T1 y regístralo.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33g`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33g_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `3d17694`, el `docs(log)` de s33f (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24). Motor `bc9a0a391b3814d97fff1b8b2de61d12`; `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor).
- La vista histórica desborda la página (headless: 423 px a 390, 493 a 320). La causa son 119 textos para lector de pantalla (`.vt-mx caption,.vt-sr{position:absolute;…}`) cuyo bloque contenedor no es `.vt-scroll`, así que su `overflow-x:auto` no los recorta; ningún ancestro de `.vt-scroll` es más ancho que el viewport (fuente: log s33f, M6b y R-14; regla CSS leída por el redactor con `grep -n`).
- `.vt-scroll{overflow-x:auto;border:1px solid var(--linea);border-radius:var(--radius-2);background:var(--paper);}` no declara `position` (fuente: `grep -n` del redactor).
- La variante (a), `.vt-scroll{position:relative;}`, medida en una copia, quitó el desborde en todos los anchos (foco y comuna, dos modos) y conservó el clic en la fila; a 1280 px, la captura de la vista histórica dio AE 0,15 a 0,18 (25 a 29 píxeles de suavizado, máximo 15/255 por canal), no 0 (fuente: log s33f, R-15 y línea de estado de T2).
- El desborde de 1,7 px del segmentador `.pan-nivel` con ventana de escritorio a 320 px (H-1 de s33f) **no** se toca: decisión del redactor con criterio delegado por el titular (un celular no lo muestra; una ventana de escritorio a 320 px no es uso real).

**Decisión del titular que este encargo implementa (sesión 33, criterio delegado al redactor):** D-2 de s33f → **sí, variante (a)**, con 🔒6 leído con una tolerancia de suavizado calibrada en FASE 0 (M7). Se elige (a) y no (e) porque el bloque contenedor debe ser el elemento que ya declara el `overflow`.

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. En celulares, la vista histórica del panorama empuja la página hacia el lado porque textos invisibles para lector de pantalla escapan del recuadro con scroll de la matriz. Una declaración CSS lo corrige. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas cambiadas del diff `-U0` de la plantilla: **agregadas = 0**.
3. **`sigdifgru` intacto:** líneas cambiadas con `sigdifgru`: **0/0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Nada visible cambia a 1280 px:** capturas a 1280 × 800 de la barra de pantallas y de la vista actual del panorama con `magick compare -metric AE` = 0; y de la vista histórica del SLEP foco con `magick compare -metric AE -fuzz <F>` = 0, donde `<F>` es la tolerancia fijada en M7.
7. **Lectores de pantalla:** los 119 textos `.vt-sr` y el `caption` de la matriz siguen en el árbol de accesibilidad (mismo número y mismo texto antes y después, leídos con el árbol de accesibilidad de Chrome o con `textContent`).
8. **Exportaciones intactas:** PRUEBAS d.

## 4. Grafo de tareas y ALCANCE

- **T1** (`position:relative` en `.vt-scroll`) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 completada.
- Serie: T1 → T2. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `3d17694` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*`); hash §8.2 con calibración; md5 y líneas del `:root`; md5 del motor | `eb4e00b3…4dc4`; igual con la fecha alterada; distinto con la cifra plantada; `bc9a0a39…` | congela T2 si la calibración falla |
| M4 | Líneas base de PRUEBAS d (md5 de los cuatro CSV de s33f M6) y de 🔒7 (número y textos de `.vt-sr` y `caption`) | los md5 de s33f; un número y una lista | congela T1 |
| M5 | **Caso malo de T1**, con ventana y headless, a 320, 360, 390 y 412 px (remount), vista histórica del SLEP foco en 4° básico y de una comuna: `scrollWidth` frente a `clientWidth` del documento | desborde (≈ 423 px a 390 en headless) | regla 6 |
| M6 | Capturas de referencia a 1280 × 800 (barra, vista actual, vista histórica) | tres PNG | congela T1 |
| M7 | **Calibración de la tolerancia de 🔒6:** aplica la edición de T1 a una copia en `/tmp` y compara su captura de la vista histórica con M6: sube `-fuzz` de 1 % en 1 % hasta el primer valor `F` con AE = 0. Luego, en otra copia, un **cambio visible plantado** (el color de fondo de una celda de la matriz alterado en 20/255 por canal, o el texto de una celda cambiado): con `-fuzz F`, AE debe ser > 0 | un `F` ≤ 8 % (el suavizado medido en s33f llega a 15/255 ≈ 5,9 %) y el plantado detectado | regla 6 |
| M8 | Calibración del testigo de T2 contra lo publicado y el motor actual: `grep -c -F '.vt-scroll{position:relative;'` (o la forma exacta que tome la edición) | `0` en `docs/index.html` y `0` en el motor actual | se elige otra cadena nueva y exclusiva, y se registra |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: `.vt-scroll` es el bloque contenedor de sus textos para lector de pantalla

1. Paso 0: relee M5 y M7.
2. Edición: en la regla `.vt-scroll{…}`, agregar `position:relative;`. Comentario de una línea antes de la regla: `/* s33g: position relative hace que el overflow de .vt-scroll recorte los .vt-sr absolutos (A-1 de s33e, D-2 de s33f). */`. Nada más cambia.
3. Verificación (con ventana y headless): M5 repetido: `scrollWidth` = `clientWidth` a 320, 360, 390 y 412 px en los dos territorios (salvo el 1,7 px de `.pan-nivel` con ventana a 320, anterior y registrado, que se identifica por elemento); `.vt-scroll` sigue con scroll interno (`scrollWidth` > `clientWidth`); el clic en una fila de la matriz abre la ficha; 🔒6 con `F` de M7; 🔒7; PRUEBAS b.
4. Commit `fix(motor): la vista historica no desborda la pagina (s33g T1, D-2 de s33f)`.

### T2: build

1. `git status --porcelain` → **solo el motor y el LOG**; otra ruta congela T2.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b y d; 🔒6 y 🔒7 sobre el motor commiteable; hash §8.2 = M3.
3. Testigo para el despliegue: la cadena de M8 (≥ 1 en el motor nuevo, 0 en `docs/index.html`).
4. md5 del motor nuevo registrado. Commit `build(motor): s33g vista historica sin desborde`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M7, M8) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (desborde con `getBoundingClientRect().right` del elemento más a la derecha; otro ancho, 400 px; 🔒7 por la otra vía de lectura).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b, c y d sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol (por ejemplo, el motor sin `position:relative` debe volver a desbordar).
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado (la `F` de M7 queda fija una vez calibrada); ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; desbordes antes y después; `F` calibrada); decisiones del titular registradas (D-2 de s33f: sí, variante (a); D-1 de s33f: no, por criterio delegado); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33g_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el log; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33g vista historica sin desborde"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; testigo y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; desbordes antes y después; `F` calibrada; testigo y md5 para el despliegue; lo que queda al titular para el gate visual (vista histórica en el celular o a 390 px, sin desplazamiento lateral de la página); "lo que falló o sorprendió; si nada, decirlo".
