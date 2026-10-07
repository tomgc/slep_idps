# Encargo autónomo: gobCL Bold, chequeo de fuentes en el verificador e instrumentos fuera de /tmp (s34d)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (`encargo_autonomo_claude_code_v1.md` §2.12, filas 1 y 2).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_generar_motor_html.R` (marcadores: `font_dir <- here::here("50_documentacion", "andamios", "diseno", "motor_idps", "fonts")`, `fuentes <- list(`, `list(fam = "gobCL", w = 800, f = "gobCL_Heavy.otf"),`, `fonts_css <- vapply(fuentes, function(ft) {`, `ruta <- fs::path(font_dir, ft$f)`); `tests/verificar_motor.R` (marcadores: `red <- contar_red(html)`, `informar <- function(ok, texto) {`) y `tests/verificar_motor_helpers.R` (`contar_red <- function(html) {`); `30_procesamiento/35_motor_template.html` (solo lectura: `--fw-bold:700`); gobCL Bold instalada en la estación (`~/Library/Fonts`); los instrumentos de s34c en `/tmp/s34c_*` (descritos en `50_documentacion/andamios/logs/20261007_cabecera_logo_fuentes_s34c_log.md`, FASE 0 "Instrumentos reescritos").
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps` en los comandos; ningún comando asume `cd`. **En el código R, rutas con `here::here()`, nunca absolutas.** `bash` explícito; anexos al LOG desde archivos; ningún script se edita mientras corre. Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`) **siempre headless** con `--disable-gpu`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Si el build cruza la medianoche, la prueba de build corre en un clon (`/tmp/s34d_clon`). Ningún shell en segundo plano queda corriendo al terminar.
- **Pantalla:** cambia a propósito (lo que pide peso 700 en gobCL deja de salir en la Heavy): la convención de pantalla idéntica no aplica; la reemplaza la **compuerta visual del titular** de T5.
- **LOG:** `50_documentacion/andamios/logs/20261007_bold_verificador_s34d_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s34d` es `<inicio>`.
- **PRUEBAS:** (a) `Rscript /Users/tomgc/Projects/slep_idps/tests/verificar_motor.R; echo "rc=$?"` → `rc=0` (desde T2, con el chequeo de fuentes); (b) build `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all(only = 35L)'` con exit 0 y 0 warnings; (c) 0 errores de consola y 0 `pageerror` en los recorridos del encargo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ningún color hex nuevo; la plantilla no se toca. El LOG no lleva RBD ni nombres de establecimiento.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, `50_documentacion/andamios/logs/20260926_registro_asistente_s34.md`} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. md5 de `docs/index.html` distinto de `fa5bad29ddd94f38a1d11c7821e2bf3c` en FASE 0 → detén la sesión y pasa a FASE L.
4. **gobCL Bold:** no hay en `~/Library/Fonts` exactamente un archivo de gobCL de peso 700 que sea OpenType válido (firma `OTTO` o `true`/`0x00010000`) → congela T3 a T5 (T1 y T2 siguen).
5. **Calibración del verificador (T2):** el chequeo nuevo no falla sobre el motor publicado antes de s34c (`git show 8353ae4:docs/index.html`, 7 fuentes con salto) o no pasa sobre `docs/` actual → congela T2 (no se commitea un verificador que no verifica).
6. Hash §8.2 distinto en cualquier build → congela la tarea que lo produjo.
7. **Compuerta visual:** el titular no aprueba en T5 → T5 sin despliegue; se registra lo que pidió.
8. Cualquier 🔒 en FALLA → congela la tarea que lo produjo. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
9. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo y del registro (`chore(encargo): s34d y registro del asistente s34`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- T1: `mkdir -p` y `cp` de `/tmp/s34c_*` (instrumentos: `.js`, `.py`, `.R`, `.sh`; no las salidas ni el banco) a `/Users/tomgc/Projects/slep_idps/_archivo/instrumentos/` (ignorado por git; se verifica con `git check-ignore`).
- T3: `cp` de la gobCL Bold de `~/Library/Fonts` a `/Users/tomgc/Projects/slep_idps/10_utils/fuentes/gobCL_Bold.otf` (nueva carpeta), una vez.
- T5: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, **solo con el "sí" explícito del titular** y K1 a K3 en pasa.
- `git revert <hash>` de un commit propio, si FASE R lo exige. `git clone` en `/tmp/s34d_clon` solo si el build cruza la medianoche.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Temporales en `/tmp/s34d_*`; lectura y copia de `/tmp/s34c_*`. Implícitas: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, ni cambios en la plantilla, el pipeline (pasos 31 a 34 y 36), los datos, `renv.lock` ni `50_documentacion/andamios/diseno/` (congelado).

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `ee77099` (`docs(log): s34c cabecera con logo y fuentes`); árbol: ` M 50_documentacion/andamios/logs/20260926_registro_asistente_s34.md` más este encargo (fuente: `.git/refs` y `GIT_OPTIONAL_LOCKS=0 git status --porcelain`, redactor, 2026-10-07).
- `docs/index.html` = motor = sitio = `fa5bad29ddd94f38a1d11c7821e2bf3c` (fuente: `md5sum` del redactor y `curl` + `md5sum` del sitio, 2026-10-07).
- El motor embebe gobCL 300, 400 y 800 y Museo Sans 100, 300, 500 y 700 desde `font_dir` (`50_documentacion/andamios/diseno/motor_idps/fonts/`, 7 archivos) (fuente: `sed -n '548,575p'` del generador y `ls` de esa carpeta, redactor). La plantilla pide peso 700 (`--fw-bold:700`) en 62 líneas (fuente: `grep -c` del redactor); hoy esa negrita sale en la Heavy (800) porque no hay cara 700 (fuente: log s34c, A-3 y D-2).
- gobCL Bold está instalada en `~/Library/Fonts` de la estación (fuente: log s34c, hallazgo (f) de FASE 0; nombre exacto del archivo: hipótesis, se mide en FASE 0, M3).
- `tests/verificar_motor.R` (108 líneas) no revisa las fuentes; usa `informar(ok, texto)` y cuenta fallas para el código de salida (fuente: `sed -n '80,108p'` y `grep -n` del redactor).
- `/tmp` se vacía entre sesiones: los instrumentos de s34b se perdieron y s34c los reescribió (fuente: log s34c, M3 y D-1). Los de s34c existen hoy en `/tmp/s34c_*` (hipótesis, se mide en FASE 0, M3; si faltan, T1 se registra como "nada que copiar" y sigue).
- `_archivo/` está en `.gitignore` (fuente: `grep -n "_archivo" .gitignore` del redactor, línea 30).

**Decisiones del titular (sesión 34):** D-1 de s34c, (b): los instrumentos de verificación se guardan fuera de `/tmp`, sin versionar (en `_archivo/instrumentos/`). D-2 de s34c, (b): el motor embebe gobCL Bold (700). D-3 de s34c, (a): la cabecera en teléfono queda como está. Y el chequeo de fuentes en el verificador versionado (ruta acordada en la sesión 34), para que el defecto de s34c no vuelva sin que nadie lo note.

## 2. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS a con `HASH_ESPERADO` sin cambios (`git diff <inicio>..HEAD -- tests/verificar_motor.R | grep -c '^[-+]HASH_ESPERADO'` → `0`).
2. **Plantilla, paletas y pipeline intactos:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/36_* 40_salidas/publico 40_salidas/intermedios renv.lock 50_documentacion/andamios/diseno | wc -l` → `0`.
3. **CSV y SVG intactos:** los cinco CSV y los tres SVG normalizados de M6 de s34c, iguales en el motor nuevo.
4. **Sin red:** `src="http`, `href="http` y `text/babel` → `0` (PRUEBAS a).

## 3. Grafo de tareas y ALCANCE

- **T1** (instrumentos fuera de `/tmp`) · ALCANCE: `_archivo/instrumentos/` (ignorado). Independiente.
- **T2** (chequeo de fuentes en el verificador) · ALCANCE: `tests/verificar_motor.R`, `tests/verificar_motor_helpers.R`. Independiente.
- **T3** (gobCL Bold) · ALCANCE: `10_utils/fuentes/gobCL_Bold.otf`, `30_procesamiento/35_generar_motor_html.R` (solo la lista de fuentes y la ruta de cada una). Independiente.
- **T4** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T2 y T3.
- **T5** (compuerta y despliegue) · ALCANCE: `docs/index.html`. Requiere T4 y el "sí" del titular.
- Orden: T1 → T2 → T3 → T4 → T5. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 4. FASE 0

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito **antes** y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; distancias con `origin/main` | `HEAD~1` = `ee77099` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 de `docs/`, motor y plantilla; PRUEBAS a; `ls ~/Library/Fonts \| grep -i gob` con firma y peso (`fc-scan` o `fontTools` si están; si no, `otfinfo`/lectura de la tabla `OS/2` en R); `ls /tmp/s34c_*` por tipo | `fa5bad29…` ×2; `rc=0`; un archivo de gobCL 700 válido; instrumentos presentes (si no, se registra) | regla 3 / regla 4 |
| M4 | Línea base desde `docs/`: los cinco CSV y tres SVG normalizados (con los instrumentos de s34c), K1 (7 caras cargadas) y, en headless, el ancho de un texto fijo en gobCL 700 frente a 800 (`document.fonts.check('700 16px gobCL')` y medida de `canvas.measureText`) | registradas; hoy 700 y 800 miden igual (la 700 cae en la Heavy) | congela T4 |
| M5 | Testigo `s34d: gobCL Bold` | `0` en `docs/` y en el generador | se elige otro |

## 5. Criterios

- **K1 (fuentes):** en el motor nuevo, 8 `@font-face` sin saltos ni espacios en sus `url()`, y las 8 caras `loaded` en headless (gobCL 300/400/700/800, Museo Sans 100/300/500/700).
- **K2 (la negrita es Bold):** un texto fijo en gobCL 700 mide distinto que en 800 (en `docs/` hoy miden igual: caso malo conocido de M4), y la cara de 700 cargada es la del archivo de `10_utils/fuentes/` (md5 del base64 decodificado = md5 del archivo).
- **K3 (nada se rompe):** sin desborde de la página en las siete pantallas a 320, 360, 390 y 1280; filas del modal con desborde a 390: no más que en s34c (0 de 345); R1 con C1, C2 y la ficha en `y=0`; 🔒3; PRUEBAS a y c.
- **K4 (verificador):** `tests/verificar_motor.R` informa una línea `[OK]` o `[FALLA]` de fuentes por archivo; **falla** sobre la copia del motor de `8353ae4` (7 `url()` con salto) y sobre una copia con una fuente cuyo base64 se trunca (firma inválida), y **pasa** sobre `docs/` actual y sobre el motor nuevo; sin imprimir nada del payload.

## 6. Tareas

### T1: instrumentos fuera de `/tmp`

1. `mkdir -p` de `_archivo/instrumentos/s34c/` y `cp` de los instrumentos de `/tmp/s34c_*` (`.js`, `.py`, `.R`, `.sh`), sin salidas, capturas ni el banco. Un `LEEME.md` breve en esa carpeta: qué mide cada uno y qué `NODE_PATH` usan.
2. Verificación: conteo copiado = conteo de origen por extensión; `git check-ignore -v _archivo/instrumentos/s34c/<uno>` → regla de `.gitignore`; `git status --porcelain` sin la carpeta. Sin commit (ignorado).

### T2: chequeo de fuentes en el verificador

1. Paso 0: lee `tests/verificar_motor.R` y `tests/verificar_motor_helpers.R` completos.
2. Edición: en los helpers, `revisar_fuentes(html)`: extrae las reglas `@font-face`, cuenta las `url(data:…)` con espacio o salto dentro, decodifica cada base64 y revisa la firma OpenType; devuelve el total, los defectuosos y la familia y peso de cada uno. En el script, una línea `informar()` por archivo: `fuentes: <n> caras, <k> con salto o espacio, <j> con firma inválida`, que falla si `n = 0`, `k > 0` o `j > 0`. Comentario con el porqué (s34c) y el testigo de M5.
3. Verificación (`esperado:` antes): K4 con sus cuatro casos; PRUEBAS a sobre el árbol (`rc=0`).
4. Commit `test(motor): el verificador revisa las fuentes embebidas (s34d)`.

### T3: gobCL Bold

1. La copia autorizada a `10_utils/fuentes/gobCL_Bold.otf`; md5 igual al de origen.
2. Edición del generador: la entrada `list(fam = "gobCL", w = 700, f = "gobCL_Bold.otf", dir = here::here("10_utils", "fuentes"))` entre la 400 y la 800, y `ruta <- fs::path(if (is.null(ft$dir)) font_dir else ft$dir, ft$f)` con verificación de existencia de cada fuente (`stop()` con la ruta si falta). Comentario con el testigo `s34d: gobCL Bold`.
3. Verificación: build de prueba en un banco `cp -Rc` en `/tmp/s34d_banco`; K1, K2; PRUEBAS a en el banco.
4. Commit `feat(motor): embebe gobCL Bold (700) para las negritas (s34d)`.

### T4: build

`git status --porcelain` → solo el LOG. Build con PRUEBAS b; PRUEBAS a; K1 a K3 sobre `40_salidas/motor_idps.html`; 🔒3, 🔒4; testigo (≥ 1 en el motor, 0 en `docs/`). Material de la compuerta: láminas antes/después (1280 y 390) de la apertura, la ficha y el comparador `m5a`, recortadas a 1.600 px, en `/tmp/s34d_gate/`. Commit `build(motor): s34d gobCL Bold`.

### T5: compuerta y despliegue

1. **Pregunta al titular** (una): "Abre las láminas de `/tmp/s34d_gate/` y `40_salidas/motor_idps.html`. Las negritas en gobCL pasan de la Heavy a la Bold. ¿Apruebas el despliegue?" con "Sí, despliega" / "No, no despliegues (dime qué cambiar)".
2. Con "sí": la copia autorizada; PRUEBAS a con motor = `docs/`; K1 y K2 sobre `docs/`. Commit `deploy(docs): gobCL Bold en las negritas (s34d)`. Con "no": regla 7.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta.

1. **Inventario** derivado del log (`R-01`, …), anexado **antes** de auditar.
2. **Re-derivación independiente:** K1 y K2 en R (decodificar las 8 fuentes y comparar con los archivos; firma); K4 corriendo el verificador desde otro directorio de trabajo; lectura dirigida: ¿el verificador imprime algo del payload o una ruta absoluta? ¿alguna `url(data:` con espacios? Si sí, REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a c.
6. **Control positivo:** el verificador falla sobre la copia de `8353ae4`; K2 da "mismo ancho" sobre `docs/` de FASE 0.
7. **Veredicto por hallazgo:** BLOQUEA / REPARA / ADVIERTE; "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano.
2. Cierre: resumen; commits; auditoría; invariantes; K1 a K4 antes y después; respuesta textual de la compuerta; PRUEBAS a final literal; md5 y testigo; dudas con pregunta cerrada; errores propios; estado de cierre. **Todo resultado se escribe como `obtenido:` al inicio de línea** (no `obtenido (…):`, que el conteo del paso 5 no ve).
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT y de `RBD [0-9]` sobre el LOG → vacío, con control plantado; ningún nombre de establecimiento.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s34d gobCL Bold y verificador"`; luego el push según la autorización.

## 9. Reporte final

- **Primera línea:** `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J tal cual.
- Después: K1 a K4 antes y después; respuesta de la compuerta; salida del push; md5 publicado; PRUEBAS a; "lo que falló o sorprendió; si nada, decirlo".
