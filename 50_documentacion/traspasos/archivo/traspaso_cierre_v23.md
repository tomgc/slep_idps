# Traspaso de cierre v23 — slep_idps

## 1. Identificación

- **Proyecto:** `slep_idps` (motor interactivo de IDPS, React 18 + D3 v7 inline, GitHub Pages).
- **Versión:** v23.
- **Fecha:** 2026-06-24.
- **Sesión 23.** Foco: consolidar y publicar el lote de presentación de s22 que había quedado sin commitear; regenerar la suite de documentación; cerrar la higiene del template (código muerto) y Batch C (#5/#8 + eliminación de un rótulo).
- **Entorno:** macOS aarch64, R 4.5.x, Positron, zsh, GitHub Pages (público).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html`, `30_procesamiento/35_generar_motor_html.R`, `40_salidas/motor_idps.html`, `docs/index.html`. Generados (no versionados): 4 `*_standalone.html` de la suite. Modificado sin commitear: `50_documentacion/suite/documentar.R`.

## 2. Resumen ejecutivo

La sesión abrió con el repo en un estado cargado: todo el trabajo de presentación de s22 (Batch A ya commiteado localmente; Batch B1/B2 en el working tree) sin publicar, y la suite de documentación editada sin regenerar. Se ordenó y publicó P-COMMIT-DEPLOY-S22: los ítems #138/#139/#140/#141 quedaron en commits atómicos separados (vía `git add -p` por hunks, hecho manualmente por terminal a pedido del titular), más el build y el deploy; `origin/main` pasó de `41a3406` (s21) a `d35027a`. Se regeneró la suite de documentación (P-DOC-REGEN), verificada 100% offline, pero se detectó que su `cfg` contiene contenido cruzado de `slep_simce_adecuado` (nuevo pendiente P-DOC-CFG-CRUZADA). Luego, vía un encargo autónomo a Claude Code, se cerró la higiene del template (eliminación del componente muerto `PanelEvolucion` y corrección de un comentario obsoleto de `ScoreBar`) y Batch C (#5 anclas del indicador en una fila, #8 etiquetas del radar sin colisión, más la eliminación del rótulo "Mirada integral · 4 indicadores"). `origin/main` quedó en `33ea07a`. Todo el trabajo de motor de s22 y s23 está desplegado. Quedan pendientes de documentación (cfg cruzada, CSS muerto) y los pendientes de fondo heredados (IDPS histórico, slepverse, P-GITIGNORE-TOKEN, Ítem 11).

## 3. Estado al cierre

**Qué funciona (última ejecución exitosa: 2026-06-24, deploy `33ea07a`):**
- Motor `motor_idps.html` desplegado en `docs/index.html`, con todos los ajustes de s22 (#138–#141) y s23 (#5/#8, higiene). Build regenerado con `run_all(only=35)`.
- Suite de documentación regenerada en 4 `*_standalone.html`, verificada offline (0 referencias de red).
- `origin/main = 33ea07a`; rama local al día.

**Qué no funciona / deuda observable:**
- La suite publicable contiene glosas de `slep_simce_adecuado` en su `cfg` (P-DOC-CFG-CRUZADA): la doc generada muestra contenido de otro proyecto. No es un fallo de ejecución sino de contenido de la `cfg`.
- CSS muerto `.evol-*` y `.fr-head` huérfanos en el template tras eliminar PanelEvolucion y el rótulo "Mirada integral".

**Delta respecto a v22:**
- `origin/main`: `41a3406` (s21) → `d35027a` (s22 publicado) → `33ea07a` (s23 higiene + Batch C).
- Todo lo que en v22 estaba "sin commitear" quedó publicado.
- Suite regenerada (antes negaba el polígono GSE; ahora actualizada, salvo la cfg cruzada).

## 4. Registro detallado de cambios

### P-COMMIT-DEPLOY-S22 (por terminal, manual, `git add -p`)
Los hunks de #138/#139/#140/#141 convivían entremezclados en `35_motor_template.html`; se separaron por hunk. #141 además tocaba `35_generar_motor_html.R`. Commits (sobre `3cf666c`, cierre de Batch A):
- `7b9c968` style(motor): color estado sin-diferencia gris-azulado (#138). Token `--st-neutro` `#8C8A86`→`#7E8A99`, para separarlo del `--gris` de UI manteniendo el punto medio del eje rojo→neutro→azul.
- `bd2829a` feat(motor): señalética de significancia temporal en barras del histórico (#139). Glifo triángulo/igual junto a cada puntaje de `BarrasAnio`; dirección por signo de `dif`, color por `sig` (clases de/al/nt). Lee `sigdif` temporal (vs evaluación anterior), no `sigdifgru`. Primera barra sin glifo.
- `6512c91` feat(motor): etiqueta externa para segmentos finos del comparador (#140). Tira `.s100-ext` bajo la barra apilada del `StackedBar` para segmentos <9% que no caben dentro.
- `2ac714c` feat(motor): texto editorial "qué refleja un puntaje alto" por indicador (#141). Constante `INDICADOR_NIVEL_ALTO` (4 textos derivados del corpus, nivel indicador) en el generador + campo `nivel_alto` en `indicadores_lst`; colapsable `<details className="indp-alto">` en la tarjeta del indicador, nivel INDICADOR (0 disclosures en dim/subdim).
- `9511235` build(motor): regenera `motor_idps.html` con el lote s22.
- `f738df8` docs(s22): encargos y logs de los batches A/B1/B2.
- `d35027a` deploy(docs): publica el lote s22 en GitHub Pages.

Verificación central (R-PAYLOAD-DELTA): baseline = build de `origin/main` s21 (sin `nivel_alto`, mismo parquet); el único delta del payload de todo el lote s22 fue la aparición de `nivel_alto` en los 4 indicadores; ninguna cifra cambió. Parquet md5 `4c764d8c…` intacto.

### P-DOC-REGEN-S22 (por terminal, titular)
Regeneración de la suite con `source("50_documentacion/suite/documentar.R")`. Produjo los 4 HTML enlazados + 4 `*_standalone.html`. Los 50+ warnings de `Rscript` son benignos (`US-ASCII to UTF-8, but is valid UTF-8`: el texto es UTF-8 válido, R solo avisa del locale). Verificación offline: `grep` de referencias de red en los 4 standalone = 0. Versionado diferido (ver §8 y decisión DEC-s23-3).

### Higiene del template (Claude Code autónomo, fase 1)
- `8e55c8d` refactor(motor): elimina `PanelEvolucion` (componente huérfano desde P3-s9). Confirmado huérfano (0 invocaciones `<PanelEvolucion`); eliminada la definición completa (~42 líneas) + 3 menciones residuales en comentarios. Llaves balanceadas, build OK. Era el único otro consumidor de `.axis-lab.b` (ahora solo el radar).
- `5aaa761` docs(motor): corrige comentario obsoleto de `ScoreBar` (coherente con D7). El comentario (JS + gemelo CSS de `.sbar`) negaba que el promedio absoluto del GSE existiera ("derivarlo viola lee-no-deriva"); desde D7 la cifra GSE es pública y reconstruida. Reescrito para reflejar que ScoreBar omite la marca GSE por elección de diseño, no por prohibición. Solo comentarios.

### Batch C — #5/#8 + eliminación de rótulo (Claude Code autónomo, fase 2, con gate visual del titular)
- `cb004d3` style(motor): anclas del indicador en una fila + etiquetas del radar sin colisión (#5/#8). También elimina el rótulo "Mirada integral · 4 indicadores".
- `2c2ed51` build(motor): regenera con higiene template + #5/#8.
- `33ea07a` deploy(docs): publica higiene template + #5/#8.

Detalle #5 (anclas del indicador en una sola fila): el objetivo del titular era que las dos anclas ("vs su GSE …" y "vs año anterior …") entren LADO A LADO en una fila, no apiladas. Enfoque aprobado: ensanchar la tarjeta. La clase real es `.rcard-anc` (las 4 tarjetas que rodean el radar), no `.indp-anc` (que ya entraba en una fila) — corregido por medición. La iteración 1 (subir `.rcard max-width` 280→330) fue insuficiente: a viewports más angostos que 1280 las tarjetas laterales (columnas `minmax(0,1fr)`) encogían bajo el umbral. Solución final: columnas laterales a `minmax(320px,1fr)` (no encogen bajo el ancho que necesitan las 2 anclas) + breakpoint de colapso a 1 columna subido a `@media(max-width:1180px)` (salta la banda de 2 filas). Valores finales: `.rquad` columnas `minmax(320px,1fr) auto minmax(320px,1fr)`, `gap:10px 50px`, `max-width:1100px`; `.rcard max-width:330px`. Verificado en barrido 1280→900: las 4 tarjetas en 1 fila en todo el rango.

Detalle #8 (etiquetas de eje del radar): NO era recorte por viewBox sino COLISIÓN: "Convivencia" (la etiqueta más larga, derecha) invadía la tarjeta lateral 19px (las tarjetas van `justify-self:start`, pegadas al radar). Solución: subir el `column-gap` de `.rquad` (16→50px) para alejar las laterales. Resultado: Convivencia libra por 30px, Hábitos por 53px. El SVG sigue 300×300 (polígono y vértices sin tocar).

Eliminación del rótulo "Mirada integral · 4 indicadores": borrado el `<div className="fr-head">` completo a pedido del titular (no aportaba). `.fr-head` queda huérfana en CSS.

Verificación: payload byte-idéntico en cada regeneración; parquet intacto; 0 errores de consola.

## 5. Backlog acumulativo

> **Nota de gobernanza del backlog (A22):** el archivo maestro `50_documentacion/activa/backlog_historico.md` debe consolidarse a v23 con las entradas nuevas de esta sesión. Esta sesión publicó los ítems #138–#141 (ya estaban en el backlog desde s22 como entradas, faltaba su commit/deploy) y cerró #5/#8 más PanelEvolucion/ScoreBar/eliminación de rótulo. Verificar el conteo correlativo contra el detalle cronológico, no contra la tabla temática heredada. **Primera acción recomendada de s24: cuadrar `backlog_historico.md` a v23.**

Entradas conceptuales nuevas de s23 (asignar correlativo al consolidar):
- Publicación del lote s22 (#138–#141): ordenamiento por hunks y deploy. (No son ítems nuevos; es la publicación de ítems ya numerados.)
- Eliminación de `PanelEvolucion` (código muerto).
- Corrección del comentario obsoleto de `ScoreBar` (coherencia con D7).
- #5: anclas del indicador en una fila (ensanche de `.rcard` + min-width de columnas + breakpoint).
- #8: etiquetas del radar sin colisión (column-gap).
- Eliminación del rótulo "Mirada integral · 4 indicadores".
- Regeneración de la suite de documentación (P-DOC-REGEN).

## 6. Bugs de la sesión

Ninguno nuevo en producción. Dos correcciones de proceso dignas de registro:

- **Iteración fallida de #5 (no es bug de producto, es de diagnóstico):** la iteración 1 ensanchó solo `.rcard max-width`, insuficiente porque el límite real lo imponía la columna `1fr` del grid, no el `max-width`. **Regla aprendida:** en grids, cuando un hijo se envuelve, medir si el límite viene del `max-width` del hijo o del ancho de la columna (`1fr` encoge con el viewport); subir el `max-width` no ayuda si la columna es la que aprieta. **Verificar a varios viewports, no solo al ancho de desarrollo (1280).**
- **Supuesto de clase erróneo en el encargo (#5):** el encargo nombró `.indp-anc`, pero la clase real era `.rcard-anc`. Claude Code lo corrigió por medición antes de actuar (R9). El error fue de redacción del encargo, atrapado por verificación.

## 7. Aprendizajes y restricciones descubiertas

- **R-GRID-VIEWPORT:** una pieza que "entra en una fila" a 1280px puede envolverse a anchos menores si vive en una columna `minmax(0,1fr)`. Para forzar una fila en todo el rango: dar `min-width` a la columna (`minmax(Npx,1fr)`) y/o subir el breakpoint de colapso. Verificar siempre en barrido de viewports.
- **R-PAYLOAD-DELTA (confirmado de nuevo):** para auditar que un cambio solo-template no toca cifras, comparar el payload descomprimido (base64→gzip→JSON) contra un baseline real (el build de `origin/main` previo), no contra el working tree. Byte-identidad excluyendo el delta esperado.
- **Suite standalone offline:** la regeneración produce 4 `*_standalone.html` que están **ignorados por `.gitignore`** (verificado con `git check-ignore`); el tema viaja embebido. Lo único versionable de la suite es `documentar.R` + `suite_estilos.css`. No intentar versionar los standalone.
- **Warnings `US-ASCII to UTF-8` en `documentar.R`:** benignos (el texto es UTF-8 válido). No son un defecto; expusieron de paso el contenido cruzado de SIMCE (ver P-DOC-CFG-CRUZADA).

## 8. Decisiones de diseño

- **DEC-s23-1 (commits atómicos del lote s22):** se commitearon #138/#139/#140/#141 como cuatro commits separados (no dos por batch), por simetría con Batch A y porque el backlog los trata como cambios conceptualmente independientes. Alternativa descartada: agrupar por batch (menos trazable). Por terminal con `git add -p` a pedido del titular (ahorro de tokens vs encargo a Claude Code).
- **DEC-s23-2 (#5 vía ensanche de tarjeta, no compactar anclas):** aprobada por el titular. Alternativas descartadas: compactar/acortar anclas (perdía legibilidad), `flex-nowrap` (riesgo de desborde). Implicancia: layout central más ancho (`.rquad` 1100), controlado con breakpoint a 1180.
- **DEC-s23-3 (versionado de la suite diferido):** `documentar.R` quedó modificado sin commitear porque contiene la `cfg` cruzada (P-DOC-CFG-CRUZADA); commitearlo ahora versionaría contenido de otro proyecto. Se difiere hasta sanear la cfg. Los standalone están ignorados; el CSS ya está al día. Implicancia: P-DOC-REGEN queda "regenerado y verificado offline localmente", sin versionar su fuente.

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `--st-neutro` | `#7E8A99` | template | cambiado en #138 (era `#8C8A86`) |
| `.rquad` columnas | `minmax(320px,1fr) auto minmax(320px,1fr)` | template | #5 (s23) |
| `.rquad` gap | `10px 50px` | template | column-gap 50 por #8 |
| `.rquad` max-width | `1100px` | template | #5/#8 (era 880) |
| `.rcard` max-width | `330px` | template | #5 (era 280) |
| breakpoint colapso `.rquad` | `@media(max-width:1180px)` | template | #5 (era 760) |
| `idps_largo.parquet` md5 | `4c764d8c9f0bf70004f8aa52661ae901` | 40_salidas/intermedios | 🔒 inmutable, 2.362.447 filas |

## 10. Arquitectura de archivos

Escáner al cierre: `50_documentacion/estructura/estructura_actual.md` (2026-06-24 20:43; 31 carpetas, 273 archivos). Estructura conforme a la política (decenas, naming, ubicación). Sin desviaciones nuevas. El último traspaso en disco es `traspaso_cierre_v22.md`; este v23 es el correlativo siguiente.

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-DOC-CFG-CRUZADA** (documentación / deuda de contenido) — NUEVO
- **Descripción:** el `documentar.R` de slep_idps (`50_documentacion/suite/documentar.R`) contiene en su `cfg` prosa y glosas de `slep_simce_adecuado`, no de IDPS. Strings detectados vía los warnings de codificación al regenerar la suite: `simce_rbd`, `simce_comunal.parquet`, `palu_eda_ade`, `nalu`/`palu`, ponderación SIMCE por matrícula, `motor_comparacion.html (~14,2 MB)`, agregación territorial comuna/SLEP/región, y anomalías de SIMCE (sufijo `_2m_`/`_4b_` en 2018 4° básico, `marca_eda_*` solo 2014, `cod_com_rbd` corrupto, remapeo de Ñuble). Nada de eso es de IDPS.
- **Causa probable:** el `documentar.R` se derivó copiando el de `slep_simce_adecuado` sin sustituir todas las zonas de la `cfg` (antipatrón que la regla 4.6.3.1 del SETTINGS advierte).
- **Riesgo:** los documentos generales de la suite se publican; publicar glosas de SIMCE en la doc de IDPS es contenido falso (R-DOC-1: la doc no solo envejece, miente) y mezcla universos. Verificar además que ningún string cruzado arrastre nombres reales de EE/RBD.
- **Tipo:** documentación. **Complejidad:** Media. **Dependencias:** ninguna técnica; requiere leer `documentar.R` completo y contrastar cada bloque de `cfg` contra el corpus real de IDPS (`idps_corpus_conceptual.md`) y las decisiones de IDPS.
- **Precauciones:** no asumir que solo lo que apareció en los warnings está cruzado (el warning solo muestra strings con acentos; puede haber residuo ASCII puro). Auditar la `cfg` entera. No regenerar como "correcta" hasta sanear. `verificar=FALSE` está activo en IDPS y no atrapa esto.
- **Enfoque sugerido:** (1) leer `documentar.R` completo; (2) marcar cada campo de `cfg` IDPS/cruzado/genérico; (3) reescribir los cruzados desde el corpus y las decisiones reales; (4) regenerar; (5) re-verificar offline y `grep -i 'simce\|nalu\|palu\|adecuado'` en los 4 HTML = 0.
- **Criterio de éxito:** `grep` de términos de SIMCE en los 4 `*_standalone.html` = 0; cada bloque de `cfg` trazable a una fuente de IDPS; suite regenerada y offline. Tras sanear, commitear `documentar.R` (cierra DEC-s23-3).

**P-CSS-MUERTO** (higiene / deuda técnica) — NUEVO
- **Descripción:** quedaron huérfanas las reglas CSS `.evol-*` (`.evol-panel/.evol-h/.evol-sw/.evol-marks/.evol-mark/.evol-sig` y `.hist-main .evol-panel`) tras eliminar `PanelEvolucion`, y `.fr-head` tras eliminar el rótulo "Mirada integral".
- **Precaución:** NO tocar `.arr` (compartida con `Ancla`, viva). **Complejidad:** Baja. **Enfoque:** un commit de higiene CSS aparte (`style(motor): elimina CSS muerto .evol-*/.fr-head`), regenerar build, verificar payload byte-idéntico.

**Heredados de v22 (siguen abiertos):**
- **P-GITIGNORE-TOKEN:** el patrón `*token*` en `.gitignore` es demasiado amplio para un proyecto que usa tokens CSS. Revisar y acotar. Tipo: deuda. Complejidad: Baja.
- **Ítem 11** (lista de EE por segmento): requiere el repo hermano. Bloqueado por dependencia externa.
- **IDPS histórico 2014–2019** (sesión de datos dedicada): extender `34_leer_normalizar_idps.R`; el `PATRON_DATOS` actual solo soporta 2022–2025. Los archivos históricos ya están en el repo bajo `20_insumos/historico/` (familia `rbd` + glosas; ver escáner). **Nota nueva del escáner:** los históricos ya NO están solo en `/Users/tomgc/Desktop/idps`; fueron incorporados a `20_insumos/historico/` (años 2014–2019, familias 2m/4b/6b/8b según año, todos `rbd`, sin `dim`/`niveles` salvo donde exista). Decisión pendiente sobre años con solo familia `rbd`. Inspeccionar un xlsx por época antes de tocar el pipeline. Existe `40_salidas/intermedios/diagnostico_historico_idps.md` e `inventario_historico_idps.parquet` de trabajo previo.
- **P-SLEPVERSE:** paquete R de tooling compartido; sesión estratégica dedicada.
- **Master dashboard:** diferido por el titular; no revisar.

### Auditoría de cierre (política 5.6)
- ¿Outputs reproducibles e idempotentes? → Sí (`run_all(only=35)` regenera el motor; payload byte-idéntico verificado).
- ¿Decisiones metodológicas como constantes nombradas? → Sí (constantes del template; `INDICADOR_NIVEL_ALTO` en el generador).
- ¿Nombres sin tildes/ñ/espacios? → Sí en lo nuevo. (Persisten archivos heredados con espacios en `andamios/diseno/` — `Motor IDPS.html`, `Handout IDPS.html`, etc.; deuda heredada en zona de andamios congelados, no se renombra.)
- **Respuesta "no" → pendiente:** `documentar.R` sin commitear (DEC-s23-3, ligado a P-DOC-CFG-CRUZADA); CSS muerto (P-CSS-MUERTO).

### Ruta sugerida para s24 (orden)
1. **Cuadrar `backlog_historico.md` a v23** (A22; primera acción, administrativa).
2. **P-CSS-MUERTO** (baja complejidad, cierra deuda recién creada, deja el template limpio).
3. **P-DOC-CFG-CRUZADA** (sanear la cfg, regenerar, verificar, y entonces commitear `documentar.R` cerrando DEC-s23-3). Sesión de documentación; puede ir junta con (2) si hay tiempo, pero son cambios conceptuales distintos (commits separados).
4. Diferir a sesiones dedicadas: IDPS histórico, P-SLEPVERSE, P-GITIGNORE-TOKEN, Ítem 11.

## 12. Instrucciones específicas para la próxima sesión

- 🔒 `idps_largo.parquet` (md5 `4c764d8c…`) intocable. Cambios solo vía `only=35` no lo tocan.
- 🔒 D7 vigente: el polígono GSE de referencia se dibuja (cifra pública reconstruida `prom - difgru`). Todo texto/comentario que lo niegue es residuo.
- ⚠️ NO commitear `documentar.R` hasta sanear P-DOC-CFG-CRUZADA (versionaría contenido de otro proyecto).
- ⚠️ NO `git add .` — siempre path-scoped, commits atómicos por tema.
- ⚠️ NO push ni deploy a `docs/` sin gate explícito del titular y aprobación visual del build local.
- ✅ ANTES de tocar el template, releer las zonas por CONTENIDO, no por número de línea (las líneas se mueven cada sesión).
- ✅ ANTES de cualquier commit, leer el estado real (`git status`, `git diff`, `git ls-files`); nunca asumir qué entra al diff.
- ✅ Verificar cambios CSS de layout en barrido de viewports, no solo a 1280 (R-GRID-VIEWPORT).
- 🔒 Los 4 `*_standalone.html` están ignorados por diseño; no intentar versionarlos.

## 13. Fragmentos de código de referencia

Regenerar el motor (no toca parquet, no recorre 31–34):
```r
# desde la raíz del proyecto
setwd("/Users/tomgc/Projects/slep_idps")
source("00_build.R"); run_all(only = 35)
```

Regenerar la suite de documentación (standalone offline; requiere npm + red en tiempo de generación):
```r
setwd("/Users/tomgc/Projects/slep_idps")
source("50_documentacion/suite/documentar.R")
```

Auditar payload byte-idéntico tras un cambio solo-template (baseline = build previo de origin/main):
```r
# extrae el JSON embebido (atob -> base64_dec -> gunzip), compara contra baseline con cmp
```

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 24 (Claude Opus 4.8)`.
- **Mensaje de apertura pre-armado:** «Tipo CONTINUATION de slep_idps. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md + DISCIPLINA_OPERATIVA.md) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v23 y el escáner. Estado: motor s22+s23 desplegado (`origin/main = 33ea07a`). Foco propuesto: (1) cuadrar `backlog_historico.md` a v23; (2) P-CSS-MUERTO; (3) P-DOC-CFG-CRUZADA (sanear la cfg de `documentar.R`, regenerar, y commitearlo cerrando DEC-s23-3).»
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO se adjuntan; verificar que estén al día):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `DISCIPLINA_OPERATIVA.md`.
  2. *Opcionales según foco:* `CLAUDE.md` si correrá en Claude Code; `idps_corpus_conceptual.md` (fuente para sanear P-DOC-CFG-CRUZADA).
  3. *Específicos (SÍ se adjuntan):* `traspaso_cierre_v23.md`; `estructura_actual.md`; para P-DOC-CFG-CRUZADA, `50_documentacion/suite/documentar.R`.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más reciente y avisarlo en la apertura.
