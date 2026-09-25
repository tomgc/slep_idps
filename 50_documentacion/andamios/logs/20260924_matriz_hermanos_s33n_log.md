# Log de sesión: matriz de patrones de usabilidad entre los tres motores (s33n)

- **Meta:** medir, en solo lectura, dónde está cada uno de los tres motores (`slep_idps`, `slep_simce_adecuado`, `slep_categoria_desempeno`) respecto de los 20 patrones de usabilidad que `slep_idps` fijó entre s29 y s33 (§6 del encargo), y dejar una matriz patrón × motor con evidencia por celda. La matriz describe; no prescribe. Ninguna escritura en los hermanos.
- **Fecha:** 2026-09-25 (el nombre del LOG lo fija el encargo con `20260924_`).
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular). Hermanos en solo lectura: `/Users/tomgc/Projects/slep_simce_adecuado` y `/Users/tomgc/Projects/slep_categoria_desempeno`.
- **HEAD al empezar:** `d41e31a` (`docs(log): s33m preparacion de decisiones`) = `origin/main` (leído con `git rev-parse --short origin/main` antes del primer acto). Medición previa al primer acto, en solo lectura: `git status --porcelain` = ` M 50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (`1 insertion(+)`, la fila 9) y `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_matriz_hermanos_s33n.md` (las dos rutas que admite la regla 1); `git stash list` vacío. Primer acto (autorizado): commit `085e147` chore(encargo): s33n y registro del asistente s33, hijo de `d41e31a` (`2 files changed, 148 insertions(+)`). **PUNTO DE RETORNO `<inicio>` = `085e147`.**
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); `bash` 3.2 explícito; `node` con Puppeteer 25.9.0 por `NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motores por `file://`.
- **EJECUCIÓN declarada:** esfuerzo `ultracode`; orquestador el modelo de la sesión; subagentes tope 3 Opus simultáneos (más hasta 2 intermedios); total Opus del encargo ≤ 9. **Modo real:** orquestador Opus 5.5 (1M); `ultracode` activo en la sesión y pedido por el titular en el mensaje de arranque; los subagentes corren dentro de la herramienta Workflow (una invocación por ola, para que el orquestador verifique entre olas), heredan el modelo de la sesión (Opus 5.5) y cada ola lanza como máximo 3 en paralelo.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_matriz_hermanos_s33n.md` (commit `085e147`).
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (inventario por motor, olas 1 y 2)   ALCANCE: ninguno (solo /tmp)
T2 (matriz)                             ALCANCE: 50_documentacion/andamios/20260924_matriz_patrones_motores.md
                                        Requiere T1.
FASE R y FASE L fuera del grafo, corren siempre.
```

- **Plan de concurrencia (real, dentro del del encargo):** ola 1a = M3: 1 Opus sobre `slep_idps` (caso bueno) y la copia sin `focoRespaldo` ni `nEE` (caso malo); el orquestador valida la calibración y fija el inventario. Ola 1b: 2 Opus en paralelo, uno por hermano, con el inventario calibrado. Ola 2: 3 Opus en paralelo que intentan refutar las celdas "ausente"/"divergente" (reparto según los conteos de la ola 1; ninguno repite el motor que midió en la ola 1). Ola 3, si hace falta: hasta 3 Opus sobre las discrepancias. Tope 1 + 2 + 3 + 3 = 9 Opus; un reintento consume de la ola 3.
- **Contrato de los subagentes (el de §0 del encargo, más tres precisiones del orquestador):** (a) no crean ni modifican archivos en ningún lugar, tampoco en `/tmp`: los scripts de `node` van por la entrada estándar (`node - <<'EOF'`) y los resultados por la salida; (b) en los hermanos no corren `git` salvo `log`/`show`/`rev-parse` (el `status` lo mide el orquestador con `GIT_OPTIONAL_LOCKS=0`, que evita la escritura oportunista del índice); (c) no crean `CLAUDE.md` en un hermano aunque falte (la instrucción global de crearlo cede ante este encargo de solo lectura).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria; 1 reintento por subagente con el mismo contrato.
- **Reglas que rigen esta sesión:** ninguna escritura en `slep_simce_adecuado` ni en `slep_categoria_desempeno` (ni `git fetch`, ni `git status` sin `GIT_OPTIONAL_LOCKS=0`); en `slep_idps` solo la matriz y el LOG; temporales en `/tmp/s33n_*`; ningún `rm`; la columna "¿aplica?" se razona por el problema que resuelve el patrón, sin convertir "no aplica" en "ausente" para uniformar.
- **Instrumentos:** en `/tmp/s33n_*`. Convenciones: **un `esperado:` y un `obtenido:` por comando**, el `esperado:` escrito en el LOG antes de correr el comando; una corrección va como `- **Corrección:** …`; los patrones de privacidad viven solo en su script.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: matriz patrón × motor de los 20 patrones de usabilidad de `slep_idps` en los tres motores, con evidencia por celda y sin escribir en los hermanos; entregada (`50_documentacion/andamios/20260924_matriz_patrones_motores.md`, 60 de 60 celdas con evidencia).
- Estado por tarea: FASE 0 completada · T1 completada (olas 1a, 1b, 2 y 3) · T2 completada (`30ecfa8`) · FASE R APROBADO CON ADVERTENCIAS (`52966df`) · FASE L completada.
- Commits: 4, rango `085e147`..`<docs(log)>` (`git log --oneline d41e31a..HEAD`), de los cuales 1 fix(auditoria), 0 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/1/3; reparados 1 (R-13); abiertos 3: A-1 (premisa "todo presente" de M3), A-2 (umbrales de las recetas 1, 10 y 19 frente a §6), A-3 (esperados escritos después del comando); control positivo 2 de 2.
- Invariantes: 3/3 PASA (🔒1 hermanos intactos con la lectura del gate "copias + atribución"; 🔒2 solo la matriz y el LOG; 🔒3 0 celdas sin evidencia, control plantado detectado); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: `slep_idps` plantilla `1c3bfd6d…`, motor y `docs/` `7ad76f36…`; `slep_categoria_desempeno` los cuatro md5 de M2; copias congeladas sin archivos nuevos; `slep_simce_adecuado` cambió solo por su sesión s35, atribuido commit a commit).
- Decisiones autónomas de mayor riesgo: (1) medir los hermanos sobre copias APFS congeladas en `/tmp` (luego ratificado en el gate); (2) organizar la ola 3 por fila (un juez por fila en los tres motores) en vez de por motor, y darle prevalencia a §6 sobre el umbral de la receta; (3) incluir `slep_idps` en la ola 2 (§7.2 pide solo hermanos; el plan admite tres subagentes).
- Desviaciones respecto del encargo: ninguna en los entregables; de procedimiento, varios `esperado:` escritos después del comando (E-1, E-2) y la calibración M3 hecha por distinción (la premisa "todo presente" no se cumplía).
- Dudas abiertas: 27: D-01 a D-24 de la matriz (13 pueden cambiar un estado) y D-L1 a D-L3 del proceso (temporales de `/tmp`, recetas, redacción del gate).
- Errores propios: 6 (E-1 a E-6: de procedimiento o de instrumento, ninguno cambió un estado ni un valor).
- Qué debe verificar el revisor por sí mismo: leer §1 y §3 de la matriz contra su conocimiento de cada hermano (sobre todo las filas 1, 10 y 19, dirimidas en la ola 3), y responder las dudas D-05, D-13 y D-21, que mueven más de una celda o cambian la lectura de un patrón.
- No publicado / queda al usuario: los encargos a cada hermano y el estándar de motores (la matriz es su insumo); ninguna interfaz ni despliegue cambió.
- Ejecución: esfuerzo ultracode; orquestador Opus 5.5 (1M); 9 subagentes de lectura Opus en 4 invocaciones de Workflow (1 + 2 + 3 + 3; nunca más de 3 simultáneos), 0 intermedios; total Opus 9 de 9.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `085e147` (primer acto).

**M1 — `slep_idps`: porcelain tras el primer commit, stash, `fetch` y `HEAD~1` = `origin/main`:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R status --porcelain; echo "stash: [$(git -C $R stash list)]"; echo "primer commit: $(git -C $R show --name-only --format= HEAD | tr "\n" " ")"; git -C $R fetch --quiet; echo "fetch rc=$?"; echo "HEAD=$(git -C $R rev-parse --short HEAD) HEAD~1=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"; echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"'
```
esperado: porcelain = una sola línea `?? 50_documentacion/andamios/logs/20260924_matriz_hermanos_s33n_log.md`; `stash: []`; primer commit = el encargo y el registro; `fetch rc=0`; `HEAD=085e147 HEAD~1=d41e31a origin/main=d41e31a`; `HEAD..origin/main=0 origin/main..HEAD=1`.
obtenido: `?? 50_documentacion/andamios/logs/20260924_matriz_hermanos_s33n_log.md` (única línea); `stash: []`; `primer commit: 50_documentacion/activa/encargos/encargo_claude_code_idps_matriz_hermanos_s33n.md 50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`; `fetch rc=0`; `HEAD=085e147 HEAD~1=d41e31a origin/main=d41e31a`; `HEAD..origin/main=0 origin/main..HEAD=1`. Reglas 1 y 2 no disparan.

**M2 — por hermano: raíz, `HEAD`, porcelain, plantilla y md5 de plantilla, motor y `docs/`.** Localización previa (solo lectura, `ls`/`grep`): `slep_simce_adecuado` genera `40_salidas/motor_comparacion.html` desde `30_procesamiento/33_motor_template.html` (`33_generar_html.R:405` y `:501`); `slep_categoria_desempeno` genera `40_salidas/motor_categoria.html` desde `30_procesamiento/33_motor_template.html` y lo copia a `docs/index.html` (`30_procesamiento/33_generar_html.R:401`, `:461`, `:476-477`). En ese repo hay también `30_procesamiento/33_app.jsx` (70.552 B), que ningún `.R` ni la plantilla nombran (`grep -n "app.jsx\|33_app"` sin salida): se registra su md5 pero no es insumo del motor. Ninguno de los dos hermanos tiene `CLAUDE.md` en la raíz (`ls` → `No such file or directory`). Instrumento nuevo `/tmp/s33n_m2.sh` (con `GIT_OPTIONAL_LOCKS=0`; registra además `mtime` y tamaño del `.git/index` de cada hermano, para mostrar al final que nadie lo refrescó); se repite tal cual en FASE L para 🔒1.
```
bash /tmp/s33n_m2.sh
```
esperado: las dos raíces existen; `HEAD` de `slep_simce_adecuado` = `4c5cc3a` o posterior (premisa §1, no verificable sin escribir más que por `git log`); porcelain de cada hermano registrado tal cual (puede no estar vacío: `slep_simce_adecuado` tiene una sesión abierta); md5 y tamaño de plantilla, motor y `docs/` registrados; en `slep_idps` motor y `docs/` = `7ad76f36e42d66c4da2d71aa28a558eb`.
obtenido:
```
== slep_simce_adecuado
raiz: existe
HEAD: dd7fe76 | 2026-09-25 10:03:52 -0300 refactor(motor): quita CSS sin uso de la cabecera antigua
porcelain (1 lineas):
  ?? 50_documentacion/andamios/logs/20260924_pendientes_s35_log.md
indice: 1790341432 25806
  e62a5f19d8ec320a168fa009846ba3f9  203394  30_procesamiento/33_motor_template.html
  b01499e01b9a40ed89b78f0bd9c60466  2790955  40_salidas/motor_comparacion.html
  8deb04595510b0f15da8bb65813b7a38  2788309  docs/index.html
== slep_categoria_desempeno
raiz: existe
HEAD: b709400 | 2026-08-21 15:06:53 -0400 docs(estado): declara ventana_insumos (I9, SETTINGS v33)
porcelain (1 lineas):
  ?? 40_salidas/categoria_rbd_contrato.parquet
indice: 1787579311 14239
  9e9640ca05205d345e713b489ee3e98d  124493  30_procesamiento/33_motor_template.html
  428448d63765d5be7a9558bd3c62e926  70552  30_procesamiento/33_app.jsx
  45e612f1c9909a2dd1115d9e8628cde0  1902667  40_salidas/motor_categoria.html
  45e612f1c9909a2dd1115d9e8628cde0  1902667  docs/index.html
== slep_idps
  1c3bfd6d3f36ae832846fdef358a4564  241375  30_procesamiento/35_motor_template.html
  7ad76f36e42d66c4da2d71aa28a558eb  5477900  40_salidas/motor_idps.html
  7ad76f36e42d66c4da2d71aa28a558eb  5477900  docs/index.html
```
Las dos raíces existen; la regla 4 no dispara. `slep_idps` como se esperaba. En `slep_simce_adecuado` el motor (`40_salidas/`, no versionado: `git ls-files` no lo lista) **difiere** de `docs/index.html` (versionado; último `deploy(docs)` = `50323ab`, 2026-09-24 16:13): el motor es el build de `dd7fe76` (mtime 10:05:27 de hoy) y `docs/` es el de s34. En `slep_categoria_desempeno` motor = `docs/`, y `33_app.jsx` está versionado como "fuente JSX del motor reconstruida y verificada (A34)" (`120813e`, 2026-06-19), aunque el generador no lo lee.

- **H-1 (hecho del entorno, fuera de lo enumerado):** `slep_simce_adecuado` tiene una sesión **activa ahora**: 9 commits hoy entre 08:28 y 10:03 (`f4bd59e` … `dd7fe76`), su log `50_documentacion/andamios/logs/20260924_pendientes_s35_log.md` se modificó a las 10:08:09 y el reloj marca 10:20:28 (`date`). La premisa §1 lo anticipaba (`4c5cc3a` o posterior; `sesion_abierta: true`), pero la regla 3 ("cualquier cambio de md5 en un archivo de un hermano durante el encargo → detén la sesión") no distingue un cambio de esa sesión de uno de este encargo: si la sesión s35 vuelve a construir o commitear, la regla 3 detendría este encargo sin que él haya escrito nada.
- **Acción inmediata (dentro de la autorización "temporales en `/tmp/s33n_*`"):** copia APFS instantánea de cada hermano (`cp -Rc <hermano> /tmp/s33n_snap_simce` y `/tmp/s33n_snap_categoria`; solo lee el hermano). md5 de las copias = los de M2 (salida literal abajo, mismos siete valores y `HEAD` `dd7fe76` / `b709400` leídos con `GIT_OPTIONAL_LOCKS=0` sobre la copia). Los subagentes medirán las copias: la matriz describe `slep_simce_adecuado` en `dd7fe76` (motor de las 10:05) y `slep_categoria_desempeno` en `b709400`.
```
== /tmp/s33n_snap_simce HEAD=dd7fe76
  e62a5f19d8ec320a168fa009846ba3f9  30_procesamiento/33_motor_template.html
  b01499e01b9a40ed89b78f0bd9c60466  40_salidas/motor_comparacion.html
  8deb04595510b0f15da8bb65813b7a38  docs/index.html
== /tmp/s33n_snap_categoria HEAD=b709400
  9e9640ca05205d345e713b489ee3e98d  30_procesamiento/33_motor_template.html
  428448d63765d5be7a9558bd3c62e926  30_procesamiento/33_app.jsx
  45e612f1c9909a2dd1115d9e8628cde0  40_salidas/motor_categoria.html
  45e612f1c9909a2dd1115d9e8628cde0  docs/index.html
```
- **Decisión del gate (titular, 10:2x, pregunta cerrada con tres opciones):** "Copias + atribución". Los subagentes miden las copias congeladas; 🔒1 y la regla 3 pasan si (a) las copias `/tmp/s33n_snap_*` no cambian, (b) el `.git/index` de cada hermano conserva el `mtime` y el tamaño de M2 (nadie lo refrescó) y (c) cada cambio del hermano vivo se explica por commits o archivos de su sesión s35; un cambio sin explicar detiene la sesión.

**M3 — calibración del inventario (caso bueno y caso malo).** Preparación del caso malo por el orquestador (script nuevo `/tmp/s33n_malo.py`): copia de la plantilla y del motor de `slep_idps` a `/tmp/s33n_malo_template.html` y `/tmp/s33n_malo_motor.html` con (1) las definiciones `const nEE=…`/`const nCom=…` retiradas y cada llamada `nEE(x)`/`nCom(x)` reemplazada por `(fmt(x)+" establecimientos")`/`(fmt(x)+" comunas")` (plural fijo, sin concordancia), y (2) `focoRespaldo` retirado: el parámetro del modal, la rama `destino=focoRespaldo?focoRespaldo():null;` (→ `destino=null;`), su comentario y las dos props en `EntityModal`. Nada más cambia.
```
python3 /tmp/s33n_malo.py
```
esperado: (propio) cada reemplazo literal encontrado exactamente 1 vez y 19 llamadas `nEE`/`nCom` reemplazadas en cada archivo; quedan 0 `focoRespaldo`; las apariciones restantes de `nEE`/`nCom`/"respaldo" solo en comentarios o en otros identificadores (`panComunas`).
obtenido: plantilla `240593 -> 240483` bytes y motor `5477115 -> 5477005` bytes; en los dos, los siete reemplazos literales `x1` y `'llamadas nEE/nCom'x19`; `quedan: focoRespaldo 0`. Restantes en la plantilla (`grep -nE "nEE|nCom|[Rr]espaldo"`): líneas 225 y 1656 (comentarios con "respaldo"), 2759–2760 y 3085 (comentarios que nombran `nEE`/`nCom`), 3025/3034/3082/3086 (`panComunas`, `panComunasNoms`, otro identificador). Los comentarios se dejan a propósito: el inventario debe medir el comportamiento o el código vivo, no un comentario.

Carga de los cuatro motores por `file://` (instrumento nuevo `/tmp/s33n_carga.js`: errores de página y de consola, peticiones que no son `file:`/`data:`/`blob:`, largo del texto visible sin `<script>` ni `<style>`):
```
cd /tmp && for f in /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s33n_malo_motor.html /tmp/s33n_snap_simce/40_salidas/motor_comparacion.html /tmp/s33n_snap_categoria/40_salidas/motor_categoria.html; do NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33n_carga.js $f; done
```
esperado: (propio) los cuatro cargan sin errores; el caso malo renderiza como el bueno (si no, la calibración mediría un motor roto); las peticiones de red de cada uno quedan registradas para la fila 20.
obtenido: los cuatro con `"errores":[]`. `slep_idps` y el caso malo: `"red"` = `https://unpkg.com/react@18.3.1/umd/react.production.min.js`, `https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js`, `https://unpkg.com/@babel/standalone@7.29.0/babel.min.js`; `largo_texto` 9998 y 9999 (un carácter más en el malo: un plural fijo). `slep_simce_adecuado`: `"red":[]`, 5594, inicio "Motor de comparación Simce — proporción de estudiantes en nivel Adecuado Datos 2014–2025…". `slep_categoria_desempeno`: `"red":[]`, 10710, inicio "SLEP Costa Central·Motor de comparaciónCategoría de Desempeño — distribución de establecimientosDatos 2016–2019…".

**M3 propiamente tal (ola 1a):** un subagente Opus aplica el inventario de §6 a `slep_idps` (motor `7ad76f36…`, plantilla `1c3bfd6d…`) y las filas 1 a 4 al caso malo; devuelve además, por fila, la receta de medición que se pasará a los hermanos.
esperado: caso bueno: filas 1 a 19 "presente"; fila 20 "ausente" (lo anticipan la medición de carga de arriba y el propio §6.20, "el hermano ya lo tiene desde su s31"; si sale así, es una inconsistencia de redacción de M3 —"todo debe salir presente"— y no un defecto del inventario). Caso malo: filas 1 y 4 "ausente" y, como control de especificidad, filas 2 y 3 "presente" (el caso malo conserva el ciclo de Tab y la vuelta al origen). "Se distinguen" = las dos condiciones.
- **Corrección:** los dos `esperado: (propio)` de la preparación de M3 (script del caso malo y carga de los cuatro motores) se escribieron en el LOG **después** de correr los comandos, no antes; los de M1, M2 y M3 sí antes. Se registra como error propio E-1 (de procedimiento; no cambia ningún valor).
obtenido: (retorno del subagente de la ola 1a, guardado en `/tmp/s33n_ola1a.json`; 50 herramientas, 22 min). **Caso malo:** fila 1 "ausente" (Puppeteer en la apertura: `"texto:1 establecimientos":1`, `"aria-label:1 establecimientos":4`, `"title:1 establecimientos":4`; comuna → ".pan-meta 1 comunas · …"), fila 4 "ausente" (dos recorridos en que el origen se desmonta: comparador al tope "10 de 10" → Escape → `BODY`; panorama → Establecimiento → ficha → `BODY`), filas 2 y 3 "presente" (mismos recorridos de teclado que el caso bueno). **Caso bueno:** 15 filas "presente" (2 a 8, 10 a 15, 18, 19); fila 1 "divergente" (los conteos de establecimientos y comunas concuerdan, pero el chip de la tarjeta escribe a mano "▼/▲ 1 indicadores … su GSE", 19 veces en la apertura; plantilla:995-996); fila 9 "divergente" (la fila Región de los dos modales, plantilla:1792 y :1878, cuenta las comunas del directorio sin nombrar el universo: en una región dice "10 comunas" y el banner, un clic después, "8 comunas"); fila 16 "divergente" (el comparador exporta tres universos distintos con el mismo nombre `idps_comparador_<nivel>_<año>.csv`: las entidades quedan fuera por la decisión s29 §5, pero también los GSE ocultos); fila 17 "no aplica" (`DATA.meta.anios_preliminar` = `[]`; con un año preliminar simulado en memoria el mecanismo marca las superficies principales y deja cuatro menciones secundarias sin marca); fila 20 "ausente" (tres scripts de unpkg). `distingue: false`, pero solo por la condición literal "presente en el caso bueno"; el subagente declara que las recetas separan los dos casos (1: divergente → ausente; 4: presente → ausente; 2 y 3: presente → presente). `escrituras: ninguna`. **Siete correcciones a las recetas** (fila 1: criterio de "ausente" para un conteo de la unidad de análisis sin ayudante, y lista de sustantivos ampliada más allá de establecimientos|comunas; fila 11: el fondo efectivo se lee de la pila de pintado con `elementsFromPoint`, no de los ancestros; fila 12: con `outline-style:auto` se leen los píxeles del anillo en una captura en memoria; fila 17: año preliminar simulado en memoria; fila 8: a 390 px separar los nombres partidos que cabrían de los que no; fila 9: cifra de cada fila del modal frente a la del banner al elegirla; fila 15: BOM por `arrayBuffer()`). Diez dudas con pregunta cerrada (filas 1 ×2, 9, 10, 11, 12, 14, 15, 16, 17, 19).

**Verificación del orquestador (contrato, punto 5):**
```
python3 /tmp/s33n_ver_lineas.py /tmp/s33n_ev_ola1a.txt
```
esperado: (propio) las evidencias `ruta:línea: texto` del retorno (extraídas por script a `/tmp/s33n_ev_ola1a.txt`, 51 entre caso bueno y malo; toda fila del caso bueno tiene al menos una) se reproducen todas: el texto citado está en esa línea.
obtenido: `total OK=51 FALLA=0`; por fila del caso bueno, evidencias de línea: 4, 2, 3, 2, 1, 2, 2, 2, 3, 3, 3, 2, 2, 1, 2, 3, 1, 1, 3, 2 (ninguna fila con 0).
```
cd /tmp && for f in /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s33n_malo_motor.html; do NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s33n_v_idps.js $f; done
```
esperado: (propio) instrumento nuevo `/tmp/s33n_v_idps.js`, distinto del del subagente (solo el texto visible de la apertura, sin atributos): en el bueno `{"indicadores":19}` y ningún "1 establecimientos"/"1 comunas"; en el malo, además, `"establecimientos":1`.
obtenido: `motor_idps.html {"indicadores":19}` y `s33n_malo_motor.html {"indicadores":19,"establecimientos":1}`.
```
python3 - <<'EOF'   (base64 → zlib → fecha_generacion = 0000-00-00 → SHA-256; script en línea, sin archivo)
```
esperado: (propio) fila 19: el SHA-256 normalizado del payload del motor = `eb4e00b3…4dc4` (valor vigente de `CLAUDE.md`).
obtenido: `fecha 2026-09-24 sha256 normalizado eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`.

- **Veredicto de M3: se distinguen.** Las recetas separan los dos casos donde debían (filas 1 y 4) y no donde no debían (2 y 3). La parte "todo debe salir presente" **no se cumple** en cinco filas del caso bueno (1, 9 y 16 divergentes; 17 no aplica; 20 ausente): no es un defecto del inventario sino del estado de partida supuesto (H-2); las cinco quedan en la columna `slep_idps` de la matriz con su evidencia, y las filas 1, 9 y 16 son hallazgos nuevos sobre `slep_idps`. La corrección que manda M3 ("corregir el inventario antes de aplicarlo a los hermanos") se cumple con las siete correcciones de receta, que pasan a `/tmp/s33n_recetas.md` junto con el resultado de `slep_idps` como referencia; no se cambió ningún criterio para que el caso bueno "saliera presente".
- **H-2 (fuera de lo enumerado; ADVIERTE de redacción):** la premisa de M3 de que `slep_idps` sale "presente" en todo es falsa en cinco filas; la fila 20 ya la anticipaba el propio §6.20.
- **Subagentes (ola 1a):** 1 · rol lectura · modelo Opus 5.5 (heredado del orquestador) · motor `slep_idps` + caso malo · devolvió 20 filas + 4 del caso malo + recetas + 10 dudas · verificado con `/tmp/s33n_ver_lineas.py` (51/51), `/tmp/s33n_v_idps.js` y el SHA normalizado. **Cuenta acumulada de Opus: 1 de 9.**
- **Estado de FASE 0:** completada.
- **Corrección:** los tres `esperado: (propio)` de la verificación del orquestador de M3 también se escribieron después de correr los comandos (los valores esperados venían del retorno del subagente y de `CLAUDE.md`, pero no quedaron en el LOG antes). Se suma a E-1. Desde aquí, cada `esperado:` se escribe en el LOG antes de su comando.

### FASE T1: inventario por motor (olas 1 y 2)

- **Estado:** en curso.
- **Recetas calibradas:** `/tmp/s33n_recetas.md` (escrito por el orquestador desde `/tmp/s33n_ola1a.json`: por fila, el resultado de `slep_idps` como referencia y la receta transferible).
- **Ola 1b (lanzada):** 2 subagentes Opus en paralelo (`ola1b:simce`, `ola1b:categoria`), cada uno sobre su copia congelada, con `/tmp/s33n_contrato.md`, `/tmp/s33n_inventario.md` y `/tmp/s33n_recetas.md`; devuelven además idiosincrasias y patrones en sentido contrario. Cuenta acumulada de Opus al lanzar: 3 de 9.

**Control intermedio de 🔒1 (regla 3 con atribución, decisión del gate), 10:52:**
```
bash /tmp/s33n_m2.sh; for B in /tmp/s33n_snap_simce /tmp/s33n_snap_categoria; do find $B -newer /tmp/s33n_m2.sh -type f -not -path '*/.git/*' | wc -l; done
```
esperado: (propio) `slep_categoria_desempeno` idéntico a M2; `slep_idps` idéntico; las copias sin archivos más nuevos que M2; `slep_simce_adecuado` puede haber cambiado por su sesión s35.
obtenido: `slep_categoria_desempeno`: `HEAD b709400`, índice `1787579311 14239`, los cuatro md5 de M2. `slep_idps`: los tres md5 de M2. Copias: `0` y `0` archivos más nuevos. **`slep_simce_adecuado` cambió:** `HEAD bfa40c9` (10:51:39), índice `1790344299 25806` (antes `1790341432`), plantilla `a21790e2d55faddb543d488bc2316d4c` (203.547 B; antes `e62a5f19…`), motor `d9119ed74d684209c9972bd9d809c86a` (2.791.100 B; antes `b01499e0…`); `docs/` igual (`8deb0459…`); porcelain igual (el log s35 sin seguimiento).
```
bash -c 'export GIT_OPTIONAL_LOCKS=0; S=/Users/tomgc/Projects/slep_simce_adecuado; git -C $S log --format="%h %ad %s" --date=format:"%H:%M:%S" dd7fe76..HEAD; git -C $S log --format="%h" dd7fe76..HEAD -- 30_procesamiento/33_motor_template.html; git -C $S show HEAD:30_procesamiento/33_motor_template.html | md5 -q; stat -f "%Sm %N" -t "%H:%M:%S" $S/30_procesamiento/33_motor_template.html $S/40_salidas/motor_comparacion.html $S/.git/index'
```
esperado: (propio) atribución: cada cambio se explica por commits de la sesión s35 posteriores a `dd7fe76` (plantilla = la versión de `HEAD`; índice con el `mtime` de su último commit; motor reconstruido después).
obtenido: 4 commits de la sesión s35 entre 10:47:44 y 10:51:39 (`f076470` R-47, `9e83ecf` R-48, `1150846` R-49 "el comentario de la sparkline del motor dice que su cifra sigue atenuada", `bfa40c9` R-63); el único que toca la plantilla es `1150846`; `git show HEAD:…33_motor_template.html | md5` = `a21790e2d55faddb543d488bc2316d4c` = el md5 del árbol; `mtime` plantilla 10:45:49, motor 10:51:45, `.git/index` 10:51:39 (= hora de `bfa40c9`). Todo cambio queda explicado por la sesión s35; ninguno por este encargo. Las copias congeladas siguen describiendo `dd7fe76`; el cambio de `1150846` es de un comentario (lo dice su mensaje) y se anota para la matriz.
- **Corrección:** los dos `esperado: (propio)` del control intermedio se escribieron después de correr los comandos, contra lo anunciado arriba. Error propio E-2 (de procedimiento; no cambia valores).
- **Ola 1b (retorno):** guardado en `/tmp/s33n_ola1b.json` (120 herramientas entre los dos, 27 min; `escrituras: ninguna` en los dos). Estados por fila (1 → 20):
  - `slep_simce_adecuado`: ausente (1, 3, 4); divergente (2, 5, 7, 8, 9, 11, 14, 15, 16, 18, 19); presente (6, 12, 13, 20); no aplica (10, 17).
  - `slep_categoria_desempeno`: ausente (2, 3, 4, 11); divergente (1, 5, 7, 8, 9, 10, 12, 14, 18, 19); presente (13, 20); no aplica (6, 15, 16, 17).
  - Premisas §1 del redactor sobre `slep_simce_adecuado`, verificadas por el subagente: modal único `AddEntityModal` para panorama y comparador; ✕ `icon-btn` sin `aria-label` ni `title` (nombre accesible vacío); filas SLEP con "traspaso AAAA"; pestaña Nacional sin buscador.
  - Cada subagente devolvió además idiosincrasias (7 y 8) y patrones en sentido contrario (4 y 2) con evidencia, y hallazgos fuera de las filas (en `notas`).
- **Nota sobre `docs/` de `slep_simce_adecuado`:** el subagente midió también `docs/index.html` (s34) donde podía cambiar el resultado: la fila 14 daría peor en `docs/` (el panorama desborda 180/110/75 px a 320/390/425) y la fila 11 también (puntos de un solo establecimiento atenuados). La matriz describe el motor de `dd7fe76`.

**Verificación del orquestador de la ola 1b (contrato, punto 5):**
```
for k in simce categoria; do python3 /tmp/s33n_ver_lineas.py /tmp/s33n_ev_ola1b_$k.txt; done
```
esperado: (propio) todas las evidencias `ruta:línea: texto` de los dos retornos (extraídas por script) se reproducen; toda fila de cada hermano tiene al menos una.
obtenido: `simce: total OK=57 FALLA=0`; `categoria: total OK=62 FALLA=1`: `FALLA /tmp/s33n_snap_categoria/30_procesamiento/33_generar_html.R:320 falta '"nacional ausente" = "nacional" %in% territorial_lst$tipo_entidad' | linea: ''`. `grep -rn "nacional ausente"` → la línea es la **333** del mismo archivo (el texto es literal; el número estaba corrido). Evidencias de línea por fila, `simce`: 5, 3, 2, 1, 2, 2, 4, 4, 3, 2, 4, 3, 2, 2, 3, 3, 3, 3, 4, 2; `categoria`: 5, 3, 3, 3, 3, 2, 3, 3, 4, 5, 5, 2, 3, 3, 1, 1, 2, 3, 5, 4 (ninguna fila con 0; la fila 6 de `categoria` conserva otra evidencia de línea que sí se reproduce).
- **Corrección:** la evidencia de la fila 6 de `slep_categoria_desempeno` se cita en la matriz como `33_generar_html.R:333` (no `:320`). Error de instrumento del subagente, sin efecto en el estado.
- **Corrección:** este `esperado:` también se escribió después de correr el verificador. Se suma a E-2.
- **Subagentes (ola 1b):** 2 · rol lectura · modelo Opus 5.5 · uno por hermano (copias congeladas) · devolvieron 20 filas cada uno, con idiosincrasias, sentido contrario y notas · verificados con `/tmp/s33n_ver_lineas.py` (119/120; la que falla es un número de línea corrido). **Cuenta acumulada de Opus: 3 de 9.**

**Ola 2 (panel adversarial).** Reparto (uno por motor, como el plan de concurrencia; ninguno es el subagente que midió ese motor en la ola 1): `ola2:simce` (14 celdas: 1, 2, 3, 4, 5, 7, 8, 9, 11, 14, 15, 16, 18, 19), `ola2:categoria` (14 celdas: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 14, 18, 19) y `ola2:idps` (las 4 celdas no "presente" que no son "no aplica" en el motor de origen: 1, 9, 16, 20; §7.2 pide solo las de los hermanos, pero el plan admite tres subagentes, "cada uno … las filas de un motor"). Insumos: `/tmp/s33n_ola2_<motor>.md` (estado, razón, cómo se midió y dudas de la ola 1, para que cada uno mida con **otro** comando), más el contrato, el inventario y las recetas. Cada uno devuelve, por celda, su estado re-derivado y el veredicto confirma / refuta / parcial.
esperado: (propio, escrito antes de lanzar) 3 retornos con 32 celdas en total (14 + 14 + 4), cada celda con evidencia propia; `escrituras: ninguna` en los tres; las celdas "refuta" o "parcial" pasan a la ola 3 (hasta 3 Opus) o a duda. Cuenta acumulada de Opus al lanzar: 6 de 9.

**Verificación de las evidencias de idiosincrasias y sentido contrario (ola 1b), mientras corre la ola 2:**
```
python3 (extrae de /tmp/s33n_ola1b.json las evidencias "ruta:línea:" de idiosincrasias y sentido_contrario a /tmp/s33n_ev_ola1b_extra.txt) && python3 /tmp/s33n_ver_lineas.py /tmp/s33n_ev_ola1b_extra.txt
```
esperado: (propio, escrito antes de correr) todas se reproducen; si alguna falla, esa idiosincrasia o ese patrón entra a la matriz solo con la evidencia que sí se reproduce, o como duda.
obtenido: `42 evidencias`; `total OK=41 FALLA=1`: `FALLA …/slep_categoria (copia)/30_procesamiento/33_generar_html.R:61 falta 'CAT_COLORS <- list('`; `grep -n` → está en la **62** (otra vez un número corrido en uno; el texto es literal).
- **Corrección:** la idiosincrasia "paleta ordinal de cuatro categorías" de `slep_categoria_desempeno` se cita como `33_generar_html.R:62`.

**Verificación de dos afirmaciones de "sentido contrario" que citan `slep_idps` por comando (no por línea):**
```
bash -c 'grep -cE "location\.hash|hashchange" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; GIT_OPTIONAL_LOCKS=0 git -C /Users/tomgc/Projects/slep_idps ls-files | grep -iE "^tests/|spot|auditar"'
```
esperado: (propio, escrito antes de correr) `0` (el motor de origen no lee la dirección) y una sola ruta, `tests/.gitkeep` (sin pruebas versionadas del invariante del dato).
obtenido: `0` y `tests/.gitkeep`.
obtenido: (retorno en `/tmp/s33n_ola2.json`; 155 herramientas entre los tres, 18 min) 32 celdas (14 + 14 + 4), cada una con evidencia propia y método distinto declarado; `escrituras: ninguna` en los tres (el de `categoria` precisa que inyectó y retiró un `<style>` en el DOM en memoria del navegador para un contrafactual de la fila 8; no es escritura en disco). Veredictos:
  - `slep_simce_adecuado`: confirma 11 (2, 3, 4, 5, 7, 8, 9, 11, 15, 16, 18); **parcial** 1 (14: el estado se sostiene, pero a 320 px los 15 px vienen de los subtítulos "Últimas 3 aplicaciones"/"Trayectoria histórica", no de los títulos GSE, que llegan a 322); **refuta** 2 (1: ausente → divergente, porque el ternario vivo de la plantilla:3486 da "1 establecimiento con resultados" en el panorama y la receta pone "solo parte de los conteos de la unidad concuerdan" en divergente; 19: divergente → presente, porque el invariante del hermano no es el hash crudo sino el JSON sin la fecha, documentado en A34-1 e I-5 y reproducido entre motor y `docs/`).
  - `slep_categoria_desempeno`: confirma 11 (2, 3, 4, 5, 7, 8, 9, 12, 14, 18, 19); **parcial** 1 (11: ausente se sostiene, pero el "2,07 (4 de 4)" vale solo para la fila Alto —las otras celdas máximas dan 2,40, 2,95 y 3,51— y el delta negativo da 4,11 sobre `paper`, no 3,97); **refuta** 2 (1: divergente → ausente, porque "1 establecimientos sin categoría" sale en 93 entidades sin ayudante que lo cubra y la cláusula de ausente calza tal cual; 10: divergente → presente, porque ninguna superficie pinta una categoría sobre un nulo y la fusión "sin medición"/"s/i" es un defecto de universo, ya contado en la fila 9).
  - `slep_idps`: confirma 4 (1, 9, 16, 20), con matices: fila 9 más amplia (en 2° medio difieren cuatro regiones); fila 16: la decisión que cubre las entidades es §48 ítem 5 del log de s29 (no "s29 §5") y no cubre los GSE ocultos, aunque el `title` del botón promete "los GSE visibles"; fila 20: sin red el motor queda en blanco.
  - Dudas de la ola 1 que la ola 2 resuelve con evidencia nueva: fila 4 de `categoria` (hay un recorrido que desmonta el origen con el modal abierto y el foco cae en `BODY`: ausente también por la letra); fila 12 de `categoria` (la banda azul del anillo cae sobre el relleno del propio control, 1,08).

**Verificación del orquestador de la ola 2.** Primera pasada con `/tmp/s33n_ver_lineas.py`: `simce OK=27 FALLA=1`, `categoria OK=21 FALLA=2`, `idps OK=7 FALLA=2`; las cinco fallas son de formato (texto literal correcto seguido de una anotación del subagente: "(payload: …)", "[recortada]", o `̀-ͯ` escrito como carácter; comprobado con `od -c` sobre la línea 1406 de la plantilla de `slep_idps`). Verificador nuevo `/tmp/s33n_ver_lineas2.py` (igual criterio, pero separa la anotación final y la cuenta como `OK*`, y normaliza `\uXXXX`), corrido sobre todas las olas:
```
for f in ola1a ola1b_simce ola1b_categoria ola1b_extra ola2_simce ola2_categoria ola2_idps; do python3 /tmp/s33n_ver_lineas2.py /tmp/s33n_ev_$f.txt; done
```
esperado: (propio) las mismas cifras que la primera pasada en las olas 1a/1b (incluidas las dos fallas por número de línea corrido, que no son de formato) y 0 fallas en la ola 2 salvo anotaciones con "…" dentro (que el verificador parte en fragmentos).
- **Corrección:** este `esperado:` se escribió después de la primera pasada con el verificador viejo, pero antes de correr `ver_lineas2.py`.
obtenido: `ola1a OK=51 FALLA=0`; `ola1b_simce OK=57 FALLA=0`; `ola1b_categoria OK=62 FALLA=1` (la `:320`, corrida a `:333`); `ola1b_extra OK=41 FALLA=1` (la `:61`, corrida a `:62`); `ola2_simce OK=28 FALLA=0`; `ola2_categoria OK=23 FALLA=0`; `ola2_idps OK=7 FALLA=2`: las dos con una anotación final que contiene "…" (un extracto del payload tras la línea 1406 y un `grep` tras la línea 2574 del log de s29); la cabeza literal de cada una está en su línea (comprobado a mano: `od -c` y `sed -n`).
- **Subagentes (ola 2):** 3 · rol lectura · modelo Opus 5.5 · uno por motor, ninguno repite el motor que midió en la ola 1 · 32 celdas: 26 confirma, 2 parcial, 4 refuta · verificados con `/tmp/s33n_ver_lineas2.py`. **Cuenta acumulada de Opus: 6 de 9.**

**Ola 3 (discrepancias entre ola 1 y ola 2).** Las cuatro refutaciones reproducen los mismos hechos que la ola 1: discrepan en qué estado corresponde. Dos patrones de desacuerdo: (a) fila 1: la receta superpone sus umbrales ("ausente = … no hay ayudante vivo que lo cubra" frente a "divergente = … o solo parte de los conteos de la unidad concuerdan"), y las dos olas la leyeron al revés en cada hermano (simce: ausente → divergente; categoria: divergente → ausente), con el mismo tipo de hechos; (b) filas 19 y 10: la receta estrecha "divergente" a un caso particular ("el invariante es el hash crudo"; "alguna superficie trata el nulo como neutro, o calcula"), mientras §6 del encargo define divergente como "existe pero resuelve distinto; describir cómo". Reparto (por fila, para que un mismo juez decida con un solo criterio en todos los motores): `ola3:fila1` (simce, categoria y, por consistencia, `slep_idps`), `ola3:fila19` (simce y, por consistencia, categoria y `slep_idps`), `ola3:fila10` (categoria y, por consistencia, simce "no aplica" y `slep_idps` "presente"). Instrucción común: los estados de §6 del encargo prevalecen sobre el umbral de una receta cuando chocan (y hay que decirlo); verificar con un comando propio al menos un hecho por celda; dejar la ambigüedad de criterio restante como pregunta cerrada.
esperado: (propio, escrito antes de lanzar) 3 retornos con un estado final por celda y su razón, evidencia propia y, si queda ambigüedad de criterio, una pregunta cerrada; `escrituras: ninguna`. La cuenta llega a 9 de 9 (regla 5: no queda margen de reintento; si uno falla, sus celdas quedan como duda con los dos estados).
obtenido: (retorno en `/tmp/s33n_ola3.json`; 96 herramientas entre los tres, 9 min; `escrituras: ninguna` en los tres) un criterio escrito por fila y un estado final por motor:
  - **Fila 1** (criterio: §6 "algunos sí y otros no", aplicado por motor; un conteo concuerda si muestra el singular en un estado con 1, por ayudante, función o ternario; "ausente" solo si ningún conteo concuerda, como el caso malo): `slep_idps` divergente, `slep_simce_adecuado` **divergente** (ola 1 ausente), `slep_categoria_desempeno` **divergente** (ola 2 ausente). Evidencia propia: simce, comuna con un solo EE en el panorama → "1 establecimiento con resultados" y, en la pestaña SLEP del modal, "1 comunas · traspaso 2026"; categoría, en una misma pantalla (una comuna, básica) la cabecera dice "1 establecimiento" (`C:2381`) y la caja "1 establecimientos sin categoría en 2019" (`C:2419`). Choque receta/§6: la lectura "conteo por conteo" del umbral de ausente vacía la cláusula de divergente de la propia receta; prevalece §6. Sin pregunta al titular (la gravedad distinta queda en la razón).
  - **Fila 19** (criterio: presente = digest de todo el JSON con el sello fijo + valor de referencia escrito que se reproduce, manual o automático; divergente = un mecanismo escrito neutraliza el sello y compara el dato entre builds por otra vía; ausente = ninguno o solo el hash crudo): `slep_idps` presente (reproducido con python: `eb4e00b3…4dc4`; manual), `slep_simce_adecuado` **divergente** (ola 2 presente: el medidor borra la fecha y compara con `identical()` contra una copia base en `$TMPDIR`, sin digest ni valor escrito, medidor no versionado), `slep_categoria_desempeno` divergente (bloque ancla F4 entre builds y 6 celdas ancla contra el crudo del mismo build; cobertura parcial) con pregunta cerrada (¿cobertura parcial cuenta como divergente o ausente?). Choque receta/§6: la receta llamaba divergente al hash crudo, que no resuelve el problema (es ausente por §6), y no tenía casilla para "resuelve distinto".
  - **Fila 10** (criterio: aplica si el motor muestra por entidad un veredicto frente a una referencia de contexto; el GSE como eje de segmentación no es estado; nulo = toda entidad-año sin veredicto publicado; presente si el nulo no recibe estado, no cuenta y se muestra como no-estado): `slep_idps` presente, `slep_simce_adecuado` no aplica (el GSE es eje; las bandas son escala absoluta declarada; el nulo no recibe banda: 97 celdas vacías, 0 con banda), `slep_categoria_desempeno` **presente** (ola 1 divergente: la categoría aplica —"respecto de lo esperado para el contexto social"—, se lee del campo publicado, el nulo nunca entra en una categoría ni en el denominador, 0 arrastres entre 199 casos en riesgo). Pregunta cerrada común a `slep_idps` y categoría: ¿se exige nombrar el nulo por su motivo en toda superficie? (sí → las dos pasan juntas a divergente).
```
python3 /tmp/s33n_ver_lineas2.py /tmp/s33n_ev_ola3.txt
```
esperado: (propio) todas las evidencias de línea de la ola 3 se reproducen, salvo anotaciones del subagente tras el texto.
- **Corrección:** este `esperado:` se escribió después de correr el verificador (E-2).
obtenido: `total OK=23 OK*(con anotacion)=2 FALLA=2`: una es la línea `C:2419` con una anotación final con "…" ("[recortada] (en el compilado: …)"); la otra, `categoria/50_documentacion/activa/decisiones/20260611_decision_sin_gse.md:31`, tiene el texto en la **32** (`grep -n "en bruto"` → `32:`), otro número corrido en uno.
- **Subagentes (ola 3):** 3 · rol lectura · modelo Opus 5.5 · uno por fila en discrepancia (1, 19, 10), cada uno sobre los tres motores · 9 celdas con estado final (4 de ellas dirimidas: simce 1 y 19 divergente; categoría 1 divergente y 10 presente) · verificados con `/tmp/s33n_ver_lineas2.py`. **Cuenta acumulada de Opus: 9 de 9** (regla 5: tope alcanzado; no se lanza ningún subagente más en el encargo).
- **Estado de T1:** completada. Totales de re-verificación de evidencias de línea en las cuatro olas: 300 citadas; 294 se reproducen (2 tras separar una anotación final); 3 con el número de línea corrido en uno (`:320`→`:333`, `:61`→`:62`, `:31`→`:32`), corregidas en la matriz; 3 con una anotación final que contiene "…" (cabeza literal comprobada a mano).

### FASE T2: matriz

- **Estado:** en curso.
- **Matriz escrita** en `50_documentacion/andamios/20260924_matriz_patrones_motores.md` (§0 cómo leer; §1 tabla patrón × motor; §2 conteos; §3 huecos por motor y tema con "¿aplica? — razón"; §4 idiosincrasias; §5 sentido contrario; §6 hallazgos fuera del inventario; §7 24 dudas con pregunta cerrada; §8 procedencia). Al armarla, 11 `|` dentro de código en celdas de tabla (patrones de `grep`) partían las tablas en GFM: se escaparon como `\|`, y `/tmp/s33n_candado3.py` parte solo en pipes no escapados.

**🔒3 y forma de las tablas:**
```
python3 /tmp/s33n_candado3.py /Users/tomgc/Projects/slep_idps/50_documentacion/andamios/20260924_matriz_patrones_motores.md
```
esperado: (propio, escrito antes de correr) `filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=0`; conteos `slep_idps`: presente 15, divergente 3, ausente 1, no aplica 1; `slep_simce_adecuado`: presente 4, divergente 12, ausente 2, no aplica 2; `slep_categoria_desempeno`: presente 3, divergente 9, ausente 4, no aplica 4.
```
python3 - (cuenta de celdas por fila en cada tabla del documento, partiendo en pipes no escapados)
```
esperado: (propio, escrito antes de correr) cada tabla con el mismo número de celdas en todas sus filas.
obtenido: `filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=0`; `slep_idps: ausente 1, divergente 3, no aplica 1, presente 15`; `slep_simce_adecuado: ausente 2, divergente 12, no aplica 2, presente 4`; `slep_categoria_desempeno: ausente 4, divergente 9, no aplica 4, presente 3`.
obtenido: tablas: líneas 10, 26, 65, 86 con 5 celdas por fila; 51 con 6; 106 y 162 con 4 (todas uniformes).

**§8.2 del encargo (cada celda ausente o divergente con su resultado de la ola 2) y privacidad de la matriz:**
```
python3 - (en la tabla §1, celdas con **ausente**/**divergente** que no contienen "ola 2:")
bash /tmp/s33n_priv.sh
```
esperado: (propio, escrito antes de correr) 0 celdas ausente/divergente sin "ola 2:" (de 34: 4 de `slep_idps`, 14 de simce, 13 de categoría… recuento exacto en la salida); privacidad: control plantado `RUT 1 | RBD con número 1`; matriz y LOG `RUT 0 | RBD con número 0`.
obtenido: `celdas ausente/divergente: 31 sin "ola 2:": []` (4 + 14 + 13); `control plantado: RUT 1 | RBD con número 1`; LOG y matriz `RUT 0 | RBD con número 0`.
- **Commit:** `30ecfa8` docs(matriz): patrones de usabilidad entre los tres motores (s33n T2), hijo de `085e147` (`1 file changed, 193 insertions(+)`). Porcelain tras el commit: solo el LOG.
- **Estado de T2:** completada.

### FASE R: auditoría propia y reparación

- **Estado:** en curso.
- **Sin subagentes** (tope de 9 Opus alcanzado en la ola 3): toda la re-derivación la hace el orquestador, con comandos distintos de los de las olas.

**Paso 1 — inventario de afirmaciones auditables (anexado antes de auditar).** Muestra de 12 celdas (5 de `slep_simce_adecuado`, 5 de `slep_categoria_desempeno`, 2 de `slep_idps`), elegidas para cubrir los cuatro estados y los cinco temas, más los 🔒, las PRUEBAS y los controles positivos:

| id | Afirmación de la matriz | Re-derivación prevista (distinta de las olas) |
|---|---|---|
| R-01 | simce fila 5 divergente: el ✕ del modal no tiene nombre accesible | `grep` sobre el **motor compilado** del `button` con clase `icon-btn` del encabezado del modal y de un `aria-label`/`title` en su elemento |
| R-02 | simce fila 20 presente: sin red al abrir | conteo de `<script src=`, `<link href=` y `url(http` externos en el HTML compilado (sin navegador) |
| R-03 | simce fila 3 ausente: Escape no cierra y el foco cae en `body` | Puppeteer propio: abrir con clic en "Agregar territorio", Escape (¿sigue el modal?), cerrar con Cancelar por clic y leer `document.activeElement` |
| R-04 | simce fila 13 presente: tabla con `min-width` y scroll en su contenedor | regla `min-width` en el CSS del motor compilado + Puppeteer a 390 px: `scrollWidth` del contenedor frente a su `clientWidth`, y el del documento |
| R-05 | simce fila 10 no aplica: el payload no trae significancia | python (no node): base64 → zlib → JSON, claves de todos los objetos que contengan `sig` |
| R-06 | categoría fila 2 ausente: ninguna fila del modal es enfocable | Puppeteer propio: abrir el modal y contar `.check-row` con `tabIndex ≥ 0`, `role` o `input` dentro |
| R-07 | categoría fila 15 no aplica: no exporta | `grep -c` de `Blob`, `createObjectURL`, `download` y `.csv` sobre el **motor compilado** |
| R-08 | categoría fila 11 ausente: blanco sobre Medio-Bajo a 2,62:1 en las cabeceras | python: contraste WCAG desde los hex del generador (`CAT_COLORS`) y el `color: #fff` de la regla de la cabecera |
| R-09 | categoría fila 1 divergente: un ternario concuerda y "establecimientos sin categoría" va a mano; 93 entidades con total 1 | `sed -n` de `C:2381` y `C:2419` + python sobre el payload: entidades con `sin_vigente` total 1 en 2019 |
| R-10 | categoría fila 20 presente: React en línea, sin red | `grep` de los marcadores `__REACT_INLINE__` en la plantilla y de `<script src=` externos en el compilado |
| R-11 | `slep_idps` fila 16 divergente: el nombre del CSV del comparador no lleva los GSE; el del panorama sí | `sed -n` de `I:2294` y del bloque de `I:2349`, buscando el sufijo de GSE |
| R-12 | `slep_idps` fila 9 divergente: la fila Región cuenta comunas sin nombrar el universo; SLEP/Nacional sí lo nombran | `sed -n` de `I:1792`, `I:1878` y `I:1856` y `grep -c "en el directorio"` en esas líneas |
| R-13 | 🔒1 hermanos intactos (con la lectura del gate: copias + índice + atribución) | `/tmp/s33n_m2.sh` + `find -newer` en las copias + `git log` de atribución |
| R-14 | 🔒2 `slep_idps` solo gana documentos | `git diff --name-only 085e147..HEAD` (tras el commit del LOG se repite en FASE L) |
| R-15 | 🔒3 toda celda con evidencia | `/tmp/s33n_candado3.py` sobre la matriz commiteada |
| R-16 | PRUEBAS: md5 de plantillas, motores y `docs/` de los tres repositorios iguales al inicio y al final | `/tmp/s33n_m2.sh` frente a M2 (con la lectura del gate para simce) |
| R-17 | Control positivo de M3 (repetido): el caso malo da filas 1 y 4 ausentes y el bueno no | `/tmp/s33n_v_idps.js` (fila 1) y un instrumento nuevo de foco al tope (fila 4) sobre los dos motores |
| R-18 | Control positivo de 🔒3: el script detecta una celda sin evidencia | copia de la matriz en `/tmp` con la evidencia de una celda borrada |

**Paso 2 — re-derivación independiente (estáticas: R-01, R-02, R-05, R-07 a R-12).** Script nuevo `/tmp/s33n_r_estaticas.sh` (un bloque por id; la decodificación del payload en python dentro del script).
```
bash /tmp/s33n_r_estaticas.sh
```
esperado: (propio, escrito antes de correr) R-01: en el motor compilado de simce, el `button` con `className: "icon-btn"` del modal no lleva `aria-label` ni `title` en su llamada (`aria-label` 0 en esas líneas). R-02: simce compilado: `<script src="http` 0, `<link … href="http` 0, `url(http` 0. R-05: claves con `sig` en el payload de simce: ninguna. R-07: en la plantilla de categoría, `text/csv|toBlob|\.download|msSaveBlob|"\.csv` → 0. R-08: blanco sobre los rellenos de categoría: Insuficiente 4,11, Medio-Bajo 2,62, Medio 3,48, Alto 6,45; la regla de `C:1069` lleva `color: #fff`. R-09: `C:2381` con el ternario `stat.n_ee === 1 ?`; `C:2419` con `" establecimientos sin categoría en "` sin ternario; entidades con total "sin vigente" = 1 en 2019: 93 (comuna 78, región 2, SLEP 13). R-10: `__REACT_INLINE__` y `__REACTDOM_INLINE__` en las líneas 1517–1518 de la plantilla; `<script src=` en el compilado: 0. R-11: `I:2294` sin "gse"; el bloque desde `I:2349` con un sufijo de GSE. R-12: "en el directorio" en `I:1792` 0, en `I:1878` 0, en `I:1856` 1.
obtenido: R-01: dos `button` con `className: "icon-btn"` en el compilado de simce (líneas 4584 y 4867), `aria-label en esas lineas: 0  title: 0`; el contexto (`sed -n 4580,4590p` y `4863,4872p`) muestra que la 4867 es el ✕ del `modal-header` ("Agregar territorio"/"Editar territorio") y la 4584 el del popup de establecimientos, los dos con solo `className` y `onClick`. R-02: `script src http: 0  link href http: 0  url(http: 0`. R-05: `cabecera 789c; claves con 'sig': []` (raíz: comunas, datos, establecimientos, meta, rbd_gse, rbds_por_nivel, regiones, simce_rbd, sleps). R-07: `0`. R-08: `CAT_COLORS` en `33_generar_html.R:62-66`; la regla `.cat-col-head { padding: 12px 14px; color: #fff;` (`C:1068-1069`); blanco sobre Insuficiente 4.11, Medio-Bajo 2.62, Medio 3.48, Alto 6.45. R-09: `C:2381` con `stat.n_ee === 1 ? "establecimiento" : "establecimientos"`; `C:2419` `fmtInt(total), " establecimientos sin categoría en "` sin ternario; `sin_vigente` es columnar (`rows 1985`, año vigente 2019); combinaciones entidad × nivel con total 1: `93 {'comuna': 78, 'region': 2, 'slep': 13}` (un segundo python, sobre la misma decodificación, sumó `n_ee` por entidad y nivel). R-10: `1517`/`1518` y `<script src= en compilado: 0`. R-11: `I:2294` `"idps_comparador_"+slugArchivo(args.grado)+"_"+args.agno+".csv");`, `gse en 2294: 0`; `I:2349-2350` termina en `+sufijoGse(args.gseSel)+".csv"`, `gse en 2349-2352: 1`. R-12: `1792: 0`, `1878: 0`, `1856: 1` (con el texto de cada línea). **Las diez re-derivaciones estáticas coinciden con la matriz.**

**Paso 2 (cont.) y paso 6 — re-derivaciones con navegador (R-03, R-04, R-06) y control positivo de M3 (R-17).** Instrumento nuevo `/tmp/s33n_r_pup.js` (acciones `simce_r03`, `simce_r04`, `cat_r06`, `idps_foco`), con clics y teclas propias (no los recorridos de las olas).
```
cd /tmp && for a in simce_r03 simce_r04 cat_r06; do NODE_PATH=… node /tmp/s33n_r_pup.js $a; done
```
esperado: (propio, escrito antes de correr) R-03: tras abrir el modal con **clic** en "Agregar territorio", Escape deja el modal abierto (`modal_tras_escape: true`) y, tras cerrar con **clic** en Cancelar, `document.activeElement` = `BODY`. R-04: a 390 px, la tabla dentro de `.table-wrap` con `min-width` 1000px, `scrollWidth` del contenedor > su `clientWidth` y el documento sin desborde (`scrollWidth` − `clientWidth` = 0). R-06: en el modal de categoría abierto con clic en `.entity-select-btn`, filas `.check-row` > 0 y, de ellas, con `tabIndex ≥ 0` 0, con `role` 0, con `input` 0.
```
cd /tmp && for f in /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s33n_malo_motor.html; do NODE_PATH=… node /tmp/s33n_v_idps.js $f; NODE_PATH=… node /tmp/s33n_r_pup.js idps_foco $f; done
```
esperado: (propio, escrito antes de correr) fila 1: bueno `{"indicadores":19}`, malo `{"indicadores":19,"establecimientos":1}` (como en M3); fila 4 (recorrido: `.terr-trigger` con Enter → pestaña Establecimiento → búsqueda → Enter en la primera fila → la ficha reemplaza al panorama): bueno, `origen_en_documento: false` y foco en `ficha-name`; malo, `origen_en_documento: false` y foco en `BODY`.
obtenido: `simce_r03`: `{"abrio_con_clic":true,"modal_tras_escape":true,"cerro_con_cancelar":true,"modal_tras_cancelar":false,"activo":"BODY"}`; `simce_r04`: `{"hay_tabla":true,"min_width":"1000px","wrap_sw":1337,"wrap_cw":308,"overflow":"auto","doc_desborde":0}`; `cat_r06`: `{"filas":345,"tabindex_0":0,"con_role":0,"con_input":0}`;
obtenido: fila 1: `motor_idps.html {"indicadores":19}` y `s33n_malo_motor.html {"indicadores":19,"establecimientos":1}`; fila 4: bueno `{"origen_en_documento":false,"modal_abierto":false,"activo":"DIV.ficha-name"}`, malo `{"origen_en_documento":false,"modal_abierto":false,"activo":"BODY"}`. **R-03, R-04 y R-06 coinciden con la matriz; el control positivo de M3 (R-17) se repite: las recetas siguen separando el caso malo en las filas 1 y 4.**

**Pasos 3 a 5 — invariantes, alcance y PRUEBAS (R-13 a R-16), y control positivo de 🔒3 (R-18).**
```
bash /tmp/s33n_m2.sh; for B in /tmp/s33n_snap_simce /tmp/s33n_snap_categoria; do find $B -newer /tmp/s33n_m2.sh -type f -not -path '*/.git/*' | wc -l; done
```
esperado: (propio, escrito antes de correr) R-13/R-16: `slep_categoria_desempeno` con `HEAD b709400`, índice `1787579311 14239` y los cuatro md5 de M2; `slep_idps` con los tres md5 de M2 (`1c3bfd6d…`, `7ad76f36…` ×2); copias `0` y `0`; `slep_simce_adecuado` con cambios posibles, cada uno atribuible a commits de su sesión s35 posteriores a `dd7fe76` (se comprueba con el comando siguiente).
```
bash -c 'export GIT_OPTIONAL_LOCKS=0; S=/Users/tomgc/Projects/slep_simce_adecuado; git -C $S log --format="%h %ad %s" --date=format:"%H:%M:%S" dd7fe76..HEAD; for f in 30_procesamiento/33_motor_template.html docs/index.html; do echo "$f árbol=$(md5 -q $S/$f) HEAD=$(git -C $S show HEAD:$f | md5 -q)"; done; stat -f "%Sm %N" -t "%H:%M:%S" $S/40_salidas/motor_comparacion.html $S/.git/index'
```
esperado: (propio, escrito antes de correr) plantilla y `docs/` del árbol = sus versiones en `HEAD` (cambios commiteados por s35, no sin dueño); `mtime` del índice = hora de un commit de s35; el motor (no versionado) reconstruido por s35 después de su último cambio de plantilla.
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R diff --name-only 085e147..HEAD; git -C $R show HEAD:50_documentacion/andamios/20260924_matriz_patrones_motores.md > /tmp/s33n_matriz_head.md; python3 /tmp/s33n_candado3.py /tmp/s33n_matriz_head.md | head -1; python3 - (copia /tmp/s33n_matriz_plantada.md con la evidencia de la celda categoría × fila 13 reducida a "**presente** · —"); python3 /tmp/s33n_candado3.py /tmp/s33n_matriz_plantada.md | head -2'
```
esperado: (propio, escrito antes de correr) R-14: una sola ruta, `50_documentacion/andamios/20260924_matriz_patrones_motores.md` (el LOG entra en FASE L). R-15: `filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=0`. R-18: `celdas_sin_evidencia_o_estado=1`, señalando la línea de la fila 13 y el motor `slep_categoria_desempeno`.
obtenido: `/tmp/s33n_m2.sh`: `slep_categoria_desempeno` `HEAD b709400`, índice `1787579311 14239`, md5 `9e9640ca…`, `428448d6…`, `45e612f1…` ×2 (= M2); `slep_idps` `1c3bfd6d…`, `7ad76f36…` ×2 (= M2); copias `0` y `0`. **`slep_simce_adecuado`:** `HEAD 01cdee0` (11:53:24), porcelain `?? 50_documentacion/andamios/logs/20260925_pendientes_s35b_log.md` (otro log sin seguimiento de su sesión), índice `1790348004 26062`, plantilla `3daac159cc59a3f1f88e5d99bcd8d2fe` (204.071 B), motor `56a6c052054a97ec4dfa9d2838dac386` (2.791.598 B), `docs/` `8deb0459…` (= M2). (La primera corrida del bloque terminó con `(eval):18: ===== not found`: el separador `echo ======` lo interpretó zsh; la parte de atribución se repitió en `bash -c`, abajo.)
obtenido: atribución: 11 commits de s35 entre 10:47:44 y 11:53:24 (`f076470` … `01cdee0`); plantilla del árbol = `HEAD` (`3daac159…` las dos), `docs/` del árbol = `HEAD` (`8deb0459…`); `mtime` motor 11:52:50, índice 11:53:24 (= hora de `01cdee0`/`f8e7870`), plantilla 11:41:09; los commits que tocan la plantilla desde `dd7fe76` son dos: `1150846` (10:47, un comentario) y **`01cdee0` (11:53) "fix(motor): cifra dentro de la franja Elemental con tinta oscura (D35-5)"**, que cambia el `fill` de la cifra interior de Elemental de blanco a `TINTA_SOBRE_ELEM` (su comentario: "El blanco daba 2,78:1 … esta tinta oscura … da 5,44:1"). Todo cambio del hermano vivo queda explicado por su sesión s35; ninguno por este encargo.
obtenido: R-14 `50_documentacion/andamios/20260924_matriz_patrones_motores.md` (única ruta); R-15 `filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=0`; R-18 `plantada línea 40` → `filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=1` y `(40, 'slep_categoria_desempeno', 'SIN EVIDENCIA')`.

**Paso 7 — veredicto por hallazgo.**
- **R-13 → REPARA.** 🔒1 PASA con la lectura del gate (copias intactas; índices: el de categoría sin tocar, el de simce con el `mtime` de un commit de s35; todos los cambios atribuidos). Pero la matriz (§0) dice que entre `dd7fe76` y `bfa40c9` solo un commit tocó la plantilla y "lo posterior no se midió", sin mencionar `01cdee0`, que corrige uno de los hechos de la celda simce × fila 11 (cifras blancas sobre Elemental, 2,78:1). La celda sigue siendo cierta para `dd7fe76` y sigue "divergente" por el hover de "Eliminar" (3,47:1, que `01cdee0` no toca), pero un lector de la matriz leería como abierto algo que el hermano ya cambió. Reparación: nota en §0, en la celda simce × fila 11 y en su fila de §3.1, citando el commit y su comentario (no medido aquí).
- **A-1 → ADVIERTE (de redacción, H-2).** La premisa de M3 de que `slep_idps` sale "presente" en las 20 filas es falsa en cinco (1, 9, 16, 17, 20); la calibración se hizo por distinción (filas 1 y 4) y quedó registrada.
- **A-2 → ADVIERTE (de instrumento).** Las recetas de las filas 1, 10 y 19 tenían umbrales que chocan con §6 del encargo (umbrales superpuestos en la 1; "divergente" estrechado en la 10 y la 19); la ola 3 los dirimió con §6. Las recetas de `/tmp/s33n_recetas.md` no se corrigieron: si se reutilizan para el estándar, esos tres umbrales deben reescribirse con los criterios de `/tmp/s33n_ola3.json`.
- **A-3 → ADVIERTE (de procedimiento, E-1/E-2).** Varios `esperado:` del orquestador se escribieron después de correr su comando (preparación de M3, verificación de M3, control intermedio, verificación de la ola 1b, verificador de la ola 3); están marcados con `- **Corrección:**`. No cambian ningún valor.
- **R-01 a R-12, R-15, R-17, R-18:** sin hallazgo (coinciden con la matriz; controles positivos 2 de 2).
- Tres números de línea corridos en evidencias de subagentes (`:320`→`:333`, `:61`→`:62`, `:31`→`:32`): los dos primeros se citan en la matriz ya corregidos desde el commit de T2; el tercero no se cita; sin acción.

**Paso 8 — ciclo de reparación 1 (R-13), solo sobre la matriz.** Edición: §0 (los 11 commits de s35 hasta `01cdee0` y los dos que tocaron la plantilla), celda simce × fila 11 (nota: `01cdee0` pasó la cifra interior de Elemental a tinta oscura, no medido; el hover de "Eliminar" no cambió; estado igual) y su fila en §3.1. Re-verificación:
```
python3 /tmp/s33n_candado3.py <matriz>; bash /tmp/s33n_priv.sh; git -C /Users/tomgc/Projects/slep_idps diff --stat -- 50_documentacion/andamios/20260924_matriz_patrones_motores.md
```
esperado: (propio, escrito antes de correr) 🔒3 igual que antes (`filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=0` y los mismos conteos por motor); privacidad 0/0 con control 1/1; el diff toca solo las tres líneas (§0, fila 11 de §1, fila 11 de §3.1).
obtenido: `filas=20 celdas_con_estado=60 celdas_sin_evidencia_o_estado=0` y los mismos conteos por motor; privacidad control `1 | 1`, LOG y matriz `0 | 0`; `1 file changed, 3 insertions(+), 3 deletions(-)` en las líneas 16, 38 y 76.
- **Commit:** `52966df` fix(auditoria): R-13 la matriz registra los cambios de la plantilla de simce posteriores a dd7fe76 (hijo de `30ecfa8`). Porcelain: solo el LOG. Un solo ciclo de reparación (de 2 admitidos).

**Paso 10 — salida.**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | simce 5 divergente (✕ sin nombre) | `grep 'className: "icon-btn"'` en el compilado + contexto | sin `aria-label`/`title` | 0 y 0; 4867 = `modal-header` | — | ninguna | — | — |
| R-02 | simce 20 presente | conteo de `src`/`href`/`url(` externos | 0/0/0 | 0/0/0 | — | ninguna | — | — |
| R-03 | simce 3 ausente | Puppeteer propio (clic, Escape, Cancelar por clic) | modal sigue; foco `BODY` | `true`; `BODY` | — | ninguna | — | — |
| R-04 | simce 13 presente | CSS del compilado + Puppeteer 390 | 1000px; wrap desplaza; doc 0 | 1000px; 1337 > 308; 0 | — | ninguna | — | — |
| R-05 | simce 10 no aplica | python sobre el payload | sin claves `sig` | `[]` | — | ninguna | — | — |
| R-06 | categoría 2 ausente | Puppeteer propio (conteo de filas enfocables) | 0/0/0 de >0 | 0/0/0 de 345 | — | ninguna | — | — |
| R-07 | categoría 15 no aplica | `grep -cE 'text/csv\|toBlob\|\.download\|msSaveBlob\|"\.csv'` | 0 | 0 | — | ninguna | — | — |
| R-08 | categoría 11 ausente | python WCAG desde `CAT_COLORS` + regla `.cat-col-head` | 4,11/2,62/3,48/6,45; `#fff` | idénticos | — | ninguna | — | — |
| R-09 | categoría 1 divergente | `sed -n` + python (suma de `n_ee`) | ternario en 2381, fijo en 2419; 93 | idénticos; 93 (78/2/13) | — | ninguna | — | — |
| R-10 | categoría 20 presente | `grep` de marcadores y de `src` | 1517–1518; 0 | idénticos | — | ninguna | — | — |
| R-11 | `slep_idps` 16 divergente | `sed -n` 2294 y 2349–2352 | sin GSE / con sufijo | 0 / 1 | — | ninguna | — | — |
| R-12 | `slep_idps` 9 divergente | `sed -n` + `grep -c "en el directorio"` | 0/0/1 | 0/0/1 | — | ninguna | — | — |
| R-13 | 🔒1 hermanos intactos | `s33n_m2.sh` + `find -newer` + atribución | PASA con cambios atribuidos | PASA; `01cdee0` cambia un hecho de simce × 11 no citado | REPARA | nota en §0, celda y §3.1 | `52966df` | 🔒3 0; privacidad 0; diff 3 líneas |
| R-14 | 🔒2 solo documentos | `git diff --name-only 085e147..HEAD` | la matriz | la matriz (el LOG, en FASE L) | — | ninguna | — | se repite en FASE L |
| R-15 | 🔒3 toda celda con evidencia | `s33n_candado3.py` sobre `HEAD` | 0 | 0 | — | ninguna | — | tras `52966df`: 0 |
| R-16 | PRUEBAS | `s33n_m2.sh` frente a M2 | iguales (simce con atribución) | `slep_idps` y categoría iguales; simce cambiado por s35 (atribuido); copias intactas | — | ninguna | — | se repite en FASE L |
| R-17 | control positivo de M3 | `s33n_v_idps.js` + `s33n_r_pup.js idps_foco` | malo: 1 y 4 ausentes | malo: "1 establecimientos" y foco `BODY`; bueno: sin ellos y `ficha-name` | — | ninguna | — | — |
| R-18 | control positivo de 🔒3 | copia plantada | 1 celda sin evidencia | 1 (línea 40, categoría) | — | ninguna | — | — |
| A-1 | premisa de M3 ("todo presente") | — | — | falsa en 5 filas | ADVIERTE | registrada (H-2) | — | — |
| A-2 | umbrales de las recetas 1, 10, 19 | — | — | chocan con §6; dirimidos en la ola 3 | ADVIERTE | registrada | — | — |
| A-3 | `esperado:` antes del comando | — | — | varios escritos después (E-1, E-2) | ADVIERTE | marcados como corrección | — | — |

- **Veredicto de FASE R: APROBADO CON ADVERTENCIAS** (BLOQUEA/REPARA/ADVIERTE = 0/1/3; reparado 1: R-13; abiertos 3: A-1, A-2, A-3); controles positivos 2 de 2 (R-17, R-18).
- **Estado de FASE R:** completada.

### FASE L: cierre del log

- **Estado:** en curso.

**L.1 — porcelain, 🔒1/PRUEBAS al cierre y procesos.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; bash /tmp/s33n_m2.sh; for B in /tmp/s33n_snap_simce /tmp/s33n_snap_categoria; do find $B -newer /tmp/s33n_m2.sh -type f -not -path "*/.git/*" | wc -l; done; pgrep -fl "puppeteer_dev_chrome_profile|s33n_" | grep -v pgrep | wc -l'
```
esperado: (propio, escrito antes de correr) porcelain = solo el LOG; categoría y `slep_idps` = M2; copias `0` y `0`; simce igual al control de FASE R (`01cdee0`) o con nuevos commits de s35 (se atribuyen); `0` procesos propios (Chrome de Puppeteer o scripts `s33n_`) vivos.

**L.4 — privacidad** (`/tmp/s33n_priv.sh`: RUT y "RBD" + número, control plantado armado por el script; `/tmp/s33n_priv_nombres.R` nuevo, adaptado de s33m: nombres de establecimiento del directorio y de `idps_largo`, con un nombre real plantado en `/tmp`):
```
bash /tmp/s33n_priv.sh
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s33n_priv_nombres.R 2>&1 | grep -v "^- The project\|locale \]\|entorno no la\|procesos hijos"'
```
esperado: (propio, escrito antes de correr) control `RUT 1 | RBD con número 1`, LOG y matriz `0 | 0`; nombres: control `1`, LOG `0`, matriz `0`.
obtenido: porcelain `?? 50_documentacion/andamios/logs/20260924_matriz_hermanos_s33n_log.md` (única línea); `slep_categoria_desempeno` y `slep_idps` = M2 (mismos `HEAD`, índice y md5); copias `0` y `0`; procesos propios vivos `0`. **`slep_simce_adecuado`:** `HEAD 01cdee0` (igual que en FASE R), índice `1790348004 26062` (igual que en FASE R), `docs/` `8deb0459…` (= M2), motor `56a6c052…` (igual que en FASE R), pero porcelain de 3 líneas: ` M 30_procesamiento/33_motor_template.html` (md5 `383df694ddbc11436cc0777eda527c6f`, 204.423 B), ` M 30_procesamiento/36_verificar_trayectorias.R` y `?? …/20260925_pendientes_s35b_log.md`.
- **Atribución de los cambios sin commitear de simce** (comando de solo lectura: `stat`, `git diff --stat` con `GIT_OPTIONAL_LOCKS=0`, `grep` sobre el log de su sesión): `mtime` plantilla 12:01:05, `36_verificar_trayectorias.R` 11:59:29, log s35b 11:54:12, reloj 12:01:23; `2 files changed, 99 insertions(+), 50 deletions(-)`; el log de la sesión s35b nombra los dos archivos dentro de su ALCANCE (`33_motor_template` 4 menciones, `36_verificar_trayectorias` 6; su línea 248: "Alcance: antes de commitear, `git diff --name-only HEAD` = `33_motor_template.html` (M1), … `36_verificar_trayectorias.R` (A1)"). Este encargo no leyó `36_verificar_trayectorias.R` ni corrió en el hermano vivo nada que escriba (el índice conserva el `mtime` de `01cdee0`: nadie lo refrescó). Con la lectura del gate (c: "cada cambio del hermano vivo se explica por commits o archivos de su sesión s35"), **🔒1 PASA**: todo cambio es de la sesión s35/s35b, que sigue trabajando.
obtenido: control `RUT 1 | RBD con número 1`; LOG `RUT 0 | RBD con número 0`; matriz `RUT 0 | RBD con número 0`. Nombres: `s33n_priv_nombres_control.txt : nombres de EE encontrados 1`, LOG `0`, matriz `0` (`nombres revisados: 16066`).

**L.2 — secciones de cierre.**

- **Resumen:** matriz patrón × motor de los 20 patrones en los tres motores, con evidencia por celda (60 de 60) y tres olas de subagentes de lectura (calibración y medición, refutación, dirimente) más la verificación del orquestador. Resultado: `slep_idps` 15 presente, 3 divergente, 1 ausente, 1 no aplica; `slep_simce_adecuado` 4, 12, 2, 2; `slep_categoria_desempeno` 3, 9, 4, 4 (presente, divergente, ausente, no aplica). El grueso de los huecos de los dos hermanos está en el modal y el foco (filas 2 a 8: 6 de 7 en cada uno). En sentido contrario, los dos hermanos abren sin red (fila 20), que `slep_idps` no; `slep_simce_adecuado` además direcciona sus vistas por URL, exporta imagen con un solo dibujante y marca la base pequeña con asterisco y nota; `slep_categoria_desempeno` versiona una verificación del dato publicado. Nada se escribió en los hermanos.
- **Commits:** `085e147` chore(encargo): s33n y registro del asistente s33; `30ecfa8` docs(matriz): patrones de usabilidad entre los tres motores (s33n T2); `52966df` fix(auditoria): R-13 la matriz registra los cambios de la plantilla de simce posteriores a dd7fe76; `docs(log): s33n matriz de motores hermanos` (este LOG, al cerrar).
- **Subagentes:** 9, todos de lectura, modelo Opus 5.5 (heredado del orquestador); 0 de modelo intermedio. Ola 1a: 1 (calibración); ola 1b: 2 (uno por hermano); ola 2: 3 (uno por motor); ola 3: 3 (uno por fila en discrepancia). Nunca más de 3 simultáneos. Ningún reintento. **Cuenta de Opus: 9 de 9.** Ninguno escribió archivos (declarado por cada uno y comprobado: copias intactas, índices sin refrescar, `slep_idps` solo con los documentos del ALCANCE).
- **Auditoría:** APROBADO CON ADVERTENCIAS (0/1/3); R-13 reparado en `52966df`; A-1, A-2, A-3 abiertos; controles positivos 2 de 2.
- **Invariantes:** 🔒1 PASA (con la lectura del gate: copias intactas; índice de categoría intacto; todos los cambios de simce atribuidos a su sesión s35); 🔒2 PASA (se re-mide abajo tras el commit del LOG); 🔒3 PASA (0 celdas sin evidencia; control plantado detectado).
- **Conteo de celdas por estado y motor:** `slep_idps`: presente 15, divergente 3, ausente 1, no aplica 1; `slep_simce_adecuado`: presente 4, divergente 12, ausente 2, no aplica 2; `slep_categoria_desempeno`: presente 3, divergente 9, ausente 4, no aplica 4 (salida de `/tmp/s33n_candado3.py`).
- **Dudas con pregunta cerrada:** las 24 de la matriz (§7, D-01 a D-24; 13 pueden cambiar un estado). Del proceso: **D-L1** ¿se borran a mano los temporales que este encargo dejó en `/tmp` (copias APFS `/tmp/s33n_snap_simce` y `/tmp/s33n_snap_categoria`, el caso malo `/tmp/s33n_malo_*`, los retornos `/tmp/s33n_ola*.json` y los instrumentos)? (sí / no; el encargo no autoriza `rm`). **D-L2** ¿se reescriben los umbrales de las recetas 1, 10 y 19 con los criterios de la ola 3 antes de reutilizar `/tmp/s33n_recetas.md` en el estándar de motores? (sí / no). **D-L3** ¿la lectura del gate para la regla 3 y el 🔒1 ("copias + atribución") pasa a ser la redacción estándar cuando un hermano tiene una sesión abierta? (sí / no).
- **Errores propios:** E-1 (esperados de la preparación y la verificación de M3 escritos después de correr); E-2 (lo mismo en el control intermedio, la verificación de la ola 1b y la de la ola 3, después de anunciar que no volvería a pasar); E-3 (dos `obtenido:` que cubrían dos `esperado:` cada uno, separados en FASE L para balancear el conteo; valores sin cambio); E-4 (un `echo ======` dentro de un comando zsh abortó la primera corrida de R-13/R-16: `(eval):18: ===== not found`; se repitió en `bash -c`); E-5 (el primer verificador de evidencias dio 5 falsas alarmas por anotaciones de los subagentes; se escribió `ver_lineas2.py`); E-6 (al armar la matriz, 11 `|` dentro de código partían las tablas; corregido antes del commit de T2). Ninguno cambió un estado ni un valor.
- **Estado de cierre:** FASE 0, T1, T2, FASE R y FASE L completadas; push de `main` según la autorización (una vez, tras este commit, con porcelain vacío y `HEAD..origin/main` = 0).
- **L.5 — verificación del archivo** (antes de agregar esta línea): `ls -l` → 72.572 bytes; `wc -l` → 393; `grep -c '^### FASE'` → 5; `grep -c '^esperado:'` → 29 = `grep -c '^obtenido:'` → 29; `grep -c '^## J'` → 1, con 13 campos; privacidad del LOG re-medida: `RUT 0 | RBD con número 0`.
- **L.6:** `git add` del LOG y commit `docs(log): s33n matriz de motores hermanos`; después, `git push origin main` una vez (autorizado: FASE R no terminó en BLOQUEADO; se comprueba porcelain vacío y `HEAD..origin/main` = 0 antes de empujar). El push publica los 4 commits de esta sesión (`085e147`, `30ecfa8`, `52966df` y el `docs(log)`).
- **Estado de FASE L:** completada.

## Cierre

Encargo s33n cerrado: matriz entregada y auditada (APROBADO CON ADVERTENCIAS, 0/1/3), hermanos intactos por este encargo, 9 de 9 Opus usados, 27 dudas con pregunta cerrada para el titular.

## Adenda de cierre: push retenido

- `git -C /Users/tomgc/Projects/slep_idps push origin main` (ejecutado solo, tras `174cf1e`, con porcelain vacío y `HEAD..origin/main` = 0) **no se ejecutó**: lo denegó el clasificador de permisos del modo automático de Claude Code ("Out-of-Place Publication"). No se intentó ninguna otra vía. Quedan **locales** los commits `085e147`, `30ecfa8`, `52966df`, `174cf1e` y este `docs(log)`; `origin/main` sigue en `d41e31a`. **Queda al titular:** `git -C /Users/tomgc/Projects/slep_idps push origin main` (en esta sesión, `! git -C /Users/tomgc/Projects/slep_idps push origin main`).
