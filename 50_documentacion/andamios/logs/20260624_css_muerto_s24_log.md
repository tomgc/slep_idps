# Log — P-CSS-MUERTO: elimina CSS huerfano del template (s24)

**Fecha:** 2026-06-24
**Modo:** autonomo, secuencial. Un solo cambio conceptual (higiene CSS), commit atomico.
**Alcance:** `30_procesamiento/35_motor_template.html` (solo CSS inerte) + build regenerado.
**Base:** HEAD `988fd05`.

---

## 1. Resumen

En s23 se eliminaron el componente `PanelEvolucion` y el rotulo "Mirada integral · 4
indicadores", dejando reglas CSS huerfanas. Este encargo las elimina: bloque `.evol-*`
completo (comentario + 12 reglas), `.evol-sw` del selector compartido, `.hist-main .evol-panel`
y `.fr-head`. Ninguna de estas clases se usa en JSX (0 apariciones en className, verificado).
Render sin cambio; **payload byte-identico**; parquet intacto.

**Commit:** `f531cb5` — `style(motor): elimina CSS muerto .evol-*/.fr-head (P-CSS-MUERTO)`
(2 archivos: template + build; 2 insertions, 32 deletions). **Sin deploy, sin push.**

---

## 2. Fase 0 — estado real

- Working tree de template/build: limpio antes de empezar.
- `grep className=…(evol-|fr-head)` → **0 lineas**: ninguna clase viva en JSX (no se cumple la
  condicion de detencion (a)).
- Clases a borrar localizadas por contenido (no por linea): `.evol-*` (13 lineas: comentario +
  12 reglas), `.evol-sw` en selector compartido, `.hist-main .evol-panel`, `.fr-head`.

---

## 3. Fase 1 — 4 ediciones quirurgicas

| # | Edicion | Resultado |
|---|---------|-----------|
| A | Bloque `.evol-*` completo (comentario `/* Evolucion: small-multiples 2x2 … */` + 12 reglas) | eliminado; `.nota` arriba y comentario "Disparador de navegacion" abajo intactos |
| B | `.evol-sw` quitado del selector compartido | `.indp-dot,.rcard-dot,.th-sw,.sw{box-shadow:…}` conservado (regla viva) |
| C | `.hist-main .evol-panel{border:0;padding:0;}` | linea eliminada; reglas `.hist-*` vecinas intactas |
| D | `.fr-head{…}` | linea eliminada; `.ficha-radar` arriba y `.fr-note` abajo intactas |

**Verificacion post-edicion:** `grep "evol-\|fr-head"` deja UNICAMENTE el comentario JS de
`HistTrend` ("… las evol-marks inter-anuales del componente de lineas.") — VIVO, esperado
(invariante 🔒). **0 reglas CSS** `.evol-*`/`.fr-head`. Diff: -16/+1 (las 4 ediciones).
`.ancla`/`.arr` (L133-137) y `.fr-note` intactas.

---

## 4. Fase 2 — regeneracion y verificacion

- **Parquet** `idps_largo.parquet` md5 pre/post = `4c764d8c9f0bf70004f8aa52661ae901` (intocado).
- **Payload byte-identico:** baseline = payload del build de HEAD (antes del cambio); tras
  `run_all(only=35)`, `cmp` del JSON descomprimido (base64→gunzip) baseline vs nuevo = **IDENTICO**.
  (No se cumple la condicion de detencion (b): el cambio fue solo CSS inerte.)
- **Build limpio:** `grep` de reglas `.evol-*{`/`.fr-head{` en `40_salidas/motor_idps.html` = 0;
  `.fr-note`/`.ancla`/`.arr` siguen presentes.
- **Render (RBD 1692, viewport 1280):** radar SVG **300×300**; las 4 `.rcard-anc` en **1 fila**
  (grid 335/330/335); "Convivencia" con 30px de holgura (sin colision, #8 intacto); `.fr-note`
  viva; "Mirada integral" y `.fr-head` ausentes; **0 errores de consola**. Render identico al de s23.

---

## 5. Invariantes 🔒

| Invariante | Resultado | Evidencia |
|-----------|-----------|-----------|
| `.arr`/`.ancla` vivas (las usa `<Ancla/>`) | **PASA** | Reglas L133-137 intactas; solo se borro `.evol-mark .arr` (distinta, muerta). |
| Parquet md5 `4c764d8c…` intocable | **PASA** | md5 pre/post identico. |
| Payload byte-identico | **PASA** | `cmp` baseline vs nuevo = identico. |
| `HistTrend` y su comentario ("evol-marks") vivos | **PASA** | No se toco; el comentario es la unica mencion "evol-" restante (esperada). |
| `.fr-note` viva | **PASA** | Regla conservada; `<p className="fr-note">` renderiza en la tarjeta del radar. |

---

## 6. Estado de git

- **HEAD = `f531cb5`** (mi commit). Local `ahead 2` de origin/main: incluye el commit de
  backlog previo del titular (`988fd05`, no mio) + este (`f531cb5`).
- Commit toca SOLO `30_procesamiento/35_motor_template.html` y `40_salidas/motor_idps.html`.
- `docs/index.html` — **NO tocado** (deploy es gate del titular).
- **Sin push.** Working tree residual (sin commitear, invariante de no-commit): documentar.R,
  SETTINGS, snapshots de `50_documentacion/estructura/`, untracked viejos (resena, logs
  s21/s22/s23/overlay, traspasos v20–v23).
- Este log queda **sin commitear** para revision.

---

## 7. Pendientes / notas

- Deploy a `docs/` y push pendientes del gate del titular (este encargo cierra solo el commit).
- Higiene CSS muerta de s23 cerrada: ya no quedan reglas `.evol-*`/`.fr-head` huerfanas.
