# Encargo autónomo a Claude Code — slep_idps, sesión 12: P-MOTOR (serie histórica en el motor)

> Patrón: encargo autónomo dirigido por meta (`encargo_autonomo_claude_code_v1.md`).
> Tipo de sesión del proyecto: CONTINUATION (slep_idps). Este encargo cubre el
> bloque P-MOTOR del traspaso v11: el motor debe MOSTRAR la serie histórica
> 2014→2025 ya presente y verificada en el parquet. El dato está blindado; este
> encargo NO lo toca.

---

## 1. Contrato

- **Modo:** autónomo, secuencial, ejecuta todo en este turno. Una vez leído el
  estado real, encadena las fases sin pedir confirmación intermedia.
- **Reglas canónicas heredadas** (no se re-explican; ver `POLITICA_PROYECTO.md`):
  rutas absolutas siempre con `git -C /Users/tomgc/Projects/slep_idps`; sin asumir
  `cd` previo; R-only; commits atómicos temáticos, nunca `git add .` ni `git add -u`;
  `git status` revisado antes de cada `git add`; push solo con `git status` limpio.
  Scripts de verificación efímeros (`verificar_*.R`) NUNCA se versionan.
- **Regla de detención (PARA y reporta, no improvises) — solo en estos casos:**
  1. Un invariante 🔒 te obligaría a alterar el parquet o a inventar metodología
     (significancia/GSE/geo que el dato no trae).
  2. Un dato real contradice un supuesto de este encargo (p. ej. el `md5` del
     parquet NO es `4c764d8c9f0bf70004f8aa52661ae901`, o `grado_anios` no calza
     con lo que este encargo afirma).
  3. Un gate de diseño que este encargo no resolvió. (No debería quedar ninguno;
     las dos decisiones de diseño van resueltas en la sección 3.)

---

## 2. Contexto mínimo

- **Proyecto:** `/Users/tomgc/Projects/slep_idps` (Rama A, datos públicos en el
  repo; motor React 18 + D3 v7 inline en GitHub Pages, sirve `docs/index.html`).
- **Pipeline del producto:**
  - Generador: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_generar_motor_html.R`
  - Plantilla: `/Users/tomgc/Projects/slep_idps/30_procesamiento/35_motor_template.html`
  - Config:   `/Users/tomgc/Projects/slep_idps/10_utils/10_configuracion.R`
  - Dato:     `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
  - Salida:   `/Users/tomgc/Projects/slep_idps/40_salidas/motor_idps.html`
  - Deploy:   se copia la salida a `/Users/tomgc/Projects/slep_idps/docs/index.html`
- **Cómo se construye el motor:** `source(here::here("30_procesamiento","35_generar_motor_html.R"))`
  desde una sesión R con el working dir del proyecto (o `setwd` al root antes).
  El generador lee el parquet, arma un JSON columnar, lo comprime
  (gzip→base64→pako) y lo incrusta en la plantilla reemplazando `__JSON_DATA__`.
- **Estado de partida (diagnóstico ya hecho, sesión 12, P1):**
  - El parquet (`md5 4c764d8c9f0bf70004f8aa52661ae901`, 2.362.447 filas) está
    verificado a nivel CENSO en la sesión 11. Contiene la serie 2014→2025. **LEE,
    no re-audites ni regeneres el parquet.**
  - El `docs/index.html` DESPLEGADO es VIEJO: cubre solo 2022-2025 y al 4b le
    falta 2024. Por eso hay que regenerar. (No es que falte dato: el build precede
    a la integración histórica y a 4b2024.)
  - Para los grados del motor (`GRADOS_MOTOR = 4b, 2m`), el parquet tiene:
    años con dato = 2014,2015,2016,2017,2018,2022,2023,2024,2025; **faltan
    2019, 2020, 2021** (rango contiguo 2014→2025). `preliminar=TRUE` en 2024 y 2025.
- **Reparto dual:** el análisis (qué es correcto, la metodología del eje, la
  decisión de geo-NA) ya está hecho por el asistente y vive en este encargo. Tú
  ejecutas; no redefines la metodología ni escribes el traspaso.

---

## 3. Invariantes (🔒) y decisiones de diseño ya tomadas

### Invariantes intocables
- 🔒 **El parquet no se toca.** Verifica `md5` al inicio y al fin de tu trabajo:
  debe seguir siendo `4c764d8c9f0bf70004f8aa52661ae901`. Si difiere al inicio,
  detente (regla 2).
- 🔒 **Lee, no deriva.** Significancia (`dif`/`sigdif`, `difgru`/`sigdifgru`) y GSE
  no se calculan ni se inventan. En el histórico la significancia es NA en
  2014-2018 y el GSE no existe 2014-2016; el motor ya degrada con NA (no agregar
  lógica que rellene). No reconstruir el puntaje absoluto del GSE.
- 🔒 **Solo 4b y 2m en la UI** (`GRADOS_MOTOR`). 6b/8b están en el parquet, no en
  pantalla. No cambies este alcance.
- 🔒 **Sin agregación territorial.** El territorio acota la lista de
  establecimientos; nunca produce un promedio. No introducir cifras agregadas.
- 🔒 **Dimensión histórica solo existe para 2018**; subdimensión/niveles no antes
  de 2023. El render ya lo maneja vía NA; no fabricar puntos.

### Decisión de diseño D-s12-EJE (eje histórico contiguo) — RESUELTA
El eje de años de la vista histórica (y donde el motor liste años de un grado)
debe ser el **rango contiguo** desde el primer hasta el último año con dato del
grado (2014→2025 para 4b y 2m), NO solo los años con dato. Los años del rango sin
dato se marcan, no se omiten. Cada año del eje se clasifica en uno de tres estados:

- `con_dato`: el grado tiene medición ese año. Barra normal (atenuada si preliminar).
- `pandemia`: 2020 y 2021. Columna **gris desactivada** (no barra, no hueco vacío),
  rótulo/tooltip "Sin evaluación (pandemia)".
- `no_eval`: año del rango sin dato que NO es pandemia (para 4b/2m, es 2019).
  Columna **gris desactivada**, MISMO tratamiento visual que pandemia (mismo gris,
  no un tercer color), pero rótulo/tooltip distinto: "Este grado no se evaluó este año".

Justificación: el invariante v11 separó "pandemia" de "EE sin medición" porque la
CAUSA del vacío importa para una lectura honesta. 2019 es una tercera causa (el
grado no se evaluó ese año a nivel sistema) que merece el mismo tratamiento visual
de "año del calendario sin dato del sistema" (gris desactivado, contiguo en el eje)
pero con su propio rótulo. NO se usa un tercer color: pandemia y no_eval comparten
el gris desactivado; solo difieren en el texto del tooltip. El "hueco sin barra"
(EE individual sin dato un año que sí se evaluó) se mantiene como estaba: un año
`con_dato` donde ESE establecimiento no tiene fila → columna vacía "sin dato", que
es distinto de un año desactivado.

**Dónde vive la lógica (decisión A): en el generador R, no en el template JS.**
El generador ya deriva `grado_anios` y `anios_preliminar` del dato. Se le agrega la
construcción del eje contiguo con la clasificación por año, emitida en `meta`. El
template solo CONSUME esa estructura y pinta; no reconstruye el eje en JS. El motivo
(pandemia vs no_eval) se decide server-side con constantes nombradas en R, nunca
hardcodeado en el JS.

### Decisión de diseño D-s12-GEONA (RBD solo-históricos sin geo) — RESUELTA
356 RBD del universo del motor (4b/2m) tienen `cod_com_rbd`/`cod_reg_rbd` NA en
TODAS sus filas; todos son solo-históricos (máximo año 2018; ninguno con año
moderno ≥2022). Legítimo: el directorio público no trae geo de establecimientos
que ya no existen.

Tratamiento (opción A): **visibles solo por el buscador de establecimiento**
(nombre/RBD), fuera de la navegación territorial. Esto es esencialmente el
comportamiento ACTUAL (el filtro territorial por `cod_com`/`cod_reg` ya no los
matchea, y `buildList` rama establecimiento ya los alcanza por nombre/RBD). Lo que
falta es solo PULIDO defensivo, no una rama nueva:
- En la ficha de un RBD geo-NA, la meta NO debe mostrar NA crudo, "undefined" ni
  vacío engañoso. Mostrar explícitamente algo como "Sin territorio asignado · solo
  registro histórico" en lugar de comuna/región. Verifica el comportamiento real
  de `comNom`/`regNom` (devuelven el `cod` crudo si no hallan match: con NA eso es
  vacío) y haz que degrade a una etiqueta legible.
- Confirmar (no asumir) que estos RBD: (a) NO aparecen como tarjetas en el Panorama
  territorial bajo ningún territorio, (b) SÍ aparecen en el buscador por nombre/RBD,
  (c) abren ficha sin romper (su serie histórica se grafica; territorio = etiqueta
  "sin territorio").
- NO crear un cubo "Sin territorio" en los selectores territoriales (eso es la
  opción B, descartada). NO excluirlos del motor (opción C, descartada).

---

## 4. Fases en orden estricto

### Fase 0 — Lectura del estado real (no modificar sin leer)
1. `git -C /Users/tomgc/Projects/slep_idps status` (debe estar limpio o con solo lo
   esperado de la sesión; si hay basura sin trackear inesperada, repórtala y sigue).
2. Verifica `md5` del parquet (regla 🔒). Si no es `4c764d8c…`, detente.
3. Lee completos: `35_generar_motor_html.R`, `35_motor_template.html`,
   `10_configuracion.R`. Identifica:
   - En el generador: el bloque `grado_anios` (~L332) y `meta` (~L344) donde
     emitir el eje contiguo.
   - En el template: `BarrasAnio` (componente de barras por año), el header
     estático "Datos 2022–2025" (~L451) y la `ficha-explain` que menciona
     "4° básico no aplica 2024" (~L932; ese comentario es FALSO con el dato actual
     y debe corregirse).

### Fase 1 — Generador: eje contiguo + meta (lógica server-side)
- En `35_generar_motor_html.R`, agrega (con constantes nombradas, sin números
  mágicos): `ANIOS_PANDEMIA <- c(2020L, 2021L)`. Construye, por grado del motor,
  el eje contiguo `seq(min(anio_con_dato), max(anio_con_dato))` y clasifica cada
  año en `con_dato` / `pandemia` / `no_eval` según la regla D-s12-EJE. Emite en
  `meta` una estructura nueva (p. ej. `meta$eje_historico` = por grado, lista de
  `{agno, estado, preliminar}`), SIN romper `grado_anios` ni `anios_preliminar`
  (que el resto del template ya consume). Mantén el contrato JSON existente:
  agregas, no quitas.
- El header dinámico: emite en `meta` la cobertura real de años (p. ej.
  `meta$cobertura_anios` = min/max global del motor) para que el template arme el
  texto del header desde el dato, en vez del literal "2022–2025".
- Commit atómico: `feat(motor): eje historico contiguo con estados de año en meta`.

### Fase 2 — Template: consumir el eje + header dinámico + pulido geo-NA
- `BarrasAnio` (y donde se liste el eje): consumir `meta$eje_historico` del grado.
  Para cada año: `con_dato` → barra (atenuada si preliminar); `pandemia`/`no_eval`
  → columna gris desactivada con su tooltip respectivo (mismo gris, distinto texto).
  Mantener el "hueco sin barra" para EE sin fila en un año `con_dato`.
- Header: reemplazar el literal "Datos 2022–2025" por el texto armado desde
  `meta$cobertura_anios`. Corregir/eliminar el comentario "4° básico no aplica
  2024" en `ficha-explain` (es falso: 4b sí tiene 2024).
- Pulido geo-NA (D-s12-GEONA): que `comNom`/`regNom` (o el punto donde se arma la
  meta de la ficha) degraden a "Sin territorio asignado · solo registro histórico"
  cuando no hay comuna/región, sin NA crudo ni "undefined".
- Estilos: si hace falta un estado visual para la columna desactivada, reusar
  tokens existentes (`--gris`, `--linea`, `.ybar-empty` como base); NO introducir
  colores nuevos fuera de la paleta. El gris desactivado es de ESTADO, no de la
  paleta de 4 indicadores (que queda intacta).
- Commits atómicos separados por tema: `feat(motor): render de años desactivados
  (pandemia/no_eval) en vista historica`; `fix(motor): header dinamico de cobertura
  y correccion nota 4b2024`; `fix(motor): ficha de RBD sin territorio degrada a
  etiqueta legible`.

### Fase 3 — Regenerar y desplegar
- Regenera el motor: `source(.../35_generar_motor_html.R)`. Verifica que termina
  sin error y que el resumen reporta los 4b2024 y los años históricos.
- Copia `40_salidas/motor_idps.html` → `docs/index.html`.
- Commit atómico: `build(motor): regenerar y desplegar serie 2014-2025`.

### Fase 4 — Verificación en vivo (criterio de éxito, sección 5)
- Abre el `docs/index.html` regenerado en navegador (o decodifica su JSON como en
  P1) y comprueba el criterio de éxito. Verifica en VIVO, no por inferencia.

---

## 5. Criterios de éxito verificables (B.4)

1. **4b2024 presente:** la ficha de un EE de 4b con dato 2024 muestra su barra 2024
   (antes faltaba). Decodificando el JSON del nuevo `docs/index.html`: bloque `ind`
   contiene grado 4b, agno 2024 (las 28.740 filas / 7.185 RBD del parquet).
2. **Eje contiguo:** una ficha de EE con serie larga (4b o 2m) muestra el eje
   2014…2025 contiguo; 2019, 2020, 2021 aparecen como columnas grises desactivadas
   (no omitidas, no barras), con tooltip: 2019 "este grado no se evaluó este año",
   2020-2021 "sin evaluación (pandemia)". 2018 y 2022 NO quedan pegados.
3. **Dimensión solo 2018 en el histórico:** el drill-down de dimensión muestra el
   punto 2018 y nada en 2014-2017 ni 2019-2021 (NA), conectando con 2022+.
4. **Sin significancia/GSE inventados:** en años 2014-2018 las anclas de
   significancia degradan a "sin dato"/"sin cambios"; el GSE no aparece donde no
   existe. Nada fabricado.
5. **Header dinámico:** el header refleja la cobertura real (incluye 2014), no
   "2022–2025". El comentario "4b no aplica 2024" ya no está.
6. **Geo-NA:** un RBD solo-histórico sin geo (a) no aparece como tarjeta en ningún
   territorio del Panorama territorial, (b) aparece en el buscador por nombre/RBD,
   (c) abre ficha sin romper, mostrando "Sin territorio asignado" en vez de NA.
7. **Parquet intacto:** `md5` final == `4c764d8c9f0bf70004f8aa52661ae901`.
8. **Render sin errores de consola** en las tres pantallas (territorial, ficha,
   comparar); filtros, hovers y selección operativos.

---

## 6. Auto-auditoría (panel adversarial — hay render de dato e invariantes)

Antes de reportar "listo", lanza un panel adversarial de SOLO LECTURA que
**re-derive con código independiente** (no reuses las funciones del generador):

- **Cobertura del JSON desplegado:** decodifica el `docs/index.html` final (como en
  P1: el dato es `atob(variable)`, usa el escaneo de base64 largos) y reconstruye,
  por grado y familia, los años presentes. Contrasta contra el parquet leído por
  separado: deben coincidir (mismo conjunto de años, mismo conteo de filas 4b2024).
- **Clasificación del eje:** verifica independientemente que, para 4b y 2m, el eje
  emitido marca 2020/2021 como `pandemia`, 2019 como `no_eval`, y el resto
  `con_dato`; que ningún año fuera de 2020-2021 quedó rotulado "pandemia".
- **Geo-NA:** re-cuenta desde el parquet los RBD del motor con comuna NA en todas
  sus filas (debe dar 356, todos max año ≤2018) y confirma que el motor los trata
  por la rama buscador, no territorial.
- **Invariante parquet:** `md5` inicio == fin.

Si el panel detecta una discrepancia de dato (no estética), detente y repórtala;
no la "arregles" silenciosamente.

---

## 7. Log y cierre

- Escribe el log en
  `/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/YYYYMMDD_motor_historico_log.md`
  con la plantilla fija (resumen, inventario de commits por fase, cada cambio
  sustantivo con causa, auditoría del panel adversarial con veredicto, bugs si los
  hubo, verificación de cada 🔒 con PASA/FALLA y evidencia, pendientes/`# REVISAR`,
  md5 inicio/fin del parquet, notas para el revisor). Honesto: incluye lo que costó.
- **NO actualices `CLAUDE.md` "últimos cambios"** (es paso de cierre de sesión, no
  de este encargo — 🔒 traspaso v11).
- **Push:** tras `git status` limpio, pushea todo lo de este encargo en bloque
  (A38: versionado Y pusheado). El log puede ir como `docs()` atómico aparte o
  quedar sin commitear para revisión; tú decides, pero déjalo escrito.
- **Reporta** al volver: resumen de fases, hashes de commits, veredicto del panel
  adversarial, y el resultado de los 8 criterios de éxito (PASA/FALLA cada uno).

---

## 8. Qué NO hacer (recordatorios)

- No tocar el parquet ni regenerarlo desde crudos (LEE el parquet existente).
- No integrar los `idps4B2024_*.xlsx` que el titular recuperó: el parquet YA los
  contiene (conteo idéntico verificado). No entran a `20_insumos/`. Ignóralos.
- No introducir colores nuevos ni alterar la paleta de 4 indicadores.
- No agregar cifras agregadas por territorio.
- No fabricar significancia, GSE ni geo donde el dato trae NA.
- No combinar cambios no relacionados en un commit; no `git add .`/`-u`.
