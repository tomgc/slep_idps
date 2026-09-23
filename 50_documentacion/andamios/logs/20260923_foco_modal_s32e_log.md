# Log de sesión: el foco se queda dentro del modal (s32e)

- **Meta:** que, con `EntityModal` abierto (modal de territorio y modal del comparador), Tab y Shift+Tab recorran solo los controles del modal, en ciclo, y que al cerrarlo por cualquier vía el foco vuelva al botón que lo abrió (T1); regenerar el motor (T2). Sin despliegue.
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `f5ae215` (= `origin/main` tras el push de s32d/A-1). Primer acto (autorizado): commit `d9016c0` chore(encargo): s32e, hijo de `f5ae215`. **PUNTO DE RETORNO `<inicio>` = `d9016c0`.** Porcelain, stash y `rev-parse` se miden en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`); pruebas de teclado **con ventana** (`headless: false`) y en headless.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`, sin `ultracode`; **sin subagentes**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_foco_modal_s32e.md` (commit `d9016c0`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (foco retenido y devuelto)  ALCANCE: 30_procesamiento/35_motor_template.html
T2 (build)                      ALCANCE: 40_salidas/motor_idps.html; requiere T1
Serie: T1 → T2; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s32e_*`; se copian de los de s32–s32d cuando sirven.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: con cualquiera de los dos modales abiertos, Tab y Shift+Tab dan la vuelta dentro del modal (0 pasos fuera, con ventana y en headless), y al cerrarlo por cualquier vía el foco vuelve al botón que lo abrió (10 de 10) → cumplida.
- Estado por tarea: FASE 0 completada · T1 completada (`620df50`, reparada en `379582a`) · T2 completada (`919af1f`; motor final en `379582a`) · FASE R completada (1 reparación) · FASE L completada.
- Commits: 5, rango `d9016c0`..`<docs(log)>` (`git log --oneline f5ae215..HEAD`), de los cuales 1 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/1/1; reparados 1 (R-11: Enter o Espacio sostenidos sobre una fila o sobre Listo reabrían el modal al volver el foco al disparador); abiertos 1 (A-1: si el botón de origen desaparece, el foco queda en `BODY`).
- Invariantes: 6/6 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒6 Enter/Espacio, tope y Escape idénticos a la línea base, con ventana y headless); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, en T1, en T2, en el fix y en la regresión; el `run_all()` completo deja el árbol limpio).
- Decisiones autónomas de mayor riesgo: (1) el origen se captura en el primer render (`useState(()=>document.activeElement)`), porque el `autoFocus` del buscador se aplica antes de los efectos; (2) con el foco fuera de la caja, Shift+Tab lo lleva al último enfocable (el encargo solo fija Tab → primero); (3) R-11 se repara descartando solo las repeticiones de Enter y Espacio sobre el origen hasta el primer `keyup`.
- Desviaciones respecto del encargo: ninguna en el grafo ni en las autorizaciones; la auditoría agregó un caso límite (tecla sostenida) que el encargo no pedía y que destapó R-11.
- Dudas abiertas: 1 (A-1 ¿un destino alternativo del foco cuando el botón de origen desaparece? sí/no).
- Errores propios: 1 (R-11, defecto del trabajo de T1, reparado en el ciclo 1); costo: un ciclo de reparación, unos 10 minutos.
- Qué debe verificar el revisor por sí mismo: el gate visual en los dos modales (Tab y Shift+Tab no salen; al cerrar, el foco vuelve al botón); esta sesión midió `document.activeElement` y `:focus`, no la percepción del contorno.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo "s32e: aria-modal=true promete que el foco no sale"). El push se hace según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo, sin ultracode; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `d9016c0` (primer acto).

**M1 a M4** (instrumentos copiados de s32d: `/tmp/s32e_payload_sha.sh` → `/tmp/s32e_payload_norm.js`, `/tmp/s32e_fecha_alterada.js`, `/tmp/s32e_plantar_payload.js`, `/tmp/s32e_root_md5.sh`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s32e_motor_fase0.html; md5 -q $M; for f in /tmp/s32e_motor_fase0.html; do bash /tmp/s32e_payload_sha.sh $f | grep -o "sha256_norm\":\"[0-9a-f]*"; done; node /tmp/s32e_fecha_alterada.js /tmp/s32e_motor_fase0.html /tmp/s32e_motor_fecha.html; bash /tmp/s32e_payload_sha.sh /tmp/s32e_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s32e_plantar_payload.js /tmp/s32e_motor_fase0.html /tmp/s32e_motor_plantado.html; bash /tmp/s32e_payload_sha.sh /tmp/s32e_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s32e_root_md5.sh $R/30_procesamiento/35_motor_template.html; cp /tmp/s32e_root_block.txt /tmp/s32e_root_block_fase0.txt'
```
esperado: M1 solo este LOG, stash vacío; M2 `HEAD=d9016c0`, padre `f5ae215` = `origin/main`, `0`, `1`; M3 motor `ae30a4e9…` (`020418b`), §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; M4 `:root` `63` líneas, `9842151d…`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260923_foco_modal_s32e_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=d9016c0 padre=f5ae215 origin/main=f5ae215`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 motor `ae30a4e909257f31c2b89c4a12602393`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada `eb4e00b3…` (igual), plantado `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); M4 `lineas: 63; md5 9842151d897e8768abd2207513c6607b`. Reglas 1 y 2 no disparan; valores de 🔒1 y 🔒2.

**M7** (lectura del hermano; sin valor esperado):
```
bash -c 'H=/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html; ls -l $H; grep -n "focus\|Escape\|keydown\|aria-modal\|role=\"dialog\"" $H | head -30'
```
esperado: se registra lo que haya.
obtenido: el archivo existe (203.668 bytes). Las únicas coincidencias son estilos `:focus`/`:focus-visible` de controles (L233, L405, L415) y el estado `focusYear` de su tabla de calor (L2599-2664). **Su modal (L3940-…, leído en s32) no tiene `role="dialog"`, `aria-modal`, listener de Escape ni manejo de foco**: no retiene ni devuelve el foco. No hay mecánica que replicar; T1 aplica la de §6 y lo dice en su comentario.

**Instrumento de foco** (`/tmp/s32e_foco.js`): Chrome con ventana (`headless:false`, `bringToFront`) o headless; abre cada modal con clic de ratón en su botón; cuenta N = enfocables del modal en el DOM (`button, input, select, textarea, a[href], [tabindex]` no deshabilitados, `tabIndex >= 0` y con cajas); desde el buscador presiona N+3 Tab y registra, tras cada uno, el índice de `document.activeElement` en esa lista (−1 = fuera del modal); cierra, reabre y repite con N+3 Shift+Tab. Acción `devol`: a qué elemento vuelve el foco al cerrar (Escape, Cancelar/Listo, Enter o Espacio en una fila, clic en el fondo, y apertura con teclado). 🔒6 usa el script de s32 T2 (`/tmp/s32_verif.js`: `tecl_terr`, `tecl_cmp`, `tope`, `escape`), copiado a `/tmp/s32e_l6.js` para que también corra con ventana (`VENTANA=1`).

**M5, M6 y M8** (motor actual, `/tmp/s32e_motor_fase0.html`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s32e_foco.js /tmp/s32e_motor_fase0.html $m ciclo_terr,ciclo_cmp,devol; done > /tmp/s32e_m5m6.jsonl; node /tmp/s32e_l6.js /tmp/s32e_motor_fase0.html tecl_terr,tecl_cmp,tope,escape > /tmp/s32e_m8_headless.json; VENTANA=1 node /tmp/s32e_l6.js /tmp/s32e_motor_fase0.html tecl_terr,tecl_cmp,tope,escape > /tmp/s32e_m8_ventana.json'
```
esperado: **M5** (con ventana y headless, los dos modales): con Tab el foco sale del modal hacia el fondo (en territorio, después de sus ~353 enfocables; en el comparador, que abre en la pestaña Establecimiento sin filas, después de 7), y con Shift+Tab desde el buscador también sale (por arriba, después de las pestañas); ningún ciclo se cierra. **M6:** al cerrar, el foco queda en `BODY` o en un elemento que no es el botón que abrió el modal. **M8:** Tab llega a la fila y Enter elige (territorio); Espacio conmuta (comparador); con el tope, las filas deshabilitadas tienen `tabIndex=-1` y Enter no cambia el conteo; Escape cierra los dos modales; 0 errores.
obtenido (`/tmp/s32e_m5m6.jsonl`, `/tmp/s32e_m8_headless.json`, `/tmp/s32e_m8_ventana.json`; 0 errores de consola y 0 `pageerror` en todas; **con ventana y en headless, resultados idénticos**):
- **M5, territorio** (N = **353**: 5 pestañas, buscador, selector de dependencia, 345 filas, Cancelar; inicio en el buscador): **Tab** → sale en el paso **348**, a `BUTTON.lvl-b "Vista actual"` del panorama de fondo; 9 de 356 pasos fuera; el ciclo no se cierra (0). **Shift+Tab** → sale en el paso **6**, a `BUTTON.screen-tab "Comparación entre…"`; recorre el documento hacia atrás y vuelve a entrar al modal por el final (cola de índices 81, 80, …, 76): 74 pasos fuera; 0 cierres de ciclo.
- **M5, comparador** (N = **7**: 5 pestañas, buscador, Listo; abre en Establecimiento, sin filas): **Tab** → sale en el paso **2**, a `BUTTON.lvl-b "4° básico"`; 9 de 10 fuera. **Shift+Tab** → sale en el paso 6, a `BUTTON.screen-tab`; 5 fuera. 0 cierres de ciclo. **Caso malo confirmado.**
- **M6:** al cerrar, el foco queda en **`BODY`** en todos los casos: territorio con Escape, con Cancelar, con Enter en una fila (el disparador pasa a `comuna de Algarrobo ▾`), con clic en el fondo (que **cierra** el modal) y abierto con teclado (foco en `.terr-trigger` + Enter) y cerrado con Escape; comparador con Escape, con Listo, con Espacio en una fila más Listo (1 chip) y con clic en el fondo (cierra). El botón de origen existe en todos (`origen_existe: true`). Coincide: T1 hace también la devolución.
- **M8 (🔒6, línea base):** headless y con ventana: territorio, Tab llega a la fila en 2 y Enter elige y cierra (`trigger_contiene_fila: true`); comparador, Espacio `0 → 1 de 10` y otra vez `→ 0 de 10`; tope `10 de 10`, fila deshabilitada con `tabIndex=-1` y Enter sin cambio (`10 de 10`); Escape cierra los dos modales.

- **Estado de FASE 0:** completada. M1–M8 coinciden con su esperado. Ninguna tarea congelada; sin gates.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `d9016c0` (hijo de `f5ae215` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno.

### FASE T1: el foco se queda dentro del modal y vuelve a su origen al cerrar

- **Paso 0:** M5 (sale con Tab y Shift+Tab en los dos modales), M6 (vuelve a `BODY`), M7 (el hermano no lo resuelve), M8 (línea base de 🔒6). Lectura de `EntityModal`: el `autoFocus` del buscador se aplica en la fase de commit de React, **antes** de los efectos del componente padre, así que un efecto que leyera `document.activeElement` al montar vería el buscador y no el botón de origen; el origen se captura en el **primer render** (`useState(()=>document.activeElement)`), antes del commit. Clic en el fondo: cierra el modal (comportamiento actual, se conserva).
- **Implementación** (solo `EntityModal` y un ayudante junto a él):
  - `_enfocablesModal(m)`: `button, input, select, textarea, a[href], [tabindex]` dentro de la caja, no deshabilitados, con `tabIndex >= 0` y con cajas (`getClientRects().length > 0`), en orden de documento; se calcula en cada pulsación (la lista cambia con la pestaña, la búsqueda y el tope).
  - `ref` en `.modal`; un `keydown` de `window` (separado del de Escape, que queda igual) para Tab: si el foco está fuera del modal o en un elemento que no es de la lista, lo lleva al primero; Tab en el último → primero; Shift+Tab en el primero → último.
  - Origen: `useState(()=>document.activeElement)` en el primer render; al desmontar (limpieza de `useEffect`), si el origen sigue en el documento, recibe el foco.
  - Foco inicial en el buscador, Escape, orden interno y una parada por fila (D-3 de s32): sin cambios.
  - Comentario pedido: "s32e: aria-modal=true promete que el foco no sale; aquí se cumple (D-2 de s32)".
- **Diff:** `+23/−1` en la plantilla (ayudante `_enfocablesModal` con su comentario; bloque de foco en `EntityModal`; `ref={modalRef}` en `.modal`). **Decisión autónoma D-A1:** con el foco fuera de la caja, Shift+Tab lo lleva al **último** enfocable (el encargo solo dice qué hace Tab: al primero); es el espejo natural del ciclo.
- **Instrumento, ampliado antes de verificar:** `devol` agrega **Espacio sobre una fila del modal de territorio**: como el foco vuelve al botón de origen al cerrar, el `keyup` de Espacio podría activar ese botón y reabrir el modal. Riesgo de este mismo cambio; se mide.
- **Verificación** (build temporal con `run_all(only = 35L)`; el motor se commitea en T2):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32e_run_t1.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32e_run_t1.log; cp $R/40_salidas/motor_idps.html /tmp/s32e_motor_t1.html; md5 -q /tmp/s32e_motor_t1.html; bash /tmp/s32e_payload_sha.sh /tmp/s32e_motor_t1.html | grep -o "sha256_norm\":\"[0-9a-f]*"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in ventana headless; do node /tmp/s32e_foco.js /tmp/s32e_motor_t1.html $m ciclo_terr,ciclo_cmp,devol,lista_cmp; done > /tmp/s32e_t1.jsonl; node /tmp/s32e_l6.js /tmp/s32e_motor_t1.html tecl_terr,tecl_cmp,tope,escape > /tmp/s32e_t14_headless.json; VENTANA=1 node /tmp/s32e_l6.js /tmp/s32e_motor_t1.html tecl_terr,tecl_cmp,tope,escape > /tmp/s32e_t14_ventana.json'
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…4dc4` (= M3). Con ventana **y** headless: **T1.1** territorio (N = 353) y comparador (N = 7): 0 pasos fuera en N+3 Tab y en N+3 Shift+Tab; el ciclo se cierra (Tab del último al primero ≥ 1 vez; Shift+Tab del primero al último ≥ 1 vez). **T1.2** comparador: en la pestaña Comuna con "san" escrito, 0 fuera y ciclo cerrado; con el tope lleno (`10 de 10`, pestaña Región), 0 fuera, **0 pasos** en filas deshabilitadas y ciclo cerrado. **T1.3** el foco queda en el botón de origen (`es_origen: true`) al cerrar con Escape, Cancelar/Listo, Enter en una fila (territorio), Espacio en una fila más Listo (comparador) y abriendo con teclado; y Espacio en una fila del territorio **no reabre** el modal. **T1.5** clic en el fondo: el modal se cierra (comportamiento actual) y el foco vuelve al origen. **T1.4** (🔒6): igual que M8. 0 errores.
obtenido (`/tmp/s32e_t1.jsonl`, `/tmp/s32e_t14_*.json`; **con ventana y en headless, idénticos**; 0 errores y 0 `pageerror`): `rc=0`; `0`; motor temporal `be437ac0655cbb1cc57485a30b25654a`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3).
- **T1.1:** territorio (N = 353): Tab **0** fuera en 356 pasos, el ciclo se cierra 1 vez (del 352 al 0; cola 3, 4, …, 8); Shift+Tab **0** fuera, se cierra 1 vez (del 0 al 352; cola 7, 6, …, 2). Comparador (N = 7): Tab 0 fuera, 2 cierres (cola 3, 4, 5, 6, 0, 1); Shift+Tab 0 fuera, 1 cierre (cola 0, 6, 5, …, 2).
- **T1.2:** comparador, pestaña Comuna con "san": N = 38, 0 fuera, ciclo cerrado (1). Tope lleno en Región (`10 de 10`, 6 deshabilitadas): N = 18 (5 pestañas, buscador, selector, 10 filas marcadas, Listo), 0 fuera, **0 pasos en filas deshabilitadas**, ciclo cerrado (1).
- **T1.3:** foco en el origen (`es_origen: true`) en todos: territorio con Escape, Cancelar, Enter en una fila (`comuna de Algarrobo ▾`), **Espacio en una fila (modal cerrado, no se reabre)** y abierto con teclado + Escape → `BUTTON.terr-trigger`; comparador con Escape, Listo, y Espacio en una fila + Listo (1 chip) → `BUTTON.cmp-add`.
- **T1.5:** clic en el fondo: el modal se cierra (`modal_cerrado: true`) y el foco vuelve al origen, en los dos modales.
- **T1.4 (🔒6):** idéntico a M8 con ventana y en headless: fila en 2 Tab y Enter elige; Espacio `1 de 10` → `0 de 10`; tope `10 de 10`, `tabIndex=-1`, Enter sin cambio; Escape cierra los dos.
- **T1.6** = M5 (motor anterior: sale del modal en los dos sentidos y en los dos modales).
- **Regresión:** build `rc=0`, 0 warnings; modales abiertos y cerrados en cada corrida sin errores (PRUEBAS b completa, en T2).
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: ` M 30_procesamiento/35_motor_template.html` (ALCANCE de T1), ` M 40_salidas/motor_idps.html` (temporal; va en T2) y el LOG.
obtenido: ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? …s32e_log.md`. Solo la plantilla se agrega.
- **Commit:** `620df50` fix(motor): el foco se queda en el modal y vuelve a su origen (s32e T1). `git show --name-only HEAD` = la plantilla.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: build

- **Pasos 1 a 3** (PRUEBAS a con el pipeline completo; PRUEBAS b completa: los dos modales abiertos y cerrados con `/tmp/s32_verif.js consola`, una ficha con `/tmp/s32c_t1.js`, una comparación con `/tmp/s32d_cmp.js`; T1.1 y T1.3 con ventana y headless sobre el motor commiteable; testigo):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32e_run_t2.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32e_run_t2.log; grep -c "Paso 3[1-5] OK" /tmp/s32e_run_t2.log; git -C $R status --porcelain; M=$R/40_salidas/motor_idps.html; md5 -q $M; bash /tmp/s32e_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_verif.js $M consola | tr -d "\n " | grep -oE "\"(modal_[a-z]+|consola_errores|pageerror)\":[^,}]*" | tr "\n" " "; echo; node /tmp/s32c_t1.js $M | tr -d "\n " | grep -oE "\"(glosa_existe|errores)\":[^,}]*" | tr "\n" " "; echo; node /tmp/s32d_cmp.js $M 430 - base | grep -oE "\"(errores|th|desbordadas)\":[^]}]*[]]?" | tr "\n" " "; echo; for m in ventana headless; do node /tmp/s32e_foco.js $M $m ciclo_terr,ciclo_cmp,devol; done > /tmp/s32e_t2.jsonl; grep -c "s32e: aria-modal=true promete que el foco no sale" $M; grep -c "s32e: aria-modal=true promete que el foco no sale" $R/docs/index.html'
```
esperado: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`, 0 warnings, 5 pasos; porcelain después, el mismo; motor `be437ac0…` (= build temporal de T1); §8.2 `eb4e00b3…`; modales `true`, 0 errores; ficha, 0 errores; comparación a 430 px `[210, 150 ×4]`, 0 desbordes, 0 errores; T1.1 y T1.3 como en T1, en los dos modos; testigo `1` en el motor y `0` en `docs/index.html`.
obtenido: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`; `0`; `5`; porcelain después, el mismo; motor `be437ac0655cbb1cc57485a30b25654a` (= T1); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `glosa_existe: true`, `errores: []`; comparación a 430 px `th [210,150,150,150,150]`, 0 desbordadas, 0 errores. T1.1 (con ventana y headless): territorio N 353, Tab 0 fuera / 1 cierre, Shift+Tab 0 fuera / 1 cierre; comparador N 7, Tab 0 / 2, Shift+Tab 0 / 1. T1.3: `es_origen: true` en los 10 cierres, en los dos modos; Espacio en una fila no reabre (`false`); 0 errores. **Testigo del despliegue futuro:** "s32e: aria-modal=true promete que el foco no sale" → `1` en el motor, `0` en `docs/index.html`.
- **Paso 4 (commit):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s32e foco retenido en el modal" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: commit con solo el motor (`be437ac0…`); porcelain después: solo el LOG.
obtenido: `919af1f build(motor): s32e foco retenido en el modal`; `40_salidas/motor_idps.html`; `be437ac0655cbb1cc57485a30b25654a`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `d9016c0`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `d9016c0` (hijo de `f5ae215` = `origin/main`); commits `d9016c0`, `620df50`, `919af1f` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0, en el build de T1 y en T2; ciego a la fecha, ve una cifra plantada (M3) |
| R-03 | M5 / T1.6: en el motor anterior el foco sale del modal con Tab y con Shift+Tab, en los dos modales y en los dos modos |
| R-04 | M6: en el motor anterior el foco vuelve a `BODY` al cerrar |
| R-05 | M7: el hermano no maneja el foco en su modal |
| R-06 | T1.1: 0 pasos fuera en N+3 Tab y Shift+Tab, ciclo cerrado, en los dos modales y en los dos modos |
| R-07 | T1.2: con búsqueda y con el tope, 0 fuera, ciclo cerrado y 0 paradas en filas deshabilitadas |
| R-08 | T1.3 / T1.5: el foco vuelve al origen en los 10 cierres; Espacio en una fila no reabre; clic en el fondo cierra y devuelve |
| R-09 | T1.4 / 🔒6: Enter/Espacio, tope y Escape como antes (M8), con ventana y headless |
| R-10 | T2: build completo sin cambios en derivados; motor `be437ac0…`; testigo 1 en el motor y 0 en `docs/` |
| 🔒1–🔒6 | invariantes de §3 |
| ALC | alcance global ⊆ ALCANCE de T1–T2 + LOG + encargo |
| REG | PRUEBAS a, b y c sobre el estado final |

**Paso 2. Re-derivación en navegador** (`/tmp/s32e_foco.js`, otra vía: el ciclo contado además con `document.querySelector('.modal :focus')`, en **otra pestaña** de cada modal —Región en el de territorio, SLEP en el del comparador— y un cierre **solo con teclado**: abrir con Espacio o Enter sobre el disparador, Shift+Tab hasta el botón del pie, cerrar con Espacio o Enter; sobre el motor final en los dos modos y sobre el anterior en headless):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; (for m in ventana headless; do node /tmp/s32e_foco.js $M $m ciclo_terr_region,css,devol_teclado; done; node /tmp/s32e_foco.js /tmp/s32e_motor_fase0.html headless ciclo_terr_region,css,devol_teclado) > /tmp/s32e_r_nav.jsonl'
```
esperado: motor final (dos modos): Región del territorio y SLEP del comparador con 0 pasos fuera por índice **y** 0 por `:focus` (`css_fuera: 0`), ciclo cerrado en los dos sentidos; cierre con teclado: el modal abre, el foco llega al botón del pie, el modal se cierra, no se reabre y el foco queda en el disparador. Motor anterior: pasos fuera > 0 por índice y por `:focus`; al cerrar con teclado, el foco no queda en el disparador. 0 errores.
obtenido (`/tmp/s32e_r_nav.jsonl`; 0 errores en las tres corridas): **motor final, con ventana y headless:** territorio en Región (N = 24): Tab 0 fuera y `css_fuera 0`, ciclo 1; Shift+Tab 0 y 0, ciclo 1. Comparador en SLEP (N = 43): Tab 0 y 0, ciclo 1; Shift+Tab 0 y 0, ciclo 1. Cierre solo con teclado: territorio abre con Espacio, el foco llega a Cancelar, Espacio lo cierra, **no se reabre** y queda en `BUTTON.terr-trigger` (`es_origen: true`); comparador abre con Enter, llega a Listo, Enter lo cierra y queda en `BUTTON.cmp-add` (`true`). **Motor anterior (headless):** Región: Tab 9 fuera / 9 por `:focus`, Shift+Tab 22 / 22, 0 cierres; SLEP: 9 / 9 y 11 / 11, 0 cierres; cierre con teclado: el foco **nunca llega** al botón del pie (sale del modal por arriba), el Espacio o Enter cae en la página y el modal sigue abierto (`BODY`). R-03, R-06 y R-08 confirmados por otra vía (`:focus`, otra pestaña, otro modo de cerrar).

**Pasos 3 a 6** (`/tmp/s32e_final.sh`: invariantes con los comandos de §3 —🔒6 con el script de s32 T2, en los dos modos—; alcance con lista explícita; regresión completa con `run_all()` y PRUEBAS b completa; controles positivos: dos copias del motor final fuera del árbol, una **sin la trampa de Tab** y otra **sin la devolución**, más los de siempre):
```
bash /tmp/s32e_final.sh
```
esperado: L1 `eb4e00b3…`; L2a `63` y `9842151d…`, L2b `0`; L3 `0`; L4 `0`; L5 `0`; L6 (headless y ventana) `True 2 False True 1 de 10 0 de 10 10 de 10 -1 10 de 10 False False [] []` (= M8). ALC 2 rutas, 0 fuera, porcelain solo el LOG. REGa `rc=0`, 0 warnings, 5 pasos, motor `be437ac0…`, porcelain solo el LOG. REGb modales `true`, ficha y comparación sin errores ni desbordes. REGc `eb4e00b3…`. Los dos plantados difieren del motor; C1 pasos fuera > 0; C2 `origen en 0 de 10`; C3 `1`; C4 `1`; C5 `docs/index.html`; C6 `1c3799e2…`.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **🔒1 PASA**; `L2a: lineas: 63; md5 9842151d897e8768abd2207513c6607b ; L2b: 0` → **🔒2 PASA**; `L3: 0` → **🔒3 PASA**; `L4: 0` → **🔒4 PASA**; `L5: 0` → **🔒5 PASA**; `L6 headless` y `L6 ventana`: `True 2 False True 1 de 10 0 de 10 10 de 10 -1 10 de 10 False False [] []` (= M8) → **🔒6 PASA**. `ALC: rutas 2 ; fuera 0 ; porcelain [?? …s32e_log.md]` → **alcance PASA**. `REGa: rc=0 warn=0 pasos=5 motor=be437ac0655cbb1cc57485a30b25654a`, porcelain solo el LOG; REGb modales `true`/`true`, 0 errores; ficha `glosa_existe: true`, 0 errores; comparación 0 errores, 0 desbordes; `REGc: eb4e00b3…` → **regresión PASA**. Controles: los dos plantados difieren del motor; **C1** sin la trampa: `Tab fuera 9 Shift fuera 5`; **C2** sin la devolución: `origen en 0 de 10`; C3 `1`; C4 `1`; C5 `docs/index.html`; C6 `1c3799e2e8e35da8`. **Todos disparan.**

**Hallazgo nuevo de la auditoría (R-11), buscado a propósito como caso límite de la devolución:** si el foco vuelve al disparador **dentro** del mismo `keydown` que cierra el modal (React 18 vacía los efectos de un evento discreto de forma síncrona), la **autorrepetición** de una tecla sostenida cae en el disparador y lo activa. Medición (`/tmp/s32e_enter_sostenido.js`: Enter sobre la primera fila del modal de territorio, 1, 2 o 4 `keydown` antes de soltar, el 2.º en adelante con `repeat`):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32e_enter_sostenido.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s32e_motor_fase0.html'
```
esperado: (propio) el modal queda cerrado en los tres casos, en los dos motores.
obtenido: motor final: `enter_simple` cerrado, foco en `terr-trigger`; **`enter_sostenido_2` y `enter_sostenido_4`: el modal queda ABIERTO** (reabierto; foco en `input-search`). Motor anterior: cerrado en los tres (el foco caía en `BODY`, así que la repetición no activaba nada). **Regresión introducida por T1** (la devolución del foco), dentro del ALCANCE, medible y con caso malo calibrado → **REPARA** (ciclo 1).

**Ciclo de reparación 1 (R-11).**
- **Causa raíz:** la devolución del foco ocurre dentro del `keydown` que cierra el modal; las repeticiones de esa misma tecla (Enter o Espacio sostenidos) llegan al disparador ya enfocado, cuya acción por defecto lo reabre.
- **Fix quirúrgico** (`EntityModal`, ALCANCE de T1): al devolver el foco, un `keydown` en captura sobre `window` descarta (`preventDefault` + `stopPropagation`) solo las **repeticiones** (`e.repeat`) de **Enter y Espacio** cuyo destino es el origen, y se retira con el primer `keyup`. Una pulsación nueva no es repetición y pasa.
- **Re-verificación** con el chequeo que lo detectó (`/tmp/s32e_enter_sostenido.js`) **y** con uno distinto (`/tmp/s32e_sostenido2.js`: Espacio sostenido sobre una fila del territorio; Enter sostenido sobre Listo del comparador; y que una pulsación **nueva** de Enter sobre el disparador siga abriendo), sobre un build temporal (`run_all(only = 35L)`), más la regresión de 🔒6 y del ciclo:
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32e_run_r11.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32e_run_r11.log; M=$R/40_salidas/motor_idps.html; md5 -q $M; bash /tmp/s32e_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32e_enter_sostenido.js $M; node /tmp/s32e_sostenido2.js $M /tmp/s32e_motor_t1.html; for m in ventana headless; do node /tmp/s32e_foco.js $M $m ciclo_terr,ciclo_cmp,devol,lista_cmp,devol_teclado; done > /tmp/s32e_r11.jsonl; node /tmp/s32e_l6.js $M tecl_terr,tecl_cmp,tope,escape > /tmp/s32e_r11_l6.json'
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…`; `enter_simple`, `enter_sostenido_2` y `enter_sostenido_4` con el modal **cerrado** y el foco en `terr-trigger`; con el motor reparado: Espacio sostenido en una fila → cerrado; Enter sostenido en Listo → cerrado, foco en `cmp-add`; **Enter nuevo sobre el disparador → abre** (`true`); con el motor de T1 (`/tmp/s32e_motor_t1.html`, caso malo): los dos sostenidos reabren. Ciclo, devolución (10 de 10), lista y cierre con teclado como en T1, en los dos modos; 🔒6 = M8; 0 errores.
obtenido: `rc=0`; `0`; motor temporal `4b485f4fe40d4a75f0cb6fdaa275bff4`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`. Chequeo que lo detectó: `enter_simple`, `enter_sostenido_2`, `enter_sostenido_4` → **cerrado**, foco `terr-trigger` en los tres. Chequeo distinto, motor reparado: Espacio sostenido en una fila → cerrado (`terr-trigger`); **Enter nuevo sobre el disparador → abre (`true`)**; Enter sostenido en Listo → cerrado (`cmp-add`). Motor de T1 (caso malo): Espacio sostenido → **reabierto**; Enter sostenido en Listo → **reabierto** (el instrumento distingue). Regresión (con ventana y headless): territorio Tab 0 fuera / 1 cierre, Shift+Tab 0 / 1; comparador 0 / 2 y 0 / 1; devolución 10 de 10, Espacio no reabre; lista con "san" N 38, 0 fuera, 1 cierre; tope 0 fuera, 0 en deshabilitadas; cierre con teclado → origen en los dos, modal cerrado; 🔒6 `True 2 False True 1 de 10 0 de 10 10 de 10 -1 10 de 10`, Escape cierra los dos; 0 errores.
- **Regresión completa y commit de la reparación** (plantilla + motor, los dos dentro de la unión de ALCANCE):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32e_run_r11b.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32e_run_r11b.log; md5 -q $R/40_salidas/motor_idps.html; git -C $R status --porcelain; git -C $R add 30_procesamiento/35_motor_template.html 40_salidas/motor_idps.html && git -C $R commit -q -m "fix(auditoria): R-11 Enter o Espacio sostenidos reabrian el modal" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R status --porcelain'
```
esperado: `rc=0`, 0 warnings; motor `4b485f4f…` (= temporal del fix); porcelain antes: plantilla, motor y LOG; commit con esas dos rutas; después, solo el LOG.
obtenido: `rc=0`; `0`; `4b485f4fe40d4a75f0cb6fdaa275bff4`; porcelain antes: ` M` plantilla, ` M` motor, `??` LOG; **`379582a fix(auditoria): R-11 Enter o Espacio sostenidos reabrian el modal`** con `30_procesamiento/35_motor_template.html` y `40_salidas/motor_idps.html`; después, solo el LOG.

**Pasos 2 a 5 repetidos sobre lo tocado** (mismo `/tmp/s32e_final.sh`, con dos ajustes: el control C2 ahora planta la devolución quitada en su forma nueva, reemplazando la línea `      origen.focus();` —única en el motor, `grep -c` → `1`—; y se agregan la medición de R-11 y el testigo):
```
bash /tmp/s32e_final.sh
```
esperado: todo como en la primera corrida (🔒1–🔒6 PASA, alcance 2 rutas y 0 fuera, regresión `rc=0` y árbol limpio, motor `4b485f4f…`, controles que disparan con C2 `origen en 0 de 10`); R-11 cerrado en los tres casos; testigo `1` en el motor y `0` en `docs/`.
obtenido: L1 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; L2a `63`, `9842151d897e8768abd2207513c6607b`, L2b `0`; L3 `0`; L4 `0`; L5 `0`; L6 headless y ventana `True 2 False True 1 de 10 0 de 10 10 de 10 -1 10 de 10 False False [] []` → **🔒1–🔒6 PASA**. `ALC: rutas 2 ; fuera 0` → PASA. `REGa: rc=0 warn=0 pasos=5 motor=4b485f4fe40d4a75f0cb6fdaa275bff4`, porcelain solo el LOG; REGb modales `true`/`true`, 0 errores; ficha y comparación sin errores, 0 desbordes; `REGc: eb4e00b3…` → PASA. R-11: `enter_simple`/`sostenido_2`/`sostenido_4` cerrados, foco `terr-trigger`. **Testigo: motor `1`, docs `0`.** Controles: plantados difieren (`SI`/`SI`); C1 `Tab fuera 9 Shift fuera 5`; **C2 `origen en 0 de 10`** (dispara con la forma nueva); C3 `1`; C4 `1`; C5 `docs/index.html`; C6 `1c3799e2e8e35da8`.

**Pasos 7-8. Veredicto y reparación.** 0 BLOQUEA. 1 REPARA (R-11), reparado en el ciclo 1 de 2 (`379582a`), re-verificado con el chequeo que lo detectó y con uno distinto, con su regresión. Nada sobrevive al ciclo.

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `git log` | padre `f5ae215` | `d9016c0` → `620df50`, `919af1f`, `379582a` | — | ninguna | — | — |
| R-02 | §8.2 constante | L1 y REGc | `eb4e00b3…` | igual | — | ninguna | — | C6 |
| R-03 | caso malo (M5/T1.6) | `:focus` en otra pestaña, motor anterior | sale | 9/9, 22/22, 9/9, 11/11 | — | ninguna | — | C1 |
| R-04 | vuelve a `BODY` (M6) | cierre solo con teclado, motor anterior | no vuelve al origen | `BODY`, modal abierto | — | ninguna | — | C2 |
| R-05 | el hermano no maneja el foco | `grep` de foco/Escape/aria-modal | sin manejo | sin manejo | — | ninguna | — | — |
| R-06 | ciclo cerrado (T1.1) | `:focus` + índice, Región y SLEP, dos modos | 0 fuera; ciclo | 0/0; 1 | — | ninguna | — | — |
| R-07 | lista que cambia (T1.2) | repetido tras R-11 | 0 fuera; 0 en deshabilitadas | 0; 0 | — | ninguna | — | — |
| R-08 | devolución (T1.3/T1.5) | cierre solo con teclado; 10 cierres | origen | origen | — | ninguna | — | C2 |
| R-09 | 🔒6 | script de s32 T2, dos modos | = M8 | = M8 | — | ninguna | — | — |
| R-10 | build limpio y testigo | `run_all()`; `grep -c` | árbol limpio; 1/0 | igual | — | ninguna | — | — |
| **R-11** | **Enter/Espacio sostenidos no reabren el modal** | `/tmp/s32e_enter_sostenido.js`; `/tmp/s32e_sostenido2.js` | cerrado | **reabierto** en el motor de T1 → cerrado tras el fix | **REPARA** | descartar repeticiones de Enter/Espacio sobre el origen hasta el `keyup` | `379582a` | sí (dos chequeos + regresión + pasos 2-5) |
| A-1 | origen que desaparece | lectura del código | — | si el botón de origen ya no está (el comparador llega a 10 entidades y oculta "+ agregar entidad"; elegir un establecimiento en el modal de territorio lleva a la ficha), el foco no puede volver y queda en `BODY` (lo que pide el encargo: "si sigue en el documento") | ADVIERTE (no medido aquí) | nota | — | — |
| 🔒1–🔒6 | invariantes | `/tmp/s32e_final.sh` (dos veces) | ver arriba | todos PASA | — | — | — | C1–C6 |
| ALC | alcance global | lista + `grep -vxF` | 0 fuera | 0 (2 rutas) | — | — | — | C5 |
| REG | PRUEBAS a, b, c | `/tmp/s32e_final.sh` | `rc=0`, árbol limpio; 0 errores; `eb4e00b3…` | iguales | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/1/1; reparados 1 (R-11); abiertos 1 (A-1, nota).
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** ninguno de instrumento; R-11 es un defecto del trabajo de T1, encontrado y reparado aquí.

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 4 respecto de `origin/main`.
obtenido: `?? 50_documentacion/andamios/logs/20260923_foco_modal_s32e_log.md` (única); `## main...origin/main [ahead 4]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s32e (D-2 de s32: el modal no retenía el foco). Fases: FASE 0, T1, T2, R (con un ciclo de reparación) y L. Estado del grafo: T1 completada (`620df50`, reparada en `379582a`) · T2 completada (`919af1f`, motor actualizado en `379582a`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Sin gates.
2. **Commits** (`git log f5ae215..HEAD --oneline`, antes del commit de este log):
   - `d9016c0` chore(encargo): s32e — FASE 0 (= `<inicio>`)
   - `620df50` fix(motor): el foco se queda en el modal y vuelve a su origen (s32e T1)
   - `919af1f` build(motor): s32e foco retenido en el modal — motor `be437ac0…`
   - `379582a` fix(auditoria): R-11 Enter o Espacio sostenidos reabrian el modal — plantilla y motor `4b485f4fe40d4a75f0cb6fdaa275bff4`
   - (este log: `docs(log): s32e foco retenido en el modal`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/1/1; reparados 1.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, en T1, en T2, en el fix y en la regresión) · 🔒2 PASA · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA · 🔒6 PASA (Enter/Espacio, tope y Escape idénticos a M8, con ventana y headless, antes y después de R-11). 6/6.
5. **Decisiones del titular en gates:** ninguna.
6. **Estado de cifras y secuencias de foco** (hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en todos los builds; con ventana y headless, idénticas):

   | modal (N enfocables) | antes (`020418b`) | después (`379582a`) |
   |---|---|---|
   | territorio, Comuna (353) | Tab sale en el paso 348 al panorama de fondo; Shift+Tab sale en el paso 6; 0 ciclos | 0 pasos fuera en 356 Tab y 356 Shift+Tab; ciclo cerrado en los dos sentidos |
   | territorio, Región (24) | sale (9 y 22 pasos fuera) | 0 fuera (también por `:focus`); ciclo cerrado |
   | comparador, Establecimiento (7) | Tab sale en el paso 2; Shift+Tab en el 6 | 0 fuera; ciclo cerrado |
   | comparador, SLEP (43) / Comuna con búsqueda (38) / tope (18) | sale | 0 fuera; ciclo cerrado; 0 paradas en filas deshabilitadas |
   | al cerrar (10 vías) | foco en `BODY` | foco en el botón que abrió el modal (10 de 10); Enter o Espacio sostenidos no lo reabren |

   Motor `ae30a4e9…` → `4b485f4f…`; `docs/` sin cambios (`ae30a4e9…`).
7. **Dudas y pendientes consolidados:**
   - A-1: si el botón de origen desaparece al cerrar (el comparador llega a 10 entidades y oculta "+ agregar entidad"; elegir un establecimiento en el modal de territorio lleva a la ficha), el foco queda en `BODY`. ¿Se quiere un destino alternativo para esos dos casos (por ejemplo, el primer chip del comparador o el título de la ficha)? (sí/no). Bloquea: nada.
   - **Testigo del próximo despliegue:** "s32e: aria-modal=true promete que el foco no sale" (`grep -c` → `1` en el motor, `0` en `docs/index.html`).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** R-11 (defecto del trabajo de T1: la devolución del foco dentro del mismo `keydown` dejaba que la autorrepetición de Enter o Espacio reabriera el modal). Lo encontró la auditoría con un caso límite buscado a propósito y se reparó en el ciclo 1 (`379582a`). Costo: un ciclo de reparación, un build y una re-verificación completa (unos 10 minutos). Ningún error de instrumento en esta sesión.
9. **Notas para el revisor:** (a) gate visual en los dos modales: Tab y Shift+Tab dan la vuelta dentro del modal (en el de territorio, con 345 comunas, llegar al final con Tab toma su tiempo: Shift+Tab desde el buscador llega antes al botón Cancelar); (b) al cerrar con Escape, Cancelar, Listo, eligiendo una fila o con clic en el fondo, el foco vuelve al botón que abrió el modal (el contorno de foco se ve si se llegó con teclado); (c) mantener Enter apretado sobre una fila ya no reabre el modal; (d) nada se desplegó.
10. **Estado de cierre:** commiteados `d9016c0`, `620df50`, `919af1f`, `379582a` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s32e_priv.sh`, adaptado de s32d: RUT con la expresión en una variable y control plantado en un archivo aparte; "RBD" seguido de número; nombres de establecimiento; nombre de la estación):
```
bash /tmp/s32e_priv.sh
```
esperado: `0`; plantado `1`; `0`; `0`; `0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `estación por nombre: 0`. El log nombra territorios públicos (Algarrobo, Región de Tarapacá, SLEP Aconcagua…) y ningún establecimiento ni persona.

Paso 5, primera medición (sin contar el par del paso 4): `### FASE` = 5 (FASE 0, T1, T2, R, L); `## J` = 1, relleno; **`^esperado:` = 14 y `^obtenido:` = 11**. Causa: tres resultados se escribieron como `obtenido (<archivo>):` (M5/M6/M8, la verificación de T1 y la re-derivación en navegador de FASE R): el mismo desliz de s32c y s32d. Se anexa lo faltante con su estado real:
obtenido: (anexo de formato a M5/M6/M8) el foco sale del modal con Tab y Shift+Tab en los dos modales y en los dos modos; al cerrar vuelve a `BODY`; la línea base de 🔒6 es la esperada.
obtenido: (anexo de formato a la verificación de T1) 0 pasos fuera, ciclo cerrado, 0 paradas en deshabilitadas, foco devuelto en 10 de 10, 🔒6 igual a M8, en los dos modos.
obtenido: (anexo de formato a la re-derivación de FASE R) Región y SLEP con 0 fuera por índice y por `:focus`; cierre solo con teclado devuelve el foco; el motor anterior falla en todo.

Segunda medición:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260923_foco_modal_s32e_log.md; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L)"; bash /tmp/s32e_priv.sh | head -1'
```
esperado: `FASE=5`; `esperado=16` y `obtenido=15` al medir (este par todavía sin su `obtenido:`); `J=1`; `RUT en el log: 0`.
obtenido: `FASE=5 esperado=16 obtenido=15 J=1`; `RUT en el log: 0`. Con esta línea, **16 = 16**.
