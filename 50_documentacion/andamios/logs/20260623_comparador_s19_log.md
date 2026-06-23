# Log — Modal multiselección + botón del comparador territorial (s19, Ítems 9+10)

> Ejecución autónoma de `encargo_claude_code_idps_comparador_s19.md`.
> Fecha: 2026-06-23. Ejecutor: Claude Code (Opus 4.8). Rama: `main`.
> **Push NO ejecutado**: commits locales, a la espera de OK del titular.
> Log SIN commitear para revisión (§5).

---

## 1. Resumen

Dos mejoras de UI del comparador territorial, solo en template (no toca R ni el
parquet):
- **Ítem 9:** `EntityModal` gana un modo multiselección OPT-IN (`multiple`); en el
  comparador, clic en una fila TOGGLEA el territorio **sin cerrar** el modal, con
  casilla marcada, tope 4 (al llegar, las demás filas se deshabilitan), contador
  "N de 4" y cierre explícito con "Listo"/Escape/backdrop. El modo simple (navegación
  de ficha) queda intacto.
- **Ítem 10:** botón "+ agregar territorio" rediseñado a **azul sólido** (`--azul`,
  forma del patrón hermano con tokens IDPS) + botón **reset (↺)** que vacía todos los
  territorios, visible solo con ≥1 territorio.

Payload de datos byte-idéntico al build anterior; fidelidad censal 0 mismatch
(verificador propio + panel adversarial). Criterios verificados en navegador,
incluida la **no-regresión** del modo simple.

## 2. Inventario de commits

| Fase | Hash | Tipo | Título |
|---|------|------|--------|
| 1 | `5df6fa1` | feat | multiseleccion de territorios sin cerrar el modal (item 9) |
| 2 | `c1e0f5f` | style | boton agregar territorio azul solido + reset (item 10) |
| 3 | `1a32f1c` | build | regenerar y desplegar mejoras del comparador territorial (items 9,10) |

Archivos: F1 y F2 → `30_procesamiento/35_motor_template.html`; F3 →
`40_salidas/motor_idps.html`, `docs/index.html`. Push: **pendiente**.

## 3. Detalle por ítem

### Ítem 9 — multiselección sin cerrar el modal
- **Qué:**
  - `EntityModal` gana props opcionales `multiple=false`, `seleccionados=[]`,
    `maxSel=null`, `onDone=null`. Con `multiple=true`: clic en fila llama `onSelect`
    (toggle) sin cerrar; filas marcadas con `.check-box`/`.is-checked` y
    `aria-checked`; al alcanzar `maxSel` las no marcadas pasan a `.is-disabled` (sin
    handler); footer muestra contador "N de maxSel" y botón primario "Listo"
    (`onDone||onCancel`). Con `multiple=false` (default): comportamiento ACTUAL intacto
    (footer "Cancelar", sin casilla, clic en fila → `onSelect` → el caller cierra).
  - `addTerr` deja de cerrar (`setCmpModalOpen(false)` removido) y ahora TOGGLEA en
    `cmpTerr` (quita si está; agrega si hay cupo; no-op si tope 4).
  - Render del modal del comparador: `multiple={true}`,
    `seleccionados={cmpTerr.map(t=>t.kind+"|"+t.cod)}`, `maxSel={4}`,
    `onDone={()=>setCmpModalOpen(false)}`.
- **Por qué:** antes cada selección cerraba el modal (había que reabrirlo por cada
  territorio); el modo multiselección permite armar la comparación de una vez.
- **Verificación (navegador):** "+ agregar" abre modal; clic agrega y **el modal
  sigue abierto** con la fila marcada (contador 0→2 de 4); clic en fila marcada la
  quita (4→3); al llegar a 4, las **32 filas no marcadas quedan deshabilitadas**
  (32/32); `aria-checked="true"`; "Listo" cierra; aparecen los chips. Captura en log
  de sesión.
- **No-regresión (modo simple / ficha):** el modal de navegación territorial abre con
  footer "Cancelar", **sin** `.check-box`, y **cierra al clic** en una fila
  (verificado: `modalCerradoTrasClic=true`).
- **Causa raíz:** N/A (feature; el modo multiple ya estaba anticipado en el comentario
  del componente, no había código muerto previo).

### Ítem 10 — botón azul sólido + reset
- **Qué:** `.cmp-add` pasa de outline dashed a **azul sólido** (`background:var(--azul)`,
  texto blanco, `+`, hover `--foco`). Nuevo `.cmp-reset` (outline) con ícono ↺,
  `aria-label/title="Limpiar territorios"`, visible solo con `cmpTerr.length>=1`;
  ejecuta `onReset` (=`setCmpTerr([])`). `Comparador` recibe la prop `onReset`,
  cableada en el render.
- **Por qué:** dar jerarquía visual a la acción primaria (agregar) y una vía rápida de
  limpiar, replicando la forma del patrón hermano con tokens locales (decisión B).
- **Verificación (navegador):** botón agregar `background-color: rgb(10,58,92)` =
  `--azul`, texto blanco; reset visible con ≥1 territorio, vacía todos los chips al
  pulsarlo (chips→0) y queda **oculto con 0**; el botón agregar sigue visible con 0.
- **Causa raíz:** N/A.

## 4. Verificación de invariantes 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet NO se toca; fidelidad intacta | **PASA** | md5 parquet `4c764d8c…` igual; censal 0 mismatch (ind/dim/niv). La matriz `StackedBar` (conteo vs GSE) no se tocó. |
| Modo SIMPLE de `EntityModal` no cambia | **PASA** | Multiselección es OPT-IN por prop; el modal de ficha (sin `multiple`) cierra al elegir, footer "Cancelar", sin casilla (verificado en navegador). |
| Tope de 4 | **PASA** | Al llegar a 4, las filas no marcadas se deshabilitan; `addTerr` no agrega un 5º. |
| Cero agregación / no se promedia | **PASA** | Cambio solo de selección; banda "No se promedia ni se agrega" presente; matriz intacta. |
| `docs/` solo en deploy | **PASA** | `docs/index.html` se tocó solo en Fase 3, tras fidelidad y navegador. |
| Tokens IDPS, no del repo hermano | **PASA** | Botón usa `--azul`/`--foco`/`--linea`/`--cream-200` locales; sin importar nada del hermano. |

## 5. Estado de cifras

- **md5 parquet:** antes = después = `4c764d8c9f0bf70004f8aa52661ae901`.
- **Payload:** los 11 bloques `identical()` al build de HEAD; `meta` sin diferencias
  (mismo día, ni `fecha_generacion` cambió). El cambio vive 100% fuera del JSON.
- **Fidelidad censal (re-derivación independiente, sin fantasma rbd=NA):** ind
  366.384 / dim 557.898 / niv 662.514, mismatch=0 en todas las columnas. Panel
  adversarial confirmó además el redondeo banker's en los `.5` de `niv_*_por`.
- **md5 build / docs:** `512feb1771902fb8576751fbbf406560` (idénticos).

## 6. Pendientes y marcas

- **PENDIENTE: `git push origin main`** — NO ejecutado. Quedan locales en `main`
  (de toda la sesión s19): `f1eb638`, `df7be34`, `1fe2157` (fases 1-3 UI/UX),
  `82680ea`, `d5d763a` (media móvil), `5df6fa1`, `c1e0f5f`, `1a32f1c` (comparador).
  **8 commits** a pushear cuando el titular apruebe.
- **# REVISAR (disposición del reset):** el reset (↺) se ubicó dentro del flujo de
  chips, junto al botón agregar (agregar primero, reset al lado), como en la captura
  hermana. Si el titular prefiere una fila de acciones separada de los chips, es un
  ajuste menor.
- **# REVISAR (toggle vs solo-agregar en addTerr):** ahora `addTerr` togglea (quita si
  ya está). Esto es coherente con el modo multiselección (clic en fila marcada la
  desmarca), pero cambia la semántica previa de `addTerr` (antes solo agregaba). El
  chip ✕ (`removeTerr`) sigue funcionando igual para quitar desde fuera del modal.
- **Ítems aún diferidos:** 4 (tipografía, al final) y 11 (lista EE por segmento,
  requiere leer el componente de `slep_simce_adecuado`).

## 7. Notas para el revisor

- **Backward-compat de `EntityModal`:** las props nuevas tienen defaults; la llamada
  del modal de ficha no se tocó y sigue en modo simple. Verificado en navegador que no
  hay regresión (footer, casilla, cierre).
- **Selección en vivo:** como `addTerr` togglea `cmpTerr` directamente, los chips del
  comparador se actualizan EN VIVO detrás del modal abierto; al cerrar con "Listo" la
  comparación ya está armada. El contador del modal (`seleccionados.length`) refleja
  `cmpTerr` en tiempo real.
- **a11y:** filas en multiple con `role="checkbox"` + `aria-checked`; foco inicial en
  el buscador (ya estaba); cierre con Escape (ya estaba) y "Listo"/backdrop.
- **Honestidad:** todo verificado por DOM real (estado de filas, contador, conteo de
  deshabilitadas, color computado del botón, cierre del modal simple), no por lectura
  de código. Capturas a 1280px (el preview venía a 1px; se redimensionó).

## 8. Reproducir la verificación de fidelidad

Script independiente reutilizado: `/tmp/verif_mmovil_s19.R` (identidad de payload vs
HEAD + censal), apuntado al build previo `/tmp/prev_build_cmp.html`. Panel adversarial:
agente de solo-lectura con código propio (veredicto PASA, 0 mismatch, payload
byte-idéntico).
