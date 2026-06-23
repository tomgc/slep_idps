# Encargo autónomo — ajustes UI/UX del motor IDPS (s19, Fases 1+2+3)

> Encargo dirigido por meta para Claude Code en modo autónomo. Lo redacta el
> asistente de análisis; lo ejecuta Claude Code de punta a cabo en este turno.
> Las reglas canónicas (autonomía 0.3, commits atómicos, gobernanza, principios
> técnicos) viven en `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`
> y `DISCIPLINA_OPERATIVA.md` (knowledge base / `50_documentacion/activa/`); se
> referencian, no se reescriben.

---

## 1. Encabezado de contrato

- **Modo:** autónomo, secuencial. Ejecuta TODAS las fases en este turno, en orden
  estricto. Un commit atómico por fase (mensajes abajo).
- **Stack:** R + HTML/JSX inline (React 18 + D3 v7 vía Babel CDN, runtime classic).
  Sin bundler. R-only para el pipeline.
- **Rutas:** absolutas siempre, desde `/Users/tomgc/Projects/slep_idps`. No asumir `cd`.
- **Regla de detención (PARA y reporta, no improvises):**
  1. Un invariante 🔒 te obligaría a violarse para cumplir un ítem.
  2. Un dato real contradice un supuesto del encargo (p. ej. una columna que el
     encargo asume existe no existe, o la fidelidad censal post-cambio NO da 0).
  3. Un cambio requiere una decisión de diseño que el encargo no fijó.
  En esos casos: reporta el hallazgo, deja el working tree en estado limpio o
  claramente marcado, y espera. No fabriques metodología.
- **DISCIPLINA_OPERATIVA R1-R9 aplica.** Antes de cada `git add`, leer `git status`.
  Nunca `git add .` / `-u`. Antes de redactar un mensaje de commit, leer el diff real.

---

## 2. Contexto mínimo suficiente

- **Proyecto:** `slep_idps`, motor IDPS nacional. HTML autocontenido publicado en
  GitHub Pages desde `docs/index.html`. Rama A (público).
- **Archivos clave:**
  - Generador R: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`
  - Template (JSX inline): `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
  - Parquet fuente: `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
  - Build de salida: `/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html`
  - Deploy: `/Users/tomgc/Projects/slep_idps/docs/index.html` (copia del build).
- **Cómo se construye:** `run_all(only=35)` regenera el motor; luego se copia a
  `docs/`. Toda presentación se cambia por `35` (template + generador), nunca el parquet.
- **Componentes ya localizados (líneas aproximadas en `35_motor_template.html`,
  reverificar antes de editar — el archivo pudo moverse):**
  - `Ancla` (par número+significancia): ~:621.
  - `Definicion` (colapsable "¿Qué mide…?"/"Sobre esta dimensión"): ~:565.
  - `DistBar` (barras de distribución de niveles, % por segmento): ~:684.
  - `IndPanel` (tarjeta de indicador, pinta 2 anclas en orden fijo): ~:918, anclas ~:938-941.
  - `DimBlock` (bloque de dimensión, 1 ancla vs año): ~:901.
  - `BarrasAnio` (barras de vista histórica, escala fija 0–100): ~:794; CSS prelim ~:323.
  - Selector de grado global: `const grados = Object.keys(DATA.meta.grados)` ~:1313;
    botones ~:1002/:1421/:1245; `irFicha`/`fichaGrado=panGrado` ~:1339; `onPickEE` ~:1481.
  - `DATA.meta.grado_anios[grado]` (grado→años, hoy solo para vista histórica) ~:1343.

---

## 3. Invariantes (🔒)

- 🔒 **El parquet NO se toca ni se regenera.** md5 `4c764d8c…`, 2.362.447 filas.
  Todo cambio de presentación vive en `35` (template + generador). Las columnas de
  medición (`prom/dif/sigdif/difgru/sigdifgru/niveles`) son invariantes.
- 🔒 **Fidelidad censal parquet→sitio = 0 mismatch.** Tras regenerar, las cifras
  mostradas deben ser byte-idénticas a las del build anterior salvo en lo que estos
  ítems cambian deliberadamente (signo %, slot GSE oculto, grados desactivados). El
  número en sí (`prom`, `niv_*_por`, `difgru`, etc.) NO cambia: solo su presentación.
- 🔒 **GSE solo existe a nivel indicador.** Verificado por dato: `difgru`/`sigdifgru`
  pobladas solo en familia `indicador` (114.509 filas), 0 en dimensión y niveles.
  NO inyectar GSE donde es NA.
- 🔒 **Identidad de indicador es regla (sin semáforo).** `DistBar` usa la rampa
  monocromática derivada del color del indicador (Bajo claro→Alto oscuro), no un
  semáforo. NO alterar la codificación cromática.
- 🔒 **Escala de `BarrasAnio` fija 0–100, sin autoescala.**
- 🔒 **Lógica en R, el template solo pinta** (D-s12). El cómputo nuevo del Ítem 8
  (grados-con-dato por RBD) va en `35_generar_motor_html.R`, emitido en `meta`; el
  template lo consume, no lo deriva.
- 🔒 **`docs/` solo se toca en la fase de deploy** (Fase 3), nunca antes, y solo si
  la verificación de fidelidad pasó.

---

## 4. Fases en orden estricto

### FASE 1 — Fidelidad y comportamiento (Ítems 1 y 8)

**Paso 0 (leer, no modificar):** abrir `IndPanel` (~:918-941), `Ancla` (~:621), el
selector de grado (~:1002/:1245/:1313/:1421), `irFicha` (~:1339), `onPickEE` (~:1481)
y `35_generar_motor_html.R` en la zona donde se arma `meta`. Confirmar nombres reales.

**Ítem 1 — ancla GSE primaria, sin slot muerto.**
- En `IndPanel`, el par de anclas (~:938-941): cuando `d.difgru != null`, "vs su GSE"
  es la primera ancla (primaria). Cuando `d.difgru == null`, **NO renderizar** el slot
  "vs su GSE" (hoy degrada a "sin dato"): mostrar solo "vs año anterior".
- "vs año anterior" se mantiene como segunda ancla siempre que `d.dif != null`; si
  tampoco hay, el comportamiento actual de degradación de esa ancla se conserva.
- Solo presentación en el template. Sin cambios en `dimOf`/`indOf` ni en el parquet.
- **Criterio de éxito:** en un EE con `difgru` (p. ej. el de la captura), la tarjeta
  muestra "vs su GSE ▼/▲ X · sig" primero y "vs año anterior …" después. En un EE sin
  `difgru`, NO aparece ningún "vs su GSE — sin dato": solo "vs año anterior".

**Ítem 8 — grados desactivados por EE + cruce territorio→EE corregido.**
- **(a) Precómputo en R (`35_generar_motor_html.R`):** por cada RBD, derivar el
  conjunto de grados con dato (los grados para los que ese RBD tiene al menos una fila
  con `prom` no-NA, o el criterio de "tiene dato" que ya use el motor para poblar la
  ficha — alinear con cómo `indOf`/`nivOf` deciden mostrar). Emitir en `meta` un mapa
  `rbd → grados_con_dato` (estructura compacta; p. ej. `meta.grados_ee[rbd] = ["4b","6b"]`).
  No recalcular nada del parquet de medición; es un índice de disponibilidad.
- **(b) Template — selector de grado en la ficha:** los botones de grado que NO estén
  en `grados_ee[rbdSel]` se renderizan **desactivados** (greyed, `disabled`/no clickeable,
  sin handler). Visualmente atenuados, coherentes con el resto del chrome. Los demás
  grados, normales.
- **(c) Template — cruce territorio→EE (`onPickEE`/`irFicha`):** al seleccionar un EE,
  si el grado activo (`panGrado`/`fichaGrado`) está en `grados_ee[rbd]`, conservarlo; si
  NO, caer al **primer grado con dato** del EE (orden canónico 4b→6b→2m→8b, o el que use
  el motor). Nunca dejar un grado activo que el EE no tiene.
- **Criterio de éxito:** (i) en un EE solo-básica, el botón "2° medio" aparece
  desactivado y no seleccionable. (ii) Estando en 2° medio en Panorama territorial y
  saltando a un EE sin 2° medio, la ficha abre en el primer grado con dato del EE, no en
  2° medio vacío. (iii) Ningún panel de ficha muestra "sin dato" por grado-inexistente:
  ese caso ahora se previene en el selector.

**Commit Fase 1:**
```
git -C /Users/tomgc/Projects/slep_idps add 30_procesamiento/35_generar_motor_html.R 30_procesamiento/35_motor_template.html
git -C /Users/tomgc/Projects/slep_idps status   # confirmar solo esos dos staged
git -C /Users/tomgc/Projects/slep_idps commit -m "feat(motor): ancla GSE primaria sin slot muerto + grados desactivados por EE (items 1,8)"
```

### FASE 2 — Presentación discreta (Ítems 2, 3, 5, 6)

**Paso 0 (leer, no modificar):** `DistBar` (~:684-688), `Definicion` (~:565),
`BarrasAnio` (~:794) y su CSS (~:321-331).

**Ítem 2 — signo % en la barra de niveles.**
- En `DistBar` (~:688), el número visible (`fmt(val)`, pintado solo si `val>=9`) muestra
  ahora `fmt(val) + "%"`. Mantener el umbral `val>=9` para que quepa. El `title` ya tenía
  `%`; queda igual.
- **Criterio:** los segmentos visibles muestran "50%", "28%", "22%" (no "50", "28", "22").

**Ítem 3 — "¿Qué mide…?" abierto por defecto, ancho completo, fuente mayor.**
- En `Definicion` (~:565): estado inicial `open=true` (hoy arranca cerrado). La pregunta
  sigue como encabezado clickeable (puede seguir colapsándose), pero arranca desplegada.
- El texto desplegado ocupa el **ancho completo** del contenedor de la tarjeta, no un
  ancho menor arbitrario (revisar si hay un `max-width`/contenedor angosto y eliminarlo
  para este bloque).
- Subir el `font-size` del texto de definición (hoy es de los más pequeños; llevarlo al
  tamaño del cuerpo de la tarjeta — alinear con el Ítem 4 que vendrá después, pero aquí
  basta subirlo a un tamaño legible coherente con el resto).
- **Criterio:** al cargar la ficha, "¿Qué mide este indicador?" y "Sobre esta dimensión"
  ya están abiertos, a ancho completo, con texto legible (no la fuente diminuta actual).

**Ítem 5 — techo 100 visible en `BarrasAnio`.**
- Hacer evidente el espacio entre la barra y el 100: relleno **sutil** del faltante
  (un fondo tenue desde el tope de la barra hasta el 100% de la columna) + **borde** a la
  barra de dato. Sin eje, sin números de escala. Sutil (baja opacidad, coherente con la
  estética crema/sobria del motor).
- Escala sigue fija 0–100; la línea dashed de referencia al 50% se conserva.
- **Criterio:** en cada columna se distingue visualmente cuánto falta para 100, sin
  agregar ejes ni etiquetas numéricas nuevas.

**Ítem 6 — quitar tratamiento del preliminar, destacar año más reciente.**
- Eliminar la atenuación del preliminar: hoy `.is-prelim` aplica `opacity .62` + outline
  dashed (~:323). Quitar ambos. El sufijo `*` en valor y año se mantiene (es suficiente
  para marcar preliminar).
- El **año más reciente CON DATO del EE** lleva un borde que lo destaca, en el color del
  indicador (intensidad mayor que el relleno, grosor **sutil**). "Más reciente con dato"
  = el último año del eje contiguo para el cual ese EE tiene barra (no necesariamente
  2025; un EE sin 2025 destaca su último año con dato).
- Los estados `pandemia`/`no_eval` (`.ybar-off`, gris opacity .12) NO cambian.
- **Criterio:** las barras preliminares ya no se ven semitransparentes ni punteadas
  (solo el `*`); el último año con dato del EE tiene un borde de su color que lo resalta
  discretamente sobre los demás.

**Commit Fase 2:**
```
git -C /Users/tomgc/Projects/slep_idps add 30_procesamiento/35_motor_template.html
git -C /Users/tomgc/Projects/slep_idps status   # confirmar solo el template staged
git -C /Users/tomgc/Projects/slep_idps commit -m "style(motor): signo %, definicion abierta, techo 100 historico, realce ano vigente (items 2,3,5,6)"
```

### FASE 3 — Regeneración, verificación de fidelidad y deploy

**Paso 1 — regenerar:**
```
cd /Users/tomgc/Projects/slep_idps && Rscript -e 'source("00_build.R")'   # o run_all(only=35) segun el orquestador real; verificar cual aplica
```
Si el build falla, PARA y reporta el error (no parchear a ciegas).

**Paso 2 — verificación de fidelidad censal (panel adversarial, código independiente):**
- Re-derivar desde el parquet, con código propio (no copia de las funciones del
  generador), que las cifras numéricas mostradas NO cambiaron respecto al build
  anterior: spot-check censal de `prom` por indicador/dimensión, `niv_*_por` por nivel,
  `difgru`/`dif` y sus `sig`. El cambio del Ítem 2 (signo %) es de presentación: el
  número sigue siendo el mismo, ahora con sufijo `%`. El Ítem 1 oculta un slot, no
  altera un número. **Mismatch esperado = 0.**
- Verificar que el Ítem 8 no alteró ninguna cifra: el índice `grados_ee` es de
  disponibilidad, no de medición.
- Si el mismatch NO es 0, PARA y reporta (regla de detención 2).

**Paso 3 — verificación en navegador (los criterios de aceptación de cada ítem):**
abrir el build y confirmar 1, 2, 3, 5, 6, 8 contra sus criterios de §4. Capturar
evidencia (qué se vio) para el log.

**Paso 4 — deploy (solo si Pasos 2 y 3 pasaron):**
```
cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html
git -C /Users/tomgc/Projects/slep_idps add 40_salidas/motor_idps.html docs/index.html
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps commit -m "build(motor): regenerar y desplegar ajustes UI/UX s19 (items 1,2,3,5,6,8)"
git -C /Users/tomgc/Projects/slep_idps push origin main
```

---

## 5. Mandato de auto-auditoría

Antes de reportar "listo": NO confiar en checks inline del mismo flujo que hizo el
cambio. Para la fidelidad censal (Paso 2), usar el **panel adversarial**: agentes de
solo-lectura que reconstruyen las cifras desde el parquet con código independiente y
las contrastan contra el build. El valor: caza el punto ciego que el check propio
hereda. Verificación en navegador obligatoria para los criterios visuales.

---

## 6. Mandato del log y cierre

Escribir el log en `50_documentacion/andamios/logs/YYYYMMDD_uiux_s19_fase123_log.md`
(plantilla fija del `encargo_autonomo_claude_code_v1.md` §4): resumen, inventario de
commits (hash/tipo/título), por cada ítem qué/por qué/cómo se verificó/causa raíz si
hubo bug, verificación de invariantes 🔒 (cada uno PASA/FALLA con evidencia), estado
de cifras (md5 parquet antes/después = sin cambio; fidelidad censal mismatch), pendientes
y marcas `# REVISAR`, notas para el revisor. Honesto: incluir lo que costó.
Dejar el log SIN commitear (para revisión del asistente) o como `docs()` aparte.

El cierre de la sesión lo decide el titular (R5). NO cerrar ni sugerir cerrar.

---

## 7. Reporte final al chat

- Hashes de los 3 commits (Fase 1, Fase 2, Fase 3/deploy) + estado de push.
- md5 del parquet antes/después (debe ser idéntico) y md5 del build/`docs/`.
- Resultado de la verificación de fidelidad censal (mismatch = 0 esperado).
- Spot-checks visuales: qué se vio para cada criterio de aceptación (1,2,3,5,6,8).
- Pendientes, marcas `# REVISAR`, y la ruta del log.
- Cualquier punto donde aplicó la regla de detención.

---

## 8. Notas para el redactor (no van al log)

- Ítems deferidos a encargos posteriores, NO incluidos aquí: 4 (auditoría tipográfica,
  va al final y recoge lo que la Fase 2 movió), 7 (media móvil, diseño convergente
  pendiente de aprobación del titular), 9+10 (modal de territorios), 11 (lista de EE por
  segmento, requiere leer el componente de `slep_simce_adecuado`).
- El Ítem 8(a) introduce el primer cómputo cliente-relevante nuevo desde la carga
  histórica; verificar que `grados_ee` se serializa dentro del payload gzip+base64 ya
  existente, sin romper el tamaño ni el formato del JSON embebido.
