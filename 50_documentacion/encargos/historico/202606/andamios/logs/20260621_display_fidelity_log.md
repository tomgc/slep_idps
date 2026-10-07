# Log de verificación — P-DISPLAY-FIDELITY (slep_idps, sesión 12)

> Cierre de la cadena de fidelidad: **parquet → cifra que el sitio DESPLEGADO muestra**.
> Encargo: `50_documentacion/activa/encargos/encargo_claude_code_idps_display_fidelity.md`.
> Tipo: SOLO LECTURA y verificación. No se modificó parquet, generador, template ni `docs/`.
> Fecha: 2026-06-21 · HEAD: `99597d8` · Generado por Claude Code (autónomo).

---

## 1. Resumen y veredicto

**VEREDICTO: PASA — el motor desplegado es fiel al parquet a 1 decimal, sin
ninguna excepción de cifra.** Cada número que el sitio muestra es trazable e
idéntico (bajo la tolerancia de redondeo) al `idps_largo.parquet`, y por
transitividad al crudo (cadena crudo→parquet ya verificada en censo s11 y
cobertura JSON==parquet en el panel de P-MOTOR).

- **47 anclas** spot-check (encargo §5): **47/47 PASA**.
- **Reconciliación CENSAL** (no muestra): **0 discrepancias** sobre **2.911.828**
  celdas numéricas (ind 366.388 · dim 557.898 · niv 662.514 × bajo/medio/alto).
- **Cifras de comparación** (`dif/sigdif/difgru/sigdifgru`, que el sitio también
  pinta y el generador NO redondea): **0 discrepancias** (byte-idénticas).
- **md5 parquet inicio == fin** (🔒 intocado); **md5 sitio en vivo == build local**.
- Tres familias cubiertas (ind/dim/niv); vacío pandemia 2019-2021 fiel (sin cifra,
  no 0 inventado); RBD ex-duplicado aparece una sola vez con su cifra intacta.

**Hallazgos (NO de cifra):** el panel adversarial encontró dos matices de
**presentación** que *acotan* la afirmación pero **no** la refutan (ninguna cifra
diverge): (1) un establecimiento "fantasma" rbd=null alcanzable por el buscador;
(2) la etiqueta **Dependencia** se pinta del directorio oficial (por diseño H6),
no de `idps_largo.cod_depe2`. Ver §7. Ninguno dispara la regla de detención 2.

---

## 2. Reglas de detención (estado)

| Regla | Condición | Estado |
|---|---|---|
| 1 | md5 parquet ≠ `4c764d8c9f0bf70004f8aa52661ae901` al inicio | **NO disparada** (md5 = esperado) |
| 2 | Una **cifra** del sitio difiere del parquet > TOL | **NO disparada** (0 discrepancias de cifra) |
| 3 | Necesidad de modificar código para verificar | **NO disparada** (todo solo lectura) |

`TOL = 1e-9` sobre la base redondeada a 1 decimal (constante nombrada en los scripts).

---

## 3. Metodología (dos caminos independientes + extensiones)

Cada cifra se contrasta por dos caminos que deben coincidir (patrón auditoría):

- **Camino A (sitio):** decode independiente del `docs/index.html` desplegado.
  Se extrae el único `atob("<base64>")` del HTML, se decodifica base64 →
  inflate zlib (cabecera **`0x78 0x9c`** = stream zlib, no gzip; `memDecompress(type="gzip")`
  en R y `zlib.unzipSync` en node lo auto-detectan, igual que `pako.inflate` en el
  navegador) → `JSON.parse`. La cifra se lee **reimplementando** el filtro del
  cliente (`indOf`/`dimOf`/`nivOf`: filtrar el array columnar por `rbd`+`grado`+`agno`+`id`),
  **sin importar funciones del generador `35` ni del template** (🔒 invariante A21).
- **Camino B (parquet):** `arrow::read_parquet` independiente, filtrado a
  `grado ∈ {4b, 2m}` (universo del motor), `round(prom, 1)` para comparar.

**Independencia reforzada (no exigida, añadida para validación externa):**
- **Decode triple:** Camino A en R (`memDecompress`+`base64enc`); cross-check en
  **node** (`zlib.unzipSync`+`Buffer base64`, ruta que replica literalmente al
  navegador); y re-derivación a ciegas por dos subagentes independientes (R y node).
  Las cuatro lecturas del sitio coinciden cifra a cifra.
- **Censo completo** en lugar de solo anclas (§5).
- **Panel escéptico adversarial** (3 lentes) que intentó *refutar* la fidelidad.

El generador serializa `round(prom,1)` (y niveles) con `jsonlite::toJSON(digits=NA)`;
`dif/sigdif/difgru/sigdifgru` viajan **sin** redondeo. El render del cliente
(`fmt = v=>Number(v).toLocaleString("es-CL",{maximumFractionDigits:1})`, línea 511
del template) es **puramente presentacional** (coma chilena, máx. 1 decimal) sobre
un valor ya redondeado a 1dp: **no altera el valor numérico**.

---

## 4. Anclas usadas y por qué

| # | Ancla | Cubre | Validación de existencia (A24) |
|---|---|---|---|
| 1 | RBD 10, 4b, indicador, 2014 / 2018 / 2024 | familia **ind**; año histórico **entero** (2014); año histórico con **cola decimal** → redondeo (2018); **4b2024** (el que faltaba) | Existe en parquet y en JSON desplegado |
| 2 | RBD 1, 2m, dimension, 2018 + vacío 2019-2021 | familia **dim**; **punto dim-2018** aislado; **vacío** pandemia (sin cifra) | Existe; 2019-2021 = 0 filas en ambos |
| 3 | RBD 75, 4b, indicador, 2015 / 2016 / 2017 | **RBD ex-duplicado** (fix `fefb79a`); cifra real intacta (2016) + NA→null (2017) | **Validado:** RBD 75 SÍ tiene indicador 4b (2015-17). El "año más reciente" es 2017 (todo NA→null = vacío fiel); 2016 aporta el caso de **cifra real intacta** (65/65/70/82) |
| 4 | RBD 10, 4b, niveles, 2024 (sub 111, 122, 211, 222) | familia **niv** (distribución bajo/medio/alto); caso **medio=NA→null** (sub 2 niveles) | Existe; 22 subdimensiones |

**Nota de sustitución (A24):** el encargo daba RBD 75 como ejemplo "a validar". Se
confirmó que **sí pertenece** a los 20 RBD ex-duplicados (reproducción independiente
de la lógica del generador: 20/20 coinciden con el log de P-MOTOR) **y** que tiene
cifra de indicador 4b → **no requirió sustitución**. Su año de indicador más reciente
(2017) es legítimamente todo-NA; se ancló además 2016 para exhibir cifra real intacta.

---

## 5. Tabla ancla × Camino A (sitio) × Camino B (parquet) × veredicto

`prom` redondeado a 1 decimal; `crudo` = valor pleno del parquet (sin redondear).

### Ancla 1 — RBD 10, 4b, indicador
| Año | id | crudo (parquet) | Camino B `round(,1)` | Camino A (sitio) | Veredicto |
|---|---|---|---|---|---|
| 2014 | 1 | 79.0 | 79 | 79 | PASA |
| 2014 | 2 | 73.0 | 73 | 73 | PASA |
| 2014 | 3 | 77.0 | 77 | 77 | PASA |
| 2014 | 4 | 69.0 | 69 | 69 | PASA |
| 2018 | 1 | 78.4574308698 | 78.5 | 78.5 | PASA |
| 2018 | 2 | 84.7141888254 | 84.7 | 84.7 | PASA |
| 2018 | 3 | 88.9683011011 | 89 | 89 | PASA |
| 2018 | 4 | 80.1747724156 | 80.2 | 80.2 | PASA |
| 2024 | 1 | 83.0 | 83 | 83 | PASA |
| 2024 | 2 | 78.0 | 78 | 78 | PASA |
| 2024 | 3 | 87.0 | 87 | 87 | PASA |
| 2024 | 4 | 74.0 | 74 | 74 | PASA |

→ Verifica explícitamente (§4 encargo) el **entero histórico** (2014: 79.0 no se
distorsiona) y la **cola decimal** (2018: 88.9683→89, 78.4574→78.5, etc.).

### Ancla 2 — RBD 1, 2m, dimension, 2018 (11 dimensiones)
| dim | A (sitio) | B (parquet round) | | dim | A | B |
|---|---|---|---|---|---|---|
| 11 | 68.9 | 68.9 ✓ | | 32 | 79.3 | 79.3 ✓ |
| 12 | 78.3 | 78.3 ✓ | | 33 | 76.9 | 76.9 ✓ |
| 21 | 66.6 | 66.6 ✓ | | 41 | 61.5 | 61.5 ✓ |
| 22 | 82.4 | 82.4 ✓ | | 42 | 67.1 | 67.1 ✓ |
| 23 | 72.2 | 72.2 ✓ | | 43 | 66.8 | 66.8 ✓ |
| 31 | 78.2 | 78.2 ✓ | | | | |

**Vacío pandemia** (RBD 1, 2m, dimension): 2019 / 2020 / 2021 → **0 filas en sitio
Y 0 filas en parquet** (vacío fiel, no 0 inventado). PASA.

### Ancla 3 — RBD 75 (ex-duplicado), 4b, indicador
| Año | ind1 | ind2 | ind3 | ind4 | Veredicto |
|---|---|---|---|---|---|
| 2015 | 85 / 85 | NA / null | NA / null | 58 / 58 | PASA |
| 2016 | 65 / 65 | 65 / 65 | 70 / 70 | 82 / 82 | PASA (cifra real intacta) |
| 2017 | NA / null | NA / null | NA / null | NA / null | PASA (vacío fiel) |

(formato `parquet round / sitio`). **RBD 75 aparece exactamente 1 vez** en
`establecimientos` del JSON (nombre "ESCUELA VALLE DE GUANACAGUA") → el dedup
`fefb79a` no duplicó ni alteró su cifra. PASA.

### Ancla 4 — RBD 10, 4b, niveles, 2024 (distribución bajo/medio/alto)
| sub | bajo (A/B) | medio (A/B) | alto (A/B) | Veredicto |
|---|---|---|---|---|
| 111 | 6.3 / 6.3 | 18.8 / 18.8 | 75 / 75 | PASA |
| 122 | 43.8 / 43.8 | null / NA | 56.3 / 56.3 | PASA (medio NA→null) |
| 211 | 25 / 25 | 56.3 / 56.3 | 18.8 / 18.8 | PASA |
| 222 | 18.8 / 18.8 | null / NA | 81.3 / 81.3 | PASA (medio NA→null) |

**Total spot-check: 47 comparaciones, 47 PASA.**

---

## 6. Reconciliación CENSAL (extensión — universo completo, no muestra)

Comparación cifra-a-cifra de **todas** las filas de los arrays del sitio contra
todo el parquet 4b/2m (join por `rbd`+`grado`+`agno`+`id`; `rbd` NA → centinela):

| Familia | Filas sitio | Filas parquet | Claves dup. | No-casadas | **Mismatch** |
|---|---|---|---|---|---|
| indicador (`prom`) | 366.388 | 366.388 | 0 | 0 | **0** |
| dimension (`prom`) | 557.898 | 557.898 | 0 | 0 | **0** |
| niveles (`bajo/medio/alto`) | 662.514 | 662.514 | 0 | 0 | **0** |
| **Cifras de comparación** | | | | | |
| ind `dif/sigdif/difgru/sigdifgru` | 366.388 | 366.388 | — | 0 | **0** |
| dim `dif/sigdif` | 557.898 | 557.898 | — | 0 | **0** |

**Total ≈ 2,9 millones de comparaciones numéricas, 0 discrepancias.** Confirmado
por el panel adversarial de forma independiente (lente redondeo: 2.911.828 celdas,
0 mismatch; además 0 dobles caen en empate `.5` exacto IEEE-754 → `round-half-even`
de R nunca diverge de half-up; roundtrip `round()`+`toJSON(digits=NA)`+base64+inflate
**lossless**, max diff 0).

Conteos coherentes con el log de P-MOTOR (ind/dim/niv 366.388/557.898/662.514;
establecimientos 9137 = 9136 RBD reales + 1 fantasma).

---

## 7. Hallazgos / `# REVISAR` (presentación, NO cifra)

Ninguno es discrepancia de cifra; **no** disparan la regla de detención 2. Se
**documentan, no se corrigen** (corrección = tarea nueva del titular).

### H-FID-1 — Establecimiento "fantasma" rbd=null alcanzable por el buscador
- El parquet trae **4 filas con `rbd = NA`** (4b / indicador / 2017), propiedad
  preexistente del `idps_largo` (no introducida aquí). El generador las colapsa
  en **1** establecimiento (idx 9136), 1 fila roster y 4 filas `ind` con rbd=null.
- **La cifra del fantasma es fiel** parquet→sitio: prom 60.9502→**61.0**, NA→**—**,
  61.7446→**61.7**, 65.6224→**65.6**. No hay violación de cifra.
- **Matiz de presentación:** queda fuera de la navegación territorial
  (cod_reg/com/slep = null nunca matchean), **pero el buscador lo expone**:
  `establecimientos.filter(... || String(e.rbd).includes(ql))` con `ql="null"` lo
  lista como "RBD null" clickeable; al abrirlo, la ficha muestra esas 4 cifras sin
  nombre/comuna/GSE. Es el "1 fantasma" que el log de P-MOTOR ya contabilizaba
  (9136 + 1).
- **Recomendación (titular):** evaluar filtrar `rbd = null` del array
  `establecimientos`/buscador en una futura tarea del generador `35`. Severidad: baja.

### H-FID-2 — Etiqueta **Dependencia** del directorio vigente, no de `idps_largo.cod_depe2`
- Por **diseño H6** (documentado), el generador pinta `cod_depe2` desde el
  **directorio oficial** (homologado 5→4), no desde la columna `cod_depe2` del
  parquet (`35_generar_motor_html.R` líneas 162-170, 242-244: `coalesce(dir, idps)`).
- Verificación independiente: en **192 RBD** la etiqueta difiere por
  **reclasificación genuina** (parquet 1=Municipal/2=P.subv → sitio 4=SLEP: 181×(1→4),
  9×(2→4), 2×(2→3)); en **323 RBD** adicionales el parquet trae dependencia NA
  (RBD solo-históricos) y el directorio la **rellena** (no es divergencia, es coalesce).
  Total 515 RBD donde la etiqueta pintada ≠ columna homónima del parquet.
- Es **etiqueta/filtro, NO cifra IDPS** (ninguna cifra cambia). Ya está en la lista
  pendiente-titular de `CLAUDE.md` ("EE SLEP-por-traspaso marcados Municipal,
  desfase de vigencia"). Se ancla aquí para que la validación externa **no lo lea
  como discrepancia de cifra**. Severidad: media (decisión de etiqueta, pendiente titular).

---

## 8. md5 inicio / fin

| Artefacto | md5 | Estado |
|---|---|---|
| `40_salidas/intermedios/idps_largo.parquet` (inicio) | `4c764d8c9f0bf70004f8aa52661ae901` | == esperado |
| `40_salidas/intermedios/idps_largo.parquet` (fin) | `4c764d8c9f0bf70004f8aa52661ae901` | **== inicio (🔒 intocado)** |
| `docs/index.html` (build local) | `7481159532c07ee7b4f3c2910f2e6976` | == `40_salidas/motor_idps.html` |
| Sitio en vivo `https://tomgc.github.io/slep_idps/` | `7481159532c07ee7b4f3c2910f2e6976` | **== build local** |

---

## 9. Notas para el revisor

- **Camino A sin reusar `35`:** el lector se reimplementó (filtro columnar por
  rbd+grado+agno+id); el "índice de rangos por rbd" del cliente es solo
  optimización — filtrar el array completo da el mismo resultado. Independencia A21 OK.
- **Formato del stream:** la cabecera es **zlib `0x78 0x9c`**, no gzip `0x1f8b`.
  `pako.inflate` (navegador), `memDecompress(type="gzip")` (R) y `zlib.unzipSync`
  (node) lo auto-detectan; `node:zlib.gunzipSync` (estricto gzip) **falla** —
  usar `unzipSync`. Anotado para futuras verificaciones.
- **Render = `toLocaleString("es-CL", {maximumFractionDigits:1})`**: la cifra
  pintada es el mismo valor de `prom` (formato chileno, coma decimal), sin
  re-redondeo material sobre un valor ya a 1dp. La trazabilidad llega al píxel.
- **Brief del encargo (corrección menor de redacción):** el JSON expone los arrays
  en el **top-level** (`obj.ind`, `obj.dim`, `obj.niv`, `obj.establecimientos`),
  **sin** wrapper `DATA`. El §4 del encargo escribe `DATA.ind`; un re-derivador a
  ciegas tropezó un intento. Sugerencia: actualizar el encargo a `obj.*`.
- **`establecimientos` = 9137** (no 8353 del CLAUDE.md): coherente con la carga
  histórica extendida 2014-2025 (sesiones 10/12), no una discrepancia.
- **Columnas no pintadas:** `niv_mbajo_por/niv_mmedio_por/niv_malto_por` y
  `mdif/mdifgru` del parquet **no** viajan al sitio (el generador no las usa); no
  hay cifra que verificar para ellas.

---

## 10. Cierre

- Verificación **SOLO LECTURA**: parquet, generador, template y `docs/` intactos
  (git limpio en esos paths antes y después; md5 parquet inicio == fin).
- Scripts efímeros en `/tmp` (no versionados), borrados al cierre.
- **El motor queda certificado para validación técnica externa**: parquet→sitio
  fiel a 1 decimal (0 discrepancias de cifra en el universo completo), y por
  transitividad crudo→sitio. Los dos hallazgos de §7 son de presentación (no de
  cifra) y quedan registrados para decisión del titular.
