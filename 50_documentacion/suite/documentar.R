# ============================================================================
#  documentar.R — genera la suite de documentación de "slep_idps"
#  Edita el bloque cfg con la realidad del proyecto y ejecuta:
#      source("documentar.R")
#  Vuelve a correrlo cada vez que cambie algo: los 4 HTML quedan al día.
#
#  Esta cfg está calzada a la forma de suitedoc::cfg_ejemplo() (0.3.0). Todos
#  los bloques obligatorios están sobrescritos con la realidad de slep_idps
#  (motor IDPS, SIN agregación territorial). Las zonas de prosa de comunidad
#  marcadas `# REVISAR (voz)` son redacción propia: afinar el tono, no el dato.
# ============================================================================
#  CONSTANCIA DE GOBERNANZA. Proyecto con datos: PÚBLICOS (agregados por
#  establecimiento, Agencia de Calidad; Rama A).
#  Revisión hecha por: Tomás G. Casanova   Fecha: 2026-06-22
#  Verifiqué que la cfg NO contiene: RUT, nombres de personas, ni datos
#  individuales identificables. El nombre de establecimiento (nom_rbd) es
#  información pública del directorio oficial; los universos se describen en
#  abstracto. El directorio crudo con RUT/MRUN no se versiona (lo depura 31).
# ============================================================================

library(suitedoc)
library(here)

# Salida anclada a la ubicación canónica de la suite (no depende del working
# directory de R: source() no hace cd al directorio del script). Evita que los
# HTML caigan en la raíz del proyecto.
DESTINO_SUITE <- here::here("50_documentacion", "suite")

cfg <- cfg_ejemplo()        # forma de referencia; TODO el contenido se sobrescribe abajo

# ---- 1.1 Identidad ---------------------------------------------------------
cfg$slug        <- "slep_idps"
cfg$institucion <- "SLEP Costa Central"
cfg$area        <- "Área de Monitoreo y Seguimiento"
cfg$fuente      <- "Datos públicos de la Agencia de Calidad de la Educación (Cuestionarios de Calidad y Contexto)"
cfg$salida_dir  <- DESTINO_SUITE
cfg$css_href    <- "suite_estilos.css"
cfg$logo_href   <- "assets/logo-white-stacked.png"
cfg$gobernanza  <- "Datos públicos de la Agencia de Calidad"

# ---- Comunas (franja de cierre de los documentos generales) ----------------
cfg$comunas <- list(
  list(nombre = "Concón",       bg = "var(--mk-red)"),
  list(nombre = "Puchuncaví",   bg = "var(--mk-yellow)", fg = "var(--ink)"),
  list(nombre = "Quintero",     bg = "var(--mk-green)"),
  list(nombre = "Viña del Mar", bg = "var(--mk-blue)")
)

# ---- 1.2 Cabeceras por documento -------------------------------------------
cfg$cab <- list(
  arq_tec = list(
    eyebrow = "Esquema de arquitectura · Versión técnica",
    h1      = "Arquitectura del proyecto",
    mono    = "slep_idps",
    tagline = "Motor de exploración de los Indicadores de Desarrollo Personal y Social (IDPS) por establecimiento, sin agregación territorial. Pipeline R (Positron) &rarr; HTML autocontenido (React 18 + D3 v7) · datos públicos de la Agencia de Calidad · publicado en GitHub Pages.",
    metas   = list(
      list(c="var(--ocean)", k="Lenguaje", v="R"),
      list(c="var(--coral)", k="Salida",   v="HTML autocontenido"),
      list(c="var(--olive)", k="Cobertura",v="2014–2025"),
      list(c="var(--sand)",  k="Niveles",  v="4° básico · II medio")
    )
  ),
  doc_tec = list(
    eyebrow = "Documentación del proyecto · Versión técnica completa",
    h1      = "Manual del proyecto",
    mono    = "slep_idps",
    tagline = "Presentación de punta a punta: qué mide, qué conceptos usa, cómo se construye y qué decisiones metodológicas lo gobiernan. La regla rectora del proyecto es leer la cifra oficial, no derivarla.",
    metas   = list(
      list(c="var(--ocean)", k="Área",   v="Monitoreo y Seguimiento"),
      list(c="var(--olive)", k="Datos",  v="Agencia de Calidad (públicos)"),
      list(c="var(--coral)", k="Salida", v="motor_idps.html")
    )
  ),
  arq_gen = list(
    eyebrow = "Esquema de arquitectura · Visión general",
    h1      = "Cómo se construye la herramienta",
    mono    = NULL,
    tagline = "De las planillas de la Agencia a un tablero que se abre en el navegador, explicado como una línea de producción. Sin tecnicismos: qué entra, qué pasa en cada paso y qué sale.",
    metas   = list(
      list(c="var(--coral)", k="Para",           v="directivos, equipos y comunidad"),
      list(c="var(--olive)", k="Versión técnica",v="arquitectura_slep_idps.html")
    )
  ),
  doc_gen = list(
    eyebrow = "Documentación del proyecto · Guía general",
    h1      = "Qué es la herramienta y cómo leerla",
    mono    = NULL,
    tagline = "Una guía breve y sin tecnicismos para entender qué muestra el motor IDPS, qué se puede ver en él y en qué conviene fijarse al interpretarlo.",
    metas   = list(
      list(c="var(--coral)", k="Para",           v="directivos, docentes, apoderados y comunidad"),
      list(c="var(--olive)", k="Detalle técnico", v="documentacion_proyecto_slep_idps.html")
    )
  )
)

# ---- 1.3 Diagrama técnico: insumos, auxiliares, etapas ----------------------
cfg$insumos <- list(
  list(t='Tablas IDPS de la Agencia', badge='xlsx',
       d='3 familias (rbd · rbd_dim · niveles) × 4 grados (4b/2m/6b/8b) · 2014–2025<br><span class="code-sm">idps{grado}{anio}_*.xlsx</span><br>Agregadas por establecimiento (RBD); 2025 preliminar'),
  list(t='Directorio oficial de establecimientos', badge='csv',
       d='Mineduc · geo, dependencia y nombre por RBD<br><span class="code-sm">directorio_oficial_ee.csv</span> (crudo, con RUT/MRUN, NO versionado)<br>31 produce la versión pública sin columnas personales'),
  list(t='Corpus conceptual IDPS', badge='json',
       d='Jerarquía indicador · dimensión · subdimensión · actor (4 &rarr; 11 &rarr; 30)<br><span class="code-sm">idps_corpus_conceptual.json</span><br>Fuente única de definiciones y niveles de desarrollo')
)
cfg$auxiliares <- list(
  list(t='listado_slep_2026.xlsx', badge='xlsx',
       d='Catálogo de Servicios Locales y sus comunas<br>Insumo de los catálogos territoriales (solo filtro)'),
  list(t='glosas IDPS', badge='xlsx',
       d='Diccionarios de códigos de indicador/dimensión/subdimensión<br>Homologación de esquema texto &rarr; id numérico')
)
cfg$aux_uses <- c(
  '↘ <code>33_construir_catalogos.R</code> catálogos territoriales (solo filtro)',
  '↘ <code>33_construir_catalogos.R</code> catálogo jerárquico IDPS (4 niveles)',
  '↘ <code>directorio_oficial_ee_publico.csv</code> geo y dependencia vigente por RBD'
)

# Etapas del pipeline (31 -> 35). flags = invariantes metodológicos.
cfg$etapas <- list(
  list(n=1, titulo='Depuración del directorio oficial', sub='30_procesamiento/',
       head='<span class="code">31_depurar_directorio_oficial.R</span> <span class="bg bg--r">R</span>',
       d='Lee el directorio oficial crudo (Mineduc)<br>Elimina columnas personales (<span class="code-sm">RUT_SOSTENEDOR</span>, <span class="code-sm">MRUN</span>) en origen<br>Conserva <span class="code-sm">nom_rbd</span> solo como llave de join interno<br>Escribe <strong>directorio_oficial_ee_publico.csv</strong> (este sí se versiona)',
       flags=c('Datos personales fuera antes de versionar','nom_rbd jamás a output sensible'), norm=list()),
  list(n=2, titulo='Censo de insumos', sub='30_procesamiento/',
       head='<span class="code">32_censo_insumos.R</span> <span class="bg bg--r">R</span>',
       d='Perfila las 3 familias × grado × año (cobertura, % NA en la medida)<br>Valida la metadata del nombre de archivo contra el contenido real<br>Reporta presencia de <span class="code-sm">cod_grupo</span> / <span class="code-sm">cod_depe2</span><br>Escribe <strong>censo_insumos.parquet</strong> + <strong>.md</strong>',
       flags=c('Tipos leídos del dato, no de las glosas'), norm=list()),
  list(n=3, titulo='Construcción de catálogos', sub='30_procesamiento/',
       head='<span class="code">33_construir_catalogos.R</span> <span class="bg bg--r">R</span>',
       d='(A) Catálogos territoriales desde el directorio público: comuna · SLEP · región · establecimiento (solo como <strong>filtro</strong>)<br>(B) Catálogo jerárquico IDPS de 4 niveles desde el corpus, con ids numéricos por match de nombre<br>Marca qué subdimensiones tienen niveles (solo actor EST)<br>Escribe <strong>catalogo_idps.parquet</strong> + catálogos territoriales',
       flags=c('Territorio es filtro, nunca agregación','IDs como character'), norm=list()),
  list(n=4, titulo='Lectura y normalización IDPS', sub='30_procesamiento/',
       head='<span class="code">34_leer_normalizar_idps.R</span> <span class="bg bg--r">R</span>',
       d='Lee las 3 familias · homologa el esquema que migra de texto (2022–2024) a id numérico (2025)<br>Trae GSE y dependencia a la familia <span class="code-sm">niveles</span> vía join <span class="code-sm">rbd × agno × grado</span><br>Funde el régimen histórico (2014–2019, ancho) con el moderno (2022–2025, largo)<br>Escritura atómica &rarr; <strong>idps_largo.parquet</strong> (2.362.447 filas, por establecimiento-grado)',
       flags=c('SIN agregación territorial','Llaves character','NA = resguardo, nunca cero','grado/agno desde el nombre de archivo'),
       norm=list(
         list(id='E1', tx='<strong>Esquema por año:</strong> indicador/dimensión/subdimensión migran de código de texto (<span class="code-sm">ind/dim/sdim</span>, 2022–2024) a id numérico (2025). Homologado al id vía crosswalk de <span class="code-sm">10_configuracion.R</span>.'),
         list(id='E2', tx='<strong>Régimen histórico:</strong> 2014–2019 vienen en formato ancho por RBD; se pivotan a largo y se funden con el moderno. Sin subdimensión/niveles/significancia histórica (NA legítimo).'),
         list(id='E3', tx='<strong>Hueco pandemia:</strong> 2020–2021 sin evaluación del sistema. El eje histórico es contiguo; el motivo del vacío se resuelve en R, no en el template.'),
         list(id='E4', tx='<strong>grado inconsistente:</strong> la columna del dato trae "2" (2022–2023) vs "2m" (2024–2025); grado y año se toman del nombre de archivo, no de la columna.')
       )),
  list(n=5, titulo='Generación del motor', sub='30_procesamiento/',
       head='<span class="code">35_generar_motor_html.R</span> <span class="bg bg--r">R</span> + <span class="code">35_motor_template.html</span> <span class="bg bg--html">HTML</span>',
       d='Serializa <span class="code-sm">idps_largo</span> + catálogos a JSON columnar ordenado por RBD (cliente arma índice de rangos)<br>Embebe el JSON (gzip+base64, pako) y las fuentes gobCL/Museo Sans (base64) en el template<br>Navegación región &rarr; SLEP/comuna &rarr; establecimiento; GSE de referencia con doble ancla; serie histórica eje contiguo 2014→2025<br>Escribe HTML autocontenido &rarr; <strong>motor_idps.html</strong> (= <span class="code-sm">docs/index.html</span>)',
       flags=c('Lee, no deriva','GSE filtro/etiqueta, no cifra agregada','Paleta de indicador = folleto Agencia'),
       norm=list())
)

cfg$intermedios <- list(
  list(t='idps_largo.parquet',  d='Una fila por RBD × grado × año<br>× familia (indicador/dim/niveles)<br>medidas prom · dif · difgru · niveles'),
  list(t='catalogo_idps.parquet', d='Jerarquía 4 &rarr; 11 &rarr; 30<br>ids numéricos + flags de niveles<br>solo actor EST tiene niveles'),
  list(t='Catálogos territoriales', d='comunas · sleps · establecimientos_chile<br>solo como filtro de navegación<br>IDs como character')
)

# ---- 1.4 Diccionario de datos ----------------------------------------------
cfg$dic_crudos <- list(
  list(campo='rbd', tipo='character', d='Rol Base de Datos: identificador único del establecimiento. Llave primaria.'),
  list(campo='grado', tipo='character', d='<b>4b</b> / <b>2m</b> / <b>6b</b> / <b>8b</b>. Tomado del nombre de archivo (la columna del dato es inconsistente). El motor expone 4b y 2m.'),
  list(campo='agno', tipo='integer', d='Año de evaluación. Sin datos 2020–2021 (pandemia); 2019 no evaluado en 4b/2m; 2025 preliminar.'),
  list(campo='familia', tipo='character', d='<b>indicador</b> / <b>dimension</b> / <b>niveles</b>. Medidas independientes; no se combinan.'),
  list(campo='id_indicador / id_dimension / id_subdimension', tipo='character', d='Identificadores jerárquicos. Migran de texto (2022–2024) a id numérico (2025); homologados al id.'),
  list(campo='cod_grupo', tipo='character', d='Grupo socioeconómico (GSE). Atributo y segmentador; <b>nunca</b> cifra agregada.'),
  list(campo='cod_depe2', tipo='character', d='Dependencia en 4 categorías (1 Municipal, 2 Part. subv., 3 Part. pagado, 4 SLEP). El directorio usa otro esquema de 5.'),
  list(campo='prom', tipo='numeric', d='Puntaje 0–100 del establecimiento. La medida central. Se LEE, no se recalcula.'),
  list(campo='dif / sigdif', tipo='numeric/character', d='Desvío vs evaluación anterior y su significancia, calculados por la Agencia.'),
  list(campo='difgru / sigdifgru', tipo='numeric/character', d='Desvío vs el mismo GSE y su significancia, calculados por la Agencia.'),
  list(campo='niv_bajo_por / niv_medio_por / niv_alto_por', tipo='numeric', d='Distribución de niveles de desarrollo (%). Solo subdimensiones de actor EST.')
)
cfg$dic_intermedios <- list(
  list(campo='idps_largo.parquet', tipo='parquet', d='Tabla larga por establecimiento × grado × año × familia × id, con prom/dif/difgru/niveles, GSE y dependencia. 2.362.447 filas; md5 4c764d8c…'),
  list(campo='catalogo_idps.parquet', tipo='parquet', d='Catálogo jerárquico 4&rarr;11&rarr;30 con ids, definiciones y flag de niveles por subdimensión.'),
  list(campo='comunas_chile.parquet', tipo='parquet', d='Catálogo de comunas con código, nombre, SLEP y región (filtro).'),
  list(campo='sleps_chile.parquet', tipo='parquet', d='Catálogo de Servicios Locales con sus comunas (filtro).'),
  list(campo='establecimientos_chile.parquet', tipo='parquet', d='Catálogo de RBD con dependencia, geo y atributos (filtro y etiquetas).')
)

# ---- 1.5 Decisiones metodológicas ------------------------------------------
cfg$decisiones <- list(
  list(id='D1', titulo='Sin agregación territorial (leer, no derivar)',
       cuerpo='<p>El motor <strong>no</strong> construye ningún consolidado a comuna, SLEP, región o país. Muestra el dato al nivel en que la Agencia lo publica: el <strong>establecimiento</strong>. Territorio y GSE son filtros y etiquetas, nunca una cifra agregada.</p>',
       por_que='<strong>Por qué.</strong> Ninguna familia IDPS publica el número de respondentes ni la matrícula del grado evaluado. Sin ponderador válido, cualquier agregación mezclaría universos distintos y daría una cifra indefendible ante la Agencia. La inmutabilidad de la fuente prevalece sobre la conveniencia de tener una línea territorial.'),
  list(id='D2', titulo='Comparar = poner radares lado a lado + leer el desvío oficial',
       cuerpo='<p>Comparar significa dos cosas, ninguna de las cuales construye un agregado propio: (a) poner los panoramas (radares) de varios establecimientos <strong>lado a lado</strong> dentro de la grilla por GSE; y (b) mostrar el desvío de cada establecimiento respecto de su GSE usando <span class="inl">difgru/sigdifgru</span>, que la Agencia ya calculó.</p>',
       por_que='<strong>Por qué.</strong> El nivel absoluto del GSE la Agencia no lo publica; derivarlo (<code class="inl">prom − difgru</code>) reconstruiría el consolidado prohibido y sería inexacto por redondeo. Se usa el desvío oficial como marca (sobre / bajo / igual a su GSE), no como una línea de puntaje.'),
  list(id='D3', titulo='GSE inviolable, como segmentador',
       cuerpo='<p>Ningún resultado se muestra sin su GSE. En IDPS el GSE es <strong>atributo</strong> visible de cada establecimiento, <strong>segmentador</strong> que define qué establecimientos entran a la grilla, y el <strong>referente</strong> que la Agencia usó para <span class="inl">difgru/sigdifgru</span>.</p>',
       por_que='<strong>Por qué.</strong> A diferencia de las pruebas estandarizadas de aprendizaje, en IDPS el GSE no es dimensión de agregación (no se promedia por grupo). Es legítimo como filtro y etiqueta; ilegítimo como cifra: "el promedio del GSE 3 en el SLEP" es justo el consolidado que D1 prohíbe.'),
  list(id='D4', titulo='Dependencia vigente del directorio, en toda la serie',
       cuerpo='<p>Cada establecimiento se etiqueta con su dependencia <strong>vigente</strong> según el directorio oficial homologado, no con la del año del dato IDPS. Un establecimiento traspasado a SLEP figura como SLEP también en años previos al traspaso.</p>',
       por_que='<strong>Por qué.</strong> El motor es herramienta de datos IDPS, no de gobernanza; para directivos (lectura presente) la dependencia vigente es la lectura natural. Reconstruir la era-IDPS es parcial (323 de 515 RBD sin fuente histórica) y exigiría tocar el generador y re-verificar fidelidad, costo desproporcionado para una etiqueta que no altera cifras. Ninguna cifra IDPS cambia: la dependencia es etiqueta y filtro, no insumo de cálculo.'),
  list(id='D5', titulo='Naturaleza pública de los insumos (Rama A)',
       cuerpo='<p>Los archivos IDPS son agregados públicos por establecimiento, no bases por estudiante; se versionan en el repositorio bajo arquitectura de raíz unificada (Rama A). El directorio oficial crudo (con RUT/MRUN) no se versiona: <span class="inl">31</span> lo depura en origen.</p>',
       por_que='<strong>Por qué.</strong> Verificación de cabeceras de las 34 tablas: ninguna contiene columnas personales (rut/run/mrun/nombre/id_alumno). La unidad de observación es el establecimiento. Si entrara una base por estudiante, el proyecto pasa a Rama B (datos fuera de Git) sin excepción.'),
  list(id='D6', titulo='Paleta de indicador = identidad oficial de la Agencia',
       cuerpo='<p>Los 4 indicadores se codifican con la paleta del folleto oficial de la Agencia: Autoestima azul, Convivencia turquesa, Participación verde, Hábitos verde-lima. Los colores de estado y la identidad gobCL no se tocan.</p>',
       por_que='<strong>Por qué.</strong> Coherencia institucional y validación externa: el motor replica la identidad con que la Agencia presenta los indicadores. Cambio 100% presentación, verificado por panel adversarial (cifras byte-idénticas, parquet intocado).')
)

# ---- 1.6 Anomalías de origen -----------------------------------------------
cfg$anomalias <- list(
  list(id='H1',
       largo='<strong>Fantasma rbd=NA (crudo 4b/2017).</strong> Cuatro filas crudas traían <span class="inl">rbd</span> NA y colapsaban en un establecimiento "fantasma" sin nombre/geo/GSE alcanzable por el buscador. Se descartan al construir el universo del motor (<span class="inl">!is.na(rbd)</span>); el parquet queda intacto. Universo 9.137 &rarr; 9.136.',
       corto='Cuatro filas sin RBD en 2017 generaban un establecimiento fantasma. Se descartan al armar el motor; el dato base no se toca.'),
  list(id='H2',
       largo='<strong>356 RBD sin geo (solo registro histórico).</strong> Establecimientos con máximo año ≤2018 y sin geo en el directorio. Visibles solo por el buscador, etiquetados "Sin territorio asignado · solo registro histórico". NA legítimo: no se inventa territorio.',
       corto='Algunos establecimientos solo tienen registros antiguos y no traen territorio. Se muestran solo por búsqueda, advertidos.'),
  list(id='H3',
       largo='<strong>Dedup por atributos mixtos.</strong> Un RBD con atributos histórico/moderno distintos generaba tarjetas duplicadas (20 RBD ×2). <span class="inl">est_attr</span> toma una fila por RBD (la más reciente): 9.157 &rarr; 9.137.',
       corto='Algunos establecimientos aparecían duplicados por tener datos de épocas distintas. Se unifican en una ficha por establecimiento.'),
  list(id='H4',
       largo='<strong>Etiqueta Dependencia anacrónica (por diseño).</strong> En 515 RBD la dependencia vigente difiere de la del año del dato (192 traspasos genuinos a SLEP; 323 con <span class="inl">cod_depe2</span> NA rellenada por el directorio). Decisión consciente (D4): se muestra la vigente.',
       corto='Establecimientos traspasados a un SLEP aparecen como SLEP también en años anteriores. Es una decisión explicada, no un error.')
)

# ---- 1.7 Glosarios ---------------------------------------------------------
cfg$glosario_tec <- c(
  '<strong>RBD</strong> — Rol Base de Datos. Identificador único de cada establecimiento. Siempre character.',
  '<strong>IDPS</strong> — Indicadores de Desarrollo Personal y Social. Cuatro de cuestionario (los de este motor) y cuatro administrativos.',
  '<strong>GSE / cod_grupo</strong> — Grupo socioeconómico. En IDPS: atributo y segmentador, nunca cifra agregada.',
  '<strong>prom</strong> — Puntaje 0–100 del establecimiento en un indicador/dimensión. Se lee, no se deriva.',
  '<strong>difgru / sigdifgru</strong> — Desvío respecto del mismo GSE y su significancia, calculados por la Agencia.',
  '<strong>dif / sigdif</strong> — Desvío respecto de la evaluación anterior y su significancia.',
  '<strong>cod_depe2</strong> — Dependencia en 4 categorías (Municipal, Part. subvencionado, Part. pagado, SLEP).',
  '<strong>parquet</strong> — Formato columnar comprimido de los datos intermedios.'
)
cfg$glosario_doc <- c(
  '<strong>IDPS</strong> — Indicadores de Desarrollo Personal y Social: aspectos no académicos que mide la Agencia junto a las pruebas estandarizadas de aprendizaje.',
  '<strong>Indicador de cuestionario</strong> — Los cuatro que mide este motor: autoestima y motivación, convivencia, participación, hábitos de vida saludable.',
  '<strong>Nivel de desarrollo</strong> — Distribución de estudiantes en Alto / Medio / Bajo en una subdimensión.',
  '<strong>GSE</strong> — Grupo socioeconómico del establecimiento.',
  '<strong>RBD</strong> — identificador único de establecimiento.',
  '<strong>SLEP</strong> — Servicio Local de Educación Pública.',
  '<strong>Dependencia</strong> — de quién depende hoy el establecimiento (municipal, particular subvencionado, particular pagado o SLEP).',
  '<strong>Pipeline</strong> — la secuencia de pasos que transforma las planillas de la Agencia en el motor navegable.'
)

# ---- 1.8 Entidades comparables ---------------------------------------------
# En IDPS la "comparación" es entre establecimientos (lado a lado) y contra el
# propio GSE; no hay entidad territorial agregada.
cfg$entidades_tec <- list(
  list(ct='Establecimiento', cd='Un RBD individual: la unidad de dato del motor.'),
  list(ct='Grilla por GSE', cd='Todos los establecimientos de un GSE, un radar cada uno (sin promediar).'),
  list(ct='Desvío vs GSE', cd='difgru/sigdifgru: cada establecimiento contra su mismo GSE (cifra oficial).'),
  list(ct='Filtro territorial', cd='Comuna / SLEP / región: acotan qué establecimientos se listan, no agregan.'),
  list(ct='Serie por establecimiento', cd='Evolución 2014→2025 del establecimiento, con años sin evaluación marcados.')
)
cfg$entidades_gen <- list(
  list(ct='Un establecimiento', cd='El panorama de un colegio en los cuatro indicadores.'),
  list(ct='Colegios del mismo grupo', cd='Varios establecimientos de un mismo nivel socioeconómico, lado a lado.'),
  list(ct='Comparación con su grupo', cd='Si el colegio está sobre, bajo o igual a otros de su mismo grupo.'),
  list(ct='Un filtro de zona', cd='Mirar solo los colegios de una comuna, un Servicio Local o una región.'),
  list(ct='La evolución en el tiempo', cd='Cómo cambió un colegio desde 2014, con los años sin medición marcados.')
)

# ---- 1.9 Línea de producción (arquitectura general) ------------------------
cfg$estaciones <- list(
  list(icon='boxes', color='var(--ocean)', paso='Paso 1 · Insumo', titulo='Llegan las planillas',
       parrafos=c('Cada año, la Agencia de Calidad publica los resultados de los cuestionarios IDPS por establecimiento, en planillas separadas por grado y por año. Son datos <strong>públicos</strong>.',
                  'El formato cambia con el tiempo: los códigos de los indicadores pasaron de letras a números, y los años antiguos vienen en una forma distinta de los recientes. Tal cual llegan, no se pueden leer juntos.'),
       chip_in=list(ico='download', tx='Entra: planillas IDPS 2014–2025'), chip_out=NULL),
  list(icon='shield-check', color='var(--olive)', paso='Paso 2 · Preparación', titulo='Limpieza y orden',
       parrafos=c('Antes de mostrar nada, cada planilla se revisa y se lleva a un formato común: se homologan los códigos que cambiaron, se resuelven los casos raros (filas sin establecimiento, registros solo antiguos) y se quitan del directorio los datos personales que no deben publicarse.',
                  'A cada establecimiento se le asocia su <strong>grupo socioeconómico</strong>, clave para comparar con justicia más adelante.'),
       chip_in=list(ico='file-warning', tx='Datos crudos, distintos entre años'),
       chip_out=list(ico='check', tx='Una sola tabla ordenada por establecimiento')),
  list(icon='layers', color='var(--coral)', paso='Paso 3 · Organización', titulo='Catálogo de conceptos',
       parrafos=c('Los indicadores IDPS tienen una estructura: cada uno se abre en dimensiones y subdimensiones. Ese mapa conceptual se arma como un catálogo de cuatro niveles, para que el motor pueda mostrar el detalle ordenado.',
                  'Aquí <strong>no se promedia ni se junta nada por territorio</strong>: el dato se conserva tal como lo publica la Agencia, establecimiento por establecimiento.'),
       chip_in=list(ico='check', tx='Datos limpios por establecimiento'),
       chip_out=list(ico='sitemap', tx='Conceptos ordenados en 4 niveles')),
  list(icon='bar-chart-3', color='var(--plum-80)', paso='Paso 4 · Producto', titulo='Se arma el tablero',
       parrafos=c('Los datos y el catálogo se empaquetan dentro de una <strong>interfaz interactiva</strong>: radares por establecimiento, comparación con su grupo, distribución de niveles y la evolución en el tiempo. Todo en un solo archivo.',
                  'Ese archivo <strong>lleva los datos adentro</strong>: no necesita conexión ni programas especiales.'),
       chip_in=list(ico='sitemap', tx='Datos y conceptos listos'),
       chip_out=list(ico='file-code-2', tx='Un archivo navegable')),
  list(icon='monitor', color='var(--plum)', paso='Paso 5 · Producto terminado', titulo='La herramienta lista',
       parrafos=c('El resultado es un <strong>tablero que se abre en cualquier navegador</strong>, sin instalar nada. Permite elegir un establecimiento (filtrando por zona o por grupo socioeconómico) y ver su panorama IDPS y su evolución desde 2014.',
                  'Está publicado en línea y se actualiza repitiendo la línea de producción cuando llegan datos nuevos.'),
       chip_in=NULL, chip_out=list(ico='globe', tx='Tablero publicado y consultable'))
)

# ---- 1.10 Garantías (lenguaje simple) --------------------------------------
cfg$garantias <- list(
  list(icon='copy-check', titulo='Mostramos la cifra oficial, no una propia', d='El motor lee los puntajes y comparaciones tal como los publica la Agencia. No recalcula ni promedia nada por su cuenta.'),
  list(icon='scale', titulo='Cada establecimiento se compara con su grupo', d='Un colegio se mira frente a otros de su mismo nivel socioeconómico, usando la comparación que la propia Agencia ya calculó. No inventamos un promedio del grupo ni de la zona.'),
  list(icon='calendar-x', titulo='No inventamos años sin medición', d='En 2020 y 2021 no hubo evaluación (pandemia), y algunos grados no se midieron ciertos años. Esos vacíos se muestran como vacíos, nunca como una línea continua.'),
  list(icon='shapes', titulo='No mezclamos indicadores ni grados', d='Cada indicador y cada grado se ven por separado. Combinarlos daría un número sin sentido.'),
  list(icon='eye-off', titulo='Sin datos de estudiantes', d='Toda la información es agregada por establecimiento. El motor no contiene ni muestra datos de estudiantes individuales.'),
  list(icon='info', titulo='La dependencia es la de hoy', d='Un colegio traspasado a un Servicio Local aparece como tal también en años anteriores. Es una decisión explicada: el motor muestra de quién depende hoy.')
)

# ---- 1.11 "En qué fijarte" --------------------------------------------------
cfg$notas <- list(
  list(icon='palette', tx='<strong>Cada indicador tiene siempre el mismo color,</strong> el de la identidad oficial de la Agencia. No hay que memorizar leyendas distintas entre vistas.'),
  list(icon='scale', tx='<strong>Siempre verás el resultado junto a su grupo socioeconómico.</strong> No es un detalle: es lo que permite comparar con justicia. Un único número mezclaría realidades distintas.'),
  list(icon='git-compare', tx='<strong>La comparación es contra el mismo grupo, no contra un promedio de la zona.</strong> El motor muestra si el colegio está sobre, bajo o igual a su grupo, con la marca que calcula la Agencia.'),
  list(icon='calendar-x', tx='<strong>Hay años en gris.</strong> No es un error: o no hubo evaluación (2020–2021) o ese grado no se midió ese año. Se marca a propósito.'),
  list(icon='flag', tx='<strong>La dependencia que ves es la actual.</strong> Para colegios traspasados a un Servicio Local, eso significa que figuran como SLEP también en años en que dependían del municipio.')
)

# ---- 1.12 Preguntas frecuentes ---------------------------------------------
cfg$faq <- list(
  list(q='¿Por qué cuatro indicadores y no ocho?', a='Los IDPS son ocho en total, pero cuatro se miden por cuestionario (los de este motor: autoestima y motivación, convivencia, participación, hábitos de vida saludable) y cuatro por información administrativa (asistencia, retención, equidad de género, titulación técnico-profesional). Este motor cubre los cuatro de cuestionario.', abierta=TRUE),
  list(q='¿Qué significa que un año aparezca en gris?', a='Que no hubo evaluación de ese indicador ese año: por la pandemia (2020 y 2021) o porque ese grado no se evaluó ese año (por ejemplo 2019 en 4° básico y II medio). No es un dato faltante por error: es que no se midió.', abierta=FALSE),
  list(q='¿Comparado con qué está un establecimiento?', a='Con su mismo grupo socioeconómico, usando la comparación que la propia Agencia ya calculó (sobre, bajo o igual a su grupo, con su significancia). El motor no inventa un promedio del grupo ni del territorio.', abierta=FALSE),
  list(q='¿Por qué no hay un promedio por comuna o por SLEP?', a='Porque las fuentes IDPS no informan cuántos estudiantes respondieron en cada establecimiento. Sin ese dato no se puede promediar de forma válida entre establecimientos, así que el motor muestra el dato establecimiento por establecimiento. Los filtros de zona solo acotan qué colegios se listan.', abierta=FALSE),
  list(q='¿Qué dependencia muestra la ficha?', a='La dependencia vigente del establecimiento según el directorio oficial de hoy. Para colegios traspasados a un Servicio Local, eso significa que aparecen como SLEP aunque en años anteriores dependieran del municipio.', abierta=FALSE),
  list(q='¿Necesito instalar algo para usarlo?', a='No. Es un archivo que se abre en cualquier navegador y funciona sin conexión. También está publicado en línea para consultarlo directamente.', abierta=FALSE)
)

# ---- 1.13 Prosa de los documentos de lectura -------------------------------
# REVISAR (voz): afinar el tono; el dato es correcto.
cfg$prosa <- list(
  doc_que = c(
    '<code class="inl">slep_idps</code> es una herramienta para <strong>explorar los Indicadores de Desarrollo Personal y Social (IDPS) de cada establecimiento</strong>, tal como los publica la Agencia de Calidad de la Educación. Muestra el panorama de un establecimiento en los cuatro indicadores de cuestionario, su desglose por dimensión y subdimensión, su evolución desde 2014, y cómo se sitúa respecto de establecimientos de su mismo grupo socioeconómico.',
    'El problema que resuelve es concreto: los resultados IDPS se publican por establecimiento, grado y año, en planillas dispersas cuyo formato cambia con el tiempo. A diferencia de las pruebas estandarizadas de aprendizaje, las fuentes IDPS no informan cuántos estudiantes respondieron, de modo que no existe una forma válida de promediar entre establecimientos. Por eso el motor <strong>no agrega por territorio</strong>: muestra el dato al nivel en que la Agencia lo entrega, el establecimiento, y deja que la comparación se haga estableciendo cada colegio frente a su mismo grupo.',
    'El producto final es un <strong>archivo HTML autónomo</strong> (<code class="inl">motor_idps.html</code>): se abre en cualquier navegador, sin instalar nada, y está publicado para consulta en línea. La regla rectora es leer la cifra oficial, nunca derivarla.'
  ),
  doc_pipeline = c(
    'Detrás del archivo navegable hay un <strong>pipeline en R</strong> de cinco etapas, orquestado por un único script (<code class="inl">00_build.R</code>). Cada etapa lee el resultado de la anterior y escribe el suyo, de modo que el proceso completo es reproducible de principio a fin. En prosa, las etapas son:'
  ),
  gen_porque = c(
    'Los IDPS amplían la idea de calidad educativa más allá de lo académico, pero suelen quedar en planillas difíciles de leer, con formatos que cambian de un año a otro.',
    'Esta herramienta hace ese trabajo una sola vez, con reglas claras, y entrega el panorama de cada establecimiento listo para mirar, fiel a la cifra oficial. El objetivo es que la conversación sea sobre <strong>qué dicen los datos</strong>, no sobre cómo armarlos.'
  ),
  etapas_pipeline = '<h3>1 · Depurar el directorio</h3><p>Se quita del directorio oficial todo dato personal antes de usarlo, dejando una versión pública con la geografía y la dependencia de cada establecimiento.</p><h3>2 · Censar las planillas</h3><p>Se perfilan las tablas de la Agencia para saber qué hay, con qué cobertura y qué vacíos.</p><h3>3 · Ordenar los conceptos</h3><p>Se arma el catálogo de cuatro niveles (indicador, dimensión, subdimensión, actor) que estructura el detalle.</p><h3>4 · Leer y normalizar</h3><p>Se leen las tres familias de tablas, se homologan los códigos que cambiaron en el tiempo y se funden en una única tabla por establecimiento, sin agregar por territorio.</p><h3>5 · Generar el motor</h3><p>Los datos se empaquetan dentro de un archivo HTML autónomo que se publica.</p>'
)

# ---- 1.14 Gobernanza -------------------------------------------------------
cfg$gobernanza <- "Datos públicos de la Agencia de Calidad"

# ---- 1.15 Rótulos del diagrama técnico -------------------------------------
cfg$rotulos <- list(
  lbl_fuentes     = 'Fuentes de datos <span class="sub">20_insumos/</span>',
  lbl_auxiliares  = 'Tablas auxiliares <span class="sub">20_insumos/auxiliares/</span>',
  lbl_intermedios = 'Datos intermedios <span class="sub">40_salidas/intermedios/</span>',
  norm_titulo     = 'Casos de origen resueltos (datos crudos Agencia de Calidad)',
  exec = '<span class="cm"># Ejecución canónica del pipeline completo:</span><br><span class="fn">source</span>(<span class="str">"00_build.R"</span>)<br><br><span class="cm"># Republicar en GitHub Pages tras el build:</span><br><span class="cm"># cp 40_salidas/motor_idps.html docs/index.html &amp;&amp; git push</span>'
)

# ---- 1.16 Leyenda del diagrama (posicional, sin nombres) -------------------
cfg$leyenda <- list(
  list(color="var(--ocean)", texto="Pipeline R"),
  list(color="var(--plum)",  texto="Auxiliares / Motor"),
  list(color="var(--sand)",  texto="Datos intermedios"),
  list(color="var(--amber)", texto="Decisión metodológica"),
  list(color="var(--olive)", texto="Caso de origen resuelto (H1–H4)")
)

# ---- 1.17 Reglas de cálculo ------------------------------------------------
cfg$reglas_calculo <- list(
  list(titulo='Leer, no derivar',
       cuerpo='<p>El motor LEE <span class="inl">prom / dif / sigdif / difgru / sigdifgru / niveles</span> del parquet. No recalcula ninguna cifra: las medidas son invariantes.</p>'),
  list(titulo='Sin agregación territorial',
       cuerpo='<p>No existe ponderador (las fuentes IDPS no publican respondentes). El dato se muestra al nivel del establecimiento; territorio y GSE son filtros y etiquetas, jamás cifra agregada.</p>'),
  list(titulo='Comparación contra el mismo GSE',
       cuerpo='<p>Se usa <span class="inl">difgru/sigdifgru</span> (desvío vs el mismo GSE, calculado por la Agencia) como marca de sobre/bajo/igual. No se dibuja el puntaje absoluto del GSE: derivarlo reconstruiría un consolidado prohibido.</p>'),
  list(titulo='NA = resguardo, nunca cero',
       cuerpo='<p>Un NA en la medida es supresión estadística de la Agencia, no ausencia ni cero. No se imputa.</p>')
)

# ---- 1.18 Pie por documento ------------------------------------------------
cfg$pie_extra <- list(
  arq_tec = "Casos de origen H1–H4 documentados en idps_corpus_conceptual.md y en las decisiones de 50_documentacion/activa/decisiones/.",
  doc_tec = "",
  arq_gen = "¿Necesitas el detalle técnico? Abre arquitectura_slep_idps.html",
  doc_gen = ""
)

# ---- 1.19 Textos de sección y hero-notes -----------------------------------
# REVISAR (voz): títulos e intros de sección; ajustar tono si hace falta.
cfg$textos <- list(
  ref_intro        = 'El diagrama de arriba muestra <strong>cómo fluyen los datos</strong>. Las secciones siguientes documentan el proyecto al detalle, de modo que cualquier persona técnica (o una sesión de IA) pueda reconstruir el contexto completo sin material adicional.',
  dic_crudos_titulo= 'Datos crudos (planillas IDPS y directorio)',
  dic_interm_titulo= 'Datos intermedios producidos',
  reglas_titulo    = 'Reglas de cálculo',
  anom_titulo      = 'Casos de origen resueltos H1–H4 (detalle)',
  anom_intro       = 'Particularidades de los datos crudos que el pipeline resuelve de forma trazable <strong>antes</strong> de mostrar nada. No son errores del proyecto.',
  doc_s2_intro     = 'El motor permite explorar el panorama IDPS de distintos <strong>establecimientos</strong>:',
  doc_s2_cierre    = 'Para cada establecimiento se muestra el panorama de los <strong>cuatro indicadores</strong>, su <strong>desglose</strong> por dimensión y subdimensión, su <strong>evolución</strong> desde 2014 y su <strong>desvío respecto del mismo GSE</strong>. La comparación entre colegios se hace poniendo sus radares lado a lado, sin promediar.',
  doc_dec_intro    = 'Reglas que gobiernan todo el motor. Cada una corrige una forma específica de leer mal los datos IDPS.',
  doc_s5_intro     = 'Todos los datos provienen de la <strong>Agencia de Calidad de la Educación</strong> y son <strong>públicos</strong>. Las planillas crudas traen particularidades de origen que el pipeline resuelve antes de mostrar nada:',
  gen_hero         = 'Piensa en este proyecto como una <strong>pequeña fábrica de datos</strong>. Llegan materias primas —las planillas IDPS de la Agencia—, pasan por una línea que las limpia, las ordena y las ensambla, y al final sale un <strong>producto terminado</strong>: una herramienta para mirar el panorama de cada establecimiento de forma justa.',
  gen_linea_titulo = 'La línea de producción',
  gen_guards_titulo= 'Las garantías de calidad de la fábrica',
  gen_guards_intro = 'Toda fábrica seria tiene reglas que nunca se saltan. Estas existen para que las comparaciones sean <strong>justas y honestas</strong>:',
  gen_frase_titulo = 'En una frase',
  gen_frase        = 'Una línea de producción que toma más de una década de planillas IDPS dispersas, las limpia, las ordena y las convierte en un <strong>tablero navegable</strong> para mirar el desarrollo personal y social de cada establecimiento, sin inventar promedios.',
  doc_gen_hero          = 'Es una herramienta para <strong>mirar los Indicadores de Desarrollo Personal y Social de cada establecimiento</strong>: autoestima y motivación, convivencia, participación y hábitos de vida saludable, a lo largo del tiempo y siempre junto a su grupo socioeconómico.',
  doc_gen_porque_titulo = 'Por qué existe',
  doc_gen_hacer_titulo  = 'Qué puedes hacer con ella',
  doc_gen_hacer_intro   = 'Eliges <strong>qué establecimiento mirar</strong> y la herramienta te muestra su panorama y su evolución:',
  doc_gen_hacer_cierre  = 'Para el establecimiento que elijas verás su <strong>panorama en los cuatro indicadores</strong>, su <strong>comparación con su grupo socioeconómico</strong> y su <strong>evolución año a año</strong>, con los años sin medición marcados.',
  doc_gen_fijarte_titulo= 'En qué fijarte al leerla',
  doc_gen_fijarte_intro = 'Cinco claves para interpretar la herramienta sin malentendidos:',
  doc_gen_datos_titulo  = 'De dónde vienen los datos',
  doc_gen_datos_cuerpo  = 'Todos los resultados provienen de la <strong>Agencia de Calidad de la Educación</strong> y son <strong>públicos</strong>. La herramienta no contiene información de estudiantes individuales: trabaja siempre con resultados agregados por establecimiento.',
  doc_gen_faq_titulo    = 'Preguntas frecuentes'
)

# ---- Generar ---------------------------------------------------------------
generar_suite(cfg, salida_dir = DESTINO_SUITE)
