# Encargo autónomo — Vista histórica de la ficha: barras por año (alinear al diseño)

> Modo autónomo, secuencial. Ejecuta TODO en este turno, sin pedir confirmación
> entre fases. Patrón: `herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md`.
> Tipo de trabajo: corrección de fidelidad de UI (presentación pura). El parquet
> NO se toca.

---

## 0. Contrato de ejecución

- **Disciplina:** modo autónomo, secuencial. Lees el estado real antes de tocar
  nada (no modificar sin leer), implementas, regeneras con `only=35`, verificas
  en navegador, commiteas por fase con mensaje temático. No fragmentas: la ruta
  ya está aprobada por el titular.
- **Regla de detención (PARA y reporta solo si):**
  1. Un invariante 🔒 te obligaría a violar el contrato de datos (sección 2).
  2. Un dato real contradice un supuesto de este encargo (p. ej. `serieFull` no
     devuelve lo que aquí se afirma).
  3. Un gate estratégico no previsto. (No hay ninguno abierto en este encargo.)
  En esos tres casos reportas y esperas; no improvisas metodología.
- **Reglas canónicas heredadas (no se re-explican, ver política):** rutas
  absolutas siempre (`git -C /Users/tomgc/Projects/slep_idps …`); sin asumir
  `cd` previo; R-only; comentarios en español; commits atómicos temáticos (jamás
  `git add .`); `git status` revisado antes de cada `git add`; push solo con
  `git status` limpio.
- **Decisión ya tomada por el titular (gate cerrado):** el anidamiento histórico
  es **indicador → dimensión** únicamente. La **subdimensión NO se grafica en el
  histórico** (es distribución de niveles, no puntaje; invariante 🔒-3). No la
  agregues "por completitud": hacerlo viola el invariante y reabre el conflicto
  C2/D-s8-7 ya resuelto.

---

## 1. La meta (aprobable como un todo)

La **vista histórica** de la pantalla "Panorama IDPS por establecimiento"
(`isHist === true`) hoy renderiza **líneas de tendencia** (`PanelEvolucion`,
gráfico de línea con puntos). El diseño aprobado (`Propuesta_IDPS.html` +
`idps-demo.js`, en `50_documentacion/andamios/diseno/rediseno_3pantallas/`) pide
**barras verticales discretas por año**: una barra por cada año (2022, 2023,
2025…), eje fijo 0-100, valor encima de cada barra, año preliminar con relleno
atenuado y contorno discontinuo, y una marca de tendencia (`vs <año> *: ±N ·
sig`) en la cabecera de cada bloque.

La meta es **reemplazar el componente de líneas por el de barras por año en la
vista histórica**, replicando la estructura visual del diseño (CSS `.ybars` y
familia), anidando **indicador → dimensión**, conservando todos los invariantes
de dato. La vista **actual** (`isHist === false`) NO se toca en absoluto.

**Por qué es una sustitución, no un ajuste:** el CSS de barras del diseño
(`.ybars`, `.ybar-col`, `.ybar-plot`, `.ybar-fill`, `.ybar-val`, `.ybar-yr`) no
existe en el motor (`grep -c ybars motor_idps.html` → 0). El motor usa
`PanelEvolucion` (líneas) donde el diseño usa barras. Por eso "no se parece en
nada".

---

## 2. Invariantes (🔒 — intocables)

- **🔒-1 Cero agregación.** Cada barra es el puntaje del **establecimiento
  individual** en ese año. Nunca se promedia ni agrega.
- **🔒-2 Lee, no deriva.** No reconstruyas la línea absoluta del GSE
  (`prom − difgru` prohibido, decisión de ponderación §5). El histórico grafica
  solo el promedio del propio EE por año; el desvío vs GSE no se grafica en el
  histórico (ya vive a nivel indicador en la vista actual).
- **🔒-3 Subdimensión = distribución, no puntaje.** La subdimensión NO entra al
  histórico (decisión del titular, coherente con C2/D-s8-7). Solo indicador y
  dimensión, que sí son puntaje 0-100.
- **🔒-4 Eje fijo 0-100.** Cada panel de barras usa dominio `[0,100]` fijo,
  nunca autoescala. (El `PanelEvolucion` actual ya respeta esto; el nuevo
  componente debe mantenerlo.)
- **🔒-5 No interpolar huecos.** Un año sin aplicación (p. ej. 4° básico no
  aplica 2024) **no genera barra** ese año (hueco real), no se rellena ni se
  desliza. Año preliminar (`PRELIM.has(String(a))`) → barra atenuada/discontinua
  + sufijo `*`.
- **🔒-6 Paleta de 4 indicadores** (`#EE2D49 #FFC92E #9BC93E #2A8FD9`):
  codificación de dato, intacta. Las dimensiones usan tonos derivados vía
  `dimColor(ind.color, di, n)` (ya existe).
- **🔒-7 Comentarios CSS sin la secuencia `*/` literal dentro del texto** (Bug
  s7-1): no escribir `*/` dentro de un comentario.
- **🔒-8 El parquet `idps_largo.parquet` NO se toca.** md5 debe seguir siendo
  `50d9de4f1fc80259d29f499cdf46d9e1` antes y después. Todo es presentación:
  `run_all(only = 35)`. Si el md5 cambia, PARA y reporta (significa que tocaste
  el pipeline de datos, no la presentación).

---

## 3. Contexto técnico (rutas y estado real)

- **Raíz de código:** `/Users/tomgc/Projects/slep_idps`
- **Template fuente (lo que se edita):**
  `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
- **Build:** `source(here::here("00_build.R")); run_all(only = 35)` regenera
  `40_salidas/motor_idps.html` desde el template, SIN tocar el parquet.
- **Deploy (NO en este encargo salvo que el titular lo pida en el reporte):**
  `docs/index.html` es copia byte-idéntica de `motor_idps.html`; se republica
  aparte tras OK visual.
- **Diseño de referencia (read-only, en el repo):**
  `/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/diseno/rediseno_3pantallas/Propuesta_IDPS.html`
  (CSS de `.ybars` y familia) y su JS `idps-demo.js` (lógica de render de
  referencia). El CSS de barras por año está en `Propuesta_IDPS.html`, secciones
  marcadas `barra 0–100`, `.hist-*` y `.ybars`/`.ybar-*`.

### Estado real del bloque a reemplazar

En `35_motor_template.html`, dentro del componente `Ficha`, rama
`isHist === true` (envoltorio `<div className="hist-wrap">`), hoy hay:

```jsx
<section className="hist-ind" style={{"--ic":ind.color}} key={ind.id}>
  <div className="hist-ind-h">…<span className="hist-ind-name">{ind.nombre}</span></div>
  <div className="hist-main"><PanelEvolucion … pts={serieFull(indOf,rbd,grado,ind.id,anios)} hideHead={true}/></div>
  {idims.length>0 && <>
    <div className="hist-dims-lab">Dimensiones</div>
    <div className="hist-dims">
      {idims.map((dimo,di)=><PanelEvolucion … pts={serieFull(dimOf,rbd,grado,dimo.id,anios)}/>)}
    </div></>}
</section>
```

`PanelEvolucion` (líneas) es lo que hay que **dejar de usar en el histórico** y
sustituir por el nuevo componente de barras. (No borres `PanelEvolucion` del
archivo: si no queda referenciado en otra parte, puede quedar definido sin uso o
eliminarse; verifica con `grep` antes de borrar nada. La vista actual NO lo usa,
así que probablemente quede huérfano: decide tú si lo eliminas o lo dejas con un
comentario; documenta la decisión en el log.)

### Helpers que YA EXISTEN en el motor (úsalos, no los reescribas)

- `serieFull(ofFn, rbd, grado, id, anios)` → devuelve por año
  `{a, v, dif, sig}`, donde `v` = `prom` (puntaje 0-100 o `null` si hueco),
  `dif` = diferencia vs evaluación anterior, `sig` = significancia
  (`1`/`0`/`-1`/`null`). Es exactamente el shape que el componente de barras
  necesita. Funciona con `indOf` (indicador) y `dimOf` (dimensión).
- `dimsByInd[ind.id]` → array de dimensiones del indicador.
- `dimColor(ind.color, di, n)` → tono derivado de la dimensión `di` de `n`.
- `PRELIM` (Set de años preliminares como string), `fmt(v)`, `fmtSigned(d)`,
  `showTT(html, ev)` / `hideTT()` para tooltips, `useRef`/`useEffect`.
- `anios` (array de años del grado) ya está en scope en el bloque histórico.

### Tokens CSS del motor (mapea los del diseño a estos)

El diseño usa nombres propios (`--ink`, `--slate`, `--line`, `--line-strong`,
`--st-bajo`, etc.). El motor usa: `--tinta` (texto), `--gris` (texto sec.),
`--linea` (líneas), `--cream-200` (fondo barra base), `--alerta` `#EE2D49` (▼),
`--destaca` `#2A8FD9` (▲), `--st-neutro` `#8C8A86` (=). Al portar el CSS de
`.ybars`, **traduce los nombres de variable del diseño a los tokens del motor**
(igual que se hizo con `.hist-ind`/`.hist-dims`, ya presentes en el template).

---

## 4. Fases en orden estricto

### Fase 1 — Leer el estado real (Paso 0, no modificar sin leer)

1. Lee en `35_motor_template.html`: el bloque `hist-wrap` completo (rama
   `isHist`), la definición de `PanelEvolucion`, `serieFull`, `dimsByInd`,
   `dimColor`, y el bloque CSS `.hist-*` ya existente.
2. Lee en `Propuesta_IDPS.html` el CSS de `.ybars`, `.ybar-col`, `.ybar-plot`,
   `.ybar-fill` (incluye `.is-prelim`), `.ybar-val`, `.ybar-yr`, y los
   modificadores de tamaño `.hist-main .ybars` / `.hist-dim .ybars`. Lee también
   `idps-demo.js` en la zona de render histórico para ver cómo arma las barras
   por año y la marca de tendencia de cabecera (referencia de comportamiento).
3. Verifica el md5 del parquet ANTES de empezar:
   `md5 /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
   → debe ser `50d9de4f1fc80259d29f499cdf46d9e1`. Anótalo.

Sin commit (solo lectura).

### Fase 2 — Portar el CSS de barras por año

Agrega al `<style>` del template el CSS de `.ybars` y familia del diseño,
**traducido a los tokens del motor** (sección 3). Incluye el estado preliminar
(`.ybar-fill.is-prelim`: relleno atenuado + contorno discontinuo) y los
modificadores de altura para el nivel indicador (`.hist-main`) vs dimensión
(`.hist-dim`). Respeta 🔒-7 (sin `*/` literal en comentarios).

**Criterio de éxito Fase 2:** el CSS compila (render sin romper layout); las
clases `.ybars`, `.ybar-fill`, `.is-prelim`, `.ybar-val`, `.ybar-yr` existen en
el template.

**Commit:** `style(motor): portar CSS de barras por año (.ybars) del diseño al template`

### Fase 3 — Componente `BarrasAnio` (barras verticales por año)

Crea un componente React (nombre sugerido `BarrasAnio`; tú decides el nombre
final) que recibe `{nombre, color, pts}` con `pts` en el shape de `serieFull`
(`{a, v, dif, sig}`) y renderiza:

- Una **columna por año** de `pts`. Si `v == null` (hueco), la columna se omite
  o se muestra vacía sin barra (🔒-5: no interpolar). El diseño muestra el hueco
  como ausencia de barra; replica eso.
- **Barra vertical** con altura proporcional a `v` sobre eje fijo 0-100 (🔒-4).
  Implementación a tu criterio: el diseño lo hace con CSS puro (`.ybar-fill`
  posicionado con `bottom:0` y altura `% = v`), no con SVG/D3. Prefiere el
  enfoque CSS del diseño para fidelidad visual exacta; si optas por D3, justifica
  en el log. (El `PanelEvolucion` viejo usaba D3 por ser línea; las barras del
  diseño son CSS.)
- **Valor encima** de cada barra (`.ybar-val`, `fmt(v)`).
- **Año debajo** (`.ybar-yr`) con sufijo `*` si `PRELIM.has(String(a))`.
- Año preliminar → barra con clase `is-prelim` (atenuada + discontinua).
- **Color** = `color` recibido (indicador o tono de dimensión).
- **Tooltip** opcional al pasar el mouse (reusa `showTT`/`hideTT`) con
  `nombre + año + fmt(v)`; mantén el patrón del componente viejo.
- **Marca de tendencia en cabecera:** el diseño muestra en la cabecera del
  bloque (`.hist-trend`) la diferencia del último año con dato vs el año anterior
  comparado, en formato `vs <año> *: ±N · <sig>` con ▲/▼/= y color de estado
  (`--destaca`/`--alerta`/`--st-neutro`). Toma `dif`/`sig` del último punto con
  `dif != null` de `pts` (es lo que `serieFull` ya entrega). Replica el copy del
  diseño. Esta marca reemplaza las `evol-marks` inter-anuales del componente
  viejo.

**Criterio de éxito Fase 3:** el componente renderiza barras por año con eje
0-100, valores correctos, huecos sin barra, preliminar atenuado, y la marca de
tendencia en cabecera. Verificable en navegador con un EE real que tenga serie
multi-año (p. ej. el del screenshot, RBD 1864 / Complejo Educacional Sargento
Aldea, 4° básico) y con uno que tenga huecos.

**Commit:** `feat(motor): componente BarrasAnio (barras verticales por año, eje 0-100)`

### Fase 4 — Sustituir en la vista histórica

En el bloque `hist-wrap` (rama `isHist`):

- Reemplaza el `<PanelEvolucion … pts={serieFull(indOf,…)}/>` del nivel
  **indicador** (dentro de `.hist-main`) por `<BarrasAnio …>` con la misma serie
  y la marca de tendencia en la cabecera `.hist-ind-h` (añade el span
  `.hist-trend` a la cabecera del indicador).
- Reemplaza los `<PanelEvolucion … pts={serieFull(dimOf,…)}/>` del nivel
  **dimensión** (dentro de `.hist-dims`) por `<BarrasAnio …>` con tono de
  dimensión (`dimColor`). Cada panel de dimensión lleva su propia cabecera con
  nombre y su marca de tendencia (`.hist-trend.tiny` según el diseño).
- **NO** agregues nivel subdimensión (🔒-3).
- Conserva el texto explicativo `.ficha-explain` del histórico (ya correcto:
  "Puntaje por año … eje fijo 0–100 … se leen de la Agencia … huecos son años sin
  aplicación"). Ajústalo solo si el copy del diseño difiere; si difiere, usa el
  del diseño.
- Conserva la `nota nota-inv` de cierre del histórico (invariante lee-no-deriva).

**Criterio de éxito Fase 4:** la vista histórica de la ficha se ve como el
diseño (`Propuesta_IDPS.html` render): barras por año anidadas indicador →
dimensión, no líneas. Verifica 1:1 contra el render del diseño abriendo ambos.
Verifica que la vista **actual** (`isHist === false`) quedó intacta.

**Commit:** `feat(motor): vista historica de ficha usa barras por año (indicador y dimension), reemplaza lineas`

### Fase 5 — Regenerar, verificar invariantes y md5

1. `source(here::here("00_build.R")); run_all(only = 35)` desde la raíz del
   proyecto. Regenera `40_salidas/motor_idps.html`.
2. Verifica md5 del parquet DESPUÉS:
   `md5 …/idps_largo.parquet` → debe seguir siendo
   `50d9de4f1fc80259d29f499cdf46d9e1` (🔒-8). Si cambió, PARA y reporta.
3. Abre `motor_idps.html` regenerado en navegador. Recorre la vista histórica de
   al menos dos EE (uno con serie completa, uno con huecos). Confirma sin errores
   de consola.

**Commit:** ninguno propio (la regeneración del `motor_idps.html` puede ir en el
commit de Fase 4 o como `build(motor): regenerar only=35` aparte; tú decides,
documenta cuál).

---

## 5. Auto-auditoría antes de reportar

Este encargo es de **presentación** (no de datos): no requiere panel adversarial
completo. Basta el principio general + verificación en navegador, MÁS estos tres
checks explícitos (porque tocan el límite del invariante):

1. **Fidelidad visual:** abre `Propuesta_IDPS.html` y la vista histórica del
   `motor_idps.html` regenerado lado a lado. La estructura de barras por año debe
   coincidir (columnas por año, valor encima, año debajo, preliminar atenuado,
   anidamiento indicador → dimensión). Documenta divergencias residuales si las
   hay.
2. **🔒-3 (subdimensión ausente):** confirma por `grep`/inspección que el bloque
   histórico NO renderiza subdimensiones (ni `SubDist`, ni `DistBar`, ni
   `.hist-sub` con barras de puntaje). Solo indicador y dimensión.
3. **🔒-8 (parquet intacto):** md5 antes == md5 después ==
   `50d9de4f1fc80259d29f499cdf46d9e1`. Déjalo registrado en el log.

---

## 6. Log de cierre (obligatorio)

Escribe `50_documentacion/andamios/logs/YYYYMMDD_vista_historica_barras_log.md`
con la plantilla fija (sección 4 del encargo_autonomo_v1): resumen, inventario de
commits (hash corto + tipo + título + qué hizo), por cada cambio sustantivo (qué,
por qué, archivos, verificación, decisiones —p. ej. enfoque CSS vs D3 para las
barras, y qué hiciste con `PanelEvolucion` huérfano—), verificación de cada 🔒
con PASA/FALLA y evidencia, md5 antes/después del parquet, y notas para el
revisor (qué mirar con ojo crítico, deuda residual). Sé honesto: incluye lo que
costó. El log puede quedar sin commitear (para revisión del titular) o como
`docs()` atómico aparte; documenta cuál elegiste.

---

## 7. Reporte final (al titular, vía el asistente de análisis)

Al terminar, reporta: estado final (hecho/parcial), inventario de commits con
hash, confirmación de los tres checks de auto-auditoría (fidelidad, 🔒-3, md5),
ruta del log, y si quedó algún `# REVISAR`. **NO republiques `docs/` en este
turno** salvo instrucción explícita: la republicación a Pages espera el OK visual
del titular sobre el `motor_idps.html` regenerado (compuerta P0-s9). Indica
explícitamente que `docs/` quedó sin tocar y que el deploy es el paso siguiente
del titular.
