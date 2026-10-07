# Encargo autónomo — Integración del histórico IDPS 2014-2019 al pipeline (P5, fase 3)

> **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, Rama A
> pública). **Fase:** P5, fase 3 de 3 (INTEGRACIÓN al pipeline). Las fases 1 (censo)
> y 2 (organización) están cerradas y aprobadas. **Modelo recomendado:** Opus.
>
> **Qué cambia respecto a las fases previas.** Las fases 1 y 2 fueron read-only / de
> filesystem. **Esta fase modifica código del pipeline por primera vez en P5**:
> extiende `30_procesamiento/34_leer_normalizar_idps.R` para leer el histórico ancho
> 2014-2019 desde `20_insumos/historico/`, homologarlo al esquema canónico largo, y
> fundirlo en el mismo `idps_largo.parquet`. Por eso el invariante central ya no es
> "no tocar nada" sino **"no alterar ni una fila del dato moderno 2022-2025 ya
> validado"**, verificado bit-a-bit.
>
> **Arquitectura elegida (decisión del titular):** opción (a) — fundir en `34` con
> una rama de lectura histórica, un solo `idps_largo.parquet`, con verificación
> bit-a-bit del dato moderno + DRY_RUN antes de sobrescribir.
>
> **Patrón:** encargo autónomo dirigido por meta
> (`herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md`).

---

## 0. Principio rector y resultado esperado

Extender `34` para que el `idps_largo.parquet` pase de cubrir **2022-2025** a cubrir
**2014→2025** (con el hueco pandemia 2020-2021 ausente, esperado), sumando el nivel
indicador para todo el histórico y el nivel dimensión para 2018. **Sin alterar ni un
valor del dato moderno**: las filas 2022-2025 del parquet nuevo deben ser
bit-a-bit idénticas a las del parquet actual.

**Lo que el histórico aporta al parquet** (del censo, fase 1):
- **Indicador** para 2014-2019 (todos los grados disponibles, formato ancho
  `ind_*` → pivotar a largo).
- **Dimensión** para 2018 (columnas `dim_*_rbd` → pivotar a largo).
- **NADA de:** significancia (`dif`/`sigdif`/`difgru`/`sigdifgru`/`mdif`/`mdifgru`
  — el histórico no la trae, quedan NA), subdimensión/niveles (no existe antes de
  2023, queda NA), `id_subdimension` (NA en todo el histórico).

**Conservación (heredada):** el histórico se LEE y se homologa; nada de su dato se
descarta. Donde el histórico no trae una columna, va NA (supresión/ausencia
legítima), nunca un valor inventado.

---

## 1. Encabezado de contrato

### 1.1 Modo y disciplina

- **Modo autónomo, con COMPUERTA DRY_RUN antes de sobrescribir el parquet** (§4).
  Primero se construye el parquet nuevo en un archivo temporal, se verifica
  bit-a-bit contra el actual (dato moderno) y se valida la cobertura histórica; solo
  si todo cuadra se promueve sobre `idps_largo.parquet`. Si no cuadra, se conserva
  el actual y se reporta.
- Esta fase **modifica `34`** y **corre el pipeline** (`run_all(only = 34)` o
  equivalente) para regenerar el parquet. NO toca el motor (`35`), ni `33`, ni `32`,
  ni `31`, ni el `10_configuracion.R` (los crosswalks ya tienen lo necesario, ver
  §2.3). NO republica `docs/`.

### 1.2 Regla de detención

Detente y reporta SOLO si:

1. **(a)** La verificación bit-a-bit falla: alguna fila 2022-2025 del parquet nuevo
   difiere del actual. NO promuevas el parquet nuevo. Esto significa que la rama
   histórica contaminó el dato moderno: hay un bug que corregir.
2. **(b)** Un sufijo de indicador o dimensión del histórico NO está en el crosswalk
   (`CW_INDICADOR`/`CW_DIMENSION`). El código ya aborta solo (`map_codigo` hace
   `stop`); repórtalo como hallazgo (esto contradiría el análisis previo, que
   verificó que los 8 sufijos `ind_*` y los 11 `dim_*` calzan; si pasa, es nuevo).
3. **(c)** Una validación del Bloque 6 de `34` falla sobre el histórico (dominio de
   id, coherencia de jerarquía, duplicados de llave). Diagnostica la causa; no
   relajes la validación para que pase.
4. **(d)** Un `.xls` histórico no se puede leer.

Fuera de eso, avanza con autonomía: nombres de helpers, estructura del código,
orden de operaciones, los decides tú.

### 1.3 Reglas canónicas heredadas

- **Rutas absolutas** desde `/Users/tomgc/Projects/slep_idps`. No asumas `cd`.
- **R-only**, stack del proyecto. Pipe nativo `|>`, `.by=` en dplyr ≥ 1.1,
  `here::here()`.
- **Llaves `character`:** `rbd`, `cod_*`, `grado`, `agno` siempre character (el
  parquet actual lo es; el histórico debe entrar igual).
- **Estilo de `34`:** respeta su estructura de bloques, sus helpers (`to_num`,
  `col_o_na`, `map_codigo`, `homologar_id`, `limpiar_marca`), sus comentarios en
  español, su patrón de validación con `stopifnot`. La rama histórica debe leerse
  como parte natural del archivo, no como un parche pegado.
- **Commits atómicos temáticos.** Nunca `git add .`/`-u`.

---

## 2. Contexto: cómo está construido `34` hoy y dónde encaja el histórico

### 2.1 Arquitectura actual de `34` (leer el archivo completo antes de tocar)

`34_leer_normalizar_idps.R` hoy:

1. **Bloque 1 — Manifiesto:** `fs::dir_ls(here::here("20_insumos"), glob="*.xlsx")`
   (NO recursivo, solo `.xlsx`, excluye `GLOSAS`), parsea nombre con
   `PATRON_DATOS = "^idps(2m|4b|6b|8b)(\\d{4})_(.+)_(final|preliminar)$"`, clasifica
   familia (`rbd`/`rbd_dim`/`niveles`) por substring del fragmento.
2. **Bloque 2 — Helpers:** `to_num`, `col_o_na` (columna→coerción / ausente→NA del
   tipo correcto), `map_codigo` (texto→id, **aborta si el código no está en el
   crosswalk**), `homologar_id` (usa id numérico si está, si no mapea texto).
3. **Bloque 3 — `leer_un_archivo`:** lee un xlsx (asume formato LARGO: una fila por
   rbd×nivel), homologa ids con los crosswalks, construye el esquema canónico
   `COLS_CANONICAS` (30 columnas), proyectando NA donde la columna no existe.
4. **Bloque 4 — Iterar:** `purrr::pmap` sobre el manifiesto, `bind_rows`.
5. **Bloque 5 — Atributos canónicos:** sobrescribe `cod_depe2`/geo con el del
   registro **más reciente** de la familia indicador por RBD (resuelve
   inconsistencias de dependencia); GSE por `(rbd, agno, grado)`.
6. **Bloque 6 — Validaciones:** dominio de `id_indicador ∈ 1:4`, `cod_grupo ∈
   {1..5,NA}`, `cod_depe2 ∈ {1..4,NA}`; coherencia jerárquica
   (`id_dimension %/% 10 == id_indicador`, etc.); duplicados de llave.
7. **Bloque 7 — Escritura atómica** (write tmp → move).
8. **Bloque 8 — Resumen** de cobertura grado×año×familia.

**El supuesto que el histórico rompe:** Bloque 3 asume formato **largo** (la Agencia
moderna publica `ind`+`prom` por filas). El histórico es **ancho** (`ind_*`/`dim_*`
como columnas, una fila por RBD). Esa es la única diferencia estructural de fondo;
todo lo demás del histórico encaja en los mecanismos existentes.

### 2.2 Lo que el censo (fase 1) estableció sobre el histórico — los cuatro esquemas

Material en `20_insumos/historico/` (datos) y `20_insumos/historico/glosas/`. Cuatro
esquemas estructurales (confirmados, fase 1):

- **Mínimo 2014-2016** (`.xls`, hoja `Sheet1`): `rbd, agno, grado, ind_am, ind_cc,
  ind_pf, ind_hv`. Solo indicador, sin sufijo. SIN geo, SIN GSE (`cod_grupo`), SIN
  `cod_depe2`.
- **Enriquecido-texto 2017** (`.xlsx`, `Sheet1`): `agno, grado, rbd, nom_rbd, geo…,
  cod_depe2, cod_grupo, cod_rural_rbd, ind_am, ind_cc, ind_hv, ind_pf`. Indicador
  sin sufijo. **`cod_depe2`/`cod_grupo`/`cod_rural_rbd` vienen en TEXTO** (`Municipal`,
  `Medio bajo`, `Urbano`), no numérico.
- **2018-con-dimensión** (`.xlsx`): 29 columnas. Indicador con sufijo `_rbd`
  (`ind_am_rbd`…) Y 11 columnas de dimensión `dim_*_rbd`. Geo con nombres distintos
  (`nom_regi_n`, `nom_provincia`, `nom_comuna`, `cod_deprov`). `cod_depe2`/`cod_grupo`
  numéricos. **SIN columna `agno`** (derivar del nombre).
- **Enriquecido-numérico 2019** (`.xlsx`, `idps19_rbd` → ya renombrado a
  `idps8b2019_rbd_historico.xlsx`): ~18 columnas, indicador sin sufijo, `cod_depe2`
  numérico {1,2,3}.

**Nomenclatura ya normalizada (fase 2):** todos los archivos históricos están en
`20_insumos/historico/` como `idps{grado}{AAAA}_rbd_historico.{xls,xlsx}`. El grado y
el año salen del nombre (igual que en el moderno). Cobertura: 2014 (2m,4b,6b,8b),
2015 (2m,4b,6b,8b), 2016 (2m,4b,6b), 2017 (2m,4b,8b), 2018 (2m,4b,6b), 2019 (8b).

### 2.3 D1 resuelto: el mapeo de sufijos ya está en el crosswalk (NO inventar)

**Verificado por el análisis previo contra `10_configuracion.R`:**

- **Indicador:** los sufijos `ind_{xx}` del histórico (`am, cc, pf, hv`, con o sin
  `_rbd`) → tomar el par `xx`, mayúscula, mapear con **`CW_INDICADOR`**
  (`AM=1, CC=2, PF=3, HV=4`). Los 8 sufijos calzan.
- **Dimensión 2018:** las columnas `dim_{ind}_{dim}_rbd` → tomar el **par medio**
  (`dim`), mayúscula, mapear con **`CW_DIMENSION`** (`AA=11, ME=12, AR=21, AO=22,
  AS=23, PA=31, VD=32, SP=33, VA=41, HA=42, AC=43`). Los 11 sufijos calzan, y los 11
  pasan la regla de coherencia `id_dimension %/% 10 == id_indicador` del Bloque 6.1.

`CW_DIMENSION` fue construido leyendo las glosas oficiales 2024/2025 cruzadas por
label (lo dice su provenance en el config). **Por eso el mapeo de dimensión 2018 NO
es inferencia por nombre: es el crosswalk canónico ya validado contra glosa moderna**
— que es exactamente la condición que el titular puso para D1. La salvaguarda contra
inventar metodología ya existe: `map_codigo` aborta si un sufijo no calza. El encargo
NO debe construir un mapeo nuevo; debe REUSAR `CW_INDICADOR`/`CW_DIMENSION` y dejar
que aborten si algo no calza.

**Sufijo de indicador en 2018:** el primer par de `dim_{ind}_{dim}` es redundante (el
indicador sale de la decena de `id_dimension`). Para el indicador 2018 usar las
columnas `ind_{xx}_rbd`, no el primer par del sufijo de dimensión.

### 2.4 Decisiones de homologación del histórico (D2-D7, cómo resolverlas)

Todas mecánicas, resueltas por el pipeline o por normalización; ninguna es decisión
nueva del titular (ya las aprobó):

- **D2 — `cod_depe2`/`cod_grupo`/`cod_rural_rbd` en TEXTO en 2017:** convertir texto→
  código antes de homologar. `cod_grupo`: `Bajo=1, Medio bajo=2, Medio=3, Medio
  alto=4, Alto=5` (inverso de `GSE_LABELS` del config). `cod_depe2`: `Municipal=1,
  Particular subvencionado=2, Particular pagado=3` (inverso de `DEPENDENCIAS`, sin
  el 4=SLEP que no aparece en 2017). **Sin embargo**, recuerda que el Bloque 5
  SOBRESCRIBE `cod_depe2`/geo con el canónico del año más reciente: el `cod_depe2`
  histórico (texto o numérico) es efímero, solo se usa si ese RBD no tiene registro
  moderno. Conviértelo igual (para los RBD que solo existen en el histórico), pero su
  efecto es marginal. El `cod_grupo` SÍ importa por año (no se sobrescribe), así que
  su conversión texto→código en 2017 es necesaria.
- **D3 — `agno` ausente en 2018:** derivar del nombre (el código ya hace
  `agno = as.integer(anio)` donde `anio` viene del nombre; el histórico 2018 cae
  naturalmente en eso).
- **D4 — geo con nombres distintos en 2018** (`nom_regi_n`, `nom_provincia`,
  `nom_comuna`, `cod_deprov`): mapear a las columnas canónicas (`nom_reg_rbd`,
  `cod_pro_rbd`, `nom_com_rbd`, etc.) al leer 2018. Igual que `cod_depe2`, la geo se
  sobrescribe en el Bloque 5 con la del registro moderno más reciente, así que para
  los RBD que existen en el moderno esto es efímero; para los que solo existen en el
  histórico, conserva la geo histórica.
- **D5 — `cod_depe2`=4 en 2m_2018:** irrelevante (se sobrescribe en Bloque 5). El
  dominio `cod_depe2 ∈ {1..4,NA}` del Bloque 6.2 lo tolera (4 es válido).
- **D6 — migración texto↔id moderna:** ya resuelta en `34` (no la toques).
- **D7 — subdimensión solo desde 2023:** el histórico no trae subdimensión; queda
  NA. Correcto, no hay nada que hacer.

### 2.5 Los `.xls` legacy 2014-2016

`readxl::read_excel` los lee directamente (detecta `.xls` vs `.xlsx`). **NO los
conviertas a `.xlsx`** (transformación innecesaria de dato; el formato original se
conserva, conservación). Solo léelos. Verifica que `read_excel` maneja la hoja
`Sheet1` (el moderno usa hojas con otro nombre, pero `read_excel` toma la primera
hoja por defecto, que es la correcta).

---

## 3. Invariantes (🔒)

- 🔒 **EL DATO MODERNO 2022-2025 NO CAMBIA.** Verificación bit-a-bit obligatoria: las
  filas con `agno ∈ 2022:2025` del parquet nuevo deben ser idénticas (todas las
  columnas, todos los valores) a las del parquet actual. Si difieren, NO se
  sobrescribe; es un bug (detención a). Esta es la garantía que justifica la
  arquitectura fundida.
- 🔒 **Conservación.** Donde el histórico no trae una columna, va NA (significancia,
  subdimensión, niveles, y geo/GSE en 2014-2016). Nunca un valor inventado, nunca un
  cero por NA.
- 🔒 **Lee, no deriva.** Los `prom` históricos (indicador y dimensión) se LEEN tal
  cual del ancho y se pivotan; no se calcula `prom` de dimensión a partir del
  indicador ni viceversa. No se deriva significancia (no existe en el histórico).
- 🔒 **Llaves `character`.** El histórico entra con `rbd`/`cod_*`/`grado`/`agno`
  character, consistente con el parquet actual (un `bind_rows` con tipos mezclados
  rompe en silencio).
- 🔒 **DRY_RUN antes de sobrescribir.** El parquet nuevo se construye en temporal, se
  verifica (bit-a-bit moderno + cobertura histórica), y solo entonces se promueve.
- 🔒 **El mapeo de sufijos REUSA los crosswalks** `CW_INDICADOR`/`CW_DIMENSION`; no se
  construye un mapeo histórico nuevo. Si un sufijo no calza, `map_codigo` aborta
  (detención b); no se relaja.
- 🔒 **Solo se toca `34`.** No `33`, no `35`, no `10_configuracion.R`, no el motor.
  No republicar `docs/`.
- 🔒 **Respaldo del parquet actual** antes de sobrescribir: copia
  `40_salidas/intermedios/idps_largo.parquet` a
  `_archivo/YYYYMMDD/idps_largo_pre_historico.parquet` (gitignored). md5 actual a
  preservar como referencia: `50d9de4f1fc80259d29f499cdf46d9e1`.

---

## 4. Fases en orden estricto

### Fase A — Lectura del código y respaldo

1. Lee `34_leer_normalizar_idps.R` COMPLETO, `10_configuracion.R` (crosswalks) y la
   cabecera de `00_build.R` (cómo se invoca `run_all`). No toques nada aún.
2. Respalda el parquet actual a `_archivo/YYYYMMDD/idps_largo_pre_historico.parquet`
   y anota su md5 (`50d9de4f…`). Carga el parquet actual en memoria como **verdad de
   referencia del dato moderno** (lo usará la verificación bit-a-bit).
3. Lista `20_insumos/historico/` y `historico/glosas/`; confirma los 18 datos y su
   nomenclatura `idps{g}{AAAA}_rbd_historico.{xls,xlsx}`.

### Fase B — Diseño e implementación de la rama histórica en `34`

Modifica `34` para incorporar el histórico. Decisiones de diseño (tuyas, respetando
la estructura del archivo):

1. **Manifiesto (Bloque 1):** suma los archivos de `20_insumos/historico/` al
   manifiesto, marcándolos con un discriminador (p. ej. `regimen = "historico"` vs
   `"moderno"`), y parsea su grado/año del nombre `idps{g}{AAAA}_rbd_historico`. El
   manifiesto moderno sigue leyendo la raíz exactamente como hoy (no cambies su
   `dir_ls` ni su `PATRON_DATOS`; agrega un segundo `dir_ls` para `historico/` con su
   propio patrón). Los `.xls` entran al manifiesto histórico.
2. **Lector histórico (Bloque 3):** una función nueva — `leer_un_archivo_historico`
   o una rama dentro de `leer_un_archivo` — que:
   - Lee el ancho (`.xls`/`.xlsx`, primera hoja).
   - **Pivota indicador a largo:** las columnas `ind_{xx}` (con o sin `_rbd`) →
     filas, una por indicador, con `id_indicador = CW_INDICADOR[toupper(xx)]` y
     `prom = valor`, `familia = "indicador"`, `id_dimension = NA`,
     `id_subdimension = NA`.
   - **Pivota dimensión a largo (solo 2018):** las columnas `dim_{ind}_{dim}_rbd` →
     filas, una por dimensión, con `id_dimension = CW_DIMENSION[toupper(dim_medio)]`,
     `id_indicador = id_dimension %/% 10`, `prom = valor`, `familia = "dimension"`,
     `id_subdimension = NA`.
   - **Convierte texto→código** donde aplique (2017: `cod_grupo`, `cod_depe2`,
     `cod_rural_rbd`).
   - **Mapea geo divergente** (2018: `nom_regi_n`→`nom_reg_rbd` vía `NOMBRES_REGION`
     por código, etc.) a las columnas canónicas.
   - Proyecta el resto del esquema canónico con NA vía `col_o_na` (significancia,
     niveles, subdimensión: todas NA en el histórico).
   - Emite exactamente `COLS_CANONICAS`, mismo orden, mismos tipos que el moderno.
   - **Reusa `map_codigo`** para que aborte si un sufijo no calza (no construyas un
     mapeo paralelo).
3. **Iteración (Bloque 4):** el histórico se lee con su lector y se une al moderno
   con `bind_rows`. El resultado debe ser un único `datos` con régimen moderno +
   histórico.
4. **Bloque 5 (atributos canónicos):** revisa con cuidado. El Bloque 5 toma
   `cod_depe2`/geo del registro **más reciente de la familia indicador**. Con el
   histórico, "más reciente" sigue siendo 2025 (el histórico es más viejo), así que
   los RBD que existen en el moderno conservan su atributo moderno (correcto). Los
   RBD que SOLO existen en el histórico (cerrados antes de 2022) tomarán su atributo
   del año histórico más reciente en que aparecen. **Verifica que esto no rompe el
   join** (el `stopifnot` de filas constantes) y que el GSE histórico por
   `(rbd, agno, grado)` entra bien. Punto de atención: 2014-2016 no tiene GSE; esos
   `(rbd, agno, grado)` tendrán `cod_grupo = NA` (supresión legítima, el motor ya
   tolera GSE NA).
5. **Bloque 6 (validaciones):** deben pasar sobre el histórico SIN relajarse:
   - `id_indicador ∈ 1:4` (el pivoteo garantiza 1-4).
   - `cod_depe2 ∈ {1..4,NA}` (histórico: 1-3, o 4 en 2m_2018, o NA en 2014-2016 —
     todos válidos).
   - `cod_grupo ∈ {1..5,NA}` (histórico 2017-2019: 1-5; 2014-2016: NA).
   - coherencia jerárquica de `id_dimension` (los 11 sufijos 2018 ya verificados
     coherentes).
   - duplicados de llave `(familia, rbd, agno, grado, ids)`: el histórico no debería
     duplicar (una fila por rbd×indicador, una por rbd×dimensión). Si duplica,
     diagnostica.
   Si alguna validación falla, es detención (c): diagnostica, no relajes.

### Fase C — Regeneración del parquet con DRY_RUN y verificación bit-a-bit

1. **Corre `34`** (vía `run_all(only = 34)` o `source` directo) escribiendo a un
   **parquet temporal**, NO sobre `idps_largo.parquet` todavía. (Si `34` escribe
   directo al final, ajusta para que en modo DRY_RUN escriba a
   `idps_largo_nuevo.parquet` temporal.)
2. **Verificación bit-a-bit del dato moderno (🔒, la compuerta crítica):**
   - Filtra el parquet nuevo a `agno ∈ 2022:2025` y el parquet actual (referencia)
     completo.
   - Ordena ambos por la llave completa y compara **todas las columnas, todos los
     valores**. Deben ser idénticos: mismo número de filas, mismos valores, mismos
     NA. Reporta el resultado (filas comparadas, diferencias = 0).
   - Si hay UNA diferencia, **detención (a)**: no promuevas; reporta qué fila/columna
     difiere (es un bug de la rama histórica que tocó el moderno).
3. **Validación de la cobertura histórica:**
   - El parquet nuevo debe tener filas con `agno ∈ 2014:2019`. Reporta la matriz
     grado×año×familia del histórico (indicador para 2014-2019; dimensión solo 2018).
   - Confirma: sin filas 2020-2021 (hueco esperado); 2018 con familia dimensión;
     2014-2016 con `cod_grupo` NA; significancia NA en todo el histórico;
     subdimensión NA en todo el histórico.
   - Cuenta de filas nuevas (histórico) y total.
4. **Promoción (solo si 2 y 3 cuadran):** mueve el parquet temporal sobre
   `idps_largo.parquet` (escritura atómica). Si no cuadran, conserva el actual.

### Fase D — Validación end-to-end (la que el titular pidió diferir a esta fase)

El titular decidió que la fase 3 valida todo junto (incluido el 4b2024 promovido en
la fase 2). Por tanto:

1. **Corre el pipeline relevante** para confirmar que `34` produce el parquet
   completo sin error y que aguas arriba (`33` catálogos) sigue coherente. NO corras
   `35` (motor) salvo que sea trivial; el foco es el parquet.
2. **Confirma el 4b2024:** el parquet nuevo debe contener `agno=2024, grado=4b`
   (el activo promovido en fase 2, que `34` ahora ingiere de la raíz). Repórtalo.
3. **Resumen de cobertura final** grado×año×familia del parquet completo 2014→2025.

---

## 5. Criterios de éxito verificables (B.4)

1. **`34` modificado** lee el histórico de `20_insumos/historico/` y lo funde en
   `idps_largo.parquet`, conservando intacta la lectura moderna de la raíz.
2. **Verificación bit-a-bit:** las filas 2022-2025 del parquet nuevo son idénticas a
   las del parquet actual (0 diferencias). Reportado con número de filas comparadas.
3. **Cobertura histórica presente:** el parquet tiene indicador 2014-2019 y dimensión
   2018; sin 2020-2021; significancia/subdimensión/niveles NA en el histórico;
   `cod_grupo` NA en 2014-2016. Matriz grado×año×familia reportada.
4. **4b2024 presente** en el parquet (validación cruzada con fase 2).
5. **Todas las validaciones del Bloque 6 pasan** sin relajarse, sobre moderno +
   histórico.
6. **Respaldo** del parquet pre-histórico en `_archivo/`. md5 del parquet nuevo
   reportado (será distinto del `50d9de4f…` actual — ahora tiene histórico; eso es
   esperado y correcto).
7. **`git status`/`diff`:** solo `34_leer_normalizar_idps.R` modificado y el parquet
   regenerado (Rama A, se versiona). El respaldo `_archivo/` no se versiona.

---

## 6. Mandato de auto-auditoría (panel adversarial)

Fase de máximo riesgo de datos (modifica el pipeline y regenera el parquet). Panel
adversarial de SOLO LECTURA con código independiente, antes de reportar "hecho":

1. **No-alteración del dato moderno (la verificación central, re-derivada
   independientemente):** un agente que reabre el respaldo
   `idps_largo_pre_historico.parquet` y el parquet nuevo, filtra el nuevo a
   2022-2025, y confirma con su propio código que son bit-a-bit idénticos (todas las
   columnas). Que reporte hash por partición de año o comparación fila-a-fila. Este
   agente NO confía en la verificación de la Fase C; la rehace.
2. **Integridad del histórico:** un agente que confirma, con código propio, que el
   histórico entró correcto: para una muestra de RBD de 2014, 2017, 2018 y 2019,
   que el `prom` del parquet coincide con el valor del xlsx ancho original (lee el
   xlsx, ubica el RBD, compara el indicador); y que la dimensión 2018 de un RBD
   coincide con su columna `dim_*_rbd` original. Esto verifica que el pivoteo no
   barajó valores.
3. **Mapeo de ids correcto:** un agente que confirma que los `id_indicador`/
   `id_dimension` del histórico corresponden a los sufijos originales vía
   `CW_INDICADOR`/`CW_DIMENSION` (p. ej. que `dim_cc_as_rbd` quedó como
   `id_dimension=23`, no otro), y que la coherencia `id_dimension %/% 10 ==
   id_indicador` se cumple en todo el histórico.
4. **Cobertura y huecos:** un agente que confirma la matriz grado×año×familia: sin
   2020-2021, dimensión solo en 2018, subdimensión/niveles/significancia NA en
   2014-2019, GSE NA en 2014-2016.

Si el panel detecta discrepancia, **restaura el parquet desde el respaldo**, corrige
el código, y vuelve a correr. Documenta en el log qué auditó el panel.

---

## 7. Mandato del log y estado de cierre

1. **Log** en
   `50_documentacion/andamios/logs/YYYYMMDD_integracion_historico_idps_log.md`
   (plantilla del protocolo: resumen, commits, cambios en `34` con el porqué, DRY_RUN
   vs real, verificación bit-a-bit con evidencia, auditoría con veredicto,
   invariantes 🔒 con PASA/FALLA, decisiones, pendientes, md5 del parquet
   anterior→nuevo, cobertura final, notas para el revisor). Honesto: incluye lo que
   costó y cualquier ajuste al Bloque 5/6 que el histórico haya exigido.
2. **Commits atómicos:**
   - `feat(34): leer e integrar histórico IDPS 2014-2019 (indicador + dim 2018) (P5 fase 3)`
     — `30_procesamiento/34_leer_normalizar_idps.R`.
   - `data(idps): regenerar idps_largo con serie 2014-2025 (P5 fase 3)`
     — `40_salidas/intermedios/idps_largo.parquet` (Rama A, se versiona).
   - `docs(idps): log de integración del histórico IDPS (P5 fase 3)` — el log.
   - **NO** `git add .`/`-u`. Por ruta. El respaldo `_archivo/` y cualquier script de
     verificación efímero no se versionan.
   - **NO** push. El titular revisa, valida (puede correr `35` y ver el motor), y
     decide el push y el cierre de sesión.

---

## 8. Reporte final (qué vuelve al chat)

1. **Cambios en `34`:** qué bloques se tocaron y cómo encajó la rama histórica
   (manifiesto + lector histórico + ajustes a Bloque 5/6 si hubo).
2. **Verificación bit-a-bit:** filas 2022-2025 comparadas, diferencias (debe ser 0).
3. **Cobertura del parquet nuevo:** matriz grado×año×familia 2014→2025, con el hueco
   2020-2021, la dimensión 2018, y el 4b2024.
4. **Filas:** total anterior vs nuevo, cuántas aporta el histórico.
5. **Veredicto del panel adversarial:** qué auditó (las 4 dimensiones), qué encontró.
   Especialmente el resultado del agente de no-alteración del dato moderno.
6. **Invariantes:** md5 parquet anterior (`50d9de4f…`) → nuevo (distinto, esperado);
   respaldo en `_archivo/`; validaciones del Bloque 6 todas PASA; `git status`.
7. **Rutas** del log y del respaldo; los commits con hashes.
8. **Cierre de P5:** con esta fase, P5 (carga histórica) queda funcionalmente
   completa: el parquet cubre 2014→2025. Señala qué quedaría para una sesión futura
   (p. ej. que el motor `35` muestre la serie histórica extendida en la vista de la
   ficha — eso es trabajo de motor, no de pipeline, y el titular decide si va en esta
   sesión o en otra). NO inicies ese trabajo de motor; detente en el reporte.

---

## 9. Recordatorio de reparto (dual-Claude)

Tú (Claude Code) ejecutas: lectura del código, modificación de `34`, regeneración del
parquet con DRY_RUN, verificación bit-a-bit, panel adversarial, commits, log. **NO**
modificas el motor `35` ni el `10_configuracion.R` (los crosswalks ya bastan), **NO**
republicas `docs/`, **NO** rediseñas la vista histórica del motor, **NO** redactas el
traspaso de cierre. Si el histórico exige una decisión metodológica no prevista, la
REPORTAS como hallazgo; no la resuelves inventando. El invariante que manda: el dato
moderno 2022-2025 no cambia ni un valor, verificado bit-a-bit.
