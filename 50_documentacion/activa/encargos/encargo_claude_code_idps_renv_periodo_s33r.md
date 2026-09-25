# Encargo autónomo: `renv.lock` completo y periodo del contrato de contexto (s33r)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en una sesión de Claude Code con contexto limpio. **Subagentes: no se admiten** (`encargo_autonomo_claude_code_v1.md` §2.12, fila 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `renv.lock`; `30_procesamiento/36_exponer_contrato_contexto.R`; `50_documentacion/activa/contrato_contexto_v1.md` (§3, columnas 13 y 14); `40_salidas/publico/contexto_idps.parquet`; `00_build.R`; el log de s33q (`50_documentacion/andamios/logs/20260925_sin_red_contexto_s33q_log.md`, H-1 y H-2).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`; `bash` explícito. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar. En código R, rutas con `here::here()`, nunca absolutas.
- **LOG:** `50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del primer commit es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0 y 0 warnings; (b) hash §8.2 del payload del motor = `eb4e00b3…4dc4` y md5 del motor = `417acd964a95f3616560a1b46a5ba81f` (este encargo no toca el motor); (c) `Rscript -e 'renv::status()'` sin paquetes "out-of-sync".
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria. Un push denegado no se reintenta por otra vía.
- **Reglas canónicas:** commits en español; `git add` con rutas explícitas; nunca `--no-verify`.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_exportacion_svg_a1_s33s.md`, ` M 50_documentacion/activa/decisiones/20260925_decision_exportacion_imagen.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. `renv::record` cambia en `renv.lock` alguna entrada fuera de `askpass`, `curl`, `Rcpp` y `sys` → no se commitea `renv.lock`; congela T1 y regístralo.
4. El parquet de contexto cambia de filas, columnas o valores fuera de `periodo` y `fecha_calculo` → congela T2 y regístralo.
5. Cualquier 🔒 en FALLA → congela la tarea que lo produjo.
6. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue.

### Autorizaciones (lista cerrada)

- En FASE 0, un solo commit `chore(encargo): s33r y s33s, y parte A de la decisión de exportación` con este encargo, el encargo s33s y la enmienda de `20260925_decision_exportacion_imagen.md` (§4, escrita por el redactor).
- `Rscript -e 'renv::record(...)'` de `askpass`, `curl`, `Rcpp` y `sys` con sus versiones instaladas.
- `git commit` de los archivos del ALCANCE de cada tarea, tras su verificación.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33r_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular ni `rm`, `reset`, `restore`, `checkout --` ni cambios en la plantilla, el generador del motor o `docs/`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `5b629dd`, el `docs(log)` de s33q (fuente: `.git/refs` leídos por el redactor el 2026-09-25). Motor y `docs/index.html` = `417acd96…` (fuente: `openssl md5` del redactor).
- `renv.lock` registra `V8` y `openssl`, pero no sus dependencias `askpass`, `curl`, `Rcpp` y `sys`, y `renv::status()` da "out-of-sync" por esas cuatro (fuente: log de s33q, H-1).
- El productor fija `PERIODO_CORRIDA <- "2026-07"` a mano y escribe `fecha_calculo = Sys.Date()`; el contrato define `periodo` como "período de la corrida que generó el parquet, formato AAAA-MM" y `fecha_calculo` como "fecha de generación del parquet" (fuente: `grep` del redactor sobre el script y `contrato_contexto_v1.md` §3). Consecuencia medible: cada `run_all()` en un día distinto reescribe el parquet aunque el dato no cambie (hipótesis, se mide en M4).

**Decisiones del titular (sesión 33, criterio delegado):** D-1 de s33q → registrar las cuatro dependencias. D-2 de s33q → `periodo` se deriva de la fecha de corrida. Además, para que el paso 36 no ensucie el árbol en cada build: **el productor reescribe el parquet solo si cambió su contenido** (todas las columnas salvo `periodo` y `fecha_calculo`); si no cambió, conserva el archivo y sus metadatos, que siguen diciendo cuándo se generó ese contenido.

## 2. Invariantes 🔒 (cada uno con su comando)

1. **El motor no cambia:** PRUEBAS b.
2. **El contenido del contrato no cambia:** el parquet leído con `arrow`, sin `periodo` ni `fecha_calculo`, idéntico (`identical()` sobre el `data.frame` ordenado) antes y después.
3. **Solo cambia el ALCANCE:** `git diff --name-only <inicio>..HEAD` ⊆ {`renv.lock`, `30_procesamiento/36_exponer_contrato_contexto.R`, el LOG, más lo del primer commit}.

## 3. Tareas

- **T1** (`renv.lock`) · ALCANCE: `renv.lock`. `renv::record` de los cuatro; verificación: `git diff -U0 renv.lock` toca solo esas cuatro entradas; PRUEBAS c. Commit `chore(renv): registra askpass, curl, Rcpp y sys, dependencias de V8 y openssl (s33r T1, D-1 de s33q)`.
- **T2** (periodo e idempotencia) · ALCANCE: `30_procesamiento/36_exponer_contrato_contexto.R`. (i) `PERIODO_CORRIDA <- format(Sys.Date(), "%Y-%m")`, con comentario que cite el contrato §3 col 13. (ii) Antes de escribir: si existe el parquet y su contenido sin `periodo` ni `fecha_calculo` es idéntico al nuevo, no se reescribe y el script lo informa con un `message()`; si difiere, se escribe como hoy. Verificación (`esperado:` antes): **caso malo** medido en FASE 0 (M4: dos corridas del script original con la fecha del sistema simulada distinta, por ejemplo con `Sys.Date` enmascarada en un entorno de prueba en `/tmp`, dan md5 distintos); con el script nuevo, `run_all(only = 36)` dos veces → md5 del parquet igual a FASE 0 y porcelain vacío; una copia de prueba en `/tmp` con una celda de contenido alterada → el script la reescribe (control positivo); 🔒2. Commit `fix(contexto): periodo derivado de la fecha de corrida y escritura solo si cambia el contenido (s33r T2, D-2 de s33q)`.
- Después de T2: PRUEBAS a completo y porcelain vacío salvo el LOG.

## 4. FASE 0: mediciones

Primer acto: el commit autorizado. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` escrito **antes** de su comando y `obtenido:` literal después: M1 porcelain, stash y archivos del primer commit (solo el LOG; vacío; los tres archivos autorizados); M2 `fetch`, `HEAD~1` = `5b629dd` = `origin/main`, `0`, `1`; M3 PRUEBAS b y `renv::status()` (out-of-sync por los cuatro); M4 caso malo de T2 y md5 del parquet actual.

## 5. FASE R y FASE L

- **FASE R:** los diez pasos del patrón (inventario antes de auditar; re-derivación independiente: el parquet con `nanoparquet` o `arrow::read_parquet(..., as_data_frame = FALSE)`, `renv.lock` con `jsonlite`; 🔒; alcance; regresión PRUEBAS a, b y c; control positivo; veredicto BLOQUEA / REPARA / ADVIERTE; máximo 2 ciclos; prohibiciones; tabla y veredicto).
- **FASE L:** porcelain; secciones de cierre; bloque J de trece campos; privacidad (grep de RUT con script en `/tmp/s33r_priv.sh` y control plantado; ninguna fila del parquet en el log); verificación del archivo (`esperado:` = `obtenido:`, un `## J`); commit `docs(log): s33r renv y periodo`; push según la autorización.

## 6. Reporte final

Primera línea: `ls -l <LOG> && wc -l <LOG>` y hash del `docs(log)`. Segundo bloque: el J tal cual. Después: salida del push; md5 del parquet antes y después; "lo que falló o sorprendió; si nada, decirlo".
