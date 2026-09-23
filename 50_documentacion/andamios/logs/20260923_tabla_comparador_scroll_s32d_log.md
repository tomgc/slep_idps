# Log de sesión: la tabla del comparador hace scroll en vez de comprimirse (s32d)

- **Meta:** que ninguna columna de indicador de la tabla del comparador quede más angosta que un ancho mínimo legible medido (`W_min`) y que, si no caben, `.cmp-tscroll` haga scroll horizontal (T1); que el banner de `32_censo_insumos.R` diga el conteo real de tablas (T2); regenerar el motor (T3). Sin despliegue.
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `0b266a1` (= `origin/main` tras el push de s32c). Primer acto (autorizado): commit `1800147` chore(encargo): s32d, hijo de `0b266a1`. **PUNTO DE RETORNO `<inicio>` = `1800147`.** Porcelain, stash y `rev-parse` se miden en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`, sin `ultracode`; **sin subagentes**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_tabla_comparador_scroll_s32d.md` (commit `1800147`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (min-width de la tabla del comparador)  ALCANCE: 30_procesamiento/35_motor_template.html
T2 (banner del censo)                       ALCANCE: 30_procesamiento/32_censo_insumos.R; independiente de T1
T3 (build)                                  ALCANCE: 40_salidas/motor_idps.html (y censo_insumos.md solo si el build lo reescribe; no debería); requiere T1
Serie: T1 → T2 → T3; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s32d_*`; se copian de los de s32/s32b/s32c cuando sirven.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: a cualquier ancho, ninguna columna de indicador del comparador queda bajo `W_min` = 140 px (`min-width:770px`), y bajo ~820 px de ventana la tabla hace scroll en vez de comprimirse; el banner del censo dice 28 tablas; motor regenerado → cumplida.
- Estado por tarea: FASE 0 completada (1 gate, H-1) · T1 completada (`ac3047e`) · T2 completada (`8ce176a`) · T3 completada (`16f54d9`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 5, rango `1800147`..`<docs(log)>` (`git log --oneline 0b266a1..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/3; reparados 0; abiertos 3 (A-1 "sobre su GSE" pide 140,36 px, 0,36 px dentro del relleno; A-2 el comando de M8 no excluía dos glosas en minúscula; A-3 la cláusula "sin scroll" de M5).
- Invariantes: 5/5 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds; 🔒4 el censo cambia solo un comentario); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, en el build de T1, en T3 y en la regresión; el `run_all()` completo deja el árbol limpio).
- Decisiones autónomas de mayor riesgo: (1) D-A1: el banner dice 28 (filtro del propio script) y no el 30 del comando literal de M8; (2) se mantuvo `W_min` = 140 del barrido pese al margen de 0,36 px de "sobre su GSE", porque el exceso queda dentro del relleno de la celda; (3) el comentario CSS cita la regla del hermano (`.data-table` con `min-width`, L606-617).
- Desviaciones respecto del encargo: T1.1 exigió además que la tabla supere al contenedor (gate H-1); el conteo de T2 usa el filtro del script (D-A1); ninguna otra.
- Dudas abiertas: 1 (A-1 ¿subir `W_min` a 150, `min-width` 810, para tener margen de sobra? sí/no).
- Errores propios: 2 (una corrida de prueba antes del esperado de M5; el instrumento de M6 no revisaba los `th`, corregido y barrido repetido); costo: ~2 minutos.
- Qué debe verificar el revisor por sí mismo: el gate visual del comparador a ancho de celular (la tabla se desplaza de lado y nada se sale de las celdas) y de escritorio (sin cambios); esta sesión midió anchos y desbordes, no gusto.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo `min-width:770px`). El push se hace según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo, sin ultracode; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `1800147` (primer acto).

**M1 y M2:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"'
```
esperado: M1 solo este LOG; stash vacío. M2 `HEAD=1800147`, padre `0b266a1` = `origin/main`; `0`; `1`.
obtenido: `?? 50_documentacion/andamios/logs/20260923_tabla_comparador_scroll_s32d_log.md` (única); `stash: []`; `fetch rc=0`; `HEAD=1800147 padre=0b266a1 origin/main=0b266a1`; `HEAD..origin/main=0 origin/main..HEAD=1`. Reglas 1 y 2 no disparan.

**M3 y M4** (instrumentos copiados de s32c: `/tmp/s32d_payload_sha.sh` → `/tmp/s32d_payload_norm.js`; `/tmp/s32d_fecha_alterada.js`; `/tmp/s32d_plantar_payload.js`; `/tmp/s32d_root_md5.sh`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s32d_motor_fase0.html; md5 -q $M; bash /tmp/s32d_payload_sha.sh /tmp/s32d_motor_fase0.html | cut -c1-170; node /tmp/s32d_fecha_alterada.js /tmp/s32d_motor_fase0.html /tmp/s32d_motor_fecha.html; bash /tmp/s32d_payload_sha.sh /tmp/s32d_motor_fecha.html | cut -c1-170; node /tmp/s32d_plantar_payload.js /tmp/s32d_motor_fase0.html /tmp/s32d_motor_plantado.html; bash /tmp/s32d_payload_sha.sh /tmp/s32d_motor_plantado.html | cut -c1-170; bash /tmp/s32d_root_md5.sh $R/30_procesamiento/35_motor_template.html; cp /tmp/s32d_root_block.txt /tmp/s32d_root_block_fase0.txt'
```
esperado: motor `7eb920d2…` (`584042f`); §8.2 `eb4e00b3…4dc4`; fecha alterada, el mismo; cifra plantada, otro; `:root` `63` líneas y `9842151d…`.
obtenido: motor `7eb920d25c44c3597f7a3a2fb9d0da4b`; §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`** (59.467.463 bytes); fecha alterada: `eb4e00b3…4dc4`, **igual**; plantado: `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8`, **distinto**; `:root` `lineas: 63; md5 9842151d897e8768abd2207513c6607b` (copia en `/tmp/s32d_root_block_fase0.txt`). Valores de 🔒1 y 🔒2.

**Instrumento de T1** (`/tmp/s32d_cmp.js`): una página nueva por medición, con el viewport fijado **antes** de cargar; arma la comparación en la pantalla del comparador eligiendo las entidades desde `DATA` de forma determinista (armado `base`: 1 EE del SLEP foco con dato en 4b 2025, buscado por RBD, la comuna de ese EE, SLEP Costa Central y Chile; cierra con Escape); mide la **primera** `.cmp-table` (ancho de cada `th` con `getBoundingClientRect().width`, ancho de la tabla, `scrollWidth`/`clientWidth` de su `.cmp-tscroll`) y, en **todas** las tablas (una por GSE), cuenta las celdas `td` que desbordan (`scrollWidth > clientWidth + 1` o algún descendiente fuera de la caja de contenido del `td`) y las palabras partidas entre renglones en `th.th-ind`, `.s100-sin`, `.ee-st` y `.s100-ext-it` (rango de texto por palabra con más de un `top`). No imprime RBD ni nombres de establecimientos. Una corrida de prueba a 1280 px se hizo antes de escribir este esperado (instrumento); M5 la repite.

**M5** (caso malo de T1, motor actual `/tmp/s32d_motor_fase0.html`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for v in 430 768 1280; do node /tmp/s32d_cmp.js /tmp/s32d_motor_fase0.html $v - base ext; done > /tmp/s32d_m5.jsonl'
```
esperado: a 430 px, columnas de indicador < 60 px, `.cmp-tscroll` sin scroll (`scrollWidth = clientWidth`) y al menos una celda desbordada; a 768 y 1280, se registra; 0 errores.
obtenido (`/tmp/s32d_m5.jsonl`; 0 errores en las tres; chips `Chile`, `EE`, `Viña del Mar`, `SLEP Costa Central`; 5 tablas, 80 celdas, 1 fila de EE):
- **430 px:** `th` = `[210, 42.5, 42.5, 42.5, 42.5]`; tabla `380` (= `clientWidth` del contenedor); `.cmp-tscroll` `scrollWidth 420`, `clientWidth 380` → **hace scroll: `true`**; **64 de 80 celdas desbordan** (desde la fila nacional, columnas 1–4); 0 palabras partidas; el contenedor recibe foco con Tab (7 Tab) y ArrowRight lo desplaza `0 → 40`.
- **768 px:** `th` = `[210, 127, 127, 127, 127]`; tabla `718`; sin scroll (`718/718`); **4 celdas desbordan** (las 4 de la fila del EE, `row-ee row-ee-first`, tabla 2); 0 palabras partidas; el contenedor no recibe foco (no hay scroll).
- **1280 px:** `th` = `[210, 235, 235, 235, 235]`; tabla `1150`; sin scroll; 0 celdas desbordadas; 0 palabras partidas.
**Contraste con el esperado:** columnas < 60 px (42,5) y celdas desbordadas (64): **cumplen**. "`.cmp-tscroll` sin scroll (`scrollWidth = clientWidth`)": **no se cumple al pie de la letra**: `420 > 380`. Lectura: la tabla mide exactamente lo que el contenedor (380 = 380) y los 40 px de scroll los aporta **el contenido desbordado de las celdas**, no la tabla: la tabla se comprime en vez de ensancharse, que es la premisa de §1; el scroll residual es el síntoma del desborde, no un remedio (desplaza fragmentos cortados). Hallazgo H-1: la cláusula literal choca con la columna "Si difiere" ("si no, congela T1"). Se lleva al titular como gate. Hallazgo aparte: a 768 px también desbordan las 4 celdas de la fila del EE (127 px), fuera de lo que la premisa preveía.

**Gate del titular (H-1):** eligió **"Seguir con T1"**. La cláusula de M5 se lee como "la tabla no supera el contenedor" (380 = 380: cumple); en consecuencia, T1.1 exige además que **la tabla** sea más ancha que el contenedor (`tabla_w > clientWidth`), no solo `scrollWidth > clientWidth`. Queda como error de redacción del encargo (lo consolida FASE L).

**M6** (ancho mínimo legible; `/tmp/s32d_cmp.js` con CSS inyectado antes de armar la comparación: `.cmp-table{width: 210 + 4·W px}` y `th.th-ind{width: W px}`, en un viewport de 1600 px para que la tabla quepa sin scroll; W = 60, 80, …, 240):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for w in 60 80 100 120 140 160 180 200 220 240; do node /tmp/s32d_cmp.js /tmp/s32d_motor_fase0.html 1600 $w base; done > /tmp/s32d_m6.jsonl'
```
esperado: un W entre 60 y 240: el menor en que 0 celdas desbordan su `td` y 0 palabras quedan partidas (en `StackedBar`, su nota "+N sin comparación publicada", `CeldaEE` y los rótulos de indicador); 0 errores. Por M5, a 127 px aún desborda la fila del EE, así que se espera W > 127.
obtenido (primera corrida): W 60 → 60 celdas desbordadas; 80 → 50; 100 → 4 (las de la fila del EE); 120 → 4 (fila del EE); **140 → 0**; 160–240 → 0; 0 palabras partidas en todos; tabla `210 + 4·W` exacta (450 … 1170); 0 errores. **Falta en el instrumento (error propio):** revisaba el desborde de los `td` y las palabras partidas, pero **no** si el rótulo del indicador (`th`) desborda su celda: con `overflow-wrap: normal` una palabra larga no se parte, se sale. Se agrega al instrumento (`th_desbordados`: `scrollWidth > clientWidth + 1` o algún descendiente fuera del `th`) y se repite el barrido completo, con el mismo esperado.
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for w in 60 80 100 120 140 160 180 200 220 240; do node /tmp/s32d_cmp.js /tmp/s32d_motor_fase0.html 1600 $w base; done > /tmp/s32d_m6b.jsonl'
```
esperado: el mismo de M6 (menor W con 0 `td` desbordados, 0 palabras partidas y, ahora también, 0 `th` desbordados).
obtenido (`/tmp/s32d_m6b.jsonl`): W 60 → 60 `td` y 20 `th` desbordados; 80 → 50 y 15; 100 → 4 `td` (fila del EE) y 5 `th` (el rótulo de la columna 3 en cada tabla); **120 → 4 `td` (fila del EE) y 0 `th`**; **140 → 0 y 0**; 160–240 → 0 y 0; 0 palabras partidas; 0 errores. **`W_min` = 140 px** (lo fija la fila del EE; los rótulos caben desde 120).
Comprobación propia de robustez (el EE elegido muestra solo algunos de los cuatro estados; `/tmp/s32d_ee_ancho.js` mide, con los estilos reales del motor, el ancho natural del `td` de `CeldaEE` para cada texto de estado posible, con un puntaje de dos cifras):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32d_ee_ancho.js /tmp/s32d_motor_fase0.html'
```
esperado: (propio) los tres estados que no envuelven ("bajo su GSE", "sin diferencia", "sobre su GSE") caben en ≤ 140 px; "sin comparación publicada" envuelve (`white-space: normal`) y su ancho natural en una línea puede superar 140 sin desbordar.
obtenido: `{"bajo":133,"neutro":140,"sobre":141,"sin":218}` (redondeado hacia arriba); con dos decimales (misma medición, `Math.round(…·100)/100`): `bajo 132.8`, `neutro 139.64`, **`sobre 140.36`**, `sin 217.61`. **"sobre su GSE" necesita 140,36 px** con los 24 px de relleno: en una columna de 140 px su texto excede la caja de contenido en 0,36 px, dentro de los 12 px de relleno del `td` (no se ve ni se recorta). "sin comparación publicada" envuelve y cabe. Se mantiene **`W_min` = 140** (criterio del encargo: barrido de 20 en 20 sobre el armado de M5); el margen de 0,36 px queda como advertencia (A-1).

**M7** (lectura del hermano; sin valor esperado):
```
bash -c 'H=/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html; ls -l $H; grep -n "table-layout\|min-width" $H | head -20; sed -n 605,640p $H; grep -n "tableClass\|table-wrap" $H | head -5'
```
esperado: se registra lo que haya.
obtenido: el archivo existe (203.668 bytes); **no usa `table-layout`**. Su tabla de datos del comparador es `.data-table` dentro de `.table-wrap`: L606-613 `.table-wrap { background: var(--paper); border: 1px solid var(--border-1); border-radius: var(--radius-3); overflow: auto; box-shadow: var(--shadow-1); position: relative; }` y L614-617 `.data-table { border-collapse: collapse; width: 100%; font-size: var(--fs-body); min-width: 1000px; }` (L2616-2620: `const tableClass = "data-table data-table-heat" …`, `<div className="table-wrap">`, `<table className={tableClass}>`); la columna de entidad `th.th-ent` lleva `min-width: 200px; max-width: 260px` (L632-637). **Mismo mecanismo que pide el encargo**: `width: 100%` + `min-width` en la tabla + contenedor con `overflow: auto`, con un valor fijo (1000 px) en vez de medido. T1 replica el mecanismo con el valor medido de M6 y cita estas líneas.

**M8:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; ls $R/20_insumos/idps*.xlsx | grep -vc GLOSAS; ls $R/20_insumos/idps*.xlsx | grep -ic glosa; sed -n 12p $R/30_procesamiento/32_censo_insumos.R; grep "Archivos de datos perfilados" $R/40_salidas/intermedios/censo_insumos.md; sed -n 155,162p $R/30_procesamiento/32_censo_insumos.R'
```
esperado: un número (el log de s32c dice 28); la línea L12 dice "27 tablas de datos"; se compara con el conteo del propio censo.
obtenido: `30` (comando del encargo); `2` archivos con "glosa" en minúscula en la raíz; L12 `# Insumos   : 20_insumos/idps*.xlsx (27 tablas de datos; se excluyen glosas).`; el censo dice `- Archivos de datos perfilados: 28`; el filtro del script (L157-161) excluye `"GLOSAS|glosa"`. **El comando de M8 no excluye las dos glosas en minúscula** (`idps2m2022_rbd_glosa_publica_final.xlsx`, `idps4b2022_rbd_glosa_publica_final.xlsx`, en la raíz de `20_insumos/`): cuenta 30, cuando el banner habla de tablas de datos "sin glosas". Re-medición con el filtro del propio script (`/tmp/s32d_m8.sh`):
```
bash /tmp/s32d_m8.sh
```
esperado: (propio) `28` (= el censo) y las dos glosas en minúscula.
obtenido: `con el filtro del censo: 28`; `glosas en la raiz: idps2m2022_rbd_glosa_publica_final.xlsx idps4b2022_rbd_glosa_publica_final.xlsx`. **Decisión autónoma D-A1:** T2 escribe **28** en el banner, no 30: el banner describe los insumos del script "sin glosas", y el propio script y su salida cuentan 28; el 30 del comando de M8 incluye dos glosas porque su exclusión distingue mayúsculas (error de redacción del encargo, A-2). Reversible (una línea de comentario).

- **Estado de FASE 0:** completada, con un gate del titular (H-1, M5). M1–M4 y M6–M8 coinciden (M6 → `W_min` = 140; M8 → 28 con el filtro del script). Ninguna tarea congelada.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `1800147` (hijo de `0b266a1` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** una corrida de prueba de `/tmp/s32d_cmp.js` a 1280 px antes de escribir el esperado de M5 (M5 la repitió); el instrumento de M6 no revisaba los `th` (corregido y barrido repetido).

### FASE T1: la tabla hace scroll horizontal en vez de comprimirse

- **Paso 0:** M5 (a 430 px: columnas de 42,5 px, 64 celdas desbordadas; a 768 px: la fila del EE desborda; a 1280 px, nada), M6 (`W_min` = 140) y M7 (el hermano usa `min-width` en la tabla dentro de un contenedor `overflow: auto`, L606-617).
- **Implementación:** a `.cmp-table` se le agrega `min-width:770px;` (210 + 4 × 140 = 770, ya múltiplo de 10), con el comentario "s32d: min-width = columna de entidad + 4 × ancho mínimo legible medido (M6); bajo eso, scroll en .cmp-tscroll", que cita además la regla del hermano. No se tocan `table-layout`, anchos de columna, tipografía ni colores. El comentario CSS no lleva `*/` interno.
- **Diff:** `+3/−1` en la plantilla (dos líneas de comentario y la regla con `min-width:770px`); el comentario no contiene `*/` interno.
- **Verificación** (build temporal con `run_all(only = 35L)`; el motor temporal se commitea en T3; mismo instrumento de M5, con el armado `base` y `ext`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32d_run_t1.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32d_run_t1.log; cp $R/40_salidas/motor_idps.html /tmp/s32d_motor_t1.html; md5 -q /tmp/s32d_motor_t1.html; bash /tmp/s32d_payload_sha.sh /tmp/s32d_motor_t1.html | cut -c1-170; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for v in 430 768 1280; do node /tmp/s32d_cmp.js /tmp/s32d_motor_t1.html $v - base ext; done > /tmp/s32d_t1.jsonl'
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…4dc4` (= M3). **T1.1** (430 px): la tabla mide 770 y es más ancha que el contenedor (lectura del gate H-1: `tabla_w > clientWidth`), `.cmp-tscroll` hace scroll (`scrollWidth > clientWidth`), cada columna de indicador ≥ 140 px (140) y 0 `td` y 0 `th` desbordados. **T1.2** (1280 px): sin scroll, `th` = `[210, 235, 235, 235, 235]` como en M5 (± 1 px), 0 desbordes. **T1.3** (768 px): el contenedor (718 px en M5) es menor que 770, así que hace scroll; 0 desbordes (en M5 desbordaba la fila del EE). **T1.5:** con scroll, el contenedor se alcanza con Tab (Chrome enfoca los contenedores desplazables sin hijos enfocables) y ArrowRight lo desplaza; se registra tal cual. **T1.4** = M5 (motor viejo: 64 desbordes a 430). 0 errores.
obtenido: `rc=0`; `0`; motor temporal `81bf74ab80454d0c436f83811bcf7c22`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3). **T1.1 (430 px):** `th` = `[210, 140, 140, 140, 140]`; tabla `770` > contenedor `380`; `scrollWidth 770 > clientWidth 380` (hace scroll); 0 `td` y 0 `th` desbordados; 0 palabras partidas; `min-width` computado `770px`. **T1.3 (768 px):** `th` = `[210, 140 ×4]`; tabla `770` > `718`; hace scroll; 0 desbordes (la fila del EE, que desbordaba en M5, ya no). **T1.2 (1280 px):** `th` = `[210, 235, 235, 235, 235]` = M5 (diferencia 0 px); tabla `1150`; sin scroll; 0 desbordes. **T1.5:** a 430 y 768 px el contenedor, sin `tabindex` propio, **recibe foco con Tab** (7 Tab desde el botón de la comparación: Chrome hace enfocables los contenedores desplazables sin hijos enfocables) y ArrowRight lo desplaza `0 → 40`; a 1280 px (sin scroll) no recibe foco. No se cambió nada (el encargo lo pide así); queda como nota, no como duda, porque sí es alcanzable. **T1.4** = M5. 0 errores.
- **Regresión:** build `rc=0`, 0 warnings; comparación armada y los modales abiertos en cada corrida sin errores (PRUEBAS b completa en T3).
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: ` M 30_procesamiento/35_motor_template.html` (ALCANCE de T1), ` M 40_salidas/motor_idps.html` (temporal, va en T3) y el LOG.
obtenido: ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? …s32d_log.md`. Solo la plantilla se agrega.
- **Commit:** `ac3047e` fix(motor): la tabla del comparador hace scroll en vez de comprimirse (s32d T1). `git show --name-only HEAD` = la plantilla.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: banner del censo con el conteo real

- **Implementación:** L12 `(27 tablas de datos; se excluyen glosas)` → `(28 tablas de datos; se excluyen glosas)` (D-A1: 28, el conteo con el filtro del propio script; ver M8). Nada más en el archivo.
- **Verificación** (`/tmp/s32d_t2.sh`):
```
bash /tmp/s32d_t2.sh
```
esperado: `lineas cambiadas: 2` (una quitada, una agregada); `no comentario: 0` (🔒4); `28 tablas: 1 ; 27 tablas: 0`; el archivo sigue ASCII (`0`).
obtenido: `lineas cambiadas: 2`; `no comentario: 0`; `28 tablas: 1 ; 27 tablas: 0`; `ascii: 0`; `-# Insumos   : … (27 tablas de datos; …)` / `+# Insumos   : … (28 tablas de datos; …)`.
- **Regresión:** T2 cambia solo un comentario de R; el build de T3 (pipeline completo) lo cubre.
- **Chequeo de alcance:** porcelain = ` M 30_procesamiento/32_censo_insumos.R` (ALCANCE de T2), ` M 40_salidas/motor_idps.html` (T3) y el LOG; solo el script se agrega.
- **Commit:** `8ce176a` docs(pipeline): conteo de tablas en el banner del censo (s32d T2). `git show --name-only HEAD` = `30_procesamiento/32_censo_insumos.R`.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T3: build

- **Pasos 1 y 2** (PRUEBAS a con el pipeline completo en el árbol; PRUEBAS b completa: modales con `/tmp/s32_verif.js consola`, una ficha con `/tmp/s32c_t1.js` y una comparación armada con `/tmp/s32d_cmp.js`; T1.1 y T1.2 repetidos sobre el motor commiteable):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32d_run_t3.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32d_run_t3.log; grep -c "Paso 3[1-5] OK" /tmp/s32d_run_t3.log; git -C $R status --porcelain; M=$R/40_salidas/motor_idps.html; md5 -q $M; bash /tmp/s32d_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_verif.js $M consola | tr -d "\n " | grep -oE "\"(modal_[a-z]+|consola_errores|pageerror)\":[^,}]*" | tr "\n" " "; echo; node /tmp/s32c_t1.js $M | tr -d "\n " | grep -oE "\"(glosa_existe|errores)\":[^,}]*" | tr "\n" " "; echo; for v in 430 1280; do node /tmp/s32d_cmp.js $M $v - base; done > /tmp/s32d_t3.jsonl; grep -c "min-width:770px" $M; grep -c "min-width:770px" $R/docs/index.html'
```
esperado: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`, 0 warnings, 5 pasos; porcelain después, **el mismo** (ningún derivado cambia, tampoco `censo_insumos.md`); motor `81bf74ab…` (= build temporal de T1: T2 solo cambió un comentario de R); §8.2 `eb4e00b3…4dc4`; modales `true`, 0 errores; ficha abierta, 0 errores; T1.1 y T1.2 como en T1; testigo `min-width:770px`: `1` en el motor y `0` en `docs/index.html`.
obtenido: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`; `0`; `5`; porcelain después: el mismo (ningún derivado cambió); motor `81bf74ab80454d0c436f83811bcf7c22` (= T1); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3: 🔒1); `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha `glosa_existe: true`, `errores: []`; comparación: 430 px `[210, 140, 140, 140, 140]`, tabla `770`, `770/380` con scroll, 0/0 desbordes; 1280 px `[210, 235 ×4]`, `1150`, sin scroll, 0/0; 0 errores. **Testigo del despliegue futuro:** `min-width:770px` → `1` en el motor, `0` en `docs/index.html`.
- **Paso 4 (commit):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s32d tabla del comparador con scroll" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: commit con solo el motor (`81bf74ab…`); porcelain después: solo el LOG.
obtenido: `16f54d9 build(motor): s32d tabla del comparador con scroll`; `40_salidas/motor_idps.html`; `81bf74ab80454d0c436f83811bcf7c22`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `1800147`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `1800147` (hijo de `0b266a1` = `origin/main`); commits `1800147`, `ac3047e`, `8ce176a`, `16f54d9` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0, en el build temporal de T1 y en T3; ciego a la fecha, ve una cifra plantada (M3) |
| R-03 | M5 (caso malo, motor anterior): a 430 px columnas de 42,5 px, tabla = contenedor (380), 64/80 celdas desbordadas; a 768 px desborda la fila del EE; a 1280 px nada |
| R-04 | M6: `W_min` = 140 (120 desborda la fila del EE; los `th` caben desde 120); "sobre su GSE" pide 140,36 px |
| R-05 | T1: `min-width:770px` = 210 + 4 × 140; a 430 y 768 px la tabla mide 770 y hace scroll, columnas de 140, 0 desbordes; a 1280 px `[210, 235 ×4]` sin scroll (= M5) |
| R-06 | T1.5: con scroll, el contenedor se alcanza con Tab y ArrowRight lo desplaza |
| R-07 | M7: el hermano usa `min-width: 1000px` en `.data-table` dentro de `.table-wrap` con `overflow: auto` (L606-617) |
| R-08 | M8/T2: 28 tablas de datos (30 con el comando literal, que no excluye 2 glosas en minúscula); el banner dice 28; el diff es 1 línea de comentario |
| R-09 | T3: build completo sin cambios en derivados; motor `81bf74ab…`; testigo `min-width:770px` 1 en el motor y 0 en `docs/` |
| 🔒1–🔒5 | invariantes de §3 |
| ALC | alcance global ⊆ ALCANCE de T1–T3 + LOG + encargo |
| REG | PRUEBAS a, b y c sobre el estado final |

**Paso 2. Re-derivación independiente.**

Bloque estático (`/tmp/s32d_r_static.sh`: `find` en vez de `ls` para el conteo de T2, como pide el encargo; objetos de git en vez de archivos del árbol; `grep -o`):
```
bash /tmp/s32d_r_static.sh
```
esperado: R01 padre `0b266a1`, sesión `16f54d9 8ce176a ac3047e 1800147`; R05 `cmp-table{width:100%;min-width:770px` y `770`; R08 `28` sin glosas, `30` con glosas, banner `28 tablas de datos`; R09 `1`, `0`, `0`; R07 la regla `.data-table { … min-width: 1000px; }`.
obtenido: `R01: padre_1800147=0b266a1 sesion=16f54d9 8ce176a ac3047e 1800147`; `R05: … cmp-table{width:100%;min-width:770px ; 210+4*140=770`; `R08 (find): 28 sin glosas ; 30 con glosas ; banner HEAD: 28 tablas de datos` (más una segunda coincidencia ` tablas de datos` sin número: el `[0-9]*` también calza vacío con el comentario de L156, "solo tablas de datos"; no es otro conteo); `R09: motor HEAD 1 ; docs HEAD 0 ; motor anterior 0b266a1 0`; `R07: .data-table { border-collapse: collapse; width: 100%; font-size: var(--fs-body); min-width: 1000px; }`. Todo coincide.

Navegador, otra vía (`/tmp/s32d_cmp.js` con el armado `alt`: una región (código 13), **otro** SLEP, Chile y 1 EE de ese otro SLEP; modo `ext`: anchos con `getComputedStyle` además de `getBoundingClientRect`; sobre el motor final a 430, 768 y 1280 px, sobre el anterior a 430 px, y un barrido `W` = 120/140 con CSS inyectado para re-derivar `W_min`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; (for v in 430 768 1280; do node /tmp/s32d_cmp.js $M $v - alt ext; done; node /tmp/s32d_cmp.js /tmp/s32d_motor_fase0.html 430 - alt ext; for w in 120 140; do node /tmp/s32d_cmp.js /tmp/s32d_motor_fase0.html 1600 $w alt; done) > /tmp/s32d_r_nav.jsonl'
```
esperado: motor final: a 430 y 768 px `th` de 140 (también en `getComputedStyle`), tabla 770 con scroll, 0 desbordes; a 1280 px sin scroll y columnas más anchas que 140; contenedor enfocable con Tab cuando hay scroll. Motor anterior a 430 px: columnas de ~42,5 px y celdas desbordadas. Barrido `alt`: a 140, 0 desbordes (a 120 se registra: depende de los estados de este otro EE). 0 errores.
obtenido (`/tmp/s32d_r_nav.jsonl`; chips `Chile`, `EE`, `Metropolitana`, `SLEP Chinchorro`; 1 fila de EE; 0 errores en las seis): motor final 430 px `th` `[210, 140 ×4]` y `getComputedStyle` `['210px', '140px' ×4]`, tabla `770`, `770/380` con scroll, 0/0 desbordes, Tab → contenedor (7), ArrowRight `0 → 40`; 768 px igual (`770/718`); 1280 px `[210, 235 ×4]` (`235px` computado), `1150`, sin scroll, 0/0, sin foco. Motor anterior 430 px: `[210, 42.5 ×4]` (`42.5px`), tabla `380`, `420/380`, **64 `td` y 20 `th` desbordados**. Barrido `alt`: W 120 → 4 `td` desbordados (la fila del EE) y 0 `th`; **W 140 → 0 y 0**. R-03, R-04, R-05 y R-06 confirmados con otro armado y otra función de medida.

**Pasos 3 a 6** (`/tmp/s32d_final.sh`: invariantes con los comandos de §3; alcance global con lista explícita; regresión completa con `run_all()` en el árbol y PRUEBAS b completa —modales, ficha y comparación—; controles positivos de cada instrumento, entre ellos el motor final **sin** el `min-width` plantado fuera del árbol):
```
bash /tmp/s32d_final.sh
```
esperado: L1 `eb4e00b3…4dc4`; L2a `63` líneas y `9842151d…`; L2b `0`; L3 `0`; L4a `0` y L4b `0`; L5 `0`. ALC 3 rutas (plantilla, script del censo, motor; el encargo está en `<inicio>` y el LOG sin commitear), `0` fuera, porcelain solo el LOG. REGa `rc=0`, 0 warnings, 5 pasos, motor `81bf74ab…`, porcelain solo el LOG. REGb modales `true`, 0 errores; ficha, 0 errores; comparación a 430 px con `[210, 140 ×4]` y 0 desbordes. REGc `eb4e00b3…`. C1 columnas de ~42,5 px y desbordes > 0; C2 `1`; C3 `1`; C4 `1`; C5 imprime `docs/index.html`; C6 `1c3799e2…`.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **🔒1 PASA**; `L2a: lineas: 63; md5 9842151d897e8768abd2207513c6607b`, `L2b: 0` → **🔒2 PASA**; `L3: 0` → **🔒3 PASA**; `L4a: 0 ; L4b: 0` → **🔒4 PASA**; `L5: 0` → **🔒5 PASA**. `ALC: rutas 3 ; fuera 0 ; porcelain [?? …s32d_log.md]` → **alcance PASA**. `REGa: rc=0 warn=0 pasos=5 motor=81bf74ab80454d0c436f83811bcf7c22 porcelain [?? …s32d_log.md]`; REGb modales `true`/`true`, `consola_errores: []`, `pageerror: []`; ficha `glosa_existe: true`, `errores: []`; comparación a 430 px `th` `[210,140,140,140,140]`, 0 `td` y 0 `th` desbordados, 0 errores; `REGc: eb4e00b3…4dc4` → **regresión PASA**. Controles: `C1` motor final sin el `min-width` → `[210,42.5 ×4]` y **64** desbordes (el instrumento distingue el arreglo); `C2: 1`; `C3: 1`; `C4: 1`; `C5: docs/index.html`; `C6: 1c3799e2e8e35da8`. **Todos disparan.**

**Pasos 7-8.** 0 BLOQUEA, 0 REPARA; ciclos usados 0 de 2.

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `log --format=%p`; `log 0b266a1..HEAD` | padre `0b266a1`; 4 commits | iguales | — | ninguna | — | — |
| R-02 | §8.2 constante | L1 + REGc | `eb4e00b3…` | igual | — | ninguna | — | C6 |
| R-03 | caso malo | armado `alt` + `getComputedStyle` sobre el motor anterior | 42,5 px; desbordes | `42.5px`; 64 `td`, 20 `th` | — | ninguna | — | C1 |
| R-04 | `W_min` = 140 | barrido con el armado `alt` | 120 desborda, 140 no | 4 → 0 | ADVIERTE (A-1: "sobre su GSE" pide 140,36 px; 0,36 px dentro del relleno) | nota | — | — |
| R-05 | `min-width:770px` y sus efectos | `grep -o` en HEAD; armado `alt` a 430/768/1280 | 770; 140 con scroll; 1280 sin cambio | iguales | — | ninguna | — | — |
| R-06 | contenedor alcanzable | Tab + ArrowRight con el armado `alt` | alcanzable con scroll | 7 Tab; `0 → 40` | — | ninguna | — | — |
| R-07 | mecanismo del hermano | `sed -n 614,617p` | `min-width` en `.data-table` | `min-width: 1000px` | — | ninguna | — | — |
| R-08 | 28 tablas | `find … ! -iname '*glosa*'`; banner en HEAD | 28; 28 | 28 (30 con glosas); 28 | ADVIERTE (A-2: el comando de M8 del encargo no excluye 2 glosas en minúscula) | D-A1 (28) | `8ce176a` | L4b |
| R-09 | build limpio y testigo | `run_all()` en el árbol; `grep -o` sobre objetos | porcelain solo el LOG; 1/0/0 | iguales | — | ninguna | — | — |
| H-1 | cláusula de M5 "sin scroll" | `scrollWidth` vs ancho de la tabla | — | 420/380 con tabla = 380 | ADVIERTE (A-3: redacción del encargo) | gate del titular | — | — |
| 🔒1–🔒5 | invariantes | `/tmp/s32d_final.sh` | ver arriba | todos PASA | — | — | — | C2–C6 |
| ALC | alcance global | lista + `grep -vxF` | 0 fuera | 0 fuera (3 rutas) | — | — | — | C5 |
| REG | PRUEBAS a, b, c | `/tmp/s32d_final.sh` | `rc=0`, árbol limpio; 0 errores; `eb4e00b3…` | iguales | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/0/3 (A-1 margen de 0,36 px de "sobre su GSE" a 140 px; A-2 comando de M8 que no excluye las glosas en minúscula; A-3 cláusula de M5 que confundía el scroll del contenido con el de la tabla).
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** ninguno nuevo.

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 4 respecto de `origin/main`.
obtenido: `?? 50_documentacion/andamios/logs/20260923_tabla_comparador_scroll_s32d_log.md` (única); `## main...origin/main [ahead 4]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s32d: la tabla del comparador se comprimía hasta columnas de 42,5 px en pantallas angostas y sus celdas desbordaban. Fases: FASE 0 (con un gate, H-1), T1, T2, T3, R y L. Estado del grafo: T1 completada (`ac3047e`) · T2 completada (`8ce176a`) · T3 completada (`16f54d9`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
2. **Commits** (`git log 0b266a1..HEAD --oneline`, antes del commit de este log):
   - `1800147` chore(encargo): s32d — FASE 0 (= `<inicio>`)
   - `ac3047e` fix(motor): la tabla del comparador hace scroll en vez de comprimirse (s32d T1)
   - `8ce176a` docs(pipeline): conteo de tablas en el banner del censo (s32d T2)
   - `16f54d9` build(motor): s32d tabla del comparador con scroll — motor `81bf74ab80454d0c436f83811bcf7c22`
   - (este log: `docs(log): s32d tabla del comparador con scroll`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/3; reparados 0.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, en el build de T1, en T3 y en la regresión; C6 dispara) · 🔒2 PASA (`:root` `9842151d…`; 0 hex; C3 dispara) · 🔒3 PASA (`0`) · 🔒4 PASA (`0`; el censo cambia solo un comentario; C2 dispara) · 🔒5 PASA (`0`; C4 dispara). 5/5.
5. **Decisiones del titular en gates:** (1) FASE 0, H-1 (M5): "Seguir con T1", leyendo la cláusula como "la tabla no supera el contenedor".
6. **Estado de cifras:** hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en todos los builds (sin cambio de dato). **`W_min` = 140 px**; `min-width` elegido **770 px** (210 + 4 × 140). Anchos de la primera tabla (entidad + 4 indicadores), armado `base`:

   | viewport | antes (`7eb920d2…`) | después (`81bf74ab…`) |
   |---|---|---|
   | 430 px | `[210, 42.5 ×4]`, tabla 380 = contenedor; 64/80 celdas desbordan | `[210, 140 ×4]`, tabla 770 con scroll (contenedor 380); 0 desbordes |
   | 768 px | `[210, 127 ×4]`, tabla 718, sin scroll; 4 celdas (fila del EE) desbordan | `[210, 140 ×4]`, tabla 770 con scroll (contenedor 718); 0 desbordes |
   | 1280 px | `[210, 235 ×4]`, tabla 1150, sin scroll; 0 desbordes | `[210, 235 ×4]`, igual; 0 desbordes |

   Motor `7eb920d2…` → `81bf74ab…`; `docs/` sin cambios (`7eb920d2…`).
7. **Dudas y pendientes consolidados:**
   - A-1: a 140 px, "sobre su GSE" excede su caja de contenido en 0,36 px (dentro del relleno de 12 px; no se ve). ¿Se sube `W_min` a 150 (`min-width` 810) para tener margen de sobra? (sí/no). Bloquea: nada.
   - A-2: el comando de M8 (`grep -vc GLOSAS`) contaba 30 porque no excluye dos glosas en minúscula en la raíz de `20_insumos/`; el banner quedó en 28, el conteo del propio script. Para el redactor. Bloquea: nada.
   - A-3: la cláusula "sin scroll" de M5 no distinguía el scroll que aporta el contenido desbordado del ancho de la tabla (gate H-1). Para el redactor.
   - Nota (T1.5): con scroll, el contenedor de la tabla se alcanza con Tab (Chrome lo hace enfocable sin `tabindex`) y las flechas lo desplazan; no se agregó nada.
   - **Testigo del próximo despliegue:** `min-width:770px` (`grep -c` → `1` en el motor, `0` en `docs/index.html`).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** (1) FASE 0: una corrida de prueba del instrumento a 1280 px antes de escribir el esperado de M5 (M5 la repitió). (2) FASE 0: el instrumento de M6 no revisaba el desborde de los `th`; se agregó y se repitió el barrido completo (mismo resultado: 140). Costo: una corrida extra de ~2 minutos. Ninguno tocó un criterio ni la meta.
9. **Notas para el revisor:** (a) gate visual del comparador **a ancho de celular** (la tabla se desplaza de lado con el dedo o con el trackpad, las columnas conservan 140 px y ninguna barra ni texto se sale de su celda) y **de escritorio** (1280 px: nada cambia); (b) entre 770 y ~820 px de ventana, la tabla todavía cabe apenas y no hace scroll; bajo eso, sí; (c) el despliegue a `docs/` queda para después del gate.
10. **Estado de cierre:** commiteados `1800147`, `ac3047e`, `8ce176a`, `16f54d9` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s32d_priv.sh`, adaptado de s32c: RUT con la expresión en una variable y un control plantado en un archivo aparte; "RBD" seguido de número; nombres de establecimiento; nombre de la estación):
```
bash /tmp/s32d_priv.sh
```
esperado: `0`; plantado `1`; `0`; `0`; `0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `estación por nombre: 0`. El log nombra territorios públicos (Viña del Mar, Metropolitana, SLEP Costa Central, SLEP Chinchorro) y ningún establecimiento ni persona.

Paso 5, primera medición (sin contar el par del paso 4): `### FASE` = 6 (FASE 0, T1, T2, T3, R, L); `## J` = 1, relleno; **`^esperado:` = 18 y `^obtenido:` = 14**. Causa: cuatro resultados se escribieron como `obtenido (<archivo>):` (M5, las dos corridas de M6 y la re-derivación en navegador de FASE R), que el conteo no ve (mismo desliz que en s32). Se anexa lo faltante con su estado real:
obtenido: (anexo de formato a M5) a 430 px columnas de 42,5 px, tabla = contenedor, 64/80 celdas desbordadas; a 768 px 4 celdas; a 1280 px ninguna.
obtenido: (anexo de formato a la primera corrida de M6) 140 es el primer W sin `td` desbordados (sin revisar los `th`).
obtenido: (anexo de formato a la segunda corrida de M6) `W_min` = 140 con `td` y `th` revisados.
obtenido: (anexo de formato a la re-derivación en navegador de FASE R) armado `alt`: 140 px con scroll y 0 desbordes a 430/768; 1280 sin cambio; el motor anterior desborda; W 120 → 4, W 140 → 0.

Segunda medición:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260923_tabla_comparador_scroll_s32d_log.md; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L)"; bash /tmp/s32d_priv.sh | head -1'
```
esperado: `FASE=6`; `esperado=20` y `obtenido=19` al medir (este par todavía sin su `obtenido:`); `J=1`; `RUT en el log: 0`.
obtenido: `FASE=6 esperado=20 obtenido=19 J=1`; `RUT en el log: 0`. Con esta línea, **20 = 20**.
