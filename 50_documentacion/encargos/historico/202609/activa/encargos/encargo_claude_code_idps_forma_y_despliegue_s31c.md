# Encargo autónomo a Claude Code: dos correcciones de forma y despliegue

> Proyecto: `slep_idps`. Encargo **s31c**, continuación de s31b. Patrón: `herramientas_dev/prompts/encargo_autonomo_claude_code_v1.md` (v1.6).
> Origen: verificación independiente del motor de s31b (cinco lentes con refutación adversarial). Las cinco correcciones de s31b quedaron verificadas y **ninguna cifra ni CSV cambió**; sobrevivieron dos defectos de forma, los dos medidos en navegador, que son T1 y T2 de este encargo.
> **Este encargo SÍ despliega a `docs/`**: el titular ya dio el visto bueno visual sobre el motor de s31b, con la condición de corregir estas dos cosas antes de publicar.

---

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno, en serie. **Subagentes: no se admiten.**
- **EJECUCIÓN:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus 0.
- **ENTORNO:** Claude Code en la estación macOS del titular, repositorio `/Users/tomgc/Projects/slep_idps`, rama `main`.
- **INTÉRPRETE:** shell con `bash -c '…'`; cálculo sobre datos con `Rscript`; rutas absolutas, sin `cd` previo.
- **INSUMOS:** `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`; `50_documentacion/andamios/logs/20260917_correcciones_revision_s31b_log.md`; `30_procesamiento/35_motor_template.html`; `CLAUDE.md`.
- **LOG:** `50_documentacion/andamios/logs/20260917_forma_y_despliegue_s31c_log.md` (log propio; los de s31 y s31b están commiteados y no se editan).
- **PRUEBAS:** sin arnés (`tests/` vacío). Lo sustituye `Rscript -e 'source("/Users/tomgc/Projects/slep_idps/00_build.R"); run_all(only = 35L)'` con exit 0 y sin warnings nuevos, más la fidelidad del payload (SHA-256 `1e29c2b5…b5b6` sin el bloque `vista_territorial`, 59.466.778 bytes).
- **PUNTO DE RETORNO:** FASE 0 mide `git status --porcelain` (esperado: solo `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_forma_y_despliegue_s31c.md`, este encargo), `git stash list` (vacío), `git fetch` y `git rev-parse --short HEAD` = `git rev-parse --short origin/main` = `48d35da`. T0 commitea el encargo (`docs(s31c): encargo de forma y despliegue`) y ese hash es `<PR>`.
- **Topes:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando.

### 0.1 Regla de detención

1. Si `HEAD` no es `48d35da` o difiere de `origin/main` → detente.
2. Si el `git status` de FASE 0 muestra alguna ruta fuera de la declarada → detente.
3. Si la fidelidad del payload deja de dar `1e29c2b5…b5b6` → detente: este encargo no toca R ni el payload.
4. Si una corrección exigiera tocar `repartoInd`, `pctRound`, la lectura de `sigdifgru`, `n_sin_comparacion` o `filasComparadorCSV` → detente (🔒8).
5. Si `run_all(only = 35L)` falla o emite un warning nuevo → congela la tarea en curso.
6. Si una verificación da un valor distinto del `esperado:` → congela la tarea y registra la diferencia.
7. Si el motor y `docs/index.html` no quedan byte a byte idénticos en T4 → detente antes del push.
8. **Cualquier estado, conteo o resultado no enumerado aquí → congela ESTA tarea, regístrala como duda y sigue con la próxima tarea independiente.**

### 0.2 Autorizaciones (lista cerrada)

- `git commit` de las rutas del ALCANCE de cada tarea, tras su verificación.
- `cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html` en T4, solo con T1 y T2 completadas y verificadas, y commit `deploy(docs): publica la vista historica territorial`.
- `git push origin main` en FASE L, solo con FASE R en `APROBADO` o `APROBADO CON ADVERTENCIAS` y `git status --porcelain` vacío.
- `git revert <hash>` de un commit propio de esta sesión.
- Escribir mediciones en `/tmp/idps_s31c/`.

Nada más. No está autorizado: `push --force`, `reset`, `restore`, `checkout --`, borrar archivos, ni tocar `20_insumos/` o `40_salidas/intermedios/`.

### 0.3 Grafo

```
T0 (commit del encargo)     independiente, corre en FASE 0
T1 (plural del banner)      independiente
T2 (anclaje del rótulo)     independiente
T3 (build y auditoría)      requiere T1 y T2
T4 (despliegue a docs/)     requiere T3
FASE R y FASE L             corren siempre, al final, fuera del grafo
```

---

## 1. Invariantes 🔒

Siguen los ocho de s31 y s31b, con los mismos comandos y `<PR>` = el hash de T0. El más estricto aquí es **🔒8 (ninguna cifra cambia)**, con esta comprobación dinámica: para el SLEP foco (`cod_slep` 503), 4° básico y 2° medio, vista actual e histórica, el `title`, el `aria-label`, el texto de cada segmento, la tira externa y la nota de **todas** las barras deben ser idénticos antes y después (en s31b fueron 92 barras, md5 `21f1019a09218dec434d4e84e938c840`).

---

## 2. Tareas

### T1 — El banner concuerda el plural (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Defecto medido:** en `.pan-meta` la cadena " establecimientos" está escrita a mano en las dos ramas del ternario, sin el ayudante `nEE` que s31b introdujo. Con el SLEP foco, 4° básico y solo el GSE "Medio alto": la vista actual dice "1 establecimientos en el nivel seleccionado" y la histórica dice "1 establecimientos con resultado en algún año", mientras el subtítulo de la sección, treinta píxeles más abajo, dice "1 establecimiento". La misma línea sí concuerda "comuna" y "comunas".
- **Corrección:** las dos ramas usan el ayudante de plural que ya existe. Revisa de paso que no quede ninguna otra cadena de conteo escrita a mano en el banner ni en las notas de nivel nacional.
- **Verificación** (navegador, motor regenerado): SLEP foco, 4° básico, solo "Medio alto", en las dos vistas.
  - `esperado:` "1 establecimiento" en ambas, y "2 establecimientos" al encender también "Sin clasificar" en la histórica.
  - Calibración: la misma medición sobre el motor actual da "1 establecimientos" en las dos (caso malo conocido).
  - `esperado:` 0 ocurrencias de "1 establecimientos" y de "1 comunas" en cualquier pantalla, territorio y nivel que pruebes (incluye nacional, una región y una comuna).
- Commit: `fix(panorama): el banner concuerda el plural de establecimiento`.

### T2 — El rótulo del indicador se ancla a su barra (commit `fix`)

- **ALCANCE:** `30_procesamiento/35_motor_template.html`.
- **Defecto medido:** T1 de s31b metió barra, tira y nota en `.s100-wrap`, y como `.pan-dist-row` conserva `align-items:center`, el rótulo pasó a centrarse en el bloque completo. En la sección Medio del SLEP foco, 4° básico, el centro del rótulo queda 9 px bajo el centro de su barra en las filas con solo nota, y 17 px en las filas con tira y nota. Antes de s31b la desviación era 0 px.
- **Decisión del titular (2026-09-17):** el rótulo se ancla a la **barra**, no al bloque.
- **Corrección:** anclar el rótulo al inicio de la fila con una altura mínima igual a la de la barra (la clase ya centra su contenido), o pasar la fila a `align-items:start` y compensar en el rótulo. No cambies el ancho de la primera columna.
- **Verificación** (navegador): sección Medio del SLEP foco, 4° básico, los cuatro indicadores.
  - `esperado:` desviación vertical del rótulo respecto de su barra = 0 px en los cuatro, con nota y con tira.
  - Calibración: la misma medición sobre el motor actual da +9, +17, +9, +17 px (caso malo conocido).
  - `esperado:` en las filas sin nota la desviación sigue en 0 px (caso bueno conocido), y el comparador y la franja de la vista histórica no se mueven.
  - `esperado:` a 390 px de ancho, el layout de una columna no cambia respecto del motor actual.
- Commit: `fix(panorama): el rotulo del indicador se ancla a su barra`.

### T3 — Regenerar y auditar (commit `build`)

- **ALCANCE:** `40_salidas/motor_idps.html`.
- `run_all(only = 35L)`; fidelidad del payload; 🔒8 dinámico (las 92 barras idénticas); `run_all` sin warnings nuevos.
- **Verificación:** `esperado:` SHA-256 `1e29c2b5…b5b6` sin el bloque, 59.466.778 bytes, y `diff` vacío entre el volcado de barras de antes y el de después.
- Commit: `build(motor): regenera con las correcciones de forma`.

### T4 — Desplegar a `docs/` (commit `deploy`)

- **ALCANCE:** `docs/index.html`.
- Copia el motor a `docs/index.html` y comprueba **byte a byte** (`md5` de los dos archivos, `cmp -s`).
- **Verificación, con testigo que distingue este build del anterior** (la cadena "Exportar CSV" no sirve: existe también en el motor viejo):
  - `esperado:` `grep -c 'sin comparación publicada' docs/index.html` ≥ 1 y `grep -c 'vt-mx' docs/index.html` ≥ 1.
  - `esperado:` `md5` de `docs/index.html` igual al de `40_salidas/motor_idps.html`, y distinto de `2f34dafe1309b67e5e1e1cfb3eea47a3` (el publicado hasta hoy).
- Commit: `deploy(docs): publica la vista historica territorial`.

### T5 — Pendientes anotados (va con FASE L)

Anota en el log, sin corregirlos, los tres pendientes que esta línea deja abiertos, cada uno con su medición:

1. **Enmienda de la decisión §3.5:** el piso de la rampa continua de color es 4,58:1, no 4,78:1; el 4,78 es el mínimo entre los puntajes que hoy se muestran. Ninguna celda publicada baja de 4,5:1.
2. **Criterio de verificación del despliegue:** el traspaso vigente busca "Exportar CSV" en `docs/index.html`, cadena que también trae el motor viejo. Desde hoy el testigo es "sin comparación publicada" (T4).
3. **Teclado en el modal de territorio:** las filas del selector no son operables por teclado (preexistente, anterior a s31). Va al backlog.

---

## 3. FASE R y FASE L

Iguales a §5 y §6 del encargo s31, con sus diez y siete pasos. Precisiones:

- FASE R corre los ocho invariantes y re-deriva cada verificación de T1 a T4 con un comando distinto del que la produjo; el control positivo puede plantarse sobre una copia del template en `/tmp/idps_s31c/`.
- FASE L cierra el log propio, rellena el bloque J, corre el grep de privacidad, commitea `docs(log): forma y despliegue s31c` y hace `git push origin main`.

## 4. Reporte final

Abre con `ls -l <LOG> && wc -l <LOG>` y el hash del commit `docs(log)`, sigue con el bloque J literal, y cierra con el md5 de `docs/index.html` y la confirmación de que `origin/main` quedó igual a `HEAD`.

## 5. Fuera de alcance

Los tres pendientes de T5; la exportación CSV de la vista histórica; §5.6 de la decisión de contraste; `min-width` de `.cmp-table`; el desborde de la barra de pestañas bajo 425 px (preexistente); y el resto del backlog de v29.
