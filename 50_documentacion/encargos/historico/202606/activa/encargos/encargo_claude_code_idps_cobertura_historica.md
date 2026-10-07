# Encargo autónomo a Claude Code — Documentar cobertura histórica IDPS

> Proyecto: `slep_idps`. Sesión origen: s25 (CONTINUATION). Patrón:
> `encargo_autonomo_claude_code_v1.md`. Redactado por el asistente de análisis
> tras verificar el estado real con el titular (parquet ya integra el histórico
> 2014–2025; md5 `4c764d8c…` confirmado intacto; cobertura confirmada contra el
> parquet).

---

## 0. Contrato

- **Modo:** autónomo, secuencial. Ejecuta todas las fases en este turno, en
  orden estricto. Commit atómico por fase.
- **Stack:** R-only para el pipeline; edición directa de `.R` y `.html`. Rutas
  SIEMPRE absolutas desde `/Users/tomgc/Projects/slep_idps`. No asumir `cd`
  previo.
- **Regla de detención (PARA y reporta, no improvises):**
  1. Si cualquier operación alterara `idps_largo.parquet` (este encargo NO toca
     datos; si algo lo modifica, es un bug — detente).
  2. Si la regeneración del motor cambia alguna cifra del payload más allá de la
     nota nueva (detente y reporta el diff).
  3. NO despliegues a `docs/`: el gate visual es del titular. El encargo termina
     con el build local listo para su revisión.

---

## 1. Contexto mínimo suficiente

- **Estado verificado (s25):** el script `34_leer_normalizar_idps.R` ya integra
  el histórico 2014–2019 (rama 3b, formato ancho → largo). El parquet
  `40_salidas/intermedios/idps_largo.parquet` tiene 2.362.447 filas, md5
  `4c764d8c9f0bf70004f8aa52661ae901`. El pendiente heredado "extender el
  PATRÓN_DATOS / integrar el histórico" estaba OBSOLETO: ya está hecho.
- **Cobertura real por familia (verificada contra el parquet):**
  - indicador: 2014–2025 (los 4 grados, con huecos de aplicación).
  - dimensión: 2018 (histórico) + 2022–2025 (moderno).
  - niveles: 2023–2025 (2024 para 6b/8b).
- **Huecos de cobertura por grado (NO son deuda de datos; son ausencia de
  aplicación del instrumento en origen):**
  - 6b: presente 2014–2016, 2018, 2024 (sin 2017, 2019, 2020–2023, 2025).
  - 8b: presente 2014–2015, 2017, 2019, 2025 (sin 2016, 2018, 2020–2024).
  - 2m/4b: presente 2014–2018, 2022–2025 (sin 2019, sin 2020–2021).
  - **Razón (provenance del titular, NO deducido):** 6b y 8b se aplican de forma
    intermitente (no anual). 2019: la aplicación de 2m/4b se interrumpió por el
    estallido social (incidentes tras el 18 de octubre); la Agencia informa que
    4b enfrentó alteraciones en varios establecimientos y 2m no pudo realizarse.
    Referencia pública: https://www.agenciaeducacion.cl/agencia-de-calidad-de-la-educacion-entrega-resultados-simce-2019-para-8-basico/
- **El motor expone SOLO 4b y 2m** (`10_configuracion.R`, `GRADOS_MOTOR <-
  c("4b","2m")`). El parquet conserva los 4 grados; el filtro es de
  presentación.
- **El motor ya clasifica los años sin dato** server-side: `eje_historico`
  (`35_generar_motor_html.R`, ~L411) marca cada año `con_dato` / `pandemia` /
  `no_eval`. El template los pinta en gris. Este encargo NO reimplementa esa
  lógica: solo añade la EXPLICACIÓN textual al usuario.

---

## 2. Invariantes (🔒)

- 🔒 **`idps_largo.parquet` intocable.** md5 debe seguir siendo
  `4c764d8c9f0bf70004f8aa52661ae901` al final. Ninguna fase toca datos; todo es
  documentación, comentario y presentación.
- 🔒 **`eje_historico` y su clasificación `no_eval`/`pandemia` NO se tocan.** La
  nota visible EXPLICA lo que esa lógica ya produce; no la duplica ni la altera.
- 🔒 **Separación de universos por capa (crítico — no propagar texto entre
  capas):**
  - La **decisión interna** y los **comentarios de código** documentan la
    cobertura de los **4 grados** (el universo del parquet), incluida la
    intermitencia de 6b/8b.
  - La **nota visible** del motor habla SOLO de **2019 / 4b / 2m** (el universo
    que el motor expone). NO menciona 6b/8b: confundiría sobre grados que el
    usuario no ve. NO copiar el texto de la decisión a la nota visible ni
    viceversa.
- 🔒 **NO deploy a `docs/`.** Build local para gate visual del titular.
- 🔒 Un cambio conceptual por commit; `git add` path-scoped, nunca `git add .`.

---

## 3. Fases

### Paso 0 de cada fase: leer el estado real antes de editar
`git status` al inicio. Antes de cada edición, abrir el archivo y localizar el
punto por CONTENIDO (A37), no por número de línea (los números de este encargo
son orientativos y pueden haber corrido).

---

### Fase 1 — Decisión interna (commit `docs`)

**Crear** `50_documentacion/activa/decisiones/20260625_decision_cobertura_historico_idps.md`,
autocontenido, con esta estructura (contenido en español pleno, neutro, sin
voseo, sin em-dashes, sin tildes en el NOMBRE de archivo — el nombre ya cumple):

1. **Contexto.** El pendiente histórico heredado (traspasos previos) describía
   un estado obsoleto: archivos supuestamente en `~/Desktop/idps`, `PATRON_DATOS`
   sin soporte histórico, integración pendiente. El estado real (verificado en
   s25): el histórico está integrado, desplegado y verificado. El parquet
   re-corrido es byte-equivalente al canónico (md5 `4c764d8c…` idéntico antes y
   después → script idempotente).
2. **Decisión.** La cobertura histórica disponible es la MÁXIMA que permite la
   fuente. Los años/grados ausentes son ausencia de aplicación del instrumento,
   NO datos pendientes de adquirir. El script `34` no requiere extensión.
3. **Cobertura real por familia** (tabla): indicador 2014–2025; dimensión 2018 +
   2022–2025; niveles 2023–2025 (2024 para 6b/8b).
4. **Cobertura por grado** (tabla con los años presentes de cada grado, los 4):
   2m y 4b → 2014–2018, 2022–2025 (9 años); 6b → 2014–2016, 2018, 2024 (5 años);
   8b → 2014–2015, 2017, 2019, 2025 (5 años).
5. **Razón de los huecos (provenance del titular).** 6b/8b intermitentes (no
   anuales). 2019: interrupción de 2m/4b por el estallido social; cita la
   referencia pública de la Agencia (URL de arriba) en estilo indirecto, NO como
   cita textual entrecomillada.
6. **Implicancia.** (a) Los huecos no se tratan como deuda de datos en sesiones
   futuras. (b) El motor solo expone 4b/2m; su nota visible se limita a 2019. (c)
   La intermitencia de 6b/8b se documenta aquí y en código, no en la UI.

Commit: `docs(decision): fija cobertura historica IDPS y razon de huecos (s25)`.

---

### Fase 2 — Constancia en el pipeline (commit `docs`)

Dos comentarios de constancia (NO lógica nueva; cambios quirúrgicos B.3):

**2a.** En `30_procesamiento/34_leer_normalizar_idps.R`, en el bloque del
manifiesto histórico (donde se define `PATRON_HISTORICO`, ~L67-70): añadir un
comentario que registre que la cobertura histórica tiene huecos por ausencia de
aplicación (6b/8b intermitentes; 2019 estallido para 2m/4b), con referencia a la
decisión `20260625_decision_cobertura_historico_idps.md`. NO tocar el patrón ni
la lógica.

**2b.** En `30_procesamiento/35_generar_motor_html.R`, junto al bloque
`eje_historico` / `ANIOS_PANDEMIA` (~L62 y ~L411): añadir un comentario que
ancle que los estados `no_eval` corresponden a ausencia de aplicación
documentada (intermitencia de grados; 2019 estallido), con referencia a la misma
decisión. NO tocar la clasificación.

Commit: `docs(pipeline): ancla razon de huecos de cobertura historica en 34 y 35`.

---

### Fase 3 — Nota visible al usuario (commit `feat`)

**Ampliar el `.ficha-explain` EXISTENTE** de la vista histórica en
`30_procesamiento/35_motor_template.html` (dentro de `<div className="hist-wrap">`,
el primer `.ficha-explain`). NO crear un bloque `.nota` nuevo: el `.ficha-explain`
ya explica los años en gris; se amplía ahí (evita duplicación, R10).

**Sustitución quirúrgica (B.3):** localizar por contenido la oración actual que
explica los grises:

> los años en <b>gris</b> no tuvieron evaluación del sistema (2020–2021 por
> pandemia; 2019 el grado no se evaluó)

y reemplazar SOLO el paréntesis escueto del 2019 por la explicación definitiva,
conservando intacto todo lo demás del `.ficha-explain` (promedio móvil, columna
"sin dato", carácter preliminar, etc.). El texto definitivo aprobado por el
titular (literal, no modificar; respeta tildes UTF-8):

> Algunos años no muestran resultados porque la evaluación no se aplicó. En 2019,
> donde correspondía aplicar la medición en 4° básico y 2° medio como cada año,
> la Agencia informa que debido a los incidentes en el país tras el 18 de octubre
> la aplicación de 4° básico enfrentó alteraciones en varios establecimientos y
> la de 2° medio no pudo realizarse. Un año sin resultados no significa un
> resultado bajo sino que indica que no hubo medición o que esta no fue válida
> según los estándares fijados por la Agencia.

**Costura:** integrar el texto de modo que fluya con la frase contigua sobre los
años en gris y la columna "sin dato"; no debe quedar una yuxtaposición abrupta.
Decisión de redacción de la costura: tuya, conservando el texto definitivo
íntegro y el resto del `.ficha-explain` sin cambios de contenido.

**Regenerar el motor** tras la edición del template:
```bash
cd /Users/tomgc/Projects/slep_idps && Rscript 00_build.R   # o el orquestador que regenera 40_salidas/motor_idps.html
```
(Verifica el nombre real del orquestador con `git status`/escáner antes; si es
`00_run_all.R` con un paso específico, úsalo.)

Commit: `feat(motor): amplia nota de vista historica con razon de 2019 (estallido)`.

---

### Fase 4 — Auto-auditoría antes de reportar

1. **Parquet intacto (🔒):** `md5 -q 40_salidas/intermedios/idps_largo.parquet`
   debe devolver `4c764d8c9f0bf70004f8aa52661ae901`. Si difiere, FALLA — reporta.
   (Este encargo no corre el `34`; el parquet no debería ni tocarse. Si lo
   regeneras por dependencia del build, confirma md5 idéntico igualmente.)
2. **Payload = solo la nota nueva:** descomprime el JSON embebido del
   `motor_idps.html` nuevo vs el baseline (`docs/index.html` = `01b0f14`) y
   confirma que la ÚNICA diferencia es el texto del `.ficha-explain`. Cero
   cambios en cifras, roster, ind/dim/niv, `eje_historico`,
   `primer_anio_familia`. Reporta el diff.
3. **Render (viewport 1280 explícito, R-VIEWPORT-RENDER):** la vista histórica de
   un EE con serie ≥2 años renderiza el `.ficha-explain` ampliado sin romper
   layout; 0 errores de consola; las barras y el eje contiguo intactos.
4. **Tildes:** confirmar que el texto nuevo conserva 4°/2°/país sin mojibake en
   el HTML final (UTF-8).

---

### Fase 5 — Log y reporte

- **Log** en `50_documentacion/andamios/logs/20260625_cobertura_historica_s25_log.md`
  (plantilla fija del patrón: resumen, inventario de commits con hash, por cada
  cambio qué/por qué/verificación, verificación de invariantes 🔒 con
  PASA/FALLA y evidencia, pendientes). Honesto: incluye lo que costó.
- **Reporte al chat:** hashes de los 3 commits; md5 del parquet (debe ser el
  canónico); resultado del diff de payload (solo la nota); resultado del render;
  ruta del log. Estado: build local listo, `docs/` SIN tocar (gate visual del
  titular pendiente).

---

## 4. Pendientes que este encargo DEJA anotados (NO ejecuta)

- Suite de documentación (`50_documentacion/suite/documentar.R`) y corpus
  conceptual: incorporar la cobertura histórica y su razón. Sesión/pasada propia
  (un cambio conceptual por intervención; la suite se regenera en su flujo).
- Tooltip por año `no_eval` en la vista histórica, derivado del `eje_historico`
  (mejora de UI; convierte la nota fija en explicación contextual por año).
- Cierre formal del pendiente histórico obsoleto en el traspaso v25 (lo hace el
  asistente de análisis al cerrar, no Claude Code).
