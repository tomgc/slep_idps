# Log — Documentar cobertura histórica IDPS (s25)

**Fecha:** 2026-06-25
**Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_cobertura_historica.md`
**Modo:** autónomo, secuencial. Commit atómico por fase.
**Base:** HEAD previo `01b0f14` (deploy s24).

---

## 1. Resumen

El histórico 2014-2025 ya está integrado en el parquet (pendiente heredado obsoleto). Este
encargo NO toca datos: documenta la cobertura histórica y la razón de sus huecos en tres capas
sin propagar texto entre ellas: (1) una **decisión interna** (4 grados, intermitencia 6b/8b +
2019), (2) **comentarios de constancia** en el pipeline (`34` y `35`), y (3) una **nota visible**
del motor que se limita a 2019/4b/2m (los grados que el motor expone). Build local regenerado y
verificado; `docs/` SIN tocar (gate visual del titular).

---

## 2. Inventario de commits

| Hash | Tipo | Título |
|------|------|--------|
| `551dfd3` | docs | fija cobertura historica IDPS y razon de huecos (s25) |
| `152b73f` | docs | ancla razon de huecos de cobertura historica en 34 y 35 |
| `67f5aa5` | feat | amplia nota de vista historica con razon de 2019 (estallido) |

`docs/index.html` no se tocó. HEAD = `67f5aa5`.

---

## 3. Por cambio: qué / por qué / verificación

### Fase 1 — Decisión interna (`551dfd3`)
- **Qué:** nuevo `50_documentacion/activa/decisiones/20260625_decision_cobertura_historico_idps.md`
  con las 6 secciones del encargo (contexto, decisión, cobertura por familia, cobertura por grado,
  razón de los huecos con la referencia pública de la Agencia en estilo indirecto, implicancia).
- **Por qué:** fija que la cobertura disponible es la máxima de la fuente; los huecos son ausencia
  de aplicación, no deuda de datos. Documenta los 4 grados (universo del parquet).
- **Verificación:** archivo autocontenido, español neutro, sin tildes en el nombre; cita la URL de
  la Agencia en estilo indirecto (no entrecomillado).

### Fase 2 — Constancia en el pipeline (`152b73f`)
- **Qué:** comentario de constancia en `34_leer_normalizar_idps.R` (junto a `PATRON_HISTORICO`) y
  en `35_generar_motor_html.R` (junto a `eje_historico`/`ANIOS_PANDEMIA`), con referencia a la
  decisión. Capa de código → documentan los 4 grados (intermitencia 6b/8b + 2019).
- **Por qué:** dejar registro en el punto del código donde vive la lógica, sin alterarla (B.3).
- **Verificación:** `git diff` de ambos archivos = SOLO líneas `+#` (comentarios); cero código
  ejecutable cambiado. La clasificación `no_eval`/`pandemia` y el patrón no se tocaron.

### Fase 3 — Nota visible al usuario (`67f5aa5`)
- **Qué:** ampliación quirúrgica del `.ficha-explain` existente de la vista histórica
  (`35_motor_template.html`, dentro de `.hist-wrap`). Se reemplazó solo el paréntesis escueto del
  2019 — `(2020–2021 por pandemia; 2019 el grado no se evaluó)` → `(2020–2021 por pandemia)` + el
  texto definitivo aprobado (literal, íntegro) sobre el estallido social. Costura por puntuación
  (punto y seguido), conservando intactos el resto del `.ficha-explain` (promedio móvil, "sin
  dato", carácter preliminar, intro).
- **Por qué:** explicar al usuario por qué 2019 sale en gris, sin duplicar el bloque (R10).
- **Verificación:** ver §4 y §5.
- **Separación de capas (🔒):** la nota NO menciona 6b/8b (verificado en el render); habla solo de
  2019/4b/2m.

---

## 4. Verificación del payload (regla de detención 2)

- **Método:** baseline = JSON embebido de `docs/index.html` (= `01b0f14`); nuevo = JSON del
  `motor_idps.html` regenerado. Descompresión base64→gunzip y comparación byte a byte.
- **Resultado:** el JSON crudo difiere en **EXACTAMENTE 1 byte**: `meta.fecha_generacion`
  `"2026-06-24"` → `"2026-06-25"` (el `4`→`5`). Tras neutralizar `fecha_generacion`, los dos JSON
  son **idénticos** (`cmp` sin diferencias). Tamaños idénticos (59.465.915 bytes).
- **Conclusión:** CERO cambios en cifras, roster, ind/dim/niv, `eje_historico`,
  `primer_anio_familia`. El único delta del payload es la fecha de build (metadata, esperada al
  regenerar hoy), NO una cifra → no se activa la regla de detención 2. La nota nueva vive en el
  HTML del template, fuera del JSON.

---

## 5. Verificación de invariantes 🔒

| Invariante | Resultado | Evidencia |
|-----------|-----------|-----------|
| `idps_largo.parquet` md5 `4c764d8c…` intocable | **PASA** | md5 antes y después = `4c764d8c9f0bf70004f8aa52661ae901` (el encargo no corre el `34`). |
| `eje_historico` / `no_eval`/`pandemia` no se tocan | **PASA** | Fase 2 solo añadió comentarios; la clasificación server-side intacta; `eje_historico` idéntico en el payload. |
| Separación de capas (no propagar texto) | **PASA** | Decisión y comentarios documentan 4 grados (incl. 6b/8b); la nota visible habla solo de 2019/4b/2m (render: `mencionaGrados6b8b = false`). |
| NO deploy a `docs/` | **PASA** | `git status docs/` vacío; commits path-scoped a decisión / `34`+`35` / template+build. |
| Un cambio conceptual por commit; `git add` path-scoped | **PASA** | 3 commits atómicos; nunca `git add .`. |
| Tildes UTF-8 sin mojibake | **PASA** | "4° básico", "2° medio", "país", "no fue válida", "según los estándares" presentes en `motor_idps.html`; 0 secuencias de mojibake. |

**Render (viewport 1280, R-VIEWPORT-RENDER):** RBD 1692 (serie larga), vista histórica. El
`.ficha-explain` ampliado renderiza completo (incl. la nota 2019 y su cierre), altura 166px, sin
overflow horizontal; conserva promedio móvil y "sin dato"; 4 indicadores y 48 barras (eje
contiguo intacto); 0 errores de consola. Screenshot tomado.

---

## 6. Lo que costó / notas

- El diff del payload disparó una alerta inicial (`cmp` "differ: char 39"). Investigado: era
  `meta.fecha_generacion` (1 byte, la fecha del día), no una cifra. Resuelto neutralizando el
  campo y reconfirmando identidad byte a byte del resto. Sin esto, podría haberse leído como
  cambio de datos; la verificación lo descartó limpiamente.

---

## 7. Estado y pendientes

- **Estado:** build local listo (`40_salidas/motor_idps.html`), `docs/` SIN tocar — **gate visual
  del titular pendiente**. 3 commits locales nuevos sobre `01b0f14`; sin push.
- **Pendientes anotados por el encargo (NO ejecutados):**
  - Suite de documentación (`documentar.R`) y corpus conceptual: incorporar la cobertura histórica
    (pasada propia).
  - Tooltip por año `no_eval` en la vista histórica, derivado del `eje_historico`.
  - Cierre formal del pendiente histórico obsoleto en el traspaso v25 (lo hace el asistente de
    análisis).
