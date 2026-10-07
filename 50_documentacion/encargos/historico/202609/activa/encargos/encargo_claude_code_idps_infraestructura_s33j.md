# Encargo autónomo: renv sin suitedoc y rama de contrato de contexto publicada (s33j)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (dos tareas cortas en serie, una con push; `encargo_autonomo_claude_code_v1.md` §2.12, filas 2 y 5).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `renv.lock`; `renv/`; `50_documentacion/suite/documentar.R`; la rama local `feat/contrato-contexto`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`; `bash` explícito; `Rscript` con `setwd("/Users/tomgc/Projects/slep_idps")` dentro de `-e`. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260924_infraestructura_s33j_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío), `git rev-parse --short HEAD` y `git rev-parse --short feat/contrato-contexto`. El hash del commit `chore(encargo): s33j` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'` con exit 0, 0 warnings y el árbol limpio salvo el ALCANCE; (b) `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); renv::status()'` (salida literal en el log).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits en español; `git add` con rutas explícitas.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. `feat/contrato-contexto` no apunta a `61132e7`, o `origin/feat/contrato-contexto` ya existe con otro hash → congela T2 (no se empuja nada encima de algo que no se midió).
4. `renv::status()` reporta, después de T1, algo relacionado con `suitedoc` → congela T1 (no se hace `renv::snapshot()`).
5. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y sigue con la próxima tarea independiente.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33j`).
- `git commit` de `.renvignore` tras la verificación de T1.
- `git push origin feat/contrato-contexto` **una vez**, en T2, solo con la regla 3 superada. **Sin merge, sin rebase, sin checkout** de esa rama: se empuja tal como está.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33j_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular, ni `renv::snapshot()`, ni `renv::install()`, ni cambios en `renv.lock`, ni `rm`, `reset`, `restore` ni `checkout`.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `d19a3a4`, el `docs(log)` de s33h (fuente: `.git/refs` leídos por el redactor el 2026-09-24).
- No existe `.renvignore` en la raíz (fuente: `ls -a` del redactor). `suitedoc` no aparece en `renv.lock` (fuente: `grep -n` del redactor, 0 resultados), y el único `.R` del repositorio que lo usa es `50_documentacion/suite/documentar.R` (fuente: `grep -rln` del redactor, excluido `renv/`).
- Que `renv::status()` hoy reporte `suitedoc` como paquete usado y no registrado es hipótesis (traspaso v31, pendiente 9; se mide en FASE 0, M3).
- La rama local `feat/contrato-contexto` apunta a `61132e7` y tiene tres commits propios (productor del contrato de contexto, paso 36; enganche en `run_all`; propagación S-01) (fuente: `.git/refs/heads/feat/contrato-contexto` y `.git/logs/refs/heads/feat/contrato-contexto` leídos por el redactor). No existe `origin/feat/contrato-contexto` (fuente: `ls .git/refs/remotes/origin/` del redactor; se re-mide tras el `fetch`, M4).

**Decisiones del titular que este encargo implementa (sesión 33):** pendiente 9 → `.renvignore` sobre la suite; pendiente 10 → publicar la rama sin integrarla.

## 2. Contexto mínimo

`renv` escanea el proyecto buscando paquetes usados; la suite de documentación usa `suitedoc`, un paquete del kit que no es parte del pipeline y no está publicado, y por eso `renv::status()` queda desincronizado. La rama `feat/contrato-contexto` vive solo en esta máquina desde julio; se publica como respaldo, sin tocar `main`.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **`renv.lock` intacto:** `git diff <inicio>..HEAD -- renv.lock | wc -l` → `0`.
2. **Código y datos intactos:** `git diff --name-only <inicio>..HEAD` ⊆ {`.renvignore`, el LOG}.
3. **`main` no recibe la rama:** `git merge-base --is-ancestor 61132e7 HEAD` falla (la rama no queda integrada en `main`).
4. **La rama publicada es la local:** `git rev-parse origin/feat/contrato-contexto` = `git rev-parse feat/contrato-contexto` = `61132e7…` tras T2.

## 4. Grafo de tareas y ALCANCE

- **T1** (`.renvignore`) · ALCANCE: `.renvignore`.
- **T2** (publicar la rama) · ALCANCE: ninguna ruta del árbol (solo el remoto).
- T1 y T2 son independientes; se ejecutan T1 → T2. **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `d19a3a4` = `origin/main`; `0`; `1` | regla 2 |
| M3 | **Caso malo de T1:** `renv::status()` literal | menciona `suitedoc` como usado y no registrado | si no lo menciona, T1 se omite y se registra |
| M4 | `git rev-parse feat/contrato-contexto`; `git ls-remote origin 'refs/heads/feat/*'`; `git log --oneline main..feat/contrato-contexto`; `git merge-base --is-ancestor feat/contrato-contexto main` | `61132e7…`; vacío; 3 commits; falla | regla 3 |
| M5 | Calibración de 🔒2: un archivo plantado fuera de la lista en un diff de prueba debe aparecer como fuera de alcance | se detecta | corrige el instrumento antes de T1 |

Último acto: anexar la sección `### FASE 0`.

## 6. Tareas

### T1: `.renvignore` sobre la suite

1. Crear `/Users/tomgc/Projects/slep_idps/.renvignore` con dos líneas: un comentario `# s33j: la suite de documentacion usa suitedoc (kit, no publicado) y no es parte del pipeline (pendiente 9 de v31).` y `50_documentacion/suite/`.
2. Verificación: `renv::status()` literal: ya no menciona `suitedoc` (si reporta otras diferencias no relacionadas, se registran como duda, no se tocan); `renv.lock` sin cambios; PRUEBAS a.
3. Commit `chore(renv): renvignore sobre la suite de documentacion (s33j T1, pendiente 9)` con solo `.renvignore`.

### T2: publicar `feat/contrato-contexto` sin integrarla

1. Con la regla 3 superada, el push autorizado.
2. Verificación: `git ls-remote origin refs/heads/feat/contrato-contexto` = `61132e7…`; 🔒3 y 🔒4.
3. Sin commit en el árbol.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log (cada verificación, cada 🔒, M3 a M5, el alcance). Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** la rama remota leída por `git branch -r --contains 61132e7` además de `ls-remote`; `renv::dependencies()` filtrado por `suitedoc` (debe venir vacío o solo desde rutas ignoradas) además de `renv::status()`.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`: lo no commiteado es hallazgo y no se limpia.
5. **Regresión completa:** PRUEBAS a y b.
6. **Control positivo de la auditoría:** M5, repetido sobre el diff final.
7. **Veredicto por hallazgo:** **BLOQUEA** (🔒 en FALLA, alcance violado, historia divergente: no se repara; se congela la tarea de origen y se registra con pregunta cerrada); **REPARA** (defecto propio dentro del ALCANCE, sin tocar un 🔒, con verificación calibrada); **ADVIERTE** (sin efecto sobre la meta o no medible aquí). "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2):** causa raíz; fix quirúrgico dentro del ALCANCE; re-verificación con el chequeo que lo detectó **y** con uno distinto; regresión; commit `fix(auditoria): R-NN <hallazgo>`; fila en la tabla.
9. **Prohibido:** ajustar criterio o esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG (o vacío). Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; auditoría; invariantes; `renv::status()` antes y después; estado de la rama local y remota; decisiones del titular (pendientes 9 y 10); dudas; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33j_priv.sh`) → vacío, con control plantado.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33j infraestructura"`; luego el push de `main` según la autorización.
7. Estado de cierre en el reporte: hashes; salida de los dos push.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salidas literales de los dos push; `renv::status()` antes y después; lo que queda al titular (nada que ver en el motor; la rama aparece en GitHub); "lo que falló o sorprendió; si nada, decirlo".
