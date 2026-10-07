# Encargo autónomo: matriz de patrones de usabilidad entre los tres motores (s33n)

> Revisión de **solo lectura** de tres repositorios: `slep_idps` (origen de los patrones), `slep_simce_adecuado` y `slep_categoria_desempeno`. Produce una matriz patrón × motor con evidencia, que el redactor usa para el estándar de motores y para los encargos de cada hermano. **No escribe en ningún hermano.**

## 0. Encabezado de contrato

- **Modo:** autónomo, todo en este turno. **Subagentes admitidos, solo de lectura.** Tope duro: **5 simultáneos, de ellos 3 o menos en Opus**; total Opus del encargo **≤ 9**; los de modelo intermedio solo listan, cuentan y transcriben.
- **EJECUCIÓN:** esfuerzo `ultracode`; orquestador el modelo de la sesión; subagentes tope 3 Opus simultáneos (más hasta 2 intermedios); total Opus del encargo ≤ 9 (`encargo_autonomo_claude_code_v1.md` §2.12, fila 3: revisión de solo lectura sobre unidades independientes).
- **Plan de concurrencia:** ola 1: tres subagentes Opus de lectura, uno por motor, cada uno aplica **el mismo inventario de patrones** (§6) a su repositorio; ola 2: tres subagentes Opus de lectura, cada uno re-deriva de forma independiente las filas de un motor que la ola 1 marcó como "ausente" o "divergente" (panel adversarial: intenta refutar); ola 3 (si hace falta): hasta tres Opus sobre las discrepancias entre ola 1 y ola 2. El orquestador escribe la matriz, el log y los commits; ningún subagente escribe en ningún árbol.
- **ENTORNO:** Claude Code sobre el filesystem local del titular, macOS. Raíces: `/Users/tomgc/Projects/slep_idps` (escritura solo del ALCANCE), `/Users/tomgc/Projects/slep_simce_adecuado` y `/Users/tomgc/Projects/slep_categoria_desempeno` (solo lectura).
- **INSUMOS (en disco):** en cada repositorio, su plantilla de motor (la de `slep_idps` es `30_procesamiento/35_motor_template.html`; la de `slep_simce_adecuado` es `30_procesamiento/33_motor_template.html`; la de `slep_categoria_desempeno` se localiza en FASE 0), su motor compilado, su `docs/index.html` y su `CLAUDE.md` si existe; en `slep_idps`, los logs de s29 a s33 y las decisiones de `50_documentacion/activa/decisiones/`.
- **POSICIÓN:** rutas absolutas; ningún comando asume `cd`; `bash` explícito; `node` para Puppeteer (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motores por `file://`). En los hermanos, **ningún comando que escriba** (ni `git fetch`, que escribe refs: se usa `git -C <hermano> log -1` y `git -C <hermano> status --porcelain` solo para registrar su estado). Ningún shell en segundo plano queda corriendo al terminar.
- **LOG:** `50_documentacion/andamios/logs/20260924_matriz_hermanos_s33n_log.md` (en `slep_idps`).
- **PUNTO DE RETORNO:** FASE 0 mide en `slep_idps` `git status --porcelain`, `git stash list` (vacío) y `git rev-parse --short HEAD`; en cada hermano, `git rev-parse --short HEAD`, `git status --porcelain` y el md5 de su plantilla (para demostrar al final que no cambiaron).
- **PRUEBAS (sin arnés; sustituto declarado):** los md5 de las plantillas, motores y `docs/` de los tres repositorios iguales al inicio y al final.
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria; 1 reintento por subagente con el mismo contrato.
- **Reglas canónicas:** commits en español; `git add` con rutas explícitas; la matriz **describe**, no prescribe: cada celda con evidencia (archivo y línea, o medición), y la columna "¿aplica?" se razona por el problema que el patrón resuelve, **sin forzar uniformidad donde el hermano tiene una razón propia**.

### Contrato de subagentes (§2.11 del instrumento, transcrito)

1. Tope: 5 simultáneos, de ellos 3 o menos en Opus; el orquestador no cuenta.
2. Un solo rol: **lectura** (medir, buscar, citar líneas, correr Puppeteer sobre un motor por `file://`). Sin escritura en ningún árbol, sin git que escriba, sin log, sin lanzar subagentes.
3. Olas según el plan de concurrencia; nadie commitea; el orquestador verifica cada retorno.
4. Cada subagente recibe: su motor, el inventario de §6, los 🔒 con su porqué, la POSICIÓN, la regla "sin escritura; ante duda, detente y devuelve", y el formato de retorno: por patrón, estado (presente, ausente, divergente, no aplica), evidencia (ruta y líneas literales o comando con salida literal), y dudas con pregunta cerrada.
5. Su retorno es hipótesis: el orquestador verifica al menos una evidencia por motor y patrón con comando propio antes de escribirla en la matriz; lo no verificado entra como duda.
6. Sin anidamiento.
7. Fallo: un reintento con el mismo contrato; al segundo, el orquestador hace ese motor en serie o la fila queda como duda.
8. Registro: la sección de log de cada ola lleva `Subagentes:` (rol, modelo, motor, qué devolvió, cómo se verificó) y la cuenta acumulada de Opus.

### Regla de detención (lista medible)

1. `git stash list` no vacío en `slep_idps`, o `git status --porcelain` antes del primer commit con alguna ruta fuera de {este encargo, ` M` del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md`, el LOG} → detén la **sesión** y pasa a FASE L.
2. `slep_idps`: `HEAD` distinto de `origin/main` tras el `fetch` → detén la sesión.
3. Cualquier cambio de md5 en un archivo de un hermano durante el encargo → detén la sesión y regístralo (este encargo no escribe allí).
4. `slep_categoria_desempeno` no existe en la ruta, o no se encuentra su plantilla → su columna queda como "no medido" con la razón; los otros dos siguen.
5. Alcanzar el total de 9 Opus → la ola en curso termina en serie con el orquestador o queda como duda.
6. **Residual:** cualquier estado, conteo o resultado no enumerado → congela ESTA tarea, regístrala como duda y sigue.

### Autorizaciones (lista cerrada)

- En `slep_idps`, FASE 0: `git add` y `git commit` de este encargo **y** del registro `50_documentacion/andamios/logs/20260924_registro_asistente_s33.md` (fila 9 agregada por el redactor), en un solo commit (`chore(encargo): s33n y registro del asistente s33`).
- En `slep_idps`: `git commit` de la matriz tras T2.
- `git push origin main` de `slep_idps` **una vez**, tras el commit `docs(log)`, solo si FASE R no terminó en `BLOQUEADO`, el porcelain está vacío y `HEAD..origin/main` = 0.
- Archivos temporales en `/tmp/s33n_*`.
- Implícitas del patrón: `fix(auditoria): R-NN …` y `docs(log): …`.

Nada más. **Ninguna escritura en `slep_simce_adecuado` ni en `slep_categoria_desempeno`.**

## 1. Estado de partida (premisas marcadas)

- `slep_idps`: `HEAD` = `origin/main` = `d41e31a`, el `docs(log)` de s33m (fuente: `.git/refs` leídos por el redactor el 2026-09-25); motor y `docs/` = `7ad76f36…` (fuente: `md5sum` del redactor). El registro del asistente s33 tiene 9 filas; la 9 la agregó el redactor sin commitear (fuente: `grep -c`).
- `slep_simce_adecuado` tiene hoy una sesión abierta (`sesion_abierta: true`) y su trabajo va en `4c5cc3a` o posterior (fuente: la fotografía de apertura del hermano pegada por el titular en esta sesión; se re-lee en FASE 0 sin escribir). Su modal es `AddEntityModal`, uno solo para panorama y comparador; su encabezado trae un botón de cierre `icon-btn` sin `aria-label`; sus filas de SLEP muestran "traspaso AAAA"; su pestaña Nacional no tiene buscador (fuente: log s33c, M4).
- `slep_categoria_desempeno`: ruta, plantilla y estado son hipótesis (se miden en FASE 0).

## 2. Contexto mínimo

`slep_idps` pasó en las sesiones 29 a 33 por una revisión minuciosa de usabilidad, accesibilidad y fidelidad de datos. El titular quiere llevar lo relevante a los dos motores hermanos y que los tres se vean más estandarizados, **sin forzar lo idiosincrático de cada proyecto**. Este encargo solo mide dónde está cada hermano respecto de cada patrón.

## 3. Invariantes 🔒 (cada uno con su comando)

1. **Hermanos intactos:** md5 de plantilla, motor y `docs/index.html` de cada hermano iguales en FASE 0 y en FASE L; `git -C <hermano> status --porcelain` igual en FASE 0 y en FASE L.
2. **`slep_idps` solo gana documentos:** `git diff --name-only <inicio>..HEAD` ⊆ {la matriz, el LOG}.
3. **Toda celda con evidencia:** en la matriz, 0 celdas de estado sin su columna de evidencia llena (conteo por script).

## 4. Grafo de tareas y ALCANCE

- **T1** (inventario por motor, olas 1 y 2) · ALCANCE: ninguno (solo `/tmp`).
- **T2** (matriz) · ALCANCE: `50_documentacion/andamios/20260924_matriz_patrones_motores.md` (en `slep_idps`). Requiere T1.
- **FASE R** y **FASE L** quedan fuera del grafo y corren siempre.

## 5. FASE 0: apertura del log y mediciones

| # | Medición | esperado | Si difiere |
|---|---|---|---|
| M1 | `slep_idps`: porcelain tras el primer commit; stash; `fetch`; `HEAD~1` = `origin/main` | solo el LOG; vacío; sí | reglas 1 y 2 |
| M2 | Por hermano: existe la raíz; `git rev-parse --short HEAD`; `git status --porcelain`; ruta de la plantilla del motor (en `slep_categoria_desempeno`, localizarla por `*_motor_template.html` o por el script que genera `docs/index.html`); md5 de plantilla, motor y `docs/` | registrado | regla 4 |
| M3 | Calibración del inventario: los subagentes de la ola 1 aplican el inventario primero a `slep_idps` como **caso bueno** (todo debe salir "presente"); una copia de la plantilla de `slep_idps` en `/tmp` sin `focoRespaldo` ni `nEE` como **caso malo** (esas filas deben salir "ausente") | se distinguen | corregir el inventario antes de aplicarlo a los hermanos |

## 6. Inventario de patrones (el mismo para los tres motores)

Cada fila: nombre, qué problema resuelve, cómo se mide (grep o Puppeteer), sesión de origen en `slep_idps`.

1. Todo conteo visible con plural concordante (`nEE`/`nCom` o equivalente) (s32).
2. Modal de entidades: filas operables con Tab, Enter y Espacio (s32).
3. Modal: el foco queda retenido en ciclo y vuelve al botón de origen al cerrar (s32e).
4. Modal: destino de respaldo del foco si el origen desaparece (s33).
5. Modal: botón ✕ de cierre con `aria-label` (s33c).
6. Modal: pestaña Nacional sin buscador (s33c).
7. Modal: con el tope alcanzado, se puede quitar una entidad desde el modal (s33c).
8. Modal: las filas caben en la lista (sin scroll horizontal; el texto secundario cede ancho) (s33i).
9. Cada cifra nombra su universo (directorio frente a roster del nivel y año) (s33c).
10. El estado frente al GSE se lee de la fuente de la Agencia y, donde es nulo, se dice "sin comparación válida" sin afirmar un estado (s31, s32f).
11. Contraste: tokens de texto `-txt` sobre fondos claros; ningún texto de estado bajo 4,5:1; hover de acciones destructivas con token de texto (s29c a s33d).
12. Anillo de foco visible (`:focus-visible`) en todos los controles, con contraste ≥ 3:1 contra su fondo (s32, s33b).
13. Tabla del comparador con `min-width` y scroll dentro de su contenedor (s32d).
14. En pantallas angostas (320 a 425 px), ninguna pantalla desplaza la página hacia el lado (s33d, s33f, s33g).
15. Exportación CSV con la regla de fidelidad (los mismos arreglos que la pantalla) y columnas código + etiqueta (s30, s33e).
16. Nombre del archivo exportado con todos los acotes que cambian el universo (s30, s33f).
17. Año preliminar marcado en todas las superficies que muestran el año (s32c, s33d).
18. Mayúsculas sostenidas solo en siglas (s29i).
19. Hash del payload con fecha normalizada (convención §8.2) como invariante de build (s29).
20. Motor sin dependencias de red al abrir (el hermano ya lo tiene desde su s31).

Estados: **presente**, **ausente**, **divergente** (existe pero resuelve distinto; describir cómo), **no aplica** (el hermano no tiene el problema que el patrón resuelve; razonarlo).

## 7. T1: inventario por motor (olas 1 y 2)

1. Ola 1: un subagente Opus por motor aplica §6 y devuelve según el contrato. El orquestador verifica al menos una evidencia por motor y patrón.
2. Ola 2: por cada celda "ausente" o "divergente" de un hermano, otro subagente Opus (distinto del de la ola 1 de ese motor) intenta refutarla con su propio comando. Si refuta, la celda pasa a la ola 3 o a duda.
3. Verificación: M3 superado antes de la ola 1; cuenta de Opus en el log por ola.

## 8. T2: matriz

1. Documento con: tabla patrón × motor (estado y evidencia por celda); para cada hermano, la lista de huecos agrupados por tema (modal y foco; textos y cifras; contraste y ancho; exportación; build), con la columna "¿aplica? — razón"; una sección "Lo idiosincrático de cada motor" (diferencias que **no** deben uniformarse, con su razón); y una sección "Patrones que van en sentido contrario" (lo que un hermano hace mejor y `slep_idps` debería adoptar).
2. Verificación: 🔒3 por script; cada celda "ausente" o "divergente" con su resultado de la ola 2.
3. Commit `docs(matriz): patrones de usabilidad entre los tres motores (s33n T2)`.

## 9. FASE R: auditoría propia y reparación (penúltima, obligatoria)

La reparación cambia el trabajo, nunca el criterio, la tolerancia, el valor esperado ni la meta. Pasos, en orden:

1. **Inventario** de afirmaciones auditables (una muestra de 12 celdas, al menos 4 por hermano, más los 🔒). Numera `R-01`, … y anéxalo **antes** de auditar.
2. **Re-derivación independiente:** las 12 celdas con un comando distinto del de las olas, hecho por el orquestador.
3. **Invariantes 🔒:** el comando de cada uno, PASA/FALLA con salida literal.
4. **Alcance global:** `git diff --name-only <inicio>..HEAD` en `slep_idps`; 🔒1 en los hermanos.
5. **Regresión:** PRUEBAS.
6. **Control positivo:** M3 repetido.
7. **Veredicto por hallazgo:** **BLOQUEA** / **REPARA** / **ADVIERTE**. "0 hallazgos" solo junto al control positivo.
8. **Ciclo de reparación (máximo 2)**, solo sobre la matriz, con commit `fix(auditoria): R-NN …`.
9. **Prohibido:** escribir en un hermano; cambiar un estado sin evidencia; convertir "no aplica" en "ausente" para uniformar.
10. **Salida:** tabla `id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación` y veredicto.

## 10. FASE L: cierre del log (última, obligatoria, corre siempre)

1. `git status --porcelain` de `slep_idps` → solo el LOG; 🔒1 en los hermanos. Ningún shell en segundo plano sigue corriendo.
2. Secciones de cierre: resumen; commits; subagentes (cuántos, modelo, cuenta de Opus); auditoría; invariantes; conteo de celdas por estado y motor; dudas con pregunta cerrada; errores propios; estado de cierre.
3. Bloque J: trece campos, una línea cada uno, copiados del detalle; el campo de ejecución con la cuenta real de subagentes.
4. Privacidad: grep de RUT con script (`/tmp/s33n_priv.sh`) → vacío, con control plantado; ningún RBD con número ni nombre de establecimiento.
5. Verificación del archivo: `ls -l <LOG> && wc -l <LOG>`; `grep -c '^### FASE'`; `grep -c '^esperado:'` = `grep -c '^obtenido:'`; `grep -c '^## J'` = 1.
6. `git add <LOG>` y `git commit -m "docs(log): s33n matriz de motores hermanos"`; luego el push según la autorización.
7. Estado de cierre en el reporte.

## 11. Reporte final

- **Primera línea:** salida literal de `ls -l <LOG> && wc -l <LOG>` y hash del commit `docs(log)`.
- **Segundo bloque:** el bloque J copiado tal cual.
- Después: la tabla patrón × motor resumida (solo estados); los huecos de cada hermano por tema; lo idiosincrático; lo que `slep_idps` debería adoptar de los hermanos; "lo que falló o sorprendió; si nada, decirlo".
