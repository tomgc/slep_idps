# Traspaso de cierre — slep_idps — v05

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS por establecimiento, hermano de `slep_simce_adecuado`).
- **Versión:** v05.
- **Fecha:** 2026-06-19.
- **Sesión:** 5. Foco: **decisión de ponderación/alcance (P4) + construcción del pipeline
  productivo completo (31→35) + motor HTML nacional desplegado en GitHub Pages.**
  La sesión que el reapertura de v04 anticipó como "decisión P4 + pipeline": se ejecutó
  entera, llevando el proyecto de scaffold sin pipeline a plataforma nacional pública.
- **Entorno:** R 4.5.2 / Positron / zsh (macOS aarch64) / Claude Code (Opus 4.8). Rama A
  (datos públicos, raíz unificada).
- **Archivos principales modificados/creados:** `00_build.R` (orquestador `run_all`);
  `10_utils/10_configuracion.R` (crosswalk + constantes); `10_utils/{d3,pako}.min.js`
  (libs inline nuevas); `30_procesamiento/31_depurar_directorio_oficial.R` (fix encoding);
  `30_procesamiento/33_construir_catalogos.R`, `34_leer_normalizar_idps.R`,
  `35_generar_motor_html.R`, `35_motor_template.html` (nuevos); `40_salidas/intermedios/*.parquet`
  (idps_largo, catalogo_idps, comunas/sleps/establecimientos_chile); `40_salidas/motor_idps.html`;
  `docs/index.html` (deploy); `CLAUDE.md`; `decisiones/20260612_decision_ponderacion_idps.md`
  (versionada); `andamios/diseno/` (versionado).

## 2. Resumen ejecutivo

Sesión de altísimo avance: el proyecto pasó de un `00_build.R` stub sin pipeline a una
**plataforma nacional pública desplegada**. Se versionó la decisión de ponderación de la
sesión 5 (P4 cerrado: **sin agregación territorial**; el motor muestra el dato al nivel en
que la Agencia lo publica, el establecimiento). Se cerró la Prioridad 1 (orquestador
`run_all()`, conexión de `10_configuracion.R`, gobernanza de sesión 5 versionada). Se
construyó **P6** completo: lectura de las 3 familias (rbd/rbd_dim/niveles) para 4 grados ×
2022-2025, **homologación del esquema texto↔id por año**, resolución de la inconsistencia de
`cod_depe2` entre familias, join que trae GSE a la familia niveles, y emisión de
`idps_largo.parquet` (**1.485.103 filas**, sin agregación). Se corrigió el encoding del
directorio (el crudo era UTF-8, no latin1) y se serializaron los textos de nivel por ciclo.
Se construyó el **motor HTML** (`35`): grilla de radares por establecimiento agrupada por GSE,
detalle con drill-down indicador→dimensión→subdimensión, **GSE de referencia como eje
interpretativo central** (doble ancla `difgru`/`dif` con número, significancia y alerta),
tendencia con eje fijo 0-100, distribución de niveles por subdimensión EST con texto por ciclo,
fuentes de marca embebidas. Se amplió a **todo Chile** (8.353 establecimientos, 16 regiones)
con **navegación territorial** región→SLEP/comuna→establecimiento, y se **desplegó a
`docs/index.html`** (pusheado a `origin/main`). Validado: `run_all()` de cero OK (27 s),
spot-checks motor↔parquet 1:1 dentro y fuera de Valparaíso, render sin errores de consola,
decode del JSON nacional ~340 ms. **Pendiente único de terceros:** activar GitHub Pages
(paso manual del titular en settings remotos).

## 3. Estado al cierre

**Qué funciona (con última verificación):**
- **Pipeline completo `run_all()` 31→35** corre de cero sin error (última corrida 2026-06-19,
  27,1 s: 31=0,2s · 32=7,3s · 33=0,1s · 34=16,4s · 35=3,1s).
- **`idps_largo.parquet`** (1.485.103 filas × 30 columnas, por establecimiento-grado).
  Spot-check contra xlsx crudo: 2m 2022 (texto) y 2025 (id), indicador/dimensión/niveles → 1:1.
- **Catálogos**: `catalogo_idps.parquet` (30 subdim, 22 EST con id y texto por ciclo),
  `comunas_chile`/`sleps_chile`/`establecimientos_chile` (UTF-8 limpio verificado).
- **Motor `40_salidas/motor_idps.html`** (6,5 MB, todo Chile): abre y renderiza; decode 339 ms,
  índice de rangos 7 ms, render 1 ms; 0 errores de consola; navegación, GSE doble ancla,
  drill-down, tendencia 0-100 y distribución verificados en navegador.
- **Deploy `docs/index.html`** (copia self-contained) sirve por HTTP local 1:1; commit `eabeec3`
  en `origin/main`.
- Spot-check **fuera de Valparaíso**: RBD 10000 (Metropolitana), 4b 2023 → motor↔parquet 1:1.

**Qué no funciona / pendiente de terceros:**
- **GitHub Pages no está activo** (repo PRIVADO, 404 en la API de Pages). Activación = paso
  manual del titular (settings remotos; ver §11 y §14). El HTML ya está pusheado y listo.

**Delta respecto a v04:** v04 cerró sin código ejecutable (00_build stub, sin pipeline,
diagnóstico de P4 abierto). v05 cierra con **pipeline productivo completo (31→35), motor
nacional desplegado y validado**, P4 resuelto y materializado, P3 cerrado como "no aplica".
Es el salto de "scaffold + diagnóstico" a "producto público".

## 4. Registro detallado de cambios

**Cambio 29 — Decisión de ponderación territorial y alcance del motor (sesión 5).**
Categoría: Visualización / diseño. Qué: se cerró P4 con la decisión vinculante de **no construir
ningún consolidado territorial** (ninguna fuente IDPS publica respondentes → no hay ponderador
válido); el motor muestra el dato por establecimiento y usa `difgru`/`sigdifgru` y `dif`/`sigdif`
(que la Agencia ya calcula por fila) como comparaciones. Por qué: inmutabilidad de la fuente
(C.5.2.1) + no mezclar universos distintos. Cómo se verificó: documento
`decisiones/20260612_decision_ponderacion_idps.md` (versionado en cambio 31). Implicancia:
P3 muere ("no aplica"); P6 pierde el paso de agregación; P9 se reorienta a grilla por GSE.

**Cambio 30 — Orquestador `run_all()` + conexión de configuración (Prioridad 1).**
Categoría: Infraestructura y scaffold. Qué: se reescribió `00_build.R` del stub al patrón
`run_all(from/to/only/skip)` de `slep_categoria_desempeno` (ancla con `rprojroot`, bootstrap de
utils, `PASOS` con id=prefijo, `tryCatch` + `chdir`, `regenerar_motor()=run_all(only=35)`),
**cargando `10_configuracion.R`** (antes definido pero muerto). Sin etapa de agregación. Por qué:
deuda heredada barata que desbloquea iterar; el orquestador aludía a nombres comentados que
chocaban con `31`/`32` reales. Verificado: `run_all()` end-to-end OK.

**Cambio 31 — Gobernanza de la sesión 5 versionada + archivado de residuo.**
Categoría: Limpieza / deuda técnica. Qué: se versionaron la decisión de ponderación y los
andamios del prototipo (`motor_idps/`); se archivó a `_archivo/` el residuo duplicado de
`andamios/diseno/` (`PROMPT.md`, `slep_idps_fuente_completa.md`, `Simce IDPS.zip`). Por qué:
política §3 (commit limpio) y §1.5 (archivar, no borrar). Verificado: `git status` limpio.

**Cambio 32 — Catálogos territoriales + jerárquico IDPS (`33_construir_catalogos.R`).**
Categoría: Pipeline / motor (código productivo). Qué: desde el directorio público se construyen
`comunas_chile`/`sleps_chile` (dos ramas de traspaso)/`establecimientos_chile`; desde el corpus
`.json` se arma el **catálogo jerárquico de 4 niveles** (30 subdimensiones), adjuntando los ids
numéricos de la Agencia por **match de nombre normalizado** (3 alias documentados) con
aserciones duras (22 EST con id, 8 DOC/PAD sin niveles). Verificado: 30 subdim, 22 EST con id.

**Cambio 33 — P6: lectura/normalización/homologación/join (`34_leer_normalizar_idps.R`).**
Categoría: Pipeline / motor (código productivo). Qué: lee las 3 familias para 2m/4b/6b/8b y
2022-2025; **homologa el esquema texto↔id por año** (`ind`/`dim`/`sdim` → `id_*` vía `CW_*`);
toma `grado`/`agno` del nombre de archivo (la columna `grado` del dato es inconsistente "2" vs
"2m"); resuelve `cod_depe2` canónico por RBD; **join que trae GSE a la familia niveles**; NA =
supresión; emite `idps_largo.parquet`. Verificado: validaciones de jerarquía/dominios/llave +
spot-check 1:1.

**Cambio 34 — Fix de encoding del directorio público (`31_depurar`).**
Categoría: Limpieza / deuda técnica (bug). Qué: el crudo `directorio_oficial_ee.csv` está en
**UTF-8** (no latin1, como suponía `31`); leerlo mal producía doble codificación (CONCÓN→mojibake)
en `comunas_chile`/`sleps_chile`. Corregido a `encoding="UTF-8"`. Verificado por bytes:
VALPARAÍSO `c3 8d`, CONCÓN `c3 93`, VIÑA `c3 91` (un solo codepoint).

**Cambio 35 — Serialización de textos de nivel por ciclo al catálogo.**
Categoría: Documentación conceptual / contenido. Qué: se anexaron a `catalogo_idps.parquet` la
`definicion` y 6 columnas `nivel_{basica,media}_{bajo,medio,alto}` desde el corpus; solo EST;
2 niveles → `medio=NA`; 8b sin texto (vía `ciclo_texto=NA`). Verificado: 22 EST con texto
básica+media.

**Cambio 36 — Motor HTML base (`35_generar_motor_html.R` + `35_motor_template.html`).**
Categoría: Visualización / diseño. Qué: motor autocontenido que replica el mecanismo del madre
(JSON→gzip→base64→pako; D3/pako inline; React CDN+SRI) sobre el modelo nuevo: grilla de radares
por establecimiento agrupada por GSE, detalle con radar indicador/dimensión, distribución de
niveles, marca de desvío. Alcance base: Región de Valparaíso. Verificado: render local, 0
errores, spot-check 1:1.

**Cambio 37 — Ampliación a todo Chile + navegación territorial.**
Categoría: Visualización / diseño. Qué: el universo embebido pasó de Región 5 a **todo Chile**
(8.353 establecimientos, 16 regiones); catálogos territoriales nacionales; **navegación
jerárquica región→SLEP/comuna→establecimiento** (foco Costa Central por defecto). Invariante:
el territorio solo acota la lista, nunca agrega. Verificado: 3 regiones navegables con nombres
UTF-8 limpios.

**Cambio 38 — GSE de referencia como eje interpretativo central.**
Categoría: Visualización / diseño. Qué: por cada cifra de establecimiento, **doble ancla**
siempre visible (vs su GSE `difgru`/`sigdifgru` y vs año anterior `dif`/`sigdif`) con número +
significancia + color de alerta (rojo bajo / verde sobre); resumen de alertas en cada tarjeta;
banner que explica la escala relativa. Verificado: detalle con "▼−13 ·sig" en ambas anclas.

**Cambio 39 — Jerarquía con drill-down + tendencia eje fijo 0-100.**
Categoría: Visualización / diseño. Qué: drill-down completo indicador→dimensión→subdimensión con
breadcrumb (cierra P8), sin perder el contexto del establecimiento; tendencia con eje **fijo
0-100** (nunca autoescala), sin interpolar huecos, deshabilitada con un solo año. Verificado:
Clima ▸ Ambiente de respeto → 2 subdim con distribución + texto.

**Cambio 40 — Fuentes de marca embebidas + estética/pulido.**
Categoría: Visualización / diseño. Qué: gobCL + Museo Sans embebidas en base64 (self-contained
real); paleta canónica, header azul, fondo cream; formato chileno (coma decimal); terminología
"establecimiento educacional"; leyenda preliminar (2025) y supresión explícita. Verificado:
header en gobCL, render correcto.

**Cambio 41 — Deploy a GitHub Pages (`docs/index.html`).**
Categoría: Infraestructura y scaffold. Qué: copia self-contained del motor a `docs/index.html`
(patrón de `slep_categoria_desempeno`); commit `eabeec3` pusheado a `origin/main`. Pendiente:
activación de Pages (paso manual del titular). Verificado: `docs/index.html` sirve por HTTP local.

## 5. Backlog acumulativo

### Objetivo del proyecto

`slep_idps` es un motor de comparación interactivo de los Indicadores de Desarrollo Personal y
Social (IDPS) de la Agencia de Calidad de la Educación. Produce un HTML autocontenido (React 18
+ D3 v7) publicado en GitHub Pages que muestra el dato **por establecimiento educacional**,
segmentado por grupo socioeconómico (GSE), para el equipo de Monitoreo y Seguimiento del SLEP
Costa Central y, desde v05, para cualquier SLEP/comuna del país. Hermano de `slep_simce_adecuado`,
del que reutiliza catálogos, patrones de generación HTML, escáner y estética. Activo desde
2026-06-11; desplegado nacionalmente desde 2026-06-19.

### Nota metodológica

Un "cambio" es una solicitud distinguible del usuario, no las acciones técnicas que la
implementan. No cuentan los errores del asistente corregidos en el acto; sí cuentan los bugfixes
reportados por el usuario. Clasificación por intención primaria. Fuente del conteo: registro
detallado de cada traspaso.

### Clasificación temática (recalculada en v05)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 5 | 12% | Estructura, stubs, git, repo remoto, orquestador run_all, deploy |
| Gobernanza de datos | 4 | 10% | Verificación sensibilidad, decisión Rama A, depuración directorio, ignore |
| Visualización / diseño | 10 | 24% | Prototipo, feedback, decisión de alcance, motor base, nacional, GSE eje, drill-down, estética |
| Perfilado / exploración de datos | 4 | 10% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 7 | 17% | P1-P2, commits atómicos, consolidación 20_insumos, gobernanza s5, fix encoding |
| Documentación conceptual / contenido | 9 | 22% | Corpus dual IDPS, niveles por ciclo, reconciliación, serialización de textos de nivel |
| Pipeline / motor (código productivo) | 2 | 5% | Catálogos (33) y lectura/normalización (34) — categoría nueva en v05 |

(41 cambios acumulados a v05. **Categoría nueva** "Pipeline / motor (código productivo)" para el
código de datos productivo, inexistente hasta v05. Dominantes: Visualización/diseño 24%,
Documentación conceptual 22%, Limpieza/deuda técnica 17%; ninguna supera el 25%.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| 5 | v05 | 13 | Opus 4.8 | Decisión P4/alcance + pipeline 31→35 + motor nacional + deploy Pages |
| **Total** | | **41** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02).
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). Cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver traspaso v04). Diagnóstico de P4, feedback prototipo.
- Sesión 5 (2026-06-12 decisión / 2026-06-19 implementación): cambios 29–41 (ver §4). Decisión
  P4/alcance + pipeline completo 31→35 + motor nacional + deploy. Subtítulos: *Decisión y
  Prioridad 1* (29-31), *Pipeline P6* (32-35), *Motor* (36-40), *Deploy* (41).

### Delta del backlog

13 entradas nuevas (29–41). **Refinamiento de taxonomía:** se agrega la categoría "Pipeline /
motor (código productivo)" (el proyecto produjo su primer código de pipeline). Porcentajes
recalculados sobre el nuevo total de 41. Crecen Visualización/diseño y Documentación; aparece
Pipeline/motor.

## 6. Bugs de la sesión

**Bug 1 — `sigdifgru` interpretado como significancia binaria.** Síntoma: el detalle mostraba
"no significativo" para un establecimiento con `sigdifgru=-1` y desvío real. Causa raíz: el
código asumía `significativo = (sigdifgru===1)`; el esquema real de la Agencia es **{−1,0,+1} =
significativamente bajo / no significativo / significativamente alto**. Solución:
`significativo = sigdifgru!=null && sigdifgru!==0` (`35_motor_template.html`, MarcaDesvio/Ancla).
Verificación: contra 39.285 casos, el signo de `sigdifgru` coincide 100% con el de `difgru`
(17.405 en −1, 21.880 en +1, 0 inconsistencias). **Regla aprendida:** la semántica de
significancia se lee de la glosa/datos, no se asume codificación binaria. Estado: resuelto.

**Bug 2 — Mojibake en las etiquetas de grado (°/á).** Síntoma: el motor mostraba "4&lt;c2&gt;&lt;b0&gt;
b&lt;c3&gt;&lt;a1&gt;sico" en vez de "4° básico". Causa raíz: en locale C, R marca los literales no-ASCII
de `GRADO_LABELS` con Encoding "unknown" y `jsonlite` los degrada al serializar. Solución:
`Encoding(grados_lbl) <- "UTF-8"` antes de armar el JSON (`35_generar_motor_html.R`). **Regla
aprendida:** forzar Encoding UTF-8 (o `intToUtf8`) a todo literal no-ASCII antes de serializar a
JSON en sesiones de locale C. Estado: resuelto.

**Bug 3 — Doble codificación de los catálogos territoriales.** Síntoma: `comunas_chile`/`sleps_chile`
con CONCÓN→mojibake. Causa raíz: `31_depurar` leía el crudo del directorio como **latin1**, pero
el crudo está en **UTF-8** (las tildes vienen como bytes `C3xx`); releerlo mal y reescribir
producía doble codificación. Solución: `encoding="UTF-8"` en la lectura. **Regla aprendida:**
diagnosticar el encoding real por bytes antes de asumir; no confiar en la suposición heredada.
Estado: resuelto.

**Bug 4 — `cod_depe2` inconsistente entre familias del propio dato IDPS.** Síntoma: la tabla de
atributos tenía 583 llaves `(rbd,agno,grado)` duplicadas (p.ej. 2022 RBD 1: `rbd`=1 Municipal vs
`rbd_dim`=4 SLEP). Causa raíz: la Agencia no actualiza `cod_depe2` en todas las tablas. Solución:
homologar a un valor **canónico por RBD** (familia indicador, año más reciente, esquema 4-cat
IDPS). Hallazgo asociado: el **directorio oficial usa un esquema de 5 categorías** (SLEP=5),
distinto del IDPS de 4 (SLEP=4) — no se mezclan. **Regla aprendida:** un mismo código puede venir
inconsistente entre tablas de la misma fuente y diferir entre fuentes; homologar a un canónico
declarado, no leer fila a fila. Estado: resuelto.

**Bug 5 — `subscript out of bounds` al construir el catálogo jerárquico.** Síntoma: `33` abortaba.
Causa raíz: indexación con `[[` sobre vector nombrado **lanza error** ante clave ausente (esperaba
`NULL`). Solución: indexación con `[` + chequeo `is.na`. **Regla aprendida:** en R, `vec[["x"]]`
con `"x"` ausente es error, no `NULL`; usar `vec["x"]` para tolerar ausencias. Estado: resuelto.

**Bug 6 — Subdimensión del corpus sin match contra la Agencia.** Síntoma: la aserción "22 EST con
id" fallaba por 1. Causa raíz: el corpus dice "Promoción de vida activa" y la glosa "Promoción de
**la** vida activa". Solución: tercer alias en el emparejador por nombre normalizado. **Regla
aprendida:** el emparejamiento corpus↔Agencia exige normalización + alias para variantes de
nombre (consistente con `_meta.variantes_nombre`); validar con conteo exacto y fallar fuerte.
Estado: resuelto.

## 7. Aprendizajes y restricciones descubiertas

- **El esquema de identificadores migra de texto a id numérico por año** (`ind`/`dim`/`sdim`
  2022-2024 → `id_*` 2025). Principio: C.6 (rigor de esquema). Homologar a un vocabulario único
  (id numérico) vía `CW_*` antes de cualquier bind; un bind ingenuo duplica columnas y pierde
  filas. Ejemplo: el crosswalk se verificó porque el orden de la Agencia ≠ orden del corpus en
  Hábitos (41 = vida activa, no alimenticios).
- **`grado` del dato es inestable** ("2" en 2022-2023 vs "2m" en 2024-2025). Usar el grado del
  nombre de archivo, no el de la columna.
- **La familia `niveles` no trae GSE/dependencia**: join obligatorio con la familia indicador por
  `(rbd, agno, grado)`, validando conteo pre/post (no duplicar).
- **Rendimiento de datos grandes**: con 1,5M filas, el cuello es `JSON.parse`, no Babel ni D3.
  Solución: columnar **ordenado por rbd** + índice de rangos en cliente (no materializar objetos);
  decode ~340 ms. No fue necesario Babel build ni recorte de D3.
- **GitHub Pages en repo privado** requiere plan pagado o repo público; es un setting remoto del
  titular.

## 8. Decisiones de diseño

**D1 — Sin agregación territorial (marco rector).** Decisión 2026-06-12 (`decisiones/`).
Alternativas: (a) ponderar por matrícula; (b) promedio simple; (c) `prom` pre-agregado de la
Agencia; (d) no agregar (elegida). Justificación: ninguna fuente publica respondentes → cualquier
agregación mezcla universos no equivalentes y produce una cifra indefendible. Implicancia: P3
muere; el motor muestra establecimiento; territorio = navegación/filtro. **Ratificada por el
titular esta sesión.**

**D2 — `cod_depe2` canónico por RBD.** Alternativas: (a) leer fila a fila (rompe por
inconsistencia entre familias); (b) directorio oficial (esquema 5-cat, incompatible); (c) valor
canónico por RBD de la familia indicador, año más reciente, esquema 4-cat IDPS (elegida).
Justificación: resuelve la inconsistencia y mantiene el esquema canónico del proyecto (4=SLEP).
Implicancia: la dependencia vigente se aplica a toda la serie. **Ratificada.**

**D3 — "Comparar" = grilla por GSE + desvío, nunca línea absoluta del GSE.** Decisión 2026-06-12
§5. El GSE de referencia es el **eje interpretativo central**: la escala 0-100 es relativa; las
anclas son `difgru`/`sigdifgru` (vs GSE) y `dif`/`sigdif` (vs año anterior), con significancia.
**Prohibido** derivar `prom − difgru` (línea absoluta del GSE, no publicada). **Ratificada y
elevada a protagonista de la UI esta sesión.**

**D4 — Alcance nacional completo embebido.** Alternativas: (a) Región 5; (b) carga diferida por
región; (c) todo Chile completo (elegida). Justificación: el titular fijó "todo Chile obligatorio"
(abrir a otros SLEP, explorar cualquier comuna); 8.353 establecimientos caben en 6,5 MB con
rendimiento bueno. **Ratificada.**

**D5 — Navegación territorial de primer nivel** región→SLEP/comuna→establecimiento; el territorio
acota la lista, nunca agrega. **Ratificada.**

**D6 — Tendencias con eje fijo 0-100**, nunca autoescalado (la escala es común y comparable).
**Ratificada (invariante duro).**

**D7 — Serialización columnar ordenada por rbd + índice de rangos en cliente.** Justificación:
decode ~340 ms con 1,5M filas; por eso **no** se hizo Babel build ni recorte D3 (innecesarios).
Se mantiene React/Babel por CDN+SRI (patrón hermano).

**D8 — Fuentes gobCL/Museo Sans embebidas en base64** (self-contained real para Pages).

**D9 — Gobernanza: publicación nacional nominal.** Datos públicos (repositorio de la Agencia);
el titular confirmó la publicación nacional con nombres de establecimiento. El motor no expone
ningún dato por estudiante ni RUT. **Ratificada (gobernanza zanjada).**

## 9. Constantes y parámetros vigentes

| Constante | Valor / contenido | Archivo |
|---|---|---|
| `CW_INDICADOR` | AM=1, CC=2, PF=3, HV=4 | `10_configuracion.R` |
| `CW_DIMENSION` | AA=11, ME=12, AR=21, AO=22, AS=23, PA=31, VD=32, SP=33, VA=41, HA=42, AC=43 | `10_configuracion.R` |
| `CW_SUBDIMENSION` | 22 códigos texto → id 3 dígitos (verificado vs datos 2025) | `10_configuracion.R` |
| `GRADO_LABELS` | 4b/6b/8b/2m → etiquetas (UTF-8 forzado al serializar) | `10_configuracion.R` |
| `GRADO_CICLO_TEXTO` | 4b/6b→basica, 2m→media (8b omitido: sin texto) | `10_configuracion.R` |
| `NOMBRES_REGION` | 1..16 → nombres oficiales | `10_configuracion.R` |
| `DEPENDENCIAS` | cod_depe2 1..4 (4=SLEP) — esquema IDPS, NO el del directorio (5-cat) | `10_configuracion.R` |
| `GSE_LABELS` | 1..5 (Bajo..Alto) — segmentación inviolable | `10_configuracion.R` |
| `ANIO_DATOS_VIGENTE` | 2025L (ramas de traspaso SLEP) | `33_construir_catalogos.R` |
| `REGION_FOCO` | "5" (default de navegación) | `35_generar_motor_html.R` |
| Alcance del motor | TODO CHILE (16 regiones, 8.353 establecimientos) | `35_generar_motor_html.R` |
| Paleta indicadores | 1 #EE2D49, 2 #FFC92E, 3 #9BC93E, 4 #2A8FD9 | `35_*` |
| Esquema `idps_largo.parquet` | 30 cols: rbd, agno, grado, ciclo_texto, preliminar, familia, id_indicador, id_dimension, id_subdimension, cod_grupo, cod_depe2, geo(6), prom, dif, sigdif, difgru, sigdifgru, mdif, mdifgru, niv_{bajo,medio,alto}_por, niv_m{bajo,medio,alto}_por | `34_*` |

## 10. Arquitectura de archivos

Estructura conforme a Rama A. Escáner re-corrido al cierre (ver
`50_documentacion/estructura/estructura_actual.{md,txt}`, snapshot más reciente). Cambios de
estructura en v05: `30_procesamiento/` ahora tiene `31`–`35` + `35_motor_template.html`;
`10_utils/` suma `d3.min.js` y `pako.min.js` (libs inline); `40_salidas/intermedios/` suma
`idps_largo.parquet`, `catalogo_idps.parquet`, `comunas/sleps/establecimientos_chile.parquet`;
`40_salidas/motor_idps.html`; **`docs/index.html`** (deploy). `andamios/diseno/motor_idps/`
versionado (congelado). `_archivo/20260619/` con el residuo archivado (fuera de Git).

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **PD-Pages — Activar GitHub Pages.** Tipo: bloqueante de publicación / **paso manual del
  titular** (settings remotos). Impacto: alto (sin esto el sitio no es público). Complejidad: baja.
  Pasos: (1) si plan Free → Settings→General→Change visibility→Public; (2) Settings→Pages→Source
  "Deploy from a branch"→Branch `main`, Folder `/docs`→Save; (3) ~1 min → `https://tomgc.github.io/slep_idps/`.
  Criterio de éxito: la URL responde 200 con el motor. Precaución: el asistente NO toca settings
  remotos.
- **P7-iter — a11y exhaustiva y responsive móvil.** Tipo: mejora. Impacto: medio. Complejidad:
  media. Hoy a11y/responsive "razonables", no exhaustivos. Criterio: navegación por teclado, ARIA,
  contraste AA, layout móvil.
- **P8-iter — virtualización de la grilla** para comunas muy grandes. Tipo: deuda técnica/rendimiento.
  Impacto: bajo (hoy gateada por la navegación; bien hasta cientos). Complejidad: media.
- **P-meta — sección metodológica del motor** desde el corpus (definiciones de indicador/dimensión).
  Tipo: contenido. Impacto: medio (interpretabilidad). Complejidad: media. El corpus ya está
  serializado (definiciones en el catálogo).
- **P-8b — verificación visual fina de la vista de niveles en 8° básico** (texto "no disponible").
  Tipo: QA. Impacto: bajo. Código presente, probado en 4b; falta inspección visual de 8b.
- **P-opc — opcionales:** Babel build previo (soltar CDN), vista comparativa lado-a-lado de
  establecimientos seleccionados, microinteracciones/transiciones. Tipo: mejora. Impacto: bajo.
- **P10-bis — versionar/documentar `generar_md.py`/`inyectar_niveles.py`** (scripts del corpus).
  Tipo: deuda menor. Impacto: bajo. Pendiente desde v03; localizar ruta o documentar que el `.md`
  es derivado.
- **P10-ter — repoblar textos de nivel ante ediciones futuras del corpus.** Tipo: mantención de
  contenido. Impacto: bajo. **Reincorporado explícitamente** (estaba sin nota de cierre desde v04):
  sigue abierto como tarea de mantención cuando la Agencia publique nuevas ediciones.

### Evaluación de deuda técnica

Zonas frágiles: el motor depende de React/Babel por CDN (unpkg) — funciona pero acopla a la red;
el Babel build previo lo eliminaría (P-opc). El catálogo jerárquico depende del match de nombre
corpus↔Agencia (3 alias); cualquier nueva edición del corpus puede requerir un alias más (aserción
dura lo detectará). `docs/index.html` es copia manual de `40_salidas/motor_idps.html`: republicar
siempre re-corriendo `run_all(only=35)` y copiando (o automatizar la copia en `35`).

### Auditoría de cierre (POLÍTICA 5.6)

- ¿Datos crudos aislados e inmutables? → **Sí**; xlsx fuente read-only; crudo del directorio (con
  RUT) ignorado, solo el `_publico.csv` versionado.
- ¿El pipeline corre de cero sin intervención manual? → **Sí**; `run_all()` 31→35 OK (27 s).
- ¿Cada transformación crítica tiene check de validación? → **Sí**; `stopifnot` de jerarquía,
  dominios, llave y conteo pre/post join en 33/34.
- ¿Outputs reproducibles e idempotentes? → **Sí**; escritura atómica (tmp+rename), arrow
  determinista (parquets byte-idénticos entre corridas).
- ¿Decisiones metodológicas como constantes nombradas? → **Sí**; `CW_*`, `GRADO_*`, `DEPENDENCIAS`,
  `REGION_FOCO`, paleta.
- ¿Nombres sin tildes/ñ/espacios? → **Sí** en código/carpetas; los xlsx fuente y andamios conservan
  nombres heredados (excepción declarada).

Ninguna respuesta "no": la auditoría no agrega pendientes nuevos.

### Ruta sugerida para la próxima sesión

1. **PD-Pages** (titular): activar Pages y verificar la URL 200. Llave de la publicación.
2. **P-meta** (sección metodológica) + **P-8b** (QA visual de niveles 8b): completan la
   interpretabilidad y cierran un hueco de QA conocido.
3. **P7-iter** (a11y/responsive): pulido de producto para uso amplio.
4. Diferir P8-iter, P-opc, P10-bis/ter salvo necesidad. Si se itera la UI, partir de
   `35_motor_template.html` + `35_generar_motor_html.R` y **republicar a `docs/` re-corriendo
   `run_all(only=35)` + copia** (o automatizar la copia en `35`).

## 12. Instrucciones específicas para la próxima sesión

- 🔒 **Cero agregación territorial** (también nacional): el territorio navega y acota qué
  establecimientos se listan; la grilla es de radares por establecimiento **individual** agrupada
  por GSE. Nunca "promedio de comuna/SLEP".
- 🔒 **Leer, no derivar**: `prom`, `niv_*_por`, `dif`/`sigdif`/`difgru`/`sigdifgru` se leen tal como
  vienen. **NO reconstruir la línea absoluta del GSE** (`prom − difgru` prohibido).
- 🔒 **GSE de referencia = eje interpretativo central** (desvío + significancia), no marca
  secundaria. La escala 0-100 es relativa.
- 🔒 **`sigdifgru`/`sigdif` ∈ {−1,0,+1}** = significativamente bajo / no significativo /
  significativamente alto. No tratar como binario.
- 🔒 **Tendencias con eje fijo 0-100**, nunca autoescalado.
- 🔒 **Supresión = NA, nunca cero.** **Niveles solo EST; 8b sin texto** de nivel.
- 🔒 **No mezclar** indicadores/dimensiones/grados/años en una misma cifra.
- 🔒 **`cod_depe2` esquema IDPS 4-cat (4=SLEP)**, NO el del directorio (5-cat, SLEP=5).
- 🔒 **El deploy vive en `docs/index.html`** y se republica desde ahí (copia de
  `40_salidas/motor_idps.html`).
- 🔒 **Andamios congelados**: `50_documentacion/andamios/` no se edita (se lee/replica). Las fuentes
  se leen de ahí en build.
- ✅ ANTES de cualquier bind entre años, homologar texto↔id con `CW_*` (esquema migra por año).
- ✅ ANTES de tomar `grado`/atributos, usar el nombre de archivo (grado) y el canónico por RBD
  (depe2/geo), no la columna cruda inconsistente.
- ✅ ANTES de serializar literales no-ASCII a JSON en locale C, forzar `Encoding<-"UTF-8"` /
  `intToUtf8`.
- ✅ ANTES de emparejar subdimensiones corpus↔Agencia, normalizar nombres y usar/añadir alias;
  validar con conteo exacto (22 EST) y fallar fuerte.
- ✅ ANTES de editar el corpus, recordar que el `.md` es derivado del `.json`: editar el JSON.
- ⚠️ NO activar Pages ni tocar settings remotos del repo sin el titular (es su paso manual).
- ⚠️ NO republicar `docs/` sin re-correr `run_all(only=35)` (que el HTML refleje el pipeline).

## 13. Fragmentos de código de referencia

```r
# Homologación texto↔id por año (CW_* en 10_configuracion.R). Mapea o usa el id si ya viene.
homologar_id <- function(df, col_id, col_txt, crosswalk, etiqueta, archivo) {
  if (col_id %in% names(df)) as.integer(round(to_num(df[[col_id]])))
  else if (col_txt %in% names(df)) map_codigo(df[[col_txt]], crosswalk, etiqueta, archivo)
  else stop(sprintf("%s: faltan %s y %s para homologar %s", archivo, col_id, col_txt, etiqueta))
}
# map_codigo falla fuerte si aparece un código fuera del crosswalk (no homologar a ciegas).
```

```r
# Atributos canónicos por RBD (resuelve cod_depe2 inconsistente entre familias):
attr_estab <- datos |>
  dplyr::filter(.data$familia == "indicador") |>
  dplyr::arrange(rbd, dplyr::desc(agno)) |>
  dplyr::distinct(rbd, .keep_all = TRUE) |>   # año más reciente por RBD
  dplyr::transmute(rbd, cod_depe2, cod_com_rbd, nom_com_rbd, cod_reg_rbd,
                   nom_reg_rbd = dplyr::coalesce(unname(NOMBRES_REGION[cod_reg_rbd]), nom_reg_rbd),
                   cod_pro_rbd, nom_rbd)
```

```r
# Inyección al template (patrón madre): JSON -> gzip -> base64 (una línea) -> placeholder.
json_b64 <- gsub("\n", "", jsonlite::base64_enc(memCompress(charToRaw(json_str), "gzip")), fixed = TRUE)
html <- sub("__JSON_DATA__", json_b64, plantilla, fixed = TRUE)   # + __FONTS_CSS__/__D3_INLINE__/__PAKO_INLINE__
# Cliente: JSON.parse(pako.inflate(Uint8Array.from(atob(b64), c=>c.charCodeAt(0)), {to:"string"}))
```

```js
// Índice de rangos por rbd (columnas ORDENADAS por rbd): O(n) una vez, sin materializar objetos.
function rangeIdx(arr){const m=Object.create(null);for(let i=0;i<arr.length;i++){const r=arr[i];const e=m[r];if(e===undefined)m[r]=[i,i+1];else e[1]=i+1;}return m;}
// lectura: for(let i=rng[0]; i<rng[1]; i++) if(grado[i]===g && agno[i]===a) {...}
```

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 6 — iteración post-deploy (Opus 4.8)`
- **Mensaje de apertura pre-armado:** Tipo CONTINUATION. El protocolo (política + settings) vive
  en la knowledge base del Project y en `50_documentacion/activa/`; léelo desde ahí. El proyecto
  está **desplegado y validado** (motor nacional en `docs/index.html`, pusheado a `origin/main`).
  Primer paso de dominio: confirmar que el titular activó **GitHub Pages** (PD-Pages) y verificar
  la URL `https://tomgc.github.io/slep_idps/`. Foco sugerido: sección metodológica (P-meta) + QA
  visual de niveles 8b (P-8b) + a11y/responsive (P7-iter). Adjunto el traspaso v05 y el escáner
  re-corrido; los archivos del motor (`35_motor_template.html`, `35_generar_motor_html.R`) si se
  itera la UI. Ruta sugerida: PD-Pages → P-meta/P-8b → P7-iter.
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar que estén al día):*
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` (correrá en Claude Code); el corpus
     `idps_corpus_conceptual.json` si se aborda P-meta; `catalogo_idps.parquet` si se trabaja
     contenido de niveles.
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v05.md`; el escáner
     `estructura_actual.md` re-corrido; si se itera la UI, `30_procesamiento/35_motor_template.html`
     y `35_generar_motor_html.R` (críticos, voluminosos); `idps_largo.parquet` solo si se rehace el
     contrato de datos.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más
  actualizada al abrir y avisarlo. PD-Pages es decisión/acción del titular: tener a mano el plan
  del repo (Free vs pagado) para decidir entre hacerlo público o usar el plan.
