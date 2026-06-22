# Encargo autónomo — P-PALETA: alinear la paleta de indicadores a la identidad de la Agencia

> Modo autónomo, secuencial. Ejecuta todo en este turno. Detente y reporta SOLO
> en los tres casos de la regla de detención (§0.2). Stack: R-only para el
> pipeline; el template es HTML/JS/D3 inline. Rutas absolutas siempre, sin asumir
> `cd` previo. Reglas canónicas heredadas de `POLITICA_PROYECTO.md` (commits
> atómicos, gobernanza, principios §5) y de `encargo_autonomo_claude_code_v1.md`
> (auto-auditoría, log de cierre): se referencian, no se reexplican.

---

## 0. Contrato

### 0.1 Meta (aprobada por el titular)

La paleta de los 4 indicadores IDPS del motor debe adoptar la identidad cromática
del folleto oficial de la Agencia (los 4 círculos del documento
"¿Cuáles son los Indicadores de Desarrollo Personal y Social?"), reemplazando la
paleta interna actual (rojo/amarillo/verde-lima/azul). El mapeo indicador→color
está confirmado contra los rótulos impresos del folleto.

### 0.2 Regla de detención (PARA y reporta)

1. Un invariante 🔒 te obligaría a violar el contrato de datos/fidelidad.
2. Un dato real contradice un supuesto de este encargo (p. ej. `INDICADOR_COLORS`
   en `35` ya no contiene los hex que este encargo dice reemplazar; el JSON no
   expone `ind.color`; el build regenerado cambia alguna CIFRA, no solo color).
3. Un gate estratégico no resuelto. **No hay gates abiertos en este encargo:** el
   mapeo está confirmado, la fuente está fijada (§1), y la política de contraste de
   texto se delega a tu criterio por umbral (Fase 3). Procede sin preguntar.

### 0.3 Paleta canónica nueva (fuente fijada, NO la cambies)

Muestreada por moda exacta del folleto oficial (PNG de alta nitidez; procedencia
documentada en la decisión de la Fase 5). Mapeo confirmado contra rótulos:

| id | Indicador (corto) | Hex NUEVO | Hex que reemplaza |
|----|-------------------|-----------|-------------------|
| 1  | Autoestima        | `#3858A3` | `#EE2D49` |
| 2  | Convivencia/Clima | `#61BDC6` | `#FFC92E` |
| 3  | Participación     | `#4BA560` | `#9BC93E` |
| 4  | Hábitos           | `#AACB58` | `#2A8FD9` |

---

## 1. Contexto mínimo suficiente

- **Repo:** `/Users/tomgc/Projects/slep_idps` (Rama A pública; datos versionados).
- **Generador:** `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`.
  Define `INDICADOR_COLORS` (L42) e inyecta `color` por indicador al JSON (L116).
- **Template:** `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`.
  Bloque `:root` con `--ind1..4` (L12) y tokens de estado (L13–19).
- **Build de salida:** `40_salidas/motor_idps.html`, que se copia/publica como
  `docs/index.html` (GitHub Pages desde `main`).
- **Cómo se construye:** `Rscript 00_build.R` (orquestador) o el paso `only=35`.
  Confirma el mecanismo real leyendo `00_build.R` antes de regenerar.

### Arquitectura de color (ya diagnosticada — confírmala leyendo, no asumas)

- **Fuente única runtime:** cada indicador lleva `color` en el JSON, puesto por
  `INDICADOR_COLORS` en `35`. Casi todo el motor lee `ind.color` (radar L625/L920,
  `BarrasAnio` L970, dots, swatches de leyenda L1402, tabla territorial L1241,
  paneles L1421). **Cambiar `INDICADOR_COLORS` + regenerar propaga a todos esos
  usos.**
- **`dimColor(mother,di,total)`** (template L714–715) deriva tonos de dimensión
  aclarando/oscureciendo el color madre (factor `f ∈ [-0.05,+0.35]`). Al cambiar la
  base, los derivados se recalculan solos.
- **`--ind1..4`** en `:root` (L12) está declarado pero **ningún CSS lo consume vía
  `var(--ind…)`** (token espejo). Actualízalo por coherencia documental; no afecta
  render.
- **`COLB`/`--cmp-year`** (`#C77D3A`, L562) es color de serie de comparación
  temporal, NO de indicador. **No se toca.**

---

## 2. Invariantes (🔒)

1. 🔒 **El parquet `idps_largo.parquet` no se lee, audita ni modifica.** md5 debe
   seguir `4c764d8c9f0bf70004f8aa52661ae901`. La paleta es presentación.
2. 🔒 **Ninguna CIFRA del motor cambia.** El build regenerado debe ser idéntico al
   certificado en todo lo que no sea color: mismo universo (9.136 EE), mismos
   `prom/dif/sig/niveles`, misma estructura JSON salvo los 4 valores `color`. La
   re-verificación de fidelidad (Fase 4) lo comprueba.
3. 🔒 **Solo cambia la paleta de INDICADOR.** NO toques los tokens de ESTADO
   (`--alerta`, `--destaca`, `--bajo`, `--medio`, `--alto`, `--st-neutro`,
   `--coral`) ni la identidad gobCL (`--azul`, `--cream`, `--foco`). El comentario
   de L14–17 documenta que la coincidencia previa estado↔indicador era intencional;
   al cambiar la paleta de indicador esa coincidencia desaparece sola y es correcto
   que así sea. Estado e indicador son ejes semánticos distintos.
4. 🔒 **No inventar significancia/GSE/geo donde el dato trae NA** (vigente desde
   v11; no debería tocarse en este encargo, pero rige).
5. 🔒 **No desplegar a ciegas.** El deploy (Fase 6) ocurre solo si las Fases 4 y 5
   pasan. Si la fidelidad falla, PARA y reporta.

---

## 3. Fases en orden estricto

### Fase 0 — Lectura del estado real (no modificar sin leer)

- Lee `35_generar_motor_html.R` (al menos L38–120) y confirma que `INDICADOR_COLORS`
  (L42) contiene exactamente `#EE2D49/#FFC92E/#9BC93E/#2A8FD9`. Si no, PARA (§0.2.2).
- Lee el `:root` de `35_motor_template.html` (L9–35) y confirma `--ind1..4` (L12).
- Lee `00_build.R` y registra el comando real de regeneración (orquestador vs
  `only=35`) y de copia a `docs/`.
- `git status` limpio antes de empezar (si hay cambios sin commitear ajenos a este
  encargo, PARA y reporta).

### Fase 1 — Generador: nueva paleta (determinista)

- En `35_generar_motor_html.R` L42, reemplaza `INDICADOR_COLORS` por:
  ```r
  INDICADOR_COLORS <- c("1" = "#3858A3", "2" = "#61BDC6", "3" = "#4BA560", "4" = "#AACB58")
  ```
- Actualiza el comentario de L41 para que refleje la nueva procedencia (folleto
  Agencia, no "madre/prototipo").
- **Commit atómico:** `feat(paleta): adoptar identidad cromatica del folleto Agencia en INDICADOR_COLORS`.

### Fase 2 — Template: token espejo y comentario (coherencia documental)

- En `:root` L12, actualiza `--ind1..4` a los nuevos hex (mismo orden 1→4).
- Ajusta el comentario de L14–17 si es necesario para que no afirme una coincidencia
  estado↔indicador que ya no existe (documenta que la paleta de indicador ahora
  sigue el folleto y que los tokens de estado conservan su semántica propia).
- **No toques** ninguna línea de estado (L13, L19) ni `--coral` (L14).
- **Commit atómico:** `style(paleta): sincronizar tokens espejo --ind1..4 al folleto`.

### Fase 3 — Contraste de texto sobre fondos de indicador (tu criterio por umbral)

Los círculos/badges/dots llevan texto o iconografía. Tres de los cuatro hex nuevos
son claros (`#61BDC6`, `#4BA560`, `#AACB58`).

- Calcula el contraste WCAG (ratio de luminancia relativa) de **texto blanco**
  sobre cada uno de los 4 fondos nuevos.
- **Regla de decisión (tuya, por umbral):** para cada fondo donde blanco no alcance
  **4.5:1** (AA texto normal) o **3:1** (AA texto grande / elementos gráficos,
  según el rol real del texto en ese componente), cambia el color de texto a la
  tinta oscura del sistema (`var(--tinta)` `#23303a`) **solo en ese componente**.
  Donde blanco sí pase, consérvalo (fidelidad al folleto).
- Aplica esto en los componentes que renderizan texto/icono sobre `ind.color`:
  badges de indicador, dots con label encima si los hay, swatches con texto. Los
  swatches puramente decorativos (cuadrito de leyenda sin texto encima) no
  requieren ajuste de contraste de texto, pero si su `ⓘ`/borde queda invisible
  sobre `cream`, dales borde sutil.
- Si un fondo claro queda con bajo contraste **contra el fondo `cream` de la
  página** (no contra su texto) en elementos finos (líneas de radar, bordes de
  barra), aplica el mínimo realce necesario (borde o leve oscurecido SOLO del
  trazo, no del fill de marca). Documenta cada decisión en el log.
- **Commit atómico:** `fix(a11y): contraste de texto sobre fondos de indicador claros (umbral WCAG AA)`.

### Fase 4 — Regenerar y re-verificar fidelidad (🔒 el corazón del encargo)

- Regenera el build con el comando real de Fase 0 (`only=35` u orquestador).
- Verifica que `40_salidas/motor_idps.html` se regeneró y, si el flujo lo exige,
  cópialo a `docs/index.html` (replica el mecanismo de `00_build.R`, no improvises).
- **Re-verificación de fidelidad parquet→sitio:** corre el verificador de fidelidad
  vigente del proyecto (busca `verificar_*.R` relacionado con display/fidelidad;
  el log de s12 `20260621_display_fidelity_log.md` indica cuál). Debe confirmar:
  - universo intacto (9.136 EE),
  - `prom/dif/sig/niveles` byte-idénticos al build certificado,
  - única diferencia en el JSON: los 4 valores `color` de `indicadores`.
- **md5 del parquet** antes/después: idéntico (🔒 1).
- **Commit atómico:** `build(paleta): regenerar motor con paleta Agencia + recopiar a docs`.

### Fase 5 — Decisión documentada (procedencia de la paleta)

- Crea `50_documentacion/activa/decisiones/20260622_decision_paleta_indicadores.md`
  con: las dos paletas en conflicto (interna previa vs folleto), la decisión
  (adoptar folleto), el mapeo confirmado, los 4 hex nuevos, **la procedencia
  honesta** (muestreo por moda exacta del PNG del folleto, alta nitidez, no
  extracción vectorial del PDF — deuda menor declarada), y la frase canónica ante
  validación externa ("la paleta del motor replica la identidad oficial de los 4
  indicadores IDPS de la Agencia de Calidad").
- **Commit atómico:** `docs(decision): registrar adopcion de paleta del folleto Agencia`.

### Fase 6 — Deploy (solo si Fases 4 y 5 pasan)

- Si todo lo anterior está verde y `git status` solo muestra lo de este encargo,
  haz push a `main` para publicar en Pages.
- Si la fidelidad falló en cualquier punto: **NO despliegues**, PARA y reporta con
  evidencia.

---

## 4. Criterios de éxito verificables (B.4)

- `INDICADOR_COLORS` y `--ind1..4` contienen exactamente los 4 hex nuevos, mismo
  mapeo 1→4. (grep)
- Tokens de estado intactos: `--alerta:#EE2D49`, `--destaca:#2A8FD9`, `--bajo`,
  `--alto`, `--coral` sin cambios. (grep diff contra build certificado)
- Build regenerado renderiza sin errores de consola; radar, `BarrasAnio`, leyendas,
  tabla territorial y paneles muestran los colores nuevos. (verificación en navegador)
- Fidelidad parquet→sitio: PASA, con la única diferencia esperada en los 4 `color`.
- md5 del parquet sin cambios.
- Contraste: ningún texto sobre fondo de indicador por debajo del umbral AA aplicable
  a su rol. (cálculo WCAG reportado en el log)
- Decisión documentada en `decisiones/`.

---

## 5. Auto-auditoría antes de reportar (panel adversarial — obligatorio)

Este encargo toca un build certificado y declara un 🔒 de "ninguna cifra cambia".
Eso exige panel adversarial (no basta el check inline). Tras la Fase 4, lanza
agentes de solo-lectura que, **con código propio independiente**, re-deriven:

1. **Que ninguna cifra cambió:** parsear el JSON embebido del build NUEVO y del
   build CERTIFICADO (o regenerar el certificado en un worktree limpio si no lo
   tienes), y diff de todos los campos `prom/dif/sig/sigdif/difgru/sigdifgru/niveles`
   por (rbd, grado, año, id). Debe ser vacío. La ÚNICA diferencia admisible es
   `indicadores[*].color`.
2. **Que el universo no cambió:** `n_distinct(rbd)` = 9.136 en ambos builds.
3. **Que los tokens de estado no se movieron:** diff del bloque `:root` acotado a
   las líneas de estado.
4. **Contraste:** re-calcular de forma independiente el ratio WCAG de los 4 fondos
   con texto blanco y confirmar que las decisiones de Fase 3 son coherentes con el
   umbral declarado.

Si el panel detecta cualquier diferencia de cifra, el encargo FALLA: revierte el
build, NO despliegues, reporta.

---

## 6. Log y cierre

- Escribe el log en
  `50_documentacion/andamios/logs/20260622_paleta_indicadores_log.md` siguiendo la
  plantilla fija de `encargo_autonomo_claude_code_v1.md` §4 (resumen, inventario de
  commits por fase, cambios sustantivos con causa raíz, verificación de cada 🔒 con
  PASA/FALLA y evidencia, decisiones de contraste, md5 del parquet antes/después,
  pendientes y `# REVISAR`, notas para el revisor).
- Honesto: incluye lo que costó (p. ej. si algún fondo claro exigió fallback de
  texto no previsto, o si `dimColor` produjo un tono de dimensión con poco
  contraste que hubo que realzar).
- Deja el log **sin commitear** para revisión previa del titular, O commitéalo como
  `docs()` atómico aparte; indícalo en el reporte.

## 7. Reporte final al chat

Devuelve: hashes de los commits por fase; resultado del panel adversarial (diff de
cifras = vacío, universo = 9.136, tokens de estado intactos); tabla de contraste
WCAG de los 4 fondos con la decisión texto-blanco/tinta por componente; md5 del
parquet antes/después; confirmación de deploy (o motivo de no-deploy); ruta del log;
cualquier `# REVISAR`.
