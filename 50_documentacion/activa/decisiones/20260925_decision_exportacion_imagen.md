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
