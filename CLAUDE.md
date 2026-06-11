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
- **Agregacion territorial ponderada** (no promedio simple de porcentajes);
  la variable de ponderacion esta por definir (ver decisiones/).
- **`cod_depe2` tiene 4 categorias** (1 Municipal, 2 Part. subvencionado,
  3 Part. pagado, 4 SLEP). Homologar al normalizar.
- Formato numerico chileno en outputs (coma decimal, punto miles).
- Locale espanol en Excel (`;` separador, `,` decimal).

## Estado

RAMA A (proyecto publico, datos versionados en el repo). Si entrara data por
estudiante, pasa a RAMA B (dos raices) sin excepcion.

## Pipeline

```r
source("00_build.R")              # orquestador (stub)
source("00_escanear_proyecto.R")  # snapshot de estructura
```
