# Traspaso de cierre — slep_idps — v31 (sesión 32)

## 1. Identificación

- **Proyecto:** `slep_idps` — motor de comparación interactivo de los IDPS.
- **Versión del traspaso:** v31. **Fecha de cierre:** 2026-09-23.
- **Sesión cubierta:** **32**, con siete encargos autónomos (s32, s32b, s32c, s32d, s32e, s32g) y un bloque dirigido (s32f), más cinco despliegues a `docs/`.
- **Foco:** los cuatro pendientes menores de s31, los resultados definitivos de IDPS 2025, y a continuación los pendientes de interfaz que el traspaso v30 dejaba en la ruta: tabla del comparador, foco del modal, rótulo del estado sin comparación y §5.6 de contraste.
- **Entorno:** R 4.5.2 con `renv`; Positron; build `run_all()` / `run_all(only = 35L)`. El asistente leyó el repositorio por el puente de archivos sin ejecutar `git`; Claude Code ejecutó todo lo que toca git.
- **Protocolo usado:** `POLITICA_PROYECTO.md` "> **Versión 5.8 — vigente.**" y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` "> **Versión 38.**" (fuente: knowledge base y `activa/`, encabezados leídos en esta sesión).
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html` (todos los encargos de interfaz); `30_procesamiento/32_censo_insumos.R` (hora del censo y banner); `20_insumos/` (definitivos 2025) con los preliminares archivados en `_archivo/20260923/`; `40_salidas/motor_idps.html` y `docs/index.html`; las decisiones `20260917_decision_vista_historica_territorial.md` (enmiendas §3.5 y s32f) y `20260910_decision_contraste_texto_estado.md` (§5.6 resuelta); siete encargos en `activa/encargos/`; siete logs más el registro del asistente en `andamios/logs/`; el mockup `andamios/diseno/detalles/mockup_contraste_paleta_indicador_s56.html`.
- **Commits:** entre `6117393` (apertura de sesión) y `9fc6f22`, punta de `main` **previa al commit de cierre** (fuente: `.git/refs/heads/main` leído en esta sesión y ecos de Claude Code). Los hashes definitivos los agrega el eco del cierre.
- **Registro de ejecución detallado:** los siete logs de `50_documentacion/andamios/logs/20260923_*` (detalle no reproducido aquí).

## 2. Resumen ejecutivo

La sesión abrió con los cuatro pendientes menores de s31 y los cerró todos: los conteos visibles pasan por un ayudante de plural (había 7 plurales fijos, no 3), las filas del modal se operan con teclado, la decisión §3.5 quedó enmendada con cifras re-medidas, y el criterio de verificación del despliegue ya estaba corregido en v30. A mitad de sesión el titular incorporó los resultados definitivos de IDPS 2025: reemplazaron a los preliminares en 4b, 2m y 8b sin alterar ningún año anterior, y el asterisco de 2025 desapareció (junto con las leyendas que lo explicaban sin condición). Después se recorrió la ruta de interfaz del traspaso: la tabla del comparador hace scroll en vez de comprimirse, el foco queda retenido dentro del modal y vuelve a su origen al cerrarlo, el estado vacío se rotula "sin comparación válida" (decisión del titular sobre el significado de `sigdifgru` nulo) y §5.6 de contraste quedó resuelta con la opción B elegida sobre un mockup. Todo quedó desplegado: `docs/index.html` = motor, md5 `4b28a03f…` (fuente: `md5sum` sobre ambos en esta sesión). El costo fue de redacción: el asistente cometió siete errores en los encargos, todos detectados por el ejecutor en un gate y ninguno con efecto en el árbol ni en las cifras. Estado general: **publicado, verificado y documentado**.

## 3. Estado al cierre

**Qué funciona** (última ejecución: `run_all(only = 35L)` exit 0, 0 warnings en s32g; `run_all()` completo deja el árbol limpio desde s32c; fuente: logs s32c y s32g):

- Datos IDPS 2025 definitivos en 4b, 2m y 8b; `anios_preliminar` vacío para los grados del motor; años distintos de 2025 idénticos (🔒1 de s32b: `identical()` TRUE sobre 1.770.628 filas; fuente: log s32b).
- Hash §8.2 del payload: `eb4e00b3…` desde s32b, igual en todos los builds posteriores (fuente: logs s32c a s32g).
- Todo conteo visible con plural concordante (`nEE`, `nCom`); 0 ocurrencias de "1 comunas" / "1 establecimientos" en el censo de s32.
- Modal de entidades: filas operables con Tab, Enter y Espacio; foco retenido en ciclo y devuelto al botón de origen en 10 de 10 vías de cierre (fuente: log s32e).
- Tabla del comparador con `min-width:810px` (W_min 150 px): a 430 px hace scroll y 0 de 80 celdas desbordan (fuente: eco del bloque W_min 150).
- Estado vacío rotulado "sin comparación válida"; CSV del comparador con `n_con_comparacion`.
- §5.6: título del indicador en tinta con filete del color (13,50 ×4); etiquetas de `DistBar` ≥ 4,74; glifos y tendencia ≥ 5,00; línea "vs GSE" del tooltip 13,50 (fuente: log s32g).
- `censo_insumos.md` sin hora de build: un `run_all()` sin cambios de insumos no ensucia el árbol.

**Qué no funciona / limitaciones conocidas:**

- Si el botón que abrió el modal desaparece (tope de 10 entidades, salto a la ficha), el foco queda en `body` (A-1 de s32e).
- `_txtOn` quedó sin uso (D-1 de s32g) y `const col` del tooltip quedó sin uso (A-3 de s32g; se conserva a propósito, ver §8).
- El encabezado de §5 de la decisión de contraste todavía dice "§5.6 abierto" (A-1 de s32g).
- Fila del SLEP en el modal (39, del directorio) y chip del comparador (24, del roster del nivel y año) dan cifras distintas para la misma entidad: divergencia heredada de s29i, no introducida en esta sesión.
- Preexistentes, sin cambios: desborde de la barra de pestañas bajo 425 px; marca de base pequeña sin umbral.

**Delta respecto de v30:** todo lo de arriba es nuevo salvo las dos últimas viñetas de limitaciones.

**Compuerta de repositorio (2.1) — estado declarado.** No se ejecutó dentro de la sesión; la corre el instrumento de cierre. La apertura pasó el candado 0bis 5/5 (fuente: eco de `/apertura`).

**Declaración de insumos (huella).** La produce el verificador en este cierre sobre `./20_insumos`. Cambio de la sesión que la afecta: 9 archivos de datos y 3 glosas `_final` de 2025 reemplazan a sus `_preliminar`, archivados con su md5 en `_archivo/20260923/20_insumos/` (fuente: `ls` y `find` en esta sesión: 0 preliminares 2025 en la ventana, 9 + 3 finales, 12 archivados). Los tres archivos de datos de 8° básico `_final` son byte-idénticos a sus preliminares; el titular confirmó que son los definitivos publicados por la Agencia.

## 4. Registro detallado de cambios

El detalle por fase, con comandos y salidas, vive en los logs `50_documentacion/andamios/logs/20260923_{conteos_teclado_enmienda_s32, teclado_territorio_definitivos_2025_s32b, leyendas_censo_despliegue_s32c, tabla_comparador_scroll_s32d, foco_modal_s32e, sin_comparacion_valida_s32f, contraste_paleta_indicador_s32g}_log.md`. Bloques conceptualmente independientes:

1. **Conteos visibles por ayudante de plural** (`b0262ca`). Categoría: saneamiento / calidad de datos de presentación. `nEE` y `nCom` declarados junto a `fmt`; 7 plurales fijos y 2 ternarios migrados. Verificación: censo en Puppeteer con control plantado; Santiago Centro "1 comuna · 39 establecimientos".
2. **Filas del modal operables por teclado** (`45b3db0`). Categoría: visualización / diseño — rediseño UI. `tabIndex`, `role`, `onKeyDown` y una sola función para clic y teclado; `.check-row:focus-visible`. En el gate, el titular reportó que el modal de territorio no respondía; s32b no lo reprodujo en Chrome con ventana y el gate siguiente pasó (pestaña sin recargar, probablemente).
3. **Enmienda §3.5 de la decisión de vista histórica** (`62514a9`). Categoría: documentación. Piso de la rampa continua 4,58:1 (k = 0,819) y mínimo sobre puntajes enteros 4,78:1, re-medidos en R y en node.
4. **IDPS 2025 definitivos** (`364c53a`). Categoría: saneamiento / calidad de datos de presentación. Esquema de columnas idéntico al de los preliminares (M6 de s32b); cambio en 2025: 4b, 10 celdas de `prom` (máx. |Δ| 2); 2m, 25 celdas (máx. 4), 4 `sigdifgru` y 22 filas de niveles; 8b, 0 (fuente: T2.6 del log s32b).
5. **El asterisco solo se explica si hay año preliminar** (`c5ade2e`). Leyenda del panorama y glosa de la ficha, con el patrón de la nota de barras.
6. **Censo sin hora y banner con el conteo real** (`c549d53`, `8ce176a`). Categoría: limpieza / deuda técnica. El banner dice 28 tablas (filtro del propio script; el comando literal contaba 30 porque no excluía dos glosas en minúscula).
7. **Tabla del comparador con scroll** (`ac3047e`, W_min 150 en `020418b`). Categoría: visualización / diseño — rediseño UI. W_min medido = 140 px; se fijó 150 para dar margen a fuentes de otros sistemas; mismo mecanismo que `.data-table` del hermano.
8. **Foco retenido en el modal** (`620df50`, reparado en `379582a`). Categoría: visualización / diseño — rediseño UI. La auditoría propia encontró una regresión (Enter o Espacio sostenidos reabrían el modal) y la reparó.
9. **"Sin comparación válida" y `n_con_comparacion`** (`da2d7ac`, `4b01f6f`). Categoría: saneamiento / calidad de datos de presentación. Decisión del titular: la Agencia informa `sigdifgru` solo cuando la comparación es válida. Cierra D-1 y D-3 de s31. El texto de `estado_vs_gse` también cambia en los CSV del panorama y de la ficha.
10. **§5.6 de contraste resuelta** (`8e92f7b`, `5e006f2`, `5be8e32`, `2029e7d`, `52430b6`, `641cf67`). Categoría: visualización / diseño — rediseño UI. Opción B del mockup (titular); `DistBar` con la regla de mayor contraste de §3.5; tokens `-txt` en glifos y tendencia; tooltip en blanco.
11. **Despliegues** (`1633319` s32c, `f5ae215` s32d, `bb7ef75` s32e, `bcb956b` s32f, `9fc6f22` s32g). Categoría: deploy / publicación. Cada uno con md5 idéntico al motor y un testigo propio del build.

## 5. Backlog acumulativo

Nueve entradas nuevas (#161–169), en el bloque `BACKLOG_ENTRADAS` de este paquete. **No suman:** la enmienda §3.5 (documentación), el pendiente 3 de v30 (cerrado sin cambios: v30 ya usaba el testigo correcto), los cinco despliegues, el banner del censo (va con la entrada del censo), los encargos, logs, mockup y registro de errores, y las reparaciones hechas por las auditorías propias.

## 6. Bugs de la sesión

1. **Siete plurales fijos, no tres.** Síntoma: "1 establecimientos" en las barras de la vista de apertura del SLEP foco y "1 comunas" en el modal. Causa raíz: cadenas `" comunas"`/`" establecimientos"` concatenadas a mano en siete lugares (el traspaso contaba tres). Solución: todo conteo pasa por `nEE`/`nCom` (`b0262ca`). Verificación: censo con control plantado. **Patrón aprendido:** un inventario de ocurrencias se mide por comando antes de fijar el alcance; la cifra heredada es hipótesis. Estado: resuelto.
2. **El foco salía del modal y quedaba en `body` al cerrar.** Causa raíz: `EntityModal` declaraba `aria-modal="true"` sin retener ni devolver el foco. Solución: ciclo de Tab calculado al pulsar la tecla, origen capturado en el primer render (`620df50`) y descarte de la autorrepetición sobre el origen (`379582a`). Verificación: con ventana y en headless, 0 pasos fuera; 10 de 10 cierres devuelven el foco. **Patrón:** un atributo ARIA es una promesa que el código tiene que cumplir. Estado: resuelto; A-1 (origen desaparecido) abierto.
3. **La tabla del comparador se comprimía a 42,5 px por columna.** Causa raíz: `table-layout:fixed` con `width:100%` sin `min-width`. Solución: `min-width:810px` (`020418b`). Verificación: a 430 px, 150 px por columna y 0 de 80 celdas desbordadas. **Patrón:** el síntoma (scroll del contenedor) no prueba la causa (tabla del mismo ancho que el contenedor); se mide la causa. Estado: resuelto.
4. **Cuatro superficies bajo 4,5 sobre la paleta de indicador** (§5.6). Causa raíz: color de indicador usado como texto, y colores de barra usados como texto. Solución: §4 punto 10. **Patrón:** la premisa "ningún color de texto llega a 4,5 sobre `#4C939A`" medía `#2e2710` y no `#000000`; el negro da 5,95. Antes de declarar imposible un contraste, se mide el negro y el blanco puros. Estado: resuelto.

## 7. Aprendizajes y restricciones descubiertas

1. **El hash del payload se compara con la convención §8.2, nunca crudo.** `fecha_generacion` viaja dentro del JSON: cualquier build de otro día cambia el SHA crudo sin que cambie una cifra.
2. **Un caso malo de calibración debe diferir en la magnitud que se mide.** `docs/` y el motor pueden ser builds distintos con el mismo payload.
3. **Los invariantes por `grep` sobre un diff van con `-U0`.** Con contexto, una línea vecina que no se tocó cuenta como cambio.
4. **Un 🔒 que mide un bloque completo choca con cualquier tarea que edite dentro de ese bloque.** Los 🔒 se releen contra cada tarea, no solo contra el encargo anterior.
5. **La carpeta de salidas del asistente se refleja dentro del repositorio del titular como `Claude outputs/`.** Los archivos para el repositorio se escriben con el puente de archivos a su ruta final, nunca en esa carpeta.
6. **Headless puede no reproducir lo que ve el titular.** Las pruebas de teclado corren también con ventana.
7. **No se escriben colores hex en comentarios de la plantilla:** el control de 🔒2 los cuenta.
8. **Un proceso largo satura el contexto de Claude Code;** los bloques siguientes se lanzan en sesión limpia, con su estado de partida escrito en el propio bloque (hash de `HEAD`, md5 esperados).

## 8. Decisiones de diseño

Replicadas como archivo: enmiendas en `20260917_decision_vista_historica_territorial.md` (§3.5 y s32f) y §5.6 resuelta en `20260910_decision_contraste_texto_estado.md`.

| Decisión | Alternativa descartada | Motivo |
|---|---|---|
| Estado vacío = "sin comparación válida" (titular) | "sin comparación publicada" | La Agencia informa `sigdifgru` solo cuando la comparación es válida; "publicada" insinuaba una comparación oculta |
| `n_con_dato` → `n_con_comparacion` (titular, D-1 de s31) | conservar el nombre | el nombre inducía a leer mal el CSV; nada automatizado lo consume |
| Chip "· sin comparación válida" en la tarjeta (titular, D-3 de s31) | volver a "≈ en su GSE" | afirmaría un estado donde `sigdifgru` es nulo (🔒 de v30) |
| 8b 2025 entra como definitivo (titular) | dejarlo fuera por ser idéntico al preliminar | la Agencia lo publicó así |
| Opción B en el título del indicador (titular, sobre mockup) | A (solo tinta); C (tres hex nuevos) | cumple sin crear colores y conserva la señal del indicador |
| W_min 150 px | 140 px medido | margen para fuentes de otros sistemas |
| Una parada de Tab por fila (D-3 de s32) | foco itinerante | cambio mayor; se reevalúa si el equipo lo pide |
| Foco en `body` si el origen desaparece (A-1 de s32e) | destino alternativo | mismo comportamiento que antes; queda en backlog |
| `const col` del tooltip se conserva | retirarla | borrarla aparece en `git diff -U0` y el 🔒 de `sigdifgru` daría 1 |
| Despliegue en un bloque aparte, después del gate visual | desplegar dentro del encargo | el gate del titular va sobre el build que se publica |

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `min-width` de `.cmp-table` | (no existía) | `810px` | `35_motor_template.html` | 210 + 4 × W_min 150 |

Fuente canónica de las vigentes: `10_utils/10_configuracion.R` y el `:root` de la plantilla. Las paletas de ESTADO e INDICADOR **no se tocaron**; el inventario de usos de los tokens `-txt` pasa de cinco a siete (`.ybar-sig`, `.hist-trend`).

## 10. Arquitectura de archivos

El escáner se regenera en este cierre. Cambios estructurales: siete encargos en `activa/encargos/`, siete logs y un registro en `andamios/logs/`, un mockup en `andamios/diseno/detalles/`; `20_insumos/` cambia 12 archivos `_preliminar` por `_final` y los preliminares van a `_archivo/20260923/20_insumos/` (fuera de git). Residuo local sin efecto en git: una carpeta vacía `Claude outputs/` en la raíz (fuente: `ls -A` = 0 entradas); se borra a mano. El gatillo de ordenación (§1.2.2 punto 4bis) sigue encendido: no existe `50_ordenacion_repositorio.md`.

## 11. Pendientes y ruta sugerida

**Inventario**

| # | Pendiente | Tipo | Impacto | Complejidad | Criterio de éxito |
|---|---|---|---|---|---|
| 1 | Retirar `_txtOn` sin uso (D-1 s32g) y actualizar el encabezado de §5 de la decisión de contraste (A-1 s32g) | deuda técnica | bajo | baja | `grep -c '_txtOn'` = 0 en la plantilla; el encabezado de §5 dice §5.6 resuelta |
| 2 | Destino del foco cuando el botón de origen desaparece (A-1 s32e) | mejora visual | bajo | baja | Con 10 de 10 entidades o tras elegir un establecimiento, el foco queda en un elemento visible, no en `body` |
| 3 | Divergencia 39 vs 24 del SLEP entre modal (directorio) y chip (roster) | deuda técnica | medio | media | Ambos textos dicen de qué universo es su cifra, o usan el mismo |
| 4 | Exportación CSV de la vista histórica | funcionalidad | medio | media | Una fila por establecimiento × año con puntaje y estado |
| 5 | Marca de base pequeña | mejora visual | medio | baja | Umbral fijado por el titular en una decisión |
| 6 | Desborde de la barra de pestañas bajo 425 px | deuda técnica | bajo | baja | A 390 px, `scrollWidth` = `innerWidth` |
| 7 | P-EXPORTACION-IMAGEN | funcionalidad | medio | alta | La imagen la produce el mismo dibujante que la pantalla |
| 8 | Tope de 10 con cambio de selector deja el modal sin poder desmarcar | bug de interacción | bajo | baja | Con 10 de 10 se quita una entidad sin cerrar el modal |
| 9 | `renv` desincronizado por `suitedoc` | deuda heredada | bajo | baja | `renv::status()` limpio o `.renvignore` con razón |
| 10 | Rama `feat/contrato-contexto` sin push desde 2026-07-11 | decisión | bajo | baja | Publicada, integrada o descartada con razón |
| 11 | Trece divergencias del modal con el hermano (log s29 §36.7): la 13 (teclado) quedó resuelta en esta sesión | deuda técnica | bajo | media | Las dos que quedan como deuda (6 y 10) resueltas |
| 12 | Ordenación del repositorio (gatillo 4bis) | deuda heredada | bajo | media | El marcador existe y el árbol cumple la política v5.5 |
| 13 | Carpeta vacía `Claude outputs/` en la raíz local | limpieza | bajo | baja | No existe (borrado manual del titular) |

**Evaluación de deuda técnica.** La zona frágil pasa a ser la **redacción de invariantes de los encargos**, no el código: cinco de los siete errores del asistente fueron comandos de 🔒 o de calibración que medían un proxy. El código quedó con dos restos sin uso (`_txtOn`, `const col`) que conviene retirar juntos en el próximo encargo con cambios de plantilla, con el 🔒 de `sigdifgru` redactado para admitir el borrado de `const col`.

**Auditoría de cierre (POLITICA 5.6).** ¿Repositorio publicado y sincronizado? Sí (`main` = `origin/main` = `9fc6f22`; fuente: `.git/refs` leído en esta sesión). ¿El artefacto desplegado corresponde al código? Sí (md5 `4b28a03f…` en motor y `docs/`; fuente: `md5sum`). ¿Decisiones de peso como archivo? Sí. ¿Cifras medidas en la sesión? Sí (logs). ¿Trabajo sin commitear? No (fuente: último eco de Claude Code, porcelain vacío). ¿Escáner al día? No: se regenera en este cierre. ¿Pipeline corre de cero? Sí (`run_all()` completo, log s32c). ¿Guarda de locale? Sí (`50_locale_utf8.md`, 3 archivos de `10_utils` la invocan; fuente: `grep` al abrir). ¿Nombres sin tildes ni espacios? No en 4 archivos de `andamios/diseno/` (congelados, deuda heredada) y la carpeta `Claude outputs/` (pendiente 13).

**Salida de la compuerta de dudas (2.1): 4 registradas.**

| supuesto | predicado | medicion |
|---|---|---|
| Pages sirve el build de s32g | `view-source` del sitio contiene "opción B de §5.6" | Recarga forzada y Cmd+F en el sitio publicado |
| Excel en español abre bien los CSV renombrados | `n_con_comparacion` y "sin comparación válida" aparecen en columnas separadas | Abrir un CSV del comparador en un equipo del Área |
| Con Windows y sus fuentes la tabla del comparador no desborda | A ancho de celular, ninguna celda se sale con columnas de 150 px | Abrir el sitio en un equipo Windows del Área |
| El filete de la opción B se distingue en los cuatro indicadores | Clima y Hábitos, los más claros, se ven sobre blanco | Mirar la ficha en un monitor del Área |

**Ruta sugerida para la próxima sesión** (criterios de 1.2.4):

1. **Pendiente 1 con el 2 en el mismo encargo:** limpieza de código muerto y encabezado de §5, más el destino del foco. Son baratos y tocan la misma plantilla; el 🔒 de `sigdifgru` se redacta para permitir retirar `const col`.
2. **Pendiente 3:** la divergencia 39 vs 24 es la única cifra visible que hoy puede leerse mal.
3. **Pendiente 5 (base pequeña)** si el titular fija el umbral.

Conviene diferir: exportación de la vista histórica (4) y de imagen (7) hasta que el equipo la pida.

## 12. Instrucciones específicas para la próxima sesión

- ✅ **PRIMERO**: correr `/apertura` y pegar su eco.
- ⚠️ **NO** dejar que un shell externo corra `git` sobre el repositorio: el asistente lee `.git/refs` como archivo.
- ⚠️ **NO** escribir archivos destinados al repositorio en la carpeta de salidas del asistente: aparece como `Claude outputs/` y bloquea el push.
- ⚠️ **NO** comparar el hash del payload crudo: siempre la convención §8.2.
- ⚠️ **NO** escribir un 🔒 por `grep` sobre un diff sin `-U0`, ni un 🔒 sobre un bloque completo que una tarea del mismo encargo edita.
- ⚠️ **NO** escribir colores hex en comentarios de la plantilla.
- ✅ **ANTES** de fijar el esperado de un caso malo, verificar que difiere en la magnitud que se mide.
- ✅ **ANTES** de dar por buena una prueba de teclado, correrla con ventana, no solo en headless.
- ✅ **ANTES** de desplegar, gate visual del titular sobre el build que se publica, y testigo propio del build.
- ✅ Lanzar cada encargo en una sesión limpia de Claude Code, con el estado de partida escrito en el propio encargo.
- 🔒 **Cero agregación:** el territorio acota la lista de establecimientos; jamás produce un puntaje propio.
- 🔒 **`sigdifgru` es la fuente del estado vs GSE**; donde es nulo no se afirma ningún estado: se dice **"sin comparación válida"**.
- 🔒 **La paleta de ESTADO y la de INDICADOR no se tocan.** El texto sobre ellas usa tinta, los tokens `-txt` o la regla de mayor contraste de §3.5; el color de indicador como texto se reemplaza por el filete (opción B).

## 13. Fragmentos de código de referencia

```js
// Plural concordante: todo conteo visible pasa por aquí (s32).
const nEE=n=>fmt(n)+(n===1?" establecimiento":" establecimientos");
const nCom=n=>fmt(n)+(n===1?" comuna":" comunas");
```

```css
/* s32d: min-width = columna de entidad + 4 x W_min; bajo eso, scroll en .cmp-tscroll */
.cmp-table{width:100%;min-width:810px;border-collapse:collapse;table-layout:fixed;}
```

```bash
# Invariante de sigdifgru: solo líneas cambiadas, nunca el contexto del diff.
git -C /Users/tomgc/Projects/slep_idps diff -U0 <inicio>..HEAD -- 30_procesamiento/35_motor_template.html | grep -E '^[+-][^+-]' | grep -c sigdifgru
```

Patrones estables: `CLAUDE.md` del proyecto (convención §8.2 del hash, Puppeteer por `NODE_PATH`).

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md y
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project y se lee
> desde ahí; no lo adjunto. Adjunto el traspaso `traspaso_cierre_v31.md`.
> Estado: `origin/main` = commit de cierre de v31, árbol limpio, sitio desplegado en
> `docs/index.html` (md5 `4b28a03f…`). Foco propuesto: limpieza de código muerto
> (`_txtOn`, `const col`) y encabezado de §5 de la decisión de contraste, junto con el
> destino del foco cuando el botón de origen del modal desaparece.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`, `encargo_autonomo_claude_code_v1.md`.
2. *Opcionales según el foco:* `CLAUDE.md` si correrá en Claude Code.
3. *Específicos (sí se adjuntan):* `traspaso_cierre_v31.md`. El asistente lee el repositorio por el puente de archivos; `30_procesamiento/35_motor_template.html` no se adjunta si la carpeta está conectada.

**Nota final:** si alguno de estos archivos cambia entre sesiones, adjuntar la versión más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente (POLITICA 0.5)

Los del redactor, con los diez campos (copia del registro `50_documentacion/andamios/logs/20260923_registro_asistente_s32.md`):

| # | momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Entrega del encargo s32 | ejecutor lo detectó en FASE 0/M1 (gate) | El encargo se escribió en el repositorio sin commitear, y su propia M1 exigía porcelain vacío con detención de la sesión | `encargo_autonomo_claude_code_v1.md` §2.2 regla 1 y §2.10 ítem 3; SETTINGS §1.2.6 "Generar, verificar, consumar" | El esperado de M1 no contó el acto de entrega que el propio redactor hizo después | SETTINGS / patrón de encargos | PAT-12, encargo desfasado por el contexto que su propia entrega creó | encargos-premisas: esperado de árbol limpio sin contar el encargo depositado sin commit | 0 | 1 gate del ejecutor; ningún cambio en el árbol |
| 2 | Redacción del encargo s32, 🔒2 y PRUEBAS c | ejecutor lo detectó en el build de línea base (gate H-0) | El 🔒 del payload pedía SHA-256 crudo, que cambia con cada build por `fecha_generacion`, en vez de la convención §8.2 | CLAUDE.md (convención §8.2) y traspaso v30 §2 | Se especificó la medición desde la intención sin transcribir la convención documentada | CLAUDE.md / traspaso | PAT-13, criterio que mide un proxy (bytes crudos) y no el riesgo (cifras) | encargos-premisas: invariante de hash sin leer la convención de CLAUDE.md | 0 | 1 gate del ejecutor; ningún cambio en el árbol |
| 3 | Entrega del registro de errores | ejecutor lo detectó en FASE L (O-1, D-4) | El registro se escribió en la carpeta de salidas del asistente, que aparece en el repositorio como `Claude outputs/`; retuvo el push de 5 commits | SETTINGS §1.2.6 "Entrega materializada con destino" y CLAUDE.md (rutas desde la raíz) | Se trató la carpeta de salidas como externa al repositorio sin verificar dónde aterriza | SETTINGS / CLAUDE.md | PAT-03, supuesto sobre el entorno de ejecución ajeno | entrega-sin-destino-o-nombre: archivo en una ruta del asistente sin destino declarado | 0 | push retenido; 1 duda (D-4) del ejecutor |
| 4 | Redacción del encargo s32b, calibración de M3 | ejecutor lo detectó en FASE 0 (gate H-1) | La calibración esperaba que el hash §8.2 de `docs/` difiriera del motor, con el mismo payload en ambos | `encargo_autonomo_claude_code_v1.md` §2.6 | Caso malo elegido sin verificar que difiriera en la magnitud medida | patrón de encargos | PAT-13, calibración con un proxy (build distinto) del riesgo (payload distinto) | encargos-premisas: caso malo sin medir que difiera en la magnitud medida | 0 | 1 gate del ejecutor; ningún cambio en el árbol |
| 5 | Redacción del encargo s32d, M5 | ejecutor lo detectó en FASE 0 (gate H-1) | M5 esperaba el contenedor sin scroll como evidencia de la compresión, pero las celdas desbordadas ya generaban scroll | `encargo_autonomo_claude_code_v1.md` §2.6 | Se describió la compresión por su síntoma y no por la causa medible | patrón de encargos | PAT-13, criterio que mide un proxy (scroll) y no el riesgo (ancho de la tabla) | encargos-premisas: esperado de caso malo sobre un efecto secundario sin medirlo | 0 | 1 gate del ejecutor; ningún cambio en el árbol |
| 6 | Redacción del encargo s32g, T3 frente a 🔒2 | ejecutor lo detectó en T3 (gate H-1) | T3 pedía editar un comentario dentro del `:root` mientras 🔒2 exigía el md5 del `:root` completo | `encargo_autonomo_claude_code_v1.md` §2.4 y §2.10 | Se copió el comando del 🔒 sin releerlo contra el alcance de T3 | patrón de encargos / traspaso v30 §12 | PAT-07, restricción leída no propagada al diseño de T3 | restriccion-no-propagada: tarea que edita dentro del bloque que un invariante mide completo | 0 | 1 gate del ejecutor; ningún cambio en el árbol |
| 7 | Redacción de los encargos s32d a s32g, 🔒 de `sigdifgru` | ejecutor lo detectó en T4 de s32g (gate H-2) | El `grep` sobre el diff contaba líneas de contexto; dio 2 sobre una edición que no tocaba `sigdifgru` | `encargo_autonomo_claude_code_v1.md` §2.6 | Comando heredado sin calibrarlo con un caso bueno vecino a `sigdifgru` | patrón de encargos | PAT-13, criterio que mide un proxy (diff con contexto) y no el riesgo (líneas cambiadas) | encargos-premisas: invariante por grep sobre diff sin `-U0` | 0 | 1 gate del ejecutor; ningún cambio en el árbol |

**Lectura:** cuatro de siete son PAT-13 en comandos de invariante o de calibración. La salvaguarda que falta es de forma (§2.2.16): todo 🔒 y todo caso malo del encargo lleva, escrita junto a él, la calibración con un caso bueno y uno malo **cercanos al cambio de la propia tarea**, no heredada del encargo anterior.

**Del ejecutor (Claude Code):** registrados en la sección "Errores propios" de cada log; todos de instrumento o de redacción del log, ninguno tocó un criterio ni una cifra. La auditoría propia reparó dos defectos reales del trabajo (R-11 de s32e, R-11 de s32g).

## 16. Fricciones (2.2.17)

- friccion: el titular tuvo que preguntar dónde dejar los definitivos y luego los dejó en otra ruta con el grado en mayúscula → el asistente los reubicó y normalizó; conviene dar la instrucción con un ejemplo de nombre exacto.
- friccion: el titular pidió teclado del modal sin recordar haberlo pedido → el foco de la sesión venía del traspaso; al proponer, citar de dónde sale cada pendiente.
- friccion: siete gates del ejecutor por redacción del asistente → las decisiones de gate se tomaron en una línea cada una; la corrección de fondo está en §15 (lectura).
- friccion: el contexto de Claude Code se saturó tras varios encargos → sesión limpia por encargo, con estado de partida escrito en el bloque.
- friccion: "sin comparación publicada" sugería una comparación oculta → el titular fijó el significado ("no hay comparación válida") y el rótulo cambió.
