# Log — Reorganización del universo IDPS (P5, fase 2)

> Fecha: 2026-06-21 · Encargo: `50_documentacion/activa/encargo_claude_code_idps_organizacion.md`
> Ejecutor: Claude Code (Opus). Modo autónomo con compuerta DRY_RUN interna.
> **NO se hizo push** (el titular revisa y valida, incluido correr el pipeline, antes).

## 1. Resumen

Reorganización de filesystem sobre `20_insumos/` (sin tocar el pipeline). Se promovió
el activo único **4b2024** (traspapelado en `historico_2014_2018/4B/`) a la raíz; se
organizó el **histórico real 2014-2019** (18 datos + glosas) en la subcarpeta nueva
`20_insumos/historico/`; se eliminaron **18 duplicados byte-idénticos verificados**; y
se retiró la carpeta `historico_2014_2018/`. Conservación por defecto: **cero pérdida
de dato**; todo lo eliminado tiene gemelo byte-idéntico vivo y/o está en el backup.

El **DRY_RUN cuadró con el plan** (todos los conteos de §4, 0 conservados-sin-gemelo)
antes de pasar a modo real. md5 de `idps_largo.parquet` intacto inicio→fin.

## 2. DRY_RUN vs real (conteos)

| operación | DRY_RUN | real | esperado §4 | estado |
|---|---|---|---|---|
| promover 4b2024 dato | 3 | 3 | 3 | OK |
| promover 4b2024 glosa (hallazgo) | 1 | 1 | (no enumerado) | OK |
| mover histórico 2014-2019 | 18 | 18 | 18 | OK |
| dedup glosas-año (2014-2019) | 6 | 6 | 6 | OK |
| eliminar dup 2024 dato (2m,6b) | 6 | 6 | 6 | OK |
| eliminar dup 2024 glosa (2m,6b) | 2 | 2 | (no enumerado) | OK |
| eliminar dup cubeta B 2022/2023 | 10 | 10 | 10 (7 datos+3 glosas) | OK |
| **conservados sin gemelo (alerta)** | **0** | **0** | 0 | OK |
| limpiar `.DS_Store` | 27 | 27 | — | OK |
| retirar carpetas vacías | 25 | 25 | — | OK |

Compuerta: el modo real (`REORG_REAL=1`) solo se corrió tras confirmar que el DRY_RUN
cuadraba. Backup completo verificado (83==83) antes de la primera mutación.

## 3. Hallazgos relevantes (desviaciones del conteo literal del encargo)

Todos benignos y resueltos por conservación (la regla mecánica: idéntico→elimina,
no-idéntico→conserva+reporta). Ninguno disparó detención (a/b/c/d).

1. **4b2024 GLOSA = activo único.** El encargo enumeró solo los 3 datos de 4b2024.
   En `historico_2014_2018/4B/` había además `idps4b2024_GLOSAS_web_final.xlsx`, **sin
   gemelo** en `auxiliares/` (sí existen las de 2m2024 y 6b2024). Es la misma "lección
   de la fase 1" que el dato 4b2024. Se **promovió** a
   `20_insumos/auxiliares/idps4b2024_GLOSAS_web_final.xlsx` (md5 `f27c47ca`),
   completando el set de glosas 2024 (2m·4b·6b) en `auxiliares/`. NO se borró.
2. **Las 3 subcarpetas 2024 traían glosa.** `2M/` y `6B/` con
   `idps{2m,6b}2024_GLOSAS_web_final.xlsx` byte-idénticas a sus gemelas en
   `auxiliares/` → eliminadas como duplicado. `4B/` = el activo único (punto 1).
3. **Cubeta B: 4 archivos que el censo NO había verificado, ahora probados idénticos.**
   - `idps2m2022_rbd_glosa_pública_final.xlsx` (`87328dc1`) == gemelo raíz (el censo
     decía "no comparable").
   - `idps4b2022_rbd_glosa_pública_final.xlsx` (`80b8258e`) == gemelo raíz ("no
     comparable").
   - `idps4b2023_GLOSAS_rbd_público_final.xlsx` (`4691ad0c`) == gemelo en
     `auxiliares/` (el censo decía "NO está en raíz" — sí está, pero en `auxiliares/`).
   - `idps4b_niveles_final.xlsx` (`8d1edb1a`, nombre no canónico, sin año) == raíz
     `idps4b2023_niveles_final.xlsx` (el censo decía "NO está en raíz" por el desajuste
     de nombre; es el mismo contenido).
4. **Bug de locale corregido (crítico).** Bajo `LC_CTYPE=C`, R en macOS mangla los
   nombres con tilde en NFD (`pública`/`público`) y `md5sum`/`file_exists`/`file_copy`/
   `file_delete` fallan EN SILENCIO. Sin el fix, (a) la verificación de byte-identidad
   de esos 3 archivos habría sido un falso match (riesgo de borrado sin prueba), y
   (b) el modo real no habría podido eliminarlos. Se fija `LC_ALL=en_US.UTF-8` en el
   script y en la invocación. El DRY_RUN atrapó esto antes del modo real.

## 4. 4b2024 promovido (md5)

| archivo (raíz/aux) | md5 |
|---|---|
| `20_insumos/idps4b2024_rbd_final.xlsx` | `6bc03d0e896220fdebca0f8effa8deb1` |
| `20_insumos/idps4b2024_rbd_dim_final.xlsx` | `d095a0acd2acd36d931cdccec81859d4` |
| `20_insumos/idps4b2024_rbd_niveles_final.xlsx` | `ef3bfabfa278e871f4e30ecffc777fb3` |
| `20_insumos/auxiliares/idps4b2024_GLOSAS_web_final.xlsx` | `f27c47ca5cb983a4f4ed7188dfd41736` |

Cobertura 4b en la raíz queda **2022·2023·2024·2025**.

## 5. Histórico organizado

`20_insumos/historico/` — 18 datos `idps{g}{AAAA}_rbd_historico.{xls,xlsx}`:
2014 (2m,4b,6b,8b) · 2015 (2m,4b,6b,8b) · 2016 (2m,4b,6b) · 2017 (2m,4b,8b) ·
2018 (2m,4b,6b) · 2019 (8b). `.xls` 2014-2016 conservados sin convertir (la
conversión es fase 3).
`20_insumos/historico/glosas/` — 6 glosas-año (`idps{AAAA}_rbd_GLOSAS.xlsx`,
2014-2019), deduplicadas desde 18 copias (todas byte-idénticas dentro de cada año).

## 6. Duplicados eliminados (par dup == gemelo vivo, md5)

Cada borrado fue verificado byte-idéntico contra un gemelo VIVO (raíz o auxiliares).

| # | duplicado (en histórico viejo) | gemelo vivo | md5 |
|---|---|---|---|
| 1 | `idps2M2024_rbd_final.xlsx` | raíz `idps2m2024_rbd_final.xlsx` | `8d4e2ca9…` |
| 2 | `idps2M2024_rbd_dim_final.xlsx` | raíz `idps2m2024_rbd_dim_final.xlsx` | `ac13ff61…` |
| 3 | `idps2M2024_rbd_niveles_final.xlsx` | raíz `idps2m2024_rbd_niveles_final.xlsx` | `04088450…` |
| 4 | `idps6B2024_rbd_preliminar.xlsx` | raíz `idps6b2024_rbd_preliminar.xlsx` | `0db6782a…` |
| 5 | `idps6B2024_rbd_dim_preliminar.xlsx` | raíz `idps6b2024_rbd_dim_preliminar.xlsx` | `b05557c1…` |
| 6 | `idps6B2024_rbd_niveles_preliminar.xlsx` | raíz `idps6b2024_rbd_niveles_preliminar.xlsx` | `da8d9a0d…` |
| 7 | `idps2m2024_GLOSAS_web_final.xlsx` | aux `idps2m2024_GLOSAS_web_final.xlsx` | `5b5b8704…` |
| 8 | `idps6b2024_GLOSAS_web_final.xlsx` | aux `idps6b2024_GLOSAS_web_final.xlsx` | `1c47b570…` |
| 9 | `idps2m2022_rbd_dim_final.xlsx` | raíz idem | `3ca584a8…` |
| 10 | `idps2m2022_rbd_final.xlsx` | raíz idem | `1eb3053e…` |
| 11 | `idps2m2022_rbd_glosa_pública_final.xlsx` | raíz idem | `87328dc1…` |
| 12 | `idps4b2022_rbd_dim_final.xlsx` | raíz idem | `afbfd19a…` |
| 13 | `idps4b2022_rbd_final.xlsx` | raíz idem | `ff62f43e…` |
| 14 | `idps4b2022_rbd_glosa_pública_final.xlsx` | raíz idem | `80b8258e…` |
| 15 | `idps4b2023_GLOSAS_rbd_público_final.xlsx` | aux idem | `4691ad0c…` |
| 16 | `idps4b2023_rbd_dim_final.xlsx` | raíz idem | `c46d3d29…` |
| 17 | `idps4b2023_rbd_final.xlsx` | raíz idem | `37203f8e…` |
| 18 | `idps4b_niveles_final.xlsx` | raíz `idps4b2023_niveles_final.xlsx` | `8d1edb1a…` |

Además: las 18 copias de glosas-año del histórico se redujeron a 6 (byte-idénticas
dentro de cada año). 27 `.DS_Store` eliminados.

## 7. Panel adversarial (§6) — veredicto: **4/4 PASA**

4 agentes read-only, cada uno con código R propio (`/tmp/audit_idps*.R`, ejecutados
con `LC_ALL=en_US.UTF-8` para no caer en el bug NFD), contra el backup como verdad.

| dimensión | veredicto | hallazgo clave |
|---|---|---|
| 1 · Integridad / cero pérdida | **PASA** | 0 de 46 md5 únicos del backup faltan en el conjunto vivo; todo recuperable bit-a-bit. Movidos/promovidos casan 18/18, 6/6, 3/3, 1/1 con el backup. |
| 2 · No-borrado de activos | **PASA** | los 18 eliminados tienen gemelo vivo byte-idéntico (lista completa dup→gemelo); 4b2024 promovido e intacto, 0 sin gemelo. |
| 3 · Cobertura post-reorg | **PASA** | `historico/`=18 datos (grilla exacta), `glosas/`=6 (2014-2019), 4b raíz=2022·23·24·25, `historico_2014_2018/` ausente. |
| 4 · Integridad del pipeline | **PASA** | parquet md5 intacto; `git diff HEAD --stat` sobre 00_build.R/10_utils/30_procesamiento = vacío; solo 5 añadidos untracked; `34` ingerirá 4b2024 y deja `historico/` invisible. |

Sin discrepancias → no se restauró del backup. (Nota del panel: las 4 eliminaciones
trackeadas que ve git son snapshots de `50_documentacion/estructura/`, ajenas a esta
reorg y al pipeline.)

## 8. Invariantes 🔒 (PASA/FALLA)

| invariante | estado |
|---|---|
| CONSERVACIÓN (solo dups byte-idénticos + `.DS_Store`) | PASA — 18 dups con gemelo probado, 0 conservados-sin-gemelo |
| COPIAR→VERIFICAR→ELIMINAR | PASA — toda promoción/movimiento copia+md5+borra |
| DRY_RUN PRIMERO | PASA — DRY_RUN cuadró; real solo con `REORG_REAL=1` |
| Pipeline NO se toca | PASA — md5 parquet `50d9de4f1fc80259d29f499cdf46d9e1` intacto; 0 scripts modificados |
| Backup antes del real | PASA — `_archivo/20260621/historico_2014_2018_prereorg/` (83 archivos, verificado 83==83) |
| Registro de cada movimiento | PASA — `_archivo/log_reorganizacion.csv` (98 filas) |

## 9. Notas para el revisor

- **Al correr `run_all()`** (tu validación), `34_leer_normalizar_idps.R` lee
  `20_insumos/*.xlsx` (nivel 1, no recursivo, excluye GLOSAS): **ingerirá ahora el
  4b2024 promovido** (3 archivos) → `idps_largo.parquet` crecerá con 4b2024. **Es el
  efecto deseado de la promoción**, no una violación: esta fase NO corrió el pipeline,
  por eso el parquet en disco quedó byte-idéntico. La subcarpeta `historico/` y los
  `.xls` siguen invisibles para `34` (eso es fase 3).
- **Git:** `historico_2014_2018/` estaba **untracked** (`??`), así que su retiro NO
  produce eliminaciones en git; solo aparecen los AÑADIDOS nuevos. Backups, CSV y el
  script efímero quedan sin versionar (gitignored / `.git/info/exclude`).
- **Observación pre-existente (fuera de alcance, NO tocada):** varios archivos de la
  raíz están trackeados con mayúscula de grado (`idps2M2024…`, `idps6B2024…`,
  `idps4B2025…`) pero en disco están en minúscula — desajuste de case en macOS
  (FS case-insensitive). No lo causó esta reorg ni lo corregí; lo dejo señalado.
- **Backups conservados** hasta tu validación (no se borran en este encargo).

## 10. Commits (sin push)

- `feat(insumos): promover 4b2024 traspapelado a la raiz (P5 fase 2)`
- `feat(insumos): organizar historico IDPS 2014-2019 en subcarpeta (P5 fase 2)`
- `docs(idps): log de reorganizacion del universo IDPS (P5 fase 2)`
