# traspaso_cierre_v19.md

## 1. Identificación

- **Proyecto:** `slep_idps` (motor IDPS nacional, React 18 + D3 v7 inline,
  GitHub Pages desde `docs/index.html`, Rama A pública).
- **Versión:** v19. **Fecha:** 2026-06-23. **Sesión:** 19.
- **Foco:** tanda de 9 ajustes UI/UX del motor desplegado (ítems 1, 2, 3, 5,
  6, 7, 8, 9, 10), ejecutados en 3 encargos autónomos a Claude Code.
- **Entorno:** macOS aarch64, Positron, R 4.5.x, zsh. HEAD `aeb2dcf`,
  `origin/main == aeb2dcf`, working tree limpio.
- **Archivos principales modificados:** `30_procesamiento/35_motor_template.html`
  (los 9 ítems), `30_procesamiento/35_generar_motor_html.R` (Ítem 8a: índice
  `grados_ee`), `40_salidas/motor_idps.html` + `docs/index.html` (3 deploys),
  `50_documentacion/activa/backlog_historico.md` (cierre P-BACKLOG-INTEGRIDAD).

## 2. Resumen ejecutivo

La sesión abrió cerrando deuda documental (P-BACKLOG-INTEGRIDAD: la entrada
huérfana #93 reasignada a Saneamiento, backlog ahora suma 110 = correlativo; y
versionado del traspaso v18 + rotación de escáner que s18 dejó sin pushear).
Luego ejecutó la tanda de UI/UX del motor en tres encargos autónomos: (A)
fidelidad y presentación discreta (ítems 1, 2, 3, 5, 6, 8), (B) media móvil en
históricos (ítem 7), (C) modal multiselección + rediseño de botón del comparador
(ítems 9, 10). Los nueve ítems quedaron desplegados en producción. Toda la tanda
preservó la fidelidad censal (mismatch 0, verificado por panel adversarial
independiente en cada encargo) y el parquet intacto (md5 `4c764d8c…`). Quedan
dos ítems para s20: 4 (auditoría tipográfica) y 11 (lista de EE por segmento,
requiere leer el componente de `slep_simce_adecuado`).

**Registro de ejecución detallado:** `50_documentacion/andamios/logs/20260622_uiux_s19_fase123_log.md`,
`50_documentacion/andamios/logs/20260623_mmovil_s19_log.md`,
`50_documentacion/andamios/logs/20260623_comparador_s19_log.md` (logs de las
sesiones de Claude Code; detalle paso a paso no reproducido aquí).

## 3. Estado al cierre

- **Funciona:** motor desplegado con los 9 ítems (último deploy `1a32f1c`,
  build md5 `512feb17…`). Pages sirve el build vigente. Pipeline corre de cero.
- **No funciona:** nada conocido roto.
- **Delta vs v18:** v18 era cierre documental (motor estable sin cambios de
  producto desde P-PALETA-v2 / s15). v19 reactiva el producto: 9 mejoras de
  UI/UX desplegadas, primer índice cliente nuevo (`grados_ee`) desde la carga
  histórica, y cierre de la última deuda de backlog (P-BACKLOG-INTEGRIDAD).

## 4. Registro detallado de cambios

Ver detalle exhaustivo en los tres logs referenciados (§2). Síntesis por bloque:

- **P-BACKLOG-INTEGRIDAD** (`backlog_historico.md`): entrada huérfana #93
  (bugfix dedup de establecimientos por RBD, s12) reasignada a Saneamiento
  (14→15). Suma de clasificación = 110 = correlativo. Sin renumerar histórico.
- **Deuda A38 de s18** (`traspaso_cierre_v18.md` + escáner): versionados; eran
  untracked desde el cierre de s18.
- **Ítem 1** (`35_motor_template.html`, `IndPanel`): ancla "vs su GSE" primaria
  cuando `difgru!=null`; cuando es NA, el slot NO se renderiza (antes degradaba a
  "sin dato"). Solo presentación.
- **Ítem 8** (`35_generar_motor_html.R` + template): índice server-side
  `meta.grados_ee` (rbd→grados con dato displayable, unión ind/dim/niv); en la
  ficha, grados sin dato del EE desactivados; al cruzar territorio→EE, conserva
  el grado si el EE lo tiene, si no cae al primer grado con dato.
- **Ítem 2** (`DistBar`): signo `%` en el número visible de la barra de niveles.
- **Ítem 3** (`Definicion`): abierta por defecto (`open=true`), ancho completo
  (`max-width:none`), fuente 11.5→13px.
- **Ítem 5** (`BarrasAnio`): `.ybar-track` envolvente 0–100 (relleno tenue del
  faltante + borde a la barra). Sin eje. Escala fija 0–100 conservada.
- **Ítem 6** (`BarrasAnio`): eliminada la atenuación del preliminar (`.is-prelim`
  opacity .62 + outline dashed); solo queda el `*`. Último año CON DATO del EE
  con `.is-latest` + outline 2px del color del indicador.
- **Ítem 7** (`BarrasAnio`): media móvil centrada de 3 puntos como overlay de
  línea (SVG), sobre puntos con dato consecutivos en el eje saltando huecos;
  ≥4 puntos para dibujarla; omite extremos; color del indicador opacidad 0.5;
  cómputo en cliente (función pura). Constantes `MMOVIL_VENTANA=3`,
  `MMOVIL_MIN_PUNTOS=4`. Alineación px verificada (mide layout + ResizeObserver).
- **Ítem 9** (`EntityModal` + `addTerr`): modo multiselección opt-in (`multiple`):
  clic togglea sin cerrar, casilla marcada, tope 4 (al llegar deshabilita el
  resto), "Listo"/Escape cierran. `addTerr` deja de cerrar y togglea. Modo simple
  (navegación de ficha) intacto.
- **Ítem 10** (`.cmp-add` + `.cmp-reset`): botón agregar azul sólido (`--azul`);
  botón reset (↺) que vacía territorios, visible solo con ≥1.

## 5. Backlog acumulativo

> El backlog vivo se mantiene en `50_documentacion/activa/backlog_historico.md`
> (fuente única del conteo histórico). Esta sesión: cerró P-BACKLOG-INTEGRIDAD
> (suma = 110 = correlativo) y agrega las entradas de los 9 ítems UI/UX +
> deuda documental. **Delta v19:** entradas nuevas por los 9 ítems desplegados,
> el cierre de la entrada huérfana, y el versionado de deuda A38 de s18.
> Actualizar el detalle cronológico y la clasificación temática en el archivo
> de backlog con las entradas de s19 (pendiente de incorporar al cronológico si
> no se hizo en esta sesión: registrar como primer paso de s20 si falta).

## 6. Bugs de la sesión

- **Bug 8(b) (cruce territorio→EE conserva grado inexistente):** síntoma —
  seleccionar 2° medio en Panorama territorial y saltar a un EE sin 2° medio
  dejaba el grado activo y la ficha en "sin dato". **Causa raíz:** el selector de
  grado era global (`Object.keys(DATA.meta.grados)`) y `onPickEE`/`irFicha`
  conservaban `panGrado` sin validar contra el EE destino. **Solución:** índice
  `meta.grados_ee` + `gradoValido(rbd,g)`; cae al primer grado con dato si el
  activo no aplica. **Verificación:** RBD 1 (solo-media) y RBD 10 (solo-básica) en
  navegador. **Regla aprendida:** un selector de dimensión global debe validarse
  contra la disponibilidad real de la entidad destino antes de conservar estado al
  navegar. **Estado:** resuelto.

No hubo otros bugs; los demás ítems fueron features/presentación.

## 7. Aprendizajes y restricciones descubiertas

- **A-s19-1 (overlay alineado a columnas con gap):** para superponer un trazo
  (media móvil) sobre barras con `flex:1` + `gap` fijo, el centro de columna NO es
  fracción constante del ancho; medir `getBoundingClientRect` por columna y
  recalcular con `ResizeObserver`. Principio C.7 (portabilidad/no asumir layout).
- **A-s19-2 (modo opt-in en componente portable):** al extender `EntityModal`
  (usado en dos lugares), el comportamiento nuevo (multiselección) va como prop
  opcional con default que preserva el uso existente; verificar no-regresión del
  otro consumidor en navegador. Principio B.3 (cambios quirúrgicos).
- **A-s19-3 (fantasma rbd=NA recurrente en verificación censal):** la
  re-derivación cruda muestra 4 filas más en indicador que el build (1 RBD
  fantasma `rbd=NA`, excluido por diseño desde s12, H-FID-1). No es discrepancia;
  excluirlo antes de declarar mismatch.

## 8. Decisiones de diseño

- **D-s19-GRADOS-EE:** el criterio "tiene dato" de `grados_ee` es la UNIÓN
  displayable (indicador OR dimensión OR niveles), no solo indicador, para no
  desactivar un grado que la ficha igual pintaría. Validado por panel adversarial
  (equivalencia exacta en 9.103 EE). Alternativa descartada: solo-indicador
  (habría desactivado grados con dato de dimensión/niveles).
- **D-s19-MMOVIL:** la media móvil se computa en CLIENTE (función pura sobre la
  serie que arma `serieEje`), no en R. Justificación: la serie final depende del
  EE; computarla server-side replicaría el recorte EE×grado×familia para 9.000+ EE
  e inflaría el payload. Lectura estricta de D-s12: la lógica de negocio (qué año
  tiene dato, qué estado) sigue en R; la media es derivada visual. Ventana centrada
  de 3, mínimo 4 puntos, omite extremos. Alternativa descartada: cómputo en R
  (costo de payload).
- **D-s19-MODAL-MULTI:** `EntityModal` gana modo multiselección opt-in; `addTerr`
  pasa de solo-agregar a togglear (coherente con el modal: clic en fila marcada la
  desmarca). El chip ✕ externo sigue quitando. Modo simple intacto.
- **D-s19-BOTON-B:** el rediseño del botón del comparador (Ítem 10) replica la
  FORMA del patrón hermano (Simce Adecuado) anclada a tokens locales del IDPS
  (`--azul`, etc.), sin importar clases del repo hermano. Alternativa descartada:
  leer y copiar del repo hermano (riesgo de importar estilos que no calzan).

## 9. Constantes y parámetros vigentes

| Constante | Valor | Archivo | Nota |
|---|---|---|---|
| md5 parquet | `4c764d8c…` | `idps_largo.parquet` | invariante, 2.362.447 filas |
| `MMOVIL_VENTANA` | 3 | `35_motor_template.html` | nueva s19, ventana centrada |
| `MMOVIL_MIN_PUNTOS` | 4 | `35_motor_template.html` | nueva s19, mínimo para dibujar media |
| `ANIOS_PANDEMIA` | 2020,2021 | `35_generar_motor_html.R` | huecos estructurales |
| tope comparador | 4 territorios | `35_motor_template.html` | multiselección respeta el tope |
| `--azul` | `#0A3A5C` | template (tokens) | botón agregar (Ítem 10) |
| `--foco` | `#0062A0` | template (tokens) | hover botón |

## 10. Arquitectura de archivos

Escáner de cierre: `50_documentacion/estructura/estructura_actual.md`
(2026-06-23 07:47, 31 carpetas, 249 archivos). Sin cambios estructurales; el
crecimiento son los 3 encargos y 3 logs de la sesión más los snapshots rotados.
Estructura conforme a la política.

## 11. Pendientes y ruta sugerida

### Inventario

- **P-TIPOGRAFIA (Ítem 4):**
  - Descripción: auditar tamaños y familias de fuente del motor; hay demasiada
    variedad de tamaños y las pequeñas son muy pequeñas. Consolidar a una escala
    tipográfica coherente.
  - Contexto: el usuario lo pidió como transversal. Los ítems 3, 5, 6 de s19 ya
    movieron tamaños puntuales; esta auditoría debe recogerlos y unificar el resto.
  - Tipo: deuda técnica / mejora visual. Impacto: todo el motor. Dependencias:
    ninguna (no requiere repo hermano). Complejidad: Media (convergente).
  - Precaución: es convergente; conviene inventariar primero todos los `font-size`
    actuales (auditoría), proponer la escala, y recién entonces aplicar. No parchear
    tamaño por tamaño.
  - Criterio de éxito sugerido: un set acotado de tamaños nombrados (tokens
    `--fs-*`) aplicado consistentemente; ningún texto bajo el mínimo legible
    acordado; sin regresión de layout.

- **P-LISTA-EE-SEGMENTO (Ítem 11):**
  - Descripción: en Panorama territorial, clic en un segmento del gráfico abre la
    lista de EE que lo componen (RBD + nombre + comuna), patrón de Simce Adecuado.
  - Contexto: el callback `onPickEE` ya existe en el motor; el patrón visual a
    replicar vive en el componente de `slep_simce_adecuado` (modal de lista por
    segmento, cap. 13/14 de la sesión).
  - Tipo: funcionalidad nueva. Impacto: pestaña Panorama territorial. Dependencias:
    LEER el componente real de `slep_simce_adecuado` (no reconstruir de memoria,
    A37). Complejidad: Alta.
  - Precaución: gobernanza — el modal mostraría nombres de EE; el motor IDPS ya los
    muestra en la ficha, así que es consistente, pero verificar que la lista respete
    las mismas reglas de presentación de nombres (autoridad de nombres en 3 capas,
    s7). No introducir agregación.
  - Criterio de éxito sugerido: clic en segmento → modal con la lista de EE de ese
    segmento (territorio×GSE×estado), fiel al patrón hermano, sin agregación.

### Evaluación de deuda técnica

Zona frágil: `35_motor_template.html` crece en complejidad (overlay SVG, modal
multimodo, índice `grados_ee`). La auditoría tipográfica (P-TIPOGRAFIA) es buen
momento para consolidar tokens. No hay deuda bloqueante.

### Auditoría de cierre (política 5.6)

- ¿Pipeline corre de cero sin intervención? → Sí.
- ¿Cada transformación crítica tiene check? → Sí; fidelidad censal verificada por
  panel adversarial en los 3 encargos.
- ¿Outputs reproducibles e idempotentes? → Sí (build determinista salvo
  `fecha_generacion`).
- ¿Decisiones metodológicas como constantes nombradas? → Sí (`MMOVIL_*`).
- ¿Nombres sin tildes/ñ/espacios? → Sí.

### Ruta sugerida para s20

1. **P-TIPOGRAFIA (Ítem 4)** primero: es convergente y recoge lo que s19 movió;
   hacerlo antes de añadir más superficie. Criterio: escala de tokens consistente.
2. **P-LISTA-EE-SEGMENTO (Ítem 11)** después: abre la dependencia del repo hermano
   (otro contexto); conviene en su propio tramo, leyendo el componente real primero.
3. Diferir: P-SLEPVERSE (sesión NEW PROJECT dedicada).

## 12. Instrucciones específicas para la próxima sesión

- 🔒 Parquet intocable (md5 `4c764d8c…`); fidelidad censal mismatch = 0 siempre.
- 🔒 GSE solo a nivel indicador; no inyectar donde es NA.
- 🔒 Escala `BarrasAnio` fija 0–100; la media móvil y el track se dibujan en esa
  escala, sin autoescala.
- 🔒 `EntityModal` modo simple (navegación de ficha) NO debe cambiar; multiselección
  es opt-in.
- ✅ ANTES de tocar `35_motor_template.html`, releer las zonas (las líneas se mueven
  cada sesión por los cambios acumulados).
- ✅ ANTES de declarar fidelidad, excluir el fantasma rbd=NA (4 filas en indicador).
- ⚠️ NO reconstruir el componente de Simce Adecuado de memoria para el Ítem 11:
  leerlo del repo hermano (A37).
- ⚠️ Ítem 4 es convergente: inventariar tamaños ANTES de aplicar; no parchear uno
  por uno.

## 13. Fragmentos de referencia

- Verificación de fidelidad (patrón de la sesión): re-derivar las cifras desde el
  parquet con código independiente + identidad de bloques de payload vs build HEAD;
  excluir fantasma rbd=NA; panel adversarial de solo-lectura. Scripts en `/tmp` (no
  versionados); el patrón vive en `auditoria_codigo_proyecto_md_v1.md`.

## 14. Reapertura

- **Nombre del chat:** `slep_idps, sesión 20 (Opus 4.8)`
- **Mensaje de apertura pre-armado:** "Tipo CONTINUATION de `slep_idps`. El
  protocolo (POLITICA_PROYECTO.md + SETTINGS_Y_PROMPTS_OPERACIONALES.md) vive en la
  knowledge base y se lee desde ahí. Adjunto el traspaso v19, el escáner y el
  backlog histórico. Foco propuesto: P-TIPOGRAFIA (Ítem 4)."
- **Documentos para la próxima sesión:**
  1. *Protocolo en knowledge base (NO adjuntar, solo verificar al día):*
     `POLITICA_PROYECTO.md`, `SETTINGS_Y_PROMPTS_OPERACIONALES.md`.
  2. *Opcionales según foco:* `encargo_autonomo_claude_code_v1.md` (si el Ítem 4 o
     11 va por encargo autónomo); `auditoria_codigo_proyecto_md_v1.md` (si hay
     auditoría de cifras).
  3. *Específicos de la sesión (SÍ adjuntar):* `traspaso_cierre_v19.md`;
     `estructura_actual.md`; `backlog_historico.md`. Para el Ítem 11, cuando se
     aborde: el componente de lista por segmento de `slep_simce_adecuado`.
- **Nota final:** si algún archivo listado cambió, adjuntar la versión más reciente
  al abrir y avisarlo.
