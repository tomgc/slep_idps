# Encargo autónomo: la tabla del comparador hace scroll en vez de comprimirse (s32d)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `30_procesamiento/32_censo_insumos.R`; `00_build.R`; `40_salidas/motor_idps.html`; el hermano `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html` (solo lectura).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
- **LOG:** `50_documentacion/andamios/logs/20260923_tabla_comparador_scroll_s32d_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `0b266a1`), y los escribe en el encabezado del log.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y árbol limpio salvo el ALCANCE (desde s32c el censo no sella la hora); (b) Puppeteer sobre el motor por `file://`: 0 errores de consola y 0 `pageerror` tras cargar, abrir los dos modales, abrir una ficha y armar una comparación; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (este encargo no toca datos).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; localizar código por marcadores, no por número de línea.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` con alguna ruta fuera de {este encargo} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s32d`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras el cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s32d_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto: el despliegue va tras el gate visual del titular), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `0b266a1` (fuente: reporte del push de s32c y `.git/refs/heads/main` leído por el redactor).
- `.cmp-table` declara `width:100%;border-collapse:collapse;table-layout:fixed;` sin `min-width` (~L556); `th.th-terr` tiene `width:210px` (~L558); `th.th-ind` envuelve (~L559); el contenedor `.cmp-tscroll` ya tiene `overflow-x:auto` (~L599) (fuente: `grep -n 'cmp-table\|cmp-tscroll'` del redactor).
- La tabla se dibuja una vez por sección de GSE: una fila por entidad comparada (`cmpTerrs`, celdas `StackedBar`) y una por establecimiento (`cmpEEs`, celdas `CeldaEE`), con una columna de entidad y cuatro de indicador (~L1969-1990) (fuente: `sed` del redactor).
- Con `table-layout:fixed`, `width:100%` y sin `min-width`, a 430 px las columnas de indicador se reducen a unos 43 px en vez de hacer scroll; es la causa de fondo del desborde de la tira de barras (fuente: `CLAUDE.md`, pendientes de s29i, log §43; el número de 43 px es hipótesis y se mide en FASE 0).
- El hermano tiene un comparador equivalente (regla s29h: su implementación es referencia vinculante); si su tabla usa `min-width` y cuál es su valor, es hipótesis (se mide en FASE 0).
- El encabezado de `32_censo_insumos.R` dice "27 tablas de datos" (~L12) (fuente: `grep` del redactor); el conteo real es hipótesis (se mide en FASE 0; el log de s32c dice 28).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. Interfaz en `30_procesamiento/35_motor_template.html`; `00_build.R` orquesta los pasos 31 a 35. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (script `/tmp/s32d_payload_sha.sh`).
2. **Paletas intactas:** md5 del `:root` igual antes y después (script `/tmp/s32d_root_md5.sh`), y el diff de la plantilla sin colores literales agregados ni borrados (expresión dentro de un script).
3. **El estado se lee de `sigdifgru`:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/31* 30_procesamiento/33* 30_procesamiento/34* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`, y el diff de `32_censo_insumos.R` toca solo líneas de comentario (`git diff … | grep -E '^[+-][^+-]' | grep -vcE '^[+-]#'` → `0`).
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.

## 4. Grafo de tareas y ALCANCE

- **T1** (`min-width` de la tabla del comparador) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (banner del censo) · ALCANCE: `30_procesamiento/32_censo_insumos.R`. Independiente de T1.
- **T3** (build) · ALCANCE: `40_salidas/motor_idps.html` (y `40_salidas/intermedios/censo_insumos.md` solo si el build lo reescribe por sí mismo; no debería). Requiere T1 completada.
- Serie: T1 → T2 → T3. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: commitear el encargo. Segundo acto: crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real; grafo; "sin subagentes"; topes), el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición con `esperado:` escrito **antes** y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain` tras el primer commit (el LOG recién creado cuenta como propio); `git stash list` | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD` hijo de `0b266a1`; `0`; `1` | regla 2 |
| M3 | hash §8.2 del payload; calibración con dos copias en `/tmp`: fecha alterada (mismo hash) y cifra plantada (otro hash) | 64 hex; igual; distinto | congela T3 |
| M4 | md5 del `:root` | un md5 | congela T1 |
| M5 | **Caso malo de T1**, en Puppeteer sobre el motor actual, con una comparación de 3 entidades (SLEP foco, una comuna y Chile) más 1 establecimiento, 4b: a viewports de 430, 768 y 1280 px de ancho, para la primera `.cmp-table`, registra el ancho renderizado de cada `th` (`getBoundingClientRect().width`), el `scrollWidth` y `clientWidth` de `.cmp-tscroll`, y si algún `.s100-wrap` o celda desborda su `td` (`scrollWidth > clientWidth` del `td`) | a 430 px, columnas de indicador < 60 px, `.cmp-tscroll` sin scroll (`scrollWidth = clientWidth`) y al menos una celda desbordada | si no, congela T1 y registra (la premisa de §1 falló) |
| M6 | **Ancho mínimo legible** de una columna de indicador, `W_min`: con el mismo armado, en un viewport ancho, fija por CSS inyectado el ancho de las columnas de indicador en 60, 80, …, 240 px (paso 20) y registra el menor ancho en que ninguna celda (`StackedBar`, su nota "+N sin comparación publicada" y `CeldaEE`) desborda su `td` y ningún texto de rótulo se corta a mitad de palabra | un número entre 60 y 240 | si ninguno cumple, congela T1 |
| M7 | Lectura del hermano: la regla CSS de la tabla de su comparador (busca por `table-layout` o por la clase de la tabla del comparador); cita las líneas literales y si trae `min-width` | se registra lo que haya | si el archivo no existe, T1 sigue con M6 y se registra |
| M8 | `ls 20_insumos/idps*.xlsx \| grep -vc GLOSAS` y la línea literal del banner (~L12 de `32_censo_insumos.R`) | un número; la línea dice "27 tablas" | congela T2 si la línea no existe |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: la tabla hace scroll horizontal en vez de comprimirse

**Meta:** a cualquier ancho de pantalla, ninguna columna de indicador queda más angosta que `W_min`; si no caben, `.cmp-tscroll` hace scroll horizontal.

1. Paso 0: relee M5, M6 y M7.
2. Implementación: agrega a `.cmp-table` `min-width: <210 + 4 × W_min, redondeado hacia arriba a múltiplo de 10>px`. Si el hermano usa otro mecanismo con el mismo efecto, replícalo y cita sus líneas. Comentario de una línea: "s32d: min-width = columna de entidad + 4 × ancho mínimo legible medido (M6); bajo eso, scroll en .cmp-tscroll". No cambies `table-layout`, anchos de columna, tipografía ni colores.
3. Verificación (build temporal con `run_all(only = 35L)`; `esperado:` antes):
   - T1.1 **caso que lo motivó:** con el armado de M5 a 430 px, `.cmp-tscroll` hace scroll (`scrollWidth > clientWidth`), cada columna de indicador mide ≥ `W_min` y ninguna celda desborda su `td`.
   - T1.2 a 1280 px (caso bueno): la tabla ocupa el ancho disponible sin scroll y los anchos de columna quedan iguales a los de M5 a 1280 px (± 1 px); si difieren, explica por qué.
   - T1.3 a 768 px: registra si hay scroll y que ninguna celda desborda.
   - T1.4 caso malo: M5 (el motor anterior desborda a 430 px).
   - T1.5 el scroll de `.cmp-tscroll` se alcanza con teclado o con gesto horizontal: registra si el contenedor es enfocable. Si no lo es, **no lo cambies**: anótalo como duda para el titular.
   - Hash §8.2 igual a M3.
4. Cierre de fase en cinco pasos; commit `fix(motor): la tabla del comparador hace scroll en vez de comprimirse (s32d T1)`.

## 7. T2: banner del censo con el conteo real

1. Reemplaza "27 tablas de datos" por el número de M8 en el comentario del encabezado. Nada más en el archivo.
2. Verificación: el diff es 1 línea de comentario (🔒4); `grep -c '<N> tablas de datos'` → `1`.
3. Commit `docs(pipeline): conteo de tablas en el banner del censo (s32d T2)`.

## 8. T3: build

1. `git status --porcelain` → solo `40_salidas/motor_idps.html` o vacío.
2. Build (PRUEBAS a), PRUEBAS b completa; T1.1 y T1.2 repetidos sobre el motor commiteable; hash §8.2 igual a M3.
3. Testigo para el despliegue futuro: el valor literal del `min-width` de `.cmp-table` (`grep -c` en el motor nuevo = 1 y en `docs/index.html` = 0).
4. Commit `build(motor): s32d tabla del comparador con scroll`.

## 9. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando, los casos malos y plantados (M3, M5, T1.4) y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (los anchos de T1 con `getComputedStyle` además de `getBoundingClientRect`, y en otra combinación de entidades; el conteo de T2 con `find … -name` además de `ls`).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol, que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 10. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; anchos de columna antes y después a 430, 768 y 1280 px; `W_min`); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: "según la condición del encargo; resultado en el reporte final".
4. Privacidad: grep de RUT sobre el log con un script (`/tmp/s32d_priv.sh`) → vacío; ningún RBD ni nombre de establecimiento o de persona; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s32d tabla del comparador con scroll"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; el testigo del despliegue de T3; hash del commit `docs(log)`.

## 11. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; `W_min` y el `min-width` elegido; anchos a 430/768/1280 antes y después; lo que queda al titular (gate visual del comparador a ancho de celular y de escritorio; despliegue); "lo que falló o sorprendió; si nada, decirlo".
