import React, { useState, useMemo, useRef, useEffect } from "react";

// ============================================================
// PROTOTIPO — Motor IDPS · Radar de desarrollo integral
// Estética heredada de slep_simce_adecuado (motor madre).
// Datos reales 4° básico 2025 (dimensiones), agregación
// PROVISIONAL por promedio simple (pendiente ponderación).
// ============================================================

const DATA = {"meta":{"agno":2025,"grado":"4b","ponderacion":"PROMEDIO_SIMPLE_PROVISIONAL"},"dim_labels":{"11":"Autopercepción y autovaloración académica","12":"Motivación escolar","21":"Ambiente de respeto","22":"Ambiente organizado","23":"Ambiente seguro","31":"Participación","32":"Vida democrática","33":"Sentido de pertenencia","41":"Hábitos de vida activa","42":"Hábitos alimenticios","43":"Hábitos de autocuidado"},"ind_labels":{"1":"Autoestima Académica y Motivación Escolar","2":"Clima de Convivencia Escolar","3":"Participación y Formación Ciudadana","4":"Hábitos de Vida Saludable"},"gse_labels":{"1":"Bajo","2":"Medio bajo","3":"Medio","4":"Medio alto","5":"Alto"},"ind_dims":{"1":[11,12],"2":[21,22,23],"3":[31,32,33],"4":[41,42,43]},"data":{"NACIONAL":{"TODOS":{"11":72.5,"12":76.9,"22":82.5,"21":69.9,"23":76.0,"43":76.6,"42":71.0,"41":64.8,"31":78.4,"33":79.0,"32":79.1},"4":{"11":70.8,"12":74.2,"22":79.6,"21":68.9,"23":75.4,"43":76.4,"42":70.2,"41":63.5,"31":74.4,"33":77.4,"32":78.3},"2":{"11":73.4,"12":78.2,"22":83.4,"21":70.3,"23":76.2,"43":77.0,"42":72.1,"41":65.7,"31":79.7,"33":79.7,"32":80.0},"3":{"11":72.0,"12":76.0,"22":81.4,"21":69.4,"23":76.0,"43":76.8,"42":71.3,"41":64.8,"31":76.8,"33":78.3,"32":79.0},"1":{"11":72.8,"12":78.8,"43":76.4,"42":71.3,"41":65.6,"31":82.1,"33":79.9,"32":79.0,"22":84.7,"21":70.5,"23":76.0},"5":{"11":71.2,"12":73.1,"22":80.1,"21":70.4,"23":76.7,"43":75.0,"42":65.9,"41":61.3,"31":74.1,"33":78.5,"32":77.5}},"REGION_5":{"TODOS":{"11":71.6,"12":75.6,"22":81.3,"21":69.1,"23":75.3,"43":75.7,"42":69.8,"41":63.7,"31":77.7,"33":77.6,"32":77.8},"3":{"11":70.8,"12":74.5,"22":80.3,"21":68.4,"23":75.1,"43":75.8,"42":69.8,"41":63.4,"31":76.5,"33":76.5,"32":77.2},"2":{"11":72.9,"12":77.5,"22":82.9,"21":69.6,"23":75.3,"43":75.7,"42":71.1,"41":64.9,"31":80.0,"33":78.6,"32":78.9},"1":{"11":72.1,"12":77.6,"22":81.8,"21":68.8,"23":74.1,"43":75.1,"42":69.4,"41":63.2,"31":80.0,"33":77.3,"32":77.3},"4":{"11":70.4,"12":73.4,"22":79.6,"21":69.0,"23":75.4,"43":76.1,"42":69.5,"41":63.1,"31":75.4,"33":77.4,"32":77.5},"5":{"11":71.1,"12":73.6,"22":80.6,"21":70.5,"23":76.9,"43":75.6,"42":65.7,"41":61.4,"31":74.4,"33":78.7,"32":77.2}},"SLEP_CC":{"TODOS":{"11":69.9,"12":73.6,"22":79.1,"21":67.6,"23":72.8,"43":74.2,"42":67.4,"41":61.3,"31":75.9,"33":75.3,"32":75.3},"5":{"11":70.8,"12":72.8,"22":80.6,"21":70.2,"23":76.3,"43":73.6,"42":62.6,"41":58.7,"31":74.7,"33":77.3,"32":76.0},"3":{"11":69.3,"12":73.1,"22":77.4,"21":66.6,"23":72.2,"43":74.7,"42":68.4,"41":62.6,"31":74.9,"33":73.3,"32":75.3},"2":{"11":71.1,"12":75.9,"22":81.0,"21":67.7,"23":72.1,"43":73.9,"42":70.6,"41":62.7,"31":79.2,"33":76.8,"32":76.5},"1":{"11":69.2,"12":74.4,"22":77.9,"21":65.1,"23":67.2,"43":74.2,"42":68.1,"41":62.1,"31":77.6,"33":74.8,"32":73.9},"4":{"11":67.8,"12":70.6,"22":77.3,"21":67.3,"23":73.7,"43":74.1,"42":65.4,"41":58.6,"31":72.4,"33":74.2,"32":72.8}}}};

// Paleta heredada del motor madre
const C = {
  plum: "#4A2746", cream: "#FFF6E0", ocean: "#0062A0", slate: "#747474",
  olive: "#75924E", coral: "#E88663", ink: "#1C1212", paper: "#FFFFFF",
  cream50: "#FFFBEF", line: "#E7DFC9", lineStrong: "#C8BDA0", plum80: "#66394F",
};
// Color por indicador (los 4 sectores del radar)
const IND_COLOR = { 1: "#2A8FD9", 2: "#75924E", 3: "#E88663", 4: "#9B59B6" };

// Territorios disponibles
const TERRS = [
  { id: "SLEP_CC", label: "SLEP Costa Central", color: C.plum },
  { id: "REGION_5", label: "Región de Valparaíso", color: C.ocean },
  { id: "NACIONAL", label: "País", color: C.slate },
];

const FONT = 'system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif';

// Orden canónico de dimensiones siguiendo el orden de indicadores
const DIM_ORDER = [11, 12, 21, 22, 23, 31, 32, 33, 41, 42, 43];
const DIM_TO_IND = {};
Object.entries(DATA.ind_dims).forEach(([ind, dims]) =>
  dims.forEach((d) => (DIM_TO_IND[d] = +ind))
);

function Radar({ series, size = 460 }) {
  const ref = useRef(null);
  const [hover, setHover] = useState(null);
  const cx = size / 2, cy = size / 2;
  const R = size / 2 - 86;
  const N = DIM_ORDER.length;
  const angle = (i) => (Math.PI * 2 * i) / N - Math.PI / 2;
  const rScale = (v) => (v / 100) * R;
  const pt = (i, v) => [cx + Math.cos(angle(i)) * rScale(v), cy + Math.sin(angle(i)) * rScale(v)];

  const rings = [20, 40, 60, 80, 100];

  return (
    <svg ref={ref} viewBox={`0 0 ${size} ${size}`} width={size} height={size} style={{ fontFamily: FONT }}>
      {/* anillos */}
      {rings.map((rv) => (
        <polygon key={rv}
          points={DIM_ORDER.map((_, i) => pt(i, rv).join(",")).join(" ")}
          fill="none" stroke={C.line} strokeWidth={rv === 100 ? 1.4 : 1} />
      ))}
      {rings.map((rv) => (
        <text key={"l" + rv} x={cx + 4} y={cy - rScale(rv)} fontSize="9.5" fill={C.slate}
          dominantBaseline="middle">{rv}</text>
      ))}
      {/* ejes + arcos de color por indicador */}
      {DIM_ORDER.map((dim, i) => {
        const [x, y] = pt(i, 100);
        const ind = DIM_TO_IND[dim];
        return (
          <g key={dim}>
            <line x1={cx} y1={cy} x2={x} y2={y} stroke={C.line} strokeWidth="1" />
            <circle cx={x} cy={y} r="3.5" fill={IND_COLOR[ind]} />
          </g>
        );
      })}
      {/* series por territorio */}
      {series.map((s) => {
        const poly = DIM_ORDER.map((dim, i) => {
          const v = s.values[dim];
          return v == null ? null : pt(i, v).join(",");
        }).filter(Boolean).join(" ");
        return (
          <g key={s.id}>
            <polygon points={poly} fill={s.color} fillOpacity={s.fill ? 0.14 : 0}
              stroke={s.color} strokeWidth="2.4" strokeLinejoin="round" />
            {DIM_ORDER.map((dim, i) => {
              const v = s.values[dim];
              if (v == null) return null;
              const [x, y] = pt(i, v);
              return (
                <circle key={dim} cx={x} cy={y} r={hover === dim ? 5 : 3} fill={s.color}
                  stroke={C.paper} strokeWidth="1.5"
                  onMouseEnter={() => setHover(dim)} onMouseLeave={() => setHover(null)} />
              );
            })}
          </g>
        );
      })}
      {/* etiquetas de dimensión */}
      {DIM_ORDER.map((dim, i) => {
        const [x, y] = pt(i, 116);
        const a = angle(i);
        const anchor = Math.abs(Math.cos(a)) < 0.3 ? "middle" : Math.cos(a) > 0 ? "start" : "end";
        const lbl = DATA.dim_labels[dim];
        const ind = DIM_TO_IND[dim];
        const words = lbl.split(" ");
        const lines = [];
        let cur = "";
        words.forEach((w) => {
          if ((cur + " " + w).trim().length > 16) { lines.push(cur.trim()); cur = w; }
          else cur = (cur + " " + w).trim();
        });
        if (cur) lines.push(cur);
        return (
          <text key={dim} x={x} y={y} fontSize="10" textAnchor={anchor}
            fill={hover === dim ? IND_COLOR[ind] : C.ink}
            fontWeight={hover === dim ? 700 : 500} dominantBaseline="middle">
            {lines.map((ln, k) => (
              <tspan key={k} x={x} dy={k === 0 ? -((lines.length - 1) * 5.5) : 11}>{ln}</tspan>
            ))}
          </text>
        );
      })}
      {/* tooltip de valor */}
      {hover != null && (() => {
        const i = DIM_ORDER.indexOf(hover);
        const [x, y] = pt(i, 50);
        return (
          <g pointerEvents="none">
            <rect x={x - 70} y={y - 14} width="140" height={18 + series.length * 14} rx="4"
              fill={C.plum} opacity="0.96" />
            <text x={x} y={y - 1} fontSize="9.5" fill={C.cream} textAnchor="middle" fontWeight="700">
              {DATA.dim_labels[hover]}
            </text>
            {series.map((s, k) => (
              <text key={s.id} x={x} y={y + 12 + k * 14} fontSize="10" fill={s.color === C.slate ? C.cream : C.cream}
                textAnchor="middle">
                <tspan fill={C.cream} opacity="0.7">{s.label}: </tspan>
                <tspan fontWeight="700">{s.values[hover] ?? "s/d"}</tspan>
              </text>
            ))}
          </g>
        );
      })()}
    </svg>
  );
}

export default function App() {
  const [gse, setGse] = useState("TODOS");
  const [activeTerrs, setActiveTerrs] = useState(["SLEP_CC", "REGION_5"]);
  const [fill, setFill] = useState(true);

  const series = useMemo(() => {
    return TERRS.filter((t) => activeTerrs.includes(t.id)).map((t) => ({
      id: t.id, label: t.label, color: t.color, fill,
      values: DATA.data[t.id][gse] || {},
    }));
  }, [activeTerrs, gse, fill]);

  const toggleTerr = (id) =>
    setActiveTerrs((prev) => prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]);

  const gseOpts = [["TODOS", "Todos"], ...Object.entries(DATA.gse_labels)];

  return (
    <div style={{ fontFamily: FONT, background: C.cream, color: C.ink, padding: "20px 24px", minHeight: "100%" }}>
      {/* header */}
      <div style={{ borderBottom: `2px solid ${C.plum}`, paddingBottom: 10, marginBottom: 14 }}>
        <div style={{ fontSize: 11, letterSpacing: "0.08em", textTransform: "uppercase", color: C.plum80, fontWeight: 700 }}>
          slep_idps · prototipo
        </div>
        <h1 style={{ fontSize: 22, margin: "2px 0 0", color: C.plum, fontWeight: 700 }}>
          Desarrollo integral · Indicadores IDPS
        </h1>
        <div style={{ fontSize: 12.5, color: C.slate, marginTop: 2 }}>
          4° básico · 2025 (preliminar) · cada arista es una dimensión; los 4 indicadores confluyen en un solo perfil
        </div>
      </div>

      <div style={{ display: "flex", gap: 24, flexWrap: "wrap" }}>
        {/* panel de control */}
        <div style={{ width: 230, flexShrink: 0 }}>
          <ControlBlock title="Territorios (comparar)">
            {TERRS.map((t) => (
              <label key={t.id} style={chk(activeTerrs.includes(t.id))}>
                <input type="checkbox" checked={activeTerrs.includes(t.id)}
                  onChange={() => toggleTerr(t.id)} style={{ accentColor: t.color }} />
                <span style={{ width: 12, height: 12, borderRadius: 3, background: t.color, display: "inline-block" }} />
                {t.label}
              </label>
            ))}
          </ControlBlock>

          <ControlBlock title="Grupo socioeconómico (GSE)">
            <div style={{ fontSize: 10.5, color: C.coral, marginBottom: 6, fontWeight: 600 }}>
              Segmentación inviolable
            </div>
            <select value={gse} onChange={(e) => setGse(e.target.value)}
              style={{ width: "100%", padding: "6px 8px", fontSize: 13, border: `1px solid ${C.lineStrong}`,
                borderRadius: 4, background: C.paper, color: C.ink, fontFamily: FONT }}>
              {gseOpts.map(([k, v]) => <option key={k} value={k}>{v}</option>)}
            </select>
          </ControlBlock>

          <ControlBlock title="Indicadores (leyenda)">
            {Object.entries(DATA.ind_labels).map(([k, v]) => (
              <div key={k} style={{ display: "flex", gap: 7, alignItems: "flex-start", fontSize: 11.5, marginBottom: 5 }}>
                <span style={{ width: 10, height: 10, borderRadius: "50%", background: IND_COLOR[k],
                  display: "inline-block", marginTop: 3, flexShrink: 0 }} />
                <span style={{ color: C.ink }}>{v}</span>
              </div>
            ))}
          </ControlBlock>

          <label style={{ ...chk(fill), marginTop: 4 }}>
            <input type="checkbox" checked={fill} onChange={() => setFill(!fill)} />
            Rellenar áreas
          </label>
        </div>

        {/* radar */}
        <div style={{ flex: 1, minWidth: 480, display: "flex", flexDirection: "column", alignItems: "center" }}>
          <Radar series={series} />
          <div style={{ fontSize: 11, color: C.slate, marginTop: 4, textAlign: "center", maxWidth: 460 }}>
            Escala 0–100. {gse !== "TODOS" && <strong>GSE: {DATA.gse_labels[gse]}. </strong>}
            <span style={{ color: C.coral, fontWeight: 600 }}>
              Agregación provisional (promedio simple, pendiente ponderación por matrícula).
            </span>
          </div>
        </div>
      </div>
    </div>
  );
}

function ControlBlock({ title, children }) {
  return (
    <div style={{ marginBottom: 16 }}>
      <div style={{ fontSize: 10.5, letterSpacing: "0.06em", textTransform: "uppercase",
        color: C.slate, fontWeight: 700, marginBottom: 7, borderBottom: `1px solid ${C.line}`, paddingBottom: 4 }}>
        {title}
      </div>
      {children}
    </div>
  );
}

const chk = (active) => ({
  display: "flex", alignItems: "center", gap: 8, fontSize: 12.5, padding: "5px 0",
  cursor: "pointer", color: active ? C.ink : C.slate, fontWeight: active ? 600 : 400,
});
