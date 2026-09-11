---
slug: slep_idps
nombre_real: Motor de comparación interactivo de los Indicadores de Desarrollo Personal y Social (IDPS)
categoria: activo
semaforo: activo
sesion_actual: s29
ultima_actividad: 2026-09-11
maneja_sensibles: false
tipo_pendiente: deuda_tecnica
---
## En que vamos
La sesión 29 (seis encargos, s29–s29f, 2026-09-09 → 2026-09-11) cerró y desplegó el comparador de entidades con contraste accesible. Comparador: entidad nacional como referencia fija, establecimientos como filas de caso individual (glifo + puntaje, cero agregación), etiquetado adaptativo de la barra por espacio real (nunca un número truncado ni un porcentaje duplicado), aviso único de EE sin ubicación. Contraste: la paleta de ESTADO no se tocó; se separó color de barra de color de texto con tres tokens `-txt`, `--gris` se corrigió en la raíz (cumple 4,5:1 en los 15 fondos claros del CSS), y chips y anclas pasaron a los tokens de texto; `--alerta-txt` quedó en `#CE112C` con margen. Decisión `20260910_decision_contraste_texto_estado.md` con dos excepciones escritas (§3.4 etiqueta blanca dentro de la barra; §3.5 glifos como componente gráfico) y una exención con fundamento (§5.3 c, componentes inactivos). Payload byte-idéntico en toda la línea. **Desplegado a `docs/index.html` el 2026-09-11** (md5 `f61ac9c5…`), que llevaba desde el 2026-07-03 sin promoverse. Backlog sin cambio de correlativo.

## Proximo paso
Decidir la §5.5 de la decisión: cuatro fallas de AA en la ficha de establecimiento, anteriores a la línea s29 y sin excepción que las cubra. La más urgente y barata es el sufijo "· sig." del ancla (`opacity:.8` inline, 3,72 → 4,61 con opacidad 1; JSX, una línea). Después `.defn-title` con color de indicador sobre blanco (hasta 1,84) y los spans "▼ rojo / ▲ azul" de `.ficha-explain`. La vista histórica (§5.3 b) sigue en backlog y pide mockup. Pendientes heredados: P-GITIGNORE-TOKEN, P-SLEPVERSE, marca de "base pequeña" (umbral metodológico sin fijar).

## Bloqueantes
ninguno
