# Log — Ajustes de presentación del motor IDPS (sesión 14)

> Encargo: `50_documentacion/activa/encargos/encargo_ajustes_motor_s14.md`. 4 ajustes de
> PRESENTACIÓN del motor `35` + regeneración + verificación censal de fidelidad +
> panel adversarial. Ninguno toca el dato. Fecha: 2026-06-22.
> Parquet md5 `4c764d8c9f0bf70004f8aa52661ae901` (inicio == fin).

## 1. Resumen y veredicto

**ÉXITO — los 4 ajustes implementados, regenerados y verificados.** Fidelidad
censal parquet→sitio con redondeo entero: **mismatch = 0** sobre 2,9 M celdas.
Panel adversarial **3/3 PASA**. Universo 9.136 intacto. Parquet intocado. **No se
desplegó (push)**: fuera del alcance del encargo; queda para decisión del titular.

## 2. Inventario de commits por fase

| Fase | Commit | Mensaje |
|---|---|---|
| 1 — Decimales→entero | `b90ebd8` | style(motor): puntajes y niveles a entero en presentacion (s14) |
| 2 — Recorte de eje por familia | `5cd8465` | feat(motor): recorte de eje por familia, elimina anios sin dato sistemico (s14) |
| 3 — Borde por dimensión | `a79346a` | style(motor): borde por dimension con color del indicador (s14) |
| 4 — Espaciado establecimiento | `756b464` | style(motor): igualar espaciado header/ficha-explain en pestana establecimiento (s14) |
| 5 — Regenerar build | `5a311de` | build(motor): regenera docs/index.html con ajustes de presentacion s14 |
| Log | (este, docs() aparte) | docs(motor): log ajustes presentacion s14 |

## 3. Cambios: causa / efecto / verificación

### FASE 1 — Decimales a entero
- **Causa/efecto:** `35` serializaba `prom` (ind/dim) y `bajo/medio/alto` (niv) con
  `round(.,1)`; pasa a `round(.,0)` (4 líneas, L359/364/370/371). Decisión de
  presentación (decimales nativos auditados; ver log de auditoría 20260622).
- **Template:** NO requirió cambio. `fmt` usa `toLocaleString(maximumFractionDigits:1)`
  (no `toFixed`), que muestra enteros sin decimal. `fmtSigned` (dif/sig) intacto.
- **Verificación:** build `enteros=TRUE` en las 3 familias; visual: `ybar-val` =
  `72,70,77,69,…` sin decimales (`anyDecimal:false`).

### FASE 2 — Recorte de eje por familia
- **Causa/efecto:** el eje histórico era único por grado (derivado del roster =
  indicador), así dimensión/niveles mostraban "años fantasma" al frente. Ahora `35`
  calcula `meta.primer_anio_familia` DERIVADO del dato (columna correcta por familia:
  niveles usa `niv_bajo_por`), y el template recorta el eje de cada panel con el
  helper `ejeFam(fam)` (filtra `agno >= primer_anio_familia[fam]`); aplicado a las
  series de indicador y dimensión en la Vista histórica. Solo recorta el FRENTE; los
  huecos internos (pandemia/no_eval/sin-dato del EE) se conservan.
- **Niveles:** no tiene serie temporal (es distribución en la Vista actual); su
  `primer_anio_familia=2023` queda embebido por completitud, sin efecto de render hoy.
- **Verificación:** `primer_anio_familia: ind=2014 dim=2018 niv=2023` (mensaje del
  generador y meta del JSON). Visual: panel indicador años 2014→2025; panel dimensión
  años **2018→2025** (sin 2014-2017). Censo: build dim sin filas 2014-2017, niv sin <2023.

### FASE 3 — Borde por dimensión
- **Causa/efecto:** regla CSS nueva `.hist-dim{border-left:3px solid var(--ic,var(--azul));
  padding-left:11px;}`. `var(--ic)` se hereda de `.hist-ind` (color del indicador padre,
  paleta s14). Separa cada dimensión para que las barras por año no se lean como continuo.
- **Verificación:** computado `border-left: 3px solid rgb(56,88,163)` = `#3858A3`
  (Autoestima, ind1). Consume la paleta, no la redefine (🔒5).

### FASE 4 — Espaciado pestaña establecimiento
- **Causa/efecto:** la pestaña establecimiento tenía el header azul (`.ficha-bar`)
  pegado al buscador/explicación: `.ficha-bar` sin `margin-bottom`, radio top-only
  (diseño "conectado a `.ficha-card`" que el buscador `.picker-bar` interpuesto ya
  rompía). Se iguala a la pestaña territorial (`.pan-bar`): `.ficha-bar` → banner
  autónomo (radio completo + `margin-bottom:16px`); `.ficha-card` → tarjeta limpia
  (borde completo + radio completo). CSS puro.
- **Verificación:** computado `.ficha-bar margin-bottom:16px`, `border-radius:9px/9px`;
  `.ficha-card border-top:1px solid`, `radius:9px`. Coincide con `.pan-bar` (16px).

### FASE 5 — Regeneración y verificación
- `run_all(only=35)` OK en 3,4 s; `40_salidas/motor_idps.html` → `docs/index.html`
  (md5 `e166ef6f5a9587b3659ab06f3a9f9f5f`; peso 5,0 MB, bajó porque los enteros
  comprimen mejor). md5 parquet antes==después.

## 4. Verificación de invariantes (🔒)

| 🔒 | Invariante | Resultado | Evidencia |
|---|---|---|---|
| 1 | Parquet no se toca | **PASA** | md5 inicio==fin `4c764d8c…`; `35` solo lo lee |
| 2 | Fidelidad censal (build==round(parquet,0)) | **PASA** | mismatch=0: prom ind 366.384 + dim 557.898 + niv 3×662.514 = **2.911.824 celdas, 0 discrepancias**, todo entero; dif/sigdif/difgru/sigdifgru sin cambio |
| 3 | Universo 9.136 | **PASA** | establecimientos=9.136 (fantasma rbd=NA excluido, H-FID-1) |
| 4 | Lógica metodológica intocable | **PASA** | Panel C: `Ancla` (difgru/sigdifgru, dif/sigdif), `serieEje`, `indOf/dimOf/nivOf` idénticos a `cf719aa`; solo cambió el ARGUMENTO del eje |
| 5 | Paleta s14 intacta | **PASA** | borde usa `var(--ic)` (consume, no redefine); hex sin cambio |
| 6 | Sin agregación territorial | **PASA** | ningún ajuste introduce cálculo agregado; todo presentación por EE |

## 5. Panel adversarial (§5) — 3 agentes, código propio, solo lectura

- **A (fidelidad de redondeo):** **PASA**. Decode propio (atob único, zlib 0x78,
  `memDecompress`); censo 2.911.824 celdas, 0 mismatch, 0 solo-build/solo-parquet,
  todos enteros; md5 confirmado.
- **B (eje por familia):** **PASA**. `primer_anio_familia` derivado del parquet
  (2014/2018/2023) == meta embebido; build dim sin 2014-2017, niv sin <2023, ind desde 2014.
- **C (no-regresión metodológica):** **PASA**. Diff del template = exactamente los 4
  hunks intencionales; columnas de comparación (`difgru/sigdifgru/dif/sigdif`) y lectores
  idénticos. Anotó (correctamente) que el redondeo a entero de FASE 1 es presentación
  de cifras mostradas, no de comparación — dentro del invariante.

## 6. Lo que costó (honesto)

- **FASE 4** fue la menos obvia: las líneas citadas en el encargo se habían desplazado
  (cambios de s13), y la estructura real era `header → buscador (.picker-bar) → card`,
  no `header → explain`. El "pegado" venía de `.picker-bar` con `margin-top:0` y
  `.ficha-bar` sin `margin-bottom`; el diseño "header conectado a la tarjeta" ya estaba
  roto por el buscador interpuesto. La solución (banner autónomo) es coherente con la
  pestaña territorial, pero implicó tocar 2 reglas, no 1.
- **Verificación visual:** `preview_screenshot` produjo tiras finas inutilizables para
  esta página (SVG `width:100%` + altura enorme → aspect ratio extremo). La verificación
  visual se hizo por **inspección del DOM y estilos computados** (años por familia,
  enteros, `border-left`, `margin-bottom`), más rigurosa que un JPEG; 0 errores de consola.

## 7. Estado de cifras y md5

- `idps_largo.parquet`: `4c764d8c9f0bf70004f8aa52661ae901` (inicio == fin, 🔒1).
- `docs/index.html` == `40_salidas/motor_idps.html`: `e166ef6f5a9587b3659ab06f3a9f9f5f`.
- Ninguna cifra cambió salvo el redondeo intencional 1dp→entero; comparaciones intactas.

## 8. Pendientes / `# REVISAR` / notas para el revisor

- **No se desplegó (push):** el encargo no lo pide; los 6 commits quedan LOCALES para
  tu revisión. Si apruebas, `git push origin main` actualiza Pages.
- **Niveles sin serie temporal:** `primer_anio_familia.niveles=2023` está embebido pero
  hoy no recorta nada visible (niveles es distribución en la Vista actual). Si en el
  futuro se añade una serie temporal de niveles, el recorte ya está listo.
- **`.ficha-bar` como banner autónomo:** revisa visualmente que el nuevo espaciado te
  convence (verificado por estilos computados; igual a `.pan-bar`).
- El working tree tiene cambios ajenos a este encargo (suite/, .gitignore, SETTINGS,
  snapshots de estructura, encargos) que NO toqué; son del cierre de sesión.
