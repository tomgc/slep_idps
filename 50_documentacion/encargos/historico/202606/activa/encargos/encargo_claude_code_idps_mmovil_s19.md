# Encargo autónomo — media móvil en históricos del motor IDPS (s19, Ítem 7)

> Encargo dirigido por meta para Claude Code en modo autónomo. Reglas canónicas
> (autonomía 0.3, commits atómicos, gobernanza, principios técnicos, R1-R9) en la
> knowledge base; se referencian, no se reescriben.

---

## 1. Encabezado de contrato

- **Modo:** autónomo, secuencial, todo en este turno. Commit atómico por fase.
- **Stack:** R + HTML/JSX inline (React 18 + D3 v7, runtime classic, sin bundler).
- **Rutas:** absolutas desde `/Users/tomgc/Projects/slep_idps`. No asumir `cd`.
- **Push:** NO ejecutar. Dejar commits locales y pedir aprobación del titular.
- **Regla de detención (PARA y reporta):** (1) un invariante 🔒 te obligaría a
  violarse; (2) un dato real contradice un supuesto del encargo (p. ej. la serie no
  tiene el formato `{a,v,estado}` esperado, o la fidelidad post-build no da 0);
  (3) una decisión de diseño no fijada aquí. No fabricar metodología.
- **DISCIPLINA_OPERATIVA R1-R9:** leer `git status` antes de cada `add`; nunca
  `git add .`/`-u`; leer el diff real antes de redactar el mensaje de commit.

---

## 2. Contexto mínimo suficiente

- **Archivos clave:**
  - Generador R: `30_procesamiento/35_generar_motor_html.R`
  - Template: `30_procesamiento/35_motor_template.html`
  - Build: `40_salidas/motor_idps.html`; deploy: `docs/index.html`
  - Parquet: `40_salidas/intermedios/idps_largo.parquet` (md5 `4c764d8c…`, NO se toca)
- **Mecanismo de la serie histórica (ya verificado, reconfirmar antes de editar):**
  - R decide el eje contiguo y los estados: `eje_historico[g]` clasifica cada año
    como `con_dato` / `pandemia` (2020-2021) / `no_eval` (p. ej. 2019), con flag
    `preliminar`. Constante `ANIOS_PANDEMIA = c(2020,2021)` (~:51). Todo va a `meta`.
  - Cliente: `serieEje(ofFn, rbd, grado, id, eje)` (~:788) produce el array de puntos
    `{a, v, dif, sig, estado}` por año, leyendo el dato del propio EE vía
    `indOf`/`dimOf`. Año no-`con_dato` → `v:null` con su `estado`. Hueco real del EE
    (sin fila ese año) → `v:null`, `estado:"con_dato"`. No se interpola.
  - `BarrasAnio` (~:794) solo pinta: usa `p.a`, `p.v`, `p.estado`. Ya trae (de s19)
    `.ybar-track` (envolvente 0-100) e `.is-latest` (realce último año con dato).
  - Ensamblaje (~:1040-1052): `BarrasAnio` por indicador y por dimensión. La
    subdimensión NO entra al histórico (invariante).

---

## 3. Invariantes (🔒)

- 🔒 **Parquet NO se toca.** md5 `4c764d8c…`, 2.362.447 filas.
- 🔒 **Fidelidad censal = 0 mismatch.** La media móvil es overlay derivado; NO altera
  ninguna barra ni ninguna cifra `v` de la serie. Las alturas de barra y los valores
  no cambian. Tras el build, re-derivar fidelidad censal: mismatch esperado = 0.
- 🔒 **Escala `BarrasAnio` fija 0-100, sin autoescala.** La línea de media se dibuja
  en la MISMA escala 0-100 que las barras (un valor de media de 78 cae a la altura 78%
  de la columna). NO reescalar.
- 🔒 **No interpolar datos.** La media se computa SOLO sobre puntos `con_dato` con
  `v != null`. Los huecos (`pandemia`/`no_eval`/sin dato del EE) NO aportan al
  promedio NI se rellenan. La media NO inventa un punto donde el EE no tiene dato.
- 🔒 **Identidad de indicador.** La línea de media usa el color del propio indicador
  (a baja opacidad). Sin semáforo, sin color nuevo.
- 🔒 **`docs/` solo en deploy**, tras pasar fidelidad y verificación en navegador.

---

## 4. Decisión de diseño fijada (D-s19-MMOVIL)

- **Cómputo en cliente, función pura** sobre la serie que `serieEje` ya devuelve. NO
  se computa en R. Justificación: la serie final depende del EE (la arma el cliente
  año a año); computar la media server-side exigiría replicar el recorte
  EE×grado×familia para 9.000+ EE e inflar el payload. La media es una transformación
  de PRESENTACIÓN sobre una serie ya armada, no lógica de negocio nueva (el dato y los
  estados los decide R). Coherente con D-s12 leído en sentido estricto: la lógica de
  negocio (qué año tiene dato, qué estado) sigue en R; la media es derivada visual.
- **Ventana:** media móvil **centrada de 3 puntos**, sobre puntos-con-dato
  CONSECUTIVOS EN EL EJE saltando los huecos estructurales. Es decir: se toma la
  secuencia ordenada de puntos con `estado==="con_dato" && v!=null`, y para cada uno
  se promedia con su anterior y su siguiente EN ESA SECUENCIA (no en años de
  calendario). Los extremos (primer y último punto de la secuencia) no tienen media
  centrada completa: omitir la media en ellos (no media de 2; mantenerlo simple y
  honesto), salvo que prefieras media parcial — ver criterio.
- **Mínimo de puntos:** dibujar la línea de media SOLO si el EE tiene **≥4 puntos con
  dato** en esa serie (indicador o dimensión). Bajo 4, NO se dibuja media (sin mensaje).
- **Constantes nombradas** (no números mágicos), al inicio del bloque JS del template:
  `MMOVIL_VENTANA = 3`, `MMOVIL_MIN_PUNTOS = 4`.

---

## 5. Fases

### FASE 1 — Cómputo y render de la media móvil

**Paso 0 (leer, no modificar):** `serieEje` (~:788), `BarrasAnio` (~:794) y su CSS
(`.ybar-*`), el ensamblaje (~:1040-1052). Confirmar el formato real del punto.

**Implementación:**
1. **Función pura** `mediaMovil(serie)` en el bloque JS del template:
   - Filtra la serie a los puntos `con_dato` con `v!=null`, en orden de eje.
   - Si hay `< MMOVIL_MIN_PUNTOS`, retorna `[]` (no se dibuja media).
   - Para cada punto interior `i` (1..n-2 de la secuencia filtrada), media =
     promedio de `v[i-1], v[i], v[i+1]`. Devuelve pares `{a, m}` anclados al AÑO `a`
     del punto central (para posicionarlo en la misma columna que su barra). Los
     extremos no producen punto de media.
   - Constantes `MMOVIL_VENTANA`, `MMOVIL_MIN_PUNTOS` nombradas.
2. **Render en `BarrasAnio`:** superponer una **línea tenue** que conecta los puntos
   `{a, m}` sobre las columnas correspondientes, en la misma escala 0-100 que las
   barras (altura = `m%`). Color = color del indicador, baja opacidad (sutil, no
   compite con las barras). La línea pasa POR ENCIMA de las barras pero no las tapa
   (opacidad baja + grosor fino). Sin puntos/marcadores salvo que quede ilegible;
   sin etiquetas numéricas.
   - Implementación sugerida: un SVG overlay absoluto dentro del contenedor de
     `BarrasAnio`, con un `<polyline>`/`<path>` cuyos puntos se calculan desde la
     posición x de cada columna (centro) y la y = `(100-m)%`. Alternativa CSS si
     resulta más limpio; criterio de Claude Code, manteniendo la escala 0-100 y el
     alineamiento con el centro de cada barra.
3. **Aplica a indicador y dimensión** (las dos series que usan `BarrasAnio`). La
   subdimensión no entra (invariante).
4. **Leyenda mínima:** si el motor tiene leyenda de la vista histórica, añadir una
   entrada discreta "línea: promedio móvil (3)" o equivalente, en el registro de la
   prosa existente. Si no hay leyenda, NO crear una nueva sección; basta el tooltip/
   título del trazo. Decisión menor: que Claude Code elija lo que encaje sin recargar.

**Criterio de éxito:**
- En un EE con ≥4 puntos con dato (p. ej. RBD 1440 indicador, eje 2014-2025), aparece
  una línea tenue del color del indicador que conecta las medias móviles centradas,
  saltando 2019/2020/2021. La barra que se despega de la línea es visualmente la
  anomalía (propósito declarado).
- En un EE con <4 puntos, NO aparece línea de media.
- Las barras, sus alturas y sus valores NO cambian respecto al build anterior.
- La media nunca aparece sobre un año-hueco (no hay punto de media donde no hay barra).

**Commit Fase 1:**
```
git -C /Users/tomgc/Projects/slep_idps add 30_procesamiento/35_motor_template.html
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps commit -m "feat(motor): media movil centrada en historicos (item 7)"
```

### FASE 2 — Regeneración, fidelidad y deploy

1. **Regenerar:** `run_all(only=35)` (o el comando real del orquestador; confirmar).
   Si falla, PARA y reporta.
2. **Fidelidad censal (panel adversarial, código independiente):** re-derivar desde
   el parquet que `prom`/`niv_*_por`/`dif`/`difgru` y sus `sig` NO cambiaron (la media
   es overlay; el cambio es solo template). Identidad de bloques de payload esperada
   (el cambio NO toca R salvo que se añada leyenda en prosa; si se tocó R, declararlo).
   Mismatch esperado = 0. Si no es 0, PARA y reporta.
3. **Navegador:** verificar los criterios de §5 con casos reales (un EE con ≥4 puntos
   y uno con <4; confirmar que la línea salta los huecos y no aparece bajo el mínimo).
   Capturar evidencia para el log.
4. **Deploy (solo si 2 y 3 pasaron):**
```
cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html
git -C /Users/tomgc/Projects/slep_idps add 40_salidas/motor_idps.html docs/index.html
git -C /Users/tomgc/Projects/slep_idps status
git -C /Users/tomgc/Projects/slep_idps commit -m "build(motor): regenerar y desplegar media movil historica (item 7)"
```
NO pushear. Pedir aprobación del titular.

---

## 6. Auto-auditoría, log y cierre

- Panel adversarial para la fidelidad censal (código independiente, no inline).
- Verificación en navegador obligatoria de los criterios visuales.
- Log en `50_documentacion/andamios/logs/YYYYMMDD_mmovil_s19_log.md` (plantilla fija):
  resumen, commits, detalle del ítem (qué/por qué/cómo se verificó), invariantes 🔒
  PASA/FALLA con evidencia, estado de cifras (md5 parquet, fidelidad), `# REVISAR`,
  notas para el revisor. Honesto. Dejar SIN commitear para revisión del titular.
- NO cerrar ni sugerir cerrar la sesión (R5).

---

## 7. Reporte final al chat

Hashes de los 2 commits + estado de push (pendiente de OK); md5 parquet antes/después;
fidelidad censal (mismatch=0 esperado); spot-checks visuales (EE con ≥4 y con <4
puntos, salto de huecos); pendientes/`# REVISAR`; ruta del log; cualquier detención.

---

## 8. Notas para el redactor (no van al log)

- Decisión abierta menor que Claude Code puede resolver y declarar: en los EXTREMOS de
  la secuencia filtrada, la media centrada de 3 no existe. El encargo opta por OMITIR
  la media en los extremos (no media parcial de 2 puntos), para no sugerir una
  tendencia con menos soporte. Si al verificar resulta que esto deja la línea
  demasiado corta en series ya rasas, reportarlo como `# REVISAR` para que el titular
  decida si se admite media parcial en extremos.
- Ítems aún diferidos tras este: 4 (tipografía), 9+10 (modal territorios), 11 (lista
  EE por segmento).
