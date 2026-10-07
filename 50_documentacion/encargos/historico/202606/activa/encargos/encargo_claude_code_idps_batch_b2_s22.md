# Encargo autónomo — slep_idps, Batch B / Encargo 2 (#7, s22)

> Añade un campo editorial "qué refleja un puntaje alto" por indicador y lo muestra en
> la tarjeta del radar como bloque colapsable discreto. Toca DOS archivos: el generador
> R (`35_generar_motor_html.R`) y el template (`35_motor_template.html`). Modo autónomo,
> secuencial, este turno.
>
> **Estado de cierre especial:** se acumula ENCIMA de Batch A (4 commits, sin push) y
> Batch B/Encargo 1 (working tree, sin commitear). **NO commitees, NO push, NO deploy:**
> deja los cambios en el working tree, regenera, verifica y reporta. El titular decide
> el commit del lote Batch B después.
>
> **Diferencia con los encargos anteriores:** este SÍ cambia el payload (añade un campo
> al catálogo de indicadores). El invariante no es "byte-idéntico" sino **"el único
> cambio del payload es el campo nuevo `nivel_alto`; ninguna cifra cambia y el parquet
> queda intacto"**.

---

## Encabezado de contrato

- **Modo:** autónomo, secuencial. 2 fases (generador → template) en orden, este turno.
- **Stack:** R (generador) + HTML/JSX (template). Rutas absolutas. Raíz:
  `/Users/tomgc/Projects/slep_idps`.
  - Generador: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`
  - Template: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
- **Regla de detención (PARA y reporta):** (a) un invariante 🔒 que te obligue a violarlo;
  (b) el estado real no calza con lo descrito y no puedes localizar la zona con certeza;
  (c) tras regenerar, el diff del payload afecta algo más que el campo `nivel_alto` (alguna
  cifra cambió) — para y reporta, no lo des por bueno.
- **Build:** regenera el motor (`run_all(only=35)`) y verifícalo en navegador. NO commit,
  NO push, NO deploy.

## Invariantes (🔒)

- 🔒 Parquet `idps_largo.parquet` md5 `4c764d8c…` intocable. Este encargo NO toca datos
  medidos; solo añade texto editorial al catálogo de indicadores en el generador.
- 🔒 El texto "nivel alto" es de **nivel INDICADOR**, no de subdimensión (regla del corpus
  `idps_corpus_conceptual.md`). Se inyecta SOLO en el catálogo de los 4 indicadores y se
  muestra SOLO en la tarjeta del indicador. NO replicar por dimensión ni subdimensión.
- 🔒 Delta del payload acotado: el único campo nuevo en el JSON es `nivel_alto` dentro de
  cada `indicadores[]`. Ninguna cifra (prom, dif, sigdif, difgru, sigdifgru, prom_gse)
  cambia. Verifícalo comparando el payload viejo vs nuevo (debe diferir solo por el campo).
- 🔒 Bug s7-1: ningún comentario CSS contiene `*/` salvo el cierre real.
- 🔒 La definición ya existente (`definicion`, "¿Qué mide este indicador?") se conserva
  intacta; `nivel_alto` es un campo ADICIONAL, no la reemplaza.

## Contexto mínimo

- **Generador**, armado del catálogo de indicadores (~L118-125): `indicadores_lst` se construye
  por `lapply` sobre los 4 ids; cada elemento tiene `id, nombre, corto, color, definicion`. La
  `definicion` sale de `CAT$indicador_definicion` (catálogo parquet). Las constantes de
  identidad (`INDICADOR_LABELS`, `INDICADOR_CORTO`, `INDICADOR_COLORS`) viven ~L44-48.
- **Template**, tarjeta del indicador: el componente `Definicion` (~L590) ya renderiza la
  definición; se invoca en la tarjeta del indicador con `etiqueta="¿Qué mide este indicador?"`
  (~L1030). El patrón colapsable discreto "P-meta" existe en el CSS (~L136). El objeto del
  indicador en el cliente es `ind` (tiene `ind.definicion`, `ind.color`, etc.).

**Paso 0 de cada fase:** abre el archivo, localiza la zona por contenido (las líneas se
movieron en Batch A/B1). Si no calza, PARA y reporta.

---

## Fase 1 — Generador: constante `INDICADOR_NIVEL_ALTO` + campo `nivel_alto`

**Qué.** Añadir, como constante nombrada del generador (junto a las otras constantes de
identidad de indicador, C.10 de la política), los 4 textos editoriales de "qué refleja un
puntaje alto", y exponerlos en `indicadores_lst` como campo `nivel_alto`.

**Cómo.**
1. Junto a `INDICADOR_LABELS`/`INDICADOR_CORTO`/`INDICADOR_COLORS` (~L44-48), añade el vector
   nombrado por id ("1".."4"). Texto EXACTO (no editar; redactado desde el corpus, nivel
   indicador):

   ```r
   # Texto editorial "que refleja un puntaje alto" por indicador (nivel INDICADOR, no
   # subdimension; derivado de idps_corpus_conceptual.md, secciones "Por que importa" +
   # caracterizacion de nivel alto). Prosa de comunidad, no dato medido de la Agencia.
   INDICADOR_NIVEL_ALTO <- c(
     "1" = "Un puntaje alto refleja estudiantes que se perciben capaces de aprender y de lograr buenos resultados, con interes y disposicion frente al estudio. Suele acompanar a establecimientos que comunican confianza en las capacidades de sus estudiantes, reconocen sus avances y tratan el error como parte normal del aprendizaje.",
     "2" = "Un puntaje alto refleja un ambiente percibido como respetuoso, organizado y seguro por estudiantes, docentes y apoderados. Suele acompanar a establecimientos con normas claras y conocidas, mecanismos formativos de resolucion de conflictos y resguardo de la integridad fisica y psicologica de la comunidad.",
     "3" = "Un puntaje alto refleja estudiantes y apoderados que se involucran en la vida del establecimiento y un espacio que promueve la expresion de opiniones, la deliberacion y la representacion democratica. Suele acompanar a establecimientos con canales efectivos de comunicacion, organizaciones representativas activas y una identidad institucional positiva.",
     "4" = "Un puntaje alto refleja actitudes favorables hacia la alimentacion, la actividad fisica y el autocuidado, y la percepcion de que el establecimiento promueve esos habitos. Suele acompanar a establecimientos que educan sobre vida saludable, ofrecen oportunidades de actividad fisica y abordan tempranamente los riesgos de tabaco, alcohol y drogas."
   )
   ```

   (Sigue la convención del archivo: el generador fuerza UTF-8 pero las constantes se escriben
   en ASCII, como `INDICADOR_CORTO`. El texto va sin tildes ni ñ, igual que las demás
   constantes del generador. La acentuación de presentación, si el proyecto la aplica, corre
   por el mismo mecanismo que `definicion`; si `definicion` se muestra acentuada en runtime,
   confirma cómo y replica ese tratamiento — no introduzcas un mecanismo nuevo.)

2. En `indicadores_lst` (~L120-124), añade el campo:

   ```r
   indicadores_lst <- lapply(as.character(1:4), function(id) {
     d <- ind_def$indicador_definicion[ind_def$id_indicador == as.integer(id)][1]
     list(id = as.integer(id), nombre = unname(INDICADOR_LABELS[id]),
          corto = unname(INDICADOR_CORTO[id]), color = unname(INDICADOR_COLORS[id]),
          definicion = if (length(d) == 0 || is.na(d)) NULL else d,
          nivel_alto = unname(INDICADOR_NIVEL_ALTO[id]))
   })
   ```

**Criterio de éxito.** El JSON regenerado tiene `nivel_alto` en cada uno de los 4 indicadores
con el texto correcto; ninguna otra clave cambia.

---

## Fase 2 — Template: colapsable "Qué refleja un puntaje alto" en la tarjeta

**Qué.** En la tarjeta del indicador, bajo la definición ya visible, añadir un bloque
**colapsable discreto** que muestre `ind.nivel_alto`. Cerrado por defecto (la tarjeta no debe
alargarse de entrada); un disclosure sobrio lo abre.

**Cómo.**
1. Localiza la invocación de `Definicion` en la tarjeta del indicador (~L1030,
   `etiqueta="¿Qué mide este indicador?"`). Inmediatamente después, dentro del mismo
   contenedor `.indp-def`, añade el colapsable condicionado a `ind.nivel_alto`:

   ```jsx
   {ind.nivel_alto && (
     <details className="indp-alto">
       <summary>Qué refleja un puntaje alto</summary>
       <div className="indp-alto-txt">{ind.nivel_alto}</div>
     </details>
   )}
   ```

   (Usa `<details>/<summary>` nativo: accesible por teclado sin JS, degrada solo. Si el proyecto
   ya tiene un patrón de colapsable propio (busca "P-meta" en el CSS ~L136 o algún `details`
   existente), reutilízalo en vez de introducir uno nuevo; mantén la coherencia visual.)

2. CSS sobrio junto a `.indp-def` (~L284):

   ```css
   .indp-alto{margin-top:7px;}
   .indp-alto summary{cursor:pointer;font-size:var(--fs-xs);font-weight:var(--fw-bold);color:var(--gris);list-style:none;}
   .indp-alto summary::-webkit-details-marker{display:none;}
   .indp-alto summary::before{content:"+ ";font-weight:var(--fw-bold);}
   .indp-alto[open] summary::before{content:"– ";}
   .indp-alto-txt{font-size:var(--fs-base);color:#5a5142;line-height:1.55;margin-top:5px;}
   ```

   (Replica el color/tamaño del bloque definicional para coherencia; no inventes una jerarquía
   tipográfica nueva fuera de los 7 tokens `--fs-*`. Verifica que el comentario CSS no contenga
   `*/` interno, 🔒 s7-1.)

**🔒 de la fase:** el colapsable va SOLO en la tarjeta del indicador. NO lo agregues a los
bloques de dimensión (`DimBlock`) ni de subdimensión. El texto es de nivel indicador.

**Criterio de éxito.** En la tarjeta de cada indicador aparece, bajo "¿Qué mide?", un disclosure
"Qué refleja un puntaje alto" cerrado por defecto; al abrirlo muestra el párrafo del corpus;
accesible por teclado (foco + Enter); las dimensiones/subdimensiones NO lo tienen; render sin
error de consola.

---

## Auto-auditoría antes de reportar

Este encargo cambia el payload, así que el chequeo de datos es más estricto que en los lotes
solo-template. Principio general + verificación en navegador (sin panel adversarial: el cambio
es editorial, no de cifras, pero el delta del payload SÍ se audita):

1. **Delta del payload acotado (🔒, el chequeo central).** Extrae el JSON de ambos payloads
   (viejo y nuevo): descomprime el blob base64+gzip de cada `motor_idps.html` y compara. El
   único cambio debe ser la aparición de `nivel_alto` en los 4 indicadores. Reporta el método y
   el resultado (p. ej. diff del JSON normalizado = solo líneas `nivel_alto`). Si cambia
   cualquier cifra, PARA (regla de detención c).
2. **Parquet intacto:** md5 pre/post = `4c764d8c…`.
3. **Render:** en la tarjeta de los 4 indicadores, disclosure presente, cerrado por defecto,
   abre con el texto correcto; teclado OK; dimensiones/subdimensiones sin el bloque.
4. Sin errores de consola (salvo warning benigno de Babel).

## Log y cierre

Log en
`/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260624_batch_b2_s22_log.md`
(plantilla fija: resumen, por-cambio con verificación, **método y resultado del delta de
payload**, invariantes 🔒 PASA/FALLA, pendientes). Sin commitear.

**Estado de cierre:** NO commit, NO push, NO deploy. Los cambios (generador + template + build
regenerado) quedan en el working tree, encima de Batch A y B1. El titular decide el commit del
lote Batch B después.

## Reporte final al chat

- Confirmación de las 2 fases con evidencia (qué viste en la tarjeta de cada indicador).
- **Método y resultado del delta del payload**: cómo extrajiste y comparaste el JSON, y la
  confirmación de que solo cambió `nivel_alto` (ninguna cifra).
- Parquet md5 pre/post.
- Confirmación de que dimensiones/subdimensiones NO muestran el bloque (🔒 nivel indicador).
- Estado del working tree (generador + template + build sin commitear); ruta del log.
