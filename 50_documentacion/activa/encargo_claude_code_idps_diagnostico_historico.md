# Encargo autónomo — Diagnóstico forense del histórico IDPS 2014-2019

> **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, Rama A
> pública). **Sesión:** 10. **Fase:** P5, tramo 1 de 3 (DIAGNÓSTICO).
> **Tipo de encargo:** autónomo dirigido por meta, modo secuencial, ejecuta todo
> en este turno.
>
> Este encargo cubre **solo el diagnóstico forense** del material depositado en
> `20_insumos/historico_2014_2018/`. NO organiza archivos, NO integra al pipeline,
> NO toca el motor ni ningún script de `30_procesamiento/`. La organización (tramo
> 2) y la integración (tramo 3) son encargos posteriores que dependen del
> inventario que este produce. No te adelantes a ellos.

---

## 0. Contrato de ejecución

- **Modo:** autónomo, secuencial. Ejecuta todas las fases en este turno sin pedir
  confirmación intermedia.
- **Disciplina de rutas:** rutas absolutas SIEMPRE desde la raíz del proyecto
  (`/Users/tomgc/Projects/slep_idps`). No asumas `cd` previo. Usa
  `git -C /Users/tomgc/Projects/slep_idps ...` para cualquier comando git.
- **Stack:** R-only para el análisis (R 4.5.x / Positron, macOS aarch64). Pipe
  nativo `|>`, `dplyr >= 1.1` con `.by=`, `here::here()` para rutas internas,
  llaves siempre `character`. Lectura de Excel con `readxl` (`read_xls` para
  `.xls` legacy, `read_xlsx` para `.xlsx`; `readxl::read_excel` autodetecta, pero
  si falla la autodetección usa el lector explícito).
- **Sin comentarios `#` inline en comandos de terminal zsh** (rompen en zsh
  interactivo). Los comentarios van dentro de los scripts `.R`, no en la línea de
  comando.

### 0.1 Regla de detención (PARA y reporta, no improvises)

Detente y reporta SIN continuar solo si:

1. **Gobernanza:** encuentras en `historico_2014_2018/` algún archivo con datos
   personales identificables a nivel de individuo (RUT de estudiante, nombre de
   estudiante, asistencia nominal). El histórico IDPS es agregado por
   establecimiento (igual que el actual), así que esto NO debería ocurrir; si
   ocurre, es una anomalía grave: detente y reporta.
2. **Lectura imposible:** un archivo no se puede abrir con ningún lector de
   `readxl` (corrupto, protegido con contraseña, formato no soportado). Regístralo
   en el inventario como "ilegible" con el error exacto y SIGUE con los demás; solo
   detente del todo si más de la mitad de los archivos son ilegibles (señal de un
   problema sistémico).
3. **Contradicción estructural con la meta:** el contenido real desmiente
   frontalmente el supuesto de que el histórico es indicador-ancho (p. ej. los
   archivos traen formato largo con dimensiones y niveles como 2022+). En ese caso
   el plan de integración posterior cambia por completo: documenta el hallazgo en
   el diagnóstico y señálalo en el reporte final como gate para el titular.

Fuera de estos tres casos, ejecuta con autonomía: rutas, warnings, codificación,
elección de lector Excel, todo se resuelve sin preguntar.

### 0.2 Invariante maestro de este encargo: READ-ONLY sobre todo lo existente

**Este es un encargo de lectura.** No modificas, mueves, renombras ni borras NINGÚN
archivo preexistente. No tocas `34_leer_normalizar_idps.R`, `10_configuracion.R`,
ningún crosswalk, ningún `.xlsx`/`.xls` de datos, ni `idps_largo.parquet`. No corres
`run_all()` ni ninguna etapa del pipeline.

Los **únicos** artefactos que creas son:

1. Un script de diagnóstico efímero: `/Users/tomgc/Projects/slep_idps/verificar_historico_idps.R`
   (cae en el patrón `/verificar_*.R` del `.gitignore`; **NO se versiona**).
2. El informe de diagnóstico en Markdown:
   `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/diagnostico_historico_idps.md`
   (output de trabajo; **NO se versiona en este encargo** — el titular decide al
   revisarlo).
3. Un parquet de respaldo del inventario tabular (para que el tramo 2 lo consuma
   sin re-parsear): `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/inventario_historico_idps.parquet`
   (output de trabajo; **NO se versiona** en este encargo).
4. El log de cierre en `50_documentacion/andamios/logs/` (ver sección 4).

Nada más se crea, nada existente se altera. Si en algún momento dudas si una acción
es read-only, NO la hagas: el costo de no hacerla es cero; el de alterar un crudo es
re-descargarlo de la Agencia.

---

## 1. Contexto mínimo suficiente

### 1.1 Qué es el proyecto y dónde está el dato

`slep_idps` es un motor de visualización de los Indicadores de Desarrollo Personal
y Social (IDPS) de la Agencia de Calidad de la Educación, a nivel nacional,
desplegado en GitHub Pages. Es Rama A (datos 100% públicos, versionados en el repo).

El pipeline vigente lee tablas IDPS de la raíz de `20_insumos/` para los años
**2022-2025** y produce `40_salidas/intermedios/idps_largo.parquet`, un parquet
largo por establecimiento-grado-año-jerarquía. El script que lo hace es
`30_procesamiento/34_leer_normalizar_idps.R` (NO lo toques; solo se describe para
contexto).

### 1.2 Qué se depositó y dónde (el material de este diagnóstico)

El titular depositó manualmente material IDPS **2014-2019** en:

```
/Users/tomgc/Projects/slep_idps/20_insumos/historico_2014_2018/
```

(El nombre de la carpeta dice "2018" pero el rango real es **2014-2019**; no la
renombres, es trabajo de otro tramo.)

Esta carpeta NO está mapeada por el pipeline: `34` hace `fs::dir_ls(here::here(
"20_insumos"))` **no recursivo**, así que las subcarpetas quedan fuera de su
alcance. Por eso es seguro que el material esté ahí sin que ninguna corrida lo
ingiera a medias.

**Advertencia sobre el contenido de la carpeta:** según el escáner
(`50_documentacion/estructura/estructura_actual.md`, 2026-06-21 13:09), la carpeta
contiene una MEZCLA de tres tipos de material que el diagnóstico debe distinguir:

- **(A) Histórico real 2014-2019** (el objetivo): subcarpetas por grado-año como
  `idps4b2014/`, `idps2m2017/`, `idps8b2019/`, con tablas de datos (`.xls` para
  2014-2016, `.xlsx` para 2017-2019) y sus glosas (`idpsAAAA_rbd_GLOSAS.xlsx`).
- **(B) Duplicados de años ya presentes en la raíz:** subcarpetas `idps2m2022/`,
  `idps4b2022/`, `idps4b2023/` con datos 2022-2023 que YA existen en la raíz de
  `20_insumos/`. NO son histórico; son copias.
- **(C) Material ajeno mal ubicado:** subcarpetas `2M/`, `4B/`, `6B/` que contienen
  datos de **2024** (`idps2M2024_rbd_*`, etc.), que no son histórico ni pertenecen
  a P5.

El diagnóstico debe **inventariar TODO** lo que hay en la carpeta y **clasificar
cada archivo en una de estas tres cubetas (A/B/C)**, más una cuarta para lo que no
encaje. No descartes ni muevas nada: solo identifica. El tramo 2 (organización)
usará esta clasificación para decidir qué promover, qué borrar por duplicado y qué
reubicar.

### 1.3 El régimen "ancho" del histórico (lo que esperas encontrar en la cubeta A)

Por las glosas 2014-2018 ya inspeccionadas por el asistente, el histórico sigue un
esquema RADICALMENTE más simple que el actual. Esto es una **hipótesis a verificar
archivo por archivo**, no un hecho asumido:

- **Formato ancho, indicador-solo:** una fila por establecimiento-grado, con los 4
  indicadores como columnas: `ind_am` (Autoestima académica y motivación),
  `ind_cc` (Clima de convivencia), `ind_pf` (Participación y formación ciudadana),
  `ind_hv` (Hábitos de vida saludable), todos en escala 0-100. NO hay columna `ind`
  + `prom` como en 2022+; NO hay dimensión, subdimensión ni niveles; NO hay
  significancia (`dif/sigdif/difgru/sigdifgru`).
- **Dos sub-épocas dentro del histórico:**
  - **2014-2016 (mínimo, ~7 variables):** solo `rbd, agno, grado, ind_am, ind_cc,
    ind_pf, ind_hv`. SIN geografía, SIN `cod_depe2`, **SIN `cod_grupo` (GSE)**, SIN
    ruralidad.
  - **2017-2019 (enriquecido, ~17-19 variables):** agrega `nom_rbd`, geografía
    (`cod_reg_rbd, nom_reg_rbd, cod_pro_rbd, nom_pro_rbd, cod_com_rbd, nom_com_rbd,
    nom_deprov_rbd`), `cod_depe2`, `cod_grupo`, `cod_rural_rbd`.
- **`cod_depe2` histórico tiene 3 categorías** (1 Municipal, 2 Particular
  subvencionado, 3 Particular pagado), SIN la categoría 4=SLEP que el dato actual
  introduce. (Esto importa para integración, no para diagnóstico; pero el
  diagnóstico DEBE reportar el conjunto de valores únicos de `cod_depe2` por año
  para confirmarlo.)
- **Los 4 indicadores `am/cc/pf/hv` son los mismos 4 indicadores actuales**
  (mismos macro-indicadores, misma escala). NO hay crosswalk de indicadores que
  resolver a este nivel. (A verificar: que no aparezca un quinto indicador ni
  una recodificación.)

Si algún archivo de la cubeta A se desvía de este esquema (columnas extra,
indicadores distintos, formato largo), es un hallazgo de primer orden: regístralo
con detalle.

### 1.4 Cobertura irregular conocida (a confirmar en el barrido)

El escáner sugiere cobertura grado×año incompleta en el histórico (p. ej. 2016 sin
8b; 2017 sin 6b; 2019 con solo 8b visible en subcarpeta `idps8b2019/`). El
diagnóstico debe construir la **matriz real grado×año** con presencia/ausencia
verificada, no inferida del nombre de carpeta. Recuerda: faltan archivos de
**2020-2021** y eso es ESPERADO (pandemia, sin SIMCE; no se publicaron). El
diagnóstico debe registrar 2020-2021 explícitamente como hueco confirmado, no como
omisión.

---

## 2. Invariantes (🔒) de este encargo

1. 🔒 **READ-ONLY total sobre lo existente** (ya detallado en 0.2). El único
   write permitido es a los 4 artefactos nuevos listados ahí.
2. 🔒 **No ingerir al pipeline.** No corras `34`, no toques `idps_largo.parquet`,
   no modifiques crosswalks ni configuración. `idps_largo.parquet` debe tener el
   mismo md5 al final que al inicio (md5 esperado:
   `50d9de4f1fc80259d29f499cdf46d9e1`; **verifícalo al abrir y al cerrar** y
   repórtalo en el log).
3. 🔒 **Llaves como `character`.** Al leer cualquier tabla, `rbd`, `cod_*`,
   `grado`, `agno` se tratan como texto para el perfilado (un `rbd` no es un
   número con el que se opera; es un identificador). Reporta sus valores como
   texto.
4. 🔒 **NA es dato, no error.** En IDPS, una medida vacía (`NA`, celda en blanco,
   "NA", "*", "s/i") es **supresión por resguardo estadístico**, nunca cero.
   Al perfilar, cuenta y reporta los NA y los marcadores de supresión textuales
   tal como aparecen; NO los conviertas a cero ni los imputes.
5. 🔒 **Clasificación honesta en cubetas A/B/C.** Cada archivo de la carpeta se
   asigna a exactamente una cubeta con su criterio explícito. Si un archivo es
   ambiguo, va a una cubeta "D — revisar" con la razón. No fuerces una
   clasificación para que cuadre.
6. 🔒 **Sin transformar antes de inventariar.** Los `.xls` se leen tal cual (no
   los conviertas a `.xlsx`; eso es tramo 2). El perfilado describe el dato como
   está, no como debería quedar.

---

## 3. Fases en orden estricto

El orden es deliberado: primero el censo de archivos (qué hay), luego el perfilado
profundo (qué contiene cada uno), luego la síntesis (qué significa para los tramos
siguientes). Lo determinista antes que lo interpretativo.

### Fase 0 — Estado real y preparación (lectura)

**Paso 0.1.** Registra el md5 inicial de `idps_largo.parquet`:
```
md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet
```
Anótalo; debe coincidir al cierre (🔒-2).

**Paso 0.2.** Lista recursivamente TODO el contenido de
`20_insumos/historico_2014_2018/` con tamaños, incluyendo `.xls`, `.xlsx` y
cualquier otra extensión. Ignora `.DS_Store` (basura de macOS, no la inventaríes
como dato pero NÓTALA como presente para el tramo 2 de limpieza). Construye la
lista maestra de archivos a diagnosticar.

**Paso 0.3.** Crea el script `/Users/tomgc/Projects/slep_idps/verificar_historico_idps.R`
con header banner (nombre, propósito, insumos, salidas, fecha), bloque de
auto-instalación (`readxl`, `dplyr`, `stringr`, `purrr`, `tibble`, `tidyr`,
`arrow`, `fs`, `here`), y la lógica de las fases 1-3. Este script es el motor del
diagnóstico; es efímero y no se versiona.

### Fase 1 — Censo y clasificación en cubetas (determinista)

Para CADA archivo de datos o glosa en la carpeta (recursivo), produce una fila de
inventario con:

- `ruta_rel`: ruta relativa desde la raíz del proyecto.
- `subcarpeta`: la subcarpeta inmediata (`idps4b2014`, `2M`, `IDPS2m2018`, etc.).
- `archivo`: nombre del archivo.
- `extension`: `.xls` / `.xlsx` / otra.
- `tamano_kb`.
- `tipo_contenido`: `datos` / `glosa` / `otro` (una glosa se reconoce por contener
  "GLOSAS"/"glosa" en el nombre o por tener hoja "Índice" + hojas descriptivas).
- `cubeta`: **A** (histórico real 2014-2019) / **B** (duplicado de año ya en la
  raíz: 2022/2023) / **C** (ajeno mal ubicado: 2024) / **D** (no clasificable —
  con razón).
- `criterio_cubeta`: una frase con el porqué de la cubeta (p. ej. "año 2024
  detectado en nombre interno de hoja → ajeno a P5").
- `grado_declarado` y `anio_declarado`: extraídos del nombre de archivo Y del
  contenido (ver Fase 2 para cómo se cruza). Si nombre y contenido discrepan,
  márcalo.
- `existe_en_raiz`: para cubeta B, TRUE/FALSE verificando si un archivo de mismo
  año-grado-familia ya está en la raíz de `20_insumos/` (compara por año, grado y
  familia lógica, no por nombre exacto: los nombres difieren).

Emite también la **matriz de cobertura grado×año** de la cubeta A: una tabla con
filas = grado (4b/6b/8b/2m), columnas = año (2014…2019), celdas = presencia del
archivo de datos (✓/✗) y, entre paréntesis, si tiene glosa. Marca 2020-2021 como
"hueco pandemia (esperado)".

### Fase 2 — Perfilado forense por archivo, hoja y columna (el núcleo)

Para CADA archivo de datos de la cubeta A (los 2014-2019 reales), y también para
cada glosa de la cubeta A, abre y perfila EXHAUSTIVAMENTE. Profundidad requerida:

**Por archivo:**
- Lista de hojas (`readxl::excel_sheets`).
- Para cada hoja, si es **glosa** (hoja descriptiva tipo "idps4b" con la tabla de
  variables): extrae el nombre de archivo declarado internamente, el nº de
  variables y de observaciones declarado, y el listado COMPLETO de variables con su
  descripción, valores posibles y tipo, tal como la glosa lo declara. Extrae además
  las tablas de códigos que la glosa incluya (Dependencia, GSE, Ruralidad, Grado) —
  el mapeo valor→descripción literal.
- Para cada hoja, si es **tabla de datos**: el perfilado por columna de abajo.

**Por columna de una tabla de datos (perfilado profundo, "dato por dato auditable"):**
- `nombre_columna` (normalizado a minúsculas con `trimws`).
- `tipo_R` detectado al leer.
- `n_total`, `n_na` (incluyendo blancos y marcadores de supresión textuales), `pct_na`.
- Para columnas **de código o categóricas** (`rbd`, `agno`, `grado`, `cod_depe2`,
  `cod_grupo`, `cod_reg_rbd`, `cod_pro_rbd`, `cod_com_rbd`, `cod_rural_rbd`, y
  cualquier columna con ≤ 60 valores distintos): **volcado COMPLETO del conjunto de
  valores únicos** (ordenados), con su frecuencia. Esto es el "dato por dato" que
  pidió el titular: cada valor distinto de cada código, auditable. Para `rbd`
  (identificador de alta cardinalidad) NO vuelques todos: reporta n distintos,
  min/max como texto, y si hay duplicados de `rbd` dentro de la misma hoja
  (no debería haberlos en una tabla por establecimiento).
- Para columnas **numéricas de medida** (`ind_am`, `ind_cc`, `ind_pf`, `ind_hv`, y
  cualquier `prom`/`ind` si apareciera): min, max, media, mediana, n de valores
  fuera del rango esperado 0-100 (reporta cuántos y ejemplos), n de NA/supresión.
  NO conviertas supresión a cero.
- Muestras: las primeras 5 y últimas 5 filas de la hoja (head/tail), para ojo
  humano.

**Cruce nombre vs contenido (crítico):**
- El año real del dato: lee la columna `agno` y reporta sus valores únicos. Cruza
  contra el año del nombre de archivo/carpeta. La Agencia históricamente publica el
  dato del proceso del año ANTERIOR (p. ej. "idps...2018" puede contener datos del
  SIMCE 2017 con `agno`=2017 o 2018 — REPORTA cuál es, no asumas). Documenta la
  convención real observada por año.
- El grado real: la columna `grado` del histórico puede ser inconsistente (el
  pipeline actual deriva el grado del NOMBRE por esta razón). Reporta los valores
  únicos de la columna `grado` por archivo y si calzan con el grado del nombre.

### Fase 3 — Síntesis e implicaciones para integración (interpretativa, pero sin decidir)

Con todo lo perfilado, redacta en el `.md` una síntesis que NO decide la
integración (eso es del asistente y el titular) pero le entrega el mapa:

1. **Confirmación o refutación del régimen ancho:** ¿todos los archivos de la
   cubeta A son indicador-ancho? ¿Aparece alguna desviación?
2. **Las dos sub-épocas:** ¿se confirma 2014-2016 mínimo vs 2017-2019 enriquecido?
   ¿Dónde exactamente cae el corte (qué año introduce GSE/geografía)?
3. **Convención de `agno`:** la tabla año-de-archivo → año-en-dato, observada.
4. **`cod_depe2` histórico:** confirma el conjunto de valores (¿3 categorías sin
   SLEP?) por año.
5. **`cod_grupo` (GSE):** en qué años existe y en cuáles no.
6. **Mapeo de indicadores:** confirma que `ind_am/cc/pf/hv` → indicadores 1/2/3/4
   actuales (sin quinto indicador, sin recodificación).
7. **Brecha estructural contra el parquet actual:** enumera, columna por columna,
   qué columnas del esquema canónico de `idps_largo` (las 30 de `COLS_CANONICAS`)
   podrá poblar el histórico y cuáles quedarán NA, por sub-época. Esto es el insumo
   directo del tramo 3.
8. **Inventario de basura para el tramo 2:** lista de `.DS_Store`, archivos de
   cubeta B (duplicados) y C (ajenos), con recomendación de destino (sin ejecutarla):
   qué borrar, qué ya está en raíz, qué reubicar.
9. **Preguntas abiertas / gates para el titular:** todo lo que el diagnóstico no
   puede resolver solo y requiere decisión (p. ej. si 2019 con solo 8b se carga
   igual; cómo nombrar los archivos al promoverlos; si `cod_depe2` de 3 categorías
   se mantiene o se re-mapea al esquema de 4 — esto último es decisión de
   integración, solo señálalo).

### Fase 4 — Persistir el inventario tabular

Escribe el inventario de Fase 1 (la tabla maestra de archivos con sus cubetas) y,
si es práctico, un perfil tabular resumido por columna, a
`40_salidas/intermedios/inventario_historico_idps.parquet` (escritura atómica:
write a `.tmp`, luego `file_move`). Esto permite que el tramo 2 consuma la
clasificación sin re-parsear. Output de trabajo, NO se versiona aquí.

---

## 4. Criterios de éxito verificables (B.4)

El encargo está completo cuando:

1. `40_salidas/intermedios/diagnostico_historico_idps.md` existe y contiene: el
   censo completo (Fase 1) con la matriz grado×año y la clasificación en cubetas;
   el perfilado por columna de TODOS los archivos de datos y glosas de la cubeta A
   (Fase 2), con volcado completo de valores únicos de toda columna de código; y
   la síntesis de 9 puntos (Fase 3).
2. Todo archivo de la carpeta `historico_2014_2018/` aparece en el inventario con
   una cubeta asignada. Conteo de archivos inventariados == conteo de archivos
   reales en la carpeta (excluyendo `.DS_Store`, que se cuenta aparte). Verifícalo
   explícitamente y repórtalo.
3. `inventario_historico_idps.parquet` existe y se relee sin error (`arrow::
   read_parquet` y un `nrow` de control).
4. **md5 de `idps_largo.parquet` idéntico al inicial** (🔒-2). Repórtalo
   explícitamente: valor inicial, valor final, IGUALES.
5. `git -C /Users/tomgc/Projects/slep_idps status` muestra como NO rastreados solo:
   `verificar_historico_idps.R`, `40_salidas/intermedios/diagnostico_historico_idps.md`,
   `40_salidas/intermedios/inventario_historico_idps.parquet`, el log nuevo, y lo
   que el titular haya depositado en `historico_2014_2018/`. NINGÚN archivo
   preexistente del repo aparece como modificado. Verifícalo y repórtalo. **No
   hagas commit de nada en este encargo** (el titular revisa el diagnóstico antes
   de versionar lo que corresponda).

---

## 5. Auto-auditoría antes de reportar (panel adversarial)

Este es un encargo de datos sensible: el inventario gobernará dos tramos
posteriores. Antes de reportar "listo", lanza un **panel adversarial** de
verificación read-only que re-derive con código INDEPENDIENTE (no reutilices las
funciones del script de diagnóstico) las afirmaciones de mayor riesgo:

1. **Re-conteo de archivos:** un agente independiente lista la carpeta y cuenta
   archivos por extensión; debe cuadrar con el inventario de Fase 1. Si discrepa,
   hay archivos sin inventariar: investígalo.
2. **Re-verificación de la cubeta C (ajenos 2024):** abre independientemente uno de
   los archivos de `2M/4B/6B/` y confirma por su columna `agno` que es 2024 (no
   2014-2019). Si fuera histórico mal etiquetado, la clasificación está mal.
3. **Re-verificación del régimen ancho:** toma un archivo de 2014 y uno de 2019,
   ábrelos independientemente, y confirma que las columnas de indicador son
   `ind_am/cc/pf/hv` (ancho) y NO `ind`+`prom` (largo). Confirma que NO hay hoja de
   dimensión ni de niveles.
4. **Re-verificación de NA-no-cero:** en una columna de medida con NA, confirma que
   el perfilado reportó los NA como NA (supresión), no como 0. Un check que muestre
   "min=0" donde en realidad hay supresión sería un punto ciego.
5. **md5 del parquet protegido:** un agente independiente recomputa el md5 de
   `idps_largo.parquet` y confirma que es el inicial.

Documenta el veredicto del panel (cada punto PASA/FALLA con evidencia) en el log y
en el reporte final. Si el panel detecta una discrepancia, corrígela ANTES de
reportar y deja constancia de qué se corrigió.

---

## 6. Log de cierre

Al terminar, escribe el log en
`50_documentacion/andamios/logs/20260621_diagnostico_historico_idps_log.md`
siguiendo la plantilla fija del protocolo (`encargo_autonomo_claude_code_v1.md`,
sección 4): resumen, inventario de commits (en este caso: NINGUNO — declararlo
explícitamente), cambios sustantivos (los 4 artefactos creados), auditoría de
diagnóstico con tabla de hallazgos, verificación de invariantes (los 6 🔒 con
PASA/FALLA y evidencia), pendientes/gates para el titular, estado de cifras
críticas (md5 del parquet antes/después), y notas para el revisor (qué mirar con
ojo crítico). El log es un andamio honesto: incluye lo que costó, no solo los
éxitos. NO lo commitees (queda para revisión del titular junto al diagnóstico).

---

## 7. Reporte final al chat

Cuando termines, devuelve al chat:

- md5 de `idps_largo.parquet`: inicial y final (deben ser iguales).
- Conteo de archivos inventariados, desglosado por cubeta (A/B/C/D) y por
  extensión.
- La matriz grado×año de la cubeta A (texto).
- Veredicto del régimen ancho: confirmado / refutado, con la evidencia de los dos
  archivos extremos (2014 y 2019).
- El corte de sub-época (qué año introduce GSE/geografía), observado.
- La convención `agno` (año-archivo → año-dato) observada.
- Resultado del panel adversarial (5 puntos, PASA/FALLA).
- `git status` resumido confirmando que ningún archivo preexistente cambió.
- Lista de gates abiertos para el titular (Fase 3, punto 9).
- Ruta del `.md` de diagnóstico y del log.

Detente ahí. NO propongas ni inicies la organización (tramo 2) ni la integración
(tramo 3): son encargos posteriores que el asistente redactará a partir de este
diagnóstico.
