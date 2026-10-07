# Encargo autónomo a Claude Code — Comparador: entidades (nacional + establecimiento) y etiquetado adaptativo de la barra

> Proyecto: `slep_idps`. Sesión origen: s29 (CONTINUATION). Redactado por el
> asistente de análisis tras leer el código real en esta sesión
> (`30_procesamiento/35_motor_template.html`, líneas citadas abajo) y tras
> aprobación explícita del titular sobre el mockup
> `50_documentacion/andamios/diseno/detalles/mockup_comparador_ee_nacional.html`.
> Ese mockup es la **referencia visual vinculante** de este encargo: ábrelo antes
> de escribir código y replica su comportamiento, no lo reinterpretes.

---

## 0. Contrato

- **Modo:** autónomo, secuencial. Todas las fases en este turno, en orden
  estricto. Commit atómico por fase, `git add` a rutas exactas.
- **Stack:** edición directa de `30_procesamiento/35_motor_template.html`
  (JSX/CSS embebido). **No se toca el pipeline de datos** (31–34) ni
  `idps_largo.parquet`. Rutas SIEMPRE absolutas desde
  `/Users/tomgc/Projects/slep_idps`. No asumir `cd` previo.
- **Regla de detención (PARA y reporta, no improvises):**
  1. Si alguna fase exigiera tocar `34_leer_normalizar_idps.R` o el parquet:
     detente. Este encargo es 100% de presentación; los datos ya alcanzan.
  2. Si tras regenerar el motor cambia **cualquier cifra** del payload
     (conteos, promedios, tamaño de los bloques columnares): detente y reporta
     el diff. Este encargo no mueve ninguna cifra, solo dónde se dibuja.
  3. Si el build local falla o emite un warning nuevo: detente y reporta.
  4. **NO despliegues a `docs/`.** El gate visual es del titular. El encargo
     termina con `40_salidas/motor_idps.html` regenerado y listo para revisión.

---

## 1. Contexto mínimo suficiente (verificado en el código, s29)

El comparador (pantalla `comparar`) compara **territorios** `slep|comuna|region`.
Piezas vigentes:

| Pieza | Línea (aprox.) | Qué hace hoy |
|---|---|---|
| `CMP_MAX_TERR=10` | 577 | tope de entidades comparables |
| `repartoInd(items,indId,grado,agno)` | 752 | cuenta EE por estado vs GSE (`sigdifgru`) |
| `StackedBar({rep})` | 769 | barra 100% + tira externa para segmentos `<9%` |
| `TABS_CMP` / `buildListCmp` | 1327-1332 | tabs y catálogo del modal del comparador |
| `rosterTerr(t,grado,agno)` | 1343 | roster de un territorio, todos los GSE |
| `Comparador({...})` | 1359 | matriz entidades × indicadores, una tabla por GSE |
| `addTerr` / `removeTerr` | 1497-1506 | alta/baja de entidades (toggle, sin cerrar modal) |
| `buildList("establecimiento", ql)` | 1286 | buscador de EE por nombre o RBD (ya existe, se reusa) |
| `indOf(rbd,grado,agno)` | 602 | `{prom, sigdifgru, ...}` por indicador de un RBD |
| Panorama territorial | 1606-1610 | **también** usa `StackedBar` |

Dos hechos que mandan sobre el diseño:

1. **El dato nacional ya está en el motor.** `DATA.roster` y
   `DATA.establecimientos` son nacionales (`35_generar_motor_html.R` bloques 3-4,
   "todo Chile"); el territorio solo **acota** con `continue`. Agregar Chile no
   requiere ningún dato nuevo: requiere una rama que no filtre.
2. **La regla de etiquetado de la barra está calibrada para `n` de dos dígitos.**
   Hoy decide por porcentaje (`p>=16` → `"p% (n)"`, `p>=9` → `"p%"`, línea 780).
   Con Chile, `"18% (1.108)"` no cabe en el 18% de una columna repartida entre
   cuatro indicadores y el texto se corta a media cifra. Es un defecto latente
   que el nivel nacional vuelve visible, y por eso se arregla **antes** de
   agregar la entidad nacional (Fase 1 antes que Fase 2).

---

## 2. Invariantes (🔒 no negociables)

1. 🔒 **Cero agregación.** El comparador cuenta establecimientos; jamás promedia
   ni construye una cifra territorial. La entidad nacional es un conteo más. La
   fila de establecimiento muestra el estado y el puntaje **de ese EE**, leídos
   tal cual, no una media.
2. 🔒 **`sigdifgru` es la fuente del estado.** No se reconstruye el GSE absoluto
   ni se compara promedios a mano.
3. 🔒 **Ninguna cifra cambia.** Este encargo mueve etiquetas y agrega filas; los
   conteos, porcentajes y promedios salen de las mismas funciones de siempre.
4. 🔒 **Nunca un número truncado.** Dentro de la barra va solo lo que cabe
   completo; lo que no cabe baja entero a la tira. Prohibido `text-overflow`,
   elipsis o recorte silencioso.
5. 🔒 **Sin duplicar la lectura.** Un mismo porcentaje no aparece dentro de la
   barra y en la tira externa a la vez.
6. 🔒 **Paleta de ESTADO intacta** (`--alerta` / `--st-neutro` / `--destaca`),
   distinta de la paleta de 4 indicadores. No se inventan colores.
7. 🔒 **El año sigue sin ser seleccionable**: `agnoCmp` es el más reciente del
   nivel, igual para todas las entidades. Entidad sin EE ese año → "sin dato",
   nunca se desliza a un año anterior.
8. 🔒 **Accesibilidad**: el `aria-label` de la barra sigue exponiendo la
   distribución completa como texto; la fila de EE expone su estado como texto,
   no solo como color y glifo.

---

## 3. Fases

### Paso 0 de cada fase: leer el estado real antes de editar

`git status`, y leer el bloque que vas a tocar en el archivo (no de memoria, no
de este encargo: el archivo). Este documento cita líneas aproximadas de s29; si
no calzan, manda el archivo.

---

### Fase 1 — Etiquetado adaptativo de `StackedBar` (commit `fix`)

**Qué:** reemplazar el umbral por porcentaje por una medición real de píxeles.

**Cómo:**

1. Helper de medición a nivel de módulo (una sola vez, fuera del componente):
   - un `canvas` con `getContext("2d")` y una función `medirTexto(txt)`;
   - la fuente se deriva del CSS efectivo de `.s100-seg span`
     (`700 14px <font-family computada>`), no se escribe a mano;
   - re-derivar la fuente en `document.fonts.ready` (las OTF de marca cargan
     embebidas y cambian el ancho del texto).
2. Un **ResizeObserver compartido** a nivel de módulo con un `Map` de
   `elemento → callback`, y un `observar(el, cb)` / `desobservar(el)`. Un
   observer por celda es inaceptable: la matriz llega a ~200 celdas.
3. `StackedBar` obtiene un `ref` a su `.s100`, guarda el ancho en estado
   (`useState` + `useLayoutEffect`) y se re-renderiza al cambiar.
4. **Regla de etiquetado (única):** para cada segmento con `p>0`, sea
   `px = anchoUtil * p / 100` y `full = "p% (n)"` con `n` formateado
   `toLocaleString("es-CL")`:
   - si `medirTexto(full) + 12 <= px` → la etiqueta va **dentro** del segmento;
   - si no → el segmento va **sin texto**, y su dato completo (`▼/=/▲ p% (n)`)
     baja a la tira externa. Sin nivel intermedio "solo p%".
5. **Tira externa alineada a los sectores**: `display:grid` con
   `grid-template-columns:1fr auto 1fr`; `ext-bajo` en la columna 1
   (`justify-self:start`), `ext-neutro` en la 2 (centro), `ext-sobre` en la 3
   (`justify-self:end`). El estado ausente no desplaza a los otros.
6. El `title` de cada segmento y el `aria-label` de la barra no cambian de
   contenido.

**Ojo (impacto cruzado):** `StackedBar` también la usa el **panorama
territorial** (línea ~1606). El cambio la mejora ahí también; verifica esa
pantalla en la Fase 5, no solo el comparador.

**Retiro:** desaparecen las constantes `16` y `9` del etiquetado y la condición
`p>0 && p<9` de la tira externa.

Commit: `fix(motor): etiqueta de barra por espacio real, no por porcentaje`

---

### Fase 2 — Entidad nacional (commit `feat`)

1. `rosterTerr`: nueva rama `kind === "nacional"` que **no filtra** (ojo con el
   `else` final actual, que hoy captura `region`; reordena para que `nacional`
   no caiga ahí por descarte).
2. Ítem fijo del catálogo: `{kind:"nacional", cod:"CL", nom:"Chile",
   sub:"Nivel nacional · N comunas · N establecimientos"}`, con los conteos
   derivados de `DATA.establecimientos` (mismo patrón que `SLEPS_OPTS`, línea
   1322). Aparece **arriba de la lista en todos los tabs** del modal del
   comparador, no dentro de un tab propio.
3. `Comparador`: al renderizar, la entidad nacional va **siempre primero**
   (ordenar una copia de `cmpTerr`; no mutar el orden de selección del estado).
   Fila con clase `row-nac` y subtítulo "referencia nacional".
4. Chip con `cmp-ck` = "Nacional · fijo" y banda izquierda `--azul`.
5. La meta del chip (comunas · establecimientos) se calcula del **roster real**
   por grado y año, como los demás (D-s8-4), no del directorio.

Commit: `feat(comparador): entidad nacional como referencia fija`

---

### Fase 3 — Filas de establecimiento (commit `feat`)

1. Tab nuevo en `TABS_CMP`: `["establecimiento","Establecimiento"]`. Su
   `buildListCmp` **reusa** la rama existente de `buildList("establecimiento",
   ql)` (línea 1286) y añade al `sub` el GSE del EE en `(cmpGrado, agnoCmp)`
   vía `gseLbl` (línea 1201).
2. `addTerr` acepta el nuevo `kind` sin cambios de lógica: mismo toggle, mismo
   tope `CMP_MAX_TERR=10`, **sin subtope por tipo** (decisión del titular).
3. Render: `cmpTerr` se parte en territorios (incluida la nacional) y
   establecimientos. Cada EE se dibuja como **última fila de la tabla de su
   propio GSE**, con `row-ee` (y `row-ee-first` en el primero, para el borde
   superior). Un EE nunca aparece en la tabla de otro GSE.
4. Celda de EE (**no** `StackedBar`, ver 🔒 4-5 y el mockup §2):
   - glifo de estado en círculo (`▼` `=` `▲`) con los colores de estado, según
     `indOf(rbd,cmpGrado,agnoCmp)[ind.id].sigdifgru` (`-1`, `0/null`, `1`);
   - a su derecha el puntaje `prom` con **una decimal y coma** (formato del
     motor) y, debajo, el texto del estado ("bajo su GSE" / "sin diferencia" /
     "sobre su GSE");
   - `prom == null` → `"sin dato"` en cursiva, jamás un cero ni un guion.
5. Pie de sección (`gse-sec-foot`): si hay EE seleccionados que pertenecen a
   otro GSE, nombrarlos ("… se muestra más abajo"). Si no hay ninguno, no se
   pinta el pie.
6. Chip del EE: `cmp-ck` = "Establecimiento", nombre curado y
   `RBD nnnn · GSE x`, banda izquierda `--foco`.

Commit: `feat(comparador): establecimientos como filas de caso individual`

---

### Fase 4 — "Territorio" → "Entidad" (commit `refactor`)

Con nacional y EE adentro, "territorio" dejó de ser cierto en la interfaz. Cambia
**solo texto visible**: encabezado de columna, contador ("Entidades a comparar ·
N de 10"), botón ("+ agregar entidad"), invitación de estado vacío, título del
modal y `aria-label` de los botones de quitar.

**No renombres** las variables `cmpTerr`, `rosterTerr`, `addTerr`, `removeTerr`
ni las clases `cmp-*`: el churn de identificadores no aporta y ensucia el diff.
Deja un comentario de una línea donde se explique que "territorio" en el código
significa "entidad comparable" desde s29.

Commit: `refactor(comparador): rotulo "entidad" en la interfaz`

---

### Fase 5 — Auto-auditoría antes de reportar

1. `Rscript 00_build.R` (o `run_all(only = 35L)`) → build limpio, sin warnings
   nuevos.
2. **Fidelidad de cifras:** el resumen del bloque 7 del generador debe reportar
   los mismos conteos que antes del encargo (regiones, EE, unidades de grilla,
   filas ind/dim/niv). Cualquier diferencia es un bug: detente.
3. **Grep de retiro:** que no queden en el archivo las condiciones
   `p>=16` / `p>=9` del etiquetado viejo ni la de la tira `p<9`.
4. **Inspección en navegador** de `40_salidas/motor_idps.html`, con capturas:
   - comparador con Chile + un SLEP + una comuna + dos EE de GSE distintos;
   - la misma pantalla angostando la ventana a ~430px de ancho;
   - **panorama territorial** (verificación del impacto cruzado de la Fase 1).
   Criterio de aceptación: ninguna etiqueta cortada a media cifra, ningún
   porcentaje repetido dentro y fuera de la barra, `▼` a la izquierda y `▲` a la
   derecha bajo sus sectores.
5. Comparación contra el mockup aprobado: las diferencias que encuentres, si las
   hay, se reportan; no se "corrigen" hacia tu propio criterio.

---

### Fase 6 — Log y reporte

Log en `50_documentacion/andamios/logs/AAAAMMDD_comparador_entidades_s29_log.md`
con: inventario de commits, cambios sustantivos por fase (qué, por qué, cómo se
verificó), resultado de los 5 chequeos de la Fase 5 con **valores observados**, y
decisiones de implementación que tomaste dentro del margen que este encargo deja.

Reporte final en el chat: 5 líneas máximo + la tabla de commits.

---

## 4. Pendientes que este encargo DEJA anotados (NO ejecuta)

- Despliegue a `docs/index.html`: gate visual del titular, sesión aparte.
- Tooltip "vs evaluación anterior": de `title` a body (heredado de s28).
- Rama `feat/contrato-contexto` con 2 commits locales sin push (paso 36): fuera
  de alcance, no la toques ni la mezcles.
