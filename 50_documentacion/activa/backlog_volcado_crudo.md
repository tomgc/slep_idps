# Volcado crudo de backlog — 13 traspasos (materia prima A22)
> Generado por Claude Code el 2026-06-22. SOLO LECTURA sobre traspasos.
> VERBATIM: sin reconciliar, sin renumerar. Insumo de la consolidación del redactor.

## Índice de origen

| traspaso | L_inicio | L_fin | título encabezado |
|---|---|---|---|
| traspaso_cierre_v01.md | 86 | 131 | 5. Backlog acumulativo |
| traspaso_cierre_v02.md | 115 | 167 | 5. Backlog acumulativo |
| traspaso_cierre_v03.md | 125 | 184 | 5. Backlog acumulativo |
| traspaso_cierre_v04.md | 122 | 184 | 5. Backlog acumulativo |
| traspaso_cierre_v05.md | 160 | 222 | 5. Backlog acumulativo |
| traspaso_cierre_v06.md | 107 | 145 | 5. Backlog acumulativo |
| traspaso_cierre_v07.md | 130 | 229 | 5. Backlog acumulativo (CONSOLIDADO ÍNTEGRO en v07) |
| traspaso_cierre_v08.md | 63 | 127 | 5. Backlog acumulativo (CONSOLIDADO ÍNTEGRO en v08) |
| traspaso_cierre_v09.md | 59 | 116 | 5. Backlog acumulativo (CONSOLIDADO ÍNTEGRO en v09) |
| traspaso_cierre_v10.md | 129 | 152 | 5. Backlog acumulativo |
| traspaso_cierre_v11.md | 117 | 136 | 5. Backlog acumulativo |
| traspaso_cierre_v12.md | 166 | 193 | 5. Backlog acumulativo |
| traspaso_cierre_v13.md | 117 | 146 | 5. Backlog acumulativo |

===== ORIGEN: traspaso_cierre_v01.md · L86–L131 =====

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


===== ORIGEN: traspaso_cierre_v02.md · L115–L167 =====

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


===== ORIGEN: traspaso_cierre_v03.md · L125–L184 =====

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


===== ORIGEN: traspaso_cierre_v04.md · L122–L184 =====

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

### Clasificación temática (refinada en v04)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 3 | 11% | Estructura canónica, stubs, git, repo remoto |
| Gobernanza de datos | 4 | 14% | Verificación sensibilidad, decisión, depuración directorio, ignore |
| Visualización / diseño | 4 | 14% | Prototipo radar, reubicación, prompt de diseño, feedback prototipo como spec |
| Perfilado / exploración de datos | 4 | 14% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 5 | 18% | P1 (no-op), P2 reubicación, commits atómicos, consolidación 20_insumos, verif. P5-bis |
| Documentación conceptual / contenido | 8 | 29% | Corpus dual IDPS, niveles por ciclo, reconciliación de fuentes |

(28 cambios acumulados a v04. La categoría "Documentación conceptual / contenido"
baja de 35% a 29% al recalcularse sobre el nuevo total de 28; sigue siendo la
dominante pero ya no supera el 25% por margen amplio. "Limpieza / deuda técnica"
sube a 18% por la consolidación de Git de esta sesión.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| **Total** | | **28** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02). Cambio 9 resuelve la
  precaución de gobernanza del backlog.
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). El conjunto cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver sección 4). Sesión sin código
  ejecutable; consolida Git, desbloquea P3 (con caveat de adaptación), cierra el
  diagnóstico de P4 e incorpora el prototipo de UI con feedback de datos.

### Delta del backlog

5 entradas nuevas (24–28). Refinamiento de taxonomía: sin categorías nuevas; los
porcentajes se recalcularon sobre el nuevo total de 28. "Limpieza / deuda técnica"
y "Perfilado / exploración" crecen; "Documentación conceptual" baja en peso
relativo.


===== ORIGEN: traspaso_cierre_v05.md · L160–L222 =====

## 5. Backlog acumulativo

### Objetivo del proyecto

`slep_idps` es un motor de comparación interactivo de los Indicadores de Desarrollo Personal y
Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML autocontenido (React 18
+ D3 v7) publicado en GitHub Pages que muestra el dato **por establecimiento educacional**,
segmentado por grupo socioeconómico (GSE), para el equipo de Monitoreo y Seguimiento del SLEP
Costa Central y, desde v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado`,
del que reutiliza catálogos, patrones de generación HTML, escáner y estética. Activo desde
2026-06-11; desplegado nacionalmente desde 2026-06-19.

### Nota metodológica

Un "cambio" es una solicitud distinguible del usuario, no las acciones técnicas que la
implementan. No cuentan los errores del asistente corregidos en el acto; sí cuentan los bugfixes
reportados por el usuario. Clasificación por intención primaria. Fuente del conteo: registro
detallado de cada traspaso.

### Clasificación temática (recalculada en v05)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 12% | Estructura, stubs, git, repo remoto, orquestador run_all, deploy |
| Gobernanza de datos | 4 | 10% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore |
| Visualización / diseño | 10 | 24% | Prototipo, feedback, decisión de alcance, motor base, nacional, GSE eje, drill-down, estética |
| Perfilado / exploración de datos | 4 | 10% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 7 | 17% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding |
| Documentación conceptual / contenido | 9 | 22% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel |
| Pipeline / motor (código productivo) | 2 | 5% | Catálogos (33) y lectura/normalización (34) — categoría nueva en v05 |

(41 cambios acumulados a v05. **Categoría nueva** "Pipeline / motor (código productivo)" para el
código de datos productivo, inexistente hasta v05. Dominantes: Visualización/diseño 24%,
Documentación conceptual 22%, Limpieza/deuda técnica 17%; ninguna supera el 25%.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| 5 | v05 | 13 | Opus 4.8 | Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy Pages |
| **Total** | | **41** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02).
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). Cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver traspaso v04). Diagnóstico de P4, feedback prototipo.
- Sesión 5 (2026-06-12 decisión / 2026-06-19 implementación): cambios 29–41 (ver §4). Decisión
  P4/alcance + pipeline completo 31→35 + motor nacional + deploy. Subtítulos: *Decisión y
  Prioridad 1* (29-31), *Pipeline P6* (32-35), *Motor* (36-40), *Deploy* (41).

### Delta del backlog

13 entradas nuevas (29–41). **Refinamiento de taxonomía:** se agrega la categoría "Pipeline /
motor (código productivo)" (el proyecto produjo su primer código de pipeline). Porcentajes
recalculados sobre el nuevo total de 41. Crecen Visualización/diseño y Documentación; aparece
Pipeline/motor.


===== ORIGEN: traspaso_cierre_v06.md · L107–L145 =====

## 5. Backlog acumulativo

> **Nota:** el backlog acumulativo completo (objetivo del proyecto, nota
> metodológica, clasificación temática, resumen por sesión y detalle cronológico
> con numeración global permanente) se mantiene en su forma extensa heredada de
> v05 y se **copia íntegro** desde el traspaso v05, agregando al final los cambios
> de la sesión 6. Aquí se registra el **delta** de esta sesión para incorporar al
> detalle cronológico; la próxima apertura debe reconstruir el backlog completo
> uniendo v05 + este delta (o consolidarlo en v06 al republicar).

**Delta sesión 6 (≈22 cambios nuevos, continuando la numeración global desde el
último de v05):**
- Alcance 4b/2m (filtro de presentación duro).
- P-meta: definiciones metodológicas contextuales en el drill-down.
- Histórico de años agnóstico (preliminar derivado del dato).
- Evolución en 4 paneles por indicador con significancia inter-anual leída.
- Filtro Dependencia (4 categorías de cod_depe2) reemplaza el filtro SLEP.
- Significancia explícita (sig./n.s.) en la doble ancla GSE (a11y).
- EntityModal con 4 pestañas reemplaza los selects de navegación.
- Foco de apertura en SLEP Costa Central (estado, no filtro fijo).
- Tildes correctas en NOMBRES_REGION.
- Saneamiento de nombres de comuna/EE desde el directorio (H1/H2) + backfill geo (H8).
- Tildes en nombres de indicador y dimensión (H3/H4).
- Rename Sostenedor→Dependencia + blindaje de la pestaña (H5).
- GSE sin numeración en etiquetas.
- Radar con etiquetas de vértice (nombre + puntaje).
- Radar de dos años superpuestos (detalle, nivel indicador).
- Leyenda con definición de indicador accesible (hover + teclado).
- H6: dependencia vigente del directorio (118 EE Municipal→SLEP).
- Tildes en nombres de subdimensión (22 EST).
- Pulido funcional del radar de 2 años.
- Rediseño visual de chrome (densidad, header, controles, modal) hacia la
  referencia, conservando identidad IDPS y paleta de indicadores.

**Categoría temática nueva dominante en esta sesión:** Saneamiento/calidad de
datos de presentación (auditoría FASE I + correcciones H1-H8) y Rediseño visual.

---


===== ORIGEN: traspaso_cierre_v07.md · L130–L229 =====

## 5. Backlog acumulativo (CONSOLIDADO ÍNTEGRO en v07)

> **Cierre de deuda:** el v06 mantuvo el backlog por referencia (solo el delta de s6
> listado, sin consolidar con v05). Este v07 reconstruye el backlog íntegro: numeración
> global 1-41 (heredada de v05), 42-61 (sesión 6), 62-69 (sesión 7). La numeración es
> permanente y no se reinicia. Las entradas 1-28 siguen referenciadas a sus traspasos de
> origen (v01-v04) como en v05; 29-41 tienen detalle en v05 §4; 42-69 se detallan aquí.

### Objetivo del proyecto

`slep_idps` es un motor de comparación interactivo de los Indicadores de Desarrollo
Personal y Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML
autocontenido (React 18 + D3 v7) publicado en GitHub Pages que muestra el dato **por
establecimiento educacional**, segmentado por grupo socioeconómico (GSE), para el equipo
de Monitoreo y Seguimiento del SLEP Costa Central y, desde v05, para cualquier SLEP/comuna
del país. Hermano de `slep_simce_adecuado` y `slep_categoria_desempeno`, de los que
reutiliza catálogos, patrones de generación HTML, escáner y estética. Activo desde
2026-06-11; desplegado nacionalmente desde 2026-06-19; en rediseño a 3 pantallas desde
2026-06-20.

### Nota metodológica

Un "cambio" es una solicitud distinguible del usuario, no las acciones técnicas que la
implementan. No cuentan los errores del asistente corregidos en el acto; sí cuentan los
bugfixes reportados por el usuario. Clasificación por intención primaria. Fuente del
conteo: registro detallado de cada traspaso. En esta sesión, cada FASE del rediseño se
contó como un conjunto de cambios distinguibles (no cada commit técnico).

### Clasificación temática (recalculada en v07, sobre 69 cambios)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 7% | Estructura, stubs, git, repo remoto, orquestador run_all, deploy |
| Gobernanza de datos | 4 | 6% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore |
| Visualización / diseño | 23 | 33% | Prototipo, motor base, nacional, GSE eje, drill-down, estética, rediseño 3 pantallas (andamiaje, ficha, territorial), radares, evolución, EntityModal |
| Perfilado / exploración de datos | 4 | 6% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 8 | 12% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding, higiene andamios |
| Documentación conceptual / contenido | 9 | 13% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel, P-meta |
| Pipeline / motor (código productivo) | 2 | 3% | Catálogos (33) y lectura/normalización (34) |
| Saneamiento / calidad de datos de presentación | 14 | 20% | Auditoría FASE I, correcciones H1-H8, tildes, dependencia vigente, saneamiento de nombres (caracterización + reparación de caracteres corruptos) |

(69 cambios acumulados a v07. **Categoría nueva** "Saneamiento / calidad de datos de
presentación", dominante en s6-s7, agrupa la auditoría de datos y todas las correcciones
de etiqueta. Dominante: Visualización/diseño 33% — supera el 25%, candidata a subdividir
en v08 entre "motor base/datos" y "rediseño UI" si sigue creciendo. Porcentajes
aproximados, redondeados.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| 5 | v05 | 13 | Opus 4.8 | Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy Pages |
| 6 | v06 | 20 | Opus 4.8 | Alcance 4b/2m + P-meta + evolución + auditoría datos + saneamiento H1-H8 + rediseño chrome |
| 7 | v07 | 8 | Opus 4.8 | Rediseño 3 pantallas (Fases 1-3) + saneamiento de nombres + consolidación backlog |
| **Total** | | **69** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02).
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). Cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver traspaso v04). Diagnóstico P4, feedback prototipo.
- Sesión 5 (2026-06-12 decisión / 2026-06-19 implementación): cambios 29–41 (ver v05 §4).
  Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy.
- Sesión 6 (2026-06-19/20): cambios **42–61**. Rediseño y auditoría. Subtítulos:
  *Alcance y P-meta* (42-45: alcance 4b/2m, P-meta definiciones contextuales, histórico
  agnóstico, evolución 4 paneles con significancia inter-anual leída); *Navegación y foco*
  (46-49: filtro Dependencia 4-cat reemplaza filtro SLEP, significancia explícita sig./n.s.
  en doble ancla GSE, EntityModal 4 pestañas reemplaza selects, foco apertura Costa Central);
  *Saneamiento FASE II tras auditoría FASE I* (50-57: tildes NOMBRES_REGION, saneamiento
  nombres comuna/EE desde directorio H1/H2 + backfill geo H8, tildes indicador/dimensión
  H3/H4, rename Sostenedor→Dependencia + blindaje pestaña H5, GSE sin numeración, radar con
  etiquetas de vértice, radar 2 años superpuestos, leyenda con definición accesible);
  *Encargo 2* (58-61: H6 dependencia vigente del directorio 118 Municipal→SLEP, tildes
  subdimensión 22 EST, pulido radar 2 años, rediseño visual de chrome hacia la referencia).
- Sesión 7 (2026-06-20): cambios **62–69**. Rediseño 3 pantallas + nombres. Subtítulos:
  *Rediseño por fases* (62: Fase 1 andamiaje navegación tabs + router + stubs; 63: Fase 2
  ficha rediseñada todo-desplegado radar + paneles + toggle vista actual/histórica; 64:
  Fase 3 pantalla territorial barras apiladas + grilla mini-radar, grilla migrada de ficha);
  *Saneamiento de nombres* (65: jerarquía de nombres de tres capas — caracterización para EE
  del SLEP, directorio con reparación para el resto; 66: reparación de caracteres corruptos
  por contexto — acento/circunflejo entre letras → apóstrofo, backtick envolvente → comillas
  dobles, backtick impar → anomalía reportada); *Higiene e instrumentos* (67: versionado de
  andamios rediseno_3pantallas y logs Fases 1-2; 68: auditoría de bugs/errores/debilidades
  del motor completo tras 3 fases; 69: consolidación del backlog acumulativo íntegro 1-69,
  cierre de la deuda de backlog-por-referencia de v06).

### Delta del backlog

28 entradas nuevas desde v05 (42-69: 20 en s6, 8 en s7). **Refinamiento de taxonomía:** se
agrega la categoría "Saneamiento / calidad de datos de presentación" (dominante en s6-s7).
Visualización/diseño crece a 33% (supera 25%: subdividir en v08 si sigue). **Cierre de
deuda documental:** el backlog vuelve a estar consolidado in extenso, no por referencia.

---


===== ORIGEN: traspaso_cierre_v08.md · L63–L127 =====

## 5. Backlog acumulativo (CONSOLIDADO ÍNTEGRO en v08)

> Numeración global permanente 1-69 (heredada de v07) + 70-77 (sesión 8). No se
> reinicia ni renumera. Entradas 1-28 referenciadas a v01-v04; 29-41 detalladas
> en v05 §4; 42-69 en v07 §5; 70-77 aquí.

### Objetivo del proyecto

`slep_idps` es un motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML autocontenido (React 18 + D3 v7) publicado en GitHub Pages que muestra el dato **por establecimiento educacional**, segmentado por grupo socioeconómico (GSE), para el equipo de Monitoreo y Seguimiento del SLEP Costa Central y, desde v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado` y `slep_categoria_desempeno`, de los que reutiliza catálogos, patrones de generación HTML, escáner y estética. Activo desde 2026-06-11; desplegado nacionalmente desde 2026-06-19; rediseño a 3 pantallas completado 2026-06-20.

### Nota metodológica

Un "cambio" es una solicitud distinguible del usuario, no las acciones técnicas que la implementan. No cuentan los errores del asistente corregidos en el acto; sí cuentan los bugfixes reportados por el usuario. Clasificación por intención primaria. Fuente del conteo: registro detallado de cada traspaso. Cada FASE del rediseño y cada hito de cierre (deploy, auditoría, lote) se cuenta como un cambio distinguible, no cada commit técnico.

### Clasificación temática (recalculada en v08, sobre 77 cambios)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 6% | Estructura, stubs, git, repo remoto, orquestador run_all, deploy |
| Gobernanza de datos | 4 | 5% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore |
| Visualización / diseño — motor base/datos | 14 | 18% | Prototipo, motor base, nacional, GSE eje, drill-down, estética, radares, evolución, EntityModal |
| Visualización / diseño — rediseño UI | 13 | 17% | Rediseño 3 pantallas (andamiaje, ficha, territorial, comparación), auditoría de fidelidad, lote de corrección |
| Perfilado / exploración de datos | 4 | 5% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 8 | 10% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding, higiene andamios |
| Documentación conceptual / contenido | 9 | 12% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel, P-meta |
| Pipeline / motor (código productivo) | 2 | 3% | Catálogos (33) y lectura/normalización (34) |
| Saneamiento / calidad de datos de presentación | 14 | 18% | Auditoría FASE I, correcciones H1-H8, tildes, dependencia vigente, saneamiento de nombres |
| Deploy / publicación | 4 | 5% | Deploy Pages inicial, republicaciones, verificación byte a byte docs/ |

(77 cambios acumulados a v08. **Refinamiento de taxonomía aplicado (P8 resuelto):** la categoría "Visualización / diseño" que superaba el 25% en v07 se subdividió en "motor base/datos" (18%) y "rediseño UI" (17%). **Categoría nueva** "Deploy / publicación" (5%), antes absorbida en Infraestructura, separada al volverse recurrente en s8. Porcentajes aproximados, redondeados.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| 5 | v05 | 13 | Opus 4.8 | Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy Pages |
| 6 | v06 | 20 | Opus 4.8 | Alcance 4b/2m + P-meta + evolución + auditoría datos + saneamiento H1-H8 + rediseño chrome |
| 7 | v07 | 8 | Opus 4.8 | Rediseño 3 pantallas (Fases 1-3) + saneamiento de nombres + consolidación backlog |
| 8 | v08 | 8 | Opus 4.8 | Fase 4 comparación + deploy + auditoría de fidelidad + lote de corrección |
| **Total** | | **77** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02).
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). Cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver traspaso v04). Diagnóstico P4, feedback prototipo.
- Sesión 5 (2026-06-12 / 2026-06-19): cambios 29–41 (ver v05 §4). Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy.
- Sesión 6 (2026-06-19/20): cambios 42–61 (ver v07 §5). Rediseño y auditoría de datos.
- Sesión 7 (2026-06-20): cambios 62–69 (ver v07 §5). Rediseño 3 pantallas Fases 1-3 + saneamiento de nombres + consolidación backlog.
- Sesión 8 (2026-06-20): cambios **70–77**. Cierre del rediseño. Subtítulos:
  *Fase 4 y deploy* (70: evaluación y aprobación del log de Fase 3 sin correcciones; 71: Fase 4 pantalla Comparación entre territorios — matriz GSE × indicador, celda % (n), hasta 4 territorios, año más reciente del grado; 72: deploy inicial a Pages republicando docs/ con Fases 1-4);
  *Auditoría de fidelidad* (73: auditoría sistemática read-only del motor vs handout — 36 divergencias + 3 conflictos de invariante, 4 auditores + 1 crítico; 74: lote de corrección de 35 divergencias igualando al diseño — header, nav sticky+coral, banner territorial, GSE multi-select, buscador en ficha, comparar vacío, estado azul/gris/rojo C3; 75: C1/C2 mantenidos por invariante, verificado contra la decisión de ponderación);
  *Republicación y cierre* (76: republicación de docs/ tras correcciones + commit de la auditoría como evidencia; 77: traspaso v08 con backlog 1-77 y subdivisión de taxonomía P8).

### Delta del backlog

8 entradas nuevas desde v07 (70-77). **Refinamiento de taxonomía (P8 resuelto):** "Visualización / diseño" (33% en v07) subdividida en "motor base/datos" (18%) y "rediseño UI" (17%); nueva categoría "Deploy / publicación" (5%). Sin reclasificación de entradas históricas; la subdivisión opera sobre la distribución, no reescribe entradas previas.

---


===== ORIGEN: traspaso_cierre_v09.md · L59–L116 =====

## 5. Backlog acumulativo (CONSOLIDADO ÍNTEGRO en v09)

> Numeración global permanente 1-77 (heredada de v08) + 78-83 (sesión 9). No se
> reinicia ni renumera. Entradas 1-28 referenciadas a v01-v04; 29-41 a v05;
> 42-69 a v07; 70-77 a v08; 78-83 detalladas en §4 de este traspaso.

### Clasificación temática (recalculada en v09, sobre 83 cambios)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 6% | Estructura, stubs, git, repo remoto, orquestador run_all |
| Gobernanza de datos | 4 | 5% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore |
| Visualización / diseño — motor base/datos | 14 | 17% | Prototipo, motor base, nacional, GSE eje, drill-down, estética, radares, evolución, EntityModal |
| Visualización / diseño — rediseño UI | 15 | 18% | Rediseño 3 pantallas, auditoría de fidelidad, lote de corrección, barras vista histórica, pestaña SLEP |
| Perfilado / exploración de datos | 4 | 5% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 8 | 10% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding, higiene andamios |
| Documentación conceptual / contenido | 9 | 11% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel, P-meta |
| Pipeline / motor (código productivo) | 3 | 4% | Catálogos (33), lectura/normalización (34), exposición anio_traspaso (generador 35) |
| Saneamiento / calidad de datos de presentación | 14 | 17% | Auditoría FASE I, correcciones H1-H8, tildes, dependencia vigente, saneamiento de nombres |
| Deploy / publicación | 7 | 8% | Deploy Pages inicial, republicaciones, verificación byte a byte docs/, deploys s9, confirmación P0-s9 |

(83 cambios acumulados a v09. Sin refinamiento de taxonomía nuevo: las dos entradas de UI de s9 caen en "rediseño UI" (14→15), la exposición del generador en "Pipeline/motor" (2→3), y los deploys + confirmación P0 en "Deploy/publicación" (4→7). Porcentajes aproximados, redondeados; suma de redondeos no exacta a 100.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| 5 | v05 | 13 | Opus 4.8 | Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy Pages |
| 6 | v06 | 20 | Opus 4.8 | Alcance 4b/2m + P-meta + evolución + auditoría datos + saneamiento H1-H8 + rediseño chrome |
| 7 | v07 | 8 | Opus 4.8 | Rediseño 3 pantallas (Fases 1-3) + saneamiento de nombres + consolidación backlog |
| 8 | v08 | 8 | Opus 4.8 | Fase 4 comparación + deploy + auditoría de fidelidad + lote de corrección |
| 9 | v09 | 6 | Opus 4.8 | Barras vista histórica + pestaña SLEP + exposición anio_traspaso + cierre P0-s9 |
| **Total** | | **83** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02).
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). Cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver traspaso v04). Diagnóstico P4, feedback prototipo.
- Sesión 5 (2026-06-12 / 2026-06-19): cambios 29–41 (ver v05 §4).
- Sesión 6 (2026-06-19/20): cambios 42–61 (ver v07 §5).
- Sesión 7 (2026-06-20): cambios 62–69 (ver v07 §5).
- Sesión 8 (2026-06-20): cambios 70–77 (ver v08 §4). Cierre del rediseño + auditoría de fidelidad.
- Sesión 9 (2026-06-21): cambios **78–83** (ver §4 de este traspaso). Subtítulos:
  *Confirmación y barras* (78: confirmación visual P0-s9 del rediseño; 79: vista histórica de ficha de líneas a barras por año — componente `BarrasAnio` CSS, indicador → dimensión, sin subdimensión; 80: deploy de las barras a Pages);
  *Pestaña SLEP* (81: exposición de `anio_traspaso` en `DATA.sleps` vía generador; 82: pestaña SLEP en selector territorial con "Traspaso AAAA" como etiqueta, sin filtro de año; 83: deploy de la pestaña SLEP + sellado de cierre — encargos y snapshot de estructura versionados).

### Delta del backlog

6 entradas nuevas desde v08 (78-83). Sin refinamiento de taxonomía (ninguna categoría cruzó el 25% ni cayó bajo el 2%). Sin reclasificación de entradas históricas.

---


===== ORIGEN: traspaso_cierre_v10.md · L129–L152 =====

## 5. Backlog acumulativo

> Se copia íntegro de v09 y se agregan las entradas nuevas al final. La numeración
> es global y permanente. (El backlog detallado vive en
> `50_documentacion/` del proyecto; aquí se registra el delta de la sesión 10 y se
> referencia el acumulado.)

- **Objetivo del proyecto** (permanente): motor de visualización de los
  Indicadores de Desarrollo Personal y Social (IDPS) de la Agencia de Calidad,
  nacional, por establecimiento, sin agregación territorial; React 18 + D3 v7
  inline desplegado en GitHub Pages; para directivos y comunidad del SLEP Costa
  Central y de todo Chile; desde 2026.
- **Nota metodológica** (permanente): "cambio" = una solicitud distinguible del
  titular, no las acciones técnicas que la implementan; los bugfixes reportados
  por el titular cuentan, los errores del asistente corregidos de inmediato no.

**Delta del backlog v10:** +4 entradas de sesión (C1 censo, C2 reorganización, C3
integración, C4 push/deploy), todas de la categoría dominante de esta sesión
(carga de datos histórica / pipeline). Sin reclasificaciones ni refinamiento de
taxonomía. El conteo acumulado y el detalle cronológico se actualizan en el
backlog histórico del proyecto en la próxima apertura si procede.

---


===== ORIGEN: traspaso_cierre_v11.md · L117–L136 =====

## 5. Backlog acumulativo

> Se copia integro de v10 y se agregan las entradas nuevas al final (numeracion
> global y permanente; el detalle vive en el backlog del proyecto, aqui el delta).

- **Objetivo del proyecto** (permanente): motor de visualizacion de los IDPS de la
  Agencia de Calidad, nacional, por establecimiento, sin agregacion territorial;
  React 18 + D3 v7 inline en GitHub Pages; para directivos y comunidad del SLEP
  Costa Central y de todo Chile; desde 2026.
- **Nota metodologica** (permanente): "cambio" = una solicitud distinguible del
  titular; bugfixes reportados por el titular cuentan; errores del asistente
  corregidos de inmediato no.

**Delta del backlog v11:** la sesion no introdujo cambios de dato/producto; sus
entradas son de **verificacion** (C1 auditoria de integracion, C2 censo de valores)
y de **higiene documental** (C3). Sin reclasificaciones de taxonomia. El conteo
acumulado se actualiza en la proxima apertura si procede.

---


===== ORIGEN: traspaso_cierre_v12.md · L166–L193 =====

## 5. Backlog acumulativo

> Se copia integro de v11 y se agregan las entradas nuevas al final (numeracion
> global y permanente; el detalle vive en el backlog del proyecto, aqui el delta).

- **Objetivo del proyecto** (permanente): motor de visualizacion de los IDPS de la
  Agencia de Calidad, nacional, por establecimiento, sin agregacion territorial;
  React 18 + D3 v7 inline en GitHub Pages; para directivos y comunidad del SLEP
  Costa Central y de todo Chile; desde 2026.
- **Nota metodologica** (permanente): "cambio" = una solicitud distinguible del
  titular; bugfixes reportados por el titular cuentan; errores del asistente
  corregidos de inmediato no.

**Delta del backlog v12:** la sesion produjo cambios de PRODUCTO (motor) por primera
vez en varias sesiones. Entradas nuevas, por intencion primaria:
- **Funcionalidad/motor (C2, C3, C6):** serie historica en el motor — eje contiguo
  server-side, render de años desactivados, header dinamico, pulido geo-NA, deploy.
  Cuenta como 1 solicitud distinguible del titular (P-MOTOR), implementada en varias
  piezas tecnicas.
- **Bugfix (C4, C5, C8):** tres bugs del generador destapados por el historico (H6
  dependencia-NA, dedup de establecimientos, fantasma rbd=NA). Reportados/derivados
  durante la ejecucion; cuentan.
- **Verificacion (C1, C7):** diagnostico del build + auditoria de fidelidad censal.
- Sin reclasificaciones de taxonomia. El conteo acumulado se actualiza en la proxima
  apertura (A22: verificar contra el detalle cronologico, no heredar tablas).

---


===== ORIGEN: traspaso_cierre_v13.md · L117–L146 =====

## 5. Backlog acumulativo

> Se copia integro del backlog del proyecto y se agregan las entradas nuevas al
> final (numeracion global y permanente). Aqui el delta de s13; el conteo
> acumulado total se reconcilia contra el detalle cronologico del proyecto (A22:
> no heredar tablas), pendiente de verificar en la apertura de s14 con el backlog
> historico a la vista.

- **Objetivo del proyecto** (permanente): motor de visualizacion de los IDPS de la
  Agencia de Calidad, nacional, por establecimiento, sin agregacion territorial;
  React 18 + D3 v7 inline en GitHub Pages; para directivos y comunidad del SLEP
  Costa Central y de todo Chile; desde 2026.
- **Nota metodologica** (permanente): "cambio" = una solicitud distinguible del
  titular; bugfixes reportados por el titular cuentan; errores del asistente
  corregidos de inmediato no.

**Delta del backlog v13:** sesion de decisiones e higiene (sin producto ni dato).
Entradas nuevas, por intencion primaria:
- **Decision/gobernanza (C1):** resolucion de H-FID-2 (etiqueta Dependencia,
  opcion A). 1 solicitud distinguible del titular.
- **Higiene/chore (C2, C3, C4):** gitignore de scratch, renombrado de glosas,
  snapshot del escaner. Mantenimiento de repo; cuentan segun la nota metodologica
  si el titular los considera solicitudes distinguibles (los 3 derivan de
  pendientes heredados + instruccion de cierre).
- Sin reclasificaciones de taxonomia. **Posible categoria nueva a evaluar en s14:**
  si "higiene/chore" o "decision/gobernanza" acumulan, considerar si merecen
  categoria propia o se absorben (umbral ~2%, subdivision >25%).

---


