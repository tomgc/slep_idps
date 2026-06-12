# Decisión: naturaleza pública de los insumos IDPS y arquitectura Rama A

- **Fecha:** 2026-06-11
- **Estado:** Vigente
- **Ámbito:** Gobernanza de datos (POLITICA_PROYECTO.md, secciones 6 y 8)

## Contexto

El proyecto `slep_idps` versiona dentro del repositorio Git (público en cuanto a
arquitectura, repo remoto privado) los archivos xlsx de Indicadores de
Desarrollo Personal y Social (IDPS) de la Agencia de Calidad de la Educación,
en `20_insumos/`. La política exige, antes de versionar datos, confirmar
explícitamente que no se trata de bases desagregadas a nivel de estudiante, las
cuales obligarían a una arquitectura de dos raíces (Rama B) y a mantener los
datos fuera del control de Git.

## Decisión

Los 34 archivos de `20_insumos/` se clasifican como **agregados públicos a nivel
de establecimiento (RBD)** y se versionan en el repositorio bajo arquitectura
**Rama A** (raíz unificada, sin data root externo).

## Verificación realizada

Se inspeccionaron las cabeceras de los 34 xlsx con un chequeo automatizado
(`verificar_gobernanza_insumos.R`, chequeo único no versionado) que buscó
columnas delatoras de datos personales: `rut`, `run`, `mrun`, `nombre_alumno`,
`nombre_estudiante`, `id_alumno`, `cod_alumno`.

Resultado:

- **Ninguna** de las 34 tablas contiene columnas sensibles (todas marcaron
  `columnas_sospechosas = —`).
- Las 24 tablas de datos tienen columna `rbd` (una fila por establecimiento ×
  indicador, × dimensión o subdimensión según la tabla). La unidad de
  observación es el establecimiento, no el estudiante.
- Las 10 tablas restantes (`tiene_rbd = FALSE`, 1 columna) son glosas:
  diccionarios de códigos de indicador/dimensión/subdimensión, sin datos.
- El único identificador nominal presente es `nom_rbd` (nombre del
  establecimiento), que es información pública.

Esto es consistente con el material oficial de la Agencia ("se entregan
resultados por establecimiento, no por estudiante"; "la información e identidad
de quienes responden es confidencial").

## Marco normativo

- Condiciones de Uso de Bases de Datos de la Agencia de Calidad: las
  restricciones aplican a bases **desagregadas a nivel de alumno**. Los
  agregados por establecimiento son equivalentes en naturaleza a los datos
  Simce por estándar que el proyecto madre `slep_simce_adecuado` ya publica.
- Misma lógica que la decisión B2 del proyecto madre.

## Alternativas consideradas

- **Rama B (dos raíces, datos fuera de Git).** Descartada: aplica solo a datos
  personales o desagregados a nivel de estudiante, que aquí no existen.
  Introduciría complejidad de configuración (data root externo, variable de
  entorno) sin beneficio de gobernanza, dado que los datos son públicos.

## Consecuencia e invariante

- Los insumos IDPS por RBD se versionan en `20_insumos/`.
- **Invariante:** si en algún punto el proyecto incorporara una base
  desagregada a nivel de estudiante (con RUT, nombre individual o una fila por
  alumno), el proyecto pasa a Rama B **sin excepción**, lo que exige limpiar el
  historial de Git antes de continuar (no basta con borrar el archivo del
  árbol de trabajo).
- El chequeo `verificar_gobernanza_insumos.R` debe re-ejecutarse cada vez que
  se agreguen nuevos archivos a `20_insumos/`, antes de hacer commit.
