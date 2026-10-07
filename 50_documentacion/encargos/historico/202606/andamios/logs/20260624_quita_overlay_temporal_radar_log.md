# Log — Retiro del overlay temporal (año comparado) del radar de la ficha (s21)

> Ejecución autónoma del encargo corto "quita overlay temporal del radar". Fecha:
> 2026-06-24. Ejecutor: Claude Code (Opus 4.8). Rama: `main`. **Push NO; docs/ NO
> tocado.** Build local regenerado. Log SIN commitear.

---

## 1. Resumen

El radar de la ficha mostraba tres trazos: sólido (EE), punteado gris `2 4` (GSE de
referencia, s21) y punteado naranja `4 3` (overlay temporal = comparación con otro
año). Por decisión del titular, la comparación entre años vive en la **Vista histórica**;
el radar de la ficha queda con SOLO 2 trazos (EE + GSE). Cambio quirúrgico, template-only;
payload byte-idéntico; anclas y vista histórica intactas.

## 2. Paso 0 — diagnóstico: **LIMPIO** (vía libre)

Los tres trazos en `Radar`:
- **EE actual** (sólido `var(--azul)`): prop `axes` → se conserva.
- **Overlay temporal** (punteado `4 3` `var(--cmp-year)`): prop `axesB`/`colB`/`labelB`
  → **se retira**.
- **GSE** (punteado `2 4` `var(--gris)`): prop `axesG`/`colG`/`labelG` → se conserva.

**Acoplamiento:** el overlay temporal se alimentaba de `cmpA` (estado) → `cmpAgno` →
`imB`=`indOf(rbd,grado,cmpAgno)` → `axIndB`, más `aniosCD`/`cmpPrev`/`cmpDef`/`cmpOpts`
(selector de año) y el `<select>`/hint/leyenda "comparación". **TODO exclusivo del
radar**: ninguna de esas variables alimenta las anclas ni la vista histórica.
- Las anclas **"vs evaluación anterior"** (`d.dif`/`d.sigdif`) y **"vs su GSE"**
  (`d.difgru`/`d.sigdifgru`) leen el dato del **año actual** (`im=indOf(...,agno)`), NO
  dependían de `cmpAgno`. El texto del bloque azul ("diferencia en relación a la
  evaluación anterior") se comunica con esas anclas/texto, NO con el trazo del radar.
- La **Vista histórica** usa su propio eje (`serieEje`/`eje_historico`), no `cmpA`.

→ Remoción limpia, sin detención.

## 3. Qué se retiró (todo en `35_motor_template.html`)

- **Componente `Radar`:** el bloque de dibujo de `axesB` (path `4 3` + círculos), las
  props `axesB`/`colB`/`labelB`, la constante `COLB`, y esas props de las deps del
  `useEffect`. Comentario de cabecera actualizado.
- **Ficha:** estado `cmpA`/`setCmpA` + su `useEffect` de reset; los cómputos `aniosCD`,
  `cmpPrev`, `cmpDef`, `cmpAgno`, `imB`, `axIndB`, `cmpOpts` (todos exclusivos del
  overlay). En el `<Radar>` se quitaron las props `axesB`/`colB`/`labelB`.
- **Leyenda del radar:** ahora 2 entradas — "Resultado del establecimiento" (sólido) y
  "Promedio del mismo GSE" (punteado, condicional a `hasGse`). Se eliminó la entrada
  "· comparación", el `<select>` "Comparar radar con" y el `cmp-hint`.
- **CSS huérfano (inequívocamente exclusivo del overlay → removido):** `.radar-cmp
  .cmp-label`, `.radar-cmp select`, `.radar-cmp .sw-line.cmp`, `.radar-cmp .cmp-hint`, y
  el token `--cmp-year` (solo lo usaba `.sw-line.cmp`). Conservados `.radar-cmp`,
  `.radar-cmp .leyenda`, `.sw-line` (EE) y `.sw-line.gse` (GSE).
- **Generador (`35_generar_motor_html.R`): NO se tocó.** El overlay reusaba el `prom`
  del payload (vía `indOf`), no tenía campo propio → 0 dead code en R.

Verificado: 0 referencias huérfanas a `cmpA/cmpAgno/axIndB/imB/aniosCD/cmpPrev/cmpDef/
cmpOpts/axesB/colB/labelB/COLB` y 0 a `cmp-year/cmp-label/cmp-hint/sw-line.cmp`.

## 4. Verificación (navegador, RBD 10 4b 2025)

- Radar con **exactamente 2 trazos**: sólido `var(--azul)` (EE) + punteado `2 4`
  `var(--gris)` (GSE). **0 trazos naranja `4 3`.**
- Leyenda con 2 entradas ("Resultado del establecimiento", "Promedio del mismo GSE"),
  sin huérfanos; selector "Comparar radar con" ausente.
- Anclas **"vs su GSE"** y **"vs año anterior"** presentes en las rcard (intactas).
- **Vista histórica intacta:** 15 bloques `BarrasAnio` + 15 marcas de tendencia (la
  comparación entre años sigue ahí).
- Render sin errores de consola (solo warning benigno de Babel CDN).

## 5. Invariantes 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet intocable | **PASA** | md5 `4c764d8c…` igual; generador no tocado. |
| Fidelidad censal 0 | **PASA** | Payload byte-idéntico (`identical()=TRUE`) al build s21 desplegado; `prom_gse` 69.646 sin cambio. |
| Polígono GSE intacto | **PASA** | `axesG`/trazo `2 4`/`prom_gse` no se tocaron; sigue dibujándose. |
| Anclas intactas | **PASA** | "vs su GSE" y "vs año anterior" presentes (no dependían del overlay). |
| Vista histórica intacta | **PASA** | 15 `BarrasAnio` + 15 `HistTrend` renderizan. |
| Bug s7-1 | **PASA** | Comentario CSS nuevo sin `*/` interno. |
| Cambio quirúrgico (B.3) | **PASA** | Solo se retiró el overlay temporal; trazo EE, GSE y vista histórica sin tocar. |

## 6. Estado / pendientes

- **Commit:** `ff1e11f` — `fix(radar): retira el overlay temporal (año comparado) del
  radar de la ficha; la comparacion entre anios vive en la vista historica`. `git add`
  path-scoped (solo template). **Sin push; docs/ intacto.** Build local regenerado para
  revisión visual del titular.
- Pendiente previo vivo: `# REVISAR jerarquía .axis-lab.b` (s20).
