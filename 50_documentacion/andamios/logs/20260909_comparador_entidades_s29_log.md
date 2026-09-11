# Log — Comparador: entidades (nacional + establecimiento) y etiquetado adaptativo

> Encargo: `50_documentacion/activa/encargos/encargo_claude_code_idps_comparador_entidades_s29.md`
> Referencia visual vinculante: `50_documentacion/andamios/diseno/detalles/mockup_comparador_ee_nacional.html`
> Sesión: s29. Ejecución autónoma secuencial, 2026-09-09.
> Alcance: 100% presentación. No se tocó el pipeline de datos (31–34) ni
> `idps_largo.parquet`. No se desplegó a `docs/`. No se tocó `feat/contrato-contexto`.

---

## 1. Inventario de commits

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 1 | `d4edefc` | 1 — `fix(motor): etiqueta de barra por espacio real, no por porcentaje` | `30_procesamiento/35_motor_template.html` |
| 2 | `3c16c80` | 2 — `feat(comparador): entidad nacional como referencia fija` | `30_procesamiento/35_motor_template.html` |
| 3 | `ffdaeaa` | 3 — `feat(comparador): establecimientos como filas de caso individual` | `30_procesamiento/35_motor_template.html` |
| 4 | `6c37ea4` | 4 — `refactor(comparador): rotulo "entidad" en la interfaz` | `30_procesamiento/35_motor_template.html` |
| 5 | `b3a0340` | 5 — `build(motor): regenera el motor con el comparador de entidades s29` | `40_salidas/motor_idps.html` |
| 6 | (este) | 6 — `docs(log): registro del encargo comparador de entidades s29` | `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` |

Commit atómico por fase, `git add` a rutas exactas. El motor regenerado se
commiteó aparte (Fase 5) para no mezclar plantilla y salida en un mismo commit.

---

## 2. Cambios sustantivos por fase

### Fase 1 — Etiquetado adaptativo de `StackedBar`

**Qué.** El umbral de etiquetado dejó de decidirse por porcentaje del total
(`p>=16` → `"p% (n)"`, `p>=9` → `"p%"`) y pasa a decidirse por el espacio real
en píxeles del segmento.

**Por qué.** El umbral estaba calibrado con territorios de dos dígitos de EE.
Con la entidad nacional, `"18% (1.108)"` no cabe en el 18% de una columna
repartida entre cuatro indicadores: el texto se cortaba a media cifra. Es un
defecto latente que el nivel nacional vuelve visible, por eso se arregló antes
de agregar la entidad nacional.

**Cómo.**

- Helper de medición a nivel de módulo: `canvas` + `getContext("2d")` +
  `medirTexto(txt)`. La fuente **se deriva** del CSS efectivo de
  `.s100-seg span` (se monta una sonda `.s100 > .s100-seg > span` fuera de
  pantalla y se lee `fontWeight`/`fontSize`/`fontFamily` computados); no se
  escribe a mano. Se vuelve a derivar en `document.fonts.ready` y se notifica a
  las barras montadas vía un `Set` de suscriptores, porque las OTF de marca van
  embebidas y cambian el ancho del texto al cargar.
- `ResizeObserver` **compartido** a nivel de módulo, con `Map` elemento →
  callback y funciones `observar(el, cb)` / `desobservar(el)`. Un observer por
  celda era inaceptable: la matriz llega a ~200 celdas.
- `StackedBar` toma un `ref` a su `.s100`, guarda el ancho en estado
  (`useState` + `useLayoutEffect`) y se da de alta/baja en el observer
  compartido. Los hooks se movieron **antes** del retorno temprano de
  "sin dato"; el efecto depende de `vacia` para cubrir la transición N=0 → N>0
  sin desmontar.
- Regla única: para cada segmento con `p>0`, `px = ancho * p / 100` y
  `full = "p% (n)"` con `n` formateado con `fmt` (= `toLocaleString("es-CL")`).
  Si `medirTexto(full) + 12 <= px`, la etiqueta va dentro; si no, el segmento
  queda **sin texto** y su dato completo (`▼/=/▲ p% (n)`) baja **entero** a la
  tira externa. Sin nivel intermedio "solo p%".
- Tira externa alineada a los sectores: `.s100-ext` pasó de `flex` a
  `display:grid` con `grid-template-columns:1fr auto 1fr`; `.ext-bajo` en la
  columna 1 (`justify-self:start`), `.ext-neutro` en la 2 (centro),
  `.ext-sobre` en la 3 (`justify-self:end`). El estado ausente no desplaza a
  los otros.
- El `title` de cada segmento y el `aria-label` de la barra **no cambiaron de
  contenido** (siguen con el conteo crudo, sin separador de miles).

**Retiro verificado.** No quedan en la plantilla las condiciones `p>=16`,
`p>=9` ni `p>0&&p<9` (grep en §3.3).

**Impacto cruzado.** `StackedBar` también la usa el panorama territorial;
verificado en §3.4.

### Fase 2 — Entidad nacional

- `rosterTerr`: rama `kind === "nacional"` **al inicio** de la cadena, que no
  filtra. Se puso primero justamente para que no cayera por descarte en el
  `else` final, que captura `region`.
- `NACIONAL_OPT`: ítem fijo `{kind:"nacional", cod:"CL", nom:"Chile",
  sub:"Nivel nacional · 346 comunas · 9.136 establecimientos"}`, con los
  conteos derivados de `DATA.establecimientos` (mismo patrón que `SLEPS_OPTS`).
- `buildListCmp` devuelve `[NACIONAL_OPT].concat(...)`: Chile es la **primera
  fila de la lista en todos los tabs**, no un tab propio, y no depende del
  texto buscado (es la referencia, no un resultado de búsqueda). El cuerpo
  anterior se movió a `_listaCmpEnt`, sin cambios.
- `EntityModal` marca esa fila con `is-nac` (borde punteado de foco); es la
  única modificación al andamio y sólo se activa con `kind === "nacional"`,
  que no existe en el otro modal.
- `Comparador`: `cmpOrden` es una **copia ordenada** de `cmpTerr` con la
  entidad nacional primero (`sort` estable ⇒ el resto conserva su orden de
  selección). El estado `cmpTerr` no se muta. Chips y filas recorren `cmpOrden`.
- Fila con clase `row-nac` y subtítulo "referencia nacional"; chip con
  `cmp-ck` = "Nacional · fijo" y banda izquierda `--azul`.
- La meta del chip se calcula del **roster real** por grado y año (D-s8-4), no
  del directorio: para (4b, 2025) da "343 comunas · 6.717 establecimientos",
  distinto de los 346/9.136 del directorio que rotula el picker. Es lo
  correcto: el chip describe lo que efectivamente se está comparando.

### Fase 3 — Filas de establecimiento

- Tab nuevo en `TABS_CMP`: `["establecimiento","Establecimiento"]`. Su rama
  **reusa** `buildList("establecimiento", ql)` y sólo le añade al `sub` el GSE
  del EE en `(cmpGrado, agnoCmp)` vía `gseLbl`. Para poder pasarle ese par,
  `buildListCmp` recibe ahora `(tab, ql, grado, agno)` y `App` lo envuelve:
  `buildList={(tab,ql)=>buildListCmp(tab,ql,cmpGrado,agnoCmp)}`.
- `gseCod(rbd,grado,agno)` devuelve el **código** de GSE (el comparador lo
  necesita para ubicar al EE en la tabla de su GSE); `gseLbl` quedó como su
  capa de presentación y delega en él. Sin duplicar el recorrido del roster.
- `addTerr` aceptó el nuevo `kind` sin ningún cambio: mismo toggle, mismo tope
  `CMP_MAX_TERR=10`, sin subtope por tipo.
- Render: `cmpOrden` se parte en `cmpTerrs` (territorios, incluida la nacional)
  y `cmpEEs`. Cada EE se dibuja como **última fila de la tabla de su propio
  GSE**, con `row-ee` y `row-ee-first` en el primero. Un EE nunca aparece en
  otra tabla.
- `CeldaEE` (no `StackedBar`): glifo de estado en círculo con los colores de
  ESTADO según `indOf(rbd,cmpGrado,agnoCmp)[ind.id].sigdifgru` (`-1`, `0/null`,
  `1`), el puntaje `prom` con el formato del motor (`fmt`) y, debajo, el estado
  como texto ("bajo su GSE" / "sin diferencia" / "sobre su GSE").
  `prom == null` → `"sin dato"` en cursiva; jamás un cero ni un guion.
- Pie de sección (`gse-sec-foot`): sólo se pinta si hay EE seleccionados de
  otro GSE, y los nombra. Se resolvió la posición real: "se muestra más abajo"
  o "se muestra más arriba" según el orden de `visGse`, y se cubren dos casos
  que el mockup no ilustra: EE cuyo GSE está oculto por el segmentador, y EE
  sin GSE en ese nivel y año.
- Chip del EE: `cmp-ck` = "Establecimiento", nombre curado, `RBD nnnn · GSE x`
  y banda izquierda `--foco`.

### Fase 4 — "Territorio" → "Entidad"

Sólo texto visible, sin renombrar identificadores (`cmpTerr`, `rosterTerr`,
`addTerr`, `removeTerr`, clases `cmp-*` intactos):

- encabezado de columna `Territorio` → `Entidad`;
- contador `Entidades a comparar · N de 10`;
- botón `+ agregar entidad`;
- invitación y estado vacío;
- título del modal `Agregar entidad a la comparación`;
- botón de limpiar: `aria-label`/`title` `Limpiar territorios` → `Limpiar
  entidades`. Los `aria-label` de los ✕ por chip ya eran `"Quitar {nombre}"`,
  sin la palabra "territorio", así que no requerían cambio.

Comentario de una línea dejado sobre el bloque del comparador explicando que
"territorio" en el código significa "entidad comparable" desde s29.

**No** se cambiaron el título de pantalla ni la pestaña de navegación
("Comparación entre territorios"): no están en la enumeración del encargo y el
mockup los conserva.

---

## 3. Resultado de los 5 chequeos de la Fase 5 (valores observados)

### 3.1 Build limpio

`Rscript -e 'source("00_build.R"); run_all(only = 35L)'` → **OK, exit 0**, sin
warnings nuevos. El log del build final es idéntico al de la línea base salvo
el tiempo transcurrido (4,2 s → 4,3 s).

Nota de entorno: la librería de `renv` del proyecto estaba vacía y el build
fallaba con `no hay paquete llamado 'rprojroot'` **antes de tocar nada**. Se
resolvió con `renv::restore(prompt = FALSE)`, que enlazó todos los paquetes
desde la caché global (`[linked from cache]`, sin descargas). `renv.lock` no se
modificó.

### 3.2 Fidelidad de cifras — **cero movimiento**

Resumen del bloque 7 del generador, línea base (antes del encargo) vs final:

| Métrica | Antes | Después |
|---|---|---|
| Regiones | 16 | 16 |
| Establecimientos | 9.136 | 9.136 |
| Unidades de grilla | 91.596 | 91.596 |
| Filas ind / dim / niv | 366.384 / 557.898 / 662.514 | 366.384 / 557.898 / 662.514 |
| JSON plano → gzip+base64 | 59,5 MB → 4,41 MB (7,4%) | 59,5 MB → 4,41 MB (7,4%) |
| Peso HTML | 5,1 MB | 5,1 MB |

Además del resumen se comparó el **payload completo**: se decodifica el bloque
base64, se descomprime y se normaliza `fecha_generacion`. SHA-256 del JSON
normalizado, antes y después:

```
b1fd3eb10d804e9ae5bc3990e91e9d1089c0a2766865cd8bca2c916a30bf4f7c   (59.466.778 bytes)
```

Idéntico. El payload no cambió ni en un byte fuera de la fecha de generación,
lo que era esperable: este encargo no toca el generador ni el dato.

Hallazgo lateral: el `motor_idps.html` que estaba versionado se había generado
el 2026-07-03 y difería del rebuild **sólo** en `fecha_generacion` (offsets 35 y
38 del JSON, ninguna otra diferencia en 59,4 MB). Es decir, el artefacto
versionado ya estaba al día respecto del dato.

Fidelidad en pantalla, verificada contra las fuentes crudas:

- Fila de EE (RBD 12301, 4b, 2025): pintado `57 / 71 / 67 / 63` con estados
  `▼ / = / ▼ / ▼`; crudo de `indOf`: `prom` `57, 71, 67, 63` y `sigdifgru`
  `-1, 0, -1, -1`. Coinciden. Es lectura directa, no una media.
- Fila Chile, GSE Bajo, indicador 1: pintado `1.355 con dato — 233 (17%) /
  890 (66%) / 232 (17%)`; recuento independiente sobre el roster nacional
  completo: `{N:1355, bajo:233, neutro:890, sobre:232}`. Coinciden.
- Roster nacional (4b, 2025) = 6.717 EE, igual a la meta del chip de Chile.

### 3.3 Grep de retiro

```
grep -n "p>=16\|p>=9\|p<9\|s\.p>=\|s\.p<" 30_procesamiento/35_motor_template.html
```

Sin coincidencias. En la salida generada, `grep -c "s.p>=16"` → `0`.

### 3.4 Inspección en navegador

`40_salidas/motor_idps.html` servido en `http://localhost:8766`. Sin errores en
consola (sólo el aviso esperable de Babel in-browser). Auditoría automatizada
sobre el DOM (por cada segmento se compara el ancho real del `<span>` contra el
ancho del segmento; se cruzan los porcentajes de dentro y de fuera; se comparan
las coordenadas x de la tira):

| Escenario | Barras | Etiq. dentro | Etiq. fuera | Cortadas | % duplicados | Orden ▼◂▸▲ malo |
|---|---|---|---|---|---|---|
| Comparador 1200px (Chile + SLEP Costa Central + Viña del Mar + 2 EE) | 60 | 75 | 83 | **0** | **0** | **0** |
| Comparador 430px (mismo set) | 60 | 0 | 168 | **0** | **0** | **0** |
| Panorama territorial 1200px | 16 | 38 | 2 | **0** | **0** | **0** |

Magnitud del defecto corregido: en la pantalla del comparador a 1200px, con la
**regla vieja**, 49 de 158 segmentos habrían pintado un `"p% (n)"` cortado —
por ejemplo `"17% (233)"` necesita 65px y su segmento mide 36px. Con la regla
nueva: 0. Otros 25 segmentos habrían mostrado sólo `"p%"`, que ahora o muestran
el dato completo dentro o lo bajan entero a la tira.

La fuente derivada en tiempo de ejecución resultó
`bold 14px "Museo Sans", "Helvetica Neue", system-ui, Arial, sans-serif`, es
decir la OTF de marca embebida, no una fallback: la medición se hace contra la
tipografía real.

Estructura verificada en el mismo escenario: `row-nac` es la primera fila de
las 5 secciones de GSE; `Colegio Español de Viña del Mar` (GSE Medio alto) y
`Scuola Italiana Arturo Dell' Oro Viña del Mar` (GSE Alto) aparecen sólo en su
propia sección, con `row-ee row-ee-first`; los pies nombran al EE ausente con
la dirección correcta ("más abajo" / "más arriba"). Caso "sin dato" verificado
con RBD 10095 (4b, 2025), que tiene 3 de 4 indicadores: la celda vacía pinta
`<span class="ee-nd">sin dato</span>`, no un cero ni un guion.

A 430px la tabla mantiene `table-layout:fixed`: las barras quedan en 17px, todo
el etiquetado baja a la tira y `.cmp-tscroll` habilita scroll horizontal
(`scrollWidth` 569 vs `clientWidth` 380). Degradación correcta, sin recorte.

**Limitación de la verificación (importante para el gate visual).** El panel de
navegador de esta sesión corre con `document.hidden === true`. Con el documento
oculto el navegador suspende los pasos de renderizado, así que **no entrega
callbacks de `ResizeObserver` ni eventos `resize`** (comprobado: 0 disparos tras
cambiar el viewport de 1200px a 430px, con `window.innerWidth` ya en 430). Por
eso el camino "arrastrar el borde de la ventana y ver degradar las etiquetas"
no pudo ejercitarse aquí. Lo que sí quedó demostrado es que la **regla** es
correcta a cualquier ancho: montando en frío a 430px, y forzando el remontaje
de una sección a 430px, las tres etiquetas bajan enteras a la tira
(`▼ 12% (86)` · `= 69% (489)` · `▲ 19% (135)`). El re-etiquetado en vivo al
redimensionar queda para el gate visual del titular en un navegador normal.

### 3.5 Contraste con el mockup aprobado

Diferencias encontradas. Se **reportan**, no se "corrigieron" hacia criterio
propio:

1. **`.s100-seg span{overflow:hidden}`** — el mockup lo incluye; el motor **no**
   lo lleva. El invariante 4 prohíbe el recorte silencioso, y con la regla de
   medición el texto siempre cabe: esa guarda sólo podría ocultar un defecto en
   vez de evitarlo.
2. **Decimal del puntaje** — el mockup muestra `78,4` y `76,0`; el motor
   muestra `57`, `71`. Los 354.007 valores de `prom` no nulos del payload son
   **enteros** (verificado en el dato); `fmt` es el formateador del motor, el
   mismo que usa la ficha. Forzar una decimal inventaría un dígito que la
   fuente no tiene.
3. **Mayúscula del GSE** — el mockup escribe "GSE medio"; el motor escribe
   "GSE Medio", porque la Fase 3.1 manda usar `gseLbl` y esa es su salida en
   todo el motor (ficha incluida).
4. **Chile en el modal** — el mockup lo dibuja *sobre* el buscador; el motor lo
   pone como primera fila de la lista, que es lo que dicen en palabras tanto el
   encargo como el §3 del mockup ("fila fija arriba de la lista"). `EntityModal`
   es andamio congelado y su layout pone el buscador sobre la lista.
5. **Orden del `sub` del EE en el picker** — mockup: "RBD 1854 · Viña del Mar ·
   GSE medio"; motor: "Viña del Mar · RBD 1854 · GSE Medio", porque la Fase 3.1
   manda **reusar** la rama existente de `buildList`, que arma `comuna · RBD`.
6. **`.cmp-chip{max-width}`** — mockup 290px, motor conserva 280px (no es un
   requisito del encargo).
7. **Pie de la segunda sección** — el mockup ilustra ahí una nota sobre "sin
   dato"; el encargo sólo especifica el pie para EE de otro GSE, así que sólo
   se pinta en ese caso.
8. **Variante sobria** (glifo sin puntaje) — el mockup la ofrece como opción
   abierta; el encargo §3.4 decide glifo + puntaje, y eso es lo implementado.

---

## 4. Decisiones de implementación tomadas dentro del margen del encargo

1. **`renv::restore()` para poder construir.** La librería del proyecto estaba
   vacía y el build fallaba antes de cualquier edición. Se restauró desde la
   caché global, sin descargas y sin tocar `renv.lock`. Se descartó la
   alternativa de construir contra la librería del sistema: contradice el
   protocolo de portabilidad del README, que declara `renv.lock` fuente única.
   (Se comprobó, de todos modos, que ambas rutas producen un payload idéntico.)
2. **Servidor local para la inspección.** La entrada `motor` de
   `.claude/launch.json` usa `servr::httd`, y `servr` no está en `renv.lock`.
   Se agregó una entrada **`motor-py`** (`python3 -m http.server 8766`) sin
   tocar la existente. `.claude/` está en `.gitignore`: es configuración local,
   no entra al repo.
3. **`fmt()` en la meta de los chips.** Sin separador de miles, el chip de
   Chile leía "6717 establecimientos" junto a un picker que dice "9.136". Se
   aplicó el formateador del motor a las cifras de la meta de todos los chips.
   Es formato, no cifra: el número no cambia.
4. **`gseCod` extraído y `gseLbl` delegando en él.** Evita duplicar el recorrido
   del roster ahora que se necesita el código además de la etiqueta.
5. **`buildListCmp(tab, ql, grado, agno)`.** Era la forma mínima de darle al
   catálogo el par `(cmpGrado, agnoCmp)` que exige la Fase 3.1, sin estado
   global ni un segundo índice.
6. **Frase agregada a la banda "no se agrega".** Ahora dice "Cada celda **de
   territorio** reparte..." y cierra con "Las filas de **establecimiento** son
   un caso único: muestran su estado, no un reparto". Es el texto del mockup
   §1; sin él la banda quedaba incompleta al existir filas de EE. Entró en el
   commit de Fase 4 por ser texto visible.
7. **Pie de sección con posición real.** El encargo pide "se muestra más
   abajo"; se resolvió según el orden efectivo de `visGse` ("más arriba" cuando
   corresponde) y se cubrieron los dos casos que el mockup no ilustra (GSE
   oculto por el segmentador; EE sin GSE en ese nivel y año). Decir "más abajo"
   de algo que está más arriba habría sido una afirmación falsa en pantalla.
8. **Hooks antes del retorno "sin dato" en `StackedBar`,** con el efecto de
   layout dependiente de `vacia`. Es lo que exigen las reglas de hooks y cubre
   la transición N=0 → N>0 sin desmontar el componente.

---

## 5. Pendientes que este encargo dejó anotados (no ejecutados)

- Despliegue a `docs/index.html`: gate visual del titular, sesión aparte.
- Tooltip "vs evaluación anterior": de `title` a body (heredado de s28).
- Rama `feat/contrato-contexto` con 2 commits locales sin push (paso 36): fuera
  de alcance, no se tocó.
- Verificación del re-etiquetado **en vivo** al redimensionar (ver §3.4): pide
  un navegador con la pestaña visible.

---

# Continuación de la sesión — s29b y s29c (2026-09-10)

> Misma sesión s29. Dos encargos posteriores al registro de arriba:
> **s29b** (aviso único de establecimientos sin ubicación) y
> **s29c** (`50_documentacion/activa/encargos/encargo_claude_code_idps_contraste_texto_estado_s29c.md`,
> contraste del texto de estado), con referencia visual vinculante
> `50_documentacion/andamios/diseno/detalles/mockup_contraste_estados.html`.
> Alcance: 100% presentación. No se tocó el pipeline (31–34) ni `idps_largo.parquet`.
> No se desplegó a `docs/`. No se tocó `feat/contrato-contexto`.

## 6. Inventario de commits de s29b y s29c

| # | Commit | Encargo · Fase | Rutas |
|---|---|---|---|
| 7 | `495b9fb` | s29b — `fix(comparador): aviso unico de establecimientos sin ubicacion` | `30_procesamiento/35_motor_template.html` |
| 8 | `8d5a011` | s29b — `build(motor): regenera el motor con el aviso unico s29b` | `40_salidas/motor_idps.html` |
| 9 | `82ba5d3` | s29c · 1 — `fix(motor): tokens de texto accesibles para el estado vs GSE` | `30_procesamiento/35_motor_template.html` |
| 10 | `a6e82d3` | s29c · 2 — `docs(decision): contraste del texto de estado y excepcion de la etiqueta interna` | `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` |
| 11 | `110ab44` | s29c · 3 — `build(motor): regenera el motor con los tokens de texto accesibles` | `40_salidas/motor_idps.html` |
| 12 | `14cab8a` | s29c · 4 — `docs(andamios): versiona encargos, mockups y escaner de estructura s29` | 6 andamios (encargos, mockups, escáner) |
| 13 | (este) | s29c · 5 — `docs(log): registro de s29b y s29c` | este archivo |

## 7. s29c — qué se cambió

Tres tokens nuevos en el `:root` de `35_motor_template.html`, **añadidos**, no sustituidos:

```
--alerta-txt:#D2112D;  --destaca-txt:#1E6EA9;  --st-neutro-txt:#5F6A78;
```

Aplicados en dos lugares y solo en esos dos:

1. `.s100-ext-it` — el color deja de viajar como `style={{color:s.c}}` (traía el color
   de **barra**) y sale de la clase de estado que el elemento ya llevaba
   (`ext-bajo` / `ext-neutro` / `ext-sobre`).
2. `.ee-st` — deja `var(--gris)` y toma el token del estado, en negrita; `CeldaEE`
   marca el estado con clase (`ee-st bajo|neutro|sobre`).

`--alerta`, `--destaca` y `--st-neutro` conservan sus valores; barras, glifos `.ee-gl`
y muestras de la leyenda quedan idénticos. `grep` confirma que los tres tokens nuevos
no aparecen en ninguna barra, borde, fondo ni leyenda.

## 8. Chequeos de la Fase 3 de s29c (valores observados)

### 8.1 Build limpio

`run_all(only = 35L)` en 4,5 s, sin error y sin warning nuevo. Bloque 7 idéntico a la
línea base de s29:

| Métrica | s29 (base) | s29c |
|---|---|---|
| Regiones | 16 | 16 |
| Establecimientos | 9.136 | 9.136 |
| Unidades de grilla | 91.596 | 91.596 |
| Filas ind / dim / niv | 366.384 / 557.898 / 662.514 | 366.384 / 557.898 / 662.514 |
| JSON plano → gzip+base64 | 59,5 MB → 4,41 MB (7,4%) | 59,5 MB → 4,41 MB (7,4%) |
| Peso HTML | 5,1 MB | 5,1 MB |

Nota de entorno: `renv::status()` reporta `suitedoc` como no instalado. No lo usa ni
`00_build.R` ni el paso 35 (`grep` sin coincidencias); no bloquea el build y no se
tocó `renv.lock`.

### 8.2 Fidelidad del payload — cero movimiento

Se decodificó el bloque `atob(...)` de ambos motores (el de `HEAD~` y el regenerado),
se descomprimió (zlib) y se compararon **carácter a carácter**:

```
bytes JSON:  59.466.778  ==  59.466.778
offsets que difieren: [37, 38]
  off 37: '0' -> '1'
  off 38: '9' -> '0'
  contexto: ...racion":"2026-09-09","cob  ->  ...racion":"2026-09-10","cob
```

Es decir: **las dos únicas posiciones distintas en 59,4 MB son los dos dígitos del día
en `fecha_generacion`**. Ninguna cifra se movió.

**Discrepancia que hay que dejar anotada:** el encargo s29c fija como regla de
detención que "el SHA-256 del JSON normalizado debe seguir siendo
`b1fd3eb1…4f7c`". Ese valor **no es reproducible**, porque el log de s29 registró el
hash pero no la receta de normalización, y el hash depende de con qué se sustituye la
fecha. Se probaron 18 convenciones plausibles (cadena vacía, `null`, `XXXX-XX-XX`,
`0000-00-00`, `NORMALIZADA`, borrar la clave, con y sin salto de línea final, hash del
base64, del gzip y del HTML completo) y ninguna da `b1fd3eb1…`. El recuento de bytes
del JSON crudo (59.466.778) **sí** coincide exacto con el que el log de s29 publica
junto a ese hash, lo que confirma que el payload es el mismo y que lo que no coincide
es la receta, no el dato.

Para que esto no se repita, a partir de aquí la convención queda **escrita**:
sustituir `"fecha_generacion":"AAAA-MM-DD"` por `"fecha_generacion":"0000-00-00"`
(misma longitud, byte count invariante) y hashear en UTF-8 sin salto final. Con esa
convención, y sobre estos dos motores:

```
1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6   (59.466.778 bytes)
```

idéntico antes y después. La verificación fuerte, en todo caso, es el diff de dos
offsets de arriba, que no depende de ninguna convención.

### 8.3 Auditoría de contraste sobre el motor generado

Método: colores **computados** en el navegador sobre el motor regenerado, comparador
poblado (Chile + SLEP Costa Central + RBD 12301 Colegio Español de Viña del Mar, más
5 EE adicionales para cubrir los tres estados). Fondo **efectivo**: se parte del propio
elemento y se compone hacia arriba hasta el primer opaco. Fórmula WCAG 2.1.

| Zona | fg / bg | px / peso | Ratio antes | Ratio ahora | Exige | Veredicto |
|---|---|---|---|---|---|---|
| `.s100-ext-it` bajo, fila nacional | `#D2112D` / `#FCFAF2` | 12 / 700 | 3,93 | **5,21** | 4,5 | OK |
| `.s100-ext-it` sobre, fila nacional | `#1E6EA9` / `#FCFAF2` | 12 / 700 | 3,33 | **5,21** | 4,5 | OK |
| `.s100-ext-it` bajo, resto | `#D2112D` / `#FFFDF7` | 12 / 700 | 4,04 | **5,35** | 4,5 | OK |
| `.s100-ext-it` sobre, resto | `#1E6EA9` / `#FFFDF7` | 12 / 700 | 3,42 | **5,35** | 4,5 | OK |
| `.s100-ext-it` neutro, resto | `#5F6A78` / `#FFFDF7` | 12 / 700 | 3,45 | **5,41** | 4,5 | OK |
| `.ee-st` bajo | `#D2112D` / `#F7FBFE` | 12 / 700 | 4,41 | **5,23** | 4,5 | OK |
| `.ee-st` sobre | `#1E6EA9` / `#F7FBFE` | 12 / 700 | 4,41 | **5,23** | 4,5 | OK |
| `.ee-st` neutro | `#5F6A78` / `#F7FBFE` | 12 / 700 | 4,41 | **5,28** | 4,5 | OK |
| `.gse-sec-foot` | `#6B7780` / `#FFFFFF` | 14 / 400 | 4,59 | 4,59 | 4,5 | OK |
| `.cmp-nota-ee` | `#6B7780` / `#FFFDF7` | 14 / 400 | 4,51 | 4,51 | 4,5 | OK |
| `.cmp-cm`, chips de territorio | `#6B7780` / `#FFFFFF` | 14 / 400 | 4,59 | 4,59 | 4,5 | OK |
| **`.cmp-cm`, chip de establecimiento** | `#6B7780` / `#F7FBFE` | 14 / 400 | 4,41 | **4,41** | 4,5 | **FALLA** |
| `.s100-seg span` sobre `--st-neutro` | `#FFFFFF` / `#7E8A99` | 14 / 700 | 3,51 | 3,51 | 4,5 | excepción §3.4 |
| `.s100-seg span` sobre `--alerta` | `#FFFFFF` / `#EE2D49` | 14 / 700 | 4,11 | 4,11 | 4,5 | excepción §3.4 |
| `.s100-seg span` sobre `--destaca` | `#FFFFFF` / `#2A8FD9` | 14 / 700 | 3,48 | 3,48 | 4,5 | excepción §3.4 |

Los "ratio antes" de las tres primeras zonas se midieron con el **mismo instrumento**
sobre el motor de `HEAD~` antes de tocar nada, no se copiaron del encargo; reproducen
sus cifras de §1 (3,93 / 4,04 / 3,33 / 3,42 / 3,45).

**El criterio "0 fallas en las cinco zonas" no se cumple, por una causa ajena a este
encargo.** `.cmp-cm` da 4,41 dentro del chip de establecimiento porque `--gris`
(`#6b7780`), el gris de interfaz, cae sobre `#F7FBFE`, el teñido que s29 introdujo para
las superficies de establecimiento. Ni el color ni el fondo los toca s29c: la misma
falla está en el motor de `HEAD~`, medida arriba. Se corrigió el elemento vecino
(`.ee-st`, que pasó de 4,41 a 5,23) porque el encargo lo autoriza; `.cmp-cm` no es
texto de estado y queda fuera de los dos lugares que la Fase 1 permite tocar. Está
documentada como §5.1 de la decisión, con las dos salidas posibles y una recomendación,
y **es decisión del titular**. La auditoría destapó además que la misma causa afecta a
`.td-ee-k`, `.td-ee-rbd` y `.ee-nd` (4,41 sobre `#F7FBFE`; 4,39 sobre `#FCFAF2`), que no
estaban entre las cinco zonas del criterio.

Un hallazgo menor corregido dentro de esta fase: el comentario del `:root` afirmaba
que `--cream-200` es "el peor fondo del motor". Es falso —`#D4E4F1` y `#eee5cf` son más
oscuros— y se reescribió con los fondos reales sobre los que estos tokens caen.

### 8.4 Regla de etiquetado de s29 — intacta

En **carga** a 1200px y a 430px, comparador poblado:

| Ancho | Barras | Etiquetas dentro | En la tira | Cortadas | % duplicados |
|---|---|---|---|---|---|
| 1200px | 40 | 44 | 56 | **0** | **0** |
| 430px | 40 | 0 | 100 | **0** | **0** |

A 430px ninguna etiqueta cabe dentro y las 100 bajan enteras a la tira: es exactamente
lo que la regla de s29 promete.

**El re-etiquetado en vivo al redimensionar sigue sin poder verificarse**, y ahora se
sabe por qué. Al cambiar el viewport sin recargar, las 44 etiquetas internas se quedan
puestas y quedan recortadas por el `overflow:hidden` de `.s100`. La causa está medida:
en este entorno la pestaña corre con `document.hidden === true` y **`ResizeObserver` no
dispara ni una sola vez** —ni el callback inicial— comprobado con un observador de
prueba sobre un `div` al que se le cambia el ancho. No es un defecto del motor: es la
limitación que el §3.4 del registro de s29 ya anticipaba ("pide un navegador con la
pestaña visible"). Queda como pendiente de verificación, no como bug.

Por la misma razón (pane no compositando) no se pudo capturar pantallazo del motor
regenerado a 1280px; la evidencia de esta sección son las mediciones, no imágenes.

### 8.5 Panel adversarial sobre el diff de la Fase 1

Se corrió una auditoría independiente de solo lectura (4 lentes: cumplimiento de
invariantes, regresión visual y especificidad CSS, aritmética de contraste, corrección
del JSX y a11y) con refutación adversarial de cada hallazgo. 15 agentes, 11 hallazgos
brutos, **0 confirmados**: todos refutados por no ser regresión (las reglas señaladas
son byte-idénticas a `HEAD`), por caer fuera de los dos lugares autorizados, o por ser
exactamente lo que el mockup aprobado dibuja. El único hallazgo que sí prosperó fue la
imprecisión del comentario sobre `--cream-200`, ya corregida.

Comprobaciones puntuales que la auditoría dejó cerradas:

- No existe ningún selector `.bajo` / `.neutro` / `.sobre` sin calificar en la
  plantilla, así que las clases nuevas de `.ee-st` no colisionan con nada.
- `k` en `CeldaEE` solo puede valer `bajo|neutro|sobre` (se deriva de `sigdifgru` con
  un ternario cerrado y el retorno de "sin dato" ocurre antes), así que no hay
  `"ee-st undefined"` posible. Verificado en pantalla: los tres estados renderizan
  `rgb(210,17,45)`, `rgb(95,106,120)` y `rgb(30,110,169)`.
- `medirTexto()` deriva la fuente del CSS de `.s100-seg span`, no de `.ee-st`, y
  `.cmp-table` es `table-layout:fixed`: poner `.ee-st` en negrita no puede alterar el
  ancho de columna ni, por tanto, la regla de etiquetado.
- `s.c` sigue usándose para el `background` del segmento; solo se retiró del `color`.

## 9. Decisiones tomadas dentro del margen del encargo (s29c)

1. **Fallback de `.ee-st` en `--st-neutro-txt`, no en `--gris`.** La regla base la
   fija un token que cumple AA, de modo que si alguna vez faltara la clase de estado el
   texto siga siendo legible en vez de caer al gris que no llega. En la práctica
   `CeldaEE` siempre pone la clase.
2. **Convención de normalización del payload, escrita.** Ver §8.2. Sin ella el chequeo
   de fidelidad no es reproducible entre sesiones.
3. **Segundo pendiente en el documento de decisión.** El hallazgo de `--gris` sobre los
   fondos teñidos se registró como §5.1 en vez de dejarlo solo en este log: es una falla
   de AA viva en el motor y merece estar donde se buscan las decisiones, no en un
   andamio.
4. **Orden de las fases 4 y 5.** El encargo pone el `push` en la Fase 4 y el log en la
   Fase 5. Se escribió el log **antes** de empujar, para que el `push` lleve de verdad
   "todo lo acumulado de la sesión" en un solo empujón en vez de dejar el registro
   fuera y tener que empujar dos veces.

## 10. Pendientes que s29c deja anotados (no ejecutados)

- **`--gris` sobre los fondos teñidos de s29** (`.cmp-cm`, `.td-ee-k`, `.td-ee-rbd`,
  `.ee-nd`): 4,39–4,41, bajo AA. Decisión del titular; ver §5.1 de
  `20260910_decision_contraste_texto_estado.md`.
- **Marca de "base pequeña"**: el umbral es una decisión metodológica sin fijar.
- **Despliegue a `docs/index.html`**: gate visual del titular, sesión aparte.
- **Re-etiquetado en vivo al redimensionar**: pide una pestaña visible (§8.4).
- **Tooltip "vs evaluación anterior"**: de `title` a body (heredado de s28).
- **Rama `feat/contrato-contexto`** con 2 commits locales sin push: no se tocó.

---

## 11. Errores del asistente de análisis (s29) — insumo de la §15 del traspaso

Registro en el momento en que se detectan, según POLITICA 0.5. Estos son errores
del asistente de análisis (el que redacta encargos y mockups), no del ejecutor.

| # | Error | Dónde se manifestó | Patrón |
|---|---|---|---|
| 1 | Puntajes con decimal inventados en el mockup (`78,4`, `76,0`) cuando los 354.007 valores de `prom` del payload son enteros. | `mockup_comparador_ee_nacional.html`, detectado por el ejecutor en §3.5.2 | Inferencia sobre datos no leídos: se ilustró una cifra plausible en vez de verificar el tipo del dato antes de dibujarlo. Es el mismo patrón registrado en el traspaso s28. |
| 2 | Regla de detención §0.2 del encargo s29c fijada sobre un SHA-256 no reproducible: se copió el hash del log de s29 sin su receta de normalización, que ese log no registraba. | `encargo_claude_code_idps_contraste_texto_estado_s29c.md`, detectado por el ejecutor en §8.2 | Se convirtió en criterio bloqueante un valor que no se había verificado como reproducible. Una regla de detención debe poder ejecutarse con lo que el encargo entrega. |
| 3 | Atribución errónea de selector en el §1 del encargo s29d: la falla de 3,53 sobre `#D4E4F1` se adjudicó a las casillas GSE activas (`.gfb.on`), que usan `--foco` y ya cumplían (4,97). El caso real era `.eo-m` con `.estab-opt:hover`. | `encargo_claude_code_idps_gris_accesible_s29d.md` §1, detectado por el ejecutor en §14.3 | Se nombró un selector por inferencia visual (el fondo azul claro se asoció a la casilla activa) en vez de leerlo del instrumento que produjo la medición. El fondo y el ratio eran correctos; el culpable, no. |

Corrección adoptada para el punto 2: la convención de normalización queda escrita en
§8.2 de este log y se cita desde los próximos encargos, en vez de repetir el hash.

---

# Continuación de la sesión — s29d (2026-09-10)

> Misma sesión s29, cuarto encargo:
> `50_documentacion/activa/encargos/encargo_claude_code_idps_gris_accesible_s29d.md`.
> Resuelve el pendiente §5.1 de la decisión del 2026-09-10, con una salida distinta a
> la que ese documento recomendaba. Alcance: 100 % presentación. No se tocó el pipeline
> (31–34) ni `idps_largo.parquet`. No se desplegó a `docs/`. No se tocó
> `feat/contrato-contexto`.

## 12. Inventario de commits de s29d

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 14 | `d440ff2` | 1 — `fix(motor): --gris accesible en todos los fondos del motor` | `30_procesamiento/35_motor_template.html` |
| 15 | `ac1e2ea` | 2 — `docs(decision): cierra §5.1 con --gris accesible y anota la excepcion de los glifos` | `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` |
| 16 | `1225735` | 3 — `build(motor): regenera el motor con --gris accesible` | `40_salidas/motor_idps.html` |
| 17 | (este) | 4 — `docs(log): registro de s29d y errores del asistente de la sesion` | este log + la §5.3 de la decisión |

## 13. Qué se cambió

Una sola declaración: en `:root`, `--gris` pasa de `#6b7780` a `#5C666E`.

Medido: `#6b7780` = H 205,71° · S 8,94 % · L 46,08 %; `#5C666E` = H 206,67° · S 8,91 %
· L 39,61 %. La afirmación del encargo de que conserva "la misma H y S" es **casi**
exacta: S coincide en la práctica (0,03 pp) y H se desplaza 0,96°, diferencia de
redondeo a 8 bits. Lo que baja de verdad es la luminancia relativa, de 0,1788 a 0,1290.

`--gris` sigue siendo **un** token (invariante 5): no se creó ningún paralelo ni se
sustituyó `var(--gris)` por un literal en ningún selector. Los ~60 selectores que lo
usan heredan el cambio solos. Ni la paleta de ESTADO ni sus tokens `-txt` ni los
`--ind1..4` se tocaron; verificado en el motor generado, donde `--alerta` `#EE2D49`,
`--destaca` `#2A8FD9`, `--st-neutro` `#7E8A99`, `--alerta-txt` `#D2112D`,
`--destaca-txt` `#1E6EA9`, `--st-neutro-txt` `#5F6A78`, `--ind1` `#3858A3` e `--ind4`
`#AACB58` siguen intactos.

## 14. Chequeos de s29d (valores observados)

### 14.1 Regla de detención 1 — verificada ANTES de aplicar el cambio

La regla obliga a parar si algún uso de `--gris` cae sobre fondo oscuro y el cambio lo
empeora. Se comprobó empíricamente sobre el motor de `bbe77e3`, recorriendo cada
elemento visible cuyo color computado fuese exactamente `#6b7780` y clasificando su
fondo efectivo por luminancia:

| Pantalla | Elementos en `--gris` | Sobre fondo oscuro **con texto** |
|---|---|---|
| Panorama territorial | 13 grupos | **0** |
| Panorama IDPS por establecimiento | 4 grupos | **0** |
| Comparador poblado | 29 grupos | **0** |
| Modal "agregar entidad" | 25 grupos | **0** |

Los únicos elementos en `--gris` sobre fondo oscuro son **muestras de color sin
texto**: `.th-sw` (sobre `#3858A3`, `#4BA560`, `#61BDC6`, `#AACB58`) y los `<i>` de
`.leyenda` (sobre `#EE2D49`, `#7E8A99`, `#2A8FD9`). Solo pintan `background` y heredan
un `color` que nunca usan. Dentro del banner azul (`.cmp-chrome`) no hay **ni un** uso
de `--gris`: sus textos son `--cream` con opacidad. La regla **no se dispara**.

Trampa de medición que hubo que resolver antes: la pestaña del navegador corre con
`document.hidden === true`, así que las transiciones de entrada no avanzan y el modal
queda congelado en `opacity:0`. Medido así, `.modal-tab` aparecía como "gris sobre
fondo oscuro" —un falso positivo que habría disparado la regla de detención sin
motivo—. Se forzó el estado final de las animaciones antes de medir.

### 14.2 Verificación exhaustiva contra TODOS los fondos del CSS

No solo los 7 que lista el encargo: se extrajeron del CSS de la plantilla todas las
declaraciones `background`/`background-color`, resolviendo los `var(--…)` contra el
`:root`. Resultan **19 fondos distintos, 15 claros y 4 oscuros**. Con `#5C666E`:

| Fondo | L | Antes | Después |
|---|---|---|---|
| `#D4E4F1` hover de `.estab-opt` | 0,758 | 3,53 | **4,51** |
| `#eee5cf` badge | 0,787 | 3,66 | **4,68** |
| `#FBE3E6` `--alerta-bg` | 0,812 | 3,77 | **4,81** |
| `#f4e9cc` `--cream-200` | 0,819 | 3,80 | **4,85** |
| `#f3ecd6` | 0,839 | 3,89 | **4,97** |
| `#E2F0FB` `--destaca-bg` | 0,855 | 3,95 | **5,05** |
| `#EDF0F3` relleno del glifo neutro | 0,868 | 4,01 | **5,13** |
| `#f3f0e8` | 0,872 | 4,03 | **5,15** |
| `#f4f1e8` `.nota` / pista de barra | 0,880 | 4,06 | **5,19** |
| `#eef3f7` `.ficha-explain` | 0,890 | 4,11 | **5,25** |
| `#FFF6E0` `--cream` | 0,926 | 4,26 | **5,45** |
| `#FCFAF2` fila nacional | 0,955 | 4,39 | **5,61** |
| `#F7FBFE` fila EE | 0,959 | 4,41 | **5,64** |
| `#fffdf7` `--panel` | 0,982 | 4,51 | **5,77** |
| `#ffffff` `--paper` | 1,000 | 4,59 | **5,86** |

**0 fondos claros donde `#5C666E` quede bajo 4,5.** Peor caso: 4,51.

### 14.3 Corrección de una atribución del encargo

El §1 del encargo atribuye la falla de 3,53 sobre `#D4E4F1` a las **casillas GSE
activas** (`.gfb.on`). No es así: `.gfb.on` usa `color:var(--foco)` `#0062A0` y mide
**4,97**, es decir ya cumplía y el cambio no la toca. El fondo y el ratio sí existen,
pero corresponden a `.eo-m` —la línea de metadatos de cada establecimiento en el
buscador— cuando su contenedor `.estab-opt` está en `:hover`. El cambio la corrige
igual, de 3,53 a 4,51. La fila de la tabla era válida en sustancia y errónea en el
selector.

### 14.4 Build y fidelidad del payload

`run_all(only = 35L)` en 4,1 s, sin error y sin warning: `grep -inE "warn|error|aviso|
fail|problema"` sobre las 73 líneas de salida no devuelve ninguna coincidencia. Bloque
7 idéntico a la línea base (16 regiones, 9.136 establecimientos, 91.596 unidades de
grilla, 366.384 / 557.898 / 662.514 filas, JSON 59,5 MB → 4,41 MB, HTML 5,1 MB). Un
segundo `run_all` produce un archivo **byte-idéntico**: el paso 35 es determinista.

Verificación fuerte, diff de offsets del JSON descomprimido contra el motor de
`bbe77e3`:

```
bytes: 59.466.778  ==  59.466.778
offsets que difieren: []
```

**Cero.** Ni siquiera la fecha, porque ambos builds son del mismo día. SHA-256 con la
convención de §8.2 (`"fecha_generacion":"0000-00-00"`, UTF-8, sin salto final),
idéntico antes y después:

```
1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6
```

Como pedía §4 del encargo, no se reutilizó el hash de s29c, que no era reproducible.

### 14.5 Auditoría de todo el texto visible

Método: se recorren los elementos con **texto propio** (nodo de texto directo), se
compone el fondo efectivo hacia arriba con el alfa y la `opacity` de cada capa, y se
calcula el ratio con la fórmula de WCAG 2.1. Umbral 4,5 para texto normal y 3,0 para
texto grande (≥24 px, o ≥18,66 px en negrita).

| Escenario | Nodos agrupados | En `--gris` | Fallas de `--gris` | Peor `--gris` |
|---|---|---|---|---|
| Panorama territorial 1200px | 40 | 9 | **0** | 4,85 |
| Comparador poblado 1200px | 58 | 21 | **0** | 4,85 |

**Criterio de la Fase 3 cumplido: 0 fallas atribuibles a `--gris`**, frente a 10 en la
pantalla del comparador antes del cambio.

Los dos falsos positivos que el encargo advertía se disuelven al componer el alfa,
como avisaba: el botón de nivel inactivo del banner (`.lvl-b`, crema al 70 % sobre
`rgba(255,246,224,.12)` encima del azul) compone a `#BEC4BD` sobre `#27516C` y da
**4,81**; la banda "no se promedia" también pasa. Ninguno es falla.

Fallas restantes, **todas ajenas a `--gris`**:

| Zona | Ratio | Estado |
|---|---|---|
| `.s100-seg span` (etiqueta blanca dentro de la barra) | 3,48 / 3,51 / 4,11 | excepción §3.4 de la decisión |
| `.ee-gl` (glifos ▼ = ▲) | 3,37 / 3,07 / 3,00 | excepción §3.5, nueva en este encargo |
| `.chip.al` / `.chip.de` (panorama territorial) | 3,37 / 3,00 | **hallazgo nuevo**, §5.3 (a) |
| Vista histórica: `.ybar-val`, `.ybar-sig`, `.hist-trend` | 1,04 – 4,40 | **hallazgo nuevo**, §5.3 (b) |
| `.ybar-yr` en columna sin dato, `.sw-line.mm` (atenuados) | 2,13 / 2,42 | **hallazgo nuevo**, §5.3 (c) |

Los tres hallazgos nuevos quedan escritos en la §5.3 de la decisión, no solo aquí: son
fallas vivas y deben estar donde se buscan las decisiones. Ninguno lo empeora s29d; los
dos atenuados por `opacity` incluso **mejoran** (1,94 → 2,13 y 2,15 → 2,42), porque
oscurecer el color base oscurece también el resultado de componerlo sobre blanco.

### 14.6 Regla de etiquetado de s29 — intacta

En **carga** a 1200px y a 430px, comparador poblado:

| Ancho | Barras | Dentro | En la tira | Cortadas | % duplicados |
|---|---|---|---|---|---|
| 1200px | 40 | 44 | 56 | **0** | **0** |
| 430px | 40 | 0 | 100 | **0** | **0** |

Sigue sin poder verificarse el re-etiquetado **en vivo** al redimensionar, por la misma
razón medida en §8.4: la pestaña corre oculta y `ResizeObserver` no dispara.

### 14.7 Panel adversarial sobre el cambio

Auditoría independiente de solo lectura, 4 lentes (regla de detención 1, invariantes y
alcance, aritmética de contraste completa, regresión por tocar un token usado en ~60
selectores) con refutación adversarial de cada hallazgo. 15 agentes, 11 hallazgos
brutos, **0 confirmados**. Los refutadores recalcularon por su cuenta el compositing de
`.ybar-yr` (1,94 → 2,13) y confirmaron que el cambio **mejora** ese caso, y
corroboraron de forma independiente la corrección de la atribución de `.gfb.on`.

## 15. Decisiones tomadas dentro del margen del encargo (s29d)

1. **Forzar el estado final de las animaciones antes de medir.** Sin eso el modal se
   mide en `opacity:0` y aparece un falso "gris sobre fondo oscuro" que habría
   disparado la regla de detención 1 sin motivo.
2. **Ampliar la verificación a los 19 fondos del CSS**, no a los 7 de la tabla del
   encargo. Es lo que convierte "0 fallas en lo que miré" en "0 fallas donde `--gris`
   puede caer".
3. **Registrar los hallazgos nuevos en la decisión (§5.3) y no solo en este log.** Es
   la misma razón que en §9.3: un andamio no es donde se buscan las decisiones.
4. **Incluir la §5.3 de la decisión en el commit de la Fase 4.** El encargo asigna a
   esa fase solo el log; se añadió el documento de decisión porque los hallazgos que
   la Fase 3 destapó son parte del mismo registro y separarlos en dos commits habría
   dejado el log citando una sección que aún no existía.

## 16. Pendientes tras s29d

- **§5.3 (a)** `.chip.al` / `.chip.de` a 3,37 y 3,00: texto de estado sin excepción que
  lo cubra. Salida natural: usar los tokens `-txt` en el color del chip (4,81 y 5,05).
- **§5.3 (b)** Vista histórica: `.ybar-val`, `.ybar-sig` y `.hist-trend` entre 1,04 y
  4,40. Toca las paletas de INDICADOR y de ESTADO; decisión del titular.
- **§5.3 (c)** `.ybar-yr` de columna sin dato y `.sw-line.mm`: se arreglan subiendo la
  `opacity`, no el color.
- **§5.2** Marca de "base pequeña": umbral metodológico sin fijar.
- **Despliegue a `docs/index.html`**: gate visual del titular, sesión aparte.
- **Re-etiquetado en vivo al redimensionar**: pide una pestaña visible.
- **Tooltip "vs evaluación anterior"**: de `title` a body (heredado de s28).
- **Rama `feat/contrato-contexto`** con 2 commits locales sin push: no se tocó.

---

# Continuación de la sesión — s29e (2026-09-10)

> Misma sesión s29, quinto y último encargo:
> `50_documentacion/activa/encargos/encargo_claude_code_idps_chips_panorama_s29e.md`.
> Cierra los tres hallazgos que la §5.3 de la decisión dejó abiertos. Alcance: 100 %
> presentación, usando tokens que ya existían. No se tocó el pipeline (31–34) ni
> `idps_largo.parquet`. No se desplegó a `docs/`. No se tocó `feat/contrato-contexto`.

## 17. Inventario de commits de s29e

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 18 | `5d508f7` | 1 — `fix(motor): chips de estado del panorama con los tokens de texto` | `30_procesamiento/35_motor_template.html` |
| 19 | `40a279c` | 2 — `docs(decision): cierra §5.3 — chips corregidos, atenuados exentos, historica al backlog` | decisión `20260910_…md` |
| 20 | `ec22558` | 3 — `build(motor): regenera el motor con los chips de estado accesibles` | `40_salidas/motor_idps.html` |
| 21 | `4550d2f` | corrección — `docs(motor): actualiza el inventario de usos de los tokens de texto` | plantilla + decisión + motor |
| 22 | (este) | 4 — `docs(log): registro de s29e` | este log + decisión §5.4 + el encargo s29e |

## 18. Qué se cambió

Dos declaraciones. `.chip.al` y `.chip.de` dejan el token de **barra** y toman el de
**texto**; los fondos `-bg` no se tocan y **ningún token cambia de valor**:

```
.chip.al{background:var(--alerta-bg);  color:var(--alerta-txt);}
.chip.de{background:var(--destaca-bg); color:var(--destaca-txt);}
```

El razonamiento es el de §5.3 (a): el chip es **texto** (12 px, peso 600), no un glifo,
así que no le sirve el argumento de componente gráfico de §3.5. Aquí el color **es** el
texto.

## 19. Chequeos de s29e (valores observados)

### 19.1 Cifras de los chips — y un déficit que no se cierra

Medido en el motor, colores computados en navegador:

| Chip | Color antes | Color después | Fondo | Antes | Después | Exige | Veredicto |
|---|---|---|---|---|---|---|---|
| `.chip.al` | `--alerta` `#EE2D49` | `--alerta-txt` `#D2112D` | `#FBE3E6` | 3,374 | **4,466** | 4,5 | **no llega** |
| `.chip.de` | `--destaca` `#2A8FD9` | `--destaca-txt` `#1E6EA9` | `#E2F0FB` | 3,000 | **4,689** | 4,5 | cumple |
| `.chip.nt` | `#6a5a2f` (sin cambio) | — | `#eee5cf` | 5,373 | 5,373 | 4,5 | **ya cumplía** |

**Veredicto sobre `.chip.nt`, que el encargo pedía expresamente:** da **5,373** y por
tanto **ya cumplía**; se deja tal cual, sin tocar. La misma pareja de colores
(`#6a5a2f` sobre `#eee5cf`) la usa `.badge`, con el mismo 5,373: tampoco necesita nada.
`.badge.foco` (blanco sobre `--foco`) da 6,452.

**El déficit.** `.chip.al` se queda en **4,466** y no alcanza el 4,5 de AA: le faltan
**0,034**. El encargo daba por esperados 4,81 y 5,05 y pedía confirmarlos midiendo; la
medición los desmiente. La aritmética se validó con dos controles conocidos (`#000`
sobre `#fff` = 21,00 y `#777` sobre `#fff` = 4,48) y se comprobó dos veces: por cálculo
propio y sobre el motor cargado en el navegador.

Cerrar esos 0,034 exige tocar `--alerta-txt` o `--alerta-bg`, que es exactamente lo que
la regla de detención 1 de este encargo prohíbe. Así que **no se tocó** y el déficit se
reporta, con las dos vías mínimas ya calculadas y verificadas:

| Vía | Cambio | Resultado sobre `--alerta-bg` | Efecto en el resto |
|---|---|---|---|
| **(i)** recomendada | `--alerta-txt` `#D2112D` → `#D1112D` (un escalón, H y S idénticas) | **4,500** | mejora: 4,54 sobre `--cream-200`, 5,10–5,39 en el resto |
| **(ii)** | `--alerta-bg` `#FBE3E6` → `#FBE5E7` | **4,526** | toca un fondo de la paleta institucional |

Queda escrito además en el CSS, junto a la propia declaración, para que quien lea el
selector se entere del déficit sin ir a buscarlo.

### 19.2 De dónde salió el "4,81 y 5,05" — error del ejecutor, no del asistente

Estos dos números **no corresponden a `--alerta-txt` y `--destaca-txt`**: son los de
`--gris` `#5C666E` sobre esos mismos dos fondos, que están en la tabla §14.2 de este
log (`#FBE3E6` → 4,81; `#E2F0FB` → 5,05). Al redactar la §5.3 (a) de la decisión en
s29d se copiaron dos celdas de la **columna equivocada** de esa tabla, y el encargo
s29e heredó la cifra.

Es un error **del ejecutor**, no del asistente de análisis, así que no entra en la §11.
Se registra aquí. El agravante es que la cifra correcta ya estaba calculada desde s29c:
en la tabla de aquel encargo, `--alerta-txt` sobre `--alerta-bg` figuraba como **4,466**
y marcada explícitamente "solo AA-large". Es decir: el dato bueno estaba en el
repositorio y se escribió encima uno malo.

Patrón, para el traspaso: **al citar una cifra de una tabla propia, verificar que la
columna es la que se cree, sobre todo cuando la tabla compara varios colores contra los
mismos fondos.** Recalcular en vez de copiar cuesta segundos y no arrastra el error a
los encargos siguientes.

### 19.3 Build y fidelidad del payload

`run_all(only = 35L)` sin error y sin warning: `grep -inE "warn|error|aviso|fail|
problema"` sobre la salida completa no devuelve ninguna coincidencia. Bloque 7 idéntico
a la línea base (16 regiones, 9.136 establecimientos, 91.596 unidades de grilla,
366.384 / 557.898 / 662.514 filas, JSON 59,5 MB → 4,41 MB, HTML 5,1 MB).

Verificación fuerte contra el motor de `f429b5e`:

```
bytes: 59.466.778  ==  59.466.778
offsets que difieren: []
```

**Cero.** SHA-256 con la convención de §8.2, idéntico antes y después:

```
1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6
```

### 19.4 Auditoría de todo el texto visible

Mismo método que en s29d: elementos con texto propio, fondo efectivo compuesto hacia
arriba con alfa y `opacity` de cada capa, fórmula WCAG 2.1, animaciones forzadas a su
estado final porque la pestaña corre oculta.

| Escenario | Nodos | Fallas |
|---|---|---|
| Panorama territorial 1200px | 40 | `.s100-seg span` (3,483 / 3,510 / 4,112) · `.chip.al` (4,466) |
| Comparador poblado 1200px | 58 | `.s100-seg span` (3,483 / 3,510 / 4,112) · `.ee-gl` (3,069 / 3,374) |

**Criterio de la Fase 3:** se cumple en el comparador, donde lo único que queda son las
dos excepciones escritas —§3.4 la etiqueta blanca dentro de la barra y §3.5 los glifos
`.ee-gl`—. En el panorama territorial queda además `.chip.al` a 4,466, que **no es un
hallazgo nuevo** sino el déficit de la Fase 1, ya reportado arriba. Ninguna otra cosa
aparece: `.chip.de` y `.chip.nt` pasan, y lo exento en §5.3 (c) no se dibuja en estos
dos escenarios.

### 19.5 Regla de etiquetado de s29 — intacta

| Ancho | Barras | Dentro | En la tira | Cortadas | % duplicados |
|---|---|---|---|---|---|
| 1200px | 40 | 44 | 56 | **0** | **0** |
| 430px | 40 | 0 | 100 | **0** | **0** |

### 19.6 Nota de instrumentación

La tabla de la §11 llegó con su tercera fila separada del cuerpo por una línea en
blanco, lo que en markdown corta la tabla y deja esa fila como texto suelto. Se quitó
la línea en blanco: el contenido de la fila no se tocó, solo se reunió con la tabla.

Durante la auditoría, la pantalla activa saltaba sola a "Panorama IDPS por
establecimiento" entre una llamada y la siguiente, lo que produjo una medición vacía
(15 nodos, 0 fallas) que habría sido un falso "todo en orden". Se resolvió haciendo
cada medición en **una sola** llamada autocontenida —cambiar de pantalla, poblar y
medir sin volver— y verificando la pantalla activa y el número de entidades dentro del
propio resultado.

### 19.7 Hallazgo nuevo: `.ancla.al` y `.ancla.de` repiten el defecto de los chips

La auditoría destapó que el componente `<Ancla/>` de la ficha de establecimiento tiene
**exactamente** el mismo defecto que la Fase 1 corrige en los chips, con las mismas dos
parejas de colores:

| Elemento | Color | Fondo | Ratio |
|---|---|---|---|
| `.ancla.al` | `--alerta` `#EE2D49` | `--alerta-bg` `#FBE3E6` | **3,374** |
| `.ancla.de` | `--destaca` `#2A8FD9` | `--destaca-bg` `#E2F0FB` | **3,000** |

Es texto de 14 px —`"vs GSE ▼ -13 · sig."`— que se usa en dimensión y subdimensión, ahí
donde no hay dato de GSE para dibujar barra. **No se corrigió**: el encargo especificaba
dos declaraciones exactas, se declaraba "sin decisiones nuevas", y el ancla vive en la
ficha, una tercera pantalla fuera de los dos escenarios que este encargo mandaba
auditar. Queda anotado como §5.4 de la decisión, con su salida —la misma de §5.3 (a)—
y la recomendación de resolverlo junto con el déficit de `.chip.al`, porque es el mismo
problema en dos sitios y una sola vía (i) los cierra a la vez.

Por qué no lo vio la auditoría de s29d: aquella recorrió el panorama territorial y el
comparador, y el ancla solo se dibuja en la ficha. Es el límite conocido de auditar por
escenarios en vez de por componentes.

### 19.8 Corrección de una afirmación que esta misma sesión dejó obsoleta

El comentario del `:root` declaraba que los tokens `-txt` se usan "SOLO ... (tira
externa y texto de estado de la fila EE)", y la §3.3 de la decisión se titulaba "en dos
lugares, y solo en esos dos". Con la Fase 1 pasaron a ser **tres**. La restricción de
fondo —solo texto pequeño sobre fondo claro— sigue intacta: lo que había quedado
obsoleto era el **inventario**, no el invariante.

Se corrigieron los dos sitios (commit `4550d2f`) y ambos llevan ahora la lista al día
más la instrucción de mantenerla. Es la misma clase de deriva que produjo el error de
los 4,81/5,05 descrito en §19.2: un dato correcto en su momento que nadie actualizó al
cambiar el código. El motor se regeneró; el payload no se movió (cero offsets, es un
comentario CSS fuera del JSON).

## 20. Decisiones tomadas dentro del margen del encargo (s29e)

1. **Aplicar la Fase 1 aunque no alcance AA.** El cambio sube `.chip.al` de 3,374 a
   4,466 y `.chip.de` de 3,000 a 4,689: es lo que el encargo pide y una mejora real.
   Detenerse habría dejado los chips en 3,37 y 3,00 sin ganar nada, ya que la única
   salida al déficit está fuera de este encargo por su propia regla de detención.
2. **Escribir el déficit en el CSS, no solo en los documentos.** Quien lea
   `.chip.al` tiene que enterarse ahí mismo de que ese selector no cumple y por qué.
3. **Reunir la tabla de la §11** (ver §19.6). Incluir la fila tal cual habría
   significado publicarla rota.
4. **Registrar el error del "4,81 y 5,05" fuera de la §11**, porque esa sección es
   explícitamente para errores del asistente de análisis y este es del ejecutor.

## 21. Pendientes tras s29e

- **Déficit de `.chip.al`** (4,466, faltan 0,034): decisión del titular entre la vía
  (i) `--alerta-txt` → `#D1112D` —recomendada— y la (ii) `--alerta-bg` → `#FBE5E7`.
  Ver §5.3 (a) de la decisión.
- **`.ancla.al` / `.ancla.de`** (§5.4): mismo defecto que los chips, 3,374 y 3,000, sin
  corregir por alcance. La vía (i) del punto anterior los cerraría junto con el chip.
- **Vista histórica de la ficha** (§5.3 (b)): al **backlog**. Pide mockup y aprobación,
  no un token.
- **§5.2** Marca de "base pequeña": umbral metodológico sin fijar.
- **Despliegue a `docs/index.html`**: gate visual del titular, sesión aparte.
- **Re-etiquetado en vivo al redimensionar**: pide una pestaña visible.
- **Tooltip "vs evaluación anterior"**: de `title` a body (heredado de s28).
- **Rama `feat/contrato-contexto`** con 2 commits locales sin push: no se tocó.

Cerrado por §5.3 (c): los dos usos atenuados por `opacity` quedan **exentos**, no
pendientes, con la condición de caducidad escrita en la decisión.

---

# Continuación de la sesión — s29f (2026-09-11)

> Misma sesión s29, sexto y último encargo:
> `50_documentacion/activa/encargos/encargo_claude_code_idps_cierre_contraste_y_deploy_s29f.md`.
> Cierra los dos déficits que s29e dejó medidos (§5.3 a y §5.4 de la decisión) y, con el
> gate visual del titular concedido el 2026-09-10, **despliega** a `docs/index.html`.
> No se tocó el pipeline (31–34) ni `idps_largo.parquet`. No se tocó
> `feat/contrato-contexto`.

## 22. Inventario de commits de s29f

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 23 | `65ced7f` | 1 — `fix(motor): --alerta-txt con margen sobre el fondo de alerta` | plantilla |
| 24 | `c157a05` | 2 — `fix(motor): desvio vs GSE de la ficha con los tokens de texto` | plantilla |
| 25 | `ea3b22c` | 3 — `build(motor): regenera el motor con el contraste cerrado` | `40_salidas/motor_idps.html` |
| 26 | `8ae932b` | 4 — `deploy(docs): publica el comparador de entidades y el contraste accesible` | `docs/index.html` |
| 27 | (este) | 5 — `docs(log): registro de s29f, cierre de contraste y despliegue` | log + decisión + `ESTADO.md` + encargo |

## 23. Qué se cambió

**Fase 1.** `--alerta-txt` pasa de `#D2112D` a **`#CE112C`**. H 351,3° → 351,4°, S 85,0 %
→ 84,8 %; solo baja la luminancia relativa, 0,1429 → 0,1370. Se descartó `#D1112D` —la
vía (i) que proponía la decisión— porque da 4,5003 sobre `--alerta-bg`, tres
diezmilésimas de margen. Se descartó tocar `--alerta-bg`, fondo institucional.
`--destaca-txt` no se toca: 4,689 ya cumple. Se retira del CSS la nota de déficit que
s29e dejó junto a `.chip.al`.

**Fase 2.** `.ancla.al` y `.ancla.de` pasan del token de barra al de texto. Fondos y
bordes intactos. El inventario de usos de los `-txt` en el `:root` pasa a cuatro.

## 24. Chequeos de s29f (valores observados)

### 24.1 La aritmética del encargo, verificada antes de aplicar

Después del error de s29e (4,81/5,05), la tabla del encargo se recalculó entera antes
de tocar nada, con dos controles conocidos (`#000`/`#fff` = 21,00; `#777`/`#fff` =
4,478). **Los siete valores coinciden al cuarto decimal.** Se añadieron seis fondos
claros más que el encargo no lista; `#CE112C` pasa en todos los que el token usa. Los
dos donde no llega (`#D4E4F1` 4,32 y `#eee5cf` 4,48) son fondos sobre los que
`--alerta-txt` **no** se dibuja en ningún sitio.

### 24.2 Regla de detención 1 — cada uso de `--alerta-txt`, antes y después

Medido en el motor cargado, con el token sobreescrito en vivo antes de commitear:

| Uso | Fondo | `#D2112D` | `#CE112C` |
|---|---|---|---|
| `.chip.al` | `--alerta-bg` `#FBE3E6` | 4,4661 | **4,6064** |
| `.s100-ext-it.ext-bajo` | fila nacional `#FCFAF2` | 5,2082 | **5,3718** |
| `.s100-ext-it.ext-bajo` | `--panel` `#FFFDF7` | 5,3507 | **5,5188** |
| `.ee-st.bajo` | fila EE `#F7FBFE` | 5,2314 | **5,3957** |
| `.ancla.al` (tras la Fase 2) | `--alerta-bg` `#FBE3E6` | 3,3742 (era `--alerta`) | **4,6064** |

Ninguno baja de 4,5; todos suben. La regla **no se dispara**.

### 24.3 Las anclas

| Elemento | Antes | Después | Dónde se midió |
|---|---|---|---|
| `.ancla.al` | 3,3742 | **4,6064** | RBD 12301 (25 anclas) |
| `.ancla.de` | 3,0000 | **4,6886** | Liceo Atenea, RBD 134 (el 12301 no dibuja ninguna) |

Barrido del patrón "color de barra sobre su `-bg`" en toda la plantilla: los únicos
selectores que lo repiten son los glifos `.ee-gl` (bajo/neutro/sobre), cubiertos por
§3.5 como componente gráfico. **No queda ningún otro.**

### 24.4 Build y fidelidad

`run_all(only = 35L)` sin error y sin warning (`grep -inE "warn|error|aviso|fail|
problema"` sobre la salida completa: ninguna coincidencia). Bloque 7 idéntico a la
línea base.

```
bytes: 59.466.778  ==  59.466.778
offsets que difieren: [38]      ← el dígito del día: 2026-09-10 → 2026-09-11
SHA-256 (convención §8.2):  1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6
```

Un solo offset, y es el permitido. **Ninguna cifra se movió.**

### 24.5 Auditoría de todo el texto visible — tres escenarios a 1200px

Mismo método: elementos con texto propio, fondo efectivo compuesto con alfa y `opacity`,
animaciones forzadas a su estado final.

| Escenario | Nodos | Fallas | Cubiertas por |
|---|---|---|---|
| A · Panorama territorial | 40 | `.s100-seg span` 3,483 / 3,510 / 4,112 | §3.4 |
| B · Comparador poblado | 58 | `.s100-seg span` (ídem) · `.ee-gl` 3,069 / 3,374 | §3.4 · §3.5 |
| C · Ficha de establecimiento (vista actual) | 68 | ver abajo | **cuatro sin cubrir** |

En A los tres chips pasan: `.chip.al` **4,606**, `.chip.de` 4,689, `.chip.nt` 5,373.
En B los tres usos de `--alerta-txt` suben (5,372 / 5,519 / 5,396). **A y B cumplen el
criterio.**

**C es la pantalla que s29e nunca auditó**, y ahí el criterio **no se cumple**: además
de `.ancla.al` a 4,606 (resuelto), quedan cuatro fallas que ninguna excepción cubre.
Todas son **anteriores** a s29f; ninguna la empeora; dos las mejora sin llegar:

| # | Elemento | Color / fondo | Ratio | Nota |
|---|---|---|---|---|
| 1 | sufijo `"· sig."` del ancla, `opacity:.8` inline (JSX l.~771) | `--alerta-txt` @.8 / `#FBE3E6` | **3,718** (de 2,817) | a `opacity:1` daría 4,606 |
| 1 | ídem, rama sobre | `--destaca-txt` @.8 / `#E2F0FB` | **3,301** (de 2,380) | a `opacity:1` daría 4,689 |
| 2 | `.defn-title` con `ind.color` inline (JSX l.~707) | `--ind2` / `#fff` | **2,187** | `--ind3` 3,066 · `--ind4` 1,843 · `--ind1` 6,790 ✓ |
| 3 | `"▼ rojo"` / `"▲ azul"` de `.ficha-explain` (JSX l.~1290) | `--alerta` / `#eef3f7` | **3,681** | con `-txt` 5,025 |
| 3 | ídem | `--destaca` / `#eef3f7` | **3,118** | con `-txt` 4,872 |
| 4 | `"10%"` blanco sobre barra de dimensión | `#fff` / `#4C939A` | **3,531** | hermana de §3.4, sobre tono de indicador |

Los cuatro están en la **§5.5 de la decisión** con su salida y su costo. El más urgente
es el (1): está **dentro del mismo componente** que la Fase 2 acaba de corregir, y el
sufijo distingue "sig." de "n.s.", que sí es información. No se tocó porque es JSX y el
encargo fijaba dos declaraciones CSS.

### 24.6 Regla de etiquetado de s29 — intacta

| Ancho | Barras | Dentro | En la tira | Cortadas | % duplicados |
|---|---|---|---|---|---|
| 1200px | 40 | 44 | 56 | **0** | **0** |
| 430px | 40 | 0 | 100 | **0** | **0** |

### 24.7 Despliegue

`docs/index.html` es **copia byte a byte** de `40_salidas/motor_idps.html`: `cmp` sin
diferencias, md5 `f61ac9c596bec51518d20fbe9ef4e02e` en ambos, 5.383.820 bytes. Verificado
antes de commitear (regla de detención 4). Sustituye el `docs/index.html` del
2026-07-03 (md5 `3f1d6e98…`), que llevaba tres sesiones sin promoverse.

Servido `docs/` en local (`python3 -m http.server 8767`, entrada `docs-py` añadida a
`.claude/launch.json`, que no se versiona): título correcto, payload decodificado en
293 ms, las tres pantallas abren, `--alerta-txt` = `#CE112C` y `--gris` = `#5C666E` en
el documento servido, **cero errores de consola y cero errores JS en vivo**.

Lo publicado incorpora toda la línea s29: comparador de entidades, etiquetado adaptativo,
aviso único de EE sin ubicación, tokens de texto de estado, `--gris` accesible, chips y
anclas con los tokens de texto, `--alerta-txt` con margen.

### 24.8 Panel adversarial — no hubo

Se lanzó el panel de tres lentes (regla de detención 1, invariantes y alcance,
cobertura de la ficha) y **los tres agentes murieron por límite de sesión antes de
producir nada**. Este encargo descansa íntegramente en la auditoría directa del
ejecutor —aritmética recalculada con controles, medición en navegador de cada uso, y
barrido de los tres escenarios—. Queda dicho para que no se lea como verificado por
terceros lo que no lo fue.

## 25. Decisiones tomadas dentro del margen del encargo (s29f)

1. **Recalcular la tabla del encargo antes de aplicar**, por el precedente de s29e.
   Esta vez coincidió al cuarto decimal; el recálculo es barato y evita arrastrar
   errores a `docs/`.
2. **Medir `.ancla.de` en otro establecimiento.** El RBD 12301 no dibuja ninguna; en vez
   de dar por buena la aritmética se buscó uno que sí (RBD 134).
3. **Desplegar aunque la ficha tenga fallas sin cubrir.** El gate visual se concedió
   sobre el motor de esta línea, que ya las tenía; lo publicado es estrictamente mejor
   que lo que estaba en `docs/` desde julio, y ninguna de las cuatro la introdujo s29f.
   Retener el despliegue por defectos anteriores que el encargo no autorizaba a tocar
   habría sido decidir por el titular.
4. **No tocar el sufijo del ancla (§5.5-1)** pese a estar dentro del componente
   corregido: es JSX, no CSS, y el encargo fijaba dos declaraciones. Se reporta como lo
   más urgente de la lista.

## 26. Pendientes tras s29f (cierre de la línea)

- **§5.5 (1)** sufijo `"· sig."` del ancla a `opacity:.8`: 3,718 / 3,301. Quitar la
  opacidad da 4,606 / 4,689. JSX, una línea. **Lo más urgente.**
- **§5.5 (3)** `"▼ rojo"` / `"▲ azul"` de `.ficha-explain`: 3,681 / 3,118. Con los
  tokens `-txt` pasan. JSX inline.
- **§5.5 (2)** `.defn-title` con color de indicador sobre blanco: 2,187 / 3,066 / 1,843.
  Salida barata: título en `--tinta`, color solo en el punto.
- **§5.5 (4)** `"10%"` blanco sobre barra de dimensión: 3,531. Extender §3.4 o sacar la
  etiqueta.
- **§5.3 (b)** vista histórica: backlog, pide mockup.
- **§5.2** marca de "base pequeña": umbral metodológico sin fijar.
- Re-etiquetado en vivo al redimensionar: pide una pestaña visible.
- Tooltip "vs evaluación anterior" (s28). Rama `feat/contrato-contexto`: no se tocó.
