# Diagnóstico de base pequeña en las barras del comparador (s33m T1, pendiente 5)

> Documento **generado** por `20260924_diagnostico_base_pequena.R` (misma carpeta); no se edita a mano.
> Presenta evidencia para la decisión metodológica de §5.2 de `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`
> (marca de "base pequeña"). **No recomienda un umbral**: la decisión es del titular.

## 1. Qué es N y de dónde sale

- En cada barra 0–100 de una entidad del comparador, `N` = establecimientos del roster del nivel y del año de esa entidad, en ese GSE,
  con puntaje (`prom` no nulo) **y** comparación válida con su GSE (`sigdifgru` en −1, 0 o 1). Los que tienen puntaje pero `sigdifgru`
  nulo se cuentan aparte (`sin`) y no entran en el 100 % (la nota "+k sin comparación válida" bajo la barra).
- Hoy `N` solo se lee en el `title` de la barra ("100% = N establecimientos con comparación válida"). §5.2 describe dos piezas: el `N`
  visible bajo el nombre de la entidad y una marca cuando `N` cae bajo un umbral.
- El cálculo replica en R `rosterTerr` y `repartoInd` del motor (`30_procesamiento/35_motor_template.html`) y el armado de
  `DATA.roster`, `DATA.ind` y `DATA.establecimientos` (`30_procesamiento/35_generar_motor_html.R`). La réplica se validó contra la
  pantalla del motor (`40_salidas/motor_idps.html`, md5 `7ad76f36e42d66c4da2d71aa28a558eb`) con Puppeteer: 12 barras de control
  iguales en `N` y `sin` (log `50_documentacion/andamios/logs/20260924_preparacion_decisiones_s33m_log.md`, M4); la auditoría del
  mismo log (FASE R) contrasta barras adicionales.
- Insumo: `40_salidas/intermedios/idps_largo.parquet` (md5 `b2aab20da2901bfb5152ba223a885be4`), más el directorio público, `sleps_chile` y `comunas_chile`.
- Universo: para cada nivel del motor, su año más reciente (4° básico 2025 y 2° medio 2025; el comparador no tiene selector de año); entidades sin dependencia de los tipos comuna, SLEP y región, y la entidad nacional aparte; cada GSE con al menos un establecimiento en el roster de la entidad; los cuatro indicadores. Una **barra** es una celda entidad × GSE × indicador.
- **Barra marcada con el umbral u**: `1 ≤ N < u` ("cae bajo un umbral", §5.2). Las barras con `N = 0` ya se dibujan como "sin dato"
  (no hay barra que marcar) y se cuentan en su propia columna.

## 2. Barras por tipo y nivel

| Nivel | Tipo | Entidades con barras | Barras | Con N = 0 | Con sin > 0 |
|---|---|---:|---:|---:|---:|
| 4° básico 2025 | Comuna | 343 | 4.604 | 329 | 1.718 |
| 4° básico 2025 | SLEP | 36 | 508 | 4 | 298 |
| 4° básico 2025 | Región | 16 | 320 | 0 | 242 |
| 4° básico 2025 | Nacional | 1 | 20 | 0 | 20 |
| 2° medio 2025 | Comuna | 335 | 3.416 | 4 | 47 |
| 2° medio 2025 | SLEP | 36 | 404 | 0 | 8 |
| 2° medio 2025 | Región | 16 | 320 | 0 | 31 |
| 2° medio 2025 | Nacional | 1 | 20 | 0 | 12 |

Total sin la entidad nacional: 5.432 barras en 4° básico 2025 y 4.140 barras en 2° medio 2025.

## 3. Distribución de N por tipo

Cuartiles con `quantile(type = 1)` (valores observados de N).

| Nivel | Tipo | Barras | Mínimo | Q1 | Mediana | Q3 | Máximo |
|---|---|---:|---:|---:|---:|---:|---:|
| 4° básico 2025 | Comuna | 4.604 | 0 | 1 | 3 | 6 | 40 |
| 4° básico 2025 | SLEP | 508 | 0 | 3 | 8 | 15 | 43 |
| 4° básico 2025 | Región | 320 | 1 | 13 | 35 | 95 | 526 |
| 4° básico 2025 | Nacional | 20 | 490 | 662 | 890 | 1.622 | 2.059 |
| 2° medio 2025 | Comuna | 3.416 | 0 | 1 | 2 | 4 | 35 |
| 2° medio 2025 | SLEP | 404 | 1 | 2 | 4 | 6 | 16 |
| 2° medio 2025 | Región | 320 | 1 | 8 | 20 | 42 | 280 |
| 2° medio 2025 | Nacional | 20 | 365 | 451 | 594 | 725 | 848 |
| ambos niveles | Comuna | 8.020 | 0 | 1 | 2 | 5 | 40 |
| ambos niveles | SLEP | 912 | 0 | 2 | 5 | 10 | 43 |
| ambos niveles | Región | 640 | 1 | 11 | 24 | 56 | 526 |
| ambos niveles | Nacional | 40 | 365 | 494 | 672 | 890 | 2.059 |

## 4. Barras que quedarían marcadas según el umbral

Cada celda: barras con `1 ≤ N < u` y su porcentaje sobre todas las barras de la fila (incluidas las de `N = 0`).
La fila "Comuna + SLEP + Región" excluye la entidad nacional.

| Nivel | Tipo | Barras | N = 0 | u = 5 | u = 10 | u = 15 | u = 20 | u = 30 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| 4° básico 2025 | Comuna | 4.604 | 329 | 2.671 (58,0 %) | 3.606 (78,3 %) | 3.939 (85,6 %) | 4.070 (88,4 %) | 4.240 (92,1 %) |
| 4° básico 2025 | SLEP | 508 | 4 | 158 (31,1 %) | 281 (55,3 %) | 366 (72,0 %) | 437 (86,0 %) | 488 (96,1 %) |
| 4° básico 2025 | Región | 320 | 0 | 12 (3,8 %) | 52 (16,2 %) | 100 (31,2 %) | 116 (36,2 %) | 148 (46,2 %) |
| 4° básico 2025 | Comuna + SLEP + Región | 5.432 | 333 | 2.841 (52,3 %) | 3.939 (72,5 %) | 4.405 (81,1 %) | 4.623 (85,1 %) | 4.876 (89,8 %) |
| 4° básico 2025 | Nacional | 20 | 0 | 0 (0,0 %) | 0 (0,0 %) | 0 (0,0 %) | 0 (0,0 %) | 0 (0,0 %) |
| 2° medio 2025 | Comuna | 3.416 | 4 | 2.625 (76,8 %) | 3.132 (91,7 %) | 3.296 (96,5 %) | 3.376 (98,8 %) | 3.404 (99,6 %) |
| 2° medio 2025 | SLEP | 404 | 0 | 216 (53,5 %) | 376 (93,1 %) | 396 (98,0 %) | 404 (100,0 %) | 404 (100,0 %) |
| 2° medio 2025 | Región | 320 | 0 | 20 (6,2 %) | 100 (31,2 %) | 132 (41,2 %) | 157 (49,1 %) | 208 (65,0 %) |
| 2° medio 2025 | Comuna + SLEP + Región | 4.140 | 4 | 2.861 (69,1 %) | 3.608 (87,1 %) | 3.824 (92,4 %) | 3.937 (95,1 %) | 4.016 (97,0 %) |
| 2° medio 2025 | Nacional | 20 | 0 | 0 (0,0 %) | 0 (0,0 %) | 0 (0,0 %) | 0 (0,0 %) | 0 (0,0 %) |

Barras con `N` exactamente igual al umbral (lo que agregaría leer la marca como `N ≤ u` en lugar de `N < u`):

| Nivel | Tipo | N = 5 | N = 10 | N = 15 | N = 20 | N = 30 |
|---|---|---:|---:|---:|---:|---:|
| 4° básico 2025 | Comuna | 325 | 88 | 19 | 35 | 4 |
| 4° básico 2025 | SLEP | 19 | 15 | 20 | 12 | 0 |
| 4° básico 2025 | Región | 4 | 6 | 5 | 0 | 1 |
| 4° básico 2025 | Comuna + SLEP + Región | 348 | 109 | 44 | 47 | 5 |
| 4° básico 2025 | Nacional | 0 | 0 | 0 | 0 | 0 |
| 2° medio 2025 | Comuna | 180 | 44 | 12 | 12 | 4 |
| 2° medio 2025 | SLEP | 69 | 8 | 4 | 0 | 0 |
| 2° medio 2025 | Región | 12 | 0 | 8 | 7 | 0 |
| 2° medio 2025 | Comuna + SLEP + Región | 261 | 52 | 24 | 19 | 4 |
| 2° medio 2025 | Nacional | 0 | 0 | 0 | 0 | 0 |

## 5. El SLEP foco y sus cuatro comunas, barra por barra

Cada celda: `N` y, entre paréntesis, los establecimientos con puntaje sin comparación válida (`+sin`). "EE en el roster": establecimientos
de la entidad en ese GSE, nivel y año (con o sin puntaje). Una fila con 0 no tiene barra (el motor dice "sin dato"). La barra del SLEP
cuenta solo los establecimientos del SLEP; la de cada comuna cuenta todos los de la comuna, de cualquier dependencia.

### 4° básico 2025

**SLEP Costa Central**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 10 | 10 | 10 | 10 | 10 |
| Medio bajo | 21 | 21 | 21 | 21 | 21 |
| Medio | 28 | 26 (+2) | 25 (+2) | 26 (+2) | 26 (+2) |
| Medio alto | 1 | 1 | 1 | 1 | 1 |
| Alto | 0 | — | — | — | — |

**CONCÓN**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 0 | — | — | — | — |
| Medio bajo | 1 | 1 | 1 | 1 | 1 |
| Medio | 6 | 6 | 6 | 6 | 6 |
| Medio alto | 2 | 2 | 2 | 2 | 2 |
| Alto | 5 | 5 | 5 | 5 | 5 |

**PUCHUNCAVÍ**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 2 | 2 | 2 | 2 | 2 |
| Medio bajo | 3 | 3 | 3 | 3 | 3 |
| Medio | 9 | 7 (+2) | 7 (+2) | 7 (+2) | 7 (+2) |
| Medio alto | 0 | — | — | — | — |
| Alto | 0 | — | — | — | — |

**QUINTERO**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 1 | 1 | 1 | 1 | 1 |
| Medio bajo | 4 | 4 | 4 | 4 | 4 |
| Medio | 4 | 4 | 4 | 4 | 4 |
| Medio alto | 1 | 1 | 1 | 1 | 1 |
| Alto | 0 | — | — | — | — |

**VIÑA DEL MAR**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 8 | 8 | 8 | 8 | 8 |
| Medio bajo | 29 | 29 | 29 | 29 | 29 |
| Medio | 33 | 33 | 32 | 33 | 33 |
| Medio alto | 16 | 16 | 16 | 16 | 16 |
| Alto | 23 | 20 (+3) | 19 (+3) | 20 (+3) | 20 (+3) |

### 2° medio 2025

**SLEP Costa Central**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 3 | 3 | 3 | 3 | 3 |
| Medio bajo | 6 | 6 | 6 | 6 | 6 |
| Medio | 3 | 3 | 3 | 3 | 3 |
| Medio alto | 0 | — | — | — | — |
| Alto | 0 | — | — | — | — |

**CONCÓN**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 0 | — | — | — | — |
| Medio bajo | 2 | 2 | 2 | 2 | 2 |
| Medio | 4 | 4 | 4 | 4 | 4 |
| Medio alto | 1 | 1 | 1 | 1 | 1 |
| Alto | 4 | 4 | 4 | 4 | 4 |

**PUCHUNCAVÍ**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 0 | — | — | — | — |
| Medio bajo | 3 | 3 | 3 | 3 | 3 |
| Medio | 0 | — | — | — | — |
| Medio alto | 0 | — | — | — | — |
| Alto | 0 | — | — | — | — |

**QUINTERO**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 0 | — | — | — | — |
| Medio bajo | 3 | 3 | 3 | 3 | 3 |
| Medio | 2 | 2 | 2 | 2 | 2 |
| Medio alto | 0 | — | — | — | — |
| Alto | 0 | — | — | — | — |

**VIÑA DEL MAR**

| GSE | EE en el roster | Autoestima | Convivencia | Participación | Hábitos |
|---|---:|---:|---:|---:|---:|
| Bajo | 3 | 3 | 3 | 3 | 3 |
| Medio bajo | 12 | 12 | 12 | 12 | 12 |
| Medio | 16 | 16 | 16 | 16 | 16 |
| Medio alto | 11 | 11 | 11 | 11 | 11 |
| Alto | 21 | 20 (+1) | 20 (+1) | 20 (+1) | 20 (+1) |

## 6. Barras con N = 0

| Nivel | Tipo | Con N = 0 | De ellas, con sin > 0 | De ellas, sin = 0 (ningún EE con puntaje) |
|---|---|---:|---:|---:|
| 4° básico 2025 | Comuna | 329 | 304 | 25 |
| 4° básico 2025 | SLEP | 4 | 4 | 0 |
| 4° básico 2025 | Región | 0 | 0 | 0 |
| 4° básico 2025 | Nacional | 0 | 0 | 0 |
| 2° medio 2025 | Comuna | 4 | 4 | 0 |
| 2° medio 2025 | SLEP | 0 | 0 | 0 |
| 2° medio 2025 | Región | 0 | 0 | 0 |
| 2° medio 2025 | Nacional | 0 | 0 | 0 |

## 7. N distinto entre los cuatro indicadores de una misma fila

§5.2 habla del "N de la fila" bajo el nombre de la entidad. Una fila del comparador (entidad × GSE) tiene cuatro barras, y su `N`
puede diferir entre indicadores (puntaje o comparación publicados para unos indicadores y no para otros).

| Nivel | Tipo | Filas | Filas con N distinto entre indicadores | Diferencia máxima (máx − mín) en una fila |
|---|---|---:|---:|---:|
| 4° básico 2025 | Comuna | 1.151 | 111 | 3 |
| 4° básico 2025 | SLEP | 127 | 29 | 3 |
| 4° básico 2025 | Región | 80 | 40 | 15 |
| 4° básico 2025 | Nacional | 5 | 5 | 55 |
| 2° medio 2025 | Comuna | 854 | 7 | 1 |
| 2° medio 2025 | SLEP | 101 | 1 | 1 |
| 2° medio 2025 | Región | 80 | 6 | 2 |
| 2° medio 2025 | Nacional | 5 | 5 | 3 |

## 8. Alcance y límites

- Solo entidades **sin dependencia**. El comparador también admite la misma entidad acotada a una dependencia (clave `kind|cod|dep`);
  ahí `N` es igual o menor que el de la entidad completa. No se midió.
- Solo el año más reciente de cada nivel, que es el único que muestra el comparador.
- La misma barra (`StackedBar` con `repartoInd`) aparece en el panorama territorial (Vista actual, por GSE) y en la franja de la vista
  histórica del panorama (por año). Este diagnóstico cuenta las barras del comparador; no midió esas dos pantallas.

## 9. Lo que el titular decide

Ninguna de estas preguntas se responde aquí; cada una con sus alternativas cerradas.

1. **El umbral u.** ¿Qué valor fija la decisión de proyecto que pide §5.2? La tabla de §4 muestra qué fracción de barras marcaría
   cada valor medido (5, 10, 15, 20, 30) por tipo y nivel; otro valor exige volver a correr el script.
2. **La desigualdad.** ¿La marca aplica con `N < u` (lectura literal de "cae bajo un umbral", la usada en §4) o con `N ≤ u`
   (la tabla de §4 da cuántas barras agrega)?
3. **El alcance por tipo.** ¿El mismo umbral para comuna, SLEP, región y nacional, y para las entidades con dependencia, o umbrales
   distintos por tipo?
4. **El N visible de la fila (pieza 1 de §5.2).** Como el `N` difiere entre indicadores en parte de las filas (§7), ¿qué se muestra
   bajo el nombre: (a) los establecimientos del roster de la fila; (b) el `N` de cada barra, junto a la barra; (c) el mínimo de la fila?
5. **Las otras pantallas.** ¿La marca se limita al comparador o alcanza también las barras del panorama (Vista actual y vista histórica)?
6. **Las barras con N = 0.** Hoy dicen "sin dato" (y la nota `sin` cuando corresponde). ¿Quedan así o reciben la misma marca?

