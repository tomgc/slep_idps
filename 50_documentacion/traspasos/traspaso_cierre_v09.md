# Traspaso de cierre — slep_idps — v09

> **Sesión 9 (2026-06-21).** Cierre de dos correcciones de fidelidad sobre el
> motor desplegado: (1) la vista histórica de la ficha pasó de líneas de
> tendencia a barras verticales por año (alineada al diseño); (2) el selector
> territorial ganó una pestaña SLEP con el año de traspaso como etiqueta de
> contexto. Ambas desplegadas a Pages y confirmadas visualmente por el titular.
> La compuerta P0-s9 (confirmación visual del rediseño) quedó cerrada en esta
> sesión. Backlog 1-77 (heredado de v08) + entradas 78-83.
>
> **Registro de ejecución detallado:**
> `50_documentacion/andamios/logs/20260621_vista_historica_barras_log.md` y
> `50_documentacion/andamios/logs/20260621_pestana_slep_selector_log.md`
> (logs de las dos sesiones de Claude Code; detalle paso a paso no reproducido
> aquí).

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, Rama A pública).
- **Versión:** v09. **Fecha:** 2026-06-21. **Sesión:** 9.
- **Foco:** dos correcciones de fidelidad de UI sobre el motor desplegado (vista histórica → barras por año; pestaña SLEP en selector territorial), con cierre de la compuerta P0-s9.
- **Entorno:** R 4.5.x / Positron (macOS aarch64); Claude Code autónomo para terminal/git/edición; despliegue GitHub Pages (`docs/index.html` desde `main`).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html`, `30_procesamiento/35_generar_motor_html.R`, `40_salidas/motor_idps.html`, `docs/index.html`. Se agregaron dos logs y se versionaron dos encargos.

---

## 2. Resumen ejecutivo

La sesión 9 abrió desde v08 con la compuerta P0-s9 pendiente (confirmar visualmente el rediseño desplegado). El titular confirmó el rediseño y, en lugar de abrir de inmediato P5 (carga histórica), introdujo dos correcciones de fidelidad. La primera: la vista histórica de la ficha renderizaba líneas de tendencia (`PanelEvolucion`) cuando el diseño aprobado pedía barras verticales discretas por año; se diagnosticó como sustitución de componente (el CSS `.ybars` ni existía en el motor), se reemplazó por un componente nuevo `BarrasAnio` (CSS puro, eje fijo 0-100, año preliminar atenuado, marca de tendencia leída de la Agencia), anidando indicador → dimensión y omitiendo subdimensión por invariante (decisión del titular, coherente con C2/D-s8-7). La segunda: el selector territorial ganó una pestaña SLEP con el año de traspaso como etiqueta de contexto, lo que exigió exponer `anio_traspaso` en `DATA.sleps` (el generador no lo proyectaba, aunque el dato ya vivía en `sleps_chile.parquet`). Ambos trabajos se ejecutaron con el patrón de encargo autónomo, verificaron todos sus invariantes (en particular: parquet `idps_largo` intacto en `50d9de4f…`, y el año de traspaso como etiqueta, NUNCA filtro — un SLEP de 2026 muestra su serie 2022-2025), se desplegaron a Pages y se confirmaron visualmente. El repo quedó completamente sellado (motor, deploys, logs, encargos y snapshot de estructura versionados y pusheados). Queda P5 (carga histórica IDPS 2014-2019) como la próxima sesión de datos dedicada.

---

## 3. Estado al cierre

- **Qué funciona:** el motor desplegado en `https://tomgc.github.io/slep_idps/` con las tres pantallas del rediseño confirmadas por el titular. Vista histórica de la ficha con barras verticales por año (indicador → dimensión). Selector territorial con pestañas Comuna · SLEP · Región · Dependencia · Establecimiento; la pestaña SLEP lista los 36 SLEPs con "Traspaso AAAA". Última ejecución exitosa: `run_all(only=35)` 2026-06-21, md5 del parquet intacto. `origin/main` en `ae174ce`.
- **Qué no funciona:** nada reportado. 0 errores de consola en ambas verificaciones.
- **Delta respecto a v08:** dos correcciones de fidelidad (barras vista histórica, pestaña SLEP) + exposición de `anio_traspaso` en el generador. La compuerta P0-s9 (pendiente desde v08) quedó cerrada: el titular confirmó el rediseño y las dos correcciones. El template creció de 98.6K a ~100K+ por el componente de barras y la rama SLEP.

---

## 4. Registro detallado de cambios (sesión 9)

**Cambio 78 — Confirmación visual del rediseño en Pages (P0-s9 cerrada).** El titular recorrió el motor desplegado y confirmó las tres pantallas del rediseño como correctas. Cierra la compuerta que venía pendiente desde v08. Categoría: Deploy / publicación. Sin código.

**Cambio 79 — Vista histórica de la ficha: barras por año (reemplaza líneas).** Diagnóstico (read-only, contra `Propuesta_IDPS.html` + el motor): la vista histórica usaba `PanelEvolucion` (líneas D3) donde el diseño pide barras verticales por año; el CSS `.ybars` no existía en el motor (`grep`=0). Causa raíz: sustitución de componente, no ajuste de estilo. Solución: componente nuevo `BarrasAnio` (CSS puro como el diseño, no D3), eje fijo 0-100, hueco sin barra (no interpola), año preliminar atenuado + discontinuo + `*`, más `HistTrend` (marca de tendencia en cabecera que usa el `dif`/`sigdif` leído de la Agencia, no la resta visual de las barras). Anidamiento indicador → dimensión; subdimensión NO entra (decisión del titular, coherente con C2/D-s8-7 — subdimensión es distribución, no puntaje). `PanelEvolucion` quedó huérfano (conservado con comentario por reversibilidad). Verificado en navegador (EE con hueco 2024 y año 2025 preliminar; alturas medidas proporcionales). Commits `bbeacde` (CSS), `e6fb5ce` (componente), `6edfeaf` (sustitución). Categoría: Visualización / diseño — rediseño UI. Referencia: log `20260621_vista_historica_barras_log.md`.

**Cambio 80 — Deploy de las barras a Pages.** `run_all(only=35)` (`c407d65`), republicación byte-idéntica de `docs/index.html` (`dd480fb`), commit del log (`7b2cc36`), push. md5 parquet intacto; `docs ≡ motor` (`db9e8173…`). Categoría: Deploy / publicación.

**Cambio 81 — Exponer `anio_traspaso` en `DATA.sleps` (generador).** El dato vivía en `sleps_chile.parquet` (constante por SLEP) pero `35_generar_motor_html.R` no lo proyectaba al JSON embebido. Solución: `left_join` localizado en `sleps_lst` con `distinct(SLE, cod_slep, anio_traspaso)` (enfoque acotado, sin tocar `est_attr` para no acoplar otras proyecciones). Verificado: `DATA.sleps` (36 SLEPs) trae el campo, distribución por año idéntica al parquet. Commit `b2b74d5`. Categoría: Pipeline / motor (código productivo, capa generador).

**Cambio 82 — Pestaña SLEP en el selector territorial.** `TABS` territorial reordenado a Comuna · SLEP · Región · Dependencia · Establecimiento (Dependencia conservada, no eliminada); rama `tab==="slep"` en `buildList` (reusa el patrón del comparador) con `sub:"Traspaso "+anio`; `SLEPS_OPTS` extendido con `anio` (compartido con el comparador, que lo ignora); `searchPlaceholderFor` para SLEP; `onPick`/`unidades`/`terrTxt` manejan `kind:"slep"` filtrando por `cod_slep` SIN comparación con `anio_traspaso` (🔒-DOM). Verificado: SLEP de traspaso 2026 muestra serie 2025 completa; etiquetas correctas; buscador filtra. Commit `3a9cce2`, build `0c8eb85`. Categoría: Visualización / diseño — rediseño UI. Referencia: log `20260621_pestana_slep_selector_log.md`.

**Cambio 83 — Deploy de la pestaña SLEP + sellado de cierre.** Republicación byte-idéntica de `docs/` (`e18b866`), commit del log (`d44c4a0`), push; luego versionado de los dos encargos de la sesión (`e3c0a42`) y del snapshot de estructura (`ae174ce`). md5 parquet intacto; `docs ≡ motor` (`4317a76d…`). Categoría: Deploy / publicación.

---

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

## 6. Bugs de la sesión 9

Sin bugs nuevos. Las dos correcciones fueron desviaciones de fidelidad respecto al diseño aprobado (la vista histórica implementada como líneas en vez de barras), no errores funcionales. Se diagnosticaron read-only antes de tocar código (A-s8-1 aplicado) y se corrigieron como sustitución dirigida.

---

## 7. Aprendizajes y restricciones descubiertas (sesión 9)

- **A-s9-1 (verificar la existencia del dato antes de prometer la etiqueta).** Antes de redactar el encargo de la pestaña SLEP, se verificó (read-only) si `anio_traspaso` existía en el dato y dónde. Resultó estar en el parquet pero NO expuesto al cliente por el generador. Saltarse esa verificación habría llevado a un encargo que asumía presentación pura cuando en realidad tocaba el generador. Regla: cuando una etiqueta nueva depende de un campo, confirmar dónde vive ese campo (parquet, JSON embebido, xlsx aguas arriba) ANTES de fijar el alcance del encargo (B.1).

- **A-s9-2 (el año de traspaso es etiqueta de contexto, no filtro temporal).** El `anio_traspaso` de un SLEP se muestra como dato informativo pero NUNCA recorta qué años se atribuyen al SLEP: un SLEP agrupa toda su serie histórica como propia, incluidos los años anteriores a su traspaso (los resultados IDPS 2025 de un EE traspasado en 2026 SÍ se agrupan bajo ese SLEP). Coherente con D-s8-5 (el comparador agrupa por `cod_slep` sin filtrar por año) y con la nota del motor de categoría. Regla: el año de traspaso jamás entra a una comparación que filtre la serie; solo se renderiza como etiqueta.

- **A-s9-3 (distinguir sustitución de componente de ajuste de estilo).** Ante "no se parece en nada al diseño", el diagnóstico read-only reveló que el componente era otro (líneas vs barras), no que los estilos estuvieran mal: el CSS de barras ni existía en el motor. La corrección correcta es reemplazar el componente, no parchar el existente. Regla: ante una divergencia visual grande, comparar QUÉ componente renderiza cada lado antes de asumir que es cuestión de CSS.

- **A-s9-4 (el motor de IDPS y el de categoría comparten andamio pero no código literal).** El selector que el titular quería "como en categoría" YA EXISTÍA en IDPS (mismo `EntityModal`, mismo andamio de origen), solo que parametrizado distinto y con la pestaña SLEP solo en el comparador. Y el de categoría es código transpilado (`React.createElement`), no copiable al motor de IDPS (JSX + Babel). Regla: antes de portar de un motor hermano, verificar si el patrón ya existe en el destino y si el origen es fuente o transpilado (A34/A37).

---

## 8. Decisiones de diseño (sesión 9)

- **D-s9-1 (subdimensión fuera del histórico):** la vista histórica anida solo indicador → dimensión; la subdimensión NO se grafica. Alternativa: incluirla como pide el diseño. Rechazada: subdimensión es distribución de niveles, no puntaje (invariante), y graficarla como barra de puntaje violaría C2/D-s8-7 (conflicto ya resuelto a favor del invariante). El titular confirmó esta decisión explícitamente. La distribución de subdimensiones sigue viéndose en la Vista actual.

- **D-s9-2 (barras CSS puro, no D3):** `BarrasAnio` se implementó con CSS (`position`/`height %`) como el diseño, no con SVG/D3. Alternativa: D3 (como el viejo `PanelEvolucion`). Rechazada: el diseño dibuja las barras con CSS; replicarlo da fidelidad exacta y evita un `useEffect`/SVG por panel.

- **D-s9-3 (tendencia leída, no derivada de las barras):** la marca `HistTrend` usa el `dif`/`sigdif` leído de la Agencia (p. ej. -14), no la resta visual de las alturas (p. ej. -19). Implicancia: el número de la tendencia puede no "cuadrar" con la diferencia visible de las barras; es correcto por 🔒 lee-no-deriva. El `title` del tooltip aclara que es leído de la Agencia.

- **D-s9-4 (Dependencia sobrevive al reorden):** el selector territorial igualó el orden de pestañas a categoría (Comuna · SLEP · Región · …) PERO conservó la pestaña Dependencia, que IDPS usa y categoría no tiene. Alternativa: replicar categoría exactamente (sin Dependencia). Rechazada: sería regresión, no mejora. Recomendación aplicada: añadir SLEP, no quitar Dependencia.

- **D-s9-5 (join localizado en `sleps_lst`, no en `est_attr`):** `anio_traspaso` se expuso con un `left_join` acotado a la lista de SLEPs, no añadiendo la columna a `est_attr` (que alimenta varias proyecciones). Motivo: evitar acoplar/inflar proyecciones que no necesitan el campo. `anio_traspaso` es constante por SLEP, así que el `distinct` no multiplica filas.

- **D-s9-6 (SLEPS_OPTS compartido, extendido):** la pestaña SLEP reusa el `SLEPS_OPTS` del comparador, extendido con `anio`, en vez de una proyección territorial aparte. El comparador ignora el campo nuevo (sin regresión). Menos duplicación.

---

## 9. Constantes y parámetros vigentes (nuevos/cambiados en sesión 9)

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `TABS` territorial | `comuna · slep · region · dependencia · establecimiento` | `35_motor_template.html` | D-s9-4: reordenado a categoría + SLEP; Dependencia conservada. Tab inicial pasó de Región a Comuna (efecto del reorden) |
| Etiqueta SLEP en selector | `"Traspaso " + anio_traspaso` | `35_motor_template.html` | D-s9-* / 🔒-DOM: etiqueta de contexto, no filtro |
| `DATA.sleps` (campos) | `cod_slep, nombre_slep, cod_reg, anio_traspaso` | `35_generar_motor_html.R` | +`anio_traspaso` (D-s9-5) |
| `SLEPS_OPTS` (campos) | `{cod, nom, ee, ncom, anio}` | `35_motor_template.html` | +`anio` (D-s9-6, compartido con comparador) |
| Componente histórico | `BarrasAnio` + `HistTrend` (CSS puro) | `35_motor_template.html` | D-s9-2/D-s9-3; reemplaza `PanelEvolucion` (huérfano) en el histórico |
| Paleta indicadores | `#EE2D49 #FFC92E #9BC93E #2A8FD9` | `35_*` | 🔒 codificación de dato, intacta |
| md5 `idps_largo.parquet` | `50d9de4f1fc80259d29f499cdf46d9e1` | `40_salidas/intermedios/` | Verificado intacto en toda la sesión 9 (ambos trabajos) |

---

## 10. Arquitectura de archivos

Escáner al cierre: `estructura_actual.md` (2026-06-21 12:19, sellado y versionado en `50_documentacion/estructura/`). La sesión tocó `35_motor_template.html`, `35_generar_motor_html.R`, `motor_idps.html`, `docs/index.html`, agregó dos logs en `andamios/logs/` y versionó dos encargos en `activa/`. Estructura conforme a la política; sin deuda heredada nueva.

`origin/main` al cierre: `ae174ce`. Commits de la sesión, en orden: `bbeacde` (CSS barras), `e6fb5ce` (componente BarrasAnio), `6edfeaf` (sustitución histórica), `c407d65` (build barras), `dd480fb` (deploy barras), `7b2cc36` (log barras), `b2b74d5` (anio_traspaso generador), `3a9cce2` (pestaña SLEP), `0c8eb85` (build SLEP), `e18b866` (deploy SLEP), `d44c4a0` (log SLEP), `e3c0a42` (encargos), `ae174ce` (snapshot estructura).

---

## 11. Pendientes y ruta sugerida (sesión 10)

| ID | Pendiente | Tipo | Complejidad | Enfoque sugerido |
|---|---|---|---|---|
| **P5** | **Carga histórica IDPS 2014-2019** | funcionalidad (datos) | Alta | **PRIORIDAD 1 de la sesión 10** (foco datos, sesión dedicada). Primer paso obligatorio: inspeccionar un `.xlsx` por época en `/Users/tomgc/Desktop/idps` ANTES de tocar `34`. Decidir crosswalk de indicadores históricos, años con solo familia `rbd` (sin `dim`/`niveles`), y patrón de nombre nuevo (el actual `PATRON_DATOS` solo soporta 2022-2025; nombres históricos como `idps_4b2018`, `idps19_rbd` no calzan; solo `idpsNb2017_rbd_final` fija el patrón). NO integrar a ciegas (⚠️) |
| **#24** | Texto "qué caracteriza a un EE que puntúa alto" en la ficha | funcionalidad (catálogo) | Media | El texto existe en `idps_corpus_conceptual` (4 secciones, a nivel INDICADOR, no subdim). Ciclo propio: leer `33_construir_catalogos.R` → agregar campo `caracteriza_alto` al catálogo → re-correr 33 (regenera `catalogo_idps.parquet`, NO `idps_largo`) → renderizar en `rcard`. NO presentar a nivel subdimensión |
| **Handout-C1** | Corregir el handout de diseño (no el motor) | documentación | Baja | El handout pide GSE absoluto / 2º trazo gris-GSE, prohibidos por lee-no-deriva. Documentar en el handout que el GSE absoluto NO se grafica, para que una futura sesión no reintroduzca la divergencia |
| **P6** | 45 definiciones de subdimensión sin acentuar | calidad de datos | Baja | Espera fuente acentuada del titular |
| **Higiene-s9-a** | `PanelEvolucion` + CSS `.evol-*` huérfanos | deuda técnica | Baja | Tras pasar el histórico a `BarrasAnio`, `PanelEvolucion` y su CSS quedaron sin uso (conservados por reversibilidad). Candidatos a limpieza en una pasada de higiene; NO mezclar con cambios funcionales (A-s8-4) |
| **Higiene-s9-b** | Tab inicial del selector territorial en Comuna | mejora visual | Trivial | El reorden de `TABS` dejó Comuna como tab por defecto del modal. Si se prefiere otro (Región, o el foco), es un cambio de una línea. Decisión del titular |

**Deuda técnica:** ninguna nueva crítica. Dos higienes menores (huérfanos de `PanelEvolucion` y tab inicial), ambas triviales. El template sigue creciendo; si supera un umbral incómodo, evaluar separar CSS/JS en una sesión de mantenimiento dedicada.

**Nota de comportamiento (no pendiente):** `SLEPS_OPTS` filtra `ee>0`, así que solo lista SLEPs con EE con dato IDPS (hoy los 36). Si una regeneración futura dejara un SLEP sin dato, desaparecería de la pestaña silenciosamente; es correcto (no sería navegable) pero queda señalado.

**Auditoría de cierre (política 5.6):** datos crudos aislados (Rama A pública) ✓; pipeline reproducible ✓; constantes nombradas ✓; estructura conforme ✓; sin tildes/ñ en nombres de archivo ✓. Sin respuestas "no".

**Ruta sugerida sesión 10:** abrir P5 como sesión de datos dedicada (es el trabajo grande pendiente y el único de complejidad Alta). Primer paso obligatorio: inspección de un xlsx por época antes de extender `34`. #24, Handout-C1 y las dos higienes son acotados y pueden intercalarse o diferirse según prioridad del titular; conviene NO mezclar #24 (catálogo, toca 33) ni P5 (pipeline, toca 34) con las higienes de UI en un mismo commit.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 La **paleta de 4 indicadores** (`#EE2D49 #FFC92E #9BC93E #2A8FD9`) es codificación de dato. Ningún ajuste visual la recolorea ni la re-mapea.
- 🔒 **Cero agregación territorial.** Barras y celdas son CONTEO de establecimientos por estado (% con n) o puntaje del EE individual por año, nunca promedio entre EE.
- 🔒 **Lee, no deriva.** No reconstruir la línea absoluta del GSE (`prom − difgru` prohibido, decisión de ponderación §5). Ancla vs GSE solo a nivel indicador. Subdimensión es distribución, no puntaje (no entra al histórico). Las tendencias usan el `dif`/`sigdif` leído, no la resta visual.
- 🔒 **El `anio_traspaso` del SLEP es etiqueta de contexto, NUNCA filtro temporal** (A-s9-2). Un SLEP agrupa toda su serie histórica como propia, incluidos años previos al traspaso. Jamás introducir una comparación contra `anio_traspaso` que recorte la serie.
- 🔒 **Jerarquía de nombres de tres capas** (D-s7-4): caracterización para EE del SLEP; directorio saneado para el resto; prohibido corregir ortografía a ojo fuera del SLEP.
- 🔒 **Comentarios CSS sin la secuencia `*/` literal** (Bug s7-1).
- ✅ ANTES de republicar `docs/`: confirmar `docs/index.html` == `motor_idps.html` por bytes.
- ✅ ANTES de fijar el alcance de un encargo que dependa de un campo nuevo: verificar dónde vive ese campo (parquet / JSON embebido / xlsx aguas arriba), read-only (A-s9-1).
- ✅ ANTES de portar un componente de un motor hermano: verificar si el patrón ya existe en el destino y si el origen es fuente o transpilado (A-s9-4).
- ✅ ANTES de tocar #24: leer `33_construir_catalogos.R` y verificar que el campo del corpus se mapea a nivel indicador (no subdimensión).
- ⚠️ NO regenerar `idps_largo` por un cambio de presentación: usar `only=35` y verificar md5 `50d9de4f1fc80259d29f499cdf46d9e1` antes y después.
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

```js
// Pestaña SLEP en el selector territorial — el año es ETIQUETA, NO filtro (🔒-DOM).
// buildList rama slep: el sub muestra el año; el filtrado de unidades es por cod_slep,
// jamás por anio_traspaso.
if(tab==="slep") return SLEPS_OPTS.filter(s=>!ql||String(s.nom).toLowerCase().includes(ql))
  .map(s=>({kind:"slep", cod:s.cod, nom:"SLEP "+s.nom, sub:"Traspaso "+s.anio}));
// onPick: item.kind==="slep" => setTerr({kind:"slep",cod:item.cod});  (sin filtro de año)
// unidades: if(terr.kind==="slep"){ if(String(e.cod_slep)!==String(terr.cod))continue; }
```

```
# Vista histórica: barras por año (BarrasAnio), NO líneas, NO subdimensión.
# - Eje fijo 0-100, hueco sin barra (no interpola), preliminar atenuado + discontinuo + *.
# - Anidamiento indicador → dimensión únicamente (subdimensión es distribución, va en Vista actual).
# - HistTrend usa dif/sigdif LEÍDO de la Agencia, no la resta visual de las barras.
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 10 (Opus 4.8)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política + settings) vive en la knowledge base del Project y en `50_documentacion/activa/`; léelo desde ahí. La sesión 9 cerró con v09: dos correcciones de fidelidad sobre el motor desplegado (vista histórica de la ficha de líneas a barras por año; pestaña SLEP en el selector territorial con el año de traspaso como etiqueta), ambas desplegadas a Pages y confirmadas visualmente. La compuerta P0-s9 (confirmación del rediseño) quedó cerrada. El foco de la sesión 10 es **P5: carga histórica IDPS 2014-2019**, como sesión de datos dedicada y prioridad 1 — el trabajo grande pendiente. Primer paso obligatorio: inspeccionar un `.xlsx` por época de `/Users/tomgc/Desktop/idps` ANTES de tocar `34` (el `PATRON_DATOS` actual solo soporta 2022-2025). Adjunto el traspaso v09 y el escáner; para P5 adjuntaré también `34_leer_normalizar_idps.R` y un xlsx histórico por época."
- **Documentos para la sesión 10:**
  1. *Protocolo en knowledge base* (NO se adjuntan; verificar al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` si corre en Claude Code; `34_leer_normalizar_idps.R` y un `.xlsx` histórico por época de `/Users/tomgc/Desktop/idps` para P5 (imprescindibles si se ataca P5); `33_construir_catalogos.R` + `idps_corpus_conceptual.json` si se ataca #24.
  3. *Específicos de la sesión (SÍ se adjuntan):* el traspaso `traspaso_cierre_v09.md`; el escáner `estructura_actual.md`.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo.
