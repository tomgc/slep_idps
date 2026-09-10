# Encargo autónomo a Claude Code — Contraste del texto de estado (tokens de texto) y decisión de excepción

> Proyecto: `slep_idps`. Sesión origen: s29 (CONTINUATION), tercer encargo (s29c).
> Redactado tras medir el contraste real sobre el motor regenerado y con aprobación
> explícita del titular sobre el mockup
> `50_documentacion/andamios/diseno/detalles/mockup_contraste_estados.html`, que es
> la **referencia visual vinculante**: ábrelo antes de escribir código.

---

## 0. Contrato

- **Modo:** autónomo, secuencial, commit atómico por fase, `git add` a rutas exactas.
- **Stack:** CSS embebido en `30_procesamiento/35_motor_template.html` + un documento
  de decisión en markdown. Rutas absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención (PARA y reporta):**
  1. Si el cambio exigiera tocar los valores de `--alerta`, `--destaca` o
     `--st-neutro`: detente. Este encargo **añade** tokens, no modifica la paleta.
  2. Si tras regenerar cambia cualquier cifra del payload: detente y reporta el diff.
     El SHA-256 del JSON normalizado debe seguir siendo
     `b1fd3eb10d804e9ae5bc3990e91e9d1089c0a2766865cd8bca2c916a30bf4f7c`.
  3. Si el build falla o emite un warning nuevo: detente y reporta.
  4. **NO despliegues a `docs/`.** El despliegue es una decisión aparte del titular.

---

## 1. Contexto: la medición que origina el encargo

Contraste medido sobre el motor regenerado (Chromium, colores computados). WCAG 2.1
AA exige 4,5:1 para texto normal y 3:1 para texto grande (≥24px, o ≥18,66px en
negrita):

| Zona | Colores | Ratio | Exige | Estado |
|---|---|---|---|---|
| Tira externa (12px bold) | `#EE2D49` sobre crema | 3,93 / 4,04 | 4,5 | **falla** |
| Tira externa (12px bold) | `#2A8FD9` sobre crema | 3,33 / 3,42 | 4,5 | **falla** |
| Tira externa (12px bold) | `#7E8A99` sobre crema | 3,45 | 4,5 | **falla** |
| Etiqueta dentro de barra (14px bold) | blanco sobre rojo / neutro / azul | 4,11 / 3,51 / 3,48 | 4,5 | **falla** |
| Meta del chip, banda "no se agrega" | — | 4,59 / 5,58 | 4,5 | ok |

La paleta de ESTADO es identidad del folleto de la Agencia y un invariante del
proyecto: **no se toca**. La salida es separar *color de barra* de *color de texto*.

---

## 2. Invariantes (🔒)

1. 🔒 `--alerta`, `--destaca`, `--st-neutro` conservan sus valores actuales. Barras,
   glifos de la fila EE y muestras de la leyenda quedan **idénticos**.
2. 🔒 Los tokens nuevos se usan **solo** en texto pequeño sobre fondo claro. No entran
   a barras, bordes de glifo, fondos ni leyenda.
3. 🔒 Ninguna cifra cambia. Este encargo es color de texto y un documento.
4. 🔒 No se altera la regla de etiquetado adaptativo de s29 ni la estructura de la
   tira externa (grid de 3 posiciones).

---

## 3. Fases

### Fase 1 — Tokens de texto (commit `fix`)

1. En `:root`, junto a la paleta de estado y con comentario que explique su razón:

```
   --alerta-txt:#D2112D;      /* 4,50 sobre cream-200; 5,35 sobre panel */
   --destaca-txt:#1E6EA9;     /* 4,50 sobre cream-200; 5,35 sobre panel */
   --st-neutro-txt:#5F6A78;   /* 4,55 sobre cream-200; 5,41 sobre panel */
```

2. Aplicarlos en dos lugares y **solo** en esos dos:
   - `.s100-ext-it` — hoy toma el color inline del estado (`s.c`). Cámbialo para que
     use el token de texto según el estado (`ext-bajo` → `--alerta-txt`,
     `ext-neutro` → `--st-neutro-txt`, `ext-sobre` → `--destaca-txt`). Mejor por CSS
     que por estilo inline, ya que la clase de estado ya existe.
   - `.ee-st` (texto "bajo su GSE" / "sin diferencia" / "sobre su GSE" de la fila de
     establecimiento): pasa de gris de interfaz al token del estado que corresponde,
     en negrita, como en la sección 2 del mockup. Requiere que `CeldaEE` marque el
     estado con una clase (`ee-st bajo|neutro|sobre`).
3. No cambies tamaños de fuente en esta fase.

Commit: `fix(motor): tokens de texto accesibles para el estado vs GSE`

### Fase 2 — Decisión de proyecto (commit `docs`)

Nuevo archivo
`50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`,
con la estructura de las decisiones existentes de la carpeta. Debe dejar por escrito:

- **Qué se decide:** la paleta de estado no se modifica; se añaden tres tokens de
  texto para fondo claro; se aplican solo a la tira externa y al texto de estado del EE.
- **La excepción, explícita:** la etiqueta *dentro* de la barra (blanco sobre color
  de estado, 3,48–4,11) **no alcanza AA y se acepta así**, porque (a) corregirla
  exigiría alterar la paleta institucional o agrandar la etiqueta, lo que reduce
  cuántas caben dentro; (b) el dato es redundante: el mismo valor está en la tira
  externa, en el `title` del segmento y en el `aria-label` de la barra, que es lo que
  lee un lector de pantalla. Es decir, el bajo contraste **no oculta información**.
- **La tabla de mediciones** de §1 de este encargo, con su método (colores computados
  en navegador, fórmula WCAG 2.1) y su fecha.
- **Pendiente asociado:** la marca de "base pequeña" (sección 4 del mockup) queda al
  backlog; su umbral es una decisión metodológica que el titular aún no ha fijado.

Commit: `docs(decision): contraste del texto de estado y excepcion de la etiqueta interna`

### Fase 3 — Regenerar y auditar (commit `build`)

1. `Rscript -e 'source("00_build.R"); run_all(only = 35L)'`.
2. Verificación de cifras: las 6 métricas del bloque 7 y el SHA-256 del payload
   normalizado, como en §3.2 del log s29.
3. **Auditoría de contraste sobre el motor generado**, con la pantalla del comparador
   poblada (Chile + un SLEP + un EE): recorre `.s100-ext-it`, `.ee-st`, `.gse-sec-foot`,
   `.cmp-nota-ee` y `.cmp-cm`, calcula el ratio contra el fondo efectivo y reporta la
   tabla con los valores observados. Criterio: **0 fallas** en esas cinco zonas. La
   etiqueta interna de la barra queda fuera del criterio por la excepción de la Fase 2
   (repórtala igual, con su valor).
4. Verifica que la regla de etiquetado de s29 sigue intacta: 0 etiquetas cortadas a
   1200px y a 430px, 0 porcentajes duplicados.

Commit: `build(motor): regenera el motor con los tokens de texto accesibles`

### Fase 4 — Versionar los andamios pendientes y publicar (commit `docs` + push)

1. Versiona los archivos sin seguimiento **que corresponden a esta línea de trabajo**:
   - `50_documentacion/activa/encargos/encargo_claude_code_idps_comparador_entidades_s29.md`
   - `50_documentacion/activa/encargos/encargo_claude_code_idps_contraste_texto_estado_s29c.md`
   - `50_documentacion/andamios/diseno/detalles/mockup_comparador_ee_nacional.html`
   - `50_documentacion/andamios/diseno/detalles/mockup_contraste_estados.html`
   - `50_documentacion/estructura/20260704_222011_estructura.md` y `.txt`
   **Deja fuera** `50_documentacion/andamios/logs/20260711_contrato_contexto_idps_log.md`:
   ese archivo se declara a sí mismo "no commitear".
2. `git push origin main` con **todo** lo acumulado de la sesión.
3. Reporta el hash publicado y confirma que `origin/main` quedó igual a `HEAD`.

Commit: `docs(andamios): versiona encargos, mockups y escaner de estructura s29`

### Fase 5 — Log y reporte

Agrega una sección al log existente
`50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md`
(no crees uno nuevo: es la misma sesión) con los commits de s29b y s29c, la tabla de
contraste con valores observados y las decisiones tomadas. Reporte final: 5 líneas
más la tabla de commits.

---

## 4. Fuera de alcance (no ejecutar)

- Despliegue a `docs/index.html`.
- Marca de "base pequeña" y su umbral.
- Rama `feat/contrato-contexto` (2 commits locales sin push): no se toca.
- Tooltip "vs evaluación anterior" (heredado de s28).
