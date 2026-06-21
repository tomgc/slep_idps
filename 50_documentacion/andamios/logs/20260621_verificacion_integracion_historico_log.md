# Log — Verificación adversarial de la integración histórica IDPS (sesión 11)

> Fecha: 2026-06-21 · Encargo: `50_documentacion/activa/encargo_claude_code_idps_verificacion_integracion_historico.md`
> Naturaleza: **auditoría READ-ONLY** del `idps_largo.parquet` integrado en la sesión 10 (P5).
> Ejecutor: Claude Code (Opus). **Sin cambios de datos ni de código; sin push; sin Pages.**

## 1. Resumen

Panel adversarial de 5 dimensiones (cobertura, NA legítimo, dato-moderno-intacto, integridad
estructural, spot-check contra crudo) re-derivado con **código independiente** (sin las
funciones de `34`), por dos vías paralelas: (a) un script propio `verificar_*.R` y (b) un panel
de 5 agentes read-only con código R propio (scripts en `/tmp`). **Veredicto: 5/5 PASA, sin
hallazgos.** La integración 2014→2025 es correcta: 0 cifras IDPS modernas alteradas, NA
estructural donde corresponde, cobertura exacta vs los 18 archivos, y 14 celdas ancla trazadas
1:1 desde el crudo. md5 del parquet **idéntico** al inicio y al fin (prueba de read-only).

## 2. Inventario de commits

Ninguno de datos ni de código (encargo read-only). Scripts `verificar_*.R` y `/tmp/*.R`:
efímeros, gitignored, no commiteados. **Este log se deja SIN commitear** para revisión previa
del titular (opción preferida del encargo §7); si se versiona, será como `docs()` aislado.

## 3. Fase 0 — estado real (compuerta)

- md5 `idps_largo.parquet` = `4c764d8c9f0bf70004f8aa52661ae901` == canónico ✓.
- Respaldo `50d9de4f1fc80259d29f499cdf46d9e1` localizado por md5 en
  `_archivo/20260621/idps_largo_pre_historico.parquet` (1.485.103 filas, solo 2022-2025) ✓.
- **P-PUSH:** `HEAD` local == `origin/main` == `aec6d495aa126a2f42c7fe627ce4d8ac1d63ddb7`
  (tras `git fetch`): **sincronizado** ✓.
- 18 datos históricos presentes en `20_insumos/historico/`.

## 4. Dimensiones verificadas

### Dim 1 — Cobertura (verdad 3.1, 3.2) — **PASA**
- Re-derivado: `count(familia, grado, agno)` del parquet + reconciliación contra los 18 archivos.
- **Descomposición exacta:** `2.362.447 = 1.485.103 + 263.535 (4b2024) + 613.809 (histórico)`;
  moderno (2022-2025) = `1.748.638`.
- (grado,agno) histórico = los 18 archivos exactos (`anti_join` 0 extras / 0 faltantes):
  2m 2014-2018, 4b 2014-2018, 6b 2014/15/16/18, 8b 2014/15/17/19.
- `dimension` histórica solo 2018 (2m/4b/6b; **0** en 8b); `niveles` solo 2023-2025 (**0** en
  histórico); **0** filas en 2020-2021.
- El panel reconcilió además las celdas `prom` no-NA vs el crudo: indicador 410.380, dimensión
  189.767 (el resto son placeholders NA de la grilla ancha, no datos espurios).

### Dim 2 — Legitimidad del NA (verdad 3.3) — **PASA**
- Significancia (`dif/sigdif/difgru/sigdifgru/mdif/mdifgru`) = **100% NA** en todo 2014-2019.
- `id_subdimension`, `niv_*_por` = **100% NA** en todo el histórico.
- GSE (`cod_grupo`): **100% NA en 2014-2016** (la columna no existe en el crudo de esos años),
  presente 2017-2019 con NA marginal (**2017 0.3% · 2018 1.3% · 2019 0.1%**, no masivo). El
  patrón reproduce 1:1 el crudo, incluso a nivel RBD (8b2019: 5.960 RBD / 7 NA idénticos).
- Moderno conserva sus medidas (niveles con dato 2023-2025; significancia presente donde toca).

### Dim 3 — El dato moderno no cambió (verdad 3.4) — **PASA** (la fase de riesgo)
- Join del moderno (2022-2025) vs respaldo por la llave (NA==NA con centinela).
- `left_only = 263.535` = **exactamente 4b2024** (0 fuera); `right_only = 0`; `inner = 1.485.103`.
- **Columnas SAGRADAS (17): 0 diferencias**, confirmado por **tres métodos independientes**
  (hash de fila + conteo `!=` col-a-col NA-safe + `anti_join` sobre la tupla sagrada) que
  coinciden, y `max|delta| = 0` bit-exacto en las medidas numéricas.
- **Presentación, acotada y explicada:**
  - `nom_reg_rbd`: 588.286 filas puro-tilde con `cod_reg_rbd` **idéntico** (7 regiones acentuadas;
    0 reasignaciones).
  - geo/depe no-tilde: **~38-45 RBD distintos** (unión según columnas; orden ~45, **no ~657** →
    fix H10-2 completo). Sin cifra IDPS afectada.
  - `cod_reg_rbd`: 836 filas / 27 RBD cambian, **todas NA→código** (relleno de geo faltante desde
    4b2024); **0 reasignaciones región→región**.

### Dim 4 — Integridad estructural (verdad 3.5) — **PASA**
- Jerarquía de ids: **0 violaciones** (`id_dimension %/% 10 == id_indicador`; subdim %/%100 e
  %/%10). No vacua: las 37 combinaciones únicas (familia, ids) calzan 1:1 con el crosswalk.
- Dominios: `id_indicador ∈ 1:4`, `cod_grupo ∈ {1..5,NA}`, `cod_depe2 ∈ {1..4,NA}` — 0 fuera
  (verificado también como string crudo).
- Duplicados de llave: **0** (2.362.447 filas → 2.362.447 claves únicas, dos motores).

### Dim 5 — Spot-check 1:1 contra la fuente cruda — **PASA** (el test más fuerte)
- Pivoteo ancho→largo re-derivado a mano (readxl directo, sin funciones de `34`). **14/14 celdas
  ancla** coinciden 1:1:
  - 6 indicadores 2014-2016 (`prom` == crudo, `cod_grupo` NA): RBD 32/283/210/417/67/168.
  - 6 dimensiones 2018 (`id_dimension` por token medio vía `CW_DIMENSION`, p. ej. `dim_cc_as_rbd`
    → AS → 23; `prom` a precisión flotante completa): RBD 208/496/200/310/929/415.
  - 2 indicadores 2018 de control (`ind_*_rbd`): RBD 18/594.
- NA crudo preservado como NA (RBD 86, `dim_hv_va_rbd` 2018 → `prom` NA, no 0 ni descarte).

## 5. Auditoría de diagnóstico (tabla de hallazgos)

| # | observación | severidad | ¿toca cifra IDPS? | estado |
|---|---|---|---|---|
| — | **Sin hallazgos.** Las 5 dimensiones PASA. | — | — | — |
| obs-1 | 2 cambios de atributo moderno documentados en sesión 10 (tildes de `NOMBRES_REGION` + geo/depe de ~45 RBD por 4b2024), confirmados **acotados y explicados** | informativa | **No** | esperado (H10-1) |
| obs-2 | `cod_reg_rbd` cambia en 27 RBD: todas NA→código (relleno desde 4b2024), 0 reasignaciones | informativa | **No** | dentro del set ~45 (H10-1) |

No hubo bug nuevo. El fix H10-2 (`attr_estab` régimen-aware) se confirma **completo** (~45 RBD,
no ~657). Nada requiere corrección → nada que escalar al titular como tarea nueva.

## 6. Verificación de invariantes 🔒

| invariante | estado | evidencia |
|---|---|---|
| READ-ONLY (md5 inicio==fin) | **PASA** | `4c764d8c…` al inicio y al fin; parquet, código y repo sin cambios |
| Código independiente | **PASA** | script propio + 5 agentes; ningún `source()` de `34` ni sus funciones |
| "Lee, no deriva" (NA legítimo) | **PASA** | 100% NA estructurales donde corresponde; NA reproduce el crudo 1:1 |
| `verificar_*.R` efímeros, no commiteados | **PASA** | gitignored; 0 en `git add` |
| No mutar el repo (no push/Pages/add) | **PASA** | sin commits de datos/código; sin push |
| Gobernanza (RBD, no nombres) | **PASA** | el log ejemplifica solo con RBD |

## 7. Estado de cifras y cierre

- **md5 parquet antes = después = `4c764d8c9f0bf70004f8aa52661ae901`.** Cero escritura.
- Respaldo `50d9de4f…` intacto.
- P-PUSH sincronizado (HEAD == origin/main == `aec6d49`).
- Repo sin cambios de datos/código; este log nuevo queda **sin commitear** para tu revisión.

## 8. Pendientes / # REVISAR

- Ninguno de integración (auditoría limpia). La **vista histórica extendida en el motor 35**
  (mostrar 2014→2025 en la ficha) sigue pendiente como trabajo de motor de una sesión futura —
  fuera del alcance de esta auditoría.

## 9. Notas para el revisor

- Lo que costó: el único punto que exigió desambiguación fue el conteo de RBD con cambio geo/depe
  (38 vs 45 según qué columnas de presentación se unan); ambos están en el orden ~45 esperado,
  lejos del umbral ~657 que indicaría fix incompleto. Las 836 transiciones de `cod_reg_rbd`
  resultaron ser todas NA→código (relleno), no reasignaciones — confirmado por tabla de
  transiciones.
- Nada quedó dudoso: mi re-derivación y el panel coinciden en cada número clave.
