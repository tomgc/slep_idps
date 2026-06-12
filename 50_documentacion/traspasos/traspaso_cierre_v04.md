# Traspaso de cierre — slep_idps — v04

## 1. Identificación

- **Proyecto:** `slep_idps` (motor de comparación IDPS, hermano de `slep_simce_adecuado`).
- **Versión:** v04.
- **Fecha:** 2026-06-12.
- **Sesión:** 4. Foco: consolidación de Git (reorganización de `20_insumos/`),
  lectura del `agregar_ponderado()` del madre (P3), resolución parcial de P4 con
  evidencia dura, y feedback estructurado del prototipo de UI como especificación
  de datos. Sesión mixta que pivoteó de técnica a diseño; se cierra por higiene.
- **Entorno:** R 4.5.x / Positron / zsh (macOS aarch64) / Claude Code. Rama A
  (datos públicos, raíz unificada).
- **Archivos principales modificados:** ninguno de código. Cambio real en Git:
  reorganización de `20_insumos/` (renombres a snake_case, glosas y referencias a
  `auxiliares/`, año explícito en niveles) consolidada en dos commits.

## 2. Resumen ejecutivo

Sesión sin cambios de código ejecutable. Se consolidó en Git una reorganización
de `20_insumos/` que había quedado a medias en disco (archivos renombrados a
snake_case y movidos a `auxiliares/` pero sin commitear): se verificó par a par
con detección de renames y se cerró en un commit limpio que preservó historial
al 100%. Se confirmó que P5-bis (versionar censo) ya estaba hecho desde v02. Se
obtuvo y leyó por fin el `agregar_ponderado()` real del madre, lo que **desbloquea
P3 pero revela que la función no es portable tal cual**: asume el esquema SIMCE
(`nalu`, `palu_eda_ade/ele/ins`, `marca`), columnas que ningún archivo IDPS tiene.
P4 queda **resuelto en su diagnóstico**: ninguna familia IDPS (`rbd`, `rbd_dim`,
`niveles`) publica número de evaluados ni respondentes, y las glosas tampoco; el
ponderador por evaluados del madre es inaplicable y la decisión de método pasa a
requerir input de dominio del usuario. Finalmente, el usuario compartió el
prototipo de UI completo (React/D3, datos de ejemplo) construido en Claude Design;
se analizó a fondo y se entregó feedback que lo reposiciona como **spec visual + 5
puntos de spec de datos** para P6. La sesión se cierra con protocolo por pivote de
dominio.

## 3. Estado al cierre

**Qué funciona:**
- Repo sincronizado con `origin/main` (último commit `9081ba2`, reorganización de
  `20_insumos/`). Working tree limpio salvo snapshots del escáner sin commitear.
- Censo de insumos versionado (`32_censo_insumos.R` + `censo_insumos.parquet/.md`),
  confirmado desde v02.
- Corpus conceptual versionado (`idps_corpus_conceptual.json/.md`), commit `30ed63e`.
- Prototipo de UI funcional (Claude Design): dos radares, evolución, distribución,
  con datos de ejemplo deterministas. Respeta GSE inviolable, preliminar, supresión.

**Qué no funciona / no existe:**
- Pipeline de datos (P6): `00_build.R` sigue siendo stub. Sin lectura real.
- `10_utils.R` de `slep_idps`: sigue sin `agregar_ponderado()` (P3 no aplicado;
  ahora se sabe que requiere **adaptación**, no copia literal).
- Ponderación territorial (P4): diagnóstico cerrado (no hay ponderador de
  evaluados en ninguna fuente), **decisión de método pendiente de dominio**.

**Delta respecto a v03:** la reorganización de `20_insumos/` pasó de "a medias en
disco" a "consolidada en Git con historial preservado". P3 pasó de "bloqueado por
archivo faltante" a "desbloqueado pero requiere adaptación de esquema". P4 pasó de
"dos fuentes candidatas a evaluar" a "ninguna fuente sirve como ponderador de
evaluados; decisión de método escalada al usuario". Se incorporó el prototipo de
UI como insumo de diseño con feedback de datos documentado.

## 4. Registro detallado de cambios

**Cambio 24 — Consolidación en Git de la reorganización de `20_insumos/`.**
Categoría: Limpieza / deuda técnica. Qué: se detectó que `20_insumos/` tenía
archivos renombrados a snake_case y movidos a `auxiliares/` en disco pero sin
commitear (Git los veía como delete+untracked). Se verificó par a par con
`git status --short -M` y `git add -A --dry-run` antes de commitear, confirmando
que Git reconocía los renames al 100% (binarios idénticos). Se cerró en commit
`9081ba2`. Por qué: la política §3 exige commit limpio antes de avanzar a P3/P4, y
el delete+add habría roto el historial de los renames. Cómo se verificó: la salida
del commit listó `rename ... (100%)` para los 20 renames y `delete`/`create` para
el único borrado genuino y los nuevos. Tensión resuelta: se prefirió detección
automática de renames (preserva historial) sobre `git mv` manual (imposible:
archivos ya movidos en disco).

**Cambio 25 — Verificación de P5-bis (censo ya versionado).** Categoría: Limpieza /
deuda técnica. Qué: se intentó versionar el censo como primera tarea, pero
`git add` no produjo cambios (los archivos no aparecían en staged/modified/
untracked), confirmando que ya estaban committeados desde v02. P5-bis se cierra sin
acción. Por qué: el pendiente P5-bis del v03 era condicional ("si no se hizo en
v02").

**Cambio 26 — Lectura del `agregar_ponderado()` del madre y diagnóstico de
portabilidad (P3).** Categoría: Perfilado / exploración. Qué: tras tres adjuntos
erróneos del `10_utils.R` de `slep_idps`, se obtuvo el del madre vía
`cat ~/Projects/slep_simce_adecuado/10_utils/10_utils.R`. La función pondera
`palu_eda_ade` por `nalu` con umbral MINEDUC (≥10), exclusión por `marca`, y trae
7 tests inline. Diagnóstico: **no es portable literal** al esquema IDPS (medida es
`prom`, no `palu_eda_*`; no hay `nalu` ni `marca`). P3 requiere trasladar el
*patrón* (ponderar por evaluados, umbral, GSE como dimensión), no clonar columnas.
Por qué: homologar no es copiar; copiar a ciegas habría producido una función que
falla en el primer `stopifnot` contra datos IDPS.

**Cambio 27 — Resolución del diagnóstico de P4 (no existe ponderador de
evaluados).** Categoría: Perfilado / exploración. Qué: se evaluaron las columnas
reales de las familias `rbd` y `niveles` contra el censo y se inspeccionaron las
glosas. Hallazgo duro: **ninguna familia IDPS publica número de evaluados ni
respondentes**; la familia `rbd` trae `prom/dif/sigdif/difgru/sigdifgru` +
atributos, sin conteo; las glosas solo traen "Características generales"
descriptivas. Conclusión: la Fuente A del v03 (`nalu` del madre) es ponderador de
*SIMCE*, no del cuestionario IDPS (distinto instrumento, distinta participación):
conceptualmente inválido, no solo de cobertura. La decisión de método (MATRICULA /
promedio simple declarado / `prom` territorial pre-agregado si la Agencia lo
publica) requiere input de dominio. Por qué: define toda la agregación de P6 y es
una decisión estratégica (regla 0.3 / autonomía).

**Cambio 28 — Feedback estructurado del prototipo de UI como spec de datos.**
Categoría: Visualización / diseño. Qué: el usuario compartió el prototipo completo
(Claude Design): `Motor_IDPS.html`, `idps-data.js`, `idps-charts.jsx`,
`idps-controls.jsx`, `idps-app.jsx`, fuentes gobCL/Museo Sans, `PROMPT.md`. Se
leyó el contrato de datos (`window.IDPS`) y su consumo en charts, y se entregó
feedback de 8 puntos: 5 de datos (indicador NO es promedio de dimensiones;
distribución viene medida en familia `niveles`, no derivada; falta `cod_grupo` en
camino de niveles → join obligatorio; supresión bien modelada; significancia se
lee de `sigdif/sigdifgru`, no se calcula) y 3 de dominio (cobertura temporal
correcta; orden de dimensiones correcto; desajuste de granularidad dimensión vs
subdimensión en niveles). Por qué: el prototipo es la mejor especificación visual
disponible para P9, pero su capa de datos asume cosas que P6 debe producir de
fuente real. Reposiciona el prototipo como contrato a poblar.

## 5. Backlog acumulativo

### Objetivo del proyecto

`slep_idps` es un motor de comparación interactivo de los Indicadores de
Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación.
Produce un HTML autocontenido (React 18 + D3 v7) publicado en GitHub Pages que
compara territorios (establecimiento, comuna, SLEP, región, país) y su evolución
temporal, siempre segmentado por grupo socioeconómico (GSE), para el equipo de
Monitoreo y Seguimiento del SLEP Costa Central. Hermano de `slep_simce_adecuado`,
del que reutiliza catálogos, patrones de agregación, escáner y estética. Activo
desde 2026-06-11.

### Nota metodológica

Un "cambio" es una solicitud distinguible del usuario, no las acciones técnicas
que la implementan. No cuentan los errores del asistente corregidos en el acto;
sí cuentan los bugfixes reportados por el usuario. Clasificación por intención
primaria. Fuente del conteo: registro detallado de cada traspaso.

### Clasificación temática (refinada en v04)

| Categoría | N° | % | Descripción |
|---|---|---|---|
| Infraestructura y scaffold | 3 | 11% | Estructura canónica, stubs, git, repo remoto |
| Gobernanza de datos | 4 | 14% | Verificación sensibilidad, decisión, depuración directorio, ignore |
| Visualización / diseño | 4 | 14% | Prototipo radar, reubicación, prompt de diseño, feedback prototipo como spec |
| Perfilado / exploración de datos | 4 | 14% | Censo, mapa de cobertura, lectura utils madre, diagnóstico P4 |
| Limpieza / deuda técnica | 5 | 18% | P1 (no-op), P2 reubicación, commits atómicos, consolidación 20_insumos, verif. P5-bis |
| Documentación conceptual / contenido | 8 | 29% | Corpus dual IDPS, niveles por ciclo, reconciliación de fuentes |

(28 cambios acumulados a v04. La categoría "Documentación conceptual / contenido"
baja de 35% a 29% al recalcularse sobre el nuevo total de 28; sigue siendo la
dominante pero ya no supera el 25% por margen amplio. "Limpieza / deuda técnica"
sube a 18% por la consolidación de Git de esta sesión.)

### Resumen estadístico por sesión

| Sesión | Traspasos | N° cambios | Modelo | Foco |
|---|---|---|---|---|
| 1 | v01 | 6 | Opus 4.8 | Paso 0 + prototipo radar |
| 2 | v02 | 9 | Opus 4.8 | Limpieza + gobernanza + censo P5 + prompt diseño |
| 3 | v03 | 8 | Opus 4.8 | Documentación conceptual IDPS (P10) + corpus dual |
| 4 | v04 | 5 | Opus 4.8 | Consolidación Git + lectura utils madre + diagnóstico P4 + feedback prototipo |
| **Total** | | **28** | | |

### Detalle cronológico

- Sesión 1 (2026-06-11): cambios 1–6 (ver traspaso v01).
- Sesión 2 (2026-06-11): cambios 7–15 (ver traspaso v02). Cambio 9 resuelve la
  precaución de gobernanza del backlog.
- Sesión 3 (2026-06-12): cambios 16–23 (ver traspaso v03). El conjunto cierra P10.
- Sesión 4 (2026-06-12): cambios 24–28 (ver sección 4). Sesión sin código
  ejecutable; consolida Git, desbloquea P3 (con caveat de adaptación), cierra el
  diagnóstico de P4 e incorpora el prototipo de UI con feedback de datos.

### Delta del backlog

5 entradas nuevas (24–28). Refinamiento de taxonomía: sin categorías nuevas; los
porcentajes se recalcularon sobre el nuevo total de 28. "Limpieza / deuda técnica"
y "Perfilado / exploración" crecen; "Documentación conceptual" baja en peso
relativo.

## 6. Bugs de la sesión

No aplica: sin código ejecutable, sin bugs. La única anomalía recurrente fue
operativa (el `10_utils.R` adjuntado tres veces era el de `slep_idps`, no el del
madre), resuelta leyendo el archivo correcto por ruta absoluta vía `cat` en
terminal. Aprendizaje operativo, no bug de código (ver sección 7).

## 7. Aprendizajes y restricciones descubiertas

- **El `agregar_ponderado()` del madre NO es portable literal a IDPS.** Principio:
  C.6 (rigor de esquema) + B.1 (pensar antes de codificar). Contexto: la función
  del madre asume `nalu`/`palu_eda_ade`/`marca` (esquema SIMCE); los datos IDPS
  tienen `prom` y ningún conteo de evaluados. Homologar P3 = trasladar el patrón
  (ponderar por evaluados disponibles, umbral, GSE como dimensión, tests inline
  propios), no clonar la firma. Ejemplo: copiarla habría fallado en el primer
  `stopifnot("Faltan columnas requeridas...")`.
- **Ninguna fuente IDPS publica evaluados ni respondentes por establecimiento.**
  Principio: inviolable de ponderación. Contexto: las 3 familias (`rbd`, `rbd_dim`,
  `niveles`) traen solo medidas y atributos; las glosas son descriptivas. El
  ponderador del madre (`nalu` SIMCE) es de otro instrumento y no sirve como proxy
  válido. Consecuencia: P4 no se resuelve con datos disponibles; exige decisión de
  método del usuario (MATRICULA del directorio / promedio simple declarado / `prom`
  territorial pre-agregado de la Agencia si existe).
- **El prototipo de UI deriva por cálculo cinco cosas que el dato real trae
  medidas.** Principio: inmutabilidad de la fuente (C.5.2.1). Contexto: el mockup
  calcula indicador = promedio de dimensiones, distribución desde el `prom`, y
  significancia con umbral aleatorio. En real: indicador y dimensión son `prom`
  independientes de dos familias; la distribución es `niv_*_por` de la familia
  `niveles`; la significancia es `sigdif`/`sigdifgru`. P6 lee, no deriva. Ejemplo:
  `idps-data.js:242` (indicador promediado), `:274` (distribución inventada),
  `:264` (significancia con umbral 2.0–5.2 aleatorio).
- **Verificar siempre que el archivo del madre adjuntado sea del madre.** Principio:
  B.1 (no operar sobre estado supuesto). Contexto: `10_utils.R` es un nombre que
  existe en ambos proyectos; el selector de adjuntos puede traer el equivocado. La
  verificación barata es leer el header (`# Proyecto: ...`) y buscar la función
  esperada antes de usarla. Solución robusta: `cat` por ruta absoluta o
  `grep -rl "funcion" ~/Projects/<madre>/`.

## 8. Decisiones de diseño

**Decisión 1 — Consolidar la reorganización de `20_insumos/` con detección
automática de renames, no con `git mv`.** Alternativas: (a) `git mv` archivo por
archivo (imposible: ya movidos en disco); (b) `git rm` viejos + `git add` nuevos
(rompe historial); (c) `git add -A` con detección de renames al commit (elegida).
Justificación: con binarios idénticos, Git empareja delete+add como rename al 100%,
preservando historial sin trabajo manual. Verificado en el `--dry-run` antes de
commitear. Implicancia: historial de los insumos intacto para auditoría futura.

**Decisión 2 — Reposicionar el prototipo de UI como spec visual + spec de datos,
no como motor a migrar directamente.** Alternativas: (a) conectar el prototipo al
pipeline tal cual; (b) usarlo como contrato y construir P6 hacia su JSON, corrigiendo
los 5 puntos de datos (elegida como dirección, no ejecutada). Justificación: el
prototipo cristalizó el modelo visual correcto pero su capa de datos asume cálculos
que violan inmutabilidad de la fuente. Construir P6 hacia un contrato corregido
evita un Parquet que después haya que reformatear. Implicancia: la próxima sesión
de datos parte del prototipo como referencia, con los 5 puntos como checklist.

## 9. Constantes y parámetros vigentes

Sin cambios respecto a v03. Referencia de las constantes del prototipo (datos de
ejemplo, NO canónicas para el pipeline): umbral de supresión simulado, paleta de
indicadores (rojo `#EE2D49`, amarillo `#FFC92E`, verde `#9BC93E`, azul `#2A8FD9`),
paleta de territorios (plum `#4A2746`, ocean `#0062A0`, coral `#E88663`, olive
`#75924E`), máx. 4 territorios. El umbral MINEDUC real de evaluados (≥10) viene del
madre pero **no es aplicable a IDPS** mientras no haya conteo de evaluados (ver P4).

## 10. Arquitectura de archivos

Estructura conforme a Rama A. La reorganización de `20_insumos/` quedó consolidada:
glosas y referencias en `auxiliares/`, niveles con año explícito, nombres en
snake_case (PDF fuente conservan nombres heredados como excepción §1.2.4). El
escáner debe re-correrse al cierre para sellar el snapshot post-commits (instruido
en el mensaje de cierre). Referencia: `estructura_actual.md` re-corrido.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

- **P3 — Homologar `10_utils/10_utils.R` adaptando `agregar_ponderado()` al esquema
  IDPS.** Tipo: bloqueante para agregación. Impacto: alto. Complejidad: media.
  **Nuevo contexto v04:** NO es copia literal del madre; la función real del madre
  pondera `palu_eda_ade` por `nalu` (esquema SIMCE inexistente en IDPS). Adaptar:
  parametrizar columna de medida (`prom`) y ponderador (el que decida P4), con tests
  inline propios. `instalar_si_falta()` y `log_msg()` sí se copian idénticos (ya
  están). Depende de P4 (la firma cambia según el ponderador). Criterio de éxito:
  `10_utils.R` con la función adaptada + tests que pasen contra una muestra IDPS.
- **P4 — Decidir el método de ponderación territorial.** Tipo: bloqueante /
  **decisión de dominio**. Impacto: alto. **Nuevo contexto v04:** diagnóstico
  cerrado — ninguna fuente IDPS trae evaluados/respondentes; el `nalu` del madre es
  de SIMCE (otro instrumento), inválido como proxy. Opciones reales: (1) ponderar
  por `MATRICULA` del directorio depurado, declarando la limitación; (2) promedio
  simple declarado como método explícito (no placeholder); (3) usar `prom`
  territorial pre-agregado si la Agencia lo publica (análogo a `simce_comunal` del
  madre). Recomendación registrada: opción 3 con fallback a 1. Criterio de éxito:
  método elegido por el usuario y documentado en `decisiones/`.
- **P6 — Pipeline de datos.** Tipo: funcionalidad. Impacto/Complejidad: alta.
  Lectura 3 familias → normalización → **join `niveles`↔`rbd` por `rbd×agno` para
  traer GSE/dependencia (restricción v02-6)** → catálogos del madre → agregación por
  el método de P4, por indicador/dimensión × GSE × territorio × grado × año.
  **Nuevo contexto v04 (5 puntos del feedback del prototipo):** (a) indicador y
  dimensión son `prom` independientes de dos familias, no derivar uno del otro;
  (b) distribución Bajo/Medio/Alto se lee de `niv_*_por` (familia `niveles`), no se
  calcula; (c) niveles solo existen para subdimensiones EST (regla v03-11);
  (d) significancia se lee de `sigdif` (vs grado/año previo) y `sigdifgru` (vs grupo
  GSE), son dos columnas distintas; (e) granularidad: niveles vienen por subdimensión,
  la UI los muestra por dimensión → decidir si agregar (ponderado) o bajar la UI a
  subdimensión.
- **P7 — Vista de distribución Alto/Medio/Bajo.** Depende del join de P6. La
  descripción textual por nivel ya está en el corpus, por ciclo (seleccionar según
  grado, v03-12).
- **P8 — Drill-down por indicador** (radar secundario). Tipo: mejora visual.
- **P9 — Conectar la interfaz definitiva** partiendo del prototipo de Claude Design.
  **Nuevo contexto v04:** el prototipo completo ya está en mano (archivos en
  uploads de esta sesión); es la spec visual. Consumir el corpus `.json` para
  definiciones; corregir los 5 puntos de datos antes de poblar `window.IDPS` con
  datos reales.
- **P10-bis — Versionar los scripts de generación del corpus** (`generar_md.py`,
  `inyectar_niveles.py`). Tipo: decisión / deuda menor. **Pendiente desde v03, no
  abordado en v04.** Los scripts no aparecen en el escáner; antes de versionarlos
  hay que localizar su ruta real (o documentar que el `.md` es derivado en el README
  del insumo).
- **P-meta — Sección metodológica del motor.** Encaja junto a P9 con el prototipo
  en mano, usando el corpus como fuente.

### Evaluación de deuda técnica

Zonas frágiles: ninguna en código ejecutable (sin código aún). El prototipo usa
promedio simple, distribución inventada y significancia aleatoria: **no migrar al
motor sin corregir los 5 puntos y sin resolver P4.** Oportunidad: el prototipo
define el contrato `window.IDPS`; P6 debe producir exactamente esa estructura
(corregida), evitando reformateos posteriores.

### Auditoría de cierre (POLÍTICA 5.6)

- ¿Datos crudos aislados e inmutables? → Sí; xlsx fuente read-only en `20_insumos/`.
- ¿Pipeline corre de cero sin intervención manual? → No aplica aún (sin pipeline).
- ¿Cada transformación crítica tiene check de validación? → No aplica (sin
  transformaciones esta sesión). La consolidación de Git se verificó con `--dry-run`
  antes de commitear.
- ¿Outputs reproducibles e idempotentes? → No aplica (sin outputs nuevos).
- ¿Decisiones metodológicas como constantes nombradas? → Pendiente para P6; el
  método de P4 deberá quedar como constante nombrada con su decisión en
  `decisiones/`.
- ¿Nombres sin tildes/ñ/espacios? → Sí; la reorganización de esta sesión llevó los
  insumos a snake_case (PDF fuente conservan nombres heredados, excepción declarada).

### Ruta sugerida para la próxima sesión

La próxima sesión natural es **TÉCNICA** (implementación del pipeline), salvo que
el usuario prefiera primero una sesión de **decisión de dominio** corta para cerrar
P4 (es la llave de todo lo demás). Orden sugerido:
1. Re-correr el escáner si no se hizo al cierre de v04. 🔧
2. **P4 primero** (decisión de método de ponderación): es bloqueante de P3 y P6, y
   requiere input de dominio del usuario sobre qué publica la Agencia. Si el usuario
   confirma que existe `prom` territorial pre-agregado, esa es la fuente; si no,
   elegir entre MATRICULA y promedio simple declarado.
3. P3 (adaptar `agregar_ponderado()` al esquema IDPS, con el ponderador de P4).
4. P6 (pipeline con el join `niveles`↔`rbd` y los 5 puntos del feedback del prototipo).
Diferir P7/P8/P9 hasta que P6 produzca Parquet. P10-bis sigue trivial y pendiente.

## 12. Instrucciones específicas para la próxima sesión

- ✅ ANTES de aplicar P3, recordar que `agregar_ponderado()` del madre asume
  esquema SIMCE (`nalu`/`palu_eda_ade`/`marca`): NO copiarla literal, adaptarla al
  `prom` de IDPS y al ponderador que decida P4 (aprendizaje v04).
- ✅ ANTES de cualquier agregación territorial, recordar que NO existe conteo de
  evaluados en IDPS: el ponderador será MATRICULA, promedio simple declarado o
  `prom` pre-agregado, según P4 (aprendizaje v04).
- ✅ ANTES de poblar `window.IDPS` con datos reales, corregir los 5 puntos del
  feedback: indicador/dimensión independientes; distribución de `niv_*_por`;
  niveles solo EST; significancia de `sigdif`/`sigdifgru`; granularidad subdimensión
  vs dimensión.
- ✅ ANTES de construir cualquier vista de niveles (P7), seleccionar la descripción
  de nivel **según el grado/ciclo** del dato: básica (4°/6°) y media (II medio)
  tienen textos distintos (v03-12).
- ✅ ANTES de mostrar niveles de una subdimensión, verificar que sea de actor EST:
  las DOC/PAD no tienen niveles por diseño (v03-11). No es dato faltante.
- ✅ ANTES de emparejar subdimensiones corpus↔datos, normalizar nombres (sin tildes,
  minúsculas) y consultar `_meta.variantes_nombre` (v03-13).
- ✅ ANTES de tratar el corpus `.md` como fuente, recordar que es derivado del
  `.json` vía `generar_md.py`: editar el JSON.
- ✅ ANTES de usar un `10_utils.R` "del madre", verificar el header y que contenga
  `agregar_ponderado()`: hay un archivo homónimo en `slep_idps` (aprendizaje v04).
- 🔒 El corpus cubre solo los 4 indicadores de cuestionario; los 4 administrativos
  (Asistencia, Retención, Equidad de género, Titulación TP) son escalares sin
  subdimensión: el motor no los trata con la misma estructura jerárquica.
- 🔒 GSE inviolable: la segmentación aparece en todo output, jamás colapsada.
- 🔒 No mezclar indicadores, dimensiones, grados ni años en una misma cifra agregada.
- 🔒 No publicar ninguna cifra agregada territorial sin resolver P4: el promedio
  simple del prototipo es placeholder, no método (mientras no se declare como método
  explícito elegido).
- 🔒 El directorio original `directorio_oficial_ee.csv` (con RUT) NO se versiona
  jamás; solo el depurado `_publico.csv`.
- 🔒 `NOM_RBD` y `Nombre del establecimiento` son insumos internos de join:
  PROHIBIDO filtrarlos a cualquier output publicado.
- 🔒 Si entra una base por estudiante → Rama B sin excepción (limpiar historial Git).

## 13. Fragmentos de código de referencia

`agregar_ponderado()` del madre (referencia del PATRÓN a adaptar, NO a copiar; el
esquema IDPS no tiene `nalu`/`palu_eda_*`/`marca`). El núcleo a preservar es:
filtrar filas válidas → agrupar por `group_vars` → `sum(peso * medida/100) /
sum(peso) * 100`, con `n_estab` y `n_evaluados` (en IDPS: `n_peso`) como columnas
de control. La firma IDPS deberá parametrizar la columna de medida y la de peso:

```r
# Forma objetivo (P3, adaptada a IDPS — pseudo-firma):
# agregar_ponderado_idps(df, group_vars, col_medida = "prom", col_peso = <P4>)
#   filtra: !is.na(.data[[col_peso]]), !is.na(.data[[col_medida]]), (umbral si aplica)
#   agrupa: dplyr::across(dplyr::all_of(group_vars))
#   resume: prom_pond = sum(peso * medida) / sum(peso); n_estab = n(); n_peso = sum(peso)
# Tests inline propios: GSE como dimensión, supresión (NA), peso 0, una sola fila.
```

Verificar el archivo del madre correcto antes de usarlo:

```
grep -rl "agregar_ponderado" ~/Projects/slep_simce_adecuado/ --include="*.R"
cat ~/Projects/slep_simce_adecuado/10_utils/10_utils.R
```

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 5 — decisión P4 + pipeline (Opus 4.8)`
- **Mensaje de apertura pre-armado:** Tipo CONTINUATION. El protocolo (política +
  settings) vive en la knowledge base del Project y en `50_documentacion/activa/`;
  léelo desde ahí. Sesión TÉCNICA, pero arranca con una **decisión de dominio (P4)**
  que es la llave del pipeline. Adjunto el traspaso v04, el escáner re-corrido, el
  `10_utils.R` del madre (con `agregar_ponderado()` real, para P3) y el
  `censo_insumos.parquet` (para P6). Ruta sugerida: escáner → P4 (decidir método de
  ponderación) → P3 (adaptar utils) → P6.
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar que estén al día):*
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `CLAUDE.md` (la sesión técnica correrá en Claude
     Code); el corpus `idps_corpus_conceptual.json` y los archivos del prototipo
     (`idps-data.js`, `idps-charts.jsx`, etc.) solo si se aborda P9 (no necesarios
     para P3/P4/P6).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v04.md`; el escáner
     `estructura_actual.md` re-corrido; `10_utils.R` **del madre** (verificar que sea
     el de `slep_simce_adecuado`, con `agregar_ponderado()`); `censo_insumos.parquet`.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión
  más actualizada al abrir y avisarlo. P4 es una decisión de dominio: ten a mano qué
  publica la Agencia (¿IDPS pre-agregados por comuna/SLEP/región? ¿algún conteo de
  respondentes en cortes no perfilados?) para cerrarla rápido.
