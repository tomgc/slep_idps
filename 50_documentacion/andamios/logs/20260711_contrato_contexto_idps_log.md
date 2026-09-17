# Implementación del productor del contrato de contexto v1 (slep_idps)

**Fecha:** 2026-07-11
**Tipo:** andamio congelado (log de implementación). No commitear.
**Rama:** `feat/contrato-contexto` (2 commits locales, SIN push).

---

## 1. Resumen

Se implementó el **productor del contrato de contexto v1** en `slep_idps`: un paso nuevo (`36_exponer_contrato_contexto.R`) que lee `idps_largo.parquet`, filtra a `familia == "indicador"`, deriva las 15 columnas del contrato y expone **solo las filas donde el establecimiento mejora** (por sobre su GSE o respecto de su evaluación anterior) a `40_salidas/publico/contexto_idps.parquet`. Estado final: **39.591 filas × 15 columnas**, los **9 chequeos de validación pasan** (incluida la trazabilidad de la bandera), 2 commits atómicos locales. No se hizo push (revisión del titular pendiente).

---

## 2. Inventario de commits

| Hash | Tipo | Título | Qué hizo |
|---|---|---|---|
| `aca50f7` | feat | productor del contrato de contexto v1 (paso 36) | Nuevo script `36_...R` + contrato `contrato_contexto_v1.md` (congelado) + primer parquet público `contexto_idps.parquet` |
| `19add55` | chore | engancha paso 36 en run_all | Entrada `id=36` en `PASOS` de `00_build.R` + línea en el comentario de cabecera |

Ambos commits son path-scoped (`git add` a rutas exactas). Los cambios preexistentes en el working tree (`40_salidas/motor_idps.html`, archivos de `50_documentacion/estructura/`) **no** se tocaron: no son de este encargo.

---

## 3. Cambios sustantivos

### 3.1 `30_procesamiento/36_exponer_contrato_contexto.R` (nuevo)
- **Qué:** productor del contrato. Estructura canónica del proyecto: header banner, bootstrap (anclaje de raíz + `source` de `10_utils.R`/`10_configuracion.R` si no están cargados, para correr standalone o vía `run_all`), `instalar_si_falta()`, constantes nombradas, helpers, flujo principal.
- **Por qué:** el contrato exige que el filtrado de "qué es mejora" viva en el productor (§1, §2); el consumidor recibe un parquet ya filtrado.
- **Cómo se verificó:** ejecución `run_all(only = 36L)` OK en 0.7 s; luego los 9 chequeos de la Fase 2 (abajo).
- **Decisiones de implementación:**
  - `eje_etiqueta` se toma de `INDICADOR_LABELS` (`10_utils/10_configuracion.R:79-84`), la glosa acentuada canónica del productor (coincide con el estilo del ejemplo §4 del contrato). Guarda: `stop()` si algún `id_indicador` no tiene glosa (eje_etiqueta no admite NA).
  - Booleanos con idioma que **no propaga NA**: `!is.na(x) & x == 1L` (helper `bandera_a_mejora`). Estados 0, -1 y NA → FALSE (§6, 🔒).
  - `desvio_gse <- difgru` se copia tal cual, **incluyendo NA** cuando la magnitud está suprimida pero la bandera es +1 (§6: esas filas SÍ se exponen).
  - Escritura atómica (`write` a `.tmp` → `fs::file_move`), mismo idiom que los pasos 33/34.
  - Guardas internas `stopifnot` antes de escribir (llave única, sin NA en booleanos, sin fila doble-FALSE): fallan ruidosamente si algo se rompe en una corrida futura.

### 3.2 `00_build.R` (modificado)
- **Qué:** una entrada nueva `list(id = 36L, ...)` en `PASOS`, más una línea en el comentario de cabecera.
- **Por qué:** que `run_all()` ejecute el productor tras el pipeline y `run_all(only = 36)` lo aísle. `36` es el siguiente correlativo libre (31–35 existían).
- **Cómo se verificó:** `run_all(only = 36L)` lo selecciona y ejecuta correctamente; los pasos 31–35 quedan "saltados" como se espera.

### 3.3 `50_documentacion/activa/contrato_contexto_v1.md` (versionado)
- Estaba `??` (sin versionar). Se incluyó en el commit del productor: es la especificación que el script implementa y debe viajar con él (copia idéntica a la del consumidor, §10).

---

## 4. Resultado de los 9 chequeos (Fase 2), conteos reales

| # | Chequeo | Esperado | Observado | Estado |
|---|---|---|---|---|
| 1 | 15 columnas, orden y tipos del contrato | match | orden TRUE; tipos: rbd string, anio int32, booleanos bool, `fecha_calculo` date32[day], valor/desvio double | **PASA** |
| 2 | `rbd` character + ceros a la izquierda | character | character; `rbd` con cero inicial = **0** (la fuente no tiene RBD con ceros a la izquierda — invariante igual satisfecho) | **PASA** |
| 3 | Llave `(rbd, anio, eje, segmento)` única | 0 dup | 0 duplicados | **PASA** |
| 4 | Ninguna fila con ambos booleanos FALSE | 0 | 0 | **PASA** |
| 5 | Ningún booleano de mejora en NA | 0 | 0 | **PASA** |
| 6 | `version_contrato == "contexto_v1"` 100% | sí | sí | **PASA** |
| 7 | `escala == "idps_prom"` 100% | sí | sí | **PASA** |
| 8 | Cobertura vs-GSE solo 2024-2025 | {2024,2025} | {2024,2025} | **PASA** |
| 9 | Trazabilidad de la bandera (fuente vs salida) | coincide | ver abajo | **PASA** |

**Cobertura por año (chequeo 8):**

| anio | filas | mejora_sobre_gse=TRUE | mejora_ano_ano=TRUE |
|---|---|---|---|
| 2024 | 19.702 | 13.436 | 12.242 |
| 2025 | 19.889 | 13.856 | 12.145 |

(No hay filas < 2024: sin ninguna de las dos señales, todas caen por el filtro de exposición. Coherente con §8: IDPS no tiene señal antes de 2024.)

**Trazabilidad (chequeo 9), re-derivado independientemente desde `idps_largo.parquet`:**
- `sigdifgru == 1` (familia indicador): fuente **27.292** = salida `mejora_sobre_gse=TRUE` **27.292** → COINCIDE.
- `sigdif == 1` (familia indicador): fuente **24.387** = salida `mejora_ano_ano=TRUE` **24.387** → COINCIDE.

Sin pérdida ni invención de señal.

---

## 5. Verificación de invariantes (🔒)

| Invariante | Estado | Evidencia |
|---|---|---|
| Banderas leídas verbatim, nunca recalculadas | **PASA** | El productor solo mapea `== 1L`; `34:273-275` las lee verbatim y no se tocó. Chequeo 9 confirma conteos idénticos. |
| Solo filas con alguna mejora TRUE | **PASA** | Chequeo 4 = 0 filas doble-FALSE; filtro `mejora_sobre_gse | mejora_ano_ano` en el script. |
| `rbd` siempre character | **PASA** | Chequeo 1/2: `rbd` string. |
| Booleanos nunca NA (0/-1/NA → FALSE) | **PASA** | Chequeo 5 = 0 NA; idioma `!is.na(x) & x==1L`. |
| No tocar 20_insumos ni idps_largo ni artefactos existentes | **PASA** | El paso solo lee la fuente; escribe solo `publico/contexto_idps.parquet`. `git status` no muestra cambios en `20_insumos/` ni en `idps_largo.parquet`. |
| Gobernanza: sin RBD ni filas individuales en logs | **PASA** | Este log y el reporte solo contienen conteos agregados y esquemas. |
| No push | **PASA** | 2 commits locales; ningún `git push` ejecutado. |

---

## 6. Decisiones tomadas autónomamente

1. **Exclusión de `familia == "dimension"`.** El contrato (§8) admite la señal año-año de nivel dimensión, pero solo existe en 2025 y en un grano distinto (dimensión, no indicador). Mezclar indicador y dimensión bajo la misma columna `eje` produciría una llave donde un mismo `eje` significa cosas distintas y rompería la unicidad semántica de `(rbd, anio, eje, segmento)`. Se expone **solo `familia == "indicador"`** en v1 (opción conservadora, indicada por el encargo). Pendiente explícito en §7.
2. **Glosa de `eje_etiqueta`:** `INDICADOR_LABELS` en `10_utils/10_configuracion.R:79-84` (acentuada, canónica de presentación). Se prefirió sobre `indicador_nombre` de `catalogo_idps.parquet` (ASCII sin tildes) por coincidir con el estilo del contrato y ser la constante de configuración del proyecto.
3. **Correlativo `36`** (no 35bis ni reutilizar): siguiente id libre; el paso corre tras el motor, del que no depende (solo depende de `idps_largo`, paso 34).
4. **Versionar el parquet de salida.** `.gitignore` **no** ignora `40_salidas/publico/` (RAMA A versiona datos; `intermedios/*.parquet` y `motor_idps.html` ya están trackeados). `git check-ignore` devolvió rc=1 (no ignorado). Se versionó por consistencia con la convención del repo. La copia al consumidor sigue siendo manual (contrato §10).

---

## 7. Pendientes abiertos

1. **Señal año-año de nivel dimensión (2025), EXCLUIDA en v1.** Si el titular la quiere exponer, requiere decidir cómo convive con el grano indicador: ¿columna `eje` que distinga indicador vs dimensión?, ¿`segmento` extendido?, ¿un parquet separado? Es material de una eventual v2 del contrato (§4 prohíbe forzar el encaje).
2. **`prom_GSE` (puntaje absoluto del GSE) no se expone.** El contrato solo pide `desvio_gse` (= `difgru`) y el booleano; el puntaje absoluto del grupo no es parte de v1.
3. **Copia al consumidor:** el parquet quedó versionado en este repo, pero su copia a `slep_minuta_buenas_senales/20_insumos/contexto_idps.parquet` es tarea manual del titular (no automatizada; contrato §10).
4. **`periodo` hardcodeado** a `"2026-07"` como constante nombrada. Si se re-corre en otro mes, hay que actualizar `PERIODO_CORRIDA` (o derivarlo; no se automatizó para evitar dependencia de `Sys.Date()` en el período declarado).
5. **Push pendiente** del titular tras revisión.

---

## 8. Notas para el revisor (mirar con ojo crítico)

- **Chequeo 9 es el que importa:** confirma que el booleano no inventa ni pierde señal respecto de la bandera cruda. Re-derivado de forma independiente desde la fuente; coincide exacto (27.292 y 24.387).
- **`desvio_gse` con NA legítimo:** hay filas con `mejora_sobre_gse=TRUE` y `desvio_gse=NA` (bandera +1, magnitud suprimida). Es lo que manda §6; no es un bug. Verificar que el consumidor lo tolere (columna admite NA por diseño).
- **Solo 2024-2025 en la salida:** puede sorprender que no haya filas históricas, pero es correcto: antes de 2024 no hay señal, y el contrato solo expone mejoras. La serie histórica sigue completa en `idps_largo.parquet` (intacto).
- **`periodo` y `fecha_calculo`:** `fecha_calculo = Sys.Date()` cambia en cada corrida; `periodo` es constante. Si se re-genera, el parquet cambiará solo en `fecha_calculo` (y en el orden si arrow no es determinista — no se verificó byte-idempotencia entre corridas).
- **Exclusión de dimensión:** decisión de alcance, no técnica. Si el titular la considera necesaria ya, es lo primero a rediscutir.

---

*Fin del andamio. Congelado 2026-07-11. No commitear. Rama `feat/contrato-contexto`, 2 commits locales, sin push.*
