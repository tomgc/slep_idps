# Encargo autónomo a Claude Code — Reanudar la exportación (s30b): auditar lo hecho y cerrar

> Proyecto: `slep_idps`. **Este encargo NO empieza de cero.** El encargo
> `encargo_claude_code_idps_exportacion_s30.md` quedó a medio ejecutar: sus cuatro
> primeras fases están **commiteadas** y verificadas, y la sesión que las corrió se
> quedó sin cuota antes de cerrar. Tu tarea es **auditar lo ya hecho** y **completar
> solo lo que falta**.
>
> **Prohibido rehacer trabajo que la Fase 0 encuentre correcto.** Si una verificación
> de la Fase 0 pasa, se da por buena y se sigue adelante; solo se rehace lo que falle.

---

## 0bis. Insumos

1. El encargo original: `50_documentacion/activa/encargos/encargo_claude_code_idps_exportacion_s30.md`
   (define qué debía hacer cada fase y los criterios de aceptación).
2. `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` — §8.2
   (convención de normalización del payload). Trae una §44 **sin commitear**.
3. Referencia del hermano: `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`.
4. `CLAUDE.md` y `50_documentacion/activa/POLITICA_PROYECTO.md`.

**Restricción de esta sesión, explícita:** la sesión anterior agotó su cuota corriendo
paneles adversariales de 12 a 33 agentes. **No lances workflows ni paneles multiagente.**
Las verificaciones de este encargo son deterministas y se corren directo. Si crees que
falta una revisión adversarial, anótala como pendiente en vez de ejecutarla.

---

## 1. Estado medido del repositorio (verificado el 2026-09-17, antes de redactar esto)

| Elemento | Estado |
|---|---|
| `HEAD` | `ce91580`, **4 commits ahead** de `origin/main` (`98fc4d3`), sin push |
| Fases 1-4 | commiteadas: `d703d20`, `c03a393`, `5ccdae2`, `ce91580` |
| `30_procesamiento/35_motor_template.html` | **modificado sin commitear**: las correcciones posteriores al commit de la Fase 4 (hallazgos del panel y arreglos propios del ejecutor) |
| `40_salidas/motor_idps.html` | **regenerado sin commitear**, y corresponde a la plantilla actual |
| Payload | **fiel**: 59.466.778 bytes, un solo offset distinto (el día en `fecha_generacion`), SHA-256 normalizado `1e29c2b5be529e01…` idéntico al de §8.2 |
| `docs/index.html` | **desactualizado** (md5 distinto del motor): falta el despliegue |
| Log de la sesión | tiene la §44 (sin commitear); **no** tiene ninguna sección de s30a |
| Encargo s30 | en disco, **sin versionar** |

Estas mediciones son el punto de partida. Confírmalas en la Fase 0 antes de confiar en
ellas: si algo cambió desde entonces, manda lo que midas tú.

---

## 2. Fase 0 — Auditoría de lo ya hecho (sin commits)

Verifica, en este orden, y **reporta cada resultado**:

1. **Integridad de git:** `HEAD`, distancia con `origin/main`, árbol de trabajo. Que los
   cuatro commits existan y toquen solo `30_procesamiento/35_motor_template.html`.
2. **Sintaxis:** el bloque JSX de la plantilla compila (Babel). Sin esto no sigas.
3. **Correspondencia plantilla → motor:** el motor sin commitear contiene las funciones
   de exportación de la plantilla (`filasComparadorCSV`, `filasPanoramaCSV`,
   `filasFichaCSV`, `estadoVsGse`, `rasterizarSvgAPng`, `descargarBlob`, `IconExport`).
   Si no coinciden, el motor está desfasado: regenera.
4. **Fidelidad del payload:** diff de offsets contra `HEAD:40_salidas/motor_idps.html`
   y hash con la convención de §8.2. Criterio: solo puede diferir `fecha_generacion`.
5. **Criterios del encargo original que ya se declararon cumplidos**, revisados por
   muestreo, no repetidos enteros:
   - la verificación de fidelidad CSV ↔ pantalla que exige el §6.2 del encargo original
     (un caso concreto: Chile + SLEP Costa Central, 4° básico, GSE Bajo, indicador 1);
   - que el CSV lleve BOM, separador `;` y decimal con coma;
   - que los cuatro botones existan y disparen descarga (comparador, panorama, ficha,
     radar).
6. **Revisión del diff sin commitear** (`git diff`): entiende qué corrige cada hunk y
   verifica que ninguno rompa lo que las fases anteriores dejaron verificado. Presta
   atención a la unificación de `estadoVsGse` (que panorama y ficha no se contradigan) y
   al escape de comillas en el CSV.

**Si todo pasa:** sigue en la Fase 1 sin rehacer nada.
**Si algo falla:** arréglalo, dilo en el reporte, y sigue.

---

## 3. Fase 1 — Commitear las correcciones pendientes (commit `fix`)

Commitea el diff de la plantilla que quedó sin commitear.

Commit: `fix(export): correcciones posteriores al panel adversarial de s30a`

## 4. Fase 2 — Las dos revisiones que la sesión anterior no alcanzó a hacer

El panel de la sesión anterior dejó **dos lentes sin correr**: imagen (SVG/PNG) y estado
de React. Hazlas tú, directo y acotado, **sin multiagente**:

1. **Imagen:** que el SVG exportado sea válido en SVG 1.1 (sin `fill="rgba(...)"`, sin
   variables CSS sin resolver, con `width`/`height`/`viewBox`), que el PNG se genere con
   el mismo contenido, y que un establecimiento **sin ningún indicador con dato** exporte
   un radar legible en vez de fallar.
2. **Estado de React:** que abrir y cerrar el modal, cambiar de nivel, de territorio y de
   pantalla no deje al exportador leyendo datos de la selección anterior. Criterio: el
   contenido del CSV corresponde siempre a lo que la pantalla muestra en ese momento.

Si encuentras defectos, corrígelos y commitea aparte.

## 5. Fase 3 — Build y despliegue

1. Si la Fase 1 o la 2 tocaron la plantilla: `run_all(only = 35L)` y vuelve a verificar
   la fidelidad del payload. **Si no la tocaron, no regeneres**: el motor ya
   corresponde a la plantilla (verificado en la Fase 0.3).
2. Commitea el motor si cambió: `build(motor): regenera el motor con la exportacion`.
3. Promueve a `docs/index.html` (copia byte a byte, verificada con `md5`).
   Commit: `deploy(docs): publica la exportacion CSV e imagen`.

## 6. Fase 4 — Log, ESTADO.md y publicación

El borrador del log de s30a **se perdió con la sesión anterior** (vivía en su
scratchpad). Reconstrúyelo desde el material que sí sobrevive: los cuatro commits, el
diff completo `98fc4d3..HEAD`, y los resultados de tus Fases 0 y 2.

1. Sección s30a en el log: commits, qué se cambió por fase, cifras de la verificación de
   fidelidad CSV ↔ pantalla, resultado de las dos revisiones de la Fase 2, decisiones
   tomadas dentro del margen y pendientes. **Incluye la §44 sin commitear.**
2. Registra en el log dos cosas que la sesión anterior dejó sueltas:
   - el aviso `renv::status(): the project is out-of-sync` que apareció al final. Dí si
     es previo a esta línea de trabajo o lo introdujo ella, y qué paquete falta;
   - que el panel adversarial se cortó por cuota y **dos lentes no corrieron**, y que se
     reemplazaron por las verificaciones directas de la Fase 2.
3. `ESTADO.md` al día.
4. Versiona el encargo original s30 y este.
5. `git push origin main`; reporta el hash y confirma `origin/main == HEAD`.

Commit: `docs(log): registro de s30a y cierre de la exportacion`

---

## 7. Fuera de alcance

- Exportación de imagen del comparador y del panorama (requiere reconstruir en SVG lo
  que hoy es HTML; razón escrita en el encargo original §5.2).
- P-VISTA-TERRITORIAL, §5.6, marca de base pequeña, `table-layout:fixed` sin `min-width`.
- Rama `feat/contrato-contexto`.
