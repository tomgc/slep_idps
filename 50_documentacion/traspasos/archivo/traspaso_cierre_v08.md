# Traspaso de cierre v08 — slep_idps

> **Sesión 8 (2026-06-20).** Cierre del rediseño a 3 pantallas: Fase 4
> (Comparación entre territorios), republicación a GitHub Pages, auditoría de
> fidelidad contra el handout de diseño, y corrección en lote de 35 de 36
> divergencias. Copia el backlog acumulativo íntegro 1-69 del v07 y agrega las
> entradas 70-77 de esta sesión. La confirmación visual de Pages queda
> deliberadamente pendiente como primer paso de la sesión 9.

---

## 1. Identificación

- **Proyecto:** `slep_idps` — motor IDPS nacional por establecimiento, segmentado por GSE.
- **Versión:** v08
- **Fecha:** 2026-06-20
- **Sesión:** 8, con foco en cerrar el rediseño a 3 pantallas (Fase 4 + revisión de fidelidad + deploy).
- **Entorno:** R 4.5.x / Positron (macOS aarch64); Git + GitHub Pages (`tomgc/slep_idps`); dual-Claude (este Claude analiza/instruye; Claude Code ejecuta en repo).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (Fase 4 + lote de fidelidad), `40_salidas/motor_idps.html` (regenerado `only=35`), `docs/index.html` (republicado 2 veces), logs de Fase 4 y auditoría de fidelidad.

---

## 2. Resumen ejecutivo

La sesión 8 cerró el rediseño a 3 pantallas que venía de la 7. Se evaluó y aprobó el log de Fase 3 (sin correcciones), se implementó y verificó la Fase 4 (pantalla "Comparación entre territorios": matriz GSE × indicador, cada celda % (n) de establecimientos por estado, hasta 4 territorios vía EntityModal, año más reciente del grado), y se republicó el motor a Pages. Al revisar lo publicado, el titular detectó que la implementación se había apartado del diseño original en varios puntos (el más grave: la pantalla de ficha sin buscador embebido). En vez de corregir punto por punto, se levantó una **auditoría de fidelidad** completa contra el handout (36 divergencias + 3 conflictos de invariante), el titular aprobó el lote, y se corrigieron 35 de 36 divergencias igualando al diseño, con tres excepciones resueltas por invariante de dato (C1 GSE absoluto y C2 subdimensión como puntaje: el motor está normativamente correcto, el handout quedó desfasado; C3 color de estado: el titular optó por igualar al diseño aceptando el solape con la paleta). El parquet `idps_largo` permaneció intacto (`50d9de4f…`) en toda la sesión: todo fue presentación, `only=35`. Quedó pendiente la confirmación visual del titular sobre Pages (primer paso de la sesión 9) y dos ajustes acotados (#24 texto "puntúa alto" del corpus, P5 carga histórica).

---

## 3. Estado al cierre

**Qué funciona** (última ejecución exitosa: regeneración `only=35` de esta sesión, motor en `origin/main` `7907fd1`):
- Las 3 pantallas del rediseño operativas y desplegadas en `https://tomgc.github.io/slep_idps/`: Panorama territorial (banner oscuro, GSE multi-select, barras apiladas), Panorama IDPS por establecimiento (buscador embebido + ficha todo-desplegado, vista actual/histórica), Comparación entre territorios (matriz GSE × indicador, abre vacía).
- Invariantes verificados: `B7AC96` = 0, paleta de indicadores intacta, cero agregación (celdas = conteo % (n)), md5 parquet `50d9de4f…`.

**Qué no funciona / pendiente:**
- Confirmación visual de Pages NO realizada (decisión del titular: dejarla para apertura de sesión 9).
- #24 (texto "qué caracteriza a un EE que puntúa alto"): no implementado. Existe en el corpus pero requiere ampliar el catálogo (script 33), fuera del alcance del lote de UI.

**Delta respecto a v07:** v07 dejó Fase 3 sin evaluar y `docs/` sin republicar; v08 evaluó Fase 3 (OK), ejecutó Fase 4, republicó `docs/` dos veces (deploy inicial + correcciones de fidelidad), y cerró la fidelidad al diseño con auditoría sistemática.

---

## 4. Registro detallado de cambios (sesión 8)

1. **Evaluación de Fase 3** (cambio 70). Se evaluó el log de Fase 3 contra los criterios de P1 y por verificación de código (no solo narrativa): saneamiento de nombres por bytes, barras = conteo, md5 intacto, sin GSE absoluto. Veredicto: cerró correctamente, sin correcciones. Hallazgo BAJA: comentario stale en el router (resuelto luego en el lote).

2. **Fase 4 — Comparación entre territorios** (cambio 71). Pantalla `comparar` implementada: matriz por sección GSE con filas = territorios (hasta 4) y columnas = 4 indicadores; cada celda es `StackedBar` de `repartoInd` (conteo de EE por `sigdifgru` ∈ {-1,0,1}, % (n)). Decisiones D-s8-1 a D-s8-5 (ver §8). EntityModal reutilizado para agregar territorios. Re-derivación a mano de una celda confirmó cero agregación. Commit `b1c84da`. md5 intacto.

3. **Deploy inicial a Pages** (cambio 72). `docs/index.html` republicado por copia byte a byte de `motor_idps.html` (Fases 1-4). Commit `1b6f03b`, push a `origin/main`. Resolvió la divergencia deliberada de `docs/` que arrastraba desde antes de Fase 1.

4. **Auditoría de fidelidad contra el handout** (cambio 73). Revisión sistemática read-only de las 3 pantallas (render en vivo + 4 PNG + funciones `renderX` + `PROMPT para Claude.md`), cruzada por 4 auditores + 1 crítico. Resultado: 36 divergencias (3 ALTA, 16 MEDIA, 17 BAJA) + 3 conflictos de invariante. Documento `20260620_auditoria_fidelidad_p3.md`.

5. **Lote de corrección de fidelidad** (cambio 74). 35 de 36 divergencias corregidas igualando al diseño: header lidera "Motor IDPS", nav sticky + acento coral, banner territorial, GSE multi-select, buscador embebido en ficha, comparar abre vacío, copys del handout, estado azul/gris/rojo (C3). Verificado 8/8 en navegador. Commit `2ba88f6`.

6. **C1/C2 mantenidos por invariante** (cambio 75). El handout pedía GSE absoluto sobre las barras (C1) y subdimensión como puntaje 0-100 (C2). Ambos violan invariantes de dato verificados contra `20260612_decision_ponderacion_idps.md` §5/§5.1 (derivar `prom − difgru` reconstruye el consolidado prohibido; la subdimensión es distribución, no puntaje). Se mantuvo el motor; el handout queda desfasado (ver pendiente del handout, §11).

7. **Republicación tras correcciones** (cambio 76). `docs/index.html` republicado de nuevo (byte-idéntico al motor corregido), más commit de la auditoría como evidencia histórica. Commits `9355b2e` (auditoría) + `7907fd1` (deploy). Push a `origin/main`.

8. **Cierre de sesión** (cambio 77). Traspaso v08 con backlog consolidado 1-77.

---

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

## 6. Bugs de la sesión 8

Sin bugs nuevos. La sesión fue de implementación verificada y corrección dirigida; las divergencias de fidelidad no son bugs (son desviaciones de la implementación respecto al diseño, capturadas por la auditoría). El comentario stale del router detectado en la evaluación de Fase 3 se corrigió en el lote (no llegó a producción como bug funcional).

---

## 7. Aprendizajes y restricciones descubiertas (sesión 8)

- **A-s8-1 (auditoría de fidelidad sobre corrección punto-por-punto).** Cuando hay múltiples divergencias entre implementación y un diseño de referencia aprobado, conviene auditar sistemáticamente contra el artefacto (patrón A19) y producir una lista única para aprobación en lote, en vez de corregir hallazgo por hallazgo. Contexto: el titular se rehúsa, con razón, a hacer de intérprete de su propio diseño; el handout es la fuente de verdad. Regla: ante "esto no es como lo diseñé", pedir el artefacto de diseño y auditar el conjunto, no parchar el síntoma reportado.

- **A-s8-2 (el diseño manda en lo visual; el invariante de dato manda sobre el diseño).** Un handout de diseño puede pedir, de buena fe, algo que el dato no sostiene (C1: GSE absoluto; C2: subdimensión como puntaje). La jerarquía correcta: igualar al diseño por defecto, PERO marcar como conflicto toda divergencia que exija violar un invariante de dato, y resolverla contra la fuente normativa (la decisión documentada), no contra el PNG. El handout, no el motor, es lo que se corrige.

- **A-s8-3 (verificar lo normativo contra la fuente, no la memoria).** Ante una duda de qué permite el dato de la Agencia (C1), no se improvisa: se lee la decisión cerrada (`20260612_decision_ponderacion_idps.md`). La decisión §5 prohíbe explícitamente derivar `prom − difgru`. El invariante "lee-no-deriva" no es preferencia estética: nace de que ninguna familia IDPS publica número de respondentes, lo que hace indefendible toda agregación o reconstrucción.

- **A-s8-4 (no mezclar cambio de UI con cambio de pipeline en un commit).** #24 (texto "puntúa alto") parecía un ajuste de ficha, pero requiere ampliar el catálogo (script 33) y regenerar `catalogo_idps.parquet`. Se difirió a un ciclo propio para no contaminar el lote de UI puro (md5 intacto). Regla: un cambio de dato/catálogo es temático distinto de un cambio de presentación; commits atómicos separados.

---

## 8. Decisiones de diseño (sesión 8)

- **D-s8-1 (año en comparar):** sin selector de año. `agnoCmp = grado_anios[cmpGrado].at(-1)`, igual para todos los territorios. Territorio sin EE ese año → celda "sin dato" (N=0), nunca se desliza a un año anterior (preserva comparabilidad y lee-no-deriva). Año preliminar → `*`.
- **D-s8-2 (nivel en comparar):** segmentador propio `cmpGrado` (4b/2m) en el banner, común a los territorios comparados.
- **D-s8-3 (selección de territorios):** EntityModal reutilizado; `addTerr` agrega (máx 4, sin duplicados por `kind+cod`). **Revisado en lote de fidelidad:** abre EN BLANCO (0 chips + invitación), no con el SLEP foco precargado.
- **D-s8-4 (meta de chip):** "N comunas · N establecimientos" del roster real, recomputado por nivel.
- **D-s8-5 (kind "slep"):** rama de filtrado por `cod_slep` (vive en `est[rbd]`) para comparar SLEPs arbitrarios.
- **D-s8-6 (C3, color de estado):** igualar al diseño — ▲ sobre = `#2A8FD9` (azul), = igual = `#8C8A86` (gris), ▼ bajo = `#EE2D49` (rojo). Alternativas: mantener rojo/gris/verde (evita solape con paleta de indicadores 4/1) vs igualar (fidelidad cromática). **El titular, como diseñador, optó por igualar**, aceptando el solape, a evaluar sobre lo publicado. La paleta de indicadores en sí no se tocó.
- **D-s8-7 (C1/C2, no igualar al diseño):** mantener el motor. El handout pide GSE absoluto (C1) y subdimensión como puntaje (C2), ambos prohibidos por `20260612_decision_ponderacion_idps.md`. El handout es lo desfasado.
- **D-s8-8 (#9, control Territorio):** mantener el EntityModal nacional estilizado como "Territorio" (no `<select>` plano de 4), por ser el motor nacional.

---

## 9. Constantes y parámetros vigentes (nuevos/cambiados en sesión 8)

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| Colores de estado | ▲ `#2A8FD9` / = `#8C8A86` / ▼ `#EE2D49` | `35_motor_template.html` | D-s8-6 (C3): igualados al diseño. Solapan con paleta indicadores 4/1 a propósito |
| Token acento coral | `#E88663` | `35_motor_template.html` | Subrayado de tab activa + borde hero (fidelidad #5) |
| `cmpTerr` (estado inicial) | `[]` (vacío) | `35_motor_template.html` | D-s8-3 revisado: comparar abre en blanco |
| `cmpGrado` / `panGrado` / `fichaGrado` | nivel independiente por pantalla | `35_motor_template.html` | Año fijo al más reciente del nivel; sin selector de año en ninguna |
| Token `--cmp-year` (2º trazo radar) | `#C77D3A` | `35_motor_template.html` | Movido de hardcode a `:root` (fidelidad #28) |
| Paleta indicadores | `#EE2D49 #FFC92E #9BC93E #2A8FD9` | `35_*` | 🔒 codificación de dato, intacta |
| `GRADOS_MOTOR` | `c("4b","2m")` | `10_configuracion.R` | Sin cambio |
| md5 `idps_largo.parquet` | `50d9de4f1fc80259d29f499cdf46d9e1` | `40_salidas/intermedios/` | Verificado intacto en toda la sesión 8 |

---

## 10. Arquitectura de archivos

Escáner al cierre: `estructura_actual.md` (2026-06-20 23:05, 25 carpetas / 149 archivos). Sin cambios estructurales: la sesión tocó solo `35_motor_template.html`, `motor_idps.html`, `docs/index.html` y agregó logs (Fase 4, auditoría). El template creció de 78.4K (v07) a 98.6K por el lote de fidelidad (banner territorial, buscador embebido, comparador, CSS de fidelidad). Estructura conforme a la política; sin deuda heredada nueva.

`origin/main` al cierre: `7907fd1`. Commits de la sesión: `b1c84da` (Fase 4), `1b6f03b` (deploy inicial), `2ba88f6` (lote fidelidad), `9355b2e` (auditoría doc), `7907fd1` (deploy correcciones).

---

## 11. Pendientes y ruta sugerida (sesión 9)

| ID | Pendiente | Tipo | Complejidad | Enfoque sugerido |
|---|---|---|---|---|
| **P0-s9** | **Confirmación visual del rediseño en Pages** | verificación | Baja | PRIMER PASO. El titular recorre `https://tomgc.github.io/slep_idps/` y aprueba o lista ajustes. Hasta entonces, el rediseño está desplegado pero no aprobado. Atención especial a C3 (solape de color estado/indicador) |
| **P5** | **Carga histórica IDPS 2014-2019** | funcionalidad (datos) | Alta | **PRIORIDAD 1 de la sesión 9** (foco datos, sesión dedicada). Primer paso obligatorio: inspeccionar un `.xlsx` por época en `/Users/tomgc/Desktop/idps` ANTES de tocar `34`. Decidir crosswalk de indicadores históricos, años con solo familia `rbd`, y patrón de nombre nuevo (el actual `PATRON_DATOS` solo soporta 2022-2025). NO integrar a ciegas (⚠️) |
| **#24** | Texto "qué caracteriza a un EE que puntúa alto" en la ficha | funcionalidad (catálogo) | Media | El texto existe en `idps_corpus_conceptual` (4 secciones, a nivel INDICADOR, no subdim). Ciclo propio: leer `33_construir_catalogos.R` → agregar campo `caracteriza_alto` al catálogo → re-correr 33 (regenera `catalogo_idps.parquet`, NO `idps_largo`) → renderizar en `rcard` del template. El corpus advierte: NO presentar a nivel subdimensión |
| **Handout-C1** | Corregir el handout de diseño (no el motor) | documentación | Baja | El handout pide GSE absoluto sobre barras / 2º trazo gris-GSE, que el invariante lee-no-deriva prohíbe. Documentar en el handout/diseño que el GSE absoluto NO se grafica, para que una futura sesión no reintroduzca la divergencia |
| **P6** | 45 definiciones de subdimensión sin acentuar | calidad de datos | Baja | Espera fuente acentuada del titular |

**Deuda técnica:** ninguna nueva crítica. El template a 98.6K es grande pero coherente; si crece más, evaluar separar CSS/JS en Fase de mantenimiento.

**Auditoría de cierre (política 5.6):** datos crudos aislados (Rama A pública) ✓; pipeline reproducible ✓; constantes nombradas ✓; estructura conforme ✓; sin tildes/ñ en nombres de archivo ✓. Sin respuestas "no".

**Ruta sugerida sesión 9:** (1) P0-s9 confirmación de Pages (apertura); (2) si hay ajustes, lote + republicar; (3) si aprueba, abrir P5 como sesión de datos dedicada (es el trabajo grande pendiente). #24 y Handout-C1 son ajustes acotados que pueden intercalarse o diferirse según prioridad del titular.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 La **paleta de 4 indicadores** (`#EE2D49 #FFC92E #9BC93E #2A8FD9`) es codificación de dato. Ningún ajuste visual la recolorea ni la re-mapea. (Nota: los colores de ESTADO ahora solapan con indicadores 4/1 por decisión D-s8-6; eso es del estado, no de la paleta.)
- 🔒 **Cero agregación territorial.** Barras y celdas son CONTEO de establecimientos por estado (% con n), nunca promedio.
- 🔒 **Lee, no deriva.** No reconstruir la línea absoluta del GSE (`prom − difgru` prohibido, decisión de ponderación §5). Ancla vs GSE solo a nivel indicador. Subdimensión es distribución, no puntaje. (C1/C2: el handout pide lo contrario; NO igualar.)
- 🔒 **Jerarquía de nombres de tres capas** (D-s7-4): caracterización para EE del SLEP; directorio saneado para el resto; prohibido corregir ortografía a ojo fuera del SLEP.
- 🔒 **Comentarios CSS sin la secuencia `*/` literal** (Bug s7-1).
- ✅ ANTES de cualquier corrección sobre el rediseño, esperar la confirmación visual del titular (P0-s9): el rediseño está desplegado pero no aprobado.
- ✅ ANTES de republicar `docs/`: confirmar `docs/index.html` == `motor_idps.html` por bytes.
- ✅ ANTES de cualquier diagnóstico de encoding: trabajar por bytes/codepoints sobre el dato crudo (locale C engaña).
- ✅ ANTES de tocar #24: leer `33_construir_catalogos.R` y verificar que el campo del corpus se mapea a nivel indicador (no subdimensión).
- ⚠️ NO regenerar `idps_largo` por un cambio de presentación: usar `only=35`.
- ⚠️ NO integrar los años históricos IDPS 2014-2019 a ciegas (P5): el `PATRON_DATOS` de `34` solo soporta 2022-2025; inspeccionar un xlsx por época antes de extender `34`. Archivos fuente en `/Users/tomgc/Desktop/idps`.

---

## 13. Fragmentos de código de referencia

```r
# only=35: regenerar SOLO el motor HTML, sin tocar el parquet (presentación).
# Verificar SIEMPRE md5 antes y después: debe ser 50d9de4f1fc80259d29f499cdf46d9e1.
source(here::here("00_build.R")); run_all(only = 35)
```

```r
# Republicar a Pages: docs/index.html NUNCA se edita a mano, solo se copia.
# Verificar identidad por bytes ANTES del push (✅ §12).
file.copy(here::here("40_salidas", "motor_idps.html"),
          here::here("docs", "index.html"), overwrite = TRUE)
# luego: md5 de ambos deben coincidir; recién entonces commit + push (push con OK explícito).
```

```
# C1/C2 (lo que el motor NO hace, por invariante de dato — decisión ponderación §5):
# - NO graficar "GSE n puntos" sobre las barras (sería prom − difgru, prohibido).
# - NO 2º trazo del radar en #B7AC96 (GSE absoluto). El 2º trazo = otro año del mismo EE.
# - NO graficar subdimensión como puntaje 0-100. Subdimensión = distribución de niveles (DistBar).
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 9 (Opus 4.8)`
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política + settings) vive en la knowledge base del Project y en `50_documentacion/activa/`; léelo desde ahí. La sesión 8 cerró con v08: rediseño a 3 pantallas COMPLETO (Fase 4 + auditoría de fidelidad + lote de corrección de 35 divergencias) y desplegado en Pages, pero la confirmación visual del titular quedó pendiente como PRIMER paso (P0-s9). El foco de la sesión 9 es: (1) confirmar visualmente el rediseño en `https://tomgc.github.io/slep_idps/` y, si hay ajustes, corregirlos en lote y republicar; (2) si OK, abrir P5 (carga histórica IDPS 2014-2019) como sesión de datos dedicada — prioridad 1. Adjunto el traspaso v08 y el escáner."
- **Documentos para la sesión 9:**
  1. *Protocolo en knowledge base* (NO se adjuntan; verificar al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` si corre en Claude Code; `34_leer_normalizar_idps.R` y un `.xlsx` histórico por época de `/Users/tomgc/Desktop/idps` si se ataca P5; `33_construir_catalogos.R` + `idps_corpus_conceptual.json` si se ataca #24.
  3. *Específicos de la sesión (SÍ se adjuntan):* el traspaso `traspaso_cierre_v08.md`; el escáner `estructura_actual.md`.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo.
