# traspaso_cierre_v03.md — slep_idps

## 1. Identificación

- **Proyecto:** `slep_idps` — Motor interactivo de comparación de Indicadores de
  Desarrollo Personal y Social (IDPS) por territorio y GSE, SLEP Costa Central y
  todo Chile. React 18 + D3 v7, HTML autocontenido en GitHub Pages. Hermano de
  `slep_simce_adecuado`.
- **Versión:** v03
- **Fecha:** 2026-06-12
- **Sesión:** 3. Foco: exploración y documentación conceptual de los IDPS (P10),
  no técnica. Construcción de un corpus conceptual dual (JSON estructurado + MD
  narrativo) de los 4 indicadores de cuestionario.
- **Entorno:** Interfaz web (sesión de documentación/diseño). Sin Claude Code,
  sin ejecución de R, sin acceso a los xlsx ni re-corrida del escáner.
- **Repo:** `https://github.com/tomgc/slep_idps` (privado).
- **Archivos principales creados esta sesión (entregados como artefactos, el
  usuario los descarga y ubica):**
  `20_insumos/auxiliares/referencias_idps/idps_corpus_conceptual.json` (nuevo),
  `20_insumos/auxiliares/referencias_idps/idps_corpus_conceptual.md` (nuevo,
  derivado del JSON),
  más dos PDF fuente que el usuario ya guardó en esa misma carpeta
  (`otros_indicadores_calidad_2019.pdf` = folleto Mineduc 2019;
  `marco_evaluacion_idps_2025.pdf` = Marco de Evaluación, edición oct 2024).
- **Scripts auxiliares de generación (viven junto al corpus, regeneran el MD):**
  `generar_md.py`, `inyectar_niveles.py`. Pendiente de decisión del usuario si
  se versionan (ver pendiente P10-bis).

## 2. Resumen ejecutivo

Tercera sesión, de tipo CONTINUATION, de exploración de documentación conceptual
(P10), sin tocar código ni pipeline. Se procesaron dos documentos de la Agencia
con distinto nivel de profundidad (folleto 2019: definiciones + "qué hacen los
establecimientos que puntúan alto" por indicador, incluyendo los 8 indicadores;
Marco de Evaluación oct 2024: estructura formal indicador→dimensión→subdimensión
→actor con definiciones operacionales para los 4 indicadores de cuestionario).
Se acordó alcance: solo los 4 indicadores de cuestionario (los que el motor
segmenta por GSE). Se construyó un corpus dual con fuente única: un JSON
estructurado (jerarquía completa, consumible por la UI) del que se deriva por
script un MD narrativo (sección metodológica / consulta). Estructura validada:
11 dimensiones, 30 subdimensiones. A media sesión el usuario aportó dos URLs que
desbloquearon el cierre completo de P10: el documento *Descripción de
subdimensiones y niveles de desarrollo IDPS* (descripción cualitativa por nivel)
y un *Marco 2025 v3*. Se incorporaron las descripciones de niveles **separadas
por ciclo** (4°/6° básico vs II medio, que difieren en varias subdimensiones), y
se descubrió la regla de dominio de que los niveles solo se reportan para
subdimensiones evaluadas en estudiantes (EST). El cotejo confirmó que el "Marco
2025 v3" es idéntico en contenido a la edición oct 2024 (sin cambios de
estructura). Corpus cerrado en v1.1, P10 completo sin huecos.

## 3. Estado al cierre

**Qué funciona / existe:**
- Corpus conceptual dual v1.1 completo: `idps_corpus_conceptual.json` (fuente
  única) + `idps_corpus_conceptual.md` (derivado). 4 indicadores, 11 dimensiones,
  30 subdimensiones, con definiciones de indicador/dimensión/subdimensión, actor
  por subdimensión, y descripciones de niveles por ciclo para las 22 subdims EST.
- Scripts de generación funcionando: `generar_md.py` (JSON→MD) e
  `inyectar_niveles.py` (inyecta niveles emparejando por nombre normalizado, con
  manejo de variantes de nombre).
- Los dos PDF fuente y el corpus guardados en
  `20_insumos/auxiliares/referencias_idps/`.

**Qué no funciona / no existe aún (igual que al cierre de v02, esta sesión no era
técnica):**
- Pipeline de datos (P6): `00_build.R` sigue siendo stub. Sin lectura,
  normalización ni agregación reales.
- `10_utils.R`: sin `agregar_ponderado()` (P3 pendiente).
- Ponderación territorial (P4) sin resolver.
- Censo (P5-bis): pendiente de verificar si quedó versionado al cierre de v02.
- El escáner NO se re-corrió esta sesión (no aplicaba a documentación); sigue sin
  reflejar el censo ni el corpus nuevo.

**Delta respecto a v02:** se agrega el corpus conceptual dual como insumo
estructurado de los IDPS; P10 pasa de "pendiente con hueco" a "completo"; se
documentan dos variantes de nombre de subdimensión y la equivalencia
Marco2024≡Marco2025v3; se descubre la regla "niveles solo para EST" y la
diferencia de niveles por ciclo.

## 4. Registro detallado de cambios

16. **Procesamiento de documentación conceptual (folleto 2019 + Marco oct 2024)
    y fijación de alcance.** Se acordó cubrir solo los 4 indicadores de
    cuestionario (Autoestima, Clima, Participación, Hábitos), excluyendo los 4
    administrativos (Asistencia, Retención, Equidad de género, Titulación TP) que
    no tienen subdimensiones ni cuestionario y no se segmentan por GSE.
17. **Diseño y construcción del corpus dual con fuente única.** Decisión: JSON
    estructurado como fuente canónica + MD derivado por script (no transcripción
    manual paralela, para evitar divergencia). Esquema:
    indicador{definicion, instrumento, puntuacion, importancia,
    caracterizacion_nivel_alto, dimensiones[]}; dimension{definicion,
    subdimensiones[]}; subdimension{actores, definicion,
    descripcion_niveles_subdimension}.
18. **Validación de estructura:** 11 dimensiones, 30 subdimensiones, conteos
    verificados por script contra lo esperado.
19. **Reconciliación de orden de dimensiones de Participación.** El folleto 2019
    y el Marco 2024 difieren en el orden (no en el contenido). Se adopta el orden
    del Marco 2024 (fuente canónica): Participación → Vida democrática → Sentido
    de pertenencia.
20. **Incorporación del documento de niveles** (*Descripción de subdimensiones y
    niveles de desarrollo IDPS*, Agencia 2024, datos Cuestionarios 2024). Se
    poblaron las descripciones cualitativas por nivel, **separadas por ciclo**
    (`basica` = 4°/6°, `media` = II medio), porque varias subdimensiones difieren
    entre ciclos (ej.: autocuidado "ocho horas" básica vs "siete horas" media;
    Vida democrática con texto distinto y mención al Centro de Estudiantes en
    media). 16 subdims con 3 niveles, 6 con 2 niveles.
21. **Descubrimiento de la regla "niveles solo para EST".** Las 8 subdimensiones
    sin niveles son exactamente las de actor DOC y/o PAD; las 22 con niveles son
    todas EST. No es hueco de datos: es regla del dominio (los niveles se
    construyen de respuestas de estudiantes). Se marcaron las 8 con
    `niveles_no_aplica_motivo` explícito para que la UI no las trate como
    faltantes.
22. **Cotejo Marco 2025 v3 vs Marco 2024.** El archivo "2025 v3" es idéntico en
    contenido a la edición oct 2024 (mismas tablas 1–17, 11 dim, 30 subdim,
    definiciones y actores). Sin cambios de estructura. La decisión condicional
    del usuario (adoptar 2025 si difería) no se gatilla. Documentado en
    `_meta.nota_marco_2025`.
23. **Registro de dos variantes de nombre de subdimensión** en
    `_meta.variantes_nombre`: (a) "Participación" aparece como "Participación de
    la o el estudiante" en el documento de niveles; (b) "Actitud frente a la
    actividad física" figura como "Actitud frente a la vida activa" en la tabla
    14 del Marco (inconsistencia interna del propio Marco), y como "Actitud
    frente a la actividad física" en su tabla 16 y en el documento de niveles.

## 5. Backlog acumulativo

### Objetivo del proyecto

`slep_idps` es un motor de comparación interactivo de los Indicadores de
Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación.
Produce un HTML autocontenido (React 18 + D3 v7) publicado en GitHub Pages que
compara territorios (establecimiento, comuna, SLEP, región, país) y su evolución
temporal, siempre segmentado por grupo socioeconómico (GSE), para el equipo de
Monitoreo y Seguimiento del SLEP Costa Central. Hermano de `slep_simce_adecuado`,
del que reutiliza catálogos, patrones de agregación, escáner y estética. Activo
desde 2026-06-11.

### Nota metodológica

Un "cambio" es una solicitud distinguible del usuario, no las acciones técnicas
que la implementan. No cuentan los errores del asistente corregidos en el acto;
sí cuentan los bugfixes reportados por el usuario. Clasificación por intención
primaria. Fuente del conteo: registro detallado de cada traspaso.

### Clasificación temática (refinada en v03)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 3 | 13% | Estructura canónica, stubs, git, repo remoto |
| Gobernanza de datos | 4 | 17% | Verificación sensibilidad, decisión, depuración directorio, ignore |
| Visualización / diseño | 3 | 13% | Prototipo radar, reubicación, prompt de diseño Claude Design |
| Perfilado / exploración de datos | 2 | 9% | Censo exhaustivo, mapa de cobertura grado×año×familia |
| Limpieza / deuda técnica | 3 | 13% | P1 (no-op), P2 reubicación, commits atómicos |
| Documentación conceptual / contenido | 8 | 35% | Corpus dual IDPS, niveles por ciclo, reconciliación de fuentes |

(23 cambios acumulados a v03. La nueva categoría "Documentación conceptual /
contenido" absorbe los 8 cambios de la sesión 3, que no encajaban en las
categorías técnicas previas. Supera el 25%; si crecen sesiones de contenido,
subdividir entre "definiciones/estructura" y "niveles/descripción".)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| **Total** | | **23** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02). Cambio 9 resuelve la
  precaución de gobernanza del backlog.
- Sesión 3 (2026-06-12): cambios 16–23 (ver sección 4). El conjunto cierra P10.
  Cambios 20–21 dependieron de un insumo (documento de niveles) aportado por el
  usuario a media sesión vía URL.

### Delta del backlog

8 entradas nuevas (16–23). Refinamiento de taxonomía: se agregó la categoría
"Documentación conceptual / contenido" (35%). Los porcentajes de las categorías
previas se recalcularon sobre el nuevo total de 23.

## 6. Bugs de la sesión

No aplica en esta sesión: no se reportaron bugs. Un único tropiezo operativo: la
descarga directa de los PDF desde el S3 de la Agencia devolvió HTTP 403 (dominio
fuera de la lista permitida para `curl` en el entorno); se resolvió con el fetcher
web, que sí puede traer URLs provistas por el usuario. No es bug del proyecto.

## 7. Aprendizajes y restricciones descubiertas

11. **Los niveles de desarrollo IDPS solo se reportan para subdimensiones
    evaluadas en estudiantes (EST).** Las subdimensiones de actor DOC/PAD no
    tienen niveles. Regla: la UI debe tratar la ausencia de niveles en una
    subdimensión DOC/PAD como intencional (no como dato faltante). En el corpus,
    esas 8 subdimensiones llevan `descripcion_niveles_subdimension: null` +
    `niveles_no_aplica_motivo`.
12. **Las descripciones de nivel difieren por ciclo.** Básica (4°/6°) y media (II
    medio) tienen textos distintos en varias subdimensiones (no solo de detalle:
    p.ej. Expresión de opiniones y Representación democrática tienen redacciones
    sustancialmente diferentes en media). Regla: el motor debe seleccionar la
    descripción de nivel **según el grado/ciclo del dato mostrado**, jamás asumir
    una descripción única. Esto se cruza con el join `niveles`↔`rbd` por
    `rbd×agno` (aprendizaje v02-6), que ya trae el grado.
13. **Inconsistencia de nombres entre documentos oficiales.** Una misma
    subdimensión puede aparecer con nombres distintos entre el Marco y el
    documento de niveles, e incluso dentro del propio Marco (tabla 14 vs 16).
    Regla: emparejar subdimensiones por nombre **normalizado** (sin tildes,
    minúsculas) y mantener un registro de variantes, nunca por string exacto
    (refuerza el patrón de normalización de familias del aprendizaje v02-7).
14. **"Marco 2025 v3" ≠ versión nueva.** El nombre de archivo sugiere una edición
    posterior, pero el contenido es la edición oct 2024. Regla: cotejar contenido,
    no confiar en el nombre del archivo, antes de tratar un documento como fuente
    más reciente.

## 8. Decisiones de diseño

8. **Corpus dual con fuente única (JSON canónico + MD derivado).** Alternativas:
   (a) solo MD narrativo; (b) dual con dos archivos mantenidos en paralelo; (c)
   dual derivado de fuente única. Decisión: (c). Justificación: la UI necesita la
   jerarquía como dato consultable (P9: definiciones accesibles por subdimensión)
   y derivar el MD por script evita que prosa y dato divergan. Costo marginal bajo
   porque la estructura ya estaba en las tablas del Marco.
9. **Alcance limitado a los 4 indicadores de cuestionario.** Alternativas: 4 vs 8
   indicadores. Decisión: 4. Justificación: son los que el motor segmenta por GSE
   por subdimensión; los 4 administrativos son escalares (puntaje 0–100), sin
   subdimensión ni cuestionario, y el motor no puede tratarlos igual. El corpus no
   debe forzar simetría entre ambos grupos.
10. **Niveles guardados por ciclo, no colapsados.** Alternativa: una sola
    descripción por nivel (asumiendo equivalencia básica/media). Decisión:
    separar por ciclo. Justificación: difieren en el contenido real; colapsar
    perdería información y mostraría texto incorrecto para uno de los ciclos.

## 9. Constantes y parámetros vigentes

(Sin cambios respecto a v02 en lo técnico; esta sesión no tocó código. Se
mantienen las constantes de `10_configuracion.R`, `31_depurar_directorio_oficial.R`
y `32_censo_insumos.R` declaradas en v02 §9.)

Nuevo del corpus (no son constantes de código R, son estructura del insumo):
| Elemento | Valor | Archivo | Nota |
|---|---|---|---|
| Indicadores cubiertos | 4 (de cuestionario) | `idps_corpus_conceptual.json` | Excluye 4 administrativos |
| Dimensiones | 11 | idem | |
| Subdimensiones | 30 (22 con niveles EST, 8 sin) | idem | |
| Ciclos de niveles | `basica` (4°/6°), `media` (II medio) | idem | Difieren entre sí |

## 10. Arquitectura de archivos

El escáner NO se re-corrió esta sesión (de documentación). Último escáner
referenciado sigue siendo el de v02 (`2026-06-11 21:50`, más el snapshot
`20260611_221548` que aparece en el árbol adjunto a la apertura). Pendiente
crítico para la próxima sesión técnica: **re-correr el escáner**, que sigue sin
reflejar (a) el censo de v02 y (b) los archivos nuevos del corpus en
`20_insumos/auxiliares/referencias_idps/`. Estructura conforme a la política
(Rama A). Nota de gobernanza menor: el directorio `referencias_idps/` ahora mezcla
insumos crudos (PDF de la Agencia) con artefactos derivados versionables (corpus
JSON/MD); no es problema mientras se documente que el `.md` se deriva del `.json`
vía `generar_md.py`.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P10-bis — Decidir versionado de los scripts de generación del corpus**
  (`generar_md.py`, `inyectar_niveles.py`). Tipo: decisión / deuda técnica menor.
  Impacto: bajo. Contexto: el `.md` se deriva del `.json` por estos scripts; si no
  se versionan, el `.md` no es reproducible desde el repo. Enfoque: versionarlos
  junto al corpus, o documentar en el README del insumo que el `.md` es derivado.
  Recomendación: versionarlos. Criterio: scripts en el repo o derivación
  documentada.
- **P10-ter — Poblar niveles si aparecen ediciones futuras o el documento se
  actualiza.** Tipo: mantención de contenido. Impacto: bajo. El esquema ya soporta
  la actualización: editar el JSON y re-correr `generar_md.py`.
- **P5-bis — Versionar el censo (si no se hizo al cierre de v02).** Tipo: deuda
  técnica. Impacto: bajo. Enfoque: `git add` de `32_censo_insumos.R` y las dos
  salidas en `40_salidas/intermedios/`, commit, push; re-correr el escáner.
  Primera acción de la próxima sesión técnica.
- **P3 — Homologar `10_utils/10_utils.R` con el madre.** Tipo: bloqueante para
  agregación. Impacto: alto. Complejidad: media. Traer `instalar_si_falta()`,
  `log_msg()` y `agregar_ponderado()` validados de `slep_simce_adecuado`.
- **P4 — Resolver ponderación territorial.** Tipo: bloqueante / decisión.
  Impacto: alto. Complejidad: media. Ninguna familia trae `nalu`; dos fuentes
  candidatas (`nalu` del madre por RBD×grado×año, o `MATRICULA` del directorio
  depurado). Evaluar cobertura de cada fuente contra el censo.
- **P6 — Pipeline de datos.** Tipo: funcionalidad. Impacto/Complejidad: alta.
  Lectura 3 familias → normalización → **join `niveles`↔`rbd` por `rbd×agno` para
  traer GSE/dependencia (restricción v02-6)** → catálogos del madre → agregación
  ponderada por indicador/dimensión × GSE × territorio × grado × año.
- **P7 — Vista de distribución Alto/Medio/Bajo** (apilado por subdimensión).
  Depende del join de P6. **Nuevo contexto de v03:** la descripción textual de
  cada nivel ya existe en el corpus, por ciclo; la vista debe seleccionar la
  descripción según el grado mostrado (aprendizaje v03-12).
- **P8 — Drill-down por indicador** (radar secundario). Tipo: mejora visual.
- **P9 — Implementar la interfaz definitiva** a partir del mockup de Claude
  Design. Depende de P6 y del retorno de Design. **Nuevo contexto de v03:** el
  corpus alimenta directamente las "definiciones accesibles por subdimensión" y la
  sección metodológica; consumir el `.json`, no reparsear prosa.
- **P-meta — Sección metodológica del motor.** Tipo: contenido / diseño. Encaja
  junto a P9 (con el mockup en mano), usando el corpus como fuente. Diferida
  deliberadamente para no escribir texto que la estructura real de la UI obligue a
  reacomodar.

### Evaluación de deuda técnica

Zonas frágiles: ninguna en código ejecutable (esta sesión no tocó código). El
prototipo sigue usando promedio simple (no migrar al motor sin resolver P4).
Oportunidad nueva: el corpus deja la jerarquía y los niveles como dato
estructurado reutilizable; P9 debe consumirlo en vez de hardcodear definiciones.

### Auditoría de cierre (POLÍTICA 5.6)

- ¿Datos crudos aislados e inmutables? → Sí; los PDF fuente quedan como insumo
  read-only; el corpus es derivado por código documentado.
- ¿Pipeline corre de cero sin intervención manual? → No aplica aún (sin pipeline;
  sesión de documentación).
- ¿Cada transformación crítica tiene check de validación? → Sí en lo de esta
  sesión: el emparejamiento de niveles se validó (22 EST con niveles, 8 no-EST sin
  niveles, 0 inconsistencias); conteos de estructura verificados por script.
- ¿Outputs reproducibles e idempotentes? → Sí: el `.md` se regenera
  deterministamente del `.json` vía `generar_md.py`; la inyección de niveles es
  determinista. (Sujeto a P10-bis: versionar los scripts para reproducibilidad
  desde el repo.)
- ¿Decisiones metodológicas como constantes nombradas? → No aplica a contenido;
  las decisiones (alcance, ciclos, variantes) quedan declaradas en `_meta` del
  JSON.
- ¿Nombres sin tildes/ñ/espacios? → El corpus (`idps_corpus_conceptual.json/.md`)
  cumple. Los PDF fuente conservan nombres con tildes/+ heredados de la Agencia
  (excepción declarada §1.2.4 de la política); ya estaban renombrados a snake_case
  en el árbol (`otros_indicadores_calidad_2019.pdf`,
  `marco_evaluacion_idps_2025.pdf`).

### Ruta sugerida para la próxima sesión

La próxima sesión natural es **TÉCNICA** (implementación). Orden sugerido:
1. Re-correr el escáner (refleja censo de v02 + corpus de v03). 🔧
2. P5-bis (versionar censo si quedó pendiente).
3. P3 + P4 (utils + ponderación, evaluando las dos fuentes de `nalu` contra el
   censo).
4. P6 (pipeline con el join `niveles`↔`rbd`).
Diferir P7/P8/P9 hasta que P6 produzca Parquet. P10-bis (versionar scripts del
corpus) puede resolverse al inicio de cualquier sesión, es trivial.

## 12. Instrucciones específicas para la próxima sesión

- ✅ ANTES de construir cualquier vista de niveles (P7), seleccionar la
  descripción de nivel **según el grado/ciclo** del dato mostrado: básica (4°/6°)
  y media (II medio) tienen textos distintos (aprendizaje v03-12). No asumir
  descripción única.
- ✅ ANTES de mostrar niveles de una subdimensión, verificar que sea de actor EST:
  las subdimensiones DOC/PAD no tienen niveles por diseño (aprendizaje v03-11). No
  tratar su ausencia como dato faltante.
- ✅ ANTES de emparejar subdimensiones entre el corpus y los datos, normalizar
  nombres (sin tildes, minúsculas) y consultar `_meta.variantes_nombre`; hay
  inconsistencias de nombre entre documentos oficiales (aprendizaje v03-13).
- ✅ ANTES de tratar el corpus `.md` como fuente, recordar que es **derivado** del
  `.json` vía `generar_md.py`: editar el JSON, no el MD.
- ✅ ANTES de construir el motor, re-correr el escáner (sigue sin reflejar el censo
  de v02 ni el corpus de v03).
- 🔒 El corpus cubre solo los 4 indicadores de cuestionario; los 4 administrativos
  (Asistencia, Retención, Equidad de género, Titulación TP) son escalares sin
  subdimensión: el motor no debe tratarlos con la misma estructura jerárquica.
- 🔒 GSE inviolable: la segmentación aparece en todo output, jamás colapsada.
- 🔒 No mezclar indicadores, dimensiones, grados ni años en una misma cifra
  agregada.
- 🔒 No publicar ninguna cifra agregada territorial sin resolver P4 (ponderación):
  el promedio simple del prototipo es placeholder, no método.
- 🔒 El directorio original `directorio_oficial_ee.csv` (con RUT) NO se versiona
  jamás; solo el depurado `_publico.csv`.
- 🔒 `NOM_RBD` y `Nombre del establecimiento` son insumos internos de join:
  PROHIBIDO filtrarlos a cualquier output publicado.
- 🔒 Si entra una base por estudiante → Rama B sin excepción (limpiar historial Git).

## 13. Fragmentos de código de referencia

Regenerar el corpus `.md` tras editar el `.json` (la forma correcta; el `.md`
nunca se edita a mano):

```bash
# desde 20_insumos/auxiliares/referencias_idps/ (o donde vivan los scripts)
python3 inyectar_niveles.py   # solo si cambian las descripciones de niveles
python3 generar_md.py          # siempre, para reconstruir el .md desde el .json
```

Patrón de selección de descripción de nivel por ciclo (referencia conceptual para
P7; el motor es JS/D3, esto ilustra la lógica):

```r
# grado del dato -> ciclo del corpus
ciclo <- dplyr::if_else(grado %in% c("4b", "6b"), "basica", "media")
# luego: corpus$...$descripcion_niveles_subdimension[[ciclo]][[nivel]]
# subdimensiones DOC/PAD: descripcion_niveles_subdimension es null (no mostrar niveles).
```

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 4 — implementación pipeline (Opus 4.8)`
- **Mensaje de apertura pre-armado:** Tipo CONTINUATION, sesión TÉCNICA de
  implementación. El protocolo (política + settings) vive en la knowledge base del
  Project y en `50_documentacion/activa/`; léelo desde ahí. Adjunto el traspaso
  v03, el escáner re-corrido, `10_utils.R` del madre y el `censo_insumos.parquet`.
  Ruta sugerida: re-correr escáner → P5-bis → P3+P4 → P6.
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar que estén al día):*
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` (la sesión técnica correrá en Claude
     Code); el corpus `idps_corpus_conceptual.json` si se aborda P7/P9 (no es
     necesario para P3/P4/P6).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v03.md`; el
     escáner `estructura_actual.md` **re-corrido** (debe reflejar censo de v02 +
     corpus de v03); `10_utils.R` del madre (P3); `censo_insumos.parquet` (P6).
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la
  versión más actualizada al abrir y avisarlo. Re-correr el escáner ANTES de abrir
  la sesión técnica es la precondición más importante: sigue desactualizado desde
  v02.
