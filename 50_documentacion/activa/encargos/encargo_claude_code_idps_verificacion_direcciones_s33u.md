# Encargo autónomo: verificación versionada del motor y vistas con dirección propia (s33u)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (`encargo_autonomo_claude_code_v1.md` §2.12, filas 2 y 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html` (marcadores: `const PANTALLAS`, `const [pantalla,setPantalla]`, `className="screen-tabs"`, `const irFicha`, `setPantalla(`); `30_procesamiento/35_generar_motor_html.R` (bloque del payload: `memCompress(…, type = "gzip")` y `jsonlite::base64_enc`); `40_salidas/intermedios/idps_largo.parquet`; `tests/` (hoy solo `.gitkeep`); la convención §8.2 escrita en `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` (§8.2: descomprimir, sustituir `"fecha_generacion":"AAAA-MM-DD"` por `"fecha_generacion":"0000-00-00"`, SHA-256 en UTF-8 sin salto final); los logs de s33s y s33t (instrumentos de pantalla idéntica y red bloqueada). **Referencias de los hermanos, solo lectura:** `/Users/tomgc/Projects/slep_categoria_desempeno/tests/spot_check_publicado.R` (cómo extrae y descomprime el JSON del HTML publicado en R y compara celdas ancla) y `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html` (marcador `vistaDesdeDireccion`: la vista la fija `#panorama`/`#comparacion` y se escucha `hashchange`).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps` en los comandos; ningún comando asume `cd`. **En el código R versionado, rutas con `here::here()`, nunca absolutas.** `bash` explícito; los anexos al LOG se escriben desde archivos; ningún script se edita mientras corre. Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`) **siempre headless**. En los hermanos, solo lectura y git con `GIT_OPTIONAL_LOCKS=0`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **Convención de pantalla idéntica (D-2 de s33s y s33t, adoptada):** captura con `--disable-gpu` y el puntero fuera de la página; página completa hasta 16.384 px y tramos de 8.000 px más arriba; una pantalla pasa si alguna de hasta tres capturas del motor nuevo es idéntica píxel a píxel a alguna de dos capturas de `docs/index.html`; la corrida completa admite un reintento; con control positivo.
- **LOG:** `50_documentacion/andamios/logs/20260925_verificacion_direcciones_s33u_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s33u` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado hasta T1):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) 0 errores de consola y 0 `pageerror`, con la red bloqueada, en los dos modales, una ficha con vista histórica, el comparador de 10 entidades con sus exportaciones y el panorama en sus dos vistas con sus exportaciones; (c) hash §8.2 = `eb4e00b3…4dc4`; (d) los cuatro CSV de s33f M6 con los md5 de FASE 0. **Desde T1, (c) se mide también con el script versionado.**
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ningún color hex nuevo; R moderno (pipe nativo `|>`, `dplyr` con `.by=` si hace falta agrupar).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. **Calibración de T1:** el script versionado no reproduce `eb4e00b3…4dc4` sobre `docs/index.html`, o no detecta un caso plantado (fecha alterada → mismo hash; una cifra alterada → hash distinto y celda ancla en falla) → congela T1 (no se commitea un verificador que no verifica).
4. Hash §8.2 distinto en cualquier build → congela la tarea que lo produjo.
5. **Pantalla:** tras el tope de intentos, alguna pantalla de 🔒4 distinta de `docs/` → congela T2 y todo lo que dependa de ella (sin despliegue); la plantilla vuelve a su estado de FASE 0 con una edición inversa.
6. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
7. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
8. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33u`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- T5: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, solo con la regla 5 superada sobre el motor final.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33u_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, ni cambios en el generador, el pipeline, los datos o `renv.lock`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `25890f0` (fuente: `.git/refs` leídos por el redactor el 2026-09-25). Motor y `docs/index.html` = `b3daf503514a49b56426339e75fb7d82`, y el sitio en línea sirve el mismo archivo (fuente: `openssl md5` y `curl` del redactor).
- `tests/` solo tiene `.gitkeep`; la verificación del payload se rehace en cada encargo con instrumentos en `/tmp` (fuente: `ls` del redactor; matriz de s33n, fila 19 y §5.5).
- El payload del motor es JSON comprimido con `memCompress(…, type = "gzip")` y codificado con `jsonlite::base64_enc`, en el placeholder `__JSON_DATA__`; el navegador lo abre con `pako.inflate(atob(…))` (fuente: `grep` del redactor sobre el generador y la plantilla). Categoría lo descomprime en R con `memDecompress(jsonlite::base64_dec(b64), type = "gzip")` (fuente: `grep` del redactor sobre su `tests/spot_check_publicado.R`).
- La pantalla activa vive en el estado `pantalla` (`"territorio"`, `"ficha"`, `"comparar"`, en `const PANTALLAS`), cambia con los botones `.screen-tab` y con `setPantalla` en varios recorridos (`irFicha`, la búsqueda, el botón "Ir a Panorama territorial"); la plantilla no lee ni escribe la dirección (`location.hash|hashchange|pushState|replaceState` → 0) (fuente: `grep` del redactor).

**Decisiones del titular (sesión 33, criterio delegado; adopciones §5.2 y §5.5 de la matriz de s33n):**
- **Verificación versionada:** un script R en `tests/` que cualquiera corre con `Rscript tests/verificar_motor.R` y que falla con código de salida distinto de 0 si algo no cuadra. Verifica: (i) hash §8.2 del payload de `docs/index.html` y de `40_salidas/motor_idps.html` contra el valor esperado escrito en el propio script; (ii) celdas ancla del payload frente a `idps_largo.parquet`; (iii) que el motor no pide nada a la red; (iv) si el motor y `docs/` son el mismo archivo (informativo: antes de desplegar difieren a propósito). Las celdas ancla se **eligen por una regla determinista** (por ejemplo, orden y semilla fijos), no por RBD escritos en el código, y el script no imprime RBD ni nombres de establecimiento.
- **Vistas con dirección propia:** `#panorama`, `#ficha` y `#comparador` (nombres para el usuario; en el código siguen las claves `territorio`, `ficha`, `comparar`). Abrir con una de ellas abre esa vista; cambiar de vista por cualquier camino actualiza la dirección y deja una entrada en el historial, de modo que Atrás y Adelante recorren las vistas; una dirección vacía o desconocida abre el panorama **sin escribir nada en la dirección** (abrir la página como hoy se ve exactamente igual). La dirección lleva solo la vista, no la selección (territorio, establecimiento, entidades): eso queda fuera de este encargo.

## 2. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS c.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` = `04b2876e…`; hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **Generador, pipeline y datos intactos:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R 30_procesamiento/36_* 40_salidas/publico 40_salidas/intermedios renv.lock | wc -l` → `0`.
4. **La pantalla no cambia:** con la convención de §0, las pantallas de s33t (comparador de 10 entidades y selección del SLEP Costa Central, panorama en sus dos vistas para el territorio de apertura y la Región de Valparaíso, una ficha) a 1280 × 800 y 390 × 800, llegando a cada una **por los mismos clics que en FASE 0**, idénticas a `docs/index.html`; y el inventario de barras idéntico.
5. **Exportaciones intactas:** PRUEBAS d y los md5 del SVG del comparador y de los dos del panorama para el SLEP Costa Central (medidos en FASE 0).
6. **Foco y teclado siguen iguales:** los scripts de s33g dan lo mismo que en su log.

## 3. Grafo de tareas y ALCANCE

- **T1** (verificador versionado) · ALCANCE: `tests/verificar_motor.R` (y, si hace falta separar funciones, `tests/verificar_motor_helpers.R`). Independiente.
- **T2** (vistas con dirección propia) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente de T1.
- **T3** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T2 completada.
- **T4** (despliegue) · ALCANCE: `docs/index.html`. Requiere T3 y la regla 5 superada.
- Orden: T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 4. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `25890f0` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2 (el de `/tmp` de s33t), `:root`, red bloqueada y pantalla idéntica, con calibración y control positivo; md5 de plantilla, motor y `docs/` | `eb4e00b3…`; `04b2876e…`; motor = `docs/` = `b3daf503…` | congela T3 y T4 |
| M4 | Líneas base desde `docs/`: 🔒4 (capturas e inventario), 🔒5 y 🔒6 | registradas | congela T2 |
| M5 | **Casos malos de T2:** abrir `docs/index.html#comparador` y `#ficha`; cambiar de vista con clic y leer `location.hash`; `history.back()` | abre el panorama en los dos casos; `location.hash` vacío; Atrás no vuelve a la vista anterior | regla 8 |
| M6 | En R, con la biblioteca del proyecto: `requireNamespace` de `jsonlite`, `arrow`, `openssl` (o `digest`) y `here` | `TRUE` los cuatro | congela T1 (no se instala nada) |
| M7 | Testigo de despliegue: `s33u: vistas con dirección` | `0` en `docs/` y en el motor | se elige otro y se registra |

Último acto: anexar la sección `### FASE 0`.

## 5. Tareas

### T1: verificador versionado del motor

1. Paso 0: lee la convención §8.2 del log de s29 y el `spot_check_publicado.R` de Categoría (como referencia de método, no para copiarlo: aquí el dato es `idps_largo.parquet` y la unidad es el establecimiento por indicador, año y nivel).
2. Escribe `tests/verificar_motor.R` (cabecera con propósito, uso, qué verifica y qué no; `here::here()` para toda ruta; sin rutas absolutas): extrae `__JSON_DATA__` ya reemplazado de cada HTML, descomprime, aplica §8.2 y compara con `HASH_ESPERADO <- "eb4e00b3…"` (el valor completo, escrito una sola vez); elige al menos 12 celdas ancla por una regla determinista que cubra los dos niveles, al menos tres años, los cuatro indicadores y al menos una celda con `sigdifgru` nulo, y compara puntaje, `difgru` y `sigdifgru` del payload con el parquet; cuenta `src="http`, `href="http` y `text/babel` en cada HTML (esperado 0); informa si motor y `docs/` son idénticos. Sale con `quit(status = 1)` ante cualquier falla, con un resumen de una línea por verificación, **sin imprimir RBD ni nombres**.
3. Verificación (`esperado:` antes): sobre el estado actual, todo pasa y el hash coincide con el instrumento de `/tmp` (M3); **controles plantados** en copias en `/tmp` (regla 3): fecha alterada → pasa; una cifra alterada en el JSON → falla el hash y la celda ancla correspondiente; una etiqueta `<script src="https://…">` agregada → falla la red. El script se corre también desde otro directorio de trabajo (prueba de `here::here()`).
4. Commit `test(motor): verificador versionado del payload, celdas ancla y red (s33u T1, matriz s33n §5.5)`.

### T2: vistas con dirección propia

1. Paso 0: relee el mecanismo del hermano (solo el principio: la dirección fija la vista y se escucha `hashchange`) y localiza **todos** los `setPantalla(` de la plantilla.
2. Edición: un mapa único clave ↔ dirección (`territorio` ↔ `#panorama`, `ficha` ↔ `#ficha`, `comparar` ↔ `#comparador`); el estado inicial de `pantalla` sale de la dirección (desconocida o vacía → `territorio`, sin escribir); todo cambio de `pantalla` (botones y recorridos) escribe la dirección con una entrada nueva en el historial solo si difiere de la actual; un `hashchange` (Atrás, Adelante, un enlace) fija la pantalla sin volver a escribir la dirección. Comentario con la cadena de M7.
3. Verificación (`esperado:` antes): M5 repetido: `#comparador` y `#ficha` abren su vista; un clic cambia `location.hash`; Atrás y Adelante recorren las vistas; `#xyz` y la dirección vacía abren el panorama con `location.hash` vacío; ir a la ficha desde una tarjeta del panorama deja `#ficha` y Atrás vuelve al panorama con el territorio que tenía; 🔒4 (llegando por clics, como en FASE 0); 🔒5; 🔒6; PRUEBAS b.
4. Commit `feat(motor): la vista activa se refleja en la dirección (#panorama, #ficha, #comparador) (s33u T2, matriz s33n §5.2)`.

### T3: build

1. `git status --porcelain` → solo el LOG o vacío. Build con PRUEBAS a; PRUEBAS b, c y d; **`Rscript tests/verificar_motor.R` sobre el motor nuevo** (el hash debe coincidir; la comparación motor = `docs/` informa "distintos", como corresponde antes de desplegar); 🔒4 a 🔒6.
2. Testigo de M7 (≥ 1 en el motor, 0 en `docs/`). md5 del motor nuevo. Commit `build(motor): s33u vistas con dirección`.

### T4: despliegue

1. Regla 5 sobre el motor final. La copia autorizada. Verificación: `Rscript tests/verificar_motor.R` pasa entero, ahora con motor = `docs/`; testigo igual en los dos. Commit `deploy(docs): vistas con dirección propia (s33u)`.

## 6. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada verificación, cada cifra, cada 🔒, M3 a M7, los controles plantados de T1 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** el hash §8.2 con el instrumento de `/tmp` (node) frente al del script R; 3 celdas ancla recalculadas a mano desde el parquet; T2 con otro recorrido (enlace escrito en la barra de direcciones y recarga; `history.go(-2)`); y una lectura dirigida: **¿queda algún `setPantalla(` que cambie la vista sin reflejarlo en la dirección, o alguna escritura de la dirección al abrir sin hash?** Si la hay, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a d y `Rscript tests/verificar_motor.R`.
6. **Control positivo:** el motor anterior (`b3daf503…`) vuelve a dar los casos malos de M5; una copia con una cifra alterada hace fallar el script.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y, si ya se desplegó, un segundo despliegue solo con la regla 5 superada.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA; cambiar `HASH_ESPERADO` para que un caso pase.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 7. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; auditoría; invariantes; salida literal de `Rscript tests/verificar_motor.R` final; md5 y testigo; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33u_priv.sh`) → vacío, con control plantado, sobre el LOG **y sobre `tests/verificar_motor.R`**; ningún RBD con número ni nombre de establecimiento en ninguno de los dos.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33u verificación y direcciones"`; luego el push según la autorización.

## 8. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida del push; md5 publicado; salida de `Rscript tests/verificar_motor.R`; los tres enlaces para probar en el sitio publicado (`…/#panorama`, `…/#ficha`, `…/#comparador`); "lo que falló o sorprendió; si nada, decirlo".
