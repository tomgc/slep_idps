# traspaso_cierre_v18.md

> Documento de cierre de sesión. Único puente entre sesiones: todo lo que no quede
> aquí se pierde. Generado al cierre de la sesión 18 de `slep_idps`.

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional; Rama A
  pública, datos versionados en el repo).
- **Versión de traspaso:** v18.
- **Fecha:** 2026-06-22.
- **Sesión:** 18. **Foco:** cierre de la deuda de backlog declarada en v17 (escribir
  las entradas 108–110 en `backlog_historico.md`) y saneamiento del working tree
  (versionado de traspasos s16/s17 no trackeados, rotación del escáner, eliminación
  de un stray cruzado del proyecto hermano). El foco mayor propuesto por v17
  (P-DOC-SIMCE, documentar `slep_simce_adecuado`) se derivó a una sesión propia de
  ese proyecto.
- **Entorno:** R 4.5.2 en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`. Git + GitHub Pages. Ejecución dual-Claude: este
  Claude como analista/redactor; Claude Code como ejecutor de terminal y git.
- **Archivos principales modificados:**
  - `50_documentacion/activa/backlog_historico.md` (consolidado a v17/110).
  - `50_documentacion/traspasos/traspaso_cierre_v16.md` y `traspaso_cierre_v17.md`
    (versionados; estaban untracked — deuda A38 heredada).
  - `50_documentacion/estructura/` (rotación de snapshots del escáner, retención 2).
  - **El motor, el parquet, `20_insumos/`, `40_salidas/` y `docs/` NO se tocaron.**

---

## 2. Resumen ejecutivo

Sesión breve de cierre documental. Se escribieron en `backlog_historico.md` las tres
entradas que v17 declaró pero dejó sin integrar (108 consolidación del backlog a
v16/107; 109 P-SUITEDOC-INLINE + P-SUITEDOC-SANEAMIENTO sobre el repo del paquete;
110 regeneración de la suite de `slep_idps` como standalone offline + retiro de
`inline_suite.R`), dejando el backlog en **v17 / 110 cambios**, con las entradas
1–107 verificadas idénticas por diff. En el saneamiento del working tree se detectó y
cerró deuda A38 heredada: los traspasos de cierre s16 y s17 nunca se habían versionado
(estaban untracked); se versionaron en un commit aparte. Se rotaron los snapshots del
escáner (retención 2) y se eliminó un stray cruzado: una copia byte-idéntica del
encargo de `slep_simce_adecuado` que había quedado untracked en `activa/encargos/` de
idps (md5 confirmado idéntico al original del hermano; cero pérdida al borrar). El foco
mayor de v17 (P-DOC-SIMCE) se trasladó a una sesión propia de `slep_simce_adecuado`,
que avanzó en paralelo: su backlog se cerró a 1–113 y su suite standalone quedó como
Fase B pendiente en esa sesión. Queda abierto en idps el pendiente menor
P-BACKLOG-INTEGRIDAD (la clasificación temática suma 109 vs correlativo 110).

---

## 3. Estado al cierre

### Qué funciona (con evidencia)
- **Backlog v17/110:** `backlog_historico.md` consolidado, entradas 108–110
  integradas, entradas 1–107 verificadas idénticas (diff limpio). Commit `1bc5a34`,
  pusheado.
- **Traspasos s16/s17 versionados:** cierre de deuda A38 (estaban untracked). Commit
  `ec2579c`, pusheado.
- **Escáner rotado:** snapshots a retención 2 (renames 160154→193311, 141236→200734
  + re-alias de `estructura_actual.*`). Commit `48df5d7`, pusheado.
- **Working tree limpio y sincronizado:** `git status` limpio; local == origin en
  `48df5d7`.
- **Motor, parquet, docs/ intactos:** ningún commit de la sesión toca `docs/` →
  GitHub Pages sin cambio.

### Qué no funciona / queda a medias
- Nada roto. Pendientes abiertos = trabajo no iniciado (ver §11).

### Delta respecto a v17
- Backlog: de 108–110 declarado-no-escrito a **108–110 escrito y consolidado** (v17/110).
- Traspasos s16/s17: de untracked a **versionados** (deuda A38 cerrada).
- Escáner: rotado a retención 2.
- Stray cruzado de SIMCE en idps: **eliminado**.

---

## 4. Registro detallado de cambios (sesión 18)

> Numeración global del backlog NO avanza en esta sesión: el trabajo de s18 es
> escritura/saneamiento documental, no cambios de producto nuevos. Las entradas
> 108–110 que se escribieron corresponden a solicitudes de s17, ya contadas en el
> total 110. Por la nota metodológica (intención primaria), el acto de consolidar el
> backlog no genera una entrada nueva (sería recursivo); se registra aquí por
> trazabilidad, no en el correlativo.

**C1 — Escritura de las entradas 108–110 en `backlog_historico.md` (P1, foco de la sesión).**
[documentación de proyecto]. Consolidación del backlog a v17/110: encabezado de
versión a v17/110, fila s17 (108–110) + total 110 en el resumen estadístico,
encabezado de la clasificación temática a 110, dos filas de clasificación
actualizadas ("Limpieza/deuda técnica" 12→13 por #108; "Documentación de proyecto"
2→4 por #109/#110), entrada cronológica de la sesión 17, y bloque "Delta del backlog
(consolidación v17)". Entradas 1–107 verificadas idénticas por diff. Commit `1bc5a34`.

**C2 — Versionado de los traspasos s16 y s17 (deuda A38 heredada).**
[infraestructura / operativo-versionado]. Se detectó en `git status` que
`traspaso_cierre_v16.md` y `traspaso_cierre_v17.md` estaban untracked: los cierres de
s16 y s17 nunca se habían versionado, pese a que el escáner los listaba (A20: el
escáner lista el filesystem, no el índice de Git). Se versionaron en commit atómico
aparte. Commit `ec2579c` (con trailer `Co-Authored-By` añadido por amend antes del
push).

**C3 — Rotación de snapshots del escáner.**
[limpieza / deuda técnica]. Rotación a retención 2 conforme a la política §7.4
(renames 160154→193311, 141236→200734 + re-alias de `estructura_actual.*`). Commit
atómico separado (no mezclado con C1/C2). Commit `48df5d7`.

**C4 — Eliminación de un stray cruzado del proyecto hermano.**
[limpieza / deuda técnica]. Una copia de
`encargo_claude_code_simce_suite_standalone.md` (encargo de `slep_simce_adecuado`)
había quedado untracked en `activa/encargos/` de idps. Verificado byte-idéntico
(md5 `f22a88eb…`) a la copia que ya vive en el repo hermano; borrado de idps (mover
solo habría sobrescrito una copia idéntica). El original se conserva en su proyecto.
El otro match del grep (`encargo_..._idps_producto_deploy.md`) es de idps legítimo y
se conservó. Sin commit propio (era untracked; su eliminación no genera diff
versionable).

**(Spin-off, no-cambio de idps) — P-DOC-SIMCE derivado a sesión propia.**
El foco mayor que v17 proponía (documentar `slep_simce_adecuado` con suitedoc) se
trasladó a una sesión de ese proyecto. Esta sesión de idps preparó el encargo
correspondiente, que se ejecuta allá. No es trabajo de idps; se registra por
trazabilidad del traspaso.

---

## 5. Backlog acumulativo

> Vive consolidado en `backlog_historico.md` (numeración global permanente, única
> fuente de verdad del conteo — A22).

- **Total a v18:** 110 cambios (sin avance respecto a v17; s18 fue escritura del
  backlog ya declarado en v17, no producto nuevo).
- **Delta v18:** 0 entradas nuevas de producto. La sesión escribió las entradas
  108–110 (solicitudes de s17, ya contadas) y saneó el working tree.

---

## 6. Bugs y hallazgos de la sesión

- **Traspasos s16/s17 sin versionar (deuda A38 heredada, no un bug de código).**
  Síntoma: `git status` los mostró untracked; el escáner los listaba, lo que ocultó
  que no estaban en el índice. **Regla aplicada (A20/A38):** el escáner lista el
  filesystem, no el índice; para afirmar qué está versionado, `git ls-files`. Git
  pusheado es la condición de cierre, no el archivo en disco. Resuelto en `ec2579c`.
- **Stray cruzado entre proyectos.** Una copia del encargo de SIMCE quedó en la
  carpeta de idps. **Regla aplicada:** verificar la identidad de todo artefacto
  (encabezado/título) contra el proyecto activo antes de versionarlo; un encargo
  titulado para otro proyecto no se versiona aquí. Resuelto al borrar el stray.
- **Incidente de proceso del asistente (R9).** El redactor entregó comandos de
  corrección del commit de backlog antes de leer el output de la verificación,
  asumiendo que P1 no estaba commiteado cuando sí lo estaba (`1bc5a34`). Sin daño
  (un `add`/`commit` sobre un archivo sin cambios no habría hecho nada), pero
  contraviene R9 (verificar el estado real antes de redactar comandos). **Regla
  reforzada:** ante una verificación, parar y esperar el output antes de redactar
  cualquier comando que dependa de su resultado; no precargar el fix.

---

## 7. Aprendizajes y restricciones descubiertas

- **A38 reforzado:** un traspaso generado y guardado en disco no está cerrado hasta
  versionarse y pushearse. Verificar con `git status`/`git ls-files` al cierre, no
  confiar en que el escáner lo liste.
- **Contaminación cruzada entre proyectos hermanos:** archivos con stack y
  convenciones idénticas (idps / simce / categoria) pueden quedar en la carpeta
  equivocada. Verificar el encabezado/título del artefacto contra el proyecto activo
  antes de usarlo o versionarlo (refuerzo de R9 y de la nota de v20 de SIMCE).
- **R9 (precarga de comandos):** no entregar comandos condicionados a un resultado
  no observado; partir la intervención en verificar → leer → decidir.

---

## 8. Decisiones de diseño

- **D-s18-COMMITS-ATOMICOS.** Los tres frentes del saneamiento (backlog, traspasos,
  escáner) se commitearon por separado (`1bc5a34`, `ec2579c`, `48df5d7`), no en un
  commit mezclado, conforme a la política §3 (commits atómicos temáticos) y al patrón
  de SIMCE (no mezclar reorg con rotación de escáner). El stray se eliminó antes de
  los commits para que no contaminara el working tree.
- **D-s18-SPINOFF-SIMCE.** P-DOC-SIMCE se trasladó a una sesión propia de
  `slep_simce_adecuado` en vez de ejecutarse desde idps. Razón: un foco por sesión;
  documentar otro proyecto desde la sesión de idps mezcla dos repos y arriesga
  contaminación cruzada (que de hecho ocurrió con el stray). Decisión del titular.

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c…` | parquet | Sin cambio (ni se leyó en s18). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| md5 build desplegado | `4958558d…` | `docs/index.html` | Sin cambio (s17 no tocó docs/; s18 tampoco). |
| HEAD `slep_idps` (`origin/main`) | `48df5d7` | repo | **Nuevo (s18): saneamiento del working tree.** |
| HEAD `herramientas_dev` (`origin/main`) | `c8b3bd7` | repo paquete | Sin cambio respecto a v17. |
| Total backlog (global) | 110 (1–110) | `backlog_historico.md` | Escrito y consolidado en s18. |

---

## 10. Arquitectura de archivos

Sin cambios estructurales de fondo: la sesión versionó traspasos ya existentes, rotó
el escáner y consolidó el backlog. **Motor, parquet, docs/ intactos.** HEAD de idps
en `48df5d7` (`origin/main` sincronizado). Antes de abrir s19, re-correr
`00_escanear_proyecto.R` si la estructura cambió.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-BACKLOG-INTEGRIDAD (menor, heredado de v15/v16).** La clasificación temática del
backlog suma 109 vs el correlativo global 110 (faltante de 1 heredado de la
reconciliación v14/v15: una entrada de 84–106 sin categoría asignada al recalcular la
distribución). El correlativo (1–110) es la cifra válida (A22). Localizar la entrada
huérfana contra el detalle de los traspasos v10–v14 y declarar su categoría con una
nota, **sin renumerar ni reasignar entradas históricas a ciegas**. Tipo: deuda de
documentación. Complejidad: baja. No requiere insumos externos más allá de los
traspasos v10–v14.

**P-DOC-SIMCE (en sesión propia de `slep_simce_adecuado`, NO de idps).** Documentar
ese proyecto con suitedoc como suite standalone offline. El encargo está preparado y
vive en `slep_simce_adecuado/50_documentacion/activa/encargos/`. ⚠️ Su Fase A está
obsoleta (espera el backlog en 1–109; ya está en 1–113): debe recortarse a solo Fase B
antes de ejecutar. NO es trabajo de idps; se lista aquí solo para trazabilidad del
spin-off.

**P-SLEPVERSE (paquete transversal).** Proyecto propuesto, no iniciado. Decisión
estratégica abierta (¿`slepverse` absorbe a `suitedoc` o paquetes separados?;
recomendación previa: separados). Tipo: NEW PROJECT, sesión dedicada.

**Afinaciones menores heredadas (no bloquean).** Tono de la prosa de la suite
(`# REVISAR (voz)` en `documentar.R`); hairline de la rampa del motor. Diferibles.

**Subir versión de lucide-static.** Cuando se quiera, cambiar `.SD_LUCIDE_VERSION` y
reverificar que los iconos de cada proyecto resuelven.

### Auditoría de cierre (política 5.6)
- Pipeline corre de cero sin intervención: **Sí** (s18 no tocó el pipeline).
- Outputs reproducibles/idempotentes: **Sí** (la suite se regenera con `documentar.R`).
- Decisiones metodológicas como constantes nombradas: **No aplica** (s18 no introdujo
  lógica de cálculo).
- Nombres sin tildes/ñ/espacios: **Sí**.
- Estructura respeta la política: **Sí**. Working tree limpio y sincronizado.

### Ruta sugerida para la sesión 19
1. Apertura CONTINUATION con este v18 + `backlog_historico.md` + escáner.
2. **Foco candidato:** P-BACKLOG-INTEGRIDAD (cierre de la deuda menor del backlog; no
   requiere insumos externos, sesión de higiene). Es lo único pendiente propio de
   idps que no es decisión estratégica ni spin-off.
3. **Diferir:** P-SLEPVERSE (sesión dedicada), afinaciones de tono.
   **Recomendación:** P-BACKLOG-INTEGRIDAD si se quiere cerrar la última deuda
   documental de idps; de lo contrario, idps está estable y desplegado sin trabajo
   obligado, y el siguiente foco lo decide el titular.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El dato está verificado a nivel CENSO y la fidelidad parquet→sitio también. NO
  re-auditar ni regenerar el parquet. md5 `4c764d8c…`.
- 🔒 El motor desplegado es el de P-PALETA-v2 (build `4958558d…`); s17 y s18 NO lo
  tocaron. docs/ intacto. HEAD de idps en `48df5d7`.
- 🔒 Identidad de indicador es regla (sin semáforo). StackedBar codifica
  significancia, no niveles (D-s15-RAMPA, D-s15-SEPARADOR).
- 🔒 La suite usa `suitedoc` (paquete en `herramientas_dev`, HEAD `c8b3bd7`).
  `inline_suite.R` ya NO existe. Los HTML de la suite son gitignorados (reproducibles
  con `documentar.R`).
- 🔒 **DISCIPLINA_OPERATIVA.md (R1-R9) es regla canónica de prioridad máxima.** Leer
  al inicio de sesión.
- ✅ ANTES de abrir s19, RE-CORRER `00_escanear_proyecto.R` si la estructura cambió.
- ✅ ANTES de cualquier `git add`, revisar `git status`; nunca `git add .`/`-u`.
- ✅ ANTES de redactar un comando git o un mensaje de commit, LEER el estado real
  (`git status`, `git log`, `.gitignore`, contenido) — no asumir qué entra al diff ni
  qué ya está commiteado (R3/R9). Ante una verificación, esperar su output antes de
  redactar comandos que dependan de él.
- ✅ Para afirmar qué está versionado, usar `git ls-files`, no el escáner (A20).
- ⚠️ Verificar la identidad de todo artefacto cargado (encabezado/título) contra el
  proyecto activo antes de usarlo o versionarlo (contaminación cruzada entre
  proyectos hermanos).
- 🔒 Backlog en `backlog_historico.md` (110 cambios, escrito y consolidado a v17).
  Actualizarlo en CADA cierre; NO diferir (A22).

---

## 13. Fragmentos de código de referencia

**Versionar un saneamiento de working tree en commits atómicos separados (patrón vigente):**
```bash
# Cada frente en su propio commit; nunca git add . / -u; leer git status antes.
git -C /Users/tomgc/Projects/slep_idps add 50_documentacion/activa/backlog_historico.md
git -C /Users/tomgc/Projects/slep_idps commit -m "docs(backlog): consolidar a vNN/NNN"
git -C /Users/tomgc/Projects/slep_idps add 50_documentacion/traspasos/traspaso_cierre_vNN.md
git -C /Users/tomgc/Projects/slep_idps commit -m "docs(traspaso): versionar cierre sNN"
git -C /Users/tomgc/Projects/slep_idps add 50_documentacion/estructura/
git -C /Users/tomgc/Projects/slep_idps status   # confirmar solo estructura/ staged
git -C /Users/tomgc/Projects/slep_idps commit -m "chore(estructura): rota snapshots del escaner"
git -C /Users/tomgc/Projects/slep_idps push origin main
```

**Detectar un stray cruzado antes de versionar:**
```bash
# Verificar identidad y duplicado antes de borrar/mover:
head -1 <archivo_sospechoso>                       # el titulo declara su proyecto
md5 <archivo_idps> <archivo_hermano>               # si idem -> stray, borrar la copia local
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 19 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  SETTINGS + DISCIPLINA_OPERATIVA) vive en la knowledge base y se lee desde ahí.
  Adjunto el traspaso v18, el backlog histórico y el escáner actual. El motor
  (P-PALETA-v2) sigue desplegado e intacto (docs/ sin cambio); `slep_idps`
  sincronizado en `48df5d7`. Backlog consolidado a v17/110, traspasos s16/s17
  versionados, working tree limpio. Pendiente propio de idps: P-BACKLOG-INTEGRIDAD
  (clasificación temática suma 109 vs correlativo 110; localizar la entrada huérfana
  sin renumerar). P-DOC-SIMCE se ejecuta en su sesión propia, no aquí."
- **Documentos para la sesión 19, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; verificar que estén al día):
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`,
     `DISCIPLINA_OPERATIVA.md`.
  2. *Opcionales según el foco:* si P-BACKLOG-INTEGRIDAD → traspasos v10–v14 para
     localizar la entrada huérfana.
  3. *Específicos (SÍ se adjuntan):* `traspaso_cierre_v18.md`;
     `backlog_historico.md`; `estructura_actual.md`.
- **Nota final:** si algún archivo listado cambió entre sesiones, adjuntar la versión
  más actualizada al abrir y avisarlo en el mensaje de apertura.
