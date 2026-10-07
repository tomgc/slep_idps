# Encargo autónomo a Claude Code — Modal del comparador alineado al proyecto hermano, y redespliegue

> Proyecto: `slep_idps`. Sesión s29 (CONTINUATION), octavo encargo (s29h).
> Corrige un **error de especificación mío**, no de ejecución. El encargo s29 §3.2 mandó
> poner la entidad nacional como fila fija "arriba de la lista en TODOS los tabs, no
> dentro de un tab propio", y se implementó exactamente así: "Chile" aparece dentro del
> tab **Establecimiento** (donde no es un establecimiento) y encabeza las listas de
> SLEP, Comuna y Región (donde tampoco pertenece). El error de fondo fue inventar una
> solución en vez de mirar cómo la resolvió el proyecto hermano, **`slep_simce_adecuado`**,
> que ya tiene este mismo modal resuelto. Detectado por el titular sobre el motor
> publicado; registrado en la §33 del log de la sesión.

---

## 0bis. Insumos (contexto frío)

1. `50_documentacion/andamios/logs/20260909_comparador_entidades_s29_log.md` — log de
   la sesión. §8.2 trae la convención de normalización del payload para el hash de
   fidelidad; §33 registra el error que este encargo corrige (**sin commitear**: entra
   en el commit de la Fase 4).
2. `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md` —
   decisión de contraste vigente (excepciones §3.4 y §3.5, exención §5.3 c, backlog §5.6).
3. `CLAUDE.md` y `50_documentacion/activa/POLITICA_PROYECTO.md`.
4. **Referencia vinculante:** `/Users/tomgc/Projects/slep_simce_adecuado/30_procesamiento/33_motor_template.html`,
   componente del modal (alrededor de la línea 3945). Es el proyecto hermano y ya tiene
   este modal resuelto; su solución manda sobre cualquier criterio propio. Ábrelo antes
   de editar.

**Gate:** el titular pidió expresamente corregir esto y republicar sin revisión previa
suya. La Fase 3 **redespliega** a `docs/`.

---

## 1. Contrato

- Modo autónomo secuencial, commit atómico por fase, `git add` a rutas exactas, rutas
  absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención:**
  1. Si el cambio exigiera tocar la lógica de selección (`addTerr`), el tope
     `CMP_MAX_TERR`, `rosterTerr` o cualquier cifra: detente. Esto es catálogo del
     modal, nada más.
  2. Si cambia cualquier cifra del payload: detente (diff de offsets; hash §8.2).
  3. Si el build falla o emite un warning nuevo: detente.
  4. Si `docs/index.html` no queda byte-idéntico a `40_salidas/motor_idps.html`: detente.

---

## 2. Fase 1 — Tabs del modal como en el hermano (commit `fix`)

**Cómo lo resuelve `slep_simce_adecuado`** (leído en su plantilla, líneas 3952-3959):
seis tabs en este orden, de menor a mayor alcance, con la categoría transversal al
final:

```
Establecimiento · Comuna · SLEP · Región · Nacional · Grupo personalizado
```

El tab **Nacional no tiene lista ni buscador**: es una sola opción que, al guardar,
produce `{name:"Chile", kind:"nacional"}`. El título del modal es "Agregar territorio"
y el footer tiene "Cancelar" + "Agregar al análisis".

**Qué se hace en `slep_idps`:**

1. `TABS_CMP` pasa a cinco entradas, en el orden del hermano y **sin** "Grupo
   personalizado" (esa categoría no existe en este motor y no se inventa aquí):
   `[["establecimiento","Establecimiento"],["comuna","Comuna"],["slep","SLEP"],["region","Región"],["nacional","Nacional"]]`.
   Con ese orden el modal abre en **Establecimiento**, igual que el hermano, sin tocar
   `EntityModal`.
2. `buildListCmp` **deja de concatenar** `NACIONAL_OPT` a todas las listas: devuelve
   `[NACIONAL_OPT]` solo cuando `tab === "nacional"`, y `_listaCmpEnt(...)` tal cual en
   los demás. Corrige el comentario de las líneas 1494-1496, que hoy afirma lo
   contrario.
3. En el tab Nacional el buscador no aplica (una sola opción): ajusta
   `cmpPlaceholderFor` y `emptyTextFor` para ese tab de modo que no invite a buscar. No
   elimines el buscador del andamio ni cambies su layout.
4. La fila de Chile conserva su marca `is-nac` y su `sub` ("Nivel nacional · N comunas ·
   N establecimientos").

**No** replique el resto del hermano en este encargo (título del modal, footer, filtro
de dependencia, "Grupo personalizado"): son diferencias reales entre los dos motores y
cambiarlas ahora excede lo que el titular pidió. Si al leer el hermano detectas otras
divergencias del modal, **anótalas en el log** sin corregirlas.

Todo lo demás del comparador queda igual: mismo toggle, mismo tope de 10, Chile sigue
siendo la primera fila de cada sección de GSE.

Commit: `fix(comparador): tabs del modal alineados al proyecto hermano; nacional en su tab`

## 3. Fase 2 — Regenerar y verificar (commit `build`)

1. `Rscript -e 'source("00_build.R"); run_all(only = 35L)'`.
2. Fidelidad del payload: bloque 7 idéntico + diff de offsets (solo `fecha_generacion`).
3. Verificación funcional en navegador, sobre el motor generado:
   - los cinco tabs existen, en el orden del hermano, y el modal abre en **Establecimiento**;
   - "Chile" aparece **solo** en el tab Nacional y en ninguno de los otros cuatro
     (comprueba explícitamente el tab Establecimiento, que era el caso más visible);
   - seleccionar Chile desde su tab lo agrega igual que antes: chip "Nacional · fijo" y
     primera fila de cada sección de GSE;
   - el tope de 10 y el toggle siguen funcionando.
4. Regla de etiquetado de s29 intacta: 0 cortadas y 0 duplicados a 1200px.

Commit: `build(motor): regenera el motor con el tab nacional`

## 4. Fase 3 — Redesplegar (commit `deploy`)

Copia `40_salidas/motor_idps.html` a `docs/index.html` (byte a byte, verificado con
`md5`) y confirma que abre sin errores de consola.

Commit: `deploy(docs): republica con la entidad nacional en su propio tab`

## 5. Fase 4 — Log y publicación

1. Sección s29h en el log: qué cambió, verificación funcional y constancia del
   redespliegue. **Incluye la §33 preexistente sin commitear.**
2. `git push origin main`; reporta el hash y confirma `origin/main == HEAD`.

Commit: `docs(log): registro de s29h`

---

## 6. Fuera de alcance

- Cualquier otro hallazgo de la revisión del titular: él los reportará aparte.
- §5.6 (texto sobre color de indicador), P-VISTA-TERRITORIAL, marca de base pequeña.
- Rama `feat/contrato-contexto`.
