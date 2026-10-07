# Log de sesión: leyendas del preliminar, censo sin hora y despliegue (s32c)

- **Meta:** que ninguna leyenda ni glosa explique el asterisco del preliminar si ningún año visible es preliminar (T1); que un `run_all()` sin cambios en los insumos deje `censo_insumos.md` byte-idéntico (T2); regenerar el motor (T3) y desplegarlo a `docs/index.html` byte a byte (T4).
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `9185ec6` (= `origin/main` tras el push de s32b). Primer acto, antes de medir (autorizado): commit `f5523f7` chore(encargo): s32c; docs(log): error #4 del asistente (el encargo y la fila 4 del registro de errores del asistente, que estaba ` M`), hijo de `9185ec6`. **PUNTO DE RETORNO `<inicio>` = `f5523f7`.** Porcelain, stash y `rev-parse` se miden en M1/M2.
- **Gate del titular:** el mensaje de lanzamiento contiene literalmente `GATE APROBADO` → **T4 (despliegue) habilitada**.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`, sin `ultracode`; **sin subagentes**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_leyendas_censo_despliegue_s32c.md` (commit `f5523f7`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (textos del asterisco condicionales)  ALCANCE: 30_procesamiento/35_motor_template.html
T2 (censo sin hora)                      ALCANCE: 30_procesamiento/32_censo_insumos.R, 40_salidas/intermedios/censo_insumos.md
T3 (build)                               ALCANCE: 40_salidas/motor_idps.html; requiere T1 o T2 completada
T4 (despliegue)                          ALCANCE: docs/index.html; requiere T3 completada y GATE APROBADO
Serie: T1 → T2 → T3 → T4; FASE R y FASE L fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s32c_*`; se copian de los de s32/s32b (`/tmp/s32_*`, `/tmp/s32b_*`) cuando sirven.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: la leyenda del panorama y la glosa de la ficha explican el asterisco solo si algún año visible es preliminar; el censo ya no sella la hora y un `run_all()` completo deja el árbol limpio; motor regenerado y desplegado a `docs/` byte a byte → cumplida.
- Estado por tarea: FASE 0 completada · T1 completada (`c5ade2e`) · T2 completada (`c549d53`) · T3 completada (`584042f`) · T4 completada (`1633319`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 6, rango `f5523f7`..`<docs(log)>` (`git log --oneline 9185ec6..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 1 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/2; reparados 0; abiertos 2 (A-1 el banner de `32_censo_insumos.R` dice "27 tablas" y son 28; A-2 el cambio de leyendas se desplegó sin gate visual propio).
- Invariantes: 5/5 PASA (🔒1 §8.2 `eb4e00b3…` en todos los builds y en `docs/`; 🔒5 `docs/index.html` = motor `7eb920d2…`, commit de 1 ruta); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: hash §8.2 igual en FASE 0, en cada build y en `docs/`; `censo_insumos.md` cambia solo en la línea de fecha, y su contenido es idéntico entre dos builds con `md5` y `cmp`).
- Decisiones autónomas de mayor riesgo: (1) la condición de la leyenda mira las dos fuentes del asterisco del panorama (`y.preliminar || prelimY(y.agno)`); (2) el censo no usa la fecha de modificación de los insumos, que cambia con cada `clone`/`checkout`: la línea dice que la fecha la registra git; (3) el comentario del censo va sin tildes porque el script es ASCII puro.
- Desviaciones respecto del encargo: el build temporal de T1 usó `run_all(only = 35L)` para no reescribir el censo antes de T2; M1 y los chequeos de porcelain cuentan el LOG, que el propio encargo crea antes de medir. Ninguna otra.
- Dudas abiertas: 2 (A-1 ¿corregir el banner del censo? sí/no · A-2 ¿revisar en el sitio publicado las leyendas sin asterisco? sí/no).
- Errores propios: 6, todos de instrumento o de redacción del log (entre ellos `page.content()`, que incluye el JSX y no discriminaba, y el "Diff: +3/−2" de T1, que es +5/−2); ninguno tocó un criterio ni la meta; costo: minutos.
- Qué debe verificar el revisor por sí mismo: el sitio publicado con recarga forzada: testigo `check-row:focus-visible`, teclado del modal de territorio, y la vista histórica de 2025 sin "2025*", sin "* resultado preliminar" y sin la oración del asterisco en la ficha.
- No publicado / queda al usuario: nada retenido por el ejecutor; `docs/` desplegado en `1633319`. El push se hace según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo, sin ultracode; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `f5523f7` (primer acto).

**M1 y M2:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"'
```
esperado: M1 vacío salvo este LOG, que el encargo manda crear antes de medir (el esperado literal "vacío" no puede contarlo); stash vacío. M2 `HEAD=f5523f7`, padre `9185ec6` = `origin/main`; `HEAD..origin/main=0`; `origin/main..HEAD=1`.
obtenido: `?? 50_documentacion/andamios/logs/20260923_leyendas_censo_despliegue_s32c_log.md` (única); `stash: []`; `fetch rc=0`; `HEAD=f5523f7 padre=9185ec6 origin/main=9185ec6`; `HEAD..origin/main=0 origin/main..HEAD=1`. Reglas 1 y 2 no disparan.

**M3** (`/tmp/s32c_payload_sha.sh` → `/tmp/s32c_payload_norm.js`, copia del instrumento §8.2 de s32b; `/tmp/s32c_fecha_alterada.js` cambia solo `fecha_generacion`; `/tmp/s32c_plantar_payload.js` cambia `region_foco` "5"→"6"):
```
bash -c 'M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; cp $M /tmp/s32c_motor_fase0.html; md5 -q $M; bash /tmp/s32c_payload_sha.sh /tmp/s32c_motor_fase0.html; node /tmp/s32c_fecha_alterada.js /tmp/s32c_motor_fase0.html /tmp/s32c_motor_fecha.html; bash /tmp/s32c_payload_sha.sh /tmp/s32c_motor_fecha.html /tmp/s32c_motor_fase0.html; node /tmp/s32c_plantar_payload.js /tmp/s32c_motor_fase0.html /tmp/s32c_motor_plantado.html; bash /tmp/s32c_payload_sha.sh /tmp/s32c_motor_plantado.html /tmp/s32c_motor_fase0.html'
```
esperado: motor `8428ea58…` (`e7848df`); hash de 64 hex (se espera `eb4e00b3…4dc4`, el final de s32b); con la fecha alterada, el **mismo**; con la cifra plantada, **otro**.
obtenido: motor `8428ea585f70b9fae0efa4f9cc9907ad`; **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`** (59.467.463 bytes); fecha alterada: `eb4e00b3…4dc4`, **igual**; plantado: `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8`, **distinto**. Valor del 🔒1. (Error propio menor: la primera copia del script del `:root`, hecha con `sed` sin la bandera `g`, dejaba una referencia a `/tmp/s32_root_block.txt`; se regeneró con `g` antes de medir M4: `0` referencias viejas, `2` nuevas.)

**M4, M5, M7 y M8:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; T=$R/30_procesamiento/35_motor_template.html; bash /tmp/s32c_root_md5.sh $T; cp /tmp/s32c_root_block.txt /tmp/s32c_root_block_fase0.txt; grep -n "resultado preliminar" $T | cut -c1-160; grep -n "carácter preliminar" $T | cut -c1-120; grep -n "anios.some(a=>PRELIM.has" $T | cut -c1-160; grep -c "Fecha: " $R/40_salidas/intermedios/censo_insumos.md; grep "Fecha: " $R/40_salidas/intermedios/censo_insumos.md; md5 -q $R/docs/index.html; grep -c "check-row:focus-visible" $R/docs/index.html'
```
esperado: M4 `63` líneas, md5 `9842151d…` (el de s32/s32b); M5 dos textos del asterisco sin condición (leyenda ~L2692 "* resultado preliminar"; glosa ~L1495 "carácter preliminar") y uno condicionado (~L1512 con `anios.some(a=>PRELIM.has(String(a)))`); M7 `1` y una línea `- Fecha: AAAA-MM-DD HH:MM:SS`; M8 `6c5feab5428ed05dff09867f2b47bba3` y `0`.
obtenido: M4 `lineas: 63; md5 9842151d897e8768abd2207513c6607b` (copia en `/tmp/s32c_root_block_fase0.txt`). M5: L2692 `…<span>* resultado preliminar</span>` (sin condición, en la leyenda `vt-leg` de `PanoramaHistorico`); L1495 `ficha-explain` con "El signo * al lado del año indica el carácter preliminar de los resultados, según lo informado por la Agencia." (sin condición); L1512 la nota de barras con `{anios.some(a=>PRELIM.has(String(a)))?"El signo * … carácter preliminar …":""}` (condicionada; por eso `grep "carácter preliminar"` también la devuelve). Coincide: 2 sin condición, 1 con condición. M7 `1`; `- Fecha: 2026-09-23 16:32:17` (hora `HH:MM:SS`). M8 `6c5feab5428ed05dff09867f2b47bba3`; `0`.
Lectura adicional para T1 (Paso 0 anticipado): en `PanoramaHistorico` el asterisco se dibuja desde **dos** fuentes: la franja usa `prelimY(y)` (`PRELIM`, de `DATA.meta.anios_preliminar`) y el encabezado de la matriz usa `bq.y.preliminar` (de `DATA.meta.eje_historico`, que en `35_generar_motor_html.R` L443 es `preliminar = y %in% anios_prelim`, la misma fuente en R). En la ficha, `anios` es la prop `fichaAnios` (`grado_anios` del grado), la misma que usa la nota de barras.

**M6** (caso malo de T1; `/tmp/s32c_t1.js`: `PRELIM` del script; leyenda `.vt-leg` del panorama histórico del SLEP foco en 4b y en 2m; glosa `.ficha-explain` de la vista histórica de la ficha de la primera tarjeta del foco; y cuántos `AAAA*` hay en pantalla):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32c_t1.js /tmp/s32c_motor_fase0.html > /tmp/s32c_m6.json'
```
esperado: `PRELIM` vacío; la leyenda (4b y 2m) contiene "resultado preliminar" y la glosa "carácter preliminar", **aunque no haya ningún `AAAA*` en pantalla**; la nota de barras, no (ya está condicionada); 0 errores.
obtenido: `prelim: []`; panorama 4b `tiene_resultado_preliminar: true`, `asteriscos_visibles: 0`; panorama 2m (`2° medio` activo) `true`, `0`; ficha histórica: glosa presente, `tiene_caracter_preliminar: true`, `asteriscos_visibles: 0`, nota de barras `false`; 0 errores. **Caso malo confirmado**: las dos leyendas explican un asterisco que no aparece en ningún año.

- **Estado de FASE 0:** completada. M1–M8 coinciden con su esperado (M1 con la lectura del LOG creado por el propio encargo). Ninguna tarea congelada.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `f5523f7` (hijo de `9185ec6` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** el `sed` sin `g` al copiar el script del `:root` (corregido antes de M4; costo nulo).

### FASE T1: el asterisco solo se explica cuando existe

- **Paso 0:** leídos los dos textos (L2692 leyenda `vt-leg` de `PanoramaHistorico`; L1495 glosa `ficha-explain`) y el patrón de L1512 (`anios.some(a=>PRELIM.has(String(a)))`). En `PanoramaHistorico` están en ámbito `conDato` (años con dato del eje del grado) y `prelimY`; el asterisco del panorama sale de dos fuentes (`prelimY` en la franja, `y.preliminar` en el encabezado de la matriz), así que la condición de la leyenda mira las dos: `conDato.some(y=>y.preliminar||prelimY(y.agno))`. En la ficha, `anios` es la prop del grado (la misma de L1512).
- **Implementación:** (a) en `PanoramaHistorico`, `const hayPrelim=conDato.some(y=>y.preliminar||prelimY(y.agno));` junto a `prelimY`, con el comentario pedido, y la leyenda dibuja `{hayPrelim && <span>* resultado preliminar</span>}`; (b) en la ficha, la oración del asterisco pasa a `{anios.some(a=>PRELIM.has(String(a)))?"El signo * … la Agencia. ":""}` dentro del mismo texto (el resto de la glosa queda literal), con el comentario pedido como comentario JSX antes del `div`.
- **Diff:** `+3/−2` en la plantilla (comentario JSX + oración condicionada en la ficha; comentario + `hayPrelim` y la leyenda condicionada en el panorama).
- **Verificación** (build temporal con `run_all(only = 35L)`: T1 solo toca la plantilla, y un `run_all()` completo antes de T2 reescribiría la hora de `censo_insumos.md`, que es ALCANCE de T2; el motor temporal no se commitea hasta T3):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32c_run_t1.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32c_run_t1.log; cp $R/40_salidas/motor_idps.html /tmp/s32c_motor_t1.html; md5 -q /tmp/s32c_motor_t1.html; bash /tmp/s32c_payload_sha.sh /tmp/s32c_motor_t1.html | cut -c1-170; node /tmp/s32c_plantar_prelim.js /tmp/s32c_motor_t1.html /tmp/s32c_motor_t1_prelim.html; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32c_t1.js /tmp/s32c_motor_t1.html > /tmp/s32c_t11.json; node /tmp/s32c_t1.js /tmp/s32c_motor_t1_prelim.html > /tmp/s32c_t12.json'
```
esperado: `rc=0`, 0 warnings; hash §8.2 `eb4e00b3…4dc4` (= M3, 🔒1); **T1.1** motor nuevo: la leyenda del panorama (4b y 2m) sin "resultado preliminar" y la glosa de la ficha sin "carácter preliminar", con el resto de la glosa intacto (empieza en "Vista histórica. Puntaje por año…" y termina en "…resultados válidos."); **T1.2** copia plantada con 2025 preliminar: los dos textos vuelven (leyenda 4b y 2m `true`, glosa `true`), la nota de barras también, y aparecen `AAAA*` en pantalla; **T1.3** = M6 (motor viejo: los dos textos sin asteriscos); 0 errores en todas.
obtenido: `rc=0`; `0`; motor temporal `7eb920d25c44c3597f7a3a2fb9d0da4b`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3; 🔒1 y regla 3 sin disparar); plantado `anios_preliminar=[2025]; entradas 2025 del eje marcadas: 2`. **T1.1** (`/tmp/s32c_t11.json`): `prelim: []`; panorama 4b y 2m `tiene_resultado_preliminar: false`; ficha `tiene_caracter_preliminar: false`, glosa presente, empieza en `Vista histórica. Puntaje por año de cada` y termina en `…las últimas tres aplicaciones con resultados válidos.`; 0 `AAAA*`; 0 errores. **T1.2** (`/tmp/s32c_t12.json`): `prelim: ["2025"]`; panorama 4b `true` con 11 `AAAA*`, 2m `true` con 7; ficha `true`, nota de barras `true`, 30 `AAAA*`; 0 errores. **T1.3** = M6 (motor viejo: `true`/`true`/`true` sin asteriscos). Los tres casos se separan.
- **Regresión:** build `rc=0`, 0 warnings; los dos modales y una ficha se abren en las corridas de T1.1/T1.2 sin errores de consola (PRUEBAS b completa, en T3).
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: ` M 30_procesamiento/35_motor_template.html` (ALCANCE de T1), ` M 40_salidas/motor_idps.html` (build temporal; se commitea en T3) y el LOG.
- **Commit:** `c5ade2e` fix(motor): el asterisco solo se explica si hay año preliminar (s32c T1). `git show --name-only HEAD` = la plantilla; el motor temporal queda sin agregar.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: el censo deja de sellar la hora

- **Paso 0:** `32_censo_insumos.R` L197 `paste0("- Fecha: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))`. El script es ASCII puro (`LC_ALL=C grep -c '[^ -~<tab>]'` → `0`) y ninguno de sus comentarios lleva tildes.
- **Implementación:** la línea pasa a `"- Fecha: la registra git (el reporte no sella la hora del build)"`, precedida del comentario del encargo **sin tildes** ("s32c: git registra cuando cambio el censo; el reloj ensuciaba el arbol en cada build (D-2 s32b).") para conservar el archivo en ASCII como el resto del script. **Decisión autónoma D-A1:** no se usa la fecha de modificación de los insumos: es un atributo del sistema de archivos, no del dato, y cambia con `git clone`/`checkout` (el checkout fija la hora del momento), así que volvería a hacer que el reporte dependa del entorno. El encabezado `# Fecha : 2026-06-11` no se toca: la convención (POLITICA §5.4, "header banner … fecha") pide la fecha del script, y ningún otro script la actualiza al modificarse (31 dice 2026-06-11 con último commit 2026-06-19).
- **Diff:** `+2/−1` en `32_censo_insumos.R`; el archivo sigue ASCII (`0`).
- **Verificación** (`/tmp/s32c_t2.sh`: dos `run_all()` completos seguidos, md5 del censo y del motor tras cada uno, `cmp` de los dos censos, porcelain tras el segundo; el censo de `9185ec6` con `git show`; la expresión de la hora va en una variable del script):
```
bash /tmp/s32c_t2.sh
```
esperado: **T2.1** las dos corridas con `rc=0`, 0 warnings y 5 pasos OK; el md5 del censo igual en las dos y `cmp` IDÉNTICOS; porcelain tras la segunda: ` M 30_procesamiento/32_censo_insumos.R`, ` M 40_salidas/intermedios/censo_insumos.md`, ` M 40_salidas/motor_idps.html` (ALCANCE de T2 y T3) y el LOG, ningún otro derivado. **T2.2** hora en `9185ec6`: `1`; en el nuevo: `0`. **T2.3** el `diff` muestra solo la línea `- Fecha:`.
obtenido: `corrida 1: rc=0 warn=0 pasos_ok=5 md5_censo=a3e7b96e9bd47ad7044619baba260fb7 md5_motor=7eb920d25c44c3597f7a3a2fb9d0da4b`; `corrida 2: rc=0 warn=0 pasos_ok=5 md5_censo=a3e7b96e9bd47ad7044619baba260fb7 md5_motor=7eb920d25c44c3597f7a3a2fb9d0da4b`; `cmp corridas: IDENTICOS`; porcelain: ` M 30_procesamiento/32_censo_insumos.R`, ` M 40_salidas/intermedios/censo_insumos.md`, ` M 40_salidas/motor_idps.html` y el LOG (los seis parquets derivados no cambian). **T2.2:** `hora HH:MM:SS en 9185ec6: 1 ; en el nuevo: 0`. **T2.3:** `diff` = `3c3` `< - Fecha: 2026-09-23 16:32:17` / `> - Fecha: la registra git (el reporte no sella la hora del build)` (única diferencia; el `rc=1` del script es el de `diff` al encontrarla). El motor de los builds completos es `7eb920d2…`, el mismo del build temporal de T1.
- **Regresión (PRUEBAS a):** dos `run_all()` completos, `rc=0`, 0 warnings, 5 pasos OK.
- **Chequeo de alcance:** el porcelain de arriba: ALCANCE de T2 (`32_censo_insumos.R`, `censo_insumos.md`) más el motor (T3) y el LOG. Se agregan solo las dos rutas de T2.
- **Commit:** `c549d53` fix(pipeline): censo_insumos sin hora de build (s32c T2). `git show --name-only HEAD` = `30_procesamiento/32_censo_insumos.R`, `40_salidas/intermedios/censo_insumos.md`.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T3: build

- **Paso 1 y paso 2** (con T2 hecho, el build completo ya no ensucia el árbol; PRUEBAS b = cargar, abrir los dos modales y abrir una ficha, con `/tmp/s32_verif.js consola` y `/tmp/s32c_t1.js`, que abre la ficha de la primera tarjeta; T1.1 repetido sobre el motor commiteable):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32c_run_t3.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32c_run_t3.log; grep -c "Paso 3[1-5] OK" /tmp/s32c_run_t3.log; git -C $R status --porcelain; md5 -q $R/40_salidas/motor_idps.html; bash /tmp/s32c_payload_sha.sh $R/40_salidas/motor_idps.html | cut -c1-170; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_verif.js $R/40_salidas/motor_idps.html consola > /tmp/s32c_t3_consola.json; grep -A1 -E "consola_errores|pageerror|modal_" /tmp/s32c_t3_consola.json | tr -d "\n "; echo; node /tmp/s32c_t1.js $R/40_salidas/motor_idps.html > /tmp/s32c_t3_t1.json; grep -E "tiene_|asteriscos|errores|glosa_existe" /tmp/s32c_t3_t1.json | tr -d "\n "'
```
esperado: porcelain antes: ` M 40_salidas/motor_idps.html` y el LOG; `rc=0`, 0 warnings, 5 pasos OK; porcelain después: **el mismo** (ningún derivado cambia); motor `7eb920d2…`; §8.2 `eb4e00b3…4dc4` (= M3); los dos modales abren y la ficha abre, 0 errores y 0 `pageerror`; T1.1: `tiene_resultado_preliminar` y `tiene_caracter_preliminar` `false`, 0 asteriscos.
obtenido: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`; `0`; `5`; porcelain después, **el mismo** (el build completo ya no toca ningún derivado versionado); motor `7eb920d25c44c3597f7a3a2fb9d0da4b`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d…` (recortado por `cut`; completo en el commit de abajo); `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; ficha abierta (`glosa_existe: true`), 0 errores; T1.1 panorama 4b y 2m `false`, ficha `false`, 0 asteriscos.
- **Chequeo de alcance y commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; bash /tmp/s32c_payload_sha.sh $R/40_salidas/motor_idps.html | grep -o "sha256_norm\":\"[0-9a-f]*"; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s32c leyendas del preliminar" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: §8.2 completo `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; commit con solo el motor (`7eb920d2…`); porcelain después: solo el LOG.
obtenido: `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3: 🔒1 PASA en el build final); `584042f build(motor): s32c leyendas del preliminar`; `git show --name-only HEAD` = `40_salidas/motor_idps.html`; `7eb920d25c44c3597f7a3a2fb9d0da4b`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T4: despliegue

- **Gate:** el mensaje de lanzamiento contiene `GATE APROBADO` y T3 está completada → T4 corre.
- **Despliegue y verificación:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; md5 -q $R/docs/index.html; cp $R/40_salidas/motor_idps.html $R/docs/index.html; md5 -q $R/docs/index.html; md5 -q $R/40_salidas/motor_idps.html; cmp -s $R/docs/index.html $R/40_salidas/motor_idps.html && echo byte_a_byte; grep -c "check-row:focus-visible" $R/docs/index.html; git -C $R status --porcelain'
```
esperado: antes `6c5feab5428ed05dff09867f2b47bba3`; después `7eb920d2…` en los dos archivos (🔒5), distinto de `6c5feab5…`; `byte_a_byte`; testigo `check-row:focus-visible` ≥ 1 (en el `docs/` anterior, `0`, M8); porcelain: ` M docs/index.html` y el LOG.
obtenido: antes `6c5feab5428ed05dff09867f2b47bba3`; después `7eb920d25c44c3597f7a3a2fb9d0da4b` en `docs/index.html` y en el motor; `byte_a_byte`; testigo `1`; porcelain ` M docs/index.html` + LOG.
- **Commit** (solo `docs/index.html`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add docs/index.html && git -C $R commit -q -m "deploy(docs): motor s32 (teclado, plurales, definitivos 2025 y leyendas)" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD | wc -l && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:docs/index.html | md5 -q && git -C $R status --porcelain'
```
esperado: el commit toca 1 ruta, `docs/index.html`, con md5 `7eb920d2…`; porcelain después: solo el LOG.
obtenido: `1633319 deploy(docs): motor s32 (teclado, plurales, definitivos 2025 y leyendas)`; `1` ruta; `docs/index.html`; `7eb920d25c44c3597f7a3a2fb9d0da4b`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `f5523f7`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `f5523f7` (hijo de `9185ec6` = `origin/main`); commits `f5523f7`, `c5ade2e`, `c549d53`, `584042f`, `1633319` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0 y en todos los builds (T1 temporal, las dos corridas de T2, T3); ciego a la fecha, ve una cifra plantada (M3) |
| R-03 | M5: dos textos del asterisco sin condición y uno condicionado; T1 condiciona los dos y deja el resto literal |
| R-04 | T1.1: el motor nuevo no explica el asterisco en el panorama (4b y 2m) ni en la ficha |
| R-05 | T1.2: con 2025 re-marcado como preliminar (copia plantada), los dos textos vuelven |
| R-06 | T1.3 = M6: el motor viejo explica el asterisco sin ningún asterisco en pantalla |
| R-07 | T1: con la condición verdadera, la glosa es idéntica a la original; con la condición falsa, es la original sin esa oración |
| R-08 | T2.1: dos `run_all()` seguidos dejan `censo_insumos.md` idéntico (`a3e7b96e…`); ningún otro derivado cambia |
| R-09 | T2.2/T2.3: el censo de `9185ec6` tiene hora y el nuevo no; única diferencia, la línea `- Fecha:` |
| R-10 | T3: motor `7eb920d2…`, build completo sin cambios en el porcelain |
| R-11 | T4 / 🔒5: `docs/index.html` = motor byte a byte; el commit toca solo `docs/index.html`; `docs/` antes `6c5feab5…` |
| R-12 | Testigo `check-row:focus-visible`: 0 en el `docs/` anterior, ≥ 1 en el nuevo |
| 🔒1–🔒5 | invariantes de §3 |
| ALC | alcance global ⊆ ALCANCE de T1–T4 + LOG + encargo + registro de errores |
| REG | PRUEBAS a, b y c sobre el estado final |

**Paso 2. Re-derivación independiente.**

Bloque estático (`/tmp/s32c_r_static.sh`: objetos de git en vez de archivos del árbol; `shasum -a 256` en vez de `md5`; `numstat`; `grep -o` en vez de `grep -c`):
```
bash /tmp/s32c_r_static.sh
```
esperado: R01 padre `9185ec6`, sesión `1633319 584042f c549d53 c5ade2e f5523f7`; R03 `0` leyendas sin condición, `1` con `hayPrelim &&`, `1` oración de la glosa condicionada; R03b `3 2`; R09 `1 1` y la línea quitada es `- Fecha: 2026-09-23 16:32:17`; R11 los tres SHA iguales; R11b solo `docs/index.html`, antes `6c5feab5…`; R12 `0` y `1`.
obtenido: `R01: padre_f5523f7=9185ec6 sesion=1633319 584042f c549d53 c5ade2e f5523f7`; `R03: … 1 … 'hayPrelim &&' 1; oraciones de la glosa condicionadas 2`; `R03b: 5 2`; `R09: 1 1 … ; lineas quitadas:` (vacío); `R11: docs 4de9c0045550dd31 motor 4de9c0045550dd31 ; objeto HEAD docs 4de9c0045550dd31`; `R11b: docs/index.html ; docs antes (584042f) 6c5feab5428ed05dff09867f2b47bba3`; `R12: anterior 0 ; nuevo 1`.
Tres discrepancias, las tres de instrumento o de redacción mía, no del trabajo: (1) R03: el primer conteo del script buscaba `…</span>}` (la forma **condicionada**), así que su etiqueta "sin condición" estaba mal puesta; y el esperado "1 oración condicionada" olvidó que la nota de barras (L1512, preexistente) usa el mismo patrón: `2` es lo correcto (la nueva de la glosa + la de la nota). (2) R03b: el diff de la plantilla es **+5/−2**, no "+3/−2" como escribí en la sección de T1 (línea "**Diff:** `+3/−2`"): corrección de ese texto, que no se reescribe (cinco líneas agregadas: comentario JSX, línea de la glosa, comentario JS, `hayPrelim`, línea de la leyenda; dos quitadas: las dos líneas originales). (3) R09: el `grep '^-[^-]'` no ve la línea quitada porque empieza con `-- Fecha`. Re-medición con el instrumento corregido (`/tmp/s32c_r_static2.sh`):
```
bash /tmp/s32c_r_static2.sh
```
esperado: leyenda: 1 aparición del `span`, y esa 1 precedida de `hayPrelim && `; glosa: 2 apariciones de "carácter preliminar", las 2 dentro de `anios.some(…)?"…"`; `5 / 2`; quitada `-- Fecha: 2026-09-23 16:32:17`, agregada `+- Fecha: la registra git …`.
obtenido: `R03 leyenda: … 1 ; precedida de 'hayPrelim && ' 1`; `R03 glosa: 'carácter preliminar' total 2 ; dentro de anios.some(...)?"…" 2`; `R03b: 5 / 2`; `R09 linea quitada: -- Fecha: 2026-09-23 16:32:17 ; agregada: +- Fecha: la registra git (el reporte no sella la hora del build)`. R03, R03b y R09 confirmados; las tres discrepancias quedan explicadas como errores propios de instrumento/redacción.

Navegador, otra vía (`/tmp/s32c_t1.js` en modo `html`, que busca los textos en `page.content()` además de la consulta por selector, sobre `docs/index.html` recién desplegado, la copia plantada y el motor viejo; y `/tmp/s32c_r_glosa.js`, que guarda el texto completo de la glosa de la ficha en los tres para compararlo con `diff`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in /Users/tomgc/Projects/slep_idps/docs/index.html /tmp/s32c_motor_t1_prelim.html /tmp/s32c_motor_fase0.html; do node /tmp/s32c_t1.js $m html | tr -d "\n " | grep -oE "\"(motor|errores|html_[a-z_]+|tiene_[a-z_]+)\":[^,}]*" | tr "\n" " "; echo; done; node /tmp/s32c_r_glosa.js; cmp -s /tmp/s32c_glosa_plantado.txt /tmp/s32c_glosa_viejo.txt && echo "plantado = viejo"; diff <(sed "s/El signo \* al lado del año indica el carácter preliminar de los resultados, según lo informado por la Agencia. //" /tmp/s32c_glosa_viejo.txt) /tmp/s32c_glosa_nuevo.txt && echo "nuevo = viejo sin la oración"'
```
esperado: `docs/index.html`: `html_resultado_preliminar` y `html_caracter_preliminar` `false` en panorama 4b, 2m y ficha, y los selectores `false`; plantado: todo `true`; viejo: todo `true`; 0 errores; `plantado = viejo`; `nuevo = viejo sin la oración`.
obtenido: selectores: `docs/index.html` `false`/`false`/`false`, plantado `true`×3, viejo `true`×3; 0 errores en los tres; `plantado = viejo`; `nuevo = viejo sin la oración` (R-07 confirmado: la glosa condicionada reproduce el texto original exacto cuando hay preliminar, y sin él solo cae esa oración). **Pero `html_resultado_preliminar` y `html_caracter_preliminar` dan `true` también en `docs/index.html`**: `page.content()` serializa el documento completo, **incluido el `<script type="text/babel">` con el código fuente JSX**, donde las dos cadenas siguen escritas (ahora dentro de la condición). El instrumento no discrimina (error propio de instrumento, detectado porque da lo mismo en el caso bueno y en el malo). Corrección: `/tmp/s32c_t1.js` en modo `html` serializa un clon del documento **sin los `<script>`** (y reporta aparte el crudo de `page.content()` para dejar el defecto a la vista). Re-medición:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; for m in /Users/tomgc/Projects/slep_idps/docs/index.html /tmp/s32c_motor_t1_prelim.html /tmp/s32c_motor_fase0.html; do node /tmp/s32c_t1.js $m html | tr -d "\n " | grep -oE "\"(motor|errores|html_[a-z_]+|crudo_[a-z_]+)\":[^,}]*" | tr "\n" " "; echo; done'
```
esperado: `docs/index.html`: `html_*` `false` en panorama 4b, 2m y ficha (`crudo_con_scripts` `true`: el código fuente); plantado y viejo: `html_*` `true`; 0 errores.
obtenido: `docs/index.html`: `html_resultado_preliminar: false`, `html_caracter_preliminar: false` en panorama 4b, 2m y ficha (`crudo_con_scripts: true`, el código fuente); plantado y viejo: panorama 4b y 2m `html_resultado_preliminar: true` / `html_caracter_preliminar: false`, ficha `false` / `true`; 0 errores. Mi esperado ("`html_*` `true`" en todas las vistas) era impreciso: cada vista tiene su propio texto (la leyenda en el panorama, la glosa en la ficha), y así sale. **R-04, R-05 y R-06 confirmados por HTML renderizado**, con el instrumento que ahora distingue el caso bueno del malo.

**Paso 3. Invariantes 🔒** (`/tmp/s32c_invariantes.sh`, comandos de §3; `<inicio>` = `f5523f7`):
```
bash /tmp/s32c_invariantes.sh
```
esperado: L1 `eb4e00b3…4dc4` en el motor y en `docs/`; L2a `63` líneas, `9842151d…` (= M4); L2b `0`; L3 `0`; L4 `0`; L5 los dos md5 `7eb920d2…` y `1` ruta.
obtenido: `L1: motor eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 ; docs eb4e00b3…4dc4` → **🔒1 PASA**; `L2a: lineas: 63; md5 9842151d897e8768abd2207513c6607b` y `L2b: 0` → **🔒2 PASA**; `L3: 0` → **🔒3 PASA**; `L4: 0` → **🔒4 PASA**; `L5: docs 7eb920d25c44c3597f7a3a2fb9d0da4b motor 7eb920d25c44c3597f7a3a2fb9d0da4b ; rutas del commit de despliegue 1` → **🔒5 PASA**.

**Pasos 4, 5 y 6** (`/tmp/s32c_final.sh`: alcance global con lista explícita y `grep -vxF`; regresión completa con `run_all()` **en el árbol**, que ahora no debe tocar nada, más `cmp` del censo contra el objeto de git de HEAD (re-derivación de R-08, que se midió con `md5` y `cmp` entre corridas); PRUEBAS b con los dos modales y una ficha; PRUEBAS c; y controles positivos de cada instrumento):
```
bash /tmp/s32c_final.sh
```
esperado: ALC 8 rutas, `0` fuera, porcelain solo el LOG. REGa `rc=0`, 0 warnings, 5 pasos, motor `7eb920d2…`, porcelain **solo el LOG** (el build completo no cambia nada versionado). R08 `IDENTICO`. REGb dos modales, 0 errores, 0 `pageerror`; ficha abierta, 0 errores. REGc `eb4e00b3…4dc4`. C1 ≥ 1; C2 `2`; C3 md5 distinto de `9842151d…`; C4 `1`; C5 md5 de `docs` plantado distinto del motor, y el deploy de s31c toca `1` ruta; C6 imprime `30_procesamiento/34_leer_normalizar_idps.R`; C7 distinto de `eb4e00b3…` (`1c3799e2…`).
obtenido: `ALC: rutas 5 ; fuera 0 ; porcelain [?? …s32c_log.md]` (mi esperado decía 8: el encargo y el registro de errores entraron en `f5523f7`, que es `<inicio>`, y el LOG todavía no está commiteado; las 5 son plantilla, `32_censo_insumos.R`, `censo_insumos.md`, motor y `docs/index.html`; error de cuenta del esperado, no del alcance) → **alcance PASA**. `REGa: rc=0 warn=0 pasos=5 motor=7eb920d25c44c3597f7a3a2fb9d0da4b porcelain [?? …s32c_log.md]` (el `run_all()` completo en el árbol ya no toca nada versionado). `R08: IDENTICO`. `REGb: modal_territorio true, modal_comparador true, consola_errores [], pageerror []`; ficha `glosa_existe: true`, `errores: []`. `REGc: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`. **Regresión PASA.** Controles: `C1: 87`; `C2: 2`; `C3: … md5 1d9d9396…` (≠); `C4: 1`; `C5: docs 12ff5b62… motor 7eb920d2…` (≠) y el deploy de s31c toca `1` ruta; `C6: 30_procesamiento/34_leer_normalizar_idps.R`; `C7: 1c3799e2e8e35da8` (≠). **Todos los instrumentos disparan.**

**Pasos 7-8. Veredicto y reparación.** 0 BLOQUEA (ningún 🔒 en FALLA, alcance respetado, payload intacto, despliegue fiel, historia lineal sobre `9185ec6`). 0 REPARA. Ciclos usados: 0 de 2.

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `log --format=%p`; `log 9185ec6..HEAD` | padre `9185ec6`; 5 commits | iguales | — | ninguna | — | — |
| R-02 | §8.2 constante | `/tmp/s32c_invariantes.sh` L1 sobre motor y `docs/` | `eb4e00b3…` | iguales | — | ninguna | — | C7 |
| R-03 | textos condicionados | `grep -o` sobre el objeto de git de HEAD | 1 leyenda con `hayPrelim &&`; 2 oraciones en `anios.some` | iguales | — | ninguna | — | — |
| R-04/05/06 | T1.1, T1.2, T1.3 | HTML renderizado sin `<script>` | nuevo sin textos; plantado y viejo con su texto por vista | iguales | — | ninguna | — | control implícito: plantado y viejo `true` |
| R-07 | glosa literal | `diff` del texto completo de la glosa | plantado = viejo; nuevo = viejo sin la oración | iguales | — | ninguna | — | — |
| R-08 | censo reproducible | `cmp` contra el objeto de git de HEAD tras un `run_all()` más | IDÉNTICO | IDÉNTICO | — | ninguna | — | — |
| R-09 | única diferencia del censo | `numstat` + `grep '^-- Fecha'` | 1/1; la línea de la hora | iguales | — | ninguna | — | — |
| R-10 | build limpio | `run_all()` completo en el árbol | porcelain solo el LOG | igual | — | ninguna | — | — |
| R-11 | despliegue fiel | `shasum -a 256` de docs, motor y objeto de HEAD; rutas del commit | iguales; 1 ruta | iguales (`4de9c004…`); 1 | — | ninguna | — | C5 |
| R-12 | testigo | `grep -o` sobre objetos de git | 0 → 1 | 0 → 1 | — | ninguna | — | — |
| A-1 | encabezado del censo desfasado | lectura de `32_censo_insumos.R` | — | el banner dice "27 tablas de datos" y hoy se perfilan 28 | ADVIERTE (preexistente, fuera de ALCANCE) | pendiente | — | — |
| A-2 | el despliegue lleva un cambio no revisado en el gate | orden de los hechos | — | `GATE APROBADO` se dio sobre el motor de s32b; T1 (leyendas) entró después y se desplegó sin gate visual propio | ADVIERTE (diseño del encargo) | revisar el sitio publicado | — | — |
| 🔒1–🔒5 | invariantes | `/tmp/s32c_invariantes.sh` | ver paso 3 | todos PASA | — | — | — | C1–C7 |
| ALC | alcance global | lista + `grep -vxF` | 0 fuera | 0 fuera (5 rutas) | — | — | — | C6 |
| REG | PRUEBAS a, b, c | `/tmp/s32c_final.sh` | `rc=0`, 0 warn, `7eb920d2…`; 0 errores; `eb4e00b3…` | iguales | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/0/2 (A-1 banner del censo desfasado, preexistente; A-2 el cambio de leyendas se desplegó sin gate visual propio).
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** (1) `/tmp/s32c_r_static.sh`: conteo de R03 con la etiqueta cambiada y `grep '^-[^-]'` que no ve `-- Fecha` (re-medidos con `/tmp/s32c_r_static2.sh`); (2) esperado de R03 sin contar la nota de barras; (3) la sección de T1 dice "Diff: +3/−2" y es +5/−2 (corregido en línea nueva); (4) `page.content()` incluye el código fuente JSX y no discriminaba (corregido: HTML renderizado sin `<script>`); (5) esperado del alcance "8 rutas" en vez de 5. Ninguno tocó un criterio ni la meta.

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 5 respecto de `origin/main`.
obtenido: `?? 50_documentacion/andamios/logs/20260923_leyendas_censo_despliegue_s32c_log.md` (única); `## main...origin/main [ahead 5]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s32c, lanzado con `GATE APROBADO`: leyendas del asterisco preliminar, censo sin hora y despliegue. Fases: FASE 0 (con el commit del encargo y la fila 4 del registro de errores), T1, T2, T3, T4, R y L. Estado del grafo: T1 completada (`c5ade2e`) · T2 completada (`c549d53`) · T3 completada (`584042f`) · T4 completada (`1633319`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Sin gates en la sesión.
2. **Commits** (`git log 9185ec6..HEAD --oneline`, antes del commit de este log):
   - `f5523f7` chore(encargo): s32c; docs(log): error #4 del asistente — FASE 0 (= `<inicio>`)
   - `c5ade2e` fix(motor): el asterisco solo se explica si hay año preliminar (s32c T1)
   - `c549d53` fix(pipeline): censo_insumos sin hora de build (s32c T2)
   - `584042f` build(motor): s32c leyendas del preliminar — motor `7eb920d25c44c3597f7a3a2fb9d0da4b`
   - `1633319` deploy(docs): motor s32 (teclado, plurales, definitivos 2025 y leyendas) — solo `docs/index.html`
   - (este log: `docs(log): s32c leyendas, censo y despliegue`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/2; reparados 0.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en FASE 0, en el build temporal de T1, en las dos corridas de T2, en T3, en `docs/` y en la regresión; C7 dispara) · 🔒2 PASA (`:root` `9842151d…`; 0 hex; C2/C3 disparan) · 🔒3 PASA (`0`; C4 dispara) · 🔒4 PASA (`0`; C1 dispara) · 🔒5 PASA (docs = motor `7eb920d2…`, `shasum` `4de9c004…` en los dos; commit de 1 ruta; C5 dispara). 5/5.
5. **Decisiones del titular en gates:** ninguna en la sesión; `GATE APROBADO` venía en el mensaje de lanzamiento (condición de T4).
6. **Estado de cifras:** hash §8.2 del payload `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en todos los builds (el encargo no toca datos). Motor `8428ea58…` (`e7848df`) → `7eb920d2…` (`584042f`). `docs/index.html` `6c5feab5428ed05dff09867f2b47bba3` (s31c) → `7eb920d25c44c3597f7a3a2fb9d0da4b` (= motor). `censo_insumos.md` `a3e7b96e9bd47ad7044619baba260fb7`, estable entre builds.
7. **Dudas y pendientes consolidados:**
   - A-1: el banner de `32_censo_insumos.R` dice "27 tablas de datos" y hoy se perfilan 28 (preexistente, fuera de ALCANCE). ¿Se corrige en un encargo de higiene? (sí/no). Bloquea: nada.
   - A-2: el despliegue incluye el cambio de leyendas de T1, posterior al gate visual aprobado. ¿El titular revisa en el sitio publicado que la vista histórica ya no muestra "* resultado preliminar" ni la oración del asterisco en la ficha? (sí/no). Bloquea: nada.
   - Siguen abiertos de s32b: D-1 (teclado del modal de territorio: el gate de hoy lo aprobó, así que la duda se puede cerrar si el titular lo confirma) y D-3 (chequeo de derivados al cierre). **D-2 de s32b queda cerrado por T2.**
   - **Testigo del despliegue:** `check-row:focus-visible` en el `index.html` publicado (`grep -c` → `1`; el publicado anterior daba `0`); y, en pantalla, ningún "2025*" ni "(preliminar)" en 2025.
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** (1) FASE 0: `sed` sin `g` al copiar el script del `:root` (corregido antes de M4). (2) FASE R: conteos de R03/R09 mal planteados en el primer script (re-medidos). (3) FASE R: esperado de R03 sin la nota de barras. (4) T1: el texto "Diff: +3/−2" era +5/−2 (corregido en línea nueva). (5) FASE R: `page.content()` incluye el código fuente JSX y no discriminaba (instrumento corregido). (6) FASE R: esperado del alcance "8 rutas" en vez de 5. Costo total: unos minutos; ninguno tocó un criterio, un esperado ya escrito ni la meta.
9. **Notas para el revisor:** (a) abrir el sitio publicado con recarga forzada (Cmd+Shift+R): GitHub Pages puede tardar unos minutos en servir `7eb920d2…`; (b) en la vista histórica del panorama, la leyenda termina en "sin medición nacional", y en la vista histórica de la ficha la glosa ya no menciona el asterisco; si algún día vuelve a haber un año preliminar, los dos textos reaparecen solos (verificado con una copia plantada); (c) la línea del censo quedó "- Fecha: la registra git (el reporte no sella la hora del build)"; (d) el comentario del script del censo va sin tildes porque el archivo es ASCII puro.
10. **Estado de cierre:** commiteados `f5523f7`, `c5ade2e`, `c549d53`, `584042f`, `1633319` y el commit `docs(log)`. **`docs/` desplegado**: `docs/index.html` = motor `7eb920d25c44c3597f7a3a2fb9d0da4b`. Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s32c_priv.sh`, adaptado de s32b: RUT con la expresión en una variable y un control plantado en un archivo aparte; "RBD" seguido de número; nombres de establecimiento; nombre de la estación):
```
bash /tmp/s32c_priv.sh
```
esperado: `0`; plantado `1`; `0`; `0`; `0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `estación por nombre: 0`.

Paso 5, primera medición (sin contar el par del paso 4): `### FASE` = 7 (FASE 0, T1, T2, T3, T4, R, L); `## J` = 1, relleno; **`^esperado:` = 18 y `^obtenido:` = 17**. Causa, leída línea a línea: al chequeo de alcance de T1 le faltó su `obtenido:` (la salida se usó para el commit, pero no se anotó). Se anexa con su estado real:
obtenido: (anexo, faltante, al chequeo de alcance de T1) ` M 30_procesamiento/35_motor_template.html`, ` M 40_salidas/motor_idps.html`, `?? 50_documentacion/andamios/logs/20260923_leyendas_censo_despliegue_s32c_log.md`; solo la plantilla se agregó al commit `c5ade2e` (`git show --name-only` lo confirma arriba).

Segunda medición:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260923_leyendas_censo_despliegue_s32c_log.md; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L)"; bash /tmp/s32c_priv.sh | head -1'
```
esperado: `FASE=7`; `esperado=20` y `obtenido=19` al medir (este par todavía sin su `obtenido:`); `J=1`; `RUT en el log: 0`.
obtenido: `FASE=7 esperado=20 obtenido=19 J=1`; `RUT en el log: 0`. Con esta línea, **20 = 20**.
