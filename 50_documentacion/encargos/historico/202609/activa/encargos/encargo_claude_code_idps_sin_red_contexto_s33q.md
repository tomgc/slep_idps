# Encargo autónomo: motor sin red, integración del contrato de contexto y despliegue (s33q)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena que escribe en serie, un merge, un despliegue y un push; `encargo_autonomo_claude_code_v1.md` §2.12, filas 2 y 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `30_procesamiento/35_generar_motor_html.R`; `00_build.R`; `00_escanear_proyecto.R`; `renv.lock`; `40_salidas/motor_idps.html`; `docs/index.html`; la rama `feat/contrato-contexto-v2`; el log de s33l (columnas del parquet de contexto). **Del hermano `/Users/tomgc/Projects/slep_simce_adecuado`, solo lectura:** `50_documentacion/activa/decisiones/20260923_decision_transpilacion_en_build.md` (referencia vinculante del método), `30_procesamiento/33_generar_html.R` (bloque 3b y constantes `VENDOR_JS`, `ANCLA_JSX_APERTURA`, `OPCIONES_BABEL`, funciones `verificar_vendor` y `transpilar_jsx`), `10_utils/10_html.R` (`reemplazar_literal`), sus tres archivos `10_utils/react.production.min.js`, `react-dom.production.min.js` y `babel.min.js`, y los logs `50_documentacion/andamios/logs/20260923_retiro_cdn_v8_log.md` y su adenda (método de la equivalencia del transpilado).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2; expresiones con `{m,n}` dentro de un script en `/tmp/s33q_*`). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea. **En el hermano no se escribe nada ni se corre git que escriba** (lecturas con `GIT_OPTIONAL_LOCKS=0`).
- **LOG:** `50_documentacion/andamios/logs/20260925_sin_red_contexto_s33q_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío), `git rev-parse --short HEAD` y `git worktree list`. El hash del commit `chore(encargo): s33q` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG** (desde T4, también el parquet de contexto si cambió, según T4); (b) PRUEBAS b de s33 (0 errores de consola y 0 `pageerror` con los dos modales, una ficha con vista histórica, una comparación de 10 entidades, cada exportación CSV y un `page.pdf` del comparador); (c) hash del payload con la **convención §8.2 de s29** = `eb4e00b3…4dc4`; (d) los cuatro CSV de s33f M6 con contenido byte-idéntico al de FASE 0.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado (hook o clasificador) no se reintenta por otra vía: se registra y el comando queda al titular.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify` ni `hooks.cartera false`; ningún color hex nuevo; en código R, rutas con `here::here()`, nunca absolutas; cita clases y textos de **este** motor (no los del hermano).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit), o `git worktree list` con más de una entrada → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto de `eb4e00b3…4dc4` en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. El sha384 de un archivo copiado del hermano distinto del `integrity` que hoy declara la plantilla para ese archivo → congela T1 y T2.
7. `V8` u `openssl` no instalables en la biblioteca del proyecto (M6) → congela T2 y T3 (T4 y T5 siguen).
8. El transpilado del build distinto, carácter a carácter, del que produce Babel en el navegador con la plantilla actual (T2.4) → congela T2 y T3.
9. `git merge` de T4 con conflicto → `git merge --abort` y congela T4 (no se resuelven conflictos).
10. El parquet regenerado en T4 con alguna columna o valor de identificación individual, o con otra unidad que el establecimiento → `git revert -m 1` del merge, congela T4 y regístralo.
11. **Despliegue (T6):** cualquier captura del motor nuevo distinta píxel a píxel de la de `docs/index.html` actual, o cualquier diferencia de `textContent` entre los dos, en las pantallas de 🔒6 → no se despliega; congela T6.
12. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33q`).
- `cp` de los tres archivos del hermano a `/Users/tomgc/Projects/slep_idps/10_utils/`, una vez cada uno.
- `Rscript -e 'renv::install(c("V8","openssl"))'` y `renv::record()` de esos dos paquetes con sus versiones instaladas, **solo** si M6 los da por ausentes. Si `renv::record` toca otra entrada de `renv.lock`, se anota como hallazgo, `renv.lock` no se commitea y la tarea sigue (el build usa la biblioteca instalada).
- `git commit` en `main` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- T4: `git merge --no-ff feat/contrato-contexto-v2` una vez; `git revert -m 1 <merge>` si la regla 10 dispara.
- T6: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, solo con la regla 11 superada.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33q_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, `rebase` ni `branch -D`, y nada escrito en el hermano.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `23ce4b0`, el `docs(log)` de s33p; o, si el titular ya hizo merge del PR #4 y `pull`, el merge de `ordenacion/20260925` (`d7a8520`) sobre `23ce4b0` (fuente: `.git/refs` leídos por el redactor el 2026-09-25; el merge es hipótesis, se mide en M2).
- Motor y `docs/index.html` = `e227639b61eb3ca5620b84fb3834d6fe` (fuente: `openssl md5` del redactor).
- La plantilla carga React 18.3.1, ReactDOM 18.3.1 y Babel standalone 7.29.0 desde `unpkg.com`, con `integrity` sha384 `DGyLxAyj…`, `gTGxhz21…` y `m08Kidi…`; D3 y pako ya van en línea (`__D3_INLINE__`, `__PAKO_INLINE__`); hay **un** bloque `<script type="text/babel" data-presets="env,react">` (fuente: `sed` y `grep -c` del redactor). Sin red el motor queda en blanco (matriz de s33n, fila 20).
- Los tres archivos del hermano en su `10_utils/` dan exactamente esos sha384 (fuente: `openssl dgst -sha384` del redactor).
- El generador arma el HTML con `sub(…, fixed = TRUE)` en su "Bloque 6"; `10_utils/` versiona `d3.min.js` y `pako.min.js` (fuente: `sed` y `git ls-files` del redactor).
- `V8` y `openssl` no están en la biblioteca `renv` del proyecto (hipótesis del redactor por `ls` de `renv/library`; se mide en M6). El hermano los usa sin registrarlos en su `renv.lock`.
- `feat/contrato-contexto-v2` = `6752d29`: dos commits sobre `c872511` con `30_procesamiento/36_exponer_contrato_contexto.R`, `40_salidas/publico/contexto_idps.parquet` (autorizado en `main` desde s33l), `50_documentacion/activa/contrato_contexto_v1.md` y el enganche del paso 36 en `00_build.R` (fuente: log de s33o, T6, y `git log` de solo lectura del redactor). El parquet es de julio (fuente: fecha del commit `aca50f7`).

**Decisiones que este encargo implementa (sesión 33, criterio delegado por el titular):**
- Motor sin red con el método del hermano (transpilación en el build con V8; React y ReactDOM en línea; Babel no viaja), según su decisión D31-1, sin paso manual ni Node.
- Integración del contrato de contexto en `main`: el paso 36 entra a `run_all()` y el parquet se regenera con el dato vigente.
- Despliegue en el mismo encargo **solo** si la pantalla es idéntica a la publicada (regla 11): el cambio no debe verse.
- Si el PR #4 ya está integrado, el escáner se corre en el árbol principal para que la foto deje de nombrar la raíz del worktree (D-1 de s33o).

## 2. Contexto mínimo

El motor publicado pide tres librerías a un CDN y transpila el JSX en el navegador: sin internet queda en blanco. Los dos hermanos ya lo resolvieron. El contrato de contexto es un parquet público que otros proyectos leen; vive en una rama publicada y sin integrar.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 = `eb4e00b3…4dc4` en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils/*.R 20_insumos 30_procesamiento/3[1-4]* | wc -l` → `0`.
4. **Sin red:** el motor nuevo no contiene `src="http`, `href="http` ni `text/babel` (`grep -c` → 0) y, abierto con Puppeteer con **toda** petición que no sea `file:`, `data:` o `blob:` abortada, dibuja la apertura con 0 errores.
5. **La pantalla no cambia:** capturas a 1280 × 800 y a 390 × 800 de la apertura, el comparador de 10 entidades, el panorama (vista actual e histórica), una ficha y los dos modales, idénticas píxel a píxel entre `docs/index.html` (FASE 0) y el motor nuevo.
6. **El texto no cambia:** `textContent` de esas mismas pantallas idéntico entre `docs/index.html` y el motor nuevo.
7. **Exportaciones intactas:** PRUEBAS d.
8. **`main` no recibe otra rama que la de contexto:** `git log --merges <inicio>..HEAD` = a lo sumo el merge de T4.

## 4. Grafo de tareas y ALCANCE

- **T1** (vendorizar) · ALCANCE: `10_utils/react.production.min.js`, `10_utils/react-dom.production.min.js`, `10_utils/babel.min.js`.
- **T2** (transpilar en el build) · ALCANCE: `30_procesamiento/35_generar_motor_html.R`, `30_procesamiento/35_motor_template.html`, `renv.lock` (solo si M6 instaló). Requiere T1.
- **T3** (build y verificación sin red) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T2.
- **T4** (integrar el contrato de contexto) · ALCANCE: el merge de `feat/contrato-contexto-v2` y, si se regenera distinto, `40_salidas/publico/contexto_idps.parquet`. Independiente de T1 a T3; corre después de T3.
- **T5** (foto del escáner) · ALCANCE: `50_documentacion/estructura/*`. Solo si M2 muestra el PR #4 integrado; si no, "no aplica".
- **T6** (despliegue) · ALCANCE: `docs/index.html`. Requiere T3 completada.
- Orden: T1 → T2 → T3 → T4 → T5 → T6. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito en el LOG **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit; `git worktree list` | solo el LOG; vacío; el encargo; una entrada | regla 1 o 2 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD`; `git merge-base --is-ancestor d7a8520 HEAD` | `HEAD~1` = `origin/main` ∈ {`23ce4b0`, un merge cuyo primer padre es `23ce4b0` y el segundo `d7a8520`}; `0`; `1`; se registra si el PR #4 está integrado | regla 2 |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*` o reconstruidos desde el log de s33o); hash §8.2 con calibración; md5 del `:root`, de la plantilla, del motor y de `docs/` | `eb4e00b3…`; igual con la fecha alterada; distinto con una cifra plantada; motor = `docs/` = `e227639b…` | congela T3 y T6 si la calibración falla |
| M4 | **Caso malo:** `docs/index.html` abierto con la red bloqueada como en 🔒4 | apertura en blanco o con error (React no definido) | regla 12 |
| M5 | Líneas base desde `docs/index.html`: capturas y `textContent` de 🔒5 y 🔒6; los cuatro CSV de PRUEBAS d | registradas | congela T6 |
| M6 | En la biblioteca del proyecto: `Rscript -e 'for (p in c("V8","openssl")) cat(p, requireNamespace(p, quietly=TRUE), "\n")'`; `renv::status()` resumido | se registra; si falta alguno, la instalación autorizada y otra vez la medición → `TRUE TRUE` | regla 7 |
| M7 | En el hermano, solo lectura: `openssl dgst -sha384 -binary … | openssl base64 -A` de los tres archivos frente a los `integrity` de la plantilla | iguales los tres | regla 6 |
| M8 | Calibración del testigo de despliegue: una cadena nueva y exclusiva del generador o de la plantilla (propuesta: el comentario `s33q: sin red`) | `0` en `docs/index.html` y en el motor actual | se elige otra y se registra |
| M9 | Contexto, solo lectura: `git diff --stat origin/main...feat/contrato-contexto-v2`; md5 del parquet de la rama | los cuatro archivos de §1; el md5 registrado en el log de s33o | regla 12 |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: vendorizar React, ReactDOM y Babel

1. Las tres copias autorizadas. Verificación: sha384 de cada copia = el `integrity` de la plantilla. Commit `chore(vendor): React 18.3.1, ReactDOM 18.3.1 y Babel standalone 7.29.0 en 10_utils (s33q T1)`.

### T2: transpilar el JSX en el build

1. Paso 0: relee la decisión D31-1 del hermano y su bloque 3b.
2. **Generador:** portar el método del hermano al "Bloque 6" de `35_generar_motor_html.R`: `VENDOR_JS` con las tres rutas (`here::here("10_utils", …)`), sus sha384 y sus URL de referencia; `verificar_vendor`; `transpilar_jsx` con las mismas `OPCIONES_BABEL` (presets `env` y `react` con `runtime: 'classic'`, `sourceType: 'script'`, `comments: true`, `compact: false`) y los mismos dos controles (JS válido; sin `_jsx(` ni `react/jsx-runtime`); extracción del único bloque `text/babel` por su ancla y reemplazo por `<script>` con el transpilado; React y ReactDOM insertados con una función de reemplazo literal equivalente a `reemplazar_literal` (no con `sub()`, que interpreta la barra invertida en el reemplazo). Chequeo de paquetes `V8` y `openssl` al inicio del bloque, con mensaje de instalación. Comentario con la cadena de M8.
3. **Plantilla:** las tres etiquetas `<script src="https://unpkg.com/…">` se reemplazan por `<script>__REACT_INLINE__</script>` y `<script>__REACTDOM_INLINE__</script>` (Babel no viaja). El bloque JSX no se toca: se sigue editando como JSX.
4. **Equivalencia del transpilado:** con Puppeteer sobre la plantilla actual (o `docs/index.html`), `Babel.transform` del mismo bloque con las opciones que aplica `data-presets="env,react"` en el navegador, frente a la salida de `transpilar_jsx` en V8: iguales carácter a carácter (método del log del hermano); se registran los largos.
5. Si M6 instaló paquetes: `renv::record` de los dos; `git diff renv.lock` debe tocar solo esas dos entradas (si no, hallazgo y `renv.lock` no se commitea).
6. Commit `feat(build): el JSX se transpila en el build con V8; React y ReactDOM en línea (s33q T2, método D31-1 del hermano)`.

### T3: build y verificación sin red

1. Build con PRUEBAS a; porcelain = solo el motor y el LOG.
2. Verificación (`esperado:` antes): 🔒1; 🔒4 (incluido el control: `docs/index.html` sigue en blanco con la misma intercepción); 🔒5 y 🔒6 contra M5; PRUEBAS b con la red bloqueada **y** con red; PRUEBAS d; `React.createElement(` > 0 y `_jsx(` = 0 en el motor; testigo de M8 ≥ 1; tamaño del motor antes y después.
3. md5 del motor nuevo registrado. Commit `build(motor): s33q motor sin red`.

### T4: integrar el contrato de contexto

1. `git merge --no-ff feat/contrato-contexto-v2 -m "merge: integra el contrato de contexto v1 (paso 36) desde feat/contrato-contexto-v2 (s33q T4)"` (regla 9).
2. `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all(only = 36)'` **dos veces**; md5 del parquet tras cada corrida (esperado: iguales entre sí: el productor es determinista; si difieren, regla 12).
3. Gobernanza (M4 de s33l repetido sobre el parquet regenerado): nombres y tipos de columnas, `nrow()`, valores distintos del identificador, patrón de RUT sobre las columnas de texto → mismas columnas que s33l y 0 coincidencias (regla 10). Se registran filas y columnas antes y después.
4. Si el parquet cambió: commit `data(contexto): regenera contexto_idps.parquet con el dato vigente (s33q T4)`. PRUEBAS a completo después del merge: porcelain limpio salvo el LOG (el paso 36 ya no deja cambios).

### T5: foto del escáner en el árbol principal

1. Solo si M2 dio el PR #4 integrado: `Rscript /Users/tomgc/Projects/slep_idps/00_escanear_proyecto.R`; la foto nombra la raíz del proyecto (no `/private/tmp/…`); totales registrados. Commit `docs(estructura): foto del escáner en el árbol principal (D-1 de s33o)`. Si no, "no aplica".

### T6: despliegue

1. Regla 11 medida otra vez sobre el motor final (tras T4 y T5 el motor no debe haber cambiado: md5 = el de T3).
2. La copia autorizada. Verificación: md5 de `docs/index.html` = motor; testigo de M8 igual en los dos; 🔒1 sobre `docs/`; 🔒4 sobre `docs/`. Commit `deploy(docs): motor sin red (s33q)`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M4, M8, el control de 🔒4) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** sha384 con otra herramienta (`shasum -a 384` + base64); 🔒4 con otra intercepción (`--host-resolver-rules="MAP * ~NOTFOUND"` al lanzar Chrome); 🔒5 con otra métrica de píxeles; el parquet con otra lectura (`arrow::read_parquet(..., as_data_frame = FALSE)$schema` o `nanoparquet`); el merge con `git show --stat`.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG, el encargo y los archivos que trae el merge de T4); `git status --porcelain`; `git worktree list`.
5. **Regresión completa:** PRUEBAS a, b, c y d sobre el estado final.
6. **Control positivo de la auditoría:** el motor anterior (`e227639b…`) vuelve a quedar en blanco con la red bloqueada, con el mismo instrumento.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**, como en los encargos s33 a s33p. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …` (con rebuild y, si ya se desplegó, un segundo despliegue solo con la regla 11 superada).
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA; escribir en el hermano.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); `git worktree list` → una entrada. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; auditoría; invariantes; estado de cifras (hash §8.2 en cada build; tamaño del motor; largo del transpilado; filas y columnas del parquet antes y después); md5 publicado y testigo; salida del push; decisiones (§1); dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con script (`/tmp/s33q_priv.sh`) → vacío, con control plantado; ninguna fila del parquet en el log.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33q sin red y contexto"`; luego el push según la autorización.
7. Estado de cierre en el reporte: hashes; md5 publicado; salida del push.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push; md5 de `docs/index.html` y testigo; lo que queda al titular (abrir el sitio publicado, y también el archivo descargado con el wifi apagado); "lo que falló o sorprendió; si nada, decirlo".
