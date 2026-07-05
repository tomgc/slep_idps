# Traspaso de cierre — slep_idps — s28

## Resumen
Resuelta cobertura histórica de la suite de documentación. Pipeline de datos
tiene cobertura real 2014–2019, 2022–2025 (hueco 2020–2021); `documentar.R`
declaraba erróneamente "2014–2025" (bloque continuo). Corregido, regenerado
y versionado.

## Commits
- `3ce836c` — docs(politica): actualiza a v5.3 (regla 0.4, regla 0.5)
- `b765158` — chore(docs): promueve motor_idps.html a docs/index.html
- `088b524` — docs: traspaso cierre s27 y rotación escáner
- `b5a3479` — docs(suite): versiona _standalone.html; gitignore ajustado;
  regenera con cobertura 2014-2019,2022-2025

Todos pusheados a `origin/main`.

## Decisión de gobernanza (esta sesión)
`.gitignore` L57 excluía `50_documentacion/suite/*.html` en su totalidad
(HTML "reproducibles con documentar.R", sin versionar). Contradice
SETTINGS_Y_PROMPTS_OPERACIONALES.md §4.6.4 punto 7 (los `*_standalone.html`
sí se versionan). Decisión explícita del titular: versionar los
`*_standalone.html`; mantener gitignorados solo los 4 HTML base (enlazados,
no standalone). `.gitignore` corregido en consecuencia.

## Verificación standalone (protocolo 4.6.4 punto 6)
- `@font-face`: 6 declaraciones, fuentes embebidas como `data:font/otf;base64`
- Iconos: verificación visual en navegador confirmada por el titular (carga
  bien); no se completó el grep de `data-lucide`/`<svg>` por archivo, dado
  que la verificación visual directa fue más concluyente
- Meta de cobertura confirmada en HTML generado: "2014–2019, 2022–2025"

## Pendientes de fondo (sin cambios esta sesión)
- Item 11 (bloqueado, sin nueva información)
- Tooltip "vs evaluación anterior": de `title` a body (cosmético, menor)

## Auditoría de apertura (s28)
Estructura consistente con escáner adjunto al cierre (32 carpetas,
286 archivos). Sin deuda estructural nueva.

## Estado del repo al cierre
`origin/main = b5a3479`. `working tree` limpio salvo `40_salidas/motor_idps.html`
(esperado, salida de build local no versionada en este punto del flujo).

## Errores del asistente esta sesión (POLITICA 0.5)
- Reformulación incorrecta del rango de cobertura antes de la corrección
  final: el titular corrigió directamente ("piensa", la imagen ilustraba
  solo el tramo posterior al hueco, no la cobertura completa). Patrón:
  inferencia apresurada sobre datos parciales sin pedir confirmación
  explícita del rango completo antes de aplicar el cambio.
- Uso de la palabra "ignorar" al referirse a warnings de locale ya
  verificados como no bloqueantes; el titular señaló correctamente que
  esto sonaba como evasión de responsabilidad en vez de una decisión
  técnica ya fundamentada.
