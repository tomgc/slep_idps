# traspaso_cierre_v13.md

> Documento de cierre de sesion. Unico puente entre sesiones: todo lo que no
> quede aqui se pierde. Generado al cierre de la sesion 13 de `slep_idps`.

---

## 1. Identificacion

- **Proyecto:** `slep_idps` (motor IDPS, React 18 + D3 v7 inline, nacional, todo
  Chile; Rama A publica, datos versionados en el repo).
- **Version de traspaso:** v13.
- **Fecha:** 2026-06-22.
- **Sesion:** 13. **Foco:** cerrar pendientes sin cara de cifra que quedaron de
  s12 — **H-FID-2** (decision de etiqueta Dependencia) e **higiene de repo**
  (P-INVENTARIOS, P-HIGIENE-CASE). Sesion de decisiones y limpieza, sin trabajo
  de dato ni de motor. **Resultado:** H-FID-2 resuelta (opcion A); inventarios
  scratch gitignorados; 4 glosas renombradas sin tildes; un pendiente nuevo
  abierto por el titular (**P-PALETA**, fidelidad de paleta a la identidad IDPS).
- **Entorno:** R 4.5.x en Positron (macOS aarch64); repo en
  `/Users/tomgc/Projects/slep_idps`; Git + GitHub Pages (`docs/index.html` desde
  `main`). Ejecucion via Claude Code (comandos puntuales de git/escaner, no
  encargo autonomo).
- **Archivos principales modificados:** ninguno de codigo ni de dato. Cambios:
  `.gitignore` (regla nueva); `50_documentacion/activa/decisiones/20260622_decision_etiqueta_dependencia.md`
  (nuevo); 4 renames en `20_insumos/`; snapshot del escaner. **El parquet NO se
  toco** (md5 intacto); **el motor NO se regenero** (build certificado intacto).

---

## 2. Resumen ejecutivo

La sesion 13 cerro los pendientes sin cara de cifra heredados de s12, sin tocar
dato ni motor. H-FID-2 (la etiqueta Dependencia pinta la dependencia vigente del
directorio, no la de la era IDPS) se resolvio con la **opcion A**: se mantiene la
dependencia vigente, decision documentada en archivo propio con su frase canonica
de respuesta ante validacion externa. P-INVENTARIOS se cerro tras confirmar por
grep que ningun script del flujo (`00_build.R`, `30_procesamiento/`,
`reorganizar_universo_idps.R`) genera los dos `inventario_*.parquet`: son scratch
de encargos one-off, se gitignorearon por patron sin afectar los intermedios
trazables del pipeline. El pendiente que el traspaso v11/v12 llamo "P-HIGIENE-CASE"
resulto ser, al inspeccionarlo, deuda de **tildes** y no de mayuscula/minuscula:
la deteccion indice-vs-disco salio vacia (no habia desajuste de case), pero 4
glosas `.xlsx` tenian `público`/`pública` en el nombre. Se renombraron sin tildes
(politica 2), seguro porque ningun script las referencia por nombre. El titular
abrio en paralelo un pendiente nuevo, **P-PALETA**: secciones, graficos y colores
del motor que no respetan la paleta de identidad de los 4 indicadores IDPS;
referencia visual entregada (folleto Agencia), con la instruccion de extraer los
hex canonicos de la fuente del repo, no del PNG. Cuatro commits limpios; falta
push de cierre.

---

## 3. Estado al cierre

### Que funciona
- **Motor desplegado con la serie 2014→2025** (sin cambios respecto a s12):
  `https://tomgc.github.io/slep_idps/` sigue sirviendo el build certificado
  (md5 `0b7b0b08…`). Esta sesion NO regenero ni redesplego.
- **Dato (parquet `idps_largo.parquet`, md5 `4c764d8c…`):** intacto, NO leido ni
  tocado esta sesion.
- **Repo mas limpio:** sin inventarios scratch en el indice; sin tildes en nombres
  de `20_insumos/`; decision H-FID-2 trazable en `decisiones/`.

### Que falta / pendientes vivos
- **P-PALETA (NUEVO, titular):** colores del motor que no siguen la paleta de
  identidad IDPS. Bug de fidelidad visual (presentacion, no cifra). Sin abordar.
- **P-DOC:** documentacion via `suitedoc` (protocolo 4.6) + doc minima de politica
  10. Sesion BIBLIOTECA dedicada. Sin abordar.

### Delta respecto a v12
- **H-FID-2:** de pendiente-titular a CERRADO (opcion A, dependencia vigente).
- **P-INVENTARIOS:** de pendiente a CERRADO (gitignorados por patron).
- **P-HIGIENE-CASE:** de pendiente a CERRADO, RECLASIFICADO como deuda de tildes
  (no de case); 4 glosas renombradas. Ver nota de nomenclatura en seccion 6.
- **P-PALETA:** ABIERTO (nuevo, titular).

---

## 4. Registro detallado de cambios (sesion 13)

**C1 — Decision H-FID-2: mantener dependencia vigente (opcion A)** [decision/docs].
Se evaluaron 3 opciones (A vigente / B distinguir era-IDPS / C vigente + badge).
Elegida **A**: el motor es herramienta de datos IDPS, no de gobernanza; la
dependencia vigente es la lectura natural para directivos; B reconstruiria una
serie de dependencia que el dato no soporta entera (323 de 515 RBD con NA sin
fuente era-IDPS). Archivo `decisiones/20260622_decision_etiqueta_dependencia.md`
con alternativas, justificacion y frase canonica ante validacion externa.
Commit `45b5ddd`.

**C2 — Gitignorar inventarios scratch (P-INVENTARIOS)** [chore]. Verificado por
grep que ni `00_build.R`, ni `30_procesamiento/`, ni `reorganizar_universo_idps.R`
escriben `inventario_historico_idps.parquet` / `inventario_universo_idps.parquet`;
no estan trackeados; el `.gitignore` no los cubria. Conclusion: scratch one-off no
reproducible por el pipeline → no trazable → no se versiona. Regla nueva por patron
`40_salidas/intermedios/inventario_*.parquet` con comentario justificativo. Los 7
intermedios trazables (`idps_largo`, `catalogo_idps`, `censo_insumos`,
`comunas_chile`, `establecimientos_chile`, `sleps_chile`, `.gitkeep`) siguen
trackeados. Commit `36f0c48`.

**C3 — Renombrar 4 glosas sin tildes (P-HIGIENE-TILDES)** [chore]. La deteccion
indice-vs-disco confirmo que NO habia desajuste de case (el pendiente heredado
estaba mal caracterizado). La deuda real: 4 `.xlsx` con `público`/`pública` en el
nombre. Grep confirmo que ningun script los lee por nombre → rename seguro sin
editar codigo. `git mv` directo (sin paso intermedio, porque es cambio de tilde, no
de case). Renombrados:
`idps2m2023_GLOSAS_rbd_publico_final.xlsx`, `idps4b2023_GLOSAS_rbd_publico_final.xlsx`,
`idps2m2022_rbd_glosa_publica_final.xlsx`, `idps4b2022_rbd_glosa_publica_final.xlsx`.
Git los registro como `R 100%` (blob preservado). Commit `a5a2ce4`.

**C4 — Snapshot del escaner post-higiene** [docs]. `Rscript 00_escanear_proyecto.R`
(217 archivos, 27 carpetas); poda de retencion 2 aplicada; aliases actualizados.
Commit `9371156`.

---

## 5. Backlog acumulativo

> Se copia integro del backlog del proyecto y se agregan las entradas nuevas al
> final (numeracion global y permanente). Aqui el delta de s13; el conteo
> acumulado total se reconcilia contra el detalle cronologico del proyecto (A22:
> no heredar tablas), pendiente de verificar en la apertura de s14 con el backlog
> historico a la vista.

- **Objetivo del proyecto** (permanente): motor de visualizacion de los IDPS de la
  Agencia de Calidad, nacional, por establecimiento, sin agregacion territorial;
  React 18 + D3 v7 inline en GitHub Pages; para directivos y comunidad del SLEP
  Costa Central y de todo Chile; desde 2026.
- **Nota metodologica** (permanente): "cambio" = una solicitud distinguible del
  titular; bugfixes reportados por el titular cuentan; errores del asistente
  corregidos de inmediato no.

**Delta del backlog v13:** sesion de decisiones e higiene (sin producto ni dato).
Entradas nuevas, por intencion primaria:
- **Decision/gobernanza (C1):** resolucion de H-FID-2 (etiqueta Dependencia,
  opcion A). 1 solicitud distinguible del titular.
- **Higiene/chore (C2, C3, C4):** gitignore de scratch, renombrado de glosas,
  snapshot del escaner. Mantenimiento de repo; cuentan segun la nota metodologica
  si el titular los considera solicitudes distinguibles (los 3 derivan de
  pendientes heredados + instruccion de cierre).
- Sin reclasificaciones de taxonomia. **Posible categoria nueva a evaluar en s14:**
  si "higiene/chore" o "decision/gobernanza" acumulan, considerar si merecen
  categoria propia o se absorben (umbral ~2%, subdivision >25%).

---

## 6. Bugs y hallazgos de la sesion

No hubo bugs de codigo (sesion sin ejecucion de pipeline ni regeneracion). Un
hallazgo de diagnostico:

**Reclasificacion de P-HIGIENE-CASE → P-HIGIENE-TILDES.** El traspaso v11/v12
arrastraba el pendiente como "desajuste de case git/disco en `20_insumos/`". La
inspeccion (comparacion indice-vs-disco por bucle `git ls-files` + `ls`) salio
**vacia**: no habia ningun archivo con el nombre en mayuscula en el indice y
minuscula en disco (ni viceversa). La deuda real era de **tildes** (`público`/
`pública` en 4 nombres). **Regla aprendida: una etiqueta de pendiente heredada
puede nombrar mal el fenomeno; verificar el sintoma contra el filesystem real
antes de disenar la correccion (A22 aplicado a pendientes, no solo a conteos; B.1
caracterizar desde el dato). El fix correcto para "case" (git mv con renombrado
intermedio) habria sido innecesario; el fix correcto para tildes es git mv
directo.** Sin principio violado (se detecto antes de actuar).

---

## 7. Aprendizajes y restricciones descubiertas

- **A13-1 (verificar el pendiente, no solo el conteo).** A22 decia "verificar el
  backlog contra el detalle cronologico". Esta sesion extiende: tambien la
  *descripcion* de un pendiente heredado se verifica contra la realidad antes de
  actuar. "P-HIGIENE-CASE" era en verdad tildes. Principio: B.1, A22.
- **A13-2 (clasificar scratch por reproducibilidad, no por ubicacion).** Un parquet
  en `40_salidas/intermedios/` no es automaticamente trazable: lo es si un script
  del flujo lo regenera. La prueba es el grep sobre el pipeline, no la carpeta donde
  vive. Principio: politica 5.2 (reproducibilidad), A20 (filesystem ≠ indice).
- **A13-3 (decision de presentacion sin tocar codigo es legitima y barata).**
  H-FID-2 se cerro con un archivo de decision y cero cambio de `35`. No toda
  resolucion de pendiente exige implementacion; a veces la entrega es la decision
  documentada con su defensa. Principio: B.2 (simplicidad).

---

## 8. Decisiones de diseno

- **D-s13-DEPENDENCIA (H-FID-2, opcion A).** La etiqueta Dependencia del motor
  refleja la dependencia **vigente** del directorio oficial homologado, no la de la
  era IDPS. Alternativas B (distinguir era-IDPS, descartada: 323/515 RBD sin fuente
  era-IDPS, exige tocar `35` + re-verificar fidelidad) y C (vigente + badge de
  traspaso, descartada: complejidad de presentacion innecesaria para la audiencia).
  Justificacion: motor de datos IDPS, no de gobernanza; ninguna cifra cambia; la
  objecion externa se cierra en una oracion. Replicada en
  `decisiones/20260622_decision_etiqueta_dependencia.md`.
- **D-s13-INVENTARIOS (gitignore por patron).** Los `inventario_*.parquet` no
  reproducibles por el pipeline se ignoran por patron, no se archivan a mano.
  Alternativa (archivar a `_archivo/`) descartada: el patron es defensa permanente
  contra re-aparicion sin depender de la memoria del titular.

---

## 9. Constantes y parametros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 `idps_largo.parquet` | `4c764d8c9f0bf70004f8aa52661ae901` | parquet | Sin cambio (NO leido en s13). |
| Filas del parquet | 2.362.447 | parquet | Sin cambio. |
| md5 build desplegado | `0b7b0b08420a2af985cb92714fc72e42` | `docs/index.html` == `motor_idps.html` | Sin cambio (NO regenerado en s13). |
| Establecimientos (motor) | 9136 | JSON desplegado | Sin cambio. |
| Regla gitignore nueva | `40_salidas/intermedios/inventario_*.parquet` | `.gitignore` | Nueva (s13). |

---

## 10. Arquitectura de archivos

Estructura conforme a la politica. Cambios de s13: `.gitignore` (regla nueva);
1 archivo de decision nuevo en `activa/decisiones/`; 4 renames en `20_insumos/`
(sin tildes); snapshot del escaner `20260622_074045` con poda de retencion 2.
Escaner al cierre: `50_documentacion/estructura/estructura_actual.md` (217
archivos, 27 carpetas). Sin cambios en codigo, dato ni build.

**Deuda de higiene aun en pie (no abordada, baja prioridad):** scripts
`verificar_*.R` (8) en la raiz del repo. Estan cubiertos por `.gitignore`
(`/verificar_*.R`) → NO trackeados, no contaminan el repo remoto, pero ensucian
el working tree local. Decidir en una sesion futura si se archivan a `_archivo/`
o se mueven a una ubicacion trazable. No urgente.

---

## 11. Pendientes y ruta sugerida

### Inventario de pendientes

**P-PALETA — Auditoria de fidelidad de paleta a la identidad IDPS (NUEVO, titular).**
- **Descripcion:** secciones, graficos y colores del motor que no respetan la
  paleta de identidad de los 4 indicadores IDPS (instruccion previa del titular,
  reincidente). Referencia visual entregada por el titular: folleto de la Agencia
  (4 circulos: Autoestima = indigo; Clima = turquesa; Participacion = verde;
  Habitos = verde lima). Hex muestreados del PNG (NO canonicos):
  ~`#3B5BA5` / `#4DB8C4` / `#3E9B5F` / `#8DC63F`.
- **Tipo:** bug de fidelidad visual (presentacion, no cifra).
- **Alcance a definir:** censar donde el motor usa color de indicador (badges,
  graficos `BarrasAnio`/radar, secciones, leyendas) y contrastar contra la paleta
  canonica.
- **Fuente canonica de los hex:** extraer de la fuente del repo
  (`20_insumos/auxiliares/referencias_idps/otros_indicadores_calidad_2019.pdf`,
  el marco, o los hex ya embebidos en `35_motor_template.html` /
  `idps_corpus_conceptual`), **no del PNG comprimido**.
- **Precaucion:** 🔒 cualquier toque a `35` exige REGENERAR + RE-VERIFICAR
  fidelidad parquet→sitio antes de desplegar (la paleta es presentacion, no altera
  valores, pero el build cambia de md5). NO desplegar a ciegas.
- **Complejidad:** Media (censo de usos + alineacion); si hay paleta canonica clara,
  es mecanico.
- **Sugerencia de enfoque:** (1) extraer/confirmar la paleta canonica de la fuente;
  (2) censar usos de color en template y generador; (3) encargo a Claude Code para
  alinear, regenerar y re-verificar fidelidad. Posible candidato a metodologia A19
  (referencia aprobada) si la iteracion visual no converge.
- **Criterio de exito sugerido:** paleta canonica documentada (hex de fuente) +
  todos los usos de color de indicador alineados + fidelidad re-certificada +
  deploy.

**P-DOC — Documentacion via `suitedoc` + doc minima.**
- Generar la suite (protocolo 4.6) y la doc minima de politica 10 (README,
  `documentacion_tecnica`, `gobernanza_datos`). Definir si se publica la metodologia
  en Pages. Tipo BIBLIOTECA (produce `documentar.R`). Insumos imprescindibles ya
  disponibles: escaner + este traspaso; `idps_corpus_conceptual.md` en la KB.

### Evaluacion de deuda tecnica
- **Scripts `verificar_*.R` en raiz** (8): gitignorados, no trazables. Ver seccion 10.
- **Generador `35`:** la zona fragil sigue siendo las uniones con el directorio
  (coalesce de geo y dependencia); cualquier reapertura del motor (p. ej. P-PALETA
  si toca render) debe respetar los `stopifnot` calibrados en s12.

### Auditoria de cierre (politica 5.6)
- Pipeline corre de cero sin intervencion: **Si** (sin cambios al flujo).
- Outputs reproducibles/idempotentes: **Si** (no se regenero nada).
- Nombres sin tildes/ñ/espacios: **Mejorado** — 4 glosas corregidas en s13; quedan
  tildes solo en crudos heredados de la Agencia (excepcion declarada, politica 2).
- Estructura respeta la politica: **Si**, con la deuda de `verificar_*.R` en raiz
  anotada (no bloqueante, gitignorada).

### Ruta sugerida para la sesion 14
1. **Apertura CONTINUATION** con este v13 + escaner + protocolo de la KB.
2. **P-PALETA** como foco: extraer la paleta canonica de la fuente del repo, censar
   los usos de color del motor, y (si hay divergencia real) encargo a Claude Code
   para alinear + regenerar + re-verificar fidelidad + desplegar. Es lo unico con
   cara al usuario pendiente.
3. **P-DOC** en sesion BIBLIOTECA dedicada (no mezclar con P-PALETA).
- **Diferir:** scripts `verificar_*.R` en raiz (higiene local, no urgente).
- **No reabrir el dato** (blindado) **ni el build** salvo que P-PALETA lo exija, y
  en ese caso con regeneracion + re-verificacion de fidelidad obligatorias.

---

## 12. Instrucciones especificas para la proxima sesion

- 🔒 El dato esta verificado a nivel CENSO (s11) y la fidelidad parquet→sitio
  tambien (s12). NO re-auditar ni regenerar el parquet.
- 🔒 El motor desplegado es el certificado (build md5 `0b7b0b08…`). Cualquier
  cambio de `35` (incluida P-PALETA si toca render) exige REGENERAR y RE-VERIFICAR
  fidelidad antes de desplegar. NO desplegar a ciegas.
- 🔒 H-FID-2 esta DECIDIDA (opcion A, dependencia vigente, D-s13-DEPENDENCIA). No
  reabrir sin decision explicita del titular.
- ⚠️ P-PALETA: extraer los hex de la FUENTE del repo, no del PNG de referencia
  (comprimido, colores aproximados). Verificar antes de alinear (B.1).
- ⚠️ NO inventar significancia/GSE/geo donde el dato trae NA (vigente desde v11).
- ✅ ANTES de cualquier `git add`, revisar `git status`; commits atomicos por ruta;
  nunca `git add .`/`-u`.
- ✅ Al renombrar archivos: verificar primero por grep que ningun script los lee por
  nombre; distinguir deuda de case (git mv con paso intermedio) de deuda de tildes
  (git mv directo).
- 🔒 Actualizar `CLAUDE.md` "ultimos cambios" es paso de CIERRE (ver nota).

### Nota de cierre pendiente
**`CLAUDE.md` "ultimos cambios" NO se actualizo en esta sesion** (igual que quedo
anotado en v12). Corresponde hacerlo como parte del cierre. Si s14 corre en Claude
Code, actualizarlo al abrir con el resumen de s13 (H-FID-2 + higiene). Push de
cierre de s13 tambien pendiente al momento de redactar (4 commits locales:
`45b5ddd`, `36f0c48`, `a5a2ce4`, `9371156`).

---

## 13. Fragmentos de codigo de referencia

**Detectar deuda de case real (indice vs disco, macOS case-insensitive):**
```bash
cd /Users/tomgc/Projects/slep_idps
git ls-files <subcarpeta>/ | while read f; do
  real=$(ls "$f" 2>/dev/null)
  if [ "$f" != "$real" ] && [ -n "$real" ]; then
    echo "INDICE: $f"; echo "DISCO:  $real"; echo "---"
  fi
done
# vacio = no hay desajuste de case (puede haber otra deuda, p. ej. tildes)
```

**Clasificar un intermedio como trazable vs scratch (la prueba es el grep):**
```bash
# trazable si y solo si un script del FLUJO lo escribe:
grep -rn "nombre_sin_extension" \
  /Users/tomgc/Projects/slep_idps/00_build.R \
  /Users/tomgc/Projects/slep_idps/30_procesamiento/
# vacio = scratch one-off → gitignorar por patron, no versionar
```

**Renombrar sin tildes cuando ningun script referencia el nombre (git mv directo):**
```bash
git mv "ruta/archivo_público_final.xlsx" "ruta/archivo_publico_final.xlsx"
# cambio de tilde (no de case) → no requiere paso intermedio en macOS
```

---

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesion 14 (Opus)`.
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION. El protocolo (politica +
  SETTINGS) vive en la knowledge base y se lee desde ahi. Adjunto el traspaso v13 y
  el escaner actual. El motor 2014→2025 sigue desplegado y certificado (sin cambios
  en s13); el parquet esta blindado. Foco propuesto: P-PALETA (auditoria de
  fidelidad de la paleta del motor a la identidad IDPS) — extraer la paleta canonica
  de la fuente del repo, censar usos de color y alinear si hay divergencia. P-DOC
  queda para una sesion BIBLIOTECA dedicada."
- **Documentos para la sesion 14, en tres bloques:**
  1. *Protocolo en knowledge base* (NO se adjuntan; se listan para verificar que
     este al dia): `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales segun el foco:* `CLAUDE.md` (si se corre en Claude Code);
     `encargo_autonomo_claude_code_v1.md` (si hay encargo, probable en P-PALETA);
     `35_generar_motor_html.R` + `35_motor_template.html` (imprescindibles si
     P-PALETA toca render); `idps_corpus_conceptual.md` (en la KB) si el foco vira a
     P-DOC.
  3. *Especificos de la sesion (SI se adjuntan):* `traspaso_cierre_v13.md`;
     `estructura_actual.md`. La imagen de referencia de la paleta IDPS (folleto
     Agencia) si se trabaja P-PALETA. El parquet se lee del repo, no se adjunta.
- **Nota final:** si `35_generar_motor_html.R` o `35_motor_template.html` cambian
  entre sesiones, adjuntar la version mas reciente y avisarlo en la apertura.
