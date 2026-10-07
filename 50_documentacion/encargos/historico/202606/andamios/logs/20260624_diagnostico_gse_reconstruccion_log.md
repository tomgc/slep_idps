# Log — Diagnóstico: reconstrucción del "Puntaje promedio nacional del mismo GSE"

> Diagnóstico READ-ONLY (s21). Fecha: 2026-06-24. Ejecutor: Claude Code (Opus 4.8).
> No se modificó el parquet, scripts ni el working tree (salvo este log untracked).
> md5 parquet INICIO = FIN = `4c764d8c9f0bf70004f8aa52661ae901` (intacto).

---

## 1. Pregunta

¿El "Puntaje promedio nacional del mismo GSE" que publica la Agencia (cifra absoluta
0–100) se reconstruye SIN pérdida desde el parquet (que solo tiene `difgru`, no el
puntaje GSE absoluto), para dibujar un polígono GSE de referencia en el radar?

## 2. Signo de `difgru` (Paso 0, bloqueante) — DETERMINADO

- **Glosa** (`idps*_GLOSAS_web_*.xlsx`, hoja `idps`): `difgru` = *"Diferencia con el
  mismo GSE"*; `sigdifgru` = *"Indica si diferencia con el mismo GSE es significativa"*;
  `mdifgru` = *"Marca de la diferencia con respecto a la mismo GSE"*. **La glosa NO fija
  la dirección** (EE−GSE vs GSE−EE).
- **`mdifgru` inservible:** solo 5.609 filas no-NA, todas con el valor `"¬"` (símbolo,
  no marca direccional); con `sigdifgru!=0` el cruce queda vacío. No fija el signo.
- **Signo fijado por el dato (cruce `sign(difgru)` × `sigdifgru`):** alineación PERFECTA,
  cero fuera de diagonal:

  | | sigdifgru = −1 | sigdifgru = +1 |
  |---|---|---|
  | difgru < 0 | 21.969 | 0 |
  | difgru > 0 | 0 | 27.292 |

  `sigdifgru=+1` es "sobre su GSE" (semántica establecida del motor: `sigdifgru===1`→
  sobre, `===-1`→bajo). Como `difgru>0 ⟺ sigdifgru=+1 ⟺` EE por encima del GSE:
  **`difgru = prom_EE − prom_GSE`**, por tanto **`prom_GSE = prom − difgru`**.

## 3. Prueba decisiva — consistencia intra-grupo (sd intra-grupo)

`prom_GSE` debe ser ÚNICO por grupo `(cod_grupo, id_indicador, agno, grado)`. Varianza
intra-grupo (120 grupos con n≥3), tolerancia declarada **TOL_INTRAGRUPO = 0.20 pts**:

| Fórmula candidata | sd mediana | sd p95 | sd máx | grupos dentro de TOL |
|---|---|---|---|---|
| **prom − difgru** | **0** | **0** | **0** | **100 %** |
| prom + difgru | 9.78 | 12.82 | 14.04 | 0 % |

`prom − difgru` es **EXACTAMENTE constante** dentro de cada grupo (sd = 0, no solo ≤
tolerancia). Premisa "`difgru` es desvío vs un único `prom_GSE`": **CONFIRMADA** con
sd=0. La fórmula alternativa queda refutada (sd ~10–14).

## 4. Reconstrucción es exacta (sin riesgo de ±1)

- `prom` y `difgru` son **enteros** en las 114.509 filas reconstruibles (0 con
  decimales). El "redondeo asimétrico" temido no aplica: el dato ya es entero.
- Entero-vs-crudo: `round(prom−difgru,0)` vs `round(round(prom,0)−difgru,0)` →
  **0 filas difieren** de 114.509. El motor reconstruye el mismo entero use el `prom`
  crudo o el redondeado del payload.
- **Imposibles:** `prom − difgru` < 0 o > 100 → **0 casos** (ambas variantes).

## 5. Spot-check del caso publicado

- **EE=74 / difgru=0 (Autoestima):** `prom_GSE = 74 − 0 = 74` ✓ (coincide con el caso
  simce.cl EE=74, GSE=74, dif=0).
- **difgru ≠ 0 (Autoestima, mismo grupo da el mismo GSE):**

  | prom | difgru | cod_grupo | prom_GSE = prom−difgru |
  |---|---|---|---|
  | 77 | 4 | 3 | 73 |
  | 70 | −3 | 3 | 73 |
  | 79 | 6 | 3 | 73 |
  | 82 | 9 | 3 | 73 |
  | 81 | 6 | 2 | 75 |
  | 78 | 2 | 1 | 76 |

  Todos plausibles (0–100); el GSE es constante por `cod_grupo` dentro del indicador/
  año. ✓

## 6. Cobertura (el caveat mayor)

**Por indicador** (los 4 idénticos, ~18 %): de 157.961 filas-indicador c/u, ~28.700
con polígono GSE (difgru y cod_grupo no-NA); `difgru` NA ≈129k, `cod_grupo` NA =65.568.

**Por año — `difgru`/`cod_grupo` SOLO existen en 2024–2025:**

| año | % filas con polígono GSE |
|---|---|
| 2014–2023 | **0 %** |
| 2024 | 83.1 % |
| 2025 | 91.1 % |

⚠️ La comparación vs GSE (y por tanto el polígono) **solo es dibujable para 2024–2025**.
Para 2014–2023 no hay `difgru` en el dato (NA legítimo). El ~18% global se explica
porque solo 2 de 10 años traen la columna.

## 7. Veredicto

**El "Puntaje promedio nacional del mismo GSE" se reconstruye EXACTO desde el parquet
con `prom_GSE = prom − difgru` (entero), confirmado por consistencia intra-grupo sd=0 y
por el caso publicado 74/74/0. No hay riesgo de ±1 (prom y difgru ya son enteros). El
límite es de COBERTURA: solo existe para 2024–2025 y para ~18% de las filas-indicador.**

## 8. Caveats para la decisión (reapertura de "lee, no deriva")

- **Sigue siendo DERIVAR.** Aritméticamente exacto, pero `prom − difgru` es una
  reconstrucción, no una columna leída. La decisión `20260612_decision_ponderacion_idps.md`
  prohíbe derivar el puntaje GSE. El fundamento de reapertura (la cifra ES pública en
  simce.cl y se reconstruye sin pérdida) queda CONFIRMADO técnicamente; la decisión es
  del titular (metodológica, no técnica).
- **Cobertura parcial:** el polígono GSE solo aparecería en 2024–2025 y donde `difgru`
  y `cod_grupo` no son NA (~18% de filas-indicador). EE sin dato GSE no tendrían
  polígono — definir el comportamiento (omitir el trazo, no degradar a 0).
- **Recomendación técnica de redondeo:** usar `prom` **crudo del parquet** menos
  `difgru` (no el `prom` ya redondeado del payload) elimina cualquier ±1 teórico; aquí
  el delta medido fue 0 (dato entero), pero es la vía robusta si en años futuros la
  Agencia publicara decimales.
- **GSE solo a nivel INDICADOR:** `difgru` solo existe en familia indicador (no en
  dimensión ni niveles). El polígono GSE sería solo de los 4 indicadores (coherente con
  el radar).
- **md5 parquet sin cambios** (`4c764d8c…`): diagnóstico no tocó el dato.
