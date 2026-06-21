# Encargo autónomo — Censo forense del universo IDPS completo (P5, fase 1 rehecha)

> **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, Rama A
> pública). **Fase:** P5, fase 1 (CENSO DE ACTIVOS) — rehecha con encuadre
> corregido. Las fases 2 (organización) y 3 (integración) son posteriores y NO
> forman parte de este encargo. **Modelo recomendado:** Opus.
>
> **Por qué se rehace.** Un diagnóstico previo se encuadró como "confirmar que el
> histórico es indicador-ancho" — una hipótesis que empujó a tratar como ruido a
> uniformar el dato que no encajaba (las columnas de DIMENSIÓN de 2018), al punto
> de casi descartarlo. Ese encuadre era erróneo. Este encargo lo invierte: **no se
> valida una hipótesis, se censa todo lo disponible, en todo nivel de informe, sin
> asumir nada y sin podar nada.** El objetivo es un MAPA DE ACTIVOS: qué dato
> existe realmente, para qué año, qué grado y qué nivel de informe, en todo el
> universo IDPS del proyecto.
>
> **Patrón:** encargo autónomo dirigido por meta
> (`herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md`).

---

## 0. Principio rector (leer primero, gobierna todo el encargo)

**CONSERVACIÓN POR DEFECTO. CERO PODA.** El criterio del proyecto es "lee, no
deriva; carga lo que la fuente publica, al nivel en que lo publica". Este censo
existe para encontrar y catalogar **todo** lo aprovechable, no para decidir qué
dejar fuera. En consecuencia:

- **Ningún dato publicado se declara descartable.** Si un año trae dimensión,
  subdimensión, o cualquier nivel adicional, eso es un ACTIVO que se cataloga como
  disponible, jamás como excedente a podar.
- **Toda asimetría es información, no defecto.** Que un año tenga más niveles que
  otro, o un esquema distinto, es parte del mapa. Se reporta, no se "normaliza
  hacia el mínimo común".
- **No se recomienda descartar nada.** Si detectas una decisión de uso (qué
  ingerir, qué dejar), la marcas como decisión del titular con la evidencia al
  lado; no la resuelves ni sugieres podar.

Este principio es un invariante (§3). Si en algún punto el censo te llevara a
"esto sobra" o "esto se puede ignorar", detente: ese es el error que este encargo
corrige.

---

## 1. Encabezado de contrato

### 1.1 Modo y disciplina

- **Modo autónomo, secuencial: ejecuta TODAS las fases en este turno**, sin pedir
  confirmación entre fases. La ruta ya fue aprobada por el titular.
- Es un encargo de **CENSO PURO, READ-ONLY**. Tu único producto es **un reporte de
  inventario** (más tu log y los artefactos de trabajo). **NO transformas, NO
  mueves, NO renombras, NO conviertes, NO integras, NO descartas nada.**

### 1.2 Regla de detención (cuándo PARAR y reportar)

Detente y reporta SOLO si:

1. **(a)** Un invariante de este encargo te obligaría a violarlo para continuar.
2. **(b)** Un archivo está corrupto/ilegible y no puedes catalogarlo (regístralo
   como "ilegible" y sigue; solo detente del todo si es generalizado).
3. **(c)** Un gate estratégico explícitamente marcado para el titular.

Fuera de eso: **avanza sin preguntar.** Esquemas raros, extensiones mixtas, hojas
faltantes, glosas con etiquetado interno erróneo, codificación en texto vs
numérica, material mal ubicado — todo se CATALOGA y se reporta. Nada de eso
detiene la ejecución ni se "arregla".

### 1.3 Reglas canónicas heredadas

- **Rutas absolutas siempre** desde la raíz `/Users/tomgc/Projects/slep_idps`.
  No asumas `cd` previo.
- **R-only.** Stack: `here`, `fs`, `readxl`, `dplyr`, `stringr`, `purrr`,
  `tibble`, `tidyr`, `arrow`. Pipe nativo `|>`, `.by=` en dplyr ≥ 1.1.
- **`here::here()`** ancla rutas dentro del script; nunca rutas absolutas
  hardcodeadas en el código.
- **Llaves siempre `character`** al leer (`col_types = "text"` donde aplique):
  `rbd`, `cod_*`, `grado`, `agno`, `ind`, `dim`, `sdim`. Un código leído como
  numérico puede perder ceros o cambiar de tipo entre archivos.
- **Commits atómicos.** Nunca `git add .` ni `git add -u`.

---

## 2. Contexto mínimo suficiente

### 2.1 Qué es el producto y por qué este censo

P5 construirá la **serie histórica completa** del motor IDPS: extender la vista
histórica de la ficha de establecimiento hacia atrás hasta donde haya dato. El
motor hoy cubre 2022-2025. El histórico aporta 2014-2019. El producto final es una
serie continua 2014→2025 (con el hueco pandemia 2020-2021). Para decidir qué se
puede construir, se necesita un **mapa exhaustivo de qué dato existe**, en qué
año, qué grado y qué **nivel de informe** — porque el nivel de informe disponible
por año es lo que determina qué se puede mostrar.

### 2.2 Los cuatro niveles de informe IDPS (la dimensión central del censo)

El dato IDPS de la Agencia se publica en hasta cuatro niveles jerárquicos. El
censo debe determinar, **por cada año y grado, cuáles de estos niveles existen**:

1. **Indicador** (4 indicadores macro: Autoestima/motivación `am`, Clima de
   convivencia `cc`, Participación/formación ciudadana `pf`, Hábitos de vida
   saludable `hv`). En el esquema moderno es la familia `rbd` (columnas `ind`,
   `prom`, y significancia `dif`/`sigdif`/`difgru`/`sigdifgru`). En el histórico
   ancho son columnas `ind_am`/`ind_cc`/`ind_pf`/`ind_hv` (con o sin sufijo
   `_rbd`).
2. **Dimensión** (las 11 dimensiones que componen los indicadores). Esquema
   moderno: familia `rbd_dim` (columnas `ind`, `dim`, `prom`). En el histórico
   2018 aparecen como columnas anchas `dim_*_rbd` (p. ej. `dim_am_aa_rbd`).
3. **Subdimensión + niveles de desarrollo** (las 30 subdimensiones, con
   distribución porcentual en niveles Alto/Medio/Bajo). Esquema moderno: familia
   `niveles` (columnas `ind`, `dim`, `sdim`, `niv_*_por`).
4. (Las familias `niveles` también portan la subdimensión; trátalas como un solo
   nivel "subdimensión/niveles" salvo que el dato las separe.)

**Esquema de destino moderno confirmado** (glosa 2024, para que sepas contra qué
mapear cada año histórico):
- familia **indicador** (`idps`): `agno, rbd, ind, prom, dif, sigdif, difgru,
  sigdifgru, nom_rbd, geo…, cod_depe2, cod_grupo, cod_rural_rbd, grado`.
- familia **dimensión** (`dim_idps`): `agno, rbd, ind, dim, prom, …, grado`.
- familia **subdimensión/niveles** (`idps_niveles`): `nivel, agno, rbd, ind, dim,
  sdim, niv_bajo_por, niv_medio_por, niv_alto_por, niv_mbajo_por, niv_mmedio_por,
  niv_malto_por, …, grado`.

### 2.3 Dónde está TODO el universo IDPS (el censo barre los tres)

1. **Insumos actuales (régimen largo 2022-2025), raíz:**
   `/Users/tomgc/Projects/slep_idps/20_insumos/*.xlsx`
   (los `idps{grado}{año}_rbd*.xlsx` directamente en la raíz, NO en subcarpetas).
   Estos son los que `34_leer_normalizar_idps.R` ya consume hoy.
2. **Material depositado para P5 (régimen ancho 2014-2019 + mezcla):**
   `/Users/tomgc/Projects/slep_idps/20_insumos/historico_2014_2018/`
   (recursivo; contiene histórico real, duplicados de 2022/2023, y material de
   2024 mal ubicado).
3. **Glosas auxiliares (diccionarios):**
   `/Users/tomgc/Projects/slep_idps/20_insumos/auxiliares/`
   (las `idps*_GLOSAS*.xlsx`) y las glosas internas de cada carpeta histórica.
   Sirven para resolver qué significa cada código/sufijo, especialmente los
   `dim_*` de 2018.

**No incluir en el censo de DATOS** (pero sí mencionarlos si aparecen): PDFs de
referencia, parquets de `40_salidas/`, el directorio oficial de EE, listados SLEP.
El censo es de **tablas de datos IDPS y sus glosas**.

### 2.4 Lo que un diagnóstico previo ya estableció (verifícalo, NO lo asumas)

Un censo anterior de la carpeta histórica encontró esto. **Confírmalo o refútalo
contra el dato real; las glosas pueden no coincidir con la tabla:**

- La carpeta `historico_2014_2018/` contiene tres grupos: **histórico real
  2014-2019**, **duplicados de 2022/2023** (que ya están en la raíz), y **material
  de 2024 mal ubicado** en subcarpetas `2M/4B/6B/`.
- El histórico 2014-2019 tiene **al menos tres esquemas estructurales**:
  - **2014-2016** (`.xls`, hoja `Sheet1`): mínimo, ~7 columnas `rbd, agno, grado,
    ind_am, ind_cc, ind_pf, ind_hv`. Solo indicador. Sin geo/GSE/dependencia.
  - **2017** (`.xlsx`, `Sheet1`): enriquecido, ~18 columnas. Solo indicador (sin
    sufijo). Geo presente. `cod_depe2`, `cod_grupo`, `cod_rural_rbd` **en TEXTO**
    ("Municipal", "Medio bajo", "Urbano"), no en código numérico.
  - **2018** (`.xlsx`): **29 columnas, el más rico del histórico**. Indicadores
    con sufijo `_rbd` (`ind_am_rbd`…) Y **11 columnas de DIMENSIÓN** `dim_*_rbd`
    (`dim_am_aa_rbd`, `dim_am_me_rbd`, `dim_cc_ao_rbd`, `dim_cc_ar_rbd`,
    `dim_cc_as_rbd`, `dim_hv_ac_rbd`, `dim_hv_ha_rbd`, `dim_hv_va_rbd`,
    `dim_pf_pa_rbd`, `dim_pf_sp_rbd`, `dim_pf_vd_rbd`). Geo con nombres distintos
    (`nom_regi_n`, `nom_provincia`, `nom_comuna`, `cod_deprov`). `cod_depe2`/
    `cod_grupo` numéricos. **Sin columna `agno`.**
  - **2019** (`.xlsx`, `idps19_rbd`): ~18 columnas, enriquecido numérico, solo
    indicador (sin dimensiones).
- **Los 4 indicadores `am/cc/pf/hv` son estables** en todo el rango y coinciden
  con los 4 actuales; escala 0-100.
- **Cobertura por grado irregular:** algunos años no traen los 4 grados.
- **Hueco 2020-2021:** inexistente por pandemia (sin SIMCE). Esperado, NO es
  omisión. NO lo busques.

**Importante sobre 2018:** su dimensión NO es un excedente. La dimensión se usa
hoy en el motor (familia `rbd_dim` de 2022-2025 alimenta la vista histórica
indicador→dimensión). 2018 con dimensión es un ACTIVO que conecta con la serie de
dimensión moderna a través del hueco. Catalógalo como tal.

---

## 3. Invariantes (🔒)

- 🔒 **CONSERVACIÓN POR DEFECTO (§0).** Ningún dato publicado se cataloga como
  descartable ni se recomienda podar. El censo es un mapa de activos.
- 🔒 **READ-ONLY ABSOLUTO.** No muevas, renombres, conviertas, borres ni edites
  NINGÚN archivo bajo `20_insumos/`. No toques `34_leer_normalizar_idps.R`,
  `10_configuracion.R`, ni script alguno de `30_procesamiento/`. No corras
  `00_build.R` ni `run_all()`. No escribas en ningún parquet de `40_salidas/`.
  Tus únicas escrituras permitidas: (1) el reporte de censo en
  `50_documentacion/activa/`, (2) tu log en `andamios/logs/`, (3) artefactos de
  trabajo (script efímero `verificar_*.R` en la raíz, gitignored; opcionalmente un
  parquet de inventario en `40_salidas/intermedios/`).
- 🔒 **El `idps_largo.parquet` actual queda BYTE-IDÉNTICO.** md5 esperado
  (verificar al inicio y al cierre): `50d9de4f1fc80259d29f499cdf46d9e1`. Si cambió,
  algo rompió el read-only: detente y reporta.
- 🔒 **No corregir datos "a ojo".** Glosa que declara hojas que el archivo no trae,
  nombre interno que no calza, código en texto vs numérico, sufijo desconocido:
  se REPORTA tal cual. No se arregla.
- 🔒 **No asumir contenido por el nombre.** Abre cada archivo, lee cada hoja,
  perfila cada columna. El nombre es hipótesis; el contenido es el dato.
- 🔒 **Llaves `character`** al leer (§1.3).

---

## 4. Fases en orden estricto

### Fase A — Estado real y censo de archivos (Paso 0)

1. Verifica y anota el md5 de `40_salidas/intermedios/idps_largo.parquet`
   (control 🔒).
2. Lista, con código propio, **todos** los `.xls`/`.xlsx` de los tres orígenes de
   §2.3 (raíz de `20_insumos/`, `historico_2014_2018/` recursivo, `auxiliares/`).
   Para cada uno: ruta completa, extensión, tamaño. Separa `.DS_Store` y archivos
   de sistema como ruido (cuéntalos pero no los proceses).
3. Clasifica cada archivo por **rol** (dato / glosa) y por **origen** (actual-raíz
   / histórico / auxiliar / duplicado / ajeno-mal-ubicado), con criterio explícito.
   Reporta la correspondencia: ¿qué archivos de la carpeta histórica están
   duplicados en la raíz? (compara por nombre y, si coinciden, por md5: ¿son
   byte-idénticos o solo homónimos?).

### Fase B — Perfilado forense de CADA archivo de datos, hoja por hoja, columna por columna

Para **cada archivo de DATOS** de todos los orígenes (actuales 2022-2025 incluidos:
el censo es del universo completo, no solo del histórico):

1. **Identidad:** ruta, extensión, tamaño, origen, patrón de nombre (descríbelo y
   anota si calza o no el `PATRON_DATOS` actual
   `^idps(2m|4b|6b|8b)(\d{4})_(.+)_(final|preliminar)$`).
2. **Hojas:** todas (`readxl::excel_sheets`); clasifica cada una (datos / glosa /
   índice).
3. **Por cada hoja de datos:**
   - `names(df)` exacto en orden real, nº de columnas, nº de filas.
   - **Determinación del NIVEL DE INFORME** (lo central): ¿esta tabla contiene
     nivel indicador, dimensión, subdimensión/niveles, o varios? Decídelo por las
     columnas presentes:
       - indicador si hay `prom`/`ind` o columnas `ind_*` ancho;
       - dimensión si hay columna `dim` (largo) o columnas `dim_*` ancho;
       - subdimensión/niveles si hay `sdim` y/o `niv_*_por`.
     Reporta explícitamente qué niveles porta cada tabla.
   - **Formato:** ancho (indicadores/dimensiones como columnas, una fila por RBD)
     o largo (`ind`/`dim`/`sdim` como filas). Confírmalo contando filas por RBD.
   - **Perfilado por columna:** tipo, NA (conteo y %), y:
     - **columnas de código** (`rbd`, `agno`, `grado`, `ind`, `dim`, `sdim`,
       `cod_*`): volcado COMPLETO de valores únicos; para alta cardinalidad
       (`rbd`, `cod_com_rbd`) reporta conteo de únicos + rango + muestra de 30.
       Anota si el código viene en TEXTO o NUMÉRICO (clave: 2017 viene en texto).
     - **columnas de medida** (`prom`, `ind_*`, `dim_*`, `niv_*_por`): mín, máx,
       media, mediana, nº NA, y verifica rango esperado (0-100 para puntajes y
       porcentajes). Reporta cualquier valor fuera de rango.
     - **columnas de texto** (`nom_*`): NA, 5 ejemplos; no vuelques miles de
       nombres.
   - **Cruces dentro de la tabla:** ¿`agno` del dato == año del nombre? (reporta
     desfases; el pipeline deriva año del NOMBRE). ¿`grado` del dato consistente?
     (puede venir "2" vs "2m"). ¿`rbd` duplicado? (en ancho debería ser único por
     RBD; en largo no). 
4. **Por cada glosa:** lo que el `Índice` declara (grado→hoja); por hoja, el
   `Nombre archivo` interno, nº de variables/observaciones declarados, lista
   completa de variables (Nombre/Descripción/Valores/Tipo), y **las tablas de
   codificación** (Dependencia, GSE, Ruralidad, y cualquier tabla de Indicador/
   Dimensión/Subdimensión que mapee códigos a nombres). **Contraste declarado vs
   real:** ¿hojas del índice == hojas del archivo? ¿`Nombre archivo` interno calza
   con el grado de la hoja? Reporta cada discrepancia sin corregirla.
5. **Atención especial a los `dim_*` de 2018:** extrae de la glosa 2018 (y de
   cualquier glosa que los defina) qué dimensión nombra cada sufijo
   (`dim_am_aa`, `dim_am_me`, `dim_cc_ao`, …). Esto es insumo para que la fase 3
   pueda mapear sufijo→`id_dimension`. **No inventes el mapeo**; reporta lo que la
   glosa dice y, si la glosa no lo aclara, dilo.

### Fase C — Mapa de cobertura del universo (la síntesis que decide qué se construye)

1. **Matriz maestra año × grado × nivel.** Para cada año (2014…2025) y grado
   (4b, 6b, 8b, 2m), una celda que indique qué NIVELES DE INFORME existen:
   indicador (I), dimensión (D), subdimensión/niveles (S). Ejemplo de celda:
   "I·D·S" (los tres), "I" (solo indicador), "—" (sin dato). Marca el hueco
   2020-2021 como "inexistente (pandemia), esperado". **Esta matriz es el producto
   central**: muestra de un vistazo qué serie se puede construir en cada nivel.
2. **Tabla de esquemas por época.** Cada esquema estructural distinto encontrado
   (mínimo 2014-2016, enriquecido-texto 2017, 2018-con-dimensiones, enriquecido-
   numérico 2019, largo 2022-2025, y los que aparezcan), con: años que lo usan,
   columnas presentes, formato, codificación (texto/numérica), nivel(es) que
   porta, y diferencias contra el esquema canónico de `idps_largo`.
3. **Tabla de mapeo de columnas → esquema canónico.** Para cada columna canónica
   del parquet (`COLS_CANONICAS` de `34`: `rbd, agno, grado, ciclo_texto,
   preliminar, familia, id_indicador, id_dimension, id_subdimension, cod_grupo,
   cod_depe2, geo…, prom, dif, sigdif, difgru, sigdifgru, mdif, mdifgru,
   niv_*_por`), indica de qué columna de origen sale en cada esquema, o si NO
   existe en ese esquema (quedará NA). Presta atención a: el pivot `ind_*`→
   (`id_indicador`,`prom`), el pivot `dim_*`→(`id_dimension`,`prom`) en 2018, la
   conversión texto→código de 2017, los campos ausentes (significancia en todo el
   histórico; `agno` en 2018).
4. **Catálogo de activos por nivel.** Tres listas — qué años/grados aportan
   **indicador**, cuáles **dimensión**, cuáles **subdimensión/niveles** — para que
   el titular vea exactamente qué serie es construible en cada nivel. El 2018 debe
   aparecer en la lista de dimensión. **Ningún activo se marca como descartable.**
5. **Inventario de duplicados y material ajeno** (informativo, para la fase 2 de
   organización): qué hay duplicado (con su gemelo en raíz y si es byte-idéntico),
   qué es ajeno (2024 mal ubicado), qué es ruido de sistema (`.DS_Store`). Sin
   recomendar borrado: solo catalogar.
6. **Decisiones que quedan para el titular** (las DETECTAS, NO las resuelves, NO
   recomiendas podar): mapeo sufijo-`dim_*`-2018 → dimensión (propón el técnico
   validado contra glosa+crosswalk, MARCADO "a validar por el titular"); conversión
   texto→código 2017; tratamiento de `agno` ausente en 2018; homologación de geo
   con nombres distintos en 2018; cualquier hallazgo inesperado. Preséntalas como
   insumo neutral con evidencia, no como recomendación de qué dejar fuera.

---

## 5. Criterios de éxito verificables (B.4)

1. **Existe el reporte** en
   `50_documentacion/activa/censo_universo_idps.md`, con: censo de archivos (Fase
   A), perfilado por archivo/hoja/columna (Fase B), y las seis tablas/listas de
   síntesis (Fase C), incluida la **matriz maestra año×grado×nivel**.
2. **Cobertura del barrido = 100%:** nº de archivos de datos IDPS catalogados ==
   nº que `fs::dir_ls(recurse=TRUE)` encuentra en los tres orígenes (menos
   `.DS_Store`, glosas y no-IDPS). Reporta ambos números y su igualdad.
3. **Todo nivel de informe de toda tabla está determinado y reportado** (I/D/S por
   año×grado). Ninguna tabla queda sin clasificar su nivel.
4. **Todo valor de columna de código está volcado** (o conteo+rango+muestra para
   alta cardinalidad), incluida la marca texto-vs-numérico.
5. **md5 de `idps_largo.parquet` idéntico** al inicial. Reportado.
6. **`git status` limpio** salvo los artefactos autorizados.

---

## 6. Mandato de auto-auditoría (panel adversarial)

Encargo de riesgo de datos (el censo funda qué se construye). Antes de reportar
"hecho", lanza un **panel adversarial**: agentes de SOLO LECTURA que re-derivan con
**código independiente** las afirmaciones de mayor riesgo. Mínimo:

1. **Cobertura:** un agente re-lista los tres orígenes con código propio, cuenta
   datos IDPS por origen/extensión, y confirma que el reporte no omitió ningún
   archivo (criterio 2). Reporta cualquier archivo en el FS y ausente del reporte.
2. **Nivel de informe:** un agente reabre, con código propio, **una tabla por
   esquema** (una de 2014-2016, la de 2017, una de 2018, una de 2019, y una
   moderna de cada familia rbd/rbd_dim/niveles) y confirma de forma independiente
   qué niveles porta (presencia de `ind_*`/`dim_*`/`sdim`/`niv_*`) y el formato
   (ancho/largo). Esto rompe el punto ciego de que el perfilado principal haya
   clasificado mal un nivel — el error exacto que motivó rehacer el diagnóstico.
3. **Dimensión 2018:** un agente confirma independientemente que los 3 archivos
   2018 contienen las 11 columnas `dim_*_rbd` con medida en [0,100] y una fila por
   RBD (que la dimensión 2018 es dato real y aprovechable, no artefacto).
4. **Integridad:** un agente confirma el md5 del parquet y que `git status` no
   muestra ningún dato modificado.

Si el panel detecta discrepancia, corrígela en el reporte y vuelve a auditar.
Documenta en el log qué auditó y qué encontró (aunque no encuentre nada, dilo).

---

## 7. Mandato del log y estado de cierre

1. **Log** en `50_documentacion/andamios/logs/YYYYMMDD_censo_universo_idps_log.md`
   según la plantilla fija del protocolo (resumen, commits, cada hallazgo con
   evidencia, auditoría de diagnóstico con veredicto, verificación de invariantes
   🔒 con PASA/FALLA, decisiones detectadas, pendientes, md5 del parquet, notas para
   el revisor). **Honesto:** incluye lo que costó.
2. **Commits.** Crea exactamente dos artefactos versionables: el reporte y el log.
   Dos commits atómicos:
   - `docs(idps): censo forense del universo IDPS por anio/grado/nivel (P5 fase 1)`
     — solo `50_documentacion/activa/censo_universo_idps.md`.
   - `docs(idps): log de ejecucion del censo del universo IDPS (P5 fase 1)`
     — solo el log.
   - **NO** commitees nada bajo `20_insumos/`. **NO** `git add -u`/`.`. El
     `verificar_*.R` y el parquet de inventario (si lo creas) quedan sin versionar.
   - **NO** hagas push. El titular revisa reporte y log antes.

---

## 8. Reporte final (qué vuelve al chat)

1. **Conteo del barrido** por origen y extensión (datos IDPS vs glosas vs ruido).
2. **La matriz maestra año×grado×nivel** en texto compacto (el producto central).
3. **Catálogo de activos por nivel:** qué años/grados aportan indicador, cuáles
   dimensión, cuáles subdimensión/niveles. Con el 2018 en dimensión.
4. **Confirmación/refutación** de cada hipótesis de §2.4 (los tres esquemas, 2018
   con dimensión, indicadores estables, codificación texto en 2017). Lo que
   refutes, prominente.
5. **Decisiones detectadas para el titular** (sin resolver, sin recomendar podar),
   con el mapeo técnico sufijo-2018→dimensión marcado "a validar".
6. **Veredicto del panel adversarial:** qué auditó, qué encontró.
7. **Invariantes:** md5 inicio/fin, `git status`, los dos commits con hashes.
8. **Rutas** del reporte y del log.
9. **NO inicies la fase 2 ni la 3.** Detente en el reporte.

---

## 9. Recordatorio de reparto (dual-Claude)

Tú (Claude Code) ejecutas: terminal, lectura, perfilado, escritura del reporte y
del log, commits, panel adversarial. **NO** decides qué dato se ingiere o se deja,
**NO** recomiendas podar, **NO** rediseñas el pipeline, **NO** redactas el traspaso.
Si aparece una decisión de uso, la REPORTAS con evidencia; no la tomas. El
principio rector §0 manda: el censo conserva y cataloga todo; descartar es decisión
del titular, fuera de este encargo.
