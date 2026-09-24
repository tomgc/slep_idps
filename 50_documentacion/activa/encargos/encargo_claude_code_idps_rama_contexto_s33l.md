# Encargo autónomo: autorizar el parquet de contexto y publicar la rama (s33l)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (gobernanza de datos y un push; `encargo_autonomo_claude_code_v1.md` §2.12, fila 2).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `50_documentacion/activa/50_datos_versionados_autorizados.md`; la rama local `feat/contrato-contexto` (solo lectura con `git show` y `git diff`, sin checkout); el hermano `/Users/tomgc/Projects/slep_simce_adecuado` (solo lectura: su lista de autorizados y el commit con que autorizó su parquet de contexto).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`; `bash` explícito; `Rscript` para leer el parquet (`arrow`). Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260924_rama_contexto_s33l_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío), `git rev-parse --short HEAD` y `git rev-parse --short feat/contrato-contexto`. El hash del primer commit es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** el hook `pre-push` de la cartera, corrido por el propio push (su salida literal va al log); `git ls-remote` tras el push.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits en español; `git add` con rutas explícitas; **nunca `--no-verify` ni `hooks.cartera false`**; POLITICA §6.1: la lista de autorizados cubre solo datos públicos agregados a nivel de establecimiento y no se amplía para acomodar otra cosa.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. **Gobernanza (M4):** el parquet trae alguna columna con identificación individual (RUT, nombre de persona, dato de estudiante) o su unidad no es el establecimiento → **no se autoriza**, T1 y T2 se congelan y se registra con pregunta cerrada al titular.
4. `git diff --stat main..feat/contrato-contexto` trae, además del parquet, otra ruta con extensión de datos → congela T1 y T2 y regístralo (la autorización se redacta sobre lo medido, no sobre lo supuesto).
5. El hook vuelve a rechazar el push en T2 → congela T2; no hay segundo intento.
6. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y pasa a FASE R.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (fila 7 agregada por el redactor), en un solo commit (`chore(encargo): s33l y registro del asistente s33`).
- `git commit` de `50_documentacion/activa/50_datos_versionados_autorizados.md` en `main`, tras M4 y M5 superados.
- `git push origin feat/contrato-contexto` **una vez**, en T2. Sin merge, sin rebase, sin checkout de la rama.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33l_*` (incluida la copia del parquet leída con `git show`).
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `09ae0bc`, el `docs(log)` de s33j (fuente: `.git/refs` leídos por el redactor el 2026-09-24).
- El registro del asistente s33 tiene 7 filas; la 7 la agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- `feat/contrato-contexto` = `61132e7`; su commit `aca50f7` agrega `40_salidas/publico/contexto_idps.parquet` (201.936 bytes), que no está en la lista de autorizados; el hook `pre-push` rechazó el push por eso (fuente: log s33j, T2).
- La lista de autorizados de `slep_idps` cubre `20_insumos/*` (tres niveles), `40_salidas/intermedios/*` y `renv/settings.json`, y limita la autorización a datos públicos agregados a nivel de establecimiento (fuente: `sed` del redactor sobre el archivo).
- El hermano `slep_simce_adecuado` autorizó en `main` el parquet de contexto de su propia rama `feat/contrato-contexto` antes de trabajar con ella (commit `760ce01` "docs(datos): autoriza contexto_simce.parquet de la rama feat/contrato-contexto (s32)") (fuente: la fotografía de apertura del hermano pegada por el titular en esta sesión; se lee en FASE 0, M5).

**Decisión del titular que este encargo implementa (sesión 33, criterio delegado al redactor):** D-1 de s33j → **(a)**: autorizar el parquet en `main`, con la misma forma que el hermano, **solo si** la inspección de M4 confirma que es dato público a nivel de establecimiento; nunca `--no-verify`.

## 2. Contexto mínimo

La rama `feat/contrato-contexto` produce un "contrato de contexto" (paso 36): un parquet público derivado de las planillas de la Agencia, que otros proyectos leen. Vive solo en esta máquina desde julio. Publicarla como respaldo exige que su archivo de datos esté autorizado, igual que en el hermano.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **`main` no recibe la rama:** `git merge-base --is-ancestor 61132e7 HEAD` falla.
2. **En `main` solo cambia la lista de autorizados (y el LOG):** `git diff --name-only <inicio>..HEAD` ⊆ {`50_documentacion/activa/50_datos_versionados_autorizados.md`, el LOG}.
3. **La autorización es la mínima:** el diff de la lista agrega exactamente una línea de autorización (la ruta exacta del parquet, no un comodín de carpeta) y no quita ninguna.
4. **La rama publicada es la local:** `git ls-remote origin refs/heads/feat/contrato-contexto` = `61132e7…`.

## 4. Grafo de tareas y ALCANCE

- **T1** (autorización en `main`) · ALCANCE: `50_documentacion/activa/50_datos_versionados_autorizados.md`.
- **T2** (publicar la rama) · ALCANCE: ninguna ruta del árbol. Requiere T1 completada.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash; archivos del primer commit | solo el LOG; vacío; el encargo y el registro | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD`; `git rev-parse feat/contrato-contexto`; `git ls-remote origin 'refs/heads/feat/*'` | `HEAD~1` = `09ae0bc` = `origin/main`; `0`; `1`; `61132e7…`; vacío | regla 2 |
| M3 | `git diff --stat main..feat/contrato-contexto` y lista de rutas con extensión de datos en ese diff | el parquet y rutas de código o documentación | regla 4 si hay otro archivo de datos |
| M4 | **Gobernanza:** `git show feat/contrato-contexto:40_salidas/publico/contexto_idps.parquet > /tmp/s33l_contexto.parquet`; en R: `names()`, tipos, `nrow()`, número de valores distintos de la columna identificadora, y búsqueda de columnas con nombres o contenidos de identificación individual (patrón de RUT sobre las columnas de texto) | columnas a nivel de establecimiento (RBD y atributos públicos), 0 coincidencias de RUT | regla 3 |
| M5 | En el hermano, solo lectura: `git -C /Users/tomgc/Projects/slep_simce_adecuado show 760ce01 --stat` y el diff de su lista de autorizados | una línea con la ruta exacta de su parquet de contexto | si no existe, se sigue con la forma de 🔒3 y se registra |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: autorizar el parquet en `main`

1. En el bloque de autorización de la lista, agregar **una** línea con la ruta exacta y su comentario: `40_salidas/publico/contexto_idps.parquet  # contrato de contexto (paso 36, rama feat/contrato-contexto): derivado de planillas publicas, nivel establecimiento (s33l)`. Si M5 muestra una forma distinta en el hermano, se copia su forma (y se registra).
2. Verificación: 🔒3 con `git diff -U0`; el resto del archivo intacto.
3. Commit `docs(datos): autoriza contexto_idps.parquet de la rama feat/contrato-contexto (s33l T1, D-1 de s33j)`.

### T2: publicar la rama

1. El push autorizado de la rama. La salida literal del hook va al log.
2. Verificación: 🔒4 y 🔒1.
3. Sin commit en el árbol.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log (M3 a M5, cada 🔒, el alcance, la salida del hook). Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** M4 por otra vía (lectura del parquet con `nanoparquet` o `duckdb` desde R, o con `arrow::read_parquet(..., as_data_frame = FALSE)$schema`); la rama remota con `git branch -r --contains 61132e7`.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión:** ninguna de código; se declara.
6. **Control positivo de la auditoría:** el detector de RUT de M4 corrido sobre una copia en `/tmp` con un RUT plantado en una columna de texto debe dispararse.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**, como en los encargos anteriores. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`.
9. **Prohibido:** ajustar criterio o esperado; ampliar la autorización más allá de la ruta exacta; `--no-verify`; editar evidencia ya escrita.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; auditoría; invariantes; columnas del parquet (nombres y tipos, sin filas); salida del hook; estado de la rama local y remota; decisión del titular (D-1 de s33j: (a), con la condición de M4); dudas; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33l_priv.sh`) → vacío, con control plantado; ninguna fila del parquet en el log.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33l rama de contexto"`; luego el push de `main` según la autorización.
7. Estado de cierre en el reporte: hashes; salida de los dos push.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: columnas del parquet; salida del hook; salida de los dos push; lo que queda al titular (ver la rama en GitHub); "lo que falló o sorprendió; si nada, decirlo".
