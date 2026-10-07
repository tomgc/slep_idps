# Encargo autónomo: leyendas del preliminar, censo sin hora y despliegue (s32c)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie que termina en un acto de efecto público; `encargo_autonomo_claude_code_v1.md` §2.12, filas 1 y 2).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `30_procesamiento/32_censo_insumos.R`; `00_build.R`; `40_salidas/motor_idps.html`; `40_salidas/intermedios/censo_insumos.md`; `docs/index.html`; `50_documentacion/andamios/logs/20260923_registro_asistente_s32.md`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
- **LOG:** `50_documentacion/andamios/logs/20260923_leyendas_censo_despliegue_s32c_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `9185ec6`), y los escribe en el encabezado del log.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0 y 0 warnings; (b) Puppeteer sobre el motor por `file://`: 0 errores de consola y 0 `pageerror` tras cargar, abrir los dos modales y abrir una ficha; (c) hash del payload con la **convención §8.2 de s29** (JSON descomprimido con `fecha_generacion` normalizada a `0000-00-00`).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; localizar código por marcadores, no por número de línea.

### Gate del titular (condición de T4)

T4 (despliegue) corre **solo** si el mensaje con el que el titular lanzó este encargo contiene literalmente `GATE APROBADO`. Sin esa cadena, T4 queda congelada como "pendiente del gate visual" y el resto se ejecuta igual.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` con alguna ruta fuera de {este encargo, `50_documentacion/andamios/logs/20260923_registro_asistente_s32.md`} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo y sus descendientes (este encargo no toca datos).
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo y del registro de errores (`chore(encargo): s32c; docs(log): error #4 del asistente`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras el cierre de fase.
- En T4, solo con `GATE APROBADO` y T3 completada: `cp 40_salidas/motor_idps.html docs/index.html`, y commit `deploy(docs): …` con **solo** `docs/index.html`.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s32c_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. Ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `9185ec6` (fuente: reporte del push de s32b); se re-mide en FASE 0.
- `50_documentacion/andamios/logs/20260923_registro_asistente_s32.md` quedó modificado sin commitear: el redactor agregó la fila 4, y ahora tiene 4 filas (fuente: `grep -c '^| [0-9] |'` del redactor → 4).
- Ya no hay ningún año preliminar en 4b ni en 2m: `anios_preliminar` vacío (fuente: bloque J y T2.3 del log s32b).
- En la plantilla hay **dos** textos sobre el asterisco escritos sin condición (fuente: `grep` del redactor):
  - la leyenda de la vista histórica del panorama territorial (~L2692): `<span>* resultado preliminar</span>`;
  - la glosa `.ficha-explain` de la vista histórica de la ficha (~L1495): "El signo * al lado del año indica el carácter preliminar de los resultados, según lo informado por la Agencia."
- La nota de la vista de barras (~L1512) ya condiciona el mismo texto con `anios.some(a=>PRELIM.has(String(a)))`; es el patrón que se replica (fuente: `grep` del redactor). En `PanoramaHistorico` existe `prelimY=y=>PRELIM.has(String(y))` (~L2677) y el eje del grado (`eje`, `conDato`).
- `32_censo_insumos.R` escribe `"- Fecha: "` con `format(Sys.time(), "%Y-%m-%d %H:%M:%S")` (~L197), y por eso todo `run_all()` completo reescribe `40_salidas/intermedios/censo_insumos.md` aunque el censo no cambie (fuente: `grep` del redactor; D-2 y A-3 del log s32b).
- `docs/index.html` tiene md5 `6c5feab5428ed05dff09867f2b47bba3` y no contiene `check-row:focus-visible` (fuente: M3 y M12 del log s32; hipótesis de que siga igual, se mide en FASE 0).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. Interfaz en `30_procesamiento/35_motor_template.html`; `00_build.R` orquesta los pasos 31 a 35. `docs/index.html` es el sitio publicado en GitHub Pages; el despliegue es copia byte a byte del motor más un commit propio que toca solo ese archivo.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (script `/tmp/s32c_payload_sha.sh`).
2. **Paletas intactas:** md5 del `:root` igual antes y después (script `/tmp/s32c_root_md5.sh`), y el diff de la plantilla sin colores literales agregados ni borrados (expresión dentro de un script).
3. **El estado se lee de `sigdifgru`:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/31* 30_procesamiento/33* 30_procesamiento/34* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0` (T2 toca solo `32_censo_insumos.R`).
5. **Despliegue fiel** (si T4 corre): `md5 -q docs/index.html` = `md5 -q 40_salidas/motor_idps.html`, y el commit de despliegue toca solo `docs/index.html` (`git show --name-only --format= <hash>` → 1 línea).

## 4. Grafo de tareas y ALCANCE

- **T1** (textos del asterisco condicionales) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (censo sin hora) · ALCANCE: `30_procesamiento/32_censo_insumos.R`, `40_salidas/intermedios/censo_insumos.md`.
- **T3** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 **o** T2 completada.
- **T4** (despliegue) · ALCANCE: `docs/index.html`. Requiere T3 completada y `GATE APROBADO`.
- Serie: T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: commitear el encargo y el registro de errores (autorización de FASE 0). Segundo acto: crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real; grafo; "sin subagentes"; topes; si el mensaje de lanzamiento traía `GATE APROBADO`), el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición con `esperado:` escrito **antes** y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain` tras el primer commit; `git stash list` | vacío; vacío | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD` hijo de `9185ec6`; `0`; `1` | regla 2 |
| M3 | hash §8.2 del payload del motor; calibración con dos copias en `/tmp`: una con `fecha_generacion` alterada (debe dar el **mismo** hash) y otra con una cifra plantada (debe dar **otro**) | 64 hex; igual; distinto | congela T3 y T4 |
| M4 | md5 del `:root` | un md5 | congela T1 |
| M5 | `grep -n` de los dos textos del asterisco (§1) y del patrón condicional de ~L1512 | 2 textos sin condición y 1 con condición | congela T1 |
| M6 | **caso malo de T1**, en Puppeteer sobre el motor actual: la leyenda de la vista histórica territorial (SLEP foco, 4b) y la glosa de la vista histórica de una ficha contienen el texto del asterisco | ambas lo contienen | si no, congela T1 y registra |
| M7 | `grep -c 'Fecha: ' 40_salidas/intermedios/censo_insumos.md` y la línea literal | `1`, con hora `HH:MM:SS` | congela T2 |
| M8 | `md5 -q docs/index.html`; `grep -c 'check-row:focus-visible' docs/index.html` | `6c5feab5428ed05dff09867f2b47bba3`; `0` | registra (cambia el testigo de T4) |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: el asterisco solo se explica cuando existe

**Meta:** ninguna leyenda ni glosa explica el asterisco del preliminar si ningún año visible es preliminar, y si alguno lo es, la explicación vuelve igual que antes.

1. Paso 0: lee los dos textos y el patrón de ~L1512.
2. Implementación:
   - Leyenda del panorama (~L2692): el `<span>* resultado preliminar</span>` se dibuja solo si algún año del eje del grado es preliminar (`conDato.some(y=>prelimY(y.agno))` o la forma equivalente según las variables en ámbito).
   - Glosa de la ficha (~L1495): la oración del asterisco se incluye solo si algún año de la serie de esa ficha es preliminar, con el mismo patrón que ~L1512. El resto de la glosa queda literal.
   - Comentario de una línea en cada sitio: "s32c: el asterisco solo se explica si algún año visible es preliminar (patrón de la nota de barras)".
3. Verificación (build temporal, `esperado:` antes):
   - T1.1 **caso que lo motivó:** en el motor nuevo, la leyenda de la vista histórica territorial (SLEP foco, 4b y 2m) y la glosa de la ficha no contienen "resultado preliminar" ni "carácter preliminar".
   - T1.2 **caso bueno plantado:** en una copia en `/tmp` del motor nuevo, con `DATA.meta.anios_preliminar=[2025]` inyectado en `page.evaluate` antes del render (o con la copia del payload modificada fuera del árbol), los dos textos vuelven a aparecer.
   - T1.3 caso malo: M6.
   - Hash §8.2 igual a M3 (🔒1).
4. Cierre de fase en cinco pasos; commit `fix(motor): el asterisco solo se explica si hay año preliminar (s32c T1)`.

## 7. T2: el censo deja de sellar la hora

**Meta:** un `run_all()` sin cambios en los insumos deja `censo_insumos.md` byte-idéntico.

1. Implementación en `32_censo_insumos.R` (~L197): reemplaza la línea de fecha y hora por una que no dependa del reloj. Si el documento necesita una marca, usa la fecha de modificación más reciente de los insumos censados (derivada del dato, no del reloj) y documenta el cambio en un comentario de una línea ("s32c: git registra cuándo cambió el censo; el reloj ensuciaba el árbol en cada build (D-2 s32b)"). Actualiza la línea `# Fecha` del encabezado del script solo si la convención del proyecto lo pide.
2. Verificación:
   - T2.1 `run_all()` dos veces seguidas: `md5` de `censo_insumos.md` igual entre ambas corridas, y `git status --porcelain` después de la segunda muestra solo los archivos del ALCANCE de T1 a T3 (ningún derivado desfasado).
   - T2.2 **caso malo:** el `censo_insumos.md` de `9185ec6` (`git show 9185ec6:40_salidas/intermedios/censo_insumos.md`) contiene `HH:MM:SS`; el nuevo no.
   - T2.3 el resto del censo (conteos, tablas) es idéntico al de `9185ec6` salvo la línea de fecha (`diff` literal al log).
3. Cierre de fase; commit `fix(pipeline): censo_insumos sin hora de build (s32c T2)` con las dos rutas del ALCANCE.

## 8. T3: build

1. `git status --porcelain` → solo `40_salidas/motor_idps.html` o vacío.
2. Build (PRUEBAS a), PRUEBAS b completa; T1.1 repetido sobre el motor commiteable; hash §8.2 igual a M3.
3. Commit `build(motor): s32c leyendas del preliminar`.

## 9. T4: despliegue (solo con `GATE APROBADO`)

1. Si el mensaje de lanzamiento no traía `GATE APROBADO`, congela T4 con la duda "¿aprobó el titular el gate visual sobre el motor de T3?" y pasa a FASE R.
2. `cp` del motor a `docs/index.html`.
3. Verificación: md5 igual en los dos archivos (🔒5); md5 de `docs/index.html` distinto de `6c5feab5…`; **testigo del build nuevo:** `grep -c 'check-row:focus-visible' docs/index.html` ≥ 1 (en el `docs/` anterior daba 0, M8).
4. Commit `deploy(docs): motor s32 (teclado, plurales, definitivos 2025 y leyendas)` con **solo** `docs/index.html`.

## 10. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando, los casos malos y plantados (T1.2, T1.3, T2.2) y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (el texto de T1 por `grep` sobre el HTML renderizado con `page.content()` además de la consulta por selector; el md5 de T4 con `shasum -a 256` además de `md5`; el censo de T2 con `cmp` además de `md5`).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG, el encargo y el registro de errores de FASE 0); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol, que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, despliegue no fiel, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Si una reparación toca la plantilla después de T4, el despliegue queda desfasado: se registra como BLOQUEA de T4 y no se vuelve a desplegar en este encargo.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 11. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; md5 de `docs/` antes y después); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: "según la condición del encargo; resultado en el reporte final".
4. Privacidad: grep de RUT sobre el log con un script (`/tmp/s32c_priv.sh`) → vacío; ningún RBD ni nombre de establecimiento o de persona; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s32c leyendas, censo y despliegue"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; si `docs/` quedó desplegado, con su md5; hash del commit `docs(log)`.

## 12. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; md5 de `docs/index.html` publicado; lo que queda al titular (abrir el sitio publicado con recarga forzada y confirmar el testigo); "lo que falló o sorprendió; si nada, decirlo".
