# Propuesta de ordenación del repositorio (s33m T3, pendiente 12)

> **Propuesta**, no encargo de ejecución (SETTINGS §4.7.3 punto 1: la lista de movimientos se aprueba antes de ejecutar).
> **No se movió, renombró ni borró nada.** Cada fila lleva su grado de certeza (SETTINGS §4.7.2) y el resultado de su grep; los
> comandos literales y sus salidas están en el log `50_documentacion/andamios/logs/20260924_preparacion_decisiones_s33m_log.md`
> (M6 y FASE T3). Las filas de grado bajo son dudas, no recomendaciones. La decisión es del titular.
>
> Medido el 2026-09-25 sobre `main` en `c49043e` + T1 y T2 de s33m (ningún cambio fuera de documentos).

## 0. Estado de partida (medido)

- **Gatillo 4bis encendido:** no existe `50_documentacion/activa/50_ordenacion_repositorio.md`.
- **Traspasos:** `ls 50_documentacion/traspasos/*.md` → 1 (`traspaso_cierre_v31.md`); `traspasos/archivo/` → 30 (v01 a v30).
- **Normativos:** las copias locales de `POLITICA_PROYECTO.md` (v5.8) y `SETTINGS_Y_PROMPTS_OPERACIONALES.md` (v38) son **idénticas**
  byte a byte a las del kit (`herramientas_dev/gobernanza/`). No están versionadas en este repositorio público (`a9d8ac8`).
- **`50_documentacion/` versionado por carpeta:** `activa` 7 · `activa/decisiones` 9 · `activa/encargos` 54 · `activa/prototipos` 1 ·
  `andamios` 101 · `estructura` 7 · `suite` 15 · `traspasos` 2 · `traspasos/archivo` 30. Fuera de la estructura de POLITICA §1.1: `suite/`
  (15), cuya ubicación fija SETTINGS §4.6.3 punto 5 (línea 1890) ("Ubicación canónica de la salida: `50_documentacion/suite/`"); y dos subcarpetas de
  `activa/` que §1.1 no nombra: `encargos/` y `prototipos/`.
- **Nombres con tilde, `ñ`, espacio o guion medio:** 25 de 344 versionados (16 en `andamios/diseno/`, 4 en `suite/`, 5 en
  `20_insumos/auxiliares/referencias_idps/`); con tilde, `ñ` o espacio, solo 4, todos en `andamios/diseno/`.
- **Escáner:** `00_escanear_proyecto.R` excluye `.git`, `renv`, `.Rproj.user` y `_archivo` (líneas 65–66); no excluye `node_modules/`,
  `packrat/`, `venv/` ni `.quarto/`. Ninguna de esas cuatro carpetas existe hoy en el repositorio. Última foto:
  `estructura_actual.md`, 2026-09-23 23:16:26, **34 carpetas, 333 archivos**.

## 1. Cuestión previa: qué cuenta como "referencia viva"

SETTINGS §4.7.2 manda, para cada candidato de grado medio, `grep -rn --exclude-dir=_archivo --exclude-dir=.git "<nombre_archivo>" .`
y cancela la fila si hay una referencia viva; solo exime a `andamios/` (registro histórico). Medido aquí, ese grep encuentra **todo**
archivo del árbol en las fotos del escáner (`estructura/`: 3 fotos × `.md` y `.txt` = 6 coincidencias por archivo, porque cada foto
lista el árbol entero), y muchos también en `traspasos/archivo/`. Hay dos lecturas posibles, y el resultado de cada fila se da con las dos:

- **(L) Literal:** solo `andamios/` es registro histórico. Con esta lectura **toda fila de grado medio queda cancelada** por las fotos del
  escáner.
- **(H) Histórico ampliado:** también son registro, no referencia viva, `estructura/` (la regenera el escáner al final de la ejecución,
  §4.7.3 punto 6) y `traspasos/archivo/` ("solo se agrega; nunca se borra ni se reescribe", POLITICA §1.3.1).

## 2. Bloque 1 — Traspasos

| # | Movimiento | Grado | Evidencia |
|---|---|---|---|
| — | **Ninguno.** La aserción de cierre del bloque ya se cumple. | — | `ls 50_documentacion/traspasos/*.md` → 1 línea; normativos locales = kit (`cmp` sin diferencias) |

## 3. Bloque 2 — Obsoletos y duplicados

Destino de todo lo que sale del árbol vivo: `_archivo/AAAAMMDD/<ruta relativa>` (POLITICA §1.5). **Advertencia:** `_archivo/` está en
`.gitignore` (línea 30), así que archivar un documento versionado lo **saca del repositorio** (queda solo en el disco del titular). Cómo
se hace (`git mv` hacia una ruta ignorada o `git rm --cached` más copia) lo fija el encargo de ejecución; aquí no se probó (regla 5).

Grep: total · en `andamios/` · vivas (de ellas: en `estructura/` · en `traspasos/archivo/` · otras). Totales medidos **antes** de escribir
esta propuesta: como ella misma vive en `andamios/` y nombra cada candidato, un grep posterior suma sus menciones al total y a `andamios/`,
nunca a las vivas (re-medido en el log: las vivas no cambian).

| # | Archivo | Por qué es candidato | Grado | Grep | (L) | (H) |
|---|---|---|---|---|---|---|
| O-1 | `50_documentacion/activa/prompt_nuevo_proyecto_idps.md` | Prompt de apertura de un proyecto nuevo (2026-06-11); el proyecto está abierto desde junio. Nada lo declara superado; el traspaso v16 lo lista entre el "protocolo" de `activa/`. | medio | 8 · 1 · 7 (6 · 1 · ninguna) | cancelada | procede |
| O-2 | `50_documentacion/activa/prototipos/idps_radar_prototipo.jsx` | Prototipo del radar (2026-06-11). El traspaso v01 (P2) propuso archivarlo "cuando se construya el motor"; el v02 lo movió a `prototipos/` y lo **conservó como referencia de diseño** ("decisión B"). El motor existe. | medio | 10 · 0 · 10 (6 · 4 · ninguna) | cancelada | procede solo si el titular revoca la decisión B de v02 |
| O-3 | `50_documentacion/activa/censo_universo_idps.md` | Censo forense de junio (P5, fase 1). El traspaso v16 lo declara "artefacto vivo"; solo su fecha sugiere que está superado. | **bajo** | 15 · 3 · 12 (6 · 3 · 3 en `activa/encargos/`) | no se mueve (duda) | no se mueve (duda; además, referencias en `activa/encargos/`) |
| O-4 | `50_documentacion/activa/resena_slep_idps.md` | Reseña editorial con sus tres versiones en "[PENDIENTE: a definir por editor]"; nada la declara superada: está sin terminar, no reemplazada. | **bajo** | 10 · 3 · 7 (6 · 1 · ninguna) | no se mueve (duda) | no se mueve (duda) |

- **Grado alto: ninguna fila.** No hay en el árbol una versión posterior de ningún documento fuera de `andamios/`, ni un traspaso que
  declare abandonada una arquitectura con documentos aún en el árbol vivo. (P-PALETA y P-PALETA-v2 son dos encargos de sesiones distintas. De los 20 encargos que contienen
  "reemplaza", el único que declara reemplazar a otro encargo es este, s33m, respecto de s33k, que no está en el árbol; los demás hablan
  de componentes o textos.)
- **`estructura/`:** cumple la retención de 2 fotos de POLITICA §7.4 (dos fotos fechadas más `estructura_actual`): sin candidatos.
- **`activa/encargos/` (54 encargos ejecutados, incluido este):** no son documentos superados sino contratos de sesiones cerradas; no
  son candidatos del bloque 2. Queda una **duda estructural** (grado bajo): ni POLITICA §1.1, ni SETTINGS, ni la plantilla
  `encargo_autonomo_claude_code_v1.md` nombran esa carpeta.

## 4. Bloque 3 — Nomenclatura

Regla (POLITICA §1.2.4 y §2; SETTINGS §4.7.2): los archivos de las subcarpetas de `50_*` llevan el prefijo de su decena (`50_`), salvo
los que otro documento fija por nombre y los de patrón propio (fechados, `decisiones/`, traspasos). Antes de renombrar, grep del nombre en
POLITICA y en SETTINGS; todo renombre actualiza sus referencias en el mismo commit.

| # | Archivo actual | Nombre propuesto | POLITICA | SETTINGS | Grep de referencias (como en §3) | Grado | Nota |
|---|---|---|---:|---:|---|---|---|
| N-1 | `activa/censo_universo_idps.md` | `activa/50_censo_universo_idps.md` | 0 | 0 | 15 · 3 · 12 (6 · 3 · 3 en `activa/encargos/`) | medio | Las 3 de `traspasos/archivo/` y las 3 de `andamios/` no se pueden reescribir: quedarían con el nombre viejo. |
| N-2 | `activa/prompt_nuevo_proyecto_idps.md` | `activa/50_prompt_nuevo_proyecto_idps.md` | 0 | 0 | 8 · 1 · 7 (6 · 1 · ninguna) | medio | Solo si O-1 no procede. |
| N-3 | `activa/resena_slep_idps.md` | `activa/50_resena_slep_idps.md` | 0 | 0 | 10 · 3 · 7 (6 · 1 · ninguna) | medio | Idem N-1 para `traspasos/archivo/` y `andamios/`. |
| N-4 | `activa/prototipos/idps_radar_prototipo.jsx` | `activa/prototipos/50_idps_radar_prototipo.jsx` | 0 | 0 | 10 · 0 · 10 (6 · 4 · ninguna) | medio | Solo si O-2 no procede. |
| N-5 | `activa/encargos/*.md` (54; dos fuera del patrón `encargo_claude_code_idps_*`: `encargo_ajustes_motor_s14.md`, `encargo_paleta_v2_s15.md`) | prefijo `50_` | 0 | 0 | cada encargo lo citan su log (en `andamios/`) y las fotos del escáner; p. ej. `encargo_paleta_v2_s15.md`: 10 · 3 · 7 (6 · 1 · ninguna) | **bajo** | Duda: renombrar 54 contratos que citan logs congelados; no se propone. |
| N-6 | `suite/` (15) | — | — | — | `documentar.R` y los cuatro `*_standalone.html` los fija SETTINGS §4.6 (15 y 4 menciones); `suite_estilos.css` y `assets/logo-white-stacked.png` los cita `documentar.R` (líneas 37–38); `fonts/MuseoSans-300.otf` lo cita `suite_estilos.css` | no procede | Nombres del kit `suitedoc`; las referencias vivas están en código: fila cancelada. |
| N-7 | `estructura/` | — | 2 y 1 | 3 | — | no procede | `estructura_actual` y el patrón `YYYYMMDD_HHMMSS_estructura.md` los fija POLITICA §7.3 (líneas 698–712). |

- **Patrón propio, sin cambios:** `activa/decisiones/` (`AAAAMMDD_decision_<tema>.md`), `traspasos/` (`traspaso_cierre_vNN.md`) y las
  excepciones declaradas de `activa/` (`ESTADO.md`, `backlog_acumulativo.md`).
- **Fuera por `andamios/` congelado** (POLITICA §1.3 punto 7 y §1.6: sus rutas no se reescriben jamás): los 101 archivos versionados de
  `andamios/`, entre ellos 16 con espacio o guion medio: `diseno/motor_idps/Motor IDPS.html`, `…/fonts/MuseoSans-100.otf`,
  `…/fonts/MuseoSans-300.otf`, `…/idps-app.jsx`, `…/idps-charts.jsx`, `…/idps-controls.jsx`, `…/idps-data.js`,
  `…/screenshots/dual-default.png`, `diseno/rediseno_3pantallas/Handout IDPS.html`, `…/PROMPT para Claude.md`,
  `…/Propuesta IDPS.html`, `…/idps-demo.js` y `…/img/01-territorial.png` a `04-historica.png`. **Además**, `diseno/motor_idps/fonts/`
  es un insumo vivo del pipeline: `30_procesamiento/35_generar_motor_html.R` (línea 551, `font_dir`) lee de ahí las siete fuentes que embebe el motor.
- **Fuera del alcance del bloque** (no son subcarpetas de `50_*`): `20_insumos/auxiliares/referencias_idps/` (5 PDF con guion: nombres de
  la fuente externa, excepción de POLITICA §1.2.4) y el orquestador de la raíz, `00_build.R`, que POLITICA §1.1 y §4 llaman
  `00_run_all.R` (deuda heredada; no es documentación).

## 5. Bloque 4 — Escáner

| # | Cambio | Grado | Evidencia |
|---|---|---|---|
| E-1 | `00_escanear_proyecto.R`, línea 65: agregar `"node_modules"`, `"packrat"` y `"venv"` a `DIRS_EXCLUIR` | alto | POLITICA §7.2 lo manda y SETTINGS §4.7.2 (bloque 4) lo verifica; hoy 0 coincidencias de los tres en el script. Ninguna de las tres carpetas existe: el total antes y después es el mismo (34 carpetas, 333 archivos en la última foto; el escáner se corre al final de la ejecución). |
| E-2 | Mismo lugar: agregar `".quarto"` | medio | POLITICA §7.2 también la nombra; SETTINGS §4.7.2 no la pide. No existe hoy (0 carpetas). |

- **Observación (sin fila):** POLITICA §7.2 habla de excluir "carpetas ocultas y de sistema"; la foto actual incluye `.claude/` (configuración
  local de la herramienta) y 8 `.DS_Store`. Ni §7.2 ni §4.7.2 los nombran; se deja anotado para el titular.

## 6. Precondiciones y entrega de la ejecución (recordatorio, SETTINGS §4.7.1 y §4.7.3)

Rama propia `ordenacion/AAAAMMDD` (no `main`), árbol y stash vacíos, `@{u}...HEAD` = `0 0`; un commit por bloque con rutas explícitas;
manifiesto con `git hash-object` de cada archivo movido (origen y destino); log de greps con las filas canceladas; grep de privacidad y de
coautoría antes de cada commit; escáner al final; PR (el merge lo decide el titular); el último commit crea
`50_documentacion/activa/50_ordenacion_repositorio.md`, que apaga el gatillo 4bis.

## 7. Resumen por bloque y grado de certeza

| Bloque | Alto | Medio | Bajo (dudas) | No procede / cancelada |
|---|---:|---:|---:|---:|
| 1. Traspasos | 0 | 0 | 0 | 0 (nada que mover) |
| 2. Obsoletos y duplicados | 0 | 2 (O-1, O-2) | 2 (O-3, O-4) + la duda estructural de `encargos/` | con la lectura (L): O-1 y O-2 |
| 3. Nomenclatura | 0 | 4 (N-1 a N-4; N-2 y N-4 condicionadas a O-1 y O-2) | 1 (N-5) | 2 (N-6, N-7) |
| 4. Escáner | 1 (E-1) | 1 (E-2) | 0 | 0 |

## 8. Lo que el titular decide

1. **La lectura del grep (§1).** ¿(L) literal, con lo que O-1, O-2 y N-1 a N-4 se cancelan; o (H) `estructura/` y `traspasos/archivo/`
   como registro histórico?
2. **O-1, el prompt de apertura.** ¿(a) se archiva; o (b) se queda en `activa/` (y entonces N-2)?
3. **O-2, el prototipo.** ¿(a) se revoca la decisión B de v02 y se archiva; o (b) se queda como referencia de diseño (y entonces N-4)?
4. **Renombres con referencias que no se pueden reescribir** (N-1 a N-4: `traspasos/archivo/` y `andamios/`). ¿(a) se renombra y esas
   referencias quedan con el nombre viejo; o (b) no se renombra y el archivo queda como excepción?
5. **`activa/encargos/`.** ¿(a) queda como está (y se pide al kit que la política la nombre); (b) los encargos ejecutados salen de
   `activa/`; o (c) se decide en otro momento?
6. **Archivar saca del repositorio.** ¿Se acepta que lo que va a `_archivo/` deje de estar versionado (sí / no)?
7. **E-2 y la observación de §5.** ¿Se excluye también `.quarto/` (sí / no)? ¿Y `.claude/` y `.DS_Store` de la foto (sí / no)?
