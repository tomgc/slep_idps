# Decisión: vista histórica del panorama territorial (P-VISTA-TERRITORIAL)

- **Fecha:** 2026-09-17
- **Sesión:** s31 (traspaso vigente v29)
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_vista_historica_territorial_s31.md`
- **Referencia visual vinculante:** `50_documentacion/andamios/diseno/detalles/mockup_vista_historica_territorial.html`
- **Tipo:** decisión de producto y presentación. No crea ninguna cifra agregada. Corrige además un defecto de lectura del estado vs GSE (§6).
- **Estado:** adoptada por el titular el 2026-09-17, tras cinco iteraciones del mockup.

---

## 1. Problema

El traspaso v29 pedía un selector "Vista actual / Vista histórica" en el panorama territorial. También pedía que la vista histórica fuera una **serie de repartos por año**, no una curva de puntaje, porque un territorio no tiene puntaje propio (invariante de cero agregación).

Esa serie no se puede construir con los datos del motor. El estado vs GSE (`sigdifgru`) solo existe en 2024 y 2025; entre 2014 y 2023 el payload trae únicamente el puntaje (`prom`). Además, el GSE falta en todos los establecimientos en 2014–2016 (fuente de ambas cifras: conteo sobre el payload de `40_salidas/motor_idps.html`, 2026-09-17; `34_leer_normalizar_idps.R` L299 declara que el histórico no trae significancia). Un reparto por año tendría hoy dos barras.

## 2. Alternativas evaluadas

| Opción | Qué muestra | Por qué se descartó o se adoptó |
|---|---|---|
| A. Repartos de estado solo en los años que lo tienen | 2024 y 2025; el resto como "sin estado publicado" | Fiel a la Agencia, pero muestra casi nada. **Se adopta como franja superior**, no como vista completa |
| **B. Matriz establecimiento × año con el puntaje propio** | Una fila por establecimiento y una columna por año, sin sumar ni promediar | **Adoptada.** Es la única que muestra 2014–2025 sin inventar cifras ni tramos |
| C. Conteo de establecimientos por tramos de puntaje | 2014–2025 | Descartada: los tramos serían del equipo, la Agencia no los publica |

## 3. Decisiones adoptadas

1. **Agrupación.** Cada establecimiento va en la sección del GSE de su **último año con GSE publicado** en el nivel. Los que nunca tuvieron GSE van al final, en "Sin clasificar". Cada fila indica el GSE anterior y el último año en que lo tuvo ("hasta 2024: Medio bajo"). Motivo: el GSE cambia seguido. En SLEP Costa Central, 46 de 61 establecimientos de 4° básico y 7 de 13 de 2° medio tuvieron más de un GSE en la serie (fuente: conteo del armado del mockup, 2026-09-17).
2. **Franja de estado (opción A).** Sobre la matriz de cada sección, una barra de reparto por indicador **solo en los años con `sigdifgru` publicado**. Esos años se derivan del dato en R, no se escriben a mano. El estado de cada establecimiento en un año se lee contra el GSE que tenía **ese** año, no contra el de la sección.
3. **Matriz (opción B).** Un indicador a la vez, elegido en un selector propio. La celda muestra el puntaje propio del establecimiento (`prom`). En los años con estado publicado, lleva además el glifo ▼ = ▲ leído de `sigdifgru`, y ninguno si es nulo.
4. **Color de la celda.** Va del casi blanco al color del indicador (paleta invariante de P-PALETA). El 6 % inicial del tramo se reserva para que una celda con dato nunca quede tan blanca como una sin dato. El color se **calibra** a los percentiles 5 y 95 de los puntajes del país para ese nivel e indicador, sumando todos los años. Por debajo y por encima de ese rango el color se satura. El rango es el mismo para cualquier territorio y lo calcula R.
   - *Por qué no 0–100:* casi todos los puntajes caen en una franja angosta. Por ejemplo, Autoestima en 4° básico va de 65 a 84 entre los percentiles 5 y 95 (fuente: payload, 2026-09-17). Con la escala completa, todas las celdas tenían el mismo tono y el mapa de calor no distinguía nada; el titular lo rechazó por eso.
   - *Por qué no percentiles del territorio:* el mismo tono significaría cosas distintas en cada territorio.
5. **Color del número.** Se elige por contraste WCAG entre negro (`#000000`), `--gris` y blanco (`#ffffff`): gana el de mayor razón con el fondo de la celda. En la rampa continua el piso es 4,58:1 (Autoestima, k = 0,819); sobre los puntajes enteros del dominio calibrado, el mínimo realizado es 4,78:1 (puntaje 81, 4° básico) (fuente: `/tmp/s32_rampa.R`, s32, 2026-09-23; controles 21,00 y 4,48). Se descartaron el número sobre una pastilla blanca (rechazada por el titular) y el texto fijo en `--tinta`: con Autoestima, cerca de 73 puntos ni el texto oscuro ni el blanco llegan a 4,5:1 (el mejor da 3,69:1), y con Participación, en su tono pleno, el texto oscuro queda en 4,40:1.
6. **Leyenda.** Dice "Puntaje 0 [barra] 100". El rango calibrado se lee al pasar el cursor, porque el titular pidió que la leyenda no mostrara "≤65 / ≥84". Los controles de la matriz van en un panel de dos columnas: rótulo a la izquierda y contenido a la derecha.
7. **Años sin medición nacional.** Los años contiguos sin medición (2019–2021) se agrupan en **una** columna angosta y rayada. El encabezado va en horizontal, en dos líneas ("2019–" arriba y "2021" abajo), nunca en vertical. Los motivos de cada año se leen al pasar el cursor.
8. **Nivel nacional.** La matriz no se muestra (mismo criterio que la grilla de tarjetas); sí se muestra la franja.
9. **Orden de las filas.** Por defecto, alfabético. Al hacer clic en el encabezado del último año, se ordena de mayor a menor puntaje de ese año. Al hacer clic en una fila, se abre el Panorama IDPS del establecimiento.
10. **Exportación.** Mientras esté activa la vista histórica, la barra de exportación del panorama no se muestra. Exportar esta vista queda como pendiente propio.

## 4. Invariantes que la decisión respeta

- **Cero agregación:** ninguna celda, barra ni rótulo promedia o suma puntajes. La franja cuenta establecimientos por estado leído de `sigdifgru`, igual que la vista actual.
- **`sigdifgru` es la fuente del estado vs GSE.** Donde es nulo, no se afirma ningún estado.
- **Las paletas de ESTADO y de INDICADOR no cambian.** El tinte de las celdas es una mezcla hacia blanco del color del indicador, sin tonos nuevos. No se usa verde con sentido de "bueno": el único verde es el propio de Participación y el de Hábitos.
- **La calibración se calcula en R** (`35_generar_motor_html.R`, con constantes nombradas en `10_utils/10_configuracion.R`) y viaja en `meta`. El template solo la pinta.

## 5. Constantes nuevas

| Constante | Valor | Archivo | Motivo |
|---|---|---|---|
| `VT_PERCENTILES_COLOR` | `c(inf = 0.05, sup = 0.95)` | `10_utils/10_configuracion.R` | rango de calibración del color de la matriz |
| `VT_TINTE_MINIMO` | `0.06` | íd. (viaja en `meta`) | una celda con dato nunca queda blanca como una sin dato |

Valores esperados de la calibración con el payload actual (percentil tipo 7 sobre `prom` redondeado; fuente: cálculo del 2026-09-17):

| Nivel | Autoestima (1) | Convivencia (2) | Participación (3) | Hábitos (4) |
|---|---|---|---|---|
| 4b | 65–84 | 66–87 | 67–90 | 60–82 |
| 2m | 68–81 | 67–84 | 68–86 | 61–79 |

## 6. Defecto corregido en la misma línea: estado nulo contado como "sin diferencia"

Al revisar la franja apareció un defecto del motor publicado. `repartoInd` cuenta como `neutro` a todo establecimiento con puntaje y `sigdifgru` nulo (`35_motor_template.html` L896), y `CeldaEE` le pinta el glifo "=" (L1690). Pero `estadoVsGse` (L1949) ya los exporta como "sin comparación vs GSE publicada". Resultado: la pantalla y el CSV dicen cosas distintas de la misma celda, y la pantalla deriva una conclusión de una ausencia.

- **Magnitud:** en 4° básico 2025, 900 establecimientos del país tienen puntaje sin comparación publicada en al menos un indicador, 2 de ellos de SLEP Costa Central (fuente: conteo sobre el payload, 2026-09-17). En la sección Medio de SLEP Costa Central (4° básico 2025, Autoestima), la barra dice hoy N = 28 con 17 "sin diferencia"; el dato publicado es N = 26 con 15.
- **Decisión del titular (2026-09-17): fuera de la barra.** El 100 % de la barra pasa a ser los establecimientos **con** comparación publicada. Si hay establecimientos sin ella, bajo la barra aparece una nota: "+N sin comparación publicada". La paleta de estado no se toca. En la fila de establecimiento del comparador, el puntaje va con el glifo "·" y el texto "sin comparación publicada" (la misma señalética de #147 para años sin comparación). El CSV del comparador suma la columna `n_sin_comparacion`.
- **Alternativa descartada:** un cuarto segmento rayado dentro de la barra. Agregaba una trama nueva a la codificación de estado y mezclaba en el 100 % casos sin estado.

**Enmienda s32 (2026-09-23):** §3.5 distinguía mal el piso de la rampa (4,58:1) del mínimo sobre puntajes enteros (4,78:1); detectado en la revisión s31b (log L274).

**Enmienda s32f (2026-09-23):** el rótulo 'sin comparación publicada' pasa a 'sin comparación válida' (decisión del titular: la Agencia informa sigdifgru solo cuando la comparación es válida), y la columna n_con_dato del CSV del comparador pasa a n_con_comparacion (D-1 de s31).

**Enmienda s33e (2026-09-24):** la vista histórica se exporta con su propio botón dentro de la vista (una fila por establecimiento, año e indicador, con el GSE de ese año y el último); el punto 10 de §3 queda superado. Decisión del titular en la sesión 33.
