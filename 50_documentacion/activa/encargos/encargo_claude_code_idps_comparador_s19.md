# Encargo autónomo — modal multiselección + botón del comparador territorial (s19, Ítems 9+10)

> Encargo dirigido por meta para Claude Code en modo autónomo. Reglas canónicas
> (autonomía 0.3, commits atómicos, gobernanza, principios técnicos, R1-R9) en la
> knowledge base; se referencian, no se reescriben.

---

## 1. Encabezado de contrato

- **Modo:** autónomo, secuencial, todo en este turno. Commit atómico por fase.
- **Stack:** HTML/JSX inline (React 18 + D3 v7, runtime classic, sin bundler). El
  cambio es solo de template; NO toca R ni el parquet (verificar: si algo obligara a
  tocar R, es regla de detención).
- **Rutas:** absolutas desde `/Users/tomgc/Projects/slep_idps`. No asumir `cd`.
- **Push:** NO ejecutar. Commits locales; pedir aprobación del titular.
- **Regla de detención (PARA y reporta):** (1) un invariante 🔒 te obligaría a
  violarse; (2) un dato real contradice un supuesto del encargo; (3) una decisión de
  diseño no fijada aquí. No fabricar metodología.
- **DISCIPLINA_OPERATIVA R1-R9:** `git status` antes de cada `add`; nunca `git add .`/
  `-u`; leer el diff real antes del mensaje de commit.

---

## 2. Contexto mínimo suficiente

- **Archivo:** `30_procesamiento/35_motor_template.html` (único que se toca).
- **Build:** `40_salidas/motor_idps.html`; deploy: `docs/index.html`.
- **Estado real ya verificado (reconfirmar líneas antes de editar; pueden moverse):**
  - `EntityModal({onSelect,onCancel,tabs,buildList,searchPlaceholderFor,emptyTextFor,title})`
    (~:1178). Componente PORTABLE usado en DOS lugares:
    1. Navegación de ficha (`modalOpen`, `onSelect=onPick`, ~:1490) — modo SIMPLE:
       clic en fila selecciona y cierra. **NO debe cambiar.**
    2. Comparador territorial (`cmpModalOpen`, `onSelect=addTerr`,
       `title="Agregar territorio a la comparación"`, ~:1491) — el que SÍ cambia.
  - Cuerpo del modal: input de búsqueda + `.comuna-checklist` con filas `.check-row`
    `onClick={()=>onSelect(item)}` (~:1196-1208); footer con un solo botón "Cancelar"
    (`.estab-popup-btn`, ~:1208).
  - `addTerr=item=>{setCmpModalOpen(false); setCmpTerr(prev=>{…})}` (~:1441) — la
    PRIMERA línea cierra el modal en cada selección. Es la causa del Ítem 9.
  - `removeTerr=(kind,cod)=>setCmpTerr(prev=>prev.filter(...))` (~:1448).
  - `cmpTerr` estado (~:1417), tope 4. Chips render (~:1332), botón `.cmp-add`
    (`+ agregar territorio`, ~:1338), `onAdd={()=>setCmpModalOpen(true)}` (~:1495).
  - Render de `EntityModal` del comparador: ~:1491.
- **Tokens locales disponibles** (NO importar del repo hermano; usar los del IDPS):
  `--azul`, `--paper`, `--panel`, `--linea`, `--foco`, `--gris`, `--tinta`,
  `--radius-2/3`, `--font-body`, `--fs-base`, `--fw-*`; clases `.estab-popup-btn`,
  `.modal-*`, `.check-row`, `.cmp-*`.

---

## 3. Invariantes (🔒)

- 🔒 **Parquet NO se toca; fidelidad censal intacta.** Este cambio es puramente de
  UI/comportamiento del selector; NO altera ninguna cifra, roster ni reparto. La
  matriz del comparador (`StackedBar`, conteo vs GSE, cero agregación) NO se toca.
- 🔒 **El modo SIMPLE de `EntityModal` (navegación de ficha) NO cambia.** El modo
  multiselección es OPT-IN por prop nueva; el uso de ficha sigue cerrando al elegir.
- 🔒 **Tope de 4 territorios** se respeta: en multiselección no se puede marcar un 5º.
- 🔒 **Cero agregación / no se promedia** (regla del comparador): el cambio es de
  selección, no de cálculo. La banda "No se promedia ni se agrega" permanece.
- 🔒 **`docs/` solo en deploy**, tras verificación.
- 🔒 **Tokens del IDPS, no del repo hermano** (decisión B del titular): el botón
  replica la FORMA del patrón hermano (captura) anclada a los tokens locales.

---

## 4. Fases

### FASE 1 — Ítem 9: multiselección sin cerrar el modal

**Paso 0 (leer, no modificar):** `EntityModal` completo (~:1178-1210), `addTerr`
(~:1441), el render del modal del comparador (~:1491). Confirmar que el modo simple
(ficha, ~:1490) queda intacto.

**Implementación:**
1. **`EntityModal` gana props opcionales** (sin romper las llamadas existentes):
   - `multiple=false` (default): comportamiento ACTUAL (clic en fila → `onSelect` →
     cierra; el cierre lo decide el caller). NO cambiar este camino.
   - `multiple=true`: clic en fila hace **toggle** (agrega si no está, quita si está)
     llamando a `onSelect(item)`, **sin cerrar**. Las filas ya seleccionadas se marcan
     visualmente (check / estado activo en `.check-row`, p. ej. `.is-checked`). Cuando
     se alcanza el tope (prop `maxAlcanzado=true`, o derivable de `seleccionados`), las
     filas NO seleccionadas se muestran deshabilitadas (no clickeables).
   - `seleccionados` (array de claves `kind|cod` o equivalente) para saber qué filas
     marcar. El componente deriva el set de claves activas y pinta el check.
   - Footer en modo multiple: botón **"Listo"** (primario, cierra vía `onCancel` o un
     `onDone`) además de cerrar con Escape/backdrop. Mantener "Cancelar" si aplica, o
     reemplazarlo por "Listo" — criterio de Claude Code, lo importante es que haya una
     vía explícita de cierre y que el conteo "N de 4" sea legible (puede mostrarse en
     el header o footer del modal).
2. **`addTerr` deja de cerrar:** quitar `setCmpModalOpen(false)` de la primera línea
   (~:1441). Ahora `addTerr` solo togglea en `cmpTerr` (agrega si no está y hay cupo;
   quita si ya está). El cierre pasa a ser explícito ("Listo"/Escape/backdrop).
3. **Render del modal del comparador** (~:1491): pasar `multiple={true}`,
   `seleccionados={cmpTerr.map(t=>t.kind+"|"+t.cod)}`, y el tope (4). El `onSelect`
   sigue siendo `addTerr` (ahora togglea sin cerrar).
4. **a11y:** mantener `role=dialog`, `aria-modal`, cierre con Escape (ya existe). Las
   filas en modo multiple deben comunicar su estado seleccionado (aria-checked o
   equivalente). Foco inicial en el buscador (ya está).

**Criterio de éxito (Ítem 9):**
- En el comparador, "+ agregar" abre el modal; clic en una fila la agrega y el modal
  SIGUE abierto, con la fila marcada; clic de nuevo la quita. Se pueden agregar hasta
  4 sin que el modal se cierre. Al llegar a 4, las demás filas quedan deshabilitadas.
- "Listo"/Escape/backdrop cierran. Los territorios agregados aparecen como chips.
- La navegación de ficha (modo simple) sigue cerrando al elegir, sin cambios.

**Commit Fase 1:**
```
git -C /Users/tomgc/Projects/slep_idps add 30_procesamiento/35_motor_template.html
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps commit -m "feat(motor): multiseleccion de territorios sin cerrar el modal (item 9)"
```

### FASE 2 — Ítem 10: rediseño del botón + reset

**Paso 0 (leer):** `.cmp-add` y su CSS (~:409 y alrededores), la zona de chips
(~:1330-1340), el footer/controles del comparador.

**Implementación (replicar la FORMA del patrón hermano desde la captura, con tokens
locales — decisión B):**
1. **Botón "+ agregar territorio"** (`.cmp-add`): rediseñar a **azul sólido** (fondo
   `var(--azul)`, texto claro, ícono `+`, radio `var(--radius-2)`, padding cómodo),
   al estilo del botón "+ Agregar entidad" del patrón hermano. Mantener el texto
   "+ agregar territorio" (terminología del IDPS) y el handler `onAdd`. Coherente con
   el chrome del comparador (no un azul ajeno; el `--azul` del motor).
2. **Botón reset (↺)** NUEVO, al lado del de agregar: botón circular/cuadrado con
   borde (outline, no sólido), ícono de reset (↺ o equivalente del set ya usado), que
   ejecuta **`setCmpTerr([])`** (limpiar todos los territorios). Visible SOLO cuando
   `cmpTerr.length >= 1` (sin territorios no hay nada que limpiar). `aria-label`
   "Limpiar territorios", `title` igual.
   - Cablear: el `Comparador` recibe una prop nueva `onReset` (=`()=>setCmpTerr([])`),
     análoga a `onAdd`/`onRemove`. Pasarla en el render (~:1494-1495).
3. **Disposición:** los dos botones (agregar + reset) juntos, alineados como en la
   captura hermana (agregar primero, reset al lado). Respetar el flujo de chips
   existente: el botón de agregar puede seguir entre los chips o moverse a una fila de
   acciones — criterio de Claude Code, manteniendo el conteo "N de 4" legible.

**Criterio de éxito (Ítem 10):**
- El botón de agregar se ve azul sólido con `+`, coherente con el patrón hermano y con
  el chrome del IDPS.
- Con ≥1 territorio aparece el botón reset (↺); al pulsarlo, se vacían todos los chips
  y el comparador vuelve al estado inicial (invitación a agregar). Sin territorios, el
  reset no se muestra.

**Commit Fase 2:**
```
git -C /Users/tomgc/Projects/slep_idps add 30_procesamiento/35_motor_template.html
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps commit -m "style(motor): boton agregar territorio azul solido + reset (item 10)"
```

### FASE 3 — Regeneración, verificación y deploy

1. **Regenerar:** `run_all(only=35)` (o el comando real; confirmar). Si falla, PARA.
2. **Fidelidad:** el cambio es solo template; el payload de datos debe quedar
   byte-idéntico al build anterior (salvo `fecha_generacion`). Verificar identidad de
   bloques + censal (mismatch=0). Panel adversarial si hay cualquier duda. Si el
   payload cambió más allá de la fecha, PARA y reporta (algo tocó datos sin querer).
3. **Navegador (criterios §4):**
   - Ítem 9: agregar 2-3 territorios sin que el modal se cierre; marcar/desmarcar;
     verificar tope 4 (5ª fila deshabilitada); "Listo"/Escape cierran; chips aparecen.
   - Ítem 9 (no-regresión): la navegación de ficha sigue cerrando al elegir.
   - Ítem 10: botón azul sólido; reset visible con ≥1 territorio, vacía al pulsarlo,
     oculto con 0.
   Capturar evidencia para el log.
4. **Deploy (solo si 2 y 3 pasaron):**
```
cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html
git -C /Users/tomgc/Projects/slep_idps add 40_salidas/motor_idps.html docs/index.html
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps commit -m "build(motor): regenerar y desplegar mejoras del comparador territorial (items 9,10)"
```
NO pushear. Pedir aprobación del titular.

---

## 5. Auto-auditoría, log y cierre

- Panel adversarial para fidelidad (código independiente) — aunque el riesgo de datos
  es bajo (solo UI), confirmar que el payload no cambió.
- Verificación en navegador obligatoria de los criterios visuales/comportamiento,
  INCLUIDA la no-regresión del modo simple (ficha).
- Log en `50_documentacion/andamios/logs/YYYYMMDD_comparador_s19_log.md` (plantilla
  fija): resumen, commits, detalle por ítem (qué/por qué/cómo se verificó),
  invariantes 🔒 PASA/FALLA con evidencia, estado de cifras, `# REVISAR`, notas.
  Honesto. SIN commitear para revisión del titular.
- NO cerrar ni sugerir cerrar la sesión (R5).

---

## 6. Reporte final al chat

Hashes de los 3 commits + push pendiente; md5 parquet antes/después; fidelidad
(payload byte-idéntico salvo fecha); spot-checks de 9 (multiselección, tope, no-
regresión ficha) y 10 (botón, reset); `# REVISAR`; ruta del log; detenciones si las hubo.

---

## 7. Notas para el redactor (no van al log)

- El modo multiple de `EntityModal` estaba PREVISTO en el comentario del componente
  (~:1177 "Modo simple (multiple=false)…"), así que esta implementación completa un
  contrato ya anticipado; verificar que no exista ya código muerto de multiple a medio
  hacer antes de duplicar.
- Ítems aún diferidos tras este: 4 (auditoría tipográfica, al final) y 11 (lista EE
  por segmento, requiere leer el componente de `slep_simce_adecuado`).
