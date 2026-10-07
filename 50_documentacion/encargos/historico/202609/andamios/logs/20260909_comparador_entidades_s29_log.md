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

---

## 27. Pendiente nuevo solicitado por el titular (2026-09-16)

> *Nota de s29g:* este apartado se redactó como "§25" y quedó sin commitear; el número
> ya lo llevaba "Decisiones tomadas dentro del margen del encargo (s29f)". Se renumera
> a §27 sin tocar una palabra del texto. El encargo s29g lo cita como "§25 del log".

**P-VISTA-TERRITORIAL — selector "Vista actual / Vista histórica" en el panorama
territorial.** Hoy el selector de vista existe solo en el Panorama IDPS por
establecimiento (banner de la ficha: "VISTA · Vista actual | Vista histórica"). El
titular pide el mismo par de vistas en el Panorama territorial, con el selector en el
mismo lugar del banner, junto al de NIVEL.

Advertencia de diseño (no es un pendiente trivial): la vista histórica de la ficha
grafica el **puntaje por año** de un establecimiento. Un territorio no tiene puntaje
propio (invariante de cero agregación), así que su vista histórica no puede ser la
misma curva. La forma compatible con el invariante es una **serie de repartos**: por
cada año con medición, el % (n) de establecimientos del territorio en cada estado vs su
GSE, es decir la barra apilada del panorama repetida en el eje del tiempo. Eso hay que
decidirlo y mockearlo antes de encargarlo; el pendiente queda anotado, no especificado.

Entra al backlog con su correlativo en el cierre de la sesión, según la regla de
mantención del propio backlog (las entradas nuevas se agregan al final en cada cierre).

---

## 28. Inventario de commits de s29g

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 28 | `ef9fdeb` | 1 — `fix(motor): el sufijo de significancia del ancla deja de atenuarse` | plantilla |
| 29 | `46e0e47` | 2 — `fix(motor): glosa de estados de la ficha con los tokens de texto` | plantilla |
| 30 | `cde1d95` | 3 — `docs(decision): cierra §5.5 (1) y (3) y agrupa el resto como problema de paleta de indicador` | decisión |
| 31 | `c63287b` | 4 — `build(motor): regenera el motor con el contraste de la ficha cerrado` | `40_salidas/motor_idps.html` |
| 32 | `2388e88` | 4 — `deploy(docs): republica con los ultimos arreglos de contraste` | `docs/index.html` |
| 33 | (este) | 5 — `docs(log): registro de s29g y pendiente de vista historica territorial` | log + `ESTADO.md` + encargo |

Rama `feat/contrato-contexto` y su log (`20260711_contrato_contexto_idps_log.md`, sin
seguimiento en el árbol) **no se tocaron**.

## 29. Qué se cambió

**Fase 1.** El `<span>` del sufijo `"· sig."` / `"· n.s."` de `<Ancla/>` pierde
`opacity:.8`; conserva `fontSize:"var(--fs-overline)"` y el texto byte a byte. No se
tocó el peso: la jerarquía la da el tamaño (12 px frente a los 14 px del número) y en
pantalla sigue leyéndose como sufijo (captura en §30.6). Cuatro líneas de comentario
en el JSX dejan la razón junto al código.

**Fase 2.** Los `<span>` `"▼ rojo"` / `"▲ azul"` de la glosa `.ficha-explain` pasan de
`var(--alerta)` / `var(--destaca)` a `var(--alerta-txt)` / `var(--destaca-txt)`. Es el
**quinto uso** de los tokens de texto y se anotó en el comentario del `:root` (regla del
propio comentario) y en §3.3 de la decisión. Comentario JSX `{/* */}` delante del `<div>`.

**Fase 3.** Decisión: encabezado de estado; §3.3 pasa a cinco entradas (la 4, anclas,
faltaba en la lista aunque s29f la anotó en el `:root` y en §5.4); §5.5 (1) y (3)
**resueltos** con cifras antes/después; §5.5 (2) y (4) **reagrupados** con §5.3 (b) en la
**§5.6 nueva**, "Texto sobre un color de la paleta de INDICADOR", con las tres salidas
para mockup y recomendación; §6 reversión con la entrada s29g. Dos hallazgos propios de
la fase, ambos en §5.6:

- **Corrección de atribución de §5.5 (4).** No es la "barra de dimensión" (`ScoreBar`,
  sin texto) sino `.bar span` de **`DistBar`** (niveles de la subdimensión), teñida con
  `nivelRamp(ind.color)`; `#4C939A` = `_darken(#61BDC6, .22)`. Y esa etiqueta **ya lleva
  inversión por luminancia** (`_txtOn`, umbral 0,55 de luma Rec. 601): la salida (b) de
  la §5.6 existe en el código. Recalculado sobre los 12 tonos de la rampa: `_txtOn`
  acierta en 11 (4,75–10,67) y en `#4C939A` **ningún** color de texto llega a 4,5
  (blanco 3,53; `#2e2710` 4,21). Por eso (b) no puede cerrar (4).
- **Anexo del panel adversarial (§30.7):** el tooltip `.tt` de la vista histórica pinta
  `"vs GSE: …"` con color de barra sobre `#23303a` (3,88 / 3,28 / 3,85) y los tokens
  `-txt` ahí **empeoran** (2,48 / 2,41 / 2,46): están diseñados para fondo claro. Viaja
  con §5.3 (b).

**Fase 4.** Motor regenerado y promovido a `docs/`. **Fase 5.** Este registro, el
pendiente del titular (§27) en `ESTADO.md`, push.

## 30. Chequeos de s29g (valores observados)

### 30.1 Instrumento y aritmética, antes de aplicar

Calculadora WCAG 2.1 propia (linealización sRGB, compositing de `opacity` en sRGB),
verificada con los dos controles del §0bis: `#000`/`#fff` = **21,00**; `#777`/`#fff` =
**4,48**. Las cuatro cifras del encargo se reprodujeron al tercer decimal antes de tocar
la plantilla:

| Elemento | Antes | Después | Exige |
|---|---|---|---|
| sufijo `.ancla.al` (`--alerta-txt` @.8 → @1 sobre `#FBE3E6`) | 3,718 | **4,606** | 4,5 |
| sufijo `.ancla.de` (`--destaca-txt` @.8 → @1 sobre `#E2F0FB`) | 3,301 | **4,689** | 4,5 |
| `"▼ rojo"` (`--alerta` → `--alerta-txt` sobre `#eef3f7`) | 3,681 | **5,025** | 4,5 |
| `"▲ azul"` (`--destaca` → `--destaca-txt` sobre `#eef3f7`) | 3,118 | **4,872** | 4,5 |
| sufijo `.ancla` neutra (`--tinta` @.8 → @1 sobre `#fff`) | 7,121 | 13,502 | 4,5 |

La quinta fila no está en el encargo: se añadió porque quitar la `opacity` afecta a las
tres ramas del ancla y había que descartar que la neutra empeorara. Mejora.

### 30.2 Regla de detención 1 — no se dispara

Ningún token de ESTADO (`--alerta`, `--st-neutro`, `--destaca`), de INDICADOR
(`--ind1..4`) ni ningún fondo cambió de valor: el diff de todas las definiciones `--*:`
del `:root` entre `1630ae8` y `46e0e47` es vacío, y las únicas líneas nuevas con
`background`/`#hex` son comentarios. Solo se usaron `--alerta-txt` y `--destaca-txt`, ya
definidos en `1630ae8` (l.50). Verificado por el ejecutor y, de forma independiente, por
la lente "contrato" del panel (§30.7).

### 30.3 Build y fidelidad (regla de detención 2 — no se dispara)

`run_all(only = 35L)` en 4,2 s. `grep -inE "warn|error|aviso|fail|problema"` sobre la
salida completa: **ninguna coincidencia**. Bloque 7 idéntico a la línea base (16
regiones; 9.136 EE; 91.596 unidades; 366.384 / 557.898 / 662.514 filas; 59,5 MB → 4,41 MB;
5,1 MB HTML).

```
bytes JSON:  59.466.778  ==  59.466.778
offsets que difieren: [38]      ← el dígito del día: 2026-09-11 → 2026-09-16
SHA-256 (convención §8.2):  1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6
```

Un solo offset, el permitido; hash idéntico al de s29c, s29d, s29e y s29f. **Ninguna
cifra se movió.** Nota de instrumentación: el `atob(...)` del motor es un flujo **zlib**
(`78 9c`, salida de `memCompress(type="gzip")` en R), no gzip con cabecera; se
descomprime con `zlib.decompress`, no con `gzip`.

### 30.4 Auditoría de todo el texto visible — tres escenarios a 1200px

Mismo método de s29d–s29f: todo elemento con nodo de texto propio, colores computados,
fondo efectivo compuesto capa a capa hacia arriba (alfa del `background-color` y
`opacity` de cada grupo) hasta lienzo blanco, animaciones forzadas a su estado final,
umbral 4,5 (3,0 si grande). El recuento de nodos es por elemento (no por combinación
única, como en s29f), de ahí las cifras mayores.

| Escenario | Nodos | Fallas | Cubiertas por |
|---|---|---|---|
| A · Panorama territorial | 478 | `.s100-seg span` 3,483 / 3,510 / 4,112 (×38) | §3.4 |
| B · Comparador poblado (Chile + SLEP Costa Central + 6 EE, tres estados) | 329 | `.s100-seg span` (×44) · `.ee-gl` 3,374 / 3,069 / 3,000 (×20) | §3.4 · §3.5 |
| C · Ficha RBD 12301 (vista actual) | 422 | `.defn-title` 2,187 / 3,066 / 1,843 (×3) · `.bar span` blanco/`#4C939A` 3,531 (×5) | **§5.6** (backlog de paleta de indicador) |
| C' · Ficha Liceo Atenea RBD 134 (vista actual) | 422 | ídem: `.defn-title` (×3) · `.bar span` 3,531 (×4) | **§5.6** |

**El criterio de la Fase 4.2 se cumple en los tres escenarios**: no queda ninguna falla
fuera de las excepciones escritas (§3.4, §3.5), lo exento (§5.3 c, sin nodos en estos
escenarios) y el ítem de backlog de paleta de indicador (§5.6 = §5.3 b + §5.5 2 y 4).

Los dos cierres, medidos en el motor cargado:

| Elemento | Dónde | Medido | Calculado (§30.1) |
|---|---|---|---|
| sufijo `"· sig."` de `.ancla.al` | RBD 12301, 25 anclas `.al`, `opacity` computada 1 | **4,606** | 4,606 |
| sufijo `"· sig."` de `.ancla.de` | Liceo Atenea (RBD 134), 4 anclas `.de` | **4,689** | 4,689 |
| sufijo `"· n.s."` de `.ancla` neutra | ambos EE | 13,502 | 13,502 |
| `"▼ rojo"` de `.ficha-explain` | ambos EE | **5,025** | 5,025 |
| `"▲ azul"` de `.ficha-explain` | ambos EE | **4,872** | 4,872 |

Resto del inventario `-txt`, intacto y al alza respecto de s29f: `.chip.al` 4,606,
`.chip.de` 4,689 (A); tira externa 5,372 / 5,208 (fila nacional) y 5,519 / 5,351 / 5,405
(panel); `.ee-st` 5,396 / 5,231 / 5,285 (B). La etiqueta `.k` del ancla (`--gris`) da
4,812 sobre `--alerta-bg`, 5,052 sobre `--destaca-bg` y 5,865 sobre blanco.

### 30.5 Regla de etiquetado de s29 — intacta

Comparador poblado (8 entidades, 40 `.s100`, 36 con dato):

| Ancho | Barras con dato | Dentro | En la tira | Cortadas | Duplicados |
|---|---|---|---|---|---|
| 1200px | 36 | 44 | 56 | **0** | **0** |
| 430px | 36 | 0 | 100 | **0** | **0** |

Mismos 44/56 y 0/100 de s29c–s29f. La pestaña sigue corriendo con `document.hidden ===
true` (§8.4), así que a 430px se forzó el **remount** del comparador (salir a Panorama
territorial y volver) para que `useLayoutEffect` remida el ancho; no es el re-etiquetado
en vivo por `ResizeObserver`, que sigue pendiente de una pestaña visible.

### 30.6 Despliegue (regla de detención 4 — no se dispara)

`docs/index.html` es **copia byte a byte** de `40_salidas/motor_idps.html`: `cmp` sin
diferencias, md5 **`02c742153ae36e19f6b4388e337ed62f`** en ambos, **5.384.452 bytes**
(632 bytes más que s29f por los comentarios del JSX). Sustituye el `docs/index.html` de
s29f (md5 `f61ac9c5…`, 5.383.820 bytes).

Servido `docs/` en local (`docs-py`, puerto 8767): título correcto, tres pantallas,
`--alerta-txt` = `#CE112C` y `--gris` = `#5C666E` en el documento servido, **0
ocurrencias** de `opacity:.8}}` y **1** de `var(--alerta-txt)"}}>▼ rojo`, **cero errores
de consola** en ambos servidores (8766 y 8767).

A diferencia de s29c–s29f, esta vez el pane **sí compuso** y se pudo capturar la ficha
del Liceo Atenea a 1200px: glosa con `▼ rojo` / `▲ azul` en los tokens de texto; anclas
`vs su GSE ▼ -8 · sig.` (`.al`), `vs año anterior ▲ +5 · sig.` (`.de`) y `▼ -4 · n.s.`
(neutra) con el sufijo a opacidad plena y jerarquía conservada por tamaño.

### 30.7 Panel adversarial — esta vez sí hubo

Tras la Fase 2 y antes del build se corrió el panel de solo lectura sobre el diff
`1630ae8..46e0e47`: tres lentes (contrato y regla de detención 1; corrección del JSX y
regresión visual; aritmética y cobertura), y cada hallazgo bruto sometido a dos
refutadores (hechos del código; alcance y norma). **7 agentes, 2 hallazgos brutos, 0
confirmados** (ambos refutados por unanimidad: preexistentes byte a byte en `1630ae8` y
fuera del alcance declarado). Comprobaciones que el panel dejó cerradas por su cuenta:

- El bloque `<script type="text/babel">` completo de ambas versiones **parsea con
  `@babel/parser` y transforma con `@babel/core` + `preset-react`**; el JS emitido
  difiere **solo en tres líneas** (la `opacity` y los dos `var(--*-txt)`). El comentario
  `{/* */}` es un `JSXExpressionContainer(JSXEmptyExpression)` y no emite ningún hijo.
- Ocho cifras recalculadas de forma independiente: delta máximo **0,0004** frente a las
  del encargo (si se redondea la opacidad a 8 bits sale 3,719 / 3,304 en vez de 3,718 /
  3,301: redondeo, no fórmula).
- Barrido de los seis colores de barra (`var()` y hex) como `color` de texto en la ficha
  vista actual: **ningún** uso fuera de las excepciones y de §5.6.
- Los dos hallazgos refutados quedan como **observaciones útiles**, no como defectos de
  s29g: (i) el tooltip `.tt` de la vista histórica, ya anexado a §5.6 de la decisión;
  (ii) `.sel-chip button:hover` y `.cmp-x:hover` pintan el `✕` con `--alerta` sobre
  blanco (**4,11**), fuera de la ficha; con `--alerta-txt` pasaría. Va a pendientes
  (§32).

### 30.8 Errores del asistente en s29g (regla 0.5)

| # | Qué pasó | Cuándo se detectó | Efecto |
|---|---|---|---|
| 1 | En §3.3 (5) de la decisión se escribió "medidos en s29g" para 5,025 / 4,872 cuando aún solo estaban **calculados**. | Antes del commit de la Fase 3; se corrigió a "cálculo… medición en navegador queda en el log". | Ninguno en el repo. La medición posterior (§30.4) coincidió. |
| 2 | Se indicó al panel el mismo directorio de scratchpad del ejecutor y un agente **sobrescribió** `wcag.py`, el instrumento del ejecutor. | Al reutilizarlo tras el panel (`ImportError`). | Ninguno en el repo ni en las cifras (ya capturadas); se rehízo con nombre propio. Lección: dar a los agentes un subdirectorio propio. |

## 31. Decisiones tomadas dentro del margen del encargo (s29g)

1. **No tocar el peso del sufijo.** El encargo lo permitía "si pierde la jerarquía". En
   pantalla el tamaño (12 vs 14 px) basta; añadir peso habría sido cambiar más de lo
   necesario.
2. **Anotar el quinto uso en el `:root` dentro de la Fase 2**, no en la Fase 3: la regla
   está escrita en el propio comentario y la plantilla es el archivo de esa fase.
3. **Completar la lista de §3.3 con la entrada 4 (anclas)** que s29f dejó fuera de la
   lista aunque la anotó en dos sitios: el inventario debe tener una sola fuente.
4. **Corregir la atribución de §5.5 (4)** y **documentar `_txtOn`** al reagrupar en §5.6:
   sin eso la §5.6 habría propuesto como salida (b) algo que el motor ya hace y que en ese
   tono no basta. Es documentación, no código, y cambia la recomendación.
5. **Anexar a §5.6 el hallazgo del panel sobre el tooltip histórico**, aunque el panel lo
   refutó como defecto de s29g: la advertencia de que los `-txt` empeoran sobre fondo
   oscuro es lo que evita que alguien lo "cierre" con el remedio de s29g.
6. **Renumerar el §25 duplicado a §27** sin tocar su texto, con nota de por qué.
7. **Panel adversarial antes del build**, como en s29c (§8.5), porque s29f no pudo
   tenerlo (§24.8) y este encargo despliega a `docs/`.
8. **Forzar remount para la medición a 430px** en vez de recargar (que habría perdido el
   comparador poblado) o de dar por válido el re-etiquetado en vivo, que no se puede ver
   con la pestaña oculta.

## 32. Pendientes tras s29g (cierre de la línea de contraste)

- **§5.6 — texto sobre color de la paleta de INDICADOR** (= §5.3 b + §5.5 2 y 4 + anexo
  del tooltip histórico): **backlog, pide mockup y aprobación del titular**. Recomendación
  escrita en la decisión: (a) sacar el texto del relleno; para la etiqueta de `DistBar`,
  extender §3.4.
- **P-VISTA-TERRITORIAL (§27):** selector "Vista actual / Vista histórica" en el panorama
  territorial. **Solo anotado**, no especificado: la vista histórica de un territorio no
  puede ser la curva de la ficha (cero agregación); §27 propone una serie de repartos y
  pide mockup. Entra al backlog con su correlativo en el cierre de sesión. Anotado en
  `ESTADO.md`.
- **Hover `✕` de `.sel-chip button` y `.cmp-x`** (panorama y comparador): `--alerta`
  sobre blanco, 4,11. Con `--alerta-txt` pasaría; sería el sexto uso del inventario.
  Observación del panel, no verificada en navegador (pide `hover`). Menor.
- **§5.2** marca de "base pequeña": umbral metodológico sin fijar.
- Re-etiquetado en vivo al redimensionar: pide una pestaña visible.
- Tooltip "vs evaluación anterior" (s28). Rama `feat/contrato-contexto`: no se tocó.


---

## 33. Error del asistente de análisis detectado en revisión del titular (2026-09-16)

| # | Error | Dónde se manifestó | Patrón |
|---|---|---|---|
| 4 | La entidad nacional se especificó como fila fija **en todos los tabs** del modal del comparador. El encargo s29 §3.2 lo dice literalmente ("aparece arriba de la lista en todos los tabs, no dentro de un tab propio"), y así se implementó. En pantalla, "Chile" aparece dentro del tab **Establecimiento** (donde no es un establecimiento) y encabeza las listas de SLEP, Comuna y Región (donde tampoco es ninguna de las tres). | `encargo_claude_code_idps_comparador_entidades_s29.md` §3.2; detectado por el titular sobre el motor publicado | Se diseñó desde cero un problema que el proyecto **hermano** `slep_simce_adecuado` ya tenía resuelto (su modal "Agregar territorio" lleva tabs Establecimiento · Comuna · SLEP · Región · Nacional · Grupo personalizado, con Nacional como tab propio y sin lista). El objetivo del backlog declara esa hermandad y aun así no se consultó la implementación existente antes de especificar. Sub-patrón: se confundió "fácil de encontrar" con "presente en todas partes". |

**Regla que se adopta:** antes de especificar cualquier componente de interfaz que el
hermano `slep_simce_adecuado` también tenga, se lee su implementación y se cita como
referencia vinculante en el encargo. Inventar una solución propia cuando existe una
hermana produce divergencia entre dos motores que el mismo equipo usa en paralelo.

Corrección: ver encargo de corrección posterior. La entidad nacional pasa a un tab propio.

---

## 34. Inventario de commits de s29h

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 34 | `be340c9` | 1 — `fix(comparador): tabs del modal alineados al proyecto hermano; nacional en su tab` | plantilla |
| 35 | `145b91b` | 2 — `build(motor): regenera el motor con el tab nacional` | `40_salidas/motor_idps.html` |
| 36 | `747e7e3` | 3 — `deploy(docs): republica con la entidad nacional en su propio tab` | `docs/index.html` |
| 37 | (este) | 4 — `docs(log): registro de s29h` | log (incluida la §33, que llegaba sin commitear) + `ESTADO.md` + encargo |

Rama `feat/contrato-contexto` y su log (`20260711_contrato_contexto_idps_log.md`, sin
seguimiento en el árbol) **no se tocaron**.

## 35. Qué se cambió

s29h corrige un **error de especificación** (§33), no de ejecución: s29 §3.2 mandó poner
la entidad nacional como fila fija arriba de la lista en todos los tabs, y así se
implementó. La corrección replica lo que el proyecto hermano `slep_simce_adecuado` ya
tenía resuelto (`30_procesamiento/33_motor_template.html`, pestañas en 3952-3959, cuerpo
del tab nacional en 4137), que el encargo declara **referencia vinculante**.

**Fase 1** — cuatro cambios de catálogo del modal, todos en la plantilla:

1. `TABS_CMP` pasa de cuatro a cinco entradas y cambia de orden, al del hermano, de menor
   a mayor alcance: **Establecimiento · Comuna · SLEP · Región · Nacional**. Sin "Grupo
   personalizado" (categoría que este motor no tiene; no se inventa). Con ese orden el
   modal abre en Establecimiento, igual que el hermano, **sin tocar `EntityModal`**: el
   tab inicial es `tabs[0][0]`.
2. `buildListCmp` deja de concatenar `NACIONAL_OPT` a todas las listas:
   `return tab==="nacional"?[NACIONAL_OPT]:_listaCmpEnt(tab,ql,grado,agno)`. La fila no
   depende del texto buscado.
3. `cmpPlaceholderFor` y `emptyTextFor` ganan su rama para el tab Nacional, de modo que
   no inviten a buscar. El buscador del andamio **no se elimina ni cambia de layout**, como
   ordena el encargo.
4. Los **dos** comentarios que afirmaban lo derogado: el del JS (líneas 1494-1496 del
   archivo previo, que el encargo §2.2 pedía corregir) y su gemelo en el CSS de
   `.check-row.is-nac`, que decía exactamente lo mismo y que el encargo no había visto.

La fila de Chile conserva su marca `is-nac` y su `sub`. No se tocó `addTerr`, ni
`CMP_MAX_TERR`, ni `rosterTerr`, ni ninguna cifra (regla de detención 1: no se dispara).

**Fase 2.** Motor regenerado. **Fase 3.** Promovido a `docs/`. **Fase 4.** Este registro,
la §33 que llegaba sin commitear, `ESTADO.md` y push.

## 36. Chequeos de s29h (valores observados)

### 36.1 El hermano, leído antes de editar

Lo que manda la referencia vinculante, y qué se tomó de ella:

| Del hermano | Se replica en `slep_idps` |
|---|---|
| Seis tabs de menor a mayor alcance, transversal al final | Cinco, mismo orden, sin "Grupo personalizado" |
| Abre en Establecimiento | Sí, por `tabs[0][0]`; `EntityModal` intacto |
| Tab Nacional sin lista ni buscador: una sola opción | Una sola fila, que ignora la consulta; el buscador del andamio queda, pero declarado inerte en su texto |
| Al guardar produce la entidad nacional | Ya existía: `NACIONAL_OPT` / `kind:"nacional"`, sin cambios |

Lo que **no** se replica, por instrucción expresa del encargo: título del modal, footer,
filtro de dependencia y "Grupo personalizado". El inventario completo de divergencias
está en §36.7.

### 36.2 Panel adversarial antes del build

Sobre el árbol de trabajo de la Fase 1, antes de commitear: cuatro lentes (regresión;
reglas de detención y alcance; fidelidad al hermano e inventario de divergencias; texto
visible y presentación) y cada hallazgo bruto sometido a **dos** refutadores (hechos del
código; ¿lo notaría el usuario del motor y lo prohíbe el encargo?). **12 agentes, 4
hallazgos brutos, 0 confirmados** y 29 notas. Comprobaciones que el panel dejó cerradas:

- Las cuatro funciones modificadas, ejecutadas **aisladas en node**: `TABS_CMP` en el
  orden esperado, tab inicial `establecimiento`, ningún tab distinto de `nacional`
  devuelve un item `kind==="nacional"`, y `buildListCmp("nacional", ql)` devuelve una
  fila **para todo `ql`**.
- Los cuatro placeholders del generador (`__FONTS_CSS__`, `__D3_INLINE__`,
  `__PAKO_INLINE__`, `__JSON_DATA__`) idénticos antes y después, y el generador solo hace
  esos cuatro `sub()` fijos (`35_generar_motor_html.R:546-552`): la plantilla no puede
  mover el payload.
- Dos hallazgos brutos apuntaban al comentario CSS gemelo y uno a un anglicismo en cadena
  visible: ambos se corrigieron **antes** del commit (§36.8), y por eso no figuran como
  defectos del cambio.

### 36.3 Build y fidelidad (regla de detención 2 — no se dispara)

`run_all(only = 35L)` en **4,2 s**. `grep -inE "warn|error|aviso|fail|problema"` sobre la
salida completa: **ninguna coincidencia**, igual que la línea base de s29g (§30.3). Bloque
7 idéntico: 16 regiones; 9.136 EE; 91.596 unidades; 366.384 / 557.898 / 662.514 filas;
59,5 MB → 4,41 MB gzip+base64 (7,4%); 5,1 MB de HTML.

```
bytes JSON:  59.466.778  ==  59.466.778
offsets que difieren: []          ← ninguno: el motor anterior se generó el MISMO día
SHA-256 (convención §8.2):  1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6
```

Es el caso más fuerte posible de la regla: **cero** offsets, no uno. El instrumento se
validó antes de tocar nada, contra el motor publicado, y reprodujo exacto el hash y el
recuento de bytes que §8.2 dejó escritos. El `diff` del HTML generado son **exactamente
los cinco hunks de la plantilla** (22 inserciones, 11 supresiones); el archivo pasa de
5.384.452 a **5.385.578 bytes** (+1.126, todos de comentario).

### 36.4 Verificación funcional en navegador — antes y después

Chrome 152 headless, motor **generado** (no la plantilla), mismo guion sobre los dos
motores para que el antes/después sea comparable. Consola **limpia** (sin errores ni
warnings) en las cuatro corridas.

| | Motor publicado (antes) | Motor de s29h (después) |
|---|---|---|
| Tabs | SLEP · Comuna · Región · Establecimiento | **Establecimiento · Comuna · SLEP · Región · Nacional** |
| Tab activo al abrir | SLEP | **Establecimiento** |
| Tabs en una línea a 1200px | sí | sí |
| Tab Establecimiento, sin consulta | **1 fila: Chile** | 0 filas, "Escribe para buscar un establecimiento" |
| Tab Establecimiento, "liceo" | 61 filas, **con Chile** | **60**, sin Chile |
| Tab Comuna | 346, **con Chile** | **345**, sin Chile |
| Tab SLEP | 37, **con Chile** | **36**, sin Chile |
| Tab Región | 17, **con Chile** | **16**, sin Chile |
| Tab Nacional | no existía | **1 fila: Chile**, `is-nac`, sub "Nivel nacional · 346 comunas · 9.136 establecimientos" |

Exactamente una fila menos en cada uno de los cuatro tabs: la que sobraba. El tab
Establecimiento, que era el caso más visible, pasa de mostrar **solo a Chile** cuando no
hay consulta a mostrar la invitación a buscar.

Lo demás del comparador, sin cambio (verificado sobre el motor nuevo):

- Placeholder del tab Nacional: "Sin búsqueda: Chile es la única opción".
- Elegir Chile desde su tab lo agrega igual que antes: chip **"Nacional · fijo"** con
  `is-nac`, y **primera fila (`row-nac`) de las cinco secciones de GSE**.
- Toggle: `1 de 10 → 0 de 10 → 1 de 10`.
- Tope: poblado a 8 (Chile + SLEP Costa Central + 6 EE) y llevado a **10 de 10**; las 52
  filas no marcadas de la lista quedan `is-disabled` y un clic más no agrega nada.

### 36.5 Regla de etiquetado de s29 — intacta y sin moverse

Mismo escenario poblado (8 entidades; 2 filas territoriales × 4 indicadores × 5 GSE):

| Ancho | Motor | Barras | Con dato | Dentro | En la tira | Cortadas | Duplicados |
|---|---|---|---|---|---|---|---|
| 1200px | antes | 40 | 36 | 45 | 55 | **0** | **0** |
| 1200px | **después** | 40 | 36 | **45** | **55** | **0** | **0** |
| 430px | antes | 40 | 36 | 0 | 100 | **0** | **0** |
| 430px | **después** | 40 | 36 | **0** | **100** | **0** | **0** |

No se movió una sola etiqueta: era lo esperable, porque el cambio no toca ni el reparto ni
el ancho de las columnas. Los 45/55 de esta corrida difieren de los 44/56 de §30.5 por el
conjunto de EE elegido (los nombres de las filas EE cambian el ancho de `.td-terr` y con
él el de las columnas de indicador); lo que importa —0 cortadas, 0 duplicados— se sostiene
en los cuatro casos.

### 36.6 Despliegue (regla de detención 4 — no se dispara)

`docs/index.html` es **copia byte a byte** de `40_salidas/motor_idps.html`: `cmp` sin
diferencias, md5 **`5ab600724e8642e769d9e8936f81188e`** en ambos, **5.385.578 bytes**.
Sustituye al `docs/index.html` de s29g (md5 `02c74215…`, 5.384.452 bytes). Abierto desde
`docs/`: consola limpia y las mismas cifras de §36.4 y §36.5.

### 36.7 Divergencias del modal con el hermano que NO se corrigen

El encargo ordena anotarlas, no corregirlas: son diferencias reales entre dos motores, o
deuda que pide su propio encargo.

| # | Divergencia | Lectura |
|---|---|---|
| 1 | Cuerpo del tab Nacional: prosa explicativa en el hermano; fila de lista con cifras del directorio en el local | Diferencia de forma; el local informa cobertura con números |
| 2 | `EntityModal` es un andamio **portable** con cuerpo genérico por tab; el hermano escribe un formulario a medida por tab | Divergencia estructural de la que cuelgan casi todas las demás |
| 3 | El hermano no dibuja buscador en el tab Nacional; el local sí (inerte) | Suprimirlo pediría una prop nueva en `EntityModal`, que el encargo excluye |
| 4 | Título "Agregar/Editar territorio" con modo edición; el local dice "Agregar entidad a la comparación" y no edita (se quita con el ✕ del chip) | Diferencia real; "entidad" es convención de s29 |
| 5 | Footer: confirmación diferida ("Cancelar" + "Agregar al análisis") vs alta inmediata por toggle y "Listo" | Diferencia real de arquitectura del modal |
| 6 | El modal local no tiene ✕ de cierre en el encabezado (Escape, backdrop o "Listo") | Deuda menor |
| 7 | El hermano ofrece filtro de dependencia, incluso en el tab Nacional | Diferencia real: el comparador IDPS no usa dependencia |
| 8 | Selección múltiple en todos los tabs del local; en el hermano solo SLEP y Región, y Nacional es alta simple | Diferencia real |
| 9 | Buscador único que se borra al cambiar de tab vs buscador por tab, con umbral de 3 caracteres y tope propio | Diferencia real |
| 10 | El tab SLEP del comparador no muestra "Traspaso AAAA" ni el disclaimer SLEP | Deuda menor: el **otro** modal del mismo motor sí etiqueta el traspaso |
| 11 | El color por entidad no aparece en el modal local | Diferencia real: el comparador no colorea por entidad |
| 12 | Conteo: cupos libres en el hermano vs "N de 10" en el local | Diferencia real (regla de detención 1) |
| 13 | a11y: filas `div[role=checkbox]` sin foco de teclado vs controles nativos | **Deuda preexistente**, no la introduce s29h |

Observaciones sobre la solución adoptada, que no son defectos pero conviene tener escritas:

- La rama `emptyTextFor("nacional")` es una **guarda que hoy no se pinta nunca**: la lista
  del tab siempre trae una fila, así que `list.length===0` no ocurre. Lo único que
  comunica "aquí no se busca" es el placeholder, y el placeholder desaparece al primer
  carácter. Es el precio de conservar el buscador del andamio, como ordena el encargo.
- Ese placeholder se pinta con el gris por defecto del navegador (no hay regla
  `::placeholder` en el motor), de modo que queda **fuera** del inventario de la decisión
  de contraste.
- `.check-row.is-nac` gana por orden de fuente a `.check-row.is-checked`: la fila de Chile
  **no cambia de fondo** al marcarse, y el acuse queda en el ✓ de la casilla y en el
  contador del footer. Comprobado en captura. Es preexistente.
- Con una sola fila, el destacado de `is-nac` se reduce al borde punteado: su fondo
  (`--panel`) es el mismo del contenedor.
- A 430px la tira de pestañas envuelve a dos líneas. **Ya lo hacía con cuatro tabs**
  (medido sobre el motor anterior): no lo introduce s29h.

### 36.8 Errores del asistente en s29h (regla 0.5)

| # | Qué pasó | Cuándo se detectó | Efecto |
|---|---|---|---|
| 1 | La primera pasada corrigió el comentario del JS que el encargo §2.2 señalaba, pero dejó intacto su **gemelo en el CSS** de `.check-row.is-nac`, que afirmaba lo mismo que se estaba derogando. | Panel adversarial, antes del commit de la Fase 1. | Ninguno en el repo: se corrigió antes de commitear. |
| 2 | La cadena de vacío nueva decía "…de este **tab**": habría sido el único anglicismo visible del motor (y en un texto que además no llega a pantalla). | Panel adversarial, antes del commit de la Fase 1. | Ninguno: quedó "Nivel nacional: Chile es la única opción". |

**Nota de instrumentación.** (a) La verificación funcional corre con Puppeteer 25.9.0
tomado por `NODE_PATH` de `slep_servicio_educativo_regional` (este proyecto no tiene
`node_modules`) sobre el Chrome 152 del sistema; el motor se abre por `file://`. (b) El
verificador de fidelidad se validó **antes** de tocar nada contra el motor publicado y
reprodujo exacto el `1e29c2b5…` de §8.2: la convención escrita ahí es reproducible. (c) Un
`.git/index.lock` obsoleto (0 bytes, de las 11:38, sin proceso git vivo) bloqueó el primer
intento de commit; se retiró.

## 37. Decisiones tomadas dentro del margen del encargo (s29h)

1. **Conectar `emptyTextFor` al modal del comparador.** El encargo pedía ajustarlo, pero
   ese modal no recibía la prop: sin conectarla el ajuste habría sido nominal y, peor, el
   tab Establecimiento —ahora el primero y vacío al abrir— habría dicho "Sin resultados"
   donde corresponde "Escribe para buscar un establecimiento". Es la segunda cadena
   visible que cambia, y queda declarada en el comentario y aquí.
2. **Corregir también el comentario gemelo del CSS.** El encargo nombraba uno; había dos
   diciendo lo mismo. Dejar el del CSS habría dejado el archivo contradiciéndose.
3. **No filtrar `NACIONAL_OPT` por la consulta.** El encargo dice devolver `[NACIONAL_OPT]`
   y filtrar contradiría "el buscador no aplica"; de ahí que la rama de vacío sea una
   guarda y no un texto alcanzable.
4. **No tocar el `<input>` del andamio** pese a que el hermano no lo dibuja: el encargo lo
   prohíbe expresamente. La divergencia queda anotada (§36.7, 3).
5. **Panel adversarial antes del build**, como en s29g (§30.7), porque este encargo
   despliega a `docs/` sin revisión previa del titular.
6. **Corregir en `ESTADO.md` el md5 y el peso del despliegue**, que quedaban falsos tras la
   Fase 3. El encargo no lo pide, pero publicar un estado con el hash equivocado es el
   mismo tipo de defecto que s29h viene a corregir.

## 38. Pendientes tras s29h

Los de §32 siguen abiertos sin cambio (**§5.6** de la decisión de contraste;
**P-VISTA-TERRITORIAL**; hover `✕` a 4,11; **§5.2** marca de base pequeña; re-etiquetado
en vivo; tooltip "vs evaluación anterior"; rama `feat/contrato-contexto`, no tocada). Se
suman:

- **Divergencias del modal con el hermano** (§36.7): trece, ninguna corregida por decisión
  del encargo. Las que parecen deuda y no diferencia de motor son la 6 (sin ✕ de cierre),
  la 10 ("Traspaso AAAA" en un modal sí y en el otro no) y la 13 (a11y de teclado).
- **El aviso de "aquí no se busca" depende de un placeholder** (§36.7). Si el titular
  quiere el remedio del hermano —no dibujar buscador en ese tab— hay que darle a
  `EntityModal` una prop para suprimirlo por tab. Es un encargo propio, chico.

---

## 39. Inventario de commits de s29i

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 38 | `ca1cdcd` | 1 — `feat(panorama): la entidad nacional disponible tambien en el selector de territorio` | plantilla |
| 39 | `ed0d799` | 2 — `feat(entidades): dependencia por entidad en el modal, como el motor hermano` | plantilla |
| 40 | `28a4de4` | 3 — `fix(comparador): la explicacion del pie se dice una vez, no en cada seccion` | plantilla |
| 41 | `76be5ef` | 4 — `fix(motor): la tira externa se apila en vez de solaparse en anchos extremos` | plantilla |
| 42 | `7a2b263` | 5 — `fix(motor): retira mayusculas sostenidas fuera de siglas` | plantilla |
| 43 | `7377fc7` | 6 — `fix(motor): correcciones del panel adversarial de s29i` | plantilla |
| 44 | `be9b05b` | 6 — `build(motor): regenera el motor con las correcciones de la revision` | `40_salidas/motor_idps.html` |
| 45 | `8e01b92` | 7 — `deploy(docs): republica con las correcciones de la revision` | `docs/index.html` |
| 46 | (este) | 7 — `docs(log): registro de s29i` | log + `ESTADO.md` + encargo |

Rama `feat/contrato-contexto` y su log (`20260711_contrato_contexto_idps_log.md`, sin
seguimiento en el árbol) **no se tocaron**.

## 40. Qué se cambió

s29i reúne los cuatro hallazgos de la revisión que el titular hizo sobre el motor
publicado el 2026-09-16. Todo es plantilla: ninguna fase toca el pipeline ni el payload.

**Fase 1 — la entidad nacional también en el panorama.** `TABS` gana el tab **Nacional**
después de Región; `buildList` devuelve `[NACIONAL_OPT]` ahí; `onPick` acepta el `kind`;
`unidades` gana la rama que **no filtra**, primera en la cadena para no caer por descarte
en el `else` que captura región. Decisión declarada y reversible: con el territorio
nacional **no se dibuja la grilla** —6.717 tarjetas no son lo que esa pantalla responde—
y en su lugar va un aviso con el conteo del grupo; las barras por GSE sí se calculan,
porque son conteo.

**Fase 2 — dependencia por entidad.** Es la fase grande y la que sigue al hermano de
cerca: la dependencia deja de ser un filtro global y pasa a ser **atributo de la
entidad** (`terr.dep` en el panorama, `t.dep` en el comparador). El `<select>` vive
dentro del modal y solo en Comuna, Región y Nacional. `rosterTerr` y `unidades` filtran
con `continue`. La clave de unicidad pasa a `kind|cod|dep` (`keyEnt`), que es lo que
permite comparar la misma comuna con dos dependencias. El aviso metodológico del SLEP se
replica adaptado. El tab "Dependencia" del picker **se retira** (decisión declarada y
reversible del encargo §3.7).

**Fase 3 — el pie de sección.** La explicación general se dice una vez, en el bloque
`.cmp-nota-ee` que ya existía bajo los chips; el pie de cada sección se queda con lo que
cambia.

**Fase 4 — la tira externa.** `.s100-ext` pasa de grid de tres columnas fijas a **flex
con salto de línea**, con las posiciones sostenidas por márgenes automáticos.

**Fase 5 — mayúsculas sostenidas.** Las siete reglas `text-transform:uppercase` pierden
esa propiedad y conservan `letter-spacing` y peso.

**Fase 6.** Panel adversarial, correcciones, build y auditoría. **Fase 7.** Despliegue,
este registro y push.

## 41. Chequeos de s29i (valores observados)

### 41.1 El hermano, leído para la Fase 2

Referencia vinculante del encargo: `slep_simce_adecuado/30_procesamiento/33_motor_template.html`.

| Del hermano | En `slep_idps` |
|---|---|
| La dependencia es atributo de la entidad: `if (entity.depe2) { if (String(r.cod_depe2) !== String(entity.depe2)) return false; }` (1953 y 2106) | `if(t.dep && e.cod_depe2!==t.dep)continue;` en `rosterTerr`, y el gemelo en `unidades` |
| `<select>` "Dependencia" dentro del modal, en Comuna, Región y Nacional (4040-4055) | Igual, vía cuatro props opt-in de `EntityModal` |
| Primera opción "Todas las dependencias" (valor vacío) | Igual |
| `SlepDisclaimer` cuando la dependencia es SLEP; siempre en el tab SLEP (3766) | Igual, con el texto adaptado a la serie 2014-2025 |
| Código de la dependencia SLEP: `"5"` | **`"4"`** en este motor. No se escribe a mano: se **deriva** de `DATA.meta.depe2_labels` con `/slep/i`, para que el aviso siga al dato |

El catálogo de este motor es `{1: Municipal, 2: Particular subvencionado, 3: Particular
pagado, 4: SLEP}`. Si el encargo se hubiera seguido al pie (`dep === "5"`), el aviso no
se habría mostrado nunca.

### 41.2 Panel adversarial antes del build

Cinco lentes (dependencia; nacional; presentación; reglas de detención; **cero
agregación**) con dos refutadores por hallazgo. **Se cortó a la mitad por el límite de
sesión: 16 de 33 agentes terminaron.** De los 10 hallazgos que quedaron marcados como
confirmados, **3 llegaron sin verificación** (sus dos refutadores murieron) y se
juzgaron a mano. Lo que se corrigió, en `7377fc7`:

| Hallazgo | Por qué se acepta |
|---|---|
| El `<select>` quedaba **después** de la lista | En el hermano el modal confirma con un botón y el orden da igual; aquí el clic en la fila commitea, así que la dependencia debe fijarse antes. Bajo 340px de lista quedaba fuera de la caja en un portátil |
| El ✕ de dos chips de la misma comuna tenía el mismo nombre accesible | Es justo el caso que el encargo §3 manda verificar |
| `.help` seguía prometiendo la grilla a nivel nacional | La Fase 1 corrigió el sub-encabezado y no la explicación de arriba |
| La cabecera de sección no pasaba por `fmt()` | El mismo número se leía "2343" arriba y "2.343" dos líneas más abajo |
| `.cmp-noagg` decía "del territorio" | Desde s29i la dependencia es el segundo acotador |
| El estado vacío del panorama no nombraba la dependencia | Es hoy la causa más probable del cero |
| El comentario de `.s100-ext` afirmaba un invariante que el flex no conserva entero | Ver §41.5 |
| Restos del tab retirado | Tres comentarios y el conteo por categoría de `DEPS_OPTS` |

**Se declara NO corregido** (decisión del titular): al llegar al tope de 10 entidades,
cambiar el selector deja **todas** las filas sin marcar —la clave es `kind|cod|dep`, como
ordena el §3.4— y desde el modal no se puede desmarcar; la salida son los ✕ de los chips.

### 41.3 Build y fidelidad (regla de detención 2 — no se dispara)

`run_all(only = 35L)` en **4,2 s**; `grep -inE "warn|error|aviso|fail|problema"` sobre la
salida completa: **ninguna coincidencia**. Bloque 7 idéntico: 16 regiones; 9.136 EE;
91.596 unidades; 366.384 / 557.898 / 662.514 filas; 59,5 MB → 4,41 MB (7,4%); 5,1 MB HTML.

```
bytes JSON:  59.466.778  ==  59.466.778
offsets que difieren: []
SHA-256 (convención §8.2):  1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6
```

Cero offsets, como en s29h. **Ninguna cifra se movió**: las cinco fases son plantilla.

### 41.4 Verificación funcional (Chrome headless; consola limpia en todas las corridas)

**Fase 1.** Picker territorial: `Comuna · SLEP · Región · Nacional · Establecimiento`.
Con Chile, el banner da **343 comunas y 6.717 establecimientos** —del roster real del
nivel y año, no del directorio (346 / 9.136)— y las cinco secciones muestran sus cuatro
barras y el aviso en vez de la grilla (1.408 + 2.343 + 1.736 + 713 + 517 = **6.717**).
Con una comuna, la grilla vuelve.

**Fase 2.** El `<select>` aparece solo en Comuna, Región y Nacional; el aviso SLEP,
siempre en el tab SLEP y además al elegir esa dependencia en los otros. En el panorama,
"Región de Valparaíso · Municipal" da 32 comunas y 255 EE frente a 38 y 747 sin filtro, y
el banner y el chip de selección lo dicen.

**La verificación exigida por el encargo §3**, sobre el motor generado, en 4° básico 2025:

| Entidad | Comunas | Establecimientos |
|---|---|---|
| Viña del Mar · todas | 1 | **109** |
| Viña del Mar · Municipal | 0 | 0 |
| Viña del Mar · Particular subvencionado | 1 | 47 |
| Viña del Mar · Particular pagado | 1 | 23 |
| Viña del Mar · SLEP | 1 | 39 |
| | | 0 + 47 + 23 + 39 = **109** |

Las cinco conviven como cinco filas distintas, cada una rotulada con su dependencia bajo
el nombre. El **0 de Municipal no es un fallo**: los municipales de Viña ya fueron
traspasados al SLEP, y eso es exactamente lo que el aviso metodológico advierte.

**Fase 3.** La frase "Los establecimientos seleccionados aparecen únicamente en la
sección de su propio grupo socioeconómico." pasa de **5 apariciones** (una por GSE
visible) a **1**; sin establecimientos seleccionados no aparece ninguna, y el pie de cada
sección empieza ahora por el nombre.

### 41.5 La tira externa: el mecanismo real

El síntoma de la captura no era que los tres ítems se pisaran **dentro** de la tira —eso
da 0 en los dos motores, porque un grid nunca superpone sus pistas—, sino que la tira
**desbordaba la celda** y caía sobre la vecina. Medido sobre el comparador poblado:

| Ventana | Celda | Antes: desbordes / cruces entre celdas | Después | Líneas por tira |
|---|---|---|---|---|
| 1200px | 235px | 0 / 0 | 0 / 0 | 1 → 1 |
| 768px | 127px | **63 / 55** | **0 / 0** | 1 → **3** |
| 430px | 43px | 100 / 185 | 100 / **75** | 1 → **3** |
| 375px | — | 100 / 213 | 100 / **112** | 1 → 3 |
| 320px | — | 100 / 242 | 100 / **150** | 1 → 3 |

A 768px el defecto **desaparece**: las tres etiquetas se apilan y dejan de salirse. Por
debajo de ~70px de celda, **una sola** etiqueta ya no cabe, y `white-space:nowrap` es
invariante (un número no se parte nunca): ahí el desborde es irreducible por CSS. La
causa de fondo es otra y **queda como pendiente**: `.cmp-table` es `table-layout:fixed`
con `width:100%` y sin `min-width`, así que la tabla se **comprime** en vez de dejar que
`.cmp-tscroll` haga scroll; a 430px las columnas caen a 43px. En el panorama, donde la
barra ocupa el ancho de la columna de contenido (230px a 320px de ventana), no hay
desborde ni antes ni después.

Lo que el flex **no** conserva del grid: con **dos** ítems, el del medio ya no cae en el
centro del contenedor sino repartido entre los otros dos. Los extremos siguen anclados y
el neutro solo sigue exactamente centrado. Es el precio de poder saltar de línea, y el
comentario del CSS ya lo dice así.

### 41.6 Mayúsculas sostenidas

Las siete reglas pierden `text-transform:uppercase` y conservan `letter-spacing` y peso.
Medido sobre el motor generado: **0 elementos** con `text-transform:uppercase` computado
en las tres pantallas. Del texto fuente solo hacía falta corregir uno —el rótulo del chip
de selección del panorama, escrito "dependencia" porque la versalita lo capitalizaba—; el
barrido de literales en versalita dentro del JSX no encontró ninguno. `.ctl label` no
tiene uso vivo (la clase `.ctl` no se usa en el JSX); se limpió igual. **Nota:** la regla
de mayúsculas no está escrita en `POLITICA_PROYECTO.md`; su enunciado es el del encargo
§6 y conviene subirlo al normativo.

### 41.7 Auditoría de contraste

Método de s29d–s29g (colores computados, fondo efectivo compuesto capa a capa, umbral 4,5
/ 3,0), validado antes de usarlo: sobre el motor anterior reprodujo exactamente los
valores que §30.4 dejó escritos (`.s100-seg span` 3,483 / 3,510 / 4,112; `.ee-gl` 3,374 /
3,069; `.defn-title` 2,187 / 3,066 / 1,843; `.bar span` 3,531). Seis escenarios, con los
tres nuevos de s29i:

| Escenario | Nodos | Fallas |
|---|---|---|
| A · Panorama territorial | 718 | `.s100-seg span` (×38) — §3.4 |
| **A2 · Panorama nacional** | 145 | `.s100-seg span` (×60) — §3.4 |
| **A3 · Panorama región + dependencia** | 2.425 | `.s100-seg span` (×44) — §3.4 |
| **D · Modal con selector y aviso SLEP** | 3.126 | `.s100-seg span` (×44) — §3.4 |
| B · Comparador poblado (8 entidades, con dependencias) | 376 | `.s100-seg span` (×90) — §3.4 · `.ee-gl` (×8) — §3.5 |
| C · Ficha | 430 | `.bar span` (×5) · `.defn-title` (×3) — §5.6 |

**Ninguna falla nueva.** Los elementos que s29i añade —el rótulo y el `<select>` de
dependencia, el aviso SLEP, el aviso de la grilla nacional, la sub-línea de dependencia
de la fila— pasan todos.

### 41.8 Regla de etiquetado de s29 — intacta

| Ancho | Barras con dato | Dentro | En la tira | Cortadas | Duplicados |
|---|---|---|---|---|---|
| 1200px | 36 | 45 | 55 | **0** | **0** |
| 768px | 36 | 5 | 95 | **0** | **0** |
| 430px | 36 | 0 | 100 | **0** | **0** |
| 375px | 36 | 0 | 100 | **0** | **0** |
| 320px | 36 | 0 | 100 | **0** | **0** |

Los 45/55 de 1200px y los 0/100 de 430px son los mismos de s29h.

### 41.9 Despliegue (regla de detención 4 — no se dispara)

`docs/index.html` es copia byte a byte de `40_salidas/motor_idps.html`: `cmp` sin
diferencias, md5 **`5ac4a1b85559ac490df82dac7f07f272`** en ambos, **5.393.686 bytes**.
Sustituye al de s29h (md5 `5ab60072…`, 5.385.578 bytes). Abierto desde `docs/`: consola
limpia y las mismas cifras.

### 41.10 Errores del asistente en s29i (regla 0.5)

| # | Qué pasó | Cuándo se detectó | Efecto |
|---|---|---|---|
| 1 | Se aplicaron las Fases 3, 4 y 5 **antes** de commitear la 3, rompiendo el "commit atómico por fase" del contrato. | Al ir a commitear la Fase 3. | Ninguno en el repo: se restauró la plantilla a `HEAD` y se reaplicó cada fase con su commit. Costó una vuelta. |
| 2 | El `<select>` de dependencia se puso **después** de la lista, copiando el orden visual del hermano sin advertir que aquí el clic en la fila confirma de inmediato. | Panel adversarial, antes del build. | Ninguno: corregido en `7377fc7`. |
| 3 | La Fase 1 ajustó el sub-encabezado de la sección al territorio nacional pero dejó el `.help` de arriba prometiendo la grilla, y el conteo de la cabecera sin `fmt()`. | Panel adversarial. | Ninguno: corregido en `7377fc7`. |
| 4 | El comentario de `.s100-ext` afirmaba que el flex conservaba entero el invariante de s29, y no lo conserva con dos ítems. | Panel adversarial. | Ninguno: el comentario ahora lo dice exacto. |

**Nota de instrumentación.** (a) El panel se cortó por el límite de sesión (16 de 33
agentes); tres hallazgos llegaron sin verificación y se juzgaron a mano, lo que conviene
declarar antes que ocultar. (b) El auditor de contraste se validó contra los valores que
§30.4 dejó escritos **antes** de usarlo para juzgar s29i. (c) El `.git/index.lock`
obsoleto de s29h volvió a aparecer dos veces (0 bytes, sin proceso git vivo) y bloqueó
commits; se retiró cada vez. Conviene mirar qué lo crea —probablemente la integración git
del editor abierto sobre el repo—.

## 42. Decisiones tomadas dentro del margen del encargo (s29i)

1. **El código de la dependencia SLEP se deriva de la etiqueta**, no se fija a `"5"` como
   decía el encargo: en este motor es `"4"`. Seguir el encargo al pie habría dejado el
   aviso muerto.
2. **El `<select>` va arriba de la lista**, al revés que el hermano, porque este modal
   confirma con el clic en la fila (§41.2).
3. **El banner del panorama pasa por `fmt()`**: con el territorio nacional el número
   llega a cuatro cifras y se leía "6717". Lo mismo en la cabecera de sección.
4. **`.cmp-noagg` nombra la entidad, no solo el territorio**, y el estado vacío nombra la
   dependencia: desde s29i hay un segundo acotador y los textos que enuncian el
   invariante tienen que decirlo.
5. **El conteo por categoría de `DEPS_OPTS` se elimina**: era del directorio completo y,
   junto a un territorio elegido, habría engañado.
6. **Panel adversarial antes del build**, como en s29g y s29h, porque el encargo despliega
   sin revisión previa del titular.
7. **No se toca `.cmp-table`** para que la tabla haga scroll en vez de comprimirse, pese a
   ser la causa de fondo del desborde a 430px: cambia el comportamiento responsive del
   comparador y podría mover las cifras de la regla de etiquetado que el encargo manda
   conservar. Va a pendientes.

## 43. Pendientes tras s29i

**Nuevo, pedido por el titular tras la revisión (encargo §9, fuera de alcance aquí):**

- **P-EXPORTACION** — exportación tipo `slep_simce_adecuado`: botón "Exportar CSV" y
  exportación de imagen del gráfico, con el selector de GSE al lado. Es funcionalidad
  nueva, con su propio diseño y su propio encargo; el hermano es la referencia.

**Nuevos, de esta sesión:**

- **Tope + selector:** al llegar a 10 entidades, cambiar el selector de dependencia deja
  todas las filas sin marcar y el modal no permite desmarcar (§41.2). Decisión de diseño
  del titular; la alternativa es marcar las filas que ya están con otra dependencia.
- **`.cmp-table` se comprime en vez de hacer scroll** (§41.5): a 430px las columnas caen a
  43px y una sola etiqueta no cabe en la celda. Un `min-width` haría que `.cmp-tscroll`
  sirviera de verdad.
- **El aviso de dependencia actual solo se dispara con SLEP.** La otra cara de la misma
  regla —una comuna cuyos municipales fueron traspasados muestra "Municipal · 0
  establecimientos"— no tiene aviso.
- **`NACIONAL_OPT.sub` anuncia 9.136 EE y 346 comunas** (directorio) y, al elegir Chile,
  el banner dice 6.717 y 343 (roster del nivel y año). Las dos cifras son correctas y
  miden cosas distintas, pero conviven a un clic de distancia.
- **La regla de mayúsculas no está en `POLITICA_PROYECTO.md`** (§41.6): vive solo en el
  encargo.

**Heredados, sin cambio:** §5.6 de la decisión de contraste; P-VISTA-TERRITORIAL; hover
`✕` a 4,11; §5.2 marca de base pequeña; re-etiquetado en vivo; tooltip "vs evaluación
anterior"; las trece divergencias del modal con el hermano (§36.7); rama
`feat/contrato-contexto`, no tocada.


---

## 44. Errores del asistente de análisis en el encargo s29i (2026-09-17)

| # | Error | Dónde se manifestó | Patrón |
|---|---|---|---|
| 5 | El §3.6 fijó el código de la dependencia SLEP en `"5"`, copiado del motor hermano. En `slep_idps` la dependencia tiene **4 categorías** (`10_utils/10_configuracion.R` líneas 39-42: 1 Municipal, 2 Particular subvencionado, 3 Particular pagado, 4 SLEP) y SLEP es `"4"`. De haberse seguido al pie, el aviso metodológico del SLEP nunca se habría mostrado. | `encargo_claude_code_idps_correcciones_revision_s29i.md` §3.6; detectado por el ejecutor, que lo derivó de `DATA.meta.depe2_labels` en vez de fijarlo | Se copió del hermano un **valor de dominio**, no solo un patrón de interfaz. La referencia hermana vale para la forma (dónde va el selector, cómo se rotula); los códigos, glosas y categorías son de cada motor y se leen de su propia configuración. |
| 6 | El §5 describió el defecto de la tira externa como "las tres etiquetas se superponen entre sí". Medido: dentro de la tira no hay superposición (es un grid, no pisa sus pistas); lo que ocurría era **desborde de la celda sobre la vecina**. El remedio pedido servía igual, pero el diagnóstico era incorrecto. | `encargo_claude_code_idps_correcciones_revision_s29i.md` §5; corregido por el ejecutor con medición | Se describió el síntoma tal como se ve en una captura en vez de medir qué elemento invade a cuál. Un encargo que nombra mal la causa puede llevar al ejecutor a arreglar el sitio equivocado. |

**Regla que se adopta:** de la referencia hermana se toma la **forma**; los valores de
dominio (códigos, glosas, categorías, topes) se leen siempre de la configuración del
motor que se está editando.


---

# Anexo s30 — Exportación de datos (CSV) e imagen (2026-09-17)

> Encargos: `encargo_claude_code_idps_exportacion_s30.md` (s30a) y
> `encargo_claude_code_idps_reanudar_exportacion_s30b.md` (s30b, reanudación).
> Ejecución autónoma secuencial en dos sesiones: **s30a** (17-sep, 00:09–03:05) corrió
> las fases 1-4 y las commiteó, corrigió los hallazgos del panel adversarial en la
> plantilla y se quedó sin cuota antes de commitear ese fix, regenerar, desplegar y
> cerrar; **s30b** (17-sep, 08:45→) auditó lo hecho, commiteó el fix, corrió a mano las
> dos lentes que el panel no alcanzó, regeneró, desplegó y cerró. Alcance: 100 %
> presentación; el pipeline (31–34) no se tocó. **Sí** se desplegó a `docs/`. No se tocó
> `feat/contrato-contexto`.
>
> El borrador de este anexo lo escribió s30a en su scratchpad y **sobrevivió** (el
> encargo s30b asumía que se había perdido): s30b lo completó y corrigió sus cifras
> donde las medidas de hoy difieren, en vez de reconstruirlo. Se marca con **[s30b]**
> lo que s30b añadió o cambió.

## 45. Inventario de commits de s30 (s30a y s30b)

| # | Commit | Fase | Rutas |
|---|---|---|---|
| 47 | `d703d20` | 1 — `feat(export): infraestructura de descarga y boton de exportacion` | plantilla |
| 48 | `c03a393` | 2 — `feat(export): CSV del comparador de entidades` | plantilla |
| 49 | `5ccdae2` | 3 — `feat(export): CSV del panorama territorial y de la ficha` | plantilla |
| 50 | `ce91580` | 4 — `feat(export): imagen SVG y PNG del radar de la ficha` | plantilla |
| 51 | `07d2293` | s30b F1 — `fix(export): correcciones posteriores al panel adversarial de s30a` | plantilla |
| 52 | `3969248` | s30b F3 — `build(motor): regenera el motor con la exportacion` | `40_salidas/motor_idps.html` |
| 53 | `b7fc213` | s30b F3 — `deploy(docs): publica la exportacion CSV e imagen` | `docs/index.html` |
| 54 | (este) | s30b F4 — `docs(log): registro de s30a y cierre de la exportacion` | log (§44–§49) + `ESTADO.md` + los dos encargos |

Rama `feat/contrato-contexto` y su log (`20260711_contrato_contexto_idps_log.md`, sin
seguimiento en el árbol) **no se tocaron**. Los commits 47-50 son de s30a; 51-54 de
s30b. Entre 50 y 51 no hubo push: `origin/main` estuvo en `98fc4d3` hasta el cierre.

**[s30b] Fase 0 — auditoría de lo hecho, antes de tocar nada.** Todas las mediciones del
encargo s30b §1 se confirmaron; se reporta cada una:

| # | Verificación | Resultado |
|---|---|---|
| 0.1 | Git | `HEAD ce91580`, 4 ahead de `origin/main 98fc4d3`; los cuatro commits tocan solo `35_motor_template.html`; sin `.git/index.lock`. |
| 0.2 | Sintaxis | Bloque `text/babel` transpilado con `@babel/standalone` **7.29.0** y presets `env,react` (los del motor): **OK**, 1.960 líneas → 167.314 bytes. |
| 0.3 | Plantilla → motor | Las 13 funciones de exportación están en los dos con el mismo conteo, pero el bloque JSX **no era byte-idéntico**: un comentario de cuatro líneas (el de `clonarSvgResuelto`) estaba en otra posición en el motor —un estado intermedio de la edición del `rgba`—, misma longitud total, misma función. La plantilla era la correcta. **Se regeneró en la Fase 3** para que el motor publicado corresponda byte a byte a la plantilla commiteada. |
| 0.4 | Payload | `HEAD:40_salidas/motor_idps.html` vs el sin commitear: 59.466.778 bytes, **un solo offset** (el 38, día de `fecha_generacion`), SHA-256 normalizado `1e29c2b5…` idéntico a §8.2. `docs/index.html` tenía el md5 del motor de s29i (`5ac4a1b8…`): desactualizado, como decía el encargo. |
| 0.5 | Criterios por muestreo (Chrome headless, motor por `file://`, Blob interceptado) | Caso exigido reproducido **dígito a dígito** (§47.3). BOM `ef bb bf` en los bytes; `;`; CRLF (240 en el panorama, 0 `\n` sueltos); `numCSV(78.4)="78,4"`; `aCSV` escapa `"` como `""` y entrecomilla el salto de línea. Los cuatro botones disparan descarga (§47.7). Sufijo `_gse_1` con un solo GSE visible y predicción 40 = real 40. Consola limpia, cero `alert`, cero `confirm`. |
| 0.6 | Diff sin commitear (9 hunks) | Leídos uno a uno contra la tabla del panel (§47.10) más el `rgba` (hallazgo propio); todos los identificadores nuevos en alcance (`cmpTerrs`, `cmpEEs`, `eeGse`, `visGse`, `EST_EE`, `DATA.dimensiones`, `gseVis`). Ejecutado sobre el JSX real transpilado con el payload real: `nFilasFicha` = `filasFichaCSV` en **24 casos** (12 RBD × 2 niveles, 91 filas todos); `DATA.dimensiones.length` (11) = suma de `dimsByInd` (11); `estadoVsGse` da la misma glosa por la ficha y por llamada directa en tres celdas con `sigdifgru` nulo (RBD 35, ind 1-3); la divergencia declarada de §47.9 se reprodujo exacta: 26.328 con puntaje, 3.495 sin `sigdifgru`, 13,3 %, distribución `{0: 12315, 1: 5517, -1: 5001, null: 3495}`. |

Nada de lo auditado se rehízo. Lo único que falló (0.3) se resolvió regenerando, que es
lo que la Fase 3 pedía de todos modos si la plantilla cambiaba.

## 46. Qué se cambió

s30a implementa **P-EXPORTACION** (§43): poder llevarse lo que se está viendo en vez de
capturar la pantalla. Todo es plantilla: ninguna fase toca el pipeline, y el payload no
se mueve (§47.2). Del motor hermano `slep_simce_adecuado` se copió la **forma**
—`descargarBlob` (~2981), `IconExport` (~2721), el mapa de iconos (~1743),
`rasterizarSvgAPng` (~3007), el saneo NFD del nombre de archivo (~3394)— y los valores
de dominio se leyeron de este motor, como manda la regla de §44.

**Fase 1 — infraestructura.** Las decisiones metodológicas van como constantes
nombradas (POLITICA §5.3, punto 10) y no como literales sueltos por el JSX: `CSV_SEP`
`";"`, `CSV_DEC` `","`, `CSV_EOL` el CRLF de RFC 4180, `CSV_BOM` como el escape `\ufeff` y
`CSV_AVISO_FILAS` = 10.000. `aCSV()` entrecomilla según RFC 4180 y antepone el BOM, que
es lo que hace que Excel en locale español abra el archivo en columnas y con los acentos
correctos. `numCSV()` pone coma decimal y **quita** el separador de miles: `fmt()` es
capa de pantalla y sí escribe "6.717", que en una celda numérica Excel leería como
decimal. `slugArchivo()` descompone en NFD y retira diacríticos **antes** de sanear, de
modo que "Región de Valparaíso" da `region_de_valparaiso` y no `regi_n_de_valpara_so`;
la ñ se resuelve por el mismo camino (NFD la parte en "n" más tilde combinante).

**Fase 2 — CSV del comparador.** El botón vive en `.gse-filter-wrap`, al lado del
segmentador de GSE, en la misma posición relativa que en el hermano (cuyo
`.section-actions` junta `GseFilter` y el `IconExport` de la tabla). La garantía de que
el archivo no puede divergir de la tabla es **estructural**: `filasComparadorCSV` no
recalcula el universo, recibe los MISMOS arreglos con los que `Comparador` dibuja
—`cmpTerrs`, `cmpEEs`, `rosters`, `eeGse`, `visGse`— y los recorre en el mismo orden.
Dos tipos de fila distinguidos por la columna `tipo`, con el encabezado como unión de
sus columnas (22): la de territorio lleva conteos y porcentajes, la de establecimiento
lleva puntaje y estado. Los porcentajes son los de `pctRound`, los mismos que pinta
`StackedBar`, y con N=0 las tres celdas quedan **vacías**: `pctRound` sobre un total de
0 devolvería un 34/33/33 inventado, y la barra en ese caso dice "sin dato".

**Fase 3 — CSV del panorama y de la ficha.** El panorama recorre `grupos`, el mismo
arreglo ya agrupado por GSE y ordenado por nombre con el que la pantalla dibuja
secciones y tarjetas, así que el orden del archivo es el de la vista. A nivel nacional
el botón **sigue disponible**: la restricción de s29i era de render, no de datos. La
ficha recorre el eje contiguo recortado por familia (`meta.primer_anio_familia`:
indicador desde 2014, dimensión desde 2018).

**Fase 4 — imagen del radar.** Aquí está la diferencia real entre los dos motores, y es
lo que acota la fase: en el hermano **todos** los gráficos son SVG y por eso puede
componer un SVG grande y rasterizarlo; en `slep_idps` solo el **radar** de la ficha es
SVG (D3), mientras las barras del panorama y las celdas del comparador son HTML/CSS. La
imagen se ofrece solo sobre el radar y solo en la Vista actual; en la histórica, donde
no hay radar, va un aviso de una línea en vez de dos botones desaparecidos.

El radar no se puede serializar tal cual: toma su estilo de dos sitios que un SVG suelto
no tiene —clases del documento (`.ring`, `.axis-lab`) y custom properties en atributos
(`stroke="var(--linea)"`)— y fuera del documento `var()` no resuelve y el trazo
desaparece. `clonarSvgResuelto` clona resolviendo `getComputedStyle` a atributos
literales, y devuelve un `<g>` y **no** un `<svg>` anidado: un svg interior recorta a su
viewport y se comería las etiquetas de eje, que el radar dibuja fuera del cuadro con
`overflow:visible`. Los colores del export se **derivan** de `:root` (`tokenCSS`), no se
escriben a mano; las fuentes son una pila de sistema, como en el hermano, porque las OTF
de marca van embebidas en el HTML y un SVG rasterizado dentro de un `<img>` no las
tiene.

## 47. Chequeos de s30a y s30b (valores observados)

### 47.1 Build limpio (regla de detención 3 — no se dispara)

`Rscript -e 'source("00_build.R"); run_all(only = 35L)'` → **OK, exit 0**, paso 35 en
**4,0 s**, sin warnings nuevos. La salida informativa es la de siempre: `[NOMBRES] saneo
OK: 0 nombres con U+00B4/U+005E/U+0060; 68 EE con nombre curado`, `[H6] Dependencia
reclasificada en 192 RBD`, `[s21] prom_gse: 69646 con valor, 296738 NA`,
`[s14] primer_anio_familia: ind=2014 dim=2018 niv=2023`, `[s19] grados_ee: índice para
9103 establecimientos`. HTML de **5,2 MB**.

**[s30b]** Segundo build, el que se publicó: `run_all(only = 35L)` → **exit 0**, paso 35 en
**4,2 s**, la misma salida informativa línea por línea. Motor de **5.431.955 bytes**, md5
`2f34dafe1309b67e5e1e1cfb3eea47a3`. Bloque JSX del motor **byte a byte igual** al de la
plantilla en `07d2293` (verificado extrayendo los dos bloques y comparándolos), CSS de
la plantilla contenido entero en el motor, `grep -c text-transform` = 0.

Antes del build, cada fase se validó con el **mismo Babel y los mismos presets** que usa
el motor en el navegador (`@babel/standalone` 7.29.0, `presets: env,react`), transpilando
el bloque `<script type="text/babel">` completo en node. Es un instrumento nuevo de esta
sesión y conviene dejarlo escrito: sin él, un error de sintaxis del JSX solo aparece
después de regenerar y abrir el motor.

### 47.2 Fidelidad del payload — cero movimiento (regla de detención 2 — no se dispara)

Convención de §8.2, aplicada sobre el motor de `98fc4d3` y el regenerado:

```
magic zlib:  789c / 789c
bytes JSON:  59.466.778  ==  59.466.778
offsets que difieren: [38]
  off 38: '6' -> '7'
  contexto: ...fecha_generacion":"2026-09-16","cobertur  ->  ...fecha_generacion":"2026-09-17","cobertur

SHA-256 normalizado (fecha_generacion -> "0000-00-00", UTF-8 sin salto final):
  1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6   antes y después
```

Un solo offset distinto en 59,4 MB: el dígito del día. El hash coincide con el que §8.2
dejó escrito y que §41.3 reverificó. Ninguna cifra se movió.

### 47.3 Fidelidad del CSV — el caso exigido por el encargo (§6.2)

Exigido: para Chile + SLEP Costa Central en 4° básico, GSE Bajo, indicador 1, los
conteos y porcentajes del CSV deben coincidir **exactamente** con los que pinta la barra.
Medido en una sola sesión de Chrome: se agregaron las dos entidades por la interfaz real
(modal → tab Nacional → fila única; tab SLEP → buscar "Costa Central"), se leyó el
`aria-label` de las barras en pantalla y se pulsó el botón, interceptando el Blob.

**En pantalla** (`aria-label` de `.s100`, sección "Bajo", primera columna):

```
Chile              — Distribución de 1355 establecimientos con dato:
                     ▼ 233 (17%);  = 890 (66%);  ▲ 232 (17%)
SLEP Costa Central — Distribución de 10 establecimientos con dato:
                     ▼ 6 (60%);    = 3 (30%);    ▲ 1 (10%)
```

**En el CSV descargado en ese mismo clic** (`idps_comparador_4b_2025.csv`, 5.105 bytes):

```
tipo;entidad;tipo_entidad;dependencia;rbd;comuna;gse;gse_label;indicador;indicador_label;n_con_dato;n_bajo;n_neutro;n_sobre;pct_bajo;pct_neutro;pct_sobre;puntaje;estado_vs_gse;nivel;anio;preliminar
territorio;Chile;nacional;;;;1;Bajo;1;Autoestima Académica y Motivación Escolar;1355;233;890;232;17;66;17;;;4° básico;2025;1
territorio;SLEP Costa Central;slep;;;;1;Bajo;1;Autoestima Académica y Motivación Escolar;10;6;3;1;60;30;10;;;4° básico;2025;1
```

Coinciden dígito a dígito. Verificaciones complementarias sobre el mismo archivo: las
36 filas con porcentaje suman 100 exacto, y `n_bajo + n_neutro + n_sobre == n_con_dato`
en las 40 filas de territorio.

### 47.4 El CSV en Excel con configuración regional española (§6.3)

- **BOM**: los tres primeros bytes de cada archivo descargado son `ef bb bf`, medidos con
  `blob.arrayBuffer()` en el navegador. (Con `blob.text()` el BOM no aparece: el
  decodificador UTF-8 del estándar lo retira al decodificar. Hay que mirar los bytes.)
- **Separador**: `;`, 21 ocurrencias por fila en el comparador (22 columnas), 12 en el
  panorama, 9 en la ficha.
- **Fin de línea**: CRLF.
- **Acentos**: `Peñaflor`, `Región de Valparaíso`, `Autoestima Académica y Motivación
  Escolar` y `Participación y Formación Ciudadana` se leen correctamente.
- **Decimal coma**: el mecanismo está (`numCSV(78.4) → "78,4"`, `numCSV(-3.5) → "-3,5"`,
  `numCSV(1234.5) → "1234,5"`, sin separador de miles), pero **ninguna celda del CSV de
  hoy lo ejercita**: el payload vigente trae todos los puntajes como enteros (medido: el
  conjunto de longitudes decimales de `ind.prom`, `dim.prom` y `niv` es `{0}`). Conviene
  decirlo antes que dar por probado algo que no se probó con dato real.
- **Entrecomillado**: `aCSV([["a;b","dice \"hola\"","normal"]])` da
  `"a;b";"dice ""hola""";normal`.

### 47.5 Auditoría de contraste de los botones nuevos (§6.4)

Método de s29d–s29g: color y fondo **efectivos** leídos con `getComputedStyle` sobre el
motor generado, subiendo por los ancestros hasta el primer fondo opaco.

| Elemento | Color | Sobre | px / peso | Ratio |
|---|---|---|---|---|
| `.btn-export` "Exportar CSV" (panorama y comparador) | `rgb(10, 58, 92)` `--azul` | `#ffffff` `.btn-export` | 14 / 700 | **11,847** |
| `.btn-export` "CSV de la serie", "Radar en SVG", "Radar en PNG" | `rgb(10, 58, 92)` | `#ffffff` | 14 / 700 | **11,847** |
| `.export-bar-lab` "Exportar" | `rgb(92, 102, 110)` `--gris` | `#fffdf7` `--panel` | 14 / 700 | **5,766** |

En hover el fondo pasa a `--cream-200` (`#f4e9cc`): `--azul` da **9,801** ahí, el peor
caso de la serie y muy por encima de AA. El anillo de foco usa `--foco` (`#0062A0`):
6,45 sobre `--paper`, 5,34 sobre `--cream-200`.

El borde va en `--border-2`, que da 1,37 sobre blanco y no alcanza el 3:1 de WCAG 1.4.11.
No se corrige y conviene decir por qué: es la convención ya vigente en `.nav-trigger`,
`.estab-popup-btn`, `.gfb` y `.cmp-chip`, y el control se identifica por su **texto**,
no por el borde —a diferencia del `.icon-export` del hermano, que oculta el rótulo hasta
el hover y sí depende del contorno. Cambiar el token de borde sería una línea de trabajo
propia sobre todo el motor, no un añadido de esta fase.

### 47.5bis Accesibilidad y comportamiento en anchos extremos

El botón es un `<button type="button">` nativo con `aria-label`, `title` explicativo y el
icono marcado `aria-hidden="true"` y `focusable="false"`. En el árbol de accesibilidad de
Chrome aparece como `{role: "button", name: "Exportar CSV"}`. Se alcanza con **6
pulsaciones de Tab** desde el primer tab de pantalla y se activa tanto con **Enter** como
con **Espacio**; las dos disparan la descarga (comprobado interceptando el Blob). El
anillo de foco es `rgb(0, 98, 160) solid 2px` con 2px de separación, es decir `--foco`.

Medido a **430, 760, 980, 1180 y 1400px**: en ninguno hay scroll horizontal del documento,
ningún elemento de la barra se sale del contenedor, el botón conserva 138×33 y nunca se
solapa con el segmentador de GSE. La barra de la ficha envuelve a tres filas a 430px y a
dos desde 760px. Cero `pageerror` en las cinco corridas.

### 47.6 Regla de etiquetado de s29 — intacta y sin moverse

Se ejecutó el mismo extractor sobre el motor de `98fc4d3` y sobre el regenerado, a
1400px, en el panorama de apertura (SLEP Costa Central, 4° básico, 2025):

```
Bajo       | 60% (6)/30% (3)/10% (1) || 60% (6)/20% (2)/20% (2) || 50% (5)/40% (4)/10% (1) || 40% (4)/50% (5)/10% (1)
Medio bajo | 19% (4)/71% (15)/10% (2) || 43% (9)/48% (10)/9% (2) || 28% (6)/48% (10)/24% (5) || 38% (8)/48% (10)/14% (3)
Medio      | 32% (9)/61% (17)/7% (2) || 41% (11)/55% (15) EXT:▲ 4% (1) || 36% (10)/50% (14)/14% (4) || 36% (10)/61% (17) EXT:▲ 3% (1)
Medio alto | 100% (1) || 100% (1) || 100% (1) || 100% (1)
```

**Idéntico** antes y después, incluidas las dos bajadas a la tira externa. El banner
tampoco se movió (60 establecimientos · 4° básico · 5 de 5 GSE · 2025 preliminar). La
barra de exportación no desplaza el segmentador: medido en layout, el botón queda en la
fila del rótulo (y=15 dentro del contenedor) y las pastillas en la suya (y=58), sin
solaparse, con el botón a 17px del borde derecho.

`grep -c text-transform` sobre la plantilla: **0**. Los rótulos nuevos solo llevan
mayúsculas sostenidas en siglas (CSV, SVG, PNG, GSE), como manda la regla de s29i.

### 47.7 Verificación funcional en navegador (Chrome headless, consola limpia)

Instrumento: Puppeteer 25.9.0 tomado por `NODE_PATH` de
`/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del
sistema, motor abierto por `file://`, viewport 1400×1100. Las descargas se interceptan
parcheando `URL.createObjectURL` y `HTMLAnchorElement.prototype.click`, de modo que se
lee el Blob real que el motor entrega.

| Acción | Archivo | Resultado |
|---|---|---|
| Panorama (SLEP Costa Central) → Exportar CSV | `idps_panorama_slep_costa_central_4b_2025.csv` | 241 líneas (60 EE × 4 + 1), **32.465 bytes** [s30b: medido sobre el motor publicado; s30a había medido 32.313 antes de la glosa nueva, más larga que "sin diferencia"], BOM `ef bb bf` |
| Ficha RBD 11853 → CSV de la serie | `idps_ficha_11853_4b.csv` | **12.338 bytes** [s30b: sobre el motor publicado; s30a midió 12.621 con la glosa anterior, más larga], 91 filas de dato, 9 años (2014-2018, 2022-2025) |
| Ficha → Radar en SVG | `idps_radar_11853_4b_2025.svg` | 656×459, 13,2 KB |
| Ficha → Radar en PNG | `idps_radar_11853_4b_2025.png` | 1312×918 (2x), 174 KB |
| Comparador (Chile + SLEP) → Exportar CSV | `idps_comparador_4b_2025.csv` | 5.105 bytes, 41 líneas |
| Vista histórica | — | solo el botón de CSV y el aviso "La imagen del radar se descarga desde la Vista actual." |
| Comparador vacío | — | botón desactivado (`disabled`), en vez de entregar un archivo con solo el encabezado |

**Consola: cero errores y cero warnings** en todas las corridas; cero `alert()`.

Auditoría del SVG generado: `var(--` **no aparece**, tampoco `class=` ni `style=`; un
solo `xmlns`; los anillos salen con `stroke="rgb(228, 220, 198)"`, que es `--linea`
resuelto; 13 `<circle>` (5 anillos + 4 vértices del EE + 4 del GSE), 10 `<text>` y 8
`<tspan>` (etiqueta y valor de cada eje); cero referencias a las fuentes de marca; y
**cero `rgba()`**, tras la corrección de §47.10.

**Radar sin ningún dato.** RBD 12664 (Escuela San Santiago de Macaya, Pozo Almonte) no
tiene un solo indicador con puntaje en ningún grado ni año: su radar dibuja los cinco
anillos y ningún vértice. Los tres botones siguen funcionando —CSV de 11.234 bytes, SVG
de 9.687, PNG de 146.553— sin `alert`, sin error de consola y sin `pageerror`. La imagen
sale con las cuatro etiquetas de eje, un `—` bajo cada una y sin la leyenda del GSE,
exactamente como el radar en pantalla.

### 47.8 Tamaño del panorama nacional

`idps_panorama_chile_4b_2025.csv` son **26.868 filas** (6.717 establecimientos × 4
indicadores) y **3,75 MB** de texto. Supera `CSV_AVISO_FILAS` (10.000), así que
`confirmarTamano` pide confirmación diciendo la cifra antes de generar, como pide el
encargo §4. Una región grande no llega al umbral.

### 47.9 Hallazgo del dato: la comparación vs GSE no existe en toda la serie

Al escribir el CSV apareció algo que el encargo no anticipaba y que estuvo a punto de
colarse como una afirmación inventada. Medido sobre el payload, en 4° básico:

| año | filas | `difgru` nulo | `sigdifgru` nulo | `prom_gse` nulo |
|---|---|---|---|---|
| 2014–2023 | 233.592 | **100 %** | **100 %** | **100 %** |
| 2024 | 28.740 | 5.751 (20,0 %) | 5.751 | 5.751 |
| 2025 | 26.868 | 4.035 (15,0 %) | 4.035 | 4.035 |

La Agencia publica la comparación con el GSE **desde 2024**, y dentro de 2024–2025 sigue
nula para el establecimiento sin grupo de comparación: son dos causas distintas de la
misma ausencia.

La primera versión de los tres constructores clasificaba con
`sigdifgru === -1 ? bajo : sigdifgru === 1 ? sobre : neutro` —el patrón de `CeldaEE` y
`alertSummary`— y por lo tanto escribía **"sin diferencia"** donde no hay ninguna
comparación que informar. Se corrigió en dos tiempos, y el segundo lo forzó el panel
(§47.10): primero solo en la ficha, lo que dejó al panorama y a la ficha **diciendo
cosas distintas de la misma celda** (mismo RBD, mismo indicador, mismo año); después,
en una sola función `estadoVsGse` que usan las tres exportaciones. Comprobado sobre una
celda real con `sigdifgru` nulo (RBD 1869, indicador 1, 4° básico 2025, puntaje 70): los
tres archivos dicen ahora `sin comparación vs GSE publicada`.

La glosa **no nombra la causa**, porque son dos y la guarda no las separa. Una que
dijera "ese año" sería falsa para el establecimiento sin grupo de comparación en 2025.
Distinguirlas pide que el build publique el primer año con `difgru`, igual que ya
publica `meta.primer_anio_familia`; queda anotado.

**Divergencia con la pantalla, declarada y reversible.** En ese mismo caso `CeldaEE`
dice "sin diferencia" y el chip de la tarjeta dice "≈ en su GSE", porque `repartoInd` y
`alertSummary` mandan el nulo al cubo neutro: son **3.495 celdas EE × indicador** en 4°
básico 2025, el **13,3 %** de las 26.328 que tienen puntaje. El CSV no las repite. Es la
única divergencia deliberada entre pantalla y archivo de toda la sesión, y se toma
porque el invariante del motor es que el estado vs GSE se **lee** de `sigdifgru`: cuando
ese campo es nulo no hay nada que leer y escribir "sin diferencia" sería **derivar** una
conclusión de una ausencia. No se corrige la pantalla aquí porque cambiaría las cifras
de las barras y de la regla de etiquetado, que este encargo manda conservar; va como
pendiente propio (**P-ESTADO-SIN-COMPARACION**).

### 47.9bis Barrido de estados

Además de los casos puntuales, se generaron **118 combinaciones alcanzables por la
interfaz** —dos niveles × cuatro selecciones de GSE (todos, uno, dos, ninguno) ×
territorios de los cinco tipos, con y sin dependencia, más doce fichas de muestra— y se
comprobó sobre las **26.774 filas de dato** resultantes, con un parser RFC 4180
independiente del que escribe: ancho de fila uniforme e igual al del encabezado, BOM
presente, `n_bajo + n_neutro + n_sobre == n_con_dato`, porcentajes que suman 100 exacto
cuando N>0 y celdas vacías cuando N=0, ningún salto de línea sin escapar y todo nombre
de archivo dentro de `[a-z0-9_]+\.csv` y sin huecos. **Cero problemas.**

También se comprobó que el conteo de filas que predice el aviso previo coincide
**exactamente** con el que produce cada constructor, en los 14 casos probados: si se
desincronizaran, el aviso mentiría.

### 47.10 Panel adversarial

Cinco lentes independientes sobre el diff —fidelidad pantalla↔CSV, formato del CSV,
exportación de imagen, estado de React e interfaz, y cumplimiento del encargo—, cada
hallazgo sometido después a tres refutadores con ángulos distintos (código, dato,
encargo) que arrancan del lado de refutar. El panel se cortó por límite de sesión y las
dos últimas lentes se relanzaron después (§47.12).

**Lo que encontró, y qué se hizo con cada cosa:**

| # | Hallazgo | Gravedad | Resolución |
|---|---|---|---|
| 1 | El CSV escribe "sin diferencia" donde la Agencia no publica comparación vs GSE. **Tres lentes lo levantaron por separado**, y una lo afiló hasta el punto decisivo: la guarda vivía solo en la ficha, así que el panorama y la ficha **decían cosas distintas de la misma celda**, a un clic de distancia. | alta | **Corregido.** Una sola función `estadoVsGse` para las tres exportaciones (§47.9). El propio refutador de la ronda siguiente lo verificó ejecutando el código nuevo sobre RBD 1008 y confirmó que los tres archivos coinciden. |
| 2 | La glosa decía "…**ese año**", atribuyendo al año una ausencia que en 2024-2025 es del establecimiento (sin grupo de comparación). | media | **Corregido.** La glosa pasó a `sin comparación vs GSE publicada`, que no nombra una causa que la guarda no distingue. |
| 3 | `confirmarTamano` se llamaba **después** de construir las filas: el aviso decía "puede tardar unos segundos en generarse" cuando la generación ya había ocurrido, y no ahorraba nada. | baja | **Corregido.** Cada exportación predice el conteo con la misma aritmética que recorre su constructor, verificado contra el real en 14 casos. |
| 4 | El nombre del CSV del panorama no recogía el filtro de GSE: dos universos distintos producían el mismo archivo. Dos lentes. | media/baja | **Corregido.** Sufijo `_gse_<códigos>` cuando no están los cinco. |
| 5 | El "CSV de la serie" de la ficha no tiene guarda: para un establecimiento sin ninguna medición entrega 91 filas sin un solo puntaje. | baja | **No se corrige.** Es fiel a la pantalla, que en ese caso también muestra "sin dato" en todo (comprobado con RBD 12664). Va a pendientes. |

Los veredictos de los refutadores de esa ronda hay que leerlos con cuidado: leyeron el
archivo **mientras se estaba corrigiendo**, así que varios dicen "refutado contra el
estado actual" sobre hallazgos que eran correctos cuando se emitieron. El juicio útil es
el de los que verificaron el dato, y ahí no hubo ninguna cifra inventada: los recuentos
del hallazgo 1 (26.328 con puntaje, 3.495 sin `sigdifgru`, 900 establecimientos
distintos, distribución `{0: 12315, 1: 5517, -1: 5001, null: 3495}`) se reprodujeron
exactos de forma independiente.

**Hallazgo propio, fuera del panel.** Revisando el SVG generado apareció que el relleno
del polígono salía como `fill="rgba(10, 58, 92, 0.1)"`. Chrome lo pinta —el PNG estaba
bien—, pero un color con alfa **no es un valor válido de atributo de presentación en SVG
1.1**, y un editor vectorial estricto lo descarta: el relleno se perdería o caería a
negro justo al abrir el archivo en la herramienta para la que se exporta un SVG. Se
separa en `fill="rgb(10, 58, 92)"` más `fill-opacity="0.1"`. Comprobado sobre el SVG
regenerado: cero `rgba()`, y el PNG sale idéntico.

### 47.10bis [s30b] Las dos lentes que el panel no corrió, verificadas en directo

El encargo s30b prohibió relanzar paneles (la cuota de s30a se fue en 12 a 33 agentes)
y pidió las dos lentes **a mano, acotadas y deterministas**. Se corrieron en la Fase 2,
es decir sobre el motor sin commitear de s30a (bloque JSX funcionalmente idéntico al de
la plantilla, ver 0.3; el regenerado de la Fase 3 repitió después el muestreo de 0.5 con
salida idéntica), en Chrome headless (Puppeteer 25.9.0, Chrome del sistema, `file://`,
1400×1100), interceptando el Blob real que el motor entrega; los archivos se validaron
después con herramientas **ajenas a Chrome**: `xmllint` (XML bien formado),
`rsvg-convert` (librsvg 2x, renderizador independiente) e ImageMagick (`compare -metric
AE`). Ninguna de las dos encontró un defecto: **no hubo commit de la Fase 2**.

**Lente imagen.** Cinco establecimientos elegidos por el dato, exportados por los botones
reales: RBD **11853** (normal, 4 de 4), **12664** (Escuela San Santiago de Macaya: sin un
solo indicador con puntaje en ningún grado ni año), **14** (Escuela Romulo J. Pena
Maturana: 3 de 4, sin GSE), **16843** (Liceo Bicentenario … People Help People de
Panguipulli: nombre de 86 caracteres, rama del cuadro adaptativo) y **144** (4 de 4,
Iquique).

| RBD | SVG (px) | PNG 2x (px, bytes) | `xmllint` | `xmlns` | `rgba(` | `var(--` | `class=`/`style=` | AE PNG motor vs render Chrome del **archivo** SVG |
|---|---|---|---|---|---|---|---|---|
| 11853 | 656×459 | 1312×918, 174.621 | OK | 1 | 0 | 0 | 0 | 1,5 px de 1.204.416 |
| 12664 | 560×459 (W_MIN) | 1120×918, 146.553 | OK | 1 | 0 | 0 | 0 | 0,03 px de 1.028.160 |
| 14 | 560×459 | 1120×918, 149.831 | OK | 1 | 0 | 0 | 0 | 1,2 px |
| 16843 | 853×459 (< W_MAX 900) | 1706×918, 192.937 | OK | 1 | 0 | 0 | 0 | 1,7 px de 1.566.108 |
| 144 | 611×459 | 1222×918, 167.942 | OK | 1 | 0 | 0 | 0 | 19,3 px de 1.121.796 |

- **SVG 1.1.** La raíz lleva `width`, `height` y `viewBox`. El inventario de atributos es
  el mismo en los cinco archivos y todos son atributos de presentación válidos en 1.1:
  `cx cy d dominant-baseline dy fill fill-opacity font-family font-size font-style
  font-weight height letter-spacing opacity r stroke stroke-dasharray stroke-linecap
  stroke-linejoin stroke-opacity stroke-width text-anchor transform width x y`. Todos
  los colores son `rgb(r, g, b)` o `#hex` o `none`; el polígono del establecimiento sale
  como `fill="rgb(10, 58, 92)"` + `fill-opacity="0.1"` (la corrección de §47.10). Los
  anillos: `stroke="rgb(228, 220, 198)"` (= `--linea` resuelto).
- **PNG con el mismo contenido.** Es estructural —`exportarRadarPNG` rasteriza el mismo
  `svgStr` que `exportarRadarSVG` descarga— y se midió: el PNG del motor contra una
  captura a 2x del **archivo** SVG exportado, abierto en una página limpia (sin el CSS,
  las fuentes ni los tokens del motor), difiere en 0,03 a 19,3 píxeles sobre 1,0 a 1,6
  millones (< 0,002 %; antialiasing subpíxel). librsvg dibuja los cinco archivos con
  5-10 % de píxeles distintos del fondo, es decir con contenido; sus diferencias con
  Chrome (0,7-1,2 % a `fuzz 10%`) son rasterizado de texto, como corresponde a otro motor
  de fuentes.
- **Establecimiento sin ningún dato (12664).** Exporta sin `alert`, sin `pageerror`, sin
  error de consola. El SVG trae los 5 anillos, las 4 etiquetas de eje con `—` debajo, la
  identidad con `GSE —`, la leyenda **solo** con el trazo del establecimiento (sin la
  línea del GSE, porque `hasGse` es falso) y un `<path>` sin `d` (D3 no genera trazo sin
  puntos; es válido). Legible, y exactamente lo que el radar muestra en pantalla.
- **Parcial (14).** El radar vivo y el exportado tienen el mismo inventario (8 `circle`,
  1 `path`, 4 `text`, 8 `tspan`); en los dos, Autoestima queda como vértice aislado y
  Hábitos–Participación como segmento, porque el generador de línea de D3 corta donde
  falta el vecino (`defined`). Es conducta del **radar**, previa y de pantalla; el
  exportador la copia. Se anota como observación, no como defecto de esta línea.
- **Nombre largo (16843).** El cuadro creció a 853 px y el título salió entero, sin
  `…`: la medición en canvas de `_medirExport` hizo lo que §48.17 dice.

**Lente estado de React.** Una sola sesión de Chrome, **24 pasos** encadenados; tras
cada cambio se exporta y el archivo se compara con el DOM leído **en ese instante**
(conjunto de RBD de las tarjetas, secciones GSE dibujadas, nivel marcado, chips del
comparador, filas de cada sección, identidad de la ficha y los valores del radar
vivo). **24 de 24 OK**, consola limpia, cero `alert`, cero `confirm`.

| Paso | Estado provocado | Criterio verificado |
|---|---|---|
| P1 | Apertura: SLEP Costa Central, 4° básico | 60 tarjetas ↔ 60 RBD × 4 filas; secciones {Bajo, Medio bajo, Medio, Medio alto} = `gse_label` del CSV (el toggle "Alto" está encendido pero el SLEP no tiene EE en ese grupo, y el CSV no lo inventa) |
| P2 | Modal de territorio abierto y **cancelado** | CSV byte-idéntico al de P1 |
| P3 | Nivel → 2° medio | 12 EE ↔ 48 filas, columna `nivel` = "2° medio", nombre `_2m_`, año único |
| P4 | Territorio → comuna de Quintero | 5 EE, `comuna` = Quintero en toda fila, nombre `idps_panorama_comuna_de_quintero_2m_2025.csv` (el slug es el de `terrTxt`) |
| P5 | Región de Valparaíso · dependencia Municipal (desde el `<select>` del modal) | 79 EE, chip de dependencia presente, `dependencia` = Municipal en toda fila, nombre `…_region_de_valparaiso_municipal_2m_2025.csv` |
| P6 | Quitar el primer y el último GSE | 60 EE, secciones {Medio bajo, Medio} = CSV, sufijo `_gse_2_3_4` |
| P7 | `✕` del chip de dependencia | 297 EE ↔ 1.188 filas, chip fuera, varias dependencias en el CSV, nombre sin `municipal` |
| C1 | Comparador vacío | Botón `disabled` con su `title` |
| C2 | + Chile + SLEP Costa Central + Quintero | Entidades del CSV = chips; por cada sección GSE, las entidades del CSV = filas de la tabla; el comparador tiene **su propio nivel** (4° básico), no hereda el del panorama, y el CSV lo dice |
| C3 | `✕` SLEP Costa Central | Solo Chile y Quintero |
| C4 | Nivel del comparador → 4° básico | `nivel` y nombre `_4b_` |
| C5 | Solo el GSE Medio visible | `gse_label` = {Medio} |
| C6 | + establecimiento RBD 14 (GSE Bajo) con solo Medio visible | El chip está, la tabla no lo dibuja, `.cmp-nota-ee` lo avisa y el CSV **no** lo exporta (0 filas de tipo establecimiento) |
| C7 | GSE Bajo visible otra vez | 4 filas de establecimiento con `rbd` = 14 |
| C8 | Modal del comparador abierto y cerrado con "Listo" sin tocar nada | CSV byte-idéntico al de C7 |
| F1 | Ficha 11853, Vista actual | `rbd`, `establecimiento` y `nivel` = cabecera; los cuatro puntajes de 2025 del CSV = los del radar vivo (83, 83, 84, 78); tres botones |
| F2 | Vista histórica | CSV byte-idéntico al de F1 (§48.8); un solo botón y la nota "La imagen del radar se descarga desde la Vista actual."; sin radar en el DOM |
| F3 | Ficha 14 abierta **después** de la 11853 | `rbd` = 14, valores del CSV = radar vivo (77, —, 81, 70), nombre `idps_ficha_14_4b.csv` |
| F3b | Radar SVG de la 14 | Nombre `idps_radar_14_4b_2025.svg`; el SVG contiene el nombre del EE |
| F4 | Ficha **22464** (Liceo Bicentenario de Excelencia de Dalcahue, primer resultado de la búsqueda), nivel → 2° medio | `nivel` = "2° medio", nombre `idps_ficha_22464_2m.csv`, valores = radar (71, 74, 74, 72) |
| F4b | Radar SVG en 2° medio | Nombre `idps_radar_22464_2m_2025.svg`, subtítulo con "2° medio" |
| P8 | Vuelta al panorama tras ficha y comparador | Estado conservado (región, 2° medio, 3 GSE) y CSV byte-idéntico al de P7 |
| C9 | Vuelta al comparador | CSV = pantalla y byte-idéntico al de C8 |
| C10 | `↺` limpiar entidades | Cero chips, botón `disabled` |

Ningún paso dejó al exportador leyendo la selección anterior: las tres exportaciones
reciben los mismos arreglos con los que la pantalla dibuja (§46), y eso es lo que las
24 comparaciones confirman.

**Nota sobre el instrumento.** La primera corrida marcó 12 pasos como fallidos; los
doce eran del **chequeo**, no del motor: un diccionario de verificación con valores no
booleanos (el año, los puntajes) y una suposición falsa del ejecutor —que los toggles de
GSE encendidos deben coincidir con los GSE del CSV, cuando lo que la pantalla muestra
son las **secciones** con establecimientos—. Se corrigió el chequeo y se repitió entero.
Se deja escrito por la regla 0.5: un verificador que falla por su propia cuenta se parece
demasiado a un motor que falla.

**Lo que NO se hizo, dicho antes que se infiera:** ninguna revisión adversarial
multiagente sobre estas dos lentes. Si el titular la quiere, es un encargo propio.


### 47.11 Despliegue (regla de detención 4 — no se dispara)

**[s30b]** `docs/index.html` = copia byte a byte de `40_salidas/motor_idps.html`,
verificada con `cmp` (sin diferencias) y `md5` (`2f34dafe1309b67e5e1e1cfb3eea47a3` en
los dos), **5.431.955 bytes**. Antes del despliegue `docs/index.html` era el motor de
s29i (`5ac4a1b8…`, 5.393.686 bytes). El muestreo de la Fase 0.5 se repitió sobre el
motor regenerado antes de commitearlo: salida idéntica a la del motor sin commitear
salvo el conteo de nodos del DOM (que no es del archivo).

### 47.12 Errores del ejecutor en s30a y s30b (regla 0.5)

| # | Qué pasó | Cuándo se detectó | Efecto |
|---|---|---|---|
| 1 | Al escribir el código se colaron **caracteres invisibles literales** en el fuente: un U+FEFF como valor de `CSV_BOM` y el rango de diacríticos de `slugArchivo` escrito con combinantes reales en vez de `\u0300-\u036f`. | Por un chequeo propio antes del primer commit | Ninguno en el motor publicado: el archivo quedó con escapes explícitos. El riesgo era real: un carácter invisible en el fuente sobrevive a un diff sin verse. |
| 2 | La guarda del `sigdifgru` nulo se aplicó **solo en la ficha**, dejando al panorama y a la ficha diciendo cosas distintas de la misma celda. | Por el panel adversarial, no por el ejecutor | Contradicción interna entre dos archivos del mismo motor, corregida antes del build definitivo con una función única. Es el hallazgo más valioso de la sesión y no salió de la revisión propia. |
| 3 | El aviso de tamaño se llamaba **después** de construir las filas, contradiciendo su propio texto y el encargo. | Por el panel | Corregido con un conteo predicho, verificado contra el real en 14 casos. |
| 4 | El mensaje del commit de la Fase 4 decía que el PNG era de `1312x886` cuando el verificado era `1312x918`: la cifra venía de una versión anterior del cuadro. | Al redactar el log | Corregido con `--amend` antes de cualquier push (el commit pasó de `fc02f4d` a `ce91580`). |
| 5 | **[s30a]** El motor regenerado sin commitear quedó con un **estado intermedio** de la plantilla: el comentario de `clonarSvgResuelto` en otra posición (la edición del `rgba` lo dejó huérfano y luego se movió en la plantilla sin regenerar). Función idéntica, bytes distintos. | Fase 0.3 de s30b | Ninguno en lo publicado: se regeneró en la Fase 3 de s30b y el motor desplegado es byte a byte el de la plantilla commiteada. |
| 6 | **[s30b]** La primera corrida de la lente de React marcó 12 falsos fallos por defectos del propio chequeo (valores no booleanos; toggles de GSE frente a secciones). | Al leer el detalle de cada uno | Se corrigió el instrumento y se repitió: 24/24. Lección: mirar el detalle de un FAIL antes de tocar el motor. |
| 7 | **[s30b]** El caso "parcial" de la lente de imagen eligió el RBD **144** (4 de 4) en vez del **14**, porque la búsqueda por "14" calzó primero con "RBD 144". | Al leer el inventario del radar vivo (13 `circle`, no 8) | Se repitió con búsqueda por nombre. El 144 se conservó como quinto caso. |

**Nota de instrumentación.** El panel adversarial se cortó por **límite de sesión** con 14
de 32 agentes caídos, y dos lentes —la de imagen y la de estado de React— no llegaron a
ejecutarse como panel. s30a empezó a correrlas a mano contra la plantilla vigente
(quedan sus scripts en el scratchpad) y se quedó sin cuota; **s30b las reemplazó por las
verificaciones directas de §47.10bis**, deterministas y sin agentes, como mandaba su
encargo. Conviene declararlo antes que dejar creer que la cobertura fue de una sola
pasada o que hubo refutadores sobre esas dos lentes: no los hubo. Los refutadores que sí corrieron leyeron el archivo **mientras se estaba
corrigiendo**, así que varios veredictos dicen "refutado contra el estado actual" sobre
hallazgos que eran correctos cuando se emitieron: el juicio útil de esa ronda es el de
los que verificaron el dato, no el del veredicto final.

### 47.13 [s30b] El aviso `renv::status(): the project is out-of-sync`

Aparece como primera línea de **todo** `Rscript` del proyecto, también del build de la
Fase 3. Medido:

- `renv::status()` → «The following package(s) are used in this project, but are not
  installed: **suitedoc**».
- `suitedoc` lo carga `50_documentacion/suite/documentar.R:21` (`library(suitedoc)`), que
  entró en `c674254` (suite de documentación, julio de 2026). No está en `renv.lock`
  (último snapshot `9d2ba43`, 2026-08-19) ni en `renv/library`; **sí** está en la
  librería del sistema (`system.file(package="suitedoc")` con `--vanilla` la encuentra),
  así que `documentar.R` corre fuera de renv y renv marca el proyecto desincronizado.
- **Es previo a esta línea de trabajo**: está en la primera línea de los cinco logs de
  build que sobreviven de s29g a s29i (16-sep, 11:08 → 21:56) y no lo introdujo s30. No
  afecta al paso 35, que no usa `suitedoc`. No se registró antes en ningún log.

No se toca aquí (regla 3 del encargo original habla de warnings **nuevos**, y este no lo
es; y es decisión del titular): las salidas son `renv::snapshot()` tras instalar
`suitedoc` en la librería del proyecto, o excluir `50_documentacion/suite/` de la
detección (`.renvignore`) si la suite se considera herramienta externa. Va a pendientes.

## 48. Decisiones tomadas dentro del margen del encargo (s30a y s30b)

1. **Un solo archivo para el comparador, con encabezado de unión.** El encargo enumera
   columnas distintas para `tipo = "territorio"` y `tipo = "establecimiento"` pero fija
   **un** nombre de archivo. Se resolvió con 22 columnas, unión de las dos listas: cada
   fila llena las suyas y deja vacías las de la otra naturaleza.
2. **Cada columna de código va con su columna de etiqueta.** `gse`/`gse_label` e
   `indicador`/`indicador_label` en los tres archivos, no solo en el comparador, que es
   donde el encargo los enumera. Razón: la pantalla solo muestra etiquetas, así que un
   código suelto sería exportar algo que nadie ve; y el propio encargo pide `id` y
   `label` juntos para la ficha.
3. **`dependencia` no significa lo mismo en las dos filas del comparador, así que solo
   va en una.** En la fila de territorio es el filtro aplicado a la entidad; una fila de
   establecimiento no está acotada por una dependencia, es un caso único, y se deja
   vacía para no dar dos sentidos a la misma columna. En el panorama, donde toda fila es
   un establecimiento, la columna sí lleva la dependencia del propio EE, que es lo que
   la tarjeta muestra.
4. **Los dos acotes entran en el nombre del panorama: dependencia y selección de GSE.**
   Sin ellos, "Región de Valparaíso", la misma región acotada a Municipal y la misma
   región mostrando solo el GSE Bajo darían **el mismo archivo**, y son tres universos
   distintos. El sufijo de GSE se omite cuando están los cinco, que es el caso de
   apertura: `idps_panorama_region_de_valparaiso_4b_2025_gse_1_3.csv`.
5. **El nombre del comparador no codifica la selección de entidades**, a diferencia del
   panorama. Podrían ser diez, y el nombre se volvería ilegible; el archivo es
   autodescriptivo, porque la columna `entidad` las nombra todas.
6. **Nombres de archivo en minúsculas.** El encargo pide sanear el territorio a
   `[a-zA-Z0-9_]`; POLITICA §2 manda snake_case en minúsculas sin tildes ni ñ para todo
   nombre de archivo. `[a-z0-9_]` cumple las dos.
7. **`<nivel>` es la clave del grado, no su rótulo.** `idps_comparador_4b_2025.csv`:
   sanear "4° básico" daría `4__b_sico`.
8. **El CSV de la ficha no depende de la vista abierta** (declarada y reversible). El
   nombre que fija el encargo —`idps_ficha_<rbd>_<nivel>.csv`— no lleva año ni vista, así
   que el archivo es el **registro** del establecimiento en ese nivel y el toggle es una
   lente sobre el mismo dato; con la lectura contraria, las dos vistas producirían dos
   archivos distintos con el mismo nombre. No se calcula nada nuevo: cada año es la
   misma lectura de `indOf`/`dimOf` que hace la Vista histórica.
9. **La ficha exporta solo los años CON medición.** Un año de pandemia o sin evaluación
   no es un dato ausente sino la ausencia de una medición, y las columnas que el encargo
   fija no tienen dónde decir el motivo; una fila vacía sin explicación mentiría por
   omisión. Va a pendientes: una columna `estado_anio` lo resolvería.
10. **Una sola función `estadoVsGse` para las tres exportaciones**, con tres salidas:
    "sin dato" cuando no hay puntaje, `sin comparación vs GSE publicada` cuando hay
    puntaje pero no hay `sigdifgru`, y las palabras de `EST_EE` cuando sí lo hay. Es la
    corrección que forzó el panel: mientras la guarda vivía solo en la ficha, dos
    archivos del mismo motor decían cosas distintas de la misma celda. El caso del medio
    se resuelve del lado de **no afirmar**, porque el invariante manda **leer**
    `sigdifgru` y de un nulo no se lee nada. Divergencia con la pantalla declarada y
    medida en §47.9.
11. **La glosa no nombra la causa de la ausencia**, porque son dos y la guarda no las
    separa: el año (la Agencia publica la comparación desde 2024) y el establecimiento
    (sin grupo de comparación, también en 2024-2025). Una glosa que dijera "ese año"
    sería falsa en el segundo caso.
12. **`estado_vs_gse` de una dimensión dice "no aplica (solo a nivel indicador)"** en vez
    de quedar vacía, que se leería como "no se pudo calcular". `dimOf` trae
    `prom`/`dif`/`sigdif` pero no `difgru`/`sigdifgru`: el desvío vs GSE solo existe a
    nivel indicador, y es invariante del motor.
13. **El conteo de filas se predice antes de armar el archivo.** El encargo pide avisar
    "antes de generar" y el aviso dice "puede tardar unos segundos en generarse":
    contarlas después de construirlas hacía de ese texto una mentira. Las tres
    predicciones coinciden exactamente con lo que produce cada constructor (§47.9bis).
14. **El rótulo del botón va siempre visible**, a diferencia del `.icon-export` del
    hermano, que lo oculta y lo despliega al hover con un `max-width` animado de 36 a
    220px. Este motor no esconde rótulos tras una interacción, y un cuadrado de 36px no
    se anuncia a sí mismo.
15. **El BOM va como el escape `\ufeff`, no como carácter literal.** El hermano lo tiene
    de las dos formas (`exportarCSV` literal, `exportarPanoramaCSV` escapado); el escape
    sobrevive a cualquier recodificación de la plantilla y se ve en el diff.
16. **`CSV_EOL` es CRLF**, no el `\n` del hermano: es lo que fija RFC 4180 y lo que
    Excel escribe. No hay contrapartida; Excel y R leen ambos.
17. **El cuadro del SVG exportado se adapta al texto entre 560 y 900px**, midiendo cada
    línea en canvas con la fuente del export, en vez de truncar para respetar un ancho
    fijo: truncar la línea de identidad se comía el nivel y el año. Es el mismo
    instrumento de la regla de etiquetado de s29 —medir en píxeles, no estimar por
    número de caracteres— aplicado a otra fuente.
18. **El `<svg>` clonado se inserta como `<g>`, no como `<svg>` anidado.** Un svg
    interior recorta a su viewport y se comería las etiquetas de eje, que el radar
    dibuja fuera del cuadro con `overflow:visible`.
19. **[s30b] Se regeneró el motor aunque la diferencia con la plantilla fuera un
    comentario.** El encargo s30b permitía no regenerar si la plantilla no cambiaba en
    las Fases 1-2; pero la Fase 0.3 mostró que el motor sin commitear no correspondía
    byte a byte a la plantilla, y publicar un motor que no es el de su plantilla —aunque
    funcione igual— rompe la trazabilidad plantilla → motor → docs. Cuatro segundos de
    build contra una duda permanente.
20. **[s30b] El borrador del log se completó, no se reconstruyó.** El encargo daba el
    borrador por perdido; estaba en el scratchpad de s30a. Reconstruirlo desde los
    commits habría perdido las cifras del panel (§47.10) y las decisiones 1-18, que solo
    s30a vio. Se conservó, se marcó lo añadido con **[s30b]** y se corrigieron las dos
    cifras que hoy difieren (§47.7).
21. **[s30b] Las dos lentes se corrieron como verificaciones directas, no como panel.**
    Lo mandaba el encargo; y lo que las lentes preguntan (¿es válido el SVG?, ¿el CSV
    sigue a la pantalla?) tiene respuesta determinista con `xmllint`, librsvg,
    ImageMagick y un DOM leído en el mismo instante. Un refutador aportaría ángulos que
    no se pensaron; se anota como pendiente, no se simula.

## 49. Pendientes tras s30 (s30a y s30b)

**Nacidos de esta sesión:**

- **P-EXPORTACION-IMAGEN** — exportar como imagen el comparador y el panorama. La razón
  de que no entre aquí está escrita en el propio código: exigiría reconstruir en SVG lo
  que hoy es HTML (`StackedBar`, su regla de etiquetado medida en píxeles, la tira
  externa y la tabla entera), es decir un **segundo dibujante** que podría divergir del
  de pantalla. La lección que el hermano dejó escrita en su código (~3067) es la
  contraria: un solo dibujante que recibe un `<g>` de destino. Es un rediseño de
  `StackedBar`, no un añadido.
- **P-ESTADO-SIN-COMPARACION** — `repartoInd`, `alertSummary` y `CeldaEE` mandan el
  `sigdifgru` nulo al cubo neutro y lo muestran como "= sin diferencia" / "≈ en su GSE".
  Son 3.495 celdas EE × indicador en 4° básico 2025 (13,3 % de las que tienen puntaje) y
  3.445 en 2024. Corregirlo mueve las cifras de las barras y de la regla de etiquetado,
  así que es encargo propio con su propia verificación. Hoy el CSV ya no lo repite
  (§47.9), de modo que pantalla y archivo dicen cosas distintas en esas celdas: es la
  única divergencia deliberada de la sesión y conviene cerrarla por el lado de la
  pantalla.
- **Columna `estado_anio` en el CSV de la ficha**, para poder incluir los años sin
  medición diciendo el motivo (pandemia / no evaluado / sin dato del establecimiento) en
  vez de omitirlos.
- **El build podría publicar el primer año con `difgru`**, igual que ya publica
  `meta.primer_anio_familia`. Con ese dato la glosa de §47.9 podría distinguir las dos
  causas de la ausencia en vez de callarlas.
- **El "CSV de la serie" de la ficha no tiene guarda**: para un establecimiento sin
  ninguna medición en ese nivel entrega 91 filas sin un solo puntaje. Es fiel a la
  pantalla, que también muestra "sin dato" en todo; queda anotado por si conviene
  desactivar el botón.
- **`tc()` sobre un nombre que empieza con comilla**: `COLEGIO PARTICULAR N. 244 "MADRE
  DE DIOS"` se presenta como `... ""madre de Dios""`, porque `tc` pone en mayúscula el
  primer carácter de la palabra, que es la comilla. Son 11 establecimientos del
  directorio. Es defecto **previo** —la tarjeta y la ficha ya lo mostraban así—, pero el
  CSV lo hace más visible.
- **El borde `--border-2` de los controles da 1,37 sobre blanco**, bajo el 3:1 de WCAG
  1.4.11. No es del botón nuevo: es la convención vigente en `.nav-trigger`,
  `.estab-popup-btn`, `.gfb` y `.cmp-chip`. Cerrarlo es una línea sobre todo el motor.
- **POLITICA §10 pediría un archivo propio en `decisiones/`** para el formato de
  exportación (separador, decimal, universo exportado, patrón de nombre). Aquí esas
  decisiones las fijó el encargo y las registra este log; si se quiere el archivo
  canónico, es un trámite de cierre.

- **[s30b] `renv` desincronizado por `suitedoc`** (§47.13): decisión del titular entre
  `renv::snapshot()` con el paquete en la librería del proyecto o `.renvignore` sobre
  `50_documentacion/suite/`. Previo a s30; sin efecto sobre el build.
- **[s30b] Revisión adversarial de las lentes de imagen y de estado de React**, si se
  quiere: no la hubo (§47.10bis). Encargo propio y con cuota.
- **[s30b] Observación sobre el radar, no defecto de la exportación:** con un indicador
  sin dato entre dos con dato, el vértice queda aislado y el resto forma un segmento
  (D3 `defined`). Es conducta previa de pantalla; si se quisiera cerrar el polígono
  saltando el hueco, sería una decisión de diseño del radar.

**Heredados, sin cambio:** §5.6 de la decisión de contraste; **P-VISTA-TERRITORIAL**;
hover `✕` de `.sel-chip`/`.cmp-x` a 4,11; §5.2 marca de "base pequeña"; el tope de 10 más
el cambio de selector que deja el modal sin poder desmarcar; `.cmp-table` que se comprime
en vez de hacer scroll; el aviso de dependencia que solo se dispara con SLEP;
`NACIONAL_OPT.sub` frente al banner; la regla de mayúsculas fuera de `POLITICA`; las
trece divergencias del modal con el hermano (§36.7); rama `feat/contrato-contexto`, no
tocada.
