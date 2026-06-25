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
> **Versión:** consolidado a v23 (2026-06-24). **Total reconciliado: 144 cambios.**

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
| 17 | v17 | 3 | 108–110 | Opus 4.8 | Consolidación backlog + suitedoc inline/saneamiento + suite standalone offline |
| 18 | v18 | 0 | — | Opus 4.8 | Cierre documental: backlog v17, traspasos s16/s17, escáner |
| 19 | v19 | 9 | 111–119 | Opus 4.8 | 9 ítems UI/UX del motor + cierre P-BACKLOG-INTEGRIDAD |
| 20 | v20 | 11 | 120–130 | Opus 4.8 | Tipografía (7 tokens) + lote UI directo (10 ítems) |
| 21 | v21 | 3 | 131–133 | Opus 4.8 | Polígono GSE en el radar + textos bloque azul/leyenda |
| 22 | v22 | 8 | 134–141 | Opus 4.8 | Refresco doc GSE + Batch A (lote directo) + Batch B (señalética/textos motor) |
| 23 | v23 | 3 | 142–144 | Opus 4.8 | Publicación lote s22 + higiene template + Batch C (#5/#8) + eliminación de rótulo |
| **Total** | | **144** | **1–144** | | |

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

## Clasificación temática (actualizada a v23, sobre 144 cambios)

> Taxonomía orgánica heredada de v09 (10 categorías), con dos categorías nuevas
> que emergen al consolidar v10–v14. Categorías mutuamente excluyentes por
> intención primaria. Porcentajes redondeados; la suma de redondeos puede no dar
> 100 exacto.

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 3% | Estructura canónica, stubs, git, repo remoto, orquestador run_all |
| Gobernanza de datos | 5 | 3% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore, gitignore inventarios scratch |
| Visualización / diseño — motor base/datos | 14 | 10% | Prototipo, motor base, nacional, GSE eje, drill-down, estética, radares, evolución, EntityModal |
| Visualización / diseño — rediseño UI | 47 | 33% | Rediseño 3 pantallas, auditoría de fidelidad, lote de corrección, barras vista histórica, pestaña SLEP, rampa de niveles + separador de dimensión (P-PALETA-v2), tanda s19 de 9 ítems UI/UX del motor (#111–119: ancla GSE primaria, signo %, definición abierta, techo 100, realce año vigente, media móvil, grados por EE, modal multiselección, botón comparador), lote UI directo s20 (#121–130: leyenda redundante, comunas por SLEP, nivel seleccionado, nombre completo rcard, definición estática, leyenda subdim, preliminar/significancia, comparador nombre/Territorio), s21 (#131–133: polígono GSE en el radar, texto del bloque azul, leyenda duplicada), s22 (#135–140: alto de barras, leyenda media móvil, tope comparador 4→10, color sin-diferencia, señalética sigdif temporal, etiqueta externa segmentos finos) y s23 (#142–144: anclas del indicador en una fila, etiquetas del radar sin colisión, eliminación del rótulo "Mirada integral") |
| Perfilado / exploración de datos | 4 | 3% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 15 | 10% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding, higiene andamios, renombrado de glosas, snapshot escáner, reorganización del directorio (P-ORG), consolidación del backlog a v16/107 (#108), tokenización tipográfica a 7 tokens --fs-* (P-TIPOGRAFIA, #120, s20), jerarquía `.axis-lab.b` por peso (#134, s22, cierra REVISAR s20) |
| Documentación conceptual / contenido | 10 | 7% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel, P-meta, texto "qué refleja un puntaje alto" por indicador (#141, s22, nivel indicador desde el corpus) |
| Pipeline / motor (código productivo) | 7 | 5% | Catálogos (33), lectura/normalización (34), exposición anio_traspaso (35), carga histórica 2014–2019, serie histórica server-side |
| Saneamiento / calidad de datos de presentación | 15 | 10% | Auditoría FASE I, correcciones H1-H8, tildes, dependencia vigente, saneamiento de nombres, bugfix dedup de establecimientos por RBD (#93, s12) |
| Deploy / publicación | 9 | 6% | Deploy Pages inicial, republicaciones, verificación byte a byte docs/, deploys s9–s14 |
| Verificación / auditoría (independiente) | 6 | 4% | Auditoría de integración histórica, censo de valores, fidelidad censal del build, auditoría de decimales nativos |
| Decisión / gobernanza de producto | 3 | 2% | Decisión de ponderación, decisión H-FID-2 (dependencia vigente), decisión de paleta del folleto |
| Documentación de proyecto (suite/política) | 4 | 3% | Suite `suitedoc` (4 HTML, v14) + P-DOC-RENDER (HTML autocontenidos + tema versionado, v15) + saneamiento del paquete `suitedoc` con inlining offline integrado (#109, v17) + regeneración de la suite como 4 standalone offline y retiro de `inline_suite.R` (#110, v17) |

> **Cierre P-BACKLOG-INTEGRIDAD (s19):** el faltante de 1 (tabla 109 vs correlativo 110) heredado de la reconciliación v14/v15 era el #93 (bugfix dedup de establecimientos por RBD, sesión 12), que quedó sin categoría al recalcular la distribución. Asignado a Saneamiento / calidad de datos de presentación (14→15). La tabla suma ahora 110 = correlativo global. Sin renumerar ni reasignar entradas históricas.

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
- **Sesión 17** (2026-06-22): cambios **108–110** (detalle en v17 §4). Consolidación del backlog, saneamiento del paquete `suitedoc` y regeneración de la suite: **108** consolidación del backlog a v16/107 (integración de la entrada 107/P-ORG que v16 declaró sin escribir; encabezado a v16/107, fila s16 en el resumen, clasificación "Limpieza/deuda técnica" 11→12, entrada cronológica s16, delta v16; entradas 1–106 verificadas idénticas por diff; commit `faefc93`); **109** P-SUITEDOC-INLINE + P-SUITEDOC-SANEAMIENTO (una solicitud —documentación compartible offline— ejecutada en dos encargos autónomos a Claude Code sobre el repo del paquete `herramientas_dev`/`suitedoc`): función `inlinar_suite()` exportada como post-proceso de responsabilidad única + flag `standalone` en `generar_suite()`, embebido de CSS/fuentes/logos como data: URIs e iconos lucide como `<svg>` desde `lucide-static` (sin `<script>` de red, 100% offline verificado por grep), más saneamiento (fix del warning de install por `%` sin escapar en `@title` de roxygen → A17-1; `.gitignore` del paquete; versionado completo; `limpiar_enlazados=TRUE` en standalone; validación temprana de iconos; `.SD_LUCIDE_VERSION="1.21.0"` fijada); 9 commits pusheados (`8ef4b2a..c8b3bd7`), paquete instalable desde cero; **110** regeneración de la suite de `slep_idps` con el paquete saneado (`documentar.R`: `standalone=TRUE`, barrido "colegio→establecimiento educacional" 11 usos, icono `sitemap`→`network` por inexistencia en lucide → A17-2) y retiro de `inline_suite.R` (obsoleto; el inlining lo hace ahora el paquete); 4 `*_standalone.html` regenerados offline (gitignorados, reproducibles con `documentar.R`); commit `055cbac`. (No-cambio de producto registrado por trazabilidad en v17 §4: barreras anti-error operativas `DISCIPLINA_OPERATIVA.md`/R1-R9 — gobernanza del asistente, no del producto; no entra al backlog de producto.)
- **Sesión 18** (2026-06-22): **sin avance del correlativo** (cierre documental; detalle en v18 §4–§5). Se escribieron en este archivo las entradas **108–110** (solicitudes de s17, ya contadas), se versionaron los traspasos s16/s17 (deuda A38, estaban untracked), se rotó el escáner (retención 2) y se eliminó un stray cruzado del proyecto hermano. Por la nota metodológica (consolidar el backlog es recursivo; el saneamiento documental no es producto nuevo), s18 **no agrega cambios al correlativo**: el total se mantiene en **110**. (El foco mayor propuesto por v17, P-DOC-SIMCE, se derivó a una sesión propia de `slep_simce_adecuado`; no es trabajo de idps.)
- **Sesión 19** (2026-06-23): cambios **111–119** (detalle en v19 §4 y en los logs `20260622_uiux_s19_fase123_log.md`, `20260623_mmovil_s19_log.md`, `20260623_comparador_s19_log.md`). Tanda de **9 ítems UI/UX del motor** desplegada en 3 encargos autónomos a Claude Code (fidelidad censal mismatch 0 verificada por panel adversarial independiente en cada encargo; parquet intacto `4c764d8c…`): **111** Ítem 1 — ancla "vs su GSE" primaria, sin slot muerto (no se renderiza cuando `difgru` es NA, antes degradaba a "sin dato"); **112** Ítem 2 — signo `%` en el número visible de las barras de niveles (`DistBar`); **113** Ítem 3 — definición "¿Qué mide…?" abierta por defecto, ancho completo y fuente 11.5→13px (`Definicion`); **114** Ítem 5 — envolvente 0–100 (`.ybar-track`) en la vista histórica para ver el faltante a 100; **115** Ítem 6 — preliminar sin atenuar (solo el sufijo `*`) + realce del último año con dato (`.is-latest`, outline del color del indicador); **116** Ítem 7 — media móvil centrada de 3 puntos como overlay (cómputo en cliente, función pura; ≥4 puntos, omite extremos, salta huecos estructurales; `MMOVIL_VENTANA=3`, `MMOVIL_MIN_PUNTOS=4`; D-s19-MMOVIL); **117** Ítem 8 — índice server-side `meta.grados_ee` (rbd→grados con dato, unión ind/dim/niv) + grados sin dato del EE desactivados en la ficha + cruce territorio→EE que cae al primer grado con dato (bugfix 8b reportado por el titular; D-s19-GRADOS-EE); **118** Ítem 9 — modo multiselección opt-in de `EntityModal` (clic togglea sin cerrar, tope 4 deshabilita el resto, "Listo"/Escape cierran; modo simple de navegación de ficha intacto; D-s19-MODAL-MULTI); **119** Ítem 10 — botón "+ agregar territorio" azul sólido (`--azul`) + botón reset (↺) que vacía territorios, visible solo con ≥1 (D-s19-BOTON-B). **Actos no correlativos de s19** (registrados por trazabilidad, no suman al global, como en s18): cierre **P-BACKLOG-INTEGRIDAD** (entrada huérfana #93 reasignada a Saneamiento 14→15; reconciliación de la vista derivada con el correlativo, ya reflejada en la tabla — no es entrada nueva) y versionado de la **deuda A38 de s18** (traspaso v18 + escáner que s18 dejó sin pushear; operativo). Ítems 4 (auditoría tipográfica) y 11 (lista de EE por segmento) diferidos a s20.
- **Sesión 20** (2026-06-23/24): cambios **120–130** (delta razonado en v20 §5; logs `20260623_tipografia_escala_log.md`, `20260623_fix_ancla_s7_1_log.md`, `20260624_s21_lote_directo_log.md` —pese a su nombre, su contenido es de s20, v20 §1). Tipografía + lote UI directo, desplegado: **120** P-TIPOGRAFIA (Ítem 4) — reemplazo de la escala de facto (19 valores de font-size) por **7 tokens `--fs-*`** (piso 11px, cuerpo 14px), ~88 declaraciones tokenizadas; el fix del **Bug s7-1 en `.ancla`** (comentario CSS con `*/` prematuro que descartaba la regla del CSSOM desde `00e567d`) fue bugfix hallado por Claude Code, NO reportado por el titular → no suma aparte (nota metodológica; va dentro de #120). **Lote UI directo, 10 ítems de presentación:** **121** elimina la leyenda redundante de indicadores (Panorama territorial); **122** comunas por SLEP en tercera línea (alfabético "A, B, C y D", solo SLEP); **123** "establecimientos en el nivel seleccionado" en la meta; **124** nombre completo del indicador en tarjetas rcard; **125** definición estática (negrita, color del indicador, sin toggle); **126** recorte de la leyenda de subdimensiones a "el tono lo da cada indicador"; **127** texto del `*` preliminar unificado; **128** texto de significancia unificado; **129** nombre completo del indicador en los th del comparador (wrap); **130** columna "Territorio" alineada a la derecha en el comparador. (No suman: el ítem #19 del lote fue solo diagnóstico —umbral de ancho del `StackedBar`, no de datos—, el fix .ancla es bugfix no-titular, y la consolidación del cronológico s18/s19 ejecutada también en s20 es trabajo recursivo.)
- **Sesión 21** (2026-06-24): cambios **131–133** (detalle en v21 y logs `20260624_poligono_gse_texto_leyenda_log.md`, `20260624_afinacion_textos_gse_log.md`, `20260624_diagnostico_gse_reconstruccion_log.md`, `20260624_deploy_push_s21_log.md`). Polígono GSE de referencia en el radar y textos asociados (fidelidad censal mismatch 0, panel adversarial independiente 0 mismatch en 366.384 filas; parquet intacto `4c764d8c…`; reabre la decisión de ponderación, `20260624_decision_poligono_gse_radar.md`): **131** polígono GSE de referencia en el radar (resuelve "captura 2") — campo server-side `prom_gse = round(prom_crudo − difgru, 0)` (reconstrucción EXACTA, signo fijado por `sign(difgru)==sign(sigdifgru)`, sd intra-grupo 0; solo 2024-2025, solo nivel indicador, solo donde hay difgru/cod_grupo); trazo punteado gris distinto del overlay temporal, leyenda "Promedio del mismo GSE"; se dibuja solo si los 4 indicadores tienen `prom_gse` (NA = supresión, nunca 0); **132** reescritura del texto del bloque azul de la ficha (describe el polígono GSE y la significancia; resuelve el pendiente "texto 3b" de v20); **133** eliminación de la leyenda de significancia duplicada de la ficha (conserva la del bloque azul; resuelve "3a"). **Actos no correlativos de s21** (registrados por trazabilidad, no suman): la **afinación de textos** (condicionar la frase de la línea punteada a la existencia de GSE + corregir 2 textos que negaban la representación del GSE) es refinamiento/coherencia del propio #132; los **diagnósticos read-only** (radar vs GSE; reconstrucción `prom_gse`) son análisis, no producto; la **decisión versionada** (reapertura ponderación) es la justificación del #131, no un cambio aparte; el **deploy + push** del día es operativo.
- **Sesión 22** (2026-06-24): cambios **134–141** (detalle en v22 §4 y en los logs `20260624_batch_a_s22_log.md`, `20260624_batch_b1_s22_log.md`, `20260624_batch_b2_s22_log.md`). Mejoras de presentación del motor en 3 encargos autónomos a Claude Code, **todas sin tocar datos** (parquet intacto `4c764d8c…`; Batch A y B1 con payload byte-idéntico; B2 con delta de payload acotado a solo `nivel_alto`, verificado estructuralmente, ninguna cifra cambió): **134** `.axis-lab.b` por peso (cierra REVISAR s20); **135** alto de barras `--yh` (152→168 / 118→130); **136** leyenda media móvil; **137** tope comparador 4→10 vía `CMP_MAX_TERR`; **138** color "sin diferencia" gris-azulado (`--st-neutro` `#8C8A86`→`#7E8A99`); **139** señalética sigdif temporal en `BarrasAnio` (lee `sigdif`, no `sigdifgru`); **140** etiqueta externa segmentos finos del comparador (`.s100-ext`, `<9%`); **141** texto "qué refleja un puntaje alto" por indicador (campo `nivel_alto`, nivel indicador, desde el corpus). **Actos no correlativos de s22** (no suman): #9 cerrado como no-implementado (decisión DS22-1, sin código); refresco de `documentar.R` (mantención de doc; expuso el contenido cruzado de SIMCE → P-DOC-CFG-CRUZADA); diagnósticos de zona previos a cada encargo. **Estado especial: nada commiteado al cierre de s22** (Batch A en 4 commits locales; B1/B2 en working tree); el commit y el deploy quedaron como pendiente del titular, ejecutado en s23.
- **Sesión 23** (2026-06-24): cambios **142–144** (detalle en v23 §4 y en los logs `20260624_commit_deploy_s22_log.md`, `20260624_higiene_batchc_s23_log.md`). Publicación del lote s22, higiene del template y Batch C (parquet intacto `4c764d8c…`; payload byte-idéntico en cada regeneración salvo el `nivel_alto` ya contado en s22; 0 errores de consola): **142** #5 — anclas del indicador (`.rcard-anc`) en una sola fila vía ensanche de la tarjeta (`.rcard max-width` 280→330, columnas laterales `minmax(320px,1fr)`, `.rquad` `gap:10px 50px` `max-width:1100`, breakpoint de colapso 760→1180; DEC-s23-2); **143** #8 — etiquetas de eje del radar sin colisión con las tarjetas laterales (sube `.rquad` column-gap 16→50px; SVG 300×300 intacto); **144** eliminación del rótulo "Mirada integral · 4 indicadores" (`<div className="fr-head">`, a pedido del titular; deja `.fr-head` huérfana → P-CSS-MUERTO). **Actos no correlativos de s23** (registrados por trazabilidad, no suman): **publicación del lote s22 #138–141** (ordenamiento por hunks con `git add -p` + build + deploy; `origin/main 41a3406→d35027a`; son ítems ya numerados en s22, no entradas nuevas); eliminación de **`PanelEvolucion`** (componente muerto desde P3-s9, higiene hallada por Claude Code, no solicitud del titular → no suma, como el fix `.ancla` en s20); corrección del **comentario obsoleto de `ScoreBar`** (coherencia con D7, solo comentarios, no producto); **P-DOC-REGEN** (regeneración de la suite, mantención de doc); el **deploy + push** de s23 (`d35027a→33ea07a`, operativo).

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

---

## Delta del backlog (consolidación v17)

- **+3 entradas** (108–110): consolidación del backlog a v16/107 (#108),
  P-SUITEDOC-INLINE + P-SUITEDOC-SANEAMIENTO (#109) y regeneración de la suite de
  `slep_idps` como standalone offline + retiro de `inline_suite.R` (#110). Total
  107 → **110**. Verificado contra el detalle cronológico (último #107 a v16), no
  contra la tabla heredada (A22).
- **Sin categorías nuevas:** #108 entra en "Limpieza / deuda técnica" (12 → 13);
  #109 y #110 en "Documentación de proyecto (suite/política)" (2 → 4). Ninguna
  categoría cruza el 25% ni cae bajo el 2% con estos cambios; sin subdivisión ni
  absorción.
- **#109 es trabajo sobre repo distinto (`herramientas_dev`/`suitedoc`)**, no sobre
  `slep_idps`. Se contabiliza aquí porque la solicitud del titular (documentación
  compartible offline de este proyecto) lo originó y su intención primaria es la
  herramienta de documentación de `slep_idps`; el detalle de ejecución del paquete
  vive en `suitedoc/dev_logs/` (no en este repo).
- **Cierre de la deuda de cierre de s17:** el traspaso v17 §5 declaró el total en
  110 con las entradas 108–110 descritas pero pendientes de escribir en este
  archivo (A22: no diferir el conteo). Esta consolidación las integra.
- **⚠️ Deuda de integridad heredada (sin cambios respecto a v16):** la suma de la
  tabla de clasificación temática sigue arrastrando el descuadre de 1 nacido en la
  reconciliación v14/v15 (una entrada de 84–106 sin categoría asignada). Con el
  delta v17 la tabla suma **109** (106 a v16 + 3 de v17) frente al correlativo
  **110**; el faltante de 1 es el mismo de v16, no uno nuevo (los 3 cambios de v17
  sí se clasificaron). El correlativo (1–110) es la cifra válida (A22); la
  clasificación es vista derivada con el faltante heredado por localizar
  (pendiente P-BACKLOG-INTEGRIDAD, sin renumerar entradas históricas).

---

## Delta del backlog (consolidación v19)

- **s18: +0 entradas.** Cierre puramente documental (escritura de 108–110 —ya
  contadas en s17—, versionado de traspasos s16/s17, rotación del escáner,
  eliminación de un stray cruzado). Por la nota metodológica y el criterio explícito
  del propio v18 (§4: "la numeración global del backlog NO avanza"; §5: "Delta v18:
  0 entradas nuevas"), s18 no aporta cambios al correlativo. Total a v18 = **110**.
- **s19: +9 entradas** (111–119): los 9 ítems UI/UX del motor (Ítems 1, 2, 3, 5, 6,
  7, 8, 9, 10). Total 110 → **119**. Verificado contra el detalle cronológico (último
  #110 a v17), no contra la tabla heredada (A22). Cada ítem es una solicitud
  distinguible que el titular enumeró (4 y 11 quedaron diferidos a s20); aunque se
  ejecutaron en 3 encargos autónomos y ~13 commits técnicos, se cuenta por solicitud,
  no por commit (nota metodológica). El bugfix 8b (cruce territorio→EE) iba dentro del
  Ítem 8 reportado por el titular, no se cuenta aparte.
- **Clasificación:** los 9 ítems entran en "Visualización / diseño — rediseño UI"
  (16 → 25): todos son presentación/UX del motor (ancla, barras, definición, media
  móvil, selector de grado, modal, botón). Ninguna categoría cruza el 25% (25/119 =
  21%) ni cae bajo el 2%; sin subdivisión ni absorción. (Los porcentajes de la tabla
  son indicativos —nota de la sección—; la fuente de verdad del cuadre es la columna
  N° contra el correlativo.)
- **Cierre de P-BACKLOG-INTEGRIDAD (integrado en s19, NO es entrada nueva):** la deuda
  de integridad heredada de v14/v15 (la tabla sumaba 109 vs correlativo 110) se cerró
  reasignando la entrada huérfana **#93** (bugfix dedup de establecimientos por RBD,
  s12) a "Saneamiento / calidad de datos de presentación" (14 → 15), dejando la tabla
  en 110 = correlativo ANTES de integrar los 9 ítems. Es una reconciliación de la
  vista derivada con el correlativo, no un cambio correlativo nuevo (no añade un #111
  propio). Tras integrar los 9 ítems, tabla y correlativo avanzan juntos a **119**. La
  deuda de integridad queda **CERRADA**: la suma de la tabla vuelve a cuadrar con el
  correlativo.
- **Deuda A38 de s18 versionada en s19:** acto operativo (versionar el traspaso v18 y
  el escáner que s18 dejó sin pushear); no entra al correlativo, igual que en s18.
- **Verificación de cuadre (cuatro totales):** suma de la columna N° de la tabla
  temática = **119**; correlativo global (detalle cronológico, último #119) = **119**;
  fila Total del resumen estadístico = **119**; encabezado del archivo = v19/**119**.
  Los cuatro cuadran.

---

## Delta del backlog (consolidación v21)

- **s20: +11 entradas** (120–130): P-TIPOGRAFIA (#120) + 10 ítems del lote UI directo
  (#121–130). Total 119 → **130**. Razonado en v20 §5; verificado contra el detalle
  cronológico (último #119 a v19), no contra la tabla heredada (A22). NO suman: el fix
  del Bug s7-1 en `.ancla` (bugfix hallado por Claude Code, no reportado por el titular),
  el ítem #19 del lote (solo diagnóstico) y la consolidación recursiva del cronológico
  s18/s19 (criterio v18).
- **s21: +3 entradas** (131–133): polígono GSE de referencia en el radar (#131), texto
  del bloque azul (#132) y eliminación de la leyenda duplicada (#133). Total 130 →
  **133**. NO suman: la afinación de textos (refinamiento de #132), los diagnósticos
  read-only (análisis), la decisión versionada (justificación de #131) y el deploy/push
  (operativo).
- **Clasificación:** #120 (tipografía) → "Limpieza / deuda técnica" (13 → 14:
  tokenización/refactor de la escala tipográfica a 7 tokens). #121–133 (10 del lote s20
  + 3 de s21) → "Visualización / diseño — rediseño UI" (25 → 38). Recalculada la columna
  % sobre 133.
- **⚠️ Observación de umbral:** "Visualización / diseño — rediseño UI" llega a **38/133
  = 29%**, cruzando el umbral del 25% que en deltas previos se vigilaba para subdivisión.
  NO se subdivide aquí: exigiría reclasificar entradas históricas (contra la regla
  append-only / A37). Queda **EN OBSERVACIÓN** para una sesión de higiene del backlog
  (mismo criterio con que v14 puso categorías en observación), p. ej. separar "tweaks de
  presentación" de "features de visualización" sin renumerar.
- **Verificación de cuadre (cuatro totales):** suma de la columna N° de la tabla temática
  = **133**; correlativo global (detalle cronológico, último #133) = **133**; fila Total
  del resumen estadístico = **133**; encabezado del archivo = v21/**133**. Los cuatro
  cuadran.

---

## Delta del backlog (consolidación v23)

> Esta consolidación integra **dos** sesiones que el maestro no había recogido: s22
> (cuyas piezas quedaron preparadas en el traspaso v22 pero no se escribieron aquí, por
> haber cerrado s22 con todo sin commitear) y s23. Verificado contra el detalle
> cronológico (último #133 a v21), no contra la tabla heredada (A22).

- **s22: +8 entradas** (134–141): #134 `.axis-lab.b` por peso; #135 alto de barras; #136
  leyenda media móvil; #137 tope comparador 4→10; #138 color sin-diferencia; #139
  señalética sigdif temporal; #140 etiqueta externa segmentos finos; #141 texto "qué
  refleja un puntaje alto". Total 133 → **141**. NO suman: #9 cerrado sin código
  (DS22-1), el refresco de `documentar.R` (mantención de doc) y los diagnósticos de zona.
- **s23: +3 entradas** (142–144): #142 anclas del indicador en una fila (#5); #143
  etiquetas del radar sin colisión (#8); #144 eliminación del rótulo "Mirada integral".
  Total 141 → **144**. NO suman: la publicación del lote s22 (#138–141 ya numeradas en
  s22), la eliminación de `PanelEvolucion` y la corrección del comentario de `ScoreBar`
  (higiene hallada por Claude Code, no solicitudes del titular; mismo criterio que el fix
  `.ancla` en s20), P-DOC-REGEN (mantención de doc) y el deploy/push (operativo).
- **Clasificación:** #134 → "Limpieza / deuda técnica" (14 → 15); #135–140 (6) y #142–144
  (3) → "Visualización / diseño — rediseño UI" (38 → 47); #141 → "Documentación
  conceptual / contenido" (9 → 10). Recalculada la columna % sobre 144 (cambia el
  denominador de todas las filas).
- **⚠️ Observación de umbral (continúa de v21/v22):** "Visualización / diseño — rediseño
  UI" pasa de 38/133 (29%) a **47/144 (33%)**. Sigue cruzando el 25% pero NO se subdivide:
  el backlog es append-only y la categoría es coherente por intención (presentación del
  motor). Permanece **EN OBSERVACIÓN** para una sesión de higiene del backlog (candidata a
  subdividir, p. ej. "comparador" vs "ficha/histórico", sin renumerar).
- **Verificación de cuadre (cuatro totales):** suma de la columna N° de la tabla temática
  = **144** (5+5+14+47+4+15+10+7+15+9+6+3+4); correlativo global (detalle cronológico,
  último #144) = **144**; fila Total del resumen estadístico = **144**; encabezado del
  archivo = v23/**144**. Los cuatro cuadran.
