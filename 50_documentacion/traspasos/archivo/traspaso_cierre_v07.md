# Traspaso de cierre v07 — slep_idps

> **Cierre de sesión de rediseño (parcial).** La sesión 7 ejecutó tres de las
> cuatro fases del rediseño a 3 pantallas (handoff de Claude Design) y resolvió
> el saneamiento de nombres de establecimiento. Fases 1 y 2 quedaron con su log
> evaluado; la Fase 3 se ejecutó y generó su log, pero **ese log NO alcanzó a ser
> evaluado en esta sesión** (no llegó al contexto del asistente). El motor sigue
> **sin republicar** en `docs/` a propósito. Este traspaso consolida además el
> backlog acumulativo íntegro (v05 + delta s6 + delta s7), cerrando la deuda de
> backlog-por-referencia que arrastraba el v06.

---

## 1. Identificación

- **Proyecto:** slep_idps — motor nacional de Indicadores de Desarrollo Personal y
  Social (IDPS), Agencia de Calidad de la Educación. Dato por establecimiento,
  leído vs su GSE, sin agregación territorial. Hermano de `slep_categoria_desempeno`
  y `slep_simce_adecuado`.
- **Versión:** v07 (cierre de rediseño parcial; Fase 4 pendiente, Fase 3 sin evaluar).
- **Fecha:** 2026-06-20.
- **Sesión:** 7. Foco: rediseño del motor a 3 pantallas (handoff de Claude Design)
  por fases + saneamiento de nombres de establecimiento + consolidación del backlog.
- **Entorno:** R 4.5.x, Positron, macOS aarch64, zsh. Claude Code (Opus 4.8, modo
  autónomo). Rama A (datos públicos, raíz unificada). Motor HTML autocontenido
  React 18 + D3 v7 (Babel CDN), JSON→gzip→base64→pako inline.
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html`
  (de 56.9K a 79.3K: tres fases de rediseño), `30_procesamiento/35_generar_motor_html.R`
  (de 19.4K a 23K: saneamiento de nombres en Fase 3), `40_salidas/motor_idps.html`
  (regenerado, 4.64M). NUEVO insumo en uso: `20_insumos/auxiliares/caracterizacion_establecimientos.xlsx`
  (autoridad de nombres curados para EE del SLEP).
- **Registro de ejecución detallado:** `50_documentacion/andamios/logs/20260620_rediseno_fase1_log.md`,
  `20260620_rediseno_fase2_log.md`, `20260620_rediseno_fase3_log.md` (logs de las
  sesiones de Claude Code; el detalle paso a paso no se reproduce aquí). **El log de
  Fase 3 está SIN evaluar por el asistente: primera tarea de la sesión 8.**

---

## 2. Resumen ejecutivo

La sesión 7 transformó el motor de una sola pantalla (territorio→grilla→detalle con
drill-down) hacia el rediseño de 3 pantallas del handoff aprobado de Claude Design,
ejecutado por fases con encargos autónomos a Claude Code, cada uno auditado y
verificado en navegador. **Fase 1** (commit `0de6647`, log evaluado): andamiaje de
navegación con tabs + router + stubs. **Fase 2** (commit `71f4c1c`, log evaluado,
panel adversarial 5/5 PASA): pantalla ficha rediseñada al patrón todo-desplegado
(radar de 4 indicadores + paneles por indicador con dimensiones y subdimensiones +
toggle Vista actual/histórica). **Fase 3** (ejecutada, log generado, **NO evaluada**):
pantalla Panorama territorial (barras apiladas de distribución por estado vs GSE +
grilla con mini-radar) + saneamiento de nombres de establecimiento. El hito
metodológico de la sesión fue resolver, sin violar el contrato de datos, tres
divergencias del prototipo forzadas por el dato real (sin marca absoluta de GSE
sobre barras, ancla vs GSE solo a nivel indicador, subdimensión como distribución de
niveles) y una jerarquía de nombres de tres capas tras descubrir por bytes que el
directorio trae tres caracteres corruptos con semántica distinta (apóstrofo vs
comillas envolventes). Queda pendiente: evaluar el log de Fase 3, ejecutar Fase 4
(comparación entre territorios), y republicar `docs/` una vez aprobado todo el
rediseño. Este traspaso además consolida el backlog acumulativo íntegro (1-69).

---

## 3. Estado al cierre

**Qué funciona** (verificado en navegador en Fases 1 y 2; Fase 3 verificada por
Claude Code pero pendiente de evaluación del asistente):
- Motor en `40_salidas/motor_idps.html` (4.64 MB) con navegación por 3 tabs:
  Panorama territorial, Panorama IDPS por establecimiento, Comparación entre
  territorios.
- **Pantalla ficha (Fase 2):** radar de 4 indicadores (con comparación de 2 años del
  propio establecimiento), 4 paneles por indicador desplegando dimensiones y
  subdimensiones de una vez, toggle Vista actual/histórica. Asimetría de anclas
  correcta y verificada por panel adversarial: indicador 2 anclas (vs GSE + vs año),
  dimensión 1 ancla (solo vs año), subdimensión distribución de niveles.
- **Pantalla territorial (Fase 3, pendiente de evaluar):** según el encargo, secciones
  por GSE con barras apiladas de conteo de establecimientos por estado vs GSE + grilla
  de tarjetas con mini-radar; la grilla migró de la pantalla ficha a territorial.
- **Saneamiento de nombres (Fase 3, pendiente de evaluar):** jerarquía de tres capas
  (caracterización para EE del SLEP; directorio con reparación de caracteres corruptos
  para el resto).

**Qué NO está publicado** (deliberado):
- `docs/index.html` sigue en la versión previa al rediseño (la del v06, anterior
  incluso a Fase 1). Diverge a propósito de `40_salidas/motor_idps.html`. La
  republicación espera la aprobación visual del titular y el cierre de Fase 4.

**Qué está pendiente de verificación:**
- El **log de Fase 3** no fue evaluado por el asistente. No se puede afirmar que Fase 3
  cerró correctamente (saneamiento de nombres correcto por bytes, barras como conteo y
  no promedio, navegación sin regresión) hasta evaluarlo. Está en
  `50_documentacion/andamios/logs/20260620_rediseno_fase3_log.md`.

**Delta respecto a v06:** v06 dejó el motor de una pantalla con la ficha rediseñada de
piel pero sin reorganizar; el rediseño de 3 pantallas no existía. v07 ejecuta Fases
1-3 del rediseño (andamiaje + ficha todo-desplegado + territorial + saneamiento de
nombres), deja Fase 4 pendiente, y consolida el backlog íntegro que v06 dejó por
referencia.

---

## 4. Registro detallado de cambios (sesión 7)

Ver los logs de ejecución (§1) para el detalle exhaustivo por commit. Resumen por fase:

**Fase 1 — Andamiaje de navegación 3 pantallas** (`0de6647`, log evaluado):
estado `pantalla` (territorio|ficha|comparar, default ficha), barra de tabs `.screen-tabs`,
router por pantalla, picker movido a franja persistente `.picker-strip`, stubs para
territorial y comparar. La ficha actual se montó sin cambios en su rama. 6/6 criterios,
6/6 invariantes PASA. Decisión declarada: grado/año/GSE quedaron locales en la pantalla
(no se globalizaron al banner).

**Fase 2 — Pantalla ficha rediseñada** (`71f4c1c`, log evaluado, panel adversarial 5/5
PASA): nuevos componentes `Ficha`/`IndPanel`/`DimBlock`/`SubDist`/`ScoreBar`,
reorganizando la lógica ya auditada de `Detalle` (sin reescribirla) al patrón
todo-desplegado. Toggle Vista actual/histórica con `vistaFicha`. `ScoreBar` adaptado de
`bar0100` del prototipo ELIMINANDO el parámetro `gseRef` (la marca absoluta de GSE no
existe en el dato). Tonos de dimensión derivados del color del indicador (dentro de la
paleta). Eliminados `AnchorRow` y `SubdimView`. 8/8 criterios, 6/6 invariantes PASA.
Bug del comentario CSS resuelto (ver §6).

**Fase 3 — Panorama territorial + saneamiento de nombres** (ejecutada, log SIN evaluar):
según el encargo, construcción de la pantalla territorial (barras apiladas de conteo por
estado vs GSE con `stacked100` + grilla con mini-radar sin serie GSE absoluta), migración
de la grilla de ficha a territorial, y saneamiento de nombres con la jerarquía de tres
capas. Incluía una auditoría de bugs/errores/debilidades del motor completo y un commit
`docs()` de higiene de andamios/logs. **Pendiente de confirmar contra el log que todo esto
se ejecutó como se especificó.**

---

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

## 6. Bugs de la sesión 7 (causa raíz + regla aprendida)

1. **Regla CSS corrompida por `*/` en comentario (Fase 2).** Síntoma: la barra de
   identidad de la ficha (`.ficha-bar`) no tomaba fondo azul ni texto cream;
   `getComputedStyle` daba fondo transparente. Curiosamente `.ficha-card` (regla
   posterior) sí funcionaba. Causa raíz: un comentario CSS contenía la cadena
   `.ficha-*/.indp`; el `*/` dentro de `*/.indp` cerró el comentario antes de tiempo y
   el resto se interpretó como CSS basura que, por recuperación de errores del parser,
   se comió la regla `.ficha-bar`. Fix: reescribir el comentario sin la secuencia `*/`.
   Verificado con `getComputedStyle` (fondo `rgb(10,58,92)`, color cream). **Regla
   aprendida:** los comentarios CSS NUNCA deben contener la secuencia `*/` literal (ni
   siquiera como parte de un patrón de clase tipo `.x-*/.y`); rompe el comentario.
   Estado: resuelto.

**Fricción de diagnóstico (no bug, pero aprendizaje central):** el apóstrofo corrupto de
los nombres NO era un solo carácter (`0x5e`, como supuso el diagnóstico inicial del
asistente). El diagnóstico por bytes de Claude Code reveló una familia de tres: U+00B4
(´, acento agudo ×46) y U+005E (^, ×1) entre letras = apóstrofos; U+0060 (`, backtick
×118) ENVOLVIENDO el nombre = comillas. La corrección no es uniforme: depende del carácter
y su contexto (ver §7 y §8). **Regla:** el diagnóstico de encoding se hace por
bytes/codepoints sobre el dato real ANTES de escribir la regla de reparación, nunca por
inspección visual ni por el primer ejemplo observado.

---

## 7. Aprendizajes y restricciones descubiertas (sesión 7)

- **Diagnóstico de encoding por bytes antes de corregir.** El locale C engaña en la
  inspección visual (Bug 2 histórico). Confirmar la naturaleza real de un carácter
  corrupto (codepoint exacto, frecuencia, contexto) sobre el dato crudo antes de fijar la
  regla de reparación. Un carácter que "parece" un apóstrofo puede ser tres caracteres
  distintos con semántica distinta. Principio: B.1 (sin supuestos implícitos).
- **El prototipo de diseño usa datos sintéticos; su layout no es portable 1:1.** El
  `idps-demo.js` del handoff dibuja anclas y marcas que su generador por hash puede
  sostener pero el dato real no (marca absoluta de GSE, ancla vs GSE a nivel dimensión,
  puntaje de subdimensión). Portar un handoff de Claude Design al motor real exige
  filtrar cada elemento contra el contrato de datos: lo que el dato no publica, no se
  dibuja, aunque el prototipo lo muestre. Esto NO es recortar el diseño: es fidelidad a
  la fuente.
- **Jerarquía de autoridad de nombres multinivel.** Cuando una fuente curada cubre solo
  un subconjunto (caracterización = solo EE del SLEP) y la fuente general tiene defectos
  (directorio), la regla es: curada donde existe, general saneada (solo de corrupción
  objetiva, no de criterio ortográfico) donde no. Nunca corregir ortografía a ojo sobre
  datos no verificables (B.1).
- **Reparación de corrupción ≠ edición de contenido.** Reemplazar un carácter corrupto
  por su forma correcta (apóstrofo, comilla) es reparación segura y demostrable por bytes.
  Cambiar mayúsculas o agregar tildes sin fuente es edición de contenido, prohibida sin
  autoridad. La línea entre ambas debe quedar explícita en el encargo.

---

## 8. Decisiones de diseño (sesión 7)

**D-s7-1 — Rediseño completo a 3 pantallas, por fases, publicación postergada.** El
titular decidió adoptar el handoff de Claude Design completo (no solo la piel), aceptando
que tome varias sesiones y postergue la republicación de `docs/`. Alternativas
descartadas: solo piel sobre el motor de una pantalla (insuficiente); todo de una vez
(riesgo alto). Ejecución por 4 fases con encargos autónomos.

**D-s7-2 — Grado/año/GSE locales por pantalla, no globales al banner.** Diverge del
layout del handoff (donde Nivel vive en el banner común). Justificación: cada pantalla
puede mirar un grado distinto sin arrastrar el de otra; evita controles inertes en stubs.
Consecuencia: el segmentador Nivel se renderiza dentro de cada pantalla; en Fase 4
(comparación) esa pantalla tendrá su propio selector de grado.

**D-s7-3 — Tres divergencias del prototipo forzadas por el dato (invariante "lee, no
deriva"):**
- (a) **Sin marca absoluta de GSE sobre las barras.** El promedio absoluto del GSE no
  existe en el dato (las columnas de origen son `prom` del establecimiento, sin
  `prom_grupo`); dibujarlo exigiría derivar `prom − difgru`. El desvío vs GSE se comunica
  con anclas textuales. `ScoreBar` no porta el parámetro `gseRef` de `bar0100`.
- (b) **Ancla vs GSE solo a nivel indicador.** Verificado por panel adversarial sobre el
  parquet: `difgru/sigdifgru` a nivel dimensión es 100% NA (0 de 508.959 filas); a nivel
  indicador ~49.8% no-NA. La asimetría está forzada por el dato, no por la UI. Indicador:
  2 anclas. Dimensión: 1 ancla (solo vs año). Subdimensión: distribución.
- (c) **Subdimensión como distribución de niveles (% bajo/medio/alto), no puntaje.** El
  dato de subdimensión es distribución, no un `prom`. Se usa `DistBar`, no una barra de
  score.

**D-s7-4 — Jerarquía de nombres de tres capas.** (1) EE del SLEP Costa Central: nombre
verbatim de `caracterizacion_establecimientos.xlsx` (autoridad curada: tildes +
capitalización). (2) Resto del país: nombre del directorio con reparación de caracteres
corruptos. (3) Prohibido corregir mayúsculas/tildes a ojo fuera del SLEP. Alternativa
descartada: usar la caracterización para todo el país (no lo cubre). Las cifras no
cambian: es saneamiento de etiqueta.

**D-s7-5 — Reparación de caracteres corruptos por contexto.** U+00B4 (´) y U+005E (^)
entre letras → apóstrofo recto U+0027 (O'Higgins). U+0060 (`, backtick) que envuelve un
nombre → par de comillas dobles rectas U+0022. Backtick impar/suelto (sin par) → NO
adivinar: reportar como anomalía con RBD y nombre crudo, fallback a apóstrofo recto.
Verificación por bytes de que ningún nombre conserva U+00B4/U+005E/U+0060 tras la
reparación. **Decisión tomada en gate; pendiente de confirmar su implementación contra el
log de Fase 3.**

**D-s7-6 — Migración de la grilla de tarjetas de la pantalla ficha a la territorial.** La
grilla pasa a ser el contenido de la pantalla territorial; la ficha queda enfocada en el
EE seleccionado. **Pendiente de confirmar contra el log de Fase 3 que no introdujo
regresión de navegación.**

---

## 9. Constantes y parámetros vigentes (nuevos/cambiados en sesión 7)

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| Caracterización de nombres | `caracterizacion_establecimientos.xlsx` | `20_insumos/auxiliares/` | Autoridad de nombre para EE del SLEP (capa 1). Llave RBD character |
| Función de reparación de apóstrofo/comillas | por contexto (U+00B4/U+005E→', U+0060 envolvente→") | `35_generar_motor_html.R` | Capa 2 (resto del país). Reparación de corrupción, no edición |
| `vistaFicha` | `"actual"`/`"historica"` | `35_motor_template.html` | Estado del toggle de la ficha (Fase 2) |
| Paleta indicadores | `#EE2D49 #FFC92E #9BC93E #2A8FD9` | `35_*` | 🔒 codificación de dato, intacta (sin cambio) |
| `GRADOS_MOTOR` | `c("4b","2m")` | `10_configuracion.R` | Sin cambio desde v06 |
| md5 `idps_largo.parquet` | `50d9de4f1fc80259d29f499cdf46d9e1` | `40_salidas/intermedios/` | Verificado intacto en Fases 1-2; pendiente confirmar en Fase 3 |

---

## 10. Arquitectura de archivos

Escáner al cierre: `50_documentacion/estructura/estructura_actual.md` (2026-06-20 18:30,
25 carpetas / 146 archivos). Novedades estructurales de la sesión: `andamios/diseno/rediseno_3pantallas/`
(referencia de diseño del handoff: `idps-demo.js`, `Propuesta IDPS.html`, `Handout IDPS.html`,
`PROMPT para Claude.md`, `img/` con 4 capturas); tres logs nuevos en `andamios/logs/`
(fase1, fase2, fase3). El template creció a 79.3K y el generador a 23K. Estructura conforme
a la política (Rama A).

**Deuda de versionado a verificar:** el commit `docs()` de higiene del encargo de Fase 3
debía versionar `rediseno_3pantallas/` y los logs de Fases 1-2. Confirmar contra el log de
Fase 3 que se ejecutó. Los traspasos versionados en el repo llegan a v06; el v07 (este) y el
log de Fase 3 quedan por versionar al cierre real.

---

## 11. Pendientes y ruta sugerida (sesión 8)

| # | Pendiente | Tipo | Complejidad | Criterio de éxito |
|---|-----------|------|-------------|-------------------|
| P1 | **Evaluar el log de Fase 3** (`20260620_rediseno_fase3_log.md`) | bloqueante / verificación | Baja | Confirmar: nombres saneados correctos por bytes, barras = conteo no promedio, sin regresión de navegación, md5 parquet intacto, auditoría del Paso 7 sin hallazgos ALTA abiertos |
| P2 | **Fase 4 del rediseño: Comparación entre territorios** | feature | Alta | Hasta 4 territorios; matriz por GSE × indicador donde cada celda reparte el 100% de los EE en ▼/=/▲ como % (n); cero agregación; mini-radar/barras sin GSE absoluto |
| P3 | Revisión visual del titular del rediseño completo (3-4 pantallas en vivo) | mejora visual | — (del titular) | El titular aprueba o lista ajustes concretos |
| P4 | Republicar `docs/` (= `motor_idps.html`) + escáner | cierre | Baja | `docs/index.html` == `motor_idps.html`; push; Pages sirve la versión nueva |
| P5 | **Años históricos IDPS 2014-2019** (sesión de datos dedicada) | feature datos | Alta | Extender `34` con nuevo patrón de nombre + crosswalk histórico + manejo de años con solo familia rbd; inspeccionar un xlsx por época antes de re-correr 34 |
| P6 | 45 definiciones largas sin acentuar | deuda de datos | Media | Titular provee fuente acentuada; aplicar con verificación por bytes + P-meta 1:1 |
| P7 | Versionar v07 + log de Fase 3 + verificar higiene de andamios | higiene git | Baja | `git status` limpio salvo `.claude/`; traspasos al día en el repo |
| P8 | Subdividir categoría Visualización/diseño en el backlog (supera 25%) | deuda documental | Baja | Taxonomía con la categoría partida en "motor base/datos" y "rediseño UI" |

**Ruta sugerida sesión 8:** P1 (evaluar log Fase 3, es bloqueante: define si Fase 3 cerró
bien o necesita correcciones) → si Fase 3 OK, P2 (Fase 4 comparación) → P3 (revisión visual
del titular del rediseño completo) → P7 (higiene) → P4 (republicar). P5 (años históricos) es
una sesión de datos propia, no mezclar con el rediseño. P6 espera fuente del titular.

**Auditoría de cierre (5.6):** las cifras son reproducibles e idempotentes (md5 verificado
en Fases 1-2; pendiente confirmar Fase 3); decisiones metodológicas como constantes nombradas
(sí); nombres de archivo sin tildes/ñ (sí; la caracterización es insumo heredado, excepción
declarada). Pendiente "no" a resolver en sesión 8: confirmar que Fase 3 mantuvo el md5 del
parquet (el saneamiento de nombres es `only=35`, no debería tocarlo, pero hay que verificarlo
en el log).

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 La **paleta de 4 indicadores** (`#EE2D49 #FFC92E #9BC93E #2A8FD9`) es codificación de
  dato. Ningún ajuste visual la recolorea ni la re-mapea.
- 🔒 **Cero agregación territorial.** Las barras apiladas de la pantalla territorial son
  CONTEO de establecimientos por estado (% con n), nunca promedio. La comparación de Fase 4
  es % (n), nunca media de puntajes.
- 🔒 **Lee, no deriva.** No reconstruir la línea absoluta del GSE (`prom − difgru` prohibido).
  El ancla vs GSE solo existe a nivel indicador (a nivel dimensión el dato es 100% NA).
  Subdimensión es distribución, no puntaje.
- 🔒 **Jerarquía de nombres de tres capas** (D-s7-4): caracterización para EE del SLEP;
  directorio saneado para el resto; prohibido corregir ortografía a ojo fuera del SLEP.
- 🔒 **Comentarios CSS sin la secuencia `*/` literal** (Bug s7-1).
- ✅ ANTES de evaluar Fase 3: leer el log completo y verificar por bytes que los nombres
  quedaron correctos (ningún U+00B4/U+005E/U+0060 residual), que el md5 del parquet no
  cambió, y que la migración grilla→territorial no rompió navegación.
- ✅ ANTES de republicar `docs/`: confirmar `docs/index.html` == `motor_idps.html` (hoy
  divergen a propósito desde antes de Fase 1).
- ✅ ANTES de cualquier diagnóstico de encoding: trabajar por bytes/codepoints sobre el dato
  crudo, nunca por inspección visual (locale C engaña).
- ⚠️ NO regenerar `idps_largo` por un cambio de presentación: usar `only=35`. El saneamiento
  de nombres es presentación.
- ⚠️ NO integrar los años históricos IDPS 2014-2019 a ciegas: el patrón de nombre actual
  (`PATRON_DATOS` en `34`) solo soporta 2022-2025; inspeccionar un xlsx por época antes de
  extender `34`.

---

## 13. Fragmentos de código de referencia

```r
# Jerarquía de nombres de tres capas (patrón objetivo en 35_generar_motor_html.R).
# Capa 1: caracterización (EE del SLEP). Capa 2: directorio saneado (resto). Capa 3: fallback.
# Las CIFRAS no se tocan; esto es etiqueta de presentación. Verificar por bytes el resultado.
nombre_presentacion <- dplyr::coalesce(
  nombre_caracterizacion,           # capa 1: verbatim curado (solo RBD del SLEP)
  sanear_nombre(nombre_directorio), # capa 2: reparación de corrupción (resto del país)
  nombre_idps_largo                 # capa 3: fallback si el directorio no cubre el RBD
)
```

```r
# Reparación de caracteres corruptos por contexto (D-s7-5). Repara corrupción, NO edita
# ortografía. Backtick impar => reportar anomalía, no adivinar.
# U+00B4 (´) y U+005E (^) entre letras -> apóstrofo U+0027 ('): O'Higgins
# U+0060 (`) que ENVUELVE -> par de comillas dobles U+0022 ("): "ARMANDO CARRERA GONZALEZ"
# Verificación post: ningún nombre conserva U+00B4/U+005E/U+0060.
```

```js
// ScoreBar (Fase 2): barra 0-100 SIN marca absoluta de GSE (a diferencia de bar0100 del
// prototipo). El promedio absoluto del GSE no existe en el dato; el desvío va por ancla textual.
// NO portar el parámetro gseRef ni el markup .bar-gse.
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 8 (Claude Opus 4.8)`
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política + settings)
  vive en la knowledge base del Project y en `50_documentacion/activa/`; léelo desde ahí. La
  sesión 7 cerró con v07: rediseño del motor a 3 pantallas, Fases 1-3 ejecutadas (andamiaje +
  ficha todo-desplegado + pantalla territorial + saneamiento de nombres), pero el **log de
  Fase 3 quedó SIN evaluar** (primera tarea) y `docs/` NO republicado. El foco de la sesión 8
  es: (1) evaluar el log de Fase 3 y confirmar que cerró bien; (2) si OK, ejecutar Fase 4
  (Comparación entre territorios); (3) revisión visual del rediseño completo; (4) cerrar de
  verdad (republicar docs/ + traspaso v08). Adjunto el traspaso v07, el escáner re-corrido y
  el log de Fase 3 para evaluar."
- **Documentos para la sesión 8:**
  1. *Protocolo en knowledge base (NO se adjuntan; verificar que estén al día):*
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, y
     `encargo_autonomo_claude_code_v1.md` (instrumento de encargos a Claude Code).
  2. *Opcionales según foco:* `CLAUDE.md` si corre en Claude Code; los logs de Fases 1-2 si se
     necesita el detalle del rediseño ya evaluado.
  3. *Específicos de la sesión (SÍ se adjuntan):* este traspaso v07; el escáner
     `estructura_actual.md`; **el log de Fase 3** `20260620_rediseno_fase3_log.md` (crítico:
     es lo primero a evaluar); `35_motor_template.html` y `35_generar_motor_html.R` si se itera
     la UI en Fase 4; la referencia de diseño `rediseno_3pantallas/idps-demo.js` (función
     `renderComparar`) y la captura `img/03-comparar.png` para Fase 4.
- **Nota final:** si algún archivo cambió entre sesiones, adjuntar la versión más actualizada
  al abrir y avisarlo. El log de Fase 3 es la pieza bloqueante: sin evaluarlo no se sabe si
  Fase 3 cerró bien ni se puede avanzar con confianza a Fase 4.

---
*Fin del traspaso v07 — cierre de rediseño parcial (Fases 1-3) de la sesión 7.*
