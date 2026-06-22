# traspaso_cierre_v15.md

> Documento de cierre de sesión. Único puente entre sesiones: todo lo que no quede
> aquí se pierde. Generado al cierre de la sesión 15 de `slep_idps`.

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, todo
  Chile; Rama A pública, datos versionados en el repo).
- **Versión de traspaso:** v15.
- **Fecha:** 2026-06-22.
- **Sesión:** 15. **Foco:** dos frentes cerrados — **P-PALETA-v2** (rampa de niveles
  monocromática por indicador + separador de dimensión como contenedor a escala,
  desplegado vía encargo autónomo a Claude Code) y **P-DOC-RENDER** (render y
  verificación de la suite `suitedoc` con 4 HTML autocontenidos + versionado del tema;
  2 bugs de `inline_suite.R` encontrados y corregidos). **Resultado:** motor con la
  rampa de niveles desplegado y certificado (semáforo eliminado, H-s14-SEMAFORO
  cerrado); suite renderiza con estilo completo; tema versionado para reproducibilidad
  desde el repo; backlog a 106 cambios. Quedan abiertos P-SUITEDOC-INLINE (integrar el
  inlining al paquete) y P-ORG (reorganizar el directorio).
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`). Ejecución dual-Claude: este Claude como analista/redactor; Claude Code como
  ejecutor (un encargo autónomo P-PALETA-v2 + comandos puntuales de P-DOC-RENDER).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html`
  (rampa `nivelRamp` + `_txtOn` + threading IndPanel→DistBar + leyenda neutra +
  separador `.hist-dim`); `docs/index.html` y `40_salidas/motor_idps.html` (regenerados
  y desplegados); `50_documentacion/suite/inline_suite.R` (2 bugfixes); tema de la suite
  versionado (`suite_estilos.css` + `fonts/` + `assets/` ahora trackeados);
  `.gitignore` (quitadas 3 reglas del tema, conservada `suite/*.html`); snapshots del
  escáner. **El parquet NO se tocó** (md5 `4c764d8c…` intacto, verificado inicio==fin en
  la regeneración del motor).

---

## 2. Resumen ejecutivo

La sesión 15 cerró dos frentes. **P-PALETA-v2** (foco heredado de v14) corrigió
H-s14-SEMAFORO: los stacked de niveles Bajo/Medio/Alto de las subdimensiones
abandonaron la paleta semáforo (rojo/amarillo/verde) y pasaron a una rampa
monocromática derivada del color del indicador padre (Bajo claro → Alto oscuro, una
rampa por indicador), y el separador de dimensión pasó del border-left rechazado en s14
a un contenedor a escala. El encargo autónomo se ejecutó hasta la verificación
(fidelidad censal mismatch 0 sobre 2.911.824 celdas, panel adversarial 3/3, parquet
intacto, 3 superficies confirmadas por estilos computados), se detuvo en un gate
pre-push del titular, y tras la aprobación se desplegó (push de 21 commits, `live==local`
`4958558d…`). **P-DOC-RENDER** verificó la suite `suitedoc` de s14: al correr
`inline_suite.R` aparecieron 2 bugs (extracción del href con `.*` multilínea; base64 con
saltos de línea MIME que invalidaban el CSS), ambos corregidos; los 4 HTML quedaron
autocontenidos y renderizan con estilo. El tema (CSS + fuentes + logos) se versionó para
que la suite sea reproducible desde el repo sin depender del paquete `suitedoc`
instalado. La suite queda **interna** (no se publica en Pages, decisión del titular).

---

## 3. Estado al cierre

### Qué funciona
- **Motor desplegado con la rampa de niveles** (P-PALETA-v2 en vivo):
  `https://tomgc.github.io/slep_idps/` sirve el build con la rampa monocromática por
  indicador y el separador de dimensión como contenedor (build md5
  `4958558d0e0ea21c05eb442f561bfaca`, HEAD `ed240a6`). Última ejecución exitosa:
  regeneración + deploy de P-PALETA-v2, `live==local` confirmado por md5.
- **Dato (parquet `idps_largo.parquet`, md5 `4c764d8c…`):** intacto. Leído (solo
  lectura) por la regeneración; nunca escrito.
- **Suite `suitedoc` renderizando con estilo:** los 4 `*_standalone.html`
  (`arquitectura_*`, `documentacion_*`) se generan autocontenidos vía `inline_suite.R`
  (CSS + 6 fuentes en base64; 0 referencias externas; 189 reglas CSS parseadas; 0
  errores de consola). Tema versionado en `50_documentacion/suite/{fonts,assets}` +
  `suite_estilos.css`.
- **`inline_suite.R` corregido y versionado** (`1485abf`): los 2 bugs que impedían el
  render con estilo están resueltos.

### Qué no funciona / queda a medias
- Nada roto. Dos pendientes nuevos abiertos (no son fallas, son trabajo no iniciado):
  P-SUITEDOC-INLINE y P-ORG (ver §11).
- **Afinación de tono de la suite:** 2 marcas `# REVISAR (voz)` en `documentar.R`
  (L311, L370) + uso de "colegio" como genérico en `doc_que` (prosa técnica, infringe
  regla 4.6.3.6) quedan como afinación opcional del titular; no bloquean (suite interna).
- **`# REVISAR` estético de la rampa (A14-2):** la verificación técnica está cerrada,
  pero el OK estético del titular sobre las 3 superficies queda pendiente. Hallazgo
  honesto: una rampa monocromática de 3 tonos no alcanza 3:1 de contraste entre
  segmentos adyacentes (limitación inherente); la accesibilidad la garantizan los
  canales textuales (🔒). Si se quiere más separación visual, la vía es un separador
  fino (hairline) entre segmentos — decisión nueva, no implementada.

### Delta respecto a v14
- **P-PALETA-v2:** de ABIERTO (titular, v14) a **DESPLEGADO y CERRADO**.
- **P-DOC-RENDER:** de pendiente (render por verificar, v14) a **CERRADO** (suite
  renderiza con estilo; tema versionado).
- **2 bugs de `inline_suite.R`:** NUEVOS y RESUELTOS.
- **P-SUITEDOC-INLINE:** ABIERTO (nuevo, titular — integrar el inlining al paquete).
- **P-ORG:** ABIERTO (nuevo, titular — reorganizar el directorio).
- **Divergencia local/remoto de v14:** CERRADA (los 15 commits locales de v14 se
  pushearon con el deploy de P-PALETA-v2; el repo está sincronizado).

---

## 4. Registro detallado de cambios (sesión 15)

> Numeración global continúa en `backlog_historico.md`. Las 2 entradas de s15 son los
> cambios **105–106**.

**C1 (#105) — P-PALETA-v2: rampa de niveles por indicador + separador de dimensión**
[visualización/diseño — rediseño UI; desplegado]. Encargo autónomo a Claude Code
(`encargo_paleta_v2_s15.md`). Una solicitud del titular (rediseño cromático), dos
piezas:
- **Rampa de niveles.** `DistBar` (distribución Bajo/Medio/Alto de subdimensión) deja el
  semáforo `--bajo/--medio/--alto` y usa una rampa monocromática derivada del color del
  indicador padre vía `nivelRamp(mother)` (junto a `dimColor`): `bajo=_lighten(m,0.45)`,
  `medio=_lighten(m,0.12)`, `alto=_darken(m,0.22)` (constantes `RAMP_BAJO/MEDIO/ALTO`;
  reutiliza `_lighten/_darken`, misma familia que `dimColor`, sin colores nuevos). La
  rampa se hila `IndPanel`(`const ramp=nivelRamp(ind.color)`)→`DimBlock`→`SubDist`→
  `DistBar({v,ramp})`. Se añadió `_txtOn(c)` (color de texto adaptativo del % por
  luminancia, umbral 0.55) para legibilidad sobre el Alto oscuro. Leyenda global
  (multi-indicador) en rampa neutra de luminosidad + etiquetas textuales
  (D-s15-LEYENDA-NEUTRA). `--bajo/--medio/--alto` quedan como fallback documentado.
- **Separador de dimensión.** `.hist-dim` deja el `border-left:3px` (fase 3 de s14,
  rechazada) y pasa a contenedor a escala: `border 1px var(--cream-200)` +
  `border-top 2px var(--ic)` + `border-radius var(--radius-2)` + `padding 10px 11px` +
  `background var(--paper)`. Análogo a `.hist-ind` subordinado; `var(--ic)` heredado.

**Verificación:** fidelidad censal parquet→sitio **mismatch 0** sobre 2.911.824 celdas
(prom ind 354.007 + dim 531.479 + niveles 662.514 == `round(parquet,0)`); panel
adversarial 3/3 (A cifras 0 mismatch robusto a banker's vs half-up; B StackedBar
byte-idéntico; C rampa por indicador + canal textual); universo 9.136; parquet md5
inicio==fin. 3 superficies confirmadas visualmente (rampa no-semáforo, separador marco,
StackedBar intacto), 0 errores de consola. **Desplegado** tras gate pre-push del titular
(`cf719aa..ed240a6`, 21 commits, `live==local 4958558d…`). Commits s15: `19c30a7`,
`9d9a172` (churn), `b079e04` (rampa), `4a0f172` (separador), `4738496` (build),
`ed240a6` (log). Log: `andamios/logs/20260622_paleta_v2_s15_log.md`.

**C2 (#106) — P-DOC-RENDER: render y verificación de la suite `suitedoc`**
[documentación de proyecto; cerrado]. Verificación de la suite generada en s14 (C3 de
v14). Al correr `inline_suite.R` (que vuelve autocontenidos los 4 HTML embebiendo CSS +
fuentes + logos en base64) aparecieron 2 bugs (ver §6), ambos corregidos. Resultado: los
4 `*_standalone.html` (~430–441 KB vs 8–19 KB los base) con 0 referencias externas, 6
fuentes en base64 de una línea, 189 reglas CSS parseadas, render con estilo, 0 errores de
consola. **Tema versionado** (`f41efdf`): se quitaron del `.gitignore` las 3 reglas del
tema (`suite/suite_estilos.css`, `suite/fonts/`, `suite/assets/`) y se versionaron
`suite_estilos.css` + 6 `.otf` + 3 `.png` en `50_documentacion/suite/{fonts,assets}`
(rutas verificadas: bajo `suite/`, no en la raíz), para que la suite sea reproducible
desde el repo sin depender de `suitedoc::copiar_tema`. Los `*_standalone.html` siguen
gitignorados (`suite/*.html`) y son reproducibles. **Decisión del titular:** suite
INTERNA (no Pages). Commits: `1485abf` (fix inline_suite), `f41efdf` (tema), `70d73a7`
(escáner de cierre).

---

## 5. Backlog acumulativo

> El backlog vive consolidado en `backlog_historico.md` (numeración global permanente).
> Esta sección referencia el archivo, que es la única fuente de verdad del conteo (A22).

- **Total a v15:** 106 cambios (1–104 a v14; 105–106 de s15).
- **Delta v15:** +2 entradas (105 P-PALETA-v2 rampa+separador; 106 P-DOC-RENDER).
- **Taxonomía:** sin categorías nuevas. "Documentación de proyecto (suite/política)"
  sube de 1 a 2 entradas (≈2%): sale del riesgo de absorción (<2%), se mantiene.
- **Nota:** los 2 bugs de `inline_suite.R` NO suman al conteo de cambios (son bugfixes
  reportados en el flujo de #106, registrados en §6 según la nota metodológica).

---

## 6. Bugs y hallazgos de la sesión

**Bug s15-1 — extracción del href del CSS en `inline_suite.R`** [resuelto, `1485abf`].
- **Síntoma:** `inline_suite.R` abortaba con "CSS no encontrado: <documento HTML entero>";
  el path capturado del `<link rel=stylesheet>` incluía casi todo el documento.
- **Causa raíz:** `.inline_html` extraía el href con
  `sub(".*"+link_pat+".*","\\1",html,perl=TRUE)`. En PCRE el `.` no cruza saltos de línea
  sin el flag `(?s)`, y el HTML está unido por `\n`, así que el `sub` reemplaza solo la
  línea del `<link>` y deja el resto del documento dentro del grupo capturado.
- **Solución:** extraer con `regexec`/`regmatches` (el mismo idiom que ya usaba la rama de
  `<img>` en el propio script).
- **Regla aprendida (A15-1):** PCRE `.*` no cruza `\n`. Para extraer un grupo de un texto
  multilínea, usar `regexec`/`regmatches` o el flag `(?s)`, nunca `sub(".*pat.*","\\1")`.
- **Principio:** B.1 (sin supuestos: no asumir que el HTML es de una línea).

**Bug s15-2 — base64 con saltos de línea MIME invalida el CSS** [resuelto, `1485abf`].
- **Síntoma:** tras el fix anterior, los `_standalone.html` se generaban pero se veían
  SIN estilo; el navegador parseaba 1 de 189 reglas CSS y se detenía.
- **Causa raíz:** `jsonlite::base64_enc` envuelve el base64 en líneas de 76 caracteres
  (estilo MIME); un salto de línea dentro de `url('data:font/otf;base64,…')` invalida la
  regla CSS, y el parser aborta el resto del bloque `<style>`.
- **Solución:** `gsub("[\r\n]","",b64)` sobre el base64 en `.data_uri`, antes de armar el
  `data:` URI.
- **Regla aprendida (A15-2):** `jsonlite::base64_enc` produce base64 multilínea (MIME). Al
  embeber en `url()`, en un atributo HTML o en cualquier contexto sensible a saltos,
  quitar los `\r\n` con `gsub`. Es exactamente lo que hace `35_generar_motor_html.R` (L440)
  con su JSON base64; el patrón ya estaba probado en el proyecto.
- **Principio:** C.11 (transparencia), reutilización del patrón canónico del motor.
- **Nota de alcance:** este bug es latente en el propio paquete `suitedoc` si alguna vez
  embebe fuentes — motivo de fondo de P-SUITEDOC-INLINE (§11).

**Hallazgo (no bug) — contraste de la rampa monocromática.** Ninguna rampa de 3 tonos del
mismo matiz alcanza 3:1 de contraste entre segmentos adyacentes (bajo/medio ~1.2–2.0;
medio/alto ~1.8) ni bajo vs fondo cream (~1.3–2.3). Es limitación inherente, no de
calibración (subir factores mejora bajo/alto pero empeora bajo/cream). La accesibilidad se
garantiza por los canales textuales (🔒 invariante duro): `title` por segmento + % con
`_txtOn` + leyenda + borde de la barra. Queda como `# REVISAR` estético del titular (A14-2).

---

## 7. Aprendizajes y restricciones descubiertas

- **A15-1 (PCRE `.*` no cruza `\n`).** Ver bug s15-1. Extraer grupos de texto multilínea
  con `regexec`/`regmatches` o `(?s)`, nunca `sub(".*pat.*")`.
- **A15-2 (`base64_enc` es multilínea MIME).** Ver bug s15-2. Quitar `\r\n` del base64
  antes de embeberlo en `url()`/atributos; el patrón canónico es `gsub` (como `35` L440).
- **A15-3 (el gate pre-push protegió un deploy a producción).** El encargo se detuvo antes
  de la FASE 4 mostrando el set de 21 commits; el titular lo confirmó antes del push. Un
  push a Pages es saliente y difícil de revertir; el gate es la compuerta correcta cuando
  el contenido del set divergió del análisis original. Principio: A38 (versionado/pusheado
  es el cierre real), autonomía con interrupción solo en lo irreversible.
- **A15-4 (verificar rutas tras un `git add` de carpetas nuevas).** Una sospecha de que el
  tema se hubiera versionado en la raíz (en vez de `50_documentacion/suite/`) se resolvió
  con un chequeo de solo lectura (`git ls-files` + `ls` físico) antes de cerrar; resultó
  correcto. Un chequeo barato evita meter un bug de reproducibilidad en el traspaso.
  Principio: A20 (el escáner lista el filesystem; verificar con `git ls-files`).

---

## 8. Decisiones de diseño

- **D-s15-RAMPA (rampa de niveles monocromática por indicador).** Los stacked
  Bajo/Medio/Alto usan tonos derivados del color del indicador padre (Bajo claro → Alto
  oscuro/saturado), una rampa por indicador. Factores finales `RAMP_BAJO=0.45`,
  `RAMP_MEDIO=0.12`, `RAMP_ALTO=0.22`. Alternativa (rampa neutra única) descartada: el
  titular quiere que la identidad del indicador gobierne todo lo cromático. Sentido de la
  rampa (Alto oscuro) decidido por el titular al abrir.
- **D-s15-SEPARADOR (contenedor a escala).** `.hist-dim` como marco contenedor análogo a
  `.hist-ind` subordinado (border 1px cream + border-top 2px `--ic` + radius-2 + paper),
  no el border-left de la fase 3 de s14. Alternativa (conservar border-left) descartada:
  rechazada por el titular en revisión visual de s14.
- **D-s15-LEYENDA-NEUTRA (leyenda global en rampa neutra).** La leyenda de niveles es
  global al panel (mezcla subdimensiones de varios indicadores), sin un color de indicador
  único, así que usa rampa neutra de luminosidad (grises) + etiquetas textuales. Decisión
  del redactor. Alternativa (leyenda por indicador) descartada: recarga el panel.
- **D-s15-SUITE-INTERNA (suite no se publica en Pages).** Los HTML de documentación quedan
  internos (repo, para el equipo), no en `docs/`. Consecuencia: se versiona el tema para
  reproducibilidad desde el repo (D-s15-TEMA-VERSIONADO); los `_standalone.html` siguen
  gitignorados y reproducibles. Alternativa (publicar los "general") descartada por el
  titular.
- **D-s15-TEMA-VERSIONADO (versionar el tema de la suite).** Se quitaron del `.gitignore`
  las 3 reglas del tema y se versionaron CSS + fuentes + logos (~730 KB) para que la suite
  se rehaga desde el repo sin depender de `suitedoc` instalado. Alternativa (dejar
  dependiente del paquete) descartada: la reproducibilidad desde-el-repo no debe depender
  de un paquete externo instalado (dependencia de estado, C.2).

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | Sin cambio (solo lectura en s15). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| md5 build **desplegado** | `4958558d0e0ea21c05eb442f561bfaca` | `docs/index.html` en vivo, HEAD `ed240a6` | **Nuevo (s15): rampa + separador.** Reemplaza `27679407…` (paleta s14). |
| Establecimientos (motor) | 9136 | JSON | Sin cambio (fantasma rbd=NA excluido, H-FID-1). |
| Paleta indicadores (folleto) | Autoestima `#3858A3`, Convivencia `#61BDC6`, Participación `#4BA560`, Hábitos `#AACB58` | `35` L46 (`INDICADOR_COLORS`) | Sin cambio (s14). |
| Factores rampa de niveles | `RAMP_BAJO=0.45` (lighten), `RAMP_MEDIO=0.12` (lighten), `RAMP_ALTO=0.22` (darken) | `35_motor_template.html` (`nivelRamp`) | **Nuevo (s15).** Bajo claro → Alto oscuro. |
| Redondeo de presentación | entero (`round(.,0)`) | `35` L359/364/370-371 | Sin cambio (s14). |
| `primer_anio_familia` | indicador 2014, dimensión 2018, niveles 2023 | `meta` del JSON | Sin cambio (s14). |
| Total backlog (global) | 106 cambios (1–106) | `backlog_historico.md` | **+2 (s15).** |

---

## 10. Arquitectura de archivos

Estructura conforme a la política. Cambios de s15: `35_motor_template.html` (rampa +
separador); `docs/index.html` + `40_salidas/motor_idps.html` (regenerados, desplegados);
`50_documentacion/suite/inline_suite.R` (2 bugfixes); tema de la suite versionado
(`suite_estilos.css` + `fonts/*.otf` + `assets/*.png` ahora trackeados bajo `suite/`);
`.gitignore` (3 reglas del tema quitadas, `suite/*.html` conservada); snapshots del
escáner. Escáner al cierre: `estructura_actual.md` (30 carpetas, 250 archivos,
snapshot `20260622_141236`).

**Registro de ejecución detallado:** `50_documentacion/andamios/logs/20260622_paleta_v2_s15_log.md`
(log de la sesión de Claude Code de P-PALETA-v2; detalle paso a paso no reproducido aquí).

**Deuda de higiene aún en pie:** scripts `verificar_*.R` (7) + `reorganizar_universo_idps.R`
sueltos en la raíz del repo (gitignorados); 18 encargos `encargo_*.md` y artefactos de
trabajo mezclados en la raíz de `50_documentacion/activa/`. Ambos son el objeto de P-ORG (§11).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-SUITEDOC-INLINE — Integrar el inlining autocontenido al paquete `suitedoc` (NUEVO,
titular).**
- **Descripción:** que `generar_suite()` produzca los HTML ya autocontenidos (CSS +
  fuentes + assets embebidos en base64), eliminando el paso manual de `inline_suite.R` y
  evitando que cada proyecto con `suitedoc` arrastre los 2 bugs de s15 en su copia.
- **Origen:** los 2 fixes de `inline_suite.R` de s15 (A15-1 regexec; A15-2 quitar saltos
  del base64) son la lógica probada a portar. El bug A15-2 es latente en el propio paquete
  si embebe fuentes.
- **Insumo imprescindible:** código fuente de `suitedoc` (`generar_suite()` + los builders
  que escriben el HTML y enlazan el tema). Sin él, el punto de integración se inventaría (B.1).
- **Tipo:** BIBLIOTECA sobre el paquete `suitedoc` — **repo distinto de `slep_idps`**.
- **Decisión de diseño abierta:** ¿`generar_suite()` produce solo HTML autocontenidos
  (reemplaza el modelo tema-enlazado) o ambos (base para edición + standalone para
  compartir)?
- **Complejidad:** Media. **Precaución:** afecta a todos los proyectos con `suitedoc`
  (`slep_simce_adecuado`, `slep_categoria_desempeno`, etc.); una vez integrado, regenerar
  sus suites para que hereden el fix.
- **Criterio de éxito sugerido:** `generar_suite()` emite HTML que abren con estilo desde
  cualquier carpeta sin paso manual; los 2 bugs de s15 imposibles de reintroducir.

**P-ORG — Reorganizar el directorio del proyecto (NUEVO, titular).**
- **Descripción:** el directorio está desordenado; faltan carpetas que agrupen documentos
  recientes. Foco: `50_documentacion/activa/` mezcla en su raíz 18 encargos `encargo_*.md`,
  protocolo (`POLITICA`, `SETTINGS`, `prompt_nuevo_proyecto`) y artefactos de trabajo
  (`backlog_*.md`, `censo_universo_idps.md`); y 7 `verificar_*.R` + `reorganizar_universo_idps.R`
  sueltos en la raíz del repo.
- **Tipo:** deuda técnica / migración de estructura.
- **Precaución:** 🔒 es migración de estructura → **protocolo 4.2** (diagnóstico de
  referencias literales ANTES del mapeo + `DRY_RUN <- TRUE` obligatorio). Los encargos se
  referencian por ruta en logs y traspasos: mover encargos sin rastrear esas referencias
  las rompe. La política no define subcarpeta canónica para encargos → es decisión de
  taxonomía nueva (¿`activa/encargos/`?), no solo `mv`.
- **Complejidad:** Media. NO mezclar con otros tipos de cambio (política §9.7).
- **Criterio de éxito sugerido:** encargos y artefactos de trabajo en subcarpetas claras;
  `verificar_*.R` archivados a `_archivo/`; referencias en logs/traspasos actualizadas;
  DRY_RUN verde antes del modo real.

**Afinación de tono de la suite (menor, titular).** 2 marcas `# REVISAR (voz)` en
`documentar.R` (L311 prosa de documentos; L370 títulos/intros de sección) + uso de
"colegio" como genérico en `doc_que` (L315 prosa técnica) y L306 (FAQ — excepción válida
de voz del lector). Editar `documentar.R`, regenerar (`documentar.R` → `inline_suite.R`).
No bloquea (suite interna).

**`# REVISAR` estético de la rampa (menor, titular, A14-2).** OK estético de las 3
superficies. Si se quiere más separación visual entre segmentos de la rampa, evaluar un
separador fino (hairline) entre `span` — decisión nueva.

### Evaluación de deuda técnica
- **`50_documentacion/activa/` y raíz del repo:** desorden acumulado (objeto de P-ORG).
- **`inline_suite.R`:** corregido; su lógica debe migrar al paquete (P-SUITEDOC-INLINE)
  para no vivir duplicada en cada proyecto.

### Auditoría de cierre (política 5.6)
- Pipeline corre de cero sin intervención: **Sí**.
- Outputs reproducibles/idempotentes: **Sí** (regeneración verificada; parquet intacto;
  suite reproducible desde el repo tras versionar el tema).
- Decisiones metodológicas como constantes nombradas: **Sí** (`nivelRamp` factores,
  separador con tokens nombrados).
- Nombres sin tildes/ñ/espacios: **Sí** en lo canónico (andamios de diseño con espacios
  son congelados, excepción declarada; crudos heredados, excepción declarada).
- Estructura respeta la política: **Sí**, con la deuda de P-ORG anotada.

### Ruta sugerida para la sesión 16
1. **Apertura CONTINUATION** con este v15 + `backlog_historico.md` + escáner + protocolo
   de la KB.
2. **Decidir el foco:** P-SUITEDOC-INLINE (repo del paquete, requiere el código fuente de
   `suitedoc`) o P-ORG (este repo, migración de estructura con protocolo 4.2). Son dominios
   distintos; no mezclarlos. **Recomendación:** P-SUITEDOC-INLINE primero si el titular va
   a generar más documentación pronto (el fix beneficia a todos los proyectos); P-ORG si
   prefiere ordenar `slep_idps` antes de seguir construyendo encima.
3. **Diferir:** afinación de tono de la suite y `# REVISAR` estético de la rampa (menores).

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El dato está verificado a nivel CENSO (s11) y la fidelidad parquet→sitio también
  (s12, re-confirmada en s14 y s15). NO re-auditar ni regenerar el parquet. md5 `4c764d8c…`.
- 🔒 El motor **desplegado** es el de P-PALETA-v2 (build `4958558d…`, HEAD `ed240a6`). El
  repo está sincronizado con origin (sin divergencia local/remoto).
- 🔒 Cualquier cambio de `35` exige REGENERAR y RE-VERIFICAR fidelidad censal antes de
  desplegar. NO desplegar a ciegas.
- 🔒 **Identidad de indicador es regla:** todo lo cromático de un indicador (gráficos y
  stackeds de niveles) vive en su familia de color. NO introducir paleta semáforo ni
  colores ajenos. La rampa de niveles ya cumple esto (D-s15-RAMPA).
- 🔒 **StackedBar (estado vs GSE) es intocable:** codifica significancia
  (`--alerta/--st-neutro/--destaca`), NO niveles. No confundir con la rampa de niveles.
- 🔒 D-s15-RAMPA, D-s15-SEPARADOR, D-s15-LEYENDA-NEUTRA, D-s15-SUITE-INTERNA,
  D-s15-TEMA-VERSIONADO están DECIDIDAS. No reabrir sin decisión explícita del titular.
- ⚠️ NO inventar significancia/GSE/geo donde el dato trae NA (vigente desde v11).
- ⚠️ P-SUITEDOC-INLINE es sobre el repo del paquete `suitedoc`, NO sobre `slep_idps`;
  requiere el código fuente del paquete como insumo.
- ⚠️ P-ORG es migración de estructura: protocolo 4.2, DRY_RUN obligatorio, diagnóstico de
  referencias antes del mapeo. NO mezclar con otros cambios.
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atómicos por ruta; nunca
  `git add .`/`-u`.
- 🔒 El backlog vive en `backlog_historico.md` (106 cambios, 1–106). Actualizarlo en CADA
  cierre; NO volver a diferir el conteo (A22/A14-3).

---

## 13. Fragmentos de código de referencia

**Rampa monocromática de niveles derivada del color del indicador (patrón D-s15-RAMPA):**
```js
// Reutiliza _lighten/_darken (misma familia que dimColor; sin colores nuevos).
// Bajo claro -> Alto oscuro. Degrada a --bajo/--medio/--alto si no es hex.
function nivelRamp(mother){
  if(!mother||mother[0]!=='#') return {bajo:"var(--bajo)",medio:"var(--medio)",alto:"var(--alto)"};
  return { bajo:_lighten(mother,0.45), medio:_lighten(mother,0.12), alto:_darken(mother,0.22) };
}
// Hilado: IndPanel(const ramp=nivelRamp(ind.color)) -> DimBlock -> SubDist -> DistBar({v,ramp})
```

**Quitar saltos de línea del base64 antes de embeber (patrón A15-2, igual que `35` L440):**
```r
# jsonlite::base64_enc envuelve en lineas MIME de 76 chars; un \n dentro de
# url('data:...') invalida la regla CSS. Quitarlos SIEMPRE al embeber.
b64 <- gsub("[\r\n]", "", jsonlite::base64_enc(bytes))
```

**Extraer un grupo de HTML multilínea (patrón A15-1; NO usar `sub(".*pat.*")`):**
```r
# PCRE .* no cruza \n. regexec/regmatches captura el grupo correctamente.
m <- regexec(link_pat, html, perl = TRUE)
href <- regmatches(html, m)[[1]][2]   # [1]=match completo, [2]=grupo 1
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 16 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  SETTINGS) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v15, el
  backlog histórico consolidado y el escáner actual. El motor con la rampa de niveles
  (P-PALETA-v2) está desplegado y certificado (HEAD `ed240a6`, build `4958558d…`); el repo
  está sincronizado con origin. El parquet está blindado (md5 `4c764d8c…`). La suite
  `suitedoc` renderiza con estilo y su tema está versionado (interna, no Pages). Foco a
  decidir entre dos pendientes de dominios distintos: **P-SUITEDOC-INLINE** (integrar el
  inlining autocontenido al paquete `suitedoc` — repo del paquete, requiere su código
  fuente) o **P-ORG** (reorganizar el directorio de `slep_idps` — migración de estructura,
  protocolo 4.2)."
- **Documentos para la sesión 16, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que esté al
     día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según el foco:*
     - Si P-SUITEDOC-INLINE: el **código fuente del paquete `suitedoc`** (`generar_suite()`
       + builders; **imprescindible**); `inline_suite.R` corregido (la lógica a portar);
       `encargo_autonomo_claude_code_v1.md` si habrá encargo.
     - Si P-ORG: `estructura_actual.md` (imprescindible, ya en el bloque 3);
       `99_reorganizar_estructura_PLANTILLA.R` de `herramientas_dev/`; `CLAUDE.md` si corre
       en Claude Code.
  3. *Específicos de la sesión (SÍ se adjuntan):* `traspaso_cierre_v15.md`;
     `backlog_historico.md`; `estructura_actual.md`.
- **Nota final:** si `35_generar_motor_html.R`, `35_motor_template.html` o
  `inline_suite.R` cambian entre sesiones, adjuntar la versión más reciente y avisarlo en
  la apertura. El backlog histórico debe actualizarse a 106 (entradas 105–106) antes de
  cerrar s16.
