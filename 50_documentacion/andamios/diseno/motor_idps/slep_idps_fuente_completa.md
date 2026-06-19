# slep_idps — Código fuente completo

Motor de Indicadores de Desarrollo Personal y Social (IDPS) · SLEP Costa Central.
Maqueta React 18 + D3 v7 (Babel en cliente). Datos de ejemplo (0–100, deterministas).

Adjunta este archivo junto con `PROMPT.md` en una conversación de Claude.
Las fuentes (.otf de gobCL / Museo Sans) no se incluyen aquí; están en `fonts/` del proyecto
y tienen fallback a system-ui.

---

## Índice de archivos

- `Motor IDPS.html`
- `idps-data.js`
- `idps-charts.jsx`
- `idps-controls.jsx`
- `idps-app.jsx`

---


## `Motor IDPS.html`

```html
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8" />
<title>slep_idps — Motor de Indicadores de Desarrollo Personal y Social</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='5' fill='%230A3A5C'/%3E%3Cg transform='translate(16 16)'%3E%3Cpolygon points='0,-10 8.7,5 -8.7,5' fill='none' stroke='%23FFF6E0' stroke-width='1.4'/%3E%3Ccircle r='2.4' fill='%23E88663'/%3E%3C/g%3E%3C/svg%3E" />
<style>
/* ============================================================
   slep_idps — SLEP Costa Central
   Hereda tokens y estética del motor "madre" (slep_simce).
   ============================================================ */

/* Fuentes de marca */
@font-face { font-family:"gobCL"; src:url("fonts/gobCL_Light.otf") format("opentype"); font-weight:300; font-display:swap; }
@font-face { font-family:"gobCL"; src:url("fonts/gobCL_Regular.otf") format("opentype"); font-weight:400; font-display:swap; }
@font-face { font-family:"gobCL"; src:url("fonts/gobCL_Heavy.otf") format("opentype"); font-weight:900; font-display:swap; }
@font-face { font-family:"Museo Sans"; src:url("fonts/MuseoSans-100.otf") format("opentype"); font-weight:100; font-display:swap; }
@font-face { font-family:"Museo Sans"; src:url("fonts/MuseoSans-300.otf") format("opentype"); font-weight:300; font-display:swap; }
@font-face { font-family:"Museo Sans"; src:url("fonts/MuseoSans_500.otf") format("opentype"); font-weight:500; font-display:swap; }
@font-face { font-family:"Museo Sans"; src:url("fonts/MuseoSans_700.otf") format("opentype"); font-weight:700; font-display:swap; }

:root {
  --mark-red:#EE2D49; --mark-pink:#F8A0AE; --mark-yellow:#FFC92E; --mark-green:#9BC93E; --mark-blue:#2A8FD9;
  --plum:#4A2746; --cream:#FFF6E0; --ocean:#0062A0; --slate:#747474; --olive:#75924E; --sand:#BCA493; --coral:#E88663;
  --ink:#1C1212; --ink-2:#2E2230; --paper:#FFFFFF; --cream-50:#FFFBEF; --cream-200:#F4E9CC;
  --line:#E7DFC9; --line-strong:#C8BDA0; --plum-80:#66394F; --plum-20:#EEDCE5; --ocean-80:#00558A; --ocean-20:#D4E4F1;
  --header:#0A3A5C; --header-80:#0E4A72;
  --fg-1:var(--ink); --fg-2:var(--ink-2); --fg-3:var(--slate); --fg-on-dark:var(--cream); --fg-link:var(--ocean);
  --bg-1:var(--cream); --bg-2:var(--paper); --bg-3:var(--cream-50); --accent:var(--coral);
  --success:var(--olive); --info:var(--ocean); --warning:var(--mark-yellow); --danger:var(--mark-red);
  --border-1:var(--line); --border-2:var(--line-strong);
  --space-1:4px; --space-2:8px; --space-3:12px; --space-4:16px; --space-5:24px; --space-6:32px; --space-7:48px; --space-8:64px;
  --radius-1:2px; --radius-2:4px; --radius-3:8px;
  --shadow-1:0 1px 0 rgba(28,18,18,.05); --shadow-2:0 2px 8px rgba(74,39,70,.08); --shadow-3:0 10px 30px rgba(74,39,70,.16);
  --font-display:"gobCL","Arial Black",system-ui,sans-serif;
  --font-body:"Museo Sans","gobCL",system-ui,-apple-system,sans-serif;
  --font-mono:ui-monospace,"SF Mono","Menlo",monospace;
}

* { box-sizing:border-box; }
html,body { margin:0; padding:0; }
body {
  background:var(--bg-1); color:var(--fg-1); font-family:var(--font-body); font-weight:300;
  font-size:15px; line-height:1.5; -webkit-font-smoothing:antialiased; text-rendering:optimizeLegibility;
}
::selection { background:var(--mark-yellow); color:var(--ink); }
button { font-family:inherit; }
:focus-visible { outline:2px solid var(--ocean); outline-offset:2px; }

/* ---------------- Header ---------------- */
.app-header { background:var(--header); color:var(--fg-on-dark); padding:26px 40px 24px; }
.app-header-inner { max-width:1640px; margin:0 auto; }
.brand-row { display:flex; align-items:center; gap:12px; margin-bottom:14px; }
.brand-mark { width:30px; height:30px; flex:none; }
.brand-eyebrow { font-family:var(--font-display); font-weight:900; font-size:12px; letter-spacing:.14em; text-transform:uppercase; opacity:.92; line-height:1.2; }
.brand-eyebrow .muted { opacity:.55; font-weight:400; }
.brand-pill { margin-left:auto; display:inline-flex; align-items:center; gap:7px; font-size:11px; letter-spacing:.06em; text-transform:uppercase; font-weight:500;
  background:rgba(255,246,224,.08); border:1px solid rgba(255,246,224,.22); padding:5px 11px; border-radius:var(--radius-2); }
.brand-pill code { font-family:var(--font-mono); background:transparent; color:var(--cream); padding:0; font-size:11px; }
.app-title { font-family:var(--font-display); font-weight:900; font-size:clamp(26px,3vw,38px); line-height:1.04; letter-spacing:-.01em; margin:0 0 8px; }
.app-title .sub { display:block; font-weight:400; font-size:clamp(15px,1.5vw,19px); opacity:.8; letter-spacing:0; margin-top:4px; }
.app-objective { font-size:14.5px; line-height:1.62; opacity:.9; max-width:1000px; margin:10px 0 0; }
.app-objective strong { font-weight:700; opacity:1; }
.header-meta { display:flex; flex-wrap:wrap; gap:8px; margin-top:16px; }
.hmeta { display:inline-flex; align-items:center; gap:7px; font-size:12px; letter-spacing:.02em; opacity:.85;
  background:rgba(255,246,224,.07); border:1px solid rgba(255,246,224,.16); padding:5px 11px; border-radius:var(--radius-2); }
.hmeta b { font-weight:700; opacity:1; }
.link-def-intro { color:var(--mark-yellow); background:none; border:0; padding:0; cursor:pointer; font:inherit; text-decoration:underline; text-underline-offset:3px; font-weight:500; }
.link-def-intro:hover { color:#fff; }

/* ---------------- Layout ---------------- */
.app-main { max-width:1640px; margin:0 auto; }

/* ---------------- Controls ---------------- */
.controls { padding:18px 40px 6px; }
.controls-row { display:flex; flex-wrap:wrap; align-items:flex-end; gap:26px 30px; }
.control-group { display:flex; flex-direction:column; gap:7px; }
.control-label { font-family:var(--font-display); font-weight:700; font-size:11px; letter-spacing:.1em; text-transform:uppercase; color:var(--fg-3); display:flex; align-items:center; gap:6px; }
.control-label .req { color:var(--coral); font-size:10px; letter-spacing:.04em; background:rgba(232,134,99,.14); padding:1px 6px; border-radius:var(--radius-1); }

.segmented { display:inline-flex; background:var(--cream-200); border:1px solid var(--line); border-radius:var(--radius-2); padding:2px; }
.segmented-btn { background:transparent; border:0; padding:6px 13px; font-size:13px; font-weight:500; color:var(--fg-3); cursor:pointer; border-radius:3px; transition:background 120ms,color 120ms; white-space:nowrap; }
.segmented-btn:hover { color:var(--fg-1); }
.segmented-btn.is-active { background:var(--paper); color:var(--plum); box-shadow:var(--shadow-1); font-weight:700; }
.segmented-btn:disabled { opacity:.38; cursor:not-allowed; }
.segmented.tiny .segmented-btn { padding:4px 10px; font-size:12px; }

/* GSE selector — siempre visible, énfasis especial */
.gse-block { background:var(--plum-20); border:1px solid var(--line-strong); border-radius:var(--radius-3); padding:12px 16px; display:flex; flex-direction:column; gap:8px; }
.gse-head { display:flex; align-items:center; gap:9px; }
.gse-head .control-label { color:var(--plum); }
.gse-head .lock { display:inline-flex; align-items:center; gap:5px; font-size:10.5px; font-weight:600; letter-spacing:.04em; text-transform:uppercase; color:var(--plum-80); }
.gse-seg { display:inline-flex; gap:3px; background:transparent; }
.gse-btn { background:var(--paper); border:1px solid var(--line); border-radius:var(--radius-2); padding:7px 12px; cursor:pointer; display:flex; flex-direction:column; align-items:center; gap:2px; min-width:62px; transition:all 120ms; }
.gse-btn .g-cod { font-family:var(--font-display); font-weight:900; font-size:14px; color:var(--fg-2); line-height:1; }
.gse-btn .g-lab { font-size:10.5px; color:var(--fg-3); line-height:1; }
.gse-btn:hover { border-color:var(--plum-80); }
.gse-btn.is-active { background:var(--plum); border-color:var(--plum); }
.gse-btn.is-active .g-cod, .gse-btn.is-active .g-lab { color:var(--cream); }
.gse-scale { display:flex; align-items:center; gap:8px; font-size:11px; color:var(--plum-80); }
.gse-scale .bar { flex:1; height:3px; border-radius:2px; background:linear-gradient(90deg,#9a7a8c,#4A2746); }

/* ---------------- Buttons ---------------- */
.btn { display:inline-flex; align-items:center; gap:7px; border:1px solid transparent; border-radius:var(--radius-2); padding:8px 14px; font-size:13px; font-weight:500; cursor:pointer; transition:background 120ms,border-color 120ms,color 120ms; background:var(--paper); color:var(--fg-1); }
.btn:active { transform:translateY(1px); }
.btn .ic { width:15px; height:15px; }
.btn-primary { background:var(--ocean); color:#fff; border-color:var(--ocean); }
.btn-primary:hover { background:var(--ocean-80); border-color:var(--ocean-80); }
.btn-ghost { background:transparent; border-color:var(--line-strong); color:var(--fg-1); }
.btn-ghost:hover { background:var(--cream-200); border-color:var(--plum); }
.btn-small { padding:6px 11px; font-size:12px; }
.btn:disabled { opacity:.4; cursor:not-allowed; }

/* ---------------- Territories ---------------- */
.terr-section { padding:14px 40px 4px; }
.terr-head { display:flex; align-items:center; gap:12px; margin-bottom:10px; flex-wrap:wrap; }
.section-eyebrow { font-family:var(--font-display); font-weight:700; font-size:11px; letter-spacing:.1em; text-transform:uppercase; color:var(--fg-3); }
.terr-count { font-size:12px; color:var(--fg-3); }
.terr-list { display:flex; flex-wrap:wrap; gap:9px; align-items:stretch; }
.terr-chip { display:inline-flex; align-items:flex-start; gap:9px; padding:8px 9px 8px 11px; background:var(--paper); border:1px solid var(--line); border-left-width:3px; border-radius:var(--radius-2); max-width:320px; box-shadow:var(--shadow-1); }
.terr-swatch { width:11px; height:11px; border-radius:2px; margin-top:3px; flex:none; }
.terr-text { display:flex; flex-direction:column; line-height:1.18; min-width:0; }
.terr-name { font-weight:700; font-size:13.5px; color:var(--fg-1); }
.terr-meta { font-size:11.5px; color:var(--fg-3); }
.terr-x { background:none; border:0; color:var(--fg-3); cursor:pointer; padding:2px; line-height:1; border-radius:3px; margin-left:2px; }
.terr-x:hover { color:var(--danger); background:var(--cream-200); }
.terr-add { display:inline-flex; align-items:center; gap:7px; padding:8px 13px; border:1px dashed var(--line-strong); background:transparent; border-radius:var(--radius-2); color:var(--ocean); font-weight:600; font-size:13px; cursor:pointer; }
.terr-add:hover { border-color:var(--ocean); background:var(--ocean-20); }
.terr-add:disabled { opacity:.4; cursor:not-allowed; }
.terr-hint { font-size:12px; color:var(--fg-3); margin:8px 0 0; display:flex; align-items:center; gap:7px; }

/* ---------------- Results / viz ---------------- */
.viz-section { padding:18px 40px 8px; }
.viz-head { display:flex; align-items:flex-start; justify-content:space-between; gap:20px; flex-wrap:wrap; margin-bottom:14px; }
.viz-title { font-family:var(--font-display); font-weight:900; font-size:22px; letter-spacing:-.01em; color:var(--fg-1); margin:4px 0 0; }
.viz-sub { font-size:13px; color:var(--fg-3); margin:5px 0 0; }
.viz-actions { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }

.panel { background:var(--paper); border:1px solid var(--line); border-radius:var(--radius-3); box-shadow:var(--shadow-2); }

/* Radar layout */
.radar-wrap { display:grid; grid-template-columns:minmax(0,1fr) 300px; gap:0; }
.radar-stage { position:relative; padding:18px 10px 8px; min-height:520px; display:flex; align-items:center; justify-content:center; }
.radar-side { border-left:1px solid var(--line); padding:20px; display:flex; flex-direction:column; gap:18px; }
.radar-legend-title { font-family:var(--font-display); font-weight:700; font-size:11px; letter-spacing:.1em; text-transform:uppercase; color:var(--fg-3); margin-bottom:2px; }
.ind-legend { display:flex; flex-direction:column; gap:3px; }
.ind-legend-item { display:flex; align-items:center; gap:9px; padding:7px 8px; border-radius:var(--radius-2); cursor:pointer; border:1px solid transparent; text-align:left; background:none; width:100%; transition:background 120ms; }
.ind-legend-item:hover { background:var(--cream-200); }
.ind-legend-item.is-dim { opacity:.4; }
.ind-dot { width:13px; height:13px; border-radius:3px; flex:none; }
.ind-legend-name { font-size:13px; font-weight:600; color:var(--fg-1); line-height:1.2; }
.ind-legend-info { margin-left:auto; color:var(--fg-3); display:flex; background:none; border:0; cursor:pointer; padding:3px; border-radius:3px; }
.ind-legend-info:hover { background:var(--cream-200); }
.ind-legend-item:hover .ind-legend-info { color:var(--ocean); }
.terr-legend { display:flex; flex-direction:column; gap:7px; }
.terr-legend-item { display:flex; align-items:center; gap:9px; font-size:12.5px; }
.terr-legend-line { width:22px; height:0; border-top-width:3px; border-top-style:solid; flex:none; }
.terr-legend-name { font-weight:600; color:var(--fg-1); }

.focus-note { font-size:12px; color:var(--ocean); display:flex; align-items:center; gap:6px; }
.focus-clear { background:none; border:0; color:var(--ocean); cursor:pointer; text-decoration:underline; font:inherit; padding:0; }

/* Lines small-multiples */
.lines-grid { display:grid; gap:14px; padding:18px; }
.line-card { border:1px solid var(--line); border-radius:var(--radius-2); padding:12px 12px 6px; background:var(--cream-50); }
.line-card-head { display:flex; align-items:center; gap:8px; margin-bottom:6px; }
.line-card-dot { width:11px; height:11px; border-radius:3px; flex:none; }
.line-card-title { font-size:13px; font-weight:700; color:var(--fg-1); line-height:1.15; }
.line-card-sub { font-size:11px; color:var(--fg-3); }
.line-card-info { margin-left:auto; background:none; border:0; cursor:pointer; color:var(--fg-3); display:flex; padding:2px; }
.line-card-info:hover { color:var(--ocean); }

/* Dual radar — por indicador y por dimensión */
.dual-legends { display:flex; flex-wrap:wrap; gap:18px 28px; align-items:flex-start; padding:16px 20px; border-bottom:1px solid var(--line); background:var(--cream-50); }
.dual-ind-legend { display:flex; flex-wrap:wrap; gap:6px; }
.dual-ind-chip { display:inline-flex; align-items:center; gap:4px; padding:5px 6px 5px 9px; border:1px solid var(--line); border-radius:var(--radius-2); background:var(--paper); }
.dual-ind-chip.is-dim { opacity:.42; }
.dual-ind-chip.is-on { border-color:var(--plum); box-shadow:var(--shadow-1); }
.dual-ind-main { display:flex; align-items:center; gap:8px; background:none; border:0; cursor:pointer; padding:0; }
.dual-focus-note { display:flex; align-items:center; gap:7px; font-size:12px; color:var(--ocean); padding:10px 20px 0; }
.dual-radar { display:grid; grid-template-columns:1fr 1fr; gap:16px; padding:16px 20px 12px; }
.radar-pane { border:1px solid var(--line); border-radius:var(--radius-3); background:var(--cream-50); padding:6px 6px 12px; min-width:0; }
.radar-pane-head { display:flex; align-items:center; justify-content:center; gap:8px; font-family:var(--font-display); font-weight:700; font-size:12px; letter-spacing:.07em; text-transform:uppercase; color:var(--fg-2); padding:12px 0 4px; }
.radar-pane-head .cnt { background:var(--cream-200); color:var(--fg-3); font-size:10.5px; padding:1px 7px; border-radius:var(--radius-1); letter-spacing:0; font-weight:500; }
@media (max-width:880px){ .dual-radar { grid-template-columns:1fr; } }

/* Indicadores + Dimensiones (dos gráficos) */
.idbars-legend { display:flex; flex-wrap:wrap; align-items:center; gap:8px 18px; padding:14px 20px; border-bottom:1px solid var(--line); background:var(--cream-50); }
.idbars-leg-item { display:inline-flex; align-items:center; gap:7px; font-size:12.5px; font-weight:600; color:var(--fg-1); }
.idbars-leg-scale { margin-left:auto; font-size:11.5px; color:var(--fg-3); font-weight:400; }
.idbars-wrap { display:grid; grid-template-columns:1fr 1fr; }
.idbars-col { padding:18px 22px 22px; min-width:0; }
.idbars-col-right { border-left:1px solid var(--line); }
.idbars-col-head { font-family:var(--font-display); font-weight:700; font-size:12px; letter-spacing:.09em; text-transform:uppercase; color:var(--fg-2); margin-bottom:16px; display:flex; align-items:center; gap:8px; }
.idbars-col-count { background:var(--cream-200); color:var(--fg-3); font-size:11px; padding:1px 7px; border-radius:var(--radius-1); letter-spacing:0; }
.idbar-group { margin-bottom:6px; }
.idbar-group-head { display:flex; align-items:center; gap:7px; font-size:11.5px; font-weight:700; color:var(--fg-2); margin:0 0 8px; padding-top:8px; border-top:1px dashed var(--line); }
.idbar-group:first-of-type .idbar-group-head { border-top:0; padding-top:0; }
.idbar-group-head .g-dot { width:9px; height:9px; border-radius:2px; flex:none; }
.idbar-row { margin-bottom:15px; }
.idbar-rlabel { background:none; border:0; cursor:pointer; text-align:left; padding:0; font-size:12.5px; font-weight:600; color:var(--fg-1); display:flex; align-items:center; gap:7px; margin-bottom:6px; line-height:1.2; }
.idbar-rlabel .r-dot { width:8px; height:8px; border-radius:2px; flex:none; }
.idbar-rlabel:hover { color:var(--ocean); }
.idbar-bars { display:flex; flex-direction:column; gap:4px; }
.idbar-track { display:flex; align-items:center; gap:8px; cursor:default; }
.idbar-sw { width:9px; height:9px; border-radius:2px; flex:none; }
.idbar-rail { flex:1; height:13px; background:var(--cream-200); border-radius:2px; overflow:hidden; }
.idbar-fill { height:100%; border-radius:2px; transition:width 250ms ease; }
.idbar-val { font-size:11px; font-weight:700; font-variant-numeric:tabular-nums; color:var(--fg-2); width:36px; text-align:right; flex:none; }
.idbar-sin { font-size:10.5px; color:var(--fg-3); font-style:italic; width:auto; flex:none; }
@media (max-width:820px){ .idbars-wrap { grid-template-columns:1fr; } .idbars-col-right { border-left:0; border-top:1px solid var(--line); } }

/* Distribution */
.dist-wrap { padding:18px; display:flex; flex-direction:column; gap:6px; }
.dist-legend { display:flex; gap:16px; align-items:center; margin-bottom:8px; font-size:12px; color:var(--fg-2); flex-wrap:wrap; }
.dist-legend span { display:inline-flex; align-items:center; gap:6px; }
.dist-swatch { width:13px; height:13px; border-radius:2px; }
.dist-row { display:grid; grid-template-columns:200px minmax(0,1fr); align-items:center; gap:14px; padding:5px 0; }
.dist-row-label { font-size:12.5px; color:var(--fg-1); display:flex; align-items:center; gap:7px; line-height:1.2; }
.dist-row-label .d-ind { width:8px; height:8px; border-radius:2px; flex:none; }
.dist-bar { height:26px; display:flex; border-radius:var(--radius-1); overflow:hidden; border:1px solid var(--line); background:var(--cream-200); }
.dist-seg { display:flex; align-items:center; justify-content:center; font-size:11px; font-weight:700; color:#fff; min-width:0; transition:width 200ms ease; }
.dist-seg.is-sin { background:repeating-linear-gradient(45deg,#efe7d2,#efe7d2 5px,#e3d8bc 5px,#e3d8bc 10px); color:var(--fg-3); width:100%; }

/* Empty / no-data states */
.empty-state { padding:60px 32px; text-align:center; display:flex; flex-direction:column; align-items:center; gap:12px; }
.empty-state .ic-big { color:var(--line-strong); }
.empty-state .es-title { font-family:var(--font-display); font-weight:700; font-size:18px; color:var(--fg-2); }
.empty-state p { color:var(--fg-3); max-width:480px; margin:0; font-size:14px; }
.empty-board { margin:24px 40px; padding:56px 32px; border:1px dashed var(--line-strong); border-radius:var(--radius-3); background:var(--cream-200); text-align:center; }
.empty-board .es-title { margin-bottom:8px; }

/* Badges */
.badge { display:inline-flex; align-items:center; gap:5px; font-size:11px; font-weight:600; letter-spacing:.02em; padding:3px 8px; border-radius:var(--radius-1); }
.badge-prelim { background:rgba(255,201,46,.22); color:#8a6400; border:1px solid rgba(255,201,46,.5); }
.badge-sindato { background:var(--cream-200); color:var(--fg-3); border:1px solid var(--line-strong); }
.prelim-star { color:#b07d00; font-weight:700; }

/* ---------------- Definitions drawer ---------------- */
.drawer-scrim { position:fixed; inset:0; background:rgba(28,18,18,.34); z-index:60; opacity:0; pointer-events:none; transition:opacity 180ms; }
.drawer-scrim.is-open { opacity:1; pointer-events:auto; }
.drawer { position:fixed; top:0; right:0; height:100%; width:min(460px,94vw); background:var(--paper); box-shadow:var(--shadow-3); z-index:61; transform:translateX(100%); transition:transform 200ms ease; display:flex; flex-direction:column; }
.drawer.is-open { transform:translateX(0); }
.drawer-head { padding:20px 24px 16px; border-bottom:1px solid var(--line); display:flex; align-items:flex-start; gap:12px; }
.drawer-head .d-eyebrow { font-family:var(--font-display); font-weight:700; font-size:11px; letter-spacing:.1em; text-transform:uppercase; color:var(--fg-3); }
.drawer-head h3 { font-family:var(--font-display); font-weight:900; font-size:20px; margin:5px 0 0; line-height:1.1; }
.drawer-ind-tag { display:inline-flex; align-items:center; gap:7px; margin-top:8px; font-size:12px; font-weight:600; color:var(--fg-2); }
.drawer-ind-tag .tg-dot { width:11px; height:11px; border-radius:3px; }
.drawer-close { margin-left:auto; background:none; border:1px solid var(--line); border-radius:var(--radius-2); width:32px; height:32px; cursor:pointer; color:var(--fg-2); display:flex; align-items:center; justify-content:center; flex:none; }
.drawer-close:hover { background:var(--cream-200); border-color:var(--plum); }
.drawer-body { padding:20px 24px 40px; overflow-y:auto; }
.drawer-body p { font-size:14px; line-height:1.62; color:var(--fg-2); }
.drawer-dim { border-top:1px solid var(--line); padding-top:16px; margin-top:16px; }
.drawer-dim-name { font-weight:700; font-size:14.5px; color:var(--fg-1); margin-bottom:4px; display:flex; align-items:center; gap:8px; }
.drawer-dim-name .dd-n { font-family:var(--font-mono); font-size:11px; color:var(--fg-3); background:var(--cream-200); padding:1px 6px; border-radius:var(--radius-1); }
.drawer-all-link { margin-top:6px; }
.drawer-card { background:var(--cream-50); border:1px solid var(--line); border-radius:var(--radius-2); padding:14px 16px; margin-bottom:14px; }
.drawer-card h4 { font-family:var(--font-display); font-weight:700; font-size:13px; margin:0 0 4px; }

/* ---------------- Modal (territory picker) ---------------- */
.modal-scrim { position:fixed; inset:0; background:rgba(28,18,18,.4); z-index:70; display:flex; align-items:center; justify-content:center; padding:24px; }
.modal { background:var(--paper); border-radius:var(--radius-3); box-shadow:var(--shadow-3); width:min(720px,96vw); max-height:88vh; display:flex; flex-direction:column; overflow:hidden; }
.modal-head { padding:20px 24px 16px; border-bottom:1px solid var(--line); }
.modal-head h3 { font-family:var(--font-display); font-weight:900; font-size:19px; margin:0; }
.modal-head p { font-size:13px; color:var(--fg-3); margin:6px 0 0; }
.modal-body { padding:18px 24px; overflow-y:auto; }
.modal-foot { padding:14px 24px; border-top:1px solid var(--line); display:flex; align-items:center; justify-content:space-between; gap:12px; }
.level-tabs { display:flex; gap:4px; flex-wrap:wrap; margin-bottom:16px; }
.level-tab { background:var(--cream-200); border:1px solid var(--line); border-radius:var(--radius-2); padding:7px 13px; font-size:13px; font-weight:600; color:var(--fg-2); cursor:pointer; display:flex; align-items:center; gap:7px; }
.level-tab.is-active { background:var(--ocean); border-color:var(--ocean); color:#fff; }
.level-desc { font-size:12.5px; color:var(--fg-3); margin:0 0 14px; display:flex; align-items:center; gap:7px; }
.search-box { display:flex; align-items:center; gap:8px; border:1px solid var(--line-strong); border-radius:var(--radius-2); padding:8px 12px; margin-bottom:12px; }
.search-box input { border:0; outline:0; flex:1; font:inherit; font-size:14px; background:transparent; color:var(--fg-1); }
.opt-list { display:flex; flex-direction:column; gap:4px; max-height:340px; overflow-y:auto; }
.opt-row { display:flex; align-items:center; gap:11px; padding:9px 11px; border:1px solid var(--line); border-radius:var(--radius-2); cursor:pointer; background:var(--paper); text-align:left; }
.opt-row:hover { border-color:var(--ocean); background:var(--ocean-20); }
.opt-row.is-sel { border-color:var(--ocean); background:var(--ocean-20); }
.opt-row.is-disabled { opacity:.4; cursor:not-allowed; }
.opt-check { width:18px; height:18px; border:1.5px solid var(--line-strong); border-radius:3px; flex:none; display:flex; align-items:center; justify-content:center; }
.opt-row.is-sel .opt-check { background:var(--ocean); border-color:var(--ocean); color:#fff; }
.opt-main { display:flex; flex-direction:column; line-height:1.2; min-width:0; }
.opt-name { font-weight:600; font-size:14px; color:var(--fg-1); }
.opt-meta { font-size:11.5px; color:var(--fg-3); }
.opt-flag { margin-left:auto; font-size:10.5px; font-weight:700; letter-spacing:.04em; text-transform:uppercase; color:var(--coral); background:rgba(232,134,99,.14); padding:2px 7px; border-radius:var(--radius-1); }

/* ---------------- Tooltip ---------------- */
.tt { position:fixed; z-index:80; pointer-events:none; background:var(--ink); color:var(--cream); border-radius:var(--radius-2); padding:9px 12px; font-size:12px; line-height:1.4; box-shadow:var(--shadow-3); max-width:280px; }
.tt-title { font-weight:700; margin-bottom:5px; font-size:12.5px; }
.tt-row { display:flex; align-items:center; gap:7px; margin-top:3px; }
.tt-row .tt-sw { width:9px; height:9px; border-radius:2px; flex:none; }
.tt-row .tt-v { margin-left:auto; font-weight:700; font-variant-numeric:tabular-nums; }
.tt-def { margin-top:6px; padding-top:6px; border-top:1px solid rgba(255,246,224,.18); opacity:.82; font-weight:300; }
.tt-hint { margin-top:6px; opacity:.6; font-size:11px; }

/* ---------------- Footer ---------------- */
.app-footer { padding:24px 40px 56px; max-width:1640px; margin:14px auto 0; }
.notes-toggle { display:inline-flex; align-items:center; gap:10px; background:transparent; border:1px solid var(--line-strong); border-radius:var(--radius-2); padding:11px 16px; font-weight:600; font-size:14px; color:var(--fg-1); cursor:pointer; }
.notes-toggle:hover { background:var(--cream-200); border-color:var(--plum); }
.notes-toggle .chev { margin-left:2px; transition:transform 200ms; display:flex; }
.notes-toggle.is-open .chev { transform:rotate(180deg); }
.notes-body { margin-top:16px; }
.notes-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:16px; }
.note { background:var(--cream-50); border:1px solid var(--line); border-radius:var(--radius-2); padding:18px 20px; }
.note h4 { font-family:var(--font-display); font-weight:700; font-size:14px; margin:0 0 8px; }
.note p { font-size:13px; line-height:1.58; color:var(--fg-2); margin:0 0 8px; }
.note p:last-child { margin-bottom:0; }
.notes-sources { margin-top:18px; padding-top:14px; border-top:1px solid var(--line); display:flex; flex-direction:column; gap:4px; font-size:12px; color:var(--fg-3); }
.note .formula { font-family:var(--font-mono); font-size:12px; background:var(--cream-200); padding:6px 9px; border-radius:var(--radius-1); display:block; margin:6px 0; color:var(--plum); }

/* Misc */
.spin { animation:spin 900ms linear infinite; } @keyframes spin { to { transform:rotate(360deg); } }
.loading-pill { display:inline-flex; align-items:center; gap:8px; font-size:12px; color:var(--fg-3); }
.loading-dot { width:8px; height:8px; border-radius:50%; background:var(--ocean); animation:pulse 900ms ease-in-out infinite; }
@keyframes pulse { 0%,100%{opacity:.3;} 50%{opacity:1;} }
svg text { font-family:var(--font-body); }

@media (max-width:1080px){
  .radar-wrap { grid-template-columns:1fr; }
  .radar-side { border-left:0; border-top:1px solid var(--line); }
}
@media (max-width:720px){
  .app-header, .controls, .terr-section, .viz-section, .app-footer { padding-left:18px; padding-right:18px; }
}
</style>
</head>
<body>
<div id="root"></div>

<!-- Tooltip global -->
<div id="tt-layer"></div>

<!-- Datos (mockup) -->
<script src="idps-data.js"></script>

<!-- React 18 + Babel -->
<script src="https://unpkg.com/react@18.3.1/umd/react.development.js" integrity="sha384-hD6/rw4ppMLGNu3tX5cjIb+uRZ7UkRJ6BPkLpg4hAu/6onKUg4lLsHAs9EBPT82L" crossorigin="anonymous"></script>
<script src="https://unpkg.com/react-dom@18.3.1/umd/react-dom.development.js" integrity="sha384-u6aeetuaXnQ38mYT8rp6sbXaQe3NL9t+IBXmnYxwkUI2Hw4bsp2Wvmx4yRQF1uAm" crossorigin="anonymous"></script>
<script src="https://unpkg.com/@babel/standalone@7.29.0/babel.min.js" integrity="sha384-m08KidiNqLdpJqLq95G/LEi8Qvjl/xUYll3QILypMoQ65QorJ9Lvtp2RXYGBFj1y" crossorigin="anonymous"></script>
<script src="https://unpkg.com/d3@7.9.0/dist/d3.min.js"></script>

<!-- App -->
<script type="text/babel" data-presets="env,react" src="idps-charts.jsx"></script>
<script type="text/babel" data-presets="env,react" src="idps-controls.jsx"></script>
<script type="text/babel" data-presets="env,react" src="idps-app.jsx"></script>
</body>
</html>
```


## `idps-data.js`

```javascript
/* ============================================================
   slep_idps — capa de datos (mockup)
   Datos de EJEMPLO, generados de forma determinista (0–100).
   No es un pipeline real: solo alimenta la interfaz.
   Expone window.IDPS.
   ============================================================ */
(function () {
  "use strict";

  // ----------------------------------------------------------
  // 1. Marco conceptual: 4 indicadores, 11 dimensiones
  // ----------------------------------------------------------
  const INDICADORES = [
    {
      id: "autoestima",
      n: 1,
      nombre: "Autoestima académica y motivación escolar",
      corto: "Autoestima y motivación",
      color: "#EE2D49", // mark-red
      def: "Autopercepción del estudiante sobre su capacidad de aprender y sus actitudes hacia el aprendizaje. Considera tanto la confianza en las propias aptitudes como la disposición frente al estudio.",
      dimensiones: [
        { id: "autopercepcion", nombre: "Autopercepción y autovaloración académica", corto: "Autopercepción académica",
          def: "Percepción que tienen las y los estudiantes de sus propias aptitudes y la valoración de sus habilidades para aprender las distintas asignaturas." },
        { id: "motivacion", nombre: "Motivación escolar", corto: "Motivación escolar",
          def: "Interés y disposición de las y los estudiantes hacia el aprendizaje, y su actitud para superar las dificultades que este implica." },
      ],
    },
    {
      id: "convivencia",
      n: 2,
      nombre: "Clima de convivencia escolar",
      corto: "Convivencia escolar",
      color: "#FFC92E", // mark-yellow
      def: "Percepciones y actitudes que tienen las y los estudiantes, docentes y apoderados respecto de la existencia de un ambiente de respeto, organizado y seguro en el establecimiento.",
      dimensiones: [
        { id: "respeto", nombre: "Ambiente de respeto", corto: "Ambiente de respeto",
          def: "Percepción de un trato respetuoso entre los miembros de la comunidad, valoración de la diversidad y ausencia de discriminación." },
        { id: "organizado", nombre: "Ambiente organizado", corto: "Ambiente organizado",
          def: "Existencia de normas claras, conocidas y exigidas, y de una resolución constructiva de los conflictos en el establecimiento." },
        { id: "seguro", nombre: "Ambiente seguro", corto: "Ambiente seguro",
          def: "Percepción de seguridad y de ausencia de violencia física y psicológica, junto con la existencia de mecanismos de prevención." },
      ],
    },
    {
      id: "participacion",
      n: 3,
      nombre: "Participación y formación ciudadana",
      corto: "Participación ciudadana",
      color: "#9BC93E", // mark-green
      def: "Actitudes de las y los estudiantes frente a su establecimiento y al fomento de la vida democrática, así como el grado en que la institución promueve la participación y el compromiso cívico.",
      dimensiones: [
        { id: "participacion_d", nombre: "Participación", corto: "Participación",
          def: "Oportunidades de encuentro, colaboración y comunicación que el establecimiento ofrece a estudiantes, apoderados y docentes." },
        { id: "democratica", nombre: "Vida democrática", corto: "Vida democrática",
          def: "Espacios para la expresión de opiniones, la representación estudiantil y la deliberación democrática dentro del establecimiento." },
        { id: "pertenencia", nombre: "Sentido de pertenencia", corto: "Sentido de pertenencia",
          def: "Grado de identificación y orgullo de las y los estudiantes por pertenecer a su establecimiento." },
      ],
    },
    {
      id: "habitos",
      n: 4,
      nombre: "Hábitos de vida saludable",
      corto: "Vida saludable",
      color: "#2A8FD9", // mark-blue
      def: "Actitudes y conductas autodeclaradas de las y los estudiantes frente a una vida saludable, y la promoción que el establecimiento hace de estas.",
      dimensiones: [
        { id: "alimenticios", nombre: "Hábitos alimenticios", corto: "Hábitos alimenticios",
          def: "Actitud de las y los estudiantes frente a la alimentación saludable y la promoción que el establecimiento realiza de ella." },
        { id: "activa", nombre: "Hábitos de vida activa", corto: "Vida activa",
          def: "Actitud frente a la actividad física y deportiva, y la promoción que el establecimiento hace de la vida activa." },
        { id: "autocuidado", nombre: "Hábitos de autocuidado", corto: "Autocuidado",
          def: "Actitud frente al consumo de sustancias y la adopción de conductas de autocuidado, junto con su promoción institucional." },
      ],
    },
  ];

  // Lista plana de las 11 dimensiones, en orden, con su indicador padre
  const DIMENSIONES = [];
  INDICADORES.forEach((ind) => {
    ind.dimensiones.forEach((d) => {
      DIMENSIONES.push({ ...d, indId: ind.id, indNombre: ind.nombre, indN: ind.n, color: ind.color });
    });
  });

  // ----------------------------------------------------------
  // 2. GSE — siempre presente. 1 Bajo … 5 Alto
  // ----------------------------------------------------------
  const GSE = [
    { cod: 1, label: "GSE 1 · Bajo", corto: "Bajo" },
    { cod: 2, label: "GSE 2 · Medio bajo", corto: "Medio bajo" },
    { cod: 3, label: "GSE 3 · Medio", corto: "Medio" },
    { cod: 4, label: "GSE 4 · Medio alto", corto: "Medio alto" },
    { cod: 5, label: "GSE 5 · Alto", corto: "Alto" },
  ];

  // ----------------------------------------------------------
  // 3. Grados y cobertura temporal (asimétrica, intencional)
  // ----------------------------------------------------------
  const GRADOS = [
    { id: "2m", label: "2° medio",  anios: [2022, 2023, 2024, 2025] }, // serie larga
    { id: "4b", label: "4° básico", anios: [2022, 2023, 2025] },        // falta 2024
    { id: "6b", label: "6° básico", anios: [2024] },                    // corte único
    { id: "8b", label: "8° básico", anios: [2025] },                    // corte único
  ];
  const PRELIMINAR = [2025];
  const TODOS_ANIOS = [2022, 2023, 2024, 2025];

  // ----------------------------------------------------------
  // 4. Catálogo territorial — TODO Chile disponible
  //    Niveles: país · región · slep · comuna · establecimiento
  // ----------------------------------------------------------
  const REGIONES = [
    { id: "r15", nombre: "Arica y Parinacota" },
    { id: "r01", nombre: "Tarapacá" },
    { id: "r02", nombre: "Antofagasta" },
    { id: "r03", nombre: "Atacama" },
    { id: "r04", nombre: "Coquimbo" },
    { id: "r05", nombre: "Valparaíso" },
    { id: "r13", nombre: "Metropolitana de Santiago" },
    { id: "r06", nombre: "O'Higgins" },
    { id: "r07", nombre: "Maule" },
    { id: "r16", nombre: "Ñuble" },
    { id: "r08", nombre: "Biobío" },
    { id: "r09", nombre: "La Araucanía" },
    { id: "r14", nombre: "Los Ríos" },
    { id: "r10", nombre: "Los Lagos" },
    { id: "r11", nombre: "Aysén" },
    { id: "r12", nombre: "Magallanes" },
  ];

  // SLEPs (selección plausible; Costa Central es el foco)
  const SLEPS = [
    { id: "slep_costacentral", nombre: "Costa Central", region: "r05", comunas: ["concon", "puchuncavi", "quintero", "vinadelmar"] },
    { id: "slep_valparaiso",   nombre: "Valparaíso",   region: "r05", comunas: ["valparaiso", "juanfernandez"] },
    { id: "slep_andalien",     nombre: "Andalién Sur", region: "r08", comunas: ["concepcion", "chiguayante", "hualqui"] },
    { id: "slep_gabriela",     nombre: "Gabriela Mistral", region: "r13", comunas: ["santiago", "macul"] },
    { id: "slep_barrancas",    nombre: "Barrancas",    region: "r13", comunas: ["pudahuel", "lopranado", "cerronavia"] },
    { id: "slep_puertocord",   nombre: "Puerto Cordillera", region: "r04", comunas: ["coquimbo", "andacollo"] },
  ];

  // Comunas (las 4 de Costa Central + algunas nacionales para mostrar alcance)
  const COMUNAS = [
    { id: "concon",      nombre: "Concón",        region: "r05", slep: "slep_costacentral" },
    { id: "puchuncavi",  nombre: "Puchuncaví",    region: "r05", slep: "slep_costacentral" },
    { id: "quintero",    nombre: "Quintero",      region: "r05", slep: "slep_costacentral" },
    { id: "vinadelmar",  nombre: "Viña del Mar",  region: "r05", slep: "slep_costacentral" },
    { id: "valparaiso",  nombre: "Valparaíso",    region: "r05", slep: "slep_valparaiso" },
    { id: "juanfernandez", nombre: "Juan Fernández", region: "r05", slep: "slep_valparaiso" },
    { id: "santiago",    nombre: "Santiago",      region: "r13", slep: "slep_gabriela" },
    { id: "macul",       nombre: "Macul",         region: "r13", slep: "slep_gabriela" },
    { id: "concepcion",  nombre: "Concepción",    region: "r08", slep: "slep_andalien" },
    { id: "chiguayante", nombre: "Chiguayante",   region: "r08", slep: "slep_andalien" },
    { id: "hualqui",     nombre: "Hualqui",       region: "r08", slep: "slep_andalien" },
    { id: "coquimbo",    nombre: "Coquimbo",      region: "r04", slep: "slep_puertocord" },
    { id: "andacollo",   nombre: "Andacollo",     region: "r04", slep: "slep_puertocord" },
    { id: "pudahuel",    nombre: "Pudahuel",      region: "r13", slep: "slep_barrancas" },
    { id: "cerronavia",  nombre: "Cerro Navia",   region: "r13", slep: "slep_barrancas" },
  ];

  // Establecimientos (algunos dentro de Costa Central)
  const ESTABLECIMIENTOS = [
    { id: "e1", rbd: "1631", nombre: "Liceo Bicentenario de Viña del Mar", comuna: "vinadelmar", region: "r05", slep: "slep_costacentral" },
    { id: "e2", rbd: "1702", nombre: "Escuela República del Ecuador", comuna: "vinadelmar", region: "r05", slep: "slep_costacentral" },
    { id: "e3", rbd: "1845", nombre: "Liceo Politécnico de Concón", comuna: "concon", region: "r05", slep: "slep_costacentral" },
    { id: "e4", rbd: "1912", nombre: "Escuela Básica de Quintero", comuna: "quintero", region: "r05", slep: "slep_costacentral" },
    { id: "e5", rbd: "2033", nombre: "Escuela Rural de Puchuncaví", comuna: "puchuncavi", region: "r05", slep: "slep_costacentral" },
    { id: "e6", rbd: "0855", nombre: "Liceo de Aplicación", comuna: "santiago", region: "r13", slep: "slep_gabriela" },
  ];

  // País
  const PAIS = { id: "chile", nombre: "Chile (total nacional)" };

  // Paleta de territorios — usa la PALETA DE MARCA (no choca con los colores
  // de indicador, que son rojo/amarillo/verde/azul).
  const TERRITORIO_PALETTE = ["#4A2746", "#0062A0", "#E88663", "#75924E"]; // plum, ocean, coral, olive
  const MAX_TERRITORIOS = 4;

  // ----------------------------------------------------------
  // 5. Generador determinista de valores 0–100
  // ----------------------------------------------------------
  function hash(str) {
    let h = 2166136261;
    for (let i = 0; i < str.length; i++) {
      h ^= str.charCodeAt(i);
      h = Math.imul(h, 16777619);
    }
    return (h >>> 0) / 4294967295; // 0..1
  }

  // Línea base por territorio (estable). Mayor GSE ⇒ leve alza.
  function baseTerritorio(territorioKey) {
    return 58 + hash("base|" + territorioKey) * 22; // 58..80
  }

  // Valor de una dimensión para (territorio, gse, grado, dim, año)
  function valorDimension(territorioKey, gse, gradoId, dimId, anio) {
    const base = baseTerritorio(territorioKey);
    const gseEfecto = (gse - 3) * 2.4; // GSE alto un poco más alto
    const dimEfecto = (hash(dimId + "|" + territorioKey) - 0.5) * 26; // perfil por dimensión
    const anioEfecto = (anio - 2022) * (hash("trend|" + territorioKey + "|" + dimId) - 0.42) * 4.5; // deriva temporal suave
    const ruido = (hash(territorioKey + "|" + gse + "|" + gradoId + "|" + dimId + "|" + anio) - 0.5) * 7;
    let v = base + gseEfecto + dimEfecto + anioEfecto + ruido;
    return Math.max(8, Math.min(98, Math.round(v * 10) / 10));
  }

  // Supresión por resguardo estadístico: algunos establecimientos pequeños
  // y GSE poco poblados devuelven "sin dato" (null), NUNCA cero.
  function estaSuprimido(territorio, gse, gradoId, anio) {
    if (territorio.kind === "estab") {
      // establecimientos pequeños: ciertos GSE no aplican / se suprimen
      const r = hash("sup|" + territorio.key + "|" + gse + "|" + gradoId);
      return r < 0.45; // ~ casi la mitad de las celdas GSE de un estab no tienen dato
    }
    if (territorio.kind === "comuna") {
      const r = hash("sup|" + territorio.key + "|" + gse + "|" + gradoId + "|" + anio);
      return r < 0.06;
    }
    return false; // slep/región/país siempre tienen dato
  }

  // ----------------------------------------------------------
  // 6. API de consulta
  // ----------------------------------------------------------
  // territorio: objeto { kind, id, key, nombre, ... }
  // Devuelve { [dimId]: valor|null } para un grado/gse/año
  function dimsDe(territorio, gse, gradoId, anio) {
    const out = {};
    const suprimido = estaSuprimido(territorio, gse, gradoId, anio);
    DIMENSIONES.forEach((d) => {
      out[d.id] = suprimido ? null : valorDimension(territorio.key, gse, gradoId, d.id, anio);
    });
    return out;
  }

  // Valor de indicador = promedio de sus dimensiones (null si todas null)
  function indicadoresDe(territorio, gse, gradoId, anio) {
    const dims = dimsDe(territorio, gse, gradoId, anio);
    const out = {};
    INDICADORES.forEach((ind) => {
      const vals = ind.dimensiones.map((d) => dims[d.id]).filter((v) => v != null);
      out[ind.id] = vals.length ? Math.round((vals.reduce((a, b) => a + b, 0) / vals.length) * 10) / 10 : null;
    });
    return out;
  }

  // Serie histórica de una métrica (indicador o dimensión) para un territorio/gse/grado
  // metricKind: "indicador" | "dimension"
  // Cada punto trae la significancia estadística del cambio respecto de la
  // medición anterior disponible (sigVsPrev): true = diferencia significativa,
  // false = no significativa, null = sin comparación posible.
  function serie(territorio, gse, gradoId, metricId, metricKind) {
    const grado = GRADOS.find((g) => g.id === gradoId);
    let prev = null; // { anio, valor }
    return grado.anios.map((anio) => {
      const vals = metricKind === "indicador"
        ? indicadoresDe(territorio, gse, gradoId, anio)
        : dimsDe(territorio, gse, gradoId, anio);
      const valor = vals[metricId];
      let sigVsPrev = null, deltaVsPrev = null, prevAnio = null;
      if (valor != null && prev != null) {
        deltaVsPrev = Math.round((valor - prev.valor) * 10) / 10;
        prevAnio = prev.anio;
        const thr = 2 + hash("sig|" + territorio.key + "|" + metricId + "|" + gradoId + "|" + anio) * 3.2; // umbral 2.0–5.2
        sigVsPrev = Math.abs(deltaVsPrev) >= thr;
      }
      const point = { anio, valor, preliminar: PRELIMINAR.includes(anio), sigVsPrev, deltaVsPrev, prevAnio };
      if (valor != null) prev = { anio, valor };
      return point;
    });
  }

  // Distribución Bajo/Medio/Alto por dimensión (suma 100; null si suprimido)
  function distribucionDim(territorio, gse, gradoId, dimId, anio) {
    if (estaSuprimido(territorio, gse, gradoId, anio)) return null;
    const v = valorDimension(territorio.key, gse, gradoId, dimId, anio); // 0..100, "favorabilidad"
    // Mapear puntaje a una mezcla plausible: a mayor puntaje, más "Alto".
    let alto = Math.max(6, Math.min(86, v - 8 + (hash("alto|" + dimId + territorio.key) - 0.5) * 10));
    let bajo = Math.max(3, Math.min(60, (100 - v) * 0.55 + (hash("bajo|" + dimId + territorio.key) - 0.5) * 8));
    let medio = 100 - alto - bajo;
    if (medio < 6) { medio = 6; const exc = (alto + bajo + medio) - 100; alto -= exc * 0.6; bajo -= exc * 0.4; }
    const round1 = (x) => Math.round(x * 10) / 10;
    return { bajo: round1(bajo), medio: round1(100 - round1(alto) - round1(bajo)), alto: round1(alto) };
  }

  // Año más reciente disponible para un grado
  function anioReciente(gradoId) {
    const g = GRADOS.find((x) => x.id === gradoId);
    return g.anios[g.anios.length - 1];
  }

  // ----------------------------------------------------------
  // Exportar
  // ----------------------------------------------------------
  window.IDPS = {
    INDICADORES, DIMENSIONES, GSE, GRADOS, PRELIMINAR, TODOS_ANIOS,
    REGIONES, SLEPS, COMUNAS, ESTABLECIMIENTOS, PAIS,
    TERRITORIO_PALETTE, MAX_TERRITORIOS,
    dimsDe, indicadoresDe, serie, distribucionDim, anioReciente,
    intro: "Los Indicadores de Desarrollo Personal y Social (IDPS) son un conjunto de índices de la Agencia de Calidad de la Educación que miden el desarrollo personal y social de las y los estudiantes, complementando los resultados académicos del Simce. Se construyen a partir de cuestionarios tipo Likert aplicados a estudiantes, docentes y apoderados. Su puntaje va de 0 a 100, donde 100 representa las percepciones más positivas, y son un insumo de la Categoría de Desempeño de cada establecimiento.",
  };
})();
```


## `idps-charts.jsx`

```jsx
/* ============================================================
   slep_idps — Visualizaciones (D3)
   Radar (héroe) · Líneas (small multiples) · Distribución
   ============================================================ */
"use strict";

const D = window.IDPS;

/* ---------- Iconos (lucide-style, 2px) ---------- */
const ICON_PATHS = {
  info: '<circle cx="12" cy="12" r="9"/><path d="M12 16v-4M12 8h.01"/>',
  close: '<path d="M18 6 6 18M6 6l12 12"/>',
  plus: '<path d="M12 5v14M5 12h14"/>',
  search: '<circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/>',
  check: '<path d="M20 6 9 17l-5-5"/>',
  chevron: '<path d="m6 9 6 6 6-6"/>',
  x: '<path d="M18 6 6 18M6 6l12 12"/>',
  radar: '<path d="M12 2 2 8.5 6 21h12l4-12.5z"/><path d="M12 6 6.5 9.7 8.5 17h7l2-7.3z"/><circle cx="12" cy="12" r="1.4"/>',
  trend: '<path d="M3 17l6-6 4 4 7-8"/><path d="M14 7h6v6"/>',
  bars: '<path d="M4 20V10M10 20V4M16 20v-7M22 20H2"/>',
  clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
  layers: '<path d="m12 2 9 5-9 5-9-5 9-5z"/><path d="m3 12 9 5 9-5M3 17l9 5 9-5"/>',
  map: '<path d="M9 4 3 6v14l6-2 6 2 6-2V4l-6 2-6-2z"/><path d="M9 4v14M15 6v14"/>',
  flag: '<path d="M4 22V4s2-1 5-1 5 2 8 2 3-1 3-1v10s-1 1-3 1-5-2-8-2-5 1-5 1z"/>',
  building: '<path d="M6 22V4h12v18M10 8h4M10 12h4M10 16h4"/>',
  lock: '<rect x="5" y="11" width="14" height="9" rx="1.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>',
  filter: '<path d="M3 5h18l-7 8v6l-4-2v-4z"/>',
  reset: '<path d="M3 12a9 9 0 1 0 3-6.7L3 8"/><path d="M3 3v5h5"/>',
};
function Icon({ name, size = 16, style }) {
  return (
    <svg className="ic" width={size} height={size} viewBox="0 0 24 24" fill="none"
      stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
      style={style} dangerouslySetInnerHTML={{ __html: ICON_PATHS[name] || "" }} />
  );
}

/* ---------- Tooltip imperativo ---------- */
const TT = (function () {
  let el = null;
  function ensure() {
    if (!el) { el = document.createElement("div"); el.className = "tt"; el.style.display = "none";
      document.getElementById("tt-layer").appendChild(el); }
    return el;
  }
  return {
    show(html, x, y) {
      const t = ensure(); t.innerHTML = html; t.style.display = "block";
      const r = t.getBoundingClientRect();
      let left = x + 14, top = y + 14;
      if (left + r.width > window.innerWidth - 8) left = x - r.width - 14;
      if (top + r.height > window.innerHeight - 8) top = y - r.height - 14;
      t.style.left = Math.max(8, left) + "px"; t.style.top = Math.max(8, top) + "px";
    },
    hide() { if (el) el.style.display = "none"; },
  };
})();

const fmt = (v) => (v == null ? "sin dato" : v.toFixed(1));

/* ============================================================
   RADAR — héroe. 11 ejes (dimensiones), polígono por territorio.
   ============================================================ */
function RadarChart({ territorios, gse, gradoId, anio, metric = "dimension", focusInd, onAxisClick }) {
  const ref = React.useRef(null);

  React.useEffect(() => {
    const host = ref.current;
    host.innerHTML = "";
    const byInd = metric === "indicador";
    const W = 560, H = 540, cx = W / 2, cy = H / 2 + 6, R = byInd ? 168 : 196;
    const svg = d3.select(host).append("svg")
      .attr("viewBox", `0 0 ${W} ${H}`).attr("width", "100%").style("max-height", "560px").style("display", "block");

    // Ejes según métrica
    const axes = byInd
      ? D.INDICADORES.map((ind) => ({ id: ind.id, label: ind.corto, nombre: ind.nombre, def: ind.def, color: ind.color, indId: ind.id, sub: "Indicador", ref: ind }))
      : D.DIMENSIONES.map((dim) => ({ id: dim.id, label: dim.corto, nombre: dim.nombre, def: dim.def, color: dim.color, indId: dim.indId, sub: dim.indNombre, ref: dim }));
    const valuesOf = (t) => byInd ? D.indicadoresDe(t, gse, gradoId, anio) : D.dimsDe(t, gse, gradoId, anio);
    const N = axes.length;
    const ang = (i) => (Math.PI * 2 * i) / N - Math.PI / 2;
    const rScale = d3.scaleLinear().domain([0, 100]).range([0, R]);
    const point = (i, v) => [cx + Math.cos(ang(i)) * rScale(v), cy + Math.sin(ang(i)) * rScale(v)];

    // Cuñas de fondo -------------------------------------------
    const wedge = svg.append("g");
    if (byInd) {
      axes.forEach((ax, i) => {
        const arc = d3.arc().innerRadius(0).outerRadius(R + 6).startAngle(ang(i - 0.5) + Math.PI / 2).endAngle(ang(i + 0.5) + Math.PI / 2);
        const dimmed = focusInd && focusInd !== ax.id;
        wedge.append("path").attr("d", arc).attr("transform", `translate(${cx},${cy})`)
          .attr("fill", ax.color).attr("opacity", dimmed ? 0.025 : (focusInd ? 0.12 : 0.06));
      });
    } else {
      let idx = 0;
      D.INDICADORES.forEach((ind) => {
        const k = ind.dimensiones.length;
        const arc = d3.arc().innerRadius(0).outerRadius(R + 6).startAngle(ang(idx - 0.5) + Math.PI / 2).endAngle(ang(idx + k - 0.5) + Math.PI / 2);
        const dimmed = focusInd && focusInd !== ind.id;
        wedge.append("path").attr("d", arc).attr("transform", `translate(${cx},${cy})`)
          .attr("fill", ind.color).attr("opacity", dimmed ? 0.025 : (focusInd ? 0.12 : 0.06));
        idx += k;
      });
    }

    // Anillos de grilla ----------------------------------------
    const grid = svg.append("g");
    [20, 40, 60, 80, 100].forEach((tick) => {
      const pts = d3.range(N + 1).map((i) => point(i % N, tick));
      grid.append("polygon").attr("points", pts.map((p) => p.join(",")).join(" "))
        .attr("fill", "none").attr("stroke", "#E7DFC9").attr("stroke-width", tick === 100 ? 1.4 : 1);
      grid.append("text").attr("x", cx + 3).attr("y", cy - rScale(tick) - 2)
        .attr("font-size", 9).attr("fill", "#A99F86").text(tick);
    });

    // Ejes + etiquetas -----------------------------------------
    const axG = svg.append("g");
    axes.forEach((ax, i) => {
      const dimmed = focusInd && focusInd !== ax.indId;
      const [x, y] = point(i, 100);
      axG.append("line").attr("x1", cx).attr("y1", cy).attr("x2", x).attr("y2", y)
        .attr("stroke", ax.color).attr("stroke-width", 1).attr("opacity", dimmed ? 0.15 : 0.5);

      const la = ang(i), lx = cx + Math.cos(la) * (R + 20), ly = cy + Math.sin(la) * (R + 20);
      const anchor = Math.abs(Math.cos(la)) < 0.34 ? "middle" : (Math.cos(la) > 0 ? "start" : "end");
      const words = ax.label.split(" ");
      const lines = []; let cur = "";
      words.forEach((w) => { if ((cur + " " + w).trim().length > 14) { lines.push(cur.trim()); cur = w; } else cur += " " + w; });
      if (cur.trim()) lines.push(cur.trim());
      const g = axG.append("g").style("cursor", "pointer").attr("opacity", dimmed ? 0.32 : 1)
        .on("click", () => onAxisClick && onAxisClick(ax.ref))
        .on("mousemove", (ev) => {
          const rows = territorios.map((t) => {
            const v = valuesOf(t)[ax.id];
            return `<div class="tt-row"><span class="tt-sw" style="background:${t.color}"></span>${t.nombre}<span class="tt-v">${fmt(v)}</span></div>`;
          }).join("");
          TT.show(`<div class="tt-title">${ax.nombre}</div><div style="font-size:11px;opacity:.7;margin-bottom:4px">${ax.sub}</div>${rows}<div class="tt-def">${ax.def}</div><div class="tt-hint">Clic para ver la definición completa →</div>`, ev.clientX, ev.clientY);
        })
        .on("mouseleave", () => TT.hide());
      lines.forEach((ln, li) => {
        g.append("text").attr("x", lx).attr("y", ly + li * 11 - (lines.length - 1) * 5.5)
          .attr("text-anchor", anchor).attr("dominant-baseline", "middle")
          .attr("font-size", 11).attr("font-weight", 600).attr("fill", "#2E2230").text(ln);
      });
      g.append("circle").attr("cx", cx + Math.cos(la) * (R + 9)).attr("cy", cy + Math.sin(la) * (R + 9))
        .attr("r", 3).attr("fill", ax.color);
    });

    // Polígonos por territorio ---------------------------------
    territorios.forEach((t) => {
      const vals = valuesOf(t);
      const pts = axes.map((ax, i) => ({ i, v: vals[ax.id], ax }));
      const valid = pts.filter((p) => p.v != null);
      if (valid.length < (byInd ? 2 : 3)) return;
      const pathPts = pts.filter((p) => p.v != null).map((p) => point(p.i, p.v).join(",")).join(" ");
      svg.append("polygon").attr("points", pathPts)
        .attr("fill", t.color).attr("fill-opacity", focusInd ? 0.05 : 0.1)
        .attr("stroke", t.color).attr("stroke-width", 2).attr("stroke-linejoin", "round").attr("opacity", 0.95);
      pts.forEach((p) => {
        if (p.v == null) return;
        const dimmed = focusInd && focusInd !== p.ax.indId;
        const [x, y] = point(p.i, p.v);
        svg.append("circle").attr("cx", x).attr("cy", y).attr("r", focusInd && !dimmed ? 4 : 3)
          .attr("fill", "#fff").attr("stroke", t.color).attr("stroke-width", 2)
          .attr("opacity", dimmed ? 0.25 : 1).style("cursor", "pointer")
          .on("mousemove", (ev) => TT.show(`<div class="tt-title">${t.nombre}</div><div class="tt-row"><span class="tt-sw" style="background:${p.ax.color}"></span>${p.ax.nombre}<span class="tt-v">${fmt(p.v)}</span></div>`, ev.clientX, ev.clientY))
          .on("mouseleave", () => TT.hide());
      });
    });

    svg.append("circle").attr("cx", cx).attr("cy", cy).attr("r", 2).attr("fill", "#C8BDA0");
  }, [territorios, gse, gradoId, anio, metric, focusInd]);

  return <div ref={ref} />;
}

/* ============================================================
   LÍNEAS — small multiples. Una métrica por panel, línea por territorio.
   Maneja huecos de cobertura (sin interpolar) y año preliminar.
   ============================================================ */
function LineMini({ territorios, gse, gradoId, metric, metricKind }) {
  const ref = React.useRef(null);
  React.useEffect(() => {
    const host = ref.current; host.innerHTML = "";
    const W = 300, H = 150, m = { t: 10, r: 12, b: 24, l: 30 };
    const iw = W - m.l - m.r, ih = H - m.t - m.b;
    const svg = d3.select(host).append("svg").attr("viewBox", `0 0 ${W} ${H}`).attr("width", "100%").style("display", "block");
    const g = svg.append("g").attr("transform", `translate(${m.l},${m.t})`);

    const allYears = D.TODOS_ANIOS;                       // reserva el slot del hueco
    const cover = D.GRADOS.find((x) => x.id === gradoId).anios;
    const x = d3.scalePoint().domain(allYears).range([0, iw]).padding(0.5);
    const y = d3.scaleLinear().domain([0, 100]).range([ih, 0]);

    // grilla y
    [0, 25, 50, 75, 100].forEach((t) => {
      g.append("line").attr("x1", 0).attr("x2", iw).attr("y1", y(t)).attr("y2", y(t))
        .attr("stroke", "#EFE7D2").attr("stroke-width", 1);
      g.append("text").attr("x", -6).attr("y", y(t)).attr("dy", "0.32em").attr("text-anchor", "end")
        .attr("font-size", 8.5).attr("fill", "#A99F86").text(t);
    });

    // huecos de cobertura (año dentro del rango pero sin aplicación)
    allYears.forEach((yr) => {
      if (!cover.includes(yr)) {
        g.append("rect").attr("x", x(yr) - 13).attr("y", 0).attr("width", 26).attr("height", ih)
          .attr("fill", "#F4E9CC").attr("opacity", 0.55);
        g.append("text").attr("x", x(yr)).attr("y", ih / 2).attr("text-anchor", "middle")
          .attr("font-size", 7.5).attr("fill", "#B0967B").attr("transform", `rotate(-90 ${x(yr)} ${ih / 2})`).text("sin aplicación");
      }
    });

    // eje x
    allYears.forEach((yr) => {
      const prelim = D.PRELIMINAR.includes(yr);
      g.append("text").attr("x", x(yr)).attr("y", ih + 15).attr("text-anchor", "middle")
        .attr("font-size", 9).attr("fill", prelim ? "#B07D00" : "#747474").attr("font-weight", prelim ? 700 : 400)
        .text(yr + (prelim ? "*" : ""));
    });

    // líneas por territorio
    territorios.forEach((t) => {
      const s = D.serie(t, gse, gradoId, metric.id, metricKind);
      // segmentos: conectar solo años consecutivos con dato.
      // Estilo del segmento = significancia del cambio (b.sigVsPrev):
      //   sólido  = diferencia significativa · punteado = no significativa
      for (let i = 0; i < s.length - 1; i++) {
        const a = s[i], b = s[i + 1];
        if (a.valor != null && b.valor != null && (b.anio - a.anio) === 1) {
          const sig = b.sigVsPrev;
          const seg = g.append("line").attr("x1", x(a.anio)).attr("y1", y(a.valor)).attr("x2", x(b.anio)).attr("y2", y(b.valor))
            .attr("stroke", t.color).attr("stroke-linecap", "round");
          if (sig) seg.attr("stroke-width", 2.6);
          else seg.attr("stroke-width", 1.7).attr("stroke-dasharray", "2.5 2.8").attr("opacity", 0.55);
          // marcador de cambio significativo: triángulo de dirección en el punto posterior
          if (sig) {
            const up = b.deltaVsPrev > 0;
            const mx = x(b.anio), my = y(b.valor) + (up ? -8 : 8);
            g.append("path")
              .attr("d", up ? `M${mx},${my - 3.4} L${mx - 3},${my + 2.2} L${mx + 3},${my + 2.2} Z`
                            : `M${mx},${my + 3.4} L${mx - 3},${my - 2.2} L${mx + 3},${my - 2.2} Z`)
              .attr("fill", up ? "#5E8A2E" : "#D32036").attr("opacity", 0.95);
          }
        }
      }
      s.forEach((pt) => {
        if (pt.valor == null) return;
        const prelim = pt.preliminar;
        const sigTxt = pt.sigVsPrev == null ? ""
          : `<div class="tt-def">vs ${pt.prevAnio}: ${pt.deltaVsPrev > 0 ? "+" : ""}${pt.deltaVsPrev} pts — ${pt.sigVsPrev ? "diferencia <b>significativa</b>" : "<b>sin</b> diferencia significativa"}</div>`;
        g.append("circle").attr("cx", x(pt.anio)).attr("cy", y(pt.valor)).attr("r", prelim ? 4 : 3.4)
          .attr("fill", prelim ? "#fff" : t.color).attr("stroke", t.color).attr("stroke-width", prelim ? 2 : 1.5)
          .attr("stroke-dasharray", prelim ? "2 1.6" : null).style("cursor", "pointer")
          .on("mousemove", (ev) => TT.show(`<div class="tt-title">${t.nombre}</div><div style="font-size:11px;opacity:.75;margin-bottom:3px">${metric.nombre} · ${pt.anio}${prelim ? " (preliminar)" : ""}</div><div class="tt-row"><span class="tt-v" style="margin-left:0;font-size:15px">${fmt(pt.valor)}</span></div>${sigTxt}`, ev.clientX, ev.clientY))
          .on("mouseleave", () => TT.hide());
      });
    });
  }, [territorios, gse, gradoId, metric, metricKind]);
  return <div ref={ref} />;
}

/* ============================================================
   DISTRIBUCIÓN — barras apiladas Bajo/Medio/Alto por dimensión
   ============================================================ */
const DIST_COLORS = { bajo: "#E88663", medio: "#FFC92E", alto: "#75924E" };
function DistributionView({ territorio, gse, gradoId, anio, onDimClick }) {
  return (
    <div className="dist-wrap">
      <div className="dist-legend">
        <strong style={{ fontWeight: 700 }}>{territorio.nombre}</strong>
        <span><span className="dist-swatch" style={{ background: DIST_COLORS.bajo }} />Bajo</span>
        <span><span className="dist-swatch" style={{ background: DIST_COLORS.medio }} />Medio</span>
        <span><span className="dist-swatch" style={{ background: DIST_COLORS.alto }} />Alto</span>
        <span style={{ marginLeft: "auto", color: "var(--fg-3)" }}>% de estudiantes por nivel de favorabilidad · {anio}{D.PRELIMINAR.includes(anio) ? " (preliminar)" : ""}</span>
      </div>
      {D.DIMENSIONES.map((dim) => {
        const dist = D.distribucionDim(territorio, gse, gradoId, dim.id, anio);
        return (
          <div className="dist-row" key={dim.id}>
            <button className="dist-row-label" style={{ background: "none", border: 0, cursor: "pointer", textAlign: "left" }}
              onClick={() => onDimClick && onDimClick(dim)} title="Ver definición">
              <span className="d-ind" style={{ background: dim.color }} />{dim.corto}
            </button>
            {dist == null ? (
              <div className="dist-bar"><div className="dist-seg is-sin">sin dato (resguardo estadístico)</div></div>
            ) : (
              <div className="dist-bar">
                {["bajo", "medio", "alto"].map((k) => (
                  <div key={k} className="dist-seg" style={{ width: dist[k] + "%", background: DIST_COLORS[k], color: k === "medio" ? "#5a4500" : "#fff" }}
                    title={`${k}: ${dist[k]}%`}>{dist[k] >= 9 ? Math.round(dist[k]) : ""}</div>
                ))}
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}

/* ============================================================
   INDICADORES + DIMENSIONES — dos gráficos lado a lado.
   Barras horizontales agrupadas: una barra por entidad/territorio.
   Izquierda = los 4 indicadores · Derecha = las 11 dimensiones.
   ============================================================ */
function MetricRow({ nombre, color, valores, territorios, onClick }) {
  // valores: [{ t, v }]
  return (
    <div className="idbar-row">
      <button className="idbar-rlabel" onClick={onClick} title="Ver definición">
        <span className="r-dot" style={{ background: color }} />{nombre}
      </button>
      <div className="idbar-bars">
        {valores.map(({ t, v }) => (
          <div className="idbar-track" key={t.key}
            onMouseMove={(ev) => TT.show(`<div class="tt-title">${nombre}</div><div class="tt-row"><span class="tt-sw" style="background:${t.color}"></span>${t.nombre}<span class="tt-v">${fmt(v)}</span></div>`, ev.clientX, ev.clientY)}
            onMouseLeave={() => TT.hide()}>
            <span className="idbar-sw" style={{ background: t.color }} />
            <div className="idbar-rail">
              {v != null && <div className="idbar-fill" style={{ width: v + "%", background: t.color }} />}
            </div>
            {v == null ? <span className="idbar-sin">sin dato</span> : <span className="idbar-val">{v.toFixed(1)}</span>}
          </div>
        ))}
      </div>
    </div>
  );
}

function IndDimBars({ territorios, gse, gradoId, anio, onIndClick, onDimClick }) {
  const inds = territorios.map((t) => ({ t, vals: D.indicadoresDe(t, gse, gradoId, anio) }));
  const dims = territorios.map((t) => ({ t, vals: D.dimsDe(t, gse, gradoId, anio) }));
  return (
    <div>
      <div className="idbars-legend">
        {territorios.map((t) => (
          <span className="idbars-leg-item" key={t.key}>
            <span className="idbar-sw" style={{ background: t.color }} />{t.nombre}
          </span>
        ))}
        <span className="idbars-leg-scale">Escala 0–100 · clic en una etiqueta para su definición</span>
      </div>
      <div className="idbars-wrap">
        {/* IZQUIERDA — indicadores */}
        <div className="idbars-col">
          <div className="idbars-col-head"><Icon name="layers" size={14} /> Indicadores <span className="idbars-col-count">4</span></div>
          {D.INDICADORES.map((ind) => (
            <MetricRow key={ind.id} nombre={ind.nombre} color={ind.color}
              territorios={territorios}
              valores={inds.map(({ t, vals }) => ({ t, v: vals[ind.id] }))}
              onClick={() => onIndClick && onIndClick(ind)} />
          ))}
        </div>
        {/* DERECHA — dimensiones, agrupadas por indicador */}
        <div className="idbars-col idbars-col-right">
          <div className="idbars-col-head"><Icon name="bars" size={14} /> Dimensiones <span className="idbars-col-count">11</span></div>
          {D.INDICADORES.map((ind) => (
            <div className="idbar-group" key={ind.id}>
              <div className="idbar-group-head"><span className="g-dot" style={{ background: ind.color }} />{ind.corto}</div>
              {ind.dimensiones.map((dim) => {
                const dimFull = D.DIMENSIONES.find((d) => d.id === dim.id);
                return (
                  <MetricRow key={dim.id} nombre={dim.nombre} color={ind.color}
                    territorios={territorios}
                    valores={dims.map(({ t, vals }) => ({ t, v: vals[dim.id] }))}
                    onClick={() => onDimClick && onDimClick(dimFull)} />
                );
              })}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { Icon, TT, RadarChart, LineMini, DistributionView, IndDimBars, fmt, IDPS_D: D });
```


## `idps-controls.jsx`

```jsx
/* ============================================================
   slep_idps — Controles, selector territorial, definiciones, footer
   ============================================================ */
"use strict";

const CD = window.IDPS;

/* ---------- Segmented genérico ---------- */
function Segmented({ value, options, onChange, tiny }) {
  return (
    <div className={"segmented" + (tiny ? " tiny" : "")} role="tablist">
      {options.map((o) => {
        const opt = typeof o === "string" ? { value: o, label: o } : o;
        return (
          <button key={opt.value} role="tab" aria-selected={value === opt.value} disabled={opt.disabled}
            className={"segmented-btn" + (value === opt.value ? " is-active" : "")}
            onClick={() => !opt.disabled && onChange(opt.value)} title={opt.title || ""}>
            {opt.label}
          </button>
        );
      })}
    </div>
  );
}

/* ---------- Header con intro conceptual ---------- */
function Header({ onOpenDefs }) {
  return (
    <header className="app-header">
      <div className="app-header-inner">
        <div className="brand-row">
          <svg className="brand-mark" viewBox="0 0 32 32" aria-hidden="true">
            <g transform="translate(16 15)" fill="none" stroke="#FFF6E0" strokeWidth="1.3">
              <polygon points="0,-11 9.5,5.5 -9.5,5.5" />
              <polygon points="0,-7 6,3.5 -6,3.5" opacity="0.5" />
            </g>
            <circle cx="16" cy="15" r="2.3" fill="#E88663" />
          </svg>
          <div className="brand-eyebrow">SLEP Costa Central<br /><span className="muted">Monitoreo y Seguimiento</span></div>
          <span className="brand-pill"><code>slep_idps</code> · v1 mockup</span>
        </div>

        <h1 className="app-title">
          Motor de Indicadores de Desarrollo Personal y Social
          <span className="sub">Comparación de los IDPS entre territorios y en el tiempo, segmentada por grupo socioeconómico (GSE)</span>
        </h1>

        <p className="app-objective">
          {CD.intro}{" "}
          Esta herramienta permite comparar los IDPS entre <strong>establecimientos, comunas, SLEP, regiones y el total nacional</strong>,
          observando tanto la <strong>foto del estado actual</strong> como su <strong>evolución en el tiempo</strong>.{" "}
          <button className="link-def-intro" onClick={() => onOpenDefs({ kind: "all" })}>Ver qué mide cada indicador y dimensión →</button>
        </p>

        <div className="header-meta">
          <span className="hmeta"><b>4</b> indicadores · <b>11</b> dimensiones</span>
          <span className="hmeta">Escala <b>0–100</b> · 100 = percepciones más positivas</span>
          <span className="hmeta">Fuente: <b>Agencia de Calidad de la Educación</b></span>
          <span className="hmeta">Cobertura: <b>todo Chile</b></span>
        </div>
      </div>
    </header>
  );
}

/* ---------- Selector de GSE (siempre visible) ---------- */
function GseSelector({ gse, setGse }) {
  return (
    <div className="gse-block">
      <div className="gse-head">
        <span className="control-label">Grupo socioeconómico (GSE)</span>
        <span className="lock"><Icon name="lock" size={12} /> Segmentación siempre presente</span>
      </div>
      <div className="gse-seg">
        {CD.GSE.map((g) => (
          <button key={g.cod} className={"gse-btn" + (gse === g.cod ? " is-active" : "")} onClick={() => setGse(g.cod)}>
            <span className="g-cod">{g.cod}</span>
            <span className="g-lab">{g.corto}</span>
          </button>
        ))}
      </div>
      <div className="gse-scale"><span>Bajo</span><span className="bar" /><span>Alto</span></div>
    </div>
  );
}

/* ---------- Chips de territorio ---------- */
function TerritoryChips({ territorios, removeTerr, openModal }) {
  const tipoLabel = { pais: "País", region: "Región", slep: "SLEP", comuna: "Comuna", estab: "Establecimiento" };
  return (
    <div className="terr-section">
      <div className="terr-head">
        <span className="section-eyebrow">Territorios en comparación</span>
        <span className="terr-count">{territorios.length} de {CD.MAX_TERRITORIOS}</span>
      </div>
      <div className="terr-list">
        {territorios.map((t) => (
          <div className="terr-chip" key={t.key} style={{ borderLeftColor: t.color }}>
            <span className="terr-swatch" style={{ background: t.color }} />
            <span className="terr-text">
              <span className="terr-name">{t.nombre}</span>
              <span className="terr-meta">{tipoLabel[t.kind]}{t.meta ? " · " + t.meta : ""}</span>
            </span>
            <button className="terr-x" onClick={() => removeTerr(t.key)} aria-label={"Quitar " + t.nombre}><Icon name="x" size={14} /></button>
          </div>
        ))}
        <button className="terr-add" onClick={openModal} disabled={territorios.length >= CD.MAX_TERRITORIOS}>
          <Icon name="plus" size={15} /> Agregar territorio
        </button>
      </div>
      <p className="terr-hint"><Icon name="map" size={14} /> Disponible para todo el país: compara una comuna del SLEP con su región y con el total nacional en un mismo gráfico.</p>
    </div>
  );
}

/* ---------- Modal selector territorial ---------- */
const LEVELS = [
  { kind: "pais", label: "País", icon: "flag", desc: "El total nacional agrega todos los establecimientos del país." },
  { kind: "region", label: "Región", icon: "map", desc: "Las 16 regiones de Chile están disponibles para comparar." },
  { kind: "slep", label: "SLEP", icon: "layers", desc: "Servicios Locales de Educación Pública. Costa Central es el foco de este equipo." },
  { kind: "comuna", label: "Comuna", icon: "map", desc: "Comunas de todo el país, no solo las del SLEP Costa Central." },
  { kind: "estab", label: "Establecimiento", icon: "building", desc: "Establecimientos individuales (RBD). Algunos GSE pueden estar suprimidos por resguardo estadístico." },
];
const REGION_NOMBRE = Object.fromEntries(CD.REGIONES.map((r) => [r.id, r.nombre]));
const SLEP_NOMBRE = Object.fromEntries(CD.SLEPS.map((s) => [s.id, s.nombre]));

function buildOptions(kind) {
  if (kind === "pais") return [{ id: "chile", nombre: CD.PAIS.nombre, meta: "Agregado de todo el país", key: "pais|chile" }];
  if (kind === "region") return CD.REGIONES.map((r) => ({ id: r.id, nombre: "Región de " + r.nombre, meta: "Región", key: "region|" + r.id }));
  if (kind === "slep") return CD.SLEPS.map((s) => ({ id: s.id, nombre: "SLEP " + s.nombre, meta: `${s.comunas.length} comunas · ${REGION_NOMBRE[s.region]}`, key: "slep|" + s.id, foco: s.id === "slep_costacentral" }));
  if (kind === "comuna") return CD.COMUNAS.map((c) => ({ id: c.id, nombre: c.nombre, meta: `${REGION_NOMBRE[c.region]}${c.slep ? " · SLEP " + SLEP_NOMBRE[c.slep] : ""}`, key: "comuna|" + c.id, foco: c.slep === "slep_costacentral" }));
  return CD.ESTABLECIMIENTOS.map((e) => ({ id: e.id, nombre: e.nombre, meta: `RBD ${e.rbd} · ${CD.COMUNAS.find((c) => c.id === e.comuna).nombre}`, key: "estab|" + e.id, foco: e.slep === "slep_costacentral" }));
}

function TerritoryModal({ taken, slotsLeft, onAdd, onClose }) {
  const [level, setLevel] = React.useState("slep");
  const [q, setQ] = React.useState("");
  const [sel, setSel] = React.useState([]);
  const levelDef = LEVELS.find((l) => l.kind === level);
  const opts = buildOptions(level).filter((o) => o.nombre.toLowerCase().includes(q.toLowerCase()));
  const isTaken = (key) => taken.includes(key);

  function toggle(o) {
    if (isTaken(o.key)) return;
    setSel((prev) => prev.find((p) => p.key === o.key) ? prev.filter((p) => p.key !== o.key) : (prev.length + 1 > slotsLeft ? prev : [...prev, o]));
  }
  function confirm() {
    onAdd(sel.map((o) => ({ kind: level, id: o.id, key: o.key, nombre: o.nombre, meta: o.meta })));
  }

  return (
    <div className="modal-scrim" onClick={onClose}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-head">
          <h3>Agregar territorios a la comparación</h3>
          <p>Todo Chile está disponible. Quedan {slotsLeft} {slotsLeft === 1 ? "espacio" : "espacios"} de comparación.</p>
        </div>
        <div className="modal-body">
          <div className="level-tabs">
            {LEVELS.map((l) => (
              <button key={l.kind} className={"level-tab" + (level === l.kind ? " is-active" : "")} onClick={() => { setLevel(l.kind); setQ(""); }}>
                <Icon name={l.icon} size={15} /> {l.label}
              </button>
            ))}
          </div>
          <p className="level-desc"><Icon name="info" size={14} /> {levelDef.desc}</p>
          <div className="search-box">
            <Icon name="search" size={16} style={{ color: "var(--fg-3)" }} />
            <input placeholder={"Buscar " + levelDef.label.toLowerCase() + "…"} value={q} onChange={(e) => setQ(e.target.value)} />
          </div>
          <div className="opt-list">
            {opts.map((o) => {
              const taken_ = isTaken(o.key), selected = sel.find((s) => s.key === o.key);
              const full = !selected && sel.length >= slotsLeft;
              return (
                <button key={o.key} className={"opt-row" + (selected ? " is-sel" : "") + (taken_ || full ? " is-disabled" : "")}
                  onClick={() => toggle(o)} disabled={taken_ || full}>
                  <span className="opt-check">{selected && <Icon name="check" size={13} />}</span>
                  <span className="opt-main">
                    <span className="opt-name">{o.nombre}</span>
                    <span className="opt-meta">{taken_ ? "Ya en comparación" : o.meta}</span>
                  </span>
                  {o.foco && <span className="opt-flag">Costa Central</span>}
                </button>
              );
            })}
            {opts.length === 0 && <p style={{ color: "var(--fg-3)", fontSize: 13, padding: "12px 4px" }}>Sin resultados.</p>}
          </div>
        </div>
        <div className="modal-foot">
          <span style={{ fontSize: 13, color: "var(--fg-3)" }}>{sel.length} seleccionado(s)</span>
          <div style={{ display: "flex", gap: 10 }}>
            <button className="btn btn-ghost btn-small" onClick={onClose}>Cancelar</button>
            <button className="btn btn-primary btn-small" onClick={confirm} disabled={sel.length === 0}>
              Agregar {sel.length > 0 ? `(${sel.length})` : ""}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

/* ---------- Drawer de definiciones ---------- */
function IndicatorCard({ ind, highlightDim }) {
  return (
    <div className="drawer-card" style={{ borderLeft: `3px solid ${ind.color}` }}>
      <div className="drawer-ind-tag"><span className="tg-dot" style={{ background: ind.color }} />Indicador {ind.n}</div>
      <h4 style={{ marginTop: 6 }}>{ind.nombre}</h4>
      <p style={{ margin: "6px 0 0", fontSize: 13.5 }}>{ind.def}</p>
      {ind.dimensiones.map((d, i) => (
        <div className="drawer-dim" key={d.id} style={highlightDim === d.id ? { background: "var(--ocean-20)", margin: "12px -8px 0", padding: "12px 8px 0", borderRadius: 4 } : null}>
          <div className="drawer-dim-name"><span className="dd-n">D{ind.n}.{i + 1}</span>{d.nombre}</div>
          <p style={{ margin: 0, fontSize: 13 }}>{d.def}</p>
        </div>
      ))}
    </div>
  );
}

function DefinitionsDrawer({ target, onClose }) {
  const open = !!target;
  let content = null, eyebrow = "Definiciones", title = "Indicadores y dimensiones";
  if (target) {
    if (target.kind === "all") {
      eyebrow = "Marco conceptual"; title = "Los 4 indicadores IDPS";
      content = (<React.Fragment>
        <p>Los IDPS se organizan en <strong>4 indicadores</strong> que agrupan <strong>11 dimensiones</strong>. Cada uno se mide en una escala de 0 a 100.</p>
        {CD.INDICADORES.map((ind) => <IndicatorCard key={ind.id} ind={ind} />)}
      </React.Fragment>);
    } else if (target.kind === "ind") {
      const ind = CD.INDICADORES.find((i) => i.id === target.id);
      eyebrow = `Indicador ${ind.n}`; title = ind.nombre;
      content = <IndicatorCard ind={ind} />;
    } else if (target.kind === "dim") {
      const ind = CD.INDICADORES.find((i) => i.id === target.dim.indId);
      eyebrow = ind.nombre; title = target.dim.nombre;
      content = (<React.Fragment>
        <p>{target.dim.def}</p>
        <IndicatorCard ind={ind} highlightDim={target.dim.id} />
      </React.Fragment>);
    }
  }
  return (
    <React.Fragment>
      <div className={"drawer-scrim" + (open ? " is-open" : "")} onClick={onClose} />
      <aside className={"drawer" + (open ? " is-open" : "")} aria-hidden={!open}>
        <div className="drawer-head">
          <div>
            <div className="d-eyebrow">{eyebrow}</div>
            <h3>{title}</h3>
          </div>
          <button className="drawer-close" onClick={onClose} aria-label="Cerrar"><Icon name="close" size={18} /></button>
        </div>
        <div className="drawer-body">{content}</div>
      </aside>
    </React.Fragment>
  );
}

/* ---------- Footer notas metodológicas ---------- */
function FooterNotes() {
  const [open, setOpen] = React.useState(false);
  return (
    <footer className="app-footer">
      <button className={"notes-toggle" + (open ? " is-open" : "")} onClick={() => setOpen(!open)}>
        <Icon name="info" size={16} /> Notas metodológicas y fuentes
        <span className="chev"><Icon name="chevron" size={15} /></span>
      </button>
      {open && (
        <div className="notes-body">
          <div className="notes-grid">
            <article className="note">
              <h4>¿Qué son los IDPS?</h4>
              <p>Los Indicadores de Desarrollo Personal y Social son un conjunto de índices de la Agencia de Calidad de la Educación que miden el desarrollo personal y social de las y los estudiantes, complementando los resultados académicos del Simce.</p>
              <p>Se construyen a partir de cuestionarios tipo Likert aplicados a estudiantes, docentes y apoderados, y se expresan en una escala de 0 a 100, donde 100 corresponde a las percepciones más positivas. Son un insumo de la Categoría de Desempeño de cada establecimiento.</p>
            </article>
            <article className="note">
              <h4>Segmentación por GSE</h4>
              <p>Todos los resultados se presentan segmentados por <b>Grupo Socioeconómico</b> (GSE 1 Bajo a GSE 5 Alto), siguiendo las normas de la Agencia de Calidad. La comparación entre territorios es válida principalmente <b>dentro de un mismo GSE</b>; por eso el selector de GSE está siempre presente.</p>
            </article>
            <article className="note">
              <h4>Cobertura temporal por grado</h4>
              <p>La disponibilidad de datos es asimétrica: <b>2° medio</b> 2022–2025; <b>4° básico</b> 2022, 2023 y 2025 (sin aplicación en 2024); <b>6° básico</b> solo 2024; <b>8° básico</b> solo 2025. Cuando un grado tiene un único año, la vista de evolución se deshabilita.</p>
            </article>
            <article className="note">
              <h4>Datos preliminares 2025</h4>
              <p>Los resultados de <b>2025 son preliminares</b> y están sujetos a revisión por la Agencia de Calidad de la Educación. Se marcan con asterisco (*) y con un punto de borde discontinuo en todos los gráficos.</p>
            </article>
            <article className="note">
              <h4>Datos suprimidos</h4>
              <p>Por resguardo estadístico, algunas combinaciones (especialmente en establecimientos o GSE poco poblados) no publican valor. Se representan como <b>“sin dato”</b>, nunca como cero, y las líneas no se interpolan sobre el hueco.</p>
            </article>
            <article className="note">
              <h4>Datos de ejemplo</h4>
              <p>Esta es una maqueta de interfaz: las cifras son <b>ilustrativas (0–100) y generadas de forma determinista</b>, no provienen del pipeline oficial. Sirven para demostrar el comportamiento de la herramienta.</p>
            </article>
          </div>
          <div className="notes-sources">
            <span>Fuente conceptual: Agencia de Calidad de la Educación · Indicadores de Desarrollo Personal y Social.</span>
            <span>Hermano del motor <code>slep_simce_adecuado</code> · Área de Monitoreo y Seguimiento · SLEP Costa Central.</span>
          </div>
        </div>
      )}
    </footer>
  );
}

Object.assign(window, { Segmented, Header, GseSelector, TerritoryChips, TerritoryModal, DefinitionsDrawer, FooterNotes });
```


## `idps-app.jsx`

```jsx
/* ============================================================
   slep_idps — App principal
   ============================================================ */
"use strict";

const A = window.IDPS;

function pickColors(existing, n) {
  const used = existing.map((e) => e.color);
  const free = A.TERRITORIO_PALETTE.filter((c) => !used.includes(c));
  const out = [];
  for (let i = 0; i < n; i++) out.push(free[i] || A.TERRITORIO_PALETTE[i % A.TERRITORIO_PALETTE.length]);
  return out;
}

// Estado inicial precargado: SLEP Costa Central vs Región Valparaíso vs Chile
const INITIAL = (function () {
  const raw = [
    { kind: "slep", id: "slep_costacentral", key: "slep|slep_costacentral", nombre: "SLEP Costa Central", meta: "4 comunas · Valparaíso" },
    { kind: "region", id: "r05", key: "region|r05", nombre: "Región de Valparaíso", meta: "Región" },
    { kind: "pais", id: "chile", key: "pais|chile", nombre: "Chile (total nacional)", meta: "Agregado de todo el país" },
  ];
  const cols = A.TERRITORIO_PALETTE;
  return raw.map((r, i) => ({ ...r, color: cols[i] }));
})();

function App() {
  const [territorios, setTerritorios] = React.useState(INITIAL);
  const [gse, setGse] = React.useState(3);
  const [gradoId, setGradoId] = React.useState("2m");
  const grado = A.GRADOS.find((g) => g.id === gradoId);
  const [anio, setAnio] = React.useState(A.anioReciente("2m"));
  const [vista, setVista] = React.useState("actual");      // actual | evolucion
  const [vizActual, setVizActual] = React.useState("dual"); // dual | radar | distribucion
  const [metricKind, setMetricKind] = React.useState("indicador"); // indicador | dimension
  const [focusInd, setFocusInd] = React.useState(null);
  const [distTerrKey, setDistTerrKey] = React.useState(INITIAL[0].key);
  const [modal, setModal] = React.useState(false);
  const [defTarget, setDefTarget] = React.useState(null);

  const evolucionDisponible = grado.anios.length > 1;

  // Ajustar año cuando cambia el grado (tomar el más reciente válido)
  React.useEffect(() => {
    if (!grado.anios.includes(anio)) setAnio(A.anioReciente(gradoId));
    if (!evolucionDisponible && vista === "evolucion") setVista("actual");
  }, [gradoId]);

  // Territorio para distribución (válido)
  const distTerr = territorios.find((t) => t.key === distTerrKey) || territorios[0];
  React.useEffect(() => {
    if (territorios.length && !territorios.find((t) => t.key === distTerrKey)) setDistTerrKey(territorios[0].key);
  }, [territorios]);

  function addTerritorios(nuevos) {
    setTerritorios((prev) => {
      const libres = A.MAX_TERRITORIOS - prev.length;
      const add = nuevos.slice(0, Math.max(0, libres));
      const cols = pickColors(prev, add.length);
      return [...prev, ...add.map((t, i) => ({ ...t, color: cols[i] }))];
    });
    setModal(false);
  }
  function removeTerr(key) { setTerritorios((prev) => prev.filter((t) => t.key !== key)); }

  const gseLabel = A.GSE.find((g) => g.cod === gse).label;
  const prelim = A.PRELIMINAR.includes(anio);

  const gradoOpts = A.GRADOS.map((g) => ({ value: g.id, label: g.label }));
  const anioOpts = grado.anios.map((y) => ({ value: y, label: y + (A.PRELIMINAR.includes(y) ? "*" : "") }));

  return (
    <div className="app">
      <Header onOpenDefs={setDefTarget} />

      <main className="app-main">
        {/* ---------- Controles ---------- */}
        <section className="controls">
          <div className="controls-row">
            <div className="control-group">
              <span className="control-label">Grado</span>
              <Segmented value={gradoId} options={gradoOpts} onChange={setGradoId} />
            </div>

            <div className="control-group">
              <span className="control-label"><Icon name="clock" size={12} /> Modo temporal</span>
              <Segmented value={vista} onChange={setVista} options={[
                { value: "actual", label: "Estado actual" },
                { value: "evolucion", label: "Evolución", disabled: !evolucionDisponible, title: evolucionDisponible ? "" : "Este grado tiene un solo año de datos" },
              ]} />
            </div>

            {vista === "actual" && (
              <div className="control-group">
                <span className="control-label">Año {prelim && <span className="badge badge-prelim" style={{ marginLeft: 4 }}>preliminar*</span>}</span>
                <Segmented value={anio} onChange={setAnio} options={anioOpts} />
              </div>
            )}

            {vista === "actual" ? (
              <div className="control-group">
                <span className="control-label">Visualización</span>
                <Segmented value={vizActual} onChange={setVizActual} options={[
                  { value: "dual", label: "Indicador y dimensión" },
                  { value: "radar", label: "Radar 11 dimensiones" },
                  { value: "distribucion", label: "Distribución" },
                ]} />
              </div>
            ) : (
              <div className="control-group">
                <span className="control-label">Líneas por</span>
                <Segmented value={metricKind} onChange={setMetricKind} options={[
                  { value: "indicador", label: "Indicador" },
                  { value: "dimension", label: "Dimensión" },
                ]} />
              </div>
            )}

            <div style={{ flex: 1 }} />
            <GseSelector gse={gse} setGse={setGse} />
          </div>
        </section>

        {/* ---------- Territorios ---------- */}
        <TerritoryChips territorios={territorios} removeTerr={removeTerr} openModal={() => setModal(true)} />

        {/* ---------- Visualización ---------- */}
        {territorios.length === 0 ? (
          <div className="empty-board">
            <div className="es-title">Agrega un territorio para comenzar</div>
            <p style={{ margin: "0 auto" }}>Compara establecimientos, comunas, SLEP, regiones o el total nacional. Todo Chile está disponible.</p>
          </div>
        ) : (
          <section className="viz-section">
            <div className="viz-head">
              <div>
                <span className="section-eyebrow">{vista === "actual" ? "Estado actual" : "Evolución histórica"} · {gseLabel}</span>
                <h2 className="viz-title">
                  {vista === "actual"
                    ? (vizActual === "radar" ? "Desarrollo integral — radar de las 11 dimensiones"
                      : vizActual === "dual" ? "Desarrollo integral — por indicador y por dimensión"
                      : "Distribución por nivel de favorabilidad")
                    : (metricKind === "indicador" ? "Evolución por indicador" : "Evolución por dimensión")}
                </h2>
                <p className="viz-sub">
                  {grado.label} · {gseLabel} · {vista === "actual" ? <span>{anio}{prelim && <span className="prelim-star"> * preliminar</span>}</span> : <span>serie {grado.anios[0]}–{grado.anios[grado.anios.length - 1]}</span>}
                  {" · "}{territorios.length} territorio(s)
                </p>
              </div>
              <div className="viz-actions">
                <button className="btn btn-ghost btn-small" onClick={() => setDefTarget({ kind: "all" })}>
                  <Icon name="info" size={14} /> Definiciones
                </button>
              </div>
            </div>

            {/* RADAR */}
            {vista === "actual" && vizActual === "radar" && (
              <div className="panel radar-wrap">
                <div className="radar-stage">
                  <RadarChart territorios={territorios} gse={gse} gradoId={gradoId} anio={anio}
                    focusInd={focusInd} onAxisClick={(dim) => setDefTarget({ kind: "dim", dim })} />
                </div>
                <div className="radar-side">
                  <div>
                    <div className="radar-legend-title">Indicadores</div>
                    <div className="ind-legend">
                      {A.INDICADORES.map((ind) => (
                        <div key={ind.id} className={"ind-legend-item" + (focusInd && focusInd !== ind.id ? " is-dim" : "")}>
                          <button onClick={() => setFocusInd(focusInd === ind.id ? null : ind.id)}
                            style={{ display: "flex", alignItems: "center", gap: 9, background: "none", border: 0, cursor: "pointer", flex: 1, textAlign: "left", padding: 0 }}
                            title="Enfocar este indicador en el radar">
                            <span className="ind-dot" style={{ background: ind.color }} />
                            <span className="ind-legend-name">{ind.corto}</span>
                          </button>
                          <button className="ind-legend-info" onClick={() => setDefTarget({ kind: "ind", id: ind.id })} aria-label={"Definición de " + ind.corto} title="Ver definición">
                            <Icon name="info" size={15} />
                          </button>
                        </div>
                      ))}
                    </div>
                    {focusInd ? (
                      <div className="focus-note" style={{ marginTop: 10 }}>
                        <Icon name="filter" size={13} /> Enfocando un indicador.
                        <button className="focus-clear" onClick={() => setFocusInd(null)}>Ver los 4</button>
                      </div>
                    ) : (
                      <p style={{ fontSize: 11.5, color: "var(--fg-3)", margin: "10px 0 0", lineHeight: 1.45 }}>Clic en un indicador para aislar sus dimensiones. Clic en una arista del radar para su definición.</p>
                    )}
                  </div>

                  <div>
                    <div className="radar-legend-title">Territorios</div>
                    <div className="terr-legend">
                      {territorios.map((t) => (
                        <div className="terr-legend-item" key={t.key}>
                          <span className="terr-legend-line" style={{ borderTopColor: t.color }} />
                          <span className="terr-legend-name">{t.nombre}</span>
                        </div>
                      ))}
                    </div>
                  </div>

                  <p style={{ fontSize: 11.5, color: "var(--fg-3)", margin: 0, lineHeight: 1.45, borderTop: "1px solid var(--line)", paddingTop: 14 }}>
                    Escala completa 0–100 (100 = percepciones más positivas). Cada polígono es un territorio en {gseLabel}, {grado.label}, {anio}{prelim ? "*" : ""}.
                  </p>
                </div>
              </div>
            )}

            {/* DOS RADARES — por indicador y por dimensión */}
            {vista === "actual" && vizActual === "dual" && (
              <div className="panel">
                <div className="dual-legends">
                  <div>
                    <div className="radar-legend-title">Indicadores</div>
                    <div className="dual-ind-legend">
                      {A.INDICADORES.map((ind) => (
                        <div key={ind.id} className={"dual-ind-chip" + (focusInd && focusInd !== ind.id ? " is-dim" : "") + (focusInd === ind.id ? " is-on" : "")}>
                          <button className="dual-ind-main" onClick={() => setFocusInd(focusInd === ind.id ? null : ind.id)} title="Enfocar este indicador en ambos radares">
                            <span className="ind-dot" style={{ background: ind.color }} />
                            <span className="ind-legend-name">{ind.corto}</span>
                          </button>
                          <button className="ind-legend-info" onClick={() => setDefTarget({ kind: "ind", id: ind.id })} title="Ver definición"><Icon name="info" size={14} /></button>
                        </div>
                      ))}
                    </div>
                  </div>
                  <div style={{ marginLeft: "auto" }}>
                    <div className="radar-legend-title">Territorios</div>
                    <div className="terr-legend" style={{ flexDirection: "row", flexWrap: "wrap", gap: "6px 16px" }}>
                      {territorios.map((t) => (
                        <div className="terr-legend-item" key={t.key}>
                          <span className="terr-legend-line" style={{ borderTopColor: t.color }} />
                          <span className="terr-legend-name">{t.nombre}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
                {focusInd && (
                  <div className="dual-focus-note"><Icon name="filter" size={13} /> Enfocando un indicador en ambos radares.
                    <button className="focus-clear" onClick={() => setFocusInd(null)}>Ver los 4</button>
                  </div>
                )}
                <div className="dual-radar">
                  <div className="radar-pane">
                    <div className="radar-pane-head"><Icon name="layers" size={14} /> Vista por indicador <span className="cnt">4 ejes</span></div>
                    <RadarChart territorios={territorios} gse={gse} gradoId={gradoId} anio={anio} metric="indicador"
                      focusInd={focusInd} onAxisClick={(ind) => setDefTarget({ kind: "ind", id: ind.id })} />
                  </div>
                  <div className="radar-pane">
                    <div className="radar-pane-head"><Icon name="radar" size={14} /> Vista por dimensión <span className="cnt">11 ejes</span></div>
                    <RadarChart territorios={territorios} gse={gse} gradoId={gradoId} anio={anio} metric="dimension"
                      focusInd={focusInd} onAxisClick={(dim) => setDefTarget({ kind: "dim", dim })} />
                  </div>
                </div>
                <p style={{ fontSize: 11.5, color: "var(--fg-3)", margin: 0, padding: "0 20px 18px", lineHeight: 1.45 }}>
                  Escala completa 0–100. Izquierda: los 4 indicadores agregados. Derecha: las 11 dimensiones que los componen. Clic en un indicador para aislarlo en ambos radares; clic en una arista para su definición. {gseLabel}, {grado.label}, {anio}{prelim ? "*" : ""}.
                </p>
              </div>
            )}

            {/* DISTRIBUCIÓN */}
            {vista === "actual" && vizActual === "distribucion" && (
              <div className="panel">
                <div style={{ display: "flex", alignItems: "center", gap: 10, flexWrap: "wrap", padding: "16px 18px 0" }}>
                  <span className="control-label" style={{ marginRight: 4 }}>Territorio</span>
                  <Segmented tiny value={distTerr.key} onChange={setDistTerrKey}
                    options={territorios.map((t) => ({ value: t.key, label: t.nombre }))} />
                </div>
                <DistributionView territorio={distTerr} gse={gse} gradoId={gradoId} anio={anio} onDimClick={(dim) => setDefTarget({ kind: "dim", dim })} />
              </div>
            )}

            {/* EVOLUCIÓN — líneas */}
            {vista === "evolucion" && (
              <div className="panel">
                <div style={{ padding: "14px 18px 0", display: "flex", gap: "8px 16px", flexWrap: "wrap", alignItems: "center", fontSize: 12, color: "var(--fg-2)" }}>
                  <span style={{ display: "inline-flex", alignItems: "center", gap: 6 }}><svg width="22" height="8"><line x1="1" y1="4" x2="21" y2="4" stroke="var(--plum)" strokeWidth="2.6" /></svg> cambio significativo vs. año anterior</span>
                  <span style={{ display: "inline-flex", alignItems: "center", gap: 4 }}><span style={{ color: "#5E8A2E" }}>▲</span><span style={{ color: "#D32036" }}>▼</span> dirección del cambio</span>
                  <span style={{ display: "inline-flex", alignItems: "center", gap: 6 }}><svg width="22" height="8"><line x1="1" y1="4" x2="21" y2="4" stroke="var(--plum)" strokeWidth="1.7" strokeDasharray="2.5 2.8" opacity="0.6" /></svg> sin diferencia significativa</span>
                  <span style={{ display: "inline-flex", alignItems: "center", gap: 6 }}><span style={{ width: 10, height: 10, borderRadius: "50%", border: "2px dashed var(--plum)", display: "inline-block" }} /> año preliminar (*)</span>
                  <span style={{ display: "inline-flex", alignItems: "center", gap: 6 }}><span style={{ width: 14, height: 12, background: "var(--cream-200)", display: "inline-block", borderRadius: 2 }} /> sin aplicación (no se interpola)</span>
                </div>
                <div className="lines-grid" style={{ gridTemplateColumns: metricKind === "indicador" ? "repeat(auto-fit,minmax(260px,1fr))" : "repeat(auto-fit,minmax(240px,1fr))" }}>
                  {(metricKind === "indicador" ? A.INDICADORES : A.DIMENSIONES).map((m) => (
                    <div className="line-card" key={m.id}>
                      <div className="line-card-head">
                        <span className="line-card-dot" style={{ background: m.color }} />
                        <div style={{ minWidth: 0 }}>
                          <div className="line-card-title">{metricKind === "indicador" ? m.corto : m.corto}</div>
                          {metricKind === "dimension" && <div className="line-card-sub">{m.indNombre}</div>}
                        </div>
                        <button className="line-card-info" onClick={() => setDefTarget(metricKind === "indicador" ? { kind: "ind", id: m.id } : { kind: "dim", dim: m })} title="Ver definición"><Icon name="info" size={14} /></button>
                      </div>
                      <LineMini territorios={territorios} gse={gse} gradoId={gradoId} metric={m} metricKind={metricKind} />
                    </div>
                  ))}
                </div>
              </div>
            )}
          </section>
        )}

        <FooterNotes />
      </main>

      {modal && (
        <TerritoryModal taken={territorios.map((t) => t.key)} slotsLeft={A.MAX_TERRITORIOS - territorios.length}
          onAdd={addTerritorios} onClose={() => setModal(false)} />
      )}
      <DefinitionsDrawer target={defTarget} onClose={() => setDefTarget(null)} />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
```
