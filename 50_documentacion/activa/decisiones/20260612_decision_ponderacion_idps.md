# Decisión — Ponderación territorial y alcance del motor IDPS

- **Fecha:** 2026-06-12
- **Sesión:** 5 (`slep_idps`)
- **Pendientes que resuelve:** P4 (método de ponderación territorial),
  reposicionamiento de P3 y P6, alcance del motor (caso de uso).
- **Estado:** cerrada.

---

## 1. Contexto

El motor `slep_idps` se concibió (sesiones 1–4) asumiendo que reproduciría
el patrón del proyecto madre `slep_simce_adecuado`: agregar resultados de
establecimiento a niveles territoriales (comuna, SLEP, región, país),
ponderando por el número de estudiantes evaluados (`nalu` en SIMCE), y
comparar "SLEP vs Resto de Valparaíso".

El pendiente P4 quedó en el traspaso v04 como decisión de dominio bloqueante:
qué columna usar como ponderador, dado que el diagnóstico de v04 ya había
detectado que ninguna familia IDPS publica número de evaluados.

## 2. Evidencia revisada (sesión 5)

Se inspeccionaron, por glosa oficial y por datos reales, las tres familias
de archivos de la Agencia (`rbd`, `rbd_dim`, `niveles`) para los grados 2m,
4b, 6b, 8b y los años 2022–2025:

- **Ninguna familia publica número de estudiantes evaluados, respondentes
  ni matrícula.** La medida es siempre `prom` (puntaje 0–100 del
  establecimiento). La familia `niveles` trae `niv_*_por` (porcentajes de
  distribución, no frecuencias absolutas).
- **No existe ningún corte territorial pre-agregado** en los archivos: todo
  es por establecimiento (`rbd`).
- La Agencia ya publica, por fila de establecimiento, las comparaciones
  significativas calculadas: `dif`/`sigdif` (vs evaluación anterior) y
  `difgru`/`sigdifgru` (vs el mismo GSE).
- Hallazgo adicional de esquema: el identificador de indicador/dimensión
  migra de texto (`ind`=`AM`/`CC`/`PF`/`HV`) en 2022–2023 a numérico
  (`id_indicador`=1–4) en 2025; igual para dimensión y subdimensión. P6
  requiere una capa de homologación por año.

## 3. Opciones consideradas

1. **`prom` territorial pre-agregado de la Agencia.** Descartada: no existe.
2. **Ponderar por número de evaluados (patrón del madre).** Descartada:
   la columna no existe en ninguna fuente IDPS.
3. **Ponderar por `MATRICULA` del directorio oficial.** Descartada: la
   matrícula total del establecimiento es una población distinta de quienes
   respondieron el cuestionario IDPS (lo rinde el grado evaluado, no todo el
   establecimiento). Usarla mezclaría universos no equivalentes.
4. **Promedio simple declarado.** Descartada: pondera por igual
   establecimientos con universos de respondentes desiguales; produce una
   cifra territorial no defendible metodológicamente.

## 4. Decisión

**No se construye ningún consolidado territorial propio.** Sin número de
respondentes por establecimiento, cualquier agregación a comuna / SLEP /
región / país mezclaría universos distintos y produciría una cifra que el
equipo no puede defender ante la Agencia ni ante terceros. La inmutabilidad
de la fuente (política C.5.2.1) y el principio de no mezclar cifras de
universos distintos prevalecen sobre la conveniencia de tener una línea
territorial.

**El motor muestra únicamente cifras al nivel en que la Agencia las publica:
el establecimiento (`rbd`).**

## 5. Reposicionamiento del alcance del motor (caso de uso B)

El motor pasa de "comparación territorial agregada" a **panorama por
establecimiento-grado, segmentado por GSE**:

- La unidad de dato es el establecimiento (RBD) en un grado. Para cada uno
  se muestra el `prom` de los 4 indicadores de cuestionario (AM, CC, PF,
  HV), su desglose por dimensión, y la distribución de niveles
  Bajo/Medio/Alto por subdimensión (familia `niveles`, solo subdimensiones
  de actor EST).
- La referencia comparativa es la que la Agencia ya calcula por fila:
  `difgru`/`sigdifgru` (cada establecimiento contra su mismo GSE) y
  `dif`/`sigdif` (vs evaluación anterior). **El motor lee estas columnas; no
  las deriva ni recalcula.**
- **Definición de "comparar" en este motor.** Comparar es legítimo y
  necesario, pero significa dos cosas concretas, ninguna de las cuales
  construye un agregado propio: (a) comparar establecimientos entre sí,
  poniendo sus panoramas (radares) lado a lado dentro de la grilla por GSE
  (cada radar es dato crudo individual, nada se promedia); y (b) mostrar el
  desvío de cada establecimiento respecto de su GSE mediante
  `difgru`/`sigdifgru`, el consolidado que la Agencia ya informó. Se usa el
  desvío oficial como marca/indicador (sobre / bajo / igual a su GSE, con su
  significancia), **no** se dibuja una línea de puntaje absoluto del GSE: ese
  nivel absoluto la Agencia no lo publica, y derivarlo (`prom − difgru`)
  reconstruiría el consolidado prohibido por P4 y además sería inexacto por
  redondeo. Comparar contra un agregado territorial o de GSE calculado por
  nosotros queda prohibido.
- **GSE como segmentador:** al filtrar por un GSE, el motor despliega una
  grilla con todos los establecimientos-grado que pertenecen a ese GSE, un
  panorama (radar) por establecimiento. El GSE agrupa y etiqueta la grilla;
  **no produce ninguna cifra agregada.**
- Los filtros territoriales (SLEP, comuna, región) solo acotan qué
  establecimientos se listan; nunca generan una cifra agregada.

### 5.1 Aclaración sobre la regla canónica de GSE

La regla "GSE en todo output" se cumple de forma distinta a SIMCE. En el
madre, GSE es una **dimensión de agregación** (se agrupan establecimientos
por `cod_grupo`). En IDPS, como no se agrega, GSE es:

- **atributo** visible de cada establecimiento (etiqueta permanente), y
- **segmentador** que define qué establecimientos entran a la grilla, y
- el **referente** que la Agencia ya usó para calcular `difgru`/`sigdifgru`.

La segmentación por GSE es legítima como filtro y como etiqueta. Es
**ilegítima como cifra agregada**: "el promedio del GSE 3 en el SLEP" es
exactamente el consolidado territorial que esta decisión prohíbe.

## 6. Consecuencias sobre los pendientes

- **P3 (`agregar_ponderado_idps`) se cierra como "no aplica".** Sin
  ponderador no hay función de agregación que escribir. El patrón del madre
  (ponderar por `nalu`) no se traslada. De `10_utils.R` del madre solo se
  copian `instalar_si_falta()` y `log_msg()`.
- **P6 (pipeline) cambia de alcance:** lectura de las 3 familias →
  homologación de esquema por año (texto vs ID) → join `niveles`↔`rbd` por
  `rbd×agno` para traer `cod_grupo`/`cod_depe2` a niveles (restricción
  v02-6) → catálogos indicador/dimensión/subdimensión. **Sin paso de
  agregación.** El Parquet de salida es por establecimiento-grado-indicador.
- **P9 (UI):** el prototipo de Claude Design asumía comparación territorial;
  se reposiciona hacia la grilla de radares por GSE. Consideración de escala
  anotada para P9: con varios establecimientos por GSE × grados, la grilla
  puede crecer; es un problema de diseño de UI, no de método.

## 7. Limitación declarada

Este motor **no entrega comparación territorial agregada** (a diferencia de
`slep_simce_estandares_aprendizaje`, que sí la hace para SIMCE porque SIMCE
publica el número de evaluados). Si en el futuro la Agencia publicara el
número de respondentes IDPS por establecimiento, esta decisión debe
revisarse: existiría entonces un ponderador válido y la agregación
territorial volvería a ser posible.
