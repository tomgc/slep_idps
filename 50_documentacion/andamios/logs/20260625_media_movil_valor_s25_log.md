# Log — Valor de la media móvil en la vista histórica (cabecera + tooltip), s25

**Fecha:** 2026-06-25
**Modo:** autónomo, secuencial. Un solo commit (template + build).
**Base:** HEAD previo `7ea1baf`.

---

## 1. Resumen

La vista histórica dibujaba la media móvil como línea tenue pero no exponía su VALOR. Este
encargo añade, en grano indicador y dimensión: (a) el valor de la **media móvil vigente** en la
cabecera de cada panel (junto al HistTrend, etiquetado con su año); (b) en el **tooltip** por
barra, la media móvil DE ESE AÑO (o "sin media móvil (extremo de la serie)") y, **solo en
indicador**, la distancia **vs GSE** (glifo/color/sig). Todo es JS/CSS de presentación: el dato
ya está en el payload. Build regenerado, payload byte-idéntico, parquet intacto.

**Commit:** `c968c9e` — `feat(motor): muestra valor de media movil en cabecera y tooltip (vista
historica) + vs GSE en tooltip de indicador` (template + build; 72 insertions, 18 deletions).
`docs/` SIN tocar (gate visual del titular).

---

## 2. Por cambio: qué / por qué / verificación

### Fase 1 — Propagar `difgru`/`sigdifgru` en `serieEje`
- **Qué:** `serieEje` ahora devuelve también `difgru`/`sigdifgru`, condicional a presencia del
  campo (`d.difgru!=null?…:null`). La rama `estado!=="con_dato"` los pone en `null` (forma
  homogénea). No se ramifica la función por grano.
- **Por qué:** `indOf` trae difgru/sigdifgru; `dimOf` no → en dimensión quedan `null`. Así el
  tooltip de indicador puede mostrar vs GSE y el de dimensión nunca (no existe el dato).
- **Verificación:** tooltip de dimensión sin línea GSE (ver §3); tooltip de indicador con
  "vs GSE: ▼ -1 · n.s." en 2024 y "▼ -3 · n.s." en 2025.

### Fase 2 — Media móvil vigente en la cabecera
- **Qué:** en el `.map` de indicadores y de dimensiones, IIFE que calcula `mediaMovil(ipts)`/
  `mediaMovil(dpts)`, toma el ÚLTIMO elemento (vigente = penúltimo año con dato) y renderiza un
  texto suelto `<span className="mm-head"><span className="mm-line"></span> media móvil {AAAA}:
  <b>{fmt(m)}</b></span>` junto al HistTrend. Si `mediaMovil` devuelve `[]` (serie < 4 puntos),
  no renderiza nada.
- **CSS:** `.mm-head` (texto suelto, `--fs-sm` indicador / `--fs-xs` dimensión, color `--gris`,
  `b` en `--tinta`/`--fw-heavy`); `.mm-line` (muestra de trazo 16px, `border-top:2px var(--ic)`,
  opacity .6); `flex-wrap:wrap` + `gap` en `.hist-ind-h`/`.hist-dim-h`. El HistTrend ya lleva
  `margin-left:auto`, así que empuja el grupo a la derecha; la media móvil va después y por
  flex-wrap baja sola al renglón siguiente en ancho estrecho.
- **Verificación:** indicador "media móvil 2024: 72,3"; dimensión "media móvil 2024: 68,7";
  año = penúltimo con dato (2024, no 2025); a 1280 todo en un renglón (mm junto al trend); a 720
  la media móvil baja sola (mmTop > trendTop) sin overflow. En dimensión NO hay GSE en la
  cabecera (solo media móvil), igual que indicador.

### Fase 3 — Tooltip por año enriquecido
- **Qué:** `BarrasAnio` recibe `gse` (true desde el `.map` de indicadores, ausente desde el de
  dimensiones) y calcula `mmByYear` una vez (mismo `mediaMovil(pts)` que alimenta `mmLine`). El
  tooltip añade: (a) media móvil del año con muestra de trazo si `mmByYear[p.a]!=null`, o
  "sin media móvil (extremo de la serie)" atenuado si no; (b) solo si `gse && p.difgru!=null`,
  "vs GSE: {▲/▼/=} {fmtSigned(difgru)} {· sig./· n.s.}" con color por `sigdifgru`
  (de/al/st-neutro).
- **Por qué:** el grano se distingue por el flag `gse` (cambio quirúrgico de firma); la
  condicionalidad `p.difgru!=null` evita inventar GSE en años suprimidos (2014-2023) o en
  dimensión.
- **Verificación:** ver §3.

---

## 3. Evidencia de render (viewport 1280, RBD 1692, vista histórica)

- **Cabecera indicador (Autoestima):** "media móvil 2024: 72,3" con muestra de línea color
  `rgb(56,88,163)` = `#3858A3` (--ic); junto a "vs 2024: = -1 · n.s." del HistTrend, mismo renglón.
- **Cabecera dimensión (Autopercepción…):** "media móvil 2024: 68,7", `--fs-xs`, sin GSE.
- **Tooltip indicador interior (2024):** `74 (0–100)` + trazo `#3858A3` "media móvil: 72,3" +
  "vs GSE: ▼ -1 · n.s." (st-neutro).
- **Tooltip indicador extremo (2025*):** "año más reciente con dato" + "sin media móvil
  (extremo de la serie)" (atenuado) + "vs GSE: ▼ -3 · n.s.".
- **Tooltip dimensión interior (2024):** trazo `#35549b` (tono dim) "media móvil: 68,7" —
  **SIN línea vs GSE**.
- **flex-wrap:** a 720px la media móvil baja sola al renglón siguiente, sin overflow horizontal.
- **0 errores de consola**; tildes sin mojibake (4°, móvil, académica).

---

## 4. Spot-check del cálculo (Fase 5d)

Indicador Autoestima, RBD 1692. Últimos años con dato: 2023 = 70, 2024 = 74, 2025 = 73. La media
móvil vigente se ancla al PENÚLTIMO con dato (2024) y promedia los tres últimos con dato:
`(70 + 74 + 73) / 3 = 217 / 3 = 72,33…` → `fmt` (1 decimal, es-CL) = **"72,3"**. Coincide
exactamente con lo mostrado en cabecera ("media móvil 2024: 72,3") y tooltip ("media móvil: 72,3").

---

## 5. Verificación de invariantes 🔒

| Invariante | Resultado | Evidencia |
|-----------|-----------|-----------|
| `idps_largo.parquet` md5 `4c764d8c…` intocable | **PASA** | md5 antes y después = `4c764d8c9f0bf70004f8aa52661ae901`. |
| Sin dato vs GSE a nivel DIMENSIÓN | **PASA** | `dimOf` no trae difgru → `serieEje` lo deja `null`; el tooltip de dimensión NO muestra línea GSE (verificado). El flag `gse` solo se pasa desde el `.map` de indicadores. |
| Media móvil vigente = último elemento de `mediaMovil(pts)` = penúltimo año con dato | **PASA** | Cabecera muestra "media móvil 2024" (no 2025); spot-check §4 reproduce el valor. SIEMPRE etiquetada con su año. |
| NO deploy a `docs/`; commit path-scoped | **PASA** | `git status docs/` vacío; commit toca solo template + build. |
| Payload byte-idéntico (todo es render) | **PASA** | `cmp` JSON nuevo vs `docs/index.html` baseline = 0 bytes distintos (ni la fecha difiere; baseline ya de hoy). |
| Bug s7-1 (sin `*/` interno en comentario CSS) | **PASA** | El comentario nuevo de `.mm-head` solo tiene el cierre real. |

---

## 6. Pendientes

- Ninguno técnico abierto en este encargo. Build local listo para el gate visual del titular;
  `docs/` y push pendientes de su decisión.
