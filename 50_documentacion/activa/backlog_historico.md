# backlog_historico.md — `slep_idps`

> **Backlog acumulativo consolidado del proyecto.** Memoria de largo plazo
> (numeración global y permanente). Este documento cierra la deuda **A22**: la
> reconciliación del conteo correlativo global contra el detalle cronológico, que
> venía difiriéndose desde v10 (los deltas de v10–v13 se describieron pero nunca
> se numeraron ni se sumaron al total). Reconstruido en la sesión 14 a partir del
> volcado verbatim de las secciones de backlog de los 14 traspasos
> (`backlog_volcado_crudo.md`), verificando la numeración contra el detalle
> cronológico de los consolidados íntegros v07/v08/v09 (A22: no heredar tablas,
> verificar contra el detalle).
>
> **Regla de mantención:** en cada cierre se copia íntegro y se agregan las
> entradas nuevas al final. Jamás se reescriben, resumen ni renumeran entradas
> anteriores; un error se corrige con una entrada nueva. La numeración global es
> permanente y no se reinicia.
>
> **Versión:** consolidado a v16 (2026-06-22). **Total reconciliado: 107 cambios.**

---

## Objetivo del proyecto (permanente)

`slep_idps` es un motor de visualización interactivo de los Indicadores de
Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación.
Produce un HTML autocontenido (React 18 + D3 v7 inline) publicado en GitHub Pages
que muestra el dato **por establecimiento educacional**, sin agregación
territorial, segmentado por grupo socioeconómico (GSE), con serie histórica
2014→2025. Para el equipo de Monitoreo y Seguimiento del SLEP Costa Central y, desde
v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado` y
`slep_categoria_desempeno`, de los que reutiliza catálogos, patrones de generación
HTML, escáner y estética. Activo desde 2026-06-11; desplegado nacionalmente desde
2026-06-19.

## Nota metodológica (permanente)

Un "cambio" es una solicitud distinguible del titular, no las acciones técnicas
que la implementan. No cuentan los errores del asistente corregidos en el acto; sí
cuentan los bugfixes reportados por el titular. Clasificación por intención
primaria. Fuente del conteo: registro detallado de cada traspaso. Cuando una
solicitud se implementa en varias piezas técnicas (p. ej. una FASE de rediseño o
un encargo de varias fases a Claude Code), se cuenta como el conjunto de cambios
distinguibles que el titular pidió, no como cada commit técnico.

---

## Resumen estadístico por sesión

| Sesión | Traspaso | N° cambios | Rango global | Modelo | Foco |
|---|---|---|---|---|---|
| 1 | v01 | 6 | 1–6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | 7–15 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | 16–23 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | 24–28 | Opus 4.8 | Consolidación Git + utils madre + diagnóstico P4 + feedback prototipo |
| 5 | v05 | 13 | 29–41 | Opus 4.8 | Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy Pages |
| 6 | v06/v07 | 20 | 42–61 | Opus 4.8 | Alcance 4b/2m + P-meta + evolución + auditoría datos + saneamiento H1-H8 + rediseño chrome |
| 7 | v07 | 8 | 62–69 | Opus 4.8 | Rediseño 3 pantallas (Fases 1-3) + saneamiento de nombres + consolidación backlog |
| 8 | v08 | 8 | 70–77 | Opus 4.8 | Fase 4 comparación + deploy + auditoría de fidelidad + lote de corrección |
| 9 | v09 | 6 | 78–83 | Opus 4.8 | Barras vista histórica + pestaña SLEP + exposición anio_traspaso + cierre P0-s9 |
| 10 | v10 | 4 | 84–87 | Opus 4.8 | Carga histórica: censo + reorganización universo + integración + deploy |
| 11 | v11 | 3 | 88–90 | Opus 4.8 | Verificación integración + censo de valores + higiene documental |
| 12 | v12 | 6 | 91–96 | Opus 4.8 | Serie histórica en motor (P-MOTOR) + 3 bugfixes + verificación de fidelidad |
| 13 | v13 | 4 | 97–100 | Opus 4.8 | Decisión H-FID-2 + higiene de repo (inventarios, glosas, escáner) |
| 14 | v14 | 4 | 101–104 | Opus 4.8 | Paleta folleto + auditoría decimales + suite suitedoc + ajustes de motor |
| 15 | v15 | 2 | 105–106 | Opus 4.8 | P-PALETA-v2 rampa+separador + P-DOC-RENDER suite |
| 16 | v16 | 1 | 107 | Opus 4.8 | P-ORG: reorganización del directorio (encargos + scripts) |
| **Total** | | **107** | **1–107** | | |

> **Nota de reconciliación A22 (sesión 14):** las sesiones 1–9 mantuvieron
> numeración global verificable y taxonomía recalculada en cada cierre (total 83
> a v09, trazado en los consolidados íntegros v07/v08/v09). Desde v10 el conteo
> dejó de actualizarse: los traspasos v10–v13 registraron el delta de cada sesión
> con la nota "el conteo acumulado se actualiza en la próxima apertura si procede",
> que nunca se ejecutó. Esta consolidación numera esos deltas (84–100) contra el
> detalle de cada traspaso y agrega s14 (101–104). El conteo de cada delta sigue
> la nota metodológica (intención primaria): donde un traspaso listó varios `Cn`
> técnicos que implementan una sola solicitud, se contó la solicitud, no los `Cn`.

---

## Clasificación temática (recalculada a v16, sobre 107 cambios)

> Taxonomía orgánica heredada de v09 (10 categorías), con dos categorías nuevas
> que emergen al consolidar v10–v14. Categorías mutuamente excluyentes por
> intención primaria. Porcentajes redondeados; la suma de redondeos puede no dar
> 100 exacto.

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 5% | Estructura canónica, stubs, git, repo remoto, orquestador run_all |
| Gobernanza de datos | 5 | 5% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore, gitignore inventarios scratch |
| Visualización / diseño — motor base/datos | 14 | 13% | Prototipo, motor base, nacional, GSE eje, drill-down, estética, radares, evolución, EntityModal |
| Visualización / diseño — rediseño UI | 16 | 15% | Rediseño 3 pantallas, auditoría de fidelidad, lote de corrección, barras vista histórica, pestaña SLEP, rampa de niveles + separador de dimensión (P-PALETA-v2) |
| Perfilado / exploración de datos | 4 | 4% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 12 | 11% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding, higiene andamios, renombrado de glosas, snapshot escáner, reorganización del directorio (P-ORG) |
| Documentación conceptual / contenido | 9 | 9% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel, P-meta |
| Pipeline / motor (código productivo) | 7 | 7% | Catálogos (33), lectura/normalización (34), exposición anio_traspaso (35), carga histórica 2014–2019, serie histórica server-side |
| Saneamiento / calidad de datos de presentación | 14 | 13% | Auditoría FASE I, correcciones H1-H8, tildes, dependencia vigente, saneamiento de nombres |
| Deploy / publicación | 9 | 9% | Deploy Pages inicial, republicaciones, verificación byte a byte docs/, deploys s9–s14 |
| Verificación / auditoría (independiente) | 6 | 6% | Auditoría de integración histórica, censo de valores, fidelidad censal del build, auditoría de decimales nativos |
| Decisión / gobernanza de producto | 3 | 3% | Decisión de ponderación, decisión H-FID-2 (dependencia vigente), decisión de paleta del folleto |
| Documentación de proyecto (suite/política) | 2 | 2% | Suite `suitedoc` (4 HTML, v14) + P-DOC-RENDER (HTML autocontenidos + tema versionado, v15) |

**Refinamientos de taxonomía aplicados en la consolidación v14:**
- **Categoría nueva "Verificación / auditoría (independiente)"** (6%): las
  sesiones 11 y 12 produjeron auditorías de solo lectura (integración histórica,
  censo de valores, fidelidad censal) y s14 sumó la auditoría de decimales. Antes
  dispersas entre "Saneamiento" y "Pipeline"; se separan al volverse recurrentes y
  metodológicamente distintas (no modifican el producto, lo verifican).
- **Categoría nueva "Decisión / gobernanza de producto"** (3%): decisiones
  documentadas que resuelven un pendiente sin tocar código (ponderación, H-FID-2,
  paleta). Antes absorbidas en "Gobernanza de datos"; se separan porque son
  decisiones de presentación/producto, no de protección de datos.
- **Categoría nueva "Documentación de proyecto (suite/política)"** (1%): la suite
  `suitedoc` de s14. Bajo el umbral del 2%; se mantiene en observación para
  absorberla si no acumula (regla de absorción <2%).

---

## Detalle cronológico

> Numeración global permanente. Las entradas 1–83 conservan su trazabilidad a los
> traspasos de origen tal como quedó en los consolidados v07/v08/v09; las entradas
> 84–107 se reconcilian aquí por primera vez.

- **Sesión 1** (2026-06-11): cambios **1–6** (ver traspaso v01). Paso 0 + prototipo radar.
- **Sesión 2** (2026-06-11): cambios **7–15** (ver traspaso v02). Limpieza + gobernanza + censo P5 + prompt diseño.
- **Sesión 3** (2026-06-12): cambios **16–23** (ver traspaso v03). Documentación conceptual IDPS; cierra P10.
- **Sesión 4** (2026-06-12): cambios **24–28** (ver traspaso v04). Diagnóstico P4, feedback prototipo.
- **Sesión 5** (2026-06-12 / 2026-06-19): cambios **29–41** (ver v05 §4). Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy.
- **Sesión 6** (2026-06-19/20): cambios **42–61** (detalle en v07 §5). Rediseño y auditoría de datos (alcance 4b/2m, P-meta, histórico agnóstico, evolución 4 paneles, filtro Dependencia, significancia a11y, EntityModal, saneamiento H1-H8, rediseño chrome).
- **Sesión 7** (2026-06-20): cambios **62–69** (detalle en v07 §5). Rediseño 3 pantallas Fases 1-3 + saneamiento de nombres + consolidación backlog.
- **Sesión 8** (2026-06-20): cambios **70–77** (detalle en v08 §5). Cierre del rediseño: Fase 4 Comparación entre territorios (matriz GSE × indicador), deploy inicial republicando docs/, auditoría de fidelidad read-only (36 divergencias + 3 conflictos de invariante), lote de corrección de 35 divergencias, C1/C2 mantenidos por invariante, republicación + traspaso v08.
- **Sesión 9** (2026-06-20): cambios **78–83** (detalle en v09 §4). Barras vista histórica + pestaña SLEP + exposición `anio_traspaso` en el generador + deploys + cierre P0-s9.
- **Sesión 10** (2026-06-21): cambios **84–87** (detalle en v10 §4). Carga histórica 2014–2019: **84** censo del histórico; **85** reorganización del universo IDPS; **86** integración histórica al pipeline; **87** push/deploy de la carga.
- **Sesión 11** (2026-06-21): cambios **88–90** (detalle en v11 §4). Verificación (sin cambio de producto): **88** auditoría de integración histórica; **89** censo de valores históricos; **90** higiene documental.
- **Sesión 12** (2026-06-21): cambios **91–96** (detalle en v12 §4). Serie histórica en el motor y bugfixes: **91** P-MOTOR (serie histórica server-side: eje contiguo, render de años desactivados, header dinámico, pulido geo-NA, deploy — una solicitud, varias piezas C2/C3/C6); **92** bugfix H6 dependencia-NA; **93** bugfix dedup de establecimientos; **94** bugfix fantasma rbd=NA (H-FID-1); **95** diagnóstico del build (C1); **96** auditoría de fidelidad censal parquet→sitio (C7, P-DISPLAY-FIDELITY).
- **Sesión 13** (2026-06-22): cambios **97–100** (detalle en v13 §4). Decisiones e higiene: **97** decisión H-FID-2 (etiqueta Dependencia, opción A); **98** gitignore de inventarios scratch (P-INVENTARIOS); **99** renombrado de 4 glosas sin tildes (P-HIGIENE-TILDES); **100** snapshot del escáner post-higiene.
- **Sesión 14** (2026-06-22): cambios **101–104** (detalle en v14 §4). Paleta, auditoría, documentación y motor: **101** P-PALETA — adopción de la identidad cromática del folleto de la Agencia en los 4 indicadores (desplegada, `1d41c17`); **102** auditoría de decimales en `prom` (solo lectura: veredicto nativos de la Agencia, leídos verbatim por `34`); **103** suite de documentación `suitedoc` (4 HTML generados; P-DOC, entrega sustantiva con verificación de render pendiente); **104** ajustes de presentación del motor (una solicitud, 4 fases: decimales→entero, recorte de eje por familia, borde por dimensión, espaciado — fases 1/2/4 aprobadas, fase 3 rechazada en revisión visual → reabre en P-PALETA-v2; build local sin push por decisión del titular, camino A).
- **Sesión 15** (2026-06-22): cambios **105–106** (detalle en v15 §4). P-PALETA-v2 y documentación de la suite: **105** P-PALETA-v2 — rampa de niveles monocromática por indicador (reemplaza el semáforo en `DistBar`, derivada del color del indicador padre; Bajo claro→Alto oscuro) + separador de dimensión como contenedor a escala (rehace la fase 3 rechazada de s14); presentación pura (fidelidad censal mismatch 0, panel adversarial 3/3), desplegado `ed240a6`; **106** P-DOC-RENDER — render autocontenido de la suite (4 HTML `*_standalone` con CSS/fuentes/logos en base64) + 2 bugfixes de `inline_suite.R` (href con `regexec`; saltos del base64) + versionado del tema (css/fonts/assets) para reproducir la suite desde el repo.
- **Sesión 16** (2026-06-22): cambio **107** (detalle en v16 §4). P-ORG — reorganización del directorio del proyecto bajo protocolo 4.2 (migración de estructura, DRY_RUN) vía encargo autónomo a Claude Code: **107** los 16 `encargo_*.md` movidos de la raíz de `50_documentacion/activa/` a `activa/encargos/` (renames git, historial preservado), 8 scripts de andamio (`verificar_*.R` ×7 + `reorganizar_universo_idps.R`) archivados de la raíz del repo a `_archivo/20260622/`, 12 referencias full-path reescritas en `.md` vivos (DRY_RUN==real, 0 refs rotas, 6 invariantes 🔒 PASA); desplegado tras gate pre-push (`681783d..50c3dd4`, local==origin `50c3dd4`); motor, parquet, `20_insumos/`, `40_salidas/` y `docs/` NO tocados.

---

## Delta del backlog (consolidación v14)

- **+21 entradas reconciliadas** respecto al último conteo verificable (83 a v09):
  84–87 (s10), 88–90 (s11), 91–96 (s12), 97–100 (s13), 101–104 (s14).
- **Cierre de A22:** este documento es la reconciliación que v10–v13 difirieron.
  En adelante, el conteo acumulado se actualiza en este archivo en cada cierre, no
  se difiere.
- **3 categorías nuevas** en la taxonomía (Verificación/auditoría;
  Decisión/gobernanza de producto; Documentación de proyecto), todas por
  separación de categorías existentes que acumularon entradas de naturaleza
  distinta; sin reclasificar entradas históricas (la subdivisión opera sobre la
  distribución, no reescribe entradas previas).
- **En observación:** "Documentación de proyecto (suite/política)" está bajo el 2%
  (1 entrada); se absorbe en una sesión futura si no acumula. "Decisión /
  gobernanza de producto" (3%) y "Verificación / auditoría" (6%) quedan por encima
  del umbral de absorción.

---

## Delta del backlog (consolidación v15)

- **+2 entradas** (105–106): P-PALETA-v2 (#105) y P-DOC-RENDER (#106). Total 104 → **106**.
- **Sin categorías nuevas:** #105 entra en "Visualización / diseño — rediseño UI"
  (15 → 16); #106 en "Documentación de proyecto (suite/política)" (1 → 2).
- **"Documentación de proyecto (suite/política)" alcanza el 2%** (2 entradas): sale
  del umbral de absorción <2% en el que quedó en observación en v14.

---

## Delta del backlog (consolidación v16)

- **+1 entrada** (107): P-ORG (#107). Total 106 → **107**. Verificado contra el
  detalle cronológico (último #106 a v15), no contra la tabla heredada (A22).
- **Sin categorías nuevas:** #107 entra en "Limpieza / deuda técnica" (11 → 12).
  Ninguna categoría cruza el 25% ni cae bajo el 2% con este cambio; sin subdivisión
  ni absorción.
- **Cierre de la deuda de cierre de s16:** el traspaso v16 §9 declaraba el total en
  107, pero la entrada no se había integrado al archivo (quedó descrita en v16 §4
  sin numerar aquí). Esta consolidación la integra, manteniendo A22 (no diferir el
  conteo).
- **⚠️ Deuda de integridad detectada (heredada de la reconciliación v14/v15, NO de
  P-ORG):** la suma de la tabla de clasificación temática da **106** (105 a v15 + 1
  de P-ORG), mientras el correlativo global —la fuente de verdad por A22— da **107**.
  El descuadre de 1 nació en la reconciliación v14: una de las entradas 84–106 nunca
  se asignó a una categoría al recalcular la distribución. El conteo correlativo
  (1–107) es correcto y es la cifra válida; la clasificación es una vista derivada
  con un faltante de 1 por localizar. **No se corrige reasignando entradas
  históricas a ciegas** (violaría la regla de no reescribir entradas previas);
  queda como pendiente menor para una sesión de higiene del backlog: identificar la
  entrada huérfana entre 84–106 contra el detalle de cada traspaso v10–v14 y
  declarar su categoría con una nota, sin renumerar.
