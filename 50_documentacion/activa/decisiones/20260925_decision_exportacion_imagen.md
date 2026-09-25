# Decisión: exportación de imagen del comparador y del panorama (P-EXPORTACION-IMAGEN)

- **Fecha:** 2026-09-25
- **Sesión:** s33 (traspaso vigente v31)
- **Encargo que implementa la primera parte:** `50_documentacion/activa/encargos/encargo_claude_code_idps_ejecucion_final_s33o.md` (T3)
- **Evidencia:** `50_documentacion/andamios/diseno/detalles/20260924_diagnostico_exportacion_imagen.md` y `mockup_exportacion_imagen_s33m.html` (log s33m)
- **Tipo:** decisión de producto. No afecta ninguna cifra.
- **Estado:** adoptada por el titular el 2026-09-25.

## 1. Alternativa

**(d) C ahora y A después.** Primero, impresión limpia con reglas `@media print` (C). Después, en un encargo aparte, el redibujo de las barras en SVG con un solo dibujante para pantalla y exportación (A), que tiene precedente en `slep_simce_adecuado`. B (`foreignObject`) queda descartada.

## 2. Alcance y forma de C (criterio delegado por el titular)

- **Pantallas:** comparador, panorama (vista actual e histórica) y ficha del establecimiento.
- **Papel:** A4 **horizontal**, márgenes de 12 mm (~1.032 px útiles), para que la tabla del comparador (`min-width: 810px`) quepa sin reducir su ancho.
- **Qué se imprime:** el contenido de la vista con sus títulos, leyendas y notas. Se ocultan la navegación, las pestañas, los controles, los botones y los modales.
- **Color:** `print-color-adjust: exact` en barras y muestras de color, para que salgan aunque la impresión no traiga "gráficos de fondo".
- **Sin botón "Imprimir"** en esta etapa: se imprime con el comando del navegador. Si el uso en terreno lo pide, se agrega en el encargo de A.

## 3. Riesgo

Nulo para la pantalla: las reglas solo rigen al imprimir. El encargo lo verifica con capturas idénticas antes y después.

## 4. Parte A: un solo trazado para pantalla y archivo (enmienda del 2026-09-25, criterio delegado por el titular)

C quedó desplegada en s33o. Para A se elige la variante de **trazado único**: una función pura calcula el trazado de cada barra (anchos de segmento redondeados con `pctRound`, qué etiquetas "p% (n)" caben dentro y cuáles bajan a la tira externa, el texto de `N`, la marca de base pequeña, la nota `sin`, "sin dato", los `title` y el `aria-label`, y el corte de líneas de los textos largos) a partir del reparto, el ancho disponible y una función de medición de texto. La pantalla (HTML, como hoy) y el archivo (SVG) **pintan lo que esa función decide**; ninguno de los dos decide por su cuenta.

- **Por qué esta variante y no reescribir `StackedBar` en SVG:** la regla que importa, que pantalla e imagen no puedan divergir, se cumple porque las decisiones salen del mismo código; y la pantalla puede quedar idéntica píxel a píxel a la publicada, lo que baja el riesgo de alto a nulo y permite verificarla sin revisión visual. Lo que no se comparte es solo la primitiva de pintado (un `div` o un `rect`).
- **A1 (encargo s33s):** trazado único y exportación del **comparador** en SVG y PNG. Se despliega en el mismo encargo solo si la pantalla queda idéntica a la publicada.
- **A2 (encargo posterior):** exportación del **panorama**: franjas por GSE de la vista actual (sin la grilla de tarjetas, que es navegación) y franja de la vista histórica. La matriz histórica queda fuera salvo decisión nueva.
- **Tipografía del archivo:** la pila del sistema que ya usa la exportación del radar (`SVG_FUENTE`). El trazado se calcula con la medición de la fuente del destino (la de marca en pantalla; la del sistema en el archivo): las mismas reglas deciden con las métricas de cada uno.
- **Techo del PNG:** el comportamiento que ya tiene el motor para el radar: si la imagen supera el techo seguro, se avisa y se ofrece el SVG (alternativa c).
- **Nombre del archivo:** el mismo del CSV del comparador, con extensión `.svg` o `.png`.
