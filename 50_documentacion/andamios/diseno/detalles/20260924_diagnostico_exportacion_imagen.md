# Diagnóstico de la exportación de imagen del comparador y del panorama (s33m T2, pendiente 7)

> Acompaña al mockup `mockup_exportacion_imagen_s33m.html` (misma carpeta), que dibuja una sección del comparador con las
> tres alternativas y el archivo que produce cada una. Este documento **no recomienda** una alternativa: presenta lo medido y lo
> que cada una exige. La decisión es del titular (pendiente 7, P-EXPORTACION-IMAGEN).
>
> Medido el 2026-09-25 sobre `40_salidas/motor_idps.html` (md5 `7ad76f36e42d66c4da2d71aa28a558eb`, el publicado en `docs/`),
> con Chrome del sistema por Puppeteer. Los comandos y las salidas literales están en el log
> `50_documentacion/andamios/logs/20260924_preparacion_decisiones_s33m_log.md` (M5 y FASE T2).

## 1. Qué dibuja hoy cada pantalla

Censo en ejecución (elementos visibles, 4° básico 2025; panorama y ficha con el territorio de apertura, el SLEP foco; comparador
con Chile y el SLEP foco) y lectura de la plantilla `30_procesamiento/35_motor_template.html`:

| Componente | Tecnología | Pantalla · vista | En el estado medido | Exportación hoy |
|---|---|---|---:|---|
| `Radar` (D3) | SVG | Panorama territorial · Vista actual (una por tarjeta, 168 px) | 60 tarjetas | ninguna |
| `Radar` (D3) | SVG | Ficha · Vista actual (300 px) | 1 | **imagen SVG y PNG** (clona el SVG vivo); CSV de la serie |
| `StackedBar` (`.s100`) | HTML (divs con `width` en %) | Comparador (cada celda de entidad) | 40 | CSV del comparador |
| `StackedBar` (`.s100`) | HTML | Panorama territorial · Vista actual (4 por GSE) | 16 | CSV del panorama |
| `StackedBar` (`.s100`) | HTML | Panorama territorial · Vista histórica (franja por año) | 40 | CSV histórico |
| Matriz histórica (`table.vt-mx`) | HTML (celdas teñidas) | Panorama territorial · Vista histórica | 5 tablas, 549 celdas | CSV histórico |
| `DistBar` (`.bar`) | HTML | Ficha · Vista actual (niveles de subdimensión) | 22 | CSV de la serie (sin niveles) |
| `ScoreBar` (`.sbar`) | HTML | Ficha · Vista actual (puntaje de dimensión) | 11 | CSV de la serie |
| `BarrasAnio` (`.ybars-wrap`) | HTML con una capa SVG (media móvil, `.ybar-mm`) | Ficha · Vista histórica | 15 paneles, 91 barras, 15 capas SVG | CSV de la serie |
| Fila de establecimiento del comparador (`CeldaEE`) | HTML (glifo y puntaje, sin barra) | Comparador | — | CSV del comparador |

`canvas`: 0 en todas las pantallas. Reglas `@media print`: ninguna en la plantilla.

**Diferencias con la premisa del encargo (hallazgo H-1 del log).** El radar no es el único SVG: es SVG en dos pantallas (la ficha y
cada tarjeta del panorama) y `BarrasAnio` lleva una capa SVG. El comparador y el panorama no tienen "barra de puntaje": la fila de
establecimiento del comparador es texto con glifo, y el panorama combina `StackedBar` (HTML) con tarjetas cuyo mini-radar ya es SVG
pero cuyo marco (nombre, RBD, chips) es HTML. La única barra de puntaje del motor es `ScoreBar`, en la ficha. Por eso, en lo que
sigue, "las barras del comparador y del panorama" son `StackedBar`.

## 2. La regla "un solo dibujante" y su referencia vinculante

- **En el motor.** El comentario de la plantilla (línea 2468, "PENDIENTE ANOTADO") ya deja escrita la razón: exportar el comparador
  o el panorama como imagen exigiría reconstruir en SVG lo que hoy es HTML (`StackedBar`, su regla de etiquetado medida en píxeles,
  la tira externa y la tabla), y un segundo dibujante podría divergir del de pantalla. La exportación actual del radar cumple la
  regla: `construirSvgRadar` (línea 2557) **clona el SVG vivo** de `.rquad-svg` con `clonarSvgResuelto` (línea 2534) y
  `rasterizarSvgAPng` (línea 2651) lo pasa a PNG con el techo `PNG_MAX_SUPERFICIE_PX = 16.777.216`.
- **En el proyecto hermano** (`slep_simce_adecuado/30_procesamiento/33_motor_template.html`, último cambio `07b860c`, 2026-09-24;
  regla s29h: su implementación es la referencia):
  - líneas 3043–3047: "El dibujo vive en una sola función que recibe un `<g>` de destino, de modo que la pantalla y el SVG exportado
    salen del mismo código y no pueden divergir. Es la lección de la exportación del supergrid, donde el constructor del SVG
    reimplementa el layout de las tarjetas." La función es `dibujarPanoramaEnGrupo` (línea 3061), llamada por la pantalla
    (`PanoramaChart`, línea 3243) y por el exportador (`construirSvgPanorama`, línea 3318);
  - líneas 2731–2955: `construirSvgGraficos`, el contraejemplo que motivó la lección (clona los SVG de cada celda y **reimplementa**
    el layout que los rodea);
  - línea 2983: el rasterizador compartido, con el mismo techo de superficie.
  - El hermano no usa `foreignObject` ni reglas `@media print` (0 coincidencias de cada uno): **A** tiene precedente vinculante;
    **B** y **C** no lo tienen.

## 3. Qué exigiría exportar el comparador y el panorama

**Qué hay que dibujar.** Comparador: por cada GSE visible, una tabla con una fila por entidad (cuatro `StackedBar`, cada una con su
tira externa y su nota `sin`) y, al final, las filas de establecimiento (glifo, puntaje y estado, sin barra). Panorama, Vista actual:
por cada GSE, cuatro `StackedBar` y la grilla de tarjetas (una por establecimiento; en el nivel nacional la grilla no se muestra).
Panorama, Vista histórica: la franja (una `StackedBar` por indicador y año) y la matriz de celdas teñidas.

**Tamaño real en pantalla** (ventana de 1280 px, 4° básico 2025) y superficie de un PNG, frente al techo del rasterizador
(16,78 Mpx):

| Caso | Ancho × alto (px) | PNG 1x (Mpx) | PNG 2x (Mpx) | 2x frente al techo |
|---|---:|---:|---:|---:|
| Comparador con 10 entidades (el tope) | 1.150 × 4.289 | 4,93 | 19,73 | 1,18 |
| Panorama, SLEP foco (60 tarjetas) | 1.150 × 6.734 | 7,74 | 30,98 | 1,85 |
| Panorama, nacional (sin grilla) | 1.150 × 2.432 | 2,80 | 11,19 | 0,67 |

Con la escala 2x de la exportación del radar, el comparador completo y el panorama con grilla pasan el techo: A y B tendrían que
bajar la escala, partir la imagen (por GSE, por ejemplo) o dejar el PNG solo para casos pequeños y ofrecer el SVG.

**Cómo imprime hoy el motor** (línea base de C; comparador con 10 entidades, A4, sin "gráficos de fondo", que es lo que Chrome trae
por defecto): **7 páginas**; se imprimen la cabecera, las pestañas, los chips, el segmentador y los botones; las barras salen
**sin relleno** (el rojo de "bajo" suma 903 píxeles en las 7 páginas a 40 ppp: solo el texto rojo de la tira externa); y la cuarta
columna queda **cortada** en el borde derecho ("Saludable" aparece 0 veces en el texto del PDF, frente a 10 de "Hábitos"), porque la
tabla tiene `min-width:810px` dentro de un contenedor con `overflow-x:auto` y el área útil de un A4 vertical es menor.

## 4. Las tres alternativas

### A. Redibujar en SVG las barras y exportar ese mismo SVG (y PNG desde él)

- **Qué cambia.** `StackedBar` (hoy 62 líneas, líneas 1096–1157, 4.318 bytes) se reescribe como un dibujante SVG que recibe un `<g>` de destino y
  que usan la pantalla y el exportador: la barra, la regla de etiquetado medida en píxeles, la tira externa (hoy un grid CSS alineado
  por sector), el estado vacío "sin dato", la nota `sin`, los `title` por segmento y el `aria-label` del contenedor. Se agregan
  exportadores del comparador (layout de la tabla: columna de entidad, cuatro columnas, filas de establecimiento con glifo y puntaje,
  encabezados, leyenda, pie) y del panorama (franja y, si se incluye, la grilla de tarjetas, cuyo marco hoy es HTML).
- **Lo que el SVG no hace solo.** El HTML parte las líneas; el SVG no. En el mockup, la primera versión de A dejó la nota
  "+2 sin comparación válida" pisando la celda vecina; hubo que medir y partir por palabras (también el nombre de la entidad). El
  dibujante del motor tendría que hacerlo en cada texto que hoy se acomoda solo.
- **Riesgo para la pantalla actual: alto.** `StackedBar` dibuja el comparador, el panorama (Vista actual) y la franja de la vista
  histórica; cambia por construcción lo que ve el usuario en las tres (nuevo gate visual; los controles AE a 1280 de sesiones
  anteriores dejan de valer); los instrumentos que leen `.s100`, su `title` y `.s100-sin` (entre ellos el control M4 de esta sesión)
  hay que rehacerlos; el comportamiento angosto cambia (un SVG con `viewBox` escala el texto en vez de re-medir la etiqueta).
- **Peso en el motor.** En el mockup, el dibujante y el exportador de una sección suman 9.081 bytes (más 2.742 del rasterizador,
  que el motor ya tiene). Con el motor en 5.477.900 bytes (casi todo el payload), el peso no es el costo: lo es el cambio de
  componente.
- **Esfuerzo estimado: 5 tareas** (probablemente dos encargos): (1) `StackedBar` → dibujante SVG con la misma regla de etiquetado,
  tira externa y accesibilidad, verificado en las tres pantallas a 390 y 1280 px; (2) exportador del comparador (SVG y PNG);
  (3) exportador del panorama y de la franja (y decidir la grilla de tarjetas); (4) techo de PNG (escala o partición);
  (5) fidelidad pantalla ↔ imagen y actualización de los instrumentos de verificación.
- **Lo que mostró el mockup.** SVG de 21,3 KB y PNG 2x de 251,8 KB (1.200 × 1.190 px), generados sin error; XML bien formado;
  **otro programa (librsvg) lo dibuja igual** (13.445 píxeles del rojo de "bajo" a 1x frente a 56.247 a 2x en Chrome, la
  proporción ×4 esperada): el SVG es un archivo vectorial portable y editable.

### B. HTML en pantalla y exportar lo que la pantalla ya dibuja, con `foreignObject`

- **Qué cambia.** La pantalla no se toca. Se agrega un exportador: clonar la sección con sus estilos calculados (en el mockup, 39
  propiedades por elemento), envolverla en un `<foreignObject>` dentro de un SVG y rasterizarla.
- **Riesgo para la pantalla actual: bajo.** Los riesgos están en el archivo:
  1. **Canvas contaminado.** En Chrome, rasterizar el SVG con `foreignObject` desde una URL `blob:` falla:
     `Failed to execute 'toBlob' on 'HTMLCanvasElement': Tainted canvases may not be exported.`; desde una URL `data:` sí genera el
     PNG (medido en el mockup). Safari y Firefox **no se midieron** en esta sesión.
  2. **El SVG solo lo dibuja un navegador.** librsvg lo deja en blanco (0 píxeles no blancos). El "SVG" de B no es un archivo
     vectorial portable; lo útil es el PNG. Los editores vectoriales no se midieron.
  3. **Tipografía.** Un SVG usado como imagen no ve las fuentes del documento. El motor embebe 7 caras (502.071 bytes; la del cuerpo,
     Museo Sans, en 4 pesos de ~85 KB cada uno). O cada archivo lleva las caras que usa, o la imagen sale con otra tipografía; y con
     otra tipografía la regla de etiquetado (medida con la fuente de pantalla) puede dejar dentro del segmento un "p% (n)" que en la
     imagen ya no cabe, lo que el motor prohíbe (nunca un número a medias). No se midió en el motor.
  4. **Peso del archivo.** SVG del mockup: 183,3 KB, frente a 21,3 KB de A (los estilos van en línea en cada elemento).
  5. El techo de PNG de §3 rige igual.
- **Peso en el motor.** 1.484 bytes en el mockup (clon y envoltorio), más el paso a URL `data:` en el rasterizador existente.
- **Esfuerzo estimado: 2 tareas**: (1) exportador del comparador y del panorama (clon con estilos, URL `data:`, techo de PNG,
  decisión sobre las fuentes); (2) verificación en los navegadores del titular y en el programa donde se pegará la imagen.
- **"Un solo dibujante".** Se cumple en el sentido de que la imagen es la pantalla clonada; pero el resultado depende del motor de
  render del navegador que exporta, cosa que A no tiene.

### C. Sin imagen: impresión limpia con `@media print`

- **Qué cambia.** Un bloque de reglas de impresión (416 bytes en el mockup) y, si se quiere, un botón que llame a imprimir: ocultar
  cabecera, pestañas, controles, botones y modales; `print-color-adjust: exact` en barras y muestras de color; no partir una sección
  de GSE entre páginas; y resolver el ancho de la tabla (`min-width:810px`) frente al A4: el área útil con márgenes de 12 mm es
  ~703 px en vertical y ~1.032 px en horizontal, a 96 ppp.
- **Un detalle técnico.** La etiqueta "p% (n)" dentro de cada segmento se decide en píxeles al ancho de pantalla (ResizeObserver);
  al imprimir el ancho cambia. O la impresión fija un ancho de tabla, o el motor vuelve a medir al imprimir (`beforeprint`). El
  mockup evita el problema con un ancho fijo de 560 px, igual en pantalla y en papel.
- **Riesgo para la pantalla actual: nulo.** Las reglas solo rigen al imprimir (verificable con el control AE a 1280).
- **Peso en el motor.** Menos de 1 KB.
- **Esfuerzo estimado: 1 o 2 tareas**: (1) reglas de impresión del comparador, el panorama y la ficha, verificadas en PDF (páginas,
  colores, cortes); (2) opcional: botón "Imprimir" y re-medición de etiquetas al imprimir.
- **Lo que mostró el mockup.** PDF A4 de 1 página (212 KB) con solo la sección (cabecera, A, B y el resumen quedan ocultos); con las
  barras en color aunque la impresión no traiga "gráficos de fondo": 7.555 píxeles del rojo de "bajo"; **control**: una copia sin la
  regla `print-color-adjust` da 913 (solo el texto rojo), así que es esa regla la que trae los colores.
- **Límite.** El resultado es un PDF del navegador, no una imagen para pegar en una presentación.

### Resumen

| | A · SVG | B · foreignObject | C · impresión |
|---|---|---|---|
| Componentes del motor que cambian | `StackedBar` (3 pantallas) y dos exportadores nuevos | un exportador nuevo | reglas de impresión |
| Riesgo para la pantalla actual | alto | bajo | nulo |
| Código en el mockup (bytes) | 9.081 (+2.742 del rasterizador, que el motor ya tiene) | 1.484 (+ el mismo rasterizador) | 416 |
| Esfuerzo estimado | 5 tareas | 2 tareas | 1 o 2 tareas |
| Archivo que produce | SVG portable y PNG | PNG (el SVG solo se ve en navegadores) | PDF |
| Medido en el mockup | SVG 21,3 KB, PNG 2x 251,8 KB; librsvg lo dibuja | SVG 183,3 KB, PNG 2x 256,9 KB solo por URL `data:`; librsvg: en blanco | 1 página A4; colores solo con `print-color-adjust` |
| Precedente en el hermano | sí (`dibujarPanoramaEnGrupo`) | no | no |

## 5. Lo que el titular decide

Ninguna se responde aquí.

1. **La alternativa.** ¿(a) A; (b) B; (c) C; o (d) C ahora y A en un encargo posterior?
2. **El alcance.** ¿Solo el comparador, o también el panorama (Vista actual con o sin la grilla de tarjetas; vista histórica)?
3. **Si A o B: el techo del PNG.** Cuando la imagen pasa los 16,78 Mpx, ¿(a) se baja la escala; (b) se parte por GSE; o (c) solo se
   ofrece el SVG (solo en A, donde el SVG es portable)?
4. **Si B: la tipografía.** ¿(a) cada archivo lleva las caras de Museo Sans que usa (~85 KB por peso); o (b) se acepta la tipografía
   del sistema en la imagen?
5. **Si C: el papel.** ¿A4 (a) vertical, con la tabla bajo su ancho mínimo actual; o (b) horizontal?

## 6. Cómo se midió

- Mockup: `mockup_exportacion_imagen_s33m.html`, autocontenido (sin librerías, sin fuentes externas, sin ninguna referencia de red);
  sus datos son conteos de territorio (SLEP Costa Central, 4° básico 2025) generados en R desde la réplica de T1
  (`20260924_diagnostico_base_pequena.R`); tipografía del sistema.
- Instrumentos en `/tmp/s33m_*` (descritos en el log): `s33m_m5.js` (censo de §1), `s33m_t2_verif.js` (consola, red, descargas,
  impresión, 390 px), `s33m_t2_archivos.sh` (XML, librsvg, píxeles, PDF), `s33m_t2_extra.js` (control de C), `s33m_t2_alturas.js` y
  `s33m_t2_imprimir_motor.js` (tamaños y línea base de impresión del motor), `s33m_t2_peso.py` (bytes de código), `s33m_fuentes.py`
  (caras embebidas).
