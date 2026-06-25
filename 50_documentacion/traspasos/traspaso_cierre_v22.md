# Traspaso de cierre — slep_idps v22

## 1. Identificación

- **Proyecto:** `slep_idps` (motor de comparación interactivo de los IDPS de la Agencia de Calidad, SLEP Costa Central).
- **Versión:** v22.
- **Fecha:** 2026-06-24.
- **Sesión 22**, foco: documentación (refresco de la suite por la decisión GSE de s21) + Batch A (lote directo verificable, 4 ítems) + Batch B (5 ítems: 3 solo-template, 1 generador+template, 1 cerrado por decisión).
- **Entorno:** macOS aarch64, R 4.5.x, Positron, zsh, GitHub Pages (público). Modelo: Opus 4.8.
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (Batch A + B1 + B2), `30_procesamiento/35_generar_motor_html.R` (B2), `50_documentacion/suite/documentar.R` (refresco doc). Build `40_salidas/motor_idps.html` regenerado.

---

## 2. Resumen ejecutivo

Sesión de mejoras de presentación sin tocar datos. Se refrescó la suite de documentación (`documentar.R`) para reflejar la decisión del polígono GSE de s21, que había dejado 5 zonas de la `cfg` afirmando lo contrario (que el GSE absoluto no se publicaba ni se dibujaba); se reescribieron esas zonas y se agregó una decisión D7 dedicada. Luego se ejecutaron dos tandas de ajustes al motor vía encargos autónomos a Claude Code: **Batch A** (jerarquía `.axis-lab.b`, alto de barras, leyenda de media móvil, tope del comparador 4→10) y **Batch B** (color "sin diferencia", glifo de significancia temporal en el histórico, etiqueta externa para segmentos finos del comparador, y textos "qué refleja un puntaje alto" por indicador). De los 9 ítems de mejora, 8 se implementaron y verificaron en navegador; #9 (recolorear dimensiones por puntaje) se cerró como **no se implementa** por decisión metodológica. **Todo el trabajo del motor quedó sin commitear ni desplegar**, apilado en el working tree por decisión del titular ("commit después"). Pendiente principal para s23: commit + deploy del lote acumulado, y Batch C (bloqueado a capturas).

---

## 3. Estado al cierre

**Qué funciona (verificado en navegador este cierre, EE de referencia RBD 1692, serie 2014→2025):**
- Suite de documentación: `documentar.R` actualizado y coherente con la decisión GSE; pendiente de regenerar los 4 HTML (tarea del titular, requiere npm + red).
- Motor con los 8 ajustes de Batch A + B aplicados sobre el build local, todos verificados.

**Qué NO está cerrado (no es falla, es estado de cierre elegido):**
- Los cambios del motor (Batch A: 4 commits locales; Batch B1 + B2: working tree sin commitear) NO están en `origin/main` ni desplegados en `docs/`.
- `documentar.R`: editado, NO regenerado (los `*_standalone.html` aún reflejan la versión vieja hasta que el titular corra la generación).

**Delta respecto a v21:**
- `origin/main` sigue en `41a3406` (s21). Localmente, HEAD = `3cf666c` (4 commits de Batch A) + working tree con B1, B2 y los builds.
- 8 mejoras nuevas de presentación; 1 ítem cerrado por decisión; suite de doc refrescada en fuente.

---

## 4. Registro detallado de cambios

> Cada ítem de mejora es un cambio conceptualmente independiente. Los del motor se agrupan por el encargo que los entregó. La numeración #NNN corresponde al backlog (sección 5).

### Documentación — refresco de la suite (no es entrada de backlog de producto; es mantención de doc)
- **Archivo:** `50_documentacion/suite/documentar.R`.
- **Qué:** se corrigieron 5 zonas de la `cfg` que contradecían la decisión `20260624_decision_poligono_gse_radar.md` (s21) y se agregó una decisión nueva:
  - **D2** (decisión "comparar = radares lado a lado + desvío"): el `por_que` afirmaba que el GSE absoluto "no lo publica la Agencia… derivarlo reconstruiría el consolidado prohibido". Reescrito: el desvío sigue siendo la marca primaria, y el puntaje GSE absoluto sí se dibuja como referencia (remite a D7).
  - **D7 nueva:** "Polígono GSE de referencia (cifra pública, reconstruida sin pérdida)", con su `por_que` (cifra pública, `prom − difgru` exacto, solo indicador, solo 2024–2025, omitido donde falta dato; el radar no lleva comparación temporal).
  - **reglas_calculo** "Comparación contra el mismo GSE": de "no se dibuja el puntaje absoluto" a "se dibuja como polígono de referencia reconstruido, solo donde hay dato".
  - **entidades_tec:** nueva entrada "Polígono GSE de referencia".
  - **glosario_tec:** GSE matizado (el puntaje publicado sí se grafica) + entrada nueva `prom_gse`.
  - **doc_s2_cierre:** menciona el polígono GSE en el radar.
- **Por qué (C.11):** la documentación publicable afirmaba lo contrario de lo que el motor hace desde s21; era contenido falso, no solo desactualizado.
- **Cómo se verificó:** balanceo de paréntesis de los 5 bloques editados (parser de strings); 0 residuos contradictorios por grep; `standalone = TRUE` intacto en la llamada final. NO se regeneraron los HTML (requiere R + npm en la máquina del titular).
- **Marca abierta:** persisten `# REVISAR (voz)` preexistentes en `textos`/`prosa` (afinamiento de tono, no dato); no se tocaron.

### Batch A (encargo `encargo_claude_code_idps_batch_a_s22.md`, 4 commits atómicos locales)
- **#134 / `.axis-lab.b` (commit `50baa41`, `style`):** restaurada la jerarquía de la variante `.b` por **peso** (`font-weight:var(--fw-bold)`), no por píxel, tras que s20 dejara `.axis-lab` y `.axis-lab.b` ambas en `--fs-2xs`. Cierra la marca `# REVISAR` de s20. Verificado: en el radar las etiquetas `.b` en negrita, 11px; 0 marcas REVISAR.
- **#135 / alto de barras (commit `87cc923`, `style`):** `--yh` del histórico subido sutil y proporcionalmente (`hist-main` 152→168, `hist-dim` 118→130). Escala 0–100 intacta (es alto del contenedor, no del dato).
- **#136 / leyenda de media móvil (commit `0e1365b`, `feat`):** tira `.hist-leg` con swatch `.sw-line.mm` (línea tenue gris) + "Promedio móvil (tendencia)" en la vista histórica. Solo leyenda; no toca `mediaMovil()` ni `MMOVIL_*`.
- **#137 / tope comparador 4→10 (commit `3cf666c`, `feat`):** introducida constante única `CMP_MAX_TERR=10`, referenciada en los **5 lugares** donde el "4" estaba hardcodeado (`maxSel`, contador, guard del botón, guard de `addTerr`, textos del invite). Gate de layout de la matriz a 10: PASÓ (la matriz es tabla con filas por territorio + scroll horizontal; crece vertical, ancho fijado por los 4 indicadores). Modo simple de `EntityModal` intacto.

### Batch B / Encargo 1 (`encargo_claude_code_idps_batch_b1_s22.md`, working tree, sin commitear)
- **#138 / color "sin diferencia" (#23):** token `--st-neutro` `#8C8A86` → `#7E8A99` (gris-azulado), para separarlo del `--gris` de UI (`#6b7780`) manteniendo el punto medio del eje rojo→neutro→azul. Contraste del % interno verificado: `_txtOn('#7E8A99')` → `#fff` (luminancia 0.5338 < 0.55), AA.
- **#139 / señalética sigdif en el histórico (#13):** glifo `▲/▼/=` de significancia **temporal** (vs evaluación anterior) junto a cada número de barra (`.ybar-val` en `BarrasAnio`). Dirección por signo de `dif`, color por `sig` (clases `de`/`al`/`nt`), igual semántica que `Ancla`. La primera barra de cada serie no lleva glifo (`dif===null`). Datos desde `serieEje` (ya devolvía `dif` y `sig`); cálculo intacto. Verificado con casos significativo/aritmético reales.
- **#140 / etiqueta externa segmentos finos del comparador (#18):** tira `.s100-ext` bajo la barra apilada del `StackedBar` para los segmentos `<9%` que no caben dentro (cada uno con glifo de estado, color y %). `repartoInd`/`pctRound` intactos. Gate de layout: PASÓ (los ítems caben en su `<td>`; solo agregan alto vertical).

### Batch B / Encargo 2 (`encargo_claude_code_idps_batch_b2_s22.md`, working tree, sin commitear)
- **#141 / textos "qué refleja un puntaje alto" (#7):** campo editorial `nivel_alto` por indicador (4 textos derivados de `idps_corpus_conceptual.md`, **nivel indicador**), como constante nombrada `INDICADOR_NIVEL_ALTO` en `35_generar_motor_html.R` + colapsable `<details className="indp-alto">` en la tarjeta del indicador (cerrado por defecto, accesible por teclado). Este es el único cambio de la sesión que **toca el payload**; delta verificado como acotado (ver §9): solo `nivel_alto` se añade, ninguna cifra cambia. 🔒 nivel indicador respetado: 0 disclosures en dimensiones/subdimensiones.

---

## 5. Backlog acumulativo

> Se copia íntegro el backlog v21 y se agregan las entradas nuevas al final. La copia íntegra vive en `50_documentacion/traspasos/backlog_historico.md` (append-only). Aquí se registra el **delta de v22** y las entradas nuevas; el archivo maestro debe actualizarse con lo siguiente antes de cerrar.

### Entradas nuevas (134–141), Sesión 22

- **#134** — Jerarquía `.axis-lab.b` restaurada por peso (negrita), cierra la marca `# REVISAR` de s20 (la tokenización tipográfica había igualado base y variante en `--fs-2xs`). Categoría: Limpieza / deuda técnica.
- **#135** — Alto visual de las barras del histórico subido sutilmente vía token `--yh` (152→168 / 118→130). Categoría: Visualización / diseño — rediseño UI.
- **#136** — Leyenda visual de la media móvil en la vista histórica (swatch de línea tenue + texto). Categoría: Visualización / diseño — rediseño UI.
- **#137** — Tope del comparador de territorios subido de 4 a 10 vía constante única `CMP_MAX_TERR` (5 puntos hardcodeados unificados). Categoría: Visualización / diseño — rediseño UI.
- **#138** — Color del estado "sin diferencia significativa" virado a gris-azulado (`--st-neutro` `#8C8A86`→`#7E8A99`) para separarlo del gris de UI. Categoría: Visualización / diseño — rediseño UI.
- **#139** — Señalética de significancia temporal (`▲/▼/=` por `dif`/`sigdif`) en cada número de la matriz histórica (`BarrasAnio`). Categoría: Visualización / diseño — rediseño UI.
- **#140** — Etiqueta externa para los segmentos finos (`<9%`) del gráfico apilado del comparador (`StackedBar`), que solo tenían hover. Categoría: Visualización / diseño — rediseño UI.
- **#141** — Texto editorial "qué refleja un puntaje alto" por indicador (campo `nivel_alto`, colapsable en la tarjeta; nivel indicador, desde el corpus). Categoría: Contenido / texto conceptual.

**Actos no correlativos de s22 (registrados por trazabilidad, NO suman al global):**
- **#9 cerrado por decisión, sin código** (recolorear dimensiones por puntaje): NO se implementa. No es un cambio de producto; es una decisión de no-hacer (ver §8, decisión DS22-1). No ocupa correlativo.
- **Refresco de `documentar.R`** (5 zonas + D7): mantención de documentación, no cambio de producto. No ocupa correlativo.
- **Diagnósticos de zona** (lectura de template/generador antes de cada encargo): análisis, no producto.

### Delta del backlog v22
- **+8 entradas** (134–141). Total **133 → 141**.
- Reparto por categoría: 6 a "Visualización / diseño — rediseño UI" (#135–140), 1 a "Limpieza / deuda técnica" (#134), 1 a "Contenido / texto conceptual" (#141).
- **⚠️ Observación de umbral (continúa de v21):** "Visualización / diseño — rediseño UI" pasa de 38/133 (29%) a **44/141 (31%)**. Cruza el 25% pero NO se subdivide: el backlog es append-only y la categoría es coherente por intención (presentación del motor). Se mantiene en observación; si una sesión futura reabre la taxonomía, es candidata a subdividir (p. ej. "comparador" vs "ficha/histórico").
- **Verificación de integridad (A22):** encabezado del archivo maestro debe quedar v22/141; correlativo del detalle cronológico, último #141; fila Total del resumen estadístico, 141; conteo por categoría suma 141. Los cuatro deben cuadrar tras actualizar el maestro.

### Fila nueva del resumen estadístico por sesión

| Sesión | Traspaso | N° cambios | Rango # | Modelo | Foco |
|---|---|---|---|---|---|
| 22 | v22 | 8 | 134–141 | Opus 4.8 | Refresco doc GSE + Batch A (lote directo) + Batch B (señalética/textos motor) |

### Línea nueva del detalle cronológico (para el maestro)

- **Sesión 22** (2026-06-24): cambios **134–141** (detalle en v22 §4 y en los logs `20260624_batch_a_s22_log.md`, `20260624_batch_b1_s22_log.md`, `20260624_batch_b2_s22_log.md`). Mejoras de presentación del motor en 3 encargos autónomos a Claude Code, **todas sin tocar datos** (parquet intacto `4c764d8c…`; Batch A y B1 con payload byte-idéntico; B2 con delta de payload acotado a solo `nivel_alto`, verificado estructuralmente, ninguna cifra cambió): **134** `.axis-lab.b` por peso (cierra REVISAR s20); **135** alto de barras `--yh`; **136** leyenda media móvil; **137** tope comparador 4→10 vía `CMP_MAX_TERR`; **138** color "sin diferencia" gris-azulado; **139** señalética sigdif temporal en `BarrasAnio`; **140** etiqueta externa segmentos finos del comparador; **141** texto "qué refleja un puntaje alto" por indicador (campo `nivel_alto`, nivel indicador). **Actos no correlativos de s22** (no suman): #9 cerrado como no-implementado (decisión DS22-1, sin código); refresco de `documentar.R` (mantención de doc, 5 zonas + D7); diagnósticos de zona previos a cada encargo. **Estado especial: nada commiteado al cierre** (Batch A en 4 commits locales; B1/B2 en working tree) — el commit y el deploy quedaron como pendiente del titular para s23.

---

## 6. Bugs de la sesión

Ninguno introducido ni descubierto-y-corregido en s22. (Las verificaciones de cada encargo no hallaron regresiones; los gates de layout pasaron.) Se documentan en su lugar dos **deudas preexistentes detectadas** (no bugs activos): ver §11.

---

## 7. Aprendizajes y restricciones descubiertas

- **R-DOC-1 (la documentación publicable puede mentir, no solo envejecer).** Cuando una decisión cambia lo que el producto hace (s21, polígono GSE), la suite de doc que describía el comportamiento viejo pasa a afirmar lo contrario de la realidad. Regla: al cerrar una decisión que altera el comportamiento, revisar en la misma sesión o registrar como pendiente la actualización de `documentar.R` (las zonas `decisiones`, `reglas_calculo`, `glosario_tec`, `entidades_tec`, textos). Contexto: si no, la próxima regeneración publica contenido falso. Principio: C.11 (transparencia del cambio).
- **R-HARDCODE-1 (un tope "mágico" suele estar en más de un lugar).** El tope 4 del comparador estaba en 5 sitios (estado, guards, textos), no solo en `maxSel`. Regla: antes de cambiar un límite, `grep` exhaustivo del valor y unificar en constante nombrada (C.10); cambiar solo uno deja textos/guards mintiendo. Ejemplo: #137.
- **R-SIG-CANAL (dos significancias distintas no se confunden).** `sigdif` (temporal, vs evaluación anterior) y `sigdifgru` (vs GSE) son campos distintos; la señalética de #139 usa el temporal. Regla: al añadir un glifo de significancia, declarar explícitamente cuál de las dos señales lee y verificar el campo en `serieEje`/`indOf` antes de prometer. Contexto: confundirlas pinta una comparación falsa.
- **R-PAYLOAD-DELTA (cuando un cambio toca el payload, auditar el delta, no confiar).** En #141 el riesgo no era visual sino que una cifra se moviera. Regla: capturar el JSON antes de editar, comparar estructuralmente después (`jsonlite::fromJSON` + `identical` excluyendo la clave que debe cambiar), confirmar que el delta es solo el campo nuevo. Byte-idéntico aplica a cambios solo-template; delta-acotado aplica a cambios de generador. Principio: B.4.

---

## 8. Decisiones de diseño

- **DS22-1 — #9 (color de dimensiones por puntaje): NO se implementa.**
  - **Decisión:** no recolorear las dimensiones en función de su puntaje.
  - **Alternativas:** (A) teñir el swatch de la dimensión por luminancia según `prom`; (B) no implementar, dejar el puntaje codificado por longitud de barra + número.
  - **Justificación:** la opción A colisiona con `nivelRamp` (la rampa monocromática claro→oscuro de niveles Bajo/Medio/Alto, derivada del color del indicador): habría dos codificaciones claro-oscuro del mismo matiz significando cosas distintas (qué dimensión vs qué nivel). El puntaje ya tiene canal (longitud + número); duplicarlo en color resta legibilidad. Implementar A exigiría primero mover `nivelRamp` a otro matiz, lo que reabre P-PALETA-v2 sin beneficio claro.
  - **Implicancia:** el pendiente #9 se cierra como resuelto-por-decisión. Si en el futuro se quiere codificar puntaje por color, primero se decide la separación de matices con la rampa de niveles.
- **DS22-2 — `nivel_alto` como constante del generador, no como columna del catálogo parquet.**
  - **Decisión:** los 4 textos editoriales viven como constante nombrada `INDICADOR_NIVEL_ALTO` en `35_generar_motor_html.R`, junto a `INDICADOR_LABELS`/`CORTO`/`COLORS`.
  - **Alternativas:** (A) constante en el generador; (B) columna nueva en `catalogo_idps.parquet` aguas arriba.
  - **Justificación:** el "qué refleja un puntaje alto" es prosa de comunidad derivada del corpus, no un dato medido de la Agencia; pertenece a la identidad de presentación (como labels y colores), no al parquet de datos. B obligaría a tocar la etapa de catálogo para alojar texto editorial. Coherente con C.10 (constantes nombradas).
  - **Implicancia:** futuros textos editoriales por indicador siguen el mismo patrón (constante en el generador).
- **DS22-3 (operativa) — diferir commit y deploy del lote completo.** El titular optó por acumular Batch A + B sin commitear para seguir iterando. Implicancia: s23 abre con un working tree cargado; el primer acto es ordenar y commitear (ver §11 y §12).

---

## 9. Constantes y parámetros vigentes (cambios/altas de s22)

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `CMP_MAX_TERR` | `10` | `35_motor_template.html` | **Nueva** (#137). Tope de territorios del comparador; referenciada en 5 lugares. Era `4` hardcodeado. |
| `--st-neutro` | `#7E8A99` | `35_motor_template.html` | **Cambiado** (#138). Era `#8C8A86`. Estado "sin diferencia". |
| `--yh` (`.hist-main .ybars`) | `168px` | `35_motor_template.html` | **Cambiado** (#135). Era `152px`. |
| `--yh` (`.hist-dim .ybars`) | `130px` | `35_motor_template.html` | **Cambiado** (#135). Era `118px`. |
| `INDICADOR_NIVEL_ALTO` | 4 textos por id | `35_generar_motor_html.R` | **Nueva** (#141). Constante editorial; alimenta el campo `nivel_alto`. |
| `MMOVIL_VENTANA` / `MMOVIL_MIN_PUNTOS` | `3` / `4` | `35_motor_template.html` | Sin cambio; #136 solo agrega leyenda. |
| md5 `idps_largo.parquet` | `4c764d8c…` | `40_salidas/intermedios/` | 🔒 Sin cambio en toda la sesión. |

---

## 10. Arquitectura de archivos

Escáner al cierre: `50_documentacion/estructura/estructura_actual.md` (2026-06-24 19:21:04; 31 carpetas, 270 archivos). Refleja s22: los 3 encargos en `50_documentacion/activa/encargos/`, los 3 logs en `50_documentacion/andamios/logs/`. Sin cambios de estructura de carpetas; conforme a la política (decenas, naming, ubicación). El archivo maestro del backlog (`50_documentacion/traspasos/backlog_historico.md`) debe actualizarse con el delta de §5 antes de considerar cerrado el cierre.

---

## 11. Pendientes y ruta sugerida

> Campos obligatorios por pendiente: descripción, contexto, tipo, impacto, dependencias, complejidad, principios, precauciones, enfoque sugerido, criterio de éxito.

### P-COMMIT-DEPLOY-S22 — Ordenar, commitear y desplegar el lote acumulado (PRIORIDAD 1)
- **Descripción:** el motor tiene Batch A en 4 commits locales (`50baa41`, `87cc923`, `0e1365b`, `3cf666c`) y Batch B1 + B2 **sin commitear** en el working tree, más los builds regenerados. Hay que commitear B1 (3 cambios: #138/#139/#140) y B2 (#141, toca generador + template) en commits atómicos por tema, regenerar el build final, y desplegar a `docs/` + push a `origin/main`.
- **Contexto:** el titular difirió el commit para seguir iterando (DS22-3). `origin/main` sigue en `41a3406` (s21).
- **Tipo:** deuda técnica / operativa (bloqueante de la limpieza del repo).
- **Impacto:** 2 archivos modificados (template, generador) + build + docs. Toca el payload (por #141).
- **Dependencias:** ninguna; todo está local y verificado.
- **Complejidad:** Media (los hunks de B1 y B2 conviven en el template; separar commits atómicos exige cuidado, como se hizo en Batch A reaplicando por fase).
- **Principios:** commits atómicos por tema (política §3); `git add` path-scoped, nunca `git add .`; push gateado.
- **Precauciones:** **leer el estado real antes de commitear** (R9 / A20: `git status`, `git diff`, `git ls-files`, no el escáner). Los hunks de #138/#139/#140 (B1) y #141 (B2) están entremezclados en `35_motor_template.html`; separarlos por tema requiere reaplicar o usar `git add -p`. Verificar que el build regenerado corresponde al template final. No desplegar `docs/` sin aprobación visual del build local (gate de gobernanza visual).
- **Enfoque sugerido:** (1) `git status` + `git diff` completos; (2) commits atómicos: uno por #138, #139, #140 (B1) y uno por #141 (B2, generador+template juntos porque son un solo cambio conceptual); (3) commit del build; (4) mostrar `git status` al titular; (5) con visto bueno, deploy a `docs/index.html` + push de todo (Batch A + B + deploy).
- **Criterio de éxito:** `origin/main` adelantado con todos los commits de s22; `docs/index.html` desplegado; `git ls-files` confirma que no entró nada espurio; motor en vivo muestra los 8 ajustes.

### P-DOC-REGEN-S22 — Regenerar la suite de documentación (PRIORIDAD 2)
- **Descripción:** `documentar.R` se actualizó (5 zonas + D7) pero los 4 `*_standalone.html` NO se regeneraron; siguen reflejando la versión que negaba el polígono GSE.
- **Contexto:** la regeneración requiere R + npm + red (descarga lucide-static fijado); es tarea de la máquina del titular (`Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source(".../50_documentacion/suite/documentar.R")'`).
- **Tipo:** documentación.
- **Impacto:** 4 HTML de la suite.
- **Dependencias:** npm disponible; `documentar.R` ya editado.
- **Complejidad:** Baja (un comando), pero fuera del entorno de Claude.
- **Principios:** §4.6.4 del SETTINGS (suite standalone).
- **Precauciones:** verificar `npm --version` antes; si un icono no resuelve, sustituir por el lucide más cercano; verificar 0 referencias de red en los 4 HTML tras generar.
- **Enfoque sugerido:** correr la generación, verificar los 4 HTML, decidir si se versionan (si la doc se publica desde el repo) o quedan locales.
- **Criterio de éxito:** los 4 `*_standalone.html` regenerados reflejan D7 y el polígono GSE; 0 referencias de red.

### P-BATCH-C — Ajustes convergentes de la ficha (#5, #8) (PRIORIDAD 3, BLOQUEADO)
- **Descripción:** dos ajustes de presentación que dependen de criterio visual:
  - **#5:** tarjetas del radar más anchas para que las anclas ("vs su GSE" / "vs año anterior") quepan en **una sola línea** (hoy envuelven a dos en tarjetas angostas).
  - **#8:** nombre del indicador en el radar más grande, sin superponerse con los vértices/etiquetas de eje.
- **Contexto:** son convergentes (A19): no se verifican contra dato ni regla, sino contra cómo deben verse. El render abierto de #141 (colapsable) puede acentuar el problema de ancho de #5.
- **Tipo:** mejora visual.
- **Impacto:** layout de la tarjeta del indicador (`.indp-*`) y del radar.
- **Dependencias:** **bloqueado a que el titular adjunte capturas** del estado actual (tarjeta con anclas envueltas; radar con el nombre superpuesto), o una referencia aprobada del estado deseado (A19).
- **Complejidad:** Media (layout, riesgo de iteración no convergente).
- **Principios:** A19 (referencia aprobada para iteración visual); B.3.
- **Precauciones:** no iterar a ciegas; pedir la referencia primero. #5 toca anchos de grilla que pueden afectar el radar y el comparador.
- **Enfoque sugerido:** con las capturas, diagnosticar el problema real (¿ancho de tarjeta? ¿tamaño de fuente del nombre? ¿margen del SVG?) antes de proponer; si no converge, pedir artefacto de referencia y hacer reverse-engineering (A19).
- **Criterio de éxito:** anclas en una línea sin desbordar; nombre del radar legible sin superposición; verificado contra la referencia aprobada.

### Deudas preexistentes detectadas en s22 (no abordadas, anotadas para no perderlas)
- **P-CODIGO-MUERTO-PANELEVOLUCION:** el componente `PanelEvolucion` (`35_motor_template.html` ~L815/L827) está **huérfano desde P3-s9** (la vista histórica usa `BarrasAnio`; era el único otro consumidor vivo de `.axis-lab.b`). Tipo: limpieza / deuda técnica. Enfoque: confirmar que ningún render lo invoca (`grep`), eliminarlo en una sesión de limpieza dedicada. Criterio: 0 referencias; motor sin regresión. Precaución: A20 (verificar contra el índice real, no el escáner).
- **P-COMENTARIO-SCOREBAR-OBSOLETO:** el comentario de `ScoreBar` (`35_motor_template.html` ~L786-789) aún afirma "el promedio absoluto del GSE no existe en el dato… derivarlo viola lee-no-deriva" — **falso desde la decisión D7 de s21** (igual que los comentarios ya corregidos en el generador en s21). Tipo: limpieza / deuda documental en código. Enfoque: reescribir el comentario para reflejar D7 (la cifra es pública y se reconstruye; `ScoreBar` no la dibuja por elección de diseño de esa barra, no por prohibición). Criterio: comentario coherente con D7. Bajo riesgo (sin efecto runtime).

### Pendientes heredados aún abiertos (de v21, no tocados en s22)
- **P-GITIGNORE-TOKEN:** el patrón `*token*` del `.gitignore` es demasiado amplio para un proyecto que usa tokens CSS (`--fs-*`, tokens de color); riesgo de ignorar archivos legítimos con "token" en el nombre. Acotar el patrón. (⚠️ vigente: evitar "token" en nombres de archivo hasta resolverlo.)
- **Ítem 11 (lista de EE por segmento):** requiere repo hermano; diferido desde s19/s20.
- **IDPS histórico 2014–2019:** sesión de datos dedicada (extender `34_leer_normalizar_idps.R`; `PATRON_DATOS` solo soporta 2022–2025).
- **P-SLEPVERSE:** sesión estratégica dedicada.

### Auditoría de cierre (política §5.6, preguntas "Cierre")
- ¿Pipeline reproducible sin intervención manual? → Sí (no se tocó el pipeline de datos).
- ¿Outputs reproducibles e idempotentes? → Sí (build regenerado desde el template; payload determinista).
- ¿Decisiones metodológicas como constantes nombradas? → Sí (#137 `CMP_MAX_TERR`, #141 `INDICADOR_NIVEL_ALTO`, #135 `--yh`, #138 `--st-neutro`).
- ¿Cada transformación crítica con check? → No aplica (sin transformación de datos nueva).
- ¿Nombres sin tildes/ñ/espacios? → Sí (encargos y logs conformes).
- **Respuesta "no" convertida en pendiente:** ninguna nueva; las deudas detectadas quedan en los pendientes de arriba.

### Ruta sugerida para s23 (en orden)
1. **P-COMMIT-DEPLOY-S22** (bloqueante de limpieza; abre la sesión leyendo el estado real del working tree).
2. **P-DOC-REGEN-S22** (tarea del titular; recordarla en la apertura).
3. **P-BATCH-C** si el titular trae las capturas; si no, diferir.
4. Oportunista (sesión de limpieza): P-CODIGO-MUERTO-PANELEVOLUCION + P-COMENTARIO-SCOREBAR-OBSOLETO (van juntas, ambas son higiene del template).
5. Diferir: P-GITIGNORE-TOKEN, Ítem 11, IDPS histórico, P-SLEPVERSE (sesiones dedicadas).

---

## 12. Instrucciones específicas para la próxima sesión

- ✅ **ANTES de commitear**, leer el estado real: `git status`, `git diff`, `git ls-files`. Los hunks de Batch B1 (#138/#139/#140) y B2 (#141) conviven en `35_motor_template.html`; separarlos en commits atómicos por tema exige `git add -p` o reaplicar. NO confiar en el escáner para el índice (A20).
- ⚠️ **NO `git add .`** — siempre path-scoped. Commits atómicos por tema.
- ⚠️ **NO push ni deploy a `docs/`** sin gate explícito del titular y sin aprobación visual del build local.
- 🔒 **Parquet `idps_largo.parquet` (`4c764d8c…`) intocable.** Ningún pendiente abierto lo toca.
- 🔒 **Decisión GSE (D7) vigente:** el polígono GSE de referencia se dibuja (cifra pública reconstruida); cualquier comentario o texto que lo niegue es residuo a sanear (ver P-COMENTARIO-SCOREBAR-OBSOLETO).
- ⚠️ **Evitar "token" en nombres de archivo** hasta cerrar P-GITIGNORE-TOKEN.
- ⚠️ Comandos a terminal se pegan sin prosa (zsh rompe con paréntesis).
- ✅ **ANTES de tocar `35_motor_template.html`**, releer las zonas: las líneas se movieron en Batch A/B1/B2 (el archivo creció). Localizar por contenido, no por número de línea heredado.

---

## 13. Fragmentos de código de referencia

```r
# Patrón canónico de #141: texto editorial por indicador como constante nombrada
# del generador (NO en el parquet de datos; DS22-2). Junto a INDICADOR_CORTO/COLORS.
INDICADOR_NIVEL_ALTO <- c("1" = "…", "2" = "…", "3" = "…", "4" = "…")
# y en indicadores_lst:  nivel_alto = unname(INDICADOR_NIVEL_ALTO[id])
```

```text
# Auditoría del delta de payload cuando un cambio toca el generador (R-PAYLOAD-DELTA):
# 1. ANTES de editar: extraer y guardar el JSON del build vigente
#    (atob → base64_dec → memDecompress gzip → JSON compacto).
# 2. DESPUÉS de regenerar: fromJSON de ambos; identical(viejo, nuevo) excluyendo la
#    clave que debe cambiar; por ítem, reportar campos añadidos/quitados.
# 3. Confirmar: el único delta es el campo nuevo; ninguna cifra cambió.
```

---

## 14. Reapertura

**Nombre del chat:** `slep_idps, sesión 23 (Opus 4.8)`

**Mensaje de apertura pre-armado:**
> Tipo CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md + DISCIPLINA_OPERATIVA.md) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v22, el escáner y el backlog histórico (a 141). **Estado especial: s22 dejó todo el trabajo del motor sin commitear** (Batch A en 4 commits locales; Batch B1/B2 en working tree) y la suite de doc editada sin regenerar. Foco propuesto: P-COMMIT-DEPLOY-S22 (ordenar y commitear el lote acumulado, leyendo primero el estado real del working tree), luego recordar P-DOC-REGEN-S22 (tarea mía). Batch C sigue bloqueado a que adjunte capturas.

**Documentos para s23:**
1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que estén al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `DISCIPLINA_OPERATIVA.md`.
2. *Opcionales según foco:* `CLAUDE.md` (s23 correrá en Claude Code para el commit/deploy); `encargo_autonomo_claude_code_v1.md` si se redacta otro encargo.
3. *Específicos de la sesión (SÍ se adjuntan):* el traspaso `traspaso_cierre_v22.md`; el escáner `estructura_actual.md`; el backlog `backlog_historico.md` (ya actualizado a 141); si s23 aborda Batch C, las **capturas** de #5 y #8.

**Nota final:** si `35_motor_template.html`, `35_generar_motor_html.R` o `documentar.R` cambiaron entre sesiones (no deberían: quedaron sin commitear esperando s23), adjuntar la versión más reciente y avisarlo en la apertura.
