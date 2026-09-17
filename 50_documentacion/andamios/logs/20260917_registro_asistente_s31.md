# Registro del asistente: sesión s31 (slep_idps)

Fuente de la tabla §15 y de las fricciones (§16) del próximo traspaso (`SETTINGS_Y_PROMPTS_OPERACIONALES.md` §2.2.15 y §2.2.17). Cada fila se anota en el momento en que ocurre.

## Errores del asistente

| # | momento | disparador | que_paso | regla_violada | causa_raiz | salvaguarda_presente | patron | gatillo_observable | intentos_previos | costo |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Medición previa a la compuerta de repositorio (apertura) | asistente lo señaló espontáneamente | Un `git status` corrido desde la máquina Linux del puente dejó un `.git/index.lock` vacío en el repositorio, que ese shell no podía borrar | SETTINGS §1.2.6, "Ningún comando asume el entorno" | Se trató `git status` como un comando de solo lectura; en realidad refresca el índice, y el shell remoto no tenía permiso de borrado | SETTINGS | PAT-03, sobre un shell sin permiso de borrado | comando-entorno: git que escribe el índice en una carpeta montada sin permiso de borrado | 0 | 1 permiso de borrado pedido al titular; sin daño en el árbol |

## Fricciones

- friccion: el primer mapa de calor usaba una escala fija de 60 a 90 y un tono verde leído como "bueno" → escala calibrada y del blanco al color de cada indicador.
- friccion: el número sobre una pastilla blanca dentro de la celda de color se vio mal → el color del texto se elige por contraste entre negro, gris y blanco.
- friccion: la escala absoluta de 0 a 100 no distinguía entre celdas → color calibrado a los percentiles 5 y 95 del país; la leyenda dice solo 0 a 100.
- friccion: la leyenda de puntaje con la franja calibrada dentro de 0–100, y después con "≤65 / ≥84", no ayudaba y quedaba desalineada → panel de dos columnas con "0 [barra] 100".
- friccion: el encabezado 2019–21 iba en vertical → horizontal en dos líneas.
