# Decisión: polígono GSE de referencia en el radar (reapertura de la ponderación IDPS)

- **Fecha:** 2026-06-24
- **Sesión:** s21
- **Estado:** vigente
- **Reabre:** `20260612_decision_ponderacion_idps.md` (regla "lee, no deriva", en lo relativo al GSE en el radar)
- **Evidencia de respaldo:** `50_documentacion/andamios/logs/20260624_diagnostico_gse_reconstruccion_log.md`

---

## Contexto

La decisión `20260612_decision_ponderacion_idps.md` estableció que el motor "lee, no
deriva": el GSE se usa como navegación/etiqueta y su relación con el establecimiento se
expresa solo mediante `difgru`/`sigdifgru` (desvío y significancia leídos del dato),
**nunca** dibujando una línea o puntaje GSE absoluto en el radar. El comentario L12 de
`35_generar_motor_html.R` materializa esa decisión: "no se dibuja la linea absoluta del
GSE".

El fundamento de esa prohibición era que el puntaje absoluto del grupo de comparación
**no es una cifra publicada por la Agencia**: reconstruirlo por aritmética y presentarlo
en escala 0–100 sugeriría una precisión que la Agencia no respalda y podría leerse como
dato oficial cuando sería una derivación nuestra.

Ese fundamento ya no se sostiene. La Agencia **sí publica** el puntaje absoluto del grupo
de comparación. En la ficha del establecimiento (simce.cl), sección "Comparación con
establecimientos de similar GSE", muestra como cifra en escala 0–100 el "Puntaje promedio
nacional del mismo GSE", junto al puntaje del establecimiento y la diferencia en puntos
(caso observado: establecimiento 74, GSE 74, diferencia 0 pts). Es una cifra pública,
rotulada y verificable contra el sitio de la Agencia.

Surge entonces la pregunta de diseño: representar ese puntaje GSE publicado como un
**polígono de referencia** sobre el radar de cada establecimiento (un trazo GSE por
detrás del trazo del establecimiento), análogo al overlay temporal año-vs-año que el
motor ya dibuja.

## Decisión

Se **habilita** dibujar el polígono GSE de referencia en el radar de indicadores, bajo
las siguientes condiciones, todas obligatorias:

1. **El puntaje GSE se obtiene como `prom_GSE = prom − difgru`**, a nivel indicador, con
   `prom` y `difgru` leídos del parquet. Se usa el `prom` **crudo del parquet** (no el
   redondeado del payload) menos `difgru`, para eliminar cualquier riesgo de ±1 si en el
   futuro la Agencia publicara decimales.
2. **El trazo se omite donde no hay dato.** Si `difgru` o `cod_grupo` son NA (toda la
   serie 2014–2023, y los establecimientos sin GSE asignado), el polígono GSE **no se
   dibuja** para ese establecimiento/año. Nunca se degrada a 0 ni a un valor por defecto
   (NA = supresión, nunca cero; invariante del proyecto).
3. **Solo a nivel indicador.** `difgru` no existe en dimensión ni en niveles; el polígono
   GSE es exclusivamente de los 4 indicadores, coherente con los ejes del radar.
4. **Rótulo explícito de procedencia.** El trazo se etiqueta de forma que comunique que
   es el "Puntaje promedio nacional del mismo GSE" (la misma denominación que usa la
   Agencia), no un puntaje del establecimiento ni un promedio territorial.

En consecuencia, **se actualiza la decisión `20260612_decision_ponderacion_idps.md`**: la
prohibición de dibujar el GSE absoluto en el radar queda levantada para el puntaje del
grupo de comparación publicado por la Agencia, reconstruido según el punto 1. El resto de
"lee, no deriva" sigue vigente (sin agregación territorial, sin ponderación entre
establecimientos, significancia leída de `sigdif`/`sigdifgru`).

## Justificación

- **La cifra es pública.** El "Puntaje promedio nacional del mismo GSE" lo publica la
  Agencia en la ficha del establecimiento. Representarlo no expone un dato que la Agencia
  reserve; reproduce información que ella misma difunde.
- **La reconstrucción es exacta, no aproximada.** El diagnóstico read-only del 2026-06-24
  confirmó `prom_GSE = prom − difgru` por tres vías independientes: (a) el signo de
  `difgru` quedó fijado por el cruce perfecto `sign(difgru) × sigdifgru` (cero fuera de
  diagonal; `difgru>0 ⟺ sigdifgru=+1 ⟺` establecimiento sobre su GSE); (b) consistencia
  intra-grupo con `sd = 0` exacta (el `prom_GSE` reconstruido es idéntico entre todos los
  establecimientos de un mismo `cod_grupo`/indicador/año/grado, como debe serlo el
  promedio de un grupo); (c) el caso publicado 74/74/0 reproducido. `prom` y `difgru` son
  enteros en las 114.509 filas reconstruibles, así que no hay pérdida por redondeo (delta
  entero-vs-crudo = 0). Cero valores imposibles (<0 o >100).
- **La derivación es honesta, no encubierta.** Reconstruir `prom − difgru` es derivar, no
  leer una columna. Esta decisión no pretende lo contrario: afirma que la derivación
  reproduce sin pérdida una cifra que la Agencia publica, y el motor la rotula como tal.
  La distinción entre "leer" y "reconstruir sin pérdida una cifra pública" es la que
  separa esta decisión de lo que la original quiso evitar (inventar precisión no
  respaldada).
- **El radar es decisión de diseño nuestra.** La Agencia publica el par de puntajes como
  gráfico de barras por indicador; representarlos como polígono sobre el radar es una
  elección de visualización del motor, legítima, que no altera los valores.

## Alternativas consideradas

- **Mantener la prohibición (no dibujar el polígono GSE).** Descartada: el fundamento
  original (cifra no publicada) ya no aplica; conservar la prohibición dejaría al motor
  ofreciendo menos que el propio sitio de la Agencia, sin razón metodológica.
- **Dibujar el polígono sin rótulo de procedencia.** Descartada: sin rótulo, el trazo GSE
  podría confundirse con otro puntaje del establecimiento. El rótulo es condición, no
  adorno.
- **Degradar a 0 (o a la media) donde falta `difgru`.** Descartada: viola el invariante
  "NA = supresión, nunca cero" e introduciría un GSE ficticio en 2014–2023.
- **Reconstruir desde el `prom` redondeado del payload.** Descartada como vía por
  defecto: aunque hoy el delta medido es 0, usar el `prom` crudo del parquet es la opción
  robusta ante decimales futuros. (Sin recomendación fuerte: hoy ambas dan idéntico
  resultado; se elige la cruda por robustez, no por diferencia observada.)

## Implicancia

- **Cobertura limitada a 2024–2025.** El polígono GSE solo aparecerá en 2024 (83.1 % de
  filas-indicador) y 2025 (91.1 %); en 2014–2023 no se dibuja por ausencia de `difgru` en
  el dato. La interfaz debe tratar esta ausencia como intencional (igual que los huecos de
  pandemia), no como error.
- **Código a tocar (sesión de implementación aparte, no en esta decisión):**
  `35_generar_motor_html.R` (incluir `prom_GSE` reconstruido en el payload del indicador,
  o el insumo para reconstruirlo en cliente) y `35_motor_template.html` (trazo del
  polígono GSE en el radar, su rótulo, y el manejo del caso sin dato). El comentario L12
  de `35_generar_motor_html.R` ("no se dibuja la linea absoluta del GSE") debe
  actualizarse para reflejar esta decisión.
- **Accesibilidad.** El nuevo trazo necesita un canal no cromático (rótulo/leyenda) que lo
  distinga del trazo del establecimiento y del overlay temporal, para no descansar solo en
  color (lección del panel adversarial de sesiones previas).
- **Invariantes que siguen 🔒:** parquet intocable (md5 `4c764d8c…`); fidelidad censal
  mismatch 0; sin agregación territorial ni ponderación entre establecimientos;
  significancia siempre leída, nunca recalculada.
- **Gobernanza:** sin implicancia sobre datos sensibles. El GSE y su puntaje son públicos;
  no se expone ningún establecimiento por nombre ni dato individual.
