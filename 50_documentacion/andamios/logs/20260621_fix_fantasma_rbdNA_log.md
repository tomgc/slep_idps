# Log — Fix fantasma rbd=NA (H-FID-1) · slep_idps sesión 12

> Higiene de presentación. Encargo: `50_documentacion/activa/encargos/encargo_claude_code_idps_fix_fantasma.md`.
> Elimina del motor el establecimiento "fantasma" rbd=null que el spot-check de
> P-DISPLAY-FIDELITY detectó alcanzable por el buscador. El parquet NO se toca
> (el fantasma se filtra al SERIALIZAR). Fecha: 2026-06-21.

---

## 1. Qué se filtró y dónde

- **Qué:** las **4 filas con `rbd = NA`** del crudo (todas 4b / indicador / 2017),
  que el generador colapsaba en **1 establecimiento fantasma** (sin nombre/geo/GSE).
  Son una propiedad preexistente de `idps_largo` (H-FID-1).
- **Dónde:** `30_procesamiento/35_generar_motor_html.R`, Bloque 1, **un único punto
  explícito** justo después del filtro a `GRADOS_MOTOR`:
  ```r
  n_fantasma <- sum(is.na(P$rbd))
  P <- dplyr::filter(P, !is.na(.data$rbd))
  message(sprintf("    [H-FID-1] descartadas %d fila(s) con rbd=NA ...", n_fantasma))
  ```
  Condición nombrada (`!is.na(rbd)`), `message()` de transparencia, comentario que
  explica el porqué. El parquet permanece intacto; el dato sigue completo en `idps_largo`.

## 2. Conteo antes / después

| Métrica | Antes | Después |
|---|---|---|
| Establecimientos en JSON | 9137 | **9136** |
| — de ellos con `rbd` null | 1 (fantasma) | **0** |
| Filas array `ind` | 366.388 | **366.384** (−4) |
| Filas array `dim` | 557.898 | 557.898 (=) |
| Filas array `niv` | 662.514 | 662.514 (=) |
| `n_distinct(rbd real)` | 9136 | **9136** (sin cambio) |
| Filas totales (4b/2m) | 1.586.800 | 1.586.796 (−4) |

El generador reporta: `[H-FID-1] descartadas 4 fila(s) con rbd=NA (fantasma 4b/2017); parquet intacto.`

## 3. Verificación (Fase 3 — decode independiente del `docs/index.html` regenerado)

| # | Criterio | Resultado |
|---|---|---|
| C1 | `establecimientos` = 9136, 0 con rbd null | **PASA** |
| C1b | 0 filas rbd null en ind/dim/niv/roster | **PASA** |
| C2 | buscador `ql="null"` → 0 tarjetas (0 totales, 0 rbd-null) | **PASA** |
| C3 | control RBD 10, 4b, ind, 2024 = 83/78/87/74 idéntico | **PASA** |
| C4 | md5 parquet fin == inicio | **PASA** |
| C5 | `n_distinct(rbd real)` parquet == sitio (9136) | **PASA** |

Decode independiente (no reusa funciones de `35`): `atob` único → `memDecompress(gzip)`
→ `fromJSON`. El buscador `ql="null"` da **0 resultados totales** (ni siquiera un
nombre real contiene "null"), confirmando que el fantasma ya no es alcanzable.

## 4. md5 inicio / fin

| Artefacto | md5 | Estado |
|---|---|---|
| `idps_largo.parquet` (inicio y fin) | `4c764d8c9f0bf70004f8aa52661ae901` | **inicio == fin (🔒 intocado)** |
| `docs/index.html` == `40_salidas/motor_idps.html` (nuevo) | `0b7b0b08420a2af985cb92714fc72e42` | build coherente |

## 5. Commits y deploy

- `365667b` — `fix(motor): filtrar establecimiento fantasma rbd=NA del crudo 4b2017` (código).
- `69ad902` — `build(motor): redesplegar sin fantasma rbd=NA` (docs/index.html + motor_idps.html).
- Push a `origin/main` actualiza GitHub Pages (deploy verificado: md5 live == local).

## 6. Alcance / qué NO se hizo

- Parquet intacto (filtro al serializar, no borrado del dato).
- Ningún RBD real filtrado ni alterado (cifras idénticas).
- Cambio aislado del fantasma (sin mezclar con P-DOC, inventarios ni otros).
- El otro hallazgo de P-DISPLAY-FIDELITY (H-FID-2, etiqueta Dependencia del
  directorio, por diseño H6) **no** se toca aquí (queda pendiente-titular).
