# Encargo autónomo a Claude Code — Cierre del contraste y despliegue a GitHub Pages

> Proyecto: `slep_idps`. Sesión origen: s29 (CONTINUATION), sexto encargo (s29f).
> Cierra los dos déficits que s29e dejó medidos (§5.3 a y §5.4 de la decisión) y, con
> el gate visual del titular ya dado, **despliega** el motor a `docs/index.html`.
> Es el último encargo de la línea.

---

## 0. Contrato

- **Modo:** autónomo, secuencial, commit atómico por fase, `git add` a rutas exactas.
- **Stack:** CSS embebido en `30_procesamiento/35_motor_template.html`, más documentos
  markdown y la promoción del artefacto. Rutas absolutas desde
  `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención:**
  1. Si el cambio de `--alerta-txt` bajara de 4,5 cualquier lugar donde ese token ya se
     usa (tira externa, `.ee-st`, `.chip.al`, y `.ancla.al` tras la Fase 2): detente.
  2. Si cambia cualquier cifra del payload: detente (diff de offsets; hash con la
     convención de §8.2 del log).
  3. Si el build falla o emite un warning nuevo: detente.
  4. Si `docs/index.html` resultante no fuese **byte-idéntico** a
     `40_salidas/motor_idps.html`: detente. El despliegue es una promoción del
     artefacto, no una regeneración aparte.
- **Gate visual:** concedido por el titular el 2026-09-10 sobre el motor de esta línea.
  Por eso la Fase 4 de este encargo **sí** despliega.

---

## 1. Fase 1 — `--alerta-txt` con margen real (commit `fix`)

`.chip.al` quedó en **4,4661** tras s29e: no alcanza AA por 0,034. La causa está en el
token, no en el selector.

```
--alerta-txt: #D2112D  ->  #CE112C
```

Verificado aritméticamente (controles `#000/#fff` = 21,00 y `#777/#fff` = 4,478):

| Fondo donde el token vive | `#D2112D` | `#CE112C` |
|---|---|---|
| `--alerta-bg` `#FBE3E6` | 4,4661 | **4,6064** |
| `--cream-200` `#F4E9CC` | 4,5029 | 4,6444 |
| `--panel` `#FFFDF7` | 5,3507 | 5,5188 |
| `--paper` `#FFFFFF` | 5,4427 | 5,6136 |
| fila EE `#F7FBFE` | 5,2314 | 5,3957 |
| fila nacional `#FCFAF2` | 5,2082 | 5,3718 |
| `--cream` `#FFF6E0` | 5,0567 | 5,2155 |

Se descartó `#D1112D` (la vía (i) que proponía la decisión): da 4,5003, un margen de
tres diezmilésimas que el próximo ajuste de fondo rompería. Se descartó también tocar
`--alerta-bg`: es fondo institucional. `--destaca-txt` **no se toca**: 4,6886 ya cumple.

Confirma midiendo y retira del CSS la nota de déficit que s29e dejó junto a `.chip.al`.

Commit: `fix(motor): --alerta-txt con margen sobre el fondo de alerta`

## 2. Fase 2 — `.ancla` en la ficha (commit `fix`)

`.ancla.al` y `.ancla.de` (desvío vs GSE de dimensiones y subdimensiones, en la ficha de
establecimiento) repiten el defecto de los chips: usan el color de **barra** sobre el
`-bg`, y dan 3,374 y 3,000. Mismo remedio, dos declaraciones (líneas ~164-165):

```
.ancla.al{background:var(--alerta-bg);  border-color:#f3c9c2; color:var(--alerta-txt);}
.ancla.de{background:var(--destaca-bg); border-color:#c5e4cd; color:var(--destaca-txt);}
```

Fondos y bordes **no** se tocan. Esperado: 4,6064 y 4,6886 (confírmalo midiendo).
Revisa si algún otro selector de la plantilla repite el patrón "color de barra sobre su
`-bg`" y repórtalo; **no** lo corrijas sin decir cuál es.

Commit: `fix(motor): desvio vs GSE de la ficha con los tokens de texto`

## 3. Fase 3 — Regenerar y auditar (commit `build`)

1. `Rscript -e 'source("00_build.R"); run_all(only = 35L)'`.
2. Fidelidad: bloque 7 idéntico + diff de offsets del JSON.
3. Auditoría de todo el texto visible, con compositing de alfa y `opacity`, en **tres**
   escenarios a 1200px: panorama territorial, comparador poblado y **ficha de
   establecimiento** (la que faltaba en s29e y donde vive `.ancla`).
   - **Criterio:** las únicas fallas admisibles son las excepciones escritas (etiqueta
     blanca dentro de la barra §3.4; glifos `.ee-gl` §3.5), lo exento en §5.3 (c) y lo
     que §5.3 (b) dejó en el backlog (vista histórica). Cualquier otra cosa es falla.
4. Regla de etiquetado de s29: 0 cortadas y 0 duplicados a 1200px y 430px.

Commit: `build(motor): regenera el motor con el contraste cerrado`

## 4. Fase 4 — Despliegue a GitHub Pages (commit `deploy`)

1. Promueve el artefacto: copia `40_salidas/motor_idps.html` a `docs/index.html`.
   Es una **copia**, no una regeneración: verifica igualdad byte a byte (`md5`) antes
   de commitear (regla de detención 4).
2. Verifica que `docs/index.html` abre sin errores de consola.

Commit: `deploy(docs): publica el comparador de entidades y el contraste accesible`

## 5. Fase 5 — Documentación, log y publicación

1. En la decisión `20260910_decision_contraste_texto_estado.md`: cierra §5.3 (a) y §5.4
   con las cifras finales, y corrige el valor recomendado (la decisión proponía
   `#D1112D`; se adoptó `#CE112C` por margen).
2. Sección s29f en el log de la sesión: commits, cifras antes/después, resultado de la
   auditoría en los tres escenarios y constancia del despliegue.
3. Actualiza `50_documentacion/activa/ESTADO.md`: `sesion_actual` a s29,
   `ultima_actividad` a la fecha de hoy, y "En qué vamos" / "Próximo paso" al día. Hoy
   declara `v26` y `2026-07-02`, tres sesiones atrás.
4. `git push origin main`; reporta el hash y confirma `origin/main == HEAD`.

Commit: `docs(log): registro de s29f, cierre de contraste y despliegue`

---

## 6. Fuera de alcance

- §5.3 (b), vista histórica: queda en el backlog, pide mockup y decisión del titular.
- Marca de "base pequeña": umbral metodológico sin fijar.
- Rama `feat/contrato-contexto`; tooltip "vs evaluación anterior" (s28).
