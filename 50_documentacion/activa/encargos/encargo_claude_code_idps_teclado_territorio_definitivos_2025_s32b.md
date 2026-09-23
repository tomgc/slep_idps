# Encargo autónomo: teclado del modal de territorio y datos definitivos 2025 (s32b)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena que escribe en serie; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. Si la sesión está en `ultracode`, el encargo manda: 0 subagentes, declarado en el encabezado del log.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `30_procesamiento/3[1-5]_*.R`; `10_utils/10_configuracion.R`; `20_insumos/*2025*_preliminar.xlsx` (9) y `20_insumos/auxiliares/*2025_GLOSAS_web_preliminar.xlsx` (3); `20_insumos/definitivos_2025/` (12 archivos `_final`); `40_salidas/motor_idps.html`; `40_salidas/intermedios/`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito para shell (bash 3.2 de macOS: toda expresión con `{m,n}` va en un script, no entre comillas anidadas); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema). Primer acto git de FASE 0: `fetch` y comparar `HEAD` con `origin/main`.
- **LOG:** `50_documentacion/andamios/logs/20260923_teclado_territorio_definitivos_2025_s32b_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `f0c24e9`), y los escribe en el encabezado del log.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0 y 0 warnings (T2 cambia datos: corre el pipeline completo); (b) el motor abierto por `file://` en Puppeteer con 0 errores de consola y 0 `pageerror` tras cargar y abrir los dos modales; (c) hash del payload con la **convención §8.2 de s29** (SHA-256 del JSON descomprimido con `fecha_generacion` normalizada a `0000-00-00`), no el SHA crudo.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; localizar código por marcadores, no por número de línea.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` con alguna ruta fuera de {este encargo, `20_insumos/definitivos_2025/`} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 **tras T1** → congela T1 (T1 no toca datos).
4. En T2: cualquier columna del esquema de un archivo `_final` distinta de la de su `_preliminar` homólogo (nombres y tipos, por hoja) → congela T2 y registra la diferencia literal; no adaptes el pipeline.
5. En T2: filas de `idps_largo.parquet` con `agno != 2025` no idénticas antes y después → congela T2 (BLOQUEA en FASE R).
6. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
7. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
8. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- `git add` y `git commit` del encargo en FASE 0 (`chore(encargo): s32b`), antes de medir nada más.
- `git commit` de los archivos del ALCANCE de cada tarea, tras el cierre de fase.
- En T2, **solo con el esquema de M6 idéntico**: `mkdir -p` de `_archivo/20260923/20_insumos/auxiliares/`; `mv -n` de los 9 `20_insumos/idps*2025*_preliminar.xlsx` y los 3 `20_insumos/auxiliares/idps*2025_GLOSAS_web_preliminar.xlsx` a esa ruta, conservando la ruta relativa; `git rm --cached --quiet` de esas 12 rutas viejas; `mv -n` de los 9 `_final` de datos de `definitivos_2025/` a `20_insumos/` y de las 3 glosas `_final` a `20_insumos/auxiliares/`; `rmdir 20_insumos/definitivos_2025` solo si quedó vacía. El bucle se imprime primero en modo solo impresión; la lista impresa es lo autorizado.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s32b_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular: **no** se despliega (`docs/` intacto: el despliegue va tras el gate visual del titular sobre este build), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `f0c24e9` (fuente: eco del push de Claude Code, 2026-09-23); se re-mide en FASE 0.
- **T1, el defecto:** en el gate visual del titular, en Chrome sobre `40_salidas/motor_idps.html` (build `4a22cbc`), fallaron los tres puntos del **modal de territorio**: llegar con Tab desde el buscador a una fila, elegir con Enter y elegir con Espacio. En el **mismo gate** pasaron los puntos del modal del comparador: Espacio marca y desmarca, y el tope salta las filas atenuadas (fuente: mensaje del titular, 2026-09-23). El titular no precisó en qué paso se cortó.
- Las filas de `EntityModal` tienen `tabIndex={dis?-1:0}`, `role`, `onKeyDown` para Enter y Espacio, y una sola función `elegir` para clic y teclado; `.check-row:focus-visible` existe en la plantilla y en el motor (fuente: `sed` y `grep -c` del redactor sobre la plantilla ~L1635-1650 y `40_salidas/motor_idps.html`). El log de s32 registra T2.1 PASA en Puppeteer headless sobre el modal de territorio (fuente: log s32, leído por el redactor). **La prueba headless no reproduce lo que vio el titular**: la causa es hipótesis, se diagnostica en T1.
- Los dos modales usan el mismo `EntityModal` (~L2902 territorio, simple; ~L2904 comparador, múltiple) (fuente: `grep '<EntityModal'` del redactor). Lo que difiere entre ambos (props, `buildList`, `avisoFor`, `depVisible`, `onPick` frente a `addTerr`, foco inicial, re-render al escribir) es donde se busca la causa (hipótesis, se mide en T1).
- **T2:** hay 12 archivos definitivos en `20_insumos/definitivos_2025/`: 9 de datos (`rbd`, `rbd_dim`, `rbd_subdim_niveles` × 4b, 2m, 8b) y 3 glosas (fuente: `ls` del redactor). Seis traían el grado en mayúscula y el redactor los renombró a minúscula en la misma carpeta, sin tocar su contenido.
- Los 3 archivos de datos de 8° básico `_final` son **byte-idénticos** a sus `_preliminar` (md5 `fad1f206…`, `92c4fda7…`, `e3cb579a…`) (fuente: `md5sum` del redactor). El titular confirma que son los definitivos publicados por la Agencia (**decisión del titular**, 2026-09-23): entran igual.
- Los 6 archivos de datos `_final` de 4b y 2m difieren de sus preliminares (entre 18 % y 21 % más bytes) (fuente: `stat` del redactor). Si cambia el esquema o solo el contenido, es hipótesis (M6).
- La marca preliminar sale **solo** del sufijo del nombre: `PATRON_DATOS` en `34_leer_normalizar_idps.R` (~L65) y `preliminar = (estado == "preliminar")` (~L254); `anios_preliminar` en `35_generar_motor_html.R` (~L409) se deriva del dato; la plantilla arma `PRELIM` desde `DATA.meta.anios_preliminar` (~L824) (fuente: `grep` del redactor).
- `34_leer_normalizar_idps.R` lista `20_insumos` con `fs::dir_ls(…, type = "file")` sin recursión (~L87), así que `definitivos_2025/` no se lee mientras exista (fuente: `grep` del redactor). Ningún script lee las glosas por nombre; la única mención es un comentario de procedencia en `10_configuracion.R` ~L198, que queda como está porque describe cómo se construyó el crosswalk (fuente: `grep` del redactor).
- `_archivo/` está en `.gitignore` (fuente: `grep -n _archivo .gitignore`, L30).
- `idps6b2024_*_preliminar.xlsx` (3) queda fuera del alcance: no es 2025 y 6° básico no está en `GRADOS_MOTOR` (fuente: `ls` y `10_configuracion.R` L166).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. La interfaz vive en `30_procesamiento/35_motor_template.html`. `00_build.R` orquesta los pasos 31 a 35: 34 produce `idps_largo.parquet` y 35 arma el payload y produce `40_salidas/motor_idps.html`. Cero agregación: el territorio acota, jamás promedia. `docs/index.html` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Años distintos de 2025 intactos:** en R, `idps_largo.parquet` antes (copia en `/tmp/s32b_largo_antes.parquet`, tomada en FASE 0) y después, filtrado a `agno != 2025` y ordenado por todas las columnas: `identical()` → `TRUE`, con `nrow` igual en ambos.
2. **Sin agregación nueva:** `git diff <inicio>..HEAD -- 30_procesamiento/3[1-5]_*.R 10_utils | wc -l` → `0` (T2 cambia insumos, no código).
3. **Paletas intactas:** md5 del bloque `:root{…}` (mismo `awk` que en s32, en un script `/tmp/s32b_root_md5.sh`) igual antes y después; y `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html` sin colores literales agregados ni borrados (script con la expresión dentro, no entre comillas anidadas).
4. **El estado se lee de `sigdifgru`:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Nada se borra:** los 12 preliminares existen en `_archivo/20260923/20_insumos/…` con el md5 de FASE 0.

## 4. Grafo de tareas y ALCANCE

- **T1** (teclado del modal de territorio) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (definitivos 2025) · ALCANCE: `20_insumos/` (solo los 24 nombres de §0 Autorizaciones y la carpeta `definitivos_2025/`), `_archivo/20260923/` (fuera de git) y los derivados que regenera el pipeline: `40_salidas/intermedios/` y los artefactos de `50_documentacion` que los pasos 31-35 reescriben por sí mismos (se listan en FASE 0 con un `git status` tras un build de línea base, M9).
- **T3** (build final) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 **o** T2 completada.
- Independientes T1 y T2; comparten el build final, así que van en serie: T1 → T2 → T3.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: commitear este encargo (`chore(encargo): s32b`). Segundo acto: `mkdir -p` y crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real; grafo; "sin subagentes"; topes), el slot vacío `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición con `esperado:` escrito **antes** y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain`; `git stash list` | solo `?? 20_insumos/definitivos_2025/` (el encargo ya se commiteó); stash vacío | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD` = hash del commit del encargo, hijo de `f0c24e9`; `0`; `1` | regla 2 |
| M3 | hash §8.2 del payload de `40_salidas/motor_idps.html` (script `/tmp/s32b_payload_sha.sh`); calibración: el mismo script sobre `docs/index.html` da otro hash (build distinto) y sobre una copia del motor con la fecha alterada da el mismo | 64 hex; distinto de docs; igual con la fecha alterada | congela T1 y T3 |
| M4 | md5 del `:root` | un md5 | congela T1 |
| M5 | `ls` y `md5sum` de los 12 `_final` y los 12 `_preliminar` | 12 y 12; los 3 pares de datos de 8b con md5 igual; los otros 6 de datos, distintos | congela T2 |
| M6 | **Esquema**, en R con `readxl`: por cada par final/preliminar, nombres de hoja, y por hoja nombres de columna y clase | idénticos en los 9 pares de datos | regla 4 |
| M7 | **Glosas**: en R, la tabla id↔label de indicadores, dimensiones y subdimensiones de cada glosa final contra su preliminar | idéntica (el crosswalk `CW_*` sigue válido) | congela T2 |
| M8 | copia de `40_salidas/intermedios/idps_largo.parquet` a `/tmp/s32b_largo_antes.parquet`; en R, `nrow` por `grado` × `agno` × `preliminar` | 2025 con `preliminar = TRUE` en 4b, 2m y 8b | registra; no bloquea |
| M9 | build de línea base `run_all()` sin tocar nada; `git status --porcelain` después | lista de derivados que el pipeline reescribe por sí mismo (fija el ALCANCE de derivados de T2) | si toca algo fuera de `40_salidas/` y `50_documentacion/`, congela T2 |
| M10 | **Reproducción de T1 en Chrome con ventana** (`headless: false`, viewport 1440×900, foco de ventana real): abre el motor, clic en `.terr-trigger`, y desde el buscador presiona Tab 10 veces, registrando tras cada Tab `document.activeElement` (tag, clase, `role`, texto recortado a 40 caracteres). Repite en headless con la misma secuencia | la secuencia headful muestra dónde se corta (el foco no llega a una `.check-row`, o llega y Enter no elige) | si headful también pasa, repite con la **pestaña inicial** del modal de territorio, con escritura previa en el buscador y con `depVisible`; si nada falla, congela T1 como duda con pregunta cerrada al titular ("¿en qué paso se cortó: el Tab no llegaba a la fila, o llegaba y Enter no elegía?") |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: el modal de territorio se opera con teclado

**Meta:** en Chrome con ventana, en el modal de territorio, Tab desde el buscador llega a una fila con contorno visible, y Enter o Espacio elige la entidad y cierra el modal.

1. Paso 0: con la traza de M10, localiza la causa raíz leyendo el código (qué recibe el foco en lugar de la fila, o qué intercepta la tecla: un `keydown` de `window`, un re-render que desmonta la fila, un `autoFocus` que devuelve el foco al buscador, un `onPick` que exige otro evento). Escribe la causa en el log **antes** de corregir.
2. Corrección quirúrgica en `EntityModal` o en las props del modal de territorio. Si el modal del hermano (`/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`) resuelve ese caso, cita sus líneas. No se toca el comparador salvo que la causa esté en código compartido; en ese caso se repite su verificación.
3. Verificación (headful **y** headless, con `esperado:` antes):
   - T1.1 **caso que lo motivó:** la secuencia de M10 llega a `.check-row` en ≤ 3 Tab, y el `outline` computado es `2px solid` en `--foco`.
   - T1.2 Enter sobre la fila enfocada cierra el modal y `.terr-trigger` muestra esa entidad; Espacio hace lo mismo en el tab Región.
   - T1.3 Escape cierra sin cambiar el territorio.
   - T1.4 no regresión del comparador: Espacio marca y desmarca, y el tope salta las filas atenuadas.
   - T1.5 **caso malo:** el mismo script de T1.1 y T1.2 sobre el motor de `4a22cbc` (extraído con `git show 4a22cbc:40_salidas/motor_idps.html > /tmp/s32b_motor_viejo.html`) falla en el paso que mostró M10.
   - Hash §8.2 del payload igual a M3 (regla 3).
4. Cierre de fase en cinco pasos; commit `fix(motor): teclado del modal de territorio (s32b T1)`, solo la plantilla.

## 7. T2: datos definitivos 2025

**Meta:** el motor lee los definitivos de 2025 en los tres grados, ningún 2025 queda marcado como preliminar, los años anteriores quedan idénticos y los preliminares quedan archivados, no borrados.

1. Paso 0: relee M5, M6 y M7. Si alguno congeló T2, no sigas.
2. Intercambio, según las Autorizaciones: primero imprime la lista de 24 movimientos más los 12 `git rm --cached`; después ejecútalos.
3. Build completo `run_all()` (PRUEBAS a).
4. Verificación (con `esperado:` antes de cada comando):
   - T2.1 `ls 20_insumos/*2025*_preliminar.xlsx 20_insumos/auxiliares/*2025*_preliminar.xlsx 2>/dev/null | wc -l` → `0`; `ls 20_insumos/*2025*_final.xlsx | wc -l` → `9`; `ls 20_insumos/auxiliares/*2025_GLOSAS_web_final.xlsx | wc -l` → `3`; `definitivos_2025/` no existe.
   - T2.2 en R: `idps_largo.parquet` nuevo con `preliminar = FALSE` en todo 2025, en los tres grados; el conteo por `grado` × `agno` sale en el log.
   - T2.3 en el payload: `anios_preliminar` sin 2025 (queda 2024 solo si 6b entra al payload; 6b está fuera de `GRADOS_MOTOR`, así que el esperado es la lista vacía para 4b y 2m).
   - T2.4 **caso que lo motivó**, en Puppeteer: la ficha de un establecimiento del SLEP foco en 4b 2025 no dice "(preliminar)"; la vista histórica no muestra "2025*"; el panorama no dice "(preliminar)". Caso malo: el mismo script sobre `/tmp/s32b_motor_viejo.html` encuentra las tres marcas.
   - T2.5 🔒1: filas con `agno != 2025` idénticas.
   - T2.6 **cuánto cambió 2025**, en R, 4b y 2m por separado, comparando `/tmp/s32b_largo_antes.parquet` con el nuevo sobre 2025: establecimientos (RBD) que entran, que salen y comunes; en los comunes, celdas de `prom` distintas (n y máximo de |Δ|), cambios de `sigdifgru` (tabla de transición -1/0/1/NA) y cambios de GSE. En 8b, el esperado es 0 cambios (archivos byte-idénticos); si hay alguno, es hallazgo. Solo conteos: ningún RBD ni nombre entra al log.
   - T2.7 control positivo de T2.6: la misma función sobre dos copias en `/tmp` del parquet, una con un `prom` alterado a mano, reporta exactamente 1 celda distinta.
5. Cierre de fase: commit `data(insumos): IDPS 2025 definitivos reemplazan a los preliminares (s32b T2)`, con las 24 rutas (12 borrados del índice y 12 altas) más los derivados de M9, y nada más.

## 8. T3: build final

1. `git status --porcelain` → solo `40_salidas/motor_idps.html` o vacío.
2. Build (PRUEBAS a); PRUEBAS b completa; T1.1, T1.2 y T2.4 repetidos sobre el motor commiteable.
3. Testigo para el despliegue futuro: una cadena que exista en el motor nuevo y no en `docs/index.html` ni en el motor de `4a22cbc`. Propón la del arreglo de T1; si no hay ninguna distintiva, usa la ausencia de "2025*" como testigo negativo y decláralo.
4. Commit `build(motor): s32b teclado y definitivos 2025`.

## 9. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar. Incluye los controles positivos y los casos malos (T1.5, T2.4, T2.7) y los chequeos de alcance por tarea.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (T2.6 re-derivado con `table()` o un `anti_join` si se produjo con `summarise()`; T1 con otra entidad y otro tab del modal; el hash §8.2 en `node` si se produjo en R, o al revés).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol, que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, años anteriores alterados, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Después, pasos 2 a 5 sobre lo tocado. Lo que sobrevive al segundo ciclo, o destapa algo nuevo en otra parte, se congela como pendiente.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 10. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 antes y después de T1, antes y después de T2; resumen de T2.6); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre. Anota el **testigo del despliegue** de T3.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: se declara "según la condición del encargo; resultado en el reporte final".
4. Privacidad: el grep de RUT sobre el log con un script (`/tmp/s32b_priv.sh`) → vacío; ningún RBD ni nombre de establecimiento o de persona. El nombre de la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s32b teclado del modal de territorio y definitivos 2025"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado, qué no se publica (el despliegue a `docs/`, tras el gate visual del titular), hash del commit `docs(log)`.

## 11. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: resultado del push (salida literal y `rev-list` final); causa raíz del defecto de T1 en dos líneas; tabla de T2.6; lo que queda al titular (gate visual: modal de territorio con Tab y Enter, y ningún "2025*" ni "(preliminar)" en 2025); "lo que falló o sorprendió; si nada, decirlo".
