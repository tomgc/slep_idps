# Log — Lote UI/UX directo + 2 bugs (s21, tramo 1)

> Ejecución autónoma del encargo "lote UI/UX directo + 2 bugs (s21, tramo 1)".
> Fecha: 2026-06-24. Ejecutor: Claude Code (Opus 4.8). Rama: `main`.
> Archivo tocado: `30_procesamiento/35_motor_template.html` (solo template).
> **Push NO ejecutado; docs/ NO tocado.** Build local regenerado. Log SIN commitear.

---

## 1. Resumen

11 ítems de presentación (#2,#3,#4,#6,#10,#11,#14,#15,#19,#20,#21) en 7 fases, una
con commit atómico cada una (la fase 6 fue solo diagnóstico, sin commit). Todo
texto/CSS/JSX: fidelidad censal mismatch 0, parquet intacto, payload byte-idéntico.
Cero regresiones de layout (los dos casos de riesgo, #6 rcard y #20 th con nombre
completo, no desbordan). El bug #19 resultó ser de umbral de ancho (no de datos) y el
conteo ya está siempre accesible por hover → solo diagnóstico, sin cambio.

## 2. Inventario de commits

| Fase | Hash | Tipo | Título |
|---|---|---|---|
| 1 | `92ec92b` | docs | recorta y unifica textos de leyenda, preliminar y significancia |
| 2 | `a1226d8` | style | elimina leyenda redundante de indicadores bajo el radar |
| 3 | `10c1c0a` | feat | lista comunas por SLEP en tres lineas + nivel seleccionado en meta |
| 4 | `a6971a6` | feat | nombre completo de indicador en tarjetas rcard y comparador |
| 5 | `de142c0` | style | alinea columna Territorio a la derecha en el comparador |
| 6 | (sin commit) | — | diagnóstico bug #19 (sin cambio de código) |
| 7 | `eabf544` | feat | definicion estatica con titulo en color del indicador (sin toggle) |

## 3. Qué se tocó, por ítem

- **#11** (L1175): leyenda de subdimensiones recortada a "· el tono lo da cada
  indicador."; conservados los 3 swatches Bajo/Medio/Alto. Verificado en navegador.
- **#14** (L1106 + L1123): "Los años con * son preliminares." → "El signo * al lado
  del año indica el carácter preliminar de los resultados, según lo informado por la
  Agencia." (2 lugares; el de L1123 conserva el condicional `anios.some(...)?…:""`).
  Grep "son preliminares" = 0 restantes.
- **#15** (L1106 + L1123): frase unificada "La significancia estadística es calculada e
  informada por la Agencia." Reemplazó "se leen de la Agencia (no se calculan)" (L1106,
  directa) y la cláusula "leídas de la Agencia" de L1123 (separada como oración propia).
  Grep de variantes huérfanas = 0 (el "se leen" de L1168 es "se leen en los paneles",
  no relacionado; intacto por diseño).
- **#2** (L1567–1575): eliminada la leyenda de los 4 indicadores con ⓘ + "★ Costa
  Central". **Nota de ubicación:** el encargo la situó "bajo el radar de la ficha", pero
  estaba en el **Panorama territorial** (es la única con `leg-item`+ⓘ+★, identidad
  inequívoca). Detención (c) descartada: la definición sigue accesible por
  `<Definicion>` en cada `IndPanel` (L1032), que el encargo nombra como acceso alterno.
  Verificado: `leg-item`=0, "★ Costa Central"=0 en runtime; el grid sigue renderizando.
- **#3** (pan-id): nueva línea `.pan-comunas` entre `pan-name` y `pan-meta`, SOLO para
  SLEP (`terr.kind` foco/slep). Lista de nombres de comuna del territorio, únicos,
  orden alfabético es-CL, formato "A, B, C y D". CSS `.pan-comunas` con tokens del
  banner (cream, `--fs-sm`), sin color nuevo. Verificado: "Concón, Puchuncaví, Quintero
  y Viña del Mar" en foco Costa Central; ausente en comuna Algarrobo.
- **#4** (pan-meta): "{n} establecimientos" → "{n} establecimientos en el nivel
  seleccionado". El prefijo "{panComunas} comunas ·" se quita para SLEP (las comunas
  van arriba con nombres) y se conserva para comuna/región/dependencia. Verificado en
  ambas ramas (SLEP sin prefijo; comuna con "1 comuna ·").
- **#6** (rcard-name, L1145): `{ind.corto}` → `{ind.nombre}`. Radar (axes) intacto con
  `ind.corto`. Verificado: 4 nombres completos en rcard, **0 overflow**.
- **#20** (comparador th, L1404): `{i.corto}` → `{i.nombre}` + clase `th-ind` con
  `white-space:normal` (permite envolver; `th-terr` intacto). Verificado: nombres
  completos en los th, `white-space:normal`, **0 overflow** (table-layout fixed reparte
  el ancho).
- **#21** (CSS): `.cmp-table th.th-terr` y `.td-terr` → `text-align:right`. Verificado:
  ambos computan `right`.
- **#10** (Definicion): convertido de toggle colapsable a **texto estático**. Título
  fijo "¿Qué mide este indicador?" en NEGRITA y en el color del indicador (prop nueva
  `color={ind.color}` en L1032), sin ▾/ⓘ; definición SIEMPRE visible. CSS `.defn-toggle`
  reemplazado por `.defn-title`. Verificado: `defn-title` color `rgb(56,88,163)`
  (#3858A3 = Autoestima), `font-weight:700`, 0 toggles restantes, 15 definiciones
  visibles. (El `DimBlock`/L1003 "Sobre esta dimensión" no recibe color → usa el default
  `--tinta`; el encargo solo pidió color para el de indicador.)

## 4. Diagnóstico bug #19 (componente y umbral)

- **Componente:** `StackedBar` es el ÚNICO componente de barra apilada; se usa TANTO en
  el comparador (matriz, L1411 `<td><StackedBar rep={repartoInd(...)}/></td>`) COMO en
  el grid del Panorama territorial (L1596). No hay un render distinto para el
  comparador.
- **Umbral confirmado:** la etiqueta visible es `s.p>=16?(p+"% (n)"):(p>=9?p+"%":"")`
  (L755) — umbral de **ANCHO** (un segmento angosto no cabe "(n)"), no de datos.
- **Conteo siempre accesible:** cada `.s100-seg` lleva
  `title={lbl+": "+count+" de "+N+" ("+p+"%)"}` (L756) — el conteo está en el tooltip de
  hover SIEMPRE, incluso en segmentos <9% sin etiqueta visible. Verificado en navegador:
  un segmento mostró title "= sin diferencia significativa: 4 de 4 (100%)".
- **Conclusión:** no es bug de datos ni hay componente sin title. **Sin cambio de
  código** (no commit). La solución visual para mostrar "(n)" en segmentos angostos es
  el **#18** (NO incluido en este encargo) — queda enlazado como pendiente.

## 5. Regresiones de layout

**NINGUNA.** Verificación de `scrollWidth/Height > client`:
- #6 rcard-name (nombre completo): 0/4 overflow.
- #20 th-ind (nombre completo, wrap): 0/20 overflow (5 GSE × 4 indicadores).
- #10 definición: 15 visibles, sin desborde.
Render sin errores de consola (solo warning benigno de Babel CDN).

## 6. Verificación de invariantes 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet intocable; fidelidad censal 0 | **PASA** | md5 `4c764d8c…` igual; ind/dim/niv mismatch 0; payload byte-idéntico (los 11 bloques `identical()`, meta solo difiere en fecha). |
| GSE/significancia solo a nivel indicador; no inyectar NA | **PASA** | Solo se cambiaron textos descriptivos; ninguna lógica de significancia ni de reparto. |
| Escala de gráficos intacta (BarrasAnio 0–100, DistBar rampa) | **PASA** | No se tocó ningún gráfico ni su escala; #19 fue diagnóstico. |
| Bug s7-1 (comentarios CSS) | **PASA** | El único comentario CSS nuevo (`.cmp-table th.th-ind{…}`) no contiene `*/` interno. |
| Cambio quirúrgico (B.3) | **PASA** | git diff: solo textos, CSS de tipografía/alineación, JSX de los ítems listados. Sin cambios de color de paleta, lógica de datos ni escala. |

## 7. Pendientes y notas

- **#18 (enlazado a #19):** mostrar el conteo "(n)" en segmentos angostos del
  `StackedBar` (etiqueta externa o tooltip mejorado). NO en este encargo. El conteo ya
  está en el title de hover como solución provisional.
- **Deploy/push:** gate del titular. Build local regenerado, docs/ intacto. 6 commits
  locales sin push (92ec92b, a1226d8, 10c1c0a, a6971a6, de142c0, eabf544).
- **CSS muerto menor (no tocado, fuera de scope):** `.leg-item`/`.leg-info` (CSS L111–115)
  y `showTTEl` (L588) quedan sin uso tras eliminar la leyenda #2. Reportado; no removido
  (cambio quirúrgico). Afinable en una higiene futura.
- **Pendiente vivo previo:** `# REVISAR jerarquía .axis-lab.b` (del encargo de
  tipografía s20). No tocado aquí.
