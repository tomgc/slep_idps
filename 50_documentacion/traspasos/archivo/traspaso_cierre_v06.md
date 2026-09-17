# Traspaso de cierre v06 — slep_idps

> **Cierre intermedio.** La sesión 6 entregó un motor avanzado, auditado y
> rediseñado, pero **NO está publicado**: `docs/index.html` sigue en la versión
> previa a propósito. La revisión visual con Claude Design, la republicación y
> los ajustes que surjan quedan para la sesión 7. Este traspaso documenta todo lo
> hecho y deja el camino al cierre real.

---

## 1. Identificación

- **Proyecto:** slep_idps — motor nacional de Indicadores de Desarrollo Personal
  y Social (IDPS), Agencia de Calidad de la Educación. Dato por establecimiento,
  leído vs su GSE, sin agregación territorial.
- **Versión:** v06 (cierre intermedio).
- **Fecha:** 2026-06-20.
- **Sesión:** 6, en cuatro tramos. Foco: alcance + P-meta + evolución (tramo 1);
  navegación + foco + tildes + deploy (tramo 2); auditoría de datos + saneamiento
  (tramo 3); H6 + tildes subdim + pulido + rediseño visual (tramo 4).
- **Entorno:** R 4.5.x, Positron, macOS. Motor HTML autocontenido React 18 + D3
  v7 (Babel CDN), JSON→gzip→base64→pako inline.
- **Archivos principales modificados:** `10_utils/10_configuracion.R`,
  `30_procesamiento/33_construir_catalogos.R`, `30_procesamiento/35_generar_motor_html.R`,
  `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`,
  `40_salidas/intermedios/catalogo_idps.parquet`, `CLAUDE.md`.
- **Registro de ejecución detallado:**
  `50_documentacion/andamios/logs/20260619_sesion6_encargo2_log.md` (log de la
  sesión de Claude Code; el detalle paso a paso no se reproduce aquí).

---

## 2. Resumen ejecutivo

La sesión 6 transformó el motor de "producto desplegado con datos sospechosos" a
"producto auditado, saneado, enriquecido y rediseñado, listo para revisión
visual". Se acotó el motor a 4° básico / 2° medio, se agregaron definiciones
metodológicas contextuales (P-meta), evolución en 4 paneles con significancia
inter-anual leída de la Agencia, un selector de navegación con pestañas
(EntityModal: Región/Comuna/Dependencia/Establecimiento), foco de apertura en
SLEP Costa Central, y radar de dos años superpuestos. El hito central fue una
**auditoría exhaustiva de datos** (triple verificada) que confirmó que el "caos"
percibido era de presentación, no de medición: las cifras IDPS son 1:1 con el
crudo de la Agencia y los joins geográficos 100% correctos. Sobre ese veredicto
se aplicaron sólo saneamientos de presentación (nombres completos desde el
directorio, tildes, dependencia vigente H6) y un rediseño visual de piel hacia el
motor hermano `slep_categoria_desempeno`. Todo el trabajo de datos fue
`only=35`: `idps_largo.parquet` quedó con md5 idéntico de punta a punta, las
cifras intactas por construcción. Quedan pendientes para el cierre real: la
revisión visual del titular con Claude Design, la republicación de `docs/`, y
acentuar 45 definiciones largas que carecen de fuente verificable.

---

## 3. Estado al cierre

**Qué funciona** (verificado en navegador, 0 errores de consola, última corrida
2026-06-20):
- Motor completo en `40_salidas/motor_idps.html` (4.6 MB): grilla por
  establecimiento agrupada por GSE; detalle con doble ancla GSE (significancia
  explícita "· sig."/"· n.s."), radar de 4 indicadores con etiquetas de vértice
  (nombre + puntaje), radar de 2 años superpuestos, 4 paneles de evolución
  (eje fijo 0-100, marca dif/sigdif leída), drill-down indicador→dimensión→
  subdimensión, P-meta (definiciones contextuales).
- EntityModal con 4 pestañas, foco de apertura en Costa Central (60 EE en 4b
  2025), filtro Dependencia (4 categorías, con H6 aplicado).
- Rediseño visual de chrome aplicado (header, controles segmentados, modal)
  conservando azul gobCL + cream y la paleta de 4 indicadores intacta.

**Qué NO está publicado** (deliberado):
- `docs/index.html` sigue en la versión previa (4 grados, antes del rediseño).
  Diverge a propósito de `40_salidas/motor_idps.html`. La republicación espera la
  revisión visual.

**Delta respecto a v05:** v05 dejó el motor nacional desplegado (todo Chile, 4
grados, sin las mejoras de esta sesión). v06 acota a 4b/2m, audita y sanea los
datos de presentación, agrega P-meta / evolución 4 paneles / radar 2 años /
EntityModal / foco Costa Central / Dependencia vigente, y rediseña el chrome.

---

## 4. Registro detallado de cambios

Ver el log de ejecución (§1) para el detalle exhaustivo por commit. Resumen por
tramo (22 commits de sesión 6, todos en `origin`-pendiente de push salvo los del
tramo 2 ya pusheados en `cff962d`):

**Tramo 1** — `50400de` P-meta; `07ecc3c` alcance 4b/2m + ordinal + sin ALLCAPS;
`1e977ed` histórico de años agnóstico; `5918caf` evolución 4 paneles.

**Tramo 2** — `3f6b4c3` filtro dependencia; `bdfc876` significancia explícita
(a11y); `163e58b` EntityModal con pestañas; `0a9f505` foco Costa Central;
`f06ab95` tildes región; `cff962d` deploy a docs/ + escáner (este SÍ pusheado).

**Tramo 3** (saneamiento FASE II tras auditoría FASE I) — `ce2b11d` nombres+geo
desde directorio (H1/H2/H8); `116c678` tildes indicador/dimensión (H3/H4);
`667e690` rename Dependencia + blindaje pestaña (H5); `efdb785` GSE sin
numeración; `42ce2d3` radar etiquetado; `9147d5f` radar 2 años; `3d63705` leyenda
con definición; `dadbfdb` doc CLAUDE.md.

**Tramo 4** (Encargo 2) — `0a6d65c` H6 dependencia vigente; `1498873` tildes
subdimensión; `2a18b5c` pulido radar 2 años; `cdef681`/`09d912b`/`fb8405c`/
`de79ce0` los 4 commits style() de rediseño (piel, revertibles aparte).

---

## 5. Backlog acumulativo

> **Nota:** el backlog acumulativo completo (objetivo del proyecto, nota
> metodológica, clasificación temática, resumen por sesión y detalle cronológico
> con numeración global permanente) se mantiene en su forma extensa heredada de
> v05 y se **copia íntegro** desde el traspaso v05, agregando al final los cambios
> de la sesión 6. Aquí se registra el **delta** de esta sesión para incorporar al
> detalle cronológico; la próxima apertura debe reconstruir el backlog completo
> uniendo v05 + este delta (o consolidarlo en v06 al republicar).

**Delta sesión 6 (≈22 cambios nuevos, continuando la numeración global desde el
último de v05):**
- Alcance 4b/2m (filtro de presentación duro).
- P-meta: definiciones metodológicas contextuales en el drill-down.
- Histórico de años agnóstico (preliminar derivado del dato).
- Evolución en 4 paneles por indicador con significancia inter-anual leída.
- Filtro Dependencia (4 categorías de cod_depe2) reemplaza el filtro SLEP.
- Significancia explícita (sig./n.s.) en la doble ancla GSE (a11y).
- EntityModal con 4 pestañas reemplaza los selects de navegación.
- Foco de apertura en SLEP Costa Central (estado, no filtro fijo).
- Tildes correctas en NOMBRES_REGION.
- Saneamiento de nombres de comuna/EE desde el directorio (H1/H2) + backfill geo (H8).
- Tildes en nombres de indicador y dimensión (H3/H4).
- Rename Sostenedor→Dependencia + blindaje de la pestaña (H5).
- GSE sin numeración en etiquetas.
- Radar con etiquetas de vértice (nombre + puntaje).
- Radar de dos años superpuestos (detalle, nivel indicador).
- Leyenda con definición de indicador accesible (hover + teclado).
- H6: dependencia vigente del directorio (118 EE Municipal→SLEP).
- Tildes en nombres de subdimensión (22 EST).
- Pulido funcional del radar de 2 años.
- Rediseño visual de chrome (densidad, header, controles, modal) hacia la
  referencia, conservando identidad IDPS y paleta de indicadores.

**Categoría temática nueva dominante en esta sesión:** Saneamiento/calidad de
datos de presentación (auditoría FASE I + correcciones H1-H8) y Rediseño visual.

---

## 6. Bugs de la sesión (causa raíz + regla aprendida)

1. **Nombres truncados (H1/H2).** Síntoma: comunas/EE cortados ("Curaco de Vél").
   Causa raíz: el export de la Agencia trunca `nom_com_rbd`/`nom_rbd` de forma
   inconsistente entre archivos; el motor serializaba esa copia de `idps_largo`
   ignorando el directorio que sí los tiene completos. Fix: directorio público
   como autoridad de etiqueta+geo, por RBD character (`ce2b11d`). **Regla:** para
   atributos de presentación (nombre, geo, dependencia), la autoridad es el
   directorio oficial, no la copia heredada en `idps_largo`.
2. **51 EE con geo NULL invisibles (H8).** Causa raíz: `idps_largo` trae geo NA
   para algunos RBD; sin `cod_com`/`cod_reg` no caen en ningún filtro territorial
   y su buscador los saltaba (si además `nom` era nulo). Fix: backfill de geo +
   nombre desde el directorio (cobertura 100%); geo NA 51→0. **Regla:** todo
   atributo que filtra o busca debe tener cobertura garantizada; verificar NA en
   llaves de navegación.
3. **Delta H6.** Causa raíz: la homologación canónica usa la dependencia del año
   de evaluación, previa al traspaso 2025. Fix (decisión titular): dependencia
   actual del directorio (`0a6d65c`); 118 Municipal→SLEP, cifras byte-idénticas.
   **Regla:** la vigencia de un atributo administrativo es una decisión explícita
   del titular, no un default; documentarla.
4. **Pestaña Dependencia "contaminada" (H5) — refutado.** El dato ya estaba limpio
   (`cod_depe2 ∈ {1,2,3,4}`); la captura era previa al refactor EntityModal. Se
   blindó igual (defensa en profundidad). **Regla:** verificar el síntoma contra
   el estado actual del código antes de asumir un bug; una captura puede ser
   stale.

**Fricciones técnicas (no bugs de datos):** locale C en Rscript da falsos
negativos en comparaciones con literales acentuados (verificar por bytes);
screenshots en blanco por restauración de scroll headless; estado asíncrono de
React en las verificaciones (separar click y lectura en evals distintos).

---

## 7. Decisiones de diseño

1. **Capa de corrección = presentación (`only=35`), no pipeline.** Todos los
   saneamientos (nombres, geo, dependencia, tildes) se aplican al serializar, no
   en `34`. Alternativa descartada: corregir en el pipeline (regeneraría
   `idps_largo`). Justificación: garantiza cifras byte-idénticas por construcción;
   `idps_largo` se mantiene fiel al crudo de la Agencia.
2. **Vigencia de dependencia = actual del directorio (H6).** Un EE traspasado
   aparece como SLEP aunque fuera evaluado siendo Municipal. Aplica nacionalmente,
   no sólo a Costa Central. Reversible (capa de presentación).
3. **Rediseño = sólo chrome.** Adopta estructura/patrones de la referencia
   (`slep_categoria_desempeno`) conservando azul gobCL + cream y la paleta de 4
   indicadores intacta (es codificación de dato). Coral de la referencia evitado
   (colisiona con `--bajo`). Rótulo de grado, no de nivel.
4. **45 definiciones largas sin acentuar.** No se acentúan a ciegas (riesgo
   ortográfico sin fuente verificable). Pendiente para fuente del titular.

---

## 8. Constantes y parámetros vigentes (nuevos/cambiados esta sesión)

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `GRADOS_MOTOR` | `c("4b","2m")` | `10_configuracion.R` | Filtro de presentación; parquet conserva 4 grados |
| `CW_DEPE_DIRECTORIO_A_IDPS` | `c("1"="1","2"="2","3"="3","4"="2","5"="4")` | `10_configuracion.R` | Homologa 5-cat dir → 4-cat IDPS (H6) |
| `INDICADOR_LABELS`/`DIMENSION_LABELS`/`SUBDIMENSION_LABELS` | acentuados | `10_configuracion.R` | Override de presentación; corpus sigue ASCII |
| `NOMBRES_REGION` | nombres oficiales con tildes | `10_configuracion.R` | UTF-8 forzado al serializar |
| Paleta indicadores | `#EE2D49 #FFC92E #9BC93E #2A8FD9` | template | 🔒 codificación de dato, intacta |

---

## 9. Arquitectura de archivos

Escáner al cierre: `50_documentacion/estructura/estructura_actual.md`
(2026-06-20, 23 carpetas / 132 archivos). Novedades estructurales de la sesión:
`andamios/diseno/entity_modal/` (componente portado), `andamios/logs/` (log de
ejecución de esta sesión). Estructura conforme a la política (Rama A).

---

## 10. Pendientes y ruta sugerida (sesión 7)

| # | Pendiente | Tipo | Complejidad | Criterio de éxito |
|---|---|---|---|---|
| P1 | Revisión visual del rediseño con Claude Design (grilla + detalle + responsive) | mejora visual | — (del titular) | El titular aprueba o lista ajustes concretos |
| P2 | Aplicar ajustes visuales aprobados | feature visual | según P1 | Cambios aprobados, invariantes 🔒 intactos, 0 errores consola |
| P3 | **45 definiciones largas sin acentuar** | deuda de datos | Media | Titular provee fuente acentuada; aplicar con verificación por bytes + P-meta 1:1 |
| P4 | Republicar `docs/` (= `motor_idps.html`) + escáner | cierre | Baja | `docs/index.html` == `motor_idps.html`; push; Pages sirve la nueva versión |
| P5 | Versionar lo pendiente (log, andamio entity_modal, encargos) | higiene git | Baja | `git status` limpio salvo `.claude/` |
| P6 | Traspaso v07 (cierre real, con backlog consolidado v05+v06) | cierre | Baja | Backlog íntegro renumerado; reapertura con valores reales |

**Ruta sugerida sesión 7:** P1 (revisión visual) → P2 (ajustes) → P3 si el titular
trae las definiciones → P5 (higiene) → P4 (republicar) → P6 (cierre v07). La
republicación va al final para publicar una sola vez con todo aprobado.

**Auditoría de cierre (5.6):** las cifras son reproducibles e idempotentes
(verificado md5 + byte a byte); decisiones metodológicas como constantes
nombradas (sí: `GRADOS_MOTOR`, `CW_DEPE_*`); nombres sin tildes/ñ en archivos (sí).
Sin respuestas "no" que generen pendiente nuevo.

---

## 11. Instrucciones específicas para la próxima sesión

- 🔒 La **paleta de 4 indicadores** es codificación de dato. Ningún ajuste visual
  la recolorea ni la re-mapea.
- 🔒 **Cero agregación.** Cualquier futura "comparación de territorios" NO promedia
  entre establecimientos (el motor hermano compara categorías de desempeño, otra
  métrica, no promedios IDPS).
- ✅ ANTES de republicar `docs/`: confirmar `docs/index.html` == `motor_idps.html`
  (hoy divergen a propósito).
- ✅ ANTES de aplicar definiciones acentuadas: verificar por bytes (locale C da
  falsos negativos) y confirmar P-meta 1:1.
- ⚠️ NO regenerar `idps_largo` por un cambio de presentación: usar `only=35`. Si
  algo exige tocar `34`, es decisión de datos, no de presentación.
- ⚠️ El **mapeo 5→4 de dependencia** (Adm. Delegada→Part. subv.) es criterio de la
  Agencia; revisarlo contra glosas si se cuestiona.

---

## 12. Reapertura

- **Nombre del chat:** `slep_idps, sesión 7 (Claude Opus 4.8)`
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  settings) vive en la knowledge base del Project y en `50_documentacion/activa/`;
  léelo desde ahí. Sesión 6 cerró con v06 (cierre intermedio): motor avanzado,
  auditado y rediseñado en `40_salidas/motor_idps.html`, pero `docs/` NO
  republicado (espera revisión visual). El foco de la sesión 7 es: incorporar los
  ajustes de la revisión visual con Claude Design, acentuar definiciones si aporto
  la fuente, y cerrar de verdad (republicar docs/ + traspaso v07). Adjunto el
  traspaso v06 y el escáner re-corrido."
- **Documentos para la sesión 7:**
  1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`,
     `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, y el nuevo
     `encargo_autonomo_claude_code_v1.md` (instrumento de encargos a Claude Code).
  2. *Opcionales según foco:* `CLAUDE.md` si corre en Claude Code; el log de
     ejecución `andamios/logs/20260619_sesion6_encargo2_log.md` si se necesita el
     detalle del rediseño.
  3. *Específicos de la sesión (se adjuntan):* este traspaso v06; el escáner
     `estructura_actual.md`; `35_motor_template.html` y `35_generar_motor_html.R`
     si se itera la UI; las definiciones acentuadas si el titular las aporta (P3).
- **Nota final:** si algún archivo cambió entre sesiones, adjuntar la versión más
  actualizada al abrir y avisarlo.

---
*Fin del traspaso v06 — cierre intermedio de la sesión 6.*
