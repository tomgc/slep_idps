# Encargo autónomo a Claude Code — Correcciones de la revisión del titular (s29i)

> Proyecto: `slep_idps`. Sesión s29 (CONTINUATION), noveno encargo (s29i).
> Reúne los cuatro hallazgos de la revisión que el titular hizo sobre el motor
> publicado el 2026-09-16. La exportación tipo `slep_simce_adecuado` **no** entra
> aquí: es funcionalidad nueva y va en su propio encargo.

---

## 0bis. Insumos (contexto frío)

1. `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` — log de
   la sesión; §8.2 trae la convención de normalización del payload.
2. `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`.
3. `CLAUDE.md` y `50_documentacion/activa/POLITICA_PROYECTO.md` — en particular la regla
   de mayúsculas del proyecto (§4 de este encargo).
4. **Referencia vinculante para cualquier duda de interfaz:**
   `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`.

**Gate:** el titular revisó el motor publicado y pidió estas correcciones. La Fase 6
redespliega y publica.

---

## 1. Contrato

- Modo autónomo secuencial, commit atómico por fase, `git add` a rutas exactas, rutas
  absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención:**
  1. Si cualquier fase exigiera tocar el pipeline (31–34), `idps_largo.parquet` o
     producir una cifra agregada por territorio: detente.
  2. Si cambia cualquier cifra del payload: detente (diff de offsets; hash §8.2).
  3. Si el build falla o emite un warning nuevo: detente.
  4. Si `docs/index.html` no queda byte-idéntico al motor: detente.

---

## 2. Fase 1 — La entidad nacional también en el panorama territorial (commit `feat`)

**Hallazgo:** "Chile" solo existe en el comparador. El picker de Territorio del panorama
(`TABS`, línea ~1430: Comuna · SLEP · Región · Dependencia · Establecimiento) no lo
ofrece.

1. Añade el tab **Nacional** a `TABS`, en la misma posición relativa que en `TABS_CMP`
   (después de Región). `buildList` devuelve `[NACIONAL_OPT]` en ese tab, igual que
   `buildListCmp`.
2. `onPick` acepta `kind === "nacional"` y hace `setTerr({kind:"nacional",cod:"CL"})`.
3. `unidades` (el roster del panorama, ~línea 1770) gana la rama `nacional`, que **no
   filtra**, igual que `rosterTerr`. El filtro de dependencia y el de GSE siguen
   aplicando.
4. El banner muestra "Chile" con su meta (comunas y establecimientos del roster real
   del nivel y año, no del directorio).

**Decisión de diseño que este encargo toma, y que el titular puede revertir:** con el
territorio nacional **no se dibuja la grilla de establecimientos** (`.pan-grid`, ~línea
1874). En 4° básico 2025 el roster nacional son 6.717 EE: pintar 6.717 tarjetas es
inviable y además no es lo que esa pantalla responde. En su lugar, bajo las barras de
cada GSE, un aviso breve del tipo "La grilla de establecimientos no se muestra a nivel
nacional (N establecimientos). Elige una región, un SLEP o una comuna para verla."
Las barras por GSE **sí** se calculan y muestran: son conteo, no agregación.

Commit: `feat(panorama): la entidad nacional disponible tambien en el selector de territorio`

## 3. Fase 2 — Filtro de dependencia por entidad (commit `feat`)

**Lo que pide el titular:** poder mirar una comuna, una región o el país **acotados a
una dependencia** (municipal, particular subvencionado, SLEP…), en vez de forzosamente
todos los establecimientos. Referencia vinculante: el modal del hermano.

**Cómo lo resuelve `slep_simce_adecuado`** (leído en su plantilla):

- La dependencia es **un atributo de la entidad**, no un filtro global: cada entidad
  guarda su `depe2` y se filtra con él (`if (entity.depe2) { if (String(r.cod_depe2) !==
  String(entity.depe2)) return false; }`, líneas 1953 y 2106).
- El `<select>` "Dependencia" vive **dentro del modal**, en los tabs **Comuna**,
  **Región** y **Nacional**. Los tabs **SLEP** y **Establecimiento** no lo llevan: un
  SLEP ya es una dependencia y un establecimiento es uno solo.
- La primera opción es "Todas las dependencias" (valor vacío).
- El subtítulo de la entidad muestra la dependencia elegida, o "Todas las dependencias".
- Cuando la dependencia elegida es SLEP (código `"5"`) aparece un aviso
  (`SlepDisclaimer`, línea 3766) advirtiendo que los establecimientos se clasifican por
  su dependencia **actual** y que las cifras previas al traspaso no son atribuibles a la
  gestión del SLEP. El tab SLEP lo muestra siempre.

**Qué se hace en `slep_idps`:**

1. La entidad gana el campo `dep` (código `cod_depe2`, vacío = todas). Afecta a
   `cmpTerr` (comparador) y a `terr` (panorama).
2. `<select>` de dependencia dentro del modal en los tabs **Comuna**, **Región** y
   **Nacional**, con "Todas las dependencias" primero, alimentado por
   `DATA.meta.depe2_labels` / `DEPS_OPTS`, que ya existen. **No** en SLEP ni en
   Establecimiento.
3. `rosterTerr` (comparador) y `unidades` (panorama) filtran por `t.dep` / `terr.dep`
   cuando viene, con el mismo idioma que el resto: `continue`, nunca una cifra nueva.
   El invariante de cero agregación no se toca: filtrar por dependencia sigue siendo
   **acotar la lista**.
4. **La clave de unicidad de las entidades pasa a ser `kind|cod|dep`.** Es lo que
   permite lo que el titular quiere: comparar la misma comuna con dos dependencias
   distintas como dos filas. Revisa `addTerr`, `removeTerr` y `seleccionados` del modal.
5. El chip y el banner muestran la dependencia elegida; con "todas" no se escribe nada
   (no ensuciar la etiqueta con lo que es el estado por defecto). La meta (comunas y
   establecimientos) se recalcula **con** el filtro aplicado: es el roster real de lo
   que se está comparando.
6. **Aviso de SLEP:** replica el del hermano cuando `dep === "5"`, adaptado a este
   motor (serie 2014–2025, traspasos escalonados). El tab SLEP ya muestra "Traspaso
   AAAA" por SLEP; el aviso lo complementa, no lo reemplaza.
7. **Decisión declarada, reversible:** el tab **"Dependencia"** del picker territorial
   del panorama (`TABS`, línea ~1430) **se retira**. Hoy es un filtro global suelto que
   duplicaría al nuevo select y permitiría estados contradictorios (un territorio con
   una dependencia y el filtro global con otra). Quien quiera "solo municipales de la
   región" ahora elige Región + Dependencia en el mismo modal, que es como lo hace el
   hermano. Si el titular prefiere conservarlo, se repone sin tocar lo demás.
8. Actualiza los comentarios del código que afirman que "el comparador no usa dep"
   (rosterTerr y su cabecera): dejaron de ser ciertos.

**Verificación exigida:** comparar "Viña del Mar · Municipal" y "Viña del Mar ·
Particular subvencionado" como dos entidades simultáneas, y comprobar que sus conteos
suman los mismos establecimientos que "Viña del Mar · todas" cuando se agregan todas las
dependencias presentes.

Commit: `feat(entidades): dependencia por entidad en el modal, como el motor hermano`

## 4. Fase 3 — El pie de sección repite la explicación (commit `fix`)

**Hallazgo (captura del titular):** la frase "Los establecimientos seleccionados
aparecen únicamente en la sección de su propio grupo socioeconómico." se repite en el
pie de **cada** sección de GSE. Lo que cambia entre secciones es solo la parte final
("Colegio Miraflores … se muestra más abajo").

Corrección (línea ~1688): la **explicación general** se dice una sola vez, junto al
aviso `.cmp-nota-ee` que ya vive bajo los chips; el pie de cada sección se queda
**solo** con la parte que cambia: los nombres y su ubicación ("Colegio Miraflores (GSE
Medio bajo), más abajo"). Si ya existe el bloque `.cmp-nota-ee`, la explicación general
se integra ahí en vez de crear un tercer sitio.

Commit: `fix(comparador): la explicacion del pie se dice una vez, no en cada seccion`

## 5. Fase 4 — La tira externa se solapa en anchos extremos (commit `fix`)

**Hallazgo (captura del titular):** a ancho muy angosto las tres etiquetas de
`.s100-ext` (grid `1fr auto 1fr`, línea ~460) se superponen: se leen "▼17% (233)" y
"▲17% (232" encima de "= 63% (822)".

Corrección: cuando las tres no caben en una línea, deben **apilarse**, no solaparse.
`white-space:nowrap` en los ítems está bien (no queremos partir un número), lo que falta
es que el contenedor ceda: usa `grid-template-columns:auto auto auto` con
`justify-content:space-between` y permite el salto (por ejemplo `flex-wrap` con
`display:flex` + `justify-content:space-between` y `gap`, conservando el orden
▼ / = / ▲ y la alineación a los extremos cuando sí caben). El criterio de aceptación es
medible: a 320px de ancho de columna ningún par de ítems de la misma celda se solapa
(compara sus `getBoundingClientRect`).

Commit: `fix(motor): la tira externa se apila en vez de solaparse en anchos extremos`

## 6. Fase 5 — Mayúsculas sostenidas (commit `fix`)

**Regla del proyecto:** solo las siglas y las palabras que lo admiten van en mayúsculas
sostenidas. Hoy hay **siete** reglas CSS con `text-transform:uppercase` que fuerzan
versalitas sobre texto común:

| Línea | Selector | Texto afectado |
|---|---|---|
| 90 | `.ctl label` | rótulos de control |
| 195 | `.sel-chip .k` | clave del chip de selección |
| 268 | (banner) | "VISTA", "NIVEL" |
| 367 | `.hist-dims-lab` | rótulo de dimensiones |
| 481 | `.cmp-eyebrow` | línea superior del comparador |
| 495 | `.cmp-ck` | tipo de entidad del chip ("ESTABLECIMIENTO", "NACIONAL · FIJO") |
| 534 | `.td-ee-k` | "ESTABLECIMIENTO" de la fila de EE |

Quita `text-transform:uppercase` de las siete y deja los literales con capitalización
normal ("Vista", "Nivel", "Establecimiento", "Nacional · fijo"…), corrigiendo el texto
fuente donde haga falta. **Conserva** el `letter-spacing` y el peso: la jerarquía visual
la dan esos, no las mayúsculas. Las siglas (GSE, SLEP, RBD, IDPS) quedan como están.

Barre también literales escritos en mayúsculas dentro del JSX, si los hubiera, y
repórtalos.

Commit: `fix(motor): retira mayusculas sostenidas fuera de siglas`

## 7. Fase 6 — Regenerar y auditar (commit `build`)

1. `run_all(only = 35L)`; fidelidad del payload (bloque 7 + diff de offsets).
2. Verificación funcional: tab Nacional en **ambos** modales; dependencia por entidad
   (ver la verificación exigida en §3); el panorama nacional
   muestra barras y el aviso en vez de la grilla; el pie de sección ya no repite la
   explicación; a 320px de columna la tira no se solapa; ninguna versalita fuera de
   siglas en las tres pantallas.
3. Auditoría de contraste (método de s29d–s29g) en panorama, comparador y ficha:
   criterio igual que en s29g (solo excepciones escritas y backlog §5.6).
4. Regla de etiquetado: 0 cortadas y 0 duplicados a 1200px y 430px.

Commit: `build(motor): regenera el motor con las correcciones de la revision`

## 8. Fase 7 — Desplegar, log y publicar

1. Promueve a `docs/index.html` (byte a byte, verificado con `md5`).
2. Sección s29i en el log: hallazgos, decisiones, cifras y verificación. Anota en
   ESTADO.md el pendiente nuevo de **exportación** (ver §9).
3. `git push origin main`; reporta el hash.

Commits: `deploy(docs): republica con las correcciones de la revision` y
`docs(log): registro de s29i`

---

## 9. Fuera de alcance (anotar, no ejecutar)

- **Exportación tipo `slep_simce_adecuado`** (botón "Exportar CSV" y exportación de
  imagen del gráfico, con el selector de GSE al lado): el titular la pidió tras la
  revisión. Es funcionalidad nueva, con su propio diseño y su propio encargo. Anótala
  como pendiente citando el hermano como referencia.
- §5.6 (texto sobre color de indicador), P-VISTA-TERRITORIAL, marca de base pequeña.
- Las trece divergencias del modal con el hermano (§36.7).
- Rama `feat/contrato-contexto`.
