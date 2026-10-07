# Encargo autónomo a Claude Code — Chips de estado del panorama y cierre de la §5.3

> Proyecto: `slep_idps`. Sesión origen: s29 (CONTINUATION), quinto y último encargo (s29e).
> Cierra los tres hallazgos que la §5.3 de
> `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`
> dejó abiertos: uno se corrige, uno se declara exento con fundamento, uno pasa al
> backlog. Encargo corto y sin decisiones nuevas: usa tokens que ya existen.

---

## 0. Contrato

- **Modo:** autónomo, secuencial, commit atómico por fase, `git add` a rutas exactas.
- **Stack:** CSS embebido en `30_procesamiento/35_motor_template.html` + documentos
  markdown. Rutas absolutas desde `/Users/tomgc/Projects/slep_idps`.
- **Regla de detención:**
  1. Si el cambio exigiera tocar `--alerta`, `--destaca`, `--st-neutro`, sus `-bg`, los
     `-txt` o `--gris`: detente. Este encargo solo **usa** tokens existentes.
  2. Si cambia cualquier cifra del payload: detente (diff de offsets del JSON; hash con
     la convención de §8.2 del log).
  3. Si el build falla o emite un warning nuevo: detente.
  4. **NO despliegues a `docs/`.**
- **Estado del árbol al recibir esto:** el log de la sesión tiene una **tercera fila en
  la §11** sin commitear (error de atribución del asistente de análisis en el §1 de
  s29d). Entra en el commit de la Fase 4; no la descartes.

---

## 1. Fase 1 — Chips de estado del panorama (commit `fix`)

Medido en el motor de `f429b5e`, panorama territorial:
`.chip.al` (`#EE2D49` sobre `--alerta-bg`) = **3,37**; `.chip.de` (`#2A8FD9` sobre
`--destaca-bg`) = **3,00**. Exigen 4,5: son texto (12px, peso 600), y aquí el color
**es** el texto, así que no aplica el argumento del glifo de la §3.5.

Cambio, en dos declaraciones (líneas ~123-124 de la plantilla):

```
.chip.al{background:var(--alerta-bg);  color:var(--alerta-txt);}
.chip.de{background:var(--destaca-bg); color:var(--destaca-txt);}
```

Esperado: 4,81 y 5,05 (confírmalo midiendo). Los fondos `-bg` **no** se tocan.
Revisa además `.chip.nt` (`#6a5a2f` sobre `#eee5cf`) y repórtalo: si ya cumple, se deja
tal cual; si no, corrígelo con el mismo criterio y dilo en el log.

Commit: `fix(motor): chips de estado del panorama con los tokens de texto`

## 2. Fase 2 — Cerrar la §5.3 de la decisión (commit `docs`)

En `50_documentacion/activa/decisiones/20260910_decision_contraste_texto_estado.md`:

- **§5.3 (a): resuelta** por la Fase 1, con las cifras antes/después.
- **§5.3 (c): declarada exenta**, no pendiente. Fundamento: WCAG 2.1 SC 1.4.3 excluye
  explícitamente el texto de componentes **inactivos** del requisito de contraste, y
  `.ybar-yr` de una columna sin dato es exactamente eso (un año deshabilitado, atenuado
  a propósito para señalar su inactividad); `.sw-line.mm` no es texto sino una **muestra
  de línea**, es decir componente gráfico. Deja escrito que si alguna vez esa atenuación
  pasa a marcar algo distinto de "inactivo", la exención caduca y hay que remedir.
- **§5.3 (b): pasa al backlog** como ítem propio, no como pendiente de esta decisión.
  Anota por qué no se resuelve con un token: los valores van sobre las barras de
  INDICADOR y el peor caso (1,04) es texto sobre su propio color; la salida pasa por
  diseño (sacar el valor de la barra, o decidir el color del texto según la luminancia
  del fondo), y por lo tanto pide mockup y aprobación del titular.

Commit: `docs(decision): cierra §5.3 — chips corregidos, atenuados exentos, historica al backlog`

## 3. Fase 3 — Regenerar y auditar (commit `build`)

1. `Rscript -e 'source("00_build.R"); run_all(only = 35L)'`.
2. Fidelidad: bloque 7 idéntico + diff de offsets del JSON.
3. Auditoría de todo el texto visible, con compositing de alfa y `opacity`, en
   **panorama territorial** y **comparador poblado**, a 1200px.
   - **Criterio:** las únicas fallas que pueden quedar son las dos excepciones escritas
     (etiqueta blanca dentro de la barra §3.4; glifos `.ee-gl` §3.5) y lo declarado
     exento en §5.3 (c). Cualquier otra cosa es falla y se reporta.
4. Regla de etiquetado de s29: 0 cortadas y 0 duplicados a 1200px y 430px.

Commit: `build(motor): regenera el motor con los chips de estado accesibles`

## 4. Fase 4 — Log y publicación

1. Sección s29e en el log de la sesión: commits, cifras antes/después, resultado de la
   auditoría y el veredicto sobre `.chip.nt`. **Incluye la tercera fila de la §11**
   (ver §0).
2. `git push origin main`; reporta el hash y confirma `origin/main == HEAD`.

Commit: `docs(log): registro de s29e`

---

## 5. Fuera de alcance

- Despliegue a `docs/index.html` (gate del titular, sesión aparte).
- §5.3 (b), vista histórica: al backlog.
- Marca de "base pequeña": umbral metodológico sin fijar.
- Rama `feat/contrato-contexto`; tooltip "vs evaluación anterior".
