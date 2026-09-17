# Traspaso de cierre — slep_idps — v24

**Proyecto:** slep_idps (motor IDPS nacional, React 18 + D3 v7 inline, GitHub Pages)
**Versión:** v24
**Fecha:** 2026-06-25
**Sesión:** 24 — administrativa y de higiene (cuadrar backlog a v23, P-CSS-MUERTO, P-DOC-CFG-CRUZADA, higiene del working tree, deploy + push).
**Entorno:** R 4.5.x, Positron (macOS aarch64); Claude Code para terminal/git; Claude web para análisis y encargos.
**Modelo:** Opus 4.8.
**Archivos principales modificados:** `50_documentacion/activa/backlog_historico.md`, `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`, `docs/index.html`, `50_documentacion/suite/documentar.R`, `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md`, más versionado de deuda documental acumulada (traspasos, logs, escáner, reseña).

---

## 1. Resumen ejecutivo

Sesión administrativa que saldó las tres deudas de cierre que v23 dejó documentadas, sin tocar cifras ni el parquet. Se consolidó `backlog_historico.md` a **v23/144** (integrando s22, que nunca se había escrito en el maestro, y s23). Se cerró **P-CSS-MUERTO** eliminando las reglas CSS huérfanas `.evol-*` y `.fr-head` del template (payload byte-idéntico). Se cerró **P-DOC-CFG-CRUZADA / DEC-s23-3**: la auditoría de la `cfg` de `documentar.R` reveló que **ya estaba limpia** de contenido cruzado de `slep_simce_adecuado` (0 marcadores SIMCE en las 406 líneas), de modo que el "saneo" se redujo a regenerar la suite standalone, verificar offline + sin SIMCE, y versionar `documentar.R`. Se hizo una **pasada de higiene del working tree** que versionó deuda documental acumulada (traspasos v20–v23, 6 logs de andamio, rotación del escáner, reseña) en commits atómicos por grupo. Finalmente, **deploy del motor a `docs/` + push de 9 commits**: el motor con la higiene CSS quedó en producción byte-idéntico al build aprobado. El backlog NO ganó entradas nuevas: s24 fue higiene y mantención, sin solicitud de producto distinguible. `origin/main = 01b0f14`, working tree limpio.

---

## 2. Estado al cierre

**Qué funciona:**
- Motor en producción (`docs/index.html = 01b0f14`), con la higiene CSS de P-CSS-MUERTO. Última ejecución exitosa: deploy byte-idéntico (`cmp` build vs docs = idéntico).
- Suite de documentación regenerada en modo standalone offline (4 `*_standalone.html`, 0 referencias de red reales, 0 marcadores SIMCE).
- `backlog_historico.md` consolidado a v23/144, cuatro totales cuadrados.
- Working tree limpio; toda la deuda documental acumulada (traspasos, logs, escáner, reseña, SETTINGS v4) versionada y empujada.

**Qué no funciona / pendiente:** nada roto. Los pendientes son de fondo (ver §11), ninguno bloqueante.

**Delta respecto a v23:**
- `origin/main`: `33ea07a` (v23) → `01b0f14` (v24).
- Backlog: v21/133 en disco → **v23/144** (s22 y s23 integradas).
- 9 commits nuevos publicados (detalle en §4).
- SETTINGS en el repo: v3 → **v4** (subsección 4.6.4 suite standalone offline), alineado con la knowledge base.

---

## 3. Registro detallado de cambios

### 3.1 Consolidación del backlog a v23/144 (`988fd05`)
- **Archivo:** `50_documentacion/activa/backlog_historico.md`. **Categoría:** Limpieza / deuda técnica (memoria de largo plazo).
- **Qué:** integró dos sesiones que el maestro no había recogido — s22 (cuyas piezas quedaron preparadas en el traspaso v22 pero no se escribieron, por haber cerrado s22 con todo sin commitear) y s23. Encabezado a v23/144; dos filas nuevas en el resumen estadístico (s22 +8, s23 +3) + total; clasificación temática recalculada sobre 144 (Rediseño UI 38→47, Limpieza 14→15, Doc conceptual 9→10, % de todas las filas sobre nuevo denominador); dos líneas de detalle cronológico (s22 #134–141, s23 #142–144); dos deltas nuevos.
- **Por qué (C.11):** A22 — los conteos se verifican contra el detalle cronológico, no contra la tabla heredada. s22 había numerado #134–141 en su propio traspaso; s23 agregó #142–144 (solicitudes distinguibles del titular: #5 anclas, #8 etiquetas radar, eliminación del rótulo "Mirada integral"). PanelEvolucion y ScoreBar NO sumaron (higiene hallada por Claude Code, mismo criterio que el fix `.ancla` en s20).
- **Cómo se verificó (B.4):** los cuatro totales cuadran en 144 (suma de columna N° de la tabla temática = 144, vía conteo programático; correlativo global último #144; fila Total del resumen; encabezado). Entradas históricas 1–133 intactas (append-only).

### 3.2 P-CSS-MUERTO: elimina CSS huérfano del template (`f531cb5`)
- **Archivos:** `30_procesamiento/35_motor_template.html` + `40_salidas/motor_idps.html` (build). **Categoría:** Limpieza / deuda técnica.
- **Qué:** 4 ediciones quirúrgicas — (A) bloque `.evol-*` completo (comentario + 12 reglas); (B) `.evol-sw` quitado del selector compartido `.indp-dot,.rcard-dot,.th-sw,.sw,.evol-sw` (regla conservada); (C) `.hist-main .evol-panel`; (D) `.fr-head`.
- **Por qué (C.11):** s23 eliminó el componente `PanelEvolucion` y el rótulo "Mirada integral", dejando estas reglas sin selector vivo. B.3: solo se tocaron reglas huérfanas.
- **Cómo se verificó (B.4):** payload byte-idéntico (`cmp` del JSON descomprimido baseline vs build nuevo = idéntico); 0 reglas `.evol-*`/`.fr-head` en template y build; `.ancla`/`.arr`/`.fr-note`/`HistTrend` intactas; render idéntico a s23 (radar 300×300, anclas en 1 fila, 0 errores de consola). Parquet md5 `4c764d8c…` intacto. Log: `50_documentacion/andamios/logs/20260624_css_muerto_s24_log.md`.
- **Tensión resuelta:** una primera medición de render dio "2 filas" de anclas por un viewport degenerado (`vw:0`, server headless recién reiniciado); al fijar viewport 1280 se confirmó 1 fila. El CSS de layout (`.rquad`/`.rcard`/`.rcard-anc`) no se tocó; el payload byte-idéntico lo respalda.

### 3.3 P-DOC-CFG-CRUZADA / DEC-s23-3: regenera suite + versiona documentar.R (`6e7d4de`)
- **Archivo:** `50_documentacion/suite/documentar.R`. **Categoría:** Documentación de proyecto (mantención).
- **Qué:** auditoría completa de las 406 líneas de la `cfg` → **0 marcadores SIMCE** (la cfg ya estaba saneada en disco). Regeneración de la suite standalone offline; verificación de los 4 HTML; versionado de `documentar.R` (cierra DEC-s23-3).
- **Por qué (C.11):** B.1 — el traspaso v23 advirtió posible residuo ASCII puro, así que se auditó la cfg entera, no solo lo que disparó warnings. El hallazgo (cfg limpia) contradijo el supuesto del encargo; por R9/B.1 no se fabricó un saneo inexistente. Reconfirmado en disco por el titular (grep = 0).
- **Cómo se verificó (B.4):** 4 standalone con 0 referencias de red reales (el único `http://` es el namespace `xmlns` de los SVG embebidos, inerte) y 0 marcadores SIMCE; iconos como `<svg>` embebido, fuentes como `data:` URIs; enlazados intermedios borrados. Commit path-scoped (solo `documentar.R`, +10/-5). Log: `50_documentacion/andamios/logs/20260624_doc_cfg_cruzada_s24_log.md`.

### 3.4 Higiene del working tree (`9ba7dd4`, `169aa34`, `da6106c`, `21a8497`)
- **Categoría:** Limpieza / deuda técnica (A38: versionado = cierre real).
- **Qué:** cuatro commits atómicos por grupo — traspasos v20–v23 (`9ba7dd4`); 6 logs de andamio s21–s24 (`169aa34`); rotación del escáner, retención-2 (`da6106c`, git la representó como renames por similitud, efecto neto correcto); reseña del proyecto (`21a8497`).
- **Por qué (C.11):** deuda de versionado arrastrada de sesiones previas; cada `git status` la mostraba. A20 — la retención-2 del escáner se verificó contra el filesystem (2 timestamps sellados en disco) antes de versionar.
- **Cómo se verificó (B.4):** path-scoped en cada fase, nunca `git add .`; standalone y `.DS_Store` gitignorados confirmados fuera. Sin log de andamio (higiene de git, no cambio de producto).

### 3.5 SETTINGS v4 (`9f6c42f`) y deploy (`01b0f14`)
- **SETTINGS:** `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` v3→v4 (subsección 4.6.4: suite standalone offline, precondición npm+red, validación de iconos, ajuste de versionado). +85/-1. Detenido por Claude Code en la higiene (diff sustantivo = gobernanza, gate del titular) y commiteado tras aprobación. Alinea el repo con la knowledge base.
- **Deploy:** `cp 40_salidas/motor_idps.html docs/index.html` (byte-idéntico, `cmp` ok) + commit path-scoped `docs/index.html` (`01b0f14`, +1/-16 = la higiene CSS que `docs/` aún no tenía). Gate visual del titular otorgado sobre el build local antes del deploy.

---

## 4. Inventario de commits de la sesión (9, todos en `origin/main`)

| # | Hash | Tipo | Título |
|---|------|------|--------|
| 1 | `988fd05` | docs | consolida backlog a v23/144 (integra s22 134-141 y s23 142-144) |
| 2 | `f531cb5` | style | elimina CSS muerto .evol-*/.fr-head (P-CSS-MUERTO) [template + build] |
| 3 | `6e7d4de` | docs | regenera suite con cfg saneada y versiona documentar.R (DEC-s23-3) |
| 4 | `9ba7dd4` | docs | versiona traspasos v20-v23 (deuda A38) |
| 5 | `169aa34` | docs | versiona logs de andamio s21-s24 |
| 6 | `da6106c` | docs | rota snapshots de estructura (retencion-2) |
| 7 | `21a8497` | docs | versiona resena del proyecto |
| 8 | `9f6c42f` | docs | SETTINGS a v4 (subseccion 4.6.4 suite standalone offline) |
| 9 | `01b0f14` | deploy | publica motor con higiene CSS s24 (P-CSS-MUERTO) |

`origin/main`: `33ea07a` → `01b0f14`.

---

## 5. Backlog acumulativo

**Estado:** consolidado a **v23/144** en `988fd05`. **s24 NO aporta entradas nuevas** al correlativo: fue sesión administrativa y de higiene (consolidación del propio backlog, eliminación de CSS muerto, regeneración de doc, versionado de deuda, deploy). Por la nota metodológica, ninguno es una solicitud de producto distinguible del titular; son mantención y limpieza, que no ocupan correlativo (mismo criterio con que P-DOC-REGEN no sumó en s22). El detalle cronológico y la clasificación temática quedan como están en el maestro v23/144. El total permanente sigue en **144**; el próximo cambio de producto será #145.

**Delta del backlog en s24:** 0 entradas nuevas. El maestro pasó de v21/133 en disco a v23/144 versionado (acto de consolidación, no de creación de entradas).

---

## 6. Bugs de la sesión

Ninguno. Una tensión de medición resuelta (viewport degenerado en P-CSS-MUERTO, §3.2), sin impacto en producto.

---

## 7. Aprendizajes y restricciones descubiertas

- **R-AUDIT-ANTES-DE-SANEAR (B.1/R9):** cuando un pendiente describe un saneo ("la cfg tiene contenido cruzado"), auditar el estado real ANTES de redactar el encargo de saneo. En s24 la cfg de `documentar.R` ya estaba limpia; redactar un encargo de saneo habría fabricado trabajo inexistente. El hallazgo reconvirtió el pendiente de "sanear" a "regenerar + versionar". Contexto: si se viola, Claude Code recibe un encargo para corregir algo que no está mal y puede "corregir" de más.
- **R-FALSO-POSITIVO-OFFLINE:** al verificar suites standalone, `grep` de `http://` arroja falsos positivos por `xmlns="http://www.w3.org/2000/svg"` (namespace XML de SVG embebidos, inerte). La verificación correcta excluye el namespace y cuenta solo recursos cargables (`<link>/<script>/<img>/<use>` con http). Ya anticipado en el SETTINGS v4 / `prompt_activar_suite_standalone` (caso `xmlns` false-positive), confirmado en vivo.
- **R-VIEWPORT-RENDER (refuerzo de R-GRID-VIEWPORT, s23):** un server de preview headless recién reiniciado puede arrancar con viewport degenerado (`vw:0`), produciendo falsos "2 filas". Fijar viewport explícito (1280) antes de medir layout.
- **A38 confirmado:** versionar la deuda documental (traspasos, logs) ANTES de cerrar evita arrastrar una cola de untracked que ensucia cada `git status`. La sesión s24 saldó traspasos v20–v23 que llevaban sin versionar desde sus respectivas sesiones.

---

## 8. Decisiones de diseño

- **DEC-s24-1 — s24 no aporta entradas al backlog.** Alternativas: (a) numerar PanelEvolucion/ScoreBar/regeneración como entradas; (b) no numerar nada de s24. Elegida (b): por la nota metodológica, son higiene y mantención, no solicitudes de producto. Justificación: mantiene el correlativo como medida de trabajo de producto, no de actividad técnica. Implicancia: el próximo cambio de producto es #145.
- **DEC-s24-2 — SETTINGS v4 se versiona en el repo.** El cambio (subsección 4.6.4) ya regía desde la knowledge base; versionarlo solo alinea el repo, misma lógica A38 que los traspasos. Sin tensión: es protocolo ya vigente, no una propuesta nueva.

---

## 9. Constantes y parámetros vigentes

Sin cambios de valor en s24. Vigentes: parquet `idps_largo.parquet` md5 `4c764d8c9f0bf70004f8aa52661ae901` (inmutable); paleta de indicadores = folleto Agencia (D6); reconstrucción `prom_GSE = prom − difgru` a nivel indicador, 2024–2025 (D7); retención-2 del escáner.

---

## 10. Arquitectura de archivos

Estructura conforme a la política (verificada en apertura: 31 carpetas, sin desviaciones nuevas; espacios en `andamios/diseno/` son deuda heredada congelada). El escáner rotó a los snapshots `20260624_204338` y `20260624_230515` (retención-2). Referencia de cierre: `50_documentacion/estructura/estructura_actual.md`.

**Registro de ejecución detallado:** logs de Claude Code en `50_documentacion/andamios/logs/` — `20260624_css_muerto_s24_log.md` (P-CSS-MUERTO) y `20260624_doc_cfg_cruzada_s24_log.md` (P-DOC-CFG-CRUZADA); detalle paso a paso no reproducido aquí.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes (heredados de v23, ninguno cerrado por trabajo de producto en s24)

- **IDPS histórico 2014–2019** (instrucción explícita del titular). *Tipo:* funcionalidad / sesión de datos dedicada. *Contexto:* extender `34_leer_normalizar_idps.R`; el `PATRON_DATOS` actual solo soporta `idps<grado><AAAA>_..._<final|preliminar>` y años 2022–2025. Los archivos históricos (`idps_4b2018`, `idps19_rbd`, etc.) no calzan; solo `idpsNb2017_rbd_final` (2m/4b/8b) entra al patrón. *Precaución:* NO integrar a ciegas — inspeccionar un xlsx por época antes de re-correr el script 34. Fuente en `/Users/tomgc/Desktop/idps`. Posible crosswalk de indicadores históricos; decisión pendiente sobre años con solo familia `rbd` (sin `dim`/`niveles`). *Complejidad:* Alta.
- **Batch B (ítems con propuesta):** #7, #9, #13, #18, #23. *Tipo:* funcionalidad / mejora visual. *Nota:* #9 quedó cerrado como no-implementado en s22 (DS22-1); revisar si sigue en la lista. *Complejidad:* Media.
- **Batch C (ítems visuales convergentes):** #5 y #8 ya cerrados (s23, #142–143). Revisar si quedan ítems abiertos en el batch.
- **P-SLEPVERSE:** extracción de código duplicado a paquete R interno. *Tipo:* deuda técnica / estratégica. *Precaución:* inventario de duplicación real (enfoque B) es paso obligatorio previo. *Complejidad:* Alta. Sesión dedicada.
- **Ítem 11:** bloqueado por repo hermano.
- **P-GITIGNORE-TOKEN:** revisar (heredado de v23).
- **Observación de umbral del backlog:** "Visualización / diseño — rediseño UI" en 47/144 (33%), sobre el 25%. Candidata a subdivisión en una sesión de higiene del backlog (sin renumerar, append-only).
- **`# REVISAR (voz)` en `documentar.R`:** marcas de prosa de comunidad (L316, L375) para afinar tono; el dato es correcto. *Tipo:* documentación. *Complejidad:* Baja.

### Auditoría de cierre (política 5.6)
- ¿Pipeline reproducible? Sí (`run_all(only=35)` byte-idéntico). ✔
- ¿Outputs idempotentes? Sí (deploy byte-idéntico). ✔
- ¿Nombres sin tildes/ñ/espacios? Los archivos nuevos cumplen; deuda heredada en `andamios/diseno/` (espacios), congelada. ✔ (con deuda declarada)
- Sin respuestas "no" nuevas que generen pendiente.

### Ruta sugerida para s25
1. **IDPS histórico 2014–2019** (sesión de datos dedicada): es la instrucción explícita del titular y el pendiente de mayor valor. Empezar por la inspección de un xlsx por época (NO re-correr 34 a ciegas), luego decidir crosswalk y tratamiento de años solo-`rbd`. *Criterio de éxito:* un xlsx por época inspeccionado y el patrón de extensión de `34` decidido antes de tocar el script.
2. **Alternativa si no hay tiempo de datos:** sesión de higiene del backlog (subdividir "Rediseño UI", resolver `# REVISAR (voz)`), de menor riesgo.

**Recomendación:** s25 = IDPS histórico — es la instrucción explícita del titular y desbloquea la serie 2014–2019 que el motor ya muestra como eje contiguo pero sin datos pre-2022.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 `idps_largo.parquet` md5 `4c764d8c…` intocable; nunca reescribir columnas de medida.
- 🔒 D7: polígono GSE de referencia se dibuja (`prom − difgru`), solo a nivel indicador, 2024–2025, omitido si falta algún dato (nunca parcial, `.every`, nunca NA→0).
- 🔒 Sin agregación territorial; GSE inviolable como segmentador; básica y media nunca mezcladas.
- 🔒 Los 4 `*_standalone.html` de la suite están gitignorados por diseño; no versionarlos.
- ⚠️ NO integrar datos históricos 2014–2019 sin inspeccionar antes un xlsx por época.
- ⚠️ NO push/deploy a `docs/` sin gate visual explícito del titular.
- ⚠️ NO `git add .`; staging path-scoped; commits atómicos por tema.
- ✅ ANTES de redactar un encargo de saneo, auditar el estado real (R-AUDIT-ANTES-DE-SANEAR): el archivo puede ya estar limpio.
- ✅ ANTES de cualquier commit, leer estado real (`git status`/`diff`/`ls-files`); verificar retención-2 del escáner contra el filesystem (A20).
- ✅ Localizar por contenido, no por número de línea (A37).
- ✅ Al verificar suites standalone, excluir el namespace `xmlns` de SVG del conteo de referencias de red (R-FALSO-POSITIVO-OFFLINE).

---

## 13. Fragmentos de código de referencia

```r
# Regeneración canónica de la suite standalone offline (requiere npm + red en
# tiempo de generación; produce *_standalone.html y borra los enlazados).
# Desde la raíz del proyecto:
source("50_documentacion/suite/documentar.R")   # ya llama a generar_suite(..., standalone = TRUE)
```

```bash
# Verificación de offline real de un standalone (excluyendo el namespace xmlns inerte):
grep -oE '(href|src)="https?://[^"]*"' archivo_standalone.html | grep -vE 'w3\.org'
# vacío = sin recursos de red cargables (los xmlns="http://www.w3.org/2000/svg" no cuentan).
```

```bash
# Deploy del motor a producción (gate visual del titular requerido antes):
cp 40_salidas/motor_idps.html docs/index.html
cmp 40_salidas/motor_idps.html docs/index.html && echo "BYTE-IDENTICO"
git add docs/index.html && git commit -m "deploy(docs): ..."
```

---

## 14. Reapertura

**Nombre del chat:** `slep_idps, sesión 25 (Opus 4.8)`

**Mensaje de apertura pre-armado:**
> Tipo CONTINUATION de slep_idps. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md + DISCIPLINA_OPERATIVA.md) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v24 y el escáner. Estado: motor s24 desplegado (`origin/main = 01b0f14`), working tree limpio, backlog en v23/144. Foco propuesto: IDPS histórico 2014–2019 (sesión de datos dedicada) — inspeccionar un xlsx por época antes de extender `34_leer_normalizar_idps.R`.

**Documentos para la próxima sesión:**
1. *Protocolo en knowledge base* (NO se adjuntan; verificar que estén al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `DISCIPLINA_OPERATIVA.md`.
2. *Opcionales según foco:* `CLAUDE.md` si corre en Claude Code; `34_leer_normalizar_idps.R` y `10_configuracion.R` (crosswalk) si se aborda el histórico; `encargo_autonomo_claude_code_v1.md` si se delega ejecución.
3. *Específicos de la sesión* (SÍ se adjuntan): `traspaso_cierre_v24.md`; `estructura_actual.md`; para el foco histórico, la salida de inspección de un xlsx por época (a generar en s25) y la referencia de los archivos en `/Users/tomgc/Desktop/idps`.

**Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo.
