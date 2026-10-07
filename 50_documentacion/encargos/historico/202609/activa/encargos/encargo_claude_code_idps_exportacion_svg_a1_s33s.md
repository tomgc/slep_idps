# Encargo autónomo: trazado único de la barra y exportación del comparador en SVG y PNG (s33s, parte A1)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (edición en serie de la plantilla, un build, un despliegue y un push; `encargo_autonomo_claude_code_v1.md` §2.12, filas 2 y 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS. Corre **después** de s33r.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html` (marcadores: `function pctRound`, `function StackedBar`, `.s100-seg`, `.s100-ext`, `_remedirBarras`, `function clonarSvgResuelto`, `function construirSvgRadar`, `const SVG_FUENTE`, `PNG_MAX_SUPERFICIE_PX`, `function rasterizarSvgAPng`, `function descargarComparadorCSV`, `function IconExport`, `cmp-nota-bp`); `50_documentacion/activa/decisiones/20260925_decision_exportacion_imagen.md` (§4, **vinculante**); `…/20260925_decision_base_pequena.md`; `…/20260910_decision_contraste_texto_estado.md` (§3, tokens `-txt`); `50_documentacion/andamios/diseno/detalles/20260924_diagnostico_exportacion_imagen.md` y `mockup_exportacion_imagen_s33m.html` (alternativa A: layout del SVG, corte de líneas por palabras, lección de la nota que pisaba la celda vecina); los logs de s33m, s33o y s33q (instrumentos de barras, capturas AE, impresión, §8.2, red bloqueada).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2; expresiones con `{m,n}` dentro de un script en `/tmp/s33s_*`). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea. Cita clases y textos de **este** motor.
- **LOG:** `50_documentacion/andamios/logs/20260925_exportacion_svg_a1_s33s_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. Este encargo ya está versionado (lo commiteó s33r en su primer commit): `<inicio>` = `HEAD` al abrir, sin commit propio de apertura.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) 0 errores de consola y 0 `pageerror` con los dos modales, una ficha con vista histórica, una comparación de 10 entidades, cada exportación CSV, las dos exportaciones nuevas y un `page.pdf` del comparador, **con la red bloqueada** (instrumento de s33q); (c) hash §8.2 = `eb4e00b3…4dc4`; (d) los cuatro CSV de s33f M6 con los md5 de FASE 0.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ningún color hex nuevo (el SVG resuelve los tokens existentes, como `clonarSvgResuelto`); cada cifra visible nombra su universo; todo texto se verifica también por su efecto en el ancho.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` al abrir con alguna ruta fuera de {el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch`, o el último commit de `main` no es el `docs(log)` de s33r → detén la sesión y pasa a FASE L.
3. Hash §8.2 distinto en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. **Pantalla (T1):** cualquier diferencia de píxeles o de texto entre el motor con el trazado único y `docs/index.html` en las pantallas de 🔒5 → congela T1 y T2 (sin despliegue); la plantilla vuelve a su estado de FASE 0 con una edición inversa y se registra qué difería.
7. **Despliegue (T4):** la regla 6 medida otra vez sobre el motor final falla → no se despliega; congela T4.
8. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- T4: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, solo con la regla 7 superada.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33s_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --` ni cambios en el generador, el pipeline o los datos.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = el `docs(log)` de s33r, que corre justo antes (hipótesis del redactor; se mide en M2). Antes de s33r, `main` = `5b629dd` (fuente: `.git/refs` leídos por el redactor el 2026-09-25).
- Motor y `docs/index.html` = `417acd964a95f3616560a1b46a5ba81f` (fuente: `openssl md5` del redactor); s33r no toca el motor.
- `StackedBar({rep,conN})` dibuja en HTML la barra del comparador, del panorama (vista actual) y de la franja histórica. Decide dentro del componente: anchos con `pctRound`, qué etiquetas "p% (n)" caben dentro midiendo con la fuente efectiva de `.s100-seg span`, la tira externa `.s100-ext` con `.s100-ext-it.ext-bajo/neutro/sobre`, "sin dato", la nota `sin`, `N` y el asterisco de base pequeña (`conN`, solo comparador), los `title` y el `aria-label`. Se re-mide con un `ResizeObserver` compartido (`observar`/`desobservar`) y, al imprimir, con `_remedirBarras` (fuente: `sed` del redactor sobre la plantilla).
- La exportación del radar ya resuelve tokens al clonar (`clonarSvgResuelto`), fija la pila `SVG_FUENTE`, rasteriza con `rasterizarSvgAPng` y avisa cuando el PNG supera `PNG_MAX_SUPERFICIE_PX` (fuente: `sed` del redactor).
- El comparador exporta hoy solo CSV (`descargarComparadorCSV`, nombre `idps_comparador_<nivel>_<año><sufijoGse>.csv` desde s33o) (fuente: log de s33o, T2).

**Decisión que este encargo implementa:** `20260925_decision_exportacion_imagen.md` §4 (trazado único; A1 = comparador; pila del sistema; techo con aviso; nombre del CSV con `.svg`/`.png`; despliegue solo con pantalla idéntica).

## 2. Contexto mínimo

Hoy la imagen solo se exporta del radar. Para exportar el comparador sin crear un segundo dibujo que pueda contar otra cosa que la pantalla, las decisiones de trazado de la barra salen a una función pura que usan la pantalla y el archivo. La pantalla no debe cambiar ni un píxel.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS c.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` = `04b2876e…` (FASE 0); hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **Generador, pipeline y datos intactos:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R 30_procesamiento/36_* 40_salidas/publico | wc -l` → `0`.
4. **Exportaciones CSV intactas:** PRUEBAS d.
5. **La pantalla no cambia:** capturas a 1280 × 800 y a 390 × 800 del comparador (10 entidades, y el comparador de 4° básico 2025 con las cuatro comunas del SLEP Costa Central, el SLEP y una región), del panorama (vista actual e histórica, territorio de apertura y Región de Valparaíso) y de una ficha, idénticas píxel a píxel entre `docs/index.html` (FASE 0) y el motor nuevo; `textContent`, `aria-label` y `title` de cada `.s100-wrap` idénticos.
6. **La impresión no cambia:** `page.pdf` del comparador de 10 entidades con las mismas páginas y el mismo texto que en FASE 0.
7. **Foco y teclado siguen iguales:** los scripts de s33g dan lo mismo que en su log.

## 4. Grafo de tareas y ALCANCE

- **T1** (trazado único) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (exportación del comparador) · ALCANCE: `30_procesamiento/35_motor_template.html`. Requiere T1 completada.
- **T3** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1.
- **T4** (despliegue) · ALCANCE: `docs/index.html`. Requiere T3 y la regla 7 superada.
- Orden: T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain; stash; `git log -1 --format=%s` | vacío (o solo el LOG); vacío; `docs(log): s33r …` | regla 1 o 2 |
| M2 | `fetch`; `HEAD..origin/main`; `origin/main..HEAD`; `git log --oneline -1 -- 50_documentacion/activa/encargos/encargo_claude_code_idps_exportacion_svg_a1_s33s.md` | `0`; `0`; el primer commit de s33r | regla 2 |
| M3 | Instrumentos §8.2, `:root` y red bloqueada (copias de `/tmp/s33*` o reconstruidos desde los logs de s33o y s33q), con calibración; md5 de plantilla, motor y `docs/` | `eb4e00b3…`; `04b2876e…`; motor = `docs/` = `417acd96…` | congela T3 y T4 si la calibración falla |
| M4 | Líneas base desde `docs/index.html`: 🔒5, 🔒6 y 🔒7; PRUEBAS d; y un **inventario de barras**: por cada `.s100-wrap` de las pantallas de 🔒5, anchos de segmento (px), etiquetas dentro, ítems de la tira externa, `N`, nota `sin`, `title` y `aria-label` | registradas | congela T1 |
| M5 | **Caso malo de T2:** en el comparador no hay botón de imagen (texto de la barra de exportación) | solo "Exportar CSV" | regla 8 |
| M6 | Calibración de testigos de despliegue: `s33s: trazado único` y `s33s: exportación del comparador` | `0` en `docs/` y en el motor | se eligen otros y se registran |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: trazado único de la barra

1. Paso 0: relee la decisión §4 y el componente `StackedBar` completo, con su CSS.
2. Extraer a una función pura (propuesta: `trazarBarra({rep, conN, ancho, medir})`, con comentario que cite la decisión y la cadena de M6) **todas** las decisiones que hoy toma `StackedBar`: anchos por `pctRound`, qué etiquetas caben dentro con la regla única de s29 (margen incluido), la tira externa y su orden, "sin dato", la nota `sin`, `N` y el asterisco (`conN`), los `title` y el `aria-label`. `medir(texto, rol)` devuelve el ancho del texto con la fuente del destino; en pantalla, la misma medición que hoy (la fuente efectiva de `.s100-seg span`). `StackedBar` pasa a pintar lo que devuelve `trazarBarra`, con el mismo DOM y las mismas clases que hoy; el `ResizeObserver` y `_remedirBarras` siguen llamando lo mismo.
3. Verificación (`esperado:` antes): 🔒5 (incluido el inventario de M4 idéntico barra por barra), 🔒6, 🔒7, PRUEBAS b. Si algo difiere, regla 6.
4. Commit `refactor(motor): trazado único de la barra apilada, sin cambio en pantalla (s33s T1)`.

### T2: exportación del comparador en SVG y PNG

1. Paso 0: relee el mockup de A y el diagnóstico (corte de líneas; la nota que pisaba la celda vecina).
2. En la barra de exportación del comparador, junto a "Exportar CSV", dos botones con el mismo componente `IconExport` y la misma forma que la ficha ofrece para el radar ("Imagen SVG", "Imagen PNG"), deshabilitados en los mismos casos que el CSV (`sinQueExportar`).
3. Constructor `construirSvgComparador(...)` que recibe **los mismos arreglos que dibuja la pantalla** (regla de fidelidad de s30: entidades, GSE visibles, repartos, filas de establecimiento) y arma: título con nivel, año y universo (como el título de la pantalla); por cada GSE visible, su encabezado y una fila por entidad con su nombre (partido por palabras si no cabe) y cuatro barras **pintadas desde `trazarBarra`** con `medir` sobre `SVG_FUENTE` (canvas `measureText`); las filas de establecimiento con glifo, puntaje y estado (tokens `-txt`); la leyenda de estados; la nota de base pequeña si hay barras marcadas; el pie con fuente y fecha. Colores resueltos desde los tokens (como `clonarSvgResuelto`); `title` en cada segmento. Ningún texto sale de su celda: se mide antes de ubicarlo.
4. PNG con `rasterizarSvgAPng` (mismo techo y mismo aviso). Nombre: el del CSV con `.svg` o `.png`.
5. Verificación (`esperado:` antes): M5 repetido (tres botones); con 10 entidades y con la selección del SLEP Costa Central: el SVG es XML válido; cada cifra de cada barra de la pantalla ("p% (n)", `N`, `+k sin comparación válida`, "sin dato") aparece en el SVG, dentro o en su tira externa (conteo igual al del inventario, aunque cambie cuál va dentro por la fuente distinta); cada nombre de entidad y cada fila de establecimiento presentes; 0 textos fuera de su celda (`getBBox` de cada texto frente a su celda, en Chrome); el SVG abierto como `<img>` en Chrome pinta los colores de estado (píxeles del rojo de "bajo" > 0; control: una copia sin barras da 0); PNG generado con la selección del SLEP; con 10 entidades, si supera el techo, aparece el aviso y no se descarga nada; nombres de archivo con la convención; 🔒5 (la pantalla sigue idéntica, salvo la barra de exportación del comparador, que se mide aparte); PRUEBAS b.
6. Commit `feat(motor): exportación del comparador en SVG y PNG desde el trazado único (s33s T2)`.

### T3: build

1. `git status --porcelain` → solo el LOG o vacío. Build con PRUEBAS a; PRUEBAS b, c y d; 🔒5 a 🔒7 sobre el motor commiteable (en 🔒5, la barra de exportación del comparador queda exceptuada y se registra su diferencia).
2. Testigos de M6 (≥ 1 en el motor, 0 en `docs/`). md5 del motor nuevo. Commit `build(motor): s33s trazado único y exportación del comparador`.

### T4: despliegue

1. Regla 7 sobre el motor final. La copia autorizada. Verificación: md5 de `docs/index.html` = motor; testigos iguales en los dos; §8.2 sobre `docs/`; `docs/` abre con la red bloqueada. Commit `deploy(docs): exportación del comparador en SVG y PNG (s33s)`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada verificación, cada cifra, cada 🔒 con su comando, M3 a M6 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** 🔒5 con otra métrica de píxeles y otra lectura del DOM (el árbol de accesibilidad para `aria-label`); el SVG exportado leído con otra herramienta (`xmllint --noout` y un conteo de textos con `grep`); la fidelidad de cifras recontada desde el payload para 5 barras al azar; y una lectura dirigida: **¿`StackedBar` o el constructor del SVG deciden algo por su cuenta que no venga de `trazarBarra`?** Si lo hacen, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a, b, c y d.
6. **Control positivo:** el motor anterior (`417acd96…`) no ofrece imagen del comparador (M5) y una copia en `/tmp` con un segmento alterado en `trazarBarra` rompe 🔒5.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y, si ya se desplegó, un segundo despliegue solo con la regla 7 superada.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; auditoría; invariantes; md5 y testigos; tamaño del SVG y del PNG de los dos casos; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33s_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el log.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33s exportación del comparador"`; luego el push según la autorización.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida del push; md5 publicado; el SVG y el PNG de la selección del SLEP Costa Central guardados en `/tmp/s33s_muestra/` para que el titular los abra; lo que queda al titular (exportar desde el sitio publicado y abrir el SVG en otro programa); "lo que falló o sorprendió; si nada, decirlo".
