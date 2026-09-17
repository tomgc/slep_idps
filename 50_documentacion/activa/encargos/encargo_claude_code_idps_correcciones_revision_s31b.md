# Encargo autónomo a Claude Code: correcciones de la revisión de s31

> Proyecto: `slep_idps`. Encargo **s31b**, continuación de s31. Patrón: `herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md` (v1.6).
> Origen: revisión independiente del 2026-09-17 sobre el motor regenerado (seis lentes, refutación adversarial de cada hallazgo y crítico de completitud). Sobrevivieron tres hallazgos y el crítico agregó dos; los cinco están abajo, con la medición que los reprodujo.
> **Sigue sin desplegar a `docs/`**: el despliegue espera el visto bueno visual del titular sobre el motor corregido.

---

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en serie. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus 0.
- **ENTORNO:** Claude Code en la estación macOS del titular, repositorio `/Users/tomgc/Projects/slep_idps`, rama `main`.
- **INTÉRPRETE:** shell con `bash -c '…'`; cálculo sobre datos con `Rscript`; rutas absolutas, sin `cd` previo.
- **INSUMOS:** `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`; `50_documentacion/andamios/logs/20260917_vista_historica_territorial_s31_log.md`; `30_procesamiento/35_motor_template.html`; `CLAUDE.md`.
- **LOG:** `50_documentacion/andamios/logs/20260917_correcciones_revision_s31b_log.md` (log propio; el de s31 está commiteado y **no se edita**: una corrección es una línea nueva que cita a la anterior).
- **PRUEBAS:** sin arnés (`tests/` vacío). Lo sustituye `Rscript -e 'source("/Users/tomgc/Projects/slep_idps/00_build.R"); run_all(only = 35L)'` con exit 0 y sin warnings nuevos, más la fidelidad del payload de §4 del encargo s31 (SHA-256 `1e29c2b5…b5b6` sin el bloque `vista_territorial`).
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain` (esperado: solo ` M 40_salidas/motor_idps.html`, que s31 dejó regenerado), `git stash list` (vacío) y `git rev-parse --short HEAD` (esperado `cbcfdc8`).
- **Topes:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando.

### 0.1 Regla de detención

1. Si el `git status` de FASE 0 muestra algo distinto de ` M 40_salidas/motor_idps.html` → detente.
2. Si la fidelidad del payload deja de dar `1e29c2b5…b5b6` → detente: este encargo no toca R ni el payload.
3. Si una corrección exigiera cambiar una cifra de la barra o del CSV → detente: aquí solo se corrigen rótulos, ubicación y accesibilidad.
4. Si `run_all(only = 35L)` falla o emite un warning nuevo → congela la tarea en curso.
5. Si una verificación da un valor distinto del `esperado:` → congela la tarea y registra la diferencia.
6. **Cualquier estado, conteo o resultado no enumerado aquí → congela ESTA tarea, regístrala como duda y sigue con la próxima tarea independiente.**

### 0.2 Autorizaciones (lista cerrada)

- `git commit` de las rutas del ALCANCE de cada tarea, tras su verificación.
- `git add 40_salidas/motor_idps.html` junto con el commit de la última tarea de código, en un commit propio `build(motor): regenera con las correcciones de la revision`. (Resuelve la duda D-2 de s31: **sí** se commitea el motor regenerado; `docs/` sigue intacto.)
- `git push origin main` en FASE L, solo con FASE R en `APROBADO` o `APROBADO CON ADVERTENCIAS` y `git status --porcelain` vacío.
- `git revert <hash>` de un commit propio de esta sesión.
- Escribir mediciones en `/tmp/idps_s31b/`.

Nada más. No está autorizado tocar `docs/`, `push --force`, `reset`, `restore`, `checkout --`, ni borrar archivos.

### 0.3 Grafo

```
T1 (nota +N en su columna)      independiente
T2 (banner por GSE)             independiente
T3 (rótulo de sección)          independiente
T4 (accesibilidad de la matriz) independiente
T5 (correcciones del log s31)   independiente
FASE R y FASE L                 corren siempre, al final, fuera del grafo
```

---

## 1. Invariantes 🔒

Los siete de s31 siguen vigentes y FASE R los vuelve a correr con los mismos comandos (§2 del encargo s31), con `<PR>` = `cbcfdc8`. Se agrega uno:

- **🔒8 Ninguna cifra cambia.** Las barras del panorama y del comparador, sus porcentajes y el CSV quedan exactamente como están hoy.
  ```bash
  git -C /Users/tomgc/Projects/slep_idps diff cbcfdc8..HEAD -- 30_procesamiento/35_motor_template.html | grep -E '^[-+]' | grep -nE 'repartoInd|pctRound|sigdifgru|n_sin_comparacion|filasComparadorCSV'
  ```
  Esperado: salida vacía. Si una corrección obligara a tocar esas funciones, es un BLOQUEA.

---

## 2. Tareas

### T1 — La nota "+N sin comparación publicada" va bajo su barra (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Defecto medido:** `StackedBar` devuelve un Fragment y sus hijos entran como ítems del grid `.pan-dist-row` (300 px | 1fr). Cuando no hay tira externa, la nota cae en la celda del rótulo, a 316 px a la izquierda de la barra que califica; cuando sí la hay, cae bajo la barra. En la pantalla de apertura (SLEP Costa Central, 4° básico, sección Medio) la nota salta de columna entre filas: Autoestima y Participación la muestran bajo el nombre del indicador, Convivencia y Hábitos bajo la barra (medición en navegador: `dx` = −316, 0, −316, 0 px respecto del borde izquierdo de la barra).
- **Corrección:** envolver la salida de `StackedBar` en un contenedor propio, como ya hacen la celda de la franja y el `<td>` del comparador, de modo que barra, tira externa y nota vivan en la misma columna en las tres pantallas.
- **Verificación** (navegador, motor regenerado): en la sección Medio del SLEP foco, 4° básico, para los cuatro indicadores.
  - `esperado:` `dx` = 0 px en los cuatro (la nota empieza donde empieza la barra).
  - Calibración: la misma medición sobre el motor actual da −316, 0, −316, 0; es el caso malo conocido.
  - `esperado:` en el comparador y en la franja de la vista histórica, la nota sigue bajo su barra (0 px) y ninguna barra se desalinea.
- Commit: `fix(panorama): la nota de sin comparacion publicada va bajo su barra`.

### T2 — El banner de la vista histórica cuenta comunas del mismo universo que establecimientos (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Defecto medido:** `univBanner = isHistPan ? rosterHist : unidades`, pero `rosterHist` no está filtrado por `gseVis` y `nHist` sí. En nacional, 4° básico, vista histórica, con solo el GSE "Alto" encendido, el banner dice "346 comunas · 555 establecimientos con resultado en algún año · 4° básico · 1 de 5 GSE"; esos 555 establecimientos viven en 96 comunas. Es la reparación R-25 de s31 a medias: se verificó con los cinco GSE encendidos.
- **Corrección:** el universo del banner en la vista histórica se filtra por `gseVis` igual que `nHist`, con una sola expresión que alimente ambos conteos (comunas y establecimientos), para que no puedan volver a divergir.
- **Verificación** (navegador):
  - Nacional, 4° básico, histórica, solo "Alto": `esperado:` "96 comunas · 555 establecimientos…". Reconteo independiente con `Rscript` sobre el payload: comunas distintas de los RBD con GSE vigente "5" en 4b.
  - Con los cinco GSE encendidos: `esperado:` "346 comunas · 8.284 establecimientos…" (caso bueno conocido, igual que hoy).
  - Vista actual: `esperado:` sin cambios ("343 comunas · 6.717 establecimientos en el nivel seleccionado").
- Commit: `fix(panorama): el banner historico cuenta comunas del universo filtrado`.

### T3 — El rótulo de sección dice la regla que el código aplica (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Defecto medido:** la agrupación usa el último año **con GSE publicado** (decisión §3.1), pero el subtítulo dice "GSE de su último año con resultado". En nacional 4° básico, 198 de 8.284 establecimientos quedan en una sección cuyo GSE viene de un año en que su fila de la matriz está vacía. En el SLEP foco no ocurre.
- **Corrección:** el subtítulo pasa a "GSE de su último año con GSE publicado". No se toca `rosterHistorico`. Revisa además que la glosa del pie y la ayuda no repitan la regla vieja, y el plural del conteo ("1 establecimientos" → "1 establecimiento").
- **Verificación:** `esperado:` 0 ocurrencias de "último año con resultado" en el template; el conteo de secciones y de filas por sección no cambia (nacional 4b y SLEP foco 4b/2m, mismos números que s31: 10/21/28/1/1 = 61 y 3/7/3 = 13).
- Commit: `fix(vista-historica): el rotulo de seccion nombra la regla aplicada`.

### T4 — El estado y la fila llegan al lector de pantalla (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Defecto medido:** en la matriz, el glifo ▼ = ▲ viaja como carácter suelto (el nombre accesible de una celda es "63▼", sin decir el estado) y la celda del nombre lleva `role="button"`, con lo que deja de ser celda de la tabla y ninguna fila tiene encabezado.
- **Corrección, con el patrón que el motor ya usa:** (1) el glifo va con `aria-hidden` más un texto oculto con la glosa de `EST_EE` y el año; (2) la celda del nombre pasa a `<th scope="row">` con un botón adentro (o `role="rowheader"` conservando el foco por teclado), de modo que cada celda se anuncie con su establecimiento.
- **Verificación:** árbol de accesibilidad en navegador (CDP `Accessibility.getPartialAXTree`).
  - `esperado:` el nombre accesible de una celda con estado incluye el puntaje, el año y la glosa del estado; cada fila expone su encabezado; Enter y Espacio sobre el nombre abren la ficha.
  - Calibración: la misma sonda sobre el motor actual devuelve "63▼" sin glosa y sin encabezado de fila.
- Commit: `fix(a11y): la matriz historica expone estado y encabezado de fila`.

### T5 — Correcciones de forma del log de s31 (commit `docs`)

- **ALCANCE:** `50_documentacion/andamios/logs/20260917_correcciones_revision_s31b_log.md` (este log). **El log de s31 no se edita.**
- Anota en este log, citando la línea anterior, las tres citas erradas que la revisión encontró en el de s31: los dos `esperado (propio…)` están en las líneas 167 y 279 (el log dice 154 y 266); `tokenCSS` se define en L2206 del template base (el log dice L2311, que es `COL_FONDO`); la barra de exportación del panorama está en L2579–L2583 (el log dice L2547–L2556). Cada corrección con el `grep -n` que la produce.
- Anota también las tres advertencias que no se corrigen aquí y por qué: el piso real de la rampa de color es 4,58:1 y el 4,78:1 de la decisión §3.5 es el mínimo de los puntajes que hoy se muestran (queda como enmienda de la decisión en el cierre); el modal de territorio no es operable por teclado (preexistente, va al backlog); y el criterio del traspaso para verificar el despliegue busca "Exportar CSV", cadena que también existe en el motor viejo (se reemplaza por "sin comparación publicada" en el cierre de esta sesión).
- Commit: junto con FASE L.

---

## 3. FASE R y FASE L

Iguales a §5 y §6 del encargo s31, transcritas allí con sus diez y siete pasos, con dos precisiones:

- FASE R corre los ocho invariantes (los siete de s31 más 🔒8) y re-deriva cada verificación de T1 a T4 con un comando distinto del que la produjo. El control positivo puede plantarse sobre una copia del template en `/tmp/idps_s31b/`.
- FASE L cierra el log propio, rellena el bloque J, corre el grep de privacidad y commitea `docs(log): correcciones de la revision s31b`; luego `git push origin main`.

## 4. Reporte final

Abre con `ls -l <LOG> && wc -l <LOG>` y el hash del commit `docs(log)`, sigue con el bloque J copiado literal, y cierra con el md5 del motor regenerado para la revisión visual del titular.

## 5. Fuera de alcance

- Despliegue a `docs/index.html`.
- Teclado en el modal de entidades (preexistente).
- Desborde horizontal de la barra de pestañas bajo 425 px (preexistente: el motor base mide igual).
- Exportación CSV de la vista histórica, §5.6 de la decisión de contraste, `min-width` de `.cmp-table`, y el resto del backlog de v29.
