# Encargo autónomo: despliegue a docs/ del motor de s33 a s33i (s33h)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (acto de efecto público; `encargo_autonomo_claude_code_v1.md` §2.12, fila 2).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `40_salidas/motor_idps.html` (el motor que pasó el gate visual del titular); `docs/index.html` (lo publicado hoy); los instrumentos §8.2 en `/tmp/s33*`.
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`; `bash` explícito. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260924_despliegue_s33h_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s33h` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) md5 de `docs/index.html` igual al del motor después de copiar; (b) PRUEBAS b de s33 sobre `docs/index.html` (0 errores de consola y 0 `pageerror` con los dos modales, una ficha con vista histórica, una comparación y la exportación CSV de la vista histórica); (c) hash §8.2 del payload de `docs/index.html` = `eb4e00b3…4dc4`.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits en español; `git add` con rutas explícitas.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. El md5 del motor en FASE 0 distinto de `7ad76f36e42d66c4da2d71aa28a558eb` (el que pasó el gate) → detén la sesión: el gate fue sobre otro build.
4. Cualquier testigo de M4 distinto de su esperado, o hash §8.2 distinto → no se commitea el despliegue; congela T1.
5. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y pasa a FASE R.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo (`chore(encargo): s33h`).
- `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html`, **una vez**, solo con la regla 3 superada.
- `git commit` de `docs/index.html` tras la verificación de T1.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33h_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular, ni `rm`, `reset`, `restore` ni `checkout --`, y nada fuera de `docs/index.html` y el LOG.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `4684a48`, el `docs(log)` de s33i (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-24).
- Motor `40_salidas/motor_idps.html` = `7ad76f36e42d66c4da2d71aa28a558eb`; `docs/index.html` = `4b28a03fdaa00bd5dbb0a6fc501eab72` (el despliegue de s32g) (fuente: `md5sum` del redactor).
- Testigos de s33 a s33g, `grep -c -F` en el motor / en `docs/index.html` (fuente: `grep -c -F` del redactor): `focoRespaldo` 4/0; `outline:2px solid var(--cream)` 1/0; `" en el directorio"` 2/0; `Llegaste al tope de` 1/0; `:hover{color:var(--alerta-txt)` 2/0; `CSV_HIST_COLS` 2/0; `sin_clasificar_excluido` 1/0; `.vt-scroll{position:relative;` 1/0; `s33i: el sub cede ancho` 1/0.
- El titular pasó el gate visual sobre el motor `7ad76f36…` (hipótesis del redactor sobre el momento de lanzamiento; este encargo se lanza solo después del gate).

## 2. Contexto mínimo

`docs/` es lo que GitHub Pages publica. El despliegue es copiar el motor aprobado, verificar que la copia es idéntica y que funciona, y commitear. No se toca código.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 de `docs/index.html` = `eb4e00b3…4dc4` (convención §8.2 de s29).
2. **Solo cambia `docs/index.html`:** `git diff --name-only <inicio>..HEAD` ⊆ {`docs/index.html`, el LOG}.
3. **La copia es el motor aprobado:** md5 de `docs/index.html` = `7ad76f36e42d66c4da2d71aa28a558eb`.

## 4. Grafo de tareas y ALCANCE

- **T1** (copia, verificación y commit) · ALCANCE: `docs/index.html`.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `4684a48` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 del motor y de `docs/index.html`; hash §8.2 de los dos con calibración (fecha alterada igual, cifra plantada distinta) | `7ad76f36…` y `4b28a03f…`; `eb4e00b3…` en los dos | regla 3; si la calibración falla, regla 4 |
| M4 | Los nueve testigos de §1, motor / `docs/` | los valores de §1 | regla 4 |

## 6. T1: despliegue

1. La copia autorizada.
2. Verificación (`esperado:` antes): md5 de `docs/index.html` = `7ad76f36…`; los nueve testigos con los mismos conteos en `docs/index.html` que en el motor; hash §8.2 = `eb4e00b3…`; PRUEBAS b sobre `docs/index.html` sin errores; `git status --porcelain` = ` M docs/index.html` y el LOG.
3. Commit `deploy(docs): motor s33 a s33i (7ad76f36)` con solo `docs/index.html`.

## 7. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** derivado del log (cada verificación, cada 🔒, los casos plantados de M3, el alcance). Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** md5 con otra herramienta (`shasum -a 256` del motor y de `docs/index.html`, iguales entre sí); testigos con `awk index()`; el commit de despliegue leído con `git show --stat HEAD~1` o el que corresponda.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD`; `git status --porcelain`.
5. **Regresión completa:** PRUEBAS a, b y c.
6. **Control positivo de la auditoría:** una copia de `docs/index.html` en `/tmp` con un byte cambiado debe dar otro md5 y fallar 🔒3.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**, como en los encargos s33 a s33g. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, con commit `fix(auditoria): R-NN …`.
9. **Prohibido:** ajustar criterio o esperado; tocar fuera del ALCANCE; editar evidencia ya escrita.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 8. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` → solo el LOG.
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; auditoría; invariantes; md5 y testigos; decisiones del titular (gate visual aprobado sobre el motor de s33g salvo las filas del modal, corregidas en s33i y revisadas por el titular sobre `7ad76f36…`; N-1 de s33g: no se toca; A-1 de s33i: se acepta la fila Chile en dos líneas); dudas; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33h_priv.sh`) → vacío, con control plantado.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33h despliegue"`; luego el push según la autorización.
7. Estado de cierre en el reporte: hashes de los commits `deploy(docs)` y `docs(log)`; salida del push.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push; md5 de `docs/index.html`; los nueve testigos en `docs/`; lo que queda al titular (recarga forzada del sitio publicado y Cmd+F de un testigo, por ejemplo `Llegaste al tope de` en `view-source`); "lo que falló o sorprendió; si nada, decirlo".
