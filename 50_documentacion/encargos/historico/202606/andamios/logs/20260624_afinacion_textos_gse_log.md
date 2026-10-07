# Log — Afinación de textos GSE (s21): frase del bloque azul + 2 textos contradictorios

> Ejecución autónoma del encargo corto "afinación textos GSE" (s21). Fecha: 2026-06-24.
> Ejecutor: Claude Code (Opus 4.8). Rama: `main`. Continúa el encargo del polígono GSE
> (`4493bcf`/`11e7d62`/`ef15f5e`). **Push NO; docs/ NO tocado.** Build local regenerado.
> Log SIN commitear.

---

## 1. Resumen

Tres cambios de SOLO texto/comentario, un commit cada uno: (1) condicionar la frase de
la línea punteada del bloque azul a la existencia de GSE; (2) corregir la nota que
negaba globalmente la representación del GSE; (3) actualizar el comentario de cabecera
del generador. Payload byte-idéntico al build previo (cambios no tocan dato); parquet
intacto.

## 2. Commits

| # | Hash | Título |
|---|---|---|
| 1 | `a04b312` | docs(ficha): condiciona la frase de la linea punteada GSE a la existencia de grupo de comparacion |
| 2 | `c775d48` | docs(ficha): corrige la nota que negaba la representacion del GSE (ahora en el radar) |
| 3 | `9a50088` | docs: actualiza comentario de cabecera (el radar dibuja el poligono GSE, decision 20260624) |

## 3. Detalle

### Cambio 1 — bloque azul (`.ficha-explain`)
2ª oración: "La línea punteada indica los resultados de su GSE de referencia." →
**"Cuando el establecimiento cuenta con un grupo de comparación (GSE), la línea
punteada indica los resultados de su GSE de referencia."** Resto del texto idéntico
(verbatim, negritas y color ▼/▲ conservados). Verificado: grep de la frase vieja sin
"Cuando…" = 0; paréntesis final cerrado ("…su referencia)."); render sin error.

### Cambio 2 — nota `.nota-inv` (texto final)
> "Cada cifra se interpreta por su **desvío**, no solo por su nivel absoluto. El motor
> lee `difgru`/`sigdifgru` (vs GSE) y `dif`/`sigdif` (vs evaluación anterior); la
> significancia no se recalcula. El **radar** sí representa el puntaje del GSE
> (reconstruido desde el desvío informado por la Agencia, solo a nivel indicador). Las
> **barras** de dimensión y subdimensión muestran solo el promedio del establecimiento,
> porque a ese nivel no hay dato de GSE; ahí el desvío vs GSE se comunica con las
> anclas."

Ya no afirma globalmente que el GSE no se reconstruye; explica correctamente por qué las
barras no lo muestran. Grep de "no reconstruye el puntaje del GSE" = 0.

### Cambio 3 — comentario de cabecera (`35_generar_motor_html.R`, ~L11-12)
Texto final:
> "…nunca cifra agregada; la comparacion (difgru/sigdifgru y dif/sigdif) se LEE, no se
> recalcula la significancia. El radar SI dibuja el poligono GSE de referencia,
> reconstruido como prom - difgru (decision 20260624_decision_poligono_gse_radar), solo
> a nivel indicador y solo donde hay difgru/cod_grupo (en la practica 2024-2025)."

Cita el archivo de decisión; ya no afirma que el GSE no se dibuja. Comentario, no código.

## 4. Cierre / invariantes 🔒

| Invariante | Estado | Evidencia |
|---|---|---|
| Parquet intocable | **PASA** | md5 `4c764d8c9f0bf70004f8aa52661ae901` igual. |
| Payload sin cambios | **PASA** | `identical()` byte a byte del JSON descomprimido vs el build previo (del encargo GSE) = TRUE. Cambios solo texto HTML / comentario R. |
| Fidelidad censal 0 | **PASA** | Trivial: payload byte-idéntico (mismas cifras, mismo `prom_gse`). |
| Bug s7-1 | **N/A** | No se agregó ningún comentario CSS (Cambio 2 es texto JSX; Cambio 3 es comentario R). Confirmado. |
| docs/ solo en deploy | **PASA** | `git status docs/` vacío. |

## 5. Estado / pendientes

- **Deploy/push:** gate del titular. Build local regenerado; docs/ intacto. Commits
  locales acumulados del día (polígono GSE + esta afinación): `4493bcf`, `11e7d62`,
  `ef15f5e`, `a04b312`, `c775d48`, `9a50088`.
- Sin panel adversarial (no hubo reconstrucción de dato nueva; el polígono GSE ya se
  validó en el encargo previo).
- Pendiente previo vivo: `# REVISAR jerarquía .axis-lab.b` (s20).
