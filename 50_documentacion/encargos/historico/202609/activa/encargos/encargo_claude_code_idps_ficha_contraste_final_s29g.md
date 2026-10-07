# Encargo autónomo a Claude Code — Últimos dos arreglos de contraste en la ficha y redespliegue

> Proyecto: `slep_idps`. Sesión origen: s29 (CONTINUATION), séptimo encargo (s29g).
> Cierra los dos ítems de la §5.5 que se arreglan con tokens ya existentes, documenta
> los otros dos como familia de un problema de diseño mayor, y redespliega.
> Es el último encargo de la línea de contraste.

---

## 0bis. Insumos (léelos antes que nada; este encargo se ejecuta en contexto frío)

Todas las referencias de tipo §N.N de este documento apuntan a estos dos archivos, no a
esta conversación. Léelos primero:

1. `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`
   — decisión vigente de contraste. De ahí salen: §3.4 (excepción de la etiqueta blanca
   dentro de la barra), §3.5 (excepción de los glifos `.ee-gl`), §5.3 (a/b/c), §5.4 y
   §5.5 (los cuatro hallazgos de la ficha, dos de los cuales cierra este encargo).
2. `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md`
   — log de la sesión s29 completa. De ahí salen: §8.2 (convención de normalización del
   payload para el hash de fidelidad) y §25 (el pendiente nuevo del titular, sin
   commitear todavía).
3. `CLAUDE.md` y `50_documentacion/activa/POLITICA_PROYECTO.md` — contexto del proyecto
   y reglas permanentes.

**Gate visual:** concedido por el titular el 2026-09-10 sobre esta línea de trabajo, y
ratificado el 2026-09-16 al pedir expresamente llegar hasta publicación. Por eso la
Fase 4 de este encargo **sí** redespliega a `docs/`, igual que hizo s29f.

**Método de medición del contraste** (el mismo de s29d–s29f, para que los números sean
comparables): colores computados en navegador; fondo efectivo compuesto hacia arriba
incluyendo el canal alfa y la `opacity` acumulada de cada capa; fórmula WCAG 2.1;
umbral 4,5 para texto normal y 3,0 para texto grande (≥24px, o ≥18,66px en negrita).
Verifica el instrumento con dos controles antes de confiar en él: `#000` sobre `#fff`
debe dar 21,00 y `#777` sobre `#fff` debe dar 4,48.

---

## 0. Contrato

- **Modo:** autónomo, secuencial, commit atómico por fase, `git add` a rutas exactas.
- **Stack:** plantilla `30_procesamiento/35_motor_template.html` (una línea de JSX y
  CSS), documentos markdown, promoción del artefacto. Rutas absolutas desde
  `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención:**
  1. Si cerrar alguno de los dos ítems exigiera tocar la paleta de ESTADO, la de
     INDICADOR o cualquier fondo: detente y reporta. Este encargo solo usa los tokens
     `-txt` que ya existen y quita una opacidad.
  2. Si cambia cualquier cifra del payload: detente (diff de offsets; hash con la
     convención de §8.2 del log).
  3. Si el build falla o emite un warning nuevo: detente.
  4. Si `docs/index.html` no quedara byte-idéntico a `40_salidas/motor_idps.html`:
     detente.
- **Estado del árbol al recibir esto:** el log de la sesión tiene una **§25 sin
  commitear** (pendiente nuevo solicitado por el titular). Entra en el commit de la
  Fase 5; no la descartes.

---

## 1. Fase 1 — Sufijo "· sig." del ancla (commit `fix`)

En la ficha, el sufijo `· sig.` / `· n.s.` del ancla lleva `opacity:.8` inline
(plantilla, ~línea 771). Con el color ya corregido en s29f queda igual en **3,72 / 3,30**;
a opacidad 1 da **4,61 / 4,69**.

Quita esa `opacity` del `style` inline de ese `<span>`. No cambies su tamaño
(`--fs-overline`) ni el texto. Si al quitarla el sufijo pierde la jerarquía visual que
la opacidad le daba, resuélvelo **sin** opacidad (por ejemplo, con el peso de fuente) y
dilo en el log.

Commit: `fix(motor): el sufijo de significancia del ancla deja de atenuarse`

## 2. Fase 2 — Spans de estado de `.ficha-explain` (commit `fix`)

Los spans "▼ rojo" / "▲ azul" del texto explicativo de la ficha usan los colores de
**barra** (3,68 / 3,12). Mismo remedio que los chips y el ancla: `--alerta-txt` y
`--destaca-txt`. Confirma midiendo; esperado ≥ 4,5.

Commit: `fix(motor): glosa de estados de la ficha con los tokens de texto`

## 3. Fase 3 — Documentar los dos que NO se tocan (commit `docs`)

En `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`:

- **§5.5 (1) y (3): resueltas** por las fases 1 y 2, con cifras antes/después.
- **§5.5 (2) `.defn-title` y §5.5 (4) etiqueta blanca sobre barra de dimensión:** se
  agrupan explícitamente con **§5.3 (b)** (vista histórica) en un solo ítem de backlog,
  porque son el mismo problema: **texto sobre un color de la paleta de INDICADOR**. Deja
  escrito que no se resuelven con un token (la paleta es identidad del folleto de la
  Agencia) sino decidiendo una regla general: qué hace el texto cuando cae sobre un
  color de marca (sacarlo del relleno, invertirlo según luminancia, o reservar una
  variante de texto por indicador). Pide mockup y aprobación del titular.

Commit: `docs(decision): cierra §5.5 (1) y (3) y agrupa el resto como problema de paleta de indicador`

## 4. Fase 4 — Regenerar, auditar y redesplegar (commits `build` + `deploy`)

1. `run_all(only = 35L)`; fidelidad del payload (bloque 7 + diff de offsets).
2. Auditoría de todo el texto visible, con compositing de alfa y `opacity`, en los tres
   escenarios a 1200px (panorama, comparador poblado, **ficha**).
   - **Criterio:** las únicas fallas admisibles son las excepciones escritas (§3.4
     etiqueta blanca dentro de la barra de estado; §3.5 glifos `.ee-gl`), lo exento en
     §5.3 (c) y el ítem de backlog de paleta de indicador (§5.3 b + §5.5 2 y 4).
3. Regla de etiquetado de s29: 0 cortadas y 0 duplicados a 1200px y 430px.
4. Promueve `40_salidas/motor_idps.html` a `docs/index.html` (copia byte a byte,
   verificada con `md5`).

Commits: `build(motor): regenera el motor con el contraste de la ficha cerrado` y
`deploy(docs): republica con los ultimos arreglos de contraste`

## 5. Fase 5 — Pendiente nuevo, log y publicación

1. **Registra el pendiente nuevo del titular** (ya descrito en la §25 del log, sin
   commitear): selector "Vista actual / Vista histórica" en el **panorama territorial**,
   análogo al de la ficha. Añádelo también al "Próximo paso" de
   `50_documentacion/activa/ESTADO.md`. **No lo implementes ni lo especifiques**: la
   §25 explica por qué la vista histórica de un territorio no puede ser la curva de la
   ficha (invariante de cero agregación) y que pide mockup previo.
2. Sección s29g en el log: commits, cifras antes/después, auditoría en los tres
   escenarios y constancia del redespliegue.
3. `git push origin main`; reporta el hash y confirma `origin/main == HEAD`.

Commit: `docs(log): registro de s29g y pendiente de vista historica territorial`

---

## 6. Fuera de alcance

- Paleta de INDICADOR como texto (§5.3 b, §5.5 2 y 4): backlog, pide mockup.
- Marca de "base pequeña": umbral metodológico sin fijar.
- Selector de vista en el panorama territorial: solo se anota.
- Rama `feat/contrato-contexto`; tooltip "vs evaluación anterior" (s28).
