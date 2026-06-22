# Log — P-PALETA: adopción de la paleta del folleto de la Agencia

> Encargo: `50_documentacion/activa/encargo_claude_code_idps_paleta.md`.
> Alcance: presentación pura — la paleta de los 4 indicadores IDPS pasa de la
> interna (rojo/amarillo/verde-lima/azul) a la identidad cromática del folleto
> oficial. Ninguna cifra cambia. Fecha: 2026-06-22. Base: HEAD `ce2604d` (cierre s13).

---

## 1. Resumen y veredicto

**ÉXITO — desplegado.** La paleta de indicador adopta los 4 hex del folleto; el
build regenerado es **idéntico al certificado en todo salvo los 4 valores `color`**
del bloque `indicadores` del JSON. Panel adversarial **3/3 PASA**. Fidelidad
parquet→sitio intacta, `md5` del parquet sin cambios, universo 9.136. Deploy a
GitHub Pages confirmado (`live == local`).

| Mapeo confirmado | id | corto | Hex viejo → **nuevo** |
|---|---|---|---|
| Autoestima | 1 | `#EE2D49` → **`#3858A3`** (azul) |
| Convivencia/Clima | 2 | `#FFC92E` → **`#61BDC6`** (turquesa) |
| Participación | 3 | `#9BC93E` → **`#4BA560`** (verde) |
| Hábitos | 4 | `#2A8FD9` → **`#AACB58`** (verde-lima) |

---

## 2. Inventario de commits por fase

| Fase | Commit | Mensaje |
|---|---|---|
| 1 — Generador | `bd8bceb` | feat(paleta): adoptar identidad cromatica del folleto Agencia en INDICADOR_COLORS |
| 2 — Template (token espejo) | `7804fb2` | style(paleta): sincronizar tokens espejo --ind1..4 al folleto |
| 3 — Contraste a11y | `9035a38` | fix(a11y): delinear swatches de indicador claros (WCAG 1.4.11); sin texto sobre fill |
| 4 — Regenerar + redeploy build | `4c41c4a` | build(paleta): regenerar motor con paleta Agencia + recopiar a docs |
| 5 — Decisión documentada | `1d41c17` | docs(decision): registrar adopcion de paleta del folleto Agencia |
| 6 — Deploy | push `ce2604d..1d41c17` | publica Pages (HEAD == origin/main `1d41c17`) |

---

## 3. Cambios sustantivos (causa raíz)

- **`30_procesamiento/35_generar_motor_html.R` L46** — `INDICADOR_COLORS` pasa a
  `c("1"="#3858A3","2"="#61BDC6","3"="#4BA560","4"="#AACB58")`; comentario L41
  actualizado (procedencia: folleto Agencia, no "madre/prototipo"). Es la **fuente
  única runtime**: el `color` por indicador entra al JSON en un solo punto (L116,
  `color = unname(INDICADOR_COLORS[id])`), de donde lo leen radar, `BarrasAnio`,
  dots, swatches de leyenda, tabla territorial y paneles. Cambiar la constante +
  regenerar propaga a todos esos usos; `dimColor()` deriva sus tonos del nuevo color
  madre automáticamente.
- **`30_procesamiento/35_motor_template.html` `:root` L15** — token espejo
  `--ind1..4` sincronizado a los nuevos hex (coherencia documental; ningún CSS lo
  consume vía `var(--ind…)`, no afecta render). Comentario de los tokens de estado
  (L15–18 previas) reescrito: la coincidencia estado↔indicador (`--alerta`/`--bajo`
  con ind1, `--destaca` con ind4) **ya no existe** tras el cambio y es correcto que
  así sea (estado e indicador son ejes semánticos distintos).
- **CSS de realce no-textual** (template, ~L286–292) — hairline
  `box-shadow: inset 0 0 0 1px rgba(35,48,58,.22)` en los swatches/dots de indicador
  (`indp-dot`, `rcard-dot`, `th-sw`, `sw`, `evol-sw`) para dar contraste de borde a
  los 3 fills claros (ind2/3/4) contra el fondo `cream` (WCAG 1.4.11 ≥3:1). No
  altera ningún hex de marca.

---

## 4. Verificación de invariantes (🔒)

| 🔒 | Invariante | Resultado | Evidencia |
|---|---|---|---|
| 1 | Parquet no se toca; `md5` igual | **PASA** | `4c764d8c9f0bf70004f8aa52661ae901` antes y después; el generador solo lo lee |
| 2 | Ninguna CIFRA cambia | **PASA** | Panel: ind/dim/niv (366384/557898/662514) **0 diffs**; neutralizando `color`, el JSON entero es **byte-idéntico** (60.359.353 chars) entre build nuevo y certificado |
| 3 | Solo cambia paleta de INDICADOR | **PASA** | Diff `:root` = solo `--ind1..4` (+ comentario); 10 tokens de estado idénticos y con sus literales (`--alerta:#EE2D49`, `--destaca:#2A8FD9`, `--bajo/--medio/--alto/--coral/--st-neutro/--cmp-year`) |
| 4 | No inventar NA (sig/GSE/geo) | **PASA** (no aplica) | El encargo no toca datos; NA legítimos sin cambio |
| 5 | No desplegar a ciegas | **PASA** | Deploy (Fase 6) ocurrió tras Fases 4–5 verdes y panel 3/3 PASA |

---

## 5. Decisiones de contraste (Fase 3 — WCAG)

Ratio WCAG 2.x de **texto blanco** (`#FFFFFF`) sobre cada fill nuevo (sRGB→lineal,
`(L1+0.05)/(L2+0.05)`), recalculado de forma independiente por el panel:

| id | Fill | Ratio blanco | AA normal (≥4.5) | AA gráfico/grande (≥3.0) |
|---|---|---|---|---|
| 1 | `#3858A3` | **6.79:1** | PASA | PASA |
| 2 | `#61BDC6` | **2.19:1** | FALLA | FALLA |
| 3 | `#4BA560` | **3.07:1** | FALLA | PASA |
| 4 | `#AACB58` | **1.84:1** | FALLA | FALLA |

**Decisión (por umbral, criterio propio):** el fallback blanco→`var(--tinta)`
(`#23303a`) resultó **inaplicable**, porque la inspección del template confirmó que
**ningún elemento con `background = ind.color` lleva texto/icono encima**:

- swatches/dots de indicador (`indp-dot`, `rcard-dot`, `th-sw`, `sw`, leyenda `<i>`)
  son decorativos vacíos; su etiqueta va en un **hermano** en `--tinta`/`--gris`.
- `sbar-fill` (ScoreBar) es div vacío; el puntaje va arriba en `.dim-score`/`--tinta`.
- `ybar-fill` (BarrasAnio) contiene `.ybar-val`, pero está `position:absolute;
  top:-19px` → se pinta **sobre** la barra (fuera del fill), en `--tinta`.
- `.bar` (StackedBar) usa colores de **NIVEL** (`--bajo/--medio/--alto`), no la
  paleta de indicador → fuera de alcance.

Por tanto el único realce necesario fue de **contraste no-textual** (borde): el
hairline `inset 0 0 0 1px rgba(35,48,58,.22)` sobre los 3 fills claros (WCAG 1.4.11
≥3:1 contra `cream`). Fidelidad cromática al folleto preservada (no se oscureció
ningún hex de marca).

---

## 6. Panel adversarial (§5 — obligatorio, 3 agentes, código propio)

| Check | Veredicto | Evidencia |
|---|---|---|
| 1 — Ninguna cifra cambió | **PASA** | Decode node independiente de ambos builds; diff posicional **y** por join (clave `rbd\|grado\|agno\|id`) = 0 en ind/dim/niv; sin huérfanos ni claves duplicadas. Bloque indicadores: única diferencia = `color`; `nonColorDiffs=0`. Neutralizando color → JSON byte-idéntico |
| 2 — Universo intacto | **PASA** | establecimientos = **9.136** en ambos; `n_distinct(rbd)` ind = 9.135 en ambos (diferencia esperada tarjetas vs filas, idéntica entre builds) |
| 3 — Tokens de estado | **PASA** | 10 tokens de estado idénticos build-a-build y vs literales esperados |
| 4 — Contraste + Fase 3 | **PASA** | Ratios recalculados (6.79/2.19/3.07/1.84) coherentes; decisión "sin texto sobre fill" confirmada por enumeración independiente de usos de `ind.color` |

md5: build NUEVO `27679407577fd43f1d8a53806168e1f8`; certificado `0b7b0b08…`
(= `git ce2604d`). El cambio de md5 del HTML es esperado (el blob base64 cambia con
los 4 colores); la fidelidad es de la **cifra decodificada**, no del byte del HTML.

---

## 7. md5 del parquet antes / después

`4c764d8c9f0bf70004f8aa52661ae901` (idéntico). 🔒1 PASA.

---

## 8. Deploy

- Push `ce2604d..1d41c17  main -> main`; HEAD == origin/main `1d41c17`.
- Pages: `live == local == 27679407577fd43f1d8a53806168e1f8` (confirmado).

---

## 9. Pendientes / `# REVISAR` / notas para el revisor

- **Deuda menor declarada (procedencia):** los 4 hex se muestrearon por **moda
  exacta del PNG** del folleto (alta nitidez), no por extracción vectorial del PDF.
  Documentado en `decisiones/20260622_decision_paleta_indicadores.md`. Frase canónica
  ante validación externa: *"la paleta del motor replica la identidad oficial de los
  4 indicadores IDPS de la Agencia de Calidad"*.
- **`# REVISAR` (verificación visual en navegador):** la fidelidad de cifra y los
  ratios WCAG están verificados por código; queda a criterio del titular una pasada
  visual del render (radar, `BarrasAnio`, leyendas, tabla territorial, paneles) para
  confirmar legibilidad de los tonos derivados por `dimColor()` sobre los nuevos
  colores madre (especialmente los fills claros ind2/3/4 con el hairline).
- **No tocado (correcto):** `--cmp-year`/`COLB` (`#C77D3A`, serie de comparación
  temporal); tokens de estado; identidad gobCL (`--azul`/`--cream`/`--foco`).
- **`encargo_claude_code_idps_paleta.md`** queda untracked (se archiva en el cierre
  de sesión, como los demás encargos).

---

## 10. Cierre

Build certificado en color sin alterar ninguna cifra; parquet intocado; deploy en
vivo. El motor mantiene su fidelidad parquet→sitio (P-DISPLAY-FIDELITY) y ahora viste
la identidad cromática oficial de la Agencia.
