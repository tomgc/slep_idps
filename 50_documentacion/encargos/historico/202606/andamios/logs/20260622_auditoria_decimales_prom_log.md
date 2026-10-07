# Auditoría de decimales en `prom` — ¿nativos de la Agencia o derivados? (solo lectura)

> Diagnóstico de procedencia de los decimales que el motor muestra en los puntajes.
> SOLO LECTURA: no se modificó, regeneró ni desplegó nada. Sin commitear.
> Fecha: 2026-06-22. Parquet md5 `4c764d8c9f0bf70004f8aa52661ae901` (intacto).
> Build contrastado: `docs/index.html` md5 `27679407577fd43f1d8a53806168e1f8`.

## Veredicto

**Los decimales son NATIVOS del dato de la Agencia (leídos, no derivados).** El
pipeline de lectura (`34`) escribe `prom` **verbatim** desde el xlsx (única
transformación: coma→punto del locale chileno; sin `round`, sin `mutate`, sin
cálculo). La ÚNICA transformación numérica de `prom` en todo el flujo ocurre en la
capa de **presentación** (`35`), que serializa `round(prom, 1)`. Como **ningún**
valor crudo tiene exactamente 1 decimal, la cifra de 1 decimal en pantalla es el
redondeo de un valor **real de la Agencia** (entero o de precisión completa), no un
decimal inventado por el pipeline.

## Paso 1 — Distribución de decimales en `prom` (parquet, ind+dim)

| familia | n | con_decimal | % | min | max | max_dec |
|---|---|---|---|---|---|---|
| dimension | 746.499 | 187.956 | 25,2 % | 0 | 100 | 14 |
| indicador | 612.728 | 157.024 | 25,6 % | 4,002942 | 100 | 14 |

**Distribución granular del nº de decimales (repr. `as.character`):**

| ndec | n | | ndec | n |
|---|---|---|---|---|
| **0 (entero)** | **1.014.247** | | 10 | 302 |
| **1** | **0** | | 11 | 3.097 |
| 5 | 2 | | 12 | 32.891 |
| 6 | 17 | | 13 | 284.841 |
| 7 | 202 | | 14 | 9 |
| 8 | 2.093 | | | |
| 9 | 21.526 | | | |

→ **Bimodal:** ~75 % enteros exactos, ~25 % cola larga (precisión doble IEEE-754).
**Cero** valores con 1 (ni 2/3/4) decimales. Firma de "entero o full-precision",
no de "redondeado a N decimales por la fuente".

## Paso 2 — ¿`34` transforma `prom`? **NO** (lee, no deriva)

`prom` se lee con `col_o_na(df, "prom", "num", n)` (moderno L266; histórico L349/364),
y `col_o_na` tipo `"num"` aplica **solo** `to_num`:

```r
to_num <- function(x) as.numeric(gsub(",", ".", as.character(x), fixed = TRUE))  # L150-152
col_o_na(... "num") -> to_num(x)                                                  # L161
```

`to_num` normaliza la coma decimal y castea a numérico — **no redondea ni deriva**.
Los `round()` de `34` son ajenos a `prom`: `as.integer(round(...))` para IDs (L162,
L188) y `round(100*mean(is.na(prom)),1)` para un **% de cobertura NA** (L535-536, no
toca valores). Principio documentado en cabecera (L33: "Lee, no deriva: prom de
indicador y de dimensión son [del crudo]"). **`prom` se escribe tal cual se lee.**

## Paso 3 — Rango y forma

- Rango `[0, 100]`; **0** valores fuera de 0–100.
- Máx. decimales del crudo: **14** (precisión doble completa).
- 10 ejemplos reales con decimal (parquet, sin redondear), todos 2m/2017/indicador:
  `72.6990364470287`, `71.8171460245620`, `75.4978198925303`, `68.9865720674299`,
  `77.2426431461509`, `66.7072485747668`, `76.6866721195511`, `74.7650351642347`,
  `76.5542988656801`, `77.1328301036498`. → valores de precisión completa, nativos.

## Paso 4 — Contraste build desplegado vs `round(parquet, 1)`

- **Muestra aleatoria 200 celdas (seed 42):** build == `round(parquet,1)` en **200/200**
  (incluye NA==NA).
- **Censo completo (ind+dim, 4b/2m): 885.486 celdas comparadas, `mismatch = 0`.**
- Único "solo-parquet": **4 celdas**, todas **`rbd=NA` (4b/2017/indicador)** = el
  establecimiento "fantasma" que `35` excluye por diseño (fix H-FID-1, sesión previa).
  No es discrepancia de cifra; es exclusión deliberada. `solo-build = 0`.

→ El build muestra exactamente `round(prom_nativo, 1)`. La capa que introduce el
redondeo a 1 decimal es `35` (presentación), no `34` (lectura).

## Cierre

Diagnóstico de solo lectura. Parquet, generador, template y `docs/` intactos
(md5 parquet inicio==fin). Conclusión para validación externa: **la cifra con 1
decimal del motor es el redondeo a 1 decimal del puntaje real publicado por la
Agencia; el pipeline lo lee verbatim y solo lo redondea al mostrarlo.**
