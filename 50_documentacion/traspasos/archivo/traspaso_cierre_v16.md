# traspaso_cierre_v16.md

> Documento de cierre de sesión. Único puente entre sesiones: todo lo que no quede
> aquí se pierde. Generado al cierre de la sesión 16 de `slep_idps`.

---

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, todo
  Chile; Rama A pública, datos versionados en el repo).
- **Versión de traspaso:** v16.
- **Fecha:** 2026-06-22.
- **Sesión:** 16. **Foco:** un frente cerrado — **P-ORG** (reorganización del
  directorio: encargos a `50_documentacion/activa/encargos/`, scripts de andamio
  archivados a `_archivo/`, referencias en logs/traspasos reescritas e íntegras),
  ejecutado vía encargo autónomo a Claude Code bajo protocolo 4.2 (migración de
  estructura con DRY_RUN). **Resultado:** repo ordenado y sincronizado con origin;
  16 encargos movidos como renames git (historial preservado), 8 scripts archivados,
  12 referencias full-path reescritas, 0 referencias rotas; backlog a 107 cambios.
  No quedó nada roto. Quedan abiertos P-SUITEDOC-INLINE (integrar el inlining al
  paquete `suitedoc`, repo distinto) y las afinaciones menores heredadas de s15.
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`). Ejecución dual-Claude: este Claude como analista/redactor; Claude Code
  como ejecutor (un encargo autónomo P-ORG con gate pre-push respetado).
- **Archivos principales modificados:** 16 `encargo_*.md` movidos de
  `50_documentacion/activa/` a `50_documentacion/activa/encargos/` (renames git);
  8 scripts (`verificar_*.R` ×7 + `reorganizar_universo_idps.R`) movidos de la raíz
  del repo a `_archivo/20260622/`; 12 archivos `.md` (10 logs + `traspaso_v11.md` +
  `decisiones/20260622_decision_paleta_indicadores.md`) con referencias full-path
  reescritas a la ruta nueva. **El motor, el parquet y `docs/` NO se tocaron**
  (md5 parquet `4c764d8c…` intacto, verificado; `docs/index.html` sin cambios →
  Pages no cambia).

---

## 2. Resumen ejecutivo

La sesión 16 cerró **P-ORG**, la reorganización de estructura pendiente desde s15.
El directorio acumulaba desorden: 16 encargos `encargo_*.md` mezclados en la raíz de
`50_documentacion/activa/` junto al protocolo y los artefactos vivos, y 8 scripts de
andamio (`verificar_*.R`, `reorganizar_universo_idps.R`) sueltos en la raíz del repo.
Se ejecutó bajo protocolo 4.2 (migración de estructura) vía encargo autónomo a Claude
Code, con el motor `99_reorganizar_estructura.R` adaptado de la plantilla de
`herramientas_dev/` (se reutilizó su Fase 3 de reescritura con `.bak` y CSV, y se
añadió un bloque de movimientos propio, porque la Fase 2 original absorbe *hacia*
`activa/` y este caso crea subcarpetas *dentro* de `activa/`). El diagnóstico de
referencias disparó la regla de detención (a) por una referencia a un encargo en un
archivo NO-`.md` (un comentario de procedencia en `reorganizar_universo_idps.R`); se
resolvió con la opción de no reescribirla (el `.R` se archiva a `_archivo/`, donde las
rutas históricas se preservan, política §1.6). El ciclo DRY_RUN→real cuadró exacto
(12 reescrituras esperadas == 12 reales), los 16 movimientos quedaron como renames git
(historial intacto), la integridad referencial quedó verde (0 refs a la ruta vieja) y
los 6 invariantes 🔒 pasaron con evidencia. Se desplegó tras gate pre-push del titular
(`681783d..50c3dd4`, 2 commits, local==origin `50c3dd4`). El set no toca `docs/` ni el
motor: el sitio en vivo es idéntico.

---

## 3. Estado al cierre

### Qué funciona
- **Repo ordenado y sincronizado** (P-ORG en repo): `origin/main` = `50c3dd4`,
  working tree limpio, local==origin. Última ejecución exitosa: push de P-ORG
  verificado (`git status -sb` sin ahead/behind).
- **Estructura de `50_documentacion/activa/`:** la raíz contiene solo protocolo
  (`POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`,
  `prompt_nuevo_proyecto_idps.md`) + artefactos vivos (`backlog_historico.md`,
  `backlog_volcado_crudo.md`, `censo_universo_idps.md`) + subcarpetas (`decisiones/`,
  `prototipos/`, `encargos/`). Cero `encargo_*.md` sueltos.
- **Raíz del repo limpia:** sin `verificar_*.R` ni `reorganizar_universo_idps.R`;
  archivados en `_archivo/20260622/` (8 + el propio `99_reorganizar_estructura.R`).
- **Integridad referencial:** 0 referencias a la ruta vieja de encargos; las 12
  referencias reescritas apuntan a archivos que existen en disco.
- **Motor desplegado intacto** (heredado de s15, NO tocado en s16): el sitio en vivo
  sigue siendo el build de P-PALETA-v2 (`4958558d…`, HEAD de contenido `ed240a6`); el
  push de s16 no modifica `docs/`.
- **Dato (parquet `idps_largo.parquet`, md5 `4c764d8c…`):** intacto, ni se leyó.

### Qué no funciona / queda a medias
- Nada roto. Los pendientes abiertos no son fallas, son trabajo no iniciado:
  P-SUITEDOC-INLINE (repo del paquete) y afinaciones menores de s15 (ver §11).

### Delta respecto a v15
- **P-ORG:** de ABIERTO (titular, v15) a **DESPLEGADO y CERRADO**.
- **Estructura del repo:** de desordenada (encargos + scripts mezclados) a ordenada
  (encargos en `activa/encargos/`, scripts en `_archivo/`).
- **P-SUITEDOC-INLINE:** sigue ABIERTO (no se abordó esta sesión; requiere el código
  fuente del paquete `suitedoc`, no disponible en s16).
- **Afinaciones menores de s15** (tono de la suite, `# REVISAR` estético de la rampa):
  siguen DIFERIDAS.

---

## 4. Registro detallado de cambios (sesión 16)

> Numeración global continúa en `backlog_historico.md`. La entrada de s16 es el
> cambio **107**.

**C1 (#107) — P-ORG: reorganización del directorio del proyecto**
[limpieza / deuda técnica — migración de estructura; desplegado]. Encargo autónomo a
Claude Code (`encargo_org_s16.md`, en `activa/encargos/` tras la propia migración).
Una solicitud del titular (ordenar el directorio), ejecutada bajo protocolo 4.2:
- **Movimiento de encargos.** Los 16 `encargo_*.md` de la raíz de
  `50_documentacion/activa/` pasan a `50_documentacion/activa/encargos/` (decisión de
  taxonomía aprobada: `activa/encargos/`, no `andamios/encargos/`, porque un encargo
  describe trabajo aprobado, no es un andamio de refactor congelado). Git los detectó
  como **renames** (no D+A): el historial de cada encargo se preserva.
- **Archivado de scripts de andamio.** Los 7 `verificar_*.R` + `reorganizar_universo_idps.R`
  sueltos en la raíz del repo pasan a `_archivo/20260622/`. Eran andamios ejecutados,
  ya gitignorados (movimiento de filesystem sin diff git).
- **Reescritura de referencias.** 12 referencias full-path (`50_documentacion/activa/encargo_X.md`)
  en 12 archivos `.md` (10 logs + `traspaso_v11.md` + `decisiones/20260622_decision_paleta_indicadores.md`)
  reescritas a `…/activa/encargos/encargo_X.md`. Reescritura solo de full-path; las
  menciones bare en prosa (nombre sin ruta) se dejaron intactas (no son paths, son
  referencias textuales). 10 encargos referenciados (paleta=2, verif_integ=2, resto=1);
  6 encargos sin referencias externas solo se movieron.

**Verificación:** DRY_RUN (12 reescrituras esperadas) == real (12) → detención (c) no
se disparó; integridad referencial post-migración 0 refs a la ruta vieja, refs nuevas
existen en disco; `activa/encargos/`=16, raíz sin scripts, `_archivo/20260622/`=8;
parquet md5 inicio==fin; `30_procesamiento/`, `20_insumos/`, `40_salidas/`, `docs/` NO
aparecen en el set. **Desplegado** tras gate pre-push del titular
(`681783d..50c3dd4`, 2 commits, local==origin `50c3dd4`). Commits s16: `f73a07e`
(mover encargos + reescribir referencias, 16 renames + 12 modificaciones), `50c3dd4`
(log). Log: `andamios/logs/20260622_org_s16_log.md`.

---

## 5. Backlog acumulativo

> El backlog vive consolidado en `backlog_historico.md` (numeración global permanente).
> Esta sección referencia el archivo, que es la única fuente de verdad del conteo (A22).

- **Total a v16:** 107 cambios (1–106 a v15; 107 de s16).
- **Delta v16:** +1 entrada (107 P-ORG). Verificado contra el detalle cronológico de
  `backlog_historico.md` (último #106 a v15), no contra la tabla heredada (A22).
- **Taxonomía:** sin categorías nuevas. #107 entra en "Limpieza / deuda técnica"
  (11 → 12 entradas). Ninguna categoría cruza el 25% ni cae bajo el 2% con este
  cambio; sin subdivisión ni absorción.
- **Nota:** las 3 reconciliaciones de FASE 0 de Claude Code (16 encargos no 19;
  `.DS_Store` no trackeados → `git rm --cached` moot; commits 2–4 vacíos por
  gitignore) NO son cambios: son ajustes de alcance del encargo frente al estado real,
  registrados en §6.

---

## 6. Bugs y hallazgos de la sesión

> Sin bugs de código en s16 (la sesión no tocó código productivo). Se registran los
> hallazgos de reconciliación entre los supuestos del encargo y el estado real, por
> trazabilidad.

**Hallazgo 1 — conteo de encargos sobreestimado en el encargo.** El encargo asumía 19
`encargo_*.md`; el estado real eran 16. Sin impacto: se movieron los 16 reales y el
DRY_RUN lo confirmó antes del modo real. **Regla:** los conteos del encargo son
estimaciones del redactor; el Paso 0 de lectura del estado real (no modificar sin leer)
es el que manda. Principio: B.1 (no operar sobre estado supuesto).

**Hallazgo 2 — `.DS_Store` no trackeados.** El encargo previó `git rm --cached` de
`.DS_Store` versionados; el diagnóstico mostró que ninguno está trackeado (ya cubiertos
por `.gitignore` L20). El paso quedó moot, no se ejecutó. **Regla (A20):** el escáner
lista el filesystem, no el índice git; verificar con `git ls-files` antes de asumir que
algo está versionado. El `.DS_Store` aparecía en el escáner pero no en el índice.

**Hallazgo 3 — detención (a): referencia a encargo en archivo NO-`.md`.** El
diagnóstico de alcance halló `# Encargo: …encargo_claude_code_idps_organizacion.md` en
`reorganizar_universo_idps.R:4`, un comentario de procedencia. Claude Code se detuvo y
reportó (correcto). **Resolución del titular:** no reescribir ese comentario; el `.R` se
archiva a `_archivo/`, donde las rutas históricas se preservan intactas (política §1.6:
reescribir rutas en andamios falsifica el registro). La referencia viva que importa para
integridad son los `.md`, que sí se reescribieron. **Regla aprendida (A16-1):** una
referencia a un artefacto movido dentro de un archivo que a su vez se archiva a
`_archivo/` NO se reescribe — los archivos congelados conservan sus rutas históricas; la
reescritura solo aplica a referencias en documentación viva.

**Hallazgo 4 — CSV de log con esquemas mixtos.** `_archivo/log_reorganizacion.csv`
preexistía de s10 (9 columnas); el script de s16 appendeó 36 filas con su esquema
(5 columnas) → CSV con esquemas heterogéneos. Es scratch gitignorado, no entra al repo
ni a ninguna verificación. Sin acción; anotado en pendientes menores (§11).

---

## 7. Aprendizajes y restricciones descubiertas

- **A16-1 (no reescribir referencias en archivos que se archivan a `_archivo/`).** Ver
  Hallazgo 3. Cuando un artefacto se mueve y otro archivo lo referencia, pero ese otro
  archivo a su vez se archiva a `_archivo/`, su referencia NO se reescribe: los archivos
  congelados preservan rutas históricas (política §1.6). Solo se reescriben referencias
  en documentación viva (logs, traspasos, decisiones vigentes). Principio: §1.6 (no
  falsificar el registro histórico).
- **A16-2 (adaptar la plantilla, no forzar el caso en sus bloques).** La plantilla
  `99_reorganizar_estructura_PLANTILLA.R` tiene una Fase 2 que absorbe documentación
  *hacia* `activa/` (caso de migración inicial). El caso de P-ORG (crear subcarpetas
  *dentro* de `activa/` y mover a ellas) no encaja en sus bloques A–E. Lo correcto fue
  reutilizar su patrón canónico (DRY_RUN, `.bak`, CSV, Fase 3 de reescritura con
  `extensiones_a_escanear <- "\\.md$"`) y añadir un bloque de movimientos propio, no
  forzar el caso en bloques que no lo cubren. Principio: B.2 (simplicidad: el patrón
  reutilizable es el ciclo DRY_RUN, no la forma exacta de los bloques de ejemplo).
- **A16-3 (el conteo de `ls -R` puede miscontar `.bak`).** En FASE 4 un `ls -R` reportó
  0 `.bak` donde debían existir 12; un `find` explícito los localizó (el `ls -R` los
  miscontó por la forma de listar subdirectorios). **Regla:** para verificar la
  existencia de archivos generados, usar `find`/`fd` con patrón explícito, no confiar en
  un `ls -R` agregado. Principio: A20 (verificar el filesystem con la herramienta
  correcta), verificación barata antes de afirmar.

---

## 8. Decisiones de diseño

- **D-s16-ENCARGOS-ACTIVA (encargos a `activa/encargos/`, no a `andamios/encargos/`).**
  Los 16 `encargo_*.md` se agrupan en `50_documentacion/activa/encargos/`. Alternativa
  (`andamios/encargos/`, junto a sus logs gemelos) descartada: un encargo describe
  trabajo aprobado y es insumo de consulta vivo, no un andamio de refactor congelado
  (los andamios son los logs de ejecución, que ya viven en `andamios/logs/`).
  Decisión del titular.
- **D-s16-NO-REESCRIBIR-ARCHIVADO (caso a).** El comentario de procedencia en
  `reorganizar_universo_idps.R` apuntando a la ruta vieja de un encargo NO se reescribe,
  porque el `.R` se archiva a `_archivo/` y los archivos congelados preservan rutas
  históricas (política §1.6). Alternativa (reescribir el comentario antes de archivar)
  descartada: cosmética, y violaría la regla de no reescribir rutas en material
  congelado. Decisión del titular (opción 1). Formaliza A16-1.

---

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | Sin cambio (ni se leyó en s16). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| md5 build **desplegado** | `4958558d0e0ea21c05eb442f561bfaca` | `docs/index.html` en vivo | Sin cambio (s15; s16 no toca `docs/`). |
| HEAD remoto (`origin/main`) | `50c3dd4` | repo | **Nuevo (s16): cierre de P-ORG.** Reemplaza `ed240a6` (HEAD de contenido del motor, s15, intacto en el árbol). |
| Establecimientos (motor) | 9136 | JSON | Sin cambio. |
| Paleta indicadores (folleto) | Autoestima `#3858A3`, Convivencia `#61BDC6`, Participación `#4BA560`, Hábitos `#AACB58` | `35` L46 | Sin cambio (s14). |
| Factores rampa de niveles | `RAMP_BAJO=0.45`, `RAMP_MEDIO=0.12`, `RAMP_ALTO=0.22` | `35_motor_template.html` | Sin cambio (s15). |
| Total backlog (global) | 107 cambios (1–107) | `backlog_historico.md` | **+1 (s16): P-ORG #107.** |

---

## 10. Arquitectura de archivos

Estructura conforme a la política, ahora más ordenada. Cambios de s16:
`50_documentacion/activa/encargos/` (subcarpeta nueva, 16 encargos como renames git);
8 scripts de andamio movidos de la raíz a `_archivo/20260622/` (+ el propio
`99_reorganizar_estructura.R` archivado en FASE 5); 12 `.md` con referencias full-path
reescritas. Raíz de `activa/` despejada (solo protocolo + artefactos vivos +
subcarpetas). Raíz del repo sin scripts sueltos. **El motor, el parquet, `20_insumos/`,
`40_salidas/` y `docs/` NO cambiaron.** Escáner al cierre: ejecutar antes de la próxima
apertura (el de apertura, snapshot `20260622_141236`, ya no refleja la nueva estructura;
**re-correr `00_escanear_proyecto.R` y versionar el snapshot de cierre**).

> **Registro de ejecución detallado:** `50_documentacion/andamios/logs/20260622_org_s16_log.md`
> (log de la sesión de Claude Code de P-ORG; detalle paso a paso no reproducido aquí).

**Deuda de higiene resuelta en s16:** la mezcla de encargos en `activa/` y los scripts
sueltos en la raíz (objeto de P-ORG en v15 §11) quedaron resueltos. Deuda menor
remanente: `_archivo/log_reorganizacion.csv` con esquemas mixtos (scratch gitignorado;
§11).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-SUITEDOC-INLINE — Integrar el inlining autocontenido al paquete `suitedoc` (heredado
de v15, titular).**
- **Descripción:** que `generar_suite()` produzca los HTML ya autocontenidos (CSS +
  fuentes + assets embebidos en base64), eliminando el paso manual de `inline_suite.R` y
  evitando que cada proyecto con `suitedoc` arrastre los 2 bugs de s15 en su copia.
- **Origen:** los 2 fixes de `inline_suite.R` de s15 (A15-1 regexec; A15-2 quitar saltos
  del base64) son la lógica probada a portar. El bug A15-2 es latente en el propio
  paquete si embebe fuentes.
- **Insumo imprescindible:** código fuente de `suitedoc` (`generar_suite()` + los
  builders que escriben el HTML y enlazan el tema). Sin él, el punto de integración se
  inventaría (B.1). **No estuvo disponible en s16.**
- **Tipo:** BIBLIOTECA sobre el paquete `suitedoc` — **repo distinto de `slep_idps`**.
- **Decisión de diseño abierta:** ¿`generar_suite()` produce solo HTML autocontenidos
  (reemplaza el modelo tema-enlazado) o ambos (base para edición + standalone para
  compartir)?
- **Complejidad:** Media. **Precaución:** afecta a todos los proyectos con `suitedoc`
  (`slep_simce_adecuado`, `slep_categoria_desempeno`, etc.); una vez integrado, regenerar
  sus suites para que hereden el fix.
- **Criterio de éxito sugerido:** `generar_suite()` emite HTML que abren con estilo desde
  cualquier carpeta sin paso manual; los 2 bugs de s15 imposibles de reintroducir.

**Afinación de tono de la suite (menor, heredado de v15, titular).** 2 marcas
`# REVISAR (voz)` en `documentar.R` (L311 prosa de documentos; L370 títulos/intros de
sección) + uso de "colegio" como genérico en `doc_que` (L315 prosa técnica, infringe
regla 4.6.3.6) + L306 (FAQ, excepción válida de voz del lector). Editar `documentar.R`,
regenerar (`documentar.R` → `inline_suite.R`). No bloquea (suite interna).

**`# REVISAR` estético de la rampa (menor, heredado de v15, titular, A14-2).** OK
estético del titular sobre las 3 superficies de la rampa de niveles. Si se quiere más
separación visual entre segmentos, evaluar un separador fino (hairline) entre `span` —
decisión nueva, no implementada.

**Higiene del CSV de reorganización (menor, nuevo, s16).** `_archivo/log_reorganizacion.csv`
quedó con esquemas mixtos (9 col de s10 + 5 col de s16). Scratch gitignorado, sin
impacto. Si se quiere log limpio, regenerar con un esquema único. Trivial; difiérase.

### Evaluación de deuda técnica
- **`50_documentacion/activa/` y raíz del repo:** deuda de desorden **resuelta** por
  P-ORG (era el objeto del pendiente).
- **`inline_suite.R`:** corregido en s15; su lógica debe migrar al paquete
  (P-SUITEDOC-INLINE) para no vivir duplicada en cada proyecto. Único frente de deuda
  estructural abierto.

### Auditoría de cierre (política 5.6)
- Pipeline corre de cero sin intervención: **Sí** (s16 no tocó el pipeline; sigue
  reproducible).
- Outputs reproducibles/idempotentes: **Sí** (s16 no generó outputs de datos; el
  motor y el parquet están intactos).
- Decisiones metodológicas como constantes nombradas: **No aplica** (s16 no introdujo
  lógica de cálculo).
- Nombres sin tildes/ñ/espacios: **Sí** en lo canónico (la nueva subcarpeta `encargos/`
  cumple; andamios de diseño con espacios son congelados, excepción declarada).
- Estructura respeta la política: **Sí** — la deuda de P-ORG (la única anotada en v15)
  quedó resuelta. Escáner de cierre pendiente de re-correr (anotado en §10).

### Ruta sugerida para la sesión 17
1. **Apertura CONTINUATION** con este v16 + `backlog_historico.md` + escáner **re-corrido
   al cierre de s16** + protocolo de la KB.
2. **Foco recomendado: P-SUITEDOC-INLINE.** Es el único pendiente de deuda estructural y
   beneficia a todos los proyectos con `suitedoc`. **Requiere adjuntar el código fuente
   del paquete `suitedoc`** (imprescindible; sin él no se puede empezar). Si el titular no
   lo tiene a mano o prefiere otro frente, alternativa: cerrar las afinaciones menores de
   la suite (tono + hairline de la rampa) en una sesión corta dedicada.
   **Recomendación:** P-SUITEDOC-INLINE si el titular puede adjuntar el código del paquete;
   si no, diferirlo y no abrir sesión hasta tenerlo (no tiene sentido abrir sin el insumo
   imprescindible).
3. **Diferir:** afinaciones menores (tono de la suite, hairline de la rampa, CSV de
   reorganización) salvo que se elijan explícitamente como foco liviano.

---

## 12. Instrucciones específicas para la próxima sesión

- 🔒 El dato está verificado a nivel CENSO (s11) y la fidelidad parquet→sitio también
  (s12, re-confirmada en s14/s15). NO re-auditar ni regenerar el parquet. md5 `4c764d8c…`.
- 🔒 El motor **desplegado** es el de P-PALETA-v2 (build `4958558d…`); s16 NO lo tocó. El
  HEAD remoto es `50c3dd4` (cierre de P-ORG), pero el contenido del motor sigue en el
  estado de `ed240a6`. El repo está sincronizado con origin.
- 🔒 Cualquier cambio de `35` exige REGENERAR y RE-VERIFICAR fidelidad censal antes de
  desplegar. NO desplegar a ciegas.
- 🔒 **Identidad de indicador es regla:** todo lo cromático de un indicador vive en su
  familia de color. NO introducir paleta semáforo ni colores ajenos (D-s15-RAMPA).
- 🔒 **StackedBar (estado vs GSE) es intocable:** codifica significancia
  (`--alerta/--st-neutro/--destaca`), NO niveles. No confundir con la rampa de niveles.
- 🔒 D-s15-RAMPA, D-s15-SEPARADOR, D-s15-LEYENDA-NEUTRA, D-s15-SUITE-INTERNA,
  D-s15-TEMA-VERSIONADO, D-s16-ENCARGOS-ACTIVA, D-s16-NO-REESCRIBIR-ARCHIVADO están
  DECIDIDAS. No reabrir sin decisión explícita del titular.
- 🔒 **Encargos viven ahora en `50_documentacion/activa/encargos/`** (no en la raíz de
  `activa/`). Las referencias en logs/traspasos apuntan a la ruta nueva. Al redactar un
  encargo nuevo, ubicarlo ahí.
- 🔒 **No reescribir rutas en archivos de `_archivo/`** (A16-1): los archivos congelados
  preservan rutas históricas (política §1.6).
- ⚠️ NO inventar significancia/GSE/geo donde el dato trae NA (vigente desde v11).
- ⚠️ P-SUITEDOC-INLINE es sobre el repo del paquete `suitedoc`, NO sobre `slep_idps`;
  requiere el código fuente del paquete como insumo imprescindible.
- ✅ ANTES de abrir s17, RE-CORRER `00_escanear_proyecto.R` (el escáner de apertura de
  s16 no refleja la nueva estructura) y versionar el snapshot de cierre.
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atómicos por ruta;
  nunca `git add .`/`-u`.
- 🔒 El backlog vive en `backlog_historico.md` (107 cambios, 1–107). Actualizarlo en
  CADA cierre; NO volver a diferir el conteo (A22/A14-3).

---

## 13. Fragmentos de código de referencia

**Reescribir referencias de ruta en `.md` con el motor de la plantilla (patrón P-ORG):**
```r
# Reutiliza la Fase 3 de 99_reorganizar_estructura_PLANTILLA.R, cambiando solo la
# extensión a escanear. Para reescribir referencias en documentación (no en código),
# usar .md, NO .R. Genera .bak por archivo y registra en _archivo/log_reorganizacion.csv.
extensiones_a_escanear <- "\\.md$"
# Las parejas de reemplazo se derivan del DIAGNÓSTICO de referencias (FASE 1),
# nunca se inventan patrones que el diagnóstico no encontró (B.1).
# Excluir SIEMPRE /_archivo/ y /andamios/diseno/; NO excluir andamios/logs/ ni
# traspasos/ (ahí viven las referencias vivas a reescribir).
```

**Verificar integridad referencial tras mover artefactos (patrón P-ORG):**
```bash
# 0 resultados = integridad referencial OK (ninguna referencia apunta a la ruta vieja).
grep -rn "activa/encargo_" /Users/tomgc/Projects/slep_idps/50_documentacion/{andamios/logs,traspasos} \
  --include="*.md"
# Confirmar además que las rutas NUEVAS existen en disco (no basta con que la vieja no aparezca).
```

**Localizar archivos generados con `find`, no con `ls -R` (patrón A16-3):**
```bash
# ls -R puede miscontar archivos en subdirectorios; find con patrón explícito es fiable.
find /Users/tomgc/Projects/slep_idps -name "*.bak" -type f
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 17 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (política +
  SETTINGS) vive en la knowledge base y se lee desde ahí. Adjunto el traspaso v16, el
  backlog histórico consolidado (107 cambios) y el escáner actual (re-corrido al cierre
  de s16). El motor con la rampa de niveles (P-PALETA-v2) sigue desplegado e intacto; el
  repo está sincronizado con origin (HEAD `50c3dd4`, cierre de P-ORG). El parquet está
  blindado (md5 `4c764d8c…`). La estructura del repo quedó ordenada (encargos en
  `activa/encargos/`, scripts de andamio en `_archivo/`). Foco propuesto:
  **P-SUITEDOC-INLINE** (integrar el inlining autocontenido al paquete `suitedoc` — repo
  del paquete, **adjunto su código fuente**). Si no traigo el código del paquete, foco
  alternativo: afinaciones menores de la suite y la rampa."
- **Documentos para la sesión 17, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que esté al
     día): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según el foco:*
     - Si P-SUITEDOC-INLINE: el **código fuente del paquete `suitedoc`** (`generar_suite()`
       + builders; **imprescindible**, sin él no se abre la sesión); `inline_suite.R`
       corregido (la lógica a portar, en `50_documentacion/suite/`);
       `encargo_autonomo_claude_code_v1.md` si habrá encargo.
     - Si afinaciones menores: `documentar.R` (en `50_documentacion/suite/`);
       `35_motor_template.html` si se aborda el hairline de la rampa.
  3. *Específicos de la sesión (SÍ se adjuntan):* `traspaso_cierre_v16.md`;
     `backlog_historico.md`; `estructura_actual.md` (re-corrido al cierre de s16).
- **Nota final:** RE-CORRER `00_escanear_proyecto.R` antes de cerrar s16 / abrir s17, para
  que el escáner refleje la nueva estructura (`activa/encargos/`, scripts en `_archivo/`).
  Si `inline_suite.R`, `documentar.R` o `35_motor_template.html` cambian entre sesiones,
  adjuntar la versión más reciente y avisarlo en la apertura. El backlog histórico debe
  estar en 107 (entrada 107) al abrir s17.
