# Log de ejecución — Rediseño 3 pantallas · FASE 4

**Pantalla "Comparación entre territorios" (comparador)** · Sesión 8 · 2026-06-20

Encargo autónomo (ultracode). Última fase del rediseño a 3 pantallas. Solo se
tocó `30_procesamiento/35_motor_template.html` (+ regeneración `only=35` de
`40_salidas/motor_idps.html`). **No** se republicó `docs/` (tarea posterior del
titular). **No** se tocó 31–34 ni `35_generar_motor_html.R`.

---

## Invariantes (verificados)

| 🔒 Invariante | Estado |
|---|---|
| md5 `idps_largo.parquet` intacto | `50d9de4f1fc80259d29f499cdf46d9e1` antes **y** después |
| Cero agregación (celda = conteo de EE por estado, % (n), nunca promedio) | ✔ re-derivado a mano vs `idps_largo` (ver abajo) |
| Lee-no-deriva (solo `sigdifgru`; sin GSE absoluto, sin `#B7AC96`) | ✔ `grep -c B7AC96` = 0 en el HTML generado |
| Paleta 4 indicadores intacta (`#EE2D49 #FFC92E #9BC93E #2A8FD9`) | ✔ solo en swatches de columna (`th-sw`); colores de barra = estado |
| Comentarios CSS sin `*/` literal interno (Bug s7-1) | ✔ |
| `only=35` no regenera `idps_largo` | ✔ el generador solo lee el parquet |

---

## Decisiones metodológicas implementadas

- **D-s8-1 (AÑO):** sin selector de año. `agnoCmp = (grado_anios[cmpGrado]).at(-1)`,
  igual para los 4 territorios. Territorio sin EE ese año → celda "sin dato"
  (N=0), nunca se desliza a un año anterior. Año preliminar → `*` en el banner.
- **D-s8-2 (NIVEL):** segmentador propio `cmpGrado` (4b/2m) en el banner, default 4b.
- **D-s8-3 (SELECCIÓN):** EntityModal reutilizado con `buildListCmp` propio
  (tabs SLEP/Comuna/Región, `kind ∈ {slep,comuna,region}`), `addTerr` agrega
  (máx 4, sin duplicados por `kind+cod`). Chip inicial = SLEP foco (Costa Central).
- **D-s8-4 (META chip):** "N comunas · N establecimientos" calculado del roster
  real en `cmpGrado/agnoCmp` (todos los GSE), recomputado por nivel — NO hardcodeado.
- **D-s8-5 (kind "slep"):** rama `if(t.kind==="slep"){ if(String(e.cod_slep)!==String(t.cod)) continue; }`
  en `rosterTerr` (cod_slep vive en `est[rbd]`, igual que el foco de App).

---

## Cambios en `35_motor_template.html`

1. **CSS** — bloque Fase 4: `.cmp-chrome/.cmp-bar/.cmp-eyebrow/.cmp-title/.cmp-noagg/
   .cmp-controls/.cmp-chips/.cmp-chip/.cmp-x/.cmp-add/.cmp-invite/.cmp-gse-ctl/
   .cmp-table/.th-sw/.td-terr/.cmp-empty/.cmp-tscroll`. Adaptado de Propuesta
   IDPS.html a tokens del motor. Reusa `.gse-sec` y `.leyenda.pan-state-leg` de Fase 3.
2. **EntityModal** — prop opcional `title` (default = texto territorial; el
   comparador pasa "Agregar territorio a la comparación"). Sin cambios de lógica.
3. **Comparador** — `SLEPS_OPTS`, `TABS_CMP`, `buildListCmp`, `cmpPlaceholderFor`,
   `rosterTerr(t,grado,agno)` y el componente `Comparador`. La celda es
   `<StackedBar rep={repartoInd(itemsTerrGse, indId, cmpGrado, agnoCmp)}/>`
   (maquinaria de Fase 3 reutilizada tal cual, parametrizada por territorio,
   sin filtro de dependencia).
4. **App** — estado nuevo: `cmpTerr / cmpGrado / cmpGseVis / cmpModalOpen` +
   `agnoCmp` derivado; handlers `addTerr / removeTerr / toggleCmpGse`.
   Router: stub `comparar` → `<Comparador/>`; picker-strip oculto en `comparar`;
   segundo `<EntityModal/>` para el comparador.
5. **Higiene** — comentario STALE de L907 actualizado (3 pantallas funcionales);
   `ScreenStub` eliminado (su único uso, el stub de `comparar`, ya no existe;
   la invitación de ficha-sin-EE usa `.screen-stub` directo, intacta).

---

## Re-derivación a mano de UNA celda (Paso 7, punto 4)

Conteo independiente desde `idps_largo.parquet` (familia="indicador") + join
`sleps_chile.parquet`, contando `sigdifgru ∈ {-1,0,1}` con `prom` no-NA.

**Celda: SLEP Costa Central × GSE Medio bajo (cod 2) × Autoestima (id 1) · 4b · 2025**

| | ▼ bajo | = neutro | ▲ sobre | N |
|---|---|---|---|---|
| R (ground truth) | 4 | 15 | 2 | 21 |
| StackedBar (DOM) | 4 (19%) | 15 (71%) | 2 (10%) | 21 |

Suma 19+71+10 = **100%**. Idéntico. Confirmado también para Convivencia (id2:
9/10/2) en 4b, y los 4 indicadores en 2m/2025 (Autoestima 1/5/0, Convivencia
2/2/2, Participación 1/3/2, Hábitos 1/3/2; todos N=6) — todos 1:1 con el conteo
independiente.

---

## Verificación (10 puntos)

1. **md5 parquet** idéntico antes/después (`50d9de4f…`). ✔
2. **`grep -c B7AC96`** en HTML generado = **0**. ✔
3. **Paleta 4 indicadores** intacta — swatches de columna rgb(238,45,73)/
   (255,201,46)/(155,201,62)/(42,143,217). ✔
4. **Cero agregación** comprobada (celda re-derivada arriba). ✔
5. **Suma de cada barra = 100%** (o "sin dato" si N=0; GSE Alto de Costa Central
   en 4b/2025 = "sin dato", coincide con la fuente). ✔
6. **Agregar/quitar territorios:** add 1→2 (invita desaparece), dedup mantiene 2,
   máx 4 (oculta "+ agregar"), ✕ baja a 3 (reaparece "+ agregar"). ✔
7. **Cambiar Nivel** re-renderiza (4b 4 filas → 2m 3 filas) y el año salta solo
   al más reciente del grado (2m → 2025, preliminar → `*`), con datos correctos. ✔
8. **0 errores de consola** (solo el warning estándar del Babel in-browser). ✔
9. **Sin regresión:** territorial (picker visible, 4 secciones GSE, 60 tarjetas,
   16 barras, crumb correcto) y ficha (radar + 4 paneles + anclas vs GSE / vs año)
   OK; grado territorial independiente del `cmpGrado`. ✔
10. **Comentario STALE** de L907 reemplazado; `ScreenStub` retirado. ✔

---

## Pendiente (cierre v08, lo coordina el titular)

- Republicar `docs/index.html` (= `motor_idps.html`).
- Traspaso v08.
- Evaluar/commitear este log.
