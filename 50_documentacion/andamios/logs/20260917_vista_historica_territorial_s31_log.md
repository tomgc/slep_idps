# Log de sesión: vista histórica del panorama territorial y corrección del estado nulo (s31)

- **Meta:** implementar P-VISTA-TERRITORIAL (decisión `20260917_decision_vista_historica_territorial.md`: franja de estado por año + matriz establecimiento × año calibrada) y corregir el estado vs GSE nulo contado como "sin diferencia" (decisión §6), sin desplegar a `docs/`.
- **Fecha:** 2026-09-17
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main`
- **HEAD al empezar:** `bc42fad` (= `origin/main`). PUNTO DE RETORNO `<PR>`: se toma tras el commit de T0 (FASE 0 paso 2); se registra abajo.
- **ENTORNO:** Claude Code en la estación macOS del titular; R 4.5.2 con `renv` del proyecto; `bash -c` explícito en todo comando de shell; `Rscript` en todo cálculo sobre datos.
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real de la sesión:** Opus 5 (1M), efecto de sesión `ultracode` activado por el titular pero el encargo prohíbe subagentes y workflows: se ejecuta en solo, en serie (el encargo manda).
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_vista_historica_territorial_s31.md` (patrón v1.6).
- **Grafo de tareas (copiado del encargo):**

```
T0 (registro de sesión)         independiente
T1 (estado nulo)                independiente
T2 (meta en R)                  independiente
T3 (vista histórica)            requiere T1 y T2
FASE R                          corre siempre, después de la última tarea (congeladas incluidas)
FASE L                          corre siempre, al final
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando que falle por causa transitoria.

## J. Juicio
- Meta y resultado: vista histórica del panorama territorial (franja de estado por año + matriz establecimiento × año calibrada) y corrección del estado vs GSE nulo, sin desplegar a `docs/` → cumplida, en una línea.
- Estado por tarea: T0 completada (`c93ea6d`) · T1 completada (`f2aecd5`) · T2 completada (`68b4e43`) · T3 completada (`b699466`) · FASE R completada (`ebf6090`).
- Commits: 6, rango `c93ea6d`..`<docs(log)>` (`git log --oneline`), de los cuales 1 fix(auditoria).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/1/3; reparados 1; abiertos 0 (advertencias A-1, A-2, A-3 registradas como P-1, D-2, D-3).
- Invariantes: 7/7 PASA; FALLA: ninguno.
- Cifras críticas: intactas (evidencia: SHA-256 §8.2 `1e29c2b5…b5b6` sin el bloque nuevo en T2, T3 y estado final; `cmp -l` solo en `fecha_generacion`; 🔒5/🔒6 = 0).
- Decisiones autónomas de mayor riesgo: (1) chip de la tarjeta "· sin comparación publicada" contra la premisa §1 (alternativa: dejar "≈ en su GSE" sobre ausencia total; reversible); (2) `title`/`aria` de la barra "con comparación publicada" en vez de "con dato" (alternativa: conservar; reversible); (3) `gseVis` incorpora la llave `"sin"` y `.pan-nivel` pasa a `flex-wrap` (alternativa: estado aparte / ancho fijo; reversible).
- Desviaciones respecto del encargo: premisa §1 sobre `alertSummary` refutada y corregida bajo T1 paso 5; `40_salidas/motor_idps.html` queda regenerado sin commitear (ningún ALCANCE lo cubre) y por eso no hay push; el log aparece en porcelain en el PUNTO DE RETORNO (previsto).
- Dudas abiertas: 3; D-2 ¿se commitea el motor regenerado en un commit `build:` tras el visto bueno (sí/no)? · D-3 ¿se mantiene el chip "· sin comparación publicada" en la tarjeta (sí/no)? · D-1 ¿se renombra `n_con_dato` a `n_con_comparacion` (sí/no)?
- Errores propios: 8 registrados (4.1); ninguno costó más de un turno.
- Qué debe verificar el revisor por sí mismo: el aspecto visual de la vista histórica (colores, tipografía de marca, densidad de la matriz) y su comportamiento en una región grande; esta sesión midió cifras, contraste y layout, no gusto.
- No publicado / queda al usuario: push retenido (árbol con el motor regenerado); despliegue a `docs/` pendiente del visto bueno; decisión D-2.
- Ejecución: modo de sesión ultracode (efecto) ejecutado como xhigh en solo por contrato; subagentes 0, por contrato.

## Registro por fase

### FASE 0: log, punto de retorno y mediciones

- **Estado:** completada.
- **Commits:** `c93ea6d` docs(s31): decision, encargo, mockup y registro de la vista historica territorial (T0, ejecutada dentro de esta fase).
- **PUNTO DE RETORNO `<PR>`:** `c93ea6d`.
- **Cambios sustantivos:** ninguno en código. Se creó este log y `/tmp/idps_s31/` (instrumentos: `extraer_json.R`, `hash_json.R`, `medir_fase0.R`; `base.json`).
- **Verificación:**

Medición previa a la creación del log (solo lectura), porque el paso 2 exige que no haya rutas ajenas a T0:
```
bash -c 'git fetch --quiet && git status --porcelain && git stash list'
```
esperado: solo las cuatro rutas de T0 como `??`; stash vacío.
obtenido: las cuatro rutas de T0 **más** `?? "Claude outputs/"` (carpeta no trackeada, nunca commiteada, con copias de los mismos cuatro archivos; el mockup ahí era una versión anterior, 78.134 bytes, 11:40). Stash vacío. Condición de detención del paso 2 disparada **antes de escribir nada**. Se consultó al titular (gate); autorizó explícitamente `rm -rf "/Users/tomgc/Projects/slep_idps/Claude outputs"` y continuar. Ejecutado. Ver Decisiones del usuario (FASE L §5).

Paso 2, tras crear el log:
```
bash -c 'git fetch --quiet && git status --porcelain && git stash list && echo "HEAD=$(git rev-parse --short HEAD) origin/main=$(git rev-parse --short origin/main)"'
```
esperado: solo las cuatro rutas de T0 como `??` (más este log, creado en el paso 1); stash vacío; HEAD = origin/main = `bc42fad`.
obtenido: `?? 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`, `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_vista_historica_territorial_s31.md`, `?? 50_documentacion/andamios/diseno/detalles/mockup_vista_historica_territorial.html`, `?? 50_documentacion/andamios/logs/20260917_registro_asistente_s31.md`, `?? 50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md`; stash vacío; `HEAD=bc42fad origin/main=bc42fad`.

T0 (verificación y commit):
```
bash -c 'grep -c "^|" 50_documentacion/andamios/logs/20260917_registro_asistente_s31.md'
```
esperado: ≥ 3.
obtenido: `3`.
```
bash -c 'git add -- <4 rutas de T0> && git commit -m "docs(s31): decision, encargo, mockup y registro de la vista historica territorial" && git status --porcelain && git rev-parse --short HEAD'
```
esperado: commit creado; porcelain vacío salvo este log; hash registrado como `<PR>`.
obtenido: `c93ea6d`; porcelain: `?? 50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md` (solo el log); `<PR>` = `c93ea6d`.

Paso 3, línea base de `run_all(only = 35L)`:
```
bash -c 'md5 -q 40_salidas/motor_idps.html; Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31/run35_fase0.log 2>&1; echo rc=$?; grep -inE "warning|advertencia|error" /tmp/idps_s31/run35_fase0.log; grep -c WARN /tmp/idps_s31/run35_fase0.log; md5 -q 40_salidas/motor_idps.html'
```
esperado: exit 0; warnings literales anotados (línea base); md5 puede diferir de `2f34dafe…` solo por `fecha_generacion`.
obtenido: md5 antes `2f34dafe1309b67e5e1e1cfb3eea47a3` (5.431.955 bytes); `rc=0`; grep de warnings: **vacío** (0 líneas WARN; 70 líneas de salida; `[s21] prom_gse: 69646 con valor, 296738 NA`, `[s14] primer_anio_familia: ind=2014 dim=2018 niv=2023`, `[s19] grados_ee: 9103`, `JSON: 59.5 MB plano -> 4.41 MB gzip+base64`); md5 después `2f34dafe1309b67e5e1e1cfb3eea47a3` (idéntico: la fecha de generación del motor versionado es también 2026-09-17). **Línea base de warnings: ninguno.**

Paso 4, JSON y SHA-256 (§8.2):
```
bash -c 'Rscript /tmp/idps_s31/extraer_json.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/idps_s31/base.json && cd /tmp/idps_s31 && Rscript /tmp/idps_s31/hash_json.R /tmp/idps_s31/base.json --calibrar'
```
esperado: 59.466.778 bytes; SHA-256 `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo distinto; control negativo igual.
obtenido: `gzip/zlib bytes: 3306034; cabecera 78 9c` (zlib, como anota CLAUDE.md); `JSON bytes: 59466778`; `bytes: 59466778`; `sha256: 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; `control positivo (digito 7 -> 8 en pos. 10824564): 73bf3cf4…a2f5 -> DISTINTO (ok)`; `control negativo (recalculo sobre la original): IGUAL (ok)`. **Regla 0.1-1 no dispara.**

Paso 5, mediciones (`Rscript /tmp/idps_s31/medir_fase0.R` sobre `base.json`):
```
bash -c 'Rscript /tmp/idps_s31/medir_fase0.R'
```
esperado: años con `sigdifgru` no nulo = 2024, 2025 en 4b y en 2m.
obtenido: `2m 2024, 2025`; `4b 2024, 2025`.
esperado: en 4b 2025, 900 RBD con `prom` no nulo y `sigdifgru` nulo en algún indicador, 2 con `cod_slep = "503"`.
obtenido: `900 RBD …; 2 con cod_slep 503`.
esperado: en 2024–2025, 0 filas con `sigdifgru` nulo y `difgru` no nulo.
obtenido: `0 filas`.
esperado: SLEP 503, 4b 2025, GSE "3", indicador 1: 28 RBD con `prom`; −1: 9, 0: 15, +1: 2, nulo: 2.
obtenido: `28 RBD con prom; -1 9; 0 15; 1 2; nulo 2`.
Extra (sin `esperado:` previo en el encargo; sirve de calibración para T1): GSE "1", mismo corte: 10 RBD con prom; −1: 6, 0: 3, +1: 1, nulo: 0. Y 3.495 celdas EE × indicador con `prom` y `sigdifgru` nulo en 4b 2025, de 26.328 con `prom` (13,3 %; coincide con el comentario de `estadoVsGse`).

Paso 6, línea base de 🔒7:
```
bash -c 'grep -c "text-transform" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: un entero (línea base).
obtenido: `0`.

- **Alcance:** T0 ⊆ su ALCANCE (4 rutas). Además este log (previsto).
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings (línea base).
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** (1) `digest` no está en el `renv` del proyecto (`requireNamespace` FALSE bajo renv; TRUE en la librería del sistema, 0.6.37): el instrumento de hash corre con `cd /tmp/idps_s31 && Rscript` (fuera de la activación de renv), mismo binario R 4.5.2. Alternativa descartada: instalar `digest` en renv (no autorizado; tocaría `renv.lock`). Reversible. (2) El log aparece en `git status --porcelain` en el PUNTO DE RETORNO; se interpreta como previsto (FASE L: "vacío, o solo el log").
- **Errores propios:** (1) Primer `extraer_json.R` recortó el base64 con `substr` por caracteres sobre offsets en bytes (falló `base64_dec`); corregido con `regmatches`. Costo: 1 rehecho. (2) Primer control positivo de `hash_json.R` alteró una coma en vez de un dígito por el mismo desajuste bytes/caracteres; el hash cambió igual (control válido) pero se rehizo para que altere un dígito, como pide el encargo. Costo: 1 rehecho.
- **Dudas:** ninguna.

### FASE T1: el estado nulo no se cuenta como "sin diferencia"

- **Estado:** completada.
- **Commits:** `f2aecd5` fix(motor): el estado vs GSE nulo no se cuenta como sin diferencia.
- **Paso 0, inventario de lecturas de `sigdifgru`** (`grep -n sigdifgru` sobre el template en `<PR>`, 24 coincidencias; se clasifican las que leen el valor, no los comentarios):

| línea (PR) | lectura | clasificación | razón |
|---|---|---|---|
| 739 `indOf` | copia el campo al objeto de medida | no afectada | es el lector; no interpreta |
| 837 `alertSummary` + 858 chip `≈ en su GSE` de `Card` | cuenta ±1; el chip "≈" se muestra con `dato>0` y sin ±1 | **afectada** (refuta la premisa §1 "no está afectada") | con `prom` en ≥1 indicador y `sigdifgru` nulo en todos, el chip afirmaba "≈ en su GSE": 892 EE en 4b 2025 y 14 en 2m 2025 (2 del SLEP foco), medido con `Rscript /tmp/idps_s31/medir_chip.R` |
| 896 `repartoInd` | `else neutro++` absorbía el nulo | **afectada** (decisión §6) | 3.495 celdas en 4b 2025 |
| 1050/1054 `serieEje` | propaga nulo como nulo | no afectada | no interpreta |
| 1151–1152 tooltip `BarrasAnio` | protegido por `p.difgru!=null` (L1149) | no afectada | en 2024–2025, 0 filas con `sigdifgru` nulo y `difgru` no nulo (FASE 0) |
| 1255 y 1401 `Ancla` (ficha) | `Ancla` con `dif==null` pinta "sin dato"; 1255 además guarda `difgru!=null` | no afectada | no deriva estado del nulo |
| 1690 `CeldaEE` | `"neutro"` por descarte | **afectada** (decisión §6) | pintaba "=" |
| 1951–1952 `estadoVsGse` | ya devuelve `CSV_SIN_CMP_GSE` | no afectada | es la referencia correcta |
| 2001+ `filasComparadorCSV` | usa `repartoInd` | **afectada** vía `repartoInd`; columna nueva | decisión §6 |

- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`):
  1. `repartoInd` devuelve `{bajo, neutro, sobre, sin, N}`; `neutro` solo con `sigdifgru === 0`, `sin` con `prom != null && sigdifgru == null`, `N = bajo + neutro + sobre`. Valores posibles del campo verificados en el payload: {−1, 0, 1, nulo}.
  2. `StackedBar`: 100 % = `N`; con `rep.sin > 0` nota `+{sin} sin comparación publicada` (`.s100-sin`, `--gris`, `--fs-overline`, con `title`), después de la tira externa; `aria-label` la incluye; con `N === 0` y `sin > 0` la barra dice "sin dato" y la nota se muestra. El `title` de la barra y el `aria-label` pasan de "con dato" a "con comparación publicada" (decisión autónoma, abajo).
  3. `CeldaEE`: estado `sin` en `EST_EE` (glifo "·", texto "sin comparación publicada", `--st-neutro-txt`); `.ee-gl.sin` con el aspecto neutro; `.ee-st.sin` con `white-space:normal`.
  4. `CSV_CMP_COLS` + `filasComparadorCSV`: columna `n_sin_comparacion` tras `n_sobre`; `n_con_dato` = `N`; filas de establecimiento con un blanco más.
  5. `alertSummary` devuelve además `cmp` y `sin`; el chip "≈ en su GSE" exige `cmp > 0`; con `dato > 0 && cmp === 0` chip neutro "· sin comparación publicada" (con `title`).
  6. Comentario de `estadoVsGse` actualizado: la divergencia pantalla↔CSV queda cerrada (P-ESTADO-SIN-COMPARACION).
- **Verificación** (Babel 7.29.0 en node para sintaxis; motor regenerado; Puppeteer 25.9.0 + Chrome del sistema, `file://`, viewport 1200 y 430; script `t1_verif.js` del scratchpad; salida en `/tmp/idps_s31/t1_verif_out.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `JSX OK`.
obtenido: `JSX OK — 1992 lineas de fuente -> 170172 bytes transpilados`.
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31/run35_t1.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31/run35_t1.log'
```
esperado: `rc=0`; 0 warnings nuevos.
obtenido: `rc=0`; `WARN: 0`; grep de warning/error vacío. md5 del motor `bcbca3c9803819045fbe6d939812b20c`.
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t1_verif.js /tmp/idps_s31/motor_fase0.html /tmp/idps_s31/motor_t1.html'
```
esperado: panorama, SLEP Costa Central, 4° básico, sección Medio, Autoestima: 100 % = 26; bajo 9, sin diferencia 15, sobre 2; nota `+2 sin comparación publicada`.
obtenido: `title: 100% = 26 establecimientos con comparación publicada`; segmentos `9 de 26 (34%)`, `15 de 26 (58%)`, `2 de 26 (8%)`; `sin: +2 sin comparación publicada`.
esperado: calibración sobre el motor de FASE 0 (caso malo conocido): 100 % = 28 con 17 sin diferencia.
obtenido: `title: 100% = 28 establecimientos con dato`; `17 de 28 (61%)`; sin nota. El criterio distingue los dos motores.
esperado: sección Bajo, mismo nivel e indicador: 100 % = 10; bajo 6, sin diferencia 3, sobre 1; sin nota.
obtenido: `100% = 10 …`; `6 de 10 (60%)`, `3 de 10 (30%)`, `1 de 10 (10%)`; `sin: null`. Idéntico en FASE 0 (caso bueno conocido).
esperado: CSV del comparador con SLEP Costa Central, 4° básico, GSE Medio, indicador 1: `n_con_dato` 26, `n_neutro` 15, `n_sin_comparacion` 2, porcentajes idénticos a los de la barra.
obtenido: encabezado `…,n_con_dato,n_bajo,n_neutro,n_sobre,n_sin_comparacion,pct_bajo,…` (BOM `239,187,191`, 21 líneas); fila `gse 3 Medio: n_con_dato 26 n_bajo 9 n_neutro 15 n_sobre 2 n_sin_comparacion 2 pct 34/58/8` (= barra). Fila Bajo: `10/6/3/1/0, 60/30/10`.
esperado: etiquetado de barra: 0 spans truncados a 1200 px y a 430 px.
obtenido: `1200: {"truncados":0,"spans":38}`; `430: {"truncados":0,"spans":30}` (a 430 el segmento "▲ 8% (2)" baja a la tira externa, sin truncar). Consola: `errs: []` en las dos páginas.
esperado (propio, para el cambio 5): en la sección Medio del SLEP foco, 4b, 2 tarjetas con el chip "· sin comparación publicada" y ninguna de ellas con "≈ en su GSE".
obtenido: `Medio | cards 28 chipsSin 2 chipsAprox 6` (FASE 0: `chipsSin 0 chipsAprox 8`: las dos tarjetas que decían "≈" pasan al chip nuevo; Bajo/Medio bajo/Medio alto sin cambio).
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE. `40_salidas/motor_idps.html` queda modificado en el árbol por la regeneración (PRUEBAS) y **no** está en ningún ALCANCE: no se commitea (0.2); va como duda.
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno en el código. En el instrumento: `t1_verif.js` buscaba la pestaña "Comparador" y el rótulo real es "Comparación entre territorios" (1 reintento, corregido).
- **Decisiones autónomas:** (1) `Card`/`alertSummary` clasificada como afectada contra la premisa §1, por medición (892 EE); fix con el mismo criterio de §6. Alternativa descartada: dejar el chip "≈ en su GSE" sobre ausencia total de comparación. Reversible (un `if`). (2) `title` y `aria-label` de la barra dicen "con comparación publicada" en vez de "con dato": con la nota bajo la barra, "26 con dato" mentiría (28 tienen dato). Alternativa descartada: conservar "con dato". Reversible. (3) `.ee-st.sin` con `white-space:normal` para que "sin comparación publicada" no desborde una columna comprimida del comparador (pendiente 5 del traspaso v29). Reversible.
- **Errores propios:** ninguno.
- **Dudas:**
  1. `n_con_dato` ya no significa "con puntaje" sino "con comparación publicada"; se conserva el nombre por contrato. Pregunta cerrada: ¿se renombra a `n_con_comparacion` en el próximo encargo de exportación (sí/no)? Bloquea: nada.
  2. `40_salidas/motor_idps.html` (salida versionada) se regenera en cada tarea y no está en ningún ALCANCE. Pregunta cerrada: ¿se commitea el motor regenerado en un commit `build:` propio tras el visto bueno visual (sí/no)? Bloquea: el `git push` de FASE L (0.2 exige porcelain vacío).

### FASE T2: calibración y años con estado, en R

- **Estado:** completada.
- **Commits:** `68b4e43` feat(motor): calibracion de color y anios con estado para la vista historica territorial.
- **Cambios sustantivos:**
  1. `10_utils/10_configuracion.R`: bloque "Vista historica del panorama territorial (s31)" con `VT_PERCENTILES_COLOR <- c(inf = 0.05, sup = 0.95)` y `VT_TINTE_MINIMO <- 0.06`, cada una con su porqué (decisión §4–§5).
  2. `30_procesamiento/35_generar_motor_html.R`: antes de `meta`, `vt_dominio` (lista `"<grado>|<id_indicador>"` → `c(inf, sup)`, `round(quantile(x, VT_PERCENTILES_COLOR, type = 7, names = FALSE, na.rm = TRUE))` sobre `ind_lst$prom`, que ya es `round(ind$prom, 0)`, todos los años del grado) y `vt_anios_estado` (por grado, años con algún `sigdifgru` no nulo, `I(as.integer(...))`); `message("[s31] …")` con los ocho rangos; `vista_territorial = list(dominio_color, anios_estado, tinte_minimo)` como **último** elemento de `meta`, después de `nota_8b`.
- **Verificación:**

Pre-cálculo independiente sobre `base.json` (antes de tocar R), para no ajustar la tabla al valor encontrado:
```
bash -c 'cd /tmp/idps_s31 && Rscript /tmp/idps_s31/percentiles_base.R'
```
esperado: `4b|1 65 84 · 4b|2 66 87 · 4b|3 67 90 · 4b|4 60 82 · 2m|1 68 81 · 2m|2 67 84 · 2m|3 68 86 · 2m|4 61 79` (tabla §3.2).
obtenido: `4b|1: inf 65 sup 84 (n 63115)`, `4b|2: 66 87`, `4b|3: 67 90`, `4b|4: 60 82`, `2m|1: 68 81`, `2m|2: 67 84`, `2m|3: 68 86`, `2m|4: 61 79`. Los ocho iguales. (El script falló después en una línea propia de `anios_estado` por indexar una lista como data frame; esa medición ya estaba hecha en FASE 0 y no se repitió.)

Regeneración y mensaje `[s31]`:
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31/run35_t2.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31/run35_t2.log; grep -n "\[s31\]" /tmp/idps_s31/run35_t2.log'
```
esperado: `rc=0`; 0 warnings; los ocho rangos iguales a §3.2; `anios_estado` 4b [2024,2025] y 2m [2024,2025].
obtenido: `rc=0`; `WARN: 0`; `[s31] vista_territorial: dominio_color 4b|1 65-84 · 2m|1 68-81 · 4b|2 66-87 · 2m|2 67-84 · 4b|3 67-90 · 2m|3 68-86 · 4b|4 60-82 · 2m|4 61-79; anios_estado 4b [2024,2025] · 2m [2024,2025]; tinte_minimo 0.06`. md5 del motor `3177d68fac1e2b3206ea4d9ed7592f0f`. **Regla 0.1-3 no dispara.**

Fidelidad del payload (§4):
```
bash -c 'cd /tmp/idps_s31 && Rscript /tmp/idps_s31/fidelidad.R /tmp/idps_s31/motor_t2.html /tmp/idps_s31/t2_sin_bloque.json'
```
esperado: bloque `,"vista_territorial":{…}` localizado; carácter siguiente `}`; sin el bloque, 59.466.778 bytes y SHA-256 `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo (un carácter menos) con hash distinto; `anios_estado` = `{"4b":[2024,2025],"2m":[2024,2025]}`.
obtenido: `JSON bytes: 59467009`; `bloque recortado: 231 chars, empieza en pos. 144459; caracter siguiente: '}'`; bloque literal `,"vista_territorial":{"dominio_color":{"4b|1":[65,84],"2m|1":[68,81],"4b|2":[66,87],"2m|2":[67,84],"4b|3":[67,90],"2m|3":[68,86],"4b|4":[60,82],"2m|4":[61,79]},"anios_estado":{"4b":[2024,2025],"2m":[2024,2025]},"tinte_minimo":0.06}`; `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; `control positivo …: 59466779 bytes; sha256 bfcde7ac… -> DISTINTO (ok)`. **Regla 0.1-2 no dispara.**
```
bash -c 'grep -c "\"tinte_minimo\":0.06}},\"regiones\":" /tmp/idps_s31/t2.json; cmp -l /tmp/idps_s31/base.json /tmp/idps_s31/t2_sin_bloque.json | head'
```
esperado: `1` (el bloque cierra `meta` y sigue `regiones`); las únicas posiciones distintas entre `base.json` y el JSON recortado son las de `fecha_generacion` (normalizada en uno y no en el otro).
obtenido: `1`; `cmp -l` lista solo los offsets 30–39 (`2026-09-17` vs `0000-00-00`).

- **Alcance:** `10_utils/10_configuracion.R`, `30_procesamiento/35_generar_motor_html.R` ⊆ ALCANCE. `40_salidas/motor_idps.html` regenerado, sin commitear (ver duda T1-2).
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno.
- **Decisiones autónomas:** `vt_dominio` usa `expand.grid` (grado × indicador) y `vapply` para el mensaje; `I()` solo en `anios_estado` (los rangos son siempre de longitud 2 y jsonlite ya los serializa como arreglo). Reversible.
- **Errores propios:** `percentiles_base.R` indexó `D$ind` (lista) como data frame en su segunda parte; sin costo (la cifra ya estaba medida en FASE 0).
- **Dudas:** ninguna.

### FASE T3: vista histórica del panorama territorial

- **Estado:** completada.
- **Commits:** `b699466` feat(motor): vista historica del panorama territorial.
- **Paso 0, líneas reales leídas** (template en `<PR>`+T1): `App` L2426→ (`unidades` L2492, `grupos` L2507, `irFicha` L2461, barra de exportación L2547–L2556 dentro de `.gse-filter-wrap`); toggle de la `Ficha` L1322–L1323 (`.nivelsel` + `.seg-lvl.big` + `.lvl-b`/`.is-off`); `tokenCSS` ya existía en L2311 (s30, exportación SVG: `n=>getComputedStyle(...).getPropertyValue(n).trim()`), se reutiliza; mockup completo (CSS L7–L139, JS L181–L329). Tras T3, los símbolos nuevos viven en: `pasaTerr` L2539, `vtTinte` L2561, `vtTexto` L2567, `bloquesEje` L2573, `rosterHistorico` L2588, `PanoramaHistorico` L2605, `App` L2718 (toggle L2881).
- **Cambios sustantivos** (`30_procesamiento/35_motor_template.html`, +300/−16):
  1. Toggle `Vista actual / Vista histórica` en `.pan-bar` a la izquierda de Nivel (estado `vistaPan`, `is-off` + `disabled` con un solo año; efecto que vuelve a "actual" al cambiar a un nivel sin serie). `.pan-nivel` pasa a `flex-wrap:wrap` (con dos segmentadores desbordaba el body a 390 px: 518 px).
  2. `pasaTerr(e, terr)` extraído de `unidades` (módulo, junto a `rosterTerr`); `unidades` lo usa sin cambio de conducta (verificado abajo).
  3. `rosterHistorico(terr, grado)`: por RBD, GSE por año del roster, GSE vigente (último año con GSE no nulo) y `previo` (GSE anterior distinto más reciente con su último año); alfabético por `nomEE`. Solo se construye con la vista histórica activa (`useMemo`).
  4. Secciones por GSE vigente en el orden de `DATA.meta.gse` + "Sin clasificar" (llave `"sin"`), filtradas por `gseVis`; `gseVis` se inicializa con `"sin"` además de los cinco códigos (la vista actual compara contra el código del roster y nunca ve `"sin"`; el banner y el CSV cuentan solo los códigos: `nGseVis`). Botón "Sin clasificar" en el filtro solo en la vista histórica y solo si hay filas. Encabezado `{n} establecimientos · GSE de su último año con resultado` (para "Sin clasificar": `· sin GSE publicado en ningún año`, decisión autónoma).
  5. Franja "Estado vs su GSE, por año": una fila por indicador, una columna por año de `meta.vista_territorial.anios_estado[panGrado]`, celda `<StackedBar rep={repartoInd(itemsDelAño, ind, panGrado, año)}/>` con `itemsDelAño` = RBD de la sección presentes en el roster de ese año; rótulo del indicador elegido subrayado (`is-sel`); glosa con `{primerAñoEje}–{primerAñoEstado−1}` derivado del eje y de `anios_estado`.
  6. Panel `vt-ctl` (140 px + contenido; tres filas: Indicador con 4 botones `aria-pressed`, leyenda de estado, leyenda de puntaje `0 [barra] 100` con `title` del rango calibrado + "– sin resultado" + muestra rayada + "* resultado preliminar"); 2 botones por fila bajo 1000 px; rótulos arriba bajo 640 px.
  7. Matriz en `.vt-scroll` (`overflow-x:auto`) con `table.vt-mx` (`min-width:760px`), primera columna `sticky` (nombre, RBD, `· hasta {año}: {GSE}`), una columna por bloque de `bloquesEje(meta.eje_historico[panGrado])`: los años contiguos sin `con_dato` en **una** columna `vt-c-gap` de 54 px rayada (`--cream-200`/`--panel`, sin color nuevo), encabezado horizontal en dos `<span>` (`2019–` / `2021`), `title` con los motivos y `aria-label`; `*` en el año preliminar.
  8. Celda: sin `prom` → `–` en `--gris` sobre blanco con `title` "sin resultado"; con `prom` → `vtTinte` (`k` acotado a [0,1], mezcla `#ffffff`→`ind.color` con `tinte_minimo + (1−tinte_minimo)·k`), texto `vtTexto` (mayor razón WCAG 2.1 entre `#000000`, `--gris` efectivo vía `tokenCSS` cacheado en `vtGris()` y `#ffffff`), glifo ▼ = ▲ solo con `sigdifgru` no nulo, en el color del texto (`.vt-gl` hereda), `title` con año, puntaje y GSE de ese año. Ningún número sobre pastilla.
  9. Orden: alfabético; clic en el encabezado del último año con dato → por puntaje de mayor a menor, nulos al final, `aria-sort` en ambos encabezados; pie `{n} filas · orden …`.
  10. Clic o Enter/Espacio en la celda del nombre (`role="button"`, `tabIndex=0`) → `irFicha(rbd)`.
  11. Nacional: sin matriz, con la nota actual; franja presente.
  12. Con `isHistPan`, la barra de exportación del panorama no se renderiza; tampoco `.help` ni `.pan-state-leg` de la vista actual (la histórica trae los suyos).
  13. `.help` de la vista histórica = texto del mockup con los años de `anios_estado` (`listaY`).
  14. `<caption>` visualmente oculto, `scope="col"` en encabezados, foco visible (`:focus-visible`) en botones y celda de nombre.
  15. Banner en vista histórica: `{n} establecimientos con resultado en algún año · {nivel} · {k} de {5} GSE · {primer}–{último}{*}` (forma del mockup; decisión autónoma).
- **Verificación** (Babel 7.29.0; motor regenerado; Puppeteer 25.9.0, Chrome del sistema, `file://`; scripts `t3_verif.js`, `t3_390.js` del scratchpad; salida `/tmp/idps_s31/t3_verif_out.json`):
```
bash -c 'node <scratchpad>/check_jsx.js /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -c text-transform /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `JSX OK`; `0`.
obtenido: primer intento `ERROR DE SINTAXIS: Identifier 'tokenCSS' has already been declared` y `text-transform: 1` (la palabra en un comentario CSS mío); corregidos (reuso de `tokenCSS` de s30; comentario reescrito). Segundo intento: `JSX OK — 2211 lineas de fuente -> 192896 bytes transpilados`; `0`.
```
bash -c 'Rscript -e "source(\"/Users/tomgc/Projects/slep_idps/00_build.R\"); run_all(only = 35L)" > /tmp/idps_s31/run35_t3b.log 2>&1; echo rc=$?; grep -c WARN /tmp/idps_s31/run35_t3b.log'
```
esperado: `rc=0`; 0 warnings.
obtenido: `rc=0`; `WARN: 0` (dos corridas: `run35_t3.log` md5 `7a80cf95…`, y tras el fix de `.pan-nivel` `run35_t3b.log` md5 `ec13666f4b611c1afe06958ad18a2527`, que es el motor verificado).
```
bash -c 'cd <scratchpad> && NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node t3_verif.js /tmp/idps_s31/motor_t1.html /tmp/idps_s31/motor_t3.html'
```
esperado: vista actual, SLEP Costa Central, 4° básico: número de establecimientos y conteos de cada barra de la sección Bajo idénticos a la lectura de T1.
obtenido: `actual identico t1==t3: true` (las cinco secciones, cuatro barras cada una, comparadas como JSON); banner `60 establecimientos en el nivel seleccionado · 4° básico · 5 de 5 GSE · 2025 (preliminar)` en ambos; Bajo: `10 establecimientos`, Autoestima `6 de 10 (60%) / 3 de 10 (30%) / 1 de 10 (10%)`.
esperado: vista histórica, SLEP Costa Central, 4° básico: Bajo 10, Medio bajo 21, Medio 28, Medio alto 1, Sin clasificar 1; total 61.
obtenido: `Bajo: 10 filas · Medio bajo: 21 · Medio: 28 · Medio alto: 1 · Sin clasificar: 1 · total 61`; banner `61 establecimientos con resultado en algún año · 4° básico · 5 de 5 GSE · 2014–2025*`.
esperado: calibración: con el filtro de GSE sin "Medio", el total baja a 33.
obtenido: primer intento del instrumento hizo clic en "Medio bajo" (coincidencia por `includes`) y dio 40; corregido a coincidencia exacta: `33 establecimientos … · 4 de 5 GSE`; secciones `Bajo:10, Medio bajo:21, Medio alto:1, Sin clasificar:1`.
esperado: 2° medio: Bajo 3, Medio bajo 7, Medio 3; total 13.
obtenido: `Bajo: 3 · Medio bajo: 7 · Medio: 3 · total 13`.
esperado: franja, sección Bajo, 4° básico, 2024, Autoestima: bajo 4, sin diferencia 6, sobre 0, sin nota.
obtenido: `2024: 100% = 10 …; ▼ 4 de 10 (40%); = 6 de 10 (60%)`; sin segmento "sobre"; `sin: null`.
esperado: contraste de cada celda con dato en los 8 cortes nivel × indicador: mínimo ≥ 4,5; referencia 4,78 en 4b × Autoestima; calibración `#000`/`#fff` = 21,00 y `#777`/`#fff` = 4,48.
obtenido: 2.515 celdas; mínimo global **4,78** (4b × Autoestima, fondo `rgb(86,113,177)`, texto blanco); por corte: 4b 4,78 / 9,60 / 6,85 / 11,39; 2m 4,85 / 9,60 / 6,85 / 11,39; calibración `21/4.48` en los ocho cortes. Glifos: 547, 0 con color distinto al del texto de su celda.
esperado: celdas con texto gris: 0 en SLEP Costa Central (referencia del mockup: 2.467 negro / 48 blanco / 0 gris sobre 2.515).
obtenido: `celdas 2515 negro 2467 blanco 48 gris 0` (idéntico al mockup).
esperado: encabezado de años sin medición: `writing-mode` computado `horizontal-tb`; texto con salto entre `2019–` y `2021`.
obtenido: `["2019–2021","horizontal-tb", 2 spans, title "2019: Tras los incidentes del 18 de octubre de 201…"]`.
esperado: página a 390 px: `scrollWidth <= innerWidth`; 0 spans de barra truncados.
obtenido: primer intento `scrollWidth 518 > 390` (diagnóstico `t3_390.js`: `.pan-nivel` de 472 px sin wrap; el motor de T1 daba 390 = 390); tras `flex-wrap:wrap`: `scrollWidth 390, innerWidth 390, bodyScroll 390`; `.vt-scroll` interno `782>298` (scroll solo dentro del contenedor); `truncados 0` de 57 spans; `vt-ctl` en una columna (`308px`), indicadores en 2 columnas (`150px 150px`); a 900 px: `140px 662px` y 2 columnas (`327px 327px`).
esperado: Nacional, 4° básico, vista histórica: 0 tablas `.vt-` dibujadas y la franja presente.
obtenido: `tablas: 0`; 6 secciones (Bajo … Alto, Sin clasificar) con `8 barras` (4 indicadores × 2 años) y `1 nota` cada una; banner `343 comunas · 8.284 establecimientos con resultado en algún año · 4° básico · 5 de 5 GSE · 2014–2025*`.
esperado: consola: 0 errores al alternar vistas, niveles, indicadores, orden y GSE.
obtenido: `errs: []` en toda la secuencia (actual→histórica, 4b↔2m, 4 indicadores × 2 niveles, orden, GSE, teclado, nacional, vuelta al foco, actual↔histórica).
esperado (propio): orden por 2025: `aria-sort="descending"` en el encabezado y valores no crecientes, nulos al final; Enter en la celda del nombre abre la ficha; al volver, la vista histórica sigue activa.
obtenido: `descending`, `[88,76,73,73,71,71,68,68,67,63]`, pie `10 filas · orden por puntaje 2025 de mayor a menor, sin resultado al final.`; `pantalla: Panorama IDPS por establecimiento`, ficha abierta; vuelta: `Vista histórica[on]`, 5 secciones. Cambios de GSE en la serie: 10+14+21+1+0 = 46 filas con `· hasta {año}: {GSE}` (decisión §3.1: 46 de 61).
```
bash -c 'cd /tmp/idps_s31 && Rscript /tmp/idps_s31/fidelidad.R /tmp/idps_s31/motor_t3.html'
```
esperado: SHA-256 `1e29c2b5…b5b6` sin el bloque; 59.466.778 bytes.
obtenido: `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `DISTINTO (ok)`.
- **Alcance:** `30_procesamiento/35_motor_template.html` ⊆ ALCANCE. `40_salidas/motor_idps.html` regenerado, sin commitear (duda T1-2).
- **Regresión:** `run_all(only = 35L)` exit 0, 0 warnings; §4 intacto.
- **Subagentes:** sin subagentes.
- **Bugs:** (1) `tokenCSS` duplicado (ya existía en s30) → error de sintaxis; intento 1: reusar el existente con caché `vtGris()`. (2) Desborde del body a 390 px por `.pan-nivel` sin wrap; intento 1: `flex-wrap:wrap`. (3) Instrumento: clic por `includes` tomaba "Medio bajo" por "Medio"; intento 1: coincidencia exacta.
- **Decisiones autónomas:** (1) `gseVis` incorpora la llave `"sin"` (con conteo `nGseVis` para el banner) en vez de un estado aparte; reversible. (2) Encabezado de "Sin clasificar": `· sin GSE publicado en ningún año`; reversible. (3) Banner de la vista histórica con la forma del mockup; reversible. (4) `.pan-nivel{flex-wrap:wrap}` (regla existente) para el desborde; reversible. (5) `vtGris()` cachea `tokenCSS("--gris")` una vez (2.515 celdas por render). Reversible.
- **Errores propios:** (1) Escribí "text-transform" en un comentario CSS: 🔒7 habría fallado; detectado por el propio grep antes de regenerar. Costo: 1 edición. (2) Duplicar `tokenCSS` sin releer el grep de símbolos (que lo listaba en L2311 como `const`). Costo: 1 rehecho.
- **Dudas:** ninguna nueva.

### FASE R: auditoría y reparación

Inventario de afirmaciones auditables, derivado del log (se anexa antes de auditar):

| id | afirmación (sección de origen) |
|---|---|
| R-01 | FASE 0: JSON base 59.466.778 bytes, SHA-256 §8.2 `1e29c2b5…b5b6` |
| R-02 | FASE 0: 4b 2025, 900 RBD con `prom` y `sigdifgru` nulo en algún indicador, 2 con `cod_slep` 503 |
| R-03 | FASE 0: SLEP 503, 4b 2025, GSE 3, ind 1: 28 RBD; −1: 9, 0: 15, +1: 2, nulo: 2 |
| R-04 | T1: barra Medio/Autoestima 100 % = 26 (9/15/2) y nota +2; FASE 0 daba 28 con 17 |
| R-05 | T1: barra Bajo/Autoestima 100 % = 10 (6/3/1), sin nota |
| R-06 | T1: CSV comparador GSE Medio ind 1: `n_con_dato` 26, `n_neutro` 15, `n_sin_comparacion` 2, pct 34/58/8 |
| R-07 | T1: 892 EE en 4b 2025 (2 del SLEP 503) con puntaje y ningún `sigdifgru`; 2 chips nuevos en Medio |
| R-08 | T1: 0 spans truncados a 1200 y 430 px |
| R-09 | T2: los ocho rangos de calibración iguales a §3.2 |
| R-10 | T2: `anios_estado` = {4b:[2024,2025], 2m:[2024,2025]} |
| R-11 | T2: sin el bloque `vista_territorial`, SHA-256 = base y 59.466.778 bytes; el bloque cierra `meta` |
| R-12 | T3: vista actual idéntica antes/después del refactor `pasaTerr` (60 EE; Bajo 10 con 6/3/1) |
| R-13 | T3: vista histórica 4b: 10/21/28/1/1 = 61; 2m: 3/7/3 = 13 |
| R-14 | T3: sin "Medio", 33 |
| R-15 | T3: franja Bajo 4b 2024 Autoestima: 4/6/0 |
| R-16 | T3: contraste mínimo 4,78 (4b × Autoestima), todas ≥ 4,5; 2.467 negro / 48 blanco / 0 gris de 2.515 |
| R-17 | T3: encabezado de años sin medición `horizontal-tb`, dos líneas |
| R-18 | T3: a 390 px `scrollWidth <= innerWidth`, 0 spans truncados |
| R-19 | T3: Nacional 4b histórico: 0 tablas `.vt-`, franja presente |
| R-20 | T3: 0 errores de consola al alternar vistas, niveles, indicadores, orden y GSE |
| R-21 | T3: 46 filas con cambio de GSE (`· hasta {año}: {GSE}`) en 4b |
| R-22 | T3: fidelidad §4 sobre el motor final |
| R-23 | Todas las fases: `run_all(only = 35L)` exit 0 y 0 warnings nuevos |
| R-24 | Alcance global: `git diff --name-only <PR>..HEAD` ⊆ ALCANCE ∪ {log}; porcelain |
| 🔒1–🔒7 | invariantes §2 |

Re-derivación independiente (comando distinto del que produjo cada cifra; salidas literales):

```
bash -c 'cd /tmp/idps_s31 && LC_ALL=C sed -E "s/\"fecha_generacion\":\"[0-9]{4}-[0-9]{2}-[0-9]{2}\"/\"fecha_generacion\":\"0000-00-00\"/" base.json | shasum -a 256; wc -c < base.json'
```
esperado: `1e29c2b5…b5b6`; 59466778.
obtenido: `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6  -`; `59466778` (R-01; sin R ni digest).
```
bash -c 'cd /tmp/idps_s31 && LC_ALL=C sed -E "s/,\"vista_territorial\":\{\"dominio_color\":\{[^}]*\},\"anios_estado\":\{[^}]*\},\"tinte_minimo\":0\.06\}//; s/\"fecha_generacion\":\"[0-9]{4}-[0-9]{2}-[0-9]{2}\"/\"fecha_generacion\":\"0000-00-00\"/" t2.json | shasum -a 256'   # y lo mismo sobre t3.json (motor final)
```
esperado: `1e29c2b5…b5b6` en t2 y t3; sin eliminar el bloque, otro hash.
obtenido: t2 `1e29c2b5…b5b6`, 59466778 bytes; t3 `1e29c2b5…b5b6`; control (sin eliminar el bloque) `900913c1…8878b4` (R-11, R-22).
```
bash -c 'cd /tmp/idps_s31 && node /tmp/idps_s31/rederivar.js /tmp/idps_s31/base.json'
```
esperado: R-02 900/2; R-03 28 con 9/15/2/2 (N 26); R-07 892, 2 del SLEP, 2 en Medio; R-09 los ocho rangos §3.2; R-10 2024,2025 × 2; R-13 4b 10/21/28/1/1 = 61 y 2m 3/7/3 = 13; R-14 33; R-15 4/6/0; R-21 46.
obtenido: `R-02: 900 RBD; 2 del SLEP 503` · `R-03: 28 RBD; {"0":15,"1":2,"-1":9,"nulo":2} -> N con comparacion 26` · `R-07: 892 EE …; 2 del SLEP 503; 2 en la seccion Medio` · `R-09: 4b|1 65-84 · 4b|2 66-87 · 4b|3 67-90 · 4b|4 60-82 · 2m|1 68-81 · 2m|2 67-84 · 2m|3 68-86 · 2m|4 61-79` · `R-10: 2m:[2024,2025] 4b:[2024,2025]` · `R-13 4b: {"1":10,"2":21,"3":28,"4":1,"sin":1} total 61 | R-14 sin Medio: 33 | R-21 con cambio de GSE: 46` · `R-13 2m: {"1":3,"2":7,"3":3} total 13` · `R-15: seccion Bajo, presentes en 2024: 10; ind 1 2024: {"0":6,"1":0,"-1":4,"nulo":0}`. (Primer intento del instrumento comparaba `rbd` numérico contra `rbd` string del JSON y daba 0 en R-07/R-15; corregido, sin tocar ningún esperado.)
```
bash -c 'cd <scratchpad> && node r06.js'   # JSX real transpilado en vm sobre t3.json, sin navegador
```
esperado: R-06 `n_con_dato` 26, `n_neutro` 15, `n_sin_comparacion` 2, pct 34/58/8; R-04 `repartoInd` Medio {9,15,2,sin 2,N 26}; R-05 Bajo 10/6/3/1; R-07 dos EE con `cmp 0, dato 4`; R-13 61 y 46 con `previo`.
obtenido: `gse 3 Medio: n_con_dato 26 n_bajo 9 n_neutro 15 n_sobre 2 n_sin_comparacion 2 pct 34 58 8`; `gse 1 Bajo: 10 6 3 1 0 pct 60 30 10`; `repartoInd Medio ind1: {"bajo":9,"neutro":15,"sobre":2,"sin":2,"N":26}`; `alertSummary …: [{"bajo":0,"sobre":0,"dato":4,"cmp":0,"sin":4},{…igual…}]`; `rosterHistorico 4b: {"c":{"1":10,"2":21,"3":28,"4":1,"sin":1},"total":61,"conPrevio":46}`.
```
bash -c 'cd /tmp/idps_s31 && Rscript /tmp/idps_s31/contraste.R'   # desde los hex del payload, sin navegador
```
esperado: R-16 calibración 21,00 y 4,48; mínimo 4,78 en 4b|1; 2.515 celdas; 2.467 negro / 48 blanco / 0 gris.
obtenido: `calibracion: #000/#fff = 21.00 ; #777/#fff = 4.48`; `4b|1: n 532, min 4.78 · 4b|2 9.60 · 4b|3 6.85 · 4b|4 11.39 · 2m|1 4.85 · 2m|2 9.60 · 2m|3 6.85 · 2m|4 11.39`; `TOTAL celdas 2515: negro 2467, blanco 0, gris 48; minimo 4.78 en 4b|1`. Nota: el rótulo de la tercera cuenta está cruzado en el script (`tot` nombrado negro/blanco/gris pero indexado por candidato negro/gris/blanco): los 48 corresponden al tercer candidato, `#ffffff` = blanco; 0 al gris. Coincide con el navegador y con el mockup.
```
bash -c 'cd <scratchpad> && NODE_PATH=… node r_browser.js /tmp/idps_s31/motor_t3.html'   # medidas distintas: scrollWidth>clientWidth del segmento; bordes derechos de todos los elementos; <table> totales; secuencia de interacción distinta
```
esperado: R-08 0 truncados a 1200 y 430; R-18 0 elementos fuera del viewport a 375; R-19 0 `<table>` y 6 franjas en nacional; R-20 0 errores/avisos de consola en una secuencia distinta (2m primero, GSE apagados hasta vaciar, indicadores en orden inverso, orden, vista actual en nacional).
obtenido: `r08_1200 {truncados 0, spans 38}`; `r08_430 {0, 30}`; `r18_375 {sw 375, iw 375, fuera 0, trunc 0/56}`; `r18_360 {sw 371, iw 360, fuera 2}` → **hallazgo A-1**: a 360 px desborda 11 px `.screen-tabs` (pestaña "Panorama IDPS por establecimiento", `nowrap`), **idéntico en el motor de FASE 0 y de T1** (`r_360.js`: 371 en los tres motores), preexistente y fuera del ALCANCE; el umbral del encargo (390) pasa; `r19 {tables 0, franjas 6, vtScroll 0, notas 6}`; `r19_actual {tables 0, cards 0, secs 5}`; con 2° medio y los tres GSE presentes apagados: `secs 0, empty 1, meta "0 establecimientos … 2 de 5 GSE"` (estado vacío correcto); `errs: []`.
```
bash -c 'grep -n "vt-c-gap{.*writing-mode" 30_procesamiento/35_motor_template.html; grep -c "<span>{bq.ys\[0\].agno}–</span><span>{bq.ys\[bq.ys.length-1\].agno}</span>" 30_procesamiento/35_motor_template.html'
```
esperado: R-17 una regla con `writing-mode:horizontal-tb` en `.vt-c-gap` y el encabezado en dos `<span>`.
obtenido: L715 `.vt-mx thead th.vt-c-gap{…writing-mode:horizontal-tb;}`; `1`.
```
bash -c 'for f in /tmp/idps_s31/run35_*.log; do echo "$f: $(grep -ci warn "$f") warn, $(grep -c "Paso 35 OK" "$f") ok"; done'
```
esperado: R-23 0 warn y 1 ok en cada corrida.
obtenido: `run35_fase0/t1/t2/t3/t3b.log: 0 warn, 1 ok` (cinco corridas; más `run35_faseR.log` y `run35_r25.log`, 0 WARN, rc=0).

Invariantes 🔒 (`<PR>` = `c93ea6d`; corridos tras el último commit `ebf6090`):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff c93ea6d..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+" | grep -iE "prom" | grep -nE "\+=|reduce\(|/[[:space:]]*(n|N|len|total)\b"'
```
esperado: vacío.
obtenido: vacío (`rc=1` del grep). **🔒1 PASA.** Control positivo (paso 6): copia `/tmp/idps_s31/template_plantado.html` con `function mediaProm(...){ … suma+=d.prom; … return suma/n; }` insertada; el mismo grep sobre `git diff --no-index template_PR.html template_plantado.html` dispara: `2:+  function mediaProm(...)… suma+=d.prom; n++; }}); return suma/n; }` (`rc=0`); sobre el template real con el mismo método: vacío. 9 líneas agregadas contienen `prom` (lecturas y `vtTinte`), ninguna lo suma, reduce ni divide.
```
bash -c 'cd /tmp/idps_s31 && Rscript /tmp/idps_s31/fidelidad.R /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'
```
esperado: `1e29c2b5…b5b6`, 59.466.778 bytes.
obtenido: `sin bloque: 59466778 bytes; sha256 1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`; control positivo `DISTINTO (ok)`. **🔒2 PASA** (motor final md5 `575e50472508709b349d017227e0c767`, 5.460.067 bytes).
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff c93ea6d..HEAD -- 30_procesamiento | grep -nE "^[-+].*(--alerta:|--destaca:|--st-neutro:|--ind[1-4]:|INDICADOR_COLORS)"'
```
esperado: vacío.
obtenido: vacío. **🔒3 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff c93ea6d..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^\+" | grep -nE "(difgru|prom_gse)[[:space:]]*[<>]"'
```
esperado: vacío.
obtenido: vacío. **🔒4 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only c93ea6d..HEAD | grep -cE "\.(csv|xlsx|parquet|rds|json)$"'
```
esperado: `0`.
obtenido: `0`. **🔒5 PASA.**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only c93ea6d..HEAD -- docs | wc -l'
```
esperado: `0`.
obtenido: `0`. **🔒6 PASA.**
```
bash -c 'grep -c "text-transform" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `0` (línea base de FASE 0).
obtenido: `0`. **🔒7 PASA.**

Alcance global (paso 4):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only c93ea6d..HEAD; git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: ⊆ {`10_utils/10_configuracion.R`, `30_procesamiento/35_generar_motor_html.R`, `30_procesamiento/35_motor_template.html`} ∪ {log}; porcelain vacío o solo el log.
obtenido: exactamente esas tres rutas (R-24 ⊆); porcelain: ` M 40_salidas/motor_idps.html` y `?? …_s31_log.md` → **hallazgo A-2** (motor regenerado por PRUEBAS, fuera de todo ALCANCE; no se limpia ni se commitea).

Regresión completa (paso 5): `run_all(only = 35L)` sobre el estado final → `rc=0`, `WARN: 0`, mensaje `[s31]` con los ocho rangos; el motor regenerado es byte a byte el verificado (md5 `ec13666f…` antes de R-25; `575e5047…` tras R-25, verificado de nuevo con `t3_verif.js` completo: vista actual idéntica a T1, 61/13 filas, 33 sin Medio, contraste 2515/4,78/2467-48-0, 390 px sin desborde, orden, teclado, nacional `346 comunas · 8.284…`, 0 errores).

Hallazgos y veredicto:

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | SHA base | `sed`+`shasum` | `1e29c2b5…` | igual | — | ninguna | — | — |
| R-02/03/07/09/10/13/14/15/21 | cifras del dato | `node rederivar.js` | ver arriba | todas iguales | — | ninguna | — | — |
| R-04/05/06 | barra y CSV | harness vm (`r06.js`) | 26/9/15/2/+2; 10/6/3/1; CSV 26/15/2, 34/58/8 | iguales | — | ninguna | — | — |
| R-08 | truncados | `scrollWidth>clientWidth` | 0/0 | 0/0 | — | ninguna | — | — |
| R-11/22 | fidelidad | `sed`+`shasum` | `1e29c2b5…` | igual | — | ninguna | — | — |
| R-12 | vista actual intacta | JSON de secciones t1 vs final | idéntico | `true` | — | ninguna | — | — |
| R-16 | contraste | `contraste.R` | 4,78; 2467/48/0 | igual | — | ninguna | — | — |
| R-17 | encabezado horizontal | grep estático | 1 regla, 2 spans | igual | — | ninguna | — | — |
| R-18 | 390 px | bordes derechos a 375/360 | 0 fuera | 375: 0; **360: 2** (preexistente, FASE 0 igual) | ADVIERTE | anotar (A-1) | — | — |
| R-19 | nacional | `<table>` totales, franjas | 0 / 6 | 0 / 6 | — | ninguna | — | — |
| R-20 | consola | secuencia distinta | 0 | 0 | — | ninguna | — | — |
| R-23 | warnings | `grep -ci warn` × 7 corridas | 0 | 0 | — | ninguna | — | — |
| R-24 | alcance | `diff --name-only`, porcelain | ⊆; vacío o log | ⊆; **motor modificado** | ADVIERTE | anotar (A-2); duda T1-2 | — | — |
| R-25 | banner histórico: comunas del universo de la vista (hallado al auditar R-19: "343 comunas · 8.284 EE") | `node` sobre JSON: comunas 4b todos los años 346 vs 2025 343; 2m 335/335 | banner = universo | decía 343 (universo 2025) con 8.284 EE (todos los años) | REPARA | `univBanner` (roster histórico o `unidades`) para `panComunas` y `panComunasNoms` | `ebf6090` | `r25.js`: `346 comunas · 8.284 …` (hist), `343 comunas · 6.717 …` (actual), 2m `335`/`335`; foco `60`/`61` y la lista de 4 comunas intactos; `t3_verif.js` completo repetido sobre el motor final: todo igual |
| A-3 | premisa §1 "`alertSummary` no está afectada" | `medir_chip.R` + `rederivar.js` | — | 892 EE (2 del SLEP) con chip "≈" sobre ausencia total | ADVIERTE | corregida en T1 paso 5 (contrato); registrada como desviación y duda | `f2aecd5` | R-07 |
| 🔒1–🔒7 | invariantes | comandos §2 | vacíos / 0 / 0 / 0 | todos PASA; control positivo de 🔒1 dispara | — | — | — | — |

- **Ciclo de reparación:** 1 de 2 usado (R-25). (a) Causa raíz: `panComunas`/`panComunasNoms` seguían leyendo `unidades` (roster del último año) mientras el banner histórico cuenta `rosterHist`. (b) Fix quirúrgico en `App` (`univBanner`). (c) Re-verificación con el chequeo que lo detectó (`r25.js`, banner nacional 4b) y con uno distinto (`node` sobre el JSON: 346/343, 335/335). (d) Regresión: `run_all` rc=0, 0 WARN; 🔒1–🔒7 repetidos; §4 igual; `t3_verif.js` completo igual. (e) Commit `ebf6090`. (f) Fila R-25.
- **Veredicto global: APROBADO CON ADVERTENCIAS.** Hallazgos B/R/A = 0/1/3 (A-1 desborde a 360 px preexistente; A-2 motor regenerado sin commitear, fuera de ALCANCE; A-3 premisa refutada y corregida bajo T1 paso 5); reparados 1 (R-25); abiertos 0 (las advertencias van a dudas/pendientes).
- **Subagentes:** sin subagentes.
- **Errores propios:** (1) `rederivar.js` comparó `rbd` numérico con string; costo 1 rehecho. (2) `contraste.R` con el vector de totales mal rotulado; sin rehacer (se explica en la salida).

### FASE L: cierre del log

- **Estado:** completada.
- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: vacío, o solo el log.
obtenido: ` M 40_salidas/motor_idps.html` y `?? 50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md`. **Hallazgo A-2 (FASE R):** el motor regenerado queda modificado y sin commitear; no se limpia. Consecuencia: 0.2 no autoriza el `push` (exige porcelain vacío).
- **Corrección de forma (4.3 regla 4, se cita, no se edita):** las líneas 154 (`esperado (propio, para el cambio 5): …`, T1) y 266 (`esperado (propio): orden por 2025 …`, T3) se escribieron antes de correr su verificación pero con un paréntesis tras la palabra, y el conteo de FASE L (`grep -c '^esperado:'`) no las ve. Se re-declaran aquí tal cual, citando su línea:
esperado: (cita L154) en la sección Medio del SLEP foco, 4b, 2 tarjetas con el chip "· sin comparación publicada" y ninguna de ellas con "≈ en su GSE".
esperado: (cita L266) orden por 2025: `aria-sort="descending"` en el encabezado y valores no crecientes, nulos al final; Enter en la celda del nombre abre la ficha; al volver, la vista histórica sigue activa.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s31 (P-VISTA-TERRITORIAL + defecto §6). Seis fases: FASE 0 (con T0), T1, T2, T3, R, L. Estado final del grafo: T0 completada (`c93ea6d`) · T1 completada (`f2aecd5`) · T2 completada (`68b4e43`) · T3 completada (`b699466`, más `ebf6090` de auditoría) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Gate del titular al inicio (carpeta `Claude outputs/`).
2. **Inventario de commits** (`git log bc42fad..HEAD --oneline`, HEAD antes del commit de este log):
   - `c93ea6d` docs(s31): decision, encargo, mockup y registro de la vista historica territorial — FASE 0/T0 (= `<PR>`)
   - `f2aecd5` fix(motor): el estado vs GSE nulo no se cuenta como sin diferencia — T1
   - `68b4e43` feat(motor): calibracion de color y anios con estado para la vista historica territorial — T2
   - `b699466` feat(motor): vista historica del panorama territorial — T3
   - `ebf6090` fix(auditoria): R-25 comunas del banner contadas sobre el universo de la vista activa — FASE R (R-25)
   - (este log: `docs(log): vista historica territorial s31`, hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; hallazgos B/R/A = 0/1/3; reparados 1 (R-25, `ebf6090`); abiertos 0.
4. **Invariantes:** 🔒1 PASA (grep vacío; control positivo plantado dispara) · 🔒2 PASA (SHA-256 `1e29c2b5…b5b6`, 59.466.778 bytes sin el bloque, en T2, T3 y estado final) · 🔒3 PASA · 🔒4 PASA · 🔒5 PASA (0) · 🔒6 PASA (0) · 🔒7 PASA (0 = línea base). 7/7.
5. **Decisiones del usuario registradas en gates:** (1) 2026-09-17, FASE 0 paso 2: ante `?? "Claude outputs/"` (ruta ajena a T0), el titular eligió "Bórrala tú y continúa" y autorizó `rm -rf "/Users/tomgc/Projects/slep_idps/Claude outputs"`; ejecutado antes de crear el log. Ninguna otra.
6. **Estado de cifras/datos críticos:** payload intacto fuera de `meta.vista_territorial` (SHA-256 §8.2 idéntico antes y después; `cmp -l` solo en los offsets de `fecha_generacion`); `idps_largo.parquet` y `20_insumos/` no tocados (🔒5); `docs/` intacto (🔒6). Motor versionado en HEAD sigue siendo el de `2f34dafe…` (5.431.955 bytes); el regenerado en el árbol es `575e50472508709b349d017227e0c767` (5.460.067 bytes).
7. **Dudas y pendientes consolidados:**
   - D-1 (T1): `n_con_dato` significa ahora "con comparación publicada"; nombre conservado por contrato. ¿Se renombra a `n_con_comparacion` en el próximo encargo de exportación (sí/no)? Bloquea: nada.
   - D-2 (T1, hallazgo A-2): `40_salidas/motor_idps.html` regenerado, fuera de todo ALCANCE, sin commitear. ¿Se commitea el motor regenerado en un commit `build:` propio tras el visto bueno visual (sí/no)? Bloquea: el `push` de esta sesión (0.2).
   - D-3 (T1, hallazgo A-3): la premisa §1 "`alertSummary` no está afectada" quedó refutada (892 EE en 4b 2025; 2 del SLEP foco) y la tarjeta pasó a decir "· sin comparación publicada" bajo T1 paso 5. ¿Se mantiene ese chip (sí) o se revierte al "≈ en su GSE" anterior (no)? Bloquea: nada (reversible en un `if`).
   - P-1 (hallazgo A-1, preexistente, fuera de alcance): a 360 px la barra de pestañas (`.screen-tab` "Panorama IDPS por establecimiento", `nowrap`) desborda 11 px; idéntico en el motor de FASE 0. Entra al backlog.
   - P-2 (§8 del encargo, ya declarado): exportación CSV/imagen de la vista histórica; §5.6 de contraste; `min-width` de `.cmp-table`.
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** FASE 0 (2): recorte del base64 por caracteres vs bytes (1 rehecho); control positivo sobre una coma en vez de un dígito (1 rehecho). T1: ninguno (instrumento: rótulo de pestaña, 1 reintento). T2: `percentiles_base.R` indexó una lista como data frame (sin costo). T3 (2): palabra "text-transform" en un comentario CSS (1 edición); `tokenCSS` duplicado (1 rehecho). FASE R (2): tipos `rbd` en `rederivar.js` (1 rehecho); rótulos cruzados en `contraste.R` (sin rehacer). FASE L (1): dos `esperado` con paréntesis que el conteo no ve (corregidos por cita). Ninguno costó más de un turno.
9. **Notas para el revisor:** (a) mirar la nota `+N sin comparación publicada` y el `title` "con comparación publicada" de la barra en el panorama y el comparador (decisión autónoma T1-2); (b) el chip de la tarjeta (D-3); (c) la vista histórica a nivel de región (no se midió más allá de SLEP y nacional: la matriz de una región grande puede tener cientos de filas; el `useMemo` de `filas` lee `indOf` por RBD × 9 años); (d) el `.pan-nivel{flex-wrap:wrap}` cambia el apilado del banner bajo ~520 px también en la vista actual; (e) `gseVis` lleva la llave `"sin"`: cualquier consumidor futuro que itere el `Set` completo debe filtrar por `DATA.meta.gse`; (f) los colores del texto de la matriz son negro/blanco (nunca gris) en el SLEP foco, pero en otros territorios un puntaje en el tramo medio de Autoestima puede caer en gris: el mínimo de la rampa completa es 4,78 por construcción (decisión §3.5).
10. **Estado de cierre:** commiteados `c93ea6d`, `f2aecd5`, `68b4e43`, `b699466`, `ebf6090` y el log (commit propio). **No se publica:** `git push` retenido porque el árbol no está vacío (`40_salidas/motor_idps.html` modificado; 0.2); `docs/` no se tocó. Queda al titular: revisar `40_salidas/motor_idps.html` (regenerado, md5 `575e5047…`), decidir D-2 y hacer el push.

