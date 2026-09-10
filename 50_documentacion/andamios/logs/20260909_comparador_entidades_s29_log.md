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
