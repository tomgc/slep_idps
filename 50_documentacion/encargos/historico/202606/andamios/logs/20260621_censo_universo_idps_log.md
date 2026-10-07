# Log — Censo forense del universo IDPS (P5, fase 1 rehecha)

**Sesión 10 · 2026-06-21 · censo puro READ-ONLY, conservación por defecto (cero
poda).** Barrido de los 3 orígenes del universo IDPS, perfilado por archivo/hoja/
columna, y mapa de cobertura año×grado×nivel de informe. No se transformó, movió,
renombró, convirtió ni descartó ningún archivo. md5 de `idps_largo.parquet` intacto.

---

## Resumen

Se censó el **universo IDPS completo** (95 xls/xlsx en raíz `20_insumos/`,
`historico_2014_2018/` recursivo y `auxiliares/`): **59 tablas de datos IDPS**, 33
glosas, 3 no-IDPS, + 27 `.DS_Store` (ruido). Se perfiló cada tabla de datos y se
determinó su **nivel de informe** (Indicador / Dimensión / Subdimensión-niveles),
produciendo la **matriz maestra año×grado×nivel** — el producto central. El
encuadre de conservación se respetó: ningún activo se marcó descartable; toda
asimetría se reporta como información. El panel adversarial (4 verificaciones con
código independiente) salió **4/4 PASA**.

**Corrección clave durante la ejecución:** la primera pasada del detector de nivel
solo conocía el esquema de texto (`ind`/`dim`/`sdim`, 2022-2024) y leyó mal los
archivos **2025** (que usan `id_indicador`/`id_dimension`/`id_subdimension`,
numéricos): el archivo `dim` de 2025 se clasificó como I en vez de D. Se corrigió
el detector para reconocer ambos esquemas y se re-corrió; la matriz quedó correcta
(2025 = I·D·S).

---

## Inventario de commits

Dos commits atómicos (el `verificar_censo_universo.R` gitignored y el parquet de
inventario en `40_salidas/` NO se versionan). **NO push.**

| Hash | Tipo | Archivo |
|---|---|---|
| (ver reporte chat) | docs(idps) | `50_documentacion/activa/censo_universo_idps.md` |
| (ver reporte chat) | docs(idps) | este log |

## Artefactos creados
- `verificar_censo_universo.R` (raíz, gitignored) — script del censo.
- `50_documentacion/activa/censo_universo_idps.md` (1412 líneas) — reporte (Fase A/B/C).
- `40_salidas/intermedios/inventario_universo_idps.parquet` (95×11) — inventario tabular (trabajo, no versionado).
- Este log.

---

## Matriz maestra año × grado × nivel (producto central)

| grado | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020-21 | 2022 | 2023 | 2024 | 2025 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 4b | I | I | I | I | **I·D** | — | pand | I·D | I·D·S | I·D·S | I·D·S |
| 6b | I | I | I | — | **I·D** | — | pand | — | — | I·D·S | — |
| 8b | I | I | — | I | — | I | pand | — | — | — | I·D·S |
| 2m | I | I | I | I | **I·D** | — | pand | I·D | I·D·S | I·D·S | I·D·S |

I=indicador · D=dimensión · S=subdimensión/niveles · pand=hueco pandemia (esperado).

## Catálogo de activos por nivel
- **Indicador (I):** todo año-grado con dato (2014-2019 histórico + 2022-2025 moderno).
- **Dimensión (D):** **2018 (4b/6b/2m)** + 2022→ moderno. El 2018 D **puentea** la serie de dimensión a través del hueco pandemia.
- **Subdimensión/niveles (S):** solo 2023→ (no hay S en el histórico).

---

## Hallazgos (con evidencia)

| # | Hallazgo | Evidencia |
|---|---|---|
| H1 | **95 archivos**, 59 datos IDPS (raíz 25 + histórico 34), 33 glosas, 3 no-IDPS, 27 `.DS_Store`. | Censo + panel P1 (setdiff vacío FS↔inventario). |
| H2 | **3 esquemas históricos confirmados:** mínimo 2014-16 (7 cols, I), enriquecido-texto 2017 (geo+depe/grupo en TEXTO, I), **2018 con dimensión** (ind_*_rbd + 11 dim_*_rbd, I·D), enriquecido-numérico 2019 (I). | Perfilado + panel P2. |
| H3 | **2018 = activo de dimensión real**, no artefacto: 11 `dim_*_rbd` en [0,100], 1 fila por RBD (2m 2935, 4b 7414, 6b 7322 filas==rbd distintos), NA=supresión. | Panel P3. |
| H4 | **`cod_depe2` heterogéneo:** ausente 2014-16; TEXTO 2017; numérico 2018-19; **`4` en 2m_2018** (posible SLEP temprano). | Perfilado por archivo. |
| H5 | **`agno` ausente en 2018** (los demás históricos sí lo traen; año-nombre==año-dato donde existe). | Cruce agno↔nombre. |
| H6 | **Migración de esquema moderno texto↔id:** 2022-2024 usan `ind/dim/sdim` (texto); **2025 usa `id_indicador/id_dimension/id_subdimension`** (numérico). | Panel P2 (#8/#9). |
| H7 | **S (niveles) solo desde 2023** (2022 = I·D; niveles entran 2023). | Matriz. |
| H8 | **Glosa 2018 no documenta las dimensiones:** 0 celdas mencionan `dim_*`; lista los 4 indicadores como `ind_am` (sin sufijo `_rbd`). | Lectura de la glosa 2018. |
| H9 | **Duplicados/ajeno:** histórico tiene 10 archivos 2022/2023 (duplican raíz) y 12 de 2024; `4b2024` está **solo** en `historico/4B` (no en raíz). | Fase A byte-check. |

---

## Panel adversarial (4 verificaciones, código independiente)

| Punto | Veredicto | Evidencia |
|---|---|---|
| P1 — cobertura | **PASA** | 95 (raíz 27/hist 58/aux 10); datos 59, glosa 33, no_idps 3; inventario 95 filas; setdiff FS↔inv vacío. |
| P2 — nivel de informe (9 esquemas) | **PASA** | Los 9 coinciden: 2014/2017/2019 ancho I; 2018 ancho I·D; moderno rbd largo I; rbd_dim largo D; niveles-texto 2023 S; 2025 id-dim D (sin id_subdimension); 2025 id-niveles S. |
| P3 — dimensión 2018 real | **PASA** | 11 `dim_*_rbd` en los 3, [0,100] (0 fuera), 1 fila/RBD, NA=supresión real. |
| P4 — integridad | **PASA** | md5 `50d9de4f…` (bash+R); `git status` sin M/D bajo `20_insumos/` (solo carpeta untracked). |

**Veredicto global: 4/4 PASA.** Ninguna corrección necesaria tras el panel.

---

## Verificación de invariantes 🔒

| 🔒 | Estado | Evidencia |
|---|---|---|
| Conservación por defecto (cero poda) | **PASA** | Catálogo lista todo como activo; el 2018 aparece en Dimensión; nada se marca descartable. |
| READ-ONLY absoluto | **PASA** | Solo se crearon los 4 artefactos; panel P4: ningún `20_insumos/` modificado. |
| `idps_largo.parquet` byte-idéntico | **PASA** | md5 `50d9de4f1fc80259d29f499cdf46d9e1` inicio y cierre. |
| No corregir datos "a ojo" | **PASA** | Glosa 2018 sin dimensiones, 2017 en texto, sufijos `_rbd`: reportados tal cual. |
| No asumir por el nombre | **PASA** | Cada archivo abierto, hoja y columnas leídas; nivel determinado por columnas. |
| Llaves `character` | **PASA** | `col_types="text"` en todo el perfilado. |

## Estado de cifras críticas
- md5 `idps_largo.parquet`: inicial `50d9de4f1fc80259d29f499cdf46d9e1` → final igual. **IGUALES.**

---

## Decisiones detectadas para el titular (NO resueltas, sin recomendar podar)
- **D1** Mapeo `dim_*` 2018 → `id_dimension` (**a validar**): la glosa 2018 no los define; propuesto por sufijo + crosswalk `catalogo_idps` (tabla en el reporte §C6).
- **D2** `cod_depe2`/`cod_grupo`/geo en TEXTO en 2017: conversión texto→código al homologar.
- **D3** `agno` ausente en 2018: derivar del nombre.
- **D4** geo 2018 con nombres distintos (`nom_regi_n`/`nom_comuna`/`cod_deprov`): renombrar.
- **D5** `cod_depe2`=4 en 2m_2018: interpretación (SLEP temprano).
- **D6** migración texto↔id 2022-24 vs 2025.
- **D7** S no construible antes de 2023; I en todo el rango; D en 2018 + 2022→.

---

## Notas para el revisor (qué mirar con ojo crítico)
- **El producto central es la matriz C1**: define qué serie es construible por nivel. Léela junto al catálogo C4.
- **Lo que costó:** el detector de nivel falló al inicio con 2025 (esquema id-numérico) — clasificó el `dim` de 2025 como I por tener `prom`. Es el mismo tipo de punto ciego (clasificar mal un nivel) que motivó rehacer el censo; el panel P2 lo verifica independientemente con los 9 esquemas. Corregido y re-corrido.
- **`git status` muestra cambios en `50_documentacion/estructura/`**: son **pre-existentes** (corridas del escáner), fuera de `20_insumos/`; no los tocó el censo (panel P4 lo confirma).
- **Conservación:** ni una sola recomendación de poda; las decisiones de uso quedan para el titular con evidencia al lado.

## Decisión sobre commits
Se commitean **dos** artefactos (reporte + este log), atómicos. El script y el
parquet de inventario quedan sin versionar. **No push** (el titular revisa antes).
