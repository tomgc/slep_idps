# Encargo autónomo — Ajustes de presentación del motor IDPS (sesión 14)

> **Para:** Claude Code (modo autónomo, secuencial, ejecuta todo en este turno).
> **De:** asistente de análisis (redactor del encargo).
> **Proyecto:** `slep_idps` · raíz `/Users/tomgc/Projects/slep_idps`
> **Patrón:** `encargo_autonomo_claude_code_v1.md` (contrato de tres partes).
> **Naturaleza:** 4 ajustes de PRESENTACIÓN del motor `35`. Ninguno toca el dato:
> todos pasan por regenerar + re-verificar fidelidad censal antes de desplegar.

---

## 1. Encabezado de contrato

- **Modo y disciplina:** autónomo, secuencial. Ejecuta las 4 fases en orden en
  este turno. Commit atómico temático por fase. No pidas confirmación entre
  fases ya aprobadas.
- **Regla de detención (PARA y reporta solo si):**
  (a) un invariante 🔒 te obligaría a violar el contrato de datos/fidelidad;
  (b) un dato real contradice un supuesto de este encargo (p. ej. los rangos de
  año por familia no calzan con lo auditado);
  (c) la re-verificación de fidelidad falla (mismatch ≠ 0 fuera de lo esperado).
  En esos casos reporta y espera; no improvises metodología.
- **Reglas canónicas heredadas (no se re-explican; ver POLITICA_PROYECTO.md):**
  rutas absolutas siempre; R-only; `here::here()`; sin asumir `cd`; nunca
  `git add .` ni `git add -u` (add explícito por archivo); commits temáticos en
  español.

---

## 2. Contexto mínimo suficiente

El motor es un HTML autocontenido generado por `35_generar_motor_html.R` a partir
de `35_motor_template.html` (plantilla con React 18 + D3 inline) y del parquet
`40_salidas/intermedios/idps_largo.parquet`. El generador serializa el dato a
JSON columnar (gzip+base64), lo inyecta en la plantilla y escribe
`40_salidas/motor_idps.html`, que se copia a `docs/index.html` para GitHub Pages.

Rutas exactas:
- Generador: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`
- Plantilla: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
- Parquet:   `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
- Salida:    `/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html`
- Deploy:    `/Users/tomgc/Projects/slep_idps/docs/index.html`
- Regenerar: `run_all(only = 35)` (o `regenerar_motor()`), desde `00_build.R`.

**Hechos auditados en esta sesión (no re-derivar, son la base del encargo):**
- Los decimales de `prom` son NATIVOS de la Agencia; `34` los lee verbatim; el
  único redondeo es de presentación en `35` (`round(.,1)`). Auditoría en
  `50_documentacion/andamios/logs/20260622_auditoria_decimales_prom_log.md`.
- Rangos de año con dato sistémico POR FAMILIA (grados 4b+2m), confirmados contra
  el parquet:
  - **indicador:** 2014–2018 + 2022–2025 (valor en `prom`).
  - **dimension:** 2018 + 2022–2025 (valor en `prom`).
  - **niveles:**   2023–2025 (valor en `niv_bajo_por`; en esta familia `prom` es
    NA siempre — NO usar `prom` para detectar presencia de niveles).
- El eje histórico hoy se construye SOLO por grado (derivado del roster = familia
  indicador) en `35` L385–399 (`eje_historico`), y las tres familias se dibujan
  sobre ese mismo eje. Por eso dimensión y niveles muestran años vacíos al frente
  (los "años fantasma"). El generador ya deriva años preliminares y estados
  con_dato/pandemia/no_eval server-side (el template solo pinta).

---

## 3. Invariantes (🔒)

1. 🔒 **El parquet no se toca.** `idps_largo.parquet` md5
   `4c764d8c9f0bf70004f8aa52661ae901`. Verificar md5 al inicio y al final; deben
   ser idénticos. Ningún ajuste de este encargo lee/escribe el parquet salvo el
   `read_parquet` normal del pipeline.
2. 🔒 **Fidelidad censal de cifras.** Tras regenerar, la re-verificación
   parquet→sitio debe dar mismatch = 0 EXCEPTO por el cambio intencional de
   redondeo (entero en vez de 1 decimal). Es decir: `build == round(parquet, 0)`
   para `prom` (indicador/dimensión) y para `niv_*_por` (niveles), al 100%.
3. 🔒 **Universo intacto:** 9.136 establecimientos en el motor (filtro de 1 RBD
   fantasma `rbd=NA` por diseño, H-FID-1). El conteo no cambia.
4. 🔒 **Lógica metodológica intocable:** las anclas de la VISTA ACTUAL ("vs su
   GSE" = `difgru/sigdifgru`, y "vs año anterior" = `dif/sigdif`) NO se tocan
   (template L907, L1019). La comparación interanual de la VISTA HISTÓRICA
   (`BarrasAnio`, "vs {año}") es CORRECTA y NO se toca. Ningún ajuste de este
   encargo altera qué columna se lee para comparar.
5. 🔒 **Paleta de indicadores de s14 intacta** (folleto oficial: Autoestima
   `#3858A3`, Convivencia `#61BDC6`, Participación `#4BA560`, Hábitos `#AACB58`).
   Los ajustes 3 (borde) y 4 (espaciado) usan estos colores; no los redefinen.
6. 🔒 **Sin agregación territorial.** Ningún ajuste introduce un cálculo agregado.
   Todo es presentación del dato por establecimiento.

---

## 4. Fases en orden estricto

Orden con criterio: lo determinista (redondeo, contrastable contra el parquet)
y la lógica de datos (eje por familia) antes que lo estético (borde, espaciado).

### FASE 1 — Decimales a entero (presentación)

**Paso 0 (leer):** abre `35_generar_motor_html.R` y localiza L359, L364, L370–371
(serialización de `prom` de indicador y dimensión, y de `niv_bajo/medio/alto_por`).
Confirma que son las únicas superficies donde se redondea el valor mostrado.

**Implementación:** cambia el redondeo de 1 decimal a entero en las cuatro:
- L359 `prom = round(ind$prom, 1)` → `round(ind$prom, 0)`
- L364 `prom = round(dim$prom, 1)` → `round(dim$prom, 0)`
- L370 `bajo = round(niv$niv_bajo_por, 1)` → `round(niv$niv_bajo_por, 0)`
- L371 `medio = round(niv$niv_medio_por, 1)`, `alto = round(niv$niv_alto_por, 1)` → `, 0)`

Usa `round(x, 0)` (no `as.integer`, que truncaría; `round` respeta
round-half-even, consistente con el resto del pipeline). El JSON quedará con
valores enteros (R los serializa sin `.0`).

**Verificación template:** comprueba que NINGÚN punto del template re-formatee el
número asumiendo decimal (busca `toFixed`, `.0`, formato es-CL de decimal sobre
estos campos). Si el template aplicaba `toFixed(1)` a un puntaje, ajústalo a
entero para coherencia. Reporta qué encontraste.

**Criterio de éxito (B.4):** en el JSON regenerado, `prom` de indicador/dimensión
y `bajo/medio/alto` de niveles son enteros; el contraste `build == round(parquet,0)`
da 100% de coincidencia (parte de la Fase de verificación final).

**Commit:** `style(motor): puntajes y niveles a entero en presentacion (s14)`

### FASE 2 — Recorte de eje por familia (años fantasma)

**Paso 0 (leer):** estudia en `35` la construcción de `grado_anios` (L373–377),
`eje_historico` (L385–399) y `cobertura_anios` (L401–403). Entiende que hoy el eje
es por grado y se deriva del roster (familia indicador). Abre en el template
`serieEje` (~L752) y los componentes que la consumen (`BarrasAnio`, paneles de
indicador/dimensión, ~L981/L989) para ver cómo se mapea el eje a columnas.

**Diseño a implementar (la lógica vive en R; el template solo pinta):**

1. En `35`, calcular el **primer año con dato sistémico por familia**, derivado
   del dato (NO hardcodeado), usando la columna correcta de cada familia:
   - indicador: primer `agno` con `!is.na(prom)` en `familia=="indicador"`.
   - dimension: primer `agno` con `!is.na(prom)` en `familia=="dimension"`.
   - niveles:   primer `agno` con `!is.na(niv_bajo_por)` en `familia=="niveles"`.
   (Filtrar a los grados del motor.) Resultado esperado, a verificar contra el
   dato: indicador 2014, dimensión 2018, niveles 2023. Si el dato arroja otro
   valor, USA EL DEL DATO y repórtalo (regla de detención b solo si contradice
   groseramente lo auditado).

2. Embeber en `meta` un `primer_anio_familia` (lista nombrada:
   `indicador`/`dimension`/`niveles` → año entero). NO recortes el `eje_historico`
   global (sigue siendo el del grado, base del indicador); el recorte se aplica
   POR FAMILIA en el render.

3. En el template, cada panel filtra el eje a los años `>= primer_anio_familia[fam]`
   ANTES de mapear columnas. Dentro de ese rango recortado, los huecos sistémicos
   (pandemia 2020–2021, no_eval) se conservan como columnas grises EXACTAMENTE
   como hoy (no cambia el tratamiento del hueco; cambia dónde empieza el eje).
   Para dimensión: el eje empieza en 2018 → se ve 2018 (con_dato) · 2019–2021
   (gris) · 2022–2025. Para niveles: empieza en 2023. Para indicador: empieza en
   2014 (sin cambio visible respecto a hoy).

**Criterio de éxito (B.4):**
- Panel de dimensión: ya NO muestra columnas 2014–2017. Primera columna = 2018.
  Hueco 2019–2021 gris visible. Luego 2022–2025.
- Panel de niveles (si tiene serie temporal visible): primera columna = 2023.
- Panel de indicador: sin cambios (sigue 2014→2025 con sus huecos).
- Las columnas "sin dato" de un EE específico DENTRO del rango de la familia se
  conservan (no se eliminan; solo se eliminan los años previos al primer año
  sistémico de la familia).

**Commit:** `feat(motor): recorte de eje por familia, elimina anios sin dato sistemico (s14)`

### FASE 3 — Borde por dimensión (separación visual)

**Paso 0 (leer):** localiza en el template el bloque que renderiza cada dimensión
en el drill-down (los `BarrasAnio` de dimensión, ~L989) y el CSS asociado.

**Implementación:** añade un borde sutil del color del indicador padre a cada
bloque de dimensión, para que las dimensiones se distingan entre sí y los años no
se lean como un continuo. Sugerencia: `border` o `border-left` de 1–2px con el
color del indicador (la variable de color que el componente ya recibe, p. ej.
`dcol`/`ind.color`), con opacidad o tono suave (no saturado). CSS; sin tocar la
paleta (🔒 5), solo consumirla. Respeta la regla de comentarios CSS (nunca la
secuencia literal de cierre de comentario dentro de un comentario).

**Criterio de éxito (B.4):** cada bloque de dimensión queda visualmente separado
del siguiente, con un borde del color de su indicador; render sin errores de
consola.

**Commit:** `style(motor): borde por dimension con color del indicador (s14)`

### FASE 4 — Espaciado pestaña establecimiento

**Paso 0 (leer):** compara en el template el espaciado del header y el
`ficha-explain` de la pestaña "Panorama IDPS por establecimiento" contra la
pestaña "Panorama territorial" (que tiene el espaciado correcto). Identifica la
clase/regla CSS que difiere (margin/padding entre el header azul y el bloque
explicativo).

**Implementación:** iguala la separación de la pestaña establecimiento a la de la
territorial (aumentar el margin/padding superior del `ficha-explain` o inferior
del header, según corresponda). CSS puro.

**Criterio de éxito (B.4):** el header y el `ficha-explain` de la pestaña
establecimiento tienen la misma holgura que la pestaña territorial; sin
solapamiento ni pegado.

**Commit:** `style(motor): igualar espaciado header/ficha-explain en pestana establecimiento (s14)`

### FASE 5 — Regeneración y verificación de fidelidad (🔒)

**Paso 0:** registra el md5 del parquet ANTES (debe ser `4c764d8c…`).

1. Regenera el motor: `run_all(only = 35)`. Verifica que corre sin error y que
   escribe `40_salidas/motor_idps.html`.
2. Copia a `docs/index.html` (como hace el flujo de deploy del proyecto).
3. **Re-verificación censal parquet→sitio** (mismo patrón que P-DISPLAY-FIDELITY
   de s12, adaptado al redondeo entero): decodifica el JSON del build y contrasta,
   para indicador/dimensión, `build == round(parquet, 0)` en `prom`; para niveles,
   `build == round(parquet, 0)` en `niv_bajo/medio/alto_por`. Censo completo, no
   muestra. Reporta nº de celdas y mismatch (debe ser 0 salvo el fantasma rbd=NA
   excluido por diseño). Verifica también:
   - dif/sigdif/difgru/sigdifgru SIN cambio (no se tocaron) → byte-idénticos vs el
     build anterior salvo donde el redondeo de prom no influye.
   - universo = 9.136 EE.
   - rangos de eje por familia: el JSON de `meta` trae `primer_anio_familia`
     correcto (indicador 2014, dimensión 2018, niveles 2023).
4. **Verificación visual** (render en navegador): las 4 correcciones se ven
   (enteros, eje de dimensión desde 2018, bordes, espaciado). Captura evidencia.
5. **md5 del parquet DESPUÉS** = idéntico al inicio (🔒 1).

**Criterio de éxito (B.4):** mismatch = 0 (salvo redondeo intencional y fantasma);
parquet intacto; universo 9.136; los 4 ajustes visibles; sin errores de consola.

**Commit:** `build(motor): regenera docs/index.html con ajustes de presentacion s14`

---

## 5. Auto-auditoría antes de reportar (panel adversarial)

Este encargo toca cifras mostradas (redondeo) y el eje (qué años se ven), ambos de
riesgo. Tras completar las fases, lanza un **panel adversarial** de solo lectura
que re-derive de forma INDEPENDIENTE (código propio, no tus checks inline):

- **Agente A (fidelidad de redondeo):** desde el parquet crudo, calcula
  `round(prom,0)` y `round(niv_*,0)` y contrasta contra el JSON del build, para una
  muestra censal. Confirma mismatch = 0. Debe re-leer el parquet por su cuenta, no
  confiar en el contraste de la Fase 5.
- **Agente B (eje por familia):** desde el parquet, deriva el primer año con dato
  de cada familia (con la columna correcta por familia) y confirma que coincide con
  el `primer_anio_familia` embebido en el JSON. Verifica que el build NO contiene
  columnas de dimensión para 2014–2017 ni de niveles para 2014–2022.
- **Agente C (no-regresión metodológica):** confirma que las anclas de la vista
  actual (difgru/sigdifgru y dif/sigdif) y la comparación de la vista histórica
  siguen leyendo las mismas columnas que antes del encargo (diff del template en
  esas zonas = solo lo intencional). Que el 🔒 4 se respetó.

Si cualquier agente encuentra una discrepancia no explicada por el cambio
intencional, PARA y reporta antes de dar por bueno el trabajo.

---

## 6. Log y cierre

- Escribe el log en `50_documentacion/andamios/logs/20260622_ajustes_motor_s14_log.md`
  siguiendo la plantilla fija del protocolo (resumen, inventario de commits por
  fase, por cada cambio causa/efecto/verificación, bugs si hubo, verificación de
  invariantes 🔒 con PASA/FALLA y evidencia, decisiones registradas, pendientes,
  estado de cifras con md5 parquet antes/después, notas para el revisor).
- **Honesto:** incluye lo que costó, no solo los éxitos.
- Puedes dejar el log SIN COMMITEAR (para revisión previa del usuario) o
  commitearlo como `docs()` atómico aparte. Indica cuál elegiste.
- **NO publiques nada más allá de `docs/index.html`.** No toques otros archivos.

---

## 7. Reporte final al chat

Devuelve: (a) inventario de commits con hash corto; (b) resultado de la
re-verificación de fidelidad (nº celdas, mismatch); (c) md5 del parquet antes y
después; (d) confirmación de los 4 ajustes con evidencia (incluida la captura
visual); (e) `primer_anio_familia` embebido; (f) veredicto del panel adversarial
(A/B/C, PASA/FALLA); (g) pendientes o marcas `# REVISAR`; (h) ruta del log.

---

## 8. Decisiones del usuario ya tomadas (registradas, no volver a preguntar)

- Puntajes Y niveles → **entero** (no 1 decimal). Auditoría probó decimales
  nativos; es decisión de presentación.
- Eje de dimensión: 2018 se **mantiene** como punto aislado con hueco visible
  (opción A), no se separa.
- Recorte de eje: **por familia** (indicador 2014, dimensión 2018, niveles 2023),
  derivado del dato.
- La comparación interanual de la captura 4 (vista histórica) es correcta: **NO se
  toca** (P2 descartado tras auditoría).
- Borde por dimensión: color del indicador padre, sutil.
