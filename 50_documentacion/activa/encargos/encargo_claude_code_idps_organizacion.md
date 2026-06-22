# Encargo autónomo — Organización del universo IDPS (P5, fase 2)

> **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, Rama A
> pública). **Fase:** P5, fase 2 de 3 (ORGANIZACIÓN de archivos). La fase 1 (censo)
> está cerrada y aprobada; la fase 3 (integración al pipeline) es posterior y NO
> forma parte de este encargo. **Modelo recomendado:** Opus.
>
> **Insumo de origen:** el censo de la fase 1, ya en el repo:
> `50_documentacion/activa/censo_universo_idps.md` y el parquet de inventario
> `40_salidas/intermedios/inventario_universo_idps.parquet`. Este encargo ejecuta
> las decisiones que el titular tomó sobre ese censo.
>
> **Patrón:** encargo autónomo dirigido por meta
> (`herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md`), combinado con el
> protocolo de reorganización estructural de la política (secciones 9 y 4.2):
> **DRY_RUN obligatorio antes del modo real.**

---

## 0. Principio rector y qué hace esta fase

**CONSERVACIÓN POR DEFECTO (heredado de la fase 1).** Esta fase ORGANIZA; no
descarta dato aprovechable. Lo único que se elimina son **duplicados byte-idénticos
verificados** (redundancia real, recuperable de su gemelo) y **ruido de sistema**
(`.DS_Store`). Todo lo demás se conserva: se mueve, se renombra, se archiva, nunca
se borra a ciegas.

Esta fase deja el universo IDPS ordenado para que la fase 3 (integración) tenga un
terreno limpio, en **dos ubicaciones según régimen**:

- **Raíz `20_insumos/`** = régimen moderno largo (2022-2025). Hoy ya vive ahí; esta
  fase solo le AGREGA el activo 2024 que está traspapelado (4b2024).
- **Subcarpeta nueva `20_insumos/historico/`** = régimen ancho 2014-2019 (el
  histórico), normalizado a nomenclatura canónica.

### 0.1 Las cuatro operaciones de esta fase (resumen; el detalle en §4)

1. **Promover** los 3 archivos de **4b2024** desde `historico_2014_2018/4B/` a la
   raíz `20_insumos/`, renombrando `4B`→`4b` (activo único: 4b2024 NO está en la
   raíz, el motor no lo usa hoy).
2. **Normalizar y mover** el histórico real 2014-2019 (cubeta A: 18 datos + sus
   glosas) a `20_insumos/historico/` con nomenclatura canónica.
3. **Eliminar duplicados byte-idénticos verificados:** cubeta B (2022/2023, el
   censo ya los confirmó byte-idénticos) y los 2m2024/6b2024 de la carpeta
   histórica (presuntos duplicados de la raíz — **verificar byte-identidad ANTES de
   borrar**, no asumir).
4. **Limpiar** el ruido `.DS_Store` y, al final, retirar la carpeta vacía
   `historico_2014_2018/`.

---

## 1. Encabezado de contrato

### 1.1 Modo y disciplina

- **Modo autónomo, pero con COMPUERTA DRY_RUN interna obligatoria** (§3 y §4). NO
  es "todas las operaciones destructivas de corrido": primero se simula todo, se
  emite el reporte del DRY_RUN, se autoverifica contra el plan, y solo si cuadra se
  pasa a modo real. Esta compuerta es interna al encargo (no requiere que el titular
  apruebe entre medio), pero el modo real NO se ejecuta si el DRY_RUN no cuadra con
  el plan: en ese caso, detente y reporta.
- Es una fase de **filesystem**: mover, renombrar, eliminar duplicados verificados.
  **NO toca el pipeline** (`34`, `10_configuracion.R`, motores): eso es la fase 3.
  **NO corre `run_all`.** **NO escribe en parquets de salida** salvo el log de
  reorganización.

### 1.2 Regla de detención

Detente y reporta SOLO si:

1. **(a)** El DRY_RUN no cuadra con el plan (conteos de movimientos/renombrados/
   borrados distintos a lo esperado en §4): NO pases a modo real.
2. **(b)** Un archivo a eliminar como "duplicado" resulta NO byte-idéntico a su
   gemelo en la raíz: NO lo borres, repórtalo (puede ser un activo distinto, como
   pasó con 4b2024).
3. **(c)** El diagnóstico de referencias (§4 Fase A) encuentra que algún script
   referencia literalmente rutas que esta fase movería: detente, repórtalo (hay que
   actualizar el código, que es fase 3).
4. **(d)** Archivo corrupto/ilegible que impide verificar byte-identidad.

Fuera de eso, avanza con autonomía: decisiones de nombre exacto, orden de
operaciones, estructura del log, las tomas tú.

### 1.3 Reglas canónicas heredadas

- **Rutas absolutas** desde `/Users/tomgc/Projects/slep_idps`. No asumas `cd`.
- **R-only** (`here`, `fs`, `readxl`, `dplyr`, `stringr`, `purrr`, `tibble`,
  `tools` para md5, `arrow` para leer el inventario). Pipe nativo `|>`.
- **`here::here()`** ancla rutas dentro del script.
- **Movimiento físico: COPIAR, luego verificar, luego eliminar el origen** — nunca
  `mv` directo sobre dato (regla de la política 4.3: copiar, no mover; verificar
  antes de borrar). Para esta fase, en régimen Rama A pública el origen es
  recuperable, pero igual se copia-verifica-elimina, no se mueve a ciegas.
- **Commits atómicos temáticos.** Nunca `git add .` ni `git add -u`.

---

## 2. Contexto: el mapa de origen (del censo de la fase 1)

### 2.1 Estado actual confirmado por el censo

Bajo `20_insumos/`:

- **Raíz** (régimen moderno largo, lo que `34` ya consume): 25 datos 2022-2025 + 2
  glosas. Cobertura por grado-año: 2022 (2m,4b · I·D), 2023 (2m,4b · I·D·S), 2024
  (2m,6b · I·D·S), 2025 (2m,4b,8b · I·D·S). **Le falta 4b2024** (que está
  traspapelado, ver abajo).
- **`historico_2014_2018/`** (recursivo): contiene tres grupos:
  - **Histórico real 2014-2019** (cubeta A): 18 archivos de datos + sus glosas.
    Régimen ancho. Subcarpetas con nombres inconsistentes (`idps2m2014/`,
    `IDPS4b2018/`, `idps8b2019/`…) y archivos con nombres heterogéneos
    (`idps2m2014_rbd.xls`, `idps_4b2018.xlsx`, `idps19_rbd.xlsx`).
  - **Duplicados 2022/2023** (cubeta B): 7 datos + 3 glosas. El censo confirmó los
    datos **byte-idénticos** a sus gemelos en la raíz.
  - **Material 2024** (cubeta C): en subcarpetas `2M/`, `4B/`, `6B/`. Aquí está el
    matiz crítico (ver §2.2).

### 2.2 El matiz de 2024 (lo que define las operaciones 1 y 3)

El censo, al detalle por grado:

- **`historico_2014_2018/2M/`** → `idps2M2024_rbd_{final,dim_final,niveles_final}`:
  **2m2024 YA está en la raíz** (`idps2m2024_rbd_*`). Estos son **duplicados
  presuntos** (verificar byte-identidad; si lo son, eliminar).
- **`historico_2014_2018/6B/`** → `idps6B2024_rbd_{preliminar,dim_preliminar,
  niveles_preliminar}`: **6b2024 YA está en la raíz** (`idps6b2024_rbd_*`).
  **Duplicados presuntos** (verificar; si lo son, eliminar).
- **`historico_2014_2018/4B/`** → `idps4B2024_rbd_{final,dim_final,niveles_final}`:
  **4b2024 NO está en la raíz.** Es un **ACTIVO ÚNICO** (I·D·S para 4b2024) que el
  motor no usa hoy porque no está donde `34` lee. **Se PROMUEVE a la raíz**,
  renombrando `4B`→`4b`.

La diferencia entre "duplicado a eliminar" (2m, 6b) y "activo a promover" (4b) se
decide por **presencia en la raíz**, verificada con md5, NO por el nombre de la
carpeta. Esta distinción es la lección de la fase 1: lo que parecía "todo 2024
ajeno" resultó contener un activo único.

### 2.3 Nomenclatura canónica de destino (derivada de la raíz actual)

La raíz usa el patrón
`idps{grado}{AAAA}_{familia}_{estado}.xlsx`, con grado en **minúscula**
(`2m`,`4b`,`6b`,`8b`), familias `rbd` / `rbd_dim` / `rbd_niveles` o
`rbd_subdim_niveles`, estado `final`/`preliminar`. Ejemplos reales de la raíz:
`idps4b2024_rbd_final.xlsx`, `idps2m2024_rbd_dim_final.xlsx`,
`idps2m2024_rbd_niveles_final.xlsx`.

**Para el 4b2024 promovido**, el destino es exactamente el nombre canónico que
tendría si hubiera estado en la raíz: `idps4b2024_rbd_final.xlsx`,
`idps4b2024_rbd_dim_final.xlsx`, `idps4b2024_rbd_niveles_final.xlsx` (es decir,
`4B`→`4b`; el resto del nombre ya es canónico).

### 2.4 Nomenclatura del histórico (subcarpeta `historico/`)

El histórico 2014-2019 va a `20_insumos/historico/` con nomenclatura **canónica y
uniforme**, resolviendo los tres regímenes de nombre actuales. Patrón propuesto:
`idps{grado}{AAAA}_rbd_historico.xlsx` (o conserva `.xls` para 2014-2016 si no se
convierte — ver nota). El criterio: nombre uniforme, parseable, sin tildes/ñ/
espacios, que distinga el régimen histórico del moderno. Mapeo origen→destino:

| Origen (subcarpeta/archivo) | Grado | Año | Destino en `historico/` |
|---|---|---|---|
| `idps2m2014/idps2m2014_rbd.xls` | 2m | 2014 | `idps2m2014_rbd_historico.xls` |
| `idps4b2014/idps4b2014_rbd.xls` | 4b | 2014 | `idps4b2014_rbd_historico.xls` |
| `idps6b2014/idps6b2014_rbd.xls` | 6b | 2014 | `idps6b2014_rbd_historico.xls` |
| `idps8b2014/idps8b2014_rbd.xls` | 8b | 2014 | `idps8b2014_rbd_historico.xls` |
| (2015: 2m,4b,6b,8b análogos) | | 2015 | `idps{g}2015_rbd_historico.xls` |
| (2016: 2m,4b,6b — sin 8b) | | 2016 | `idps{g}2016_rbd_historico.xls` |
| `idps2m2017/idps2m2017_rbd_final.xlsx` | 2m | 2017 | `idps2m2017_rbd_historico.xlsx` |
| `idps4b2017/idps4b2017_rbd_final.xlsx` | 4b | 2017 | `idps4b2017_rbd_historico.xlsx` |
| `idps8b2017/idps8b2017_rbd_final.xlsx` | 8b | 2017 | `idps8b2017_rbd_historico.xlsx` |
| `IDPS2m2018/idps_2m2018.xlsx` | 2m | 2018 | `idps2m2018_rbd_historico.xlsx` |
| `IDPS4b2018/idps_4b2018.xlsx` | 4b | 2018 | `idps4b2018_rbd_historico.xlsx` |
| `IDPS6b2018/idps_6b2018.xlsx` | 6b | 2018 | `idps6b2018_rbd_historico.xlsx` |
| `idps8b2019/idps19_rbd.xlsx` | 8b | 2019 | `idps8b2019_rbd_historico.xlsx` |

**Nota sobre `.xls` 2014-2016:** NO se convierten a `.xlsx` en esta fase (la
conversión es transformación de dato; si la fase 3 la necesita, la hará ahí). Se
mueven y renombran conservando `.xls`. Conservación: el formato original se
preserva.

**Glosas del histórico:** cada año tiene su glosa (`idps{AAAA}_rbd_GLOSAS.xlsx`),
varias repetidas en cada subcarpeta-grado del mismo año (la misma glosa 2014 está
en `idps2m2014/`, `idps4b2014/`, etc.). Llevar **una copia por año** a
`20_insumos/historico/glosas/` con nombre `idps{AAAA}_rbd_GLOSAS.xlsx` (deduplicar
las repetidas del mismo año — verificar byte-identidad entre las copias del mismo
año antes de quedarte con una). Conservar todas las glosas-año (2014-2019); son la
fuente para la homologación de la fase 3.

---

## 3. Invariantes (🔒)

- 🔒 **CONSERVACIÓN.** Solo se eliminan duplicados byte-idénticos VERIFICADOS y
  `.DS_Store`. Cualquier archivo cuya byte-identidad no se pueda confirmar contra
  un gemelo en la raíz, NO se borra: se conserva (y se reporta).
- 🔒 **COPIAR → VERIFICAR → ELIMINAR**, nunca `mv`/`rm` directo sobre dato. Toda
  promoción y todo movimiento se hace copiando al destino, verificando (md5 origen
  == md5 destino), y solo entonces eliminando el origen. Todo borrado de duplicado
  se hace tras confirmar md5(duplicado) == md5(gemelo en raíz).
- 🔒 **DRY_RUN PRIMERO.** Ninguna operación destructiva (copia, renombrado,
  borrado, retiro de carpeta) se ejecuta en modo real sin que el DRY_RUN haya
  emitido el plan completo y este cuadre con §4. `DRY_RUN <- TRUE` por defecto en
  el script.
- 🔒 **El pipeline NO se toca.** No editar `34`, `10_configuracion.R`, motores.
  No correr `run_all`. md5 de `idps_largo.parquet` byte-idéntico al inicio y al fin
  (`50d9de4f1fc80259d29f499cdf46d9e1`); si cambió, algo salió del alcance.
- 🔒 **Backups antes del modo real.** Antes de eliminar nada en modo real, la
  carpeta `historico_2014_2018/` completa se respalda (copia a
  `_archivo/YYYYMMDD/historico_2014_2018_prereorg/` conservando ruta relativa). Los
  backups se conservan hasta que el titular valide; NO se borran en este encargo.
  (`_archivo/` está gitignored; el respaldo es local, no entra a git.)
- 🔒 **Registro de cada movimiento** en `_archivo/log_reorganizacion.csv` (tipo,
  ruta vieja, ruta nueva, md5, ocurrencias, timestamp), según política 9.9.
- 🔒 **Llaves `character`** si se lee algún dato para verificación (no debería
  hacer falta más que md5).

---

## 4. Fases en orden estricto

### Fase A — Diagnóstico de referencias y backup (antes de mover nada)

1. Verifica y anota md5 de `idps_largo.parquet` (control 🔒).
2. **Diagnóstico de referencias literales** (política 9.1): busca en TODO `.R`/
   `.qmd` del proyecto referencias literales a las rutas que esta fase moverá o
   creará: `historico_2014_2018`, `historico/`, nombres de archivos 2024
   (`idps4b2024`, `idps4B2024`), `2M/`, `4B/`, `6B/`. Excluye `.Rproj.user`,
   `renv/`, `.bak`, `_archivo/`. **Reporta toda coincidencia.** Si algún script del
   pipeline referencia estas rutas literalmente, es caso de detención (c): el
   código habría que actualizarlo en fase 3, y mover antes rompería. (Expectativa:
   `34` lee por patrón de `dir_ls` sobre la raíz, no por nombres fijos del
   histórico; el 4b2024 promovido entrará al `dir_ls` de la raíz, lo cual es
   deseado. Confírmalo.)
3. **Backup** (🔒): copia `20_insumos/historico_2014_2018/` completa a
   `_archivo/YYYYMMDD/historico_2014_2018_prereorg/`. Verifica que la copia esté
   íntegra (conteo de archivos origen == copia) antes de proceder.

### Fase B — Construcción del plan + DRY_RUN

Escribe el script de reorganización efímero
`/Users/tomgc/Projects/slep_idps/reorganizar_universo_idps.R` (gitignored: cae en
`/verificar_*.R`? NO — usa un nombre que el `.gitignore` excluya, o agrégalo a la
exclusión local; NO lo versiones). Con `DRY_RUN <- TRUE`, el script construye y
reporta el plan completo SIN ejecutarlo:

1. **Plan de promoción 4b2024** (3 archivos `historico/4B/idps4B2024_*` → raíz
   `idps4b2024_*`), con md5 origen.
2. **Plan de verificación de duplicados:**
   - cubeta B (7 datos 2022/2023): confirmar md5(histórico) == md5(raíz). El censo
     dijo byte-idénticos; **re-verificar** aquí.
   - 2m2024 (3 archivos `historico/2M/`) y 6b2024 (3 archivos `historico/6B/`):
     confirmar md5(histórico) == md5(raíz, con grado en minúscula). Estos NO
     estaban verificados en el censo.
   - Para cada uno: si byte-idéntico → marcar "eliminar"; si NO → marcar
     "CONSERVAR + reportar" (caso de detención b, posible activo distinto).
3. **Plan de movimiento del histórico 2014-2019** (18 datos → `historico/` con
   nomenclatura canónica de §2.4; glosas-año dedup → `historico/glosas/`), con md5
   origen de cada uno.
4. **Plan de limpieza:** lista de `.DS_Store` a eliminar; retiro de la carpeta
   `historico_2014_2018/` (solo si queda vacía tras los movimientos).
5. **Reporte del DRY_RUN:** conteos por operación (N promovidos, N duplicados
   verificados-a-eliminar, N conservados-por-no-idénticos, N históricos movidos, N
   glosas dedup, N `.DS_Store`), y la tabla origen→destino completa.

**Autoverificación del DRY_RUN contra el plan (compuerta 🔒):** los conteos del
DRY_RUN deben cuadrar con lo esperado: 3 promovidos (4b2024); cubeta B = 7 datos +
3 glosas; 2m2024+6b2024 = 6 presuntos duplicados (a verificar); 18 históricos
movidos; glosas-año históricas dedup (una por año 2014-2019, con 2016 y 2019
teniendo menos grados). Si los conteos NO cuadran (p. ej. un "duplicado" resultó no
idéntico, o falta un archivo), **NO pases a modo real**: reporta la discrepancia.

### Fase C — Modo real (solo si el DRY_RUN cuadró)

Con `DRY_RUN <- FALSE`, ejecuta el plan en este orden (copiar→verificar→eliminar
en cada paso, registrando en `_archivo/log_reorganizacion.csv`):

1. Crear `20_insumos/historico/` y `20_insumos/historico/glosas/`.
2. **Promover 4b2024** a la raíz (copiar con nombre canónico, verificar md5,
   eliminar origen en `historico/4B/`).
3. **Mover histórico 2014-2019** a `historico/` con nomenclatura canónica
   (copiar-verificar-eliminar cada uno). Glosas-año dedup → `historico/glosas/`.
4. **Eliminar duplicados verificados:** cubeta B + los 2m2024/6b2024 que resultaron
   byte-idénticos. Cualquiera no idéntico se CONSERVA (movido a `historico/` o
   reportado, según qué sea).
5. **Limpiar** `.DS_Store`; retirar `historico_2014_2018/` si quedó vacía.
6. Cada operación registrada en el log CSV.

### Fase D — Reubicación del inventario del censo (cierre de la deuda de la fase 1)

El censo de la fase 1 dejó su reporte en `50_documentacion/activa/` (correcto) pero
su parquet de inventario en `40_salidas/intermedios/` (output de trabajo). No se
mueve; queda como está. (Esta fase NO toca el reporte del censo, solo reorganiza
`20_insumos/`.)

---

## 5. Criterios de éxito verificables (B.4)

1. **`20_insumos/historico/`** existe y contiene los 18 datos históricos 2014-2019
   con nomenclatura canónica `idps{g}{AAAA}_rbd_historico.{xls,xlsx}`, y
   `historico/glosas/` con una glosa por año.
2. **La raíz `20_insumos/`** contiene ahora `idps4b2024_rbd_final.xlsx`,
   `idps4b2024_rbd_dim_final.xlsx`, `idps4b2024_rbd_niveles_final.xlsx` (4b2024
   promovido). La cobertura 4b de la raíz queda 2022-2023-2024-2025.
3. **`historico_2014_2018/` ya no existe** (vacía y retirada), o si quedó algo, se
   reporta por qué (un archivo no idéntico conservado).
4. **Duplicados eliminados == solo los byte-idénticos verificados.** Reporta md5 de
   cada par confirmado. Ningún archivo borrado sin gemelo idéntico probado.
5. **Backup** en `_archivo/YYYYMMDD/historico_2014_2018_prereorg/` íntegro
   (conteo == original pre-reorg).
6. **`_archivo/log_reorganizacion.csv`** registra cada movimiento (tipo, ruta
   vieja, ruta nueva, md5, timestamp).
7. **md5 de `idps_largo.parquet` idéntico** al inicial. Reportado.
8. **`git status`** muestra solo: archivos nuevos bajo `20_insumos/historico/` y
   `20_insumos/idps4b2024_*` (untracked, a versionar — son Rama A pública), y las
   eliminaciones de los duplicados/histórico-viejo bajo `20_insumos/`. El
   `reorganizar_universo_idps.R`, el backup `_archivo/` y el CSV quedan sin
   versionar (gitignored).

---

## 6. Mandato de auto-auditoría (panel adversarial)

Fase de riesgo de datos (movimientos y borrados sobre insumos). Antes de reportar
"hecho", panel adversarial de SOLO LECTURA con código independiente:

1. **Integridad del movimiento:** un agente que confirma, para cada archivo del
   plan, que el destino existe y su md5 == md5 del backup correspondiente (el dato
   movido es bit-a-bit el mismo que antes de la reorg). Cero pérdida, cero
   corrupción.
2. **No-borrado de activos:** un agente que confirma que TODO lo eliminado tiene un
   gemelo byte-idéntico vivo (en la raíz, para los duplicados) o está en el backup
   (para todo lo demás). Que verifique explícitamente que 4b2024 NO fue borrado
   sino promovido (existe en la raíz con su md5 original).
3. **Cobertura post-reorg:** un agente que re-lista `20_insumos/` y confirma la
   matriz esperada: raíz con 2022-2025 + 4b2024 ahora presente; `historico/` con
   2014-2019 completo (18 datos); `historico_2014_2018/` ausente.
4. **Integridad del pipeline:** md5 de `idps_largo.parquet` intacto; ningún script
   del pipeline modificado.

Si el panel detecta discrepancia, **restaura desde el backup** y reporta; no dejes
el universo a medias. Documenta en el log qué auditó el panel.

---

## 7. Mandato del log y estado de cierre

1. **Log** en
   `50_documentacion/andamios/logs/YYYYMMDD_reorganizacion_universo_idps_log.md`
   (plantilla del protocolo: resumen, commits, reporte DRY_RUN vs real, cada
   operación con md5, auditoría con veredicto, invariantes 🔒 con PASA/FALLA, md5
   del parquet, notas para el revisor). Honesto: incluye lo que costó y cualquier
   archivo conservado por no ser idéntico.
2. **Commits.** Esta fase modifica `20_insumos/` (Rama A pública, se versiona).
   Commits atómicos temáticos:
   - `feat(insumos): promover 4b2024 traspapelado a la raiz (P5 fase 2)` — los 3
     archivos `idps4b2024_*` nuevos en la raíz.
   - `feat(insumos): organizar historico IDPS 2014-2019 en subcarpeta (P5 fase 2)`
     — el árbol nuevo `20_insumos/historico/` + las eliminaciones del histórico
     viejo y los duplicados bajo `20_insumos/`.
   - `docs(idps): log de reorganizacion del universo IDPS (P5 fase 2)` — el log.
   - **NO** `git add .`/`-u`. Agrega por ruta. El script efímero, el backup
     `_archivo/` y el CSV NO se versionan.
   - **NO** push. El titular revisa y valida (puede correr el pipeline) antes.

---

## 8. Reporte final (qué vuelve al chat)

1. **Resultado del DRY_RUN vs real:** conteos por operación, y si todo cuadró.
2. **4b2024 promovido:** confirmación de los 3 archivos en la raíz con md5.
3. **Histórico organizado:** árbol de `20_insumos/historico/` (18 datos + glosas).
4. **Duplicados eliminados:** lista con md5 del par (duplicado == gemelo raíz).
   Cualquier archivo CONSERVADO por no ser idéntico, destacado.
5. **Veredicto del panel adversarial:** qué auditó, qué encontró.
6. **Invariantes:** md5 parquet inicio/fin, backup íntegro, `git status`, los
   commits con hashes.
7. **Estado de `historico_2014_2018/`:** retirada, o qué quedó y por qué.
8. **Rutas** del log y del backup.
9. **NO inicies la fase 3** (integración a `34`). Detente. La fase 3 enseñará a `34`
   a leer la subcarpeta `historico/` con su patrón ancho y a homologar los tres
   esquemas; la redactará el asistente tras validar esta reorganización.

---

## 9. Recordatorio de reparto (dual-Claude)

Tú (Claude Code) ejecutas: terminal, DRY_RUN, copia-verificación-eliminación,
commits, panel adversarial, log. **NO** decides qué se descarta más allá de los
duplicados byte-idénticos verificados (la regla es mecánica: idéntico→elimina,
no-idéntico→conserva+reporta). **NO** tocas el pipeline ni rediseñas la lectura
(fase 3). **NO** conviertes `.xls` a `.xlsx` (transformación de dato, fase 3). Si
algo no cuadra, restauras del backup y reportas; el universo nunca queda a medias.
