# Log de sesión: la vista histórica no desborda la página (s33g)

- **Meta:** que `.vt-scroll` sea el bloque contenedor de sus textos para lector de pantalla (`position:relative`), para que la vista histórica del panorama haga scroll dentro de su matriz sin desplazar la página en pantallas angostas (T1, D-2 de s33f variante (a), A-1 de s33e); regenerar el motor (T2). A 1280 px nada visible cambia (🔒6 con la tolerancia de suavizado calibrada en M7); los lectores de pantalla leen lo mismo; las exportaciones no cambian un byte. Sin despliegue.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `3d17694` (= `origin/main`, `docs(log)` de s33f). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_vista_historica_ancho_s33g.md` (única); `git stash list` vacío; `HEAD=3d17694 origin/main=3d17694`; `HEAD..origin/main=0`, `origin/main..HEAD=0`; motor `bc9a0a391b3814d97fff1b8b2de61d12`, `docs/index.html` `4b28a03fdaa00bd5dbb0a6fc501eab72` (= premisas de §1); la regla `.vt-scroll{overflow-x:auto;…}` sin `position` y `.vt-mx caption,.vt-sr{position:absolute;…}` (= premisas). Primer acto (autorizado): commit `955fbfe` chore(encargo): s33g, hijo de `3d17694` (`1 file changed, 130 insertions(+)`). **PUNTO DE RETORNO `<inicio>` = `955fbfe`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); `bash` 3.2 explícito (toda expresión con `{m,n}` y toda regla CSS con llaves va en un script en `/tmp/s33g_*`); `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`); con ventana, `waitForSelector` visible antes de actuar; a anchos angostos, el motor se abre con el viewport ya en el ancho y se cambia de pantalla y se vuelve (remount); R 4.5.2 con `renv` para el build.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular mandan sobre el modo: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_vista_historica_ancho_s33g.md` (commit `955fbfe`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (position:relative en .vt-scroll)   ALCANCE: 30_procesamiento/35_motor_template.html
T2 (build)                              ALCANCE: 40_salidas/motor_idps.html; requiere T1 completada
Serie: T1 → T2; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33g_*`; los 44 scripts de `/tmp/s33f_*` copiados con las rutas internas, el `<inicio>` (`2d5a1ee` → `955fbfe`) y la ruta del log de privacidad reescritos (medido: 0 restos de `s33f_` y de `2d5a1ee`); PRUEBAS b de s33 usa las copias `/tmp/s33g_s32_*.js` (sin cambios de lógica). Convenciones: **un `esperado:` y un `obtenido:` por comando**; una corrección va como `- **Corrección:** …`; los patrones de privacidad viven solo en su script; **ningún RBD con número, nombre de establecimiento ni fila de CSV en el log** (solo conteos, md5 y nombres de columna).

## J. Juicio (lo rellena FASE L)

- Meta y resultado: con `position:relative` en `.vt-scroll`, la vista histórica ya no desborda la página (de 423 px a 0 a 390 en headless; 0 en 320–412 px en el SLEP foco y en una comuna, salvo el 1,7 px de `.pan-nivel` con ventana a 320, anterior), la matriz conserva su scroll interno y el clic en la fila; a 1280 px nada visible cambia (AE 0 con `-fuzz 5%`).
- Estado por tarea: FASE 0 completada · T1 completada (`7277a7a`) · T2 completada (`36fdd25`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
- Commits: 4, rango `955fbfe`..`<docs(log)>` (`git log --oneline 3d17694..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/2; reparados 0; abiertos 2: H-1 de s33f (decidido "no") y N-1 (la misma familia en la ficha); control positivo 2 de 2.
- Invariantes: 8/8 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒2 `:root` `04b2876e…` y hex +0/−0; 🔒3 0/0; 🔒4 0; 🔒5 0; 🔒6 AE 0, histórica con `-fuzz 5%`; 🔒7 119 textos por DOM y por árbol de accesibilidad; 🔒8 cuatro CSV byte a byte); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, T1, T2 y la regresión, re-derivado en Python; los cuatro CSV idénticos, filas contadas en R).
- Decisiones autónomas de mayor riesgo: (1) `position:relative;` al inicio de la regla (forma del testigo de M8); (2) la celda plantada de M7 inyectada con un script sobre la copia (−20/255 por canal en el fondo); (3) el modo `ax` de 🔒7 lee el nombre accesible de la celda, tras corregir el filtro; (4) el caso de comuna es Algarrobo en 2° medio, el de s33e y s33f.
- Desviaciones respecto del encargo: ninguna en código ni en criterio; `F` se calibró sobre una copia que resultó byte a byte igual al motor de T1 (medido).
- Dudas abiertas: 1: N-1 ¿la decisión "no" sobre D-1 de s33f cubre también los 2 px de `.ficha-tools` con ventana a 320? (sí/no).
- Errores propios: 0 con efecto en código, cifras o conclusión; 3 de instrumento, esperado o comando, corregidos y repetidos (filtro `ax` de 🔒7, esperado de la ficha con ventana, conteo de procesos).
- Qué debe verificar el revisor por sí mismo: en el celular o a 390 px, Vista histórica del SLEP foco: la página no se desplaza hacia el lado y la matriz sí, dentro de su recuadro; el clic en una fila abre la ficha.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `.vt-scroll{position:relative;`: 1 en el motor, 0 en `docs/`; md5 `2a436756f8a4dff35b203b246eb022eb`). La respuesta a N-1.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `955fbfe` (primer acto).

**M1 a M3** (el motor de FASE 0 se guarda en `/tmp/s33g_motor_fase0.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) HEAD~1=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s33g_motor_fase0.html; echo "motor $(md5 -q $M) docs $(md5 -q $R/docs/index.html)"; bash /tmp/s33g_payload_sha.sh /tmp/s33g_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33g_fecha_alterada.js /tmp/s33g_motor_fase0.html /tmp/s33g_motor_fecha.html; bash /tmp/s33g_payload_sha.sh /tmp/s33g_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33g_plantar_payload.js /tmp/s33g_motor_fase0.html /tmp/s33g_motor_plantado.html; bash /tmp/s33g_payload_sha.sh /tmp/s33g_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s33g_root_md5.sh $R/30_procesamiento/35_motor_template.html'
```
esperado: M1 solo este LOG (`?? …_s33g_log.md`), `stash: []`; M2 `fetch rc=0`, `HEAD=955fbfe`, `HEAD~1=3d17694` = `origin/main`, `HEAD..origin/main=0`, `origin/main..HEAD=1`; M3 motor `bc9a0a39…`, `docs` `4b28a03f…`, §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; `:root` `lineas: 65; md5 04b2876e…`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_vista_historica_ancho_s33g_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=955fbfe HEAD~1=3d17694 origin/main=3d17694`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 `motor bc9a0a391b3814d97fff1b8b2de61d12 docs 4b28a03fdaa00bd5dbb0a6fc501eab72`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada → igual, cifra plantada → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. Reglas 1 y 2 no disparan; la calibración de M3 funciona.

**M4 — líneas base de PRUEBAS d y de 🔒7.** PRUEBAS d con `/tmp/s33g_csv.js` (Blob interceptado, BOM conservado; acciones `cmp5`, `ficha`, `pan`, `hist_foco` = los cuatro casos de s33f M6). 🔒7 con el instrumento nuevo `/tmp/s33g_sr.js` en modo `dom` (vista histórica del SLEP foco, 4° básico, 1280 × 800: `textContent` de cada `.vt-mx caption` y de cada `.vt-sr` en orden del documento; la lista queda en `/tmp/s33g_sr_f0_dom.json`, en el log solo conteos y md5; el modo `ax`, que lee el árbol de accesibilidad de Chrome, queda para la re-derivación de FASE R):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33g_csv.js /tmp/s33g_motor_fase0.html f0 cmp5,ficha,pan,hist_foco > /tmp/s33g_m4.json; python3 -c "import json; d=json.load(open(\"/tmp/s33g_m4.json\")); [print(k, d[k].get(\"archivo\"), d[k].get(\"md5\"), d[k].get(\"lineas\"), d[k].get(\"bom\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"cmp5\",\"ficha\",\"pan\",\"hist_foco\")]; print(\"dialogos\", d[\"dialogos\"])"; node /tmp/s33g_sr.js /tmp/s33g_motor_fase0.html f0 dom'
```
esperado: PRUEBAS d = s33f M6: `cmp5` `idps_comparador_4b_2025.csv` `ee741cb7be811b029e888d6cbe85fde5`; `ficha` `idps_ficha_<rbd>_4b.csv` `3b092123be1750d277b91f32ba0a071a`; `pan` `idps_panorama_slep_costa_central_4b_2025.csv` `cd5ebb55a2cb02efa5598dd5a6a4f465`; `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv` `856071a8ffdfc90b3c6226251e44fbef`; todos con BOM; 0 errores, sin diálogos. 🔒7: **119** textos (5 `caption`, uno por grupo, y 114 `.vt-sr`, los de s33f M6b), sus md5 y el primer `caption`; 0 errores.
obtenido: 0 errores, `dialogos []`. `cmp5` `idps_comparador_4b_2025.csv` **`ee741cb7be811b029e888d6cbe85fde5`** (85 líneas, BOM); `ficha` `idps_ficha_<rbd>_4b.csv` **`3b092123be1750d277b91f32ba0a071a`** (92); `pan` `idps_panorama_slep_costa_central_4b_2025.csv` **`cd5ebb55a2cb02efa5598dd5a6a4f465`** (241); `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv` **`856071a8ffdfc90b3c6226251e44fbef`** (2.197): **= s33f M6**. 🔒7: `captions 5`, `vt_sr 114`, **`total 119`**, `sr_distintos 6` (la glosa de estado por año se repite), `md5_lista 4cd99fba9193f75437ffb646db94e20c`, `md5_sr 30dd2c9ed3bd54cbb78a74e29d0f79ea`, `md5_captions fd31d005cd1cb82b9c7465413be7968e`, primer `caption` "Puntaje de cada establecimiento por año en Autoestima Académica y Motivación Escolar, 4° b…"; 0 errores. Líneas base fijadas (T1 no se congela por M4).

**M5 — caso malo de T1** (`/tmp/s33g_vt_ancestros.js`, copia del de s33f M6b: viewport ya en el ancho, Vista histórica, remount; con ventana y headless; SLEP foco en 4° básico y la comuna de Algarrobo en 2° medio, el caso de comuna de s33e y s33f; resumen `/tmp/s33g_vt_resumen.py`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in headless ventana; do node /tmp/s33g_vt_ancestros.js /tmp/s33g_motor_fase0.html 320,360,390,412 $m > /tmp/s33g_m5_foco_$m.json; node /tmp/s33g_vt_ancestros.js /tmp/s33g_motor_fase0.html 320,360,390,412 $m comuna:Algarrobo:2° > /tmp/s33g_m5_comuna_$m.json; done; python3 /tmp/s33g_vt_resumen.py /tmp/s33g_m5_foco_headless.json /tmp/s33g_m5_foco_ventana.json /tmp/s33g_m5_comuna_headless.json /tmp/s33g_m5_comuna_ventana.json | cut -c1-150'
```
esperado: desborde en los 16 casos (`exceso` > 0), **≈ 423 px a 390 en headless** para el SLEP foco (s33f: 423) y ≈ 422 para la comuna; `.vt-scroll` con scroll adentro; 0 errores.
obtenido: 0 errores en las cuatro corridas. **SLEP foco:** headless `exceso 493 / 453 / **423** / 401` a 320 / 360 / 390 / 412 (`scroll 813`); con ventana `508 / 468 / 438 / 416` (`client` 305–397). **Comuna (Algarrobo, 2° medio):** headless `492 / 452 / 422 / 400` (`scroll 812`); con ventana `507 / 467 / 437 / 415`. En los 16 casos `.vt-scroll` hace scroll adentro (`782 >` su `client`) y la página igual desborda. **Caso malo confirmado** (regla 6 no dispara).

**M6 — capturas de referencia de 🔒6** (`/tmp/s33g_captura.js`, copia del de s33f: 1280 × 800, headless, `document.fonts.ready`, ratón fuera, página arriba; `nav.app-nav`, `.wrap` en la vista actual y `.wrap` en la vista histórica del SLEP foco). Dos corridas del mismo motor (`f0`, `f0b`) para confirmar el determinismo, comparadas con `/tmp/s33g_ae.sh`:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33g_captura.js /tmp/s33g_motor_fase0.html f0; node /tmp/s33g_captura.js /tmp/s33g_motor_fase0.html f0b; bash /tmp/s33g_ae.sh f0 f0b'
```
esperado: tres PNG por corrida (`barra 1280x55`, `actual 1200x7261`, `historica 1200x6617`, como en s33f), 0 errores; `f0` frente a `f0b`: AE 0 en las tres.
obtenido: 0 errores; `barra 1280x55`, `actual 1200x7261`, `historica 1200x6617` en las dos corridas; `barra AE=0 (0)`, `actual AE=0 (0)`, `historica AE=0 (0)`. Referencias de 🔒6: `/tmp/s33g_cap_{barra,actual,historica}_f0.png`; el instrumento es determinista.

**M7 — calibración de la tolerancia de 🔒6** (script nuevo `/tmp/s33g_m7.sh`; las reglas con llaves viven en el script por bash 3.2): (1) copia `/tmp/s33g_motor_m7.html` = motor de FASE 0 con **la edición exacta de T1** (el comentario de una línea y `position:relative;` al inicio de la regla `.vt-scroll{…}`), hecha por reemplazo de texto (una ocurrencia); (2) copia `/tmp/s33g_motor_m7p.html` = (1) más un script que, al aparecer la matriz, **oscurece 20/255 por canal el fondo de la primera celda con puntaje** (cambio visible plantado); captura de las dos; AE sin tolerancia de las tres capturas de (1) frente a M6; en la vista histórica, `-fuzz` de 1 % en 1 % hasta el primer `F` con AE = 0; con ese `F`, el plantado frente a M6 y frente a (1).
```
bash /tmp/s33g_m7.sh
```
esperado: `barra` y `actual` de (1) con AE 0 sin tolerancia; `historica` de (1) con AE > 0 sin tolerancia (s33f: 0,15–0,18) y un **`F` ≤ 8 %** con AE = 0 (el suavizado de s33f llega a 15/255 ≈ 5,9 %); la celda plantada se identifica (color original y nuevo, ≈ 62 × 40 px); con `-fuzz F` el plantado da **AE > 0** frente a M6 y frente a (1): la tolerancia separa el suavizado de un cambio visible.
obtenido: `copias: m7 (edición de T1) y m7p (m7 + celda plantada)`; capturas sin errores (`barra 1280x55`, `actual 1200x7261`, `historica 1200x6617`); celda plantada `original rgb(164,179,213) -> rgb(144, 159, 193) 78x53 px`. (1) frente a M6: `barra AE=0 (0)`, `actual AE=0 (0)`, `historica AE=0.184314` (= s33f). Escalera de la vista histórica: `-fuzz 1%` AE 0.108497; `2%` 0.0640523; `3%` 0.0522876; `4%` 0.0196078; **`5%` AE=0** → **`F=5%`**. Plantado: sin tolerancia `AE=298.621`; **con `-fuzz 5%` `AE=296.195` frente a M6 y `296.195` frente a (1)**: detectado. **M7 conforme: `F = 5 %` (≤ 8 %) y el cambio visible plantado sigue detectado con esa tolerancia** (regla 6 no dispara). `F` queda fija para 🔒6 desde aquí.
- **Nota del instrumento (medida):** en ImageMagick 7.1.2 el AE no es un conteo de píxeles: la diferencia entre (1) y el plantado ocupa `bbox=76x51+400+1100` (la celda), con diferencia máxima 20/255 y **3.837 píxeles distintos** medidos con `-compose difference` y umbral, mientras el AE informa 296. Para 🔒6 solo importa el criterio "= 0 / > 0", que el AE separa bien en los dos sentidos.
```
bash -c 'cd /tmp; echo "bbox=$(magick s33g_cap_historica_m7.png s33g_cap_historica_m7p.png -compose difference -composite -threshold 0 -format "%@" info:) max=$(magick s33g_cap_historica_m7.png s33g_cap_historica_m7p.png -compose difference -composite -format "%[fx:maxima*255]" info:) px=$(magick s33g_cap_historica_m7.png s33g_cap_historica_m7p.png -compose difference -composite -separate -evaluate-sequence max -threshold 0 -format "%[fx:mean*w*h]" info:)"; magick -version | head -1'
```
esperado: (propio) recuadro en la celda plantada (≈ 76–78 × 51–53 px), diferencia máxima 20, y el número de píxeles distintos.
obtenido: `bbox=76x51+400+1100 max=20 px=3837`; `Version: ImageMagick 7.1.2-29 Q16-HDRI aarch64`.

**M8 — calibración del testigo de T2** (la forma exacta que toma la edición, medida en la copia de M7: `position:relative;` al inicio de la regla):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; C=".vt-scroll{position:relative;"; echo "testigo docs $(grep -c -F "$C" $R/docs/index.html) motor $(grep -c -F "$C" $R/40_salidas/motor_idps.html) plantilla $(grep -c -F "$C" $R/30_procesamiento/35_motor_template.html) copia_m7 $(grep -c -F "$C" /tmp/s33g_motor_m7.html)"'
```
esperado: `docs 0`, `motor 0`, `plantilla 0`; `copia_m7 1` (el testigo aparece con la edición).
obtenido: `testigo docs 0 motor 0 plantilla 0 copia_m7 1`. **Testigo elegido: `.vt-scroll{position:relative;`.**

- **Estado de FASE 0:** completada. M1–M8 coinciden con su esperado. Reglas 1, 2 y 6 no disparan: el caso malo se reproduce (M5) y la tolerancia separa el suavizado de un cambio visible (M7, `F = 5 %`). Ninguna tarea congelada; sin gates.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `955fbfe` (hijo de `3d17694` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno en FASE 0.

### FASE T1: `.vt-scroll` es el bloque contenedor de sus textos para lector de pantalla

- **Paso 0:** releí M5 (desborde en los 16 casos: 423 px a 390 headless en el SLEP foco, 422 en la comuna, con `.vt-scroll` ya haciendo scroll adentro) y M7 (`F = 5 %`; con la edición, la vista histórica a 1280 da AE 0,18 sin tolerancia y 0 con `-fuzz 5%`; el plantado sigue detectado).
- **Implementación** (§6 T1.2, nada más): antes de la regla `.vt-scroll{…}` (bajo el comentario "Matriz B"), el comentario de una línea del encargo, literal; en la regla, `position:relative;` al inicio. Es la misma edición que se aplicó a la copia de M7.
- **Verificación 1 — árbol y build temporal** (`/tmp/s33g_arbol.sh`, `/tmp/s33g_build.sh`; además, el motor temporal frente a la copia de M7):
```
bash -c 'bash /tmp/s33g_arbol.sh t1; git -C /Users/tomgc/Projects/slep_idps diff -U0 -- 30_procesamiento/35_motor_template.html | grep "^[+-][^+-]" | cut -c1-80; bash /tmp/s33g_build.sh t1; cmp -s /tmp/s33g_motor_t1.html /tmp/s33g_motor_m7.html && echo "motor t1 = copia M7 (byte a byte)" || echo "motor t1 DISTINTO de la copia M7"'
```
esperado: `stat sin commitear: 1 file changed, 2 insertions(+), 1 deletion(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; las 3 líneas: `-` la regla vieja, `+` el comentario, `+` la regla con `position:relative;`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…4dc4`; `:root` `04b2876e…`; y el motor temporal **idéntico** a la copia de M7 (misma edición, misma fecha de build), de modo que la `F` se calibró sobre el mismo archivo.
obtenido: `stat sin commitear:  1 file changed, 2 insertions(+), 1 deletion(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; las tres líneas esperadas (la regla vieja, el comentario `s33g`, la regla con `position:relative;` al inicio); `rc=0 warn=0 pasos_ok=1`; motor temporal `2a436756f8a4dff35b203b246eb022eb`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; **`motor t1 = copia M7 (byte a byte)`**.
- **Verificación 2 — M5 repetido** (mismo instrumento y mismos 16 casos que M5):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in headless ventana; do node /tmp/s33g_vt_ancestros.js /tmp/s33g_motor_t1.html 320,360,390,412 $m > /tmp/s33g_t1_foco_$m.json; node /tmp/s33g_vt_ancestros.js /tmp/s33g_motor_t1.html 320,360,390,412 $m comuna:Algarrobo:2° > /tmp/s33g_t1_comuna_$m.json; done; python3 /tmp/s33g_vt_resumen.py /tmp/s33g_t1_foco_headless.json /tmp/s33g_t1_foco_ventana.json /tmp/s33g_t1_comuna_headless.json /tmp/s33g_t1_comuna_ventana.json | python3 -c "import sys,re; [print(re.sub(r\" \| tabla .*\| fuera:\", \" | fuera:\", l.rstrip())[:230]) for l in sys.stdin]"'
```
esperado: en los 16 casos `scroll` = `client` (`exceso 0`), salvo con ventana a 320 px, donde el exceso (1–2 px) se identifica por elemento como `.pan-nivel` (H-1 de s33f, anterior y registrado); `.vt-scroll` sigue con scroll adentro (`782 >` su `client`); 0 errores.
obtenido: 0 errores en las cuatro corridas. **Headless**, SLEP foco y comuna: `exceso 0` a 320, 360, 390 y 412 (`scroll = inner = client`). **Con ventana**, SLEP foco y comuna: `exceso 0` a 360, 390 y 412; a 320 `scroll 307 client 305 exceso 2`, con **fuera del borde solo `div.pan-nivel`, `div.nivelsel`, `span.nivelsel-lab`, `div.seg-lvl.big` (der = 306,7)**: el segmentador de H-1, identificado por elemento. En los 16 casos `.vt-scroll` sigue con scroll adentro (`782 >` 213–320). El elemento de mayor borde derecho sigue siendo `table.vt-mx` (828), ahora recortado por `.vt-scroll`. **M5 repetido: conforme.**
- **Verificación 3 — clic en una fila, 🔒6 con `F`, 🔒7 y PRUEBAS b** (`/tmp/s33g_clic_fila.js` a 390 y 320 en los dos modos; capturas del motor de T1 frente a M6 con el script nuevo `/tmp/s33g_ae_f.sh`: barra y vista actual con AE sin tolerancia, vista histórica con `-fuzz 5%` y, como registro, sin tolerancia; `/tmp/s33g_sr.js` modo `dom`; PRUEBAS b de s33):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33g_motor_t1.html; for m in headless ventana; do for w in 390 320; do node /tmp/s33g_clic_fila.js $M $w $m; done; done; node /tmp/s33g_captura.js $M t1; bash /tmp/s33g_ae_f.sh f0 t1 5; node /tmp/s33g_sr.js $M t1 dom; cmp -s /tmp/s33g_sr_f0_dom.json /tmp/s33g_sr_t1_dom.json && echo "sr t1 = f0 (lista idéntica)" || echo "sr DISTINTO"; bash /tmp/s33g_pruebas_b.sh $M'
```
esperado: el clic abre la ficha en los cuatro casos (`ficha_visible true`, activa "Panorama IDPS por establecimiento", `scroll = client`, 0 errores); 🔒6 `barra AE=0`, `actual AE=0`, `historica -fuzz 5% AE=0` (sin tolerancia ≈ 0,18, como en M7); 🔒7 `captions 5`, `vt_sr 114`, `total 119`, `md5_lista 4cd99fba…` (= M4) y la lista idéntica; PRUEBAS b `"consola_errores":[] "pageerror":[]`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`.
obtenido: clic → ficha en los cuatro casos: headless 390 `ficha_visible true`, "Panorama IDPS por establecimiento", `scroll 390 client 390`; headless 320 igual con `320/320`; ventana 390 `375/375`; **ventana 320 `scroll 307 client 305`** (la ficha se abre, pero la página de la ficha desborda 2 px: distinto de mi esperado `scroll = client`); 0 errores. 🔒6: `barra: AE=0 (0)`, `actual: AE=0 (0)`, **`historica: -fuzz 5% AE=0 (0)`** (sin tolerancia `0.184314`, = M7). 🔒7: `captions 5`, `vt_sr 114`, `total 119`, `md5_lista 4cd99fba9193f75437ffb646db94e20c`, `md5_sr 30dd2c9e…`, `md5_captions fd31d005…`, **`sr t1 = f0 (lista idéntica)`**. PRUEBAS b: `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`.
- **Identificación de los 2 px de la ficha con ventana a 320** (instrumento nuevo `/tmp/s33g_clic_fuera.js`: tras el clic, elementos de la ficha que pasan el borde sin recorte), en el motor de T1 y en el de FASE 0:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in t1 fase0; do echo "$M $(node /tmp/s33g_clic_fuera.js /tmp/s33g_motor_$M.html 320 ventana)"; done'
```
esperado: (propio) si es el mismo segmentador de H-1 (la ficha tiene su propio `.nivelsel` de nivel), aparece un `.nivelsel`/`.seg-lvl` fuera del borde, igual en FASE 0 y en T1; nada de la matriz.
obtenido: T1 `{"client":305,"scroll":307,"fuera":["div.ficha-tools der=306.7","div.nivelsel der=306.7","span.nivelsel-lab der=306.7","div.seg-lvl.big der=306.7", …(el segundo segmentador)…]}`; FASE 0 **idéntico**. Los 2 px de la ficha con ventana a 320 los ponen los segmentadores de la ficha (`.ficha-tools` con sus dos `.nivelsel`), a 306,7 px, igual que `.pan-nivel` en el panorama: la **misma familia que H-1 de s33f**, anterior a este encargo, nada de la matriz. Queda como **nota N-1** (la decisión del titular sobre D-1 de s33f —no se toca, una ventana de escritorio a 320 px no es uso real— la cubre). El criterio de T1.3 ("el clic en una fila abre la ficha") se cumple en los cuatro casos.
- **Estado de T1:** completada. M5 repetido conforme (0 px de desborde en los 16 casos salvo el de `.pan-nivel` con ventana a 320, identificado por elemento), scroll interno conservado, clic → ficha, 🔒6 con `F = 5 %` (AE 0), 🔒7 idéntico, PRUEBAS b sin errores. Commit con solo la plantilla:
- **Commit:** `7277a7a` fix(motor): la vista historica no desborda la pagina (s33g T1, D-2 de s33f) (`1 file changed, 2 insertions(+), 1 deletion(-)`).

### FASE T2: build

- **Requisito:** T1 completada (`7277a7a`).
- **Paso 1 — porcelain antes del build:**
```
git -C /Users/tomgc/Projects/slep_idps status --porcelain
```
esperado: solo ` M 40_salidas/motor_idps.html` (el build temporal de T1) y `?? …_s33g_log.md`.
obtenido: ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260924_vista_historica_ancho_s33g_log.md`. Conforme; T2 sigue.
- **Paso 2 — build completo (PRUEBAS a), hash y porcelain** (`/tmp/s33g_build.sh t2 completo`: `run_all()` entero desde la raíz):
```
bash -c 'bash /tmp/s33g_build.sh t2 completo; git -C /Users/tomgc/Projects/slep_idps status --porcelain; echo "motor_repo $(md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html)"; echo "warnings_en_log $(grep -ciE warn /tmp/s33g_run_t2.log)"'
```
esperado: `rc=0 warn=0 pasos_ok=5`; motor `2a436756…` (= el temporal de T1: misma plantilla y misma fecha); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `04b2876e…`; porcelain igual al del paso 1; `motor_repo` = `2a436756…`; `warnings_en_log 0`.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `2a436756f8a4dff35b203b246eb022eb` (= T1); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain ` M 40_salidas/motor_idps.html` y `?? …_s33g_log.md` (= paso 1); `motor_repo 2a436756f8a4dff35b203b246eb022eb`; `warnings_en_log 0`.
- **Paso 3 — PRUEBAS b y d, 🔒6, 🔒7 y testigo** (motor commiteable `/tmp/s33g_motor_t2.html`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33g_motor_t2.html; bash /tmp/s33g_pruebas_b.sh $M; node /tmp/s33g_csv.js $M t2 cmp5,ficha,pan,hist_foco > /tmp/s33g_t2.json; python3 -c "import json; d=json.load(open(\"/tmp/s33g_t2.json\")); [print(k, d[k].get(\"archivo\"), d[k].get(\"md5\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"cmp5\",\"ficha\",\"pan\",\"hist_foco\")]"; for k in cmp5 ficha pan hist_foco; do cmp -s /tmp/s33g_csv_f0_$k.csv /tmp/s33g_csv_t2_$k.csv && echo "$k identico a FASE 0" || echo "$k DISTINTO"; done; node /tmp/s33g_captura.js $M t2; bash /tmp/s33g_ae_f.sh f0 t2 5; node /tmp/s33g_sr.js $M t2 dom; cmp -s /tmp/s33g_sr_f0_dom.json /tmp/s33g_sr_t2_dom.json && echo "sr t2 = f0 (lista idéntica)" || echo "sr DISTINTO"; R=/Users/tomgc/Projects/slep_idps; C=".vt-scroll{position:relative;"; echo "testigo motor $(grep -c -F "$C" $R/40_salidas/motor_idps.html) docs $(grep -c -F "$C" $R/docs/index.html)"'
```
esperado: PRUEBAS b sin errores de consola ni `pageerror`, ficha `"errores":[]`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d con los cuatro nombres y md5 de M4 e `identico a FASE 0`; 🔒6 `barra AE=0`, `actual AE=0`, `historica -fuzz 5% AE=0`; 🔒7 `total 119`, `md5_lista 4cd99fba…`, lista idéntica; testigo `motor 1`, `docs 0`; 0 errores.
obtenido: PRUEBAS b `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d `cmp5` `idps_comparador_4b_2025.csv` `ee741cb7…`, `ficha` `idps_ficha_<rbd>_4b.csv` `3b092123…`, `pan` `idps_panorama_slep_costa_central_4b_2025.csv` `cd5ebb55…`, `hist_foco` `idps_panorama_historico_slep_costa_central_4b.csv` `856071a8…`, los cuatro `identico a FASE 0`; 🔒6 `barra: AE=0 (0)`, `actual: AE=0 (0)`, `historica: -fuzz 5% AE=0 (0)` (sin tolerancia `0.184314`); 🔒7 `total 119`, `md5_lista 4cd99fba9193f75437ffb646db94e20c`, `sr t2 = f0 (lista idéntica)`; **testigo `motor 1 docs 0`**; 0 errores.
- **Paso 4 — md5 y commit:** motor `2a436756f8a4dff35b203b246eb022eb`; testigo para el despliegue: `.vt-scroll{position:relative;` (1 en el motor, 0 en `docs/index.html`).
- **Commit:** `36fdd25` build(motor): s33g vista historica sin desborde (`1 file changed, 2 insertions(+), 1 deletion(-)`); porcelain después: `?? …_s33g_log.md` (solo el LOG).
- **Estado de T2:** completada.

### FASE R: auditoría propia y reparación

**Paso 1 — inventario** (derivado del log, antes de auditar):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno: `<inicio>` = `955fbfe`, hijo de `3d17694` = `origin/main`; stash vacío (M1, M2) |
| R-02 | 🔒1: §8.2 `eb4e00b3…4dc4` en FASE 0, T1 y T2; la fecha alterada no lo mueve y la cifra plantada sí (M3) |
| R-03 | 🔒2: `:root` `04b2876e…` (65 líneas); hex agregadas 0 |
| R-04 | 🔒3: `sigdifgru` en líneas cambiadas 0/0; `const sg` 1 |
| R-05 | 🔒4: pipeline de datos intacto |
| R-06 | 🔒5: `docs/` intacto |
| R-07 | 🔒6: barra y vista actual AE 0; vista histórica AE 0 con `-fuzz 5%` (0,18 sin tolerancia), en T1 y T2 |
| R-08 | M7: `F = 5 %` (primer valor con AE 0) y el plantado (celda −20/255, 3.837 píxeles) detectado con esa `F`; el motor de T1 es byte a byte la copia calibrada |
| R-09 | 🔒7: 119 textos (5 `caption` + 114 `.vt-sr`), misma lista en M4, T1 y T2 |
| R-10 | 🔒8 / PRUEBAS d: `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…` con su nombre en M4 y T2 |
| R-11 | M5 (caso malo): desborde en los 16 casos (423 px a 390 headless, SLEP foco; 422, comuna) |
| R-12 | T1.3: 0 px de desborde en los 16 casos salvo `.pan-nivel` con ventana a 320 (H-1); `.vt-scroll` con scroll interno |
| R-13 | T1.3: el clic en una fila abre la ficha (4 casos); N-1: la ficha desborda 2 px con ventana a 320 por `.ficha-tools`, igual en FASE 0 |
| R-14 | T1: la edición es exactamente la del encargo (comentario literal y `position:relative;`), nada más |
| R-15 | T2: PRUEBAS a (`rc=0 warn=0 pasos_ok=5`); motor `2a436756…`; porcelain solo motor y LOG; PRUEBAS b sin errores |
| R-16 | Testigo `.vt-scroll{position:relative;`: 1 en el motor, 0 en `docs/` (M8: 0/0/0) |
| R-17 | Reglas canónicas en las líneas nuevas: sin comentario CSS con `*/` interno, sin hex, sin `text-transform:uppercase` |
| R-18 | Alcance global: commits ⊆ {plantilla, motor} + encargo (`<inicio>`) + LOG; porcelain solo el LOG |

**Paso 2 — re-derivación independiente.**

R-11 y R-12 (desborde): `/tmp/s33g_r_borde.js` (copia del re-derivador de s33f, distinto del de M5: borde derecho **visible** de cada elemento con `getBoundingClientRect().right`, recortado por las cajas con `overflow-x` no visible de su cadena de **bloques contenedores**), ancho nuevo **400 px** y 320, vista histórica y vista actual, dos modos; motor de `HEAD` (`/tmp/s33g_motor_t2.html` = `2a436756…`) y, de contraste, el de FASE 0 en la vista histórica:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in t2 fase0; do for v in historica actual; do [ $M = fase0 ] && [ $v = actual ] && continue; for m in headless ventana; do node /tmp/s33g_r_borde.js /tmp/s33g_motor_$M.html 320,400 $v $m | python3 -c "import json,sys; d=json.load(sys.stdin); [print(d[\"motor\"], d[\"vista\"], d[\"modo\"], m[\"ancho\"], \"client\", m[\"clientWidth\"], \"mas_derecho\", m[\"visible_mas_derecho\"], m[\"borde\"], \"exceso\", m[\"exceso_visible\"], \"n_fuera\", m[\"n_fuera\"], m[\"fuera\"][:2], \"scrollWidth\", m[\"scrollWidth\"], \"err\", len(d[\"errores\"])) for m in d[\"medidas\"]]"; done; done; done'
```
esperado: **`HEAD`**, vista histórica y vista actual: `exceso` ≤ 0 y `n_fuera 0` a 400 (dos modos) y a 320 headless; con ventana a 320, solo `.pan-nivel` (≈ 1,7 px); en ningún caso un `.vt-sr` ni el `caption` como elemento visible más a la derecha. **FASE 0**, vista histórica: `span.vt-sr` en 813 como elemento visible más a la derecha y exceso ≈ 813 − `client` (s33f: 413 a 400 headless).
obtenido: 0 errores. **`HEAD`, vista histórica:** headless 320 `mas_derecho header.app 320 exceso 0 n_fuera 0 scrollWidth 320`; headless 400 `exceso 0 n_fuera 0 scrollWidth 400`; ventana 400 `exceso 0 n_fuera 0 scrollWidth 385`; ventana 320 `mas_derecho div.pan-nivel 306.7 exceso 1.7 n_fuera 4` (`.pan-nivel`, `.nivelsel`, …), `scrollWidth 307`. **`HEAD`, vista actual:** lo mismo (`exceso 0` salvo `.pan-nivel` con ventana a 320). **FASE 0, vista histórica:** `mas_derecho span.vt-sr 813`, exceso `493` / `413` (headless 320 / 400) y `508` / `428` (ventana), `n_fuera 114` (118 con `.pan-nivel` a 320 ventana). **R-11 y R-12 re-derivados**, también a 400 px: con `position:relative` ningún `.vt-sr` queda visible fuera del borde; sin él, los 114 salen hasta 813.

R-09 (🔒7) por la otra vía de lectura: `/tmp/s33g_sr.js` en modo **`ax`** (árbol de accesibilidad de Chrome por CDP `Accessibility.getFullAXTree`: nombres de las tablas —el `caption` da nombre a la tabla— y nodos `StaticText` con la forma de un `.vt-sr`, ", … en AAAA"), sobre FASE 0 y `HEAD`, más la comparación con la lista del modo `dom`:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in fase0 t2; do node /tmp/s33g_sr.js /tmp/s33g_motor_$M.html r$M ax; done; cmp -s /tmp/s33g_sr_rfase0_ax.json /tmp/s33g_sr_rt2_ax.json && echo "ax HEAD = ax FASE 0 (lista idéntica)" || echo "ax DISTINTO"; python3 -c "import json; a=json.load(open(\"/tmp/s33g_sr_rt2_ax.json\")); d=json.load(open(\"/tmp/s33g_sr_t2_dom.json\")); print(\"ax = dom:\", \"captions\", a[\"captions\"]==d[\"captions\"], \"srs\", a[\"srs\"]==[s for s in d[\"srs\"]], \"| srs como multiconjunto\", sorted(a[\"srs\"])==sorted(d[\"srs\"]))"'
```
esperado: en los dos motores `captions 5`, `vt_sr 114`, `total 119` leídos del árbol de accesibilidad; la lista `ax` de `HEAD` idéntica a la de FASE 0; y `ax = dom` (mismos textos que el `textContent` de M4/T2; el orden puede diferir si el árbol ordena distinto, por eso también como multiconjunto); 0 errores.
obtenido: los dos motores `captions 5`, **`vt_sr 0`**, `total 5`, `md5_captions fd31d005…` (= M4); `ax HEAD = ax FASE 0 (lista idéntica)`; `ax = dom: captions True srs False | srs como multiconjunto False`. Los 5 `caption` coinciden con el DOM; los `.vt-sr` no se encontraron **en ninguno de los dos motores**: falla del instrumento, no del motor.
- **Corrección (error del instrumento, modo `ax`):** depuré el árbol (volcado de nodos `StaticText` y `cell`): React parte el texto del `.vt-sr` (`", " + glosa + " en " + año`) en varios nodos de texto y Chrome los expone como `StaticText` separados, así que ninguno tiene la forma completa ", … en AAAA" que buscaba el filtro. Lo que el lector anuncia es el **nombre accesible de la celda** (p. ej. "77 , Sin diferencia significativa con su GSE en 2024"). El modo `ax` pasa a leer, de cada nodo `cell` no ignorado, la cola ", … en AAAA" de su nombre. Repito el mismo comando:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for M in fase0 t2; do node /tmp/s33g_sr.js /tmp/s33g_motor_$M.html r$M ax; done; cmp -s /tmp/s33g_sr_rfase0_ax.json /tmp/s33g_sr_rt2_ax.json && echo "ax HEAD = ax FASE 0 (lista idéntica)" || echo "ax DISTINTO"; python3 -c "import json; a=json.load(open(\"/tmp/s33g_sr_rt2_ax.json\")); d=json.load(open(\"/tmp/s33g_sr_t2_dom.json\")); print(\"ax = dom:\", \"captions\", a[\"captions\"]==d[\"captions\"], \"srs\", a[\"srs\"]==[s for s in d[\"srs\"]], \"| srs como multiconjunto\", sorted(a[\"srs\"])==sorted(d[\"srs\"]))"'
```
esperado: en los dos motores `captions 5`, `vt_sr 114`, `total 119` desde el árbol de accesibilidad; `ax HEAD = ax FASE 0`; `ax = dom` en `captions` y en `srs` (orden y multiconjunto); 0 errores.
obtenido: FASE 0 y `HEAD` desde el árbol de accesibilidad: `captions 5`, **`vt_sr 114`**, **`total 119`**, `sr_distintos 6`, `md5_lista 4cd99fba9193f75437ffb646db94e20c`, `md5_sr 30dd2c9e…`, `md5_captions fd31d005…` (**= los md5 del modo `dom` en M4, T1 y T2**); `ax HEAD = ax FASE 0 (lista idéntica)`; `ax = dom: captions True srs True | srs como multiconjunto True`; 0 errores. **R-09 re-derivado por la otra vía de lectura:** los 119 textos siguen en el árbol de accesibilidad, con el mismo texto y el mismo orden.

**Paso 3 — invariantes** (sobre `HEAD` y el motor versionado; 🔒1 y 🔒2 con los re-derivadores en Python; 🔒6 con otro método que el AE: firma de píxeles en barra y vista actual y, en la vista histórica, la **distancia RMS por píxel** entre las dos capturas —máximo, en % de la escala— más la diferencia máxima por canal y el número de píxeles distintos; 🔒7 ya re-derivado arriba; 🔒8 con `cmp` y filas contadas en R):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=955fbfe; M=$R/40_salidas/motor_idps.html; T=$R/30_procesamiento/35_motor_template.html; echo "1 $(python3 /tmp/s33g_r_payload.py $M | cut -c1-200)"; echo "2 root $(python3 /tmp/s33g_r_root.py $T) ; $(bash /tmp/s33g_hex.sh | head -1)"; echo "3 $(bash /tmp/s33g_sig.sh | head -1)"; echo "4 $(git -C $R diff $I..HEAD -- 10_utils 20_insumos 30_procesamiento/31* 30_procesamiento/32* 30_procesamiento/33* 30_procesamiento/34* 30_procesamiento/35_generar_motor_html.R | wc -l | tr -d " ")"; echo "5 $(git -C $R diff --name-only $I..HEAD -- docs | wc -l | tr -d " ")"; cd /tmp; for k in barra actual; do a=$(magick identify -format "%#" s33g_cap_${k}_f0.png); b=$(magick identify -format "%#" s33g_cap_${k}_t2.png); [ "$a" = "$b" ] && echo "6 $k firma igual ${a:0:12}" || echo "6 $k firma DISTINTA"; done; echo "6 historica rms_max=$(magick s33g_cap_historica_f0.png s33g_cap_historica_t2.png -compose difference -composite -evaluate pow 2 -separate -evaluate-sequence mean -evaluate pow 0.5 -format "%[fx:maxima*100]" info:)% canal_max=$(magick s33g_cap_historica_f0.png s33g_cap_historica_t2.png -compose difference -composite -format "%[fx:maxima*255]" info:)/255 px=$(magick s33g_cap_historica_f0.png s33g_cap_historica_t2.png -compose difference -composite -separate -evaluate-sequence max -threshold 0 -format "%[fx:mean*w*h]" info:) | plantado rms_max=$(magick s33g_cap_historica_m7.png s33g_cap_historica_m7p.png -compose difference -composite -evaluate pow 2 -separate -evaluate-sequence mean -evaluate pow 0.5 -format "%[fx:maxima*100]" info:)%"; for k in cmp5 ficha pan hist_foco; do cmp -s /tmp/s33g_csv_f0_$k.csv /tmp/s33g_csv_t2_$k.csv && echo "8 $k identico (cmp) $(md5 -q /tmp/s33g_csv_t2_$k.csv)" || echo "8 $k DISTINTO"; done; cd $R && Rscript /tmp/s33g_csv_contar.R /tmp/s33g_csv_t2_cmp5.csv /tmp/s33g_csv_t2_ficha.csv /tmp/s33g_csv_t2_pan.csv /tmp/s33g_csv_t2_hist_foco.csv 2>&1 | grep -v renv | cut -c1-50'
```
esperado: 1 `motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1`; 2 `lineas=65 md5=04b2876e…`, `hex agregadas=0 borradas=0`; 3 `sigdifgru borradas=0 agregadas=0 const_sg=1`; 4 `0`; 5 `0`; 6 firmas iguales en barra y vista actual; en la vista histórica `rms_max` **< 5 %** (por eso AE 0 con `-fuzz 5%`) con `canal_max` ≈ 15/255 y unas decenas de píxeles, y el plantado con `rms_max` > 5 % (≈ 7,8 %: 20/255 en los tres canales); 8 los cuatro CSV idénticos, con 84, 91, 240 y 2.196 filas en R.
obtenido: `1 motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1 bytes=59467463`; `2 root 35_motor_template.html lineas=65 md5=04b2876e2bcece41f09398f28f6fc41d ; hex agregadas=0 borradas=0`; `3 sigdifgru borradas=0 agregadas=0 const_sg=1`; `4 0`; `5 0`; `6 barra firma igual 91a89972b1a8`, `6 actual firma igual 0bb6242e44f1`, **`6 historica rms_max=4.69498% canal_max=15/255 px=29 | plantado rms_max=7.84314%`**; `8 cmp5 identico (cmp) ee741cb7…`, `8 ficha … 3b092123…`, `8 pan … cd5ebb55…`, `8 hist_foco … 856071a8…`; en R `84 | 23`, `91 | 10`, `240 | 13`, `2196 | 15`. **🔒1 a 🔒8 PASAN** sobre el estado final. La distancia RMS re-deriva la calibración de M7 por otro camino: el suavizado máximo (4,69 %) queda bajo `F = 5 %` y sobre 4 % (por eso la escalera dio AE > 0 en 4 % y 0 en 5 %), y el cambio plantado (7,84 %) queda sobre `F`.

**Paso 4 — alcance global y reglas canónicas** (R-14, R-17, R-18):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; I=955fbfe; T=$R/30_procesamiento/35_motor_template.html; git -C $R diff --name-only $I..HEAD; git -C $R status --porcelain; D=$(git -C $R diff -U0 $I..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^[+-][^+-]"); echo "cambiadas $(printf "%s\n" "$D" | wc -l | tr -d " ") agregadas $(printf "%s\n" "$D" | grep -c "^+") borradas $(printf "%s\n" "$D" | grep -c "^-")"; A=$(printf "%s\n" "$D" | grep "^+"); echo "css_cierre_interno $(printf "%s\n" "$A" | grep -F "/*" | grep -c -E "\*/.+\*/")"; echo "uppercase $(printf "%s\n" "$A" | grep -c -i "text-transform")"; echo "comentario_literal $(grep -c -F "  /* s33g: position relative hace que el overflow de .vt-scroll recorte los .vt-sr absolutos (A-1 de s33e, D-2 de s33f). */" $T)"; echo "regla $(grep -c -F ".vt-scroll{position:relative;overflow-x:auto;border:1px solid var(--linea);border-radius:var(--radius-2);background:var(--paper);}" $T)"; echo "vt_sr_intacta $(grep -c -F ".vt-mx caption,.vt-sr{position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0 0 0 0);white-space:nowrap;}" $T)"'
```
esperado: `git diff --name-only 955fbfe..HEAD` = `30_procesamiento/35_motor_template.html` y `40_salidas/motor_idps.html` (⊆ ALCANCE; el encargo es `<inicio>`, el LOG va en FASE L); porcelain = solo el LOG; `cambiadas 3 agregadas 2 borradas 1`; `css_cierre_interno 0`; `uppercase 0`; `comentario_literal 1`; `regla 1`; `vt_sr_intacta 1` (la regla de los textos para lector no se tocó).
obtenido: `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html` (⊆ ALCANCE); porcelain `?? 50_documentacion/andamios/logs/20260924_vista_historica_ancho_s33g_log.md` (solo el LOG); `cambiadas 3 agregadas 2 borradas 1`; `css_cierre_interno 0`; `uppercase 0`; `comentario_literal 1`; `regla 1`; `vt_sr_intacta 1`. **R-14, R-17 y R-18 conformes.**

**Paso 5 — regresión completa sobre el estado final** (PRUEBAS a con `run_all()` entero; c; b; d):
```
bash -c 'bash /tmp/s33g_build.sh r completo; git -C /Users/tomgc/Projects/slep_idps status --porcelain; bash /tmp/s33g_pruebas_b.sh /tmp/s33g_motor_r.html; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33g_csv.js /tmp/s33g_motor_r.html r cmp5,ficha,pan,hist_foco | python3 -c "import json,sys; d=json.load(sys.stdin); [print(k, d[k].get(\"archivo\"), d[k].get(\"md5\"), len(d[k].get(\"errores\",[])), d[k].get(\"error\")) for k in (\"cmp5\",\"ficha\",\"pan\",\"hist_foco\")]"'
```
esperado: PRUEBAS a `rc=0 warn=0 pasos_ok=5`, motor `2a436756…` (= `HEAD`), porcelain solo el LOG; PRUEBAS c §8.2 `eb4e00b3…`; `:root` `04b2876e…`; PRUEBAS b sin errores; PRUEBAS d `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…` con sus nombres; 0 errores.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `2a436756f8a4dff35b203b246eb022eb` (= `HEAD`); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain `?? …_s33g_log.md` (solo el LOG); PRUEBAS b `"modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`, ficha `"errores":[] "glosa_existe":true`, comparación `"errores":[] "desbordadas":0`; PRUEBAS d `ee741cb7…`, `3b092123…`, `cd5ebb55…`, `856071a8…` con sus nombres; 0 errores. **PRUEBAS a, b, c y d conformes sobre el estado final.**

**Paso 6 — control positivo** (`/tmp/s33g_control.sh`, fuera del árbol, sobre copias del motor de `HEAD`: (1) sin `position:relative` en `.vt-scroll`, re-derivado con `r_borde.js` a 400 px en la vista histórica; (2) con los `.vt-sr` y el `caption` en `display:none`, re-derivado con `sr.js` en modo `ax`):
```
bash /tmp/s33g_control.sh
```
esperado: (1) el desborde vuelve: `span.vt-sr` en 813 como elemento visible más a la derecha, exceso 413, `n_fuera 114`; (2) el árbol de accesibilidad deja de tener los textos: `captions 0` (sin `caption`, la tabla pierde ese nombre) y `vt_sr 0`, `total 0`: el instrumento de 🔒7 detecta textos que salen del árbol.
obtenido: `plantados: sinpos y srnone`; `(1) mas_derecho span.vt-sr 813 exceso 413 n_fuera 114 scrollWidth 813` (**detectado**: sin la declaración, el desborde vuelve); `(2) {… "modo":"ax","captions":0,"vt_sr":0,"total":0, … "errores":0}` (**detectado**). Los dos re-derivadores fallan donde deben.

**Pasos 7 y 10 — tabla y veredicto:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno `955fbfe` | `git diff --name-only 955fbfe..HEAD` (paso 4) | 2 rutas del ALCANCE | 2 rutas del ALCANCE | — | ninguna | — | — |
| R-02 | 🔒1 §8.2 | `r_payload.py` (Python) sobre `HEAD` | `eb4e00b3…` | `eb4e00b3…` | PASA | ninguna | — | build `r` = `eb4e00b3…` |
| R-03 | 🔒2 paletas y hex | `r_root.py`; `hex.sh` sobre `955fbfe..HEAD` | `04b2876e…`; 0 | `04b2876e…`; `0/0` | PASA | ninguna | — | — |
| R-04 | 🔒3 `sigdifgru` | `sig.sh` sobre `955fbfe..HEAD` | 0/0, `const_sg=1` | 0/0, 1 | PASA | ninguna | — | — |
| R-05 | 🔒4 pipeline | `git diff … \| wc -l` | 0 | 0 | PASA | ninguna | — | — |
| R-06 | 🔒5 `docs/` | `git diff --name-only … -- docs` | 0 | 0 | PASA | ninguna | — | — |
| R-07 | 🔒6 a 1280 | firma de píxeles (barra, actual); distancia RMS por píxel (histórica) | iguales; < 5 % | iguales; 4,69 % | PASA | ninguna | — | plantado 7,84 % |
| R-08 | M7: `F = 5 %` separa suavizado de cambio visible | distancia RMS (otro método que el AE con `-fuzz`) | suavizado < F < plantado | 4,69 % < 5 % < 7,84 % | PASA | ninguna | — | — |
| R-09 | 🔒7 119 textos | `sr.js` modo `ax` (árbol de accesibilidad), FASE 0 y `HEAD` | 119, = `dom` | 119, = `dom`, = FASE 0 (tras corregir el instrumento) | PASA | ninguna | — | control (2) |
| R-10 | 🔒8 / PRUEBAS d | `cmp` + `md5`; filas en R | idénticos; 84/91/240/2.196 | idénticos; 84/91/240/2.196 | PASA | ninguna | — | build `r` |
| R-11 | M5 caso malo | `r_borde.js` FASE 0, 320 y 400 | `span.vt-sr` en 813 | 813; exceso 493/413 (headless) | PASA | ninguna | — | — |
| R-12 | T1.3 sin desborde | `r_borde.js` `HEAD`, 320 y **400**, dos vistas, dos modos | exceso 0 salvo `.pan-nivel` (ventana 320) | así | PASA; ADVIERTE H-1 (anterior, decisión D-1 de s33f: no) | registro | — | control (1) |
| R-13 | T1.3 clic → ficha | `clic_fila.js` (4 casos); `clic_fuera.js` | ficha abierta | abierta; N-1: `.ficha-tools` 2 px con ventana a 320, igual en FASE 0 | PASA; ADVIERTE N-1 | registro | — | — |
| R-14 | T1 edición literal | `grep -F` comentario, regla y `.vt-sr` | 1, 1, 1 | 1, 1, 1 | PASA | ninguna | — | — |
| R-15 | T2 build y PRUEBAS b | build `r` completo | `2a436756…`; solo LOG; sin errores | igual | PASA | ninguna | — | — |
| R-16 | testigo | `grep -c -F` (T2) | motor ≥ 1, docs 0 | 1, 0 | PASA | ninguna | — | M8 |
| R-17 | reglas canónicas | `grep` sobre las líneas agregadas | 0/0 | 0/0 | PASA | ninguna | — | — |
| R-18 | alcance global | `git diff --name-only`; porcelain | ⊆ ALCANCE; solo LOG | ⊆; solo LOG | PASA | ninguna | — | — |

- **Control positivo:** dos casos plantados fuera del árbol (sin `position:relative`: el desborde vuelve; textos en `display:none`: salen del árbol de accesibilidad), detectados; más la calibración de M3 (cifra plantada) y de M7 (celda plantada).
- Ningún hallazgo BLOQUEA; ninguno pide REPARA; 0 ciclos de reparación, 0 commits `fix(auditoria)`. ADVIERTE: R-12 (H-1, ya decidido por el titular: no se toca) y R-13 (N-1, la misma familia en la ficha).
- **Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (B/R/A = 0/0/2).

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R status -sb | head -1; git -C $R log --oneline 3d17694..HEAD; pgrep -fl "s33g|node /tmp|Rscript" | grep -v pgrep | wc -l | tr -d " "'
```
esperado: solo este LOG; `main` adelantada 3 respecto de `origin/main`; commits `955fbfe`, `7277a7a`, `36fdd25`; `0` procesos de instrumentos vivos (ningún shell en segundo plano en esta sesión).
obtenido: `?? 50_documentacion/andamios/logs/20260924_vista_historica_ancho_s33g_log.md` (única); `## main...origin/main [ahead 3]`; `36fdd25`, `7277a7a`, `955fbfe`; el conteo de procesos dio **`3`**, distinto de mi esperado.
- **Corrección (conteo de procesos):** el patrón `s33g|node /tmp|Rscript` calza con la propia línea de comando del shell que mide (contiene el patrón). Re-medí con `pgrep -fl "node /tmp/s33|Rscript|Chrome for Testing"` y `ps … | grep -E "node /tmp/s33|Rscript -e"`: **ningún `node /tmp/s33*` ni `Rscript -e` de esta sesión**; sí aparecen procesos **de otras sesiones y otros repositorios** del titular (un Chrome for Testing de Puppeteer —mis instrumentos usan el Chrome del sistema— y dos `Rscript` de otros proyectos), que no son de este encargo y no se tocan. En esta sesión no quedó ningún shell en segundo plano (ninguno se lanzó).
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33g (una declaración CSS para que la vista histórica no desborde la página, y build). Fases: FASE 0, T1, T2, R y L. Estado del grafo: T1 completada (`7277a7a`) · T2 completada (`36fdd25`). FASE R: **APROBADO CON ADVERTENCIAS**. Sin gates con el titular.
2. **Commits** (`git log 3d17694..HEAD --oneline`, antes del commit de este log):
   - `955fbfe` chore(encargo): s33g (= `<inicio>`)
   - `7277a7a` fix(motor): la vista historica no desborda la pagina (s33g T1, D-2 de s33f)
   - `36fdd25` build(motor): s33g vista historica sin desborde (motor `2a436756f8a4dff35b203b246eb022eb`)
   - (este log: `docs(log): s33g vista historica sin desborde`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/2 (R-12 = H-1 de s33f, decidido "no"; R-13 = N-1); reparados 0; control positivo: 2 de 2 detectados.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, T1, T2 y la regresión; re-derivado en Python) · 🔒2 PASA (`:root` 65 / `04b2876e…`; hex +0/−0) · 🔒3 PASA (0/0; `const_sg` 1) · 🔒4 PASA (0) · 🔒5 PASA (0) · 🔒6 PASA (barra y vista actual AE 0 y firma de píxeles igual; vista histórica AE 0 con `-fuzz 5%`, distancia RMS máxima 4,69 %) · 🔒7 PASA (119 textos, misma lista por `textContent` y por el árbol de accesibilidad, en FASE 0, T1 y T2) · 🔒8 PASA (cuatro CSV byte a byte en M4, T2 y la regresión).
5. **Decisiones del titular registradas** (del encargo, sesión 33, criterio delegado al redactor): **D-2 de s33f → sí, variante (a)** (`.vt-scroll{position:relative;}`, con 🔒6 leído con la tolerancia de M7): implementada en T1. **D-1 de s33f → no** (el 1,7 px de `.pan-nivel` con ventana de escritorio a 320 px no se toca). Ninguna decisión nueva en esta sesión.
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0 (motor `bc9a0a39…`) y en los builds de T1 (`2a436756…`, temporal = la copia calibrada de M7), T2 y la regresión (`2a436756…`). Motor `bc9a0a391b3814d97fff1b8b2de61d12` → `2a436756f8a4dff35b203b246eb022eb`. **`F` calibrada: 5 %** (suavizado máximo 4,69 % RMS, 15/255 en un canal, 29 píxeles; plantado 7,84 %).

   | vista histórica, exceso de página (px) | 320 | 360 | 390 | 400 (R) | 412 |
   |---|---|---|---|---|---|
   | SLEP foco, headless, antes → después | 493 → 0 | 453 → 0 | 423 → 0 | 413 → 0 | 401 → 0 |
   | SLEP foco, ventana, antes → después | 508 → 2 (`.pan-nivel`) | 468 → 0 | 438 → 0 | 428 → 0 | 416 → 0 |
   | comuna (Algarrobo, 2° medio), headless | 492 → 0 | 452 → 0 | 422 → 0 | — | 400 → 0 |
   | comuna, ventana | 507 → 2 (`.pan-nivel`) | 467 → 0 | 437 → 0 | — | 415 → 0 |

   PRUEBAS d (sin cambio): comparador `ee741cb7be811b029e888d6cbe85fde5`, ficha `3b092123be1750d277b91f32ba0a071a`, panorama actual `cd5ebb55a2cb02efa5598dd5a6a4f465`, histórico del SLEP foco `856071a8ffdfc90b3c6226251e44fbef`.
7. **Dudas y pendientes consolidados:**
   - **N-1 (la misma familia de H-1 en la ficha).** Contexto: con ventana de escritorio a 320 px, la ficha de establecimiento también desborda 2 px, por los segmentadores de `.ficha-tools` (306,7 px frente a 305 útiles), igual en FASE 0; un celular no lo muestra. Pregunta: ¿la decisión "no" sobre D-1 de s33f cubre también la ficha? (sí/no). Bloquea: nada.
   - **Testigo del próximo despliegue:** `grep -c -F '.vt-scroll{position:relative;'` → `1` en el motor, `0` en `docs/index.html`. md5 del motor a desplegar: `2a436756f8a4dff35b203b246eb022eb` (lleva s33 a s33g).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados** (ninguno con efecto en el código, las cifras del motor o la conclusión):
   - FASE R, 🔒7 por el árbol de accesibilidad: el filtro buscaba el `.vt-sr` como un solo nodo `StaticText`, y React lo parte en varios; dio 0 en los dos motores. Corregido (el texto se lee del nombre accesible de la celda) y repetido. Costo: una corrida y un volcado de depuración.
   - FASE R: mi esperado de la verificación 3 de T1 daba `scroll = client` también en la ficha con ventana a 320; los 2 px de `.ficha-tools` (N-1) son anteriores. Costo: una medición.
   - FASE L: el conteo de procesos se contó a sí mismo (el patrón vivía en la línea de comando); re-medido con otro patrón. Costo: un comando.
9. **Notas para el revisor:**
   - (a) Gate visual en un celular o una ventana a 390 px: Panorama, **Vista histórica** del SLEP foco. La página ya no se desplaza hacia el lado; la matriz sí, dentro de su recuadro, con la primera columna fija.
   - (b) El clic en una fila sigue abriendo la ficha.
   - (c) A 1280 px la vista histórica se ve igual (la diferencia medida es de suavizado, invisible: hasta 15/255 en 29 píxeles).
   - (d) Con un lector de pantalla, cada celda sigue anunciando su estado ("…, bajo su GSE en 2024").
   - (e) Nada se desplegó.
10. **Estado de cierre:** commiteados `955fbfe`, `7277a7a`, `36fdd25` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33g_priv.sh`, copia del de s33f con la ruta de este log; los patrones viven solo en el script):
```
bash /tmp/s33g_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `nombre plantado: 1`; `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0 (bruto, con los identificadores de acción: 0)`; `nombre plantado: 1`; `estación por nombre: 0`. **Privacidad: PASA.** La estación figura como "estación del titular"; los casos se nombran por territorio y nivel; los archivos de ficha, con `<rbd>`.

Paso 5 (verificación del archivo, después de rellenar el J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_vista_historica_ancho_s33g_log.md; ls -l $L | awk "{print \$5}"; wc -l < $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(awk "/^## J/,/^## Registro/" $L | grep -c "^- ")"; bash /tmp/s33g_priv.sh | head -1'
```
esperado: `FASE=5` (FASE 0, T1, T2, R, L); `esperado` = `obtenido` + 1 al medir (este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `57464` bytes y `316` líneas al medir; `FASE=5 esperado=24 obtenido=23 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **24 = 24** (un `esperado:` por comando, sin anexos de formato).
