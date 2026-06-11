# slep_idps

Motor de comparacion interactivo de los **Indicadores de Desarrollo Personal y
Social (IDPS)** de la Agencia de Calidad de la Educacion, para el SLEP Costa
Central (Vina del Mar, Concon, Quintero, Puchuncavi).

Proyecto hermano de `slep_simce_adecuado`. Producto final: HTML autocontenido
(React 18 + D3 v7) publicado en GitHub Pages, que compara territorios y
establecimientos en el tiempo, siempre segmentado por grupo socioeconomico
(GSE).

## Que son los IDPS

Indices en escala 0-100 por establecimiento que miden aspectos no academicos,
medidos junto al Simce. Cuatro indicadores de cuestionario:

1. Autoestima Academica y Motivacion Escolar
2. Clima de Convivencia Escolar
3. Participacion y Formacion Ciudadana
4. Habitos de Vida Saludable

Cada indicador se descompone en dimensiones y subdimensiones. Los datos vienen
pre-agregados por la Agencia a nivel de establecimiento (RBD), no por
estudiante.

## Estructura del proyecto

Sigue la convencion canonica de `POLITICA_PROYECTO.md` (carpetas numeradas por
flujo de ejecucion): `10_utils/`, `20_insumos/`, `30_procesamiento/`,
`40_salidas/`, `50_documentacion/`.

## Como correr el pipeline

```r
source("00_build.R")    # orquestador (stub por ahora)
```

## Datos

**Este repositorio versiona datos publicos** (agregados por establecimiento de
la Agencia de Calidad). No contiene bases por estudiante. Los xlsx fuente se
descargan del portal de la Agencia y se colocan en `20_insumos/`.

> Gobernanza: si en algun punto el proyecto incorporara datos desagregados a
> nivel de alumno, pasa a arquitectura de dos raices (Rama B de la politica)
> sin excepcion.

## Estructura actual

Generada por el escaner:

```r
source("00_escanear_proyecto.R")
```

Ver `50_documentacion/estructura/estructura_actual.md`.
