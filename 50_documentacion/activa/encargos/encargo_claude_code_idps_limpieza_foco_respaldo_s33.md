# Encargo autónomo: limpieza de código sin uso y destino de respaldo del foco (s33)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`; `00_build.R`; `40_salidas/motor_idps.html`; los logs `50_documentacion/andamios/logs/20260923_foco_modal_s32e_log.md` (instrumentos de foco) y `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` (convención §8.2 del hash del payload).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33_*`); `Rscript` para R; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Las pruebas de foco corren **con ventana** (`headless: false`) **y** en headless. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Localiza el código por marcadores (nombres, clases, comentarios), no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260924_limpieza_foco_respaldo_s33_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`, y los escribe en el encabezado del log. El hash del commit `chore(encargo): s33` es `<inicio>` para todos los diffs de este encargo.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y árbol limpio salvo el ALCANCE; (b) Puppeteer sobre el motor: 0 errores de consola y 0 `pageerror` tras cargar, abrir y cerrar los dos modales, abrir una ficha con vista histórica y armar una comparación; (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0 (este encargo no toca datos).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas (nunca `-A` ni `.`); ningún comentario CSS con `*/` interno; **ningún color hex en comentarios ni en código nuevo** (el control de 🔒2 los cuenta).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del commit del encargo) → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. M5 no reproduce el caso malo (el foco **no** cae en `BODY` en alguno de los dos casos) → T4 omite ese caso, lo registra y sigue con el otro.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto: el despliegue va en un bloque aparte, tras el gate visual del titular), ni `rm`, `reset`, `restore` ni `checkout --`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `d046c9c` (commit de `/apertura`, `sesion_abierta: true`) (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24).
- Motor y `docs/index.html` tienen el mismo md5, `4b28a03fdaa00bd5dbb0a6fc501eab72` (fuente: `md5sum` del redactor el 2026-09-23).
- Hash §8.2 vigente del payload: `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (fuente: log s32g, línea `obtenido:` de M3). Se vuelve a medir en FASE 0.
- `_txtOn` aparece 2 veces en la plantilla: la definición (`const _txtOn=c=>{…}`, dos líneas, con los literales de color claro y oscuro en la segunda) y una mención en el comentario que precede a `_lumWCAG` ("distinto de _txtOn (luminancia perceptual…)") (fuente: `grep -n '_txtOn'` del redactor). Encima de la definición hay un comentario de 5 líneas que la describe y declara que no se usa desde s32g (fuente: `sed` del redactor).
- Ningún `.R` del proyecto menciona `_txtOn` (fuente: `grep -rn` del redactor, sin resultados `.R`).
- `_hx(` aparece 3 veces en la plantilla y `_lumWCAG` es uno de sus usos, así que `_hx` se queda (fuente: `grep -c '_hx('` y `sed` del redactor).
- `const col=` aparece una vez, en el tooltip de la vista histórica (`if(gse && p.difgru!=null){…}`); la línea contiene `sigdifgru` y el comentario dos líneas más abajo dice que `col` "ya no pinta el texto y queda sin uso aqui" (fuente: `sed` y `grep -n` del redactor). Que `col` no se lea en ningún otro punto del bloque es hipótesis (se mide en FASE 0).
- La línea siguiente, `const sg=(p.sigdifgru===1||p.sigdifgru===-1)?"· sig.":"· n.s.";`, **sí** se usa y no se toca (fuente: `sed` del redactor).
- En la decisión de contraste, el encabezado `## 5.` dice "(§5.1, §5.3 a/c, §5.4 y §5.5 1/3 resueltos; §5.2 y §5.6 abiertos)", y `### 5.6` dice "**RESUELTO el 2026-09-23 (s32g)**" (fuente: `grep -n` del redactor). El campo **Estado** del encabezado termina en la enmienda de s29g con la frase "Última enmienda de la línea de contraste." y no menciona s32g (fuente: `sed -n 1,20p` del redactor).
- `EntityModal` lee el origen en el primer render (`const [origen]=useState(()=>document.activeElement)`) y, al desmontar, lo enfoca **solo si** sigue en el documento; si no, no hace nada (fuente: `sed` del redactor sobre el efecto de limpieza).
- El botón `.cmp-add` ("+ agregar entidad") se renderiza solo con `cmpTerr.length<CMP_MAX_TERR`, y `CMP_MAX_TERR=10` (fuente: `grep -n` del redactor).
- `onPick` del modal de territorio, con un ítem `establecimiento`, cambia a la pantalla de ficha (`setPantalla("ficha")`) (fuente: `sed` del redactor). `.terr-trigger` vive en la barra del panorama (fuente: `sed` del redactor). Que no exista en la ficha es hipótesis (se mide en FASE 0).
- Destinos de respaldo candidatos: `.ficha-name` (nombre del establecimiento en la cabecera de `Ficha`) y `.cmp-cl` ("Entidades a comparar · N de 10"); hoy ninguno lleva `tabIndex` (fuente: `grep -n` del redactor; 0 ocurrencias de `tabIndex={-1}` en la plantilla).
- Que en los dos casos de A-1 (tope de 10 en el comparador; elegir un establecimiento en el modal de territorio) el foco caiga en `BODY` es hipótesis: el log s32e lo registró como "ADVIERTE (no medido aquí)" (fuente: log s32e, fila A-1). Se mide en FASE 0 (M5).
- Los instrumentos de s32g (`/tmp/s32g_payload_sha.sh`, `/tmp/s32g_root_md5.sh` y sus `.js`) y el script de foco de s32e siguen existiendo en `/tmp`: hipótesis (se mide en FASE 0; si no existen, se reescriben desde los logs citados en INSUMOS y se calibran).

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS (React 18 UMD, JSX transpilado en el navegador, payload zlib+base64). La interfaz completa vive en `30_procesamiento/35_motor_template.html`; `run_all(only = 35L)` genera `40_salidas/motor_idps.html`. `EntityModal` se usa dos veces: modal de territorio (selección simple, abre desde `.terr-trigger`) y modal del comparador (múltiple con tope de 10, abre desde `.cmp-add`). Desde s32e el modal retiene el foco y lo devuelve al botón de origen. Este encargo cierra D-1, A-1 y A-3 de s32g y A-1 de s32e. `docs/` no se toca.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build (script `/tmp/s33_payload_sha.sh`).
2. **Paletas intactas y sin hex nuevo:** (a) md5 del bloque `:root` igual al de FASE 0 (script `/tmp/s33_root_md5.sh`); (b) script `/tmp/s33_hex.sh` sobre `git diff -U0 <inicio>..HEAD -- 30_procesamiento/35_motor_template.html`, contando solo líneas cambiadas (`^[+-][^+-]`) que contienen un hex (`#[0-9a-fA-F]{6}\b` o `#[0-9a-fA-F]{3}\b`): **agregadas = 0; borradas = 1** (la segunda línea de `_txtOn`, que lleva los dos literales de color). Calibración en FASE 0 (M10).
3. **El estado se lee de `sigdifgru`:** script `/tmp/s33_sig.sh`: sobre `git diff -U0 <inicio>..HEAD -- 30_procesamiento/35_motor_template.html`, líneas `^-[^-]` con `sigdifgru` = **1** y es exactamente la línea `const col=…` retirada en T2; líneas `^\+[^+]` con `sigdifgru` = **0**. Además `grep -c 'const sg=(p.sigdifgru===1||p.sigdifgru===-1)' 30_procesamiento/35_motor_template.html` = 1. Calibración en FASE 0 (M10).
4. **Pipeline de datos intacto:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **La retención y devolución de s32e siguen funcionando:** con el origen presente, Tab y Shift+Tab en ciclo dentro de los dos modales y devolución del foco al botón de origen en las 10 vías de cierre de s32e. Comando: el script de M8, corrido antes (FASE 0) y después (T5 y FASE R), con el mismo resultado.

## 4. Grafo de tareas y ALCANCE

- **T1** (retirar `_txtOn`) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (retirar `const col`) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente de T1 en lógica; comparte archivo, va en serie después de T1.
- **T4** (destino de respaldo del foco) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente en lógica; en serie después de T2.
- **T3** (encabezado de la decisión) · ALCANCE: `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`. Independiente.
- **T5** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere al menos una de T1, T2 o T4 completada; construye lo que haya commiteado.
- Orden de ejecución: T1 → T2 → T4 → T3 → T5. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre, aunque una tarea quede congelada.

**Excluidos de la cadena (con razón):** pendientes 3 (divergencia 39 vs 24: exige decidir el texto), 5 (base pequeña: umbral sin fijar), 4 y 7 (exportaciones: diferidas hasta que el equipo las pida), 9 y 10 (`renv` y rama `feat/contrato-contexto`: decisión del titular), 11 (divergencias 6 y 10 con el hermano: decisión de diseño), 12 (ordenación: requiere aprobación propia), 13 (carpeta vacía: tarea manual del titular), 6 y 8 (desborde de pestañas y desmarcar con tope: fuera de la ruta aprobada para s33; se proponen al titular para el encargo siguiente).

## 5. FASE 0: apertura del log y mediciones

Primer acto: commitear el encargo (`chore(encargo): s33`). Segundo acto: crear el LOG con encabezado (meta; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` y modo real de la sesión; grafo; "sin subagentes"; topes), el slot `## J. Juicio (lo rellena FASE L)` y el esqueleto de secciones. Cada medición con `esperado:` escrito **antes** del comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain` tras el primer commit; `git stash list` | solo el LOG (o vacío); vacío | regla 1 |
| M2 | `fetch`; `rev-parse --short HEAD` y `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `d046c9c` = `origin/main`; `0`; `1` | regla 2 |
| M3 | Instrumentos §8.2 (copiar los de s32g a `/tmp/s33_*` si existen; si no, reescribirlos desde el log s29 §8.2). Hash §8.2 del motor actual; calibración con dos copias en `/tmp`: fecha alterada (mismo hash) y cifra plantada (otro hash) | `eb4e00b3…4dc4`; igual; distinto | si el motor da otro valor: regístralo y úsalo como referencia (el motor no cambió desde s32g); si la calibración falla, congela T5 |
| M4 | md5 del `:root` (script `/tmp/s33_root_md5.sh`) | un md5 y su número de líneas | congela T1, T2 y T4 |
| M5 | **Caso malo de T4**, con ventana y en headless: (i) comparador: abre el modal desde `.cmp-add`, agrega entidades con teclado (Enter sobre filas `.check-row`) hasta 10 de 10, cierra con Listo, con Escape y con clic en el fondo (tres corridas) y registra `document.activeElement` (tag y clase); (ii) territorio: abre el modal desde `.terr-trigger`, pestaña Establecimiento, elige una fila con Enter y registra `document.activeElement` tras el cambio a la ficha | `BODY` en las cuatro corridas y en los dos modos | regla 6 |
| M6 | En la ficha, `document.querySelectorAll(".terr-trigger").length`; en el comparador con 10 de 10, `document.querySelectorAll(".cmp-add").length` | `0`; `0` | residual |
| M7 | Conteos de partida en la plantilla: `grep -c '_txtOn'`; `grep -c '_hx('`; `grep -c 'const col='`; `grep -c 'const sg=(p.sigdifgru===1'`; `grep -c 'tabIndex={-1}'`; y dentro del bloque del tooltip (desde `if(gse && p.difgru!=null){` hasta su cierre) las apariciones de la palabra `col` como identificador (`\bcol\b`) fuera de la línea de declaración y del comentario | `2`; `3`; `1`; `1`; `0`; `0` | congela la tarea que dependa del conteo que difiera (T1, T2 o T4) |
| M8 | Script de 🔒6 (reescrito desde la sección T1 del log s32e si no existe en `/tmp`) sobre el motor actual, con ventana y headless | ciclo cerrado en los dos modales; 10 de 10 vías devuelven el foco al origen | congela T4 |
| M9 | Colores calculados de las etiquetas de `DistBar` en una ficha fija (el primer establecimiento del roster de 4b del año vigente) y texto de la línea "vs GSE" del tooltip de la vista histórica para tres puntos: uno con `sigdifgru` 1, uno con -1 y uno con 0 o nulo | valores registrados (son la línea base de T1 y T2) | residual |
| M10 | Calibración de 🔒2(b) y 🔒3 sobre copias en `/tmp`: (i) caso bueno: aplicar a una copia de la plantilla las ediciones de T1 y T2 y correr `diff -U0` original→copia con los scripts; (ii) caso malo: a esa copia agregarle una línea `// #123456 sigdifgru` y repetir | (i) hex +0/−1, `sigdifgru` −1/+0; (ii) hex +1, `sigdifgru` +1 | si un script no dispara en (ii) o dispara en (i), corrígelo **antes** de T1 y registra la corrección; no se ajusta el esperado |

Último acto: anexar la sección `### FASE 0`.

## 6. T1: retirar `_txtOn` (D-1 de s32g)

**Meta:** la función sin uso y sus menciones desaparecen de la plantilla, sin cambio visible.

1. Paso 0: relee M7 y M9.
2. Borra la definición completa de `_txtOn` (sus dos líneas) y el comentario de 5 líneas que la precede y la describe. En el comentario que precede a `_lumWCAG`, reemplaza la frase que la menciona por: `// Contraste WCAG 2.1 (luminancia relativa con linealizacion sRGB).` Nada más cambia.
3. Verificación (build temporal con `run_all(only = 35L)`; `esperado:` antes):
   - T1.1 `grep -c '_txtOn' 30_procesamiento/35_motor_template.html` → `0`; en el motor temporal → `0`.
   - T1.2 `grep -c '_hx('` → `2`.
   - T1.3 colores de las etiquetas de `DistBar` iguales a M9, en la misma ficha.
   - T1.4 PRUEBAS b sin errores; hash §8.2 igual a M3; md5 del `:root` igual a M4.
   - T1.5 🔒2(b) parcial: hex +0/−1.
4. Cierre de fase en cinco pasos; commit `chore(motor): retira _txtOn sin uso (s33 T1, D-1 de s32g)`.

## 7. T2: retirar `const col` (A-3 de s32g)

**Meta:** la variable sin uso del tooltip desaparece; el texto del tooltip no cambia.

1. Paso 0: relee M7 (el conteo de `\bcol\b` en el bloque debe haber dado 0) y M9.
2. Borra la línea `const col=p.sigdifgru===1?…` completa. En el comentario de dos líneas que sigue a `const sg=…`, deja la primera tal como está y reemplaza la segunda por: `// (la linea hereda el blanco de .tt).` Nada más cambia.
3. Verificación (build temporal; `esperado:` antes):
   - T2.1 `grep -c 'const col=' 30_procesamiento/35_motor_template.html` → `0`; `grep -c 'const sg=(p.sigdifgru===1' ` → `1`.
   - T2.2 🔒3 completo: `sigdifgru` −1 (la línea de `col`)/+0.
   - T2.3 texto de la línea "vs GSE" del tooltip idéntico a M9 en los tres puntos.
   - T2.4 PRUEBAS b sin errores; hash §8.2 igual a M3.
4. Cierre de fase; commit `chore(motor): retira const col sin uso del tooltip (s33 T2, A-3 de s32g)`.

## 8. T4: destino de respaldo del foco cuando el origen desaparece (A-1 de s32e)

**Meta:** si el botón que abrió el modal ya no está en el documento al cerrarlo, el foco queda en un elemento visible y con sentido, no en `BODY`. Con el origen presente, nada cambia.

1. Paso 0: relee M5, M6 y M8.
2. Implementación:
   - `EntityModal` gana una prop `focoRespaldo=null`: una función sin argumentos que devuelve un elemento o `null`. En el efecto de limpieza que hoy devuelve el foco al origen: si el origen sigue en el documento, **todo queda como está** (incluido el descarte de la autorrepetición de Enter y Espacio); si no, y `focoRespaldo` existe, se llama y, si devuelve un elemento que está en el documento, se le da el foco. Si tampoco hay respaldo, el comportamiento es el actual.
   - Modal de territorio: `focoRespaldo={()=>document.querySelector(".ficha-name")}`. El `div.ficha-name` de `Ficha` gana `tabIndex={-1}`.
   - Modal del comparador: `focoRespaldo={()=>document.querySelector(".cmp-add")||document.querySelector(".cmp-cl")}` (si el usuario desmarcó una entidad antes de cerrar, el botón reapareció como nodo nuevo y es el mejor destino; si no, el contador "Entidades a comparar · 10 de 10"). El `span.cmp-cl` gana `tabIndex={-1}`.
   - CSS, fuera del `:root`, junto a las demás reglas `:focus-visible`: `.ficha-name:focus-visible,.cmp-cl:focus-visible{outline:2px solid var(--foco);outline-offset:2px;}`. Sin colores literales.
   - Comentario de una línea en `EntityModal`, sin hex: `// s33: si el origen ya no existe (tope del comparador, salto a la ficha), el foco va al respaldo que declara quien abre el modal (A-1 de s32e).`
3. Verificación (build temporal; con ventana **y** headless; `esperado:` antes):
   - T4.1 **caso que lo motivó, comparador:** repetir M5 (i). `document.activeElement` es `.cmp-cl` en las tres vías de cierre; y con teclado su `outline-style` calculado es `solid`.
   - T4.2 **caso que lo motivó, territorio:** repetir M5 (ii). `document.activeElement` es `.ficha-name`.
   - T4.3 comparador con 10 de 10, desmarcar una entidad con Enter dentro del modal y cerrar con Listo: el foco queda en `.cmp-add`.
   - T4.4 desde el respaldo, un Tab lleva al siguiente control del documento (no hay trampa fuera del modal).
   - T4.5 🔒6: el script de M8 da el mismo resultado que en FASE 0 (con el origen presente, el respaldo no interviene).
   - T4.6 caso malo: M5 sobre el motor de FASE 0 (guardado en `/tmp/s33_motor_fase0.html`) sigue dando `BODY`.
   - T4.7 🔒2(b): hex +0; md5 del `:root` igual a M4; hash §8.2 igual a M3.
   - Registrar, sin que sea criterio, el `outline-style` del respaldo cuando el cierre fue con el mouse.
4. Cierre de fase; commit `fix(motor): destino de respaldo del foco al cerrar el modal sin origen (s33 T4, A-1 de s32e)`.

## 9. T3: encabezado de §5 y estado de la decisión de contraste (A-1 de s32g)

**Meta:** la decisión dice en su encabezado lo que su cuerpo ya dice.

1. Paso 0: `grep -n '^## 5\.' <decisión>`, `sed -n 1,20p <decisión>` y `grep -c 's33' <decisión>` (esperado `0`, fuente: `grep -c` del redactor).
2. Edición:
   - El encabezado `## 5.` pasa a: `## 5. Pendientes asociados (§5.1, §5.3 a/c, §5.4, §5.5 1/3 y §5.6 resueltos; §5.2 abierto)`.
   - En el campo **Estado**, la frase "Última enmienda de la línea de contraste." está partida en dos líneas (la primera termina en "Redesplegado a `docs/`. Última" y la siguiente es "  enmienda de la línea de contraste."). Se borra esa frase y en su lugar va el texto siguiente (literal, sin la valla), con el mismo sangrado de dos espacios y líneas de ~88 columnas como el resto del campo:

     ```text
     **Enmendada el 2026-09-23 (s32g):** se resuelve la §5.6 con la opción B (título del indicador en tinta con filete del color) y se amplía a siete el inventario de usos de los tokens `-txt`. Desplegado a `docs/`. **Enmendada el 2026-09-24 (s33):** encabezado de §5 al día; `_txtOn` retirado del motor.
     ```
   - Nada más cambia.
3. Verificación (`esperado:` antes): `grep -c '§5.6 abiertos'` → `0`; `grep -c '§5.6 resueltos; §5.2 abierto'` → `1`; `grep -c 's33'` → `1`; `git diff -U0 -- <decisión> | grep -c '^@@'` → `2`. No tocó código (regresión: "no tocó código").
4. Cierre de fase; commit `docs(decision): encabezado de §5 y estado al día (s33 T3, A-1 de s32g)`.

## 10. T5: build

1. `git status --porcelain` → vacío.
2. Build con PRUEBAS a; PRUEBAS b completa; T4.1, T4.2 y 🔒6 repetidos sobre el motor commiteable; hash §8.2 igual a M3.
3. Testigo para el despliegue: `grep -c 'focoRespaldo' 40_salidas/motor_idps.html` ≥ 1 y `grep -c 'focoRespaldo' docs/index.html` = 0; `grep -c '_txtOn' 40_salidas/motor_idps.html` = 0.
4. md5 del motor nuevo, distinto de `4b28a03f…`, registrado para el despliegue.
5. Commit `build(motor): s33 limpieza y respaldo del foco`.

## 11. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra de las secciones por fase, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M10, T4.6) y el alcance global. Numera `R-01`, `R-02`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (el destino del foco con `document.activeElement` y además con `document.querySelector(':focus')`; los conteos de `grep` con `awk` o `node`; el retiro de `_txtOn` además buscando `txtOn` sin guion bajo en el motor).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG y el encargo); `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** al menos una afirmación auditada además contra un caso plantado fuera del árbol que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log (una corrección es una línea nueva que cita a la anterior); reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 12. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; destinos del foco antes y después en los cuatro casos de M5); decisiones del titular registradas; dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push no se afirma en el J: "según la condición del encargo; resultado en el reporte final".
4. Privacidad: grep de RUT sobre el log con un script (`/tmp/s33_priv.sh`, patrón `[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]`) → vacío; ningún RBD ni nombre de establecimiento o de persona (el establecimiento de M9 se registra como "primer establecimiento del roster de 4b"); la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas (congeladas y FASE R incluidas); `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real; no reescribas el esperado.
6. `git add <LOG>` y `git commit -m "docs(log): s33 limpieza y respaldo del foco"`; luego el push según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado; el testigo y el md5 para el despliegue; hash del commit `docs(log)`.

## 13. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push y `rev-list` final; destinos del foco antes y después (con ventana y headless) en los cuatro casos; testigo y md5 para el despliegue; lo que queda al titular (gate visual: en el comparador, llegar a 10 de 10 con teclado y cerrar, el foco queda en el contador con anillo visible; en el modal de territorio, elegir un establecimiento, el foco queda en su nombre en la ficha); "lo que falló o sorprendió; si nada, decirlo".
