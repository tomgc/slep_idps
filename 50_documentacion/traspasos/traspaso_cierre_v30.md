# Traspaso de cierre — slep_idps — v30 (sesión 31)

## 1. Identificación

- **Proyecto:** `slep_idps` — motor de comparación interactivo de los IDPS.
- **Versión del traspaso:** v30. **Fecha de cierre:** 2026-09-23.
- **Sesión cubierta:** **31**, con tres encargos autónomos (s31, s31b, s31c) y dos revisiones independientes del asistente entre ellos.
- **Foco:** correr la compuerta de repositorio que v29 dejó sin ejecutar, construir la vista histórica del panorama territorial (P-VISTA-TERRITORIAL) y corregir un defecto del motor publicado que afirmaba un estado que la Agencia no publica. Todo desplegado a GitHub Pages.
- **Entorno:** R 4.5.2 con `renv`; Positron; build `run_all(only = 35L)`. Las revisiones del asistente corrieron en su propio entorno, sobre copias del motor.
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (los tres encargos), `30_procesamiento/35_generar_motor_html.R` y `10_utils/10_configuracion.R` (calibración del color), `40_salidas/motor_idps.html` y `docs/index.html` (regenerados y desplegados), `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md` (nueva), tres encargos nuevos en `activa/encargos/`, tres logs de ejecución y el registro del asistente en `andamios/logs/`, y el mockup `andamios/diseno/detalles/mockup_vista_historica_territorial.html`.
- **Commits:** 19 entre `bc42fad` (apertura de sesión) y `c7ec7f9`, punta de `main` **previa al commit de cierre** (fuente: `git rev-list --count bc42fad..HEAD` y `git log --oneline` en esta sesión). Los hashes definitivos los agrega el eco del cierre.

## 2. Resumen ejecutivo

La sesión abrió con el bloqueante que v29 heredó: la compuerta de repositorio nunca se había ejecutado. Corrió y dio **9/9**, con lo que `cierre_incompleto` quedó saldado antes de tocar código. El foco siguiente, P-VISTA-TERRITORIAL, obligó a una decisión previa: el estado vs GSE solo existe en 2024 y 2025, así que la "serie de repartos por año" que pedía el traspaso v29 no se puede construir. Se adoptó en cambio una **matriz de establecimiento × año** con el puntaje propio de cada uno, calibrada por percentiles del país, más una franja de reparto en los años que sí traen estado. Al especificarla apareció un defecto del motor publicado: los establecimientos con puntaje pero **sin comparación publicada** se contaban como "sin diferencia", en desacuerdo con el CSV, que ya los marcaba aparte; se corrigieron las tres pantallas y el CSV ganó la columna `n_sin_comparacion`. Dos revisiones independientes del asistente (6 y 5 lentes, con refutación adversarial de cada hallazgo) encontraron siete defectos reales después de que el ejecutor declarara terminado, todos de rótulo, conteo de banner, ubicación o accesibilidad, y ninguno de cifra; se corrigieron en dos encargos cortos. El payload **no se movió** en toda la línea: mismo SHA-256 normalizado (`1e29c2b5…`) en los 19 commits, con un bloque nuevo de metadatos como única diferencia. El motor quedó publicado en `docs/index.html` (md5 `6c5feab5…`). Estado general: **publicado, verificado y documentado**.

## 3. Estado al cierre

**Qué funciona** (última ejecución: `run_all(only = 35L)` exit 0, 0 warnings; sitio desplegado en `d03aa5b`):

- Compuerta de repositorio **9/9** (primera corrida del proyecto bajo el régimen de nueve invariantes).
- Panorama territorial con selector **Vista actual / Vista histórica**. La histórica trae, por sección de GSE, la franja de estado de 2024 y 2025 y la matriz establecimiento × año del indicador elegido, con color calibrado y orden por el último año.
- El estado vs GSE nulo ya no se cuenta como "sin diferencia": queda fuera del 100 % de la barra, con la nota "+N sin comparación publicada", y el CSV del comparador trae `n_sin_comparacion`.
- La matriz entrega al lector de pantalla el estado de cada celda y el encabezado de fila; Enter y Espacio abren la ficha.
- Calibración del color en R (`meta.vista_territorial`): percentiles 5 y 95 del país por nivel e indicador, más los años con estado publicado.

**Qué no funciona / limitaciones conocidas:**

- Dos cadenas de conteo escritas a mano fuera del banner: el tab SLEP del modal del comparador ("SLEP Santiago Centro 1 comunas · 39 establecimientos") y el `title` del botón de exportación del panorama.
- Texto sobre colores de la paleta de INDICADOR (§5.6 de la decisión de contraste), pendiente de criterio del titular.
- `.cmp-table` es `table-layout:fixed` sin `min-width` (heredado de v29).
- El modal de territorio no es operable por teclado (preexistente).
- A anchos menores de 425 px la barra de pestañas desborda (preexistente, medido también en el motor anterior a esta sesión).

**Delta respecto de v29:** v29 cerró con el comparador de entidades, la línea de contraste y la exportación, y dejó la compuerta sin correr. Todo lo de arriba es nuevo.

**Compuerta de repositorio (2.1) — estado declarado.** Ejecutada al abrir: **9/9 PASA** (fuente: salida de `95_verificar_cierre.R` pegada por el titular el 2026-09-17). `I8` pasó con la lista de autorización que v29 dejó preparada (74 rutas de datos, 74 cubiertas) y `I9` con la ventana `./20_insumos`. `ESTADO.md` pasó a `cierre_incompleto: no` en `156b6ea`.

**Declaración de insumos (huella).** Producida por el verificador en su corrida del 2026-09-17:

| Entrada declarada | Entradas de primer nivel | `mtime` más reciente | Bytes (archivos de primer nivel) |
|---|---|---|---|
| `./20_insumos` | 34 (32 archivos + `auxiliares/` e `historico/`) | 2026-07-27 14:45 | 100,2M |

La huella es **completa**: el proyecto no lee ninguna fuente fuera de esa ventana. La diferencia con la tabla de v29 (que declaraba 2026-09-15 y 105.070.120 bytes) se explica porque aquella se midió con `find`/`stat` incluyendo archivos ocultos, y esta la produce el verificador; el conteo de entradas coincide.

## 4. Registro detallado de cambios

El detalle por fase, con sus comandos y salidas, vive en tres logs: `50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md`, `…_correcciones_revision_s31b_log.md` y `…_forma_y_despliegue_s31c_log.md`. Los bloques conceptualmente independientes:

1. **Compuerta de repositorio ejecutada** (`156b6ea`). Categoría: limpieza / deuda técnica. 9/9; `cierre_incompleto` saldado. Verificación: salida literal del verificador, con la huella de insumos.
2. **El estado nulo deja de contarse como "sin diferencia"** (`f2aecd5`). Categoría: saneamiento / calidad de datos de presentación. `repartoInd` separa `sin` de `neutro`; `StackedBar` muestra "+N sin comparación publicada"; `CeldaEE` y la tarjeta dejan de afirmar estado; el CSV suma `n_sin_comparacion`. Verificación: sección Medio del SLEP foco, 4° básico, Autoestima, pasó de "100 % = 28 con 17 sin diferencia" a "100 % = 26 con 15" más la nota de 2; el CSV coincide con la barra. Magnitud nacional: 900 establecimientos de 4° básico 2025 con al menos un indicador sin comparación, 892 sin ninguna.
3. **Calibración del color y años con estado, en R** (`68b4e43`). Categoría: pipeline / motor. `meta.vista_territorial` con `dominio_color` (percentiles 5 y 95 por nivel e indicador), `anios_estado` y `tinte_minimo`. Verificación: los ocho rangos recalculados de forma independiente coinciden; el payload sin el bloque da el mismo SHA-256 de siempre.
4. **Vista histórica del panorama territorial** (`b699466`, reparada en `ebf6090`). Categoría: visualización / diseño. Toggle, secciones por GSE vigente, franja de estado, matriz con selector de indicador, columna única para 2019–2021, orden por el último año y clic a la ficha.
5. **Correcciones de la primera revisión** (`09ea2de`, `d0614f3`, `bad2309`, `4c7179e`). Nota bajo su barra; banner que cuenta comunas del universo filtrado; rótulo de sección que nombra la regla aplicada; accesibilidad de la matriz.
6. **Correcciones de la segunda revisión y despliegue** (`2eb0908`, `58a37aa`, `b3a91e7`, `d03aa5b`). Plural del banner; rótulo anclado a su barra con `subgrid`; motor regenerado; `docs/index.html` publicado byte a byte.

## 5. Backlog acumulativo

Cuatro entradas nuevas (#157–160), en el bloque `BACKLOG_ENTRADAS` de este paquete. El detalle de qué no suma va en ese bloque.

## 6. Bugs de la sesión

1. **El estado vs GSE nulo se contaba como "sin diferencia".** Síntoma: la barra del panorama decía "100 % = 28" con 17 "sin diferencia" donde el dato publicado eran 26 con 15; el CSV de la misma celda decía "sin comparación vs GSE publicada". Causa raíz: `repartoInd` mandaba al segmento `neutro` todo `sigdifgru` distinto de ±1, incluido el nulo (`35_motor_template.html`, L896 de la versión de v29). Solución: `sin` como cuarto conteo, fuera del 100 %, con nota propia. Verificación: 900 establecimientos nacionales afectados en 4° básico 2025, 2 en el SLEP foco; barra y CSV coinciden tras el fix. **Patrón aprendido:** una ausencia no es un valor; cuando el dato no viene, la pantalla dice que no viene. Estado: resuelto.
2. **El banner de la vista histórica mezclaba universos.** Síntoma: "346 comunas · 555 establecimientos" con un solo GSE encendido, cuando esos 555 viven en 96 comunas. Causa raíz: el universo del banner no aplicaba el filtro de GSE que sí aplicaba el conteo de establecimientos; fue una reparación a medias de la propia sesión (R-25), verificada solo con los cinco grupos encendidos. Solución: una sola expresión alimenta ambos conteos. Verificación: 16 combinaciones de GSE en cuatro territorios. **Patrón:** una reparación verificada solo en el caso completo no está verificada; el caso que la motivó es el filtrado. Estado: resuelto.
3. **La nota "+N sin comparación publicada" caía en la columna del rótulo.** Causa raíz: `StackedBar` devolvía un fragmento cuyos hijos entraban como celdas del grid. Solución: contenedor propio. Verificación: desplazamiento 0 px en los cuatro indicadores. Estado: resuelto.
4. **El rótulo del indicador quedó descentrado tras el arreglo anterior.** Causa raíz: el rótulo pasó a centrarse en el bloque barra + nota. Solución: `grid-template-rows: subgrid`, tras descartar dos mecánicas que no llegaban a 0 px con rótulos de dos renglones. Verificación: 0 px en las filas con nota y en las filas sin nota. Estado: resuelto.

## 7. Aprendizajes y restricciones descubiertas

1. **Antes de aceptar el criterio de éxito que trae un traspaso, hay que comprobar que el dato lo permite.** v29 pedía una serie de repartos por año; `sigdifgru` solo existe en 2024 y 2025. El criterio se rehízo antes de especificar nada, no después.
2. **Una revisión independiente después del "terminado" encuentra cosas.** Dos revisiones sobre trabajo ya declarado completo y auditado por su propio ejecutor dejaron siete defectos reales (y 19 descartados por refutación). Ninguno era de cifra, todos eran visibles en pantalla.
3. **Un invariante heredado se relee contra el alcance nuevo.** El encargo de despliegue arrastró un 🔒 que decía "`docs/` intacto" mientras su propia tarea escribía en `docs/`.
4. **Un criterio de verificación debe distinguir el build nuevo del viejo.** El traspaso verificaba el despliegue buscando "Exportar CSV", cadena presente en los dos motores.
5. **El color de un mapa de calor se calibra al dato, no al rango teórico.** Con la escala 0–100 todas las celdas se veían iguales; con los percentiles 5 y 95 del país el mapa distingue, y el rango viaja en el payload para que sea el mismo en cualquier territorio.
6. **`git status` no es de solo lectura.** Corrido desde un shell sin permiso de borrado deja un `.git/index.lock` que bloquea los commits del titular.

## 8. Decisiones de diseño

Replicada como archivo: `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md` (diez reglas de la vista histórica, la calibración del color, la regla de contraste del texto y, en su §6, el tratamiento del estado sin comparación publicada).

Otras, con su alternativa descartada:

| Decisión | Alternativa descartada | Motivo |
|---|---|---|
| Matriz establecimiento × año | serie de repartos por año | el estado solo existe en 2024–2025; serían dos barras |
| Color calibrado a percentiles 5 y 95 del país | escala 0 a 100 | con la escala completa el mapa no distinguía nada |
| Los sin comparación, fuera de la barra | cuarto segmento rayado dentro del 100 % | agregaba una trama nueva a la codificación de estado |
| Agrupar por el GSE del último año con GSE publicado | por el GSE del último año con resultado | 46 de 61 establecimientos del SLEP cambiaron de GSE en la serie |
| Color del texto por contraste entre negro, gris y blanco | número sobre pastilla blanca | la pastilla se veía mal y rompía el mapa de calor |
| Rótulo anclado con `subgrid` | `align-items:start` o `min-height` | ninguna daba 0 px con rótulos de dos renglones |
| Despliegue verificado con "sin comparación publicada" | "Exportar CSV" | esa cadena existe también en el motor viejo |

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `VT_PERCENTILES_COLOR` | (no existía) | `c(inf = 0.05, sup = 0.95)` | `10_utils/10_configuracion.R` | rango de calibración del color de la matriz |
| `VT_TINTE_MINIMO` | (no existía) | `0.06` | íd. | una celda con dato nunca queda blanca como una sin dato |

Rangos calibrados que produce hoy el pipeline (4b: 65–84, 66–87, 67–90, 60–82; 2m: 68–81, 67–84, 68–86, 61–79). Fuente canónica de las vigentes: `10_utils/10_configuracion.R` y el `:root` de la plantilla. Las paletas de ESTADO y de INDICADOR **no se tocaron**.

## 10. Arquitectura de archivos

El escáner se regenera en este cierre (`00_escanear_proyecto.R`); su salida es la referencia. Cambios estructurales: tres encargos nuevos en `activa/encargos/`, una decisión nueva en `activa/decisiones/`, tres logs y un registro del asistente en `andamios/logs/`, y un mockup en `andamios/diseno/detalles/`. Sin movimientos de carpetas. El gatillo de ordenación del repositorio (§1.2.2 punto 4bis) sigue encendido: no existe `50_documentacion/activa/50_ordenacion_repositorio.md`, aunque `traspasos/` ya cumple la regla 1.3.1 con un solo archivo vigente.

## 11. Pendientes y ruta sugerida

**Inventario**

| # | Pendiente | Tipo | Impacto | Complejidad | Criterio de éxito |
|---|---|---|---|---|---|
| 1 | Dos cadenas de conteo a mano: `sub` de los SLEP en el modal del comparador y `title` del botón de exportación del panorama | cosmética | bajo | baja | 0 ocurrencias de "1 comunas" y "1 establecimientos" en cualquier pantalla y tooltip |
| 2 | Enmendar la decisión §3.5: el piso real de la rampa de color es 4,58:1 | documentación | bajo | baja | La decisión dice el piso de la rampa y el mínimo realizado, con su medición |
| 3 | Cambiar en el traspaso el criterio de verificación del despliegue | documentación | medio | baja | El criterio usa "sin comparación publicada" (o `vt-mx`), que no existe en el motor viejo |
| 4 | Teclado en el modal de territorio (`.check-row` sin `role` ni `tabindex`) | deuda técnica | medio | baja | Con Tab y Enter se elige un territorio sin mouse |
| 5 | **§5.6**: regla para el texto sobre colores de la paleta de INDICADOR | deuda técnica | medio | media | `.defn-title`, etiqueta de `DistBar` y vista histórica de la ficha ≥ 4,5, sin tocar la paleta |
| 6 | `.cmp-table` `table-layout:fixed` sin `min-width` | deuda técnica | medio | baja | A 430px la tabla hace scroll en `.cmp-tscroll` en vez de comprimir a 43px |
| 7 | Exportación CSV de la vista histórica | funcionalidad | medio | media | El CSV trae una fila por establecimiento × año con su puntaje y su estado |
| 8 | `n_con_dato` del CSV del comparador: ¿renombrar a `n_con_comparacion`? (D-1 de s31) | decisión | bajo | baja | Decidido y escrito; si se renombra, el cambio se anuncia en el traspaso |
| 9 | Chip "· sin comparación publicada" de la tarjeta (D-3 de s31) | decisión | bajo | baja | Confirmado o retirado con razón escrita |
| 10 | Marca de base pequeña | mejora visual | medio | baja | Umbral de N fijado por el titular y escrito en una decisión |
| 11 | P-EXPORTACION-IMAGEN: exportar imagen del comparador y del panorama | funcionalidad | medio | alta | La imagen la produce el mismo dibujante que pinta la pantalla |
| 12 | Desborde de la barra de pestañas bajo 425 px (preexistente) | deuda técnica | bajo | baja | A 390 px, `scrollWidth` = `innerWidth` |
| 13 | Desmarcar entidades desde el modal al llegar al tope | bug de interacción | bajo | baja | Con 10 de 10, se puede quitar una entidad sin cerrar el modal |
| 14 | `renv` out-of-sync: `suitedoc` | deuda heredada | bajo | baja | `renv::status()` limpio, o `.renvignore` con la razón escrita |
| 15 | Rama `feat/contrato-contexto` (2 commits sin push desde el 2026-07-11) | decisión | bajo | baja | Publicada, integrada o descartada con razón |
| 16 | Tooltip "vs evaluación anterior": de `title` a body | mejora visual | bajo | baja | heredado de s28 |
| 17 | Trece divergencias del modal con el hermano (log s29 §36.7) | deuda técnica | bajo | media | Las tres que son deuda resueltas |
| 18 | Ordenación del repositorio (gatillo 4bis, sin `50_ordenacion_repositorio.md`) | deuda heredada | bajo | media | El marcador existe y el árbol cumple la política v5.5 |

**Evaluación de deuda técnica.** Zona frágil principal: la tabla del comparador, que comprime en vez de hacer scroll (pendiente 6) y sigue siendo la causa de fondo de dos síntomas parcheados. Segunda: los rótulos con cifras escritas a mano, que ya produjeron dos defectos de plural en dos sesiones distintas; conviene que todo conteo visible pase por el ayudante que ya existe.

**Auditoría de cierre (POLITICA 5.6).** ¿El repositorio está publicado y sincronizado? Sí (`origin/main == HEAD == c7ec7f9`, medido en esta sesión). ¿El artefacto desplegado corresponde al código? Sí (`docs/index.html` y el motor con el mismo md5 `6c5feab5…`). ¿Las decisiones de peso están como archivo? Sí. ¿Las cifras comunicadas se midieron en la sesión? Sí. ¿Hay trabajo sin commitear? No. ¿El escáner está al día? **No** — se regenera en este cierre. ¿El pipeline corre de cero sin intervención manual? Sí (`run_all(only = 35L)`, exit 0, 0 warnings). ¿La guarda de locale sigue instalada? Sí (`50_locale_utf8.md` presente; 3 archivos de `10_utils` la invocan). ¿Nombres sin tildes ni espacios? Sí.

**Salida de la compuerta de dudas (2.1): 4 registradas.**

| supuesto | predicado | medicion |
|---|---|---|
| El sitio público ya sirve el build de esta sesión | `docs/index.html` servido por GitHub Pages contiene la cadena "sin comparación publicada" | Abrir la URL con recarga forzada y buscar la cadena; o revisar Actions del repositorio |
| La vista histórica rinde en un territorio grande en los equipos del Área | Abrir Región Metropolitana en 4° básico y alternar indicador demora menos de 1 segundo | Abrirla en una máquina del equipo y cronometrar la interacción |
| El anclaje con `subgrid` se ve igual en los navegadores del equipo | El rótulo del indicador queda a 0 px del centro de su barra en la sección Medio | Abrir el sitio en un equipo del Área y comparar con la captura del cierre |
| El CSV del comparador con la columna nueva abre en columnas en el Excel del equipo | Excel en español separa el archivo sin asistente de importación y muestra `n_sin_comparacion` | Abrir `idps_comparador_*.csv` en el Excel de una máquina del equipo |

**Ruta sugerida para la próxima sesión** (criterios de 1.2.4):

1. **Los cuatro pendientes menores 1 a 4** (cadenas a mano, enmienda de §3.5, criterio del despliegue y teclado del modal). Son baratos, cierran lo que esta sesión dejó anotado y el primero es del mismo tipo que dos defectos ya corregidos.
2. **Pendiente 6** (`min-width` de la tabla del comparador). Corta de raíz lo que se ha parcheado dos veces por síntomas.
3. **§5.6** (pendiente 5), que necesita criterio del titular antes de cualquier encargo.

Conviene diferir: la exportación de la vista histórica (pendiente 7) hasta ver si el equipo la pide; la exportación de imagen (11) y las divergencias del modal (17).

## 12. Instrucciones específicas para la próxima sesión

- ✅ **PRIMERO**: correr `/apertura` y pegar su eco. La compuerta de repositorio quedó en 9/9 y `cierre_incompleto: no`, así que el candado debería pasar.
- ⚠️ **NO** dejar que un shell externo corra `git status` sobre el repositorio: crea `.git/index.lock` y bloquea los commits.
- ⚠️ **NO** copiar los invariantes 🔒 de un encargo al siguiente sin releerlos contra el alcance nuevo.
- ⚠️ **NO** verificar un despliegue con una cadena que también existe en el motor anterior.
- ✅ **ANTES** de dar por buena una reparación, verificarla en el caso que la motivó, no solo en el caso completo.
- ✅ **ANTES** de aceptar el criterio de éxito de un pendiente, comprobar que el dato lo permite.
- 🔒 **Cero agregación:** el territorio acota la lista de establecimientos; jamás produce un puntaje propio.
- 🔒 **`sigdifgru` es la fuente del estado vs GSE**, y donde es nulo no se afirma ningún estado: se dice "sin comparación publicada".
- 🔒 **La paleta de ESTADO y la de INDICADOR no se tocan.** El color de la matriz es una mezcla hacia blanco del color del indicador, con el rango que calcula R.

## 13. Fragmentos de código de referencia

```r
# Calibracion del color: percentiles del pais sobre los MISMOS valores que viajan
# en el payload (prom redondeado), por nivel e indicador. El template solo pinta.
rangos <- stats::quantile(x, VT_PERCENTILES_COLOR, type = 7, names = FALSE) |> round()
```

```js
// Color del texto de una celda: el de mayor contraste WCAG entre negro, gris y
// blanco. No se usa el umbral de luminancia de _txtOn: ahi el valle de contraste
// del azul de Autoestima deja el texto bajo 4,5:1.
const txtSobre = bg => TXT.reduce((m, c) => cr(bg, c) > cr(bg, m) ? c : m);
```

```js
// El estado se LEE. Una ausencia no es un valor: sale del 100% y se declara aparte.
if (d && d.prom != null) { if (d.sigdifgru === -1) bajo++; else if (d.sigdifgru === 1) sobre++;
  else if (d.sigdifgru === 0) neutro++; else sin++; }
```

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md y
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project y se lee
> desde ahí; no lo adjunto. Adjunto el traspaso `traspaso_cierre_v30.md`.
> Estado: `origin/main = <commit_cierre>`, árbol limpio, sitio desplegado en
> `docs/index.html` (md5 `6c5feab5…`). Foco propuesto: los cuatro pendientes menores
> que dejó la sesión 31 (cadenas de conteo a mano, enmienda de la decisión §3.5,
> criterio de verificación del despliegue y teclado del modal de territorio).

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según el foco:* `CLAUDE.md` si correrá en Claude Code.
3. *Específicos (sí se adjuntan):* `traspaso_cierre_v30.md`. Anotado como voluminoso pero crítico si se entra a implementar: `30_procesamiento/35_motor_template.html`. Referencia vinculante de interfaz, no se adjunta pero se cita por ruta: `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`.

**Nota final:** si alguno de estos archivos cambia entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente (POLITICA 0.5)

Los del redactor, con los diez campos:

| # | momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Medición previa a la compuerta, en la apertura | asistente lo señaló espontáneamente | Un `git status` corrido desde el shell remoto dejó un `.git/index.lock` vacío que ese shell no podía borrar | SETTINGS §1.2.6, "Ningún comando asume el entorno" | Se trató `git status` como comando de solo lectura; refresca el índice | SETTINGS | PAT-03, sobre un shell sin permiso de borrado | comando-entorno: git que escribe el índice en una carpeta montada sin permiso de borrado | 0 | 1 permiso de borrado pedido al titular; ocurrió dos veces |
| 2 | Redacción del encargo s31 | ejecutor lo refutó en T1 | La premisa "`alertSummary` no está afectada" era incompleta: la tarjeta sí afirmaba "≈ en su GSE" sobre 892 establecimientos sin ninguna comparación | SETTINGS §1.2.6, marcador de fuente: toda premisa de hecho de un encargo | Se leyó el conteo de la función, no lo que la tarjeta muestra con ese conteo | SETTINGS | PAT-01, sobre una premisa leída a medias | encargos-premisas: premisa sobre el efecto visible derivada de leer solo el cálculo | 0 | ninguno: el ejecutor lo corrigió dentro de T1 |
| 3 | Redacción del encargo s31c | ejecutor lo declaró como decisión autónoma | Las dos mecánicas que el encargo sugería para anclar el rótulo no alcanzaban el criterio con rótulos de dos renglones | `encargo_autonomo_claude_code_v1.md` §2.6, criterio calibrado | Se propuso la mecánica sin medir las alturas reales de los rótulos | patrón de encargos | PAT-13, precondición que mide un proxy y no el riesgo | iteracion-sin-criterio: solución sugerida sin medir el caso que debe cumplir | 0 | ninguno: el ejecutor encontró la mecánica correcta y lo declaró |
| 4 | Redacción del encargo s31c | ejecutor lo anotó en FASE R | El encargo heredó el invariante 🔒6 ("`docs/` intacto") mientras su propia T4 despliega a `docs/` | `encargo_autonomo_claude_code_v1.md` §2.4, invariante con veredicto interpretable | Los invariantes se copiaron en bloque sin releerlos contra el alcance nuevo | patrón de encargos | PAT-12, invariante heredado que contradice la tarea | restriccion-no-propagada: invariante copiado sin revisar contra el alcance | 0 | ninguno: el ejecutor lo leyó según la autorización y lo anotó |
| 5 | Redacción del paquete de cierre v30 | el instrumento de cierre lo detectó en F0.6 (BLOQUEA) | `settings_version` se transcribió de la copia de `activa/` del repositorio (v37) sin contrastarla con el kit, que desde el 2026-09-19 está en v38 | `cierre_sesion_autonomo_cc_v15.md` F0.6: la traza compara contra la línea del kit sincronizado | Se tomó la copia del repositorio como fuente de la versión del protocolo, siendo el kit la fuente | instrumento de cierre | PAT-01, sobre una traza de gobernanza copiada de una réplica y no de su fuente | traza-gobernanza: campo de versión transcrito de una copia local sin contrastar el kit | 0 | 1 cierre detenido en F0 y reemitido; el árbol no se tocó |

**Del ejecutor (Claude Code):** 8 en s31, 4 en s31b y 5 en s31c, todos de instrumento (rutas, `cd` heredado, sondas de navegador mal armadas), ninguno tocó un `esperado:` ni costó más de un turno; el detalle está en la sección "Errores propios" de cada log.

**Reglas adoptadas a partir de estos errores:** (a) ningún shell externo corre `git` sobre el repositorio del titular; (b) una premisa sobre lo que la pantalla afirma se mide en la pantalla, no en la función que calcula; (c) los invariantes de un encargo se releen contra su propio alcance antes de enviarlo; (d) toda traza de versión del protocolo se toma del kit, no de la copia en `activa/`.

## 16. Fricciones (2.2.17)

- friccion: el primer mapa de calor usaba escala fija 60–90 y un verde leído como "bueno" → escala calibrada y del blanco al color de cada indicador.
- friccion: el número sobre una pastilla blanca dentro de la celda de color se vio mal → color del texto elegido por contraste.
- friccion: la escala absoluta de 0 a 100 no distinguía entre celdas → calibración por percentiles del país.
- friccion: la leyenda de puntaje quedaba desalineada y con marcas colgando → panel de dos columnas con "0 [barra] 100".
- friccion: el encabezado 2019–21 iba en vertical → horizontal en dos líneas.
- friccion: la línea `/effort` al inicio del mensaje para Claude Code rompe el pedido → el modo viaja solo dentro del encargo; contradice la regla 4 de §2.12 del patrón de encargos y corresponde enmendar el kit.
- friccion: entre revisión y revisión el titular quedó sin novedades por varios minutos → informar estado aunque no haya avance, sin esperar a que lo pida.
