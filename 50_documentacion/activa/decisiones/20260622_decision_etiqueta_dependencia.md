# Decisión: etiqueta Dependencia del motor IDPS (H-FID-2)

- **Fecha:** 2026-06-22
- **Sesión:** 13
- **Proyecto:** `slep_idps`
- **Estado:** RESUELTA — opción A (mantener dependencia vigente del directorio).
- **Tipo:** decisión de etiqueta/presentación (no afecta ninguna cifra IDPS).

---

## Contexto

El motor pinta, para cada establecimiento, la etiqueta **Dependencia** tomada
del **directorio oficial vigente** (homologado), no de `idps_largo.cod_depe2`
(la dependencia registrada en el dato IDPS de cada año). Esto es comportamiento
por diseño del generador (regla H6: el generador resuelve la dependencia contra
el directorio vigente).

Consecuencia observable: un establecimiento traspasado a SLEP figura como "SLEP"
aunque en la era del dato IDPS (p. ej. 2016) fuera "Municipal". La etiqueta es
históricamente anacrónica para los años previos al traspaso.

**Alcance cuantificado:** 515 RBD donde la etiqueta pintada difiere de
`idps_largo.cod_depe2`:
- **192 RBD** con reclasificación genuina (Municipal / Particular Subvencionado
  → SLEP por traspaso administrativo).
- **323 RBD** con `cod_depe2` NA en el dato, rellenada por el directorio.

**Invariante respetado:** ninguna cifra IDPS cambia. La dependencia es
etiqueta y criterio de filtro, no entra en el cálculo de ningún indicador,
dimensión ni nivel.

---

## Decisión

Se mantiene la **opción A: la etiqueta Dependencia refleja la dependencia
vigente del directorio oficial**. No se reconstruye la dependencia de la era
IDPS ni se agrega marca visual de traspaso.

---

## Alternativas consideradas

- **B — Distinguir era-IDPS vs vigente.** La etiqueta reflejaría la dependencia
  que el EE tenía en el año del dato. Descartada por dos razones: (1) el crudo
  histórico 2014-2016 no siempre trae `cod_depe2`, y los 323 RBD con NA seguirían
  sin fuente era-IDPS, por lo que la reconstrucción sería parcial y heterogénea
  (una serie de dependencia que el dato no soporta entera); (2) exige tocar `35`,
  regenerar y re-verificar fidelidad censal antes de desplegar, costo
  desproporcionado para una etiqueta que no altera cifras.
- **C — Vigente + badge de traspaso.** Mantener vigente pero marcar los RBD
  reclasificados. Descartada: agrega complejidad de presentación y una distinción
  que el público objetivo (directivos hoy) no requiere para leer el dato IDPS.

---

## Justificación

El motor es una herramienta de **datos IDPS**, no de gobernanza institucional.
Para su audiencia (directivos y comunidad del SLEP, lectura presente), la
dependencia vigente es la lectura natural: responde "¿de quién depende este
establecimiento hoy?". La objeción de un validador externo (anacronismo de la
etiqueta en años previos al traspaso) se cierra en una oración, sin reconstruir
una serie de dependencia que el dato no soporta de forma homogénea.

---

## Respuesta ante validación externa (frase canónica)

> El motor muestra la dependencia vigente del establecimiento según el directorio
> oficial homologado. Ninguna cifra IDPS cambia: la dependencia es etiqueta y
> criterio de filtro, no insumo de cálculo.

---

## Implicancias

- **Sin cambios de código.** El generador `35` queda como está; el build
  certificado (md5 `0b7b0b08…`) no se regenera por esta decisión.
- **El parquet no se toca** (🔒, md5 `4c764d8c…`).
- H-FID-2 pasa de "pendiente-titular" a **cerrada**.
