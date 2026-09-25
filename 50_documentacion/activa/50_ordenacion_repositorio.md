# Marcador de la ordenación del repositorio

Este archivo apaga el gatillo de SETTINGS §1.2.2 punto 4bis: la ordenación del repositorio (SETTINGS §4.7) ya se ejecutó en este proyecto. El mantenimiento posterior lo hace el cierre de sesión.

- **Fecha:** 2026-09-25 (sesión 33, encargo s33o, T5).
- **Rama:** `ordenacion/20260925`.
- **PR:** [#4](https://github.com/tomgc/slep_idps/pull/4), con base `main`. El merge lo decide el titular.
- **Propuesta ejecutada:** `50_documentacion/andamios/20260924_propuesta_ordenacion_repositorio.md` (s33m T3), con la lectura literal (L) del grep de referencias vivas de SETTINGS §4.7.2.

## Archivos movidos por bloque

| Bloque | Movidos | Nota |
|---|---:|---|
| 1. Traspasos | 0 | Ya había un solo traspaso en `traspasos/`. |
| 2. Obsoletos y duplicados | 0 | O-1 y O-2 cancelados por la lectura (L); O-3 y O-4 eran de grado bajo (dudas). |
| 3. Nomenclatura | 0 | N-1 a N-4 cancelados por la lectura (L); N-5 a N-7 no proceden. |
| 4. Escáner | 0 | Sin movimientos; cambio del script (abajo). |

## Cambio del escáner (bloque 4)

`00_escanear_proyecto.R` excluye además `node_modules`, `packrat`, `venv` (E-1) y `.quarto` (E-2), por POLITICA §7.2. Ninguna de esas carpetas existe: la foto da 32 carpetas y 350 archivos antes y después del cambio. `.claude/` y `.DS_Store` no se excluyen (ni POLITICA §7.2 ni SETTINGS §4.7.2 los nombran). `activa/encargos/` queda como está.
