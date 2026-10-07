# Log de cierre — Rediseño Fase 2: pantalla Ficha (Panorama IDPS por establecimiento)

Fecha: 2026-06-20 · Modo: encargo autónomo secuencial · Alcance: `only=35` (solo template + regeneración).
**Sin commitear — para revisión del titular.**

## 1. Resumen

La pantalla `ficha` pasó del patrón **drill-down secuencial** (un nivel a la vez,
clic para bajar) al patrón **todo desplegado** del prototipo aprobado: un radar de
los 4 indicadores arriba y, debajo, un panel por indicador que muestra de una vez
sus dimensiones y, dentro de cada dimensión, sus subdimensiones. Se agregó un toggle
**Vista actual / Vista histórica** local a la pantalla, con el grado y el año también
locales (no se globalizaron al banner). La grilla territorial y la selección de
establecimiento NO cambiaron (se rediseñan en Fase 3).

Todo el trabajo fue en `30_procesamiento/35_motor_template.html` (la UI vive ahí; el
`.R` solo inyecta datos/libs). Se regeneró `40_salidas/motor_idps.html` (4.6 MB) con
`run_all(only=35)` vía el script R. El parquet `idps_largo.parquet` quedó intacto
(md5 idéntico). 0 errores de consola tras navegar la ficha completa (actual +
histórica), conmutar grado/año/vista y los 3 tabs.

Lo que costó: un bug de CSS que tardó en aparecer (un `*/` dentro de un comentario
cerró el comentario antes de tiempo y corrompió la regla `.ficha-bar`); ver §5.

## 2. Inventario de commits

- `71f4c1c` — feat(motor): pantalla ficha rediseñada (todo-desplegado: radar +
  paneles indicador/dimension/subdimension + toggle vista actual/historica).
  Exactamente 2 archivos: `30_procesamiento/35_motor_template.html` (+524/−...) y
  `40_salidas/motor_idps.html` regenerado. NO se publicó a `docs/`. Este log queda
  sin commitear, para revisión del titular.

## 3. Cambios sustantivos (con causa raíz)

1. **Nuevo componente `Ficha`** (reemplaza `Detalle`). Causa: el contrato de Fase 2
   pide layout todo-desplegado en vez de drill-down. Reusa la lectura de datos
   (`indOf/dimOf/nivOf`, `Radar`, `Ancla`, `DistBar`, `serieFull`, `PanelEvolucion`,
   `Definicion`, `gseLbl`); reorganiza, no reescribe, la lógica.
2. **`IndPanel` / `DimBlock` / `SubDist`** (nuevos). Panel por indicador con encabezado
   (prom + 2 anclas) + definición + dimensiones; cada dimensión con prom + barra 0–100
   (solo establecimiento) + 1 ancla (vs año); cada subdimensión como distribución de
   niveles (DistBar). Causa: asimetría de anclas por nivel exigida por el dato.
3. **`ScoreBar`** (nuevo). Barra 0–100 adaptada de `bar0100()` del prototipo
   ELIMINANDO el parámetro `gseRef` y la marca `.bar-gse`. Causa raíz documentada en
   comentario del template: el promedio absoluto del GSE no existe en el dato (solo
   `difgru`, el desvío); dibujarlo exigiría derivar `prom − difgru` → viola "lee, no
   deriva". El desvío vs GSE se comunica con anclas textuales.
4. **Tonos derivados de dimensión** (`dimColor` + helpers `_hx/_mix/_lighten/_darken`,
   portados del prototipo). Aclaran/oscurecen el color del indicador (`ind.color`) para
   teñir sus dimensiones; parten de la paleta invariante, no introducen colores nuevos.
5. **Toggle Vista actual/histórica** + cabecera de ficha oscura (`.ficha-bar`) con
   segmentadores Vista/Grado/Año (estética `.seg-lvl big` del prototipo). Estado
   `vistaFicha` en `App`. Histórica reusa `PanelEvolucion`/`serieFull` (line chart eje
   fijo 0–100, sin interpolar); se deshabilita si el grado tiene un solo año.
6. **`PanelEvolucion` gana prop opcional `hideHead`** (para no duplicar el nombre del
   indicador en la sección histórica). Único consumidor tras Fase 2 es `Ficha`.
7. **`App`: efectos ajustados.** grado/año ya NO limpian `rbdSel` (se pueden cambiar
   DENTRO de la ficha sin volver a la grilla); terr/dep/gse sí lo limpian. Nuevo efecto:
   si el grado pasa a tener un solo año, `vistaFicha` vuelve a "actual". Decisión de
   diseño (ver §7).
8. **`.nav` (grado/año/gse) movido al ramo de la grilla.** Antes envolvía grilla y
   detalle; ahora solo aparece con la grilla (sticky). La ficha trae sus propios
   controles en la barra oscura. Resuelve parte de la deuda sticky de Fase 1 (§8).
9. **Eliminados** `AnchorRow` y `SubdimView` (su lógica se reorganizó en los nuevos
   componentes; quedaron comentarios que documentan la eliminación).
10. **Sobrevive la nota del invariante** ("El motor lee difgru/sigdifgru… no reconstruye
    el puntaje del GSE"), ahora como `.nota-inv` visible entre el radar y los paneles.

## 4. Auditoría / panel adversarial

Se lanzó un **panel adversarial de 5 agentes solo-lectura** (workflow), cada uno
re-derivando con su PROPIO código (Rscript sobre el parquet; grep/Read sobre el
template y el HTML generado) una afirmación de riesgo, con sesgo a FALLA. Duración
~143 s, 84 tool-uses. **Veredicto unánime: 5/5 PASA.**

1. **No derivación de cifras (lee, no deriva).** PASA. ScoreBar dibuja solo con
   `value` (prom); sin `gseRef` ni `.bar-gse` ejecutables (la única coincidencia de
   "bar-gse"/"gseRef" en el HTML generado es el comentario explicativo). `indOf`/`dimOf`
   no hacen aritmética; las anclas pasan `difgru`/`dif` LEÍDOS. Riesgo: ninguno.
2. **Asimetría de anclas respeta el dato.** PASA, con evidencia dura del parquet:
   familia DIMENSIÓN → `difgru`/`sigdifgru` = **0 filas no-NA (100% NA)** de 508.959;
   familia INDICADOR → `difgru` ~49,8% no-NA. `dimOf()` no lee `difgru`; `IndPanel`
   renderiza 2 anclas (vs GSE + vs año), `DimBlock` 1 ancla (solo vs año), ninguna vs
   GSE en dimensión. "La asimetría es dato-first, no lógica-first."
3. **Subdimensión = distribución, no puntaje.** PASA. `nivOf` lee solo bajo/medio/alto;
   en el parquet las filas de subdimensión tienen `prom`=NA y niveles poblados
   (suma 100%). `SubDist` usa solo `DistBar`; `ScoreBar` aparece solo en `DimBlock`.
4. **"Sin dato" ≠ cero y sin interpolar.** PASA. NA real confirmado (RBD 32, 2° medio,
   2022, dimensión 22 → `prom`=NA, resguardo). Todas las rutas de NA rotulan "sin dato"
   (nunca 0); `d3.line().defined(d=>d.v!=null)` rompe en NA; `serieFull` solo recorre
   `grado_anios[grado]`. Años por grado: 4b = 2022/2023/2025 (sin 2024); 2m =
   2022/2023/2024/2025.
5. **md5 del parquet intacto.** PASA. md5 = `50d9de4f1fc80259d29f499cdf46d9e1`;
   `git status` no muestra ningún `.parquet` modificado; bajo `30_procesamiento` solo
   cambió `35_motor_template.html`.

Hallazgos del panel: **ninguno** con riesgo residual. Igual que en la sesión 6, el
panel re-derivó con código propio (no mis checks inline) y confirmó cada invariante.

## 5. Bugs (síntoma → causa → fix → verificación)

1. **`.ficha-bar` sin fondo azul ni texto cream (se veía texto oscuro sobre cream).**
   - Síntoma: la barra de identidad del establecimiento no tomaba `background:var(--azul)`
     ni `color:var(--cream)`; `getComputedStyle` daba fondo transparente y color `--tinta`.
     Curiosamente `.ficha-card` (regla posterior) sí funcionaba.
   - Causa raíz: el comentario CSS de cabecera del bloque Fase 2 contenía la cadena
     `.ficha-*/.indp` — el `*/` dentro de `*/.indp` CERRÓ el comentario antes de tiempo;
     el resto del texto del comentario pasó a interpretarse como CSS basura y, por
     recuperación de errores del parser, se "comió" la regla `.ficha-bar`.
   - Fix: reescribir el comentario sin la secuencia `*/` (de `(.ficha-*/.indp/…)` a
     `(clases .ficha-, .indp, …)`).
   - Verificación: regeneré; `getComputedStyle(.ficha-bar)` → `background rgb(10,58,92)`
     (=#0A3A5C azul), `color rgb(255,246,224)` (=cream), `display flex`. Capturé el
     header (correcto). Grep de `*/` en `<style>`: todas las apariciones son cierres
     legítimos de comentario.

## 6. Verificación de invariantes 🔒 (PASA/FALLA con evidencia)

- 🔒 **Paleta de 4 indicadores intacta.** PASA. `getComputedStyle` de los 4 dots de
  panel: `rgb(238,45,73)`=#EE2D49, `rgb(255,201,46)`=#FFC92E, `rgb(155,201,62)`=#9BC93E,
  `rgb(42,143,217)`=#2A8FD9. Los tonos de dimensión son derivados (más claros/oscuros)
  de cada color de indicador (rojos, amarillos, verdes, azules), dentro de la familia.
- 🔒 **Lee, no deriva — sin GSE absoluto.** PASA. El radar dibuja solo 2 trazos:
  azul (año actual) + dashed `#C77D3A` (año de comparación del PROPIO establecimiento);
  NO hay serie gris de referencia GSE (la del prototipo, `#B7AC96`). ScoreBar usa solo
  `value` (prom). Grep en el HTML generado de `bar-gse`/`GSE N puntos`/`gseRef`: única
  coincidencia = un comentario explicativo; 0 en CSS y markup.
- 🔒 **Asimetría de anclas por nivel.** PASA. Verificado en navegador con queries
  scopeadas: indicador → `["vs su GSE","vs año anterior"]` (2 anclas); dimensión →
  `["vs año anterior"]` (1 ancla, sin vs-GSE); subdimensión → DistBar (distribución),
  0 barras de score. `dimOf()` no lee difgru; `indOf()` sí.
- 🔒 **Significancia por texto.** PASA. `Ancla` muestra "· sig." / "· n.s." además del
  color; no se cambió.
- 🔒 **"Sin dato" ≠ cero; sin interpolar.** PASA. Establecimiento RBD 1853 en 2° medio
  (sin datos): indicador, dimensión, rcards y subdimensión muestran "sin dato"; ningún
  score "0/100" (`anyZeroScore:false`). Histórica 4° básico: ejes `2022, 2023, 2025*`
  (sin punto 2024); 2° medio: `2022, 2023, 2024, 2025*`. `PanelEvolucion` rompe en NA
  (`defined(d=>d.v!=null)`).
- 🔒 **Cobertura temporal asimétrica del dato.** PASA. `grado_anios` se deriva del
  roster (no hardcodeado); 4° básico sin 2024 confirmado en navegador.
- 🔒 **Radar solo 4 indicadores.** PASA. El radar de la ficha grafica solo los 4 proms
  de indicador; dimensiones/subdimensiones usan barras/distribución, nunca radar.
- 🔒 **RBD en línea aparte, sin negrita, sin paréntesis.** PASA. `.ficha-rbd` es
  `display:block`, `font-weight:var(--fw-regular)`, texto "RBD 1853" sin paréntesis.
- 🔒 **Alcance nacional, foco Costa Central.** PASA. No se re-etiquetó nada; el banner
  y el foco inicial (SLEP Costa Central) intactos.
- 🔒 **No tocar 34 ni regenerar parquet; md5 idéntico.** PASA. md5 de
  `idps_largo.parquet` = `50d9de4f1fc80259d29f499cdf46d9e1` antes y después. Solo se
  editó el template; `34_leer_normalizar_idps.R` intacto.

## 7. Decisiones tomadas en gates

- **grado/año locales a la ficha, no globales.** Se mantienen como estado de `App`
  (usados por la pantalla ficha) y se exponen en la barra oscura de la ficha; no se
  subieron al banner estático. (Pedido explícito del encargo.)
- **grado/año ya no expulsan al usuario a la grilla.** Antes cualquier cambio de
  grado/año limpiaba `rbdSel`. Se quitó eso para que cambiar Grado/Año DENTRO de la
  ficha re-renderice la misma ficha (como el prototipo). terr/dep/gse sí siguen
  volviendo a la grilla (cambio de contexto territorial).
- **Se conservó el control de Año en la ficha** (parity; el motor ya permitía elegir
  año). Agrupado con Vista y Grado en la barra oscura.
- **No se duplicó el buscador `.estab-search` del prototipo:** la búsqueda por
  nombre/RBD ya la cubre `.picker-strip` + `EntityModal` (pestaña Establecimiento).
- **rcards compactas:** muestran indicador + prom/100 + 2 anclas textuales; se omitió
  el bloque def/"alto" del prototipo para no duplicar lo que ya está en los paneles, y
  sin la marca de GSE absoluta (invariante).

## 8. Pendientes abiertos (`# REVISAR`)

- `# REVISAR` (Fase 3) **Estado "Vista histórica deshabilitada" no demostrable en
  vivo:** ningún grado del dato (solo 4b y 2m, ambos con ≥3 años) tiene un solo año,
  así que el botón nunca aparece deshabilitado con los datos actuales. La lógica está
  (serie=anios.length>1; disabled={!serie}; tooltip "Sin serie suficiente") y se
  ejercitaría con un grado de un año. Verificado por inspección de código, no en vivo.
- `# REVISAR` (Fase 3) **Sticky:** la `.nav` de la grilla sigue sticky; la barra oscura
  de la ficha NO es sticky (decisión coherente: en la ficha no hay `.nav`). Si Fase 3
  rediseña la grilla, revisar si la barra de ficha debe fijarse.
- `# REVISAR` (Fase 3) **Responsive del `.rquad`:** hay media query para apilar las
  rcards bajo el radar en <760px, pero no se probó a fondo en móvil (fuera de alcance).
- `# REVISAR` (Fase 3) **Tooltip del screenshot headless:** el preview no honró el
  scroll vía eval para las capturas profundas (problema de tooling, no del producto);
  la verificación se hizo con queries de geometría/estilos computados, más rigurosas.

## 9. Estado de cifras / datos críticos

Sin cambios en cifras. El rediseño es de presentación: lee las mismas medidas
(`indOf/dimOf/nivOf`) que el `Detalle` anterior, reorganizadas. `idps_largo.parquet`
intacto (md5 idéntico). Spot-check en navegador (RBD 1853 Costa Central): Autoestima
63/100 (vs GSE ▼ −13 sig., vs año ▼ −14 sig.), Convivencia 62, Participación 67,
Hábitos 62; dimensiones con prom y barra propios; subdimensiones como distribución.

## 10. Notas para el revisor (ojo crítico de cara a Fase 3)

- **El `.nav` de la grilla y la barra oscura de la ficha conviven** pero solo uno se ve
  a la vez (grilla vs ficha). Fase 3 rediseña la grilla; revisar la coherencia de los
  dos lenguajes de control (segmentador claro `.seg` vs `.seg-lvl big` oscuro).
- **rcards vs paneles:** las rcards repiten prom + anclas que también están en el
  encabezado del panel. Es intencional (lectura "de un vistazo" alrededor del radar),
  pero si se percibe redundante, las rcards podrían adelgazarse más.
- **Histórica:** muestra indicador + sus dimensiones (line charts). La subdimensión NO
  aparece en histórica por diseño (es distribución, no puntaje). Confirmar que es el
  comportamiento deseado.
- **Comparación de dos años en el radar:** se conserva (selector + leyenda). Por defecto
  superpone el año previo con datos. Ambos trazos son del propio establecimiento.
