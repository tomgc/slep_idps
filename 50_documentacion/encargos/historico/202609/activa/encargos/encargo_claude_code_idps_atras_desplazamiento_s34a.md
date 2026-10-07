# Encargo autónomo: medir Atrás después de desplazarse por el panorama (s34a)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (`encargo_autonomo_claude_code_v1.md` §2.12, fila 5: medición de pocos recorridos, sin unidades separables).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **Naturaleza:** **medición de solo lectura.** No se edita la plantilla, el generador, el motor ni `docs/`; no hay build ni despliegue. Si la medición muestra un defecto, se registra como duda con pregunta cerrada: el remedio es decisión del titular y va en otro encargo.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `docs/index.html` (motor publicado); `30_procesamiento/35_motor_template.html` (solo lectura, marcadores: `const DIRECCION_VISTA`, `const vistaDesdeDireccion`, `const [pantalla,setPantalla]`, `window.history.pushState`, `addEventListener("hashchange"`, `const irFicha`, `function Card(`, `className="pan-grid"`, `className="vt-ee-btn"`, `className="ficha-name"`, `className="screen-tabs"`, los botones `Vista actual` / `Vista histórica` de clase `lvl-b`); el motor anterior a las direcciones, que se extrae de git con `git show b97d76d:docs/index.html` (caso malo de calibración); `tests/verificar_motor.R`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps` en los comandos; ningún comando asume `cd`. `bash` explícito; los anexos al LOG se escriben desde archivos. Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor abierto por `file://`) **siempre headless**, con `--disable-gpu`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s34a` es `<inicio>`.
- **PRUEBAS (sin arnés de interfaz; sustituto declarado):** `Rscript /Users/tomgc/Projects/slep_idps/tests/verificar_motor.R; echo "rc=$?"` → `rc=0` al abrir (FASE 0) y al cerrar (FASE R). Como el encargo no toca código, la regresión prueba que nada cambió.
- **Topes de esfuerzo:** 3 intentos por instrumento que falla (al tercero, la medición se congela con la evidencia); 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`. El LOG no lleva RBD ni nombres de establecimiento: las tarjetas se identifican por su **índice** en la grilla.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. md5 de `docs/index.html` distinto de `c5542b2013b6fb6e5d42f709ca723c3c` en FASE 0 → detén la sesión (se estaría midiendo otro motor) y pasa a FASE L.
4. **Calibración:** el instrumento no falla sobre el caso malo (M5) o no detecta el desplazamiento plantado (M6) → congela T1 y T2 (un instrumento que no dispara no mide).
5. Cualquier escritura en el árbol fuera del LOG (medida por `git status --porcelain`) → congela la tarea que la produjo.
6. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s34a`).
- `git show b97d76d:docs/index.html > /tmp/s34a_motor_s33t.html` (lectura de git hacia un temporal).
- Archivos temporales en `/tmp/s34a_*` (instrumentos, copias, capturas).
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Implícitas del patrón: `fix(auditoria): R-NN …` (solo sobre el LOG o los temporales) y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --`, ni cambios en la plantilla, el generador, el motor, `docs/`, el pipeline, los datos, `tests/` o `renv.lock`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `8ddd6c8` (`chore(estado): abre sesion`) (fuente: `.git/refs/heads/main` leído por el redactor el 2026-09-26; el commit `chore(encargo): s34a` quedará encima).
- Motor, `docs/index.html` y sitio en línea = `c5542b2013b6fb6e5d42f709ca723c3c` (fuente: `openssl md5` sobre los dos archivos y `curl` + `md5sum` del sitio, redactor, 2026-09-26).
- El motor anterior a las direcciones (s33t) está en `b97d76d:docs/index.html`, md5 `b3daf503514a49b56426339e75fb7d82` (fuente: `git show b97d76d:docs/index.html | md5sum` del redactor, con `GIT_OPTIONAL_LOCKS=0`).
- La plantilla no desplaza la página por su cuenta: `scrollTo|scrollIntoView|scrollRestoration|scrollY|pageYOffset` → `0` (fuente: `grep -c` del redactor sobre `35_motor_template.html`). La posición de la página al cambiar de vista y al volver la decide solo el navegador.
- Cambiar de vista escribe la dirección con `window.history.pushState(null,"",DIRECCION_VISTA[pantalla])` si difiere; Atrás y Adelante llegan por `hashchange`, que fija `pantalla` con `setPantalla(vistaDesdeDireccion())` (fuente: `sed -n '3531,3600p'` del redactor sobre la plantilla, L3539, L3582 y L3584-3585).
- Hay dos caminos del panorama a la ficha, ambos por `irFicha` (L3598): una tarjeta `.card` (`role="button"`, dentro de `.pan-grid`) en la vista actual, y el botón `.vt-ee-btn` de la matriz en la vista histórica (fuente: `grep -n` del redactor; `function Card(` L1010, `.pan-grid` L3815, `.vt-ee-btn` en `PanoramaHistorico`, L3390 + 110).
- El estado del panorama (`terr`, `vistaPan`, `panGrado`, `gseVis`) vive en `App` y no se desmonta al pasar a la ficha (fuente: lectura del redactor de L3552-3603). Por eso el territorio y la vista deberían sobrevivir a Atrás (hipótesis, se mide en T1 y T2).
- `.ficha-name` es el nombre de la ficha (`tabIndex={-1}`), y sirve para medir si la ficha abre arriba o a media página (fuente: `grep -n` del redactor, L1645 del componente de la ficha).
- La apertura por defecto muestra el panorama del SLEP Costa Central en vista actual con tarjetas suficientes para desplazarse al menos una pantalla completa a 1280 × 800 y a 390 × 800 (hipótesis, se mide en FASE 0, M4).

**Decisión del titular (sesión 34):** D-5 de s33u se resuelve con la opción (b), "encargo para medir"; este encargo mide y **no** corrige.

## 2. Invariantes 🔒 (cada uno con su comando)

1. **Motor y `docs/` intactos:** `openssl md5 /Users/tomgc/Projects/slep_idps/docs/index.html /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html` → los dos `c5542b2013b6fb6e5d42f709ca723c3c`, en FASE 0 y en FASE R.
2. **Nada versionado cambia salvo el encargo y el LOG:** `git -C /Users/tomgc/Projects/slep_idps diff --name-only <inicio>..HEAD` ⊆ {el LOG}; `git -C /Users/tomgc/Projects/slep_idps status --porcelain` vacío al final.
3. **Dato intacto:** PRUEBAS (`rc=0`).

## 3. Grafo de tareas y ALCANCE

- **T1** (Atrás desde la vista actual) · ALCANCE: el LOG y `/tmp/s34a_*`. Independiente.
- **T2** (Atrás desde la vista histórica, Adelante y una cadena de tres vistas) · ALCANCE: el LOG y `/tmp/s34a_*`. Independiente de T1 (comparte instrumento, que se escribe en FASE 0).
- Orden: T1 → T2. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre, aunque una tarea quede congelada.

## 4. FASE 0: apertura del log, instrumento y calibración

Primer acto: el commit autorizado. Segundo acto: crear el LOG (`mkdir -p`; encabezado con meta, fecha, rama, `<inicio>`, ENTORNO, EJECUCIÓN, grafo, topes; slot `## J. Juicio (lo rellena FASE L)`; esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después.

**Instrumento** (`/tmp/s34a_atras.js`, Puppeteer headless, `--disable-gpu`, viewport indicado, puntero fuera de la página). Por recorrido registra, en cada estado: `location.hash`; la pestaña activa (`.screen-tab.is-active`, su texto); el texto del banner del territorio (para comparar, sin anotarlo en el LOG: se anota su md5); `window.scrollY`; `document.documentElement.scrollHeight`; y, para la tarjeta o fila de origen (por su índice), `getBoundingClientRect().top` y si está dentro del viewport. Espera cada cambio de vista por el selector de la vista nueva, no por un tiempo fijo; después de cada Atrás o Adelante, espera además dos `requestAnimationFrame`. Tolerancia nombrada en el script: `TOL_PX = 1`.

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | vacío salvo el LOG; vacío; solo este encargo | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `8ddd6c8` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 de `docs/index.html` y del motor; PRUEBAS; `node` y el `NODE_PATH` resuelven `puppeteer`; Chrome del sistema presente | los dos `c5542b20…`; `rc=0`; sí; sí | regla 3 / congela T1 y T2 |
| M4 | Al abrir `docs/index.html` sin hash, a 1280 × 800 y a 390 × 800: `scrollHeight − innerHeight` y número de `.card` en `.pan-grid` | `scrollHeight − innerHeight` ≥ `innerHeight` y ≥ 8 tarjetas en los dos anchos | regla 6 (sin recorrido largo la medición no dice nada) |
| M5 | **Caso malo:** el recorrido R1 de T1 sobre `/tmp/s34a_motor_s33t.html` (md5 `b3daf503…`, extraído con la autorización) | criterio C1 **falla** (Atrás no vuelve al panorama: el motor no escribe la dirección) | regla 4 |
| M6 | **Control positivo del desplazamiento:** sobre `docs/index.html`, llevar la página a una posición conocida `Y0`, forzar después `window.scrollTo(0,0)` y medir con el instrumento | el instrumento reporta `|Δ| = Y0` y C2 en falla; sin el forzado, `|Δ| ≤ TOL_PX` | regla 4 |
| M7 | Caso bueno de C1: pestañas Panorama → Ficha por clic en `.screen-tab` y Atrás, sin desplazar | C1 pasa (vuelve a `#panorama`, pestaña Panorama) | regla 4 |

Último acto: anexar la sección `### FASE 0`.

## 5. Criterios (definidos antes de medir; calibrados en M5, M6 y M7)

- **C1 (vuelve a la vista):** tras Atrás, `location.hash` = `#panorama`, la pestaña activa es la del panorama y el md5 del texto del banner es el mismo que antes de salir. Mide la duda de la compuerta de v32 ("tras bajar por el panorama, abrir una tarjeta y pulsar Atrás, vuelve al panorama").
- **C2 (vuelve al lugar):** tras Atrás, `|scrollY_después − scrollY_antes| ≤ TOL_PX` **y** la tarjeta (o fila) de origen está dentro del viewport. Mide lo que D-5 dejó abierto.
- **C3 (la ficha abre arriba):** al entrar a la ficha desde una tarjeta desplazada, `.ficha-name` está dentro del viewport. Es informativo: se reporta, no congela nada.

## 6. Tareas

### T1: Atrás desde la vista actual del panorama

Recorrido R1, a 1280 × 800 y a 390 × 800:

1. Abrir `docs/index.html` sin hash. Elegir la tarjeta de índice `k = floor(0,6 × n)` de `.pan-grid` (n = número de tarjetas, medido en el mismo turno), llevarla al centro del viewport con desplazamiento de la ventana (`window.scrollTo`, no `scrollIntoView`) y registrar el estado "antes".
2. Clic en la tarjeta. Registrar el estado "ficha" (hash esperado `#ficha`, C3).
3. `page.goBack()` (Atrás del navegador, no `history.back()` desde la página). Registrar el estado "después" y evaluar C1 y C2.
4. Repetir 1 a 3 activando la tarjeta con el teclado (foco en la tarjeta y `Enter`), para cubrir el otro camino de entrada.
5. Verificación (`esperado:` antes de correr): C1 pasa en los 4 casos (2 anchos × 2 entradas); para C2 y C3 el esperado es el criterio, y el resultado se anota tal cual.
6. Cierre de fase: `git status --porcelain` → vacío salvo el LOG; sección `### FASE T1` con la tabla `ancho | entrada | hash | pestaña | banner igual | scrollY antes | scrollY después | Δ | origen visible | C1 | C2 | C3`. Sin commit propio (el LOG va en FASE L).

### T2: vista histórica, Adelante y cadena de tres vistas

A 1280 × 800 y a 390 × 800:

1. **R2 (vista histórica):** abrir sin hash, pulsar el botón `Vista histórica` (`.lvl-b`), desplazar hasta la fila de índice `floor(0,6 × n)` de la matriz y pulsar su `.vt-ee-btn`; Atrás. Además de C1 y C2: la vista del panorama sigue en histórica (el botón `Vista histórica` sigue con la clase `on`).
2. **R3 (Adelante):** tras R1 paso 3, `page.goForward()`: hash `#ficha` y la ficha del mismo establecimiento (se compara el md5 del texto de `.ficha-name`, sin anotar el texto).
3. **R4 (cadena):** panorama desplazado → tarjeta → ficha → pestaña del comparador → Atrás (`#ficha`) → Atrás (`#panorama`): C1 y C2 al llegar al panorama.
4. Verificación (`esperado:` antes de correr): C1 en todos los casos; vista histórica conservada en R2; misma ficha en R3; C2 y C3 anotados tal cual.
5. Cierre de fase: `git status --porcelain` → vacío salvo el LOG; sección `### FASE T2` con la misma tabla más las columnas propias de R2 y R3.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log: cada verificación, cada cifra, cada 🔒, M1 a M7 y el alcance. Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** repite R1 a 1280 × 800 con otra tarjeta (índice `floor(0,3 × n)`) y otra forma de volver (`history.go(-1)` desde la página en vez de `page.goBack()`); y re-mide `scrollY` con `document.scrollingElement.scrollTop` en vez de `window.scrollY`. Discrepancia con T1 mayor que `TOL_PX` → hallazgo.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS.
6. **Control positivo de la propia auditoría:** el recorrido del paso 2 sobre `/tmp/s34a_motor_s33t.html` debe fallar C1.
7. **Veredicto por hallazgo, con severidad:** **BLOQUEA** (🔒 en FALLA, escritura fuera de alcance), **REPARA** (defecto del propio instrumento o del LOG, corregible en `/tmp/s34a_*` o en el LOG), **ADVIERTE** (lo demás, incluido un C2 o C3 en falla: es un hallazgo del motor que el encargo reporta, no repara). "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con re-verificación por el chequeo que detectó y por uno distinto; un REPARA sobre el LOG se corrige anexando una línea que cita a la anterior.
9. **Prohibido:** ajustar un criterio, `TOL_PX` o un esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; tocar la plantilla, el motor o `docs/` para "arreglar" C2 o C3.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto global.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits (`git log <inicio>..HEAD --oneline`); auditoría; invariantes; tabla consolidada de C1, C2 y C3 por recorrido y ancho; **dudas con pregunta cerrada**: si C2 falla en algún caso, una duda con las opciones (a) se acepta como está, (b) encargo para guardar la posición del panorama al salir y restaurarla al volver; si C3 falla, una duda con las opciones (a) se acepta, (b) encargo para que la ficha abra arriba; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: `grep -nE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]' <LOG>` → vacío, con control plantado en una copia en `/tmp`; `grep -nE 'RBD [0-9]' <LOG>` → vacío; ningún nombre de establecimiento.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>` = fases ejecutadas; `grep -c '^esperado:' <LOG>` = `grep -c '^obtenido:' <LOG>`; `grep -c '^## J' <LOG>` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s34a atrás tras desplazarse"`; luego el push según la autorización.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: la tabla consolidada de C1, C2 y C3; salida del push; salida de PRUEBAS; "lo que falló o sorprendió; si nada, decirlo".
