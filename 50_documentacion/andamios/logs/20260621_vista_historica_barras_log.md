# Log — Vista histórica de la ficha: barras por año (P3-s9)

**Sesión 9 · 2026-06-21 · corrección de fidelidad de UI (presentación pura).**
Solo se tocó `30_procesamiento/35_motor_template.html` (+ regeneración `only=35`).
El parquet NO se tocó. `docs/` NO se republicó (espera OK visual del titular).

---

## Resumen

La vista histórica de la ficha ("Panorama IDPS por establecimiento", `isHist===true`)
renderizaba **líneas de tendencia** D3 (`PanelEvolucion`). El diseño aprobado
(`Propuesta_IDPS.html` + `idps-demo.js`) pide **barras verticales discretas por año**
(`.ybars`). Se reemplazó el componente de líneas por uno de **barras por año** (`BarrasAnio`,
CSS puro), anidando **indicador → dimensión** (subdimensión NO entra, 🔒-3), con una **marca
de tendencia** (`HistTrend`) en la cabecera de cada bloque. La **vista actual no se tocó**.

Estado final: **HECHO**. 0 errores de consola; verificado en navegador (EE 4° básico con el
hueco estructural de 2024 y el año 2025 preliminar atenuado). md5 del parquet intacto.

---

## Inventario de commits

| Hash | Tipo | Título | Qué hizo |
|---|---|---|---|
| `bbeacde` | style | portar CSS de barras por año (.ybars) del diseño al template | `.ybars/.ybar-col/.ybar-plot/.ybar-fill(.is-prelim)/.ybar-val/.ybar-yr/.ybar-empty` + `.hist-main/.hist-dim .ybars` (--yh) + `.hist-dim-h/.hist-dim-name` + `.hist-trend(.tiny/.de/.al/.nt/.ht-ic)`, traducido a tokens del motor. `.hist-main` padding-top 12→22px (aire para el valor sobre la barra). |
| `e6fb5ce` | feat | componente BarrasAnio (barras verticales por año, eje 0-100) | Componentes `BarrasAnio({nombre,color,pts})` (columna por año; barra altura=`v%`; hueco=columna sin barra; preliminar=`is-prelim`+`*`; tooltip `showTT`) y `HistTrend({pts,tiny})` (último año con `dif!=null` vs evaluación anterior, leído). |
| `6edfeaf` | feat | vista historica de ficha usa barras por año (indicador y dimension), reemplaza lineas | En `hist-wrap`: `PanelEvolucion`→`BarrasAnio` en indicador (`.hist-main`) y dimensión (`.hist-dims`, cada una en `.hist-dim` con su cabecera + `HistTrend.tiny`); `HistTrend` en la cabecera del indicador; `nota-inv` reescrita ("marca de cada año"→"marca de tendencia en cada cabecera"); `PanelEvolucion` marcado HUÉRFANO. |
| `c407d65` | build | regenerar only=35 con barras por año en vista historica | Regeneró `40_salidas/motor_idps.html` desde el template. Parquet intacto. |

---

## Cambios sustantivos

### 1. CSS `.ybars` portado (Fase 2)
- **Qué:** familia `.ybars` del diseño, traducida (`--ink`→`--tinta`, `--slate`→`--gris`,
  `--line(-strong)`→`--linea`, `--st-*`→`--alerta`/`--destaca`/`--st-neutro`).
- **Por qué:** el motor no tenía CSS de barras (`grep -c ybars` previo = 0); usaba líneas.
- **Archivos:** `35_motor_template.html` (`<style>`, junto a `.hist-*`).
- **Verificación:** clases presentes; sin `*/` literal en comentarios (🔒-7).

### 2. `BarrasAnio` — barras por año, eje 0-100 (Fase 3)
- **Qué:** componente React. Una `.ybar-col` por año de `pts` (shape de `serieFull`:
  `{a,v,dif,sig}`). `v==null`/hueco → columna con `sin dato`, sin barra. `v` → `.ybar-fill`
  con `height: v%` (clamp 0-100), `.ybar-val` encima, `.ybar-yr` (con `*` si preliminar)
  debajo. Preliminar → clase `is-prelim`. Tooltip con `nombre + año + fmt(v)`.
- **Decisión enfoque CSS vs D3:** **CSS puro** (como el diseño), no D3. El diseño dibuja las
  barras con `position`/`height %`; replicarlo da fidelidad exacta y evita el coste de un
  `useEffect`/SVG por panel. (El viejo `PanelEvolucion` usaba D3 por ser línea.)
- **`HistTrend`:** marca de cabecera. Toma el **último punto con `dif!=null`** (leído de la
  Agencia, no derivado), su año previo con dato, y muestra `vs <añoPrev>[*]: <▲/▼/=> <±dif> ·
  <sig.|n.s.>`. Glifo/color por `sigdif` (1=▲ destaca, -1=▼ alerta, 0/null== st-neutro).
- **Decisión copy:** se usó `sig.`/`n.s.` (abreviado, estilo del motor — igual que `Ancla`)
  en vez del `significativo`/`no significativo` completo del diseño, por espacio en la
  cabecera (sobre todo en dimensiones, grid 2-col). La significancia se comunica igual.

### 3. Sustitución en `hist-wrap` (Fase 4)
- **Qué:** indicador y dimensión ahora usan `BarrasAnio`; `HistTrend` en cada cabecera.
  Dimensiones reestructuradas a `.hist-dim` con `.hist-dim-h` (swatch + nombre + tendencia).
- **`PanelEvolucion` huérfano:** ya no se referencia en JSX (solo su definición). **Decisión:
  conservarlo definido** con comentario `HUÉRFANO desde P3-s9 … por si se revierte`. Motivo:
  menor riesgo que borrarlo; el CSS `.evol-*` asociado queda igualmente sin uso (inocuo). El
  titular puede eliminarlo en una pasada de higiene si lo prefiere.

---

## Verificación de invariantes 🔒

| 🔒 | Estado | Evidencia |
|---|---|---|
| 1 — Cero agregación | **PASA** | `BarrasAnio` recibe `serieFull(indOf/dimOf, rbd, …)`: puntaje del EE individual por año. Ningún promedio entre EE. |
| 2 — Lee, no deriva | **PASA** | La barra grafica `prom` del propio EE (no `prom−difgru`). La tendencia usa `dif`/`sigdif` **leídos** (no `v−v`): p.ej. EE 1853, 2025 vs 2023 mostró `-14` (dif Agencia), no `63−82=−19`. Sin `#B7AC96` (`grep -c`=0). |
| 3 — Subdimensión = distribución | **PASA** | El histórico NO renderiza subdimensión: `grep hist-sub`=0; `hasSubdimInHist`=0 en el render. Solo indicador y dimensión. |
| 4 — Eje fijo 0-100 | **PASA** | `height` = `Math.max(0,Math.min(100,v))%` sobre `.ybar-plot` de altura fija (`--yh`); sin autoescala. Alturas medidas 117/123/95px para v=78/82/63 (plot 152px). |
| 5 — No interpolar huecos | **PASA** | EE 4° básico: columnas 2022/2023/2025 (sin 2024; no está en `anios` del grado). `v==null` → columna sin barra (`sin dato`). 2025 preliminar atenuado + `*`. |
| 6 — Paleta 4 indicadores | **PASA** | Barras de indicador con `ind.color` (`#EE2D49`… medido `rgb(238,45,73)`); dimensiones con `dimColor(ind.color,di,n)`. Paleta intacta. |
| 7 — CSS sin `*/` literal | **PASA** | Comentarios nuevos sin `*/` mid-texto (solo terminadores). |
| 8 — Parquet intacto | **PASA** | md5 `50d9de4f1fc80259d29f499cdf46d9e1` **antes** y **después**. `run_all(only=35)` (no tocó 31-34). |

---

## md5 del parquet

- ANTES:   `50d9de4f1fc80259d29f499cdf46d9e1`
- DESPUÉS: `50d9de4f1fc80259d29f499cdf46d9e1` ✓ idéntico.

---

## Auto-auditoría (3 checks del encargo)

1. **Fidelidad visual:** PASA. Barras por año, valor encima, año debajo, 2025 atenuado +
   contorno discontinuo, anidamiento indicador→dimensión; tendencia en cabecera. Coincide con
   la estructura del diseño (`.ybars`). Divergencia residual menor: copy de tendencia abreviado
   (`sig.`/`n.s.`) vs completo del diseño (decisión por espacio, ver arriba).
2. **🔒-3 subdimensión ausente:** PASA. `grep hist-sub`=0; sin `SubDist`/`DistBar` en el histórico.
3. **🔒-8 md5:** PASA. Igual antes/después.

---

## Notas para el revisor

- **Mirar con ojo crítico:** la marca de tendencia usa el `dif` leído de la Agencia, que puede
  NO coincidir con la resta visual de las alturas de las barras (p.ej. -14 vs -19). Es
  **correcto** por 🔒-2 (no derivar), pero un lector podría esperar que "cuadre" con las
  barras; si se quiere, se puede añadir una nota al tooltip (hoy el `title` ya dice "leído de
  la Agencia").
- **Aire del valor sobre la barra:** se subió `.hist-main` padding-top a 22px para que el
  `.ybar-val` (top:-19px) no choque con la cabecera en barras altas (v≈100). Verificar que en
  dimensiones (grid 2-col, `--yh` 118) el valor tampoco choque con `.hist-dim-h` (en la prueba
  no chocó).
- **Deuda residual:** `PanelEvolucion` y el CSS `.evol-*` quedan **huérfanos** (sin uso). Se
  conservaron por reversibilidad; candidatos a limpieza futura.
- **Deploy:** `docs/` quedó **sin tocar**. La republicación a Pages es el **paso siguiente del
  titular** tras OK visual sobre `motor_idps.html` (compuerta P0-s9).

## Decisión sobre este log
Queda **sin commitear** (para revisión del titular), igual que se hizo con los logs de Fase 3
y Fase 4 antes de versionarlos en el cierre. El titular decide si lo versiona en el cierre de
sesión 9.
