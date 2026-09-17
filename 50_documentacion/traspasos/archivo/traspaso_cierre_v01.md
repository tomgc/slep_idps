# traspaso_cierre_v01.md — slep_idps

## 1. Identificación

- **Proyecto:** `slep_idps` — Motor interactivo de comparación de Indicadores de
  Desarrollo Personal y Social (IDPS) por territorio y GSE, SLEP Costa Central y
  todo Chile. React 18 + D3 v7, HTML autocontenido en GitHub Pages. Hermano de
  `slep_simce_adecuado`.
- **Versión:** v01
- **Fecha:** 2026-06-11
- **Sesión:** 1. Foco: arranque del proyecto (Paso 0 completo) y prototipado de
  la visualización principal (radar de desarrollo integral).
- **Entorno:** Sesión de diseño en interfaz web (prototipo) + Claude Code (zsh,
  macOS aarch64) para scaffold, git y escaneo.
- **Repo:** `https://github.com/tomgc/slep_idps` (privado).
- **Archivos principales creados:** estructura canónica completa, stubs
  (`00_build.R`, `00_escanear_proyecto.R`, `10_utils/10_utils.R`,
  `10_utils/10_configuracion.R`), `30_procesamiento/idps_radar_prototipo.jsx`
  (prototipo), `50_documentacion/activa/decisiones/20260611_decision_gobernanza_insumos_publicos.md`.

## 2. Resumen ejecutivo

Primera sesión del proyecto `slep_idps`. Se inspeccionaron las tablas IDPS
(esquema, cobertura, GSE, dependencia) y se prototipó la visualización central:
un radar donde cada arista es una dimensión IDPS y los 4 indicadores confluyen
en un solo polígono ("desarrollo integral"), con comparación territorial
superpuesta y GSE inviolable. El diseño quedó confirmado por el usuario (escala
0–100, 11 dimensiones juntas). Se completó el Paso 0: scaffold canónico Rama A,
git local, repo remoto privado, primer escaneo, descripción del repo. Se
verificó empíricamente que los 34 xlsx son agregados públicos por
establecimiento (ninguna columna sensible) y se documentó la decisión de
gobernanza en `decisiones/`. Quedan como pendientes inmediatos: limpiar
`.DS_Store` versionados, reubicar el prototipo `.jsx`, homologar `10_utils.R`
con el madre, y arrancar el pipeline aprovechando la serie multi-grado/multi-año
que el escaneo reveló disponible.

## 3. Estado al cierre

**Qué funciona:**
- Estructura canónica creada y versionada (escaneo `2026-06-11 20:14`:
  13 carpetas, 68 archivos).
- `00_escanear_proyecto.R` corre correctamente (copia validada del madre).
- Git local + remoto privado `tomgc/slep_idps`, `main` con 3 commits limpios.
- Decisión de gobernanza versionada.
- Prototipo de radar funcional (artifact React validado con `@babel/parser`),
  con datos reales de 4° básico 2025.

**Qué no funciona / no existe aún:**
- Pipeline de datos: `00_build.R` es stub, sin pasos. No hay lectura,
  normalización ni agregación reales todavía.
- `10_utils.R`: bootstrapping mínimo, SIN `agregar_ponderado()` (pendiente
  homologar con el madre).
- El prototipo usa agregación por **promedio simple** (placeholder), no
  ponderada.

**Delta respecto a v00:** proyecto inexistente → Paso 0 completo + prototipo de
diseño confirmado.

## 4. Registro detallado de cambios

1. **Inspección de esquema IDPS** (glosas + xlsx de dimensiones). Se confirmó:
   4 indicadores; indicador 1 con 2 dimensiones, los otros 3 con 3 cada uno;
   `prom` en escala 0–100; GSE 1–5; `cod_depe2` con **4 categorías** (1
   Municipal, 2 Particular subvencionado, 3 Particular pagado, **4 SLEP**),
   corrigiendo el prompt que decía 3.
2. **Prototipo de radar** (`30_procesamiento/idps_radar_prototipo.jsx`):
   React 18 + D3, estética heredada del madre (paleta plum/cream/ocean,
   system-ui), 11 dimensiones en un solo radar coloreadas por indicador,
   comparación de territorios (SLEP CC / Región 5 / País), selector GSE
   inviolable, hover por dimensión, toggle de relleno. Verificado con
   `@babel/parser`.
3. **Scaffold canónico Rama A** (POLÍTICA §8.4): estructura de carpetas, stubs,
   `.gitignore` sin bloque de datos, `.Rproj`, `README.md`, `CLAUDE.md`,
   política y settings copiados a `activa/`, `.gitkeep` en carpetas vacías.
   `00_escanear_proyecto.R` copiado idéntico del madre (solo header adaptado).
4. **Paso 0 ejecutado en Claude Code:** `git init`, primer commit, repo remoto
   privado vía `gh repo create`, push, primer escaneo + commit del snapshot.
5. **Verificación de gobernanza:** chequeo automatizado de cabeceras de los 34
   xlsx buscando columnas sensibles (RUT/RUN/MRUN/nombre/id de alumno).
   Resultado: ninguna columna sensible; 24 tablas a nivel RBD, 10 glosas.
   Clasificación Rama A confirmada.
6. **Decisión de gobernanza** documentada en
   `50_documentacion/activa/decisiones/20260611_decision_gobernanza_insumos_publicos.md`
   y versionada.

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

### Clasificación temática (inicial, a refinar)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 3 | 50% | Estructura canónica, stubs, git, repo remoto |
| Gobernanza de datos | 2 | 33% | Verificación de sensibilidad, decisión documentada |
| Visualización / diseño | 1 | 17% | Prototipo de radar de desarrollo integral |

(Taxonomía orgánica; se refina cuando arranque el pipeline y aparezcan
categorías de lectura/normalización/agregación/motor.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| **Total** | | **6** | | |

### Detalle cronológico

Sesión 1 (2026-06-11): cambios 1–6 (ver sección 4).

### Delta del backlog

Backlog inicial: 6 entradas nuevas, taxonomía propuesta por primera vez.

## 6. Bugs de la sesión

No aplica en esta sesión: no se reportaron bugs (proyecto recién iniciado, sin
pipeline ejecutable todavía).

## 7. Aprendizajes y restricciones descubiertas

1. **`cod_depe2` tiene 4 categorías, la 4 es SLEP** (no 3 como decía el prompt).
   Contexto: si se homologa a 3 categorías se pierde la categoría SLEP, que es
   justamente la de interés. Regla: usar las 4 categorías de las glosas
   oficiales. (C.6, rigor de tipado y catálogos.)
2. **El archivo de dimensiones NO trae `nalu`/matrícula.** Contexto: sin
   variable de ponderación no se puede hacer agregación ponderada territorial
   (POLÍTICA: prohibido promedio simple de porcentajes). Regla: resolver la
   ponderación antes de cualquier cifra agregada publicable (opción recomendada:
   reutilizar `nalu` validado del proyecto madre, unir por RBD×grado×año).
3. **Hay serie temporal y multi-grado disponibles.** El escaneo reveló 4 grados
   (4°, 6°, 8° básico, II medio) y años 2022–2025 (final/preliminar). El
   diagnóstico inicial del prototipo (un solo punto temporal) era parcial por
   mirar un único archivo. Regla: el motor real debe explotar la serie completa;
   marcar 2025 como preliminar y los huecos de cobertura explícitamente.
4. **`prom` con NA por supresión** (4.881 filas en 4° básico). Regla: tratar
   como faltante, nunca como cero, en cualquier agregación. (C.8.)
5. **`.gitignore` no desrastrea lo ya commiteado.** Los `.DS_Store` entraron en
   el primer commit pese a estar en `.gitignore`. Regla: en el scaffold, hacer
   `git rm --cached` de lo que el ignore deba excluir si entró antes.

## 8. Decisiones de diseño

1. **Radar de desarrollo integral como visualización central.** Cada arista =
   una dimensión IDPS; los 4 indicadores confluyen en un polígono, coloreados
   por indicador. Alternativas: un radar por indicador (drill-down). Decisión:
   las 11 dimensiones juntas como vista principal, drill-down por indicador como
   vista secundaria futura. Justificación: comunica el "desarrollo integral"
   pedido por el usuario, que una tabla o barras no logran.
2. **Escala 0–100 completa** (no recortada). Justificación: honestidad de escala
   en producto institucional, por encima de amplificar diferencias.
3. **Arquitectura Rama A** (datos públicos versionados). Ver decisión completa en
   `decisiones/20260611_decision_gobernanza_insumos_publicos.md`.

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `COMUNAS_SLEP_CC` | Viña del Mar, Concón, Quintero, Puchuncaví | `10_configuracion.R` | Homologar mayúsculas/sin tildes al leer |
| `COD_REGION_REFERENCIA` | 5 | `10_configuracion.R` | Valparaíso |
| `DEPENDENCIAS` | 1 Mun / 2 PS / 3 PP / 4 SLEP | `10_configuracion.R` | 4 categorías |
| `GSE_LABELS` | 1 Bajo … 5 Alto | `10_configuracion.R` | Segmentación inviolable |
| `INDICADOR_DIMENSIONES` | 1→[11,12]; 2→[21,22,23]; 3→[31,32,33]; 4→[41,42,43] | `10_configuracion.R` | Layout variable por indicador |
| Ponderación | PROMEDIO_SIMPLE_PROVISIONAL | prototipo | Placeholder, pendiente resolver |

## 10. Arquitectura de archivos

Ver `50_documentacion/estructura/estructura_actual.md` (escaneo
`2026-06-11 20:14`: 13 carpetas, 68 archivos). Estructura conforme a la política
(Rama A). Desviaciones detectadas (deuda heredada, ver pendientes): `.DS_Store`
versionados, prototipo `.jsx` suelto en `30_procesamiento/`.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P1 — Limpiar `.DS_Store` versionados.** Tipo: deuda técnica. Impacto: bajo
  (ruido en el repo). Complejidad: baja. Enfoque sugerido:
  `git rm --cached` de los tres `.DS_Store` y commit. Criterio de éxito:
  `git status` limpio, `.DS_Store` ausentes del árbol versionado.
- **P2 — Reubicar `idps_radar_prototipo.jsx`.** Tipo: deuda técnica. Impacto:
  bajo. Complejidad: baja. Contexto: es prototipo de diseño, no paso del
  pipeline. Enfoque: cuando se construya el motor, integrarlo al flujo de
  generación del HTML o archivarlo. Criterio: el `.jsx` no queda suelto como
  paso aparente del pipeline.
- **P3 — Homologar `10_utils/10_utils.R` con el madre.** Tipo: bloqueante para
  agregación. Impacto: alto (la agregación ponderada depende de
  `agregar_ponderado()`). Complejidad: media. Enfoque: traer
  `instalar_si_falta()`, `log_msg()` y `agregar_ponderado()` validados de
  `slep_simce_adecuado`. Criterio: `agregar_ponderado()` disponible y testeado.
- **P4 — Resolver ponderación territorial.** Tipo: bloqueante / decisión.
  Impacto: alto (toda cifra agregada publicable). Complejidad: media.
  Recomendación: reutilizar `nalu` del proyecto madre, unir por RBD×grado×año.
  Criterio: agregados territoriales reproducen un spot-check contra
  reagregación RBD.
- **P5 — Inspección completa multi-grado/multi-año.** Tipo: funcionalidad.
  Impacto: alto. Complejidad: media. Enfoque: perfilar las 3 familias de tablas
  (`rbd`, `rbd_dim`, `rbd_subdim_niveles`) para los 4 grados y todos los años;
  confirmar cobertura temporal, homologar nombres de columnas entre años
  (final vs preliminar). Criterio: mapa de cobertura grado×año×tabla
  documentado.
- **P6 — Pipeline de datos.** Tipo: funcionalidad. Impacto: alto. Complejidad:
  alta. Enfoque: lectura 3 tablas → normalización (homologar `cod_depe2`,
  resolver ponderación) → catálogos de entidades reutilizados del madre →
  tablas `idps_rbd` (puntaje) e `idps_niveles_rbd` (distribución) → agregación
  ponderada por indicador/dimensión × GSE × territorio × grado × año. Criterio:
  Parquet intermedios generados y validados.
- **P7 — Vista de distribución Alto/Medio/Bajo** (apilado por subdimensión).
  Tipo: funcionalidad / diseño. Impacto: medio. Enfoque: reutilizar el apilado
  del motor madre sobre las tablas `rbd_subdim_niveles`. Criterio: barras
  apiladas funcionando junto al radar.
- **P8 — Drill-down por indicador** (radar secundario). Tipo: mejora visual.
  Impacto: medio. Enfoque: selector que muestre solo las 2–3 dimensiones de un
  indicador. Criterio: vista secundaria conviviendo con la integral.

### Evaluación de deuda técnica

Zonas frágiles: ninguna en código ejecutable (no hay pipeline aún). El
prototipo usa promedio simple, que NO debe migrar al motor real sin resolver
P4. Oportunidad: el escaneo reveló serie temporal completa, que el diseño del
motor debe contemplar desde el inicio (no rehacer para meterla después).

### Auditoría de cierre (POLÍTICA 5.6)

- ¿Pipeline corre de cero sin intervención manual? → No aplica (sin pipeline).
- ¿Cada transformación crítica tiene check de validación? → No aplica aún;
  obligatorio al construir P6.
- ¿Outputs reproducibles e idempotentes? → No aplica aún.
- ¿Decisiones metodológicas como constantes nombradas? → Sí (constantes en
  `10_configuracion.R`); la ponderación queda pendiente como constante por
  definir.
- ¿Nombres sin tildes/ñ/espacios? → Parcial: los archivos de insumos heredados
  de la Agencia conservan tildes y `+` (excepción declarada de datos crudos,
  POLÍTICA §1.2.4). Código y documentación cumplen.

### Ruta sugerida para la próxima sesión (CONTINUATION)

1. **P1 + P2** (limpieza rápida, abre la sesión con el repo ordenado).
2. **P5** (inspección multi-grado/multi-año): da el mapa de datos real antes de
   construir.
3. **P3 + P4** (homologar utils + resolver ponderación): desbloquean la
   agregación.
4. **P6** (pipeline) en bloques verificables.

Diferir a sesiones posteriores: P7 (distribución) y P8 (drill-down), que son
trabajo de motor una vez que el pipeline produce Parquet.

## 12. Instrucciones específicas para la próxima sesión

- ⚠️ NO publicar ninguna cifra agregada territorial sin resolver P4
  (ponderación): el promedio simple del prototipo es placeholder, no método.
- ✅ ANTES de agregar archivos a `20_insumos/`, re-ejecutar el chequeo de
  gobernanza (cabeceras sin columnas sensibles).
- ✅ ANTES de construir el motor, confirmar el mapa de cobertura
  grado×año×tabla (P5).
- 🔒 GSE inviolable: la segmentación aparece en todo output, jamás colapsada.
- 🔒 No mezclar indicadores, dimensiones, grados ni años en una misma cifra
  agregada.
- 🔒 Si entra una base por estudiante → Rama B sin excepción (limpiar historial
  de Git).

## 13. Fragmentos de código de referencia

Chequeo de gobernanza (re-ejecutar antes de versionar nuevos insumos):

```r
# verificar_gobernanza_insumos.R — chequeo unico, no se versiona
library(here); library(readxl)
archivos <- fs::dir_ls(here::here("20_insumos"), glob = "*.xlsx", recurse = TRUE)
patrones_sensibles <- "rut|run|nombre_alumno|nombre_estudiante|id_alumno|mrun|cod_alumno"
resultado <- purrr::map_dfr(archivos, function(f) {
  cols <- tryCatch(names(readxl::read_excel(f, n_max = 0)), error = function(e) character(0))
  sospechosas <- cols[grepl(patrones_sensibles, cols, ignore.case = TRUE)]
  tibble::tibble(
    archivo = fs::path_file(f), n_cols = length(cols),
    tiene_rbd = any(grepl("^rbd$", cols, ignore.case = TRUE)),
    columnas_sospechosas = if (length(sospechosas)) paste(sospechosas, collapse = ", ") else "—"
  )
})
print(resultado, n = Inf)
```

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 2 (Claude Code)`
- **Mensaje de apertura pre-armado:** Tipo CONTINUATION. El protocolo (política
  + settings) vive en la knowledge base del Project y en
  `50_documentacion/activa/`; léelo desde ahí. Sesión en Claude Code. Adjunto el
  traspaso y el escáner actualizado.
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar que estén al
     día):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` (sesión en Claude Code);
     `10_utils.R` del proyecto madre `slep_simce_adecuado` (para homologar P3);
     scripts de lectura de IDPS de `minuta_simce` (para alinear criterios, P5).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v01.md`;
     `estructura_actual.md`; los xlsx no se adjuntan (ya versionados en el repo).
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la
  versión más actualizada al abrir y avisarlo.
