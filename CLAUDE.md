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
- **Identidad cromatica de indicador es regla** (titular, s14): todo lo cromatico
  de un indicador (graficos Y stackeds de niveles) vive en su familia de color.
  Los 4 indicadores usan la paleta del folleto de la Agencia (Autoestima
  `#3858A3`, Convivencia `#61BDC6`, Participacion `#4BA560`, Habitos `#AACB58`),
  fuente unica `INDICADOR_COLORS` en `35`. PROHIBIDA la paleta semaforo
  (rojo/amarillo/verde) y los colores ajenos a la familia del indicador.
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
source("00_build.R")    # define run_all(); orquesta 31 -> 32 -> 33 -> 34 -> 35 (motor)
run_all()               # pipeline completo de cero
run_all(only = 34)      # solo lectura/normalizacion -> 40_salidas/intermedios/idps_largo.parquet
run_all(only = 35)      # regenera el motor HTML (= regenerar_motor())
run_all(from = 33)      # desde catalogos (reusa el directorio depurado)
source("00_escanear_proyecto.R")  # snapshot de estructura (al abrir y cerrar sesion)
```

- `31_depurar_directorio_oficial.R` — saca RUT/MRUN; produce el directorio publico.
- `32_censo_insumos.R` — perfilado de las 25 tablas IDPS (cobertura, % NA).
- `33_construir_catalogos.R` — catalogos territoriales (directorio publico) +
  catalogo jerarquico IDPS de 4 niveles (corpus + crosswalk texto<->id).
- `34_leer_normalizar_idps.R` — 3 familias -> homologa esquema por anio -> atributos
  canonicos por RBD (depe2/geo del registro mas reciente; GSE por anio) ->
  `idps_largo.parquet` por establecimiento-grado, SIN agregacion. Lee `prom`
  verbatim (decimales nativos de la Agencia; auditado s14). Serie 2014->2025,
  2.362.447 filas.
- `35_generar_motor_html.R` — motor HTML autocontenido, TODO CHILE (filtro
  territorial en la navegacion, no agregacion). Navegacion region->SLEP/comuna->
  establecimiento; GSE de referencia protagonista (doble ancla difgru/sigdifgru y
  dif/sigdif con alerta); drill-down indicador->dimension->subdimension; serie
  historica 2014->2025 (eje contiguo server-side, recorte por familia s14);
  fuentes gobCL/Museo Sans embebidas (base64). JSON columnar ordenado por rbd (el
  cliente arma indice de rangos; decode ~340ms). Redondeo de presentacion a ENTERO
  (s14). Salida: `40_salidas/motor_idps.html` (= `docs/index.html` para GitHub
  Pages). `regenerar_motor()` = `run_all(only = 35)`. 🔒 todo cambio de `35` exige
  regenerar + re-verificar fidelidad censal parquet->sitio antes de desplegar.

## Ultimos cambios

1. **Paleta del folleto + ajustes de motor + suite + reconciliacion A22**
   (sesion 14). (a) **P-PALETA desplegada**: los 4 indicadores adoptan la identidad
   cromatica del folleto de la Agencia (`INDICADOR_COLORS`, fuente unica runtime);
   JSON byte-identico al certificado salvo los 4 `color`; panel adversarial 3/3;
   en vivo (HEAD `1d41c17`, build md5 `27679407`). (b) **Auditoria de decimales**:
   los decimales de `prom` son NATIVOS de la Agencia (`34` los lee verbatim; el
   unico redondeo es presentacion en `35`); habilito mostrarlos como entero.
   (c) **4 ajustes de presentacion del motor** (encargo autonomo, build LOCAL sin
   push, camino A): decimales->entero, recorte de eje por familia (`primer_anio_
   familia` derivado del dato: indicador 2014 / dimension 2018 / niveles 2023),
   borde por dimension (RECHAZADO en revision visual, se rehace), espaciado de la
   pestana establecimiento. Fidelidad censal mismatch 0 sobre 2,9M celdas; parquet
   intacto. (d) **Suite `suitedoc`** generada (`50_documentacion/suite/`, render por
   verificar). (e) **A22 cerrado**: backlog global reconciliado a 104 cambios en
   `backlog_historico.md`. PENDIENTE VIVO MAYOR: **P-PALETA-v2** (stacked de niveles
   a tonalidades del indicador eliminando semaforos — sentido de rampa por definir;
   + separador de dimension como contenedor a escala; + push consolidado con los
   ajustes de s14). Otros: **P-DOC-RENDER** (correr `inline_suite.R`).
2. **Serie historica 2014->2025 en el motor + 3 fixes + fidelidad censal** (sesion 12).
   El motor `35` muestra la serie historica completa: eje historico CONTIGUO por grado
   server-side (con_dato / pandemia 2020-2021 / no_eval p.ej. 2019; el motivo del vacio
   se resuelve en R, el template solo lo pinta), header dinamico (`cobertura_anios`),
   degradacion a "—" para geo-NA y dependencia-NA de RBD solo-historicos. 3 bugs (solo
   presentacion; `idps_largo` intacto): (a) **H6 dependencia-NA** (NA legitimo, degrada
   a "—", no se inventa); (b) **dedup de establecimientos** (9157->9137); (c) **fantasma
   rbd=NA** (filtrado al serializar, 9137->9136). **P-DISPLAY-FIDELITY**: verificacion
   CENSAL parquet->sitio PASA (0 discrepancias en ~2,9M comparaciones). H-FID-2 (etiqueta
   Dependencia vigente) resuelta en s13 (opcion A). P-INVENTARIOS y P-HIGIENE-CASE
   cerrados en s13 (inventarios gitignorados; "case" era deuda de tildes, 4 glosas
   renombradas).
3. **P5 — carga historica IDPS 2014-2019 completa** (sesion 10). `34` extendido para
   leer dos regimenes (moderno largo 2022-2025 + historico ancho en
   `20_insumos/historico/` 2014-2019), pivotando el ancho a largo y fundiendo en
   `idps_largo.parquet` (2014->2025, 2.362.447 filas). Indicador 2014-2019 + dimension
   2018; sin subdimension/niveles/significancia historica (NA legitimo); hueco pandemia
   2020-2021. Verificado: 0 cifras IDPS modernas alteradas (panel adversarial 4/4).
4. **Auditoria de datos (FASE I) + saneamiento (FASE II)** (sesion 6). Auditoria
   exhaustiva: join RBD->geo 100% correcto, cifras 1:1 con el crudo. Fixes SOLO de
   presentacion: nombres completos de comuna/EE y geo desde el directorio publico;
   tildes en indicador/dimension; Sostenedor->**Dependencia** (4 categorias); radar con
   nombre+puntaje y comparacion de 2 anios; leyenda con definicion (P-meta, accesible).
5. **Producto completo + deploy** (encargo 2): motor a TODO CHILE; navegacion
   territorial; GSE de referencia protagonista; drill-down; tendencia eje fijo 0-100;
   fuentes embebidas. Copiado a `docs/index.html`.
