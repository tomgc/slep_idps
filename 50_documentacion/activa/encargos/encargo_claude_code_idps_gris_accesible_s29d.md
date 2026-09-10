# Encargo autónomo a Claude Code — `--gris` accesible en todos los fondos del motor

> Proyecto: `slep_idps`. Sesión origen: s29 (CONTINUATION), cuarto encargo (s29d).
> Resuelve el pendiente §5.1 de
> `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`,
> con una salida distinta a la que ese documento recomendaba. El motivo está en §1:
> la auditoría completa del texto visible (no solo las cinco zonas del criterio de
> s29c) muestra que la falla es más amplia y en su mayor parte **anterior a s29**.

---

## 0. Contrato

- **Modo:** autónomo, secuencial, commit atómico por fase, `git add` a rutas exactas.
- **Stack:** CSS embebido en `30_procesamiento/35_motor_template.html`, más dos
  documentos markdown. Rutas absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención (PARA y reporta):**
  1. Si algún uso de `--gris` quedara sobre un fondo **oscuro** (banner azul u otro)
     y el cambio lo empeorara: detente y reporta cuáles, sin aplicar el cambio.
  2. Si cambia cualquier cifra del payload: detente. Verificación fuerte = diff de
     offsets del JSON descomprimido (solo los dígitos de `fecha_generacion` pueden
     diferir). Para el hash usa la convención escrita en §8.2 del log de la sesión;
     **no** reutilices el hash de s29, que no es reproducible (ver §4).
  3. Si el build falla o emite un warning nuevo: detente y reporta.
  4. **NO despliegues a `docs/`.**
- **Estado del árbol al recibir este encargo:** `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md`
  tiene una sección 11 **sin commitear**, escrita por el asistente de análisis
  (errores del asistente, insumo de la §15 del traspaso). No la descartes: entra en
  el commit de la Fase 4.

---

## 1. Contexto: la medición que cambia la recomendación

Auditoría de **todo el texto visible** del comparador poblado (Chile + un SLEP + un
establecimiento), colores computados en navegador, fondo efectivo compuesto hacia
arriba, fórmula WCAG 2.1, sobre el motor de `bbe77e3`:

| Zona | Fondo | Ratio | ¿La introdujo s29? |
|---|---|---|---|
| `.gse-sec-sub`, `.s100-nd` | `#F4E9CC` (cream-200) | **3,80** | no, preexistente |
| Casillas GSE activas (`.gfb.on`) | `#D4E4F1` | **3,53** | no, preexistente |
| `.cmp-cl`, leyenda ▼/=/▲ | `#FFF6E0` (cream) | **4,26** | no, preexistente |
| `.td-ee-rbd` (fila nacional) | `#FCFAF2` | 4,39 | sí |
| `.cmp-cm`, `.cmp-ck`, `.cmp-x`, `.td-ee-k`, `.td-ee-rbd` | `#F7FBFE` | 4,41 | sí |

`--gris` (`#6b7780`) falla en **5 de los 7 fondos** del motor. Un token paralelo
aplicado a cuatro selectores (la salida que proponía §5.1) taparía lo de s29 y
dejaría intacto lo peor, que es anterior. Por eso este encargo corrige el token en
la raíz.

`--gris` es gris de **interfaz**, no de la paleta institucional de estado: cambiarlo
no toca ninguna identidad de marca.

---

## 2. Invariantes (🔒)

1. 🔒 La paleta de ESTADO (`--alerta`, `--destaca`, `--st-neutro`) y sus tokens de
   texto (`-txt`, s29c) **no se tocan**.
2. 🔒 Los colores de INDICADOR (`--ind1..4`) no se tocan.
3. 🔒 Ninguna cifra cambia.
4. 🔒 No se altera la regla de etiquetado adaptativo de s29 ni la tira externa.
5. 🔒 `--gris` sigue siendo **un** token: no se crea un paralelo ni se reemplaza
   selector por selector.

---

## 3. Fases

### Fase 1 — Oscurecer `--gris` (commit `fix`)

1. En `:root`: `--gris:#6b7780` → `--gris:#5C666E`. Mismo tono (HSL con la misma H y
   S), solo menor luminosidad. Comentario de una línea con la razón y la fecha.
2. **Antes de dar por buena la fase**, enumera los usos de `--gris` sobre fondos
   oscuros (banner `--azul`, `.cmp-chrome`, `.pan-bar`) y reporta su ratio antes y
   después. Si alguno empeora por debajo de su mínimo, aplica la regla de detención 1.
3. No toques ningún otro color ni ningún tamaño de fuente.

Ratios esperados con `#5C666E` (calculados; confírmalos midiendo):

| Fondo | Antes | Después |
|---|---|---|
| `#F4E9CC` cream-200 | 3,80 | 4,85 |
| `#D4E4F1` casilla GSE activa | 3,53 | 4,51 |
| `#FFF6E0` cream | 4,26 | 5,45 |
| `#FCFAF2` fila nacional | 4,39 | 5,61 |
| `#F7FBFE` fila EE | 4,41 | 5,64 |
| `#FFFDF7` panel | 4,51 | 5,77 |
| `#FFFFFF` paper | 4,59 | 5,86 |

Commit: `fix(motor): --gris accesible en todos los fondos del motor`

### Fase 2 — Cerrar el pendiente en la decisión (commit `docs`)

Edita `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`:

- La §5.1 pasa de pendiente a **resuelta**, con fecha, y deja constancia de que la
  salida adoptada **no** fue la que ese documento recomendaba (token paralelo) sino
  oscurecer el token en la raíz, con el motivo: la falla afectaba a 5 fondos y su
  parte más severa era anterior a s29.
- Incorpora la tabla de §1 y la de la Fase 1 de este encargo, con su método.
- Añade una **excepción nueva, explícita**: los glifos de estado de la fila de
  establecimiento (`.ee-gl`: `▼` sobre `#FBE3E6` = 3,37; `=` sobre `#EDF0F3` = 3,07)
  quedan por debajo de 4,5 y se aceptan tratándolos como **componente gráfico**
  (mínimo 3:1, que sí cumplen): el glifo va acompañado del texto del estado, que
  ahora cumple AA, de modo que la información no depende del glifo.

Commit: `docs(decision): cierra §5.1 con --gris accesible y anota la excepcion de los glifos`

### Fase 3 — Regenerar y auditar (commit `build`)

1. `Rscript -e 'source("00_build.R"); run_all(only = 35L)'`.
2. Fidelidad: bloque 7 idéntico y diff de offsets del JSON (solo `fecha_generacion`).
3. **Auditoría de contraste de TODO el texto visible**, no solo de una lista de
   selectores: recorre los elementos con texto propio, calcula fondo efectivo y ratio,
   y reporta los que quedan bajo su mínimo. Escenarios: comparador poblado a 1200px y
   panorama territorial a 1200px.
   - **Criterio:** 0 fallas atribuibles a `--gris`.
   - Excepciones esperadas y ya documentadas, que no cuentan como falla: la etiqueta
     blanca dentro de la barra (§ decisión s29c) y los glifos `.ee-gl` (Fase 2).
   - **Aviso para que no persigas fantasmas:** un instrumento que no compone el canal
     alfa contra el fondo real da dos falsos positivos conocidos: el botón de nivel
     inactivo del banner (`.lvl-b`, texto crema sobre `rgba(255,255,255,.12)` encima
     del azul) y el texto de la banda "no se promedia" (sobre `rgba(255,201,46,.16)`).
     Compón el alfa antes de declarar falla, o verifícalos a mano.
4. Regla de etiquetado de s29: 0 cortadas y 0 duplicados a 1200px y 430px.

Commit: `build(motor): regenera el motor con --gris accesible`

### Fase 4 — Log y publicación

1. Amplía el log de la sesión
   `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` con una
   sección s29d: commits, tabla de contraste antes/después con valores observados,
   usos sobre fondo oscuro verificados, y el resultado de la auditoría completa.
   **Incluye en el commit la sección 11 preexistente sin commitear** (ver §0).
2. `git push origin main`.
3. Reporta el hash publicado y confirma `origin/main == HEAD`.

Commit: `docs(log): registro de s29d y errores del asistente de la sesion`

---

## 4. Nota sobre el hash de fidelidad

El encargo s29c fijó como regla de detención un SHA-256 que no era reproducible: el
asistente de análisis lo copió del log de s29 sin la receta de normalización, que ese
log no registraba. El error está registrado en la §11 del log. Desde aquí la referencia
es la convención escrita en §8.2 (`"fecha_generacion":"0000-00-00"`, UTF-8, sin salto
final) y, sobre todo, el diff de offsets, que no depende de ninguna convención.

---

## 5. Fuera de alcance (no ejecutar)

- Despliegue a `docs/index.html`.
- Marca de "base pequeña" y su umbral (decisión metodológica del titular).
- Rama `feat/contrato-contexto`.
- Tooltip "vs evaluación anterior" (heredado de s28).
