# Encargo autónomo: conteos con plural, teclado del modal y enmienda §3.5 (s32)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena que escribe en serie sobre un mismo archivo; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. Si la sesión está en `ultracode`, el encargo manda: 0 subagentes, y el encabezado del log lo declara.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (todos en disco, rutas verificadas por el redactor en este entorno):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `40_salidas/motor_idps.html`; `docs/index.html` (solo lectura); `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`; `50_documentacion/andamios/logs/20260917_correcciones_revision_s31b_log.md` (solo lectura); el hermano `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html` (solo lectura, su existencia se mide en FASE 0).
- **POSICIÓN:** todo comando usa rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd` previo. Intérprete: `bash` explícito (`bash -c '…'`) para scripts de shell; `Rscript` para R; `node` para Puppeteer. Primera acción git de FASE 0: `git -C /Users/tomgc/Projects/slep_idps fetch --quiet` y comparar `HEAD` contra `origin/main`.
- **LOG:** `50_documentacion/andamios/logs/20260923_conteos_teclado_enmienda_s32_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain` (vacío), `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `6117393`), y los escribe en el encabezado del log.
- **PRUEBAS (sin arnés de pruebas; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all(only = 35L)'` con exit 0 y 0 warnings; (b) el motor `40_salidas/motor_idps.html` abierto por `file://` en Puppeteer con 0 errores de consola y 0 `pageerror` tras cargar y abrir los dos modales; (c) el SHA-256 del contenido del `<script>` del payload es idéntico al medido en FASE 0. Puppeteer se toma con `NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules` y el Chrome del sistema (este proyecto no tiene `node_modules`). La pestaña corre con `document.hidden`: para medir, forzar remount si hace falta.
- **Topes de esfuerzo:** 3 intentos por bug (al tercero la tarea se congela con la evidencia de los tres); 2 ciclos de reparación en FASE R; 1 reintento por comando que falla por causa transitoria (al segundo fallo es un hallazgo).
- **Reglas canónicas heredadas:** commits y comentarios en español; `git add` con rutas explícitas, nunca `git add -A` ni `git add .`; un comentario CSS jamás contiene un `*/` literal; el año no es seleccionable; mayúsculas sostenidas solo en siglas; localizar código por marcadores de contenido, no por número de línea (los números de línea de este encargo son orientativos).

### Regla de detención (lista medible)

1. `git status --porcelain` no vacío o `git stash list` no vacío en FASE 0 → detén la **sesión** (compromete el repositorio) y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión y pasa a FASE L.
3. SHA-256 del payload distinto entre FASE 0 y cualquier build posterior → congela la tarea que lo produjo y todas sus descendientes.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo (BLOQUEA en FASE R).
5. Una medición de FASE 0 que contradice su `esperado:` → congela la tarea que dependía de ella; no ajustes la meta al número encontrado.
6. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
7. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (formato 4.1: contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- `git commit` de los archivos del ALCANCE de cada tarea, con rutas explícitas, tras el cierre de fase en cinco pasos.
- `git revert <hash>` de un commit propio de esta sesión, si FASE R lo exige.
- `git push origin main` **una sola vez**, después del commit `docs(log)`, y solo si: FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `git fetch` seguido de `git rev-list --count HEAD..origin/main` da `0`.
- Escribir archivos temporales fuera del árbol (`/tmp/s32_*`) para mediciones; se dejan donde quedan.
- Implícitas del patrón: commits `fix(auditoria): R-NN …` de FASE R y `docs(log): …` de FASE L.

Nada más. En particular: **no** se despliega (`docs/` no se toca: el despliegue va después del gate visual del titular), no se usa `reset`, `restore`, `checkout --` ni `rm` dentro del árbol.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `6117393`, árbol limpio (fuente: eco de `/apertura` del titular, 2026-09-23); se re-mide en FASE 0.
- `docs/index.html` y `40_salidas/motor_idps.html` tienen el mismo md5 `6c5feab5428ed05dff09867f2b47bba3` (fuente: `md5sum` sobre ambos, sesión del redactor 2026-09-23); se re-mide en FASE 0.
- En `30_procesamiento/35_motor_template.html` hay tres conteos con plural fijo escrito a mano (fuente: `grep` del redactor): `NACIONAL_OPT.sub` (~L1754, `"Nivel nacional · "+fmt(coms.size)+" comunas · "+fmt(ee)+" establecimientos"`), el `sub` del tab SLEP en `_listaCmpEnt` (~L1771, `s.ncom+" comunas · "+s.ee+" establecimientos"`, sin `fmt`) y el `title` del botón de exportación del panorama (~L2957, `"Descarga en CSV los "+fmt(unidades.length)+" establecimientos de esta vista…"`).
- El ayudante `nEE` se declara en ~L2613, entre `bloquesEje` y `PanoramaHistorico`; `fmt` se declara en ~L824 (fuente: `grep` del redactor).
- `SLEPS_OPTS` y `NACIONAL_OPT` son IIFE que se evalúan al cargar, antes de la línea de `nEE` (hipótesis, se mide en FASE 0): si es así, usar `nEE` en ellas sin moverlo dispara un error de TDZ.
- "SLEP Santiago Centro" muestra hoy "1 comunas" en el tab SLEP del modal del comparador (hipótesis, se mide en FASE 0; origen: `CLAUDE.md`, D-1 de s31c).
- `.check-row` de `EntityModal` (~L1628) no tiene `tabIndex` ni `onKeyDown`; `role="checkbox"` y `aria-checked` solo en modo múltiple (fuente: `sed -n 1590,1645p` del redactor). `EntityModal` se usa dos veces: territorio (~L2902, selección simple) y comparador (~L2904, múltiple con tope) (fuente: `grep '<EntityModal'`).
- `Escape` ya cierra el modal por un listener de `window` (fuente: ~L1592).
- La implementación del modal del hermano (`/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`, ~L3945) es referencia vinculante (regla s29h, `CLAUDE.md`); si sus filas son operables por teclado y cómo (hipótesis, se mide en FASE 0).
- La cadena `check-row:focus-visible` no existe hoy en `docs/index.html` (hipótesis, se mide en FASE 0; es el testigo del despliegue futuro).
- La decisión `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`, §3 punto 5 (~L34), dice "En toda la rampa posible, el mínimo es 4,78:1" (fuente: `sed -n 26,40p` del redactor).
- El log de s31b re-derivó en node un piso de 4,58:1 en la rampa continua (Autoestima, k = 0,819, fondo `#5a74b3`) y 4,78:1 sobre los puntajes enteros del dominio calibrado (puntaje 81), con controles 21,00 y 4,48 (fuente: `20260917_correcciones_revision_s31b_log.md`, L274-279 y L453, leídas por el redactor).
- El pendiente 3 del traspaso v30 (criterio de verificación del despliegue) **ya está cumplido**: §8, §11 y §12 del traspaso usan "sin comparación publicada" (fuente: `grep -F 'Exportar CSV'` del redactor). No entra a la cadena; FASE L lo anota como cerrado sin cambios.

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS (React 18 + D3 v7, JSX transpilado en el navegador por `@babel/standalone`). La interfaz completa vive en `30_procesamiento/35_motor_template.html`; `35_generar_motor_html.R` arma el payload y produce `40_salidas/motor_idps.html` (versionado). `docs/index.html` es el despliegue de GitHub Pages y no se toca en este encargo.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Cero agregación y pipeline intacto:** el encargo no toca R ni datos. Comando: `git -C /Users/tomgc/Projects/slep_idps diff --name-only <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/31* 30_procesamiento/32* 30_procesamiento/33* 30_procesamiento/34* 30_procesamiento/35_generar_motor_html.R 00_build.R | wc -l` → `0`.
2. **Payload byte-idéntico:** SHA-256 del contenido del `<script>` del payload de `40_salidas/motor_idps.html` igual al de FASE 0 (misma extracción en ambos momentos, script en `/tmp/s32_payload_sha.sh`).
3. **Paletas de ESTADO e INDICADOR intactas:** el bloque `:root{…}` de la plantilla, extraído con el mismo `awk` antes y después, tiene el mismo md5; y `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -E '^[+-][^+-].*#[0-9A-Fa-f]{3,6}\b' | wc -l` → `0` (ningún color literal nuevo ni borrado).
4. **El estado se lee de `sigdifgru` y el nulo no afirma estado:** `git diff <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru` → `0`.
5. **`docs/` intacto** (releído contra el alcance: este encargo **no** despliega): `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Sin datos versionados:** `git ls-files | grep -cE '\.(csv|xlsx|parquet|rds)$'` igual al valor de FASE 0 (el proyecto es público y versiona sus insumos; lo que se mide es que no cambie).

## 4. Grafo de tareas y ALCANCE

- **T1** (conteos con plural) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (teclado del modal) · ALCANCE: `30_procesamiento/35_motor_template.html`. Independiente de T1 en lógica; comparte archivo, así que corre **después** de T1, en serie.
- **T3** (enmienda §3.5) · ALCANCE: `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`. Independiente de T1 y T2.
- **T4** (build del motor) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T1 **o** T2 completada (construye con lo que esté commiteado); si ambas quedan congeladas, T4 no se ejecuta.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre, aunque alguna tarea quede congelada.

Orden de ejecución: FASE 0 → T1 → T2 → T3 → T4 → FASE R → FASE L.

## 5. FASE 0: apertura del log y mediciones

Primer acto: `mkdir -p` de la carpeta del log y creación del archivo `LOG:` con encabezado (meta en una línea; fecha; repo y rama; hash de inicio; ENTORNO; `EJECUCIÓN:` declarada y modo real de la sesión; grafo copiado de §4; "sin subagentes"; topes), el slot vacío `## J. Juicio (lo rellena FASE L)` y el esqueleto de secciones. Después, cada medición con `esperado:` escrito **antes** de correr y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `git status --porcelain`; `git stash list` | vacío; vacío | regla 1 |
| M2 | `fetch`; `git rev-parse --short HEAD`; `git rev-list --count HEAD..origin/main`; `…origin/main..HEAD` | `6117393`; `0`; `0` | regla 2 |
| M3 | `md5` de `docs/index.html` y de `40_salidas/motor_idps.html` | ambos `6c5feab5428ed05dff09867f2b47bba3` | anota y sigue (ADVIERTE; no bloquea) |
| M4 | SHA-256 del payload (escribe `/tmp/s32_payload_sha.sh`, que extrae el contenido del `<script>` del payload y lo hashea; calibra: el mismo script sobre `docs/index.html` da el mismo hash, porque el md5 de ambos archivos es igual) | un hash de 64 hex, igual en los dos archivos | congela T4 |
| M5 | md5 del bloque `:root{…}` de la plantilla (awk en `/tmp/s32_root_md5.sh`) | un md5 | congela T1 y T2 |
| M6 | Líneas de declaración de `fmt`, `nEE`, `SLEPS_OPTS`, `NACIONAL_OPT` (`grep -n`), y si `SLEPS_OPTS`/`NACIONAL_OPT` son IIFE evaluadas al cargar (lectura de su forma) | `fmt` < `SLEPS_OPTS` < `NACIONAL_OPT` < `nEE`; las dos son IIFE | ajusta la mecánica de T1 (declarar el ayudante donde esté en ámbito antes del primer uso) y regístralo como decisión autónoma |
| M7 | Censo de plurales fijos en la plantilla: `grep -nE '\+ ?" (comunas\|establecimientos)\b' 30_procesamiento/35_motor_template.html` | exactamente 3 líneas (L1754, L1771, L2957 aprox.) | si hay más, **inclúyelas en T1** (mismo patrón, mismo alcance) y regístralo; si hay menos, congela T1 |
| M8 | **Caso malo dinámico (calibración de T1):** Puppeteer sobre el motor actual; abre el modal del comparador ("Agregar entidad a la comparación"), tab SLEP, y reúne el texto de todos los `.check-region`; cuenta coincidencias de `/(^\|\D)1 (comunas\|establecimientos)\b/` | ≥ 1 (Santiago Centro) | si 0, la hipótesis falló: busca otra entidad con 1 comuna o 1 establecimiento en el payload (en `page.evaluate` sobre `DATA`) y úsala como caso malo; si no existe ninguna, T1 sigue con el control plantado de T1.4 como única calibración y se registra |
| M9 | En `page.evaluate` sobre `DATA`: una comuna con exactamente 1 establecimiento en el nivel y año por defecto del panorama (para el `title` de exportación) | al menos una; anota su código (no su nombre) | si ninguna, el `title` se verifica solo estáticamente y se registra |
| M10 | **Caso malo de T2:** Puppeteer sobre el motor actual; abre el modal de territorio (botón `.terr-trigger`), presiona Tab hasta 40 veces y registra si `document.activeElement` llega a un `.check-row` | nunca llega (0 de 40) | si llega, T2 cambia de objetivo: congela T2 y registra |
| M11 | Lectura del hermano `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html` alrededor de ~L3945 (busca por el marcador de las filas del modal): ¿sus filas tienen `tabIndex`, `role`, `onKeyDown`? Cita las líneas literales en el log | se registra lo que haya (no hay valor esperado; es una lectura) | si el archivo no existe, congela T2 (la referencia vinculante no es accesible) |
| M12 | `grep -c 'check-row:focus-visible' docs/index.html` | `0` | si ≠ 0, elige otro testigo nuevo para el despliegue y anótalo |
| M13 | `sed -n` de §3 punto 5 de la decisión | contiene "el mínimo es 4,78:1" | congela T3 |
| M14 | `git ls-files \| grep -cE '\.(csv\|xlsx\|parquet\|rds)$'` | un número (se fija como valor del 🔒6) | — |

Último acto: anexar la sección `### FASE 0` con todas las filas.

## 6. T1: todo conteo visible pasa por un ayudante de plural

**Meta:** ninguna pantalla ni tooltip dice "1 comunas" o "1 establecimientos".

1. Paso 0: lee `fmt`, `nEE`, `SLEPS_OPTS`, `NACIONAL_OPT`, `_listaCmpEnt` y el `title` de la exportación del panorama.
2. Implementación:
   - Declara, junto a `fmt` (o donde M6 indique que queda en ámbito antes de su primer uso), dos ayudantes: `nEE=n=>fmt(n)+(n===1?" establecimiento":" establecimientos")` y `nCom=n=>fmt(n)+(n===1?" comuna":" comunas")`, con un comentario de una línea: "s32: todo conteo visible pasa por aquí (tres defectos de plural en tres sesiones)".
   - Elimina la declaración de `nEE` de ~L2613 y deja un comentario que remita a la nueva ubicación. Un solo `nEE` en el archivo.
   - Reemplaza los plurales de M7: `NACIONAL_OPT.sub` → `"Nivel nacional · "+nCom(coms.size)+" · "+nEE(ee)`; `sub` del tab SLEP → `nCom(s.ncom)+" · "+nEE(s.ee)` (gana además el formato de miles de `fmt`); `title` de exportación → `"Descarga en CSV "+(unidades.length===1?"el establecimiento":"los "+nEE(unidades.length))+" de esta vista, …"`, manteniendo el resto del texto literal. Si la redacción con `nEE` produce "los 1 establecimiento", resuélvelo con la forma singular completa ("el establecimiento de esta vista") y regístralo.
3. Verificación (con `esperado:` antes de cada comando):
   - T1.1 estático: `grep -cE '\+ ?" (comunas|establecimientos)\b' 30_procesamiento/35_motor_template.html` → `0`; `grep -c 'const nEE=' …` → `1`; `grep -c 'const nCom=' …` → `1`.
   - T1.2 dinámico, **el caso que lo motivó**: Puppeteer sobre un build temporal (`run_all(only = 35L)` escribe `40_salidas/motor_idps.html`; se commitea recién en T4) → tab SLEP del comparador: 0 coincidencias de la expresión de M8 y la fila de Santiago Centro (o la de M8) dice "1 comuna · N establecimientos"; tab Nacional: el `sub` se lee con `nCom`/`nEE` y sin error.
   - T1.3 el `title` de exportación con la comuna de M9 dice "el establecimiento de esta vista", y con el SLEP foco dice "los N establecimientos".
   - T1.4 **control positivo del censo:** el mismo script de T1.2 corrido sobre una copia en `/tmp` del motor a la que se le planta el texto "1 comunas" en un `.check-region` debe dar ≥ 1. Un censo que no dispara sobre el caso plantado no vale.
   - T1.5 caso bueno: sobre el motor anterior (M8), el mismo script da ≥ 1; sobre el nuevo, 0.
4. Cierre de fase en cinco pasos; commit `fix(motor): conteos visibles por nEE/nCom (s32 T1)` solo con la plantilla (el motor temporal **no** se commitea aquí; déjalo sin agregar y verifica en el chequeo de alcance que la única ruta commiteada es la plantilla).

## 7. T2: el modal de entidades se opera con teclado

**Meta:** con Tab y Enter (o Espacio) se elige una entidad sin mouse, en los dos usos de `EntityModal`.

1. Paso 0: relee `EntityModal` y lo citado del hermano en M11.
2. Implementación en `.check-row` (el `div` de ~L1628):
   - Si el hermano (M11) resuelve el teclado de sus filas, replica su mecánica y cita sus líneas en el comentario. Si no lo resuelve, aplica: `tabIndex={dis?-1:0}`; `role={multiple?"checkbox":"button"}`; `aria-checked` solo en múltiple (como hoy); `aria-disabled={dis||undefined}`; `onKeyDown` que, con `Enter` o `" "`, hace `preventDefault()` y ejecuta lo mismo que `onClick` (incluida la guarda `if(dis)return;`). Una sola función para clic y teclado, para que no diverjan.
   - CSS: `.check-row:focus-visible{outline:2px solid var(--foco);outline-offset:-2px;}` junto a las demás reglas de `.check-row` (token existente; ningún color nuevo; el comentario, si lo hay, sin `*/` interno).
   - Registra como decisión autónoma cualquier diferencia con el hermano (es la divergencia 13 del log s29 §36.7).
3. Verificación (Puppeteer, build temporal como en T1):
   - T2.1 **el caso que lo motivó**, modal de territorio (simple): abre con `.terr-trigger`, Tab hasta un `.check-row` (llega en ≤ 40), Enter → el modal se cierra y el texto de `.terr-trigger` cambia al de la entidad enfocada.
   - T2.2 modal del comparador (múltiple): Tab a una fila, Espacio → `aria-checked` pasa a `"true"` y `.modal-count` sube en 1; Espacio otra vez → el comportamiento es el mismo que el del clic hoy (regístralo tal cual; no lo cambies).
   - T2.3 tope: con la selección llena (tope `maxSel`), una fila `is-disabled` tiene `tabIndex=-1` y Enter sobre ella (forzando el foco con `focus()`) no cambia `.modal-count`.
   - T2.4 Escape sigue cerrando ambos modales.
   - T2.5 caso malo: el mismo script de T2.1 sobre el motor anterior falla en el paso Tab (coincide con M10).
4. Cierre de fase en cinco pasos; commit `fix(motor): filas del modal operables por teclado (s32 T2)`, solo la plantilla.

## 8. T3: enmienda de la decisión §3.5

**Meta:** la decisión dice el piso de la rampa continua y el mínimo realizado sobre puntajes enteros, los dos medidos en esta sesión y con su fuente.

1. Paso 0: lee en la plantilla la fórmula de la mezcla de color de la celda (dentro de `PanoramaHistorico`: `dom`, `k0`, mezcla hacia blanco del color del indicador) y la elección de texto (`txtSobre`, `TXT`, contraste WCAG). Transcribe esa fórmula **tal cual** a `/tmp/s32_rampa.R`.
2. Medición en R (`Rscript /tmp/s32_rampa.R`), con `esperado:` antes:
   - controles: contraste `#000000`/`#ffffff` → `21.00`; `#777777`/`#ffffff` → `4.48`;
   - rampa continua, k ∈ [k0, 1] con paso 0,001, los cuatro indicadores: mínimo de la mejor razón entre negro, `--gris` y blanco → esperado `4.58` (Autoestima, k ≈ 0,819);
   - puntajes enteros dentro de cada `dominio_color` (4b y 2m, leídos del payload con `jsonlite` tras decodificar zlib; o, si la decodificación en R no está disponible, del bloque `meta.vista_territorial` que produce `35_generar_motor_html.R`) → esperado `4.78` (puntaje 81, 4° básico).
   - Si alguna cifra difiere de su esperado, **no escribas la enmienda con la cifra nueva**: congela T3 y registra las dos cifras.
3. Enmienda del texto (§3 punto 5): reemplaza "En toda la rampa posible, el mínimo es 4,78:1 (Autoestima, en los tonos más oscuros de su rango; fuente: cálculo sobre la rampa, controles 21,00 y 4,48)" por "En la rampa continua el piso es 4,58:1 (Autoestima, k = 0,819); sobre los puntajes enteros del dominio calibrado, el mínimo realizado es 4,78:1 (puntaje 81, 4° básico) (fuente: `/tmp/s32_rampa.R`, s32, 2026-09-23; controles 21,00 y 4,48)". Agrega al final del documento una línea `**Enmienda s32 (2026-09-23):** §3.5 distinguía mal el piso de la rampa (4,58:1) del mínimo sobre puntajes enteros (4,78:1); detectado en la revisión s31b (log L274).` Nada más cambia en el archivo.
4. Verificación: `git diff --stat` del archivo = 1 archivo; `git diff` muestra solo esas dos zonas; `grep -c '4,58:1'` → `≥ 1`.
5. Cierre de fase; commit `docs(decision): enmienda §3.5, piso de la rampa 4,58:1 (s32 T3)`.

## 9. T4: build del motor

1. `git status --porcelain` → solo `40_salidas/motor_idps.html` o vacío.
2. Build (PRUEBAS a); SHA-256 del payload igual a M4 (🔒2); md5 del motor nuevo **distinto** de `6c5feab5…` (cambió la plantilla); `grep -c 'check-row:focus-visible' 40_salidas/motor_idps.html` → `≥ 1` si T2 se completó.
3. PRUEBAS b completa sobre el motor nuevo; T1.2, T1.3 y T2.1 repetidos sobre el motor commiteable.
4. Cierre de fase; commit `build(motor): s32 conteos y teclado`.

## 10. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario de afirmaciones auditables**, derivado del log: cada línea `Verificación:` y cada cifra de las secciones por fase, cada 🔒 con su comando y el alcance global. Numera `R-01`, `R-02`, … y anéxalo al log **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (p. ej., el censo de T1 por `grep` sobre el texto del motor construido además de Puppeteer; la rampa de T3 re-derivada en `node` si se midió en R; el teclado de T2 con `page.keyboard` en otra entidad distinta de la usada en T2.1).
3. **Invariantes 🔒:** el comando de cada uno (§3), PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ {`30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`, `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`, el LOG}; y `git status --porcelain` (lo no commiteado es hallazgo, no se limpia).
5. **Regresión completa:** PRUEBAS a, b y c sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la propia auditoría:** al menos una afirmación auditada contra un caso plantado (p. ej., un "1 comunas" plantado en una copia en `/tmp` del motor final, o un archivo fuera de alcance simulado en un diff de prueba) que demuestre que el instrumento dispara.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara, se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto del propio trabajo, dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada disponible); **ADVIERTE** (sin efecto sobre la meta o no medible aquí: se registra). Sin hallazgos: "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** por cada REPARA, causa raíz; fix quirúrgico en el ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla. Luego se repiten los pasos 2 a 5 sobre lo tocado. Lo que sobrevive al segundo ciclo, o cuya reparación destapa algo nuevo en otra parte, se congela y queda pendiente.
9. **Prohibido en la fase:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 11. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → vacío o solo el LOG; otra cosa se anota como hallazgo y no se limpia.
2. Completa las secciones de cierre: resumen; inventario de commits desde `git log <inicio>..HEAD --oneline`; tabla de auditoría; invariantes con PASA/FALLA; estado de cifras (SHA del payload antes/después, md5 del motor antes/después); dudas y pendientes consolidados con su pregunta cerrada; errores propios consolidados con su costo; notas para el revisor; estado de cierre. Anota además: **pendiente 3 del traspaso v30 cerrado sin cambios** (el traspaso ya usa "sin comparación publicada"), y el **testigo del próximo despliegue**: `check-row:focus-visible` (o el que haya fijado M12).
3. Rellena el bloque J (trece campos, una línea cada uno, copiados del detalle).
4. Grep de privacidad: `grep -nE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]' <LOG>` → vacío; sin nombres de personas. Los establecimientos se citan por RBD o conteo, no por nombre.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>` = fases ejecutadas (incluidas congeladas y FASE R); `grep -c '^esperado:' <LOG>` = `grep -c '^obtenido:' <LOG>`; `grep -c '^## J' <LOG>` = 1 con el bloque relleno. Si un conteo difiere, se anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s32 conteos, teclado y enmienda §3.5"`. Luego el `push` según la autorización.
7. Estado de cierre: qué quedó commiteado y pusheado, qué no se publica (el despliegue a `docs/` queda al titular tras su gate visual), hash del commit `docs(log)` (`git log -1 --format=%h`).

## 12. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual del log.
- Después: hashes, verificaciones con evidencia, lo que queda al titular (gate visual: Tab en el modal de territorio y el tab SLEP del comparador) y "lo que falló o sorprendió; si nada, decirlo explícitamente".
