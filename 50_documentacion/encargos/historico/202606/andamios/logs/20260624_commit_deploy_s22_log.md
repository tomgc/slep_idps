# Log de cierre — P-COMMIT-DEPLOY-S22

**Fecha:** 2026-06-24
**Tarea:** cierre del lote de mejoras de presentacion del motor (sesion 22): commit del
ultimo item (#141), regeneracion y commit del build, commit de artefactos de sesion,
deploy a GitHub Pages y push.
**Modo:** autonomo, secuencial. Rutas absolutas, commits path-scoped (nunca `git add .`).
**Base:** `origin/main` en `41a3406` (s21). 7 commits locales previos (Batch A + #138/#139/#140).

---

## 1. Resumen

Se cerro el lote s22: se commiteo #141 (texto editorial "que refleja un puntaje alto" por
indicador, repartido en generador + template, un solo commit), se regenero el build desde el
estado commiteado y se audito el delta de payload (solo `nivel_alto`, ninguna cifra), se
commito el build, los 6 artefactos de sesion de s22, se desplego a `docs/index.html` y se hizo
push a `origin/main`. **11 commits** quedaron publicados (`41a3406..d35027a`). Parquet intacto.

---

## 2. Inventario de commits (`41a3406..HEAD`, 11 commits)

| # | Hash | Tipo | Titulo |
|---|------|------|--------|
| 1 | `50baa41` | style | restaura jerarquia .axis-lab.b por peso (cierra REVISAR s20) |
| 2 | `87cc923` | style | sube sutilmente el alto de las barras (#22) |
| 3 | `0e1365b` | feat | leyenda visual de la media movil (#12) |
| 4 | `3cf666c` | feat | sube el tope de territorios 4->10 via CMP_MAX_TERR (#16/#17) |
| 5 | `7b9c968` | style | color estado sin-diferencia gris-azulado (#138) |
| 6 | `bd2829a` | feat | senaletica de significancia temporal en barras del historico (#139) |
| 7 | `6512c91` | feat | etiqueta externa para segmentos finos del comparador (#140) |
| 8 | `2ac714c` | feat | texto editorial que-refleja-un-puntaje-alto por indicador (#141) |
| 9 | `9511235` | build | regenera motor_idps.html con el lote s22 (#138-#141) |
| 10 | `f738df8` | docs | encargos y logs de los batches A/B1/B2 de la sesion 22 |
| 11 | `d35027a` | deploy | publica el lote s22 (#138-#141) en GitHub Pages |

Commits nuevos de ESTE turno: #141 `2ac714c`, build `9511235`, docs-s22 `f738df8`, deploy `d35027a`.

Archivos tocados en todo el rango (10, todos de s22):
`30_procesamiento/35_generar_motor_html.R`, `30_procesamiento/35_motor_template.html`,
`40_salidas/motor_idps.html`, `docs/index.html`, y los 6 `*_s22*` (3 encargos + 3 logs).

---

## 3. Delta de payload (R-PAYLOAD-DELTA) — evidencia

**Metodo.** El payload viaja embebido como base64+gzip en `atob("…")`. Se descomprime
(base64_dec -> memDecompress gzip -> JSON) y se compara estructuralmente en R
(`jsonlite::fromJSON` + `identical`), no por diff textual.

**Baseline correcto.** El build del working tree ya tenia `nivel_alto` (regenerado en Batch B2).
Para auditar el invariante de datos de TODO el lote s22 se uso como baseline el build de
`origin/main` (`41a3406`, s21, mismo parquet `4c764d8c…`, SIN `nivel_alto`), extraido con
`git show 41a3406:40_salidas/motor_idps.html`. Se comparo contra el build nuevo regenerado.

**Resultado (s21 -> build nuevo):**
```
claves top-level iguales: TRUE
resto del payload (sin indicadores) IDENTICO: TRUE
n indicadores old/new: 4 / 4
  ind 1..4: compartidos_identicos=TRUE  anadidos={nivel_alto}  quitados={}
```
El unico delta del payload de todo el lote s22 es la aparicion de `nivel_alto` en los 4
indicadores. Todo lo demas (establecimientos, roster, ind, dim, niv; cifras prom/dif/sigdif/
difgru/sigdifgru/prom_gse) es **byte/estructura identico**. **Ninguna cifra cambio.**

**Sanity (build vigente B2 -> build nuevo):** identico (0 anadidos, 0 quitados) -> el build
commiteado reproduce exactamente el payload del working tree previo.

---

## 4. Verificacion de invariantes 🔒

| Invariante | Resultado | Evidencia |
|-----------|-----------|-----------|
| `idps_largo.parquet` md5 `4c764d8c…` intocable | **PASA** | md5 pre/post regeneracion = `4c764d8c9f0bf70004f8aa52661ae901`. |
| #141 nivel INDICADOR (0 disclosures en dim/subdim) | **PASA** | `nivel_alto` solo se consume como `ind.nivel_alto` (2 refs); no existe `dimo./sub.nivel_alto`. Navegador (RBD 1692): 4 disclosures, todos en `.indp-def`, 0 en `.indp-body`/`.dimb`, cerrados por defecto. |
| Delta de payload acotado a `nivel_alto`, ninguna cifra cambia | **PASA** | §3: resto identico, solo `nivel_alto` anadido en los 4 indicadores. |
| NO commitear nada que no sea de s22 | **PASA** | Los 11 commits tocan solo motor + 6 docs s22. `git diff --stat 41a3406..HEAD` sobre SETTINGS/estructura/documentar.R/traspasos = vacio. |
| Render sin error de consola | **PASA** | Build commiteado servido en preview: 4 disclosures correctos, sin errores de consola (solo warning benigno de Babel). |

---

## 5. Estado final

- **HEAD = origin/main = `d35027a`** (push OK: `41a3406..d35027a`). Rama al dia (`main...origin/main`).
- **Working tree residual (sin commitear, intencional — invariante de no-commit):**
  - modificados: `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `documentar.R`, snapshots de
    `50_documentacion/estructura/` (estructura_actual.md/.txt + borrados de snapshots viejos).
  - untracked: `resena_slep_idps.md`, logs `20260624_deploy_push_s21_log.md` y
    `20260624_quita_overlay_temporal_radar_log.md`, snapshots `20260624_19210*/19264*`,
    traspasos `v20`/`v21`/`v22`.
  - Todos de otras sesiones o de P-DOC-REGEN; NO pertenecen al lote s22.
- Este log queda **sin commitear** para revision del titular.

---

## 6. Pendientes / notas para el revisor

- El deploy quedo publicado en GitHub Pages (`docs/index.html` == `40_salidas/motor_idps.html`,
  verificado con `cmp`). Propagacion de Pages puede tardar unos minutos.
- Residual del working tree: decidir si los snapshots de estructura, `documentar.R`, SETTINGS y
  los traspasos `v20/v21/v22` se commitean en su propio lote (P-DOC-REGEN / cierre de sesion),
  fuera del alcance de s22-motor.
- `traspaso_cierre_v22.md` quedo untracked (no estaba entre los 6 artefactos de s22 del encargo);
  candidato natural al cierre documental de la sesion 22, a criterio del titular.
