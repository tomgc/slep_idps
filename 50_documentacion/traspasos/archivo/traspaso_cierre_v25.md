# Traspaso de cierre — slep_idps — v25

**Proyecto:** slep_idps (motor IDPS nacional, React 18 + D3 v7 inline, GitHub Pages)
**Versión:** v25
**Fecha:** 2026-06-25
**Sesión:** 25 — sesión de datos + UI: cierre del pendiente histórico (resultó ya integrado), documentación de cobertura histórica en 4 capas, y mejoras de la vista histórica (valor de media móvil, vs GSE en tooltip, señalética de significancia por barra).
**Entorno:** R 4.5.x, Positron (macOS aarch64); Claude Code para terminal/git; Claude web para análisis y encargos.
**Modelo:** Opus 4.8.
**Archivos principales modificados:** `30_procesamiento/35_motor_template.html`, `30_procesamiento/34_leer_normalizar_idps.R`, `30_procesamiento/35_generar_motor_html.R`, `40_salidas/motor_idps.html`, `docs/index.html`, `50_documentacion/activa/decisiones/20260625_decision_cobertura_historico_idps.md` (nueva), más deuda documental versionada al cierre (logs, encargo, escáner, traspaso v24).

---

## 1. Resumen ejecutivo

Sesión que abrió con el pendiente de máxima prioridad nominal — integrar el IDPS histórico 2014–2019 — y descubrió, contrastando contra el código real (R10), que **ya estaba integrado**: el script `34` tiene rama histórica completa (Bloque 3b), el parquet cubre 2014–2025 (2.362.447 filas) y el motor ya muestra la serie. El pendiente heredado describía un estado obsoleto (archivos supuestamente en Desktop, `PATRON_DATOS` sin soporte). Verificada la idempotencia (md5 `4c764d8c…` idéntico tras re-correr `34`) y la cobertura real contra el parquet, el trabajo se reorientó a **documentar** la cobertura y la razón de sus huecos (no-aplicación del instrumento: 6b/8b intermitentes, 2019 estallido social para 2m/4b, 2020–2021 pandemia) en cuatro capas: decisión interna, comentarios en `34`/`35`, y nota visible al usuario en la vista histórica (limitada a 2019/4b/2m, los grados que el motor expone). Luego se hicieron cuatro mejoras de UI sobre la vista histórica: corrección del texto explicativo (escala 0–100, orden de causas, COVID, media móvil), reubicación de la leyenda de media móvil (P-LEYENDA-MMOVIL-UBICACION cerrado), exposición del **valor** de la media móvil vigente (cabecera + tooltip) con la distancia vs GSE en el tooltip de indicador, y la señalética de significancia por barra ampliada con el glifo `·` para años históricos sin comparación publicada. También se corrigió la lista de pendientes: **Batch B (#7, #9, #13, #18, #23) estaba cerrado desde s22** y el v24 lo arrastró como abierto. Cierre con deploy + push de toda la sesión y working tree limpio.

---

## 2. Estado al cierre

**Qué funciona:**
- Motor en producción con la serie histórica 2014–2025, nota de cobertura (2019), texto corregido, valor de media móvil en cabecera y tooltip, vs GSE en tooltip de indicador, y señalética por barra (▲▼= por dirección, color por significancia, `·` para históricos sin comparación). Última ejecución exitosa: deploy byte-idéntico al build aprobado por gate visual.
- Parquet `idps_largo.parquet` md5 `4c764d8c…` intacto (toda la sesión fue documentación + presentación; cero toque a datos).
- Decisión `20260625_decision_cobertura_historico_idps.md` versionada.
- Working tree limpio tras el cierre; deuda documental de la sesión versionada.

**Qué no funciona / pendiente:** nada roto. Pendientes de fondo en §11, ninguno bloqueante.

**Delta respecto a v24:**
- `origin/main`: `4bb2f8f` (deploy intermedio de la sesión) → `[HASH_PUSH_FINAL]` (cierre).
- Backlog: v23/144 → **v25/147** (3 cambios de producto nuevos: #145 valor media móvil, #146 vs GSE en tooltip de indicador, #147 señalética `·` históricos; ver §5).
- Pendiente histórico 2014–2019: **cerrado** (ya estaba integrado; documentado).
- Batch B: corregido a **cerrado** (estaba mal listado como abierto en v24).

---

## 3. Registro detallado de cambios

### 3.1 Verificación y cierre del pendiente histórico (sin commit de código)
- **Qué:** se verificó que el histórico 2014–2025 ya está integrado en el parquet (rama 3b del `34`), idempotente (md5 intacto tras re-correr), y se confirmó la cobertura real por grado contra el parquet.
- **Por qué (R10):** el pendiente heredado describía premisas falsas. No se fabricó trabajo de integración inexistente (B.1); se reorientó a documentar.
- **Cobertura real (verificada contra parquet):** indicador 2014–2025; dimensión 2018 + 2022–2025; niveles 2023–2025 (2024 para 6b/8b). Por grado: 2m/4b 2014–2018 + 2022–2025 (9 años); 6b 2014–2016, 2018, 2024 (5); 8b 2014–2015, 2017, 2019, 2025 (5).

### 3.2 Decisión interna de cobertura histórica (`551dfd3`, pusheado)
- **Archivo:** `50_documentacion/activa/decisiones/20260625_decision_cobertura_historico_idps.md` (nuevo).
- **Qué:** 6 secciones (contexto, decisión, cobertura por familia y por grado, razón de huecos con referencia pública de la Agencia en estilo indirecto, implicancia). Documenta los 4 grados.
- **Por qué:** fija que la cobertura disponible es la máxima de la fuente; los huecos son ausencia de aplicación, no deuda de datos.

### 3.3 Constancia en el pipeline (`152b73f`, pusheado)
- **Archivos:** `34_leer_normalizar_idps.R` (junto a `PATRON_HISTORICO`) y `35_generar_motor_html.R` (junto a `eje_historico`/`ANIOS_PANDEMIA`). Comentarios de constancia con referencia a la decisión; cero lógica tocada (diffs = solo `+#`).

### 3.4 Nota visible 2019 + correcciones de texto (`67f5aa5`, `10b4d0b`, pusheados)
- **Archivo:** `35_motor_template.html` (`.ficha-explain` de la vista histórica).
- **Qué:** ampliación de la oración de años en gris con la explicación del estallido (2019, 4b/2m), luego corrección integral del texto (escala "0 mínimo–100 máximo", orden de causas reordenado, COVID-19 para 2020–2021, media móvil "según las últimas tres aplicaciones con resultados válidos", cola eliminada).
- **Separación de capas (🔒):** la nota visible solo menciona 2019/4b/2m (lo que el motor expone); 6b/8b viven solo en decisión y código.

### 3.5 Reubicación de la leyenda de media móvil (`7ea1baf`, pusheado)
- **Qué:** se eliminó el bloque `.leyenda hist-leg` suelto y se integró la muestra de línea en el `.ficha-explain` (con `<br/>`, su propio renglón). P-LEYENDA-MMOVIL-UBICACION cerrado.
- **Deuda dejada:** regla CSS `.hist-leg` (L128) sin selector vivo → P-CSS-HIST-LEG (§11).

### 3.6 Valor de media móvil + vs GSE en tooltip (`c968c9e`, local→push al cierre)
- **Archivo:** `35_motor_template.html` + build. **Categoría:** Rediseño UI / funcionalidad.
- **Qué:** (a) `serieEje` propaga `difgru`/`sigdifgru` condicional a presencia de campo (indicador sí, dimensión → null); (b) media móvil vigente en cabecera de indicador y dimensión (texto suelto junto al HistTrend, `flex-wrap`, etiquetada con su año); (c) tooltip por año enriquecido con la media móvil del año (o "sin media móvil (extremo de la serie)") y, **solo en indicador**, distancia vs GSE con simbología ▲/▼/= y color por `sigdifgru`.
- **Por qué (🔒):** a nivel dimensión NO hay dato vs GSE (la Agencia no lo publica); el flag `gse` solo se pasa desde el `.map` de indicadores. La media móvil vigente es el penúltimo año con dato (la ventana centrada no alcanza el extremo); SIEMPRE etiquetada con su año.
- **Verificación:** spot-check del cálculo (Autoestima RBD 1692: (70+74+73)/3 = 72,3, anclado a 2024); payload byte-idéntico (todo es render); parquet intacto. Log: `50_documentacion/andamios/logs/20260625_media_movil_valor_s25_log.md`.

### 3.7 Señalética `·` para históricos + nota ampliada (`6c1ea4e`, local→push al cierre)
- **Archivo:** `35_motor_template.html` + build. **Categoría:** Rediseño UI.
- **Qué:** el glifo `ybar-sig` ahora pinta `·` gris (clase `nt`) en años con dato pero sin `dif` (históricos), con title "La Agencia no publica la comparación con la evaluación anterior para este año". Los años con `dif` (2024–2025) mantienen ▲/▼/= con color por significancia, intactos. Nota `.nota-inv` ampliada para explicar los cuatro estados (dirección por glifo, significancia por color, `·` = sin comparación), "distribución en niveles".
- **Por qué (🔒):** el `·` NO afirma significancia; el histórico no trae `dif` y no se recalcula. Semántica decidida: glifo = dirección, color = significancia (consistente con anclas y tooltips del motor).
- **Verificación:** render año→glifo enumerado en DOM (históricos `·`, 2024 ▲, 2025 ▼ sin cambios); payload byte-idéntico.

---

## 4. Inventario de commits de la sesión

| # | Hash | Tipo | Título | Estado |
|---|------|------|--------|--------|
| 1 | `551dfd3` | docs | decision cobertura historica IDPS | pusheado (4bb2f8f) |
| 2 | `152b73f` | docs | constancia en pipeline 34/35 | pusheado |
| 3 | `67f5aa5` | feat | nota visible 2019 (estallido) | pusheado |
| 4 | `10b4d0b` | feat | correccion texto vista historica | pusheado |
| 5 | `4bb2f8f` | deploy | publica cobertura historica + correccion texto | pusheado |
| 6 | `7ea1baf` | fix | integra muestra promedio movil, elimina leyenda suelta | pusheado (en 4bb2f8f? NO — ver nota) |
| 7 | `c968c9e` | feat | valor media movil + vs GSE en tooltip | local → push al cierre |
| 8 | `6c1ea4e` | feat | glifo · historicos + nota senaletica | local → push al cierre |
| + | `[CIERRE]` | docs/deploy | deuda doc + traspaso v25 + deploy final | generado al cierre |

> **Nota sobre `7ea1baf`:** la secuencia de hashes de la sesión fue `551dfd3 → 152b73f → 67f5aa5 → 10b4d0b → 4bb2f8f (deploy) → 7ea1baf → c968c9e → 6c1ea4e`. El deploy `4bb2f8f` publicó hasta `10b4d0b`; `7ea1baf` (leyenda) y los dos siguientes quedaron sin desplegar hasta el cierre. El commit de cierre hace deploy de todo lo posterior a `4bb2f8f`.

---

## 5. Backlog acumulativo

**Estado:** v23/144 heredado → **v25/147**. s25 aporta **3 entradas nuevas** de producto:

- **#145 — Valor de la media móvil en la vista histórica.** El motor dibujaba la media móvil como línea tenue sin exponer su valor; ahora muestra la media móvil vigente (penúltimo año con dato, etiquetada con su año) en la cabecera de indicador y dimensión, y la media móvil del año en el tooltip por barra. Categoría: Visualización / diseño — rediseño UI.
- **#146 — Distancia vs GSE en el tooltip de indicador.** El tooltip por año de los indicadores muestra ahora la distancia vs el GSE de referencia (`difgru`/`sigdifgru`) con simbología ▲/▼/= y significancia, solo donde el dato existe (2024–2025) y solo a nivel indicador (no dimensión, donde no hay dato GSE). Categoría: Visualización / diseño — rediseño UI.
- **#147 — Señalética de significancia por barra completada con `·`.** La marca junto al puntaje de cada año se extendió: los años históricos con dato pero sin comparación publicada muestran `·` (sin afirmar significancia); nota de la vista histórica ampliada para explicar la convención glifo=dirección / color=significancia. Categoría: Visualización / diseño — rediseño UI.

**No suman al correlativo (mantención/higiene, criterio DEC-s24-1):** la verificación y cierre del pendiente histórico; la documentación de cobertura (decisión + comentarios + nota visible 2019); la corrección de texto de la vista histórica; la reubicación de la leyenda de media móvil (P-LEYENDA-MMOVIL-UBICACION, mejora visual de higiene). Estas son documentación, corrección y reubicación, no solicitudes de producto nuevas.

**Delta del backlog en s25:** +3 entradas (#145–147), todas en "Visualización / diseño — rediseño UI" (que sube a 50/147, ~34%, sigue sobre el 25% → ver pendiente de subdivisión en §11). Sin reclasificaciones ni renumeraciones (append-only).

**Observación:** la categoría "Rediseño UI" en 50/147 (34%) refuerza el pendiente de subdivisión heredado de v24.

---

## 6. Bugs de la sesión

Ninguno. Dos falsos positivos investigados y descartados con datos: (a) el "glifo faltante" en años históricos era ausencia de dato (la Agencia no publica `dif` pre-2024), no bug — resuelto añadiendo `·`; (b) el "vs GSE faltante" en el tooltip era porque el año mirado (2023) no tiene `difgru` (solo 2024–2025) — el tooltip GSE funciona donde el dato existe.

---

## 7. Aprendizajes y restricciones descubiertas

- **R-PENDIENTE-OBSOLETO (R10/R9):** un pendiente heredado puede describir un estado que ya cambió. Antes de trabajar sobre él, verificar contra el código/dato real. En s25, tanto "IDPS histórico" como "Batch B" estaban descritos como abiertos pero ya cerrados. Contexto: si se viola, se fabrica trabajo inexistente (B.1) o se reabre algo ya hecho. Patrón: contrastar el pendiente contra el detalle cronológico y el código, no contra la tabla de pendientes heredada.
- **Glifo = dirección, color = significancia (semántica transversal):** la señalética del motor (anclas, HistTrend, ybar-sig, tooltips) usa el glifo para la DIRECCIÓN (▲/▼/=) y el COLOR para la SIGNIFICANCIA (azul/rojo sig., gris no sig.). No colapsar "no significativo" en el glifo `=` (rompería la lectura del signo). El `·` es un cuarto estado: "sin comparación publicada", distinto del gris "no significativo".
- **Histórico = solo `prom`:** el histórico 2014–2023 trae únicamente el promedio; sin `dif`/`sigdif`/`difgru`/`sigdifgru`/niveles. Cualquier marca en esos años (glifo, GSE) debe ser ausencia honesta o `·`, nunca un valor inventado (🔒, no se recalcula significancia).
- **Separación de universos por capa de documentación:** la decisión interna y los comentarios de código documentan los 4 grados (universo del parquet); la nota visible solo los grados que el motor expone (4b/2m). No propagar texto entre capas.

---

## 8. Decisiones de diseño

- **DEC-s25-1 — Cobertura histórica = máxima de la fuente.** Los huecos (6b/8b intermitentes, 2019 estallido, 2020–2021 pandemia) son ausencia de aplicación, no deuda de datos. Replicada en `50_documentacion/activa/decisiones/20260625_decision_cobertura_historico_idps.md`.
- **DEC-s25-2 — Media móvil vigente = penúltimo año con dato.** La ventana centrada de 3 no produce valor para el extremo; el valor mostrado se etiqueta siempre con su año (nunca como "valor actual").
- **DEC-s25-3 — Señalética: glifo dirección / color significancia / `·` sin comparación.** Se mantuvo la semántica transversal (opción A sobre la alternativa de colapsar "no significativo" en `=`). El `·` cubre el caso histórico sin afirmar significancia.
- **DEC-s25-4 — vs GSE en tooltip solo a nivel indicador.** La Agencia no publica desvío GSE a nivel dimensión; el tooltip de dimensión nunca lo muestra (🔒, coherente con el radar).

---

## 9. Constantes y parámetros vigentes

Sin cambios de valor en s25. Vigentes: parquet `idps_largo.parquet` md5 `4c764d8c9f0bf70004f8aa52661ae901` (inmutable); `GRADOS_MOTOR = c("4b","2m")` (filtro de presentación); `MMOVIL_VENTANA=3`, `MMOVIL_MIN_PUNTOS=4`; `ANIOS_PANDEMIA = c(2020,2021)`; colores de estado `--destaca:#2A8FD9`, `--alerta:#EE2D49`, `--st-neutro:#7E8A99`; reconstrucción `prom_GSE = prom − difgru` a nivel indicador 2024–2025 (D7).

---

## 10. Arquitectura de archivos

Estructura conforme a la política (sin desviaciones nuevas; espacios en `andamios/diseno/` siguen como deuda heredada congelada). El escáner rotó a los snapshots `20260625_073755` y `20260625_123632` (retención-2). Referencia de cierre: `50_documentacion/estructura/estructura_actual.md`.

**Registro de ejecución detallado:** logs de Claude Code en `50_documentacion/andamios/logs/` — `20260625_cobertura_historica_s25_log.md` y `20260625_media_movil_valor_s25_log.md`; detalle paso a paso no reproducido aquí.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **`# REVISAR (voz)` en `documentar.R`** (L316, L375): prosa de comunidad de la suite para afinar tono; el dato es correcto. *Tipo:* documentación. *Complejidad:* Baja. **(No abordado en s25 pese a estar en la lista del titular; queda para s26.)**
- **Higiene del backlog:** "Visualización / diseño — rediseño UI" en 50/147 (~34%), sobre el 25%. Candidata a subdivisión (sin renumerar, append-only). *Tipo:* deuda técnica / documentación. *Complejidad:* Media.
- **P-CSS-HIST-LEG (nuevo):** la regla CSS `.hist-leg` (`35_motor_template.html` L128) quedó sin selector vivo tras la reubicación de la leyenda de media móvil (P-LEYENDA-MMOVIL-UBICACION). Candidata a limpieza CSS (mismo patrón que P-CSS-MUERTO s24). `.sw-line.mm` SÍ sigue en uso. *Tipo:* limpieza / deuda técnica. *Complejidad:* Baja.
- **Suite/corpus con cobertura histórica (nuevo):** incorporar la cobertura histórica y su razón a la suite (`documentar.R`) y al corpus conceptual. *Tipo:* documentación. *Complejidad:* Media. Pasada propia.
- **Tooltip por año `no_eval` (nuevo, mejora):** convertir la nota fija de años en gris en explicación contextual por año, derivada de `eje_historico`. *Tipo:* mejora visual. *Complejidad:* Media.
- **Afinamiento de doble lectura del glifo (nuevo, menor):** un mismo valor (p.ej. -1) puede mostrar glifo distinto en HistTrend temporal (`=` si no sig.) vs tooltip GSE (`▼` por signo), porque miden cosas distintas (`sigdif` vs `sigdifgru`). No es bug; posible afinamiento de consistencia si confunde. *Tipo:* mejora visual. *Complejidad:* Baja.
- **P-SLEPVERSE:** extracción de código duplicado a paquete R interno. Inventario de duplicación real (enfoque B) obligatorio primero. *Complejidad:* Alta. Sesión dedicada.
- **Ítem 11:** bloqueado por repo hermano.
- **P-GITIGNORE-TOKEN:** revisar (heredado).

### Pendientes CERRADOS o CORREGIDOS en s25
- **IDPS histórico 2014–2019:** CERRADO (ya estaba integrado; verificado y documentado).
- **Batch B (#7, #9, #13, #18, #23):** CORREGIDO — todos cerrados en s22; el v24 los listaba como abiertos por error. #7/#13/#18/#23 implementados en s22; #9 cerrado como no-implementado (DS22-1, colisión con `nivelRamp`).
- **Batch C (#5, #8):** ya cerrados en s23 (confirmado).
- **P-LEYENDA-MMOVIL-UBICACION:** CERRADO en s25 (reubicación al `.ficha-explain`).

### Auditoría de cierre (política 5.6)
- ¿Pipeline reproducible? Sí (`run_all(only=35)` byte-idéntico; `34` idempotente, md5 intacto). ✔
- ¿Outputs idempotentes? Sí (deploy byte-idéntico). ✔
- ¿Nombres sin tildes/ñ/espacios? Archivos nuevos cumplen; deuda heredada en `andamios/diseno/` congelada. ✔
- Sin respuestas "no" nuevas que generen pendiente.

### Ruta sugerida para s26
1. **Higiene del backlog + `# REVISAR (voz)`** (los dos pendientes de la lista del titular no abordados en s25): bajo riesgo, cierran deuda de documentación. Subdividir "Rediseño UI", afinar prosa de comunidad.
2. **P-CSS-HIST-LEG:** limpieza CSS acotada (puede ir junto a la higiene del backlog en la misma sesión).
3. **Alternativa de mayor valor:** suite/corpus con cobertura histórica (cierra la documentación de la integración histórica de punta a cabo).

**Recomendación:** s26 = higiene (backlog + `# REVISAR (voz)` + P-CSS-HIST-LEG) — son los pendientes de la lista explícita del titular que s25 no alcanzó, de bajo riesgo, y dejan la deuda documental/CSS saldada antes de abrir frentes mayores (suite/corpus, slepverse).

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 `idps_largo.parquet` md5 `4c764d8c…` intocable; nunca reescribir columnas de medida.
- 🔒 Histórico 2014–2023 = solo `prom`; sin `dif`/`sigdif`/`difgru`/`sigdifgru`/niveles. No inventar ni recalcular significancia.
- 🔒 vs GSE solo a nivel indicador (la Agencia no lo publica a nivel dimensión); el tooltip/ancla de dimensión nunca lo muestra.
- 🔒 Señalética: glifo = dirección (▲/▼/=), color = significancia (azul/rojo sig., gris no sig.), `·` = sin comparación publicada. No colapsar significancia en el glifo.
- 🔒 Media móvil vigente = penúltimo año con dato; siempre etiquetada con su año.
- 🔒 Documentación por capas: decisión/código = 4 grados; nota visible del motor = solo 4b/2m.
- 🔒 GSE de referencia polígono radar: `prom − difgru`, nivel indicador, 2024–2025, omitido si falta algún dato (D7).
- 🔒 Sin agregación territorial; GSE inviolable; básica y media nunca mezcladas; NA = supresión, nunca cero.
- ⚠️ NO push/deploy a `docs/` sin gate visual explícito del titular.
- ⚠️ NO `git add .`; staging path-scoped; commits atómicos por tema.
- ⚠️ Antes de trabajar un pendiente heredado, verificar contra el código/dato real (puede estar obsoleto o ya cerrado — R-PENDIENTE-OBSOLETO).
- ✅ ANTES de cualquier commit, leer estado real (`git status`/`diff`/`ls-files`); verificar retención-2 del escáner contra el filesystem (A20).
- ✅ Localizar por contenido, no por número de línea (A37).
- ✅ Al verificar suites/payload offline, excluir el namespace `xmlns` de SVG del conteo de referencias de red.

---

## 13. Fragmentos de código de referencia

```r
# Re-correr el lector IDPS (idempotente; md5 del parquet debe quedar intacto):
source("30_procesamiento/34_leer_normalizar_idps.R")
# Verificar idempotencia:  md5 -q 40_salidas/intermedios/idps_largo.parquet  == 4c764d8c...
```

```bash
# Cobertura real grado x anio x familia (verificacion contra el parquet):
Rscript -e 'suppressMessages({library(arrow);library(dplyr)}); d<-read_parquet(here::here("40_salidas","intermedios","idps_largo.parquet")); d|>dplyr::count(grado,agno,familia)|>tidyr::pivot_wider(names_from=familia,values_from=n,values_fill=0)|>dplyr::arrange(grado,agno)|>print(n=Inf)'
```

```bash
# Deploy del motor (gate visual del titular requerido antes):
cp 40_salidas/motor_idps.html docs/index.html
cmp 40_salidas/motor_idps.html docs/index.html && echo "BYTE-IDENTICO"
git add docs/index.html && git commit -m "deploy(docs): ..."
```

---

## 14. Reapertura

**Nombre del chat:** `slep_idps, sesión 26 (Opus 4.8)`

**Mensaje de apertura pre-armado:**
> Tipo CONTINUATION de slep_idps. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md + DISCIPLINA_OPERATIVA.md) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v25 y el escáner. Estado: motor s25 desplegado, working tree limpio, backlog en v25/147. Foco propuesto: higiene (subdividir "Rediseño UI" en el backlog, resolver `# REVISAR (voz)` en `documentar.R`, limpiar P-CSS-HIST-LEG).

**Documentos para la próxima sesión:**
1. *Protocolo en knowledge base* (NO se adjuntan; verificar que estén al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `DISCIPLINA_OPERATIVA.md`.
2. *Opcionales según foco:* `documentar.R` si se aborda `# REVISAR (voz)` o suite/corpus; `backlog_historico.md` si se subdivide la taxonomía; `35_motor_template.html` si se limpia P-CSS-HIST-LEG.
3. *Específicos de la sesión* (SÍ se adjuntan): `traspaso_cierre_v25.md`; `estructura_actual.md`.

**Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo.
