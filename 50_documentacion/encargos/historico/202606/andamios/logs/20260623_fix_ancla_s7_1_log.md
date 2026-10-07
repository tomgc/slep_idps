# Log — Fix Bug s7-1: cierre prematuro de comentario que descartaba .ancla

> Ejecución autónoma del encargo "fix Bug s7-1" (s20). Cambio quirúrgico único.
> Fecha: 2026-06-23. Ejecutor: Claude Code (Opus 4.8). Rama: `main`.
> Archivo tocado: `30_procesamiento/35_motor_template.html` (texto de un comentario).
> **Push NO ejecutado; docs/ NO tocado.** Build local regenerado. Log SIN commitear.

---

## 1. Causa raíz (confirmada)

El comentario CSS de la línea 127 contenía el fragmento `.anchor-row/.ar-*/.anclas`.
La secuencia `*/` dentro de `.ar-*/` **cerraba el comentario prematuramente** (Bug
s7-1): la cola del comentario + la regla `.ancla{}` (línea 129) se fusionaban en una
regla inválida que el navegador descartaba. Resultado: `.ancla` ausente del CSSOM; las
anclas heredaban 14px y perdían su píldora (padding/border-radius/display:flex/gap).
Pre-existente desde el commit `00e567d` (NO de la tipografía).

## 2. Cambio aplicado (solo texto del comentario)

| | Fragmento |
|---|---|
| Antes | `... .anchor-row/.ar-*/.anclas del antiguo AnchorRow). Se` |
| Después | `... .anchor-row/.ar-N/.anclas del antiguo AnchorRow). Se` |

`.ar-*` → `.ar-N` (placeholder de la familia `.ar-`, sin asterisco). Se mantuvo el
estilo de lista separada por `/` y el sentido para un lector humano. NO se usó el
método frágil de "insertar un espacio antes del `/`". La regla `.ancla{}` y todas las
demás reglas CSS quedaron intactas (el token `var(--fs-xs)` de `.ancla` ya estaba
correcto en fuente desde el encargo de tipografía; este fix solo lo vuelve efectivo).

## 3. Verificación

**Unicidad del cierre real:**
- Balance de comentarios en el template: `/*` = 64, `*/` = 64 (antes 64/65; el +1 era
  el cierre prematuro, ahora eliminado).
- Escaneo de `*/` mid-texto en el `<style>`: 0 (los únicos `*/}` restantes son
  comentarios JSX válidos, fuera del CSS).

**`.ancla` rehabilitada (navegador, build regenerado):**
- `reglaAnclaEnCSSOM`: PRESENTE → `font-size:var(--fs-xs)`, `padding:3px 9px`,
  `border-radius:7px`, `display:flex` (antes: `null`).
- Computado del elemento `.ancla`: `font-size:12px` (token `--fs-xs`, antes 14px
  heredado), `padding:3px 9px`, `border-radius:7px`, `display:flex`, `gap:5px` → **la
  píldora está restaurada**.
- `.ancla .k` computa 11px (`--fs-2xs`), sin cambio.

**Ninguna otra regla cambió de estado:** vecinas presentes en el CSSOM — `.ancla .k`
(`var(--fs-2xs)`), `.ancla.al`, `.ancla.de`, `.arr` (`font-weight:800`). Render sin
errores de consola (solo el warning benigno del transpiler Babel CDN, pre-existente).

## 4. Invariantes de datos 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet intocable | **PASA** | md5 `4c764d8c9f0bf70004f8aa52661ae901` sin cambio. |
| Fidelidad censal mismatch 0 | **PASA** | Re-derivación independiente: ind/dim/niv mismatch 0 en todas las columnas (excluido fantasma rbd=NA). |
| Payload byte-idéntico (salvo comentario) | **PASA** | Los 11 bloques de payload `identical()` al build previo; `meta` sin diferencias (ni la fecha). El cambio vive 100% en el texto del comentario CSS. |
| docs/ solo en deploy | **PASA** | `git status docs/` sin cambios. |

## 5. Estado / pendientes

- **Commit local (sin push):** `e9b9885` — `fix(css): corrige cierre prematuro de
  comentario que descartaba .ancla (Bug s7-1)`. `git add` solo del template.
- **Commits locales acumulados sin push** (gate del titular): `bd65261`, `dff5874`
  (tipografía) + `e9b9885` (este fix) = 3.
- **Build local regenerado** (`40_salidas/motor_idps.html`, sin commitear) con `.ancla`
  restaurada, para revisión visual del titular. **docs/ intacto.**
- Pendiente previo aún vivo: `# REVISAR jerarquía .axis-lab.b` (del encargo de
  tipografía). No tocado aquí.
