# traspaso_cierre_v17.md

> Documento de cierre de sesión. Único puente entre sesiones: todo lo que no quede
> aquí se pierde. Generado al cierre de la sesión 17 de `slep_idps`.

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional; Rama A
  pública, datos versionados en el repo).
- **Versión de traspaso:** v17.
- **Fecha:** 2026-06-22.
- **Sesión:** 17. **Foco:** tres frentes — (1) consolidación del backlog a v16/107
  (deuda de cierre de s16), (2) integración del inlining autocontenido al paquete
  `suitedoc` (P-SUITEDOC-INLINE + P-SUITEDOC-SANEAMIENTO, repo distinto) y
  regeneración de la suite de `slep_idps` con salida standalone 100% offline, (3)
  diseño e implementación de barreras anti-error operativas (DISCIPLINA_OPERATIVA.md
  + R1-R9) tras un desempeño deficiente de Claude durante la sesión.
- **Entorno:** R 4.5.2 en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; paquete `suitedoc` en
  `/Users/tomgc/Projects/herramientas_dev/suitedoc`. Git + GitHub Pages. Ejecución
  dual-Claude: este Claude como analista/redactor; Claude Code como ejecutor.
- **Archivos principales modificados:**
  - `slep_idps`: `50_documentacion/activa/backlog_historico.md` (a v16/107);
    `50_documentacion/suite/documentar.R` (standalone=TRUE, terminología EE, icono
    network); `50_documentacion/suite/inline_suite.R` ELIMINADO (obsoleto);
    4 `*_standalone.html` regenerados (gitignorados, no versionados por política).
  - `suitedoc` (repo `herramientas_dev`): paquete saneado y versionado completo
    (ver §4).
  - Documentos de gobernanza: `DISCIPLINA_OPERATIVA.md` (NUEVO),
    `custom_instructions_claude_web.md`, `CLAUDE.md`,
    `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (los 4 entregados al titular para
    reemplazo manual en cada proyecto y en custom instructions).
  - **El motor, el parquet, `20_insumos/`, `40_salidas/` y `docs/` NO se tocaron.**

---

## 2. Resumen ejecutivo

La sesión 17 cerró tres frentes. Primero, consolidó el backlog a **v16/107**,
integrando la entrada 107 (P-ORG) que el traspaso v16 declaró pero no había
escrito en el archivo (commit `faefc93`); en el proceso se detectó una deuda de
integridad heredada de la reconciliación v14/v15 (la tabla de clasificación suma
106 vs el correlativo 107), declarada como pendiente menor sin reasignar entradas
históricas. Segundo, el frente mayor: se integró el inlining autocontenido al
paquete `suitedoc` (opción D: post-proceso con función propia `inlinar_suite()`,
no un modo de generación), logrando salida standalone **100% offline** (CSS,
fuentes, logos e iconos lucide embebidos en base64), y luego se saneó el paquete
(gitignore, versionado completo, limpieza de enlazados, validación temprana de
iconos, versión de lucide fijada); ambos encargos quedaron pusheados (9 commits
en `herramientas_dev`). La suite de `slep_idps` se regeneró con el paquete saneado
(`055cbac`). Tercero, ante un desempeño deficiente de Claude (declarar tareas
listas sin verificar, sugerir cierre repetidamente, asumir recursos inexistentes,
errores de lectura), se diseñó e implementó un cuerpo de barreras anti-error
(`DISCIPLINA_OPERATIVA.md`, reglas R1-R9) inscrito en los 4 documentos de
gobernanza.

---

## 3. Estado al cierre

### Qué funciona (con evidencia)
- **Backlog v16/107:** `backlog_historico.md` consolidado, entrada 107 integrada,
  entradas 1-106 verificadas idénticas (diff limpio). Commit `faefc93`, pusheado.
- **Paquete `suitedoc` saneado y pusheado:** 9 commits en `origin/main` de
  `herramientas_dev` (`8ef4b2a..c8b3bd7`). Instalable desde cero vía clone +
  `devtools::install()` (criterio verificado por Claude Code: clone + install +
  `nuevo_proyecto()` copia el tema sin warning).
- **Suite de `slep_idps` regenerada:** 4 `*_standalone.html` en
  `50_documentacion/suite/`, 100% offline (0 referencias de red verificado por
  grep independiente; iconos embebidos 19/5 svg; 6 fuentes data: por archivo;
  terminología "establecimiento educacional"). `documentar.R` versionado, commit
  `055cbac`, pusheado. Los HTML son gitignorados por política (reproducibles
  corriendo `documentar.R`).
- **Barreras anti-error:** `DISCIPLINA_OPERATIVA.md` (R1-R9) + punteros en los 3
  documentos de gobernanza, entregados al titular.
- **Arranque de documentación de `slep_simce_adecuado`:** `nuevo_proyecto()` dejó
  la plantilla + tema en su carpeta suite (cfg aún sin llenar).

### Qué no funciona / queda a medias
- Nada roto. Pendientes abiertos = trabajo no iniciado (ver §11).

### Delta respecto a v16
- Backlog: de 107 declarado-no-escrito a **107 escrito y consolidado** (v16).
- `suitedoc`: de paquete a medio trackear con inlining manual externo, a
  **paquete completo versionado con inlining 100% offline integrado y saneado**.
- Suite `slep_idps`: de HTML enlazados (s14/s15) a **4 standalone offline**,
  `inline_suite.R` retirado.
- Gobernanza: **nuevo cuerpo de reglas operativas R1-R9** (no existía en v16).

---

## 4. Registro detallado de cambios (sesión 17)

> Numeración global continúa en `backlog_historico.md`. Esta sesión agrega las
> entradas 108-110 (ver §5).

**C1 (#108) — Consolidación del backlog a v16/107.**
[documentación de proyecto]. Integración de la entrada 107 (P-ORG) al
`backlog_historico.md`: encabezado a v16/107, fila s16 en el resumen, clasificación
"Limpieza/deuda técnica" 11→12, entrada cronológica s16, bloque delta v16.
Entradas 1-106 intactas (diff verificado). Hallazgo: descuadre de 1 entre la suma
de la clasificación (106) y el correlativo (107), heredado de la reconciliación
v14/v15; declarado como deuda menor sin reasignar entradas históricas. Commit
`faefc93`. Verificación: diff de entradas s1-s15 idéntico.

**C2 (#109) — P-SUITEDOC-INLINE + P-SUITEDOC-SANEAMIENTO (paquete `suitedoc`).**
[infraestructura / herramienta transversal — repo distinto]. Una solicitud
(documentación compartible offline) ejecutada en dos encargos autónomos a Claude
Code sobre el repo del paquete:
- **Inline (opción D):** función `inlinar_suite()` exportada (post-proceso de
  responsabilidad única) + flag `standalone=FALSE` en `generar_suite()`. Embebe
  CSS/fuentes/logos como data: URIs (lógica probada de s15 portada) e iconos lucide
  como `<svg>` desde `lucide-static` (npm), eliminando el `<script>` de red.
  100% offline verificado (grep red = 0). 5 invariantes PASA.
- **Saneamiento:** fix del warning de install (causa raíz: `%` sin escapar en el
  `@title` de roxygen, defecto del redactor); `.gitignore` del paquete; versionado
  completo (builders, cfg, inst/tema, README); `limpiar_enlazados=TRUE` cuando
  standalone (no deja basura); validación temprana de iconos con sugerencias;
  `.SD_LUCIDE_VERSION="1.21.0"` fijada. 5 criterios PASA + e2e en slep_idps.
- 9 commits pusheados a `herramientas_dev`. Logs:
  `suitedoc/dev_logs/20260622_inline_standalone_log.md` y
  `20260622_saneamiento_log.md`.

**C3 (#110) — Regeneración de la suite de `slep_idps` + retiro de `inline_suite.R`.**
[visualización/documentación]. `documentar.R` actualizado: `standalone=TRUE`,
barrido "colegio→establecimiento educacional" (11 usos, regla 4.6.3.6), icono
`sitemap`→`network` (sitemap no existe en lucide). Suite regenerada: 4 standalone
offline. `inline_suite.R` eliminado (obsoleto; el inlining lo hace el paquete).
Commit `055cbac` (documentar.R + eliminación; los HTML gitignorados). Verificación
empírica sobre los standalone reales: 0 referencias de red, iconos embebidos,
terminología corregida.

**(No-cambio de producto) — Barreras anti-error operativas.**
Diseño e implementación de `DISCIPLINA_OPERATIVA.md` (R1-R9) y punteros en
`custom_instructions_claude_web.md`, `CLAUDE.md`,
`SETTINGS_Y_PROMPTS_OPERACIONALES.md`. Es gobernanza del asistente, no del
producto; no entra al backlog de producto pero se registra aquí por trazabilidad.

---

## 5. Backlog acumulativo

> Vive consolidado en `backlog_historico.md` (numeración global permanente, única
> fuente de verdad del conteo — A22).

- **Total a v17:** 110 cambios (1-107 a v16; 108-110 de s17).
- **Delta v17:** +3 entradas (108 consolidación backlog; 109 suitedoc
  inline+saneamiento; 110 suite slep_idps regenerada). Pendiente de escribir en
  `backlog_historico.md` en la apertura de s18 si no se hizo en este cierre —
  **NO diferir (A22/R-no-diferir)**; idealmente escribir ahora.
- **Taxonomía:** #108 en "Documentación de proyecto (suite/política)" (2→3);
  #109 en "Infraestructura y scaffold" o categoría nueva de herramienta
  transversal (evaluar en s18); #110 en "Visualización/diseño — rediseño UI" o
  "Documentación de proyecto". Decidir categoría exacta al escribir.
- **Deuda de integridad pendiente:** la clasificación suma 106 vs correlativo 107
  desde v15 (entrada huérfana 84-106 sin categoría). Localizar contra el detalle
  de v10-v14 y declarar su categoría sin renumerar.

---

## 6. Bugs y hallazgos de la sesión

- **Warning de install de `suitedoc` (causa raíz: defecto del redactor).** El
  `@title` de `inlinar_suite` tenía `100% offline` con `%` sin escapar; en `.Rd`
  el `%` es comentario, cerraba mal `\title{}`. **Regla aprendida (A17-1):** en
  roxygen, todo `%` literal va escapado `\%`; aplica a `@title`, `@description`,
  `@examples`. Claude Code lo corrigió (commit `3b7f6c0`).
- **Icono `sitemap` inexistente en lucide.** La cfg de `slep_idps` (sesión previa)
  usaba `sitemap`, que no existe en lucide-static; el inlining offline lo destapó
  (con HTML enlazados el navegador lo ignoraba en silencio). **Regla aprendida
  (A17-2):** validar nombres de iconos (y todo recurso externo) contra su fuente
  real antes de usarlos (R3). Corregido a `network`.
- **Ruta a home por `here()` sin `cd`.** Un `R -e 'source(...)'` desde `~` ancló
  `here()` al home y escribió los HTML en `/Users/tomgc/50_documentacion/`. **Regla
  aprendida (A17-3):** todo comando que dependa de `here()` debe correr desde la
  raíz del proyecto (`cd <raiz> && ...`), nunca desde el home.

---

## 7. Aprendizajes y restricciones descubiertas

- **A17-1 (roxygen `%` escapado).** Ver §6.
- **A17-2 (validar recursos externos contra su fuente).** Ver §6. Formaliza R3 de
  `DISCIPLINA_OPERATIVA.md`.
- **A17-3 (`here()` exige `cd` a la raíz).** Ver §6.
- **A17-4 (separación generación/transformación).** El inlining es un post-proceso
  con responsabilidad propia (`inlinar_suite()`), no un modo de `generar_suite()`.
  Patrón reutilizable: cuando una capacidad nueva es una transformación de la
  salida, va en función propia exportada, no como flag que mezcla responsabilidades.
- **Disciplina operativa (R1-R9).** Lección de proceso de la sesión: Claude declaró
  tareas listas sin evidencia ejecutable, sugirió cierre repetidamente y asumió
  recursos. Las barreras R1-R9 (`DISCIPLINA_OPERATIVA.md`) existen para impedirlo;
  su punto débil es la aplicación bajo presión de rapidez. Causa recurrente:
  atajos de eficiencia que saltan la verificación.

---

## 8. Decisiones de diseño

- **D-s17-INLINE-OPCION-D (inlining como post-proceso, no modo de generación).**
  `inlinar_suite()` función propia exportada; `generar_suite()` la orquesta con un
  booleano `standalone`. Alternativas descartadas: A (solo standalone, rompe el
  modelo enlazado), B (ambos siempre, 8 archivos), C (enum de 3 modos en la firma).
  D gana por responsabilidad única y reutilización suelta. Decisión del titular.
- **D-s17-OFFLINE-OBLIGATORIO (100% offline como invariante duro).** Los iconos
  lucide se embeben como `<svg>` desde `lucide-static`, sin `<script>` de red.
  Requisito del titular, no aspiracional.
- **D-s17-LIMPIAR-ENLAZADOS (standalone no deja basura).** `generar_suite(
  standalone=TRUE)` borra los enlazados intermedios. Con `standalone=FALSE`
  intacto.
- **D-s17-LUCIDE-FIJO (`1.21.0`).** Versión fijada para reproducibilidad, no
  `@latest`.
- **D-s17-DISCIPLINA (barreras R1-R9).** Nuevo cuerpo de reglas operativas en
  documento dedicado canónico, con punteros en los 3 documentos de gobernanza.
  Decisión del titular tras el desempeño deficiente de la sesión.

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c…` | parquet | Sin cambio (ni se leyó en s17). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| md5 build desplegado | `4958558d…` | `docs/index.html` | Sin cambio (s15; s17 no toca docs/). |
| HEAD `slep_idps` (`origin/main`) | `055cbac` | repo | **Nuevo (s17): suite regenerada.** |
| HEAD `herramientas_dev` (`origin/main`) | `c8b3bd7` | repo paquete | **Nuevo (s17): suitedoc saneado.** |
| Versión lucide-static | `1.21.0` | `suitedoc/R/inline.R` | **Nueva (s17): fijada.** |
| Total backlog (global) | 110 (1-110) | `backlog_historico.md` | **+3 (s17), pendiente de escribir.** |

---

## 10. Arquitectura de archivos

Escáner al cierre: `estructura_actual.md` (2026-06-22 19:33:11, 31 carpetas, 241
archivos). Cambios de s17 en `slep_idps`: `documentar.R` actualizado;
`inline_suite.R` eliminado de la suite; 4 standalone regenerados (gitignorados);
backlog a v16. **Motor, parquet, docs/ intactos.** El paquete `suitedoc` (repo
distinto) quedó completo y versionado.

> **Registro de ejecución detallado:** los logs de las sesiones de Claude Code
> viven en `suitedoc/dev_logs/` (`20260622_inline_standalone_log.md`,
> `20260622_saneamiento_log.md`), no en el repo de `slep_idps` (dev_logs/
> gitignorado en el paquete).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-BACKLOG-INTEGRIDAD (menor, heredado de v15).** La clasificación temática suma
106 vs correlativo 107. Localizar la entrada huérfana (84-106) contra el detalle de
v10-v14 y declarar su categoría sin renumerar. Tipo: deuda de documentación.
Complejidad: baja.

**P-BACKLOG-v17 (escribir entradas 108-110).** Consolidar las 3 entradas de s17 en
`backlog_historico.md`. NO diferir (A22). Idealmente en la apertura de s18.

**P-DOC-SIMCE (documentar `slep_simce_adecuado` con suitedoc).** La plantilla y el
tema ya están en su carpeta suite (`nuevo_proyecto()` corrido). Falta llenar la cfg
con la realidad del proyecto (protocolo 4.6, sesión BIBLIOTECA con sus insumos:
escáner, traspaso, decisiones). Tipo: documentación. Complejidad: media. **Es el
siguiente paso natural del trabajo de suitedoc.**

**P-DOC-CATEGORIA (documentar `slep_categoria_desempeno`).** Igual que P-DOC-SIMCE,
para el otro proyecto. Pendiente de iniciar `nuevo_proyecto()`.

**P-SLEPVERSE (paquete transversal).** Proyecto propuesto, no iniciado. Decisión
estratégica abierta: ¿`slepverse` absorbe a `suitedoc` como módulo, o paquetes
separados? (recomendación previa: separados). Tipo: NEW PROJECT, sesión dedicada.

**Afinaciones menores de la suite (heredadas de s15).** Tono de la prosa
(`# REVISAR (voz)` en `documentar.R`); ya se hizo el barrido de terminología.
Hairline de la rampa del motor. No bloquean.

**Subir versión de lucide-static.** Cuando se quiera, cambiar `.SD_LUCIDE_VERSION`
y reverificar que los iconos de cada proyecto resuelven.

### Auditoría de cierre (política 5.6)
- Pipeline corre de cero sin intervención: **Sí** (s17 no tocó el pipeline).
- Outputs reproducibles/idempotentes: **Sí** (la suite se regenera con
  `documentar.R`; los HTML son reproducibles, por eso gitignorados).
- Decisiones metodológicas como constantes nombradas: **No aplica** (s17 no
  introdujo lógica de cálculo de datos).
- Nombres sin tildes/ñ/espacios: **Sí**.
- Estructura respeta la política: **Sí**.

### Ruta sugerida para la sesión 18
1. Apertura CONTINUATION con este v17 + `backlog_historico.md` + escáner.
2. **Primero:** escribir las entradas 108-110 al backlog (P-BACKLOG-v17), no
   diferir.
3. **Foco recomendado:** P-DOC-SIMCE (documentar `slep_simce_adecuado` con
   suitedoc, sesión BIBLIOTECA protocolo 4.6). Es la continuación natural y el
   paquete ya está saneado y listo. **Requiere los insumos de ese proyecto**
   (escáner, traspaso, decisiones).
   **Recomendación:** P-DOC-SIMCE si el titular puede adjuntar los insumos de
   `slep_simce_adecuado`; si no, P-BACKLOG-INTEGRIDAD (cierre de la deuda menor del
   backlog, no requiere insumos externos).
3. **Diferir:** P-SLEPVERSE (sesión dedicada), afinaciones de tono.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El dato está verificado a nivel CENSO y la fidelidad parquet→sitio también. NO
  re-auditar ni regenerar el parquet. md5 `4c764d8c…`.
- 🔒 El motor desplegado es el de P-PALETA-v2 (build `4958558d…`); s17 NO lo tocó.
  El HEAD de `slep_idps` es `055cbac` (suite), el contenido del motor sigue en
  `ed240a6`. docs/ intacto.
- 🔒 Identidad de indicador es regla (sin semáforo). StackedBar codifica
  significancia, no niveles. (D-s15-RAMPA, D-s15-SEPARADOR).
- 🔒 La suite usa `suitedoc` (paquete en `herramientas_dev`, HEAD `c8b3bd7`).
  `inline_suite.R` ya NO existe en slep_idps (el inlining lo hace el paquete). Los
  HTML de la suite son gitignorados (reproducibles con `documentar.R`).
- 🔒 **DISCIPLINA_OPERATIVA.md (R1-R9) es regla canónica de prioridad máxima.** Leer
  al inicio de sesión. R1 evidencia antes de "listo"; R2 gate de pre-entrega; R3
  validar contra fuente; R4 sin residuos; R5 el cierre lo decide solo el titular;
  R6 brevedad; R7 sin voseo; R8 error en una línea; R9 verificar el referente de un
  output pegado.
- ✅ ANTES de abrir s18, RE-CORRER `00_escanear_proyecto.R` si la estructura cambió.
- ✅ ANTES de cualquier `git add`, revisar `git status`; nunca `git add .`/`-u`.
- ✅ ANTES de redactar un comando git o un mensaje de commit, LEER el estado real
  (`git status`, `.gitignore`, contenido) — no asumir qué entra al diff (R3/R9).
- 🔒 Backlog en `backlog_historico.md` (110 cambios pendientes de escribir 108-110).
  Actualizarlo en CADA cierre; NO diferir (A22).

---

## 13. Fragmentos de código de referencia

**Generar la suite standalone offline de un proyecto (patrón vigente):**
```r
# Desde la raíz del proyecto (cd imprescindible para que here() ancle bien):
# cd /Users/tomgc/Projects/<proyecto> && R -e 'source("50_documentacion/suite/documentar.R")'
# documentar.R llama: generar_suite(cfg, DESTINO_SUITE, standalone = TRUE)
# Deja solo los 4 _standalone.html (los enlazados se limpian). 100% offline.
```

**Arrancar la documentación de un proyecto nuevo con suitedoc:**
```r
# suitedoc::nuevo_proyecto("<slug>", destino = "/ruta/abs/<proyecto>/50_documentacion/suite")
# Deja la plantilla documentar.R + el tema (css + fonts + assets). Luego se llena la cfg.
```

**Validar iconos de una cfg contra lucide-static (antes de generar):**
```bash
# El paquete ya valida temprano y aborta listando los inexistentes con sugerencias.
# Manual, si se quiere pre-chequear: cruzar los ico=/icon= de documentar.R contra
# los nombres de package/icons/*.svg de lucide-static@1.21.0.
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 18 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  SETTINGS + DISCIPLINA_OPERATIVA) vive en la knowledge base y se lee desde ahí.
  Adjunto el traspaso v17, el backlog histórico y el escáner actual. El motor
  (P-PALETA-v2) sigue desplegado e intacto (docs/ en `ed240a6`); `slep_idps`
  sincronizado en `055cbac`. El paquete `suitedoc` quedó saneado y pusheado
  (`herramientas_dev` en `c8b3bd7`), instalable desde cero. La suite de slep_idps
  se regeneró como 4 HTML standalone 100% offline. Pendientes: escribir entradas
  108-110 al backlog (no diferir), y documentar `slep_simce_adecuado` con suitedoc
  (foco propuesto, requiere sus insumos)."
- **Documentos para la sesión 18, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; verificar que estén al día):
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`,
     `DISCIPLINA_OPERATIVA.md`.
  2. *Opcionales según el foco:* si P-DOC-SIMCE → insumos de `slep_simce_adecuado`
     (escáner, traspaso, decisiones); `documentar.R` de slep_idps como referencia de
     cfg llena. Si P-BACKLOG-INTEGRIDAD → traspasos v10-v14 para localizar la
     entrada huérfana.
  3. *Específicos (SÍ se adjuntan):* `traspaso_cierre_v17.md`;
     `backlog_historico.md`; `estructura_actual.md`.
- **Nota final:** si `documentar.R` o el paquete `suitedoc` cambian entre sesiones,
  adjuntar/avisar. El backlog debe pasar a 110 (entradas 108-110) en la apertura de
  s18 si no se escribió en este cierre.
