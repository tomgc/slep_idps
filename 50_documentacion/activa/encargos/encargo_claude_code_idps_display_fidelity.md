# Encargo autónomo a Claude Code — slep_idps, sesión 12: P-DISPLAY-FIDELITY

> Patrón: encargo autónomo dirigido por meta (`encargo_autonomo_claude_code_v1.md`).
> Cierre de verificación del motor tras P-MOTOR. Tipo: CONTINUATION slep_idps,
> sesión 12. Es un encargo de SOLO LECTURA y verificación: NO modifica el repo,
> NO toca el parquet, NO redespliega. Produce un veredicto y un log.

---

## 1. Contrato

- **Modo:** autónomo, secuencial, todo en este turno. SOLO LECTURA del repo y del
  sitio en vivo. No `git add`, no commits de código, no redeploy. (El log de
  verificación se puede commitear como `docs()` atómico al final; ver §6.)
- **Reglas canónicas:** rutas absolutas con `git -C /Users/tomgc/Projects/slep_idps`;
  R-only para scripts; scripts de verificación efímeros NUNCA se versionan
  (`verificar_*.R` van a /tmp o se borran). Sin asumir `cd`.
- **Regla de detención (PARA y reporta):**
  1. El `md5` del parquet NO es `4c764d8c9f0bf70004f8aa52661ae901` al inicio.
  2. Una cifra del sitio desplegado NO coincide con el parquet más allá de la
     tolerancia de redondeo definida (§4): eso es un hallazgo de fidelidad real,
     se documenta y se reporta, NO se "arregla" en este encargo.
  3. Cualquier necesidad de modificar código para completar la verificación: la
     verificación no debe cambiar lo verificado.

---

## 2. Contexto y propósito

P-MOTOR (sesión 12) regeneró y desplegó el motor con la serie 2014→2025. Se
verificó crudo→parquet (censo, sesión 11) y la cobertura JSON==parquet (panel
adversarial de P-MOTOR). Lo que **falta** es el último eslabón: **parquet → cifra
que el sitio DESPLEGADO muestra**. P-DISPLAY-FIDELITY cierra esa cadena para la
validación técnica externa: que un número en pantalla sea trazable, idéntico, al
parquet (y por transitividad al crudo).

- **Sitio en vivo:** https://tomgc.github.io/slep_idps/
- **Build local idéntico:** `/Users/tomgc/Projects/slep_idps/docs/index.html`
  (en P-MOTOR el `md5` live == local quedó confirmado; revalida al inicio).
- **Parquet:** `/Users/tomgc/Projects/slep_idps/40_salidas/intermedios/idps_largo.parquet`
  (`md5 4c764d8c9f0bf70004f8aa52661ae901`, 🔒 intocable).
- **El dato viaja:** parquet → JSON columnar → gzip→base64→pako, incrustado en
  `atob(variable)` dentro del HTML. El generador redondea `prom` a 1 decimal al
  serializar (`round(prom, 1)`), niveles también. La cifra del sitio es ese valor
  redondeado; el parquet trae el valor pleno.

---

## 3. Invariantes (🔒)

- 🔒 Parquet intocable; `md5` inicio == fin.
- 🔒 Verificación independiente: re-deriva con CÓDIGO PROPIO, no reuses funciones
  del generador `35` (un check que reusa la función que produjo el valor hereda su
  punto ciego — A21 / panel adversarial).
- 🔒 No reabrir el dato ni el motor: si hay discrepancia, se DOCUMENTA, no se
  corrige aquí (corrección sería tarea nueva del titular).

---

## 4. Metodología del spot-check (patrón auditoría de cifras)

Cada cifra ancla se verifica por DOS caminos independientes que deben coincidir:
- **Camino A (sitio):** decodifica el `docs/index.html` desplegado (dato en
  `atob(variable)`; usa el escaneo de base64 largos, como en P1), parsea el JSON,
  y LEE la cifra tal como el cliente la leería (mismo índice rbd→rango, mismo
  filtro grado/agno/id que usa el motor en `indOf`/`dimOf`/`nivOf`, pero
  reimplementado por ti, no importado de `35`).
- **Camino B (parquet):** lee el parquet por separado y obtén el `prom` pleno de
  esa misma (rbd, grado, agno, familia, id), aplicando `round(x, 1)` para
  comparar contra el sitio.

**Tolerancia:** las cifras del sitio están redondeadas a 1 decimal. Compara
`round(prom_parquet, 1) == prom_sitio` con `TOL = 1e-9` sobre esa base redondeada.
Documenta como constante nombrada. Un desvío > TOL es hallazgo (detención regla 2).

**Punto de atención (redondeo histórico vs moderno):** en el parquet, varios
`prom` históricos vienen enteros (p. ej. 2014: 79.0) y los de 2018 con decimales
largos (p. ej. 78.4574…). Verifica explícitamente un caso de cada tipo: que el
redondeo a 1 decimal del valor con cola larga (2018) coincide con lo que el sitio
muestra, y que el entero histórico (2014) no se distorsiona.

---

## 5. Anclas (candidatos reales del parquet; VALÍDALOS antes de usar — A24)

Estos candidatos salen del parquet (universo motor 4b/2m). **Antes de anclar,
confirma que cada combinación existe en el JSON DESPLEGADO** (no solo en el
parquet); si alguno no está en el sitio, repórtalo y sustitúyelo por otro que
cumpla el mismo criterio.

1. **RBD 10, grado 4b — serie larga (histórico + moderno + 4b2024).** Valores
   `prom` indicador esperados (parquet, sin redondear) para contrastar:
   - 2014: ind1=79.0, ind2=73.0, ind3=77.0, ind4=69.0 (enteros históricos)
   - 2018: ind1=78.4574…→**78.5**, ind2=84.7141…→**84.7**, ind3=88.9683…→**89.0**,
     ind4=80.1747…→**80.2** (cola larga → verifica el redondeo)
   - 2024: ind1=83.0, ind2=78.0, ind3=87.0, ind4=74.0 (4b2024, el que faltaba)
   Verifica los tres años: histórico entero, histórico con cola, y 2024.
2. **RBD 1, grado 2m — tiene dimensión 2018** (el punto histórico aislado de
   dimensión) + serie moderna (2022, 2024). Verifica: la cifra de una dimensión en
   2018, y que 2019-2021 no producen cifra (vacío correcto, no 0 ni inventado).
3. **Uno de los 20 RBD que estuvieron duplicados** (el fix `fefb79a` los dejó en una
   fila). Elige uno del log de P-MOTOR (p. ej. RBD 75) y verifica que su cifra de
   indicador en el año más reciente coincide parquet→sitio, y que aparece UNA sola
   vez en `establecimientos` del JSON desplegado (el dedup no alteró su valor).
4. **Un nivel (familia niveles) de un RBD con datos 2024** (4b o 2m): verifica que
   la distribución bajo/medio/alto de una subdimensión coincide parquet→sitio
   (redondeada a 1 decimal), para cubrir la familia niveles, no solo ind/dim.

Cubre, entre las anclas: las tres familias (ind, dim, niv), un año histórico
entero, un año histórico con cola decimal, 4b2024, el punto dim-2018, y un
RBD ex-duplicado. Si un ancla no existe en el sitio, sustitúyela documentando.

---

## 6. Criterios de éxito y cierre

**Éxito:** para todas las anclas, `round(prom_parquet,1) == prom_sitio` (TOL=1e-9);
las tres familias cubiertas; 2019-2021 sin cifra (vacío correcto); el RBD
ex-duplicado aparece una vez con su cifra intacta; `md5` parquet inicio==fin.

**Si todo PASA:** el motor queda certificado para validación externa
(parquet→sitio fiel, y por transitividad crudo→sitio).

**Si algo FALLA:** documenta el ancla, el valor sitio vs parquet, y la magnitud del
desvío; detente; NO corrijas.

**Cierre:**
- Escribe el log en
  `/Users/tomgc/Projects/slep_idps/50_documentacion/andamios/logs/YYYYMMDD_display_fidelity_log.md`
  (plantilla fija: resumen, anclas usadas y por qué, tabla ancla×camino-A×camino-B×
  veredicto, familias cubiertas, md5 inicio/fin, hallazgos/`# REVISAR`, notas para
  el revisor). Honesto.
- Borra cualquier script efímero de /tmp.
- El log puede commitearse como `docs()` atómico (`git status` limpio antes; push
  si commiteas) o dejarse sin commitear para revisión del titular; tú decides, pero
  déjalo escrito.
- **NO** actualices `CLAUDE.md` (paso de cierre de sesión).
- **Reporta** al volver: la tabla de anclas con PASA/FALLA por cada una, las
  familias cubiertas, el md5 inicio/fin, y cualquier hallazgo.

---

## 7. Qué NO hacer

- No modificar el parquet, el generador, el template ni `docs/`.
- No redesplegar.
- No reusar funciones de `35_generar_motor_html.R` para leer las cifras (re-deriva).
- No corregir discrepancias: documéntalas y reporta.
- No integrar los `idps4B2024_*.xlsx` (el parquet ya los contiene).
