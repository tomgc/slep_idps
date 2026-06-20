// ============================================================
// EntityModal — selector de territorio portable (versión parametrizada)
// ============================================================
// Extraído de slep_categoria_desempeno/30_procesamiento/33_app.jsx (L593-788)
// y refactorizado para no depender de DATA/CatData globales. Todo lo que el
// componente necesita entra por props; es reutilizable en cualquier motor
// hermano (slep_idps, slep_simce_estandares_aprendizaje, etc.).
//
// ---- CONTRATO DE PROPS --------------------------------------------------
//   onSelect(item | item[])   callback al elegir. En modo simple recibe un
//                             item; en modo múltiple, el arreglo seleccionado.
//   onCancel()                callback al cerrar/cancelar.
//   tabs                      [["comuna","Comuna"], ["slep","SLEP"], ...]
//                             pares [clave, etiqueta]; define las pestañas y su
//                             orden. La primera es la activa inicial.
//   buildList(tabKey, query)  función PURA que devuelve la lista de la pestaña
//                             activa ya filtrada por query (string en minúsculas,
//                             puede venir ""). Debe devolver items con forma:
//                               { kind, cod, nom, sub }
//                             - kind: string identificador del tipo (= tabKey
//                               normalmente, p.ej. "comuna","slep","region",
//                               "establecimiento").
//                             - cod:  string, identificador único dentro del kind.
//                             - nom:  string, etiqueta visible principal.
//                             - sub:  string, etiqueta secundaria (región, nº de
//                               comunas, "RBD 1234 · Comuna", etc.). Puede ser "".
//                             El componente NO conoce el modelo de datos: toda la
//                             lógica de qué se lista vive en buildList, en el motor
//                             que lo usa.
//   multiple = false          habilita selección múltiple con checkboxes.
//   yaElegidas = []           items ya elegidos (modo múltiple): se muestran como
//                             "ya agregado" y no se pueden re-seleccionar. Cada
//                             item debe tener al menos {kind, cod}.
//   limite = 10               tope total (yaElegidas + nuevas) en modo múltiple.
//   searchPlaceholderFor(tab) opcional: placeholder del buscador según la pestaña.
//                             Si no se pasa, usa "Buscar…".
//   emptyTextFor(tab, query)  opcional: texto del estado vacío según pestaña y
//                             query. Si no se pasa, usa "Sin resultados".
//
// ---- NOTA SOBRE buildList ----------------------------------------------
// En el motor original, cada pestaña tenía su propia lógica (comuna lee
// DATA.comunas; slep lee CatData.SLEPS; establecimiento exige query y corta a
// 60 resultados). Toda esa lógica se traslada a buildList del motor destino.
// El componente solo invoca buildList(tab, queryNormalizada) y pinta el
// resultado. Ejemplo de implementación al pie de este archivo.
// ------------------------------------------------------------------------

function EntityModal({
  onSelect,
  onCancel,
  tabs,
  buildList,
  multiple = false,
  yaElegidas = [],
  limite = 10,
  searchPlaceholderFor = null,
  emptyTextFor = null,
}) {
  const tabInicial = tabs && tabs.length ? tabs[0][0] : "comuna";
  const [tab, setTab] = React.useState(tabInicial);
  const [q, setQ] = React.useState("");
  const [sel, setSel] = React.useState([]); // selección acumulada (solo modo múltiple)
  const ql = q.trim().toLowerCase();
  const claveDe = (it) => it.kind + "|" + it.cod;
  const yaSet = new Set(yaElegidas.map(claveDe));
  const selSet = new Set(sel.map(claveDe));
  const cupo = limite - yaElegidas.length; // cuántas más caben

  const toggleSel = (item) => {
    const k = claveDe(item);
    if (yaSet.has(k)) return; // ya está en la comparativa
    setSel((prev) => {
      if (prev.some((p) => claveDe(p) === k)) return prev.filter((p) => claveDe(p) !== k);
      if (prev.length >= cupo) return prev; // respeta el tope
      return [...prev, item];
    });
  };

  // Toda la lógica de qué se lista vive en el motor destino, vía buildList.
  const list = buildList(tab, ql) || [];

  const placeholder =
    (searchPlaceholderFor && searchPlaceholderFor(tab)) || "Buscar…";
  const emptyText =
    (emptyTextFor && emptyTextFor(tab, ql)) || "Sin resultados";

  return (
    <div className="modal-backdrop" onClick={onCancel}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2 className="modal-title">
            {multiple ? "Agregar territorios" : "Seleccionar territorio"}
          </h2>
        </div>
        <div className="modal-tabs">
          {tabs.map(([k, lbl]) => (
            <button
              key={k}
              className={"modal-tab" + (tab === k ? " is-active" : "")}
              onClick={() => {
                setTab(k);
                setQ("");
              }}
            >
              {lbl}
            </button>
          ))}
        </div>
        <div className="modal-body">
          <input
            className="input-search"
            placeholder={placeholder}
            value={q}
            onChange={(e) => setQ(e.target.value)}
            autoFocus={true}
            style={{
              width: "100%",
              padding: "8px 10px",
              marginBottom: 10,
              border: "1px solid var(--border-2)",
              borderRadius: "var(--radius-2)",
              fontFamily: "var(--font-body)",
              fontSize: "var(--fs-base)",
            }}
          />
          {multiple && (
            <div className="modal-hint-multi">
              {cupo <= 0
                ? "Ya alcanzaste el máximo de " + limite + " territorios."
                : "Selecciona hasta " +
                  cupo +
                  " " +
                  (cupo === 1 ? "territorio más" : "territorios más") +
                  " · marcados: " +
                  sel.length}
            </div>
          )}
          <div
            className="comuna-checklist"
            style={{
              maxHeight: 320,
            }}
          >
            {list.length === 0 && <div className="empty-state">{emptyText}</div>}
            {list.map((item) => {
              const k = claveDe(item);
              const yaEsta = yaSet.has(k);
              const marcado = selSet.has(k);
              const bloqueado = !multiple ? false : yaEsta || (!marcado && sel.length >= cupo);
              return (
                <div
                  key={k}
                  className={
                    "check-row" +
                    (multiple && marcado ? " is-checked" : "") +
                    (bloqueado ? " is-disabled" : "")
                  }
                  onClick={() => {
                    if (!multiple) {
                      onSelect(item);
                      return;
                    }
                    if (bloqueado) return;
                    toggleSel(item);
                  }}
                >
                  {multiple && (
                    <span
                      className={"check-box" + (marcado ? " is-on" : "") + (yaEsta ? " is-ya" : "")}
                    >
                      {(marcado || yaEsta) && (
                        <svg
                          viewBox="0 0 16 16"
                          width="12"
                          height="12"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2.5"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        >
                          <polyline points="3 8 7 12 13 4" />
                        </svg>
                      )}
                    </span>
                  )}
                  <span className="check-name">{item.nom}</span>
                  <span className="check-region">{yaEsta ? "ya agregado" : item.sub}</span>
                </div>
              );
            })}
          </div>
        </div>
        <div className="modal-footer">
          <button className="estab-popup-btn" onClick={onCancel}>
            Cancelar
          </button>
          {multiple && (
            <button
              className="estab-popup-btn is-primary"
              disabled={sel.length === 0}
              onClick={() => onSelect(sel)}
            >
              Agregar{sel.length > 0 ? " (" + sel.length + ")" : ""}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

// ========================================================================
// EJEMPLO DE buildList para el motor destino (slep_idps)
// ========================================================================
// Replica la lógica que en el motor original estaba embebida en EntityModal.
// Asume que en idps existen los mismos catálogos que en categoria_desempeno
// (CatData.SLEPS, CatData.REGIONES, CatData.ESTAB_CAT) construidos desde el
// JSON del motor. Si idps nombró sus claves distinto, se ajusta SOLO aquí,
// sin tocar EntityModal.
//
//   const TABS = [
//     ["comuna", "Comuna"],
//     ["slep", "SLEP"],
//     ["region", "Región"],
//     ["establecimiento", "Establecimiento"],
//   ];
//
//   function buildList(tab, ql) {
//     if (tab === "comuna") {
//       return DATA.comunas
//         .filter((c) => !ql || c.nom.toLowerCase().includes(ql))
//         .map((c) => ({ kind: "comuna", cod: String(c.cod), nom: c.nom, sub: c.nom_reg }));
//     }
//     if (tab === "slep") {
//       return CatData.SLEPS
//         .filter((s) => !ql || s.nom.toLowerCase().includes(ql))
//         .map((s) => ({
//           kind: "slep", cod: s.cod, nom: s.nom,
//           rbds: DATA.sleps.filter((r) => String(r.cod_slep) === s.cod).map((r) => String(r.rbd)),
//           sub: "Traspaso " + s.anio_traspaso,
//         }));
//     }
//     if (tab === "region") {
//       return CatData.REGIONES
//         .filter((r) => !ql || r.nom.toLowerCase().includes(ql))
//         .map((r) => ({ kind: "region", cod: r.cod, nom: r.nom, sub: r.comunas.length + " comunas" }));
//     }
//     // establecimiento: exige query (catálogo grande); corta a 60 resultados.
//     return ql
//       ? CatData.ESTAB_CAT
//           .filter((e) => e.nom.toLowerCase().includes(ql) || String(e.rbd).includes(ql))
//           .slice(0, 60)
//           .map((e) => ({
//             kind: "establecimiento", cod: e.rbd, nom: e.nom,
//             sub: (e.nom_com || "") + " · RBD " + e.rbd,
//           }))
//       : [];
//   }
//
//   function searchPlaceholderFor(tab) {
//     return tab === "establecimiento" ? "Buscar por nombre o RBD…" : "Buscar…";
//   }
//   function emptyTextFor(tab, ql) {
//     return tab === "establecimiento" && !ql
//       ? "Escribe para buscar un establecimiento"
//       : "Sin resultados";
//   }
//
//   // Uso:
//   // <EntityModal
//   //   tabs={TABS}
//   //   buildList={buildList}
//   //   searchPlaceholderFor={searchPlaceholderFor}
//   //   emptyTextFor={emptyTextFor}
//   //   onSelect={...}
//   //   onCancel={...}
//   //   multiple={false}
//   // />
