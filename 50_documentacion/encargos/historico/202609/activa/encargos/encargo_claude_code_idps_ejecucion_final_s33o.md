# Encargo autónomo: base pequeña, defectos de la matriz, impresión, escáner y rama de contexto (s33o)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena que escribe en serie sobre la misma plantilla, dos ramas y tres push; `encargo_autonomo_claude_code_v1.md` §2.12, filas 2 y 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html`; `00_build.R`; `00_escanear_proyecto.R`; `40_salidas/motor_idps.html`; las decisiones `50_documentacion/activa/decisiones/20260925_decision_base_pequena.md` y `20260925_decision_exportacion_imagen.md` (vinculantes para T1 y T3); `50_documentacion/andamios/diseno/detalles/20260924_diagnostico_base_pequena.md` y su `.R`; `…/20260924_diagnostico_exportacion_imagen.md` y `…/mockup_exportacion_imagen_s33m.html` (referencia de las reglas de impresión); `50_documentacion/andamios/20260924_propuesta_ordenacion_repositorio.md`; `50_documentacion/andamios/20260924_matriz_patrones_motores.md` (§3.3 y §6); `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` §4.7 (local, no versionado); los logs de s33c, s33f, s33g, s33i, s33l y s33m en `50_documentacion/andamios/logs/` (instrumentos del modal, del censo de textos, de los CSV, de capturas y de impresión); la rama local `feat/contrato-contexto` (solo lectura).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`. `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33o_*`; ningún `echo ======` suelto en zsh). `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Con ventana, esperar el elemento visible antes de la primera acción. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Las dos ramas se trabajan en **worktrees** bajo `/tmp`, nunca cambiando la rama del árbol principal. Ningún shell en segundo plano queda corriendo al terminar. Localiza el código por marcadores, no por número de línea.
- **LOG:** `50_documentacion/andamios/logs/20260925_ejecucion_final_s33o_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío), `git rev-parse --short HEAD` y `git worktree list`. El hash del commit `chore(encargo): s33o, decisiones y registro del asistente s33` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y, después, `git status --porcelain` con **solo el motor y el LOG**; (b) PRUEBAS b de s33 (0 errores de consola y 0 `pageerror` con los dos modales, una ficha con vista histórica, una comparación de 10 entidades y cada exportación CSV); (c) hash del payload con la **convención §8.2 de s29** igual al de FASE 0; (d) los cuatro CSV de s33f M6 con **contenido** byte-idéntico (el nombre del CSV del comparador puede cambiar por T2.3).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. **Un push denegado (por el hook o por el clasificador de permisos) no se reintenta por ninguna otra vía:** se registra y el comando queda al titular.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify` ni `hooks.cartera false`; ningún comentario CSS con `*/` interno; **ningún color hex nuevo**; cada cifra visible nombra su universo (decisión de s33c); todo texto alargado se verifica también por su efecto en el ancho (`scrollWidth` frente a `clientWidth` de su contenedor), no solo por su contenido; los commits de la rama de ordenación y el cuerpo de su PR van sin atribución de coautoría a la herramienta (SETTINGS §4.7.3 punto 5).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, las dos decisiones `20260925_*` nuevas, ` M` de `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit), o `git worktree list` con más de una entrada → detén la sesión y pasa a FASE L.
3. Hash §8.2 del payload distinto del de FASE 0 en cualquier build → congela la tarea que lo produjo.
4. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
5. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
6. Un caso malo de M5 no se reproduce → congela la tarea que lo necesita y regístralo.
7. En un worktree, `here::here()` no resuelve a la raíz del worktree o faltan `here`/`fs` (M8) → congela T5; T6 sigue (su prueba no usa paquetes).
8. `git cherry-pick` de T6 con conflicto → `git cherry-pick --abort` y congela T6 (no se resuelven conflictos).
9. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo, del registro (filas 10 y 11 agregadas por el redactor), de las dos decisiones `20260925_*` y de la enmienda de `20260910_decision_contraste_texto_estado.md`, en un solo commit.
- `git commit` en `main` de los archivos del ALCANCE de T1 a T4, tras su cierre de fase.
- `git worktree add` de `/tmp/s33o_ord` (T5) y `/tmp/s33o_ctx` (T6), y `git worktree remove` de esos dos **solo** con su árbol limpio, al cerrar cada tarea.
- T5: `git commit` en la rama `ordenacion/20260925` de los archivos de su ALCANCE; `git push -u origin ordenacion/20260925` hasta **dos** veces (antes y después del marcador); `gh pr create` **una vez**, con base `main`. Sin merge.
- T6: `git cherry-pick aca50f7 19add55` en la rama nueva `feat/contrato-contexto-v2`; `git push -u origin feat/contrato-contexto-v2` **una vez**. Sin PR, sin merge. La rama local `feat/contrato-contexto` no se toca.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33o_*`; lectura y copia de los `/tmp/s33*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular **no** se despliega (`docs/` intacto), ni `rm` fuera de lo que haga `git worktree remove`, ni `reset`, `restore`, `checkout --`, `rebase` ni `branch -D`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `c872511`, la adenda del log de s33n, empujada por el titular (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-25; salida del push del titular `d41e31a..c872511`).
- Plantilla `1c3bfd6d3f36ae832846fdef358a4564`; motor y `docs/index.html` `7ad76f36e42d66c4da2d71aa28a558eb` (fuente: `md5sum` del redactor).
- El registro del asistente s33 tiene 11 filas; la 10 y la 11 las agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- `StackedBar({rep})` dibuja la misma barra en el comparador, en el panorama (vista actual) y en la franja de la vista histórica; `rep.N` y `rep.sin` ya existen; la nota `.s100-sin` ("+k sin comparación válida") va bajo la barra (fuente: `sed` del redactor sobre la plantilla, marcador `function StackedBar`).
- Ayudantes de plural existentes: `nEE` y `nCom` (fuente: `grep` del redactor, marcador `const nEE=`). No hay uno para indicadores.
- Defectos de `slep_idps` medidos por la matriz de s33n (fuente: `20260924_matriz_patrones_motores.md` §3.3 y §6): (fila 1) el chip de la tarjeta del panorama escribe "▼/▲ N indicadores … su GSE" sin plural, 19 veces "1 indicadores" en la apertura, y la cadena latente `" · "+nSubs+" subdimensiones"`; (fila 9) la fila Región de los dos modales usa `sub:nCom(COMUNAS_POR_REGION[…])` sin nombrar su universo, mientras las filas SLEP dicen "… en el directorio"; (fila 16) `descargarComparadorCSV` nombra el archivo `idps_comparador_<nivel>_<año>.csv` sin el sufijo de GSE que sí usan el panorama y la vista histórica (`sufijoGse`); (§6) en la tarjeta del radar de la ficha, un indicador con puntaje y `difgru` nulo dice "vs su GSE · sin dato" (el `Ancla` devuelve "sin dato" con `dif==null`).
- La plantilla no tiene reglas `@media print`; el motor imprime hoy el comparador de 10 entidades en 7 páginas A4, con la cuarta columna cortada y las barras sin relleno (fuente: diagnóstico s33m §3).
- `00_escanear_proyecto.R` define `DIRS_EXCLUIR <- c(".git", "renv", ".Rproj.user")` y escribe `50_documentacion/estructura/estructura_actual.{md,txt}` (versionados) (fuente: `grep` del redactor). No existe `50_documentacion/activa/50_ordenacion_repositorio.md` (fuente: propuesta s33m §0).
- `feat/contrato-contexto` = `61132e7` sobre la base `5aca951`; sus commits: `aca50f7` (productor del paso 36, su parquet y `contrato_contexto_v1.md`), `19add55` (enganche en `00_build.R`) y `61132e7` (normativos y `CLAUDE.md`, que `main` retiró del repositorio público). `00_build.R` no cambió en `main` desde la base (fuente: `git log`/`git diff --stat` de solo lectura del redactor). El parquet ya está autorizado en `main` (s33l, `dd52447`).
- `slep_idps.Rproj`, `.Rprofile` (que carga `renv/activate.R`) y `renv/activate.R` están versionados; la biblioteca de `renv` no (hipótesis, se mide en FASE 0, M8: un worktree no trae los paquetes).

**Decisiones del titular que este encargo implementa (sesión 33):**
- Base pequeña: `20260925_decision_base_pequena.md` (u = 5, `1 ≤ N < 5`, N de cada barra junto a la barra, asterisco y nota al pie, solo el comparador, N = 0 sin cambio).
- Exportación de imagen: `20260925_decision_exportacion_imagen.md`, alternativa (d); ahora solo C (impresión limpia, A4 horizontal, comparador, panorama y ficha, sin botón).
- Ordenación: lectura literal (L) del grep; con ella O-1, O-2 y N-1 a N-4 se cancelan, N-5 a N-7 no proceden, y se ejecutan **E-1 y E-2** del bloque 4. `.claude/` y `.DS_Store` no se excluyen (criterio delegado: ni §7.2 ni §4.7.2 los nombran). `activa/encargos/` queda como está (pregunta 5, alternativa c).
- Rama de contexto: variante b′, rama nueva desde `main` con solo `aca50f7` y `19add55`, publicada sin integrar.
- Los defectos de la matriz en `slep_idps` (filas 1, 9 y 16, y el "sin dato" del radar) se corrigen conforme a las reglas que el motor ya tiene (plural con ayudante; cada cifra nombra su universo; mismo sufijo de GSE en todos los CSV; nulo de `difgru` = "sin comparación válida").

## 2. Contexto mínimo

Motor HTML autocontenido de los IDPS. Este encargo reúne los cambios de interfaz pendientes de la sesión 33 en un solo build, más dos tareas de repositorio en ramas propias. El despliegue a `docs/` va en un encargo posterior, después del gate visual del titular.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 igual al de FASE 0 en todo build.
2. **Paletas intactas y sin hex nuevo:** md5 del `:root` igual al de FASE 0; hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **`sigdifgru` intacto:** líneas cambiadas con `sigdifgru` en el diff de la plantilla: **0/0**.
4. **Pipeline de datos intacto en `main`:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R 00_build.R 00_escanear_proyecto.R | wc -l` → `0`.
5. **`docs/` intacto:** `git diff --name-only <inicio>..HEAD -- docs | wc -l` → `0`.
6. **Las barras del panorama no cambian:** `textContent` y `aria-label` de cada `.s100-wrap` del panorama (vista actual, con y sin grilla, y franja de la vista histórica), para el territorio de apertura y para Región de Valparaíso en los dos niveles, idénticos antes y después.
7. **La pantalla no cambia por la impresión:** capturas a 1280 × 800 del comparador (10 entidades), del panorama y de la ficha, idénticas píxel a píxel entre la línea base del paso 1 de T3 y el estado posterior a T3.
8. **Exportaciones intactas:** PRUEBAS d.
9. **`main` no recibe las ramas:** `git merge-base --is-ancestor` de la punta de `ordenacion/20260925` y de `feat/contrato-contexto-v2` con `HEAD` de `main` falla para las dos.
10. **Foco y teclado siguen iguales:** los scripts de ciclo, devolución y respaldos de s33g dan lo mismo que en su log, en los dos modos.

## 4. Grafo de tareas y ALCANCE

- **T1** (base pequeña en el comparador) · ALCANCE: `30_procesamiento/35_motor_template.html`.
- **T2** (defectos de la matriz) · ALCANCE: `30_procesamiento/35_motor_template.html`. Requiere T1 cerrada (completada o congelada).
- **T3** (impresión limpia) · ALCANCE: `30_procesamiento/35_motor_template.html`. Requiere T2 cerrada.
- **T4** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere al menos una de T1 a T3 completada.
- **T5** (escáner y marcador de ordenación, rama `ordenacion/20260925` en `/tmp/s33o_ord`) · ALCANCE en la rama: `00_escanear_proyecto.R`, `50_documentacion/estructura/*` (lo que reescriba el escáner) y `50_documentacion/activa/50_ordenacion_repositorio.md`. Independiente de T1 a T4.
- **T6** (rama de contexto b′ en `/tmp/s33o_ctx`) · ALCANCE: la rama nueva; ninguna ruta del árbol principal. Independiente.
- Orden: T1 → T2 → T3 → T4 → T5 → T6. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito en el LOG **antes** de correr su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit; `git worktree list` | solo el LOG; vacío; el encargo, el registro, las dos decisiones nuevas y la enmienda; una entrada | regla 1 o 2 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD`; `git ls-remote origin 'refs/heads/*'` | `HEAD~1` = `c872511` = `origin/main`; `0`; `1`; sin `ordenacion/*` ni `feat/contrato-contexto*` | regla 2 |
| M3 | Instrumentos §8.2 y `:root` (copias de `/tmp/s33*` o reconstruidos desde el log de s33i si ya no existen); hash §8.2 con calibración; md5 del `:root`, de la plantilla y del motor | `eb4e00b3…4dc4`; igual con la fecha alterada; distinto con una cifra plantada; plantilla `1c3bfd6d…`; motor `7ad76f36…` | congela T4 si la calibración falla |
| M4 | Líneas base: 🔒6 (barras del panorama), 🔒10 (teclado), PRUEBAS d (los cuatro CSV con su nombre y md5), y el `textContent` completo de la apertura, del comparador de 10 entidades y de los dos modales (para el diff enumerado de T2) | registradas | congela T1 a T3 |
| M5 | **Casos malos:** (a) T1: en el comparador de 4° básico 2025 con las cuatro comunas del SLEP Costa Central, el SLEP y una región, cuántas barras tienen `1 ≤ N < 5` (del `title`) y cuántas muestran hoy un `N` visible; (b) T2: `grep -c` de "1 indicadores" en el texto visible de la apertura, texto de la fila Región de Valparaíso en los dos modales, nombre del CSV del comparador con solo el GSE Bajo visible, y el texto del ancla "vs su GSE" de un indicador con puntaje y `difgru` nulo (buscado en el payload); (c) T3: PDF A4 del comparador de 10 entidades con `page.pdf` sin fondos: páginas, presencia de "Saludable" en el texto del PDF, píxeles del rojo de "bajo" (instrumentos de s33m T2) y presencia de "Agregar territorio" | (a) > 0 y 0; (b) 19, sin "en el directorio", sin `_gse_`, "sin dato"; (c) 7 páginas, "Saludable" 0, píxeles cercanos a los 903 de s33m, "Agregar territorio" presente | regla 6 |
| M6 | Anchos de referencia: `scrollWidth` y `clientWidth` de `.table-wrap` y de cada celda de barra del comparador a 1280 y a 390 | registrados | — |
| M7 | Calibración de testigos para el despliegue: fijar **antes de editar** una cadena nueva por tarea (propuesta: el comentario `s33o T1: base pequeña`, `s33o T2: plural de indicadores`, `s33o T3: impresión`); `grep -c -F` de cada una en `docs/index.html` y en el motor actual | `0` y `0` para las tres | se elige otra cadena nueva y exclusiva, y se registra |
| M8 | Worktrees: `gh auth status`; en un worktree de prueba `/tmp/s33o_ord` (creado ya como el de T5), `Rscript -e 'cat(here::here(), .libPaths(), sep="\n")'`; si falla por la biblioteca de `renv`, una vez con `RENV_PATHS_LIBRARY=/Users/tomgc/Projects/slep_idps/renv/library` | `gh` autenticado; `here::here()` = `/tmp/s33o_ord` (o su `/private/tmp`), con `here` y `fs` cargables | `gh` no autenticado: T5 sigue sin PR (se registra); lo demás, regla 7 |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: base pequeña en el comparador

1. Paso 0: relee la decisión `20260925_decision_base_pequena.md` y M5 (a).
2. Edición: una constante `BASE_PEQUENA_U = 5` con comentario que cite la decisión y la cadena de M7; `StackedBar` recibe una prop opcional (por ejemplo `conN`) que **solo** pasa la celda del comparador. Con la prop y `N ≥ 1`: bajo la barra, "N = n" en la misma línea y el mismo estilo de la nota `.s100-sin` (si hay `sin`, las dos piezas comparten línea: "N = 26 · +2 sin comparación válida"); con `N < 5`, un asterisco tras el número ("N = 3*") y el `aria-label` y el `title` de la barra dicen "base pequeña: menos de 5 establecimientos con comparación válida". Una nota al pie del comparador, visible solo si alguna barra en pantalla está marcada: "* Base pequeña: menos de 5 establecimientos con comparación válida. Con tan pocos, un solo establecimiento mueve el reparto en 20 puntos o más." Con `N = 0`, nada cambia. Sin color ni opacidad nuevos.
3. Verificación (`esperado:` antes): M5 (a) repetido: cada barra con `N ≥ 1` muestra su `N`; las marcadas son exactamente las de `1 ≤ N < 5` según el `title`; N = 0 igual que antes; nota al pie presente con marcadas y ausente sin ellas (una comparación solo de regiones grandes); a 1280 y a 390, ninguna celda con `scrollWidth` > `clientWidth` y el ancho de `.table-wrap` igual a M6 (o, si crece, se registra la cifra y es hallazgo para el gate); contraste del texto nuevo ≥ 4,5:1 sobre los tres fondos de fila (§3.2 de `20260910_decision_contraste_texto_estado.md`); 🔒6; 🔒10; PRUEBAS b.
4. Commit `feat(motor): marca de base pequeña en el comparador, u = 5 (s33o T1)`.

### T2: defectos de `slep_idps` que midió la matriz

0. Paso 0: el `textContent` de las pantallas de M4 más la ficha del caso de M5 (b), medido sobre el estado tras T1 (línea base de T2).
1. **Plural de indicadores:** un ayudante `nInd` junto a `nEE` y `nCom`; el chip de la tarjeta ("▼/▲ n indicador(es) bajo/sobre su GSE", en el texto y en el `title`) y la cadena de subdimensiones lo usan. Comentario con la cadena de M7.
2. **Fila Región de los modales:** el `sub` de la fila Región, en los dos `buildList`, nombra su universo como las filas SLEP: "n comunas en el directorio" (con `nCom`).
3. **Nombre del CSV del comparador:** `descargarComparadorCSV` agrega `sufijoGse(<los GSE visibles>)` antes de `.csv`, con la misma regla que el panorama (se omite con los cinco). El contenido del CSV no cambia.
4. **Ancla de la ficha:** donde el `Ancla` de "vs su GSE" se dibuja para un indicador **con puntaje** y `difgru` nulo, el texto es "sin comparación válida" (la misma forma que el chip y la barra); "vs año anterior" y los indicadores sin puntaje no cambian.
5. Verificación (`esperado:` antes): M5 (b) repetido: "1 indicadores" 0 y "1 indicador bajo/sobre su GSE" > 0; fila Región con "en el directorio" en los dos modales y la fila cabe (el `scrollWidth` de la lista = `clientWidth`, criterio de s33i); CSV del comparador con solo Bajo → `_gse_…` en el nombre y con los cinco → nombre de hoy; contenido de los cuatro CSV = M4; el ancla del caso de M5 dice "sin comparación válida"; diff del `textContent` contra la línea base del paso 0: **solo** las cadenas de los puntos 1, 2 y 4; 🔒6; 🔒10; PRUEBAS b.
6. Commit `fix(motor): plural de indicadores, universo de la fila Región, sufijo GSE del CSV del comparador y ancla sin comparación (s33o T2, matriz s33n)`.

### T3: impresión limpia

1. Paso 0: relee `20260925_decision_exportacion_imagen.md` y las reglas de impresión del mockup de s33m; toma las capturas de línea base de 🔒7 sobre el estado tras T2 (antes de editar).
2. Edición: un bloque `@media print` y `@page { size: A4 landscape; margin: 12mm; }`, con comentario con la cadena de M7: ocultar navegación, pestañas, controles, botones, buscadores y modales; `print-color-adjust: exact` (y su prefijo `-webkit-`) en barras, muestras de color y glifos de estado; `break-inside: avoid` en cada bloque de GSE y en cada fila del comparador; los contenedores con `overflow-x:auto` (`.table-wrap`, `.vt-scroll`) pasan a `overflow: visible` al imprimir. Si las etiquetas "p% (n)" de los segmentos no caben al ancho de impresión, se re-mide en `beforeprint`/`afterprint` con el mismo `ResizeObserver` (sin cambiar la regla única de etiquetado de s29).
3. Verificación (`esperado:` antes): M5 (c) repetido para el comparador y además el panorama de apertura (vista actual y vista histórica) y una ficha: "Saludable" presente en el texto del PDF del comparador; los cuatro indicadores y el último año de la vista histórica presentes; píxeles del rojo de "bajo" muy por encima de M5 (con control: una copia en `/tmp` sin `print-color-adjust` vuelve a cerca de M5); "Agregar territorio" y los textos de los botones ausentes del PDF; páginas registradas por pantalla; con `emulateMediaType('print')` a 1.032 px de ancho, cada etiqueta dentro de su segmento cabe (instrumento de s29); **🔒7**; PRUEBAS b.
4. Commit `feat(motor): impresión limpia en A4 horizontal de comparador, panorama y ficha (s33o T3)`.

### T4: build

1. `git status --porcelain` → **solo el motor y el LOG** o vacío; otra ruta congela T4.
2. Build con PRUEBAS a; porcelain igual al del paso 1. PRUEBAS b, c y d; 🔒6, 🔒7 y 🔒10 sobre el motor commiteable.
3. Testigos para el despliegue: las cadenas de M7 de las tareas completadas (≥ 1 en el motor nuevo, 0 en `docs/index.html`), más los testigos de s33h (`focoRespaldo`, `Llegaste al tope de`, `s33i: el sub cede ancho`) con sus conteos, para que el encargo de despliegue los fije.
4. md5 del motor nuevo registrado. Commit `build(motor): s33o base pequeña, matriz e impresión`.

### T5: escáner y marcador de ordenación (rama propia, PR)

1. `git worktree add -b ordenacion/20260925 /tmp/s33o_ord origin/main` (si M8 ya lo creó, se usa ese). Precondiciones de SETTINGS §4.7.1 medidas en el worktree: árbol y stash vacíos, `origin/main...HEAD` = `0 0`.
2. **E-1 y E-2:** en `00_escanear_proyecto.R`, `DIRS_EXCLUIR` suma `"node_modules"`, `"packrat"`, `"venv"` y `".quarto"`. Grep de coautoría y de privacidad sobre el diff; commit `chore(escaner): excluye node_modules, packrat, venv y .quarto (ordenación, bloque 4: E-1 y E-2)`.
3. Escáner al final, en el worktree (con la variable de M8 si hizo falta); totales antes y después (esperado: iguales, 34 carpetas y 333 archivos según s33m, o los del escáner de hoy si difieren, registrados). Lo que reescriba en `50_documentacion/estructura/` va en un commit `docs(estructura): foto del escáner tras la ordenación`.
4. Primer push de la rama y `gh pr create --base main --head ordenacion/20260925` con título "Ordenación del repositorio: escáner (E-1, E-2)" y un cuerpo que cite la propuesta de s33m, la lectura L y las filas canceladas (O-1, O-2, N-1 a N-4 canceladas por L; N-5 a N-7 no proceden; bloques 1 a 3 sin movimientos), sin atribución de coautoría.
5. **Marcador:** `50_documentacion/activa/50_ordenacion_repositorio.md` con la fecha, la rama, el número del PR (o, si no hubo PR, "PR por abrir" y la URL de comparación), el conteo de archivos movidos por bloque (0, 0, 0, 0), el cambio del escáner, las filas canceladas y la referencia a la propuesta. Commit `docs(ordenacion): marcador de la ordenación (apaga el gatillo 4bis)`; segundo push.
6. Verificación: `git log --oneline origin/main..ordenacion/20260925` (tres commits); `git ls-remote` de la rama = su punta local; grep de coautoría vacío en los tres mensajes; 🔒9; `git worktree remove /tmp/s33o_ord` con el árbol limpio.

### T6: rama de contexto b′

1. `git worktree add -b feat/contrato-contexto-v2 /tmp/s33o_ctx origin/main`; `git cherry-pick aca50f7 19add55` (regla 8 ante conflicto).
2. Verificación: `git diff --stat origin/main...feat/contrato-contexto-v2` = exactamente `30_procesamiento/36_exponer_contrato_contexto.R`, `40_salidas/publico/contexto_idps.parquet`, `50_documentacion/activa/contrato_contexto_v1.md` y `00_build.R`; ningún normativo ni `CLAUDE.md`; md5 del parquet = el de la rama vieja; `Rscript --vanilla -e 'invisible(parse(file="…"))'` de los dos `.R` sin error.
3. El push autorizado; la salida literal del hook `pre-push` va al log. Verificación: `git ls-remote` = punta local; 🔒9; la rama vieja local sigue en `61132e7`; `git worktree remove /tmp/s33o_ctx`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada `Verificación:`, cada cifra, cada 🔒 con su comando, los casos malos y plantados (M3, M5, M7, el control de T3) y el alcance global de `main` y de cada rama. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación con un comando distinto del que la produjo (T1: `N` de 5 barras al azar recalculado desde el payload con el instrumento de s33m, frente al texto visible; T2: `grep` sobre el motor compilado además del DOM; T3: texto del PDF con otra herramienta, por ejemplo `pdftotext` o `mdls`; T5 y T6: `git show --stat` de cada commit de las ramas y `gh pr view`).
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE de T1 a T4 (más el LOG, el encargo, el registro y las decisiones); cada rama ⊆ su ALCANCE; `git status --porcelain`; `git worktree list` con una sola entrada.
5. **Regresión completa:** PRUEBAS a, b, c y d sobre el estado final, con `esperado:` y `obtenido:`.
6. **Control positivo de la auditoría:** el motor anterior (`7ad76f36…`) debe volver a dar los casos malos de M5 (a), (b) y (c) con el mismo instrumento.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, payload alterado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo del paso 6.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>` (si toca la plantilla, con rebuild y commit del motor); fila en la tabla. Cerrado el ciclo, repite los pasos 2 a 5 sobre lo tocado.
9. **Prohibido:** ajustar criterio, tolerancia o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita en el log; reparar un BLOQUEA; reescribir una rama ya empujada.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío); `git worktree list` → una entrada; otra cosa se anota como hallazgo y no se limpia. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits de `main` desde `git log <inicio>..HEAD --oneline` y de cada rama; tabla de auditoría; invariantes; estado de cifras (hash §8.2 en cada build; barras marcadas en el caso de M5; anchos antes y después; páginas de impresión antes y después por pantalla); testigos y md5 para el despliegue; salida de cada push y del PR; decisiones del titular registradas (§1); dudas con pregunta cerrada; errores propios con su costo; notas para el revisor; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle. El resultado del push de `main` no se afirma en el J.
4. Privacidad: grep de RUT con un script que guarda el patrón fuera del log (`/tmp/s33o_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el log (nombres de SLEP, comuna y región sí); la estación se registra como "estación del titular".
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'` = fases ejecutadas; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1 con el bloque relleno. Si difiere, anexa lo faltante con su estado real.
6. `git add <LOG>` y `git commit -m "docs(log): s33o ejecución final"`; luego el push de `main` según la autorización.
7. Estado de cierre en el reporte: qué quedó commiteado y pusheado en `main` y en cada rama; número del PR; testigos y md5 para el despliegue; hash del commit `docs(log)`.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal de los push y `rev-list` final de `main`; número del PR de ordenación; md5 del motor nuevo y sus testigos para el despliegue; lo que queda al titular para el gate visual (el comparador de 4° básico 2025 con las comunas del SLEP Costa Central, una ficha con un indicador sin comparación válida, y la vista previa de impresión del comparador); cualquier push denegado con su comando; "lo que falló o sorprendió; si nada, decirlo".
