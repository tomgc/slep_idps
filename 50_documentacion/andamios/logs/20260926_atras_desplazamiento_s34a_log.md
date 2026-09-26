# Log de sesión: medir Atrás después de desplazarse por el panorama (s34a)

- **Meta:** medir, sin tocar código, qué pasa con la vista (C1), la posición de la página (C2) y la apertura de la ficha (C3) cuando se baja por el panorama, se abre un establecimiento y se vuelve con Atrás (D-5 de s33u, decisión (b) del titular en la sesión 34). Si la medición muestra un defecto, se registra como duda con pregunta cerrada; el remedio va en otro encargo.
- **Fecha:** 2026-09-26 (la sesión empieza a las 10:08).
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular).
- **HEAD al empezar:** `8ddd6c8` (`chore(estado): abre sesion en MacBook-Pro-de-Tomas.local`). Medición previa al primer acto, en solo lectura salvo el `fetch` (`/tmp/s34a_pre.txt`, 10:08:17): `fetch rc=0`; `HEAD=8ddd6c8 origin/main=8ddd6c8`; `HEAD..origin/main=0`, `origin/main..HEAD=0`; porcelain = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_atras_desplazamiento_s34a.md` (la única ruta que admite la regla 1); `stash list` 0 líneas; rama `main`. Reglas 1 y 2 no disparan. Primer acto (autorizado): commit `117b705` chore(encargo): s34a, hijo de `8ddd6c8`. **PUNTO DE RETORNO `<inicio>` = `117b705`.**
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); `bash` 3.2 explícito; R 4.5.2 con `renv`; `node` v26.5.0 con Puppeteer por `NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema en modo headless (`headless: 'new'`, `--disable-gpu`, sin ventanas), motor por `file://`.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), en solo y en serie, sin subagentes ni workflows (el encargo no los admite, §2.12 fila 5; manda sobre la opción ultracode de la sesión).
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_atras_desplazamiento_s34a.md` (commit `117b705`).
- **Naturaleza:** medición de solo lectura. No se edita la plantilla, el generador, el motor ni `docs/`; no hay build ni despliegue.
- **Grafo de tareas (copiado de §3 del encargo):**

```
T1 (Atrás desde la vista actual)                               ALCANCE: el LOG y /tmp/s34a_*.  Independiente.
T2 (Atrás desde la vista histórica, Adelante y cadena de tres)  ALCANCE: el LOG y /tmp/s34a_*.  Independiente de T1 (comparte instrumento, escrito en FASE 0).
Orden: T1 → T2. FASE R y FASE L quedan fuera del grafo y corren siempre.
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por instrumento que falla (al tercero, la medición se congela con la evidencia); 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria; un push denegado no se reintenta por otra vía.
- **Reglas que rigen esta sesión:** commits y comentarios en español; `git add` con rutas explícitas; nunca `--no-verify`; ni `rm`, `reset`, `restore`, `checkout --` ni cambios en la plantilla, el generador, el motor, `docs/`, el pipeline, los datos, `tests/` o `renv.lock`; temporales solo en `/tmp/s34a_*`; los anexos al LOG, desde archivos (`/tmp/s34a_frag_NN.md`, escritos con la herramienta de escritura y agregados con `cat >>`); ningún script se edita mientras corre; todo Puppeteer en headless con `--disable-gpu`; el LOG no lleva RBD ni nombres de establecimiento (las tarjetas y filas se identifican por su índice; los textos que se comparan se anotan por su md5).
- **Convenciones del registro:** un `esperado:` y un `obtenido:` literal por comando, el `esperado:` escrito antes; una corrección va como `- **Corrección:** …`; las pruebas de humo se declaran como tales y no son medición.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: medir, sin tocar código, Atrás después de desplazarse por el panorama (D-5 de s33u); medido en el motor publicado: vuelve al panorama (C1) y al mismo lugar (C2) en todos los casos; la ficha abre a media página (C3 en falla en todos).
- Estado por tarea: FASE 0 completada · T1 completada (C1 4/4, C2 4/4, C3 0/4) · T2 completada (R2, R3 y R4 en los dos anchos: C1 y C2 6/6, vista histórica conservada 2/2, Adelante con la misma ficha 2/2, C3 0/6) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
- Commits: 2 propios, `117b705` chore(encargo): s34a y `docs(log): s34a atrás tras desplazarse` (`git log --oneline 8ddd6c8..HEAD`), de los cuales 0 fix(auditoria).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/2/5; reparados 2 (R-20, R-21, del LOG); abiertos 5 (a Dudas o declarados); controles positivos 2 de 2 (más M5).
- Invariantes: 🔒1 PASA (`c5542b20…` en FASE 0 y FASE R); 🔒2 (i) PASA (solo el LOG en `<inicio>..HEAD`), (ii) porcelain no vacío al final por `Claude outputs/`, ajena (ADVIERTE A-3, no BLOQUEA); 🔒3 PASA (PRUEBAS `rc=0` en FASE 0 y FASE R).
- Cifras críticas: intactas (evidencia: `docs/` y motor `c5542b2013b6fb6e5d42f709ca723c3c`; `verificar_motor.R` con hash §8.2 `eb4e00b3…4dc4` y 16/16 celdas ancla, `rc=0`, al abrir y al cerrar; ningún archivo versionado tocado salvo el LOG).
- Decisiones autónomas de mayor riesgo: tratar `Claude outputs/` como escritura ajena (regla 5 sin congelar tareas) y el 🔒2 (ii) como ADVIERTE; agregar mediciones informativas declaradas (pasos 2 (c), 2 (d) y 2 (e) de FASE R), entre ellas una simulación en tiempo de ejecución de "la ficha abre arriba", sin tocar archivos.
- Desviaciones respecto del encargo: C1 leído como "hash de antes" por decisión del titular en el gate de FASE 0 (la letra `#panorama` es inalcanzable abriendo sin dirección); push no ejecutado por la condición de porcelain vacío (D-3); todo Puppeteer en headless con `--disable-gpu`.
- Dudas abiertas: 5 (D-1 C1 por la letra, D-2 C3 y el remedio que no rompa C2, D-3 `Claude outputs/` y el push, D-4 temporales `/tmp/s34a_*`, D-5 versionar el instrumento).
- Errores propios: 7 numerados (E-1 a E-7), ninguno con efecto en las cifras medidas; entre ellos E-3 (la hipótesis de que subir la ficha después de escribir la dirección conservaba la posición, refutada por la medición) y E-5 (descripción imprecisa del instrumento, reparada en FASE R).
- Qué debe verificar el revisor por sí mismo: en el sitio publicado, a pantalla de escritorio y de teléfono, bajar por el panorama, abrir una tarjeta (ver que la ficha abre a media página) y volver con Atrás (ver que vuelve al mismo lugar); lo mismo desde la vista histórica.
- No publicado / queda al usuario: el push de `main` (2 commits: `117b705` y el `docs(log)`) espera la decisión de D-3; D-1 a D-5.
- Ejecución: esfuerzo xhigh en solo y en serie; subagentes 0 y total Opus 0, por contrato; un gate al titular (C1).

## Registro por fase

### FASE 0: apertura del log, instrumento y calibración

- **Estado:** en curso.
- **Commits:** `117b705` (primer acto).

**M1 y M2** (`/tmp/s34a_m12.sh`, nuevo: porcelain, stash y archivos del primer commit; `fetch`, `HEAD~1` y distancias con `origin/main`):
```
bash /tmp/s34a_m12.sh
```
esperado: `M1 porcelain: [?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md|]`; `M1 stash: []`; `M1 archivos del primer commit: 50_documentacion/activa/encargos/encargo_claude_code_idps_atras_desplazamiento_s34a.md | asunto: chore(encargo): s34a`; `M2 fetch rc=0`; `HEAD=117b705 HEAD~1=8ddd6c8 origin/main=8ddd6c8`; `HEAD..origin/main=0 origin/main..HEAD=1`. Si no, reglas 1 o 2.
obtenido: `M1 porcelain: [?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md|]`; `M1 stash: []`; `M1 archivos del primer commit: 50_documentacion/activa/encargos/encargo_claude_code_idps_atras_desplazamiento_s34a.md | asunto: chore(encargo): s34a`; `M2 fetch rc=0`; `M2 HEAD=117b705 HEAD~1=8ddd6c8 origin/main=8ddd6c8`; `M2 HEAD..origin/main=0 origin/main..HEAD=1`. = esperado: reglas 1 y 2 no disparan.

**M3 — md5, PRUEBAS, Puppeteer y Chrome** (`/tmp/s34a_m3.sh`, nuevo; el shell de la sesión tiene por directorio la raíz del proyecto, que es donde `here::i_am` del verificador acepta correr):
```
bash /tmp/s34a_m3.sh
```
esperado: `MD5(…/docs/index.html)= c5542b2013b6fb6e5d42f709ca723c3c` y `MD5(…/40_salidas/motor_idps.html)= c5542b2013b6fb6e5d42f709ca723c3c`; PRUEBAS: líneas `[OK]` (regla de anclas; hash §8.2 `= esperado`, celdas ancla 16/16 y red en los dos archivos), `[INFO]` "el mismo archivo, md5 c5542b20…", `verificar_motor: todo cuadra`, `rc=0`; `puppeteer <versión> …/node_modules/…` y `node rc=0`; `chrome presente: Google Chrome <versión>`. Si el md5 difiere, regla 3; si PRUEBAS, Puppeteer o Chrome fallan, T1 y T2 congeladas.
obtenido: `cwd /Users/tomgc/Projects/slep_idps | hora 2026-09-26 10:12`; `MD5(/Users/tomgc/Projects/slep_idps/docs/index.html)= c5542b2013b6fb6e5d42f709ca723c3c`; `MD5(/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html)= c5542b2013b6fb6e5d42f709ca723c3c`; PRUEBAS: `[OK] regla de anclas: 16 celdas, 2 niveles, 4 años (2014, 2018, 2024, 2025), 4 indicadores, 6 con sigdifgru nulo`, `[OK] docs/index.html · hash §8.2 eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 (= esperado)`, `[OK] docs/index.html · celdas ancla 16/16 iguales al parquet (puntaje, difgru, sigdifgru)`, `[OK] docs/index.html · red: 0 src="http, 0 href="http, 0 text/babel`, las mismas tres `[OK]` para `40_salidas/motor_idps.html`, `[INFO] docs/index.html y 40_salidas/motor_idps.html: el mismo archivo, md5 c5542b2013b6fb6e5d42f709ca723c3c`, `verificar_motor: todo cuadra`, `rc=0`; `puppeteer 25.9.0 …/node_modules/puppeteer/lib/puppeteer/puppeteer.js`, `node rc=0`; `chrome presente: Google Chrome 153.0.8010.53`. = esperado: la regla 3 no dispara; T1 y T2 no se congelan por M3. Salida completa en `/tmp/s34a_m3.out`.

**Instrumento** (`/tmp/s34a_atras.js`, nuevo, Puppeteer 25.9.0 headless `'new'` con `--disable-gpu`, viewport `ancho × 800`, motor por `file://`; resumen con `/tmp/s34a_resumen.py`, nuevo). Cada recorrido abre una página nueva; el puntero se lleva fuera de la página con `mouse.move(-1,-1)` al abrir y después de cada clic (el estado registra `document.querySelectorAll(':hover').length`, que da `0`). Por estado registra: `location.hash`; la pestaña activa (`.screen-tab.is-active`: índice 0 panorama, 1 ficha, 2 comparador, y su texto); el md5 del `textContent` de `.pan-bar` (el banner del territorio); `window.scrollY` y `document.scrollingElement.scrollTop`; `document.documentElement.scrollHeight`; `innerHeight`; para la tarjeta o fila de origen, `getBoundingClientRect()` (`top`, `bottom`), si está dentro del viewport y el md5 de su rótulo (para saber que es la misma); para `.ficha-name`, lo mismo; `history.length`, `history.scrollRestoration` y si el documento es el mismo (marca en `window`). Las esperas de cambio de vista son por condición (`waitForFunction` con la pestaña activa y el selector de la vista nueva: `.pan-grid .card` o `.vt-ee-btn` para el panorama, `.ficha-name` para la ficha, `.cmp-add` para el comparador; tope 15 s, que se registra si se agota), y tras cada Atrás o Adelante, dos `requestAnimationFrame` más. `TOL_PX = 1` va nombrada en el script. Los clics son de ratón en el centro del elemento (`page.mouse.click`, sin el desplazamiento automático de `ElementHandle.click`); la entrada por teclado enfoca la tarjeta con `focus({preventScroll:true})` y pulsa `Enter`. Una lectura "tardía" 1 s después del estado "después" se anota como informativa (no entra en C1, C2 ni C3).
- **Definiciones fijadas antes de medir:** "dentro del viewport" = el rectángulo entero entre 0 e `innerHeight` (`top ≥ 0` y `bottom ≤ innerHeight`; el estado registra también si alguna parte es visible); "tarjeta de origen" = la de índice `k` en `document.querySelectorAll('.pan-grid .card')` (todas las grillas de GSE, en orden del documento; `n` es ese total); "fila de origen" = el `<tr>` del `.vt-ee-btn` de índice `k`; C2 exige además que la tarjeta de índice `k` tras volver sea la misma (md5 del rótulo igual); "antes" es el estado inmediatamente previo a la activación (tras centrar y, en la entrada por teclado, tras enfocar).
- **Prueba de humo del instrumento** (no medición; `docs/index.html`, 1280, `r1` con clic y `m7`; `/tmp/s34a_humo_r1.json`, `/tmp/s34a_humo_m7.json`): el instrumento corre sin errores ni peticiones externas, `hover=0`. En los dos, tras Atrás, `location.hash` es `''` (vacío), la pestaña es la del panorama y el md5 del banner es el de antes. Es lo que el motor hace por diseño (s33u, decisión del titular: "una dirección vacía o desconocida abre el panorama sin escribir nada"; lo mismo registró la verificación de T2 de s33u, `tarjeta: … → atras: territorio '' h3`): el recorrido abre el motor **sin hash**, la entrada inicial del historial no tiene fragmento, y Atrás vuelve a ella.
- **Choque de redacción (antes de M4):** C1 exige `location.hash = #panorama` y M7 espera "vuelve a `#panorama`"; con la apertura sin hash que piden R1 y M4, ningún recorrido puede volver a `#panorama`, y por la letra el caso bueno M7 fallaría: la regla 4 congelaría T1 y T2 por la redacción del criterio, no por el instrumento. Por la regla de las sesiones anteriores (una regla inejecutable por un hecho del entorno va a gate con la alternativa recomendada, en vez de congelar medio grafo), lo pregunto al titular antes de escribir el esperado de M4.
- **Decisión del titular (gate de FASE 0, 10:2x):** "Hash de antes" (la opción recomendada). **C1 se lee así:** tras Atrás, `location.hash` es el que tenía el panorama en el estado "antes" (`''` al abrir sin hash) y ese hash lleva al panorama (`''` o `#panorama`), la pestaña activa es la del panorama y el md5 del banner es el de antes. Los recorridos no cambian (se abre sin hash); en cada fila se anota el hash literal y, como dato, el resultado de la letra (`#panorama`), que queda como duda. El instrumento calcula las dos lecturas (`hash_de_antes` y `letra`); **C1 es `hash_de_antes`**.

**M4 — recorrido largo y tarjetas suficientes** (`/tmp/s34a_m4.sh`, nuevo: `m4` del instrumento a 1280 y a 390; como dato informativo, el largo de la vista histórica y su número de filas, que R2 necesita):
```
bash /tmp/s34a_m4.sh
```
esperado: `M4 1280: scrollHeight-innerHeight=<v> innerHeight=800 tarjetas=<n> -> CUMPLE` y `M4 390: … -> CUMPLE`, es decir `scrollHeight − innerHeight ≥ 800` y `≥ 8` tarjetas en los dos anchos (referencias: el panorama de apertura mide 7.596 px de alto a 1280 y 26.225 a 390 en M4 de s33u; el humo contó 60 tarjetas); 0 errores, 0 peticiones externas, sin esperas agotadas. Si no cumple, regla 6.
obtenido: `M4 1280: scrollHeight-innerHeight=6796 innerHeight=800 tarjetas=60 -> CUMPLE | informativo histórica: {"recorrido_largo": 6153, "filas": 61} | errores 0 | red_externa 0 | esperas ['abrir: panorama con tarjetas: ok', 'histórica: filas: ok']`; `M4 390: scrollHeight-innerHeight=25425 innerHeight=800 tarjetas=60 -> CUMPLE | informativo histórica: {"recorrido_largo": 12575, "filas": 61} | errores 0 | red_externa 0 | esperas ['abrir: panorama con tarjetas: ok', 'histórica: filas: ok']`. = esperado: el recorrido es largo en los dos anchos (6.796 y 25.425 px de desplazamiento posible, más de ocho pantallas a 1280 y más de treinta a 390) y hay 60 tarjetas; la vista histórica también (6.153 y 12.575 px, 61 filas). Así, `k = floor(0,6 × 60) = 36` en R1 y `floor(0,6 × 61) = 36` en R2.
- **Corrección:** la hora del gate de C1 que anoté arriba ("10:2x") no la medí; la medición de M4 empezó a las 10:46, así que el gate se respondió antes de esa hora.

**M5 — caso malo** (`/tmp/s34a_m5.sh`, nuevo: extrae el motor de s33t con la autorización, `git show b97d76d:docs/index.html > /tmp/s34a_motor_s33t.html`; comprueba su md5; corre R1 sobre él a 1280 y 390, con clic y con teclado):
```
bash /tmp/s34a_m5.sh
```
esperado: `git show rc=0`; `MD5(/tmp/s34a_motor_s33t.html)= b3daf503514a49b56426339e75fb7d82`; en los cuatro casos, la ficha abre (`pest=1`) con `location.hash` `''` (ese motor no escribe la dirección) y **C1 FALLA**: Atrás sale del motor (`despues: about:blank`, sin pestaña, sin banner) y la espera `Atrás: panorama` se agota. Si C1 pasa en alguno, regla 4.
obtenido: `git show rc=0`; `MD5(/tmp/s34a_motor_s33t.html)= b3daf503514a49b56426339e75fb7d82`; en los cuatro casos (`n 60 k 36`): `ficha: motor '' h2 pest=1` (la ficha abre sin escribir la dirección, `history.length` no crece: `hash #ficha: no llegó en 3 s`), `despues: about:blank '' h2 pest=None y=0`, `C1[hash='' pest_pan=no banner_igual=no letra=FALLA hash_de_antes=FALLA]`, `Atrás: panorama: AGOTADA (Waiting failed: 15000ms exceeded)`, 0 errores, 0 peticiones externas. Detalle: 1280 clic y teclado `antes y=4689 … origen[top=224.36 dentro=sí]`, `ficha y=4689 alto=7283 ficha-name[top=-4319.47 dentro=no]`; 390 clic y teclado `antes y=16552 … origen[top=223.59 dentro=sí]`, `ficha y=16552 alto=19342 ficha-name[top=-15855.55 dentro=no]` (salida completa en `/tmp/s34a_m5_{1280,390}_{clic,teclado}.json`). = esperado: **el instrumento falla sobre el caso malo** (Atrás sale del motor anterior a las direcciones).

**M6 — control positivo del desplazamiento** (`/tmp/s34a_m6.sh`, nuevo, sobre `docs/index.html` a 1280 y a 390: (a) la tarjeta `k` centrada da la posición conocida `Y0`, se fuerza `window.scrollTo(0,0)` y se mide; (b) lo mismo sin el forzado; (c) además, el recorrido R1 completo con clic y el forzado plantado entre Atrás y la medición, para mostrar que el desplazamiento se detecta también dentro del recorrido):
```
bash /tmp/s34a_m6.sh
```
esperado: por ancho, `forzado`: `|Δ|=Y0` (`|Δ|=Y0:sí`, `Δ = −Y0`), `origen_dentro=no`, `C2=FALLA`; `sinforzar`: `|Δ|=0` (`|Δ|<=TOL_PX:sí`), `origen_dentro=sí`, `C2=PASA`; `plantado`: `|Δ|=Y0:sí`, `C2=FALLA`. `Y0` = 4689 a 1280 y 16552 a 390 si la maquetación es la de M5 (el mismo panorama). 0 errores, 0 peticiones externas, sin esperas con problema. Si el forzado no se detecta, regla 4.
obtenido: `s34a_m6_1280_forzado.json: Y0=4689 Δ=-4689 |Δ|=4689 |Δ|=Y0:sí |Δ|<=TOL_PX:no origen_dentro=no C2=FALLA`; `s34a_m6_1280_sinforzar.json: Y0=4689 Δ=0 |Δ|=0 |Δ|=Y0:no |Δ|<=TOL_PX:sí origen_dentro=sí C2=PASA`; `s34a_m6_1280_plantado.json: Y0=4689 Δ=-4689 |Δ|=4689 |Δ|=Y0:sí |Δ|<=TOL_PX:no origen_dentro=no C2=FALLA`; `s34a_m6_390_forzado.json: Y0=16552 Δ=-16552 |Δ|=16552 |Δ|=Y0:sí |Δ|<=TOL_PX:no origen_dentro=no C2=FALLA`; `s34a_m6_390_sinforzar.json: Y0=16552 Δ=0 |Δ|=0 |Δ|=Y0:no |Δ|<=TOL_PX:sí origen_dentro=sí C2=PASA`; `s34a_m6_390_plantado.json: Y0=16552 Δ=-16552 |Δ|=16552 |Δ|=Y0:sí |Δ|<=TOL_PX:no origen_dentro=no C2=FALLA`; los seis con `errores 0 | red_externa 0 | esperas con problema []`. = esperado: **el instrumento detecta el desplazamiento plantado** (fuera y dentro del recorrido) y no inventa uno cuando no lo hay.

**M7 — caso bueno de C1** (`/tmp/s34a_m7.sh`, nuevo: sobre `docs/index.html`, a 1280 y a 390, clic en la pestaña del panorama, clic en la pestaña de la ficha y Atrás, sin desplazar):
```
bash /tmp/s34a_m7.sh
```
esperado: en los dos anchos, `antes` y `clic Panorama` con `motor '' h2 pest=0` (la pestaña ya activa no escribe nada); `ficha: motor #ficha h3 pest=1`; `despues: motor '' h3 pest=0`; `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA]`: **C1 pasa** con la lectura del gate (la letra, `#panorama`, falla, como se anticipó); 0 errores, 0 peticiones externas, sin esperas con problema. (La línea de C2 y C3 de este recorrido no se lee: no hay tarjeta de origen ni ficha con establecimiento.) Si C1 falla, regla 4.
obtenido: 1280: `antes: motor '' h2 pest=0 y=0 … alto=7596`, `clic Panorama: motor '' h2 pest=0`, `ficha: motor #ficha h3 pest=1 y=0 alto=800`, `despues: motor '' h3 pest=0 y=0 alto=7596`, `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA]`; 390: lo mismo con `alto=26225` en el panorama y `alto=1183` en la ficha, `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA]`; los dos con `esperas con problema: [] | errores: 0 | red_externa: 0 | error_instr: None`. = esperado: **C1 pasa en el caso bueno** (con la lectura del gate). La regla 4 no dispara: el instrumento falla sobre el caso malo (M5), detecta el desplazamiento plantado (M6) y da por bueno el caso bueno (M7).

**Cierre de FASE 0 — árbol** (solo lectura):
```
git -C /Users/tomgc/Projects/slep_idps status --porcelain
```
esperado: `?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` (solo el LOG; los temporales viven en `/tmp/s34a_*`).
obtenido: `?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` y `?? "Claude outputs/"`. **Difiere del esperado.** Atribución (solo lectura, sin abrir el archivo): la carpeta contiene un único archivo, `Claude outputs/20260926_registro_asistente_s34.md` (1.785 B, md5 `2c47a42352e34c136be15a1bc1289b30`), creado a las **10:46:24**, mientras el titular respondía el gate de C1 en la app; ningún comando de esta sesión escribe en el árbol fuera del LOG (a esa hora corría M4, que solo escribe `/tmp/s34a_m4_*.json`). Es el registro del asistente de la sesión 34 del titular (el mismo patrón que `Claude outputs/` en s32). La regla 5 congela "la tarea que la produjo": no la produjo ninguna tarea del encargo, así que no se congela nada; **no se toca** (la lista cerrada no admite `rm` y la carpeta es del titular). Consecuencia prevista: si sigue ahí en FASE L, el porcelain no queda vacío y el push autorizado no corre (queda como duda).

- **Estado de FASE 0:** completada. M1 a M7 conformes (M4 a M7 con la lectura de C1 que eligió el titular en el gate); reglas 1 a 4 no disparan; la regla 5 no congela ninguna tarea (escritura ajena, atribuida). **Commits:** `117b705` (primer acto).

### FASE T1: Atrás desde la vista actual del panorama

- **Estado:** en curso.

**R1** (`/tmp/s34a_t1.sh`, nuevo: `docs/index.html`, a 1280 × 800 y 390 × 800, entrada por clic y por teclado; tarjeta `k = floor(0,6 × n)` centrada con `window.scrollTo`; activación; `page.goBack()`; salida por caso en `/tmp/s34a_t1_{1280,390}_{clic,teclado}.json`):
```
bash /tmp/s34a_t1.sh
```
esperado: `MD5(…/docs/index.html)= c5542b2013b6fb6e5d42f709ca723c3c`; en los cuatro casos `n 60 k 36`, la ficha abre con `#ficha` y **C1 pasa** (`hash_de_antes=PASA`: `''` como antes, pestaña del panorama, mismo banner); para C2 el esperado es el criterio (`|Δ| ≤ 1`, la misma tarjeta de origen dentro del viewport) y para C3 también (`.ficha-name` dentro del viewport al abrir la ficha); el resultado de C2 y C3 se anota tal cual. 0 errores, 0 peticiones externas, sin esperas con problema.
obtenido: `hora 10:52`; `MD5(/Users/tomgc/Projects/slep_idps/docs/index.html)= c5542b2013b6fb6e5d42f709ca723c3c`; en los cuatro casos `n 60 k 36`, `esperas con problema: [] | errores: 0 | red_externa: 0 | error_instr: None`, `hover=0` en cada estado.
- 1280 clic: `antes: motor '' h2 pest=0 y=4689 top=4689 alto=7596 origen[top=224.36 dentro=sí]` → `ficha: motor #ficha h3 pest=1 y=4689 alto=7283 ficha-name[top=-4319.47 dentro=no]` → `despues: motor '' h3 pest=0 y=4689 top=4689 alto=7596 origen[top=224.36 dentro=sí]` (`tardio` igual); `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-4319.47 y=4689] ΔscrollTop=0`.
- 1280 teclado: idéntico al de clic, estado por estado (`y=4689`, `ficha-name[top=-4319.47]`, `C1 … hash_de_antes=PASA`, `C2 … PASA`, `C3[FALLA …]`).
- 390 clic: `antes: motor '' h2 pest=0 y=16552 top=16552 alto=26225 origen[top=223.59 dentro=sí]` → `ficha: motor #ficha h3 pest=1 y=16552 alto=19342 ficha-name[top=-15855.55 dentro=no]` → `despues: motor '' h3 pest=0 y=16552 top=16552 alto=26225 origen[top=223.59 dentro=sí]` (`tardio` igual); `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-15855.55 y=16552] ΔscrollTop=0`.
- 390 teclado: idéntico al de clic, estado por estado.

= esperado en C1 (pasa en los cuatro). C2 **pasa** en los cuatro (`Δ = 0`, la misma tarjeta 36 en el mismo lugar del viewport). C3 **falla** en los cuatro: la ficha abre con la página en el mismo `scrollY` que tenía el panorama (4.689 a 1280, 16.552 a 390), así que el nombre del establecimiento queda 4.319 px (1280) o 15.856 px (390) por encima del borde superior y se llega a la ficha a media página. Lectura del mecanismo, desde las cifras: la página **no se movió en ningún momento** (`scrollY` igual en "antes", "ficha", "después" y en la lectura tardía): `pushState` no desplaza, la ficha es más alta que `Y0 + 800` (7.283 y 19.342 px) y no recorta la posición, y al volver el panorama se dibuja en el mismo lugar. Si C2 pasa también cuando la ficha es más baja que la posición del panorama no lo mide este recorrido: se pone a prueba en FASE R.

**Tabla de T1:**

| ancho | entrada | hash | pestaña | banner igual | scrollY antes | scrollY después | Δ | origen visible | C1 | C2 | C3 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1280 | clic | `''` (antes `''`) | panorama | sí | 4689 | 4689 | 0 | sí (tarjeta 36, top 224,36) | PASA | PASA | FALLA (`.ficha-name` top −4.319,47; ficha en y 4689) |
| 1280 | teclado | `''` (antes `''`) | panorama | sí | 4689 | 4689 | 0 | sí (tarjeta 36, top 224,36) | PASA | PASA | FALLA (top −4.319,47; y 4689) |
| 390 | clic | `''` (antes `''`) | panorama | sí | 16552 | 16552 | 0 | sí (tarjeta 36, top 223,59) | PASA | PASA | FALLA (top −15.855,55; y 16552) |
| 390 | teclado | `''` (antes `''`) | panorama | sí | 16552 | 16552 | 0 | sí (tarjeta 36, top 223,59) | PASA | PASA | FALLA (top −15.855,55; y 16552) |

(C1 con la lectura del gate; por la letra, `#panorama`, falla en los cuatro, como en M7.)

**Cierre de T1 — árbol** (solo lectura):
```
git -C /Users/tomgc/Projects/slep_idps status --porcelain
```
esperado: `?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` y `?? "Claude outputs/"` (la carpeta ajena atribuida en FASE 0, si el titular no la movió); nada más.
obtenido: `?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` y `?? "Claude outputs/"`. = esperado: T1 no escribió nada en el árbol fuera del LOG.

- **Estado de T1:** completada (medición). C1 4/4 PASA; C2 4/4 PASA; C3 0/4 (FALLA en los cuatro, informativo). Sin commit propio (el LOG va en FASE L).

### FASE T2: vista histórica, Adelante y cadena de tres vistas

- **Estado:** en curso.

**R2 — vista histórica** (`/tmp/s34a_t2_r2.sh`, nuevo: `docs/index.html` a 1280 y 390; botón `Vista histórica` de `.pan-nivel`; fila `k = floor(0,6 × n)` de la matriz (`n` = número de `.vt-ee-btn`) centrada con `window.scrollTo`; clic de ratón en su `.vt-ee-btn`; `page.goBack()`; salida en `/tmp/s34a_t2_r2_{1280,390}.json`):
```
bash /tmp/s34a_t2_r2.sh
```
esperado: en los dos anchos `n 61 k 36`; `antes` con `vista=Vista histórica` y la fila de origen dentro del viewport; `ficha: motor #ficha h3 pest=1`; `despues: motor '' h3 pest=0 … vista=Vista histórica`; **C1 pasa** (`hash_de_antes=PASA`) y **`histórica_conservada=sí`** (el botón `Vista histórica` sigue con `on`); C2 y C3: el esperado es el criterio (`|Δ| ≤ 1` y la misma fila dentro del viewport; `.ficha-name` dentro del viewport), y el resultado se anota tal cual. 0 errores, 0 peticiones externas, sin esperas con problema.
obtenido: 1280 `n 61 k 36`: `antes: motor '' h2 pest=0 y=4117 top=4117 alto=6953 origen[top=374.09 dentro=sí] vista=Vista histórica` → `ficha: motor #ficha h3 pest=1 y=4117 alto=7283 ficha-name[top=-3747.47 dentro=no]` → `despues: motor '' h3 pest=0 y=4117 top=4117 alto=6953 origen[top=374.09 dentro=sí] vista=Vista histórica` (`tardio` igual); `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-3747.47 y=4117] ΔscrollTop=0 histórica_conservada=sí`. 390 `n 61 k 36`: `antes: … y=8515 alto=13375 origen[top=353.45 dentro=sí] vista=Vista histórica` → `ficha: motor #ficha h3 pest=1 y=8515 alto=19342 ficha-name[top=-7818.55 dentro=no]` → `despues: motor '' h3 pest=0 y=8515 alto=13375 origen[top=353.45 dentro=sí] vista=Vista histórica` (`tardio` igual); `C1[… hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-7818.55 y=8515] ΔscrollTop=0 histórica_conservada=sí`. Los dos con `esperas con problema: [] | errores: 0 | red_externa: 0`, `hover=0`. = esperado: C1 pasa y la vista histórica se conserva en los dos anchos; C2 **pasa** (`Δ = 0`); C3 **falla** (la ficha abre en y 4117 y 8515, con el nombre 3.747 y 7.819 px por encima). La misma lectura del mecanismo que en T1: la página no se movió.

**R3 — Adelante** (`/tmp/s34a_t2_r3.sh`, nuevo: R1 con clic a 1280 y 390 y, tras el paso 3, `page.goForward()`; se compara el md5 del texto de `.ficha-name` al entrar a la ficha y al volver a ella con Adelante; salida en `/tmp/s34a_t2_r3_{1280,390}.json`):
```
bash /tmp/s34a_t2_r3.sh
```
esperado: en los dos anchos, la parte R1 igual a T1 (C1 `hash_de_antes=PASA`, C2 y C3 como en T1: el esperado es el criterio); `adelante: motor #ficha h3 pest=1` y `R3[hash=#ficha misma_ficha=sí pasa=PASA]`; 0 errores, 0 peticiones externas, sin esperas con problema.
obtenido: 1280 `n 60 k 36`: la parte R1 igual a T1 estado por estado (`antes y=4689 … origen[top=224.36 dentro=sí]`, `ficha: motor #ficha h3 pest=1 y=4689 ficha-name[top=-4319.47 dentro=no]`, `despues: motor '' h3 pest=0 y=4689 origen[top=224.36 dentro=sí]`, `C1[… hash_de_antes=PASA] C2[Δ=0 … pasa=PASA] C3[FALLA top=-4319.47 y=4689]`); `adelante: motor #ficha h3 pest=1 y=4689 alto=7283 ficha-name[top=-4319.47 dentro=no]`; `R3[hash=#ficha misma_ficha=sí pasa=PASA]`. 390 `n 60 k 36`: la parte R1 igual a T1 (`y=16552`, `ficha-name[top=-15855.55]`, `C1 … PASA`, `C2 … PASA`, `C3[FALLA …]`); `adelante: motor #ficha h3 pest=1 y=16552 alto=19342 ficha-name[top=-15855.55 dentro=no]`; `R3[hash=#ficha misma_ficha=sí pasa=PASA]`. Los dos con `esperas con problema: [] | errores: 0 | red_externa: 0 | error_instr: None`. = esperado: Adelante vuelve a `#ficha` con la misma ficha en los dos anchos (y en la misma posición de la página: la ficha vuelve a abrir a media página).

**R4 — cadena de tres vistas** (`/tmp/s34a_t2_r4.sh`, nuevo: `docs/index.html` a 1280 y 390; panorama desplazado a la tarjeta 36 → clic → ficha → clic en la pestaña del comparador → `page.goBack()` → `page.goBack()`; salida en `/tmp/s34a_t2_r4_{1280,390}.json`):
```
bash /tmp/s34a_t2_r4.sh
```
esperado: en los dos anchos `n 60 k 36`; `ficha: motor #ficha h3 pest=1`; `comparador: motor #comparador h4 pest=2`; `atras 1: motor #ficha h4 pest=1` (`R4_atras1[hash=#ficha pest_ficha=sí]`); `despues: motor '' h4 pest=0` y **C1 pasa** (`hash_de_antes=PASA`); C2 y C3: el esperado es el criterio, y el resultado se anota tal cual. 0 errores, 0 peticiones externas, sin esperas con problema.
obtenido: 1280 `n 60 k 36`: `antes: motor '' h2 pest=0 y=4689 alto=7596 origen[top=224.36 dentro=sí]` → `ficha: motor #ficha h3 pest=1 y=4689 alto=7283 ficha-name[top=-4319.47 dentro=no]` → `comparador: motor #comparador h4 pest=2 y=217 top=217 alto=1017` → `atras 1: motor #ficha h4 pest=1 y=4689 top=4689 alto=7283 ficha-name[top=-4319.47 dentro=no]` → `despues: motor '' h4 pest=0 y=4689 top=4689 alto=7596 origen[top=224.36 dentro=sí]` (`tardio` igual); `C1[hash='' pest_pan=sí banner_igual=sí letra=FALLA hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-4319.47 y=4689] ΔscrollTop=0 R4_atras1[hash=#ficha pest_ficha=sí]`. 390 `n 60 k 36`: `antes … y=16552 alto=26225 origen[top=223.59 dentro=sí]` → `ficha: #ficha h3 pest=1 y=16552 alto=19342 ficha-name[top=-15855.55 dentro=no]` → `comparador: #comparador h4 pest=2 y=1273 top=1273 alto=2073` → `atras 1: #ficha h4 pest=1 y=16552 alto=19342 ficha-name[top=-15855.55 dentro=no]` → `despues: '' h4 pest=0 y=16552 alto=26225 origen[top=223.59 dentro=sí]` (`tardio` igual); `C1[… hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-15855.55 y=16552] ΔscrollTop=0 R4_atras1[hash=#ficha pest_ficha=sí]`. Los dos con `esperas con problema: [] | errores: 0 | red_externa: 0 | error_instr: None`. = esperado: la cadena vuelve por `#ficha` al panorama con C1 y C2 en los dos anchos; C3 falla.
- **Dato que corrige la lectura del mecanismo de T1:** en R4 la página **sí** se movió: el comparador es corto (1.017 px a 1280, 2.073 a 390) y recortó la posición a su máximo (217 y 1.273); con el primer Atrás, la ficha volvió a 4.689 y 16.552, y con el segundo, el panorama también. Es decir, el navegador guarda la posición de cada entrada del historial y la **restaura** al volver, aunque la vista desde la que se vuelve sea más corta (la restauración espera a que la página vuelva a tener alto). La frase de T1 "Si C2 pasa también cuando la ficha es más baja que la posición del panorama no lo mide este recorrido" queda respondida en parte por R4 (un paso intermedio corto no lo rompe); FASE R lo pone a prueba con la tarjeta más baja.

**Tabla de T2** (la misma de T1, más las columnas propias de R2 y R3; C1 con la lectura del gate, y por la letra `#panorama` falla en todas las filas):

| ancho | recorrido | hash | pestaña | banner igual | scrollY antes | scrollY después | Δ | origen visible | C1 | C2 | C3 | vista histórica conservada (R2) | Adelante: hash · misma ficha (R3) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1280 | R2 (histórica, fila 36 de 61) | `''` (antes `''`) | panorama | sí | 4117 | 4117 | 0 | sí (fila 36, top 374,09) | PASA | PASA | FALLA (top −3.747,47; ficha en y 4117) | sí | — |
| 390 | R2 (histórica, fila 36 de 61) | `''` (antes `''`) | panorama | sí | 8515 | 8515 | 0 | sí (fila 36, top 353,45) | PASA | PASA | FALLA (top −7.818,55; y 8515) | sí | — |
| 1280 | R3 (R1 con clic + Adelante) | `''` (antes `''`) | panorama | sí | 4689 | 4689 | 0 | sí (tarjeta 36, top 224,36) | PASA | PASA | FALLA (top −4.319,47; y 4689) | — | `#ficha` · sí (PASA) |
| 390 | R3 (R1 con clic + Adelante) | `''` (antes `''`) | panorama | sí | 16552 | 16552 | 0 | sí (tarjeta 36, top 223,59) | PASA | PASA | FALLA (top −15.855,55; y 16552) | — | `#ficha` · sí (PASA) |
| 1280 | R4 (cadena; Atrás 1 = `#ficha`, pestaña ficha) | `''` (antes `''`) | panorama | sí | 4689 | 4689 | 0 | sí (tarjeta 36, top 224,36) | PASA | PASA | FALLA (top −4.319,47; y 4689) | — | — |
| 390 | R4 (cadena; Atrás 1 = `#ficha`, pestaña ficha) | `''` (antes `''`) | panorama | sí | 16552 | 16552 | 0 | sí (tarjeta 36, top 223,59) | PASA | PASA | FALLA (top −15.855,55; y 16552) | — | — |

**Cierre de T2 — árbol** (solo lectura):
```
git -C /Users/tomgc/Projects/slep_idps status --porcelain
```
esperado: `?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` y `?? "Claude outputs/"` (ajena, atribuida en FASE 0); nada más.
obtenido: `?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md` y `?? "Claude outputs/"`. = esperado: T2 no escribió nada en el árbol fuera del LOG.

- **Estado de T2:** completada (medición). R2: C1 2/2, vista histórica conservada 2/2, C2 2/2, C3 0/2; R3: Adelante a `#ficha` con la misma ficha 2/2 (y la parte R1, igual a T1); R4: C1 2/2 (Atrás 1 en `#ficha`), C2 2/2, C3 0/2. Sin commit propio.

### FASE R: auditoría propia y reparación

**Paso 1 — inventario** (derivado del log, anexado antes de auditar):

| id | afirmación | origen |
|---|---|---|
| R-01 | Partida: `HEAD` `8ddd6c8` = `origin/main`; primer acto `117b705` (solo el encargo); stash vacío; porcelain antes del primer commit solo el encargo | cabecera, M1, M2 |
| R-02 | `docs/index.html` y `40_salidas/motor_idps.html` con md5 `c5542b2013b6fb6e5d42f709ca723c3c` (🔒1) | M3 |
| R-03 | PRUEBAS: `verificar_motor.R` con `rc=0` al abrir (🔒3) | M3 |
| R-04 | Puppeteer 25.9.0 por `NODE_PATH` y Chrome 153.0.8010.53 presentes | M3 |
| R-05 | Apertura sin hash: desplazamiento posible 6.796 px (1280) y 25.425 px (390), 60 tarjetas; histórica 6.153 / 12.575 px y 61 filas | M4 |
| R-06 | Caso malo (motor de s33t, `b3daf503…`): C1 falla en los cuatro casos de R1 (Atrás sale del motor) | M5 |
| R-07 | Control positivo: forzado `|Δ| = Y0` y C2 en falla; sin forzar `|Δ| = 0`; plantado dentro del recorrido `|Δ| = Y0` y C2 en falla, a 1280 y 390 | M6 |
| R-08 | Caso bueno: pestañas y Atrás dan C1 (hash de antes) a 1280 y 390; la letra (`#panorama`) falla | M7 |
| R-09 | C1 se lee como "hash de antes" (decisión del titular en el gate de FASE 0) | FASE 0 |
| R-10 | T1: C1 pasa en 4/4 | T1 |
| R-11 | T1: C2 pasa en 4/4 (`Δ = 0`; la tarjeta 36, la misma, dentro del viewport) | T1 |
| R-12 | T1: C3 falla en 4/4 (la ficha abre en el `scrollY` del panorama; `.ficha-name` a −4.319,47 y −15.855,55 px) | T1 |
| R-13 | R2: C1, vista histórica conservada y C2 en 2/2; C3 falla en 2/2 | T2 |
| R-14 | R3: Adelante vuelve a `#ficha` con la misma ficha en 2/2 | T2 |
| R-15 | R4: la cadena vuelve por `#ficha` al panorama con C1 y C2 en 2/2; C3 falla en 2/2; el comparador recorta la posición (217 y 1.273) y Atrás restaura la de cada entrada | T2 |
| R-16 | La plantilla no desplaza la página por su cuenta (`scrollTo`, `scrollIntoView`, `scrollRestoration`, `scrollY`, `pageYOffset`: 0); la posición al cambiar de vista y al volver la decide el navegador | premisa del encargo, T1 |
| R-17 | En todas las corridas: 0 errores de consola o de página, 0 peticiones externas, puntero fuera (`hover=0`) | M4 a T2 |
| R-18 | Ninguna escritura en el árbol fuera del LOG; `Claude outputs/` es ajena (10:46:24, registro del asistente de la sesión 34) | FASE 0, T1, T2 |
| R-19 | Nada versionado cambia salvo el encargo y el LOG (🔒2) | FASE 0 a T2 |

**Paso 2 — re-derivación independiente.** Dos instrumentos nuevos, que no reusan el código de `/tmp/s34a_atras.js`: (a) `/tmp/s34a_r_atras.js`, un recorrido R1 mínimo escrito aparte, que lee la posición **solo** con `document.scrollingElement.scrollTop`, centra la tarjeta asignando `scrollingElement.scrollTop`, vuelve con `history.go(-1)` desde la página (agendado con `setTimeout`, lección de s33u) y calcula C1 (hash de antes), C2 y C3 con su propio código; (b) `/tmp/s34a_r_crit.py`, que recalcula C1, C2 y C3 desde los estados crudos de todas las salidas JSON de M5 a T2 (sin leer los `criterios` del instrumento) y los compara con los del instrumento, y suma errores, peticiones externas y `hover`.
- **Prueba de humo** de los dos (no medición): `r_atras.js` sobre `docs/` a 1280 con la tarjeta 18 y `go(-1)` corre sin errores ni esperas agotadas; `r_crit.py` sobre la salida del humo de FASE 0 da `IGUAL`.

**Paso 2 (a) — R1 re-derivado** (`/tmp/s34a_r2a.sh`, nuevo: `r_atras.js` a 1280 sobre `docs/index.html`, tarjeta `floor(0,3 × n)` con clic y con teclado y, para comparar la cifra con T1, la tarjeta `floor(0,6 × n)` con clic; todas con `history.go(-1)` y la posición leída con `scrollingElement.scrollTop`):
```
bash /tmp/s34a_r2a.sh
```
esperado: `n 60 k 18` en los dos primeros y `n 60 k 36` en el tercero; en los tres `antes ''`, `ficha #ficha` con `top` igual al de antes y `ficha-name.top` negativo, `despues ''` con `top` igual al de antes, `Δ=0`, `C1=PASA C2=PASA C3=FALLA` (los veredictos de T1 a 1280), `esperas ['abrir ok', 'ficha ok', 'volver al panorama ok']`, `errores 0`; en el tercero `top=4689` y `T1 1280 clic Δ=0 -> discrepancia 0 (dentro de TOL_PX)`. Una discrepancia con T1 mayor que `TOL_PX`, o un veredicto distinto, es hallazgo.
obtenido: `hora 10:56`; `s34a_r2a_03_clic.json: n 60 k 18 | antes '' top=2375 | ficha #ficha top=2375 ficha-name.top=-2005.46875 | despues '' top=2375 | Δ=0 | C1=PASA C2=PASA C3=FALLA | esperas ['abrir ok', 'ficha ok', 'volver al panorama ok'] | errores 0`; `s34a_r2a_03_teclado.json:` lo mismo, cifra por cifra; `s34a_r2a_06_clic.json: n 60 k 36 | antes '' top=4689 | ficha #ficha top=4689 ficha-name.top=-4319.46875 | despues '' top=4689 | Δ=0 | C1=PASA C2=PASA C3=FALLA | esperas ['abrir ok', 'ficha ok', 'volver al panorama ok'] | errores 0 | T1 1280 clic Δ=0 -> discrepancia 0 (dentro de TOL_PX)`. = esperado: con otra tarjeta, otra forma de volver, otra lectura de la posición y otro código, los veredictos son los de T1 y la cifra comparable coincide (0 px de discrepancia).

**Paso 2 (b) — criterios recalculados desde los estados crudos** (`r_crit.py` sobre las 24 salidas JSON de `/tmp/s34a_atras.js`: M4 (2, solo para los totales), M5 (4), M6 (6), M7 (2), T1 (4), R2, R3 y R4 (2 cada uno)):
```
python3 /tmp/s34a_r_crit.py /tmp/s34a_m4_1280.json /tmp/s34a_m4_390.json /tmp/s34a_m5_*.json /tmp/s34a_m6_*.json /tmp/s34a_m7_*.json /tmp/s34a_t1_*.json /tmp/s34a_t2_*.json
```
esperado: 22 líneas `IGUAL` (ninguna `DIFIERE`), con `C1=False` en las cuatro de M5 y `True` en las demás de recorrido (M6 `plantado`, M7, T1, R2, R3, R4; en M6 `forzado`/`sinforzar` no hay Atrás y C1 no se lee), `C2=False` en M5, M6 `forzado` y `plantado` y M7, `True` en M6 `sinforzar`, T1, R2, R3 y R4, y `C3=False` en todas; y la última línea `archivos 24 | diferencias recalculado-instrumento 0 | errores 0 | peticiones externas 0 | hover máx 0 | estados <n> | |scrollY-scrollTop| máx 0.0`.
obtenido: 22 líneas `IGUAL`, ninguna `DIFIERE`: M5 (4) `recalculado C1=False C2=False C3=False` (Δ −4689 a 1280 y −16552 a 390); M6 `forzado` (2) `C1=True C2=False C3=None`, `plantado` (2) `C1=True C2=False C3=False`, `sinforzar` (2) `C1=True C2=True C3=None`; M7 (2) `C1=True C2=False C3=False`; T1 (4), R2 (2), R3 (2) y R4 (2) `C1=True C2=True C3=False Δ=0`; en todas, `instrumento` = `recalculado`. Última línea: `archivos 24 | diferencias recalculado-instrumento 0 | errores 0 | peticiones externas 0 | hover máx 0 | estados 90 | |scrollY-scrollTop| máx 0.0`. = esperado en lo que mide (0 diferencias, 0 errores, 0 peticiones, `hover` 0, las dos lecturas de la posición idénticas en los 90 estados), con una imprecisión **del esperado**, no del instrumento: escribí "`C3=False` en todas", y las cuatro corridas estáticas de M6 (`forzado`, `sinforzar`) no tienen ficha y dan `C3=None` en los dos cálculos; y no fijé su C1, que da `True` (sin Atrás, el hash, la pestaña y el banner no cambian). Error propio **E-1** (esperado impreciso).

**Paso 2 (c) — control adversarial de R-11** (agregado y declarado: la cifra de C2 de T1 y T2 se obtuvo siempre con una ficha más alta que la posición del panorama, porque la ficha mide 7.283 px a 1280 y 19.342 a 390 y la tarjeta 36 se centra en 4.689 y 16.552; R4 mostró que el navegador restaura aunque se pase por una vista corta, pero no con la ficha como vista corta). `/tmp/s34a_r2c.sh`, nuevo: la tarjeta más baja (`frac 0.999`, `k = 59`) con clic a 1280 y a 390 con los dos instrumentos, y a 390 una intermedia (`frac 0.8`, `k = 48`):
```
bash /tmp/s34a_r2c.sh
```
esperado: se registra. Lo que se sabe antes: la tarjeta 59 se centra por debajo del máximo de la ficha (1280: máximo de la ficha 6.483; 390: 18.542), así que al abrir la ficha la página se recorta a ese máximo (`ficha y` = 6483 y 18542, menor que `Y0`) y C3 falla. Hipótesis por R4: al volver, el navegador restaura `Y0` y C2 pasa (`Δ = 0`, la misma tarjeta dentro). C1 pasa. 0 errores, 0 peticiones externas, sin esperas con problema. Si C2 falla, es un hallazgo del motor (ADVIERTE), no del instrumento.
obtenido: `hora 10:57`. 1280, tarjeta 59: `antes: motor '' h2 pest=0 y=6796 alto=7596 origen[top=341.36 dentro=sí]` → `ficha: motor #ficha h3 pest=1 y=6483 alto=7283 ficha-name[top=-6113.47 dentro=no]` → `despues: motor '' h3 pest=0 y=6796 origen[top=341.36 dentro=sí]` (`tardio` igual); `C1[… hash_de_antes=PASA] C2[Δ=0 |Δ|=0 dentro=sí mismo=sí pasa=PASA] C3[FALLA top=-6113.47 y=6483]`. 390, tarjeta 59: `antes … y=25425 alto=26225 origen[top=340.59 dentro=sí]` → `ficha: #ficha h3 pest=1 y=18511 alto=19311 ficha-name[top=-17814.55 dentro=no]` → `despues: '' h3 pest=0 y=25425 origen[top=340.59 dentro=sí]` (`tardio` igual); `C1 … PASA`, `C2[Δ=0 … pasa=PASA]`, `C3[FALLA top=-17814.55 y=18511]`. 390, tarjeta 48: `antes … y=20957 origen[top=210.59 dentro=sí]` → `ficha: #ficha h3 pest=1 y=18542 alto=19342 ficha-name[top=-17845.55 dentro=no]` → `despues: '' h3 pest=0 y=20957 origen[top=210.59 dentro=sí]`; `C1 … PASA`, `C2[Δ=0 … pasa=PASA]`, `C3[FALLA top=-17845.55 y=18542]`. Los tres con `esperas con problema: [] | errores: 0 | red_externa: 0`. Segundo instrumento: `s34a_r2c_ult_1280_r.json: n 60 k 59 | antes top=6796 | ficha #ficha top=6483 | despues '' top=6796 | Δ=0 | C1=PASA C2=PASA C3=FALLA | esperas ['abrir ok', 'ficha ok', 'volver al panorama ok'] | errores 0`; `s34a_r2c_ult_390_r.json: n 60 k 59 | antes top=25425 | ficha #ficha top=18511 | despues '' top=25425 | Δ=0 | C1=PASA C2=PASA C3=FALLA | … | errores 0`. = esperado en lo que se afirmó: la ficha recorta la posición (6.483 y 18.511/18.542, menores que `Y0`), C3 falla, y **al volver el navegador restaura `Y0`: C2 pasa** también con la ficha más baja que la posición del panorama (hasta 6.914 px de diferencia a 390), con los dos instrumentos y con las dos formas de volver. La hipótesis de R4 se confirma: R-11 no depende de la geometría de estos recorridos. Una cifra del "lo que se sabe antes" no se cumplió: a 390 anticipé `ficha y = 18542` para la tarjeta 59 y fue 18.511, porque su ficha mide 19.311 px (31 menos que la de la tarjeta 36): el alto de la ficha depende del establecimiento. Error propio **E-2** (esperado con una cifra supuesta).

**Pasos 3 a 5 — invariantes, alcance global y regresión** (`/tmp/s34a_r345.sh`, nuevo: 🔒1 con `openssl md5`; 🔒2 y alcance con `git diff --name-only 117b705..HEAD` y el porcelain; la re-derivación de R-01 (`HEAD`, padre y archivos del primer acto, stash) y de R-16 (`grep -cE` de las cinco marcas de desplazamiento en la plantilla y, como dato, en `docs/`); PRUEBAS, que es a la vez 🔒3 y el paso 5):
```
bash /tmp/s34a_r345.sh
```
esperado: 🔒1 `MD5(…/docs/index.html)= c5542b2013b6fb6e5d42f709ca723c3c` y `MD5(…/40_salidas/motor_idps.html)= c5542b2013b6fb6e5d42f709ca723c3c`; 🔒2 `diff <inicio>..HEAD: []` (el LOG aún no se commitea: ⊆ {LOG}) y `porcelain: [?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md|?? "Claude outputs/"|]` (el LOG y la carpeta ajena; el "vacío al final" de 🔒2 se mide en FASE L, después del commit del LOG); `R-01: HEAD=117b705 | 117b705^=8ddd6c8 | archivos de 117b705: 50_documentacion/activa/encargos/encargo_claude_code_idps_atras_desplazamiento_s34a.md | stash: []`; `R-16: plantilla 0 | docs <n>` (`docs/` lleva React, ReactDOM, D3 y pako en línea: un número distinto de 0 se lee en contexto, no es hallazgo por sí solo); PRUEBAS con las mismas nueve líneas de M3 (siete `[OK]`, `[INFO]` md5 `c5542b20…`, `verificar_motor: todo cuadra`) y `rc=0`.
obtenido: `hora 10:58`; 🔒1 `MD5(/Users/tomgc/Projects/slep_idps/docs/index.html)= c5542b2013b6fb6e5d42f709ca723c3c`, `MD5(/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html)= c5542b2013b6fb6e5d42f709ca723c3c`; 🔒2 `diff <inicio>..HEAD: []`, `porcelain: [?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md|?? "Claude outputs/"|]`; `R-01: HEAD=117b705 | 117b705^=8ddd6c8 | archivos de 117b705: 50_documentacion/activa/encargos/encargo_claude_code_idps_atras_desplazamiento_s34a.md | stash: []`; `R-16: plantilla 0 | docs 1`; PRUEBAS: las siete `[OK]` de M3, `[INFO] docs/index.html y 40_salidas/motor_idps.html: el mismo archivo, md5 c5542b2013b6fb6e5d42f709ca723c3c`, `verificar_motor: todo cuadra`, `rc=0` (salida completa en `/tmp/s34a_r345.out`). = esperado: 🔒1 PASA, 🔒2 PASA en lo que se puede medir antes del commit del LOG, 🔒3 PASA; R-01 y R-16 (plantilla 0) re-derivados. La línea de `docs/` con una marca se lee en contexto a continuación.

**R-16 en `docs/`, en contexto** (`/tmp/s34a_r16.sh`, nuevo, solo lectura):
```
bash /tmp/s34a_r16.sh
```
esperado: se registra: el número de la línea, su tamaño y comienzo, y los fragmentos con la marca; se espera que la línea sea de una biblioteca en línea (React, ReactDOM, D3 o pako) y no el JSX transpilado de la plantilla (que tiene 0 marcas); si fuera del JSX, sería hallazgo (la premisa del encargo no valdría para el motor publicado).
obtenido: `línea 7779: 503 bytes; comienza: a.addRange(b)))}b=[];for(a=c;a=a.parentNode;)1===a.nodeType&&b.push({element:a,l`; fragmentos `;)1===a.nodeType&&b.push({element:a,left:a.scrollLeft,top:a.scrollTop});"function"===typeof c.focus&&c.focus();for(c=0;c<b.lengt` y `h;c++)a=b[c],a.element.scrollLeft=a.left,a.element.scrollTop=a.top}}function dh(a,b,c){var d=c.window===c?c.document:9=`. = esperado: la marca es `scrollTop` (el patrón `scrollTo` la contiene como subcadena) dentro de ReactDOM en línea (código minificado de React: al devolver el foco a un elemento, guarda el `scrollTop` de sus ancestros y lo **repone** tal cual, para que el foco no desplace nada); no es código de la plantilla, que tiene 0. La premisa del encargo vale para el motor publicado: la posición la decide el navegador.

**Paso 6 — control positivo de la auditoría** (`/tmp/s34a_r6.sh`, nuevo: el recorrido del paso 2 (`r_atras.js`, 1280, tarjeta `floor(0,3 × n)`, `history.go(-1)`) sobre `/tmp/s34a_motor_s33t.html`, con clic y con teclado):
```
bash /tmp/s34a_r6.sh
```
esperado: `MD5(/tmp/s34a_motor_s33t.html)= b3daf503514a49b56426339e75fb7d82`; en los dos, `n 60 k 18`, `antes '' idx=0 top=2375`, `ficha '' idx=1` (ese motor no escribe la dirección), `despues '' idx=-1` (Atrás sale del motor), **`C1=FALLA`**, la espera `volver al panorama AGOTADA`, `errores 0`.
obtenido: `hora 10:58`; `MD5(/tmp/s34a_motor_s33t.html)= b3daf503514a49b56426339e75fb7d82`; `s34a_r6_clic.json: n 60 k 18 | antes '' idx=0 top=2375 | ficha '' idx=1 | despues '' idx=-1 top=0 | C1=FALLA C2=FALLA C3=FALLA | esperas ['abrir ok', 'ficha ok', 'volver al panorama AGOTADA'] | errores 0`; `s34a_r6_teclado.json:` lo mismo. = esperado: **el control positivo de la auditoría falla C1**, como debe; el recorrido re-derivado discrimina.

**Paso 2 (d) — informativo, agregado y declarado** (insumo para la duda de C3; no es remedio, no toca ningún archivo y no entra en C1, C2 ni C3). `/tmp/s34a_r_sim.js`, nuevo (humo previo sin errores): (1) registra `scrollY` y `scrollHeight` en `popstate`, en `hashchange` y en los cuadros siguientes al volver con `history.go(-1)`; (2) simula "la ficha abre arriba" envolviendo, **en la página y en tiempo de ejecución**, `history.pushState` para llamar `window.scrollTo(0,0)` justo antes o justo después de escribir la dirección. `/tmp/s34a_r2d.sh`, nuevo: tarjeta más baja a 1280 sin simulación (línea de tiempo con la ficha más corta que la posición), y tarjeta 36 con la simulación antes y después, a 1280 y 390:
```
bash /tmp/s34a_r2d.sh
```
esperado: se registra. Hipótesis, escritas antes: (1) con la tarjeta 59 a 1280, en `popstate` la página todavía es la ficha recortada (`6483/7283`) y cuando el panorama ya está dibujado la posición es `Y0 = 6796` (`Δ=0`); (2) con la subida **después** de escribir la dirección, la ficha abre arriba (`ficha y=0`, nombre visible) y Atrás devuelve `Y0` (`Δ=0`); con la subida **antes**, la posición guardada del panorama pasa a ser 0 y Atrás vuelve arriba (`Δ = −Y0`). 0 errores; esperas `ficha ok` y `panorama ok`.
obtenido: `hora 11:01`; los cinco con `['ficha ok', 'panorama ok']` y `errores 0`.
- `s34a_r2d_1280_ult_ninguna.json: k 59 Y0=6796 | ficha y=6483 nombre_top=-6113.47 | despues '' y=6796 origen_dentro=True | Δ=0`; línea de tiempo `popstate:6483/7283 hashchange:6796/7596 raf1:6796/7596 … raf5:6796/7596`.
- `s34a_r2d_1280_06_antes.json: k 36 Y0=4689 | ficha y=0 nombre_top=369.53 | despues '' y=0 origen_dentro=False | Δ=-4689`; `popstate:0/7283 hashchange:0/7596 raf1:0/7596 …`.
- `s34a_r2d_1280_06_despues.json: k 36 Y0=4689 | ficha y=0 nombre_top=369.53 | despues '' y=6692 origen_dentro=False | Δ=2003`; `popstate:0/7283 hashchange:6692/7596 raf1:6692/7596 …`.
- `s34a_r2d_390_06_antes.json: k 36 Y0=16552 | ficha y=0 nombre_top=696.45 | despues '' y=0 origen_dentro=False | Δ=-16552`; `popstate:0/19342 hashchange:0/26225 …`.
- `s34a_r2d_390_06_despues.json: k 36 Y0=16552 | ficha y=0 nombre_top=696.45 | despues '' y=25321 origen_dentro=False | Δ=8769`; `popstate:0/19342 hashchange:25321/26225 …`.

Contra las hipótesis: (1) **se cumple**: en `popstate` la página es todavía la ficha, recortada (`6483/7283`), y cuando llega `hashchange` el panorama ya está dibujado y en `Y0` (`6796/7596`); pero en este caso `Y0` coincide con el máximo del panorama, así que por sí solo no distingue "restaura `Y0`" de "restaura algo mayor y se recorta"; el caso que sí lo distingue es el de la tarjeta 48 a 390 del paso 2 (c) (`Y0 = 20957`, lejos del máximo 25.425, restaurado exacto). (2) la subida **antes** se cumple (Atrás vuelve arriba, `Δ = −Y0`); la subida **después no se cumple**: la ficha abre arriba, pero Atrás no devuelve `Y0` sino otra posición (6.692 a 1280 y 25.321 a 390; `Δ` +2.003 y +8.769), con la tarjeta de origen fuera del viewport. El mecanismo de ese salto no se midió (ocurre entre `popstate` y `hashchange`, durante el dibujo del panorama). **Lectura para la duda de C3:** en esta simulación, llevar la ficha arriba con un `scrollTo(0,0)`, en cualquiera de los dos lugares naturales, rompe C2; un remedio de C3 tendría que guardar la posición del panorama al salir y reponerla al volver (la opción (b) de la duda de C2). Error propio **E-3**: la hipótesis (2) "después" era equivocada (se escribió antes de medir y se anota tal cual).

**Paso 7 — veredictos por hallazgo** (antes de reparar):
- **R-20 · REPARA (LOG):** el párrafo del instrumento en FASE 0 ("**Instrumento** (`/tmp/s34a_atras.js`, …") dice que la ficha se espera por `.ficha-name` y el comparador por `.cmp-add`, y que "Los clics son de ratón en el centro del elemento"; el código acepta `.ficha-name` **o** `.screen-stub-title` (la invitación de la ficha sin establecimiento, que es la que abre M7) y `.cmp-add` **o** `.cmp-empty` (`/tmp/s34a_atras.js` L45 y L47), y el cambio a "Vista histórica" de M4 y R2 es un `click()` desde la página, no de ratón (L118 y L158). Sin efecto en las cifras: las activaciones que se miden (tarjeta, `.vt-ee-btn`, pestañas) sí son de ratón, y el cambio de vista ocurre antes de desplazar. Detectado por lectura del código contra el log.
- **R-21 · REPARA (LOG):** en T2, la frase "(la restauración espera a que la página vuelva a tener alto)" era una inferencia cuando se escribió (R4 solo mostraba el resultado); ahora la respaldan el paso 2 (c) (tarjeta 48 a 390: `Y0 = 20957`, ficha en 18.542, vuelta exacta a 20.957) y la línea de tiempo del paso 2 (d) (`popstate:6483/7283` → `hashchange:6796/7596`). Debe quedar dicho que era inferencia y dónde quedó medida.
- **A-1 · ADVIERTE:** C1 por la letra (`#panorama`) falla en todos los recorridos del motor publicado; se leyó como "hash de antes" por decisión del titular en el gate (R-09). A Dudas.
- **A-2 · ADVIERTE (hallazgo del motor, no se repara):** C3 falla en todas las entradas a la ficha medidas (T1 4/4, R2 2/2, R3 y R4 en su parte R1, paso 2 (a) 3/3, paso 2 (c) 5/5): la ficha abre en la posición que tenía el panorama, con el nombre miles de píxeles por encima; y la simulación del paso 2 (d) muestra que subir la ficha con un `scrollTo(0,0)` rompería C2. A Dudas.
- **A-3 · ADVIERTE:** `Claude outputs/` (ajena, 10:46:24) deja el porcelain no vacío: la condición del push no se cumplirá mientras siga ahí. A Dudas.
- **A-4 · ADVIERTE:** mediciones agregadas y declaradas, más allá de lo que pide el encargo (M5 en los cuatro casos de R1; M6 y M7 en los dos anchos; M6 también dentro del recorrido; paso 2 (a) con una tarjeta comparable con T1; pasos 2 (c) y 2 (d)); ninguna cambia un criterio, una tolerancia ni un esperado.
- **A-5 · ADVIERTE:** errores propios E-1 (esperado impreciso en el paso 2 (b)), E-2 (una cifra supuesta en el paso 2 (c)) y E-3 (hipótesis equivocada en el paso 2 (d)), declarados junto a su `obtenido:`; la evidencia no se edita.
- Sin hallazgo: R-01 a R-19 re-derivados conformes (pasos 2 a 6); R-16 en `docs/` es ReactDOM (`scrollTop` repuesto tal cual), no código del motor. **Ningún BLOQUEA.**

**Paso 8 — ciclo de reparación 1** (sobre el LOG; cada corrección cita la frase anterior, que no se edita):
- **Corrección (R-20):** donde el párrafo **Instrumento** de FASE 0 dice "`.ficha-name` para la ficha, `.cmp-add` para el comparador" y "Los clics son de ratón en el centro del elemento", debe leerse: la ficha se espera por `.ficha-name` o `.screen-stub-title` (la invitación, en M7), el comparador por `.cmp-add` o `.cmp-empty`, y los clics de **activación** (tarjeta, `.vt-ee-btn`, pestañas) son de ratón; el cambio a "Vista histórica" (M4, R2) es un `click()` desde la página.
- **Corrección (R-21):** la frase de T2 "(la restauración espera a que la página vuelva a tener alto)" fue una inferencia al escribirla; quedó medida después, en el paso 2 (c) (tarjeta 48 a 390) y en la línea de tiempo del paso 2 (d).

**Re-verificación del ciclo 1** (`/tmp/s34a_r8.sh`, nuevo: (1) el chequeo que detectó, por lectura: las cuatro líneas del instrumento y las dos correcciones en el LOG; (2) uno distinto, por comportamiento: en M7 (1280) la ficha se reconoció sin `.ficha-name` (la invitación), y en el paso 2 (c) la tarjeta 48 a 390 volvió a `Y0` después de una ficha más corta):
```
bash /tmp/s34a_r8.sh
```
esperado: (1) `L45 … .ficha-name … .screen-stub-title`, `L47 … .cmp-add … .cmp-empty`, `L118` y `L158` con `.click())` desde `p.evaluate`; en el LOG, `correcciones R-20: 1 | R-21: 1`; (2) `M7 1280 ficha: ficha-name ausente | espera "clic pestaña Ficha: ficha: ok"`; `2c 390 k 48: antes 20957 | ficha 18542 (máximo 18542) | despues 20957 | Δ 0`.
obtenido: (1) `L45 return !!a && t.indexOf(a) === 1 && !!(document.querySelector('.ficha-name') || document.querySelector('.screen-stub-title')); };`; `L47 return !!a && t.indexOf(a) === 2 && !!(document.querySelector('.cmp-add') || document.querySelector('.cmp-empty')); };`; `L118` y `L158` `await p.evaluate(() => [...document.querySelectorAll('.pan-nivel .lvl-b')].find(b => b.textContent.trim() === 'Vista histórica').click());`; `correcciones R-20: 1 | R-21: 1`; (2) `M7 1280 ficha: ficha-name ausente | espera "clic pestaña Ficha: ficha: ok"`; `2c 390 k 48: antes 20957 | ficha 18542 (máximo 18542) | despues 20957 | Δ 0`. = esperado: R-20 y R-21 reparados y re-verificados por los dos chequeos.

**Paso 2 (e) — complemento de la re-derivación** (al armar la tabla del paso 10 vi que R-13, R-14 y R-15 solo tenían el veredicto del instrumento: `r_crit.py` recalcula C1 a C3, no la vista histórica, la ficha de Adelante ni los pasos intermedios de la cadena; se corre ahora, después del ciclo 1, y se declara). `/tmp/s34a_r2e.py`, nuevo, desde los estados crudos:
```
python3 /tmp/s34a_r2e.py
```
esperado: `R-13 1280: antes vista=Vista histórica | despues vista=Vista histórica` y lo mismo a 390; `R-14 1280: adelante hash=#ficha pestaña=1 | md5 .ficha-name igual al de "ficha": True` y lo mismo a 390; `R-15 1280: comparador hash=#comparador pestaña=2 y=217 | atras 1 hash=#ficha pestaña=1 y=4689 | despues y=4689 (antes 4689)`; `R-15 390: comparador hash=#comparador pestaña=2 y=1273 | atras 1 hash=#ficha pestaña=1 y=16552 | despues y=16552 (antes 16552)`.
obtenido: `R-13 1280: antes vista=Vista histórica | despues vista=Vista histórica`; `R-13 390: antes vista=Vista histórica | despues vista=Vista histórica`; `R-14 1280: adelante hash=#ficha pestaña=1 | md5 .ficha-name igual al de "ficha": True`; `R-14 390:` lo mismo; `R-15 1280: comparador hash=#comparador pestaña=2 y=217 | atras 1 hash=#ficha pestaña=1 y=4689 | despues y=4689 (antes 4689)`; `R-15 390: comparador hash=#comparador pestaña=2 y=1273 | atras 1 hash=#ficha pestaña=1 y=16552 | despues y=16552 (antes 16552)`. = esperado.

**Paso 10 — salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | Partida `8ddd6c8` = `origin/main`; primer acto `117b705` | `r345.sh` (R-01) | `HEAD=117b705`, padre `8ddd6c8`, solo el encargo, stash vacío | igual | — | ninguna | — | — |
| R-02 | md5 de `docs/` y del motor `c5542b20…` (🔒1) | `r345.sh` (🔒1) | los dos `c5542b20…` | igual | — | ninguna | — | — |
| R-03 | PRUEBAS `rc=0` (🔒3) | `r345.sh` (PRUEBAS) | siete `[OK]`, `rc=0` | igual | — | ninguna | — | — |
| R-04 | Puppeteer y Chrome disponibles | todas las corridas de FASE R | los instrumentos lanzan Chrome | lanzaron, 0 errores | — | ninguna | — | — |
| R-05 | Recorrido largo; 60 tarjetas y 61 filas | `r2a.sh` (`n`), `r2c.sh` (`Y0` hasta 25.425) | `n 60`; desplazamiento hasta el máximo de M4 | `n 60`; `Y0` 6.796 y 25.425 = máximos de M4 | — | ninguna | — | — |
| R-06 | Caso malo: C1 falla | `r_crit.py` (M5) y paso 6 (`r6.sh`, otro instrumento, `go(-1)`) | C1 falso ×4; C1 FALLA ×2 | igual | — | ninguna | — | — |
| R-07 | Control positivo del desplazamiento | `r_crit.py` (M6) | C2 falso en forzado y plantado, verdadero sin forzar | igual | — | ninguna | — | — |
| R-08 | Caso bueno: C1 pasa | `r_crit.py` (M7) | C1 verdadero ×2 | igual | — | ninguna | — | — |
| R-09 | C1 = "hash de antes" (gate) | — (decisión del titular) | — | — | ADVIERTE (A-1) | a Dudas | — | — |
| R-10 | T1: C1 4/4 | `r_crit.py` (T1); `r2a.sh` | verdadero ×4; PASA ×3 | igual | — | ninguna | — | — |
| R-11 | T1: C2 4/4 | `r_crit.py`; `r2a.sh` (otra tarjeta, `go(-1)`, `scrollTop`, otro código); `r2c.sh` (tarjeta más baja, ficha más corta) | `Δ 0`; discrepancia con T1 ≤ 1 | `Δ 0`; discrepancia 0; C2 pasa también con la ficha más corta (5/5) | — | ninguna | — | — |
| R-12 | T1: C3 0/4 | `r_crit.py`; `r2a.sh`; `r2c.sh` | C3 falso | falso en todos | ADVIERTE (A-2) | a Dudas | — | — |
| R-13 | R2: C1, histórica conservada, C2; C3 falla | `r_crit.py` (R2); `r2e.py` | verdadero, verdadero, falso; histórica antes y después | igual | — (C3: A-2) | ninguna | — | — |
| R-14 | R3: Adelante a `#ficha`, misma ficha | `r2e.py` | `#ficha`, pestaña 1, md5 igual | igual ×2 | — | ninguna | — | — |
| R-15 | R4: `#comparador` → `#ficha` → panorama con C1 y C2; el comparador recorta y Atrás restaura | `r_crit.py` (R4); `r2e.py` | `#comparador` y 217/1.273; `#ficha` y `Y0`; panorama en `Y0` | igual ×2 | — (C3: A-2) | ninguna | — | — |
| R-16 | La plantilla no desplaza la página | `r345.sh` (R-16); `r16.sh` | plantilla 0; `docs/` en contexto | 0; `docs/` 1 línea = ReactDOM (`scrollTop` repuesto) | — | ninguna | — | — |
| R-17 | 0 errores, 0 peticiones externas, `hover` 0 | `r_crit.py` (totales) | 0 / 0 / 0 | 0 / 0 / 0 en 90 estados; `scrollY` = `scrollTop` | — | ninguna | — | — |
| R-18 | Ninguna escritura fuera del LOG | `r345.sh` (porcelain) | el LOG y la carpeta ajena | igual | ADVIERTE (A-3) | a Dudas | — | — |
| R-19 | 🔒2 | `r345.sh` (diff) | `[]` antes del commit del LOG | `[]` | — | se cierra en FASE L | — | — |
| R-20 | Descripción del instrumento (esperas y clics) | lectura de `/tmp/s34a_atras.js` L45, L47, L118, L158 | lo que dice el log | el código acepta además la invitación y `.cmp-empty`; "Vista histórica" por `click()` | REPARA | corrección anexada (ciclo 1) | — (va en `docs(log)`) | `r8.sh` (1) lectura y (2) comportamiento: conforme |
| R-21 | "La restauración espera a que la página vuelva a tener alto" | pasos 2 (c) y 2 (d) | medido | era inferencia; medido después (390 tarjeta 48; `popstate` → `hashchange`) | REPARA | corrección anexada (ciclo 1) | — (va en `docs(log)`) | `r8.sh` (1) y (2): conforme |
| A-4 | Mediciones agregadas y declaradas | — | — | M5 ×4, M6 y M7 ×2 anchos, M6 plantado, pasos 2 (c), 2 (d), 2 (e) | ADVIERTE | declarada | — | — |
| A-5 | Errores propios E-1 a E-3 | — | — | declarados junto a su `obtenido:` | ADVIERTE | declarada | — | — |

- **Veredicto de FASE R: APROBADO CON ADVERTENCIAS.** Hallazgos BLOQUEA/REPARA/ADVIERTE = 0/2/5 (R-20, R-21; A-1 a A-5); reparados 2 en el ciclo 1 (de 2), re-verificados por el chequeo que los detectó y por otro distinto; controles positivos 2 de 2 (el paso 6 de la auditoría sobre el motor de s33t falla C1; el desplazamiento plantado de M6 se detecta), más M5. Los hallazgos del motor (C3 en falla, A-2) se reportan y no se reparan, como manda el encargo.

- **Estado de FASE R:** completada.

### FASE L: cierre del log

**Paso 1 — árbol y procesos** (`/tmp/s34a_l1.sh`, nuevo, solo lectura: porcelain; instrumentos `node /tmp/s34a*` vivos; Chrome headless vivos, con su hora de inicio, y cuántos empezaron hoy desde las 10:08):
```
bash /tmp/s34a_l1.sh
```
esperado: `porcelain: [?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md|?? "Claude outputs/"|]` (el paso pide "solo el LOG (o vacío)": la carpeta ajena de FASE 0 lo impide si sigue ahí, y se registra como diferencia atribuida, A-3); `node de los instrumentos s34a: 0`; Chrome headless de esta sesión: `0` iniciados desde las 10:08 (cada instrumento cierra su navegador; si hay otros, son de otras sesiones y no se tocan).
obtenido: `hora 11:05`; `porcelain: [?? 50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md|?? "Claude outputs/"|]`; `node de los instrumentos s34a: 0`; `Chrome headless vivos (hora de inicio): 21:01:06`; `de ellos, iniciados hoy desde las 10:08: 0`. = esperado: ningún proceso de esta sesión sigue corriendo; el único Chrome headless vivo empezó a las 21:01:06 de otro día (el ajeno que ya registraron s33t y s33u) y no se toca. El porcelain difiere de "solo el LOG" por la carpeta ajena (A-3).

**Paso 2 — secciones de cierre.**

**Resumen.** Con el motor publicado (`c5542b20…`) y el sitio abierto sin dirección, bajar por el panorama, abrir un establecimiento y volver con Atrás **vuelve al panorama** (C1: la misma pestaña, el mismo territorio y la misma vista, actual o histórica; la dirección vuelve a la de antes, que al abrir sin dirección es vacía) y **vuelve al mismo lugar** (C2: `Δ = 0` px y la tarjeta o fila de origen en el mismo punto de la pantalla), a 1280 y a 390, con clic y con teclado, desde la vista actual y desde la histórica, pasando por el comparador y también cuando la ficha es más corta que la posición del panorama; Adelante devuelve la misma ficha. Lo que **no** pasa es C3: la ficha se abre en la misma posición vertical que tenía el panorama, así que se llega a ella a media página, con el nombre del establecimiento miles de píxeles por encima (4.319 px a 1280 y 15.856 a 390 con la tarjeta 36). La posición la decide el navegador (la plantilla no desplaza la página): `pushState` no mueve nada y, al volver, el navegador repone la posición guardada de cada entrada del historial, aunque la vista desde la que se vuelve sea más corta. Una simulación en tiempo de ejecución, sin tocar archivos, muestra que subir la ficha con un `scrollTo(0,0)` rompería C2 (antes de escribir la dirección, Atrás vuelve arriba; después, a otro lugar). El instrumento se calibró antes de medir: falla sobre el motor anterior a las direcciones, detecta un desplazamiento plantado y da por bueno el caso bueno; y la auditoría lo re-derivó con otro código, otra tarjeta, otra forma de volver y otra lectura de la posición. C1 se leyó como "hash de antes" por decisión del titular en el gate (la letra, `#panorama`, es inalcanzable abriendo sin dirección).

**Commits:** `117b705` chore(encargo): s34a (primer acto, `<inicio>`); `git log --oneline 117b705..HEAD` da vacío antes del commit de este log; con él, `docs(log): s34a atrás tras desplazarse`. Ninguno `fix(auditoria)` (las dos reparaciones son del LOG y van en ese commit).

**Auditoría (FASE R):** APROBADO CON ADVERTENCIAS; B/R/A = 0/2/5; reparados 2 (R-20, R-21) en el ciclo 1 de 2, re-verificados por dos chequeos; controles positivos 2 de 2 (el paso 6 sobre el motor de s33t falla C1; el desplazamiento plantado de M6 se detecta), más M5.

**Invariantes:** 🔒1 `docs/index.html` y `40_salidas/motor_idps.html` `c5542b2013b6fb6e5d42f709ca723c3c` en FASE 0 (M3) y en FASE R (`r345.sh`) — PASA; 🔒2 (i) `git diff --name-only 117b705..HEAD` ⊆ {el LOG} — PASA (vacío en FASE R; tras el commit, solo el LOG, que se mide en el paso 6); (ii) porcelain vacío al final — **no se cumple por la letra** por `?? "Claude outputs/"`, una ruta sin seguimiento que escribió la app del titular (10:46:24) y no el encargo: se trata como ADVIERTE (A-3), como en s32, y no como BLOQUEA; el push no corre; 🔒3 PRUEBAS `rc=0` en FASE 0 (M3) y en FASE R (`r345.sh`) — PASA.

**Tabla consolidada de C1, C2 y C3** (C1 con la lectura del gate; por la letra, `#panorama`, falla en todas las filas del motor publicado):

| recorrido | ancho | entrada · origen | C1 | C2 (Δ) | C3 (`.ficha-name` top) | extra |
|---|---|---|---|---|---|---|
| R1 (T1) | 1280 | clic · tarjeta 36 | PASA | PASA (0) | FALLA (−4.319,47) | — |
| R1 (T1) | 1280 | teclado · tarjeta 36 | PASA | PASA (0) | FALLA (−4.319,47) | — |
| R1 (T1) | 390 | clic · tarjeta 36 | PASA | PASA (0) | FALLA (−15.855,55) | — |
| R1 (T1) | 390 | teclado · tarjeta 36 | PASA | PASA (0) | FALLA (−15.855,55) | — |
| R2 (T2) | 1280 | clic · fila 36 de la histórica | PASA | PASA (0) | FALLA (−3.747,47) | vista histórica conservada |
| R2 (T2) | 390 | clic · fila 36 de la histórica | PASA | PASA (0) | FALLA (−7.818,55) | vista histórica conservada |
| R3 (T2) | 1280 | clic · tarjeta 36 + Adelante | PASA | PASA (0) | FALLA (−4.319,47) | Adelante: `#ficha`, misma ficha |
| R3 (T2) | 390 | clic · tarjeta 36 + Adelante | PASA | PASA (0) | FALLA (−15.855,55) | Adelante: `#ficha`, misma ficha |
| R4 (T2) | 1280 | clic · tarjeta 36 → comparador → Atrás ×2 | PASA | PASA (0) | FALLA (−4.319,47) | Atrás 1: `#ficha`; el comparador recorta a 217 |
| R4 (T2) | 390 | clic · tarjeta 36 → comparador → Atrás ×2 | PASA | PASA (0) | FALLA (−15.855,55) | Atrás 1: `#ficha`; recorta a 1.273 |
| R1 re-derivado (FASE R) | 1280 | clic y teclado · tarjeta 18; clic · tarjeta 36 (`go(-1)`) | PASA ×3 | PASA ×3 (0) | FALLA ×3 | discrepancia con T1: 0 |
| R1, tarjeta más baja (FASE R) | 1280 / 390 | clic · tarjeta 59 (dos instrumentos); 390 tarjeta 48 | PASA ×5 | PASA ×5 (0) | FALLA ×5 | la ficha recorta (6.483; 18.511; 18.542) y Atrás repone `Y0` |
| M7 (caso bueno) | 1280 / 390 | pestañas | PASA ×2 | — | — | — |
| M5 y paso 6 (motor de s33t) | 1280 / 390 | R1 ×4; re-derivado ×2 | FALLA ×6 | — | — | Atrás sale del motor |

**Dudas (con pregunta cerrada):**
- **D-1 (A-1, C1 por la letra):** abriendo el sitio sin dirección, Atrás vuelve al panorama con la dirección vacía (así lo decidió el titular en s33u: sin dirección no se escribe nada), y C1 pedía `#panorama`; el gate lo leyó como "hash de antes". ¿(a) Se adopta esa lectura en la redacción de los encargos ("el hash que tenía el panorama al salir"); (b) encargo para que la apertura sin dirección escriba `#panorama` con `replaceState` (sin agregar entrada al historial), con lo que la letra se cumpliría (y entonces D-1 de s33u, `#xyz`, se resuelve igual)?
- **D-2 (A-2, C3 en falla):** la ficha abre en la misma posición vertical que tenía el panorama: a 1280 con la tarjeta 36, el nombre queda 4.319 px por encima del borde; a 390, 15.856 px (y 17.815 con la tarjeta 59). ¿(a) Se acepta como está; (b) encargo para que la ficha abra arriba? Nota para (b), medida en simulación (paso 2 (d) de FASE R): un `scrollTo(0,0)` al abrir la ficha rompe C2, sea antes de escribir la dirección (Atrás vuelve arriba) o después (Atrás cae 2.003 px más abajo a 1280 y 8.769 a 390); el encargo de (b) tendría que guardar la posición del panorama al salir y reponerla al volver, y verificarse con este instrumento (T1, T2 y M6).
- **Sin duda de C2:** C2 no falla en ningún caso medido (19 recorridos del motor publicado), así que la duda que el encargo prevé para C2 no se abre.
- **D-3 (A-3):** `Claude outputs/20260926_registro_asistente_s34.md` (1.785 B, 10:46:24, de la app del titular) deja el porcelain no vacío; por la autorización, el push de `main` **no corre**. ¿(a) El titular la saca del repo (o la ignora en `.gitignore`) y publica con `! git -C /Users/tomgc/Projects/slep_idps push origin main`; (b) se deja y el push espera a la próxima sesión?
- **D-4:** temporales `/tmp/s34a_*` (instrumentos, 40 salidas JSON, la copia del motor de s33t, `/tmp/s34a_priv_nombres.txt` y `/tmp/s34a_priv_control.md`, que contienen nombres de establecimientos tomados del motor público); la lista cerrada no admite `rm`. ¿(a) Los borra el titular (al menos los dos de privacidad); (b) se dejan?
- **D-5:** el instrumento `/tmp/s34a_atras.js` (y su resumen) es el que haría falta para verificar un remedio de D-2, y `/tmp` puede vaciarse. ¿(a) Encargo para versionarlo en `tests/` como verificación de navegación; (b) se deja en `/tmp` y el encargo del remedio lo reescribe?

**Errores propios:** E-1 esperado impreciso en el paso 2 (b) de FASE R ("`C3=False` en todas": las corridas estáticas de M6 dan `None`; y no fijé su C1); E-2 una cifra supuesta en el esperado del paso 2 (c) (la ficha de la tarjeta 59 a 390 mide 19.311, no 19.342); E-3 hipótesis equivocada en el paso 2 (d) (la subida "después" no conserva la posición); E-4 escribí "10:2x" como hora del gate sin medirla (corregido en FASE 0); E-5 descripción imprecisa del instrumento en FASE 0 (R-20, reparada); E-6 una inferencia escrita como hecho en T2 (R-21, reparada). Ninguno con efecto en las cifras medidas.

**Estado de cierre:** FASE 0 completada · T1 completada (medición; C1 4/4, C2 4/4, C3 0/4) · T2 completada (R2, R3 y R4 en los dos anchos) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada con el commit `docs(log)`; el push no corre mientras `Claude outputs/` siga en el árbol (D-3).
- **Corrección (D-4):** escribí "40 salidas JSON" sin contarlas; `ls /tmp/s34a_*.json | wc -l` da `43` (con las cuatro de las pruebas de humo). Error propio **E-7** (cifra no medida), sin efecto en la medición.

**Paso 3 — bloque J:** rellenado arriba, trece campos, una línea cada uno, copiados de este detalle.

**Paso 4 — privacidad** (`/tmp/s34a_priv.sh`, nuevo: patrón de RUT, "RBD" seguido de un número, palabras de nombre de establecimiento y los nombres exactos de las tarjetas y filas del panorama de apertura, leídos del motor publicado por `/tmp/s34a_priv_nombres.js` sin imprimirlos; control plantado en una copia del LOG en `/tmp/s34a_priv_control.md`, armado por el script y sin imprimirlo; los patrones viven solo en el script):
```
bash /tmp/s34a_priv.sh
```
esperado: `nombres: tarjetas 60 | filas 61 | distintos <n>`; `control plantado (copia del LOG + 4 líneas): RUT 1 | RBD con número 1 | palabras de nombre ≥ 1 | nombres exactos 1`; `LOG: RUT 0 | RBD con número 0 | palabras de nombre 0 | nombres exactos 0`.
obtenido: `nombres: tarjetas 60 | filas 61 | distintos 61`; `control plantado (copia del LOG + 4 líneas): RUT 1 | RBD con número 1 | palabras de nombre 2 | nombres exactos 1` (el nombre plantado lleva una de las palabras); `LOG: RUT 0 | RBD con número 0 | palabras de nombre 0 | nombres exactos 0`. = esperado: el LOG no lleva RUT, RBD ni nombres de establecimiento, y el chequeo detecta cada uno cuando se planta.

**Paso 5 — verificación del archivo** (`ls -l` y `wc -l`; secciones de fase; conteo de `esperado:` y `obtenido:`; una sola sección J):
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260926_atras_desplazamiento_s34a_log.md; ls -l $L && wc -l $L; echo "fases $(grep -c "^### FASE" $L) | esperado $(grep -c "^esperado:" $L) | obtenido $(grep -c "^obtenido:" $L) | J $(grep -c "^## J" $L)"'
```
esperado: el archivo con su tamaño y sus líneas; `fases 5` (FASE 0, T1, T2, R y L); `esperado 25 | obtenido 24` al medir (falta el `obtenido:` de esta misma medición, que se anexa después: 25 = 25); `J 1`.
obtenido: `-rw-r--r--  1 tomgc  staff  76896 26 Sep 11:07 …/20260926_atras_desplazamiento_s34a_log.md`; `397` líneas; `fases 5 | esperado 25 | obtenido 24 | J 1` (con esta línea, 25 = 25). = esperado.

**Paso 6 — commit del log y push.** `git add` del LOG (ruta explícita) y `git commit -m "docs(log): s34a atrás tras desplazarse"`. El push autorizado exige que FASE R no termine en `BLOQUEADO` (se cumple), `HEAD..origin/main` = 0 (se mide tras el commit) y el porcelain vacío: mientras `Claude outputs/` siga en el árbol, **el push no corre** y queda para el titular (D-3). El resultado se da en el reporte final.
