# Traspaso de cierre — slep_idps — v26

**Proyecto:** slep_idps (motor IDPS nacional, React 18 + D3 v7 inline, GitHub Pages)
**Versión:** v26
**Fecha:** 2026-07-02
**Sesión:** 26 — higiene de bajo riesgo (pendientes de s25) + tooltip histórico contextual + migración tipográfica + suite de cobertura histórica.
**Entorno:** R 4.5.x, Positron (macOS aarch64); Claude Code para terminal/git; Claude web para análisis y encargos.
**Modelo:** Sonnet 5.
**Archivos principales modificados:** `50_documentacion/suite/documentar.R`, `50_documentacion/activa/backlog_acumulativo.md`, `30_procesamiento/35_motor_template.html`, `30_procesamiento/35_generar_motor_html.R`, `40_salidas/motor_idps.html`, `docs/index.html`.

---

## 1. Resumen ejecutivo

Sesión que saldó los tres pendientes de bajo riesgo que s25 dejó abiertos (`# REVISAR (voz)`, CSS muerto `.hist-leg`, higiene del backlog) y luego avanzó tres frentes adicionales acordados en curso: un tooltip histórico contextual por año y grado (motivo del hueco 2019 distinto para 4° básico y 2° medio, con tildes completas verificadas a nivel byte), la migración de la escala tipográfica a variables `--fs-*` nombradas (patrón `slep_*`, piso 12px, dos overrides resueltos por rol), y la regeneración de la suite de documentación (`documentar.R`) para reflejar la cobertura histórica real y el motivo de sus huecos (decisión D8), con fuente verificada contra `20260625_decision_cobertura_historico_idps.md`. Se revisó también el pendiente "doble lectura del glifo" y se cerró sin cambio: el render real ya rotula ambas comparaciones (temporal y vs GSE) sin ambigüedad. Seis commits de código publicados y desplegados donde correspondía (el CSS muerto y el tooltip fueron a producción; la suite no se despliega, por diseño). Working tree limpio salvo dos ediciones manuales del titular en `POLITICA_PROYECTO.md` y `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, no relacionadas con esta sesión. `origin/main = 24618db` tras el último commit de la suite (sin push aún de ese commit específico, ver §2). Parquet intacto en todos los tramos (`4c764d8c9f0bf70004f8aa52661ae901`).

---

## 2. Estado al cierre

**Qué funciona:**
- Motor en producción con: CSS muerto eliminado, tooltip histórico contextual (`b98bc2a`), migración tipográfica (`96b5d3c`). Última verificación: `cmp` build vs `docs/` byte-idéntico en los tres deploys de la sesión.
- Suite de documentación (`documentar.R`) regenerada con D8 (cobertura histórica) + FAQ/garantías/notas afinadas; 4 HTML standalone verificados offline, 0 marcadores REVISAR. Los HTML no se versionan (gitignorados por política del repo, `.gitignore` L48-53); solo `documentar.R` se commiteó.
- `backlog_acumulativo.md` (renombrado desde `backlog_historico.md` en `708572a`, fuera de esta sesión) consolidado a v25/147 con vista analítica de "Rediseño UI" (sub-tabla no-correlativa, suma 50).
- `ESTADO.md` (Fase 2) existe pero está desactualizado (referencia v25 / 2026-06-25); este traspaso lo destila al cierre.

**Qué no funciona / pendiente:** nada roto. Ver §11.

**Delta respecto a v25:**
- `origin/main`: `9416b14` (cierre v25) → `24618db` (HEAD local tras esta sesión). El commit `24618db` (suite D8) está en HEAD local; confirmar en §12 si ya se empujó.
- Backlog: sin cambio de correlativo en esta sesión (v25/147 se mantiene; s26 no aportó entradas de producto nuevas — ver nota metodológica del backlog).
- 8 commits nuevos de código/documentación (detalle en §4), más 2 commits de higiene externos a esta sesión (`4b7cdd3` ESTADO.md, `708572a` renombrado backlog) que aparecen en el rango pero no fueron generados en esta continuación.

---

## 3. Registro detallado de cambios

### 3.1 Cierre de `# REVISAR (voz)` en `documentar.R` (`7d50568`)
- **Categoría:** Documentación / limpieza.
- **Qué:** eliminados los dos comentarios marcadores de prosa pendiente de revisión (L316, L375 en la versión pre-sesión); el contenido que documentaban ya cumplía el estándar de voz (4.6.3.6) y no requería reescritura.
- **Por qué (C.11):** pendiente explícito en la lista del titular, heredado de s25; riesgo nulo (comentarios R, no afectan el HTML generado).
- **Cómo se verificó (B.4):** `grep -c "REVISAR (voz)"` 3→1 (la ocurrencia restante es la nota de cabecera del patrón, correcta).

### 3.2 P-CSS-HIST-LEG: eliminación de CSS muerto (`805d652` + deploy `9416b14`)
- **Categoría:** Limpieza / deuda técnica.
- **Qué:** eliminada la regla `.hist-leg` (sin selector vivo tras la reubicación de la leyenda de media móvil en s25); `.sw-line.mm` (regla contigua, sí en uso) intacta.
- **Por qué:** mismo patrón que P-CSS-MUERTO (s24).
- **Cómo se verificó:** un solo hit de `hist-leg` pre-cambio (la propia regla); 0 post-cambio en template y build; payload JSON byte-idéntico salvo fecha (cero cifras tocadas); parquet intacto. Desplegado tras gate visual (cambio sin efecto de render).

### 3.3 Higiene del backlog: consolidación v25/147 + vista analítica (`6cb3794`)
- **Categoría:** Limpieza / deuda técnica (memoria de largo plazo).
- **Qué:** consolidada la delta v25 (3 entradas nuevas, #145–147, todas "Rediseño UI": valor de media móvil, vs GSE en tooltip, señalética `·`) sobre un maestro que ya estaba en v23/144 (s24 no aportó entradas — administrativa, DEC-s24-1). Categoría "Rediseño UI" 47→50 (34% sobre 147). Añadida una sub-tabla analítica no-correlativa que desglosa esas 50 entradas en 5 sub-temas (ficha/radar, vista histórica, comparador, tipografía, texto/leyenda), cerrando la observación de umbral abierta desde v21/v23/v24 sin violar append-only.
- **Por qué (C.11):** A22 (conteos contra detalle cronológico); decisión de diseño registrada en el chat: subdivisión retroactiva como vista analítica (opción 2) en vez de reclasificación real, para no tocar el correlativo histórico.
- **Cómo se verificó (B.4):** cuadre de los cuatro totales = 147 (suma columna N°, correlativo global, fila Total, encabezado); sub-tabla suma 50; diff confirma append-only (solo 4 líneas de agregado recalculado, ninguna entrada histórica 1–144 tocada).

### 3.4 Tooltip histórico contextual por año y grado (`301d11a` + fix tildes `260bb7f` + deploy `b98bc2a`)
- **Categoría:** Funcionalidad / mejora visual.
- **Qué:** el motivo del hueco en la vista histórica (antes genérico por estado: "pandemia" / "no se evaluó") ahora es contextual, decidido server-side (`35_generar_motor_html.R`, plan B: el motivo viaja en el payload, el JS solo lo pinta). Cuatro constantes: pandemia (2020-2021, igual para todos los grados), 2019/4° básico (aplicación alterada), 2019/2° medio (no se aplicó), no_eval genérico (fallback). Solo cubre 4b/2m (separación de capas s25; el motor no expone 6b/8b).
- **Por qué:** pendiente explícito de s25 (§11); la fuente ya declaraba en comentario "el motivo del vacío se decide AQUÍ, no en el JS" — el cambio completa esa arquitectura.
- **Cómo se verificó (B.4):** parquet intacto; payload sin el campo `motivo` (y sin fecha) idéntico al baseline (cero cifras tocadas); auto-auditoría DOM real con dos establecimientos (RBD 1692 para 4b, Liceo Atenea RBD 134 para 2m) confirmando 4b≠2m en 2019 y pandemia en 2020/2021; verificación de tildes a nivel byte crudo del payload descomprimido (`c3 b3`=ó, `c2 b0`=°, `c3 a1`=á en posición), tras detectar que las constantes iniciales quedaron con acentuación parcial (fix en `260bb7f`).
- **Aprendizaje:** verificar texto acentuado en payloads gzipped/base64 requiere descomprimir y leer bytes crudos (`od -An -tx1`); `grep`/`cat` sobre archivos intermedios escritos por R en locale-C dan falsos negativos, y `grep -P`/`xxd -p` tienen quirks en macOS (BSD). El método fiable es el volcado de bytes crudos del payload binario, no de un archivo intermedio re-escrito por R.

### 3.5 Migración de escala tipográfica a variables `--fs-*` (`57e10f1` + deploy `96b5d3c`)
- **Categoría:** Rediseño UI / mejora visual.
- **Qué:** los 7 tokens ad-hoc existentes (`--fs-2xs/xs/sm/base/md/lg/h1`, cerrados en s20) migrados al estándar nombrado `slep_*` (`--fs-overline/caption/body/body-lg/h4/h3/h2`; piso 12px). 122 usos migrados por rol (no por rango numérico ciego). Dos overrides resueltos explícitamente: `.pan-sub-h` (era `--fs-md`, pasó a `--fs-h4` por ser sub-encabezado, no control — visualmente neutro, ambos 18px) e `.indp-score` (era `--fs-h1`, pasó a `--fs-h3` por ser KPI destacado, no título de pantalla — cero cambio visual, 22px=22px).
- **Por qué:** patrón común entre proyectos hermanos (mismo ejercicio que `slep_paes`).
- **Cómo se verificó (B.4):** payload byte-idéntico salvo fecha (cambio puro de CSS); 0 usos residuales de tokens viejos en template y build; verificación visual en las 4 vistas principales (territorial, ficha con radar+histórico+tooltips, comparador) con inspección DOM además de screenshot; 0 errores de consola.
- **Roce cosmético no bloqueante:** `.ybar-yr` (año bajo cada barra histórica) saltó de 12px a 14px al fusionar `--fs-sm`/`--fs-xs` en `--fs-caption` (pérdida de un escalón intermedio); revisado y aprobado por el titular en el gate visual, sin overlap verificado en 12 columnas a 1280px.
- **Bug preexistente hallado de paso (no corregido):** tildes faltantes en el texto "sin dato (resguardo estadístico)" y en algunas prosas de definición del HTML fuente; deuda de contenido preexistente, no relacionada con esta migración.

### 3.6 P-GLIFO-DOBLE-LECTURA: revisado, cerrado sin cambio
- **Categoría:** Revisión / decisión de diseño.
- **Qué:** pendiente heredado de s25 ("posible afinamiento si confunde" entre el glifo de significancia temporal y el de vs GSE). Revisado el render real: el componente `Ancla` ya lleva su `tipo` ("vs su grupo" / "vs año anterior") como etiqueta visible y en el `title`; el tooltip de barra ya distingue "vs evaluación anterior" (en el `title` del glifo) de "vs GSE" (en el cuerpo del tooltip). Ninguna lectura aparece sin rótulo.
- **Por qué se cierra sin cambio:** la sospecha de confusión no se materializa en el código; tocar algo que ya funciona sería un cambio no solicitado (B.3).
- **Nota para el futuro (no es pendiente):** hay una asimetría de profundidad (la lectura temporal vive en un `title` de segundo nivel; la de GSE en el cuerpo del tooltip). Unificar los niveles sería una mejora cosmética opcional, decisión deliberada de una pasada de UI futura, no defecto actual.

### 3.7 Suite: cobertura histórica documentada (D8) (`24618db`)
- **Categoría:** Documentación.
- **Qué:** nueva entrada `D8` en `cfg$decisiones` de `documentar.R` ("Cobertura histórica: la máxima que permite la fuente"), con cobertura real por familia (indicador 2014-2025; dimensión 2018+2022-2025; niveles 2023-2025) y por grado (2m/4b: 9 años, 2014-2018+2022-2025; 6b/8b: aplicación intermitente), y el motivo de los huecos (estallido social 2019, pandemia 2020-2021), fuente: `20260625_decision_cobertura_historico_idps.md`. Afinadas también la FAQ, la garantía y la nota de "años en gris" (`cfg$faq`, `cfg$garantias`, `cfg$notas`) con el detalle 4b/2m específico, respetando separación de capas: 6b/8b solo aparece en D8 (arquitectura técnica), nunca en el lenguaje simple.
- **Por qué (C.11):** cierre del pendiente "suite/corpus con cobertura histórica" de s25 (§11); el corpus conceptual no se tocó (cobertura histórica no es materia conceptual, es documentación de proyecto).
- **Cómo se verificó (B.4):** D8 presente en `documentacion_proyecto_slep_idps_standalone.html`; FAQ/garantías/notas afinadas aterrizaron en los HTML correctos (`documentacion_general`, `arquitectura_general`); 0 menciones de 6°/8° en los HTML de lenguaje simple (separación de capas confirmada en la salida generada, no solo en la cfg); 4 HTML standalone verificados offline (0 recursos de red reales); 0 marcadores REVISAR.
- **Bug encontrado y resuelto de paso:** la URL real de la Agencia (citada en la decisión fuente) contiene literalmente `resultados-simce-2019` en su slug, disparando el guardia anti-contaminación cruzada P-DOC-CFG-CRUZADA (protege contra contenido del proyecto hermano `slep_simce_adecuado`). Falso positivo confirmado (URL legítima, no contenido cruzado). Resuelto sin tocar el flag `verificar` (invariante de gobernanza): se quitó el texto crudo de la URL de D8, remitiendo a la decisión fuente que ya la trae íntegra.
- **Desviación del encargo, correctamente resuelta:** el encargo asumía commitear `documentar.R` + los 4 HTML standalone; Claude Code verificó con `git check-ignore` que los 4 HTML están gitignorados por política explícita del repo (`.gitignore` L48-53, consistente con la sesión de P-DOC-CFG-CRUZADA en s24) y solo commiteó `documentar.R`, siguiendo el estado real del repo en vez de la instrucción literal.

---

## 4. Commits de la sesión

| # | Hash | Tipo | Descripción |
|---|------|------|-------------|
| 1 | `7d50568` | docs | cierra REVISAR voz en documentar.R (voz aprobada) |
| 2 | `805d652` | style | elimina regla CSS muerta .hist-leg (P-CSS-HIST-LEG) |
| 3 | `9416b14` | deploy | publica motor sin CSS muerto .hist-leg |
| 4 | `6cb3794` | docs | consolida backlog a v25/147 + vista analítica Rediseño UI |
| 5 | `301d11a` | feat | tooltip histórico contextual por año y grado (2019 estallido / pandemia) |
| 6 | `260bb7f` | fix | tildes completas en textos contextuales del tooltip histórico |
| 7 | `b98bc2a` | deploy | tooltip histórico contextual por año y grado |
| 8 | `57e10f1` | style | migra escala tipográfica a variables --fs-* nuevas, piso 12px |
| 9 | `96b5d3c` | deploy | migra escala tipográfica a variables --fs-* nuevas |
| 10 | `24618db` | docs | documenta cobertura histórica IDPS y motivo de huecos (D8) |

**Nota:** entre `96b5d3c` y `24618db` aparecen en el log dos commits externos a esta sesión (`4b7cdd3` ESTADO.md, `708572a` renombrado de backlog), generados por higiene independiente del titular o de otra sesión, no reportados aquí en detalle por no ser parte de este traspaso.

---

## 5. Backlog acumulativo

**Estado:** consolidado a **v25/147** en `6cb3794` (§3.3). **s26 NO aporta entradas nuevas** al correlativo: por la nota metodológica del backlog, el tooltip contextual, la migración tipográfica y la suite son mejoras/documentación derivadas de pendientes ya numerados en v25 (#145-147 y el pendiente histórico de §11 del traspaso v25), no solicitudes de producto nuevas y distinguibles. El correlativo permanece en **147**; el próximo cambio de producto será **#148**.

**Delta del backlog en s26:** 0 entradas nuevas al correlativo. Un cambio de taxonomía (vista analítica no-correlativa, §3.3), documentado como delta de subdivisión, no de creación.

---

## 6. Bugs de la sesión

**Bug 1 — Tildes parciales en constantes de motivo del tooltip histórico.**
- **Síntoma:** las constantes `MOTIVO_*` en `35_generar_motor_html.R` quedaron con acentuación inconsistente (p.ej. "4° básico" con tilde pero "interrumpio"/"aplicacion" sin) tras la primera implementación.
- **Causa raíz:** el encargo original especificó los textos de pandemia/no_eval-genérico en ASCII puro por descuido de quien redactó el encargo (esta sesión), mientras pedía `\uXXXX` para el resto; Claude Code siguió la letra del encargo en vez de aplicar consistencia ortográfica plena.
- **Solución:** las 4 constantes reescritas con `\uXXXX` completo para todo carácter no-ASCII. Verificado a nivel de bytes crudos del payload descomprimido (no de archivos intermedios re-escritos por R, que dan falsos negativos en locale-C).
- **Regla aprendida:** al redactar encargos con texto literal visible al usuario, especificar SIEMPRE el texto plenamente acentuado (nunca ASCII simplificado), y verificar consistencia contra texto ya acentuado en el mismo contexto visual (en este caso, `.ficha-explain` contiguo).
- **Estado:** resuelto (`260bb7f`).

**Bug 2 — Falso positivo del guardia anti-contaminación cruzada (P-DOC-CFG-CRUZADA) contra una URL legítima.**
- **Síntoma:** `generar_suite()` abortó al detectar la cadena "simce" en la URL de la Agencia citada en D8.
- **Causa raíz:** el guardia hace matching de substring sobre todo el contenido de `cfg`, sin distinguir entre contenido cruzado real (texto del proyecto hermano `slep_simce_adecuado`) y una URL pública que casualmente contiene "simce" en su slug.
- **Solución:** se quitó el texto crudo de la URL del cuerpo de D8 (remite a la decisión fuente, que la conserva íntegra); no se tocó el flag `verificar` (invariante de gobernanza).
- **Regla aprendida:** al citar URLs o referencias externas en `cfg`, verificar antes si contienen substrings de nombres de proyectos hermanos; preferir remitir a un documento fuente en vez de incrustar el texto crudo cuando hay riesgo de falso positivo.
- **Estado:** resuelto, sin tocar el guardia (P3, ver §7).

---

## 7. Aprendizajes y restricciones descubiertas

- **Verificación de texto acentuado en payloads binarios:** los bytes crudos (`od -An -tx1` sobre el payload descomprimido) son la única evidencia fiable; `cat`/`grep` sobre archivos intermedios escritos por R en locale-C, y `grep -P`/`xxd -p` en macOS (BSD), producen falsos negativos. Contexto: verificación de §3.4. Aplica a cualquier verificación futura de texto con tildes en el motor.
- **El guardia anti-contaminación cruzada hace matching de substring, no de contexto:** puede disparar sobre contenido legítimo que casualmente contiene el nombre de un proyecto hermano (ej. una URL con "simce" en el slug). No se ajustó el guardia esta sesión (fuera de alcance); queda como posible P3 futuro si se repite.
- **Separación entre correlativo del backlog y trabajo real de la sesión:** una sesión puede cerrar varios pendientes sustanciales (tooltip, migración tipográfica, suite) sin sumar entradas nuevas al correlativo, si esos pendientes ya estaban numerados o son documentación/mejora derivada. El correlativo mide solicitudes de producto distinguibles, no volumen de trabajo.

---

## 8. Decisiones de diseño

**Alcance del pendiente "suite/corpus con cobertura histórica" — solo suite, no corpus.**
- Alternativas consideradas: (a) tocar corpus + suite; (b) solo suite.
- Justificación: el corpus conceptual (`idps_corpus_conceptual.md`) documenta qué miden los IDPS (definiciones, dimensiones, niveles), no qué años cubre el motor. La cobertura histórica es materia de la documentación del proyecto (`documentar.R`: decisiones, reglas de cálculo), no del corpus.
- Implicancia: el corpus queda sin cambios en esta sesión; si aparece contenido conceptual nuevo en el futuro, se evalúa aparte.

**Subdivisión del backlog: vista analítica no-correlativa (opción 2), no reclasificación retroactiva.**
- Alternativas: (1) subdivisión prospectiva pura (solo futuro); (2) sub-tabla analítica no-correlativa bajo la tabla temática existente.
- Justificación: append-only prohíbe renumerar o reasignar las 50 entradas históricas de "Rediseño UI"; la opción 2 entrega el desglose que la observación de umbral (v21/v23/v24) pedía sin tocar el correlativo.
- Tensión resuelta: valor informativo (desglose real) vs integridad de memoria de largo plazo (append-only). Se priorizó la segunda.

**Orden de la sesión: suite al final, para que recoja todos los cambios.**
- Decisión del titular: reordenar la ruta original (que proponía la suite primero) para que la regeneración de `documentar.R` reflejara también el tooltip contextual y la migración tipográfica, evitando dos ciclos de regeneración.
- Implicancia: la suite D8 documenta cobertura histórica, pero NO documenta explícitamente el tooltip contextual ni la migración tipográfica como cambios de producto (son mejoras de presentación, no cambian la cfg conceptual). Si en el futuro se quiere que la suite narre esos cambios como hitos, es trabajo adicional no cubierto por D8.

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| `ANIOS_PANDEMIA` | `c(2020L, 2021L)` | `35_generar_motor_html.R` | Sin cambio. |
| `MOTIVO_PANDEMIA` | texto fijo, `\uXXXX` completo | `35_generar_motor_html.R` | Nueva (s26), corregida en `260bb7f`. |
| `MOTIVO_2019_4B` | texto fijo, `\uXXXX` completo | `35_generar_motor_html.R` | Nueva (s26). |
| `MOTIVO_2019_2M` | texto fijo, `\uXXXX` completo | `35_generar_motor_html.R` | Nueva (s26). |
| `MOTIVO_NO_EVAL` | texto fijo, `\uXXXX` completo | `35_generar_motor_html.R` | Nueva (s26), fallback genérico. |
| `--fs-overline` | 12px | `35_motor_template.html` :root | Nueva (s26), reemplaza `--fs-2xs` (11px). |
| `--fs-caption` | 14px | `35_motor_template.html` :root | Nueva (s26), reemplaza `--fs-xs`(12px) y `--fs-sm`(13px), fusionados. |
| `--fs-body` | 16px | `35_motor_template.html` :root | Nueva (s26), reemplaza `--fs-base` (14px). |
| `--fs-body-lg` | 18px | `35_motor_template.html` :root | Nueva (s26), reemplaza `--fs-md` (16px). |
| `--fs-h4` | 18px | `35_motor_template.html` :root | Nueva (s26), reemplaza `--fs-lg` (18px). |
| `--fs-h3` | 22px | `35_motor_template.html` :root | Nueva (s26), override de `--fs-h1` para KPI destacado (`.indp-score`). |
| `--fs-h2` | 28px | `35_motor_template.html` :root | Nueva (s26), reemplaza `--fs-h1` (22px) para títulos de pantalla. |
| Parquet `idps_largo.parquet` | md5 `4c764d8c9f0bf70004f8aa52661ae901` | `40_salidas/intermedios/` | Intocable, verificado intacto en cada tramo de la sesión. |

Los 7 tokens viejos (`--fs-2xs/xs/sm/base/md/lg/h1`) fueron eliminados de `:root` tras confirmar 0 usos residuales.

---

## 10. Arquitectura de archivos

Escáner re-corrido al cierre: `50_documentacion/estructura/20260702_123204_estructura.{txt,md}` (32 carpetas, 283 archivos), con alias `estructura_actual.{txt,md}` actualizado. Sin cambios estructurales en esta sesión (ningún archivo nuevo fuera de los ya versionados; el escáner solo refleja los commits de código y documentación de §4). Deuda heredada de espacios en `andamios/diseno/` (`Motor IDPS.html`, `PROMPT para Claude.md`), señalada en v25, sigue sin resolver (no tocada esta sesión, congelada).

---

## 11. Pendientes y ruta sugerida

### Inventario

| Pendiente | Contexto | Tipo | Impacto | Complejidad | Sugerencia |
|---|---|---|---|---|---|
| P-SLEPVERSE | Paquete interno propuesto (`herramientas_dev/`, 6 módulos) | funcionalidad | transversal a proyectos hermanos | alta | sesión dedicada, inventario primero |
| P-GITIGNORE-TOKEN | Heredado, scope incierto | deuda técnica | bajo, sin contexto claro | por determinar | revisar qué es antes de estimar |
| Ítem 11 | Bloqueado (sin detalle adicional en v25) | bloqueante | desconocido | — | mantener bloqueado hasta que se resuelva la dependencia |
| Guardia anti-contaminación cruzada (falso positivo con substrings) | Hallado en §6 Bug 2 | mejora técnica | bajo (workaround ya aplicado) | baja-media | evaluar si el guardia debe excluir URLs o mejorar el matching |
| Asimetría de profundidad en glifo (título vs cuerpo de tooltip) | §3.6, nota para el futuro | mejora visual | cosmético | baja | pasada de UI deliberada futura, no urgente |
| `.ybar-yr` salto 12px→14px | §3.5, roce cosmético aprobado | mejora visual | cosmético, ya aprobado por el titular | — | sin acción; revisar solo si se reporta en viewports angostos |

### Auditoría de cierre (política 5.6)
Todas las preguntas de cierre aplicables respondidas "sí" en el curso de la sesión (verificación de invariantes, gate visual, parquet intacto en cada tramo, working tree limpio salvo cambios manuales externos del titular). Sin hallazgos nuevos que agregar como pendiente.

### Ruta sugerida para s27
1. **P-GITIGNORE-TOKEN** — revisar primero (bajo costo de investigación, podría cerrarse rápido o resultar irrelevante).
2. **P-SLEPVERSE** — si hay tiempo para una sesión dedicada; requiere inventario previo del estado real de `herramientas_dev/`.
3. Diferir: guardia anti-contaminación cruzada y asimetría de glifo (ambos de bajo impacto, sin urgencia).

---

## 12. Instrucciones específicas para la próxima sesión

⚠️ NO asumir que `24618db` está empujado a `origin/main` sin verificar `git status -sb` primero: el estado exacto de push al cierre de este traspaso no fue confirmado con un comando explícito de push (a diferencia de los tramos con deploy).
✅ ANTES de continuar cualquier trabajo, correr el escáner si han pasado más de unos días (la política exige escáner reciente en la apertura).
🔒 Parquet `4c764d8c9f0bf70004f8aa52661ae901` intocable.
🔒 Separación de capas en la suite: 6b/8b solo en documentación técnica (D8), nunca en FAQ/garantías/notas (lenguaje simple).
🔒 El motor solo expone 4b/2m; cualquier lógica nueva de motivo/tooltip histórico debe respetar esa frontera.

---

## 13. Fragmentos de código de referencia

Patrón de verificación de texto acentuado en el payload (la forma correcta en este proyecto, ver §6 Bug 1 y §7):

```r
# Extraer y descomprimir el payload embebido en el HTML del motor
extract_json <- function(path){
  h <- paste(readLines(path, warn=FALSE), collapse="\n")
  m <- regmatches(h, regexpr('atob\\("[A-Za-z0-9+/=]+"\\)', h))
  b64 <- sub('atob\\("','',sub('"\\)','',m))
  rawToChar(memDecompress(jsonlite::base64_dec(b64), type="gzip"))
}
# Para verificar tildes: escribir a archivo y leer BYTES CRUDOS (no vía cat de R
# en locale-C, que escapa; usar od -An -tx1 sobre el binario descomprimido).
```

---

## 14. Reapertura

### Nombre del chat
`slep_idps, sesión 27 (Sonnet 5)`

### Mensaje de apertura pre-armado
Adjunto los documentos de protocolo (si no están ya en la knowledge base del proyecto) y los específicos de la sesión: tipo CONTINUATION de slep_idps. El protocolo (`POLITICA_PROYECTO.md` + `SETTINGS_Y_PROMPTS_OPERACIONALES.md` + `DISCIPLINA_OPERATIVA.md`) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v26 y el escáner. Estado: s26 cerró higiene (voz, CSS muerto, backlog), tooltip histórico contextual, migración tipográfica y suite D8, todo desplegado donde corresponde. Backlog en v25/147 (sin cambio de correlativo esta sesión). Foco propuesto: revisar P-GITIGNORE-TOKEN.

### Documentos para la próxima sesión

1. **Protocolo en knowledge base** (no se adjuntan, solo verificar que estén al día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. **Específicos de esta sesión, para adjuntar:** `traspaso_cierre_v26.md` (este archivo), `50_documentacion/estructura/estructura_actual.md` (o re-correr el escáner si pasaron varios días).
3. **Bajo demanda si la sesión lo requiere:** `backlog_acumulativo.md` (para consultar el detalle cronológico completo), `documentar.R` (si se retoma trabajo de suite).

---

## 15. Errores del asistente

| # | Descripción | Regla canónica violada | Corrección |
|---|---|---|---|
| 1 | El encargo del tooltip histórico (turno de esta sesión) especificó los textos de las constantes `MOTIVO_PANDEMIA`/`MOTIVO_NO_EVAL` en ASCII simplificado en vez de con tildes completas vía `\uXXXX`, generando el Bug 1 (§6). | Convención del proyecto: no-ASCII siempre vía `\uXXXX`, texto visible al usuario siempre plenamente acentuado. | Corregido en el turno siguiente con un encargo de enmienda (`260bb7f`), verificado a nivel de bytes. |
