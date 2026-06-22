# traspaso_cierre_v14.md

> Documento de cierre de sesión. Único puente entre sesiones: todo lo que no quede
> aquí se pierde. Generado al cierre de la sesión 14 de `slep_idps`.

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, todo
  Chile; Rama A pública, datos versionados en el repo).
- **Versión de traspaso:** v14.
- **Fecha:** 2026-06-22.
- **Sesión:** 14. **Foco:** sesión extensa de cuatro frentes — **P-PALETA**
  (adopción de la paleta del folleto de la Agencia, desplegada), **auditoría de
  decimales** de `prom` (procedencia de las cifras, concluyente), **P-DOC** (suite
  `suitedoc` generada) y **ajustes de presentación del motor** (4 fases vía encargo
  autónomo a Claude Code). Cierre con **reconciliación A22** del backlog histórico
  (deuda diferida desde v10). **Resultado:** paleta del folleto en vivo; decimales
  certificados como nativos de la Agencia; suite generada (render por verificar);
  3 de 4 ajustes de motor aprobados (1 rechazado en revisión visual); backlog
  global reconciliado a 104 cambios; nuevo pendiente mayor **P-PALETA-v2**.
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`). Ejecución dual-Claude: este Claude como analista/redactor; Claude Code
  como ejecutor (dos encargos autónomos: paleta y ajustes de motor; más comandos
  puntuales).
- **Archivos principales modificados:** `30_procesamiento/35_generar_motor_html.R`
  (paleta `INDICADOR_COLORS` + redondeo entero + `primer_anio_familia`);
  `30_procesamiento/35_motor_template.html` (tokens espejo, borde dimensión,
  espaciado ficha, eje por familia); `docs/index.html` y `40_salidas/motor_idps.html`
  (regenerados; el de paleta desplegado, el de ajustes local sin push);
  `50_documentacion/suite/` (suite `suitedoc` nueva: `documentar.R`, 4 HTML, tema);
  `50_documentacion/activa/decisiones/20260622_decision_paleta_indicadores.md`
  (nuevo); 3 logs de Claude Code en `andamios/logs/`; `backlog_historico.md`
  (nuevo, consolidado). **El parquet NO se tocó** (md5 `4c764d8c…` intacto en las
  tres operaciones que tocaron el motor).

---

## 2. Resumen ejecutivo

La sesión 14 trabajó cuatro frentes sobre el motor ya certificado. **P-PALETA**
(pendiente del titular desde v13) se resolvió y **desplegó**: los 4 indicadores
adoptan la identidad cromática del folleto de la Agencia (Autoestima `#3858A3`,
Convivencia `#61BDC6`, Participación `#4BA560`, Hábitos `#AACB58`), con el JSON
byte-idéntico al certificado salvo los 4 valores `color` y panel adversarial 3/3.
Antes de tocar cifras, una **auditoría de procedencia de los decimales** de `prom`
concluyó que son **nativos de la Agencia** (el pipeline los lee verbatim; el único
redondeo es de presentación), habilitando la decisión de mostrarlos como enteros.
Con esa base, un encargo autónomo de **4 ajustes de presentación del motor**
(decimales→entero, recorte de eje por familia, borde por dimensión, espaciado de
la pestaña establecimiento) se ejecutó y verificó con fidelidad censal intacta
(mismatch 0 sobre 2,9 M celdas). En paralelo se generó la **suite `suitedoc`**
(P-DOC). El cierre incluyó la **reconciliación A22**: el conteo global del backlog,
diferido desde v10, se consolidó contra el detalle cronológico (total **104
cambios**, archivo `backlog_historico.md`). En revisión visual, el titular **rechazó
el borde por dimensión** (fase 3) y abrió un pendiente mayor de rediseño cromático
(**P-PALETA-v2**): eliminar los semáforos de los stacked de niveles llevándolos a
tonalidades del color del indicador, y rehacer el separador de dimensión. Por
decisión del titular (camino A) **el motor con los 4 ajustes NO se desplegó**: se
rehace la fase 3 y se publica todo junto en v15.

---

## 3. Estado al cierre

### Qué funciona
- **Motor desplegado con la paleta del folleto** (P-PALETA en vivo):
  `https://tomgc.github.io/slep_idps/` sirve el build con la identidad cromática de
  la Agencia (build md5 `27679407577fd43f1d8a53806168e1f8`, HEAD `1d41c17`).
  Última ejecución exitosa: regeneración + deploy de P-PALETA (Fase 6 del log de
  paleta), `live == local` confirmado.
- **Dato (parquet `idps_largo.parquet`, md5 `4c764d8c…`):** intacto. Leído (solo
  lectura) por la auditoría de decimales y por las regeneraciones; nunca escrito.
- **Suite de documentación generada** (`50_documentacion/suite/`): 4 HTML
  (`arquitectura_*`, `documentacion_*`), `documentar.R`, tema. Existe en disco.
- **Backlog histórico consolidado** (`backlog_historico.md`): numeración global
  1–104 reconciliada (cierra A22).

### Qué no funciona / queda a medias
- **Motor con los 4 ajustes de presentación (s14): build local, NO desplegado.**
  6 commits locales `b90ebd8`→`5a311de` (+ log). El build local existe
  (`docs/index.html` md5 `e166ef6f5a9587b3659ab06f3a9f9f5f`) pero **el HEAD
  desplegado sigue siendo el de paleta** (`1d41c17`). Por decisión del titular
  (camino A) no se pushea hasta rehacer la fase 3.
- **Fase 3 (borde por dimensión): rechazada en revisión visual.** Técnicamente
  ejecutada y verificada (border-left 3px del color del indicador), pero no es lo
  que el titular quiere. Se rehace en v15.
- **Suite `suitedoc`: render no verificado.** La suite se generó pero **no se
  corrió `inline_suite.R`** ni se confirmó visualmente el resultado. Entrega
  sustantiva, no cerrada.

### Delta respecto a v13
- **P-PALETA:** de pendiente-titular a **DESPLEGADO** (paleta del folleto en vivo)
  — pero **reabre** como P-PALETA-v2 por instrucción del titular (rediseño
  cromático adicional).
- **P-DOC:** de pendiente a **ENTREGA SUSTANTIVA** (suite generada), con render por
  verificar.
- **Auditoría de decimales:** **NUEVA y CERRADA** (veredicto: nativos de la
  Agencia).
- **Ajustes de motor:** **NUEVO**, 3/4 aprobados, 1 rechazado; build local sin push.
- **A22 (reconciliación de backlog):** de deuda diferida (desde v10) a **CERRADA**
  (`backlog_historico.md`, 104 cambios).
- **P-PALETA-v2:** **ABIERTO** (nuevo, titular).

---

## 4. Registro detallado de cambios (sesión 14)

> Numeración global reconciliada en `backlog_historico.md`. Las 4 entradas de s14
> son los cambios **101–104**.

**C1 (#101) — P-PALETA: adopción de la paleta del folleto de la Agencia**
[visualización/diseño; desplegado]. Encargo autónomo a Claude Code
(`encargo_claude_code_idps_paleta.md`). Los 4 indicadores pasan de la paleta interna
(rojo/amarillo/verde-lima/azul) a la identidad cromática del folleto oficial:
Autoestima `#EE2D49`→`#3858A3`, Convivencia `#FFC92E`→`#61BDC6`, Participación
`#9BC93E`→`#4BA560`, Hábitos `#2A8FD9`→`#AACB58`. Fuente única runtime:
`INDICADOR_COLORS` (L46 del generador); el `color` entra al JSON en un solo punto
(L116), de donde lo leen radar, `BarrasAnio`, dots, swatches, tabla territorial y
paneles; `dimColor()` deriva los tonos de dimensión del color madre. Token espejo
`--ind1..4` sincronizado (coherencia documental; ningún CSS lo consume). Realce
no-textual: hairline `inset 0 0 0 1px rgba(35,48,58,.22)` en swatches/dots claros
(ind2/3/4) para contraste de borde contra `cream` (WCAG 1.4.11 ≥3:1); se confirmó
por enumeración independiente que **ningún elemento con `background=ind.color` lleva
texto encima**, por lo que no hizo falta tocar color de texto. **Verificación:**
panel adversarial 3/3 PASA; neutralizando `color`, el JSON es byte-idéntico al
certificado (60.359.353 chars); cifras ind/dim/niv 0 diffs; universo 9.136; parquet
md5 intacto. **Desplegado** (`ce2604d..1d41c17`, `live==local`). Commits
`bd8bceb`, `7804fb2`, `9035a38`, `4c41c4a`, `1d41c17`(decisión).
Log: `andamios/logs/20260622_paleta_indicadores_log.md`.

**C2 (#102) — Auditoría de procedencia de los decimales de `prom`** [verificación/
auditoría; solo lectura, sin commit]. Diagnóstico de si los decimales que muestra
el motor son nativos de la Agencia o derivados por el pipeline. **Veredicto: nativos**
— `34` lee `prom` verbatim (única transformación: coma→punto del locale chileno vía
`to_num`; sin `round`, `mutate` ni cálculo); el único redondeo es de presentación en
`35` (`round(prom,1)`). La distribución de decimales en el parquet es **bimodal**:
~75 % enteros exactos, ~25 % cola larga de precisión doble IEEE-754 (hasta 14
decimales), y **cero** valores con exactamente 1 decimal — firma de "entero o
full-precision", no de "redondeado por la fuente". Contraste censal build desplegado
vs `round(parquet,1)`: 885.486 celdas, **mismatch 0** (los únicos "solo-parquet" son
4 celdas del fantasma rbd=NA, excluido por diseño). **Conclusión para validación
externa:** la cifra de 1 decimal del motor es el redondeo del puntaje real publicado
por la Agencia; el pipeline lo lee verbatim y solo lo redondea al mostrarlo. Habilita
la decisión de presentación de C4 (mostrar enteros). Sin commit (solo lectura).
Log: `andamios/logs/20260622_auditoria_decimales_prom_log.md`.

**C3 (#103) — P-DOC: suite de documentación `suitedoc`** [documentación de proyecto;
entrega sustantiva, render por verificar]. Generación de la suite de 4 HTML
(`arquitectura_slep_idps`, `arquitectura_general_slep_idps`,
`documentacion_proyecto_slep_idps`, `documentacion_general_slep_idps`) vía el
protocolo 4.6, con `documentar.R` del proyecto y tema en `50_documentacion/suite/`.
**Estado:** los artefactos existen en disco (escáner los lista). **Pendiente:** no se
corrió `inline_suite.R` ni se verificó el render. **No cerrada** — queda como
pendiente P-DOC-RENDER para v15. (Detalle de gobernanza de la suite: terminología
"establecimiento educacional", sin nombres reales — los generales se publican.)

**C4 (#104) — Ajustes de presentación del motor (encargo de 4 fases)**
[visualización/diseño; build local, NO desplegado]. Encargo autónomo a Claude Code
(`encargo_ajustes_motor_s14.md`), 4 ajustes de presentación de `35`, ninguno toca el
dato. **Una solicitud del titular, 4 fases:**
- **Fase 1 — Decimales→entero:** `round(.,1)`→`round(.,0)` en `prom` (ind/dim) y
  `niv_bajo/medio/alto_por` (L359/364/370-371). El template no requirió cambio
  (`fmt` usa `toLocaleString`, no `toFixed`). **Aprobada.**
- **Fase 2 — Recorte de eje por familia:** `35` calcula `meta.primer_anio_familia`
  derivado del dato (columna correcta por familia: niveles usa `niv_bajo_por`, no
  `prom`), y el template recorta el FRENTE del eje por panel con `ejeFam(fam)`. Solo
  recorta años previos al primer dato sistémico de la familia; los huecos internos
  (pandemia/no_eval/sin-dato del EE) se conservan. Resultado: indicador 2014→2025,
  **dimensión 2018→2025** (sin 2014-2017), niveles 2023 (sin serie temporal visible
  hoy). **Aprobada.**
- **Fase 3 — Borde por dimensión:** `border-left:3px solid var(--ic)` por dimensión.
  Técnicamente ejecutada y verificada (`#3858A3` en ind1, consume la paleta sin
  redefinirla). **RECHAZADA en revisión visual del titular** (no le gusta el
  border-left lateral; quiere un contenedor a escala de dimensión, como el del
  indicador). Se rehace en P-PALETA-v2.
- **Fase 4 — Espaciado pestaña establecimiento:** `.ficha-bar` pasa a banner
  autónomo (radio completo + `margin-bottom:16px`), igualado a `.pan-bar` de la
  pestaña territorial. **Aprobada.**

**Verificación (Fase 5):** `run_all(only=35)` OK; fidelidad censal parquet→sitio con
redondeo entero **mismatch 0 sobre 2.911.824 celdas**; panel adversarial 3/3 PASA;
universo 9.136; parquet md5 inicio==fin. **NO desplegado** (decisión del titular,
camino A: rehacer fase 3 y publicar todo junto en v15). 6 commits locales
`b90ebd8`(F1), `5cd8465`(F2), `a79346a`(F3), `756b464`(F4), `5a311de`(build), + log.
Log: `andamios/logs/20260622_ajustes_motor_s14_log.md`.

**C5 (cierre, no numerado) — Reconciliación A22 del backlog histórico** [cierre de
sesión]. Consolidación del conteo correlativo global, diferido desde v10. Volcado
verbatim de las 14 secciones de backlog (Claude Code, solo lectura →
`backlog_volcado_crudo.md`); reconciliación contra el detalle cronológico de los
consolidados íntegros v07/v08/v09 (numeración 1–83 verificable) y de los deltas
v10–v13 (84–100); s14 numerada 101–104. Total **104 cambios**. Producto:
`backlog_historico.md`. No es un "cambio" de producto en el sentido de la nota
metodológica (es mantenimiento de la memoria del backlog); se registra aquí por
trazabilidad del cierre.

---

## 5. Backlog acumulativo

> **A partir de v14 el backlog vive consolidado en `backlog_historico.md`** (raíz
> de `50_documentacion/activa/` o donde el titular lo ubique), con numeración global
> 1–104. Esta sección ya NO copia el delta suelto: referencia el archivo histórico,
> que es la única fuente de verdad del conteo (A22 cerrado).

- **Total a v14:** 104 cambios (1–83 hasta v09; 84–100 reconciliados de v10–v13;
  101–104 de s14).
- **Delta v14:** +4 entradas (101 P-PALETA, 102 auditoría decimales, 103 suite
  suitedoc, 104 ajustes de motor) + la reconciliación A22 que cierra la deuda de
  conteo.
- **Taxonomía:** 3 categorías nuevas al consolidar (Verificación/auditoría;
  Decisión/gobernanza de producto; Documentación de proyecto). Detalle y
  porcentajes en `backlog_historico.md`.

---

## 6. Bugs y hallazgos de la sesión

No hubo bugs de código nuevos (los frentes de s14 fueron presentación + auditoría +
documentación; el motor no destapó regresiones). Hallazgos relevantes:

**H-s14-SEMAFORO (hallazgo de revisión, no bug de ejecución).** El encargo de paleta
(C1) excluyó deliberadamente los colores de NIVEL: el log declaró `.bar` (StackedBar
Bajo/Medio/Alto) "usa `--bajo/--medio/--alto`, no la paleta de indicador → fuera de
alcance". En la revisión visual, el titular identificó que esos stacked siguen en
**paleta semáforo** (rojo/amarillo/verde), lo cual contradice una regla del titular
(la identidad cromática de cada indicador debe gobernar TODO lo cromático de ese
indicador, gráficos y stackeds). **Regla aprendida (A14-1, ver §7):** un encargo que
acota su alcance a "la paleta de indicador" debe verificar explícitamente si existen
superficies cromáticas relacionadas (niveles) que la regla del titular también
gobierna, en vez de declararlas fuera de alcance sin contrastarlas con la regla.
No es un bug de Claude Code (cumplió el alcance del encargo); es un **miss del
encargo** (lo redactó este analista): el alcance debió incluir los stacked o, al
menos, marcar la exclusión como deuda contra la regla de identidad. Estado: abierto
en P-PALETA-v2.

---

## 7. Aprendizajes y restricciones descubiertas

- **A14-1 (el alcance de un encargo debe contrastarse con las reglas del titular, no
  solo con su propio enunciado).** El encargo de paleta acotó a "color de indicador"
  y dejó los stacked de niveles fuera, sin verificar que la regla del titular
  ("identidad de indicador gobierna todo lo cromático") los incluye. Resultado:
  semáforos sobrevivientes que el titular tuvo que señalar. Principio: B.1 (sin
  supuestos implícitos), B.4 (criterio de éxito definido contra la intención real).
  Al redactar un encargo de presentación, enumerar TODAS las superficies que la
  regla invocada gobierna, no solo las que el título del encargo nombra.
- **A14-2 (verificación técnica ≠ aprobación del titular).** La fase 3 (borde por
  dimensión) pasó toda la verificación censal y de invariantes, y aun así fue
  rechazada en revisión visual. La fidelidad de datos y el cumplimiento del encargo
  no garantizan que el resultado sea lo que el titular quería ver. Principio: A19
  (cuando la iteración visual no converge, pedir referencia aprobada). Para
  presentación, la compuerta final es la revisión visual del titular, no el panel
  adversarial.
- **A14-3 (la reconciliación diferida se acumula y se encarece).** A22 se difirió 4
  sesiones (v10–v13) con la nota "se actualiza en la próxima apertura"; nunca se
  ejecutó hasta acumular 21 entradas sin numerar. Principio: A22, A38 (lo diferido
  no desaparece). El conteo se actualiza en el cierre que lo genera, no "en la
  próxima apertura"; ahora vive en `backlog_historico.md` y se mantiene cada cierre.
- **A14-4 (auditar la procedencia antes de decidir presentación).** La decisión de
  mostrar enteros se tomó DESPUÉS de probar que los decimales eran nativos (no
  derivados); si hubieran sido un artefacto del pipeline, la decisión correcta
  habría sido otra (corregir el origen, no redondear la vista). Principio: B.1,
  A10-1. Una decisión de presentación sobre una cifra exige saber de dónde viene la
  cifra.

---

## 8. Decisiones de diseño

- **D-s14-PALETA (adopción de la identidad del folleto).** Los 4 indicadores usan
  los hex del folleto oficial de la Agencia. Alternativa (mantener paleta interna)
  descartada: la fidelidad a la identidad institucional es instrucción reincidente
  del titular. **Deuda menor declarada:** los hex se muestrearon por moda exacta del
  PNG del folleto (alta nitidez), no por extracción vectorial del PDF. Frase canónica
  ante validación externa: "la paleta del motor replica la identidad oficial de los 4
  indicadores IDPS de la Agencia". Replicada en
  `decisiones/20260622_decision_paleta_indicadores.md`. **⚠️ Corregir en ese archivo
  la fecha/sesión: dice s12, es s14** (pendiente de cierre, ver §11).
- **D-s14-ENTERO (puntajes y niveles a entero).** Mostrar `prom` (ind/dim) y niveles
  como enteros, no con 1 decimal. Fundada en la auditoría C2 (decimales nativos; el
  redondeo es solo de presentación, no altera el dato). Alternativa (mantener 1
  decimal) descartada: el titular prefiere la lectura entera y la auditoría confirma
  que no se pierde fidelidad de origen (el dato sigue intacto en el parquet).
- **D-s14-EJE-FAMILIA (recorte de eje por familia, opción A).** El eje histórico se
  recorta por familia al primer año con dato sistémico (indicador 2014, dimensión
  2018, niveles 2023), derivado del dato. 2018 se mantiene como punto aislado con
  hueco visible (opción A), no se separa. Alternativa (eje único por grado, statu
  quo) descartada: producía "años fantasma" al frente en dimensión/niveles.
- **D-s14-NO-DEPLOY-MOTOR (camino A).** Los 6 commits de ajustes de motor NO se
  despliegan: se rehace la fase 3 (separador) en v15 y se publica todo junto.
  Alternativa B (pushear fases 1/2/4 ahora revirtiendo solo la 3) descartada:
  evita dos deploys Pages seguidos y exponer una versión intermedia con un borde ya
  rechazado; P-PALETA-v2 es el próximo foco, así que conviene un push consolidado.

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | Sin cambio (leído solo lectura en s14). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| md5 build **desplegado** (paleta) | `27679407577fd43f1d8a53806168e1f8` | `docs/index.html` en vivo, HEAD `1d41c17` | **Es el desplegado al cierre.** |
| md5 build **local** (ajustes motor) | `e166ef6f5a9587b3659ab06f3a9f9f5f` | `docs/index.html` local, HEAD `5a311de` | NO desplegado (camino A). |
| Establecimientos (motor) | 9136 | JSON | Sin cambio (fantasma rbd=NA excluido, H-FID-1). |
| Paleta indicadores (folleto) | Autoestima `#3858A3`, Convivencia `#61BDC6`, Participación `#4BA560`, Hábitos `#AACB58` | `35_generar_motor_html.R` L46 (`INDICADOR_COLORS`) | **Nueva (s14).** Fuente única runtime. |
| `primer_anio_familia` | indicador 2014, dimensión 2018, niveles 2023 | `meta` del JSON (derivado del dato) | **Nuevo (s14).** Recorte de eje por familia. |
| Redondeo de presentación | entero (`round(.,0)`) | `35` L359/364/370-371 | **Cambiado (s14)**: era `round(.,1)`. |
| Total backlog (global) | 104 cambios (1–104) | `backlog_historico.md` | **Reconciliado (s14, A22).** |

---

## 10. Arquitectura de archivos

Estructura conforme a la política. Cambios de s14: `35_generar_motor_html.R` y
`35_motor_template.html` (paleta + 4 ajustes); `docs/index.html` +
`40_salidas/motor_idps.html` (regenerados; paleta desplegada, ajustes locales);
`50_documentacion/suite/` (suite `suitedoc` nueva); 1 decisión nueva
(`20260622_decision_paleta_indicadores.md`); 3 logs en `andamios/logs/`;
`backlog_historico.md` (nuevo); `backlog_volcado_crudo.md` (insumo crudo de A22,
untracked). Escáner al cierre: `estructura_actual.md` (30 carpetas, 241 archivos).

**Registro de ejecución detallado:** los logs paso a paso de las sesiones de Claude
Code viven en `50_documentacion/andamios/logs/` (`20260622_paleta_indicadores_log.md`,
`20260622_auditoria_decimales_prom_log.md`, `20260622_ajustes_motor_s14_log.md`);
detalle no reproducido aquí.

**Deuda de higiene aún en pie (baja prioridad):** scripts `verificar_*.R` (7) en la
raíz del repo, gitignorados (`/verificar_*.R`) → no trackeados, pero ensucian el
working tree local. Decidir en sesión futura si se archivan a `_archivo/`.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-PALETA-v2 — Rediseño cromático del motor (NUEVO, titular). Foco de v15.**
- **Descripción:** ajustes adicionales de paleta tras la adopción del folleto (C1).
  Principio rector del titular: **la identidad cromática de cada indicador gobierna
  TODO lo cromático de ese indicador** (gráficos y stackeds), una familia por
  indicador.
- **Ítems concretos:**
  1. **Stacked de niveles a rampa monocromática del indicador.** Hoy los stacked
     Bajo/Medio/Alto usan paleta **semáforo** (`--bajo/--medio/--alto`,
     rojo/amarillo/verde); deben pasar a **tonalidades del color del indicador
     padre** (p. ej. Autoestima azul → Bajo/Medio/Alto en azul claro→medio→oscuro).
     Elimina el semáforo como consecuencia de aplicar la identidad, no como parche.
     **Decisión de diseño abierta (única que v15 debe preguntar antes de
     implementar): el SENTIDO de la rampa** — qué extremo es Alto (azul más oscuro/
     saturado vs. más claro), consistente entre los 4 indicadores. El orden
     Bajo→Alto pasa a codificarse por luminosidad + etiqueta (hoy es redundante por
     color y posición).
  2. **Separador de dimensión (rehacer fase 3 de s14).** El `border-left:3px` que se
     implementó NO gusta. Reemplazar por un **contenedor/marco a escala de
     dimensión**, análogo al que rodea al indicador (el marco superior completo en
     el color del indicador que se ve en la vista histórica), escalado al nivel de
     dimensión. Revierte la fase 3 commiteada localmente.
- **Tipo:** bug de fidelidad visual / rediseño de presentación (no cifra).
- **Precaución:** 🔒 cualquier toque a `35` exige REGENERAR + RE-VERIFICAR fidelidad
  censal antes de desplegar. La rampa NO altera valores (solo el color de los
  segmentos), pero el build cambia de md5. 🔒 conservar la identidad del indicador
  (no introducir colores ajenos a la familia). NO desplegar a ciegas.
- **Pistas del log de P-PALETA (para no partir de cero):** `dimColor()` ya deriva
  tonos de dimensión del color madre; la rampa de niveles puede seguir el mismo
  mecanismo. Revisar los fills claros ind2/3/4 con su hairline. El titular ya
  confirmó que la derivación monocromática dentro de la familia es lo correcto (no
  quiere diferenciar dimensiones con colores ajenos).
- **Complejidad:** Media. Candidato a metodología A19 (referencia aprobada) si la
  iteración visual no converge — A14-2 enseña que la verificación técnica no basta
  para presentación.
- **Criterio de éxito sugerido:** stacked de niveles en tonos del indicador (semáforo
  eliminado, sentido de rampa definido y consistente); separador de dimensión como
  contenedor a escala; fidelidad censal re-certificada; los 4 ajustes de motor de
  s14 (con fase 3 rehecha) + el rediseño cromático desplegados en un push
  consolidado.

**P-DOC-RENDER — Verificar la suite `suitedoc`.**
- Correr `inline_suite.R` desde la máquina del titular y confirmar el render de los
  4 HTML. La suite está generada (C3); falta la verificación visual y decidir si la
  metodología se publica en Pages. Tipo BIBLIOTECA (cierre liviano).

**Deuda de cierre de s14 (mecánica, ver §12):** push consolidado pendiente (camino
A); commits de cierre de archivos sueltos; corregir fecha de la decisión de paleta;
actualizar `CLAUDE.md`.

**Deuda de higiene heredada:** scripts `verificar_*.R` (7) en raíz (gitignorados,
no urgente).

### Evaluación de deuda técnica
- **Generador `35`:** zona frágil = uniones con el directorio (coalesce geo/
  dependencia). P-PALETA-v2 toca render (stacked + separador), no las uniones, pero
  debe respetar los `stopifnot` calibrados en s12.
- **Build local sin desplegar:** mientras los 6 commits de ajustes de motor no se
  pusheen, el repo local diverge del desplegado. v15 debe consolidar (rehacer fase 3
  + rediseño cromático) y pushear todo junto; no dejar el desfase otra sesión más.

### Auditoría de cierre (política 5.6)
- Pipeline corre de cero sin intervención: **Sí**.
- Outputs reproducibles/idempotentes: **Sí** (regeneraciones verificadas; parquet
  intacto).
- Decisiones metodológicas como constantes nombradas: **Sí** (`INDICADOR_COLORS`,
  `primer_anio_familia` derivado del dato, redondeo explícito).
- Nombres sin tildes/ñ/espacios: **Sí** (sin cambios respecto a v13; tildes solo en
  crudos heredados, excepción declarada).
- Estructura respeta la política: **Sí**, con la deuda de `verificar_*.R` anotada.

### Ruta sugerida para la sesión 15
1. **Apertura CONTINUATION** con este v14 + `backlog_historico.md` + escáner +
   protocolo de la KB.
2. **P-PALETA-v2** como foco (decisión del titular): definir el sentido de la rampa
   (única pregunta de diseño), encargo a Claude Code para (a) stacked de niveles a
   tonos del indicador, (b) rehacer separador de dimensión como contenedor a escala,
   regenerar + re-verificar fidelidad. Incluir en ese mismo build los ajustes de
   s14 ya aprobados (fases 1/2/4) para el **push consolidado**.
3. **Cierre mecánico** (commits de archivos sueltos, fecha de la decisión, CLAUDE.md)
   — puede ir al inicio de s15 o como tarea de cierre de s14 si Claude Code corre.
4. **P-DOC-RENDER** en sesión BIBLIOTECA dedicada (no mezclar con P-PALETA-v2).
- **Diferir:** `verificar_*.R` en raíz.
- **No reabrir el dato** (blindado) salvo que P-PALETA-v2 lo exija (no debería: es
  solo color de segmentos), y en ese caso con re-verificación de fidelidad.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El dato está verificado a nivel CENSO (s11) y la fidelidad parquet→sitio también
  (s12, re-confirmada en s14 con redondeo entero). NO re-auditar ni regenerar el
  parquet. md5 `4c764d8c…`.
- 🔒 El motor **desplegado** es el de PALETA (build `27679407…`, HEAD `1d41c17`).
  Los 6 commits de ajustes de motor (`b90ebd8`→`5a311de`) son **locales, NO
  desplegados** (camino A). NO pushearlos sueltos: v15 los consolida con
  P-PALETA-v2 y rehace la fase 3 antes de publicar.
- 🔒 Cualquier cambio de `35` (P-PALETA-v2 incluido) exige REGENERAR y RE-VERIFICAR
  fidelidad censal antes de desplegar. NO desplegar a ciegas.
- 🔒 **Identidad de indicador es regla:** todo lo cromático de un indicador (gráficos
  y stackeds de niveles) vive en su familia de color. NO introducir paleta semáforo
  ni colores ajenos a la familia del indicador.
- 🔒 D-s14-PALETA, D-s14-ENTERO, D-s14-EJE-FAMILIA están DECIDIDAS. No reabrir sin
  decisión explícita del titular.
- ⚠️ ANTES de implementar el stacked de niveles, PREGUNTAR al titular el sentido de
  la rampa (qué extremo es Alto). Es la única decisión de diseño abierta de
  P-PALETA-v2.
- ⚠️ La fase 3 (borde por dimensión) está RECHAZADA: se rehace como contenedor a
  escala de dimensión, no se conserva el border-left.
- ⚠️ NO inventar significancia/GSE/geo donde el dato trae NA (vigente desde v11).
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atómicos por ruta;
  nunca `git add .`/`-u`.
- 🔒 El backlog vive en `backlog_historico.md` (104 cambios, 1–104). Actualizarlo en
  CADA cierre; NO volver a diferir el conteo (A22/A14-3).

### Nota de cierre pendiente (deuda mecánica de s14, para ejecutar en Claude Code)
1. **Push consolidado** — NO ahora (camino A). Va en v15 tras rehacer fase 3.
2. **Commits de cierre de archivos sueltos** (revisar `git status` antes): la suite
   `50_documentacion/suite/`, la decisión de paleta, los encargos de s14 (paleta,
   motor — hoy untracked), los snapshots del escáner, `backlog_historico.md`, el
   `SETTINGS` editado (si corresponde a este repo). Commits atómicos temáticos.
3. **Corregir la fecha/sesión en
   `decisiones/20260622_decision_paleta_indicadores.md`** (dice s12, es s14).
4. **Actualizar `CLAUDE.md` "últimos cambios"** (arrastrado sin actualizar desde
   v12/v13): poner el resumen de s14 (paleta desplegada, ajustes de motor locales,
   suite, A22 cerrado).
5. **Commitear los logs de s14** si se decide versionarlos (hoy en disco; el de
   auditoría de decimales quedó sin commitear por ser solo lectura).

---

## 13. Fragmentos de código de referencia

**Re-verificación de fidelidad censal parquet→sitio (patrón P-DISPLAY-FIDELITY,
adaptado a redondeo entero):**
```r
# Decodificar el JSON embebido del build y contrastar contra round(parquet, 0).
# Para indicador/dimension: build$prom == round(parquet$prom, 0)
# Para niveles: build$bajo/medio/alto == round(parquet$niv_*_por, 0)
# Censo completo (no muestra); mismatch esperado = 0 salvo fantasma rbd=NA.
# El patrón completo vive en el encargo de display_fidelity (s12) y en
# 20260622_ajustes_motor_s14_log.md (§5, panel adversarial A).
```

**Derivar el primer año con dato sistémico por familia (columna correcta por
familia; NO usar `prom` para niveles):**
```r
primer_anio_familia <- list(
  indicador = min(dat$agno[dat$familia == "indicador" & !is.na(dat$prom)]),
  dimension = min(dat$agno[dat$familia == "dimension" & !is.na(dat$prom)]),
  # niveles: prom es NA siempre en esta familia → usar niv_bajo_por
  niveles   = min(dat$agno[dat$familia == "niveles"   & !is.na(dat$niv_bajo_por)])
)
# Esperado contra el dato: indicador 2014, dimension 2018, niveles 2023.
```

**Verificar que ningún elemento con `background = ind.color` lleva texto encima
(antes de decidir contraste de texto):**
```
# Enumeración de usos de la paleta de indicador en el template:
# swatches/dots (indp-dot, rcard-dot, th-sw, sw, leyenda <i>) → decorativos, vacíos.
# sbar-fill, ybar-fill → div vacío / valor en hermano position:absolute.
# .bar (StackedBar) → usa colores de NIVEL (--bajo/--medio/--alto), NO la paleta de
#   indicador → ESTA es la superficie de P-PALETA-v2 (semáforo a eliminar).
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 15 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  SETTINGS) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v14,
  el backlog histórico consolidado y el escáner actual. El motor con la PALETA del
  folleto está desplegado y certificado (HEAD `1d41c17`); los 6 commits de ajustes
  de motor de s14 están LOCALES sin desplegar (camino A). El parquet está blindado
  (md5 `4c764d8c…`). Foco: **P-PALETA-v2** — (1) stacked de niveles a tonalidades del
  color del indicador (eliminar semáforos; el sentido de la rampa lo defino al
  abrir), (2) rehacer el separador de dimensión como contenedor a escala (no el
  border-left rechazado), incluyendo en el mismo build los ajustes de s14 ya
  aprobados para un push consolidado. P-DOC-RENDER queda para una BIBLIOTECA
  dedicada."
- **Documentos para la sesión 15, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que
     esté al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según el foco:* `CLAUDE.md` (si corre en Claude Code);
     `encargo_autonomo_claude_code_v1.md` (habrá encargo en P-PALETA-v2);
     `35_generar_motor_html.R` + `35_motor_template.html` (**imprescindibles**:
     P-PALETA-v2 toca render — stacked de niveles y separador de dimensión);
     `idps_corpus_conceptual.md` (en la KB) si el foco vira a P-DOC.
  3. *Específicos de la sesión (SÍ se adjuntan):* `traspaso_cierre_v14.md`;
     `backlog_historico.md`; `estructura_actual.md`. La imagen de referencia de la
     paleta IDPS (folleto Agencia) y las capturas del titular de los stacked
     semáforo si se trabaja P-PALETA-v2. El parquet se lee del repo, no se adjunta.
- **Nota final:** si `35_generar_motor_html.R` o `35_motor_template.html` cambian
  entre sesiones (probable, dado el cierre mecánico pendiente), adjuntar la versión
  más reciente y avisarlo en la apertura. Si el cierre mecánico de s14 (commits,
  fecha de decisión, CLAUDE.md) se ejecutó, decirlo en el mensaje de apertura.
