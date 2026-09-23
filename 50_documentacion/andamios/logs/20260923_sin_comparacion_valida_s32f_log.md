# Log de sesión: "sin comparación válida" y n_con_comparacion (s32f)

- **Meta:** aplicar la decisión del titular (2026-09-23): `sigdifgru` vacío significa que no hay comparación válida con su GSE (la Agencia solo informa comparaciones válidas). Cambiar los textos visibles "sin comparación publicada" → "sin comparación válida" en la plantilla, renombrar `n_con_dato` → `n_con_comparacion` en el CSV del comparador (D-1 de s31), enmendar la decisión de la vista histórica, regenerar, desplegar y publicar.
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación del titular)
- **HEAD al empezar:** `bb7ef75` (= `origin/main`).
- **Modo:** instrucción directa del titular en siete pasos, sin subagentes, deteniéndose ante cualquier resultado distinto del esperado. Instrumentos en `/tmp/s32f_*`.

## Registro

| paso | medición | esperado | obtenido | estado |
|---|---|---|---|---|
| 1a | `git status --porcelain`; `git rev-parse --short HEAD` | vacío; `bb7ef75` | vacío; `bb7ef75` | coincide |
| 1b | hash §8.2 del payload del motor (`/tmp/s32e_payload_norm.js` sobre la copia `/tmp/s32f_motor_antes.html`, md5 `4b485f4f…`) | `eb4e00b3…` | `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` | coincide |
| 2a | reemplazos por contenido en la plantilla (script con `assert` de 1 coincidencia por texto): chip L973, nota L1089, `aria-label`/`title` de `StackedBar` L1094, L1103-1104, L1118, glosa L1867, `CSV_SIN_CMP_GSE` L2128, cabecera L2182 y comentario L2176-2178 | 10 reemplazos, cada texto hallado 1 vez | `ok 10 reemplazos`; `+13/−13` | coincide |
| 2b | `grep -n 'comparación publicada\|vs GSE publicada\|no publica la comparación con su GSE\|"n_con_dato"'` | solo líneas de comentario | solo L587 (comentario CSS `/* … "sin comparación publicada" no cabe … */`) | coincide |
| 2c | `grep -c 'sin comparación válida'` | ≥ 4 | `6` | coincide |
| 2d | L1297 (comparación con la evaluación anterior) y L2739 (estado vs GSE no publicado en el nivel) | sin tocar | intactas | coincide |
| 3 | enmienda al final de `20260917_decision_vista_historica_territorial.md` | la línea literal del titular, al final; nada más cambia | `+2` (línea en blanco + la enmienda); 1 línea con contenido en el diff; queda como última línea | coincide |
| 4a | `run_all(only = 35L)` | exit 0 | `rc=0`, 0 líneas con "warn"; motor `fd09162250e17481af5014b58fa824f8` | coincide |
| 4b | hash §8.2 del payload | = 1b (`eb4e00b3…`) | `eb4e00b3784452eb1037b37d60d712dd7cfff7f97d989474b2894614fa624dc4` | coincide |
| 4c | chip en una tarjeta con `al.cmp===0` (`/tmp/s32f_verif.js`: primer RBD de 4b 2025 con GSE, puntaje y sin `sigdifgru` en ningún indicador, según `alertSummary(indOf(…))`; 892 candidatos; su comuna, código `4201`, abierta en el panorama) | "· sin comparación válida" con el `title` nuevo | `· sin comparación válida`, `title` "Con puntaje, pero sin comparación válida con su GSE en ningún indicador" | coincide |
| 4d | nota de una barra del comparador (Chile, 4b 2025) | dice "sin comparación válida" | 20 notas; p. ej. `+464 sin comparación válida`, `title` "Establecimientos con puntaje sin comparación válida con su GSE: 464. No entran en el 100 % de la barra."; `aria-label` con "comparación válida" 20, con "comparación publicada" 0 | coincide |
| 4e | CSV del comparador (Blob interceptado: `URL.createObjectURL` + `HTMLAnchorElement.prototype.click`) | trae `n_con_comparacion` y no `n_con_dato` | `idps_comparador_4b_2025.csv`, 21 filas; cabecera `…;indicador_label;n_con_comparacion;n_bajo;n_neutro;n_sobre;n_sin_comparacion;…`; `n_con_dato` ausente; 0 apariciones de "publicada" | coincide |
| 4f | errores de consola y `pageerror` | 0 | `[]` | coincide |
| 5a | commit de plantilla y motor | `fix(motor): 'sin comparación válida' y n_con_comparacion (s32f)` con las 2 rutas | `da2d7ac`; `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html` | coincide |
| 5b | commit de la decisión | `docs(decision): enmienda s32f` con 1 ruta | `4b01f6f`; `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md` | coincide |
| 6a | `cp` del motor a `docs/index.html`; md5 de los dos | iguales | `fd09162250e17481af5014b58fa824f8` y `fd09162250e17481af5014b58fa824f8` | coincide |
| 6b | `grep -c 'sin comparación válida' docs/index.html` | ≥ 1 | `6` | coincide |
| 6c | commit del despliegue | `deploy(docs): motor s32f` solo con `docs/index.html` | `bcb956b`; `docs/index.html` | coincide |
| 7 | commit de este log; `fetch`; `HEAD..origin/main`; `git push origin main` | commit `docs(log): s32f`; `0`; push aceptado | se mide después de commitear este archivo (no puede contener su propio resultado); va en el reporte | — |

## Notas

- Pendientes cerrados por este cambio: D-1 de s31 (`n_con_dato` → `n_con_comparacion`) y el rótulo del chip de D-3 de s31 (el chip se conserva, con el texto nuevo).
- `CSV_SIN_CMP_GSE` cambia el texto de la columna `estado_vs_gse` en los CSV (panorama, ficha y comparador), no el dato: el hash §8.2 del payload no cambió.
- El comentario CSS de la L587 conserva la cita del texto viejo ("sin comparación publicada" no cabe…): es historia del porqué de una regla de estilo, no un texto visible.
- Testigo del despliegue: "sin comparación válida" en el `index.html` publicado (6 apariciones) y la columna `n_con_comparacion` en el CSV del comparador.
