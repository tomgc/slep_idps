# Log de sesión: limpieza de código sin uso y destino de respaldo del foco (s33)

- **Meta:** retirar `_txtOn` (T1, D-1 de s32g) y `const col` del tooltip (T2, A-3 de s32g), sin cambio visible; que el foco caiga en un respaldo visible y con sentido cuando el botón que abrió el modal ya no existe al cerrarlo (T4, A-1 de s32e); poner al día el encabezado de §5 y el estado de la decisión de contraste (T3, A-1 de s32g); regenerar el motor (T5). Sin despliegue.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `d046c9c` (= `origin/main`, commit de `/apertura`). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_limpieza_foco_respaldo_s33.md` (única); `git stash list` vacío; `HEAD=d046c9c origin/main=d046c9c`; `HEAD..origin/main=0`, `origin/main..HEAD=0`. Primer acto (autorizado): commit `24087e1` chore(encargo): s33, hijo de `d046c9c`. **PUNTO DE RETORNO `<inicio>` = `24087e1`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script en `/tmp/s33_*`); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`); pruebas de foco **con ventana** (`headless: false`) y en headless.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular fijan subagentes 0: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_limpieza_foco_respaldo_s33.md` (commit `24087e1`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (retirar _txtOn)                 ALCANCE: 30_procesamiento/35_motor_template.html
T2 (retirar const col)              ALCANCE: 30_procesamiento/35_motor_template.html; en serie después de T1
T4 (destino de respaldo del foco)   ALCANCE: 30_procesamiento/35_motor_template.html; en serie después de T2
T3 (encabezado de la decisión)      ALCANCE: 50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md
T5 (build)                          ALCANCE: 40_salidas/motor_idps.html; requiere al menos una de T1, T2 o T4
Orden: T1 → T2 → T4 → T3 → T5; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33_*`; se copian de los de s32e y s32g cuando sirven (siguen en `/tmp`).

## J. Juicio (lo rellena FASE L)

- Meta y resultado: `_txtOn` y `const col` retirados sin cambio visible (`DistBar` y tooltips idénticos a la línea base); cuando el botón que abrió el modal ya no existe, el foco queda en el contador del comparador (`.cmp-cl`) o en el nombre de la ficha (`.ficha-name`), no en `BODY` (con ventana y headless); encabezado de §5 y Estado de la decisión al día → cumplida.
- Estado por tarea: FASE 0 completada · T1 completada (`6025d20`) · T2 completada (`1fbc9d1`) · T4 completada (`f58761c`) · T3 completada (`b1dafe4`) · T5 completada (`f4ad2e0`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 7, rango `24087e1`..`<docs(log)>` (`git log --oneline d046c9c..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/3; reparados 0; abiertos 3 (A-1 el paso 1 de T5 pedía porcelain "vacío", inalcanzable; A-2 el anillo de `.ficha-name` da 1,84:1 sobre la barra de la ficha; A-3 sin anillo tras cerrar con clic).
- Invariantes: 6/6 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒2 `:root` `04b2876e…` y hex +0/−1; 🔒3 `sigdifgru` −1 = `const col`, +0; 🔒4 0; 🔒5 0; 🔒6 = M8 con ventana y headless); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, T1, T2, T4, T5 y la regresión, re-derivado en Python; `run_all()` completo con el árbol limpio salvo el motor).
- Decisiones autónomas de mayor riesgo: (1) D-A1: el descarte de la autorrepetición de Enter/Espacio (R-11 de s32e) se aplica al destino del foco, sea origen o respaldo; sin él, Enter sostenido sobre Listo reabría el modal desde `.cmp-add` (control plantado); (2) T5.1 se midió como "solo el motor y el LOG"; (3) M9 toma el punto con `sigdifgru` −1 de la fila 29 del roster, porque la ficha fija no tenía ninguno.
- Desviaciones respecto del encargo: T5.1 (porcelain con motor y LOG, por construcción) y D-A1 (el descarte cubre también el respaldo; el encargo solo pedía darle el foco); ninguna en el grafo ni en las autorizaciones.
- Dudas abiertas: 2: A-2 ¿el anillo de `.ficha-name` pasa a un token claro ya existente (p. ej. `--cream`, 11,01:1)? (sí/no); A-1 ¿el paso 1 del build se redacta como "solo el motor y el LOG"? (sí/no).
- Errores propios: 4, sin efecto sobre cifras ni código: la búsqueda por RBD corto en M9; dos rangos de líneas en T3; el esperado de privacidad que no descontaba `terr_liceo` ni la línea del propio comando. Costo: unas 4 re-mediciones, unos 8 minutos.
- Qué debe verificar el revisor por sí mismo: el gate visual. En el comparador, llegar a 10 de 10 con teclado y cerrar con Escape o con Enter sobre Listo: el foco queda en el contador, con anillo. En el territorio, elegir un establecimiento: el foco queda en su nombre (anillo tenue, A-2). Esta sesión midió `activeElement`, `:focus`, `:focus-visible` y el contraste; la percepción no.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `focoRespaldo`: 4 en el motor, 0 en `docs/`; md5 `5a83f63cec4a5bfaf1213e554512ac64`). El push, según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `24087e1` (primer acto).

**M1 a M4** (instrumentos copiados de s32g, que seguían en `/tmp`: `/tmp/s33_payload_sha.sh` → `/tmp/s33_payload_norm.js`, `/tmp/s33_fecha_alterada.js`, `/tmp/s33_plantar_payload.js`, `/tmp/s33_root_md5.sh`; solo cambian las rutas internas y la cabecera; el motor de FASE 0 se guarda en `/tmp/s33_motor_fase0.html` para T4.6):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s33_motor_fase0.html; echo "motor $(md5 -q $M) docs $(md5 -q $R/docs/index.html)"; bash /tmp/s33_payload_sha.sh /tmp/s33_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33_fecha_alterada.js /tmp/s33_motor_fase0.html /tmp/s33_motor_fecha.html; bash /tmp/s33_payload_sha.sh /tmp/s33_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33_plantar_payload.js /tmp/s33_motor_fase0.html /tmp/s33_motor_plantado.html; bash /tmp/s33_payload_sha.sh /tmp/s33_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s33_root_md5.sh $R/30_procesamiento/35_motor_template.html; cp /tmp/s33_root_block.txt /tmp/s33_root_block_fase0.txt; bash /tmp/s32g_root_decl.sh $R/30_procesamiento/35_motor_template.html /tmp/s33_root_decl_fase0.txt'
```
esperado: M1 solo este LOG, stash vacío; M2 `fetch rc=0`, `HEAD=24087e1`, padre `d046c9c` = `origin/main`, `0`, `1`; M3 motor y `docs/` `4b28a03f…` (premisa), §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; M4 un md5 del `:root` y su número de líneas (desde s32g T3 se espera `65` líneas, `04b2876e…`); además, como dato, las declaraciones del `:root` (instrumento del gate H-1 de s32g: `21` líneas, `18233475…`).
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=24087e1 padre=d046c9c origin/main=d046c9c`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 `motor 4b28a03fdaa00bd5dbb0a6fc501eab72 docs 4b28a03fdaa00bd5dbb0a6fc501eab72`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada a 1999-01-01 → `eb4e00b3…` (igual), cifra plantada (offset JSON 82) → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); M4 `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; declaraciones `21 lineas; md5 182334759a58462f381f12063ca2cb75`. Reglas 1 y 2 no disparan; valores de 🔒1 (`eb4e00b3…`) y 🔒2(a) (`04b2876e…`, 65 líneas).

**M7** (conteos de partida; `/tmp/s33_m7.sh`: los cinco `grep -c` de la tabla, y `/tmp/s33_m7_bloque.js`, que delimita el bloque del tooltip por balance de llaves desde `if(gse && p.difgru!=null){` y cuenta `\bcol\b` fuera de la línea `const col=` y de las líneas de comentario):
```
bash /tmp/s33_m7.sh /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html
```
esperado: `_txtOn` `2`; `_hx(` `3`; `const col=` `1`; `const sg=(p.sigdifgru===1` `1`; `tabIndex={-1}` `0`; `col` fuera de la declaración y del comentario, en el bloque: `0`.
obtenido: `_txtOn=2 _hx(=3 const_col==1 const_sg=1 tabIndex-1=0`; bloque del tooltip L1293-L1300 (8 líneas), `col` en la declaración (L1295) y en el comentario (L1298), **`col_usos_fuera: 0`**. Las tres líneas con `_hx(` son `_mix` (L1144), `_txtOn` (L1165) y `_lumWCAG` (L2642); `_hx` se define en L1142 y se queda. Todo coincide: ninguna tarea se congela por M7.

**M10** (calibración de 🔒2(b) y 🔒3 antes de T1; instrumentos nuevos: `/tmp/s33_hex.sh` cuenta hex —`#[0-9a-fA-F]{6}\b` o `#[0-9a-fA-F]{3}\b`— en líneas cambiadas `^[+-][^+-]`, separadas en agregadas y borradas; `/tmp/s33_sig.sh` cuenta `sigdifgru` en `^-[^-]` y `^\+[^+]`, comprueba que la borrada sea idéntica a la línea `const col=` de `<inicio>` y cuenta `const sg=(p.sigdifgru===1||p.sigdifgru===-1)`; los dos leen `git diff -U0 24087e1..HEAD -- <plantilla>` o, con argumento, un diff dado. `/tmp/s33_aplicar_t1t2.js` aplica a una copia **exactamente** las ediciones de §6.2 y §7.2, y aborta si algún texto buscado no aparece una sola vez):
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; node /tmp/s33_aplicar_t1t2.js $T /tmp/s33_tpl_m10_bueno.html t1t2; diff -U0 $T /tmp/s33_tpl_m10_bueno.html > /tmp/s33_m10_bueno.diff; bash /tmp/s33_hex.sh /tmp/s33_m10_bueno.diff; bash /tmp/s33_sig.sh /tmp/s33_m10_bueno.diff /tmp/s33_tpl_m10_bueno.html; awk "/Contraste WCAG 2.1 \\(luminancia relativa con linealizacion sRGB\\)\\./{print; print \"  // #123456 sigdifgru\"; next} {print}" /tmp/s33_tpl_m10_bueno.html > /tmp/s33_tpl_m10_malo.html; diff -U0 $T /tmp/s33_tpl_m10_malo.html > /tmp/s33_m10_malo.diff; bash /tmp/s33_hex.sh /tmp/s33_m10_malo.diff; bash /tmp/s33_sig.sh /tmp/s33_m10_malo.diff /tmp/s33_tpl_m10_malo.html'
```
esperado: (i) caso bueno: `hex agregadas=0 borradas=1` (la segunda línea de `_txtOn`); `sigdifgru borradas=1 agregadas=0`, la borrada es la línea `const col=` (`SI`), `const_sg=1`. (ii) caso malo (la copia buena más la línea `// #123456 sigdifgru`): `hex agregadas=1`; `sigdifgru agregadas=1`.
obtenido: el aplicador encontró cada texto una sola vez (232.633 → 231.787 bytes). (i) caso bueno: `hex agregadas=0 borradas=1` (la línea borrada es `return (0.299*a[0]+…)/255 < 0.55 ? …`, la segunda de `_txtOn`, con sus dos literales de color); `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1`. El diff de la copia tiene cuatro hunks (`@@ -1160,7 +1159,0 @@`, `@@ -1295 +1287,0 @@`, `@@ -1298 +1290 @@`, `@@ -2640,2 +2632 @@`). (ii) caso malo: `hex agregadas=1 borradas=1` (dispara con `+  // #123456 sigdifgru`); `sigdifgru borradas=1 agregadas=1`. Los dos scripts disparan en (ii) y no en (i): no hace falta corregirlos. La copia buena queda en `/tmp/s33_tpl_m10_bueno.html` como referencia: la plantilla tras T1 y T2 debe ser idéntica a ella (chequeo propio de T2).

**Instrumento de M5, M6 y T4** (`/tmp/s33_foco.js`, nuevo; Chrome con ventana —`headless:false` y `bringToFront`— o headless). Comparador (`tope_listo`, `tope_escape`, `tope_fondo`): pantalla Comparación, limpia las entidades, abre el modal con clic en `.cmp-add`, pestaña Comuna, y llega a "10 de 10" **con teclado** (Tab hasta una fila no marcada y Enter, en bucle); cierra con clic en Listo, con Escape o con clic en el fondo. Territorio (`terr_ee`): Panorama, clic en `.terr-trigger`, pestaña Establecimiento, escribe "escuela", Tab hasta la primera fila y Enter (salta a la ficha). En cada cierre registra el destino del foco por dos vías (`document.activeElement` y `document.querySelector(':focus')`), si calza `:focus-visible`, su `outline` calculado, los conteos de `.cmp-add` y `.terr-trigger` (M6) y el efecto de un Tab más (T4.4). Acciones propias para después (`terr_ee_clic`: la fila con el ratón; `desmarcar`: T4.3; `sostenido`: Enter sostenido sobre Listo con el respaldo `.cmp-add`), corridas también sobre el motor de FASE 0 como línea base. No imprime RBD ni nombres.

**M5 y M6** (motor de FASE 0, `/tmp/s33_motor_fase0.html`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33_foco.js /tmp/s33_motor_fase0.html $m tope_listo,tope_escape,tope_fondo,terr_ee,terr_ee_clic,desmarcar,sostenido; done > /tmp/s33_m5.jsonl'
```
esperado: **M5** en las cuatro corridas (comparador con Listo, con Escape y con clic en el fondo; territorio con Enter en una fila) y en los dos modos, el foco queda en **`BODY`** (`activo: BODY`, `focus_css: null`). **M6** en la ficha, `.terr-trigger` = `0`; en el comparador con 10 de 10 (modal abierto y tras cerrar), `.cmp-add` = `0`. Línea base propia: `terr_ee_clic` también `BODY`; `desmarcar`, con el origen desaparecido y un `.cmp-add` nuevo, `BODY`; `sostenido`, modal cerrado. 0 errores de consola y 0 `pageerror`.
obtenido: `rc=0`; con ventana y en headless, **resultados idénticos**, 0 errores de consola y 0 `pageerror` (`/tmp/s33_m5.jsonl`). **M5:** comparador, "10 de 10" con 10 Enter y 11 Tab en los tres cierres; tras Listo (clic), tras Escape y tras el clic en el fondo: `activo: BODY`, `focus_css: null`, `focus_visible: false`, modal cerrado. Territorio (`terr_ee`): 60 filas, 1 Tab hasta la primera fila, Enter salta a la ficha (`ficha: true`) y el foco queda en `BODY` (`focus_css: null`). **Caso malo confirmado en las cuatro corridas y en los dos modos** (regla 6 no dispara). **M6:** en la ficha `n_terr_trigger: 0` (y `n_ficha_name: 1`); en el comparador con 10 de 10, `.cmp-add` = `0` con el modal abierto (`n_cmp_add_con_modal: 0`) y tras cerrar (`n_cmp_add: 0`), con el contador `Entidades a comparar · 10 de 10`. Línea base propia: `terr_ee_clic` → `BODY`; `desmarcar` → la fila enfocada estaba marcada, Enter la desmarca (`9 de 10`) y `.cmp-add` reaparece como nodo nuevo (`n_cmp_add_con_modal: 1`), pero al cerrar con Listo el foco queda en `BODY` (el origen era el nodo anterior); `sostenido` → llega a Listo, modal cerrado, `BODY`. Un Tab desde `BODY` lleva a `BUTTON.lvl-b` ("4° básico" en el comparador, "Vista actual" en la ficha).

**M8** (línea base de 🔒6; el script de foco de s32e seguía en `/tmp` y se copia **sin cambios** a `/tmp/s33_l6.js` —`cmp` idéntico—; acciones `ciclo_terr`, `ciclo_cmp` y `devol`, las 10 vías de cierre de s32e; `/tmp/s33_l6_resumen.py` lo reduce a una línea por modo):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33_l6.js /tmp/s33_motor_fase0.html $m ciclo_terr,ciclo_cmp,devol > /tmp/s33_m8_$m.json; python3 /tmp/s33_l6_resumen.py /tmp/s33_m8_$m.json; done'
```
esperado: en los dos modos (como en s32e T2 y R-11): territorio `N353 Tab 0/1 Shift 0/1` (0 pasos fuera, ciclo cerrado); comparador `N7 Tab 0/2 Shift 0/1`; devolución al origen en `10 de 10`; Espacio en una fila no reabre (`False`); el clic en el fondo cierra los dos (`True/True`); 0 errores.
obtenido: `ventana | terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` **idéntico**. Línea base de 🔒6 fijada (`/tmp/s33_m8_ventana.json`, `/tmp/s33_m8_headless.json`).

**M9** (línea base de T1 y T2; instrumento nuevo `/tmp/s33_m9.js`, headless: abre por el modal de territorio —pestaña Establecimiento, búsqueda por RBD, clic en la fila cuyo `.check-region` termina en ese RBD— la ficha del **primer establecimiento del roster de 4b del año vigente**, en 4° básico y vista actual; registra `title|texto|color calculado|fondo calculado` de cada segmento de `DistBar` (`.bar > span`); en la vista histórica pasa el ratón por cada barra de `.hist-main` y registra el HTML completo de `#tt` y la línea "vs GSE" con el `sigdifgru` y el `difgru` del dato (`indOf`); elige tres puntos —`sigdifgru` 1, −1 y 0 o nulo— y, si a la ficha fija le falta una clase, la busca en el primer establecimiento del roster que la tenga. No imprime RBD ni nombres):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33_m9.js /tmp/s33_motor_fase0.html > /tmp/s33_m9_fase0.json; echo rc=$?'
```
esperado: valores registrados (son la línea base de T1.3 y T2.3): lista de segmentos de `DistBar` con su color calculado y su md5; líneas "vs GSE" de la ficha fija y los tres puntos, con su texto; 0 errores.
obtenido: primera corrida `rc=2`, `FALLA del instrumento: fila no encontrada`: el RBD del primer establecimiento tiene 2 dígitos, la búsqueda por subcadena devuelve las 60 primeras coincidencias (`slice(0,60)`) y la fila buscada no está entre ellas (diagnóstico con `/tmp/s33_m9_diag.js`: `n_lista 60`, `en_lista false`). Corrección del instrumento (no del motor): escribe el **nombre** del dato en la búsqueda y elige la fila por su RBD. Segunda corrida: `rc=0`, 0 errores (`/tmp/s33_m9_fase0.json`). Año vigente 2025; roster de 4b 2025: 6.717 filas; ficha fija = fila 17 del roster (el primer establecimiento de 4b 2025). **(a) `DistBar`:** 58 segmentos, 53 con etiqueta, md5 de la lista `5cf6b3b9f100afdf6b554abf371a806a`; colores calculados: Autoestima bajo `rgb(0, 0, 0)` sobre `rgb(146, 163, 204)`, medio y alto `rgb(255, 255, 255)`; Clima, los tres en `rgb(0, 0, 0)` (el alto sobre `rgb(76, 147, 154)`); Participación bajo y medio `rgb(0, 0, 0)`, alto `rgb(255, 255, 255)` sobre `rgb(59, 129, 75)`; Hábitos, los tres en `rgb(0, 0, 0)`. **(b) tooltip, ficha fija:** 36 barras con tooltip, 8 con línea "vs GSE", md5 del HTML de los 36 tooltips `771f97103a70e682238c79e0e558c62a`; las 8 líneas en `rgb(255, 255, 255)`: `ind1|2024|1|vs GSE: ▲ +8 · sig.`, `ind1|2025|0|vs GSE: ▲ +3 · n.s.`, `ind2|2024|0|vs GSE: ▲ +3 · n.s.`, `ind2|2025|0|vs GSE: = 0 · n.s.`, `ind3|2024|1|vs GSE: ▲ +8 · sig.`, `ind3|2025|0|vs GSE: ▲ +1 · n.s.`, `ind4|2024|0|vs GSE: ▲ +3 · n.s.`, `ind4|2025|0|vs GSE: ▼ -1 · n.s.`. **Tres puntos:** `sigdifgru` 1 → ficha fija, indicador 1, 2024, `<span>vs GSE: ▲ +8 · sig.</span>` (md5 del tooltip `a5743d2f…`); `sigdifgru` −1 → la ficha fija no tiene ninguno, se toma el primer establecimiento del roster de 4b 2025 que lo tiene (fila 29), indicador 4, 2025, `<span>vs GSE: ▼ -4 · sig.</span>` (`ccfd50b2…`); `sigdifgru` 0 → ficha fija, indicador 1, 2025, `<span>vs GSE: ▲ +3 · n.s.</span>` (`d6c31274…`). Línea base de T1.3 y T2.3 registrada.

- **Estado de FASE 0:** completada. M1–M10 coinciden con su esperado (M9 y M10 son líneas base y calibraciones, registradas). Ninguna regla de detención dispara; ninguna tarea congelada; sin gates.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `24087e1` (hijo de `d046c9c` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** 1 de instrumento (M9, primera corrida: la búsqueda por RBD corto no encontraba la fila; corregido en el instrumento, sin efecto sobre cifras). Costo: una corrida extra, unos 2 minutos.

### FASE T1: retirar `_txtOn` (D-1 de s32g)

- **Paso 0:** M7 (`_txtOn` 2 líneas: la definición y el comentario de `_lumWCAG`; `_hx(` 3) y M9 (línea base de `DistBar`: 58 segmentos, md5 `5cf6b3b9…`).
- **Implementación** (dos ediciones, nada más): (1) se borran el comentario de 5 líneas que describía `_txtOn` ("Color de texto legible…" hasta "…(duda al titular).") y su definición de 2 líneas; la línea en blanco que separa `nivelRamp` de la barra de puntaje se conserva; (2) el comentario de 2 líneas que precede a `_lumWCAG` pasa a `// Contraste WCAG 2.1 (luminancia relativa con linealizacion sRGB).`
- **Diff:** `+1/−9` en la plantilla (`git diff --stat`). **Chequeo propio:** la plantilla es **idéntica** (`cmp`) a la copia que el aplicador de M10 genera desde `<inicio>` con solo las ediciones de T1 (`/tmp/s33_tpl_ref_t1.html`).
- **Instrumentos nuevos de esta fase:** `/tmp/s33_build.sh <etq> [completo]` (build desde la raíz con `run_all(only = 35L)` o `run_all()`; `rc`, warnings, pasos OK, md5, §8.2 y `:root`); `/tmp/s33_pruebas_b.sh <motor>` (PRUEBAS b con los instrumentos de s32 que siguen en `/tmp`: `s32_verif.js consola` para abrir y cerrar los dos modales, `s32c_t1.js` para la ficha con vista histórica, `s32d_cmp.js … 1280 - base` para una comparación armada); `/tmp/s33_cmp_m9.py` (compara dos salidas de M9). 🔒2(b) se mide aquí sobre el **árbol** (`git diff -U0 24087e1 -- <plantilla>`, pasado como archivo a `/tmp/s33_hex.sh`), porque su forma sin argumento lee `<inicio>..HEAD` y no ve lo no commiteado.
- **Verificación** (build temporal):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; T=$R/30_procesamiento/35_motor_template.html; bash /tmp/s33_build.sh t1; echo "T1.1 plantilla $(grep -c _txtOn $T) motor $(grep -c _txtOn /tmp/s33_motor_t1.html)"; echo "T1.2 $(grep -c "_hx(" $T)"; git -C $R diff -U0 24087e1 -- 30_procesamiento/35_motor_template.html > /tmp/s33_t1.diff; echo "T1.5 $(bash /tmp/s33_hex.sh /tmp/s33_t1.diff | head -1)"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33_m9.js /tmp/s33_motor_t1.html > /tmp/s33_m9_t1.json; python3 /tmp/s33_cmp_m9.py /tmp/s33_m9_fase0.json /tmp/s33_m9_t1.json; bash /tmp/s33_pruebas_b.sh /tmp/s33_motor_t1.html'
```
esperado: `rc=0 warn=0 pasos_ok=1`; motor nuevo (distinto de `4b28a03f…`); §8.2 `eb4e00b3…4dc4` (= M3); `:root` `65` líneas, `04b2876e…` (= M4). **T1.1** `0` en la plantilla y `0` en el motor temporal. **T1.2** `2`. **T1.3** `DistBar` con la lista `title|texto|color|fondo` idéntica a M9 (58 segmentos, md5 `5cf6b3b9…`); además, tooltip y tres puntos idénticos (T1 no los toca). **T1.4** PRUEBAS b: modales `true`/`true`, ficha y comparación sin errores, 0 `pageerror`. **T1.5** `hex agregadas=0 borradas=1`.
obtenido: `rc=0 warn=0 pasos_ok=1`; motor temporal `3216cd89b17a525d15658ce30c7a2073`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` (= M4). **T1.1** `plantilla 0 motor 0`. **T1.2** `2`. **T1.3** `distbar: n 58/58 md5 5cf6b3b9/5cf6b3b9 lista_identica True`; tooltip de la ficha fija `n 36/36 con_vs_gse 8/8 md5 771f9710/771f9710 lineas_identicas True`; los tres puntos con `html_igual True` y `tt_igual True`. **T1.4** `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`, `glosa_existe: true`; comparación `errores: []`, `desbordadas: 0`; M9 `errores 0/0`. **T1.5** `hex agregadas=0 borradas=1`.
- **Regresión:** build `rc=0`, 0 warnings; los dos modales, la ficha (actual e histórica) y una comparación, sin errores.
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: ` M 30_procesamiento/35_motor_template.html` (ALCANCE de T1), ` M 40_salidas/motor_idps.html` (build temporal; va en T5) y el LOG.
obtenido: ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? …s33_log.md`. Solo la plantilla se agrega.
- **Commit:** `6025d20` chore(motor): retira _txtOn sin uso (s33 T1, D-1 de s32g). `git show --name-only HEAD` = la plantilla; porcelain después: motor ` M` (temporal) y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: retirar `const col` del tooltip (A-3 de s32g)

- **Paso 0:** M7 (`const col=` 1; `\bcol\b` fuera de la declaración y del comentario, en el bloque del tooltip: **0**) y M9 (línea "vs GSE" de la ficha fija y de los tres puntos).
- **Implementación** (dos ediciones, nada más): se borra la línea `const col=p.sigdifgru===1?…` completa; en el comentario de dos líneas que sigue a `const sg=…`, la primera queda igual y la segunda pasa a `// (la linea hereda el blanco de .tt).`
- **Verificación** (build temporal; 🔒3 medido sobre el árbol con `git diff -U0 24087e1 -- <plantilla>` pasado como archivo, por la misma razón que en T1; chequeo propio: la plantilla debe ser idéntica a la copia buena de M10, `/tmp/s33_tpl_m10_bueno.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; T=$R/30_procesamiento/35_motor_template.html; cmp -s $T /tmp/s33_tpl_m10_bueno.html && echo "plantilla = copia buena de M10" || echo "plantilla DISTINTA de M10"; git -C $R diff --stat -- 30_procesamiento/35_motor_template.html | tail -1; bash /tmp/s33_build.sh t2; echo "T2.1 const_col $(grep -c "const col=" $T) const_sg $(grep -c "const sg=(p.sigdifgru===1" $T)"; git -C $R diff -U0 24087e1 -- 30_procesamiento/35_motor_template.html > /tmp/s33_t2.diff; echo "T2.2 $(bash /tmp/s33_sig.sh /tmp/s33_t2.diff)"; echo "hex $(bash /tmp/s33_hex.sh /tmp/s33_t2.diff | head -1)"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33_m9.js /tmp/s33_motor_t2.html > /tmp/s33_m9_t2.json; python3 /tmp/s33_cmp_m9.py /tmp/s33_m9_fase0.json /tmp/s33_m9_t2.json; bash /tmp/s33_pruebas_b.sh /tmp/s33_motor_t2.html'
```
esperado: `plantilla = copia buena de M10`; `1 file changed, 1 insertion(+), 2 deletions(-)` (solo lo de T2, porque T1 ya está commiteado); `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…` (= M3); `:root` `04b2876e…` (= M4). **T2.1** `const_col 0 const_sg 1`. **T2.2** `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1` (la línea borrada es la de `col`); hex acumulado `agregadas=0 borradas=1`. **T2.3** la línea "vs GSE" de los tres puntos con `html_igual True` y `tt_igual True`; las 8 líneas de la ficha fija y el md5 de sus 36 tooltips, idénticos a M9; `DistBar` sigue idéntico. **T2.4** PRUEBAS b sin errores.
obtenido: `plantilla = copia buena de M10`; `1 file changed, 1 insertion(+), 2 deletions(-)`; `rc=0 warn=0 pasos_ok=1`; motor temporal `0228a0c818b308cc01564a36a057bb3e`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` (= M4). **T2.1** `const_col 0 const_sg 1`. **T2.2** `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1` (la borrada: `const col=p.sigdifgru===1?"var(--destaca)":…`); hex acumulado `agregadas=0 borradas=1`. **T2.3** `s1: vs GSE: ▲ +8 · sig.`, `s-1: vs GSE: ▼ -4 · sig.`, `s0_o_nulo: vs GSE: ▲ +3 · n.s.`, los tres con `html_igual True` y `tt_igual True`; ficha fija `n 36/36 con_vs_gse 8/8 md5 771f9710/771f9710 lineas_identicas True`; `DistBar` `lista_identica True`. **T2.4** modales `true`/`true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`; comparación `errores: []`, `desbordadas: 0`.
- **Regresión:** build `rc=0`, 0 warnings; modales, ficha y comparación sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "chore(motor): retira const col sin uso del tooltip (s33 T2, A-3 de s32g)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && bash /tmp/s33_sig.sh && git -C $R status --porcelain'
```
esperado: porcelain antes: ` M` plantilla (ALCANCE de T2), ` M` motor (temporal) y el LOG; commit con solo la plantilla; 🔒3 ahora sobre `<inicio>..HEAD` (sin argumento): `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1`; porcelain después: motor y LOG.
obtenido: antes ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? …s33_log.md`; **`1fbc9d1` chore(motor): retira const col sin uso del tooltip (s33 T2, A-3 de s32g)** con `30_procesamiento/35_motor_template.html`; 🔒3 sobre `<inicio>..HEAD`: `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1`; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T4: destino de respaldo del foco cuando el origen desaparece (A-1 de s32e)

- **Paso 0:** M5 (`BODY` en las cuatro corridas y en los dos modos), M6 (`.terr-trigger` 0 en la ficha; `.cmp-add` 0 con 10 de 10) y M8 (línea base de 🔒6). Cada modal tiene un solo disparador (`grep`: `setModalOpen(true)` solo en `.terr-trigger`; `setCmpModalOpen(true)` solo vía `onAdd` de `.cmp-add`). Al elegir un establecimiento, `onPick` cierra el modal y pasa a la ficha en el mismo commit de React; la limpieza del efecto del modal corre después de insertar la ficha, así que `.ficha-name` ya está en el documento cuando se busca el respaldo.
- **Implementación** (lo de §8.2 del encargo):
  - `EntityModal` gana `focoRespaldo=null`. En el efecto de limpieza: si el origen sigue en el documento, se enfoca como antes; si no, se llama a `focoRespaldo` y, si devuelve un elemento que está en el documento, se enfoca; si no hay respaldo (o no está), `return` como hoy. Comentario pedido, textual, en la rama del respaldo.
  - Modal de territorio: `focoRespaldo={()=>document.querySelector(".ficha-name")}`; `div.ficha-name` con `tabIndex={-1}`.
  - Modal del comparador: `focoRespaldo={()=>document.querySelector(".cmp-add")||document.querySelector(".cmp-cl")}`; `span.cmp-cl` con `tabIndex={-1}`.
  - CSS, fuera del `:root`, justo después de `.check-row:focus-visible` (la regla de foco del modal): `.ficha-name:focus-visible,.cmp-cl:focus-visible{outline:2px solid var(--foco);outline-offset:2px;}`, con un comentario CSS de una línea (sin `*/` interno ni hex).
  - **Decisión autónoma D-A1:** el descarte de la autorrepetición de Enter y Espacio (R-11 de s32e) se aplica al **destino** del foco, sea el origen o el respaldo (`e.target===destino`; el comentario de R-11 dice ahora "sobre el destino del foco (el origen o el respaldo)"). Razón: el respaldo del comparador puede ser `.cmp-add`, un botón, y un Enter sostenido sobre Listo lo activaría y reabriría el modal (el mismo defecto de R-11). Con el origen presente, `destino===origen`: el comportamiento es el de antes. Se verifica con la acción `sostenido` y con un control plantado sin el descarte en el respaldo.
- **Diff:** `+17/−9` en la plantilla (`git diff --stat`), sin hex ni `sigdifgru` en líneas agregadas.
- **Verificación** (build temporal; con ventana **y** headless; tres comandos):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; bash /tmp/s33_build.sh t4; M=/tmp/s33_motor_t4.html; git -C $R diff -U0 24087e1 -- 30_procesamiento/35_motor_template.html > /tmp/s33_t4.diff; echo "T4.7 $(bash /tmp/s33_hex.sh /tmp/s33_t4.diff | head -1) ; $(bash /tmp/s33_sig.sh /tmp/s33_t4.diff | head -1)"; echo "focoRespaldo en el motor $(grep -c focoRespaldo $M)"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,terr_ee_clic,desmarcar,sostenido; done > /tmp/s33_t4.jsonl; python3 /tmp/s33_foco_resumen.py /tmp/s33_t4.jsonl'
bash -c 'M=/tmp/s33_motor_t4.html; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33_t4_l6_$m.json; python3 /tmp/s33_l6_resumen.py /tmp/s33_t4_l6_$m.json; done; node /tmp/s32e_enter_sostenido.js $M; node /tmp/s32e_sostenido2.js $M'
bash -c 'M=/tmp/s33_motor_t4.html; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33_foco.js /tmp/s33_motor_fase0.html $m tope_listo,tope_escape,tope_fondo,terr_ee; done > /tmp/s33_t46.jsonl; python3 /tmp/s33_foco_resumen.py /tmp/s33_t46.jsonl; echo "ocurrencias de e.target===destino $(grep -c "e.target===destino" $M)"; sed "s/e.target===destino/e.target===origen/" $M > /tmp/s33_motor_t4_sin_descarte.html; echo "plantado difiere $(cmp -s $M /tmp/s33_motor_t4_sin_descarte.html && echo NO || echo SI)"; node /tmp/s33_foco.js /tmp/s33_motor_t4_sin_descarte.html headless sostenido > /tmp/s33_t4_ctl.jsonl; python3 /tmp/s33_foco_resumen.py /tmp/s33_t4_ctl.jsonl; bash /tmp/s33_pruebas_b.sh $M'
```
esperado: `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…` (= M3); `:root` `65`, `04b2876e…` (= M4); `focoRespaldo` ≥ 1 en el motor. **T4.1** (dos modos) comparador con 10 de 10: `activo=SPAN.cmp-cl` y `focus_css=SPAN.cmp-cl` tras Listo, tras Escape y tras el clic en el fondo; tras Escape (teclado) `focus_visible=True` y `outline=solid 2px`. **T4.2** territorio con Enter en una fila: `activo=DIV.ficha-name`, `focus_css=DIV.ficha-name`. **T4.3** `desmarcar` (`9 de 10`, Listo): `activo=BUTTON.cmp-add`. **T4.4** desde cada respaldo, un Tab lleva a un control **posterior** del documento (`posterior=True`), fuera de modal (`dentro_modal=False`), no a `BODY`. **T4.5** 🔒6 = M8 en los dos modos (`N353 Tab 0/1 Shift 0/1`, `N7 Tab 0/2 Shift 0/1`, `10 de 10`, `False`, `True/True`, 0 errores). **T4.6** motor de FASE 0: `BODY` en las cuatro corridas y en los dos modos. **T4.7** `hex agregadas=0 borradas=1` (acumulado, la línea de T1) y `sigdifgru borradas=1 agregadas=0`. Registro sin criterio: `outline` del respaldo tras los cierres con el ratón (Listo, fondo, fila con clic). Propios: `sostenido` con el respaldo `.cmp-add` → `modal_reabierto=False`, `activo=BUTTON.cmp-add`; control plantado sin el descarte en el respaldo → `modal_reabierto=True` (el instrumento distingue); R-11 de s32e con el origen presente: `enter_simple`/`sostenido_2`/`sostenido_4` cerrados con el foco en `terr-trigger`, Espacio sostenido cerrado, Enter nuevo abre (`true`), Enter sostenido en Listo cerrado con el foco en `cmp-add`. PRUEBAS b sin errores; 0 errores en todas las corridas.
obtenido: (`/tmp/s33_t4.jsonl`, `/tmp/s33_t4_l6_*.json`, `/tmp/s33_t46.jsonl`, `/tmp/s33_t4_ctl.jsonl`; **con ventana y en headless, idénticos**; 0 errores de consola y 0 `pageerror` en todas las corridas) `rc=0 warn=0 pasos_ok=1`; motor temporal `5a83f63cec4a5bfaf1213e554512ac64`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` (= M4); `focoRespaldo en el motor 4`.
- **T4.1:** `tope_listo`, `tope_escape` y `tope_fondo` → `activo=SPAN.cmp-cl focus_css=SPAN.cmp-cl tabindex=-1`, `cmp_add=0`. Tras Escape: `focus_visible=True outline=solid 2px`.
- **T4.2:** `terr_ee` → `activo=DIV.ficha-name focus_css=DIV.ficha-name tabindex=-1`, `focus_visible=True outline=solid 2px`, `terr_trigger=0`.
- **T4.3:** `desmarcar` (`10 de 10` → `9 de 10`, Listo con clic) → `activo=BUTTON.cmp-add focus_css=BUTTON.cmp-add`.
- **T4.4:** desde `.cmp-cl`, Tab → `BUTTON.cmp-x` (la ✕ del primer chip); desde `.ficha-name` → `BUTTON.lvl-b`; desde `.cmp-add` (T4.3) → `BUTTON.cmp-reset`; en todos `posterior=True dentro_modal=False`, ninguno `BODY`.
- **T4.5 (🔒6):** `ventana | terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico → **= M8**.
- **T4.6:** motor de FASE 0, con ventana y headless: `BODY` en `tope_listo`, `tope_escape`, `tope_fondo` y `terr_ee`.
- **T4.7:** `hex agregadas=0 borradas=1`; `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1`; `:root` y §8.2 iguales (arriba).
- **Registro sin criterio (cierres con el ratón):** Listo con clic → `.cmp-cl` sin anillo (`focus_visible=False`, `outline=none`); fila con clic en el territorio → `.ficha-name` sin anillo (`none`); clic en el fondo del comparador → `.cmp-cl` **con** anillo (`solid 2px`): el clic cae en un elemento no enfocable y Chrome conserva la modalidad de teclado de la fila que tenía el foco.
- **Propios:** `sostenido` → `modal_reabierto=False`, `activo=BUTTON.cmp-add` (D-A1 funciona); control plantado (`e.target===destino` → `e.target===origen`, 1 ocurrencia, la copia difiere) → **`modal_reabierto=True`**, foco en el buscador del modal reabierto: sin D-A1, el respaldo `.cmp-add` reabría el modal con Enter sostenido. R-11 de s32e con el origen presente: `enter_simple`, `enter_sostenido_2`, `enter_sostenido_4` → `modal_abierto: false`, `foco: terr-trigger`; `terr_espacio_sostenido` cerrado; `terr_enter_nuevo_abre: true`; `cmp_listo_enter_sostenido` cerrado, `foco: cmp-add`. PRUEBAS b: modales `true`/`true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`; comparación `errores: []`, `desbordadas: 0`.
- **Regresión:** build `rc=0`, 0 warnings; 🔒6 = M8; R-11 de s32e intacto; PRUEBAS b sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "fix(motor): destino de respaldo del foco al cerrar el modal sin origen (s33 T4, A-1 de s32e)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && bash /tmp/s33_hex.sh | head -1 && git -C $R status --porcelain'
```
esperado: porcelain antes: ` M` plantilla (ALCANCE de T4), ` M` motor (temporal) y el LOG; commit con solo la plantilla; 🔒2(b) sobre `<inicio>..HEAD`: `hex agregadas=0 borradas=1`; después: motor y LOG.
obtenido: antes ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? …s33_log.md`; **`f58761c` fix(motor): destino de respaldo del foco al cerrar el modal sin origen (s33 T4, A-1 de s32e)** con `30_procesamiento/35_motor_template.html`; 🔒2(b) sobre `<inicio>..HEAD`: `hex agregadas=0 borradas=1`; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1. Decisión autónoma D-A1 (descarte de la autorrepetición sobre el destino), con su control plantado.

### FASE T3: encabezado de §5 y estado de la decisión de contraste (A-1 de s32g)

- **Paso 0** (comandos de §9.1 del encargo; el esperado de `s33` es el del encargo):
```
bash -c 'D=/Users/tomgc/Projects/slep_idps/50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md; grep -n "^## 5\." $D; sed -n 1,20p $D; grep -c s33 $D'
```
esperado: `## 5.` con "(§5.1, §5.3 a/c, §5.4 y §5.5 1/3 resueltos; §5.2 y §5.6 abiertos)"; el campo **Estado** termina en "…Redesplegado a `docs/`. Última" / "  enmienda de la línea de contraste." sin mención de s32g; `grep -c 's33'` → `0`.
obtenido: `190:## 5. Pendientes asociados (§5.1, §5.3 a/c, §5.4 y §5.5 1/3 resueltos; §5.2 y §5.6 abiertos)`; **Estado** L9-L18, termina en `  de la paleta de INDICADOR—, que pide mockup. Redesplegado a \`docs/\`. Última` / `  enmienda de la línea de contraste.`, sin s32g; `0`.
- **Edición:** (1) el encabezado pasa a `## 5. Pendientes asociados (§5.1, §5.3 a/c, §5.4, §5.5 1/3 y §5.6 resueltos; §5.2 abierto)`; (2) en **Estado** se borra "Última enmienda de la línea de contraste." y va el texto literal del encargo, con sangría de dos espacios y líneas de hasta 88 columnas (L17-L21). Nada más cambia.
- **Verificación** (más dos chequeos propios: el texto nuevo, unido sin saltos ni sangría, es **igual** al literal del encargo; ninguna línea del campo pasa de 88 columnas):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; D=50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md; echo "abiertos $(grep -c "§5.6 abiertos" $R/$D) resueltos $(grep -c "§5.6 resueltos; §5.2 abierto" $R/$D) s33 $(grep -c s33 $R/$D) hunks $(git -C $R diff -U0 -- $D | grep -c "^@@")"; git -C $R diff --stat -- $D | tail -1; python3 -c "
L=open(\"$R/$D\",encoding=\"utf-8\").read().split(chr(10)); t=\" \".join(x.strip() for x in L[16:21]); i=t.index(\"**Enmendada el 2026-09-23\")
lit=\"**Enmendada el 2026-09-23 (s32g):** se resuelve la §5.6 con la opción B (título del indicador en tinta con filete del color) y se amplía a siete el inventario de usos de los tokens \`-txt\`. Desplegado a \`docs/\`. **Enmendada el 2026-09-24 (s33):** encabezado de §5 al día; \`_txtOn\` retirado del motor.\"
print(\"literal_igual\", t[i:]==lit, \"max_col\", max(len(x) for x in L[8:21]))"'
```
esperado: `abiertos 0 resueltos 1 s33 1 hunks 2`; `1 file changed, 6 insertions(+), 3 deletions(-)`; `literal_igual True`, `max_col` ≤ 88. No tocó código (regresión: "no tocó código").
obtenido: `abiertos 0 resueltos 1 s33 1 hunks 2`; `1 file changed, 6 insertions(+), 3 deletions(-)`; el chequeo literal **falló por un error mío de índice** (`ValueError: substring not found`): unía las líneas 17-21, pero el texto nuevo empieza en la línea 16 (hunks `@@ -16,2 +16,5 @@` y `@@ -190 +193 @@`). Re-medición con el rango correcto (líneas 16-20): `literal_igual True`; anchos de las líneas nuevas `82, 83, 81, 84, 44`; máximo del campo **Estado** completo (L8-L20) `87` (≤ 88).
obtenido: (corrección de la línea `obtenido:` del paso 0 de esta fase, que decía "Estado L9-L18") el campo **Estado** ocupaba L8-L17 antes de la edición (L8 = `- **Estado:** …`, L17 = `  enmienda de la línea de contraste.`) y ocupa L8-L20 después.
- **Regresión:** T3 no toca código (solo la decisión).
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; D=50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md; git -C $R status --porcelain; git -C $R add $D && git -C $R commit -q -m "docs(decision): encabezado de §5 y estado al día (s33 T3, A-1 de s32g)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R status --porcelain'
```
esperado: porcelain antes: ` M` decisión (ALCANCE de T3), ` M` motor (temporal de T4; va en T5) y el LOG; commit con solo la decisión; después: motor y LOG.
obtenido: antes ` M 40_salidas/motor_idps.html`, ` M 50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`, `?? …s33_log.md`; **`b1dafe4` docs(decision): encabezado de §5 y estado al día (s33 T3, A-1 de s32g)** con la decisión; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios:** 2 de registro, sin efecto sobre el archivo: el rango de líneas del chequeo literal (17-21 en vez de 16-20) y el rango del campo Estado en el paso 0 (L9-L18 en vez de L8-L17); corregidos con líneas nuevas. Costo: una re-medición, unos 2 minutos.

### FASE T5: build

- **Paso 1** (porcelain):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: el encargo dice "vacío". **Por construcción no puede serlo:** el LOG queda sin seguimiento hasta FASE L, y los builds temporales que el encargo manda en T1, T2 y T4 (`run_all(only = 35L)`) dejan `40_salidas/motor_idps.html` modificado, que es el ALCANCE de esta tarea. Se espera exactamente ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md`; cualquier otra ruta (o un ` M` en la plantilla o en la decisión) congela T5. La diferencia con la letra del encargo se registra como advertencia de redacción en FASE R.
obtenido: ` M 40_salidas/motor_idps.html`, `?? 50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md`. Nada más: T1, T2, T4 y T3 están commiteadas.
- **Pasos 2 a 4** (PRUEBAS a con el pipeline completo; PRUEBAS b completa; testigo; md5; y, en el comando siguiente, T4.1, T4.2 y 🔒6 sobre el motor commiteable, con ventana y headless):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; bash /tmp/s33_build.sh t5 completo; git -C $R status --porcelain; echo "motor en el arbol $(md5 -q $M) ; §8.2 $(bash /tmp/s33_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*" | cut -c15-)"; echo "testigo focoRespaldo motor $(grep -c focoRespaldo $M) docs $(grep -c focoRespaldo $R/docs/index.html) ; _txtOn motor $(grep -c _txtOn $M)"; bash /tmp/s33_pruebas_b.sh $M'
bash -c 'M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee; done > /tmp/s33_t5.jsonl; python3 /tmp/s33_foco_resumen.py /tmp/s33_t5.jsonl; for m in ventana headless; do node /tmp/s33_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33_t5_l6_$m.json; python3 /tmp/s33_l6_resumen.py /tmp/s33_t5_l6_$m.json; done'
```
esperado: `rc=0 warn=0 pasos_ok=5`; porcelain después, el mismo del paso 1 (el pipeline completo no cambia nada versionado fuera del motor); motor `5a83f63cec4a5bfaf1213e554512ac64` (= build temporal de T4: misma plantilla y mismo día; T3 no toca código), **distinto de `4b28a03f…`**; §8.2 `eb4e00b3…` (= M3); `:root` `04b2876e…` (= M4); testigo `focoRespaldo` motor ≥ 1 y `docs` `0`; `_txtOn` en el motor `0`. PRUEBAS b: modales `true`/`true`, ficha y comparación sin errores, 0 `pageerror`. T4.1 `SPAN.cmp-cl` en las tres vías (Escape con `solid 2px`); T4.2 `DIV.ficha-name`; 🔒6 = M8; en los dos modos; 0 errores.
obtenido: (primer comando) `rc=0 warn=0 pasos_ok=5`; motor `5a83f63cec4a5bfaf1213e554512ac64` (= T4; **distinto de `4b28a03f…`**); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` (= M4); porcelain después ` M 40_salidas/motor_idps.html`, `?? …s33_log.md` (el mismo); testigo `focoRespaldo motor 4 docs 0 ; _txtOn motor 0`; PRUEBAS b: `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`, `glosa_existe: true`; comparación `errores: []`, `desbordadas: 0`. (Segundo comando, con ventana y headless, idénticos, 0 errores) T4.1: `SPAN.cmp-cl` (también por `:focus`) tras Listo, Escape y fondo; Escape `focus_visible=True outline=solid 2px`; T4.2: `DIV.ficha-name`; 🔒6: `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` (= M8).
- **Testigo para el despliegue:** `grep -c 'focoRespaldo'` → `4` en `40_salidas/motor_idps.html` (≥ 1) y `0` en `docs/index.html`; `grep -c '_txtOn'` en el motor → `0`. **md5 del motor para el despliegue: `5a83f63cec4a5bfaf1213e554512ac64`.**
- **Paso 5 (commit):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s33 limpieza y respaldo del foco" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: commit con solo el motor (`5a83f63c…`); porcelain después: solo el LOG.
obtenido: **`f4ad2e0` build(motor): s33 limpieza y respaldo del foco**; `40_salidas/motor_idps.html`; `5a83f63cec4a5bfaf1213e554512ac64`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `24087e1`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `24087e1` (hijo de `d046c9c` = `origin/main`); commits `24087e1`, `6025d20`, `1fbc9d1`, `f58761c`, `b1dafe4`, `f4ad2e0` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0 y en los builds de T1, T2, T4 y T5; ciego a la fecha y sensible a una cifra plantada (M3) |
| R-03 | `:root` `65` líneas, `04b2876e…`, sin cambio en todos los builds (M4, T1.4, T4.7, T5) |
| R-04 | M5 / T4.6: en el motor anterior, el foco cae en `BODY` en las cuatro corridas y en los dos modos (caso malo) |
| R-05 | M6: `.terr-trigger` 0 en la ficha; `.cmp-add` 0 con 10 de 10 |
| R-06 | M7: `_txtOn` 2, `_hx(` 3, `const col=` 1, `const sg=(…` 1, `tabIndex={-1}` 0, `col` fuera de declaración y comentario 0 |
| R-07 | M8 / T4.5 / T5: 🔒6 (ciclo y devolución de s32e) idéntico, con ventana y headless |
| R-08 | M9 / T1.3 / T2.3: `DistBar` (58 segmentos) y tooltips (36; 8 "vs GSE"; tres puntos) idénticos a la línea base |
| R-09 | M10: `/tmp/s33_hex.sh` y `/tmp/s33_sig.sh` disparan con el caso malo y no con el bueno |
| R-10 | T1.1 / T1.2: `_txtOn` 0 en la plantilla y en el motor; `_hx(` 2; plantilla = referencia de M10 |
| R-11 | T2.1 / T2.2: `const col=` 0; `const sg=` 1; `sigdifgru` −1 (la línea de `col`) / +0; plantilla = copia buena de M10 |
| R-12 | T4.1: con 10 de 10 el foco queda en `.cmp-cl` tras Listo, Escape y fondo; con Escape, anillo `solid 2px` |
| R-13 | T4.2: tras elegir un establecimiento, el foco queda en `.ficha-name` |
| R-14 | T4.3: tras desmarcar una entidad en el tope y cerrar con Listo, el foco queda en `.cmp-add` |
| R-15 | T4.4: desde cada respaldo, un Tab lleva a un control posterior, fuera del modal |
| R-16 | D-A1: Enter sostenido sobre Listo con el respaldo `.cmp-add` no reabre el modal; sin el descarte, sí (control) |
| R-17 | T3: encabezado de §5 y campo Estado; literal igual; 2 hunks; `s33` 1 |
| R-18 | T5: build completo con el árbol limpio salvo el motor; motor `5a83f63c…`; testigo `focoRespaldo` 4/0; `_txtOn` 0 |
| 🔒1–🔒6 | invariantes de §3 |
| ALC | alcance global ⊆ unión de ALCANCE + LOG + encargo |
| REG | PRUEBAS a, b y c sobre el estado final |
| CP | casos malos y plantados: M3 (cifra), M5/T4.6 (motor anterior), M10 (hex y `sigdifgru`), T4 (sin descarte) |

**Paso 2a. Re-derivación estática** (`/tmp/s33_r_static.sh`: §8.2 con `/tmp/s33_r_payload.py` —Python, otra implementación que el node de M3—; `:root` con `/tmp/s33_r_root.py`; conteos con `awk` —`index()`, sin expresiones regulares—; 🔒2(b) y 🔒3 con `/tmp/s33_r_diff.py` —Python sobre `git diff -U0`—; el código que pinta `DistBar` y la línea "vs GSE", comparado entre `<inicio>` y `HEAD`; md5 del motor en `HEAD` con `hashlib`):
```
bash /tmp/s33_r_static.sh
```
esperado: R-01 padre `d046c9c` = `origin/main`, 6 commits (`f4ad2e0 b1dafe4 f58761c 1fbc9d1 6025d20 24087e1`). R-02 `eb4e00b3…` en el motor de `HEAD`, en el de FASE 0 y en el de fecha alterada, **distinto** en el plantado, con 1 fecha normalizada en cada uno. R-03 `:root` de `<inicio>` y de `HEAD` con las mismas líneas (65) y el mismo md5 (`04b2876e…`, el del awk). R-06/R-10/R-11 en `HEAD`: `_txtOn 0`, `txtOn` en el motor `0`, `_hx( 2`, `const col= 0`, `const sg= 1`, `tabIndex={-1} 2` (los dos respaldos), `focoRespaldo 4`; en `<inicio>`: `2`, `3`, `1`, `0` y **0 usos** de `_txtOn(` fuera de su definición. R-08: `DistBar`, `vtTexto`, la línea `h += …vs GSE…` y `const gl`/`const sg`, idénticas (`SI`). R-09/R-11: `hex +0 -1` y `sigdifgru +0 -1`, con la borrada con hex = la segunda línea de `_txtOn` y la de `sigdifgru` = `const col=…`. R-17: `abiertos 0`, `resueltos 1`, `s33 1`, numstat `6 3`. R-18: md5 `5a83f63c…`; testigo `docs 0 motor 4`.
obtenido: `R-01: padre d046c9c ; origin/main d046c9c ; commits f4ad2e0 b1dafe4 f58761c 1fbc9d1 6025d20 24087e1`. R-02 (Python): motor de `HEAD`, de FASE 0 y de fecha alterada `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; plantado `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8`; `fechas_normalizadas=1` y `bytes=59467463` en los cuatro. R-03 (Python): `<inicio>` y `HEAD` `lineas=65 md5=04b2876e2bcece41f09398f28f6fc41d`. R-06/R-10/R-11 (awk, `HEAD`): `_txtOn 0 ; txtOn en el motor 0 ; _hx( 2 ; const col= 0 ; const sg= 1 ; tabIndex={-1} 2 ; focoRespaldo 4`; (`<inicio>`): `_txtOn 2 ; _hx( 3 ; const col= 1 ; tabIndex={-1} 0 ; usos de _txtOn( fuera de su definicion 0`. R-08: `DistBar identico SI ; vtTexto identico SI ; linea h+=vs GSE identica SI ; const gl y const sg identicas SI`. R-09/R-11 (Python): `lineas +19 -20 | hex +0 -1 | sigdifgru +0 -1`, borradas: la segunda línea de `_txtOn` y `const col=…`. R-17: `abiertos 0 ; resueltos 1 ; s33 1 ; numstat 6 3`. R-18: `5a83f63cec4a5bfaf1213e554512ac64 ; testigo docs 0 motor 4`. **Todo coincide por otra vía.**

**Paso 2b. Re-derivación en navegador** (`/tmp/s33_r_foco.js`, otras rutas: comparador abierto con Enter sobre `.cmp-add`, pestaña **Región** elegida con Shift+Tab + Enter, filas con **Espacio** hasta 10 de 10 y cierre con **Espacio sobre Listo** (`cmp_region`); lo mismo, desmarcando una con Espacio y cerrando con Escape (`cmp_desm`, T4.3 por otra vía); territorio abierto con Espacio, pestaña Establecimiento con teclado, búsqueda "liceo" y **tercera** fila con Espacio (`terr_liceo`). Destino por `activeElement`, `querySelector(':focus')` y `querySelector(':focus-visible')`; un **Shift+Tab** desde el destino (T4.4 hacia atrás); y el contraste WCAG del anillo contra el fondo opaco del padre. Sobre el motor de `HEAD` con ventana y headless; sobre el de FASE 0 y sobre un **control plantado** —copia del motor de `HEAD` sin el respaldo (`destino=focoRespaldo?focoRespaldo():null;` → `destino=null;`)— en headless):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; H=/tmp/s33_r_motor_head.html; echo "ocurrencias $(grep -c "destino=focoRespaldo?focoRespaldo():null;" $H)"; sed "s/destino=focoRespaldo?focoRespaldo():null;/destino=null;/" $H > /tmp/s33_r_motor_sin_respaldo.html; echo "plantado difiere $(cmp -s $H /tmp/s33_r_motor_sin_respaldo.html && echo NO || echo SI)"; (for m in ventana headless; do node /tmp/s33_r_foco.js $H $m; done; node /tmp/s33_r_foco.js /tmp/s33_motor_fase0.html headless; node /tmp/s33_r_foco.js /tmp/s33_r_motor_sin_respaldo.html headless) > /tmp/s33_r_nav.jsonl; python3 -c "
import json
for l in open(\"/tmp/s33_r_nav.jsonl\"):
    d=json.loads(l); print(\"==\", d[\"motor\"], d[\"modo\"], \"errores\", len(d[\"errores\"]))
    for k in (\"cmp_region\",\"cmp_desm\",\"terr_liceo\"):
        v=d[k]; print(\" \", k, json.dumps({x:v.get(x) for x in (\"lleno\",\"llega_listo\",\"tras_desmarcar\",\"filas\",\"fila_elegida\",\"ficha\",\"destino\",\"shift_tab\",\"error\") if x in v}, ensure_ascii=False))
"'
```
esperado: motor de `HEAD`, en los dos modos: `cmp_region` `10 de 10` en Región, llega a Listo, destino `SPAN.cmp-cl` por las tres vías (`activo`, `focus_css`, `focus_visible_css`), anillo `solid 2px` del color de `--foco`; `cmp_desm` `9 de 10`, `.cmp-add` 1, destino `BUTTON.cmp-add`; `terr_liceo` ficha abierta, destino `DIV.ficha-name` por las tres vías, anillo `solid 2px`; en los tres, Shift+Tab lleva a un control **anterior** (`anterior=True`), no a `BODY` ni al modal. Contraste del anillo: se registra; bajo 3:1 (WCAG 2.2, 1.4.11) sería una advertencia para el gate visual. Motor de FASE 0 y control plantado: destino `BODY` en los tres (`focus_css: null`). 0 errores.
obtenido: `ocurrencias 1`, `plantado difiere SI`; 0 errores en las cuatro corridas (`/tmp/s33_r_nav.jsonl`). **Motor de `HEAD`, con ventana y headless, idénticos:** `cmp_region` `10 de 10` con 10 Espacios en `Región`, `llega_listo: true`, destino `SPAN.cmp-cl` por `activo`, `focus_css` y `focus_visible_css`, anillo `solid 2px` `rgb(0, 98, 160)` sobre `rgb(255, 246, 224)`, **5,99**; Shift+Tab → `BUTTON.lvl-b`, `anterior: true`. `cmp_desm` `9 de 10`, `cmp_add: 1`, destino `BUTTON.cmp-add` por las tres vías (anillo propio del botón, `auto 1px`, 5,56); Shift+Tab → `BUTTON.cmp-x`, `anterior: true`. `terr_liceo` 60 filas, tercera fila, ficha abierta, destino `DIV.ficha-name` por las tres vías, anillo `solid 2px` `rgb(0, 98, 160)` sobre `rgb(10, 58, 92)` (la barra de la ficha, `--azul`), **1,84**; Shift+Tab → `BUTTON.screen-tab`, `anterior: true`. Ninguno en `BODY` ni dentro de un modal. **Motor de FASE 0 y control plantado sin respaldo:** `BODY` en los tres (`focus_css: null`, `focus_visible_css: null`): el instrumento dispara. R-12 a R-15 confirmados por otra vía.
**Hallazgo A-2 (anillo de `.ficha-name`):** el anillo que fija §8.2 del encargo (`outline:2px solid var(--foco)`) da **1,84:1** contra el fondo de la barra de la ficha (`--azul`), bajo el 3:1 de WCAG 2.2 (1.4.11, contraste de componentes no textuales); recalculado en Python con los hex de los tokens: `--foco`/`--azul` 1,84; `--foco`/`--cream` 5,99 (el del comparador); el token de texto de la barra, `--cream`, daría 11,01 sobre `--azul`. El foco **sí** está en el nombre (T4.2 cumple), pero el anillo se verá poco en el gate visual. Repararlo cambiaría la regla CSS que el encargo fija textualmente (el criterio), así que no se repara: **ADVIERTE**, con pregunta al titular en el cierre.

**Pasos 3, 4 y 6** (`/tmp/s33_final.sh`: L1–L5 con los comandos de §3; alcance con lista explícita de rutas permitidas —las tres de los ALCANCE, el LOG y el encargo—; controles positivos fuera del árbol: C1 una línea de diff con un hex; C2 la plantilla con un valor de token cambiado; C3 el motor con la cifra plantada de M3; C4 una ruta plantada en el alcance; C5 una línea de diff con `sigdifgru`; C6 🔒5 sobre el deploy `9fc6f22` de s32g; C7 🔒4 sobre `364c53a`, el commit de datos de s32b; C8 una copia del motor con `txtOn` plantado):
```
bash /tmp/s33_final.sh
```
esperado: `L1` `eb4e00b3…4dc4`; `L2a` `lineas: 65; md5 04b2876e…`; `L2b` `hex agregadas=0 borradas=1`; `L3` `sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1`; `L4` `0`; `L5` `0`. `ALC` 3 rutas (plantilla, motor, decisión), `fuera 0`, el encargo en `24087e1`, porcelain solo el LOG. `C1` `agregadas=1`; `C2` un md5 **distinto** de `04b2876e…`; `C3` `1c3799e2…`; `C4` `[docs/index.html]`; `C5` `agregadas=1`; `C6` `1`; `C7` > 0; `C8` `1`.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **🔒1 PASA**; `L2a: lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` y `L2b: hex agregadas=0 borradas=1` → **🔒2 PASA**; `L3: sigdifgru borradas=1 agregadas=0 borrada_es_const_col=SI const_sg=1` → **🔒3 PASA**; `L4: 0` → **🔒4 PASA**; `L5: 0` → **🔒5 PASA**. `ALC: rutas [30_procesamiento/35_motor_template.html 40_salidas/motor_idps.html 50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md ] ; fuera 0 ; en 24087e1: [50_documentacion/activa/encargos/encargo_claude_code_idps_limpieza_foco_respaldo_s33.md ] ; porcelain [?? …s33_log.md ]` → **alcance PASA**. Controles: `C1: hex agregadas=1 borradas=0`; `C2: lineas: 65; md5 070d6097d10e601e95a45ce0e6352392` (distinto); `C3: 1c3799e2e8e35da8` (distinto); `C4: [docs/index.html ]`; `C5: sigdifgru borradas=0 agregadas=1 borrada_es_const_col=NO const_sg=1`; `C6: 1`; `C7: 78`; `C8: 1`. **Todos los instrumentos disparan con su caso plantado.**

**Paso 3, 🔒6** (el script de M8 sobre el motor final, con ventana y headless) **y su control positivo C9** (copia del motor de `HEAD` con la devolución quitada: la única línea `      destino.focus();` → `      0;`, en headless, acción `devol`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; for m in ventana headless; do node /tmp/s33_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33_r_l6_$m.json; python3 /tmp/s33_l6_resumen.py /tmp/s33_r_l6_$m.json; done; sed "s/^      destino.focus();$/      0;/" /tmp/s33_r_motor_head.html > /tmp/s33_r_motor_sin_devol.html; echo "C9 plantado difiere $(cmp -s /tmp/s33_r_motor_head.html /tmp/s33_r_motor_sin_devol.html && echo NO || echo SI)"; node /tmp/s33_l6.js /tmp/s33_r_motor_sin_devol.html headless devol | python3 -c "import json,sys; d=json.load(sys.stdin)[\"devol\"]; print(\"C9 origen en\", sum(1 for v in d.values() if v.get(\"es_origen\")), \"de\", len(d))"'
```
esperado: `L6` en los dos modos igual a M8: `terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0`. `C9` la copia difiere y `origen en 0 de 10`.
obtenido: `ventana | terr N353 Tab 0/1 Shift 0/1 | cmp N7 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico → **🔒6 PASA** (= M8). `C9 plantado difiere SI`, `C9 origen en 0 de 10` → el instrumento dispara.

**Paso 5. Regresión completa** (PRUEBAS a con `run_all()` completo sobre el estado final; PRUEBAS b; PRUEBAS c; y M9 sobre el motor final contra la línea base, como regresión de T1.3 y T2.3):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; bash /tmp/s33_build.sh faseR completo; git -C $R status --porcelain; bash /tmp/s33_pruebas_b.sh $M; echo "REGc $(bash /tmp/s33_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*" | cut -c15-)"; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33_m9.js $M > /tmp/s33_m9_final.json; python3 /tmp/s33_cmp_m9.py /tmp/s33_m9_fase0.json /tmp/s33_m9_final.json'
```
esperado: REGa `rc=0 warn=0 pasos_ok=5`, motor `5a83f63c…` (= `HEAD`: mismo día, misma plantilla), porcelain solo el LOG; REGb modales `true`/`true`, ficha y comparación sin errores, 0 `pageerror`; REGc `eb4e00b3…`; M9 `DistBar` y tooltips idénticos a la línea base, 0 errores.
obtenido: `REGa: rc=0 warn=0 pasos_ok=5`, motor `5a83f63cec4a5bfaf1213e554512ac64` (= `HEAD`), `:root` `65`/`04b2876e2bcece41f09398f28f6fc41d`, porcelain `?? …s33_log.md` (solo el LOG); `REGb`: `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `errores: []`, `glosa_existe: true`; comparación `errores: []`, `desbordadas: 0`; `REGc: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; M9 final: `errores 0/0`, `distbar … lista_identica True`, `tooltip ficha fija … md5 771f9710/771f9710 lineas_identicas True`, los tres puntos con `html_igual True` y `tt_igual True` → **regresión PASA**.

**Paso 7. Veredicto por hallazgo.**
- **0 BLOQUEA; 0 REPARA.** Los controles positivos (C1–C9 y los de la re-derivación: motor sin respaldo, motor sin descarte, motor de FASE 0) prueban que cada instrumento dispara; "0 hallazgos reparables" va junto a ellos.
- **A-1 (ADVIERTE, redacción del encargo):** el paso 1 de T5 pide porcelain "vacío", inalcanzable por construcción (el LOG se commitea en FASE L y los builds temporales que el encargo manda en T1, T2 y T4 dejan el motor ` M`, que es el ALCANCE de T5). Se midió con un esperado explícito (motor + LOG, nada más) y T5 siguió. Sin efecto sobre la meta.
- **A-2 (ADVIERTE, para el gate visual):** el anillo de `.ficha-name` que fija el encargo (`--foco`) da 1,84:1 sobre la barra de la ficha (`--azul`), bajo el 3:1 de WCAG 2.2 (1.4.11). El foco está en el nombre (T4.2 cumple), pero el anillo se ve poco. Repararlo cambiaría la regla CSS del encargo: no se repara.
- **A-3 (ADVIERTE, sin efecto sobre la meta):** con 10 de 10, si el comparador se cierra con **clic** en Listo (o se elige la fila con clic en el territorio), el foco queda en el respaldo **sin anillo**: `:focus-visible` sigue la modalidad del último gesto. Con Escape, con Enter o Espacio sobre Listo, o con clic en el fondo tras usar el teclado, el anillo aparece. Importa para el gate: el titular debe cerrar con teclado.
- **Nota de diseño D-A1** (no es hallazgo): el descarte de la autorrepetición cubre también el respaldo; verificado con `sostenido` y con su control plantado.

**Paso 8.** Sin ciclos de reparación (0 de 2).

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `git rev-parse 24087e1~1`; `git log` | padre `d046c9c` = `origin/main`; 6 commits | igual | — | ninguna | — | — |
| R-02 | §8.2 constante; calibrado | `/tmp/s33_r_payload.py` (Python) | `eb4e00b3…`; plantado distinto | igual; `1c3799e2…` | — | ninguna | — | C3 |
| R-03 | `:root` sin cambio | `/tmp/s33_r_root.py` (Python), `<inicio>` y `HEAD` | 65; `04b2876e…` | igual | — | ninguna | — | C2 |
| R-04 | caso malo (M5/T4.6) | `/tmp/s33_r_foco.js` sobre el motor de FASE 0 (otras rutas) | `BODY` | `BODY` ×3 | — | ninguna | — | control sin respaldo |
| R-05 | M6: botones ausentes | `/tmp/s33_r_foco.js` (`cmp_add` tras desmarcar; ficha abierta) | 0 con 10 de 10; 1 al desmarcar | igual | — | ninguna | — | — |
| R-06 | conteos de partida (M7) | `awk index()` sobre `<inicio>` | 2; 3; 1; 0; 0 usos | igual | — | ninguna | — | C8 |
| R-07 | 🔒6 (M8/T4.5/T5) | script de M8 sobre el motor final, dos modos | = M8 | = M8 | — | ninguna | — | C9 |
| R-08 | `DistBar` y tooltip sin cambio | código de `DistBar`, `vtTexto`, `h += …`, `gl`/`sg` entre `<inicio>` y `HEAD`; M9 final | idénticos | idénticos | — | ninguna | — | — |
| R-09 | calibración de 🔒2(b)/🔒3 | `/tmp/s33_r_diff.py` (Python) | hex +0/−1; `sigdifgru` +0/−1 | igual | — | ninguna | — | C1, C5 |
| R-10 | `_txtOn` retirado | `awk` de `_txtOn`, y de `txtOn` sin guion en el motor | 0; 0; `_hx(` 2 | igual | — | ninguna | — | C8 |
| R-11 | `const col` retirado | `awk`; Python sobre el diff | 0; `const sg` 1; −1 = `const col` | igual | — | ninguna | — | C5 |
| R-12 | T4.1 `.cmp-cl` | Región con Espacio, Listo con Espacio; `:focus` y `:focus-visible` | `SPAN.cmp-cl`; `solid 2px` | igual; anillo 5,99 | — | ninguna | — | control sin respaldo |
| R-13 | T4.2 `.ficha-name` | tercera fila de "liceo" con Espacio | `DIV.ficha-name` | igual; anillo 1,84 | ADVIERTE (A-2) | nota al titular | — | Python 1,84 |
| R-14 | T4.3 `.cmp-add` | desmarcar con Espacio y cerrar con Escape | `BUTTON.cmp-add` | igual | — | ninguna | — | — |
| R-15 | T4.4 sin trampa | Shift+Tab desde el respaldo | control anterior, no `BODY` | `lvl-b`, `cmp-x`, `screen-tab` | — | ninguna | — | — |
| R-16 | D-A1 | `sostenido` y copia sin descarte | cerrado; reabre sin D-A1 | igual | — | ninguna | — | control sin descarte |
| R-17 | T3 | `awk`; `git diff --numstat`; literal en Python | 0; 1; 1; `6 3`; igual | igual | — | ninguna | — | — |
| R-18 | T5 build y testigo | md5 con `hashlib` en `HEAD`; `awk` del testigo | `5a83f63c…`; 4/0 | igual | — | ninguna | — | — |
| A-1 | T5.1 "vacío" | porcelain | motor + LOG | motor + LOG | ADVIERTE | nota (redacción) | — | — |
| A-3 | anillo tras cierre con clic | `/tmp/s33_foco.js` (`tope_listo`, `terr_ee_clic`) | — | sin anillo | ADVIERTE | nota para el gate | — | — |
| 🔒1–🔒6 | invariantes | `/tmp/s33_final.sh`; script de M8 | ver pasos 3 | 6/6 PASA | — | — | — | C1–C9 |
| ALC | alcance global | lista explícita + `grep -vxF` | 0 fuera | 0 (3 rutas + encargo en `24087e1`) | — | — | — | C4 |
| REG | PRUEBAS a, b, c (+ M9) | `run_all()`; PRUEBAS b; §8.2 | `rc=0`, árbol limpio; 0 errores; `eb4e00b3…` | igual | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/0/3 (A-1, A-2, A-3). Ciclos de reparación usados: 0 de 2.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** ninguno.

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 6 respecto de `origin/main` (`24087e1`, `6025d20`, `1fbc9d1`, `f58761c`, `b1dafe4`, `f4ad2e0`).
obtenido: `?? 50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md` (única); `## main...origin/main [ahead 6]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33 (limpieza de código sin uso y destino de respaldo del foco). Fases: FASE 0, T1, T2, T4, T3, T5, R y L, en ese orden. Estado del grafo: T1 completada (`6025d20`) · T2 completada (`1fbc9d1`) · T4 completada (`f58761c`) · T3 completada (`b1dafe4`) · T5 completada (`f4ad2e0`) · FASE R APROBADO CON ADVERTENCIAS (sin reparaciones) · FASE L completada. Sin gates; ninguna tarea congelada.
2. **Commits** (`git log d046c9c..HEAD --oneline`, antes del commit de este log):
   - `24087e1` chore(encargo): s33 (= `<inicio>`)
   - `6025d20` chore(motor): retira _txtOn sin uso (s33 T1, D-1 de s32g)
   - `1fbc9d1` chore(motor): retira const col sin uso del tooltip (s33 T2, A-3 de s32g)
   - `f58761c` fix(motor): destino de respaldo del foco al cerrar el modal sin origen (s33 T4, A-1 de s32e)
   - `b1dafe4` docs(decision): encabezado de §5 y estado al día (s33 T3, A-1 de s32g)
   - `f4ad2e0` build(motor): s33 limpieza y respaldo del foco (motor `5a83f63cec4a5bfaf1213e554512ac64`)
   - (este log: `docs(log): s33 limpieza y respaldo del foco`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/3; reparados 0.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, T1, T2, T4, T5 y la regresión) · 🔒2 PASA (`:root` `65`/`04b2876e…` sin cambio; hex en líneas cambiadas: agregadas 0, borradas 1, la segunda línea de `_txtOn`) · 🔒3 PASA (`sigdifgru`: borrada 1 = `const col=…`, agregadas 0; `const sg=` 1) · 🔒4 PASA (0) · 🔒5 PASA (0) · 🔒6 PASA (= M8 con ventana y headless, en FASE 0, T4, T5 y FASE R). 6/6.
5. **Decisiones del titular en gates:** ninguna (no hubo gates).
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0 y en los builds de T1 (`3216cd89…`), T2 (`0228a0c8…`), T4 (`5a83f63c…`), T5 (`5a83f63c…`) y la regresión (`5a83f63c…`). Motor `4b28a03f…` → `5a83f63cec4a5bfaf1213e554512ac64`; `docs/` sin cambios (`4b28a03fdaa00bd5dbb0a6fc501eab72`). Destino del foco en los cuatro casos de M5 (con ventana y headless, idénticos):

   | caso | antes (motor de FASE 0) | después (`f4ad2e0`) |
   |---|---|---|
   | comparador, 10 de 10 con teclado, cierre con clic en Listo | `BODY` | `SPAN.cmp-cl` (sin anillo: gesto de ratón, A-3) |
   | comparador, 10 de 10, cierre con Escape | `BODY` | `SPAN.cmp-cl`, anillo `solid 2px` (5,99:1) |
   | comparador, 10 de 10, cierre con clic en el fondo | `BODY` | `SPAN.cmp-cl`, anillo `solid 2px` |
   | territorio, establecimiento elegido con Enter | `BODY` | `DIV.ficha-name`, anillo `solid 2px` (1,84:1, A-2) |
   | (T4.3) comparador, desmarcar una en el tope y Listo | `BODY` | `BUTTON.cmp-add` |
   | (T4.4) un Tab desde el respaldo | — | `cmp-x` / `lvl-b` / `cmp-reset`, posterior, fuera del modal |

   Sin cambio: `DistBar` (58 segmentos, md5 `5cf6b3b9…`) y los 36 tooltips de la ficha fija (md5 `771f9710…`) y los tres puntos "vs GSE" (`▲ +8 · sig.`, `▼ -4 · sig.`, `▲ +3 · n.s.`), idénticos antes y después.
7. **Dudas y pendientes consolidados:**
   - **A-2:** el anillo de `.ficha-name` (`--foco`, fijado por el encargo) da 1,84:1 sobre la barra de la ficha (`--azul`), bajo el 3:1 de WCAG 2.2 (1.4.11); el token de texto de la barra, `--cream`, daría 11,01. ¿Se cambia el anillo de `.ficha-name` a un token claro ya existente (por ejemplo `--cream`) en el próximo encargo? (sí/no). Bloquea: nada (el foco llega al nombre).
   - **A-1:** el paso 1 de T5 pedía porcelain "vacío", inalcanzable por construcción (LOG sin seguimiento y motor modificado por los builds temporales que el encargo manda). ¿Los próximos encargos escriben ese paso como "solo el motor y el LOG", como en s32e y s32g? (sí/no). Bloquea: nada.
   - **A-3 (nota para el gate):** tras un cierre con **clic** (Listo, o la fila en el territorio) el respaldo recibe el foco sin anillo, porque `:focus-visible` sigue el último gesto. Para ver el anillo, cerrar con teclado.
   - **Propuestos por el encargo para el siguiente** (excluidos de s33): 6 (desborde de pestañas) y 8 (desmarcar con el tope).
   - **Testigo del próximo despliegue:** `grep -c 'focoRespaldo'` → `4` en el motor (≥ 1) y `0` en `docs/index.html`; `grep -c '_txtOn'` en el motor → `0`. md5 del motor a desplegar: `5a83f63cec4a5bfaf1213e554512ac64`.
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:**
   - (1) M9, primera corrida: el instrumento buscaba la ficha por un RBD de 2 dígitos y la lista de búsqueda corta en 60; se corrigió el instrumento (busca por nombre y elige por RBD). Costo: una corrida, unos 2 minutos.
   - (2) T3: el chequeo literal unía las líneas 17-21 en vez de 16-20 (falló con `ValueError`); se re-midió. Costo: una re-medición.
   - (3) T3, paso 0: anoté el campo Estado como L9-L18; era L8-L17. Corregido con una línea nueva (que es un `obtenido:` sin `esperado:` propio; ver paso 5).
   - Ningún error de instrumento con efecto sobre una cifra; ningún error en el código del motor.
9. **Notas para el revisor:**
   - (a) Gate visual, comparador: llegar a 10 de 10 con teclado (Tab y Enter o Espacio sobre las filas) y cerrar con **Escape** o con Enter/Espacio sobre Listo: el foco queda en el contador "Entidades a comparar · 10 de 10", con anillo. Un Tab lleva a la ✕ del primer chip.
   - (b) Gate visual, territorio: elegir un establecimiento en la pestaña Establecimiento: el foco queda en su nombre, en la cabecera de la ficha; el anillo se ve poco sobre la barra oscura (A-2).
   - (c) Desmarcar una entidad estando en 10 de 10 y cerrar: el foco vuelve al botón "+ agregar entidad" (reaparece como nodo nuevo); mantener Enter apretado sobre Listo no reabre el modal (D-A1).
   - (d) Con el botón de origen presente, todo sigue como en s32e (🔒6).
   - (e) Nada se desplegó.
10. **Estado de cierre:** commiteados `24087e1`, `6025d20`, `1fbc9d1`, `f58761c`, `b1dafe4`, `f4ad2e0` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33_priv.sh`: RUT con el patrón del encargo en una variable y control plantado en un archivo aparte; "RBD" seguido de número; nombres de establecimiento, descontando los términos genéricos de búsqueda de los instrumentos —"escuela" y "liceo" entre comillas—, con el conteo bruto a la vista; nombre de la estación):
```
bash /tmp/s33_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0` (el conteo bruto solo cuenta las líneas con los términos genéricos entre comillas); `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; **`establecimientos por nombre: 4`** (bruto 7); `estación por nombre: 0`. Las 4 líneas que quedan (L260, L266, L270, L271) contienen `terr_liceo`, el **nombre de una acción** de `/tmp/s33_r_foco.js`, no un establecimiento; mi esperado no contemplaba ese identificador (error propio de planteamiento). Re-medición descontándolo, abajo.
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md; sed "s/\"escuela\"//g; s/\"liceo\"//g; s/terr_liceo//g" $L | grep -ciE "liceo|escuela|colegio|complejo educacional|instituto"'
```
esperado: `0`.
obtenido: `1`: la única línea es **la del propio comando** anexado arriba (L401), que contiene el patrón de búsqueda (autorreferencia; el script de s32g evitaba esto guardando el patrón fuera del log). Fuera de esa línea y del identificador `terr_liceo`, el log no contiene ningún término de establecimiento, ningún RBD con número, ningún RUT ni el nombre de la estación. El establecimiento de M9 se registra como "primer establecimiento del roster de 4b" (fila 17) y el del punto −1 como "fila 29 del roster"; la estación, como "estación del titular". **Privacidad: PASA.**
- **Errores propios, anexo al punto 8 del Cierre:** (4) el esperado de privacidad no descontaba el identificador `terr_liceo` ni la línea del propio comando de re-medición (autorreferencia); sin efecto (ningún nombre en el log). Costo: dos re-mediciones. Total de errores propios: 4.

Paso 5, primera medición (antes de rellenar el J y de este párrafo): `### FASE` = 8 (FASE 0, T1, T2, T4, T3, T5, R, L); **`^esperado:` = 26 y `^obtenido:` = 27**; `## J` = 1. Causa: la corrección del paso 0 de T3 (L186) es una línea nueva `obtenido:` que corrige un registro anterior (regla 9 de FASE R: no se edita evidencia) y no tuvo `esperado:` propio. Se anexa lo faltante con su estado real:
esperado: (anexo de formato, escrito después, para la corrección de L186) ninguno previo: la línea corrige el rango del campo Estado que anotó el paso 0 de T3; su contenido se verificó contra `git show HEAD:<decisión>` (L8 = `- **Estado:** …`, L17 = `  enmienda de la línea de contraste.`).

Segunda medición:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md; ls -l $L && wc -l $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(sed -n "/^## J/,/^## Registro/p" $L | grep -c "^- ")"; bash /tmp/s33_priv.sh | head -1'
```
esperado: `FASE=8`; `esperado=28` y `obtenido=27` al medir (este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `78993` bytes y `426` líneas al medir; `FASE=8 esperado=28 obtenido=27 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **28 = 28**.
