# Encargo autónomo: el foco se queda dentro del modal (s32e)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; el hermano `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html` (solo lectura).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema). Las pruebas de teclado corren **con ventana** (`headless: false`) y además en headless: el gate de s32 mostró que headless puede no reproducir lo que ve el titular. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`.
- **LOG:** `50_documentacion/andamios/logs/20260923_foco_modal_s32e_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `f5ae215`), y los escribe en el encabezado del log.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y árbol limpio salvo el ALCANCE; (b) Puppeteer sobre el motor por `file://`: 0 errores de consola y 0 `pageerror` tras cargar, abrir y cerrar los dos modales, abrir una ficha y armar una comparación; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (`eb4e00b3…`; este encargo no toca datos).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; localizar código por marcadores, no por número de línea.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s32e`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras el cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s32e_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto: el despliegue va tras el gate visual del titular), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `f5ae215` (fuente: reporte del push de s32d y `.git/refs/heads/main` leído por el redactor).
- `EntityModal` es el único componente con `role="dialog"` en la plantilla; su caja `.modal` declara `role="dialog" aria-modal="true" aria-label={title}` dentro de un `.modal-backdrop` fijo (~L1606-1607) (fuente: `grep -n 'role="dialog"'` y `sed` del redactor).
- Hoy el modal: cierra con Escape por un listener de `window` (~L1592 de la versión leída); pone el foco inicial en el buscador con `autoFocus`; **no** retiene el foco: tras la última parada, Tab sale a la página de fondo, cuyo primer control activo es una tarjeta `role="button" tabIndex={0}` (fuente: log s32, A-3 y D-2, y auditoría del redactor sobre ese log).
- Al cerrar el modal, si el foco vuelve al botón que lo abrió (`.terr-trigger` o el botón de agregar entidad del comparador) es hipótesis (se mide en FASE 0).
- Los controles enfocables del modal, en orden de documento, son: botones de pestaña (`.modal-tab`), buscador, selector de dependencia (si `depVisible`), filas `.check-row` con `tabIndex` 0 (y -1 las deshabilitadas) y el botón del pie (Listo o Cancelar) (fuente: `sed` del redactor sobre `EntityModal`).
- El hermano tiene su propio modal (regla s29h: referencia vinculante); si retiene el foco y cómo, es hipótesis (se mide en FASE 0).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS (React 18 UMD, JSX transpilado en el navegador). Interfaz en `30_procesamiento/35_motor_template.html`. `EntityModal` se usa en dos lugares: modal de territorio (selección simple) y modal del comparador (múltiple con tope). `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (script `/tmp/s32e_payload_sha.sh`).
2. **Paletas intactas:** md5 del `:root` igual antes y después (script `/tmp/s32e_root_md5.sh`), y el diff de la plantilla sin colores literales agregados ni borrados (expresión dentro de un script).
3. **El estado se lee de `sigdifgru`:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Lo que ya funcionaba sigue funcionando:** Enter y Espacio sobre una fila eligen (simple) o conmutan (múltiple); las filas deshabilitadas se saltan; Escape cierra. Comando: el script de verificación de s32 T2 (o uno equivalente escrito en FASE 0) corrido antes y después, con el mismo resultado.

## 4. Grafo de tareas y ALCANCE

- **T1** (foco retenido y devuelto) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 completada.
- Serie: T1 → T2. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: commitear el encargo. Segundo acto: crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real; grafo; "sin subagentes"; topes), el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto. Cada medición con `esperado:` escrito **antes** y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain` tras el primer commit; `git stash list` | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD` hijo de `f5ae215`; `0`; `1` | regla 2 |
| M3 | hash §8.2 del payload; calibración con dos copias en `/tmp`: fecha alterada (mismo hash) y cifra plantada (otro hash) | `eb4e00b3…`; igual; distinto | congela T2 |
| M4 | md5 del `:root` | un md5 | congela T1 |
| M5 | **Caso malo de T1**, con ventana y en headless, en los dos modales: abre el modal, presiona Tab N+3 veces (N = número de controles enfocables del modal, contado en el DOM) y registra tras cada Tab si `document.activeElement` está dentro de `.modal`; repite con Shift+Tab desde el buscador | el foco sale del modal hacia el fondo con Tab y con Shift+Tab | si no sale, congela T1 y registra |
| M6 | Al cerrar cada modal (Escape, Listo o Cancelar, y elegir una fila), ¿a qué elemento vuelve el foco? | a `body` o a un elemento que no es el botón que abrió el modal | si ya vuelve al botón, T1 omite la parte de devolución y lo registra |
| M7 | Lectura del hermano: si su modal retiene el foco y devuelve el foco al cerrar, con líneas literales | se registra lo que haya | si el archivo no existe, T1 sigue con §6 y se registra |
| M8 | Script de 🔒6 sobre el motor actual | Enter/Espacio eligen o conmutan, las deshabilitadas se saltan, Escape cierra | congela T1 |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: el foco se queda dentro del modal y vuelve a su origen al cerrar

**Meta:** con el modal abierto, Tab y Shift+Tab recorren solo los controles del modal, en ciclo; al cerrarlo por cualquier vía, el foco vuelve al botón que lo abrió.

1. Paso 0: relee M5 a M8.
2. Implementación en `EntityModal` (si el hermano lo resuelve, replica su mecánica y cita sus líneas):
   - Un `ref` sobre `.modal`. Un `keydown` para Tab que, si el foco está en el último enfocable, lo lleva al primero, y con Shift+Tab en el primero lo lleva al último. Los enfocables se calculan en el momento de la tecla (la lista cambia con la pestaña, la búsqueda y el tope): controles no deshabilitados y elementos con `tabIndex >= 0`, en orden de documento, visibles.
   - Si el foco llega a quedar fuera del modal mientras está abierto (clic en el fondo sin cerrar, por ejemplo), el siguiente Tab lo devuelve al primer enfocable.
   - Al montar, se guarda `document.activeElement` como elemento de origen; al desmontar, si ese elemento sigue en el documento, se le devuelve el foco.
   - Escape y el foco inicial en el buscador quedan como están. Nada cambia en el orden de Tab dentro del modal (sigue una parada por fila; D-3 de s32 se mantuvo).
   - Comentario de una línea: "s32e: aria-modal=true promete que el foco no sale; aquí se cumple (D-2 de s32)".
3. Verificación (build temporal con `run_all(only = 35L)`; con ventana **y** headless; `esperado:` antes):
   - T1.1 **caso que lo motivó:** en los dos modales, N+3 Tab y N+3 Shift+Tab dejan siempre `document.activeElement` dentro de `.modal`, y tras el último enfocable el siguiente Tab cae en el primero.
   - T1.2 la lista cambia: en el modal del comparador, al cambiar de pestaña y al escribir en el buscador, el ciclo sigue cerrado; con el tope lleno, las filas deshabilitadas no entran al ciclo.
   - T1.3 devolución: al cerrar con Escape, con Cancelar o Listo, y eligiendo una fila, el foco queda en `.terr-trigger` (modal de territorio) o en el botón que abrió el comparador.
   - T1.4 🔒6: el script de M8 da el mismo resultado.
   - T1.5 clic en el fondo: si cierra el modal (comportamiento actual), el foco vuelve al origen; si no cierra, el siguiente Tab vuelve al modal.
   - T1.6 caso malo: M5 sobre el motor anterior (el foco sale).
   - Hash §8.2 igual a M3.
4. Cierre de fase en cinco pasos; commit `fix(motor): el foco se queda en el modal y vuelve a su origen (s32e T1)`.

## 7. T2: build

1. `git status --porcelain` → solo `40_salidas/motor_idps.html` o vacío.
2. Build (PRUEBAS a), PRUEBAS b completa; T1.1 y T1.3 repetidos sobre el motor commiteable; hash §8.2 igual a M3.
3. Testigo para el despliegue futuro: una cadena literal del código nuevo (la del comentario de T1, por ejemplo) con `grep -c` = 1 en el motor nuevo y 0 en `docs/index.html`.
4. Commit `build(motor): s32e foco retenido en el modal`.

## 8. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando, los casos malos y plantados (M3, M5, T1.6) y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (el ciclo de foco de T1 con `document.activeElement` y además con `:focus` en `querySelector`, en el otro modal y en otra pestaña del modal).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol, que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 9. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; secuencias de foco antes y después en los dos modales); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: "según la condición del encargo; resultado en el reporte final".
4. Privacidad: grep de RUT sobre el log con un script (`/tmp/s32e_priv.sh`) → vacío; ningún RBD ni nombre de establecimiento o de persona; la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s32e foco retenido en el modal"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; el testigo del despliegue de T3; hash del commit `docs(log)`.

## 10. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; secuencias de foco antes y después (con ventana y headless) en los dos modales; testigo del despliegue; lo que queda al titular (gate visual: Tab y Shift+Tab dentro de los dos modales, y al cerrar el foco vuelve al botón); "lo que falló o sorprendió; si nada, decirlo".
