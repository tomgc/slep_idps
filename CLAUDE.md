# CLAUDE.md — slep_idps

Contrato de trabajo para Claude Code en este proyecto.

## Protocolo

El protocolo completo de sesiones (apertura, cierre, protocolos bajo demanda) y
la arquitectura del proyecto viven en la knowledge base del Project y en
`50_documentacion/activa/`:

- `POLITICA_PROYECTO.md` — estructura, gobernanza de datos, principios tecnicos.
- `SETTINGS_Y_PROMPTS_OPERACIONALES.md` — protocolos de sesion y de operacion.

Leer ambos al inicio de cada sesion. No pedir que se adjunten.

## Reglas no negociables de este proyecto

- **R es el unico lenguaje de analisis.** Nunca Python. Positron, no RStudio.
- **R moderno:** pipe nativo `|>`, `dplyr >= 1.1` con `.by=` (evitar pares
  `group_by()/ungroup()`), `here::here()` para todas las rutas.
- **Llaves siempre `character`** (RBD, codigos comunales): un join con tipos
  mezclados falla en silencio.
- **GSE inviolable:** la segmentacion por grupo socioeconomico aparece en todo
  output, jamas colapsada.
- **No mezclar indicadores ni grados** en una cifra agregada.
- **Sin agregacion territorial** (decision 2026-06-12, vinculante): ninguna
  fuente IDPS publica respondentes, asi que no hay ponderador valido. El motor
  muestra el dato al nivel en que la Agencia lo publica (establecimiento); GSE y
  territorio son filtros/etiquetas, jamas cifra agregada. La comparacion usa
  `difgru`/`sigdifgru` (vs mismo GSE) y `dif`/`sigdif` (vs evaluacion anterior),
  que la Agencia ya calcula por fila. Leer, no derivar.
- **`cod_depe2` tiene 4 categorias** (1 Municipal, 2 Part. subvencionado,
  3 Part. pagado, 4 SLEP). Homologar al normalizar. OJO: el directorio oficial
  usa OTRO esquema de 5 categorias (SLEP=5); no confundir.
- **Esquema por anio:** indicador/dimension/subdimension migran de texto
  (`ind`/`dim`/`sdim`, 2022-2024) a id numerico (`id_*`, 2025). Homologar al id
  numerico via el crosswalk de `10_configuracion.R` (CW_*).
- Formato numerico chileno en outputs (coma decimal, punto miles).
- Locale espanol en Excel (`;` separador, `,` decimal).

## Estado

RAMA A (proyecto publico, datos versionados en el repo). Si entrara data por
estudiante, pasa a RAMA B (dos raices) sin excepcion.

## Pipeline

```r
source("00_build.R")    # define run_all(); orquesta 31 -> 32 -> 33 -> 34 -> (35 motor, pendiente)
run_all()               # pipeline completo de cero
run_all(only = 34)      # solo lectura/normalizacion -> 40_salidas/intermedios/idps_largo.parquet
run_all(from = 33)      # desde catalogos (reusa el directorio depurado)
source("00_escanear_proyecto.R")  # snapshot de estructura (al abrir y cerrar sesion)
```

- `31_depurar_directorio_oficial.R` — saca RUT/MRUN; produce el directorio publico.
- `32_censo_insumos.R` — perfilado de las 25 tablas IDPS (cobertura, % NA).
- `33_construir_catalogos.R` — catalogos territoriales (directorio publico) +
  catalogo jerarquico IDPS de 4 niveles (corpus + crosswalk texto<->id).
- `34_leer_normalizar_idps.R` — 3 familias -> homologa esquema por anio -> atributos
  canonicos por RBD (depe2/geo del registro mas reciente; GSE por anio) ->
  `idps_largo.parquet` por establecimiento-grado, SIN agregacion.
- `35_generar_motor_html.R` — motor HTML autocontenido. Embebe SOLO la Region de
  Valparaiso (cod_reg=5) como universo de comparacion (filtro, no agregacion);
  JSON gzip+base64+pako, D3/pako inline, React por CDN con SRI. Salida:
  `40_salidas/motor_idps.html`. `regenerar_motor()` = `run_all(only = 35)`.

## Ultimos cambios

1. **Motor HTML base** (`35_generar_motor_html.R` + `35_motor_template.html`):
   grilla de radares por establecimiento agrupada por GSE (sin agregacion),
   detalle con radar indicador/dimension, distribucion de niveles por subdimension
   EST con texto por ciclo, marca de desvio vs GSE (`difgru`/`sigdifgru`),
   evolucion donde hay serie, supresion explicita. Abre local; render verificado;
   motor<->parquet 1:1. Alcance base: Region de Valparaiso. NO desplegado.
2. **Fix encoding** (`31_depurar`): el crudo es UTF-8, no latin1; catalogos
   territoriales quedan en UTF-8 limpio.
3. **Textos de nivel por ciclo** anexados a `catalogo_idps.parquet` (solo EST).
4. **P6 — pipeline de lectura/normalizacion** (`34_leer_normalizar_idps.R`):
   lee las 3 familias, homologa texto<->id por anio, resuelve la inconsistencia
   de `cod_depe2` entre familias, trae GSE a niveles, emite `idps_largo.parquet`
   (1.485.103 filas). Spot-check contra xlsx crudo en 2022 y 2025: OK.
5. **Catalogos + orquestador**: `33_construir_catalogos.R` (comunas/sleps/
   establecimientos + jerarquia IDPS); `00_build.R` con `run_all()` y carga de
   `10_configuracion.R` (crosswalk CW_*); gobernanza sesion 5 versionada.
