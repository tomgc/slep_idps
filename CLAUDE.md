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
- `35_generar_motor_html.R` — motor HTML autocontenido, TODO CHILE (filtro
  territorial en la navegacion, no agregacion). Navegacion region->SLEP/comuna->
  establecimiento; GSE de referencia protagonista (doble ancla difgru/sigdifgru y
  dif/sigdif con alerta); drill-down indicador->dimension->subdimension; tendencia
  eje fijo 0-100; fuentes gobCL/Museo Sans embebidas (base64). JSON columnar
  ordenado por rbd (el cliente arma indice de rangos; decode ~340ms). Salida:
  `40_salidas/motor_idps.html` (= `docs/index.html` para GitHub Pages).
  `regenerar_motor()` = `run_all(only = 35)`.

## Ultimos cambios

1. **Serie historica 2014->2025 en el motor + 3 fixes + fidelidad censal** (sesion 12).
   El motor `35` ya muestra la serie historica completa (antes solo 2022-2025): eje
   historico CONTIGUO por grado decidido server-side (con_dato / pandemia 2020-2021 /
   no_eval p.ej. 2019; el motivo del vacio se resuelve en R, el template solo lo pinta),
   header dinamico (`cobertura_anios`, no el literal "2022-2025"), y degradacion a "—"
   para geo-NA y dependencia-NA de RBD solo-historicos (cerrados). 3 bugs corregidos
   (solo presentacion; `idps_largo` intacto, cifras sin cambio): (a) **H6 dependencia-NA**
   — RBD solo-historicos sin dependencia ni en el directorio ni en 2014-2016: NA legitimo,
   degrada a "—" (no se inventa); aborta solo si un RBD moderno >=2022 la perdiera;
   (b) **dedup de establecimientos** — un RBD con atributos historico/moderno distintos
   generaba tarjetas duplicadas (20 RBD x2); `est_attr` toma una fila por RBD (la mas
   reciente): 9157->9137; (c) **fantasma rbd=NA** — 4 filas crudas 4b/2017 con rbd=NA
   colapsaban en 1 EE "fantasma" alcanzable por el buscador; se filtra al serializar
   (`!is.na(rbd)` tras GRADOS_MOTOR): 9137->9136. **P-DISPLAY-FIDELITY**: verificacion
   CENSAL parquet->sitio **PASA** (0 discrepancias en ~2,9M comparaciones de cifra:
   ind/dim/niv + dif/sigdif/difgru/sigdifgru), por decode triple independiente
   (R / node / 2 subagentes a ciegas) + panel adversarial. Build desplegado
   `docs/index.html` md5 `0b7b0b08`. PENDIENTES VIVOS: **H-FID-2** (etiqueta Dependencia
   del directorio vigente, por diseno H6 — decision titular), **P-DOC**,
   **P-INVENTARIOS** (`inventario_*.parquet` sin clasificar), **P-HIGIENE-CASE**.
2. **P5 — carga historica IDPS 2014-2019 completa** (sesion 10). `34` extendido para
   leer dos regimenes (moderno largo en la raiz 2022-2025 + historico ancho en
   `20_insumos/historico/` 2014-2019), pivotando el ancho a largo y fundiendo en
   `idps_largo.parquet` (ahora 2014->2025, 2.362.447 filas). Indicador 2014-2019 +
   dimension 2018; sin subdimension/niveles/significancia historica (NA legitimo);
   hueco pandemia 2020-2021. 4b2024 traspapelado rescatado a la raiz. Verificado: 0
   cifras IDPS modernas alteradas (panel adversarial 4/4).
3. **Auditoria de datos (FASE I) + saneamiento/mejoras (FASE II)** (sesion 6,
   3er tramo). Auditoria exhaustiva: join RBD->geo 100% correcto vs directorio,
   cifras 1:1 con el crudo (0 discrepancias), Costa Central 60 en 4b 2025. Fixes
   SOLO de presentacion (`run_all(only=35)`, `idps_largo` intacto, cifras sin
   cambio): nombres completos de comuna/EE y geo desde el directorio publico
   (estaban TRUNCADOS en `idps_largo`); tildes en indicador/dimension
   (`INDICADOR_LABELS`+`DIMENSION_LABELS`); Sostenedor->**Dependencia** (rename +
   pestana blindada a 4 categorias); radar con nombre+puntaje por vertice y
   comparacion de 2 anios superpuestos; leyenda con definicion (P-meta, accesible);
   GSE sin enumeracion. PENDIENTE decision titular: 120 EE SLEP-por-traspaso
   marcados Municipal (desfase de vigencia, NO cambia cifras). `docs/` NO
   republicado (queda para el cierre v06 del Encargo 2).
4. **Producto completo + deploy** (encargo 2): motor ampliado a TODO CHILE (8353
   establecimientos, 16 regiones); navegacion territorial region->SLEP/comuna->
   establecimiento; GSE de referencia protagonista (doble ancla + alerta);
   drill-down indicador->dimension->subdimension; tendencia eje fijo 0-100;
   fuentes de marca embebidas. Copiado a `docs/index.html` para GitHub Pages.
   Decode ~340ms, indice de rangos 7ms. Spot-check fuera de Valparaiso 1:1.
5. **Motor HTML base**: grilla de radares por establecimiento agrupada por GSE
   (sin agregacion), detalle, distribucion de niveles, marca de desvio, evolucion.
