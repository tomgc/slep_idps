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

<!-- portabilidad-cross-os: bloque generado, no editar a mano -->

## Portabilidad cross-OS

Este proyecto se clona, configura y ejecuta igual en macOS y en Windows. El contrato completo está en `herramientas_dev/gobernanza/portabilidad_os/protocolo_portabilidad_cross_os.md`.

### Configuración de una máquina nueva

1. Instalar Git, R y Positron.
2. Clonar el repositorio **fuera de OneDrive** (por ejemplo `~/Projects/slep_idps`).
3. Copiar `.Renviron.example` a `~/.Renviron` y declarar la raíz de datos. Basta **una línea**:

   ```text
   WORKSPACE_DATA_ROOT=<carpeta de proyectos en el OneDrive institucional>
   ```

   El proyecto se resuelve como `<WORKSPACE_DATA_ROOT>/slep_idps`. Si necesita otra ubicación, declarar `SLEP_IDPS_DATA_ROOT`, que gana sobre la global. Reiniciar R después de editar.
4. Verificar que la raíz de datos esté sincronizada y accesible.
5. Restaurar el entorno de paquetes:

   ```r
   renv::restore()
   ```

   `renv.lock` es la única fuente de verdad de paquetes y versiones. No instalar con `install.packages()` a mano.

### Validación del entorno

Antes de ejecutar nada, con la sesión de R abierta en la raíz del repo:

```r
source(here::here("10_utils", "10_validar_portabilidad.R"))
validar_portabilidad()
```

Debe quedar sin fallas críticas. Comprueba el ancla de `here`, la locale UTF-8, `renv.lock`, que `.Renviron` no esté versionado, que `.Renviron.example` exista, y que la raíz de datos resuelva y sea escribible. Para comprobar que el propio verificador detecta violaciones: `validar_portabilidad_autotest()`.

### Ejecutar el proyecto

```r
source(here::here("00_run_all.R"))
```

### Matriz de dependencias de sistema

Lo que `renv` no resuelve se instala en la máquina antes de ejecutar el pipeline.

| Dependencia | macOS | Windows | Necesaria |
|---|---|---|---|
| Git | sí | sí | sí |
| R (4.2 o superior) | sí | sí | sí |
| Positron | sí | sí | recomendado |
| OneDrive institucional | sí | sí | sí (raíz de datos) |

Si el proyecto necesita binarios externos (ODBC, Java, Ghostscript, LibreOffice, Quarto, Typst), declararlos en esta tabla con su versión: el protocolo prohíbe depender de que un comando esté "casualmente" en el `PATH`.

