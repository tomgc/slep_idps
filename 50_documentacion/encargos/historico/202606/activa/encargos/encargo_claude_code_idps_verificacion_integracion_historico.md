# Encargo Claude Code — Verificacion adversarial de la integracion historica

> **Proyecto:** `slep_idps`. **Sesion de analisis:** 11 (Opus). **Naturaleza:**
> auditoria READ-ONLY del `idps_largo.parquet` integrado en la sesion 10 (P5).
> Patron: `encargo_autonomo_claude_code_v1.md` (panel adversarial, seccion 3).
> **No hay cambio de datos ni de codigo:** se verifica que la integracion 2014→2025
> es correcta, con codigo independiente, y se reporta un veredicto.

---

## 0. Contrato de ejecucion

- **Modo:** autonomo, secuencial, ejecuta todo en este turno. No pidas
  confirmacion de pasos mecanicos ya cubiertos por esta meta.
- **Naturaleza READ-ONLY (define todo lo demas):** este encargo NO modifica el
  parquet, NO lo regenera, NO edita `34_leer_normalizar_idps.R` ni ningun codigo
  del pipeline, NO hace push y NO publica en Pages. Produce scripts de
  verificacion efimeros y un log. El unico artefacto que puede quedar versionado
  (opcional) es el log; ver seccion 7.
- **Regla de detencion (PARA y reporta, no improvises):**
  1. Si un invariante 🔒 te obligaria a modificar el parquet o el codigo para
     "arreglar" algo: NO lo hagas. Completa el panel, reporta el hallazgo con
     evidencia y detente. **Una correccion es una tarea nueva que aprueba el
     titular** (el traspaso v10 dejo el pipeline cerrado: "no reabrir la
     integracion salvo bug"; encontrar el bug es el entregable, corregirlo no).
  2. Si falta un dato real que el panel necesita (p. ej. no aparece el respaldo
     `50d9de4f…` en `_archivo/`): reporta y detente; no fabriques un sustituto.
  3. Si una afirmacion de la "verdad esperada" (seccion 3) resulta contradicha
     por el dato: ese es el hallazgo; documentalo, no lo acomodes.
- **Reglas canonicas heredadas (no se re-explican; ver `POLITICA_PROYECTO.md`):**
  R-only, R 4.5.x en Positron (macOS aarch64); rutas absolutas SIEMPRE desde la
  raiz del repo; nunca asumas un `cd` previo; pipe nativo `|>`, `dplyr` con
  `.by=`; llaves `character`; comentarios en espanol sin tildes en nombres de
  archivo. Datos publicos (Rama A), pero igual: si ejemplificas un establecimiento
  en el log, usa el **RBD**, nunca el nombre.

---

## 1. Contexto minimo suficiente

- **Repo (raiz de codigo y datos, Rama A publica):**
  `/Users/tomgc/Projects/slep_idps`
- **Parquet a auditar:**
  `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
  - md5 canonico esperado: `4c764d8c9f0bf70004f8aa52661ae901`
  - 2.362.447 filas. Esquema largo: una fila por `rbd × agno × grado × nivel-de-
    jerarquia`, con discriminador `familia ∈ {indicador, dimension, niveles}`.
  - Columnas: `rbd, agno, grado, ciclo_texto, preliminar, familia, id_indicador,
    id_dimension, id_subdimension, cod_grupo, cod_depe2, cod_com_rbd, nom_com_rbd,
    cod_reg_rbd, nom_reg_rbd, cod_pro_rbd, nom_rbd, prom, dif, sigdif, difgru,
    sigdifgru, mdif, mdifgru, niv_bajo_por, niv_medio_por, niv_alto_por,
    niv_mbajo_por, niv_mmedio_por, niv_malto_por`.
- **Respaldo pre-historico (baseline del dato moderno, fin de v09):**
  en `/Users/tomgc/Projects/slep_idps/_archivo/20260621/` hay un parquet con md5
  `50d9de4f1fc80259d29f499cdf46d9e1` (1.485.103 filas, solo 2022-2025, **sin**
  4b2024 y **sin** la sincronizacion de tildes de region). El nombre exacto del
  archivo lo descubres en Fase 0 localizandolo por md5. `_archivo/` esta fuera de
  git (vive solo en disco): leelo del filesystem.
- **Fuente cruda del historico (para el spot-check de Fase 5):**
  `/Users/tomgc/Projects/slep_idps/20_insumos/historico/idps{grado}{AAAA}_rbd_historico.{xls,xlsx}`
  (formato ANCHO: indicador/dimension como columnas). Glosas en
  `20_insumos/historico/glosas/` (no son datos).
- **Crosswalks de referencia (puedes LEER sus constantes, NO sus funciones):**
  `/Users/tomgc/Projects/slep_idps/10_utils/10_configuracion.R` expone
  `CW_INDICADOR` (AM=1, CC=2, PF=3, HV=4), `CW_DIMENSION` (11 dims),
  `NOMBRES_REGION`, `GRADOS_MOTOR`. Son datos de referencia: usarlos como tabla de
  lookup esta permitido. **Esta prohibido** llamar a las funciones de lectura/
  pivoteo de `34` (`leer_un_archivo_historico` y similares): el panel debe
  re-derivar con codigo propio (A21: la auditoria del camino B usa codigo
  distinto, no una copia de las funciones de produccion).
- **Que paso en la sesion 10 (P5):** `34` se extendio para fundir el historico
  ancho 2014-2019 en el mismo parquet. Dos efectos colaterales legitimos sobre el
  dato moderno, ajenos al historico, quedaron en el parquet nuevo (hallazgo H10-1):
  (a) `nom_reg_rbd` se sincronizo con tildes (588.286 filas, mismas regiones por
  `cod_reg_rbd`, 0 reasignaciones); (b) ~45 establecimientos actualizaron geo/
  dependencia canonica al ingerir 4b2024. Ademas un bug (H10-2) que contaminaba
  657 filas modernas con geo/depe historica fue corregido (`attr_estab` ahora es
  regimen-aware). El parquet quedo en 2.362.447 filas.

---

## 2. Invariantes 🔒 (la red de seguridad de tu autonomia)

- 🔒 **READ-ONLY.** No escribes sobre `idps_largo.parquet`, no lo regeneras, no
  editas codigo del pipeline. **Prueba dura:** el md5 del parquet al final del
  encargo debe ser identico al del inicio (`4c764d8c…`). Reportalo.
- 🔒 **Codigo independiente.** Cada verificacion se re-deriva desde el parquet /
  el respaldo / la fuente cruda con codigo tuyo. No importas ni copias las
  funciones de `34`. (Un check escrito por el mismo flujo que produjo el cambio
  hereda sus puntos ciegos.)
- 🔒 **"Lee, no deriva."** El `NA` en el historico es dato legitimo, NO un fallo
  de integracion: significancia (`dif/sigdif/difgru/sigdifgru/mdif/mdifgru`) es NA
  en TODO 2014-2019; GSE (`cod_grupo`) es NA en 2014-2016; subdimension y niveles
  (`id_subdimension`, `niv_*_por`) son NA en TODO el historico. La auditoria
  confirma que el NA esta donde debe; no lo "corrige" ni lo cuenta como error.
- 🔒 **`verificar_*.R` son efimeros.** Los scripts de verificacion que crees van
  con prefijo `verificar_` y NO se commitean (estan en `.gitignore`). No
  contamines `git add` con ellos.
- 🔒 **No mutar el repo.** No push, no Pages, no `git add` de datos ni de codigo.
  Lo unico commiteable (opcional) es el log, como `docs()` aislado; ver seccion 7.
- 🔒 **Gobernanza.** En el log, ejemplifica con RBD, nunca con nombre de
  establecimiento.

---

## 3. La verdad esperada (contra que auditas)

Estas son las afirmaciones que el panel debe **re-derivar de forma independiente**
y confirmar o refutar. No las tomes como ciertas: son la hipotesis a verificar.

**3.1 Descomposicion de filas.**
`2.362.447 = 1.485.103 (moderno baseline) + 263.535 (4b2024) + 613.809 (historico)`.
El moderno del parquet nuevo (`agno ∈ 2022:2025`) debe ser `1.748.638`
(`1.485.103 + 263.535`).

**3.2 Cobertura por `familia × grado × agno`.**
- **Archivos historicos disponibles (18 datos):** el `(grado, agno)` del historico
  en el parquet debe corresponder exactamente a estos archivos:
  - 2m: 2014, 2015, 2016, 2017, 2018
  - 4b: 2014, 2015, 2016, 2017, 2018
  - 6b: 2014, 2015, 2016, 2018
  - 8b: 2014, 2015, 2017, 2019
- **`familia == indicador`:** presente 2014→2025 (todos los grados segun 3.2 en el
  historico; 2m/4b/6b/8b en el moderno segun los insumos de la raiz).
- **`familia == dimension`:** en el historico SOLO existe para 2018, y SOLO en los
  grados con archivo 2018: **2m, 4b, 6b** (NO 8b, no hay `idps8b2018`). En el
  moderno, 2022-2025. Verifica que NO hay dimension historica fuera de 2018.
- **`familia == niveles`:** SOLO 2023-2025 (moderno). CERO filas de niveles en el
  historico.
- **Hueco pandemia:** CERO filas en `agno ∈ {2020, 2021}`.

**3.3 Patron de NA (supresion vs ausencia de la fuente).** Distingue dos cosas:
el `NA` por supresion estadistica (en cualquier epoca, cuando la Agencia oculta
una celda) y el `NA` estructural del historico (la fuente no trae esa columna).
La verificacion estructural:
- `dif, sigdif, difgru, sigdifgru, mdif, mdifgru`: 100% NA en `agno ∈ 2014:2019`.
- `cod_grupo`: 100% NA en `agno ∈ 2014:2016`. En 2017-2019 historico **deberia**
  existir GSE: re-deriva el % NA de `cod_grupo` por anio en el historico y reporta
  el patron real (si 2017-2019 tuviera NA masivo, es un hallazgo).
- `id_subdimension`, `niv_*_por`: 100% NA en todo el historico (`agno ≤ 2019`).
- Contraparte moderna: confirma que el moderno conserva sus no-NA esperados (p. ej.
  niveles con cobertura en 2023-2025), para descartar que la fusion haya borrado
  medidas modernas.

**3.4 "El dato moderno no cambio" (el invariante de A10-3).** Join del moderno del
parquet nuevo contra el respaldo `50d9de4f…` por la llave
`(familia, rbd, agno, grado, id_indicador, id_dimension, id_subdimension)`:
- **`left_only`** (filas en el parquet nuevo no presentes en el respaldo) = las de
  **4b2024** (`grado == "4b" & agno == 2024`), exactamente **263.535**. Nada mas.
- **`right_only`** (filas del respaldo ausentes del parquet nuevo) = **0**. Ninguna
  fila moderna desaparecio.
- **Columnas SAGRADAS (cifra IDPS) en el `inner` (1.485.103 filas): CERO
  diferencias.** Son: `id_indicador, id_dimension, id_subdimension, cod_grupo,
  prom, dif, sigdif, difgru, sigdifgru, mdif, mdifgru, niv_bajo_por, niv_medio_por,
  niv_alto_por, niv_mbajo_por, niv_mmedio_por, niv_malto_por`. Una sola diferencia
  aqui = la integracion corrompio una cifra → FALLA.
- **Columnas de PRESENTACION** (`cod_com_rbd, nom_com_rbd, cod_reg_rbd,
  nom_reg_rbd, cod_pro_rbd, nom_rbd, cod_depe2`): se permiten diferencias, PERO
  acotadas y explicables:
  - `nom_reg_rbd`: difiere por tildes en hasta ~588.286 filas, con `cod_reg_rbd`
    **identico** (0 reasignaciones de region).
  - `cod_com_rbd, cod_pro_rbd, cod_depe2, nom_rbd`: difieren solo para un conjunto
    acotado de **~45 RBD distintos** (recanonizacion por 4b2024). Cuenta los RBD
    distintos con cambio; deberia rondar 45. Si fueran cientos (orden ~657), el fix
    de H10-2 estaria incompleto → hallazgo.
  - `cod_reg_rbd`: idealmente 0 cambios; cualquier cambio, reportalo.

**3.5 Integridad estructural.**
- Jerarquia de ids: `id_dimension %/% 10 == id_indicador`;
  `id_subdimension %/% 100 == id_indicador`; `id_subdimension %/% 10 ==
  id_dimension` (donde no son NA).
- Dominios: `id_indicador ∈ 1:4`; `cod_grupo ∈ {1..5, NA}`; `cod_depe2 ∈ {1..4,
  NA}`.
- Sin duplicados de llave `(familia, rbd, agno, grado, id_indicador, id_dimension,
  id_subdimension)`.

---

## 4. Fases en orden estricto (el panel)

Lo determinista antes que el juicio; el estado real antes que cualquier afirmacion.
Cada fase: re-derivacion independiente + veredicto PASA/FALLA con evidencia
numerica. Usa agentes/scripts de solo-lectura.

**Fase 0 — Leer estado real (read-only).**
- md5 del parquet canonico; confirmalo `== 4c764d8c…` (si difiere, reporta: el
  parquet en disco no es el documentado, todo lo demas queda en suspenso).
- Localiza en `_archivo/20260621/` el parquet cuyo md5 sea `50d9de4f…`; registra
  su ruta. Si no aparece: regla de detencion (2).
- Carga ambos parquets y el inventario de `20_insumos/historico/`.
- **P-PUSH (pendiente de apertura del traspaso v10):** `git -C
  /Users/tomgc/Projects/slep_idps status` y confirma HEAD local `==` `origin/main`
  (`git -C … rev-parse HEAD` vs `git -C … rev-parse origin/main`, tras `git -C …
  fetch`). Reporta si esta sincronizado. (Es solo lectura; no commitees nada.)

**Fase 1 — Cobertura (verdad 3.1 y 3.2).** Re-deriva `count(familia, grado, agno)`
del parquet; contrasta contra los 18 archivos, las reglas de familia (dimension
solo 2018 en 2m/4b/6b; niveles solo 2023-2025; cero 2020-2021) y la descomposicion
de filas. Tabla de cobertura como evidencia.

**Fase 2 — Legitimidad del NA (verdad 3.3).** % NA por columna y por anio (o por
epoca) para las columnas de significancia, GSE, subdimension y niveles. Confirma
los 100% NA estructurales y el patron real de GSE 2017-2019. Confirma que el
moderno conserva sus medidas.

**Fase 3 — El dato moderno no cambio (verdad 3.4).** El join contra el respaldo,
con la particion sagradas/presentacion. Reporta: conteos `left_only`/`right_only`/
`inner`; nº de diferencias por columna sagrada (objetivo: 0); nº de RBD distintos
con cambio en cada columna de presentacion y si calzan con lo esperado (~45 geo/
depe; tildes en `nom_reg_rbd` con `cod_reg_rbd` intacto). **Esta es la fase de
mayor riesgo: re-derivala con codigo independiente del de Fase 0.**

**Fase 4 — Integridad estructural (verdad 3.5).** Jerarquia de ids, dominios,
duplicados de llave. Evidencia: conteos de violaciones (objetivo: 0).

**Fase 5 — Spot-check 1:1 contra la fuente cruda.** El test mas fuerte: traza 2-3
celdas ancla desde el `.xls/.xlsx` historico crudo hasta el parquet, re-derivando
el pivoteo a mano (sin las funciones de `34`).
- **Antes de fijar una celda ancla, verifica que la combinacion existe** en el
  archivo crudo (A24: no asumir que un `(rbd, indicador, anio)` esta publicado).
- Cubre al menos: (a) un **indicador 2014-2016** (sin GSE) trazado de
  `idps{g}{AAAA}_rbd_historico.xls` → fila `familia==indicador` del parquet,
  confirmando `prom` y `cod_grupo` NA; (b) la **dimension 2018** trazada de un
  `idps{g}2018_rbd_historico.xlsx` (columna `dim_{ind}_{dim}_rbd`, el par medio)
  → fila `familia==dimension` del parquet, confirmando `id_dimension` via
  `CW_DIMENSION`. Reporta los valores crudos y los del parquet, lado a lado.

**Fase 6 — Veredicto + log.** Consolida PASA/FALLA por dimension; escribe el log
(seccion 7). Re-verifica el md5 del parquet (`== 4c764d8c…`, prueba de read-only).

> No hay commits de datos ni de codigo en ninguna fase. El unico `git` permitido es
> de **lectura** (status/rev-parse/fetch en Fase 0) y, opcionalmente, un `docs()`
> del log al cierre (seccion 7).

---

## 5. Criterios de exito verificables (B.4)

El encargo es exitoso si, al final:
- md5 del parquet identico al inicio (`4c764d8c…`). **Prueba de read-only.**
- Cada una de las 5 dimensiones (cobertura, NA, moderno-intacto, integridad,
  spot-check) tiene veredicto **PASA** con su evidencia numerica, **o** un
  **hallazgo** documentado con evidencia (sin intento de correccion).
- En particular, Fase 3: 0 diferencias en columnas sagradas; `right_only == 0`;
  `left_only` == 4b2024 (263.535); diffs de presentacion acotados y explicados.
- El log existe en `andamios/logs/` con la plantilla fija y es honesto (incluye lo
  que costo y lo que quedo dudoso).
- P-PUSH reportado (sincronizado / no).

---

## 6. Mandato de auto-auditoria

Este encargo **es** una auditoria; el panel adversarial es el trabajo, no un
anexo. Refuerzo: para Fase 3 (la de riesgo), re-deriva la afirmacion "0 cambios en
cifras" con **dos metodos independientes** donde sea barato (p. ej. un `anti_join`
por llave + un hash por fila de las columnas sagradas, y un conteo directo de
`!=` columna a columna). Si los dos metodos no coinciden, el problema esta en tu
verificacion: resuelvelo antes de reportar.

---

## 7. Log y estado de cierre

- **Log:** `/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/<AAAAMMDD>_verificacion_integracion_historico_log.md`
  (fecha real de ejecucion). Plantilla fija del contrato v1 (seccion 4): resumen;
  inventario de commits (aqui: ninguno de datos/codigo, y el del log si lo
  commiteas); por cada dimension verificada — que, como se re-derivo, evidencia,
  veredicto; **auditoria de diagnostico** con la tabla de hallazgos (severidad, si
  toca cifras, corregido vs pendiente); bugs si los hubo; **verificacion de
  invariantes** (la lista 🔒, cada uno PASA/FALLA con evidencia, incl. md5
  inicial==final); pendientes/`# REVISAR`; estado de cifras (md5 antes/despues);
  notas para el revisor.
- **No commitear los `verificar_*.R`** (efimeros, gitignored).
- **El log puede quedar SIN commitear** para revision previa del titular (esa es la
  opcion preferida aqui), o commitearse como un `docs()` atomico aislado. NO lo
  mezcles con ningun otro cambio. No hay nada mas que commitear: el encargo es
  read-only.
- **No push, no Pages.**
- **Estado de cierre esperado:** repo sin cambios de datos/codigo; parquet
  intacto (md5 identico); un log nuevo (commiteado como `docs()` o dejado para
  revision); veredicto reportado.

---

## 8. Reporte final (lo que devuelves en el chat de Claude Code)

1. **Veredicto por dimension:** cobertura / NA / moderno-intacto / integridad /
   spot-check → PASA o HALLAZGO (con el numero clave de cada una).
2. **md5 del parquet:** inicial y final (deben coincidir).
3. **P-PUSH:** sincronizado o no, con la evidencia (`HEAD` vs `origin/main`).
4. **Ruta del log.**
5. **Si hubo algun HALLAZGO:** descripcion, evidencia, severidad y por que NO lo
   corregiste (decision del titular). Si todo PASA: declaralo limpio.
