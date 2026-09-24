# Log de sesión: despliegue a docs/ del motor de s33 a s33i (s33h)

- **Meta:** copiar a `docs/index.html` (lo que publica GitHub Pages) el motor `40_salidas/motor_idps.html` que pasó el gate visual del titular (`7ad76f36e42d66c4da2d71aa28a558eb`, lleva s33 a s33i), verificar que la copia es idéntica y funciona, y commitearla (T1). No se toca código.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `4684a48` (= `origin/main`, `docs(log)` de s33i). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_despliegue_s33h.md` (única); `git stash list` vacío; `HEAD=4684a48 origin/main=4684a48`; `HEAD..origin/main=0`, `origin/main..HEAD=0`; motor `7ad76f36e42d66c4da2d71aa28a558eb`, `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (= premisas de §1). Primer acto (autorizado): commit `77af1b6` chore(encargo): s33h, hijo de `4684a48` (`1 file changed, 104 insertions(+)`). **PUNTO DE RETORNO `<inicio>` = `77af1b6`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); `bash` 3.2 explícito (los testigos con llaves y comillas viven en un archivo de patrones en `/tmp/s33h_*`); `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular mandan sobre el modo: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_despliegue_s33h.md` (commit `77af1b6`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (copia, verificación y commit)   ALCANCE: docs/index.html
FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato: acto de efecto público).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33h_*`: copias de los de s33i para §8.2 (`payload_sha.sh`, `payload_norm.js`, `fecha_alterada.js`, `plantar_payload.js`, `r_payload.py`), PRUEBAS b (`pruebas_b.sh` y los tres `s32_*.js`), la exportación CSV (`csv.js`, `csv_contar.R`) y privacidad (`priv.sh`, con la ruta de este log); medido: 0 restos de `s33i_`. Convenciones: **un `esperado:` y un `obtenido:` por comando**; una corrección va como `- **Corrección:** …`; los patrones de privacidad viven solo en su script; ningún RBD con número ni nombre de establecimiento en el log.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: `docs/index.html` es ahora el motor aprobado en el gate (`7ad76f36e42d66c4da2d71aa28a558eb`, de s33 a s33i), idéntico byte a byte, con el payload intacto y funcionando (modales, ficha, comparación y CSV histórico sin errores).
- Estado por tarea: FASE 0 completada · T1 completada (`ec17e17`) · FASE R APROBADO · FASE L completada.
- Commits: 3, rango `77af1b6`..`<docs(log)>` (`git log --oneline 4684a48..HEAD`), de los cuales 0 fix(auditoria), 0 build(motor) y 1 deploy(docs).
- Auditoría (FASE R): APROBADO; hallazgos B/R/A = 0/0/0; reparados 0; abiertos 0; control positivo 1 de 1 (un byte plantado).
- Invariantes: 3/3 PASA (🔒1 §8.2 `eb4e00b3…` en `docs/`; 🔒2 solo `docs/index.html`; 🔒3 md5 `7ad76f36…`, SHA-256 igual al motor); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual antes y después del despliegue, re-derivado en Python y en node; CSV histórico `856071a8…` desde `docs/`).
- Decisiones autónomas de mayor riesgo: (1) los testigos con llaves y comillas leídos desde un archivo de patrones (bash 3.2); (2) PRUEBAS b ampliada con la exportación CSV de la vista histórica, como pide el encargo.
- Desviaciones respecto del encargo: ninguna.
- Dudas abiertas: 0.
- Errores propios: 0.
- Qué debe verificar el revisor por sí mismo: el sitio publicado, con recarga forzada, y un testigo en `view-source` (por ejemplo `Llegaste al tope de`); el comparador → Agregar → SLEP con dos marcados.
- No publicado / queda al usuario: nada del motor; queda confirmar en el sitio que GitHub Pages terminó de construir.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `77af1b6` (primer acto).

**M1 a M3** (copias de trabajo `/tmp/s33h_motor.html` y `/tmp/s33h_docs_antes.html`; la calibración de §8.2 sobre el motor):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) HEAD~1=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; cp $R/40_salidas/motor_idps.html /tmp/s33h_motor.html; cp $R/docs/index.html /tmp/s33h_docs_antes.html; echo "motor $(md5 -q $R/40_salidas/motor_idps.html) docs $(md5 -q $R/docs/index.html)"; for f in /tmp/s33h_motor.html /tmp/s33h_docs_antes.html; do echo "$(basename $f) $(bash /tmp/s33h_payload_sha.sh $f | grep -o "sha256_norm\":\"[0-9a-f]*")"; done; node /tmp/s33h_fecha_alterada.js /tmp/s33h_motor.html /tmp/s33h_motor_fecha.html; bash /tmp/s33h_payload_sha.sh /tmp/s33h_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33h_plantar_payload.js /tmp/s33h_motor.html /tmp/s33h_motor_plantado.html; bash /tmp/s33h_payload_sha.sh /tmp/s33h_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"'
```
esperado: M1 solo este LOG (`?? …_s33h_log.md`), `stash: []`; M2 `fetch rc=0`, `HEAD=77af1b6`, `HEAD~1=4684a48` = `origin/main`, `HEAD..origin/main=0`, `origin/main..HEAD=1`; M3 motor **`7ad76f36e42d66c4da2d71aa28a558eb`** (regla 3) y `docs` `4b28a03fdaa00bd5dbb0a6fc501eab72`; §8.2 `eb4e00b3…4dc4` en los dos; con la fecha alterada, igual; con la cifra plantada, distinto.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_despliegue_s33h_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=77af1b6 HEAD~1=4684a48 origin/main=4684a48`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 `motor 7ad76f36e42d66c4da2d71aa28a558eb docs 4b28a03fdaa00bd5dbb0a6fc501eab72`; §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`** en el motor y en `docs/`; fecha alterada → igual; cifra plantada (`region_foco`) → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto). Reglas 1, 2 y 3 no disparan (el motor es el del gate); la calibración funciona.

**M4 — los nueve testigos de §1** (patrones en `/tmp/s33h_testigos.txt`, una línea cada uno, leídos sin expansión por `/tmp/s33h_testigos.sh`, que hace `grep -c -F` en cada archivo; por bash 3.2, las llaves y comillas no pasan por la línea de comando):
```
bash /tmp/s33h_testigos.sh /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html
```
esperado: motor / `docs`: `focoRespaldo` 4/0; `outline:2px solid var(--cream)` 1/0; `" en el directorio"` 2/0; `Llegaste al tope de` 1/0; `:hover{color:var(--alerta-txt)` 2/0; `CSV_HIST_COLS` 2/0; `sin_clasificar_excluido` 1/0; `.vt-scroll{position:relative;` 1/0; `s33i: el sub cede ancho` 1/0.
obtenido: `focoRespaldo` 4 / 0; `outline:2px solid var(--cream)` 1 / 0; `" en el directorio"` 2 / 0; `Llegaste al tope de` 1 / 0; `:hover{color:var(--alerta-txt)` 2 / 0; `CSV_HIST_COLS` 2 / 0; `sin_clasificar_excluido` 1 / 0; `.vt-scroll{position:relative;` 1 / 0; `s33i: el sub cede ancho` 1 / 0. **= §1 en los nueve** (regla 4 no dispara).

- **Estado de FASE 0:** completada. M1–M4 coinciden con su esperado; ninguna regla de detención dispara.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `77af1b6` (hijo de `4684a48` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno en FASE 0.

### FASE T1: despliegue

- **Paso 1 — la copia autorizada** (una vez; la regla 3 quedó superada en M3):
```
cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html
```
esperado: sin salida, código 0.
obtenido: sin salida, `rc=0`.
- **Paso 2 — verificación** (md5, testigos, §8.2 y porcelain; PRUEBAS b va en el comando siguiente):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; echo "docs $(md5 -q $R/docs/index.html) motor $(md5 -q $R/40_salidas/motor_idps.html)"; cmp -s $R/docs/index.html $R/40_salidas/motor_idps.html && echo "cmp: identicos"; bash /tmp/s33h_testigos.sh $R/40_salidas/motor_idps.html $R/docs/index.html; bash /tmp/s33h_payload_sha.sh $R/docs/index.html | grep -o "sha256_norm\":\"[0-9a-f]*"; git -C $R status --porcelain'
```
esperado: `docs 7ad76f36e42d66c4da2d71aa28a558eb motor 7ad76f36e42d66c4da2d71aa28a558eb`; `cmp: identicos`; los nueve testigos con el **mismo** conteo en `index.html` que en el motor (4, 1, 2, 1, 2, 2, 1, 1, 1); §8.2 `eb4e00b3…4dc4`; porcelain ` M docs/index.html` y `?? …_s33h_log.md`.
obtenido: `docs 7ad76f36e42d66c4da2d71aa28a558eb motor 7ad76f36e42d66c4da2d71aa28a558eb`; `cmp: identicos`; testigos motor / `index.html`: 4/4, 1/1, 2/2, 1/1, 2/2, 2/2, 1/1, 1/1, 1/1; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; porcelain ` M docs/index.html` y `?? 50_documentacion/andamios/logs/20260924_despliegue_s33h_log.md`.
- **Paso 2b — PRUEBAS b sobre `docs/index.html`** (PRUEBAS b de s33: los dos modales, una ficha con vista histórica y una comparación; más, como pide el encargo, la exportación CSV de la vista histórica del SLEP foco con el instrumento de Blob):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; bash /tmp/s33h_pruebas_b.sh $R/docs/index.html; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33h_csv.js $R/docs/index.html docs hist_foco | python3 -c "import json,sys; d=json.load(sys.stdin); k=d[\"hist_foco\"]; print({x: k.get(x) for x in (\"boton\",\"captura\",\"archivo\",\"md5\",\"lineas\",\"bom\",\"error\")}, \"errores\", len(k.get(\"errores\",[])), \"dialogos\", d[\"dialogos\"])"'
```
esperado: `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`; ficha `"errores":[]`; comparación `"errores":[] "desbordadas":0`; CSV histórico `boton ok`, `captura True`, `idps_panorama_historico_slep_costa_central_4b.csv`, md5 `856071a8ffdfc90b3c6226251e44fbef` (el de s33e a s33i), 2.197 líneas, BOM; 0 errores; sin diálogos.
obtenido: `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`; ficha `"errores":[] "glosa_existe":true`; comparación `"errores":[] "desbordadas":0`; CSV histórico `{'boton': 'ok', 'captura': True, 'archivo': 'idps_panorama_historico_slep_costa_central_4b.csv', 'md5': '856071a8ffdfc90b3c6226251e44fbef', 'lineas': 2197, 'bom': True, 'error': None}`, `errores 0`, `dialogos []`. **T1.2 conforme en todos sus puntos.**
- **Paso 3 — commit** con solo `docs/index.html`:
- **Commit:** `ec17e17` deploy(docs): motor s33 a s33i (7ad76f36) (`docs/index.html | 186`, `1 file changed, 148 insertions(+), 38 deletions(-)`); porcelain después: `?? …_s33h_log.md` (solo el LOG).
- **Estado de T1:** completada.

### FASE R: auditoría propia y reparación

**Paso 1 — inventario** (derivado del log, antes de auditar):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno: `<inicio>` = `77af1b6`, hijo de `4684a48` = `origin/main`; stash vacío (M1, M2) |
| R-02 | El motor de FASE 0 es el del gate: `7ad76f36…` (M3, regla 3) |
| R-03 | 🔒1: §8.2 `eb4e00b3…4dc4` en el motor, en `docs/` antes y después; la fecha alterada no lo mueve y la cifra plantada sí (M3) |
| R-04 | Testigos: 4/1/2/1/2/2/1/1/1 en el motor y 0 en `docs/` antes (M4); los mismos conteos en `docs/` después (T1) |
| R-05 | 🔒3: `docs/index.html` = `7ad76f36…`, idéntico al motor (`cmp`) (T1) |
| R-06 | PRUEBAS b sobre `docs/index.html`: 0 errores; CSV histórico `856071a8…` (T1) |
| R-07 | El commit `deploy(docs)` lleva solo `docs/index.html` (T1) |
| R-08 | 🔒2 / alcance: `git diff --name-only <inicio>..HEAD` ⊆ {`docs/index.html`, el LOG}; porcelain solo el LOG |

**Paso 2 — re-derivación independiente** (`shasum -a 256` en vez de `md5`; testigos con `awk index()` en vez de `grep -F`, script nuevo `/tmp/s33h_r_testigos.sh` con los mismos patrones; el commit leído con `git show --stat`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; a=$(shasum -a 256 $R/40_salidas/motor_idps.html | cut -d" " -f1); b=$(shasum -a 256 $R/docs/index.html | cut -d" " -f1); echo "sha256 motor $a"; echo "sha256 docs  $b"; [ "$a" = "$b" ] && echo "sha256 iguales"; bash /tmp/s33h_r_testigos.sh $R/40_salidas/motor_idps.html $R/docs/index.html /tmp/s33h_docs_antes.html; git -C $R show --stat --format="%h %s" HEAD | head -3'
```
esperado: los dos SHA-256 iguales (`sha256 iguales`); con `awk index()`, motor / `docs` después / `docs` antes: 4/4/0, 1/1/0, 2/2/0, 1/1/0, 2/2/0, 2/2/0, 1/1/0, 1/1/0, 1/1/0; `git show --stat HEAD` = `ec17e17 deploy(docs): motor s33 a s33i (7ad76f36)` con solo `docs/index.html`.
obtenido: `sha256 motor 38f05194c1e0bda5e173ca029a51fe9993e6d2953b5f409cc0f9affd52345864`, `sha256 docs  38f05194c1e0bda5e173ca029a51fe9993e6d2953b5f409cc0f9affd52345864`, **`sha256 iguales`**; con `awk index()`, motor / `docs` después / `docs` antes: 4/4/0, 1/1/0, 2/2/0, 1/1/0, 2/2/0, 2/2/0, 1/1/0, 1/1/0, 1/1/0; `ec17e17 deploy(docs): motor s33 a s33i (7ad76f36)` con ` docs/index.html | 186 …` (solo ese archivo). **R-04, R-05 y R-07 re-derivados.**

**Paso 3 — invariantes** (🔒1 con el re-derivador en Python, otra implementación que el de node; 🔒2 y 🔒3 con sus comandos del encargo):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=77af1b6; echo "1 $(python3 /tmp/s33h_r_payload.py $R/docs/index.html | cut -c1-200)"; echo "2 $(git -C $R diff --name-only $I..HEAD | tr "\n" " ")"; echo "3 docs $(md5 -q $R/docs/index.html)"'
```
esperado: 1 `index.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1`; 2 `docs/index.html` (el LOG va en FASE L); 3 `docs 7ad76f36e42d66c4da2d71aa28a558eb`.
obtenido: `1 index.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1 bytes=59467463`; `2 docs/index.html`; `3 docs 7ad76f36e42d66c4da2d71aa28a558eb`. **🔒1, 🔒2 y 🔒3 PASAN.**

**Paso 4 — alcance global:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R diff --name-only 77af1b6..HEAD; git -C $R status --porcelain; git -C $R log --oneline 77af1b6..HEAD'
```
esperado: `docs/index.html`; porcelain `?? …_s33h_log.md`; un commit, `ec17e17`.
obtenido: `docs/index.html`; porcelain `?? 50_documentacion/andamios/logs/20260924_despliegue_s33h_log.md`; `ec17e17 deploy(docs): motor s33 a s33i (7ad76f36)`. **R-08 conforme.**

**Paso 5 — regresión completa** (PRUEBAS a: md5 de `docs/index.html` = motor; b: PRUEBAS b de s33 más la exportación CSV histórica, sobre `docs/index.html` en `HEAD`; c: §8.2 con el re-derivador de node):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; [ "$(md5 -q $R/docs/index.html)" = "$(md5 -q $R/40_salidas/motor_idps.html)" ] && echo "a: docs = motor ($(md5 -q $R/docs/index.html))"; bash /tmp/s33h_pruebas_b.sh $R/docs/index.html; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33h_csv.js $R/docs/index.html r hist_foco | python3 -c "import json,sys; d=json.load(sys.stdin); k=d[\"hist_foco\"]; print(\"csv\", k.get(\"archivo\"), k.get(\"md5\"), \"errores\", len(k.get(\"errores\",[])), k.get(\"error\"))"; echo "c: $(bash /tmp/s33h_payload_sha.sh $R/docs/index.html | grep -o "sha256_norm\":\"[0-9a-f]*")"'
```
esperado: `a: docs = motor (7ad76f36…)`; PRUEBAS b sin errores de consola ni `pageerror`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`; `csv idps_panorama_historico_slep_costa_central_4b.csv 856071a8… errores 0 None`; `c: … eb4e00b3…4dc4`.
obtenido: `a: docs = motor (7ad76f36e42d66c4da2d71aa28a558eb)`; PRUEBAS b `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`; `csv idps_panorama_historico_slep_costa_central_4b.csv 856071a8ffdfc90b3c6226251e44fbef errores 0 None`; `c: sha256_norm":"eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`. **PRUEBAS a, b y c conformes sobre el estado final.**

**Paso 6 — control positivo** (fuera del árbol: copia de `docs/index.html` en `/tmp/s33h_docs_plantado.html` con **un byte** cambiado —la `i` del testigo `s33i:` pasa a `j`—; el comando de 🔒3 y el de la re-derivación deben fallar):
```
bash -c 'python3 -c "b=bytearray(open(\"/Users/tomgc/Projects/slep_idps/docs/index.html\",\"rb\").read()); k=b.find(b\"s33i: el sub cede ancho\"); b[k+3]=ord(\"j\"); open(\"/tmp/s33h_docs_plantado.html\",\"wb\").write(b); print(\"byte cambiado en\", k+3)"; cmp -l /Users/tomgc/Projects/slep_idps/docs/index.html /tmp/s33h_docs_plantado.html | wc -l | tr -d " "; m=$(md5 -q /tmp/s33h_docs_plantado.html); echo "md5 plantado $m"; [ "$m" = "7ad76f36e42d66c4da2d71aa28a558eb" ] && echo "🔒3 PASA (no debia)" || echo "🔒3 FALLA en el plantado (detectado)"; [ "$(shasum -a 256 /tmp/s33h_docs_plantado.html | cut -d" " -f1)" = "38f05194c1e0bda5e173ca029a51fe9993e6d2953b5f409cc0f9affd52345864" ] && echo "sha256 igual (no debia)" || echo "sha256 distinto (detectado)"'
```
esperado: `byte cambiado en …`; `1` byte distinto; un md5 distinto de `7ad76f36…`; `🔒3 FALLA en el plantado (detectado)`; `sha256 distinto (detectado)`.
obtenido: `byte cambiado en 521881`; `1` byte distinto; `md5 plantado 62c66bf892a0a4dd5edf056a36665150`; **`🔒3 FALLA en el plantado (detectado)`**; **`sha256 distinto (detectado)`**.

**Pasos 7 y 10 — tabla y veredicto:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno `77af1b6` | `git log --oneline 77af1b6..HEAD` (paso 4) | un commit, el despliegue | `ec17e17` | — | ninguna | — | — |
| R-02 | el motor es el del gate | `shasum -a 256` del motor (paso 2) y md5 de M3 | `7ad76f36…` | `7ad76f36…`; SHA-256 `38f05194…` | PASA | ninguna | — | — |
| R-03 | 🔒1 §8.2 | `r_payload.py` (Python) sobre `docs/index.html` | `eb4e00b3…` | `eb4e00b3…` | PASA | ninguna | — | node (paso 5c) |
| R-04 | testigos | `awk index()` sobre motor, `docs` después y `docs` antes | = motor; antes 0 | 4/1/2/1/2/2/1/1/1 = motor; antes 0 | PASA | ninguna | — | — |
| R-05 | 🔒3 copia = motor | `shasum -a 256` de los dos | iguales | iguales | PASA | ninguna | — | control (paso 6) |
| R-06 | PRUEBAS b | `pruebas_b.sh` y CSV histórico en `HEAD` (paso 5) | 0 errores; `856071a8…` | 0 errores; `856071a8…` | PASA | ninguna | — | — |
| R-07 | commit de despliegue | `git show --stat HEAD` | solo `docs/index.html` | solo `docs/index.html` | PASA | ninguna | — | — |
| R-08 | 🔒2 / alcance | `git diff --name-only 77af1b6..HEAD`; porcelain | `docs/index.html`; solo LOG | así | PASA | ninguna | — | — |

- **Control positivo:** una copia con un byte cambiado da otro md5 y otro SHA-256; 🔒3 falla en el plantado (paso 6). Más la calibración de §8.2 en M3 (fecha alterada igual, cifra plantada distinta).
- **0 hallazgos**, junto al control positivo; 0 ciclos de reparación, 0 commits `fix(auditoria)`.
- **Veredicto de FASE R: APROBADO.**

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R status -sb | head -1; git -C $R log --oneline 4684a48..HEAD; ps -ax -o command | grep -E "^node /tmp/s33h" | wc -l | tr -d " "'
```
esperado: solo este LOG; `main` adelantada 2 respecto de `origin/main`; commits `77af1b6` y `ec17e17`; `0` procesos `node /tmp/s33h*` (ningún shell en segundo plano).
obtenido: `?? 50_documentacion/andamios/logs/20260924_despliegue_s33h_log.md` (única); `## main...origin/main [ahead 2]`; `ec17e17`, `77af1b6`; `0`. Ningún shell en segundo plano (ninguno se lanzó).
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33h (despliegue a `docs/` del motor de s33 a s33i). Fases: FASE 0, T1, R y L. T1 completada (`ec17e17`). FASE R: **APROBADO** (0 hallazgos, con control positivo). Sin gates con el titular.
2. **Commits** (`git log 4684a48..HEAD --oneline`, antes del commit de este log):
   - `77af1b6` chore(encargo): s33h (= `<inicio>`)
   - `ec17e17` deploy(docs): motor s33 a s33i (7ad76f36)
   - (este log: `docs(log): s33h despliegue`; hash en el reporte)
3. **Auditoría:** en FASE R. Veredicto **APROBADO**; B/R/A = 0/0/0; control positivo detectado (un byte plantado).
4. **Invariantes:** 🔒1 PASA (§8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en `docs/index.html`, antes y después; re-derivado en Python) · 🔒2 PASA (`git diff --name-only 77af1b6..HEAD` = `docs/index.html`; el LOG entra con `docs(log)`) · 🔒3 PASA (`docs/index.html` = `7ad76f36e42d66c4da2d71aa28a558eb`, SHA-256 `38f05194c1e0bda5e173ca029a51fe9993e6d2953b5f409cc0f9affd52345864`, igual al motor).
5. **md5 y testigos.** `docs/index.html`: `4b28a03fdaa00bd5dbb0a6fc501eab72` (despliegue de s32g) → **`7ad76f36e42d66c4da2d71aa28a558eb`** (= motor). Testigos en `docs/`, antes → después (= motor): `focoRespaldo` 0 → 4; `outline:2px solid var(--cream)` 0 → 1; `" en el directorio"` 0 → 2; `Llegaste al tope de` 0 → 1; `:hover{color:var(--alerta-txt)` 0 → 2; `CSV_HIST_COLS` 0 → 2; `sin_clasificar_excluido` 0 → 1; `.vt-scroll{position:relative;` 0 → 1; `s33i: el sub cede ancho` 0 → 1.
6. **Decisiones del titular registradas** (del encargo): el gate visual se aprobó sobre el motor de s33g salvo las filas del modal, corregidas en s33i y revisadas por el titular sobre `7ad76f36…`; **N-1 de s33g: no se toca**; **A-1 de s33i: se acepta la fila Chile en dos líneas**. Ninguna decisión nueva en esta sesión.
7. **Dudas:** ninguna. Nota: GitHub Pages publica desde `origin/main`; el sitio refleja `7ad76f36…` cuando el push llega y Pages termina de construir (se verifica en el sitio, fuera de esta sesión).
8. **Errores propios:** ninguno.
9. **Estado de cierre:** commiteados `77af1b6`, `ec17e17` y el commit `docs(log)`. Push: según la condición del encargo; resultado en el reporte final.
10. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33h_priv.sh`, copia del de s33i con la ruta de este log; los patrones viven solo en el script):
```
bash /tmp/s33h_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `nombre plantado: 1`; `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0 (bruto, con los identificadores de acción: 0)`; `nombre plantado: 1`; `estación por nombre: 0`. **Privacidad: PASA.**

Paso 5 (verificación del archivo, después de rellenar el J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_despliegue_s33h_log.md; ls -l $L | awk "{print \$5}"; wc -l < $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(awk "/^## J/,/^## Registro/" $L | grep -c "^- ")"; bash /tmp/s33h_priv.sh | head -1'
```
esperado: `FASE=4` (FASE 0, T1, R, L); `esperado` = `obtenido` + 1 al medir (este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `24452` bytes y `191` líneas al medir; `FASE=4 esperado=13 obtenido=12 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **13 = 13** (un `esperado:` por comando, sin anexos de formato).
