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
