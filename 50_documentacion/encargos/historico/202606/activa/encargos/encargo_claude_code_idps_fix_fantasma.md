# Encargo autónomo a Claude Code — slep_idps, sesión 12: filtrar fantasma rbd=null (H-FID-1)

> Patrón: encargo autónomo dirigido por meta. CONTINUATION slep_idps, sesión 12.
> Higiene de presentación: eliminar del motor el establecimiento "fantasma"
> rbd=null que el spot-check de P-DISPLAY-FIDELITY detectó como alcanzable por el
> buscador. Regenera y redespliega. El parquet NO se toca (el fantasma se filtra
> al SERIALIZAR, no se borra del dato).

---

## 1. Contrato

- **Modo:** autónomo, secuencial, todo en este turno.
- **Reglas canónicas:** rutas absolutas con `git -C /Users/tomgc/Projects/slep_idps`;
  R-only; commits atómicos; `git status` antes de cada `git add`; nunca `git add .`/`-u`;
  scripts efímeros (`verificar_*.R`) NUNCA se versionan. Sin asumir `cd`.
- **Regla de detención (PARA y reporta):**
  1. El `md5` del parquet NO es `4c764d8c9f0bf70004f8aa52661ae901` al inicio o al fin.
  2. El filtro afectaría a CUALQUIER establecimiento con `rbd` no nulo (debe tocar
     SOLO la(s) fila(s) con `rbd` NA; si tu verificación muestra que cambia el
     conteo de RBD reales, detente: algo está mal en el filtro).
  3. Una decisión de diseño no prevista.

---

## 2. Contexto

- **Proyecto:** `/Users/tomgc/Projects/slep_idps` (Rama A pública; motor en
  `docs/index.html`, servido por GitHub Pages; build idéntico en
  `40_salidas/motor_idps.html`).
- **Generador:** `30_procesamiento/35_generar_motor_html.R`.
- **Parquet:** `40_salidas/intermedios/idps_largo.parquet`
  (`md5 4c764d8c9f0bf70004f8aa52661ae901`, 🔒 intocable).
- **El hallazgo (H-FID-1, log `20260621_display_fidelity_log.md`):** el parquet trae
  **4 filas con `rbd = NA`** (4b / indicador / 2017), propiedad preexistente del
  `idps_largo`. El generador las colapsa en **1 establecimiento fantasma** (sin
  nombre, sin geo, sin GSE). Queda fuera de la navegación territorial (geo null no
  matchea), PERO el buscador lo expone: escribir "null" lista una tarjeta "RBD null"
  clickeable. Sus cifras son fieles, pero es ruido visible para una validación
  externa. Hay que sacarlo del motor.

---

## 3. Invariantes (🔒)

- 🔒 **El parquet no se toca.** El fantasma se filtra en el GENERADOR al construir
  los arrays que van al JSON, NO se borra del parquet. `md5` inicio == fin.
- 🔒 **Solo se elimina lo que tiene `rbd` NA/null.** Ningún establecimiento con RBD
  real puede desaparecer ni cambiar. El conteo de RBD reales debe quedar idéntico
  (9136 reales; el total de establecimientos baja de 9137 a 9136 al quitar el
  fantasma).
- 🔒 **Ninguna cifra de un RBD real cambia.** El filtro quita filas rbd=NA, nada más.
- 🔒 Resto de invariantes del motor vigentes (lee-no-deriva, sin agregación, etc.).

---

## 4. Fases

### Fase 0 — Estado real
1. `git status` (limpio salvo lo esperado). `md5` parquet (si no es `4c764d8c…`, detente).
2. Lee `35_generar_motor_html.R`. Localiza dónde se construyen los bloques que
   reciben filas con `rbd` NA: el `roster`, `ind`, `dim`, `niv` (se filtran de `P`),
   y `establecimientos_lst`/`est_attr` (de `P |> distinct(rbd, ...)`). El fantasma
   nace de las filas `P$rbd` NA que sobreviven a esos pasos.
3. Cuenta, en el parquet (para el universo del motor 4b/2m), cuántas filas tienen
   `rbd` NA por familia, para saber exactamente qué vas a filtrar (esperado: 4
   filas en indicador, según el log; confírmalo, no lo asumas).

### Fase 1 — Filtrar el fantasma en el generador
- Agrega, en el punto donde se carga/filtra `P` (después del filtro a `GRADOS_MOTOR`,
  Bloque 1 del generador ~L80), un filtro explícito y comentado que descarte las
  filas con `rbd` NA: `P <- dplyr::filter(P, !is.na(.data$rbd))`, con un `message()`
  que reporte cuántas filas se descartaron (transparencia C.10). Comentario que
  explique el porqué (fantasma rbd=NA del crudo 4b2017; ver H-FID-1).
- Constante/condición nombrada, no número mágico. Si prefieres filtrarlo más arriba
  (al leer el parquet) está bien, mientras sea UN punto único y explícito, no
  parches en cada bloque.
- Verifica que el filtro NO toca RBD reales: el `n_distinct(rbd)` tras el filtro
  debe ser exactamente el de antes menos cero (los RBD reales no tienen NA), y el
  total de establecimientos debe bajar exactamente en 1.
- Commit atómico: `fix(motor): filtrar establecimiento fantasma rbd=NA del crudo 4b2017`.

### Fase 2 — Regenerar y desplegar
- `source(.../35_generar_motor_html.R)`. Verifica que el resumen reporta
  establecimientos = 9136 (antes 9137) y que el `md5` del parquet sigue intacto.
- Copia `40_salidas/motor_idps.html` → `docs/index.html`.
- Commit atómico: `build(motor): redesplegar sin fantasma rbd=NA`.

### Fase 3 — Verificación
Decodifica el `docs/index.html` regenerado (decode independiente, como en
P-DISPLAY-FIDELITY) y confirma:
1. `establecimientos` ya NO contiene ninguna entrada con `rbd` null (busca rbd
   null/NA/"null" en el array). Conteo = 9136.
2. El buscador ya no puede listar el fantasma: simula la lógica de `buildList`
   rama establecimiento con `ql="null"` → 0 resultados de rbd-null.
3. Una cifra de control de un RBD real (p. ej. RBD 10, 4b, ind, 2024 = 83/78/87/74)
   sigue idéntica: el filtro no movió nada real.
4. `md5` parquet inicio == fin.

---

## 5. Criterios de éxito

1. `docs/index.html` desplegado: 0 establecimientos con rbd null; total 9136.
2. Buscar "null" en el motor → 0 tarjetas fantasma.
3. RBD reales intactos: cifra de control idéntica; `n_distinct(rbd real)` sin cambio.
4. `md5` parquet `4c764d8c…` inicio == fin.
5. Render sin errores de consola (si verificas en vivo).

---

## 6. Cierre

- Log breve en `50_documentacion/andamios/logs/YYYYMMDD_fix_fantasma_rbdNA_log.md`
  (plantilla fija; puede ser corto dado el alcance acotado): qué se filtró, dónde,
  conteo antes/después, verificación, md5 inicio/fin. Honesto.
- **NO** actualices `CLAUDE.md` (paso de cierre de sesión).
- **Push** tras `git status` limpio (esto actualiza Pages; es el objetivo).
- **Reporta:** conteo antes/después, los 5 criterios PASA/FALLA, hashes de commits,
  md5 inicio/fin, y confirmación del deploy (md5 live == local, como en P-MOTOR).

---

## 7. Qué NO hacer

- No tocar el parquet (filtrar al serializar, no borrar del dato).
- No filtrar nada con `rbd` real.
- No combinar con otros cambios (P-DOC, inventarios, case): solo el fantasma.
- No reintroducir los `idps4B2024_*.xlsx` (el parquet ya los tiene).
