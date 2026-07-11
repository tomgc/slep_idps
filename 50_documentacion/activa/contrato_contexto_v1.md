# contrato_contexto_v1.md

> **Contrato de contexto, versión 1.** Esquema fijo que TODO proyecto productor
> debe cumplir para exponer indicadores de "contexto" al consumidor
> `slep_minuta_buenas_senales`. Vive en `50_documentacion/activa/` del consumidor
> y se copia IDÉNTICO a `50_documentacion/activa/` de cada productor que lo
> implemente. Ambas copias deben ser byte a byte iguales en todo momento
> (invariante heredado del contrato de indicadores positivos).
>
> **Carril:** este contrato es el carril de CONTEXTO, distinto del carril de
> INDICADORES POSITIVOS (`contrato_indicadores_positivos_v2.md`). Un mismo
> productor puede exponer ambos, en parquets separados. No se mezclan.
>
> **Fuentes primarias de este diseño:** los nombres de columna, dominios y
> coberturas declarados aquí NO son supuestos: se verificaron empíricamente en
> los inventarios de solo lectura
> `50_documentacion/andamios/logs/20260710_esquemas_crudos_simce_idps_log.md` y
> `50_documentacion/andamios/logs/20260711_dominio_significancia_simce_log.md`
> (andamios congelados).

---

## 1. Qué es el contexto y en qué se diferencia de un indicador positivo

Un **indicador positivo** es una afirmación que el productor decidió destacar,
acompañada de su justificación editorial (`justificacion_destacar`), y que pasa
por un gate formal de criterio. Responde: "esto merece ser celebrado".

Un **indicador de contexto** es una señal comparativa que sitúa al
establecimiento respecto de una referencia (su grupo socioeconómico, o su propio
desempeño anterior). No trae justificación editorial. Responde: "respecto de X,
el establecimiento está por sobre / mejoró".

**Regla de exposición (no negociable):** el contrato de contexto expone
**únicamente las señales donde el establecimiento mejora**. Las señales de
desempeño inferior o de caída NO se exponen. El contrato se llama "de contexto"
por su naturaleza comparativa, no por su neutralidad: es un contrato de buenas
señales, y el filtrado ocurre **en el productor**, nunca en el consumidor.

---

## 2. Invariantes (🔒)

- 🔒 **El productor filtra; el consumidor muestra.** La lógica de qué cuenta como
  "mejora" vive en el productor. El consumidor NUNCA la implementa, NUNCA
  recalcula significancia, y NUNCA decide qué exponer. Recibe un parquet ya
  filtrado.
- 🔒 **Las banderas de significancia se leen VERBATIM de la Agencia de Calidad.**
  Jamás se recalculan, se reestiman ni se sustituyen por un criterio propio. Si
  la Agencia no provee la bandera para un año o un nivel de agregación, esa fila
  simplemente no existe en el contrato (no se rellena con un criterio inventado).
- 🔒 **`rbd` es SIEMPRE `character`.** Preserva los ceros a la izquierda. Un `rbd`
  numérico rompe los joins en silencio.
- 🔒 **Solo se exponen filas donde alguna de las dos señales de mejora es `TRUE`.**
  Una fila sin ninguna mejora no pertenece a este contrato.
- 🔒 **La segmentación por grupo socioeconómico no se promedia ni se arrastra.**
  El `cod_grupo` es dinámico: pertenece a la llave `(rbd, anio, segmento)`, no al
  establecimiento de forma permanente.

---

## 3. Esquema (15 columnas, orden fijo)

| # | Columna | Tipo | Nulos | Descripción |
|---|---|---|---|---|
| 1 | `rbd` | `character` | No | Rol Base de Datos del establecimiento. Ceros a la izquierda preservados. |
| 2 | `anio` | `integer` | No | Año de la medición a la que corresponde la señal. |
| 3 | `eje` | `character` | No | Qué se mide. Identificador estable dentro del proyecto productor. Ver §4. |
| 4 | `eje_etiqueta` | `character` | No | Nombre legible del eje, para render directo. Ver §4. |
| 5 | `segmento` | `character` | No | Sub-población evaluada dentro del establecimiento (grado, nivel). Ver §4. |
| 6 | `escala` | `character` | No | Unidad de `valor` y `desvio_gse`. Ver §5. |
| 7 | `valor` | `double` | Sí | Valor observado del establecimiento en ese eje/segmento/año. |
| 8 | `desvio_gse` | `double` | Sí | Diferencia entre `valor` y la referencia del mismo grupo socioeconómico. Positivo = por sobre. Puede ser `NA` por supresión aun cuando la bandera exista (§6). |
| 9 | `mejora_sobre_gse` | `logical` | No | `TRUE` si el establecimiento está significativamente por sobre su grupo socioeconómico. Ver §6. |
| 10 | `mejora_ano_ano` | `logical` | No | `TRUE` si el establecimiento mejoró significativamente respecto de su evaluación anterior. Ver §6. |
| 11 | `cod_grupo` | `character` | Sí | Código del grupo socioeconómico del establecimiento en ese año/segmento ("1".."5"). |
| 12 | `proyecto_origen` | `character` | No | Slug del proyecto productor. Ej.: `"slep_idps"`, `"slep_simce_adecuado"`. |
| 13 | `periodo` | `character` | No | Período de la corrida que generó el parquet, formato `"AAAA-MM"`. |
| 14 | `fecha_calculo` | `date` | No | Fecha de generación del parquet. |
| 15 | `version_contrato` | `character` | No | Literal `"contexto_v1"`. Embebido en el dato, no solo en el nombre del archivo. |

**Llave natural:** `(rbd, anio, eje, segmento)`. Debe ser única. El productor
valida la unicidad antes de escribir.

---

## 4. Grano: `eje`, `eje_etiqueta` y `segmento`

El contrato es transversal a productores con granos nativos distintos. Las tres
columnas de grano generalizan esas llaves:

| Productor | `eje` | `eje_etiqueta` | `segmento` |
|---|---|---|---|
| `slep_idps` | `id_indicador` (como character) | Nombre del indicador (ej. "Autoestima académica y motivación escolar") | `grado` |
| `slep_simce_adecuado` | `prueba` (`"lect"` / `"mate"`) | `"Lectura"` / `"Matemática"` | `nivel` (`"4b"` / `"2m"`) |

**Reglas:**
- `eje` es el identificador estable, apto para joins y filtros. Nunca cambia entre
  corridas.
- `eje_etiqueta` es texto para el lector. El productor lo provee porque es él
  quien conoce la glosa oficial; el consumidor no debe inventarla ni mantener un
  diccionario paralelo.
- `segmento` distingue sub-poblaciones dentro del mismo establecimiento. Es parte
  de la llave: un establecimiento puede mejorar en 4° básico y no en 2° medio, y
  ambas cosas son verdaderas simultáneamente.
- Un productor nuevo que no encaje en esta generalización NO fuerza el encaje:
  se discute la extensión del contrato (v2), no se abusa de las columnas
  existentes.

---

## 5. `escala`: qué unidad tiene `valor`

`valor` y `desvio_gse` NO son comparables entre productores. La columna `escala`
declara la unidad para que el consumidor nunca los sume, promedie ni compare
entre fuentes.

| Valor de `escala` | Unidad | Productor |
|---|---|---|
| `"idps_prom"` | Puntaje del indicador de desarrollo personal y social (0-100) | `slep_idps` |
| `"simce_puntaje"` | Puntaje promedio de la prueba | `slep_simce_adecuado` |

**Regla:** el consumidor puede mostrar `valor` junto a su `escala`, pero NUNCA
agrega, promedia ni compara valores de escalas distintas. Cualquier agregación
entre escalas es un error de interpretación, no una decisión de diseño.

**Advertencia deliberada sobre SIMCE:** la escala de SIMCE en este contrato es
**puntaje promedio**, NO el "% en estándar adecuado" que es el eje habitual del
proyecto `slep_simce_adecuado`. La Agencia provee banderas de significancia
únicamente sobre el puntaje; no existe ninguna señal de significancia sobre el %
adecuado, en ningún año. Esta es una decisión consciente del titular
(sesión 13): se prefiere una señal con respaldo oficial en una escala menos
habitual, antes que fabricar un criterio de significancia propio sobre la escala
habitual. **Todo texto que el consumidor genere a partir de una fila SIMCE debe
decir "puntaje", nunca "% adecuado".**

---

## 6. Definición de las señales de mejora

Ambas señales derivan de banderas tri-estado que la Agencia de Calidad publica
junto a la magnitud de la diferencia. El dominio es `{-1, 0, +1, NA}` en ambos
productores, con semántica idéntica, verificada empíricamente (cruce
`sign(diferencia) × bandera` con anti-diagonal exactamente nula en los dos
productores; ver los andamios citados en el encabezado):

| Valor de la bandera | Significado |
|---|---|
| `+1` | Significativamente por sobre la referencia / mejora significativa |
| `0` | Sin diferencia significativa |
| `-1` | Significativamente por debajo / caída significativa |
| `NA` | Supresión, o sin comparación disponible |

**Mapeo a los booleanos del contrato:**

- `mejora_sobre_gse := (bandera_gse == 1)`, siendo `bandera_gse` la columna
  `sigdifgru` (IDPS) o `siggru_<prueba><nivel>_rbd` (SIMCE).
- `mejora_ano_ano := (bandera_ano == 1)`, siendo `bandera_ano` la columna
  `sigdif` (IDPS) o `sigdif_<prueba><nivel>_rbd` (SIMCE).

Los estados `0`, `-1` y `NA` mapean todos a `FALSE`. Los booleanos **nunca son
`NA`**: la ausencia de señal es `FALSE`, no desconocimiento. Una fila donde ambos
booleanos son `FALSE` no se expone (🔒 §2).

**Bandera significativa con magnitud suprimida.** Existen filas donde la bandera
es `+1` pero la magnitud de la diferencia llega como `NA` (supresión de la
Agencia; ~0,2% de las filas en SIMCE). Esas filas **SÍ se exponen**, con
`desvio_gse = NA`. La bandera es el dato oficial de significancia; el `NA` de la
magnitud es confidencialidad, no ausencia de señal. Suprimir la fila descartaría
una mejora real por un motivo ajeno a la mejora.

---

## 7. Normalización obligatoria en el productor SIMCE (🔒)

Las banderas de significancia de los xlsx crudos de SIMCE llegan en **dos
representaciones distintas según el año**:

- **Literal de texto** en los años antiguos:
  `{"Negativa y significativa", "No significativa", "Positiva y significativa", NA}`
- **Código numérico** en los años recientes: `{-1, 0, 1, NA}`

Los años de corte son **asimétricos por nivel**: `2m` migra a numérico en 2018;
`4b` migra en 2017.

🔒 **El productor DEBE normalizar ambas representaciones antes de derivar el
booleano.** Un `as.numeric()` aplicado a los años antiguos convierte los literales
en `NA` **en silencio**, borrando toda la señal histórica sin lanzar ningún error.
El mapeo verificado es:

| Literal | Código |
|---|---|
| `"Positiva y significativa"` | `+1` |
| `"No significativa"` | `0` |
| `"Negativa y significativa"` | `-1` |

**Verificación obligatoria:** tras normalizar, el productor comprueba que el
conjunto de valores no mapeados sea vacío. Si aparece cualquier valor fuera de
los seis conocidos (tres literales, tres códigos), **se detiene y reporta**; no
lo descarta como `NA`.

---

## 8. Cobertura real de las señales (declarada, no supuesta)

La cobertura es **asimétrica** y no debe asumirse completa. El productor expone lo
que existe; el consumidor no interpreta una ausencia como un `FALSE` informativo.

| Productor | Señal | Cobertura verificada |
|---|---|---|
| `slep_idps` | `mejora_sobre_gse` | Solo nivel indicador, solo **2024-2025** |
| `slep_idps` | `mejora_ano_ano` | Nivel indicador **2024-2025**; nivel dimensión solo 2025 |
| `slep_simce_adecuado` | `mejora_sobre_gse` | Completa: **2014-2018 y 2022-2025**, ambos niveles, ambas pruebas |
| `slep_simce_adecuado` | `mejora_ano_ano` | Completa: mismo rango |

Notas:
- IDPS no tiene ninguna de las dos señales antes de 2024, pese a tener filas en
  años anteriores. Los `NA` de esos años son legítimos y NO se rellenan.
- SIMCE no tiene archivos 2019-2021 (la evaluación no se aplicó). No es un hueco
  de datos: es un hueco de realidad.
- SIMCE 2025 es **preliminar**. El productor lo expone, pero debe poder
  distinguirlo (ver §9).

---

## 9. Metadatos de frescura y trazabilidad

Las cuatro columnas de metadatos (`proyecto_origen`, `periodo`, `fecha_calculo`,
`version_contrato`) existen para que el consumidor pueda auditar la procedencia de
cada fila sin abrir el repo productor. Son obligatorias y no admiten `NA`.

`version_contrato` va **embebida como columna del dato**, no solo en el nombre del
archivo `.md`. Esto corrige un hueco explícito del contrato de indicadores
positivos, donde la versión vive solo en el nombre y una lectura del parquet
aislado no puede saber contra qué esquema validarse.

**Dato preliminar:** si una fila proviene de una medición preliminar (caso SIMCE
2025), el productor lo declara en `eje_etiqueta` o lo omite del contrato, según lo
que el titular decida por productor. El contrato v1 **no** reserva una columna
booleana para esto; si la necesidad se confirma en más de un productor, se agrega
en v2.

---

## 10. Nombre y ubicación del artefacto

- **Parquet del productor:** `40_salidas/publico/contexto_<slug_corto>.parquet`.
  Ej.: `contexto_idps.parquet`, `contexto_simce.parquet`.
- **Copia en el consumidor:** `20_insumos/`, mismo nombre. La copia es manual
  (tarea del titular), no automatizada.
- **Este contrato:** `50_documentacion/activa/contrato_contexto_v1.md`, copia
  idéntica en el consumidor y en cada productor que lo implemente.

---

## 11. Validación en el consumidor

El consumidor valida el esquema **antes** de usar el parquet, con la misma
severidad que el contrato de positivos: si una columna falta, sobra, o tiene el
tipo equivocado, se detiene con `stop()`. No degrada silenciosamente.

Chequeos mínimos:

1. Las 15 columnas presentes, con los tipos declarados en §3.
2. `rbd` es `character`.
3. `version_contrato` es `"contexto_v1"` en todas las filas.
4. La llave `(rbd, anio, eje, segmento)` es única.
5. Ninguna fila tiene `mejora_sobre_gse` y `mejora_ano_ano` ambas `FALSE`
   (violaría §2: el productor debía filtrarla).
6. Ningún booleano de mejora es `NA`.
7. `escala` pertenece al conjunto declarado en §5.

El consumidor reduce a grano `rbd` **después** de validar, en
`33_armar_minuta.R`, según lo que la minuta necesite mostrar. La reducción es una
decisión de presentación y pertenece al consumidor; el filtrado de qué es una
mejora pertenece al productor. No se confunden.

---

## 12. Historial de versiones

- **v1** (2026-07-11): versión inicial. Cubre `slep_idps` y `slep_simce_adecuado`.
  Nombres de columna, dominios y coberturas verificados empíricamente en los dos
  andamios de inventario citados en el encabezado; ninguno asumido.
