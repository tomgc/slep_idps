# Encargo autónomo: coherencia del modal y del comparador (s33c)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; el hermano `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html` (solo lectura; **referencia vinculante** para el modal, regla s29h); los logs de s33 y s33b en `50_documentacion/andamios/logs/` (instrumentos y líneas base).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33c_*`); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Las pruebas de teclado y foco corren **con ventana** (`headless: false`) **y** en headless. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_modal_comparador_s33c_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33c` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33 (`/tmp/s33_pruebas_b.sh` o su equivalente reescrito): 0 errores de consola y 0 `pageerror`; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (este encargo no toca datos).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; ningún comentario CSS con `*/` interno; **ningún color hex nuevo** (solo tokens existentes); todo conteo visible pasa por `nEE`/`nCom`; mayúsculas sostenidas solo en siglas.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. Un caso malo de FASE 0 (M5 a M8) no se reproduce → la tarea que lo corrige se omite y se registra; las demás siguen.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33c`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33c_*`; lectura y copia de los `/tmp/s33_*` y `/tmp/s33b_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `c6162c4`, el `docs(log)` de s33b (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24). Motor `a41d9400f0fc85b183103b68af31063d`; `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor). Líneas base de s33b para 🔒7: ciclo `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10` (fuente: log s33b, FASE R).
- `EntityModal` dibuja un encabezado `.modal-header` con solo el título `h2.modal-title`; el CSS del encabezado ya usa `justify-content:space-between` (fuente: `sed` y `grep -n` del redactor). No hay botón de cierre en el encabezado; se cierra con Escape, clic en el fondo, Listo o Cancelar (fuente: `sed` del redactor; log s32e).
- El buscador (`input.input-search`, `autoFocus`) se dibuja en todas las pestañas, también en Nacional, cuyo placeholder es "Sin búsqueda: Chile es la única opción" (fuente: `sed` del redactor, `searchPlaceholderFor`).
- En modo múltiple, una fila está deshabilitada si no está marcada y se alcanzó el tope; la clave de la fila incluye la dependencia vigente del selector (`keyEnt({kind,cod,dep:depEfectiva})`) (fuente: `sed` del redactor). Que con 10 de 10, al cambiar el selector de dependencia, ninguna fila quede marcada y no se pueda desmarcar nada desde el modal es hipótesis (pendiente 8 del traspaso v31; se mide en FASE 0, M8).
- Pestaña SLEP del modal de territorio: `sub` = "Traspaso AAAA" (fuente: `sed`, `buildList`). Pestaña SLEP del comparador: `sub` = `nCom(ncom)+" · "+nEE(ee)`, conteos de `SLEPS_OPTS`, que cuenta el **directorio** (`DATA.establecimientos`) (fuente: `sed`, `_listaCmpEnt` y `SLEPS_OPTS`).
- `NACIONAL_OPT.sub` = "Nivel nacional · " + comunas + establecimientos del **directorio** (fuente: `sed` del redactor).
- La meta del chip del comparador (`metaChip`) usa comunas y establecimientos del **roster** del nivel y año (`metas`, D-s8-4) (fuente: `sed` del redactor). Por eso un mismo SLEP da 39 en la fila del modal y 24 en el chip (fuente: traspaso v31 §3; las cifras se re-miden en FASE 0, M6).
- Si los constructores CSV (`filasComparadorCSV` y otros) usan `metaChip` o los `sub` de las filas es hipótesis (se mide en FASE 0, M9).
- Qué hace el hermano con el botón ✕ del encabezado, con "Traspaso AAAA" en sus dos modales y con el buscador en su pestaña Nacional es hipótesis (se mide en FASE 0, M4).

**Decisiones del titular que este encargo implementa (sesión 33):** pendiente 3 → **cada texto nombra su universo** (no se unifican cifras); divergencias 6 y 10 del modal con el hermano y el buscador del tab Nacional → se alinean al hermano (regla s29h, referencia vinculante); pendiente 8 → se resuelve en esta cadena.

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS (React 18 UMD, JSX transpilado en el navegador). `EntityModal` sirve al modal de territorio (selección simple) y al del comparador (múltiple, tope 10). Desde s32e el modal retiene el foco; desde s33, si el botón de origen desaparece, el foco va a un respaldo. Invariante mayor del proyecto: **cero agregación**; este encargo no crea ninguna cifra: solo dice de qué universo viene cada una. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (`/tmp/s33c_payload_sha.sh`).
2. **Paletas intactas y sin hex nuevo:** (a) md5 del `:root` igual al de FASE 0; (b) hex en líneas cambiadas de `git diff -U0 <inicio>..HEAD -- <plantilla>`: **agregadas = 0**.
3. **El estado se lee de `sigdifgru`:** líneas cambiadas con `sigdifgru` en el mismo diff: **0/0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Ninguna cifra nueva ni cambiada:** censo (`/tmp/s33c_censo.js`) de los números visibles en las filas de las cinco pestañas de los dos modales (con la búsqueda vacía y con "viña"), en los chips del comparador con cinco entidades fijas (una por clase) y en el banner del panorama con el territorio foco: el multiconjunto de números por elemento es **idéntico** antes (FASE 0) y después (T6). Los textos pueden cambiar; los números no.
7. **Foco y teclado de s32e y s33 siguen funcionando:** el script de ciclo y devolución (`/tmp/s33_l6.js`) y el de respaldos (`/tmp/s33_foco.js`). Esperado después: devolución al origen 10 de 10; respaldos iguales a FASE 0; y en el ciclo, el número de enfocables `N` **crece exactamente en los controles nuevos** que agregan T3 (el ✕, uno por modal) y T5 (los botones de quitar, solo con el tope alcanzado), sin pasos fuera del modal.

## 4. Grafo de tareas y ALCANCE

Todas con ALCANCE `30_procesamiento/35_motor_template.html`, salvo T6 (`40_salidas/motor_idps.html`). Comparten archivo: van en serie T1 → T2 → T3 → T4 → T5 → T6. Lógicamente, T1 a T5 son independientes entre sí (el fallo de una no congela a las otras); T6 requiere al menos una completada. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

**Excluidos (con razón):** el aviso de dependencia que solo se dispara con SLEP (s29i): no hay decisión sobre cuándo debe dispararse; la exportación CSV histórica y la de imagen: van en su propio encargo; accesibilidad del hover de ✕ y la barra de pestañas bajo 425 px: van en el encargo de accesibilidad.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado con meta, fecha, repo, rama, hash de inicio, ENTORNO, `EJECUCIÓN:` y modo real, grafo, "sin subagentes", topes; slot `## J. Juicio (lo rellena FASE L)`; esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD`; `git log -1 --format=%s HEAD~1` | `HEAD~1` = `c6162c4` = `origin/main`; `0`; `1`; `docs(log): s33b anillo de foco de la ficha` | regla 2 si `HEAD~1` ≠ `origin/main`; si solo difiere el mensaje, se registra |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*` a `/tmp/s33c_*`; si faltan, reescribirlos desde el log s33); hash §8.2 con calibración (fecha alterada igual, cifra plantada distinta); md5 y líneas del `:root`; md5 del motor | `eb4e00b3…4dc4`; igual; distinto; `65` líneas y `04b2876e…` en el `:root`; motor `a41d9400…` | congela T6 si la calibración falla |
| M4 | **Lectura del hermano**, con líneas literales: (i) ¿su modal tiene un botón de cierre en el encabezado? marcado, `aria-label`, texto y clase; (ii) ¿qué `sub` muestran las filas de SLEP en cada uno de sus modales (¿"Traspaso AAAA"?); (iii) ¿su pestaña Nacional dibuja buscador?; (iv) ¿cómo resuelve el tope con desmarcado (lista de seleccionadas, fila fija, otro)? | se registra lo que haya, con número de línea | si el archivo no existe, T2, T3 y T4 usan la especificación de §6 y se registra |
| M5 | Instrumento `/tmp/s33c_censo.js` (🔒6) sobre el motor actual, con su control positivo (una copia del motor con un conteo plantado debe dar un multiconjunto distinto) | censo registrado; el plantado difiere | congela T1 |
| M6 | Caso malo de T1: en el comparador, la fila del SLEP foco en la pestaña SLEP y, tras agregarlo, su chip; y en la pestaña Nacional, la fila de Chile y, tras agregarla, su chip. Texto literal de cada uno | la fila dice N₁ establecimientos y el chip N₂ ≠ N₁, **sin decir de qué universo es cada cifra** | regla 6 para T1 |
| M7 | Casos malos de T3 y T4: (i) en los dos modales, `document.querySelectorAll('.modal-header button').length`; (ii) en la pestaña Nacional de los dos modales, `document.querySelectorAll('.modal .input-search').length` | `0`; `1` | regla 6 para la tarea respectiva |
| M8 | **Caso malo de T5**, con ventana y headless: en el comparador, llegar a 10 de 10 con "Todas las dependencias", cambiar el selector de dependencia a otra categoría (en la pestaña Comuna) y registrar: filas marcadas visibles, filas habilitadas, y si existe algún control dentro del modal para quitar una entidad ya elegida | 0 marcadas; 0 habilitadas; ningún control para quitar | regla 6 para T5 |
| M9 | `grep -n` de `metaChip`, `NACIONAL_OPT.sub` y `.sub` dentro de los constructores CSV (`filasComparadorCSV`, `filasPanoramaCSV`, `filasFichaCSV`) | se registra si algún CSV usa esos textos | si alguno los usa, T1 registra el cambio de texto en el CSV (no es un 🔒) |
| M10 | Líneas base de 🔒7 en los dos modos (ciclo con `N`, devolución, respaldos) | los valores de s33b | congela T3 y T5 |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: cada cifra dice de qué universo viene (pendiente 3)

1. Paso 0: relee M5, M6 y M9.
2. Edición (solo textos; ningún conteo nuevo):
   - Fila SLEP del **comparador** (`_listaCmpEnt`): `nCom(s.ncom)+" · "+nEE(s.ee)+" en el directorio"`.
   - `NACIONAL_OPT.sub`: `"Nivel nacional · "+nCom(coms.size)+" · "+nEE(ee)+" en el directorio"`.
   - Meta del chip de un territorio o de Chile (`metaChip`): el texto actual seguido de `" con IDPS en "+DATA.meta.grados[<grado del comparador>]+" "+<año del comparador>` (usa las mismas variables con las que el chip ya se calcula; no se agrega dependencia de nada nuevo).
   - Banner del panorama: si su conteo de establecimientos no dice ya el nivel y el año (M5), se le agrega el mismo sufijo con las variables del panorama; si ya lo dice, no se toca y se registra.
   - Comentario de una línea: `// s33c: la fila cuenta el directorio y el chip el roster del nivel y año; cada texto nombra su universo (pendiente 3 de v31).`
3. Verificación (build temporal; `esperado:` antes): T1.1 M6 repetido: la fila dice "… en el directorio" y el chip "… con IDPS en <nivel> <año>", con los **mismos números** que en M6; T1.2 🔒6 idéntico a M5; T1.3 PRUEBAS b sin errores; hash §8.2 = M3; hex +0.
4. Cierre de fase; commit `fix(motor): cada conteo nombra su universo, directorio o roster (s33c T1, pendiente 3)`.

### T2: "Traspaso AAAA" alineado al hermano (divergencia 10 de s29 §36.7)

1. Paso 0: relee M4 (ii).
2. Edición: si el hermano muestra "Traspaso AAAA" en las filas de SLEP de **los dos** modales, la fila SLEP del comparador pasa a `"Traspaso "+(s.anio!=null?s.anio:"—")+" · "+<texto de T1>`. Si el hermano lo muestra solo en el de territorio (igual que aquí), no se edita nada y la divergencia se registra como resuelta por coincidencia. Si no lo muestra en ninguno, no se edita (la etiqueta es regla de dominio de este motor) y se registra como duda con pregunta cerrada.
3. Verificación: texto literal de la fila antes y después; 🔒6.
4. Commit (si hubo cambio) `fix(motor): Traspaso AAAA en la fila SLEP del comparador, como el hermano (s33c T2)`.

### T3: botón ✕ de cierre en el encabezado (divergencia 6)

1. Paso 0: relee M4 (i), M7 (i) y M10.
2. Edición: en `.modal-header`, después del título, un `<button type="button">` con el texto `✕`, `aria-label="Cerrar"`, `title="Cerrar"` y la clase del hermano si la tiene (si no, `modal-x`). Acción: en modo múltiple, la misma que Listo (`onDone||onCancel`); en modo simple, `onCancel`. Estilo con tokens existentes (sin hex), foco visible con el mismo patrón `:focus-visible` de las demás reglas del modal. Queda dentro del ciclo de foco (`_enfocablesModal` lo toma por ser `button`).
3. Verificación (con ventana y headless): T3.1 M7 (i) = `1` en los dos modales; T3.2 clic y Enter sobre ✕ cierran, y el foco vuelve al origen (o al respaldo con el origen desaparecido); T3.3 🔒7: `N` del ciclo = `N` de M10 + 1 en cada modal, 0 pasos fuera; devolución 10 de 10 más las vías nuevas (clic y Enter en ✕); T3.4 Enter sostenido sobre ✕ no reabre (el descarte de R-11 cubre el destino).
4. Commit `feat(motor): boton de cierre en el encabezado del modal, como el hermano (s33c T3, divergencia 6)`.

### T4: la pestaña Nacional no dibuja buscador

1. Paso 0: relee M4 (iii) y M7 (ii).
2. Edición: `EntityModal` gana la prop `sinBuscadorFor=null` (función `tab => bool`). Cuando devuelve verdadero, en vez del `input` se dibuja `<p className="modal-hint">` con el texto que hoy es el placeholder de esa pestaña. Los dos usos de `EntityModal` pasan `sinBuscadorFor={tab=>tab==="nacional"}`. Estilo de `.modal-hint` con tokens existentes (`--gris`, tamaño de cuerpo). El `autoFocus` sigue en el `input` cuando existe; al cambiar a Nacional, el foco queda en el botón de la pestaña.
3. Verificación: M7 (ii) = `0` en los dos modales; la fila de Chile sigue siendo elegible con clic y teclado; 🔒7 (el ciclo en la pestaña Nacional tiene un enfocable menos que antes, y se registra).
4. Commit `fix(motor): la pestana Nacional no dibuja buscador, como el hermano (s33c T4)`.

### T5: con el tope alcanzado, se puede quitar una entidad desde el modal (pendiente 8)

1. Paso 0: relee M4 (iv) y M8.
2. Edición: si el hermano resuelve el caso (M4 iv), se replica su mecánica y se citan sus líneas. Si no, `EntityModal` gana la prop `seleccionadosInfo=[]` (arreglo de `{kind,cod,dep,nom}`). En modo múltiple y **solo con el tope alcanzado**, sobre la lista se dibuja una franja `.modal-sel` con el texto "Llegaste al tope de 10. Quita una para agregar otra:" y un botón por entidad elegida, con el nombre y `✕`, `aria-label` igual al de `.cmp-x` ("Quitar " + nombre + dependencia si la hay). El botón llama a `onSelect` con esa entidad (el `addTerr` actual la quita por su clave `kind|cod|dep`). El comparador pasa `seleccionadosInfo={cmpTerr}`. Estilo con tokens existentes.
3. Verificación (con ventana y headless): T5.1 M8 repetido: con 10 de 10 y el selector cambiado, la franja existe, un botón quita una entidad (contador 9 de 10) y las filas vuelven a habilitarse; T5.2 con menos de 10 la franja no existe; T5.3 🔒7: los botones de la franja entran al ciclo (`N` crece en 10 con el tope, en 0 sin él); T5.4 el chip del comparador desaparece al quitar la entidad; T5.5 🔒6 idéntico.
4. Commit `fix(motor): con el tope alcanzado se puede quitar una entidad desde el modal (s33c T5, pendiente 8)`.

### T6: build

1. `git status --porcelain` → **solo el motor y el LOG**; otra ruta congela T6.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b; 🔒6 y 🔒7 sobre el motor commiteable; hash §8.2 = M3.
3. Testigo para el despliegue: `grep -c 'en el directorio' 40_salidas/motor_idps.html` ≥ 1 y en `docs/index.html` = 0.
4. md5 del motor nuevo registrado. Commit `build(motor): s33c modal y comparador`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M6, M7, M8) y el alcance global. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (textos por `innerText` y por `textContent`; conteos del censo recalculados en Python desde el volcado; el tope y el desmarcado por otra ruta de teclado y otra dependencia).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; censo de 🔒6 antes y después); decisiones del titular registradas (pendiente 3: cada texto nombra su universo); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33c_priv.sh`, patrón `[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento o de persona; los nombres de comuna, región o SLEP sí pueden aparecer (son territorio público); la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33c modal y comparador"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; testigo y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; textos antes y después (fila SLEP, fila Chile, chips, banner); lo que el hermano hacía en cada punto (M4); testigo y md5 para el despliegue; lo que queda al titular para el gate visual; "lo que falló o sorprendió; si nada, decirlo".
