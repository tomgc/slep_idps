# Encargo autónomo: exportación del panorama en SVG y PNG, rótulos compartidos y periodo del contrato (s33t, parte A2)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (edición en serie de la plantilla, un build, un despliegue y un push; `encargo_autonomo_claude_code_v1.md` §2.12, filas 2 y 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html` (marcadores: `function trazarBarra`, `function StackedBar`, `function construirSvgComparador`, `rasterizarSvgAPng`, `SVG_FUENTE`, `function filasPanoramaCSV`, `function descargarPanoramaCSV`, `function descargarHistoricoCSV`, `function PanoramaHistorico`, `.export-bar`, `IconExport`); `50_documentacion/activa/decisiones/20260925_decision_exportacion_imagen.md` (§4, **vinculante**: A2 = franjas por GSE de la vista actual, sin la grilla de tarjetas, y franja de la vista histórica, sin la matriz); `30_procesamiento/36_exponer_contrato_contexto.R`; `50_documentacion/activa/contrato_contexto_v1.md` (§3); el log de s33s (`50_documentacion/andamios/logs/20260925_exportacion_svg_a1_s33s_log.md`: instrumentos de 🔒5, inventario de barras, D-1 a D-5) y el de s33r (D-1 y D-2).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito; los anexos al LOG se escriben desde archivos, nunca con comillas anidadas en un `bash -c`; ningún script se edita mientras corre. `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`), **siempre en modo headless, sin abrir ventanas** (decisión del titular en s33s). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. En código R, rutas con `here::here()`. Cita clases y textos de **este** motor.
- **Convención de pantalla idéntica (D-2 de s33s, adoptada):** captura con `--disable-gpu` y el puntero fuera de la página, página completa hasta 16.384 px y tramos de 8.000 px más arriba; una pantalla pasa si alguna de hasta tres capturas del motor nuevo es idéntica píxel a píxel a alguna de dos capturas de `docs/index.html`; con control positivo (un cambio real plantado se detecta).
- **LOG:** `50_documentacion/andamios/logs/20260925_exportacion_panorama_a2_s33t_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s33t y registro del asistente s33` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) 0 errores de consola y 0 `pageerror`, con la red bloqueada, en: los dos modales, una ficha con vista histórica, el comparador de 10 entidades con sus tres exportaciones, el panorama (vista actual e histórica) con cada exportación y un `page.pdf` del comparador; (c) hash §8.2 = `eb4e00b3…4dc4`; (d) los cuatro CSV de s33f M6 con los md5 de FASE 0; (e) el SVG del comparador de la selección del SLEP Costa Central con el mismo md5 que en FASE 0 (T1 no cambia lo que dibuja).
- **Topes de esfuerzo:** 3 intentos por bug (una diferencia de pantalla por la forma de pintar es bug, con re-verificación completa bajo el mismo criterio; si persiste, regla 5); 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ningún color hex nuevo; cada cifra visible nombra su universo; el constructor de cada imagen recibe **los mismos arreglos que dibuja la pantalla** y pinta las barras **desde `trazarBarra`**, sin decidir nada por su cuenta.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M 50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 distinto en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. **Pantalla:** tras el tope de intentos, alguna pantalla de 🔒5 distinta de `docs/` → congela la tarea que lo produjo y todo lo que dependa de ella (sin despliegue); la plantilla vuelve al último estado verificado con una edición inversa.
6. **Contrato (T3):** el parquet regenerado cambia en algo más que `periodo` y `fecha_calculo` → no se commitea; congela T3.
7. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
8. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo y del registro (fila 13 agregada por el redactor), en un solo commit.
- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- T3: **una** corrida de `run_all(only = 36)` con `IDPS_CONTEXTO_FORZAR=1` en el entorno (mecanismo que T3 crea) y el commit del parquet resultante.
- T5: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, solo con la regla 5 superada sobre el motor final.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33t_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, ni cambios en el generador del motor, el pipeline 31–34 o `20_insumos`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `0e48be9`, el `docs(log)` de s33s (fuente: `.git/refs` leídos por el redactor el 2026-09-25). Motor y `docs/index.html` = `7eda26aed9cac370300bb6a1a28a1b78` (fuente: `openssl md5` del redactor).
- El registro del asistente s33 tiene 13 filas; la 13 la agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- `trazarBarra` decide todo el trazado de la barra; `StackedBar` y `construirSvgComparador` pintan desde ella; el comparador exporta "Exportar CSV", "Imagen SVG" e "Imagen PNG" (fuente: `grep` del redactor sobre la plantilla).
- El panorama, vista actual, exporta solo CSV desde su `.export-bar` junto al segmentador de GSE (no se dibuja en la vista histórica); la vista histórica exporta solo CSV desde la `.export-bar` de `PanoramaHistorico` (fuente: `sed` del redactor).
- La imagen del comparador repite rótulos del marco que la tabla escribe en su JSX ("Entidad", "Grupo socioeconómico", "Establecimiento", "sin clasificar", el "sin dato" de la celda de establecimiento) (fuente: log de s33s, A-1/D-1).
- El productor del contrato lee `Sys.Date()` dos veces (`PERIODO_CORRIDA` y `fecha_calculo`) y no reescribe el parquet si el contenido no cambió; el parquet publicado dice `periodo 2026-07` con `fecha_calculo 2026-09-25`, md5 `e375de305427fbbf667fa34ad5c650f7` (fuente: `grep` y `openssl md5` del redactor; log de s33r, D-1 y D-2).

**Decisiones del titular (sesión 33, criterio delegado):** D-1 de s33s → rótulos del marco en constantes compartidas por pantalla e imagen. D-2 de s33s → convención de pantalla idéntica (arriba). D-3 de s33s → se acepta que la barra de exportación baje una línea a 390 px. D-1 y D-2 de s33r → la fecha se lee una vez y el parquet se regenera una vez para que diga el periodo de hoy. A2 según la decisión §4.

## 2. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS c.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` = `04b2876e…`; hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **Generador, pipeline y datos del motor intactos:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
4. **Exportaciones existentes intactas:** PRUEBAS d y e.
5. **La pantalla no cambia:** con la convención de §0, el comparador (10 entidades y la selección del SLEP Costa Central), el panorama (vista actual e histórica; territorio de apertura y Región de Valparaíso) y una ficha, a 1280 × 800 y 390 × 800, idénticos a `docs/index.html`, **salvo** las dos `.export-bar` del panorama, que se miden aparte; y el inventario de barras de s33s (texto, `aria-label`, `title`, anchos) idéntico.
6. **La impresión no cambia:** `page.pdf` del comparador de 10 entidades con las mismas páginas y el mismo texto que en FASE 0.
7. **El contenido del contrato no cambia:** el parquet sin `periodo` ni `fecha_calculo`, `identical()` antes y después.

## 3. Grafo de tareas y ALCANCE

- **T1** (rótulos compartidos) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (exportación del panorama) · ALCANCE: `30_procesamiento/35_motor_template.html`. Requiere T1 cerrada.
- **T3** (periodo del contrato) · ALCANCE: `30_procesamiento/36_exponer_contrato_contexto.R`, `40_salidas/publico/contexto_idps.parquet`. Independiente.
- **T4** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 o T2 completada.
- **T5** (despliegue) · ALCANCE: `docs/index.html`. Requiere T4 y la regla 5 superada.
- Orden: T1 → T2 → T3 → T4 → T5. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 4. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `0e48be9` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2, `:root`, red bloqueada y pantalla idéntica (copias de `/tmp/s33s_*` o reconstruidos desde su log), con calibración y control positivo; md5 de plantilla, motor y `docs/` | `eb4e00b3…`; `04b2876e…`; motor = `docs/` = `7eda26ae…`; la convención detecta un cambio plantado | congela T4 y T5 |
| M4 | Líneas base desde `docs/`: 🔒5 (capturas e inventario), 🔒6, PRUEBAS d y e (el SVG y el PNG del comparador de la selección del SLEP Costa Central) | registradas | congela T1 y T2 |
| M5 | **Caso malo de T2:** texto de las dos `.export-bar` del panorama | solo "Exportar CSV" en cada una | regla 8 |
| M6 | Parquet: md5; `periodo` y `fecha_calculo` leídos | `e375de30…`; `2026-07` y `2026-09-25` | regla 8 |
| M7 | Testigos de despliegue: `s33t: rótulos compartidos` y `s33t: exportación del panorama` | `0` en `docs/` y en el motor | se eligen otros y se registran |

Último acto: anexar la sección `### FASE 0`.

## 5. Tareas

### T1: rótulos del marco en constantes compartidas

1. Los rótulos que la tabla del comparador escribe en su JSX y que el SVG repite (los de §1, más los que aparezcan al leer los dos lados) pasan a constantes únicas junto a `trazarBarra`, con comentario que cite D-1 de s33s y la cadena de M7; la tabla y `construirSvgComparador` las usan. Los rótulos que T2 necesite del panorama se agregan al mismo lugar en T2.
2. Verificación (`esperado:` antes): 🔒5 completo; PRUEBAS e (el SVG del comparador idéntico byte a byte); PRUEBAS b.
3. Commit `refactor(motor): rótulos del marco compartidos entre la tabla y la imagen del comparador (s33t T1, D-1 de s33s)`.

### T2: exportación del panorama en SVG y PNG

1. **Vista actual:** en su `.export-bar`, junto a "Exportar CSV", "Imagen SVG" e "Imagen PNG" con `IconExport`, deshabilitados en los mismos casos que el CSV. Constructor `construirSvgPanorama(...)` que recibe los mismos `grupos` que dibuja la pantalla y arma: título con territorio, dependencia, nivel y año (como la pantalla); por cada GSE visible, su encabezado y las cuatro barras de indicador pintadas desde `trazarBarra` (con `medir` sobre `SVG_FUENTE`), con los mismos rótulos de indicador; la leyenda de estados; el pie con fuente y fecha. **Sin la grilla de tarjetas.**
2. **Vista histórica:** en la `.export-bar` de `PanoramaHistorico`, los mismos dos botones. Constructor `construirSvgHistorico(...)` que recibe los mismos `grupos`, años e indicador visibles que dibuja la franja y arma, por cada GSE visible, una fila por año con su barra desde `trazarBarra`, con las marcas de año que la pantalla muestra (preliminar, sin medición); leyenda y pie. **Sin la matriz de celdas.**
3. Ambos: colores resueltos desde los tokens; `title` por segmento; ningún texto fuera de su caja (se mide antes de ubicarlo; corte por palabras); PNG con `rasterizarSvgAPng` (mismo techo y mismo aviso); nombre = el del CSV de esa vista con `.svg` o `.png`; rótulos desde las constantes de T1.
4. Verificación (`esperado:` antes): M5 repetido (tres botones en cada vista); para el territorio de apertura, la Región de Valparaíso y el nivel nacional, en las dos vistas: SVG como XML válido; cada cifra de cada barra de la pantalla presente en el SVG (dentro o en la tira externa; conteo igual al del inventario); 0 textos fuera de su caja (`getBBox` en Chrome); colores de estado presentes (píxeles del rojo de "bajo" > 0, con control); PNG generado donde cabe bajo el techo y aviso donde no; nombres con la convención; 🔒5 (las dos `.export-bar` aparte: se registra su alto a 390 y 1280); PRUEBAS b.
5. Commit `feat(motor): exportación del panorama en SVG y PNG desde el trazado único (s33t T2, parte A2)`.

### T3: periodo del contrato

1. En el productor: la fecha de corrida se lee **una vez** (`FECHA_CORRIDA <- Sys.Date()`) y de ella salen `periodo` (`format(FECHA_CORRIDA, "%Y-%m")`) y `fecha_calculo`; y un modo de escritura forzada por la variable de entorno `IDPS_CONTEXTO_FORZAR=1`, que reescribe aunque el contenido no cambie, con `message()` que lo declare. Comentarios que citen el contrato §3 y D-1/D-2 de s33r.
2. La corrida forzada autorizada; después, `run_all(only = 36)` normal dos veces (esperado: sin reescritura, md5 estable).
3. Verificación (`esperado:` antes): `periodo` = `2026-09` y `fecha_calculo` = la fecha de la corrida; 🔒7; filas y columnas iguales; privacidad del parquet (0 RUT); porcelain tras las dos corridas normales = solo lo commiteable.
4. Commits `fix(contexto): la fecha de corrida se lee una vez; escritura forzada por variable de entorno (s33t T3, D-2 de s33r)` y `data(contexto): regenera contexto_idps.parquet con periodo 2026-09, mismo contenido (s33t T3, D-1 de s33r)`.

### T4: build

1. `git status --porcelain` → solo el LOG o vacío. Build con PRUEBAS a; PRUEBAS b, c, d y e; 🔒5 y 🔒6 sobre el motor commiteable.
2. Testigos de M7 (≥ 1 en el motor, 0 en `docs/`). md5 del motor nuevo. Commit `build(motor): s33t exportación del panorama`.

### T5: despliegue

1. Regla 5 sobre el motor final. La copia autorizada. Verificación: md5 de `docs/index.html` = motor; testigos iguales; §8.2 sobre `docs/`; `docs/` abre con la red bloqueada. Commit `deploy(docs): exportación del panorama en SVG y PNG (s33t)`.

## 6. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada verificación, cada cifra, cada 🔒, M3 a M7 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** 🔒5 con otra lectura (árbol de accesibilidad y otra métrica de píxeles); los SVG con `xmllint --noout` y un conteo de textos; las cifras de 5 barras al azar de cada vista recontadas desde el payload; el parquet con `nanoparquet` o `arrow::read_parquet(..., as_data_frame = FALSE)`; y una lectura dirigida: **¿algún constructor o `StackedBar` decide algo que no venga de `trazarBarra`, o escribe un rótulo que no venga de las constantes de T1?** Si lo hace, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a e.
6. **Control positivo:** el motor anterior (`7eda26ae…`) no ofrece imagen del panorama (M5); una copia en `/tmp` con un segmento alterado en `trazarBarra` rompe 🔒5.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y, si ya se desplegó, un segundo despliegue solo con la regla 5 superada.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 7. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; auditoría; invariantes; md5 y testigos; tamaño de cada SVG y PNG de muestra; `periodo` y md5 del parquet antes y después; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33t_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el log; ninguna fila del parquet.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33t exportación del panorama"`; luego el push según la autorización.

## 8. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida del push; md5 publicado; muestras (SVG y PNG de las dos vistas para el SLEP Costa Central) en `/tmp/s33t_muestra/`; `periodo` del parquet; lo que queda al titular; "lo que falló o sorprendió; si nada, decirlo".
