# Traspaso de cierre — slep_idps — v29 (sesiones 29 y 30)

## 1. Identificación

- **Proyecto:** `slep_idps` — motor de comparación interactivo de los IDPS.
- **Versión del traspaso:** v29. **Fecha de cierre:** 2026-09-17.
- **Sesiones cubiertas:** **29 y 30**. Anomalía declarada: la s29 se extendió en ocho
  encargos (s29–s29i) y la s30 en dos (s30a, s30b) sin traspaso intermedio, de modo que
  este traspaso cubre dos sesiones. La correspondencia "un traspaso por sesión" se
  retoma en el próximo cierre.
- **Foco:** dotar al comparador de entidades nuevas (nacional y establecimiento), dejar
  el motor sin fallas de contraste fuera de excepciones escritas, y darle exportación
  de datos e imagen. Todo desplegado a GitHub Pages.
- **Entorno:** R 4.5.2 con `renv`; Positron; build `run_all(only = 35L)`.
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html`
  (todas las sesiones), `40_salidas/motor_idps.html` y `docs/index.html` (regenerados y
  desplegados), `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`
  (nueva), `50_documentacion/activa/ESTADO.md`, el log de sesión
  `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` y once
  encargos nuevos en `50_documentacion/activa/encargos/`.
- **Commits:** 54 entre `f860d4d` (previo) y `c70ca78`, punta de `main` **previa al commit de cierre**. Los hashes definitivos los agrega el eco del cierre.

## 2. Resumen ejecutivo

La sesión se propuso una cosa y terminó haciendo tres. Lo pedido fue ampliar el
comparador para incluir establecimientos y el nivel nacional; al especificarlo apareció
que la etiqueta de las barras se cortaba con cifras de cuatro dígitos, y al corregirlo
apareció que el motor tenía fallas de contraste anteriores que el cambio volvía
visibles. Se resolvieron las tres cosas en cadena: entidades nuevas en el comparador y
en el panorama, etiquetado de barra por espacio real medido en píxeles, y una línea
completa de accesibilidad que separó el color de barra del color de texto sin tocar la
paleta institucional de la Agencia. Después, a pedido del titular tras revisar el motor
publicado, se agregó el filtro de dependencia por entidad (copiado del motor hermano
`slep_simce_adecuado`) y la exportación: CSV en las tres pantallas, y radar en SVG y
PNG en la ficha. El motor se desplegó a `docs/index.html` cinco veces en la sesión, la
última en `b7fc213`. El payload de datos **no se movió en ningún momento**: mismo
SHA-256 normalizado (`1e29c2b5…`) en las 54 revisiones. Quedan pendientes tres
decisiones del titular (vista histórica territorial, regla para el texto sobre colores
de indicador, umbral de base pequeña) y una deuda de layout identificada pero no
tocada. Estado general: **publicado, estable y documentado**.

## 3. Estado al cierre

**Qué funciona** (última ejecución: build `3969248`, 2026-09-17, exit 0, 4,2 s; sitio
desplegado en `b7fc213`):

- Comparador con cinco tipos de entidad (establecimiento, comuna, SLEP, región,
  nacional), tope de 10, dependencia por entidad y clave de unicidad `kind|cod|dep`.
- Panorama territorial con entidad nacional (sin grilla de establecimientos: 6.717
  tarjetas eran inviables; se muestra el aviso con el conteo por GSE).
- Etiquetado de barra por medición real de píxeles, con `ResizeObserver` compartido.
- Accesibilidad: 0 fallas de AA fuera de las dos excepciones escritas (§3.4 etiqueta
  blanca dentro de la barra, §3.5 glifos como componente gráfico) y del ítem de backlog
  §5.6 (texto sobre paleta de INDICADOR).
- Exportación: CSV en comparador, panorama y ficha (BOM, `;`, decimal coma) y radar en
  SVG/PNG.

**Qué no funciona / limitaciones conocidas:**

- Texto sobre colores de la paleta de INDICADOR: 1,84–3,53 de contraste en
  `.defn-title`, la etiqueta de `DistBar` y la vista histórica. Documentado en §5.6 de
  la decisión, pendiente de criterio del titular.
- Al llegar al tope de 10 entidades, cambiar el selector de dependencia deja las filas
  sin marcar y no se puede desmarcar desde el modal (solo con los ✕ de los chips).
- `.cmp-table` es `table-layout:fixed` sin `min-width`: a anchos pequeños comprime las
  columnas a 43px en vez de dejar que `.cmp-tscroll` haga scroll.

**Delta respecto a v28:** v28 cerró con la suite de documentación y su cobertura
histórica. Todo lo de arriba es nuevo.


**Compuerta de repositorio (2.1) — estado declarado.** Esta es la primera vez que el
proyecto se cierra bajo el régimen de nueve invariantes, y la compuerta **no se
ejecutó**: `95_verificar_cierre.R` es un script de R y la sesión del asistente no tiene
R (fuente: `command -v Rscript` sin salida en esta sesión). Queda declarado en
`ESTADO.md`, campo `cierre_incompleto`, y la apertura siguiente lo trata como
bloqueante. Dos invariantes se prepararon aquí para que la corrida no falle por falta de
instrumento, no porque se hayan verificado:

- **I8** (ningún archivo de datos versionado) exige una lista de autorización explícita,
  que el proyecto nunca tuvo: hay 74 rutas versionadas con extensión de datos (fuente:
  `git ls-files | grep -Ei '\.(xlsx|csv|parquet|json|rds)$' | wc -l` en esta sesión),
  todas legítimas porque `slep_idps` es de **raíz unificada** (POLITICA §6.2, proyectos
  100 % públicos). Este cierre crea
  `50_documentacion/activa/50_datos_versionados_autorizados.md` con los globs y su
  fundamento.
- **I9** (ventana de insumos) exige la llave `ventana_insumos` en `ESTADO.md`, que este
  cierre escribe como `./20_insumos`: el proyecto lee con `ruta_insumos()`, que es
  `here::here("20_insumos")` (fuente: `10_utils/10_configuracion.R:26`), es decir dentro
  del propio repositorio.

**Declaración de insumos (huella).** Medida con `find`/`stat` en esta sesión, **no** por
el verificador; la huella canónica la produce la primera corrida de la compuerta. Por
encima de veinte entradas la huella es agregada (2.1):

| Entrada declarada | Entradas de primer nivel | `mtime` más reciente | Bytes (archivos de primer nivel) |
|---|---|---|---|
| `./20_insumos` | 34 (32 archivos + `auxiliares/` e `historico/`) | 2026-09-15 (`.DS_Store`); el archivo de datos más reciente es del 2026-06-21 | 105.070.120 |

La huella es **completa**, no parcial: el proyecto no lee ninguna fuente fuera de esa
ventana.

## 4. Registro detallado de cambios

Por brevedad se referencia el log de sesión, que trae el detalle por fase con cifras
observadas: `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md`
(§§1–49). Los bloques conceptualmente independientes:

1. **Etiquetado adaptativo de `StackedBar`** (`d4edefc`). Categoría: visualización. El
   umbral dejó de ser un porcentaje del total y pasa a medirse en píxeles con `canvas
   measureText`, con `ResizeObserver` compartido a nivel de módulo. Verificación: 49 de
   158 segmentos habrían pintado una cifra cortada con la regla vieja; con la nueva, 0.
   Impacto cruzado verificado en el panorama territorial.
2. **Entidad nacional en el comparador** (`3c16c80`, corregida en `be340c9`). El primer
   diseño la puso como fila fija en todos los tabs; el titular lo rechazó y se rehízo
   copiando el modal del hermano: tab propio, orden Establecimiento · Comuna · SLEP ·
   Región · Nacional.
3. **Establecimientos como filas de caso individual** (`ffdaeaa`). Glifo de estado y
   puntaje, nunca barra: un caso no se reparte. Solo en la sección de su propio GSE.
4. **Aviso único de EE sin ubicación** (`495b9fb`) y **pie de sección sin repetir la
   explicación** (`28a4de4`).
5. **Línea de contraste** (`82ba5d3`, `d440ff2`, `5d508f7`, `65ced7f`, `c157a05`,
   `ef9fdeb`, `46e0e47`). Tres tokens de texto nuevos (`--alerta-txt` `#CE112C`,
   `--destaca-txt` `#1E6EA9`, `--st-neutro-txt` `#5F6A78`) y `--gris` corregido en la
   raíz (`#6b7780` → `#5C666E`, que cumple 4,5:1 en los 15 fondos claros del CSS).
6. **Entidad nacional en el panorama y dependencia por entidad** (`ca1cdcd`,
   `ed0d799`). Verificación aritmética exigida y cumplida: Viña del Mar · todas = 109
   EE; Municipal 0 + Part. subvencionado 47 + Part. pagado 23 + SLEP 39 = 109.
7. **Mayúsculas sostenidas retiradas** (`7a2b263`): siete reglas `text-transform`
   fuera; 0 elementos con versalitas en las tres pantallas.
8. **Exportación** (`d703d20`, `c03a393`, `5ccdae2`, `ce91580`, `07d2293`). CSV con
   BOM, `;` y decimal coma; radar en SVG 1.1 válido y PNG 2x.

## 5. Backlog acumulativo

Nueve entradas nuevas (#148–156), en el bloque `BACKLOG_ENTRADAS` de este paquete.
Total 147 → **156**. El detalle de qué no suma va en ese bloque.

## 6. Bugs de la sesión

1. **Etiqueta de barra cortada a media cifra.** Síntoma: `"17% (233)"` renderizado como
   `"17% (23"`. Causa raíz: umbral de etiquetado por porcentaje del total, calibrado
   con territorios de dos dígitos. Solución: medición en píxeles
   (`35_motor_template.html`, `StackedBar`). Verificación: 0 spans truncados a 1200px y
   430px. **Patrón aprendido:** un umbral que decide sobre espacio disponible debe
   medirse en la unidad del espacio (píxeles), no en la del dato (porcentaje).
   Principio: C.11. Estado: resuelto.
2. **Desborde de la tira externa sobre la celda vecina** en anchos pequeños. Causa: el
   grid de tres pistas no permitía salto de línea y `nowrap` es invariante. Solución:
   apilado. Verificación: a 768px, de 63 desbordes y 55 cruces a 0 y 0. Estado:
   resuelto. **Patrón:** describir un síntoma desde una captura no basta; hay que medir
   qué elemento invade a cuál.
3. **"Chile" en todos los tabs del modal.** Causa raíz: **error de especificación del
   asistente**, no de ejecución (ver §15). Solución: tab propio. Estado: resuelto.

## 7. Aprendizajes y restricciones descubiertas

1. **De la referencia hermana se copia la forma; los valores de dominio se leen del
   motor propio.** Contexto: el encargo s29i fijó la dependencia SLEP en `"5"`, que es
   el código del hermano; en este motor son 4 categorías y SLEP es `"4"`. Si se viola,
   la funcionalidad queda muerta sin fallar ruidosamente.
2. **Antes de especificar un componente de interfaz que el hermano `slep_simce_adecuado`
   ya tenga, se lee su implementación y se cita como referencia vinculante.** Inventar
   una solución propia cuando existe una hermana produce divergencia entre dos motores
   que el mismo equipo usa en paralelo.
3. **Un panel adversarial no es una capa de garantía si se corta por cuota.** En tres
   encargos consecutivos murieron agentes por límite de sesión, incluida la lente de
   cobertura. La verificación que sostiene un cierre debe ser determinista y barata.
4. **La convención de normalización del payload debe escribirse, no recordarse.** Un
   hash sin su receta no es reproducible entre sesiones (log §8.2).
5. **`--gris` sobre fondos teñidos:** cualquier fondo nuevo que no sea `--paper` o
   `--panel` obliga a remedir el texto gris que caiga encima.

## 8. Decisiones de diseño

Replicadas como archivo:
`50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`
(paleta de estado intacta, tres tokens de texto, dos excepciones escritas, una exención
con fundamento WCAG 1.4.3 y un ítem de backlog agrupado).

Otras, con su alternativa descartada:

| Decisión | Alternativa descartada | Motivo |
|---|---|---|
| EE con glifo de estado, no barra | barra apilada con n=1 | "100%" de un caso se lee como reparto de un colectivo |
| `--gris` corregido en la raíz | token paralelo para 4 selectores | la falla afectaba 5 fondos y su parte más severa era anterior a s29 |
| `--alerta-txt` = `#CE112C` | `#D1112D` (4,5003) | margen de tres diezmilésimas no es un arreglo |
| Panorama nacional sin grilla de EE | pintar 6.717 tarjetas | inviable de render y ajeno a lo que esa pantalla responde |
| Dependencia como atributo de la entidad | filtro global | permite comparar la misma comuna con dos dependencias |
| Imagen solo del radar | exportar también comparador y panorama | sus barras son HTML/CSS; exigiría redibujarlas en SVG |

## 9. Constantes y parámetros

| Constante | Valor anterior | Valor nuevo | Archivo | Motivo |
|---|---|---|---|---|
| `--gris` | `#6b7780` | `#5C666E` | `35_motor_template.html` | AA en los 15 fondos claros |
| `--alerta-txt` | (no existía) | `#CE112C` | íd. | texto de estado sobre fondo claro |
| `--destaca-txt` | (no existía) | `#1E6EA9` | íd. | íd. |
| `--st-neutro-txt` | (no existía) | `#5F6A78` | íd. | íd. |

`--alerta`, `--destaca`, `--st-neutro` y `--ind1..4` **no se tocaron**. Fuente canónica
de las vigentes: `10_utils/10_configuracion.R` y el `:root` de la plantilla.

## 10. Arquitectura de archivos

El escáner se regenera en este cierre (`00_escanear_proyecto.R`); su salida es la
referencia. Cambios estructurales de la sesión: cuatro andamios nuevos (dos mockups en
`andamios/diseno/detalles/`), once encargos en `activa/encargos/`, una decisión nueva en
`activa/decisiones/`. **Deuda estructural que este cierre salda:** los 28 traspasos
vivían planos en `50_documentacion/traspasos/`; la política 1.3.1 exige uno vigente y el
resto en `archivo/`. Se migran con `git mv` como parte de este cierre.

## 11. Pendientes y ruta sugerida

**Inventario**

| # | Pendiente | Tipo | Impacto | Complejidad | Criterio de éxito |
|---|---|---|---|---|---|
| 1 | **P-VISTA-TERRITORIAL**: selector Vista actual / Vista histórica en el panorama | funcionalidad | alto | media | Existe la vista y es una **serie de repartos** por año, no una curva de puntaje |
| 2 | **§5.6**: regla para el texto sobre colores de la paleta de INDICADOR | deuda técnica | medio | media | `.defn-title`, etiqueta de `DistBar` y vista histórica ≥ 4,5, sin tocar la paleta |
| 3 | **P-EXPORTACION-IMAGEN**: exportar imagen del comparador y del panorama | funcionalidad | medio | alta | La imagen la produce **el mismo dibujante** que pinta la pantalla, no una segunda ruta |
| 4 | **Marca de base pequeña** | mejora visual | medio | baja | Umbral de N fijado por el titular y escrito en una decisión |
| 5 | `.cmp-table` `table-layout:fixed` sin `min-width` | deuda técnica | medio | baja | A 430px la tabla hace scroll en `.cmp-tscroll` en vez de comprimir a 43px |
| 6 | Desmarcar entidades desde el modal al llegar al tope | bug de interacción | bajo | baja | Con 10 de 10, se puede quitar una entidad sin cerrar el modal |
| 7 | `renv` out-of-sync: `suitedoc` | deuda heredada | bajo | baja | `renv::status()` limpio, o `.renvignore` con la razón escrita |
| 8 | Rama `feat/contrato-contexto` (2 commits sin push desde el 2026-07-11) | decisión | bajo | baja | Publicada, integrada o descartada con razón |
| 9 | Tooltip "vs evaluación anterior": de `title` a body | mejora visual | bajo | baja | heredado de s28 |
| 10 | Trece divergencias del modal con el hermano (log §36.7) | deuda técnica | bajo | media | Las tres que son deuda (✕ de cierre, "Traspaso AAAA", a11y de teclado) resueltas |
| 11 | **Compuerta de repositorio nunca ejecutada**: correr `95_verificar_cierre.R` y saldar lo que marque | bloqueante | alto | baja | Los nueve invariantes con veredicto escrito, e `I8`/`I9` en verde con la lista de autorizacion y la `ventana_insumos` que este cierre dejo |

**Evaluación de deuda técnica.** Zona frágil principal: la tabla del comparador
comprime en vez de hacer scroll (pendiente 5), que es la causa de fondo de dos síntomas
ya parcheados. Segunda: la exportación de imagen, si se hace mal, crea una segunda ruta
de dibujo que diverge de la pantalla — el propio hermano dejó esa lección escrita.

**Auditoría de cierre (POLITICA 5.6).** ¿El repositorio está publicado y sincronizado?
Sí (`origin/main == HEAD == c70ca78` antes de este cierre). ¿El artefacto desplegado
corresponde al código? Sí (md5 idéntico). ¿Las decisiones de peso están como archivo?
Sí. ¿Las cifras comunicadas se midieron en la sesión? Sí. ¿Hay trabajo sin commitear?
No. ¿El escáner está al día? **No** — se regenera en este cierre. ¿Los traspasos
cumplen la política 1.3.1? **No** — se migran en este cierre. ¿Corrió la compuerta de repositorio? **No** — declarado en `cierre_incompleto` y §3. Las dos primeras "no" quedan
saldadas aquí; la tercera queda declarada, no heredada en silencio.

**Salida de la compuerta de dudas (2.1): 3 registradas.**

| supuesto | predicado | medicion |
|---|---|---|
| El sitio público sirve la última versión | `docs/index.html` servido por GitHub Pages contiene la cadena `Exportar CSV` | Abrir la URL con recarga forzada y buscar el botón; o revisar Actions del repositorio |
| El CSV abre en columnas en el Excel del equipo | Excel en español separa el archivo en 13 columnas sin asistente de importación | Abrir `idps_panorama_*.csv` en el Excel de una máquina del equipo |
| `suitedoc` no afecta a nadie más | Un clon limpio con `renv::restore()` construye el paso 35 sin error | Clonar en una máquina nueva y correr `run_all(only = 35L)` |

**Ruta sugerida para la próxima sesión** (criterios de 1.2.4):

0. **La compuerta de repositorio** (pendiente 11), antes de tocar código. Es media hora y es lo que este cierre no pudo hacer; el resto de la ruta no depende de su resultado, pero un invariante en rojo sí cambia qué se puede publicar.

1. **P-VISTA-TERRITORIAL** (pendiente 1). Es lo único del tablero que agrega capacidad
   nueva al análisis. Requiere mockup previo y una decisión: la vista histórica de un
   territorio no puede ser la curva de la ficha, porque un territorio no tiene puntaje
   propio. Criterio de éxito arriba.
2. **Pendiente 5** (`min-width` de la tabla). Barato y corta de raíz lo que se ha
   parcheado dos veces por síntomas.
3. **§5.6** (pendiente 2), que necesita criterio del titular antes de cualquier encargo.

Conviene diferir: la exportación de imagen del comparador (pendiente 3), hasta que el
CSV haya tenido uso real y se sepa si la imagen hace falta; y las divergencias del modal
(pendiente 10).

## 12. Instrucciones específicas para la próxima sesión

- ✅ **PRIMERO**: correr `Rscript "$HERRAMIENTAS_DEV_PATH/plantillas/95_verificar_cierre.R" $(pwd)` y leer los nueve invariantes. Es lo único marcado como bloqueante en el inventario.

- ⚠️ **NO** especificar un componente de interfaz que el hermano `slep_simce_adecuado`
  también tenga **sin** haber leído su implementación y citarla en el encargo.
- ⚠️ **NO** copiar del hermano códigos, glosas ni categorías: esos se leen de
  `10_utils/10_configuracion.R` (la dependencia SLEP aquí es `"4"`, no `"5"`).
- ⚠️ **NO** lanzar paneles adversariales de más de un puñado de agentes: agotaron la
  cuota de dos sesiones seguidas.
- ✅ **ANTES** de dar por buena cualquier cifra de contraste, verificar el instrumento
  con los dos controles: `#000`/`#fff` = 21,00 y `#777`/`#fff` = 4,48.
- ✅ **ANTES** de cerrar un encargo que toque el motor, verificar la fidelidad del
  payload con la convención de §8.2 del log y el diff de offsets.
- 🔒 **Cero agregación:** el territorio acota la lista de establecimientos; jamás produce
  un puntaje propio.
- 🔒 **La paleta de ESTADO y la de INDICADOR no se tocan:** son identidad del folleto de
  la Agencia. Para texto sobre fondo claro existen los tokens `-txt`.
- 🔒 **`sigdifgru` es la fuente del estado vs GSE**; no se reconstruye comparando
  promedios.

## 13. Fragmentos de código de referencia

Patrones nuevos de esta sesión (los estables viven en `CLAUDE.md` y en la plantilla):

```js
// Etiquetado por espacio real: la unidad de decisión es el píxel, no el porcentaje.
// La fuente se DERIVA del CSS efectivo (una sonda montada fuera de pantalla), nunca
// se escribe a mano, y se vuelve a derivar en document.fonts.ready.
const px = ancho * s.p / 100;
const full = s.p + "% (" + fmt(s.count) + ")";
if (medirTexto(full) + 12 <= px) { /* dentro */ } else { /* entero a la tira */ }
```

```js
// CSV para Excel en español: BOM + separador ; + decimal coma. Sin el BOM, "Peñaflor"
// llega como "PeÃ±aflor" y el archivo entero cae en la columna A.
const blob = new Blob(["﻿" + contenido], {type:"text/csv;charset=utf-8;"});
```

## 14. Reapertura

**Mensaje de apertura pre-armado:**

> Sesión CONTINUATION de `slep_idps`. El protocolo (POLITICA_PROYECTO.md y
> SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la knowledge base del Project y se lee
> desde ahí; no lo adjunto. Adjunto el traspaso `traspaso_cierre_v29.md`.
> Estado: `origin/main = <commit_cierre>`, árbol limpio, sitio desplegado en
> `docs/index.html`. Foco propuesto: **P-VISTA-TERRITORIAL** — selector Vista actual /
> Vista histórica en el panorama territorial, que necesita mockup y una decisión previa
> sobre qué es la serie histórica de un territorio.

**Documentos para la próxima sesión:**

1. *Protocolo en knowledge base (no se adjuntan):* `POLITICA_PROYECTO.md`,
   `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
2. *Opcionales según el foco:* `CLAUDE.md` si correrá en Claude Code.
3. *Específicos (sí se adjuntan):* `traspaso_cierre_v29.md`. Anotado como voluminoso
   pero crítico si se entra a implementar: `30_procesamiento/35_motor_template.html`.
   Referencia vinculante de interfaz, no se adjunta pero se cita por ruta:
   `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`.

**Nota final:** si alguno de estos archivos cambia entre sesiones, adjuntar la versión
más actualizada al abrir y avisarlo en el mensaje de apertura.

## 15. Errores del asistente (POLITICA 0.5)

| # | Error | Dónde | Patrón |
|---|---|---|---|
| 1 | Puntajes con decimal inventados en el mockup (`78,4`) cuando los 354.007 valores de `prom` son enteros | `mockup_comparador_ee_nacional.html` | Inferencia sobre datos no leídos; mismo patrón que el traspaso s28 |
| 2 | Regla de detención fijada sobre un SHA-256 no reproducible (se copió el hash sin su receta de normalización) | encargo s29c §0.2 | Se volvió criterio bloqueante un valor no verificado como reproducible |
| 3 | Atribución errónea de selector: el 3,53 sobre `#D4E4F1` se adjudicó a `.gfb.on`, que usa `--foco` y ya cumplía; el caso real era `.eo-m` en hover | encargo s29d §1 | Se nombró un selector por inferencia visual en vez de leerlo del instrumento |
| 4 | La entidad nacional se especificó como fila fija **en todos los tabs** del modal | encargo s29 §3.2 | Se diseñó desde cero un problema que el hermano ya tenía resuelto, pese a que el backlog declara esa hermandad |
| 5 | Código de dependencia SLEP fijado en `"5"`, copiado del hermano; en este motor es `"4"` | encargo s29i §3.6 | Se copió del hermano un **valor de dominio**, no un patrón de interfaz |
| 6 | El defecto de la tira externa se describió como "las tres etiquetas se superponen"; medido, era desborde de la celda sobre la vecina | encargo s29i §5 | Se describió el síntoma desde una captura en vez de medir qué invade a qué |

**Reglas adoptadas a partir de estos errores:** (a) de la referencia hermana se toma la
forma, nunca los valores de dominio; (b) antes de especificar un componente que el
hermano tenga, se lee su implementación y se cita como vinculante en el encargo; (c) una
regla de detención debe poder ejecutarse con lo que el encargo entrega.

## 16. Fricciones (2.2.17)

- Dos sesiones consecutivas agotaron su cuota corriendo paneles adversariales de 12 a 33
  agentes; una quedó a medias y hubo que redactar un encargo de reanudación. La
  verificación que sostiene un encargo debe ser determinista y barata.
- El `.git/index.lock` del editor abierto sobre el repo bloqueó commits en dos encargos.
- Este traspaso cubre dos sesiones porque la s29 se extendió a ocho encargos sin cerrar.
