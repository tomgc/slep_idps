# Encargo de ejecución — slep_idps · Encargo 2 de 2: producto completo + deploy a GitHub Pages

Motor base aprobado: abre, renderiza, spot-check 1:1 contra el parquet, cero
agregación. Excelente trabajo, incluida la cacería de los bugs de `sigdifgru` y
del mojibake de grados. Seguimos en modo autónomo, bloques grandes. Este es el
**segundo y último encargo**: lo llevas de motor base local a **producto completo
desplegado en GitHub Pages**, como los dos proyectos hermanos
(`tomgc.github.io/slep_categoria_desempeno`, `tomgc.github.io/slep_simce_adecuado`).

El titular fijó cuatro definiciones que reordenan prioridades respecto del motor
base. Léelas como el norte de este encargo, no como detalles:

1. **Todo Chile, obligatorio.** El producto incluye los establecimientos de todo
   el país (no solo Región de Valparaíso). El objetivo es que sirva a cualquier
   SLEP y permita explorar cualquier comuna. Amplía el universo embebido de
   cod_reg=5 a Chile completo.
2. **Navegación territorial completa, obligatoria.** Menús navegables por
   territorio como en los proyectos hermanos: región → SLEP → comuna →
   establecimiento. No es un filtro secundario: es navegación de primer nivel.
3. **El GSE de referencia es el corazón interpretativo.** La escala 0-100 del
   IDPS no dice por sí sola si un establecimiento va bien o mal: es relativa. Las
   únicas anclas reales son la **diferencia vs su GSE** (`difgru`/`sigdifgru`,
   número + significancia) y la **diferencia vs la evaluación anterior**
   (`dif`/`sigdif`, número + significancia). Esto debe ser **protagonista** de la
   UI: es lo que permite leer el dato y levantar alertas. No es una marca
   discreta al costado; es un eje central de lectura.
4. **Visualizar toda la jerarquía.** 4 indicadores → 11 dimensiones → 30
   subdimensiones (estas últimas desde las aplicaciones recientes). El desafío es
   mostrar todo lo navegable que se pueda.

Sobre tamaño: **no optimices por peso porque sí.** El producto debe ser
eficiente, estar optimizado para los navegadores principales y no estar inflado
con dependencias innecesarias, pero la prioridad es un **producto completo y bien
hecho**, no un archivo liviano. Todo Chile pesará más que Valparaíso y eso está
aceptado. Si el peso afecta el rendimiento real (no el número en disco), resuélvelo
con criterio técnico (build de Babel previo en vez de in-client, D3 a los módulos
usados, serialización columnar), pero sin sacrificar completitud.

**Gobernanza: zanjada.** Todos los datos son públicos (repositorio público de la
Agencia, accesibles por cualquiera). Publicar todo Chile nominalmente está
confirmado por el titular. No verifiques ni preguntes nada sobre esto: procede al
deploy.

Para cualquier cosa de GitHub Pages, dependencias de Anthropic o detalles de
producto, consulta la skill product-self-knowledge antes de afirmar de memoria.

---

## 1. Fase A — Ampliar a todo Chile + navegación territorial

### A.1 — Universo nacional

- Cambia el alcance del embebido en `35_generar_motor_html.R` de cod_reg=5 a
  **todo Chile**. El JSON crecerá; serialízalo de la forma más eficiente posible
  (columnar, tipos compactos) sin perder ningún establecimiento ni año.
- Mide el tamaño resultante y el tiempo de carga/decodificación en el navegador.
  Si la decodificación o el render se vuelven lentos (no el número de MB, el
  rendimiento percibido), aplica las palancas técnicas: build de Babel previo
  (transpilar el JSX a `React.createElement` en R o con una herramienta, soltando
  el Babel-en-cliente), reducir D3 a los módulos efectivamente usados, lazy-render
  de la grilla. Reporta qué hiciste y por qué.

### A.2 — Navegación territorial (región → SLEP → comuna → establecimiento)

Replica el modelo de navegación de los hermanos (estúdialos:
`/Users/tomgc/Projects/slep_simce_adecuado` y
`/Users/tomgc/Projects/slep_categoria_desempeno`, sus motores y catálogos
`comunas_chile`/`sleps_chile`/`establecimientos_chile`):

- Navegación jerárquica por territorio: el usuario elige región, luego SLEP o
  comuna dentro de ella, luego ve los establecimientos. Cualquier SLEP del país,
  cualquier comuna.
- **Invariante intacto:** el territorio **acota qué establecimientos se listan**,
  nunca produce una cifra agregada. No hay "promedio de la comuna" ni "del SLEP".
  La grilla sigue siendo de radares por establecimiento individual, agrupada por
  GSE.
- Foco Costa Central marcado por defecto (es el SLEP del titular), pero el resto
  del país plenamente navegable.
- Usa los catálogos territoriales ya generados (recién corregidos de encoding).
  Verifica que los nombres de todas las regiones/comunas estén en UTF-8 limpio a
  escala nacional, no solo en Valparaíso.

---

## 2. Fase B — El GSE de referencia como eje interpretativo central

Esto es lo que el titular subrayó como el corazón del producto. Hoy la marca de
desvío existe pero es secundaria; elévala a protagonista.

- **Doble ancla siempre visible** para cada cifra de establecimiento: (a) su
  posición vs el GSE de referencia (`difgru` + `sigdifgru`), y (b) su variación
  vs la evaluación anterior (`dif` + `sigdif`). Ambas con el número y la
  significancia, no solo un ícono.
- **Lógica de alerta:** usa la significancia para señalar visualmente dónde un
  establecimiento está significativamente bajo su GSE (alerta) o significativamente
  sobre él (destacado), y dónde cayó/subió significativamente respecto del año
  anterior. Es el caso de uso real del titular: "saber cómo vamos, si bien o mal, y
  levantar alertas". Diséñalo para que esa lectura sea inmediata.
- Recordatorio del invariante (decisión 2026-06-12 §5): `sigdifgru ∈ {−1,0,+1}` =
  significativamente bajo / no significativo / significativamente alto (ya
  verificado contra 39.285 casos). Se **lee** `difgru`/`sigdifgru`; **no** se
  dibuja la línea de puntaje absoluto del GSE (no existe publicada; derivarla está
  prohibido). El ancla es el desvío, no el nivel del GSE.
- Hazlo legible para alguien que no conoce la escala: el texto/leyenda debe
  ayudar a interpretar (la escala 0-100 es relativa; lo que orienta es el desvío
  vs GSE y vs el año anterior).

---

## 3. Fase C — Visualizar toda la jerarquía (4 → 11 → 30)

El desafío que planteó el titular: mostrar lo más posible, navegablemente.

- **Mirada integral con spidercharts.** El IDPS mide desarrollo integral (más allá
  de lo académico): el radar/spiderchart es la visualización natural para verlo en
  conjunto. Mantén y refina los radares: 4 ejes (indicadores) y 11 ejes
  (dimensiones). Evalúa un tercer nivel de radar o vista para las 30
  subdimensiones, o una forma navegable de bajar de dimensión a sus subdimensiones.
- **Drill-down completo de la jerarquía** (cierra P8): desde un indicador, aislar
  sus dimensiones; desde una dimensión, ver sus subdimensiones. El usuario debe
  poder recorrer indicador → dimensión → subdimensión sin perder el contexto del
  establecimiento.
- **Distribución de niveles** por subdimensión (solo actor EST), con el texto
  cualitativo por ciclo ya serializado. 8b muestra distribución numérica sin texto.
- **Variaciones interanuales con eje fijo 0-100** (invariante duro del titular):
  toda vista de tendencia (líneas o barras) usa el eje 0-100 completo, nunca
  autoescalado, porque la escala es común a todo indicador/dimensión/subdimensión y
  comparable entre sí. No interpoles huecos de cobertura; deshabilita la tendencia
  donde hay un solo año.

---

## 4. Fase D — Pulido para producto y deploy a GitHub Pages

El titular priorizó **deploy cuanto antes, pulido después**. Por eso: el pulido de
esta fase es el necesario para que sea un producto digno de publicar, no
perfección exhaustiva. Lo que quede fino se itera después.

### D.1 — Pulido mínimo de producto

- **Fuentes de marca embebidas** (gobCL + Museo Sans en base64) para self-contained
  real; sin esto el deploy depende de fuentes locales.
- Estética canónica consolidada (paleta de indicadores rojo/amarillo/verde/azul,
  header azul institucional, fondo cream), formato chileno (coma decimal),
  terminología "establecimiento educacional" (nunca "EE" visible, nunca "colegio"
  genérico).
- Leyenda de "preliminar" (2025), manejo claro de supresión ("sin dato —
  resguardo estadístico"), y de huecos de cobertura.
- Sección/acceso a definiciones del corpus (qué es cada indicador/dimensión) para
  que el producto sea interpretable por sí solo. Responsive y accesibilidad
  razonables (no exhaustivos; eso se itera).

### D.2 — Deploy a GitHub Pages

Replica el patrón de publicación de los hermanos (mira cómo `slep_categoria_desempeno`
publica `docs/index.html`):

- Copia el motor final a `docs/index.html` (más cualquier asset que el patrón de
  los hermanos requiera). Verifica que el sitio sirva el HTML autocontenido.
- Configura/verifica GitHub Pages sobre `docs/` en `main`. Si el repo aún no
  tiene Pages activado, deja documentado en el reporte el paso manual exacto que
  el titular debe hacer en la config de GitHub (esa parte es del titular, no tuya:
  no toques settings del repo remoto que requieran su intervención; indícalos).
- Commit del deploy. **Mostrar `git status` y los archivos a publicar antes del
  push**; el push lo confirmas en el reporte.
- Nota: el motor base no editaba `docs/`. Aquí sí, porque es el objetivo del
  encargo.

---

## 5. Pruebas que debes correr tú y reportar

1. `run_all()` completo de cero (31→35) sin error, con tiempos; confirmación de
   que `35` ahora embebe todo Chile.
2. Tamaño del HTML final y rendimiento real: tiempo de decodificación del JSON y
   de primer render en el navegador, con todo Chile. Si aplicaste build de Babel o
   recorte de D3, el antes/después.
3. Navegación territorial: verifica que puedes llegar a un establecimiento de al
   menos 3 regiones distintas (una de ellas Costa Central, otra de otro SLEP,
   otra una comuna cualquiera), y que los nombres salen en UTF-8 limpio.
4. GSE de referencia: captura/describe cómo se ve la doble ancla (vs GSE y vs año
   anterior) y la lógica de alerta en un establecimiento con desvío significativo.
5. Jerarquía: verifica el drill-down indicador → dimensión → subdimensión en un
   establecimiento, y la distribución de niveles con texto por ciclo.
6. Tendencia con eje 0-100: confirma que ninguna vista temporal autoescala.
7. Spot-check motor↔parquet 1:1 con un establecimiento de fuera de Valparaíso
   (para validar que la ampliación nacional no rompió la homologación).
8. Deploy: el sitio en `docs/` sirve correctamente; URL de Pages (o el paso
   manual pendiente del titular si Pages no está activado).
9. Cero agregación territorial en todo el código y el JSON, a escala nacional.

---

## 6. Estructura de reporte OBLIGATORIA (al terminar)

EXACTAMENTE estas secciones, en español, conciso pero completo, para que el
titular sepa dónde quedó sin abrir el repo:

```
## Reporte de ejecución — Encargo 2 (producto completo + deploy)

### Resumen en una línea
[El producto está/no está desplegado en Pages; URL o paso pendiente; N decisiones para el titular.]

### Por ámbito (qué logré / cómo me fue)
- Todo Chile (universo):        [hecho/parcial] — [n establecimientos, tamaño HTML]
- Navegación territorial:       [hecho/parcial] — [región/SLEP/comuna/EE funciona?]
- GSE de referencia (eje central): [hecho/parcial] — [cómo quedó la doble ancla + alertas]
- Jerarquía 4→11→30:            [hecho/parcial] — [drill-down hasta dónde llega]
- Spidercharts / tendencia 0-100: [hecho/parcial]
- Distribución de niveles:      [hecho/parcial]
- Fuentes embebidas / estética: [hecho/parcial]
- Rendimiento (todo Chile):     [aceptable/problemático] — [qué hice]
- Deploy a Pages:               [hecho/pendiente paso manual] — [URL o instrucción]

### Pruebas (resultado real, no aspiracional)
- run_all() de cero:            [OK/falló] — [tiempos; confirma todo Chile]
- Tamaño/rendimiento:           [MB; tiempo decode/render]
- Navegación 3 regiones:        [sí/no] — [ejemplos con nombre]
- GSE doble ancla + alerta:     [sí/no] — [qué se ve]
- Drill-down jerarquía:         [sí/no]
- Tendencia eje 0-100:          [confirmado/no]
- Spot-check fuera de Valpo:    [coincide/no] — [RBD, región, valores]
- Deploy sirve:                 [sí/no] — [URL]
- Cero agregación:              [confirmado/no]

### Decisiones técnicas que tomé (para ratificar)
[cada una con justificación en una línea]

### Bloqueantes / decisiones de dominio que necesito del titular
[lo que no pude resolver, o pasos manuales que le tocan a él (ej. activar Pages en settings). Si no hay, dilo.]

### Qué queda para iterar (post-deploy)
[el pulido fino diferido: a11y exhaustiva, microinteracciones, vistas adicionales, etc.]

### Commits de esta sesión
[hash + título, en orden]
```

---

## 7. Invariantes (recordatorio — violarlos arruina el trabajo)

- Cero agregación territorial, también a escala nacional. El territorio (región /
  SLEP / comuna) **navega y acota** qué establecimientos se listan; nunca produce
  una cifra agregada. La grilla es de radares por establecimiento individual,
  agrupada por GSE.
- Lee, no derives: `prom`, `niv_*_por`, `dif/sigdif/difgru/sigdifgru`. No
  reconstruyas la línea absoluta del GSE.
- GSE de referencia = eje interpretativo central (desvío + significancia), no
  marca secundaria.
- Tendencias siempre con eje fijo 0-100, nunca autoescalado.
- Supresión = NA, nunca cero. Niveles solo actor EST; 8b sin texto de nivel.
- No mezclar indicadores, dimensiones, grados ni años en una cifra.
- Andamios congelados: se replican, no se editan.
- "Establecimiento educacional" siempre; formato chileno; UTF-8.
- Gobernanza zanjada: datos públicos, todo Chile nominal confirmado. Deploy
  directo, sin verificación.

Avanza de corrido A→B→C→D hasta el deploy. Si paras, deja un punto de corte
verificable y dilo en el reporte. Al terminar, entrega el reporte de la sección 6.
El cierre de sesión con traspaso v05 lo decide el titular después de revisar el
producto desplegado.
