# Encargo autónomo: contraste del texto sobre la paleta de indicador (§5.6, s32g)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`; el mockup aprobado `50_documentacion/andamios/diseno/detalles/mockup_contraste_paleta_indicador_s56.html` (sin commitear; FASE 0 lo commitea).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
- **LOG:** `50_documentacion/andamios/logs/20260923_contraste_paleta_indicador_s32g_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `e96ef6a`), y los escribe en el encabezado del log.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y árbol limpio salvo el ALCANCE; (b) Puppeteer sobre el motor por `file://`: 0 errores de consola y 0 `pageerror` tras cargar, abrir una ficha en vista actual e histórica, pasar el mouse por una barra histórica y armar una comparación; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (`eb4e00b3…`; este encargo no toca datos).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; localizar código por marcadores, no por número de línea.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` con alguna ruta fuera de {este encargo, el mockup, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo y del mockup (`chore(encargo): s32g y mockup §5.6`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras el cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s32g_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto: el despliegue va tras el gate visual del titular), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `e96ef6a` (fuente: reporte del push de s32f y `.git/refs/heads/main` leído por el redactor).
- **Decisión del titular (2026-09-23):** en el título "¿Qué mide este indicador?" se aplica la **opción B** del mockup: texto en `--tinta` y un filete vertical de 4 px del color del indicador a la izquierda (fuente: mensaje del titular, "B").
- Las cuatro superficies de §5.6 y sus ratios de hoy, calculados por el redactor con la fórmula WCAG 2.1 sobre los hex de la plantilla (fuente: script del redactor; se re-miden en el navegador en FASE 0):
  1. `.defn-title` con `style={{color}}` = `ind.color` (componente `Definicion`, ~L868, llamado con `color={ind.color}` ~L1394): Autoestima 6,79; Clima 2,19; Participación 3,07; Hábitos 1,84 sobre `#ffffff`.
  2. Etiqueta de `DistBar` (~L996-1001): el color sale de `_txtOn` (~L1157); falla solo el nivel alto de Clima, `#4c939a`, con blanco (3,53). Con la regla de mayor contraste entre negro, `--gris` y blanco (`vtTexto`, ~L2643-2650, junto a `contrasteWCAG` ~L2634), los 12 tonos quedan entre 4,75 y 15,09; en `#4c939a`, el negro da 5,95. **Esto corrige §5.6 de la decisión de contraste, que decía que en ese tono "ningún color de texto alcanza 4,5"** (medía `#2e2710`, no `#000000`).
  3. `.ybar-sig.de/.al/.nt` (~L398) y `.hist-trend.de/.al/.nt` (~L421) usan los colores de barra `--destaca`/`--alerta`/`--st-neutro`: sobre el fondo del track (`#f6f5f6`) dan 3,20 / 3,78 / 3,23. Con los tokens de texto existentes (`--destaca-txt`, `--alerta-txt`, `--st-neutro-txt`, ~L51) dan 5,00 / 5,16 / 5,06.
  4. La línea "vs GSE" del tooltip de la barra histórica (~L1284-1289) se pinta con `var(--destaca)`/`var(--alerta)`/`var(--st-neutro)` sobre `#23303a` (`.tt`): 3,88 / 3,28 / 3,85. En blanco (`#ffffff`, el color de `.tt`): 13,50.
- Las superficies 2 a 4 no piden decisión: usan reglas o tokens que ya existen (mockup, secciones 2 a 4).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. Interfaz en `30_procesamiento/35_motor_template.html`. La paleta de INDICADOR (`--ind1..4`, `ind.color`) y la de ESTADO son invariantes: no se tocan sus hex. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (script `/tmp/s32g_payload_sha.sh`).
2. **Paletas intactas:** md5 del `:root` igual antes y después (script `/tmp/s32g_root_md5.sh`), y el diff de la plantilla sin colores hex literales agregados (expresión dentro de un script; `#000000` y `#ffffff` ya existen en el código de `vtTexto` y del tooltip y no cuentan como nuevos si no aparecen en líneas agregadas).
3. **El estado se lee de `sigdifgru`:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **El color sigue presente donde era señal:** el `.indp-dot` y las barras de indicador conservan `ind.color` (`grep` de sus estilos antes y después, idénticos).

## 4. Grafo de tareas y ALCANCE

- **T1** (título, opción B) · **T2** (etiqueta de `DistBar`) · **T3** (glifos y tendencia) · **T4** (línea del tooltip) · ALCANCE de las cuatro: `30_procesamiento/35_motor_template.html`. Independientes en lógica; comparten archivo, así que van en serie T1 → T2 → T3 → T4, un commit por tarea.
- **T5** (enmienda de la decisión de contraste) · ALCANCE: `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`. Requiere que T1 a T4 hayan cerrado (completadas o congeladas), porque registra su resultado.
- **T6** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere al menos una de T1 a T4 completada.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: commitear el encargo y el mockup. Segundo acto: crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real; grafo; "sin subagentes"; topes), el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición con `esperado:` escrito **antes** y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain` tras el primer commit; `git stash list` | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD` hijo de `e96ef6a`; `0`; `1` | regla 2 |
| M3 | hash §8.2 del payload; calibración con dos copias en `/tmp`: fecha alterada (mismo hash) y cifra plantada (otro hash) | `eb4e00b3…`; igual; distinto | congela T6 |
| M4 | md5 del `:root` | un md5 | congela T1 a T4 |
| M5 | **Casos malos**, en el navegador sobre el motor actual, con colores computados (`getComputedStyle`) y fondo efectivo compuesto: ratio de `.defn-title` en los cuatro indicadores; de la etiqueta de `DistBar` en el nivel alto de Clima (busca un establecimiento con ≥ 9 % en ese nivel); de un `.ybar-sig` de cada clase y de un `.hist-trend` de cada clase presentes; del `span` coloreado de la línea "vs GSE" del tooltip (fuérzalo con un `mousemove` sobre una barra con `difgru`) | Clima 2,19, Participación 3,07, Hábitos 1,84; `DistBar` 3,53; glifos y tendencia < 4,5; tooltip < 4,5 (± 0,05 respecto de §1) | una cifra que ya cumpla congela su tarea y se registra |
| M6 | Calibración del instrumento de contraste: `#000000`/`#ffffff` → 21,00; `#777777`/`#ffffff` → 4,48 | 21,00; 4,48 | detén T1 a T4 (instrumento no confiable) |
| M7 | `vtTexto` y `contrasteWCAG`: su ámbito (¿están a nivel de módulo o dentro de un componente?) y si `DistBar` puede llamarlos | a nivel de módulo, invocables en render | si no, T2 los mueve a nivel de módulo sin cambiar su lógica y lo registra |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: título en tinta con filete del color (opción B)

1. `Definicion` deja de pintar el texto con `color`: el título va en `--tinta` (la clase ya lo declara) y, si recibe `color`, lleva `border-left:4px solid <color>; padding-left:7px` (estilo inline con el mismo `color`; sin hex nuevos). Comentario de una línea: "s32g: opción B de §5.6 (titular); el color del indicador pasa del texto al filete".
2. Verificación: T1.1 los cuatro títulos a ≥ 4,5 con colores computados; T1.2 el filete tiene el `ind.color` de cada indicador (`getComputedStyle(...).borderLeftColor`); T1.3 la definición de dimensión (`etiqueta="Sobre esta dimensión"`, sin `color`) queda igual que antes, sin filete; T1.4 caso malo M5.
3. Commit `fix(motor): título de indicador en tinta con filete del color (s32g T1, opción B)`.

## 7. T2: la etiqueta de `DistBar` usa la regla de mayor contraste

1. En `DistBar`, el color de la etiqueta pasa de `_txtOn(c)` a `vtTexto(c)` (o al nombre compartido que M7 indique). `_txtOn` se conserva si otro componente lo usa; si queda sin uso, se deja con un comentario y se registra como duda (no se borra código en este encargo).
2. Verificación: T2.1 los 12 tonos de `nivelRamp` de los cuatro indicadores, recalculados en el navegador con el color que elige `vtTexto`: todos ≥ 4,5, y el alto de Clima con negro (≈ 5,95); T2.2 el `title` de cada segmento no cambia; T2.3 caso malo M5.
3. Commit `fix(motor): etiqueta de DistBar por mayor contraste (s32g T2)`.

## 8. T3: glifos de la vista histórica y tendencia con tokens de texto

1. `.ybar-sig.de/.al/.nt` y `.hist-trend.de/.al/.nt` pasan a `var(--destaca-txt)`, `var(--alerta-txt)` y `var(--st-neutro-txt)`. Suma estos dos selectores al comentario del inventario de usos de los tokens `-txt` del `:root` (hoy cinco usos; quedan siete).
2. Verificación: T3.1 cada clase presente ≥ 4,5 sobre su fondo efectivo; T3.2 el `title` y el glifo no cambian; T3.3 caso malo M5.
3. Commit `fix(motor): glifos y tendencia de la vista histórica con tokens de texto (s32g T3)`.

## 9. T4: la línea "vs GSE" del tooltip en blanco

1. En el constructor del tooltip de la barra histórica, la línea "vs GSE: ▲/▼/= … · sig./n.s." deja de llevar `style='color:…'` y hereda el blanco de `.tt`. El texto no cambia. Comentario de una línea: "s32g: los tokens -txt son para fondo claro; sobre .tt el estado lo dicen el glifo y sig./n.s.".
2. Verificación: T4.1 con el tooltip forzado, la línea tiene color computado `rgb(255, 255, 255)` y ratio 13,50 sobre `#23303a`; T4.2 el texto de la línea es idéntico al de antes (compara `textContent`); T4.3 caso malo M5.
3. Commit `fix(motor): línea vs GSE del tooltip en blanco (s32g T4)`.

## 10. T5: enmienda de la decisión de contraste

1. En §5.6 del archivo de decisión, agrega al final de la sección el bloque **"Resuelto el 2026-09-23 (s32g)"** con: la opción B elegida por el titular sobre el mockup (ruta del mockup); la corrección de la premisa sobre `#4C939A` (el negro da 5,95, así que la regla de mayor contraste de §3.5 resuelve `DistBar` sin extender §3.4); los tokens `-txt` aplicados a `.ybar-sig` y `.hist-trend`; la línea del tooltip en blanco; y una tabla antes/después con los ratios medidos en T1 a T4 (copiados del log, no recalculados a mano). Cambia el título de §5.6 de "BACKLOG, pide mockup y aprobación del titular" a "RESUELTO el 2026-09-23 (s32g)". Si alguna tarea quedó congelada, la sección lo dice y no se marca como resuelta esa parte.
2. Verificación: `git diff --stat` = 1 archivo; el diff solo agrega texto y cambia el título de §5.6.
3. Commit `docs(decision): §5.6 resuelta (s32g)`.

## 11. T6: build

1. `git status --porcelain` → solo `40_salidas/motor_idps.html` o vacío.
2. Build (PRUEBAS a), PRUEBAS b completa; T1.1, T2.1, T3.1 y T4.1 repetidos sobre el motor commiteable; hash §8.2 igual a M3.
3. Testigo para el despliegue futuro: el comentario de T1 ("opción B de §5.6") con `grep -c` = 1 en el motor nuevo y 0 en `docs/index.html`.
4. Commit `build(motor): s32g contraste sobre la paleta de indicador`.

## 12. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M6 y los casos malos de T1 a T4) y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (cada ratio de T1 a T4 recalculado en R además de en el navegador, sobre los colores computados).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG, el encargo y el mockup); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol, que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 13. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; ratios antes y después por superficie); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: "según la condición del encargo; resultado en el reporte final".
4. Privacidad: grep de RUT sobre el log con un script (`/tmp/s32g_priv.sh`) → vacío; ningún RBD ni nombre de establecimiento o de persona; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s32g contraste sobre la paleta de indicador"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; el testigo del despliegue de T3; hash del commit `docs(log)`.

## 14. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; tabla de ratios antes/después por superficie; testigo del despliegue; lo que queda al titular (gate visual: título con filete en los cuatro indicadores, barra de niveles de Clima, glifos de la vista histórica y tooltip); "lo que falló o sorprendió; si nada, decirlo".
