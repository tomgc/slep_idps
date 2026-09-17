# Datos versionados autorizados — `slep_idps`

> Instrumento del invariante **I8** de la compuerta de repositorio
> (`herramientas_dev/plantillas/95_verificar_cierre.R`, SETTINGS §2.1). I8
> marca toda ruta versionada con extensión de datos y **falla si no existe
> esta lista**: la ausencia de una autorización explícita no es una
> autorización tácita.

## Fundamento

`slep_idps` es un proyecto **100 % público de raíz unificada**, la forma que
`POLITICA_PROYECTO.md` §6.2 autoriza en su último viñetazo: "Proyectos 100 %
públicos usan raíz unificada: `20_insumos/` y `40_salidas/` viven en el repo y
se versionan si el tamaño lo permite". No hay modelo de dos raíces porque no
hay dato personal que separar: `maneja_sensibles: false`.

Qué contienen los datos versionados:

- **`20_insumos/`** — las planillas públicas de resultados IDPS que la Agencia
  de Calidad de la Educación publica por RBD, más los auxiliares territoriales
  y el corpus conceptual. Ningún archivo trae identificación de estudiantes:
  la unidad mínima es el establecimiento, y las propias planillas ya vienen
  con las supresiones de la Agencia aplicadas.
- **`40_salidas/intermedios/`** — los parquet que el pipeline deriva de esas
  planillas. Se versionan porque son la entrada del paso 35 y hacen el build
  reproducible desde un clon limpio, sin exigir la descarga de las planillas.
- **`renv/settings.json`** — configuración de `renv`, no un dato.

## Autorización

```
20_insumos/*                       # planillas públicas IDPS (Agencia de Calidad) y auxiliares
20_insumos/*/*                     # historico/, auxiliares/
20_insumos/*/*/*                   # historico/glosas/, auxiliares/referencias_idps/
40_salidas/intermedios/*           # parquet derivados del pipeline (reproducibilidad del build)
renv/settings.json                 # configuracion de renv, no es dato
```

## Límite

Esta autorización cubre **datos públicos agregados a nivel de
establecimiento**. Cualquier insumo con identificación individual (RUT,
nombre de estudiante, dato de menor) queda fuera de ella y fuera del
repositorio, sin excepción: POLITICA §6.1 no admite matices y esta lista no
puede ampliarse para acomodar uno.
