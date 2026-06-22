# Log — Censo de valores del histórico IDPS 2014-2019 (sesión 11, complemento)

> Fecha: 2026-06-21 · Encargo: `50_documentacion/activa/encargos/encargo_claude_code_idps_verificacion_valores_historico.md`
> Naturaleza: **auditoría READ-ONLY, censo celda-por-celda** de los valores históricos
> (`prom` + `cod_grupo`) vs el crudo ancho. Complemento del audit previo (que dejó el
> moderno exhaustivo y el histórico solo por conteos + 14 anclas).
> Ejecutor: Claude Code (Opus). **Sin cambios de datos/código; sin push; sin Pages.**

## 1. Resumen

Censo independiente: re-pivoteo propio (sin funciones de `34`) de los 18 xlsx anchos
2014-2019 → full-join contra el subconjunto histórico del parquet → comparación
**celda por celda** de `prom` y `cod_grupo`. Verificado por **tres re-derivaciones
independientes** (mi script + 2 agentes con código propio). **Veredicto: 4/4 fases PASA,
sin hallazgos.** Los valores del histórico reproducen el crudo **exactamente**: 0 diffs de
`prom` (mi `max|delta| = 0`, agente 5.68e-14 << TOL=1e-9), 0 diffs de `cod_grupo`, 0 filas
inventadas/perdidas, 0 combinaciones de crosswalk sin respaldo en el corpus. md5 del parquet
**idéntico** al inicio y al fin.

## 2. Inventario de commits

Ninguno de datos ni de código (read-only). `verificar_*.R` y `/tmp/*.R`: efímeros,
gitignored, no commiteados. **Este log se deja SIN commitear** para revisión previa del
titular (o, si se versiona, como `docs()` aislado).

## 3. Fase 0 — estado real (compuerta)

- md5 `idps_largo.parquet` = `4c764d8c9f0bf70004f8aa52661ae901` == canónico ✓.
- 18 xlsx históricos presentes; `CW_INDICADOR`/`CW_DIMENSION`/`GSE_LABELS` y corpus disponibles.

## 4. Fases verificadas

### Fase 1 — Re-pivoteo independiente — **PASA**
- Código propio (no importa `34`): `to_num`, conversión GSE texto→código (inverso de
  `GSE_LABELS`), parseo de columnas, todo reimplementado. Detección por NOMBRE:
  `ind_{cod}` / `ind_{cod}_rbd` → indicador; `dim_{ind}_{suf}_rbd` (token medio) → dimensión 2018.
- Re-derivadas **613.809** filas (indicador 419.428 + dimensión 194.381), grilla NA-completa.
- Estructura por régimen confirmada: 2014-2016 `ind_{cod}` sin GSE; 2017 `ind_{cod}` + GSE
  **texto** (Bajo..Alto); 2018 `ind_{cod}_rbd` + 11 `dim_*_rbd` + GSE numérico; 2019 `ind_{cod}`
  + GSE numérico. 0 códigos/sufijos fuera del crosswalk.

### Fase 2 — Full-join y censo de valores — **PASA** (el corazón)
- Full-join NA-safe (llave `(rbd,agno,grado,familia,id_indicador,id_dimension)` con centinela):
  `left_only=0`, `right_only=0`, `inner=613.809`. Llave única en ambos lados.
- **`prom`: 0 diferencias** (NA-safe, |delta|>TOL). `max|delta|`: **mi censo = 0.000e+00**
  (replica el round-trip exacto de `34`); agente independiente = **5.684342e-14** con un `to_num`
  más crudo — ambos << `TOL=1e-9` (ruido IEEE-754, no diferencia real).
- **`cod_grupo`: 0 diferencias** (NA-safe). Patrón: NA 2014-2016, presente 2017-2019
  (NA 0.3% / 1.25% / 0.12%). NA legítimos preservados (p. ej. 5 NA en 2m2018, 7 NA en 8b2019).
- **Dos métodos coinciden:** comparación `!=` columna-a-columna (0/0) y `anti_join` sobre la
  tupla-valor (0/0). Cuadre no-NA: indicador **410.380**, dimensión **189.767** (exacto).

### Fase 3 — Censo del crosswalk vs corpus — **PASA**
- Pares distintos usados: indicador `AM→1, CC→2, PF→3, HV→4` (biyección, sin reuso entre años);
  dimensión `AA→11, ME→12, AR→21, AO→22, AS→23, PA→31, VD→32, SP→33, VA→41, HA→42, AC→43`
  (cada sufijo → un único id; 0 reutilizado con otro significado).
- 15 combos (familia, ids); `id_dimension %/% 10 == id_indicador` en todos.
- **Contra el corpus:** la estructura usada calza 1:1 (4 indicadores; 11 dimensiones agrupadas
  2/3/3/3); **0 combinaciones sin respaldo**. La numeración intra-decena de Hábitos
  (41=vida activa por glosa, no por orden del corpus) es nota documentada, no hallazgo
  (todo `id_dim %/% 10 == 4` apunta al indicador 4 correcto).

### Fase 4 — Geo de RBD solo-histórico (liviana) — **PASA**
- 789 RBD aparecen solo en el histórico (sin fila moderna 2022+). Geo sana: los poblados
  spot-checkean 1:1 contra el crudo de su año más reciente (RBD 1000/1007 4b2017 reg4/com4201;
  RBD 20142 8b2019 reg9/com9205; RBD 5963 4b2018 reg9/com9103 — confirma que `cod_reg_rbd`/
  `cod_com_rbd` numéricos de 2018 no se afectan por el mapeo divergente `nom_regi_n`/`nom_comuna`).
- 389 RBD con geo NA = NA **legítimo**: 356 con año reciente 2014-2016 (el crudo no trae columnas
  de geo) + 33 con 2017/2018 cuya geo es NA en el propio crudo (verificado fila a fila).

## 5. Tabla de hallazgos

| # | observación | severidad | ¿toca cifra IDPS? | estado |
|---|---|---|---|---|
| — | **Sin hallazgos.** 4/4 fases PASA. | — | — | — |
| nota-1 | Hábitos: orden del corpus ≠ numeración de la glosa (41=vida activa por glosa) | informativa | No | documentado (config) |
| nota-2 | `max|delta|` de `prom`: 0 (mi censo) vs 5.68e-14 (agente) según el `to_num` usado | informativa | No | ambos << TOL, ruido IEEE-754 |

No hubo diferencia de valor real → nada que corregir → nada que escalar como tarea nueva.

## 6. Verificación de invariantes 🔒

| invariante | estado | evidencia |
|---|---|---|
| READ-ONLY (md5 inicio==fin) | **PASA** | `4c764d8c…` al inicio y al fin |
| Código independiente (no `34`) | **PASA** | pivoteo, `to_num`, GSE texto→código reimplementados; solo se leyó `10_configuracion.R` (constantes) y el corpus |
| "Lee, no deriva" (NA legítimo) | **PASA** | NA del crudo preservado como NA; no contado como diff |
| `verificar_*.R` efímeros, no commiteados | **PASA** | gitignored; 0 en `git add` |
| No mutar el repo | **PASA** | sin commits de datos/código, sin push |
| Gobernanza (RBD, no nombres) | **PASA** | el log ejemplifica solo con RBD |

## 7. Estado de cifras y cierre

- **md5 parquet antes = después = `4c764d8c9f0bf70004f8aa52661ae901`.** Cero escritura.
- Repo sin cambios de datos/código; este log nuevo queda **sin commitear** para tu revisión.

## 8. Pendientes / # REVISAR

Ninguno de integración. La vista histórica extendida en el motor 35 sigue siendo trabajo de
motor de una sesión futura, fuera del alcance de este censo.

## 9. Notas para el revisor (honestidad operativa)

- **Ambigüedad de desambiguación (reparo del log anterior):** la única "discrepancia" que apareció
  fue metodológica, no de dato. El agente independiente, al comparar `prom` por `anti_join` con
  `sprintf("%.9f", ...)`, obtuvo 15 falsos positivos en la frontera de redondeo (todos con
  `|delta|` real entre 1.4e-14 y 5.7e-14, **< TOL**); se reconciliaron a 0 al usar una codificación
  TOL-equivalente (redondeo a 6 decimales). Mi propio censo evitó esto comparando con tolerancia
  numérica directa (`abs(a-b)>TOL`), dando 0 sin frontera.
- **Por qué mi `max|delta|` es 0 y el del agente 5.68e-14:** mi `to_num` replica el round-trip
  `as.numeric(gsub(",",".",as.character(x)))` que usa `34`, así que mi `prom` queda bit-idéntico al
  del parquet; el agente leyó el doble más crudo y aun así coincidió dentro de 5.68e-14. Que dos
  normalizaciones distintas converjan al mismo valor (dentro del ruido flotante) refuerza que el
  dato es correcto, no un artefacto de una única ruta de lectura.
- Ningún shell falló de forma irrecuperable. Conclusión: los valores del histórico reproducen el
  crudo celda por celda.
