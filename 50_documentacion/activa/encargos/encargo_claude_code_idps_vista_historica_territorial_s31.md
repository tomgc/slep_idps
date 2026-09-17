# Encargo autónomo a Claude Code: vista histórica del panorama territorial y corrección del estado nulo

> Proyecto: `slep_idps`. Encargo **s31**. Patrón: `herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md` (v1.6).
> Implementa P-VISTA-TERRITORIAL según la decisión
> `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`
> y corrige el defecto de su §6 (estado vs GSE nulo contado como "sin diferencia").
> **No despliega a `docs/`**: el despliegue espera el visto bueno visual del titular.

---

## 0. Encabezado de contrato

- **Modo y disciplina:** modo autónomo, todo en este turno, en serie. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. (Cadena que escribe en serie sobre el mismo template: fila 1 de la tabla 2.12.)
- **ENTORNO:** Claude Code en la estación macOS del titular, repositorio local `/Users/tomgc/Projects/slep_idps`. R con `renv` del proyecto.
- **INTÉRPRETE:** todo comando de shell corre con `bash -c '…'` explícito; todo cálculo sobre datos corre con `Rscript`. Ningún comando asume `cd` previo: las rutas son absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **INSUMOS** (rutas en ese entorno):
  1. `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`: la **especificación**. Si este encargo y la decisión discrepan, manda la decisión y la discrepancia se registra como duda.
  2. `50_documentacion/andamios/diseno/detalles/mockup_vista_historica_territorial.html`: **referencia visual vinculante**. Tiene los datos de SLEP Costa Central incrustados. Su JavaScript es un prototipo: se copia la **forma** (estructura, clases, reglas de color y de orden), no el código literal. En particular, su `DOMINIO` está escrito a mano y en el motor viaja en `meta`.
  3. `30_procesamiento/35_motor_template.html` y `30_procesamiento/35_generar_motor_html.R`.
  4. `10_utils/10_configuracion.R`.
  5. `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` §8.2: convención de normalización del payload.
  6. `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` y `20260622_decision_paleta_indicadores.md`.
  7. `CLAUDE.md` y `50_documentacion/activa/POLITICA_PROYECTO.md`.
- **POSICIÓN:** raíz `/Users/tomgc/Projects/slep_idps`; rama `main`. FASE 0 corre `git fetch` y compara `HEAD` con `origin/main` antes de operar.
- **LOG:** `50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md`
- **PRUEBAS:** sin arnés de pruebas: `tests/` está vacío (fuente: `ls tests` en la sesión de redacción). Lo sustituye `Rscript -e 'source("/Users/tomgc/Projects/slep_idps/00_build.R"); run_all(only = 35L)'`, que debe terminar con exit 0 y sin warnings nuevos respecto de la corrida de FASE 0, más la verificación de fidelidad del payload de §4.
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain` (vacío) y `git stash list` (vacío), y registra `git rev-parse --short HEAD` en el encabezado del log.
- **Reglas canónicas heredadas:** R como único lenguaje de código persistente del proyecto (el template HTML/JS es la excepción ya existente del motor); `|>`, `.by=`, `here::here()`; rutas absolutas en comandos; convenciones de `CLAUDE.md`; `git add` con rutas explícitas, nunca `-A` ni `.`.
- **Antes de empezar:** pide al titular que cierre el editor abierto sobre el repo (en s29i un `.git/index.lock` obsoleto bloqueó commits dos veces).

### 0.1 Regla de detención (condiciones medibles)

1. Si el SHA-256 del JSON de FASE 0, normalizado con la convención §8.2, no es `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6` → detente antes de tocar nada.
2. Si, después de T2, el JSON regenerado **sin** el bloque `"vista_territorial"` y normalizado con §8.2 no da ese mismo SHA-256 → congela T2 y sus descendientes (§4).
3. Si algún percentil calculado en T2 difiere de la tabla de §3.2 → congela T2 y sus descendientes. **No ajustes la tabla al valor encontrado.**
4. Si `run_all(only = 35L)` falla o emite un warning que no estaba en FASE 0 → congela la tarea en curso.
5. Si implementar algo exige **calcular una cifra agregada** (promedio, suma o tasa de puntajes de un territorio) → congela la tarea en curso: viola la invariante de cero agregación.
6. Si una verificación de §3 o §5 da un valor distinto del `esperado:` → congela la tarea en curso y registra la diferencia.
7. **Cualquier estado, conteo o resultado no enumerado en este encargo → congela ESTA tarea, regístrala como duda (4.1) y sigue con la próxima tarea independiente.**

### 0.2 Autorizaciones (lista cerrada)

- `git commit` de las rutas del ALCANCE de cada tarea, después de su verificación.
- `git push origin main`, solo en FASE L, solo si FASE R terminó en `APROBADO` o `APROBADO CON ADVERTENCIAS`, y solo si `git status --porcelain` está vacío en ese momento.
- `git revert <hash>` de un commit propio de esta sesión.
- Escribir en `/tmp/idps_s31/` los archivos de medición (JSON extraídos, capturas); nunca dentro del repositorio.

Nada más. En particular, **no** está autorizado: tocar `docs/`, `push --force`, `reset`, `restore`, `checkout --` ni borrar archivos del repositorio.

### 0.3 Topes de esfuerzo

1. **3 intentos por bug.** Al tercer fix fallido, la tarea se congela con la evidencia de los tres intentos.
2. **2 ciclos de reparación en FASE R.**
3. **1 reintento por comando** que falle por causa transitoria (red, lock, timeout). Al segundo fallo, se registra como hallazgo.

### 0.4 Grafo de tareas

```
T0 (registro de sesión)         independiente
T1 (estado nulo)                independiente
T2 (meta en R)                  independiente
T3 (vista histórica)            requiere T1 y T2
FASE R                          corre siempre, después de la última tarea (congeladas incluidas)
FASE L                          corre siempre, al final
```

---

## 1. Estado de partida (premisas marcadas)

- `HEAD` local = `origin/main` = `bc42fad`, con el árbol limpio salvo las cuatro rutas de T0 (hipótesis, se mide en FASE 0; fuente previa: eco de `/apertura` pegado por el titular el 2026-09-17).
- `40_salidas/motor_idps.html` pesa 5.431.955 bytes, tiene md5 `2f34dafe1309b67e5e1e1cfb3eea47a3` y su JSON descomprimido pesa 59.466.778 bytes con el SHA-256 §8.2 = `1e29c2b5…b5b6` (fuente: copia del motor medida en la sesión de redacción; en esta sesión, hipótesis que se mide en FASE 0).
- `repartoInd` está en `35_motor_template.html` ~L893 y cuenta como `neutro` todo `sigdifgru` distinto de ±1, incluido el nulo (fuente: lectura del template en la sesión de redacción, L896).
- `CeldaEE` está en ~L1687 y pinta "=" cuando `sigdifgru` es nulo (fuente: ídem, L1690).
- `estadoVsGse` está en ~L1949 y ya devuelve `CSV_SIN_CMP_GSE` cuando `sigdifgru` es nulo (fuente: ídem, L1948–L1952).
- `filasComparadorCSV` está en ~L2001 y usa `repartoInd` para las filas de territorio (fuente: ídem, L2003–L2020).
- `alertSummary` (L835) solo cuenta ±1 y no está afectada; el tooltip de `BarrasAnio` (L1149) está protegido por `difgru != null` (fuente: ídem). En el payload, toda fila de 2024–2025 con `sigdifgru` nulo tiene también `difgru` nulo (hipótesis, se mide en FASE 0).
- En 4° básico 2025 hay 900 establecimientos del país con puntaje y `sigdifgru` nulo en al menos un indicador, y 2 de ellos son de SLEP Costa Central (`cod_slep = 503`) (hipótesis, se mide en FASE 0).
- `sigdifgru` no nulo existe solo en 2024 y 2025, para 4b y para 2m (hipótesis, se mide en FASE 0).
- `meta` se arma en `35_generar_motor_html.R` ~L484 y su último elemento es `nota_8b` (fuente: lectura del script en la sesión de redacción).
- El panorama arma sus unidades en `App` con `unidades` (~L2493, filtro por territorio y dependencia) y sus secciones con `grupos` (fuente: lectura del template; hipótesis sobre la línea exacta, se mide en T3 paso 0).
- La ficha ya tiene un toggle "Vista actual / Vista histórica" (L1322–L1323) que sirve de patrón visual (fuente: ídem).
- `_txtOn` (L1021) elige el color del texto por luminancia con un umbral fijo. **No** se usa para la matriz, que usa la regla de contraste de la decisión §3.5 (fuente: ídem).
- `tests/` está vacío (fuente: `ls tests` en la sesión de redacción).

---

## 2. Invariantes 🔒 (cada uno con su comando; FASE R los corre todos)

`<PR>` es el hash del PUNTO DE RETORNO registrado en FASE 0. Todos los comandos corren con `bash -c` desde cualquier directorio.

- **🔒1 Cero agregación:** ninguna línea agregada al template suma, reduce o divide sobre `prom`.
  ```bash
  git -C /Users/tomgc/Projects/slep_idps diff <PR>..HEAD -- 30_procesamiento/35_motor_template.html | grep -E '^\+' | grep -iE 'prom' | grep -nE '\+=|reduce\(|/[[:space:]]*(n|N|len|total)\b'
  ```
  Esperado: salida vacía. Si hay una coincidencia legítima (la normalización de color `(prom-inf)/(sup-inf)` no debería coincidir; si coincide, es legítima), se lista con su razón y FASE R la juzga.
- **🔒2 Payload intacto fuera del bloque nuevo:** procedimiento de §4. Esperado: SHA-256 `1e29c2b5…b5b6`.
- **🔒3 Paletas intactas** (`--alerta`, `--destaca`, `--st-neutro`, `--ind1..4`, `INDICADOR_COLORS`):
  ```bash
  git -C /Users/tomgc/Projects/slep_idps diff <PR>..HEAD -- 30_procesamiento | grep -nE '^[-+].*(--alerta:|--destaca:|--st-neutro:|--ind[1-4]:|INDICADOR_COLORS)'
  ```
  Esperado: salida vacía.
- **🔒4 `sigdifgru` es la única fuente del estado:** ninguna línea agregada compara `difgru` ni `prom_gse`.
  ```bash
  git -C /Users/tomgc/Projects/slep_idps diff <PR>..HEAD -- 30_procesamiento/35_motor_template.html | grep -E '^\+' | grep -nE '(difgru|prom_gse)[[:space:]]*[<>]'
  ```
  Esperado: salida vacía.
- **🔒5 Sin datos versionados nuevos:**
  ```bash
  git -C /Users/tomgc/Projects/slep_idps diff --name-only <PR>..HEAD | grep -cE '\.(csv|xlsx|parquet|rds|json)$'
  ```
  Esperado: `0`.
- **🔒6 `docs/` intacto:**
  ```bash
  git -C /Users/tomgc/Projects/slep_idps diff --name-only <PR>..HEAD -- docs | wc -l
  ```
  Esperado: `0`.
- **🔒7 Sin mayúsculas sostenidas** (retiradas en s29):
  ```bash
  grep -c 'text-transform' /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html
  ```
  Esperado: el mismo valor medido en FASE 0.

---

## 3. Tareas

### FASE 0: log, punto de retorno y mediciones

1. Crea el log en `LOG:` con el encabezado de §4 del patrón v1.6, el slot vacío `## J. Juicio (lo rellena FASE L)` y el esqueleto de 4.1 y 4.2 (`mkdir -p` incluido).
2. `git fetch`; mide el estado de partida.
   - `esperado:` `git status --porcelain` muestra **solo** las cuatro rutas de T0 como no trackeadas (`??`); `git stash list` vacío; `git rev-parse --short HEAD` = `git rev-parse --short origin/main` = `bc42fad`.
   - Si hay cualquier otra ruta, detente. Si coincide, ejecuta **T0 ahora** y toma el PUNTO DE RETORNO después de su commit: `git status --porcelain` vacío y `git rev-parse --short HEAD` registrado como `<PR>`.
3. `run_all(only = 35L)` sin cambios, para fijar la línea base de warnings. Anota los warnings literales.
   - `esperado:` exit 0. El md5 del motor regenerado puede diferir de `2f34dafe…` solo por `fecha_generacion`; el paso 4 lo decide.
4. Extrae el JSON del motor regenerado (bloque `atob("…")`, base64 → gzip → UTF-8) con R (`jsonlite::base64_dec`, `memDecompress(type = "gzip")`), normaliza `"fecha_generacion":"AAAA-MM-DD"` → `"fecha_generacion":"0000-00-00"`, y calcula `digest::digest(…, algo = "sha256", serialize = FALSE)` sobre los bytes UTF-8 sin salto final. Guarda el JSON en `/tmp/idps_s31/base.json`.
   - `esperado:` 59.466.778 bytes; SHA-256 `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6`.
   - Calibración del instrumento: altera un dígito de una copia en memoria y comprueba que el hash cambia (control positivo); recalcula sobre la original y comprueba que vuelve (control negativo).
5. Mide con `Rscript` sobre `/tmp/idps_s31/base.json`:
   - `esperado:` años con `sigdifgru` no nulo = `2024, 2025` en 4b y `2024, 2025` en 2m.
   - `esperado:` en 4b 2025, 900 RBD distintos con `prom` no nulo y `sigdifgru` nulo en algún indicador, 2 de ellos con `cod_slep = "503"`.
   - `esperado:` en 2024–2025, 0 filas con `sigdifgru` nulo y `difgru` no nulo.
   - `esperado:` en SLEP 503, 4b 2025, GSE `"3"` (Medio), indicador 1: 28 RBD con `prom`; `sigdifgru` −1: 9, 0: 15, +1: 2, nulo: 2.
6. Mide la línea base de 🔒7 (`grep -c "text-transform"`).
7. Anexa la sección `### FASE 0` con cada `esperado:` y `obtenido:`.

### T0: registro de la sesión (commit `docs`)

- **ALCANCE:** `50_documentacion/andamios/logs/20260917_registro_asistente_s31.md`, `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`, `50_documentacion/activa/encargos/encargo_claude_code_idps_vista_historica_territorial_s31.md`, `50_documentacion/andamios/diseno/detalles/mockup_vista_historica_territorial.html`.
- Los cuatro archivos ya están en disco, entregados por el redactor, y ninguno está trackeado (hipótesis, se mide en FASE 0 paso 2).
- **Verificación:** `grep -c "^|" 50_documentacion/andamios/logs/20260917_registro_asistente_s31.md`.
  - `esperado:` ≥ 3 (encabezado, separador y al menos una fila).
- Commit: `docs(s31): decision, encargo, mockup y registro de la vista historica territorial`.
- **Momento:** T0 se ejecuta dentro de FASE 0 paso 2, antes de tomar el PUNTO DE RETORNO, porque sus archivos llegan sin commitear.

### T1: el estado nulo no se cuenta como "sin diferencia" (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Paso 0:** lee `repartoInd`, `StackedBar`, `EST_EE`, `CeldaEE`, `filasComparadorCSV`, `CSV_CMP_COLS` y `estadoVsGse`. Inventaría todas las lecturas de `sigdifgru` (`grep -n sigdifgru`) y clasifica cada una en el log como *afectada* o *no afectada*, con su razón.
- **Cambios** (decisión §6):
  1. `repartoInd` devuelve `{bajo, neutro, sobre, sin, N}`. `neutro` cuenta solo `sigdifgru === 0`, `sin` cuenta `prom != null && sigdifgru == null`, y `N = bajo + neutro + sobre`.
  2. `StackedBar`: el 100 % es `N`. Si `rep.sin > 0`, bajo la barra (y bajo la tira externa, si la hay) aparece la nota `+{sin} sin comparación publicada`, en `--gris` y `--fs-overline`, con `title` explicativo. El `aria-label` la incluye. Con `N === 0` y `sin > 0`, la barra dice "sin dato" y la nota se muestra igual.
  3. `CeldaEE`: con `prom` y `sigdifgru` nulo, muestra el puntaje con el glifo "·" y el texto "sin comparación publicada", en clase neutra de texto (`--st-neutro-txt`). No usa "=".
  4. `filasComparadorCSV` y `CSV_CMP_COLS`: nueva columna `n_sin_comparacion`, inmediatamente después de `n_sobre`. `n_con_dato` pasa a ser `N` (con comparación). Si el nombre de columna existente lo contradice, regístralo como duda y conserva el nombre.
  5. Cualquier otra lectura clasificada como *afectada* en el paso 0 se corrige con el mismo criterio y se lista en el log. Si no hay otras, se declara.
- **Verificación** (en navegador, con el método de medición de s29d–s29g; motor regenerado con `run_all(only = 35L)`):
  - Panorama, SLEP Costa Central, 4° básico, sección Medio, Autoestima.
    - `esperado:` la barra muestra 100 % = 26; bajo 9, sin diferencia 15, sobre 2; nota `+2 sin comparación publicada`.
    - Calibración: la misma lectura sobre el motor de FASE 0 (antes del fix) da 100 % = 28 con 17 sin diferencia; es el caso malo conocido, y el criterio debe distinguirlo.
  - Sección Bajo, mismo nivel e indicador.
    - `esperado:` 100 % = 10; bajo 6, sin diferencia 3, sobre 1; sin nota (caso bueno conocido).
  - CSV del comparador con SLEP Costa Central, 4° básico, GSE Medio, indicador 1.
    - `esperado:` `n_con_dato` 26, `n_neutro` 15, `n_sin_comparacion` 2, y los porcentajes idénticos a los de la barra.
  - Etiquetado de barra.
    - `esperado:` 0 spans truncados a 1200 px y a 430 px.
- Commit: `fix(motor): el estado vs GSE nulo no se cuenta como sin diferencia`.

### T2: calibración y años con estado, en R (commit `feat`)

- **ALCANCE:** `10_utils/10_configuracion.R`, `30_procesamiento/35_generar_motor_html.R`.
- **Cambios:**
  1. En `10_configuracion.R`, dos constantes nombradas con su comentario de porqué (decisión §5): `VT_PERCENTILES_COLOR <- c(inf = 0.05, sup = 0.95)` y `VT_TINTE_MINIMO <- 0.06`.
  2. En `35_generar_motor_html.R`, antes de armar `meta`, calcula sobre **los mismos valores que viajan en el payload** (`round(ind$prom, 0)` de `ind_lst$prom`):
     - `dominio_color`: lista con nombres `"<grado>|<id_indicador>"`, cada uno `c(inf, sup)`, con `round(stats::quantile(x, VT_PERCENTILES_COLOR, type = 7, names = FALSE))` sobre todos los años del grado, `na.rm = TRUE`.
     - `anios_estado`: por grado, los años con al menos un `sigdifgru` no nulo, como vector entero con `I()` para que salga como arreglo.
     - Un `message()` con los ocho rangos, con el estilo de los mensajes `[sNN]` existentes.
  3. Agrega `vista_territorial = list(dominio_color = …, anios_estado = …, tinte_minimo = VT_TINTE_MINIMO)` como **último** elemento de `meta`, después de `nota_8b`.
- **Verificación:**
  - `esperado:` los ocho rangos iguales a la tabla de §3.2.
  - `esperado:` `anios_estado` = `{"4b":[2024,2025],"2m":[2024,2025]}`.
  - Fidelidad del payload (§4).
    - `esperado:` SHA-256 `1e29c2b5…b5b6`.
- Commit: `feat(motor): calibracion de color y anios con estado para la vista historica territorial`.

#### 3.2 Tabla esperada de calibración

| Clave | inf | sup |
|---|---|---|
| `4b\|1` | 65 | 84 |
| `4b\|2` | 66 | 87 |
| `4b\|3` | 67 | 90 |
| `4b\|4` | 60 | 82 |
| `2m\|1` | 68 | 81 |
| `2m\|2` | 67 | 84 |
| `2m\|3` | 68 | 86 |
| `2m\|4` | 61 | 79 |

(fuente: percentiles tipo 7 sobre el payload, calculados en la sesión de redacción el 2026-09-17)

### T3: vista histórica del panorama territorial (commit `feat`)

- **Requiere:** T1 y T2.
- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Paso 0:** lee `App` (estado del panorama, `unidades`, `grupos`, `irFicha`, barra de exportación), `Ficha` (toggle L1322) y el mockup completo. Anota en el log las líneas reales.
- **Especificación** (decisión §3; mockup como referencia visual; clases nuevas con prefijo `vt-`, tokens del `:root`, sin `text-transform`):
  1. **Toggle.** Estado `vistaPan` (`"actual"` por defecto) y un segmentador "Vista actual / Vista histórica" en `.pan-bar`, a la izquierda del de Nivel, con el mismo patrón que la ficha. Deshabilitado (`is-off`) si `grado_anios[panGrado]` tiene un solo año. La vista actual no cambia.
  2. **Filtro territorial compartido.** Extrae el filtro de `unidades` (territorio y dependencia) a una función `pasaTerr(e, terr)` y úsala en `unidades` y en la vista histórica. Es un refactor sin cambio de conducta: la vista actual debe dar los mismos conteos que en FASE 0 (verificación abajo).
  3. **Roster histórico.** Para `panGrado`, todos los años del roster que pasan `pasaTerr`. Por RBD: GSE por año y **GSE vigente** = el del último año con GSE no nulo (nulo si nunca lo tuvo).
  4. **Secciones.** Una por GSE vigente, en el orden de `DATA.meta.gse`, más "Sin clasificar" al final. Se respeta el filtro de GSE existente (`gseVis`), que en esta vista incluye además "Sin clasificar" si hay filas en ese grupo. El encabezado dice `{n} establecimientos · GSE de su último año con resultado`.
  5. **Franja.** Por sección, con el título "Estado vs su GSE, por año": una fila por indicador y una columna por año de `meta.vista_territorial.anios_estado[panGrado]`. Cada celda es `<StackedBar rep={repartoInd(itemsDelAño, ind, panGrado, año)}/>`, donde `itemsDelAño` son los RBD de la sección presentes en el roster de ese año. El rótulo del indicador elegido en la matriz va subrayado. Debajo va la glosa del mockup ("2014–2023: la Agencia no publicó el estado vs GSE. En cada año, el estado de un establecimiento se mide contra el GSE que tenía ese año."), con los años derivados de `anios_estado` y del eje, no escritos a mano.
  6. **Panel de controles de la matriz** (`vt-ctl`): grilla de dos columnas (rótulo de 140 px y contenido) con tres filas.
     - "Indicador": cuatro botones del mismo ancho en una fila; dos por fila bajo 1000 px. Estado `vtInd`, con 1 por defecto.
     - "Estado vs su GSE": leyenda ▼ = ▲ con las muestras de estado.
     - "Puntaje": `0 [barra] 100` en línea, más "– sin resultado", la muestra rayada "sin medición nacional" y "* resultado preliminar". El `title` de la barra dice el rango calibrado.
     - Bajo 640 px, los rótulos van arriba.
  7. **Matriz.** Tabla dentro de un contenedor con `overflow-x:auto` y `min-width` de 760 px. Primera columna fija (`position:sticky`) con el nombre (`nomEE`), `RBD` y, si el GSE vigente difiere de alguno anterior, `· hasta {año}: {GSE}` con el último año del GSE anterior más reciente. Una columna por año de `meta.eje_historico[panGrado]`; los años contiguos con `estado !== "con_dato"` se agrupan en **una** columna de 54 px, rayada, con el encabezado horizontal en dos líneas (`{primero}–` y `{último}`) y `title` con los motivos. El año preliminar lleva `*`.
  8. **Celda.** Sin `prom`: "–" en `--gris` sobre fondo blanco, con `title` "sin resultado". Con `prom`:
     - `k = clamp((prom − inf) / (sup − inf), 0, 1)`.
     - fondo = mezcla de `#ffffff` hacia `ind.color` con proporción `tinte_minimo + (1 − tinte_minimo)·k`.
     - color del texto = el de mayor razón de contraste WCAG con ese fondo entre `#000000`, el valor efectivo de `--gris` (`tokenCSS`) y `#ffffff`.
     - glifo ▼ = ▲ de `sigdifgru` en el mismo color del texto, solo si no es nulo.
     - `title` con año, puntaje y GSE de ese año.
     - Ningún número va sobre una pastilla.
  9. **Orden.** Alfabético por defecto. Al hacer clic en el encabezado del último año con dato se ordena por su puntaje, de mayor a menor (los nulos al final), con `aria-sort`. El pie dice `{n} filas · orden …`.
  10. **Interacción.** Al hacer clic en la celda del nombre, se llama a `irFicha(rbd)`.
  11. **Nacional.** Sin matriz, con la misma nota que hoy reemplaza la grilla; la franja sí se muestra.
  12. **Exportación.** Con `vistaPan === "historica"`, la barra de exportación del panorama no se renderiza.
  13. **Ayuda.** El texto `.help` de la vista histórica es el del mockup, con los años de `anios_estado` derivados.
  14. **Accesibilidad.** `<caption>` visualmente oculto; `scope` en los encabezados; foco visible en botones; la tabla se recorre con el teclado hasta la celda de nombre (`tabindex="0"` y Enter para abrir la ficha).
- **Verificación** (navegador; motor regenerado):
  - Vista actual, SLEP Costa Central, 4° básico: número de establecimientos y conteos de cada barra de la sección Bajo.
    - `esperado:` idénticos a la misma lectura hecha en T1 (el refactor no cambia conducta).
  - Vista histórica, SLEP Costa Central, 4° básico: filas por sección.
    - `esperado:` Bajo 10, Medio bajo 21, Medio 28, Medio alto 1, Sin clasificar 1; total 61 (fuente: conteo del mockup en la sesión de redacción).
    - Calibración: con el filtro de GSE sin "Medio", el total debe bajar a 33.
  - Ídem, 2° medio.
    - `esperado:` Bajo 3, Medio bajo 7, Medio 3; total 13.
  - Franja, sección Bajo, 4° básico, 2024, Autoestima.
    - `esperado:` bajo 4, sin diferencia 6, sobre 0, sin nota (fuente: mockup renderizado en la sesión de redacción).
  - Contraste de cada celda con dato (color del texto contra el fondo computado), en los 8 cortes nivel × indicador.
    - `esperado:` mínimo ≥ 4,5. Valor de referencia del mockup: 4,78 en 4b × Autoestima. Calibra el instrumento con `#000`/`#fff` = 21,00 y `#777`/`#fff` = 4,48.
  - Celdas con texto gris.
    - `esperado:` 0 en SLEP Costa Central (fuente: armado del mockup, 2.467 negro / 48 blanco / 0 gris sobre 2.515 celdas en los dos niveles y cuatro indicadores).
  - Encabezado de años sin medición: `writing-mode` computado.
    - `esperado:` `horizontal-tb`; texto con salto entre `2019–` y `2021`.
  - Página a 390 px de ancho.
    - `esperado:` `document.documentElement.scrollWidth <= innerWidth` (el scroll horizontal ocurre solo dentro del contenedor de la tabla); 0 spans de barra truncados.
  - Nacional, 4° básico, vista histórica.
    - `esperado:` 0 tablas `.vt-` dibujadas y la franja presente.
  - Consola.
    - `esperado:` 0 errores al alternar vistas, niveles, indicadores, orden y GSE.
- Commit: `feat(motor): vista historica del panorama territorial`.

---

## 4. Procedimiento de fidelidad del payload (T2, T3, FASE R)

1. Regenera con `run_all(only = 35L)` y extrae el JSON como en FASE 0 paso 4.
2. Con R, localiza la subcadena `,"vista_territorial":{` dentro de `meta` y elimínala hasta su llave de cierre balanceada. Comprueba que el carácter siguiente es el `}` que cierra `meta`.
3. Normaliza `fecha_generacion` con §8.2 y calcula el SHA-256.
   - `esperado:` `1e29c2b5be529e013f5afb98de323420e842a615b2e4f7a9cc5001ad1b55b5b6` y la misma longitud que `base.json`.
4. Control positivo: repite el paso 2 eliminando un carácter menos y comprueba que el hash **no** coincide.
5. Si el hash no coincide, haz el diff por offsets contra `/tmp/idps_s31/base.json` (método de §8.2 del log de s29), registra las posiciones y detente según 0.1-2.

---

## 5. FASE R: auditoría propia y reparación (penúltima, obligatoria)

Corre siempre, después de la última tarea (congeladas incluidas) y antes de FASE L. **La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta.**

1. **Inventario de afirmaciones auditables.** Se deriva del log, no de la memoria: cada línea `Verificación:` y cada cifra de las secciones por fase, cada 🔒 con su comando, y el alcance global. Se numera (`R-01`, `R-02`, …) y se anexa al log **antes** de auditar.
2. **Re-derivación independiente:** cada afirmación se re-deriva con un comando distinto del que la produjo. Por ejemplo, los conteos de filas por sección, con `Rscript` sobre el JSON en vez de hacerlo en el navegador; el contraste, recalculado en R desde los hex en vez de leer el estilo computado. Sin subagentes (por contrato).
3. **Invariantes 🔒:** el comando de cada uno (§2), PASA/FALLA con la salida literal.
4. **Chequeo global de alcance:** `git diff --name-only <PR>..HEAD` ⊆ unión de los ALCANCE (más el log), y `git status --porcelain` (lo no commiteado es hallazgo, no se limpia).
5. **Regresión completa:** `run_all(only = 35L)` sobre el estado final, con `esperado:` exit 0 y sin warnings nuevos, más §4.
6. **Control positivo de la propia auditoría:** al menos una afirmación se audita además con un caso plantado, por ejemplo una copia temporal en `/tmp/idps_s31/` del template con un `prom` sumado, sobre la que el comando de 🔒1 debe disparar.
7. **Veredicto por hallazgo:**
   - **BLOQUEA:** 🔒 en FALLA, datos alterados, alcance violado, historia divergente. No se repara: se congela la tarea de origen y se registra una duda con pregunta cerrada.
   - **REPARA:** defecto del propio trabajo, dentro del ALCANCE, sin tocar un 🔒 y con verificación calibrada disponible.
   - **ADVIERTE:** discrepancia sin efecto sobre la meta ni los invariantes, o riesgo no medible aquí.

   Sin hallazgos: "0 hallazgos" se declara junto con el control positivo del paso 6, o no se declara.
8. **Ciclo de reparación (máximo 2 ciclos).** Por cada REPARA:
   - (a) causa raíz;
   - (b) fix quirúrgico dentro del ALCANCE;
   - (c) re-verificación con el mismo chequeo que lo detectó y con uno distinto;
   - (d) regresión;
   - (e) commit `fix(auditoria): R-NN <hallazgo>`;
   - (f) fila en la tabla.

   Luego se repiten los pasos 2 a 5 sobre lo tocado. Un hallazgo que sobrevive al segundo ciclo se congela como pendiente.
9. **Prohibiciones:** ajustar un criterio, una tolerancia o un valor esperado; ampliar un ALCANCE; tocar un 🔒; editar evidencia ya escrita; reparar un BLOQUEA.
10. **Salida:** la tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y el veredicto global: `APROBADO`, `APROBADO CON ADVERTENCIAS`, `OBSERVADO` o `BLOQUEADO`.

---

## 6. FASE L: cierre del log (última, obligatoria)

Corre siempre, también si una tarea quedó congelada o FASE R terminó en `BLOQUEADO`.

1. `git status --porcelain`.
   - `esperado:` vacío, o solo el log. Otra cosa se anota como hallazgo y no se limpia.
2. Cierre del log (4.2 del patrón): resumen, inventario de commits derivado de `git log <PR>..HEAD --oneline`, tabla de auditoría, invariantes, estado de cifras, dudas y pendientes consolidados, errores propios, notas para el revisor y estado de cierre.
3. Bloque J (13 campos, copiados del detalle).
4. Grep de privacidad: `grep -nE '[0-9]{1,2}\.?[0-9]{3}\.?[0-9]{3}-[0-9kK]' <LOG>`.
   - `esperado:` vacío.
   - El log no contiene nombres de establecimientos ni filas de datos: solo conteos, hashes y rutas.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE' <LOG>` = número de fases ejecutadas; `grep -c '^esperado:' <LOG>` = `grep -c '^obtenido:' <LOG>`; `grep -c '^## J' <LOG>` = 1 con el bloque relleno.
6. `git add <LOG>` y `git commit -m "docs(log): vista historica territorial s31"`.
7. Si FASE R terminó en `APROBADO` o `APROBADO CON ADVERTENCIAS` y el árbol está vacío: `git push origin main`. Declara el hash del commit `docs(log)` (`git log -1 --format=%h`), qué quedó publicado y que `docs/` **no** se tocó.

---

## 7. Reporte final

- **Primera línea:** la salida literal de `ls -l <LOG> && wc -l <LOG>` y el hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- **Después:** hashes, verificaciones con evidencia, pendientes, marcas `# REVISAR` y lo que falló o sorprendió (si nada, decirlo).
- **Cierre:** la ruta del motor regenerado (`40_salidas/motor_idps.html`) para que el titular lo revise antes del despliegue.

---

## 8. Fuera de alcance

- Despliegue a `docs/index.html` (espera el visto bueno visual del titular).
- Exportación CSV de la vista histórica (decisión §3.10): pendiente propio.
- §5.6 de la decisión de contraste (texto sobre la paleta de INDICADOR en `.defn-title`, `DistBar` y la vista histórica de la ficha).
- `min-width` de `.cmp-table` (pendiente 5 del traspaso v29).
- Exportar como imagen el comparador y el panorama; desmarcar entidades en el tope; divergencias del modal; rama `feat/contrato-contexto`; `renv` y `suitedoc`.
