# Prompt de apertura — `slep_idps` (NEW PROJECT)

> Pega este mensaje como primer turno de un chat nuevo, dentro del Project.
> Adjunta los archivos listados al final. El protocolo (POLITICA_PROYECTO.md +
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base; léelo desde ahí.

---

Tipo de sesión: **NEW PROJECT**.

## Qué quiero construir

Un motor de comparación interactivo, hermano de `slep_simce_adecuado`, sobre los
**Indicadores de Desarrollo Personal y Social (IDPS)** de la Agencia de Calidad.
Producto: HTML autocontenido (React 18 + D3 v7), comparación de territorios y
establecimientos en el tiempo, publicado en GitHub Pages. Nombre: `slep_idps`.

## Qué son los IDPS

Índices en escala **0–100 por establecimiento** que miden aspectos no académicos,
medidos junto al Simce. Los cuatro de cuestionario:
- **Autoestima académica y motivación escolar** (id_indicador 1)
- **Clima de convivencia escolar** (2)
- **Participación y formación ciudadana** (3)
- **Hábitos de vida saludable** (4)

Cada indicador se descompone en **dimensiones** y **subdimensiones**, y los datos
vienen **pre-agregados por la Agencia a nivel de RBD** (no por estudiante). Esto
simplifica el pipeline: no hay que ponderar respuestas individuales, la Agencia
ya entregó el puntaje del establecimiento.

## Esquema real de la fuente (ya inspeccionado)

Tres tablas por año/grado, todas con una fila por RBD × indicador (× dimensión o
subdimensión según la tabla):

**1. `idps4b2025_rbd_preliminar` — puntaje del INDICADOR (24 vars):**
`agno, rbd, id_indicador, prom, dif, mdif, sigdif, difgru, mdifgru, sigdifgru,
nom_rbd, cod_reg_rbd, nom_reg_rbd, cod_pro_rbd, nom_pro_rbd, cod_com_rbd,
nom_com_rbd, nom_deprov_rbd, cod_depe2, cod_grupo, cod_rural_rbd, codigo_bbdd,
fecha_bbdd, grado`. `prom` es el puntaje 0–100. **Trae `cod_grupo` (GSE) y
`difgru` (diferencia con el mismo GSE).**

**2. `idps4b2025_rbd_dim_preliminar` — puntaje por DIMENSIÓN (21 vars):**
igual, con `id_dimension` extra (sin las vars de difgru). 77.319 obs en 4° básico.

**3. `idps4b2025_rbd_subdim_niveles_preliminar` — DISTRIBUCIÓN por subdimensión
(14 vars):** `agno, rbd, id_indicador, id_dimension, id_subdimension,
niv_bajo_por, niv_medio_por, niv_alto_por, niv_mbajo_por, niv_mmedio_por,
niv_malto_por, codigo_bbdd, fecha_bbdd, grado`. Aquí el dato es la distribución
**Alto/Medio/Bajo** (%) por subdimensión (las `niv_m*` son marcas de supresión).

Códigos (de las glosas): indicador 1 → dims 11 (Autopercepción/autovaloración),
12 (Motivación escolar); indicador 2 → 21/22/23 (Ambiente respeto/organizado/
seguro); indicador 3 → 31/32/...; etc. `cod_depe2`: 1 Municipal, 2 Particular
subvencionado, 3 Particular pagado (ojo: 3 categorías acá, vs. el esquema del
proyecto madre — homologar).

## Diseño que se desprende del esquema (confírmalo o ajústalo)

1. **Selector de indicador** como eje principal (la contraparte del prueba×nivel
   del proyecto madre): el usuario elige uno de los 4 IDPS. No mezclar
   indicadores en una cifra agregada.
2. **Dos vistas de dato por la naturaleza de la fuente:**
   - Puntaje 0–100 del indicador/dimensión (continuo, ponderable como en el
     proyecto madre) → sparkline/serie temporal.
   - Distribución Alto/Medio/Bajo por subdimensión (categórica apilada) → barras
     apiladas, reutilizando el patrón de apilado que ya existe en el motor madre.
3. **Agregación territorial.** Para el puntaje (tablas 1–2): promedio ponderado
   por matrícula/`nalu` al subir a comuna/SLEP/región (a confirmar la variable de
   ponderación; el archivo IDPS no trae `nalu` directo — quizá unir con matrícula
   del directorio o con el dato Simce del proyecto madre). Para la distribución
   (tabla 3): ponderar los % por el N de estudiantes de cada RBD.
4. **GSE.** El indicador SÍ trae `cod_grupo`, y la Agencia reporta `difgru`
   (comparación dentro del mismo GSE). Mantengo **GSE inviolable** como en el
   proyecto madre. Confirmar.
5. **Grado.** Los IDPS se reportan por grado (4°, 6°, 8° básico, II medio). No
   mezclar grados, igual que el proyecto madre no mezcla niveles.

## Sensibilidad de datos (bifurcación §8.1 — Rama A, público con verificación)

Los IDPS **por RBD** que entrega la Agencia son agregados públicos (el taller
oficial dice "se entregan resultados por establecimiento, no por estudiante", y
"la información e identidad de quienes responden es confidencial"). Raíz
unificada, datos versionados, sin data root externo.

> **Gobernanza a verificar al abrir, antes de versionar nada:** las Condiciones
> de Uso de la Agencia restringen las bases **desagregadas a nivel de alumno**.
> Los archivos `idps*_rbd_*` son agregados por establecimiento, equivalentes en
> naturaleza al Simce por estándar que el proyecto madre ya publica. Confirmar
> explícitamente que estos xlsx son los públicos (no una base por estudiante) y
> documentar la decisión en `decisiones/`, citando la misma lógica que la
> decisión B2 del proyecto madre. Si en algún punto entrara data por estudiante,
> esto pasa a Rama B (dos raíces) sin excepción.

## Relación con `minuta_simce`

`minuta_simce` ya produce un reporte IDPS en Word/Quarto. Este es distinto: motor
interactivo. Revisar en la apertura cómo `minuta_simce` lee y nombra los IDPS
para alinear criterios de lectura/normalización. Puedo adjuntar esos scripts.

## Paso 0 obligatorio: scaffold + versionado temprano (antes de cualquier pipeline)

La PRIMERA acción concreta, antes de leer un solo xlsx o escribir lógica de
datos, es dejar el proyecto inicializado y versionado. Esto NO es opcional ni se
mezcla con el pipeline:

1. **Crear el esqueleto de carpetas vacías** según la estructura canónica
   (POLÍTICA §1.1), listas para poblarse: `10_utils/`, `20_insumos/`,
   `30_procesamiento/`, `40_salidas/intermedios/`, `50_documentacion/{activa,
   activa/decisiones,traspasos,andamios,estructura}/`, `tests/`. Cada carpeta que
   aún no tenga contenido lleva un `.gitkeep` para que git la versione. Los
   nombres de carpetas y archivos siguen la nomenclatura de la política
   (decenas, snake_case, sin tildes/ñ/espacios).
2. **Stubs mínimos en su sitio** (POLÍTICA §8.4): `00_build.R` (orquestador
   stub funcional), `00_escanear_proyecto.R`, `10_utils/10_utils.R` con
   bootstrapping, `10_utils/10_configuracion.R` con rutas vía `here::here()`
   (Rama A, sin data root externo), `.gitignore` estándar (sin bloque de datos),
   `README.md` mínimo, `slep_idps.Rproj`, y copia de `POLITICA_PROYECTO.md` +
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md` a `50_documentacion/activa/` (o
   verificación de que están en la knowledge base) y `CLAUDE.md` en la raíz.
3. **Git local desde el primer commit:** `git init`, `.gitignore` correcto,
   primer commit con el esqueleto ("scaffold inicial: estructura canónica
   vacía"). El versionado arranca con el esqueleto, no después de tener código.
4. **Repo remoto GitHub de inmediato** (no diferido): crear el repo **privado**
   `tomgc/slep_idps`, conectar el remoto y hacer push del scaffold.
   Branch principal `main`. Esto deja el proyecto respaldado y trazable desde el
   minuto cero, replicando lo que ya tiene `slep_simce_adecuado`.
5. **Primer escaneo** (`00_escanear_proyecto.R`) y commit del snapshot inicial.

Solo con el Paso 0 cerrado (estructura creada, git local + remoto, primer
escaneo) se pasa a inspeccionar datos y construir el pipeline. La idea es ir
**poblando** carpetas que ya existen y versionando cada avance, no crear
estructura sobre la marcha.

Tareas manuales que son MÍAS (la inicialización las indica en una línea, sin
script): crear el repo en GitHub si requiere acción en la web, y cualquier
descarga o arrastre de archivos.

## Ruta de trabajo propuesta (confírmala o ajústala)

1. **Paso 0** completo (scaffold + git local + repo GitHub privado + primer
   escaneo), según la sección anterior. Reutilizar el esqueleto de
   `slep_simce_adecuado` como molde de carpetas y stubs.
2. Inspección de las 3 tablas para todos los grados/años disponibles (confirmar
   ponderación, GSE, cobertura temporal).
3. Pipeline: lectura de las 3 tablas → normalización (homologar `cod_depe2`,
   resolver ponderación) → reutilizar catálogos de entidades del proyecto madre →
   tablas `idps_rbd` (puntaje) e `idps_niveles_rbd` (distribución) → agregación
   ponderada por indicador/dimensión × GSE × territorio.
4. Motor HTML: adaptar el template. Cambios principales: selector de indicador,
   eje 0–100 para puntajes, y reutilizar el apilado existente para la
   distribución Alto/Medio/Bajo. Supergrid, GSE, tooltip, export se conservan.
5. Publicación en Pages.

## Antes de empezar

Ejecuta la pregunta de bifurcación (ya resuelta: Rama A, sujeta a la verificación
de gobernanza). En tu plan, el paso 1 debe ser el **Paso 0** (scaffold + git
local + repo GitHub privado + primer escaneo). Entrégame el plan NEW PROJECT del
protocolo y confirma explícitamente los 5 puntos de diseño. No escribas código hasta que apruebe la
ruta.

## Reutilización del proyecto madre (biblioteca de patrones, no reescribir)

Ya resuelto allí: catálogos de entidades, escáner, orquestador, `agregar_ponderado`
en `10_utils.R`, gzip+pako, export SVG/PNG, apilado de niveles, tooltip,
buscador con diacríticos, Pages. Es la base más cercana a este proyecto.

---

**Adjuntar a este mensaje:**
- `idps4B2025_rbd_dim_preliminar.xlsx` y `idps4b2025_GLOSAS_web_preliminar.xlsx`
  (glosas con todos los códigos de indicador/dimensión/subdimensión).
- `Metodologia_de_Calculo_IDPS.pdf` (define la construcción de cada índice).
- Del proyecto madre: `10_utils/10_utils.R`, `30_construir_auxiliares.R`,
  `31_leer_normalizar.R`, `33_generar_html.R`, `33_motor_template.html`,
  `00_build.R`.
- (Opcional) scripts de lectura de IDPS de `minuta_simce` para alinear criterios.
