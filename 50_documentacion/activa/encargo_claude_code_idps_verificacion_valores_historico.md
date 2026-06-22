# Encargo Claude Code — Verificacion exhaustiva (censo) de los valores del historico

> **Proyecto:** `slep_idps`. **Sesion de analisis:** 11 (Opus). **Naturaleza:**
> auditoria READ-ONLY, complemento del encargo previo
> (`encargo_claude_code_idps_verificacion_integracion_historico.md`).
> Patron: `encargo_autonomo_claude_code_v1.md`.
>
> **Por que existe este encargo.** El primer audit dejo el dato MODERNO blindado de
> forma exhaustiva (join completo vs respaldo, 17 columnas sagradas con 0 diffs por
> tres metodos). Pero los VALORES del historico 2014-2019 (dato nuevo, sin respaldo
> contra el cual diferenciar) se verificaron solo por (a) reconciliacion de
> CONTEOS y (b) 14 celdas ancla a mano: una muestra, no un censo. Un error
> sistematico del pivoteo ancho→largo o del crosswalk que produjera *mismo conteo,
> valores equivocados* pasaria la reconciliacion de conteos y podria no caer en
> ninguna ancla. Como este dato alimentara el motor publico, su correccion debe
> verificarse a nivel CENSO, celda por celda, no por muestra.
>
> **Que NO repite.** No re-verifica el moderno (ya esta exhaustivo), ni la
> estructura/cobertura (ya exhaustivas). Se concentra en una sola cosa: que cada
> valor del historico en el parquet coincide con el crudo.

---

## 0. Contrato de ejecucion

- **Modo:** autonomo, secuencial, ejecuta todo en este turno.
- **Naturaleza READ-ONLY:** NO modifica el parquet, NO lo regenera, NO edita
  `34_leer_normalizar_idps.R` ni codigo del pipeline, NO hace push, NO publica.
  Produce scripts de verificacion efimeros (`verificar_*`) y un log.
- **Regla de detencion (PARA y reporta, no improvises):**
  1. Si encuentras una diferencia de valor real entre el crudo y el parquet: ese es
     el hallazgo. Documentalo con evidencia (archivo, RBD, anio, columna, crudo vs
     parquet). NO lo corrijas: una correccion del pipeline es tarea nueva del
     titular.
  2. Si falta un dato real que el censo necesita (un xlsx ilegible, una columna que
     no calza con ningun patron conocido): reporta y detente; no fabriques un
     sustituto ni adivines la semantica.
- **Reglas canonicas heredadas (ver `POLITICA_PROYECTO.md`):** R-only, R 4.5.x en
  Positron (macOS aarch64); rutas absolutas SIEMPRE desde la raiz del repo; nunca
  asumas `cd`; `|>`, `dplyr` con `.by=`; llaves `character`. Si el `.xls` antiguo da
  problemas de lectura, usa `readxl::read_excel` (soporta `.xls` y `.xlsx`); si una
  hoja trae el locale en coma decimal, normalizala antes de `as.numeric` (mismo
  criterio `to_num` del pipeline, **reimplementado**, no importado).
- **Gobernanza:** datos publicos (Rama A); aun asi, en el log ejemplifica con RBD,
  nunca con nombre de establecimiento.

---

## 1. Contexto minimo suficiente

- **Repo:** `/Users/tomgc/Projects/slep_idps`
- **Parquet a auditar:**
  `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
  (md5 canonico `4c764d8c9f0bf70004f8aa52661ae901`; 2.362.447 filas).
- **Fuente cruda del historico (18 datos, formato ANCHO):**
  `/Users/tomgc/Projects/slep_idps/20_insumos/historico/idps{grado}{AAAA}_rbd_historico.{xls,xlsx}`
  - 2m 2014-2018 · 4b 2014-2018 · 6b 2014/15/16/18 · 8b 2014/15/17/19.
  - Indicador como columnas `ind_{codigo}_rbd` (todos los anios). Dimension como
    columnas `dim_{ind}_{suf}_rbd` (SOLO 2018). GSE en su propia columna.
  - Glosas en `historico/glosas/` (no son datos).
- **Crosswalks de referencia (LEER sus constantes, NO sus funciones):**
  `/Users/tomgc/Projects/slep_idps/10_utils/10_configuracion.R`: `CW_INDICADOR`
  (AM=1, CC=2, PF=3, HV=4), `CW_DIMENSION` (11 sufijos → id_dimension),
  `NOMBRES_REGION`.
- **Corpus conceptual canonico (la verdad de la estructura):**
  `/Users/tomgc/Projects/slep_idps/20_insumos/auxiliares/referencias_idps/idps_corpus_conceptual.md`
  (y su `.json`): indicador → dimension → subdimension oficial. Es la fuente contra
  la que se valida que cada codigo crudo significa lo que el crosswalk asume.
- **Que dejo establecido el primer audit (no re-hacer, usar como cifras de
  control):** historico = 613.809 filas; `prom` no-NA: indicador 410.380,
  dimension 189.767 (el resto son placeholders NA de la grilla ancha); `cod_grupo`
  NA en 2014-2016, presente 2017-2019; significancia/subdim/niveles 100% NA en el
  historico.

**Aclaracion metodologica clave (no caer en un falso positivo):** en el parquet, la
**geografia y la dependencia** de una fila historica NO son el dato crudo de ese
anio: son atributos CANONICOS (registro mas reciente por RBD, Bloque 5 de `34`), y
2018 ademas paso por un mapeo de geo divergente. Por eso este censo NO compara geo/
depe del historico contra el crudo (darian diferencias legitimas). El censo compara
las columnas que SI son el dato medido tomado de la celda cruda: **`prom`** (de las
columnas `ind_*`/`dim_*`) y **`cod_grupo`** (GSE por RBD/anio/grado). La geo se
trata aparte y en modo liviano (Fase 4).

---

## 2. Invariantes 🔒

- 🔒 **READ-ONLY.** md5 del parquet al final == al inicio (`4c764d8c…`). Reportalo.
- 🔒 **Codigo independiente y derivado de la fuente, no de `34`.** El pivoteo ancho→
  largo se reimplementa con codigo propio. La semantica de cada columna se deriva
  de su NOMBRE crudo + el crosswalk + el corpus, NO de la interpretacion de `34`
  (puedes leer `34` para ubicar nombres de columnas, pero la logica de transformacion
  es tuya). Razon: si replicaras la logica de `34`, no podrias cazar un error de
  `34`; el censo solo vale si re-deriva desde la fuente con criterio propio.
- 🔒 **"Lee, no deriva."** El NA del crudo (celda vacia o suprimida) se preserva como
  NA en la comparacion (NA==NA). No cuentes un NA legitimo como diferencia.
- 🔒 **`verificar_*.R` efimeros, no commiteados** (gitignored).
- 🔒 **No mutar el repo:** sin push, sin Pages, sin `git add` de datos/codigo.
- 🔒 **Gobernanza:** RBD, no nombres, en el log.

---

## 3. La verdad esperada (contra que auditas)

Re-deriva de forma independiente y confirma:

**3.1 Conjunto de filas (estructura del historico).** Tu re-pivoteo debe producir el
MISMO conjunto de llaves que el subconjunto historico del parquet. Llave:
`(rbd, agno, grado, familia, id_indicador, id_dimension)`. Esperado en el full-join:
- `left_only` (en tu re-derivacion, no en el parquet) = 0.
- `right_only` (en el parquet, no en tu re-derivacion) = 0.
- Total de filas historicas re-derivadas = **613.809**.
(Si hay left/right_only, el pivoteo invento o perdio filas → hallazgo estructural.)

**3.2 Valores medidos (el corazon de este censo).** En las filas con llave comun:
- **`prom`: 0 diferencias** (NA-safe). Cuadra ademas el no-NA: indicador **410.380**,
  dimension **189.767**.
- **`cod_grupo` (GSE): 0 diferencias** (NA-safe). Con el patron: NA en 2014-2016,
  presente 2017-2019.
- Usa tolerancia numerica explicita para `prom` (constante nombrada, p. ej.
  `TOL <- 1e-9`): el crudo y el parquet deben coincidir a precision flotante. Si
  aparece cualquier `|delta| > TOL`, reportalo con el caso.

**3.3 Censo del uso del crosswalk (correccion semantica, no solo de procesamiento).**
El full-join con la MISMA tabla de lookup verifica que el valor cayo en la id
correcta DADO el crosswalk, pero no que el crosswalk en si sea correcto. Por eso,
ademas: lista TODOS los pares distintos efectivamente usados en el historico —
`(codigo crudo de indicador → id_indicador)` y `(sufijo crudo de dimension →
id_dimension)`— y confirma cada uno contra el **corpus** (estructura oficial). Toda
combinacion `(familia, ids)` historica debe existir en el corpus. Si algun codigo
historico mapea a una id que el corpus no respalda (p. ej. un sufijo reutilizado con
otro significado entre anios), es un hallazgo. Cubre los 4 indicadores y todos los
sufijos de dimension presentes en 2018.

---

## 4. Fases en orden estricto

**Fase 0 — Estado real (read-only).** md5 del parquet `== 4c764d8c…` (si difiere,
detente: el parquet en disco no es el documentado). Inventaria los 18 xlsx de
`historico/`. Carga el subconjunto historico del parquet (`agno <= 2019`).

**Fase 1 — Re-pivoteo independiente del historico.** Con codigo propio, por cada
xlsx historico:
- Lee la hoja; identifica `rbd`, la columna de GSE, las columnas `ind_*_rbd` y (solo
  2018) `dim_*_*_rbd` a partir de sus NOMBRES.
- Pivota a largo: una fila por `(rbd, familia, id)`. Para indicador,
  `ind_{cod}_rbd → id_indicador = CW_INDICADOR[cod]`. Para dimension (2018),
  `dim_{ind}_{suf}_rbd → id_dimension = CW_DIMENSION[suf]` tomando el sufijo
  (token medio), exactamente como el spot-check del primer audit
  (`dim_cc_as_rbd → as → 23`). `prom` = valor de la celda (normalizado coma→punto).
  `cod_grupo` = GSE de esa fila.
- Anexa `agno` y `grado` desde el NOMBRE del archivo (no de columnas internas).
- Preserva NA donde la celda cruda esta vacia/suprimida (no rellenes con 0).
- Si un sufijo/codigo no calza con el crosswalk: detente y reporta (no lo descartes).

**Fase 2 — Full-join y comparacion de valores (3.1 + 3.2).** Une tu re-derivacion
con el subconjunto historico del parquet por la llave de 3.1. Reporta: conteos
left/right_only/inner; nº de diffs en `prom` y en `cod_grupo` (objetivo 0, NA-safe);
`max|delta|` de `prom`; y el cuadre de no-NA (410.380 / 189.767). Re-deriva esta
comparacion por dos vias donde sea barato (anti_join por la tupla valor + conteo
`!=` columna a columna) y confirma que coinciden.

**Fase 3 — Censo del crosswalk (3.3).** Tabla de pares distintos usados
(codigo→id_indicador; sufijo→id_dimension) confirmada 1:1 contra el corpus. Reporta
cualquier combinacion sin respaldo en el corpus.

**Fase 4 — Geo de RBD solo-historico (secundaria, liviana).** Identifica los RBD que
aparecen SOLO en el historico (sin fila moderna). Para esos, la geo del parquet es
su registro historico mas reciente (canonico). Verifica de forma liviana (no censo
estricto): que su geo (`cod_com_rbd`, `cod_reg_rbd`) esta poblada donde el crudo la
trae, y spot-checkea 3-4 contra el crudo de su anio mas reciente (recordando el
mapeo divergente de 2018). Es sanity-check; si algo se ve raro, reportalo, no lo
corrijas. (Prioridad menor: geo es atributo derivado, no dato medido.)

**Fase 5 — Veredicto + log.** Consolida PASA/HALLAZGO por fase. Re-verifica md5
(`== 4c764d8c…`). Escribe el log (seccion 6).

---

## 5. Criterios de exito verificables (B.4)

- md5 del parquet identico al inicio. **Prueba de read-only.**
- Fase 2: `left_only == 0`, `right_only == 0`, `prom` 0 diffs (`max|delta| <= TOL`),
  `cod_grupo` 0 diffs, no-NA cuadra (410.380 / 189.767). **O** un hallazgo
  documentado con evidencia y sin correccion.
- Fase 3: 0 combinaciones historicas sin respaldo en el corpus.
- Fase 4: sin anomalias de geo en solo-historico (o reportadas).
- Log en `andamios/logs/` con la plantilla fija, honesto.

---

## 6. Auto-auditoria, log y cierre

- Este censo ES, en si mismo, la verificacion independiente que complementa el primer
  audit. Refuerzo: Fase 2 por dos vias (anti_join + conteo `!=`) que deben coincidir;
  si difieren, el problema esta en tu verificacion, resuelvelo antes de reportar.
- **Log:** `/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/<AAAAMMDD>_verificacion_valores_historico_log.md`,
  plantilla del contrato v1 (resumen; commits — aqui ninguno de datos/codigo, el log
  opcional como `docs()`; por fase que/como/evidencia/veredicto; tabla de hallazgos
  con severidad y si toca cifra; invariantes 🔒 PASA/FALLA con md5 inicio==fin;
  pendientes; estado de cifras; notas para el revisor). **Honesto:** registra
  cualquier shell que falle y como se recupero, y cualquier ambiguedad de
  desambiguacion (este es un reparo del log anterior).
- **No commitear los `verificar_*.R`.** El log puede quedar SIN commitear para
  revision previa, o commitearse como `docs()` aislado. Sin push, sin Pages.
- **Estado de cierre esperado:** repo sin cambios de datos/codigo; parquet intacto
  (md5 identico); un log nuevo; veredicto reportado.

---

## 7. Reporte final (en el chat de Claude Code)

1. **Veredicto por fase:** valores historicos (`prom`/`cod_grupo`) / estructura de
   filas / crosswalk vs corpus / geo solo-historico → PASA o HALLAZGO, con el numero
   clave de cada uno (incl. `max|delta|` de `prom`).
2. **md5 del parquet:** inicial y final (deben coincidir).
3. **Ruta del log.**
4. **Si hubo HALLAZGO:** archivo/RBD/anio/columna, crudo vs parquet, severidad, y por
   que NO lo corregiste. Si todo PASA: declaralo — los valores del historico
   reproducen el crudo celda por celda.
