# Encargo de cierre — slep_idps · Traspaso v05

El titular decidió cerrar la sesión. Genera `traspaso_cierre_v05.md` siguiendo el
protocolo de cierre (`SETTINGS_Y_PROMPTS_OPERACIONALES.md`, sección 2) y déjalo en
`50_documentacion/traspasos/`. Antes de cerrar, re-corre el escáner y referencialo.
Tienes en tu historial todo el trabajo de esta sesión (Prioridad 1, P6, motor
base, producto nacional, deploy); úsalo para redactar un traspaso exhaustivo.

Esta fue una sesión densa y de alto avance: el proyecto pasó de scaffold sin
pipeline a plataforma nacional pública desplegada y validada. El traspaso debe
capturar todo eso o se pierde.

## Secciones obligatorias (protocolo 2.2)

Incluye TODAS; si una no aplica, dilo con justificación breve. En particular, no
escatimes en:

**Resumen ejecutivo y estado al cierre.** Qué se logró (pipeline completo 31→35,
motor todo-Chile desplegado en `https://tomgc.github.io/slep_idps/`), qué funciona
(con su última verificación: run_all de cero OK, spot-checks 1:1 dentro y fuera de
Valparaíso, sitio sirviendo HTTP 200), y el delta respecto de v04.

**Registro detallado de cambios** (un bloque por cambio conceptual): Prioridad 1
(orquestador run_all, gobernanza sesión 5, archivado de residuo), P6 (lectura/
normalización/homologación/join → idps_largo.parquet), fix de encoding, textos de
nivel, motor base, ampliación nacional + navegación territorial, GSE como eje
interpretativo, jerarquía con drill-down, deploy a Pages.

**Backlog acumulativo** (protocolo 2.2.5): copia íntegro el backlog de v04 y agrega
al final los cambios nuevos de esta sesión con numeración correlativa global y
permanente (no renumeres lo anterior). Actualiza la tabla por categoría, el resumen
por sesión y el delta. Recuerda reincorporar o cerrar explícitamente P10-ter (quedó
sin nota de cierre desde v04).

**Bugs de la sesión** (con causa raíz + regla aprendida), al menos:
- `sigdifgru` interpretado como {significativo si ===1} cuando el esquema real es
  {−1,0,+1} = significativamente bajo / no significativo / significativamente alto
  (verificado contra 39.285 casos). Regla: leer la semántica de significancia de la
  glosa/datos, no asumir codificación binaria.
- Mojibake de labels de grado (°/á) por el locale C de la sesión R al serializar.
- Doble codificación de catálogos territoriales: el crudo del directorio era UTF-8,
  no latin1; `31_depurar` lo leía como latin1 y reescribía mal. Regla: diagnosticar
  el encoding real por bytes antes de asumir.
- Inconsistencia de `cod_depe2` entre familias del propio dato IDPS (mismo RBD
  Municipal en una familia, SLEP en otra).

**Decisiones de diseño (D-series), ya ratificadas por el titular esta sesión** —
documéntalas formalmente con alternativas y justificación, porque hoy viven solo en
commits y reportes:
- **No agregación territorial** (ya en decisión 2026-06-12; reitérala como marco).
- **cod_depe2 canónico por RBD** (familia indicador, año más reciente, esquema
  4-categorías IDPS con 4=SLEP), por la inconsistencia entre familias. Ratificada.
- **"Comparar" = grilla por GSE + difgru/sigdifgru como marca de desvío**, nunca
  línea de puntaje absoluto del GSE (decisión 2026-06-12 §5). El GSE de referencia
  es el eje interpretativo central del producto (la escala 0-100 es relativa; el
  desvío vs GSE y vs año anterior son las anclas de lectura y alerta).
- **Alcance nacional completo embebido** (todo Chile, 8.353 establecimientos, ~6,5
  MB), no carga diferida por región. Ratificada por el titular ("todo Chile
  obligatorio"; abrir a otros SLEP y explorar comunas).
- **Navegación territorial región→SLEP→comuna→establecimiento** como navegación de
  primer nivel; el territorio acota la lista, nunca agrega.
- **Tendencias con eje fijo 0-100**, nunca autoescalado (escala común y comparable).
- **Serialización columnar ordenada por rbd + índice de rangos en cliente** para el
  rendimiento (decode ~350 ms con 1,5M filas), evitando materializar objetos; por eso
  no se hizo build de Babel ni recorte de D3.
- **Fuentes gobCL/Museo Sans embebidas en base64** (self-contained real).
- **Gobernanza:** datos públicos de la Agencia, publicación nacional nominal
  confirmada por el titular; repo público; Pages activo.

**Constantes y parámetros vigentes:** crosswalk CW_INDICADOR/CW_DIMENSION/
CW_SUBDIMENSION, GRADO_LABELS/GRADO_CICLO_TEXTO, NOMBRES_REGION, ANIO_DATOS_VIGENTE,
alcance nacional, esquema de salida de idps_largo.parquet.

**Arquitectura de archivos:** referencia el escáner al cierre; resume la estructura
nueva (33/34/35 + plantilla + libs inline + docs/).

**Pendientes y ruta sugerida** (campos completos por pendiente, son el insumo de la
próxima apertura): todo lo diferido para iteración post-deploy — a11y exhaustiva,
responsive fino móvil, virtualización de grilla para comunas grandes,
microinteracciones, sección metodológica P-meta expandida desde el corpus,
verificación visual fina de la vista 8b (texto "no disponible"), opcional build de
Babel y vista comparativa lado-a-lado. Más P10-bis (versionar scripts del corpus) y
P10-ter. Incluye la auditoría de cierre (política 5.6, preguntas "Cierre"); toda
respuesta "no" pasa a pendiente.

**Instrucciones específicas para la próxima sesión** (formato ⚠️/✅/🔒): los
invariantes que deben sobrevivir (cero agregación; leer no derivar; GSE eje central;
tendencias 0-100; supresión NA; niveles solo EST; 8b sin texto; no mezclar
indicadores/dimensiones/grados/años; andamios congelados; terminología; el deploy
vive en docs/index.html y se republica desde ahí).

**Fragmentos de código de referencia:** los patrones "forma correcta" del proyecto
(homologación texto↔id, join de atributos, mecanismo de inyección gzip+base64+pako,
índice de rangos en cliente).

**Reapertura** (protocolo 2.2.14, con valores reales, sin placeholders): nombre del
chat sugerido, mensaje de apertura pre-armado declarando CONTINUATION y que el
protocolo vive en la knowledge base, y los tres bloques de documentos (protocolo en
KB no se adjunta; opcionales según foco; específicos a adjuntar: traspaso v05,
escáner, y los archivos críticos para la próxima sesión, p. ej. el motor/plantilla si
se itera la UI). Replica esta sección textualmente al final de tu mensaje de cierre.

## Cierre operativo

- Re-corre `00_escanear_proyecto.R` y verifica retención de snapshots.
- Commit del traspaso + escáner (y push, consistente con que el repo ya está en
  origin/main). Muestra `git status` antes del commit.
- NO inicies otra tarea tras el traspaso; el cierre lo confirma el titular.

Al terminar, entrega un resumen breve de cierre: qué quedó en el traspaso, el commit/
push, y la sección de reapertura replicada para que el titular abra la próxima sesión
sin fricción.
