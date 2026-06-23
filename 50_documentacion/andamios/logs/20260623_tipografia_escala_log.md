# Log — Tokenización tipográfica completa (P-TIPOGRAFIA, Ítem 4)

> Ejecución autónoma del encargo "tokenización tipográfica" (s20).
> Fecha: 2026-06-23. Ejecutor: Claude Code (Opus 4.8). Rama: `main`.
> Archivos tocados: `30_procesamiento/35_motor_template.html` (template).
> **Push NO ejecutado; docs/ NO tocado** (deploy es gate del titular). Build
> local regenerado para revisión visual. Log SIN commitear.

---

## 1. Resumen

Se reemplazó la escala de facto (19 valores distintos de font-size, 9px→24px +
3 clamp) por UNA escala de 7 tokens `--fs-*` aplicada a TODAS las declaraciones de
font-size salvo los 3 clamp() del hero. Piso mínimo elevado a 11px. Resultado: cero
px crudos de font-size en el template (fuera de los clamp). Fidelidad censal mismatch
0, parquet intacto, payload byte-idéntico (cambio 100% CSS). **Hallazgo mayor: un bug
PRE-EXISTENTE (ajeno a tipografía) descarta la regla `.ancla` del CSSOM** — reportado
abajo, NO corregido (fuera del scope de font-size; requiere aprobación del titular).

## 2. Inventario de commits

| Fase | Hash | Tipo | Título |
|---|---|---|---|
| 1 | `bd65261` | style | redefine escala de tokens fs a 7 peldanos |
| 2 | `dff5874` | style | migra font-size crudos a tokens de escala |

Push: pendiente. Build local regenerado (no commiteado). docs/ intacto.

## 3. Escala definida (:root)

`--fs-2xs:11px; --fs-xs:12px; --fs-sm:13px; --fs-base:14px; --fs-md:16px; --fs-lg:18px; --fs-h1:22px`
Eliminados: `--fs-display` (estaba muerto, 0 usos) y `--fs-h2` (absorbido a `--fs-lg`;
su único uso, `.modal-title`, repuntado a `--fs-lg` en Fase 1).

## 4. Mapeo aplicado y conteo de usos por token

Migración (perl anclado en `font-size:` y `fontSize:`; los `clamp()` no matchean porque
su patrón es `font-size:clamp(`). 80 px crudos CSS + 6 fontSize inline JSX + 2 D3
`.attr("font-size")` → 88 declaraciones tokenizadas.

| Token | Valor | Mapeo desde | Usos `var()` totales |
|---|---|---|---|
| `--fs-2xs` | 11px | 9px, 9.5px, 10px, 10.5px (+8px D3) | 20 |
| `--fs-xs` | 12px | 11px, 11.5px, var(--fs-xs viejo) | 33 |
| `--fs-sm` | 13px | 12px, 12.5px, var(--fs-sm viejo) | 31 |
| `--fs-base` | 14px | 13px, 13.5px, var(--fs-base viejo) | 22 |
| `--fs-md` | 16px | 14px, 15px | 6 |
| `--fs-lg` | 18px | 16px, 17px, var(--fs-h2 viejo) | 6 |
| `--fs-h1` | 22px | 21px, 24px, var(--fs-h1 viejo) | 5 |

(123 usos `var(--fs-*)` totales; incluye los pre-existentes que ya usaban token.)

**Caso especial — 2 font-size de D3 NO vistos por el inventario read-only** (usaban
`.attr("font-size",…)`, no la sintaxis `font-size:`): en `Radar` (etiquetas y valores
de los ejes). Un atributo SVG `font-size` NO resuelve `var()`; se convirtieron de
`.attr("font-size",…)` a `.style("font-size","var(--fs-…)")` (la propiedad CSS sí
resuelve el token). Etiqueta: `small?"8px":"10.5px"` → `var(--fs-2xs)` (ambas ramas).
Valor: `small?"9.5px":"12px"` → `small?var(--fs-2xs):var(--fs-sm)`. Es el único cambio
de mecanismo JS, acotado a font-size.

## 5. Regresiones de layout detectadas (verificación en navegador)

**NINGUNA regresión de overflow/solape/truncamiento.** Medición de
`scrollWidth/Height > client` en las zonas de riesgo por subir el piso 9→11px:

| Zona | Selector | font-size | Overflow |
|---|---|---|---|
| Ejes D3 | `.axis-lab` | 11px (era 9) | 0 |
| % barras de niveles | `.bar span` | 11px (era 10) | 0/9 |
| Texto radar (tarjetas) | `.card svg text` | 11px (era 9.5 small) | 0/240 |
| Anclas vs GSE | `.ancla .k` | 11px (era 9.5) | 0/25 |
| Tarjeta meta/nom/rbd | `.card .meta`/`.nom`/`.card-rbd` | 11/13/11 | 0/60 c/u |
| Chips alertas | `.chip` | 11px (era 10.5) | 0/62 |
| Definición | `.defn-text` | 14px | 0/15 |
| Dimensión/subdim | `.dim-name`/`.sub-name` | 14/13 | 0/11, 0/22 |

Render sin errores de consola (solo el warning benigno del transpiler Babel CDN,
pre-existente). Tokens resuelven correctamente (`--fs-xs`=12px, etc.); `--fs-h2` y
`--fs-display` ausentes (confirmado en runtime).

## 6. Marcas # REVISAR de jerarquía dejadas en el CSS

- `/* REVISAR jerarquia: .axis-lab.b era 10px vs .axis-lab 9px; ahora ambos
  var(--fs-2xs) ... */` (línea ~206): la variante en negrita `.b` de las etiquetas de
  eje pierde su distinción de tamaño respecto a la base (ambas 11px ahora). Afinable
  por el titular si quiere recuperar la jerarquía (p.ej. dar a `.b` un `--fs-xs`).

## 7. 🔴 BUG PRE-EXISTENTE encontrado (NO corregido — fuera de scope)

**La regla CSS `.ancla{...}` (línea 129) se descarta del CSSOM y NO se aplica.**
- **Causa raíz:** el comentario de las líneas 126–128 contiene `.anchor-row/.ar-*/.anclas`.
  La secuencia `*/` dentro de `.ar-*/` **cierra el comentario prematuramente** (Bug
  s7-1). La cola del comentario + la regla `.ancla{}` se fusionan en una regla inválida
  que el navegador descarta. Las vecinas (`.ancla .k`, `.ancla.al/.de`, `.arr`) parsean
  bien; solo `.ancla` (base) cae.
- **Efecto:** los elementos `.ancla` quedan sin `padding`/`border-radius`/`display:flex`/
  `gap` ni `font-size` propios → heredan 14px (verificado: `padding:0`, `display:block`,
  `reglaAnclaEnCSSOM:null`). Visualmente las anclas conservan el fondo/borde de
  `.ancla.al/.de` pero sin la "píldora" (sin padding ni flex).
- **Antigüedad:** PRE-EXISTENTE desde el commit `00e567d` (sesión del panorama
  territorial). NO lo introdujo la tipografía: la migración solo cambió el valor
  `font-size` *dentro* de una regla que ya estaba descartada. Mi token a `.ancla`
  (`var(--fs-xs)`) es correcto en fuente pero **inerte en runtime** hasta que se corrija
  el comentario.
- **Recomendación (gate del titular):** fix de 1 carácter en el comentario (p. ej.
  `.ar-*` → `.ar-…` o insertar un espacio `.ar-* /.anclas`) para que `*/` no cierre
  antes. Restauraría la píldora de las anclas Y haría efectivo el token de tamaño. NO lo
  apliqué porque está fuera del scope "solo font-size/tokens" del encargo.
- **Verificación de unicidad:** escaneo de `*/` mid-texto en el `<style>` → el único
  cierre prematuro es la línea 127. Ninguna otra regla migrada se ve afectada (balance
  `/*`=64 vs `*/`=65, el +1 es este). Los otros `*/}` son comentarios JSX válidos.

## 8. Verificación de invariantes 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet intocable; fidelidad censal mismatch 0 | **PASA** | md5 `4c764d8c…` igual; censal ind/dim/niv mismatch 0; payload byte-idéntico al build previo (solo CSS). |
| Solo font-size / tokens (cambio quirúrgico B.3) | **PASA** | git diff toca solo font-size/fontSize/--fs-/REVISAR. Cero cambios en color, layout estructural, lógica JS (salvo `.attr`→`.style` de font-size en 2 líneas D3), datos. |
| 3 clamp() del hero intactos | **PASA** | `grep font-size:clamp` = 3, sin cambios. |
| Escala BarrasAnio fija 0–100 | **PASA** | Solo se tocó font-size de labels (vía CSS/`.style`); ninguna lógica de escala/altura del gráfico. |

## 9. Criterio de éxito (B.4)

- Cero px crudos de font-size fuera de los 3 clamp e inherit: **SÍ** (grep de cualquier
  sintaxis = 0).
- Exactamente 7 tokens `--fs-*` en :root; `--fs-display`/`--fs-h2` ausentes: **SÍ**.
- Build regenera sin error; motor renderiza sin errores de consola: **SÍ**.
- Fidelidad censal mismatch 0 (excluido fantasma rbd=NA), parquet md5 sin cambio: **SÍ**.
- Lista de regresiones de layout: **vacía** (0 overflow). Salvo el bug pre-existente de
  `.ancla` (§7), que NO es regresión de tipografía.

## 10. Pendientes

- **Deploy/push:** gate del titular. Build local regenerado, docs/ intacto. Commits
  `bd65261`, `dff5874` locales.
- **# REVISAR jerarquía** `.axis-lab.b` (§6) — afinación visual del titular.
- **🔴 Bug `.ancla` pre-existente** (§7) — requiere decisión del titular: aprobar el
  fix de 1 carácter del comentario (haría efectivo el token de `.ancla` y restauraría
  la píldora). Es un encargo aparte (no font-size).
- Revisión visual del titular de la nueva escala (piso 11px, cuerpo 14px) antes de
  aprobar deploy.
