# Decisión: cobertura histórica IDPS y razón de los huecos

- **Fecha:** 2026-06-25
- **Sesión:** s25
- **Estado:** vigente
- **Cierra (obsoleto):** el pendiente heredado "extender el PATRON_DATOS / integrar el histórico"
- **Evidencia de respaldo:** parquet `40_salidas/intermedios/idps_largo.parquet` (md5 `4c764d8c9f0bf70004f8aa52661ae901`), verificado contra la cobertura por familia y por grado.

---

## 1. Contexto

El pendiente histórico que arrastraban los traspasos previos describía un estado obsoleto:
archivos supuestamente alojados en `~/Desktop/idps`, un `PATRON_DATOS` sin soporte para el
régimen histórico y una integración del histórico 2014-2019 todavía pendiente.

El estado real, verificado en s25, es otro: el histórico ya está integrado, desplegado y
verificado. El script `30_procesamiento/34_leer_normalizar_idps.R` lee el régimen histórico
2014-2019 (rama 3b, formato ancho que se pivota a largo) y lo funde con el régimen moderno
2022-2025 en `idps_largo.parquet` (2.362.447 filas, serie 2014-2025). El parquet re-corrido es
byte-equivalente al canónico: el md5 `4c764d8c9f0bf70004f8aa52661ae901` es idéntico antes y
después de re-correr el `34`, lo que confirma que el script es idempotente sobre los insumos
actuales.

## 2. Decisión

La cobertura histórica disponible en el parquet es la **máxima** que permite la fuente. Los
años y grados ausentes son **ausencia de aplicación del instrumento en origen**, no datos
pendientes de adquirir ni deuda de ingesta. En consecuencia:

- El script `34` **no requiere extensión** para "traer más histórico": ya lee todo lo que la
  Agencia publicó.
- Los huecos de cobertura **no se tratan como deuda de datos** en sesiones futuras. Son una
  propiedad de la fuente, no un defecto del pipeline.

## 3. Cobertura real por familia (verificada contra el parquet)

| Familia | Años con dato |
|---|---|
| Indicador | 2014-2025 (los 4 grados, con huecos de aplicación) |
| Dimensión | 2018 (histórico) + 2022-2025 (moderno) |
| Niveles | 2023-2025 (2024 para 6b/8b) |

## 4. Cobertura por grado (los 4 grados del parquet)

| Grado | Años presentes | N años |
|---|---|---|
| 2° medio (2m) | 2014-2018, 2022-2025 | 9 |
| 4° básico (4b) | 2014-2018, 2022-2025 | 9 |
| 6° básico (6b) | 2014-2016, 2018, 2024 | 5 |
| 8° básico (8b) | 2014-2015, 2017, 2019, 2025 | 5 |

(El motor expone solo 4b y 2m; ver §6. Los 4 grados se conservan en el parquet.)

## 5. Razón de los huecos (provenance del titular)

- **6° y 8° básico se aplican de forma intermitente, no anual.** Su presencia en años sueltos
  (6b en 2014-2016, 2018, 2024; 8b en 2014-2015, 2017, 2019, 2025) refleja el calendario de
  aplicación de la Agencia para esos grados, no una pérdida de datos.
- **2019, interrupción de 2° medio y 4° básico por el estallido social.** Donde correspondía
  aplicar la medición en 4b y 2m como cada año, la Agencia informa que, debido a los incidentes
  en el país tras el 18 de octubre, la aplicación de 4° básico enfrentó alteraciones en varios
  establecimientos y la de 2° medio no pudo realizarse. Referencia pública de la Agencia de
  Calidad de la Educación sobre los resultados 2019:
  https://www.agenciaeducacion.cl/agencia-de-calidad-de-la-educacion-entrega-resultados-simce-2019-para-8-basico/
- **2020-2021, sin evaluación del sistema por pandemia** (hueco común a todos los grados; ya
  clasificado server-side como estado de pandemia en el eje histórico del motor).

## 6. Implicancia

- **(a)** Los huecos de cobertura no se tratan como deuda de datos en sesiones futuras: son
  ausencia de aplicación del instrumento, documentada aquí.
- **(b)** El motor expone solo **4b y 2m** (`10_configuracion.R`, `GRADOS_MOTOR <- c("4b","2m")`;
  el filtro es de presentación, el parquet conserva los 4 grados). Su **nota visible se limita a
  2019** (el único hueco relevante para los grados que el usuario ve). La nota visible NO menciona
  6b/8b: confundiría sobre grados que el usuario no ve.
- **(c)** La **intermitencia de 6b/8b** se documenta en esta decisión y en los comentarios de
  código (`34` y `35`), **no en la interfaz**.
- **Separación de capas (crítico):** los comentarios de código documentan la cobertura de los 4
  grados (universo del parquet); la nota visible del motor habla solo de 2019/4b/2m (universo
  que el motor expone). No se propaga el texto de una capa a la otra.
- **Invariantes que siguen 🔒:** parquet intocable (md5 `4c764d8c…`); `eje_historico` y su
  clasificación `no_eval`/`pandemia` intactos (la nota explica lo que esa lógica ya produce, no
  la duplica); sin agregación territorial; significancia siempre leída, nunca recalculada.
