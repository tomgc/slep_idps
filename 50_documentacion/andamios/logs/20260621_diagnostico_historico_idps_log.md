# Log — Diagnóstico forense histórico IDPS 2014-2019 (P5, tramo 1)

**Sesión 10 · 2026-06-21 · encargo de LECTURA (diagnóstico forense).** Read-only
absoluto: no se modificó/movió/renombró/borró ningún archivo preexistente, no se
corrió el pipeline. Solo se crearon 4 artefactos nuevos.

---

## Resumen

Se censó, clasificó e inventarió **todo** el material depositado en
`20_insumos/historico_2014_2018/` (83 archivos = 58 datos/glosa + 25 `.DS_Store`),
y se perfiló columna por columna el histórico real 2014-2019 (cubeta A: 18 datos +
18 glosas). El histórico es **indicador-ancho** (confirmado 18/18; ninguno es el
formato largo de 2022+, así que el gate de contradicción estructural NO se dispara).
Surgieron **tres hallazgos de primer orden** que matizan la hipótesis del encargo
(detallados abajo). El panel adversarial (5 verificaciones con código independiente)
salió **5/5 PASA**. md5 de `idps_largo.parquet` intacto.

---

## Inventario de commits

**NINGUNO.** Este encargo no commitea nada (criterio de éxito #5): el titular revisa
el diagnóstico y el log antes de versionar lo que corresponda. La rama queda como
estaba; los artefactos quedan untracked en el working tree.

## Cambios sustantivos (los 4 artefactos creados)

| Artefacto | Qué es | Versionado |
|---|---|---|
| `verificar_historico_idps.R` | Script de diagnóstico (censo + clasificación + perfilado forense + síntesis + parquet). Efímero. | NO (gitignored, patrón `/verificar_*.R`) |
| `40_salidas/intermedios/diagnostico_historico_idps.md` | Informe forense (~1014 líneas): Fase 1 censo + matriz + cubetas; Fase 2 perfilado por columna de cubeta A; Fase 3 síntesis de 9 puntos. | NO (output de trabajo) |
| `40_salidas/intermedios/inventario_historico_idps.parquet` | Inventario tabular (58 filas × 11 cols) para que el tramo 2 lo consuma sin re-parsear. | NO (output de trabajo) |
| Este log | Cierre del diagnóstico. | NO (revisión del titular) |

---

## Auditoría de diagnóstico — tabla de hallazgos

| # | Hallazgo | Evidencia | Implicación |
|---|---|---|---|
| H1 | **Conteo:** 58 archivos (11 `.xls` + 47 `.xlsx`) + 25 `.DS_Store`. Cubetas A=36, B=10, C=12. | Censo recursivo + panel P1 (1:1). | Cuadra; nada sin inventariar. |
| H2 | **Régimen ancho confirmado** (18/18). Ninguno es formato largo (prom/ind por filas). | Perfilado + panel P3 (2014 y 2019). | Gate 0.1.3 NO se dispara; integración por pivot ancho→largo. |
| H3 | **Sub-épocas: 3, no 2.** (a) **Mínima** 2014-2016 (~7 vars: rbd, agno, grado, ind_am/cc/pf/hv; sin geo/GSE/depe). (b) **Enriquecida indicador-solo** 2017,2019 (geo+depe+GSE+rural+ind_am/cc/pf/hv). (c) **Enriquecida con DIMENSIONES** 2018. | Sets de columnas por archivo. | El plan de integración debe tratar 3 esquemas, no 2. |
| H4 | **HALLAZGO 2018 (variante):** los 3 archivos 2018 (`IDPS{2m,4b,6b}2018/idps_*2018.xlsx`) traen columnas `dim_*_rbd` (datos de DIMENSIÓN en ancho), indicadores con sufijo `_rbd` (`ind_am_rbd`…), geo con nombres distintos (`nom_regi_n`, `nom_provincia`, `nom_comuna`, `cod_deprov`) y **sin columna `agno`**. | Perfilado de las 3 hojas 2018. | Decidir si se ingieren las dimensiones de 2018 o solo sus 4 indicadores; renombrar geo; derivar año del nombre. |
| H5 | **HALLAZGO `cod_depe2` heterogéneo** (refuta "3 categorías numéricas sin 4"): ausente 2014-2016; **TEXTO** ("Municipal"/"Particular subvencionado"/"Particular pagado") en 2017; **numérico** 2018-2019; y **`2m_2018` incluye el valor `4`** (los demás 2018/2019 son {1,2,3}). | Volcado de valores únicos por archivo. | El `4` coincide con que los primeros SLEPs son traspaso 2018 → posibles SLEP tempranos. Homologación de dependencia es un gate. |
| H6 | **Convención `agno`: año-nombre == año-dato** (donde existe la columna). NO se observó el desfase "año anterior". 2018 sin columna `agno`. | Cruce agno-dato vs año-nombre (15/15 con agno calzan). | Año se toma del dato (o del nombre en 2018). |
| H7 | **GSE (`cod_grupo`):** presente 2017-2019, ausente 2014-2016. | Presencia de columna por archivo. | 2014-2016 no segmentable por GSE (gate G6). |
| H8 | **Indicadores:** {ind_am, ind_cc, ind_pf, ind_hv} en todos; ningún quinto indicador ni recodificación. | Perfilado. | Mapeo directo am/cc/pf/hv → indicadores 1/2/3/4, sin crosswalk. |
| H9 | **Cobertura grado×año irregular** (verificada, no inferida): 2016 sin 8b; 2017 sin 6b; 2019 solo 8b. 2020-2021 hueco pandemia (esperado). | Matriz de cobertura cubeta A. | Decidir carga de grado-año parciales. |
| H10 | **NA = supresión, no cero.** Verificado: idps6b2016 ind_am tiene 66 NA, min real=28 (sin 0 espurio). | Panel P4 (máscaras texto↔numérico 1:1). | El perfilado respeta 🔒-4. |
| H11 | **Cubeta C es 2024** (no histórico): 2M/4B con `agno`=2024 (12000/28740 filas). | Panel P2. | Material ajeno a P5; tramo 2 lo reubica/borra. |

### Matriz de cobertura grado × año (cubeta A, archivos de datos)

| grado | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 |
|---|---|---|---|---|---|---|
| 4b | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| 6b | ✓ | ✓ | ✓ | ✗ | ✓ | ✗ |
| 8b | ✓ | ✓ | ✗ | ✓ | ✗ | ✓ |
| 2m | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |

(Todos los presentes tienen glosa. **2020-2021: hueco pandemia, esperado.**)

---

## Panel adversarial (5 verificaciones, código independiente)

| Punto | Veredicto | Evidencia (re-derivada) |
|---|---|---|
| P1 — re-conteo | **PASA** | 58 sin `.DS_Store` (11 `.xls`+47 `.xlsx`), 25 `.DS_Store`; parquet 58 filas; A=36/B=10/C=12; correspondencia FS↔inventario 1:1 (setdiff vacío en ambos sentidos). |
| P2 — cubeta C = 2024 | **PASA** | 2M y 4B: columna `agno` valor único 2024 (12000 / 28740 filas). No hay 2014-2019. |
| P3 — régimen ancho | **PASA** | 2014: 7 cols (ind_am/cc/pf/hv ancho). 2019: 18 cols enriquecido ancho. En ambos: sin `ind`+`prom`, sin hojas dim/niveles. |
| P4 — NA≠0 | **PASA** | idps6b2016 ind_am: 66 NA (máscara texto==numérico 1:1), min real=28, 0 ceros espurios. |
| P5 — md5 parquet | **PASA** | `md5 -q` y `tools::md5sum()` = `50d9de4f1fc80259d29f499cdf46d9e1` (== inicial). |

**Veredicto global del panel: 5/5 PASA.** Ninguna corrección necesaria.

---

## Verificación de invariantes 🔒

| 🔒 | Estado | Evidencia |
|---|---|---|
| 1 — READ-ONLY total | **PASA** | Solo se crearon los 4 artefactos. `git status`: ningún preexistente del repo modificado por el diagnóstico (ver nota). |
| 2 — No ingerir al pipeline | **PASA** | No se corrió `34`/`run_all`; md5 `idps_largo.parquet` = `50d9de4f…` antes y después (panel P5 lo recomputó independiente). |
| 3 — Llaves como `character` | **PASA** | Todo se leyó con `col_types="text"`; rbd/cod_*/grado/agno perfilados como texto. |
| 4 — NA es dato, no error | **PASA** | NA y marcadores contados como supresión; nunca convertidos a 0 (H10/P4). |
| 5 — Clasificación honesta A/B/C/D | **PASA** | Cada archivo en una cubeta con criterio explícito; 0 en cubeta D (todos clasificables). |
| 6 — Sin transformar antes de inventariar | **PASA** | `.xls` leídos tal cual; perfilado describe el dato como está. |

---

## Estado de cifras críticas
- **md5 `idps_largo.parquet`:** inicial `50d9de4f1fc80259d29f499cdf46d9e1` → final `50d9de4f1fc80259d29f499cdf46d9e1`. **IGUALES.**

---

## Pendientes / gates para el titular (tramo 2 y 3)
- **G1** `cod_depe2` heterogéneo (texto 2017, numérico 2018-2019, ausente 2014-2016, `4` en 2m_2018): decidir homologación.
- **G2** Variante 2018 con `dim_*`: ¿ingerir dimensiones o solo indicadores?
- **G3** 2018 sin `agno`: derivar año del nombre al promover.
- **G4** 2018 geo con nombres distintos: renombrar al homologar.
- **G5** Cobertura parcial (2016 sin 8b, 2017 sin 6b, 2019 solo 8b): ¿cargar igual?
- **G6** 2014-2016 sin GSE: confirmar tolerancia a `cod_grupo` NA.
- **Limpieza tramo 2:** 25 `.DS_Store`, cubeta B (10, duplicados 2022/2023 ya en raíz), cubeta C (12, ajeno 2024) — qué borrar/reubicar.

---

## Notas para el revisor (qué mirar con ojo crítico)
- **El nombre de la carpeta engaña** ("2014_2018") pero el rango real es 2014-2019 y además contiene 2022/2023 (cubeta B) y 2024 (cubeta C). No asumir por el nombre.
- **La hipótesis del encargo se cumplió en lo macro (ancho indicador) pero se matiza en 3 puntos** (H4, H5, H6): el 2018 es una variante con dimensiones; `cod_depe2` no es uniforme y trae un `4`; `agno` no tiene desfase. Estos tres alimentan directamente los gates.
- **Lo que costó:** la primera pasada detectó "15/18 ancho" porque el 2018 usa `ind_am_rbd` (sufijo `_rbd`), no `ind_am`; se refinó la detección de indicadores/dimensiones por regex y se re-corrió. El 2018 es el archivo más atípico del lote.
- **`git status` muestra cambios en `50_documentacion/estructura/`** (snapshots del escáner): son **pre-existentes** en el working tree (corridas del escáner ajenas a este encargo), NO los tocó el diagnóstico (que solo lee `20_insumos/` y escribe en `40_salidas/intermedios/`).

## Decisión sobre este log
Queda **sin commitear** (revisión del titular junto al diagnóstico), según el encargo.
