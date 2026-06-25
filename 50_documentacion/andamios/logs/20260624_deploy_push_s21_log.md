# Log — Deploy a docs/ + push de los commits del día (s21)

> Ejecución autónoma del encargo "deploy + push s21". Fecha: 2026-06-24.
> Ejecutor: Claude Code (Opus 4.8). Rama: `main`. Gate visual aprobado por el titular.
> Log SIN commitear.

---

## 1. Resumen

Se desplegó el build local (con todo lo del día: lote UI directo s20 + polígono GSE +
afinación de textos) a `docs/index.html`, se versionó la decisión del polígono GSE y 3
logs de ejecución, y se pushearon los 15 commits locales. `origin/main` quedó en
`397117b`. Parquet intacto.

## 2. Estado previo (Paso 0)

- 12 commits locales sin pushear (lote s20: `92ec92b`,`a1226d8`,`10c1c0a`,`a6971a6`,
  `de142c0`,`eabf544`; GSE+afinación: `4493bcf`,`11e7d62`,`ef15f5e`,`a04b312`,`c775d48`,
  `9a50088`).
- Build local md5 `2ef9e1b86baf3398e586c8cdb0179e82`; docs/ aún en s20 `0699503d…`.
- Decisión `20260624_decision_poligono_gse_radar.md`: **presente** en `activa/decisiones/`
  pero **untracked** → se versionó (Commit 2).
- Parquet md5 `4c764d8c…`.

## 3. Deploy

Patrón replicado del último deploy s20 (`3925e84`, que commiteó `40_salidas/motor_idps.html`
+ `docs/index.html`): `cp 40_salidas/motor_idps.html docs/index.html`. Verificado
`md5(docs)==md5(build)==2ef9e1b86baf3398e586c8cdb0179e82` (idénticos).

## 4. Commits creados (path-scoped, atómicos)

| # | Hash | Archivos | Título |
|---|---|---|---|
| 1 | `80f4ba6` | `40_salidas/motor_idps.html`, `docs/index.html` | deploy: motor con poligono GSE, lote UI directo s20 y afinacion de textos (s21) |
| 2 | `95e3576` | `…/decisiones/20260624_decision_poligono_gse_radar.md` | docs(decision): poligono GSE de referencia en el radar (reapertura ponderacion) |
| 3 | `397117b` | 3 logs (poligono_gse_texto_leyenda, afinacion_textos_gse, diagnostico_gse_reconstruccion) | docs(logs): registros de ejecucion del poligono GSE y afinacion (s21) |

## 5. Push

`git push origin main` → `3e3ef96..397117b` (15 commits: 12 previos + 3 nuevos).
`origin/main..main = 0`; `local == origin == 397117b`.

## 6. Defensa de gobernanza (detención (a)/(c))

- **Add path-scoped**: solo entraron al push los 6 archivos previstos (build, docs,
  decisión, 3 logs). Nada inesperado.
- **NO entraron** (siguen sin versionar, artefactos pre-existentes del titular, ajenos
  al deploy): `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (modif.), snapshots de
  `estructura/` (rotación del escáner), `resena_slep_idps.md`, `traspaso_cierre_v20.md`,
  y el log `20260624_s21_lote_directo_log.md` (NO listado en el encargo). El titular
  decide su versionado.
- Sin datos sensibles ni extensiones prohibidas en el diff (HTML público Rama A + .md
  UTF-8). Sin `.DS_Store` ni archivos de datos.

## 7. Cierre

- **GitHub Pages**: la fuente es `docs/index.html` en `main`; servirá el build nuevo
  (`2ef9e1b8…`) sin acción extra.
- **Parquet md5 `4c764d8c…` intacto** (no se tocó).
- Pendiente: `20260624_s21_lote_directo_log.md` sin versionar (no listado); decisión
  del titular si entra en una limpieza posterior.
- Pendiente previo vivo: `# REVISAR jerarquía .axis-lab.b` (s20).
