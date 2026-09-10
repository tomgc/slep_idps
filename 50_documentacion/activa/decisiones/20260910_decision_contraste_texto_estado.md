# Decisión — Contraste del texto de estado vs GSE y excepción de la etiqueta interna

- **Fecha:** 2026-09-10
- **Sesión:** s29c
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_contraste_texto_estado_s29c.md`
- **Referencia visual vinculante:** `50_documentacion/andamios/diseno/detalles/mockup_contraste_estados.html`
- **Tipo:** decisión de presentación y accesibilidad. NO afecta ninguna cifra.
- **Estado:** adoptada.

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

## 4. Garantía de fidelidad (ninguna cifra cambia)

El cambio es 100 % color de texto. No toca el pipeline (31–34), ni el generador
(`35_generar_motor_html.R`), ni `idps_largo.parquet`. Verificación en la Fase 3 del
encargo: métricas del bloque 7 del generador idénticas y payload JSON del motor
byte-idéntico salvo `fecha_generacion`.

## 5. Pendientes asociados (no ejecutados)

### 5.1 Hallazgo nuevo: `--gris` sobre los fondos teñidos de s29 (requiere decisión)

La auditoría de la Fase 3 de este encargo destapó una falla de AA que **no estaba en
la medición de partida y que este encargo no corrige**, porque cae fuera de los dos
lugares que la Fase 1 autoriza a tocar. Es anterior a esta decisión: la introdujo s29
al teñir de celeste las superficies de establecimiento.

`--gris` (`#6b7780`), el gris de interfaz, da **4,59** sobre blanco —pasa— pero solo
**4,41** sobre `#F7FBFE` (fondo de la fila y del chip de establecimiento) y **4,39**
sobre `#FCFAF2` (fila nacional). Ambos quedan bajo 4,5. Elementos afectados, todos
medidos en el motor vivo:

| Elemento | Fondo | Ratio | Estado |
|---|---|---|---|
| `.cmp-cm` en el chip de establecimiento | `#F7FBFE` | 4,41 | **falla** |
| `.cmp-cm` en los demás chips | `#ffffff` | 4,59 | ok |
| `.td-ee-k` ("ESTABLECIMIENTO"), `.td-ee-rbd`, `.ee-nd` | `#F7FBFE` | 4,41 | **falla** |
| `.td-ee-rbd` ("referencia nacional") | `#FCFAF2` | 4,39 | **falla** |
| `.gse-sec-foot` | `#fffdf7` | 4,51 | ok, por 0,01 |

Consecuencia directa: `.cmp-cm` es una de las cinco zonas del criterio "0 fallas" de la
Fase 3 del encargo, y ese criterio **no se cumple** por esta causa —no por los tokens
de estado, que sí pasan en todas partes.

Es una decisión del titular, no de esta ejecución, porque las dos salidas posibles
salen del alcance declarado:

- **(a) Un token de texto gris para fondos teñidos** —p. ej. `--gris-txt:#5F6A73`—
  aplicado a `.cmp-cm`, `.td-ee-k`, `.td-ee-rbd` y `.ee-nd`. Es el camino recomendado:
  simétrico con lo que esta decisión hace con los colores de estado, y verificado en
  5,3 sobre ambos fondos teñidos.
- **(b) Declarar una segunda excepción**, como se hizo con la etiqueta interna de la
  barra. Es más débil que la de §3.4: aquí el dato **no** está repetido en otro sitio
  (el RBD y la comuna del establecimiento solo se leen ahí), así que el argumento de
  redundancia no aplica.

Mientras no se decida, queda escrito aquí que la falla existe, cuánto mide y por qué
no se tocó.

### 5.2 Marca de "base pequeña"

La marca de **"base pequeña"** (sección 4 del mockup) queda al backlog. Son dos piezas:
el N de la fila en esa sección bajo el nombre de la entidad —hoy ese dato solo vive en
el `title` de la barra— y una marca visible cuando ese N cae bajo un umbral. **El umbral
es una decisión metodológica, no de diseño**, y el titular aún no lo ha fijado. No se
implementa nada de eso hasta que exista una decisión de proyecto que fije el umbral y
lo justifique.

## 6. Reversión

De un solo punto y trivial: borrar los tres tokens del `:root`, devolver
`style={{color:s.c}}` a `.s100-ext-it`, devolver `.ee-st` a `color:var(--gris)` sin
clase de estado, y regenerar con `run_all(only = 35L)`. Ninguna cifra se ve afectada
por una reversión.
