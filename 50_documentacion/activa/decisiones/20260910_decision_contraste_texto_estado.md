# Decisión — Contraste del texto de estado vs GSE y excepción de la etiqueta interna

- **Fecha:** 2026-09-10
- **Sesión:** s29c
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_contraste_texto_estado_s29c.md`
- **Referencia visual vinculante:** `50_documentacion/andamios/diseno/detalles/mockup_contraste_estados.html`
- **Tipo:** decisión de presentación y accesibilidad. NO afecta ninguna cifra.
- **Estado:** adoptada. **Enmendada el 2026-09-10 (s29d):** se cierra el pendiente §5.1
  y se añade la excepción §3.5 de los glifos de estado. **Enmendada el 2026-09-10
  (s29e):** se cierra la §5.3 — chips corregidos, atenuados exentos, histórica al
  backlog. **Enmendada el 2026-09-11 (s29f):** `--alerta-txt` pasa a `#CE112C` con
  margen; se cierran §5.3 (a) y §5.4; se abre §5.5 con los hallazgos de la ficha.
  Desplegado a `docs/` con gate visual del titular. **Enmendada el 2026-09-16
  (s29g):** se cierran §5.5 (1) y (3) con los tokens ya existentes; §5.5 (2) y (4) se
  agrupan con §5.3 (b) en la §5.6 como un solo problema de diseño —texto sobre color
  de la paleta de INDICADOR—, que pide mockup. Redesplegado a `docs/`. **Enmendada
  el 2026-09-23 (s32g):** se resuelve la §5.6 con la opción B (título del indicador
  en tinta con filete del color) y se amplía a siete el inventario de usos de los
  tokens `-txt`. Desplegado a `docs/`. **Enmendada el 2026-09-24 (s33):** encabezado
  de §5 al día; `_txtOn` retirado del motor.

---

## 1. Contexto y problema

El motor codifica el **estado vs GSE** con tres colores propios —`--alerta` (bajo su
GSE), `--st-neutro` (sin diferencia) y `--destaca` (sobre su GSE)— que son la identidad
del folleto de la Agencia de Calidad y un invariante del proyecto desde P-PALETA
(ver `20260622_decision_paleta_indicadores.md`, §3).

Esos tres colores fueron elegidos para pintar **superficie**: segmentos de la barra
apilada, relleno y borde de los glifos de la fila de establecimiento, muestras de la
leyenda. Como superficie funcionan. El problema aparece cuando el mismo hex se usa
para **texto pequeño sobre fondo claro**, que es lo que hacía la tira externa de la
barra (`.s100-ext-it`, 12 px en negrita): ahí el criterio ya no es "se distingue del
resto", sino el mínimo de legibilidad de WCAG 2.1 AA, y ninguno de los tres lo alcanza.

## 2. Mediciones que originan la decisión

Método: colores **computados en navegador** (Chromium) sobre el motor regenerado, y
fórmula de contraste de WCAG 2.1 (luminancia relativa sRGB, `(L1+0,05)/(L2+0,05)`).
Umbrales: **4,5:1** para texto normal; **3:1** para texto grande (≥24 px, o ≥18,66 px
en negrita). Fecha de medición: 2026-09-10.

| Zona | Colores | Ratio | Exige | Estado |
|---|---|---|---|---|
| Tira externa (12 px bold) | `#EE2D49` sobre crema | 3,93 / 4,04 | 4,5 | **falla** |
| Tira externa (12 px bold) | `#2A8FD9` sobre crema | 3,33 / 3,42 | 4,5 | **falla** |
| Tira externa (12 px bold) | `#7E8A99` sobre crema | 3,45 | 4,5 | **falla** |
| Etiqueta dentro de barra (14 px bold) | blanco sobre rojo / neutro / azul | 4,11 / 3,51 / 3,48 | 4,5 | **falla** |
| Meta del chip, banda "no se agrega" | — | 4,59 / 5,58 | 4,5 | ok |

Los dos valores de la tira externa corresponden a los dos fondos efectivos que puede
tener esa celda: `#FCFAF2` (fila nacional) y `--panel` `#fffdf7` (resto).

## 3. Decisión

### 3.1 La paleta de estado no se modifica

`--alerta` `#EE2D49`, `--st-neutro` `#7E8A99` y `--destaca` `#2A8FD9` conservan sus
valores. Barras, glifos de la fila de establecimiento y muestras de la leyenda quedan
idénticos. La lámina sigue leyéndose igual de lejos y la coherencia con el folleto de
la Agencia se mantiene intacta.

### 3.2 Se añaden tres tokens de TEXTO

Se separa *color de barra* de *color de texto*. Tres tokens nuevos en el `:root` de
`30_procesamiento/35_motor_template.html`, mismo tono y menor luminosidad:

| Token nuevo | Hex | Deriva de | Peor caso de la escala crema (`--cream-200`) | Sobre `--panel` |
|---|---|---|---|---|
| `--alerta-txt` | `#CE112C` *(s29f; antes `#D2112D`)* | `--alerta` `#EE2D49` | **4,64** | 5,52 |
| `--destaca-txt` | `#1E6EA9` | `--destaca` `#2A8FD9` | **4,50** | 5,35 |
| `--st-neutro-txt` | `#5F6A78` | `--st-neutro` `#7E8A99` | **4,55** | 5,41 |

Contraste de los tres tokens contra **todos** los fondos claros que existen en el motor
(cálculo propio con la fórmula de WCAG 2.1, verificado además en navegador en la Fase 3
del encargo):

| Token | `--cream` `#FFF6E0` | `--cream-200` `#f4e9cc` | `--panel` `#fffdf7` | `--paper` `#ffffff` | fila EE `#F7FBFE` | fila nacional `#FCFAF2` |
|---|---|---|---|---|---|---|
| `--alerta-txt` `#CE112C` | 5,22 | 4,64 | 5,52 | 5,61 | 5,40 | 5,37 |
| `--destaca-txt` | 5,06 | 4,50 | 5,35 | 5,44 | 5,23 | 5,21 |
| `--st-neutro-txt` | 5,11 | 4,55 | 5,41 | 5,50 | 5,28 | 5,26 |

Los fondos sobre los que estos dos elementos caen **realmente** en pantalla son tres:
`#FCFAF2` (fila nacional), `--panel` `#fffdf7` (resto de las filas de territorio) y
`#F7FBFE` (fila de establecimiento). Ahí los ratios medidos en el motor vivo son
**5,21 / 5,35 / 5,23**. El 4,50 de `--cream-200` es el peor caso de la escala crema y
se deja anotado como margen, no como fondo en uso.

Advertencia honesta sobre el alcance de esta tabla: `--cream-200` **no** es el fondo
claro más oscuro del motor (lo son `#D4E4F1` del filtro GSE activo y `#eee5cf` del
badge). Sobre esos dos, los tokens quedarían en 4,19–4,38 y no alcanzarían AA — pero
ni la tira externa ni el texto de estado del EE se dibujan nunca ahí, así que no es un
caso real. Si en el futuro se usan estos tokens sobre otra superficie, hay que
re-medir: la garantía de esta decisión cubre los fondos listados, no cualquier fondo.

### 3.3 Dónde se aplican los tokens (inventario al día)

1. **`.s100-ext-it`** — la tira externa bajo la barra apilada. El color deja de viajar
   como estilo inline (`style={{color:s.c}}`, que traía el color de *barra*) y pasa a
   salir de la clase de estado que el elemento ya llevaba: `ext-bajo` → `--alerta-txt`,
   `ext-neutro` → `--st-neutro-txt`, `ext-sobre` → `--destaca-txt`.
2. **`.ee-st`** — el texto "bajo su GSE" / "sin diferencia" / "sobre su GSE" de la fila
   de establecimiento. Deja el gris de interfaz (`--gris`, 3,80 sobre `--cream-200`) y
   toma el token del estado que corresponde, en negrita. `CeldaEE` marca el estado con
   una clase (`ee-st bajo|neutro|sobre`). Además de alcanzar el umbral, el texto queda
   amarrado al glifo, que ya venía teñido del estado.

3. **`.chip.al` y `.chip.de`** — los chips de estado de la tarjeta de establecimiento
   en el panorama territorial. *Añadido el 2026-09-10 por s29e*; ver §5.3 (a). En s29c
   estos dos puntos eran **los únicos dos** y así se escribió aquí; desde s29e son tres.
   Quien añada un uso tiene que anotarlo en esta lista y en el comentario del
   `:root`, que lleva el mismo inventario.

4. **`.ancla.al` y `.ancla.de`** — las anclas de desvío vs GSE / vs evaluación anterior
   de la ficha de establecimiento. *Añadido el 2026-09-11 por s29f*; ver §5.4. (s29f lo
   anotó en el `:root` y al pie de §5.4, pero no en esta lista; s29g lo trae aquí para
   que el inventario tenga una sola fuente.) Desde s29g su sufijo `"· sig."` / `"· n.s."`
   va sin `opacity`, ver §5.5 (1).

5. **Los `<span>` `"▼ rojo"` / `"▲ azul"` de `.ficha-explain`** — la glosa de estados
   del texto explicativo de la ficha (vista actual). Color inline en el JSX, no
   declaración CSS. *Añadido el 2026-09-16 por s29g*; ver §5.5 (3). Es el único uso de
   los tokens sobre `#eef3f7`, fondo que no estaba en la tabla de §3.2: `--alerta-txt`
   da ahí **5,025** y `--destaca-txt` **4,872** (cálculo de s29g con el instrumento
   verificado con controles; la medición en navegador queda en el log de s29g).

Los tokens **no entran** a barras, bordes de glifo, fondos ni leyenda. Esa restricción
sigue siendo el invariante, y es lo que permite añadir usos sin volver a decidir nada:
los tres son texto pequeño sobre fondo claro.

### 3.4 Excepción explícita: la etiqueta DENTRO de la barra

La etiqueta que va **dentro** del segmento (texto blanco de 14 px en negrita sobre el
color de estado) da **3,48 – 4,11** y **no alcanza AA. Se acepta así**, deliberadamente,
por dos razones:

**(a) Corregirla no sale gratis.** Sin tocar la paleta institucional, las únicas dos
salidas son alterar los hex del folleto —descartado por invariante— o **agrandar la
etiqueta** a 18 px en negrita, con lo que pasaría a contar como texto grande y su
umbral bajaría a 3:1 (sección 3 del mockup). Pero la regla de etiquetado adaptativo de
s29 mete la etiqueta dentro del segmento **solo si el dato completo cabe entero**: con
letra más grande caben menos etiquetas dentro y más bajan a la tira externa, sobre todo
en columnas angostas. Se pagaría legibilidad de la lámina completa para arreglar un
contraste que, por (b), no oculta nada.

**(b) El dato es redundante: el bajo contraste no oculta información.** El mismo valor
está, para el mismo segmento, en otros tres lugares:

- en la **tira externa**, que sí cumple AA tras esta decisión;
- en el **`title` del segmento** (`"▼ bajo su GSE (significativo): 233 de 1.355 (17%)"`);
- en el **`aria-label` de la barra**, que expone la distribución completa como texto y
  es lo que lee un lector de pantalla (los segmentos van `aria-hidden`).

Es decir: quien no distinga la etiqueta interna no pierde el dato; lo tiene bajo la
barra, en el tooltip y en la lectura asistida. La excepción queda documentada aquí y no
se vuelve a discutir sin una razón nueva.

### 3.5 Excepción explícita: los glifos de estado de la fila de establecimiento

*Añadida el 2026-09-10 (s29d).*

El glifo de `.ee-gl` —la pastilla redonda con `▼` / `=` / `▲` que abre la celda del
establecimiento— pinta el color de estado sobre su propio relleno claro. Medido:

| Glifo | Color | Relleno | Ratio | Texto (4,5) | Componente gráfico (3,0) |
|---|---|---|---|---|---|
| `▼` bajo | `--alerta` `#EE2D49` | `--alerta-bg` `#FBE3E6` | **3,37** | falla | cumple |
| `=` neutro | `--st-neutro` `#7E8A99` | `#EDF0F3` | **3,07** | falla | cumple |
| `▲` sobre | `--destaca` `#2A8FD9` | `--destaca-bg` `#E2F0FB` | **3,00** | falla | cumple, al filo |

**Se aceptan así**, tratándolos como **componente gráfico** y no como texto. El mínimo
aplicable pasa entonces a ser 3:1, que los tres cumplen. El argumento que lo sostiene
es el mismo que el de §3.4 y aquí es más fuerte todavía: el glifo **no es la única vía
del dato**. Va acompañado, dentro de la misma celda, del texto del estado (`.ee-st`),
que desde s29c cumple AA con holgura (5,23–5,28), y el glifo lleva `aria-hidden="true"`
mientras el texto es lo que lee un lector de pantalla. La información no depende del
glifo en ningún momento.

**Margen que hay que vigilar:** el `▲` da 3,0004. Cumple, pero por cuatro diezmilésimas.
Cualquier retoque futuro de `--destaca` o de `--destaca-bg` lo rompe. Si esos dos
tokens se tocan alguna vez, hay que volver a medir este glifo en la misma operación.

## 4. Garantía de fidelidad (ninguna cifra cambia)

El cambio es 100 % color de texto. No toca el pipeline (31–34), ni el generador
(`35_generar_motor_html.R`), ni `idps_largo.parquet`. Verificación en la Fase 3 del
encargo: métricas del bloque 7 del generador idénticas y payload JSON del motor
byte-idéntico salvo `fecha_generacion`.

## 5. Pendientes asociados (§5.1, §5.3 a/c, §5.4, §5.5 1/3 y §5.6 resueltos; §5.2 abierto)

### 5.1 `--gris` accesible en todos los fondos — **RESUELTO el 2026-09-10 (s29d)**

Este pendiente está **cerrado**, y con una salida **distinta a la que este mismo
documento recomendaba**. Queda constancia de por qué.

#### Lo que decía el pendiente

Se había detectado que `--gris` (`#6b7780`), el gris de interfaz, daba 4,41 sobre
`#F7FBFE` y 4,39 sobre `#FCFAF2` —los fondos teñidos que s29 introdujo para las
superficies de establecimiento— y se recomendaba **(a) un token paralelo**
(`--gris-txt`) aplicado a los cuatro selectores afectados: `.cmp-cm`, `.td-ee-k`,
`.td-ee-rbd` y `.ee-nd`.

#### Por qué esa recomendación era la salida equivocada

Aquella medición solo miró las cinco zonas del criterio de este encargo. Al auditar
**todo el texto visible** del motor —las tres pantallas más el modal, colores
computados en navegador, fondo efectivo compuesto hacia arriba— aparece que la falla
es más amplia y que **su parte más severa es anterior a s29**:

| Zona | Fondo | Ratio | ¿La introdujo s29? |
|---|---|---|---|
| `.gse-sec-sub`, `.s100-nd`, `.check-region` | `#F4E9CC` cream-200 | **3,80** | no, preexistente |
| `.eo-m` con el `:hover` de `.estab-opt` | `#D4E4F1` | **3,53** | no, preexistente |
| `.cmp-cl`, leyenda ▼/=/▲, `.picker-lab` | `#FFF6E0` cream | **4,26** | no, preexistente |
| `.td-ee-rbd` (fila nacional) | `#FCFAF2` | 4,39 | sí |
| `.cmp-cm`, `.cmp-ck`, `.cmp-x`, `.td-ee-k`, `.td-ee-rbd` | `#F7FBFE` | 4,41 | sí |

`--gris` fallaba en **5 de los 7 fondos claros** del motor. Un token paralelo aplicado
a cuatro selectores habría tapado exactamente lo que s29 introdujo y **habría dejado
intacto lo peor**, que llevaba ahí desde antes: el subtítulo de cada sección de GSE y
el "sin dato" de las barras, a 3,80.

#### La salida adoptada

Corregir el token **en la raíz**: `--gris` pasa de `#6b7780` a `#5C666E`. Misma
saturación (8,9 %) y prácticamente el mismo tono (H 205,7° → 206,7°, diferencia por
redondeo de 8 bits); solo baja la luminosidad relativa, de 0,1788 a 0,1290. `--gris` es
gris de **interfaz**, no de la paleta institucional de estado ni de la de indicadores:
cambiarlo no toca ninguna identidad de marca. Sigue siendo **un** token; no se creó
ningún paralelo ni se sustituyó selector por selector.

| Fondo | Antes `#6b7780` | Después `#5C666E` |
|---|---|---|
| `#F4E9CC` cream-200 | 3,80 | **4,85** |
| `#D4E4F1` hover de `.estab-opt` | 3,53 | **4,51** |
| `#FFF6E0` cream | 4,26 | **5,45** |
| `#FCFAF2` fila nacional | 4,39 | **5,61** |
| `#F7FBFE` fila EE | 4,41 | **5,64** |
| `#FFFDF7` panel | 4,51 | **5,77** |
| `#FFFFFF` paper | 4,59 | **5,86** |

Método: colores **computados** en navegador sobre el motor cargado, fondo efectivo
compuesto hacia arriba con alfa y `opacity` de cada capa, fórmula WCAG 2.1. Medido en
las tres pantallas y en el modal, con el estado final de las animaciones forzado.
Resultado: **0 fallas atribuibles a `--gris`**, frente a 10 antes del cambio en la
pantalla del comparador.

#### Comprobación de seguridad sobre fondo oscuro

Antes de aplicar el cambio se enumeró **todo** uso de `--gris` sobre superficies
oscuras, porque oscurecer el token ahí habría sido un retroceso. Resultado: **ningún
texto en `--gris` cae sobre fondo oscuro**. Los únicos elementos en `--gris` sobre
fondo oscuro son muestras de color sin texto (`.th-sw` y los `<i>` de `.leyenda`), que
solo pintan `background` y heredan el `color` sin usarlo. Dentro del banner azul
(`.cmp-chrome`) no hay ni un uso de `--gris`: usa `--cream` con opacidad.

#### Corrección de una atribución del encargo s29d

El encargo atribuía la falla de 3,53 sobre `#D4E4F1` a las **casillas GSE activas**
(`.gfb.on`). No es así: `.gfb.on` usa `color:var(--foco)` `#0062A0` y mide **4,97**, es
decir ya cumplía. El fondo `#D4E4F1` y el ratio 3,53 sí son reales, pero corresponden a
`.eo-m` (la línea de metadatos de cada establecimiento del buscador) cuando su
contenedor `.estab-opt` está en `:hover`. El cambio lo corrige igual, a 4,51.

### 5.2 Marca de "base pequeña"

La marca de **"base pequeña"** (sección 4 del mockup) queda al backlog. Son dos piezas:
el N de la fila en esa sección bajo el nombre de la entidad —hoy ese dato solo vive en
el `title` de la barra— y una marca visible cuando ese N cae bajo un umbral. **El umbral
es una decisión metodológica, no de diseño**, y el titular aún no lo ha fijado. No se
implementa nada de eso hasta que exista una decisión de proyecto que fije el umbral y
lo justifique.

### 5.3 Hallazgos de la auditoría de s29d — **CERRADOS el 2026-09-10 (s29e)**

*Abiertos el 2026-09-10 (s29d), cerrados el mismo día por s29e.* Al auditar **todo** el
texto visible —y no solo las zonas de un criterio— aparecieron tres fallas de AA que no
eran de `--gris`. Cada una tiene ahora un destino distinto: **(a) corregida**,
**(c) declarada exenta**, **(b) al backlog**.

#### (a) `.chip.al` y `.chip.de` del panorama — **RESUELTO del todo el 2026-09-11 (s29f)**

Son texto completo —"▼ 4 indicadores bajo su GSE"— pintado con el color de estado sobre
su propio fondo teñido, a 12 px/600. Ninguna de las dos excepciones lo cubre: §3.4 es
la etiqueta blanca dentro de la barra y §3.5 son los glifos `.ee-gl`, y aquí el color
**es** el texto.

Se resolvió en dos pasos, porque el primero no bastó:

| Chip | Color | Fondo | s29d | s29e (`-txt` `#D2112D`) | **s29f (`-txt` `#CE112C`)** | Exige |
|---|---|---|---|---|---|---|
| `.chip.al` | `--alerta-txt` | `--alerta-bg` `#FBE3E6` | 3,374 | 4,466 ✗ | **4,606** ✓ | 4,5 |
| `.chip.de` | `--destaca-txt` | `--destaca-bg` `#E2F0FB` | 3,000 | 4,689 ✓ | 4,689 ✓ | 4,5 |
| `.chip.nt` | `#6a5a2f` | `#eee5cf` | 5,373 ✓ | — | — | 4,5 |

**s29e** cambió el selector (token de barra → token de texto) y dejó `.chip.al` en 4,466,
a 0,034 del umbral: la causa estaba en el token, no en el selector. **s29f** ajustó el
token: `--alerta-txt` pasa de `#D2112D` a **`#CE112C`** (H 351,3° → 351,4°, S 85,0 % →
84,8 %; solo baja la luminosidad, 0,1429 → 0,1370).

**Corrección del valor recomendado.** La versión anterior de esta sección proponía
`#D1112D` como vía (i). Se **descartó**: da 4,5003 sobre `--alerta-bg`, un margen de
tres diezmilésimas que el próximo ajuste de fondo rompería. `#CE112C` da 4,606 ahí y
4,644 sobre `--cream-200`, el peor de sus fondos. También se descartó tocar
`--alerta-bg`, que es fondo institucional. `--destaca-txt` no se tocó: 4,689 ya cumple.

Regla de seguridad verificada antes de aplicar: **ningún uso existente de `--alerta-txt`
baja de 4,5; todos suben**. Tira externa 5,208 → 5,372 (fila nacional) y 5,351 → 5,519
(panel); `.ee-st.bajo` 5,231 → 5,396.

#### (b) Vista histórica de la ficha — **AL BACKLOG**

Deja de ser un pendiente de esta decisión y pasa a ser un ítem propio del backlog.

| Elemento | Color | Fondo | Ratio |
|---|---|---|---|
| `.ybar-val` | `--tinta` `#23303A` | colores de INDICADOR | 1,86 – 4,40 |
| `.ybar-sig` | `--st-neutro` / `--alerta` | colores de INDICADOR | 1,04 – 2,78 |
| `.hist-trend.al`, `.ht-ic` | `--alerta` `#EE2D49` | `#FFFFFF` | 4,11 |

**Por qué no se resuelve con un token, que es lo que distingue este caso de (a):** los
valores van **sobre las barras de color de INDICADOR**, y el peor caso —1,04— es texto
sobre prácticamente su propio color. No existe un token de texto que sirva para las
cuatro familias de indicador a la vez y para todos sus tonos derivados; cualquier color
fijo que funcione sobre `#3858A3` fracasa sobre `#C8DD92`. La salida pasa por **diseño**:
sacar el valor fuera de la barra, o elegir el color del texto según la luminancia del
fondo de cada barra. Ambas cambian la lámina, así que piden **mockup y aprobación del
titular** antes de tocar código. De ahí que sea backlog y no pendiente.

*Desde el 2026-09-16 (s29g) este ítem se lee junto con §5.5 (2) y (4) en la **§5.6**,
que los agrupa como un solo problema —texto sobre color de la paleta de INDICADOR— y
enumera las tres salidas posibles para el mockup.*

#### (c) Los dos usos atenuados por `opacity` — **EXENTOS, no pendientes**

| Elemento | Fondo | Ratio | Naturaleza |
|---|---|---|---|
| `.ybar-yr` dentro de `.ybar-col.is-off` (`opacity:.5`) | `#FFFFFF` | 2,13 | texto de componente **inactivo** |
| `.sw-line.mm` (`opacity:.6`) dentro de `.ficha-explain` | `#eef3f7` | 2,42 | **muestra de línea**, no texto |

Se declaran **exentos**, con fundamento en la norma y no por conveniencia:

- **`.ybar-yr` de una columna sin dato.** WCAG 2.1 SC 1.4.3 excluye explícitamente del
  requisito de contraste el texto que forma parte de un **componente de interfaz
  inactivo**. Una columna `.ybar-col.is-off` es exactamente eso: un año deshabilitado,
  atenuado a propósito **para señalar su inactividad**. La atenuación no es un descuido
  de estilo, es el significante.
- **`.sw-line.mm`.** No es texto: es una muestra de línea de 1,6 px en la leyenda del
  promedio móvil, es decir un componente gráfico, y su umbral sería 3:1, no 4,5.

**Condición de caducidad de la exención.** Está atada a lo que la atenuación *significa*,
no a su valor. Si alguna vez `.ybar-col.is-off` deja de marcar "inactivo" —por ejemplo si
se reutiliza para marcar un año preliminar, uno filtrado o cualquier otro estado que el
usuario sí deba leer—, **la exención caduca automáticamente** y hay que volver a medir y
corregir. Lo mismo si `.sw-line.mm` pasa a llevar texto. Quien haga ese cambio es quien
tiene que reabrir este punto.

### 5.4 `.ancla.al` y `.ancla.de` — **RESUELTO el 2026-09-11 (s29f)**

*Abierto el 2026-09-10 (s29e), cerrado el 2026-09-11 (s29f).* El componente `<Ancla/>`
de la ficha de establecimiento —desvío vs GSE y vs evaluación anterior de dimensiones y
subdimensiones, texto de 14 px: `"vs su GSE ▼ -15 · sig."`— repetía exactamente el
defecto de los chips. Mismo remedio: color de texto del estado, fondos y bordes
intactos.

| Elemento | Color antes | Color después | Fondo | Antes | Después | Exige |
|---|---|---|---|---|---|---|
| `.ancla.al` | `--alerta` `#EE2D49` | `--alerta-txt` `#CE112C` | `--alerta-bg` `#FBE3E6` | 3,374 | **4,606** | 4,5 |
| `.ancla.de` | `--destaca` `#2A8FD9` | `--destaca-txt` `#1E6EA9` | `--destaca-bg` `#E2F0FB` | 3,000 | **4,689** | 4,5 |

Medido en el motor cargado; `.ancla.de` verificado en el Liceo Atenea (RBD 134), porque
el RBD 12301 no dibuja ninguna. Barrido del patrón "color de barra sobre su `-bg`" en
toda la plantilla: los únicos selectores que lo repiten son los glifos `.ee-gl`,
cubiertos por §3.5. No queda ningún otro.

**Con esto el inventario de usos de los tokens `-txt` (§3.3) tiene cuatro entradas:**
tira externa, `.ee-st`, chips del panorama, anclas de la ficha. *(Desde s29g son cinco:
se suma la glosa de estados de `.ficha-explain`, §5.5 (3).)*

### 5.5 Hallazgos de la auditoría de la ficha (s29f) — **(1) y (3) RESUELTOS el 2026-09-16 (s29g); (2) y (4) reagrupados en §5.6**

*Abiertos el 2026-09-11; cerrados o reagrupados el 2026-09-16.* s29f auditó por primera
vez la **ficha de establecimiento** (vista actual, no la histórica, que sigue en el
backlog de §5.3 b). Aparecieron **cuatro** fallas de AA que ninguna excepción cubre.
Todas son **anteriores** a s29f, ninguna la empeora, y dos las **mejora** sin llegar.
s29g cierra las dos que se arreglan con tokens ya existentes —(1) y (3)— y saca las
otras dos —(2) y (4)— de esta lista para juntarlas con §5.3 (b) en la §5.6, porque las
tres son el mismo problema de diseño y ninguna se resuelve con un token.

**(1) El sufijo `"· sig."` / `"· n.s."` dentro del ancla, atenuado — RESUELTO el
2026-09-16 (s29g).** El `<span>` que cierra cada ancla llevaba `opacity:.8` inline
(línea ~771 del JSX). Aunque la Fase 2 de s29f arregló el color del ancla, la opacidad
dejaba ese sufijo por debajo. s29g quitó la `opacity` del `style` inline; tamaño
(`--fs-overline`) y texto intactos:

| Ancla | Antes de s29f | Tras s29f (`opacity:.8`) | **Tras s29g (`opacity` 1)** | Exige |
|---|---|---|---|---|
| `.ancla.al` | 2,817 | 3,718 | **4,606** ✓ | 4,5 |
| `.ancla.de` | 2,380 | 3,301 | **4,689** ✓ | 4,5 |
| `.ancla` neutra (`--tinta` sobre `#fff`) | — | 7,121 ✓ | **13,502** ✓ | 4,5 |

Es 12 px y **sí es información** ("sig." vs "n.s." es lo que distingue una diferencia
significativa de una aritmética). No se tocó el peso de fuente: la jerarquía visual del
sufijo la da el tamaño (12 px frente a los 14 px del número), y a opacidad 1 sigue
leyéndose como sufijo. La rama neutra del ancla (sin clase de estado, fondo blanco)
también pierde la atenuación y sube; se anota para que nadie la lea como regresión.

**(2) `.defn-title` con el color del INDICADOR sobre blanco — REAGRUPADO en §5.6
(s29g).** El título "¿Qué mide este indicador?" de cada panel toma `ind.color` por
estilo inline (línea ~707), a 14 px/700:

| Indicador | Color | Ratio sobre `#FFFFFF` |
|---|---|---|
| Autoestima (`--ind1`) | `#3858A3` | 6,790 ✓ |
| Convivencia (`--ind2`) | `#61BDC6` | **2,187** |
| Participación (`--ind3`) | `#4BA560` | **3,066** |
| Hábitos (`--ind4`) | `#AACB58` | **1,843** |

Tres de cuatro fallan, dos de ellas gravemente. Es la paleta de INDICADOR usada como
texto: no hay token de texto para ella y crearlo es una decisión de identidad
(P-PALETA). La salida barata es dejar el título en `--tinta` y mantener el color del
indicador solo en el punto (`.indp-dot`) que ya lo lleva al lado. **s29g no la aplicó**:
aunque es barata, elegirla fija implícitamente una regla ("el texto nunca lleva color
de indicador") que también decide (4) y §5.3 (b); esa regla se decide una vez, en
§5.6, con mockup.

**(3) Los `<span>` inline `"▼ rojo"` / `"▲ azul"` de `.ficha-explain` — RESUELTO el
2026-09-16 (s29g).** Texto explicativo a 14 px que llevaba el color de BARRA sobre
`#eef3f7` (línea ~1310 del JSX). s29g lo pasó a los tokens de texto; es el quinto uso
del inventario de §3.3:

| Span | Color antes | Color después | Antes | **Después** | Exige |
|---|---|---|---|---|---|
| "▼ rojo" | `--alerta` `#EE2D49` | `--alerta-txt` `#CE112C` | 3,681 | **5,025** ✓ | 4,5 |
| "▲ azul" | `--destaca` `#2A8FD9` | `--destaca-txt` `#1E6EA9` | 3,118 | **4,872** ✓ | 4,5 |

Fondo, peso y texto intactos. Es JSX inline, no una declaración CSS.

**(4) La etiqueta blanca `"10%"` sobre la barra de dimensión — REAGRUPADO en §5.6
(s29g).** Blanco a 12 px/600 sobre `#4C939A`, un tono derivado de `--ind2`: **3,531**.
Es hermana de la excepción §3.4 —etiqueta blanca dentro de una barra— pero sobre tono
de **indicador**, no de estado, así que §3.4 no la cubre literalmente. Cabe extender
§3.4 a las barras de dimensión con el mismo argumento (el valor está en el `title` y al
lado de la barra), o sacar la etiqueta fuera. Es decisión, no ejecución, y es la misma
decisión que (2) y que §5.3 (b): ver §5.6, que además corrige la atribución: la
etiqueta es la de `.bar span` en `DistBar` (niveles de la subdimensión), no la de la
barra de dimensión, y ya lleva inversión por luminancia (`_txtOn`) que en ese tono no
basta.

### 5.6 Texto sobre un color de la paleta de INDICADOR — **RESUELTO el 2026-09-23 (s32g)**

*Abierta el 2026-09-16 (s29g) como reagrupación; el único hallazgo nuevo es el anexo
del tooltip.* Tres pendientes que hasta aquí vivían en secciones distintas —§5.3 (b),
§5.5 (2) y §5.5 (4)— son **un solo problema de diseño**, y por eso se juntan en un solo
ítem de backlog:

| Origen | Elemento | Qué cae sobre qué | Ratio | Exige |
|---|---|---|---|---|
| §5.3 (b) | `.ybar-val`, `.ybar-sig` (vista histórica) | `--tinta` / `--alerta` / `--st-neutro` sobre **barras de indicador** | 1,04 – 4,40 | 4,5 |
| §5.3 (b) | `.hist-trend.al`, `.ht-ic` (vista histórica) | `--alerta` sobre `#FFFFFF` | 4,11 | 4,5 |
| §5.5 (2) | `.defn-title` (vista actual) | **color de indicador** (`--ind2` / `--ind3` / `--ind4`) sobre `#FFFFFF` | 2,19 / 3,07 / 1,84 | 4,5 |
| §5.5 (4) | etiqueta `"10%"` de `.bar span` en `DistBar` (niveles de la subdimensión, vista actual) | blanco sobre **tono derivado de indicador** (`#4C939A` = `nivelRamp(--ind2).alto`) | 3,53 | 4,5 |

**Corrección de atribución (s29g).** s29f llamó a la fila (4) "etiqueta blanca sobre la
barra de dimensión". La barra de dimensión (`ScoreBar`, `.sbar-fill`) no lleva texto;
la etiqueta `"10%"` a 12 px/600 es la de `.bar span` en **`DistBar`**, la distribución
de niveles (bajo/medio/alto) de cada subdimensión, teñida con `nivelRamp(ind.color)`.
`#4C939A` es exactamente `_darken(#61BDC6, .22)`, el nivel "alto" de Convivencia. El
ratio 3,53 y el problema son reales; cambia el componente al que se le atribuye.

**Anexo al ítem, hallado por el panel adversarial de s29g (fuera de alcance, no
corregido).** El *tooltip* de la vista histórica (`.tt`, fondo `#23303a`, blanco 14 px)
inyecta la línea `"vs GSE: ▼ -13 · sig."` con el color de **barra** del estado (JSX
~l.1099: `var(--destaca)` / `var(--alerta)` / `var(--st-neutro)`). Recalculado sobre
`#23303a`: 3,88 / 3,28 / 3,85, bajo 4,5. Se anota aquí y no en §3.3 por una razón que
importa al que lo arregle: **los tokens `-txt` no sirven sobre fondo oscuro y lo
empeorarían** (2,48 / 2,41 / 2,46), porque están diseñados para fondo claro
(invariante del `:root`). Es de la vista histórica, así que viaja con §5.3 (b) y su
mockup; si se decide una variante *clara* de texto de estado para fondo oscuro, será un
cuarto juego de tokens y una decisión aparte. Cálculo propio con controles; no medido
en navegador (el tooltip pide `hover`).

**Lo que las une.** En las cuatro filas el texto y la superficie comparten la paleta de
INDICADOR —`--ind1..4` y sus tonos derivados—, sea porque el texto *es* de ese color
(`.defn-title`) o porque cae *sobre* él (`.ybar-*`, etiqueta de `DistBar`). Esa paleta
es identidad del folleto de la Agencia (P-PALETA, `20260622_decision_paleta_indicadores.md`)
y es **cuatro** familias con luminancias opuestas: `#3858A3` es oscuro y `#AACB58` y
`#61BDC6` son claros.

**Por qué no se resuelve con un token, a diferencia de los cinco usos de §3.3.** Los
tokens `-txt` de estado funcionan porque los tres estados son colores saturados de
luminancia media y hay un "mismo tono, más oscuro" que sirve sobre todos los fondos
claros del motor. Con la paleta de indicador no existe ese punto: cualquier color fijo
que cumpla sobre `#3858A3` fracasa sobre `#C8DD92`, y un `--indN-txt` por indicador
resolvería el título pero no el texto que cae *sobre* las barras. Tampoco vale la
extensión literal de §3.4 (redundancia del dato), porque `.defn-title` es un título y
no tiene dato redundante en otro sitio.

**Lo que hay que decidir es una regla general**, no cuatro arreglos: *qué hace el
texto cuando cae sobre —o toma— un color de marca*. Las tres salidas posibles, para
mockup:

- **(a) Sacar el texto del relleno.** El valor va fuera de la barra (encima, al lado o
  en la tira externa, como ya hace `StackedBar` desde s29) y el título va en `--tinta`
  con el color del indicador reservado al punto (`.indp-dot`) y a la barra. Es la
  salida que no toca la paleta y no crea tokens; cambia la lámina.
- **(b) Invertir según luminancia.** El texto sobre una barra elige claro u oscuro
  según la luminancia del relleno. **Esta salida ya existe en el motor**: `_txtOn()`
  (plantilla, junto a `nivelRamp`) elige `#fff` o `#2e2710` con umbral 0,55 de luma
  Rec. 601, y es lo que `DistBar` aplica hoy a la etiqueta de (4). Recalculado en s29g
  sobre los 12 tonos de `nivelRamp` de los cuatro indicadores: `_txtOn` acierta en
  **11 de 12** (ratios 4,75 – 10,67), y el único que falla es `#4C939A`, donde **ningún
  color de texto alcanza 4,5** (blanco 3,53; `#2e2710` 4,21; el mejor posible es 4,21).
  Es decir: (b) resolvería `.ybar-*` de la vista histórica, que hoy no invierte nada,
  pero **no puede resolver (4)** —un tono de luminancia media que no admite texto AA a
  12 px— ni `.defn-title`, que es color *como* texto y no *bajo* texto.
- **(c) Una variante de texto por indicador.** Cuatro tokens `--indN-txt`, más oscuros,
  para el texto que hoy toma `ind.color`. Resuelve `.defn-title`; no resuelve el texto
  *sobre* barra. Es una decisión de identidad, porque la paleta pasa a tener ocho hex.

Las tres cambian cómo se ve la lámina o la identidad de la paleta, así que **piden
mockup y aprobación del titular antes de tocar código**. Hasta que exista esa decisión,
las cuatro fallas de la tabla quedan **documentadas y aceptadas como deuda conocida**,
igual que §5.3 (b) lo estaba desde s29e. El criterio de la auditoría de contraste las
trata como una sola exclusión declarada ("ítem de backlog de paleta de indicador").

**Recomendación:** (a) — no toca la paleta, no crea tokens, y su parte más barata
(`.defn-title` en `--tinta`) ya estaba identificada en (2); el mockup debe mostrar la
vista histórica con los valores fuera de la barra para que el titular vea el costo
real. Para (4) en particular, si sacar la etiqueta de `DistBar` rompe la lectura de la
barra de niveles, la alternativa honesta no es (b) —que ya está aplicada y no llega—
sino **extender §3.4** con su mismo argumento: el valor está en el `title` del
segmento (`"alto: 10%"`), y la etiqueta interna se acepta como redundante.


#### Resuelto el 2026-09-23 (s32g)

Mockup: `50_documentacion/andamios/diseno/detalles/mockup_contraste_paleta_indicador_s56.html`.
Log con las mediciones: `50_documentacion/andamios/logs/20260923_contraste_paleta_indicador_s32g_log.md`.
Todas las cifras, en navegador, con colores computados y fondo efectivo compuesto,
fórmula de WCAG 2.1 (calibración 21,00 y 4,48).

- **Título "¿Qué mide este indicador?" — opción B, elegida por el titular sobre el
  mockup.** El texto pasa a `--tinta` y el color del indicador, a un filete vertical de
  4 px a la izquierda (`border-left`, con el mismo `ind.color`; sin hex nuevos). El
  título de dimensión ("Sobre esta dimensión"), que no llevaba color, queda igual.
- **Etiqueta de `DistBar` — corrección de la premisa de (b).** Lo que decía esta
  sección ("en `#4C939A` ningún color de texto alcanza 4,5; el mejor posible es 4,21")
  midió `#2e2710`, el oscuro de `_txtOn`, y no el negro: **el negro da 5,95**. Por eso
  la regla de mayor contraste de §3.5 (`vtTexto`: negro, `--gris` o blanco) resuelve la
  etiqueta sin extender §3.4. `DistBar` pasa de `_txtOn` a `vtTexto`; `_txtOn` queda
  sin uso (se conserva, anotado en el código).
- **Glifos de la vista histórica y marca de tendencia.** `.ybar-sig.de/.al/.nt` y
  `.hist-trend.de/.al/.nt` pasan a los tokens de texto `--destaca-txt`, `--alerta-txt` y
  `--st-neutro-txt`: se pintan sobre fondo claro (el track `#f6f5f6` y la cabecera
  blanca), no sobre las barras, porque la cifra va 19 px por encima de su barra. El
  inventario del `:root` (§3.3) suma estos dos usos: quedan siete.
- **Línea "vs GSE" del tooltip.** Deja de llevar el color de barra y hereda el blanco de
  `.tt`; el estado lo dicen el glifo y "sig./n.s.". Tal como advertía el anexo, los
  tokens `-txt` no servían sobre fondo oscuro; no hizo falta un cuarto juego de tokens.

| Superficie (vista) | Antes | Después |
|---|---|---|
| `.defn-title` del indicador: Autoestima / Clima / Participación / Hábitos (actual) | 6,79 / 2,19 / 3,07 / 1,84 (texto en `ind.color` sobre `#ffffff`) | 13,50 en los cuatro (`#23303a`), con filete del color |
| Etiqueta de `DistBar`, alto de Clima `#4c939a` (actual) | 3,53 (`#ffffff`) | 5,95 (`#000000`) |
| Etiquetas de `DistBar` de una ficha (57) | mínimo 3,53; 5 bajo 4,5 | mínimo 4,74; 0 bajo 4,5 |
| Los 12 tonos de `nivelRamp` con el color elegido | 11 de 12 ≥ 4,5 (Clima alto 3,53) | 12 de 12 ≥ 4,5 (mínimo 4,74, Participación alto con blanco; máximo 15,09) |
| `.ybar-sig.al` / `.ybar-sig.nt` sobre el track `#f6f5f6` (histórica) | 3,79 / 3,24 | 5,18 / 5,07 |
| `.hist-trend.nt` sobre `#ffffff` (histórica) | 3,51 | 5,50 |
| Línea "vs GSE" del tooltip (clase neutra) sobre `#23303a` | 3,85 | 13,50 (`#ffffff`) |

Las clases `.ybar-sig.de` y `.hist-trend.de/.al` no aparecían en la ficha medida; su
contraste con los tokens nuevos se recalcula en la auditoría del mismo log (FASE R).
Ninguna parte quedó congelada. Las paletas de estado y de indicador no cambiaron (md5
de las declaraciones del `:root` igual antes y después) y ninguna cifra del dato cambió
(hash del payload igual en todos los builds).

## 6. Reversión

De un solo punto y trivial en los dos cambios, y ninguno afecta a cifra alguna:

- **Tokens de texto de estado (s29c):** borrar los tres tokens del `:root`, devolver
  `style={{color:s.c}}` a `.s100-ext-it` y devolver `.ee-st` a `color:var(--gris)` sin
  clase de estado.
- **Chips del panorama (s29e):** devolver `.chip.al` y `.chip.de` a `var(--alerta)` y
  `var(--destaca)`. Dos declaraciones.
- **`--alerta-txt` con margen y anclas (s29f):** devolver `--alerta-txt` a `#D2112D` y
  `.ancla.al` / `.ancla.de` a `var(--alerta)` / `var(--destaca)`. Tres declaraciones.
- **Sufijo del ancla y glosa de `.ficha-explain` (s29g):** devolver `opacity:.8` al
  `style` inline del `<span>` del sufijo en `<Ancla/>`, y los dos `<span>` de la glosa a
  `var(--alerta)` / `var(--destaca)`. Tres atributos inline en el JSX.
- **`--gris` (s29d):** devolver `--gris` a `#6b7780` en el `:root`. Una sola
  declaración; los ~60 selectores que lo usan vuelven solos.

En ambos casos, regenerar con `run_all(only = 35L)`.
