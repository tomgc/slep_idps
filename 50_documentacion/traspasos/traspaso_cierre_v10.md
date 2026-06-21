# traspaso_cierre_v10.md

> Documento de cierre de sesión. Único puente entre sesiones: todo lo que no
> quede aquí se pierde. Generado al cierre de la sesión 10 de `slep_idps`.

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional —
  todo Chile; Rama A pública, datos versionados en el repo).
- **Versión de traspaso:** v10.
- **Fecha:** 2026-06-21.
- **Sesión:** 10. **Foco:** P5 — carga del histórico IDPS 2014-2019 al pipeline
  (censo → organización → integración), en tres fases ejecutadas por Claude Code
  con encargos autónomos.
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`).
- **Archivos principales modificados:** `30_procesamiento/34_leer_normalizar_idps.R`
  (lectura del histórico); `40_salidas/intermedios/idps_largo.parquet`
  (regenerado 2014→2025); `20_insumos/` (reorganizado: histórico en subcarpeta,
  4b2024 promovido). `CLAUDE.md` actualizado en el cierre (ver §12).

---

## 2. Resumen ejecutivo

La sesión 10 ejecutó P5 completa a nivel de pipeline: el `idps_largo.parquet`
pasó de cubrir 2022-2025 (1.485.103 filas) a 2014→2025 (2.362.447 filas),
integrando el histórico ancho 2014-2019 de la Agencia. Se trabajó en tres fases
con encargos autónomos a Claude Code, cada una con DRY_RUN/verificación y panel
adversarial: (1) un **censo forense** del universo IDPS completo que produjo la
matriz año×grado×nivel-de-informe; (2) una **reorganización** del filesystem que
movió el histórico a `20_insumos/historico/`, rescató el activo único 4b2024
(traspapelado, ausente de producción) y eliminó duplicados byte-idénticos; (3) la
**integración** que extendió `34` para leer el histórico ancho, pivotarlo a largo
y fundirlo en el parquet, con verificación de que ninguna cifra IDPS del dato
moderno cambió. El histórico aporta indicador 2014-2019 y dimensión 2018; no trae
subdimensión/niveles ni significancia (NA legítimo). Quedó pendiente, deliberada y
documentadamente, el **trabajo de motor** (`35`): la ficha aún muestra 2022-2025;
mostrar la serie histórica extendida es la próxima sesión. Los commits de P5 se
pushearon y el repo quedó publicado; Pages sigue sirviendo el motor 2022-2025
(sin cambio de contenido, esperado).

---

## 3. Estado al cierre

### Qué funciona

- **Pipeline completo de cero:** `run_all()` produce `idps_largo.parquet`
  2014→2025 sin intervención manual. Última ejecución exitosa: sesión 10 (fase 3,
  regeneración con histórico). md5 del parquet: `4c764d8c9f0bf70004f8aa52661ae901`.
- **`34_leer_normalizar_idps.R`** lee dos regímenes: moderno largo (raíz de
  `20_insumos/`, 2022-2025) e histórico ancho (`20_insumos/historico/`,
  2014-2019), fundidos en un solo parquet.
- **Cobertura del parquet:** indicador 2014-2025; dimensión 2018 (histórico) +
  2022-2025 (moderno); niveles solo 2023-2025; 4b2024 incorporado. Hueco
  2020-2021 ausente (pandemia). GSE NA en 2014-2016; significancia/subdimensión/
  niveles NA en todo el histórico.
- **Motor `35`:** genera `docs/index.html` mostrando 2022-2025 (sin cambios esta
  sesión). Desplegado en Pages.

### Qué no funciona / qué falta

- **El motor no muestra la serie histórica.** `35` dibuja solo 2022-2025; la
  vista de la ficha no incluye 2014-2019 todavía. No es un bug: es el trabajo de
  motor pendiente (ver §11, Pendiente P-MOTOR).

### Delta respecto a v09

- Parquet: de 2022-2025 (1.485.103 filas) a 2014→2025 (2.362.447 filas,
  +877.344: histórico 613.809 + 4b2024 263.535).
- `34`: nueva rama de lectura histórica (Bloque 1 manifiesto + Bloque 3b lector +
  ajuste Bloque 5 régimen-aware).
- `20_insumos/`: reorganizado (subcarpeta `historico/`, 4b2024 promovido,
  duplicados eliminados).
- Dos cambios de atributo del dato moderno, ajenos al histórico, ahora en el
  parquet (ver §6, Bug/hallazgo H10-1).

---

## 4. Registro detallado de cambios (sesión 10)

> Categoría temática entre corchetes. Cada bloque es un cambio conceptualmente
> independiente.

**C1 — Censo forense del universo IDPS** [auditoría/diagnóstico de datos].
Encargo autónomo (fase 1). Censo read-only de los tres orígenes de `20_insumos/`
(raíz 2022-2025, `historico_2014_2018/`, `auxiliares/`): 95 archivos, 59 tablas de
datos IDPS perfiladas columna por columna. Producto central: **matriz
año×grado×nivel-de-informe** (indicador/dimensión/subdimensión). Por qué: antes de
integrar había que saber qué dato existe, en qué año/grado/nivel, sin asumir
(B.1). Verificación: panel adversarial 4/4 (cobertura, nivel de informe por los 9
esquemas, dimensión 2018 real, integridad). Reporte:
`50_documentacion/activa/censo_universo_idps.md`.

**C2 — Reorganización del filesystem de insumos** [organización/estructura].
Encargo autónomo (fase 2) con DRY_RUN obligatorio. Cuatro operaciones: (a)
**promover 4b2024** (activo único traspapelado en `historico_2014_2018/4B/`,
ausente de la raíz que `34` lee) a `20_insumos/` con nomenclatura canónica + su
glosa a `auxiliares/`; (b) mover el histórico 2014-2019 (18 datos + 6 glosas-año
dedup) a `20_insumos/historico/` con nombres `idps{g}{AAAA}_rbd_historico.{xls,
xlsx}`; (c) eliminar 18 duplicados byte-idénticos verificados (cubeta B 2022/2023
+ 2m/6b 2024 que ya estaban en la raíz); (d) retirar `historico_2014_2018/`. Por
qué: dejar terreno limpio y separar regímenes (moderno largo en raíz, histórico
ancho en subcarpeta). Verificación: DRY_RUN cuadró, backup íntegro, panel
adversarial 4/4 (cero pérdida, no-borrado de activos, cobertura, pipeline
intacto). Log: `andamios/logs/20260621_reorganizacion_universo_idps_log.md`.

**C3 — Integración del histórico a `34`** [feature/pipeline]. Encargo autónomo
(fase 3). Extendió `34` (arquitectura (a): un solo parquet): Bloque 1 suma un 2º
`dir_ls` sobre `historico/` (incluye `.xls`) con `PATRON_HISTORICO`; Bloque 3b
nuevo (`leer_un_archivo_historico`) pivota el ancho a largo —`ind_{xx}`→indicador
vía `CW_INDICADOR`, `dim_{ind}_{dim}_rbd` (solo 2018)→dimensión vía `CW_DIMENSION`
tomando el par medio—, convierte 2017 texto→código, mapea geo divergente 2018,
proyecta NA en lo ausente; Bloque 4 despacha por régimen + `bind_rows`; Bloque 5
ajustado a **régimen-aware** (ver Bug H10-2). Por qué: poblar el parquet con la
serie completa. Verificación: ver §6.

**C4 — Push y publicación** [deploy]. Push de los commits de P5 a GitHub;
publicación del estado actual en Pages (motor 2022-2025 sin cambio, esperado: el
histórico está en el parquet, no en el motor). Verificación de que `docs/index.
html` no cambió y de que HEAD local == origin/main.

---

## 5. Backlog acumulativo

> Se copia íntegro de v09 y se agregan las entradas nuevas al final. La numeración
> es global y permanente. (El backlog detallado vive en
> `50_documentacion/` del proyecto; aquí se registra el delta de la sesión 10 y se
> referencia el acumulado.)

- **Objetivo del proyecto** (permanente): motor de visualización de los
  Indicadores de Desarrollo Personal y Social (IDPS) de la Agencia de Calidad,
  nacional, por establecimiento, sin agregación territorial; React 18 + D3 v7
  inline desplegado en GitHub Pages; para directivos y comunidad del SLEP Costa
  Central y de todo Chile; desde 2026.
- **Nota metodológica** (permanente): "cambio" = una solicitud distinguible del
  titular, no las acciones técnicas que la implementan; los bugfixes reportados
  por el titular cuentan, los errores del asistente corregidos de inmediato no.

**Delta del backlog v10:** +4 entradas de sesión (C1 censo, C2 reorganización, C3
integración, C4 push/deploy), todas de la categoría dominante de esta sesión
(carga de datos histórica / pipeline). Sin reclasificaciones ni refinamiento de
taxonomía. El conteo acumulado y el detalle cronológico se actualizan en el
backlog histórico del proyecto en la próxima apertura si procede.

---

## 6. Bugs y hallazgos de la sesión

**H10-1 — Dos cambios de atributo del dato moderno, ajenos al histórico**
(hallazgo, no bug). Al regenerar `34`, el parquet nuevo difiere del anterior en el
rango 2022-2025 en dos atributos —ninguno es cifra IDPS, ninguno proviene del
histórico—: (1) **tildes de `NOMBRES_REGION`**: en la sesión 6 se tildaron las
etiquetas de región en el config pero no se regeneró `idps_largo`, dejando config
y parquet desincronizados; al regenerar ahora, `nom_reg_rbd` se sincroniza
(588.286 filas, mismas regiones por `cod_reg_rbd`, 0 reasignaciones). (2)
**geo/depe de 45 RBD por el 4b2024**: al ingerir el 4b2024 (fase 2), 45
establecimientos que aparecen en él actualizan su geo/dependencia canónica a su
registro más reciente (regla "dependencia vigente a toda la serie", Bloque 5);
casos de RBD sin indicador moderno previo (NA→valor 2024) y de RBD cuya
dependencia pasó de Municipal a SLEP por traspaso. **Regla aprendida:** un cambio
diferido en una constante de presentación (config) que no regenera su artefacto
deja una bomba de tiempo silenciosa; la próxima regeneración la detona y puede
confundirse con un cambio espurio. Registrarlo siempre. **Estado:** resuelto y
documentado (el parquet ahora está sincronizado con el config).

**H10-2 — `attr_estab` contaminaba 657 filas modernas con geo/depe histórica**
(bug, detectado y corregido en fase 3). El Bloque 5 toma geo/depe del registro
**más reciente de la familia indicador** por RBD. Con el histórico fundido, un RBD
con dimensión/niveles modernos pero **sin indicador moderno** caía al indicador
histórico como "más reciente" y recibía geo/depe histórica → 657 filas modernas
alteradas. **Causa raíz:** "más reciente" sin discriminar régimen mezcla épocas
para RBD con cobertura parcial de familias. **Solución:** `attr_estab`
régimen-aware — las filas modernas toman su atributo del indicador **moderno** más
reciente; las históricas, del global. **Verificación:** `full[moderno]` ==
baseline moderno-only (0 diferencias) tras el fix; panel Dim1 lo confirmó con
código independiente. **Regla aprendida:** al fundir dos épocas en un parquet, toda
lógica de "registro más reciente por entidad" debe ser consciente de la época, o
contaminará entidades con cobertura parcial. **Estado:** resuelto.

**H10-3 — Bug de locale NFD en la reorganización** (bug de tooling, fase 2,
atrapado por el DRY_RUN). Bajo `LC_CTYPE=C`, R en macOS mangla los nombres con
tilde en forma NFD (`pública`/`público`) y `md5sum`/`file_copy`/`file_delete`
fallan en silencio; sin el fix, tres archivos con tilde habrían dado falso match
(riesgo de borrado sin prueba) y el modo real no habría podido eliminarlos.
**Solución:** forzar `LC_ALL=en_US.UTF-8` en el script y en la invocación.
**Regla aprendida:** todo script que manipule archivos con tildes en macOS debe
forzar locale UTF-8; el DRY_RUN es lo que lo expuso antes de tocar disco.
**Estado:** resuelto.

---

## 7. Aprendizajes y restricciones descubiertas

- **A10-1 (conservación por defecto en censos de datos).** El primer diagnóstico
  de esta sesión se encuadró como "confirmar que el histórico es indicador-ancho",
  hipótesis que empujó a tratar la dimensión 2018 como ruido a podar; estuvo a
  punto de costar dato real. El encuadre correcto de un censo es **inventariar y
  conservar todo lo publicado**; descartar es decisión del titular con evidencia,
  nunca recomendación de conveniencia del asistente. Contexto: violar esto pierde
  información irrecuperable. Principio: B.1 + gobernanza de datos.
- **A10-2 (lo "ajeno" puede contener un activo).** El material 2024 traspapelado en
  la carpeta histórica parecía basura a borrar; contenía 4b2024, un activo único
  ausente de producción. La clasificación de un archivo como duplicado/ajeno debe
  decidirse por **contenido verificado** (md5, presencia en la raíz), no por el
  nombre de su carpeta. Principio: A20 (verificar con el dato, no deducir).
- **A10-3 (el invariante real, no el literal).** El encargo de integración pedía
  verificación "bit-a-bit" de las filas 2022-2025, pero eso resultó demasiado
  estricto: las tildes y la recanonización por 4b2024 cambian atributos de
  presentación legítimamente. El invariante que importa es **ninguna cifra IDPS
  cambia** (medidas/ids/GSE), no identidad byte-a-byte. Distinguir el dato medido
  (sagrado) de la presentación (el pipeline legítimamente la recomputa). Principio:
  "lee, no deriva" aplicado con criterio.
- **A10-4 (alcance del encargo es contrato).** Claude Code agregó en la fase 2 un
  4º commit no pedido (actualización de `CLAUDE.md`), invocando una regla
  permanente. Se revirtió: actualizar `CLAUDE.md` es paso de **cierre**, no de un
  encargo de filesystem, y además quedó mal fechado (sin el contexto de cierre, el
  agente no tiene el número de sesión). Un encargo enumera sus commits; el agente
  no expande alcance por iniciativa. Principio: B.3 (cambios quirúrgicos).
- **A10-5 (DRY_RUN gana su costo).** En la fase 2 el DRY_RUN atrapó el bug de
  locale antes de tocar disco; en la fase 3 el checkpoint de verificación atrapó la
  contaminación de 657 filas antes de promover el parquet. La compuerta de
  simulación/verificación antes de mutar el artefacto de verdad no es burocracia:
  es lo que evita el daño irreversible. Principio: política §9 (DRY_RUN
  obligatorio en reorganización).

---

## 8. Decisiones de diseño

- **D10-A (arquitectura de integración: un solo parquet, opción a).** El histórico
  se funde en `idps_largo.parquet` (rama de lectura en `34`), no en un parquet
  separado. Alternativas: (b) parquet histórico aparte que el motor une; (c)
  híbrido con flag. Justificación: el invariante real es "no alterar el dato
  moderno", garantizado por verificación de medidas, no por separación física;
  un solo parquet evita enseñar al motor (el componente más caro) a unir fuentes.
  Tensión resuelta: legibilidad de `34` (ahora lee dos regímenes) vs simplicidad
  del motor — se priorizó la del motor, mitigando con el lector histórico aislado
  en su propio bloque.
- **D10-B (mapeo de dimensión 2018 vía crosswalk canónico, resuelve D1).** Los 11
  sufijos `dim_*` de 2018 se mapean a `id_dimension` reusando `CW_DIMENSION` del
  config, que fue construido leyendo las glosas oficiales 2024/2025 cruzadas por
  label. Por eso NO es inferencia por nombre: es el crosswalk canónico ya validado
  contra glosa moderna. `map_codigo` aborta si un sufijo no calza. Alternativa
  descartada: construir un mapeo nuevo desde la glosa 2018 (que además no documenta
  las dimensiones). Justificación: reusar lo ya validado, con la salvaguarda de
  aborto ante lo desconocido.
- **D10-C (publicar pipeline ahora, motor después).** Se hace push y se publica el
  estado actual (motor 2022-2025); la vista histórica extendida se difiere a una
  sesión de motor dedicada. Justificación: el trabajo de motor es un dominio
  distinto (visualización, no datos) que merece contexto fresco; improvisarlo al
  final de una sesión larga de pipeline arriesga peor calidad (higiene de sesión).

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `PATRON_DATOS` (moderno) | `^idps(2m\|4b\|6b\|8b)(\d{4})_(.+)_(final\|preliminar)$` | `34` | Sin cambio. Lee la raíz. |
| `PATRON_HISTORICO` (nuevo) | `^idps(2m\|4b\|6b\|8b)(\d{4})_rbd_historico$` | `34` | **Nuevo s10.** Lee `historico/`. |
| `CW_INDICADOR` | AM=1, CC=2, PF=3, HV=4 | `10_configuracion.R` | Reusado para el histórico. |
| `CW_DIMENSION` | AA=11…AC=43 (11 dims) | `10_configuracion.R` | Reusado; mapea sufijos 2018. |
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | **Cambió s10** (era `50d9de4f…`). |
| md5 respaldo pre-histórico | `50d9de4f1fc80259d29f499cdf46d9e1` | `_archivo/20260621/` | El parquet 2022-2025 previo, conservado. |
| Filas del parquet | 2.362.447 | parquet | **Cambió s10** (era 1.485.103). |
| `GRADOS_MOTOR` | 4b, 2m | `10_configuracion.R` | Sin cambio. El motor expone solo estos. |

---

## 10. Arquitectura de archivos

Estructura conforme a la política. Cambios estructurales de s10 (todos en
`20_insumos/`): nueva subcarpeta `20_insumos/historico/` (18 datos
`idps{g}{AAAA}_rbd_historico.{xls,xlsx}`) + `historico/glosas/` (6 glosas-año);
4b2024 promovido a la raíz (`idps4b2024_rbd_*.xlsx` + glosa en `auxiliares/`);
`historico_2014_2018/` retirada. Referencia al escáner al cierre: ejecutar
`00_escanear_proyecto.R` para el snapshot actualizado (la estructura de
`20_insumos/` cambió respecto al escáner de apertura).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-MOTOR — Extender el motor `35` a la serie histórica** (la prioridad de la
próxima sesión).
- **Descripción:** que la ficha del establecimiento muestre la serie 2014→2025 en
  la vista histórica (hoy `35` muestra 2022-2025). El dato ya está en el parquet.
- **Contexto:** el parquet tiene indicador 2014-2019 y dimensión 2018; el motor
  debe leerlos y dibujarlos.
- **Tipo:** funcionalidad (trabajo de motor / visualización).
- **Impacto:** es lo único que falta para que P5 sea visible al usuario.
- **Dependencias:** parquet 2014→2025 (ya listo).
- **Complejidad:** Media-Alta (diseño de visualización).
- **Precauciones / invariantes de diseño (acordados esta sesión):**
  - **2020-2021 deben aparecer en el eje como años DESACTIVADOS en gris claro**, no
    omitidos (son años sin dato por pandemia, distinto de un EE sin medición ese
    año, que es un hueco sin barra). El motor debe distinguir los dos estados.
  - La vista histórica anida indicador → dimensión; la dimensión histórica solo
    existe para 2018 (un punto en la serie, conecta con la dimensión moderna 2022+
    a través del hueco). La subdimensión NO existe antes de 2023 (no extender ese
    nivel al histórico).
  - Significancia (`dif`/`difgru`) NO existe en el histórico: las barras
    históricas muestran altura (`prom`), sin marca de tendencia ni desviación GSE.
    La UI debe tolerar su ausencia sin inventarla ("lee, no deriva").
  - GSE NO existe en 2014-2016: esos años no se pueden segmentar por GSE. El motor
    ya tolera GSE NA; confirmarlo en la vista histórica.
  - Solo se visualizan 4b y 2m (`GRADOS_MOTOR`); 6b y 8b están en el parquet pero
    no se muestran (decisión vigente).
- **Criterio de éxito sugerido:** la ficha de un establecimiento con dato
  histórico muestra su serie de indicador 2014→2025 con 2020-2021 en gris; la
  dimensión 2018 aparece en el drill-down; ningún año inventa significancia/GSE
  donde no existe. Regenerar `docs/index.html` y publicar en Pages.
- **Sugerencia de enfoque:** sesión de motor dedicada. Abrir leyendo este traspaso
  + el escáner + `35_generar_motor_html.R` + `10_configuracion.R`. Es trabajo de
  diseño de visualización: conviene contexto fresco, no engancharlo a una sesión de
  pipeline.

**P-PUSH — Estado del push** (registrar al cierre).
- Los commits de P5 (fases 2 y 3) se pushearon a `origin/main` al cierre de la
  sesión 10. Pages republicado con el estado actual (motor 2022-2025, sin cambio de
  contenido). Si por alguna razón el push no se completó, es lo primero a verificar
  en la apertura siguiente (la próxima sesión asume el repo ya sincronizado).

**P-HIGIENE-CASE — Desajuste de case git/disco en `20_insumos/`** (deuda menor,
fuera de alcance de P5).
- **Descripción:** varios insumos de la raíz están trackeados en git con mayúscula
  de grado (`idps2M2024`, `idps6B2024`, `idps4B2025`) pero existen en minúscula en
  disco — desajuste por la insensibilidad de mayúsculas del filesystem de macOS.
- **Contexto:** pre-existente, detectado por Claude Code en la fase 2, no causado
  por P5. Podría morder en un clon case-sensitive o en CI.
- **Tipo:** deuda técnica / higiene.
- **Complejidad:** Baja. **Sugerencia:** sesión de higiene, o al inicio de la de
  motor si es rápido. `git mv` con renombrado intermedio para forzar el cambio de
  case en el índice.

**P-DOC-POLITICA — Knowledge base puede requerir sync** (heredado de v09, verificar).
- La copia de `POLITICA_PROYECTO.md` v6 / `SETTINGS_Y_PROMPTS_OPERACIONALES.md` v3
  en la knowledge base debe coincidir con `50_documentacion/activa/`. Verificar en
  la apertura.

### Evaluación de deuda técnica

- **Zona frágil:** el Bloque 5 de `34` (`attr_estab`) es ahora más delicado al
  fundir dos épocas; el fix régimen-aware lo resuelve, pero cualquier cambio futuro
  a la lógica de "registro más reciente" debe re-verificar que no contamina filas
  con cobertura parcial de familias (H10-2). Es el punto del pipeline que más
  atención merece en una modificación futura.
- **Oportunidad:** `34` ahora lee dos regímenes en un archivo; si creciera la
  complejidad (más esquemas históricos, otra fuente), evaluar extraer el lector
  histórico a su propio archivo (`34b_`), sin cambiar la arquitectura de un solo
  parquet (A10-3 / D10-A).

### Auditoría de cierre (política 5.6)

- ¿Pipeline corre de cero sin intervención manual? **Sí** (run_all produce el
  parquet 2014→2025).
- ¿Cada transformación crítica tiene check de validación? **Sí** (Bloque 6 de `34`
  pasa sobre moderno+histórico sin relajarse; panel adversarial 4/4).
- ¿Outputs reproducibles e idempotentes? **Sí** (escritura atómica; el histórico es
  determinista).
- ¿Decisiones metodológicas como constantes nombradas? **Sí** (`PATRON_HISTORICO`,
  reuso de `CW_*`).
- ¿Nombres sin tildes/ñ/espacios? **Parcial** — los insumos heredados de la Agencia
  conservan tildes en el nombre (excepción declarada de datos crudos); además queda
  P-HIGIENE-CASE (desajuste de case, deuda anotada).

### Ruta sugerida para la próxima sesión

1. **Apertura CONTINUATION** leyendo este traspaso + escáner + protocolo de la
   knowledge base. Verificar P-PUSH (repo sincronizado) y P-DOC-POLITICA.
2. **P-MOTOR** como foco único: extender `35` a la serie histórica con los
   invariantes de diseño de §11 (2020-2021 en gris, dimensión solo 2018,
   sin significancia/GSE inventados, solo 4b/2m). Es una sesión de motor/
   visualización; contexto fresco.
3. Opcional al inicio si es rápido: **P-HIGIENE-CASE**.
4. Cierre: regenerar `docs/index.html` y publicar en Pages la experiencia
   histórica completa (esto cierra P5 de cara al usuario).

**Diferir:** cualquier trabajo de pipeline (P5 está completo a ese nivel); no
reabrir la integración salvo bug.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El `idps_largo.parquet` cubre 2014→2025; el respaldo pre-histórico
  (`50d9de4f…`) está en `_archivo/20260621/`. NO regenerar el parquet salvo cambio
  de datos; la próxima sesión es de motor, lee el parquet, no lo reescribe.
- ⚠️ NO mostrar 2020-2021 como años inexistentes que desaparecen del eje: van
  DESACTIVADOS en gris claro (años sin dato por pandemia). Distinguir de "EE sin
  medición ese año" (hueco sin barra).
- ⚠️ NO inventar significancia ni GSE en el histórico donde no existen
  (significancia en todo 2014-2019; GSE en 2014-2016). "Lee, no deriva."
- ✅ ANTES de tocar `35`, leer `35_generar_motor_html.R` completo y el parquet
  (qué trae el histórico: indicador 2014-2019, dimensión 2018, nada más).
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atómicos por ruta;
  nunca `git add .`/`-u` (A10-4).
- 🔒 Solo se visualizan 4b y 2m (`GRADOS_MOTOR`); 6b/8b en el parquet, no en la UI.
- 🔒 Actualizar `CLAUDE.md` "Últimos cambios" es paso de CIERRE, no de un encargo
  intermedio (A10-4).

---

## 13. Fragmentos de código de referencia

**Lectura del parquet histórico (cómo el motor debe filtrar la serie):**
```r
library(arrow); library(dplyr)
parq <- arrow::read_parquet(here::here("40_salidas", "intermedios", "idps_largo.parquet"))

# Serie de indicador de un establecimiento, 2014->2025 (lo que la ficha grafica):
serie_ind <- parq |>
  dplyr::filter(rbd == "<RBD>", familia == "indicador", grado %in% c("4b", "2m")) |>
  dplyr::select(agno, grado, id_indicador, prom, dif, sigdif, difgru, sigdifgru) |>
  dplyr::arrange(grado, id_indicador, agno)
# Nota: dif/difgru seran NA para agno 2014-2019 (el historico no los trae).
# 2020-2021 simplemente no apareceran como filas -> el motor debe inyectar el
# hueco como anios DESACTIVADOS (gris), no omitirlos del eje.

# Dimension historica (solo 2018) + moderna (2022+):
serie_dim <- parq |>
  dplyr::filter(rbd == "<RBD>", familia == "dimension", grado %in% c("4b", "2m")) |>
  dplyr::arrange(grado, id_dimension, agno)
```

**Inyección del hueco pandemia (patrón para el eje del motor):**
```r
# El eje historico va de 2014 a 2025. Los anios sin NINGUNA fila para el RBD se
# clasifican: 2020-2021 = "pandemia" (gris, marcado); otros faltantes = "sin dato".
anios_eje <- 2014:2025
anios_pandemia <- c(2020L, 2021L)
# El motor (35) construye el eje completo y marca cada anio: con-dato / pandemia / sin-dato.
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 11 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  SETTINGS) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v10,
  el escáner actual, `35_generar_motor_html.R` y `10_configuracion.R`. Foco
  propuesto: P-MOTOR (extender el motor a la serie histórica 2014→2025)."
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que
     esté al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` (correrá en Claude Code el trabajo de
     motor); el encargo de motor cuando se redacte.
  3. *Específicos de la sesión (SÍ se adjuntan):* `traspaso_cierre_v10.md`;
     `estructura_actual.md` (escáner actualizado tras la reorg de `20_insumos/`);
     `35_generar_motor_html.R` (el archivo a extender); `10_configuracion.R`
     (constantes/crosswalks/`GRADOS_MOTOR`). El parquet `idps_largo.parquet` es
     voluminoso pero crítico; está en el repo, no se adjunta — se lee desde disco.
- **Nota final:** si `35_generar_motor_html.R` o `10_configuracion.R` cambian entre
  sesiones, adjuntar la versión más reciente y avisarlo en la apertura.
