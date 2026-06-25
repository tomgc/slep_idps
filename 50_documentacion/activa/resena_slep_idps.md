# Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS)

> Versión elegida — Tipo 1 (Snippet): [PENDIENTE: a definir por editor]
> Versión elegida — Tipo 2 (Síntesis): [PENDIENTE: a definir por editor]
> Versión elegida — Tipo 3 (Reseña extensa): [PENDIENTE: a definir por editor]

---

## Tipo 1 — Snippet

**Variante A · ángulo problema**
Los Indicadores de Desarrollo Personal y Social miden la dimensión no académica de la educación —convivencia, autoestima, participación, hábitos—, pero rara vez se exploran de forma comparativa. Desarrollamos esta herramienta interactiva para reunir sus resultados y contrastar establecimientos a lo largo del tiempo, siempre segmentados por grupo socioeconómico.

**Variante B · ángulo producto**
Construimos una herramienta interactiva que compara los resultados de los Indicadores de Desarrollo Personal y Social (IDPS) entre establecimientos y a lo largo del tiempo, segmentados por grupo socioeconómico, sobre la base de los datos públicos por establecimiento de la Agencia de Calidad de la Educación.

**Variante C · ángulo aporte institucional**
Ofrecemos una vista única y navegable de los Indicadores de Desarrollo Personal y Social en el SLEP Costa Central: integramos más de una década de resultados publicados por la Agencia de Calidad de la Educación y los ordenamos por establecimiento y grupo socioeconómico para apoyar la lectura territorial.

**Recomendación: Variante B** (capta el proyecto de un vistazo, nombra la fuente y el segmentador clave —el grupo socioeconómico— y abre con la autoría del equipo sin sacrificar concisión).

---

## Tipo 2 — Síntesis

**Variante A · enfoque en el problema**
Los Indicadores de Desarrollo Personal y Social (IDPS) que la Agencia de Calidad de la Educación mide junto al Simce capturan aspectos no académicos de la experiencia escolar —autoestima académica y motivación, clima de convivencia, participación y formación ciudadana, y hábitos de vida saludable—, pero suelen consultarse establecimiento por establecimiento y año por año, sin una mirada de conjunto. Para resolver esa fragmentación, en el Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos del SLEP Costa Central desarrollamos un motor de comparación interactivo.

El producto es una aplicación autocontenida que despliega, para cada establecimiento y grado, los resultados de los cuatro indicadores y su desglose, ordenados y filtrables por territorio y por grupo socioeconómico. Apoyamos la comparación en los contrastes que la propia Agencia ya calcula —respecto del mismo grupo socioeconómico y respecto de la evaluación anterior—, de modo que la herramienta presenta lecturas trazables a la fuente, sin que construyamos cifras agregadas propias.

**Variante B · enfoque en el producto y el aporte**
Desarrollamos un motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS) a partir de los datos públicos por establecimiento de la Agencia de Calidad de la Educación. La herramienta permite navegar desde la región hacia el territorio y el establecimiento, comparar panoramas individuales lado a lado y seguir la serie histórica de cada indicador, manteniendo la segmentación por grupo socioeconómico en todo momento.

Con ello ponemos a disposición del Servicio una lectura ordenada y comparable de la dimensión no académica de la educación, habitualmente dispersa en múltiples planillas anuales. El diseño preserva la fidelidad a la fuente: mostramos cada resultado al nivel en que la Agencia lo publica —el establecimiento— y reutilizamos las comparaciones oficiales en lugar de derivar valores propios.

**Recomendación: Variante B** (cubre objetivo, contexto institucional y, en pocas líneas, estructura y aporte; la A es más extensa en el encuadre del problema y deja el producto para el segundo párrafo).

---

## Tipo 3 — Reseña extensa

**Variante A · recorrido producto → fuentes → flujo**

En el Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos del SLEP Costa Central desarrollamos el Motor de comparación interactivo de los resultados en los Indicadores de Desarrollo Personal y Social (IDPS), una herramienta orientada al territorio que reúne las comunas de Viña del Mar, Concón, Quintero y Puchuncaví. Buscamos ofrecer una vista única, navegable y comparable de la dimensión no académica de la educación, que la Agencia de Calidad de la Educación mide junto al Simce.

Los IDPS son índices en escala de 0 a 100 que se informan por establecimiento. El motor organiza los cuatro indicadores de cuestionario —Autoestima Académica y Motivación Escolar, Clima de Convivencia Escolar, Participación y Formación Ciudadana, y Hábitos de Vida Saludable— junto con su desglose en dimensiones y subdimensiones, y permite recorrerlos desde una mirada general hacia el detalle de cada establecimiento y grado.

La estructura de uso parte de una navegación territorial —de la región al Servicio o la comuna, y de ahí al establecimiento— y mantiene el grupo socioeconómico como referencia permanente: cada establecimiento se presenta etiquetado por su grupo y comparado contra él. La comparación adopta dos formas trazables a la fuente, ambas provistas por la Agencia: el contraste de cada establecimiento respecto de su mismo grupo socioeconómico y respecto de su evaluación anterior. A ello sumamos la lectura de la serie histórica de cada indicador a lo largo de más de una década.

Como fuente de información utilizamos los resultados públicos de los IDPS que publica la Agencia de Calidad de la Educación, agregados a nivel de establecimiento y no de estudiante. Incorporamos tres familias de resultados —el indicador, sus dimensiones y la distribución por niveles— y las complementamos con un directorio oficial de establecimientos, del que obtenemos los atributos territoriales y la clasificación por grupo socioeconómico. Antes de su uso, depuramos ese directorio de cualquier identificador personal, de modo que el material de trabajo queda restringido a información pública.

El flujo de procesamiento, a nivel conceptual, homologa los resultados de los distintos años a un esquema común, integra las tres familias de archivos y normaliza la información al nivel de establecimiento y grado, sin que construyamos ninguna cifra territorial agregada. Es una definición de diseño deliberada: como las fuentes IDPS no informan el número de personas que responden cada cuestionario, no existe un ponderador válido para promediar establecimientos, y cualquier consolidado de comuna, Servicio o región mezclaría universos distintos. Publicamos el resultado como una aplicación web autocontenida, de manera que la consulta es directa y no requiere infraestructura adicional.

**Variante B · recorrido aporte institucional → gobernanza → flujo**

Este proyecto responde a una necesidad concreta del SLEP Costa Central: disponer de una lectura ordenada de los Indicadores de Desarrollo Personal y Social (IDPS), que capturan aspectos de la experiencia escolar —convivencia, autoestima académica y motivación, participación ciudadana y hábitos de vida saludable— habitualmente menos visibles que los resultados académicos y dispersos en numerosas planillas anuales. Desde el Área de Monitoreo y Seguimiento de Procesos y Resultados Educativos construimos un motor de comparación interactivo que consolida esa información en una sola herramienta, al servicio del conjunto del Servicio y de los establecimientos educacionales del territorio.

El aporte es doble. Por una parte, integramos en un mismo lugar una serie larga de resultados y la hacemos comparable entre establecimientos y en el tiempo, segmentada de forma permanente por grupo socioeconómico. Por otra, lo hacemos preservando la fidelidad a la fuente: presentamos cada resultado al nivel en que la Agencia de Calidad de la Educación lo publica —el establecimiento— y reutilizamos las comparaciones que esa institución ya calcula, en lugar de derivar valores propios que no podríamos sustentar ante terceros.

Cuidamos la gobernanza del dato como parte del diseño. Trabajamos exclusivamente con agregados públicos por establecimiento; verificamos que el material no contiene bases desagregadas por estudiante y establecimos como invariante que, de incorporarse alguna vez información a nivel de alumno, el tratamiento de los datos cambiaría por completo. El único identificador nominal que aparece —el nombre del establecimiento— es información pública.

En cuanto a las fuentes y su procesamiento conceptual, el motor se nutre de los resultados IDPS de la Agencia de Calidad de la Educación —en sus distintas familias: indicador, dimensiones y distribución por niveles— y de un directorio oficial de establecimientos del que tomamos la geografía y el grupo socioeconómico, previamente depurado de identificadores personales. El procesamiento homologa los esquemas de los distintos años, une esas fuentes y normaliza la información por establecimiento y grado.

Por definición de diseño, el flujo no produce ningún consolidado territorial: al no publicarse el número de respondentes de cada cuestionario, no contamos con un ponderador que permita promediar establecimientos sin mezclar universos distintos. Resolvemos la comparación, en cambio, poniendo lado a lado los panoramas individuales y mostrando el desvío oficial de cada establecimiento respecto de su grupo socioeconómico. El producto final es una aplicación web autocontenida, de consulta directa, que ordena la navegación desde el territorio hacia el establecimiento y permite seguir la evolución histórica de cada indicador.

**Recomendación: Variante B** (además de objetivo, estructura, fuentes y flujo, explicita la gobernanza del dato —un atributo distintivo y bien documentado de este proyecto— sin exponer rutas ni nombres; la A es sólida pero más centrada en el recorrido de uso que en el aporte institucional).
