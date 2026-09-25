# Decisión: marca de base pequeña en las barras del comparador

- **Fecha:** 2026-09-25
- **Sesión:** s33 (traspaso vigente v31)
- **Encargo que la implementa:** `50_documentacion/activa/encargos/encargo_claude_code_idps_ejecucion_final_s33o.md` (T1)
- **Evidencia:** `50_documentacion/andamios/diseno/detalles/20260924_diagnostico_base_pequena.md` (generado por el script `.R` de la misma carpeta; log s33m)
- **Tipo:** decisión metodológica y de presentación. No crea ninguna cifra agregada: `N` ya existe en cada barra (hoy solo en su `title`).
- **Estado:** adoptada por el titular el 2026-09-25. Cierra la §5.2 de `20260910_decision_contraste_texto_estado.md`.

## 1. Qué es N

En cada barra 0–100 del comparador, `N` = establecimientos de la entidad en ese nivel, año y GSE con puntaje **y** comparación válida con su GSE (`sigdifgru` en −1, 0 o 1). Los que tienen puntaje sin comparación válida siguen fuera del 100 % y en su nota propia ("+k sin comparación válida"), como fija la decisión del 2026-09-17 §6.

## 2. Lo que se decide (respuestas a §9 del diagnóstico)

1. **Umbral:** `u = 5`.
2. **Desigualdad:** la marca aplica con `1 ≤ N < 5` (lectura literal de "cae bajo un umbral"). Con `N = 5` no hay marca.
3. **Alcance por tipo:** el mismo umbral para comuna, SLEP, región, nacional y las entidades acotadas a una dependencia. La entidad nacional nunca lo alcanza con el dato de 2025 (mínimo 365).
4. **N visible:** el `N` de **cada barra**, junto a la barra (alternativa b). No se muestra un `N` único por fila, porque en parte de las filas difiere entre indicadores (§7 del diagnóstico).
5. **Pantallas:** solo el comparador. El panorama (vista actual e histórica) no cambia.
6. **Barras con N = 0:** sin cambio ("sin dato", más la nota `sin` cuando corresponde). No reciben marca.

## 3. La marca

- Un asterisco junto al `N` de la barra y una nota al pie del comparador que lo explica: con menos de 5 establecimientos, un solo establecimiento mueve el reparto en 20 puntos o más. Es el medio de señal que usa `slep_simce_adecuado` (asterisco y nota, sin tocar la opacidad), trasladado a la unidad y el umbral de este motor.
- Sin opacidad ni color nuevos: el `N` y el asterisco usan los tokens de texto existentes, con contraste AA sobre los fondos donde caen.
- El `aria-label` de la barra declara la base pequeña en texto.

## 4. Lo que el dato muestra con u = 5 (4° básico 2025)

Quedan marcadas el 58,0 % de las barras de comuna, el 31,1 % de las de SLEP y el 3,8 % de las de región (§4 del diagnóstico). Es una proporción alta a propósito: el comparador trabaja con entidades pequeñas y la marca informa, no oculta.

## 5. Garantía de fidelidad

Ninguna cifra cambia: el `N` y el reparto de cada barra se leen de lo que el motor ya calcula. El payload y los CSV quedan idénticos.
