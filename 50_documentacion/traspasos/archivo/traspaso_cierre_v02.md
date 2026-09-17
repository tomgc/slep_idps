# traspaso_cierre_v02.md — slep_idps

## 1. Identificación

- **Proyecto:** `slep_idps` — Motor interactivo de comparación de Indicadores de
  Desarrollo Personal y Social (IDPS) por territorio y GSE, SLEP Costa Central y
  todo Chile. React 18 + D3 v7, HTML autocontenido en GitHub Pages. Hermano de
  `slep_simce_adecuado`.
- **Versión:** v02
- **Fecha:** 2026-06-11
- **Sesión:** 2. Foco: limpieza de repo (P1+P2), gobernanza del directorio
  oficial, censo exhaustivo de insumos (P5) y prompt de diseño de interfaz para
  Claude Design.
- **Entorno:** Terminal local (zsh, macOS aarch64) para git y ejecución de R;
  interfaz web para análisis, diseño del censo y del prompt.
- **Repo:** `https://github.com/tomgc/slep_idps` (privado).
- **Archivos principales creados/modificados esta sesión:**
  `30_procesamiento/31_depurar_directorio_oficial.R` (nuevo),
  `30_procesamiento/32_censo_insumos.R` (nuevo),
  `40_salidas/intermedios/censo_insumos.{parquet,md}` (nuevos),
  `20_insumos/auxiliares/directorio_oficial_ee_publico.csv` (nuevo, depurado),
  `.gitignore` (modificado), prototipo `.jsx` reubicado.

## 2. Resumen ejecutivo

Segunda sesión, de tipo CONTINUATION. Se ejecutó la ruta de limpieza acordada:
P1 (desrastrear `.DS_Store`) resultó no-op porque ya no estaban trackeados, y P2
(reubicar el prototipo de radar a `50_documentacion/activa/prototipos/`) se cerró
con `git mv`. Apareció en el árbol un conjunto de 5 insumos auxiliares nuevos que
el usuario había agregado para fases posteriores; el chequeo de gobernanza
obligatorio detectó que `directorio_oficial_ee.csv` (directorio oficial Mineduc,
58 columnas) trae `MRUN` (vacío) y `RUT_SOSTENEDOR` (RUT de persona natural en
sostenedores privados). Se resolvió generando una versión depurada de 56 columnas
vía script versionado (`31_depurar_directorio_oficial.R`), ignorando el original
en `.gitignore` y versionando solo el depurado. Todo se commiteó en 5 commits
temáticos atómicos y se hizo push. Luego se ejecutó P5 (censo exhaustivo): se
perfilaron las 25 tablas de datos IDPS, se validó el parseo de nombres contra el
contenido (todos coherentes) y se produjo el mapa de cobertura grado×año×familia
más un Parquet de perfilado reutilizable. Hallazgo central de diseño: la familia
`niveles` NO trae `cod_grupo` ni `cod_depe2`, por lo que en P6 deberá unirse con
`rbd` por `rbd×agno` para poder segmentar por GSE (inviolable). Finalmente se
construyó el prompt de diseño de interfaz para Claude Design, alimentado por el
Marco de Evaluación oficial (definiciones de los 4 indicadores y 11 dimensiones)
y por la estética del motor madre. Quedan pendientes P3+P4 (utils + ponderación)
y P6 (pipeline), que son el núcleo de la próxima sesión técnica. La próxima
sesión que pidió el usuario es de exploración de documentación, no técnica.

## 3. Estado al cierre

**Qué funciona:**
- Repo limpio y ordenado: prototipo reubicado, `.DS_Store` fuera del árbol
  versionado, directorio sensible ignorado, directorio depurado versionado.
- `31_depurar_directorio_oficial.R` corre y valida (58 → 56 columnas, último run
  2026-06-11). Escritura atómica y check de gobernanza post-depuración.
- `32_censo_insumos.R` corre y produce `censo_insumos.parquet` y `.md` con el
  mapa de cobertura. Las 25 tablas perfiladas, `anio_coherente` = TRUE en todas.
- 5 commits temáticos de limpieza/insumos empujados a `origin/main`
  (`0bdfce9..b855f07`).

**Qué no funciona / no existe aún:**
- Pipeline de datos (P6): `00_build.R` sigue siendo stub. No hay lectura,
  normalización ni agregación reales.
- `10_utils.R`: sin `agregar_ponderado()` (P3 pendiente).
- Ponderación territorial (P4) sin resolver: no hay ninguna cifra agregada
  publicable todavía.
- **El censo (P5) puede no estar versionado al cierre** (ver pendiente P5-bis):
  si el usuario no corrió el commit final del censo, queda como primera acción
  de la próxima sesión técnica.

**Delta respecto a v01:** repo limpiado y con gobernanza del directorio resuelta;
mapa de cobertura grado×año×familia documentado con dato real; restricción de
join niveles↔rbd descubierta; prompt de diseño listo para Claude Design.

## 4. Registro detallado de cambios

7. **P1 — Desrastrear `.DS_Store`:** no-op. Los tres `.DS_Store` ya no estaban
   trackeados (el `.gitignore` los cubre desde v01, línea 19). Sin acción.
8. **P2 — Reubicar prototipo:** `git mv 30_procesamiento/idps_radar_prototipo.jsx`
   `→ 50_documentacion/activa/prototipos/`. El prototipo deja de aparentar ser un
   paso del pipeline; queda como referencia de diseño versionada (decisión B
   sobre archivar, ver sección 8). Commit atómico propio.
9. **Chequeo de gobernanza de 5 insumos auxiliares nuevos**
   (`202602_Listado_SLEP_2026_vf.xlsx`, `caracterizacion_establecimientos.xlsx`,
   `diccionario_territorios.xlsx`, `directorio_oficial_ee.csv`,
   `glosas_directorio_oficial_ee.pdf`). Inspección de cabeceras: los xlsx solo
   traen nombres de territorio/establecimiento (no de personas). El CSV
   directorio oficial trae `MRUN` y `RUT_SOSTENEDOR`. Decisión: depurar el CSV
   (opción A), no bajar el proyecto a Rama B (no hay datos de estudiantes).
10. **`31_depurar_directorio_oficial.R`:** lee el directorio original (latin1,
    delim `;`, 58 cols), elimina `MRUN` y `RUT_SOSTENEDOR`, valida que no
    sobrevivan columnas sensibles (stop si fallan), escribe
    `directorio_oficial_ee_publico.csv` (UTF-8, delim `;`) con escritura atómica.
    Constante `COLUMNAS_SENSIBLES`. Resultado: 56 columnas.
11. **`.gitignore`:** se agregó `20_insumos/auxiliares/directorio_oficial_ee.csv`
    (el original con RUT no se versiona nunca). Commit propio.
12. **Commit de insumos auxiliares + script de depuración:** los 4 xlsx/pdf
    limpios + el CSV depurado + `31_depurar_directorio_oficial.R`. `NOM_RBD` y
    `Nombre del establecimiento` se conservan como insumo interno de join
    (legítimo; prohibido filtrarlos a outputs publicados).
13. **Commit de snapshot del escáner** (poda retención 2) y push de los 5 commits.
14. **`32_censo_insumos.R` (P5):** censo exhaustivo de las 25 tablas de datos.
    Deriva (grado, año, familia, estado) del nombre vía regex
    `^idps(2m|4b|6b|8b)(\d{4})_(.+)_(final|preliminar)$`; normaliza la familia de
    niveles (variantes `niveles`/`rbd_niveles`/`rbd_subdim_niveles` → `niveles`);
    lee cada archivo completo; valida nombre vs contenido (`agno`/`grado` reales);
    reporta n filas, % NA en la medida (supresión), presencia de
    `cod_grupo`/`cod_depe2`; arma mapa de cobertura. Salidas: Parquet + `.md`.
15. **Prompt de diseño para Claude Design:** construido a partir del Marco de
    Evaluación oficial (Agencia de Calidad, oct 2024) y la estética del motor
    madre. Incluye: alcance nacional navegable, dos modos temporales (reciente +
    serie histórica), definiciones conceptuales de los 4 indicadores y 11
    dimensiones como pieza central de interpretación, spider chart como héroe +
    líneas por indicador/dimensión para la serie, paleta y mark colors del madre.

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

### Clasificación temática (refinada en v02)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 3 | 20% | Estructura canónica, stubs, git, repo remoto |
| Gobernanza de datos | 4 | 27% | Verificación sensibilidad, decisión, depuración directorio, ignore |
| Visualización / diseño | 3 | 20% | Prototipo radar, reubicación, prompt de diseño Claude Design |
| Perfilado / exploración de datos | 2 | 13% | Censo exhaustivo, mapa de cobertura grado×año×familia |
| Limpieza / deuda técnica | 3 | 20% | P1 (no-op), P2 reubicación, commits atómicos |

(15 cambios acumulados a v02. Taxonomía se refinará cuando arranque el pipeline
y aparezcan categorías de lectura/normalización/agregación/motor.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| **Total** | | **15** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver sección 4). Cambio 9 resuelve la
  precaución de gobernanza del backlog (chequeo antes de versionar insumos).

### Delta del backlog

9 entradas nuevas (7–15). Refinamiento de taxonomía: se subdividió la categoría
original "Gobernanza" (creció a 27%) y se agregaron "Perfilado / exploración de
datos" y "Limpieza / deuda técnica" como categorías propias.

## 6. Bugs de la sesión

No aplica en esta sesión: no se reportaron bugs. El único tropiezo fue zsh
interpretando `#` como comando (no es bug del proyecto); se ignoró.

## 7. Aprendizajes y restricciones descubiertas

6. **La familia `niveles` no trae `cod_grupo` ni `cod_depe2`.** Contexto: las 7
   tablas de niveles solo tienen llaves (rbd, indicador, dimensión, subdimensión)
   + porcentajes Bajo/Medio/Alto. Para segmentar la distribución por GSE (🔒
   inviolable) o por dependencia, hay que unir `niveles` con `rbd` por `rbd×agno`
   (y grado), trayendo `cod_grupo`/`cod_depe2` desde `rbd`. Regla: en P6, ninguna
   vista de distribución se construye sin ese join previo. (C.6, integridad de
   llaves.)
7. **El nombre de la familia de niveles cambia por año.** `2023→*_niveles`,
   `2024→*_rbd_niveles`, `2025→*_rbd_subdim_niveles`. Regla: normalizar a la
   familia lógica `niveles` por detección de substring, jamás por nombre exacto.
8. **Supresión fuerte en niveles de básica.** % NA en la medida: 4b/6b ~26–28%,
   8b ~13%, 2m ~1.5%. En `rbd`/`rbd_dim`: 4b/6b ~7–9%, 2m ~0.3%. Regla:
   documentar la supresión en cualquier vista de básica; tratar NA como faltante,
   nunca cero (refuerza aprendizaje v01-4). (C.8.)
9. **Cobertura temporal asimétrica por grado.** Solo 2m tiene serie larga
   (2022–2025). 4b: 2022/2023/2025 (sin 2024). 6b: solo 2024. 8b: solo 2025.
   Regla: el motor debe deshabilitar la vista de tendencia donde hay un solo año,
   sin romperse; marcar 2025 preliminar y los huecos explícitamente.
10. **El directorio oficial Mineduc trae RUT de sostenedor.** Una fuente pública
    puede traer columnas personales adosadas (`MRUN`, `RUT_SOSTENEDOR`). Regla:
    chequear cabeceras SIEMPRE antes de versionar; depurar columnas personales
    vía script versionado (no a mano), ignorar el original, versionar el depurado.
    No baja a Rama B si no hay datos de estudiantes. (Gobernanza, POLÍTICA §6.)

## 8. Decisiones de diseño

4. **Prototipo `.jsx` a `50_documentacion/activa/prototipos/` (no a `_archivo/`).**
   Alternativas: archivar (congelar fuera de Git) vs. versionar como referencia
   viva. Decisión: versionar. Justificación: el radar es la decisión de diseño
   central del motor, conviene tenerlo consultable hasta que P6 lo integre.
5. **Depurar el directorio (no excluirlo entero).** Alternativas: no versionar el
   CSV (tratarlo como insumo externo) vs. versionar versión depurada.
   Decisión: depurar y versionar. Justificación: el directorio sin RUT es público
   y reutilizable (catálogo territorio/dependencia/matrícula por RBD); da
   reproducibilidad sin exponer datos personales.
6. **Censo exhaustivo (no muestreo).** Alternativas: leer un representante por
   familia vs. perfilar las 25 tablas completas. Decisión: exhaustivo.
   Justificación: el % de supresión real y el rango de `agno` por archivo son
   justo lo que P5 existe para producir; el muestreo los omite. Evita repetir el
   diagnóstico parcial de v01 que ocultó la serie temporal.
7. **Prompt de diseño anclado en el radar existente (no exploración abierta).**
   Justificación: el radar fue validado con el usuario final en sesión 1 y la
   estética viene del madre; explorar desde cero arriesga descartar decisiones
   tomadas. El prompt incluye las definiciones conceptuales del Marco de
   Evaluación como pieza central de interpretación.

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `COLUMNAS_SENSIBLES` | MRUN, RUT_SOSTENEDOR | `31_depurar_directorio_oficial.R` | Eliminadas del directorio |
| `PATRON_DATOS` | `^idps(2m\|4b\|6b\|8b)(\d{4})_(.+)_(final\|preliminar)$` | `32_censo_insumos.R` | Parseo de nombre validado contra contenido |
| `LLAVES_SEGMENTACION` | cod_grupo, cod_depe2, id_indicador, id_dimension, id_subdimension, agno, grado, rbd | `32_censo_insumos.R` | Verificación de presencia |
| `COMUNAS_SLEP_CC` | Viña del Mar, Concón, Quintero, Puchuncaví | `10_configuracion.R` | Homologar mayúsculas/sin tildes |
| `COD_REGION_REFERENCIA` | 5 | `10_configuracion.R` | Valparaíso |
| `DEPENDENCIAS` | 1 Mun / 2 PS / 3 PP / 4 SLEP | `10_configuracion.R` | 4 categorías |
| `GSE_LABELS` | 1 Bajo … 5 Alto | `10_configuracion.R` | Segmentación inviolable |
| `INDICADOR_DIMENSIONES` | 1→[11,12]; 2→[21,22,23]; 3→[31,32,33]; 4→[41,42,43] | `10_configuracion.R` | 11 dimensiones |
| Ponderación | PROMEDIO_SIMPLE_PROVISIONAL | prototipo | Placeholder, pendiente P4 |

## 10. Arquitectura de archivos

Último escáner referenciado: `2026-06-11 21:50` (14 carpetas, 76 archivos). El
censo `32_censo_insumos.R` y sus salidas en `40_salidas/intermedios/` se crearon
DESPUÉS de ese escáner: re-correr el escáner al abrir la próxima sesión técnica
para reflejarlos. Estructura conforme a la política (Rama A). El prototipo `.jsx`
quedó en `50_documentacion/activa/prototipos/`. El original
`directorio_oficial_ee.csv` existe en disco pero está ignorado por Git.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P5-bis — Versionar el censo (si no se hizo al cierre).** Tipo: deuda técnica.
  Impacto: bajo. Enfoque: `git add` de `32_censo_insumos.R` y las dos salidas en
  `40_salidas/intermedios/`, commit, push; re-correr el escáner. Criterio:
  censo en `origin/main` y reflejado en el escáner.
- **P3 — Homologar `10_utils/10_utils.R` con el madre.** Tipo: bloqueante para
  agregación. Impacto: alto. Complejidad: media. Enfoque: traer
  `instalar_si_falta()`, `log_msg()` y `agregar_ponderado()` validados de
  `slep_simce_adecuado`. Criterio: `agregar_ponderado()` disponible y testeado.
- **P4 — Resolver ponderación territorial.** Tipo: bloqueante / decisión.
  Impacto: alto (toda cifra agregada publicable). Complejidad: media. Contexto
  nuevo de P5: ninguna familia trae `nalu`. Dos fuentes candidatas de
  ponderación: (a) `nalu` validado del proyecto madre unido por RBD×grado×año;
  (b) `MATRICULA`/`MAT_TOTAL` del directorio depurado que se versionó esta sesión.
  Recomendación: evaluar primero la cobertura de cada fuente contra el censo.
  Criterio: agregados territoriales reproducen un spot-check contra reagregación
  RBD.
- **P6 — Pipeline de datos.** Tipo: funcionalidad. Impacto: alto. Complejidad:
  alta. Enfoque: lectura 3 familias → normalización (homologar nombres de familia
  de niveles, `cod_depe2`, resolver ponderación) → **join niveles↔rbd por rbd×agno
  para traer GSE/dependencia (restricción nueva, aprendizaje v02-6)** → catálogos
  del madre → tablas intermedias → agregación ponderada por indicador/dimensión ×
  GSE × territorio × grado × año. Criterio: Parquet intermedios generados y
  validados.
- **P7 — Vista de distribución Alto/Medio/Bajo** (apilado por subdimensión).
  Tipo: funcionalidad / diseño. Depende del join de P6. Criterio: barras apiladas
  segmentadas por GSE funcionando.
- **P8 — Drill-down por indicador** (radar secundario). Tipo: mejora visual.
- **P9 — Implementar la interfaz definitiva** a partir del mockup que devuelva
  Claude Design (prompt entregado en sesión 2). Tipo: funcionalidad / diseño.
  Impacto: alto. Depende de P6 (datos reales) y del retorno de Design. Criterio:
  motor HTML con radar héroe, líneas de serie, GSE inviolable, definiciones
  accesibles, marcas de preliminar y sin dato.
- **P10 — Integrar documentación conceptual complementaria.** Tipo: contenido.
  Contexto: el usuario tiene más documentación (descripciones de niveles de
  desarrollo por subdimensión, usos en Categoría de Desempeño) para complementar
  las definiciones. Es el foco declarado de la PRÓXIMA sesión (exploración de
  documentación, no técnica). Criterio: corpus conceptual organizado y listo para
  alimentar la UI y la sección metodológica.

### Evaluación de deuda técnica

Zonas frágiles: ninguna en código ejecutable (los dos scripts nuevos corren y
validan). El prototipo sigue usando promedio simple, que NO debe migrar al motor
real sin resolver P4. Oportunidad: el censo dejó un Parquet de perfilado
reutilizable; P6 debe leerlo en vez de re-perfilar.

### Auditoría de cierre (POLÍTICA 5.6)

- ¿Datos crudos aislados e inmutables? → Sí; el directorio original con RUT quedó
  ignorado, el depurado es derivado por código.
- ¿Pipeline corre de cero sin intervención manual? → No aplica aún (sin pipeline).
- ¿Cada transformación crítica tiene check de validación? → Parcial:
  `31_depurar` valida post-depuración; `32_censo` valida nombre vs contenido. P6
  pendiente.
- ¿Outputs reproducibles e idempotentes? → `31_depurar` sí (escritura atómica);
  `32_censo` sí (lectura → Parquet determinista).
- ¿Decisiones metodológicas como constantes nombradas? → Sí
  (`COLUMNAS_SENSIBLES`, `PATRON_DATOS`, `LLAVES_SEGMENTACION`). Ponderación sigue
  pendiente como constante por definir (P4).
- ¿Nombres sin tildes/ñ/espacios? → Parcial: insumos heredados de la Agencia
  conservan tildes y `+` (excepción declarada §1.2.4). Código y documentación
  cumplen. Nota: `idps2m2023_GLOSAS_rbd_público_final.xlsx` conserva `ú` (insumo
  heredado, excepción).

### Ruta sugerida para la próxima sesión

La próxima sesión que pidió el usuario es de **exploración de documentación**
(P10), no técnica. No requiere los scripts ni el pipeline. Sugerencia para ESA
sesión: organizar el corpus conceptual (Marco de Evaluación + documentación
complementaria que aporte el usuario) en un insumo estructurado que alimente
después la UI y la sección metodológica del motor.

Para la próxima sesión TÉCNICA (posterior): P5-bis (versionar censo) → P3+P4
(utils + ponderación, evaluando las dos fuentes de `nalu`) → P6 (pipeline con el
join niveles↔rbd). Diferir P7/P8/P9 hasta que P6 produzca Parquet.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ NO publicar ninguna cifra agregada territorial sin resolver P4
  (ponderación): el promedio simple del prototipo es placeholder, no método.
- ✅ ANTES de construir cualquier vista de distribución (niveles), unir `niveles`
  con `rbd` por `rbd×agno` para traer `cod_grupo` y `cod_depe2` (aprendizaje
  v02-6). La familia `niveles` no es segmentable por sí sola.
- ✅ ANTES de versionar nuevos insumos en `20_insumos/`, re-ejecutar el chequeo de
  gobernanza de cabeceras (sin columnas sensibles).
- ✅ ANTES de construir el motor, re-correr el escáner (el censo quedó fuera del
  último snapshot).
- 🔒 GSE inviolable: la segmentación aparece en todo output, jamás colapsada.
- 🔒 No mezclar indicadores, dimensiones, grados ni años en una misma cifra
  agregada.
- 🔒 El directorio original `directorio_oficial_ee.csv` (con RUT) NO se versiona
  jamás; solo el depurado `_publico.csv`.
- 🔒 `NOM_RBD` y `Nombre del establecimiento` son insumos internos de join:
  PROHIBIDO filtrarlos a cualquier output publicado.
- 🔒 Si entra una base por estudiante → Rama B sin excepción (limpiar historial Git).

## 13. Fragmentos de código de referencia

Chequeo de gobernanza de cabeceras (re-ejecutar antes de versionar nuevos
insumos; no se versiona):

```r
# verificar_gobernanza_insumos.R — chequeo unico
suppressMessages({library(readxl)})
patron <- "rut|run|nombre|mrun|cod_alumno|correo|email|mail|telefono|director|sostenedor|representante|contacto"
archivos <- fs::dir_ls(here::here("20_insumos"), glob = "*.xlsx", recurse = TRUE)
for (f in archivos) {
  cols <- tryCatch(names(readxl::read_excel(f, n_max = 0)), error = function(e) character(0))
  sosp <- cols[grepl(patron, cols, ignore.case = TRUE)]
  cat(basename(f), "→", if (length(sosp)) paste(sosp, collapse = ", ") else "limpio", "\n")
}
```

Patrón de join niveles↔rbd para segmentar por GSE (referencia para P6):

```r
# niveles no trae cod_grupo/cod_depe2: traerlos desde rbd por rbd x agno.
# Llaves como character (C.6). Validar conteo pre/post join.
niveles_segmentado <- niveles |>
  dplyr::left_join(
    dplyr::distinct(rbd, rbd, agno, cod_grupo, cod_depe2),
    by = c("rbd", "agno")
  )
stopifnot(nrow(niveles_segmentado) == nrow(niveles))  # join no debe duplicar
```

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 3 — exploración documentación (Opus 4.8)`
- **Mensaje de apertura pre-armado:** Tipo CONTINUATION, foco en exploración de
  documentación conceptual (P10), no técnica. El protocolo (política + settings)
  vive en la knowledge base del Project y en `50_documentacion/activa/`; léelo
  desde ahí. Adjunto el traspaso v02 y traeré documentación conceptual de los IDPS
  para revisar.
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar que estén al día):*
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* para la sesión de documentación, el Marco de
     Evaluación de los IDPS (Agencia de Calidad, oct 2024) ya revisado, más la
     documentación complementaria que el usuario aporte (descripciones de niveles
     de desarrollo por subdimensión, usos en Categoría de Desempeño).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v02.md`. El
     escáner y los xlsx no son necesarios para una sesión de documentación; se
     adjuntan en la próxima sesión técnica.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la
  versión más actualizada al abrir y avisarlo. Para la próxima sesión TÉCNICA
  (posterior a la de documentación), adjuntar además el escáner re-corrido,
  `10_utils.R` del madre (P3) y el `censo_insumos.parquet` (P6).
