# Log — Polígono GSE en el radar + texto del bloque azul + leyenda duplicada (s21)

> Ejecución autónoma del encargo "polígono GSE + texto + limpieza leyenda" (s21).
> Fecha: 2026-06-24. Ejecutor: Claude Code (Opus 4.8). Rama: `main`.
> Archivos tocados: `35_generar_motor_html.R` (Fase 1) y `35_motor_template.html` (1,2,3).
> **Push NO; docs/ NO tocado.** Build local regenerado. Log SIN commitear.

---

## 1. Resumen

Se añadió el polígono GSE de referencia al radar de la ficha (`prom_gse = prom_crudo −
difgru`, reconstrucción EXACTA, solo 2024-2025, solo nivel indicador), se reescribió el
texto del bloque azul para describirlo, y se eliminó la leyenda de significancia
duplicada de la ficha. Fidelidad censal mismatch 0; parquet intacto; payload
byte-idéntico salvo el campo nuevo `prom_gse`. Panel adversarial independiente: 0
mismatch en 366.384 filas. Reportadas 2 inconsistencias de texto fuera de scope.

## 2. Inventario de commits

| Fase | Hash | Tipo | Título |
|---|---|---|---|
| 1 | `4493bcf` | feat | poligono GSE de referencia (prom - difgru), solo 2024-2025, nivel indicador |
| 2 | `11e7d62` | docs | reescribe el texto del bloque azul (describe poligono GSE + significancia) |
| 3 | `ef15f5e` | style | elimina la leyenda de significancia duplicada (conserva la del bloque azul) |

## 3. Detalle por fase

### Fase 1 — Polígono GSE
- **Generador (`35_generar_motor_html.R`):** nuevo `prom_gse` en `ind_lst` =
  `round(prom_crudo − difgru, 0)` cuando `difgru` y `cod_grupo` no son NA; NA en caso
  contrario; NA si fuera de 0-100 (con `message` de reporte). Build: 69.646 con valor,
  296.738 NA, **0 fuera de 0-100**.
- **Template:** `indOf` lee `prom_gse`. El componente `Radar` gana props
  `axesG/colG/labelG` y dibuja un tercer trazo: línea **punteada gris** (`2 4`),
  distinta del overlay temporal (`4 3`, var(--cmp-year)) y del trazo EE (sólido azul).
  Tooltip con el rótulo completo "Puntaje promedio nacional del mismo GSE: X pts";
  leyenda "Promedio del mismo GSE" con swatch `.sw-line.gse` (punteado gris) → canal NO
  cromático (patrón + rótulo). El trazo EE se dibuja al final (queda encima).
- **Decisión de diseño (polígono parcial):** el polígono se dibuja SOLO si los 4
  indicadores tienen `prom_gse` (`axIndG.every(...)`), no parcial. Justificación: un
  polígono de 2-3 vértices con `curveLinearClosed` sería un trazo engañoso. Datos
  2024-2025 con cod_grupo: **87.2% completos** (4/4), ~1.3% parciales (1-3) que se
  omiten, 11.7% sin GSE en ningún indicador. (El encargo dejaba elegir entre omitir-si-
  algún-NA y seguir-el-patrón-del-overlay; se eligió omitir, el default del encargo.)
- **Verificación navegador:** RBD 10 (4b 2025, completo): 4 círculos GSE; **Convivencia
  difgru=0 → círculo GSE en (231,150) = círculo EE (231,150), coinciden exactamente**
  (caso 74/74/0); los otros 3 separados por la magnitud de difgru. RBD 1440 (parcial
  2/4) → **sin polígono** (0 círculos, leyenda sin entrada GSE). 0 errores de consola.

### Fase 2 — Texto del bloque azul
- Reemplazado el `.ficha-explain` (antes "Una sola pantalla, todo desplegado…") por el
  texto verbatim aprobado, con `<b>` en "radar de los 4 indicadores", "línea punteada",
  "diferencia significativa (sig.)", "sólo aritmética"; ▼ rojo (var(--alerta)) y ▲ azul
  (var(--destaca)) conservan color (patrón previo, refuerza canal no cromático). Sin
  condicionales JSX en el bloque (era estático). Grep texto viejo = 0; paréntesis final
  cerrado (verificado en navegador: termina en "su referencia).").

### Fase 3 — Leyenda duplicada
- Eliminada la tira `.leyenda.pan-state-leg` de la FICHA (▼ bajo su GSE / = sin
  diferencia / ▲ sobre su GSE) que duplicaba la leyenda de significancia ahora en el
  bloque azul. Conservadas las OTRAS dos `pan-state-leg` (comparador L1408, territorial
  L1597 — pantallas distintas, sin bloque azul). CSS `.pan-state-leg` compartido → NO
  removido. Verificado: 0 `pan-state-leg` en la ficha; 2 restantes.

## 4. Panel adversarial (reconstrucción de dato)

Agente read-only independiente, código propio, re-derivó `prom_gse = round(prom_crudo −
difgru, 0)` desde el parquet y comparó vs el build. **VEREDICTO: PASA.**
- Mismatch fila a fila: **0** sobre 366.384.
- 69.646 con valor, **0 fuera de 0-100**, **0 en años 2014-2023**.
- Caso publicado prom=74/difgru=0 → 74 (784 casos, todos).
- Signo: difgru>0 → prom_gse<prom (33.119); difgru<0 → prom_gse>prom (30.785);
  contra-test `prom+difgru` = 0 filas. Confirma `prom − difgru` (no `+`).
- Confirmó uso de `prom` CRUDO (no el redondeado del payload).

## 5. Verificación de invariantes 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet intocable; fidelidad censal 0 | **PASA** | md5 `4c764d8c…` igual; bloques no-ind idénticos al build s20; `ind` solo gana `prom_gse`, campos existentes (prom/dif/sigdif/difgru/sigdifgru) idénticos. |
| Payload byte-idéntico salvo campo GSE | **PASA** | único campo nuevo en `ind` = `prom_gse`; resto del payload idéntico. |
| GSE solo nivel INDICADOR | **PASA** | `prom_gse` solo en `ind_lst`; dim/niv sin cambio. |
| NA nunca a 0 | **PASA** | `prom_gse` NA donde difgru/cod_grupo NA (296.738 NA); el radar omite el trazo, no degrada a 0; `.every` evita parciales. |
| prom CRUDO usado (no redondeado) | **PASA** | generador resta difgru a `ind$prom` crudo antes del round; panel adversarial confirmó vs prom crudo del parquet. |
| Escala del radar intacta | **PASA** | solo se agregó un trazo (rsc/dominio 0-100 sin cambio); BarrasAnio/DistBar sin tocar. |
| Bug s7-1 (comentarios CSS) | **PASA** | comentarios nuevos sin `*/` interno (verificado). |

## 6. Desajuste "radar sin polígono" (Fase 1, caso de detención (c) — REPORTADO, no bloquea)

El radar muestra siempre `fichaAgno` (año más reciente del grado). Casos sin polígono
pese a que el bloque azul afirma "La línea punteada indica los resultados de su GSE":
- EE con cod_grupo pero `difgru` parcial (1-3 de 4 indicadores) → sin polígono (~1.3%).
- EE con cod_grupo NA → sin polígono.
- EE solo-histórico (año más reciente ≤ 2023) → sin polígono Y sin trazo EE (radar
  vacío); el texto es menos disonante porque tampoco hay "foto actual".

No se inventó comportamiento: el polígono se omite correctamente (NA = supresión). El
texto de Fase 2 es el aprobado y se deja tal cual. **Pendiente para el titular:** decidir
si el texto debe condicionarse a `hasGse` (p. ej. ocultar la frase de la línea punteada
cuando no hay polígono) o dejarse incondicional.

## 7. # REVISAR — inconsistencias de texto detectadas (fuera de scope, NO tocadas)

Con el polígono GSE, dos textos quedaron contradictorios (afirman que el GSE no se
dibuja). Cambio quirúrgico: se REPORTAN, no se implementan.
- **`35_motor_template.html:1187`** (`.nota.nota-inv` bajo los paneles): *"…no
  reconstruye el puntaje del GSE. Por eso las barras muestran solo el promedio del
  establecimiento…"*. Sigue siendo cierto para las BARRAS (dimensión), pero la frase
  global "no reconstruye el puntaje del GSE" es ahora falsa para el radar.
- **`35_generar_motor_html.R:12`** (comentario de cabecera): *"…no se dibuja la linea
  absoluta del GSE"*. Ahora el radar sí dibuja el polígono GSE (decisión 20260624).

Recomendación: actualizar ambos textos en un encargo de afinación (declarar que el GSE
absoluto SÍ se muestra en el radar, reconstruido exacto desde difgru; las barras siguen
sin GSE).

## 8. Pendientes / estado

- **Deploy/push:** gate del titular. Build local regenerado (`40_salidas/motor_idps.html`,
  sin commitear); docs/ intacto. 3 commits locales: `4493bcf`, `11e7d62`, `ef15f5e`.
- Decisión `20260624_decision_poligono_gse_radar.md`: el contenido normativo se siguió
  del encargo (la decisión la versiona el titular).
- Pendiente previo vivo: `# REVISAR jerarquía .axis-lab.b` (s20).
