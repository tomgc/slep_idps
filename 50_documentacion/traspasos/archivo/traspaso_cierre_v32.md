# Traspaso de cierre — slep_idps — v32 (sesión 33)

## 1. Identificación

- **Proyecto:** `slep_idps` — motor de comparación interactivo de los IDPS.
- **Versión del traspaso:** v32. **Fecha de cierre:** 2026-09-26.
- **Sesión cubierta:** **33**, abierta el 2026-09-24 y cerrada el 2026-09-26, con 20 encargos autónomos (s33 a s33u; s33k quedó superado por s33m y no corrió) y seis despliegues a `docs/` (fuente: `ls activa/encargos | grep -c s33` = 20 y `git log --oneline 55471b4..HEAD | grep -c "deploy(docs)"` = 6, en esta sesión).
- **Foco:** cerrar los pendientes de v31 (limpieza, foco del modal, divergencia 39 frente a 24, CSV histórico, base pequeña, exportación de imagen, `renv`, rama de contexto, ordenación), medir el motor contra sus dos hermanos y adoptar lo que la matriz mostró que le faltaba (motor sin red, verificación versionada del dato, vistas con dirección propia).
- **Entorno:** R 4.5.2 con `renv`; Positron; build `run_all()`; Puppeteer con Chrome del sistema (headless desde s33s). El asistente leyó el repositorio por el puente de archivos; Claude Code ejecutó todo lo que toca git, salvo un push, el merge del PR #4 con su `pull` y un commit de documentación que el titular corrió con `!` en Claude Code.
- **Protocolo usado:** `POLITICA_PROYECTO.md` "> **Versión 5.8 — vigente.**" y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` "> **Versión 38.**" (fuente: `head -3` de las copias en `activa/` y knowledge base, leídos en esta sesión).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (casi todos los encargos); `30_procesamiento/35_generar_motor_html.R` (transpilación con V8, s33q); `10_utils/` (React, ReactDOM y Babel vendorizados); `30_procesamiento/36_exponer_contrato_contexto.R` y `40_salidas/publico/contexto_idps.parquet` (contrato integrado); `00_build.R` (paso 36); `00_escanear_proyecto.R` (E-1, E-2); `renv.lock`, `.renvignore`; `tests/verificar_motor.R` y `tests/verificar_motor_helpers.R` (nuevos); `40_salidas/motor_idps.html` y `docs/index.html`; decisiones nuevas `20260925_decision_base_pequena.md` y `20260925_decision_exportacion_imagen.md`, y enmiendas en `20260910_decision_contraste_texto_estado.md` y `20260917_decision_vista_historica_territorial.md`; `50_documentacion/activa/50_ordenacion_repositorio.md` y `50_datos_versionados_autorizados.md`.
- **Commits:** desde `d046c9c` (apertura de sesión) hasta `44efae7`, punta de `main` **previa al commit de cierre**; 112 commits en el rango (fuente: `git log --oneline 55471b4..HEAD | wc -l` y `.git/refs/heads/main`, en esta sesión). Los hashes definitivos los agrega el eco del cierre.
- **Registro de ejecución detallado:** 20 logs `50_documentacion/andamios/logs/2026092[45]_*_log.md` y el registro del asistente `20260924_registro_asistente_s33.md` (detalle no reproducido aquí).

## 2. Resumen ejecutivo

La sesión cerró los trece pendientes de v31 y agregó los que salieron en el camino. Primero, un bloque de interfaz (s33 a s33i): foco de respaldo del modal, anillo de la ficha, cada cifra con su universo ("en el directorio", "con IDPS en…"), modal alineado con el del hermano, accesibilidad en pantallas angostas, CSV de la vista histórica y filas del modal que caben en su lista; se desplegó tras el gate visual del titular. Después, la infraestructura: `renv` sincronizado, parquet de contexto autorizado, tres diagnósticos para que el titular decidiera (base pequeña, exportación de imagen, ordenación) y una matriz de 20 patrones de usabilidad medida en los tres motores de la cartera. Con esas decisiones corrió la ejecución final (s33o): marca de base pequeña (u = 5), los cuatro defectos que la matriz encontró en este motor, impresión limpia, escáner corregido con su PR (#4, integrado) y la rama de contexto sin normativos. Por último se adoptó lo que la matriz mostró que faltaba: el motor abre sin red (s33q), el contrato de contexto entró a `main` con escritura idempotente y periodo derivado (s33q, s33r, s33t), el comparador y el panorama exportan SVG y PNG desde un trazado único de la barra (s33s, s33t), el dato del motor tiene un verificador versionado y las vistas tienen dirección propia (s33u). Todo quedó publicado: el sitio sirve `c5542b20…`, igual a `docs/` y al motor (fuente: `curl` y `openssl md5` en esta sesión). El costo fue de redacción: 14 errores del asistente en los encargos, detectados en gates o por el ejecutor, ninguno con efecto en las cifras. Estado general: **publicado, verificado y documentado**.

## 3. Estado al cierre

**Qué funciona** (última ejecución: `run_all()` con exit 0 en s33u, en el clon por la medianoche, y `Rscript tests/verificar_motor.R` con rc = 0 sobre el estado final; fuente: log s33u):

- Motor publicado = `docs/index.html` = sitio en línea, md5 `c5542b2013b6fb6e5d42f709ca723c3c` (fuente: `openssl md5` y `curl` en esta sesión).
- Hash §8.2 del payload `eb4e00b3…4dc4` sin cambios en toda la sesión; ahora lo mide también `tests/verificar_motor.R` (16 celdas ancla iguales al parquet, 0 peticiones de red; fuente: salida del script en el reporte de s33u).
- Abre sin red: React y ReactDOM en línea, JSX transpilado en el build con V8 (idéntico carácter a carácter al que hacía el navegador); 0 `src="http"` y 0 `href="http"` en `docs/` (fuente: `grep -c` en esta sesión).
- Exportaciones: CSV del comparador (con sufijo de GSE), del panorama, de la ficha y de la vista histórica; SVG y PNG del radar, del comparador y del panorama en sus dos vistas; impresión limpia en A4 horizontal (comparador en 12 hojas).
- Base pequeña: `N` junto a cada barra del comparador y asterisco con `1 ≤ N < 5`, con nota al pie.
- Vistas con dirección: `#panorama`, `#ficha`, `#comparador`, con Atrás y Adelante.
- Modal: filas con teclado, foco retenido con respaldo, ✕ en el encabezado, Nacional sin buscador, franja para quitar al tope, filas que caben en la lista.
- Contrato de contexto en `main`: paso 36 en `run_all()`, parquet `be084d72…` con `periodo 2026-09`, 39.591 × 15, que se reescribe solo si cambia el contenido (fuente: `openssl md5` en esta sesión y log s33t).
- `renv::status()` consistente; `renv.lock` con 46 paquetes (fuente: `python3 json` en esta sesión).
- Ordenación del repositorio hecha (marcador `50_ordenacion_repositorio.md`); guarda de locale presente.

**Qué no funciona / limitaciones conocidas:**

- Atrás después de desplazarse por el panorama y abrir una tarjeta no quedó medido (D-5 de s33u).
- La dirección guarda solo la vista, no la selección (territorio, establecimiento, entidades).
- Con 10 entidades el PNG del comparador supera el techo seguro y el motor ofrece el SVG (decisión, no defecto).
- Algunas cifras que en pantalla van dentro de la barra bajan a la tira externa en la imagen, por la pila tipográfica del sistema (D-4 de s33t, aceptado).
- Sin probar fuera del navegador del Área: SVG en PowerPoint, CSV en Excel, Windows, impresión real (compuerta de dudas).

**Delta respecto de v31:** todo lo de arriba es nuevo; las limitaciones de v31 quedaron resueltas.

**Compuerta de repositorio (2.1) — estado declarado.** No se ejecutó dentro de la sesión; la corre el instrumento de cierre. Estado previo: `main` = `origin/main` = `44efae7`, porcelain vacío (fuente: `.git/refs` y `git status --porcelain` con `GIT_OPTIONAL_LOCKS=0` en esta sesión).

**Declaración de insumos (huella).** La produce el verificador en este cierre sobre `./20_insumos`. La sesión no cambió `20_insumos/`.

## 4. Registro detallado de cambios

El detalle por fase, con comandos y salidas, vive en los 20 logs de la sesión. Bloques conceptualmente independientes (número provisional del backlog entre corchetes):

1. **[170] Limpieza de código muerto** (s33). Categoría: limpieza / deuda técnica. `_txtOn` y `const col` retirados; encabezado de §5 de la decisión de contraste al día. Verificación: `DistBar` y tooltips idénticos a la línea base.
2. **[171] Foco de respaldo del modal** (s33). Rediseño UI. Si el botón que abrió el modal ya no existe, el foco va al contador del comparador o al nombre de la ficha, no a `BODY`.
3. **[172] Anillo de foco del nombre de la ficha** (s33b). Rediseño UI. `--foco` (1,84:1) → `--cream` (11,01:1) sobre la barra azul.
4. **[173] Cada cifra nombra su universo** (s33c). Saneamiento de presentación. La fila del modal dice "en el directorio" y el chip "con IDPS en <nivel> <año>"; resuelve la divergencia 39 frente a 24. Ninguna cifra cambió (0 de 816).
5. **[174] Modal del comparador alineado con el hermano** (s33c). Rediseño UI. "Traspaso AAAA" en la fila SLEP, ✕ en el encabezado, Nacional sin buscador, franja para quitar al tope.
6. **[175] Accesibilidad en pantallas angostas** (s33d). Rediseño UI. Hover del ✕ 4,11 → 5,61; sin desborde a 320 y 360 px; chip con año preliminar; foco al volver de Nacional.
7. **[176] CSV de la vista histórica** (s33e, s33f). Exportación de datos. 15 columnas, una fila por establecimiento, año e indicador; nombre `…_sin_clasificar_excluido.csv` cuando corresponde.
8. **[177] Pestañas y vista histórica en pantallas angostas** (s33f, s33g). Rediseño UI. La pestaña larga parte en dos líneas a 320 px; `position:relative` en `.vt-scroll` saca 423 px de desborde.
9. **[178] Filas del modal caben en su lista** (s33i). Rediseño UI; bug reportado por el titular en el gate visual. El `sub` cede ancho primero; 36 → 0 nombres partidos.
10. **[179] `renv` sincronizado** (s33j). Limpieza. `.renvignore` excluye la suite de documentación.
11. **[180] Parquet de contexto autorizado** (s33l). Gobernanza de datos. Una línea con la ruta exacta en `50_datos_versionados_autorizados.md`, tras verificar 0 RUT y unidad establecimiento.
12. **[181] Decisiones de base pequeña y exportación de imagen** (s33m y redactor). Decisión / gobernanza de producto. Tres diagnósticos (con réplica en R validada contra el motor) y dos decisiones escritas.
13. **[182] Matriz de patrones de usabilidad entre los tres motores** (s33n). Verificación / auditoría. 20 patrones × 3 motores, 60 de 60 celdas con evidencia; insumo del estándar de motores.
14. **[183] Marca de base pequeña** (s33o T1). Saneamiento de presentación. `u = 5`, `1 ≤ N < 5`, solo el comparador.
15. **[184] Defectos que la matriz encontró en este motor** (s33o T2). Saneamiento de presentación. "1 indicador" con plural, fila Región con su universo, sufijo de GSE en el CSV del comparador, ancla "sin comparación válida".
16. **[185] Impresión limpia** (s33o T3). Exportación de datos. `@media print`, A4 horizontal, colores forzados, re-medición de etiquetas en `beforeprint`.
17. **[186] Ordenación del repositorio** (s33o T5). Limpieza. E-1 y E-2 del escáner y marcador, en PR #4 integrado por el titular.
18. **[187] Motor sin red** (s33q). Pipeline / motor. Método del hermano (D31-1): vendorizado con sha384 y transpilación en el build con V8.
19. **[188] Contrato de contexto integrado** (s33l, s33o T6, s33q T4, s33r T2, s33t T3). Pipeline / motor. Rama `feat/contrato-contexto-v2` sin normativos, merge a `main`, periodo derivado de una sola lectura de la fecha, escritura solo si cambia el contenido, parquet regenerado con `periodo 2026-09`; corrige además un defecto de codificación del parquet de julio (28.955 celdas con escapes escritos en el dato).
20. **[189] `renv.lock` completo** (s33r T1). Limpieza. askpass, curl, Rcpp y sys registrados.
21. **[190] Exportación del comparador en SVG y PNG** (s33s). Exportación de datos. `trazarBarra` decide todo el trazado; `StackedBar` y el SVG pintan; pantalla idéntica a la publicada.
22. **[191] Exportación del panorama en SVG y PNG** (s33t). Exportación de datos. Vista actual (sin grilla) e histórica (franja indicador × año, sin matriz); rótulos del marco compartidos.
23. **[192] Verificador versionado del motor** (s33u). Verificación / auditoría. `tests/verificar_motor.R`: hash §8.2, 16 celdas ancla, red, motor = `docs/`.
24. **[193] Vistas con dirección propia** (s33u). Rediseño UI.
25. **Despliegues** (`ec17e17` s33h, `b602d6e` s33p, `fbcf75f` s33q, `c351990` s33s, `b97d76d` s33t, `aa3386b` s33u). Deploy. Cada uno con md5 idéntico al motor y testigo propio.

## 5. Backlog acumulativo

24 entradas nuevas (170–193, numeración provisional), en el bloque `BACKLOG_ENTRADAS` de este paquete. **No suman:** los seis despliegues, los encargos, logs, registro y documentos de diagnóstico por separado, las reparaciones de las auditorías propias, el encargo de alineamiento redactado para `slep_categoria_desempeno` (repo distinto) y el mensaje de contexto para `slep_minuta_buenas_senales`.

## 6. Bugs de la sesión

1. **Filas del modal más anchas que su lista** (s33c → s33i). Síntoma: scroll horizontal, nombre partido y fondo cortado en el modal del comparador (captura del titular). Causa raíz: s33c alargó el `sub` y `.check-region{flex:0 0 auto}` no cedía ancho. Solución: `.check-name{flex:0 1 auto;min-width:0}` y `.check-region{flex:1 1 0}`. **Patrón:** un texto alargado se verifica por su efecto en el ancho, no solo por su contenido. Estado: resuelto.
2. **Parquet de contexto con escapes UTF-8 escritos en el dato** (julio; detectado en s33q). Causa raíz: la corrida de julio escribió `<c3><a9>` como texto en `eje_etiqueta`. Solución: regeneración con el productor actual. **Patrón:** un escape que "muestra la consola" se verifica leyendo el valor, no la impresión. Estado: resuelto.
3. **Cada build en otro día reescribía el parquet de contexto** (s33r). Causa raíz: `fecha_calculo = Sys.Date()` en cada escritura. Solución: escribir solo si cambia el contenido. Estado: resuelto.
4. **Chrome da forma al texto por nodo del DOM** (s33s). Síntoma: pocos píxeles distintos con el mismo HTML visible al juntar nodos de texto. Solución: pintar en los mismos nodos que antes. **Patrón:** para una pantalla idéntica, la estructura de nodos también es parte del contrato. Estado: resuelto.

## 7. Aprendizajes y restricciones descubiertas

1. **Un `git status` corrido desde un entorno sin permiso de borrado deja un `.git/index.lock`.** El asistente lee git con `GIT_OPTIONAL_LOCKS=0` y solo con comandos que no escriben.
2. **Puppeteer corre siempre headless en encargos largos** (decisión del titular en s33s): las ventanas interrumpen su trabajo.
3. **Convención de pantalla idéntica** (D-2 de s33s y s33t): `--disable-gpu`, puntero fuera, página completa hasta 16.384 px y tramos de 8.000; pasa si alguna de hasta tres capturas es idéntica a alguna de dos de `docs/`; la corrida completa admite un reintento.
4. **Un build que cruza la medianoche cambia `fecha_generacion`:** después de medianoche, la prueba de build corre en un clon (D-2 de s33u).
5. **`tests/verificar_motor.R` es la PRUEBA c de los encargos** (D-4 de s33u). `HASH_ESPERADO` se cambia solo cuando cambia el dato, en el mismo commit del build y con la razón en el log.
6. **Una rama se describe por `git diff --stat main...rama` (tres puntos)**, no por sus mensajes de commit.
7. **Cuando un hermano tiene una sesión abierta, su invariante mide la autoría de los cambios, no el md5:** "copias + atribución" (s33n) y porcelain completo del hermano en FASE 0.
8. **Una diferencia de pantalla reparable (implementación) no es un cambio de diseño:** con tope de intentos y re-verificación completa bajo el mismo criterio (s33s, decisión del titular).

## 8. Decisiones de diseño

Replicadas como archivo: `20260925_decision_base_pequena.md`, `20260925_decision_exportacion_imagen.md` (con §4 y estado al día), enmiendas en `20260910_decision_contraste_texto_estado.md` (§5.2 resuelta) y `20260917_decision_vista_historica_territorial.md` (s33e, §3.10).

| Decisión | Alternativa descartada | Motivo |
|---|---|---|
| Base pequeña con u = 5, `N` de cada barra, solo el comparador (titular) | N único por fila; umbral mayor | el N difiere entre indicadores; con u mayor se marca casi todo |
| Exportación: impresión ahora y SVG después (titular) | foreignObject | sin precedente y con canvas contaminado |
| SVG por trazado único (criterio delegado) | reescribir `StackedBar` en SVG | misma garantía de no divergir con riesgo nulo para la pantalla |
| Imagen histórica = franja indicador × año (D-1 s33t) | una fila por año | la imagen dibuja lo que dibuja la pantalla |
| Motor sin red con el método del hermano | Babel en línea; transpilado a mano | sin paso manual y sin 3 MB extra |
| Contrato: escritura solo si cambia el contenido | reescribir siempre | un build no debe ensuciar el árbol |
| Rama de contexto b′ sin normativos | publicar la rama vieja | `main` retiró los normativos del repo público |
| Dirección desconocida se deja tal cual (D-1 s33u) | borrarla con `replaceState` | abrir la página se ve igual |
| Ordenación con lectura literal del grep (L) | lectura histórica (H) | nada se mueve con referencias vivas |
| Rótulos del radar fuera del bloque compartido (D-3 s33t) | encargo aparte | valor bajo |

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `BASE_PEQUENA_U` | (no existía) | `5` | `35_motor_template.html` | decisión de base pequeña |
| `PERIODO_CORRIDA` | `"2026-07"` fijo | `format(FECHA_CORRIDA, "%Y-%m")` | `36_exponer_contrato_contexto.R` | D-2 de s33q y s33r |
| `DIRS_EXCLUIR` | `.git, renv, .Rproj.user` | + `node_modules, packrat, venv, .quarto` | `00_escanear_proyecto.R` | E-1, E-2 |
| `HASH_ESPERADO` | (no existía) | `eb4e00b3…4dc4` | `tests/verificar_motor.R` | verificador versionado |
| `SEMILLA_ANCLAS` | (no existía) | `20260925L` | `tests/verificar_motor_helpers.R` | celdas ancla deterministas |

Fuente canónica de las vigentes: `10_utils/10_configuracion.R` y el `:root` de la plantilla (md5 `04b2876e…`, sin cambios en la sesión).

## 10. Arquitectura de archivos

El escáner se regenera en este cierre. Cambios estructurales: `tests/` gana dos scripts; `10_utils/` gana tres librerías JS; `30_procesamiento/36_exponer_contrato_contexto.R`, `40_salidas/publico/contexto_idps.parquet` y `50_documentacion/activa/contrato_contexto_v1.md` entran a `main`; marcador de ordenación creado; 20 encargos en `activa/encargos/` y 21 logs en `andamios/logs/`. Fuera de git: `_archivo/cola_s33/` con copias de trabajo del asistente (ignorado). El gatillo de ordenación (4bis) queda apagado.

## 11. Pendientes y ruta sugerida

**Inventario**

| # | Pendiente | Tipo | Impacto | Dependencias | Complejidad | Criterio de éxito |
|---|---|---|---|---|---|---|
| 1 | Validación en terreno de lo publicado: SVG y PNG en PowerPoint o Illustrator, CSV en Excel, sitio en Windows, impresión real del comparador, Atrás tras desplazarse (D-5 s33u) | validación | medio | ninguna | baja | Las siete dudas de la compuerta de abajo, medidas en equipos del Área |
| 2 | Estándar de motores en `herramientas_dev` (sesión BIBLIOTECA): matriz de s33n como insumo, dudas D-05, D-13 y D-21, y las convenciones nuevas de §7 (headless, pantalla idéntica con reintento, defecto reparable frente a cambio de diseño, clon tras medianoche, verificador versionado, porcelain del hermano en FASE 0) | documentación | alto | ninguna | media | Documento de estándar y plantilla de encargos actualizados en el kit |
| 3 | Alineamiento de `slep_simce_adecuado` con los patrones (como el de Categoría, encargos a1 a a10 en su repo) | deuda técnica (otro repo) | medio | 2 recomendable | media | Encargo de alineamiento corrido en simce, con plan por clase |
| 4 | P-CTX-4 en `slep_minuta_buenas_senales` (integrar el contexto) | funcionalidad (otro repo) | medio | simce integra su rama de contexto | media | La minuta muestra la señal de contexto de IDPS según `contrato_contexto_v1.md` |
| 5 | Selección en la dirección (territorio, establecimiento, entidades) | funcionalidad | bajo | ninguna | media | Un enlace reproduce la selección además de la vista |
| 6 | Ramas integradas que siguen en GitHub (`ordenacion/20260925`, `feat/contrato-contexto-v2`) y rama local vieja `feat/contrato-contexto` | limpieza | bajo | ninguna | baja | `git ls-remote origin 'refs/heads/*'` solo muestra `main` y las ramas vivas |
| 7 | Nombres con tildes en 4 archivos de `andamios/diseno/` | deuda heredada | bajo | `andamios/` congelado | baja | Excepción declarada o archivos archivados |

**Evaluación de deuda técnica.** La zona frágil sigue siendo la redacción de los encargos: 14 errores del asistente, 5 por describir la estructura del motor o de una rama sin leerla (PAT-01), 6 por criterios que medían un proxy (PAT-13) y 3 por restricciones leídas que no llegaron al diseño (PAT-07) (fuente: conteo por `awk` sobre el registro, en esta sesión). En el código, el trazado único de la barra concentra ahora la lógica de pantalla e imagen: todo cambio a `StackedBar` pasa por `trazarBarra` o rompe la garantía de no divergir.

**Auditoría de cierre (POLITICA 5.6).** ¿Repositorio publicado y sincronizado? Sí (`main` = `origin/main` = `44efae7`; fuente: `.git/refs`). ¿El artefacto desplegado corresponde al código? Sí (md5 `c5542b20…` en motor, `docs/` y sitio; fuente: `openssl md5` y `curl`). ¿Decisiones de peso como archivo? Sí (dos nuevas y dos enmiendas). ¿Cifras medidas en la sesión? Sí (logs y verificador). ¿Trabajo sin commitear? No (fuente: `git status --porcelain` vacío). ¿Escáner al día? No: se regenera en este cierre. ¿Pipeline corre de cero? Sí (`run_all()` en s33u). ¿Guarda de locale? Sí (`50_locale_utf8.md` presente). ¿Nombres sin tildes ni espacios? No en 4 archivos de `andamios/diseno/` (pendiente 7).

**Salida de la compuerta de dudas (2.1): 7 registradas.**

| supuesto | predicado | medicion |
|---|---|---|
| El SVG exportado se abre bien fuera del navegador | El SVG del comparador y del panorama abre en PowerPoint con colores y textos completos | Abrir `/tmp/s33t_muestra/*.svg` o una exportación del sitio en PowerPoint |
| El PNG exportado sirve para una presentación | El PNG del panorama se lee sin pixelado a pantalla completa | Insertarlo en una diapositiva y proyectarlo |
| La impresión de 12 hojas es legible en papel | Colores y etiquetas del comparador se leen en una impresora del Área | Imprimir el comparador de 10 entidades |
| Atrás funciona tras desplazarse | Tras bajar por el panorama, abrir una tarjeta y pulsar Atrás, vuelve al panorama | Probarlo en el sitio publicado |
| Excel en español abre bien los CSV | Columnas separadas y tildes correctas en el CSV del comparador y del histórico | Abrir ambos CSV en un equipo del Área |
| Con Windows y sus fuentes nada desborda | A ancho de celular, ninguna celda ni fila del modal se sale | Abrir el sitio en un equipo Windows |
| El verificador corre en Windows | `Rscript tests/verificar_motor.R` da rc = 0 | Correrlo en la estación Windows |

**Ruta sugerida para la próxima sesión** (criterios de 1.2.4):

1. **Pendiente 1 (validación en terreno):** es barata y es lo único que puede mostrar un defecto en lo que ya está publicado.
2. **Pendiente 2 (sesión BIBLIOTECA):** lleva al kit las convenciones de esta sesión antes de que los hermanos corran más encargos sin ellas.
3. **Pendiente 3 (simce):** con el estándar escrito.

Conviene diferir: selección en la dirección (5) hasta que el equipo la pida.

## 12. Instrucciones específicas para la próxima sesión

- ✅ **PRIMERO**: correr `/apertura` y pegar su eco.
- ⚠️ **NO** correr `git` que escriba sobre el repositorio desde fuera de Claude Code; el asistente lee `.git/refs` como archivo y, si usa git, con `GIT_OPTIONAL_LOCKS=0` y solo lectura.
- ⚠️ **NO** tocar un archivo versionado del repo mientras corre un encargo: su regla de porcelain lo detiene.
- ⚠️ **NO** describir en un encargo una clase, un texto o un componente sin `grep` o `sed` sobre la plantilla de **este** motor.
- ⚠️ **NO** abrir Chrome con ventana en un encargo largo: siempre headless.
- ✅ **ANTES** de desplegar, `Rscript tests/verificar_motor.R` con rc = 0 y pantalla idéntica con la convención de §7.3 (o gate visual del titular si la pantalla cambia a propósito).
- ✅ Lanzar cada encargo en una sesión limpia de Claude Code, con el estado de partida escrito en el propio encargo.
- 🔒 **Cero agregación:** el territorio acota la lista de establecimientos; jamás produce un puntaje propio.
- 🔒 **`sigdifgru` es la fuente del estado vs GSE**; donde es nulo se dice **"sin comparación válida"**.
- 🔒 **La paleta de ESTADO y la de INDICADOR no se tocan.**
- 🔒 **`trazarBarra` decide todo el trazado de la barra**; pantalla e imagen solo pintan.
- 🔒 **El motor no pide nada a la red.**

## 13. Fragmentos de código de referencia

```bash
# Verificación versionada del motor (PRUEBA c de los encargos desde s33u).
cd /Users/tomgc/Projects/slep_idps && Rscript tests/verificar_motor.R; echo "rc=$?"
```

```bash
# Lectura de git sin escribir en .git/ (lección del registro s33, fila 11).
GIT_OPTIONAL_LOCKS=0 git -C /Users/tomgc/Projects/slep_idps status --porcelain
```

Patrones estables: `CLAUDE.md` del proyecto (convención §8.2, Puppeteer por `NODE_PATH`, transpilación en el build).

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md y
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project y se lee
> desde ahí; no lo adjunto. Adjunto el traspaso `traspaso_cierre_v32.md`.
> Estado: `origin/main` = commit de cierre de v32, árbol limpio, sitio desplegado en
> `docs/index.html` (md5 `c5542b20…`), `tests/verificar_motor.R` en verde. Foco
> propuesto: validación en terreno de lo publicado (exportaciones SVG y PNG,
> impresión, CSV en Excel, Windows, Atrás tras desplazarse).

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `encargo_autonomo_claude_code_v1.md`.
2. *Opcionales según el foco:* `CLAUDE.md` si correrá en Claude Code; `50_documentacion/andamios/20260924_matriz_patrones_motores.md` si la sesión trabaja el estándar.
3. *Específicos (sí se adjuntan):* `traspaso_cierre_v32.md`. El asistente lee el repositorio por el puente de archivos.

**Nota final:** si alguno de estos archivos cambia entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente (POLITICA 0.5)

Los del redactor, con los diez campos (copia del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, 14 filas):

| # | momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Redacción del encargo s33, T5 paso 1 | ejecutor lo detectó en T5 (FASE R, A-1) | T5 exigía `git status --porcelain` vacío, inalcanzable por construcción: el propio encargo mandaba builds temporales en T1, T2 y T4 que dejan el motor modificado, y el LOG queda sin seguimiento hasta FASE L | `encargo_autonomo_claude_code_v1.md` §2.2 regla 1 y §2.6 (esperado alcanzable y calibrado); traspaso v31 §12 (✅ verificar que el caso difiere en lo que se mide) | Se copió el paso 1 del build de s32e sin releerlo contra las tareas de este mismo encargo, que ensucian el árbol a propósito | patrón de encargos / traspaso | PAT-07, restricción propia del encargo (builds temporales) no propagada al esperado de T5 | encargos-premisas: esperado de árbol vacío en una tarea precedida por builds temporales del mismo encargo | 0 | 1 advertencia del ejecutor; ningún cambio en el árbol |
| 2 | Redacción del encargo s33, T4 (regla CSS del respaldo) | ejecutor lo detectó en FASE R (A-2, re-derivación en navegador) | El encargo fijó textualmente `outline:2px solid var(--foco)` para `.ficha-name` sin medir el fondo del elemento: sobre la barra de la ficha (`--azul`) el anillo da 1,84:1, bajo el 3:1 de WCAG 2.2 (1.4.11) | SETTINGS §1.2.6 (fuente primaria de una estructura es su inspección) y traspaso v31 §6 bug 4 (antes de fijar un color sobre otro, se mide el contraste) | Se especificó el anillo por consistencia con las demás reglas `:focus-visible`, que viven sobre fondos claros, sin leer el fondo de la barra de la ficha | SETTINGS / traspaso | PAT-01, estilo visual especificado sin inspeccionar el fondo sobre el que se dibuja | afirmar-sin-leer: regla de color fijada en un encargo sin medir el contraste contra el fondo real del elemento | 0 | anillo poco visible en el build `5a83f63c…`; 1 duda (A-2) al titular; exige un encargo de corrección antes del despliegue |
| 3 | Redacción del encargo s33c, testigo de T6 | ejecutor lo detectó en T6 (gate por pregunta al titular) | El testigo del despliegue (`grep -c 'en el directorio'` = 0 en `docs/index.html`) no se cumplía: la frase ya existía en un comentario del código publicado (docs 1, motor 3) | traspaso v31 §12 (✅ ANTES de fijar el esperado de un caso malo, verificar que difiere en la magnitud que se mide) y `encargo_autonomo_claude_code_v1.md` §2.6 (calibración contra un caso bueno y uno malo) | Se eligió la cadena del testigo por el texto nuevo sin medir su ausencia en `docs/index.html` antes de escribir el esperado | traspaso / patrón de encargos | PAT-13, testigo que mide una cadena (proxy) sin calibrarla contra el artefacto publicado | encargos-premisas: testigo de despliegue fijado sin `grep -c` previo sobre `docs/index.html` | 0 | 1 gate del ejecutor al titular; ningún cambio en el árbol |
| 4 | Redacción del encargo s33c, 🔒6 frente a T1 y T2 | ejecutor lo detectó en FASE 0/M5 (A-1, lectura fijada antes de tocar la plantilla) | 🔒6 exigía que "los números no cambien" en filas y chips, mientras T1 y T2 del mismo encargo mandaban agregar textos con dígitos (nivel y año en el chip; año de traspaso en la fila SLEP) | `encargo_autonomo_claude_code_v1.md` §2.4 (invariante con veredicto interpretable) y §2.10; traspaso v31 §12 (⚠️ un 🔒 no mide lo que una tarea del mismo encargo edita) | Se redactó el 🔒 por su intención (ninguna cifra nueva) sin releerlo contra las tareas que agregan etiquetas con dígitos | patrón de encargos / traspaso | PAT-07, restricción propia (T1 y T2 agregan dígitos) no propagada al 🔒6 | restriccion-no-propagada: invariante sobre números visibles en un encargo que agrega etiquetas numéricas | 0 | 1 decisión autónoma del ejecutor (lectura de 🔒6); ningún cambio en el árbol |
| 5 | Redacción del encargo s33e, T1 (pestaña enfocada) | ejecutor lo detectó en T1 (congelada por la regla 7, D-1) | T1 pedía que `scrollIntoView` dejara entera la pestaña enfocada a 320 px, imposible por construcción: la pestaña mide 335 px y la barra 296 px, cifras que el log s33d (A-2) ya traía | SETTINGS §1.2.6 (fuente primaria antes de especificar) y `encargo_autonomo_claude_code_v1.md` §2.2 regla 1 (premisa medida) | Se diseñó el remedio desde el síntoma ("queda parcialmente oculta") sin propagar al diseño las dos medidas del mismo hallazgo que hacían inviable el remedio | log s33d / patrón de encargos | PAT-07, medida leída (335 > 296) no propagada al diseño de T1 | restriccion-no-propagada: remedio de desplazamiento para un elemento más ancho que su contenedor, con las dos medidas ya registradas | 0 | 1 tarea congelada; ningún cambio en el árbol |
| 6 | Redacción del encargo s33c, T1 y T2 (textos más largos en la fila SLEP del comparador) | usuario lo señaló sin nombrarlo error, en el gate visual con capturas | El encargo alargó el `sub` de las filas ("Traspaso AAAA · … en el directorio") sin ningún criterio de ancho: con `.check-region{flex:0 0 auto}` la fila supera el ancho de la lista, aparece scroll horizontal, el nombre se parte y el fondo de la fila marcada no llega al borde | `encargo_autonomo_claude_code_v1.md` §2.6 (criterio que mide el riesgo: un cambio de texto visible se verifica también por su efecto en el diseño) y SETTINGS §1.2.6 (inspeccionar la estructura antes de escribir contra ella) | Se especificó el contenido nuevo sin leer la regla CSS que decide cómo se reparte el ancho de la fila, y la verificación de T1/T2 solo comparó textos y cifras | patrón de encargos | PAT-13, verificación de un cambio de texto por su contenido (proxy) y no por su efecto en la fila (riesgo) | otro: texto alargado en un contenedor flexible sin medir `scrollWidth` frente a `clientWidth` | 0 | 1 gate visual del titular fallido; un encargo de corrección antes del despliegue |
| 7 | Redacción del encargo s33j, T2 (publicar `feat/contrato-contexto`) | ejecutor lo detectó en T2 (el hook `pre-push` rechazó el push; D-1) | La premisa listó los tres commits de la rama pero no sus archivos: uno agrega `40_salidas/publico/contexto_idps.parquet`, que no está en la lista de datos autorizados, y el hook de la cartera lo bloqueó | SETTINGS §1.2.6 (fuente primaria: inspección, no descripción) y POLITICA §6 (gobernanza de datos versionados, invariante I8) | Se describió la rama por los mensajes de sus commits (`.git/logs`) en vez de inspeccionar su diff contra `main`, y no se cruzó con la lista de datos autorizados ni con el precedente del hermano, que tuvo que autorizar su propio parquet de contexto | SETTINGS / POLITICA | PAT-01, premisa de un encargo escrita desde una descripción (mensajes de commit) y no desde la inspección del contenido | afirmar-sin-leer: rama a publicar descrita sin `git diff --stat main..rama` | 0 | 1 tarea congelada; ningún cambio en el árbol |
| 8 | Redacción del encargo s33l, M3 y regla 4 (contenido de `feat/contrato-contexto`) | ejecutor lo detectó en FASE 0 (M3 con `..` frente a `...`, y hallazgo H-1 de los normativos) | M3 pedía `git diff main..feat/contrato-contexto`, que compara con el `main` de hoy y lista 26 archivos de datos que no son de la rama; y el encargo no previó que la rama versiona y modifica los normativos que `main` retiró del repositorio público en `a9d8ac8` | `encargo_autonomo_claude_code_v1.md` §2.6 (el criterio mide el riesgo) y SETTINGS §1.2.6 (inspección antes de escribir contra una estructura) | Se repitió el error de la fila 7: se escribió el encargo sin inspeccionar `git diff --stat main...rama` (lo que la rama agrega), y el comando elegido medía la divergencia de `main` en vez del aporte de la rama | registro s33 (fila 7) / patrón de encargos | PAT-13, comando de premisa que mide la divergencia de la base (proxy) y no lo que la rama agrega (riesgo) | encargos-premisas: diff de dos puntos para describir el contenido de una rama | 1 (fila 7, mismo objetivo: describir la rama sin inspeccionarla) | 1 tarea congelada; ningún cambio en el árbol |
| 9 | Redacción del encargo s33m, premisa de T2 (tecnología de los gráficos) | ejecutor lo detectó en FASE 0/M5 (H-1) | La premisa decía que el radar es el único SVG del motor y que el comparador y el panorama tienen "barra de puntaje"; hay SVG en cada tarjeta del panorama y una capa SVG en `BarrasAnio`, y ninguna de las dos pantallas tiene barra de puntaje | SETTINGS §1.2.6 (marcador de fuente: una premisa se funda en el archivo leído, no en una descripción) | La premisa se tomó de una frase del CLAUDE.md sobre la exportación de s30 ("único SVG del motor") sin un `grep -c '<svg'` sobre la plantilla, que el redactor tenía a mano | CLAUDE.md / SETTINGS | PAT-01, premisa escrita desde una descripción secundaria teniendo la fuente primaria disponible | afirmar-sin-leer: premisa sobre la estructura del motor sin `grep` sobre la plantilla | 0 | ninguno en el árbol; la premisa quedó corregida por M5 antes de redactar el diagnóstico |
| 10 | Redacción del encargo s33n, regla 3 y 🔒1 (hermanos intactos) | ejecutor lo detectó en FASE 0 (gate al titular) | La regla 3 detenía la sesión ante cualquier cambio de md5 en un hermano, sin prever que `slep_simce_adecuado` tenía una sesión propia activa (s35) que commitea mientras corre la matriz: el invariante medía "el archivo no cambió" (proxy) y no "este encargo no escribió" (riesgo) | `encargo_autonomo_claude_code_v1.md` §2.6 (el criterio mide el riesgo) y SETTINGS §1.2.6 (ningún comando asume el entorno) | Se supuso que los hermanos estarían quietos durante la corrida, pese a saber por la fotografía de su apertura que el hermano tenía una sesión abierta | patrón de encargos / SETTINGS | PAT-13, invariante sobre md5 de un árbol ajeno y vivo en lugar de sobre la autoría de los cambios | comando-entorno: invariante de inmutabilidad sobre un repositorio con sesión activa de otra instancia | 0 | 1 gate del ejecutor; ningún cambio en el árbol |
| 11 | Redacción del encargo s33o, inspección del repositorio desde la VM del asistente | el asistente lo detectó en el momento (warning `unable to unlink .git/index.lock`) | Para preparar el encargo corrió `git status --porcelain` sobre el repositorio del titular desde su propia VM; git intentó refrescar el índice, creó `.git/index.lock` y no pudo borrarlo (la VM no tiene permiso de borrado), dejando un bloqueo que habría detenido el primer `git add` de Claude Code. Se movió a `_archivo/cola_s33/_to_delete/` antes de lanzar nada | Acuerdo con el titular: el asistente inspecciona el repositorio leyendo `.git/refs` como archivo, no corriendo git; SETTINGS §1.2.6 (ningún comando asume el entorno) | Se usó git como herramienta de lectura sin prever que `status` escribe en `.git/` y que la VM no puede deshacer esa escritura | SETTINGS / acuerdo de la sesión | PAT-13, comando de lectura que escribe como efecto lateral en un árbol ajeno | comando-entorno: `git status` sin `GIT_OPTIONAL_LOCKS=0` desde un entorno sin permiso de borrado | 0 | ninguno en el árbol; un bloqueo de índice retirado antes de lanzar el encargo |
| 12 | Redacción del encargo s33o, M5 (c), M6 y T3 (clase y texto del comparador) | ejecutor lo detectó en FASE 0 (A-1, A-2, D-6) | El encargo nombró `.table-wrap` y "Agregar territorio", que son la clase y el texto del comparador de `slep_simce_adecuado`; en `slep_idps` son `.cmp-tscroll` y "+ agregar entidad". El ejecutor midió los equivalentes | SETTINGS §1.2.6 (fuente primaria antes de especificar) | Se copiaron nombres de las re-derivaciones de la matriz de s33n (hechas sobre el hermano) y del diagnóstico de s33m sin un `grep -c` sobre la plantilla de `slep_idps`, que el redactor tenía abierta | registro s33 (fila 9) / patrón de encargos | PAT-01, premisa escrita desde una descripción secundaria teniendo la fuente primaria disponible | afirmar-sin-leer: selector o texto de interfaz citado sin `grep` sobre la plantilla del motor al que va el encargo | 1 (fila 9, mismo objetivo: estructura del motor sin grep) | 0 en el árbol; dos lecturas de FASE 0 fijadas por el ejecutor |
| 13 | Redacción de los encargos s33q, s33r y s33s, POSICIÓN (modo de Puppeteer) | usuario lo señaló sin nombrarlo error ("es muy disruptivo") | Los encargos no fijaron el modo de Chrome; el ejecutor abrió ventanas visibles durante mediciones de ~25 min, interrumpiendo el trabajo del titular en su equipo | SETTINGS §1.2.6 (ningún comando asume el entorno) y la preferencia de no cargar al titular con trabajo mecánico | Se copió la línea de POSICIÓN de encargos anteriores (que pedían "con ventana y headless" para gates puntuales) sin preguntarse qué costo tiene una ventana en una corrida larga sin gate visual | patrón de encargos | PAT-13, instrucción de entorno heredada sin revisar su efecto en el titular | comando-entorno: Puppeteer con ventana en una corrida autónoma larga | 0 | interrupción del trabajo del titular durante s33s; instrucción correctiva enviada a mitad de corrida |
| 14 | Redacción del encargo s33t, T2.2 (forma de la imagen histórica) | ejecutor lo detectó en T2 (A-5, D-1) | El encargo pidió "por cada GSE visible, una fila por año con su barra", pero la franja de la vista histórica es indicador × año; el ejecutor siguió la pantalla (regla de fidelidad) y dejó la diferencia como duda | SETTINGS §1.2.6 (fuente primaria antes de especificar) y la regla de fidelidad de s30 (la imagen dibuja lo que dibuja la pantalla) | Se describió la franja de memoria, sin leer `PanoramaHistorico` en la plantilla que el redactor tenía abierta | registro s33 (filas 9 y 12) / patrón de encargos | PAT-01, estructura de pantalla descrita sin leer el componente | afirmar-sin-leer: forma de un gráfico especificada sin `sed` sobre su componente | 2 (filas 9 y 12, mismo objetivo: estructura del motor sin leerla) | 0 en el producto; una duda al titular |

**Lectura:** 6 de 14 son PAT-13 y 5 son PAT-01 (fuente: conteo por `awk` sobre el registro, en esta sesión). El patrón dominante cambió respecto de v31: ya no es solo el invariante mal calibrado, sino describir la estructura del motor, de una rama o de un hermano desde una descripción secundaria (mensajes de commit, CLAUDE.md, la matriz, la memoria) teniendo la fuente primaria abierta (filas 7, 8, 9, 12 y 14). La salvaguarda que falta es de forma (§2.2.16): toda premisa de un encargo que nombre una clase, un texto, un componente o el contenido de una rama lleva en la misma línea el comando que la midió en el turno de redacción. La fila 11 (índice bloqueado) y la 13 (Chrome con ventana) son de entorno (PAT-13): la lección quedó en §7.1 y §7.2.

**Del ejecutor (Claude Code):** registrados en la sección "Errores propios" de cada log; todos de instrumento o de redacción del log, ninguno cambió un criterio ni una cifra. En s33s, la regla 6 disparó por un defecto de implementación (nodos de texto) que se reparó con decisión del titular.

## 16. Fricciones (2.2.17)

- friccion: Chrome abría ventanas durante los encargos largos e interrumpía el trabajo del titular → todo Puppeteer en headless desde s33s.
- friccion: el titular pegó dos veces el mismo reporte (s33t) → el asistente confirmó que ya estaba leído, sin repetir la verificación.
- friccion: la sesión se hizo muy larga (20 encargos en tres días) → cierre propuesto al pasar el trabajo a otros repositorios; conviene cerrar tras cada bloque temático.
- friccion: el titular pidió contexto limpio por encargo para ahorrar tokens → encargos más chicos y autocontenidos desde s33r.
