# Log — Integración del histórico IDPS 2014-2019 al pipeline (P5, fase 3)

> Fecha: 2026-06-21 · Encargo: `50_documentacion/activa/encargos/encargo_claude_code_idps_integracion_historico.md`
> Ejecutor: Claude Code (Opus). Arquitectura (a): un solo `idps_largo.parquet`.
> **NO se hizo push** (el titular revisa, valida con el motor 35 y decide push y cierre).

## 1. Resumen

Se extendió `30_procesamiento/34_leer_normalizar_idps.R` para leer el histórico ancho
2014-2019 de `20_insumos/historico/`, homologarlo al esquema canónico largo y fundirlo
en el mismo `idps_largo.parquet`. El parquet pasa de **2022-2025 (1.485.103 filas)** a
**2014→2025 (2.362.447 filas)**. El histórico aporta **613.809 filas** (indicador
2014-2019 + dimensión 2018); el resto del crecimiento (263.535) es el **4b2024** que `34`
ahora ingiere de la raíz (promovido en la fase 2).

**Invariante central cumplido:** ninguna cifra IDPS del dato moderno cambió. Verificación
por **medidas/ids/GSE** (no byte-identidad): las 1.485.103 filas modernas tienen sus
columnas de medida idénticas al respaldo. El histórico, además, **no altera ninguna fila
moderna** (probado: `full[moderno]` == baseline moderno-only, 0 diferencias).

## 2. Cambios en `34` (qué bloques y por qué)

- **Bloque 1 (manifiesto):** se agregó un segundo `dir_ls` sobre `20_insumos/historico/`
  con patrón `PATRON_HISTORICO = ^idps(2m|4b|6b|8b)(\d{4})_rbd_historico$` (incluye `.xls`).
  El manifiesto moderno (raíz) queda **idéntico**. Discriminador `regimen` (moderno/historico).
  Hook `getOption("idps_solo_moderno")` (default FALSE) para aislar el moderno en verificación.
- **Bloque 3b (lector histórico nuevo `leer_un_archivo_historico`):** lee el ancho, **pivota
  a largo** las columnas `ind_{xx}`/`ind_{xx}_rbd` → familia indicador (id vía `CW_INDICADOR`)
  y —solo 2018— `dim_{ind}_{dim}_rbd` → familia dimensión (id del **par medio** vía
  `CW_DIMENSION`, `id_indicador = id_dimension %/% 10`). **Reusa `map_codigo`** (aborta si un
  sufijo no calza; ningún mapeo nuevo). Convierte 2017 texto→código (`cod_grupo`/`cod_depe2`
  con los inversos de `GSE_LABELS`/`DEPENDENCIAS`), mapea geo divergente 2018
  (`nom_regi_n`→`nom_reg_rbd`, `nom_comuna`→`nom_com_rbd`), y proyecta NA en lo que el
  histórico no trae (significancia, niveles, subdimensión). Emite `COLS_CANONICAS`, mismos
  tipos que el moderno.
- **Bloque 4 (iterar):** despacho por `regimen` (lector moderno vs histórico) + `bind_rows`.
- **Bloque 5.1/5.3 (atributos) — AJUSTE NECESARIO:** `attr_estab` ahora es **régimen-aware**.
  Las filas modernas (agno≥2022) toman su geo/depe del indicador **moderno** más reciente;
  las históricas, del indicador más reciente **global**. Sin esto, un RBD con dimensión/niveles
  modernos pero sin indicador moderno recibía geo/depe del histórico → **alteraba 657 filas
  modernas** (lo detectó la verificación). Con el ajuste, el histórico no toca ninguna fila
  moderna y un RBD solo-histórico igual recibe su geo histórica (Fase B.4). `mapa_gse` (GSE por
  rbd×agno×grado) no requirió cambio.
- **Bloque 7 (escritura):** ruta de salida sobreescribible vía `getOption("idps_largo_out")`
  (default = `idps_largo.parquet`) para construir el parquet nuevo en temporal antes de promover.
- Bloques 2 y 6 (helpers y validaciones) **sin cambios**: las validaciones del Bloque 6 pasan
  sobre moderno + histórico sin relajarse.

## 3. DRY_RUN, verificación y promoción

1. **Respaldo** del parquet actual a `_archivo/20260621/idps_largo_pre_historico.parquet`
   (md5 `50d9de4f1fc80259d29f499cdf46d9e1`, = control).
2. **Construcción en temporal** (`idps_largo_nuevo.parquet`), `idps_largo.parquet` intacto.
3. **Verificación (medidas IDPS):** sobre las 1.485.103 filas modernas emparejadas por llave
   (excluye 4b2024, que es adición nueva), **0 diferencias** en columnas de medida/id/GSE
   (`prom, dif, sigdif, difgru, sigdifgru, mdif, mdifgru, niv_*, id_*, cod_grupo`).
4. **Histórico no altera el moderno:** `full[moderno]` vs baseline moderno-only = **0/0**.
5. **Checkpoint del titular (3 verificaciones, aprobado):** (a) histórico coherente; (b)
   `nom_reg_rbd` solo tildes, 0 reasignaciones de región; (c) 45 RBD recanonizan geo/depe,
   todos en 4b2024, 0 cambio de cifra IDPS.
6. **Promoción** (autorizada): `idps_largo_nuevo.parquet` → `idps_largo.parquet` (atómica).
   Respaldo pre-histórico conservado en `_archivo/`.

## 4. Dos cambios de ATRIBUTO del dato moderno, ajenos al histórico (registro explícito)

> Para que el cierre y sesiones futuras no se sorprendan: el parquet nuevo difiere del
> anterior, en el rango 2022-2025, en exactamente dos cosas — **ninguna es una cifra IDPS
> y ninguna proviene del histórico**:

1. **Tildes de `NOMBRES_REGION` (corrección rezagada de la sesión 6).** En la sesión 6 se
   tildaron las etiquetas de región (`Tarapaca→Tarapacá`, `Valparaiso→Valparaíso`,
   `Biobio→Biobío`, `La Araucania→La Araucanía`, `Aysen→Aysén`, `Los Rios→Los Ríos`,
   `Nuble→Ñuble`) pero **no se regeneró `idps_largo`** (decisión "idps_largo intacto"), así que
   el config y el parquet quedaron **desincronizados**. Al regenerar `34` ahora, `nom_reg_rbd`
   se sincroniza con el config (588.286 filas, mismas regiones por `cod_reg_rbd`; 0
   reasignaciones). Es etiqueta de presentación; ninguna cifra cambia.
2. **Geo/depe de 45 RBD por el 4b2024 (fase 2).** Al ingerir el 4b2024 (activo promovido en la
   fase 2), 45 establecimientos que aparecen en 4b2024 actualizan su geo/dependencia canónica
   a su registro más reciente (regla "dependencia vigente a toda la serie", Bloque 5). Casos:
   RBD que no tenían indicador moderno (geo/depe NA → su valor 2024), y RBD cuya dependencia
   pasó de Municipal a SLEP reflejando el traspaso. Los 45 están en 4b2024; **0 cambio de cifra**.

Ambos efectos son inevitables en cualquier re-run de `34` y no dependen del histórico.

## 5. Cobertura final (grado × año × familia)

`idps_largo.parquet`: **2.362.447 filas**, agno **2014→2025** (hueco 2020-2021 ausente).
- **Indicador:** todo 2014-2025 (grados según disponibilidad).
- **Dimensión:** 2018 (histórico) + 2022-2025 (moderno). Cero dimensión histórica fuera de 2018.
- **Niveles:** solo 2023-2025 (moderno). Cero en el histórico.
- **GSE** NA en 2014-2016 (supresión legítima); presente 2017-2019. **Significancia/subdimensión/
  niveles** NA en todo el histórico.

## 6. Panel adversarial (§6) — veredicto: **4/4 PASA**

4 agentes read-only, código R propio, `LC_ALL=en_US.UTF-8`, contra el respaldo y los xlsx.

| dimensión | veredicto | evidencia |
|---|---|---|
| 1 · No-alteración de **MEDIDAS** IDPS 2022-2025 | **PASA** | 1.485.103 filas modernas emparejadas 1:1 por llave (NA==NA); **0 diferencias** en las 17 columnas medida/id/GSE; `identical()` bit-idéntico (max\|diff\| prom = 0). 263.535 filas 4b2024 = adiciones nuevas (ausentes del respaldo). nom_reg_rbd (589.122) y geo/depe (45 RBD, 1.650 filas) cambian como atributo aprobado, sin tocar medidas. |
| 2 · Integridad histórico vs xlsx ancho | **PASA** | reconciliación **exhaustiva** (no muestral) de **613.809 celdas** (419.428 indicador + 194.381 dimensión 2018): 0 mismatch, 0 dato perdido, 0 fila espuria. El pivote ancho→largo no barajó valores (`dim_cc_as_rbd`→id_dimension 23, prom idéntico). |
| 3 · Mapeo de ids por crosswalk | **PASA** | `id_indicador ∈ 1:4`; `id_dimension` solo 2018, coherencia decena 100%; los 11 sufijos de dimensión mapean al id correcto; `id_subdimension` NA en todo el histórico. |
| 4 · Cobertura y huecos | **PASA** | matriz grado×año×familia exacta, reconcilia 1:1 con los 18 xlsx; sin 2020-2021; dimensión histórica solo 2018; niveles/subdim/significancia NA; GSE NA en 2014-2016. |

Sin discrepancias → no hubo que restaurar. (Dim2 documentó una auto-corrección del propio
auditor: un shadowing de `grado` en su harness inicial dio falsos positivos; corregido,
cuadró a 0.)

## 7. Invariantes 🔒 (PASA/FALLA)

| invariante | estado |
|---|---|
| Dato moderno: 0 cifras IDPS cambiadas (medidas/ids/GSE 2022-2025) | PASA (panel Dim1: 0/1.485.103) |
| El histórico no altera ninguna fila moderna (full[moderno]==moderno-only) | PASA (0/0) |
| Conservación: NA donde el histórico no trae (signif./niveles/subdim; GSE 2014-2016) | PASA |
| Lee, no deriva (prom históricos leídos y pivotados, no calculados) | PASA |
| Llaves character; bind_rows sin coerción | PASA (tipos idénticos al moderno) |
| Mapeo reusa `CW_INDICADOR`/`CW_DIMENSION` (map_codigo aborta si no calza) | PASA |
| Solo se tocó `34` (no 33/35/10_configuracion/motor) | PASA |
| Respaldo del parquet anterior en `_archivo/` | PASA |
| Validaciones Bloque 6 sin relajar | PASA |

md5 parquet: anterior `50d9de4f1fc80259d29f499cdf46d9e1` → nuevo
`4c764d8c9f0bf70004f8aa52661ae901` (distinto, esperado: ahora tiene histórico + 4b2024 +
tildes).

## 8. Notas para el revisor

- **Validación con el motor 35:** `35` filtra a 4b/2m y re-deriva nombres de región/geo desde
  el directorio público y `NOMBRES_REGION` al serializar (regla de presentación), así que el
  cambio de `nom_reg_rbd` en el parquet no debería alterar el render; el motor hoy muestra
  2022-2025 (la vista histórica extendida es trabajo de motor, fuera de esta fase).
- **`.xls` 2014-2016** se leyeron sin convertir (conservación). El histórico sigue invisible
  para el motor salvo que `35` se extienda (fuera de alcance).
- Respaldo conservado hasta tu validación (no se borra en este encargo).

## 9. Commits (sin push)

- `feat(34): leer e integrar historico IDPS 2014-2019 (indicador + dim 2018) (P5 fase 3)`
- `data(idps): regenerar idps_largo con serie 2014-2025 (P5 fase 3)`
- `docs(idps): log de integracion del historico IDPS (P5 fase 3)`
