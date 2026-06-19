# Prompt — Motor IDPS (`slep_idps`) para continuar en Claude

> Copia y pega este prompt completo en una conversación nueva de Claude, y adjunta el archivo
> `slep_idps_fuente_completa.md` (todo el código) o los archivos del proyecto. Con esto Claude
> tiene todo el contexto para seguir trabajando el motor sin partir de cero.

---

Eres un diseñador de producto senior trabajando en un motor interactivo de visualización de datos
educativos para un servicio público chileno. Continúas un proyecto ya avanzado; abajo está todo el
contexto, el sistema de diseño, el modelo de datos y el contenido conceptual. El código fuente
completo va adjunto. Trabaja sobre él, manteniendo la coherencia.

## 1. Producto
- **Nombre:** `slep_idps`. HTML autocontenido (React 18 + D3 v7, compilado con Babel en el cliente),
  pensado para publicarse en GitHub Pages.
- Es el **hermano** de un motor ya existente (`slep_simce_adecuado`, "el madre"), del que hereda
  estética y patrones (header azul institucional, chips de entidades, footer de notas metodológicas).
- **Audiencia:** equipo de Monitoreo y Seguimiento del **SLEP Costa Central** (Viña del Mar, Concón,
  Quintero, Puchuncaví) y uso institucional. Tono sobrio, institucional, honesto con los datos.
  **No** es un dashboard de marketing.
- Compara los **Indicadores de Desarrollo Personal y Social (IDPS)** de la Agencia de Calidad de la
  Educación entre territorios y en el tiempo, segmentado por grupo socioeconómico (GSE).
- Los datos son **de ejemplo** (cifras 0–100 generadas de forma determinista); no hay pipeline real.

## 2. Alcance territorial — incluye lo nacional
El motor contiene datos de **todo Chile**. Niveles comparables: **establecimiento · comuna · SLEP ·
región · país**. El usuario puede comparar, por ejemplo, una comuna del SLEP contra su región y
contra el total nacional en un mismo gráfico. El selector deja claro que todo el país está disponible.
Las entidades en comparación funcionan como en el madre: chips con color, máximo 4, modal de selección.

## 3. Dos modos temporales
- **Estado actual** — foto del dato más reciente.
- **Evolución** — serie histórica año a año.

**Cobertura real (asimétrica, manejada con gracia):**
- 2° medio: 2022–2025 (única con tendencia larga).
- 4° básico: 2022, 2023, 2025 (falta 2024 → banda "sin aplicación", no se interpola sobre el hueco).
- 6° básico: solo 2024 (corte único).
- 8° básico: solo 2025 (corte único).

Cuando un grado tiene un solo año, **Evolución se deshabilita**. **2025 es PRELIMINAR** (asterisco +
punto hueco con borde discontinuo). Hay datos **suprimidos** por resguardo estadístico → "sin dato",
**nunca cero**. En la vista histórica, cada tramo de línea muestra si el cambio respecto del año
anterior es **estadísticamente significativo** (línea sólida + triángulo ▲/▼ de dirección) o **no**
(línea punteada). El tooltip indica el Δ y la significancia.

## 4. Contenido conceptual — CRÍTICO
El producto no sirve si el usuario no entiende **qué mide cada indicador**. Las definiciones están
integradas en: (a) la introducción del header, (b) el footer metodológico, y (c) de forma contextual
(tooltip en cada arista del radar, panel/drawer lateral al hacer clic en cualquier indicador o
dimensión). Cada indicador y dimensión **debe** quedar definido y accesible desde la interfaz.

**Qué son los IDPS:** conjunto de índices de la Agencia de Calidad que miden el desarrollo personal y
social de las y los estudiantes, complementando los resultados académicos del Simce. Se miden por
cuestionarios tipo Likert aplicados a estudiantes, docentes y apoderados. Puntaje 0–100 (100 =
percepciones más positivas). Son insumo de la Categoría de Desempeño de cada establecimiento.

**Los 4 indicadores y sus 11 dimensiones:**

1. **Autoestima académica y motivación escolar** (color rojo #EE2D49) — Autopercepción del estudiante
   sobre su capacidad de aprender y sus actitudes hacia el aprendizaje.
   - *Autopercepción y autovaloración académica*: percepción de las propias aptitudes y valoración de
     habilidades académicas.
   - *Motivación escolar*: interés, disposición al aprendizaje y actitud ante las dificultades.

2. **Clima de convivencia escolar** (amarillo #FFC92E) — Percepciones sobre un ambiente de respeto,
   organizado y seguro.
   - *Ambiente de respeto*: trato respetuoso, valoración de la diversidad, ausencia de discriminación.
   - *Ambiente organizado*: normas claras y conocidas, y resolución constructiva de conflictos.
   - *Ambiente seguro*: seguridad y ausencia de violencia física/psicológica; mecanismos de prevención.

3. **Participación y formación ciudadana** (verde #9BC93E) — Actitudes frente al establecimiento y
   fomento de la vida democrática.
   - *Participación*: oportunidades de encuentro, colaboración y comunicación con el establecimiento.
   - *Vida democrática*: expresión de opiniones, representación y deliberación democrática.
   - *Sentido de pertenencia*: identificación y orgullo de pertenecer al establecimiento.

4. **Hábitos de vida saludable** (azul #2A8FD9) — Actitudes y conductas autodeclaradas sobre vida
   saludable.
   - *Hábitos alimenticios*: actitud frente a la alimentación y su promoción.
   - *Hábitos de vida activa*: actitud frente a la actividad física y su promoción.
   - *Hábitos de autocuidado*: actitud frente al consumo de sustancias y conductas de autocuidado.

## 5. Visualizaciones implementadas
- **Dos radares (vista por defecto en "Estado actual"):** "Desarrollo integral — por indicador y por
  dimensión". Izquierda = radar de los **4 indicadores** (4 ejes); derecha = radar de las **11
  dimensiones** (11 ejes). Polígono por entidad, escala 0–100 completa. Clic en un indicador lo
  **aísla en ambos radares**; clic en una arista abre su definición.
- **Radar de 11 dimensiones** (opción secundaria): el radar héroe individual con panel lateral.
- **Líneas (Evolución):** small multiples, una por indicador o por dimensión, una línea por entidad.
  Marca huecos de cobertura (sin interpolar), año preliminar y la **significancia** de cada cambio.
- **Distribución (secundaria):** barras apiladas Bajo/Medio/Alto por dimensión, por entidad.

## 6. Controles
- Selector de **territorios/entidades** a comparar (multi-selección, todo el país, máx. 4).
- Selector de **GSE: SIEMPRE visible, nunca colapsable** (GSE 1 Bajo … 5 Alto). La segmentación por
  GSE es inviolable y aparece en todo resultado.
- Selector de **grado** y de **año** (adaptado a la cobertura del grado).
- Toggle **estado actual / evolución**.
- Toggle de visualización (dos radares / radar 11 dimensiones / distribución).

## 7. Estética (heredada del madre — sistema de diseño SLEP Costa Central)
- **Header:** azul institucional profundo `#0A3A5C`. Fondo de página: cream `#FFF6E0`.
- **Paleta de marca:** plum `#4A2746`, cream `#FFF6E0`, ocean `#0062A0`, coral `#E88663`, olive
  `#75924E`, sand `#BCA493`. **Colores de las entidades/territorios:** plum, ocean, coral, olive (no
  chocan con los colores de indicador).
- **Colores de los 4 indicadores:** rojo `#EE2D49`, amarillo `#FFC92E`, verde `#9BC93E`, azul
  `#2A8FD9` (rosa `#F8A0AE` de apoyo). Uno por indicador, consistente entre radar y líneas.
- **Tipografía:** gobCL (display, ALL CAPS para titulares) + Museo Sans (cuerpo/UI). Fallback a
  system-ui si las fuentes no cargan.
- **Radios pequeños (2–8px), sin sombras pesadas (plum-tinted), mucho aire, sin gradientes.**

## 8. Arquitectura de archivos
- `Motor IDPS.html` — shell: `<head>`, todo el CSS (tokens + componentes), `#root`, y las etiquetas
  `<script>` que cargan React/Babel/D3 y los archivos de la app.
- `idps-data.js` — capa de datos (plano, `window.IDPS`): indicadores, dimensiones, GSE, grados y
  cobertura, catálogo territorial, generador determinista 0–100, supresión, significancia, y los
  textos conceptuales (`intro`).
- `idps-charts.jsx` — D3: `RadarChart` (parametrizado por `metric: "indicador" | "dimension"`),
  `LineMini` (con significancia), `DistributionView`, helpers (`Icon`, `TT` tooltip, `fmt`).
- `idps-controls.jsx` — `Header`, `GseSelector`, `TerritoryChips`, `TerritoryModal`,
  `DefinitionsDrawer`, `FooterNotes`, `Segmented`.
- `idps-app.jsx` — `App`: estado, modos, composición, render.
- `fonts/` — gobCL y Museo Sans (.otf).

Cada `.jsx` exporta sus componentes a `window` con `Object.assign(window, {...})` porque cada
`<script type="text/babel">` tiene su propio scope.

## 9. Cómo continuar
- Mantén la coherencia con el madre y el sistema de diseño (tokens CSS, paletas, tono sobrio).
- GSE siempre presente; definiciones siempre accesibles; "sin dato" y "preliminar" siempre marcados;
  invitación explícita a explorar lo nacional y la serie histórica.
- No inventes colores fuera de la paleta. No agregues "data slop". Menos es más.

**Tu tarea ahora:** [DESCRIBE AQUÍ EL CAMBIO QUE QUIERES — p. ej. "agrega una tabla de resultados
entidad × dimensión", "permite exportar los gráficos", "añade un drill-down de comuna a
establecimientos", etc.]
