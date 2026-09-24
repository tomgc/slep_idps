# Log de sesión: anillo de foco legible sobre la barra de la ficha (s33b)

- **Meta:** que el anillo de foco del nombre de la ficha (`.ficha-name`, respaldo del foco desde s33) se distinga sobre la barra azul de la ficha (≥ 3:1), pasándolo a `--cream`, sin cambiar el del contador del comparador (`.cmp-cl`) (T1); regenerar el motor (T2). Sin despliegue.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `5fb3170` (= `origin/main`, commit `docs(log)` de s33). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_anillo_ficha_s33b.md` y `?? 50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (las dos rutas que admite la regla 1); `git stash list` vacío; `HEAD=5fb3170 origin/main=5fb3170`; `HEAD..origin/main=0`, `origin/main..HEAD=0`. Primer acto (autorizado): commit `54bf973` chore(encargo): s33b y registro del asistente s33, hijo de `5fb3170`. **PUNTO DE RETORNO `<inicio>` = `54bf973`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script en `/tmp/s33b_*`); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`); pruebas de foco **con ventana** (`headless: false`) y en headless.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular fijan subagentes 0: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_anillo_ficha_s33b.md` (commit `54bf973`, junto con `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (anillo de .ficha-name en --cream)  ALCANCE: 30_procesamiento/35_motor_template.html
T2 (build)                             ALCANCE: 40_salidas/motor_idps.html; requiere T1
Serie: T1 → T2; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33b_*`; se copian de los `/tmp/s33_*` (siguen en `/tmp`). Convenciones de este log: toda medición lleva una línea `esperado:` antes del comando y una `obtenido:` después; una corrección de evidencia va como `- **Corrección:** …` (no como `obtenido:`); los patrones del control de privacidad viven solo en su script.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: el anillo de foco del nombre de la ficha pasa de `--foco` (1,84:1) a `--cream` (11,01:1) sobre la barra azul; el del contador del comparador sigue en `--foco` (5,99:1), con ventana y headless → cumplida.
- Estado por tarea: FASE 0 completada · T1 completada (`6455185`) · T2 completada (`e7f2ba4`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 4, rango `54bf973`..`<docs(log)>` (`git log --oneline 5fb3170..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/1; reparados 0; abiertos 1 (A-1: una falla transitoria del instrumento con ventana en 🔒6, resuelta con el reintento autorizado).
- Invariantes: 7/7 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒2 `:root` `04b2876e…` y hex +0/−0; 🔒3 `sigdifgru` +0/−0; 🔒4 0; 🔒5 0; 🔒6 = M7 en los dos modos; 🔒7 `.cmp-cl` `solid 2px rgb(0, 98, 160)`); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, T1, T2 y la regresión, re-derivado en Python; `run_all()` completo con el árbol limpio salvo el motor).
- Decisiones autónomas de mayor riesgo: (1) `/tmp/s33b_foco.js` registra además el color del contorno, para leer 🔒7; (2) la re-derivación usa otra ruta de teclado (SLEP con Enter; "san", segunda fila) y el contraste en Python desde los tokens del `:root`; (3) el reintento de la corrida con ventana tras la falla transitoria del instrumento.
- Desviaciones respecto del encargo: ninguna en el grafo, en las autorizaciones ni en la edición (la plantilla quedó idéntica a la copia calibrada de M8).
- Dudas abiertas: 0 nuevas. Decisiones del titular registradas: A-2 y A-1 de s33, sí.
- Errores propios: 3, sin efecto sobre cifras ni código: el esperado propio de `outline_color` en M7; un `sed` de salida no escrito en el log en T2; el script de contraste probado antes de su esperado. Costo: notas, ninguna re-medición.
- Qué debe verificar el revisor por sí mismo: el gate visual con teclado. En el comparador, 10 de 10 y Escape: anillo azul en el contador. En el modal de territorio, elegir un establecimiento con Enter: anillo crema visible alrededor del nombre, sobre la barra azul. Esta sesión midió colores calculados y contraste; la percepción no.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `outline:2px solid var(--cream)`: 1 en el motor, 0 en `docs/`; md5 `a41d9400f0fc85b183103b68af31063d`). El push, según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `54bf973` (primer acto).

**Instrumentos** (copiados de `/tmp/s33_*`, que seguían en `/tmp`): `/tmp/s33b_payload_sha.sh` → `/tmp/s33b_payload_norm.js`, `/tmp/s33b_fecha_alterada.js`, `/tmp/s33b_plantar_payload.js`, `/tmp/s33b_root_md5.sh`, `/tmp/s33b_build.sh`, `/tmp/s33b_pruebas_b.sh`, `/tmp/s33b_r_foco.js`, `/tmp/s33b_l6.js` (+ `_resumen.py`), sin cambios salvo rutas internas y cabecera. Cambios con efecto: `/tmp/s33b_hex.sh` con `I=54bf973`; `/tmp/s33b_sig.sh` reescrito corto (cuenta `sigdifgru` en borradas y agregadas y `const sg=` una vez; en s33b no hay una línea `const col` que identificar); `/tmp/s33b_foco.js` registra además `outline_color` del destino (lo necesita 🔒7), y su resumidor lo imprime.

**M1 a M4** (el motor de FASE 0 se guarda en `/tmp/s33b_motor_fase0.html` para T1.4):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R show --name-only --format= HEAD; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s33b_motor_fase0.html; echo "motor $(md5 -q $M) docs $(md5 -q $R/docs/index.html)"; bash /tmp/s33b_payload_sha.sh /tmp/s33b_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33b_fecha_alterada.js /tmp/s33b_motor_fase0.html /tmp/s33b_motor_fecha.html; bash /tmp/s33b_payload_sha.sh /tmp/s33b_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33b_plantar_payload.js /tmp/s33b_motor_fase0.html /tmp/s33b_motor_plantado.html; bash /tmp/s33b_payload_sha.sh /tmp/s33b_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s33b_root_md5.sh $R/30_procesamiento/35_motor_template.html; cp /tmp/s33b_root_block.txt /tmp/s33b_root_block_fase0.txt'
```
esperado: M1 solo este LOG; `stash: []`; `HEAD` trae el encargo y el registro s33; M2 `fetch rc=0`, `HEAD=54bf973`, padre `5fb3170` = `origin/main`, `0`, `1`; M3 motor `5a83f63c…`, `docs` `4b28a03f…`, §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; M4 `lineas: 65; md5 04b2876e…`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_anillo_ficha_s33b_log.md` (única), `stash: []`, `HEAD` = `50_documentacion/activa/encargos/encargo_claude_code_idps_anillo_ficha_s33b.md` y `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`; M2 `fetch rc=0`, `HEAD=54bf973 padre=5fb3170 origin/main=5fb3170`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 `motor 5a83f63cec4a5bfaf1213e554512ac64 docs 4b28a03fdaa00bd5dbb0a6fc501eab72`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada → igual, cifra plantada (offset JSON 82) → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); M4 `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. Reglas 1 y 2 no disparan; valores de 🔒1 y 🔒2(a).

**M6** (conteos en la plantilla; además, propio, la regla que T2 usará como testigo no debe existir todavía):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; T=$R/30_procesamiento/35_motor_template.html; echo "ficha-name:focus-visible $(grep -c "ficha-name:focus-visible" $T) ; cmp-cl:focus-visible $(grep -c "cmp-cl:focus-visible" $T) ; --cream: $(grep -c -- "--cream:" $T) ; testigo en plantilla $(grep -c "outline:2px solid var(--cream)" $T) motor $(grep -c "outline:2px solid var(--cream)" $R/40_salidas/motor_idps.html) docs $(grep -c "outline:2px solid var(--cream)" $R/docs/index.html)"; grep -n "ficha-name:focus-visible" $T'
```
esperado: `1`; `1`; `1`; testigo `0` en la plantilla, en el motor y en `docs/`; la línea es la regla compartida, justo después del comentario de s33.
obtenido: `ficha-name:focus-visible 1 ; cmp-cl:focus-visible 1 ; --cream: 1 ; testigo en plantilla 0 motor 0 docs 0`; L220 `.ficha-name:focus-visible,.cmp-cl:focus-visible{outline:2px solid var(--foco);outline-offset:2px;}`, precedida en L219 por el comentario de s33 y después de `.check-row:focus-visible` (L218). Coincide.

**M8** (calibración de 🔒2(b) y 🔒3 antes de T1; `/tmp/s33b_aplicar_t1.js` aplica a una copia **exactamente** la edición de §6.2 y aborta si el bloque viejo no aparece una sola vez; con `malo`, además escribe el anillo de la ficha como `outline:2px solid #FFF6E0` y agrega la línea `/* sigdifgru */`):
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; node /tmp/s33b_aplicar_t1.js $T /tmp/s33b_tpl_m8_bueno.html bueno; diff -U0 $T /tmp/s33b_tpl_m8_bueno.html > /tmp/s33b_m8_bueno.diff; bash /tmp/s33b_hex.sh /tmp/s33b_m8_bueno.diff; bash /tmp/s33b_sig.sh /tmp/s33b_m8_bueno.diff /tmp/s33b_tpl_m8_bueno.html; node /tmp/s33b_aplicar_t1.js $T /tmp/s33b_tpl_m8_malo.html malo; diff -U0 $T /tmp/s33b_tpl_m8_malo.html > /tmp/s33b_m8_malo.diff; bash /tmp/s33b_hex.sh /tmp/s33b_m8_malo.diff; bash /tmp/s33b_sig.sh /tmp/s33b_m8_malo.diff /tmp/s33b_tpl_m8_malo.html; cat /tmp/s33b_m8_bueno.diff'
```
esperado: (i) caso bueno: `hex agregadas=0 borradas=0`; `sigdifgru borradas=0 agregadas=0 const_sg=1`; un solo hunk (`@@ -219,2 +219,3 @@`). (ii) caso malo: `hex agregadas=1`; `sigdifgru agregadas=1`.
obtenido: caso bueno `hex agregadas=0 borradas=0`, `sigdifgru borradas=0 agregadas=0 const_sg=1`, un hunk `@@ -219,2 +219,3 @@` (comentario y regla compartida → comentario nuevo, `.cmp-cl` en `--foco` y `.ficha-name` en `--cream`); caso malo `hex agregadas=1 borradas=0` (la línea `+  .ficha-name:focus-visible{outline:2px solid #FFF6E0;…}`), `sigdifgru borradas=0 agregadas=1` (`+  /* sigdifgru */`). Los dos scripts disparan en (ii) y no en (i): no hace falta corregirlos. La copia buena queda como referencia (`/tmp/s33b_tpl_m8_bueno.html`): la plantilla tras T1 debe ser idéntica a ella.

**M5** (caso malo de T1; `/tmp/s33b_r_foco.js`, copia de la re-derivación de s33, que corre `cmp_region`, `cmp_desm` y `terr_liceo` y mide el contraste del color del anillo contra el fondo opaco del ancestro más cercano; `/tmp/s33b_r_resumen.py` lo resume):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33b_r_foco.js /tmp/s33b_motor_fase0.html $m; done > /tmp/s33b_m5.jsonl; python3 /tmp/s33b_r_resumen.py /tmp/s33b_m5.jsonl'
```
esperado: en los dos modos, `terr_liceo`: `DIV.ficha-name`, anillo `solid 2px rgb(0, 98, 160)` sobre `rgb(10, 58, 92)`, **1.84**; `cmp_region`: `SPAN.cmp-cl`, `solid 2px rgb(0, 98, 160)` sobre `rgb(255, 246, 224)`, 5.99; (`cmp_desm`: `BUTTON.cmp-add`, como en s33); 0 errores.
obtenido: (`/tmp/s33b_m5.jsonl`; con ventana y en headless, **idénticos**; 0 errores) `terr_liceo: activo=DIV.ficha-name focus_css=DIV.ficha-name focus_visible_css=DIV.ficha-name anillo=solid 2px rgb(0, 98, 160) sobre rgb(10, 58, 92) contraste=1.84`; `cmp_region: activo=SPAN.cmp-cl … anillo=solid 2px rgb(0, 98, 160) sobre rgb(255, 246, 224) contraste=5.99`; `cmp_desm: activo=BUTTON.cmp-add …`. **Caso malo confirmado** (1,84 < 3): la regla 6 no dispara. Línea base de 🔒7: `solid 2px rgb(0, 98, 160)`, 5,99.

**M7** (líneas base de 🔒6: `/tmp/s33b_l6.js` —ciclo y devolución de s32e— y `/tmp/s33b_foco.js` —destinos de s33—, sobre el motor actual, en los dos modos):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33b_motor_fase0.html; for m in ventana headless; do node /tmp/s33b_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33b_m7_l6_$m.json; python3 /tmp/s33b_l6_resumen.py /tmp/s33b_m7_l6_$m.json; done; for m in ventana headless; do node /tmp/s33b_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33b_m7_foco.jsonl; python3 /tmp/s33b_foco_resumen.py /tmp/s33b_m7_foco.jsonl'
```
esperado: en los dos modos, `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0`; destinos `SPAN.cmp-cl` en `tope_listo`, `tope_escape` y `tope_fondo`, `DIV.ficha-name` en `terr_ee`, `BUTTON.cmp-add` en `desmarcar`; con `outline_color` `rgb(0, 98, 160)` en `.cmp-cl` y en `.ficha-name`; 0 errores.
obtenido: (`/tmp/s33b_m7_l6_*.json`, `/tmp/s33b_m7_foco.jsonl`; con ventana y en headless, **idénticos**; 0 errores) `ventana | terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico. Destinos: `tope_listo` `SPAN.cmp-cl` (`focus_visible=False`, `outline=none 3px`, color `rgb(92, 102, 110)`); `tope_escape` `SPAN.cmp-cl` (`solid 2px`, `rgb(0, 98, 160)`); `tope_fondo` `SPAN.cmp-cl` (`solid 2px`, `rgb(0, 98, 160)`); `terr_ee` `DIV.ficha-name` (`solid 2px`, `rgb(0, 98, 160)`); `desmarcar` `BUTTON.cmp-add` (`none 3px`, `rgb(255, 255, 255)`). Los destinos y la línea de 🔒6 coinciden con el esperado del encargo. **Mi esperado propio sobre `outline_color` era impreciso:** sin anillo (`outline-style: none`, cierres con clic en Listo y en `desmarcar`), el color calculado del contorno es `currentColor`, el color del texto del elemento (`--gris` en `.cmp-cl`, blanco en `.cmp-add`); con anillo es `rgb(0, 98, 160)`, como se esperaba. Sin efecto sobre ninguna tarea: 🔒7 se lee en el cierre con Escape.

- **Estado de FASE 0:** completada. M1–M8 coinciden con su esperado (M7 con la precisión de arriba). Ninguna regla de detención dispara; ninguna tarea congelada; sin gates.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `54bf973` (hijo de `5fb3170` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** 1 de planteamiento (el esperado propio de `outline_color` en M7 no distinguía los cierres sin anillo). Costo: ninguno más allá de esta nota.

### FASE T1: anillo de `.ficha-name` en `--cream` (A-2 de s33)

- **Paso 0:** M5 (1,84 en la ficha; 5,99 en el comparador), M6 (una regla compartida, `--cream` existe, el testigo aún no existe) y M7 (líneas base de 🔒6 y 🔒7).
- **Implementación** (la edición de §6.2, nada más): el comentario de s33 pasa al texto pedido (agrega "s33b: en la ficha el anillo va en crema porque la barra es azul oscuro (A-2 de s33)"), y la regla compartida se separa en dos, en el mismo lugar: `.cmp-cl:focus-visible{outline:2px solid var(--foco);outline-offset:2px;}` y `.ficha-name:focus-visible{outline:2px solid var(--cream);outline-offset:2px;}`. Sin hex; `--cream` ya existe en el `:root`.
- **Verificación** (build temporal con `run_all(only = 35L)`; 🔒2(b) y 🔒3 sobre el árbol, con `git diff -U0 54bf973 -- <plantilla>` pasado como archivo; con ventana **y** headless; tres comandos):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; T=$R/30_procesamiento/35_motor_template.html; cmp -s $T /tmp/s33b_tpl_m8_bueno.html && echo "plantilla = copia buena de M8" || echo "plantilla DISTINTA de M8"; git -C $R diff --stat -- 30_procesamiento/35_motor_template.html | tail -1; bash /tmp/s33b_build.sh t1; git -C $R diff -U0 54bf973 -- 30_procesamiento/35_motor_template.html > /tmp/s33b_t1.diff; echo "T1.5 $(bash /tmp/s33b_hex.sh /tmp/s33b_t1.diff | head -1) ; $(bash /tmp/s33b_sig.sh /tmp/s33b_t1.diff | head -1)"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33b_motor_t1.html; for m in ventana headless; do node /tmp/s33b_r_foco.js $M $m; done > /tmp/s33b_t1_r.jsonl; python3 /tmp/s33b_r_resumen.py /tmp/s33b_t1_r.jsonl; for m in ventana headless; do node /tmp/s33b_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33b_t1_foco.jsonl; python3 /tmp/s33b_foco_resumen.py /tmp/s33b_t1_foco.jsonl'
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33b_motor_t1.html; for m in ventana headless; do node /tmp/s33b_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33b_t1_l6_$m.json; python3 /tmp/s33b_l6_resumen.py /tmp/s33b_t1_l6_$m.json; done'
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33b_r_foco.js /tmp/s33b_motor_fase0.html $m; done > /tmp/s33b_t14.jsonl; python3 /tmp/s33b_r_resumen.py /tmp/s33b_t14.jsonl | grep -E "==|terr_liceo"; bash /tmp/s33b_pruebas_b.sh /tmp/s33b_motor_t1.html'
```
esperado: `plantilla = copia buena de M8`; `1 file changed, 3 insertions(+), 2 deletions(-)`; `rc=0 warn=0 pasos_ok=1`; motor nuevo, distinto de `5a83f63c…`; §8.2 `eb4e00b3…` (= M3); `:root` `65`, `04b2876e…` (= M4). **T1.1** (dos modos) `terr_liceo`: `DIV.ficha-name` por las tres vías, anillo `solid 2px rgb(255, 246, 224)` sobre `rgb(10, 58, 92)`, contraste **≥ 3** (se espera 11,01); `terr_ee`: `DIV.ficha-name`, `solid 2px`, `rgb(255, 246, 224)`. **T1.2** (🔒7) `cmp_region`: `SPAN.cmp-cl`, `solid 2px rgb(0, 98, 160)` sobre `rgb(255, 246, 224)`, 5,99; `tope_escape`: `SPAN.cmp-cl`, `solid 2px`, `rgb(0, 98, 160)`. **T1.3** (🔒6) la línea de `/tmp/s33b_l6.js` y los destinos de `/tmp/s33b_foco.js`, iguales a M7 en los dos modos (en `terr_ee` cambia solo el color del anillo, que es lo que T1 cambia). **T1.4** motor de FASE 0: `terr_liceo` sigue en 1,84. **T1.5** `hex agregadas=0 borradas=0`; `sigdifgru borradas=0 agregadas=0 const_sg=1`; PRUEBAS b: modales `true`/`true`, ficha y comparación sin errores, 0 `pageerror`. 0 errores en todas las corridas.
obtenido: (`/tmp/s33b_t1_r.jsonl`, `/tmp/s33b_t1_foco.jsonl`, `/tmp/s33b_t1_l6_*.json`, `/tmp/s33b_t14.jsonl`; **con ventana y en headless, idénticos**; 0 errores de consola y 0 `pageerror` en todas) `plantilla = copia buena de M8`; `1 file changed, 3 insertions(+), 2 deletions(-)`; `rc=0 warn=0 pasos_ok=1`; motor temporal `a41d9400f0fc85b183103b68af31063d`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` (= M4).
- **T1.1:** `terr_liceo: activo=DIV.ficha-name focus_css=DIV.ficha-name focus_visible_css=DIV.ficha-name anillo=solid 2px rgb(255, 246, 224) sobre rgb(10, 58, 92) contraste=11.01`; `terr_ee: activo=DIV.ficha-name … outline=solid 2px color=rgb(255, 246, 224)`.
- **T1.2 (🔒7):** `cmp_region: activo=SPAN.cmp-cl … anillo=solid 2px rgb(0, 98, 160) sobre rgb(255, 246, 224) contraste=5.99`; `tope_escape: activo=SPAN.cmp-cl … outline=solid 2px color=rgb(0, 98, 160)` (= M5 y M7).
- **T1.3 (🔒6):** `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` en los dos modos; destinos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add` (= M7; en `terr_ee` cambia solo el color del anillo, de `rgb(0, 98, 160)` a `rgb(255, 246, 224)`); los Tab siguientes, iguales (`cmp-x`, `lvl-b`, `cmp-reset`).
- **T1.4:** motor de FASE 0, `terr_liceo`: `anillo=solid 2px rgb(0, 98, 160) sobre rgb(10, 58, 92) contraste=1.84` en los dos modos.
- **T1.5:** `hex agregadas=0 borradas=0`; `sigdifgru borradas=0 agregadas=0 const_sg=1`; PRUEBAS b `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`, `glosa_existe: true`; comparación `errores: []`, `desbordadas: 0`.
- **Regresión:** build `rc=0`, 0 warnings; 🔒6 = M7; PRUEBAS b sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "fix(motor): anillo de foco en crema sobre la barra de la ficha (s33b T1, A-2 de s33)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && bash /tmp/s33b_hex.sh | head -1 && bash /tmp/s33b_sig.sh | head -1 && git -C $R status --porcelain'
```
esperado: porcelain antes: ` M` plantilla (ALCANCE de T1), ` M` motor (build temporal; va en T2) y el LOG; commit con solo la plantilla; 🔒2(b) y 🔒3 sobre `<inicio>..HEAD`: `hex agregadas=0 borradas=0`, `sigdifgru borradas=0 agregadas=0 const_sg=1`; después: motor y LOG.
obtenido: antes ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? …s33b_log.md`; **`6455185` fix(motor): anillo de foco en crema sobre la barra de la ficha (s33b T1, A-2 de s33)** con `30_procesamiento/35_motor_template.html`; `hex agregadas=0 borradas=0`; `sigdifgru borradas=0 agregadas=0 const_sg=1`; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: build

- **Paso 1** (porcelain):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: solo el motor y el LOG: ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260924_anillo_ficha_s33b_log.md`.
obtenido: ` M 40_salidas/motor_idps.html`, `?? 50_documentacion/andamios/logs/20260924_anillo_ficha_s33b_log.md`.
- **Pasos 2 a 4** (PRUEBAS a con el pipeline completo, porcelain después, md5, §8.2, testigo y PRUEBAS b; en los dos comandos siguientes, T1.1, T1.2 y 🔒6 sobre el motor commiteable, con ventana y headless):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; bash /tmp/s33b_build.sh t2 completo; git -C $R status --porcelain; echo "motor en el arbol $(md5 -q $M) ; §8.2 $(bash /tmp/s33b_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*" | cut -c15-)"; echo "testigo crema motor $(grep -c "outline:2px solid var(--cream)" $M) docs $(grep -c "outline:2px solid var(--cream)" $R/docs/index.html) ; focoRespaldo motor $(grep -c focoRespaldo $M)"; bash /tmp/s33b_pruebas_b.sh $M'
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; for m in ventana headless; do node /tmp/s33b_r_foco.js $M $m; done > /tmp/s33b_t2_r.jsonl; python3 /tmp/s33b_r_resumen.py /tmp/s33b_t2_r.jsonl; for m in ventana headless; do node /tmp/s33b_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33b_t2_foco.jsonl; python3 /tmp/s33b_foco_resumen.py /tmp/s33b_t2_foco.jsonl'
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; for m in ventana headless; do node /tmp/s33b_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33b_t2_l6_$m.json; python3 /tmp/s33b_l6_resumen.py /tmp/s33b_t2_l6_$m.json; done'
```
esperado: `rc=0 warn=0 pasos_ok=5`; porcelain después, el mismo del paso 1; motor `a41d9400f0fc85b183103b68af31063d` (= build temporal de T1: misma plantilla, mismo día), **distinto de `5a83f63c…`**; §8.2 `eb4e00b3…` (= M3); `:root` `04b2876e…`; testigo `crema motor 1 docs 0`, `focoRespaldo` ≥ 1 (4); PRUEBAS b sin errores; T1.1 `DIV.ficha-name`, `solid 2px rgb(255, 246, 224)`, 11,01; T1.2 `SPAN.cmp-cl`, `solid 2px rgb(0, 98, 160)`, 5,99; 🔒6 = M7 (con la línea de `/tmp/s33b_l6.js` idéntica y los mismos destinos); en los dos modos; 0 errores.
obtenido: (primer comando) `rc=0 warn=0 pasos_ok=5`; motor `a41d9400f0fc85b183103b68af31063d` (= T1; **distinto de `5a83f63c…`**); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain después ` M 40_salidas/motor_idps.html`, `?? …s33b_log.md` (el mismo); `testigo crema motor 1 docs 0 ; focoRespaldo motor 4`; PRUEBAS b: `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`, `glosa_existe: true`; comparación `errores: []`, `desbordadas: 0`. (Segundo comando; al ejecutarlo agregué al final `| sed -E "s/ tabindex=.*\| Tab/ | Tab/"`, que solo acorta la salida del resumidor —quita `tabindex`, `cmp_add` y `terr_trigger`—; el JSON completo está en `/tmp/s33b_t2_foco.jsonl`) con ventana y headless, idénticos, 0 errores: T1.1 `terr_liceo` `DIV.ficha-name` por las tres vías, `anillo=solid 2px rgb(255, 246, 224) sobre rgb(10, 58, 92) contraste=11.01`, `terr_ee` `DIV.ficha-name` `solid 2px` `rgb(255, 246, 224)`; T1.2 `cmp_region` `SPAN.cmp-cl` `solid 2px rgb(0, 98, 160)` sobre `rgb(255, 246, 224)`, 5.99, `tope_escape` `SPAN.cmp-cl` `solid 2px` `rgb(0, 98, 160)`; destinos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add` (= M7). (Tercer comando) `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` en los dos modos (= M7).
- **Testigo para el despliegue:** `grep -c 'outline:2px solid var(--cream)'` → `1` en `40_salidas/motor_idps.html` y `0` en `docs/index.html`; `focoRespaldo` → `4` en el motor. **md5 del motor para el despliegue: `a41d9400f0fc85b183103b68af31063d`.**
- **Paso 5 (commit):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s33b anillo de foco de la ficha" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: commit con solo el motor (`a41d9400…`); porcelain después: solo el LOG.
obtenido: **`e7f2ba4` build(motor): s33b anillo de foco de la ficha**; `40_salidas/motor_idps.html`; `a41d9400f0fc85b183103b68af31063d`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `54bf973`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `54bf973` (hijo de `5fb3170` = `origin/main`), con el encargo y el registro s33; commits `54bf973`, `6455185`, `e7f2ba4` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0, en T1 y en T2; ciego a la fecha y sensible a una cifra plantada (M3) |
| R-03 | `:root` `65` líneas, `04b2876e…`, sin cambio (M4, T1, T2) |
| R-04 | M5 / T1.4: en el motor anterior el anillo de `.ficha-name` da 1,84 sobre la barra (caso malo); el de `.cmp-cl`, 5,99 |
| R-05 | M6: una regla compartida; `--cream` definido una vez; el testigo no existía |
| R-06 | M7 / T1.3 / T2: 🔒6 (ciclo, devolución y destinos) idéntico en los dos modos |
| R-07 | M8: `/tmp/s33b_hex.sh` y `/tmp/s33b_sig.sh` disparan con el caso malo y no con el bueno |
| R-08 | T1.1: anillo de `.ficha-name` en `rgb(255, 246, 224)`, 11,01 sobre la barra |
| R-09 | T1.2 / 🔒7: anillo de `.cmp-cl` en `rgb(0, 98, 160)`, 5,99, sin cambio |
| R-10 | T1.5: hex +0/−0 y `sigdifgru` +0/−0; plantilla = copia buena de M8 |
| R-11 | T2: build completo con el árbol limpio salvo el motor; motor `a41d9400…`; testigo 1/0; `focoRespaldo` 4 |
| 🔒1–🔒7 | invariantes de §3 |
| ALC | alcance global ⊆ unión de ALCANCE + LOG + encargo + registro s33 |
| REG | PRUEBAS a, b y c sobre el estado final |
| CP | casos malos y plantados: M3 (cifra), M5/T1.4 (motor anterior), M8 (hex y `sigdifgru`), el motor con el anillo devuelto a `--foco` |

**Paso 2a. Re-derivación estática** (`/tmp/s33b_r_static.sh`: §8.2 en Python —`/tmp/s33b_r_payload.py`, otra implementación que el node de M3—; `:root` con `/tmp/s33b_r_root.py`; conteos con `awk index()`; el contraste de los dos anillos con `/tmp/s33b_r_anillo.py`, que **no usa el navegador**: lee los hex de `--azul`, `--cream` y `--foco` en el `:root` de la plantilla, el token del `outline` de cada regla `:focus-visible` de los respaldos y el token del fondo de `.ficha-bar`, y calcula WCAG 2.1; `/tmp/s33b_r_diff.py` sobre `git diff -U0 54bf973..HEAD`; md5 del motor en `HEAD` con `hashlib`. El script del contraste se probó una vez antes de escribir este esperado, con la misma salida que abajo):
```
bash /tmp/s33b_r_static.sh
```
esperado: R-01 padre `5fb3170` = `origin/main`; commits `e7f2ba4 6455185 54bf973`; 2 rutas en `54bf973`. R-02 `eb4e00b3…` en el motor de `HEAD`, en el de FASE 0 y en el de fecha alterada; distinto en el plantado. R-03 `<inicio>` y `HEAD` con 65 líneas y el mismo md5 (`04b2876e…`). R-05/R-10 en `HEAD`: `1`, `1`, `1`, regla compartida `0`, testigo `1` (en `<inicio>` `0`). R-08/R-09: en `<inicio>` la ficha usa `foco` sobre `azul` → 1,84 y `.cmp-cl` `foco` sobre `cream` → 5,99; en `HEAD` la ficha usa `cream` sobre `azul` → **11,01** y `.cmp-cl` sigue en `foco` → 5,99. R-10 `lineas +3 -2 | hex +0 -0 | sigdifgru +0 -0`. R-11 md5 `a41d9400…`; testigo motor `1`, docs `0`; `focoRespaldo` `4`.
obtenido: `R-01: padre 5fb3170 ; origin/main 5fb3170 ; commits e7f2ba4 6455185 54bf973 ; en 54bf973 2 rutas`. R-02 (Python): `HEAD`, FASE 0 y fecha alterada `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; plantado `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8`. R-03: `<inicio>` y `HEAD` `lineas=65 md5=04b2876e2bcece41f09398f28f6fc41d`. R-05/R-10: `ficha-name:focus-visible 1 ; cmp-cl:focus-visible 1 ; --cream: 1 ; regla compartida 0 ; testigo plantilla 1 (inicio 0)`. R-08/R-09: `54bf973`: ficha `['foco']` sobre `azul` → `1.84`, `.cmp-cl` `['foco']` sobre `cream` → `5.99`; `HEAD`: ficha `['cream']` sobre `azul` → **`11.01`**, `.cmp-cl` `['foco']` → `5.99` (tokens `#0A3A5C`, `#FFF6E0`, `#0062A0`, iguales en los dos commits). R-10 `lineas +3 -2 | hex +0 -0 | sigdifgru +0 -0`. R-11 `a41d9400f0fc85b183103b68af31063d ; testigo motor 1 docs 0 ; focoRespaldo motor 4`. **Todo coincide por otra vía; el contraste del navegador y el de Python dan las mismas cifras.**

**Paso 2b. Re-derivación en navegador por otra ruta de teclado** (`/tmp/s33b_r2_foco.js`, derivado de `/tmp/s33b_r_foco.js` con reemplazos verificados: comparador abierto con Enter, pestaña **SLEP** con Shift+Tab + Enter, filas con **Enter** hasta 10 de 10 y cierre con **Enter sobre Listo** (`cmp_slep`); lo mismo, desmarcando con Enter y cerrando con Escape (`cmp_desm`); territorio abierto con **Enter**, pestaña Establecimiento con teclado, búsqueda "san" y **segunda** fila con Enter (`terr_san`). Destino por `activeElement`, `:focus` y `:focus-visible`; anillo y contraste contra el fondo opaco del padre. Sobre el motor de `HEAD` con ventana y headless; sobre el de FASE 0 y sobre el **control positivo** —copia del motor de `HEAD` con el anillo de la ficha devuelto a `var(--foco)`, 1 ocurrencia— en headless):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; H=/tmp/s33b_r_motor_head.html; sed "s/.ficha-name:focus-visible{outline:2px solid var(--cream);/.ficha-name:focus-visible{outline:2px solid var(--foco);/" $H > /tmp/s33b_r_motor_anillo_foco.html; echo "plantado difiere $(cmp -s $H /tmp/s33b_r_motor_anillo_foco.html && echo NO || echo SI)"; (for m in ventana headless; do node /tmp/s33b_r2_foco.js $H $m; done; node /tmp/s33b_r2_foco.js /tmp/s33b_motor_fase0.html headless; node /tmp/s33b_r2_foco.js /tmp/s33b_r_motor_anillo_foco.html headless) > /tmp/s33b_r2.jsonl; python3 /tmp/s33b_r2_resumen.py /tmp/s33b_r2.jsonl'
```
esperado: motor de `HEAD`, dos modos: `cmp_slep` `SPAN.cmp-cl` por las tres vías, `solid 2px rgb(0, 98, 160)` sobre `rgb(255, 246, 224)`, 5,99; `cmp_desm` `BUTTON.cmp-add`; `terr_san` `DIV.ficha-name` por las tres vías, `solid 2px rgb(255, 246, 224)` sobre `rgb(10, 58, 92)`, 11,01; Shift+Tab a un control anterior. Motor de FASE 0 y control positivo: `terr_san` con `rgb(0, 98, 160)` y **1,84**; `cmp_slep` sin cambio (5,99). 0 errores.
obtenido: `plantado difiere SI`; 0 errores en las cuatro corridas (`/tmp/s33b_r2.jsonl`). **Motor de `HEAD`, con ventana y headless, idénticos:** `cmp_slep` `SPAN.cmp-cl` por `activo`, `focus_css` y `focus_visible_css`, `anillo=solid 2px rgb(0, 98, 160) sobre rgb(255, 246, 224) contraste=5.99`, Shift+Tab → `BUTTON.lvl-b` (`anterior=True`); `cmp_desm` `BUTTON.cmp-add`; `terr_san` `DIV.ficha-name` por las tres vías, `anillo=solid 2px rgb(255, 246, 224) sobre rgb(10, 58, 92) contraste=11.01`, Shift+Tab → `BUTTON.screen-tab`. **Motor de FASE 0 y control positivo (anillo devuelto a `--foco`):** `terr_san` `anillo=solid 2px rgb(0, 98, 160) … contraste=1.84`; `cmp_slep` 5.99 sin cambio. El instrumento dispara con el caso plantado y solo en la superficie cambiada. R-04, R-06 (destinos), R-08 y R-09 confirmados por otra ruta.

**Pasos 3, 4 y 6** (`/tmp/s33b_final.sh`: L1–L5 con los comandos de §3; alcance con lista explícita —las dos rutas de los ALCANCE, el LOG, el encargo y el registro s33—; controles positivos fuera del árbol: C1 una línea de diff con un hex; C2 la plantilla con un valor de token cambiado; C3 el motor con la cifra plantada de M3; C4 una ruta plantada en el alcance; C5 una línea de diff con `sigdifgru`; C6 🔒5 sobre el deploy `9fc6f22`; C7 🔒4 sobre `364c53a`, el commit de datos de s32b):
```
bash /tmp/s33b_final.sh
```
esperado: `L1` `eb4e00b3…4dc4`; `L2a` `lineas: 65; md5 04b2876e…`; `L2b` `hex agregadas=0 borradas=0`; `L3` `sigdifgru borradas=0 agregadas=0 const_sg=1`; `L4` `0`; `L5` `0`. `ALC` 2 rutas (plantilla y motor), `fuera 0`, en `54bf973` el encargo y el registro, porcelain solo el LOG. `C1` `agregadas=1`; `C2` md5 distinto de `04b2876e…`; `C3` `1c3799e2…`; `C4` `[docs/index.html ]`; `C5` `agregadas=1`; `C6` `1`; `C7` > 0.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **🔒1 PASA**; `L2a: lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`, `L2b: hex agregadas=0 borradas=0` → **🔒2 PASA**; `L3: sigdifgru borradas=0 agregadas=0 const_sg=1` → **🔒3 PASA**; `L4: 0` → **🔒4 PASA**; `L5: 0` → **🔒5 PASA**. `ALC: rutas [30_procesamiento/35_motor_template.html 40_salidas/motor_idps.html ] ; fuera 0 ; en 54bf973: [encargo, registro s33] fuera 0 ; porcelain [?? …s33b_log.md ]` → **alcance PASA**. Controles: `C1: hex agregadas=1 borradas=0`; `C2: lineas: 65; md5 070d6097d10e601e95a45ce0e6352392` (distinto); `C3: 1c3799e2e8e35da8` (distinto); `C4: [docs/index.html ]`; `C5: sigdifgru borradas=0 agregadas=1 const_sg=1`; `C6: 1`; `C7: 78`. Todos disparan.

**Paso 3, 🔒6 y 🔒7** (los dos scripts de M7 sobre el motor final, en los dos modos; 🔒7 se lee en `tope_escape`) **y el control C8 de 🔒6** (copia del motor de `HEAD` sin la devolución: la única línea `      destino.focus();` → `      0;`, en headless, `devol`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; for m in ventana headless; do node /tmp/s33b_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33b_r_l6_$m.json; python3 /tmp/s33b_l6_resumen.py /tmp/s33b_r_l6_$m.json; done; for m in ventana headless; do node /tmp/s33b_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33b_r_foco.jsonl; python3 /tmp/s33b_foco_resumen.py /tmp/s33b_r_foco.jsonl; H=/tmp/s33b_r_motor_head.html; echo "C8 ocurrencias $(grep -c "^      destino.focus();$" $H)"; sed "s/^      destino.focus();$/      0;/" $H > /tmp/s33b_r_motor_sin_devol.html; node /tmp/s33b_l6.js /tmp/s33b_r_motor_sin_devol.html headless devol | python3 -c "import json,sys; d=json.load(sys.stdin)[\"devol\"]; print(\"C8 origen en\", sum(1 for v in d.values() if v.get(\"es_origen\")), \"de\", len(d))"'
```
esperado: 🔒6 en los dos modos: `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0`; destinos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add` (= M7). 🔒7: `tope_escape` `outline=solid 2px color=rgb(0, 98, 160)`. `C8 ocurrencias 1`, `C8 origen en 0 de 10`.
obtenido: 🔒6 `ventana | terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico. Destinos en headless: `tope_listo`, `tope_escape`, `tope_fondo` → `SPAN.cmp-cl`; `terr_ee` → `DIV.ficha-name` (`solid 2px`, `rgb(255, 246, 224)`); `desmarcar` → `BUTTON.cmp-add` (= M7). Con ventana: iguales en `tope_escape`, `tope_fondo`, `terr_ee` y `desmarcar`, pero **`tope_listo: ERROR No element found for selector: .modal .input-search`**: falla del instrumento en la primera acción de la corrida con ventana (la misma acción pasó con ventana en M7, T1 y T2); 0 errores de consola y 0 `pageerror` en la página. 🔒7: `tope_escape` `outline=solid 2px color=rgb(0, 98, 160)` en los dos modos → **🔒7 PASA**. `C8 ocurrencias 1`, `C8 origen en 0 de 10` → el control dispara. 🔒6 queda pendiente del reintento de `tope_listo` con ventana (tope: 1 reintento por falla transitoria).
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; node /tmp/s33b_foco.js $M ventana tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar > /tmp/s33b_r_foco_reintento.jsonl; python3 /tmp/s33b_foco_resumen.py /tmp/s33b_r_foco_reintento.jsonl'
```
esperado: (reintento, mismo comando de la corrida con ventana) `tope_listo` `SPAN.cmp-cl` (`focus_visible=False`, sin anillo) y los demás destinos como arriba; 0 errores. Si vuelve a fallar, no es transitoria: se investiga como hallazgo.
obtenido: (reintento con ventana, 0 errores) `tope_listo` `SPAN.cmp-cl` (`focus_visible=False`, `outline=none 3px`); `tope_escape` y `tope_fondo` `SPAN.cmp-cl` (`solid 2px`, `rgb(0, 98, 160)`); `terr_ee` `DIV.ficha-name` (`solid 2px`, `rgb(255, 246, 224)`); `desmarcar` `BUTTON.cmp-add`: todo = M7 → **🔒6 PASA** en los dos modos. La falla de la primera corrida fue transitoria y del instrumento (el modal aún no mostraba su buscador cuando el script lo buscó); no se reprodujo. Se registra como advertencia A-1.

**Paso 5. Regresión completa** (PRUEBAS a con `run_all()` completo sobre el estado final; PRUEBAS b; PRUEBAS c):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; bash /tmp/s33b_build.sh faseR completo; git -C $R status --porcelain; bash /tmp/s33b_pruebas_b.sh $M; echo "REGc $(bash /tmp/s33b_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*" | cut -c15-)"'
```
esperado: REGa `rc=0 warn=0 pasos_ok=5`, motor `a41d9400…` (= `HEAD`), `:root` `04b2876e…`, porcelain solo el LOG; REGb modales `true`/`true`, ficha y comparación sin errores, 0 `pageerror`; REGc `eb4e00b3…`.
obtenido: `REGa: rc=0 warn=0 pasos_ok=5`, motor `a41d9400f0fc85b183103b68af31063d` (= `HEAD`), `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`, porcelain `?? …s33b_log.md` (solo el LOG); `REGb`: `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`, `glosa_existe: true`; comparación `errores: []`, `desbordadas: 0`; `REGc: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **regresión PASA**.

**Paso 7. Veredicto por hallazgo.**
- **0 BLOQUEA; 0 REPARA.** Los controles positivos (C1–C8 y el motor con el anillo devuelto a `--foco`, que da 1,84) prueban que cada instrumento dispara.
- **A-1 (ADVIERTE, instrumento):** en la corrida con ventana de 🔒6 de FASE R, la primera acción (`tope_listo`) falló en el instrumento (`No element found for selector: .modal .input-search`); el reintento autorizado dio el resultado de M7. Sin efecto sobre la meta; la página no registró errores.
- **Nota:** el anillo crema de `.ficha-name` tiene el mismo color que el texto del nombre (`--cream`); se distingue por su separación (`outline-offset:2px`) y su trazo. Es la decisión del titular; la percepción queda al gate visual.

**Paso 8.** Sin ciclos de reparación (0 de 2).

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `git rev-parse 54bf973~1`; `git log`; `git show --name-only 54bf973` | padre `5fb3170` = `origin/main`; 3 commits; 2 rutas | igual | — | ninguna | — | — |
| R-02 | §8.2 constante; calibrado | `/tmp/s33b_r_payload.py` (Python) | `eb4e00b3…`; plantado distinto | igual; `1c3799e2…` | — | ninguna | — | C3 |
| R-03 | `:root` sin cambio | `/tmp/s33b_r_root.py` (Python), `<inicio>` y `HEAD` | 65; `04b2876e…` | igual | — | ninguna | — | C2 |
| R-04 | caso malo (M5/T1.4) | `/tmp/s33b_r2_foco.js` (SLEP con Enter; "san", 2.ª fila) sobre el motor de FASE 0; Python desde los tokens de `<inicio>` | 1,84 | 1,84 y 1,84 | — | ninguna | — | control `--foco` |
| R-05 | conteos (M6) | `awk index()` | 1; 1; 1; testigo 0 → 1 | igual; compartida 0 | — | ninguna | — | — |
| R-06 | 🔒6 (M7/T1.3/T2) | scripts de M7 sobre el motor final, dos modos; destinos por otra ruta | = M7 | = M7 (tras 1 reintento con ventana) | ADVIERTE (A-1) | nota | — | C8 |
| R-07 | calibración (M8) | `/tmp/s33b_r_diff.py` (Python) | hex +0/−0; `sigdifgru` +0/−0 | igual | — | ninguna | — | C1, C5 |
| R-08 | T1.1 anillo de la ficha | Python desde los hex del `:root` y el token de la regla; navegador por otra ruta | ≥ 3 (11,01) | 11,01 y 11,01 | — | ninguna | — | control `--foco` (1,84) |
| R-09 | T1.2 / 🔒7 anillo de `.cmp-cl` | Python; `cmp_slep`; `tope_escape` | `solid 2px rgb(0, 98, 160)`; 5,99 | igual | — | ninguna | — | — |
| R-10 | T1.5 sin hex ni `sigdifgru` | Python sobre el diff; `awk` | +0/−0; +0/−0; `+3 -2` | igual | — | ninguna | — | C1, C5 |
| R-11 | T2 build y testigo | md5 con `hashlib`; `awk` del testigo | `a41d9400…`; 1/0; 4 | igual | — | ninguna | — | — |
| 🔒1–🔒7 | invariantes | `/tmp/s33b_final.sh`; scripts de M7 | ver pasos 3 | 7/7 PASA | — | — | — | C1–C8 |
| ALC | alcance global | lista explícita + `grep -vxF` | 0 fuera | 0 (2 rutas + encargo y registro en `54bf973`) | — | — | — | C4 |
| REG | PRUEBAS a, b, c | `run_all()`; PRUEBAS b; §8.2 | `rc=0`, solo el LOG; 0 errores; `eb4e00b3…` | igual | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/0/1 (A-1). Ciclos de reparación usados: 0 de 2.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** ninguno (A-1 es del instrumento y transitoria; en el comando del paso 2 de T2 acorté la salida con un `sed` que no estaba escrito en el log, declarado en su `obtenido:`).

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 3 respecto de `origin/main` (`54bf973`, `6455185`, `e7f2ba4`).
obtenido: `?? 50_documentacion/andamios/logs/20260924_anillo_ficha_s33b_log.md` (única); `## main...origin/main [ahead 3]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33b (A-2 de s33: el anillo de foco de `.ficha-name` daba 1,84:1 sobre la barra de la ficha). Fases: FASE 0, T1, T2, R y L. Estado del grafo: T1 completada (`6455185`) · T2 completada (`e7f2ba4`) · FASE R APROBADO CON ADVERTENCIAS (sin reparaciones) · FASE L completada. Sin gates; ninguna tarea congelada.
2. **Commits** (`git log 5fb3170..HEAD --oneline`, antes del commit de este log):
   - `54bf973` chore(encargo): s33b y registro del asistente s33 (= `<inicio>`)
   - `6455185` fix(motor): anillo de foco en crema sobre la barra de la ficha (s33b T1, A-2 de s33)
   - `e7f2ba4` build(motor): s33b anillo de foco de la ficha (motor `a41d9400f0fc85b183103b68af31063d`)
   - (este log: `docs(log): s33b anillo de foco de la ficha`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/1; reparados 0.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, T1, T2 y la regresión) · 🔒2 PASA (`:root` `65`/`04b2876e…`; hex +0/−0) · 🔒3 PASA (`sigdifgru` +0/−0; `const sg=` 1) · 🔒4 PASA (0) · 🔒5 PASA (0) · 🔒6 PASA (= M7 en FASE 0, T1, T2 y FASE R, con ventana y headless; en FASE R, con un reintento con ventana, A-1) · 🔒7 PASA (`.cmp-cl` `solid 2px rgb(0, 98, 160)`, 5,99). 7/7.
5. **Decisiones del titular registradas:** A-2 de s33 → **sí**: el anillo de `.ficha-name` pasa a `--cream` (este encargo). A-1 de s33 → **sí**: el paso 1 del build se redacta "solo el motor y el LOG" (aplicado en T2.1 de este encargo, que se cumplió tal cual). Sin gates en esta sesión.
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0, en T1 (`a41d9400…`), en T2 (`a41d9400…`) y en la regresión (`a41d9400…`). Motor `5a83f63c…` → `a41d9400f0fc85b183103b68af31063d`; `docs/` sin cambios (`4b28a03fdaa00bd5dbb0a6fc501eab72`). Anillos (con ventana y headless, idénticos; y recalculados en Python desde los hex del `:root`):

   | respaldo | fondo opaco del ancestro | antes (`5a83f63c…`) | después (`a41d9400…`) |
   |---|---|---|---|
   | `.ficha-name` (elegir un establecimiento con Enter) | `rgb(10, 58, 92)` (`--azul`, barra de la ficha) | `solid 2px rgb(0, 98, 160)` (`--foco`), **1,84:1** | `solid 2px rgb(255, 246, 224)` (`--cream`), **11,01:1** |
   | `.cmp-cl` (10 de 10 y Escape) | `rgb(255, 246, 224)` (`--cream`) | `solid 2px rgb(0, 98, 160)`, 5,99:1 | igual, 5,99:1 |

7. **Dudas y pendientes consolidados:**
   - Ninguna duda nueva.
   - **Testigo del próximo despliegue:** `grep -c 'outline:2px solid var(--cream)'` → `1` en el motor y `0` en `docs/index.html`; `focoRespaldo` → `4` en el motor. md5 del motor a desplegar: `a41d9400f0fc85b183103b68af31063d` (lleva también todo s33).
   - Propuestos por el encargo para aparte (excluidos): pendientes 6 (desborde de pestañas) y 8 (desmarcar con el tope).
   - Nota de s33 que sigue vigente para el gate: tras un cierre con **clic** el respaldo recibe el foco sin anillo (`:focus-visible` sigue el último gesto); el gate se hace con teclado.
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:**
   - (1) M7: mi esperado propio decía `outline_color rgb(0, 98, 160)` en `.cmp-cl` y `.ficha-name`, sin distinguir los cierres sin anillo, donde el color calculado es el del texto. Costo: una nota.
   - (2) T2, segundo comando: al ejecutarlo agregué un `sed` que acorta la salida del resumidor y que no estaba escrito en el log; declarado en su `obtenido:`, con el JSON completo en `/tmp`. Costo: ninguno sobre cifras.
   - (3) FASE R, paso 2a: probé una vez `/tmp/s33b_r_anillo.py` antes de escribir su esperado (declarado en el paso; misma salida). Costo: ninguno sobre cifras.
   - Ningún error en el código del motor.
9. **Notas para el revisor:**
   - (a) Gate visual con teclado, comparador: llegar a 10 de 10 (Tab y Enter o Espacio sobre las filas) y cerrar con Escape: el foco queda en "Entidades a comparar · 10 de 10" con anillo **azul**.
   - (b) Gate visual con teclado, territorio: pestaña Establecimiento, buscar, elegir una fila con Enter: el foco queda en el nombre, en la cabecera azul de la ficha, con anillo **crema** separado 2 px del texto.
   - (c) El anillo crema tiene el mismo color que el texto del nombre: se distingue por el trazo y la separación; la percepción es del gate.
   - (d) Nada se desplegó.
10. **Estado de cierre:** commiteados `54bf973`, `6455185`, `e7f2ba4` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33b_priv.sh`: el patrón de RUT del encargo en una variable y su control plantado en un archivo aparte; "RBD" seguido de número; términos de establecimiento, descontando el identificador de acción `terr_liceo`, con su propio control plantado; nombre de la estación; los patrones viven solo en el script):
```
bash /tmp/s33b_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0` (el bruto solo cuenta líneas con `terr_liceo`); `nombre plantado: 1`; `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0` (bruto 10: las líneas con el identificador de acción `terr_liceo`); `nombre plantado: 1`; `estación por nombre: 0`. **Privacidad: PASA.** El log no nombra establecimientos ni personas; la estación figura como "estación del titular".

Paso 5 (verificación del archivo, después de rellenar el J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_anillo_ficha_s33b_log.md; ls -l $L && wc -l $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(sed -n "/^## J/,/^## Registro/p" $L | grep -c "^- ")"; bash /tmp/s33b_priv.sh | head -1'
```
esperado: `FASE=5` (FASE 0, T1, T2, R, L); `esperado` = `obtenido` + 1 al medir (este par todavía sin su `obtenido:`), sin desbalance previo porque las correcciones de este log no usan `obtenido:`; `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `51311` bytes y `293` líneas al medir; `FASE=5 esperado=19 obtenido=18 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **19 = 19**.
