# Log de sesión: las filas del modal caben en la lista (s33i)

- **Meta:** que ninguna fila de `EntityModal` supere el ancho de su lista en ninguna pestaña ni ancho, que el nombre no se parta mientras quepa en una línea y el `sub` sea lo primero que cede (en dos líneas, alineado a la derecha), y que el fondo de la fila marcada cubra la fila entera (T1, defecto del gate visual del titular: comparador, pestaña SLEP, 2 de 10 marcados); regenerar el motor (T2). Los textos y cifras de las filas no cambian. Sin despliegue.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `52a757f` (= `origin/main`, `docs(log)` de s33g). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = ` M 50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` y `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_filas_modal_s33i.md` (las dos rutas que la regla 1 admite; el registro con `1 insertion(+)`, la fila 6); `git stash list` vacío; `HEAD=52a757f origin/main=52a757f`; `HEAD..origin/main=0`, `origin/main..HEAD=0`; motor `2a436756f8a4dff35b203b246eb022eb`, `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72`; reglas de la fila (`.modal{…max-width:540px;…}`, `.comuna-checklist{display:flex;flex-direction:column;…overflow-y:auto;}`, `.check-row{display:flex;align-items:center;gap:10px;padding:7px 11px;…}`, `.check-name{flex:1 1 auto;…}`, `.check-region{flex:0 0 auto;…}`) = premisas de §1. Primer acto (autorizado): commit `11da123` chore(encargo): s33i y registro del asistente s33, hijo de `52a757f` (`2 files changed, 128 insertions(+)`). **PUNTO DE RETORNO `<inicio>` = `11da123`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); `bash` 3.2 explícito (toda expresión con `{m,n}` y toda regla CSS con llaves va en un script en `/tmp/s33i_*`); `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`); con ventana, `waitForSelector` visible antes de actuar; R 4.5.2 con `renv` para el build.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular mandan sobre el modo: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_filas_modal_s33i.md` (commit `11da123`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (reparto del ancho de la fila)   ALCANCE: 30_procesamiento/35_motor_template.html
T2 (build)                          ALCANCE: 40_salidas/motor_idps.html; requiere T1 completada
Serie: T1 → T2; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33i_*`; los 48 scripts de `/tmp/s33g_*` copiados con las rutas internas, el `<inicio>` (`955fbfe` → `11da123`) y la ruta del log de privacidad reescritos (medido: 0 restos). **Lectura de 🔒7 fijada antes de editar:** el log s33g no midió foco ni teclado (su contrato no tenía ese 🔒); las líneas base más recientes registradas son las de s33f M8 (= s33e), que siguen en `/tmp/s33f_m8_*`; 🔒7 se mide contra M4 de esta sesión y M4 se compara con s33f M8. Convenciones: **un `esperado:` y un `obtenido:` por comando**; una corrección va como `- **Corrección:** …`; los patrones de privacidad viven solo en su script; **ningún RBD con número ni nombre de establecimiento en el log** (nombres de SLEP, comuna y región sí).

## J. Juicio (lo rellena FASE L)

- Meta y resultado: ninguna fila de los dos modales escribe fuera de su lista (SLEP del comparador: contenido de 549 px en listas de 494 → 0 px fuera; Nacional y Establecimiento "viña" también), el nombre no se parte mientras quepa (36 → 0 nombres partidos en SLEP a 1280) y el `sub` cede primero en dos líneas a la derecha; el fondo de la fila marcada la cubre entera; textos intactos.
- Estado por tarea: FASE 0 completada · T1 completada (`378f02e`) · T2 completada (`8f7f29d`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
- Commits: 4, rango `11da123`..`<docs(log)>` (`git log --oneline 52a757f..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/1; reparados 0; abiertos 1: A-1 (la fila Chile pasa a dos líneas); control positivo 2 de 2.
- Invariantes: 8/8 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒2 `:root` `04b2876e…` y hex +0/−0; 🔒3 0/0; 🔒4 0; 🔒5 0; 🔒6 808 filas con el mismo texto; 🔒7 foco = M4 = s33f M8; 🔒8 cuatro CSV byte a byte); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, T1, T2 y la regresión, re-derivado en Python; textos, números y cifras de las filas sin cambio por dos instrumentos).
- Decisiones autónomas de mayor riesgo: (1) V1 (`.check-name{flex:0 1 auto;min-width:0}`, `.check-region{flex:1 1 0;text-align:right}`) en lugar del punto de partida V0, que no cumplía (ii); (2) sin `overflow-x:hidden` (no hizo falta); (3) la fila Chile leída como "mismo texto, clase y borde, dentro de la lista", aunque cambie de alto; (4) 🔒7 medido contra s33f M8 porque s33g no midió foco.
- Desviaciones respecto del encargo: la proporción final difiere del punto de partida literal de T1.2 (lo admite "la proporción que haga falta, medida"); ninguna en criterio ni en alcance.
- Dudas abiertas: 1: A-1 ¿se acepta la fila Chile en dos líneas en la pestaña Nacional? (sí/no).
- Errores propios: 0 con efecto en código, cifras o conclusión; 2 de instrumento corregidos y repetidos (holgura del criterio (ii) en mi resumen; re-derivador escrito sobre un archivo existente).
- Qué debe verificar el revisor por sí mismo: comparador → Agregar → SLEP con dos marcados: nombres en una línea, texto gris entero en dos líneas a la derecha, sin barra horizontal, fondo de las marcadas completo; la pestaña Nacional de los dos modales.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `s33i: el sub cede ancho`: 1 en el motor, 0 en `docs/`; md5 `7ad76f36e42d66c4da2d71aa28a558eb`). La respuesta a A-1.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `11da123` (primer acto).

**M1 a M3** (el motor de FASE 0 se guarda en `/tmp/s33i_motor_fase0.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; echo "primer commit: $(git -C $R show --name-only --format= HEAD | tr "\n" " ")"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) HEAD~1=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s33i_motor_fase0.html; echo "motor $(md5 -q $M) docs $(md5 -q $R/docs/index.html)"; bash /tmp/s33i_payload_sha.sh /tmp/s33i_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33i_fecha_alterada.js /tmp/s33i_motor_fase0.html /tmp/s33i_motor_fecha.html; bash /tmp/s33i_payload_sha.sh /tmp/s33i_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33i_plantar_payload.js /tmp/s33i_motor_fase0.html /tmp/s33i_motor_plantado.html; bash /tmp/s33i_payload_sha.sh /tmp/s33i_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s33i_root_md5.sh $R/30_procesamiento/35_motor_template.html'
```
esperado: M1 solo este LOG (`?? …_s33i_log.md`), `stash: []`, el primer commit con el encargo y el registro; M2 `fetch rc=0`, `HEAD=11da123`, `HEAD~1=52a757f` = `origin/main`, `HEAD..origin/main=0`, `origin/main..HEAD=1`; M3 motor `2a436756…`, `docs` `4b28a03f…`, §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; `:root` `lineas: 65; md5 04b2876e…`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_filas_modal_s33i_log.md` (única), `stash: []`, primer commit = `…/encargo_claude_code_idps_filas_modal_s33i.md` y `…/20260924_registro_asistente_s33.md`; M2 `fetch rc=0`, `HEAD=11da123 HEAD~1=52a757f origin/main=52a757f`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 `motor 2a436756f8a4dff35b203b246eb022eb docs 4b28a03fdaa00bd5dbb0a6fc501eab72`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada → igual, cifra plantada → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. Reglas 1 y 2 no disparan; la calibración de M3 funciona.

**M4 — líneas base de 🔒6, 🔒7 y PRUEBAS d.**

M4a, 🔒6 (instrumento nuevo `/tmp/s33i_filas.js`: modal de territorio y del comparador, las cinco pestañas, búsqueda vacía y "viña" donde hay buscador; guarda el `textContent` de cada fila —independiente del ancho— y la geometría; al final marca dos SLEP en el comparador; resumen `/tmp/s33i_filas_resumen.py`, que nunca imprime textos). Línea base a 1280 px, headless; el mismo motor a 390 px como control de que el texto no depende del ancho:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33i_filas.js /tmp/s33i_motor_fase0.html 1280 headless /tmp/s33i_m4_1280.json; node /tmp/s33i_filas.js /tmp/s33i_motor_fase0.html 390 headless /tmp/s33i_m4_390.json; python3 /tmp/s33i_filas_resumen.py textos /tmp/s33i_m4_1280.json /tmp/s33i_m4_390.json; python3 -c "import json; d=json.load(open(\"/tmp/s33i_m4_1280.json\")); print({k: len(v[\"filas\"]) if v else None for k,v in d[\"estados\"].items()})"'
```
esperado: 19 estados por corrida (2 modales × 5 pestañas con búsqueda vacía, más "viña" en las 4 con buscador de cada modal, más `cmp|SLEP|2marcados`); `conteo` "2 de 10"; 0 errores; el número de filas por estado y el md5 total de los textos registrados; a 390 px, **los mismos textos** (`estados distintos 0`).
obtenido: dos corridas con `estados 19`, `conteo "2 de 10"`, 0 errores; `estados 18 | filas 808 | md5 total a 6e94a643f467da7c8dd9e01465379b15 b 6e94a643f467da7c8dd9e01465379b15 | estados distintos 0` (el `2marcados` no entra en la comparación de textos); filas por estado, iguales en los dos modales: Establecimiento `-` 0 (sin búsqueda la pestaña no lista) y `viña` 5; Comuna `-` 345 y `viña` 1; SLEP `-` 36 y `viña` 0; Región `-` 16 y `viña` 0; Nacional 1 (sin buscador); `cmp|SLEP|2marcados` 36. Línea base de 🔒6: `/tmp/s33i_m4_1280.json` (md5 total `6e94a643…`).

M4b, 🔒7 (`/tmp/s33i_l6.js` y `/tmp/s33i_foco.js`, copias de s33g, en los dos modos, y comparación textual con s33f M8 —la línea base de foco más reciente, ver la lectura del encabezado—):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33i_motor_fase0.html; for m in ventana headless; do node /tmp/s33i_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33i_m4_l6_$m.json; python3 /tmp/s33i_l6_resumen.py /tmp/s33i_m4_l6_$m.json; done; for m in ventana headless; do node /tmp/s33i_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33i_m4_foco.jsonl; diff <(python3 /tmp/s33f_foco_resumen.py /tmp/s33f_m8_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33[a-z]_motor_[a-z0-9]+\.html/MOTOR/") <(python3 /tmp/s33i_foco_resumen.py /tmp/s33i_m4_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33[a-z]_motor_[a-z0-9]+\.html/MOTOR/") && echo "foco = s33f M8"; for m in ventana headless; do diff <(python3 /tmp/s33f_l6_resumen.py /tmp/s33f_m8_l6_$m.json) <(python3 /tmp/s33i_l6_resumen.py /tmp/s33i_m4_l6_$m.json) && echo "l6 $m = s33f M8"; done'
```
esperado: `terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` en los dos modos; `foco = s33f M8`, `l6 ventana = s33f M8`, `l6 headless = s33f M8`.
obtenido: `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; `foco = s33f M8`, `l6 ventana = s33f M8`, `l6 headless = s33f M8`. Línea base de 🔒7: `/tmp/s33i_m4_l6_{ventana,headless}.json` y `/tmp/s33i_m4_foco.jsonl`.

M4c, PRUEBAS d (`/tmp/s33i_csv.js`, los cuatro casos de s33f M6):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33i_csv.js /tmp/s33i_motor_fase0.html f0 cmp5,ficha,pan,hist_foco > /tmp/s33i_m4_csv.json; python3 -c "import json; d=json.load(open(\"/tmp/s33i_m4_csv.json\")); [print(k, d[k].get(\"archivo\"), d[k].get(\"md5\"), d[k].get(\"bom\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"cmp5\",\"ficha\",\"pan\",\"hist_foco\")]; print(\"dialogos\", d[\"dialogos\"])"'
```
esperado: `cmp5` `idps_comparador_4b_2025.csv` `ee741cb7be811b029e888d6cbe85fde5`; `ficha` `idps_ficha_<rbd>_4b.csv` `3b092123be1750d277b91f32ba0a071a`; `pan` `idps_panorama_slep_costa_central_4b_2025.csv` `cd5ebb55a2cb02efa5598dd5a6a4f465`; `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv` `856071a8ffdfc90b3c6226251e44fbef`; BOM; 0 errores; sin diálogos.
obtenido: `cmp5` `idps_comparador_4b_2025.csv` `ee741cb7be811b029e888d6cbe85fde5`; `ficha` `idps_ficha_<rbd>_4b.csv` `3b092123be1750d277b91f32ba0a071a`; `pan` `idps_panorama_slep_costa_central_4b_2025.csv` `cd5ebb55a2cb02efa5598dd5a6a4f465`; `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv` `856071a8ffdfc90b3c6226251e44fbef`; BOM `True` en los cuatro; 0 errores; `dialogos []`. **= s33f M6.**

**M5 — caso malo de T1** (`/tmp/s33i_filas.js` a 1280 × 800 y 390 × 800, con ventana y headless; resumen por estado: filas, `scrollWidth/clientWidth` de la lista, filas que pasan la lista, contenido que pasa la fila —el fondo de `.is-checked` no lo cubre—, nombres en 2+ líneas, `sub` encogido, `sub` en 2+ líneas y `sub` no visible entero; con el detalle de `cmp|SLEP|2marcados` a 1280):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for w in 1280 390; do for m in headless ventana; do node /tmp/s33i_filas.js /tmp/s33i_motor_fase0.html $w $m /tmp/s33i_m5_${w}_$m.json > /dev/null; done; done; python3 /tmp/s33i_filas_resumen.py /tmp/s33i_m5_1280_headless.json /tmp/s33i_m5_1280_ventana.json /tmp/s33i_m5_390_headless.json /tmp/s33i_m5_390_ventana.json; python3 /tmp/s33i_filas_resumen.py /tmp/s33i_m5_1280_headless.json detalle "cmp|SLEP|2marcados" | head -8'
```
esperado: en la pestaña SLEP del comparador (y en `cmp|SLEP|2marcados`): `scrollWidth` > `clientWidth` de la lista, `sub_encogido 0` (el `sub` no cede), nombres en 2 líneas y contenido que pasa la fila en las marcadas; se registra qué otras pestañas y anchos desbordan; 0 errores.
obtenido: 0 errores y `conteo 2 de 10` en las cuatro corridas. En **ninguna** fila el rectángulo de `.check-row` pasa la lista (`pasa_lista 0`: la fila es un ítem estirado de la columna y mide lo que la lista); lo que desborda es su **contenido**, que sale de la fila y agranda el `scrollWidth` de la lista. **Caso malo confirmado** en la pestaña SLEP del comparador, en los cuatro casos (1280 y 390, headless y ventana; también `2marcados`): lista `549/494` (1280 headless), `549/464` (1280 ventana), `549/304` y `549/259` (390); **36 de 36** filas con contenido fuera de la fila, `sub_encogido 0`, **36 nombres en 2 o más líneas**, 36 `sub` no visibles enteros; en `2marcados`, las 2 filas marcadas tienen contenido fuera de la fila (el fondo no lo cubre). Detalle (1280, headless, `cmp|SLEP|2marcados`): fila 494 px; nombre de 83,6 px en 2 líneas (o 64,3 px en 3); `sub` de 406,4 px en una línea, igual a su ancho natural. **Otras pestañas que desbordan:** **Nacional en los dos modales y en todos los anchos** (lista `496/494` en territorio y `524/494` en el comparador a 1280; `496/304` y `524/304` a 390: el `sub` de la fila Chile mide 436,7 px y no cede); **Establecimiento con "viña" en el comparador a 390** (`389/304` headless, `389/274` ventana; 4 y 5 filas). Sin desborde pero con nombres partidos a 390 (el `sub` no cede y el nombre sí): Comuna y SLEP del modal de territorio con ventana (3 y 14 nombres), Comuna del comparador (1 y 9), Establecimiento con "viña" (4–5). Diferencias de `clientWidth` entre pestañas con ventana (494/479/464, 289/274/259): barras de desplazamiento verticales de la lista y del cuerpo del modal (15 px cada una). Regla 6 no dispara.
- **Lecturas fijadas antes de editar:** (1) el criterio (i) incluye la pestaña **Nacional**, que también desborda hoy; T1.3 "la fila Chile (`.is-nac`) sigue igual en su pestaña" se lee como: una sola fila, mismo texto (🔒6), clase `.is-nac` con su borde punteado, y cabe en la lista; su geometría puede cambiar, porque hoy su `sub` sale de la lista. (2) El criterio (ii) se mide por fila: si el nombre ocupa más de una línea, debe ser porque no cabe en una línea junto al `sub` en su ancho mínimo (la palabra más larga), es decir, el `sub` ya cedió todo lo que podía. Para eso `/tmp/s33i_filas.js` suma, desde ahora, el ancho natural del nombre, el ancho mínimo del `sub` (su palabra más larga), el ancho interior de la fila, la casilla y el `gap`, y el resumen cuenta las filas que violan (ii) (`ii_viol`).

**M6 — capturas de referencia** (informe, no 🔒; instrumento nuevo `/tmp/s33i_modal_foto.js`: elemento `.modal` a 1280 × 800, headless; comparador en sus cinco pestañas —Establecimiento con "viña"— y con 2 SLEP marcados, territorio en Comuna y SLEP):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33i_modal_foto.js /tmp/s33i_motor_fase0.html f0 1280; for f in /tmp/s33i_cap_*_f0.png; do echo "$(basename $f) $(magick identify -format "%wx%h" $f)"; done'
```
esperado: 8 PNG (`terr_Comuna`, `terr_SLEP`, `cmp_Establecimiento`, `cmp_Comuna`, `cmp_SLEP`, `cmp_Region`, `cmp_Nacional`, `cmp_SLEP2`), 0 errores; en `cmp_SLEP2` se ve el defecto de las capturas del titular (se revisa la imagen).
obtenido: 0 errores; ocho PNG de 540 px de ancho (`cmp_Comuna 540x676`, `cmp_Establecimiento 540x554`, `cmp_Nacional 540x366`, `cmp_Region 540x676`, `cmp_SLEP 540x704`, `cmp_SLEP2 540x704`, `terr_Comuna 540x675`, `terr_SLEP 540x704`). Revisada `cmp_SLEP2` con el lector de imágenes: **el defecto de las capturas del titular se reproduce**: "SLEP / Aconcagua" y "SLEP / Andalién / Costa" partidos en 2 y 3 líneas, el `sub` ("Traspaso 2026 · 6 comunas · 63 establecimientos en el di…") cortado en el borde derecho de la lista, y el fondo de las dos filas marcadas llega solo al borde visible.

**M7 — calibración del testigo de T2.** Cadena fijada antes de editar: el comentario de T1 será `/* s33i: el sub cede ancho y la fila nunca supera la lista (gate visual de s33g). */`, y el testigo, `s33i: el sub cede ancho`:
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; C="s33i: el sub cede ancho"; echo "testigo docs $(grep -c -F "$C" $R/docs/index.html) motor $(grep -c -F "$C" $R/40_salidas/motor_idps.html) plantilla $(grep -c -F "$C" $R/30_procesamiento/35_motor_template.html)"'
```
esperado: `docs 0`, `motor 0`, `plantilla 0`.
obtenido: `testigo docs 0 motor 0 plantilla 0`. **Testigo elegido: `s33i: el sub cede ancho`.**

- **Estado de FASE 0:** completada. M1–M7 coinciden con su esperado. Reglas 1, 2 y 6 no disparan (el caso malo se reproduce en M5 y en la captura de M6). Hallazgo registrado en M5: la pestaña **Nacional** desborda en los dos modales y en todos los anchos, y **Establecimiento con "viña"** en el comparador a 390; el criterio (i) de T1 los cubre. Lecturas fijadas antes de editar: 🔒7 contra M4 (= s33f M8); fila Chile; criterio (ii) medido por fila (`ii_viol`).
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `11da123` (hijo de `52a757f` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno en FASE 0.

### FASE T1: el `sub` cede ancho y la fila nunca supera la lista

- **Paso 0:** releí M5: el contenido de la fila sale de la fila (y de la lista) porque `.check-region{flex:0 0 auto}` no cede y `.check-name{flex:1 1 auto}` sí (hasta su palabra más larga): en SLEP del comparador el `sub` mide 406 px en una línea y el nombre queda en 64–84 px, en 2–3 líneas; en Nacional el `sub` de Chile (437 px) no cabe ni a 1280.
- **Diseño medido antes de editar la plantilla** (encargo T1.2: "la proporción que haga falta para cumplir (ii), medida y no supuesta"). Script nuevo `/tmp/s33i_variantes.sh`: copias del motor de FASE 0 con las dos reglas reemplazadas por texto (las reglas viven en el script, por bash 3.2), medidas con `/tmp/s33i_filas.js` (ya con los campos de (ii)) a 1280 y 390, headless; el motor de FASE 0 otra vez como contraste (ahora con `ii_viol`):
  - **V0, el punto de partida del encargo:** `.check-name{flex:1 1 auto;min-width:0;…}` y `.check-region{flex:0 1 auto;min-width:0;text-align:right;…}`.
  - **V1, el `sub` solo toma el espacio libre:** `.check-name{flex:0 1 auto;min-width:0;…}` y `.check-region{flex:1 1 0;text-align:right;…}` (base 0: al faltar espacio, lo que se encoge es el nombre solo después de que el `sub` baja a su ancho mínimo, que por defecto es su palabra más larga; al sobrar, el `sub` se estira y queda alineado a la derecha como hoy).
```
bash /tmp/s33i_variantes.sh
```
esperado: (propio) para cada variante, en los 19 estados de cada ancho: `lista` con `scrollWidth = clientWidth`, `contenido_pasa_fila 0`, `sub_no_visible 0`, `marc_no_cubre 0` (criterios i y iii); y **`ii_viol 0`** (criterio ii). FASE 0: `ii_viol` > 0 al menos en SLEP del comparador. Se elige la variante que cumpla los tres criterios en los dos anchos; si ninguna, se registra y se sigue midiendo.
obtenido: 0 errores y `conteo 2 de 10` en las seis corridas. Estados con alguna falla (los demás, sin falla, omitidos por el filtro del script): **FASE 0** — a 1280 `terr|Nacional` y `cmp|Nacional` (lista 496/494 y 524/494, contenido fuera de la fila), `cmp|SLEP|-` y `2marcados` (549/494, 36 contenidos fuera, `ii_viol 36`, `marc_no_cubre 2`), Establecimiento con "viña" (`ii_viol 1` y `4`); a 390 lo mismo más `cmp|Establecimiento|viña` 389/304. **V0** — (i) y (iii) se cumplen en todo (listas `494/494` y `304/304`, 0 contenidos fuera, `marc_no_cubre 0`), pero **(ii) no**: `cmp|SLEP` con 36 nombres partidos y `ii_viol 36` a 1280 (25 a 390), y Establecimiento con "viña": al encogerse los dos a la vez, el nombre sigue partiéndose aunque cabría. **V1** — a 1280, **ningún estado con falla**; a 390, solo `cmp|SLEP|-` y `2marcados` con `ii_viol 1`. Detalle de esa fila (a 390): nombre natural 138,7 px y real 138,2 en 2 líneas; `sub` en su mínimo (105,8 = su palabra más larga, 4 líneas); casilla 18, `gap` 10: 18 + 10 + 138,7 + 10 + 105,8 = **282,5 px en un interior de 282**: el nombre **no** cabe por 0,5 px y se parte con razón; mi resumen contaba "cabe" con una holgura de +0,5 px a favor.
- **Corrección (tolerancia de mi instrumento, no del encargo):** el resumen pasa a contar como violación de (ii) solo las filas cuyo nombre se parte y que caben con al menos 0,5 px de margen (`ii_viol`), y aparte las que quedan a menos de 0,5 px del borde (`ii_limite`); se aplica igual a todos los motores. Re-resumen de las mismas seis corridas (sin volver a abrir el navegador):
```
bash -c 'cd /tmp; for k in fase0 v0 v1; do python3 /tmp/s33i_filas_resumen.py /tmp/s33i_var_${k}_1280.json /tmp/s33i_var_${k}_390.json | grep -E "^==|ii_viol [1-9]|ii_limite [1-9]" | cut -c1-200; done'
```
esperado: (propio) V1 sin estados con `ii_viol` ni `ii_limite` > 0 en los dos anchos; V0 y FASE 0 con violaciones de (ii) en SLEP del comparador.
obtenido: FASE 0: `ii_viol 36` (1280) y `23` + `ii_limite 1` (390) en `cmp|SLEP|-` y `2marcados`, `ii_viol 1`/`4` en Establecimiento con "viña"; V0: los mismos (36; 23 + 1; 1; 4); **V1: ningún estado con `ii_viol` ni `ii_limite` > 0, en 1280 ni en 390.**
- **Decisión de diseño:** **V1**. Cumple (i), (ii) y (iii) en los 19 estados de cada ancho, y V0 (el punto de partida del encargo) no cumple (ii). La proporción medida: el nombre con base en su ancho natural (`flex:0 1 auto`, `min-width:0`) y el `sub` con base 0 (`flex:1 1 0`, `text-align:right`, sin `min-width:0`, para que no baje de su palabra más larga): así el `sub` solo ocupa el espacio que sobra y cede primero, en líneas alineadas a la derecha; el nombre solo se parte cuando no cabe ni con el `sub` en su mínimo. No hizo falta `overflow-x:hidden` en la lista (sin barra fantasma: `scrollWidth = clientWidth` en los 38 estados de V1).
- **Implementación** (§6 T1.2): antes de `.check-name`, el comentario de una línea con la cadena de M7 (`/* s33i: el sub cede ancho y la fila nunca supera la lista (gate visual de s33g). */`); `.check-name{flex:1 1 auto;…}` → `.check-name{flex:0 1 auto;min-width:0;…}`; `.check-region{flex:0 0 auto;…}` → `.check-region{flex:1 1 0;text-align:right;…}`. Nada más (ni la lista, ni `.check-row`, ni textos).
- **Verificación 1 — árbol y build temporal:**
```
bash -c 'bash /tmp/s33i_arbol.sh t1; git -C /Users/tomgc/Projects/slep_idps diff -U0 -- 30_procesamiento/35_motor_template.html | grep "^[+-][^+-]" | cut -c1-90; bash /tmp/s33i_build.sh t1'
```
esperado: `stat sin commitear: 1 file changed, 3 insertions(+), 2 deletions(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; las 5 líneas: las dos reglas viejas, el comentario y las dos reglas nuevas; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…4dc4`; `:root` `04b2876e…`.
obtenido: `stat sin commitear:  1 file changed, 3 insertions(+), 2 deletions(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; las cinco líneas esperadas; `rc=0 warn=0 pasos_ok=1`; motor temporal `7ad76f36e42d66c4da2d71aa28a558eb`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`.
- **Verificación 2 — M5 repetido** (`/tmp/s33i_filas.js` sobre el motor de T1, 1280 y 390, headless y ventana; el filtro imprime solo los estados con alguna falla de (i), (ii) o (iii); después, el detalle de SLEP del comparador con 2 marcados a 1280 y de Nacional, y 🔒6 contra M4):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for w in 1280 390; do for m in headless ventana; do node /tmp/s33i_filas.js /tmp/s33i_motor_t1.html $w $m /tmp/s33i_t1_${w}_$m.json; done; done; for w in 1280 390; do for m in headless ventana; do python3 /tmp/s33i_filas_resumen.py /tmp/s33i_t1_${w}_$m.json | python3 -c "
import sys, re
n = 0
for l in sys.stdin:
    l = l.rstrip()
    if l.startswith(\"==\"): print(l[:70]); continue
    n += 1; m = re.search(r\"lista (\d+)/(\d+)\", l); ok = m and m.group(1) == m.group(2)
    bad = any(re.search(p + r\" ([1-9]\d*)\", l) for p in (\"contenido_pasa_fila\", \"pasa_lista\", \"ii_viol\", \"ii_limite\", \"sub_no_visible\", \"marc_no_cubre\"))
    if not ok or bad: print(\"  FALLA \" + l.strip()[:220])
print(\"  estados revisados\", n)"; done; done; python3 /tmp/s33i_filas_resumen.py /tmp/s33i_t1_1280_headless.json detalle "cmp|SLEP|2marcados" | sed -n 2,5p; python3 /tmp/s33i_filas_resumen.py /tmp/s33i_t1_1280_headless.json detalle "cmp|Nacional|-" | tail -1; python3 /tmp/s33i_filas_resumen.py /tmp/s33i_t1_390_headless.json detalle "cmp|Nacional|-" | tail -1; python3 /tmp/s33i_filas_resumen.py /tmp/s33i_t1_1280_headless.json | grep -E "cmp\|SLEP" | cut -c1-200; python3 /tmp/s33i_filas_resumen.py textos /tmp/s33i_m4_1280.json /tmp/s33i_t1_1280_headless.json; python3 /tmp/s33i_filas_resumen.py textos /tmp/s33i_m4_1280.json /tmp/s33i_t1_390_ventana.json'
```
esperado: las cuatro corridas con 0 errores y `conteo 2 de 10`; **ningún estado con FALLA** en los 19 × 4 (lista `scrollWidth = clientWidth`, 0 filas o contenidos fuera, `ii_viol 0`, `ii_limite 0`, `sub` visible entero, fondo de las marcadas cubriendo la fila); en `cmp|SLEP|2marcados` a 1280, **cada nombre en 1 línea** y el `sub` entero en 1 o 2 líneas alineado a la derecha; la fila Chile (`.is-nac`) dentro de la lista, en una fila, con su texto; 🔒6: `estados distintos 0` y el md5 total `6e94a643…` de M4, en headless y con ventana.
obtenido: las cuatro corridas `estados 19`, `conteo "2 de 10"`, `errores 0`; **ningún estado con FALLA** (`estados revisados 19` en 1280 headless, 1280 ventana, 390 headless y 390 ventana). `cmp|SLEP|-` y `2marcados` a 1280: lista `494/494`, `contenido_pasa_fila 0`, **`nombre>1l 0`**, `ii_viol 0 ii_limite 0`, `sub` en 2 líneas en las 36 filas, `sub_no_visible 0`; detalle: filas de 494 × 57 px, nombres de 128,4 / 157,1 / 138,7 / 110,3 px **en 1 línea**, `sub` de 276,9–323,7 px (natural 406,4) **en 2 líneas, alineado a la derecha**, visible entero, las dos marcadas sin contenido fuera de la fila. Fila Chile en Nacional: a 1280 `fila 494 alto 58 | nombre 37.4 (1l) | sub 394.6/436.7 (2l) right | … visible True`; a 390 `fila 304 alto 79 | … sub 204.6 (3l) … visible True`. 🔒6: `estados 18 | filas 808 | md5 total … 6e94a643f467da7c8dd9e01465379b15 … | estados distintos 0` contra M4, con el motor de T1 en headless a 1280 **y** con ventana a 390.
- **Verificación 3 — fila Chile, 🔒7 y PRUEBAS b** (la clase y el borde de la fila `.is-nac` en los dos modales; foco y teclado contra M4; PRUEBAS b de s33):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33i_motor_t1.html; node -e "
const puppeteer=require(\"puppeteer\");(async()=>{const b=await puppeteer.launch({executablePath:\"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome\",headless:true,args:[\"--allow-file-access-from-files\"]});const p=await b.newPage();await p.setViewport({width:1280,height:800});await p.goto(\"file://$M\",{waitUntil:\"load\",timeout:180000});await p.waitForSelector(\".terr-trigger\",{visible:true,timeout:180000});
const nac=async()=>{await p.evaluate(()=>[...document.querySelectorAll(\".modal .modal-tab\")].find(x=>x.textContent.trim()===\"Nacional\").click());await new Promise(r=>setTimeout(r,400));return p.evaluate(()=>{const r=[...document.querySelectorAll(\".modal .check-row\")];const s=r[0]&&getComputedStyle(r[0]);return {filas:r.length,is_nac:r.map(x=>x.classList.contains(\"is-nac\")),borde:s&&s.borderTopStyle+\" \"+s.borderTopWidth,fondo:s&&s.backgroundColor};});};
await p.click(\".terr-trigger\");await p.waitForSelector(\".modal .modal-tab\",{visible:true});console.log(\"terr\",JSON.stringify(await nac()));await p.keyboard.press(\"Escape\");await new Promise(r=>setTimeout(r,300));
await p.evaluate(()=>[...document.querySelectorAll(\".screen-tab\")].find(x=>x.textContent.startsWith(\"Comparación\")).click());await new Promise(r=>setTimeout(r,300));await p.click(\".cmp-add\");await p.waitForSelector(\".modal .modal-tab\",{visible:true});console.log(\"cmp\",JSON.stringify(await nac()));await b.close();})();"; for m in ventana headless; do node /tmp/s33i_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33i_t1_l6_$m.json; done; for m in ventana headless; do node /tmp/s33i_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33i_t1_foco.jsonl; diff <(python3 /tmp/s33i_foco_resumen.py /tmp/s33i_m4_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33i_motor_[a-z0-9]+\.html/MOTOR/") <(python3 /tmp/s33i_foco_resumen.py /tmp/s33i_t1_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33i_motor_[a-z0-9]+\.html/MOTOR/") && echo "foco = M4"; for m in ventana headless; do python3 /tmp/s33i_l6_resumen.py /tmp/s33i_t1_l6_$m.json; diff <(python3 /tmp/s33i_l6_resumen.py /tmp/s33i_m4_l6_$m.json) <(python3 /tmp/s33i_l6_resumen.py /tmp/s33i_t1_l6_$m.json) && echo "l6 $m = M4"; done; bash /tmp/s33i_pruebas_b.sh $M'
```
esperado: en los dos modales, Nacional con 1 fila, `is_nac [true]`, `borde dashed 1px` y el fondo de `--panel` (igual que en FASE 0: la regla `.is-nac` no se tocó); `foco = M4`, `l6 ventana = M4`, `l6 headless = M4` (con la línea `… terr N354 … errores 0` en cada modo); PRUEBAS b `"consola_errores":[] "pageerror":[]`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`.
obtenido: `terr {"filas":1,"is_nac":[true],"borde":"dashed 1px","fondo":"rgb(255, 253, 247)"}` y `cmp` idéntico (la fila Chile conserva su clase, su borde punteado y su fondo); `foco = M4`; `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0`, `l6 ventana = M4`; `headless | …` idéntico, `l6 headless = M4`; PRUEBAS b `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`. **🔒7 PASA; PRUEBAS b sin errores.**
- **Revisión visual propia** (informe, fuera de los criterios: las capturas de M6 con el motor de T1 y su AE frente a FASE 0, para ver qué pestañas cambian a la vista; y la imagen del caso del titular):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33i_modal_foto.js /tmp/s33i_motor_t1.html t1 1280; for k in terr_Comuna terr_SLEP cmp_Establecimiento cmp_Comuna cmp_SLEP cmp_Region cmp_Nacional cmp_SLEP2; do echo "$k $(magick identify -format "%wx%h" /tmp/s33i_cap_${k}_t1.png) AE=$(magick compare -metric AE /tmp/s33i_cap_${k}_f0.png /tmp/s33i_cap_${k}_t1.png null: 2>&1)"; done'
```
esperado: (propio) sin cambio visible (AE 0) en las pestañas que no desbordaban y cuyo nombre no se partía: `terr_Comuna`, `cmp_Comuna`, `cmp_Region`, `terr_SLEP`; cambio en `cmp_SLEP`, `cmp_SLEP2`, `cmp_Nacional` y `cmp_Establecimiento` (con "viña": nombres partidos antes).
obtenido: 0 errores; `terr_Comuna AE=0`, `terr_SLEP AE=0`, `cmp_Comuna AE=0`, `cmp_Region AE=0` (sin cambio a la vista); `cmp_Establecimiento 540x551 AE=11141.9` (554 → 551 de alto), `cmp_SLEP AE=12424`, `cmp_SLEP2 AE=13170.9`, `cmp_Nacional 540x384 AE=4739.15` (366 → 384 de alto: el `sub` de Chile en dos líneas). Revisadas con el lector de imágenes `cmp_SLEP2` y `cmp_Nacional`: "SLEP Aconcagua", "SLEP Andalién Costa", etc. en una línea; el `sub` ("Traspaso 2026 · 6 comunas · 63 / establecimientos en el directorio") entero en dos líneas alineadas a la derecha; el fondo de las dos marcadas cubre la fila; la fila Chile con su borde punteado y el `sub` ("Nivel nacional · 346 comunas · 9.136 establecimientos en el / directorio") entero en dos líneas.
- **Estado de T1:** completada. M5 repetido sin fallas en los 76 estados (19 × 2 anchos × 2 modos); (i), (ii) y (iii) cumplidos; fila Chile con su estilo y dentro de la lista; 🔒6 y 🔒7 PASAN; PRUEBAS b sin errores; sin `overflow-x:hidden` (no hizo falta). Commit con solo la plantilla:
- **Commit:** `378f02e` fix(motor): las filas del modal caben en la lista; el sub cede ancho (s33i T1) (`1 file changed, 3 insertions(+), 2 deletions(-)`).

### FASE T2: build

- **Requisito:** T1 completada (`378f02e`).
- **Paso 1 — porcelain antes del build:**
```
git -C /Users/tomgc/Projects/slep_idps status --porcelain
```
esperado: solo ` M 40_salidas/motor_idps.html` (el build temporal de T1) y `?? …_s33i_log.md`.
obtenido: ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260924_filas_modal_s33i_log.md`. Conforme; T2 sigue.
- **Paso 2 — build completo (PRUEBAS a), hash y porcelain** (`/tmp/s33i_build.sh t2 completo`):
```
bash -c 'bash /tmp/s33i_build.sh t2 completo; git -C /Users/tomgc/Projects/slep_idps status --porcelain; echo "motor_repo $(md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html)"; echo "warnings_en_log $(grep -ciE warn /tmp/s33i_run_t2.log)"'
```
esperado: `rc=0 warn=0 pasos_ok=5`; motor `7ad76f36…` (= el temporal de T1); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `04b2876e…`; porcelain igual al del paso 1; `motor_repo` = `7ad76f36…`; `warnings_en_log 0`.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `7ad76f36e42d66c4da2d71aa28a558eb` (= T1); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain ` M 40_salidas/motor_idps.html` y `?? …_s33i_log.md` (= paso 1); `motor_repo 7ad76f36e42d66c4da2d71aa28a558eb`; `warnings_en_log 0`.
- **Paso 3 — PRUEBAS b y d, 🔒6, 🔒7 y testigo** (motor commiteable `/tmp/s33i_motor_t2.html`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33i_motor_t2.html; bash /tmp/s33i_pruebas_b.sh $M; node /tmp/s33i_csv.js $M t2 cmp5,ficha,pan,hist_foco > /tmp/s33i_t2_csv.json; for k in cmp5 ficha pan hist_foco; do cmp -s /tmp/s33i_csv_f0_$k.csv /tmp/s33i_csv_t2_$k.csv && echo "$k identico a FASE 0 $(md5 -q /tmp/s33i_csv_t2_$k.csv)" || echo "$k DISTINTO"; done; node /tmp/s33i_filas.js $M 1280 headless /tmp/s33i_t2_1280_headless.json; python3 /tmp/s33i_filas_resumen.py textos /tmp/s33i_m4_1280.json /tmp/s33i_t2_1280_headless.json; for m in ventana headless; do node /tmp/s33i_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33i_t2_l6_$m.json; done; for m in ventana headless; do node /tmp/s33i_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33i_t2_foco.jsonl; diff <(python3 /tmp/s33i_foco_resumen.py /tmp/s33i_m4_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33i_motor_[a-z0-9]+\.html/MOTOR/") <(python3 /tmp/s33i_foco_resumen.py /tmp/s33i_t2_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33i_motor_[a-z0-9]+\.html/MOTOR/") && echo "foco = M4"; for m in ventana headless; do diff <(python3 /tmp/s33i_l6_resumen.py /tmp/s33i_m4_l6_$m.json) <(python3 /tmp/s33i_l6_resumen.py /tmp/s33i_t2_l6_$m.json) && echo "l6 $m = M4"; done; R=/Users/tomgc/Projects/slep_idps; C="s33i: el sub cede ancho"; echo "testigo motor $(grep -c -F "$C" $R/40_salidas/motor_idps.html) docs $(grep -c -F "$C" $R/docs/index.html)"'
```
esperado: PRUEBAS b sin errores de consola ni `pageerror`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d: los cuatro `identico a FASE 0` con `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…`; 🔒6 `estados distintos 0`, md5 total `6e94a643…`; 🔒7 `foco = M4`, `l6 ventana = M4`, `l6 headless = M4`; testigo `motor 1 docs 0`.
obtenido: PRUEBAS b `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d `cmp5 … ee741cb7…`, `ficha … 3b092123…`, `pan … cd5ebb55…`, `hist_foco … 856071a8…`, los cuatro `identico a FASE 0`; 🔒6 `estados 18 | filas 808 | md5 total … 6e94a643f467da7c8dd9e01465379b15 … | estados distintos 0`; 🔒7 `foco = M4`, `l6 ventana = M4`, `l6 headless = M4`; **testigo `motor 1 docs 0`**.
- **Paso 4 — md5 y commit:** motor `7ad76f36e42d66c4da2d71aa28a558eb`; testigo para el despliegue: `s33i: el sub cede ancho` (1 en el motor, 0 en `docs/index.html`).
- **Commit:** `8f7f29d` build(motor): s33i filas del modal (`1 file changed, 3 insertions(+), 2 deletions(-)`); porcelain después: `?? …_s33i_log.md` (solo el LOG).
- **Estado de T2:** completada.

### FASE R: auditoría propia y reparación

**Paso 1 — inventario** (derivado del log, antes de auditar):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno: `<inicio>` = `11da123`, hijo de `52a757f` = `origin/main`; stash vacío; primer commit con el encargo y el registro (M1, M2) |
| R-02 | 🔒1: §8.2 `eb4e00b3…4dc4` en FASE 0, T1 y T2; la fecha alterada no lo mueve y la cifra plantada sí (M3) |
| R-03 | 🔒2: `:root` `04b2876e…` (65 líneas); hex agregadas 0 |
| R-04 | 🔒3: `sigdifgru` en líneas cambiadas 0/0; `const sg` 1 |
| R-05 | 🔒4: pipeline de datos intacto |
| R-06 | 🔒5: `docs/` intacto |
| R-07 | 🔒6: textos de 808 filas en 18 estados, md5 `6e94a643…`, iguales en M4 (1280 y 390), T1 (headless 1280, ventana 390) y T2 |
| R-08 | 🔒7: foco y teclado = M4 = s33f M8 en los dos modos (T1 y T2) |
| R-09 | 🔒8 / PRUEBAS d: `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…` en M4 y T2 |
| R-10 | M5 (caso malo): SLEP del comparador desborda (549 px de contenido en listas de 494/464/304/259), 36 nombres partidos, `sub` sin encoger; Nacional desborda en los dos modales y todos los anchos; Establecimiento "viña" del comparador a 390 |
| R-11 | Diseño: V0 (punto de partida) cumple (i) y (iii) y no (ii); V1 cumple los tres en 1280 y 390 (con la tolerancia de (ii) corregida) |
| R-12 | T1.3: 0 fallas en 76 estados (19 × 2 anchos × 2 modos); SLEP del comparador a 1280 con nombres en 1 línea y `sub` entero en 2 líneas a la derecha; marcadas cubiertas |
| R-13 | T1.3: fila Chile con 1 fila, `.is-nac`, borde punteado, fondo, dentro de la lista |
| R-14 | T1: la edición es solo CSS de la fila (comentario + 2 reglas); sin `overflow-x:hidden` |
| R-15 | T2: PRUEBAS a (`rc=0 warn=0 pasos_ok=5`); motor `7ad76f36…`; porcelain solo motor y LOG; PRUEBAS b sin errores |
| R-16 | Testigo `s33i: el sub cede ancho`: 1 en el motor, 0 en `docs/` (M7: 0/0/0) |
| R-17 | Reglas canónicas: sin comentario CSS con `*/` interno, sin hex, textos de las filas sin cambio |
| R-18 | Alcance global: commits ⊆ {plantilla, motor} + encargo y registro (`<inicio>`) + LOG; porcelain solo el LOG |

**Paso 2 — re-derivación independiente.**

R-10 y R-12 (desborde): instrumento nuevo `/tmp/s33i_r_borde.js`, distinto de `filas.js`: para cada fila, el borde derecho (`getBoundingClientRect().right`) de su `.check-region` y de su `.check-name` frente al borde derecho **interior** de la lista, y, en las marcadas, si el rectángulo pintado de la fila llega al borde derecho del `sub`. Anchos 1280, **540** (intermedio nuevo) y 390, en headless; 540 también con ventana; los dos modales; motor de `HEAD` (`/tmp/s33i_motor_t2.html`) y, de contraste, el de FASE 0:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in t2 fase0; do for w in 1280 540 390; do node /tmp/s33i_r_borde.js /tmp/s33i_motor_$M.html $w headless; done; node /tmp/s33i_r_borde.js /tmp/s33i_motor_$M.html 540 ventana; done'
```
esperado: **`HEAD`**: en los cuatro casos `estados 19`, `estados_con_filas_fuera 0`, `filas_fuera 0`, `max_exceso` ≤ 0, `malos []`, 0 errores. **FASE 0**: filas fuera en `cmp|SLEP|-` (36/36), `cmp|SLEP|2marcados` (36/36 y `marc2`), `terr|Nacional|-` y `cmp|Nacional|-` (1/1), y en `cmp|Establecimiento|viña` a 390 (y quizá a 540).
obtenido: ocho líneas `{"motor":…,"vista":"headless",…,"medidas":[{"ancho":…,"visible_mas_derecho":"header.app",…,"tab_der_max":…,"barra_der":…}]}`: **corrió otro instrumento**. El archivo `/tmp/s33i_r_borde.js` ya existía (la copia del re-derivador de página de s33f/s33g) y mi escritura del nuevo fue rechazada por la herramienta ("File has not been read yet"); el comando ejecutó el viejo, que mide la página y no las filas del modal. Estas salidas no sirven para R-10/R-12.
- **Corrección (error de instrumento):** el re-derivador de filas se escribe con otro nombre, `/tmp/s33i_r_filas_borde.js` (contenido descrito arriba), y se repite el mismo recorrido:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in t2 fase0; do for w in 1280 540 390; do node /tmp/s33i_r_filas_borde.js /tmp/s33i_motor_$M.html $w headless; done; node /tmp/s33i_r_filas_borde.js /tmp/s33i_motor_$M.html 540 ventana; done'
```
esperado: lo mismo que arriba: `HEAD` con `estados 19`, `estados_con_filas_fuera 0`, `filas_fuera 0`, `max_exceso` ≤ 0 y `malos []` en los cuatro casos; FASE 0 con filas fuera en SLEP y Nacional del comparador, Nacional del territorio y Establecimiento "viña" del comparador a 390.
obtenido: **`HEAD`**: 1280, 540 y 390 headless y 540 con ventana: `estados 19`, **`estados_con_filas_fuera 0`, `filas_fuera 0`, `max_exceso -11`** (el borde de lo escrito queda 11 px antes del borde interior de la lista: el `padding` derecho de la fila), `malos []`, 0 errores. **FASE 0**: a 1280 `estados_con_filas_fuera 4`, `filas_fuera 74`, `max_exceso 54.8`, `malos ["terr|Nacional|-:1/1","cmp|SLEP|-:36/36","cmp|Nacional|-:1/1","cmp|SLEP|2marcados:36/36 marc2"]`; a 540 lo mismo con `max_exceso 94.8` (headless) y `139.8` (ventana); a 390 `5` estados y `78` filas (más `cmp|Establecimiento|viña:4/5`), `max_exceso 244.8`. **R-10 y R-12 re-derivados**, también a 540 px y en el modal de territorio: tras T1 ninguna fila escribe fuera de la lista y las marcadas cubren su `sub`; antes, sí (control del paso 6 incluido: el mismo instrumento da desborde con el motor anterior).

R-07 (🔒6) por otra vía: el censo de cifras de s33c/s33d (`/tmp/s33i_censo.js`, copia sin cambios de `/tmp/s33d_censo.js`: `innerText` y `textContent` de cada fila de los dos modales con búsqueda vacía y "viña", más el multiconjunto de números y de cifras de cada una) sobre FASE 0 y `HEAD`, comparado solo en las filas de los modales (script de comparación en línea):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in fase0 t2; do node /tmp/s33i_censo.js /tmp/s33i_motor_$M.html /tmp/s33i_censo_$M.json | cut -c1-160; done; python3 -c "
import json
a=json.load(open(\"/tmp/s33i_censo_fase0.json\"))[\"elementos\"]; b=json.load(open(\"/tmp/s33i_censo_t2.json\"))[\"elementos\"]
ka=sorted(k for k in a if k.startswith((\"terr|\",\"cmp|\"))); kb=sorted(k for k in b if k.startswith((\"terr|\",\"cmp|\")))
print(\"filas fase0\", len(ka), \"HEAD\", len(kb), \"mismas claves\", ka==kb)
for campo in (\"inner\",\"text\",\"nums\",\"cifras\"): print(campo, \"distintas\", sum(1 for k in ka if a[k][campo]!=b.get(k,{}).get(campo)))"'
```
esperado: las dos corridas sin errores y con las mismas filas por pestaña; `mismas claves True`; `inner`, `text`, `nums` y `cifras` con **0 distintas** (el `innerText` normalizado a un espacio no depende de dónde parte la línea).
obtenido: `{"motor":"s33i_motor_fase0.html","errores":[],"elementos":816,"numeros":216,"cifras":133,"n_chips":5,"conteo_modal":"5 de 10",…}` y `{"motor":"s33i_motor_t2.html","errores":[],"elementos":816,"numeros":216,"cifras":133,…}`; `filas fase0 810 HEAD 810 mismas claves True`; `inner distintas 0`, `text distintas 0`, `nums distintas 0`, `cifras distintas 0` (810 = las 808 de `filas.js` más la fila Chile registrada otra vez en la pasada "viña" de cada modal, donde el censo no teclea porque no hay buscador). **R-07 re-derivado por otra vía.**

**Paso 3 — invariantes** (sobre `HEAD` y el motor versionado; 🔒1 y 🔒2 con los re-derivadores en Python; 🔒6 ya re-derivado arriba; 🔒7 con dos acciones de teclado distintas de las de M4 —`lista_cmp` y `ciclo_terr_region`— sobre FASE 0 y `HEAD`, dos modos; 🔒8 con `cmp` y filas en R):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=11da123; M=$R/40_salidas/motor_idps.html; T=$R/30_procesamiento/35_motor_template.html; echo "1 $(python3 /tmp/s33i_r_payload.py $M | cut -c1-200)"; echo "2 root $(python3 /tmp/s33i_r_root.py $T) ; $(bash /tmp/s33i_hex.sh | head -1)"; echo "3 $(bash /tmp/s33i_sig.sh | head -1)"; echo "4 $(git -C $R diff $I..HEAD -- 10_utils 20_insumos 30_procesamiento/31* 30_procesamiento/32* 30_procesamiento/33* 30_procesamiento/34* 30_procesamiento/35_generar_motor_html.R | wc -l | tr -d " ")"; echo "5 $(git -C $R diff --name-only $I..HEAD -- docs | wc -l | tr -d " ")"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do for X in fase0 t2; do node /tmp/s33i_l6.js /tmp/s33i_motor_$X.html $m lista_cmp,ciclo_terr_region > /tmp/s33i_r7_${X}_$m.json; done; diff <(python3 -c "import json; d=json.load(open(\"/tmp/s33i_r7_fase0_$m.json\")); d.pop(\"motor\"); print(json.dumps(d, sort_keys=True, indent=0))") <(python3 -c "import json; d=json.load(open(\"/tmp/s33i_r7_t2_$m.json\")); d.pop(\"motor\"); print(json.dumps(d, sort_keys=True, indent=0))") > /dev/null && echo "7 $m lista_cmp+ciclo_terr_region HEAD = FASE 0 (errores $(python3 -c "import json; print(len(json.load(open(\"/tmp/s33i_r7_t2_$m.json\"))[\"errores\"]))"))" || echo "7 $m DISTINTO"; done; for k in cmp5 ficha pan hist_foco; do cmp -s /tmp/s33i_csv_f0_$k.csv /tmp/s33i_csv_t2_$k.csv && echo "8 $k identico (cmp) $(md5 -q /tmp/s33i_csv_t2_$k.csv)" || echo "8 $k DISTINTO"; done; cd $R && Rscript /tmp/s33i_csv_contar.R /tmp/s33i_csv_t2_cmp5.csv /tmp/s33i_csv_t2_ficha.csv /tmp/s33i_csv_t2_pan.csv /tmp/s33i_csv_t2_hist_foco.csv 2>&1 | grep -v renv | cut -c1-50'
```
esperado: 1 `motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1`; 2 `lineas=65 md5=04b2876e…`, `hex agregadas=0 borradas=0`; 3 `sigdifgru borradas=0 agregadas=0 const_sg=1`; 4 `0`; 5 `0`; 7 `HEAD = FASE 0` en los dos modos con 0 errores; 8 los cuatro CSV idénticos, 84, 91, 240 y 2.196 filas en R.
obtenido: `1 motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1 bytes=59467463`; `2 root 35_motor_template.html lineas=65 md5=04b2876e2bcece41f09398f28f6fc41d ; hex agregadas=0 borradas=0`; `3 sigdifgru borradas=0 agregadas=0 const_sg=1`; `4 0`; `5 0`; `7 ventana lista_cmp+ciclo_terr_region HEAD = FASE 0 (errores 0)` y `7 headless …` igual; `8 cmp5 identico (cmp) ee741cb7…`, `8 ficha … 3b092123…`, `8 pan … cd5ebb55…`, `8 hist_foco … 856071a8…`; en R `84 | 23`, `91 | 10`, `240 | 13`, `2196 | 15`. **🔒1 a 🔒8 PASAN** sobre el estado final.

**Paso 4 — alcance global y reglas canónicas** (R-14, R-17, R-18):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=11da123; T=$R/30_procesamiento/35_motor_template.html; git -C $R diff --name-only $I..HEAD; git -C $R status --porcelain; D=$(git -C $R diff -U0 $I..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^[+-][^+-]"); echo "cambiadas $(printf "%s\n" "$D" | wc -l | tr -d " ") agregadas $(printf "%s\n" "$D" | grep -c "^+") borradas $(printf "%s\n" "$D" | grep -c "^-")"; A=$(printf "%s\n" "$D" | grep "^+"); echo "css_cierre_interno $(printf "%s\n" "$A" | grep -F "/*" | grep -c -E "\*/.+\*/")"; echo "fuera_de_css_de_fila $(printf "%s\n" "$A" | grep -v -E "^\+  (/\* s33i: el sub cede ancho|\.check-name\{|\.check-region\{)" | wc -l | tr -d " ")"; echo "overflow_x_hidden $(printf "%s\n" "$A" | grep -c "overflow-x")"; echo "jsx_tocado $(git -C $R diff -U0 $I..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^[+-][^+-]" | grep -c -E "item\.sub|item\.nom|className=")"'
```
esperado: `git diff --name-only 11da123..HEAD` = `30_procesamiento/35_motor_template.html` y `40_salidas/motor_idps.html` (⊆ ALCANCE; el encargo y el registro son `<inicio>`; el LOG va en FASE L); porcelain = solo el LOG; `cambiadas 5 agregadas 3 borradas 2`; `css_cierre_interno 0`; `fuera_de_css_de_fila 0`; `overflow_x_hidden 0`; `jsx_tocado 0` (textos y marcado de las filas intactos).
obtenido: `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html` (⊆ ALCANCE); porcelain `?? 50_documentacion/andamios/logs/20260924_filas_modal_s33i_log.md` (solo el LOG); `cambiadas 5 agregadas 3 borradas 2`; `css_cierre_interno 0`; `fuera_de_css_de_fila 0`; `overflow_x_hidden 0`; `jsx_tocado 0`. **R-14, R-17 y R-18 conformes.**

**Paso 5 — regresión completa sobre el estado final** (PRUEBAS a con `run_all()` entero; c; b; d):
```
bash -c 'bash /tmp/s33i_build.sh r completo; git -C /Users/tomgc/Projects/slep_idps status --porcelain; bash /tmp/s33i_pruebas_b.sh /tmp/s33i_motor_r.html; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33i_csv.js /tmp/s33i_motor_r.html r cmp5,ficha,pan,hist_foco | python3 -c "import json,sys; d=json.load(sys.stdin); [print(k, d[k].get(\"archivo\"), d[k].get(\"md5\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"cmp5\",\"ficha\",\"pan\",\"hist_foco\")]"'
```
esperado: PRUEBAS a `rc=0 warn=0 pasos_ok=5`, motor `7ad76f36…` (= `HEAD`), porcelain solo el LOG; PRUEBAS c §8.2 `eb4e00b3…`; `:root` `04b2876e…`; PRUEBAS b sin errores; PRUEBAS d `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…` con sus nombres; 0 errores.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `7ad76f36e42d66c4da2d71aa28a558eb` (= `HEAD`); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain `?? …_s33i_log.md` (solo el LOG); PRUEBAS b `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…` con sus nombres; 0 errores. **PRUEBAS a, b, c y d conformes sobre el estado final.**

**Paso 6 — control positivo.** (a) El que pide el encargo ya corrió en el paso 2: el mismo re-derivador sobre el motor anterior (M3, FASE 0) da 74–78 filas fuera de la lista. (b) Además, un caso plantado fuera del árbol (`/tmp/s33i_control.sh`): copia del motor de `HEAD` con las dos reglas de la fila devueltas a las de FASE 0 (el comentario se queda), re-derivada a 1280:
```
bash /tmp/s33i_control.sh
```
esperado: `estados_con_filas_fuera 4`, `filas_fuera 74`, `malos` con `cmp|SLEP|-:36/36`, `cmp|SLEP|2marcados:36/36 marc2` y las dos Nacional (como FASE 0 a 1280): el instrumento dispara.
obtenido: `plantado: reglas de FASE 0 sobre el motor de HEAD`; `{… "estados":19,"estados_con_filas_fuera":4,"filas_fuera":74,"max_exceso":54.8,"malos":["terr|Nacional|-:1/1","cmp|SLEP|-:36/36","cmp|Nacional|-:1/1","cmp|SLEP|2marcados:36/36 marc2"],"errores":0}` (**detectado**, idéntico a FASE 0 a 1280).

**Pasos 7 y 10 — tabla y veredicto:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno `11da123` | `git diff --name-only 11da123..HEAD` (paso 4) | 2 rutas del ALCANCE | 2 rutas del ALCANCE | — | ninguna | — | — |
| R-02 | 🔒1 §8.2 | `r_payload.py` (Python) sobre `HEAD` | `eb4e00b3…` | `eb4e00b3…` | PASA | ninguna | — | build `r` = `eb4e00b3…` |
| R-03 | 🔒2 paletas y hex | `r_root.py`; `hex.sh` sobre `11da123..HEAD` | `04b2876e…`; 0 | `04b2876e…`; `0/0` | PASA | ninguna | — | — |
| R-04 | 🔒3 `sigdifgru` | `sig.sh` | 0/0, `const_sg=1` | 0/0, 1 | PASA | ninguna | — | — |
| R-05 | 🔒4 pipeline | `git diff … \| wc -l` | 0 | 0 | PASA | ninguna | — | — |
| R-06 | 🔒5 `docs/` | `git diff --name-only … -- docs` | 0 | 0 | PASA | ninguna | — | — |
| R-07 | 🔒6 textos de filas | censo de cifras de s33c/s33d (`innerText`, `textContent`, números y cifras), FASE 0 ↔ `HEAD` | 0 distintas | 0/0/0/0 en 810 filas | PASA | ninguna | — | — |
| R-08 | 🔒7 foco y teclado | `l6.js` con `lista_cmp` y `ciclo_terr_region` (otras acciones), dos modos | iguales | iguales, 0 errores | PASA | ninguna | — | — |
| R-09 | 🔒8 / PRUEBAS d | `cmp` + filas en R | idénticos; 84/91/240/2.196 | idénticos; 84/91/240/2.196 | PASA | ninguna | — | build `r` |
| R-10 | M5 caso malo | `r_filas_borde.js` sobre FASE 0 (1280, 540, 390; ventana 540) | filas fuera en SLEP y Nacional | 74–78 filas fuera | PASA | ninguna | — | control (b) |
| R-11 | diseño V1 frente a V0 | (medición única sobre copias; tolerancia de mi resumen corregida y declarada) | V1 sin fallas | V1 sin fallas; V0 falla (ii) | PASA | ninguna | — | T1.3 |
| R-12 | T1.3 sin desborde, (ii), (iii) | `r_filas_borde.js` sobre `HEAD`, **540** px además de 1280 y 390, dos modales | 0 filas fuera; marcadas cubiertas | 0; `max_exceso -11`; 0 | PASA | ninguna | — | control (a) y (b) |
| R-13 | fila Chile | consulta de clase, borde y fondo (T1) | `.is-nac`, dashed, fondo | así; alto 40 → 58 a 1280 (su `sub` pasa a 2 líneas) | PASA; ADVIERTE (cambio visible en una pestaña que el titular no reportó, exigido por el criterio i) | registro | — | captura `cmp_Nacional` |
| R-14 | edición solo CSS de la fila | `grep` sobre el diff | 3 + 2 líneas; 0 fuera | así | PASA | ninguna | — | — |
| R-15 | T2 build y PRUEBAS b | build `r` completo | `7ad76f36…`; solo LOG | así | PASA | ninguna | — | — |
| R-16 | testigo | `grep -c -F` (T2) | motor ≥ 1, docs 0 | 1, 0 | PASA | ninguna | — | M7 |
| R-17 | reglas canónicas | `grep` sobre las líneas agregadas | 0; textos intactos | 0; `jsx_tocado 0` | PASA | ninguna | — | R-07 |
| R-18 | alcance global | `git diff --name-only`; porcelain | ⊆ ALCANCE; solo LOG | ⊆; solo LOG | PASA | ninguna | — | — |

- **Control positivo:** (a) el motor anterior da 74–78 filas fuera con el mismo re-derivador; (b) el motor de `HEAD` con las reglas viejas plantadas da 74: detectados. Más la calibración de M3 (cifra plantada).
- Ningún hallazgo BLOQUEA; ninguno pide REPARA; 0 ciclos de reparación, 0 commits `fix(auditoria)`. ADVIERTE: R-13.
- **Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (B/R/A = 0/0/1).

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R status -sb | head -1; git -C $R log --oneline 52a757f..HEAD; ps -ax -o command | grep -E "^node /tmp/s33i|^Rscript -e setwd" | wc -l | tr -d " "'
```
esperado: solo este LOG; `main` adelantada 3 respecto de `origin/main`; commits `11da123`, `378f02e`, `8f7f29d`; `0` procesos `node /tmp/s33i*` o `Rscript` de esta sesión (el patrón exige el inicio de la línea, para no contarse a sí mismo).
obtenido: `?? 50_documentacion/andamios/logs/20260924_filas_modal_s33i_log.md` (única); `## main...origin/main [ahead 3]`; `8f7f29d`, `378f02e`, `11da123`; `0` procesos de esta sesión. Ningún shell en segundo plano (ninguno se lanzó en esta sesión).
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33i (las filas del modal caben en la lista; el `sub` cede ancho; build). Fases: FASE 0, T1, T2, R y L. Estado del grafo: T1 completada (`378f02e`) · T2 completada (`8f7f29d`). FASE R: **APROBADO CON ADVERTENCIAS**. Sin gates con el titular.
2. **Commits** (`git log 52a757f..HEAD --oneline`, antes del commit de este log):
   - `11da123` chore(encargo): s33i y registro del asistente s33 (= `<inicio>`)
   - `378f02e` fix(motor): las filas del modal caben en la lista; el sub cede ancho (s33i T1)
   - `8f7f29d` build(motor): s33i filas del modal (motor `7ad76f36e42d66c4da2d71aa28a558eb`)
   - (este log: `docs(log): s33i filas del modal`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/1 (R-13, la fila Chile cambia de alto); reparados 0; control positivo: 2 de 2 detectados.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, T1, T2 y la regresión; re-derivado en Python) · 🔒2 PASA (`:root` 65 / `04b2876e…`; hex +0/−0) · 🔒3 PASA (0/0; `const_sg` 1) · 🔒4 PASA (0) · 🔒5 PASA (0) · 🔒6 PASA (808 filas, md5 `6e94a643…`, iguales en M4, T1 y T2 en los dos modos y anchos; re-derivado con el censo de cifras: 0 diferencias en `innerText`, `textContent`, números y cifras) · 🔒7 PASA (= M4 = s33f M8 en los dos modos; en R, con otras dos acciones) · 🔒8 PASA (cuatro CSV byte a byte en M4, T2 y la regresión).
5. **Decisiones del titular registradas:** gate visual de s33 a s33g: **aprobado salvo las filas del modal** (este encargo); **N-1 de s33g: no se toca** (los 2 px de `.ficha-tools` con ventana a 320). Ninguna decisión nueva en esta sesión.
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0 (motor `2a436756…`), en T1 (`7ad76f36…`, temporal), T2 y la regresión (`7ad76f36…`). Motor `2a436756f8a4dff35b203b246eb022eb` → `7ad76f36e42d66c4da2d71aa28a558eb`.

   Lista (`scrollWidth`/`clientWidth`, px) y nombres partidos, antes → después:

   | estado | 1280 headless | 1280 ventana | 390 headless | 390 ventana |
   |---|---|---|---|---|
   | comparador, SLEP (y con 2 marcados) | 549/494 → 494/494; nombres partidos 36 → 0 | 549/464 → 464/464; 36 → 0 | 549/304 → 304/304; 36 → 12 | 549/259 → 259/259; 36 → 33 |
   | comparador, Nacional | 524/494 → 494/494 | 524/494 → 494/494 | 524/304 → 304/304 | 524/289 → 289/289 |
   | territorio, Nacional | 496/494 → 494/494 | 496/494 → 494/494 | 496/304 → 304/304 | 496/289 → 289/289 |
   | comparador, Establecimiento "viña" | 494/494; nombres partidos 4 → 0 | 4 → 0 | 389/304 → 304/304; 5 → 4 | 389/274 → 274/274; 5 → 4 |
   | territorio, SLEP | sin cambio (494/494) | sin cambio | sin cambio | nombres partidos 14 → 0 |
   | comparador, Comuna | sin cambio | sin cambio | 1 → 1 | nombres partidos 9 → 5 |

   Los nombres que siguen partidos a 390 no caben en una línea ni con el `sub` en su mínimo (`ii_viol 0`). Resto de pestañas: sin desborde antes ni después; a 1280, las capturas de Comuna y Región del comparador y de Comuna y SLEP del territorio son idénticas (AE 0).
7. **Dudas y pendientes consolidados:**
   - **A-1 (R-13).** La fila Chile de la pestaña Nacional, que antes se salía de la lista, ahora parte su `sub` en dos líneas (a 1280: alto 40 → 58 px) y conserva su borde punteado. Lo exige el criterio (i) ("ninguna pestaña"); lo registro porque cambia una pestaña que el titular no reportó. Pregunta: ¿se acepta así? (sí/no). Bloquea: nada.
   - **Testigo del próximo despliegue:** `grep -c -F 's33i: el sub cede ancho'` → `1` en el motor, `0` en `docs/index.html`. md5 del motor a desplegar: `7ad76f36e42d66c4da2d71aa28a558eb` (lleva s33 a s33i).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados** (ninguno con efecto en el código, las cifras del motor o la conclusión):
   - T1 (diseño): mi resumen del criterio (ii) contaba "cabe" con una holgura de +0,5 px a favor y marcó como violación una fila a la que le faltaban 0,5 px; corregido (holgura en contra y conteo aparte de los casos límite), aplicado a todos los motores y declarado. Costo: un re-resumen, sin nuevas corridas.
   - FASE R: el re-derivador nuevo iba a `/tmp/s33i_r_borde.js`, que ya existía (copia de s33g); la herramienta rechazó la escritura y corrió el viejo, que mide la página. Salidas descartadas y registradas; se repitió con `/tmp/s33i_r_filas_borde.js`. Costo: una corrida.
9. **Notas para el revisor:**
   - (a) Gate visual, el caso de las capturas del titular: Comparación entre territorios → Agregar → pestaña **SLEP**, marcar dos. Cada "SLEP …" en una línea; el texto gris ("Traspaso 2026 · 6 comunas · 63 establecimientos en el directorio") entero, en dos líneas alineadas a la derecha; sin barra de desplazamiento horizontal; el fondo de las marcadas cubre la fila.
   - (b) Pestaña **Nacional** (los dos modales): la fila Chile ahora ocupa dos líneas y no se sale (A-1).
   - (c) A 390 px (celular), en SLEP del comparador, algunos nombres largos todavía se parten: no caben ni con el texto gris en su mínimo.
   - (d) Nada se desplegó.
10. **Estado de cierre:** commiteados `11da123`, `378f02e`, `8f7f29d` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33i_priv.sh`, copia del de s33g con la ruta de este log; los patrones viven solo en el script):
```
bash /tmp/s33i_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `nombre plantado: 1`; `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0 (bruto, con los identificadores de acción: 0)`; `nombre plantado: 1`; `estación por nombre: 0`. **Privacidad: PASA.** La estación figura como "estación del titular"; solo aparecen nombres de SLEP, comuna y región.

Paso 5 (verificación del archivo, después de rellenar el J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_filas_modal_s33i_log.md; ls -l $L | awk "{print \$5}"; wc -l < $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(awk "/^## J/,/^## Registro/" $L | grep -c "^- ")"; bash /tmp/s33i_priv.sh | head -1'
```
esperado: `FASE=5` (FASE 0, T1, T2, R, L); `esperado` = `obtenido` + 1 al medir (este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `65801` bytes y `354` líneas al medir; `FASE=5 esperado=26 obtenido=25 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **26 = 26** (un `esperado:` por comando, sin anexos de formato).
