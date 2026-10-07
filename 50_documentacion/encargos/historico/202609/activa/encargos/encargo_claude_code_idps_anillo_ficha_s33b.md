# Encargo autónomo: anillo de foco legible sobre la barra de la ficha (s33b)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; el log `50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md` (instrumentos y líneas base de s33); el registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (sin seguimiento; entra en el primer commit).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33b_*`); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Las pruebas de foco corren **con ventana** (`headless: false`) **y** en headless. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_anillo_ficha_s33b_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33b` es `<inicio>` para todos los diffs de este encargo.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33 (`/tmp/s33_pruebas_b.sh` o su equivalente reescrito): 0 errores de consola y 0 `pageerror` con los dos modales, una ficha con vista histórica y una comparación; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (este encargo no toca datos).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas (nunca `-A` ni `.`); ningún comentario CSS con `*/` interno; **ningún color hex en comentarios ni en código nuevo**: el anillo usa un token existente.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el registro s33, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. M5 no reproduce el caso malo (el anillo de `.ficha-name` ya llega a 3:1 sobre la barra) → congela T1 y regístralo.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, en un solo commit (`chore(encargo): s33b y registro del asistente s33`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33b_*`; lectura y copia de los `/tmp/s33_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto: el despliegue va en un bloque aparte, tras el gate visual del titular), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `5fb3170` (commit `docs(log)` de s33) (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24).
- Motor `40_salidas/motor_idps.html` = `5a83f63cec4a5bfaf1213e554512ac64`; `docs/index.html` = `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor el 2026-09-24).
- La plantilla tiene una sola regla para los dos respaldos, precedida por un comentario de una línea: `/* s33: respaldo del foco al cerrar EntityModal cuando su boton de origen ya no existe (A-1 de s32e). */` y `.ficha-name:focus-visible,.cmp-cl:focus-visible{outline:2px solid var(--foco);outline-offset:2px;}`, justo después de `.check-row:focus-visible` (fuente: `sed` del redactor).
- `.ficha-name` vive dentro de `.ficha-bar`, cuyo fondo es `var(--azul)` y cuyo color de texto es `var(--cream)`; el propio `.ficha-name` tiene `color:var(--cream)` (fuente: `sed` y `grep -n` del redactor).
- En el `:root`: `--azul:#0A3A5C`, `--cream:#FFF6E0`, `--foco:#0062A0` (fuente: `grep -n` del redactor).
- El anillo actual de `.ficha-name` da 1,84:1 contra el fondo de la barra, y el de `.cmp-cl` da 5,99:1 contra su fondo; `--cream` sobre `--azul` daría 11,01:1 (fuente: log s33, FASE R, paso 2b y hallazgo A-2). Se vuelven a medir en FASE 0 (M5).
- Los instrumentos de s33 (`/tmp/s33_payload_sha.sh`, `/tmp/s33_root_md5.sh`, `/tmp/s33_hex.sh`, `/tmp/s33_sig.sh`, `/tmp/s33_r_foco.js`, `/tmp/s33_foco.js`, `/tmp/s33_l6.js`, `/tmp/s33_pruebas_b.sh`, `/tmp/s33_build.sh`) siguen en `/tmp`: hipótesis (se mide en FASE 0; si faltan, se reescriben desde el log s33 y se calibran).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS (React 18 UMD, JSX transpilado en el navegador). En s33 (T4) el foco pasó a un respaldo cuando el botón que abrió el modal desaparece: el contador `.cmp-cl` del comparador o el nombre `.ficha-name` de la ficha. La auditoría de s33 (A-2) midió que el anillo de `.ficha-name`, en `--foco`, casi no se ve sobre la barra azul oscura de la ficha. El titular decidió pasarlo a `--cream`, un token existente que ya es el color de texto de esa barra. El anillo de `.cmp-cl` no cambia. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (`/tmp/s33b_payload_sha.sh`).
2. **Paletas intactas y sin hex nuevo:** (a) md5 del bloque `:root` igual al de FASE 0 (`/tmp/s33b_root_md5.sh`); (b) `/tmp/s33b_hex.sh` sobre `git diff -U0 <inicio>..HEAD -- 30_procesamiento/35_motor_template.html`, solo líneas cambiadas: **agregadas = 0; borradas = 0**.
3. **El estado se lee de `sigdifgru`:** `/tmp/s33b_sig.sh` sobre el mismo diff, solo líneas cambiadas: **borradas = 0; agregadas = 0**.
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **El foco sigue llegando donde llegaba:** script de 🔒6 de s33 (`/tmp/s33_l6.js`: ciclo y devolución de s32e) y el de destinos de s33 (`/tmp/s33_foco.js`: `tope_listo`, `tope_escape`, `tope_fondo`, `terr_ee`, `desmarcar`) dan, antes (FASE 0) y después (T2 y FASE R), los mismos destinos en los dos modos.
7. **El anillo de `.cmp-cl` no cambia:** con 10 de 10 y cierre con Escape, `outline` calculado de `.cmp-cl` = `solid 2px rgb(0, 98, 160)`, igual que en FASE 0 (M5).

## 4. Grafo de tareas y ALCANCE

- **T1** (anillo de `.ficha-name` en `--cream`) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 completada.
- Serie: T1 → T2. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre, aunque una tarea quede congelada.

**Excluidos de la cadena (con razón):** pendientes 6 y 8 del traspaso v31 (desborde de pestañas; desmarcar con tope): se proponen al titular aparte, para no mezclar con la corrección que precede al gate; 3 (divergencia 39 vs 24: exige decidir el texto); 5 (base pequeña: umbral sin fijar); el resto, por las razones del encargo s33 §4.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado del encargo y del registro. Segundo acto: crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real de la sesión; grafo; "sin subagentes"; topes), el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto de secciones. Cada medición con `esperado:` escrito **antes** del comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain` tras el primer commit; `git stash list`; `git show --name-only --format= HEAD` | solo el LOG (o vacío); vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD` y `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `5fb3170` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos (copiar los `/tmp/s33_*` a `/tmp/s33b_*`; si faltan, reescribirlos desde el log s33). md5 del motor; hash §8.2; calibración con fecha alterada (igual) y cifra plantada (distinto) | `5a83f63c…`; `eb4e00b3…4dc4`; igual; distinto | si la calibración falla, congela T2 |
| M4 | md5 y líneas del `:root` | `65` líneas, `04b2876e…` | congela T1 |
| M5 | **Caso malo de T1**, con ventana y en headless: con `/tmp/s33_r_foco.js` (o su copia), `terr_liceo` y `cmp_region` sobre el motor actual: destino, `outline` calculado del destino y contraste WCAG del color del anillo contra el fondo opaco del ancestro más cercano | `DIV.ficha-name`, `solid 2px rgb(0, 98, 160)`, **1,84** sobre `rgb(10, 58, 92)`; `SPAN.cmp-cl`, `solid 2px rgb(0, 98, 160)`, 5,99 sobre `rgb(255, 246, 224)` | regla 6 si `.ficha-name` ya da ≥ 3 |
| M6 | En la plantilla: `grep -c 'ficha-name:focus-visible'`; `grep -c 'cmp-cl:focus-visible'`; `grep -c -- '--cream:'` | `1`; `1`; `1` | congela T1 |
| M7 | Líneas base de 🔒6: `/tmp/s33_l6.js` (`ciclo_terr,ciclo_cmp,devol`) y `/tmp/s33_foco.js` (`tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar`) sobre el motor actual, en los dos modos | los resultados de s33 T5 y FASE R: `terr N353 Tab 0/1 Shift 0/1 \| cmp N7 Tab 0/2 Shift 0/1 \| devol origen 10 de 10 \| espacio_reabre False \| fondo cierra True/True \| errores 0`; destinos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add` | congela T1 |
| M8 | Calibración de 🔒2(b) y 🔒3 sobre una copia en `/tmp`: (i) caso bueno: la copia con la edición de §6.2 aplicada, `diff -U0` original→copia; (ii) caso malo: la misma copia con el anillo escrito en hex (`outline:2px solid #FFF6E0`) y una línea `/* sigdifgru */` agregada | (i) hex +0/−0, `sigdifgru` +0/−0; (ii) hex +1, `sigdifgru` +1 | si un script no dispara en (ii) o dispara en (i), corrígelo **antes** de T1 y registra la corrección; no se ajusta el esperado |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: anillo de `.ficha-name` en `--cream` (A-2 de s33)

**Meta:** el anillo de foco del nombre de la ficha se distingue sobre la barra azul (≥ 3:1); el del contador del comparador no cambia.

1. Paso 0: relee M5, M6 y M7.
2. Edición (nada más cambia): la regla compartida se separa en dos, en el mismo lugar y bajo el mismo comentario, que pasa a decir `/* s33: respaldo del foco al cerrar EntityModal cuando su boton de origen ya no existe (A-1 de s32e); s33b: en la ficha el anillo va en crema porque la barra es azul oscuro (A-2 de s33). */`:
   - `.cmp-cl:focus-visible{outline:2px solid var(--foco);outline-offset:2px;}`
   - `.ficha-name:focus-visible{outline:2px solid var(--cream);outline-offset:2px;}`
3. Verificación (build temporal con `run_all(only = 35L)`; con ventana **y** headless; `esperado:` antes):
   - T1.1 **caso que lo motivó:** `terr_liceo` (y `terr_ee`, con Enter): destino `DIV.ficha-name`, `outline` `solid 2px rgb(255, 246, 224)`, contraste contra el fondo opaco de la barra **≥ 3** (se espera 11,01).
   - T1.2 🔒7: `cmp_region` y `tope_escape`: destino `SPAN.cmp-cl`, `outline` `solid 2px rgb(0, 98, 160)`, 5,99 (= M5).
   - T1.3 🔒6: los dos scripts de M7 dan lo mismo que en FASE 0, en los dos modos.
   - T1.4 caso malo: M5 sobre el motor de FASE 0 (guardado en `/tmp/s33b_motor_fase0.html`) sigue dando 1,84.
   - T1.5 🔒2(b) y 🔒3 sobre el árbol (`git diff -U0 <inicio> -- <plantilla>` pasado como archivo): hex +0/−0, `sigdifgru` +0/−0; md5 del `:root` igual a M4; hash §8.2 igual a M3; PRUEBAS b sin errores.
4. Cierre de fase en cinco pasos; commit `fix(motor): anillo de foco en crema sobre la barra de la ficha (s33b T1, A-2 de s33)`.

## 7. T2: build

1. `git status --porcelain` → **solo el motor y el LOG** (el build temporal de T1 deja el motor modificado; el LOG se commitea en FASE L). Otra ruta congela T2.
2. Build con PRUEBAS a (`run_all()` completo); después, porcelain igual al del paso 1. PRUEBAS b completa; T1.1, T1.2 y 🔒6 repetidos sobre el motor commiteable; hash §8.2 igual a M3.
3. Testigo para el despliegue: `grep -c 'outline:2px solid var(--cream)' 40_salidas/motor_idps.html` = 1 y `grep -c 'outline:2px solid var(--cream)' docs/index.html` = 0; `grep -c 'focoRespaldo'` en el motor ≥ 1.
4. md5 del motor nuevo, distinto de `5a83f63c…`, registrado para el despliegue.
5. Commit `build(motor): s33b anillo de foco de la ficha`.

## 8. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M8, T1.4) y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (el contraste del anillo recalculado en Python desde los hex del `:root`; el destino del foco con `:focus` además de `activeElement`, por otra ruta de teclado; los conteos con `awk`).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG, el encargo y el registro s33, commiteados en `<inicio>`); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol que demuestre que el instrumento dispara (por ejemplo, una copia del motor con el anillo de la ficha devuelto a `var(--foco)` debe dar 1,84).
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 9. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; anillo y contraste de los dos respaldos antes y después); decisiones del titular registradas (A-2 y A-1 de s33: sí); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: "según la condición del encargo; resultado en el reporte final".
4. Privacidad: grep de RUT sobre el log con un script que guarda el patrón fuera del log (`/tmp/s33b_priv.sh`, patrón `[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento o de persona (los nombres de acción de los instrumentos, como `terr_liceo`, no cuentan); la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s33b anillo de foco de la ficha"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; el testigo y el md5 para el despliegue; hash del commit `docs(log)`.

## 10. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; anillo y contraste de `.ficha-name` y `.cmp-cl` antes y después; testigo y md5 para el despliegue; lo que queda al titular (gate visual, con teclado: en el comparador, 10 de 10 y Escape, anillo azul en el contador; en el modal de territorio, elegir un establecimiento con Enter, anillo crema visible alrededor del nombre sobre la barra azul); "lo que falló o sorprendió; si nada, decirlo".
