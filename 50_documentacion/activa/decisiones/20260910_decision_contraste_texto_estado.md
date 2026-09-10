# Decisión — Contraste del texto de estado vs GSE y excepción de la etiqueta interna

- **Fecha:** 2026-09-10
- **Sesión:** s29c
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_contraste_texto_estado_s29c.md`
- **Referencia visual vinculante:** `50_documentacion/andamios/diseno/detalles/mockup_contraste_estados.html`
- **Tipo:** decisión de presentación y accesibilidad. NO afecta ninguna cifra.
- **Estado:** adoptada. **Enmendada el 2026-09-10 (s29d):** se cierra el pendiente §5.1
  y se añade la excepción §3.5 de los glifos de estado.

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
| `--alerta-txt` | `#D2112D` | `--alerta` `#EE2D49` | **4,50** | 5,35 |
| `--destaca-txt` | `#1E6EA9` | `--destaca` `#2A8FD9` | **4,50** | 5,35 |
| `--st-neutro-txt` | `#5F6A78` | `--st-neutro` `#7E8A99` | **4,55** | 5,41 |

Contraste de los tres tokens contra **todos** los fondos claros que existen en el motor
(cálculo propio con la fórmula de WCAG 2.1, verificado además en navegador en la Fase 3
del encargo):

| Token | `--cream` `#FFF6E0` | `--cream-200` `#f4e9cc` | `--panel` `#fffdf7` | `--paper` `#ffffff` | fila EE `#F7FBFE` | fila nacional `#FCFAF2` |
|---|---|---|---|---|---|---|
| `--alerta-txt` | 5,06 | 4,50 | 5,35 | 5,44 | 5,23 | 5,21 |
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

### 3.3 Los tokens se aplican en dos lugares, y solo en esos dos

1. **`.s100-ext-it`** — la tira externa bajo la barra apilada. El color deja de viajar
   como estilo inline (`style={{color:s.c}}`, que traía el color de *barra*) y pasa a
   salir de la clase de estado que el elemento ya llevaba: `ext-bajo` → `--alerta-txt`,
   `ext-neutro` → `--st-neutro-txt`, `ext-sobre` → `--destaca-txt`.
2. **`.ee-st`** — el texto "bajo su GSE" / "sin diferencia" / "sobre su GSE" de la fila
   de establecimiento. Deja el gris de interfaz (`--gris`, 3,80 sobre `--cream-200`) y
   toma el token del estado que corresponde, en negrita. `CeldaEE` marca el estado con
   una clase (`ee-st bajo|neutro|sobre`). Además de alcanzar el umbral, el texto queda
   amarrado al glifo, que ya venía teñido del estado.

Los tokens **no entran** a barras, bordes de glifo, fondos ni leyenda. Esa restricción
es un invariante del encargo y está escrita como comentario en el `:root`.

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

## 5. Pendientes asociados (§5.1 resuelto; §5.2 y §5.3 abiertos)

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

### 5.3 Hallazgos nuevos de la auditoría de s29d (requieren decisión)

*Abiertos el 2026-09-10 (s29d).* Al auditar **todo** el texto visible —y no solo las
zonas de un criterio— aparecieron fallas de AA que **no son de `--gris`** y que por
tanto s29d no corrige. Todas son **anteriores** y ninguna la empeora el cambio de
s29d. Se dejan escritas aquí para que no se pierdan.

**(a) `.chip.al` y `.chip.de` del panorama territorial.** Son texto completo —"▼ 4
indicadores bajo su GSE"— pintado con el color de estado sobre su propio fondo teñido,
a 12 px/600:

| Chip | Color | Fondo | Ratio | Exige |
|---|---|---|---|---|
| `.chip.al` | `--alerta` `#EE2D49` | `--alerta-bg` `#FBE3E6` | **3,37** | 4,5 |
| `.chip.de` | `--destaca` `#2A8FD9` | `--destaca-bg` `#E2F0FB` | **3,00** | 4,5 |

Ninguna de las dos excepciones vigentes lo cubre: §3.4 es la etiqueta blanca dentro de
la barra y §3.5 son los glifos `.ee-gl`. Y aquí **el argumento de §3.5 no sirve**: el
glifo se acepta como componente gráfico porque va acompañado del texto del estado; en
el chip, el color **es** el texto, y la cifra ("4 indicadores") no está repetida en
ningún otro sitio de esa tarjeta. La salida natural sería la misma de s29c: usar los
tokens `-txt` (`--alerta-txt`, `--destaca-txt`) en el color del chip, sin tocar su
fondo. Con eso darían 4,81 y 5,05. **No se aplicó** porque el invariante 1 de s29d
prohíbe tocar la paleta de estado y sus tokens, y porque excede el alcance declarado.

**(b) Vista histórica de la ficha de establecimiento.** Es la zona con más deuda del
motor y ninguna de sus fallas es de `--gris`:

| Elemento | Color | Fondo | Ratio |
|---|---|---|---|
| `.ybar-val` | `--tinta` `#23303A` | colores de INDICADOR | 1,86 – 4,40 |
| `.ybar-sig` | `--st-neutro` / `--alerta` | colores de INDICADOR | 1,04 – 2,78 |
| `.hist-trend.al`, `.ht-ic` | `--alerta` `#EE2D49` | `#FFFFFF` | 4,11 |

Son texto sobre las barras de color de indicador. Corregirlo toca la paleta de
INDICADOR o la de ESTADO —invariantes 1 y 2 de s29d— así que es, otra vez, decisión
del titular y no de una ejecución.

**(c) Dos usos de `--gris` atenuados por `opacity`, que siguen bajo el umbral.** El
cambio de s29d los **mejora**, pero no basta:

| Elemento | Fondo | Antes | Después | Exige |
|---|---|---|---|---|
| `.ybar-yr` dentro de `.ybar-col.is-off` (`opacity:.5`) | `#FFFFFF` | 1,94 | 2,13 | 4,5 |
| `.sw-line.mm` (`opacity:.6`) dentro de `.ficha-explain` | `#eef3f7` | 2,15 | 2,42 | 3,0 |

El primero es la etiqueta de año de una columna **sin dato**, atenuada a propósito:
cabe defender que es un componente de interfaz inactivo, que WCAG 1.4.3 exime. El
segundo es una muestra de línea de 1,6 px en la leyenda del promedio móvil. Ambos se
arreglarían subiendo la `opacity`, no tocando el color. Quedan anotados, sin aplicar.

## 6. Reversión

De un solo punto y trivial en los dos cambios, y ninguno afecta a cifra alguna:

- **Tokens de texto de estado (s29c):** borrar los tres tokens del `:root`, devolver
  `style={{color:s.c}}` a `.s100-ext-it` y devolver `.ee-st` a `color:var(--gris)` sin
  clase de estado.
- **`--gris` (s29d):** devolver `--gris` a `#6b7780` en el `:root`. Una sola
  declaración; los ~60 selectores que lo usan vuelven solos.

En ambos casos, regenerar con `run_all(only = 35L)`.
