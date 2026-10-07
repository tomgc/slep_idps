# Encargo autónomo: las filas del modal caben en la lista (s33i)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (una edición y un build en serie; `encargo_autonomo_claude_code_v1.md` §2.12, fila 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; los logs de s33c y s33g en `50_documentacion/andamios/logs/` (instrumentos del modal, del censo de cifras y de capturas).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33i_*`); `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Con ventana, esperar el elemento visible antes de la primera acción. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_filas_modal_s33i_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s33i y registro del asistente s33` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33: 0 errores de consola y 0 `pageerror`; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0; (d) los cuatro CSV de s33f M6 byte-idénticos.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; ningún color hex nuevo; los textos de las filas no cambian (decisión de s33c: cada cifra nombra su universo).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. M5 no reproduce el caso malo → congela T1 y regístralo.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (fila 6 agregada por el redactor), en un solo commit.
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33i_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `52a757f`, el `docs(log)` de s33g (fuente: `.git/refs` leídos por el redactor el 2026-09-24). Motor `2a436756f8a4dff35b203b246eb022eb`; `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor).
- El registro del asistente s33 tiene 6 filas; la fila 6 la agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- **Defecto visto por el titular en el gate visual** (capturas del modal del comparador, pestaña SLEP, 2 de 10 marcados): la fila es más ancha que la lista; aparece una barra de scroll horizontal dentro de `.comuna-checklist`; el `sub` ("Traspaso 2026 · 6 comunas · 63 establecimientos en el directorio") queda cortado a la derecha; el nombre ("SLEP Aconcagua") se parte en dos líneas; y, al desplazar, el fondo de la fila marcada (`.is-checked`) no llega hasta el final del texto (fuente: capturas del titular en esta sesión).
- Reglas CSS de la fila (fuente: `grep -n` del redactor): `.modal{…max-width:540px;…}`; `.comuna-checklist{display:flex;flex-direction:column;…overflow-y:auto;}`; `.check-row{display:flex;align-items:center;gap:10px;padding:7px 11px;…}`; `.check-name{flex:1 1 auto;…}`; `.check-region{flex:0 0 auto;font-size:var(--fs-caption);color:var(--gris);}`. Con `flex:0 0 auto`, el `sub` no cede ancho y empuja la fila (causa probable: hipótesis, se mide en FASE 0, M5).
- El texto del `sub` creció en s33c (T1: "… en el directorio"; T2: "Traspaso AAAA · …" en el comparador) (fuente: log s33c).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. `EntityModal` dibuja las filas de las cinco pestañas de los dos modales con las mismas clases. El arreglo es de reparto del ancho de la fila, no de texto. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas cambiadas del diff `-U0` de la plantilla: **agregadas = 0**.
3. **`sigdifgru` intacto:** líneas cambiadas con `sigdifgru`: **0/0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Textos y cifras de las filas sin cambio:** el `textContent` de cada fila de las cinco pestañas de los dos modales (búsqueda vacía y "viña") es idéntico antes y después.
7. **Foco y teclado siguen iguales:** los scripts de ciclo, devolución y respaldos dan lo mismo que en el log s33g, en los dos modos.
8. **Exportaciones intactas:** PRUEBAS d.

## 4. Grafo de tareas y ALCANCE

- **T1** (reparto del ancho de la fila) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 completada.
- Serie: T1 → T2. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `52a757f` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*`); hash §8.2 con calibración; md5 del `:root` y del motor | `eb4e00b3…4dc4`; igual con la fecha alterada; distinto con la cifra plantada; `2a436756…` | congela T2 si la calibración falla |
| M4 | Líneas base de 🔒6 (textos de filas), 🔒7 y PRUEBAS d | registradas | congela T1 |
| M5 | **Caso malo de T1**, con ventana y headless, a 1280 × 800 y a 390 × 800: en los dos modales, en las cinco pestañas (búsqueda vacía; en Establecimiento, "viña"), y en el comparador con 2 SLEP marcados: `scrollWidth` frente a `clientWidth` de `.comuna-checklist`; por fila, ancho de `.check-row`, `.check-name` y `.check-region`, número de líneas del nombre (alto / `line-height`) y si el fondo de `.is-checked` cubre todo el ancho de su contenido | en la pestaña SLEP del comparador: `scrollWidth` > `clientWidth`, `.check-region` sin encoger, nombre en 2 líneas; se registra qué otras pestañas desbordan | regla 6 |
| M6 | Capturas de referencia a 1280 × 800 del modal del comparador en las cinco pestañas y del modal de territorio en Comuna y SLEP | PNG de referencia (para el informe; no es 🔒) | — |
| M7 | Calibración del testigo de T2 contra lo publicado y el motor actual: `grep -c -F` de la cadena nueva que introduzca T1 (fijarla antes de editar, por ejemplo el comentario `s33i: el sub cede ancho`) | `0` en `docs/index.html` y `0` en el motor actual | se elige otra cadena nueva y exclusiva, y se registra |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: el `sub` cede ancho y la fila nunca supera la lista

1. Paso 0: relee M5.
2. Edición mínima, solo CSS de la fila, con esta intención: (i) ninguna fila supera el ancho de la lista en ninguna pestaña ni ancho; (ii) el nombre no se parte mientras quepa en una línea, y el `sub` es lo primero que cede (se parte en dos líneas, alineado a la derecha, antes que el nombre); (iii) el fondo de la fila marcada cubre la fila entera. Punto de partida: `.check-region{flex:0 1 auto;min-width:0;text-align:right;}` y `.check-name{min-width:0;}`, con la proporción que haga falta para cumplir (ii), medida y no supuesta. Si la lista necesita `overflow-x:hidden` para no mostrar una barra fantasma, se agrega y se justifica con la medición. Comentario de una línea con la cadena de M7.
3. Verificación (con ventana y headless; `esperado:` antes): M5 repetido: `scrollWidth` = `clientWidth` en todas las listas y anchos; en la pestaña SLEP del comparador a 1280, el nombre de cada SLEP en una línea y el `sub` completo (visible, sin corte) en una o dos líneas; el fondo de `.is-checked` con el ancho de la fila; 🔒6; 🔒7; la fila Chile (`.is-nac`) sigue igual en su pestaña; PRUEBAS b.
4. Commit `fix(motor): las filas del modal caben en la lista; el sub cede ancho (s33i T1)`.

### T2: build

1. `git status --porcelain` → **solo el motor y el LOG**; otra ruta congela T2.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b y d; 🔒6 y 🔒7 sobre el motor commiteable; hash §8.2 = M3.
3. Testigo para el despliegue: la cadena de M7 (≥ 1 en el motor nuevo, 0 en `docs/index.html`).
4. md5 del motor nuevo registrado. Commit `build(motor): s33i filas del modal`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M7) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (desborde por `getBoundingClientRect().right` de cada `.check-region` frente al de la lista; otro ancho intermedio, 540 px; el modal de territorio además del comparador).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG, el encargo y el registro); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b, c y d sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** el motor anterior (M3) debe volver a dar desborde con el mismo instrumento.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; anchos antes y después por pestaña); decisiones del titular registradas (gate visual de s33 a s33g: aprobado salvo las filas del modal; N-1 de s33g: no se toca); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33i_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el log (nombres de SLEP, comuna y región sí); la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33i filas del modal"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; testigo y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; anchos antes y después por pestaña y modal; testigo y md5 para el despliegue; lo que queda al titular para el gate visual (el mismo modal de sus capturas: comparador, pestaña SLEP, con dos marcados); "lo que falló o sorprendió; si nada, decirlo".
