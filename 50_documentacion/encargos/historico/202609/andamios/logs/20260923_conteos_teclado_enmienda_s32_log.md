# Log de sesión: conteos con plural, teclado del modal y enmienda §3.5 (s32)

- **Meta:** que ninguna pantalla ni tooltip diga "1 comunas" o "1 establecimientos" (T1); que las filas de `EntityModal` se operen con Tab y Enter/Espacio en sus dos usos (T2); enmendar la decisión §3.5 para distinguir el piso de la rampa continua del mínimo sobre puntajes enteros (T3); regenerar el motor sin que cambie una cifra (T4).
- **Fecha:** 2026-09-23
- **Repo y rama:** `/Users/tomgc/Projects/slep_idps`, `main` (estación `MacBook-Pro-de-Tomas.local`)
- **HEAD al empezar (`<inicio>`):** `6117393`. PUNTO DE RETORNO medido en solo lectura antes de crear este log: `git status --porcelain` = `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_conteos_teclado_enmienda_s32.md` (única ruta: el propio encargo); `git stash list` vacío; `git rev-parse --short HEAD` = `6117393`.
- **Gate del titular (M1, regla 1):** el porcelain no está vacío solo por el encargo mismo. Se preguntó una vez; el titular eligió **"Continuar; el encargo va con docs(log)"** (patrón s29i/s30/s31b). El encargo se agrega en el commit `docs(log)` de FASE L; no hay T0.
- **ENTORNO:** Claude Code sobre el filesystem local del titular (macOS, Darwin 27.0.0); R 4.5.2 con `renv` del proyecto; `bash -c` explícito para shell, `Rscript` para R, `node` para Puppeteer 25.9.0 (`NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules`, Chrome del sistema, motor por `file://`).
- **EJECUCIÓN declarada:** esfuerzo `xhigh`; orquestador el modelo de la sesión; subagentes 0; total Opus del encargo 0. **Modo real de la sesión:** Opus 5.5 (1M), efecto de sesión `ultracode` activado por el titular; **el encargo manda: 0 subagentes, 0 workflows**, ejecución en solo y en serie.
- **Encargo:** `50_documentacion/activa/encargos/encargo_claude_code_idps_conteos_teclado_enmienda_s32.md`.
- **Grafo de tareas (copiado de §4 del encargo):**

```
T1 (conteos con plural)   ALCANCE: 30_procesamiento/35_motor_template.html
T2 (teclado del modal)    ALCANCE: 30_procesamiento/35_motor_template.html; independiente de T1 en lógica, corre después de T1 (mismo archivo)
T3 (enmienda §3.5)        ALCANCE: 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md; independiente
T4 (build del motor)      ALCANCE: 40_salidas/motor_idps.html; requiere T1 o T2 completada
FASE R y FASE L           fuera del grafo, corren siempre
Orden: FASE 0 → T1 → T2 → T3 → T4 → FASE R → FASE L
```

- **Plan de concurrencia:** sin subagentes (por contrato).
- **Topes de esfuerzo:** 3 intentos por bug; 2 ciclos de reparación en FASE R; 1 reintento por comando con falla transitoria.
- **Instrumentos:** los scripts de medición viven en `/tmp/s32_*` (autorización del encargo); los scratchpads de s30b/s31c ya no existen, así que los instrumentos se reescriben en esta sesión.

## J. Juicio (lo rellena FASE L)

- Meta y resultado: ninguna pantalla ni tooltip dice "1 comunas" o "1 establecimientos" (7 plurales fijos, no 3, más 2 ternarios, todos por `nEE`/`nCom`); las filas de `EntityModal` se operan con Tab y Enter/Espacio en los dos modales; §3.5 enmendada con 4,58:1 y 4,78:1 re-medidos; motor regenerado con el payload intacto (§8.2) → cumplida.
- Estado por tarea: FASE 0 completada (2 gates del titular) · T1 completada (`b0262ca`) · T2 completada (`45b3db0`) · T3 completada (`62514a9`) · T4 completada (`4a22cbc`) · FASE R completada (sin reparaciones) · FASE L completada.
- Commits: 5, rango `b0262ca`..`<docs(log)>` (`git log --oneline 6117393..HEAD`), de los cuales 0 fix(auditoria), 1 build(motor) y 0 deploy(docs).
- Auditoría (FASE R): APROBADO CON ADVERTENCIAS; hallazgos B/R/A = 0/0/5; reparados 0; abiertos 0 que toquen la meta (A-1 🔒2 literal inejecutable por la fecha del payload; A-2 premisa de M7, 7 y no 3; A-3 el modal no retiene el foco; A-4 una parada de Tab por fila; O-1 `Claude outputs/` del titular).
- Invariantes: 6/6 PASA (🔒2 con la convención §8.2 elegida por el titular en el gate H-0; 🔒3b re-medido por script tras un fallo de instrumento que detectó su propio control positivo); FALLA: ninguno.
- Cifras críticas: intactas (evidencia: JSON del payload igual al de FASE 0 salvo los offsets 38–39 de `fecha_generacion`; SHA-256 §8.2 `900913c1…78b4` en node y en R+`shasum`; md5 del `:root` `9842151d…` antes y después; 61 datos versionados; el build de FASE R reproduce `1069b9c9…` byte a byte).
- Decisiones autónomas de mayor riesgo: (1) D-A2: en el modal múltiple la fila misma es el control (`role="checkbox"`; Enter y Espacio conmutan) y no un checkbox nativo como en el hermano; reversible. (2) D-A1: los dos ternarios que ya concordaban (chip del comparador, banner) pasan a `nCom`/`nEE`; texto idéntico medido en los dos motores. (3) D-A3: la autorrepetición de la tecla no conmuta. (4) D-A4: T4 siguió con tres no versionados conocidos en el árbol.
- Desviaciones respecto del encargo: 🔒2 y PRUEBAS c medidos con la convención §8.2 (gate H-0) en vez del SHA crudo del `<script>`; M7 dio 7 líneas y las 4 extra entraron a T1 por la columna "Si difiere"; el encargo sin versionar de FASE 0 se resolvió por gate (va con `docs(log)`); push no ejecutado (condición de porcelain vacío no cumplida por O-1).
- Dudas abiertas: 4 (D-1 ¿§8.2 como redacción estándar del 🔒 del payload? sí/no · D-2 ¿encargo para que el modal retenga el foco? sí/no · D-3 ¿una parada de Tab por fila o foco itinerante? mantener/cambiar · D-4 ¿`Claude outputs/…registro_asistente_s32.md` se mueve a `andamios/logs/` o se descarta? mover/descartar, bloquea el push).
- Errores propios: 6 registrados, todos de instrumento, de pre-registro o de redacción del log (dos corridas antes de su `esperado:`; esperado de la línea base sin la fecha del payload; `grep` de R-24 sin acotar; `{3,6}` partido por el bash 3.2 en L3b/C2; aviso cosmético de `prettyNum`; el RUT inventado del control de privacidad copiado en el log, corregido antes del commit); ninguno costó más de un turno ni tocó un esperado.
- Qué debe verificar el revisor por sí mismo: el gate visual (Tab en el modal de territorio hasta una fila y Enter; tab SLEP del comparador con "SLEP Santiago Centro · 1 comuna · 39 establecimientos" y Espacio/Enter); el contorno de foco de 2 px en `--foco`; esta sesión midió foco, roles, conteos y textos, no gusto.
- No publicado / queda al usuario: el despliegue a `docs/` (tras el gate visual; testigo `check-row:focus-visible`) y el `git push origin main` de los 5 commits, retenido porque `Claude outputs/` deja el porcelain no vacío (D-4).
- Ejecución: modo de sesión ultracode ejecutado como xhigh en solo por contrato; subagentes 0, por contrato.

## Registro por fase

### FASE 0: apertura del log y mediciones

- **Estado:** en curso.
- **Commits:** ninguno (no hay T0; el encargo va con `docs(log)` por decisión del gate).

**M1** (medido en solo lectura antes de crear el log):
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps stash list'
```
esperado: vacío; vacío.
obtenido: `?? 50_documentacion/activa/encargos/encargo_claude_code_idps_conteos_teclado_enmienda_s32.md` (única ruta); stash vacío. **Regla 1 dispara al pie de la letra**; gate del titular: "Continuar; el encargo va con docs(log)". Se sigue.

**M2:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps fetch --quiet; git -C /Users/tomgc/Projects/slep_idps rev-parse --short HEAD; git -C /Users/tomgc/Projects/slep_idps rev-list --count HEAD..origin/main; git -C /Users/tomgc/Projects/slep_idps rev-list --count origin/main..HEAD'
```
esperado: `6117393`; `0`; `0`.
obtenido: `rc_fetch=0`; `6117393`; `0`; `0` (`origin/main` = `6117393`). Regla 2 no dispara.

**M3** (esperado tomado de la tabla del encargo, escrita antes de correr):
```
bash -c 'md5 -q /Users/tomgc/Projects/slep_idps/docs/index.html; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html'
```
esperado: ambos `6c5feab5428ed05dff09867f2b47bba3`.
obtenido: `6c5feab5428ed05dff09867f2b47bba3`; `6c5feab5428ed05dff09867f2b47bba3` (5.463.985 bytes cada uno).

**M4** (`/tmp/s32_payload_sha.sh`: `perl -0777` extrae el contenido del `<script>` que empieza con `window.__t0` —el que hace `atob("…")` + `pako.inflate`— y lo hashea con `shasum -a 256`; control positivo: una copia con un byte del base64 cambiado debe dar otro hash):
```
bash -c 'cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s32_motor_antes.html; bash /tmp/s32_payload_sha.sh /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /Users/tomgc/Projects/slep_idps/docs/index.html /tmp/s32_motor_antes.html; perl -pe '"'"'s/atob\("(.)/atob("X/'"'"' /tmp/s32_motor_antes.html > /tmp/s32_motor_plantado_payload.html; bash /tmp/s32_payload_sha.sh /tmp/s32_motor_plantado_payload.html'
```
esperado: un hash de 64 hex, igual en el motor, en `docs/index.html` y en la copia; la copia plantada da un hash **distinto**.
obtenido: motor, `docs/index.html` y `/tmp/s32_motor_antes.html`: `4408424 bytes; atob:1; sha256 a2f21bb14fe0115f646503c73ff0896a8aecf5efdac17440c323aa192b77504e` (los tres iguales); copia plantada (`/tmp/s32_motor_plantado_payload.html`, difiere en el char 897054): `sha256 ff7c6bef9c85bab3a79f769e9abefdf2fc012105bf3260d58a5c19db76a95554` → **distinto (el instrumento dispara)**. Valor del 🔒2: `a2f21bb1…77504e`. `/tmp/s32_motor_antes.html` queda como "motor anterior" para M8, M10, T1.5 y T2.5.

**M5** (`/tmp/s32_root_md5.sh`: `awk` desde la línea `:root{` hasta la primera línea que termina en `}`; una corrida de prueba del instrumento se hizo antes de esta fila, con el mismo resultado):
```
bash -c 'bash /tmp/s32_root_md5.sh /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; cp /tmp/s32_root_block.txt /tmp/s32_root_block_fase0.txt'
```
esperado: un md5 (bloque de ~60 líneas que cierra con `--border-2:var(--linea); --ink:var(--tinta);` + `}`).
obtenido: `lineas: 63; md5 9842151d897e8768abd2207513c6607b` (copia en `/tmp/s32_root_block_fase0.txt`). Valor del 🔒3a.

**M6** (esperado de la tabla del encargo):
```
bash -c 'grep -nE "const (fmt|nEE|SLEPS_OPTS|NACIONAL_OPT)=" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: `fmt` < `SLEPS_OPTS` < `NACIONAL_OPT` < `nEE`; las dos son IIFE.
obtenido: `824: const fmt=…`; `1742: const SLEPS_OPTS=(()=>{…`; `1751: const NACIONAL_OPT=(()=>{…`; `2613: const nEE=n=>fmt(n)+(n===1?" establecimiento":" establecimientos");`. Orden `fmt` (824) < `SLEPS_OPTS` (1742) < `NACIONAL_OPT` (1751) < `nEE` (2613). Forma leída (`sed -n 1738,1785p`): las dos son IIFE `(()=>{…})()` a nivel superior del script Babel, evaluadas al cargar; usar `nEE` en `NACIONAL_OPT` sin moverlo dispararía TDZ. Coincide: la mecánica de T1 es la del encargo (ayudantes junto a `fmt`).

**M7** (esperado de la tabla del encargo):
```
bash -c 'grep -nE "\+ ?\" (comunas|establecimientos)\b" /Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html'
```
esperado: exactamente 3 líneas (L1754, L1771, L2957 aprox.).
obtenido: **7 líneas, no 3**: L1096 (`aria-label` de `StackedBar`: `"Distribución de "+rep.N+" establecimientos con comparación publicada: "…`), L1111 (`title` de `.s100`: `"100% = "+rep.N+" establecimientos con comparación publicada"`), L1690 y L1776 (`sub` del tab Región en `buildList` y en `_listaCmpEnt`: `(COMUNAS_POR_REGION[r.cod]||0)+" comunas"`), L1754 (`NACIONAL_OPT.sub`), L1771 (`sub` del tab SLEP del comparador) y L2957 (`title` de exportación del panorama). **Por la columna "Si difiere" de M7, las cuatro líneas extra entran a T1** (mismo patrón, mismo alcance). Censo propio más amplio (`grep -nE "(comunas|establecimientos)"` sobre el JSX): L1852 (meta del chip del comparador) y L2922 (banner) ya concuerdan con un ternario a mano; L1087 (`sin+" con puntaje sin comparación publicada"`) no lleva sustantivo contado. Ninguna otra forma de conteo con plural fijo.

Instrumento de navegador para M8–M10 y T1/T2: `/tmp/s32_verif.js` (Puppeteer 25.9.0 por `NODE_PATH`, Chrome del sistema, `file://`, viewport 1280×900; acciones `consola`, `m9`, `slep`, `titulo`, `tecl_terr`, `tecl_cmp`, `tope`, `escape`; expresión de M8 `(^|\D)1 (comunas|establecimientos)\b`, aplicada a los `.check-region` y, como censo de documento, a `innerText` y a los atributos `title`/`aria-label`/`placeholder` de todo elemento). Se corre sobre `/tmp/s32_motor_antes.html` (copia byte a byte del motor de FASE 0).

**M8, M9 y M10** (una corrida):
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32_verif.js /tmp/s32_motor_antes.html slep,m9,tecl_terr > /tmp/s32_fase0_nav.json'
```
esperado: M8: ≥ 1 coincidencia en los `.check-region` del tab SLEP, y la fila de SLEP Santiago Centro dice "1 comunas · 39 establecimientos" (cifra de s31c); M9: al menos una comuna con exactamente 1 establecimiento en 4° básico y el último año del nivel; M10: `document.activeElement` nunca llega a un `.check-row` en 40 Tab (0 de 40).
obtenido: `rc=0`; consola 0 errores, 0 `pageerror`. **M8:** 36 filas en el tab SLEP; `malos_slep: 1` → `SLEP Santiago Centro | 1 comunas · 39 establecimientos` (única fila con un 1); tab Nacional: `Chile | Nivel nacional · 346 comunas · 9.136 establecimientos`; tab Región: 16 filas, 0 malas (muestra `7 comunas`, `9 comunas`, `9 comunas`). La hipótesis se confirma: caso malo = SLEP Santiago Centro. **M9:** nivel `4b`, año `2025`, 343 comunas con EE en el panorama; 12 comunas con exactamente 1 EE; la que usa T1.3 es la de código **`2202`** (las otras: `5104`, `11102`, `11301`, `11302`, `11303`, `12102`, `12104`, `12201`, `12302`, `12303`, `15202`). **M10:** foco inicial en `input-search` (el `autoFocus` del modal); 40 Tab sin llegar nunca a un `.check-row` (`llego: false`); tras 40 Tab el foco quedó en una `div.card.foco` **detrás** del modal (el modal no atrapa el foco; observación, fuera del ALCANCE de T2: se registra como pendiente). Coincide con el esperado: T2 conserva su objetivo.

**M11** (lectura; sin valor esperado):
```
bash -c 'ls -l /Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html; grep -nE "check-row|tabIndex|onKeyDown|role=" /Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html; sed -n 3940,4180p /Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html'
```
esperado: se registra lo que haya (lectura).
obtenido: el archivo existe (201.074 bytes). En todo el archivo **no hay `tabIndex`, `onKeyDown` ni `role=` en las filas del modal** (el `grep` solo devuelve `check-row`). Las filas son de dos clases:
- Selección simple (resultados de búsqueda de Establecimiento y Comuna): `<label key={e.rbd} className="check-row" style={{ cursor: "pointer" }} onClick={() => { setSelectedEstab(e); setEstabSearch(e.nom); }}>` (L3979-3981) y `<label key={c.cod_com} className="check-row" style={{ cursor: "pointer" }} onClick={() => { setComunaCod(c.cod_com); setSearch(c.nombre); }}>` (L4064-4065): **sin control nativo, sin `tabIndex`, sin teclado**. El hermano no resuelve el teclado de estas filas.
- Selección múltiple (Región, SLEP, Grupo): `<label key={r.cod_reg} className={"check-row" + (checked ? " is-selected" : "") + (bloqueado ? " is-disabled" : "")} …>` + `<input type={editing ? "radio" : "checkbox"} name="region" value={r.cod_reg} checked={checked} disabled={bloqueado} onChange={() => toggleSel(r.cod_reg, selectedRegions, setSelectedRegions)} />` (L4024-4030; igual en SLEP, L4109-4115, y Grupo, L4167-4172): el teclado lo da el **control nativo** (Tab llega al `input`, Espacio conmuta, `disabled` lo saca del orden de tabulación). CSS: `.check-row input[type="checkbox"] { accent-color: var(--ocean); }` (L902); ninguna regla `:focus-visible` propia.
Lectura para T2: el hermano resuelve el teclado solo donde hay un control nativo (selección múltiple) y **no** lo resuelve en la selección simple, que es el caso que motivó T2 (modal de territorio). `EntityModal` dibuja una sola clase de fila para los dos modos, así que T2 aplica la mecánica del encargo (`tabIndex`/`role`/`onKeyDown`) en ambos y cita estas líneas en el comentario. Es la divergencia 13 del log s29 §36.7 (L1639: "a11y: filas `div[role=checkbox]` sin foco de teclado vs controles nativos").

**M12, M13 y M14** (esperados de la tabla del encargo):
```
bash -c 'grep -c "check-row:focus-visible" /Users/tomgc/Projects/slep_idps/docs/index.html; grep -n "el mínimo es 4,78:1" /Users/tomgc/Projects/slep_idps/50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md; git -C /Users/tomgc/Projects/slep_idps ls-files | grep -cE "\.(csv|xlsx|parquet|rds)$"'
```
esperado: M12 `0`; M13 una línea de §3 punto 5 que contiene "el mínimo es 4,78:1"; M14 un número (valor del 🔒6).
obtenido: M12 `0` (el testigo del próximo despliegue queda `check-row:focus-visible`); M13 `34:5. **Color del número.** … En toda la rampa posible, el mínimo es 4,78:1 (Autoestima, en los tonos más oscuros de su rango; fuente: cálculo sobre la rampa, controles 21,00 y 4,48). …`; M14 `61` (valor del 🔒6).

Línea base de PRUEBAS a (propia, antes de tocar la plantilla; el build reescribe `40_salidas/motor_idps.html`):
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32_run35_fase0.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32_run35_fase0.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; git -C /Users/tomgc/Projects/slep_idps status --porcelain'
```
esperado: (propio) `rc=0`; 0 líneas con "warn"; md5 `6c5feab5428ed05dff09867f2b47bba3` (plantilla sin cambios → motor byte a byte igual); porcelain solo con el encargo y este log.
obtenido: `rc=0`; `0` líneas con "warn"; md5 **`f8496577f6fb421786409a5afa3c1e8e`** (≠ `6c5feab5…`); porcelain: ` M 40_salidas/motor_idps.html` + encargo + log. **El esperado propio no se cumple.** Diagnóstico inmediato (mismo `run`, sin tocar nada):
```
bash -c 'bash /tmp/s32_payload_sha.sh /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; node /tmp/s32_json_payload.js /tmp/s32_motor_antes.html /tmp/s32_json_antes.json; node /tmp/s32_json_payload.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s32_json_fase0build.json; cmp -l /tmp/s32_json_antes.json /tmp/s32_json_fase0build.json'
```
obtenido: SHA-256 del `<script>` del payload del motor regenerado `757a9a2110487dc4cdda295d3746ae17dbeadcae9a4b7d1ecef71b618feea7c6` (≠ M4 `a2f21bb1…`; mismo largo, 4.408.424 bytes). Descomprimido (zlib `789c`), el JSON mide 59.467.009 bytes en los dos y `cmp -l` da **2 bytes distintos, offsets 38 y 39** (`17` → `23`): `"fecha_generacion":"2026-09-17"` → `"2026-09-23"` (`35_generar_motor_html.R:516`, `fecha_generacion = format(Sys.Date())`). Ninguna cifra cambia; el cambio de dos dígitos altera todo el flujo comprimido que le sigue (y por eso el base64).

**Hallazgo de FASE 0 (H-0):** el 🔒2 y la PRUEBA c, tal como están escritos (SHA-256 del contenido crudo del `<script>`), **no se pueden cumplir con ningún build hecho un día distinto del 2026-09-17**, aunque la plantilla no cambie: el payload lleva la fecha de generación. Es el mismo patrón que el error 2 del log s29 §11 (regla de detención no ejecutable con lo que el encargo entrega); la convención escrita del proyecto para esto es la de s29 §8.2 (JSON descomprimido con `"fecha_generacion":"0000-00-00"`, UTF-8, sin salto final, más el `cmp -l` de offsets como verificación fuerte). Aplicada al pie de la letra, la regla 3 congelaría T1, T2 y T4 en su primer build. Se lleva al titular como gate (decisión de criterio, no del ejecutor).

**Gate del titular (H-0):** eligió **"Convención §8.2 de s29"**. Desde aquí el 🔒2 y la PRUEBA c se miden con `/tmp/s32_payload_norm.js` (JSON descomprimido, `"fecha_generacion":"0000-00-00"`, SHA-256 UTF-8 sin salto final) **más** el `cmp` de offsets contra el JSON de FASE 0 (únicos distintos admitidos: 38–39, la fecha); el SHA crudo de `/tmp/s32_payload_sha.sh` se sigue registrando como evidencia. Queda como error de redacción del encargo (lo consolida FASE L).

**M4′ (valor del 🔒2 con la convención §8.2):**
```
bash -c 'node /tmp/s32_payload_norm.js /tmp/s32_motor_antes.html; node /tmp/s32_payload_norm.js /Users/tomgc/Projects/slep_idps/docs/index.html /tmp/s32_motor_antes.html; node /tmp/s32_payload_norm.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s32_motor_antes.html; node /tmp/s32_plantar_payload.js /tmp/s32_motor_antes.html /tmp/s32_motor_plantado_json.html; node /tmp/s32_payload_norm.js /tmp/s32_motor_plantado_json.html /tmp/s32_motor_antes.html'
```
esperado: (propio) un SHA de 64 hex idéntico en el motor de FASE 0, en `docs/index.html` y en el build de línea base de hoy; `docs/` contra FASE 0 sin offsets distintos; build de hoy contra FASE 0: solo offsets 38 y 39; control plantado (`region_foco` "5"→"6", fuera de la fecha): SHA distinto y un offset fuera de 38–39.
obtenido: FASE 0 (`/tmp/s32_motor_antes.html`): `59467009` bytes, fecha `2026-09-17`, **`sha256_norm 900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`**; `docs/index.html`: mismo SHA, `offsets_distintos: []`; build de línea base de hoy: mismo SHA, `offsets_distintos: [38,39]` (`"2026-09-23"` ↔ `"2026-09-17"`); plantado: `7ab3ce81…f68d`, `offsets_distintos: [82]` (`region_foco` 6 ↔ 5) → **el instrumento dispara**. Valor del 🔒2 (§8.2): `900913c1…78b4`.

- **Estado de FASE 0:** completada, con dos gates del titular (M1 y H-0). Ninguna tarea congelada por FASE 0: M6–M13 coinciden con su esperado salvo M7 (7 líneas en vez de 3: las cuatro extra entran a T1 por la columna "Si difiere").
- **Estado del árbol al cerrar FASE 0:** ` M 40_salidas/motor_idps.html` (build de línea base, fecha 2026-09-23; se reemplaza en T1 y se commitea en T4), `??` encargo y este log.
- **Subagentes:** sin subagentes.
- **Errores propios:** dos corridas de instrumento hechas antes de escribir su `esperado:` (M3 y la prueba del `awk` de M5); ambas se repitieron o se tomaron con el esperado de la tabla del encargo, escrito antes. Costo: ninguno.

### FASE T1: todo conteo visible pasa por un ayudante de plural

- **Paso 0:** leídos `fmt` (L824), `nEE` (L2611-2613, con su comentario s31b), `SLEPS_OPTS` (L1742-1744), `NACIONAL_OPT` (L1751-1754), `buildList` (L1686-1692), `_listaCmpEnt` (L1764-1777), `StackedBar` (L1080-1112), la meta del chip del comparador (L1848-1852), el banner (L2920-2924) y el `title` de exportación (L2952-2957).
- **Implementación:**
  - `nEE` y `nCom` se declaran junto a `fmt`/`fmtSigned` (tras L825), con el comentario "s32: todo conteo visible pasa por aquí (tres defectos de plural en tres sesiones)". La declaración de L2613 se elimina y deja un comentario que remite a la nueva ubicación (un solo `nEE`).
  - Las siete líneas de M7: L1096 `aria-label` → `"Distribución de "+nEE(rep.N)+" con comparación publicada: "…`; L1111 `title` → `"100% = "+nEE(rep.N)+" con comparación publicada"`; L1690 y L1776 → `sub:nCom(COMUNAS_POR_REGION[r.cod]||0)`; L1754 → `"Nivel nacional · "+nCom(coms.size)+" · "+nEE(ee)`; L1771 → `nCom(s.ncom)+" · "+nEE(s.ee)`; L2957 → `"Descarga en CSV "+(unidades.length===1?"el establecimiento":"los "+nEE(unidades.length))+" de esta vista, …"` (resto literal).
  - **Decisión autónoma D-A1:** los dos ternarios a mano que ya concordaban (L1852, meta del chip del comparador; L2922, banner) pasan a `nCom(q.ncom)+" · "+nEE(q.nee)` y `{nCom(panComunas)} · `. Texto visible idéntico; se hace para que el comentario del ayudante ("todo conteo visible pasa por aquí") sea cierto. Mismo ALCANCE; reversible.
- **Verificación:**

T1.1 estático:
```
bash -c 'T=/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html; grep -cE "\+ ?\" (comunas|establecimientos)\b" $T; grep -c "const nEE=" $T; grep -c "const nCom=" $T; grep -nE "const (fmt|nEE|nCom|SLEPS_OPTS|NACIONAL_OPT)=" $T | cut -c1-40; grep -cE "\?\" ?comunas?\"|\?\" ?establecimientos?\"" $T; git -C /Users/tomgc/Projects/slep_idps diff --stat -- $T'
```
esperado: `0`; `1`; `1`; orden `fmt` < `nEE` < `nCom` < `SLEPS_OPTS` < `NACIONAL_OPT`; los ternarios de plural fuera de los ayudantes: `0` (solo quedan los dos de `nEE`/`nCom`, que usan `?" establecimiento":…` y `?" comuna":…`: el patrón cuenta 2); diff de 1 archivo.
obtenido: `0`; `1`; `1`; `824 fmt` < `827 nEE` < `828 nCom` < `1745 SLEPS_OPTS` < `1754 NACIONAL_OPT`; ternarios de plural: `2`, y son exactamente L827 (`nEE`) y L828 (`nCom`) → fuera de los ayudantes, 0; `1 file changed, 15 insertions(+), 12 deletions(-)`.

Build temporal (PRUEBAS a; escribe `40_salidas/motor_idps.html`, que no se commitea en T1) y 🔒2:
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32_run35_t1.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32_run35_t1.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s32_motor_t1.html; bash /tmp/s32_payload_sha.sh /tmp/s32_motor_t1.html; node /tmp/s32_payload_norm.js /tmp/s32_motor_t1.html /tmp/s32_motor_antes.html'
```
esperado: `rc=0`; `0`; md5 distinto de `6c5feab5…` y de `f8496577…` (cambió la plantilla); SHA crudo `757a9a21…` (mismo día que la línea base: el payload no depende de la plantilla); §8.2 `900913c1…78b4` con `offsets_distintos: [38,39]`.
obtenido: `rc=0`; `0`; md5 `606bf24235d175704a789dd5b6e22903`; SHA crudo `757a9a2110487dc4…a7c6` (= línea base de hoy); §8.2 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`, `offsets_distintos: [38,39]` (solo la fecha). **🔒2 (§8.2) intacto; regla 3 no dispara.** Copia en `/tmp/s32_motor_t1.html`.

T1.2 (el caso que lo motivó), T1.3 (`title` de exportación), T1.4 (control positivo plantado) y T1.5 (caso bueno contra el motor anterior). La copia plantada de T1.4 sale del motor nuevo con un `perl` que cambia `sub:nCom(s.ncom)+" · "+nEE(s.ee)` por `sub:(s.ncom===1?"1 comunas":nCom(s.ncom))+" · "+nEE(s.ee)` (planta "1 comunas" en el `.check-region` de todo SLEP de una comuna):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_verif.js /tmp/s32_motor_t1.html consola,slep,titulo "{\"comCod\":\"2202\"}" > /tmp/s32_t1_nuevo.json; perl -pe '"'"'s/sub:nCom\(s\.ncom\)\+" · "\+nEE\(s\.ee\)/sub:(s.ncom===1?"1 comunas":nCom(s.ncom))+" · "+nEE(s.ee)/'"'"' /tmp/s32_motor_t1.html > /tmp/s32_motor_t1_plantado.html; cmp -s /tmp/s32_motor_t1.html /tmp/s32_motor_t1_plantado.html || echo plantado_distinto; node /tmp/s32_verif.js /tmp/s32_motor_t1_plantado.html slep > /tmp/s32_t1_plantado.json; node /tmp/s32_verif.js /tmp/s32_motor_antes.html slep,titulo "{\"comCod\":\"2202\"}" > /tmp/s32_t1_antes.json'
```
esperado: motor nuevo: 0 errores de consola y 0 `pageerror` tras abrir los dos modales; tab SLEP con 0 coincidencias de la expresión de M8 y la fila de SLEP Santiago Centro dice `1 comuna · 39 establecimientos`; tab Nacional `Nivel nacional · 346 comunas · 9.136 establecimientos`; tab Región 0 malas; con la comuna `2202` el `title` es `Descarga en CSV el establecimiento de esta vista, con su puntaje y su estado vs GSE en los cuatro indicadores` y el censo de documento (texto + `title`/`aria-label`/`placeholder`) da 0; con el SLEP foco el `title` dice `Descarga en CSV los N establecimientos de esta vista, …` (N ≥ 2) y el censo da 0. Copia plantada: ≥ 1 coincidencia en el tab SLEP. Motor anterior: tab SLEP ≥ 1 (M8) y, con la comuna `2202`, el censo de documento ≥ 1 (el `title` "los 1 establecimientos" y las barras "1 establecimientos").
obtenido (`/tmp/s32_t1_nuevo.json`, `/tmp/s32_t1_plantado.json`, `/tmp/s32_t1_antes.json`; `plantado_distinto`):
- Motor nuevo: `consola_errores: []`, `pageerror: []`, los dos modales abren (`modal_territorio: true`, `modal_comparador: true`). **T1.2:** tab SLEP 36 filas, `malos_slep: 0`; `SLEP Santiago Centro | 1 comuna · 39 establecimientos`; Nacional `Chile | Nivel nacional · 346 comunas · 9.136 establecimientos`; Región 16 filas, 0 malas; censo del modal `[]`. **T1.3:** comuna `2202` (`terr_es_comuna: true`): `Descarga en CSV el establecimiento de esta vista, con su puntaje y su estado vs GSE en los cuatro indicadores`, censo `[]`; SLEP foco: `Descarga en CSV los 60 establecimientos de esta vista, …`, censo `[]`.
- **T1.4** (copia plantada): `malos_slep: 1` → `1 comunas · 39 establecimientos`; consola sin errores. El censo dispara sobre el caso plantado.
- **T1.5** (motor anterior): tab SLEP `malos_slep: 1` (`SLEP Santiago Centro | 1 comunas · 39 establecimientos`); comuna `2202`: `title` `Descarga en CSV los 1 establecimientos de esta vista, …` (1 coincidencia). **Hallazgo de la calibración:** en el motor anterior el SLEP foco (vista de apertura) ya mostraba 8 coincidencias en los atributos de `StackedBar`: `title: 100% = 1 establecimientos con comparación publicada` y `aria-label: Distribución de 1 establecimientos con comparación publicada: …` (cuatro barras de GSE con N = 1). Son L1096/L1111, las dos líneas extra de M7; en el motor nuevo el censo del foco da `[]`. En la comuna `2202` el único EE no tiene comparación publicada, así que sus barras van por la rama vacía (`Sin establecimientos con comparación publicada; 1 con puntaje sin comparación publicada`), sin sustantivo contado.
- **Regresión (PRUEBAS a, b, c):** build `rc=0`, 0 warnings; Puppeteer 0 errores y 0 `pageerror` con los dos modales abiertos; payload §8.2 `900913c1…78b4` con offsets solo 38–39.
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only HEAD; git -C /Users/tomgc/Projects/slep_idps ls-files --others --exclude-standard'
```
esperado: `30_procesamiento/35_motor_template.html` (ALCANCE de T1) más tres rutas conocidas que **no** se commitean aquí: `40_salidas/motor_idps.html` (build temporal; va en T4), el encargo (gate M1, va con `docs(log)`) y este log.
obtenido: `30_procesamiento/35_motor_template.html`, `40_salidas/motor_idps.html`, el encargo, este log **y una ruta nueva no prevista:** `Claude outputs/20260923_registro_asistente_s32.md` (1.088 bytes, creada a las 15:38, durante FASE 0; no estaba en M1). La leí en solo lectura: es el registro de errores del asistente de análisis de la sesión 32 (su fila 1 es el error del encargo que motivó el gate M1). **No la produjo T1 ni este ejecutor**: es del titular (patrón conocido de `Claude outputs/`). No se toca, no se commitea, no se borra. Consecuencia prevista: si sigue en el árbol en FASE L, el porcelain no quedará vacío y la condición del push no se cumplirá. Se registra como observación O-1. La única ruta del ALCANCE de T1 es la plantilla, y es la única que se commitea.
- **Commit:** `b0262ca` fix(motor): conteos visibles por nEE/nCom (s32 T1). `git show --name-only HEAD` = `30_procesamiento/35_motor_template.html` (única ruta commiteada; el motor temporal queda sin agregar).
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T2: el modal de entidades se opera con teclado

- **Paso 0:** releído `EntityModal` (L1583-1653 tras T1): la fila es `div.check-row` con `role={multiple?"checkbox":undefined}`, `aria-checked` solo en múltiple, `onClick={()=>{if(dis)return; onSelect({...item,dep:depEfectiva});}}`, sin `tabIndex` ni `onKeyDown`; `Escape` cierra por un listener de `window` (L1595-1596). Releído lo citado del hermano en M11.
- **Implementación:** el hermano **no** resuelve el teclado de sus filas de selección simple (M11: L3979-3981, L4064-4065) y en las múltiples lo delega en un `<input type="checkbox">` nativo (L4024-4030, L4109-4115). Como `EntityModal` dibuja una sola clase de fila para los dos modos, se aplica la mecánica del encargo en ambos: una sola función `elegir` para clic y teclado (con la guarda `if(dis)return;`); `tabIndex={dis?-1:0}`; `role={multiple?"checkbox":"button"}`; `aria-checked` solo en múltiple (como antes); `aria-disabled={dis||undefined}`; `onKeyDown` que con `Enter` o `" "` hace `preventDefault()` y llama a `elegir`. CSS: `.check-row:focus-visible{outline:2px solid var(--foco);outline-offset:-2px;}` junto a las demás reglas de `.check-row` (token existente, sin color nuevo, sin comentario).
  - **Decisión autónoma D-A2 (diferencia con el hermano, divergencia 13 de s29 §36.7):** en selección múltiple el hermano usa un checkbox nativo (Tab llega al `input`, solo Espacio conmuta, `disabled` lo saca del orden); aquí la fila misma es el control (`role="checkbox"`, Enter **y** Espacio conmutan, `tabIndex=-1` la saca del orden). Se elige así para no reescribir la fila en dos variantes; reversible.
  - **Decisión autónoma D-A3:** `onKeyDown` ignora la autorrepetición (`e.repeat`: `preventDefault()` y nada más). Sin la guarda, mantener apretado Espacio en el modal múltiple conmutaría la fila en ráfaga y la dejaría en un estado arbitrario; un checkbox nativo conmuta una sola vez. Una pulsación simple se comporta exactamente como el clic.
- **Diff:** `+1` regla CSS (L216) y la fila de `EntityModal` (L1631-1646): comentario de 8 líneas con las líneas del hermano, `elegir`, `tabIndex`, `role`, `aria-disabled`, `onClick={elegir}`, `onKeyDown`.
- **Verificación:**

Build temporal (PRUEBAS a) y 🔒2:
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32_run35_t2.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32_run35_t2.log; md5 -q /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; cp /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html /tmp/s32_motor_t2.html; grep -c "check-row:focus-visible" /tmp/s32_motor_t2.html; node /tmp/s32_payload_norm.js /tmp/s32_motor_t2.html /tmp/s32_motor_antes.html'
```
esperado: `rc=0`; `0`; md5 distinto de `606bf242…` (T1); `1`; §8.2 `900913c1…78b4`, offsets `[38,39]`.
obtenido: `rc=0`; `0`; md5 `1069b9c94b79510f3c26ce77b5cac2f6`; `1`; §8.2 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`, `offsets_distintos: [38,39]`. 🔒2 intacto.

T2.1–T2.4 sobre el motor nuevo y T2.5 sobre el anterior (mismo script `tecl_terr`):
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_verif.js /tmp/s32_motor_t2.html consola,tecl_terr,tecl_cmp,tope,escape > /tmp/s32_t2_nuevo.json; node /tmp/s32_verif.js /tmp/s32_motor_antes.html tecl_terr > /tmp/s32_t2_antes.json'
```
esperado: motor nuevo, 0 errores de consola y 0 `pageerror`. **T2.1** (territorio, simple, tab inicial Comuna): desde el buscador (`autoFocus`), Tab llega a un `.check-row` en ≤ 40 (se espera 2: buscador → selector de dependencia → primera fila) con `role="button"`; Enter → el modal se cierra y el texto de `.terr-trigger` pasa de `SLEP Costa Central ▾` a `comuna de <la fila enfocada> ▾`. **T2.2** (comparador, múltiple, tab Comuna): Tab llega a una fila con `role="checkbox"`, `aria-checked="false"` y `.modal-count` `0 de 10`; Espacio → `aria-checked="true"`, `1 de 10`, el modal sigue abierto; Espacio otra vez → lo mismo que un segundo clic hoy (`addTerr` conmuta: `aria-checked="false"`, `0 de 10`); se registra tal cual. **T2.3** (tope): con 10 filas marcadas por clic, `.modal-count` `10 de 10`; las filas no marcadas son `is-disabled` con `tabIndex=-1` y `aria-disabled="true"`; con el foco forzado (`focus()`), Enter y Espacio dejan `10 de 10`. **T2.4:** Escape cierra el modal de territorio y el del comparador. **T2.5** (motor anterior): `llego: false` en 40 Tab (como M10).
obtenido (`/tmp/s32_t2_nuevo.json`, `/tmp/s32_t2_antes.json`): motor nuevo `consola_errores: []`, `pageerror: []`, los dos modales abren.
- **T2.1:** foco inicial `input-search`; `llego: true` en **2** Tab; fila activa `Algarrobo`, `role="button"`; Enter → `modal_abierto_despues: false`; `.terr-trigger` `SLEP Costa Central ▾` → `comuna de Algarrobo ▾` (`trigger_contiene_fila: true`).
- **T2.2:** `conteo_inicial` `0 de 10`; `llego: true` en 2 Tab; fila `Algarrobo`, `role="checkbox"`, `aria-checked="false"`; Espacio → `aria-checked="true"`, clase `check-row is-checked`, `1 de 10`, modal abierto; Espacio otra vez → `aria-checked="false"`, `0 de 10` (**igual que un segundo clic hoy: `addTerr` conmuta**; registrado tal cual, sin cambio); Enter (extra) → `true`, `1 de 10`; Escape cierra y queda el chip `Algarrobo`.
- **T2.3:** tras 10 clics, `10 de 10`, 10 marcadas y 335 `is-disabled`; la primera deshabilitada (`Arauco`) tiene `tabIndex: -1`, `aria-disabled="true"`, `aria-checked="false"`; con `focus()` forzado, Enter → `10 de 10`, Espacio → `10 de 10`; la fila sigue `is-disabled`.
- **T2.4:** territorio `abre: true` → `tras_escape: false`; comparador `abre: true` → `tras_escape: false`.
- **T2.5** (motor anterior): `llego: false` en 40 Tab, foco final en `div.card.foco` detrás del modal (= M10).
- **Regresión (PRUEBAS a, b, c):** build `rc=0`, 0 warnings; 0 errores de consola y 0 `pageerror` con los dos modales abiertos; §8.2 `900913c1…78b4`, offsets 38–39.
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only HEAD; git -C /Users/tomgc/Projects/slep_idps ls-files --others --exclude-standard'
```
esperado: `30_procesamiento/35_motor_template.html` (ALCANCE de T2) más las cuatro rutas conocidas que no se commitean aquí (motor temporal, encargo, este log y `Claude outputs/…` de O-1).
obtenido: exactamente esas cinco rutas; solo la plantilla es del ALCANCE y solo ella se agrega.
- **Commit:** `45b3db0` fix(motor): filas del modal operables por teclado (s32 T2). `git show --name-only HEAD` = `30_procesamiento/35_motor_template.html`.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T3: enmienda de la decisión §3.5

- **Paso 0:** leída en la plantilla (commit `45b3db0`) la fórmula del color de la celda de `PanoramaHistorico`: `vtTinte(color,v,dom,k0)` (L2605-2608: `k=max(0,min(1,(v-dom[0])/(dom[1]-dom[0])))`, fondo `_mix('#ffffff',color,k0+(1-k0)*k)`), `_mix`/`_toHex` (L1133-1135: mezcla por canal y `Math.round`), `vtTexto(bg)` (L2611-2614: mayor razón entre `#000000`, `vtGris()` = `--gris` `#5C666E` y `#ffffff`) y `_lumWCAG`/`contrasteWCAG` (L2599-2601). `dom` = `VT.dominio_color[grado|ind]`, `k0` = `VT.tinte_minimo` (L2656-2657). Transcrita tal cual a `/tmp/s32_rampa.R`; única adaptación declarada: `Math.round(x)` → `floor(x+0.5)` (el `round()` de R redondea al par). Los colores, `dominio_color` y `tinte_minimo` se leen del payload (`atob` → zlib con `memDecompress(type="gzip")` → `jsonlite::fromJSON`). Nota de lectura: el encargo escribe "k ∈ [k0, 1]"; en la fórmula la fracción de mezcla es `k0+(1-k0)·k`, que recorre [k0, 1] cuando `k` recorre [0, 1]; se barre `k` ∈ [0, 1] con paso 0,001 (el mismo barrido del log s31b, que reporta k = 0,819).
- **Verificación (medición en R):**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32_rampa.R /tmp/s32_motor_antes.html'
```
esperado: controles `21.00` y `4.48`; piso de la rampa continua `4.58` (Autoestima, id 1, `#3858A3`, k ≈ 0,819, fondo `#5a74b3`); mínimo sobre puntajes enteros `4.78` (clave `4b|1`, puntaje 81).
obtenido: `controles: #000000/#ffffff = 21.00 ; #777777/#ffffff = 4.48`; `payload: 59.467.009 bytes de JSON; fecha_generacion 2026-09-17; tinte_minimo 0.06`; rampa continua: ind 1 `#3858A3` **`4.5838 (4.58)` en k=0.819 (fondo `#5a74b3`)**, ind 2 `9.60` (k=0.997), ind 3 `6.85` (k=0.998), ind 4 `11.39` (k=0.997) → `PISO RAMPA CONTINUA: 4.58 (ind 1, k=0.819, fondo #5a74b3)`; enteros: **`4b|1` (dominio 65-84) `4.7808 (4.78)` en puntaje 81 (fondo `#5671b1`)**, `2m|1` 4,85 (79), `4b|2`/`2m|2` 9,60, `4b|3`/`2m|3` 6,85, `4b|4`/`2m|4` 11,39 → `MINIMO SOBRE PUNTAJES ENTEROS: 4.78 (4b|1, puntaje 81, fondo #5671b1)`. Las dos cifras coinciden con su esperado (y con el log s31b, L278); la enmienda se escribe. Ruido de la corrida: el aviso de `renv` "out-of-sync" (pendiente conocido de `suitedoc`) y un aviso de `prettyNum` por el `big.mark` de mi propio `format()` (cosmético, del instrumento).
- **Enmienda:** §3 punto 5 (L34), reemplazo literal del encargo; y al final del documento una línea en blanco más `**Enmienda s32 (2026-09-23):** §3.5 distinguía mal el piso de la rampa (4,58:1) del mínimo sobre puntajes enteros (4,78:1); detectado en la revisión s31b (log L274).`
- **Verificación del texto:**
```
bash -c 'D=50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md; git -C /Users/tomgc/Projects/slep_idps diff --stat -- $D; git -C /Users/tomgc/Projects/slep_idps diff -U0 -- $D | grep -E "^@@"; grep -c "4,58:1" /Users/tomgc/Projects/slep_idps/$D'
```
esperado: `1 file changed`; dos zonas (`@@` de L34 y `@@` del final); `grep -c` ≥ 1 (se espera 2: §3.5 y la línea de enmienda).
obtenido: `1 file changed, 3 insertions(+), 1 deletion(-)`; zonas `@@ -34 +34 @@` y `@@ -68,0 +69,2 @@` (solo esas dos); `2`.
- **Regresión:** T3 no tocó código (solo un `.md` de decisiones); se declara, no se omite.
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only HEAD; git -C /Users/tomgc/Projects/slep_idps ls-files --others --exclude-standard'
```
esperado: la decisión (ALCANCE de T3) más las cuatro rutas conocidas que no se commitean aquí (motor temporal, encargo, este log, `Claude outputs/…`).
- **Commit:** `62514a9` docs(decision): enmienda §3.5, piso de la rampa 4,58:1 (s32 T3). `git show --name-only HEAD` = la decisión.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE T4: build del motor

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; echo ---; git -C /Users/tomgc/Projects/slep_idps status --porcelain --untracked-files=no'
```
esperado: el encargo dice "solo `40_salidas/motor_idps.html` o vacío". Ese esperado no cuenta este log, que existe sin versionar desde FASE 0 hasta FASE L en cualquier corrida; se mide también la vista sin no versionados. Esperado leído: rastreados = solo ` M 40_salidas/motor_idps.html`; no versionados = el encargo (gate M1), este log y `Claude outputs/…` (O-1).
obtenido: rastreados ` M 40_salidas/motor_idps.html` (única); no versionados: el encargo, este log y `"Claude outputs/"`. **Decisión autónoma D-A4:** se sigue con T4. El paso 1 protege que el commit de T4 no arrastre otra cosa rastreada; el commit va con ruta explícita y los tres no versionados son conocidos (dos por diseño del encargo y del gate, uno del titular, O-1). No se toca ninguno.
- **Paso 2 (PRUEBAS a, 🔒2, testigo):**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32_run35_t4.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32_run35_t4.log; M=/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html; md5 -q $M; ls -l $M | awk "{print \$5}"; cp $M /tmp/s32_motor_t4.html; cmp -s $M /tmp/s32_motor_t2.html && echo igual_a_t2; grep -c "check-row:focus-visible" $M; bash /tmp/s32_payload_sha.sh $M; node /tmp/s32_payload_norm.js $M /tmp/s32_motor_antes.html'
```
esperado: `rc=0`; `0`; md5 distinto de `6c5feab5…`; byte a byte igual al build de T2 (misma plantilla: T3 no la tocó; mismo día); `grep -c` ≥ 1; SHA crudo `757a9a21…` (día de hoy); §8.2 `900913c1…78b4` con offsets `[38,39]`.
obtenido: `rc=0`; `0`; md5 **`1069b9c94b79510f3c26ce77b5cac2f6`** (5.465.058 bytes; ≠ `6c5feab5…`); `igual_a_t2`; `1`; SHA crudo `757a9a2110487dc4…a7c6`; §8.2 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`, `offsets_distintos: [38,39]`. 🔒2 intacto.
- **Paso 3 (PRUEBAS b y repetición de T1.2, T1.3 y T2.1 sobre el motor commiteable, el archivo del árbol):**
```
bash -c 'NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32_verif.js /Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html consola,slep,titulo,tecl_terr "{\"comCod\":\"2202\"}" > /tmp/s32_t4_nav.json'
```
esperado: 0 errores de consola y 0 `pageerror` con los dos modales abiertos; T1.2: `malos_slep: 0`, `SLEP Santiago Centro | 1 comuna · 39 establecimientos`, Nacional `… 346 comunas · 9.136 establecimientos`; T1.3: comuna `2202` → `Descarga en CSV el establecimiento de esta vista, …`, foco → `Descarga en CSV los 60 establecimientos de esta vista, …`, censos `[]`; T2.1: `llego: true` en 2 Tab, Enter cierra y el disparador pasa a `comuna de Algarrobo ▾`.
obtenido (`/tmp/s32_t4_nav.json`): `consola_errores: []`, `pageerror: []`, `modal_territorio: true`, `modal_comparador: true`; T1.2 `malos_slep: 0`, `SLEP Santiago Centro | 1 comuna · 39 establecimientos`, `Chile | Nivel nacional · 346 comunas · 9.136 establecimientos`, región 0 malas, censo del modal `[]`; T1.3 foco `Descarga en CSV los 60 establecimientos de esta vista, …` `[]`, comuna `2202` `Descarga en CSV el establecimiento de esta vista, …` `[]`; T2.1 `llego: true`, 2 Tab, `Algarrobo`, `role="button"`, modal cerrado, `comuna de Algarrobo ▾`.
- **Chequeo de alcance:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps diff --name-only HEAD; git -C /Users/tomgc/Projects/slep_idps ls-files --others --exclude-standard'
```
esperado: `40_salidas/motor_idps.html` (ALCANCE de T4) más los tres no versionados conocidos.
obtenido: `40_salidas/motor_idps.html` más los tres no versionados conocidos.
- **Commit:** `4a22cbc` build(motor): s32 conteos y teclado. `git show --name-only HEAD` = `40_salidas/motor_idps.html`; `git show HEAD:40_salidas/motor_idps.html | md5 -q` = `1069b9c94b79510f3c26ce77b5cac2f6`.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Bugs:** ninguno. Intentos: 1.

### FASE R: auditoría propia y reparación

**Paso 1. Inventario de afirmaciones auditables** (anexado antes de auditar; `<inicio>` = `6117393`):

| id | afirmación (origen) |
|---|---|
| R-01 | Punto de retorno: `HEAD` = `origin/main` = `6117393` al empezar; los commits de la sesión son `b0262ca`, `45b3db0`, `62514a9`, `4a22cbc` (FASE 0, M2) |
| R-02 | `docs/index.html` = motor de FASE 0 (`6c5feab5…`); payload crudo `a2f21bb1…`; §8.2 `900913c1…78b4` (M3, M4, M4′) |
| R-03 | H-0: entre builds de distinto día el JSON del payload difiere solo en los offsets 38–39 (`fecha_generacion`) (FASE 0) |
| R-04 | M7: en `6117393` hay 7 líneas con plural fijo (L1096, L1111, L1690, L1754, L1771, L1776, L2957) |
| R-05 | T1.1: 0 plurales fijos; un `nEE` y un `nCom`, declarados antes de las IIFE |
| R-06 | T1.2: tab SLEP sin "1 comunas/establecimientos"; Santiago Centro `1 comuna · 39 establecimientos`; Nacional `346 comunas · 9.136 establecimientos` |
| R-07 | T1.3: `title` de exportación en singular con 1 EE (`el establecimiento`) y en plural con el foco (`los 60 establecimientos`) |
| R-08 | T1.5: `StackedBar` decía `1 establecimientos` en el foco del motor anterior (8 atributos) y ya no en el nuevo |
| R-09 | D-A1: la meta del chip del comparador y el banner dicen lo mismo que antes |
| R-10 | T2.1: la fila del modal de territorio se alcanza con Tab y se elige con Enter |
| R-11 | T2.2: en el comparador, Espacio conmuta `aria-checked` y `.modal-count` como el clic |
| R-12 | T2.3: con el tope lleno, las filas `is-disabled` tienen `tabIndex=-1`, `aria-disabled="true"` y Enter/Espacio no cambian el conteo |
| R-13 | T2.4: Escape cierra los dos modales |
| R-14 | T2 CSS: `.check-row:focus-visible` dibuja un contorno de 2 px en `--foco` |
| R-15 | D-A3: la autorrepetición de la tecla no conmuta |
| R-16 | M11: las filas del hermano no tienen `tabIndex`/`onKeyDown`/`role`; líneas citadas |
| R-17 | T3: controles 21,00 y 4,48; piso de la rampa continua 4,58 (ind 1, k = 0,819, `#5a74b3`); mínimo sobre enteros 4,78 (`4b|1`, puntaje 81) |
| R-18 | T3: el diff de la decisión tiene solo dos zonas; `4,58:1` aparece 2 veces |
| R-19 | T4: motor `1069b9c9…` (5.465.058 bytes) = build de T2 = lo commiteado; reproducible |
| R-20 | M12/testigo: `check-row:focus-visible` 0 en `docs/index.html`, ≥ 1 en el motor |
| R-21 | M14: 61 archivos de datos versionados |
| R-22 | 0 warnings en todas las corridas de `run_all(only = 35L)` |
| R-23 | M9: 12 comunas con 1 EE en 4° básico 2025 (entre ellas `2202`) |
| R-24 | M8/M10: los casos malos existían en `6117393` (plural fijo en el `sub` SLEP; filas sin `tabIndex`) |
| R-25 | O-1: `Claude outputs/20260923_registro_asistente_s32.md` no lo produjo esta sesión |
| 🔒1–🔒6 | invariantes de §3 del encargo (🔒2 con la convención §8.2, gate H-0) |
| ALC | alcance global ⊆ {plantilla, motor, decisión, LOG} |
| REG | PRUEBAS a, b, c sobre el estado final |

**Paso 2. Re-derivación independiente** (cada afirmación con un comando distinto del que la produjo).

Bloque estático (git, `grep` sobre objetos de git y sobre el motor construido, no sobre la plantilla del árbol):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; G="git -C $R"; echo R01: $($G merge-base --is-ancestor 6117393 HEAD && echo ancestro) $($G rev-list --count 6117393..HEAD) $($G log --format=%h 6117393..HEAD | tr "\n" " "); echo R02: $($G show 6117393:40_salidas/motor_idps.html | md5 -q) $($G show 6117393:docs/index.html | md5 -q) $(md5 -q $R/docs/index.html); echo R04: $($G show 6117393:30_procesamiento/35_motor_template.html | grep -nE "\+ ?\" (comunas|establecimientos)\b" | cut -d: -f1 | tr "\n" " "); echo R05: $($G show HEAD:40_salidas/motor_idps.html | grep -cE "\+ ?\" (comunas|establecimientos)\b") $($G show HEAD:40_salidas/motor_idps.html | grep -c "const nEE=") $($G show HEAD:40_salidas/motor_idps.html | grep -c "const nCom=") $($G show HEAD:40_salidas/motor_idps.html | grep -c "rep.N+\" establecimientos"); echo R16: tabIndex=$(grep -c tabIndex /Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html) onKeyDown=$(grep -c onKeyDown /Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html) $(sed -n "3979p;4025p;4027p;4064p;4110p;4112p" /Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html | grep -oE "<(label|input)[^ ]*" | tr "\n" " "); echo R18: $($G diff 6117393..HEAD -- 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md | grep -cE "^[-+][^-+]") $($G diff 6117393..HEAD -- 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md | grep -c "^@@") $($G show HEAD:50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md | grep -o "4,58:1" | wc -l); echo R19: $($G show HEAD:40_salidas/motor_idps.html | shasum -a 256 | cut -c1-16) $(shasum -a 256 /tmp/s32_motor_t2.html | cut -c1-16) $($G show HEAD:40_salidas/motor_idps.html | wc -c); echo R20: $(grep -o "check-row:focus-visible" $R/docs/index.html | wc -l) $($G show HEAD:40_salidas/motor_idps.html | grep -o "check-row:focus-visible" | wc -l); echo R21: $($G ls-files "*.csv" "*.xlsx" "*.parquet" "*.rds" | wc -l); echo R22: $(cat /tmp/s32_run35_*.log | grep -ci warn) $(grep -l "Paso 35 OK" /tmp/s32_run35_*.log | wc -l) $(ls /tmp/s32_run35_*.log | wc -l); echo R24: $($G show 6117393:30_procesamiento/35_motor_template.html | grep -c "s.ncom+\" comunas") $($G show 6117393:30_procesamiento/35_motor_template.html | grep -c "tabIndex")'
```
esperado: R01 `ancestro 4` y los cuatro hashes de la sesión; R02 los tres md5 `6c5feab5…`; R04 `1096 1111 1690 1754 1771 1776 2957`; R05 `0 1 1 0`; R16 `tabIndex=0 onKeyDown=0` y las filas citadas son `<label`/`<input`; R18 `3 2 2` (una línea quitada, tres agregadas contando la línea en blanco: el `grep` de líneas con contenido ve 1 quitada y 2 agregadas = 3; dos `@@`; dos `4,58:1`); R19 el mismo prefijo SHA en HEAD y en el build de T2, 5465058 bytes; R20 `0 1`; R21 `61`; R22 `0` warnings y 4 de 4 corridas con "Paso 35 OK"; R24 `1 0`.
obtenido: `R01: ancestro 4 4a22cbc 62514a9 45b3db0 b0262ca`; `R02:` los tres `6c5feab5428ed05dff09867f2b47bba3`; `R04: 1096 1111 1690 1754 1771 1776 2957`; `R05: 0 1 1 0`; `R16: tabIndex=0 onKeyDown=0 <label <input <label <input` (L3979 y L4064 abren `<label`; L4027 y L4112 son los `<input>`; L4025 y L4110 son la línea `className` de los `<label>` abiertos en L4024 y L4109, releídas aparte: `<label key={r.cod_reg}`, `<label key={s.cod_slep}`); `R18: 3 2 2`; `R19: e3371d945b03b9e6 e3371d945b03b9e6 5465058`; `R20: 0 1`; `R21: 61`; `R22: 0 4 4`; **`R24: 1 1`** (esperado `1 0`).
R24, error de instrumento (mío): el `grep -c tabIndex` recorrió todo el archivo, y en `6117393` hay un `tabIndex` que no es del modal (L954, `<div className={"card"…} role="button" tabIndex={0}`, la tarjeta del EE). Re-medido en el ámbito de `EntityModal`:
```
bash -c 'G="git -C /Users/tomgc/Projects/slep_idps"; $G show 6117393:30_procesamiento/35_motor_template.html | grep -n "tabIndex" | cut -c1-170; $G show 6117393:30_procesamiento/35_motor_template.html | sed -n 1580,1650p | grep -c tabIndex; $G show HEAD:30_procesamiento/35_motor_template.html | sed -n 1583,1665p | grep -c tabIndex'
```
esperado: (propio) un único `tabIndex` fuera del modal en `6117393`; `0` dentro de `EntityModal` en `6117393`; `1` en HEAD.
obtenido: `954: <div className={"card"+(foco?" foco":"")} role="button" tabIndex={0}`; `0`; `1`. R24 confirmado (el esperado se corrige por ámbito, no por cifra: el `1` global era la tarjeta).

R-02/R-03 (🔒2 por otra vía: R + `shasum` sobre objetos de git, en vez de node sobre archivos del árbol):
```
bash -c 'G="git -C /Users/tomgc/Projects/slep_idps"; $G show 6117393:40_salidas/motor_idps.html > /tmp/s32_r_motor_inicio.html; $G show HEAD:40_salidas/motor_idps.html > /tmp/s32_r_motor_head.html; cd /Users/tomgc/Projects/slep_idps && Rscript /tmp/s32_r_payload.R; shasum -a 256 /tmp/s32_r_norm_inicio.json /tmp/s32_r_norm_head.json'
```
esperado: `59467009` bytes en ambos; offsets distintos `38 39` (`2026-09-17` → `2026-09-23`); los dos normalizados con SHA-256 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`.
obtenido: `bytes: 59467009 vs 59467009`; `offsets distintos: 38 39`; `eracion":"2026-09-17", -> eracion":"2026-09-23",`; `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4` en los dos. R-02/R-03 confirmados por otra vía.

R-17 y R-23 (T3 se midió en R; aquí en node, con las funciones copiadas de la plantilla en HEAD, `Math.round` nativo y enteros 0..100 en vez de solo el dominio; M9 se midió con `page.evaluate`, aquí sobre el JSON extraído):
```
bash -c 'node /tmp/s32_json_payload.js /tmp/s32_r_motor_head.html /tmp/s32_r_json_head.json >/dev/null; node /tmp/s32_r_rampa.js /tmp/s32_r_json_head.json'
```
esperado: `controles 21.00 4.48`; piso `4.58xx` en ind 1, k 0.819, `#5a74b3`; mínimo sobre enteros `4.78xx` en `4b|1`, puntaje 81; R23: año 2025, 343 comunas con EE, 12 con 1 EE, entre ellas `2202`.
obtenido: `controles 21.00 4.48`; `piso rampa continua 4.5838 ind 1 k 0.819 #5a74b3`; `minimo enteros 0..100 4.7808 4b|1 puntaje 81 #5671b1`; `R23 2025 343 12 11102 11301 11302 11303 12102 12104 12201 12302 12303 15202 2202 5104`. R-17 y R-23 confirmados en otro lenguaje (node) y con otro barrido (enteros 0..100).

Navegador, otra vía (`/tmp/s32_r_verif.js`: funciones del script en vez del DOM; otras entidades, otras pestañas y otras teclas que en T1/T2), sobre el motor de HEAD (`/tmp/s32_r_motor_head.html`, copia de `git show HEAD:…`) y, para R-09, también sobre el de `6117393`:
```
bash -c 'export NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules; node /tmp/s32_r_verif.js /tmp/s32_r_motor_head.html r_js,r_barras,r_chip,r_region_space,r_slep_enter,r_tope_tab,r_escape_fila,r_focus_style,r_repeat > /tmp/s32_r_head.json; node /tmp/s32_r_verif.js /tmp/s32_r_motor_inicio.html r_js,r_barras,r_chip > /tmp/s32_r_inicio.json'
```
esperado:
- R-05/R-06 (`r_js`, HEAD): `nEE` → `0 establecimientos`, `1 establecimiento`, `2 establecimientos`, `1.234 establecimientos`; `nCom` → `0 comunas`, `1 comuna`, `2 comunas`, `346 comunas`; `NACIONAL_OPT.sub` = `Nivel nacional · 346 comunas · 9.136 establecimientos`; `_listaCmpEnt("slep")` 36 filas, 0 malas, `SLEP Santiago Centro | 1 comuna · 39 establecimientos`; tabs Región de los dos constructores, 0 malas. En `6117393`: `nEE` accesible (existía), `nCom` no existe (ReferenceError), SLEP 1 mala.
- R-08 (`r_barras`, vista de apertura): HEAD `aria_singular` ≥ 1 y `title_singular` ≥ 1, `aria_plural_malo` 0, `title_plural_malo` 0; `6117393`: al revés (4 y 4 malos, 0 singulares).
- R-09 (`r_chip`): meta del chip de SLEP Santiago Centro y banner/`title` de la comuna `11303` (otra de M9): el chip y el banner **iguales en los dos motores** (`… | 1 comuna · N establecimientos`; `1 comuna · 1 establecimiento en el nivel seleccionado · …`); el `title` distinto (HEAD `el establecimiento`, `6117393` `los 1 establecimientos`).
- R-10 (`r_region_space`): pestaña Región del modal de territorio, tercera fila, Espacio → modal cerrado y disparador `Región de … ▾`.
- R-11 (`r_slep_enter`): comparador, pestaña SLEP, Enter → `aria-checked="true"`, `0 de 10` → `1 de 10`, un chip.
- R-12 (`r_tope_tab`): comparador, Región (16 filas), 10 marcadas → 6 `is-disabled`, las 6 con `tabIndex=-1` y `aria-disabled="true"`; las 10 habilitadas con `tabIndex=0` y sin `aria-disabled`; Tab desde la décima llega al botón `Listo` (salta las 6).
- R-13 (`r_escape_fila`): Escape con el foco **en una fila** cierra el modal.
- R-14 (`r_focus_style`): fila con foco por teclado: `:focus-visible` verdadero, contorno `solid 2px rgb(0, 98, 160)` (= `--foco` `#0062A0`), `outline-offset` `-2px`.
- R-15 (`r_repeat`): dos `keydown` de Espacio sin soltar (el segundo con `repeat`) → `aria-checked="true"`, `1 de 10` (conmuta una vez); control: dos pulsaciones separadas sobre la fila siguiente → `false`, conteo sin cambio (`1 de 10`).
- 0 errores de consola y 0 `pageerror` en las dos corridas.
obtenido (`/tmp/s32_r_head.json`, `/tmp/s32_r_inicio.json`; 0 errores de consola y 0 `pageerror` en las dos):
- R-05/R-06 HEAD: `nEE` → `0 establecimientos`, `1 establecimiento`, `2 establecimientos`, `1.234 establecimientos`; `nCom` → `0 comunas`, `1 comuna`, `2 comunas`, `346 comunas`; `Nivel nacional · 346 comunas · 9.136 establecimientos`; SLEP 36 filas, `slep_malos: []`, `SLEP Santiago Centro | 1 comuna · 39 establecimientos`; Región `region_malos: 0` (mínimo 4 comunas por región). `6117393`: `nEE` igual, `ReferenceError: nCom is not defined`, `slep_malos: ["SLEP Santiago Centro | 1 comunas · 39 establecimientos"]`.
- R-08: HEAD `aria_singular 4`, `aria_plural_malo 0`, `title_singular 4`, `title_plural_malo 0` (16 barras); `6117393` `0 / 4 / 0 / 4`.
- R-09: chip `SLEP Santiago Centro | 1 comuna · 24 establecimientos` **idéntico** en los dos motores; banner de la comuna `11303` `1 comuna · 1 establecimiento en el nivel seleccionado · 4° básico · 5 de 5 GSE · 2025 (preliminar)` **idéntico** en los dos; `title` HEAD `Descarga en CSV el establecimiento de esta vista, …` vs `6117393` `Descarga en CSV los 1 establecimientos de esta vista, …`. D-A1 no cambió el texto visible.
- R-10: 2 Tab a la primera fila de Región, 2 más a la tercera (`Atacama`, `role="button"`), Espacio → `modal: false`, disparador `comuna … ▾` (la `11303` de R-09) → `Región de Atacama ▾`.
- R-11: `0 de 10`; 1 Tab (la pestaña SLEP no dibuja selector de dependencia) a `SLEP Aconcagua` (`role="checkbox"`, `aria-checked="false"`); Enter → `aria-checked="true"`, `check-row is-checked`, `1 de 10`; tras Escape, chip `SLEP Aconcagua`.
- R-12: Región del comparador, 16 filas, 10 marcadas (`10 de 10`) → `dis 6`, `dis_tab_menos1 6`, `dis_aria 6`, `hab_tab0 10`, `hab_sin_aria_dis 10`; Tab desde la décima → `BUTTON` `Listo` (saltó las 6 deshabilitadas).
- R-13: foco en fila, Escape → `modal_tras_escape: false`.
- R-14: `focus_visible: true`, `outline: solid 2px rgb(0, 98, 160)`, `offset: -2px`, `--foco` = `#0062A0`.
- R-15: dos `keydown` sostenidos sobre `Algarrobo` → `aria-checked="true"`, `1 de 10` (una sola conmutación); control, dos pulsaciones separadas sobre `Alhué` → `false`, `1 de 10`. La guarda de autorrepetición actúa y el instrumento distingue los dos casos.
- R-25 (sin comando nuevo que la pruebe mejor que la cronología): la ruta `Claude outputs/…` apareció a las 15:38 (mtime), entre M1 (15:26, porcelain sin ella) y el chequeo de alcance de T1; ningún comando de esta sesión escribe en esa ruta (todos los temporales van a `/tmp/s32_*`). Se mantiene como O-1.

**Paso 3. Invariantes 🔒** (comandos de §3 del encargo, `<inicio>` = `6117393`, tras el último commit `4a22cbc`):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R; echo "L1: $(git diff --name-only 6117393..HEAD -- 10_utils 20_insumos "30_procesamiento/31*" "30_procesamiento/32*" "30_procesamiento/33*" "30_procesamiento/34*" 30_procesamiento/35_generar_motor_html.R 00_build.R | wc -l)"; echo "L2: $(node /tmp/s32_payload_norm.js $R/40_salidas/motor_idps.html /tmp/s32_motor_antes.html)"; echo "L2crudo: $(bash /tmp/s32_payload_sha.sh $R/40_salidas/motor_idps.html)"; echo "L3a: $(bash /tmp/s32_root_md5.sh $R/30_procesamiento/35_motor_template.html)"; echo "L3b: $(git diff 6117393..HEAD -- 30_procesamiento/35_motor_template.html | grep -E "^[+-][^+-].*#[0-9A-Fa-f]{3,6}\b" | wc -l)"; echo "L4: $(git diff 6117393..HEAD -- 30_procesamiento/35_motor_template.html | grep -c sigdifgru)"; echo "L5: $(git diff --name-only 6117393..HEAD -- docs | wc -l)"; echo "L6: $(git ls-files | grep -cE "\.(csv|xlsx|parquet|rds)$")"'
```
esperado: L1 `0`; L2 §8.2 `900913c1…78b4` con offsets `[38,39]` (y el SHA crudo registrado, `757a9a21…`, distinto de FASE 0 solo por la fecha: gate H-0); L3a `63` líneas, md5 `9842151d897e8768abd2207513c6607b`; L3b `0`; L4 `0`; L5 `0`; L6 `61`.
obtenido: `L1: 0` → **🔒1 PASA**. `L2:` §8.2 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`, `offsets_distintos: [38,39]`; crudo `757a9a2110487dc4cdda295d3746ae17dbeadcae9a4b7d1ecef71b618feea7c6` → **🔒2 PASA con la convención §8.2** (gate H-0; al pie de la letra del encargo, el SHA crudo difiere de M4 solo por la fecha). `L3a: lineas: 63; md5 9842151d897e8768abd2207513c6607b` (= FASE 0) y `L3b: 0` → **🔒3 PASA**. `L4: 0` → **🔒4 PASA**. `L5: 0` → **🔒5 PASA**. `L6: 61` (= M14) → **🔒6 PASA**. (La salida de L3b se imprimió duplicada en la terminal, `L3b: 0 L3b: 0`; re-medido solo, con `wc -l` y con `grep -c`: `0` y `0`, `rc=1`.)

**Paso 4. Alcance global:**
```
bash -c 'cd /Users/tomgc/Projects/slep_idps; git diff --name-only 6117393..HEAD; git diff --numstat 6117393..HEAD; git diff --name-only 6117393..HEAD | grep -vxF -e 30_procesamiento/35_motor_template.html -e 40_salidas/motor_idps.html -e 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md -e 50_documentacion/andamios/logs/20260923_conteos_teclado_enmienda_s32_log.md | wc -l; git status --porcelain'
```
esperado: las tres rutas (plantilla, motor, decisión; el LOG aún no está commiteado); `0` rutas fuera del conjunto permitido; porcelain: los tres no versionados conocidos (encargo, este log, `Claude outputs/`), ningún rastreado modificado.
obtenido: `30_procesamiento/35_motor_template.html` (+30/−14), `40_salidas/motor_idps.html` (+31/−15: las mismas líneas de la plantilla más la línea del payload por la fecha), la decisión (+3/−1); `0` rutas fuera del conjunto; porcelain: `?? …encargo…s32.md`, `?? …s32_log.md`, `?? "Claude outputs/"` (ningún rastreado modificado). Alcance global ⊆ permitido: **PASA**.

**Paso 5. Regresión completa** (PRUEBAS a, b, c sobre el estado final):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R && Rscript -e "setwd(\"/Users/tomgc/Projects/slep_idps\"); source(\"00_build.R\"); run_all(only = 35L)" > /tmp/s32_run35_faseR.log 2>&1; echo rc=$?; grep -ciE "warn" /tmp/s32_run35_faseR.log; md5 -q $R/40_salidas/motor_idps.html; git -C $R status --porcelain --untracked-files=no | wc -l; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32_verif.js $R/40_salidas/motor_idps.html consola > /tmp/s32_faseR_consola.json; grep -A1 -E "consola_errores|pageerror" /tmp/s32_faseR_consola.json | tr -d "\n "; echo; node /tmp/s32_payload_norm.js $R/40_salidas/motor_idps.html /tmp/s32_motor_antes.html'
```
esperado: a) `rc=0`, `0` warnings, md5 `1069b9c94b79510f3c26ce77b5cac2f6` (= HEAD: el build es reproducible el mismo día) y `0` rastreados modificados; b) `consola_errores: []`, `pageerror: []` con los dos modales abiertos; c) §8.2 `900913c1…78b4`, offsets `[38,39]`.
obtenido: a) `rc=0`, `0`, `1069b9c94b79510f3c26ce77b5cac2f6`, `0`; b) `modal_territorio: true`, `modal_comparador: true`, `consola_errores: []`, `pageerror: []`; c) `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4`, `offsets_distintos: [38,39]`. **Regresión PASA** (el build del estado final es byte a byte el commiteado).

**Paso 6. Control positivo de la propia auditoría** (cada instrumento contra un caso plantado o un rango de historia que sí toca lo vigilado):
```
bash -c 'R=/Users/tomgc/Projects/slep_idps; cd $R; echo "C1 (🔒1 sobre 68b4e43, que tocó 35_generar): $(git diff --name-only 68b4e43~1..68b4e43 -- 10_utils 20_insumos "30_procesamiento/31*" "30_procesamiento/32*" "30_procesamiento/33*" "30_procesamiento/34*" 30_procesamiento/35_generar_motor_html.R 00_build.R | wc -l)"; echo "C2 (🔒3b plantado): $(printf "+  .x{color:#123456;}\n-  .y{color:#abc;}\n+  .z{color:var(--foco);}\n" | grep -cE "^[+-][^+-].*#[0-9A-Fa-f]{3,6}\b")"; sed "s/--foco:#0062A0;/--foco:#0062A1;/" 30_procesamiento/35_motor_template.html > /tmp/s32_template_plantado_root.html; echo "C3 (🔒3a plantado): $(bash /tmp/s32_root_md5.sh /tmp/s32_template_plantado_root.html)"; echo "C4 (🔒4 plantado): $(printf "+  const s=d.sigdifgru;\n" | grep -c sigdifgru)"; echo "C5 (🔒5 sobre d03aa5b, el deploy de s31c): $(git diff --name-only d03aa5b~1..d03aa5b -- docs | wc -l)"; echo "C6 (🔒6 con un csv plantado): $( (git ls-files; echo 20_insumos/plantado.csv) | grep -cE "\.(csv|xlsx|parquet|rds)$")"; echo "C7 (alcance con una ruta plantada): $( (git diff --name-only 6117393..HEAD; echo 00_build.R) | grep -vxF -e 30_procesamiento/35_motor_template.html -e 40_salidas/motor_idps.html -e 50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md -e 50_documentacion/andamios/logs/20260923_conteos_teclado_enmienda_s32_log.md)"; perl -pe '"'"'s/sub:nCom\(s\.ncom\)\+" · "\+nEE\(s\.ee\)/sub:(s.ncom===1?"1 comunas":nCom(s.ncom))+" · "+nEE(s.ee)/'"'"' 40_salidas/motor_idps.html > /tmp/s32_motor_final_plantado.html; NODE_PATH=/Users/tomgc/Projects/slep_servicio_educativo_regional/node_modules node /tmp/s32_verif.js /tmp/s32_motor_final_plantado.html slep > /tmp/s32_faseR_plantado.json; echo "C8 (censo sobre el motor final plantado): $(python3 -c "import json; a=json.load(open(\"/tmp/s32_faseR_plantado.json\"))[\"acciones\"][\"slep\"]; print(a[\"malos_slep\"], a[\"ejemplos_malos\"])")"'
```
esperado: C1 ≥ 1; C2 `2` (la tercera línea usa un token, no un hex); C3 md5 **distinto** de `9842151d…`; C4 `1`; C5 `1`; C6 `62`; C7 imprime `00_build.R`; C8 ≥ 1 (`1 comunas · 39 establecimientos`).
obtenido: `C1: 2`; **`C2: 0`** (impreso duplicado: `C2 (🔒3b plantado): 0 C2 (🔒3b plantado): 0`); `C3: lineas: 63; md5 1d9d9396e4cb03ec7031d1a9ef0dfdcd` (≠ `9842151d…`); `C4: 1`; `C5: 1`; `C6: 62`; `C7: 00_build.R`; `C8: 1 ['1 comunas · 39 establecimientos']`.
**C2 no disparó: el control positivo detectó un defecto del instrumento.** Diagnóstico (`bash -c 'echo "D: $(printf "%s\n" "+  .x{color:#123456;}" | grep -cE "[0-9]{3,6}")"'` → `D: 1 D: 1`; con `{3}` sin coma → `E: 1`): el `bash` de la estación expande las llaves `{3,6}` cuando el regex va entre comillas dobles **dentro** de `$(…)` dentro de otras comillas dobles; `echo "X: $(… "…{3,6}…")"` se parte en dos palabras con los patrones `…3\b` y `…6\b`. Eso explica la salida duplicada. Alcance del defecto: **la medición `L3b` del bloque de invariantes (paso 3) es inválida** (mismo patrón anidado); su re-medición aislada (`git diff … | grep -E "…{3,6}\b" | wc -l` a nivel superior, sin `echo "$()"`) no tiene anidamiento y da `0`, pero no tenía control positivo. Revisados los demás comandos de este log con `{m,n}`: solo L3b y C2 lo usan dentro de `echo "$()"`; el grep de privacidad de FASE L también lleva `{1,2}` y se corre sin anidar. Se re-mide L3b y C2 con el regex en una variable de un script (`/tmp/s32_l3b.sh`):
```
bash /tmp/s32_l3b.sh
```
esperado: `real: 0` (🔒3b) y `plantado: 2` (el control dispara).
obtenido: `real: 0`, `plantado: 2` (bash `3.2.57(1)-release`). **🔒3b PASA con control positivo que dispara**; C2 queda re-medido y válido. El resto de los controles disparó a la primera: C1 `2`, C3 md5 distinto, C4 `1`, C5 `1`, C6 `62`, C7 `00_build.R`, C8 `1`.

**Paso 7-8. Veredicto por hallazgo y ciclo de reparación.** Ningún hallazgo es REPARA (no hay defecto del trabajo dentro de un ALCANCE); ciclos de reparación usados: 0 de 2. Ninguno es BLOQUEA: ningún 🔒 en FALLA (🔒2 con la convención del gate H-0), alcance respetado, payload intacto por §8.2, historia lineal sobre `6117393`.

**Paso 10. Tabla de salida:**

| id | afirmación | comando de re-derivación | esperado | obtenido | severidad | acción | commit | re-verificación |
|---|---|---|---|---|---|---|---|---|
| R-01 | punto de retorno y commits | `merge-base --is-ancestor`; `rev-list --count`; `log` | ancestro; 4 | ancestro; 4 (`b0262ca 45b3db0 62514a9 4a22cbc`) | — | ninguna | — | — |
| R-02/03 | docs = motor inicial; payload §8.2 y offsets | `git show` + `md5`; R + `shasum` sobre objetos de git | `6c5feab5…` ×3; `900913c1…`; 38–39 | iguales | — | ninguna | — | — |
| R-04 | M7: 7 líneas en `6117393` | `git show 6117393:…` + `grep -n` | 7 líneas | `1096 1111 1690 1754 1771 1776 2957` | ADVIERTE (A-2: premisa del redactor 3 ≠ 7) | registrar | — | — |
| R-05/06 | 0 plurales fijos; ayudantes; tab SLEP/Nacional | `grep` sobre el motor de HEAD; funciones del script en el navegador | `0 1 1 0`; 0 malas; `1 comuna · 39 …` | iguales; `6117393` 1 mala y `nCom` inexistente | — | ninguna | — | — |
| R-07 | `title` de exportación | otra comuna de M9 (`11303`) | `el establecimiento` | igual; `6117393` `los 1 establecimientos` | — | ninguna | — | — |
| R-08 | `StackedBar` en la vista de apertura | selectores de atributo exactos | HEAD 4/4 singulares, 0 malos | HEAD `4 0 4 0`; `6117393` `0 4 0 4` | — | ninguna | — | — |
| R-09 | D-A1 sin cambio visible | chip y banner en los dos motores | idénticos | idénticos | — | ninguna | — | — |
| R-10 | teclado, modal simple | Región, 3.ª fila, Espacio | cierra; `Región de …` | `Región de Atacama ▾` | — | ninguna | — | — |
| R-11 | teclado, modal múltiple | SLEP, Enter | `true`; `1 de 10` | iguales; chip | — | ninguna | — | — |
| R-12 | tope | Región del comparador; Tab desde la décima | 6/6/6; 10/10; `Listo` | iguales | — | ninguna | — | — |
| R-13 | Escape | con foco en fila | cierra | cierra | — | ninguna | — | — |
| R-14 | contorno de foco | `getComputedStyle` | `solid 2px rgb(0, 98, 160)`, `-2px` | iguales | — | ninguna | — | — |
| R-15 | autorrepetición | 2 `keydown` sostenidos; control 2 pulsaciones | `true`/`1 de 10`; control `false` | iguales | — | ninguna | — | — |
| R-16 | hermano | `grep -c tabIndex/onKeyDown`; `sed -n` | 0; 0; `<label`/`<input` | iguales | — | ninguna | — | — |
| R-17 | rampa | node (T3 fue en R), enteros 0..100 | 21,00 / 4,48; 4,58 k 0,819; 4,78 (81) | iguales | — | ninguna | — | — |
| R-18 | diff de la decisión | `git diff 6117393..HEAD`, `git show HEAD:` | `3 2 2` | `3 2 2` | — | ninguna | — | — |
| R-19 | motor commiteado reproducible | `shasum` de `git show HEAD:`; build de FASE R | = T2; `1069b9c9…` | iguales | — | ninguna | — | — |
| R-20 | testigo | `grep -o … \| wc -l` | `0 1` | `0 1` | — | ninguna | — | — |
| R-21 | 61 datos versionados | `git ls-files` con pathspecs | 61 | 61 | — | ninguna | — | — |
| R-22 | 0 warnings | `grep -ci warn` sobre las 5 corridas | 0 | 0 (5 de 5 con "Paso 35 OK") | — | ninguna | — | — |
| R-23 | 12 comunas con 1 EE | node sobre el JSON | 12, con `2202` | 12, con `2202` | — | ninguna | — | — |
| R-24 | casos malos en `6117393` | `git show` + `grep` en el ámbito del modal | `1`; `0` | `1`; `0` (el `1` global era la tarjeta, L954) | — | ninguna | — | — |
| R-25 | O-1 no es de la sesión | cronología (mtime 15:38; M1 a las 15:26 sin ella) | ruta ajena | ruta ajena | ADVIERTE (O-1) | no se toca; condiciona el push | — | — |
| H-0 | 🔒2 literal inejecutable | `cmp -l` del JSON | — | offsets 38–39 | ADVIERTE (A-1: redacción del encargo) | gate del titular: §8.2 | — | — |
| A-3 | el modal no retiene el foco | M10/T2.5 | — | tras la última fila, Tab sale del modal a la página de fondo | ADVIERTE (preexistente, fuera de ALCANCE) | pendiente | — | — |
| A-4 | cada fila es una parada de Tab | T2.1/R-10 | — | la pestaña Comuna del modal de territorio tiene 345 filas tabulables antes de `Cancelar` | ADVIERTE (mecánica pedida por el encargo) | nota para el revisor | — | — |
| 🔒1–🔒6 | invariantes | comandos de §3; 🔒3b por script | 0 / §8.2 / md5 y 0 / 0 / 0 / 61 | todos PASA; controles C1–C8 disparan | — | — | — | — |
| ALC | alcance global | `diff --name-only` + `grep -vxF` | ⊆ permitido | 3 rutas ⊆; 0 fuera | — | — | — | — |
| REG | PRUEBAS a, b, c | build + Puppeteer + §8.2 | `rc=0`, 0 warn, `1069b9c9…`; 0 errores; `900913c1…` | iguales | — | — | — | — |

- **Veredicto global: APROBADO CON ADVERTENCIAS.** Hallazgos B/R/A = 0/0/5 (A-1 H-0 redacción del 🔒2; A-2 premisa de M7; A-3 foco no retenido por el modal; A-4 paradas de Tab; O-1 ruta ajena del titular); reparados 0; abiertos 0 que afecten la meta.
- **Estado:** completada.
- **Subagentes:** sin subagentes.
- **Errores propios en FASE R:** (1) R-24 con `grep -c tabIndex` sobre todo el archivo (esperado mal acotado; re-medido en el ámbito del modal); (2) L3b y C2 medidos con el regex `{3,6}` entre comillas anidadas en `echo "$()"`, que el bash 3.2 parte por expansión de llaves (detectado por el control positivo C2; re-medido con script). Ninguno tocó un esperado ni la meta.

### FASE L: cierre del log

- **Paso 1:**
```
bash -c 'git -C /Users/tomgc/Projects/slep_idps status --porcelain; git -C /Users/tomgc/Projects/slep_idps status -sb | head -1'
```
esperado: el LOG, el encargo (va con `docs(log)`, gate M1) y `Claude outputs/` (O-1, del titular; se anota, no se limpia); `main` adelantada 4 respecto de `origin/main`.
obtenido: `?? …encargo_claude_code_idps_conteos_teclado_enmienda_s32.md`, `?? …20260923_conteos_teclado_enmienda_s32_log.md`, `?? "Claude outputs/"`; `## main...origin/main [ahead 4]`. Hallazgo anotado (O-1), no se limpia.
- **Paso 2:** sección `## Cierre` (abajo). **Paso 3:** bloque J (arriba). **Pasos 4 y 5:** a continuación, antes del commit. **Paso 6:** `git add` del LOG y del encargo (gate M1) y commit `docs(log)`; el push depende de su condición (porcelain vacío), que se mide después del commit.

## Cierre

1. **Resumen de la sesión.** Entró el encargo s32 (conteos con plural, teclado del modal, enmienda §3.5, build). Fases: FASE 0, T1, T2, T3, T4, R, L. Estado final del grafo: T1 completada (`b0262ca`) · T2 completada (`45b3db0`) · T3 completada (`62514a9`) · T4 completada (`4a22cbc`) · FASE R APROBADO CON ADVERTENCIAS · FASE L completada. Dos gates del titular en FASE 0 (M1 y H-0).
2. **Inventario de commits** (`git log 6117393..HEAD --oneline`, antes del commit de este log):
   - `b0262ca` fix(motor): conteos visibles por nEE/nCom (s32 T1) — plantilla
   - `45b3db0` fix(motor): filas del modal operables por teclado (s32 T2) — plantilla
   - `62514a9` docs(decision): enmienda §3.5, piso de la rampa 4,58:1 (s32 T3) — decisión
   - `4a22cbc` build(motor): s32 conteos y teclado — motor `1069b9c94b79510f3c26ce77b5cac2f6` (5.465.058 bytes)
   - (este log y el encargo: `docs(log): s32 conteos, teclado y enmienda §3.5`; hash en el reporte)
3. **Tabla de auditoría:** en FASE R. Veredicto **APROBADO CON ADVERTENCIAS**; B/R/A = 0/0/5; reparados 0.
4. **Invariantes:** 🔒1 PASA (`0`; control C1 dispara con `68b4e43`) · 🔒2 PASA con la convención §8.2 del gate H-0 (`900913c1…78b4`, offsets 38–39, en node y en R+`shasum`; control plantado dispara; el SHA crudo del `<script>` cambió de `a2f21bb1…` a `757a9a21…` solo por la fecha) · 🔒3 PASA (md5 del `:root` `9842151d…` antes y después; 0 hex nuevos o borrados; controles C2 y C3 disparan) · 🔒4 PASA (`0`; C4 dispara) · 🔒5 PASA (`0`; C5 dispara con `d03aa5b`) · 🔒6 PASA (`61`; C6 dispara). 6/6.
5. **Decisiones del usuario registradas en gates:** (1) FASE 0/M1: el encargo sin versionar en el porcelain → "Continuar; el encargo va con docs(log)". (2) FASE 0/H-0: el 🔒2 literal no se puede cumplir con un build de otro día → "Convención §8.2 de s29".
6. **Estado de cifras/datos críticos:** payload intacto salvo `fecha_generacion` (JSON de 59.467.009 bytes; offsets 38–39; SHA-256 §8.2 `900913c1cf58677636dd58db762ee6710e7373a0c3d26f1613b5a1474e8878b4` antes y después). Motor: `6c5feab5428ed05dff09867f2b47bba3` (5.463.985 bytes, FASE 0) → `1069b9c94b79510f3c26ce77b5cac2f6` (5.465.058 bytes, `4a22cbc`; el build de FASE R lo reproduce byte a byte). `docs/index.html` sin cambios (`6c5feab5…`). Ningún dato versionado cambió (61).
7. **Dudas y pendientes consolidados:**
   - D-1 (A-1, H-0): ¿El redactor adopta la convención §8.2 (JSON descomprimido con `fecha_generacion` normalizada + `cmp` de offsets) como redacción estándar del 🔒 del payload en los próximos encargos, en vez del SHA crudo del `<script>`? (sí/no). Bloquea: nada (esta sesión la aplicó por gate).
   - D-2 (A-3): ¿Se abre un encargo para que `EntityModal` retenga el foco (Tab desde la última parada vuelve a la primera) y lo devuelva al disparador al cerrar? (sí/no). Bloquea: nada.
   - D-3 (A-4): ¿Se mantiene una parada de Tab por fila (mecánica de este encargo; 345 en la pestaña Comuna) o se pasa a foco itinerante con flechas, una sola parada por lista? (mantener/cambiar). Bloquea: nada.
   - D-4 (O-1): ¿`Claude outputs/20260923_registro_asistente_s32.md` se mueve a `50_documentacion/andamios/logs/` (como el registro de s31) o se descarta? (mover/descartar). Bloquea: el push de esta sesión si sigue en el árbol.
   - A-2 (M7): la premisa del encargo contaba 3 plurales fijos y había 7; dos de los extra (L1096/L1111, `StackedBar`) se veían en la vista de apertura del SLEP foco (4 barras con N = 1). Para el redactor.
   - **Pendiente 3 del traspaso v30: cerrado sin cambios.** `traspaso_cierre_v30.md` ya usa "sin comparación publicada" como criterio (§8 L92, §11 L140); las dos menciones de "Exportar CSV" (L74, L92) explican por qué se dejó de usar.
   - **Cerrados por esta sesión:** D-1 de s31c (dos cadenas de conteo a mano: `sub` SLEP del modal y `title` de exportación) → T1; P-1 de s31b (enmienda §3.5) → T3; P-3 de s31b / divergencia 13 de s29 §36.7 (teclado del modal) → T2, salvo la retención del foco (D-2).
   - **Testigo del próximo despliegue:** `check-row:focus-visible` (M12: `0` en `docs/index.html`; `1` en el motor de `4a22cbc`).
   - Marcas `# REVISAR` en código: ninguna.
8. **Errores propios consolidados:** (1) FASE 0: M3 y la prueba del `awk` de M5 corridas antes de escribir su `esperado:` (repetidas o tomadas de la tabla del encargo; costo nulo). (2) FASE 0: el esperado propio de la línea base ("md5 = `6c5feab5…`") no contaba la fecha del payload: destapó H-0 (costo: un gate). (3) FASE R: R-24 con `grep` sobre todo el archivo (re-medido en el ámbito del modal). (4) FASE R: L3b y C2 con `{3,6}` entre comillas anidadas, partido por la expansión de llaves del bash 3.2 (detectado por el control C2; re-medido por script). (5) Instrumento: `format(big.mark=".")` en `/tmp/s32_rampa.R` emite un aviso de `prettyNum` (cosmético). (6) FASE L: el control del grep de privacidad se describió con su RUT inventado literal y el grep del log dio 1; se reescribió la descripción (ver paso 4, segunda corrida). Ninguno tocó un esperado ni la meta; ninguno costó más de un turno.
9. **Notas para el revisor:** (a) gate visual: en el panorama, abrir el modal de territorio y recorrerlo con Tab (el foco entra a la primera fila tras el buscador y el selector de dependencia; Enter o Espacio elige y cierra); en el comparador, pestaña SLEP: "SLEP Santiago Centro" dice "1 comuna · 39 establecimientos", y Espacio/Enter marcan y desmarcan; (b) el contorno de foco es de 2 px en `--foco` hacia adentro (`outline-offset:-2px`), solo con teclado (`:focus-visible`); (c) el `aria-label` y el `title` de las barras usan ahora `nEE`, que además formatea miles (`1.234 establecimientos`; antes `1234`); (d) Enter también conmuta en el modal múltiple (D-A2), a diferencia de un checkbox nativo, que solo responde a Espacio; (e) el despliegue a `docs/` no se hizo (queda tras el gate visual; testigo `check-row:focus-visible`).
10. **Estado de cierre:** commiteados `b0262ca`, `45b3db0`, `62514a9`, `4a22cbc` y el commit `docs(log)` (este log + el encargo). **No se despliega** (`docs/` intacto, por contrato). Push: según la condición del encargo (porcelain vacío tras el commit `docs(log)`), medida después del commit; el resultado va en el reporte final.
11. **FASE L, pasos 4 y 5 (verificación del archivo antes del commit).**

Paso 4, grep de privacidad (`/tmp/s32_privacidad.sh`: el regex del encargo entre comillas simples en una variable, sin anidar, más un control plantado en `/tmp/s32_privacidad_plantado.txt`: un RUT inventado con puntos y guion y otro sin puntos con dígito verificador k, que no se copian aquí porque el propio grep los contaría):
```
bash /tmp/s32_privacidad.sh
```
esperado: `log: 0 coincidencias`; `plantado: 1 coincidencias`; 0 establecimientos citados por nombre.
obtenido: `log: 0 coincidencias`; `plantado: 1 coincidencias`; `RBD/EE citados por nombre: 0`. El log nombra comunas, regiones y SLEP (territorios públicos del selector); ninguna persona ni establecimiento.

Paso 5, primera medición de los conteos: `### FASE` = 7 (FASE 0, T1, T2, T3, T4, R, L: todas las ejecutadas); `## J` = 1, relleno; **`^esperado:` = 37 y `^obtenido:` = 33, no cuadran**. Causas, leídas línea a línea (`grep -nE '^(esperado|obtenido)'`): (a) cuatro resultados se escribieron como `obtenido (<archivo>):` y el conteo no los ve (T1.2–T1.5, T2.1–T2.5, T4 paso 3 y la re-derivación en navegador de FASE R); (b) al chequeo de alcance de T3 le faltó su línea `obtenido:` (el resultado se usó para el commit, pero no se anotó); (c) el diagnóstico de H-0 en FASE 0 tiene `obtenido:` sin `esperado:` (se corrió después del resultado inesperado de la línea base, sin pre-registro). Se anexa lo faltante con su estado real:
obtenido: (anexo de formato al `obtenido (…)` de T1.2–T1.5) motor nuevo sin errores; SLEP 0 malas y `1 comuna · 39 establecimientos`; `title` singular con `2202` y plural con el foco; el plantado dispara (1); el motor anterior, 1 mala en SLEP y 1 en el `title`, más 8 atributos de `StackedBar` en el foco.
obtenido: (anexo de formato al `obtenido (…)` de T2.1–T2.5) Tab llega en 2 y Enter elige y cierra; Espacio conmuta como el clic; tope con `tabIndex=-1` y `aria-disabled`, sin cambio de conteo; Escape cierra los dos modales; el motor anterior no llega en 40 Tab.
obtenido: (anexo de formato al `obtenido (…)` de T4 paso 3) 0 errores; T1.2, T1.3 y T2.1 iguales sobre el motor commiteable.
obtenido: (anexo de formato al `obtenido (…)` de la re-derivación en navegador de FASE R) R-05 a R-15 iguales a su esperado, con los contrastes del motor de `6117393`.
obtenido: (anexo, faltante, al chequeo de alcance de T3) `40_salidas/motor_idps.html`, `50_documentacion/activa/decisiones/20260917_decision_vista_historica_territorial.md`, el encargo, este log y `Claude outputs/20260923_registro_asistente_s32.md`; solo la decisión es del ALCANCE de T3 y solo ella se agregó al commit `62514a9` (`git show --name-only` lo confirma).
esperado: (anexo al diagnóstico de H-0; no se pre-registró) ninguno: se corrió para explicar el md5 inesperado de la línea base.

Segunda medición, tras los anexos:
```
bash -c 'L=/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/20260923_conteos_teclado_enmienda_s32_log.md; grep -c "^### FASE" $L; grep -c "^esperado:" $L; grep -c "^obtenido:" $L; grep -c "^## J" $L; grep -c "^(pendiente)$" $L'
```
esperado: `7`; los dos conteos iguales (39 y 39, contando este par); `1`; `0` (el slot J ya no dice "(pendiente)").
obtenido: `7`; `40`; `39`; `1`; `0` (el `grep` del último conteo devuelve `rc=1` por el 0). Los 39 `obtenido:` medidos no incluyen esta línea; con ella, **40 = 40**. Mi esperado ("39 y 39") no contó el par del paso 4: error de cuenta del esperado, no del log; la igualdad que pide el paso 5 se cumple.

Paso 4, segunda corrida (error propio 6: la primera versión de este párrafo copiaba en el log el RUT inventado del control, y el grep del log pasó a 1; se reescribió la descripción del control sin el literal):
```
bash /tmp/s32_privacidad.sh
```
esperado: `log: 0 coincidencias`; `plantado: 1 coincidencias`.
obtenido: `log: 0 coincidencias`; `plantado: 1 coincidencias`; `RBD/EE citados por nombre: 0`. El J y el punto 8 del Cierre se actualizaron a 6 errores propios antes del commit.
