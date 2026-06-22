# Decisión — Paleta cromática de los 4 indicadores IDPS del motor

- **Fecha:** 2026-06-22
- **Encargo:** P-PALETA (`50_documentacion/activa/encargo_claude_code_idps_paleta.md`)
- **Tipo:** decisión de presentación (identidad de marca). NO afecta ninguna cifra.
- **Estado:** adoptada y desplegada (sesión 12, tras panel adversarial de fidelidad).

---

## 1. Contexto y problema

El motor codifica los 4 indicadores IDPS por color (radar, barras por año, leyendas,
tabla territorial, paneles, dots y swatches). Hasta esta decisión usaba una **paleta
interna** heredada del prototipo/madre (rojo/amarillo/verde-lima/azul), que **no
correspondía** a la identidad cromática oficial con que la Agencia de Calidad presenta
los indicadores en su folleto divulgativo
(*"¿Cuáles son los Indicadores de Desarrollo Personal y Social?"*, los 4 círculos).

Para una validación externa y coherencia institucional, el motor debe **replicar la
identidad oficial** de los 4 indicadores.

## 2. Las dos paletas en conflicto

| id | Indicador (corto)  | Interna previa (madre) | **Folleto Agencia (adoptada)** |
|----|--------------------|------------------------|--------------------------------|
| 1  | Autoestima         | `#EE2D49` (rojo)       | **`#3858A3`** (azul)           |
| 2  | Convivencia/Clima  | `#FFC92E` (amarillo)   | **`#61BDC6`** (turquesa)       |
| 3  | Participación      | `#9BC93E` (verde-lima) | **`#4BA560`** (verde)          |
| 4  | Hábitos            | `#2A8FD9` (azul)       | **`#AACB58`** (verde-amarillo) |

El **mapeo indicador→color** está confirmado contra los rótulos impresos del folleto
(cada círculo lleva el nombre del indicador).

## 3. Decisión

**Adoptar la paleta del folleto oficial de la Agencia**, reemplazando la interna en la
única fuente runtime (`INDICADOR_COLORS` en `30_procesamiento/35_generar_motor_html.R`,
que inyecta `indicadores[*].color` al JSON) y en el token espejo `--ind1..4` del
`:root` del template (coherencia documental; el runtime lee `ind.color` del JSON).

Los **colores de ESTADO** (alerta/destaca/bajo/medio/alto/neutro) y la identidad gobCL
(azul/cream) **NO se tocan**: son un eje semántico propio. La antigua coincidencia
estado↔indicador (alerta `#EE2D49` == ind1, destaca `#2A8FD9` == ind4) desaparece con
el cambio, y es correcto que así sea.

## 4. Procedencia de los hex (honesta)

Los 4 hex se obtuvieron por **muestreo por moda exacta del PNG del folleto** (imagen de
alta nitidez): se tomó el color modal de cada círculo. **NO** es una extracción
vectorial del PDF original (que daría el valor de marca exacto del archivo fuente).

- **Deuda menor declarada:** si en el futuro se dispone del PDF/vectorial oficial o de
  la guía de marca de la Agencia, conviene re-confirmar los hex contra esa fuente
  autoritativa y, si difieren, actualizar `INDICADOR_COLORS` (un solo punto). El
  muestreo por moda sobre PNG nítido es fiel a simple vista, pero no sustituye al valor
  vectorial de marca.

## 5. Garantía de fidelidad (ninguna cifra cambió)

El cambio es 100% presentación. Verificado en la Fase 4 y por panel adversarial
independiente (código propio, solo lectura):

- Reconciliación censal **parquet → sitio**: 0 discrepancias (ind/dim/niv +
  dif/sigdif/difgru/sigdifgru).
- Diff **build nuevo vs certificado** (`0b7b0b08`): cifras byte-idénticas
  (ind/dim/niv/roster); universo 9.136 establecimientos; bloque `indicadores` con
  `id/nombre/corto/definicion` idénticos y **única diferencia = los 4 `color`**.
- `md5` del parquet `4c764d8c9f0bf70004f8aa52661ae901` inicio == fin (🔒 intocado).

## 6. Frase canónica ante validación externa

> "La paleta del motor replica la identidad oficial de los 4 indicadores de Desarrollo
> Personal y Social de la Agencia de Calidad de la Educación."

## 7. Reversión

Trivial y de un solo punto: restaurar los 4 hex en `INDICADOR_COLORS` (y el espejo
`--ind1..4`), regenerar (`run_all(only = 35)`) y recopiar a `docs/`. Ninguna cifra se
ve afectada por una reversión.
