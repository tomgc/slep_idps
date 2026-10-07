# Log de sesión: contraste del texto sobre la paleta de indicador (§5.6, s32g)

- **Meta:** resolver las cuatro superficies de §5.6 de la decisión de contraste sin tocar las paletas: título "¿Qué mide este indicador?" en tinta con filete del color (opción B, decisión del titular) (T1); etiqueta de `DistBar` por la regla de mayor contraste (T2); glifos y tendencia de la vista histórica con tokens `-txt` (T3); línea "vs GSE" del tooltip en blanco (T4); enmienda de §5.6 (T5); build (T6). Sin despliegue.
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `e96ef6a` (= `origin/main` tras el push de s32f). Primer acto (autorizado): commit `8fd08b0` chore(encargo): s32g y mockup §5.6, hijo de `e96ef6a` (el encargo y `50_documentacion/andamios/diseno/detalles/mockup_contraste_paleta_indicador_s56.html`). **PUNTO DE RETORNO `<inicio>` = `8fd08b0`.** Porcelain, stash y `rev-parse` se miden en M1/M2.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); R 4.5.2 con `renv`; `bash` 3.2 explícito (toda expresión con `{m,n}` va en un script); `Rscript` para R; `node` + Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), esfuerzo `xhigh`, sin `ultracode`; **sin subagentes**, en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_contraste_paleta_indicador_s32g.md` (commit `8fd08b0`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (título, opción B) → T2 (etiqueta de DistBar) → T3 (glifos y tendencia) → T4 (línea del tooltip)
   ALCANCE de las cuatro: 30_procesamiento/35_motor_template.html; un commit por tarea
T5 (enmienda de la decisión de contraste)  ALCANCE: 50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md; requiere T1–T4 cerradas
T6 (build)                                  ALCANCE: 40_salidas/motor_idps.html; requiere al menos una de T1–T4
FASE R y FASE L                             fuera del grafo, corren siempre
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** en `/tmp/s32g_*`; se copian de los de s32–s32f cuando sirven.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: las cuatro superficies de §5.6 pasan 4,5 sin tocar las paletas. Los títulos del indicador dan 13,50 ×4, con filete del color (opción B). En `DistBar`, el mínimo es 4,74 (el alto de Clima, 5,95 en negro). Glifos y tendencia de la vista histórica ≥ 5,00. La línea "vs GSE" del tooltip da 13,50 → cumplida.
- Estado por tarea: FASE 0 completada · T1 completada (`8e92f7b`) · T2 completada (`5e006f2`; comentario reparado en `5be8e32`) · T3 completada (`2029e7d`) · T4 completada (`52430b6`) · T5 completada (`641cf67`) · T6 completada (`4a36346`; motor final en `5be8e32`) · FASE R completada (1 reparación) · FASE L completada.
- Commits: 9, rango `8fd08b0`..`<docs(log)>` (`git log --oneline e96ef6a..HEAD`), de los cuales 1 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/1/4. Reparado 1: R-11, un hex literal en un comentario de T2, que 🔒2 cuenta. Abiertos 4, como nota o duda: D-1 `_txtOn` sin uso; A-1 encabezado de §5 desactualizado; A-2 premisa 4,75 vs 4,74; A-3 `const col` sin uso.
- Invariantes: 6/6 PASA. 🔒1: §8.2 `eb4e00b3…` en todos los builds. 🔒2: sobre las declaraciones del `:root` (gate H-1), con 0 hex en líneas agregadas tras R-11 (la primera medición dio 1). 🔒3: sobre líneas cambiadas (gate H-2). FALLA: ninguno.
- Cifras críticas: intactas. Evidencia: hash §8.2 igual en FASE 0, en T1 a T4, en T6, en R-11 y en la regresión; el `run_all()` completo deja el árbol limpio.
- Decisiones autónomas de mayor riesgo: (1) `DistBar` aplica `vtTexto` solo a tonos hex y deja heredar a los `var(--…)`, como antes; (2) `const col` del tooltip se conserva sin uso para no tocar una línea que lee `sigdifgru`; (3) la tendencia se mide sobre su fondo real (blanco), y las clases ausentes en la ficha se verifican en R.
- Desviaciones respecto del encargo: 🔒2 se midió sobre las declaraciones (H-1) y 🔒3 con `-U0` (H-2), ambas por decisión del titular en gate; ninguna en el grafo ni en las autorizaciones.
- Dudas abiertas: 3: D-1 ¿se retira `_txtOn`?; A-1 ¿se actualiza el encabezado de §5?; A-3 ¿se retira `const col`? (sí/no cada una).
- Errores propios: 3. (1) R-11, hex en un comentario de T2, reparado en el ciclo 1. (2) Un esperado de L2b medido antes del commit. (3) El formato `obtenido (…)` en M5, anexado. Costo: un gate y un ciclo de reparación, unos 15 minutos.
- Qué debe verificar el revisor por sí mismo: el gate visual del título con filete en los cuatro indicadores, de la barra de niveles de Clima, de los glifos de la vista histórica y del tooltip. Esta sesión midió colores computados y ratios, no la percepción.
- No publicado / queda al usuario: el despliegue a `docs/` tras el gate visual (testigo "opción B de §5.6"). El push se hace según la condición del encargo; resultado en el reporte final.
- Ejecución: esfuerzo xhigh en solo, sin ultracode; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `8fd08b0` (primer acto).

**M1 a M4** (instrumentos copiados de s32e: `/tmp/s32g_payload_sha.sh` → `/tmp/s32g_payload_norm.js`, `/tmp/s32g_fecha_alterada.js`, `/tmp/s32g_plantar_payload.js`, `/tmp/s32g_root_md5.sh`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) padre=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"; M=$R/40_salidas/motor_idps.html; cp $M /tmp/s32g_motor_fase0.html; md5 -q $M; bash /tmp/s32g_payload_sha.sh /tmp/s32g_motor_fase0.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s32g_fecha_alterada.js /tmp/s32g_motor_fase0.html /tmp/s32g_motor_fecha.html; bash /tmp/s32g_payload_sha.sh /tmp/s32g_motor_fecha.html | grep -o "sha256_norm\":\"[0-9a-f]*"; node /tmp/s32g_plantar_payload.js /tmp/s32g_motor_fase0.html /tmp/s32g_motor_plantado.html; bash /tmp/s32g_payload_sha.sh /tmp/s32g_motor_plantado.html | grep -o "sha256_norm\":\"[0-9a-f]*"; bash /tmp/s32g_root_md5.sh $R/30_procesamiento/35_motor_template.html; cp /tmp/s32g_root_block.txt /tmp/s32g_root_block_fase0.txt'
```
esperado: M1 solo este LOG, stash vacío; M2 `HEAD=8fd08b0`, padre `e96ef6a` = `origin/main`, `0`, `1`; M3 motor `fd091622…` (`da2d7ac`), §8.2 `eb4e00b3…4dc4`, igual con la fecha alterada, distinto con la cifra plantada; M4 `:root` un md5 (se espera el de siempre, `63` líneas y `9842151d…`).
obtenido: M1 `?? 50_documentacion/andamios/logs/20260923_contraste_paleta_indicador_s32g_log.md` (única), `stash: []`; M2 `fetch rc=0`, `HEAD=8fd08b0 padre=e96ef6a origin/main=e96ef6a`, `HEAD..origin/main=0 origin/main..HEAD=1`; M3 motor `fd09162250e17481af5014b58fa824f8`, §8.2 **`eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`**, fecha alterada igual, plantado `1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); M4 `lineas: 63; md5 9842151d897e8768abd2207513c6607b`. Reglas 1 y 2 no disparan; valores de 🔒1 y 🔒2.

**M7** (lectura del código):
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -n "_txtOn\|const contrasteWCAG\|const _lumWCAG\|function vtTexto\|const vtGris" $T'
```
esperado: `vtTexto` y `contrasteWCAG` a nivel de módulo, invocables en render.
obtenido: `function vtTexto(bg)` (L2644), `const contrasteWCAG` (L2634), `const _lumWCAG` (L2632) y `const vtGris` (L2629) están al **nivel superior** del script Babel (fuera de todo componente), igual que `DistBar` (L996); `vtTexto` es una declaración de función (izada) y las constantes ya están inicializadas cuando React dibuja, así que `DistBar` puede llamar a `vtTexto` en render sin moverlo. `_txtOn` (L1157) tiene **un solo uso**, `DistBar` (L1000) (más una mención en el comentario de L2631): tras T2 queda sin uso (se conserva con un comentario, como pide el encargo). Detalle para T2: `nivelRamp` devuelve `var(--bajo/medio/alto)` si el color no es hex, y hoy `_txtOn` devuelve `undefined` en ese caso (hereda el color); T2 conserva ese comportamiento para los no hex.
**Hallazgo de lectura H-1 (conflicto interno del encargo):** el comentario de inventario de usos de los tokens `-txt` que T3 manda actualizar vive **dentro** del bloque `:root{…}` (L39-44; el bloque va de L9 a L71), y 🔒2 exige que el md5 del `:root` (el mismo `awk` de s32, que incluye los comentarios) quede **igual**. Hacer lo que pide T3 cambia ese md5 y deja 🔒2 en FALLA; cumplir 🔒2 obliga a omitir parte de T3. Se lleva al titular como gate antes de T3 (T1, T2 y T4 no tocan el `:root`).

**M5 y M6** (instrumento `/tmp/s32g_contraste.js`: colores **computados** con `getComputedStyle`; fondo efectivo compuesto por capas —ancestros hasta el primer fondo opaco, o la pila de `document.elementsFromPoint` en el centro del texto para `.ybar-sig` y `.hist-trend`, porque la cifra de la barra se pinta 19 px **encima** de su barra, fuera de la caja de su padre, sobre el track—; fórmula WCAG 2.1; calibración con dos pares conocidos; abre la ficha del primer establecimiento del SLEP foco en 4b 2025 que tiene ≥ 9 % en el nivel alto de alguna subdimensión de Clima, mide en la vista actual y en la histórica, y fuerza el tooltip con `mousemove` sobre las barras del panel principal hasta que aparece "vs GSE"):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32g_contraste.js /tmp/s32g_motor_fase0.html > /tmp/s32g_m5.json'
```
esperado: **M6** `21.00` y `4.48`. **M5** (± 0,05 respecto de §1): `.defn-title` Autoestima 6,79, Clima 2,19, Participación 3,07, Hábitos 1,84; etiqueta de `DistBar` en el alto de Clima (`#4c939a`, texto `#ffffff`) 3,53; `.ybar-sig` y `.hist-trend` < 4,5 en cada clase presente (§1: 3,20 / 3,78 / 3,23 sobre el track); línea "vs GSE" del tooltip < 4,5 (3,88 / 3,28 / 3,85 sobre `#23303a`); 0 errores.
obtenido (`/tmp/s32g_m5.json`, `rc=0`, 0 errores): **M6** `negro_blanco 21`, `gris777_blanco 4.48` → instrumento confiable. Establecimiento: 56 candidatos del foco con ≥ 9 % en el alto de Clima; se abre el primero (sin RBD en el log). **M5:**
- `.defn-title` del indicador (con `style="color: …"`): Autoestima `#3858a3`/`#ffffff` **6,79**; Clima `#61bdc6` **2,19**; Participación `#4ba560` **3,07**; Hábitos `#aacb58` **1,84**; sin filete (`0px none`). Los 11 títulos "Sobre esta dimensión" (sin `color`): `#23303a` sobre blanco, 13,50, sin filete.
- `DistBar`: 57 segmentos con etiqueta; mínimo **3,53**; 5 bajo 4,5, todos del alto de Clima (`#ffffff` sobre `#4c939a`, 3,53).
- Los 12 tonos de `nivelRamp` con la regla actual (`_txtOn`) y con `vtTexto`: el único que falla hoy es Clima alto (`#ffffff`, 3,53); con `vtTexto` el más bajo es Participación alto (`#ffffff` sobre `#3b814b`, 4,74) y Clima alto pasa a `#000000`, **5,95**; máximo 15,09 (Hábitos bajo).
- `.ybar-sig` (91 en la vista histórica): `.al` `#ee2d49` sobre `#f6f5f6` (track) **3,79**; `.nt` `#7e8a99` **3,24**; `.de`: no presente en este establecimiento.
- `.hist-trend`: `.nt` `#7e8a99` sobre `#ffffff` (cabecera del bloque) **3,51**; `.de` y `.al`: no presentes.
- Tooltip, línea "vs GSE: ▼ -2 · n.s." con `style="color:var(--st-neutro)"`: `#7e8a99` sobre `#23303a` **3,85**.
Todo coincide con §1 dentro de ± 0,05 (3,79 vs 3,78; 3,24 vs 3,23); la tendencia se mide sobre su fondo real (blanco, 3,51), no sobre el track que suponía §1: también < 4,5. Ninguna cifra ya cumple; ninguna tarea se congela por M5. Las clases ausentes (`.ybar-sig.de`, `.hist-trend.de/.al`) se cubren en FASE R (recalculadas en R sobre los colores computados de los tokens).

**Gate del titular (H-1):** eligió **"🔒2 sobre las declaraciones"**. T3 se hace completa (con el comentario de inventario, que vive en el `:root`); 🔒2 se mide sobre las **declaraciones** del `:root` (el bloque del mismo `awk` sin comentarios `/* … */` ni líneas vacías), y además FASE R verifica que el diff dentro del `:root` toque solo líneas de comentario. Registrado como decisión del gate; el conflicto queda como error de redacción del encargo.

**Instrumento nuevo de 🔒2** (`/tmp/s32g_root_decl.sh`) con su línea base y calibración:
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; bash /tmp/s32g_root_decl.sh $T /tmp/s32g_root_decl_fase0.txt; sed "s/--foco:#0062A0;/--foco:#0062A1;/" $T > /tmp/s32g_tpl_plantado_root.html; bash /tmp/s32g_root_decl.sh /tmp/s32g_tpl_plantado_root.html /tmp/s32g_root_decl_plantado.txt; perl -0777 -pe "s{(Si se agrega un uso, se agrega aqui\.)}{\$1 PLANTADO}" $T > /tmp/s32g_tpl_plantado_coment.html; bash /tmp/s32g_root_decl.sh /tmp/s32g_tpl_plantado_coment.html /tmp/s32g_root_decl_coment.txt'
```
esperado: (propio) un md5 de línea base; con un valor de token plantado, **otro** md5; con un comentario plantado, el **mismo**.
obtenido: línea base `declaraciones: 21 lineas; md5 182334759a58462f381f12063ca2cb75` (0 asteriscos: ningún resto de comentario); plantado en `--foco` → `b86e23936f4bdc08441cf516308de91f` (**distinto**); plantado en el comentario del inventario → `182334759a58462f381f12063ca2cb75` (**igual**). El instrumento separa valores de comentarios. Valor del 🔒2 (declaraciones): `18233475…`; el md5 completo `9842151d…` se sigue registrando, y cambiará solo por el comentario de T3.

- **Estado de FASE 0:** completada, con un gate del titular (H-1). M1–M7 coinciden con su esperado. Ninguna tarea congelada.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `8fd08b0` (hijo de `e96ef6a` = `origin/main`).
- **Subagentes:** sin subagentes.
- **Errores propios:** ninguno.

### FASE T1: título en tinta con filete del color (opción B)

- **Paso 0:** `Definicion` (L864-871) pinta el título con `style={color?{color}:undefined}`; `.defn-title` (L181) ya declara `color:var(--tinta)`. Solo el título del indicador recibe `color` (L1394, `color={ind.color}`); el de dimensión (L1365, "Sobre esta dimensión") no.
- **Implementación:** el `style` del título pasa de `{color}` a `{borderLeft:"4px solid "+color, paddingLeft:7}` cuando hay `color` (sin hex nuevos: el color es la prop); el texto hereda `--tinta` de la clase. Comentario pedido: "s32g: opción B de §5.6 (titular); el color del indicador pasa del texto al filete". El comentario de cabecera de `Definicion` que decía "en el color del indicador" se ajusta a "con un filete del color del indicador".
- **Diff:** `+4/−3` en la plantilla (cabecera de `Definicion`, comentario JSX y el `style` del título).
- **Verificación** (`/tmp/s32g_t1.sh t1`: build temporal con `run_all(only = 35L)`, md5, §8.2 y el instrumento de M5 sobre el motor temporal):
```
bash /tmp/s32g_t1.sh t1
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…`. **T1.1** los cuatro títulos del indicador en `#23303a` sobre blanco, 13,50 (≥ 4,5). **T1.2** cada uno con `border-left` `4px solid` en el `ind.color` de su indicador (`rgb(56, 88, 163)`, `rgb(97, 189, 198)`, `rgb(75, 165, 96)`, `rgb(170, 203, 88)`) y `padding-left` `7px`. **T1.3** los títulos "Sobre esta dimensión" iguales a M5 (`#23303a`, 13,50, `0px none`, sin `padding-left`). **T1.4** = M5 (2,19 / 3,07 / 1,84). El resto de las superficies, sin cambio respecto de M5; 0 errores.
obtenido: `rc=0 warn=0`; motor temporal `09c2d0365d8e81c060ed70f390c381d7`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3); 0 errores. **T1.1:** los cuatro títulos del indicador `#23303a` sobre `#ffffff`, **13,50**. **T1.2:** `border-left` `4px solid rgb(56, 88, 163)` (Autoestima), `rgb(97, 189, 198)` (Clima), `rgb(75, 165, 96)` (Participación), `rgb(170, 203, 88)` (Hábitos); `padding-left` `7px`. **T1.3:** "Sobre esta dimensión": `#23303a`, 13,50, `0px none`, `padding-left 0px` (igual que M5). **T1.4** = M5. Sin cambio en las otras superficies (DistBar mín. 3,53; glifos 3,79/3,24; tendencia 3,51; tooltip 3,85).
- **Regresión:** build `rc=0`, 0 warnings; ficha en vista actual e histórica, sin errores.
- **Chequeo de alcance:** porcelain = ` M` plantilla (ALCANCE de T1), ` M` motor (temporal; va en T6) y el LOG. Solo la plantilla se agrega.
- **Commit:** `8e92f7b` fix(motor): título de indicador en tinta con filete del color (s32g T1, opción B). `git show --name-only HEAD` = la plantilla.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: la etiqueta de `DistBar` usa la regla de mayor contraste

- **Paso 0:** M7 (llamable en render); `DistBar` (L997-1002) pinta la etiqueta con `_txtOn(c)`; los tonos vienen de `nivelRamp` (hex) o de `var(--bajo/medio/alto)` si el color no es hex.
- **Implementación:** `color:(c&&c[0]==='#')?vtTexto(c):undefined` (mismo comportamiento de herencia para los no hex), con un comentario de tres líneas. `_txtOn` queda **sin uso**: se conserva con un comentario ("SIN USO desde T2 … puede retirarse (duda al titular)") y se corrige el comentario de `contrasteWCAG`, que decía que `_txtOn` "sigue sirviendo a DistBar". **Duda D-1.** Diff `+7/−2`.
- **Instrumento, ampliado antes de verificar:** la salida de `DistBar` agrega la lista `title|texto` de cada segmento con etiqueta, para comparar T2.2 contra el motor de FASE 0 (que se re-mide con el mismo instrumento).
- **Verificación:**
```
bash -c 'bash /tmp/s32g_t1.sh t2; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32g_contraste.js /tmp/s32g_motor_fase0.html > /tmp/s32g_m5b.json'
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…`. **T2.1** los 12 tonos con el color que elige `vtTexto`: todos ≥ 4,5 (mín. 4,74, Participación alto con blanco; Clima alto con `#000000`, 5,95); en la ficha, 0 etiquetas bajo 4,5 y las del alto de Clima en `#000000`, 5,95. **T2.2** la lista `title|texto` de los segmentos idéntica a la del motor de FASE 0. **T2.3** = M5 (3,53, 5 bajo 4,5). T1 sigue igual (13,50); 0 errores.
obtenido: `rc=0 warn=0`; motor temporal `3a8932a134d7a6ef328dd31e9d4ac701`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; 0 errores en las dos corridas. **T2.1:** con `vtTexto`, mínimo de los 12 tonos **4,74** (Participación alto, `#ffffff` sobre `#3b814b`, el único bajo 5); Clima alto `#000000` **5,95**; en la ficha, 57 etiquetas, mínimo 4,74, **0 bajo 4,5**, las 5 del alto de Clima en `#000000`, 5,95. **T2.2:** la lista `title|texto` de los 57 segmentos es **idéntica** a la del motor de FASE 0. **T2.3** (motor de FASE 0, re-medido): 57 etiquetas, mínimo 3,53, 5 bajo 4,5. T1 sigue en 13,50.
- **Regresión:** build `rc=0`, 0 warnings; ficha sin errores.
- **Chequeo de alcance:** porcelain = ` M` plantilla, ` M` motor (temporal) y el LOG. Solo la plantilla se agrega.
- **Commit:** `5e006f2` fix(motor): etiqueta de DistBar por mayor contraste (s32g T2). `git show --name-only HEAD` = la plantilla.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T3: glifos de la vista histórica y tendencia con tokens de texto

- **Implementación:** `.ybar-sig.de/.al/.nt` y `.hist-trend.de/.al/.nt` pasan a `var(--destaca-txt)`, `var(--alerta-txt)` y `var(--st-neutro-txt)`; el comentario de inventario de usos de los tokens `-txt` del `:root` suma los dos selectores (cinco usos → siete). Diff `+6/−4`.
- **🔒2 inmediato** (gate H-1):
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; bash /tmp/s32g_root_decl.sh $T /tmp/s32g_root_decl_t3.txt; bash /tmp/s32g_root_md5.sh $T'
```
esperado: declaraciones `18233475…` (= FASE 0); md5 completo distinto de `9842151d…` (cambió solo el comentario).
obtenido: `declaraciones: 21 lineas; md5 182334759a58462f381f12063ca2cb75` (**igual**); md5 completo `lineas: 65; md5 04b2876e2bcece41f09398f28f6fc41d` (65 líneas: el comentario creció 2).
- **Instrumento, ampliado antes de verificar:** para T3.2, la lista `clase|glifo|title` de todos los `.ybar-sig` y `clase|texto|title` de todos los `.hist-trend`, y el mínimo de contraste de los primeros 40 `.ybar-sig`.
- **Verificación:**
```
bash -c 'bash /tmp/s32g_t1.sh t3; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32g_contraste.js /tmp/s32g_motor_fase0.html > /tmp/s32g_m5c.json'
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…`. **T3.1** cada clase presente ≥ 4,5 sobre su fondo efectivo (§1: 5,00 / 5,16 / 5,06 sobre el track; la tendencia, sobre blanco, algo más); mínimo de los `.ybar-sig` medidos ≥ 4,5. **T3.2** las listas `clase|glifo|title` y `clase|texto|title` idénticas a las del motor de FASE 0 (re-medido). **T3.3** = M5 (3,79 / 3,24; 3,51). T1 y T2 siguen; 0 errores.
obtenido: `rc=0 warn=0`; motor temporal `0783062ec1c9b5686c3e56903fb5a2fc`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; 0 errores. **T3.1:** `.ybar-sig.al` `#ce112c` sobre `#f6f5f6` **5,18** (antes 3,79); `.ybar-sig.nt` `#5f6a78` **5,07** (antes 3,24); mínimo de los 40 primeros `.ybar-sig` **5,07** (antes 3,24); `.hist-trend.nt` `#5f6a78` sobre `#ffffff` **5,50** (antes 3,51); `.ybar-sig.de`, `.hist-trend.de/.al`: no presentes en este establecimiento (se recalculan en R en FASE R). **T3.2:** las 91 entradas `clase|glifo|title` de `.ybar-sig` y las 15 `clase|texto|title` de `.hist-trend` **idénticas** a las del motor de FASE 0. **T3.3** = M5. T1 13,50; T2 mín. 4,74; tooltip sin cambio (3,85).
- **Regresión:** build `rc=0`, 0 warnings; vista histórica sin errores.
- **Chequeo de alcance:** porcelain = ` M` plantilla, ` M` motor (temporal) y el LOG. Solo la plantilla se agrega.
- **Commit:** `2029e7d` fix(motor): glifos y tendencia de la vista histórica con tokens de texto (s32g T3). `git show --name-only HEAD` = la plantilla.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T4: la línea "vs GSE" del tooltip en blanco

- **Paso 0:** el constructor del tooltip (`BarrasAnio`, dentro de `onMouseMove` de `.ybar-fill`) arma `const gl=…`, `const col=p.sigdifgru===1?"var(--destaca)":…` y `const sg=(p.sigdifgru===1||p.sigdifgru===-1)?"· sig.":"· n.s."`, y luego `h += "<br><span style='color:"+col+"'>vs GSE: …</span>"`.
- **Implementación:** solo la línea `h += …` cambia: `<span>` sin `style` (hereda el blanco de `.tt`), con el comentario pedido y una segunda línea que dice que `col` ya no pinta el texto. **Decisión D-A1:** la línea `const col=p.sigdifgru…` **no se borra aunque queda sin uso**, para no modificar ninguna línea que lea `sigdifgru` (🔒3).
- **Hallazgo H-2 (antes de verificar):**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && git diff -- 30_procesamiento/35_motor_template.html | grep -n sigdifgru; git diff -U0 -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru'
```
esperado: (propio) el comando de 🔒3 da `0`: el cambio no toca ninguna línea con `sigdifgru`.
obtenido: el comando de 🔒3 (`git diff … | grep -c sigdifgru`) cuenta **2**: son las dos líneas de **contexto** del diff (`const col=p.sigdifgru…` y `const sg=(p.sigdifgru…`, con prefijo de espacio, sin cambios), que `git diff` imprime por defecto porque quedan a menos de 3 líneas de la línea cambiada; con `-U0` (solo líneas cambiadas) el conteo es `0`. Al pie de la letra, 🔒3 queda en FALLA y la regla 4 congelaría T4, aunque ninguna lectura de `sigdifgru` cambió. Se lleva al titular como gate.

**Gate del titular (H-2):** eligió **"🔒3 sobre líneas cambiadas"**. Desde aquí 🔒3 se mide con `git diff -U0 <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`, y se reporta también el conteo literal, con el contexto explicado. T4 sigue; `const col` queda intacta.
- **Verificación:**
```
bash /tmp/s32g_t1.sh t4
```
esperado: `rc=0`, 0 warnings; §8.2 `eb4e00b3…`. **T4.1** la línea "vs GSE" del tooltip sin `style`, color computado `rgb(255, 255, 255)`, **13,50** sobre `#23303a`. **T4.2** el texto de la línea idéntico al de FASE 0 (`vs GSE: ▼ -2 · n.s.`, la misma barra del mismo establecimiento). **T4.3** = M5 (3,85). T1 a T3 siguen; 0 errores.
obtenido: `rc=0 warn=0`; motor temporal `12c8cebd6cb336d1cadb9abb41f455dd`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; 0 errores. **T4.1:** línea `vs GSE: ▼ -2 · n.s.`, `style: null`, color computado `rgb(255, 255, 255)`, `#ffffff` sobre `#23303a` **13,50**. **T4.2:** texto idéntico al de FASE 0 (`true`). **T4.3:** FASE 0 `style="color:var(--st-neutro)"`, `#7e8a99`, 3,85. T1 13,50; T2 mín. 4,74; T3 glifos mín. 5,07, tendencia 5,50.
- **Regresión:** build `rc=0`, 0 warnings; ficha histórica y tooltip sin errores.
- **Chequeo de alcance:** porcelain = ` M` plantilla, ` M` motor (temporal) y el LOG. Solo la plantilla se agrega.
- **Commit:** `52430b6` fix(motor): línea vs GSE del tooltip en blanco (s32g T4). `git show --name-only HEAD` = la plantilla.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T5: enmienda de la decisión de contraste

- **Implementación:** título de §5.6 → "RESUELTO el 2026-09-23 (s32g)"; al final de la sección (antes de "## 6. Reversión"), el bloque "#### Resuelto el 2026-09-23 (s32g)": ruta del mockup y del log; opción B; corrección de la premisa sobre `#4C939A` (el negro da 5,95; la regla de §3.5 lo resuelve sin extender §3.4); tokens `-txt` en `.ybar-sig` y `.hist-trend` (inventario: siete usos); tooltip en blanco; y la tabla antes/después con las cifras **copiadas de este log** (M5, T1.1, T2.1, T3.1, T4.1). Las clases no presentes (`.ybar-sig.de`, `.hist-trend.de/.al`) se remiten a FASE R. Ninguna tarea quedó congelada, así que toda la sección se marca resuelta.
- **Verificación:**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; D=50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md; git diff --stat -- $D; git diff -- $D | grep -cE "^-[^-]"; git diff -U0 -- $D | grep "^@@"'
```
esperado: 1 archivo; una sola línea quitada (el título de §5.6, reemplazado); el resto, texto agregado al final de §5.6.
obtenido: `1 file changed, 44 insertions(+), 1 deletion(-)`; `1` (la línea del título); hunks `@@ -452 +452 @@` (título) y `@@ -536,0 +537,43 @@` (bloque nuevo, al final de §5.6). **Advertencia A-1:** el encabezado de §5 (L190, "…§5.2 y §5.6 abiertos") queda desactualizado, porque el encargo solo autoriza cambiar el título de §5.6.
- **Regresión:** T5 no toca código.
- **Chequeo de alcance:** porcelain = ` M` decisión (ALCANCE de T5), ` M` motor (temporal, T6) y el LOG. Solo la decisión se agrega.
- **Commit:** `641cf67` docs(decision): §5.6 resuelta (s32g). `git show --name-only HEAD` = la decisión.
- **Estado:** completada.
- **Subagentes:** sin subagentes.

### FASE T6: build

- **Pasos 1 a 3** (PRUEBAS a con el pipeline completo; PRUEBAS b: ficha en vista actual e histórica y `mousemove` sobre una barra histórica con `/tmp/s32g_contraste.js`, que además repite T1.1–T4.1; una comparación armada con `/tmp/s32d_cmp.js`; testigo):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32g_run_t6.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32g_run_t6.log; grep -c "Paso 3[1-5] OK" /tmp/s32g_run_t6.log; git -C $R status --porcelain; M=$R/40_salidas/motor_idps.html; md5 -q $M; bash /tmp/s32g_payload_sha.sh $M | grep -o "sha256_norm\":\"[0-9a-f]*"; export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32g_contraste.js $M > /tmp/s32g_t6.json; node /tmp/s32d_cmp.js $M 1280 - base | grep -oE "\"(errores|desbordadas)\":[^]},]*[]]?" | tr "\n" " "; echo; grep -c "opción B de §5.6" $M; grep -c "opción B de §5.6" $R/docs/index.html'
```
esperado: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`, 0 warnings, 5 pasos; porcelain después, el mismo; motor `12c8cebd…` (= build temporal de T4; T5 no tocó código); §8.2 `eb4e00b3…`; T1.1 13,50 ×4 con filete; T2.1 mín. 4,74, 0 bajo 4,5; T3.1 5,18/5,07 y 5,50; T4.1 blanco, 13,50; comparación sin errores ni desbordes; 0 errores; testigo `1` en el motor y `0` en `docs/index.html`.
obtenido: porcelain antes ` M 40_salidas/motor_idps.html` + LOG; `rc=0`; `0`; `5`; porcelain después, el mismo; motor `12c8cebd6cb336d1cadb9abb41f455dd` (= T4); §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (= M3, 🔒1); calibración 21 / 4,48; T1.1 13,50 en los cuatro títulos, filete de 4 px; T2.1 mín. 4,74, 0 bajo 4,5 (12 tonos, mín. 4,74); T3.1 `.al` 5,18, `.nt` 5,07, mín. de glifos 5,07, tendencia 5,50; T4.1 `rgb(255, 255, 255)`, 13,50, `vs GSE: ▼ -2 · n.s.`; comparación a 1280 px 0 errores, 0 desbordes; 0 errores en la ficha. **Testigo:** "opción B de §5.6" → `1` en el motor, `0` en `docs/index.html`.
- **Paso 4 (commit):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R add 40_salidas/motor_idps.html && git -C $R commit -q -m "build(motor): s32g contraste sobre la paleta de indicador" && git -C $R log -1 --format="%h %s" && git -C $R show --name-only --format= HEAD && git -C $R show HEAD:40_salidas/motor_idps.html | md5 -q && git -C $R status --porcelain'
```
esperado: commit con solo el motor (`12c8cebd…`); porcelain después: solo el LOG.
obtenido: `4a36346 build(motor): s32g contraste sobre la paleta de indicador`; `40_salidas/motor_idps.html`; `12c8cebd6cb336d1cadb9abb41f455dd`; porcelain: solo el LOG.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario** (anexado antes de auditar; `<inicio>` = `8fd08b0`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno `8fd08b0` (hijo de `e96ef6a` = `origin/main`); commits `8fd08b0`, `8e92f7b`, `5e006f2`, `2029e7d`, `52430b6`, `641cf67`, `4a36346` |
| R-02 | Hash §8.2 `eb4e00b3…` en FASE 0 y en los builds de T1, T2, T3, T4 y T6 (M3) |
| R-03 | M6: calibración 21,00 y 4,48 |
| R-04 | M5 / T1.4: títulos 6,79 / 2,19 / 3,07 / 1,84 → T1.1 13,50 ×4 con filete del `ind.color` (T1.2); dimensión sin cambio (T1.3) |
| R-05 | M5 / T2.3: `DistBar` alto de Clima 3,53 → T2.1 5,95 con negro; 12 tonos ≥ 4,5 (mín. 4,74); `title` sin cambio (T2.2) |
| R-06 | M5 / T3.3: `.ybar-sig.al/.nt` 3,79 / 3,24 → 5,18 / 5,07; `.hist-trend.nt` 3,51 → 5,50; glifos, textos y `title` sin cambio (T3.2); clases `.de` y `.hist-trend.al` no presentes |
| R-07 | M5 / T4.3: tooltip 3,85 → blanco 13,50; texto idéntico (T4.2) |
| R-08 | M7: `vtTexto`/`contrasteWCAG` a nivel de módulo; `_txtOn` sin uso tras T2 |
| R-09 | T5: diff de la decisión = título de §5.6 + bloque al final |
| R-10 | T6: build completo sin cambios en derivados; motor `12c8cebd…`; testigo 1 en el motor y 0 en `docs/` |
| 🔒1–🔒6 | invariantes de §3 (🔒2 sobre las declaraciones del `:root`, gate H-1; 🔒3 sobre líneas cambiadas, gate H-2) |
| ALC | alcance global ⊆ unión de ALCANCE + LOG + encargo + mockup |
| REG | PRUEBAS a, b y c sobre el estado final |

**Paso 2. Re-derivación independiente.**

Colores computados de **todas** las clases (`/tmp/s32g_colores.js`: elementos temporales con las clases del motor, que reciben sus mismas reglas CSS; en el motor final y en el de FASE 0) y ratios recalculados **en R** con una fórmula propia (`/tmp/s32g_r.R`: el navegador no interviene en el cálculo; las reglas `_txtOn` y `vtTexto` se reimplementan en R):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32g_colores.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html > /tmp/s32g_colores_final.json; node /tmp/s32g_colores.js /tmp/s32g_motor_fase0.html > /tmp/s32g_colores_fase0.json; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32g_r.R'
```
esperado: calibración 21,00 y 4,48; T1 antes 6,79 / 2,19 / 3,07 / 1,84, después 13,50; T2 antes 11 de 12 (mín. 3,53), después 12 de 12 (mín. 4,74, máx. 15,09), Clima alto `#ffffff` 3,53 → `#000000` 5,95; T3 sobre el track, antes < 4,5 y después ≥ 4,5 en las **tres** clases (§1: 5,00 / 5,16 / 5,06), y sobre blanco la tendencia ≥ 4,5 en las tres; T4 antes 3,88 / 3,28 / 3,85, después 13,50.
obtenido: `calibracion: 21.00 4.48`; T1 antes `6.79 2.19 3.07 1.84`, después `13.5`; T2 antes mín. 3,53, 11 de 12; después mín. 4,74, máx. 15,09, **12 de 12**; Clima alto `#ffffff` 3,53 → `#000000` 5,95. T3 sobre el track: `.ybar-sig.de` **3,20 → 5,00**, `.al` 3,78 → 5,16, `.nt` 3,23 → 5,06; sobre blanco: `.hist-trend.de` **3,48 → 5,44**, `.al` **4,11 → 5,61**, `.nt` 3,51 → 5,50. T4 antes 3,88 / 3,28 / 3,85, después 13,50. Coincide con el navegador (T3 difiere en ± 0,02: el navegador compone el fondo del track sin redondear, R usa `#f6f5f6`). Las clases que la ficha medida no tenía (`.ybar-sig.de`, `.hist-trend.de/.al`) quedan verificadas aquí.

**Paso 3. Invariantes 🔒** (`/tmp/s32g_inv.sh`; 🔒2 y 🔒3 con las lecturas de los gates H-1 y H-2):
```
bash /tmp/s32g_inv.sh
```
esperado: L1 `eb4e00b3…`; L2a declaraciones `18233475…` (= FASE 0) y las líneas cambiadas dentro del `:root` todas de comentario (0 con declaración de token); L2b 0 hex en líneas agregadas; L3 `-U0` `0` (literal con contexto: se reporta); L4 `0`; L5 `0`; L6 estilos de `.indp-dot` y de las barras con `ind.color` idénticos.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` → **🔒1 PASA**. `L2a (declaraciones): 21 lineas; md5 182334759a58462f381f12063ca2cb75` (= FASE 0) y `L2a'`: 6 líneas cambiadas dentro del `:root`, **0** con declaración de token (todas del comentario de inventario). **`L2b: 1`** hex en líneas agregadas: `+ // y blanco (vtTexto, la regla de §3.5); en el alto de Clima (#4c939a) el blanco daba 3,53` (comentario de T2, escrito por mí). `L3 (-U0): 0` (literal con contexto: 2, las líneas `const col`/`const sg` de H-2) → **🔒3 PASA** con la lectura del gate. `L4: 0` → **🔒4 PASA**. `L5: 0` → **🔒5 PASA**. `L6`: estilos de `.indp-dot` y de las barras con `ind.color` **idénticos** (11 líneas) → **🔒6 PASA**.
**Hallazgo R-11:** el único hex en líneas agregadas está en un **comentario** de T2 y nombra un tono que ya existe (la salida de `nivelRamp(--ind2).alto`); ningún código ni declaración agrega un color (L2a, L2a', L6). En lo sustantivo la paleta no cambió, pero la expresión de 🔒2 ("sin colores hex literales agregados") lo cuenta. Según cómo se clasifique, es un 🔒 en FALLA (BLOQUEA: no se repara, T2 se congela y FASE R termina en BLOQUEADO, sin push) o un defecto propio reparable (REPARA: se quita el hex del comentario). Se lleva al titular.

**Gate del titular (R-11):** eligió **"REPARA: quitar el hex"**.

**Ciclo de reparación 1 (R-11).**
- **Causa raíz:** al documentar T2 escribí el tono del alto de Clima como literal (`#4c939a`) dentro de un comentario del código; 🔒2 cuenta todo hex en líneas agregadas.
- **Fix quirúrgico** (ALCANCE de T2): "en el alto de Clima (#4c939a) el blanco daba 3,53" → "en el alto de Clima el blanco daba 3,53".
- **Re-verificación** con el chequeo que lo detectó (L2b de `/tmp/s32g_inv.sh`) **y** con uno distinto (`/tmp/s32g_hexset.sh`: el conjunto y los conteos de **todos** los hex literales de la plantilla en `8fd08b0` contra el árbol), más la regresión (build completo, §8.2 y el instrumento de contraste):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; bash /tmp/s32g_inv.sh | grep -E "^L2b|^L1"; bash /tmp/s32g_hexset.sh; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all()" > /tmp/s32g_run_r11.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32g_run_r11.log; md5 -q $R/40_salidas/motor_idps.html; git -C $R status --porcelain; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32g_contraste.js $R/40_salidas/motor_idps.html > /tmp/s32g_r11.json'
```
esperado: L2b `0`; conjunto de hex idéntico entre `8fd08b0` y el árbol; `rc=0`, 0 warnings; porcelain: plantilla y motor ` M` más el LOG; contraste igual al de T6 (13,50; 4,74 y 0 bajo 4,5; 5,18/5,07 y 5,50; 13,50), 0 errores.
obtenido: `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; **`L2b: 1`**, la misma línea con `(#4c939a)`: `/tmp/s32g_inv.sh` compara `8fd08b0..HEAD` y el fix todavía **no estaba commiteado**. El esperado era mío y estaba mal planteado: el chequeo mide commits, no el árbol (se re-mide después del commit, abajo). Chequeo distinto, sobre el árbol: `distintos inicio 54 final 54`, `conjunto y conteos IDENTICOS`, o sea que s32g no agrega ni quita ningún hex literal en la plantilla. Build `rc=0`, `0` warnings; motor `4b28a03fdaa00bd5dbb0a6fc501eab72` (cambia solo por el comentario); porcelain ` M` plantilla, ` M` motor, `??` LOG. Contraste: `errores []`, T1 `[13.5]`, T2 mín. `4.74` y `0` bajo 4,5, T3 `.al 5.18`, `.nt 5.07`, tendencia `5.5`, T4 `13.5`: igual que en T6.

Commit de la reparación y nueva medición de L2b, ahora sobre `HEAD`:
```
git add 30_procesamiento/35_motor_template.html 40_salidas/motor_idps.html && git commit -m "fix(auditoria): R-11 hex en un comentario" -- 30_procesamiento/35_motor_template.html 40_salidas/motor_idps.html && git show --stat --format='%h %s' HEAD && bash /tmp/s32g_inv.sh && git status --porcelain
```
esperado: un commit con 2 rutas (`+1/−1` en la plantilla, más el motor); L1 `eb4e00b3…`; L2a `18233475…` y 0 declaraciones cambiadas; **L2b `0`**; L3 `-U0` `0`; L4 `0`; L5 `0`; L6 idénticos; porcelain: solo el LOG.
obtenido: `5be8e32 fix(auditoria): R-11 hex en un comentario`; `30_procesamiento/35_motor_template.html | 2 +-`, `40_salidas/motor_idps.html | 2 +-`. `L1: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `L2a (declaraciones): 21 lineas; md5 182334759a58462f381f12063ca2cb75`; `L2a'`: 6 cambiadas, 0 con declaración; **`L2b hex en lineas agregadas: 0`**; `L3 (-U0): 0` (con contexto: 2); `L4: 0`; `L5: 0`; `L6` idénticos (11 líneas); porcelain: solo el LOG. **R-11 reparado:** 🔒2 PASA con la lectura del gate H-1 y 🔒1, 🔒3 a 🔒6 siguen en PASA.

**Pasos 4 a 6** (`/tmp/s32g_final.sh`). Alcance: lista explícita de rutas permitidas. Regresión: `run_all()` completo; PRUEBAS b con los modales (`/tmp/s32_verif.js consola`), la ficha en vista actual e histórica con `mousemove` (`/tmp/s32g_contraste.js`, que repite T1.1–T4.1) y una comparación a 1280 px (`/tmp/s32d_cmp.js`); PRUEBAS c, el hash §8.2. Controles positivos fuera del árbol: C1 una línea de diff con un hex; C2 la plantilla con un token plantado (FASE 0); C3 el motor con la cifra plantada (M3); C4 una ruta plantada en el alcance; C5 una línea plantada con `sigdifgru`; C6 🔒5 sobre el deploy `bcb956b`; C7 una copia del motor final con T2 y T3 revertidos (`vtTexto(c)` → `_txtOn(c)`; `.ybar-sig.al/.nt` con los colores de barra):
```
bash /tmp/s32g_final.sh
```
esperado: ALC con 3 rutas (plantilla, motor, decisión), `fuera 0`, encargo y mockup (2) en `8fd08b0`, porcelain solo el LOG. REGa `rc=0 warn=0 pasos=5`, motor `4b28a03f…` (= build de R-11), porcelain solo el LOG. REGb modales abiertos y cerrados sin errores; ficha con `err []`, M6 21 y 4,48, T1 4 títulos en `[13.5]`, T2 57 etiquetas con mínimo 4,74 y 0 bajo 4,5, T3 5,18 / 5,07 / mínimo 5,07 / 5,50, T4 `rgb(255, 255, 255)` 13,5 `vs GSE: ▼ -2 · n.s.`; comparación sin errores ni desbordes. REGc `eb4e00b3…4dc4`. Testigo `1` y `0`. C1 `1`; C2 un md5 **distinto** de `18233475…` (`b86e2393…`); C3 `1c3799e2…` (distinto); C4 `[docs/index.html]`; C5 `2`; C6 `1`; C7: la copia difiere en 2 líneas, `err []`, T1 13,5, **T2 3,53 con 5 bajo 4,5**, **T3 3,79 / 3,24**, tendencia 5,50 (no revertida), T4 13,5.
obtenido: `ALC: rutas [30_procesamiento/35_motor_template.html 40_salidas/motor_idps.html 50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md ] ; fuera 0 ; encargo+mockup en 8fd08b0: 2 ; porcelain [?? …s32g_log.md ]`. `REGa: rc=0 warn=0 pasos=5 motor=4b28a03fdaa00bd5dbb0a6fc501eab72`, porcelain solo el LOG. `REGb modales: "modal_territorio":true "modal_comparador":true "consola_errores":[] "pageerror":[]`; `REGb ficha: err [] M6 21 4.48 T1 4 [13.5] T2 57 4.74 0 T3 5.18 5.07 5.07 5.5 T4 rgb(255, 255, 255) 13.5 vs GSE: ▼ -2 · n.s.`; `REGb comparacion: "errores":[] "desbordadas":0`. `REGc: eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`. `testigo: motor 1 docs 0`. `C1: 1`; `C2: declaraciones: 21 lineas; md5 b86e23936f4bdc08441cf516308de91f` (distinto); `C3: 1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (distinto); `C4: [docs/index.html]`; `C5: 2`; `C6: 1`; `C7 plantado: difiere SI ; lineas distintas 2`; `C7: err [] T1 [13.5] T2 3.53 5 T3 3.79 3.24 5.5 T4 13.5`. Todos los instrumentos disparan con su caso plantado, y el de contraste lo hace en la superficie revertida y solo en ella.

**Re-derivación de R-01, R-08, R-09 y R-10** (comandos distintos de los que produjeron cada afirmación):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; T=30_procesamiento/35_motor_template.html; git rev-parse --short 8fd08b0~1; git log --format="%h %s" 8fd08b0~1..HEAD; grep -n "_txtOn(" $T | grep -v "const _txtOn" | grep -vc "^\s*//"; grep -nE "^\s*(function vtTexto|const contrasteWCAG|const _lumWCAG|function DistBar|function App)\b" $T | cut -c1-40 | sed "s/ /·/g"; git diff --numstat 8fd08b0..HEAD -- 50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md; git show HEAD:40_salidas/motor_idps.html | md5 -q; git diff 4a36346..HEAD -- 40_salidas/motor_idps.html | grep -cE "^[+-][^+-]"'
```
esperado: `e96ef6a`; 8 commits (los 7 del inventario más `5be8e32`); `0` usos de `_txtOn(`; `vtTexto`, `contrasteWCAG` y `_lumWCAG` con la misma sangría que `DistBar` y `App`; `44 1`; motor `4b28a03f…`; `2` líneas (el comentario de R-11).
obtenido: `e96ef6a`; `5be8e32`, `4a36346`, `641cf67`, `52430b6`, `2029e7d`, `5e006f2`, `8e92f7b`, `8fd08b0` (8); `0`; `999:··function·DistBar`, `2642:··const·_lumWCAG`, `2644:··const·contrasteWCAG`, `2654:··function·vtTexto`, `2817:··function·App` (dos espacios en todas: nivel superior del script); `44	1`; `4b28a03fdaa00bd5dbb0a6fc501eab72`; `2`.

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `git rev-parse 8fd08b0~1`; `git log` | padre `e96ef6a` | `e96ef6a`; 8 commits | — | ninguna | — | — |
| R-02 | §8.2 constante | L1 y REGc | `eb4e00b3…` | igual (R-11 y REGa) | — | ninguna | — | C3 |
| R-03 | calibración (M6) | fórmula propia en R; navegador en REGb | 21,00; 4,48 | 21,00; 4,48 | — | ninguna | — | — |
| R-04 | T1 títulos | R sobre colores computados; REGb | 6,79/2,19/3,07/1,84 → 13,50 | igual; filete del `ind.color` | — | ninguna | — | C7 (T1 intacto) |
| R-05 | T2 `DistBar` | R con `_txtOn` y `vtTexto` reimplementados; REGb | 3,53 → 5,95; 12 de 12 | igual; mín. 4,74 | — | ninguna | — | C7 (3,53, 5 bajo) |
| R-06 | T3 glifos y tendencia | R para las tres clases (también las ausentes en la ficha); REGb | ≥ 4,5 en las tres | 5,00/5,16/5,06; 5,44/5,61/5,50 | — | ninguna | — | C7 (3,79/3,24) |
| R-07 | T4 tooltip | R; REGb | 13,50; texto igual | 13,50; `vs GSE: ▼ -2 · n.s.` | — | ninguna | — | — |
| R-08 | ámbito de `vtTexto`; `_txtOn` sin uso | `grep` de sangría y de usos | módulo; 0 | módulo; 0 | ADVIERTE (D-1) | se conserva por contrato; duda | — | — |
| R-09 | T5 solo agrega y cambia el título | `git diff --numstat` | `44 1` | `44 1` | ADVIERTE (A-1: encabezado de §5) | nota | — | — |
| R-10 | build y testigo | md5 en `HEAD`; `grep -c` | 2 líneas de diff; 1/0 | `4b28a03f…`; 2; 1/0 | — | ninguna | — | — |
| **R-11** | **🔒2: sin hex en líneas agregadas** | L2b de `/tmp/s32g_inv.sh`; conjunto de hex de la plantilla (`/tmp/s32g_hexset.sh`) | 0 | **1** (el `(#4c939a)` de un comentario de T2) → 0 | **REPARA** (gate del titular) | quitar el hex del comentario | `5be8e32` | sí (dos chequeos, contraste igual, regresión, pasos 2 a 6) |
| A-2 | premisa §1.2 del encargo: "entre 4,75 y 15,09" | R y navegador | — | mínimo 4,74 (`#ffffff` sobre `#3b814b`, 4,743) | ADVIERTE (sin efecto: ≥ 4,5) | nota | — | — |
| A-3 | `const col` del tooltip queda sin uso (D-A1) | lectura | — | se conservó para no tocar una línea con `sigdifgru` (🔒3) | ADVIERTE | nota | — | — |
| 🔒1–🔒6 | invariantes | `/tmp/s32g_inv.sh` (tras `5be8e32`) | ver paso 3 | 6/6 PASA (🔒2 y 🔒3 con las lecturas de H-1 y H-2) | — | — | — | C1–C3, C5, C6 |
| ALC | alcance global | lista + `grep -vxF` | 0 fuera | 0 (3 rutas + encargo y mockup en `8fd08b0`) | — | — | — | C4 |
| REG | PRUEBAS a, b, c | `/tmp/s32g_final.sh` | `rc=0`, árbol limpio; 0 errores; `eb4e00b3…` | iguales | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** B/R/A = 0/1/4 (R-11 reparado; A-1, A-2, A-3 y D-1 abiertos como nota o duda). Ciclos de reparación usados: 1 de 2.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** (1) R-11, defecto del trabajo de T2, reparado; (2) el primer esperado del ciclo de R-11 decía `L2b 0` antes del commit, pero el instrumento compara `8fd08b0..HEAD`. Se re-midió tras el commit; el `obtenido:` de la línea anterior lo registra.

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: solo este LOG; `main` adelantada 8 respecto de `origin/main`.
obtenido: `?? 50_documentacion/andamios/logs/20260923_contraste_paleta_indicador_s32g_log.md` (única); `## main...origin/main [ahead 8]`.
- **Pasos 2 y 3:** `## Cierre` (abajo) y bloque J (arriba). **Pasos 4 y 5:** al final del Cierre. **Paso 6:** commit `docs(log)` y push según la autorización, en comando aparte.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s32g, que resuelve las cuatro superficies de §5.6 de la decisión de contraste. Fases: FASE 0, T1 a T6, R (con un ciclo de reparación) y L. Estado del grafo: T1 a T6 completadas · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Tres gates del titular: H-1 (🔒2 sobre las declaraciones del `:root`), H-2 (🔒3 sobre líneas cambiadas) y R-11 (REPARA).
2. **Commits** (`git log e96ef6a..HEAD --oneline`, antes del commit de este log):
   - `8fd08b0` chore(encargo): s32g y mockup §5.6 (= `<inicio>`)
   - `8e92f7b` fix(motor): título de indicador en tinta con filete del color (s32g T1, opción B)
   - `5e006f2` fix(motor): etiqueta de DistBar por mayor contraste (s32g T2)
   - `2029e7d` fix(motor): glifos y tendencia de la vista histórica con tokens de texto (s32g T3)
   - `52430b6` fix(motor): línea vs GSE del tooltip en blanco (s32g T4)
   - `641cf67` docs(decision): §5.6 resuelta (s32g)
   - `4a36346` build(motor): s32g contraste sobre la paleta de indicador (motor `12c8cebd…`)
   - `5be8e32` fix(auditoria): R-11 hex en un comentario (plantilla y motor `4b28a03fdaa00bd5dbb0a6fc501eab72`)
   - (este log: `docs(log): s32g contraste sobre la paleta de indicador`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/1/4; reparados 1.
4. **Invariantes:** 🔒1 PASA (`eb4e00b3…` en todos los builds) · 🔒2 PASA con la lectura del gate H-1 (declaraciones `18233475…` sin cambio; las 6 líneas cambiadas dentro del `:root` son de comentario; 0 hex en líneas agregadas **tras R-11**: la primera medición de FASE R dio 1) · 🔒3 PASA con la lectura del gate H-2 (`-U0` → 0; con contexto, 2) · 🔒4 PASA · 🔒5 PASA · 🔒6 PASA (11 líneas idénticas). 6/6.
5. **Decisiones del titular en gates:** H-1 "🔒2 sobre las declaraciones"; H-2 "🔒3 sobre líneas cambiadas"; R-11 "REPARA: quitar el hex". H-1 y H-2 son errores de redacción del encargo: el inventario de T3 vive dentro del `:root`, y `git diff` imprime por defecto líneas de contexto.
6. **Estado de cifras.** Hash §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0, en los builds de T1, T2, T3, T4, T6 y R-11, y en la regresión. Motor `fd091622…` → `12c8cebd…` (T6) → `4b28a03f…` (R-11); `docs/` sin cambios (`fd09162250e17481af5014b58fa824f8`). Ratios WCAG 2.1 con colores computados y fondo efectivo; entre paréntesis, el cálculo en R cuando la clase no estaba en la ficha medida:

   | superficie | fondo | antes | después |
   |---|---|---|---|
   | título "¿Qué mide…?" Autoestima / Clima / Participación / Hábitos | `#ffffff` | 6,79 / 2,19 / 3,07 / 1,84 (color del indicador) | 13,50 ×4 (`--tinta`, filete de 4 px del `ind.color`) |
   | etiqueta de `DistBar`, alto de Clima | `#4c939a` | 3,53 (`#ffffff`) | 5,95 (`#000000`) |
   | etiquetas de `DistBar` en la ficha (57) | su tono | mín. 3,53; 5 bajo 4,5 | mín. 4,74; 0 bajo 4,5 |
   | 12 tonos de `nivelRamp` | su tono | 11 de 12 ≥ 4,5 | 12 de 12 (4,74 a 15,09) |
   | `.ybar-sig.de` / `.al` / `.nt` | track `#f6f5f6` | (3,20) / 3,79 / 3,24 | (5,00) / 5,18 / 5,07 |
   | `.hist-trend.de` / `.al` / `.nt` | `#ffffff` | (3,48) / (4,11) / 3,51 | (5,44) / (5,61) / 5,50 |
   | línea "vs GSE" del tooltip (de / al / nt) | `.tt` `#23303a` | 3,88 / 3,28 / 3,85 | 13,50 (`#ffffff`, hereda) |

7. **Dudas y pendientes consolidados:**
   - D-1: `_txtOn` quedó sin uso desde T2 y se conserva con un comentario, porque el encargo no autoriza borrar código. ¿Se retira en el próximo encargo que toque la plantilla? (sí/no). Bloquea: nada.
   - A-1: el encabezado de §5 de la decisión de contraste (L190) todavía dice "§5.2 y §5.6 abiertos" (el encargo solo autorizaba cambiar el título de §5.6). ¿Se actualiza a "§5.2 abierto" en el próximo encargo que toque la decisión? (sí/no). Bloquea: nada.
   - A-3: `const col=p.sigdifgru…` del tooltip quedó sin uso tras T4 y se conservó para no tocar una línea que lee `sigdifgru` (🔒3). ¿Se retira más adelante, con 🔒3 leído sobre líneas cambiadas? (sí/no). Bloquea: nada.
   - A-2 (nota): la premisa §1.2 del encargo daba "entre 4,75 y 15,09"; el mínimo medido es 4,74 (`#ffffff` sobre `#3b814b`, 4,743). Sin efecto, porque es ≥ 4,5.
   - **Testigo del próximo despliegue:** "opción B de §5.6" (`grep -c` → `1` en el motor, `0` en `docs/index.html`).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:**
   - (1) R-11: escribí el tono `#4c939a` como literal en un comentario de T2, y 🔒2 lo cuenta. Costo: un gate al titular, un ciclo de reparación, un build y la re-verificación (unos 15 minutos).
   - (2) En el ciclo de R-11 escribí el esperado `L2b 0` antes del commit, pero el instrumento mide `8fd08b0..HEAD`. Costo: una medición extra, tras el commit.
   - (3) El resultado de M5/M6 se escribió como `obtenido (<archivo>):`, el mismo desliz de s32c a s32e. Se anexa en el paso 5.
   - Ningún error de instrumento con efecto sobre una cifra.
9. **Notas para el revisor:**
   - (a) Gate visual:
     - el título "¿Qué mide este indicador?" en tinta, con el filete de color en los cuatro indicadores;
     - la barra de niveles de Clima (la etiqueta del nivel alto en negro);
     - los glifos ▲/▼/= de la vista histórica y la marca de tendencia, ahora en los tonos `-txt`;
     - la línea "vs GSE" del tooltip en blanco (el estado lo dicen el glifo y "sig./n.s.").
   - (b) Esta sesión midió colores computados y ratios, no la percepción.
   - (c) `.ybar-sig.de` y `.hist-trend.de/.al` no aparecían en el establecimiento medido: sus cifras salen del cálculo en R sobre los colores computados de las clases.
   - (d) Nada se desplegó.
10. **Estado de cierre:** commiteados `8fd08b0`, `8e92f7b`, `5e006f2`, `2029e7d`, `52430b6`, `641cf67`, `4a36346`, `5be8e32` y el commit `docs(log)`. **No se despliega** (`docs/` intacto). Push: según la condición del encargo; resultado en el reporte final.
11. **FASE L, pasos 4 y 5 (antes del commit).**

Paso 4, privacidad (`/tmp/s32g_priv.sh`, adaptado de s32e cambiando solo la ruta del log y del archivo plantado: RUT con la expresión en una variable y control plantado en un archivo aparte; "RBD" seguido de número; nombres de establecimiento; nombre de la estación):
```
bash /tmp/s32g_priv.sh
```
esperado: `0`; plantado `1`; `0`; `0`; `0`.
obtenido: `RUT en el log: 0`; `RUT plantado: 1`; `RBD con número: 0`; `establecimientos por nombre: 0`; `estación por nombre: 0`. El log no nombra establecimientos ni personas (el establecimiento medido se describe por criterio: "el primero del foco con ≥ 9 % en el alto de Clima").

Paso 5, primera medición (sin contar el par de esta segunda medición): `### FASE` = 9 (FASE 0, T1 a T6, R, L); `## J` = 1, relleno con 13 campos; **`^esperado:` = 21 y `^obtenido:` = 20**. Causa: el resultado de M5/M6 se escribió como `obtenido (<archivo>):`. Se anexa lo faltante con su estado real:
obtenido: (anexo de formato a M5/M6) calibración 21 y 4,48; los cuatro títulos, `DistBar` en el alto de Clima, glifos, tendencia y tooltip, todos bajo 4,5 y dentro de ± 0,05 de §1; ninguna tarea congelada.

Segunda medición:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260923_contraste_paleta_indicador_s32g_log.md; ls -l $L && wc -l $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L)"; bash /tmp/s32g_priv.sh | head -1'
```
esperado: `FASE=9`; `esperado=22` y `obtenido=21` al medir (este par todavía sin su `obtenido:`); `J=1`; `RUT en el log: 0`.
obtenido: `54956` bytes y `379` líneas al medir; `FASE=9 esperado=22 obtenido=21 J=1`; `RUT en el log: 0`. Con esta línea, **22 = 22**.
