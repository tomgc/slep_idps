# traspaso_cierre_v12.md

> Documento de cierre de sesion. Unico puente entre sesiones: todo lo que no
> quede aqui se pierde. Generado al cierre de la sesion 12 de `slep_idps`.
>
> **Registro de ejecucion detallado:** tres logs de Claude Code en
> `50_documentacion/andamios/logs/` (ver seccion 4); el paso a paso no se reproduce
> aqui.

---

## 1. Identificacion

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, todo
  Chile; Rama A publica, datos versionados en el repo).
- **Version de traspaso:** v12.
- **Fecha:** 2026-06-22.
- **Sesion:** 12. **Foco:** P-MOTOR (el bloqueante de v11) — llevar la serie
  historica 2014→2025, ya verificada en el parquet, AL MOTOR desplegado; mas su
  verificacion de cierre (P-DISPLAY-FIDELITY) e higiene de presentacion (fix
  fantasma rbd=NA). **Resultado:** el sitio publico muestra la serie completa,
  certificada fiel al parquet en el universo entero, listo para validacion tecnica
  externa.
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`). Ejecucion via Claude Code autonomo (protocolo
  `encargo_autonomo_claude_code_v1.md`).
- **Archivos principales modificados:** `30_procesamiento/35_generar_motor_html.R`
  (eje historico server-side, fix H6 dependencia-NA, dedup de establecimientos,
  filtro fantasma rbd=NA); `30_procesamiento/35_motor_template.html` (consumo del
  eje contiguo, header dinamico, pulido geo-NA); `docs/index.html` +
  `40_salidas/motor_idps.html` (regenerados y desplegados). **El parquet NO se
  toco** (md5 intacto en toda la sesion).

---

## 2. Resumen ejecutivo

La sesion 12 cerro el bloqueante P-MOTOR de v11: el sitio mostraba solo 2022-2025 y
ahora muestra la serie historica completa 2014→2025, leida del parquet blindado sin
tocarlo. El diagnostico de partida (decodificar el build desplegado) confirmo que el
build precedia tanto a 4b2024 como al historico. Un hallazgo central reordeno el
alcance: el render de vista historica YA estaba construido en el template
(`BarrasAnio`, `serieFull`, toggle); el eje no estaba hardcodeado, se derivaba de
`grado_anios`. Por tanto el trabajo real fue (a) construir en R el eje contiguo
2014→2025 con estados por año (con_dato / pandemia / no_eval), (b) que el template lo
consuma con años desactivados en gris y header dinamico, (c) pulido de RBD sin geo.
Dos supuestos del asistente cayeron contra el dato y se corrigieron sin inventar: el
"4° basico no aplica 2024" (falso: 4b2024 esta en el parquet, 28.740 filas) y el
"356 RBD geo-NA visibles solo por buscador" (el directorio publico cubre la geo de
803 de 804 solo-historicos). Durante la regeneracion surgieron dos bugs del
generador que el historico destapo (H6 dependencia-NA abortaba el build; 20
establecimientos duplicados por variacion de atributos historico/moderno), ambos
corregidos. La verificacion de cierre (P-DISPLAY-FIDELITY) elevo el spot-check de 47
anclas a reconciliacion CENSAL: ~2,9 millones de comparaciones cifra-a-cifra
parquet→sitio, 0 discrepancias, con decode triple independiente y panel adversarial.
Dos hallazgos de PRESENTACION (no de cifra) quedaron registrados: el fantasma
rbd=null (corregido en un fix posterior) y la etiqueta Dependencia del directorio
vigente (por diseño H6, pendiente-titular). Todo versionado y pusheado; Pages sirve
el motor certificado.

---

## 3. Estado al cierre

### Que funciona
- **Motor desplegado con la serie 2014→2025.** El sitio
  `https://tomgc.github.io/slep_idps/` muestra: eje contiguo 2014→2025; 2019
  (no_eval, gris), 2020-2021 (pandemia, gris) desactivados con tooltips distintos;
  4b2024 visible; dimension solo 2018 en el historico; header dinamico "Datos
  2014–2025"; sin significancia/GSE inventados; un establecimiento por RBD.
- **Fidelidad parquet→sitio CERTIFICADA a nivel censo.** ~2,9M comparaciones de
  cifra, 0 discrepancias; las tres familias (ind/dim/niv) + cifras de comparacion
  (`dif/sigdif/difgru/sigdifgru`, sin redondeo) byte-identicas. La cadena
  crudo→parquet→sitio es trazable e identica (bajo redondeo a 1 decimal).
- **Dato (parquet `idps_largo.parquet`, md5 `4c764d8c…`):** intacto, verificado a
  nivel censo desde s11. LEIDO esta sesion, no modificado.
- **Pipeline de cero:** sin cambios al flujo de dato (solo `35` de presentacion).

### Que falta / pendientes vivos (no bloqueantes para la presentacion)
- **H-FID-2 (etiqueta Dependencia):** el sitio pinta la dependencia del directorio
  vigente (un EE traspasado figura SLEP aunque fuera Municipal en la era IDPS). Es
  etiqueta de presentacion por diseño H6; **ninguna cifra IDPS cambia**. 515 RBD
  afectados (192 reclasificados Municipal/PS→SLEP + 323 con NA rellenada). Decision
  de etiqueta, pendiente-titular. Explicable en una oracion ante validacion externa.
- **P-DOC:** documentacion via `suitedoc` (protocolo 4.6) + doc minima de politica
  10, al llegar a piso solido.
- **P-INVENTARIOS:** los dos `inventario_*.parquet` siguen sin clasificar.
- **P-HIGIENE-CASE:** desajuste de case git/disco en `20_insumos/` (heredado).

### Delta respecto a v11
- P-MOTOR: de bloqueante abierto a CERRADO y desplegado.
- P-DISPLAY-FIDELITY: de pendiente a CERRADO (PASA, censal).
- +3 bugs corregidos en el generador (H6, dedup, fantasma), todos por el historico.
- +1 hallazgo nuevo de presentacion (H-FID-2 Dependencia), pendiente-titular.
- Dos supuestos del asistente corregidos contra el dato (4b2024, geo-NA).

---

## 4. Registro detallado de cambios (sesion 12)

> Logs de Claude Code: `andamios/logs/20260621_motor_historico_log.md`,
> `20260621_display_fidelity_log.md`, `20260621_fix_fantasma_rbdNA_log.md`.

**C1 — Diagnostico del build desplegado (P1, solo lectura)** [verificacion]. Decode
del `docs/index.html` desplegado (dato en `atob(variable)`; escaneo de base64
largos). Confirmo: build cubria solo 2022-2025; 4b sin 2024 en las tres familias;
0 años ≤2019. Fijo la linea base. Sin cambios al repo.

**C2 — Eje historico contiguo en el generador (P2, server-side)** [funcionalidad].
`35_generar_motor_html.R`: constante `ANIOS_PANDEMIA <- c(2020L,2021L)`; por grado,
eje contiguo `seq(min,max)` con clasificacion por año (con_dato / pandemia /
no_eval); emitido en `meta$eje_historico` + `meta$cobertura_anios`, sin romper
`grado_anios`/`anios_preliminar` (se agrega, no se quita). Decision A: la logica del
eje vive en R, el template solo pinta. Commit `c5f73f0`.

**C3 — Template: consumo del eje + header dinamico + pulido geo-NA** [funcionalidad].
`35_motor_template.html`: `serieEje` consume `meta$eje_historico`; `BarrasAnio`
pinta años desactivados (gris, tooltip pandemia vs no_eval); header dinamico via
`span#cob-anios` seteado desde `DATA.meta.cobertura_anios`; correccion de la nota
falsa "4° basico no aplica 2024"; `comNom`/`regNom`/`terrFicha` degradan a "Sin
territorio asignado · solo registro historico" sin NA crudo. Commit `af1766c`.

**C4 — Fix H6: tolerar dependencia NA en RBD solo-historicos** [bug]. La
regeneracion abortaba (`stopifnot` H6) porque los solo-historicos no traen
`cod_depe2` ni en el directorio (no listan EE cerrados) ni en el crudo 2014-2016.
Relajado: reporta el NA legitimo (degrada a "—"), aborta solo si un RBD MODERNO
perdiera dependencia (eso si seria bug real). Commit `cae06c8`.

**C5 — Fix dedup: un establecimiento por RBD** [bug]. El panel adversarial de
P-MOTOR destapo 20 RBD que renderizaban tarjeta DOBLE: con el historico, un RBD
trae atributos IDPS distintos entre filas historico/moderno, y el `distinct(rbd,
nom, geo…)` producia 2 filas que tras el coalesce con el directorio quedaban
identicas. Fix: `est_attr` toma una fila por RBD (la mas reciente). Establecimientos
9157→9137. Commit `fefb79a`.

**C6 — Regenerar y desplegar la serie historica** [build/deploy]. `source(35)`;
copia a `docs/index.html`. Verificado en vivo en navegador (8/8 criterios) + panel
adversarial (2/2). Commits `3be1caf` (build) y `99597d8` (log motor). Push
`7e1374b..99597d8`. Deploy confirmado por md5 live==local (la API de Pages iba
rezagada; se verifico el contenido servido, no el estado reportado).

**C7 — P-DISPLAY-FIDELITY: verificacion de cierre del motor (solo lectura)**
[verificacion]. Spot-check 47 anclas (3 familias, año historico entero y con cola
decimal, 4b2024, dim-2018, RBD ex-duplicado) → 47/47 PASA. Elevado a reconciliacion
CENSAL: ind 366.388 + dim 557.898 + niv 662.514×3 ≈ 2,9M celdas, 0 mismatch; mas
`dif/sigdif/difgru/sigdifgru` (sin redondeo) identicas. Decode triple independiente
(R `memDecompress`, node `zlib.unzipSync`, 2 subagentes a ciegas) + panel esceptico.
0 empates `.5` exactos IEEE-754 (round-half-even nunca diverge). Log
`20260621_display_fidelity_log.md`. Commit `e1e582c`, push `99597d8..e1e582c`.

**C8 — Fix fantasma rbd=NA (H-FID-1)** [bug/higiene]. El spot-check detecto que las
4 filas `rbd=NA` del crudo (4b/2017) colapsaban en 1 establecimiento fantasma
alcanzable por el buscador escribiendo "null". Filtro `!is.na(rbd)` en el generador
(Bloque 1, tras `GRADOS_MOTOR`), con `message()` de transparencia; el parquet NO se
toca (se filtra al serializar). Establecimientos 9137→9136; ind 366.388→366.384 (−4);
RBD reales intactos (control RBD 10 = 83/78/87/74). Regenerado, desplegado, verificado
(5/5 PASA, deploy live==local). Commits `365667b` (codigo), `69ad902` (build),
`5c33da4` (log). Log `20260621_fix_fantasma_rbdNA_log.md`.

**C9 — Cierre** [docs/deploy]. Escaner ejecutado (`estructura_actual.md`, 215
archivos); este v12; push de cierre.

---

## 5. Backlog acumulativo

> Se copia integro de v11 y se agregan las entradas nuevas al final (numeracion
> global y permanente; el detalle vive en el backlog del proyecto, aqui el delta).

- **Objetivo del proyecto** (permanente): motor de visualizacion de los IDPS de la
  Agencia de Calidad, nacional, por establecimiento, sin agregacion territorial;
  React 18 + D3 v7 inline en GitHub Pages; para directivos y comunidad del SLEP
  Costa Central y de todo Chile; desde 2026.
- **Nota metodologica** (permanente): "cambio" = una solicitud distinguible del
  titular; bugfixes reportados por el titular cuentan; errores del asistente
  corregidos de inmediato no.

**Delta del backlog v12:** la sesion produjo cambios de PRODUCTO (motor) por primera
vez en varias sesiones. Entradas nuevas, por intencion primaria:
- **Funcionalidad/motor (C2, C3, C6):** serie historica en el motor — eje contiguo
  server-side, render de años desactivados, header dinamico, pulido geo-NA, deploy.
  Cuenta como 1 solicitud distinguible del titular (P-MOTOR), implementada en varias
  piezas tecnicas.
- **Bugfix (C4, C5, C8):** tres bugs del generador destapados por el historico (H6
  dependencia-NA, dedup de establecimientos, fantasma rbd=NA). Reportados/derivados
  durante la ejecucion; cuentan.
- **Verificacion (C1, C7):** diagnostico del build + auditoria de fidelidad censal.
- Sin reclasificaciones de taxonomia. El conteo acumulado se actualiza en la proxima
  apertura (A22: verificar contra el detalle cronologico, no heredar tablas).

---

## 6. Bugs y hallazgos de la sesion

**H-s12-1 (H6 dependencia-NA) — RESUELTO.** Sintoma: `source(35)` abortaba en
`stopifnot` ("RBD del motor sin dependencia resuelta"). Causa raiz: los RBD
solo-historicos no traen `cod_depe2` (ni directorio ni crudo 2014-2016); el check
era correcto cuando el universo era solo-moderno, demasiado estricto con el
historico. Solucion: reportar el NA legitimo, abortar solo si un RBD moderno pierde
dependencia. Regla aprendida: **un check de integridad calibrado para un universo se
vuelve falso-positivo al ampliarlo; revisar las precondiciones de los `stopifnot` al
sumar datos de otra epoca.** Principio: C.8 (validacion que distingue NA legitimo de
error). Commit `cae06c8`.

**H-s12-2 (dedup de establecimientos) — RESUELTO.** Sintoma: 20 RBD renderizaban
tarjeta doble. Causa raiz: con el historico, un RBD trae atributos IDPS distintos
entre epocas; `distinct(rbd, nom, geo…)` daba 2 filas que tras coalesce quedaban
identicas. Lo cazó el PANEL ADVERSARIAL, no la verificacion inline. Solucion:
`est_attr` = una fila por RBD (la mas reciente). Regla aprendida: **el roster del
motor se construye por RBD, no por (RBD × variante de atributos); al sumar epocas,
deduplicar explicitamente por la llave de presentacion.** Principio: A11-3 (el panel
con codigo independiente caza lo que la verificacion de produccion no ve). Commit
`fefb79a`.

**H-FID-1 (fantasma rbd=NA) — RESUELTO.** Sintoma: una tarjeta "RBD null" alcanzable
por el buscador. Causa raiz: 4 filas `rbd=NA` en el crudo 4b/2017 colapsaban en 1
establecimiento sin nombre/geo. Solucion: filtro `!is.na(rbd)` al serializar (parquet
intacto). Regla aprendida: **el dato crudo puede traer llaves nulas legitimas; el
generador debe filtrarlas explicitamente antes de construir el universo navegable.**
Commit `365667b`.

**H-FID-2 (etiqueta Dependencia) — DOCUMENTADO, pendiente-titular.** El sitio pinta
`cod_depe2` del directorio vigente (homologado), no de `idps_largo.cod_depe2`. 515
RBD donde la etiqueta difiere: 192 reclasificacion genuina (Municipal/PS→SLEP por
traspaso) + 323 NA rellenada por el directorio. Es etiqueta/filtro por diseño H6,
**ninguna cifra IDPS cambia**. No dispara detencion (no es cifra). Se ancla en el log
de fidelidad para que la validacion externa no lo lea como discrepancia. Decision de
etiqueta pendiente del titular.

**Dos supuestos del asistente corregidos contra el dato (meta-aprendizaje):**
- El "4° basico no aplica 2024" venia de un comentario del template; el dato lo
  desmiente (4b2024 = 28.740 filas en el parquet). El comentario describia el build
  viejo, no el dato.
- El "356 RBD geo-NA visibles solo por buscador" no se materializo: el directorio
  publico cubre la geo de 803 de 804 solo-historicos (los hace navegables
  territorialmente). Solo 1 quedaba sin geo, y era el fantasma rbd=NA.
- Principio: **A11-1 / B.1 — caracterizar el fenomeno DESDE el dato, no desde un
  comentario o un supuesto heredado; verificar antes de construir encima.**

---

## 7. Aprendizajes y restricciones descubiertas

- **A12-1 (el render puede preceder al dato).** El motor ya tenia la maquinaria de
  vista historica construida; lo que faltaba era regenerar desde el parquet con el
  historico. "Falta en el sitio" no implica "falta el codigo": puede ser solo un
  build viejo. Verificar el estado real del artefacto antes de estimar el trabajo.
  Principio: B.1.
- **A12-2 (un supuesto no verificado contamina el diseño).** Dos decisiones de eje y
  geo se plantearon mal por supuestos no contrastados con el dato (4b2024, geo-NA).
  El dato los corrigio. Antes de fijar una decision de diseño que depende de una
  propiedad del dato, CONSULTAR el dato. Principio: B.1 + A11-1.
- **A12-3 (el panel adversarial gana su costo).** El dedup (20 tarjetas dobles) y la
  exactitud del redondeo (0 empates `.5` IEEE-754) los confirmo el panel con codigo
  independiente, no la verificacion inline. El panel no es ceremonia: caza lo que la
  ruta de produccion no ve. Principio: A11-3 / A21.
- **A12-4 (verificacion censal sobre el artefacto publico).** La fidelidad
  parquet→sitio se cerro por censo (~2,9M celdas), no por muestra, sobre el HTML
  DESPLEGADO (no el intermedio). Para validacion externa, la prueba es sobre lo que
  el publico ve. Principio: A11-1 + A11-2.
- **A12-5 (formato del dato embebido: stream zlib, no gzip).** El JSON del motor va
  como `memCompress(type="gzip")` que produce stream **zlib** (`0x78 9c`), no gzip
  (`0x1f8b`). `pako.inflate`/`memDecompress`/`node:unzipSync` lo auto-detectan;
  `node:gunzipSync` (estricto) falla. Relevante para futuras verificaciones del
  build. Render = `toLocaleString("es-CL", {maximumFractionDigits:1})`: presentacional,
  no altera el valor.

---

## 8. Decisiones de diseno

- **D-s12-EJE (eje historico contiguo, en R).** El eje de años es el rango contiguo
  2014→2025 por grado, con cada año clasificado con_dato / pandemia / no_eval.
  Pandemia (2020-2021) y no_eval (2019 para 4b/2m) comparten el gris desactivado;
  difieren solo en el tooltip (pandemia vs "este grado no se evaluo este año"). NO un
  tercer color. La logica vive en el generador R (emitida en `meta$eje_historico`),
  no en el JS. Alternativas: (B) logica en el template — descartada (fragmenta la
  regla temporal); (C') solo 2020-2021 grises, 2019 como hueco — descartada (deja
  2019 indistinguible de EE-sin-dato). Justificacion: la causa del vacio importa para
  una lectura honesta; mismo tratamiento visual de "año del sistema sin dato",
  motivos distintos en el rotulo.
- **D-s12-GEONA (RBD sin geo, opcion A).** Los solo-historicos sin geo son visibles
  solo por buscador, fuera de la navegacion territorial (comportamiento esencialmente
  ya vigente). Pulido: ficha degrada a "Sin territorio asignado". Resulto casi vacuo
  (el directorio cubre 803/804); util como defensa. Alternativas B (cubo "Sin
  territorio" en selectores) y C (excluir) descartadas.
- **D-s12-FANTASMA (filtrar rbd=NA al serializar).** El fantasma se filtra en el
  generador, no en el parquet (🔒). Una llave nula del crudo no debe entrar al
  universo navegable.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | Sin cambio (LEIDO, no tocado). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| `ANIOS_PANDEMIA` | `c(2020L, 2021L)` | `35_generar_motor_html.R` | Nuevo (s12). Eje: gris desactivado. |
| Eje motor 4b/2m | 2014→2025 contiguo | `meta$eje_historico` | con_dato (9 años) + 2019 no_eval + 2020-21 pandemia. |
| Establecimientos (motor) | 9136 | JSON desplegado | 9136 reales (fantasma rbd=NA filtrado en s12). |
| Filas array `ind` (motor) | 366.384 | JSON desplegado | Tras filtrar 4 filas fantasma. |
| `GRADOS_MOTOR` | 4b, 2m | `10_configuracion.R` | Sin cambio. |
| md5 build desplegado | `0b7b0b08420a2af985cb92714fc72e42` | `docs/index.html` == `motor_idps.html` | Build final s12 (post-fantasma). |
| `TOL` (fidelidad) | `1e-9` | encargo/verificar | Sobre base redondeada a 1 decimal. |

---

## 10. Arquitectura de archivos

Estructura conforme a la politica. Cambios de s12: `35_generar_motor_html.R` y
`35_motor_template.html` extendidos; `docs/index.html` + `motor_idps.html`
regenerados (6.23M, antes 4.66M — la serie historica). Tres logs nuevos en
`andamios/logs/` (motor_historico, display_fidelity, fix_fantasma_rbdNA) + tres
encargos en `activa/` (motor_historico, display_fidelity, fix_fantasma). Escaner al
cierre: `50_documentacion/estructura/estructura_actual.md` (215 archivos).
**Untracked deliberado:** `inventario_historico_idps.parquet` y
`inventario_universo_idps.parquet` (P-INVENTARIOS, sin clasificar).

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**H-FID-2 — Etiqueta Dependencia del directorio vigente (decision de etiqueta).**
- **Descripcion:** 515 RBD donde la etiqueta Dependencia pintada ≠ `cod_depe2` del
  parquet (192 reclasificados Municipal/PS→SLEP por traspaso; 323 NA rellenada). Por
  diseño H6 (el generador toma dependencia del directorio vigente).
- **Tipo:** decision de etiqueta/presentacion (no cifra). **Complejidad:** Baja
  (decision) / Media (si se implementa distincion era-IDPS vs vigente).
- **Impacto:** un validador externo podria leerlo como inconsistencia; ya hay
  explicacion de una oracion (vigencia del directorio, ninguna cifra cambia).
- **Sugerencia:** decidir si se mantiene (vigente, defendible) o se distingue la
  dependencia de la era IDPS. Pendiente del titular.

**P-DOC — Documentacion via `suitedoc` + doc minima.**
- Al estar el motor en piso solido, generar la suite (protocolo 4.6) y la doc minima
  de politica 10 (README, `documentacion_tecnica`, `gobernanza_datos`). Definir si
  "todas las paginas" incluye publicar la metodologia en Pages (hoy `docs/` solo el
  motor). Tipo BIBLIOTECA (produce `documentar.R`).

**P-INVENTARIOS — Clasificar `inventario_*.parquet`.**
- Versionar si `run_all()` los regenera y se quieren trazables; gitignorear si son
  scratch de los encargos one-off. Decidir con el codigo a la vista.

**P-HIGIENE-CASE — Desajuste de case git/disco en `20_insumos/`** (heredado v10/v11).
- Archivos trackeados en mayuscula, minuscula en disco (macOS case-insensitive).
  Podria morder en clon case-sensitive o CI. Baja complejidad; `git mv` con
  renombrado intermedio.

### Evaluacion de deuda tecnica
- **Generador `35`:** acumulo varios checks calibrados para el universo moderno que
  el historico volvio falso-positivos (H6 fue uno). Antes de sumar mas datos de otra
  epoca (p. ej. 6b/8b a la UI, si alguna vez), revisar las precondiciones de los
  `stopifnot`. Zona fragil: las uniones con el directorio (coalesce de geo y
  dependencia) tienen supuestos de cobertura que el historico tensó.
- **Reproduccion del build:** documentado que el stream es zlib (no gzip) y el render
  es presentacional; futuras verificaciones deben usar `unzipSync`/`memDecompress`.

### Auditoria de cierre (politica 5.6)
- Pipeline corre de cero sin intervencion: **Si** (sin cambios al flujo de dato).
- Outputs reproducibles/idempotentes: **Si** (el generador es determinista; md5 build
  estable).
- Decisiones metodologicas como constantes nombradas: **Si** (`ANIOS_PANDEMIA`,
  `TOL`, eje en `meta`).
- Nombres sin tildes/ñ/espacios: **Parcial** (P-HIGIENE-CASE + tildes en crudos de la
  Agencia, excepcion declarada).
- Cifras publicadas verificadas: **Si** — crudo→parquet (censo s11) Y parquet→sitio
  (censo s12). Cadena completa cerrada.

### Ruta sugerida para la sesion 13
1. **Apertura CONTINUATION** con este v12 + escaner + protocolo de la KB.
2. **Decidir H-FID-2** (etiqueta Dependencia): mantener vigente o distinguir era
   IDPS. Es lo unico con cara externa pendiente.
3. **P-DOC** (sesion BIBLIOTECA dedicada): suite `suitedoc` + doc minima; definir si
   se publica metodologia en Pages.
4. **P-INVENTARIOS y P-HIGIENE-CASE:** higiene de baja complejidad, agrupables en una
   sesion corta o al inicio de otra.
- **Diferir:** nada urgente. El producto esta certificado y desplegado.
- **No reabrir el dato** (blindado, censado dos veces).

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 El dato esta verificado a nivel CENSO (s11) y la fidelidad parquet→sitio tambien
  (s12). NO re-auditar ni regenerar el parquet.
- 🔒 El motor desplegado es el certificado (build md5 `0b7b0b08…`). Cualquier cambio
  de `35` exige REGENERAR y RE-VERIFICAR fidelidad antes de desplegar (no desplegar a
  ciegas).
- 🔒 El eje historico, el filtro fantasma y la dependencia-del-directorio son
  decisiones tomadas (D-s12-*, H6); no revertirlas sin decision explicita del titular.
- ⚠️ NO inventar significancia/GSE/geo donde el dato trae NA (sigue vigente de v11).
- ⚠️ H-FID-2 (Dependencia) es etiqueta por diseño, NO bug de cifra. Si surge en
  validacion externa: "el motor muestra la dependencia vigente del directorio; ninguna
  cifra IDPS cambia".
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atomicos por ruta;
  nunca `git add .`/`-u`.
- ✅ Para verificar el build: el stream es zlib (`unzipSync`/`memDecompress`, no
  `gunzipSync`); los arrays del JSON estan en top-level (`obj.ind`, no `DATA.ind`).
- 🔒 Actualizar `CLAUDE.md` "ultimos cambios" es paso de CIERRE; corresponde hacerlo
  como parte de este cierre si no se hizo (ver nota de cierre).

---

## 13. Fragmentos de codigo de referencia

**Eje historico contiguo (la forma correcta, server-side en R):**
```r
ANIOS_PANDEMIA <- c(2020L, 2021L)
# por grado: rango contiguo del primer al ultimo año con dato
anios_con_dato <- sort(unique(serie_grado$agno))
eje <- seq(min(anios_con_dato), max(anios_con_dato))
estado <- dplyr::case_when(
  eje %in% anios_con_dato            ~ "con_dato",
  eje %in% ANIOS_PANDEMIA            ~ "pandemia",
  TRUE                              ~ "no_eval"   # año del rango sin dato, no pandemia
)
# emitido en meta$eje_historico[[grado]] = data.frame(agno = eje, estado, preliminar)
# el template SOLO consume y pinta; pandemia y no_eval comparten gris, distinto tooltip.
```

**Filtro del fantasma (Bloque 1 del generador, tras GRADOS_MOTOR):**
```r
n_fantasma <- sum(is.na(P$rbd))
P <- dplyr::filter(P, !is.na(.data$rbd))   # H-FID-1: 4 filas rbd=NA del crudo 4b/2017
if (n_fantasma > 0) message(sprintf("    [H-FID-1] descartadas %d fila(s) rbd=NA; parquet intacto.", n_fantasma))
```

**Decode del build para verificar (stream zlib, no gzip):**
```r
html <- readLines(here::here("docs", "index.html"), warn = FALSE) |> paste(collapse = "\n")
b64  <- sub('.*atob\\("([A-Za-z0-9+/=]+)".*', "\\1", html)   # el base64 de datos
json <- memDecompress(base64enc::base64decode(b64), type = "gzip") |> rawToChar()
obj  <- jsonlite::fromJSON(json, simplifyVector = FALSE)       # arrays en obj$ind / obj$dim / obj$niv
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesion 13 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (politica +
  SETTINGS) vive en la knowledge base y se lee desde ahi. Adjunto el traspaso v12 y
  el escaner actual. El motor con la serie 2014→2025 esta desplegado y certificado
  (fidelidad parquet→sitio censal, s12); el parquet esta blindado. Foco propuesto:
  decidir H-FID-2 (etiqueta Dependencia) y/o P-DOC (documentacion). Sin trabajo de
  dato ni de motor pendiente y bloqueante."
- **Documentos para la sesion 13, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que este
     al dia): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales segun el foco:* `CLAUDE.md` (si se corre en Claude Code);
     `encargo_autonomo_claude_code_v1.md` (si hay encargo); `SETTINGS` 4.6 +
     `idps_corpus_conceptual.md` si el foco es P-DOC (`suitedoc`); `35_generar_motor_html.R`
     + `35_motor_template.html` solo si se decide tocar la dependencia (H-FID-2).
  3. *Especificos de la sesion (SI se adjuntan):* `traspaso_cierre_v12.md`;
     `estructura_actual.md`. El parquet se lee del repo, no se adjunta. Los logs de
     s12 quedan referenciados como evidencia, no se adjuntan salvo necesidad.
- **Nota final:** si `35_generar_motor_html.R` o `35_motor_template.html` cambian
  entre sesiones, adjuntar la version mas reciente y avisarlo en la apertura.
