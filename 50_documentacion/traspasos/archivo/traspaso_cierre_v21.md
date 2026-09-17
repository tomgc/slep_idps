# Traspaso de cierre v21 — slep_idps

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS nacional, React 18 + D3 v7 inline, GitHub Pages).
- **Versión traspaso:** v21.
- **Fecha:** 2026-06-24.
- **Sesión:** 21. Foco: **polígono GSE de referencia en el radar** (reapertura de la decisión "lee, no deriva" con fundamento de dato público) + afinación de textos + **retiro del overlay temporal del radar** + deploy + integración del cronológico al backlog (→133).
- **Entorno:** macOS aarch64, R 4.5.x, Positron, GitHub Pages (repo público).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (polígono GSE, textos, leyenda, retiro overlay temporal), `30_procesamiento/35_generar_motor_html.R` (campo `prom_gse` en payload + comentario cabecera), `docs/index.html` (deploy x2), `50_documentacion/activa/backlog_historico.md` (→133), nueva decisión `20260624_decision_poligono_gse_radar.md`.

---

## 2. Resumen ejecutivo

La sesión giró en torno a una decisión metodológica de fondo. Se descubrió que la Agencia publica en simce.cl el "Puntaje promedio nacional del mismo GSE" como cifra absoluta 0–100 (caso observado EE=74/GSE=74/dif=0), lo que desmontó el fundamento de la decisión `20260612_decision_ponderacion_idps.md` ("lee, no deriva"), que prohibía dibujar el GSE absoluto en el radar. Un diagnóstico read-only confirmó que `prom_GSE = prom − difgru` reconstruye la cifra publicada de forma EXACTA (signo fijado por `sign(difgru) × sigdifgru`, consistencia intra-grupo `sd=0`, sin riesgo de ±1 porque `prom` y `difgru` son enteros). Con eso se reabrió formalmente la decisión y se implementó el **polígono GSE de referencia** en el radar (solo nivel indicador, solo 2024–2025 donde hay dato, omitido si falta algún indicador para no dibujar parciales engañosos). Se reescribió el texto del bloque azul para describirlo, se eliminó una leyenda de significancia duplicada, y se afinaron dos textos que quedaron contradictorios. **Error de la sesión:** se dejó en el radar un overlay temporal (comparación año vs año) preexistente que el titular ya había indicado que pertenece a la vista histórica; se retiró en un fix posterior, dejando el radar con solo 2 trazos (EE + GSE). Todo desplegado y pusheado; backlog integrado de 119 a 133 (s20 lote directo + s21).

---

## 3. Estado al cierre

**Qué funciona (desplegado en producción, `docs/index.html` pusheado, `origin/main` = `41a3406`):**
- **Polígono GSE de referencia** en el radar de la ficha: trazo punteado gris `2 4` ("Promedio del mismo GSE"), reconstruido `prom_gse = prom_crudo − difgru`, solo nivel indicador, solo 2024–2025, omitido si algún indicador carece de dato (`.every`). Última verificación: panel adversarial 0 mismatch en 366.384 filas; caso 74/74/0 → GSE coincide con EE.
- **Radar con 2 trazos** (EE sólido azul + GSE punteado gris). El overlay temporal naranja fue retirado (commit `ff1e11f`, deploy `41a3406`).
- **Texto del bloque azul** reescrito (describe el polígono, la frase de la línea punteada condicionada a "cuando el establecimiento cuenta con un grupo de comparación").
- **Leyenda de significancia** única (la duplicada bajo el radar se eliminó).
- Motor renderiza sin errores de consola (solo warning benigno de Babel CDN).
- Fidelidad censal mismatch 0; parquet `idps_largo.parquet` md5 `4c764d8c…` intacto.
- Build de producción md5 `ea1283c3…` (= build local con el fix del overlay).

**Qué quedó documentado pero NO versionado (decisión del titular):**
- `resena_slep_idps.md` (untracked), `SETTINGS_Y_PROMPTS_OPERACIONALES.md` modificado en `activa/`, snapshots de `estructura/` rotados, `traspaso_cierre_v20.md` untracked, y los logs de `deploy_push_s21` y `quita_overlay_temporal_radar` (untracked). Ninguno es deuda funcional; son artefactos a versionar cuando el titular decida una limpieza.

**Delta respecto a v20:** polígono GSE en producción; overlay temporal retirado; backlog 119 → 133; decisión de ponderación reabierta y versionada; 6 commits de s20 (lote UI directo, antes sin desplegar) finalmente pusheados junto con todo lo de s21.

---

## 4. Registro detallado de cambios

**Diagnóstico read-only radar vs GSE** (`20260624_diagnostico_gse_reconstruccion_log.md`). Veredicto: el puntaje GSE absoluto no existe como columna; reconstruible exacto por `prom − difgru`. Signo fijado por cruce `sign(difgru) × sigdifgru` (alineación perfecta, cero fuera de diagonal). Consistencia intra-grupo `sd=0`. Cobertura solo 2024–2025 (~18% de filas-indicador). No es cambio de producto (análisis).

**Polígono GSE en el radar** (`4493bcf`). Generador: campo `prom_gse = round(prom_crudo − difgru, 0)` en el payload del indicador (NA si `difgru`/`cod_grupo` NA o fuera de 0–100). Template: tercer trazo en `Radar` (props `axesG/colG/labelG`), punteado `2 4` gris, rótulo "Promedio del mismo GSE" en leyenda + "Puntaje promedio nacional del mismo GSE" en tooltip. Se dibuja solo si los 4 indicadores tienen `prom_gse` (`hasGse = axIndG.every(...)`), para evitar polígonos parciales engañosos (~1.3% de casos). Decisión `20260624_decision_poligono_gse_radar.md`. Resuelve el pendiente "captura 2" de v20.

**Texto del bloque azul** (`11e7d62`, refinado en `a04b312`). Reemplazo del texto antiguo ("Una sola pantalla, todo desplegado…") por el texto nuevo que describe el polígono GSE y la significancia. Refinamiento posterior: la frase de la línea punteada se condicionó ("Cuando el establecimiento cuenta con un grupo de comparación (GSE), la línea punteada…") para no prometer un trazo que no aparece en EE sin GSE. Resuelve "3b".

**Leyenda duplicada eliminada** (`ef15f5e`). Se retiró la tira `pan-state-leg` de la ficha (swatches bajo el radar) que duplicaba la leyenda de significancia ahora en el bloque azul. Conservadas las de comparador y territorial (pantallas distintas). Resuelve "3a".

**Afinación de 2 textos contradictorios** (`c775d48`, `9a50088`). La nota `.nota-inv` ("no reconstruye el puntaje del GSE") y el comentario de cabecera del generador ("no se dibuja la linea absoluta del GSE") quedaron falsos con el polígono. Corregidos: la nota ahora distingue radar (sí GSE) de barras de dimensión (no GSE); el comentario cita la decisión 20260624. Coherencia derivada de la feature, no cambio independiente.

**Retiro del overlay temporal del radar** (`ff1e11f`). Ver §6 (es la corrección del error de la sesión). Se retiró el trazo punteado naranja `4 3` (comparación año vs año) y toda su maquinaria (`cmpA`/`cmpAgno`/`axIndB`/`aniosCD`/`cmpOpts`/selector/hint) y CSS exclusivo (`.cmp-label`, `.sw-line.cmp`, `.cmp-hint`, token `--cmp-year`). Las anclas y la vista histórica quedaron intactas (eran independientes del overlay). Radar final: 2 trazos.

**Lote UI directo de s20** (6 commits `92ec92b`…`eabf544`, pusheados en s21). Eran de s20, nunca desplegados; este cierre los integró al deploy. Detalle en v20 §4 y log `20260624_s21_lote_directo_log.md`.

**Deploys** (`80f4ba6` deploy mayor, `41a3406` deploy del fix overlay) + versionado de decisión (`95e3576`) y logs (`397117b`). Backlog integrado (`404c8b9`).

---

## 5. Backlog acumulativo

**Estado:** `backlog_historico.md` del repo integrado a **133** (commit `404c8b9`, pusheado). Antes estaba a 119 (s18/s19); este cierre integró s20 y s21 juntos.

- **s20 (#120–130, +11):** P-TIPOGRAFIA tokens (#120) + 10 ítems del lote UI directo (#121–130). Razonado en v20 §5.
- **s21 (#131–133, +3):** polígono GSE en el radar (#131, resuelve "captura 2"), texto del bloque azul (#132, "3b"), leyenda duplicada (#133, "3a").

**No contó** (nota metodológica del archivo): fix Bug s7-1 `.ancla` (bugfix de Claude Code, no del titular); ítem #19 (solo diagnóstico); afinación de textos s21 (refinamiento del #132); diagnósticos read-only (análisis); decisión versionada (justificación del #131); **retiro del overlay temporal (corrección de error propio, no solicitud distinguible);** consolidación recursiva + deploy/push (operativo).

**Los 4 totales cuadran en 133** (suma columna N° = correlativo #133 = fila Total = encabezado v21/133). Append-only verificado: solo se modificaron conteos/% y encabezados; cero entradas 1–119 del detalle tocadas.

**Observación de taxonomía (deuda, no se actuó):** la categoría "Visualización/diseño — rediseño UI" llegó a 29% (38/133), cruza el umbral del 25% que la política sugiere subdividir. NO se subdividió porque exigiría reclasificar entradas históricas (contra append-only/A37). Queda para una higiene de taxonomía dedicada.

---

## 6. Bugs y errores de la sesión

**Error propio — overlay temporal dejado en el radar.**
- **Síntoma:** tras implementar el polígono GSE, el radar mostraba TRES trazos: EE (sólido), GSE (punteado gris) y un overlay temporal (punteado naranja `4 3`, comparación año vs año). El titular nunca pidió la comparación temporal en el radar; ya había indicado que los años van en la vista histórica.
- **Causa raíz:** al montar el polígono GSE, el asistente trató el overlay temporal preexistente como parte fija del radar y no lo contrastó con la instrucción previa del titular ("la comparación entre años va en histórica"). El encargo del polígono incluso lo describía como referencia ("distinto del overlay temporal `4 3`"), asumiéndolo en vez de cuestionarlo. **Fallo: asumir el estado heredado como aprobado.**
- **Solución:** fix `ff1e11f` que retira el overlay temporal y su maquinaria exclusiva, dejando el radar con 2 trazos. Paso 0 de diagnóstico confirmó que la remoción era limpia (el overlay no alimentaba anclas ni vista histórica).
- **Verificación:** RBD 10 → radar con 2 trazos, 0 naranja; anclas intactas; vista histórica intacta (15 BarrasAnio + 15 marcas); payload byte-idéntico; consola limpia.
- **Patrón general aprendido (regla):** al construir sobre un elemento preexistente, no tratarlo como aprobado por estar ahí; contrastarlo contra las instrucciones del usuario antes de construir encima. Una instrucción previa manda sobre el estado del terreno. **Esta regla se formalizó como R10 en `DISCIPLINA_OPERATIVA.md`, `CLAUDE.md` y las custom instructions de Claude web** (entregadas en esta sesión; el titular las reemplaza en KB/repo/Settings).

**Nota operativa (no es bug del proyecto):** un bloque de encargo se pegó completo (con texto explicativo) en la terminal zsh y generó `no matches found` por los paréntesis. Lección: los comandos para terminal se pegan sin prosa alrededor.

---

## 7. Aprendizajes y restricciones descubiertas

- **El GSE absoluto SÍ es público y reconstruible.** La Agencia publica "Puntaje promedio nacional del mismo GSE" en simce.cl. `prom_GSE = prom − difgru` lo reconstruye exacto (signo: `difgru = prom_EE − prom_GSE`). El radar puede dibujarlo como referencia (decisión 20260624). Sigue siendo derivación, declarada como tal (reconstrucción sin pérdida de una cifra pública).
- **`difgru`/`cod_grupo` solo existen 2024–2025.** Cualquier feature que dependa del GSE tiene esa cobertura máxima. NA legítimo en 2014–2023 (no degradar a 0).
- **Polígono parcial es engañoso.** Un radar con 2-3 vértices y cierre `curveLinearClosed` confunde; mejor omitir (`.every`). El parcial es raro (~1.3%).
- **R10 (nueva barrera canónica):** no asumir el estado heredado como aprobado. El error de la sesión nace de aquí.
- **El reconstruir desde `prom` crudo (no el redondeado del payload)** elimina cualquier ±1 si la Agencia publicara decimales en el futuro; hoy el delta es 0 (dato entero).

---

## 8. Decisiones de diseño

- **Reapertura de "lee, no deriva" para el polígono GSE** (`20260624_decision_poligono_gse_radar.md`, versionada). Reabre `20260612_decision_ponderacion_idps.md`. Justificación: la cifra es pública y se reconstruye sin pérdida. Condiciones: reconstrucción cruda, omitir donde falta dato, solo indicador, rótulo de procedencia. El resto de "lee, no deriva" (sin agregación territorial, sin ponderación entre EE, significancia leída) sigue vigente.
- **Rótulo del trazo GSE:** "Promedio del mismo GSE" en leyenda, "Puntaje promedio nacional del mismo GSE" (denominación de la Agencia) en tooltip. Alternativas (rótulo completo en leyenda / "Mismo GSE" mínimo) descartadas por longitud/claridad.
- **Frase de la línea punteada condicionada** (no dinámica por EE, sino reformulación suave "Cuando el establecimiento cuenta con un grupo de comparación…"). Alternativas: incondicional (descartada, miente en EE sin GSE), texto dinámico por `hasGse` (descartada, complejidad). 
- **Polígono solo completo** (`.every`, no parcial). Alternativa: dibujar parcial siguiendo el patrón del overlay (descartada, trazo engañoso).
- **Comparación temporal vive en la vista histórica, no en el radar** (decisión del titular materializada en el fix `ff1e11f`).

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 parquet | `4c764d8c…` | `idps_largo.parquet` | invariante, intacto en s21 |
| `prom_gse` | `round(prom_crudo − difgru,0)` | `35_generar_motor_html.R` | **nuevo s21**, solo indicador, 2024–2025, NA si falta dato |
| `--fs-2xs` … `--fs-h1` | 11/12/13/14/16/18/22 px | `35_motor_template.html` | escala de 7 tokens (s20) |
| `MMOVIL_VENTANA` | 3 | `35_motor_template.html` | s19 |
| `MMOVIL_MIN_PUNTOS` | 4 | `35_motor_template.html` | s19 |
| `ANIOS_PANDEMIA` | 2020,2021 | `35_generar_motor_html.R` | huecos estructurales |
| tope comparador | 4 territorios | `35_motor_template.html` `maxSel={4}` | **a subir a 10 (#16/#17), pendiente** |

(`--cmp-year` **eliminado** en s21 con el retiro del overlay temporal.)

---

## 10. Arquitectura de archivos

Escáner de cierre: `50_documentacion/estructura/estructura_actual.md` (2026-06-24 14:41, 31 carpetas, 263 archivos). Sin cambios estructurales; el crecimiento son los logs de s21 (6 nuevos) y los snapshots rotados. Estructura conforme a la política.

Backlog `backlog_historico.md` ahora 33K (consolidado a 133). Nueva decisión en `activa/decisiones/`. Suite de documentación (`50_documentacion/suite/`) sigue **desactualizada** respecto a s20/s21 (no se regeneró esta sesión; pendiente).

**Registro de ejecución detallado:** logs en `50_documentacion/andamios/logs/` (`20260624_diagnostico_gse_reconstruccion_log.md`, `20260624_poligono_gse_texto_leyenda_log.md`, `20260624_afinacion_textos_gse_log.md`, `20260624_deploy_push_s21_log.md`, `20260624_quita_overlay_temporal_radar_log.md`, `20260624_s21_lote_directo_log.md`); detalle paso a paso no reproducido aquí.

---

## 11. Pendientes y ruta sugerida

### Inventario

**Batch A — Lote directo verificable (recomendado para abrir s22, sesión fresca):**
- **#12** leyenda de media móvil en histórico (ícono de línea antes de "vs 2024*"). Directo.
- **#16/#17** tope comparador 4→10 (`maxSel={4}`). ✅ ANTES: verificar que el layout de la matriz aguante 10. Verificable.
- **#22** subir sutilmente el alto de las barras. 🔒 Sin tocar escala de datos. Directo.
- **Higiene:** `# REVISAR jerarquía .axis-lab.b` (negrita del eje quedó igual de tamaño que la base, ambas 11px tras tipografía s20).

**Batch B — Requieren propuesta del asistente antes de encargar (no van directo a Claude Code):**
- **#7** textos de tarjeta más extensos (definición + qué hace el alto, desde `idps_corpus_conceptual.md`, en KB). Requiere redacción.
- **#9** color de dimensiones por puntaje (mismo tono, varía alto/bajo). 🔒 No colisionar con rampa de niveles P-PALETA-v2. Requiere propuesta.
- **#13** señalética sigdif en cada número del gráfico GSE. 🔒 Verificar disponibilidad de `sigdifgru` por celda antes de prometer. Requiere propuesta.
- **#18** etiquetas del comparador en segmentos angostos (enlazado al #19 ya diagnosticado: umbral de ancho, conteo en el `title` de hover). Requiere propuesta.
- **#23** nuevo color para "sin diferencia" (hoy gris). Requiere propuesta.

**Batch C — Convergente visual (por A19, requiere referencia aprobada + reverse-engineering, no encargo a ciegas):**
- **#5** tarjetas más anchas, anclas vs GSE/vs año en una línea (captura 1).
- **#8** nombre del radar más grande, sin superponerse a la tarjeta (captura 4).

**Batch D — Gobernanza:**
- **P-GITIGNORE-TOKEN:** acotar el patrón `*token*` del bloque de credenciales (demasiado amplio para un proyecto con tokens CSS), sin debilitar `*secret*`/`*password*`.

**Deuda de taxonomía:**
- Subdividir "rediseño UI" (29%, cruza el 25%); exige higiene del backlog respetando append-only.

**Documentación:**
- **Regenerar suite standalone** (desactualizada vs s20/s21). ✅ ANTES: verificar versión de `suitedoc` y firma de `generar_suite()` (¿`standalone=`?); requiere `npm` + red. BIBLIOTECA.

**Diferidos (sesión dedicada):**
- **Ítem 11** lista EE por segmento (repo hermano). 🔒 No reconstruir el componente de Simce Adecuado de memoria (A37).
- **P-SLEPVERSE** (estratégico).
- **IDPS histórico 2014–2019** (sesión de datos; extender `34_leer_normalizar_idps.R`, `PATRON_DATOS` solo soporta 2022–2025; inspeccionar un xlsx por época antes de tocar el pipeline).

### Auditoría de cierre (política 5.6)
- ¿Outputs reproducibles e idempotentes? Sí (build regenera idéntico salvo fecha; payload byte-idéntico en cambios de solo texto).
- ¿Decisiones metodológicas como constantes nombradas? Sí (`prom_gse` con fórmula explícita; decisión versionada).
- ¿Nombres sin tildes/ñ/espacios? Sí.

### Ruta sugerida para s22
1. **Batch A** (lote directo verificable: #12, #16/#17 con verificación de layout, #22, `.axis-lab.b`). Sesión fresca, sin decisión de diseño abierta.
2. Según tiempo: abrir **Batch B** redactando primero las propuestas (#7 con el corpus de la KB es el más autónomo).
3. **Diferir:** Batch C (convergente, requiere capturas de referencia), suite (sesión BIBLIOTECA propia), histórico y P-SLEPVERSE (sesiones dedicadas).

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 Parquet intocable (md5 `4c764d8c…`); fidelidad censal mismatch = 0 (excluir fantasma rbd=NA antes de declararla).
- 🔒 **GSE absoluto SÍ se dibuja en el radar** (polígono de referencia, `prom − difgru`, solo indicador, solo donde hay `difgru`/`cod_grupo`), por decisión `20260624_decision_poligono_gse_radar.md`. La significancia se sigue leyendo (`difgru`/`sigdifgru`), no se recalcula. Las barras de dimensión/subdimensión NO muestran GSE (no hay dato a ese nivel).
- 🔒 **El radar NO lleva comparación temporal** (año vs año). Esa comparación vive en la vista histórica. El overlay temporal fue retirado en s21; no reintroducirlo.
- 🔒 Polígono GSE solo completo (`.every`), nunca parcial.
- 🔒 `BarrasAnio` escala fija 0–100; `EntityModal` modo simple intacto (al subir tope a 10, no romper modo simple).
- 🔒 Bug s7-1: ningún comentario CSS contiene `*/` salvo cierre real.
- ✅ ANTES de tocar `35_motor_template.html`, releer las zonas (las líneas se movieron mucho en s21).
- ✅ ANTES de subir el tope del comparador a 10 (#16/#17), verificar que el layout de la matriz aguante.
- ✅ ANTES de regenerar la suite, verificar versión de `suitedoc` y firma de `generar_suite()`.
- ⚠️ Evitar "token" en nombres de archivos del repo hasta acotar `*token*` en `.gitignore` (P-GITIGNORE-TOKEN).
- ⚠️ Comandos para terminal se pegan SIN prosa alrededor (zsh rompe con paréntesis).
- 🆕 **R10 vigente:** no asumir el estado heredado como aprobado; contrastar lo preexistente contra las instrucciones del usuario antes de construir encima. (Formalizada en DISCIPLINA_OPERATIVA.md / CLAUDE.md / custom instructions; el titular las reemplaza en KB/repo/Settings.)

---

## 13. Fragmentos de referencia

```r
# Reconstruccion del puntaje GSE (s21), en el payload del indicador
# (35_generar_motor_html.R): usar prom CRUDO, no el redondeado de presentacion.
prom_gse = ifelse(!is.na(difgru) & !is.na(cod_grupo),
                  round(prom_crudo - difgru, 0),
                  NA_real_)
# Signo confirmado: difgru = prom_EE - prom_GSE  =>  prom_GSE = prom - difgru.
```

```
# Radar de la ficha: SOLO 2 trazos. EE solido (axes) + GSE punteado 2 4 (axesG).
# NO reintroducir el overlay temporal (axesB / --cmp-year): los anios van en
# la vista historica. Poligono GSE solo si hasGse = axIndG.every(v => v != null).
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 22 (Opus 4.8)`
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md + DISCIPLINA_OPERATIVA.md) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v21, el escáner y el backlog histórico (a 133). Foco propuesto: Batch A (lote directo verificable: #12 leyenda media móvil, #16/#17 tope comparador 4→10 con verificación de layout, #22 alto de barras, higiene `.axis-lab.b`)."
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar al día):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `DISCIPLINA_OPERATIVA.md`.
  2. *Opcionales según foco:* `encargo_autonomo_claude_code_v1.md` (si los UI van por encargo autónomo); `idps_corpus_conceptual.md` (en KB, si se aborda #7); §4.6 de SETTINGS (si se regenera la suite).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v21.md`; `estructura_actual.md`; `backlog_historico.md`; el `35_motor_template.html` (se movió mucho en s21) si la tarea lo toca.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más reciente al abrir y avisarlo. El `backlog_historico.md` del repo está a 133 (consolidado en s21). Las custom instructions / CLAUDE.md / DISCIPLINA_OPERATIVA.md ganaron R10 en s21: confirmar que la versión vigente en KB/repo/Settings ya la incluye.
