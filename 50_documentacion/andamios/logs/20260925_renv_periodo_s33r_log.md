# Log de sesión: `renv.lock` completo y periodo del contrato de contexto (s33r)

- **Meta:** registrar en `renv.lock` las cuatro dependencias de `V8` y `openssl` que faltan (`askpass`, `curl`, `Rcpp`, `sys`; D-1 de s33q) y que el productor del contrato de contexto derive `periodo` de la fecha de corrida y reescriba el parquet solo si cambió su contenido (D-2 de s33q), sin tocar el motor ni el contenido del contrato.
- **Fecha:** 2026-09-25.
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular).
- **HEAD al empezar:** `5b629dd` (`docs(log): s33q sin red y contexto`). Medición previa al primer acto, en solo lectura salvo el `fetch`: `fetch rc=0`, `HEAD=5b629dd origin/main=5b629dd`, `HEAD..origin/main=0 origin/main..HEAD=0`; `stash: []`; `git worktree list` = una entrada; `git status --porcelain` = ` M 50_documentacion/activa/decisiones/20260925_decision_exportacion_imagen.md`, `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_exportacion_svg_a1_s33s.md`, `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_renv_periodo_s33r.md` (las tres rutas que admite la regla 1); `.git/index.lock` no existe. Reglas 1 y 2 no disparan. Primer acto (autorizado): commit `ea7631f` chore(encargo): s33r y s33s, y parte A de la decisión de exportación, hijo de `5b629dd` (`3 files changed, 219 insertions(+)`). **PUNTO DE RETORNO `<inicio>` = `ea7631f`.**
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS); `bash` 3.2 explícito; R 4.5.2 con `renv` (cada `Rscript` se lanza con `cd` explícito a la raíz dentro del mismo comando, para que el `.Rprofile` active `renv`); `node` solo para el hash §8.2 del payload.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real:** Opus 5.5 (1M), sesión con ultracode activo; en solo y en serie, sin subagentes ni workflows, por contrato (§2.12 regla 1 del patrón).
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_renv_periodo_s33r.md` (commit `ea7631f`).
- **Grafo de tareas (del §3 del encargo):**

```
T1 (renv.lock)                  ALCANCE: renv.lock
T2 (periodo e idempotencia)     ALCANCE: 30_procesamiento/36_exponer_contrato_contexto.R
T1 y T2 son independientes (ALCANCE disjuntos); orden T1 → T2. Después de T2: PRUEBAS a completo y porcelain vacío salvo el LOG.
FASE R y FASE L fuera del grafo, corren siempre.
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria; un push denegado no se reintenta por otra vía.
- **Reglas que rigen esta sesión:** `git add` con rutas explícitas; nunca `--no-verify`; ni `rm`, `reset`, `restore` ni `checkout --` (tampoco sobre `/tmp`); no se tocan la plantilla, el generador del motor ni `docs/`; en R, rutas con `here::here()`; temporales solo en `/tmp/s33r_*`.
- **Instrumentos (en `/tmp/s33r_*`):** `s33r_payload_norm.js` (copia byte a byte de `/tmp/s33q_payload_norm.js`: hash §8.2 del payload con `fecha_generacion` → `0000-00-00`); `s33r_build.sh <etq> completo|36` (copia adaptada de `/tmp/s33q_build.sh`: `run_all()` o `run_all(only = 36L)` desde la raíz; `rc`, líneas con "warn", pasos OK, md5 del motor y de `docs/`, §8.2, md5 y `mtime` del parquet de contexto, mensajes del paso 36 y porcelain); `s33r_ctx.R <antes> <despues>` (🔒2: dimensiones, columnas, tipos, valores de `periodo` y `fecha_calculo`, e `identical()` del contenido sin esas dos columnas, ordenado por `rbd`, `anio`, `eje`, `segmento`; lectura validada contra `num_rows` del archivo; sin filas); `s33r_corre36.sh <repo_de_prueba> <fecha> <etq>` (corre el paso 36 solo, con `Sys.Date` enmascarada en el entorno global, **únicamente** sobre un repo `/tmp/s33r_*`); `s33r_plantar.R <parquet_de_prueba> celda|meta` (control positivo: `valor` + 1 en una celda, o solo los metadatos de corrida). Repo de prueba: clon APFS `cp -Rc` del repo en `/tmp/s33r_clon` (se crea en M4 y queda en `/tmp`). Convenciones: un `esperado:` y un `obtenido:` por comando, el `esperado:` escrito antes; una corrección va como `- **Corrección:** …`.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: registrar en `renv.lock` las cuatro dependencias de `V8` y `openssl`, y que el paso 36 derive `periodo` de la fecha y reescriba el parquet solo si cambia su contenido → cumplida, con el motor y el contenido del contrato intactos.
- Estado por tarea: FASE 0 completada (`ea7631f`) · T1 completada (`fe7ccb8`) · T2 completada (`f68bc57`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada.
- Commits: 4 propios, rango `ea7631f`..`<docs(log)>` (`git log --oneline 5b629dd..HEAD`), de los cuales 0 fix(auditoria).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/5; reparados 0; abiertos 5 (H-1 a H-4 como D-1 a D-4; H-5 declarado); controles positivos 3 de 3.
- Invariantes: 3/3 PASA (🔒1 motor `417acd96…` y §8.2 `eb4e00b3…4dc4`; 🔒2 contenido idéntico por `identical()` y `Table$Equals`; 🔒3 solo `renv.lock`, el script y el LOG); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: parquet `e375de305427fbbf667fa34ad5c650f7`, 39.591 × 15, con el `mtime` de FASE 0 tras tres builds; motor `417acd964a95f3616560a1b46a5ba81f`); `renv.lock` 42 → 46 entradas, 0 líneas borradas.
- Decisiones autónomas de mayor riesgo: comparación estricta con `identical()` (descartada: con tolerancia, que admite un falso "igual"); la línea literal `format(Sys.Date(), "%Y-%m")` (descartada: leer la fecha una vez; queda D-2); `renv::record("pkg@versión")` como en s33q (descartada: `renv::snapshot()`, no autorizado).
- Desviaciones respecto del encargo: ninguna (M5, el control de metadatos y el de archivo ausente de T2 son mediciones agregadas, no cambios de criterio).
- Dudas abiertas: 4; D-1 ¿se regenera una vez el parquet para que diga `periodo 2026-09` (sí / no)?; D-2 ¿se lee la fecha una sola vez (sí / no)?; D-3 ¿se prueba `renv::restore()` en un clon o se completan las entradas con `snapshot()` (ninguna / restore / snapshot)?
- Errores propios: 2 registrados; E-1 (comillas anidadas en un `bash -c`: bloque de M1 truncado en el log, sin efecto en el repo; una repetición) y un esperado de orden de `sort`.
- Qué debe verificar el revisor por sí mismo: el diff de `f68bc57` contra el contrato §3 y, en el próximo cambio de dato, que el paso 36 reescriba el parquet con el `periodo` del mes.
- No publicado / queda al usuario: D-1 a D-4 (D-4: temporales y clon en `/tmp/s33r_*`); la salida del push va en el reporte; `CLAUDE.md` (no versionado) se actualiza tras el push.
- Ejecución: modo de sesión ultracode (Opus 5.5, 1M) ejecutado en solo y en serie; subagentes 0 y total Opus 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** `ea7631f` (primer acto).

**M1 y M2 — porcelain, stash, primer commit y sincronía con el remoto:**
```
bash -c R=/Users/tomgc/Projects/slep_idps
```
- **Corrección (E-1, error propio):** el bloque de arriba quedó truncado: armé el anexo del log y la medición en un solo `bash -c '…'` con un heredoc que contenía comillas simples; la primera comilla del comando citado cerró la cadena exterior, el log recibió solo el título y el comienzo del comando, y el resto corrió con `$R` vacío (`fatal: cannot change to 'status'` y similares en cada `git -C`, `fetch rc=128`). No escribió nada más: medido después, porcelain = solo el LOG y `HEAD` = `ea7631f`. Desde aquí cada anexo al log sale de un archivo escrito aparte (`/tmp/s33r_frag_NN.md`, `cat >>`) y cada medición con comillas va en un script `/tmp/s33r_*.sh` cuyo contenido se copia al log. Se repite M1 y M2 con su `esperado:` antes.

**M1 y M2 (repetición) — `bash /tmp/s33r_m12.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps
git -C $R status --porcelain
echo "stash: [$(git -C $R stash list)]"
echo "primer commit: $(git -C $R show --name-only --format= HEAD | tr '\n' ' ')"
git -C $R fetch --quiet; echo "fetch rc=$?"
echo "HEAD=$(git -C $R rev-parse --short HEAD) HEAD~1=$(git -C $R rev-parse --short HEAD~1) origin/main=$(git -C $R rev-parse --short origin/main)"
echo "HEAD..origin/main=$(git -C $R rev-list --count HEAD..origin/main) origin/main..HEAD=$(git -C $R rev-list --count origin/main..HEAD)"
```
esperado: M1 porcelain = una sola línea `?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md`; `stash: []`; primer commit = los tres archivos autorizados (la decisión de exportación y los encargos s33s y s33r). M2 `fetch rc=0`; `HEAD=ea7631f HEAD~1=5b629dd origin/main=5b629dd`; `HEAD..origin/main=0 origin/main..HEAD=1`.
obtenido: M1 `?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md` (única); `stash: []`; `primer commit: 50_documentacion/activa/decisiones/20260925_decision_exportacion_imagen.md 50_documentacion/activa/encargos/encargo_claude_code_idps_exportacion_svg_a1_s33s.md 50_documentacion/activa/encargos/encargo_claude_code_idps_renv_periodo_s33r.md`. M2 `fetch rc=0`; `HEAD=ea7631f HEAD~1=5b629dd origin/main=5b629dd`; `HEAD..origin/main=0 origin/main..HEAD=1`. = esperado; reglas 1 y 2 no disparan.

**M3 — PRUEBAS b (con la calibración de s33q) y `renv::status()`: `bash /tmp/s33r_m3.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps
echo "motor $(md5 -q $R/40_salidas/motor_idps.html) docs $(md5 -q $R/docs/index.html)"
for f in $R/40_salidas/motor_idps.html $R/docs/index.html /tmp/s33q_docs_fecha.html /tmp/s33q_docs_plantado.html; do
  echo "${f##*/} $(node /tmp/s33r_payload_norm.js $f | grep -o 'sha256_norm":"[0-9a-f]*' | cut -c15-)"
done
cd $R && Rscript -e 'invisible(renv::status())' 2>&1 | grep -v '^- The project' | head -30
```
esperado: `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en el motor y en `docs/`; en las dos copias de calibración de s33q (que siguen en `/tmp`): con la fecha alterada, el mismo `eb4e00b3…`; con la cifra plantada, otro (`1c3799e2…`); `renv::status()` dice que el proyecto está "out-of-sync" y nombra `askpass`, `curl`, `Rcpp` y `sys` (instalados y usados, sin registrar) y ningún otro paquete.
obtenido: `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; `motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `index.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `s33q_docs_fecha.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` (calla ante la fecha); `s33q_docs_plantado.html 1c3799e2e8e35da8bdca8b8433af442fb4f84b3b7f0bc49967b90a58c39b5af8` (dispara ante la cifra); `renv::status()`: `The following package(s) are in an inconsistent state:` con la tabla `package installed recorded used` = `askpass y n y`, `curl y n y`, `Rcpp y n y`, `sys y n y` (cuatro filas, ninguna otra). = esperado. (La palabra "out-of-sync" la imprime la activación de `renv` en una línea que empieza por `- The project`, que el `grep -v` del script descarta; PRUEBAS c se medirá también sin ese filtro.)

**M5 (propia) — versiones instaladas y presencia en `renv.lock`: `bash /tmp/s33r_m5.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps
cd $R && Rscript -e '
P <- c("askpass", "curl", "Rcpp", "sys", "V8", "openssl")
for (p in P) cat(p, as.character(utils::packageVersion(p)), "\n")
cat("renv", as.character(utils::packageVersion("renv")), "\n")
l <- jsonlite::fromJSON("renv.lock", simplifyVector = FALSE)
cat("en renv.lock:", paste(intersect(P, names(l$Packages)), collapse = ","), "| entradas en el lock:", length(l$Packages), "\n")
' 2>&1 | grep -v '^- The project'
echo "renv.lock md5 $(md5 -q $R/renv.lock) lineas $(wc -l < $R/renv.lock | tr -d ' ')"
```
esperado: (propio) `Rcpp 1.1.2` y `sys 3.4.3` (los que nombró s33q M6), `askpass` y `curl` con la versión que haya (se registra), `V8 8.2.0`, `openssl 2.4.2`; `en renv.lock: V8,openssl` (los cuatro ausentes); el número de entradas y el md5 del lock se registran como línea base de T1.
obtenido: `askpass 1.2.1`, `curl 8.0.0`, `Rcpp 1.1.2`, `sys 3.4.3`, `V8 8.2.0`, `openssl 2.4.2`; `renv 1.1.4`; `en renv.lock: V8,openssl | entradas en el lock: 42`; `renv.lock md5 ca387b0863d3ca4f8df70b652e0641ae lineas 1631`. = esperado. **Registros que T1 pasará a `renv::record`: `askpass@1.2.1`, `curl@8.0.0`, `Rcpp@1.1.2`, `sys@3.4.3`.**

**M4 — parquet de contexto actual y caso malo de T2: `bash /tmp/s33r_m4.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps; P=40_salidas/publico/contexto_idps.parquet
echo "parquet $(md5 -q $R/$P) blob_HEAD $(git -C $R rev-parse --short HEAD:$P) hash_object $(git -C $R hash-object $R/$P | cut -c1-7) tamano $(stat -f %z $R/$P) mtime $(stat -f %Sm -t %Y-%m-%dT%H:%M:%S $R/$P)"
cp $R/$P /tmp/s33r_contexto_fase0.parquet
cd $R && Rscript /tmp/s33r_ctx.R /tmp/s33r_contexto_fase0.parquet $R/$P 2>&1 | grep -v '^- The project'
if [ -e /tmp/s33r_clon ]; then echo "ya existe /tmp/s33r_clon"; else cp -Rc $R /tmp/s33r_clon; echo "clon cp -Rc rc=$?"; fi
echo "clon: parquet $(md5 -q /tmp/s33r_clon/$P) | script $(md5 -q /tmp/s33r_clon/30_procesamiento/36_exponer_contrato_contexto.R) repo $(md5 -q $R/30_procesamiento/36_exponer_contrato_contexto.R)"
bash /tmp/s33r_corre36.sh /tmp/s33r_clon 2026-09-25 m4_hoy
bash /tmp/s33r_corre36.sh /tmp/s33r_clon 2026-10-15 m4_oct
cp /tmp/s33r_clon/$P /tmp/s33r_m4_oct.parquet
bash /tmp/s33r_corre36.sh /tmp/s33r_clon 2026-11-20 m4_nov
cp /tmp/s33r_clon/$P /tmp/s33r_m4_nov.parquet
cd $R && Rscript /tmp/s33r_ctx.R /tmp/s33r_m4_oct.parquet /tmp/s33r_m4_nov.parquet 2>&1 | grep -v '^- The project'
echo "repo intacto: parquet $(md5 -q $R/$P) porcelain [$(git -C $R status --porcelain | tr '\n' ';')]"
```
(`/tmp/s33r_corre36.sh <repo> <fecha> <etq>` hace `cd <repo> && Rscript -e "Sys.Date <- function() as.Date(\"<fecha>\"); source(\"30_procesamiento/36_exponer_contrato_contexto.R\")"`, rechaza todo repo que no sea `/tmp/s33r_*` e imprime `rc`, líneas con "warn", md5 y `mtime` del parquet y los mensajes del paso 36.)

esperado: parquet del repo `e375de305427fbbf667fa34ad5c650f7` (el de s33q T4), igual al blob de `HEAD` (`blob_HEAD` = `hash_object`); su lectura: `39591 x 15` las dos, mismas columnas y tipos, `periodo` `2026-07`, `fecha_calculo` `2026-09-25`, contenido idéntico `TRUE` (contra sí mismo: calla ante el caso bueno trivial). Clon creado (`rc=0`) con el parquet y el script iguales al repo. Corrida `m4_hoy` (fecha simulada = hoy): `rc=0 warn=0`, md5 `e375de30…` (el clon reproduce el repo); `m4_oct` y `m4_nov`: `rc=0 warn=0` con md5 **distintos** entre sí y de `e375de30…` (**caso malo:** el contenido no cambió y el archivo sí); su comparación: `39591 x 15`, mismas columnas y tipos, `periodo` `2026-07` en las dos (escrito a mano), `fecha_calculo` `2026-10-15` frente a `2026-11-20`, contenido idéntico `TRUE`. El repo intacto: parquet `e375de30…`, porcelain = solo el LOG.
obtenido: `parquet e375de305427fbbf667fa34ad5c650f7 blob_HEAD 81081c1 hash_object 81081c1 tamano 201846 mtime 2026-09-25T15:15:14`; lectura `antes 39591 x 15 | despues 39591 x 15`, `mismas columnas y orden: TRUE | mismos tipos: TRUE`, `periodo antes: 2026-07 | despues: 2026-07`, `fecha_calculo antes: 2026-09-25 | despues: 2026-09-25`, `contenido identico (sin periodo ni fecha_calculo): TRUE`; `clon cp -Rc rc=0`; `clon: parquet e375de305427fbbf667fa34ad5c650f7 | script bcc28fabacf82f5cbca480fd55bb4115 repo bcc28fabacf82f5cbca480fd55bb4115`; `m4_hoy`: `rc=0 warn=0 fecha=2026-09-25 parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T16:49:08` (mensajes: lectura de la fuente, `Filas familia 'indicador': 631844 (de 2362469 totales).`, `OK: 39591 filas x 15 columnas en 40_salidas/publico/contexto_idps.parquet.`); `m4_oct`: `rc=0 warn=0 fecha=2026-10-15 parquet fd7cd29ad32baf2d1004ddd96c11dff3`; `m4_nov`: `rc=0 warn=0 fecha=2026-11-20 parquet 48612c7ba4aa1d91613f0c334d2bc5bd` (mismos mensajes); comparación oct/nov: `39591 x 15` las dos, columnas y tipos `TRUE`, `periodo antes: 2026-07 | despues: 2026-07`, `fecha_calculo antes: 2026-10-15 | despues: 2026-11-20`, `contenido identico (sin periodo ni fecha_calculo): TRUE`; `repo intacto: parquet e375de305427fbbf667fa34ad5c650f7 porcelain [?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md;]`. = esperado. **Caso malo reproducido:** con el mismo contenido, tres fechas dan tres md5 (`e375de30…`, `fd7cd29a…`, `48612c7b…`) y `periodo` sigue en `2026-07`; además el script original reescribe el archivo aunque el md5 no cambie (`m4_hoy`: mismo md5, `mtime` nuevo). El clon reproduce el repo byte a byte con la fecha de hoy, así que sirve de banco para T2.

- **Estado de FASE 0:** completada. M1–M5 coinciden con su esperado; reglas 1 y 2 no disparan; el caso malo de T2 se reproduce y el criterio (md5 del parquet) queda calibrado del lado que dispara.
- **PUNTO DE RETORNO (copiado al encabezado):** porcelain = solo este LOG; stash vacío; `HEAD` `ea7631f` (hijo de `5b629dd` = `origin/main`); una sola entrada de worktree.
- **Línea base:** motor y `docs/` `417acd964a95f3616560a1b46a5ba81f`, §8.2 `eb4e00b3…4dc4`; parquet `e375de305427fbbf667fa34ad5c650f7` (copia en `/tmp/s33r_contexto_fase0.parquet`); `renv.lock` `ca387b0863d3ca4f8df70b652e0641ae`, 1.631 líneas, 42 entradas; script 36 `bcc28fabacf82f5cbca480fd55bb4115`.
- **Alcance:** FASE 0 no tocó archivos del árbol salvo el LOG (el primer commit es el autorizado).
- **Regresión:** no tocó código.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** (1) calibrar el clon con una cuarta corrida (fecha simulada = hoy) además de las dos que pide el encargo, para que el banco de T2 reproduzca el repo antes de usarlo (reversible; alternativa descartada: confiar en el clon sin medirlo). (2) M5 propia, para tomar de la biblioteca las versiones que T1 registra (alternativa descartada: escribirlas de memoria del log de s33q, que no nombra las de `askpass` y `curl`).
- **Errores propios:** E-1 (arriba: anexo y medición en un `bash -c` con comillas anidadas; bloque truncado en el log, sin efecto en el repo; costó una repetición de M1 y M2).
- **Dudas:** ninguna.

### FASE T1: `renv.lock` con las cuatro dependencias

- **Paso 0:** releí `renv.lock` (42 entradas; `V8` y `openssl` con tres campos: `Package`, `Version`, `Source`, como los dejó `renv::record` en s33q T2.5) y el método de s33q (`renv::record(c("V8@8.2.0", "openssl@2.4.2"))`, que agregó dos entradas y 0 líneas borradas). Uso el mismo método con las versiones instaladas medidas en M5.

**T1.1 — registro:**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript -e "renv::record(c(\"askpass@1.2.1\", \"curl@8.0.0\", \"Rcpp@1.1.2\", \"sys@3.4.3\"))" 2>&1 | grep -v "^- The project" | tail -4; git -C /Users/tomgc/Projects/slep_idps diff --stat -- renv.lock | cat'
```
esperado: `renv` informa que actualizó 4 registros; `renv.lock | 20 ++++…`, `1 file changed, 20 insertions(+)` (cinco líneas por entrada, como en s33q).
obtenido: `- Updated 4 records in "~/Projects/slep_idps/renv.lock".`; `renv.lock | 20 ++++++++++++++++++++`, `1 file changed, 20 insertions(+)`. = esperado.

**T1.2 — verificación del diff (regla 3) y PRUEBAS c: `bash /tmp/s33r_t1v.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps
echo "lineas + : $(git -C $R diff -U0 -- renv.lock | grep -c '^+[^+]')  lineas - : $(git -C $R diff -U0 -- renv.lock | grep -c '^-[^-]')  hunks: $(git -C $R diff -U0 -- renv.lock | grep -c '^@@')"
echo "paquetes en lineas +: $(git -C $R diff -U0 -- renv.lock | grep '^+[^+]' | grep -oE '"Package": "[^"]+"' | sort | tr '\n' ' ')"
git -C $R diff -U0 -- renv.lock | grep '^+[^+]' | tr -d ' ' | tr '\n' ' '; echo
cd $R && Rscript -e 'invisible(renv::status())' 2>&1 | head -12
echo "porcelain: [$(git -C $R status --porcelain | tr '\n' ';')]"
```
esperado: `lineas + : 20  lineas - : 0`; los paquetes de las líneas agregadas son exactamente `"Package": "Rcpp"`, `"Package": "askpass"`, `"Package": "curl"`, `"Package": "sys"` (orden de `sort`), cada uno con su `Version` de M5 y `"Source": "Repository"`; ninguna línea de otra entrada (la regla 3 no dispara). PRUEBAS c: sin la línea de activación "out-of-sync" y `renv::status()` = `No issues found -- the project is in a consistent state.`; porcelain ` M renv.lock` y el LOG.
obtenido: `lineas + : 20  lineas - : 0  hunks: 4`; `paquetes en lineas +: "Package": "askpass" "Package": "curl" "Package": "Rcpp" "Package": "sys"`; líneas agregadas (sin espacios): `"Rcpp":{ "Package":"Rcpp", "Version":"1.1.2", "Source":"Repository" },`, `"askpass":{ "Package":"askpass", "Version":"1.2.1", "Source":"Repository" },`, `"curl":{ "Package":"curl", "Version":"8.0.0", "Source":"Repository" },`, `"sys":{ "Package":"sys", "Version":"3.4.3", "Source":"Repository" },`; `renv::status()` sin línea de activación: `No issues found -- the project is in a consistent state.`; porcelain `[ M renv.lock;?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md;]`. = esperado en el contenido: los cuatro paquetes, sus versiones de M5, 0 líneas borradas y ninguna otra entrada (la regla 3 no dispara); **PRUEBAS c PASA**. El orden que imprimió `sort` (`askpass curl Rcpp sys`) no es el que anoté (`Rcpp askpass curl sys`): el `sort` de macOS con la configuración regional ordena sin distinguir mayúsculas; el conjunto es el mismo (el esperado sobre el orden era mío, no del encargo).

**T1.3 — chequeo de alcance antes del commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; echo "modificados: $(git -C $R diff --name-only HEAD | tr "\n" " ")"; echo "sin seguimiento: $(git -C $R ls-files --others --exclude-standard | tr "\n" " ")"'
```
esperado: `modificados: renv.lock`; `sin seguimiento: 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md` (⊆ ALCANCE de T1 más el LOG).
obtenido: `modificados: renv.lock`; `sin seguimiento: 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md`. ⊆ ALCANCE de T1 más el LOG.

- **Estado de T1:** completada.
- **Commits:** `fe7ccb8` chore(renv): registra askpass, curl, Rcpp y sys, dependencias de V8 y openssl (s33r T1, D-1 de s33q), hijo de `ea7631f` (`1 file changed, 20 insertions(+)`).
- **Cambios sustantivos:** `renv.lock` gana cuatro entradas mínimas (`Package`, `Version`, `Source: Repository`), con las versiones instaladas (`askpass 1.2.1`, `curl 8.0.0`, `Rcpp 1.1.2`, `sys 3.4.3`), del mismo tipo que las de `V8` y `openssl` de s33q. Causa raíz del "out-of-sync": s33q instaló seis paquetes y autorizó a registrar dos.
- **Alcance:** `renv.lock` ⊆ ALCANCE de T1.
- **Regresión:** no tocó código; PRUEBAS c PASA (arriba). PRUEBAS a corre completo después de T2.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** registrar con `renv::record("pkg@versión")` (el método de s33q), que deja entradas sin `Hash` ni `Requirements` (alternativa descartada: `renv::snapshot()`, que no está autorizado y reescribiría las entradas completas; reversible con `git revert`).
- **Errores propios:** ninguno (el orden de `sort` del esperado, arriba, era mío y no afecta el criterio).
- **Dudas:** ninguna.

### FASE T2: `periodo` derivado de la fecha y escritura solo si cambia el contenido

- **Paso 0:** releí el script completo (162 líneas; md5 `bcc28fab…`): `PERIODO_CORRIDA <- "2026-07"` en la línea 55; `fecha_calculo = Sys.Date()` en la 125; la escritura atómica incondicional (`escribir_parquet_atomico`) en la 157, seguida del `log_msg` "OK: … filas". `log_msg` escribe con `cat()` (no con `message()`), así que el aviso nuevo va con `message()`, como pide el encargo. `run_all` hace `source(…, chdir = TRUE)` en el entorno global. Contrato §3: col 13 `periodo` = "Período de la corrida que generó el parquet, formato AAAA-MM"; col 14 `fecha_calculo` = "Fecha de generación del parquet"; llave natural `(rbd, anio, eje, segmento)`.
- **Diseño:** (i) `PERIODO_CORRIDA <- format(Sys.Date(), "%Y-%m")`, con comentario que cita el contrato §3 col 13. (ii) Dos constantes nuevas (`COLS_METADATOS_CORRIDA`, `LLAVE_CONTRATO`) y dos funciones en el bloque de helpers: `sin_metadatos_corrida()` (data frame base sin `periodo` ni `fecha_calculo`, ordenado por la llave, sin nombres de fila) y `contenido_sin_cambios(ruta, nuevo)` (`FALSE` si el archivo no existe, no se puede leer o no trae las 15 columnas del contrato en su orden; si no, `identical()` estricto de los dos contenidos). Antes de escribir: si `contenido_sin_cambios()` es `TRUE`, no se escribe y se informa con `message()`; si no, se escribe como hoy y el `log_msg` "OK" queda igual. La comparación es estricta a propósito: un falso "distinto" solo reescribe (la conducta de hoy); un falso "igual" es imposible con `identical()`.
- **Edición** (cinco reemplazos con el editor; `parse ok`; `1 file changed, 47 insertions(+), 9 deletions(-)`): la cabecera (`Salidas`) dice que la escritura es solo si cambió el contenido; `PERIODO_CORRIDA <- format(Sys.Date(), "%Y-%m")` con su comentario (contrato §3 col 13; D-2 de s33q), después de `FAMILIA_ALCANCE`; `COLS_METADATOS_CORRIDA` y `LLAVE_CONTRATO` después de `COLS_CONTRATO`; `sin_metadatos_corrida()` y `contenido_sin_cambios()` en los helpers; la escritura y su `log_msg` "OK" dentro de un `if/else` cuyo lado "sin cambios" emite `message("[36_contexto] Contenido sin cambios (salvo periodo y fecha_calculo): se conserva …; no se reescribe.")`. La derivación de las 15 columnas, las guardas y `fecha_calculo = Sys.Date()` no cambian.

**T2.2 — banco en el clon (caso bueno, control positivo, control de metadatos y archivo ausente): `bash /tmp/s33r_t2_banco.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps; C=/tmp/s33r_clon; P=40_salidas/publico/contexto_idps.parquet; S=30_procesamiento/36_exponer_contrato_contexto.R
cp $R/$S $C/$S; cp /tmp/s33r_contexto_fase0.parquet $C/$P
echo "banco: script $(md5 -q $C/$S) = repo $(md5 -q $R/$S) | parquet $(md5 -q $C/$P) mtime $(stat -f %Sm -t %Y-%m-%dT%H:%M:%S $C/$P)"
bash /tmp/s33r_corre36.sh $C 2026-10-15 t2_oct
bash /tmp/s33r_corre36.sh $C 2026-11-20 t2_nov
echo "--- control positivo: celda"
cd $R && Rscript /tmp/s33r_plantar.R $C/$P celda 2>&1 | grep -v '^- The project'; echo "plantado: $(md5 -q $C/$P)"
bash /tmp/s33r_corre36.sh $C 2026-10-15 t2_celda
cp $C/$P /tmp/s33r_t2_celda.parquet
cd $R && Rscript /tmp/s33r_ctx.R /tmp/s33r_contexto_fase0.parquet /tmp/s33r_t2_celda.parquet 2>&1 | grep -v '^- The project'
echo "--- control de metadatos"
cd $R && Rscript /tmp/s33r_plantar.R $C/$P meta 2>&1 | grep -v '^- The project'; echo "plantado: $(md5 -q $C/$P)"
bash /tmp/s33r_corre36.sh $C 2026-11-20 t2_meta
cp $C/$P /tmp/s33r_t2_meta.parquet
cd $R && Rscript /tmp/s33r_ctx.R /tmp/s33r_contexto_fase0.parquet /tmp/s33r_t2_meta.parquet 2>&1 | grep -v '^- The project'
echo "--- archivo ausente"
mv $C/$P /tmp/s33r_t2_apartado.parquet; echo "ausente: $([ -e $C/$P ] && echo no || echo si)"
bash /tmp/s33r_corre36.sh $C 2026-12-01 t2_sin
cp $C/$P /tmp/s33r_t2_sin.parquet
cd $R && Rscript /tmp/s33r_ctx.R /tmp/s33r_contexto_fase0.parquet /tmp/s33r_t2_sin.parquet 2>&1 | grep -v '^- The project'
echo "repo intacto: parquet $(md5 -q $R/$P) mtime $(stat -f %Sm -t %Y-%m-%dT%H:%M:%S $R/$P)"
```
esperado: banco con el script nuevo (md5 igual al del repo) y el parquet `e375de30…`. **Caso bueno** (`t2_oct`, `t2_nov`): `rc=0 warn=0`, md5 `e375de305427fbbf667fa34ad5c650f7` en las dos y el `mtime` del banco sin cambios, con el mensaje `[36_contexto] Contenido sin cambios … se conserva …; no se reescribe.` y sin la línea "OK: … filas" (frente a M4, donde las mismas dos fechas daban dos md5). **Control positivo** (`valor` + 1 en una celda): md5 plantado distinto; `t2_celda` reescribe (`OK: 39591 filas x 15 columnas`, sin el mensaje de conservación), md5 nuevo; su comparación con FASE 0: `39591 x 15`, columnas y tipos `TRUE`, `periodo` `2026-07` → `2026-10`, `fecha_calculo` `2026-09-25` → `2026-10-15`, contenido idéntico `TRUE` (la celda plantada se corrigió con el dato de la fuente). **Control de metadatos** (solo `periodo` `1999-01` y `fecha_calculo` 1999-01-01): md5 plantado distinto; `t2_meta` no reescribe (mensaje de conservación), md5 = el plantado; comparación: `periodo` `2026-07` → `1999-01`, contenido idéntico `TRUE`. **Archivo ausente:** `ausente: si`; `t2_sin` escribe (`OK: 39591 filas …`); comparación: `periodo` → `2026-12`, `fecha_calculo` → `2026-12-01`, contenido idéntico `TRUE`. Repo intacto: parquet `e375de30…`, `mtime 2026-09-25T15:15:14`.
obtenido: `banco: script 763e853014bd3b99df0a93b5b284c4b6 = repo 763e853014bd3b99df0a93b5b284c4b6 | parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T16:52:22`. Caso bueno: `t2_oct` `rc=0 warn=0 fecha=2026-10-15 parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T16:52:22` y `t2_nov` `rc=0 warn=0 fecha=2026-11-20 parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T16:52:22`, las dos con `[36_contexto] Contenido sin cambios (salvo periodo y fecha_calculo): se conserva 40_salidas/publico/contexto_idps.parquet; no se reescribe.` y sin "OK: … filas". Control positivo: `plantado: valor +1 en 1 celda (fila 1 de 39591)`, `releido: 39591 filas`, `plantado: eca2557c81a0a01da01fb0c942ab52a2`; `t2_celda` `rc=0 warn=0 fecha=2026-10-15 parquet 3c86467b6a168b4a65a156a566caa079 mtime 2026-09-25T16:52:28` con `OK: 39591 filas x 15 columnas en 40_salidas/publico/contexto_idps.parquet.`; comparación `antes 39591 x 15 | despues 39591 x 15`, `mismas columnas y orden: TRUE | mismos tipos: TRUE`, `periodo antes: 2026-07 | despues: 2026-10`, `fecha_calculo antes: 2026-09-25 | despues: 2026-10-15`, `contenido identico (sin periodo ni fecha_calculo): TRUE`. Control de metadatos: `plantado: periodo y fecha_calculo en 39591 filas`, `plantado: 2d1e5efacea263e39c63761ea91e490a`; `t2_meta` `rc=0 warn=0 fecha=2026-11-20 parquet 2d1e5efacea263e39c63761ea91e490a mtime 2026-09-25T16:52:30` con el mensaje de conservación; comparación `periodo antes: 2026-07 | despues: 1999-01`, `fecha_calculo antes: 2026-09-25 | despues: 1999-01-01`, contenido `TRUE`. Archivo ausente: `ausente: si`; `t2_sin` `rc=0 warn=0 fecha=2026-12-01 parquet b77238c3335c1dac6f4b119dda1c2053` con `OK: 39591 filas x 15 columnas …`; comparación `periodo … despues: 2026-12`, `fecha_calculo … despues: 2026-12-01`, contenido `TRUE`. `repo intacto: parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14`. = esperado en todo. **El criterio md5 queda calibrado de los dos lados** (M4: dispara con el script original; T2.2: calla con el nuevo) y el script reescribe cuando el contenido cambia o falta el archivo.

**T2.3 — el script nuevo en el repo: `run_all(only = 36)` dos veces:**
```
bash -c 'bash /tmp/s33r_build.sh t2_36a 36; bash /tmp/s33r_build.sh t2_36b 36'
```
esperado: las dos corridas `rc=0 warn=0 pasos_ok=1 (Paso 36 OK )`; `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; `payload eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14` (md5 igual a FASE 0 y archivo sin reescribir); en los mensajes, el de conservación y no "OK: … filas"; porcelain = ` M 30_procesamiento/36_exponer_contrato_contexto.R` y el LOG (el parquet no aparece: "porcelain vacío" del encargo, leído como sin cambios fuera del ALCANCE de T2 y el LOG, porque el script y el LOG todavía no están commiteados).
obtenido: las dos corridas `rc=0 warn=0 pasos_ok=1 (Paso 36 OK )`; `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; `payload eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14`; mensajes: lectura de la fuente, `Filas familia 'indicador': 631844 (de 2362469 totales).`, `[36_contexto] Contenido sin cambios (salvo periodo y fecha_calculo): se conserva 40_salidas/publico/contexto_idps.parquet; no se reescribe.`; porcelain `[ M 30_procesamiento/36_exponer_contrato_contexto.R;?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md;]`. = esperado: md5 del parquet igual a FASE 0 y el archivo sin reescribir en las dos corridas.

**T2.4 — 🔒2 y chequeo de alcance antes del commit:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript /tmp/s33r_ctx.R /tmp/s33r_contexto_fase0.parquet $R/40_salidas/publico/contexto_idps.parquet 2>&1 | grep -v "^- The project"; echo "modificados: $(git -C $R diff --name-only HEAD | tr "\n" " ")"; echo "sin seguimiento: $(git -C $R ls-files --others --exclude-standard | tr "\n" " ")"'
```
esperado: `antes 39591 x 15 | despues 39591 x 15`, columnas y tipos `TRUE`, `periodo` `2026-07` y `fecha_calculo` `2026-09-25` en los dos, `contenido identico (sin periodo ni fecha_calculo): TRUE` (**🔒2 PASA**); `modificados: 30_procesamiento/36_exponer_contrato_contexto.R`; `sin seguimiento:` solo el LOG (⊆ ALCANCE de T2 más el LOG).
obtenido: `antes 39591 x 15 | despues 39591 x 15`; `mismas columnas y orden: TRUE | mismos tipos: TRUE`; `periodo antes: 2026-07 | despues: 2026-07`; `fecha_calculo antes: 2026-09-25 | despues: 2026-09-25`; `contenido identico (sin periodo ni fecha_calculo): TRUE` (**🔒2 PASA**); `modificados: 30_procesamiento/36_exponer_contrato_contexto.R`; `sin seguimiento: 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md`. = esperado; ⊆ ALCANCE de T2 más el LOG.

- **Commit:** `f68bc57` fix(contexto): periodo derivado de la fecha de corrida y escritura solo si cambia el contenido (s33r T2, D-2 de s33q), hijo de `fe7ccb8` (`1 file changed, 47 insertions(+), 9 deletions(-)`); script `763e853014bd3b99df0a93b5b284c4b6`.

**T2.5 — PRUEBAS a completo después de T2** (el comando del encargo, dentro de `/tmp/s33r_build.sh`: `cd` a la raíz y `Rscript -e 'setwd("/Users/tomgc/Projects/slep_idps"); source("00_build.R"); run_all()'`):
```
bash -c 'bash /tmp/s33r_build.sh pruebas_a completo'
```
esperado: `rc=0 warn=0 pasos_ok=6 (Paso 31 OK Paso 32 OK Paso 33 OK Paso 34 OK Paso 35 OK Paso 36 OK )`; `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f` (mismo día, misma plantilla, mismo payload: PRUEBAS b); `payload eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14` con el mensaje de conservación; porcelain = solo el LOG (**PRUEBAS a PASA**).
obtenido: `rc=0 warn=0 pasos_ok=6 (Paso 31 OK Paso 32 OK Paso 33 OK Paso 34 OK Paso 35 OK Paso 36 OK )`; `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; `payload eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14` con `[36_contexto] Contenido sin cambios (salvo periodo y fecha_calculo): se conserva 40_salidas/publico/contexto_idps.parquet; no se reescribe.`; porcelain `[?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md;]`. = esperado: **PRUEBAS a PASA** (y PRUEBAS b en el mismo build); el build completo ya no ensucia el árbol.

- **Estado de T2:** completada.
- **Commits:** `f68bc57` (arriba).
- **Cambios sustantivos:** `periodo` se deriva de la fecha de corrida (`format(Sys.Date(), "%Y-%m")`) y el parquet se reescribe solo si cambió su contenido (las 13 columnas que no son metadatos de corrida, comparadas con `identical()` sobre el data frame ordenado por la llave); si no cambió, `message()` y el archivo queda como está. Causa raíz del caso malo de M4: `fecha_calculo = Sys.Date()` entra en los bytes del parquet y la escritura era incondicional.
- **Alcance:** `30_procesamiento/36_exponer_contrato_contexto.R` ⊆ ALCANCE de T2.
- **Regresión:** `run_all(only = 36)` dos veces y PRUEBAS a completo (arriba), PASA.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno (la primera versión pasó todos los casos del banco).
- **Decisiones autónomas:** (1) comparación estricta con `identical()` (alternativa descartada: comparar con tolerancia o quitando atributos, que podría dar un falso "igual"; con la estricta un falso "distinto" solo reescribe, la conducta de hoy). (2) Un archivo sin las 15 columnas del contrato en su orden, o ilegible, cuenta como "distinto" y se escribe (alternativa descartada: detener el paso). (3) Seguir la letra del encargo en (i) (`format(Sys.Date(), "%Y-%m")` en la constante) y dejar `fecha_calculo = Sys.Date()` donde estaba: son dos llamadas a la fecha separadas por la lectura de la fuente (alternativa descartada: capturar la fecha una sola vez, que se aparta de la línea literal; queda como advertencia en FASE R). Las tres, reversibles con `git revert`.
- **Errores propios:** ninguno.
- **Dudas:** ninguna nueva en la fase (FASE R consolida las advertencias).

### FASE R: auditoría propia y reparación

**Paso 1 — inventario de afirmaciones auditables** (derivado de las secciones de arriba, antes de auditar):

| id | afirmación | origen |
|---|---|---|
| R-01 | PUNTO DE RETORNO: `<inicio>` = `ea7631f`, hijo de `5b629dd` = `origin/main`; stash vacío; primer commit con los tres archivos autorizados | FASE 0 M1–M2 |
| R-02 | Versiones instaladas: `askpass 1.2.1`, `curl 8.0.0`, `Rcpp 1.1.2`, `sys 3.4.3` | M5 |
| R-03 | Caso malo: con el script original y el mismo contenido, fechas distintas dan md5 distintos y `periodo` queda en `2026-07` | M4 |
| R-04 | `renv.lock` gana exactamente cuatro entradas (20 líneas, 0 borradas) con esas versiones y ninguna otra entrada cambia (regla 3) | T1.2 |
| R-05 | PRUEBAS c: `renv::status()` consistente, sin paquetes "out-of-sync" | T1.2 |
| R-06 | El script nuevo: `PERIODO_CORRIDA <- format(Sys.Date(), "%Y-%m")` con comentario que cita el contrato §3 col 13; `message()` si el contenido no cambió; escritura como antes si cambió; sin el literal `"2026-07"`; rutas sin `/Users/` | T2 edición |
| R-07 | Banco: con el script nuevo, dos fechas → mismo md5 y `mtime`; celda alterada → reescribe con contenido idéntico al de FASE 0; solo metadatos alterados → no reescribe; archivo ausente → escribe | T2.2 |
| R-08 | En el repo, `run_all(only = 36)` dos veces: md5 `e375de30…` y `mtime` de FASE 0; porcelain sin el parquet | T2.3 |
| R-09 | PRUEBAS a completo: `rc=0`, 0 warnings, 6 pasos OK, porcelain solo el LOG | T2.5 |
| R-10 | 🔒1 (PRUEBAS b): motor `417acd964a95f3616560a1b46a5ba81f` y §8.2 `eb4e00b3…4dc4` | M3, T2.3, T2.5 |
| R-11 | 🔒2: contenido del contrato idéntico antes y después | T2.4 |
| R-12 | 🔒3: `git diff --name-only ea7631f..HEAD` ⊆ {`renv.lock`, el script, el LOG} | T1.3, T2.4 |
| R-13 | Mensajes de commit iguales a los del encargo; cadena de padres `5b629dd` → `ea7631f` → `fe7ccb8` → `f68bc57` | commits |

**Pasos 2 y 3 — re-derivación independiente y 🔒.** Instrumentos nuevos, distintos de los que produjeron cada afirmación (probados en humo sobre entradas triviales antes de medir: el de parquet con la copia de FASE 0 contra sí misma, `39591 filas x 13 columnas de contenido`, igual `TRUE`; el de `renv.lock` con el lock de `HEAD` contra sí mismo, `agregadas: ` vacío y `agregadas = las cuatro: FALSE`; el de git, `bash -n`):
- `/tmp/s33r_r_git.sh [<rutas plantadas>]`: R-01 con `git cat-file` (padre), `git ls-remote` (el remoto, no la referencia local), `refs/stash` y `git diff-tree`; R-12 con `comm` entre la unión de ALCANCE y el LOG y lo commiteado desde `ea7631f` más el porcelain; R-13 con `grep -F` de cada asunto de commit en el encargo.
- `/tmp/s33r_r_lock.R <antes> <despues>`: R-02 y R-04 con `jsonlite` sobre los blobs `git show ea7631f:renv.lock` y `git show HEAD:renv.lock` (entradas agregadas, quitadas y cambiadas con `identical()` por entrada) y las versiones leídas con `read.dcf` del `DESCRIPTION` instalado (no `packageVersion`); R-05 con `renv::status()$synchronized` (el valor, no el texto).
- `/tmp/s33r_r_parquet.R <referencia> <otros…>`: R-03, R-07 y R-11 con arrow `Table` (`read_parquet(as_data_frame = FALSE)`, columnas sin `periodo` ni `fecha_calculo`, filas por `SortIndices` de la llave y `Take`, igualdad por `Table$Equals`) y md5 con `tools::md5sum`.
- `/tmp/s33r_r_varios.sh`: R-06 con `grep -F` sobre el blob de `HEAD` (no el archivo de trabajo) y `parse()` con `--vanilla`; R-07 y R-08 con los registros de cada corrida (`se conserva` frente a `OK: 39591 filas`), el `mtime` en segundos de época y `git diff --quiet`; R-09 con el registro de PRUEBAS a; R-10 con `openssl md5` y el §8.2 en Python (`/tmp/s33r_r_payload.py`, copia idéntica de `/tmp/s33q_r_payload.py`).

**R.a — R-01, R-12, R-13:**
```
bash -c 'bash /tmp/s33r_r_git.sh'
```
esperado: `R-01 padre de ea7631f: 5b629dd | remoto main: 5b629dd | refs/stash: ninguno`; archivos de `ea7631f` = la decisión de exportación y los encargos s33s y s33r; `R-12 rutas:` `30_procesamiento/36_exponer_contrato_contexto.R`, el LOG y `renv.lock`; `R-12 fuera de alcance: []` (**🔒3 PASA**); R-13: tres líneas, `ea7631f 5b629dd`, `fe7ccb8 ea7631f` y `f68bc57 fe7ccb8`, cada una con `en el encargo: 1` o más (los tres asuntos están literales en el encargo).
obtenido: `R-01 padre de ea7631f: 5b629dd | remoto main: 5b629dd | refs/stash: ninguno`; `R-01 archivos de ea7631f: 50_documentacion/activa/decisiones/20260925_decision_exportacion_imagen.md 50_documentacion/activa/encargos/encargo_claude_code_idps_exportacion_svg_a1_s33s.md 50_documentacion/activa/encargos/encargo_claude_code_idps_renv_periodo_s33r.md`; `R-12 rutas: 30_procesamiento/36_exponer_contrato_contexto.R 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md renv.lock`; `R-12 fuera de alcance: []` (**🔒3 PASA**); `R-13 ea7631f 5b629dd | en el encargo: 1 | chore(encargo): s33r y s33s, y parte A de la decisión de exportación`, `R-13 fe7ccb8 ea7631f | en el encargo: 1 | chore(renv): registra askpass, curl, Rcpp y sys, dependencias de V8 y openssl (s33r T1, D-1 de s33q)`, `R-13 f68bc57 fe7ccb8 | en el encargo: 1 | fix(contexto): periodo derivado de la fecha de corrida y escritura solo si cambia el contenido (s33r T2, D-2 de s33q)`. = esperado.

**R.b — R-02, R-04, R-05:**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; git -C $R show ea7631f:renv.lock > /tmp/s33r_lock_antes.json; git -C $R show HEAD:renv.lock > /tmp/s33r_lock_despues.json; cd $R && Rscript /tmp/s33r_r_lock.R /tmp/s33r_lock_antes.json /tmp/s33r_lock_despues.json 2>&1 | grep -v "^- The project"'
```
esperado: claves de primer nivel y `R` iguales `TRUE`; `entradas antes 42 despues 46 | agregadas: askpass,curl,Rcpp,sys | quitadas: [] | cambiadas: []` (el orden de `sort` en R puede diferir); `agregadas = las cuatro: TRUE`; por paquete, `lock` = `DESCRIPTION instalado` (`1.2.1`, `8.0.0`, `1.1.2`, `3.4.3`), `Source Repository`, campos `Package+Version+Source`, `igual: TRUE`; `R-05 renv::status()$synchronized: TRUE`.
obtenido: `claves de primer nivel iguales: TRUE | R igual: TRUE`; `entradas antes 42 despues 46 | agregadas: askpass,curl,Rcpp,sys | quitadas: [] | cambiadas: []`; `agregadas = las cuatro: TRUE`; `askpass lock 1.2.1 (Source Repository, campos Package+Version+Source) | DESCRIPTION instalado 1.2.1 | igual: TRUE`, `curl lock 8.0.0 … instalado 8.0.0 | igual: TRUE`, `Rcpp lock 1.1.2 … instalado 1.1.2 | igual: TRUE`, `sys lock 3.4.3 … instalado 3.4.3 | igual: TRUE`; `No issues found -- the project is in a consistent state.`; `R-05 renv::status()$synchronized: TRUE`. = esperado.

**R.c — R-03, R-07, R-11 (arrow Table):**
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript /tmp/s33r_r_parquet.R /tmp/s33r_contexto_fase0.parquet $R/40_salidas/publico/contexto_idps.parquet /tmp/s33r_m4_oct.parquet /tmp/s33r_m4_nov.parquet /tmp/s33r_t2_celda.parquet /tmp/s33r_t2_meta.parquet /tmp/s33r_t2_sin.parquet 2>&1 | grep -v "^- The project"'
```
esperado: `referencia s33r_contexto_fase0.parquet: 39591 filas x 13 columnas de contenido`; `contexto_idps.parquet` (el del repo): md5 `e375de305427fbbf667fa34ad5c650f7`, `periodo 2026-07`, `fecha_calculo 2026-09-25`, igual `TRUE` (R-11, **🔒2 PASA**); `s33r_m4_oct` md5 `fd7cd29a…`, `periodo 2026-07`, `2026-10-15`, `TRUE`; `s33r_m4_nov` md5 `48612c7b…`, `2026-07`, `2026-11-20`, `TRUE` (R-03: contenido igual, md5 distintos, `periodo` fijo); `s33r_t2_celda` md5 `3c86467b…`, `2026-10`, `2026-10-15`, `TRUE`; `s33r_t2_meta` md5 `2d1e5efa…`, `1999-01`, `1999-01-01`, `TRUE`; `s33r_t2_sin` md5 `b77238c3…`, `2026-12`, `2026-12-01`, `TRUE` (R-07); todos con 39.591 filas.
obtenido: `referencia s33r_contexto_fase0.parquet: 39591 filas x 13 columnas de contenido`; `contexto_idps.parquet: md5 e375de305427fbbf667fa34ad5c650f7 | filas 39591 | periodo 2026-07 | fecha_calculo 2026-09-25 | contenido igual a la referencia: TRUE` (**🔒2 PASA**); `s33r_m4_oct.parquet: md5 fd7cd29ad32baf2d1004ddd96c11dff3 | … | periodo 2026-07 | fecha_calculo 2026-10-15 | … TRUE`; `s33r_m4_nov.parquet: md5 48612c7ba4aa1d91613f0c334d2bc5bd | … | periodo 2026-07 | fecha_calculo 2026-11-20 | … TRUE`; `s33r_t2_celda.parquet: md5 3c86467b6a168b4a65a156a566caa079 | … | periodo 2026-10 | fecha_calculo 2026-10-15 | … TRUE`; `s33r_t2_meta.parquet: md5 2d1e5efacea263e39c63761ea91e490a | … | periodo 1999-01 | fecha_calculo 1999-01-01 | … TRUE`; `s33r_t2_sin.parquet: md5 b77238c3335c1dac6f4b119dda1c2053 | … | periodo 2026-12 | fecha_calculo 2026-12-01 | … TRUE`; todos `filas 39591`. = esperado.

**R.d — R-06, R-07 (registros), R-08, R-09, R-10:**
```
bash -c 'bash /tmp/s33r_r_varios.sh 2>&1 | grep -v "^- The project"'
```
esperado: `R-06 format(Sys.Date(), "%Y-%m"): 1 | literal "2026-07": 0 | cita contrato §3 col 13: 1 | message(: 1 | escribir_parquet_atomico(contexto: 1 | /Users/: 0 | fecha_calculo = Sys.Date(): 1`; `R-06 parse del blob de HEAD: ok`; R-07: `t2_oct`, `t2_nov` y `t2_meta` con `se conserva 1 | OK: 0`, `t2_celda` y `t2_sin` con `se conserva 0 | OK: 1`, los cinco `Error 0`; R-08: `t2_36a` y `t2_36b` con `se conserva 1 | OK: 0`; `mtime epoch` igual al de `2026-09-25T15:15:14`, `git diff --quiet HEAD rc 0`, último commit que toca el parquet `d935299` (s33q); `R-09 pruebas_a: pasos OK 6 | 'warning' 0 | ERROR 0 | detenido 0 | RESUMEN ejecutados: 31, 32, 33, 34, 35, 36`; `R-10 openssl md5: 417acd964a95f3616560a1b46a5ba81f motor | 417acd964a95f3616560a1b46a5ba81f docs`; Python: `motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1` e igual para `index.html` (**🔒1 PASA**).
obtenido: `R-06 format(Sys.Date(), "%Y-%m"): 1 | literal "2026-07": 0 | cita contrato §3 col 13: 1 | message(: 1 | escribir_parquet_atomico(contexto: 1 | /Users/: 0 | fecha_calculo = Sys.Date(): 1`; `R-06 parse del blob de HEAD: ok`; `R-07 t2_oct: se conserva 1 | OK: 0 | Error 0`, `t2_nov` y `t2_meta` iguales, `R-07 t2_celda: se conserva 0 | OK: 1 | Error 0`, `t2_sin` igual; `R-08 t2_36a: se conserva 1 | OK: 0`, `t2_36b` igual; `R-08 parquet: mtime epoch 1790360114 = 2026-09-25T15:15:14 epoch 1790360114 | git diff --quiet HEAD rc 0 | último commit que lo toca d935299`; `R-09 pruebas_a: pasos OK 6 | 'warning' 0 | ERROR 0 | detenido 0 | RESUMEN ejecutados: 31, 32, 33, 34, 35, 36`; `R-10 openssl md5: 417acd964a95f3616560a1b46a5ba81f motor | 417acd964a95f3616560a1b46a5ba81f docs`; `motor_idps.html eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4 fechas_normalizadas=1 bytes=59467463` e `index.html` idéntico (**🔒1 PASA**). = esperado.

**Paso 4 — alcance global:** medido en R.a (`R-12 fuera de alcance: []`, con el porcelain incluido en la lista de rutas: solo el LOG sin commitear). Nada no commiteado fuera del LOG.

**Paso 5 — regresión completa sobre el estado final (PRUEBAS a, b y c):**
```
bash -c 'bash /tmp/s33r_build.sh r_final completo; cd /Users/tomgc/Projects/slep_idps && Rscript -e "invisible(renv::status())" 2>&1 | head -5'
```
esperado: `rc=0 warn=0 pasos_ok=6 (Paso 31 OK … Paso 36 OK )`; `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; `payload eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14` con el mensaje de conservación; porcelain solo el LOG; `renv::status()` sin línea de activación y `No issues found -- the project is in a consistent state.` (**PRUEBAS a, b y c PASA**).
obtenido: `rc=0 warn=0 pasos_ok=6 (Paso 31 OK Paso 32 OK Paso 33 OK Paso 34 OK Paso 35 OK Paso 36 OK )`; `motor 417acd964a95f3616560a1b46a5ba81f docs 417acd964a95f3616560a1b46a5ba81f`; `payload eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4`; `parquet e375de305427fbbf667fa34ad5c650f7 mtime 2026-09-25T15:15:14` con `[36_contexto] Contenido sin cambios (salvo periodo y fecha_calculo): se conserva 40_salidas/publico/contexto_idps.parquet; no se reescribe.`; `porcelain: [?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md;]`; `No issues found -- the project is in a consistent state.` (sin línea de activación). = esperado: **PRUEBAS a, b y c PASA** sobre el estado final.

**Paso 6 — controles positivos de la auditoría: `bash /tmp/s33r_r_control.sh`, cuyo contenido es:**
```
R=/Users/tomgc/Projects/slep_idps
# C1 alcance: una ruta fuera de ALCANCE simulada en la lista de rutas
echo "docs/index.html" > /tmp/s33r_alcance_plantado.txt
bash /tmp/s33r_r_git.sh /tmp/s33r_alcance_plantado.txt | grep 'R-12'
# C2 renv.lock: otra entrada con la versión cambiada y una de las cuatro quitada, en una copia
cd $R && Rscript -e '
l <- jsonlite::fromJSON("/tmp/s33r_lock_despues.json", simplifyVector = FALSE)
otro <- setdiff(names(l$Packages), c("askpass", "curl", "Rcpp", "sys"))[1]
l$Packages[[otro]]$Version <- "0.0.0"
l$Packages$sys <- NULL
jsonlite::write_json(l, "/tmp/s33r_lock_plantado.json", auto_unbox = TRUE, pretty = TRUE)
cat("plantado en el lock: version de", otro, "cambiada; sys quitado\n")' 2>&1 | grep -v '^- The project'
cd $R && Rscript /tmp/s33r_r_lock.R /tmp/s33r_lock_antes.json /tmp/s33r_lock_plantado.json 2>&1 | grep -v '^- The project' | grep -E 'agregadas|^sys'
# C3 parquet: una celda de contenido alterada en una copia de la línea base
cp /tmp/s33r_contexto_fase0.parquet /tmp/s33r_r_plantado.parquet
cd $R && Rscript /tmp/s33r_plantar.R /tmp/s33r_r_plantado.parquet celda 2>&1 | grep -v '^- The project'
cd $R && Rscript /tmp/s33r_r_parquet.R /tmp/s33r_contexto_fase0.parquet /tmp/s33r_r_plantado.parquet 2>&1 | grep -v '^- The project' | tail -1
```
esperado: C1 `R-12 fuera de alcance: [docs/index.html ]` (dispara); C2 `plantado en el lock: version de <primera entrada> cambiada; sys quitado`, luego `agregadas: askpass,curl,Rcpp` con `cambiadas: [<esa entrada>]`, `agregadas = las cuatro: FALSE` y `sys lock AUSENTE … igual: FALSE` (dispara); C3 `plantado: valor +1 en 1 celda (fila 1 de 39591)`, `releido: 39591 filas` y `s33r_r_plantado.parquet: md5 <otro> | … | contenido igual a la referencia: FALSE` (dispara).
obtenido: C1 `R-12 rutas: 30_procesamiento/36_exponer_contrato_contexto.R 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md docs/index.html renv.lock` y `R-12 fuera de alcance: [docs/index.html ]` (dispara); C2 `plantado en el lock: version de R6 cambiada; sys quitado`, `entradas antes 42 despues 45 | agregadas: askpass,curl,Rcpp | quitadas: [] | cambiadas: [R6]`, `agregadas = las cuatro: FALSE`, `sys lock AUSENTE (Source -, campos -) | DESCRIPTION instalado 3.4.3 | igual: FALSE` (dispara); C3 `plantado: valor +1 en 1 celda (fila 1 de 39591)`, `releido: 39591 filas`, `s33r_r_plantado.parquet: md5 eca2557c81a0a01da01fb0c942ab52a2 | filas 39591 | periodo 2026-07 | fecha_calculo 2026-09-25 | contenido igual a la referencia: FALSE` (dispara; el md5 plantado es el mismo que dio el plantado del banco en T2.2, porque es la misma alteración sobre el mismo archivo). = esperado: **los tres controles positivos disparan.**

**Paso 7 — hallazgos** (de la auditoría y de leer lo hecho contra el encargo y el contrato; ninguno toca un 🔒):
- **H-1 (ADVIERTE):** el parquet publicado conserva `periodo 2026-07` con `fecha_calculo 2026-09-25` (lo que s33q dejó como H-2). Con la regla nueva el archivo no se reescribe mientras el contenido no cambie, así que esa pareja incoherente se mantiene hasta el próximo cambio de dato; el script nuevo, corrido hoy sobre un archivo ausente, escribiría `2026-09`. Es la conducta que el encargo pide (md5 igual a FASE 0) y la decisión del titular ("conserva el archivo y sus metadatos"); queda como duda D-1.
- **H-2 (ADVIERTE):** `periodo` sale de `Sys.Date()` al definir la constante y `fecha_calculo` de otra llamada a `Sys.Date()` dentro del `mutate`, después de leer la fuente (unos 2 s en el banco). Una corrida que cruce la medianoche del último día de un mes escribiría un `periodo` que no es el mes de `fecha_calculo`. Seguí la línea literal del encargo; la reparación (capturar la fecha una vez) se aparta de esa línea, así que no es REPARA: duda D-2.
- **H-3 (ADVIERTE):** `renv.lock` tiene ahora seis entradas mínimas (`Package`, `Version`, `Source`), sin `Hash` ni `Requirements`: las dos de s33q y las cuatro de hoy. `renv::status()` las da por consistentes; un `renv::restore()` en una biblioteca vacía las resolvería por versión en el repositorio del lock, lo que esta sesión no midió (no está autorizado y exigiría red). Duda D-3.
- **H-4 (ADVIERTE):** quedan en `/tmp` los temporales `/tmp/s33r_*`, entre ellos el clon APFS `/tmp/s33r_clon` (copia de todo el repo con su `.git`; comparte bloques con el original hasta que se escribe). La lista cerrada prohíbe `rm`. Duda D-4.
- **H-5 (ADVIERTE):** convención del log: el bloque de M1 y M2 escrito por el comando fallido (E-1) quedó truncado en el archivo (título, apertura de código y `bash -c R=/Users/tomgc/Projects/slep_idps`); lo cierra la corrección que lo sigue y la repetición con su `esperado:`. No hay comando corrido antes de su `esperado:` en esta sesión.

**Paso 8 — ciclo de reparación:** no aplica (0 REPARA). **Paso 9 — prohibiciones:** ningún criterio, tolerancia ni esperado se ajustó; ningún ALCANCE se amplió; ningún 🔒 se tocó; lo escrito en el log no se editó (solo se anexa; el slot J se rellena en FASE L).

**Paso 10 — tabla de auditoría y veredicto:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | `<inicio>` `ea7631f`, hijo de `5b629dd` = remoto; stash vacío; tres archivos | `git cat-file`, `git ls-remote`, `refs/stash`, `git diff-tree` (R.a) | así | así | PASA | ninguna | — | — |
| R-02 | versiones instaladas de los cuatro | `read.dcf` del `DESCRIPTION` (R.b) | 1.2.1, 8.0.0, 1.1.2, 3.4.3 | así | PASA | ninguna | — | — |
| R-03 | caso malo: mismo contenido, md5 distintos, `periodo` fijo | arrow `Table$Equals` y `tools::md5sum` (R.c) | `TRUE`; `fd7cd29a…` y `48612c7b…`; `2026-07` | así | PASA | ninguna | — | — |
| R-04 | `renv.lock` solo gana las cuatro entradas (regla 3) | `jsonlite` sobre los blobs de `ea7631f` y `HEAD` (R.b) | 42 → 46; quitadas y cambiadas vacías | así | PASA | ninguna | — | control C2 dispara |
| R-05 | PRUEBAS c | `renv::status()$synchronized` (R.b) y regresión (paso 5) | `TRUE`; sin "out-of-sync" | así | PASA | ninguna | — | — |
| R-06 | el script nuevo hace lo que pide el encargo | `grep -F` sobre el blob de `HEAD` y `parse()` (R.d) | 1, 0, 1, 1, 1, 0, 1; ok | así | PASA | ninguna | — | — |
| R-07 | banco: no reescribe con otra fecha ni con solo metadatos; reescribe con celda o sin archivo | registros de corrida (R.d) y arrow `Table` (R.c) | conserva ×3, escribe ×2; contenido `TRUE` ×3 | así | PASA | ninguna | — | control C3 dispara |
| R-08 | en el repo el parquet no se reescribe | registros de `t2_36a`/`b`, `mtime` en época, `git diff --quiet` (R.d) | conserva ×2; 1790360114; rc 0 | así | PASA | ninguna | — | — |
| R-09 | PRUEBAS a | registro de la corrida (R.d) y otra corrida completa (paso 5) | 6 pasos, 0 warnings, porcelain solo el LOG | así | PASA | ninguna | — | — |
| R-10 | 🔒1 motor y §8.2 | `openssl md5` y §8.2 en Python (R.d); regresión | `417acd96…`; `eb4e00b3…` | así | PASA | ninguna | — | calibración M3 (fecha calla, plantado dispara) |
| R-11 | 🔒2 contenido del contrato | arrow `Table$Equals` (R.c) | `TRUE`, md5 `e375de30…` | así | PASA | ninguna | — | control C3 dispara |
| R-12 | 🔒3 alcance | `comm` contra la unión de ALCANCE y el LOG, con porcelain (R.a) | `[]` | `[]` | PASA | ninguna | — | control C1 dispara |
| R-13 | asuntos de commit literales; cadena de padres | `grep -F` en el encargo; `git log %p` (R.a) | 3 de 3; cadena | así | PASA | ninguna | — | — |
| H-1 | `periodo 2026-07` con `fecha_calculo 2026-09-25` persiste | lectura (R.c) | — | así | ADVIERTE | a Dudas (D-1) | — | — |
| H-2 | dos llamadas a `Sys.Date()` | lectura del script | — | así | ADVIERTE | a Dudas (D-2) | — | — |
| H-3 | seis entradas mínimas en `renv.lock`; `restore` no probado | lectura (R.b) | — | así | ADVIERTE | a Dudas (D-3) | — | — |
| H-4 | temporales y clon en `/tmp` | `ls /tmp` | — | así | ADVIERTE | a Dudas (D-4) | — | — |
| H-5 | bloque truncado en el log (E-1) | lectura del log | — | así | ADVIERTE | declarado | — | — |

- **Veredicto de FASE R: APROBADO CON ADVERTENCIAS (0 BLOQUEA / 0 REPARA / 5 ADVIERTE: H-1 a H-5).** Sin ciclos de reparación. Los 🔒 1 a 3 PASA; PRUEBAS a, b y c PASA sobre el estado final; controles positivos 3 de 3.
- **Subagentes:** sin subagentes.

### FASE L: cierre del log

**L.1 y L.4 — porcelain, worktree, procesos propios y privacidad** (`/tmp/s33r_priv.sh`, copia de `/tmp/s33q_priv.sh` con la ruta de este LOG y su propio archivo de control; control plantado armado en el script, sin imprimirlo):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps worktree list; echo "procesos propios: $(pgrep -fl "s33r_" | grep -v pgrep | wc -l | tr -d " ")"; bash /tmp/s33r_priv.sh'
```
esperado: porcelain solo el LOG; una entrada de worktree (`f68bc57 [main]`); `procesos propios: 0`; `control plantado: RUT 1 | RBD con número 1 | nombre 1`; el LOG `RUT 0 | RBD con número 0 | nombre 0`.
obtenido: `?? 50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md` (única); `/Users/tomgc/Projects/slep_idps f68bc57 [main]` (una); `procesos propios: 0`; `control plantado: RUT 1 | RBD con número 1 | nombre 1`; `20260925_renv_periodo_s33r_log.md: RUT 0 | RBD con número 0 | nombre 0`. = esperado: **privacidad PASA**; el log no trae filas del parquet (solo nombres de columna, tipos, conteos, md5 y los valores de `periodo` y `fecha_calculo`, que son metadatos de corrida).

**L.2 — secciones de cierre.**

- **Resumen:** dos tareas, las dos completadas. T1 registró en `renv.lock` las cuatro dependencias de `V8` y `openssl` que s33q había instalado sin registrar (`askpass 1.2.1`, `curl 8.0.0`, `Rcpp 1.1.2`, `sys 3.4.3`): `renv::status()` pasa de "out-of-sync" a consistente. T2 hizo que el productor del contrato de contexto derive `periodo` de la fecha de corrida y reescriba el parquet solo si cambió su contenido: con el script anterior, el mismo contenido corrido en tres fechas daba tres md5; con el nuevo, el archivo no se toca (md5 y `mtime` de FASE 0) y el build completo deja el árbol limpio. El script sí reescribe si cambia una celda o si falta el archivo, y no reescribe si solo cambian `periodo` o `fecha_calculo`. El motor no cambió (`417acd96…`, §8.2 `eb4e00b3…4dc4`) ni el contenido del contrato (39.591 × 15, `e375de30…`).
- **Commits** (`git log --oneline --reverse 5b629dd..HEAD`, más el de este LOG): `ea7631f` chore(encargo): s33r y s33s, y parte A de la decisión de exportación (FASE 0); `fe7ccb8` chore(renv): registra askpass, curl, Rcpp y sys, dependencias de V8 y openssl (s33r T1, D-1 de s33q) (T1); `f68bc57` fix(contexto): periodo derivado de la fecha de corrida y escritura solo si cambia el contenido (s33r T2, D-2 de s33q) (T2); y `docs(log): s33r renv y periodo` (FASE L). Ningún `fix(auditoria)`.
- **Auditoría:** APROBADO CON ADVERTENCIAS (0 BLOQUEA / 0 REPARA / 5 ADVIERTE: H-1 a H-5); sin reparaciones; controles positivos 3 de 3 (ruta fuera de alcance; entrada ajena cambiada y una de las cuatro quitada en el lock; celda alterada en el parquet). Tabla en FASE R, paso 10.
- **Invariantes:** 🔒1 PASA (motor y `docs/` `417acd964a95f3616560a1b46a5ba81f`, §8.2 `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` en FASE 0, en `run_all(only = 36)` ×2, en PRUEBAS a ×2 y en Python); 🔒2 PASA (`identical()` en T2.4 y `Table$Equals` en FASE R: contenido idéntico; además md5 del parquet igual); 🔒3 PASA (`git diff --name-only ea7631f..HEAD` = `renv.lock` y el script; más el LOG sin commitear).
- **Decisiones del usuario registradas** (§1 del encargo, sesión 33, criterio delegado): D-1 de s33q → registrar las cuatro dependencias; D-2 de s33q → `periodo` se deriva de la fecha de corrida; el productor reescribe el parquet solo si cambió su contenido (todas las columnas salvo `periodo` y `fecha_calculo`) y, si no cambió, conserva el archivo y sus metadatos.
- **Estado de cifras:** parquet de contexto `e375de305427fbbf667fa34ad5c650f7` antes y después (39.591 × 15, 201.846 B, `mtime` 2026-09-25T15:15:14 intacto); `renv.lock` `ca387b08…` (42 entradas, 1.631 líneas) → 46 entradas (+20 líneas, 0 borradas); motor `417acd96…` sin cambios; script 36 `bcc28fab…` → `763e8530…`.
- **Dudas y pendientes consolidados (con pregunta cerrada):**
  - **D-1 (H-1, `periodo` del parquet publicado):** el parquet sigue diciendo `periodo 2026-07` con `fecha_calculo 2026-09-25`, y con la regla nueva seguirá así hasta que cambie el dato. ¿(a) se deja hasta el próximo cambio de contenido, o (b) encargo que lo regenere una vez para que diga `2026-09` (cambia el md5, no el contenido)? Nada quedó bloqueado.
  - **D-2 (H-2, dos lecturas de la fecha):** `periodo` y `fecha_calculo` salen de dos llamadas a `Sys.Date()` separadas por la lectura de la fuente; una corrida que cruce la medianoche de fin de mes los desalinearía. ¿(a) se deja, o (b) encargo chico para leer la fecha una vez (`FECHA_CORRIDA <- Sys.Date()` y de ahí las dos columnas)? Nada quedó bloqueado.
  - **D-3 (H-3, entradas mínimas del lock):** seis entradas (`V8`, `openssl`, `askpass`, `curl`, `Rcpp`, `sys`) van sin `Hash` ni `Requirements`; `renv::status()` las acepta, pero un `renv::restore()` desde cero no se probó. ¿(a) se deja, (b) encargo que pruebe `renv::restore()` en un clon, o (c) encargo que las complete con `renv::snapshot()`? Nada quedó bloqueado.
  - **D-4 (H-4, temporales):** `/tmp/s33r_*` (instrumentos, copias de parquet y el clon `/tmp/s33r_clon`) quedan en disco porque la lista cerrada prohíbe `rm`. ¿(a) los borra el titular, (b) se autoriza su borrado en el próximo encargo, o (c) se dejan a la limpieza de `/tmp` del sistema? Nada quedó bloqueado.
  - Siguen abiertas, fuera del alcance de este encargo, D-3 de s33q (el consumidor recibe `eje_etiqueta` en UTF-8) y D-4 de s33q (porcelain del hermano).
- **Errores propios consolidados:** E-1 (FASE 0: anexo del log y medición en un solo `bash -c` con comillas simples anidadas; el bloque de M1 y M2 quedó truncado en el log y los `git -C` corrieron con la ruta vacía, sin efecto en el repo; costó una repetición de M1 y M2 y cambió el método: fragmentos en archivo y scripts en `/tmp/s33r_*`); un esperado propio con un orden de `sort` que no era el de macOS (T1.2; el conjunto era el correcto).
- **Notas para el revisor:** (1) leer el diff de `f68bc57` junto al contrato §3: la comparación es estricta y excluye solo `periodo` y `fecha_calculo`; un archivo sin las 15 columnas en su orden se reescribe. (2) La próxima vez que cambie el dato (un definitivo nuevo), el paso 36 reescribirá el parquet con `periodo` del mes de corrida: conviene mirar ese primer diff. (3) H-1 a H-3 son decisiones pequeñas del titular (D-1 a D-3).
- **Estado de cierre:** FASE 0, T1, T2, FASE R y FASE L completadas; ninguna tarea congelada. Queda commiteado todo lo de `ea7631f..HEAD` más este LOG. El push de `main` va después de este commit, una vez y en comando aparte, si el porcelain queda vacío y `HEAD..origin/main` = 0 tras un `fetch`; publica los tres commits de arriba y el `docs(log)`. `CLAUDE.md` (no versionado) se actualiza después del push, según la instrucción global del titular. No se tocó `docs/`, la plantilla ni el generador del motor.

**L.5 — verificación del archivo:**
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260925_renv_periodo_s33r_log.md; ls -l $L && wc -l $L; echo "FASE=$(grep -c "^### FASE" $L) esperado=$(grep -c "^esperado:" $L) obtenido=$(grep -c "^obtenido:" $L) J=$(grep -c "^## J" $L) J_campos=$(awk "/^## J/,/^## Registro/" $L | grep -c "^- ")"; bash /tmp/s33r_priv.sh | tail -1'
```
esperado: `FASE=5` (FASE 0, T1, T2, R, L); `esperado` = `obtenido` + 1 al medir (este par todavía sin su `obtenido:`); `J=1` con `J_campos=13`; privacidad `RUT 0 | RBD con número 0 | nombre 0`.
obtenido: `65585` bytes y `385` líneas al medir; `FASE=5 esperado=19 obtenido=18 J=1 J_campos=13`; `RUT 0 | RBD con número 0 | nombre 0`. Con esta línea, **19 = 19**.
- **L.6:** `git add` del LOG (solo el LOG) y commit `docs(log): s33r renv y periodo`; luego, tras un `fetch`, se mide porcelain vacío y `HEAD..origin/main` = 0, y `git push origin main` una vez, en comando aparte (FASE R no terminó en `BLOQUEADO`). Publica `ea7631f`, `fe7ccb8`, `f68bc57` y el `docs(log)`.
- **Estado de FASE L:** completada.

## Cierre

s33r cerrado: `renv.lock` registra las cuatro dependencias de `V8` y `openssl` y `renv::status()` queda consistente; el paso 36 deriva `periodo` de la fecha de corrida y ya no reescribe el parquet de contexto cuando su contenido no cambia, así que el build completo deja el árbol limpio (parquet `e375de30…` con su `mtime` de FASE 0). El motor no cambió (`417acd96…`, §8.2 `eb4e00b3…4dc4`). FASE R APROBADO CON ADVERTENCIAS (0/0/5), controles positivos 3 de 3; cuatro dudas para el titular.
