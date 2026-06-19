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
