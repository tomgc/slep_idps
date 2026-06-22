# Log — Motor con serie histórica 2014→2025 (P-MOTOR, sesión 12)

> Fecha: 2026-06-21 · Encargo: `50_documentacion/activa/encargos/encargo_claude_code_idps_motor_historico.md`
> Ejecutor: Claude Code (Opus). Autónomo, secuencial. **El parquet no se toca** (read-only sobre el dato).

## 1. Resumen

El motor desplegado mostraba solo 2022-2025 (precedía a la integración histórica y a 4b2024). Este
encargo extiende el generador `35` y el template para que el motor muestre la **serie histórica
2014→2025** ya presente en `idps_largo.parquet` (md5 `4c764d8c…`, intacto). Se regeneró y desplegó.
Verificación **en vivo** (servidor estático + navegador): los 8 criterios de éxito PASA. Dos hallazgos
documentados (H6 dependencia-NA, geo-NA del directorio), ninguno bloqueante.

## 2. Inventario de commits por fase

| fase | hash | commit |
|---|---|---|
| 1 (generador: eje) | `c5f73f0` | feat(motor): eje historico contiguo con estados de año en meta |
| 2 (template) | `af1766c` | feat(motor): vista historica con eje contiguo, header dinamico y ficha sin territorio |
| fix (surgido al regenerar) | `cae06c8` | fix(motor): tolerar dependencia NA en RBD solo-historicos (no inventar) |
| fix (surgido por el panel) | `fefb79a` | fix(motor): un establecimiento por RBD (deduplicar variantes historico/moderno) |
| 3 (build) | `3be1caf` | build(motor): regenerar y desplegar serie 2014-2025 |
| 7 (log) | _(este)_ | docs(motor): log P-MOTOR serie historica |

> Nota: las 3 sub-temáticas del template del encargo (render desactivados / header / geo-NA) van en
> UN commit (`af1766c`) por compartir un único archivo y no haber staging interactivo por hunks en
> este entorno; el diff las separa con claridad.

## 3. Cambios sustantivos y por qué

- **Generador — eje server-side (D-s12-EJE):** `ANIOS_PANDEMIA <- c(2020L,2021L)`; por grado del motor
  se construye el eje contiguo `seq(min..max)` de años con dato y se clasifica cada año en
  `con_dato`/`pandemia`/`no_eval`, emitido en `meta$eje_historico`. También `meta$cobertura_anios`
  (min/max) para el header. No quita campos del contrato JSON.
- **Template — consumo del eje:** nueva `serieEje()` (paralela a `serieFull`, ahora huérfana como
  `PanelEvolucion`); `BarrasAnio` pinta `con_dato` = barra, `pandemia`/`no_eval` = columna gris
  desactivada (`.ybar-off`, reusa `--gris`; mismo gris, tooltip distinto). Se conserva el hueco "sin
  dato" para EE sin fila en un año con_dato.
- **Template — header dinámico:** `span#cob-anios` seteado en el arranque desde
  `meta.cobertura_anios` (el header es HTML estático fuera de React). Se eliminó la nota falsa "4°
  básico no aplica 2024" de `ficha-explain` (4b SÍ tiene 2024) y se reescribió para explicar los años
  en gris.
- **Template — geo-NA (D-s12-GEONA):** `comNom`/`regNom` degradan `null` a `""`; `terrFicha()` muestra
  "Sin territorio asignado · solo registro histórico" en la ficha de un RBD sin geo.
- **Generador — fix H6 (hallazgo, ver §5):** el `stopifnot` de dependencia (válido cuando el universo
  era solo-moderno) abortaba la regeneración; se relajó para reportar el NA legítimo de solo-históricos
  y seguir abortando si un RBD moderno perdiera dependencia.

## 4. Verificación en vivo (8 criterios de éxito)

Servidor estático sobre `40_salidas/` (= `docs/index.html` byte-idéntico) + navegador. Verificado en
el build inicial y re-verificado en el build final tras el dedup (md5 `74811595`).

| # | criterio | resultado |
|---|---|---|
| 1 | 4b2024 presente | **PASA** — ficha RBD 1853 muestra barra 2024 (val 77); JSON `ind` 4b-2024 = 28.740 filas |
| 2 | Eje contiguo (2019/2020/2021 gris) | **PASA** — 12 columnas 2014…2025; 2019/20/21 `is-off`; tooltips: 2019 "Este grado no se evaluó este año", 2020/21 "Sin evaluación (pandemia)"; 2018 y 2022 NO pegados |
| 3 | Dimensión solo 2018 histórico | **PASA** — drill-down: "sin dato" 2014-2017, barra solo 2018 (83,9), gris 2019-21, barras 2022-25 |
| 4 | Sin significancia/GSE inventados | **PASA** — 2014: `prom` presente, `dif`/`sigdif`/`difgru` = null; GSE 2014 = null (pre-GSE), 2023 = "2" |
| 5 | Header dinámico | **PASA** — eyebrow "Datos **2014–2025**" (antes 2022–2025); nota 4b2024 eliminada |
| 6 | Geo-NA | **PASA (con hallazgo)** — `terrFicha` degrada correcto; pero el caso real es casi inexistente (ver §5) |
| 7 | Parquet intacto | **PASA** — md5 `4c764d8c…` antes y después de regenerar |
| 8 | Render sin errores de consola | **PASA** — 0 errores tras navegar territorial→ficha→histórica |

## 5. Auditoría de diagnóstico (hallazgos)

| # | hallazgo | severidad | ¿toca cifra? | estado |
|---|---|---|---|---|
| H-s12-1 | `stopifnot` H6 abortaba la regeneración: solo-históricos (cerrados, máx ≤2018) sin dependencia ni en el directorio ni en el dato 2014-2016. **1 RBD** queda con dependencia NA legítima → degrada a "—". | media (bloqueaba el build) | No | **corregido** (commit `cae06c8`): reporta el NA, no inventa; aborta solo si un RBD moderno perdiera dependencia |
| H-s12-2 | El encargo supuso ~356 RBD geo-NA visibles por buscador. En el build, el **directorio público SÍ cubre** la geo de los solo-históricos: de 804 solo-históricos, **803 tienen geo** (navegables territorialmente). Solo **1** sin geo, y es un **registro fantasma `rbd=NA`** (el crudo 4b2017 traía 1 rbd nulo; 4 filas en `ind`), **inerte** (no buscable, no en tarjetas, no abrible). | baja | No | **documentado, no acomodado** (detención regla 2). El pulido `terrFicha` es correcto/defensivo; el caso "Sin territorio" casi no se dispara. Posible higiene futura: filtrar `rbd=NA` en el generador (fuera de alcance; el parquet es 🔒) |
| H-s12-3 | Con la serie histórica, un RBD podía traer atributos IDPS distintos entre filas histórico/moderno; el `distinct(rbd, nom_rbd, geo…)` del generador producía **establecimientos duplicados** (20 RBD ×2 con variantes idénticas tras el `coalesce` con el directorio) → **tarjetas repetidas** en el panorama. Detectado por el panel adversarial; confirmado en vivo (RBD 75 aparecía 2 veces en su comuna). | media (defecto visible) | No | **corregido** (commit `fefb79a`): `est_attr` toma una fila por RBD (la más reciente); 0 duplicados (9157→9137 EE). Misma clase que H6 (supuesto del generador roto por el histórico) |
| Nota | El encargo §2 decía "preliminar=TRUE en 2024 y 2025"; el dato real marca **2024 como final** para 4b/2m (4b2024 y 2m2024 son archivos `_final`). El generador deriva `anios_preliminar` del dato (su principio), así que el eje marca solo 2025 con `*`. | informativa | No | correcto por dato |

## 6. Panel adversarial (§6) — veredicto: **2/2 PASA**

2 agentes read-only con código R propio (decodifican `docs/index.html` y re-derivan vs el parquet,
sin reusar las funciones del generador).

| dimensión | veredicto | evidencia |
|---|---|---|
| A · Cobertura JSON vs parquet + eje | **PASA** | las 18 celdas grado×año de `ind` (+ dim + niv) coinciden JSON==parquet, 0 discrepancias; **4b2024 = 28.740** (JSON==parquet==esperado); eje contiguo seq(2014..2025) con 2019=no_eval, 2020/21=pandemia, sin pandemia espuria; 2019/20/21 cargan 0 filas |
| B · Geo-NA + md5 parquet | **PASA** | parquet **356** RBD geo-NA reales; build los cubre **356/356** vía directorio; build geo-NA = **1** (fantasma `rbd=NA`, 4 filas 4b2017); md5 `4c764d8c…` intacto |

**El panel destapó el defecto de duplicación** (20 RBD ×2 en `establecimientos`), reportado como
"nota menor" en su dim B; lo investigué en vivo, lo confirmé como visible y lo corregí (H-s12-3,
commit `fefb79a`). Tras el fix: 0 duplicados (re-verificado en vivo, RBD 75 = 1 vez).

## 7. Invariantes 🔒 (PASA/FALLA)

| invariante | estado | evidencia |
|---|---|---|
| El parquet no se toca (md5 inicio==fin) | **PASA** | `4c764d8c9f0bf70004f8aa52661ae901` antes y después de regenerar |
| Lee, no deriva (significancia/GSE no inventados) | **PASA** | 2014: dif/sigdif/difgru null; GSE null pre-2017 (criterio 4) |
| Solo 4b y 2m en la UI | **PASA** | `GRADOS_MOTOR` intacto; build expone 4b/2m |
| Sin agregación territorial | **PASA** | no se añadió ninguna cifra agregada; territorio = filtro |
| Dimensión histórica solo 2018; niveles no antes de 2023 | **PASA** | criterio 3 (dim solo 2018) + JSON (niv solo 2023-2025) |
| No inventar geo donde el dato trae NA | **PASA** | geo-NA degrada a "Sin territorio"; depe2-NA degrada a "—" |

## 8. Pendientes / # REVISAR

- **# REVISAR (titular):** H-s12-2 — ¿filtrar el registro fantasma `rbd=NA` en el generador (higiene),
  o dejarlo (es inerte)? Decisión del titular; el parquet no se toca.
- El comparador y la vista actual no fueron el foco de este encargo (se verificó que no hay errores de
  consola al navegarlos, pero la verificación profunda de esas pantallas queda para el titular).

## 9. md5 del parquet y cierre

- **md5 parquet: inicio = fin = `4c764d8c9f0bf70004f8aa52661ae901`.** Read-only sobre el dato.
- Build: `40_salidas/motor_idps.html` = `docs/index.html` (md5 `74811595…`), 6.2 MB, **9137 EE**
  (9136 + 1 fantasma; tras el dedup H-s12-3), filas ind/dim/niv 366.388 / 557.898 / 662.514.
- CLAUDE.md "últimos cambios" NO actualizado (es paso de cierre de sesión, 🔒 traspaso v11).

## 10. Notas para el revisor

- **Lo que costó:** la regeneración falló al primer intento por el `stopifnot` H6 (universo ahora
  incluye solo-históricos sin dependencia); se diagnosticó y corrigió (H-s12-1) sin tocar el parquet.
- El render se verificó EN VIVO (no por inferencia): React montó sin errores, header dinámico, eje
  contiguo con grises y tooltips correctos, 4b2024 visible, dimensión 2018, significancia/GSE NA.
- El hallazgo geo-NA (H-s12-2) muestra que el directorio público cubre mejor de lo supuesto; el pulido
  defensivo queda como red de seguridad.
