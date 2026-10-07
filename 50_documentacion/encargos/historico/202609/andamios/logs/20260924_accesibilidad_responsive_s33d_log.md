# Log de sesión: accesibilidad, ancho angosto y dos ajustes del modal y del comparador (s33d)

- **Meta:** que el ✕ de quitar pase a `--alerta-txt` al pasar el ratón (T1); que la barra de pantallas no desborde la página bajo 480 px (T2, pendiente 6); que el chip marque el año preliminar (T3, A-5 de s33c); que al cambiar de pestaña el foco se quede en la pestaña (T4, A-6 de s33c); regenerar el motor (T5). Nada cambia a 1280 px. Sin despliegue.
- **Fecha:** 2026-09-24
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `55d4701` (= `origin/main`, `docs(log)` de s33c). Medición previa al primer acto, en solo lectura: `git fetch origin` rc=0; `git status --porcelain` = ` M 50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (+2 líneas: las filas 3 y 4 del redactor) y `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_accesibilidad_responsive_s33d.md` (las dos rutas que admite la regla 1); `git stash list` vacío; `HEAD=55d4701 origin/main=55d4701`; `HEAD..origin/main=0`, `origin/main..HEAD=0`. Primer acto (autorizado): commit `0688dd9` chore(encargo): s33d y registro del asistente s33, hijo de `55d4701`. **PUNTO DE RETORNO `<inicio>` = `0688dd9`.** Porcelain, stash y `rev-parse` después del primer acto: en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script en `/tmp/s33d_*`); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`); pruebas de teclado y foco **con ventana** (`headless: false`) y en headless; con ventana, antes de la primera acción de cada corrida, `waitForSelector` con `visible:true` del elemento de la acción (A-3 de s33c).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`; la sesión tiene `ultracode` activo, pero el encargo y el mensaje del titular mandan sobre el modo: **sin subagentes ni workflows**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_accesibilidad_responsive_s33d.md` (commit `0688dd9`, junto con el registro del asistente s33).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (hover del ✕ en --alerta-txt)         ALCANCE: 30_procesamiento/35_motor_template.html
T2 (barra de pestañas angosta)           ALCANCE: ídem; en serie después de T1
T3 (año preliminar en el chip)           ALCANCE: ídem; en serie después de T2
T4 (el foco se queda en la pestaña)      ALCANCE: ídem; en serie después de T3
T5 (build)                               ALCANCE: 40_salidas/motor_idps.html; requiere al menos una de T1–T4
FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s33d_*`; se copian de `/tmp/s33c_*` (siguen en `/tmp`). Convenciones de este log: **un `esperado:` y un `obtenido:` por comando** (lección de s33c); una corrección de evidencia va como `- **Corrección:** …`; los patrones del control de privacidad viven solo en su script.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: el ✕ de quitar pasa de 4,11 a 5,61 con hover; la página ya no desborda a 320 ni a 360 px (+51 y +11 antes); el chip marca el año preliminar; al volver de Nacional el foco queda en la pestaña; nada cambia a 1280 px → cumplida.
- Estado por tarea: FASE 0 completada · T1 completada (`a198d8b`) · T2 completada (`bee0bad`, con gate H-1) · T3 completada (`be5945f`) · T4 completada (`8353951`) · T5 completada (`1444922`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 7, rango `0688dd9`..`<docs(log)>` (`git log --oneline 55d4701..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/2; reparados 0; abiertos 2: A-1, el desborde estaba bajo 371 px y no a 390 (resuelto en gate); A-2, a 320 px la pestaña más ancha se ve desplazando la barra.
- Invariantes: 7/7 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒2 `:root` `04b2876e…` y hex +0/−0; 🔒3 0/0; 🔒4 0; 🔒5 0; 🔒6 AE = 0 a 1280 en la barra y el chip; 🔒7 = M8 en los dos modos); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, T1 a T5 y la regresión, re-derivado en Python; censo de s33c con 133 cifras idénticas).
- Decisiones autónomas de mayor riesgo: (1) T2 con la variante B, elegida midiendo tres: 12 px de padding (mínimo con el que la pestaña más ancha cabe entera a 360) y scroll dentro de la barra solo para 320; (2) T4 con una bandera `useRef` que el primer montaje consume, sin mover la lectura del origen; (3) `max-width:100%` en `.screen-tabs`, necesario para que `overflow-x:auto` actúe en un ítem flexible.
- Desviaciones respecto del encargo: el criterio de T2 se midió a 320, 360, 390, 412 y 425 px por decisión del titular (H-1); ninguna en el grafo ni en las autorizaciones.
- Dudas abiertas: 1: A-2 ¿se acepta que a 320 px la pestaña más ancha se vea desplazando la barra, o se acorta su rótulo en otro encargo? (acepta/acorta).
- Errores propios: 0 con efecto; dos detalles de proceso declarados (un script probado antes de su esperado; un patrón `awk` sin efecto quitado antes de correr).
- Qué debe verificar el revisor por sí mismo: el gate visual en el celular o con la ventana a 390 px. La barra con menos padding; a 360 y 320 sin desplazamiento lateral de la página. El ✕ en rojo oscuro al pasar el ratón. El foco en la pestaña al volver de Nacional. Esta sesión midió anchos, colores y foco; la percepción no.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `:hover{color:var(--alerta-txt)`: 2 en el motor, 0 en `docs/`; md5 `08c22714954617d454618a1d647f1be4`). El push, según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo; `ultracode` activo en la sesión, pero sin workflows ni subagentes: el encargo manda; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `0688dd9` (primer acto).

**Instrumentos** (copiados de `/tmp/s33c_*`, que siguen en `/tmp`): §8.2 (`/tmp/s33d_payload_sha.sh` → `…_payload_norm.js`, `…_fecha_alterada.js`, `…_plantar_payload.js`), `:root` (`/tmp/s33d_root_md5.sh`), 🔒2(b)/🔒3 (`/tmp/s33d_hex.sh`, `/tmp/s33d_sig.sh`, `/tmp/s33d_arbol.sh`, con `I=0688dd9`), build (`/tmp/s33d_build.sh`), PRUEBAS b (`/tmp/s33d_pruebas_b.sh`), 🔒7 (`/tmp/s33d_l6.js` y `/tmp/s33d_foco.js`, con sus resumidores), y el censo de s33c (`/tmp/s33d_censo.js`, `/tmp/s33d_censo_cmp.py`). **Cambio con efecto (espera de POSICIÓN, A-3 de s33c):** en `/tmp/s33d_l6.js` y `/tmp/s33d_foco.js`, la carga espera `.terr-trigger` **visible**, y cada apertura de modal espera el botón visible antes del clic y el modal (o su buscador) visible después, en lugar de una pausa fija.

**M1 a M3** (el motor de FASE 0 se guarda en `/tmp/s33d_motor_fase0.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; echo "mensaje de HEAD~1: $(git -C $R log -1 --format=%s HEAD~1)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s33d_motor_fase0.html; echo "motor $(md5 -q $M) docs $(md5 -q $R/docs/index.html)"; bash /tmp/s33d_payload_sha.sh /tmp/s33d_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33d_fecha_alterada.js /tmp/s33d_motor_fase0.html /tmp/s33d_motor_fecha.html; bash /tmp/s33d_payload_sha.sh /tmp/s33d_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s33d_plantar_payload.js /tmp/s33d_motor_fase0.html /tmp/s33d_motor_plantado.html; bash /tmp/s33d_payload_sha.sh /tmp/s33d_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s33d_root_md5.sh $R/30_procesamiento/35_motor_template.html'
```
esperado: M1 solo este LOG, `stash: []`; M2 `fetch rc=0`, `HEAD=0688dd9`, padre `55d4701` = `origin/main`, `0`, `1`, mensaje que empieza por `docs(log): s33c`; M3 motor `5825cc14…`, `docs` `4b28a03f…`, §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; `:root` `lineas: 65; md5 04b2876e…`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260924_accesibilidad_responsive_s33d_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=0688dd9 padre=55d4701 origin/main=55d4701`, `HEAD..origin/main=0 origin/main..HEAD=1`, `mensaje de HEAD~1: docs(log): s33c modal y comparador`; M3 `motor 5825cc14c9f625287733e5780c1a0f0b docs 4b28a03fdaa00bd5dbb0a6fc501eab72`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada → igual, cifra plantada → `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. Reglas 1 y 2 no disparan; valores de 🔒1 y 🔒2.

**M4 — reglas de hover en `--alerta` y botones de quitar** (búsqueda por marcadores: el patrón del encargo, los `aria-label` que empiezan por "Quitar" y las reglas CSS de cada clase y de su contenedor):
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; echo "patron del encargo:"; grep -n ":hover{color:var(--alerta)" $T; echo "hover con --alerta (cualquier forma): $(grep -c ":hover{[^}]*--alerta" $T)"; echo "botones con aria-label Quitar:"; grep -n "aria-label={\"Quitar\|aria-label=\"Quitar" $T | sed -E "s/^([0-9]+):.*(className=\"[a-z-]+\"|<button onClick).*/\1: \2/"; for c in "\.sel-chip{" "\.sel-chip button" "\.cmp-chip{" "\.cmp-x" "\.modal-sel{" "\.modal-sel-b"; do grep -n "^  $c" $T | cut -c1-150; done'
```
esperado: el patrón da `.sel-chip button` y `.cmp-x`; botones de quitar: el de `.sel-chip` (dependencia en el panorama), `.cmp-x` (chips del comparador) y `.modal-sel-b` (franja de s33c); los contenedores `.sel-chip` y `.cmp-chip` con `background:var(--paper)`; `.modal-sel-b` con hover en otro token (no `--alerta`).
obtenido: patrón del encargo: **L199 `.sel-chip button:hover{color:var(--alerta);}`** y **L559 `.cmp-x:hover{color:var(--alerta);}`**; `hover con --alerta (cualquier forma): 2`. Botones con `aria-label` "Quitar…": L1698 `modal-sel-b` (franja de s33c), L1989 `cmp-x` (chips del comparador), L3041 el `<button>` dentro de `.sel-chip` (quitar la dependencia en el panorama). Contenedores: `.sel-chip` (L195) y `.cmp-chip` (L549) con `background:var(--paper)`; `.modal-sel-b` (L235-L236): fondo `var(--paper)` y hover **`border-color:var(--foco)`** (no toca el color del texto ni usa `--alerta`). Las reglas que T1 debe tocar son dos: L199 y L559. Coincide.

**M5 — caso malo de T1** (instrumento nuevo `/tmp/s33d_hover.js`, headless: `:hover` **forzado por CDP** (`CSS.forcePseudoState`) sobre el botón de `.sel-chip` —dependencia "Municipal" elegida en el panorama, pestaña Comuna, primera comuna—, sobre `.cmp-x` —comparador con 10 regiones— y, como dato, sobre `.modal-sel-b`; color calculado sin y con hover y contraste WCAG 2.1 contra el fondo opaco del contenedor; además los valores de `--alerta`, `--alerta-txt`, `--paper` y `--gris`):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33d_hover.js /tmp/s33d_motor_fase0.html'
```
esperado: con hover, `.sel-chip button` y `.cmp-x` en el `rgb` de `--alerta` con **4,11** (< 4,5) sobre el fondo de `--paper`; sin hover, en `--gris`; `.modal-sel-b` con hover no cambia de color; 0 errores.
obtenido: 0 errores. Tokens: `--alerta #EE2D49`, `--alerta-txt #CE112C`, `--paper #ffffff`, `--gris #5C666E`. **`.sel-chip button`**: sin hover `rgb(92, 102, 110)` (5,86); **con hover `rgb(238, 45, 73)` sobre `rgb(255, 255, 255)`, 4,11**. **`.cmp-x`**: sin hover `rgb(92, 102, 110)` (5,86); **con hover `rgb(238, 45, 73)`, 4,11**. `.modal-sel-b`: `rgb(35, 48, 58)` con y sin hover (su hover cambia el borde; el fondo medido es el de la franja, `rgb(255, 253, 247)`, 13,27). **Caso malo confirmado** (regla 6 no dispara para T1).

**M6 — caso malo de T2** (instrumento nuevo `/tmp/s33d_ancho.js`, headless: el motor se abre con el viewport ya en el ancho, alto 800; en cada pantalla, con remount —se pasa por otra pantalla y se vuelve—, mide `scrollWidth` e `innerWidth`, el ancho y el borde derecho (`ancho/derecho`) de `.app-nav-inner`, `.screen-tabs` y cada `.screen-tab`, y el elemento con el mayor borde derecho de la página y si está en la barra; resumen `/tmp/s33d_ancho_resumen.py`):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33d_ancho.js /tmp/s33d_motor_fase0.html 390,412,425 > /tmp/s33d_m6.json; python3 /tmp/s33d_ancho_resumen.py /tmp/s33d_m6.json'
```
esperado: a 390 px, en las tres pantallas, `scrollWidth` > `innerWidth`, y el elemento con el mayor borde derecho está en la barra (una `.screen-tab`); a 412 y 425 se registra lo que haya; 0 errores.
obtenido: 0 errores. **A 390, 412 y 425 px, en las tres pantallas: `scrollWidth` = `innerWidth` (390/390, 412/412, 425/425), exceso 0.** `.app-nav-inner` ocupa todo el ancho (390/390…); `.screen-tabs` 347/371 a 390 px (364/388 a 412; 377/401 a 425); cada pestaña `208/232`, `347/371`, `291/315` (ancho/borde derecho): con `flex-wrap:wrap` se apilan una por línea y la más ancha ("Panorama IDPS por establecimiento") cabe. El elemento con el mayor borde derecho es `header.app` (= `innerWidth`), fuera de la barra. **El caso malo de T2 no se reproduce.**

**M6b (control del instrumento y dato, propio)**: una copia del motor de FASE 0 con `.screen-tabs` en una sola línea (`flex-wrap:nowrap` inyectado al final del CSS, solo en la copia) debe desbordar a 390 px; y el motor real se mide además a 320 y 360 px:
```
bash -c 'python3 -c "s=open(\"/tmp/s33d_motor_fase0.html\",encoding=\"latin-1\").read(); i=s.index(\"</style>\"); open(\"/tmp/s33d_motor_nowrap.html\",\"w\",encoding=\"latin-1\").write(s[:i]+\".screen-tabs{flex-wrap:nowrap !important}\"+s[i:])"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33d_ancho.js /tmp/s33d_motor_nowrap.html 390 > /tmp/s33d_m6b_nowrap.json; python3 /tmp/s33d_ancho_resumen.py /tmp/s33d_m6b_nowrap.json; node /tmp/s33d_ancho.js /tmp/s33d_motor_fase0.html 320,360 > /tmp/s33d_m6b.json; python3 /tmp/s33d_ancho_resumen.py /tmp/s33d_m6b.json'
```
esperado: (propio) la copia `nowrap`: exceso > 0 a 390 px, con el mayor borde derecho en una `.screen-tab` (el instrumento dispara); el motor real a 320 y 360 px: se registra lo que haya.
obtenido: 0 errores. **Control `nowrap` a 390 px:** `scroll 871 inner 390 exceso 481`, mayor borde derecho en `div.screen-tabs < div.app-nav-inner < nav.app-nav` (`barra True`), las tres pestañas en fila (`208/232 347/580 291/871`): **el instrumento dispara**. **Motor real a 320 px:** `scroll 371 inner 320` → **exceso 51** en las tres pantallas; **a 360 px:** `scroll 371 inner 360` → **exceso 11**; en los dos, el mayor borde derecho es `div.screen-tabs` (`barra True`), por la pestaña más ancha (347 px + 24 px del padding izquierdo de `.app-nav-inner` = 371 px). **Hallazgo H-1:** el desborde de la barra existe, pero **por debajo de 371 px** (360 y 320), no a 390, 412 o 425, que es donde el encargo lo esperaba (M6) y donde mide T2.1. Al pie de la letra, la regla 6 omite T2. Se lleva al titular como gate al empezar T2, con la alternativa de corregirlo midiendo a 360 y 320 px (los mismos anchos de T2.1 más estos dos).

**M7 — capturas de 🔒6** (instrumento nuevo `/tmp/s33d_captura.js`: viewport 1280 × 800, tras `document.fonts.ready` y con el ratón fuera, captura `nav.app-nav` y el primer `.cmp-chip` —comparador con la primera región—; `/tmp/s33d_ae.sh` compara con `magick compare -metric AE`). Calibración: dos corridas sobre el motor de FASE 0 (`f0` y `f0b`) y una copia con la barra y el chip cambiados en 1 px de padding (`.screen-tab{padding:14px 19px}` y `.cmp-chip{padding:9px 12px}` inyectados al final del CSS, solo en la copia):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33d_captura.js /tmp/s33d_motor_fase0.html f0; node /tmp/s33d_captura.js /tmp/s33d_motor_fase0.html f0b; python3 -c "s=open(\"/tmp/s33d_motor_fase0.html\",encoding=\"latin-1\").read(); i=s.index(\"</style>\"); open(\"/tmp/s33d_motor_pad.html\",\"w\",encoding=\"latin-1\").write(s[:i]+\".screen-tab{padding:14px 19px !important}.cmp-chip{padding:9px 12px !important}\"+s[i:])"; node /tmp/s33d_captura.js /tmp/s33d_motor_pad.html pad; bash /tmp/s33d_ae.sh f0 f0b; bash /tmp/s33d_ae.sh f0 pad'
```
esperado: dos PNG de referencia (`/tmp/s33d_cap_barra_f0.png`, `/tmp/s33d_cap_chip_f0.png`); `f0` contra `f0b`: `AE=0` en los dos (determinista); `f0` contra `pad`: `AE` > 0 en los dos (el comparador dispara); 0 errores.
obtenido: 0 errores; chip capturado: `Tarapacá 7 comunas · 103 establecimientos con IDPS en 4° básico 2025 ✕`. `f0` vs `f0b`: **`barra: 1280x55 … AE=0 (0)`**, **`chip: 280x76 … AE=0 (0)`** (determinista). `f0` vs `pad`: `barra … AE=2418.24`, `chip … AE=900.366` (el comparador dispara). Referencias de 🔒6: `/tmp/s33d_cap_barra_f0.png` y `/tmp/s33d_cap_chip_f0.png`.

**M8 — líneas base de 🔒7** (`/tmp/s33d_l6.js` y `/tmp/s33d_foco.js`, ya con la espera visible, sobre el motor de FASE 0, en los dos modos; el `sed` final solo acorta la salida del resumidor):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33d_motor_fase0.html; for m in ventana headless; do node /tmp/s33d_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33d_m8_l6_$m.json; python3 /tmp/s33d_l6_resumen.py /tmp/s33d_m8_l6_$m.json; done; for m in ventana headless; do node /tmp/s33d_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33d_m8_foco.jsonl; python3 /tmp/s33d_foco_resumen.py /tmp/s33d_m8_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/"'
```
esperado: las de s33c (T6 y FASE R): `terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` en los dos modos; respaldos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`; 0 errores, **sin fallas del instrumento con ventana** (primera prueba de la espera de POSICIÓN).
obtenido: `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; respaldos en los dos modos `SPAN.cmp-cl` ×3 (`tope_listo` sin anillo; `tope_escape` y `tope_fondo` `solid 2px`, `rgb(0, 98, 160)`), `DIV.ficha-name` (`rgb(255, 246, 224)`), `BUTTON.cmp-add`; 0 errores. **= s33c.** La corrida con ventana de `/tmp/s33d_foco.js` fue la primera del comando y pasó sin fallas del instrumento (la espera de POSICIÓN funciona en esta prueba).

**M9 — caso malo de T3** (instrumentos nuevos: `/tmp/s33d_forzar_prelim.js` copia el motor con `meta.anios_preliminar` del payload forzado a incluir 2025 —solo la copia, `/tmp/s33d_motor_prelim.html`; el árbol no se toca—; `/tmp/s33d_chip.js` lee la meta del chip de un territorio —comparador con la primera región— y, como prueba de que el año quedó preliminar en la copia, `PRELIM` y la línea del banner del panorama):
```
bash -c 'node /tmp/s33d_forzar_prelim.js /tmp/s33d_motor_fase0.html /tmp/s33d_motor_prelim.html 2025; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33d_chip.js /tmp/s33d_motor_prelim.html; node /tmp/s33d_chip.js /tmp/s33d_motor_fase0.html'
```
esperado: `anios_preliminar` pasa de `[]` a `[2025]`; en la copia, `PRELIM` = `["2025"]` y el banner dice `2025 (preliminar)`, pero la meta del chip termina en `con IDPS en 4° básico 2025` **sin** marca de preliminar; en el motor real, `PRELIM` vacío y la misma meta; 0 errores.
obtenido: `{"antes":"[]","despues":"[2025]"}`; **copia**: `prelim ["2025"]`, banner `60 establecimientos en el nivel seleccionado · 4° básico · 5 de 5 GSE · 2025 (preliminar)`, **chip `Tarapacá` → `7 comunas · 103 establecimientos con IDPS en 4° básico 2025`** (sin marca); **motor real**: `prelim []`, banner sin marca, la misma meta del chip; 0 errores. **Caso malo confirmado** (regla 6 no dispara para T3).

**M10 — caso malo de T4** (instrumento nuevo `/tmp/s33d_pestanas.js`, con ventana y headless, todo con teclado y con la espera visible: abrir cada modal con Enter sobre su disparador; Shift+Tab hasta la pestaña Nacional y Enter; Shift+Tab hasta Comuna y Enter; foco por `activeElement` y por `:focus` en cada paso):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s33d_pestanas.js /tmp/s33d_motor_fase0.html $m; done'
```
esperado: en los dos modales y los dos modos: al abrir, el foco en `INPUT.input-search`; en Nacional, en la pestaña (`BUTTON.modal-tab:Nacional`); **al volver a Comuna, en el buscador (`INPUT.input-search`), no en la pestaña**; 0 errores.
obtenido: con ventana y en headless, **idénticos**, 0 errores. En los dos modales: al abrir, `INPUT.input-search` (por `activeElement` y por `:focus`); en Nacional, `BUTTON.modal-tab:Nacional`; **al volver a Comuna, `INPUT.input-search`** (`buscador_montado: true`); cerrado con Escape. **Caso malo confirmado** (regla 6 no dispara para T4).

**M11 — calibración del testigo de T5** (cuatro cadenas candidatas, una por tarea, contadas con `grep -c -F` en `docs/index.html`, en el motor actual y en la plantilla):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; for P in ":hover{color:var(--alerta-txt)" "bajo 480px la barra de pantallas" "?\" (preliminar)\":\"\")" "el buscador toma el foco solo al abrir el modal" "s33d:"; do echo "[$P] docs $(grep -c -F "$P" $R/docs/index.html) motor $(grep -c -F "$P" $R/40_salidas/motor_idps.html) plantilla $(grep -c -F "$P" $R/30_procesamiento/35_motor_template.html)"; done'
```
esperado: una cadena de código de T1, `:hover{color:var(--alerta-txt)`, con `0` en `docs/`, `0` en el motor y `0` en la plantilla: se elige esa (aparecerá solo tras el build); las de comentario de T2 y T4 y `s33d:`, también en `0` (reservas). La de T3 (`?" (preliminar)":"")`) **no** sirve si ya existe en la ficha (se espera > 0).
obtenido: `[:hover{color:var(--alerta-txt)] docs 0 motor 0 plantilla 0`; `[bajo 480px la barra de pantallas] docs 0 motor 0 plantilla 0`; `[?" (preliminar)":"")] docs 1 motor 1 plantilla 1` (ya existe: es el de la cabecera de la ficha; no sirve); `[el buscador toma el foco solo al abrir el modal] docs 0 motor 0 plantilla 0`; `[s33d:] docs 0 motor 0 plantilla 0`. **Testigo elegido: `:hover{color:var(--alerta-txt)`** (código de T1; reservas: las de comentario de T2 y T4 y `s33d:`).

- **Estado de FASE 0:** completada. M1–M5 y M7–M11 coinciden con su esperado. **M6 no reproduce el caso malo** a 390, 412 y 425 px; el control del instrumento dispara y el desborde real aparece a 360 y 320 px (hallazgo H-1): va a gate al empezar T2. Ninguna otra regla dispara.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `0688dd9` (hijo de `55d4701` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno.

### FASE T1: el ✕ de quitar usa el token de texto al pasar el ratón

- **Paso 0:** M4 (dos reglas: `.sel-chip button:hover` L199 y `.cmp-x:hover` L559; `.modal-sel-b` no usa `--alerta`) y M5 (los dos en `rgb(238, 45, 73)`, 4,11, sobre `--paper` blanco). Los dos botones están sobre fondo claro: se tocan los dos.
- **Implementación:** en las dos reglas de M4, `color:var(--alerta)` → `color:var(--alerta-txt)` (L199 y L559). Nada más cambia.
- **Verificación** (build temporal; 🔒2(b)/🔒3 sobre el árbol con `/tmp/s33d_arbol.sh`; 🔒6 con las capturas de M7):
```
bash -c 'bash /tmp/s33d_arbol.sh t1; bash /tmp/s33d_build.sh t1; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33d_motor_t1.html; node /tmp/s33d_hover.js $M; node /tmp/s33d_captura.js $M t1 > /dev/null; bash /tmp/s33d_ae.sh f0 t1; bash /tmp/s33d_pruebas_b.sh $M'
```
esperado: `stat sin commitear: 1 file changed, 2 insertions(+), 2 deletions(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…`; `:root` `04b2876e…` (= M3). **T1 (M5 repetido):** con hover, `.sel-chip button` y `.cmp-x` en `rgb(206, 17, 44)` (`--alerta-txt`) con contraste **≥ 4,5** sobre blanco; sin hover, iguales a M5 (`rgb(92, 102, 110)`, 5,86). **🔒6:** `barra … AE=0` y `chip … AE=0` contra `f0`. PRUEBAS b sin errores; 0 errores.
obtenido: `stat sin commitear: 1 file changed, 2 insertions(+), 2 deletions(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; motor temporal `0ca07c5552ad55e467036026911e3e35`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. **T1:** `.sel-chip button` con hover **`rgb(206, 17, 44)` sobre `rgb(255, 255, 255)`, 5,61** (antes 4,11); `.cmp-x` con hover **`rgb(206, 17, 44)`, 5,61**; sin hover, los dos `rgb(92, 102, 110)`, 5,86 (= M5); `.modal-sel-b` sin cambio. **🔒6:** `barra: 1280x55 … AE=0 (0)`, `chip: 280x76 … AE=0 (0)`. PRUEBAS b: modales `true`/`true`, 0 errores, 0 `pageerror`; ficha y comparación sin errores.
- **Regresión:** build `rc=0`; 🔒6 sin cambio; PRUEBAS b sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "fix(motor): el boton de quitar usa --alerta-txt al pasar el raton (s33d T1)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R status --porcelain'
```
esperado: porcelain antes: ` M` plantilla (ALCANCE de T1), ` M` motor (temporal; va en T5) y el LOG; commit con solo la plantilla; después: motor y LOG.
obtenido: antes ` M` plantilla, ` M` motor, `?? …s33d_log.md`; **`a198d8b` fix(motor): el boton de quitar usa --alerta-txt al pasar el raton (s33d T1)** con la plantilla; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: la barra de pestañas cabe en pantallas angostas (pendiente 6)

- **Paso 0:** M6 (sin desborde a 390, 412 ni 425 px) y M6b (desborde por la barra a 360 px, +11, y a 320 px, +51; la pestaña más ancha mide 347 px con `padding:14px 18px`, o sea 311 px de texto, más 24 px de padding izquierdo de `.app-nav-inner`).
- **Gate del titular (H-1):** eligió **"Corregir a 360 y 320"**. T2 se hace con la edición del encargo; el criterio de T2.1 pasa a ser `scrollWidth` = `innerWidth` a **320, 360, 390, 412 y 425 px**, en las tres pantallas; T2.2 a 390 px, T2.3 (🔒6 a 1280) y T2.4 (el caso malo, ahora a 320 y 360 px, sobre el motor de FASE 0) quedan como estaban. Se registra como decisión del titular.
- **Elección de valores, midiendo** (el encargo pide "el mínimo cambio"). Solo con el padding, a 360 px hace falta que el de `.app-nav-inner` más el de `.screen-tab` sumen como máximo (360 − 311) / 2 = 24,5 px por lado (hoy suman 42); a 320 px, 4,5, que no es razonable. Se miden tres variantes sobre copias del motor de FASE 0 con el CSS inyectado dentro de `@media (max-width:480px)` (solo en las copias): **A** `.app-nav-inner{padding:0 12px}` y `.screen-tab{padding:14px 12px}`; **B** A más `.screen-tabs{overflow-x:auto;max-width:100%}`; **C** solo `.screen-tabs{overflow-x:auto;max-width:100%}`:
```
bash -c 'python3 -c "
s=open(\"/tmp/s33d_motor_fase0.html\",encoding=\"latin-1\").read(); i=s.index(\"</style>\")
v={\"A\":\".app-nav-inner{padding:0 12px}.screen-tab{padding:14px 12px}\",\"B\":\".app-nav-inner{padding:0 12px}.screen-tab{padding:14px 12px}.screen-tabs{overflow-x:auto;max-width:100%}\",\"C\":\".screen-tabs{overflow-x:auto;max-width:100%}\"}
for k,c in v.items(): open(\"/tmp/s33d_motor_var\"+k+\".html\",\"w\",encoding=\"latin-1\").write(s[:i]+\"@media (max-width:480px){\"+c+\"}\"+s[i:])"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for k in A B C; do node /tmp/s33d_ancho.js /tmp/s33d_motor_var$k.html 320,360,390 > /tmp/s33d_var$k.json; python3 /tmp/s33d_ancho_resumen.py /tmp/s33d_var$k.json | grep -E "==|Panorama territorial" | sed "s/^/$k /"; done'
```
esperado: (propio) **A**: sin desborde a 360 y 390 px, todavía con desborde a 320 px (la pestaña más ancha, 335 px, en 296 px de contenedor); **B**: sin desborde en los tres anchos; **C**: sin desborde en los tres, pero con la pestaña más ancha recortada dentro de la barra también a 360 px. Se elige la variante más pequeña que cumple en los cinco anchos.
obtenido: **A** (solo padding): 320 px `exceso 27` (la pestaña más ancha, 335 px, en la barra), 360 y 390 px `exceso 0`. **B** (padding + scroll dentro de `.screen-tabs`): `exceso 0` a 320, 360 y 390 px; a 320 px la pestaña más ancha desborda **dentro** de la barra (`.screen-tabs` 296 px de ancho), a 360 y 390 px cabe entera (`tabs 336/348` y `366/378`). **C** (solo scroll): `exceso 0` en los tres, pero la pestaña más ancha queda recortada dentro de la barra ya a 360 px (371 frente a 336). 0 errores. **Se elige B:** A no alcanza a 320 px; C recorta desde 360. El padding de 12 px + 12 px es la reducción mínima con la que la pestaña más ancha cabe entera a 360 px (suma ≤ 24,5 px por lado); el scroll solo entra en juego bajo ~348 px. `max-width:100%` en `.screen-tabs` es lo que hace efectivo `overflow-x:auto` (sin él, el ítem flexible no se encoge por debajo de su contenido).
- **Implementación:** después de `.screen-tab.is-active`, el comentario pedido (`/* s33d: bajo 480px la barra de pantallas no desborda la pagina (pendiente 6 de v31). */`) y `@media (max-width:480px){ .app-nav-inner{padding:0 12px;} .screen-tab{padding:14px 12px;} .screen-tabs{overflow-x:auto;max-width:100%;} }`. No existía otra media query en el bloque de la barra. Sin cambios de tipografía ni de color.
- **Instrumento nuevo** `/tmp/s33d_tabs.js`: a un ancho dado, cada pestaña queda activa con clic; con teclado (foco en la primera, Tab a la siguiente, Enter) se activa y se registra si la pestaña enfocada queda visible dentro de la barra; además el scroll propio de `.screen-tabs`.
- **Verificación** (build temporal; tres comandos):
```
bash -c 'bash /tmp/s33d_arbol.sh t2; bash /tmp/s33d_build.sh t2; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33d_motor_t2.html; node /tmp/s33d_ancho.js $M 320,360,390,412,425 > /tmp/s33d_t2_ancho.json; python3 /tmp/s33d_ancho_resumen.py /tmp/s33d_t2_ancho.json | cut -c1-150; node /tmp/s33d_captura.js $M t2 > /dev/null; bash /tmp/s33d_ae.sh f0 t2'
```
esperado: `stat sin commitear: 1 file changed, 2 insertions(+)`; hex y `sigdifgru` `0/0`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…`; `:root` `04b2876e…`. **T2.1:** `exceso 0` a 320, 360, 390, 412 y 425 px en las tres pantallas (15 filas). **T2.3 (🔒6):** `barra … AE=0` y `chip … AE=0` contra `f0` (a 1280 px la media query no actúa).
obtenido: `stat sin commitear: 1 file changed, 2 insertions(+)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; motor temporal `0fe9085413f159125ed5e9e52d1d58cc`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`. **T2.1:** las 15 filas con **`exceso 0`** (320: `scroll 320 inner 320`, `.screen-tabs` 296/308; 360: 360/360, `tabs 336/348`; 390, 412 y 425: iguales a su ancho); pestañas `196/208 335/347 279/291`; 0 errores. **T2.3 (🔒6):** `barra: 1280x55 … AE=0 (0)`, `chip: 280x76 … AE=0 (0)`.
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33d_motor_t2.html; for m in ventana headless; do node /tmp/s33d_tabs.js $M 390 $m; done; node /tmp/s33d_tabs.js $M 320 headless; node /tmp/s33d_ancho.js /tmp/s33d_motor_fase0.html 320,360 > /tmp/s33d_t24.json; python3 /tmp/s33d_ancho_resumen.py /tmp/s33d_t24.json | grep -E "==|Panorama territorial" | cut -c1-110; bash /tmp/s33d_pruebas_b.sh $M'
```
esperado: **T2.2** a 390 px, con ventana y headless: `clic` `[true, true, true]`; con teclado, las dos pestañas siguientes reciben el foco, quedan visibles dentro de la barra y Enter las activa (`activa_ok: true`); página sin desborde. (Propio) a 320 px, igual, con `.screen-tabs` en `overflow-x: auto` y `scrollWidth` > `clientWidth` (el scroll está dentro de la barra). **T2.4** motor de FASE 0: a 320 px `exceso 51` y a 360 px `exceso 11` (el caso malo sigue). PRUEBAS b sin errores; 0 errores.
obtenido: 0 errores en las tres corridas de `/tmp/s33d_tabs.js`. **T2.2 a 390 px** (con ventana y headless): `clic [true, true, true]`; teclado: "Panorama IDPS por establecimiento" y "Comparación entre territorios" reciben el foco (`es_pestana: true`), quedan visibles en la barra (`visible_en_barra: true`) y Enter las activa (`activa_ok: true`); `.screen-tabs` sin scroll propio (`scrollWidth` = `clientWidth`: 366 en headless; 351 con ventana); página: headless `390/390`; con ventana `scrollWidth 375` frente a `innerWidth 390` (la barra de desplazamiento vertical de la ventana ocupa 15 px; no hay desborde). **(Propio) a 320 px:** clic y teclado activan las tres; `.screen-tabs` con `overflowX: auto`, `scrollWidth 335` > `clientWidth 296` (el scroll está dentro de la barra) y página `320/320`; la pestaña más ancha, enfocada con Tab, **no cabe entera** (`visible_en_barra: false`, 335 px en 296): se activa igual y se ve desplazando la barra. **T2.4:** motor de FASE 0 a 320 px `exceso 51` y a 360 px `exceso 11` (el caso malo sigue). PRUEBAS b: modales `true`/`true`, 0 errores, 0 `pageerror`; ficha y comparación sin errores.
- **Regresión:** build `rc=0`; 🔒6 sin cambio; PRUEBAS b sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "fix(motor): la barra de pantallas no desborda bajo 480 px (s33d T2, pendiente 6)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R status --porcelain'
```
esperado: porcelain antes: plantilla, motor y LOG; commit con solo la plantilla; después: motor y LOG.
obtenido: antes ` M` plantilla, ` M` motor, `?? …s33d_log.md`; **`bee0bad` fix(motor): la barra de pantallas no desborda bajo 480 px (s33d T2, pendiente 6)** con la plantilla; después: motor ` M` y el LOG.
- **Estado:** completada, con un gate del titular (H-1).
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T3: el chip marca el año preliminar (A-5 de s33c)

- **Paso 0:** M9 (con 2025 forzado a preliminar en una copia, el banner dice "(preliminar)" y el chip no).
- **Implementación:** en `metaChip`, al sufijo `" con IDPS en "+DATA.meta.grados[cmpGrado]+" "+agno` se agrega `+(PRELIM.has(String(agno))?" (preliminar)":"")`, el mismo texto que usa la cabecera de la ficha (L1473) y el título de la exportación (L2522). Nada más cambia.
- **Verificación** (build temporal; la copia con el año forzado se hace desde el motor de T3; el censo de s33c se compara contra el del motor de FASE 0 de s33d, corrido en el mismo comando):
```
bash -c 'bash /tmp/s33d_arbol.sh t3; bash /tmp/s33d_build.sh t3; node /tmp/s33d_forzar_prelim.js /tmp/s33d_motor_t3.html /tmp/s33d_motor_t3_prelim.html 2025; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s33d_chip.js /tmp/s33d_motor_t3_prelim.html; node /tmp/s33d_chip.js /tmp/s33d_motor_t3.html; node /tmp/s33d_censo.js /tmp/s33d_motor_fase0.html /tmp/s33d_censo_fase0.json > /dev/null; node /tmp/s33d_censo.js /tmp/s33d_motor_t3.html /tmp/s33d_censo_t3.json > /dev/null; python3 /tmp/s33d_censo_cmp.py /tmp/s33d_censo_fase0.json /tmp/s33d_censo_t3.json; bash /tmp/s33d_pruebas_b.sh /tmp/s33d_motor_t3.html'
```
esperado: `stat sin commitear: 1 file changed, 1 insertion(+), 1 deletion(-)`; hex y `sigdifgru` `0/0`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…`; `:root` `04b2876e…`. Copia con 2025 preliminar: chip `7 comunas · 103 establecimientos con IDPS en 4° básico 2025 (preliminar)`. Motor real: `prelim []` y chip `7 comunas · 103 establecimientos con IDPS en 4° básico 2025`, **idéntico a M9**. Censo de s33c: 816 elementos, **0 cifras distintas y 0 grupos con diferencias** (sin años preliminares, ningún texto cambia). PRUEBAS b sin errores; 0 errores.
obtenido: `stat sin commitear: 1 file changed, 1 insertion(+), 1 deletion(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; motor temporal `bb38fa14a20d8b33e7aec23facc7e927`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `04b2876e…`. Copia (`anios_preliminar` `[]` → `[2025]`): `prelim ["2025"]`, **chip `7 comunas · 103 establecimientos con IDPS en 4° básico 2025 (preliminar)`**. Motor real: `prelim []`, chip `7 comunas · 103 establecimientos con IDPS en 4° básico 2025` (**= M9**). Censo de s33c: `elementos antes 816 despues 816`; `CIFRAS … distintos 0 de 816 | (textContent): 0`; `NUMEROS COMPLETOS: grupos con diferencias 0`. PRUEBAS b: modales `true`/`true`, 0 errores, 0 `pageerror`; ficha y comparación sin errores.
- **Regresión:** build `rc=0`; censo idéntico; PRUEBAS b sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "fix(motor): el chip del comparador marca el ano preliminar (s33d T3, A-5 de s33c)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R status --porcelain'
```
esperado: porcelain antes: plantilla, motor y LOG; commit con solo la plantilla; después: motor y LOG.
obtenido: antes ` M` plantilla, ` M` motor, `?? …s33d_log.md`; **`be5945f` fix(motor): el chip del comparador marca el ano preliminar (s33d T3, A-5 de s33c)** con la plantilla; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T4: al cambiar de pestaña, el foco se queda en la pestaña (A-6 de s33c)

- **Paso 0:** M10 (al volver de Nacional a Comuna, el foco salta al buscador en los dos modales y los dos modos) y M8 (líneas base de 🔒7).
- **Implementación:** en `EntityModal`, justo después de la lectura del origen (`const [origen]=useState(()=>document.activeElement);`, que no se mueve), el comentario pedido, una bandera `const buscadorAlAbrir=useRef(true);` y `useEffect(()=>{buscadorAlAbrir.current=false;},[]);`; el `input` pasa de `autoFocus={true}` a `autoFocus={buscadorAlAbrir.current}`. En el primer render la bandera vale `true` (el `autoFocus` se aplica en el commit, como antes); el efecto la consume y, si el buscador se vuelve a montar al salir de Nacional, ya no toma el foco. Cada apertura monta un `EntityModal` nuevo con su bandera en `true`.
- **Instrumento:** `/tmp/s33d_pestanas.js` registra además el foco al **reabrir** el mismo modal (propio).
- **Verificación** (build temporal; con ventana y headless; dos comandos):
```
bash -c 'bash /tmp/s33d_arbol.sh t4; bash /tmp/s33d_build.sh t4; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33d_motor_t4.html; for m in ventana headless; do node /tmp/s33d_pestanas.js $M $m; done; node /tmp/s33d_pestanas.js /tmp/s33d_motor_fase0.html headless | grep -o "\"tras_volver_a_comuna\":{[^}]*}" ; bash /tmp/s33d_pruebas_b.sh $M'
```
esperado: `stat sin commitear: 1 file changed, 4 insertions(+), 1 deletion(-)`; hex y `sigdifgru` `0/0`; `rc=0 warn=0 pasos_ok=1`; §8.2 `eb4e00b3…`; `:root` `04b2876e…`. **M10 repetido** (dos modales, dos modos): al abrir, `INPUT.input-search`; en Nacional, `BUTTON.modal-tab:Nacional`; **al volver a Comuna, `BUTTON.modal-tab:Comuna`** (por `activeElement` y `:focus`); al reabrir, `INPUT.input-search`. Motor de FASE 0 (caso malo): al volver a Comuna, `INPUT.input-search`. PRUEBAS b sin errores; 0 errores.
obtenido: `stat sin commitear: 1 file changed, 4 insertions(+), 1 deletion(-)`; `hex agregadas=0 borradas=0 ; sigdifgru borradas=0 agregadas=0 const_sg=1`; `rc=0 warn=0 pasos_ok=1`; motor temporal `08c22714954617d454618a1d647f1be4`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `:root` `04b2876e…`. **M10 repetido** (con ventana y headless, idénticos, 0 errores), en los dos modales: al abrir `INPUT.input-search`; en Nacional `BUTTON.modal-tab:Nacional`; **al volver a Comuna `BUTTON.modal-tab:Comuna`** (`activeElement` y `:focus`), con el buscador montado; al reabrir `INPUT.input-search`. Motor de FASE 0: al volver a Comuna `INPUT.input-search` en los dos modales (el caso malo sigue). PRUEBAS b: modales `true`/`true`, 0 errores, 0 `pageerror`; ficha y comparación sin errores.
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/tmp/s33d_motor_t4.html; for m in ventana headless; do node /tmp/s33d_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33d_t4_l6_$m.json; python3 /tmp/s33d_l6_resumen.py /tmp/s33d_t4_l6_$m.json; done; for m in ventana headless; do node /tmp/s33d_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33d_t4_foco.jsonl; python3 /tmp/s33d_foco_resumen.py /tmp/s33d_t4_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/"'
```
esperado: 🔒7 = M8: `terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` en los dos modos; respaldos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`; 0 errores.
obtenido: `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; respaldos en los dos modos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`; 0 errores → 🔒7 = M8.
- **Regresión:** build `rc=0`; 🔒7 igual; PRUEBAS b sin errores.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html && git -C $R commit -q -m "fix(motor): el foco se queda en la pestana al cambiarla (s33d T4, A-6 de s33c)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R status --porcelain'
```
esperado: porcelain antes: plantilla, motor y LOG; commit con solo la plantilla; después: motor y LOG.
obtenido: antes ` M` plantilla, ` M` motor, `?? …s33d_log.md`; **`8353951` fix(motor): el foco se queda en la pestana al cambiarla (s33d T4, A-6 de s33c)** con la plantilla; después: motor ` M` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T5: build

- **Paso 1** (porcelain):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: solo el motor y el LOG: ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260924_accesibilidad_responsive_s33d_log.md`.
obtenido: ` M 40_salidas/motor_idps.html`, `?? 50_documentacion/andamios/logs/20260924_accesibilidad_responsive_s33d_log.md`.
- **Pasos 2 a 4, primer comando** (PRUEBAS a con el pipeline completo, porcelain después, md5, §8.2, testigo, PRUEBAS b y 🔒6 con capturas):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; bash /tmp/s33d_build.sh t5 completo; git -C $R status --porcelain; echo "motor en el arbol $(md5 -q $M) ; §8.2 $(bash /tmp/s33d_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*" | cut -c15-)"; echo "testigo motor $(grep -c -F ":hover{color:var(--alerta-txt)" $M) docs $(grep -c -F ":hover{color:var(--alerta-txt)" $R/docs/index.html)"; bash /tmp/s33d_pruebas_b.sh $M; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33d_captura.js $M t5 > /dev/null; bash /tmp/s33d_ae.sh f0 t5'
```
esperado: `rc=0 warn=0 pasos_ok=5`; porcelain después, el mismo del paso 1; motor `08c22714954617d454618a1d647f1be4` (= build temporal de T4: misma plantilla y mismo día); §8.2 `eb4e00b3…` (= M3); `:root` `04b2876e…`; testigo `motor 2 docs 0` (las dos reglas de T1); PRUEBAS b sin errores; 🔒6 `barra … AE=0` y `chip … AE=0`.
obtenido: `rc=0 warn=0 pasos_ok=5`; motor `08c22714954617d454618a1d647f1be4` (= T4); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `:root` `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`; porcelain después ` M 40_salidas/motor_idps.html`, `?? …s33d_log.md` (el mismo); **testigo `motor 2 docs 0`**; PRUEBAS b: modales `true`/`true`, `consola_errores: []`, `pageerror: []`; ficha y comparación sin errores; 🔒6 `barra: 1280x55 … AE=0 (0)`, `chip: 280x76 … AE=0 (0)`.
- **Pasos 2 a 4, segundo comando** (🔒7 sobre el motor commiteable, en los dos modos):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; for m in ventana headless; do node /tmp/s33d_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33d_t5_l6_$m.json; python3 /tmp/s33d_l6_resumen.py /tmp/s33d_t5_l6_$m.json; done; for m in ventana headless; do node /tmp/s33d_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33d_t5_foco.jsonl; python3 /tmp/s33d_foco_resumen.py /tmp/s33d_t5_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/"'
```
esperado: 🔒7 = M8 en los dos modos (`terr N354 … | cmp N8 … | devol origen 10 de 10 …`; respaldos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`); 0 errores.
obtenido: 🔒7 `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; respaldos en los dos modos = M8; 0 errores.
- **Testigo para el despliegue:** `grep -c -F ':hover{color:var(--alerta-txt)'` → `2` en el motor y `0` en `docs/index.html`. **md5 del motor para el despliegue: `08c22714954617d454618a1d647f1be4`.**
- **Paso 5 (commit):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s33d accesibilidad, ancho y ajustes del modal" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: commit con solo el motor (`08c22714…`); porcelain después: solo el LOG.
obtenido: **`1444922` build(motor): s33d accesibilidad, ancho y ajustes del modal**; `40_salidas/motor_idps.html`; `08c22714954617d454618a1d647f1be4`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `0688dd9`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `0688dd9` (hijo de `55d4701` = `origin/main`), con el encargo y el registro; commits `0688dd9`, `a198d8b`, `bee0bad`, `be5945f`, `8353951`, `1444922` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0 y en los builds de T1 a T5; ciego a la fecha, sensible a una cifra (M3) |
| R-03 | `:root` `65`/`04b2876e…` sin cambio |
| R-04 | M4: dos reglas de hover en `--alerta` (`.sel-chip button`, `.cmp-x`); tres botones de quitar; `.modal-sel-b` no usa `--alerta` |
| R-05 | M5 / T1: con hover, 4,11 → 5,61 (`--alerta-txt`) en los dos botones; sin hover, sin cambio |
| R-06 | M6 / M6b / T2: sin desborde a 390–425; en FASE 0, desborde por la barra a 360 (+11) y 320 (+51); tras T2, exceso 0 a 320, 360, 390, 412 y 425 en las tres pantallas (gate H-1) |
| R-07 | T2.2: pestañas operables con clic y teclado a 390 (y 320, con scroll dentro de la barra) |
| R-08 | M9 / T3: con el año forzado a preliminar, el chip dice "(preliminar)"; sin él, el texto no cambia; censo de s33c sin diferencias |
| R-09 | M10 / T4: al volver de Nacional el foco queda en la pestaña; al abrir y reabrir, en el buscador |
| R-10 | M11 / T5: testigo `:hover{color:var(--alerta-txt)` 2 en el motor, 0 en `docs/` |
| 🔒1–🔒7 | invariantes de §3 |
| ALC | alcance global ⊆ ALCANCE + LOG + encargo + registro |
| REG | PRUEBAS a, b y c sobre el estado final |
| CP | casos malos y plantados: M3, M6 (`nowrap`), M7 (`pad`), M9 (copia con el año forzado), M10 (motor de FASE 0) |

**Paso 2a. Re-derivación estática** (`/tmp/s33d_r_static.sh`: §8.2 y `:root` en Python; el contraste del ✕ con hover **en Python desde el texto de la plantilla**, sin navegador —`/tmp/s33d_r_contraste.py`: el token de cada regla de hover, su hex en el `:root` y el fondo del contenedor; se probó una vez que corre, sin mirar cifras, antes de este esperado—; conteos con `awk index()` en `<inicio>`, `HEAD`, el motor y `docs/`; diff en Python; md5 con `hashlib`):
```
bash /tmp/s33d_r_static.sh
```
esperado: R-01 padre `55d4701` = `origin/main`; 6 commits; 2 rutas en `0688dd9`. R-02 `eb4e00b3…` en `HEAD`, FASE 0 y fecha alterada; distinto en el plantado. R-03 65/`04b2876e…` en los dos. R-05: en `0688dd9` los dos hover en `--alerta #EE2D49` sobre `--paper #ffffff` → 4,11; en `HEAD`, `--alerta-txt #CE112C` → 5,61. `awk` (inicio / HEAD / motor / docs): `:hover{color:var(--alerta-txt)` 0/2/2/0; `:hover{color:var(--alerta);}` 2/0/0/2; `@media (max-width:480px)` 0/1/1/0; `buscadorAlAbrir` 0/3/3/0; `autoFocus={true}` 1/0/0/1; `?" (preliminar)":"")` 1/2/2/1; `s33d:` 0/2/2/0. Diff: hex `+0 -0`, `sigdifgru` `+0 -0`. R-10 md5 `08c22714…`.
obtenido: `R-01: padre 55d4701 ; origin/main 55d4701 ; commits 1444922 8353951 be5945f bee0bad a198d8b 0688dd9 ; en 0688dd9 2 rutas`. R-02 (Python): `HEAD`, FASE 0 y fecha alterada `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; plantado `1c3799e2…`. R-03: `lineas=65 md5=04b2876e2bcece41f09398f28f6fc41d` en los dos. **R-05 (Python, sin navegador):** `0688dd9`: `.sel-chip button:hover` y `.cmp-x:hover` `--alerta #EE2D49 sobre --paper #ffffff -> 4.11`; `HEAD`: `--alerta-txt #CE112C sobre --paper #ffffff -> 5.61` en los dos (= navegador). `awk`: `:hover{color:var(--alerta-txt)` 0/2/2/0; `:hover{color:var(--alerta);}` 2/0/0/2; `@media (max-width:480px)` 0/1/1/0; `buscadorAlAbrir` 0/3/3/0; `autoFocus={true}` 1/0/0/1; `?" (preliminar)":"")` 1/2/2/1; `s33d:` 0/2/2/0. Diff (Python): `lineas +9 -4 | hex +0 -0 | sigdifgru +0 -0`. R-10 `08c22714954617d454618a1d647f1be4`. **Todo coincide por otra vía.**

**Paso 2b. Re-derivación en navegador por otras vías** (ancho por **borde derecho** con `/tmp/s33d_r_ancho.js`, a **400 px** —ancho intermedio nuevo— y a 360 y 320, sobre `HEAD` y sobre FASE 0; hover con el **ratón real** —`page.hover`, no `forcePseudoState`— con `/tmp/s33d_r_hover.js`; el año preliminar sobre **otras entidades** —el chip del SLEP foco y el de Chile, leídos por el censo de s33c— en una copia de `HEAD` con 2025 forzado; y el foco al volver de Nacional con **clics reales** en las pestañas, con `/tmp/s33d_nac.js`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; H=/tmp/s33d_r_motor_head.html; echo "== HEAD"; node /tmp/s33d_r_ancho.js $H 400,360,320; echo "== FASE 0"; node /tmp/s33d_r_ancho.js /tmp/s33d_motor_fase0.html 400,360,320 | grep -E "ultima|errores" | sed -n "1p;4p;7p;10p"; node /tmp/s33d_r_hover.js $H; node /tmp/s33d_r_hover.js /tmp/s33d_motor_fase0.html; node /tmp/s33d_forzar_prelim.js $H /tmp/s33d_r_motor_head_prelim.html 2025; node /tmp/s33d_censo.js /tmp/s33d_r_motor_head_prelim.html /tmp/s33d_censo_r_prelim.json > /dev/null; node /tmp/s33d_censo.js $H /tmp/s33d_censo_r_head.json > /dev/null; python3 -c "import json; d=json.load(open(\"/tmp/s33d_censo_r_prelim.json\"))[\"m6\"]; print(\"prelim:\", d[\"chip_slep\"], \"|\", d[\"chip_chile\"])"; python3 /tmp/s33d_censo_cmp.py /tmp/s33d_censo_r_head.json /tmp/s33d_censo_r_prelim.json | head -3; python3 /tmp/s33d_r_censo.py /tmp/s33d_censo_fase0.json /tmp/s33d_censo_r_head.json; for m in ventana headless; do node /tmp/s33d_nac.js $H $m | grep -o "\"foco_al_volver_a_comuna\":\"[^\"]*\"" ; done; node /tmp/s33d_nac.js /tmp/s33d_motor_fase0.html headless | grep -o "\"foco_al_volver_a_comuna\":\"[^\"]*\""'
```
esperado: `HEAD`: a 400, 360 y 320 px, en las tres pantallas, "sin desborde de pagina" (última pestaña y contenedor con `right` ≤ `inner`); a 320, con "scroll dentro de la barra". FASE 0: a 400 sin desborde; a 360 y 320 `DESBORDA` (contenedor más allá de `inner`). Hover real: `HEAD` `rgb(206, 17, 44)`, FASE 0 `rgb(238, 45, 73)`; sin hover, `rgb(92, 102, 110)` en los dos. Copia con 2025 preliminar: los chips del SLEP foco y de Chile terminan en `… 2025 (preliminar)`; censo de la copia contra `HEAD`: 0 cifras distintas (el texto "(preliminar)" no tiene dígitos: 0 grupos con diferencias). Censo en Python (`textContent`) FASE 0 contra `HEAD`: 0 elementos distintos. Foco al volver a Comuna con clics reales: `HEAD` `BUTTON.modal-tab:Comuna` (dos modos); FASE 0 `INPUT.input-search:`.
obtenido: 0 errores. **Ancho por borde derecho, `HEAD`:** a 400 px `ultima 291 max 347 contenedor 388 nav 400 inner 400`; a 360 `contenedor 348 … inner 360`; a 320 `contenedor 308 … inner 320` "(scroll dentro de la barra)"; las nueve filas "sin desborde de pagina". **FASE 0:** a 400 `contenedor 376 inner 400` sin desborde; a 360 `contenedor 371 inner 360` **DESBORDA**; a 320 `contenedor 371 inner 320` **DESBORDA**. **Hover con el ratón real:** `HEAD` `hover_raton rgb(206, 17, 44)`, FASE 0 `rgb(238, 45, 73)`; sin hover `rgb(92, 102, 110)` en los dos. **Año preliminar** (copia de `HEAD` con `[2025]`): chip del SLEP foco `4 comunas · 60 establecimientos con IDPS en 4° básico 2025 (preliminar)` y de Chile `343 comunas · 6.717 establecimientos con IDPS en 4° básico 2025 (preliminar)`; censo de la copia contra `HEAD`: `CIFRAS … distintos 0 de 816`, `grupos con diferencias 0`; censo en Python (`textContent`) FASE 0 contra `HEAD`: `elementos distintos 0`. **Foco con clics reales:** `HEAD` `BUTTON.modal-tab:Comuna` (con ventana y headless); FASE 0 `INPUT.input-search:`. R-05 a R-09 confirmados por otra vía.

**Pasos 3, 4 y 6, parte estática** (`/tmp/s33d_final.sh`, copia de la de s33c con `I=0688dd9` y la lista de rutas permitidas de este encargo —plantilla, motor, LOG, encargo y registro s33—: L1–L5; alcance; controles C1 hex plantado, C2 token plantado, C3 cifra plantada, C4 ruta plantada, C5 `sigdifgru` plantado, C6 🔒5 sobre `9fc6f22`, C7 🔒4 sobre `364c53a`):
```
bash /tmp/s33d_final.sh
```
esperado: `L1` `eb4e00b3…`; `L2a` `65`, `04b2876e…`; `L2b` `hex agregadas=0 borradas=0`; `L3` `sigdifgru borradas=0 agregadas=0`; `L4` `0`; `L5` `0`; `ALC` 2 rutas (plantilla y motor), `fuera 0`, en `0688dd9` el encargo y el registro, porcelain solo el LOG; `C1` `agregadas=1`; `C2` md5 distinto; `C3` `1c3799e2…`; `C4` `[docs/index.html ]`; `C5` `agregadas=1`; `C6` `1`; `C7` > 0.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **🔒1 PASA**; `L2a: lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d`, `L2b: hex agregadas=0 borradas=0` → **🔒2 PASA**; `L3: sigdifgru borradas=0 agregadas=0` → **🔒3 PASA**; `L4: 0` → **🔒4 PASA**; `L5: 0` → **🔒5 PASA**. `ALC: rutas [plantilla motor] ; fuera 0 ; en 0688dd9: [encargo registro] ; porcelain [?? …s33d_log.md ]` → **alcance PASA**. `C1: hex agregadas=1`; `C2: md5 070d6097d10e601e95a45ce0e6352392` (distinto); `C3: 1c3799e2e8e35da8`; `C4: [docs/index.html ]`; `C5: sigdifgru … agregadas=1`; `C6: 1`; `C7: 78`. Todos disparan.

**Pasos 3 y 6, parte en navegador, primer comando** (🔒6: capturas del motor final contra `f0`; controles fuera del árbol sobre copias del motor de `HEAD`: **C9** hover devuelto a `--alerta` → 4,11; **C10** media query neutralizada (`max-width:1px`) → desborda a 360 px; **C11** `autoFocus={true}` restituido → el foco vuelve a saltar al buscador; **C12** 1 px de padding en la barra y el chip → AE > 0):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; node /tmp/s33d_captura.js $M final > /dev/null; echo "L6:"; bash /tmp/s33d_ae.sh f0 final; node /tmp/s33d_captura.js /tmp/s33d_c12_motor.html c12 > /dev/null; echo "C12:"; bash /tmp/s33d_ae.sh f0 c12; echo "C9: $(node /tmp/s33d_hover.js /tmp/s33d_c9_motor.html | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[\"sel_chip\"][\"hover\"][\"contraste\"], d[\"cmp_x\"][\"hover\"][\"contraste\"])")"; echo "C10:"; node /tmp/s33d_r_ancho.js /tmp/s33d_c10_motor.html 360 | head -1; echo "C11: $(node /tmp/s33d_pestanas.js /tmp/s33d_c11_motor.html headless | grep -o "\"tras_volver_a_comuna\":{\"activo\":\"[^\"]*\"" | tr "\n" " ")"'
```
esperado: `L6` `barra … AE=0` y `chip … AE=0` → 🔒6 PASA; `C12` AE > 0 en los dos; `C9` `4.11 4.11`; `C10` `DESBORDA`; `C11` `INPUT.input-search` en los dos modales.
obtenido: `L6`: `barra: 1280x55 … AE=0 (0)`, `chip: 280x76 … AE=0 (0)` → **🔒6 PASA**. `C12`: `barra … AE=2418.24`, `chip … AE=900.366`; `C9: 4.11 4.11`; `C10`: `360 … contenedor 371 nav 360 inner 360 | DESBORDA`; `C11`: `tras_volver_a_comuna` → `INPUT.input-search` en los dos modales. Todos disparan.

**Pasos 3 y 6, parte en navegador, segundo comando** (🔒7 sobre el motor final en los dos modos, y su control **C8**: copia sin la devolución del foco → `devol origen 0 de 10`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; for m in ventana headless; do node /tmp/s33d_l6.js $M $m ciclo_terr,ciclo_cmp,devol > /tmp/s33d_r_l6_$m.json; python3 /tmp/s33d_l6_resumen.py /tmp/s33d_r_l6_$m.json; done; for m in ventana headless; do node /tmp/s33d_foco.js $M $m tope_listo,tope_escape,tope_fondo,terr_ee,desmarcar; done > /tmp/s33d_r_foco.jsonl; python3 /tmp/s33d_foco_resumen.py /tmp/s33d_r_foco.jsonl | sed -E "s/ tabindex=.*\| Tab/ | Tab/"; echo "C8: $(node /tmp/s33d_l6.js /tmp/s33d_c8_motor.html headless devol | python3 -c "import json,sys; d=json.load(sys.stdin)[\"devol\"]; print(\"origen en\", sum(1 for v in d.values() if v.get(\"es_origen\")), \"de\", len(d))")"'
```
esperado: 🔒7 = M8 en los dos modos (`terr N354 … | cmp N8 … | devol origen 10 de 10 …`; respaldos `SPAN.cmp-cl` ×3, `DIV.ficha-name`, `BUTTON.cmp-add`); `C8` `origen en 0 de 10`; 0 errores.
obtenido: 🔒7 `ventana | terr N354 Tab 0/1 Shift 0/1 | cmp N8 Tab 0/2 Shift 0/1 | devol origen 10 de 10 | espacio_reabre False | fondo cierra True/True | errores 0` y `headless | …` idéntico; respaldos en los dos modos = M8 → **🔒7 PASA**. `C8: origen en 0 de 10` (dispara). Ninguna falla del instrumento con ventana en toda la sesión (la espera de POSICIÓN resolvió A-3 de s33c en las 8 corridas con ventana de los scripts de foco).

**Paso 5. Regresión completa** (PRUEBAS a con `run_all()` sobre el estado final; PRUEBAS b; PRUEBAS c):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; bash /tmp/s33d_build.sh faseR completo; git -C $R status --porcelain; bash /tmp/s33d_pruebas_b.sh $M; echo "REGc $(bash /tmp/s33d_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*" | cut -c15-)"'
```
esperado: REGa `rc=0 warn=0 pasos_ok=5`, motor `08c22714…` (= `HEAD`), porcelain solo el LOG; REGb modales `true`/`true`, ficha y comparación sin errores, 0 `pageerror`; REGc `eb4e00b3…`.
obtenido: `REGa: rc=0 warn=0 pasos_ok=5`, motor `08c22714954617d454618a1d647f1be4` (= `HEAD`), `:root` `04b2876e…`, porcelain `?? …s33d_log.md` (solo el LOG); `REGb`: `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha y comparación sin errores (`desbordadas: 0`); `REGc: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **regresión PASA**.

**Paso 7. Veredicto por hallazgo.**
- **0 BLOQUEA; 0 REPARA.** Los controles positivos (C1–C12, más los casos malos de FASE 0: `nowrap`, `pad`, la copia con el año forzado y el motor de FASE 0) prueban que cada instrumento dispara.
- **A-1 (ADVIERTE, premisa del encargo; resuelta en gate):** M6 esperaba el desborde a 390 px y no estaba ahí; estaba a 360 y 320 px (hallazgo H-1). El titular eligió corregirlo midiendo a 320, 360, 390, 412 y 425 px.
- **A-2 (ADVIERTE, para el gate visual):** a 320 px, la pestaña más ancha ("Panorama IDPS por establecimiento", 335 px) no cabe entera en la barra (296 px): la página no desborda, pero esa pestaña se ve desplazando la barra, y al enfocarla con Tab queda parcialmente oculta (`visible_en_barra: false`); se activa igual.
- **Notas (no son hallazgos):** (a) la media query de T2 actúa hasta 480 px, así que a 390, 412 y 425 px la barra también se ve con menos padding (12 px en vez de 24 y 18); a 1280 px no cambia nada (🔒6). (b) La espera de POSICIÓN en los instrumentos de foco (A-3 de s33c) funcionó: 0 fallas en las corridas con ventana.

**Paso 8.** Sin ciclos de reparación (0 de 2).

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `git rev-parse 0688dd9~1`; `git log` | padre `55d4701` = `origin/main`; 6 commits | igual | — | ninguna | — | — |
| R-02 | §8.2 constante; calibrado | `/tmp/s33d_r_payload.py` (Python) | `eb4e00b3…`; plantado distinto | igual | — | ninguna | — | C3 |
| R-03 | `:root` sin cambio | `/tmp/s33d_r_root.py` (Python) | 65; `04b2876e…` | igual | — | ninguna | — | C2 |
| R-04 | inventario de botones de quitar | `awk` de `:hover{color:var(--alerta);}` en `<inicio>` y `HEAD` | 2 → 0 | 2 → 0 | — | ninguna | — | — |
| R-05 | T1: 4,11 → 5,61 | contraste en Python desde el `:root`; hover con el ratón real | 4,11 / 5,61; `rgb(206, 17, 44)` | igual | — | ninguna | — | C9 |
| R-06 | T2: sin desborde de 320 a 425 | borde derecho de la última pestaña y del contenedor; 400 px | sin desborde; FASE 0 desborda a 360 y 320 | igual | ADVIERTE (A-1, A-2) | gate H-1; nota | — | C10, `nowrap` |
| R-07 | T2.2: pestañas operables | clic y teclado a 390 (dos modos) y 320 | activas | activas; a 320 la ancha, parcial | ADVIERTE (A-2) | nota | — | — |
| R-08 | T3: "(preliminar)" en el chip | copia de `HEAD` con 2025 forzado; chips del SLEP foco y de Chile por el censo | "… 2025 (preliminar)"; 0 cifras distintas | igual | — | ninguna | — | copia de FASE 0 (M9) |
| R-09 | T4: el foco se queda en la pestaña | clics reales (Nacional → Comuna), dos modos | `BUTTON.modal-tab:Comuna`; FASE 0 buscador | igual | — | ninguna | — | C11 |
| R-10 | T5 testigo y md5 | `awk`; `hashlib` | 2/0; `08c22714…` | igual | — | ninguna | — | — |
| 🔒1–🔒7 | invariantes | `/tmp/s33d_final.sh`; capturas; scripts de M8 | ver pasos 3 | 7/7 PASA | — | — | — | C1–C8, C12 |
| ALC | alcance global | lista explícita + `grep -vxF` | 0 fuera | 0 (2 rutas + encargo y registro en `0688dd9`) | — | — | — | C4 |
| REG | PRUEBAS a, b, c | `run_all()`; PRUEBAS b; §8.2 | `rc=0`, solo el LOG; 0 errores; `eb4e00b3…` | igual | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/0/2 (A-1, A-2). Ciclos de reparación usados: 0 de 2.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** ninguno (un patrón `awk` sin efecto se quitó del script antes de correrlo).

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 6 respecto de `origin/main`.
obtenido: `?? 50_documentacion/andamios/logs/20260924_accesibilidad_responsive_s33d_log.md` (única); `## main...origin/main [ahead 6]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s33d (accesibilidad, ancho angosto y dos ajustes de s33c). Fases: FASE 0, T1 a T5, R y L. Estado del grafo: T1 completada (`a198d8b`) · T2 completada (`bee0bad`, con gate H-1) · T3 completada (`be5945f`) · T4 completada (`8353951`) · T5 completada (`1444922`) · FASE R APROBADO CON ADVERTENCIAS (sin reparaciones) · FASE L completada. Ninguna tarea congelada.
2. **Commits** (`git log 55d4701..HEAD --oneline`, antes del commit de este log):
   - `0688dd9` chore(encargo): s33d y registro del asistente s33 (= `<inicio>`)
   - `a198d8b` fix(motor): el boton de quitar usa --alerta-txt al pasar el raton (s33d T1)
   - `bee0bad` fix(motor): la barra de pantallas no desborda bajo 480 px (s33d T2, pendiente 6)
   - `be5945f` fix(motor): el chip del comparador marca el ano preliminar (s33d T3, A-5 de s33c)
   - `8353951` fix(motor): el foco se queda en la pestana al cambiarla (s33d T4, A-6 de s33c)
   - `1444922` build(motor): s33d accesibilidad, ancho y ajustes del modal (motor `08c22714954617d454618a1d647f1be4`)
   - (este log: `docs(log): s33d accesibilidad y ancho`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/2; reparados 0.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, T1 a T5 y la regresión) · 🔒2 PASA (`:root` `65`/`04b2876e…`; hex +0/−0) · 🔒3 PASA (0/0) · 🔒4 PASA (0) · 🔒5 PASA (0) · 🔒6 PASA (AE = 0 en la barra y en el chip a 1280 × 800, en T1, T2, T5 y FASE R) · 🔒7 PASA (= M8 en los dos modos, en T4, T5 y FASE R). 7/7.
5. **Decisiones del titular registradas:** el anillo crema de la ficha queda como está; A-5 y A-6 de s33c se corrigen (T3 y T4); A-4 de s33c (chips una línea más altos) se acepta; A-3 de s33c se resuelve en el instrumento con la espera de POSICIÓN (0 fallas con ventana en esta sesión). **Gate de esta sesión (H-1):** "Corregir a 360 y 320" (T2 medido a 320, 360, 390, 412 y 425 px).
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0 y en los builds de T1 (`0ca07c55…`), T2 (`0fe90854…`), T3 (`bb38fa14…`), T4 y T5 (`08c22714…`) y en la regresión. Motor `5825cc14…` → `08c22714954617d454618a1d647f1be4`; `docs/` sin cambios (`4b28a03f…`). Censo de s33c: 816 elementos y 133 cifras, sin diferencias. Antes → después:

   | medida | antes | después |
   |---|---|---|
   | ✕ de `.sel-chip` con hover (sobre `--paper`) | `rgb(238, 45, 73)` (`--alerta`), 4,11 | `rgb(206, 17, 44)` (`--alerta-txt`), 5,61 |
   | ✕ de `.cmp-x` con hover | 4,11 | 5,61 |
   | desborde de la página a 320 / 360 / 390 / 412 / 425 px | +51 / +11 / 0 / 0 / 0 | 0 / 0 / 0 / 0 / 0 (a 320, scroll dentro de la barra) |
   | chip con el año preliminar (copia con 2025 forzado) | `… 2025` | `… 2025 (preliminar)` |
   | foco al volver de Nacional a Comuna | el buscador | la pestaña Comuna |

7. **Dudas y pendientes consolidados:**
   - A-2: a 320 px, la pestaña "Panorama IDPS por establecimiento" no cabe entera en la barra y se ve desplazándola. ¿Se acepta, o se acorta su rótulo en pantallas angostas (cambio de texto, fuera de este encargo)? (acepta/acorta). Bloquea: nada.
   - **Testigo del próximo despliegue:** `grep -c -F ':hover{color:var(--alerta-txt)'` → `2` en el motor, `0` en `docs/index.html`. md5 del motor a desplegar: `08c22714954617d454618a1d647f1be4` (lleva s33, s33b, s33c y s33d).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** ninguno con efecto sobre cifras, código o evidencia. Dos detalles de proceso, declarados en su lugar: el script de contraste en Python se probó una vez (sin mirar cifras) antes de escribir su esperado; un patrón `awk` sin efecto se quitó del script de re-derivación antes de correrlo.
9. **Notas para el revisor:**
   - (a) Gate visual a 390 px o en el celular: la barra de pantallas con menos padding y las pestañas apiladas; a 360 y 320 px la página ya no se desplaza de lado (a 320, la pestaña más ancha se ve desplazando la barra, A-2).
   - (b) Pasar el ratón sobre el ✕ de un chip del comparador o de la dependencia del panorama: rojo más oscuro (`--alerta-txt`).
   - (c) En los dos modales: con teclado, ir a Nacional y volver a Comuna; el foco se queda en la pestaña. Al abrir, sigue en el buscador.
   - (d) La marca "(preliminar)" del chip no se puede ver hoy: no hay años preliminares.
   - (e) Nada se desplegó.
10. **Estado de cierre:** commiteados `0688dd9`, `a198d8b`, `bee0bad`, `be5945f`, `8353951`, `1444922` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s33d_priv.sh`, copia del de s33c con la ruta de este log: RUT con el patrón en una variable y control plantado fuera del log; "RBD" seguido de número; términos de establecimiento con su control plantado; nombre de la estación; los patrones viven solo en el script):
```
bash /tmp/s33d_priv.sh
```
esperado: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `nombre plantado: 1`; `estación por nombre: 0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0 (bruto, con los identificadores de acción: 0)`; `nombre plantado: 1`; `estación por nombre: 0`. **Privacidad: PASA.** La estación figura como "estación del titular".

Paso 5 (verificación del archivo, después de rellenar el J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260924_accesibilidad_responsive_s33d_log.md; ls -l $L && wc -l $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(sed -n "/^## J/,/^## Registro/p" $L | grep -c "^- ")"; bash /tmp/s33d_priv.sh | head -1'
```
esperado: `FASE=8` (FASE 0, T1 a T5, R, L); `esperado` = `obtenido` + 1 al medir (un `esperado:` por comando en todo el log; este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; `RUT en el log: 0`.
obtenido: `71759` bytes y `415` líneas al medir; `FASE=8 esperado=34 obtenido=33 J=1 J_campos=13`; `RUT en el log: 0`. Con esta línea, **34 = 34** (un `esperado:` por comando, sin anexos de formato).
