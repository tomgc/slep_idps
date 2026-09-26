# Encargo autónomo: la ficha abre arriba y cada vista recupera su posición al volver (s34b)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (`encargo_autonomo_claude_code_v1.md` §2.12, filas 1 y 2: cadena que escribe en serie y termina en despliegue).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `30_procesamiento/35_motor_template.html` (marcadores: `const {useState, useMemo, useRef, useEffect, useLayoutEffect} = React;`, `const DIRECCION_VISTA`, `const vistaDesdeDireccion`, `const [pantalla,setPantalla]`, `window.history.pushState(null,"",DIRECCION_VISTA[pantalla])`, `window.addEventListener("hashchange",alCambiar)`, `const irFicha`, `const onPick`, `className="screen-tab`, `Ir a Panorama territorial`, `className="ficha-name"`, `.app-nav{…position:sticky;top:0…}`); el log `50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` (instrumento, definiciones y mecanismo medido: FASE 0 "Instrumento" con la corrección R-20, T1, T2 y FASE R pasos 2 (c) y 2 (d)); el instrumento `/tmp/s34a_atras.js` y su resumen `/tmp/s34a_resumen.py`; los instrumentos de pantalla idéntica de s33u (`/tmp/s33u_pant7.js` y los scripts `/tmp/s33u_m4x.sh`, descritos en `50_documentacion/andamios/logs/20260925_verificacion_direcciones_s33u_log.md`, M4); `tests/verificar_motor.R`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps` en los comandos; ningún comando asume `cd`. `bash` explícito; los anexos al LOG se escriben desde archivos; ningún script se edita mientras corre. Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, `file://`) **siempre headless** con `--disable-gpu`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. **Si el build de T3 corre después de la medianoche, la prueba de build corre en un clon** (`/tmp/s34b_clon`), no en el árbol.
- **Convención de pantalla idéntica (vigente desde s33s y s33t):** captura con `--disable-gpu` y el puntero fuera de la página; página completa hasta 16.384 px y tramos de 8.000 px más arriba; **antes de cada captura, `window.scrollTo(0,0)` en los dos motores** (la barra `.app-nav` es `sticky` y dibuja según la posición); una pantalla pasa si alguna de hasta tres capturas del motor nuevo es idéntica píxel a píxel a alguna de dos capturas de `docs/index.html`; la corrida completa admite un reintento; con control positivo.
- **LOG:** `50_documentacion/andamios/logs/20260926_ficha_arriba_s34b_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s34b` es `<inicio>`.
- **PRUEBAS:** (a) `Rscript /Users/tomgc/Projects/slep_idps/tests/verificar_motor.R; echo "rc=$?"` → `rc=0` (hash §8.2 `eb4e00b3…4dc4`, 16/16 celdas ancla, red 0; antes del despliegue informa "distintos" entre motor y `docs/`, como corresponde); (b) build `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all(only = 35L)'` con exit 0 y 0 warnings; (c) 0 errores de consola y 0 `pageerror` en los recorridos de T2 y de 🔒4.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ningún color hex nuevo; la plantilla no gana dependencias ni peticiones de red. El LOG no lleva RBD ni nombres de establecimiento (tarjetas y filas por índice; textos por md5).

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, `50_documentacion/andamios/logs/20260926_registro_asistente_s34.md`} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. md5 de `docs/index.html` distinto de `c5542b2013b6fb6e5d42f709ca723c3c` en FASE 0 → detén la sesión y pasa a FASE L.
4. **Calibración (M5):** el instrumento no da C3 en falla y C2 en pasa sobre `docs/index.html`, o no detecta el desplazamiento plantado → congela T1 a T4 (un instrumento que no dispara no mide).
5. Hash §8.2 distinto en cualquier build → congela la tarea que lo produjo.
6. **Pantalla:** tras el tope de intentos, alguna pantalla de 🔒4 distinta de `docs/` → congela T4 (sin despliegue); la plantilla queda con el cambio de T2 commiteado y se registra como duda.
7. Algún criterio C1 a C6 en falla sobre el motor nuevo tras el tope de 3 intentos de T2 → congela T3 y T4; la plantilla vuelve al estado de `<inicio>` con `git revert` del commit de T2.
8. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
9. Una tarea que necesita tocar fuera de su ALCANCE → congela esa tarea.
10. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo y de `50_documentacion/andamios/logs/20260926_registro_asistente_s34.md` (`chore(encargo): s34b y registro del asistente s34`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- T4: `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` una vez, solo con la regla 6 superada y C1 a C6 en pasa sobre el motor final.
- `git revert <hash>` de un commit propio, si la regla 7 o FASE R lo exigen.
- `git clone` del repo en `/tmp/s34b_clon`, solo si el build cruza la medianoche.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s34b_*`; lectura y copia de `/tmp/s34a_*` y `/tmp/s33u_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, ni cambios en el generador, el pipeline, los datos, `tests/` o `renv.lock`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `a0f8b33` (`docs(log): s34a atrás tras desplazarse`) y el único cambio del árbol es `?? 50_documentacion/andamios/logs/20260926_registro_asistente_s34.md` (fuente: `.git/refs` y `GIT_OPTIONAL_LOCKS=0 git status --porcelain`, redactor, 2026-09-26; este encargo se suma como segundo `??`).
- Motor, `docs/index.html` y sitio = `c5542b2013b6fb6e5d42f709ca723c3c`; md5 de la plantilla `12795856c2f9a0de4b6118eac5760f02` (fuente: `md5sum` y `openssl md5` del redactor; el sitio, con `curl` al abrir la sesión).
- **Lo que s34a midió sobre el motor publicado** (fuente: log s34a, T1, T2 y FASE R): Atrás vuelve al panorama con la dirección de antes (C1) y a la misma posición (C2, `Δ = 0`) en 19 recorridos; **la ficha abre en la posición vertical que tenía el panorama** (C3 en falla: con la tarjeta 36, `.ficha-name` a −4.319 px a 1280 y −15.856 px a 390); la plantilla no desplaza la página por su cuenta (`scrollTo|scrollIntoView|scrollRestoration|scrollY|pageYOffset` → 0) y la posición la decide el navegador; en simulación, un `window.scrollTo(0,0)` al abrir la ficha rompe C2: antes de escribir la dirección, Atrás vuelve arriba (`Δ = −Y0`); después, cae en otro lugar (`Δ` +2.003 px a 1280, +8.769 a 390).
- El cambio de vista escribe la dirección en `useEffect(()=>{if(vistaDesdeDireccion()!==pantalla){try{window.history.pushState(null,"",DIRECCION_VISTA[pantalla]);}catch(e){}}},[pantalla]);` (L3582) y Atrás o Adelante llegan por `hashchange` (L3584-3585), que fija `pantalla` sin escribir (fuente: `sed -n '3531,3600p'` y `grep -n` del redactor).
- Caminos hacia adelante que cambian de vista, todos por `setPantalla(`: `irFicha` (L3598; tarjetas `.card` y botones `.vt-ee-btn`), `onPick` con un establecimiento (L3613; búsqueda del modal), las pestañas `.screen-tab` (L3701) y "Ir a Panorama territorial" (L3831) (fuente: `grep -n "setPantalla("` del redactor, 5 líneas).
- `useLayoutEffect` ya está disponible (L838) y `.app-nav` es `position:sticky;top:0` (L104) (fuente: `grep -n` del redactor).
- El testigo `s34b: posición por vista` da `0` en `docs/index.html` y en la plantilla (fuente: `grep -c` del redactor; `s34b` suelto aparece 1 vez en `docs/` dentro del payload base64, por eso el testigo es la frase completa).
- El instrumento de s34a y los de pantalla idéntica de s33u siguen en `/tmp` (hipótesis, se mide en FASE 0, M3; si faltan, se reescriben siguiendo sus logs y se recalibran en M5 y M6).

**Decisiones del titular (sesión 34):**
- **D-1 de s34a, (a):** C1 se lee "tras Atrás, la dirección es la que tenía la vista al salir y lleva a esa vista" (abriendo sin dirección, vacía). La apertura sin dirección sigue sin escribir nada en la dirección (s33u).
- **D-2 de s34a, (b):** la ficha abre arriba y Atrás repone la posición del panorama. **Regla que se implementa (forma estándar de la web, criterio delegado):** toda vista a la que se llega **hacia adelante** (tarjeta, fila de la histórica, búsqueda, pestaña, "Ir a Panorama territorial") abre **arriba**; toda vista a la que se llega con **Atrás o Adelante** recupera **la posición en que se dejó** esa entrada del historial.
- **D-5 de s34a, (b):** el instrumento de s34a se usa desde `/tmp` como medio de verificación; no se versiona (sería JavaScript en el repo).

## 2. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** PRUEBAS a, `rc=0`, con `HASH_ESPERADO` sin cambios (`git diff <inicio>..HEAD -- tests | wc -l` → `0`).
2. **Paletas intactas y sin hex nuevo:** md5 del bloque `:root{…}` de la plantilla igual al de FASE 0 (`04b2876e…` según el traspaso v32; se re-mide en FASE 0); hex en líneas agregadas del diff `-U0` de la plantilla: **0**.
3. **Generador, pipeline y datos intactos:** `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento/3[1-4]* 30_procesamiento/35_generar_motor_html.R 30_procesamiento/36_* 40_salidas/publico 40_salidas/intermedios renv.lock tests | wc -l` → `0`.
4. **La pantalla no cambia:** con la convención de §0, las pantallas de s33u 🔒4 (comparador de 10 entidades y selección del SLEP Costa Central, panorama en sus dos vistas para el territorio de apertura y la Región de Valparaíso, una ficha) a 1280 × 800 y 390 × 800, llegando por los mismos clics que en FASE 0, idénticas a `docs/index.html`; e inventario de barras idéntico.
5. **Exportaciones intactas:** md5 de los CSV y SVG que s33u usó como línea base (medidos de nuevo en FASE 0 desde `docs/`) iguales en el motor nuevo.
6. **Sin red:** `grep -c 'src="http\|href="http\|text/babel'` en el motor → `0` (también lo mide PRUEBAS a).

## 3. Grafo de tareas y ALCANCE

- **T1** (calibración sobre `docs/`) · ALCANCE: el LOG y `/tmp/s34b_*`. Independiente.
- **T2** (implementación) · ALCANCE: `30_procesamiento/35_motor_template.html`. Requiere T1 completada (sin instrumento calibrado no hay criterio).
- **T3** (build) · ALCANCE: `40_salidas/motor_idps.html`. Requiere T2 completada.
- **T4** (despliegue) · ALCANCE: `docs/index.html`. Requiere T3 y la regla 6 superada.
- Orden: T1 → T2 → T3 → T4. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 4. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado (encargo y registro). Segundo acto: crear el LOG (`mkdir -p`; encabezado; slot `## J. Juicio (lo rellena FASE L)`; esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `a0f8b33` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 de `docs/`, motor y plantilla; PRUEBAS a; existencia de `/tmp/s34a_atras.js`, `/tmp/s34a_resumen.py`, `/tmp/s33u_pant7.js`; `node` resuelve `puppeteer`; Chrome presente; md5 del `:root` | `c5542b20…` ×2 y `12795856…`; `rc=0`; sí ×3 (si no, se reescriben y la calibración M5/M6 decide); sí; sí; registrado | regla 3 / congela T1 |
| M4 | Líneas base desde `docs/`: 🔒4 (capturas e inventario) y 🔒5 (md5 de exportaciones) | registradas | congela T4 |
| M5 | **Caso malo conocido de C3 y bueno de C2:** R1 de s34a (tarjeta `floor(0,6 × n)`, clic, 1280 y 390) sobre `docs/index.html` | C1 y C2 **pasan**; C3 **falla** (`.ficha-name` fuera del viewport, `scrollY` de la ficha = `Y0`) | regla 4 |
| M6 | **Caso malo conocido de C2:** el mismo R1 con la simulación "después" de s34a (envolver `history.pushState` en la página para llamar `window.scrollTo(0,0)` justo después) | C3 **pasa** y C2 **falla** (`Δ` ≠ 0) | regla 4 |
| M7 | Testigo `s34b: posición por vista` | `0` en `docs/` y en la plantilla | se elige otro y se registra |

Último acto: anexar la sección `### FASE 0`.

## 5. Criterios (definidos antes de codificar; calibrados en M5 y M6)

Con las definiciones del log s34a (viewport, tarjeta o fila de origen por índice, "antes", `TOL_PX = 1`):

- **C1 (vuelve a la vista):** tras Atrás, `location.hash` es el que tenía la vista al salir, la pestaña activa es la de esa vista y el md5 del banner es el de antes (D-1 (a)).
- **C2 (vuelve al lugar):** tras Atrás, `|scrollY_después − scrollY_antes| ≤ TOL_PX` y la tarjeta o fila de origen, la misma, está dentro del viewport.
- **C3 (la ficha abre arriba):** al entrar a la ficha hacia adelante (tarjeta, fila `.vt-ee-btn`, búsqueda del modal), `scrollY ≤ TOL_PX` y `.ficha-name` dentro del viewport.
- **C4 (Adelante recupera la ficha):** tras Atrás y Adelante, `#ficha`, la misma ficha (md5 de `.ficha-name`) y el `scrollY` que tenía la ficha al salir, `± TOL_PX`, con dos casos: sin desplazar la ficha (0) y desplazándola 1.000 px antes de Atrás (1.000).
- **C5 (pestaña hacia adelante abre arriba; Atrás recupera):** con la ficha desplazada 1.000 px, clic en la pestaña del comparador → comparador con `scrollY ≤ TOL_PX`; Atrás → `#ficha` con `scrollY` 1.000 `± TOL_PX`; Atrás → panorama con C1 y C2.
- **C6 (apertura intacta):** abrir sin dirección deja `location.href` sin fragmento, `history.length` igual al de `docs/` y la página en `scrollY` 0; abrir con `#comparador` y `#ficha` abre esa vista (como en s33u).

## 6. Tareas

### T1: calibración del instrumento sobre `docs/`

1. Copia `/tmp/s34a_atras.js` y `/tmp/s34a_resumen.py` a `/tmp/s34b_*` y agrega los recorridos que C3 a C6 necesitan (búsqueda del modal hacia la ficha; ficha desplazada 1.000 px; pestaña del comparador; apertura sin dirección y con dirección). No cambies las definiciones de s34a.
2. Corre M5 y M6 con la versión copiada (y los recorridos nuevos sobre `docs/`, como línea base: se espera C3 en falla y C4/C5 en lo que dé, anotado tal cual).
3. Cierre de fase: porcelain (solo el LOG); sección `### FASE T1`. Sin commit propio.

### T2: la ficha abre arriba y cada vista recupera su posición

1. Paso 0: relee L3576-3598 y los cinco `setPantalla(`; relee el mecanismo medido en s34a (FASE R, pasos 2 (c) y 2 (d)): el navegador restaura la posición en `popstate`, cuando la página todavía es la vista que se deja, y un `scrollTo(0,0)` suelto rompe esa restauración.
2. Edición (un solo lugar para la regla, comentado con la cadena de M7): la posición se gestiona desde el motor, no desde el navegador. **Diseño sugerido (el ejecutor puede elegir otro que cumpla C1 a C6):** `history.scrollRestoration = "manual"`; un identificador por entrada del historial en `history.state` (la entrada inicial lo recibe con `history.replaceState` **sin cambiar la dirección**, lo que C6 verifica); un mapa en memoria identificador → última posición, actualizado al desplazarse; en el cambio de vista hacia adelante (la rama que hoy llama a `pushState`), guardar la posición de la entrada actual, escribir la nueva entrada con su identificador y llevar la página arriba **después de que la vista nueva esté dibujada** (`useLayoutEffect`, sin un cuadro visible en la posición vieja); en `hashchange`, fijar la pantalla y, después de dibujarla, reponer la posición guardada para esa entrada (si no hay, arriba). Nada de esto viaja en la dirección: la dirección sigue siendo solo la vista.
3. Verificación (`esperado:` antes): C1 a C6 en pasa sobre el motor de una **build de prueba en `/tmp/s34b_*`** (la build versionada es T3), en R1 (clic y teclado), R2, R3, R4 de s34a y los recorridos de C3 a C6, a 1280 y a 390; 🔒2; hex nuevo 0; PRUEBAS c; y re-medir M6 **sobre el motor nuevo** para comprobar que el instrumento sigue discriminando.
4. Commit `feat(motor): la ficha abre arriba y cada vista recupera su posición al volver (s34b, D-2 de s34a)`.

### T3: build

1. `git status --porcelain` → solo el LOG o vacío. Build con PRUEBAS b (en clon si pasó la medianoche); PRUEBAS a sobre el motor nuevo; C1 a C6 sobre `40_salidas/motor_idps.html`; 🔒4 y 🔒5; testigo M7 (≥ 1 en el motor, 0 en `docs/`); md5 del motor nuevo.
2. Commit `build(motor): s34b posición por vista`.

### T4: despliegue

1. Regla 6 sobre el motor final. La copia autorizada. Verificación: PRUEBAS a entero con motor = `docs/`; testigo igual en los dos; C3 y C2 sobre `docs/index.html` (R1, clic, 1280 y 390). Commit `deploy(docs): la ficha abre arriba y cada vista recupera su posición (s34b)`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada verificación, cada cifra, cada 🔒, M1 a M7, C1 a C6 por recorrido y ancho, y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** un recorrido mínimo escrito aparte (como `/tmp/s34a_r_atras.js` de s34a: posición leída con `document.scrollingElement.scrollTop`, vuelta con `history.go(-1)` desde la página) sobre el motor final, con otra tarjeta (`floor(0,3 × n)`) y con la tarjeta más baja; los criterios recalculados desde los estados crudos con código propio; y una lectura dirigida: **¿queda algún camino hacia adelante que cambie de vista sin llevarla arriba, o alguna escritura de la dirección al abrir sin dirección?** Si la hay, es hallazgo REPARA.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a a c.
6. **Control positivo:** el recorrido del paso 2 sobre `docs/` de FASE 0 (copia `/tmp/s34b_motor_antes.html`, md5 `c5542b20…`) debe fallar C3.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`, rebuild y, si ya se desplegó, un segundo despliegue solo con la regla 6 superada.
9. **Prohibido:** ajustar un criterio, `TOL_PX` o un esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits (`git log <inicio>..HEAD --oneline`); auditoría; invariantes; tabla consolidada de C1 a C6 por recorrido y ancho, en `docs/` antes y en el motor final; salida literal de PRUEBAS a final; md5 y testigo; dudas con pregunta cerrada (incluida, si cambió, la conducta al recargar la página); errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: `grep -nE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]' <LOG>` → vacío, con control plantado en una copia en `/tmp`; `grep -nE 'RBD [0-9]' <LOG>` → vacío; ningún nombre de establecimiento (mismo chequeo de s34a, paso 4 de FASE L).
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>` = fases ejecutadas; `grep -c '^esperado:' <LOG>` = `grep -c '^obtenido:' <LOG>`; `grep -c '^## J' <LOG>` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s34b ficha arriba y posición por vista"`; luego el push según la autorización.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: la tabla de C1 a C6 antes y después; salida del push; md5 publicado; salida de PRUEBAS a; "lo que falló o sorprendió; si nada, decirlo".
