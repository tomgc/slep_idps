# Encargo autónomo: exportación CSV de la vista histórica del panorama (s33e)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md` (§3 punto 10, exportación); los logs de s30 (exportación: instrumentos de Blob interceptado) y de s33 a s33d en `50_documentacion/andamios/logs/`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33e_*`); `Rscript` para toda cifra sobre datos (conteos de filas, comparación de celdas CSV contra el parquet); `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`), con el Blob interceptado como en s30 (`URL.createObjectURL` + `HTMLAnchorElement.prototype.click`). Con ventana, antes de la primera acción, esperar el elemento visible (`waitForSelector` con `visible:true`). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_csv_historico_s33e_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33e` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33: 0 errores de consola y 0 `pageerror`; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (este encargo no toca datos); (d) los tres CSV existentes (comparador, panorama actual y ficha) byte-idénticos antes y después para los casos fijos de M6.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; ningún color hex nuevo; todo conteo visible pasa por `nEE`/`nCom`; **regla de fidelidad de s30**: el constructor del CSV recibe los **mismos arreglos** con los que la pantalla dibuja y no recalcula universos; **regla de columnas de s30**: cada columna de código va con su etiqueta; el estado vs GSE se escribe **solo** con `estadoVsGse` (no se lee `sigdifgru` en código nuevo).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. Un caso malo de FASE 0 (M5 o M7) no se reproduce → la tarea que lo corrige se omite y se registra.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33e`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33e_*`; lectura y copia de los `/tmp/s33*` y `/tmp/s30*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `82bcae0`, el `docs(log)` de s33d (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24). Motor `08c22714954617d454618a1d647f1be4`; `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor).
- La decisión de vista histórica, §3 punto 10, dice: "Mientras esté activa la vista histórica, la barra de exportación del panorama no se muestra. Exportar esta vista queda como pendiente propio." (fuente: `grep -n` del redactor). En la plantilla, la barra de exportación del panorama se dibuja con `{!isHistPan && <div className="export-bar">…}` (fuente: `sed` del redactor).
- `PanoramaHistorico` recibe `rosterHist`, `panGrado`, `gseVis`, `vtInd`, `orden`, `esNacional` y calcula dentro: `conDato` (años del eje con estado `con_dato`), `filas` (`rosterHist` con `porAnio[y] = indOf(rbd,panGrado,y)` para cada año de `conDato`) y `grupos` (por GSE visible, con `ordenar`) (fuente: `sed` del redactor). Cada fila de `rosterHist` trae `rbd`, `gse` (el de su último año con GSE), `anios` (GSE por año) y `nom` (fuente: `sed` de `rosterHistorico`).
- Existen `descargarCSV`, `confirmarTamano`, `numCSV`, `estadoVsGse`, `slugArchivo`, `IconExport` y la constante `CSV_PAN_COLS` con las columnas del CSV del panorama actual: `rbd, establecimiento, comuna, dependencia, gse, gse_label, indicador, indicador_label, puntaje, estado_vs_gse, nivel, anio, preliminar` (fuente: `grep -n` y `sed` del redactor).
- El parquet de datos del motor es `40_salidas/intermedios/idps_largo.parquet` (fuente: `find` del redactor); es la fuente contra la que 🔒7 compara en R.
- A 320 px, la pestaña más ancha de la barra de pantallas no cabe entera y, al enfocarla con Tab, queda parcialmente oculta (`visible_en_barra: false`) (fuente: log s33d, A-2).

**Decisiones del titular que este encargo implementa (sesión 33):** exportar la vista histórica (pendiente 4 de v31; enmienda §3.10 de la decisión); A-2 de s33d → el redactor, con criterio delegado por el titular, decide que la pestaña enfocada se desplace hasta verse entera, sin acortar rótulos.

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. La vista histórica del panorama muestra, por GSE, una franja de estado por año (cuatro indicadores) y una matriz de puntaje de cada establecimiento por año (un indicador a la vez). Hoy no se puede exportar. **Cero agregación:** el CSV lleva una fila por establecimiento, año e indicador; ninguna fila de territorio ni total. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas cambiadas del diff `-U0` de la plantilla: **agregadas = 0**.
3. **El estado se lee de `sigdifgru` solo por `estadoVsGse`:** líneas cambiadas con `sigdifgru`: **agregadas = 0; borradas = 0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Las tres exportaciones existentes no cambian:** PRUEBAS d (md5 de cada CSV de M6 antes y después).
7. **Fidelidad pantalla ↔ CSV histórico:** para los casos de T2, (i) el número de filas del CSV = `Σ grupos × |conDato| × 4 indicadores`, contado en R sobre el archivo; (ii) 30 celdas al azar (semilla fija, escrita en el log) del indicador visible en la matriz: el puntaje del CSV coincide con el texto de la celda de la pantalla y con el `prom` de `40_salidas/intermedios/idps_largo.parquet` (en R); (iii) el estado del CSV coincide con `estadoVsGse` para esas celdas.
8. **Foco y teclado de s32e a s33d siguen iguales:** los scripts de ciclo, devolución y respaldos dan lo mismo que en el log s33d, en los dos modos.

## 4. Grafo de tareas y ALCANCE

- **T1** (la pestaña enfocada se ve entera) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (CSV de la vista histórica) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente de T1 en lógica; en serie después de T1.
- **T3** (enmienda §3.10 de la decisión) · ALCANCE: `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`. Requiere T2 completada.
- **T4** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 o T2 completada.
- Orden: T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `82bcae0` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*`); hash §8.2 con calibración; md5 y líneas del `:root`; md5 del motor | `eb4e00b3…4dc4`; igual con la fecha alterada; distinto con la cifra plantada; `08c22714…` | congela T4 si la calibración falla |
| M4 | Instrumento de Blob interceptado (copia del de s30, o reescrito desde su log) con **control positivo**: una descarga conocida del motor actual (CSV del panorama del SLEP foco, 4° básico 2025) se captura completa y su número de filas en R coincide con `4 × establecimientos del banner + 1` | se captura; conteo igual | congela T2 |
| M5 | **Caso malo de T1**, con ventana y headless, a 320 px (con remount): Tab hasta la pestaña más ancha; ¿su rectángulo cabe dentro del de `.screen-tabs`? | no cabe (`visible_en_barra: false`) | regla 6 para T1 |
| M6 | Líneas base de PRUEBAS d: md5 de los CSV de (i) comparador con cinco entidades fijas (una por clase), (ii) panorama actual del SLEP foco en 4° básico 2025, (iii) ficha del primer establecimiento del roster de 4b 2025 | tres md5 registrados | congela T2 |
| M7 | **Caso malo de T2:** en la vista histórica del panorama (SLEP foco, 4° básico), `document.querySelectorAll('.export-bar').length` | `0` | regla 6 para T2 |
| M8 | Líneas base de 🔒8 en los dos modos | las del log s33d | congela T1 y T2 |
| M9 | Calibración del testigo de T4 contra lo publicado: `grep -c` de la cadena candidata (el nombre de la constante de columnas nueva, `CSV_HIST_COLS`) en `docs/index.html` y en el motor actual | `0` y `0` | se elige otra cadena nueva y exclusiva, y se registra |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: la pestaña enfocada se desplaza hasta verse entera (A-2 de s33d)

1. Paso 0: relee M5.
2. Edición: en el botón `.screen-tab`, un manejador `onFocus` que llama a `e.currentTarget.scrollIntoView({block:"nearest",inline:"nearest"})`. Nada más cambia (no se acortan rótulos ni se cambia el CSS).
3. Verificación (con ventana y headless): M5 repetido: a 320 px, tras el Tab, el rectángulo de la pestaña queda dentro del de `.screen-tabs`; a 1280 px no hay desplazamiento de la página (`scrollY` y `scrollX` iguales antes y después del Tab); 🔒8.
4. Commit `fix(motor): la pestana enfocada se desplaza hasta verse entera (s33e T1, A-2 de s33d)`.

### T2: exportación CSV de la vista histórica (pendiente 4 de v31)

1. Paso 0: relee M4, M6 y M7; lee `PanoramaHistorico`, `rosterHistorico`, `filasPanoramaCSV`, `descargarPanoramaCSV` y `estadoVsGse` completos.
2. Edición:
   - Constante `CSV_HIST_COLS`, junto a `CSV_PAN_COLS`: `rbd, establecimiento, comuna, dependencia, gse_ultimo, gse_ultimo_label, anio, gse_anio, gse_anio_label, indicador, indicador_label, puntaje, estado_vs_gse, nivel, preliminar`. `gse_ultimo` es el GSE con el que la pantalla agrupa (el de la fila de `rosterHist`); `gse_anio` es el GSE de ese año (`anios[y]`), contra el que se mide el estado de ese año.
   - Constructor `filasHistoricoCSV({grupos,conDato,grado})`: recorre **los mismos** `grupos` y `conDato` que dibuja `PanoramaHistorico` (en el orden en que se dibujan), y para cada fila, cada año de `conDato` y cada indicador de `DATA.indicadores` escribe una fila: puntaje con `numCSV` desde `porAnio[y][ind.id]` (vacío si no hay), estado con `estadoVsGse`, `preliminar` como en `filasPanoramaCSV`. Una fila por establecimiento, año e indicador; **ninguna fila agregada**.
   - Conteo para `confirmarTamano`: `DATA.indicadores.length × conDato.length × Σ grupos.items.length`.
   - Botón `IconExport` con rótulo "Exportar CSV", **dentro de `PanoramaHistorico`** (que es quien tiene `grupos` y `conDato`), en una `div.export-bar` al final de `.vt-ctl`; deshabilitado si no hay filas; `title` con `nEE` del total visible. Nombre del archivo: `idps_panorama_historico_<territorio>_<nivel>` + el mismo sufijo de GSE que usa `descargarPanoramaCSV` + `.csv`. `PanoramaHistorico` recibe por prop lo que necesita para el nombre (texto del territorio y selección de GSE), sin recalcular nada.
   - Comentario de dos líneas sobre el constructor: `// s33e: CSV de la vista historica (pendiente 4 de v31). Recibe los mismos grupos y anios` / `// que dibuja PanoramaHistorico (regla de fidelidad de s30); una fila por EE, anio e indicador.`
3. Verificación (con el instrumento de M4; `esperado:` antes):
   - T2.1 M7 repetido: `1` en la vista histórica; en la vista actual, la barra de siempre sigue (`1`).
   - T2.2 🔒7 en tres casos: SLEP foco 4° básico con todos los GSE; el mismo con un solo GSE; una comuna fuera del foco en 2° medio. Número de filas, 30 celdas contra pantalla y parquet (en R), estado por `estadoVsGse`.
   - T2.3 cero agregación: en R, `rbd` nunca vacío y ninguna fila con `rbd` repetido para el mismo `anio` e `indicador`.
   - T2.4 Excel en español: el separador y el decimal son los mismos que los de los CSV existentes (misma función `aCSV`, `numCSV`).
   - T2.5 🔒6 (PRUEBAS d) y 🔒3; hash §8.2; PRUEBAS b.
   - T2.6 nacional: con el territorio nacional en la vista histórica, el botón existe, `confirmarTamano` avisa (se registra el número de filas) y, aceptado, el archivo se genera sin error (se cuentan sus filas en R).
4. Commit `feat(motor): exportacion CSV de la vista historica del panorama (s33e T2, pendiente 4)`.

### T3: enmienda §3.10 de la decisión

1. Edición: al final de la decisión, una línea nueva: `**Enmienda s33e (2026-09-24):** la vista histórica se exporta con su propio botón dentro de la vista (una fila por establecimiento, año e indicador, con el GSE de ese año y el último); el punto 10 de §3 queda superado. Decisión del titular en la sesión 33.` No se edita el punto 10 original.
2. Verificación: `grep -c 'Enmienda s33e'` = 1; `git diff -U0 --stat` de la decisión: 1 archivo, solo inserciones. No tocó código.
3. Commit `docs(decision): enmienda s33e, exportacion de la vista historica (s33e T3)`.

### T4: build

1. `git status --porcelain` → **solo el motor y el LOG**; otra ruta congela T4.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b y d; 🔒7 en un caso y 🔒8 sobre el motor commiteable; hash §8.2 = M3.
3. Testigo para el despliegue: la cadena de M9 (≥ 1 en el motor nuevo, 0 en `docs/index.html`).
4. md5 del motor nuevo registrado. Commit `build(motor): s33e CSV de la vista historica`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M4, M5, M7, M9) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo. En particular, el número de filas del CSV se re-deriva en R **desde el parquet** (roster del territorio y nivel, GSE visibles, años con dato), sin leer el CSV ni el motor; y 30 celdas nuevas, con otra semilla.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b, c y d sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol (por ejemplo, un CSV con una celda alterada debe fallar la comparación con el parquet).
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; filas y celdas de 🔒7; md5 de los CSV de PRUEBAS d); decisiones del titular registradas; dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33e_priv.sh`) → vacío, con control plantado; **ningún RBD con número, nombre de establecimiento ni fila de CSV en el log** (solo conteos, md5 y nombres de columna); los casos se nombran por territorio y nivel; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33e CSV de la vista historica"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; testigo y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; columnas del CSV nuevo y filas por caso; resultado de 🔒7; testigo y md5 para el despliegue; lo que queda al titular para el gate visual (en la vista histórica, el botón y un CSV abierto en Excel); "lo que falló o sorprendió; si nada, decirlo".
