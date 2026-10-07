# Encargo autónomo: logo del servicio en la cabecera (opción C) y tipografías que por fin cargan (s34c)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (`encargo_autonomo_claude_code_v1.md` §2.12, filas 1 y 2: cadena en serie que termina en despliegue).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_generar_motor_html.R` (marcadores: `fonts_css <- vapply(fuentes, function(ft) {`, `b64 <- jsonlite::base64_enc(readBin(ruta, "raw", n = file.info(ruta)$size))`, `json_b64  <- gsub("\n", "", jsonlite::base64_enc(json_gzip), fixed = TRUE)`, `for (ph in c("__FONTS_CSS__", "__D3_INLINE__", "__PAKO_INLINE__", "__JSON_DATA__",`, `reemplazar_literal <- function(texto, marcador, valor) {`, `html <- sub("__FONTS_CSS__",   fonts_css, plantilla, fixed = TRUE)`); `30_procesamiento/35_motor_template.html` (marcadores: `header.app{background:var(--azul);`, `.app-header-inner{max-width:1200px;margin:0 auto;}`, `<div class="app-header-inner">`, `<h1 class="app-title">Motor IDPS`, `<p class="app-desc">`, `@media print{`, `.check-row{`, `.check-name{`); `10_utils/logo_slep_cc_crema.png` (nuevo, sin commitear: 418 × 192 px RGBA); `tests/verificar_motor.R`; los instrumentos de s34b en `/tmp/s34b_*` (`s34b_atras.js`, `s34b_resumen.py`, `s34b_tabla.py`, `s34b_csv*`, `s34b_svg*`, `s34b_pansvg*`, `s34b_svgmd5.sh`, `s34b_pant7.js`).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps` en los comandos; ningún comando asume `cd`. **En el código R, rutas con `here::here()`, nunca absolutas.** `bash` explícito; los anexos al LOG se escriben desde archivos; ningún script se edita mientras corre. Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`) **siempre headless** con `--disable-gpu`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Si el build cruza la medianoche, la prueba de build corre en un clon (`/tmp/s34c_clon`). Ningún shell en segundo plano queda corriendo al terminar.
- **Pantalla:** este encargo **cambia la pantalla a propósito** (cabecera y tipografía de todo el motor): la convención de pantalla idéntica no aplica; la reemplaza la **compuerta visual del titular** de T4.
- **LOG:** `50_documentacion/andamios/logs/20261007_cabecera_logo_fuentes_s34c_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s34c` es `<inicio>`.
- **PRUEBAS:** (a) `Rscript /Users/tomgc/Projects/slep_idps/tests/verificar_motor.R; echo "rc=$?"` → `rc=0` (hash §8.2 `eb4e00b3…4dc4`, 16/16 celdas ancla, red 0); (b) build `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all(only = 35L)'` con exit 0 y 0 warnings; (c) 0 errores de consola y 0 `pageerror` en todos los recorridos del encargo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ningún color hex nuevo (el borde del divisor es `--cream` con transparencia, escrito como `rgba(255,246,224,.22)`, y se declara); la plantilla no gana peticiones de red. El LOG no lleva RBD ni nombres de establecimiento.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, `50_documentacion/andamios/logs/20260926_registro_asistente_s34.md`, `10_utils/logo_slep_cc_crema.png`} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. md5 de `docs/index.html` distinto de `e21ea75c881dba2c3f3fd8067c5fc469`, o md5 del logo distinto de `e81487b0b2d4fbfc3679f1d646f649e2`, en FASE 0 → detén la sesión y pasa a FASE L.
4. **Calibración:** K1 no da "7 fuentes con salto de línea" y "gobCL sin cargar" sobre `docs/index.html` (caso malo conocido) → congela T1 a T4.
5. Hash §8.2 distinto en cualquier build → congela la tarea que lo produjo.
6. K1, K2 o K3 en falla sobre el motor nuevo tras el tope de 3 intentos → congela T3 y T4; las ediciones vuelven al estado de `<inicio>` con `git revert` de sus commits.
7. **Compuerta visual:** el titular no aprueba en T4 → T4 congelada (sin despliegue); se registra lo que pidió cambiar.
8. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
9. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
10. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo, del registro y del logo (`chore(encargo): s34c, registro del asistente s34 y logo de cabecera`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- T4: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, **solo con el "sí" explícito del titular** en la compuerta visual y K1 a K3 en pasa sobre el motor final.
- `git revert <hash>` de un commit propio, si la regla 6 o FASE R lo exigen.
- `git clone` del repo en `/tmp/s34c_clon`, solo si el build cruza la medianoche.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s34c_*`; lectura y copia de `/tmp/s34b_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, ni cambios en el pipeline (pasos 31 a 34 y 36), los datos, `tests/` o `renv.lock`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `90aa5e1` (`docs(registro): errores del asistente s34, filas 2 a 4`); árbol: ` M 50_documentacion/andamios/logs/20260926_registro_asistente_s34.md` y `?? 10_utils/logo_slep_cc_crema.png`, más este encargo (fuente: `.git/refs` y `GIT_OPTIONAL_LOCKS=0 git status --porcelain`, redactor, 2026-10-07).
- `docs/index.html` = motor = sitio en línea = `e21ea75c881dba2c3f3fd8067c5fc469`; plantilla `e71a8b8e4bbc501268278bbe582d5627` (fuente: `md5sum` del redactor; el sitio, con `curl` el 2026-09-26 tras el push de s34b).
- **Defecto de tipografía (hallazgo del redactor):** las 7 fuentes embebidas (gobCL 300/400/800, Museo Sans 100/300/500/700) llevan saltos de línea dentro de `url(data:font/otf;base64,…)`; un `url()` sin comillas no admite espacios, el navegador descarta la regla y **el motor publicado nunca cargó gobCL ni Museo Sans**: muestra la letra del sistema (fuente: script del redactor sobre `docs/index.html`, "fuentes 7, con salto de línea 7"; Chromium headless: `document.fonts.load('800 40px gobCL')` → `[]` sobre `docs/` y `["gobCL loaded"]` sobre una copia con los saltos quitados). Causa: `35_generar_motor_html.R` L565 usa `jsonlite::base64_enc()` sin quitar los saltos, a diferencia de L543 (el dato), que sí los quita (fuente: `sed -n '550,570p'` del redactor).
- **Logo:** `10_utils/logo_slep_cc_crema.png` (418 × 192 px, RGBA, md5 `e81487b0b2d4fbfc3679f1d646f649e2`) es el logo oficial `50_documentacion/suite/assets/logo-color-stacked.png` recortado (sin la línea de comunas), con las letras pasadas al color `--cream` (`#FFF6E0`) y las C de colores intactas (fuente: preparado por el redactor y verificado píxel a píxel contra su copia, 0 píxeles distintos).
- La cabecera hoy es `header.app` > `.app-header-inner` con `h1.app-title`, `p.app-eyebrow` y `p.app-desc`, sin imagen (fuente: `sed -n '805,818p'` del redactor). Las filas del modal usan `.check-row`, `.check-name` y `.check-region` (L221, L229, L230) (fuente: `grep -n` del redactor).

**Decisiones del titular (sesión 34, sobre maquetas):** opción **C** ("columna con divisor"), con el **logo oficial** (no la recreación en gobCL). Especificación, tal como se aprobó en la maqueta:
- Escritorio: la cabecera es una fila: a la izquierda el texto actual sin cambios (en un contenedor nuevo `.app-header-texto`, `flex:1 1 auto;min-width:0`); a la derecha `.app-marca` (`flex:0 0 auto;padding-left:44px;border-left:1px solid rgba(255,246,224,.22);display:flex;flex-direction:column;justify-content:center`), con el logo (`width:196px;height:auto;display:block`) y debajo `.app-marca-area` "Área de Monitoreo" (`margin-top:12px;font-family:var(--font-display);font-weight:var(--fw-heavy);font-size:16px;color:var(--cream);white-space:nowrap`). `.app-header-inner` gana `display:flex;align-items:stretch;gap:44px` y conserva su `max-width` y `margin`.
- Hasta 720 px de ancho: `.app-header-inner{flex-direction:column;gap:20px}`, `.app-marca{order:-1;padding:0;border:0}` (el logo sube sobre el título), logo de 150 px, `.app-marca-area{font-size:13px;margin-top:8px}`.
- Accesibilidad: `.app-marca` con `role="img"` y `aria-label="Servicio Local de Educación Pública Costa Central, Área de Monitoreo"`; el `<img>` con `alt=""` y `width="196" height="90"`.
- El logo viaja dentro del motor: la plantilla lleva `src="data:image/png;base64,__LOGO_CABECERA__"` y el generador reemplaza el marcador con el base64 **sin saltos de línea** de `10_utils/logo_slep_cc_crema.png` (ruta con `here::here()`, existencia verificada como las demás).

## 2. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS a, `rc=0`, `HASH_ESPERADO` sin cambios (`git diff <inicio>..HEAD -- tests | wc -l` → `0`).
2. **Paletas intactas y sin hex nuevo:** md5 del bloque `:root{…}` igual al de FASE 0 (`04b2876e…`); hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **Pipeline y datos intactos:** `git diff <inicio>..HEAD -- 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/36_* 40_salidas/publico 40_salidas/intermedios renv.lock tests | wc -l` → `0`. En `30_procesamiento/35_generar_motor_html.R` solo cambian el bloque de fuentes (T1) y el marcador del logo (T2): el `git diff` de ese archivo se explica línea a línea en el LOG.
4. **CSV intactos:** los cuatro CSV de la línea base de s34b (comparador m5a, ficha, panorama, histórico), byte a byte iguales a los de `docs/` de FASE 0.
5. **Sin red:** `src="http`, `href="http` y `text/babel` → `0` en el motor (también lo mide PRUEBAS a).

## 3. Grafo de tareas y ALCANCE

- **T1** (las fuentes cargan) · ALCANCE: `30_procesamiento/35_generar_motor_html.R`. Independiente.
- **T2** (logo en la cabecera, opción C) · ALCANCE: `30_procesamiento/35_motor_template.html` y `30_procesamiento/35_generar_motor_html.R` (solo el marcador del logo). Requiere T1 completada (comparten archivo).
- **T3** (build y verificación) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 y T2.
- **T4** (compuerta visual y despliegue) · ALCANCE: `docs/index.html`. Requiere T3 y el "sí" del titular.
- Orden: T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 4. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado (encargo, registro y logo). Segundo acto: crear el LOG (`mkdir -p`; encabezado; slot `## J. Juicio (lo rellena FASE L)`; esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo, el registro y el logo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `90aa5e1` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 de `docs/`, motor, plantilla y logo; dimensiones del logo; PRUEBAS a; `:root`; instrumentos de s34b presentes; Puppeteer y Chrome | `e21ea75c…` ×2, `e71a8b8e…`, `e81487b0…`; 418 × 192; `rc=0`; registrado; sí | regla 3 / congela T3 |
| M4 | **Caso malo de K1 sobre `docs/`:** data URIs de fuentes con salto de línea (conteo con R o con un script que lea el archivo); en headless, `await document.fonts.load('800 40px gobCL')` y `('500 16px "Museo Sans"')` | `7` con salto; `[]` y `[]` | regla 4 |
| M5 | **Caso bueno de K1:** una copia de `docs/` en `/tmp/s34c_*` con los saltos quitados solo dentro de esos 7 `url()` | `0` con salto; `["gobCL loaded"]` y `["Museo Sans loaded"]` | regla 4 |
| M6 | Líneas base desde `docs/`: los cuatro CSV de 🔒4; los tres SVG normalizados de s34b (comparador m5a, panorama actual e histórico); `.check-row` del modal (pestaña Comuna, SLEP Costa Central) con `scrollWidth > clientWidth` a 390 px; desborde horizontal de la página (`scrollingElement.scrollWidth > innerWidth`) en las 7 pantallas de s34b a 320, 360, 390 y 1280 | registradas | congela T3 |
| M7 | Testigo `s34c: cabecera con logo` | `0` en `docs/` y en la plantilla | se elige otro y se registra |

Último acto: anexar la sección `### FASE 0`.

## 5. Criterios (definidos antes de codificar; K1 calibrado en M4 y M5)

- **K1 (las fuentes cargan):** en el motor nuevo, 0 data URIs de fuentes con salto de línea, y en headless `document.fonts.load` devuelve cargadas las 7 combinaciones familia/peso del generador; `getComputedStyle` de `.app-title` sigue declarando `gobCL` primero.
- **K2 (la cabecera es la aprobada):** `__LOGO_CABECERA__` aparece 0 veces en el motor; el `<img>` de `.app-marca` carga (`complete` y `naturalWidth` 418, `naturalHeight` 192) y su base64 decodificado tiene el mismo md5 que `10_utils/logo_slep_cc_crema.png`; a 1280 px, `.app-marca` queda a la derecha del texto (`marca.left ≥ texto.right`), con borde izquierdo de 1 px, el logo a 196 px y "Área de Monitoreo" en una línea; a 390 px, `.app-marca` queda sobre el título (`marca.bottom ≤ h1.top`), sin borde, con el logo a 150 px; `.app-marca` tiene `role="img"` y el `aria-label` de §1.
- **K3 (nada se rompe):** sin desborde horizontal de la página en las 7 pantallas a 320, 360, 390 y 1280; `.check-row` con desborde a 390: no más que en M6; PRUEBAS a y c; 🔒4; en R1 de s34b (clic, 1280 y 390) C1 y C2 pasan y la ficha abre en `y=0`.
- **Informativo (no congela, va a la compuerta y al LOG):** los tres SVG exportados frente a M6 (si difieren, cuántas líneas y de qué tipo: la tipografía de la página puede cambiar mediciones); C3 de s34b por la letra; altura de la cabecera antes y después a 1280 y 390; impresión (PDF de `page.pdf` A4 horizontal de la cabecera y el comparador).

## 6. Tareas

### T1: las fuentes cargan

1. Paso 0: relee L550-570 y L543 del generador.
2. Edición: en el bloque de fuentes, el base64 sin saltos de línea, con la misma forma de L543 (`gsub("\n", "", jsonlite::base64_enc(…), fixed = TRUE)`); comentario breve con el porqué (un `url()` sin comillas no admite espacios; el navegador descartaba las 7 reglas desde el origen del motor).
3. Verificación (`esperado:` antes): build de prueba en `/tmp/s34c_*` (copia APFS `cp -Rc` del repo, como s34b) con PRUEBAS b; K1 sobre ese motor; PRUEBAS a sobre él.
4. Commit `fix(motor): las fuentes de marca cargan (base64 sin saltos de línea en @font-face) (s34c)`.

### T2: logo en la cabecera (opción C)

1. Paso 0: relee la cabecera (L78-87 y L805-818) y `@media print{`.
2. Edición de la plantilla según §1 (CSS junto a las reglas de la cabecera, con el testigo de M7 en un comentario; marcado con `.app-header-texto` y `.app-marca`); en el generador, el marcador `__LOGO_CABECERA__` entra en la lista de marcadores que se verifican y se reemplaza con `reemplazar_literal()` por el base64 sin saltos del logo, leído con `here::here("10_utils", "logo_slep_cc_crema.png")` y con verificación de existencia.
3. Verificación (`esperado:` antes): build de prueba en el banco; K1, K2 y K3 sobre ese motor; 🔒2.
4. Commit `feat(motor): logo del servicio y Área de Monitoreo en la cabecera (opción C) (s34c)`.

### T3: build y verificación

1. `git status --porcelain` → solo el LOG o vacío. Build con PRUEBAS b (en clon si pasó la medianoche); PRUEBAS a; K1, K2 y K3 sobre `40_salidas/motor_idps.html`; 🔒4 y 🔒5; los informativos de §5; testigo (≥ 1 en el motor, 0 en `docs/`); md5 del motor nuevo.
2. **Material de la compuerta:** capturas headless del motor nuevo y de `docs/` (las 7 pantallas de s34b, a 1280 y 390, solo la parte superior: hasta 1.600 px) en `/tmp/s34c_gate/`, nombradas `<pantalla>_<ancho>_{antes,despues}.png`, y una lámina comparativa de la cabecera (antes arriba, después abajo, 1280 y 390) en `/tmp/s34c_gate/cabecera_antes_despues.png`.
3. Commit `build(motor): s34c cabecera con logo y fuentes de marca`.

### T4: compuerta visual y despliegue

1. **Pregunta al titular** (una sola, con las rutas): "Abre `/tmp/s34c_gate/cabecera_antes_despues.png` y `/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html` en el navegador (escritorio y ventana angosta). Cambian la cabecera y la tipografía de todo el motor (ahora carga gobCL y Museo Sans). ¿Apruebas el despliegue?" con las opciones "Sí, despliega" / "No, no despliegues (dime qué cambiar)". Mientras espera, nada se toca.
2. Con "sí": la copia autorizada; verificación: PRUEBAS a con motor = `docs/`; testigo igual en los dos; K1 y K2 sobre `docs/index.html`. Commit `deploy(docs): cabecera con logo del servicio y fuentes de marca (s34c)`.
3. Con "no": regla 7; se registra textual lo que el titular pidió cambiar.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada verificación, cada cifra, cada 🔒, M1 a M7, K1 a K3 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** K1 con otro método (en R: leer el motor, extraer los `@font-face`, contar saltos dentro de `url()` y decodificar cada base64 a un archivo cuya firma sea `OTTO`); K2 con otro método (decodificar el `src` del `<img>` en R y comparar md5 con el archivo de `10_utils/`; posiciones de `.app-marca` re-medidas con otro script); y una lectura dirigida: **¿queda algún `url(data:` en el motor con espacios o saltos dentro, o algún marcador `__…__` sin reemplazar?** Si lo hay, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a c.
6. **Control positivo:** K1 sobre la copia de `docs/` de FASE 0 debe fallar; K2 sobre una copia del motor nuevo con el marcador sin reemplazar debe fallar.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y, si ya se desplegó, un segundo despliegue solo con un nuevo "sí" del titular.
9. **Prohibido:** ajustar un criterio o un esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits (`git log <inicio>..HEAD --oneline`); auditoría; invariantes; K1 a K3 antes (`docs/` de FASE 0) y después; informativos (SVG, C3, alturas, impresión); respuesta textual del titular en la compuerta; salida literal de PRUEBAS a final; md5 y testigo; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: `grep -nE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]' <LOG>` → vacío, con control plantado en una copia en `/tmp`; `grep -nE 'RBD [0-9]' <LOG>` → vacío; ningún nombre de establecimiento (chequeo de s34b, paso 4 de FASE L).
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>` = fases ejecutadas; `grep -c '^esperado:' <LOG>` = `grep -c '^obtenido:' <LOG>`; `grep -c '^## J' <LOG>` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s34c cabecera con logo y fuentes"`; luego el push según la autorización (si el clasificador lo deniega, queda para el titular y se dice en el reporte).

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: K1 a K3 antes y después; la respuesta de la compuerta; salida del push; md5 publicado; salida de PRUEBAS a; "lo que falló o sorprendió; si nada, decirlo".
