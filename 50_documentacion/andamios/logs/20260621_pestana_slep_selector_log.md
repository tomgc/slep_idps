# Log — Pestaña SLEP en el selector territorial (con año de traspaso)

**Sesión 9 · 2026-06-21 · presentación + proyección del generador.**
Se editaron `35_generar_motor_html.R` (proyección JSON) y `35_motor_template.html`
(UI). Pipeline 31-34 y parquet NO se tocaron (`run_all(only=35)`). `docs/` NO se
republicó (espera OK visual del titular).

---

## Resumen

El selector territorial del Panorama territorial (componente `EntityModal`) ofrecía
**Región · Comuna · Dependencia · Establecimiento**. Ahora ofrece
**Comuna · SLEP · Región · Dependencia · Establecimiento**. La pestaña **SLEP** lista los
**36 SLEPs** con su **año de traspaso** como etiqueta de contexto (`sub: "Traspaso AAAA"`),
filtrable por buscador. Elegir un SLEP fija la navegación territorial a ese SLEP agrupando
**toda su serie histórica** por `cod_slep` (🔒-DOM: el `anio_traspaso` es etiqueta, nunca
filtro). Dependencia sobrevive (se reordenó, no se eliminó).

Para que el dato llegue al cliente, primero se expuso `anio_traspaso` en `DATA.sleps` (el
generador no lo proyectaba).

Estado final: **HECHO**. 0 errores de consola; verificado en navegador. md5 del parquet intacto.

---

## Inventario de commits

| Hash | Tipo | Título | Qué hizo |
|---|---|---|---|
| `b2b74d5` | feat | exponer anio_traspaso en DATA.sleps (generador 35) | `sleps_lst` ahora hace `left_join(distinct(SLE, cod_slep, anio_traspaso), by="cod_slep")`. Una fila por SLEP, con su año. |
| `3a9cce2` | feat | pestaña SLEP en selector territorial con año de traspaso como etiqueta | `SLEPS_OPTS` +`anio:s.anio_traspaso`; `TABS` reordenado a comuna/slep/region/dependencia/establecimiento; rama `tab==="slep"` en `buildList` (`sub:"Traspaso "+anio`); `searchPlaceholderFor` slep; `onPick` maneja `kind:"slep"` → `setTerr`; `unidades` filtra por `cod_slep`; `terrTxt` muestra el nombre del SLEP. |
| `0c8eb85` | build | regenerar only=35 con pestaña SLEP y anio_traspaso en el selector | Regeneró `40_salidas/motor_idps.html`. Parquet intacto. |

---

## Cambios sustantivos

### 1. Exponer `anio_traspaso` (generador — Fase 2)
- **Qué:** en `sleps_lst` (L286) se añadió un `left_join` con `distinct(SLE, cod_slep,
  anio_traspaso)`.
- **Decisión (enfoque):** **join localizado en `sleps_lst`** en vez de añadir `anio_traspaso`
  a `estab_slep`/`est_attr`. Motivo: `est_attr` alimenta varias proyecciones
  (`establecimientos_lst`, `regiones_lst`, comunas); añadir una columna ahí arriesga
  acoplar/inflar. El join en `sleps_lst` toca solo la lista de SLEPs. `anio_traspaso` es
  constante por `cod_slep`, así que `distinct(SLE, cod_slep, anio_traspaso)` da una fila por
  SLEP y el join no multiplica filas.
- **Archivos:** `35_generar_motor_html.R`.
- **Verificación:** `DATA.sleps` (decodificado en navegador) trae `anio_traspaso` para los 36
  SLEPs; distribución por año idéntica al parquet (2018:4/2020:3/2021:4/2024:4/2025:11/2026:10).

### 2. Pestaña SLEP en el selector territorial (template — Fase 3)
- **Qué:** ver inventario. La rama `slep` de `buildList` reusa el **patrón del comparador**
  (`buildListCmp` `tab==="slep"`): `{kind:"slep", cod, nom:"SLEP "+nom, sub:"Traspaso "+anio}`.
- **Decisión (SLEPS_OPTS):** se **extendió el `SLEPS_OPTS` existente** (compartido con el
  comparador) con `anio:s.anio_traspaso`, en vez de crear una proyección territorial aparte.
  El comparador ignora ese campo (sigue usando `ee`/`ncom`), así que no hay regresión. Menos
  duplicación.
- **Navegación (`kind:"slep"`):** el `onPick` territorial NO manejaba `slep` (el foco usa
  `kind:"foco"`). Se añadió `else if(item.kind==="slep") setTerr({kind:"slep",cod})`; y la
  rama `slep` en `unidades` (`String(e.cod_slep)!==String(terr.cod)`) y en `terrTxt`. **Sin
  ninguna comparación contra `anio_traspaso`** (🔒-DOM).
- **Orden de pestañas:** `TABS` ahora `comuna/slep/region/dependencia/establecimiento`; el tab
  inicial del modal pasa de Región a Comuna (efecto secundario esperado del reorden).
- **Archivos:** `35_motor_template.html`.

---

## Verificación de invariantes 🔒

| 🔒 | Estado | Evidencia |
|---|---|---|
| DOM — `anio_traspaso` etiqueta, no filtro | **PASA** | SLEP Aconcagua (traspaso 2026) elegido en el selector → Panorama territorial muestra **58 EE con dato 2025** (4° básico), no vacío. Por código: `buildList`/`onPick`/`unidades` agrupan por `cod_slep`; **ninguna comparación con `anio_traspaso`** (solo se muestra como `sub`). |
| 1 — Parquet intacto | **PASA** | md5 `50d9de4f1fc80259d29f499cdf46d9e1` **antes y después**. |
| 2 — Pipeline 31-34 intacto | **PASA** | Solo se editaron `35_generar_motor_html.R` y `35_motor_template.html`; build `run_all(only=35)`. |
| 3 — Cero agregación | **PASA** | Tarea de navegación/selección; no cambia cómo se leen las cifras. El SLEP solo acota qué EE se muestran (igual que el foco). |
| 4 — `docs/` no republicado | **PASA** | `docs/index.html` sin tocar; difiere del motor regenerado. |
| 5 — CSS sin `*/` literal | **PASA** | No se añadió CSS; comentarios JS/R nuevos sin `*/`. |
| 6 — Sin nombres reales de EE en código | **PASA** | No se introdujeron constantes con nombres de EE. |

---

## md5 del parquet
- ANTES:   `50d9de4f1fc80259d29f499cdf46d9e1`
- DESPUÉS: `50d9de4f1fc80259d29f499cdf46d9e1` ✓ idéntico.

---

## Auto-auditoría (5 checks del encargo)
1. **`anio_traspaso` llega al cliente:** PASA. `DATA.sleps` (36) lo trae; `grep -c
   anio_traspaso motor_idps.html` = 2 (referencias de código; el JSON va gzip+base64, no
   grepeable — verificado decodificando `DATA.sleps` en navegador).
2. **Etiqueta correcta:** PASA. Costa Central (503) → "Traspaso 2025"; Aconcagua (508) →
   "Traspaso 2026"; Andalién Sur → 2020; Atacama → 2021. Coinciden con `sleps_chile.parquet`.
3. **🔒-DOM no es filtro:** PASA. SLEP 2026 muestra serie 2025 (ver tabla arriba); código sin
   filtro por año.
4. **🔒-1 parquet:** PASA. Igual antes/después.
5. **Dependencia sobrevive:** PASA. Pestaña Dependencia presente y funcional (4 categorías:
   Municipal/Particular subvencionado/Particular pagado/SLEP).

---

## Notas para el revisor
- **`SLEPS_OPTS` filtra `ee>0`:** la pestaña muestra los SLEPs **con EE con dato IDPS**. Dieron
  **36** (todos), así que coincide con el catálogo. Si en una regeneración futura algún SLEP
  quedara sin EE con dato, no aparecería en la pestaña (no es navegable de todos modos). Lo
  dejo señalado.
- **Tab inicial del modal:** pasó de Región a Comuna por el reorden de `TABS` (pedido por el
  encargo). Si se prefiere otro tab por defecto, es un cambio de una línea.
- **Elegir el SLEP foco (Costa Central) por la pestaña** crea `terr={kind:"slep",cod:503}` (no
  `kind:"foco"`); ambos filtran por `cod_slep`. Aparece el link "volver a Costa Central" (por
  ser `kind!=="foco"`), que resetea al estado foco. Comportamiento correcto, sin conflicto.
- **Deploy:** `docs/` sin tocar; la republicación a Pages + push son el **paso siguiente del
  titular** tras OK visual sobre `motor_idps.html`.

## Decisión sobre este log
Queda **sin commitear** (revisión del titular), igual que los logs previos antes de
versionarse en el cierre de sesión.
