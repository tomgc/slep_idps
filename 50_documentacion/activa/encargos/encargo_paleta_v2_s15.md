# Encargo autónomo a Claude Code — P-PALETA-v2 (sesión 15, slep_idps)

> **Modo:** autónomo, secuencial, ejecuta TODO en este turno. Lee el estado real
> antes de tocar cada archivo (Paso 0 de cada fase). No reportes "listo" sobre un
> estado supuesto: verifica el estado real (render, decodificar el build, contrastar
> contra el parquet).
>
> **Patrón:** este encargo sigue `encargo_autonomo_claude_code_v1.md` (KB). El
> análisis, la metodología y las decisiones de diseño ya están resueltos por el
> redactor; tú ejecutas la ruta.

---

## 0. Encabezado de contrato

- **Repo (raíz de código):** `/Users/tomgc/Projects/slep_idps`. Todos los comandos
  con ruta absoluta; `git -C /Users/tomgc/Projects/slep_idps`. Nunca asumas `cd`.
- **Stack:** R-only para el pipeline (R 4.5.x, Positron, macOS aarch64); el motor es
  React 18 + D3 v7 inline en `35_motor_template.html`, transpilado por Babel (regla
  A34: `runtime: "classic"`). No introduzcas Python.
- **Regla de detención (PARA y reporta, no improvises):**
  1. Un invariante 🔒 te obligaría a violar el contrato de datos/gobernanza.
  2. Un dato real contradice un supuesto de este encargo (p. ej. el border-left de la
     fase 3 no está donde se indica, o `DistBar` ya no existe con esa firma).
  3. Un gate estratégico marcado como decisión del titular. **No hay ninguno abierto
     en este encargo:** las dos decisiones de diseño (sentido de la rampa = Alto
     oscuro; rampa por familia del indicador) ya están tomadas. Si aparece una
     tercera, PARA.
- **Disciplina de git:** revisar `git status` ANTES de cada `git add`; commits
  atómicos temáticos por ruta; NUNCA `git add .` ni `git add -u`. Mensajes en
  español.

---

## 1. Contexto mínimo suficiente

Motor IDPS nacional, certificado y desplegado en `https://tomgc.github.io/slep_idps/`
(GitHub Pages sirve `docs/index.html` desde `main`). El build vivo es el de la PALETA
del folleto (HEAD `1d41c17`, build md5 `27679407577fd43f1d8a53806168e1f8`).

**Estado de partida que DEBES verificar en el Paso 0 de la Fase 0:** hay 6 commits
LOCALES sin desplegar de la sesión 14 (`b90ebd8`→`5a311de`: ajustes de presentación
del motor, fases 1/2/4 aprobadas + fase 3 RECHAZADA + build). El HEAD local debería
ser `5a311de` y el desplegado `1d41c17`. Confirma con
`git -C /Users/tomgc/Projects/slep_idps log --oneline -8`. Si el HEAD local no es
`5a311de`, PARA y reporta (el estado divergió de lo que el redactor analizó).

Archivos clave (rutas absolutas):
- Generador: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`
- Template: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
- Parquet (🔒 solo lectura): `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
- Build local: `/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html` y
  `/Users/tomgc/Projects/slep_idps/docs/index.html`
- Orquestador: `source(here::here("30_procesamiento","35_generar_motor_html.R"))` o
  `run_all(only=35)` desde `00_build.R`.

**Hallazgo que origina este encargo (H-s14-SEMAFORO):** los stacked de niveles
Bajo/Medio/Alto de las subdimensiones siguen en paleta SEMÁFORO, lo que contradice la
regla del titular (la identidad cromática de cada indicador gobierna TODO lo cromático
de ese indicador). Se corrige aquí.

---

## 2. Invariantes (🔒) — la red de seguridad de tu autonomía

- 🔒 **El parquet NO se toca.** md5 `4c764d8c9f0bf70004f8aa52661ae901`, 2.362.447
  filas. Se lee (solo lectura) en la regeneración; jamás se escribe. Verifica md5
  inicio==fin en la Fase 3.
- 🔒 **Las CIFRAS no cambian.** Este encargo es 100% color/layout de presentación.
  Ningún valor `prom/dif/sigdif/difgru/sigdifgru/niveles` se altera. La fidelidad
  censal parquet→sitio debe dar **mismatch 0** tras regenerar (mismo patrón que s14).
- 🔒 **Identidad de indicador.** Todo lo cromático de niveles vive en la familia del
  color del indicador padre. NO introduzcas colores ajenos a la familia. NO uses
  paleta semáforo.
- 🔒 **StackedBar (estado vs GSE) es INTOCABLE.** La función `StackedBar` del template
  (≈L709, segmentos `var(--alerta)/var(--st-neutro)/var(--destaca)`, ▼bajo/=neutro/
  ▲sobre) codifica SIGNIFICANCIA ESTADÍSTICA vs GSE, NO niveles de desarrollo. Es un
  invariante declarado en el propio código ("Colores de ESTADO del motor, DISTINTOS de
  la paleta de 4 indicadores"). **No la toques.** La superficie de este encargo es
  `DistBar` (niveles de subdimensión), no `StackedBar`.
- 🔒 **Accesibilidad no-textual.** La rampa monocromática NO puede ser el único canal:
  el orden Bajo→Alto debe seguir legible por etiqueta/texto (hoy lo es por el `title`
  de cada segmento y por la leyenda). Conserva esos canales textuales (lección
  A14-2: la verificación técnica no basta, pero la accesibilidad textual es invariante
  duro, no estético).
- 🔒 **No inventar** significancia/GSE/geo donde el dato trae NA (vigente desde v11).
- 🔒 **REGENERAR + RE-VERIFICAR antes de desplegar.** Nunca pushees un build sin haber
  corrido la fidelidad censal y el panel adversarial. NO desplegar a ciegas.

---

## 3. Fases en orden estricto

### FASE 0 — Cierre mecánico de s14 (deuda de higiene)

Limpia la deuda mecánica de s14 ANTES de tocar el motor, para que los commits de
P-PALETA-v2 queden limpios encima de un working tree ordenado.

**Paso 0 (leer estado real):**
```
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps log --oneline -8
```
Confirma HEAD local `5a311de` y working tree con archivos sueltos untracked (suite,
encargos, etc.). Si el estado no calza, PARA y reporta.

**Acciones:**
1. **Corregir la fecha/sesión** en
   `/Users/tomgc/Projects/slep_idps/50_documentacion/activa/decisiones/20260622_decision_paleta_indicadores.md`:
   dice "s12", debe decir "s14". Lee el archivo, localiza la mención, corrígela
   (solo esa; cambio quirúrgico).
2. **Actualizar `CLAUDE.md`** (`/Users/tomgc/Projects/slep_idps/CLAUDE.md`), sección
   "últimos cambios" (arrastrada sin actualizar desde v12/v13): reemplázala por el
   resumen de s14 (paleta del folleto desplegada; 4 ajustes de motor locales sin push,
   fase 3 rechazada; suite `suitedoc` generada con render pendiente; backlog A22
   reconciliado a 104). Lee la sección antes de reescribirla; conserva el resto del
   archivo intacto.
3. **Commits atómicos de archivos sueltos** (revisa `git status` antes de cada `add`;
   agrupa por tema, no `git add .`):
   - `docs(suite): suite suitedoc generada (s14)` → `50_documentacion/suite/`
     (incluye `documentar.R`, `inline_suite.R`, los 4 HTML, `suite_estilos.css`,
     `assets/`; `fonts/` solo si no está gitignorado — verifica el `.gitignore`).
   - `docs(decision): correccion fecha s12->s14 paleta` → el .md corregido en (1).
   - `docs(backlog): backlog historico consolidado (A22)` →
     `50_documentacion/activa/backlog_historico.md`. El `backlog_volcado_crudo.md`
     es insumo crudo de A22: si el titular no lo quiere versionar, déjalo untracked;
     en duda, NO lo commitees (es un volcado de trabajo, no producto).
   - `docs(encargos): encargos s14 (paleta, ajustes motor)` → los encargos de s14
     que estén untracked en `50_documentacion/activa/` (`encargo_ajustes_motor_s14.md`,
     `encargo_claude_code_idps_paleta.md` si no estaban trackeados).
   - `docs(estructura): snapshots escaner s14` → los pares en
     `50_documentacion/estructura/` que estén untracked.
   - `docs(claude): actualizar ultimos cambios CLAUDE.md (s14)` → `CLAUDE.md`.
   - Logs de s14 en `andamios/logs/` (`20260622_*`): commitéalos como
     `docs(logs): logs claude code s14` si no están versionados.
   - El `SETTINGS_Y_PROMPTS_OPERACIONALES.md` editado: commitéalo solo si el cambio
     pertenece a ESTE repo y no a la KB del Project. En duda, NO lo toques.

   **NO pushees todavía.** El push es la Fase 4, consolidado.

**Criterio de éxito Fase 0:** `git status` limpio (sin cambios sin commitear salvo lo
que se decidió dejar untracked); fecha corregida; `CLAUDE.md` actualizado; HEAD sigue
sin desplegarse.

---

### FASE 1 — Rampa monocromática de niveles (corrige H-s14-SEMAFORO)

**Superficie exacta** (verifica por lectura en el Paso 0): la distribución de niveles
Bajo/Medio/Alto de cada SUBDIMENSIÓN, renderizada por `DistBar` en el template.

**Paso 0 (leer estado real):** abre
`/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html` y localiza:
- L≈16: `--bajo:#E88663; --medio:#FFC92E; --alto:#75924E;` (variables CSS semáforo).
- L≈681-685: `function DistBar({v})` con
  `segs=[["bajo","var(--bajo)"],["medio","var(--medio)"],["alto","var(--alto)"]]`.
- L≈869: la llamada `<DistBar v={v}/>` dentro del bloque de subdimensión.
- L≈729-734: helpers `_hx/_toHex/_mix/_lighten/_darken` y `dimColor(mother,di,total)`.
- L≈1058: leyenda del panel con `<i style={{background:"var(--bajo)"}}>Bajo` etc.

Si alguna de estas anclas no aparece o difiere materialmente, PARA y reporta (el
template divergió del análisis).

**Metodología (decidida por el redactor; ejecútala):**

La rampa se deriva del **color del indicador padre**, una rampa por indicador (4
rampas), con **Alto = tono más oscuro/saturado, Bajo = tono más claro**. Reutiliza el
mecanismo `_lighten`/`_darken` ya presente (es la misma familia que `dimColor`, no
introduce colores nuevos).

1. **Crear un helper `nivelRamp(motherColor)`** junto a `dimColor` (≈L734), que
   devuelva los 3 tonos de la rampa a partir del color del indicador:
   ```js
   // Rampa monocromatica de NIVELES derivada del color del indicador padre.
   // Bajo = mas claro, Alto = mas oscuro/saturado (D-s15-RAMPA, titular).
   // Reutiliza _lighten/_darken (misma familia que dimColor; sin colores nuevos).
   // Degrada a la paleta vieja solo si el color no es hex (no deberia ocurrir).
   function nivelRamp(mother){
     if(!mother||mother[0]!=='#') return {bajo:"var(--bajo)",medio:"var(--medio)",alto:"var(--alto)"};
     return { bajo:_lighten(mother,0.45), medio:_lighten(mother,0.12), alto:_darken(mother,0.22) };
   }
   ```
   Los factores (0.45 / 0.12 / -0.22) son un punto de partida calibrado para dar
   contraste visible entre los 3 segmentos manteniéndolos reconocibles como la misma
   familia. Ajústalos si el contraste entre medio y alto, o entre bajo y el fondo
   `cream`, queda por debajo de ~3:1 (mismo criterio WCAG 1.4.11 que ya se aplicó a
   los swatches claros en P-PALETA). Documenta el valor final como constante.

2. **`DistBar` debe recibir el color del indicador padre.** Hoy su firma es
   `DistBar({v})`. Cámbiala a `DistBar({v,ramp})` donde `ramp` es el objeto de
   `nivelRamp(ind.color)`, y usa esos tonos en `segs`:
   ```js
   function DistBar({v,ramp}){
     const r = ramp || {bajo:"var(--bajo)",medio:"var(--medio)",alto:"var(--alto)"};
     const segs=[["bajo",r.bajo],["medio",r.medio],["alto",r.alto]];
     return <div className="bar">{segs.map(([k,c])=>{const val=v[k];if(val==null||val===0)return null;
       return <span key={k} style={{width:val+"%",background:c}} title={k+": "+fmt(val)+"%"}>{val>=9?fmt(val):""}</span>;})}</div>;
   }
   ```
   En la llamada (≈L869), pasa la rampa. El `ind.color` del indicador padre está
   disponible en ese subárbol (la sección está bajo `--ic`/`ind.color`, L904; el
   `DimBlock` conoce su indicador). Si en el punto de llamada exacto no tienes
   `ind.color` directo, deriva la rampa en el ancestro que sí lo tiene (la sección
   `indp`/`DimBlock`) y pásala hacia abajo como prop. **No reconstruyas el color desde
   otra fuente:** úsalo del indicador, que es la fuente de verdad.

3. **Leyenda (≈L1058) y cualquier `<i>` con `var(--bajo/--medio/--alto)`:** la leyenda
   es global al panel (mezcla subdimensiones de varios indicadores), así que NO tiene
   un único color de indicador. Decisión del redactor: en la leyenda, los cuadros
   Bajo/Medio/Alto pasan a una **rampa neutra de luminosidad** (gris claro→medio→
   oscuro) que comunica "esto es una rampa ordenada Bajo→Alto" sin atarse a un
   indicador, ya que el color real lo da cada barra en su contexto. Alternativa
   (repetir la leyenda por indicador) descartada: recarga el panel. Implementa la
   leyenda con tonos neutros y mantén las etiquetas textuales Bajo/Medio/Alto.

4. **Las variables CSS `--bajo/--medio/--alto` (L16):** NO las borres (siguen siendo
   el fallback de `nivelRamp` y de la leyenda si algo falla). Pero ya no son la fuente
   primaria de color de los segmentos. Déjalas como fallback documentado.

**Commit:** `style(motor): rampa de niveles monocromatica por indicador (H-s14-SEMAFORO)`.

---

### FASE 2 — Separador de dimensión como contenedor a escala (rehace fase 3 de s14)

**Paso 0 (leer estado real):** localiza en el template:
- L≈333-340: el comentario "Borde por dimension (s14)" y
  `.hist-dim{border-left:3px solid var(--ic,var(--azul));padding-left:11px;}` (la
  fase 3 RECHAZADA).
- L≈303: `.hist-ind{border:1px solid var(--linea);border-top:3px solid var(--ic,var(--azul));...}`
  (el contenedor del INDICADOR en la vista histórica — el modelo a escalar).
- L≈267: `.indp{...border-top:3px solid var(--ic,var(--azul));...}` (el mismo patrón
  en la vista actual).

**Metodología (decidida; el border-left no gusta, se quiere un contenedor a escala):**

1. **Revertir el border-left de dimensión.** Reemplaza
   `.hist-dim{border-left:3px solid var(--ic,var(--azul));padding-left:11px;}` por un
   estilo de **contenedor/marco a escala de dimensión**, análogo a `.hist-ind` pero un
   peldaño más sutil (la dimensión es subordinada al indicador). Patrón sugerido:
   ```css
   /* Separador de dimension (s15, rehace fase 3): contenedor a escala, analogo al
      del indicador (.hist-ind) pero subordinado. Marco completo con accent superior
      del color del indicador padre (--ic), no el border-left lateral rechazado. */
   .hist-dim{border:1px solid var(--cream-200);border-top:2px solid var(--ic,var(--azul));
     border-radius:var(--radius-2);padding:10px 11px;background:var(--paper);}
   ```
   Usa los tokens reales del template (verifica los nombres exactos: `--cream-200`,
   `--radius-2`/`--radius-3`, `--paper`, `--linea` aparecen en el archivo; usa los que
   existan). El objetivo visual: la dimensión se lee como una "caja" contenida dentro
   del indicador, con el accent del color del indicador en el borde superior, igual
   que el indicador pero a menor escala (borde más fino, radio menor).

2. **No dupliques `--ic`:** el contenedor de dimensión hereda `--ic` del ancestro
   `.hist-ind` (L992: `style={{"--ic":ind.color}}`). Confirma que `var(--ic)` resuelve
   dentro de `.hist-dim` por herencia CSS; si no, pásalo explícito en el JSX del bloque
   de dimensión (L998-1001) con `style={{"--ic":ind.color}}` o el `dcol` ya calculado.

3. Ajusta el espaciado circundante si el marco nuevo aprieta los elementos vecinos
   (`.hist-dim-h`, el gap entre dimensiones). Cambio quirúrgico, solo lo que el marco
   nuevo requiera.

**Commit:** `style(motor): separador de dimension como contenedor a escala (rehace fase 3 s14)`.

---

### FASE 3 — Regeneración + verificación de fidelidad (🔒 antes de desplegar)

**Paso 0:** registra el md5 del parquet ANTES:
```
md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet
```
Debe ser `4c764d8c9f0bf70004f8aa52661ae901`.

1. **Regenerar el motor:**
   ```
   cd /Users/tomgc/Projects/slep_idps && Rscript -e 'source(here::here("30_procesamiento","35_generar_motor_html.R"))'
   ```
   (o `run_all(only=35)` vía `00_build.R` si ese es el camino canónico — verifica en
   `00_build.R` cuál usa el proyecto). Copia/regenera también `docs/index.html` por el
   mecanismo que el proyecto ya tenga (el deploy de Pages sirve `docs/`).

2. **Verificar md5 del parquet DESPUÉS** = idéntico al de antes. Si cambió, PARA: algo
   escribió el dato (no debería).

3. **Fidelidad censal parquet→sitio** (patrón P-DISPLAY-FIDELITY de s12, adaptado a
   redondeo entero de s14). Decodifica el JSON embebido del build y contrasta contra
   `round(parquet, 0)`:
   - indicador/dimensión: `build$prom == round(parquet$prom, 0)`.
   - niveles: `build$bajo/medio/alto == round(parquet$niv_*_por, 0)`.
   - Censo completo (NO muestra). **Mismatch esperado = 0** salvo el fantasma rbd=NA
     (4 celdas, excluido por diseño, H-FID-1).
   El patrón completo vive en `50_documentacion/andamios/logs/20260622_ajustes_motor_s14_log.md`
   (§5, panel adversarial A) y en el encargo de display_fidelity de s12. Reúsalo.

4. **Panel adversarial (A21):** lanza agentes de solo-lectura que re-deriven con código
   INDEPENDIENTE (no copies de los checks inline) las tres afirmaciones de riesgo:
   - (A) Las cifras no cambiaron: build vs `round(parquet,0)`, mismatch 0.
   - (B) StackedBar (estado vs GSE) NO fue alterado: sus colores siguen siendo
     `--alerta/--st-neutro/--destaca`, su lógica de conteo intacta (grep + lectura).
   - (C) La rampa de niveles deriva del color del indicador y conserva el canal textual
     (cada segmento mantiene su `title` con bajo/medio/alto; la leyenda mantiene las
     etiquetas). Verifica que NO quedó ningún `DistBar` consumiendo `var(--bajo)` como
     color primario.
   3/3 debe PASAR. Si alguno falla, corrige y re-verifica; no reportes verde sobre un
   check rojo.

5. **Universo:** `n_distinct(rbd)` del build = 9.136 (sin cambio).

**Criterio de éxito Fase 3:** parquet md5 inicio==fin; fidelidad censal mismatch 0;
panel adversarial 3/3; universo 9.136; render del build sin errores de consola
(verifícalo abriendo el HTML).

---

### FASE 4 — Push consolidado

Solo si la Fase 3 cerró en verde. Un único deploy con: cierre mecánico (Fase 0) +
fases 1/2/4 de s14 ya commiteadas localmente + rampa (Fase 1) + separador (Fase 2).

1. `git -C /Users/tomgc/Projects/slep_idps status` completo: muéstralo en el log. NO
   debe haber sorpresas (archivos de datos, tokens, etc.).
2. Commit del build regenerado: `build(motor): regenerar con rampa de niveles + separador de dimension (s15)`.
3. Push a `main`.
4. Verifica el deploy: `live == local` (md5 del `docs/index.html` desplegado == local).
   Espera la propagación de Pages si hace falta y reconfirma.

**Criterio de éxito Fase 4:** HEAD desplegado == HEAD local; build vivo con la rampa y
el separador nuevos; `live==local` confirmado por md5.

---

## 4. Mandato de auto-auditoría

Antes de reportar, ejecuta el panel adversarial de la Fase 3 (ya está incluido ahí).
Para las superficies de color (rampa, separador), además del check de código, abre el
build y confirma visualmente que: (a) los stacked de niveles ya NO son rojo/amarillo/
verde sino tonos del color del indicador; (b) el separador de dimensión es un
contenedor a escala, no un border-left; (c) StackedBar (estado vs GSE) sigue en
alerta/gris/destaca. Recuerda A14-2: la verificación técnica no aprueba la
presentación; deja constancia en el log de qué quedó para revisión visual del titular.

---

## 5. Mandato del log y cierre

Escribe el log en
`/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260622_paleta_v2_s15_log.md`
siguiendo la plantilla fija (sección 4 de `encargo_autonomo_claude_code_v1.md`):
resumen, inventario de commits (todos, con hash/tipo/título), por cada cambio
sustantivo (qué/por qué/archivos/verificación), bugs si los hubo, verificación de
invariantes 🔒 (cada uno PASA/FALLA con evidencia), decisiones registradas, pendientes
y marcas `# REVISAR`, estado del parquet (md5 antes/después), notas para el revisor.
Honesto: incluye lo que costó. Commitéalo como `docs(log): log P-PALETA-v2 s15` o
déjalo untracked para revisión previa del titular (tu criterio; decláralo).

---

## 6. Reporte final al chat

Devuelve: HEAD final desplegado y local; md5 del parquet (antes==después); resultado
de la fidelidad censal (mismatch); veredicto del panel adversarial 3/3; los factores
finales de la rampa (`nivelRamp`) y del separador; confirmación visual de las 3
superficies; pendientes / `# REVISAR`; y la ruta del log.

---

## 7. Decisiones registradas (para trazabilidad)

- **D-s15-RAMPA:** rampa de niveles monocromática por familia del indicador padre;
  Alto = oscuro/saturado, Bajo = claro. Decisión del titular (sesión 15). Reemplaza el
  semáforo `--bajo/--medio/--alto` en `DistBar`. StackedBar (estado vs GSE) NO se toca.
- **D-s15-SEPARADOR:** separador de dimensión como contenedor a escala (marco con
  accent superior del color del indicador), análogo a `.hist-ind` subordinado. Revierte
  el border-left de la fase 3 de s14 (rechazado). Decisión del titular.
- **D-s15-LEYENDA-NEUTRA:** la leyenda global de niveles (multi-indicador) usa rampa
  neutra de luminosidad + etiquetas textuales, no se ata a un indicador. Decisión del
  redactor (la leyenda no tiene un único color de indicador padre).
