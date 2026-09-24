# Log de sesión: exportación CSV de la vista histórica del panorama (s33e)

- **Meta:** que la pestaña de pantalla enfocada con Tab se desplace hasta verse entera (T1, A-2 de s33d); exportar a CSV la vista histórica del panorama, con una fila por establecimiento, año e indicador y los mismos arreglos que dibuja la pantalla (T2, pendiente 4 de v31); enmendar §3.10 de la decisión de vista histórica (T3); regenerar el motor (T4). Las tres exportaciones existentes no cambian. Sin despliegue.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `82bcae0` (= `origin/main`, `docs(log)` de s33d). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_csv_historico_s33e.md` (única); `git stash list` vacío; `HEAD=82bcae0 origin/main=82bcae0`; `HEAD..origin/main=0`, `origin/main..HEAD=0`. Primer acto (autorizado): commit `9e7b993` chore(encargo): s33e, hijo de `82bcae0`. **PUNTO DE RETORNO `<inicio>` = `9e7b993`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv` (`arrow`, `jsonlite`; toda cifra sobre datos se cuenta en R); `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script en `/tmp/s33e_*`); `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`), con el Blob interceptado (`URL.createObjectURL` + `HTMLAnchorElement.prototype.click`) y, con ventana, `waitForSelector` visible antes de actuar.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular mandan sobre el modo: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_csv_historico_s33e.md` (commit `9e7b993`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (la pestaña enfocada se ve entera)   ALCANCE: 30_procesamiento/35_motor_template.html
T2 (CSV de la vista histórica)          ALCANCE: ídem; en serie después de T1
T3 (enmienda §3.10 de la decisión)      ALCANCE: 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md; requiere T2
T4 (build)                              ALCANCE: 40_salidas/motor_idps.html; requiere T1 o T2
Orden: T1 → T2 → T3 → T4; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33e_*`; se copian de `/tmp/s33d_*` y `/tmp/s33c_*`. De s30 no queda nada en `/tmp`: el instrumento de Blob interceptado se reescribe desde el patrón del log s32f (4e). Convenciones: **un `esperado:` y un `obtenido:` por comando**; una corrección va como `- **Corrección:** …`; los patrones de privacidad viven solo en su script; **ningún RBD, nombre de establecimiento ni fila de CSV en el log** (solo conteos, md5 y nombres de columna).

## J. Juicio (lo rellena FASE L)

- Meta y resultado: la vista histórica del panorama exporta su propio CSV (15 columnas, una fila por establecimiento, año e indicador, con el GSE de ese año y el último), fiel a la pantalla y al parquet en cuatro casos (2.196 / 1.008 / 144 / 298.224 filas); las tres exportaciones existentes no cambian un byte; la enmienda §3.10 quedó escrita; la pestaña enfocada NO se ve entera a 320 px (T1 congelada).
- Estado por tarea: FASE 0 completada · T1 CONGELADA (regla 7, sin commit) · T2 completada (`b6b56c6`) · T3 completada (`f31a7e3`) · T4 completada (`0ed771d`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
- Commits: 5, rango `9e7b993`..`<docs(log)>` (`git log --oneline 82bcae0..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/4; reparados 0; abiertos 4: D-2 (lectura de 🔒7 ii contra el entero), A-2/D-3 (el nombre no marca "Sin clasificar" oculto), T1 congelada (D-1), A-1 (desborde de 423 px a 390, anterior); control positivo 2 de 2.
- Invariantes: 8/8 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒2 `:root` `04b2876e…` y hex +0/−0; 🔒3 0/0; 🔒4 0; 🔒5 0; 🔒6 tres CSV idénticos; 🔒7 filas y celdas, con la lectura D-2; 🔒8 = M8 en los dos modos); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, T1, T2, T4 y la regresión, re-derivado en Python; filas del CSV re-derivadas solo desde el parquet; todas las celdas de los cuatro CSV contra el parquet).
- Decisiones autónomas de mayor riesgo: (1) congelar T1 por la regla 7 sin abrir gate, tras haberlo anunciado en H-1; (2) sacar el sufijo de GSE a `sufijoGse`, que ahora usa también el CSV del panorama actual (mismos bytes y nombres, medido); (3) `gse_anio` vacío y sin etiqueta en los años sin fila del establecimiento, y "sin clasificar" solo cuando el roster trae el año sin GSE; (4) una regla CSS sin color para que la barra ocupe la última fila de `.vt-ctl`.
- Desviaciones respecto del encargo: T1 no se entrega (congelada); T2 suma, fuera de la lista literal de §6 T2.2, la regla CSS, la función `sufijoGse` y una línea en el comentario de la barra del panorama; 🔒7 ii se leyó contra `round(prom, 0)` (D-2); las muestras de T2 y FASE R salen de los cuatro indicadores (la de T4, del visible).
- Dudas abiertas: 3 + 1: D-1 ¿rótulo partible bajo 480 px para T1? (sí/no); D-2 ¿🔒7 ii contra `round(prom, 0)`? (sí/no); D-3 ¿marcar "Sin clasificar" oculto en el nombre? (sí/no); A-1 ¿encargo para el desborde de la vista histórica a 390 px?
- Errores propios: 0 con efecto en código, cifras o conclusión; 6 de instrumento o comando corregidos y repetidos (BOM, diff de s33c, `prom` crudo, `-U0 --stat`, comuna del re-derivador, gate anunciado) y 1 errata del log corregida antes de su `obtenido:`.
- Qué debe verificar el revisor por sí mismo: en la Vista histórica del SLEP foco, el botón al final del panel; el CSV abierto en Excel (columnas, tildes, dos GSE por fila); con un GSE, el sufijo `_gse_<código>`; en Chile, el aviso de 298.224 filas.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `CSV_HIST_COLS`: 2 en el motor, 0 en `docs/`; md5 `977575d193e8207acc7728c8cdcbc909`). Las respuestas a D-1, D-2 y D-3.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `9e7b993` (primer acto).

**Instrumentos copiados** de `/tmp/s33d_*` (siguen en `/tmp`): §8.2 (`/tmp/s33e_payload_sha.sh` → `…_payload_norm.js`, `…_fecha_alterada.js`, `…_plantar_payload.js`), `:root`, 🔒2(b)/🔒3 (`/tmp/s33e_hex.sh`, `/tmp/s33e_sig.sh`, `/tmp/s33e_arbol.sh`, con `I=9e7b993`), build, PRUEBAS b, 🔒8 (`/tmp/s33e_l6.js`, `/tmp/s33e_foco.js`, con la espera visible de s33d) y `/tmp/s33e_tabs.js` (pestañas a un ancho dado); solo cambian rutas internas, cabecera e `<inicio>`.

**M1 a M3** (el motor de FASE 0 se guarda en `/tmp/s33e_motor_fase0.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s33e_motor_fase0.html; echo "motor $(md5 -q $M) docs $(md5 -q $R/docs/index.html)"; bash /tmp/s33e_payload_sha.sh /tmp/s33e_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33e_fecha_alterada.js /tmp/s33e_motor_fase0.html /tmp/s33e_motor_fecha.html; bash /tmp/s33e_payload_sha.sh /tmp/s33e_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33e_plantar_payload.js /tmp/s33e_motor_fase0.html /tmp/s33e_motor_plantado.html; bash /tmp/s33e_payload_sha.sh /tmp/s33e_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s33e_root_md5.sh $R/30_procesamiento/35_motor_template.html'
```
esperado: M1 solo este LOG, `stash: []`; M2 `fetch rc=0`, `HEAD=9e7b993`, padre `82bcae0` = `origin/main`, `0`, `1`; M3 motor `08c22714…`, `docs` `4b28a03f…`, §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; `:root` `lineas: 65; md5 04b2876e…`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_csv_historico_s33e_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=9e7b993 padre=82bcae0 origin/main=82bcae0`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 `motor 08c22714954617d454618a1d647f1be4 docs 4b28a03fdaa00bd5dbb0a6fc501eab72`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada → igual, cifra plantada → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. Reglas 1 y 2 no disparan.

**Instrumentos nuevos de exportación:** `/tmp/s33e_csv.js` (reescrito desde el patrón de s32f, 4e: parchea `URL.createObjectURL` para guardar cada Blob y `HTMLAnchorElement.prototype.click` para leer el nombre sin navegar; acepta el `confirm` de `confirmarTamano` y lo registra; guarda cada CSV en `/tmp/s33e_csv_<etq>_<acción>.csv` y, en la vista histórica, vuelca en `/tmp/s33e_pant_<etq>_<acción>.json` los grupos, los años con dato y cada celda de la matriz —RBD, año, indicador, texto de la celda y `estadoVsGse` calculado en la página—; por consola imprime el nombre del archivo con el RBD enmascarado, md5, líneas y cabecera) y `/tmp/s33e_csv_contar.R` (filas y columnas en R con `read.csv2`, BOM, `;` y coma decimal).

**M4 — instrumento de Blob con control positivo** (CSV del panorama actual del SLEP foco, 4° básico 2025, el estado inicial del motor; filas contadas en R):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_fase0.html f0 pan; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s33e_csv_contar.R /tmp/s33e_csv_f0_pan.csv 2>&1 | grep -v renv'
```
esperado: `captura: true`, archivo `idps_panorama_slep_costa_central_4b_2025.csv`, con BOM y cabecera `rbd;establecimiento;comuna;dependencia;gse;gse_label;indicador;indicador_label;puntaje;estado_vs_gse;nivel;anio;preliminar`; el banner dice `60 establecimientos`; en R, **240 filas** (4 × 60) y 13 columnas; 0 errores.
obtenido: captura `ok`, `idps_panorama_slep_costa_central_4b_2025.csv`, banner `60 establecimientos en el nivel seleccionado · 4° básico · 5 de 5 GSE · 2025`, 241 líneas, cabecera de 13 columnas igual a `CSV_PAN_COLS`; en R `filas 240 | columnas 13`; 0 errores. **Pero `bom: false`:** falla del instrumento, no del motor: `TextDecoder('utf-8')` quita el BOM al decodificar (su `ignoreBOM` vale `false` por defecto), así que el archivo guardado no era byte a byte el que genera el motor. Corrección del instrumento: `new TextDecoder('utf-8', { ignoreBOM: true })`. Se repite M4:
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_fase0.html f0 pan; head -c 3 /tmp/s33e_csv_f0_pan.csv | xxd -p; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s33e_csv_contar.R /tmp/s33e_csv_f0_pan.csv 2>&1 | grep -v renv'
```
esperado: igual que arriba, con `bom: true` y los tres primeros bytes `efbbbf`; en R, 240 filas y 13 columnas.
obtenido: captura `ok`, mismo archivo, **`bom: true`**, primeros bytes `efbbbf`, md5 `cd5ebb55a2cb02efa5598dd5a6a4f465`, 241 líneas; en R **`filas 240 | columnas 13`** = 4 × 60. El instrumento captura la descarga completa y el conteo coincide: **M4 conforme** (la regla de congelar T2 no dispara).

**M5 — caso malo de T1** (`/tmp/s33e_tabs.js` de s33d, con el viewport abierto ya a 320 px —equivale al remount—, con ventana y headless: Tab desde la primera pestaña y, para cada pestaña enfocada, si su rectángulo cabe dentro del de `.screen-tabs`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33e_tabs.js /tmp/s33e_motor_fase0.html 320 $m | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[\"modo\"], [(t[\"texto\"][:22], t[\"visible_en_barra\"], t[\"activa_ok\"]) for t in d[\"teclado\"]], d[\"scroll_barra\"], d[\"pagina\"], len(d[\"errores\"]))"; done'
```
esperado: en los dos modos, "Panorama IDPS por establecimiento" con `visible_en_barra: False` (no cabe); "Comparación entre territorios" `True`; página sin desborde (`320/320`); 0 errores.
obtenido: con ventana y en headless, 0 errores: "Panorama IDPS por establecimiento" **`visible_en_barra: False`** (se activa con Enter: `True`); "Comparación entre territorios" `True`; `.screen-tabs` con `overflowX: auto`, `scrollWidth 335` frente a `clientWidth 296` (headless) y `281` (con ventana, que descuenta 15 px de la barra de desplazamiento vertical); página sin desborde (`320/320` en headless; `305/320` con ventana). **Caso malo confirmado** (regla 6 no dispara para T1).

**M6 — líneas base de PRUEBAS d** (`/tmp/s33e_csv.js`, acciones `cmp5` —comparador con cinco entidades, una por clase: el primer establecimiento del SLEP foco en 4b del año vigente por orden de RBD, su comuna, el SLEP foco, la región de esa comuna y Chile—, `ficha` —el primer establecimiento del roster de 4b del año vigente, en 4° básico— y `pan` otra vez, para ver que el md5 se repite; filas en R):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_fase0.html f0 cmp5,ficha,pan | python3 -c "import json,sys; d=json.load(sys.stdin); [print(k, {x: d[k].get(x) for x in (\"boton\",\"captura\",\"archivo\",\"md5\",\"lineas\",\"bom\",\"chips\",\"error\")}, len(d[k].get(\"errores\",[]))) for k in (\"cmp5\",\"ficha\",\"pan\")]"; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s33e_csv_contar.R /tmp/s33e_csv_f0_cmp5.csv /tmp/s33e_csv_f0_ficha.csv 2>&1 | grep -v renv | cut -c1-160'
```
esperado: tres capturas con BOM y tres md5 registrados; `pan` con el mismo md5 de M4 (`cd5ebb55…`); el comparador con 5 chips; el nombre de la ficha con el RBD enmascarado; 0 errores.
obtenido: 0 errores. **(i) comparador** `idps_comparador_4b_2025.csv`, 5 chips, BOM, md5 **`ee741cb7be811b029e888d6cbe85fde5`**, 85 líneas (R: 84 filas, 23 columnas); **(ii) panorama actual** `idps_panorama_slep_costa_central_4b_2025.csv`, md5 **`cd5ebb55a2cb02efa5598dd5a6a4f465`** (= M4: determinista), 241 líneas; **(iii) ficha** `idps_ficha_<rbd>_4b.csv`, BOM, md5 **`3b092123be1750d277b91f32ba0a071a`**, 92 líneas (R: 91 filas, 10 columnas). Líneas base de 🔒6 fijadas.

**M7 — caso malo de T2** (`/tmp/s33e_csv.js`, acción `hist_foco`: panorama del SLEP foco en 4° básico, Vista histórica; cuenta `.export-bar`, vuelca la pantalla e intenta exportar):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_fase0.html f0 hist_foco | python3 -c "import json,sys; d=json.load(sys.stdin)[\"hist_foco\"]; print({k: d.get(k) for k in (\"n_export_bar\",\"boton\",\"grupos\",\"con_dato\",\"indicador\",\"celdas\",\"errores\",\"error\")})"'
```
esperado: `n_export_bar: 0`; `boton: sin_boton`; se registran los grupos visibles, los años con dato y el número de celdas de la matriz; 0 errores.
obtenido: **`n_export_bar: 0`**, `boton: sin_boton`; grupos `Bajo` 10, `Medio bajo` 21, `Medio` 28, `Medio alto` 1 y `Sin clasificar` 1 (61 establecimientos; la cifra de cada `.gse-sec-sub` coincide con las filas de su tabla); años con dato `2014–2018` y `2022–2025` (9); indicador visible en la matriz: 1; **549 celdas** (= 61 × 9); 0 errores. **Caso malo confirmado** (regla 6 no dispara para T2). Con T2, el CSV de este caso deberá tener 61 × 9 × 4 = 2.196 filas.

**M8 — líneas base de 🔒8** (`/tmp/s33e_l6.js` y `/tmp/s33e_foco.js`, con la espera visible, en los dos modos; el `sed` final solo acorta la salida):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33e_motor_fase0.html; for m in ventana headless; do node /tmp/s33e_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33e_m8_l6_$m.json; python3 /tmp/s33e_l6_resumen.py /tmp/s33e_m8_l6_$m.json; done; for m in ventana headless; do node /tmp/s33e_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33e_m8_foco.jsonl; python3 /tmp/s33e_foco_resumen.py /tmp/s33e_m8_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/"'
```
esperado: las del log s33d: `terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` en los dos modos; respaldos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`; 0 errores.
obtenido: `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; respaldos en los dos modos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`; 0 errores. **= s33d.**

**M9 — calibración del testigo de T4** (la constante nueva, contada con `grep -c -F` en `docs/`, en el motor y en la plantilla):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; echo "CSV_HIST_COLS docs $(grep -c -F CSV_HIST_COLS $R/docs/index.html) motor $(grep -c -F CSV_HIST_COLS $R/40_salidas/motor_idps.html) plantilla $(grep -c -F CSV_HIST_COLS $R/30_procesamiento/35_motor_template.html)"'
```
esperado: `0`, `0` y `0`.
obtenido: `CSV_HIST_COLS docs 0 motor 0 plantilla 0`. **Testigo elegido: `CSV_HIST_COLS`.**

- **Estado de FASE 0:** completada. M1–M9 coinciden con su esperado (M4 tras corregir el BOM en el instrumento). Ninguna regla de detención dispara; ninguna tarea congelada; sin gates.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `9e7b993` (hijo de `82bcae0` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** 1 de instrumento (M4: el `TextDecoder` quitaba el BOM del CSV capturado); corregido antes de las líneas base de M6. Costo: una corrida.

### FASE T1: la pestaña enfocada se desplaza hasta verse entera (A-2 de s33d)

- **Paso 0:** M5 (a 320 px, "Panorama IDPS por establecimiento" enfocada con Tab no cabe en `.screen-tabs`, en los dos modos).
- **Implementación** (lo de §6 T1.2, nada más): en el botón `.screen-tab`, `onFocus={e=>e.currentTarget.scrollIntoView({block:"nearest",inline:"nearest"})}`. Sin cambios de CSS ni de rótulos.
- **Nota previa de geometría** (de M5 y del log s33d): a 320 px, "Panorama IDPS por establecimiento" mide 335 px de ancho y `.screen-tabs` tiene 296 px de ancho útil (281 con ventana). Si la pestaña es más ancha que la barra, ningún desplazamiento la deja entera; se mide y se registra.
- **Instrumento nuevo** `/tmp/s33e_t1.js`: (a) a 320 px, Tab desde la primera pestaña hasta cada una, con el rectángulo de la pestaña frente al de la barra, el `scrollLeft` de la barra, si queda entera (`dentro`) y si al menos su comienzo queda visible (`inicio_visible`); (b) a 1280 px, `scrollX`/`scrollY` de la página antes y después de recorrer las pestañas con Tab, con la página arriba y desplazada 800 px.
- **Verificación** (build temporal; con ventana y headless; dos comandos):
```
bash -c 'bash /tmp/s33e_arbol.sh t1; bash /tmp/s33e_build.sh t1; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33e_t1.js /tmp/s33e_motor_t1.html $m; done; node /tmp/s33e_t1.js /tmp/s33e_motor_fase0.html headless'
```
esperado: `stat sin commitear: 1 file changed, 1 insertion(+)`; hex y `sigdifgru` `0/0`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…`; `:root` `04b2876e…`. **T1 (M5 repetido), según el encargo:** a 320 px, tras el Tab, el rectángulo de "Panorama IDPS por establecimiento" queda **dentro** del de `.screen-tabs` (`dentro: true`); **a 1280 px**, `scrollX`/`scrollY` iguales antes y después (`igual: true`), con la página arriba y desplazada. Motor de FASE 0 como contraste. 0 errores.
obtenido: `stat sin commitear: 1 file changed, 1 insertion(+)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; motor temporal `178a218d09149fdc9eaccc655afb057e`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `04b2876e…`; 0 errores. **A 320 px, motor de T1** (con ventana y headless): "Panorama IDPS por establecimiento" `tab_izq 12 tab_der 347 tab_ancho 335`, barra `12–308` (296 px; con ventana `12–293`, 281 px), `scrollLeft 0`, **`dentro: false`**, `inicio_visible: true`; "Comparación entre territorios" `dentro: true`. **Motor de FASE 0:** exactamente lo mismo. **A 1280 px:** `antes [0,0] despues [0,0]` y `antes [0,800] despues [0,800]`, `igual: true` en los dos modos.
- **Hallazgo H-1 (T1 no puede cumplir su criterio tal como está redactada):** con las pestañas apiladas (una por línea desde s33d), la pestaña más ancha ya empieza en el borde izquierdo de la barra; lo que no se ve son sus últimos 39 px (54 con ventana), porque **es más ancha que la barra**. `scrollIntoView` no tiene hacia dónde desplazarla (`scrollLeft` sigue en 0) y el resultado es idéntico al de FASE 0. Que quepa entera exige cambiar el CSS o el rótulo, y §6 T1.2 dice "no se acortan rótulos ni se cambia el CSS". Se lleva al titular como gate antes de commitear T1; la edición queda sin commitear mientras tanto.
- **Medición para el gate (propia, sobre una copia):** el motor de T1 con `@media (max-width:480px){.screen-tab{white-space:normal;}}` inyectado al final del CSS (solo la copia `/tmp/s33e_motor_t1_wrap.html`): la pestaña a 320 px, y el alto de cada pestaña a 320, 390 y 480 px frente al motor de T1.
```
bash -c 'python3 -c "s=open(\"/tmp/s33e_motor_t1.html\",encoding=\"latin-1\").read(); i=s.index(\"</style>\"); open(\"/tmp/s33e_motor_t1_wrap.html\",\"w\",encoding=\"latin-1\").write(s[:i]+\"@media (max-width:480px){.screen-tab{white-space:normal;}}\"+s[i:])"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33e_t1.js /tmp/s33e_motor_t1_wrap.html headless | python3 -c "import json,sys; d=json.load(sys.stdin); print([(x[\"texto\"][:12], x[\"tab_ancho\"], x[\"barra_ancho\"], x[\"dentro\"]) for x in d[\"w320\"]])"; node /tmp/s33e_ancho.js /tmp/s33e_motor_t1_wrap.html 320,390,480 > /tmp/s33e_wrap.json; node /tmp/s33e_ancho.js /tmp/s33e_motor_t1.html 320,390,480 > /tmp/s33e_nowrap.json; python3 -c "
import json
for f in (\"/tmp/s33e_nowrap.json\",\"/tmp/s33e_wrap.json\"):
    d=json.load(open(f)); print(f.split(\"/\")[-1], [(m[\"ancho\"], m[\"exceso\"], m[\"tabs\"]) for m in d[\"medidas\"] if m[\"pantalla\"].startswith(\"Panorama t\")])"'
```
esperado: (propio) con el rótulo partible, a 320 px "Panorama IDPS por establecimiento" queda `dentro: true` (el rótulo en dos líneas); a 390 y 480 px las pestañas no cambian (caben en una línea); sin desborde de página en ningún caso.
obtenido: `[('Panorama IDP', 296, 296, True), ('Comparación ', 279, 296, True)]` (headless); `s33e_nowrap.json [(320, 0, ['196/208', '335/347', '279/291']), (390, 0, […idénticas]), (480, 0, […idénticas])]`; `s33e_wrap.json [(320, 0, ['196/208', '296/308', '279/291']), (390, 0, ['196/208', '335/347', '279/291']), (480, 0, […idénticas])]` (ancho/borde derecho de cada pestaña; exceso de página 0 en todos). Con el rótulo partible, a 320 px la pestaña ocupa exactamente la barra (296 de 296) y queda entera; a 390 y 480 px nada cambia. No medí la ventana ni el alto de la pestaña partida.
- **Decisión (regla de detención 7, residual):** el criterio de T1 ("dentro" a 320 px) no se alcanza con la edición que el encargo permite ("nada más cambia: no se acortan rótulos ni se cambia el CSS"), y el resultado no está enumerado en el encargo. **T1 queda CONGELADA**: la edición del `onFocus` se deshace con el editor (sin `checkout --`), no se commitea y la registro como **duda D-1** en el Cierre. Corrige lo que dije en H-1 ("se lleva al titular como gate"): el encargo ya dice qué hacer con un residual, así que no abro gate y sigo con T2. El motor temporal de T1 que quedó en `40_salidas/` lo reemplaza el build de T4.
- **Plantilla restaurada** (la diferencia de la plantilla con `HEAD`, contada):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; echo "plantilla $(git diff --stat -- 30_procesamiento/35_motor_template.html | tail -1)"; git status --porcelain'
```
esperado: `plantilla ` sin estadística (sin diferencia); porcelain con el motor temporal y este LOG.
obtenido: `plantilla ` (sin diferencia); porcelain ` M 40_salidas/motor_idps.html` y `?? …_s33e_log.md`.
- **Estado de T1:** CONGELADA (regla 7), sin commit. Duda D-1 en el Cierre.
- **Corrección (error de instrumento, 🔒3 de T1):** `/tmp/s33e_arbol.sh` (copiado de s33c) le pasaba a `sig.sh` el archivo `/tmp/s33c_arbol_$E.diff` en vez de `/tmp/s33e_arbol_$E.diff`: el `sigdifgru borradas=0 agregadas=0` de la verificación de T1 se midió sobre un diff viejo de s33c. Corrijo el script (`s33c_arbol` → `s33e_arbol`) y repito la medida sobre el diff real de T1:
```
bash -c 'sed -i "" "s#/tmp/s33c_arbol_#/tmp/s33e_arbol_#" /tmp/s33e_arbol.sh; grep -c "s33c_arbol" /tmp/s33e_arbol.sh; bash /tmp/s33e_sig.sh /tmp/s33e_arbol_t1.diff /tmp/s33e_motor_t1.html | head -1; bash /tmp/s33e_hex.sh /tmp/s33e_arbol_t1.diff | head -1'
```
esperado: `0` (ya no apunta a s33c); `sigdifgru borradas=0 agregadas=0` (la edición de T1 era una línea con `onFocus`); `hex agregadas=0 borradas=0`.
obtenido: `0`; `sigdifgru borradas=0 agregadas=0 const_sg=1`; `hex agregadas=0 borradas=0`. La conclusión de T1 sobre 🔒3 no cambia; cambia la evidencia.

### FASE T2: exportación CSV de la vista histórica (pendiente 4 de v31)

- **Paso 0:** releí M4 (instrumento de Blob con BOM, `cd5ebb55…`), M6 (líneas base `ee741cb7…`, `cd5ebb55…`, `3b092123…`) y M7 (SLEP foco, 4° básico, Vista histórica: `n_export_bar: 0`, 61 establecimientos, 9 años con dato, 2.196 filas esperadas). Leí completos `PanoramaHistorico`, `rosterHistorico`, `filasPanoramaCSV`, `descargarPanoramaCSV` y `estadoVsGse`, y el armado del roster en `35_generar_motor_html.R` (una fila por `rbd, grado, agno, cod_grupo` de la familia indicador: un establecimiento **sin fila** ese año no tiene indicadores ese año).
- **Implementación** (plantilla; lo de §6 T2.2):
  - `CSV_HIST_COLS` junto a `CSV_PAN_COLS`, con las 15 columnas del encargo, en su orden.
  - `filasHistoricoCSV({grupos,conDato,grado})` con el comentario de dos líneas del encargo: recorre `grupos` → `items` → `conDato` → `DATA.indicadores`, en el orden en que se dibujan. `gse_ultimo`/`gse_ultimo_label` salen del grupo (`"sin"` → vacío y "sin clasificar", como en `filasPanoramaCSV`); `gse_anio` es `r.anios[y]`, y su etiqueta es la de `GSE`, "sin clasificar" si el roster trae ese año sin GSE, o vacía si el establecimiento no tiene fila ese año (sin dato, el "–" de la matriz). Puntaje con `numCSV` desde `porAnio[y][ind.id]`; estado con `estadoVsGse`; `preliminar` con `PRELIM.has(String(anio))`, como en `filasPanoramaCSV`.
  - `nFilasHistorico` = indicadores × `conDato` × Σ `items`, para `confirmarTamano`; `descargarHistoricoCSV` arma `idps_panorama_historico_<territorio>_<nivel><sufijo GSE>.csv`.
  - **Sufijo de GSE compartido:** para que sea "el mismo que usa `descargarPanoramaCSV`" por construcción, sus dos líneas pasan a `sufijoGse(gseSel)`, que ahora usan las dos descargas. No cambia ningún byte ni nombre del CSV del panorama actual (lo mide PRUEBAS d).
  - `PanoramaHistorico` recibe tres props nuevas (`gseSel`, `nomArchivoTerr`, `glosaTerr`), con **las mismas expresiones** que la barra del panorama actual; no recalcula nada. El botón `IconExport` "Exportar CSV" va en una `div.export-bar` al final de `.vt-ctl`, deshabilitado si `nFilasHistorico` = 0, con `title` que cuenta con `nEE`.
  - **CSS (una regla, sin color):** `.vt-ctl .export-bar{grid-column:1/-1;justify-content:flex-end;}`. `.vt-ctl` es una grilla de dos columnas (rótulo de 140 px + contenido); sin la regla, la barra caería en la columna del rótulo. Con comentario `s33e`.
  - El comentario de la barra del panorama (`s31: … NO se dibuja (decision §3.10)`) suma una línea: "s33e: esa vista exporta con su propio boton, dentro de PanoramaHistorico". La condición `!isHistPan` no se toca.
- **Instrumentos:** `/tmp/s33e_csv.js` suma dos cosas: en `pan` cuenta las `.export-bar` (T2.1) y, en las acciones `hist_*`, vuelca las celdas de la matriz de **los cuatro indicadores** (clic en cada `.vt-ind-b` y vuelta al de partida, antes de exportar) y el orden de las filas en pantalla. Nuevo `/tmp/s33e_fidelidad.R` (🔒7, T2.3 y T2.4): filas del CSV frente a 4 × años con dato × Σ de las cifras de `.gse-sec-sub`; cabecera = `CSV_HIST_COLS`; `rbd` vacío y filas repetidas por `(rbd, anio, indicador)`; orden del CSV = orden de la pantalla; una muestra con semilla fija contra el parquet (puntaje, estado con la regla de `estadoVsGse`, `gse_anio`, `gse_ultimo`, `preliminar`) y contra la pantalla (puntaje y estado); separador, decimal y BOM. Solo imprime conteos.
- **Verificación 1 — árbol y build temporal:**
```
bash -c 'bash /tmp/s33e_arbol.sh t2; bash /tmp/s33e_build.sh t2'
```
esperado: `stat sin commitear: 1 file changed` (solo inserciones salvo las 2 líneas del sufijo y la de la firma de `PanoramaHistorico`, más el comentario de la barra); `hex agregadas=0 borradas=0`; `sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…`; `:root` `04b2876e…`.
obtenido: `stat sin commitear: 1 file changed, 69 insertions(+), 6 deletions(-)` (las 6: las dos líneas del sufijo, la segunda línea del `descargarCSV` del panorama, la firma de `PanoramaHistorico`, el comentario `s31` de la barra y la línea de la llamada a `PanoramaHistorico`); `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; motor temporal `977575d193e8207acc7728c8cdcbc909`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`.
- **Verificación 2 — T2.1, T2.2 y T2.5 (PRUEBAS d) en headless** (el `python3` solo resume la salida):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_t2.html t2 pan,cmp5,ficha,hist_foco,hist_foco_1gse,hist_comuna_2m > /tmp/s33e_t2_v2.json; python3 -c "import json; d=json.load(open(\"/tmp/s33e_t2_v2.json\")); [print(k, {x: d[k].get(x) for x in (\"n_export_bar\",\"boton\",\"captura\",\"archivo\",\"md5\",\"lineas\",\"bom\",\"chips\",\"grupos\",\"con_dato\",\"celdas\",\"title_boton\",\"error\")}, len(d[k].get(\"errores\",[]))) for k in (\"pan\",\"cmp5\",\"ficha\",\"hist_foco\",\"hist_foco_1gse\",\"hist_comuna_2m\")]; print(\"dialogos\", d[\"dialogos\"])"'
```
esperado: **T2.1:** `pan` con `n_export_bar: 1` (la barra de siempre en la vista actual); en las tres `hist_*`, `n_export_bar: 1` (la nueva, dentro de `.vt-ctl`; la del panorama sigue oculta) y `boton: ok`. **PRUEBAS d:** `cmp5` `ee741cb7be811b029e888d6cbe85fde5`, `ficha` `3b092123be1750d277b91f32ba0a071a`, `pan` `cd5ebb55a2cb02efa5598dd5a6a4f465` y los mismos nombres de archivo que en M6. **Archivos nuevos:** `idps_panorama_historico_slep_costa_central_4b.csv` (hist_foco, 2.197 líneas = 2.196 filas + cabecera, grupos y años como en M7); en hist_foco_1gse el mismo nombre con `_gse_<código>`; en hist_comuna_2m `idps_panorama_historico_<comuna>_2m.csv`. Todos con BOM y cabecera de 15 columnas. Sin diálogos (ningún caso llega a 10.000 filas); 0 errores.
obtenido: 0 errores y `dialogos []` en las seis acciones. **T2.1:** `pan` `n_export_bar: 1`; `hist_foco`, `hist_foco_1gse` y `hist_comuna_2m` `n_export_bar: 1` y `boton: ok`. **PRUEBAS d:** `cmp5` `idps_comparador_4b_2025.csv` md5 `ee741cb7be811b029e888d6cbe85fde5` (5 chips, 85 líneas), `ficha` `idps_ficha_<rbd>_4b.csv` `3b092123be1750d277b91f32ba0a071a` (92), `pan` `idps_panorama_slep_costa_central_4b_2025.csv` `cd5ebb55a2cb02efa5598dd5a6a4f465` (241): **= M6**, byte a byte y con el mismo nombre. **Archivos nuevos** (todos con BOM): `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv`, md5 `856071a8ffdfc90b3c6226251e44fbef`, **2.197 líneas**, grupos `Bajo` 10, `Medio bajo` 21, `Medio` 28, `Medio alto` 1 y `Sin clasificar` 1 (= M7), años `2014–2018` y `2022–2025`, 2.196 celdas volcadas (4 indicadores × 549); `hist_foco_1gse` (queda `Medio`, el grupo más grande) `idps_panorama_historico_slep_costa_central_4b_gse_3.csv`, `0f6d00724322768e5a96b59b92f1a466`, 1.009 líneas (28 establecimientos); `hist_comuna_2m` (la primera comuna fuera del foco, por nombre, con al menos 5 filas de roster en 2° medio: Algarrobo) `idps_panorama_historico_comuna_de_algarrobo_2m.csv`, `b79f8be920cdf772e523d0a688bc3215`, 145 líneas (4 establecimientos, 9 años). `title` del botón con `nEE`: "Descarga en CSV los 61 establecimientos de esta vista: …" (28 y 4 en los otros casos).
- **Verificación 3 — 🔒7, T2.3 y T2.4 en R** (tres casos, semilla fija 3305, 30 celdas por caso):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; for c in hist_foco:4b hist_foco_1gse:4b hist_comuna_2m:2m; do a=${c%%:*}; g=${c##*:}; echo "== $a"; Rscript /tmp/s33e_fidelidad.R /tmp/s33e_csv_t2_$a.csv /tmp/s33e_pant_t2_$a.json $g 3305 2>&1 | grep -v renv; done'
```
esperado: en los tres casos, `filas` = 4 × 9 × Σ EE (2.196, 1.008 y 144) `IGUAL`; cabecera `= CSV_HIST_COLS (15 columnas)`; `rbd vacio 0`, `filas repetidas 0`; cada EE con 36 filas; años del CSV = `con_dato`; orden del CSV = orden de la pantalla `TRUE`; muestra de 30 contra el parquet `30/30` en puntaje, estado, `gse_anio`, `gse_ultimo` y `preliminar`; contra la pantalla, `comparables 30/30`, `puntaje 30`, `estado 30`; celdas volcadas = filas del CSV; formato: 15 campos en todas las líneas, 0 puntajes con punto, BOM `TRUE`.
obtenido: en los tres casos `filas … IGUAL` (2.196 = 4 × 9 × 61; 1.008 = 4 × 9 × 28; 144 = 4 × 9 × 4); `cabecera = CSV_HIST_COLS (15 columnas)`; `rbd vacio 0 | filas repetidas (rbd, anio, indicador) 0`; 36 filas por EE en 61/61, 28/28 y 4/4; años = `con_dato` `TRUE`; nivel único; indicadores `1,2,3,4`; orden = pantalla `TRUE` (61, 28 y 4 filas); `(rbd, anio) con mas de un GSE 0`; celdas volcadas = filas del CSV `TRUE`; contra la pantalla `comparables 30/30 | puntaje 30 | estado 30` en los tres; formato: 15 campos en todas las líneas, `puntaje con punto 0 | con coma 0`, BOM `TRUE`. Contra el parquet: `estado 30/30 | gse_anio 30/30 | gse_ultimo 30/30 | preliminar 30/30` en los tres, pero **`puntaje 25/30`, `24/30` y `26/30`**.
- **Corrección (error de instrumento, 🔒7):** el payload no lleva el `prom` crudo del parquet sino `prom = round(ind$prom, 0)` ("entero presentacion (s14)", `35_generar_motor_html.R`, en `ind_lst`); por eso tampoco hay puntajes con coma. Mi verificador comparaba contra el valor crudo. Lo corrijo para comparar contra `round(prom, 0)` (la misma función de R que usa el generador) y para contar cuántos `prom` de la muestra no son enteros en el parquet; si la explicación es esa, ese conteo debe ser igual al número de fallas de antes (5, 6 y 4). Repito con la misma semilla:
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; for c in hist_foco:4b hist_foco_1gse:4b hist_comuna_2m:2m; do a=${c%%:*}; g=${c##*:}; echo "== $a"; Rscript /tmp/s33e_fidelidad.R /tmp/s33e_csv_t2_$a.csv /tmp/s33e_pant_t2_$a.json $g 3305 2>&1 | grep -v renv | grep "vs parquet"; done'
```
esperado: `puntaje 30/30` en los tres casos, con `prom no entero en el parquet` = 5, 6 y 4; el resto de la línea sin cambios.
obtenido: `puntaje 30/30 | estado 30/30 | gse_anio 30/30 | gse_ultimo 30/30 | preliminar 30/30` en los tres casos, con `prom no entero en el parquet 5`, `6` y `4` (= las fallas de antes). Muestras: `con puntaje 29 | sin fila ese anio 1`; `29 | 0`; `17 | 13` (en la comuna de 2° medio, 13 de las 30 celdas son años en que el establecimiento no tiene fila: `gse_anio` y su etiqueta vacíos, verificado). **🔒7 PASA en los tres casos.** T2.3 (cero agregación) y T2.4 (separador `;`, sin punto decimal, BOM; mismas `aCSV` y `numCSV`) conformes.
- **Verificación 4 — T2.6 nacional y PRUEBAS b** (headless; el diálogo se acepta; filas contadas en R):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_t2.html t2 hist_nac > /tmp/s33e_t2_v4.json; python3 -c "import json; d=json.load(open(\"/tmp/s33e_t2_v4.json\")); k=d[\"hist_nac\"]; print({x: k.get(x) for x in (\"n_export_bar\",\"boton\",\"captura\",\"archivo\",\"md5\",\"lineas\",\"bom\",\"con_dato\",\"celdas\",\"error\")}, [g.split(\":\")[0]+\":\"+g.split(\":\")[2].split(\" \")[0] for g in k[\"grupos\"]], len(k.get(\"errores\",[])), d[\"dialogos\"])"; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s33e_fidelidad.R /tmp/s33e_csv_t2_hist_nac.csv /tmp/s33e_pant_t2_hist_nac.json 4b 3305 2>&1 | grep -v renv; bash /tmp/s33e_pruebas_b.sh /tmp/s33e_motor_t2.html'
```
esperado: `n_export_bar: 1`, `boton: ok`, **un diálogo** "El archivo que vas a descargar tiene N filas (Chile)…", con N = 4 × 9 × Σ de los grupos (se registra); aceptado, `captura: true`, `idps_panorama_historico_chile_4b.csv`, BOM; 0 errores. En R: `filas N … IGUAL`, cero agregación (`rbd vacio 0`, `repetidas 0`), muestra 30/30 contra el parquet y "sin matriz en pantalla (nacional)". PRUEBAS b: `modales` sin errores de consola ni `pageerror`, `ficha` con `errores 0`, `comparacion` con `errores []` y `desbordadas []`.
obtenido: `n_export_bar: 1`, `boton: ok`, **un diálogo**: "El archivo que vas a descargar tiene 298.224 filas (Chile). Puede tardar unos segundos en generarse y pesar varios MB. ¿Continuar?"; aceptado: `captura: True`, `idps_panorama_historico_chile_4b.csv`, md5 `33b8d670a401d84c203c6a15b793c71d`, 298.225 líneas, BOM; grupos `Bajo` 2.141, `Medio bajo` 2.573, `Medio` 1.868, `Medio alto` 789, `Alto` 555, `Sin clasificar` 358 (Σ 8.284); 0 celdas volcadas (sin matriz a nivel nacional); 0 errores. En R: `filas 298224 | esperadas 4 x 9 anios x 8284 EE = 298224 | IGUAL`; cabecera `= CSV_HIST_COLS`; `rbd vacio 0 | filas repetidas 0 | rbd distintos 8284`; 36 filas en 8.284 de 8.284; `(rbd, anio) con mas de un GSE 0`; muestra `puntaje 30/30 | estado 30/30 | gse_anio 30/30 | gse_ultimo 30/30 | preliminar 30/30` (`prom no entero en el parquet 7`); "sin matriz en pantalla (nacional)"; formato 15 campos en 298.225 líneas, sin punto decimal, BOM `TRUE`. PRUEBAS b: `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`; ficha `"errores":[] "glosa_existe":true`; comparación `"errores":[] "desbordadas":0` (el esperado decía `[]`; el instrumento lo reporta como número: 0).
- **Revisión propia de la ubicación** (`/tmp/s33e_vtctl_foto.js`, fuera de los criterios del encargo; captura de `.vt-ctl` y geometría del botón):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for w in 1280 390; do node /tmp/s33e_vtctl_foto.js /tmp/s33e_motor_t2.html $w /tmp/s33e_vtctl_$w.png; done; node /tmp/s33e_vtctl_foto.js /tmp/s33e_motor_fase0.html 390 /tmp/s33e_vtctl_390_fase0.png'
```
esperado: (propio) el botón en la última fila de `.vt-ctl`, alineado a la derecha, dentro del panel en los dos anchos; 0 errores; la página sin desborde horizontal.
obtenido: 1280 px: panel 64–1216, botón 1061–1199, 144 px bajo el borde superior del panel (última fila, a la derecha; la captura lo confirma); 0 errores. 390 px: panel 24–366, botón 211–349 (dentro); pero **la página desborda 423 px**, y el motor de FASE 0 desborda lo mismo (423) en la misma vista: lo producen la tabla `.vt-mx` y su encabezado, no el botón. **Advertencia A-1** (anterior a este encargo, fuera de su ALCANCE): a 390 px, la matriz de la vista histórica no queda contenida en `.vt-scroll` y la página se desplaza en horizontal.
- **Estado de T2:** completada. T2.1–T2.6 conformes (T2.2 tras corregir mi verificador, que comparaba contra el `prom` crudo).

### FASE T3: enmienda §3.10 de la decisión

- **Edición:** al final de `20260917_decision_vista_historica_territorial.md`, tras una línea en blanco (la forma de las enmiendas s32 y s32f), la línea del encargo, literal. No se edita el punto 10 original.
- **Verificación:**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; D=50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md; echo "enmienda $(grep -c "Enmienda s33e" $D)"; git diff -U0 --stat -- $D | tail -1; echo "borradas $(git diff -U0 -- $D | grep -c "^-[^-]")"; echo "punto10 $(grep -c "Mientras esté activa la vista histórica, la barra de exportación del panorama no se muestra" $D)"; git status --porcelain'
```
esperado: `enmienda 1`; `1 file changed, 2 insertions(+)` (la línea en blanco y la enmienda); `borradas 0`; `punto10 1` (el original sigue); porcelain con la decisión, el motor temporal y el LOG; sin código tocado.
obtenido: `enmienda 1`; la segunda línea no fue la estadística sino la última línea del parche (`-U0` activa el parche y `tail -1` tomó la línea `+**Enmienda s33e …**`); `borradas 0`; `punto10 1`; porcelain ` M 40_salidas/motor_idps.html`, ` M …/20260917_decision_vista_historica_territorial.md`, `?? …_s33e_log.md`.
- **Corrección (comando):** repito la estadística sin `-U0`:
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; git diff --stat -- 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md | tail -1; git diff --numstat -- 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md'
```
esperado: `1 file changed, 2 insertions(+)`; `2	0	…`.
obtenido: `1 file changed, 2 insertions(+)`; `2	0	50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`. Solo inserciones; sin código tocado.
- **Estado de T3:** completada.

### FASE T4: build

- **Paso 1 — porcelain antes del build:**
```
git -C /Users/tomgc/Projects/slep_idps status --porcelain
```
esperado: solo ` M 40_salidas/motor_idps.html` (el motor temporal de T1) y `?? …_s33e_log.md`.
obtenido: ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260924_csv_historico_s33e_log.md`. Conforme; T4 sigue.
- **Paso 2 — build completo (PRUEBAS a), hash y porcelain:**
```
bash -c 'bash /tmp/s33e_build.sh t4 completo; git -C /Users/tomgc/Projects/slep_idps status --porcelain; echo "motor_repo $(md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html)"'
```
esperado: `rc=0 warn=0 pasos_ok=5` (pasos 31 a 35); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `04b2876e…`; porcelain igual al del paso 1; `motor_repo` = md5 de la copia `/tmp/s33e_motor_t4.html`.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `977575d193e8207acc7728c8cdcbc909` (= el temporal de T2: misma plantilla y misma fecha de build); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain ` M 40_salidas/motor_idps.html` y `?? …_s33e_log.md` (= paso 1); `motor_repo 977575d193e8207acc7728c8cdcbc909`.
- **Paso 3 — PRUEBAS d, 🔒7 en un caso, PRUEBAS b y testigo** (motor commiteable; 🔒7 sobre el SLEP foco en 4° básico con semilla 3306 y la muestra **solo del indicador visible en la matriz**, la letra de 🔒7 ii; la línea "todas las celdas" compara además las 2.196 contra el parquet):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_t4.html t4 pan,cmp5,ficha,hist_foco > /tmp/s33e_t4.json; python3 -c "import json; d=json.load(open(\"/tmp/s33e_t4.json\")); [print(k, d[k].get(\"archivo\"), d[k].get(\"md5\"), d[k].get(\"lineas\"), d[k].get(\"n_export_bar\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"pan\",\"cmp5\",\"ficha\",\"hist_foco\")]"; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s33e_fidelidad.R /tmp/s33e_csv_t4_hist_foco.csv /tmp/s33e_pant_t4_hist_foco.json 4b 3306 30 visible 2>&1 | grep -v renv; bash /tmp/s33e_pruebas_b.sh /tmp/s33e_motor_t4.html; R=/Users/tomgc/Projects/slep_idps; echo "testigo CSV_HIST_COLS motor $(grep -c -F CSV_HIST_COLS $R/40_salidas/motor_idps.html) docs $(grep -c -F CSV_HIST_COLS $R/docs/index.html)"'
```
esperado: `pan` `cd5ebb55…`, `cmp5` `ee741cb7…`, `ficha` `3b092123…` (= M6), `pan` con `n_export_bar 1`; `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv`, md5 `856071a8…` (= T2: mismo motor), 2.197 líneas, `n_export_bar 1`; 0 errores. En R: `filas 2196 … IGUAL`; `todas las celdas vs parquet: puntaje = round(prom, 0) en 2196 de 2196 | estado 2196 de 2196 | max |puntaje - prom crudo|` ≤ 0,5; muestra de 30 del indicador visible (549 candidatas): parquet 30/30 en todo; pantalla `comparables 30/30 | puntaje 30 | estado 30`. PRUEBAS b sin errores. Testigo: `motor` ≥ 1, `docs 0`.
obtenido: `pan` `idps_panorama_slep_costa_central_4b_2025.csv` `cd5ebb55a2cb02efa5598dd5a6a4f465` 241 líneas, `n_export_bar 1`; `cmp5` `idps_comparador_4b_2025.csv` `ee741cb7be811b029e888d6cbe85fde5` 85; `ficha` `idps_ficha_<rbd>_4b.csv` `3b092123be1750d277b91f32ba0a071a` 92 (**PRUEBAS d = M6**); `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv` `856071a8ffdfc90b3c6226251e44fbef` 2.197, `n_export_bar 1`; 0 errores. En R: `filas 2196 | esperadas 4 x 9 anios x 61 EE = 2196 | IGUAL`; cabecera `= CSV_HIST_COLS`; `rbd vacio 0 | filas repetidas 0`; orden = pantalla `TRUE`; **`todas las celdas vs parquet: puntaje = round(prom, 0) en 2196 de 2196 | estado 2196 de 2196 | max |puntaje - prom crudo| 0.500 | prom crudo no entero 470`**; muestra del indicador visible (`1`, 549 candidatas), semilla 3306: `puntaje 30/30 | estado 30/30 | gse_anio 30/30 | gse_ultimo 30/30 | preliminar 30/30` (`prom no entero en el parquet 7`); pantalla `comparables 30/30 | puntaje 30 | estado 30`; formato conforme. PRUEBAS b: `"consola_errores":[] "pageerror":[]`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`. **Testigo `CSV_HIST_COLS`: motor 2, docs 0.**
- **Lectura declarada de 🔒7 (ii)** ("el puntaje del CSV coincide … con el `prom` de `idps_largo.parquet`"): el motor lleva el `prom` redondeado a entero desde s14 (`prom = round(ind$prom, 0)` en el generador); pantalla y CSV muestran ese entero, igual que el CSV del panorama actual. Comparo contra `round(prom, 0)`: coincide en 2.196 de 2.196, y la diferencia con el crudo nunca pasa de 0,5 (470 celdas con `prom` no entero). Con el `prom` crudo "coincide" fallaría en esas 470 celdas sin que el CSV se aparte de la pantalla ni del dato. Queda como **duda D-2** (pregunta cerrada en el Cierre); no la trato como 🔒 en FALLA.
- **Paso 3b — 🔒8 sobre el motor commiteable** (el comando de M8 con `M=/tmp/s33e_motor_t4.html`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33e_motor_t4.html; for m in ventana headless; do node /tmp/s33e_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33e_t4_l6_$m.json; python3 /tmp/s33e_l6_resumen.py /tmp/s33e_t4_l6_$m.json; done; for m in ventana headless; do node /tmp/s33e_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33e_t4_foco.jsonl; python3 /tmp/s33e_foco_resumen.py /tmp/s33e_t4_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/"'
```
esperado: = M8 en los dos modos: `terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0`; respaldos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`; 0 errores.
obtenido: `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; respaldos en los dos modos `SPAN.cmp-cl` ×3 (tope_listo, tope_escape, tope_fondo), `DIV.ficha-name` (terr_ee), `BUTTON.cmp-add` (desmarcar); 0 errores. Comparación textual con M8 (mismo resumen, con el nombre del motor normalizado):
```
bash -c 'diff <(python3 /tmp/s33e_foco_resumen.py /tmp/s33e_m8_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33e_motor_[a-z0-9]+\.html/MOTOR/") <(python3 /tmp/s33e_foco_resumen.py /tmp/s33e_t4_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/; s/s33e_motor_[a-z0-9]+\.html/MOTOR/") && echo "foco = M8"; for m in ventana headless; do diff <(python3 /tmp/s33e_l6_resumen.py /tmp/s33e_m8_l6_$m.json) <(python3 /tmp/s33e_l6_resumen.py /tmp/s33e_t4_l6_$m.json) && echo "l6 $m = M8"; done'
```
esperado: `foco = M8`, `l6 ventana = M8`, `l6 headless = M8` (sin líneas de diferencia).
obtenido: `foco = M8`, `l6 ventana = M8`, `l6 headless = M8`. **🔒8 PASA.**
- **Paso 4 — md5 y commit:** motor `977575d193e8207acc7728c8cdcbc909`; testigo para el despliegue: `CSV_HIST_COLS` (2 en el motor, 0 en `docs/index.html`).
- **Estado de T4:** completada.

### FASE R: auditoría propia y reparación

**Paso 1 — inventario** (derivado del log, antes de auditar):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno: `<inicio>` = `9e7b993`, hijo de `82bcae0` = `origin/main`; stash vacío (M1, M2) |
| R-02 | 🔒1: §8.2 `eb4e00b3…4dc4` en FASE 0, T1, T2 y T4; la fecha alterada no lo mueve y la cifra plantada sí (M3) |
| R-03 | 🔒2: `:root` `04b2876e…` (65 líneas); hex agregadas 0 en el diff de la plantilla |
| R-04 | 🔒3: `sigdifgru` en líneas cambiadas 0/0; `const sg` 1 |
| R-05 | 🔒4: pipeline de datos intacto |
| R-06 | 🔒5: `docs/` intacto |
| R-07 | 🔒6 / PRUEBAS d: `ee741cb7…`, `cd5ebb55…`, `3b092123…` iguales en M6, T2 y T4 (M4: el instrumento captura con BOM) |
| R-08 | 🔒7 (T2.2): filas 2.196 / 1.008 / 144 / 298.224 = 4 × 9 × Σ EE (61 / 28 / 4 / 8.284); 30 celdas contra pantalla y parquet (semillas 3305 y 3306), leídas contra `round(prom, 0)` (D-2) |
| R-09 | T2.3 cero agregación: `rbd` nunca vacío, sin `(rbd, anio, indicador)` repetidos |
| R-10 | T2.4: `;`, sin punto decimal, BOM, 15 campos por línea |
| R-11 | T2.1: una `.export-bar` en la vista histórica (la nueva) y una en la actual (M7: 0 en la histórica antes) |
| R-12 | T2.6: nacional con diálogo de 298.224 filas, archivo generado y contado en R |
| R-13 | Implementación de T2 conforme a §6 T2.2: 15 columnas en su orden, constructor con los mismos `grupos` y `conDato`, comentario literal de dos líneas, botón al final de `.vt-ctl`, deshabilitado sin filas, `title` con `nEE`, nombre `idps_panorama_historico_<territorio>_<nivel><sufijo GSE>.csv` |
| R-14 | Reglas canónicas en el código nuevo: sin comentario CSS con `*/` interno, sin hex, sin `text-transform:uppercase`, conteos por `nEE` |
| R-15 | T1 congelada: la plantilla no conserva el `onFocus`; H-1 (la pestaña de 335 px no cabe en 296) (M5, verificación de T1) |
| R-16 | T3: enmienda literal, 1 vez, solo inserciones; punto 10 intacto |
| R-17 | T4: PRUEBAS a (`rc=0 warn=0 pasos_ok=5`), porcelain solo motor y LOG; motor `977575d1…`; testigo `CSV_HIST_COLS` 2 / 0 (M9: 0/0/0) |
| R-18 | 🔒8: foco y teclado = M8 en los dos modos |
| R-19 | Alcance global: commits ⊆ {plantilla, decisión, motor} + LOG + encargo |
| R-20 | A-1: a 390 px la vista histórica desborda 423 px, igual en FASE 0 (anterior al encargo) |

**Paso 2 — re-derivación independiente.** Instrumento nuevo `/tmp/s33e_rederivar.R` (base R, sin `dplyr`; otro lector del CSV: `read.table` con `dec=","` y puntaje numérico). Modo `filas`: las filas esperadas de los cuatro casos **solo desde los parquet** (`idps_largo`, `sleps_chile`, `establecimientos_chile`, `comunas_chile`): establecimientos del territorio con fila de indicador en el nivel, años con dato del nivel, GSE del último año con GSE no nulo; sin leer el CSV ni el motor. Modo `celdas`: **todas** las celdas del CSV contra el parquet (puntaje contra `round(prom, 0)` y estado) y 30 al azar contra la pantalla, con otra semilla.

R-08 (filas):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; Rscript /tmp/s33e_rederivar.R filas 2>&1 | grep -v renv'
```
esperado: `SLEP foco 4b, todos los GSE: EE 61 | anios con dato 9 (2014-2025) | indicadores 4 | filas esperadas 2196`; `solo GSE 3: EE 28 … 1008`; `comuna Algarrobo 2m: EE 4 … 144`; `Chile 4b: EE 8284 … 298224`; control: 1 comuna con ese nombre.
obtenido: `SLEP foco 4b, todos los GSE: EE 61 | anios con dato 9 (2014-2025) | indicadores 4 | filas esperadas 2196`; `solo GSE 3: EE 28 … 1008`; **`comuna Algarrobo 2m: EE 3 … 108`**; `Chile 4b: EE 8284 … 298224`; `control: comunas con ese nombre 1 | RBD del SLEP foco sin fila en el directorio 0`. Tres de cuatro casos coinciden; la comuna da 3 y el CSV (y la pantalla) 4.
- **Corrección (error del re-derivador):** busqué la diferencia. Un establecimiento con fila de 2° medio y `cod_com_rbd` de Algarrobo en el parquet **no está** en `establecimientos_chile.parquet` (conteo: `parquet cod_com_rbd (cualquier anio): 4 | establecimientos_chile con fila 2m: 3 | en parquet y no en est: 1 | ese rbd en establecimientos_chile: 0`). El generador no usa ese archivo para la comuna: toma la del directorio oficial (`20_insumos/auxiliares/directorio_oficial_ee_publico.csv`) y, si falta, la del parquet (`cod_com = coalesce(cod_com_dir, cod_com_rbd)`, `35_generar_motor_html.R`). Corrijo el re-derivador con esa regla (directorio y, si falta, `cod_com_rbd` del año más reciente del parquet) y repito:
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; Rscript /tmp/s33e_rederivar.R filas 2>&1 | grep -v renv'
```
esperado: `comuna Algarrobo 2m: EE 4 … filas esperadas 144`; los otros tres casos sin cambio (2.196, 1.008, 298.224).
obtenido: `SLEP foco 4b, todos los GSE: EE 61 … filas esperadas 2196`; `solo GSE 3: EE 28 … 1008`; **`comuna Algarrobo 2m: EE 4 … 144`**; `Chile 4b: EE 8284 … 298224`; `control: comunas con ese nombre 1 | RBD del SLEP foco sin fila en establecimientos_chile 0 | RBD del parquet fuera del directorio 1`. **R-08 (filas) re-derivado desde el parquet: 2.196, 1.008, 144 y 298.224 = los CSV.**

R-08 (celdas) y R-09: todas las celdas contra el parquet y 30 nuevas contra la pantalla, semilla **3307**:
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; for c in t4_hist_foco:4b t2_hist_foco_1gse:4b t2_hist_comuna_2m:2m t2_hist_nac:4b; do a=${c%%:*}; g=${c##*:}; j=/tmp/s33e_pant_$a.json; [ $a = t2_hist_nac ] && j=""; echo "== $a"; Rscript /tmp/s33e_rederivar.R celdas /tmp/s33e_csv_$a.csv $g 3307 $j 2>&1 | grep -v renv; done'
```
esperado: `celdas N | puntaje = parquet redondeado N | estado N` en los cuatro casos (N = 2.196, 1.008, 144 y 298.224), con `sin fila en el parquet` = celdas de años sin fila (el "–"); en los tres casos con matriz, `encontradas 30/30 | puntaje 30/30 | estado 30/30 | vs parquet 30/30`.
obtenido: `t4_hist_foco`: `celdas: 2196 | puntaje = parquet redondeado 2196 | estado 2196 | sin fila en el parquet 52 | con puntaje 2111`, muestra `encontradas 30/30 | puntaje 30/30 | estado 30/30 | vs parquet 30/30`; `t2_hist_foco_1gse`: `1008 | 1008 | 1008 | 20 | 970`, muestra 30/30 en todo; `t2_hist_comuna_2m`: `144 | 144 | 144 | 36 | 108`, muestra 30/30 en todo; `t2_hist_nac`: `298224 | 298224 | 298224 | 37024 | 249398`. **R-08 (celdas) y R-09 re-derivados: todas las celdas de los cuatro CSV coinciden con el parquet (puntaje redondeado y estado); 90 celdas nuevas coinciden con la pantalla.**

**Paso 6 — control positivo** (fuera del árbol; `/tmp/s33e_plantar_csv.py` escribe dos CSV plantados desde el de T4: uno con un puntaje +1 y otro sin la última fila):
```
bash -c 'python3 /tmp/s33e_plantar_csv.py; cd /Users/tomgc/Projects/slep_idps; Rscript /tmp/s33e_rederivar.R celdas /tmp/s33e_csv_plantado_celda.csv 4b 3307 2>&1 | grep -v renv; Rscript /tmp/s33e_fidelidad.R /tmp/s33e_csv_plantado_fila.csv /tmp/s33e_pant_t4_hist_foco.json 4b 3306 30 visible 2>&1 | grep -v renv | grep -E "^filas|^por EE"'
```
esperado: plantada la celda de la fila 1 (o la primera con puntaje); el re-derivador da `puntaje = parquet redondeado 2195` de 2.196 (**detecta** la celda); con la fila quitada, `filas 2195 | … = 2196 | DISTINTO` y un EE con 35 filas (`… en 60 de 61`).
obtenido: `plantados: celda alterada en la fila 1 | filas originales 2196`; `celdas: 2196 | puntaje = parquet redondeado 2195 | estado 2196 | …` (**detectada**); `filas 2195 | esperadas 4 x 9 anios x 61 EE = 2196 | DISTINTO`; `por EE: 36 filas cada uno en 60 de 61` (**detectada**). Las dos auditorías fallan donde deben.

**Paso 3 — invariantes** (sobre `HEAD` y el motor versionado; 🔒1 y 🔒2 con los re-derivadores en Python, otra implementación que la de los builds):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=9e7b993; M=$R/40_salidas/motor_idps.html; T=$R/30_procesamiento/35_motor_template.html; echo "1 $(python3 /tmp/s33e_r_payload.py $M | cut -c1-200)"; echo "2 root $(python3 /tmp/s33e_r_root.py $T | cut -c1-120) ; $(bash /tmp/s33e_hex.sh | head -1)"; echo "3 $(bash /tmp/s33e_sig.sh | head -1)"; echo "4 $(git -C $R diff $I..HEAD -- 10_utils 20_insumos 30_procesamiento/31* 30_procesamiento/32* 30_procesamiento/33* 30_procesamiento/34* 30_procesamiento/35_generar_motor_html.R | wc -l | tr -d " ")"; echo "5 $(git -C $R diff --name-only $I..HEAD -- docs | wc -l | tr -d " ")"; for k in pan cmp5 ficha; do cmp -s /tmp/s33e_csv_f0_$k.csv /tmp/s33e_csv_t4_$k.csv && echo "6 $k identico (cmp)" || echo "6 $k DISTINTO"; done'
```
esperado: 1 `eb4e00b3…4dc4`; 2 `:root` 65 líneas `04b2876e…`, `hex agregadas=0 borradas=0`; 3 `sigdifgru borradas=0 agregadas=0 const_sg=1`; 4 `0`; 5 `0`; 6 los tres CSV idénticos byte a byte con `cmp` (otro comando que el md5 de T4). 🔒7 y 🔒8: ya re-derivados arriba (paso 2) y en T4.
obtenido: `1 motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1 bytes=59467463`; `2 root 35_motor_template.html lineas=65 md5=04b2876e2bcece41f09398f28f6fc41d ; hex agregadas=0 borradas=0`; `3 sigdifgru borradas=0 agregadas=0 const_sg=1`; `4 0`; `5 0`; `6 pan identico (cmp)`, `6 cmp5 identico (cmp)`, `6 ficha identico (cmp)`. **🔒1–🔒6 PASAN**; 🔒7 PASA (paso 2, con la lectura D-2); 🔒8 PASA (T4, `diff` contra M8).

**Paso 4 — alcance global y código nuevo** (R-13, R-14, R-15, R-19):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=9e7b993; T=$R/30_procesamiento/35_motor_template.html; git -C $R diff --name-only $I..HEAD; git -C $R status --porcelain; D=$(git -C $R diff -U0 $I..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+[^+]"); echo "comentario $(grep -c -F "// s33e: CSV de la vista historica (pendiente 4 de v31). Recibe los mismos grupos y anios" $T) $(grep -c -F "// que dibuja PanoramaHistorico (regla de fidelidad de s30); una fila por EE, anio e indicador." $T)"; echo "columnas $(grep -A1 -F "const CSV_HIST_COLS=" $T | tr -d " \n" | grep -c -F "[\"rbd\",\"establecimiento\",\"comuna\",\"dependencia\",\"gse_ultimo\",\"gse_ultimo_label\",\"anio\",\"gse_anio\",\"gse_anio_label\",\"indicador\",\"indicador_label\",\"puntaje\",\"estado_vs_gse\",\"nivel\",\"preliminar\"]")"; echo "css_cierre_interno $(printf "%s\n" "$D" | grep -F "/*" | grep -c -E "\*/.+\*/")"; echo "uppercase $(printf "%s\n" "$D" | grep -c -i "text-transform")"; echo "conteo_a_mano $(printf "%s\n" "$D" | grep -c -E "\+\" (establecimientos|comunas)")"; echo "onFocus $(grep -c "scrollIntoView" $T)"; echo "llamadas $(grep -c "descargarHistoricoCSV(" $T) $(grep -c "filasHistoricoCSV(" $T)"; grep -n -o "descargarHistoricoCSV({[^}]*})" $T'
```
esperado: los commits tocan solo `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html` y la decisión (el encargo es `<inicio>`; el LOG va en FASE L); porcelain = solo el LOG; `comentario 1 1`; `columnas 1`; `css_cierre_interno 0`; `uppercase 0`; `conteo_a_mano 0`; `onFocus 0` (T1 congelada); `llamadas 2 2` (definición + uso de cada una); la llamada pasa `grupos` y `conDato` sin transformarlos.
obtenido: `git diff --name-only 9e7b993..HEAD` = `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`, `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md` (⊆ ALCANCE); porcelain `?? …_s33e_log.md` (solo el LOG); `comentario 1 1`; `columnas 1`; `css_cierre_interno 0`; `uppercase 0`; `conteo_a_mano 0`; `onFocus 0`; `llamadas 2 2`; la llamada (línea 2835) pasa `{grupos,conDato,grado:panGrado,gseSel,nomArchivoTerr,glosaTerr}`: los `grupos` y `conDato` con los que `PanoramaHistorico` dibuja, sin transformar. **R-13, R-14, R-15 y R-19 conformes.**

**Paso 5 — regresión completa sobre el estado final** (PRUEBAS a con `run_all()` entero; c; b; d):
```
bash -c 'bash /tmp/s33e_build.sh r completo; git -C /Users/tomgc/Projects/slep_idps status --porcelain; bash /tmp/s33e_pruebas_b.sh /tmp/s33e_motor_r.html; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_r.html r pan,cmp5,ficha,hist_foco | python3 -c "import json,sys; d=json.load(sys.stdin); [print(k, d[k].get(\"md5\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"pan\",\"cmp5\",\"ficha\",\"hist_foco\")]"'
```
esperado: PRUEBAS a `rc=0 warn=0 pasos_ok=5`, motor `977575d1…` (= `HEAD`: misma plantilla y misma fecha), porcelain solo el LOG (el build no deja el motor modificado); PRUEBAS c §8.2 `eb4e00b3…`; PRUEBAS b sin errores; PRUEBAS d `cd5ebb55…`, `ee741cb7…`, `3b092123…`, y `hist_foco` `856071a8…`; 0 errores.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `977575d193e8207acc7728c8cdcbc909` (= `HEAD`); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `04b2876e…`; porcelain `?? …_s33e_log.md` (solo el LOG); PRUEBAS b `"consola_errores":[] "pageerror":[]`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d `cd5ebb55…`, `ee741cb7…`, `3b092123…`; `hist_foco` `856071a8…`; 0 errores. **PRUEBAS a, b, c y d conformes sobre el estado final.**

**Hallazgo de lectura, medido** (R-13; al releer `sufijoGse`): la selección que entra al sufijo es `DATA.meta.gse.filter(g=>gseVis.has(g))`, que deja fuera "Sin clasificar" (`"sin"` no está en `DATA.meta.gse`). Si en la vista histórica se oculta solo "Sin clasificar", el universo cambia pero el nombre del archivo no. Instrumento: `/tmp/s33e_csv.js` suma la acción `hist_foco_sin` (apaga el botón "Sin clasificar" antes de exportar):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33e_csv.js /tmp/s33e_motor_r.html r hist_foco_sin | python3 -c "import json,sys; d=json.load(sys.stdin)[\"hist_foco_sin\"]; print({k: d.get(k) for k in (\"oculto\",\"archivo\",\"md5\",\"lineas\",\"error\")}, [g.split(\":\")[0]+\":\"+g.split(\":\")[1] for g in d[\"grupos\"]], len(d.get(\"errores\",[])))"'
```
esperado: `oculto: True`; archivo `idps_panorama_historico_slep_costa_central_4b.csv` (**el mismo nombre** que con todos los grupos), 2.161 líneas (60 establecimientos × 36 + cabecera), md5 distinto de `856071a8…`; 0 errores.
obtenido: `{'oculto': True, 'archivo': 'idps_panorama_historico_slep_costa_central_4b.csv', 'md5': 'b6e9305ac157dcd4c59b332cfd27ae75', 'lineas': 2161, 'error': None}`, grupos `Bajo` 10, `Medio bajo` 21, `Medio` 28, `Medio alto` 1 (60); 0 errores. **Mismo nombre que el archivo de 61 establecimientos, con otro contenido.** Es lo que manda §6 T2.2 ("el mismo sufijo de GSE que usa `descargarPanoramaCSV`"); corregirlo cambiaría la especificación, así que no se repara: **advertencia A-2 y duda D-3.**

**Pasos 7 y 10 — tabla y veredicto:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno `9e7b993` | `git diff --name-only 9e7b993..HEAD` (paso 4) | 3 rutas del ALCANCE | 3 rutas del ALCANCE | — | ninguna | — | — |
| R-02 | 🔒1 §8.2 | `r_payload.py` (Python) sobre `HEAD` | `eb4e00b3…` | `eb4e00b3…` | PASA | ninguna | — | build `r` = `eb4e00b3…` |
| R-03 | 🔒2 paletas y hex | `r_root.py`; `hex.sh` sobre `9e7b993..HEAD` | `04b2876e…`; 0 | `04b2876e…`; `0/0` | PASA | ninguna | — | — |
| R-04 | 🔒3 `sigdifgru` | `sig.sh` sobre `9e7b993..HEAD` | 0/0, `const_sg=1` | 0/0, 1 | PASA | ninguna | — | — |
| R-05 | 🔒4 pipeline | `git diff … \| wc -l` | 0 | 0 | PASA | ninguna | — | — |
| R-06 | 🔒5 `docs/` | `git diff --name-only … -- docs` | 0 | 0 | PASA | ninguna | — | — |
| R-07 | 🔒6 PRUEBAS d | `cmp` byte a byte M6 ↔ T4; `csv.js` en el build `r` | idénticos | idénticos; mismos md5 | PASA | ninguna | — | build `r` |
| R-08 | 🔒7 filas y celdas | `rederivar.R filas` (solo parquet) y `celdas` (todas, semilla 3307) | 2.196/1.008/144/298.224; todas | iguales; todas (tras corregir el re-derivador) | PASA (lectura D-2) | pregunta D-2 | — | control positivo |
| R-09 | T2.3 cero agregación | `rederivar.R celdas` (clave única por `match`) | sin repetidos | todas las celdas casan 1 a 1 | PASA | ninguna | — | — |
| R-10 | T2.4 formato | `read.table(sep=";", dec=",")` lee el puntaje como número | lee | lee (2.111 puntajes en hist_foco) | PASA | ninguna | — | — |
| R-11 | T2.1 barras | `csv.js` build `r` (`hist_foco`) | 1 | 1 | PASA | ninguna | — | — |
| R-12 | T2.6 nacional | `rederivar.R filas` y `celdas` sobre el CSV nacional | 298.224; todas | 298.224; todas | PASA | ninguna | — | — |
| R-13 | implementación de T2 | `grep` de comentario, columnas, llamada | 1 1; 1; `grupos`,`conDato` | 1 1; 1; sí | ADVIERTE (A-2: sufijo sin "Sin clasificar") | pregunta D-3 | — | `hist_foco_sin` |
| R-14 | reglas canónicas | `grep` sobre las líneas agregadas | 0/0/0 | 0/0/0 | PASA | ninguna | — | — |
| R-15 | T1 congelada | `grep -c scrollIntoView` | 0 | 0 | ADVIERTE (T1 sin entregar; D-1) | pregunta D-1 | — | — |
| R-16 | T3 enmienda | `git diff --numstat` (T3) | `2 0` | `2 0` | PASA | ninguna | — | — |
| R-17 | T4 build | build `r` completo y porcelain | `977575d1…`; solo LOG | `977575d1…`; solo LOG | PASA | ninguna | — | — |
| R-18 | 🔒8 foco | `diff` de resúmenes contra M8 (T4) | sin diferencias | sin diferencias | PASA | ninguna | — | — |
| R-19 | alcance global | `git diff --name-only`; porcelain | ⊆ ALCANCE; solo LOG | ⊆; solo LOG | PASA | ninguna | — | — |
| R-20 | A-1 desborde a 390 | `vtctl_foto.js` en FASE 0 y T2 | — | 423 y 423 | ADVIERTE (anterior al encargo) | registro | — | — |

- **Control positivo:** una celda alterada y una fila quitada, detectadas por las dos auditorías (paso 6). Ningún hallazgo BLOQUEA; ninguno pide REPARA (los defectos encontrados fueron de mis instrumentos y se corrigieron antes de concluir; ver Errores propios); 0 ciclos de reparación, 0 commits `fix(auditoria)`.
- **Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (A-1, A-2, D-2 y T1 congelada).

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1; git -C /Users/tomgc/Projects/slep_idps log --oneline 82bcae0..HEAD'
```
esperado: solo este LOG; `main` adelantada 4 respecto de `origin/main`; commits `9e7b993`, `b6b56c6`, `f31a7e3`, `0ed771d`.
obtenido: `?? 50_documentacion/andamios/logs/20260924_csv_historico_s33e_log.md` (única); `## main...origin/main [ahead 4]`; `0ed771d`, `f31a7e3`, `b6b56c6`, `9e7b993`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33e (la pestaña enfocada se ve entera, CSV de la vista histórica, enmienda §3.10 y build). Fases: FASE 0, T1 a T4, R y L. Estado del grafo: **T1 CONGELADA** (regla 7: con la edición permitida, la pestaña de 335 px no cabe en una barra de 296; sin commit) · T2 completada (`b6b56c6`) · T3 completada (`f31a7e3`) · T4 completada (`0ed771d`). FASE R: **APROBADO CON ADVERTENCIAS**. Sin gates con el titular.
2. **Commits** (`git log 82bcae0..HEAD --oneline`, antes del commit de este log):
   - `9e7b993` chore(encargo): s33e (= `<inicio>`)
   - `b6b56c6` feat(motor): exportacion CSV de la vista historica del panorama (s33e T2, pendiente 4)
   - `f31a7e3` docs(decision): enmienda s33e, exportacion de la vista historica (s33e T3)
   - `0ed771d` build(motor): s33e CSV de la vista historica (motor `977575d193e8207acc7728c8cdcbc909`)
   - (este log: `docs(log): s33e CSV de la vista historica`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/4 (R-08 con la lectura D-2, R-13 = A-2, R-15 = T1 congelada, R-20 = A-1); reparados 0; control positivo: 2 de 2 detectados.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, T1, T2, T4 y la regresión; re-derivado en Python) · 🔒2 PASA (`:root` 65 / `04b2876e…`; hex +0/−0) · 🔒3 PASA (0/0; `const_sg` 1) · 🔒4 PASA (0) · 🔒5 PASA (0) · 🔒6 PASA (los tres CSV byte a byte iguales en M6, T2, T4 y la regresión; `cmp`) · 🔒7 PASA con la lectura D-2 (filas 2.196 / 1.008 / 144 / 298.224, re-derivadas desde el parquet; todas las celdas contra el parquet redondeado; 30 × 7 celdas contra pantalla y parquet con las semillas 3305, 3306 y 3307) · 🔒8 PASA (= M8 en los dos modos).
5. **Decisiones del titular registradas:** ninguna nueva en esta sesión (sin gates). La enmienda de T3 transcribe la decisión que el encargo atribuye a la sesión 33.
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0 (motor `08c22714…`) y en los builds de T1 (`178a218d…`, temporal, no commiteado), T2 (`977575d1…`), T4 y la regresión (`977575d1…`). Motor `08c22714954617d454618a1d647f1be4` → `977575d193e8207acc7728c8cdcbc909`. PRUEBAS d: `ee741cb7be811b029e888d6cbe85fde5` (comparador), `cd5ebb55a2cb02efa5598dd5a6a4f465` (panorama actual), `3b092123be1750d277b91f32ba0a071a` (ficha), iguales en M6, T2, T4 y la regresión.

   | CSV de la vista histórica (15 columnas: `CSV_HIST_COLS`) | establecimientos | filas | md5 |
   |---|---|---|---|
   | SLEP foco, 4° básico, todos los GSE | 61 | 2.196 | `856071a8ffdfc90b3c6226251e44fbef` |
   | SLEP foco, 4° básico, solo `Medio` (`_gse_3`) | 28 | 1.008 | `0f6d00724322768e5a96b59b92f1a466` |
   | comuna de Algarrobo, 2° medio | 4 | 144 | `b79f8be920cdf772e523d0a688bc3215` |
   | Chile, 4° básico (con aviso de `confirmarTamano`) | 8.284 | 298.224 | `33b8d670a401d84c203c6a15b793c71d` |
   | SLEP foco, 4° básico, sin "Sin clasificar" (A-2) | 60 | 2.160 | `b6e9305ac157dcd4c59b332cfd27ae75` |

7. **Dudas y pendientes consolidados:**
   - **D-1 (T1 congelada).** Contexto: a 320 px, "Panorama IDPS por establecimiento" mide 335 px y `.screen-tabs` 296 (281 con ventana); el `onFocus` con `scrollIntoView` que manda el encargo no la deja entera porque es más ancha que la barra. Medido sobre una copia: con `.screen-tab{white-space:normal}` bajo 480 px, la pestaña ocupa 296 de 296 y queda entera; a 390 y 480 px nada cambia. Pregunta: ¿se autoriza, en un encargo nuevo, que el rótulo se parta en dos líneas bajo 480 px (con o sin el `onFocus`)? (sí/no). Bloquea: T1; A-2 de s33d sigue abierto.
   - **D-2 (lectura de 🔒7 ii).** Contexto: el motor lleva `prom = round(prom, 0)` desde s14; el CSV coincide con ese entero en todas las celdas y difiere del `prom` crudo en ≤ 0,5 en las 470 celdas no enteras del caso foco (2.196). Pregunta: ¿"coincide con el `prom` del parquet" se lee contra `round(prom, 0)`? (sí/no). Bloquea: nada si sí; si no, 🔒7 falla por redondeo y T2 debería revisarse.
   - **D-3 (A-2).** Contexto: el sufijo de GSE, como manda el encargo, se arma con `DATA.meta.gse` y no ve "Sin clasificar"; ocultarlo cambia el archivo (60 en vez de 61 establecimientos) sin cambiar el nombre. Pregunta: ¿el nombre del CSV histórico debe marcar "Sin clasificar" oculto? (sí, encargo aparte / no, se acepta). Bloquea: nada.
   - **A-1.** A 390 px, la vista histórica desborda la página 423 px (la tabla `.vt-mx`), igual en el motor de FASE 0: anterior a este encargo. ¿Encargo propio? Bloquea: nada.
   - **Testigo del próximo despliegue:** `grep -c -F 'CSV_HIST_COLS'` → `2` en el motor, `0` en `docs/index.html`. md5 del motor a desplegar: `977575d193e8207acc7728c8cdcbc909` (lleva s33 a s33e).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados** (todos de instrumento o de proceso; ninguno con efecto en el código, las cifras del motor o la conclusión):
   - M4: el `TextDecoder` quitaba el BOM del CSV capturado; corregido antes de las líneas base. Costo: una corrida.
   - T1: `/tmp/s33e_arbol.sh` le pasaba a `sig.sh` un diff viejo de s33c; la medida de 🔒3 de T1 se repitió sobre el diff correcto (0/0). Costo: un comando.
   - T1: H-1 anunció un gate al titular; el encargo ya resolvía el caso por la regla 7 y no lo abrí. Declarado en su lugar.
   - T2: mi verificador comparaba contra el `prom` crudo, no contra el entero que lleva el payload; corregido y repetido con la misma semilla. Costo: una corrida.
   - T3: `git diff -U0 --stat` imprimió el parche; repetí la estadística sin `-U0`. Costo: un comando.
   - FASE R: el re-derivador tomaba la comuna de `establecimientos_chile.parquet` y no con la regla del generador (directorio y, si falta, parquet); corregido y repetido. Costo: una corrida.
   - Errata del log: en la línea de medición del gate de T1 escribí "al final del CSV" por "del CSS" y la corregí con `sed` antes de escribir su `obtenido:` (no tocó ninguna línea `esperado:` ni `obtenido:`).
   - Muestras de 🔒7: en T2 (semilla 3305) y FASE R (3307) la muestra sale de los cuatro indicadores, comparando cada celda con la pantalla con ese indicador visible; la letra de 🔒7 ii ("del indicador visible") se cumple en la muestra de T4 (3306).
9. **Notas para el revisor:**
   - (a) Gate visual: panorama del SLEP foco, **Vista histórica**. El botón "Exportar CSV" está al final del panel de controles, a la derecha. Descargar y abrir en Excel: debe abrir en columnas (`;`), con tildes bien (BOM), una fila por establecimiento, año e indicador, y dos GSE por fila (`gse_ultimo` agrupa; `gse_anio` es el de ese año).
   - (b) Con un solo GSE visible, el nombre lleva `_gse_<código>`; con "Sin clasificar" oculto no cambia (D-3).
   - (c) En Chile, el aviso previo dice 298.224 filas; aceptado, el archivo pesa varios MB.
   - (d) La Vista actual exporta como antes (mismos bytes).
   - (e) Nada se desplegó.
10. **Estado de cierre:** commiteados `9e7b993`, `b6b56c6`, `f31a7e3`, `0ed771d` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33e_priv.sh`, copia del de s33d con la ruta de este log: RUT con el patrón en una variable y control plantado fuera del log; "RBD" seguido de número; términos de establecimiento con su control plantado; nombre de la estación; los patrones viven solo en el script):
```
bash /tmp/s33e_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `nombre plantado: 1`; `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0 (bruto, con los identificadores de acción: 0)`; `nombre plantado: 1`; `estación por nombre: 0`. **Privacidad: PASA.** La estación figura como "estación del titular"; los casos se nombran por territorio y nivel; los archivos de ficha, con `<rbd>`.

Paso 5 (verificación del archivo, después de rellenar el J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_csv_historico_s33e_log.md; ls -l $L | awk "{print \$5}"; wc -l < $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(awk "/^## J/,/^## Registro/" $L | grep -c "^- ")"; bash /tmp/s33e_priv.sh | head -1'
```
esperado: `FASE=7` (FASE 0, T1 a T4, R, L); `esperado` = `obtenido` + 1 al medir (este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `77504` bytes y `429` líneas al medir; `FASE=7 esperado=36 obtenido=35 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **36 = 36** (un `esperado:` por comando, sin anexos de formato).
