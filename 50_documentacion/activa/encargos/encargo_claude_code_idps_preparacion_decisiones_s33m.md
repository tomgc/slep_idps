# Encargo autónomo: preparación de tres decisiones del titular (s33m)

> Cadena de tres tareas de **solo lectura sobre el motor y los datos**: cada una produce un documento para que el titular decida. No se toca la plantilla, el motor, el pipeline, los datos ni `docs/`. Reemplaza al encargo s33k (su contenido es la T1 de este).

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (cadena en serie que escribe documentos; `encargo_autonomo_claude_code_v1.md` §2.12, fila 1).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `40_salidas/intermedios/idps_largo.parquet`; `30_procesamiento/35_motor_template.html` y `40_salidas/motor_idps.html` (solo lectura); `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` (§5.2); `50_documentacion/activa/POLITICA_PROYECTO.md` y `50_documentacion/activa/SETTINGS_Y_PROMPTS_OPERACIONALES.md` (§4.7, ordenación); `00_escanear_proyecto.R`; `50_documentacion/estructura/estructura_actual.md`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`; `bash` explícito (bash 3.2: toda expresión con `{m,n}` va dentro de un script en `/tmp/s33m_*`); **toda cifra sobre datos se produce en R** (`Rscript`, `arrow`, `dplyr >= 1.1` con `.by=`, pipe nativo, `here::here()` dentro de los scripts); `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260924_preparacion_decisiones_s33m_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s33m` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** el motor no cambia (md5 de `40_salidas/motor_idps.html` y de `docs/index.html` iguales al de FASE 0); los scripts R corren dos veces con la misma salida (md5).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** R es el único lenguaje de los scripts que quedan versionados; commits en español; `git add` con rutas explícitas; los documentos **no deciden**: presentan evidencia y alternativas; la decisión es del titular.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. El md5 del motor o de `docs/` cambia en cualquier momento → detén la sesión (este encargo no debe tocarlos).
4. En T1, la réplica en R de `repartoInd` no coincide con el motor en los controles (M4) → congela T1.
5. En T3, cualquier comando que mueva, renombre o borre un archivo → prohibido; la tarea solo propone.
6. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (fila 8 agregada por el redactor), en un solo commit (`chore(encargo): s33m y registro del asistente s33`).
- `git commit` de los archivos del ALCANCE de cada tarea, tras su cierre de fase.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33m_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular, ni `git mv`, ni `mv`, ni `rm`, ni ramas nuevas, ni `reset`, `restore` o `checkout`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `8571c2e`, el `docs(log)` de s33l (fuente: `.git/refs` leídos por el redactor). El registro del asistente s33 tiene 8 filas; la 8 la agregó el redactor sin commitear (fuente: `grep -c` del redactor). Motor y `docs/` = `7ad76f36e42d66c4da2d71aa28a558eb` (fuente: `md5sum` del redactor tras s33h).
- **T1.** En la barra 0–100 de una entidad territorial del comparador, `N` = establecimientos del roster (nivel y año) de esa entidad, en ese GSE, con `prom` no nulo **y** `sigdifgru` ∈ {−1, 0, 1}; los de `sigdifgru` nulo se cuentan aparte (`sin`) (fuente: `sed` del redactor sobre `repartoInd`). La pantalla muestra `N` solo en el `title` de la barra ("100% = N establecimientos con comparación válida") (fuente: `grep -n` del redactor). §5.2 de la decisión de contraste: la marca de base pequeña son dos piezas (N visible y marca bajo un umbral) y el umbral lo fija el titular (fuente: `sed` del redactor). Las columnas del parquet son hipótesis (M3).
- **T2.** Hoy solo el radar de la ficha se exporta como imagen (SVG y PNG: `exportarRadarSVG`, `exportarRadarPNG`); es el único gráfico SVG del motor. Las barras del panorama y del comparador (`StackedBar`, `.s100`, barras de puntaje) son HTML (fuente: `grep -n` del redactor y CLAUDE.md del proyecto, sección de exportación s30). El pendiente 7 (P-EXPORTACION-IMAGEN) dice: exportar como imagen el comparador y el panorama exige que la imagen la produzca el mismo dibujante que la pantalla (fuente: traspaso v31 §11, fila 7).
- **T3.** No existe `50_documentacion/activa/50_ordenacion_repositorio.md` (gatillo 4bis encendido); `traspasos/` tiene 1 vigente y `traspasos/archivo/` 30 archivos; hay 4 archivos con tildes o espacios en `50_documentacion/andamios/diseno/` (congelados, deuda heredada) (fuente: `ls` del redactor y traspaso v31 §11). El protocolo es SETTINGS §4.7 (cuatro bloques; propuesta aprobada antes de ejecutar; grados de certeza; grep de referencias vivas; `andamios/` congelado).

## 2. Contexto mínimo

Quedan tres pendientes que no se pueden ejecutar sin una decisión del titular: el umbral de base pequeña (5), el diseño de la exportación de imagen (7) y la lista de movimientos de la ordenación (12). Este encargo prepara las tres decisiones en una sola corrida para que el titular las tome juntas y el siguiente encargo ejecute todo de una vez.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Motor, datos y publicado intactos:** md5 de `40_salidas/motor_idps.html` y de `docs/index.html` = FASE 0; `git diff <inicio>..HEAD -- 10_utils 20_insumos 30_procesamiento 40_salidas docs | wc -l` → `0`.
2. **Solo documentos:** `git diff --name-only <inicio>..HEAD` ⊆ unión de los ALCANCE (más el LOG).
3. **La N del diagnóstico es la N de la pantalla:** 12 barras de control (M4) iguales entre la réplica en R y el `title` del motor.
4. **Nada se movió:** `git diff --name-status <inicio>..HEAD | grep -c '^R'` → `0` y `git ls-files | wc -l` crece solo en los archivos nuevos del ALCANCE.

## 4. Grafo de tareas y ALCANCE

- **T1** (diagnóstico de base pequeña) · ALCANCE: `50_documentacion/andamios/diseno/detalles/20260924_diagnostico_base_pequena.R` y `…/20260924_diagnostico_base_pequena.md`.
- **T2** (mockup y diagnóstico técnico de la exportación de imagen) · ALCANCE: `50_documentacion/andamios/diseno/detalles/mockup_exportacion_imagen_s33m.html` y `…/20260924_diagnostico_exportacion_imagen.md`.
- **T3** (propuesta de ordenación, sin mover nada) · ALCANCE: `50_documentacion/andamios/20260924_propuesta_ordenacion_repositorio.md`.
- Las tres son independientes; se ejecutan T1 → T2 → T3. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD`; mensaje de `HEAD~1` | `HEAD~1` = `8571c2e` = `origin/main`; `0`; `1`; empieza por `docs(log): s33l` | regla 2 |
| M3 | md5 del motor y de `docs/`; en R: `names()`, tipos y `nrow()` del parquet (lectura validada) | `7ad76f36…` los dos; las columnas registradas | regla 3; residual si faltan columnas de §1 |
| M4 | **Control de la réplica (T1):** 12 barras (una comuna, el SLEP foco, una región y nacional; 3 combinaciones de GSE e indicador cada una) en el año más reciente de 4° básico: `N` en R frente al `title` en el motor (Puppeteer) | iguales en las 12 | regla 4 |
| M5 | **Inventario de gráficos (T2):** en el motor, cada componente que dibuja una barra o un gráfico, con su tecnología (HTML o SVG), su pantalla y si hoy tiene exportación | lista registrada; solo el radar con exportación | residual |
| M6 | **Inventario de ordenación (T3):** `ls 50_documentacion/traspasos/*.md | wc -l`; archivos de `50_documentacion/` fuera de las decenas de POLITICA §1; nombres con tildes, `ñ`, espacios o guion medio (`git ls-files`); si `00_escanear_proyecto.R` excluye `node_modules/`, `packrat/` y `venv/` | cifras y listas registradas | residual |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: diagnóstico de base pequeña (pendiente 5)

1. Script R con la réplica de `repartoInd` validada en M4. Para cada nivel, su año más reciente, cada tipo de entidad (comuna, SLEP, región; nacional aparte), cada entidad, cada GSE con al menos un establecimiento y cada indicador: `N`, `sin` y total del roster.
2. Informe (sin nombres de establecimiento ni RBD): barras por tipo y nivel; distribución de `N` (mínimo, cuartiles, máximo) por tipo; para umbrales 5, 10, 15, 20 y 30, cuántas barras y qué porcentaje quedarían marcadas, por tipo y nivel; el SLEP foco y sus cuatro comunas barra por barra; cuántas barras tienen `N` = 0 con `sin` > 0; sección final "Lo que el titular decide", **sin recomendar un número**.
3. Verificación: 🔒3; dos corridas con el mismo informe (md5); suma de barras por tipo re-contada por otra vía en R.
4. Commit `docs(diagnostico): base pequena en las barras del comparador (s33m T1, pendiente 5)`.

### T2: mockup y diagnóstico de la exportación de imagen (pendiente 7)

1. Diagnóstico técnico (documento): qué dibuja hoy cada pantalla (M5); qué exigiría exportar el comparador y el panorama como imagen bajo la regla "un solo dibujante"; para cada alternativa, qué componentes cambian, riesgo para la pantalla actual, peso en el motor y esfuerzo estimado en tareas. Alternativas mínimas a evaluar:
   - **A.** Redibujar en SVG las barras del comparador y del panorama (`StackedBar` y la barra de puntaje) y exportar ese mismo SVG (y PNG desde él, como el radar).
   - **B.** Mantener el HTML en pantalla y serializarlo a imagen con `foreignObject` dentro de un SVG (sin librerías externas), exportando lo que la pantalla ya dibuja.
   - **C.** No exportar imagen del comparador ni del panorama; mejorar la impresión (`@media print`) para que "Imprimir como PDF" dé una hoja limpia.
2. Mockup HTML autocontenido (sin CDN, sin datos reales de establecimientos; con datos ficticios o de territorio): una sección del comparador (una entidad, cinco GSE, cuatro indicadores) mostrada con A, B y C lado a lado, y el archivo que produciría cada una (imagen o vista de impresión), para que el titular elija mirando.
3. Verificación: el mockup abre sin errores de consola en Chrome (Puppeteer) y no tiene referencias de red (`grep -c 'http'` = 0 salvo en comentarios); el motor no cambió (🔒1).
4. Commit `docs(diseno): mockup y diagnostico de la exportacion de imagen (s33m T2, pendiente 7)`.

### T3: propuesta de ordenación del repositorio (pendiente 12, sin mover nada)

1. Siguiendo SETTINGS §4.7, redactar la **propuesta** (no el encargo de ejecución): por bloque (traspasos, obsoletos y duplicados, nomenclatura, escáner), la lista concreta de movimientos o cambios con **grado de certeza** (alto, medio, bajo), el resultado del grep de referencias vivas de cada candidato de grado medio (filas canceladas incluidas), el grep de cada nombre a renombrar en POLITICA y SETTINGS, y lo que queda fuera por `andamios/` congelado.
2. Sin ejecutar ningún movimiento (regla 5).
3. Verificación: 🔒4; cada fila de la propuesta con su comando literal en el log.
4. Commit `docs(ordenacion): propuesta de ordenacion del repositorio (s33m T3, pendiente 12)`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log (cada verificación, cada cifra citada en los documentos, cada 🔒, M3 a M6, el alcance). Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** 3 cifras del informe de T1 con código distinto (base R `table()`), 6 barras nuevas contra el motor; 3 filas del inventario de T2 con otra búsqueda; 3 filas de la propuesta de T3 con otro comando.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión:** 🔒1 y las dos corridas de T1.
6. **Control positivo de la auditoría:** un parquet de prueba en `/tmp` con un `sigdifgru` cambiado debe cambiar la `N` de su barra.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla.
9. **Prohibido:** ajustar criterio o esperado; tocar fuera del ALCANCE; editar evidencia ya escrita; que un documento recomiende en lugar del titular (el umbral, la alternativa de imagen o los movimientos de grado bajo).
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; auditoría; invariantes; las cifras principales de cada documento (copiadas de su salida); **las tres decisiones pendientes del titular, cada una con pregunta cerrada**; dudas; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33m_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento en el log ni en los documentos.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33m preparacion de decisiones"`; luego el push según la autorización.
7. Estado de cierre en el reporte: hashes; salida del push.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: la tabla de umbrales de T1; las tres alternativas de T2 con su costo; el resumen de la propuesta de T3 por bloque y grado de certeza; las tres preguntas cerradas al titular; "lo que falló o sorprendió; si nada, decirlo".
