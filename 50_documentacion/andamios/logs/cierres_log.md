# Log de cierres — `slep_idps`

> Archivo acumulativo único: una sección por cierre, anexada al final. Lo escribe el
> ejecutor del instrumento de cierre (`cierre_sesion_autonomo_cc_v*.md`); la tabla de
> rótulos que disparó en la última sección es el catálogo aplicable del cierre siguiente.

## v29 — 2026-09-17

Instrumento: cierre_sesion_autonomo_cc_v14.md | kit 965ddd3

**F0.0.** kit: sincronizado (`fetch` + `merge --ff-only`, sin trackeados sucios).
normativos: POLITICA_PROYECTO.md al día (5.8 = 5.8); SETTINGS_Y_PROMPTS_OPERACIONALES.md
**actualizado desde el kit** (proyecto v34 → kit v37). Nota estructural de este repo: los
dos normativos están en `.gitignore` (commit `f860d4d`), así que la copia se hizo en F6 pero
no pudo entrar al commit de documentación.

Primer cierre instrumentado del repositorio: no había `cierres_log.md` ni ningún commit
`docs(cierre)`. En este mismo turno hubo una detención previa en F5 por un paquete
redactado contra SETTINGS v34 (`paquete_cierre_slep_idps_v29.md`: dos bloques, sin
`reparto`, sin marcadores); el titular lo reemitió contra v37 y este es el cierre que corrió.

### Tabla de severidades

| condición | severidad | resultado |
|---|---|---|
| F0.0 kit sincronizado | ADVIERTE | pasa |
| F0.0 normativos | REPARA | reparada: SETTINGS `> **Versión 34.**` → `> **Versión 37.**` (copiado en F6; gitignorado, no entra al commit) |
| F0.1 `.git` y `traspasos/` | BLOQUEA | pasa |
| F0.2 un solo paquete; cuatro delimitadores; cero placeholders | BLOQUEA | pasa (`paquete_cierre_v29.md`, 445 líneas) |
| F0.2 campo derivado con valor | ADVIERTE | pasa (ninguno) |
| F0.3 `raiz_proyecto` = `pwd` | BLOQUEA | pasa |
| F0.4 correlativo triple (v29 = paquete = máx v28 + 1) | BLOQUEA | pasa |
| F0.5 `n` = `backlog_entradas_nuevas` | BLOQUEA | pasa (9 = 9; patrón de entrada `- **#[0-9]+** —`) |
| F0.5 numeración provisional contigua | BLOQUEA | pasa (148→156) |
| F0.5 desplazamiento `k` | REPARA | no aplica: `U` = 147, `k` = 0 |
| F0.5 formato de entrada = último bloque en disco | ADVIERTE | advertencia: en disco las entradas van inline dentro del bullet de sesión (`- **Sesión 25** (…): cambios **145–147** … **145** …; **146** …`); el paquete trae un bullet por entrada. Se insertaron byte a byte bajo el encabezado compuesto, como lista plana |
| F0.5 `sesion_nueva` = última en disco + 1 | ADVIERTE | advertencia: 30 ≠ 26 (el Detalle y el Resumen terminan en la Sesión 25; los traspasos v26–v28 existen sin fila; el traspaso v29 declara que cubre s29 y s30) |
| F0.5 `fecha_cierre` = fecha de la máquina | ADVIERTE | pasa (2026-09-17) |
| F0.5 referencias cruzadas al rango provisional | ADVIERTE | no aplica (`k` = 0) |
| F0.5 `sello_escaner`, `escaner` | BLOQUEA | pasa (`regenerar`; `00_escanear_proyecto.R`) |
| F0.5 `push_autorizado` | BLOQUEA | pasa (`si`) |
| F0.5bis `reparto` (9 líneas = provisionales; categorías; control positivo) | BLOQUEA | pasa: 6 → "Visualización / diseño — rediseño UI" (existe, 50), 3 → "Exportación de datos" (declarada en `categorias_nuevas`, no existía); `reclasificaciones: ninguna` |
| F0.5ter `recuento_tematico: vigente` | REPARA | no aplica; medido: suma N en disco 147 = `U` |
| F0.6 `settings_version` = kit | BLOQUEA | pasa (`> **Versión 37.**`) |
| F0.6 `compuerta_dudas: 3 registradas` | BLOQUEA / ADVIERTE | pasa (sección presente, 3 filas) |
| F0.7 árbol limpio en lo que el cierre escribe | BLOQUEA | pasa |
| F0.7bis sucio fuera (lista para F7.1) | BLOQUEA (>50 MB / sensible) | pasa; lista: `50_documentacion/activa/50_datos_versionados_autorizados.md` (2.234 B), `50_documentacion/andamios/logs/20260711_contrato_contexto_idps_log.md` (10.139 B; no está trackeado tampoco en `feat/contrato-contexto`) |
| F0.8 `commit_cierre` y `maquina` = `<<EJECUTOR>>` | BLOQUEA | pasa |
| F2 encabezados estructurales únicos | BLOQUEA | `Detalle cronológico` 1, `Resumen estadístico por sesión` 1, `Clasificación temática` 1: pasan. **`Delta del backlog`: el destino no tiene tabla sino ocho secciones `## Delta del backlog (consolidación vNN)` (v14–v25)**; por la letra de v14 es BLOQUEA (encabezado repetido / sin tabla). Se pidió decisión al titular en el mismo turno: **"sección nueva, como las 8 anteriores"**. Se anexó `## Delta del backlog (consolidación v29)` con la misma grafía. Queda como advertencia para la versión siguiente del instrumento (destino con secciones de delta, no tabla) |
| F2 fila del resumen | REPARA | compuesta por el ejecutor e insertada **antes de la fila `**Total**`** (derivada), que se recalculó 147 → 156 y `1–147` → `1–156`. Columna Modelo: `Opus 5` (modelo del ejecutor del cierre; s29/s30 no declararon modelo en su log) |
| F2 encabezado de sesión | — | compuesto desde la grafía de la Sesión 25: `- **Sesión 30** (2026-09-17): cambios **148–156** (detalle en v29 §4 y en el log …; cubre las sesiones 29 y 30 …). <foco>:` |
| F3 catálogo aplicable | ADVIERTE | sin historia previa: los disparos de este cierre lo fundan |
| F3 cifras sin rótulo (zonas declarativas) | ADVIERTE | ver lista abajo; todas (b) históricas legítimas |
| F4 I1 | BLOQUEA | pasa (rangos del Detalle contiguos 1→156) |
| F4 I2 | BLOQUEA | pasa (26 filas suman 156) |
| F4 I2bis | BLOQUEA | pasa (N = 156; % = 101 ± redondeo; 148–156 una vez cada una en `reparto`; sin N < 0) |
| F4 I3 | BLOQUEA | pasa (25 + 1 = 26) |
| F4 I4 | ADVIERTE | ver apariciones abajo |
| F4 I5 | ADVIERTE | advertencia: el TRASPASO §5 dice "Nueve entradas nuevas (#148–156) … Total 147 → 156" y §1 "54 commits" (autoría; se listan, no se reescriben) |
| F4 I6 | BLOQUEA | pasa (0 RUT, 0 OneDrive, 0 credenciales, 0 coautoría, 0 placeholders en backlog, traspaso y ESTADO; también sobre lo staged de F7.1) |
| F4 I7 | BLOQUEA | pasa (tras archivar v01–v28, un solo vigente: v29) |
| F7.1 staging sin rutas excluidas | BLOQUEA | **error del ejecutor, corregido antes de cualquier registro:** el primer intento commiteó también los 28 renames que `git mv` (F6) había dejado en el índice, porque la guardia contó 28 rutas excluidas y no detuvo. Se deshizo ese commit local (`reset --soft`, sin push, sin hash citado en ningún archivo), se sacaron los renames del índice y se rehízo con las dos rutas exactas. Lección para la versión siguiente: F6 deja renames en el índice; F7.1 debe limpiarlo o F7.2 ir antes |
| F8 distribución | BLOQUEA | pasa (TRASPASO, ESTADO con marcadores y BACKLOG_ENTRADAS byte a byte, `k` = 0); paquete eliminado |

renumeracion: sin desplazamiento (`U` = 147; provisionales 148→156; `k` = 0).

### Rótulos (F3) — disparos de este cierre = catálogo aplicable del siguiente

| ID | rótulo | disparos | resultado |
|---|---|---|---|
| R1 | encabezado: "Total reconciliado: N cambios" | 1 | 147 → 156 |
| R11 | encabezado: "consolidado a vNN (fecha)" | 1 | v25 (2026-06-25) → v29 (2026-09-17) |
| R12 | título y tabla de Clasificación temática | 15 | título "actualizada a v29, sobre 156 cambios"; 13 filas recalculadas (N y %) + 1 fila nueva |
| catálogo no aplicable (cero disparos) | R2, R3, R4, R5, R6, R7, R8, R9, R10, R13 | (10 de 13) | el archivo no tiene mapa de tramos, cabeceras con rango ni notas de cierre con cifra |

cifra sin rotulo (zonas declarativas; todas clasificadas (b) histórica legítima): "deuda A22 … desde v10 … v10–v13 … sesión 14 … 14 traspasos … v07/v08/v09" (encabezado, nota de reconstrucción v14); "sesiones 1–9 … total 83 a v09 … v10–v13 … (84–100) … s14 (101–104)" (nota de reconciliación A22 del Resumen); "heredada de v09 (10 categorías) … v10–v14" (nota de la tabla temática); "supera el 25% desde v21 … sus 50 entradas … Total 50 … las 35 entradas desde #105 … Las 15 entradas … las 50 salen del correlativo … suma interna 50" (vista analítica de Rediseño UI, lente fechado a v25 que este cierre no actualiza y así lo declara en el delta v29); "tabla 109 vs correlativo 110 … 14→15 … 110" (cierre P-BACKLOG-INTEGRIDAD, s19); "(6%) … (3%) … (1%) … 2%" (refinamientos v14).

### Invariantes (F4)

I1 pasa · I2 pasa (156) · I2bis pasa (N 156, % 101) · I3 pasa (26) · I4 advertencia · I5 advertencia · I6 pasa · I7 pasa.

I4 — apariciones de magnitudes viejas (`147`, `v25`, `Sesión 25`, `50 entradas`, `50/147`), todas clasificadas históricas legítimas: fila s25 del Resumen (l.75); descripción de "rediseño UI" "#145–147" (l.103); sub-tabla de la vista analítica "#147" (l.124) y "sus 50 entradas" (l.42 de la zona temática); bullet de la Sesión 25 del Detalle (l.187); sección `Delta del backlog (consolidación v25)` entera (l.413–432); y las citas deliberadas de 147/v25/50/147 dentro del delta v29 nuevo (l.439–458), que son el "antes" del cuadre.

### Clasificación temática resultante (recuento vigente)

| Categoría | N° | % |
|---|---|---|
| Infraestructura y scaffold | 5 | 3% |
| Gobernanza de datos | 5 | 3% |
| Visualización / diseño — motor base/datos | 14 | 9% |
| Visualización / diseño — rediseño UI | 56 | 36% |
| Perfilado / exploración de datos | 4 | 3% |
| Limpieza / deuda técnica | 15 | 10% |
| Documentación conceptual / contenido | 10 | 6% |
| Pipeline / motor (código productivo) | 7 | 4% |
| Saneamiento / calidad de datos de presentación | 15 | 10% |
| Deploy / publicación | 9 | 6% |
| Verificación / auditoría (independiente) | 6 | 4% |
| Decisión / gobernanza de producto | 3 | 2% |
| Documentación de proyecto (suite/política) | 4 | 3% |
| Exportación de datos (nueva) | 3 | 2% |
| **Suma** | **156** | 101% |

### Commits

- hash de trabajo: `981d814` — `chore(sesion 30): trabajo de la sesion` — rutas: `50_documentacion/activa/50_datos_versionados_autorizados.md`, `50_documentacion/andamios/logs/20260711_contrato_contexto_idps_log.md`.
- hash de documentación: `92520eb` — `docs(cierre): traspaso v29 y backlog de sesion` — 34 rutas: 28 traspasos v01–v28 → `traspasos/archivo/` (`git mv`), `traspasos/traspaso_cierre_v29.md` (nuevo), `activa/backlog_acumulativo.md`, `estructura/` (snapshot `20260917_104346_estructura.{md,txt}` nuevo, aliases `estructura_actual.{md,txt}`, poda de `20260703_142007_estructura.{md,txt}`; escáner: 32 carpetas, 306 archivos).
- Escáner: `Rscript 00_escanear_proyecto.R`, exit 0 (con el aviso previo `renv out-of-sync` por `suitedoc`, log de sesión s30 §47.13).
- push: por publicar (al final de F9, junto con el commit del log y el de estado).

## v30 — 2026-09-23

Instrumento: cierre_sesion_autonomo_cc_v15.md | kit c81552c

**F0.0.** kit: sincronizado (`fetch` + `merge --ff-only`, sin trackeados sucios). normativos:
POLITICA_PROYECTO.md al día (5.8 = 5.8); SETTINGS_Y_PROMPTS_OPERACIONALES.md **actualizado desde
el kit** (proyecto v37 → kit v38, INT-047 §2.2.15). Nota estructural heredada: los dos
normativos están en `.gitignore` (commit `f860d4d`), así que la copia se hizo en F6 pero no pudo
entrar al commit de documentación.

**Reintento tras detención previa en el mismo turno lógico:** el primer paquete emitido para
esta sesión citaba `settings_version` = `"> **Versión 37.**"` contra un kit ya sincronizado en
v38 (INT-047, 2026-09-19); F0.6 detuvo en F5 con `BLOQUEA`, árbol real intacto. El titular
reemitió el paquete contra v38 (misma `traspaso_nuevo: v30`); este es el que corrió.

### Tabla de severidades

| condición | severidad | resultado |
|---|---|---|
| F0.0 kit sincronizado | ADVIERTE | pasa |
| F0.0 normativos | REPARA | reparada: SETTINGS `> **Versión 37.**` → `> **Versión 38.**` (copiado en F6; gitignorado, no entra al commit) |
| F0.1 `.git` y `traspasos/` | BLOQUEA | pasa |
| F0.2 un solo paquete; cuatro delimitadores; cero placeholders | BLOQUEA | pasa (`paquete_cierre_v30.md`) |
| F0.2 campo derivado con valor | ADVIERTE | pasa (ninguno) |
| F0.3 `raiz_proyecto` = `pwd` | BLOQUEA | pasa |
| F0.4 correlativo triple (v30 = paquete = máx v29 + 1) | BLOQUEA | pasa |
| F0.5 `n` = `backlog_entradas_nuevas` | BLOQUEA | pasa (4 = 4; patrón de entrada `- **#[0-9]+** —`) |
| F0.5 numeración provisional contigua | BLOQUEA | pasa (157→160) |
| F0.5 desplazamiento `k` | REPARA | no aplica: `U` = 156, `k` = 0 |
| F0.5 formato de entrada = último bloque en disco | ADVIERTE | pasa (bullet `- **#NNN** —`, igual al de #148–156) |
| F0.5 `sesion_nueva` = última en disco + 1 | ADVIERTE | pasa (31 = 30 + 1) |
| F0.5 `fecha_cierre` = fecha de la máquina | ADVIERTE | pasa (2026-09-23) |
| F0.5 referencias cruzadas al rango provisional | ADVIERTE | no aplica (`k` = 0) |
| F0.5 `sello_escaner`, `escaner` | BLOQUEA | pasa (`regenerar`; `00_escanear_proyecto.R`) |
| F0.5 `push_autorizado` | BLOQUEA | pasa (`si`) |
| F0.5bis `reparto` (4 líneas = provisionales; categorías; control positivo) | BLOQUEA | pasa: 157→Limpieza/deuda técnica, 158→Visualización/diseño — rediseño UI, 159→Saneamiento/calidad de datos de presentación, 160→Pipeline/motor (código productivo); las 4 existen en disco; `categorias_nuevas: ninguna`; `reclasificaciones: ninguna` |
| F0.5ter `recuento_tematico: vigente` | REPARA | no aplica; medido: suma N en disco 156 = `U` |
| F0.6 `settings_version` = kit | BLOQUEA | **primer intento: falla** (`v37` del paquete vs `v38` del kit sincronizado) → cierre detenido en F5, árbol intacto. **reintento: pasa** (paquete reemitido con la línea íntegra de `v38`) |
| F0.6 `compuerta_dudas: 4 registradas` | BLOQUEA / ADVIERTE | pasa (sección presente, 4 filas) |
| F0.7 árbol limpio en lo que el cierre escribe | BLOQUEA | pasa |
| F0.7bis sucio fuera (lista para F7.1) | BLOQUEA (>50 MB / sensible) | pasa; lista vacía: árbol limpio salvo el propio paquete |
| F0.8 `commit_cierre` y `maquina` = `<<EJECUTOR>>` | BLOQUEA | pasa |
| F2 encabezados estructurales únicos | BLOQUEA | `Detalle cronológico`, `Resumen estadístico por sesión`, `Clasificación temática`: cada uno 1 vez, pasan. `Delta del backlog`: se repite el criterio de v29 (decisión del titular: sección nueva `## Delta del backlog (consolidación v30)`, misma grafía que las 9 anteriores) |
| F2 fila del resumen | REPARA | compuesta por el ejecutor e insertada antes de `**Total**` (derivada): 156 → 160, `1–156` → `1–160`; columna Modelo: `Opus 5` (declarado en los tres logs de sesión, "Modo real de la sesión: Opus 5 (1M)") |
| F2 encabezado de sesión | — | compuesto desde la grafía de la Sesión 30: `- **Sesión 31** (2026-09-23): cambios **157–160** (detalle en v30 §4 y en los logs …). <foco>:` |
| F2 Clasificación temática | — | recalculada: 4 filas con N y/o % modificados (Limpieza 15→16, Visualización rediseño UI 56→57, Pipeline 7→8, Saneamiento 15→16); las demás filas sin cambio visible de % tras redondeo; título "actualizada a v30, sobre 160 cambios" |
| F3 catálogo aplicable | ADVIERTE | heredado de v29: R1, R11, R12 |
| F3 R1 (encabezado "Total reconciliado: N cambios") | — | 1 disparo: 156 → 160 |
| F3 R11 (encabezado "consolidado a vNN (fecha)") | — | 1 disparo: v29 (2026-09-17) → v30 (2026-09-23) |
| F3 R12 (título y tabla de Clasificación temática) | — | 5 disparos: título + 4 filas recalculadas (N y/o %); las 10 filas sin cambio de texto no cuentan como disparo |
| F3 catálogo no aplicable (cero disparos) | ADVIERTE | R2, R3, R4, R5, R6, R7, R8, R9, R10, R13 (10 de 13); sin cambio respecto de v29 |
| F3 cifras sin rótulo (zonas declarativas) | ADVIERTE | ninguna nueva; las mismas históricas legítimas de v29 (sin tocar) |
| F4 I1 | BLOQUEA | pasa por construcción: 156 contiguos verificados en v29 + 157–160 contiguos anexados = 1→160 |
| F4 I2 | BLOQUEA | pasa (27 filas de datos suman 160, verificado por script) |
| F4 I2bis | BLOQUEA | pasa (N = 160; % suma 102 ± redondeo; 157–160 una vez cada una en `reparto`; sin N < 0) |
| F4 I3 | BLOQUEA | pasa (26 + 1 = 27) |
| F4 I4 | ADVIERTE | ver apariciones abajo |
| F4 I5 | ADVIERTE | advertencia: el TRASPASO §5 dice "Cuatro entradas nuevas (#157–160)" (autoría; se lista, no se reescribe) |
| F4 I6 | BLOQUEA | pasa (0 RUT, 0 OneDrive, 0 credenciales, 0 coautoría, 0 placeholders vivos en traspaso, backlog y ESTADO; también sobre el diff staged de F7.2) |
| F4 I7 | BLOQUEA | pasa (tras archivar v01–v29, un solo vigente: v30) |
| F7.1 staging sin rutas excluidas | BLOQUEA | no aplica: lista de F0.7bis vacía, no hubo commit de trabajo de sesión |
| F7.2 staging sin rutas excluidas | BLOQUEA | pasa: 7 rutas exactas (traspaso nuevo, traspaso archivado, backlog, 4 salidas del escáner); sin `ESTADO.md`, sin el paquete |
| F8 distribución | BLOQUEA | pasa (TRASPASO, ESTADO con marcadores y BACKLOG_ENTRADAS byte a byte, `k` = 0); paquete eliminado |

renumeracion: sin desplazamiento (`U` = 156; provisionales 157→160; `k` = 0).

### Rótulos (F3) — disparos de este cierre = catálogo aplicable del siguiente

| ID | rótulo | disparos | resultado |
|---|---|---|---|
| R1 | encabezado: "Total reconciliado: N cambios" | 1 | 156 → 160 |
| R11 | encabezado: "consolidado a vNN (fecha)" | 1 | v29 (2026-09-17) → v30 (2026-09-23) |
| R12 | título y tabla de Clasificación temática | 5 | título "actualizada a v30, sobre 160 cambios"; 4 filas recalculadas (N y/o %) |
| catálogo no aplicable (cero disparos) | R2, R3, R4, R5, R6, R7, R8, R9, R10, R13 | (10 de 13) | sin cambio respecto del cierre anterior |

cifra sin rotulo: ninguna nueva (las mismas cifras históricas legítimas de v14–v29, sin tocar en este cierre).

### Invariantes (F4)

I1 pasa (por construcción) · I2 pasa (160) · I2bis pasa (N 160, % 102) · I3 pasa (27) · I4 advertencia · I5 advertencia · I6 pasa · I7 pasa.

I4 — apariciones de magnitudes viejas (`156`, `v29`, `Sesión 30`, `56/156`), todas clasificadas históricas legítimas: fila v29 del Resumen (l.76); descripciones de "rediseño UI" y "exportación de datos" con `#148–156` (zona temática); bullet de la Sesión 30 del Detalle; sección `Delta del backlog (consolidación v29)` entera (append-only); y las citas deliberadas de 156/v29 dentro del delta v30 nuevo ("Total 156 → 160", "último #156 a v29"), que son el "antes" del cuadre.

### Clasificación temática resultante (recuento vigente)

| Categoría | N° | % |
|---|---|---|
| Infraestructura y scaffold | 5 | 3% |
| Gobernanza de datos | 5 | 3% |
| Visualización / diseño — motor base/datos | 14 | 9% |
| Visualización / diseño — rediseño UI | 57 | 36% |
| Perfilado / exploración de datos | 4 | 3% |
| Limpieza / deuda técnica | 16 | 10% |
| Documentación conceptual / contenido | 10 | 6% |
| Pipeline / motor (código productivo) | 8 | 5% |
| Saneamiento / calidad de datos de presentación | 16 | 10% |
| Deploy / publicación | 9 | 6% |
| Verificación / auditoría (independiente) | 6 | 4% |
| Decisión / gobernanza de producto | 3 | 2% |
| Documentación de proyecto (suite/política) | 4 | 3% |
| Exportación de datos | 3 | 2% |
| **Suma** | **160** | 102% |

### Commits

- hash de trabajo: ninguno (árbol limpio salvo el paquete al abrir el cierre; F0.7bis dio lista vacía).
- hash de documentación: `131f58a` — `docs(cierre): traspaso v30 y backlog de sesion` — 7 rutas: `traspasos/traspaso_cierre_v30.md` (nuevo), `traspasos/archivo/traspaso_cierre_v29.md` (`git mv`), `activa/backlog_acumulativo.md`, `estructura/` (snapshot `20260923_120220_estructura.{md,txt}` nuevo, aliases `estructura_actual.{md,txt}`, poda de `20260704_222011_estructura.{md,txt}`; escáner: 33 carpetas, 317 archivos).
- Escáner: `Rscript 00_escanear_proyecto.R`, exit 0 (con el aviso previo `renv out-of-sync` por `suitedoc`, pendiente #14 del backlog).
- push: por publicar (al final de F9, junto con el commit del log y el de estado).

