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
