# Log — P-DOC-CFG-CRUZADA (cierre, DEC-s23-3) — s24

**Fecha:** 2026-06-24
**Modo:** autonomo, secuencial. Un solo cambio conceptual (regeneracion de doc), commit atomico.
**Alcance:** regenerar la suite standalone, verificar offline + sin SIMCE, versionar
`50_documentacion/suite/documentar.R`. NO edita la cfg (ya saneada). NO toca datos/motor.
**Base:** HEAD previo `f531cb5`.

---

## 1. Resumen

`documentar.R` quedo sin commitear en s23 (DEC-s23-3) por sospecha de contenido cruzado de
`slep_simce_adecuado`. Verificado que la cfg de disco YA esta limpia (0 marcadores SIMCE). Se
regenero la suite standalone, se verificaron los 4 HTML reales (offline + sin SIMCE) y se
versiono `documentar.R`. Ninguna condicion de detencion se activo.

**Commit:** `6e7d4de` — `docs(suite): regenera con cfg saneada y versiona documentar.R
(cierra DEC-s23-3, P-DOC-CFG-CRUZADA)` (1 archivo: `documentar.R`; +10/-5). **Sin deploy, sin push.**

---

## 2. Fase 0 — precondicion + estado real

- `npm --version` → **11.12.1** (disponible; no se activa detencion (a)).
- `git status --short 50_documentacion/suite/` → solo `documentar.R` en ` M`. Nada mas que evitar.
- Re-confirmacion del hallazgo (grep `simce|nalu|palu|adecuad|comparacion.html|marca_eda|
  cod_com_rbd|nuble|ñuble` en `documentar.R`) → **0**. La cfg esta limpia; no se edita (🔒 B.3).

---

## 3. Fase 1 — regeneracion

- `Rscript -e 'source("50_documentacion/suite/documentar.R")'` desde la raiz.
- Genero 4 HTML enlazados → inlinar_suite (npm pack de lucide-static) → 4 `*_standalone.html`,
  y borro los enlazados (limpiar_enlazados=TRUE).
- Los ~50 warnings "US-ASCII to UTF-8 … valid UTF-8" son benignos (locale; UTF-8 valido).
- inlinar_suite NO aborto por iconos lucide inexistentes (no se activa detencion (b)).

---

## 4. Fase 2 — verificacion (sobre los HTML reales)

### Offline (referencias de RED por archivo)
| standalone | http total | http no-namespace | recursos cargables (link/script/img/use) |
|---|---|---|---|
| arquitectura_general_…  | 19 | **0** | **0** |
| arquitectura_…          | 0  | **0** | **0** |
| documentacion_general_… | 5  | **0** | **0** |
| documentacion_proyecto_…| 0  | **0** | **0** |

El unico `http://` que aparece (19 y 5) es `http://www.w3.org/2000/svg` — el **namespace XML de
los SVG embebidos** (iconos lucide inlineados), que NO descarga nada de la red. **Recursos de red
reales = 0 en los 4.** Offline cumplido; no se activa detencion (c).

### Sin SIMCE
`grep -icE 'simce|nalu|palu|adecuad'` por archivo → **0 en los 4**. No se activa detencion (d).

### Iconos / fuentes embebidos (spot-check)
arquitectura_general: `data:font` = 6, `<i data-lucide` = **0**, `<svg` = 19. Iconos como SVG
embebido (no `<i data-lucide>` ni `<script>` de lucide); fuentes como `data:` URIs.

### Enlazados borrados
`ls *.html` → solo los 4 `*_standalone.html`. Los enlazados intermedios fueron borrados.

---

## 5. Invariantes 🔒

| Invariante | Resultado | Evidencia |
|-----------|-----------|-----------|
| NO editar `documentar.R` (cfg sana) | **PASA** | Solo se regenero; el diff de `documentar.R` es lo que ya estaba modificado en disco (la cfg saneada previa), no una edicion nueva de esta sesion. |
| Los 4 `*_standalone.html` gitignorados; no añadir | **PASA** | `git check-ignore` imprime las 4 rutas; `git status` no los muestra; commit no los incluye. |
| `fonts/`/`assets/` no se versionan | **PASA** | No aparecen en `git status`; no añadidos. |
| Commit = SOLO `documentar.R` | **PASA** | `git diff --cached --stat` y `git show --stat` = 1 archivo (`documentar.R`). |
| Parquet `idps_largo.parquet` / motor intactos | **PASA** | md5 `4c764d8c…`; `motor_idps.html`/template/`docs` sin cambios. |

---

## 6. Estado de git

- **HEAD = `6e7d4de`** (este commit). Local `ahead 3` de origin/main: backlog del titular
  (`988fd05`) + CSS muerto (`f531cb5`) + este (`6e7d4de`).
- Commit toca SOLO `50_documentacion/suite/documentar.R`.
- **Sin push, sin deploy** (gate del titular).
- Working tree residual (sin commitear, invariante de no-commit): SETTINGS, snapshots de
  `50_documentacion/estructura/`, untracked viejos (resena, logs s21–s24, traspasos v20–v23) y
  los `*_standalone.html` regenerados (gitignorados, no versionables por diseño).
- Este log queda **sin commitear** para revision.

---

## 7. Pendientes / notas

- DEC-s23-3 cerrado: `documentar.R` versionado.
- Push pendiente del gate del titular (hay 3 commits locales sin publicar).
