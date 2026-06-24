# Encargo autónomo — slep_idps, Batch B / Encargo 1 (s22)

> Tres mejoras sobre `30_procesamiento/35_motor_template.html`. Solo template:
> payload byte-idéntico (no se toca R, generador, parquet ni datos). Modo autónomo,
> secuencial, las 3 fases en orden, este turno.
>
> **Estado de cierre especial:** este lote se acumula ENCIMA de los 4 commits de
> Batch A (locales, sin push) y del build local ya regenerado. **NO commitees y NO
> hagas push:** deja los cambios en el working tree, regenera el build local, verifica
> en navegador y reporta. El titular decide el commit después.

---

## Encabezado de contrato

- **Modo:** autónomo, secuencial. 3 fases en orden (#23 → #13 → #18) en este turno.
- **Orden con criterio:** #23 primero porque define el color que #13 usa para el glifo
  `=`; #13 segundo; #18 al final (es el de mayor componente de layout).
- **Stack:** edición de un único archivo (`35_motor_template.html`). Sin R, sin payload.
- **Rutas absolutas.** Raíz: `/Users/tomgc/Projects/slep_idps`. Archivo:
  `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`.
- **Regla de detención (PARA y reporta):** (a) un invariante 🔒 que te obligue a violarlo;
  (b) el estado real del archivo no calza con lo que el encargo describe y no puedes
  localizar la zona con certeza; (c) #18 no converge visualmente (el rótulo externo rompe
  el layout de la celda del comparador) — para y reporta, no improvises rediseño.
- **Build:** regenera el motor local (`run_all(only=35)`) y verifícalo en navegador.
  **NO commit, NO push, NO deploy a docs/.**

## Invariantes (🔒)

- 🔒 Parquet `idps_largo.parquet` md5 `4c764d8c…` intocable; payload byte-idéntico (ninguna
  fase toca datos ni generador). Verifícalo al cierre extrayendo el blob base64.
- 🔒 #13 y #18 NO cambian cálculo: `serieEje`/`repartoInd`/`pctRound` quedan intactos; solo
  se añade render a partir de campos que esas funciones YA devuelven.
- 🔒 Bug s7-1: ningún comentario CSS contiene `*/` salvo el cierre real.
- 🔒 Significancia siempre LEÍDA del dato (`sigdif` por celda), nunca recalculada.
- 🔒 El glifo de #13 usa significancia TEMPORAL (`sig`, de `sigdif`: vs evaluación anterior),
  NO la de GSE (`sigdifgru`). No confundirlas.

## Contexto mínimo

Template ~1611 líneas (subió por Batch A; **relee, las líneas se movieron**). Zonas:

- **#23:** token `--st-neutro` (~L24). Lo consumen el segmento neutro de `StackedBar` (~L744)
  y los glifos `=` de `HistTrend`/marcas (`nt`).
- **#13:** `BarrasAnio` (~L876), el número sobre cada barra es `.ybar-val` (~L934). La serie
  viene de `serieEje` (~L808), que devuelve por punto `{a, v, dif, sig, estado}`. El glifo
  estandarizado vive en `HistTrend` (~L952): `sig===1?"▲":(sig===-1?"▼":"=")`, clases `de/al/nt`.
- **#18:** `StackedBar` (~L740), captura del comparador. Etiqueta interna por umbral
  (~L750): `≥16%`→"% (N)", `≥9%`→"%", `<9%`→nada.

**Paso 0 de cada fase:** abre el archivo, localiza la zona por contenido (no por el número de
línea de este encargo), confirma que calza. Si no, PARA y reporta.

---

## Fase 1 — #23: color "sin diferencia" a gris-azulado (CSS, 1 token)

**Qué.** `--st-neutro` es hoy `#8C8A86` (gris cálido), demasiado cercano al `--gris` de UI
(`#6b7780`, texto secundario) y a los grises "off". Virarlo a un gris-azulado ligeramente más
saturado que lo separe, manteniéndolo como punto medio del eje rojo→neutro→azul
(`--alerta`/`--st-neutro`/`--destaca`).

**Cómo.** Cambiar el valor del token (~L24):

```css
--st-neutro:#7E8A99;
```

No tocar `--gris` ni `--alerta` ni `--destaca`. El cambio se propaga solo a todo lo que use
`--st-neutro`.

**Verificación de contraste (🔒).** La etiqueta de % dentro del segmento neutro del comparador
usa `_txtOn(color)` para elegir texto claro/oscuro por luminancia. Confirma que con `#7E8A99`
el `%` interno sigue legible (AA): `_txtOn('#7E8A99')` debe devolver `#fff` (luminancia < 0.55)
y leerse bien. Si no, repórtalo (no fuerces otro valor sin avisar).

**Criterio de éxito.** El segmento "sin diferencia" del comparador y los glifos `=` cambian a
gris-azulado, distinguibles del gris de texto; contraste del % interno mantenido; render sin error.

---

## Fase 2 — #13: glifo de significancia temporal en cada número del histórico (markup)

**Qué.** En la vista histórica (`BarrasAnio`), junto a cada número de puntaje (`.ybar-val`),
añadir el glifo `▲/▼/=` de significancia **temporal** (vs evaluación anterior), con su color de
estado. Es la señalética que pide la captura 1 (matriz histórica).

**Semántica (igual que `Ancla`, no inventar otra):**
- **Dirección** por el signo de `dif`: `dif>0`→`▲`, `dif<0`→`▼`, `dif===0`→`=`.
- **Énfasis (color)** por `sig`: significativo (`sig===1` o `sig===-1`)→color de estado
  (`de`=destaca para ▲ sig, `al`=alerta para ▼ sig); no significativo→neutro (`nt`,
  el gris-azulado de #23).
- Reutiliza las clases existentes `de/al/nt` (las mismas de `HistTrend`).

**Cómo.**
1. En el render de cada barra con dato (dentro del `<span className="ybar-val">`, ~L934),
   añade el glifo tras el número, solo cuando hay comparación previa:

   ```jsx
   <span className="ybar-val">{fmt(p.v)}
     {p.dif!=null && (()=>{const g=p.dif>0?"▲":(p.dif<0?"▼":"=");
       const cls=(p.sig===1||p.sig===-1)?(p.dif>0?"de":(p.dif<0?"al":"nt")):"nt";
       return <span className={"ybar-sig "+cls} title={"vs evaluación anterior: "+(p.dif>0?"+":"")+p.dif+" pts"+((p.sig===1||p.sig===-1)?" (significativo)":" (solo aritmético)")}>{g}</span>;})()}
   </span>
   ```

   (Si prefieres no usar IIFE inline, extrae un pequeño helper `glifoSig(dif,sig)` junto a los
   componentes; mantén la semántica idéntica.)

2. CSS para `.ybar-sig` (junto a `.ybar-val`, ~L: busca el bloque de barras): tamaño menor que
   el número, sin romper la línea. Las clases `de/al/nt` ya tienen color definido (reutilízalas);
   si están scopeadas a otro contexto, replica el color con los tokens `--destaca`/`--alerta`/`--st-neutro`.

   ```css
   .ybar-val .ybar-sig{font-size:var(--fs-2xs);margin-left:3px;font-weight:var(--fw-bold);}
   .ybar-sig.de{color:var(--destaca);} .ybar-sig.al{color:var(--alerta);} .ybar-sig.nt{color:var(--st-neutro);}
   ```

**Matices obligatorios (🔒):**
- El **primer año con dato de cada serie** no tiene evaluación anterior → `dif===null` →
  **no se dibuja glifo**. La condición `p.dif!=null` lo cubre; verifícalo (la primera barra con
  dato no debe llevar glifo).
- Columnas "off" (pandemia/no_eval) y huecos "sin dato" no tienen `.ybar-val`, no aplican.
- No tocar `serieEje` ni el cálculo: `dif` y `sig` ya vienen por punto.

**Criterio de éxito.** En un EE con serie larga (ej. RBD 1692), cada barra con dato salvo la
primera muestra puntaje + glifo; el glifo coincide con el signo de `dif` y su color con `sig`
(▲ azul / ▼ rojo cuando significativo, gris-azulado cuando solo aritmético, `=` cuando dif=0);
la primera barra sin glifo; tooltip coherente; sin error de consola.

---

## Fase 3 — #18: etiqueta externa para segmentos finos del comparador (markup + CSS)

**Qué.** En `StackedBar` (comparador, captura 2), los segmentos con `p<9%` hoy no muestran
etiqueta interna (solo hover). Añadir una **tira externa bajo la barra** que liste los % que no
cupieron dentro, cada uno con su glifo de estado y color. Los segmentos `≥9%` mantienen su
etiqueta interna actual sin cambios.

**Cómo.**
1. Tras el `<div className="s100">…</div>` (el cierre de la barra apilada, ~L752), añade una tira
   externa condicional: solo se renderiza si existe al menos un segmento con `p>0 && p<9`.

   ```jsx
   {(()=>{const fin=parts.filter(s=>s.p>0&&s.p<9); if(!fin.length) return null;
     const gl={bajo:"▼",neutro:"=",sobre:"▲"};
     return <div className="s100-ext">{fin.map(s=>
       <span key={s.k} className="s100-ext-it" style={{color:s.c}} title={s.lbl+": "+s.count+" de "+rep.N+" ("+s.p+"%)"}>{gl[s.k]} {s.p}%</span>)}</div>;})()}
   ```

   (Envuelve la barra y la tira en un contenedor si hace falta para que la tira quede debajo;
   si `StackedBar` retorna un solo `<div className="s100">`, cámbialo por un fragmento que
   contenga la barra + la tira.)

2. CSS:

   ```css
   .s100-ext{display:flex;gap:8px;flex-wrap:wrap;margin-top:3px;font-size:var(--fs-2xs);line-height:1.2;}
   .s100-ext-it{font-weight:var(--fw-bold);white-space:nowrap;}
   ```

**🔒 de la fase:**
- No cambiar `repartoInd` ni `pctRound`: los % salen de `parts` ya calculado.
- `title` y `aria-label` del contenedor se conservan (la accesibilidad no depende de la tira).
- El glifo `=` del estado neutro usa el color de #23 (vía `s.c` = `var(--st-neutro)`).

**Gate de convergencia (regla de detención c).** Verifica en el comparador con territorios reales
que tengan estados minoritarios: la tira externa debe quedar bajo la barra, legible, sin empujar
la fila de la tabla ni romper la grilla por GSE. Si el rótulo externo degrada el layout de la
celda de forma real, PARA y reporta (el titular decide si rótulo externo, tooltip-only, o A19 con
referencia visual).

**Criterio de éxito.** En celdas con un estado <9%, su % aparece bajo la barra con glifo y color;
en celdas sin segmentos finos no se añade nada; layout de la matriz intacto; sin error de consola.

---

## Auto-auditoría antes de reportar

Sin riesgo de datos → principio general + verificación en navegador (no panel adversarial):

1. Render del motor sin errores de consola (salvo warning benigno de Babel).
2. **#23:** segmento neutro y glifos `=` en gris-azulado; % interno legible.
3. **#13:** en EE con serie larga, glifos por barra correctos (dirección por `dif`, color por
   `sig`); primera barra de la serie SIN glifo; columnas off sin número.
4. **#18:** celda del comparador con estado <9% muestra rótulo externo; gate de layout de la
   matriz pasa.
5. **Payload byte-idéntico:** extrae el blob base64 `atob("…")` del HTML regenerado y compáralo
   con el previo (`cmp`); parquet md5 pre/post = `4c764d8c…`.

## Log y cierre

Escribe el log en
`/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260624_batch_b1_s22_log.md`
(plantilla fija: resumen, por-cambio con verificación, invariantes 🔒 PASA/FALLA con evidencia,
gate de #18, pendientes). Déjalo **sin commitear**.

**Estado de cierre (importante):** NO commit, NO push, NO deploy. Los 3 cambios quedan en el
working tree del template, encima del build de Batch A. Build local regenerado y verificado.
El titular decidirá el commit del lote Batch B después.

## Reporte final al chat

- Resultado por fase en navegador, con evidencia (EE/RBD usado, qué viste).
- **#23:** valor de `_txtOn('#7E8A99')` y confirmación de contraste del % interno.
- **#13:** confirmación de que la primera barra de la serie NO lleva glifo y de que dirección/color
  coinciden con `dif`/`sig` en ≥2 casos (uno significativo, uno solo aritmético).
- **#18:** resultado del gate de layout (pasó o no); una celda de ejemplo con su rótulo externo.
- Payload byte-idéntico (sí/no) y parquet md5.
- Estado del working tree: 3 cambios sin commitear sobre el template; ruta del log.
