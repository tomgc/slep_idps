# Encargo autónomo: despliegue a docs/ del motor de s33o (s33p)

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes: no se admiten** (acto de efecto público; `encargo_autonomo_claude_code_v1.md` §2.12, fila 2).
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, raíz `/Users/tomgc/Projects/slep_idps`, macOS.
- **INSUMOS (en disco):** `40_salidas/motor_idps.html` (el motor de s33o que pasó el gate visual del titular); `docs/index.html` (lo publicado hoy, s33h); los instrumentos §8.2 en `/tmp/s33*` (o reconstruidos desde el log de s33o).
- **POSICIÓN:** rutas absolutas desde `/Users/tomgc/Projects/slep_idps`; ningún comando asume `cd`; `bash` explícito. Primer acto git: `fetch` y comparar `HEAD` con `origin/main`. Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260925_despliegue_s33p_log.md`
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`. El hash del commit `chore(encargo): s33p y registro del asistente s33` es `<inicio>`.
- **PRUEBAS (sin arnés; sustituto declarado):** (a) md5 de `docs/index.html` igual al del motor después de copiar; (b) PRUEBAS b de s33 sobre `docs/index.html` (0 errores de consola y 0 `pageerror` con los dos modales, una ficha con vista histórica, una comparación de 10 entidades, cada exportación CSV y un `page.pdf` del comparador); (c) hash §8.2 del payload de `docs/index.html` = `eb4e00b3…4dc4`.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Reglas canónicas:** commits en español; `git add` con rutas explícitas.

### Regla de detención (lista medible)

1. `git stash list` no vacío, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `HEAD` distinto de `origin/main` tras el `fetch` (antes del primer commit) → detén la sesión y pasa a FASE L.
3. El md5 del motor en FASE 0 distinto de `e227639b61eb3ca5620b84fb3834d6fe` (el que pasó el gate) → detén la sesión: el gate fue sobre otro build.
4. Cualquier testigo de M4 distinto de su esperado, o hash §8.2 distinto → no se commitea el despliegue; congela T1.
5. **Residual:** cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (contexto + pregunta cerrada + qué quedó bloqueado) y pasa a FASE R.

### Autorizaciones (lista cerrada)

- En FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (fila 12 agregada por el redactor), en un solo commit (`chore(encargo): s33p y registro del asistente s33`).
- `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html`, **una vez**, solo con la regla 3 superada.
- `git commit` de `docs/index.html` tras la verificación de T1.
- `git revert <hash>` de un commit propio, si FASE R lo exige.
- `git push origin main` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, `git status --porcelain` está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33p_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. En particular, ni `rm`, `reset`, `restore` ni `checkout --`, y nada fuera de `docs/index.html` y el LOG.

## 1. Estado de partida (premisas marcadas)

- `HEAD` = `origin/main` = `eb4bad4`, el `docs(log)` de s33o (fuente: `.git/refs/heads/main` y `.git/refs/remotes/origin/main` leídos por el redactor el 2026-09-25).
- Motor `40_salidas/motor_idps.html` = `e227639b61eb3ca5620b84fb3834d6fe`; `docs/index.html` = `7ad76f36e42d66c4da2d71aa28a558eb` (el despliegue de s33h) (fuente: `openssl md5` del redactor).
- El registro del asistente s33 tiene 12 filas; la 12 la agregó el redactor sin commitear (fuente: `grep -c` del redactor).
- Testigos, `grep -c -F` en el motor / en `docs/index.html` (fuente: `grep -c -F` del redactor): `s33o T1: base pequeña` 3/0; `s33o T2: plural de indicadores` 1/0; `s33o T3: impresión` 2/0; `focoRespaldo` 4/4; `Llegaste al tope de` 1/1; `s33i: el sub cede ancho` 1/1.
- El titular pasó el gate visual sobre el motor `e227639b…` (hipótesis del redactor sobre el momento de lanzamiento; este encargo se lanza solo después del gate).
- Decisiones del titular sobre las dudas de s33o (criterio delegado): D-1 aceptar la foto del escáner hasta su próxima corrida; D-2 aceptar la coautoría original de la rama de contexto; D-3 aceptar las 12 hojas del comparador (bloques de GSE sin partir); D-4 `nSub` se queda; D-5 los temporales de `/tmp` los borra el titular; D-6 los encargos citan clases y textos de este motor.

## 2. Contexto mínimo

`docs/` es lo que GitHub Pages publica. El despliegue es copiar el motor aprobado, verificar que la copia es idéntica y que funciona, y commitear. No se toca código.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Payload intacto:** hash §8.2 de `docs/index.html` = `eb4e00b3…4dc4` (convención §8.2 de s29).
2. **Solo cambia `docs/index.html`:** `git diff --name-only <inicio>..HEAD` ⊆ {`docs/index.html`, el LOG}.
3. **La copia es el motor aprobado:** md5 de `docs/index.html` = `e227639b61eb3ca5620b84fb3834d6fe`.

## 4. Grafo de tareas y ALCANCE

- **T1** (copia, verificación y commit) · ALCANCE: `docs/index.html`.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

Primer acto: el commit del encargo. Segundo acto: crear el LOG (encabezado, slot `## J. Juicio (lo rellena FASE L)`, esqueleto). Cada medición con `esperado:` antes y `obtenido:` literal después:

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | porcelain tras el primer commit; stash | solo el LOG; vacío | regla 1 |
| M2 | `fetch`; `HEAD~1`; `HEAD..origin/main`; `origin/main..HEAD` | `HEAD~1` = `eb4bad4` = `origin/main`; `0`; `1` | regla 2 |
| M3 | md5 del motor y de `docs/index.html`; hash §8.2 de los dos con calibración (fecha alterada igual, cifra plantada distinta) | `e227639b…` y `7ad76f36…`; `eb4e00b3…` en los dos | regla 3; si la calibración falla, regla 4 |
| M4 | Los seis testigos de §1, motor / `docs/` | los valores de §1 | regla 4 |

## 6. T1: despliegue

1. La copia autorizada.
2. Verificación (`esperado:` antes): md5 de `docs/index.html` = `e227639b…`; los seis testigos con los mismos conteos en `docs/index.html` que en el motor; hash §8.2 = `eb4e00b3…`; PRUEBAS b sobre `docs/index.html` sin errores; `git status --porcelain` = ` M docs/index.html` y el LOG.
3. Commit `deploy(docs): motor s33o base pequeña, matriz e impresión (e227639b)` con solo `docs/index.html`.

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
2. Secciones de cierre: resumen; commits desde `git log <inicio>..HEAD --oneline`; auditoría; invariantes; md5 y testigos; decisiones del titular (gate visual aprobado sobre el motor `e227639b…` de s33o; D-1 a D-6 de s33o según §1); dudas; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle.
4. Privacidad: grep de RUT con script (`/tmp/s33p_priv.sh`) → vacío, con control plantado.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33p despliegue"`; luego el push según la autorización.
7. Estado de cierre en el reporte: hashes de los commits `deploy(docs)` y `docs(log)`; salida del push.

## 9. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: salida literal del push; md5 de `docs/index.html`; los seis testigos en `docs/`; lo que queda al titular (recarga forzada del sitio publicado y Cmd+F de un testigo, por ejemplo `s33o T1: base pequeña` en `view-source`); "lo que falló o sorprendió; si nada, decirlo".
