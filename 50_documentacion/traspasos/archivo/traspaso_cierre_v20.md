# Traspaso de cierre v20 — slep_idps

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS nacional, React 18 + D3 v7 inline, GitHub Pages).
- **Versión traspaso:** v20.
- **Fecha:** 2026-06-24.
- **Sesión:** 20. Foco: **P-TIPOGRAFIA (Ítem 4)** + saneamiento de backlog s18/s19 + **lote UI/UX directo** (11 ítems de presentación) + fix del Bug s7-1 (.ancla) encontrado de paso.
- **Entorno:** macOS aarch64, R 4.5.x, Positron, GitHub Pages (repo público).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (tipografía + lote UI + fix .ancla); `50_documentacion/activa/backlog_historico.md` (consolidación s18/s19); `docs/index.html` (deploy de tipografía + fix .ancla).

> **Nota de etiqueta:** un log de esta sesión quedó nombrado `20260624_s21_lote_directo_log.md` (dice "s21"), pero su contenido pertenece a **s20**. No es un cierre intermedio; toda esta sesión es s20. La numeración de traspasos va v19 → v20 sin saltos.

---

## 2. Resumen ejecutivo

La sesión cerró tres frentes. (a) **Saneamiento de backlog:** se consolidó el detalle cronológico de s18 (documental, 0 cambios) y s19 (9 ítems UI/UX), llevando el correlativo de 110 a **119** y cerrando la deuda P-BACKLOG-INTEGRIDAD (tabla temática = correlativo); incluyó recálculo de la columna % sobre 119. (b) **P-TIPOGRAFIA (Ítem 4):** se reemplazó la escala de facto (19 valores de font-size) por **7 tokens `--fs-*`** (piso 11px, cuerpo 14px), tokenizando ~88 declaraciones; de paso se encontró y corrigió el **Bug s7-1 en `.ancla`** (comentario CSS con `*/` prematuro que descartaba la regla del CSSOM desde el commit `00e567d`). Tipografía + fix .ancla se **desplegaron** (docs/ actualizado, pusheado). (c) **Lote UI/UX directo:** 11 ítems de presentación (#2,#3,#4,#6,#10,#11,#14,#15,#19,#20,#21) en 6 commits **locales sin push**, build local regenerado, **pendiente de revisión visual del titular y deploy**. El bug #19 resultó ser umbral de ancho (no de datos), solo diagnóstico. Quedó **lanzado un diagnóstico read-only** a Claude Code sobre si el dato permite dibujar el GSE como polígono en el radar (su veredicto es el primer insumo de s21).

---

## 3. Estado al cierre

**Qué funciona (desplegado en producción, docs/ pusheado):**
- Escala tipográfica tokenizada (7 tokens) y `.ancla` restaurada. Última ejecución exitosa: deploy `d293945` + logs; commit de cierre del log renombrado `3e3ef96`. Build de producción == build local de tipografía (md5 `0699503d…`).
- Motor renderiza sin errores de consola (solo warning benigno de Babel CDN).
- Fidelidad censal mismatch 0; parquet `idps_largo.parquet` md5 `4c764d8c…` intacto.

**Qué está hecho pero NO desplegado (local, esperando gate visual):**
- **Lote UI/UX directo:** 6 commits locales sin push (`92ec92b`, `a1226d8`, `10c1c0a`, `a6971a6`, `de142c0`, `eabf544`). Build local `40_salidas/motor_idps.html` (md5 `22fb775c…`) regenerado con los 11 ítems; `docs/index.html` sigue siendo el de tipografía (`0699503d…`), correcto. **Falta:** revisión visual del titular → deploy → push.

**Qué está en vuelo:**
- **Diagnóstico read-only del radar vs GSE** lanzado a Claude Code (¿existe puntaje GSE absoluto por indicador en el dato, o solo `difgru`?). Veredicto NO recibido al cierre. Es el primer insumo de s21.

**Delta respecto a v19:** correlativo de backlog 110 → 119 (consolidación s18/s19) y +11 cambios de s20 pendientes de integrar (→ 130, ver §5). Tipografía + fix .ancla en producción. Lote UI local sin desplegar.

---

## 4. Registro detallado de cambios

**P0 — Consolidación de backlog s18+s19** (`8176245`→`d293945` enmendado). Integró el cronológico de s18 (0 cambios, documental, por criterio explícito de v18) y s19 (9 ítems UI/UX, #111–119). Cerró P-BACKLOG-INTEGRIDAD (tabla = correlativo = 119). Recálculo de columna % sobre 119 (11 filas). Entradas 1–110 byte-idénticas. Verificado: 4 totales cuadran en 119. Log: `20260623_consolidacion_backlog_s18_s19_log.md`.

**P1 Fase 1 — Redefinir tokens tipográficos** (`bd65261`). 7 tokens `--fs-*` en :root (`--fs-2xs:11` … `--fs-h1:22`); eliminados `--fs-display` (muerto) y `--fs-h2` (absorbido a `--fs-lg`; `.modal-title` repuntado).

**P1 Fase 2 — Migrar font-size crudos a tokens** (`dff5874`). ~88 declaraciones migradas (80 CSS + 6 inline JSX + 2 D3 `.attr`→`.style`). Mapeo por rol+cercanía. Piso 9/9.5/10/10.5 → 11px. Hallazgo: 2 font-size de D3 (`.attr("font-size")`) que el inventario no vio; convertidos a `.style` para que `var()` resuelva.

**Fix Bug s7-1 .ancla** (`e9b9885`). Comentario CSS `.ar-*/.anclas` → `.ar-N/.anclas` (elimina el `*/` prematuro). Restaura `.ancla` al CSSOM con su píldora y el token de tamaño efectivo. Causa raíz pre-existente desde `00e567d`. Log: `20260623_fix_ancla_s7_1_log.md`.

**Deploy tipografía + fix** (`3925e84` deploy, `5538e2c` logs, `3e3ef96` log renombrado). docs/ actualizado; logs versionados. El log de tipografía se renombró `…_tipografia_tokens_log.md` → `…_tipografia_escala_log.md` por colisión con el patrón `*token*` de `.gitignore` (bloque credenciales).

**Lote UI/UX directo** (6 commits locales, ver §3). Detalle por ítem en §3 del log `20260624_s21_lote_directo_log.md`. Resumen: #2 elimina leyenda redundante de indicadores (estaba en Panorama territorial, no bajo el radar); #3 comunas por SLEP en tercera línea (alfabético, "A, B, C y D", solo SLEP); #4 "establecimientos en el nivel seleccionado"; #6 nombre completo en tarjetas rcard; #10 definición estática (negrita, color del indicador, sin toggle); #11 recorta leyenda a "el tono lo da cada indicador."; #14 texto del `*` preliminar unificado; #15 texto de significancia unificado; #19 diagnóstico (sin cambio); #20 nombre completo en th del comparador (wrap); #21 "Territorio" a la derecha.

---

## 5. Backlog acumulativo

**Estado:** el archivo `backlog_historico.md` del repo está consolidado a **v19/119** (Claude Code lo cerró en esta sesión, P0). El detalle cronológico de **s20 NO está integrado aún** (igual que ocurrió con s18/s19 en su momento).

**Delta de s20 a integrar (primer micro-encargo de s21):**
- **Conteo razonado (por intención primaria del titular):**
  - Escala tipográfica tokenizada (P-TIPOGRAFIA, Ítem 4) → **1 cambio** (#120).
  - Lote UI directo: 10 ítems con cambio de código (#2,#3,#4,#6,#10,#11,#14,#15,#20,#21) → **10 cambios** (#121–130). El **#19** fue solo diagnóstico (sin cambio) → no suma.
  - **Fix Bug s7-1 .ancla:** bugfix encontrado por Claude Code, no reportado por el titular → **no suma** al correlativo (nota metodológica); va como bug de la sesión (§6).
  - P0 (consolidación del cronológico): trabajo recursivo sobre el backlog → no suma (criterio v18).
- **Total: 119 → 130** (11 entradas nuevas).
- **Categoría dominante de las 11:** Visualización/diseño rediseño UI (la mayoría del lote) + 1 de tipografía (Limpieza/deuda técnica o Visualización según taxonomía).
- **La numeración real la fija Claude Code** contra el archivo del repo (119) y los logs de s20, NO de memoria. El traspaso especifica el delta; la integración se ejecuta como primer paso de s21.

---

## 6. Bugs de la sesión

**Bug s7-1 (recurrente) — `.ancla` descartada del CSSOM.**
- **Síntoma:** las anclas "vs su GSE"/"vs año anterior" perdían su píldora (padding/flex) y heredaban 14px en vez de su token.
- **Causa raíz:** comentario CSS con la secuencia `.ar-*/.anclas`; el `*/` cerraba el comentario prematuramente y fusionaba la cola con la regla `.ancla{}`, invalidándola. Pre-existente desde `00e567d`.
- **Solución:** reescribir el fragmento del comentario para eliminar `*/` interno (`.ar-*` → `.ar-N`). Commit `e9b9885`.
- **Verificación:** `.ancla` de vuelta en el CSSOM con píldora y font-size 12px; balance de comentarios 64/64; cero `*/` mid-texto restante.
- **Patrón general aprendido (regla):** ningún comentario CSS puede contener la secuencia `*/` salvo como cierre real. Un CSSOM-drop silencioso puede esconder una regla rota por sesiones sin que se note visualmente; verificar reglas en el CSSOM, no solo en fuente. **Este es el segundo episodio del Bug s7-1; vigilarlo activamente al escribir comentarios CSS.**

---

## 7. Aprendizajes y restricciones descubiertas

- **`.gitignore` `*token*` muerde archivos legítimos.** El patrón del bloque de credenciales (`*token*`, junto a `*secret*`/`*password*`) bloqueó un log con "tokens" (tipográficos) en el nombre. **Regla:** evitar "token" en nombres de archivos del repo hasta acotar el patrón; ante colisión, renombrar (no `git add -f`, que perfora la protección). Pendiente estructural: P-GITIGNORE-TOKEN (§11).
- **El inventario por sintaxis puede dejar fuera casos.** El inventario de font-size buscó `font-size:` y omitió 2 usos de D3 `.attr("font-size")`. **Regla:** al censar una propiedad, contemplar todas sus sintaxis (CSS, inline JSX, atributos SVG de D3). Un atributo SVG `font-size` no resuelve `var()`; requiere `.style()`.
- **Generar suite ya existente = actualizar.** Cuando `50_documentacion/suite/` ya tiene los `*_standalone.html`, "generar documentación" significa **regenerar con los cambios acumulados**, no crear de cero ni preguntar si es nueva. Los proyectos cambian y la suite se actualiza múltiples veces. (Instrucción del titular, s20.)
- **El radar compara vs año, no vs GSE (decisión vigente).** `20260612_decision_ponderacion_idps.md`: el GSE se lee de `difgru/sigdifgru` como marca de desvío, NUNCA como línea/puntaje GSE absoluto dibujado ("lee, no deriva"). Cualquier petición de "línea punteada = GSE" en el radar contradice esta decisión y requiere reabrirla con fundamento de dato (de ahí el diagnóstico en vuelo).

---

## 8. Decisiones de diseño

- **Escala tipográfica de 7 tokens, piso 11px.** Alternativas: piso 12px (descartado, apretaba ejes D3 densos); escala acotada solo al piso (descartado, dejaba 85 px crudos vivos). Justificación: una escala única cierra la tokenización a medias; mapeo por rol+cercanía preserva jerarquía relativa. Implicancia: `--fs-display`/`--fs-h2` eliminados; clamp() del hero intactos.
- **Fix .ancla por reescritura, no por espacio.** Alternativa: insertar espacio antes de `/` (descartada, deja `/` suelto frágil). Se eliminó el `*` (`.ar-*`→`.ar-N`): el `*/` no puede reaparecer.
- **Comunas por SLEP en tercera línea, no inline.** Alternativa: inline en la tira `pan-meta` (descartada, alarga en SLEPs grandes). Tres líneas: nombre / comunas / meta. Solo para `terr.kind` foco|slep.
- **Definición estática en color del indicador.** El "¿Qué mide este indicador?" pasa de toggle colapsable a texto fijo, negrita, color `ind.color`, definición siempre visible.
- **#19 no se "arregla" subiendo el umbral.** El umbral `s.p>=16` para mostrar "(n)" es de ancho deliberado; el conteo ya está en el `title` de hover. La solución visual (etiqueta en segmentos angostos) es el ítem #18, pendiente.

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 parquet | `4c764d8c…` | `idps_largo.parquet` | invariante, intacto en s20 |
| `--fs-2xs` … `--fs-h1` | 11/12/13/14/16/18/22 px | `35_motor_template.html` | **nuevos s20**, escala de 7 tokens |
| `MMOVIL_VENTANA` | 3 | `35_motor_template.html` | s19 |
| `MMOVIL_MIN_PUNTOS` | 4 | `35_motor_template.html` | s19 |
| `ANIOS_PANDEMIA` | 2020,2021 | `35_generar_motor_html.R` | huecos estructurales |
| tope comparador | 4 territorios | `35_motor_template.html` L1531 `maxSel={4}` | **a subir a 10 (#16/#17), pendiente** |
| `--azul` | `#0A3A5C` | template (tokens) | botón agregar |
| `--foco` | `#0062A0` | template (tokens) | hover |

(`--fs-display` y `--fs-h2`: **eliminados** en s20.)

---

## 10. Arquitectura de archivos

Escáner de cierre: `50_documentacion/estructura/estructura_actual.md` (2026-06-24 10:02, 31 carpetas, 255 archivos). Sin cambios estructurales; el crecimiento son los logs de s20 y los snapshots rotados. Estructura conforme a la política.

**Suite de documentación ya existe** (`50_documentacion/suite/`): 4 `*_standalone.html`, `documentar.R` (40.9K), `suite_estilos.css`, `fonts/`, `assets/`. **Está desactualizada respecto a los cambios de s20** (tipografía, lote UI) → regenerar en s21 (prioridad del titular).

**Registro de ejecución detallado:** logs en `50_documentacion/andamios/logs/` (`20260623_consolidacion_backlog_s18_s19_log.md`, `20260623_fix_ancla_s7_1_log.md`, `20260623_tipografia_escala_log.md`, `20260624_s21_lote_directo_log.md`); detalle paso a paso no reproducido aquí.

---

## 11. Pendientes y ruta sugerida

### Inventario

**PRIORIDAD ALTA s21:**

1. **Veredicto del diagnóstico radar vs GSE** (en vuelo). Tipo: decisión de gobernanza metodológica. Contexto: ¿el parquet tiene puntaje GSE absoluto por indicador o solo `difgru`? Si existe → reabrir `20260612_decision_ponderacion_idps.md` con fundamento; si no → ajustar el texto nuevo de captura 3b al comportamiento temporal real. Criterio de éxito: decisión tomada con el dato a la vista, no de memoria.
2. **Integrar cronológico de s20 al backlog** (delta en §5). Tipo: documental. Primer micro-encargo, mismo patrón que s18/s19. Criterio: 4 totales cuadran en 130; entradas 1–119 intactas.
3. **Deploy del lote UI directo** (6 commits locales). Tipo: deploy pendiente de gate visual. Criterio: revisión visual del titular → docs/ == build local → push.
4. **Regenerar suite de documentación standalone** (actualización, no creación). Tipo: BIBLIOTECA. **ANTES:** verificar versión instalada de `suitedoc` y firma real de `generar_suite()` (¿expone `standalone=`?); requiere `npm` + red en generación. Criterio: 4 `*_standalone.html` regenerados, 0 referencias de red, validación de iconos OK.

**UI/UX pedidos en s20, sin ejecutar (de la tanda de 25 + nuevos de hoy):**
- **#5** tarjetas más anchas, anclas vs GSE/vs año en una línea (captura 1). Convergente.
- **#7** textos de tarjeta más extensos (definición + qué hace el alto, desde `idps_corpus_conceptual.md`). Requiere redacción del asistente.
- **#8** nombre del radar más grande, sin superponerse a la tarjeta (captura 4). Convergente.
- **#9** color de dimensiones por puntaje (mismo tono, varía por alto/bajo). Requiere propuesta del asistente. 🔒 No colisionar con la rampa de niveles (P-PALETA-v2).
- **#12** leyenda de media móvil en histórico (ícono de línea antes del "vs 2024*").
- **#13** señalética sigdif en cada número del gráfico GSE (captura 13). 🔒 Sujeto a disponibilidad del dato `sigdifgru` por celda; verificar antes de prometer.
- **#16/#17** tope comparador 4→10 (`maxSel={4}` L1531). Verificar que el layout de la matriz aguante 10 antes de fijar.
- **#18** etiquetas del comparador que no caben en segmentos angostos (enlazado a #19; el conteo ya está en el title de hover como provisional). Requiere propuesta.
- **#22** subir sutilmente el alto de las barras. 🔒 Sin tocar escala de datos.
- **#23** nuevo color para "sin diferencia" (hoy gris, no convence). Requiere propuesta.
- **Nuevos de hoy:** **3a** leyenda de significancia duplicada en la ficha (L1127 cierre del bloque azul + L1128 tira `pan-state-leg`; eliminar una); **3b** reescritura del texto del bloque azul (texto nuevo provisto, atado al veredicto del radar); **captura 2** radar vs GSE (atado al veredicto).

**Deuda menor viva:**
- `# REVISAR jerarquía .axis-lab.b` (la negrita del eje quedó igual de tamaño que la base, ambas 11px tras tipografía).
- CSS muerto `.leg-item`/`.leg-info` + `showTTEl` huérfanos tras eliminar la leyenda #2.
- **P-GITIGNORE-TOKEN:** acotar el patrón `*token*` del bloque de credenciales (demasiado amplio para un proyecto con tokens CSS), sin debilitar la protección de secretos reales.

### Evaluación de deuda técnica
Zona frágil: comentarios CSS en `35_motor_template.html` (Bug s7-1 reincidente). Oportunidad: una pasada de higiene que elimine CSS muerto y revise comentarios con `*/`.

### Auditoría de cierre (política 5.6)
- ¿Outputs reproducibles e idempotentes? Sí (build regenera idéntico salvo fecha).
- ¿Decisiones metodológicas como constantes nombradas? Sí (tokens `--fs-*`).
- ¿Nombres sin tildes/ñ/espacios? Sí; corregida la colisión `*token*` por renombrado.

### Ruta sugerida para s21
1. Recibir el veredicto del radar y decidir (a)/(b) sobre captura 2 + texto 3b.
2. Integrar cronológico s20 al backlog (130).
3. Revisión visual + deploy del lote UI directo.
4. Regenerar suite standalone (verificar `suitedoc` primero).
5. Abordar bloque UI convergente (#5, #8, #3a) y propuestas (#7, #9, #13, #18, #23) por tramos.
**Diferir:** Ítem 11 (lista EE por segmento, repo hermano) y P-SLEPVERSE (sesión dedicada).

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 Parquet intocable (md5 `4c764d8c…`); fidelidad censal mismatch = 0 siempre.
- 🔒 GSE solo a nivel indicador; no inyectar donde es NA. El GSE NO se dibuja como línea absoluta en el radar (`20260612_decision_ponderacion_idps.md`, "lee, no deriva") salvo que el diagnóstico en vuelo lo habilite y se reabra la decisión.
- 🔒 Escala `BarrasAnio` fija 0–100; media móvil y track en esa escala.
- 🔒 `EntityModal` modo simple intacto; multiselección opt-in (al subir el tope a 10, no romper el modo simple).
- 🔒 **Bug s7-1:** ningún comentario CSS contiene `*/` salvo como cierre real. Segundo episodio ya ocurrido; vigilar.
- ✅ ANTES de tocar `35_motor_template.html`, releer las zonas (las líneas se mueven cada sesión; la tipografía y el lote UI las movieron de nuevo).
- ✅ ANTES de declarar fidelidad, excluir el fantasma rbd=NA (4 filas en indicador).
- ✅ ANTES de generar la suite, verificar versión de `suitedoc` y firma de `generar_suite()`.
- ⚠️ "Generar documentación" con suite ya existente = REGENERAR/actualizar, no crear de cero ni preguntar.
- ⚠️ Evitar "token" en nombres de archivos del repo hasta acotar `*token*` en `.gitignore`.
- ⚠️ NO `git add -f` sobre patrones del bloque de credenciales; renombrar el archivo.
- ⚠️ NO reconstruir el componente de Simce Adecuado de memoria para el Ítem 11 (A37).
- 🔒 Lote UI directo: 6 commits locales SIN PUSH (`92ec92b`, `a1226d8`, `10c1c0a`, `a6971a6`, `de142c0`, `eabf544`); NO desplegar sin revisión visual del titular.

---

## 13. Fragmentos de referencia

```
# Escala de tokens tipográficos (s20), en :root de 35_motor_template.html:
--fs-2xs:11px; --fs-xs:12px; --fs-sm:13px; --fs-base:14px;
--fs-md:16px; --fs-lg:18px; --fs-h1:22px;
# (--fs-display y --fs-h2 ELIMINADOS)

# Regla CSS: jamás la secuencia de cierre de comentario dentro del texto.
# Mal:  /* clases .ar-*/.anclas ... */   (el */ cierra antes)
# Bien: /* clases .ar-N/.anclas ... */
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 21 (Opus 4.8)`
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v20, el escáner y el backlog histórico. Primer insumo: el veredicto del diagnóstico read-only del radar vs GSE que Claude Code dejó corriendo al cierre de s20. Prioridades: (1) decidir captura 2 + texto 3b según el veredicto; (2) integrar cronológico s20 al backlog (→130); (3) revisión visual + deploy del lote UI directo (6 commits locales); (4) regenerar la suite de documentación standalone (actualización)."
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar al día):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `encargo_autonomo_claude_code_v1.md` (si los UI van por encargo autónomo); `SETTINGS_Y_PROMPTS_OPERACIONALES.md` §4.6 (protocolo `suitedoc`, para la regeneración de la suite); `auditoria_codigo_proyecto_md_v1.md` (si hay auditoría de cifras).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v20.md`; `estructura_actual.md`; `backlog_historico.md`; el **veredicto del diagnóstico del radar** (output de Claude Code) cuando se reabra el chat; el **template `35_motor_template.html`** (lo movieron tipografía + lote UI); `idps_corpus_conceptual.md` si se aborda #7 (ya está en la knowledge base).
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión más reciente al abrir y avisarlo. El `backlog_historico.md` del repo está a 119; s20 (→130) se integra como primer paso de s21.
