# Encargo autónomo — slep_idps, Batch A (s22)

> Lote directo verificable sobre `30_procesamiento/35_motor_template.html`. Cuatro
> ítems sin decisión de diseño abierta. Modo autónomo, secuencial, todo en este turno.

---

## Encabezado de contrato

- **Modo:** autónomo, secuencial. Ejecuta las 4 fases en orden en este turno.
- **Stack:** edición de un único archivo (`35_motor_template.html`, React 18 + D3 v7
  inline). No se toca R, ni el generador, ni el parquet, ni el payload.
- **Rutas absolutas siempre.** Raíz: `/Users/tomgc/Projects/slep_idps`. Archivo:
  `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`.
- **Regla de detención (PARA y reporta):** (a) si un invariante 🔒 te obligaría a
  violarlo; (b) si el estado real del archivo no calza con lo que este encargo
  describe (líneas movidas, código distinto) de modo que no puedas localizar la zona
  con certeza; (c) si subir el tope del comparador rompe el layout de la matriz en la
  verificación visual. No improvises metodología.
- **Build:** tras editar el template, regenera el motor y despliega a `docs/` SOLO
  hasta dejar el build local verificado; **el push queda gateado al titular** (no
  empujes a origin sin visto bueno).

## Invariantes (🔒)

- 🔒 Parquet `idps_largo.parquet` md5 `4c764d8c…` intocable. Este encargo no toca datos.
- 🔒 `BarrasAnio` escala fija 0–100: subir el alto de barras (#22) cambia el alto del
  **plot en px**, NUNCA la escala de datos ni el mapeo `height:p.v%`. El `--yh` es alto
  visual del contenedor, no rango de valores.
- 🔒 `EntityModal` modo simple intacto al subir `maxSel`: el componente se usa también
  con `multiple=false` (selección de un EE). Verifica que el modo simple siga funcionando.
- 🔒 Paleta de 4 indicadores y la media móvil (`MMOVIL_VENTANA=3`, `MMOVIL_MIN_PUNTOS=4`)
  intactas: #12 es solo leyenda, no toca el cálculo ni el trazo.
- 🔒 Bug s7-1: ningún comentario CSS contiene la secuencia `*/` salvo el cierre real
  del comentario. Al editar comentarios CSS en la zona `.axis-lab`, respétalo.
- 🔒 El radar NO lleva comparación temporal (no se reintroduce overlay). Nada en este
  encargo lo toca; se declara por higiene.

## Contexto mínimo

El template tiene ~1609 líneas. Las zonas (verificadas al 2026-06-24, pero **releelas**:
las líneas se movieron mucho en s21):

- **Comparador**: componente `Comparador(...)` (~L1328), invocado (~L1528). Modal de
  selección `EntityModal` con prop `maxSel` (~L1184). Estado/handlers en el componente
  raíz (~L1439–1469).
- **Histórico**: `BarrasAnio(...)` (~L876), media móvil `mediaMovil(...)` (~L868),
  render del bloque histórico con `.ficha-explain` (~L1105).
- **CSS**: barras `--yh` (~L346, L354); `.axis-lab` (~L201–202); `.sw-line` (~L119).

**Paso 0 de cada fase:** abre el archivo y localiza la zona por su contenido (no por el
número de línea de este encargo). Si no la encuentras tal como se describe, PARA y reporta.

---

## Fase 1 — `.axis-lab.b`: restaurar jerarquía (CSS, determinista)

**Qué.** La marca `# REVISAR` de L201–202 es real: tras la tokenización tipográfica de
s20, `.axis-lab` y `.axis-lab.b` quedaron ambas en `var(--fs-2xs)` (11px), y la variante
`.b` (usada en etiquetas de eje del radar y en los años del histórico, ej. L620, L827)
perdió la distinción de tamaño que tenía (era 10 vs 9px).

**Cómo.** Restaurar la jerarquía por **peso**, no por tamaño (no reintroducir un pixel
ad-hoc fuera de la escala de 7 tokens). La variante `.b` lleva `font-weight:var(--fw-bold)`
(700); la base se mantiene en el peso por defecto. Ambas conservan `var(--fs-2xs)`.

```css
.axis-lab{font-size:var(--fs-2xs);fill:var(--gris);} .axis-lab.b{font-size:var(--fs-2xs);font-weight:var(--fw-bold);}
```

Reescribe también el comentario `# REVISAR` de L201 como comentario resuelto (sin la
marca REVISAR), documentando que la distinción ahora es por peso. Cuida que el nuevo
comentario CSS no contenga `*/` salvo el cierre (🔒 Bug s7-1).

**Criterio de éxito.** En el radar de la ficha y en los años del histórico, las
etiquetas `.b` se ven en negrita respecto de la base; ambas mismo tamaño (11px); 0
marcas `# REVISAR` sobre `.axis-lab`; render sin error de consola.

**Commit:** `style(historico): restaura jerarquia .axis-lab.b por peso (cierra REVISAR s20)`

---

## Fase 2 — #22: subir sutilmente el alto de las barras (CSS, determinista)

**Qué.** Subir de forma sutil el alto visual de las barras del histórico. Hoy:
`--yh:152px` en `.hist-main .ybars` (L346) y `--yh:118px` en `.hist-dim .ybars` (L354).

**Cómo.** Subir ambos tokens de forma proporcional y sutil: `152→168` y `118→130`. (Es
alto del contenedor del plot; la línea de media móvil y las barras se recalculan solas
porque la media móvil mide la posición real vía `getBoundingClientRect`, y el fill usa
`%`.) No tocar `var(--yh,130px)` de L328 (fallback genérico).

**Criterio de éxito.** Barras visiblemente algo más altas, proporción indicador/dimensión
preservada; la línea de media móvil sigue alineada a las columnas (verifícalo en un EE con
≥4 años de dato, ej. RBD 1 o el que tenga serie larga); escala 0–100 intacta (un valor de
~74 sigue llegando a ~74% del alto); 0 errores de consola.

**Commit:** `style(historico): sube sutilmente el alto de las barras (#22)`

---

## Fase 3 — #12: leyenda de la media móvil en el histórico (markup + CSS leve)

**Qué.** La vista histórica explica la media móvil en prosa (`.ficha-explain`, "La línea
tenue… es el promedio móvil…") pero no tiene una **muestra visual** de leyenda que asocie
el trazo a su nombre. Agregar una tira de leyenda con un swatch de **línea tenue** y el
texto, reutilizando el patrón `.sw-line` ya existente (modelo: la leyenda del `radar-cmp`,
~L1149).

**Cómo.**
1. Tras el `.ficha-explain` del histórico (la que termina en "Solo se dibuja con 4 o más
   años con dato.", ~L1105) y antes del `.map` de indicadores, agrega una leyenda:

   ```jsx
   <div className="leyenda hist-leg">
     <span><span className="sw-line mm"></span>Promedio móvil (tendencia)</span>
   </div>
   ```

2. CSS: la muestra debe leerse como **línea tenue**, coherente con el trazo real
   (`strokeOpacity 0.5`, color del indicador). Como en la leyenda el color del indicador
   no aplica (es transversal), usa un gris tenue. Junto al bloque `.sw-line` existente
   (~L119) agrega:

   ```css
   .sw-line.mm{border-top-style:solid;border-top-width:1.6px;border-top-color:var(--gris);opacity:.6;}
   .hist-leg{justify-content:flex-start;margin:0 0 4px;padding:0 2px;}
   ```

   (Verifica los valores reales de `.sw-line` al leer: replica su `width/height/vertical-align`;
   solo cambia estilo/color/opacidad para evocar la línea tenue.)

**Invariante de la fase.** Es solo leyenda: no toca `mediaMovil()`, ni el `<polyline>`, ni
los tokens `MMOVIL_*`. El trazo real no cambia.

**Criterio de éxito.** En la vista histórica aparece una tira de leyenda con una muestra de
línea tenue y el texto "Promedio móvil (tendencia)"; visualmente coherente con el trazo de
las barras (no un cuadrado de color, una línea); no se solapa con `.ficha-explain`; render
sin error.

**Commit:** `feat(historico): leyenda visual de la media movil (#12)`

---

## Fase 4 — #16/#17: tope del comparador 4 → 10 (estado + textos, verificación de layout)

**Qué.** Subir el tope de territorios comparables de 4 a 10. El "4" está hardcodeado en
**5 lugares** (no solo `maxSel`); subir solo uno deja textos y guards mintiendo:

- `maxSel={4}` en la invocación de `EntityModal` (~L1525).
- `{cmpTerr.length} de 4` (texto contador, ~L1351).
- `cmpTerr.length<4` (guard del botón "+ agregar", ~L1359).
- textos "…para comparar, hasta 4." y "…(hasta 4)." (`cmp-invite`, ~L1362).
- `if(prev.length>=4) return prev;` (guard en `addTerr`, ~L1469).

**Cómo.** Introduce una constante única y referénciala en los 5 lugares (DRY; evita que
una próxima subida vuelva a desincronizarse). Declárala junto a las demás constantes del
componente raíz (donde viven `MMOVIL_*`, `ANIOS_PANDEMIA`, etc.; búscalas):

```js
const CMP_MAX_TERR = 10;
```

- `maxSel={CMP_MAX_TERR}`
- contador: `{cmpTerr.length} de {CMP_MAX_TERR}`
- guard botón: `cmpTerr.length<CMP_MAX_TERR`
- guard add: `if(prev.length>=CMP_MAX_TERR) return prev;`
- textos `cmp-invite`: reemplaza "hasta 4" por `hasta {CMP_MAX_TERR}` (interpola; no dejes
  el número literal).

**Verificación de layout (gate 🔒 — el riesgo de esta fase).** La matriz es una `<table>`
con **una fila por territorio** dentro de `.cmp-tscroll` (scroll horizontal ya presente);
el ancho lo fijan los 4 indicadores (constante), así que crecer a 10 filas es vertical y no
debería romper. **Pero verifícalo empíricamente:** agrega 10 territorios reales y comprueba
que (a) la tabla por GSE renderiza 10 filas legibles, (b) no hay desborde horizontal nuevo
ni colapso de columnas, (c) el modal de selección deshabilita las no marcadas al llegar a
10 (`topeAlcanzado`), (d) el contador muestra "N de 10". Si el layout se degrada de forma
real (no estética menor), PARA y reporta antes de commitear: el titular decide si 10 o un
tope intermedio.

**Verificación del modo simple (🔒).** Confirma que `EntityModal` con `multiple=false`
(selección de un EE en la ficha) sigue intacto: `maxSel` solo aplica en modo múltiple.

**Criterio de éxito.** Se pueden agregar hasta 10 territorios; los 5 puntos referencian
`CMP_MAX_TERR`; 0 textos con "4" residual relativo al tope; matriz legible a 10; modal tope
a 10; modo simple intacto; sin error de consola.

**Commit:** `feat(comparador): sube el tope de territorios 4->10 via CMP_MAX_TERR (#16/#17)`

---

## Auto-auditoría antes de reportar

Verificación en navegador obligatoria (este encargo no tiene riesgo de datos, así que basta
el principio general, no panel adversarial):

1. Render del motor sin errores de consola (solo el warning benigno de Babel CDN).
2. **#22 + #12:** en un EE con serie larga, barras más altas y media móvil alineada; leyenda
   de media móvil visible y coherente.
3. **Fase 1:** etiquetas `.b` en negrita en radar e histórico.
4. **#16/#17:** 10 territorios agregables, matriz legible, contador y textos en 10, modal
   tope a 10, modo simple de `EntityModal` intacto.
5. **Payload byte-idéntico:** como ninguna fase toca datos ni generador, el payload del
   motor regenerado debe ser idéntico al previo salvo lo que cambie por el template. Si
   regeneras vía build, confirma que el parquet y los datos embebidos no cambiaron.

## Log y cierre

Escribe el log en
`/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260624_batch_a_s22_log.md`
(plantilla fija: resumen, inventario de commits con hash, por-cambio con causa/verificación,
verificación de invariantes 🔒 con PASA/FALLA y evidencia, pendientes). Déjalo **sin
commitear** (revisión previa del titular) o como `docs()` atómico aparte, a tu criterio.

**Estado de cierre:** 4 commits atómicos (uno por fase). Build local regenerado y verificado.
**NO push** a origin: el deploy a `docs/` y el push quedan gateados al titular.

## Reporte final al chat

- Hash corto de los 4 commits, con su título.
- Resultado de la verificación en navegador por fase (con evidencia: qué EE/RBD usaste,
  qué viste).
- **Resultado del gate de layout de la matriz a 10** (el punto de mayor riesgo): pasó o no.
- Confirmación de que el modo simple de `EntityModal` quedó intacto.
- Confirmación de que el payload no cambió (datos byte-idénticos).
- Marcas `# REVISAR` que persistan (la de `.axis-lab` debe haber desaparecido).
- Ruta del log.
- Estado git: 4 commits locales, sin push (esperando gate del titular para deploy).
