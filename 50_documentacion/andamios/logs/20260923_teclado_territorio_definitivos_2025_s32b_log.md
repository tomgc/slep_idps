# Log de sesión: teclado del modal de territorio y datos definitivos 2025 (s32b)

- **Meta:** que el modal de territorio se opere con teclado en Chrome con ventana (Tab desde el buscador llega a una fila con contorno visible; Enter o Espacio elige y cierra) (T1); que el motor lea los IDPS 2025 definitivos en 4b, 2m y 8b, sin marca preliminar en 2025, con los años anteriores idénticos y los preliminares archivados, no borrados (T2); regenerar el motor (T3).
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `f0c24e9` (= `origin/main` tras el push de s32). Primer acto, antes de medir nada más (autorizado): commit del encargo `d0d4414` chore(encargo): s32b, hijo de `f0c24e9`. **PUNTO DE RETORNO `<inicio>` = `d0d4414`.** `git status --porcelain`, `git stash list` y `rev-parse` se miden en M1/M2 y se copian aquí al cerrar FASE 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv` del proyecto; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real de la sesión:** Opus 5.5 (1M), esfuerzo `xhigh` (el titular lo fijó con `/effort` al abrir el turno; `ultracode` apagado). **Sin subagentes**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_teclado_territorio_definitivos_2025_s32b.md` (commit `d0d4414`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (teclado del modal de territorio)  ALCANCE: 30_procesamiento/35_motor_template.html
T2 (definitivos 2025)                 ALCANCE: 20_insumos/ (los 24 nombres autorizados y definitivos_2025/),
                                      _archivo/20260923/ (fuera de git) y los derivados que el pipeline
                                      reescribe por sí mismo (lista fijada por M9)
T3 (build final)                      ALCANCE: 40_salidas/motor_idps.html; requiere T1 o T2 completada
T1 y T2 independientes; en serie por el build compartido: T1 → T2 → T3
FASE R y FASE L                       fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s32b_*` (autorización del encargo); se reutilizan como modelo los de s32 (`/tmp/s32_*`) cuando siguen en disco.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: los IDPS 2025 definitivos reemplazan a los preliminares en 4b, 2m y 8b, sin marca preliminar en 2025, con los años anteriores idénticos y los preliminares archivados; motor regenerado → cumplida. El teclado del modal de territorio → **no cumplida**: T1 congelada, porque el defecto del gate no se reproduce.
- Estado por tarea: FASE 0 completada (1 gate, H-1) · T1 congelada (D-1, sin commit) · T2 completada (`364c53a`) · T3 completada (`e7848df`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 4, rango `d0d4414`..`<docs(log)>` (`git log --oneline f0c24e9..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor), 1 data(insumos) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/6; reparados 0; abiertos 6 (A-1 premisa de calibración de M3; D-1 T1 no reproducible; A-3 la hora en `censo_insumos.md` ensucia todo `run_all()`; O-1 derivados desfasados desde junio; O-2 índice con seis nombres en mayúscula; D-DESV-1 aclaración en el mensaje del commit de T3).
- Invariantes: 6/6 PASA (🔒1 `identical TRUE` en 1.770.628 filas y `anti_join` 0/0; 🔒6 12 de 12 preliminares archivados con su md5); FALLA: ninguno.
- Cifras críticas: años distintos de 2025 intactos (evidencia: 🔒1 por `identical()` y `anti_join`; control plantado → FALSE). 2025 cambia poco: 4b, 10 celdas de `prom` (máx 2); 2m, 25 celdas (máx 4), 4 `sigdifgru` y 22 filas; 8b, 0. Hash §8.2 `900913c1…` → `eb4e00b3…`.
- Decisiones autónomas de mayor riesgo: (1) D-A1: T3 y la regresión construyen el motor en el árbol con `run_all(only = 35L)`, y el pipeline completo se prueba en un clon APFS en `/tmp`, porque un `run_all()` completo reescribe la hora de `censo_insumos.md` fuera del ALCANCE de T3; reversible. (2) El `git rm --cached` se hizo sobre las rutas en mayúscula que guardaba el índice (O-2). (3) El commit de T3 lleva una aclaración entre paréntesis sobre T1.
- Desviaciones respecto del encargo: la calibración de M3 se sustituyó por un control plantado (gate H-1); PRUEBAS a completo se corrió en un clon y no en el árbol (D-A1); el mensaje del commit de T3 lleva la aclaración "(T1 congelada: sin cambio de teclado)"; el esperado literal de M1 y de T3 paso 1 no contaba el LOG, que el propio encargo manda crear antes.
- Dudas abiertas: 3 (D-1 ¿en qué paso se cortó el teclado, y se recargó la pestaña tras `4a22cbc`? · D-2 ¿quitar la hora de `censo_insumos.md` o dejar de versionarlo? · D-3 ¿chequeo de derivados en el cierre de sesión?).
- Errores propios: 1 (un `rm -rf` preventivo en el texto de un comando, quitado antes de ejecutarlo); costo nulo.
- Qué debe verificar el revisor por sí mismo: el gate visual sobre el motor de `e7848df` **recién recargado**: Tab y Enter en el modal de territorio, y 2025 sin "2025*" ni "(preliminar)"; con su respuesta a D-1 se decide si T1 tiene un defecto real.
- No publicado / queda al usuario: el despliegue a `docs/` (tras el gate visual; testigo: ausencia de "2025*"/"(preliminar)" y `"anios_preliminar":[]`). El push se hace según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo, sin ultracode; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `d0d4414` chore(encargo): s32b (primer acto, antes de medir).

**M1 y M2:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"'
```
esperado: M1 `?? 20_insumos/definitivos_2025/` y, además, este LOG (`?? 50_documentacion/andamios/logs/20260923_teclado_territorio_definitivos_2025_s32b_log.md`): el encargo ordena crearlo antes de medir, así que el esperado literal de la tabla ("solo `definitivos_2025/`") no puede cumplirse en ninguna corrida; se lee como "ninguna ruta fuera de {encargo, `definitivos_2025/`, el LOG}"; stash vacío. M2 `HEAD=d0d4414`, padre `f0c24e9`, `origin/main=f0c24e9`; `HEAD..origin/main=0`; `origin/main..HEAD=1`.
obtenido: `?? 20_insumos/definitivos_2025/`, `?? 50_documentacion/andamios/logs/20260923_teclado_territorio_definitivos_2025_s32b_log.md` (únicas); `stash: []`; `fetch rc=0`; `HEAD=d0d4414 padre=f0c24e9 origin/main=f0c24e9`; `HEAD..origin/main=0 origin/main..HEAD=1`. Reglas 1 y 2 no disparan (la diferencia HEAD↔`origin/main` es exactamente el commit del encargo, como pide M2).

**M3** (`/tmp/s32b_payload_sha.sh` → `/tmp/s32b_payload_norm.js`, copia del instrumento §8.2 de s32; la copia con la fecha alterada la hace `/tmp/s32b_fecha_alterada.js`, que solo cambia `fecha_generacion` a `1999-01-01`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cp $R/40_salidas/motor_idps.html /tmp/s32b_motor_fase0.html; bash /tmp/s32b_payload_sha.sh /tmp/s32b_motor_fase0.html; bash /tmp/s32b_payload_sha.sh $R/docs/index.html /tmp/s32b_motor_fase0.html; node /tmp/s32b_fecha_alterada.js /tmp/s32b_motor_fase0.html /tmp/s32b_motor_fecha_alterada.html; bash /tmp/s32b_payload_sha.sh /tmp/s32b_motor_fecha_alterada.html /tmp/s32b_motor_fase0.html'
```
esperado (de la tabla del encargo): 64 hex; **distinto** sobre `docs/index.html`; igual sobre la copia con la fecha alterada.
obtenido: motor de FASE 0 (`/tmp/s32b_motor_fase0.html`, md5 `1069b9c94b79510f3c26ce77b5cac2f6` = `4a22cbc`): `sha256_norm 900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4` (fecha `2026-09-23`, 59.467.009 bytes). `docs/index.html`: **`900913c1…78b4`, el mismo** (fecha `2026-09-17`; offsets distintos `[38,39]`, solo la fecha). Copia con la fecha alterada: `900913c1…78b4`, igual (offsets `[30,31,32,33,36,38,39]`, todos dentro de la fecha). **La calibración "distinto sobre `docs/index.html`" no se cumple.** Causa, medida: `docs/index.html` (build de s31c, `6c5feab5…`) y el motor de `4a22cbc` (s32) llevan **el mismo dato**: s32 cambió solo la plantilla, y la convención §8.2 neutraliza justamente la única diferencia del JSON (la fecha). El log de s32 ya lo registraba (R-02/R-03: `docs` contra el motor de FASE 0, `offsets_distintos: []`). La premisa del redactor ("otro hash, build distinto") confunde build con dato. El instrumento sí es invariante a la fecha (segunda parte de la calibración: cumple).

Control positivo propio (sustituto de la parte que no puede cumplirse: una copia con **una cifra del dato** cambiada, fuera de la fecha, debe dar otro hash):
```
bash -c 'node /tmp/s32b_plantar_payload.js /tmp/s32b_motor_fase0.html /tmp/s32b_motor_plantado_dato.html; bash /tmp/s32b_payload_sha.sh /tmp/s32b_motor_plantado_dato.html /tmp/s32b_motor_fase0.html'
```
esperado: (propio) `sha256_norm` distinto de `900913c1…`; un offset fuera de la fecha (`region_foco` "5" → "6").
obtenido: `7ab3ce8111bf507bae3650708cefa5fc9c02090283b03ad792fa0ca8bb34f68d`, `offsets_distintos: [82]` (`region_foco` 6 ↔ 5). El instrumento distingue un cambio de dato y es ciego a la fecha. **Hallazgo H-1:** la columna "Si difiere" de M3 congelaría T1 y T3 por una premisa de calibración que el dato hace imposible (docs y el motor tienen el mismo JSON salvo la fecha). Se lleva al titular como gate.

**Gate del titular (H-1):** eligió **"Seguir con el control plantado"**. La calibración de M3 queda: invariancia a la fecha (cumple) + discriminación de un cambio de dato con la copia plantada (cumple, `7ab3ce81…`). Valor de referencia del hash §8.2 en FASE 0: **`900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`**. Queda como error de redacción del encargo (lo consolida FASE L).

**M4 y M5** (`/tmp/s32b_root_md5.sh`, copia del `awk` de s32; `/tmp/s32b_m5.sh`, que empareja cada `_final` con su `_preliminar` por nombre):
```
bash -c 'bash /tmp/s32b_root_md5.sh /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; cp /tmp/s32_root_block.txt /tmp/s32b_root_block_fase0.txt; bash /tmp/s32b_m5.sh'
```
esperado: M4 un md5 (el de s32: `9842151d…`, 63 líneas, si la plantilla no cambió el `:root`); M5 12 finales y 9 + 3 preliminares; los 3 pares de datos de 8b `IGUAL` (md5 `fad1f206…`, `92c4fda7…`, `e3cb579a…`); los otros 6 pares de datos `DISTINTO`; las glosas, sin esperado del encargo (se registra).
obtenido: M4 `lineas: 63; md5 9842151d897e8768abd2207513c6607b` (copia en `/tmp/s32b_root_block_fase0.txt`; valor del 🔒3a). M5: `finales: 12`; `preliminares datos: 9 ; glosas: 3`; 8b `rbd_dim` `fad1f206` = `fad1f206` (4.594.627 bytes), `rbd` `92c4fda7` = `92c4fda7` (1.971.849), `rbd_subdim_niveles` `e3cb579a` = `e3cb579a` (6.475.350) → **IGUAL ×3**; 4b y 2m, 6 pares de datos **DISTINTO** (finales 18–21 % más pesados: p. ej. 4b `rbd` 2.641.550 vs 2.195.120); las 3 glosas también **DISTINTO** (35.187→35.189, 35.170→35.192, 35.161→35.191 bytes; se miden en M7).

**M6 y M7** (`/tmp/s32b_m6_m7.R`: M6 lee cada hoja de cada par como la lee `34_leer_normalizar_idps.R`, `readxl::read_excel(ruta, guess_max = 200000)`, y compara nombres de hoja, nombres de columna y clase; M7 lee todas las hojas de cada glosa como texto sin encabezado y compara celda a celda):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32b_m6_m7.R'
```
esperado: M6 los 9 pares con esquema idéntico (`M6: 9 de 9`); M7 la tabla id↔label de indicadores, dimensiones y subdimensiones idéntica en las 3 glosas (el crosswalk `CW_*` sigue válido); si hay celdas distintas, se leen para decidir si tocan id↔label.
obtenido: **M6** `M6: 9 de 9 pares con esquema idéntico`: todas las hojas son `Hoja1`; dimensiones iguales salvo 2m `rbd_subdim_niveles` (`65978x14` final vs `65956x14` preliminar: 22 filas más, mismo esquema). Regla 4 no dispara. **M7:** las tres glosas tienen las mismas 4 hojas (`Índice`, `idps`, `dim_idps`, `idps_niveles`) y las mismas dimensiones; las únicas celdas distintas son la `[2,2]` de `idps`, `dim_idps` e `idps_niveles` (el nombre del archivo que describen, `…_preliminar` → `…_final`) y, en 2m `idps_niveles`, la `[5,2]` (`65956` → `65978`, el número de filas del archivo). **Ninguna celda de id↔label cambia**: el crosswalk `CW_*` sigue válido.

**M8:**
```
bash -c 'cp /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet /tmp/s32b_largo_antes.parquet && md5 -q /tmp/s32b_largo_antes.parquet && cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32b_m8.R /tmp/s32b_largo_antes.parquet'
```
esperado: 2025 con `preliminar = TRUE` en 4b, 2m y 8b; el resto de los años con `FALSE` (salvo 6b 2024, preliminar, si 6b está en el largo).
obtenido: md5 de la copia `4c764d8c9f0bf70004f8aa52661ae901`; 2.362.447 filas × 30 columnas (entre ellas `nom_rbd`: T2.6 no imprime RBD ni nombres). 2025: 2m `TRUE` 110.941, 4b `TRUE` 259.001, 8b `TRUE` 221.877; 6b 2024 `TRUE` 259.960 (fuera del alcance: no es 2025 y 6b no está en `GRADOS_MOTOR`); todo lo demás `FALSE` (2m 2014–2024, 4b 2014–2024, 6b 2014–2018, 8b 2014–2019). Coincide.

**M9** (build de línea base, pipeline completo, sin tocar nada):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32b_run_m9.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32b_run_m9.log; git -C $R status --porcelain; md5 -q $R/40_salidas/motor_idps.html; md5 -q $R/40_salidas/intermedios/idps_largo.parquet'
```
esperado: `rc=0`; 0 líneas con "warn"; porcelain = los dos `??` conocidos más la lista de derivados que el pipeline reescribe por sí mismo (se fija aquí el ALCANCE de derivados de T2), todos dentro de `40_salidas/` y `50_documentacion/`. Si el pipeline es determinista y el build de `4a22cbc` es de hoy, el motor y el parquet pueden salir byte a byte iguales y no aparecer.
obtenido: `rc=0`; `0`; motor `1069b9c94b79510f3c26ce77b5cac2f6` (= `4a22cbc`, no aparece en el porcelain: mismo día, mismo dato, build determinista); `idps_largo.parquet` `f34f9c882a9646ac54789f55a5778923` (≠ la copia de FASE 0, `4c764d8c…`, con el mismo tamaño). Porcelain: ` M` en **7 derivados de `40_salidas/intermedios/`**: `catalogo_idps.parquet`, `censo_insumos.md`, `censo_insumos.parquet`, `comunas_chile.parquet`, `establecimientos_chile.parquet`, `idps_largo.parquet`, `sleps_chile.parquet`; más los dos `??` conocidos. Nada en `50_documentacion/` ni fuera de `40_salidas/`. **ALCANCE de derivados de T2 = esos 7 archivos.**
Lectura propia de por qué cambian sin tocar insumos (`git diff --stat`, `git log -1` por archivo y `/tmp/s32b_m9_contenido.R`, que compara el contenido de HEAD contra el árbol con `identical()`):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && git diff --stat && Rscript /tmp/s32b_m9_contenido.R && Rscript /tmp/s32b_m9_comunas.R'
```
esperado: (propio) los parquets con contenido idéntico y bytes distintos (escritura no determinista); el resto se lee.
obtenido: contenido **idéntico** (`identical=TRUE`) en `catalogo_idps` (30×19), `establecimientos_chile` (10.945×5), `idps_largo` (2.362.447×30) y `sleps_chile` (2.337×7): cambian solo los bytes. Contenido **distinto** en dos derivados que estaban **desfasados en git desde junio** (último commit `771a820` 2026-06-11 y `cb3fb7a` 2026-06-19): `censo_insumos` (25 → 28 archivos perfilados; el `.md` agrega la fila 4b 2024 y el archivo `idps4b2024_rbd_niveles_final`, y su fecha) y `comunas_chile` (153 de 345 filas cambian solo `nom_reg_rbd`, con tildes: `Tarapaca` → `Tarapacá`). **Observación O-1:** esos derivados versionados no se habían re-commiteado tras cambios del pipeline de junio; el commit de T2 los arrastra (son parte de M9 por mandato del encargo) y se declara en el log.

**M10** (reproducción de T1; `/tmp/s32b_m10.js`: Chrome del sistema **con ventana** (`headless:false`, viewport 1440×900, `bringToFront`), clic de ratón en `.terr-trigger` y 10 Tab desde el buscador, registrando tras cada Tab `document.activeElement` (tag, clase, `role`, texto a 40 caracteres) y `document.hasFocus()`; si llega a una fila, se mide el contorno computado y se prueba Enter; la misma secuencia en headless; sobre el motor del árbol, `4a22cbc`):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32b_m10.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html > /tmp/s32b_m10.json'
```
esperado: la secuencia con ventana muestra dónde se corta (el foco no llega a una `.check-row`, o llega y Enter no elige). Si con ventana también pasa, se repite con la pestaña inicial, con escritura previa en el buscador y con/sin selector de dependencia; si nada falla, T1 se congela como duda con pregunta cerrada al titular.
obtenido (`/tmp/s32b_m10.json`, `rc=0`, 0 errores de consola en las dos corridas): **con ventana y en headless, la misma traza**: 0 `INPUT input-search` (foco inicial, `hasFocus: true`) → 1 `SELECT` (dependencia) → **2 `DIV check-row`, `role="button"`, "Algarrobo…"**, `:focus-visible` verdadero, contorno `solid 2px rgb(0, 98, 160)` → 3–10 las filas siguientes. Enter sobre la fila: `modal_abierto: false`, disparador `SLEP Costa Central ▾` → `comuna de Algarrobo ▾`. **Con ventana no se reproduce el defecto.**
Repetición con las variantes de la columna "Si difiere":
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32b_m10.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html escrito,region,slep > /tmp/s32b_m10_variantes.json'
```
esperado: (propio) si el defecto depende de la pestaña, de la escritura previa o del selector de dependencia, alguna variante con ventana no llega a la fila o Enter no elige.
obtenido: `rc=0`, 0 errores. Con ventana y headless, idénticas: **escrito** ("val" en el buscador): buscador → selector → fila en 2 Tab (`Ovalle`), Enter → `comuna de Ovalle ▾`; **Región** (selector visible, pestaña elegida con clic y vuelta al buscador con clic): fila en 2 Tab (`Tarapacá`), Enter → `Región de Tarapacá ▾`; **SLEP** (sin selector): fila en **1** Tab (`SLEP Aconcagua`), Enter → `SLEP Aconcagua ▾`. En todas, contorno `solid 2px rgb(0, 98, 160)`. **Nada falla.** Por la columna "Si difiere" de M10, **T1 se congela como duda D-1** (ver FASE T1).

- **Estado de FASE 0:** completada, con un gate del titular (H-1, calibración de M3). M1, M2, M4–M9 coinciden con su esperado; M3 cumple por el gate; M10 no reproduce el defecto → T1 congelada.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain `?? 20_insumos/definitivos_2025/` + este LOG; stash vacío; `HEAD` `d0d4414` (hijo de `f0c24e9`); `origin/main` `f0c24e9`.
- **Estado del árbol al cerrar FASE 0:** los 7 derivados de M9 ` M` (contenido de los datos igual; dos derivados desfasados desde junio, O-1) y los dos `??`.
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno en FASE 0.

### FASE T1: el modal de territorio se opera con teclado

- **Estado:** **congelada** (columna "Si difiere" de M10: el defecto no se reproduce con ventana ni en headless, en ninguna variante). No se tocó la plantilla; no hay commit de T1.
- **Paso 0 (lectura del código, con la traza de M10):** las filas de `EntityModal` tienen `tabIndex={dis?-1:0}`, `role`, `onKeyDown` (Enter/Espacio → `elegir`) y `.check-row:focus-visible` en la plantilla y en el motor de `4a22cbc`. El modal de territorio abre en la pestaña Comuna con el buscador enfocado (`autoFocus`) y el selector de dependencia visible; ningún `keydown` de `window` intercepta Tab, Enter ni Espacio (el único listener de `window` del modal filtra `Escape`); la fila no se desmonta al recibir foco. En Chrome del sistema (el mismo binario que usa el titular, en esta misma estación), con ventana y en headless, el foco llega a la fila en 1–2 Tab y Enter elige y cierra. **No hay causa raíz localizable en el código con lo medido**: sin un caso malo reproducible, T1.5 ("el mismo script sobre `4a22cbc` falla") no se puede calibrar y cualquier cambio quedaría sin verificación.
- **Diferencias entre la prueba y el gate que esta sesión no puede medir** (hipótesis, no afirmaciones): (a) la pestaña del titular podía mostrar un build anterior sin recargar: en el árbol de `40_salidas/motor_idps.html` hubo, durante s32, un build de T1 solo (`606bf242…`, sin teclado) y el de `4a22cbc` llegó después; (b) se abrió otro archivo (el publicado, `docs/index.html`, es el build de s31c, sin teclado); (c) una extensión del perfil del titular intercepta teclas (la prueba usa un perfil limpio); (d) la entrada del teclado físico por el sistema frente a la inyección por CDP.
- **Duda D-1 (formato 4.1):** contexto: M10 no reproduce el defecto en el motor de `4a22cbc` (traza arriba). Pregunta cerrada al titular: **"¿en qué paso se cortó: el Tab no llegaba a la fila, o llegaba y Enter no elegía?"**; y, para separar las hipótesis (a)–(b): **"¿la pestaña se recargó (Cmd+R) después del build `4a22cbc`, y la dirección era `file:///…/40_salidas/motor_idps.html`? (sí/no)"**. Qué quedó bloqueado: T1 (sin commit) y su verificación; T3 se ejecuta igual si T2 se completa (T3 requiere T1 **o** T2).
- **Subagentes:** sin subagentes.

### FASE T2: datos definitivos 2025

- **Paso 0:** M5, M6 y M7 no congelaron T2 (esquema 9/9 idéntico; glosas con id↔label idéntico). Hecho nuevo, medido antes del intercambio (`git ls-files '20_insumos/*2025*'`, `git config core.ignorecase`, `ls -1`): **el índice de git guarda seis preliminares con el grado en mayúscula** (`20_insumos/idps2M2025_rbd_dim_preliminar.xlsx`, `idps2M2025_rbd_preliminar.xlsx`, `idps4B2025_rbd_dim_preliminar.xlsx`, `idps4B2025_rbd_preliminar.xlsx`, `idps8B2025_rbd_dim_preliminar.xlsx`, `idps8B2025_rbd_preliminar.xlsx`; los seis desde `13c1909`), mientras el disco los tiene en minúscula y `core.ignorecase=true`. El `git rm --cached` autorizado se hace sobre las rutas **tal como las guarda el índice** (si no, no las encontraría); se registra como observación O-2. El pipeline lee el disco (minúscula), así que su conducta no depende de esto.
- **Intercambio, paso 1 (solo impresión):**
```
bash /tmp/s32b_t2_lista.sh && cat /tmp/s32b_t2_comandos.txt
```
esperado: 1 `mkdir -p`; 24 `mv -n` (9 preliminares de datos y 3 glosas preliminares a `_archivo/20260923/20_insumos/…`; 9 finales de datos a `20_insumos/` y 3 glosas finales a `20_insumos/auxiliares/`); 12 `git rm --cached --quiet`; 1 `rmdir`.
obtenido: `mv: 24 ; git rm --cached: 12 ; mkdir: 1 ; rmdir: 1`; la lista impresa completa quedó en `/tmp/s32b_t2_comandos.txt` (38 órdenes): `mkdir -p …/_archivo/20260923/20_insumos/auxiliares`; 9 `mv -n …/20_insumos/idps{2m,4b,8b}2025_{rbd_dim,rbd,rbd_subdim_niveles}_preliminar.xlsx → …/_archivo/20260923/20_insumos/`; 3 `mv -n …/auxiliares/idps{2m,4b,8b}2025_GLOSAS_web_preliminar.xlsx → …/_archivo/20260923/20_insumos/auxiliares/`; 12 `git rm --cached --quiet` con las rutas del índice (las 3 glosas; `idps2M2025_rbd_dim_…`, `idps2M2025_rbd_…`, `idps2m2025_rbd_subdim_niveles_…`, y lo mismo con `4B`/`4b` y `8B`/`8b`); 9 `mv -n …/definitivos_2025/idps{2m,4b,8b}2025_…_final.xlsx → …/20_insumos/`; 3 `mv -n …/definitivos_2025/idps{2m,4b,8b}2025_GLOSAS_web_final.xlsx → …/20_insumos/auxiliares/`; `rmdir …/20_insumos/definitivos_2025`. Coincide con las Autorizaciones; es lo que se ejecuta.
- **Intercambio, paso 2 (ejecución de esa misma lista, deteniéndose ante el primer error):**
```
bash -e /tmp/s32b_t2_comandos.txt; echo rc=$?
```
esperado: `rc=0`; después, `definitivos_2025/` no existe y el índice muestra 12 borrados.
obtenido: `rc=0`; `ls: …/20_insumos/definitivos_2025: No such file or directory` (se vació y se borró con `rmdir`; no tenía archivos ocultos); porcelain: 12 `D ` (las rutas del índice, seis con mayúscula), 12 `??` finales (9 en `20_insumos/`, 3 en `auxiliares/`), los 7 derivados ` M` de M9 y este LOG.
- **Build completo (PRUEBAS a):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32b_run_t2.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32b_run_t2.log; grep -E "RESUMEN|Paso 3[1-5] OK|preliminar|final" /tmp/s32b_run_t2.log | head -30; md5 -q $R/40_salidas/motor_idps.html; cp $R/40_salidas/motor_idps.html /tmp/s32b_motor_t2.html'
```
esperado: `rc=0`; 0 líneas con "warn"; los cinco pasos OK; el motor cambia (cambió el dato de 2025).
obtenido: `rc=0`; `0`; pasos 31, 32, 33, 34 y 35 OK (`RESUMEN — ejecutados: 31, 32, 33, 34, 35`, 37,5 s); el paso 32 perfila los nueve 2025 como `final` (p. ej. `idps4b2025_rbd_final … 26868`, `idps2m2025_rbd_subdim… 65978`); motor **`8428ea585f70b9fae0efa4f9cc9907ad`** (copia en `/tmp/s32b_motor_t2.html`).
- **Verificación:**

T2.1, T2.2, T2.3 y T2.5 (🔒1) (`/tmp/s32b_t2_r.R`: conteo del largo nuevo y comparación de `agno != 2025` ordenado por todas las columnas con `identical()`; `/tmp/s32b_t23.js`: `meta.anios_preliminar` del payload; el motor viejo se extrae con `git show 4a22cbc:40_salidas/motor_idps.html > /tmp/s32b_motor_viejo.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; ls $R/20_insumos/*2025*_preliminar.xlsx $R/20_insumos/auxiliares/*2025*_preliminar.xlsx 2>/dev/null | wc -l; ls $R/20_insumos/*2025*_final.xlsx | wc -l; ls $R/20_insumos/auxiliares/*2025_GLOSAS_web_final.xlsx | wc -l; ls -d $R/20_insumos/definitivos_2025 2>&1 | grep -c "No such"; cd $R && Rscript /tmp/s32b_t2_r.R; node /tmp/s32b_t23.js /tmp/s32b_motor_viejo.html /tmp/s32b_motor_t2.html'
```
esperado: T2.1 `0`, `9`, `3`, `1` (la carpeta no existe); T2.2 todo 2025 con `preliminar = FALSE` en 4b, 2m y 8b (0 filas 2025 con `TRUE`), mismas filas por grado que en M8 si los definitivos no agregan filas (2m puede sumar por las 22 filas extra de niveles); T2.3 viejo `anios_preliminar: [2025]` → nuevo `[]`; T2.5 🔒1 `nrow` igual e `identical TRUE`.
obtenido: T2.1 `0`, `9`, `3`, `1`. T2.2: 2025 con `preliminar = FALSE` en los tres grados (`2025 con preliminar=TRUE: 0 filas; grados 2025: 2m,4b,8b`); filas 2025: 2m `110963` (M8 `110941`: +22, las filas extra de `rbd_subdim_niveles`), 4b `259001` (=), 8b `221877` (=); 6b 2024 sigue `TRUE` (fuera del alcance). T2.3: viejo `anios_preliminar: [2025]` → nuevo `[]` (grados del payload `4b,2m`). **T2.5 / 🔒1:** `nrow antes 1770628, nuevo 1770628; columnas iguales TRUE; identical TRUE`.

T2.4 (el caso que lo motivó; `/tmp/s32b_t24.js`: texto visible del panorama actual, de su vista histórica, de la ficha de la primera tarjeta del SLEP foco en 4b 2025 y de la vista histórica de esa ficha; cuenta `(preliminar)` y `2025*`) sobre el motor nuevo y, como caso malo, sobre el de `4a22cbc`:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32b_t24.js /tmp/s32b_motor_t2.html > /tmp/s32b_t24_nuevo.json; node /tmp/s32b_t24.js /tmp/s32b_motor_viejo.html > /tmp/s32b_t24_viejo.json'
```
esperado: motor nuevo: 0 `(preliminar)` y 0 `2025*` en las cuatro vistas; el banner del panorama termina en `· 2025` sin marca; 0 errores. Motor viejo: el panorama actual y la ficha dicen `(preliminar)`, y las dos vistas históricas muestran `2025*`.
obtenido (`/tmp/s32b_t24_nuevo.json`, `/tmp/s32b_t24_viejo.json`; 0 errores en los dos): **motor nuevo**: panorama actual `… · 5 de 5 GSE · 2025`, `(preliminar)` 0, `2025*` 0; panorama histórico `… · 2014–2025`, 0 y 0; ficha actual (primera tarjeta del foco, 4b) `ficha-meta` termina en `· 4° básico · 2025`, 0 y 0; ficha histórica 0 y 0. **Motor viejo (`4a22cbc`)**: panorama actual `… · 2025 (preliminar)` (1); panorama histórico `… · 2014–2025*` y **11** `2025*`; ficha actual `… · 2025 (preliminar)` (1); ficha histórica **15** `2025*`. El caso malo tiene las tres marcas; el nuevo, ninguna.

T2.6 (cuánto cambió 2025; `/tmp/s32b_t26.R`, por grado: RBD que entran, salen y comunes; en las filas de RBD comunes emparejadas por la clave `rbd, agno, grado, familia, id_indicador, id_dimension, id_subdimension`: celdas de `prom` distintas y máximo |Δ|, tabla de transición de `sigdifgru`; y cambios de `cod_grupo` por RBD) y T2.7 (control positivo: la misma función contra una copia del largo nuevo con **un** `prom` de 2025/4b alterado en +1, `/tmp/s32b_t27_plantar.R`):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32b_t26.R /tmp/s32b_largo_antes.parquet /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet 2025 4b,2m,8b && Rscript /tmp/s32b_t27_plantar.R && Rscript /tmp/s32b_t26.R /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet /tmp/s32b_largo_plantado.parquet 2025 4b'
```
esperado: clave única antes y después en los tres grados; 4b y 2m: se registran las cifras (sin esperado numérico del encargo); **8b: 0 RBD que entran o salen, 0 celdas de `prom` distintas, 0 cambios de `sigdifgru`, 0 de GSE** (archivos byte-idénticos); T2.7: exactamente **1** celda de `prom` distinta, |Δ| = 1, 0 cambios de `sigdifgru` y de GSE.
obtenido: **T2.6**:

| grado 2025 | filas antes → después | RBD antes / después | entran / salen / comunes | `prom` distintas (dato↔NA) | máx \|Δ\| `prom` | `sigdifgru` que cambian | GSE que cambian |
|---|---|---|---|---|---|---|---|
| 4b | 259.001 → 259.001 | 7.057 / 7.057 | 0 / 0 / 7.057 | 10 (0) | 2 | 0 de 259.001 | 0 de 7.057 |
| 2m | 110.941 → 110.963 | 2.999 / 2.999 | 0 / 0 / 2.999 | 25 (15) | 4 | 4 de 110.941 (NA→−1: 2; NA→0: 2) | 0 de 2.999 |
| 8b | 221.877 → 221.877 | 6.007 / 6.007 | 0 / 0 / 6.007 | 0 (0) | 0 | 0 de 221.877 | 0 de 6.007 |

Clave única antes y después en los tres grados. En 2m, las 22 filas nuevas son de RBD comunes (`solo despues 22`; ningún RBD entra), las filas extra de `rbd_subdim_niveles` que midió M6. Transiciones de `sigdifgru` en 4b: diagonal completa (−1: 5.001; 0: 12.315; 1: 5.517; NA: 236.168); en 2m: diagonal (2.037 / 7.574 / 2.318 / 99.008) más 2 NA→−1 y 2 NA→0; en 8b: diagonal (4.119 / 12.197 / 6.021 / 199.540). **8b: 0 cambios, como se esperaba.** Los definitivos pesan 18–21 % más en bytes, pero el dato que el pipeline lee casi no se mueve. **T2.7:** `plantado: 1 celda prom (+1)`; la función reporta `prom: celdas distintas 1 … max |delta| 1`, 0 `sigdifgru` y 0 GSE → **el instrumento dispara exactamente con 1**.
- **Regresión (PRUEBAS a, b, c) y 🔒6 anticipado** (`/tmp/s32b_l6.sh` compara el md5 de cada preliminar archivado con el prefijo medido en M5):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32_verif.js /tmp/s32b_motor_t2.html consola > /tmp/s32b_t2_consola.json; grep -A1 -E "consola_errores|pageerror|modal_" /tmp/s32b_t2_consola.json | tr -d "\n "; echo; bash /tmp/s32b_payload_sha.sh /tmp/s32b_motor_t2.html /tmp/s32b_motor_fase0.html | cut -c1-260; bash /tmp/s32b_l6.sh'
```
esperado: los dos modales abren con 0 errores y 0 `pageerror`; el hash §8.2 **cambia** respecto de `900913c1…` (T2 cambia el dato; la regla 3 solo aplica tras T1); `🔒6: 12 de 12`.
obtenido: `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; hash §8.2 del motor de T2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`** (JSON 59.467.463 bytes, +454; primer offset distinto 290, en `meta`); `🔒6: 12 de 12 preliminares en _archivo con el md5 de M5`.
- **Chequeo de alcance:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; git -C $R diff --cached --name-status'
```
esperado: dentro del ALCANCE de T2: 12 `D ` (índice), 12 `??` finales, 7 derivados ` M` de M9; fuera de T2 y sin agregar: ` M 40_salidas/motor_idps.html` (ALCANCE de T3) y este LOG.
obtenido: exactamente eso: 12 `D ` en el índice, 12 `??` finales y 7 ` M` derivados (ALCANCE de T2); fuera de T2 y no agregados: ` M 40_salidas/motor_idps.html` y este LOG.
- **Commit** (`/tmp/s32b_t2_commit.sh`: `git add` con las 12 altas y los 7 derivados por ruta explícita; los 12 borrados ya estaban en el índice):
```
bash /tmp/s32b_t2_commit.sh
```
esperado: un commit con las 24 rutas de insumos y los 7 derivados; nada más; quedan fuera el motor y el LOG.
obtenido: `364c53a data(insumos): IDPS 2025 definitivos reemplazan a los preliminares (s32b T2)`. `git show --name-status` (con detección de renombres): 6 `A`, 6 `D`, 6 `R` (los 3 datos de 8b, `R100`, idénticos byte a byte; las 3 glosas, `R055`/`R061`/`R062`) y 7 `M` → 31 rutas: las 12 viejas, las 12 nuevas y los 7 derivados. Porcelain después: ` M 40_salidas/motor_idps.html` y el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.
- **Observaciones:** O-1 (derivados desfasados desde junio, arrastrados por el commit) y O-2 (índice con seis nombres en mayúscula; el commit los retira con esas rutas).

### FASE T3: build final

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status --porcelain --untracked-files=no'
```
esperado: rastreados: solo ` M 40_salidas/motor_idps.html`; no versionados: este LOG (existe desde FASE 0 y el esperado literal del encargo no lo cuenta).
obtenido: rastreados ` M 40_salidas/motor_idps.html` (el build de T2, `8428ea58…`, sin commitear); no versionados: este LOG. Coincide.
- **Hecho medido antes del build:** `32_censo_insumos.R` L197 escribe `- Fecha: format(Sys.time(), "%Y-%m-%d %H:%M:%S")` en `40_salidas/intermedios/censo_insumos.md`, así que **todo `run_all()` completo reescribe ese derivado versionado** (y quizá su `.parquet`) aunque nada cambie. Un build completo en el árbol dejaría, después del commit de T2, rutas modificadas fuera del ALCANCE de T3 (que solo es el motor), que no se pueden commitear en T3 ni limpiar (`restore`/`checkout --` prohibidos), y además romperían la condición del push. Se mide primero en una copia del árbol en `/tmp` (clon APFS `cp -Rc`, autorizado como temporal):
```
bash -c 'rm -rf /tmp/s32b_repo 2>/dev/null; cp -Rc /Users/tomgc/Projects/slep_idps /tmp/s32b_repo && cd /tmp/s32b_repo && Rscript -e "setwd(\"/tmp/s32b_repo\"); source(\"00_build.R\"); run_all()" > /tmp/s32b_run_copia.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32b_run_copia.log; git -C /tmp/s32b_repo status --porcelain; md5 -q /tmp/s32b_repo/40_salidas/motor_idps.html; git -C /tmp/s32b_repo diff --stat -- 40_salidas/intermedios'
```
esperado: (propio) `rc=0`, 0 warnings; en la copia, además del motor y el LOG, **solo** `censo_insumos.md` (la fecha) y quizá `censo_insumos.parquet`; el motor de la copia con el md5 del de T2 (`8428ea58…`), porque el dato y la fecha del payload son los mismos.
Corrección al comando anterior, antes de correrlo: se quita el `rm -rf /tmp/s32b_repo` (la carpeta no existe, lo mide `ls -d`, y el encargo no autoriza `rm`); el comando que se corre es el mismo desde `cp -Rc`.
obtenido: `ls: /tmp/s32b_repo: No such file or directory` (antes); `rc=0`; `0` warnings; porcelain de la copia: ` M 40_salidas/intermedios/censo_insumos.md` (`1 insertion(+), 1 deletion(-)`: la línea de la fecha), ` M 40_salidas/motor_idps.html` (el de T2, sin commitear en el origen de la copia) y el LOG; motor de la copia **`8428ea585f70b9fae0efa4f9cc9907ad`** (= T2). Los seis parquets salen byte a byte iguales a los commiteados en `364c53a`: la única escritura no determinista del pipeline es la fecha del censo.
- **Decisión autónoma D-A1:** el build de T3 **en el árbol** se hace con `run_all(only = 35L)` (solo el motor, el ALCANCE de T3); el pipeline completo (PRUEBAS a) queda probado sobre el estado de `364c53a` en la copia (`rc=0`, 0 warnings, mismo motor). Un `run_all()` completo en el árbol dejaría `censo_insumos.md` modificado solo por su fecha, fuera del ALCANCE de T3, sin poder commitearse ni limpiarse, y bloquearía el push. Reversible; la regresión de FASE R usa la misma receta.
- **Paso 2 (build, PRUEBAS b, T1.1–T1.2 y T2.4 sobre el motor commiteable):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32b_run_t3.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32b_run_t3.log; md5 -q $R/40_salidas/motor_idps.html; git -C $R status --porcelain; bash /tmp/s32b_payload_sha.sh $R/40_salidas/motor_idps.html | cut -c1-200; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_verif.js $R/40_salidas/motor_idps.html consola > /tmp/s32b_t3_consola.json; node /tmp/s32b_m10.js $R/40_salidas/motor_idps.html base > /tmp/s32b_t3_m10.json; node /tmp/s32b_t24.js $R/40_salidas/motor_idps.html > /tmp/s32b_t3_t24.json'
```
esperado: `rc=0`; `0`; md5 `8428ea585f70b9fae0efa4f9cc9907ad` (= T2 y = la copia); porcelain: solo el motor y el LOG; hash §8.2 `eb4e00b3…4dc4`; PRUEBAS b: los dos modales abren con 0 errores; T1.1–T1.2 (traza de M10, con ventana y headless): fila en 2 Tab, contorno `solid 2px rgb(0, 98, 160)`, Enter cierra y cambia el territorio; T2.4: 0 `(preliminar)` y 0 `2025*` en las cuatro vistas.
obtenido: `rc=0`; `0`; `8428ea585f70b9fae0efa4f9cc9907ad`; porcelain ` M 40_salidas/motor_idps.html` + LOG; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (59.467.463 bytes). PRUEBAS b: `modal_territorio: true`, `modal_comparador: true`, 0 errores, 0 `pageerror`. T1.1–T1.2 (`/tmp/s32b_t3_m10.json`): con ventana y headless, fila en **2** Tab, contorno `solid 2px rgb(0, 98, 160)`, Enter → modal cerrado y `comuna de Algarrobo ▾`, 0 errores. T2.4 (`/tmp/s32b_t3_t24.json`): `(preliminar)`/`2025*` = 0/0 en panorama actual, panorama histórico, ficha actual y ficha histórica; 0 errores.
- **Paso 3 (testigo del despliegue):** T1 no cambió la plantilla, así que no hay cadena nueva de interfaz; el HTML nuevo solo difiere del de `4a22cbc` en el payload comprimido.
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; node /tmp/s32b_t23.js $R/40_salidas/motor_idps.html $R/docs/index.html /tmp/s32b_motor_viejo.html; for f in $R/40_salidas/motor_idps.html $R/docs/index.html /tmp/s32b_motor_viejo.html; do echo "$(basename $f): 2025* en el HTML estático $(grep -c "2025\*" $f)"; done'
```
esperado: `anios_preliminar` `[]` en el motor nuevo y `[2025]` en `docs/index.html` y en el de `4a22cbc`; ninguna cadena legible distintiva en el HTML estático.
obtenido: nuevo `anios_preliminar: []`; `docs/index.html` `[2025]` (fecha 2026-09-17); `4a22cbc` `[2025]`; `2025*` en el HTML estático: 0 en los tres (la marca solo existe al dibujar). **Testigo del próximo despliegue, declarado:** (1) **negativo, en pantalla**: ausencia de "2025*" en la vista histórica y de "(preliminar)" en el banner del panorama y en la ficha (el motor de `4a22cbc` y `docs/index.html` muestran las tres marcas); (2) **estático, verificable sin navegador**: `"anios_preliminar":[]` en el JSON descomprimido del payload (`node /tmp/s32b_t23.js <html>`; hoy `docs/index.html` da `[2025]`). No hay cadena de interfaz nueva porque T1 quedó congelada.
- **Chequeo de alcance:** porcelain del paso 2 = ` M 40_salidas/motor_idps.html` (ALCANCE de T3) + el LOG. Solo se agrega el motor.
- **Commit:** el mensaje del encargo es `build(motor): s32b teclado y definitivos 2025`; con T1 congelada, el motor no trae cambio de teclado, así que se le agrega una aclaración entre paréntesis para no inducir a error (desviación D-DESV-1, registrada).
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s32b teclado y definitivos 2025 (T1 congelada: sin cambio de teclado)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: un commit con solo el motor (`8428ea58…`); porcelain después: solo el LOG.
obtenido: `e7848df build(motor): s32b teclado y definitivos 2025 (T1 congelada: sin cambio de teclado)`; `git show --name-only HEAD` = `40_salidas/motor_idps.html`; `git show HEAD:…| md5 -q` = `8428ea585f70b9fae0efa4f9cc9907ad`; porcelain: solo el LOG.
- **Estado:** completada (requería T1 **o** T2: T2 completada).
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1. **Error propio:** el primer texto del comando de la copia llevaba un `rm -rf` preventivo que el encargo no autoriza; se quitó antes de correrlo (línea de corrección arriba).

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `d0d4414`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `d0d4414` (hijo de `f0c24e9` = `origin/main`); commits de la sesión `d0d4414`, `364c53a`, `e7848df` (M2, cierres de fase) |
| R-02 | Hash §8.2: FASE 0 `900913c1…` = `docs/index.html`; T2 y final `eb4e00b3…`; el instrumento es ciego a la fecha y ve una cifra plantada (M3, gate H-1, T2, T3) |
| R-03 | M5: 12 finales y 12 preliminares; los 3 pares de datos de 8b byte-idénticos; los otros 9 pares distintos |
| R-04 | M6: esquema idéntico en los 9 pares de datos (hoja, nombres, clases) |
| R-05 | M7: glosas iguales salvo el nombre de archivo que describen y un conteo de filas (2m niveles) |
| R-06 | M8: 2025 `preliminar = TRUE` en 4b, 2m y 8b antes de T2 |
| R-07 | M9: el pipeline reescribe 7 derivados; 4 con contenido idéntico, 2 desfasados desde junio (O-1) |
| R-08 | M10: con ventana y headless, el modal de territorio de `4a22cbc` se opera con teclado; T1 congelada (D-1) |
| R-09 | T2.1: 0 preliminares 2025 en `20_insumos/`; 9 + 3 finales; `definitivos_2025/` no existe |
| R-10 | T2.2: 0 filas 2025 con `preliminar = TRUE`, en los tres grados |
| R-11 | T2.3: `anios_preliminar` `[2025]` → `[]` |
| R-12 | T2.4: 0 marcas "(preliminar)"/"2025*" en el motor nuevo; el viejo las muestra (caso malo) |
| R-13 | T2.5 / 🔒1: filas `agno != 2025` idénticas (1.770.628) |
| R-14 | T2.6: tabla de cambios de 2025 (4b: 10 `prom`, máx 2; 2m: 25 `prom` (15 dato↔NA), máx 4, 4 `sigdifgru`, +22 filas; 8b: 0) |
| R-15 | T2.7: el instrumento de T2.6 reporta exactamente 1 celda con 1 celda plantada |
| R-16 | Commit de T2: 12 bajas, 12 altas, 7 derivados y nada más (O-2: bajas con las rutas en mayúscula del índice) |
| R-17 | T3/D-A1: un `run_all()` completo sobre `364c53a` solo reescribe la fecha de `censo_insumos.md`; motor `8428ea58…` |
| R-18 | T3: motor commiteado `8428ea58…`, reproducible |
| R-19 | T3: testigo `"anios_preliminar":[]` (docs y `4a22cbc`: `[2025]`) + ausencia de "2025*"/"(preliminar)" en pantalla |
| R-20 | T1.1–T1.2 sobre el motor final: fila en 2 Tab, contorno 2 px `--foco`, Enter elige |
| 🔒1–🔒6 | invariantes de §3 |
| ALC | alcance global ⊆ unión de ALCANCE + LOG + encargo |
| REG | PRUEBAS a (completo, en copia, y paso 35 en el árbol), b y c sobre el estado final |

**Paso 2. Re-derivación independiente.**

Bloque estático (`/tmp/s32b_r_static.sh`: md5 desde los objetos de git en vez de los archivos del árbol; `diff --no-renames`; `ls-tree`; y, para las glosas, el `xl/sharedStrings.xml` de cada `.xlsx` con `unzip -p` en vez de `readxl`):
```
bash /tmp/s32b_r_static.sh
```
esperado: R01 `f0c24e9` ancestro, padre de `d0d4414` = `f0c24e9`, sesión `e7848df 364c53a d0d4414`; R03 8b `IGUAL` ×3, 4b y 2m `DISTINTO` ×6; R16 `12 A`, `12 D`, `7 M`; R16b `6`; R16c `0`; R07 los 7 derivados; R05 en cada glosa, solo cambian las cadenas con el nombre del archivo (`…_preliminar` → `…_final`; el conteo 65956 → 65978 de 2m es numérico y no vive en `sharedStrings`).
obtenido: `R01: f0c24e9-ancestro padre_d0d4414=f0c24e9 sesion=e7848df 364c53a d0d4414`; R03 2m ×3 y 4b ×3 `DISTINTO`, 8b ×3 `IGUAL`; `R16: 12 A 12 D 7 M`; `R16b: 6`; `R16c: 0`; R07 los 7 derivados; R05: 160 cadenas en cada glosa, 6 líneas de diferencia (3 salen, 3 entran), y las que entran son solo `idps{g}2025_rbd_final`, `…_rbd_dim_final`, `…_rbd_subdim_niveles_final`. Todo coincide.

Bloque de datos en R (`/tmp/s32b_r_datos.R`: el payload decodificado y normalizado en R, con el hash por `shasum`, cuando T2/T3 lo hicieron en node; esquema con `n_max = 0` y `guess_max = Inf` en vez de `guess_max = 200000`; `table()` en vez de `count()`; `anti_join` en los dos sentidos en vez de `identical()`; `merge()` de base en vez de `inner_join`):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32b_r_datos.R && shasum -a 256 /tmp/s32b_r_norm_final.json /tmp/s32b_r_norm_fase0.json /tmp/s32b_r_norm_docs.json'
```
esperado: R-11 final `"anios_preliminar":[]`, fase0 y docs `[2025]`; R-02 SHA final `eb4e00b3…4dc4`, fase0 y docs `900913c1…78b4`; R-04 `9 de 9`; R-06/R-10 2025 antes toda `TRUE`, nuevo toda `FALSE`, con los conteos de M8/T2.2; R-13 `solo antes 0; solo nuevo 0`; R-14 las mismas cifras de la tabla de T2.6 (4b 10, máx 2, 0, 0; 2m 25, máx 4, 4, 0; 8b 0, 0, 0, 0) y la transición de 2m (NA→−1 ×2, NA→0 ×2).
obtenido: R-11/R-02: `final: 59467463 bytes; "anios_preliminar":[]`, `fase0: 59467009 bytes; "anios_preliminar":[2025]`, `docs: 59467009 bytes; "anios_preliminar":[2025]`; `shasum`: final `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`, fase0 y docs `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`. R-04 `9 de 9` (con 18 avisos de `readxl` por `guess_max = Inf` en mi instrumento; no son del pipeline). R-06/R-10 2025 antes `TRUE` (2m 110.941, 4b 259.001, 8b 221.877) y nuevo `FALSE` (2m 110.963, 4b 259.001, 8b 221.877). R-13 `nrow 1770628 vs 1770628; solo antes 0; solo nuevo 0`. R-14 4b `prom distintas 10, max|d| 2; sigdifgru 0; GSE 0`; 2m `25, 4; 4; 0` con transición `NA→−1: 2`, `NA→0: 2`; 8b `0, 0; 0; 0`; RBD sin entradas ni salidas en los tres. Todo coincide.

Navegador, otra vía (`/tmp/s32_r_verif.js` de s32 con otras entidades, otro tab y otra tecla; `/tmp/s32b_r_nav.js` para R-12: el conjunto `PRELIM` del script y la ficha de la **segunda** tarjeta del foco, cuando T2.4 usó el texto de la primera):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; node /tmp/s32_r_verif.js $M r_region_space,r_focus_style,r_escape_fila,r_slep_enter,r_tope_tab,r_repeat > /tmp/s32b_r_tecl.json; node /tmp/s32b_r_nav.js $M; node /tmp/s32b_r_nav.js /tmp/s32b_motor_viejo.html'
```
esperado: R-20 (T1 en otra entidad y otro tab): Región, tercera fila, **Espacio** → modal cerrado y `Región de …`; contorno `solid 2px rgb(0, 98, 160)`; Escape con foco en fila cierra. T1.4 (no regresión del comparador): SLEP + Enter → `1 de 10`; con el tope, 6 filas `tabIndex=-1` y Tab salta a `Listo`; la autorrepetición conmuta una vez. R-12: nuevo `PRELIM` vacío (`size 0`, `tiene2025 false`) y la segunda ficha sin `(preliminar)`; viejo `size 1`, `tiene2025 true`, ficha con `2025 (preliminar)`. 0 errores.
obtenido: R-20: Región, 2 Tab a la primera fila, 2 más a la tercera (`Atacama`), **Espacio** → modal cerrado, `Región de Atacama ▾`; `focus_visible: true`, `solid 2px rgb(0, 98, 160)`, offset `-2px`, `--foco` `#0062A0`; Escape con foco en fila → modal cerrado. T1.4: SLEP `0 de 10` → Enter → `aria-checked="true"`, `1 de 10`, 1 chip; tope en Región: 16 filas, 6 deshabilitadas, 6 con `tabIndex=-1`, 6 con `aria-disabled`, 10 habilitadas con `tabIndex=0`, `10 de 10`, Tab desde la décima → `Listo`; dos `keydown` sostenidos → `true`/`1 de 10`, control de dos pulsaciones → `false`/`1 de 10`. R-12: nuevo `PRELIM` `size 0`, `tiene2025 false`, segunda ficha (60 tarjetas) termina en `2025`, sin `(preliminar)`; viejo `size 1`, `["2025"]`, segunda ficha `2025 (preliminar)`. 0 errores y 0 `pageerror` en las tres corridas. Coincide.

**Paso 3. Invariantes 🔒** (`/tmp/s32b_invariantes.sh`, con los comandos de §3; `<inicio>` = `d0d4414`):
```
bash /tmp/s32b_invariantes.sh
```
esperado: L1 `nrow` igual e `identical TRUE`; L2 `0`; L3a `63` líneas y md5 `9842151d…` (= M4); L3b `0`; L4 `0`; L5 `0`; L6 `12 de 12`.
obtenido: `L1: nrow antes 1770628, nuevo 1770628; columnas iguales TRUE; identical TRUE` → **🔒1 PASA**; `L2: 0` → **🔒2 PASA**; `L3a: lineas: 63; md5 9842151d897e8768abd2207513c6607b` y `L3b: 0` → **🔒3 PASA**; `L4: 0` → **🔒4 PASA**; `L5: 0` → **🔒5 PASA**; `L6: 🔒6: 12 de 12 preliminares en _archivo con el md5 de M5` → **🔒6 PASA**.

**Paso 4. Alcance global** (`/tmp/s32b_alcance.sh`: lista explícita de rutas permitidas —motor, 7 derivados, LOG, encargo, las 24 rutas de insumos y las 6 variantes en mayúscula que retira el índice— y `grep -vxF` sobre `git diff --no-renames --name-only d0d4414..HEAD`):
```
bash /tmp/s32b_alcance.sh
```
esperado: 32 rutas en el diff (24 de insumos, 7 derivados, el motor); 0 fuera del permitido; porcelain: solo el LOG.
obtenido: `rutas en el diff: 32`; `fuera del permitido: 0`; `porcelain: [?? …s32b_log.md]`. **Alcance global PASA.**

**Paso 6. Control positivo de la propia auditoría** (`/tmp/s32b_controles.sh`, `/tmp/s32b_c_l1.R`; todo fuera del árbol o sobre rangos de historia que sí tocan lo vigilado; R-15 re-derivado con **2** celdas plantadas en 2m, distinto del plantado de T2.7):
```
bash -c 'bash /tmp/s32b_controles.sh; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32b_c_l1.R && Rscript /tmp/s32b_t26.R /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet /tmp/s32b_largo_plantado2.parquet 2025 2m | grep -E "prom:|sigdifgru:|GSE"'
```
esperado: C1 ≥ 1; C2 `2`; C3 md5 distinto de `9842151d…`; C4 `1`; C5 `1`; C6 una `FALLA` y `11 de 12`; C7 imprime `30_procesamiento/34_leer_normalizar_idps.R`; C8 `identical FALSE`; R-15 `prom: celdas distintas 2 … max |delta| 3`, 0 `sigdifgru`, 0 GSE.
obtenido: `C1: 87`; `C2: 2`; `C3: … md5 1d9d9396e4cb03ec7031d1a9ef0dfdcd`; `C4: 1`; `C5: 1`; `C6: FALLA: idps8b2025_rbd_preliminar 🔒6: 11 de 12 …`; `C7: 30_procesamiento/34_leer_normalizar_idps.R`; `C8 (🔒1 plantado en 2018): identical FALSE`; R-15: `prom: celdas distintas 2 (de ellas, dato <-> NA: 0); max |delta| 3`, `sigdifgru … 0`, `GSE … 0 de 2999`. **Todos los instrumentos disparan con su caso plantado.**

**Paso 5. Regresión completa** (PRUEBAS a con la receta de D-A1: pipeline completo en un clon APFS del estado final en `/tmp/s32b_repo_final`, y paso 35 en el árbol; PRUEBAS b y c sobre el motor del árbol):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; ls -d /tmp/s32b_repo_final 2>&1 | grep -c "No such"; cp -Rc $R /tmp/s32b_repo_final && cd /tmp/s32b_repo_final && Rscript -e "setwd(\"/tmp/s32b_repo_final\"); source(\"00_build.R\"); run_all()" > /tmp/s32b_run_faseR_copia.log 2>&1; echo "copia rc=$?"; grep -ciE "warn" /tmp/s32b_run_faseR_copia.log; md5 -q /tmp/s32b_repo_final/40_salidas/motor_idps.html; git -C /tmp/s32b_repo_final status --porcelain; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32b_run_faseR.log 2>&1; echo "arbol rc=$?"; grep -ciE "warn" /tmp/s32b_run_faseR.log; md5 -q $R/40_salidas/motor_idps.html; git -C $R status --porcelain; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32_verif.js $R/40_salidas/motor_idps.html consola > /tmp/s32b_faseR_consola.json; grep -A1 -E "consola_errores|pageerror|modal_" /tmp/s32b_faseR_consola.json | tr -d "\n "; echo; bash /tmp/s32b_payload_sha.sh $R/40_salidas/motor_idps.html | cut -c1-200'
```
esperado: `1` (la copia no existía); copia `rc=0`, 0 warnings, motor `8428ea58…`, porcelain de la copia solo ` M …censo_insumos.md` (la fecha) y el LOG; árbol `rc=0`, 0 warnings, motor `8428ea58…`, porcelain solo el LOG; b) los dos modales, 0 errores, 0 `pageerror`; c) §8.2 `eb4e00b3…4dc4`.
obtenido: `1`; copia `rc=0`, `0`, `8428ea585f70b9fae0efa4f9cc9907ad`, porcelain de la copia ` M 40_salidas/intermedios/censo_insumos.md` + el LOG; árbol `rc=0`, `0`, `8428ea585f70b9fae0efa4f9cc9907ad`, porcelain solo el LOG; b) `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; c) `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`. **Regresión PASA.**

**Pasos 7-8. Veredicto por hallazgo y reparación.** Ningún BLOQUEA (ningún 🔒 en FALLA, alcance respetado, años distintos de 2025 idénticos, historia lineal sobre `f0c24e9`). Ningún REPARA (ningún defecto propio dentro de un ALCANCE). Ciclos usados: 0 de 2.

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `merge-base`, `log --format=%p` | `f0c24e9` padre; 3 commits | iguales | — | ninguna | — | — |
| R-02 | hash §8.2 | payload decodificado en R + `shasum` | final `eb4e00b3…`; fase0 = docs `900913c1…` | iguales | ADVIERTE (A-1: premisa de M3) | gate H-1 | — | control plantado `7ab3ce81…` |
| R-03 | 8b byte-idéntico; 4b/2m distintos | md5 desde objetos de git | 3 IGUAL, 6 DISTINTO | iguales | — | ninguna | — | — |
| R-04 | esquema 9/9 | `n_max = 0` + `guess_max = Inf` | 9 de 9 | 9 de 9 | — | ninguna | — | — |
| R-05 | glosas: solo nombre de archivo y conteo | `unzip -p … sharedStrings.xml` + `diff` | solo nombres de archivo | 3 cadenas por glosa, todas nombres | — | ninguna | — | — |
| R-06/10 | marca preliminar 2025 antes/después | `table()` | TRUE → FALSE | iguales | — | ninguna | — | — |
| R-07 | 7 derivados; 2 desfasados | `git diff --name-only d0d4414..364c53a -- 40_salidas` | 7 | 7 | ADVIERTE (O-1) | declarado | — | — |
| R-08/20 | teclado del modal de territorio en `4a22cbc` y en el final | Región, 3.ª fila, Espacio; contorno; Escape en fila | cierra y cambia; 2 px `--foco` | iguales | ADVIERTE (D-1: el defecto del gate no se reproduce; T1 congelada) | duda al titular | — | M10 con ventana, 4 variantes |
| R-09 | archivos en su lugar | `ls-tree HEAD` | 0 preliminares 2025 | 0 | — | ninguna | — | — |
| R-11 | `anios_preliminar` | JSON decodificado en R | `[]` / `[2025]` | iguales | — | ninguna | — | — |
| R-12 | marcas en pantalla | `PRELIM` del script; segunda ficha | vacío / `["2025"]` | iguales | — | ninguna | — | — |
| R-13 | 🔒1 | `anti_join` en los dos sentidos | 0 y 0 | 0 y 0 | — | ninguna | — | C8 plantado → FALSE |
| R-14 | tabla T2.6 | `merge()` + `table()` de base | 10/2/0/0; 25/4/4/0; 0/0/0/0 | iguales | — | ninguna | — | — |
| R-15 | instrumento T2.6 | 2 celdas plantadas en 2m | 2, máx 3 | 2, máx 3 | — | ninguna | — | — |
| R-16 | commit de T2 | `diff --no-renames`; `ls-tree` | 12 A, 12 D, 7 M; 6 en mayúscula | iguales | ADVIERTE (O-2, informativo) | — | — | — |
| R-17/18 | build reproducible; solo la fecha del censo | pipeline completo en un segundo clon del estado final | `8428ea58…`; solo `censo_insumos.md` | iguales | ADVIERTE (A-3: el censo versionado lleva `Sys.time()`) | D-A1 | — | — |
| R-19 | testigo | JSON en R (R-11) | `[]` vs `[2025]` | iguales | — | ninguna | — | — |
| D-DESV-1 | mensaje del commit de T3 | — | mensaje del encargo | con aclaración "(T1 congelada…)" | ADVIERTE | registrado | `e7848df` | — |
| 🔒1–🔒6 | invariantes | `/tmp/s32b_invariantes.sh` | TRUE / 0 / md5 y 0 / 0 / 0 / 12 | todos PASA | — | — | — | C1–C8 disparan |
| ALC | alcance global | lista explícita + `grep -vxF` | 0 fuera | 0 fuera (32 rutas) | — | — | — | C7 dispara |
| REG | PRUEBAS a, b, c | clon + paso 35 + Puppeteer + §8.2 | `8428ea58…`; 0 errores; `eb4e00b3…` | iguales | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/0/6 (A-1 premisa de M3; A-2 = D-1, T1 congelada porque el defecto no se reproduce; A-3 la fecha de `censo_insumos.md`; O-1 derivados desfasados desde junio; O-2 nombres en mayúscula en el índice; D-DESV-1 mensaje del commit de T3). **La meta de T1 no se cumplió** (congelada por regla del encargo, no por un defecto medido); la de T2 y la de T3, sí.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** ninguno nuevo (los 18 avisos de `readxl` en R-04 son de `guess_max = Inf` en mi instrumento, no del pipeline).

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 3 respecto de `origin/main` (`d0d4414`, `364c53a`, `e7848df`).
obtenido: `?? 50_documentacion/andamios/logs/20260923_teclado_territorio_definitivos_2025_s32b_log.md` (única); `## main...origin/main [ahead 3]`.
- **Pasos 2 y 3:** sección `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre, antes del commit. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s32b (teclado del modal de territorio, reportado como fallido en el gate visual del titular; y datos IDPS 2025 definitivos). Fases: FASE 0 (con el commit del encargo y un gate, H-1), T1 (congelada), T2, T3, R y L. Estado del grafo: T1 **congelada** (D-1: el defecto no se reproduce ni con ventana ni en headless, en cuatro variantes) · T2 completada (`364c53a`) · T3 completada (`e7848df`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
2. **Commits** (`git log d0d4414..HEAD --oneline` más `<inicio>`, antes del commit de este log):
   - `d0d4414` chore(encargo): s32b — FASE 0, primer acto (= `<inicio>`)
   - `364c53a` data(insumos): IDPS 2025 definitivos reemplazan a los preliminares (s32b T2) — 12 bajas, 12 altas y 7 derivados
   - `e7848df` build(motor): s32b teclado y definitivos 2025 (T1 congelada: sin cambio de teclado) — T3, motor `8428ea585f70b9fae0efa4f9cc9907ad`
   - (este log: `docs(log): s32b teclado del modal de territorio y definitivos 2025`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/6; reparados 0.
4. **Invariantes:** 🔒1 PASA (`identical TRUE`, 1.770.628 filas; `anti_join` 0/0; plantado → FALSE) · 🔒2 PASA (`0`; C1 dispara con `68b4e43`) · 🔒3 PASA (`:root` `9842151d…` = M4; 0 hex; C2/C3 disparan) · 🔒4 PASA (`0`; C4 dispara) · 🔒5 PASA (`0`; C5 dispara) · 🔒6 PASA (`12 de 12`; C6 dispara). 6/6.
5. **Decisiones del titular en gates:** (1) FASE 0, H-1: la calibración de M3 "distinto sobre `docs/index.html`" no puede cumplirse (docs y el motor llevan el mismo dato; §8.2 neutraliza la fecha) → "Seguir con el control plantado".
6. **Estado de cifras:** hash §8.2 del payload: FASE 0 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4` (= `docs/index.html`); tras T1: sin cambio (T1 congelada, no tocó nada); tras T2 y final: `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (JSON 59.467.009 → 59.467.463 bytes). Motor `1069b9c9…` (`4a22cbc`) → `8428ea58…` (`e7848df`). `anios_preliminar` `[2025]` → `[]`. Años distintos de 2025 idénticos (1.770.628 filas). **Resumen de T2.6:** 4b: 7.057 RBD comunes, 0 entran/salen, 10 celdas de `prom` distintas (máx |Δ| 2), 0 `sigdifgru`, 0 GSE; 2m: 2.999 comunes, 0 entran/salen, +22 filas de niveles, 25 celdas de `prom` (15 dato↔NA; máx |Δ| 4), 4 `sigdifgru` (NA→−1 ×2, NA→0 ×2), 0 GSE; 8b: 6.007 comunes, 0 cambios. Preliminares archivados en `_archivo/20260923/20_insumos/…` (fuera de git), con su md5 de FASE 0.
7. **Dudas y pendientes consolidados:**
   - **D-1 (T1, bloquea T1):** el modal de territorio de `4a22cbc` se opera con teclado en Chrome del sistema, con ventana y en headless, en las pestañas Comuna, Región y SLEP y con escritura previa (fila en 1–2 Tab, contorno 2 px `--foco`, Enter y Espacio eligen y cierran). Preguntas cerradas al titular: **"¿en qué paso se cortó: el Tab no llegaba a la fila, o llegaba y Enter no elegía?"** y **"¿la pestaña se recargó (Cmd+R) después del build `4a22cbc`, y la dirección era `file:///…/40_salidas/motor_idps.html`? (sí/no)"**. Hipótesis sin medir: pestaña sin recargar con un build anterior, otro archivo (`docs/index.html` no tiene teclado), una extensión del perfil, o la entrada física del teclado frente a la inyección por CDP.
   - **D-2 (A-3):** `32_censo_insumos.R` L197 escribe la hora en `censo_insumos.md`, un derivado versionado: cualquier `run_all()` completo ensucia el árbol. ¿Se quita la hora del `.md` (o se deja de versionar el censo)? (quitar la hora / dejar de versionar / mantener). Bloquea: nada (esta sesión usó D-A1).
   - **D-3 (O-1):** los derivados versionados estaban desfasados desde junio (censo 25 → 28 archivos; `comunas_chile` sin tildes en `nom_reg_rbd`); el commit de T2 los actualiza. ¿Se agrega al cierre de sesión un chequeo de que `run_all()` no cambie derivados versionados? (sí/no). Bloquea: nada.
   - **Testigo del próximo despliegue:** negativo en pantalla, sin "2025*" ni "(preliminar)" en 2025 (hoy `docs/index.html` muestra ambas marcas); estático, `"anios_preliminar":[]` en el JSON descomprimido (`docs/index.html`: `[2025]`).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** (1) T3: el primer texto del comando de la copia incluía un `rm -rf /tmp/s32b_repo` preventivo, no autorizado por el encargo; se quitó antes de ejecutarlo (línea de corrección en T3). Costo: nulo. Ninguno tocó un esperado.
9. **Notas para el revisor:** (a) **gate visual pendiente**, sobre el motor de `e7848df` recién abierto (o recargado con Cmd+R): modal de territorio con Tab desde el buscador (la fila aparece en 2 Tab, después del selector de dependencia) y Enter; y en 2025, ningún "2025*" en la vista histórica ni "(preliminar)" en el banner o la ficha. (b) Los definitivos 2025 casi no mueven el dato que lee el motor (tabla de T2.6); el cambio visible es que desaparece la marca preliminar. (c) La leyenda de la vista histórica sigue diciendo "* resultado preliminar": es texto fijo de la plantilla y ahora no tiene años que marcar (6b 2024, el único preliminar que queda, está fuera de `GRADOS_MOTOR`). (d) El commit de T2 muestra 6 renombres porque los tres datos de 8b son idénticos y las tres glosas casi (git los empareja por contenido). (e) Nada se desplegó.
10. **Estado de cierre:** commiteados `d0d4414`, `364c53a`, `e7848df` y el commit `docs(log)`. Push: según la condición del encargo (FASE R no BLOQUEADO, porcelain vacío, `HEAD..origin/main` = 0); resultado en el reporte final. **No se publica**: el despliegue a `docs/` queda tras el gate visual del titular.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s32b_priv.sh`: el regex de RUT en una variable, con un control plantado en un archivo aparte que no se copia aquí; además "RBD" seguido de número, nombres de establecimiento y nombre de la estación):
```
bash /tmp/s32b_priv.sh
```
esperado: RUT en el log `0`; RUT plantado `1`; RBD con número `0`; establecimientos por nombre `0`; estación por nombre `0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `estación por nombre: 0`. El log nombra comunas, regiones y SLEP (territorios públicos del selector) y ninguna persona.

Paso 5, primera medición: `### FASE` = 6 (FASE 0, T1 congelada, T2, T3, R, L: todas las ejecutadas); `## J` = 1, relleno (`(pendiente)` = 0); **`^esperado:` = 31 y `^obtenido:` = 30**, sin contar este par ni el del paso 4. Causas, leídas línea a línea: (a) el `esperado` de M3 se escribió `esperado (de la tabla del encargo):`; (b) dos resultados se escribieron `obtenido (<archivo>):` (M10 y T2.4). Se anexa lo faltante con su estado real, sin reescribir nada:
esperado: (anexo de formato al `esperado (de la tabla del encargo)` de M3) 64 hex; distinto sobre `docs/index.html`; igual con la fecha alterada.
obtenido: (anexo de formato al `obtenido (…)` de M10) con ventana y headless, fila en 2 Tab con contorno de 2 px, y Enter elige y cierra; no se reproduce el defecto.
obtenido: (anexo de formato al `obtenido (…)` de T2.4) motor nuevo 0 `(preliminar)` y 0 `2025*` en cuatro vistas; motor viejo con las tres marcas.

Segunda medición, tras los anexos:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260923_teclado_territorio_definitivos_2025_s32b_log.md; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L)"; bash /tmp/s32b_priv.sh | head -1'
```
esperado: `FASE=6`; `esperado` = `obtenido` + 1 al medir (este par todavía no tiene su `obtenido:`), es decir 34 y 33; `J=1`; `RUT en el log: 0`.
obtenido: `FASE=6 esperado=34 obtenido=33 J=1`; `RUT en el log: 0`. Con esta línea, **34 = 34**.
