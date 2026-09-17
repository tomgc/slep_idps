# Encargo autónomo a Claude Code — Exportación de datos (CSV) e imagen, como el motor hermano

> Proyecto: `slep_idps`. Encargo **s30a** (primera sesión después de s29).
> Implementa P-EXPORTACION, pedido por el titular tras revisar el motor publicado:
> poder llevarse lo que está viendo, en vez de capturar pantalla. La referencia
> vinculante es `slep_simce_adecuado`, que ya lo tiene resuelto.

---

## 0bis. Insumos (contexto frío)

1. **Referencia vinculante:** `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`
   - `IconExport` (botón) — línea ~2721
   - `exportarCSV({entities, nivel, prueba, gseFilter})` — ~2732
   - `descargarBlob` — ~2981
   - `exportarGraficosSVG` y `rasterizarSvgAPng` (PNG 2x con tope de superficie) — ~2990-3050
   - barra donde viven los botones, con el selector de GSE al lado — ~3560 y ~4452
2. `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` — §8.2
   (convención de normalización del payload). **Trae una §44 sin commitear**: entra en
   el commit de la última fase.
3. `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`.
4. `CLAUDE.md` y `50_documentacion/activa/POLITICA_PROYECTO.md`.

**Regla aprendida en s29i, vigente aquí:** del hermano se copia la **forma**; los valores
de dominio (códigos de dependencia, glosas, categorías, nombres de columna) se leen de la
configuración de **este** motor. En `slep_idps` la dependencia tiene 4 categorías
(SLEP = `"4"`), no 5.

---

## 1. Contrato

- Modo autónomo secuencial, commit atómico por fase, `git add` a rutas exactas, rutas
  absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención:**
  1. Si exportar exigiera **calcular una cifra que la pantalla no muestra** (un promedio
     territorial, una tasa agregada): detente. El CSV exporta lo que se está viendo, con
     el mismo dato y los mismos filtros; no es un motor de cálculo paralelo.
  2. Si cambia cualquier cifra del payload: detente (diff de offsets; hash §8.2).
  3. Si el build falla o emite un warning nuevo: detente.
  4. Si `docs/index.html` no queda byte-idéntico al motor: detente.
- **Antes de empezar:** pide al titular que cierre el editor abierto sobre el repo (en
  s29i un `.git/index.lock` obsoleto bloqueó commits dos veces).

---

## 2. Fase 1 — Infraestructura de descarga (commit `feat`)

Copia del hermano, adaptado:

1. `descargarBlob(blob, fname)` — idéntico al del hermano (~2981).
2. `IconExport({label, icon, onExport})` — botón con icono y rótulo. Usa el lenguaje
   visual de **este** motor (tokens `--azul`/`--foco`, `.btn`), no el CSS del hermano.
3. Helper `aCSV(filas)`: separador `;`, comillas cuando el valor contiene `;` o `"`,
   **decimal con coma**, y **BOM UTF-8** al inicio (`"﻿"`). Es lo que hace que
   Excel en español lo abra en columnas y no en una sola.

Commit: `feat(export): infraestructura de descarga y boton de exportacion`

## 3. Fase 2 — CSV del comparador (commit `feat`)

Botón "Exportar CSV" en la barra de controles del comparador, junto al segmentador de
GSE (misma ubicación relativa que en el hermano).

Exporta **exactamente lo que la pantalla muestra**, respetando entidades elegidas, nivel,
año vigente, dependencia de cada entidad y GSE visibles. Dos tipos de fila, distinguidas
por una columna `tipo`:

- `tipo = "territorio"`: una fila por entidad × GSE × indicador, con
  `entidad, tipo_entidad, dependencia, gse, gse_label, indicador, indicador_label, n_con_dato, n_bajo, n_neutro, n_sobre, pct_bajo, pct_neutro, pct_sobre, nivel, anio, preliminar`.
  Los porcentajes son los mismos que pinta la barra (los de `pctRound`), para que el CSV
  no discrepe de lo que se ve.
- `tipo = "establecimiento"`: una fila por EE × indicador, con
  `entidad (nombre del EE), rbd, comuna, gse, indicador, puntaje, estado_vs_gse, nivel, anio, preliminar`.
  `estado_vs_gse` en palabras ("bajo su GSE" / "sin diferencia" / "sobre su GSE"), no el
  código crudo.

Nombre del archivo: `idps_comparador_<nivel>_<anio>.csv`.

Commit: `feat(export): CSV del comparador de entidades`

## 4. Fase 3 — CSV del panorama territorial y de la ficha (commit `feat`)

- **Panorama:** una fila por establecimiento × indicador del territorio y nivel vigentes
  (con su dependencia y GSE aplicados): `rbd, establecimiento, comuna, gse, indicador, puntaje, estado_vs_gse, nivel, anio, preliminar`. Si el territorio es **nacional**, el
  botón sigue disponible: el CSV sí puede traer las 6.717 filas aunque la grilla no se
  dibuje (esa restricción era de render, no de datos). Avisa del tamaño antes de generar.
- **Ficha:** una fila por año × indicador (y por dimensión cuando la vista histórica las
  muestra): `rbd, establecimiento, anio, familia (indicador|dimension), id, label, puntaje, estado_vs_gse, nivel, preliminar`.

Nombres: `idps_panorama_<territorio>_<nivel>_<anio>.csv` y `idps_ficha_<rbd>_<nivel>.csv`,
saneando el territorio a `[a-zA-Z0-9_]`.

Commit: `feat(export): CSV del panorama territorial y de la ficha`

## 5. Fase 4 — Exportar imagen donde hay gráfico vectorial (commit `feat`)

**Diferencia real entre los dos motores, que acota esta fase:** en el hermano todos los
gráficos son SVG, por eso puede componer un SVG grande y rasterizarlo. En `slep_idps`
solo el **radar de la ficha** es SVG (D3, `Radar`, línea ~735); las barras del panorama
y del comparador son HTML/CSS.

Por lo tanto:

1. Implementa `exportarSvg` y `rasterizarSvgAPng` (copiados del hermano, con su tope de
   superficie y sus alertas) y ofrécelos **solo en la ficha**, sobre el radar.
2. **No** intentes exportar como imagen el comparador ni el panorama: exigiría
   reconstruir en SVG lo que hoy es HTML. Anótalo como pendiente con esa razón escrita,
   para que la próxima sesión no lo redescubra.

Commit: `feat(export): imagen SVG y PNG del radar de la ficha`

## 6. Fase 5 — Regenerar, auditar y publicar

1. `run_all(only = 35L)`; fidelidad del payload (bloque 7 + diff de offsets).
2. **Verificación de fidelidad del CSV, exigida:** para un caso concreto (Chile + SLEP
   Costa Central en 4° básico, GSE Bajo, indicador 1), los conteos y porcentajes del CSV
   deben coincidir **exactamente** con los que pinta la barra en pantalla. Reporta ambos.
3. Verifica que el CSV abre en columnas con configuración regional española (separador
   `;`, decimal coma, BOM presente) y que los acentos se ven bien.
4. Auditoría de contraste de los botones nuevos (método de s29d–s29g) y regla de
   etiquetado intacta.
5. Promueve a `docs/index.html` (byte a byte) y `git push origin main`.
6. Log de la sesión + ESTADO.md al día. **Incluye la §44 sin commitear.**

Commits: `build(motor)`, `deploy(docs)` y `docs(log)`.

---

## 7. Fuera de alcance

- Exportación de imagen del comparador y del panorama (ver §5.2).
- P-VISTA-TERRITORIAL, §5.6 (texto sobre color de indicador), marca de base pequeña.
- `table-layout:fixed` sin `min-width` en `.cmp-table`: pendiente propio, anotado en s29i.
- Poder desmarcar entidades desde el modal al llegar al tope: decisión del titular.
- Rama `feat/contrato-contexto`.
