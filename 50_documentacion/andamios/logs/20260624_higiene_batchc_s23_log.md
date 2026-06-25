# Log — Higiene del template + #5/#8 (Batch C, s23)

**Fecha:** 2026-06-24
**Modo:** autonomo, secuencial, hasta el GATE VISUAL (detencion en fase 2/3).
**Base:** `origin/main` en `d35027a` (s22 desplegado).
**Alcance:** solo template (`30_procesamiento/35_motor_template.html`) — CSS/JSX. Payload
byte-identico (no toca generador ni parquet).

---

## 1. Resumen

- **Fase 1 (higiene, COMMITEADA autonoma):** se elimino el componente muerto
  `PanelEvolucion` (huerfano desde P3-s9) y se corrigio el comentario obsoleto de
  `ScoreBar` que negaba D7. 2 commits atomicos.
- **Fase 2 (#5) + Fase 3 (#8) (CONVERGENTES, NO commiteadas):** anclas del indicador en
  una sola fila + etiquetas de eje del radar sin recorte/choque. Implementadas, build
  regenerado, dejadas en el working tree para el **gate visual del titular**.
- Payload **byte-identico** en cada regeneracion (fase 1 y fase 2/3). Parquet intacto.

---

## 2. Commits de fase 1 (sobre d35027a)

| Hash | Tipo | Titulo |
|------|------|--------|
| `8e55c8d` | refactor | elimina PanelEvolucion (componente huerfano desde P3-s9) |
| `5aaa761` | docs | corrige comentario obsoleto de ScoreBar (coherente con D7) |

**1a — PanelEvolucion.** Confirmado huerfano: 0 invocaciones `<PanelEvolucion`; solo su
definicion + 3 menciones en comentarios. Se elimino la definicion completa (comentario +
funcion, ~42 lineas) y se sanearon las 3 referencias residuales en comentarios (CSS `.ybars`,
intro de `BarrasAnio`, lista de componentes de `Ficha`). Verificado: `grep PanelEvolucion = 0`,
llaves balanceadas (1042=1042), build regenera sin error (Babel parsea el JSX). Era el unico
otro consumidor vivo de `.axis-lab.b` (ahora solo el radar).

**1b — comentario ScoreBar (D7).** El comentario afirmaba que "el promedio ABSOLUTO del GSE
no existe ... derivarlo viola lee-no-deriva". Desde D7 (s21) la cifra GSE es publica y
reconstruida (prom - difgru) y el radar dibuja el poligono GSE. Reescrito (JS L818-823 + el
comentario CSS gemelo de `.sbar`) para reflejar que ScoreBar omite la marca GSE por ELECCION
DE DISENO de esa barra, NO por prohibicion. Solo comentarios, sin efecto runtime. s7-1 OK
(sin `*/` interno).

---

## 3. Diagnostico y via elegida de #5/#8 (NO commiteadas)

### Correccion de supuesto (dato real vs encargo)
El encargo nombraba `.indp-anc` como la fila de anclas que se envuelve. **La medicion real
contradice ese supuesto**: `.indp-anc` (paneles drill-down) ya entra en 1 fila (38px); la que
se envuelve a 2 filas (58px) es **`.rcard-anc`** — las anclas de las 4 tarjetas que rodean el
radar central (`.ficha-radar`/`.rquad`). Esto coincide con el gate del encargo
("las 4 tarjetas rodean el radar central"), asi que se actuo sobre `.rcard`/`.rquad` (la zona
correcta), no sobre `.indp-anc`. No es contradiccion de gobernanza ni de cifra; es la
clase precisa segun evidencia.

### #5 — anclas en una sola fila (CORREGIDO en iteracion 2, ver §3bis)
- **Medicion:** las 2 anclas necesitan ~296px (133 + 157 + 6 gap); el contenido de `.rcard`
  era 256px (280 − 22 padding) → se envolvian.
- **Iteracion 1 (INSUFICIENTE):** `.rcard max-width 280px → 330px`. A viewport 1280 entraban
  en 1 fila, pero a viewports mas angostos (ficha-radar < ~1080) las tarjetas LATERALES seguian
  apilandose. Causa: ver §3bis. El titular lo reporto correctamente.

### #8 — etiquetas de eje del radar
- **Diagnostico:** el SVG del radar (300px, `overflow:visible`) deja desbordar la etiqueta;
  "Convivencia68" (la mas larga, derecha) llegaba a x=825, y el borde izquierdo de la tarjeta
  derecha estaba en 806 → **la etiqueta invadia la tarjeta 19px** (no era recorte por viewBox
  sino COLISION con la tarjeta lateral, que va `justify-self:start`, pegada al radar).
- **Via elegida (menor efecto colateral: "reservar margen horizontal para las etiquetas"):**
  subir el `column-gap` del grid `.rquad` (16px → 50px) para alejar las tarjetas laterales del
  radar y dar aire a las etiquetas. NO se achico la fuente del nombre, NO se movio el poligono
  ni los vertices (el SVG sigue 300×300).

### Enabler compartido (zona central)
`.rquad max-width 880px → 1100px`: mas sitio total para acomodar tarjetas mas anchas (#5) y el
column-gap amplio (#8) sin romper el layout 4-tarjetas-alrededor-del-radar. row-gap intacto (10px).

### Resultado de la iteracion 1 (viewport 1280, INSUFICIENTE en angostos)
- A 1280 las 4 tarjetas en 1 fila y Convivencia con 30px de holgura (#8 OK).
- PERO a viewport mas angosto las laterales se apilaban (ver §3bis).

---

## 3bis. Correccion de #5 (iteracion 2) + eliminacion de "Mirada integral"

### Eliminacion de "Mirada integral · 4 indicadores" (peticion del titular)
Se borro el elemento completo `<div className="fr-head">Mirada integral · 4 indicadores</div>`
(hijo de `.ficha-radar`, antes de `.rquad`). El primer hijo de `.ficha-radar` pasa a ser
`.rquad` directamente; sin contenedor vacio, sin error. (La regla CSS `.fr-head` queda huerfana,
sin uso; candidata a limpieza aparte, como el CSS `.evol-*`.)

### Diagnostico real de por que #5 fallaba (R9, medido en navegador)
Las tarjetas top/bottom viven en la **columna central `auto`** del grid (ancho ~330, fijado por
su `max-width`), por eso NUNCA se apilaban. Las tarjetas **laterales viven en columnas
`minmax(0,1fr)`** que **encogen con el viewport**: cuando la columna baja de ~318px, el contenido
cae bajo los ~296px que necesitan las 2 anclas y estas se envuelven. Medido: a viewport 1280
(ficha-radar 1150) las 4 en 1 fila; a viewport 1120 (ficha-radar 1070) las **laterales** en 2
filas (`rows=[1,2,1,2]`). Subir `.rcard max-width` NO lo arregla porque el limite lo impone la
**columna `1fr`**, no el `max-width`.

### Solucion (sigue siendo ENSANCHAR; menor efecto colateral)
1. **Ancho minimo de las columnas laterales:** `minmax(0,1fr)` → `minmax(320px,1fr)`
   (320 = contenido 296 + padding 22 + holgura). Asi la columna no encoge bajo el umbral y las
   anclas no se apilan en ningun viewport donde el grid 3-col este activo.
2. **Breakpoint de colapso subido:** `@media(max-width:760px)` → `@media(max-width:1180px)`.
   Por debajo de 1180px el grid colapsa a 1 columna (tarjetas a ancho completo, anclas en 1 fila
   de sobra) ANTES de que el 3-col (minimo ~1040px + padding) deje de caber. Asi se elimina la
   banda intermedia donde las laterales se apilaban.
3. `.rcard max-width 330px`, `.rquad max-width 1100px`, `gap 10px 50px` (column-gap 50 para #8)
   se mantienen.

### Resultado verificado en navegador (RBD 1692), barrido de viewports
| viewport | layout | 4 tarjetas en 1 fila | desborde H | Convivencia (#8) |
|---|---|---|---|---|
| 1280 | 3-col | si | no | 30px, sin colision |
| 1200 | 3-col | si | no | sin colision |
| 1185 | 3-col | si | no | sin colision |
| 1180 | 1-col | si | no | n/a (apilado) |
| 1100 | 1-col | si | no | n/a |
| 900  | 1-col | si | no | n/a |

- **#5 RESUELTO:** las 2 anclas de las 4 tarjetas en 1 fila en todo el rango; sin banda de 2-filas.
- **#8 intacto:** Convivencia con 30px de holgura en 3-col (las laterales miden 330; columnas
  335/330/335). Sin colision.
- Radar SVG **300×300** en todos los viewports (poligono y vertices sin cambio).
- Sin desborde horizontal en ningun viewport. Sin error de consola. "Mirada integral" ausente.

---

## 4. Invariantes 🔒

| Invariante | Resultado | Evidencia |
|-----------|-----------|-----------|
| `idps_largo.parquet` md5 `4c764d8c…` intocable | **PASA** | md5 sin cambio en todas las regeneraciones. |
| Payload byte-identico (fases solo-template) | **PASA** | `cmp` del JSON descomprimido vs baseline = identico, tras fase 1 y tras fase 2/3. |
| D7 vigente (poligono GSE se dibuja; comentarios coherentes) | **PASA** | 1b reescribe los 2 comentarios que negaban D7; el radar sigue dibujando el poligono GSE (no se toco). |
| s7-1: ningun comentario CSS con `*/` interno | **PASA** | Comentarios nuevos (#5/#8, .sbar) revisados; solo el cierre real. |
| No commitear nada fuera de estas fases | **PASA** | Solo 2 commits de fase 1, ambos en el template. documentar.R/SETTINGS/snapshots/untracked viejos intactos. |

---

## 5. Estado de git (CERRADO — gate visual aprobado, commit + deploy + push)

Tras la aprobacion del gate visual del titular se cerro el lote: 3 commits nuevos + push.

**`git log --oneline d35027a..HEAD` (5 commits):**

| Hash | Tipo | Titulo |
|------|------|--------|
| `8e55c8d` | refactor | elimina PanelEvolucion (componente huerfano desde P3-s9) |
| `5aaa761` | docs | corrige comentario obsoleto de ScoreBar (coherente con D7) |
| `cb004d3` | style | anclas del indicador en una fila + etiquetas del radar sin colision (#5/#8) |
| `2c2ed51` | build | regenera con higiene template + #5/#8 (s23) |
| `33ea07a` | deploy | publica higiene template + #5/#8 (s23) |

Valores finales (#5/#8): `.rquad` columnas `minmax(320px,1fr) auto minmax(320px,1fr)`,
`gap:10px 50px`, `max-width:1100px`; `.rcard max-width:330px`; colapso `@media(max-width:1180px)`.
Tambien se elimino el rotulo "Mirada integral · 4 indicadores".

- **Push OK:** `d35027a..33ea07a`. **HEAD = origin/main = `33ea07a`** (rama al dia).
- Los 5 commits tocan SOLO `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`
  y `docs/index.html`. `git diff --stat d35027a..HEAD` sobre el resto = vacio.
- `docs/index.html` desplegado (== `40_salidas/motor_idps.html`, verificado con `cmp`).
- Working tree residual (sin commitear, invariante de no-commit, intacto): documentar.R, SETTINGS,
  snapshots de `50_documentacion/estructura/`, untracked viejos (resena, logs s21/overlay,
  traspasos v20/v21/v22) + los logs de cierre s22 (`20260624_commit_deploy_s22_log.md`) y de este
  batch (`20260624_higiene_batchc_s23_log.md`).

---

## 6. Pendientes / notas para el revisor

- **#5/#8 CERRADOS:** gate visual aprobado por el titular; commit + deploy + push hechos
  (HEAD = origin/main = `33ea07a`). Propagacion de GitHub Pages puede tardar unos minutos.
- **CSS muerto `.evol-*`** (`.evol-panel/.evol-h/.evol-sw/.evol-marks/.evol-mark/.evol-sig` y
  `.hist-main .evol-panel`, L155-164/L320/L333): quedo huerfano al eliminar PanelEvolucion. NO
  se removio en 1a (el encargo acoto a la definicion del componente; ademas `.arr` es compartida
  con Ancla). Candidato a un commit de higiene CSS aparte, a tu criterio.
- **CSS muerto `.fr-head`** (L257): quedo huerfano al eliminar el rotulo "Mirada integral". Mismo
  candidato a la higiene CSS aparte.
- El supuesto del encargo sobre `.indp-anc` se corrigio a `.rcard-anc` (ver §3); confirmar que
  la intencion era la tarjeta del radar (lo es, segun el gate).
