# traspaso_cierre_v11.md

> Documento de cierre de sesion. Unico puente entre sesiones: todo lo que no
> quede aqui se pierde. Generado al cierre de la sesion 11 de `slep_idps`.
>
> **Registro de ejecucion detallado:** dos logs de Claude Code en
> `50_documentacion/andamios/logs/` (ver seccion 4); el detalle paso a paso no se
> reproduce aqui.

---

## 1. Identificacion

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, todo
  Chile; Rama A publica, datos versionados en el repo).
- **Version de traspaso:** v11.
- **Fecha:** 2026-06-21.
- **Sesion:** 11. **Foco:** auditoria adversarial READ-ONLY de la integracion
  historica (estructura + moderno-intacto, y luego censo de valores), e higiene de
  documentacion pendiente. **Hallazgo de cierre (critico):** el motor desplegado NO
  refleja el dato auditado (el historico no esta en el sitio; P-MOTOR sin hacer).
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`).
- **Archivos principales modificados:** ninguno de datos ni de codigo del pipeline
  (la sesion fue READ-ONLY sobre el dato). Cambios SOLO documentales/git: commits
  de traspasos v09/v10, encargos, logs; `.gitignore` endurecido; este traspaso v11.

---

## 2. Resumen ejecutivo

La sesion 11 sometio la integracion historica de la sesion 10 a dos auditorias
adversariales READ-ONLY y luego ordeno la documentacion pendiente. La primera
auditoria verifico, con codigo independiente y panel adversarial, que la
integracion no rompio el dato moderno (17 columnas sagradas con 0 diffs por tres
metodos), que la estructura/cobertura/NA calzan, y que el pivoteo reproduce el
crudo en 14 celdas ancla: **5/5 PASA**. Como la verificacion del historico ahi fue
por muestra y no por censo, una segunda auditoria censo **celda por celda** los
613.809 valores historicos (`prom` + `cod_grupo`) por tres re-derivaciones
independientes del pivoteo: **4/4 PASA**, 0 diffs, descartando el escenario
"mismo conteo, valores equivocados". El `md5` del parquet quedo identico al inicio
y al fin de ambas (read-only probado). En paralelo se versiono la documentacion que
arrastraba sin trackear (traspasos v09/v10, encargos, log de diagnostico) y se
endurecio el `.gitignore`. El cierre destapo el punto critico: **el sitio en Pages
muestra solo 2022-2025; el historico esta en el parquet pero NO en el motor, y el
build desplegado es anterior a la promocion de 4b2024**. Para la validacion tecnica
externa del dato (todas las paginas, dato actual e historico), el producto aun no
existe en el estado requerido: eso es P-MOTOR, elevado aqui a bloqueante. Nada se
habia pusheado durante la sesion; el push se hace en este cierre, en bloque.

---

## 3. Estado al cierre

### Que funciona
- **Dato (parquet `idps_largo.parquet`, 2014→2025, 2.362.447 filas, md5
  `4c764d8c…`): verificado a nivel censo.** Dos auditorias independientes lo
  confirman (estructura/moderno-intacto y valores historicos). Es piso solido.
- **Pipeline completo de cero:** `run_all()` produce el parquet sin intervencion
  manual (sin cambios esta sesion).
- **Documentacion:** traspasos, encargos y logs de P5 ahora versionados;
  `.gitignore` coherente con la intencion (diagnostico/`.claude` ignorados).

### Que NO funciona / que falta (para la presentacion de manana)
- **El sitio en Pages NO esta completo.** `35` renderiza solo 2022-2025; el
  historico 2014-2019 NO esta en el motor (P-MOTOR sin hacer). Para una validacion
  externa del dato, el sitio tiene que MOSTRAR el dato y hoy no muestra el historico.
- **El build desplegado esta desactualizado.** Construido antes de promover 4b2024
  esta sesion → casi con certeza el sitio publico NO tiene 4° basico 2024, y muestra
  el moderno de un parquet previo (pre-sincronizacion de tildes de region).
- **Fidelidad parquet → cifra desplegada: sin auditar.** Se verifico crudo→parquet
  exhaustivamente, pero NO parquet→lo-que-el-motor-muestra (ver P-DISPLAY-FIDELITY).

### Delta respecto a v10
- Cero cambios de dato/codigo del pipeline (sesion read-only).
- +2 auditorias con veredicto limpio (logs nuevos).
- Documentacion P5 versionada; `.gitignore` endurecido.
- Hallazgo nuevo de producto (gap motor vs dato), elevado a P-MOTOR bloqueante.

---

## 4. Registro detallado de cambios (sesion 11)

**C1 — Auditoria adversarial de la integracion (estructura + moderno-intacto)**
[auditoria/verificacion]. Encargo
`50_documentacion/activa/encargo_claude_code_idps_verificacion_integracion_historico.md`.
Panel adversarial de 5 dimensiones, codigo independiente (sin funciones de `34`):
cobertura vs los 18 archivos; NA legitimo; **moderno intacto** (join vs respaldo
`50d9de4f…`, 17 columnas sagradas 0 diffs por 3 metodos + `max|delta|=0`,
`left_only=263.535`=4b2024, `right_only=0`); integridad estructural; spot-check
14/14 contra el crudo. **5/5 PASA.** md5 inicio==fin. Log:
`andamios/logs/20260621_verificacion_integracion_historico_log.md` (commiteado,
`8a817f8`).

**C2 — Censo de valores del historico** [auditoria/verificacion]. Encargo
`.../encargo_claude_code_idps_verificacion_valores_historico.md`. Re-pivoteo
independiente (3 re-derivaciones: script propio + 2 agentes) de los 18 xlsx anchos →
full-join vs el subconjunto historico del parquet → comparacion celda por celda de
`prom` y `cod_grupo`: **613.809 filas, 0 diffs**, `left_only=0`/`right_only=0`,
no-NA 410.380/189.767, crosswalk vs corpus biyectivo sin reuso. **4/4 PASA.** md5
inicio==fin. Log: `andamios/logs/20260621_verificacion_valores_historico_log.md`.

**C3 — Higiene de documentacion pendiente** [organizacion/docs]. Cuatro commits
atomicos: `bd25cd7` (traspasos v09/v10), `ea0620d` (5 encargos de Claude Code),
`a86117d` (log de diagnostico historico), `2d0e19a` (`.gitignore`: desancla
`diagnostico_*.md` para ignorarlo en cualquier carpeta + ignora `.claude/`). Remedia
el patron A32/A35 (traspaso/escaner sin versionar tras el cierre).

**C4 — Cierre** [docs/deploy]. Escaner ejecutado; commits de cierre (logs/encargo del
censo, escaner, este v11) y **push en bloque** de todo lo acumulado de la sesion
(este cierre completa A38 por primera vez en varias sesiones: el traspaso queda
versionado Y pusheado).

---

## 5. Backlog acumulativo

> Se copia integro de v10 y se agregan las entradas nuevas al final (numeracion
> global y permanente; el detalle vive en el backlog del proyecto, aqui el delta).

- **Objetivo del proyecto** (permanente): motor de visualizacion de los IDPS de la
  Agencia de Calidad, nacional, por establecimiento, sin agregacion territorial;
  React 18 + D3 v7 inline en GitHub Pages; para directivos y comunidad del SLEP
  Costa Central y de todo Chile; desde 2026.
- **Nota metodologica** (permanente): "cambio" = una solicitud distinguible del
  titular; bugfixes reportados por el titular cuentan; errores del asistente
  corregidos de inmediato no.

**Delta del backlog v11:** la sesion no introdujo cambios de dato/producto; sus
entradas son de **verificacion** (C1 auditoria de integracion, C2 censo de valores)
y de **higiene documental** (C3). Sin reclasificaciones de taxonomia. El conteo
acumulado se actualiza en la proxima apertura si procede.

---

## 6. Bugs y hallazgos de la sesion

**Sin bugs nuevos de dato/codigo.** Las dos auditorias salieron limpias.

**H11-1 (hallazgo de PRODUCTO, no de dato):** el sitio desplegado no refleja el dato
auditado — el historico no esta en el motor (P-MOTOR sin hacer) y el build precede a
la promocion de 4b2024. **Causa raiz:** la integracion de la s10 fue a nivel
pipeline; el motor nunca se regenero ni se extendio para el historico. **Regla
aprendida:** auditar la capa de dato NO valida la capa de producto; para una
presentacion, lo que importa es lo que el sitio MUESTRA, no lo que el parquet
contiene. **Estado:** abierto → P-MOTOR bloqueante (seccion 11).

**Observaciones informativas (no hallazgos, no tocan cifra):**
- **geo NA en 389 RBD solo-historicos** (legitimo: la fuente no trae geo en
  2014-2016; o NA en el propio crudo 2017/2018). Implica que esos EE no se pueden
  filtrar por territorio. **Es decision de motor**, no de dato (ver P-MOTOR).
- **`max|delta|` de `prom`:** 0 (censo que replica el `to_num` de `34`) vs 5.68e-14
  (agente con `to_num` mas crudo), ambos << TOL=1e-9: dos normalizaciones
  convergiendo refuerzan la correccion del dato.
- **Habitos:** la numeracion intra-decena viene de la glosa (41=vida activa), no del
  orden del corpus; documentado en config; la decena apunta al indicador 4 correcto.

---

## 7. Aprendizajes y restricciones descubiertas

- **A11-1 (la capa auditada no es la capa presentada).** Se puede blindar el dato y
  aun asi tener un producto incompleto. Antes de declarar "listo para presentar",
  verificar que el ARTEFACTO PUBLICO (el sitio) contiene y muestra lo auditado.
  Principio: B.1 + B.4 (criterio de exito definido sobre el producto, no el insumo).
- **A11-2 (muestra vs censo en dato nuevo).** El dato nuevo sin respaldo (el
  historico) no se valida por spot-check: se censa. La primera auditoria verifico el
  moderno de forma exhaustiva pero el historico por muestra; el escenario de riesgo
  (mismo conteo, valores equivocados) exigio un censo dedicado. Principio: B.1.
- **A11-3 (panel adversarial con codigo independiente, no copia de produccion).**
  Las tres re-derivaciones del censo no usaron las funciones de `34`: re-pivotearon
  desde el nombre crudo + crosswalk + corpus. Reusar `34` no cazaria un error de
  `34`. Principio: A21.
- **A11-4 (cierre = versionado Y pusheado).** Esta sesion remedia explicitamente el
  patron A32/A35: la documentacion sin trackear se versiona y el push se hace en el
  cierre, no se difiere. Principio: A38.
- **A11-5 (honestidad del log).** El segundo log registro su propio artefacto de
  verificacion (15 falsos positivos de `sprintf %.9f` en frontera de redondeo,
  reconciliados a 0), corrigiendo un reparo del primer log. Un log honesto incluye lo
  que costo.

---

## 8. Decisiones de diseno

- **D11-A (auditorias READ-ONLY con detencion ante hallazgo).** Si una auditoria
  encontraba una diferencia de valor, debia documentarla y detenerse, no corregir:
  una correccion del pipeline es tarea nueva del titular (el traspaso v10 dejo el
  pipeline cerrado salvo bug). No hubo hallazgo → no se reabrio nada.
- **D11-B (dos auditorias, no una).** Primero estructura + moderno-intacto; luego,
  al ver que el historico solo tenia verificacion por muestra, un censo de valores
  dedicado. Justificacion: el dato nuevo merece verificacion exhaustiva, separada de
  la del moderno.
- **D11-C (clasificacion de `inventario_*.parquet` diferida).** Quedaron sin
  trackear; su clasificacion (versionar si `run_all()` los regenera; gitignorear si
  son scratch de censo/diagnostico) se decide en la proxima sesion, con el codigo a
  la vista. Ver P-INVENTARIOS.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | Sin cambio (auditorias read-only). |
| md5 respaldo pre-historico | `50d9de4f1fc80259d29f499cdf46d9e1` | `_archivo/20260621/idps_largo_pre_historico.parquet` | Baseline del moderno. |
| Filas del parquet | 2.362.447 | parquet | Historico 613.809 (ind 419.428 + dim 194.381). |
| no-NA `prom` historico | ind 410.380 / dim 189.767 | censo | Cuadre exacto verificado. |
| `TOL` (censo de valores) | `1e-9` | encargo/verificar | Tolerancia flotante del censo. |
| `GRADOS_MOTOR` | 4b, 2m | `10_configuracion.R` | Sin cambio. El motor expone solo estos. |
| `PATRON_HISTORICO` | `^idps(2m\|4b\|6b\|8b)(\d{4})_rbd_historico$` | `34` | Sin cambio (s10). |

---

## 10. Arquitectura de archivos

Estructura conforme a la politica. Cambios de s11 SOLO documentales: dos logs de
auditoria en `andamios/logs/`; documentacion P5 versionada; `.gitignore` endurecido
(`diagnostico_*.md` global, `.claude/`); este v11. Referencia al escaner al cierre:
`50_documentacion/estructura/estructura_actual.md` (refrescado en este cierre).
**Untracked deliberado al cierre:** `40_salidas/intermedios/inventario_historico_idps.parquet`
y `inventario_universo_idps.parquet` (P-INVENTARIOS).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-MOTOR — Sitio completo con la serie historica (BLOQUEANTE de la presentacion).**
- **Descripcion:** extender `35` para que la ficha muestre 2014→2025; regenerar el
  motor desde el parquet actual (2014→2025, lo que ademas incorpora 4b2024 y la
  sincronizacion de tildes); redesplegar en Pages; verificar el sitio EN VIVO de
  punta a punta (todas las paginas, filtros, hovers, visualizaciones, dato actual +
  historico).
- **Contexto:** el dato ya esta en el parquet y verificado a nivel censo; lo que
  falta es exclusivamente trabajo de motor/visualizacion y de despliegue.
- **Tipo:** funcionalidad (motor) + deploy. **Complejidad:** Media-Alta.
- **Impacto:** es lo unico que falta para que el producto exista en el estado que la
  validacion externa requiere.
- **Invariantes de diseno (acordados en v10, vigentes):**
  - 🔒 2020-2021 en el eje como anios DESACTIVADOS en gris (sin dato por pandemia),
    NO omitidos; distinto de "EE sin medicion ese anio" (hueco sin barra).
  - 🔒 Dimension historica solo existe para 2018 (un punto, conecta con la moderna
    2022+ a traves del hueco). Subdimension/niveles NO existen antes de 2023.
  - 🔒 Significancia (`dif`/`difgru`) y GSE NO existen en el historico (GSE existe
    2017-2019, NO 2014-2016): "lee, no deriva", no inventar.
  - 🔒 Solo 4b y 2m en la UI (`GRADOS_MOTOR`); 6b/8b en el parquet, no en pantalla.
  - **Nuevo (s11):** 389 RBD solo-historicos tienen geo NA legitima → el motor debe
    decidir como presentarlos (no se pueden filtrar por territorio); no inventar geo.
- **Criterio de exito:** el sitio desplegado muestra 2014→2025 completo, con 4b2024
  presente, 2020-2021 en gris, dimension 2018 en el drill-down, sin significancia/GSE
  inventados; todas las paginas/filtros/hovers operativos; verificado en vivo.

**P-DISPLAY-FIDELITY — Auditoria de cifras desplegadas (parquet → motor).**
- Se verifico crudo→parquet, NO parquet→cifra que el motor muestra. Para una
  validacion externa del dato conviene un spot-check de cifras publicadas (patron
  `auditoria_codigo_proyecto_md_v1.md`): elegir RBD y contrastar lo que muestra el
  motor vs el parquet vs el crudo. Hacer DESPUES de regenerar el motor (P-MOTOR), o
  como parte de su verificacion de cierre.

**P-DOC — Actualizar la documentacion segun protocolo de la KB (orden del titular).**
- Al llegar a piso solido (despues de P-MOTOR), actualizar la documentacion segun
  `SETTINGS_Y_PROMPTS_OPERACIONALES.md` 4.6 (`suitedoc`) y la doc minima de politica
  10 (README, `documentacion_tecnica`, `gobernanza_datos`). **Definir alcance:** si
  "todas las paginas" del sitio incluye publicar la suite de documentacion/
  metodologia en Pages (hoy `docs/` solo tiene el motor) — para una validacion de
  dato externa, la metodologia publicada suma.

**P-INVENTARIOS — Clasificar `inventario_*.parquet`.**
- Versionar si `run_all()` los regenera y se quieren trazables; gitignorear si son
  scratch de los encargos one-off de censo/diagnostico (mi lectura). Decidir con el
  codigo a la vista.

**P-HIGIENE-CASE — Desajuste de case git/disco en `20_insumos/`** (heredado de v10).
- `idps2M2024`/`idps6B2024`/`idps4B2025` trackeados en mayuscula, en minuscula en
  disco (macOS case-insensitive). Podria morder en un clon case-sensitive o CI.
  Baja complejidad; `git mv` con renombrado intermedio.

**P-PUSH — Resuelto.** El repo quedo sincronizado y este cierre pushea todo.

### Auditoria de cierre (politica 5.6)
- Pipeline corre de cero sin intervencion manual: **Si** (sin cambios esta sesion).
- Outputs reproducibles/idempotentes: **Si**.
- Nombres sin tildes/n/espacios: **Parcial** (P-HIGIENE-CASE + tildes en crudos de la
  Agencia, excepcion declarada).
- Cifras publicadas verificadas: **Parcial** — crudo→parquet si (censo); parquet→
  motor pendiente (P-DISPLAY-FIDELITY).

### Ruta sugerida para la sesion 12
1. **Apertura CONTINUATION** leyendo este v11 + escaner + protocolo de la KB.
2. **P-MOTOR como P0 bloqueante.** Paso 0: decodificar el `docs/index.html`
   desplegado para confirmar exactamente que grados/anios contiene hoy; leer `35` +
   `10_configuracion.R` completos. Luego: extender el render al historico, regenerar
   desde el parquet 2014→2025, redesplegar, verificar el sitio en vivo.
3. **P-DISPLAY-FIDELITY** como verificacion de cierre del motor.
4. **P-DOC** al llegar a piso solido.
- **Diferir:** P-INVENTARIOS y P-HIGIENE-CASE salvo que estorben; no reabrir el dato
  (esta blindado).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 El dato esta verificado a nivel CENSO (dos auditorias). NO re-auditar el parquet
  ni regenerarlo: la sesion 12 es de motor, LEE el parquet, construye sobre el.
- 🔒 NO desplegar el build viejo. El `docs/index.html` actual precede a 4b2024 y al
  historico; hay que REGENERAR `35` desde el parquet actual antes de presentar.
- ⚠️ NO inventar significancia ni GSE en el historico (significancia en todo
  2014-2019; GSE en 2014-2016). 2020-2021 en gris, no omitidos. Dimension solo 2018.
- ⚠️ 389 RBD solo-historicos tienen geo NA legitima: el motor no debe inventar geo;
  decidir explicitamente como presentarlos.
- ✅ ANTES de tocar `35`, decodificar el `docs/index.html` desplegado (saber con que
  producto se parte) y leer `35_generar_motor_html.R` + `35_motor_template.html` +
  `10_configuracion.R` completos.
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atomicos por ruta;
  nunca `git add .`/`-u`.
- 🔒 Actualizar `CLAUDE.md` "ultimos cambios" es paso de CIERRE, no de un encargo
  intermedio.

---

## 13. Fragmentos de codigo de referencia

**Lectura del parquet historico (como el motor debe filtrar la serie):**
```r
library(arrow); library(dplyr)
parq <- arrow::read_parquet(here::here("40_salidas", "intermedios", "idps_largo.parquet"))

# Serie de indicador de un EE, 2014->2025 (lo que la ficha grafica):
serie_ind <- parq |>
  dplyr::filter(rbd == "<RBD>", familia == "indicador", grado %in% c("4b", "2m")) |>
  dplyr::select(agno, grado, id_indicador, prom, dif, sigdif, difgru, sigdifgru) |>
  dplyr::arrange(grado, id_indicador, agno)
# dif/difgru NA en 2014-2019; 2020-2021 sin filas -> el motor inyecta el hueco como
# anios DESACTIVADOS (gris), no los omite del eje.

# Dimension historica (solo 2018) + moderna (2022+):
serie_dim <- parq |>
  dplyr::filter(rbd == "<RBD>", familia == "dimension", grado %in% c("4b", "2m")) |>
  dplyr::arrange(grado, id_dimension, agno)
```

**Eje con hueco pandemia:**
```r
anios_eje <- 2014:2025
anios_pandemia <- c(2020L, 2021L)
# El motor construye el eje completo y marca cada anio: con-dato / pandemia / sin-dato.
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesion 12 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (politica +
  SETTINGS) vive en la knowledge base y se lee desde ahi. Adjunto el traspaso v11, el
  escaner actual, `35_generar_motor_html.R`, `35_motor_template.html` y
  `10_configuracion.R`. Foco: P-MOTOR como P0 bloqueante — sitio completo con la
  serie historica 2014→2025 para validacion tecnica externa manana. El parquet esta
  verificado a nivel censo (sesion 11); se lee, no se re-audita."
- **Documentos para la sesion 12, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que este
     al dia): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales segun el foco:* `CLAUDE.md` (el motor corre en Claude Code);
     `encargo_autonomo_claude_code_v1.md` (si P-MOTOR se ejecuta por encargo);
     `idps_corpus_conceptual.md` (descripciones de nivel por subdimension para la UI,
     ya en la KB).
  3. *Especificos de la sesion (SI se adjuntan):* `traspaso_cierre_v11.md`;
     `estructura_actual.md`; `35_generar_motor_html.R` (el archivo a extender);
     `35_motor_template.html` (estructura HTML del motor); `10_configuracion.R`
     (`GRADOS_MOTOR`, crosswalks, `NOMBRES_REGION`). El parquet `idps_largo.parquet`
     es voluminoso pero critico: esta en el repo, se lee desde disco, no se adjunta.
     Los dos logs de auditoria de la s11 quedan referenciados (evidencia de que el
     dato esta blindado), no es necesario adjuntarlos.
- **Nota final:** si `35_generar_motor_html.R`, `35_motor_template.html` o
  `10_configuracion.R` cambian entre sesiones, adjuntar la version mas reciente y
  avisarlo en la apertura.
