# Log de sesión 6 — slep_idps

**Andamio de ejecución (registro congelado).** Material de evaluación, no de
marketing. Redactado para que un revisor que no vio el output en vivo pueda
juzgar la calidad del trabajo, incluyendo lo que costó y lo que quedó abierto.

- **Fecha:** 2026-06-19 (tramos 1–4) y 2026-06-20 madrugada (cierre FASE 4).
- **Repo:** `/Users/tomgc/Projects/slep_idps` · rama `main`.
- **Producto:** motor HTML autocontenido (React 18 + D3 v7 por Babel CDN; JSON →
  gzip → base64 → pako inline; fuentes gobCL/Museo Sans embebidas).
- **Generación:** `source("00_build.R"); run_all(only=35)` (template/35.R) o
  `run_all()` completo (31–34).
- **Salida:** `40_salidas/motor_idps.html`. `docs/index.html` **NO** republicado
  en esta sesión (queda en la versión previa, a la espera de la revisión visual).

---

## 1. Resumen de la sesión 6

Sesión larga, **cuatro tramos** sobre el motor IDPS (Indicadores de Desarrollo
Personal y Social, Agencia de Calidad), todos sobre el modelo **sin agregación
territorial** (el dato viaja por establecimiento; territorio/dependencia/GSE
acotan la lista, jamás promedian):

1. **Tramo 1 — Alcance + P-meta + evolución.** Acota el motor a 4° básico / 2°
   medio, ordinal en los grados, sin ALLCAPS; histórico de años agnóstico;
   evolución en 4 paneles con significancia inter-anual leída; definiciones
   metodológicas (P-meta) contextuales en el drill-down.
2. **Tramo 2 — Navegación + foco + tildes región + deploy.** Filtro de
   dependencia; doble ancla GSE con significancia explícita (a11y); selector
   EntityModal con pestañas; foco de apertura en SLEP Costa Central; tildes
   correctas en nombres de región; deploy a `docs/`.
3. **Tramo 3 — Auditoría FASE I + saneamiento FASE II.** Auditoría exhaustiva de
   datos (sin corregir) y luego sólo los fixes de presentación seguros
   (truncamiento de nombres, geo, tildes, rename Dependencia, radar etiquetado,
   radar de 2 años, leyenda con definición, GSE sin numeración).
4. **Tramo 4 — Encargo 2 (cierre).** H6 (dependencia vigente del directorio);
   tildes de subdimensión; pulido funcional del radar de 2 años y la leyenda;
   y el **rediseño visual (piel)** hacia el motor hermano
   `slep_categoria_desempeno`, conservando la identidad azul gobCL + cream y la
   paleta de 4 indicadores intacta.

**Estado final:** motor con todo aplicado en `40_salidas/motor_idps.html`,
0 errores de consola, todas las funcionalidades verificadas en navegador. Cifras
IDPS intactas por construcción (todo el tramo 3–4 fue `only=35`;
`idps_largo.parquet` con md5 idéntico de principio a fin). Pendientes de cierre:
republicar `docs/`, traspaso v06 y acentuar las 45 definiciones largas — todos a
la espera de la revisión visual del titular (Claude Design).

---

## 2. Inventario de commits (sesión 6, en orden cronológico)

Sesión 6 comienza tras `6820051` (cierre sesión 5). Tipos: feat/fix/style/docs.

### Tramo 1 — alcance, P-meta, evolución
| Hash | Tipo | Título | Qué hizo |
|------|------|--------|----------|
| `50400de` | feat | P-meta: definiciones metodológicas IDPS contextuales en el drill-down | Expone la definición de indicador/dimensión en el detalle. |
| `07ecc3c` | refactor | Alcance y nomenclatura: sólo 4b/2m, sin ALLCAPS, grado con ordinal | Filtro de presentación a GRADOS_MOTOR=4b/2m; Title Case; "4° básico". |
| `1e977ed` | refactor | Histórico agnóstico de años: deriva preliminar del dato | Marca preliminar derivada de la columna `preliminar` (no hardcode). |
| `5918caf` | feat | Evolución en 4 paneles por indicador con significancia inter-anual leída | Small-multiples 2×2, eje fijo 0–100, marca dif/sigdif leída. |

### Tramo 2 — navegación, foco, tildes región, deploy
| Hash | Tipo | Título | Qué hizo |
|------|------|--------|----------|
| `3f6b4c3` | feat | Filtro Sostenedor (tipo de dependencia) reemplaza el filtro SLEP | Filtro por las 4 categorías de dependencia. |
| `bdfc876` | feat(a11y) | Significancia explícita (sig./n.s.) en la doble ancla GSE | "· sig."/"· n.s." en cada ancla. |
| `163e58b` | feat | Sostenedor sobre EntityModal: selector con pestañas reemplaza los selects | Modal con 4 pestañas Región/Comuna/Sostenedor/Establecimiento. |
| `0a9f505` | feat | Default de apertura: foco inicial en SLEP Costa Central (estado, no filtro fijo) | Apertura en Costa Central; reversible por el usuario. |
| `f06ab95` | fix | Tildes en NOMBRES_REGION: nombres oficiales de región con UTF-8 correcto | Override de presentación con tildes (patrón Bug 2). |
| `cff962d` | chore | Deploy a docs/ + snapshot del escáner (sesión 6, 2do tramo) | Copia a `docs/index.html`. |

### Tramo 3 — saneamiento FASE II (tras la auditoría FASE I)
| Hash | Tipo | Título | Qué hizo |
|------|------|--------|----------|
| `ce2b11d` | fix | H1/H2/H8: nombres completos de comuna/EE y geo desde el directorio | El motor toma nombre/geo del directorio público (completos), no de `idps_largo` (truncado). Geo NA 51→0. |
| `116c678` | fix | H3/H4: tildes en nombres de indicador y dimensión | `INDICADOR_LABELS` + nuevo `DIMENSION_LABELS` acentuados; Encoding UTF-8. |
| `667e690` | fix | H5/II.4: renombrar Sostenedor→Dependencia y blindar la pestaña | Rename total + `DEPS_OPTS` blindado a las 4 categorías. |
| `efdb785` | fix | II.8: quitar enumeración del GSE en etiquetas visibles | "Bajo" en vez de "1 Bajo"; filtro sigue por código. |
| `42ce2d3` | feat | II.5: rotular cada vértice del radar con nombre y puntaje | Score en tarjeta; nombre corto + score en detalle; `overflow:visible`. |
| `9147d5f` | feat | II.6: comparar dos años superpuestos en el radar (detalle, nivel indicador) | Polígono actual + comparación; leyenda + selector. |
| `3d63705` | feat | II.7: leyenda de indicadores expone la definición (P-meta), accesible | Tooltip por hover **y** foco de teclado + aria-label. |
| `dadbfdb` | docs | Registrar auditoría FASE I + saneamiento/mejoras FASE II en CLAUDE.md | Actualiza "Últimos cambios". |

### Tramo 4 — Encargo 2 (H6, tildes, pulido, rediseño)
| Hash | Tipo | Título | Qué hizo |
|------|------|--------|----------|
| `0a6d65c` | fix | H6: dependencia vigente = actual del directorio (traspasados aparecen como SLEP) | `CW_DEPE_DIRECTORIO_A_IDPS`; cod_depe2 desde el directorio. 118 EE Municipal→SLEP. |
| `1498873` | fix | Tildes en nombres de subdimensión (definiciones quedan pendientes) | `SUBDIMENSION_LABELS` (22 EST). Definiciones largas: sin fuente verificable → pendiente. |
| `2a18b5c` | fix | Pulido funcional del radar de 2 años (etiquetas sin encimar) y leyenda | Leyenda con trazo sólido/discontinuo; score del año actual en el vértice, comparado en tooltip. |
| `cdef681` | style | densidad: ritmo tipográfico y escala alineados a la referencia | Tokens fs/fw/radius/tracking; base 13px. **Piel.** |
| `09d912b` | style | header: estructura tipo referencia (eyebrow, título, subtítulo, descripción) | Header reestructurado; azul/cream. **Piel.** |
| `fb8405c` | style | controles: barra segmentada tipo referencia (label + control agrupado) | Barra sticky, overline, segmented cream-200, acento azul. **Piel.** |
| `de79ce0` | style | modal: apariencia EntityModal alineada a la referencia (lógica intacta) | Encabezado/tabs/filas/footer alineados; lógica intacta. **Piel.** |

> Los cuatro `style()` son **piel** y revertibles de forma independiente sin
> tocar ninguna cifra ni el corazón analítico (FASES 1–3).

---

## 3. Cambios sustantivos (qué, por qué, cómo se verificó, tensiones)

### 3.1 Truncamiento de nombres (H1/H2) — causa raíz, no síntoma
- **Síntoma:** comunas "Curaco de Vél", "Tierra Amaril"; nombres de EE cortados.
- **Causa raíz:** el export de la Agencia trae `nom_com_rbd` truncado a ~13 chars
  y `nom_rbd` a ~37, **de forma inconsistente entre archivos/años**. La
  homologación canónica de `34` (atributo del año más reciente por RBD) hereda el
  valor truncado. El motor serializaba esa copia de `idps_largo`, **ignorando**
  el `comunas_chile`/directorio que sí tiene los nombres completos.
- **Fix:** en `35_generar_motor_html.R`, sourcing de nombre+geo desde el
  directorio público (autoridad), por RBD character. No es CSS.
- **Verificación:** 10 cod_com con doble nombre antes → 0 después; comunas
  357→345 (desaparecen los duplicados-fantasma); EE máx 47→86 chars; geo NA 51→0.
- **Tensión:** ¿corregir en `34` (regenera `idps_largo`) o en `35` (presentación)?
  Se eligió `35` (only=35) para garantizar cifras byte-idénticas. Decisión correcta:
  `idps_largo` se mantiene fiel al crudo; el motor muestra la etiqueta autoritativa.

### 3.2 Tildes (H3/H4 + tramo 4) — capa de presentación, corpus congelado
- **Causa raíz:** el corpus conceptual (`idps_corpus_conceptual.json`/`.md`) es
  **todo ASCII**: indicadores, dimensiones, subdimensiones y las ~45 definiciones.
- **Fix:** override acentuado en config (`INDICADOR_LABELS`, `DIMENSION_LABELS`,
  `SUBDIMENSION_LABELS`), mismo patrón que `NOMBRES_REGION`. El corpus/andamio
  **no** se edita. `Encoding<-"UTF-8"` antes de serializar (regla Bug 2).
- **Verificación:** por **bytes** (codepoint único c3a9/c3b3/c3a1; cero mojibake
  c383). P-meta (definiciones) idéntica 1:1 pre/post.
- **Decisión declarada:** las 22 subdimensiones EST (las que el motor muestra) se
  acentúan; las 8 no-EST no se renderizan. Las 45 **definiciones largas NO** se
  acentúan a ciegas (riesgo ortográfico sin fuente verificable) — ver §8.

### 3.3 Dependencia: Sostenedor→Dependencia (H5) + vigencia (H6)
- **H5 (rename + blindaje):** "Sostenedor" era impreciso; el término correcto es
  "Dependencia". Rename total de etiquetas visibles + identificadores internos
  (`SOST_OPTS`→`DEPS_OPTS`, `sostenedor`→`dep`, kind/tab→`dependencia`).
  `DEPS_OPTS` blindado a `cod_depe2` con etiqueta conocida → la pestaña jamás
  lista comunas (la sospecha original del titular era de una captura previa al
  refactor EntityModal; el dato ya estaba limpio).
- **H6 (vigencia):** decisión del titular = mostrar la dependencia **actual** del
  directorio, no la del momento de evaluación. `CW_DEPE_DIRECTORIO_A_IDPS`
  homologa el esquema 5-cat del directorio al 4-cat IDPS (5→4 SLEP; 4 Adm.
  Delegada→2 Part.subv). 35.R resuelve `cod_depe2` desde el directorio por RBD.
- **Verificación H6:** matriz de transición **118 Municipal→SLEP** (sin
  degradaciones); SLEP 1447→1578, Municipal 3077→2988; los 51 geo-NA resuelven su
  dependencia. **Cifras byte-idénticas** (`all.equal` TRUE en ind/dim/niv:
  prom/dif/difgru/sigdifgru/niveles). RBD 7894 verificado en navegador como SLEP.

### 3.4 Radar de 2 años (II.6 + pulido tramo 4)
- En el detalle (nivel indicador), superpone dos años del mismo RBD/grado:
  polígono actual (azul sólido) + comparación (terracota discontinuo), leyenda y
  selector "comparar con" (sólo años con serie real). Default: año vigente vs el
  inmediatamente anterior con dato.
- **Decisión declarada (pulido):** el **puntaje del vértice es del año actual**;
  el del año comparado se ve en tooltip (con el año), no dos números encimados.
  La leyenda replica el trazo (sólido vs discontinuo). Cada año se lee tal como
  viene; supresión=NA no se grafica; eje 0–100.

### 3.5 Rediseño visual (FASE 4) — piel anclada a la referencia
- **Método:** se descargó el motor hermano publicado
  (`https://tomgc.github.io/slep_categoria_desempeno/`) a `/tmp` (no versionado) y
  se **diseccionó por reverse-engineering** (tokens, header, controles, modal).
- **Mapa de correspondencias aplicado** (referencia → IDPS):
  - `.app-header` (eyebrow-row + título display + subtítulo + objetivo) → header
    IDPS, conservando azul `#0A3A5C` (no el plum `#4A2746` de la referencia).
  - `.controls-bar` sticky + `.control-group`(label overline + `.segmented`) →
    barra IDPS sticky con acento superior **azul** (NO coral: `#E88663` es el
    color de nivel `--bajo` del IDPS; usarlo como chrome colisionaría).
  - `.segmented` (track cream-200, activo paper+sombra) → `.seg` del IDPS.
  - `.modal*` (mismas clases, andamio compartido) → ajuste de radios/espaciado/
    tipografía; tabs subrayadas con activo en `--foco` (= `--ocean` de la ref).
  - tokens fs/fw/radius/tracking → `:root` del IDPS.
- **🔒 Intacto:** paleta de 4 indicadores (verificada por color exacto), radares,
  4 paneles, doble ancla, lógica de filtros, P-meta. El rediseño es del **chrome**.
- **Decisiones del titular respetadas:** sólo patrones/estructura (no la identidad
  morado/burdeos); rótulo de grado "4° básico/2° medio" (no "Educación Básica").
- **Nota de fidelidad:** la referencia usa labels en *title case* con tracking
  0.12em (no `text-transform:uppercase`). El titular los describió como "mayúsculas
  espaciadas"; se optó por `uppercase` + tracking para honrar esa descripción. Es
  una decisión de chrome trivialmente reversible.

---

## 4. Auditoría FASE I (resumen)

**Método:** backbone determinista en R (yo) + verificación adversarial
independiente (4 agentes de solo-lectura, código R propio) + lectura de las
glosas PDF. Universo completo, no muestras.

**Veredicto global:** el "caos" era de **PRESENTACIÓN**, no de datos de medición.
Joins RBD→geografía **100% correctos** (8300/8300 comuna/región/provincia
coinciden con el directorio; 53 con geo NA). Cifras IDPS del motor **1:1 con el
crudo de la Agencia** (0 discrepancias en 56+ celdas). Costa Central = 60 en 4b
2025. El caso "Sargento Aldea → Puchuncaví·SLEP" es **correcto**.

| ID | Sev | Descripción | ¿Cambia cifras? | Estado |
|----|-----|-------------|-----------------|--------|
| H1 | ALTO | Nombres de comuna truncados en el dato (~13 chars) | NO | Corregido (ce2b11d) |
| H2 | ALTO | Nombres de EE truncados en el dato (~37 chars) | NO | Corregido (ce2b11d) |
| H3 | MEDIO | Indicadores sin tildes (ASCII en config/corpus) | NO | Corregido (116c678) |
| H4 | MEDIO | Dimensiones/subdim/definiciones sin tildes (corpus ASCII) | NO | Parcial: ind/dim (116c678), subdim (1498873); definiciones pendientes |
| H5 | BAJO | Pestaña "Sostenedor" supuestamente mezcla comunas — **refutado** | NO | Rename + blindaje (667e690) |
| H6 | MEDIO | 120 EE SLEP-por-traspaso marcados Municipal (vigencia) | NO | **Resuelto** por decisión titular (0a6d65c): 118 reclasificados |
| H7 | INFO | 70 EE Adm. Delegada → Part. subvencionado (esquema Agencia) | NO | Documentado; sin acción |
| H8 | MEDIO | 53/51 EE sin geo (invisibles en navegación) | NO | Corregido (ce2b11d): backfill desde directorio |
| H9 | INFO | 8353 (idps_largo) vs 8329 (motor): 24 EE sólo 6b/8b | NO | Esperado (filtro GRADOS_MOTOR) |

**Corregido vs pendiente:** todos los hallazgos que NO cambian cifras se
corrigieron (capa de presentación). H6 quedó como decisión del titular en FASE I
y se resolvió en el tramo 4. Único pendiente real: las definiciones largas (H4).

---

## 5. Bugs encontrados y resueltos (causa raíz + fix)

1. **Nombres truncados (H1/H2)** — causa: export de la Agencia trunca campos de
   nombre de forma inconsistente; el motor usaba esa copia. Fix: directorio como
   autoridad de etiqueta. (§3.1)
2. **51 EE con geo NULL (H8) — invisibles en la navegación.** Causa: `idps_largo`
   trae geo NA para algunos RBD (el crudo IDPS no la incluyó); con `cod_com`/
   `cod_reg` NA, esos EE no caen en ningún filtro territorial y su tarjeta queda
   sin comuna. Fix: backfill de geo desde el directorio (cobertura 100%). Tras el
   fix, geo NA 51→0. (Relacionado: si el `nom` queda nulo, el buscador de
   establecimientos los saltaba — al backfillear nombre+geo desde el directorio,
   el buscador los encuentra correctamente.)
3. **Delta H6.** Causa: la homologación canónica usa la dependencia del **año de
   evaluación**, que precede al traspaso 2025. Fix: usar la dependencia **actual**
   del directorio. Resultado verificado: 118 Municipal→SLEP, cifras byte-idénticas.
4. **Pestaña Dependencia "contaminada" (H5).** Resultó **refutado**: el dato ya
   estaba limpio (`cod_depe2 ∈ {1,2,3,4}`); la captura del titular era previa al
   refactor EntityModal. Se blindó `DEPS_OPTS` igualmente (defensa en profundidad).

### Fricciones técnicas (lo que costó)
- **Locale C en Rscript.** `Rscript` corre en `LC_CTYPE=C`: los `grepl` con
  literales acentuados fallan ("regular expression is invalid") y las
  comparaciones `identical(literal_acentuado, json)` dan FALSE espurio. Se
  resolvió verificando **por bytes** (`charToRaw` + secuencias UTF-8) y, donde
  hacía falta leer xlsx con tildes, `Sys.setlocale("LC_ALL","en_US.UTF-8")`. Sin
  esto, varias verificaciones daban falsos negativos que **no** eran bugs de datos.
- **Screenshots en blanco por restauración de scroll.** El navegador headless
  restauraba el scroll tras `reload`, dejando el viewport en una zona vacía; los
  screenshots salían crema. Se resolvió con `history.scrollRestoration='manual'`,
  `scrollTo(0,0)` y/o `preview_resize` a un viewport alto. La verificación DOM
  (preferida) nunca dependió del screenshot.
- **EntityModal no provisto en un tramo previo.** La copia del EntityModal en el
  template se derivó del andamio congelado `entity_modal/`; el rediseño FASE 4
  ajusta **sólo** la copia del template, no el andamio.
- **Estado asíncrono de React en las verificaciones.** Click + lectura en el mismo
  `eval` devolvía estado viejo (setState batched); se separó en evals distintos.

---

## 6. Verificación de invariantes (PARTE B, post-rediseño, en navegador)

| # | Invariante | Resultado | Evidencia |
|---|-----------|-----------|-----------|
| B.1 | EntityModal: 4 pestañas, buscador filtra, selección acota, Escape + backdrop cierran, foco en buscador, role=dialog/aria-modal | **PASA** | tabs=[Región,Comuna,Dependencia,Establecimiento]; "valpa"→Valparaíso; selección SLEP→crumb "dependencia: SLEP"; Escape y backdrop cierran; activeElement=input-search; role=dialog, aria-modal=true |
| B.2 | Dependencia H6: 4 categorías; SLEP ~1578; RBD traspasado=SLEP | **PASA** | Muni 2988 / PSub 3258 / PPag 505 / SLEP 1578; rbd 7894 detalle = "Los Muermos · Los Lagos · SLEP" |
| B.3 | Grado/Año/GSE operan; GSE por código | **PASA** | 2° medio→años 2022–2025; "Medio"→sólo grupo GSE·Medio; pills sin numeración |
| B.4 | Foco Costa Central (60); "volver" funciona | **PASA** | crumb "SLEP Costa Central…60 establecimientos"; volver resetea dep+terr |
| B.5 | Detalle: doble ancla con sig.; 4 paneles paleta+0–100; radar 2 años sólido/discontinuo + leyenda + selector; vértices legibles; drill-down; P-meta; subdim con tildes | **PASA** | "vs su GSE ▼ -13 · sig." + "vs año anterior ▼ -14 · sig."; 4 evol-panel con colores #EE2D49/#FFC92E/#9BC93E/#2A8FD9; radar 1 sólido + 1 discontinuo; vértices "Autoestima 63…"; drill Indicador→Dimensión→Subdim; 4 toggles P-meta; "Autovaloración académica [EST]" |
| B.6 | Leyenda grilla: tildes + tooltip accesible (hover y foco) | **PASA** | 4 leg-item acentuados con ⓘ; hover y foco muestran la definición |
| B.7 | Nombres comuna/EE completos+tildes; dependencia vigente en tarjeta y detalle | **PASA** | "Colegio Artístico Costa Mauco · Quintero · SLEP"; "Curaco de Vélez"; detalle "Quintero · Valparaíso · SLEP · GSE Bajo" |
| B.8 | 0 errores de consola | **PASA** | `preview_console_logs(level=error)` = vacío en toda la verificación |
| B.9 | Screenshots: header, controles, tarjeta, detalle | **PASA** | capturados (header eyebrow+título; barra segmentada; grilla Costa Central; detalle con doble ancla + 4 paneles + radar 2 años) |

**Sin regresiones.** La paleta de 4 indicadores se verificó por color exacto en
leyenda y paneles (codificación de dato, no decoración).

---

## 7. Decisiones del titular registradas

1. **Alcance 4b/2m** (filtro de presentación duro; el parquet conserva los 4
   grados).
2. **"Dependencia", no "Sostenedor"** (término administrativo correcto); SLEP se
   conserva como etiqueta de la categoría 4.
3. **Vigencia de dependencia = actual del directorio** (H6): un EE traspasado
   aparece como SLEP aunque fuera evaluado siendo Municipal. Capa de presentación.
4. **Rediseño = sólo chrome**, conservando azul gobCL + cream y la **paleta de 4
   indicadores intacta** (no la identidad morado/burdeos de la referencia).
5. **Rótulo de nivel = grado** ("4° básico / 2° medio"), no "Educación Básica/Media".
6. **No republicar `docs/` ni traspasar v06** hasta la revisión visual del titular
   (Claude Design).

---

## 8. Pendientes abiertos

1. **45 definiciones largas sin acentuar (H4).** Indicador (4) + dimensión (11) +
   subdimensión (30) viajan en ASCII. **No se acentúan a ciegas:** son párrafos
   largos y no hay fuente acentuada verificable (corpus `.json`/`.md` son ASCII;
   las glosas xlsx son diccionarios de variables; el `marco_evaluacion_idps_2025.pdf`
   / `subdimensiones_idps.pdf` requerirían extracción + match propensos a error).
   **Recomendación:** el titular provee el texto correcto, o se hace un pase
   dedicado con la fuente oficial. Los **nombres** (indicador/dimensión/subdim) sí
   están acentuados.
2. **Republicación de `docs/` + traspaso v06.** Esperan la revisión visual. El
   motor está completo en `40_salidas/motor_idps.html`; `docs/index.html` sigue en
   la versión previa (divergente, a propósito).
3. **Casing de los labels de control.** Se aplicó `uppercase` por la descripción
   del titular; la referencia real usa title case. Reversible si se prefiere
   fidelidad estricta a la referencia.

No quedaron marcas `# REVISAR` en el código.

---

## 9. Estado de cifras

- `40_salidas/intermedios/idps_largo.parquet` **md5 = `50d9de4f1fc80259d29f499cdf46d9e1`**,
  **idéntico** al inicio y al final de los tramos 3–4. Nunca se regeneró: todo el
  trabajo fue `run_all(only=35)` (sólo template/35.R/config).
- **prom / dif / sigdif / difgru / sigdifgru / niv_*_por NUNCA cambiaron.** Se
  verificó por `all.equal`/`identical` de los bloques `ind`/`dim`/`niv` del JSON
  embebido pre/post en cada cambio sensible (H6, tildes, truncamiento). La
  dependencia (H6) y los nombres (H1/H2) son **atributos de etiqueta**, no cifras
  de medición.
- Los catálogos intermedios trackeados (`comunas_chile`, `sleps_chile`,
  `establecimientos_chile`, `catalogo_idps`) tampoco se regeneraron en el tramo 4.

---

## 10. Notas para el revisor

- **Mirar con ojo crítico:**
  - El **mapeo 5→4 de dependencia** (`CW_DEPE_DIRECTORIO_A_IDPS`): la decisión de
    mandar Adm. Delegada (dir=4) a Part. subvencionado (idps=2) es el criterio de
    la Agencia confirmado en la auditoría, pero vale revisarlo contra las glosas.
  - El **fallback** de `est_attr.cod_depe2 = coalesce(dir, idps)`: si el directorio
    no cubriera un RBD, cae al valor por-evaluación. Hoy cobertura 100%, pero el
    fallback existe por seguridad.
  - La **decisión de no agregar** sigue siendo el corazón: cualquier futura
    "comparación de territorios" (como en el motor hermano) NO debe promediar entre
    establecimientos; el motor hermano compara **categorías de desempeño** (otra
    métrica), no promedios IDPS.
- **Deuda:** las 45 definiciones largas en ASCII (§8.1) y la republicación
  pendiente (§8.2).
- **Auditar en la próxima sesión:** (a) cuando se republique `docs/`, confirmar
  que `docs/index.html` == `40_salidas/motor_idps.html` (hoy divergen a propósito);
  (b) revisión visual del rediseño con el titular antes de congelar la piel;
  (c) si el titular aporta las definiciones acentuadas, aplicarlas con verificación
  por bytes y P-meta 1:1.
- **Confianza:** las cifras están protegidas por construcción (only=35 + md5
  estable + verificación byte a byte). El riesgo residual está en la **piel**
  (estética, a revisar visualmente), no en el dato.

---
*Fin del log — sesión 6.*
