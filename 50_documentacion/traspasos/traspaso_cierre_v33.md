# Traspaso de cierre — slep_idps — v33 (sesión 34)

## 1. Identificación

- **Proyecto:** `slep_idps` — motor de comparación interactivo de los IDPS.
- **Versión del traspaso:** v33. **Fecha de cierre:** 2026-10-07.
- **Sesión cubierta:** **34**, abierta el 2026-09-26 (`8ddd6c8`) y cerrada el 2026-10-07, con 4 encargos autónomos (s34a a s34d) y 3 despliegues a `docs/` (fuente: `ls activa/encargos | grep -c s34` = 4 y `git log --oneline 8ddd6c8..HEAD | grep -c 'deploy(docs)'` = 3, en esta sesión).
- **Foco:** validar lo publicado en s33 (Atrás tras desplazarse), corregir la posición de la ficha y de cada vista, poner el logo oficial del servicio con "Área de Monitoreo" en la cabecera, reparar las fuentes de marca que nunca cargaban, embeber gobCL Bold y hacer que el verificador revise las fuentes.
- **Entorno:** R 4.5.2 con `renv`; Positron; build `run_all()`; Puppeteer headless con `--disable-gpu`. El asistente leyó el repositorio por el puente de archivos (git solo con `GIT_OPTIONAL_LOCKS=0` y lectura); Claude Code ejecutó todo lo que toca git, salvo el borrado de ramas remotas, que corrió el titular.
- **Protocolo usado:** `POLITICA_PROYECTO.md` "> **Versión 5.9 — vigente.**" y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` "> **Versión 39.** Emitida el 2026-09-30 junto con" (fuente: `grep -m1 -E '^> \*\*Versi'` sobre `gobernanza/` del kit, en esta sesión). La sesión trabajó con la v5.8 y la v38 que `/apertura` sincronizó el 2026-09-26; los cambios de la v5.9 y la v39 (expediente de encargos, protocolo v1.7) no tocaron su trabajo.
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (s34b, s34c); `30_procesamiento/35_generar_motor_html.R` (s34c, s34d); `10_utils/logo_slep_cc_crema.png` y `10_utils/fuentes/gobCL_Bold.otf` (nuevos); `tests/verificar_motor.R` y `tests/verificar_motor_helpers.R` (s34d); `40_salidas/motor_idps.html` y `docs/index.html`.
- **Commits:** desde `8ddd6c8` (apertura) hasta `8354975`, punta de `main` **previa al commit de cierre**; 21 commits en el rango (fuente: `git log --oneline 8ddd6c8..HEAD | wc -l`, en esta sesión). Los hashes definitivos los agrega el eco del cierre.
- **Registro de ejecución detallado:** 4 logs `50_documentacion/andamios/logs/2026*_s34[a-d]_log.md` y el registro del asistente `20260926_registro_asistente_s34.md`.

## 2. Resumen ejecutivo

La sesión partió por la validación que v32 dejó pendiente: s34a midió Atrás tras desplazarse por el panorama y confirmó que vuelve a la misma vista y al mismo lugar, pero mostró que la ficha se abría a media página. s34b lo corrigió: toda vista a la que se llega hacia adelante abre arriba y toda vista a la que se vuelve con Atrás o Adelante recupera su posición (`scrollRestoration` manual, identificador por entrada en `history.state`). Se borraron las ramas remotas ya integradas. A pedido del titular, s34c puso en la cabecera el logo oficial del SLEP con "Área de Monitoreo" (opción C de tres maquetas) y, al medirla, encontró que las fuentes de marca nunca habían cargado en el sitio (saltos de línea dentro de `url()`; en la estación del titular lo tapaba gobCL instalada). s34d embebió gobCL Bold para que el peso 700 deje de caer en la Heavy, agregó al verificador una línea de fuentes por archivo y sacó de `/tmp` los instrumentos de s34c. Todo quedó publicado: el sitio sirve `c1cd87cb…`, igual a `docs/` (fuente: `md5sum` y `curl` en esta sesión). Quedó aprobado aplicar la misma cabecera en `slep_categoria_desempeno` y `slep_simce_adecuado`, pendiente de sus propias sesiones. Estado general: **publicado, verificado y documentado**.

## 3. Estado al cierre

**Qué funciona** (última ejecución: PRUEBAS a, b y c en verde en FASE L de s34d; fuente: log s34d leído en esta sesión):

- Motor = `docs/index.html` = sitio en línea, md5 `c1cd87cb6afb8fd92289e02839479170` (fuente: `md5sum docs/index.html` y `curl` del sitio, en esta sesión).
- Hash §8.2 del payload `eb4e00b3…4dc4` sin cambios en toda la sesión (fuente: `tests/verificar_motor.R` en el log s34d).
- Ocho caras de fuente embebidas y cargadas (gobCL 300, 400, 700, 800 y Museo Sans); gobCL 700 mide distinto de 800 (739,84 frente a 761 px) (fuente: K1 y K2 del log s34d).
- Cabecera opción C: texto a la izquierda, divisor y logo oficial con "Área de Monitoreo"; hasta 720 px el logo sube sobre el título; sin desborde a 320, 360, 390 y 1280 px.
- Posición por vista: adelante abre arriba; Atrás y Adelante reponen la posición (C1, C2 y C3 pasan a 1280 y 390).
- Verificador: nueve `[OK]`, incluida una línea de fuentes por archivo que falla ante saltos, espacios o un base64 truncado.
- Ramas remotas: solo `main` (fuente: `git branch -a`, en esta sesión).

**Qué no funciona / limitaciones conocidas:**

- Recargar la página abre la vista arriba (antes conservaba la posición) (D-1 de s34b, sin decidir).
- A 390 px la cabecera mide 615,84 px y el nombre de la ficha queda bajo el borde al abrirla (D-3 de s34c; el titular prefirió mantener la cabecera móvil actual).
- Todo lo de navegación y cabecera se midió en Chrome headless; sin probar en Safari, Windows ni impresión real (compuerta de dudas).
- La Heavy del repo declara `usWeightClass` 900 y se embebe como 800 (sin efecto visible; D-4 de s34d).

**Delta respecto de v32:** posición por vista, cabecera con logo, fuentes que cargan, gobCL Bold y verificador de fuentes son nuevos; el pendiente 6 de v32 (ramas integradas) quedó resuelto.

**Compuerta de repositorio (2.1) — estado declarado.** La corre el instrumento de cierre. Estado previo: `main` = `origin/main` = `8354975`, porcelain vacío (fuente: `git rev-list --count` y `git status --porcelain` con `GIT_OPTIONAL_LOCKS=0`, en esta sesión). Queda un directorio vacío `Claude outputs/` en la raíz, que git no ve.

**Declaración de insumos (huella).** La produce el verificador en este cierre sobre `./20_insumos`. La sesión no cambió `20_insumos/`.

## 4. Registro detallado de cambios

Número provisional del backlog entre corchetes; el detalle con comandos y salidas vive en los logs.

1. **[194] Atrás tras desplazarse, medido** (s34a). Verificación. Instrumento de navegación sobre el motor publicado: C1 y C2 pasan (misma vista, `Δ = 0` px) a 1280 y 390, con clic y teclado; C3 falla (la ficha abría a la altura del panorama). Resuelve D-5 de s33u.
2. **[195] La ficha abre arriba y cada vista recupera su posición** (s34b, `6f1e124`). Rediseño UI. `history.scrollRestoration = 'manual'`, un id por entrada en `history.state`, mapa en memoria de posiciones y reposición con `flushSync` tras dibujar. Verificación: C1 a C6 en 15 recorridos y dos anchos, más el control plantado de s34a; regresión de direcciones de s33u idéntica.
3. **[196] Ramas remotas integradas borradas** (titular, tras s34b). Limpieza. `ordenacion/20260925` y `feat/contrato-contexto-v2` fuera de GitHub. Resuelve el pendiente 6 de v32 (en lo remoto).
4. **[197] Las fuentes de marca cargan** (s34c T1, `9a80831`). Pipeline / motor. `gsub("\n", "", jsonlite::base64_enc(...), fixed = TRUE)` en el generador; las siete reglas `@font-face` dejaron de descartarse.
5. **[198] Cabecera con el logo oficial y "Área de Monitoreo"** (s34c T2, `539d38e`). Rediseño UI. Opción C elegida por el titular entre tres maquetas; logo en data URI desde `10_utils/logo_slep_cc_crema.png`; gate visual "Sí, despliega".
6. **[199] Instrumentos de s34c fuera de `/tmp`** (s34d T1). Limpieza. 38 instrumentos y un `LEEME.md` en `_archivo/instrumentos/s34c/`, ignorados por git.
7. **[200] El verificador revisa las fuentes embebidas** (s34d T2, `1fc802f`). Verificación. `revisar_fuentes()`: falla con 0 caras, con saltos o espacios en `url(data:…)` o con un base64 que no decodifica a un OpenType entero; controles positivos sobre `8353ae4` y una copia truncada.
8. **[201] gobCL Bold embebida** (s34d T3, `5f143d2`). Rediseño UI. Lo que la plantilla pide en 700 sale en la Bold y no en la Heavy; el generador se detiene si falta una fuente.
9. **Despliegues** (`8353ae4` s34b, `155229b` s34c, `836a3a9` s34d). Deploy. Cada uno con md5 idéntico al motor y testigo propio. No suman.

## 5. Backlog acumulativo

8 entradas nuevas (194–201, numeración provisional), en el bloque `BACKLOG_ENTRADAS` de este paquete. **No suman:** los tres despliegues, los encargos, logs y registro, las tres maquetas de cabecera y las de los hermanos, y las reparaciones de las auditorías propias.

## 6. Bugs de la sesión

1. **Las fuentes de marca nunca cargaban en el sitio** (desde que se embebieron; detectado en s34c). Síntoma: el sitio dibujaba la letra del sistema; en la estación del titular se veía bien porque gobCL está instalada. Causa raíz: `jsonlite::base64_enc` parte el base64 en líneas y `35_generar_motor_html.R` (L565) lo ponía tal cual dentro de un `url()` sin comillas; el navegador descarta la regla entera. Solución: `gsub("\n", "", …, fixed = TRUE)`. **Patrón:** una fuente embebida se verifica por `document.fonts` (estado `loaded`) en un navegador sin la fuente instalada, no a la vista. Verificación permanente: línea de fuentes de `tests/verificar_motor.R`. Estado: resuelto.
2. **La ficha abría a media página** (s34a, C3). Causa raíz: el navegador conserva la posición vertical al cambiar de vista sin cambiar de documento. Solución: posición por vista (s34b). **Patrón:** un `scrollTo(0,0)` solo rompe Atrás; abrir arriba exige guardar y reponer la posición de cada entrada. Estado: resuelto.
3. **gobCL 700 caía en la Heavy** (s34c, tras reparar el bug 1). Causa raíz: el motor embebía 300, 400 y 800, no la Bold. Solución: embeber `gobCL_Bold.otf` (s34d). Estado: resuelto.

## 7. Aprendizajes y restricciones descubiertas

1. **`/tmp` de macOS se vacía en días:** los instrumentos que un encargo deja ahí y otro encargo cita se pierden. Se guardan en `_archivo/instrumentos/<encargo>/` (ignorado), y todo encargo que los use trae la cláusula "si faltan, se reescriben".
2. **Una fuente instalada en la estación tapa una fuente embebida rota:** las mediciones de fuentes se hacen sobre `document.fonts` y sobre las fuentes que Chrome incrusta al imprimir a PDF, no a la vista.
3. **Base64 dentro de `url()` sin comillas: sin saltos ni espacios.**
4. **Con la plantilla congelada, el testigo de un encargo en el motor es el literal que produce el cambio**, no un comentario de R (fila 7 del registro).
5. **La carpeta de salidas de la app del asistente se refleja en la raíz del repo como `Claude outputs/`** y ensucia el porcelain: el asistente escribe en el repo solo entre encargos, en la ruta de destino, y nunca en su carpeta de salidas mientras corre un encargo.
6. **El titular lee el reporte; el asistente lee el LOG completo** antes de responder a cada reporte de Claude Code.

## 8. Decisiones de diseño

Ninguna con archivo propio; el detalle vive en los logs s34b, s34c y s34d.

| Decisión | Alternativa descartada | Motivo |
|---|---|---|
| Cabecera opción C con el logo oficial (titular) | recrear el logo con gobCL; opciones A y B | el logo es marca institucional: se usa el archivo oficial |
| Cabecera móvil actual, logo sobre el título (titular) | compactarla hasta 720 px (D-3 s34c) | se ve bien; el costo es la ficha a 390 px |
| Posición por vista en memoria con id en `history.state` | `sessionStorage` | suficiente para Atrás y Adelante; la recarga queda como D-1 de s34b |
| Embeber gobCL Bold (titular, D-2 s34c) | aceptar la Heavy; fijar 800 | la plantilla pide 700 y debe salir en 700 |
| Instrumentos en `_archivo/` sin versionar (D-1 s34c, b) | versionarlos en `tests/` | son de navegador y no son entregables en R |
| Testigo del motor = literal de la cara 700 (gate s34d) | comentario CSS generado | no toca la plantilla congelada |

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| lista de fuentes embebidas | 7 caras | + `gobCL` 700 `gobCL_Bold.otf` (`10_utils/fuentes/`) | `35_generar_motor_html.R` | D-2 de s34c |
| `logo_path` | (no existía) | `here::here("10_utils","logo_slep_cc_crema.png")` | `35_generar_motor_html.R` | cabecera opción C |
| `.app-marca img` | (no existía) | `width:196px` (150 px hasta 720 px) | `35_motor_template.html` | cabecera opción C |

Fuente canónica de las vigentes: `10_utils/10_configuracion.R` y el `:root` de la plantilla.

## 10. Arquitectura de archivos

El escáner se regenera en este cierre. Cambios: `10_utils/` gana `logo_slep_cc_crema.png` y `fuentes/gobCL_Bold.otf`; 4 encargos en `activa/encargos/`, 4 logs y el registro s34 en `andamios/logs/`. Fuera de git: `_archivo/instrumentos/s34c/` y `_archivo/claude_outputs_20261007/` (ignorados).

## 11. Pendientes y ruta sugerida

**Inventario**

| # | Pendiente | Tipo | Impacto | Dependencias | Complejidad | Precauciones y enfoque | Criterio de éxito |
|---|---|---|---|---|---|---|---|
| 1 | Cabecera con logo en `slep_categoria_desempeno` y `slep_simce_adecuado` (aprobado por el titular): opción C con el logo y "Área de Monitoreo" en ambos; en Categoría, además, `@font-face` de gobCL sin saltos en el base64 y eyebrow solo "Motor de comparación" | funcionalidad (otros repos) | medio | `/apertura` en cada hermano | media | un encargo por hermano, con sus convenciones: Categoría retranspila `33_app.jsx` y corre `spot_check_publicado.R`; simce corre `33_verificar_motor.R` y `36_verificar_trayectorias.R` y cubre `trayectorias.html` si comparte la cabecera; gate visual antes del despliegue. Ninguno tiene el bug de fuentes (Categoría no carga fuentes web; simce carga gobCL-sitio 400/700 bien); fondo de cabecera `rgb(10,58,92)` en los tres | los dos sitios publicados muestran la cabecera opción C, con fuentes `loaded` y sin desborde a 320–1280 px |
| 2 | Validación en terreno (v32, pendiente 1) más la cabecera y la posición por vista en Safari de iPhone y en Windows | validación | medio | ninguna | baja | probar en equipos del Área, no en la estación de desarrollo | las dudas de la compuerta de v32 y de esta, medidas |
| 3 | Dudas abiertas de los logs s34: recarga sin posición (s34b D-1), buscador de la ficha sin entrada nueva (s34b D-3), banco APFS frente a `git clone` (s34b D-5), puntero de la convención (s34b D-6), instrumentos como tarea fija de FASE L (s34d D-1), regla del testigo (s34d D-3), Heavy 900 (s34d D-4) | decisión | bajo | ninguna | baja | una línea de decisión por duda; las de redacción van al kit | cada duda con decisión escrita en el traspaso siguiente |
| 4 | Temporales `/tmp/s34[a-d]_*` (bancos de ~800 MB, capturas y listas con nombres de establecimiento) | limpieza (manual del titular) | bajo | ninguna | baja | el titular los borra; la lista cerrada de los encargos no admite `rm` | `ls -d /tmp/s34*` vacío |
| 5 | Estándar de motores en `herramientas_dev` (v32, pendiente 2), sumando §7 de este traspaso | documentación | alto | ninguna | media | sesión BIBLIOTECA | estándar y plantilla de encargos al día en el kit |
| 6 | Alineamiento de `slep_simce_adecuado` con los patrones (v32, pendiente 3) | deuda técnica (otro repo) | medio | 5 recomendable | media | conviene juntarlo con el pendiente 1 en la sesión de simce | encargo de alineamiento corrido |
| 7 | P-CTX-4 en `slep_minuta_buenas_senales` (v32, pendiente 4) | funcionalidad (otro repo) | medio | simce integra su contexto | media | según `contrato_contexto_v1.md` | la minuta muestra la señal de contexto |
| 8 | Selección en la dirección (v32, pendiente 5) | funcionalidad | bajo | ninguna | media | diferir hasta que el equipo la pida | un enlace reproduce la selección |
| 9 | Ramas locales viejas `feat/contrato-contexto` y `gobernanza/v16` | limpieza | bajo | ninguna | baja | borrarlas desde Claude Code tras comprobar que están integradas | `git branch` muestra solo `main` |
| 10 | Nombres con tildes en 4 archivos de `andamios/diseno/` (v32, pendiente 7) | deuda heredada | bajo | `andamios/` congelado | baja | excepción declarada | excepción escrita o archivos archivados |

**Evaluación de deuda técnica.** La zona frágil sigue siendo la redacción de los encargos (registro de 8 filas; lectura en §15). En el código, el generador concentra ahora tres responsabilidades sensibles (payload, fuentes y logo en línea); el verificador cubre payload y fuentes, no el logo.

**Auditoría de cierre (POLITICA 5.6).** ¿Repositorio publicado y sincronizado? Sí (`main` = `origin/main` = `8354975`; fuente: `git rev-list --count` en esta sesión). ¿El artefacto desplegado corresponde al código? Sí (md5 `c1cd87cb…` en `docs/` y en el sitio; fuente: `md5sum` y `curl`). ¿Decisiones de peso como archivo? No (viven en los logs y en §8; ninguna cambia el dato). ¿Cifras medidas en la sesión? Sí (logs y verificador). ¿Trabajo sin commitear? No (porcelain vacío). ¿Escáner al día? No: se regenera en este cierre. ¿Pipeline corre de cero? Sí (PRUEBAS b en s34d). ¿Guarda de locale? Sí. ¿Nombres sin tildes ni espacios? No en 4 archivos de `andamios/diseno/` (pendiente 10).

**Salida de la compuerta de dudas (2.1): 3 registradas.**

| supuesto | predicado | medicion |
|---|---|---|
| La posición por vista funciona fuera de Chrome | En Safari de iPhone, bajar por el panorama, abrir una tarjeta y pulsar Atrás vuelve a la misma tarjeta, y la ficha abre arriba | Probarlo en el sitio publicado desde un iPhone |
| La cabecera móvil se ve igual en Safari y en Windows | A 390 px el logo queda sobre el título, sin desborde, con gobCL cargada | Abrir el sitio en un iPhone y en un equipo Windows sin gobCL instalada |
| La versión crema del logo cumple la norma gráfica | El manual de marca del servicio admite el logo en color claro sobre fondo azul con la línea de comunas recortada | Revisar el manual de normas gráficas con quien administra la marca del SLEP |

**Ruta sugerida para la próxima sesión** (criterios de 1.2.4):

1. **Pendiente 1, desde las sesiones de cada hermano:** es lo aprobado y pendiente de ejecución; en `slep_idps` no requiere trabajo.
2. **Pendientes 2 y 3 en `slep_idps`:** validación en terreno y decisiones de las dudas de s34; baratas y son lo único que puede mostrar un defecto en lo publicado.
3. **Pendiente 5 (BIBLIOTECA):** llevar al kit las reglas de §7.

Conviene diferir: selección en la dirección (8).

## 12. Instrucciones específicas para la próxima sesión

- ✅ **PRIMERO**: correr `/apertura` y pegar su eco.
- ⚠️ **NO** correr `git` que escriba sobre el repositorio desde fuera de Claude Code; el asistente lee git con `GIT_OPTIONAL_LOCKS=0` y solo lectura.
- ⚠️ **NO** tocar un archivo versionado del repo mientras corre un encargo, ni escribir en la carpeta de salidas de la app (se refleja en el repo como `Claude outputs/`).
- ⚠️ **NO** describir en un encargo una clase, un texto o un componente sin `grep` o `sed` sobre la plantilla de **este** motor.
- ⚠️ **NO** abrir Chrome con ventana: siempre headless con `--disable-gpu`.
- ✅ **ANTES** de responder a un reporte de Claude Code, leer el LOG completo.
- ✅ **ANTES** de citar un instrumento de otro encargo, comprobar que existe (en `_archivo/instrumentos/` o `/tmp`) y escribir la cláusula "si falta, se reescribe".
- ✅ **ANTES** de desplegar, `Rscript tests/verificar_motor.R` con rc = 0 (incluida la línea de fuentes) y pantalla idéntica o gate visual del titular.
- ✅ El testigo de un encargo en el motor es un literal que el cambio produce en el HTML.
- 🔒 **Cero agregación:** el territorio acota la lista de establecimientos; jamás produce un puntaje propio.
- 🔒 **`sigdifgru` es la fuente del estado vs GSE**; donde es nulo se dice **"sin comparación válida"**.
- 🔒 **La paleta de ESTADO y la de INDICADOR no se tocan.**
- 🔒 **`trazarBarra` decide todo el trazado de la barra**; pantalla e imagen solo pintan.
- 🔒 **El motor no pide nada a la red.**
- 🔒 **El logo de la cabecera es el archivo oficial**; no se recrea ni se redibuja.

## 13. Fragmentos de código de referencia

```r
# Base64 de una fuente para un url() sin comillas (s34c): sin saltos de línea.
ruta <- here::here("10_utils", "fuentes", "gobCL_Bold.otf")
b64  <- gsub("\n", "", jsonlite::base64_enc(readBin(ruta, "raw", n = file.info(ruta)$size)), fixed = TRUE)
```

```bash
# Verificación versionada del motor, con la línea de fuentes (s34d).
cd /Users/tomgc/Projects/slep_idps && Rscript tests/verificar_motor.R; echo "rc=$?"
```

Patrones estables: `CLAUDE.md` del proyecto.

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md y
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project y se lee
> desde ahí; no lo adjunto. Adjunto el traspaso `traspaso_cierre_v33.md`.
> Estado: `origin/main` = commit de cierre de v33, árbol limpio, sitio desplegado en
> `docs/index.html` (md5 `c1cd87cb…`), `tests/verificar_motor.R` en verde. Foco
> propuesto: validación en terreno (Safari de iPhone y Windows) y decisión de las
> dudas abiertas de s34; la cabecera de los hermanos corre en sus propias sesiones.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `encargo_autonomo_claude_code_v1.md`.
2. *Opcionales según el foco:* `CLAUDE.md` si correrá en Claude Code.
3. *Específicos (sí se adjuntan):* `traspaso_cierre_v33.md`. El asistente lee el repositorio por el puente de archivos.

**Nota final:** si alguno de estos archivos cambia entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente (POLITICA 0.5)

Filas 1 a 6: copia del registro `50_documentacion/andamios/logs/20260926_registro_asistente_s34.md`. Filas 7 y 8: registradas solo aquí (escribirla en el registro habría ensuciado el árbol antes del cierre).

| # | momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Redacción del encargo s34a, criterio C1 y caso bueno M7 | ejecutor lo detectó en FASE 0 (prueba de humo sobre `docs/`, pregunta al titular) | C1 exigía `location.hash = #panorama` tras Atrás, pero R1 abre el motor sin hash, y el motor (decisión de s33u) no escribe nada en la dirección al abrir: Atrás vuelve a esa entrada con hash vacío, de modo que el caso bueno M7 falla por construcción | `encargo_autonomo_claude_code_v1.md` §2.6 (el criterio se calibra contra un caso bueno conocido) y §2.2 regla 1; traspaso v32 §12 (una premisa de un encargo se mide en el turno de redacción) | El redactor leyó en ese mismo turno el comentario de la plantilla ("Al abrir, la pantalla ya salió de la dirección y no se escribe nada") y lo citó en las premisas, pero escribió C1 desde el nombre de la vista (`#panorama`) sin cruzarlo con el paso 1 de R1, que abre sin hash | traspaso v32 / patrón de encargos | PAT-07, restricción leída (abrir sin dirección no escribe nada) no propagada al criterio C1 | restriccion-no-propagada: criterio de hash fijo en un recorrido que abre sin hash, con la regla de apertura citada en las premisas del mismo encargo | 0 | 1 gate del ejecutor al titular; ningún cambio en el árbol |
| 2 | Registro de la fila 1, durante la corrida de s34a | ejecutor lo detectó en FASE 0 (porcelain con `?? "Claude outputs/"`, 10:46:24); la sesión 33 lo movió después al destino | El asistente escribió el registro en su carpeta de salidas de la app, que se refleja en la raíz del repo como `Claude outputs/`, mientras corría un encargo: el porcelain quedó sucio, 🔒2 (ii) no se cumplió por la letra y el push autorizado no corrió | traspaso v32 §12 (⚠️ NO tocar un archivo versionado del repo mientras corre un encargo) y la cabecera del propio registro ("no se escribe en el repo mientras corre s34a") | Se tomó la carpeta de salidas por un lugar fuera del repo sin medir dónde aterriza, pese a que s32 ya había dejado el mismo `Claude outputs/` bloqueando un push (D-4 de s32, en `CLAUDE.md`) | traspaso / CLAUDE.md | PAT-03, supuesto sobre dónde aterriza la carpeta de salidas de la app | comando-entorno: escritura en la carpeta de salidas con un encargo corriendo sobre la carpeta conectada | 1 (s32, `Claude outputs/20260923_registro_asistente_s32.md`, mismo efecto) | push de s34a retenido; un traslado manual hecho desde otra sesión |
| 3 | Redacción del encargo s34b, T2 paso 3 ("re-medir M6 sobre el motor nuevo para comprobar que el instrumento sigue discriminando") | ejecutor lo detectó en T2 (A-6, D-4 de s34b) | El encargo pidió usar la simulación "después" como prueba de que el instrumento discrimina sobre el motor nuevo, cuando el remedio que el mismo encargo describía (el motor guarda y repone la posición por su cuenta) neutraliza esa simulación por construcción: sobre el motor nuevo M6 da C2 PASA y no puede discriminar nada | `encargo_autonomo_claude_code_v1.md` §2.6 (el criterio se calibra y debe poder dar el resultado contrario) | Se trasladó el caso malo de FASE 0 a la verificación posterior sin preguntarse si el cambio pedido lo dejaba inerte; el ejecutor lo suplió con el desplazamiento plantado de s34a | patrón de encargos | PAT-13, control de discriminación que el propio remedio vuelve inerte | encargos-premisas: caso malo reutilizado después de un cambio que elimina el mecanismo que lo hacía fallar | 0 | ninguno en el árbol; una duda (D-4) |
| 4 | Redacción del encargo s34b, criterio C3 ("`.ficha-name` dentro del viewport") | ejecutor lo detectó en FASE R, barrido de las 60 tarjetas (A-1, D-2 de s34b) | C3 exigía el nombre entero dentro de la pantalla, pero a 390 px el nombre empieza en 696 px y un nombre de tres líneas termina en 810 px: con la ficha arriba, C3 falla por la letra para 1 de 60 establecimientos, aunque la intención (la ficha abre arriba) se cumple | `encargo_autonomo_claude_code_v1.md` §2.6 (el criterio mide el riesgo, no un proxy) y SETTINGS §1.2.6 (inspección antes de especificar) | El log de s34a traía la posición y el alto del nombre a 390 (696,45 px, 82,6 px) para una sola tarjeta; se fijó el criterio sobre ese caso sin considerar que el alto del nombre varía por establecimiento | log s34a / patrón de encargos | PAT-13, criterio que mide el nombre entero visible (proxy) y no que la vista abre arriba (riesgo) | cifras-datos: umbral de visibilidad fijado con la medida de un solo elemento cuyo alto varía | 0 | ninguno en el producto; una duda (D-2) |
| 5 | Respuesta tras el borrado de ramas (validación de terreno) | usuario lo corrigió ("se me pierde lo que me quieres decir") | Dos párrafos de prosa y una referencia a "la lista" entregada varios turnos antes, en vez de la lista misma en pasos numerados | userPreferences, Brevedad (tope de forma; dos párrafos de prosa seguidos prohibidos) y preferencias del Project (pasos del titular numerados) | Se priorizó dar contexto sobre entregar la acción; se citó un artefacto anterior en vez de repetirlo | userPreferences / memoria del Project | PAT-08, verbosidad sobre el tope de forma | otro: respuesta con prosa de contexto y acción referida a un turno anterior | 0 | 1 turno del titular |
| 6 | Redacción del encargo s34c, INSUMOS y M3 (instrumentos de s34b en `/tmp`) | ejecutor lo detectó en FASE 0, M3 (gate al titular) | El encargo dio por presentes los instrumentos `/tmp/s34b_*` sin marcarlo como hipótesis y su M3 congelaba T3 si faltaban; faltaban (macOS vació `/tmp` en 11 días) y hubo que reescribirlos con un gate. El encargo s34b sí traía la cláusula "si faltan, se reescriben y la calibración decide" | `encargo_autonomo_claude_code_v1.md` §2.2 (toda premisa lleva marcador; sobre un entorno ajeno, hipótesis medida) y la cláusula del propio encargo s34b | Se copió la lista de insumos de s34b sin su rama de contingencia, sabiendo que `/tmp` es volátil (D-5 de s34a, que el mismo redactor resolvió dejándolos ahí) | patrón de encargos / log s34b | PAT-07, restricción leída (los temporales de `/tmp` pueden faltar) no propagada al diseño de M3 | comando-entorno: insumo en `/tmp` de otra sesión, 11 días antes, sin rama de reescritura | 0 | 1 gate del titular; instrumentos reescritos y recalibrados |
| 7 | Redacción del encargo s34d, testigo de T3 y T4 | ejecutor lo detectó en FASE 0, M5 (gate al titular: "Leer la cara 700") | T3 ponía el testigo `s34d: gobCL Bold` como comentario de R en el generador y T4 lo contaba "≥ 1 en el motor"; un comentario de R no viaja al HTML, así que el esperado de T4 era inalcanzable por construcción | `encargo_autonomo_claude_code_v1.md` §2.6 (esperado calibrado y alcanzable) y §2.2 regla 1 | El redactor sabía que 🔒2 congelaba la plantilla y que el único cambio del motor sería la regla `@font-face` generada, pero escribió el testigo por la costumbre de encargos que sí editaban la plantilla | patrón de encargos | PAT-07, restricción leída (plantilla congelada) no propagada al testigo | restriccion-no-propagada: testigo escrito como comentario de R y contado en el HTML generado | 0 | 1 gate del ejecutor al titular; ningún cambio en el árbol |
| 8 | Redacción del paquete de cierre v33, campo `settings_version` y §1 del traspaso | ejecutor lo detectó en F0 punto 6 (`/cierre` detenido con BLOQUEA) | Transcribí la línea de encabezado de la copia de `activa/` (v38, sincronizada por `/apertura` el 2026-09-26) y no la del kit, que desde el 2026-09-30 está en v39 | SETTINGS §2.1 (cita de versión por transcripción de la línea leída en el turno; la traza `settings_version` se verifica contra el kit) | Tomé la copia del repositorio como fuente de la versión vigente sin comprobar contra qué la compara el ejecutor, en una sesión abierta once días | SETTINGS | PAT-13, versión transcrita de una copia sincronizada al abrir (proxy) y no del kit que el ejecutor compara (riesgo) | comando-entorno: `settings_version` tomado de `activa/` en una sesión abierta más de un día | 0 | 1 corrida de `/cierre` detenida; paquete reemitido |

**Lectura:** 8 filas: PAT-03 1, PAT-07 3, PAT-08 1, PAT-13 3 (fuente: conteo por python sobre la columna patron de esta tabla, en esta sesión). El patrón dominante de esta sesión es PAT-07: criterios y testigos escritos sin cruzar una restricción que el propio redactor había leído (apertura sin hash, instrumentos en `/tmp`, plantilla congelada). La salvaguarda de forma (§2.2.16) es una línea por criterio con la restricción que lo condiciona, escrita junto al esperado.

**Del ejecutor (Claude Code):** registrados en "Errores propios" de cada log (s34c E-1 a E-7, s34d E-1 a E-3, entre otros); todos de instrumento o de redacción del log, ninguno cambió una cifra medida.

## 16. Fricciones (2.2.17)

- friccion: el asistente refirió "la lista" sin repetirla y en dos párrafos → pasos numerados y lo que el titular debe hacer, primero.
- friccion: el titular tuvo que recordar "lee el log" en tres reportes → lectura del LOG completo como regla permanente (§12).
- friccion: la conversación se compactó por largo → cierre pedido por el titular; conviene cerrar tras cada bloque temático (se repite la fricción de v32).
