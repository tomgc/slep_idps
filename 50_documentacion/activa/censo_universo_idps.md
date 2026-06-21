# Censo forense del universo IDPS — por año / grado / nivel de informe (P5, fase 1)

> READ-ONLY, conservación por defecto (cero poda). Generado por `verificar_censo_universo.R` (efímero).
> Orígenes: raíz `20_insumos/` (2022-2025), `historico_2014_2018/` (recursivo), `auxiliares/`. Fecha: 2026-06-21.

## Fase A — Censo de archivos (3 orígenes)

Total xls/xlsx: **95** + `.DS_Store`: **27** (ruido de sistema, no procesado).

### Por origen × rol
| origen | datos | glosa | no_idps |
|---|---|---|---|
| auxiliar | 0 | 7 | 3 |
| historico | 34 | 24 | 0 |
| raiz | 25 | 2 | 0 |

### Sub-clasificación del histórico
| sub-grupo | datos | glosa |
|---|---|---|
| hist_ajeno2024 | 9 | 3 |
| hist_dup2223 | 7 | 3 |
| hist_real | 18 | 18 |
: hist_real=2014-2019 (objetivo) · hist_dup2223=duplicados 2022/2023 · hist_ajeno2024=2024 mal ubicado.

### Duplicados histórico ↔ raíz (byte-check)
| archivo histórico | gemelo en raíz | md5 |
|---|---|---|
| `idps2m2022_rbd_dim_final.xlsx` | `idps2m2022_rbd_dim_final.xlsx` | byte-idéntico |
| `idps2m2022_rbd_final.xlsx` | `idps2m2022_rbd_final.xlsx` | byte-idéntico |
| `idps2m2022_rbd_glosa_pu<cc><81>blica_final.xlsx` | `idps2m2022_rbd_glosa_pu<cc><81>blica_final.xlsx` | no comparable |
| `idps4b2022_rbd_dim_final.xlsx` | `idps4b2022_rbd_dim_final.xlsx` | byte-idéntico |
| `idps4b2022_rbd_final.xlsx` | `idps4b2022_rbd_final.xlsx` | byte-idéntico |
| `idps4b2022_rbd_glosa_pu<cc><81>blica_final.xlsx` | `idps4b2022_rbd_glosa_pu<cc><81>blica_final.xlsx` | no comparable |
| `idps4b2023_GLOSAS_rbd_pu<cc><81>blico_final.xlsx` | **NO está en raíz** | NA |
| `idps4b2023_rbd_dim_final.xlsx` | `idps4b2023_rbd_dim_final.xlsx` | byte-idéntico |
| `idps4b2023_rbd_final.xlsx` | `idps4b2023_rbd_final.xlsx` | byte-idéntico |
| `idps4b_niveles_final.xlsx` | **NO está en raíz** | NA |

### Material 2024 en `historico/` (¿duplica la raíz o es único?)
| archivo (historico) | mismo nombre en raíz? |
|---|---|
| `idps2M2024_rbd_dim_final.xlsx` | sí (duplica raíz) |
| `idps2M2024_rbd_final.xlsx` | sí (duplica raíz) |
| `idps2M2024_rbd_niveles_final.xlsx` | sí (duplica raíz) |
| `idps4B2024_rbd_dim_final.xlsx` | **NO (único aquí)** |
| `idps4B2024_rbd_final.xlsx` | **NO (único aquí)** |
| `idps4B2024_rbd_niveles_final.xlsx` | **NO (único aquí)** |
| `idps6B2024_rbd_dim_preliminar.xlsx` | sí (duplica raíz) |
| `idps6B2024_rbd_niveles_preliminar.xlsx` | sí (duplica raíz) |
| `idps6B2024_rbd_preliminar.xlsx` | sí (duplica raíz) |

### Archivos no-IDPS en `auxiliares/` (mencionados, NO censados como datos)
- `caracterizacion_establecimientos.xlsx`
- `diccionario_territorios.xlsx`
- `listado_slep_2026.xlsx`

## Fase B — Perfilado forense por archivo de datos (todos los orígenes)

### `20_insumos/historico_2014_2018/idps2m2014/idps2m2014_rbd.xls`
- origen=historico · año-nombre=2014 · grado=2m · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (2747×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2014} vs año-nombre=2014 · grado-dato={2m} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2747; alta cardinalidad (2747), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2014(2747)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(2747)
  - `ind_am`: NA=6 (0.2%), distintos=27; MEDIDA min=54 max=85 media=73.8 fuera0-100=0
  - `ind_cc`: NA=105 (3.8%), distintos=38; MEDIDA min=46 max=94 media=75 fuera0-100=0
  - `ind_pf`: NA=21 (0.8%), distintos=48; MEDIDA min=43 max=97 media=76.9 fuera0-100=0
  - `ind_hv`: NA=6 (0.2%), distintos=47; MEDIDA min=43 max=92 media=70.1 fuera0-100=0

### `20_insumos/historico_2014_2018/idps4b2014/idps4b2014_rbd.xls`
- origen=historico · año-nombre=2014 · grado=4b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7562×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2014} vs año-nombre=2014 · grado-dato={4b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7562; alta cardinalidad (7562), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2014(7562)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(7562)
  - `ind_am`: NA=62 (0.8%), distintos=61; MEDIDA min=29 max=100 media=74.1 fuera0-100=0
  - `ind_cc`: NA=472 (6.2%), distintos=54; MEDIDA min=27 max=98 media=76 fuera0-100=0
  - `ind_pf`: NA=278 (3.7%), distintos=65; MEDIDA min=20 max=100 media=78 fuera0-100=0
  - `ind_hv`: NA=48 (0.6%), distintos=67; MEDIDA min=26 max=100 media=71.2 fuera0-100=0

### `20_insumos/historico_2014_2018/idps6b2014/idps6b2014_rbd.xls`
- origen=historico · año-nombre=2014 · grado=6b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7478×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2014} vs año-nombre=2014 · grado-dato={6b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7478; alta cardinalidad (7478), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2014(7478)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(7478)
  - `ind_am`: NA=42 (0.6%), distintos=53; MEDIDA min=31 max=100 media=75.7 fuera0-100=0
  - `ind_cc`: NA=701 (9.4%), distintos=53; MEDIDA min=27 max=99 media=77.4 fuera0-100=0
  - `ind_pf`: NA=278 (3.7%), distintos=62; MEDIDA min=24 max=100 media=79.1 fuera0-100=0
  - `ind_hv`: NA=36 (0.5%), distintos=63; MEDIDA min=16 max=100 media=72.7 fuera0-100=0

### `20_insumos/historico_2014_2018/idps8b2014/idps8b2014_rbd.xls`
- origen=historico · año-nombre=2014 · grado=8b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (5905×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2014} vs año-nombre=2014 · grado-dato={8b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=5905; alta cardinalidad (5905), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2014(5905)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(5905)
  - `ind_am`: NA=15 (0.3%), distintos=47; MEDIDA min=42 max=96 media=74.3 fuera0-100=0
  - `ind_cc`: NA=344 (5.8%), distintos=46; MEDIDA min=48 max=96 media=75.7 fuera0-100=0
  - `ind_pf`: NA=84 (1.4%), distintos=54; MEDIDA min=43 max=100 media=77.5 fuera0-100=0
  - `ind_hv`: NA=17 (0.3%), distintos=58; MEDIDA min=42 max=100 media=71.4 fuera0-100=0

### `20_insumos/historico_2014_2018/idps2m2015/idps2m2015_rbd.xls`
- origen=historico · año-nombre=2015 · grado=2m · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (2864×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2015} vs año-nombre=2015 · grado-dato={2m} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2864; alta cardinalidad (2864), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2015(2864)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(2864)
  - `ind_am`: NA=2 (0.1%), distintos=29; MEDIDA min=60 max=100 media=74.1 fuera0-100=0
  - `ind_cc`: NA=58 (2%), distintos=38; MEDIDA min=57 max=97 media=75.1 fuera0-100=0
  - `ind_pf`: NA=10 (0.3%), distintos=46; MEDIDA min=51 max=100 media=77.2 fuera0-100=0
  - `ind_hv`: NA=2 (0.1%), distintos=39; MEDIDA min=50 max=97 media=69.8 fuera0-100=0

### `20_insumos/historico_2014_2018/idps4b2015/idps4b2015_rbd.xls`
- origen=historico · año-nombre=2015 · grado=4b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7441×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2015} vs año-nombre=2015 · grado-dato={4b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7441; alta cardinalidad (7441), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2015(7441)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(7441)
  - `ind_am`: NA=58 (0.8%), distintos=60; MEDIDA min=32 max=100 media=74.3 fuera0-100=0
  - `ind_cc`: NA=459 (6.2%), distintos=49; MEDIDA min=22 max=98 media=76.3 fuera0-100=0
  - `ind_pf`: NA=314 (4.2%), distintos=65; MEDIDA min=32 max=100 media=77.5 fuera0-100=0
  - `ind_hv`: NA=65 (0.9%), distintos=62; MEDIDA min=16 max=99 media=70.6 fuera0-100=0

### `20_insumos/historico_2014_2018/idps6b2015/idps6b2015_rbd.xls`
- origen=historico · año-nombre=2015 · grado=6b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7396×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2015} vs año-nombre=2015 · grado-dato={6b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7396; alta cardinalidad (7396), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2015(7396)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(7396)
  - `ind_am`: NA=62 (0.8%), distintos=56; MEDIDA min=37 max=100 media=75.8 fuera0-100=0
  - `ind_cc`: NA=367 (5%), distintos=50; MEDIDA min=43 max=99 media=77.5 fuera0-100=0
  - `ind_pf`: NA=310 (4.2%), distintos=59; MEDIDA min=23 max=100 media=79 fuera0-100=0
  - `ind_hv`: NA=77 (1%), distintos=58; MEDIDA min=39 max=100 media=72.3 fuera0-100=0

### `20_insumos/historico_2014_2018/idps8b2015/idps8b2015_rbd.xls`
- origen=historico · año-nombre=2015 · grado=8b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (5946×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `ind_am`, `ind_cc`, `ind_pf`, `ind_hv`
- cruce: agno-dato={2015} vs año-nombre=2015 · grado-dato={8b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=5946; alta cardinalidad (5946), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2015(5946)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(5946)
  - `ind_am`: NA=13 (0.2%), distintos=46; MEDIDA min=51 max=99 media=74.6 fuera0-100=0
  - `ind_cc`: NA=160 (2.7%), distintos=48; MEDIDA min=51 max=98 media=75.5 fuera0-100=0
  - `ind_pf`: NA=34 (0.6%), distintos=52; MEDIDA min=28 max=100 media=77.4 fuera0-100=0
  - `ind_hv`: NA=9 (0.2%), distintos=55; MEDIDA min=40 max=98 media=70.7 fuera0-100=0

### `20_insumos/historico_2014_2018/idps2m2016/idps2m2016_rbd.xls`
- origen=historico · año-nombre=2016 · grado=2m · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (2891×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `agno`, `grado`, `rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2016} vs año-nombre=2016 · grado-dato={2m} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2016(2891)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(2891)
  - `rbd`: NA=0 (0%), distintos=2891; alta cardinalidad (2891), rango[1..9986]
  - `ind_am`: NA=1 (0%), distintos=29; MEDIDA min=57 max=90 media=73.9 fuera0-100=0
  - `ind_cc`: NA=101 (3.5%), distintos=39; MEDIDA min=51 max=94 media=75.1 fuera0-100=0
  - `ind_hv`: NA=1 (0%), distintos=45; MEDIDA min=41 max=92 media=70 fuera0-100=0
  - `ind_pf`: NA=12 (0.4%), distintos=46; MEDIDA min=48 max=95 media=77.4 fuera0-100=0

### `20_insumos/historico_2014_2018/idps4b2016/idps4b2016_rbd.xls`
- origen=historico · año-nombre=2016 · grado=4b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7390×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `agno`, `grado`, `rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2016} vs año-nombre=2016 · grado-dato={4b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2016(7390)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(7390)
  - `rbd`: NA=0 (0%), distintos=7390; alta cardinalidad (7390), rango[10..9999]
  - `ind_am`: NA=63 (0.9%), distintos=61; MEDIDA min=32 max=98 media=73.7 fuera0-100=0
  - `ind_cc`: NA=782 (10.6%), distintos=50; MEDIDA min=46 max=99 media=75.8 fuera0-100=0
  - `ind_hv`: NA=61 (0.8%), distintos=69; MEDIDA min=8 max=100 media=70.3 fuera0-100=0
  - `ind_pf`: NA=251 (3.4%), distintos=62; MEDIDA min=16 max=100 media=78 fuera0-100=0

### `20_insumos/historico_2014_2018/idps6b2016/idps6b2016_rbd.xls`
- origen=historico · año-nombre=2016 · grado=6b · patrón `final/preliminar`: FALSE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7328×7)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `agno`, `grado`, `rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2016} vs año-nombre=2016 · grado-dato={6b} · rbd duplicados=0 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2016(7328)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(7328)
  - `rbd`: NA=0 (0%), distintos=7328; alta cardinalidad (7328), rango[10..9999]
  - `ind_am`: NA=66 (0.9%), distintos=59; MEDIDA min=28 max=100 media=74.7 fuera0-100=0
  - `ind_cc`: NA=352 (4.8%), distintos=51; MEDIDA min=43 max=100 media=76.9 fuera0-100=0
  - `ind_hv`: NA=42 (0.6%), distintos=69; MEDIDA min=18 max=100 media=71.6 fuera0-100=0
  - `ind_pf`: NA=250 (3.4%), distintos=57; MEDIDA min=35 max=100 media=79 fuera0-100=0

### `20_insumos/historico_2014_2018/idps2m2017/idps2m2017_rbd_final.xlsx`
- origen=historico · año-nombre=2017 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Sheet1` · hoja datos=`Sheet1` (2912×18)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `agno`, `grado`, `rbd`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2017} vs año-nombre=2017 · grado-dato={2m} · rbd duplicados=0 · cod_depe2 en TEXTO={Municipal,Particular pagado,Particular subvencionado}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2017(2912)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(2912)
  - `rbd`: NA=0 (0%), distintos=2912; alta cardinalidad (2912), rango[1..9986]
  - `cod_reg_rbd`: NA=0 (0%), distintos=15; VALORES: 13(1048), 5(377), 8(325), 9(176), 7(168), 10(157), 4(153), 6(151), 14(84), 2(83), 1(62), 3(38), 15(34), 12(31), 11(25)
  - `cod_pro_rbd`: NA=0 (0%), distintos=8; alta cardinalidad (8), rango[1..8]
  - `cod_com_rbd`: NA=0 (0%), distintos=330; alta cardinalidad (330), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: Particular subvencionado(1690), Municipal(823), Particular pagado(399)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: Medio bajo(829), Medio(679), Bajo(638), Alto(394), Medio alto(372)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: Urbano(2748), Rural(164)
  - `ind_am`: NA=3 (0.1%), distintos=2909; MEDIDA min=61.1 max=91.4 media=74.4 fuera0-100=0
  - `ind_cc`: NA=63 (2.2%), distintos=2849; MEDIDA min=59.8 max=93.9 media=75.6 fuera0-100=0
  - `ind_hv`: NA=3 (0.1%), distintos=2909; MEDIDA min=48.4 max=93.2 media=70.5 fuera0-100=0
  - `ind_pf`: NA=3 (0.1%), distintos=2909; MEDIDA min=38.8 max=97.5 media=77.4 fuera0-100=0

### `20_insumos/historico_2014_2018/idps4b2017/idps4b2017_rbd_final.xlsx`
- origen=historico · año-nombre=2017 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Sheet1` · hoja datos=`Sheet1` (7384×18)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `agno`, `grado`, `rbd`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2017} vs año-nombre=2017 · grado-dato={4b} · rbd duplicados=0 · cod_depe2 en TEXTO={Municipal,Particular pagado,Particular subvencionado}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2017(7384)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(7384)
  - `rbd`: NA=1 (0%), distintos=7383; alta cardinalidad (7383), rango[10..9999]
  - `cod_reg_rbd`: NA=1 (0%), distintos=15; VALORES: 13(1778), 8(992), 9(841), 5(759), 10(677), 7(568), 4(462), 6(448), 14(318), 2(136), 1(106), 3(106), 15(77), 11(60), 12(55)
  - `cod_pro_rbd`: NA=1 (0%), distintos=8; alta cardinalidad (8), rango[1..8]
  - `cod_com_rbd`: NA=1 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=1 (0%), distintos=3; VALORES: Municipal(3920), Particular subvencionado(3026), Particular pagado(437)
  - `cod_grupo`: NA=41 (0.6%), distintos=5; VALORES: Medio bajo(2615), Bajo(2056), Medio(1597), Medio alto(640), Alto(435)
  - `cod_rural_rbd`: NA=1 (0%), distintos=2; VALORES: Urbano(4515), Rural(2868)
  - `ind_am`: NA=101 (1.4%), distintos=7273; MEDIDA min=12.1 max=97.8 media=73.9 fuera0-100=0
  - `ind_cc`: NA=354 (4.8%), distintos=7029; MEDIDA min=33.3 max=98.3 media=75.6 fuera0-100=0
  - `ind_hv`: NA=90 (1.2%), distintos=7281; MEDIDA min=4 max=99.2 media=71.1 fuera0-100=0
  - `ind_pf`: NA=85 (1.2%), distintos=7266; MEDIDA min=23.4 max=100 media=78.1 fuera0-100=0

### `20_insumos/historico_2014_2018/idps8b2017/idps8b2017_rbd_final.xlsx`
- origen=historico · año-nombre=2017 · grado=8b · patrón `final/preliminar`: TRUE
- hojas: `Sheet1` · hoja datos=`Sheet1` (5982×18)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `agno`, `grado`, `rbd`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2017} vs año-nombre=2017 · grado-dato={8b} · rbd duplicados=0 · cod_depe2 en TEXTO={Municipal,Particular pagado,Particular subvencionado}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2017(5982)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(5982)
  - `rbd`: NA=0 (0%), distintos=5982; alta cardinalidad (5982), rango[10..9999]
  - `cod_reg_rbd`: NA=0 (0%), distintos=15; VALORES: 13(1751), 8(794), 5(686), 9(530), 7(448), 10(432), 6(359), 4(314), 14(184), 2(131), 1(97), 3(87), 15(65), 12(55), 11(49)
  - `cod_pro_rbd`: NA=0 (0%), distintos=8; alta cardinalidad (8), rango[1..8]
  - `cod_com_rbd`: NA=0 (0%), distintos=343; alta cardinalidad (343), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: Municipal(2944), Particular subvencionado(2616), Particular pagado(422)
  - `cod_grupo`: NA=8 (0.1%), distintos=5; VALORES: Medio bajo(1985), Bajo(1488), Medio(1405), Medio alto(658), Alto(438)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: Urbano(4536), Rural(1446)
  - `ind_am`: NA=10 (0.2%), distintos=5972; MEDIDA min=51.2 max=100 media=75 fuera0-100=0
  - `ind_cc`: NA=117 (2%), distintos=5865; MEDIDA min=53.7 max=98.8 media=76.3 fuera0-100=0
  - `ind_hv`: NA=9 (0.2%), distintos=5973; MEDIDA min=39.2 max=100 media=71.6 fuera0-100=0
  - `ind_pf`: NA=8 (0.1%), distintos=5971; MEDIDA min=41.8 max=100 media=78.2 fuera0-100=0

### `20_insumos/historico_2014_2018/IDPS2m2018/idps_2m2018.xlsx`
- origen=historico · año-nombre=2018 · grado=2m · patrón `final/preliminar`: FALSE
- hojas: `idps_2m2018` · hoja datos=`idps_2m2018` (2935×29)
- **NIVEL DE INFORME: I·D** · formato: ancho
- columnas: `rbd`, `nom_rbd`, `cod_reg_rbd`, `cod_pro_rbd`, `cod_com_rbd`, `nom_regi_n`, `nom_provincia`, `cod_deprov`, `nom_deprov`, `nom_comuna`, `grado`, `ind_am_rbd`, `dim_am_aa_rbd`, `dim_am_me_rbd`, `ind_cc_rbd`, `dim_cc_ao_rbd`, `dim_cc_ar_rbd`, `dim_cc_as_rbd`, `ind_hv_rbd`, `dim_hv_ac_rbd`, `dim_hv_ha_rbd`, `dim_hv_va_rbd`, `ind_pf_rbd`, `dim_pf_pa_rbd`, `dim_pf_sp_rbd`, `dim_pf_vd_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`
- cruce: agno-dato={} vs año-nombre=2018 · grado-dato={2m} · rbd duplicados=0 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2935; alta cardinalidad (2935), rango[1..9986]
  - `cod_reg_rbd`: NA=5 (0.2%), distintos=15; VALORES: 13(1048), 5(382), 8(332), 9(178), 7(168), 10(159), 4(153), 6(149), 2(85), 14(84), 1(62), 3(38), 15(35), 12(32), 11(25)
  - `cod_pro_rbd`: NA=5 (0.2%), distintos=54; alta cardinalidad (54), rango[101..92]
  - `cod_com_rbd`: NA=5 (0.2%), distintos=330; alta cardinalidad (330), rango[10101..9211]
  - `cod_deprov`: NA=97 (3.3%), distintos=41
  - `grado`: NA=5 (0.2%), distintos=1; VALORES: 2m(2930)
  - `ind_am_rbd`: NA=5 (0.2%), distintos=2930; MEDIDA min=58.2 max=92.1 media=74.5 fuera0-100=0
  - `dim_am_aa_rbd`: NA=5 (0.2%), distintos=2930; MEDIDA min=55.1 max=90.3 media=72.7 fuera0-100=0
  - `dim_am_me_rbd`: NA=5 (0.2%), distintos=2930; MEDIDA min=58.9 max=97.9 media=76.3 fuera0-100=0
  - `ind_cc_rbd`: NA=35 (1.2%), distintos=2900; MEDIDA min=51.1 max=94.3 media=75.6 fuera0-100=0
  - `dim_cc_ao_rbd`: NA=35 (1.2%), distintos=2900; MEDIDA min=61.1 max=97.6 media=81.2 fuera0-100=0
  - `dim_cc_ar_rbd`: NA=35 (1.2%), distintos=2900; MEDIDA min=48.4 max=91.6 media=69.8 fuera0-100=0
  - `dim_cc_as_rbd`: NA=35 (1.2%), distintos=2900; MEDIDA min=43.7 max=97.4 media=75.8 fuera0-100=0
  - `ind_hv_rbd`: NA=6 (0.2%), distintos=2929; MEDIDA min=44.3 max=92.1 media=70.5 fuera0-100=0
  - `dim_hv_ac_rbd`: NA=6 (0.2%), distintos=2929; MEDIDA min=45.2 max=97.8 media=76.6 fuera0-100=0
  - `dim_hv_ha_rbd`: NA=6 (0.2%), distintos=2929; MEDIDA min=44.7 max=94.6 media=71.6 fuera0-100=0
  - `dim_hv_va_rbd`: NA=6 (0.2%), distintos=2929; MEDIDA min=27.6 max=87.7 media=63.4 fuera0-100=0
  - `ind_pf_rbd`: NA=6 (0.2%), distintos=2929; MEDIDA min=43.7 max=95.6 media=77.5 fuera0-100=0
  - `dim_pf_pa_rbd`: NA=6 (0.2%), distintos=2929; MEDIDA min=44.2 max=97.3 media=76.9 fuera0-100=0
  - `dim_pf_sp_rbd`: NA=6 (0.2%), distintos=2928; MEDIDA min=29.1 max=99.1 media=77.2 fuera0-100=0
  - `dim_pf_vd_rbd`: NA=6 (0.2%), distintos=2928; MEDIDA min=45.7 max=98.7 media=78.3 fuera0-100=0
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(1653), 1(803), 3(444), 4(35)
  - `cod_grupo`: NA=5 (0.2%), distintos=5; VALORES: 2(855), 1(725), 3(628), 5(380), 4(342)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(2769), 2(166)

### `20_insumos/historico_2014_2018/IDPS4b2018/idps_4b2018.xlsx`
- origen=historico · año-nombre=2018 · grado=4b · patrón `final/preliminar`: FALSE
- hojas: `idps_4b2018` · hoja datos=`idps_4b2018` (7414×29)
- **NIVEL DE INFORME: I·D** · formato: ancho
- columnas: `rbd`, `nom_rbd`, `cod_reg_rbd`, `cod_pro_rbd`, `cod_com_rbd`, `nom_regi_n`, `nom_provincia`, `cod_deprov`, `nom_deprov`, `nom_comuna`, `grado`, `ind_am_rbd`, `dim_am_aa_rbd`, `dim_am_me_rbd`, `ind_cc_rbd`, `dim_cc_ao_rbd`, `dim_cc_ar_rbd`, `dim_cc_as_rbd`, `ind_hv_rbd`, `dim_hv_ac_rbd`, `dim_hv_ha_rbd`, `dim_hv_va_rbd`, `ind_pf_rbd`, `dim_pf_pa_rbd`, `dim_pf_sp_rbd`, `dim_pf_vd_rbd`, `cod_grupo`, `cod_rural_rbd`, `cod_depe2`
- cruce: agno-dato={} vs año-nombre=2018 · grado-dato={4b} · rbd duplicados=0 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7414; alta cardinalidad (7414), rango[10..9999]
  - `cod_reg_rbd`: NA=73 (1%), distintos=15; VALORES: 13(1774), 8(972), 9(825), 5(755), 10(669), 7(569), 4(467), 6(444), 14(325), 2(135), 1(106), 3(106), 15(79), 11(59), 12(56)
  - `cod_pro_rbd`: NA=73 (1%), distintos=54; alta cardinalidad (54), rango[101..92]
  - `cod_com_rbd`: NA=73 (1%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_deprov`: NA=372 (5%), distintos=41
  - `grado`: NA=73 (1%), distintos=1; VALORES: 4b(7341)
  - `ind_am_rbd`: NA=160 (2.2%), distintos=7225; MEDIDA min=11.7 max=95.7 media=73.9 fuera0-100=0
  - `dim_am_aa_rbd`: NA=147 (2%), distintos=7096; MEDIDA min=24.1 max=94.9 media=71.8 fuera0-100=0
  - `dim_am_me_rbd`: NA=156 (2.1%), distintos=6614; MEDIDA min=9.8 max=96.5 media=76 fuera0-100=0
  - `ind_cc_rbd`: NA=363 (4.9%), distintos=7044; MEDIDA min=41.3 max=97.8 media=75.9 fuera0-100=0
  - `dim_cc_ao_rbd`: NA=361 (4.9%), distintos=6956; MEDIDA min=43.9 max=100 media=82.1 fuera0-100=0
  - `dim_cc_ar_rbd`: NA=357 (4.8%), distintos=7022; MEDIDA min=15.1 max=93.4 media=69.9 fuera0-100=0
  - `dim_cc_as_rbd`: NA=362 (4.9%), distintos=6965; MEDIDA min=36.1 max=100 media=75.6 fuera0-100=0
  - `ind_hv_rbd`: NA=152 (2.1%), distintos=7251; MEDIDA min=20.3 max=98.6 media=71 fuera0-100=0
  - `dim_hv_ac_rbd`: NA=151 (2%), distintos=6508; MEDIDA min=26.3 max=100 media=77.2 fuera0-100=0
  - `dim_hv_ha_rbd`: NA=150 (2%), distintos=7126; MEDIDA min=10.4 max=100 media=71.7 fuera0-100=0
  - `dim_hv_va_rbd`: NA=151 (2%), distintos=6750; MEDIDA min=0 max=95.8 media=64.1 fuera0-100=0
  - `ind_pf_rbd`: NA=147 (2%), distintos=7222; MEDIDA min=18.6 max=99.1 media=78.5 fuera0-100=0
  - `dim_pf_pa_rbd`: NA=146 (2%), distintos=7147; MEDIDA min=28.8 max=100 media=78 fuera0-100=0
  - `dim_pf_sp_rbd`: NA=139 (1.9%), distintos=6327; MEDIDA min=0 max=97.2 media=78.7 fuera0-100=0
  - `dim_pf_vd_rbd`: NA=146 (2%), distintos=6446; MEDIDA min=6.6 max=100 media=78.7 fuera0-100=0
  - `cod_grupo`: NA=108 (1.5%), distintos=5; VALORES: 2(2624), 1(2000), 3(1650), 4(586), 5(446)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(4529), 2(2885)
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 1(3774), 2(3151), 3(489)

### `20_insumos/historico_2014_2018/IDPS6b2018/idps_6b2018.xlsx`
- origen=historico · año-nombre=2018 · grado=6b · patrón `final/preliminar`: FALSE
- hojas: `idps_6b2018` · hoja datos=`idps_6b2018` (7322×29)
- **NIVEL DE INFORME: I·D** · formato: ancho
- columnas: `rbd`, `nom_rbd`, `cod_reg_rbd`, `cod_pro_rbd`, `cod_com_rbd`, `nom_regi_n`, `nom_provincia`, `cod_deprov`, `nom_deprov`, `nom_comuna`, `grado`, `ind_am_rbd`, `dim_am_aa_rbd`, `dim_am_me_rbd`, `ind_cc_rbd`, `dim_cc_ao_rbd`, `dim_cc_ar_rbd`, `dim_cc_as_rbd`, `ind_hv_rbd`, `dim_hv_ac_rbd`, `dim_hv_ha_rbd`, `dim_hv_va_rbd`, `ind_pf_rbd`, `dim_pf_pa_rbd`, `dim_pf_sp_rbd`, `dim_pf_vd_rbd`, `cod_grupo`, `cod_rural_rbd`, `cod_depe2`
- cruce: agno-dato={} vs año-nombre=2018 · grado-dato={6b} · rbd duplicados=0 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7322; alta cardinalidad (7322), rango[10..9999]
  - `cod_reg_rbd`: NA=76 (1%), distintos=15; VALORES: 13(1758), 8(981), 9(817), 5(748), 10(645), 7(553), 4(453), 6(438), 14(315), 2(136), 1(112), 3(97), 15(78), 11(58), 12(57)
  - `cod_pro_rbd`: NA=76 (1%), distintos=54; alta cardinalidad (54), rango[101..92]
  - `cod_com_rbd`: NA=76 (1%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_deprov`: NA=375 (5.1%), distintos=41
  - `grado`: NA=76 (1%), distintos=1; VALORES: 6b(7246)
  - `ind_am_rbd`: NA=154 (2.1%), distintos=7146; MEDIDA min=14 max=98 media=74.9 fuera0-100=0
  - `dim_am_aa_rbd`: NA=144 (2%), distintos=6982; MEDIDA min=12.8 max=96.8 media=72.6 fuera0-100=0
  - `dim_am_me_rbd`: NA=152 (2.1%), distintos=6537; MEDIDA min=13.4 max=99.2 media=77.1 fuera0-100=0
  - `ind_cc_rbd`: NA=344 (4.7%), distintos=6973; MEDIDA min=37.7 max=98.5 media=77.2 fuera0-100=0
  - `dim_cc_ao_rbd`: NA=344 (4.7%), distintos=6812; MEDIDA min=40.4 max=100 media=83.1 fuera0-100=0
  - `dim_cc_ar_rbd`: NA=341 (4.7%), distintos=6961; MEDIDA min=28.4 max=95.5 media=71.4 fuera0-100=0
  - `dim_cc_as_rbd`: NA=341 (4.7%), distintos=6859; MEDIDA min=28.4 max=100 media=77.3 fuera0-100=0
  - `ind_hv_rbd`: NA=146 (2%), distintos=7164; MEDIDA min=37.8 max=99.4 media=72.4 fuera0-100=0
  - `dim_hv_ac_rbd`: NA=144 (2%), distintos=6321; MEDIDA min=8.3 max=100 media=78.6 fuera0-100=0
  - `dim_hv_ha_rbd`: NA=145 (2%), distintos=7048; MEDIDA min=40.7 max=100 media=73.3 fuera0-100=0
  - `dim_hv_va_rbd`: NA=144 (2%), distintos=6638; MEDIDA min=12.6 max=98.3 media=65.3 fuera0-100=0
  - `ind_pf_rbd`: NA=152 (2.1%), distintos=7126; MEDIDA min=26.9 max=100 media=79.7 fuera0-100=0
  - `dim_pf_pa_rbd`: NA=152 (2.1%), distintos=7034; MEDIDA min=39.9 max=100 media=78.7 fuera0-100=0
  - `dim_pf_sp_rbd`: NA=139 (1.9%), distintos=6354; MEDIDA min=11.2 max=100 media=80.4 fuera0-100=0
  - `dim_pf_vd_rbd`: NA=151 (2.1%), distintos=6270; MEDIDA min=13.2 max=100 media=80.2 fuera0-100=0
  - `cod_grupo`: NA=108 (1.5%), distintos=5; VALORES: 2(2557), 1(2123), 3(1541), 4(572), 5(421)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(4496), 2(2826)
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 1(3724), 2(3115), 3(483)

### `20_insumos/historico_2014_2018/idps8b2019/idps19_rbd.xlsx`
- origen=historico · año-nombre=2019 · grado=8b · patrón `final/preliminar`: FALSE
- hojas: `idps19_rbd` · hoja datos=`idps19_rbd` (5960×18)
- **NIVEL DE INFORME: I** · formato: ancho
- columnas: `rbd`, `agno`, `grado`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `ind_am`, `ind_cc`, `ind_hv`, `ind_pf`
- cruce: agno-dato={2019} vs año-nombre=2019 · grado-dato={8b} · rbd duplicados=0 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=5960; alta cardinalidad (5960), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2019(5960)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(5960)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(1737), 5(686), 8(557), 9(530), 7(447), 10(436), 6(357), 4(316), 16(231), 14(184), 2(131), 1(95), 3(86), 15(65), 12(53), 11(49)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 1(2931), 2(2556), 3(473)
  - `cod_grupo`: NA=7 (0.1%), distintos=5; VALORES: 2(2129), 3(1595), 1(1193), 4(574), 5(462)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(4522), 2(1438)
  - `ind_am`: NA=0 (0%), distintos=5960; MEDIDA min=45.5 max=98 media=75.1 fuera0-100=0
  - `ind_cc`: NA=33 (0.6%), distintos=5927; MEDIDA min=54.5 max=98.9 media=76.5 fuera0-100=0
  - `ind_hv`: NA=1 (0%), distintos=5959; MEDIDA min=40.7 max=97.4 media=71.8 fuera0-100=0
  - `ind_pf`: NA=1 (0%), distintos=5959; MEDIDA min=47.6 max=100 media=78.5 fuera0-100=0

### `20_insumos/historico_2014_2018/idps2m2022/idps2m2022_rbd_dim_final.xlsx`
- origen=historico · año-nombre=2022 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (32736×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={2} · rbd duplicados=29760 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2976; alta cardinalidad (2976), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(32736)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(32736)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(8928), HV(8928), PF(8928), AM(5952)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(2976), AC(2976), AO(2976), AR(2976), AS(2976), HA(2976), ME(2976), PA(2976), SP(2976), VA(2976), VD(2976)
  - `prom`: NA=96 (0.3%), distintos=66; MEDIDA min=34 max=99 media=74.6 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(11627), 5(4257), 8(2750), 9(1958), 7(1914), 10(1793), 4(1716), 6(1683), 16(1045), 2(946), 14(913), 1(660), 3(440), 15(396), 12(352), 11(286)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=332; alta cardinalidad (332), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(18392), 1(8118), 3(4928), 4(1298)
  - `cod_grupo`: NA=44 (0.1%), distintos=5; VALORES: 2(9295), 3(7590), 1(7260), 5(4686), 4(3861)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(30910), 2(1826)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(32736)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240603v1(32736)

### `20_insumos/historico_2014_2018/idps2m2022/idps2m2022_rbd_final.xlsx`
- origen=historico · año-nombre=2022 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (11904×16)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={2} · rbd duplicados=8928 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2976; alta cardinalidad (2976), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(11904)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(11904)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(2976), CC(2976), HV(2976), PF(2976)
  - `prom`: NA=34 (0.3%), distintos=44; MEDIDA min=52 max=95 media=74.6 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(4228), 5(1548), 8(1000), 9(712), 7(696), 10(652), 4(624), 6(612), 16(380), 2(344), 14(332), 1(240), 3(160), 15(144), 12(128), 11(104)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=332; alta cardinalidad (332), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 2(6688), 1(3424), 3(1792)
  - `cod_grupo`: NA=16 (0.1%), distintos=5; VALORES: 2(3380), 3(2760), 1(2640), 5(1704), 4(1404)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(11240), 2(664)

### `20_insumos/historico_2014_2018/idps4b2022/idps4b2022_rbd_dim_final.xlsx`
- origen=historico · año-nombre=2022 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (78815×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={4} · rbd duplicados=71650 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7165; alta cardinalidad (7165), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(78815)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(78815)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21495), HV(21495), PF(21495), AM(14330)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7165), AC(7165), AO(7165), AR(7165), AS(7165), HA(7165), ME(7165), PA(7165), SP(7165), VA(7165), VD(7165)
  - `prom`: NA=6773 (8.6%), distintos=79; MEDIDA min=0 max=100 media=75 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19294), 9(8679), 5(8206), 8(7249), 10(6941), 7(6171), 4(4851), 6(4829), 14(3410), 16(3179), 2(1496), 1(1188), 3(1188), 15(869), 11(649), 12(616)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(36586), 2(31757), 3(5269), 4(5203)
  - `cod_grupo`: NA=1001 (1.3%), distintos=5; VALORES: 2(26378), 1(20251), 3(18546), 4(7128), 5(5511)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49698), 2(29117)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240531(78815)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final202400603v1(78815)

### `20_insumos/historico_2014_2018/idps4b2022/idps4b2022_rbd_final.xlsx`
- origen=historico · año-nombre=2022 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28660×16)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={4} · rbd duplicados=21495 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7165; alta cardinalidad (7165), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(28660)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(28660)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7165), CC(7165), HV(7165), PF(7165)
  - `prom`: NA=2489 (8.7%), distintos=65; MEDIDA min=30 max=99 media=74.9 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7016), 9(3156), 5(2984), 8(2636), 10(2524), 7(2244), 4(1764), 6(1756), 14(1240), 16(1156), 2(544), 1(432), 3(432), 15(316), 11(236), 12(224)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 1(15196), 2(11548), 3(1916)
  - `cod_grupo`: NA=364 (1.3%), distintos=5; VALORES: 2(9592), 1(7364), 3(6744), 4(2592), 5(2004)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18072), 2(10588)

### `20_insumos/historico_2014_2018/idps4b2023/idps4b2023_rbd_dim_final.xlsx`
- origen=historico · año-nombre=2023 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (77473×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `grado`, `agno`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={4} · rbd duplicados=70430 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7043; alta cardinalidad (7043), rango[10..9999]
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(77473)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(77473)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21129), HV(21129), PF(21129), AM(14086)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7043), AC(7043), AO(7043), AR(7043), AS(7043), HA(7043), ME(7043), PA(7043), SP(7043), VA(7043), VD(7043)
  - `prom`: NA=5714 (7.4%), distintos=77; MEDIDA min=8 max=100 media=75.1 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19261), 9(8349), 5(8294), 8(7040), 10(6787), 7(6050), 6(4807), 4(4741), 14(3333), 16(3080), 2(1518), 1(1243), 15(880), 3(847), 11(638), 12(605)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(35937), 2(31350), 3(5313), 4(4873)
  - `cod_grupo`: NA=55 (0.1%), distintos=5; VALORES: 2(25784), 3(19327), 1(18260), 4(8349), 5(5698)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49500), 2(27973)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(77473)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(77473)

### `20_insumos/historico_2014_2018/idps4b2023/idps4b2023_rbd_final.xlsx`
- origen=historico · año-nombre=2023 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28172×18)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `grado`, `agno`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={4} · rbd duplicados=21129 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7043; alta cardinalidad (7043), rango[10..9999]
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(28172)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(28172)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7043), CC(7043), HV(7043), PF(7043)
  - `prom`: NA=2103 (7.5%), distintos=64; MEDIDA min=23 max=99 media=75.1 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7004), 9(3036), 5(3016), 8(2560), 10(2468), 7(2200), 6(1748), 4(1724), 14(1212), 16(1120), 2(552), 1(452), 15(320), 3(308), 11(232), 12(220)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(13068), 2(11400), 3(1932), 4(1772)
  - `cod_grupo`: NA=20 (0.1%), distintos=5; VALORES: 2(9376), 3(7028), 1(6640), 4(3036), 5(2072)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18000), 2(10172)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(28172)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(28172)

### `20_insumos/historico_2014_2018/idps4b2023/idps4b_niveles_final.xlsx`
- origen=historico · año-nombre=2023 · grado=4b · patrón `final/preliminar`: FALSE
- hojas: `Hoja1` · hoja datos=`Hoja1` (154823×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `rbd`, `agno`, `nivel`, `grado`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={4} · rbd duplicados=147762 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7061; alta cardinalidad (7061), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(154823)
  - `nivel`: NA=0 (0%), distintos=1; VALORES: BASIC(154823)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(154823)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(42271), PF(42195), HV(42138), AM(28219)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(21069), AA(14111), ME(14108), AR(14099), AS(14091), PA(14086), AO(14081), HA(14067), VA(14042), AC(14029), SP(7040)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(7056), ID(7056), PA(7055), PM(7052), CS(7050), AB(7049), MP(7047), PE(7044), TV(7044), AO(7042), PP(7042), IE(7040), PR(7039), AL(7037), PH(7030), AF(7026), EP(7026), RD(7022), PD(7021), AC(7017), PV(7016), PC(7012)
  - `niv_bajo_por`: NA=43189 (27.9%), distintos=948; MEDIDA min=0 max=100 media=32.9 fuera0-100=0
  - `niv_medio_por`: NA=73545 (47.5%), distintos=751; MEDIDA min=0 max=100 media=35.1 fuera0-100=0
  - `niv_alto_por`: NA=43189 (27.9%), distintos=960; MEDIDA min=0 max=100 media=41.5 fuera0-100=0
  - `niv_mbajo_por`: NA=111634 (72.1%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=111634 (72.1%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=111634 (72.1%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(154823)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(154823)

### `20_insumos/historico_2014_2018/2M/idps2M2024_rbd_dim_final.xlsx`
- origen=historico · año-nombre=2024 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (33000×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={2m} · rbd duplicados=30000 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(33000)
  - `rbd`: NA=0 (0%), distintos=3000; alta cardinalidad (3000), rango[1..9986]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(9000), HV(9000), PF(9000), AM(6000)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(3000), AC(3000), AO(3000), AR(3000), AS(3000), HA(3000), ME(3000), PA(3000), SP(3000), VA(3000), VD(3000)
  - `prom`: NA=127 (0.4%), distintos=65; MEDIDA min=24 max=100 media=74.4 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(11671), 5(4268), 8(2761), 9(1991), 7(1936), 10(1793), 6(1749), 4(1727), 16(1067), 14(946), 2(946), 1(660), 3(440), 15(396), 12(352), 11(297)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=335; alta cardinalidad (335), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(18502), 1(7755), 3(4950), 4(1793)
  - `cod_grupo`: NA=55 (0.2%), distintos=5; VALORES: 2(9537), 1(7623), 3(7381), 5(4763), 4(3641)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(31119), 2(1881)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(33000)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(33000)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(33000)

### `20_insumos/historico_2014_2018/2M/idps2M2024_rbd_final.xlsx`
- origen=historico · año-nombre=2024 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (12000×22)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `prom`, `dif`, `sigdif`, `difgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={2m} · rbd duplicados=9000 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(12000)
  - `rbd`: NA=0 (0%), distintos=3000; alta cardinalidad (3000), rango[1..9986]
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(3000), CC(3000), HV(3000), PF(3000)
  - `prom`: NA=45 (0.4%), distintos=49; MEDIDA min=36 max=97 media=74.4 fuera0-100=0
  - `dif`: NA=1115 (9.3%), distintos=44
  - `sigdif`: NA=1115 (9.3%), distintos=3; VALORES: 0(6987), -1(2131), 1(1767)
  - `difgru`: NA=105 (0.9%), distintos=40; VALORES: 0(1109), 1(1031), -1(1026), 2(998), -2(914), 3(872), -3(755), 4(742), -4(668), 5(579), -5(475), 6(465), -6(400), 7(344), 8(269), -7(266), -8(194), 9(168), 10(137), -9(107), -10(83), 11(71), 12(46), -11(38), -12(30), 13(25), -13(14), 14(13), 15(13), -14(9), -16(9), 17(6), -15(5), -17(5), 16(3), 19(2), -18(1), -20(1), -32(1), 18(1)
  - `sigdifgru`: NA=105 (0.9%), distintos=3; VALORES: 0(7461), 1(2501), -1(1933)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(4244), 5(1552), 8(1004), 9(724), 7(704), 10(652), 6(636), 4(628), 16(388), 14(344), 2(344), 1(240), 3(160), 15(144), 12(128), 11(108)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=335; alta cardinalidad (335), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(6728), 1(2820), 3(1800), 4(652)
  - `cod_grupo`: NA=20 (0.2%), distintos=5; VALORES: 2(3468), 1(2772), 3(2684), 5(1732), 4(1324)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(11316), 2(684)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(12000)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(12000)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(12000)

### `20_insumos/historico_2014_2018/2M/idps2M2024_rbd_niveles_final.xlsx`
- origen=historico · año-nombre=2024 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (65868×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `nivel`, `agno`, `rbd`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={2m} · rbd duplicados=62874 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `nivel`: NA=0 (0%), distintos=1; VALORES: MEDIA(65868)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(65868)
  - `rbd`: NA=0 (0%), distintos=2994; alta cardinalidad (2994), rango[1..9986]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(17964), HV(17964), PF(17964), AM(11976)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(8982), AA(5988), AC(5988), AO(5988), AR(5988), AS(5988), HA(5988), ME(5988), PA(5988), VA(5988), SP(2994)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(2994), AB(2994), AC(2994), AF(2994), AL(2994), AO(2994), CS(2994), EP(2994), ID(2994), IE(2994), MP(2994), PA(2994), PC(2994), PD(2994), PE(2994), PH(2994), PM(2994), PP(2994), PR(2994), PV(2994), RD(2994), TV(2994)
  - `niv_bajo_por`: NA=1036 (1.6%), distintos=968; MEDIDA min=0 max=100 media=41.9 fuera0-100=0
  - `niv_medio_por`: NA=18716 (28.4%), distintos=849; MEDIDA min=0 max=100 media=38.9 fuera0-100=0
  - `niv_alto_por`: NA=1036 (1.6%), distintos=937; MEDIDA min=0 max=100 media=29.8 fuera0-100=0
  - `niv_mbajo_por`: NA=64832 (98.4%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=65116 (98.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=64832 (98.4%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(65868)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(65868)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(65868)

### `20_insumos/historico_2014_2018/4B/idps4B2024_rbd_dim_final.xlsx`
- origen=historico · año-nombre=2024 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (79035×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={4b} · rbd duplicados=71850 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(79035)
  - `rbd`: NA=0 (0%), distintos=7185; alta cardinalidad (7185), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21555), HV(21555), PF(21555), AM(14370)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7185), AC(7185), AO(7185), AR(7185), AS(7185), HA(7185), ME(7185), PA(7185), SP(7185), VA(7185), VD(7185)
  - `prom`: NA=6280 (7.9%), distintos=80; MEDIDA min=15 max=100 media=75.1 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19338), 9(8547), 5(8404), 8(7117), 10(6985), 7(6204), 4(4917), 6(4895), 14(3443), 16(3124), 2(1518), 1(1243), 3(1199), 15(836), 12(638), 11(627)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(34936), 2(31834), 4(6897), 3(5368)
  - `cod_grupo`: NA=1265 (1.6%), distintos=5; VALORES: 2(27060), 3(19294), 1(18150), 4(7656), 5(5610)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49984), 2(29051)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20250625v1(79035)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250625(79035)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(79035)

### `20_insumos/historico_2014_2018/4B/idps4B2024_rbd_final.xlsx`
- origen=historico · año-nombre=2024 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28740×22)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `prom`, `dif`, `sigdif`, `difgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={4b} · rbd duplicados=21555 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(28740)
  - `rbd`: NA=0 (0%), distintos=7185; alta cardinalidad (7185), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7185), CC(7185), HV(7185), PF(7185)
  - `prom`: NA=2306 (8%), distintos=61; MEDIDA min=33 max=99 media=75 fuera0-100=0
  - `dif`: NA=7567 (26.3%), distintos=57
  - `sigdif`: NA=7567 (26.3%), distintos=3; VALORES: 0(10822), -1(5339), 1(5012)
  - `difgru`: NA=5751 (20%), distintos=46
  - `sigdifgru`: NA=5751 (20%), distintos=3; VALORES: 0(13013), 1(5412), -1(4564)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7032), 9(3108), 5(3056), 8(2588), 10(2540), 7(2256), 4(1788), 6(1780), 14(1252), 16(1136), 2(552), 1(452), 3(436), 15(304), 12(232), 11(228)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(12704), 2(11576), 4(2508), 3(1952)
  - `cod_grupo`: NA=460 (1.6%), distintos=5; VALORES: 2(9840), 3(7016), 1(6600), 4(2784), 5(2040)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18176), 2(10564)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20250625v1(28740)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250625(28740)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(28740)

### `20_insumos/historico_2014_2018/4B/idps4B2024_rbd_niveles_final.xlsx`
- origen=historico · año-nombre=2024 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (155760×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `nivel`, `agno`, `rbd`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={4b} · rbd duplicados=148680 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `nivel`: NA=0 (0%), distintos=1; VALORES: BASIC(155760)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(155760)
  - `rbd`: NA=0 (0%), distintos=7080; alta cardinalidad (7080), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(42480), HV(42480), PF(42480), AM(28320)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(21240), AA(14160), AC(14160), AO(14160), AR(14160), AS(14160), HA(14160), ME(14160), PA(14160), VA(14160), SP(7080)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(7080), AB(7080), AC(7080), AF(7080), AL(7080), AO(7080), CS(7080), EP(7080), ID(7080), IE(7080), MP(7080), PA(7080), PC(7080), PD(7080), PE(7080), PH(7080), PM(7080), PP(7080), PR(7080), PV(7080), RD(7080), TV(7080)
  - `niv_bajo_por`: NA=41069 (26.4%), distintos=953; MEDIDA min=0 max=100 media=30.2 fuera0-100=0
  - `niv_medio_por`: NA=72271 (46.4%), distintos=762; MEDIDA min=0 max=100 media=33.4 fuera0-100=0
  - `niv_alto_por`: NA=41069 (26.4%), distintos=961; MEDIDA min=0 max=100 media=45.5 fuera0-100=0
  - `niv_mbajo_por`: NA=114691 (73.6%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=125969 (80.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=114691 (73.6%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20250625v1(155760)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250625(155760)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(155760)

### `20_insumos/historico_2014_2018/6B/idps6B2024_rbd_dim_preliminar.xlsx`
- origen=historico · año-nombre=2024 · grado=6b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (77946×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={6b} · rbd duplicados=70860 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(77946)
  - `rbd`: NA=0 (0%), distintos=7086; alta cardinalidad (7086), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21258), HV(21258), PF(21258), AM(14172)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7086), AC(7086), AO(7086), AR(7086), AS(7086), HA(7086), ME(7086), PA(7086), SP(7086), VA(7086), VD(7086)
  - `prom`: NA=6357 (8.2%), distintos=76; MEDIDA min=10 max=100 media=75.5 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19250), 9(8393), 5(8250), 8(7161), 10(6809), 7(6105), 6(4807), 4(4774), 14(3377), 16(3102), 2(1496), 1(1210), 3(1133), 15(825), 11(638), 12(616)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(34419), 2(31482), 4(6743), 3(5302)
  - `cod_grupo`: NA=1353 (1.7%), distintos=5; VALORES: 2(27082), 1(18513), 3(18282), 4(7139), 5(5577)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49753), 2(28193)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(77946)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(77946)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(77946)

### `20_insumos/historico_2014_2018/6B/idps6B2024_rbd_niveles_preliminar.xlsx`
- origen=historico · año-nombre=2024 · grado=6b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (153670×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `nivel`, `agno`, `rbd`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={6b} · rbd duplicados=146685 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `nivel`: NA=0 (0%), distintos=1; VALORES: BASIC(153670)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(153670)
  - `rbd`: NA=0 (0%), distintos=6985; alta cardinalidad (6985), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(41910), HV(41910), PF(41910), AM(27940)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(20955), AA(13970), AC(13970), AO(13970), AR(13970), AS(13970), HA(13970), ME(13970), PA(13970), VA(13970), SP(6985)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(6985), AB(6985), AC(6985), AF(6985), AL(6985), AO(6985), CS(6985), EP(6985), ID(6985), IE(6985), MP(6985), PA(6985), PC(6985), PD(6985), PE(6985), PH(6985), PM(6985), PP(6985), PR(6985), PV(6985), RD(6985), TV(6985)
  - `niv_bajo_por`: NA=40172 (26.1%), distintos=968; MEDIDA min=0 max=100 media=34.6 fuera0-100=0
  - `niv_medio_por`: NA=71045 (46.2%), distintos=779; MEDIDA min=0 max=93.3 media=34.9 fuera0-100=0
  - `niv_alto_por`: NA=40172 (26.1%), distintos=967; MEDIDA min=0 max=100 media=40 fuera0-100=0
  - `niv_mbajo_por`: NA=113498 (73.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=124535 (81%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=113498 (73.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(153670)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(153670)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(153670)

### `20_insumos/historico_2014_2018/6B/idps6B2024_rbd_preliminar.xlsx`
- origen=historico · año-nombre=2024 · grado=6b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28344×22)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `prom`, `dif`, `sigdif`, `difgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={6b} · rbd duplicados=21258 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(28344)
  - `rbd`: NA=0 (0%), distintos=7086; alta cardinalidad (7086), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7086), CC(7086), HV(7086), PF(7086)
  - `prom`: NA=2325 (8.2%), distintos=63; MEDIDA min=27 max=100 media=75.5 fuera0-100=0
  - `dif`: NA=7653 (27%), distintos=58
  - `sigdif`: NA=7653 (27%), distintos=3; VALORES: 0(9563), -1(5665), 1(5463)
  - `difgru`: NA=5818 (20.5%), distintos=47
  - `sigdifgru`: NA=5818 (20.5%), distintos=3; VALORES: 0(12688), 1(5523), -1(4315)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7000), 9(3052), 5(3000), 8(2604), 10(2476), 7(2220), 6(1748), 4(1736), 14(1228), 16(1128), 2(544), 1(440), 3(412), 15(300), 11(232), 12(224)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(12516), 2(11448), 4(2452), 3(1928)
  - `cod_grupo`: NA=492 (1.7%), distintos=5; VALORES: 2(9848), 1(6732), 3(6648), 4(2596), 5(2028)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18092), 2(10252)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(28344)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(28344)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(28344)

### `20_insumos/idps2m2022_rbd_dim_final.xlsx`
- origen=raiz · año-nombre=2022 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (32736×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={2} · rbd duplicados=29760 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2976; alta cardinalidad (2976), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(32736)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(32736)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(8928), HV(8928), PF(8928), AM(5952)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(2976), AC(2976), AO(2976), AR(2976), AS(2976), HA(2976), ME(2976), PA(2976), SP(2976), VA(2976), VD(2976)
  - `prom`: NA=96 (0.3%), distintos=66; MEDIDA min=34 max=99 media=74.6 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(11627), 5(4257), 8(2750), 9(1958), 7(1914), 10(1793), 4(1716), 6(1683), 16(1045), 2(946), 14(913), 1(660), 3(440), 15(396), 12(352), 11(286)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=332; alta cardinalidad (332), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(18392), 1(8118), 3(4928), 4(1298)
  - `cod_grupo`: NA=44 (0.1%), distintos=5; VALORES: 2(9295), 3(7590), 1(7260), 5(4686), 4(3861)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(30910), 2(1826)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(32736)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240603v1(32736)

### `20_insumos/idps2m2022_rbd_final.xlsx`
- origen=raiz · año-nombre=2022 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (11904×16)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={2} · rbd duplicados=8928 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2976; alta cardinalidad (2976), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(11904)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(11904)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(2976), CC(2976), HV(2976), PF(2976)
  - `prom`: NA=34 (0.3%), distintos=44; MEDIDA min=52 max=95 media=74.6 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(4228), 5(1548), 8(1000), 9(712), 7(696), 10(652), 4(624), 6(612), 16(380), 2(344), 14(332), 1(240), 3(160), 15(144), 12(128), 11(104)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=332; alta cardinalidad (332), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 2(6688), 1(3424), 3(1792)
  - `cod_grupo`: NA=16 (0.1%), distintos=5; VALORES: 2(3380), 3(2760), 1(2640), 5(1704), 4(1404)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(11240), 2(664)

### `20_insumos/idps4b2022_rbd_dim_final.xlsx`
- origen=raiz · año-nombre=2022 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (78815×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={4} · rbd duplicados=71650 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7165; alta cardinalidad (7165), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(78815)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(78815)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21495), HV(21495), PF(21495), AM(14330)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7165), AC(7165), AO(7165), AR(7165), AS(7165), HA(7165), ME(7165), PA(7165), SP(7165), VA(7165), VD(7165)
  - `prom`: NA=6773 (8.6%), distintos=79; MEDIDA min=0 max=100 media=75 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19294), 9(8679), 5(8206), 8(7249), 10(6941), 7(6171), 4(4851), 6(4829), 14(3410), 16(3179), 2(1496), 1(1188), 3(1188), 15(869), 11(649), 12(616)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(36586), 2(31757), 3(5269), 4(5203)
  - `cod_grupo`: NA=1001 (1.3%), distintos=5; VALORES: 2(26378), 1(20251), 3(18546), 4(7128), 5(5511)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49698), 2(29117)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240531(78815)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final202400603v1(78815)

### `20_insumos/idps4b2022_rbd_final.xlsx`
- origen=raiz · año-nombre=2022 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28660×16)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `grado`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`
- cruce: agno-dato={2022} vs año-nombre=2022 · grado-dato={4} · rbd duplicados=21495 · cod_depe2 numérico/ausente={1,2,3}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7165; alta cardinalidad (7165), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2022(28660)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(28660)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7165), CC(7165), HV(7165), PF(7165)
  - `prom`: NA=2489 (8.7%), distintos=65; MEDIDA min=30 max=99 media=74.9 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7016), 9(3156), 5(2984), 8(2636), 10(2524), 7(2244), 4(1764), 6(1756), 14(1240), 16(1156), 2(544), 1(432), 3(432), 15(316), 11(236), 12(224)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=3; VALORES: 1(15196), 2(11548), 3(1916)
  - `cod_grupo`: NA=364 (1.3%), distintos=5; VALORES: 2(9592), 1(7364), 3(6744), 4(2592), 5(2004)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18072), 2(10588)

### `20_insumos/idps2m2023_niveles_final.xlsx`
- origen=raiz · año-nombre=2023 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (65293×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `rbd`, `agno`, `nivel`, `grado`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={2} · rbd duplicados=62325 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2968; alta cardinalidad (2968), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(65293)
  - `nivel`: NA=0 (0%), distintos=1; VALORES: MEDIA(65293)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(65293)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(17808), PF(17808), HV(17805), AM(11872)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(8904), AA(5936), AO(5936), AR(5936), AS(5936), HA(5936), ME(5936), PA(5936), AC(5935), VA(5934), SP(2968)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(2968), AB(2968), AL(2968), AO(2968), CS(2968), EP(2968), ID(2968), IE(2968), MP(2968), PA(2968), PC(2968), PD(2968), PE(2968), PH(2968), PM(2968), PP(2968), PR(2968), RD(2968), TV(2968), AC(2967), AF(2967), PV(2967)
  - `niv_bajo_por`: NA=983 (1.5%), distintos=973; MEDIDA min=0 max=100 media=45.9 fuera0-100=0
  - `niv_medio_por`: NA=18520 (28.4%), distintos=825; MEDIDA min=0 max=94.4 media=38.3 fuera0-100=0
  - `niv_alto_por`: NA=983 (1.5%), distintos=914; MEDIDA min=0 max=100 media=26.3 fuera0-100=0
  - `niv_mbajo_por`: NA=64310 (98.5%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=64310 (98.5%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=64310 (98.5%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(65293)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(65293)

### `20_insumos/idps2m2023_rbd_dim_final.xlsx`
- origen=raiz · año-nombre=2023 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (32692×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `grado`, `agno`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={2} · rbd duplicados=29720 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2972; alta cardinalidad (2972), rango[1..9986]
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(32692)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(32692)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(8916), HV(8916), PF(8916), AM(5944)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(2972), AC(2972), AO(2972), AR(2972), AS(2972), HA(2972), ME(2972), PA(2972), SP(2972), VA(2972), VD(2972)
  - `prom`: NA=97 (0.3%), distintos=60; MEDIDA min=33 max=99 media=74.6 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(11649), 5(4268), 8(2761), 9(1980), 7(1914), 10(1771), 4(1716), 6(1683), 16(1045), 14(946), 2(946), 1(660), 15(396), 12(352), 3(319), 11(286)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=331; alta cardinalidad (331), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(18414), 1(8173), 3(4928), 4(1177)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(10021), 3(7568), 1(6996), 5(4686), 4(3421)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(30866), 2(1826)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(32692)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(32692)

### `20_insumos/idps2m2023_rbd_final.xlsx`
- origen=raiz · año-nombre=2023 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (11888×18)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `grado`, `agno`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={2} · rbd duplicados=8916 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2972; alta cardinalidad (2972), rango[1..9986]
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2(11888)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(11888)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(2972), CC(2972), HV(2972), PF(2972)
  - `prom`: NA=35 (0.3%), distintos=50; MEDIDA min=42 max=96 media=74.6 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(4236), 5(1552), 8(1004), 9(720), 7(696), 10(644), 4(624), 6(612), 16(380), 14(344), 2(344), 1(240), 15(144), 12(128), 3(116), 11(104)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=331; alta cardinalidad (331), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(6696), 1(2972), 3(1792), 4(428)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(3644), 3(2752), 1(2544), 5(1704), 4(1244)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(11224), 2(664)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(11888)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(11888)

### `20_insumos/idps4b2023_niveles_final.xlsx`
- origen=raiz · año-nombre=2023 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (154823×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `rbd`, `agno`, `nivel`, `grado`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={4} · rbd duplicados=147762 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7061; alta cardinalidad (7061), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(154823)
  - `nivel`: NA=0 (0%), distintos=1; VALORES: BASIC(154823)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(154823)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(42271), PF(42195), HV(42138), AM(28219)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(21069), AA(14111), ME(14108), AR(14099), AS(14091), PA(14086), AO(14081), HA(14067), VA(14042), AC(14029), SP(7040)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(7056), ID(7056), PA(7055), PM(7052), CS(7050), AB(7049), MP(7047), PE(7044), TV(7044), AO(7042), PP(7042), IE(7040), PR(7039), AL(7037), PH(7030), AF(7026), EP(7026), RD(7022), PD(7021), AC(7017), PV(7016), PC(7012)
  - `niv_bajo_por`: NA=43189 (27.9%), distintos=948; MEDIDA min=0 max=100 media=32.9 fuera0-100=0
  - `niv_medio_por`: NA=73545 (47.5%), distintos=751; MEDIDA min=0 max=100 media=35.1 fuera0-100=0
  - `niv_alto_por`: NA=43189 (27.9%), distintos=960; MEDIDA min=0 max=100 media=41.5 fuera0-100=0
  - `niv_mbajo_por`: NA=111634 (72.1%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=111634 (72.1%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=111634 (72.1%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(154823)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(154823)

### `20_insumos/idps4b2023_rbd_dim_final.xlsx`
- origen=raiz · año-nombre=2023 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (77473×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `grado`, `agno`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={4} · rbd duplicados=70430 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7043; alta cardinalidad (7043), rango[10..9999]
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(77473)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(77473)
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21129), HV(21129), PF(21129), AM(14086)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7043), AC(7043), AO(7043), AR(7043), AS(7043), HA(7043), ME(7043), PA(7043), SP(7043), VA(7043), VD(7043)
  - `prom`: NA=5714 (7.4%), distintos=77; MEDIDA min=8 max=100 media=75.1 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19261), 9(8349), 5(8294), 8(7040), 10(6787), 7(6050), 6(4807), 4(4741), 14(3333), 16(3080), 2(1518), 1(1243), 15(880), 3(847), 11(638), 12(605)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(35937), 2(31350), 3(5313), 4(4873)
  - `cod_grupo`: NA=55 (0.1%), distintos=5; VALORES: 2(25784), 3(19327), 1(18260), 4(8349), 5(5698)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49500), 2(27973)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(77473)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(77473)

### `20_insumos/idps4b2023_rbd_final.xlsx`
- origen=raiz · año-nombre=2023 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28172×18)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `grado`, `agno`, `ind`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `fecha_bbdd`, `codigo_bdd`
- cruce: agno-dato={2023} vs año-nombre=2023 · grado-dato={4} · rbd duplicados=21129 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7043; alta cardinalidad (7043), rango[10..9999]
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4(28172)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2023(28172)
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7043), CC(7043), HV(7043), PF(7043)
  - `prom`: NA=2103 (7.5%), distintos=64; MEDIDA min=23 max=99 media=75.1 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7004), 9(3036), 5(3016), 8(2560), 10(2468), 7(2200), 6(1748), 4(1724), 14(1212), 16(1120), 2(552), 1(452), 15(320), 3(308), 11(232), 12(220)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(13068), 2(11400), 3(1932), 4(1772)
  - `cod_grupo`: NA=20 (0.1%), distintos=5; VALORES: 2(9376), 3(7028), 1(6640), 4(3036), 5(2072)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18000), 2(10172)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20240528(28172)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: final20240528v1(28172)

### `20_insumos/idps2m2024_rbd_dim_final.xlsx`
- origen=raiz · año-nombre=2024 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (33000×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={2m} · rbd duplicados=30000 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(33000)
  - `rbd`: NA=0 (0%), distintos=3000; alta cardinalidad (3000), rango[1..9986]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(9000), HV(9000), PF(9000), AM(6000)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(3000), AC(3000), AO(3000), AR(3000), AS(3000), HA(3000), ME(3000), PA(3000), SP(3000), VA(3000), VD(3000)
  - `prom`: NA=127 (0.4%), distintos=65; MEDIDA min=24 max=100 media=74.4 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(11671), 5(4268), 8(2761), 9(1991), 7(1936), 10(1793), 6(1749), 4(1727), 16(1067), 14(946), 2(946), 1(660), 3(440), 15(396), 12(352), 11(297)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=335; alta cardinalidad (335), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(18502), 1(7755), 3(4950), 4(1793)
  - `cod_grupo`: NA=55 (0.2%), distintos=5; VALORES: 2(9537), 1(7623), 3(7381), 5(4763), 4(3641)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(31119), 2(1881)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(33000)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(33000)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(33000)

### `20_insumos/idps2m2024_rbd_final.xlsx`
- origen=raiz · año-nombre=2024 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (12000×22)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `prom`, `dif`, `sigdif`, `difgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={2m} · rbd duplicados=9000 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(12000)
  - `rbd`: NA=0 (0%), distintos=3000; alta cardinalidad (3000), rango[1..9986]
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(3000), CC(3000), HV(3000), PF(3000)
  - `prom`: NA=45 (0.4%), distintos=49; MEDIDA min=36 max=97 media=74.4 fuera0-100=0
  - `dif`: NA=1115 (9.3%), distintos=44
  - `sigdif`: NA=1115 (9.3%), distintos=3; VALORES: 0(6987), -1(2131), 1(1767)
  - `difgru`: NA=105 (0.9%), distintos=40; VALORES: 0(1109), 1(1031), -1(1026), 2(998), -2(914), 3(872), -3(755), 4(742), -4(668), 5(579), -5(475), 6(465), -6(400), 7(344), 8(269), -7(266), -8(194), 9(168), 10(137), -9(107), -10(83), 11(71), 12(46), -11(38), -12(30), 13(25), -13(14), 14(13), 15(13), -14(9), -16(9), 17(6), -15(5), -17(5), 16(3), 19(2), -18(1), -20(1), -32(1), 18(1)
  - `sigdifgru`: NA=105 (0.9%), distintos=3; VALORES: 0(7461), 1(2501), -1(1933)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(4244), 5(1552), 8(1004), 9(724), 7(704), 10(652), 6(636), 4(628), 16(388), 14(344), 2(344), 1(240), 3(160), 15(144), 12(128), 11(108)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=335; alta cardinalidad (335), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(6728), 1(2820), 3(1800), 4(652)
  - `cod_grupo`: NA=20 (0.2%), distintos=5; VALORES: 2(3468), 1(2772), 3(2684), 5(1732), 4(1324)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(11316), 2(684)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(12000)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(12000)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(12000)

### `20_insumos/idps2m2024_rbd_niveles_final.xlsx`
- origen=raiz · año-nombre=2024 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (65868×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `nivel`, `agno`, `rbd`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={2m} · rbd duplicados=62874 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `nivel`: NA=0 (0%), distintos=1; VALORES: MEDIA(65868)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(65868)
  - `rbd`: NA=0 (0%), distintos=2994; alta cardinalidad (2994), rango[1..9986]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(17964), HV(17964), PF(17964), AM(11976)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(8982), AA(5988), AC(5988), AO(5988), AR(5988), AS(5988), HA(5988), ME(5988), PA(5988), VA(5988), SP(2994)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(2994), AB(2994), AC(2994), AF(2994), AL(2994), AO(2994), CS(2994), EP(2994), ID(2994), IE(2994), MP(2994), PA(2994), PC(2994), PD(2994), PE(2994), PH(2994), PM(2994), PP(2994), PR(2994), PV(2994), RD(2994), TV(2994)
  - `niv_bajo_por`: NA=1036 (1.6%), distintos=968; MEDIDA min=0 max=100 media=41.9 fuera0-100=0
  - `niv_medio_por`: NA=18716 (28.4%), distintos=849; MEDIDA min=0 max=100 media=38.9 fuera0-100=0
  - `niv_alto_por`: NA=1036 (1.6%), distintos=937; MEDIDA min=0 max=100 media=29.8 fuera0-100=0
  - `niv_mbajo_por`: NA=64832 (98.4%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=65116 (98.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=64832 (98.4%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(65868)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(65868)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(65868)

### `20_insumos/idps6b2024_rbd_dim_preliminar.xlsx`
- origen=raiz · año-nombre=2024 · grado=6b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (77946×19)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `dim`, `prom`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={6b} · rbd duplicados=70860 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(77946)
  - `rbd`: NA=0 (0%), distintos=7086; alta cardinalidad (7086), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(21258), HV(21258), PF(21258), AM(14172)
  - `dim`: NA=0 (0%), distintos=11; VALORES: AA(7086), AC(7086), AO(7086), AR(7086), AS(7086), HA(7086), ME(7086), PA(7086), SP(7086), VA(7086), VD(7086)
  - `prom`: NA=6357 (8.2%), distintos=76; MEDIDA min=10 max=100 media=75.5 fuera0-100=0
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19250), 9(8393), 5(8250), 8(7161), 10(6809), 7(6105), 6(4807), 4(4774), 14(3377), 16(3102), 2(1496), 1(1210), 3(1133), 15(825), 11(638), 12(616)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(34419), 2(31482), 4(6743), 3(5302)
  - `cod_grupo`: NA=1353 (1.7%), distintos=5; VALORES: 2(27082), 1(18513), 3(18282), 4(7139), 5(5577)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49753), 2(28193)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(77946)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(77946)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(77946)

### `20_insumos/idps6b2024_rbd_niveles_preliminar.xlsx`
- origen=raiz · año-nombre=2024 · grado=6b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (153670×15)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `nivel`, `agno`, `rbd`, `ind`, `dim`, `sdim`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={6b} · rbd duplicados=146685 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `nivel`: NA=0 (0%), distintos=1; VALORES: BASIC(153670)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(153670)
  - `rbd`: NA=0 (0%), distintos=6985; alta cardinalidad (6985), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: CC(41910), HV(41910), PF(41910), AM(27940)
  - `dim`: NA=0 (0%), distintos=11; VALORES: VD(20955), AA(13970), AC(13970), AO(13970), AR(13970), AS(13970), HA(13970), ME(13970), PA(13970), VA(13970), SP(6985)
  - `sdim`: NA=0 (0%), distintos=22; VALORES: AA(6985), AB(6985), AC(6985), AF(6985), AL(6985), AO(6985), CS(6985), EP(6985), ID(6985), IE(6985), MP(6985), PA(6985), PC(6985), PD(6985), PE(6985), PH(6985), PM(6985), PP(6985), PR(6985), PV(6985), RD(6985), TV(6985)
  - `niv_bajo_por`: NA=40172 (26.1%), distintos=968; MEDIDA min=0 max=100 media=34.6 fuera0-100=0
  - `niv_medio_por`: NA=71045 (46.2%), distintos=779; MEDIDA min=0 max=93.3 media=34.9 fuera0-100=0
  - `niv_alto_por`: NA=40172 (26.1%), distintos=967; MEDIDA min=0 max=100 media=40 fuera0-100=0
  - `niv_mbajo_por`: NA=113498 (73.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=124535 (81%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=113498 (73.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(153670)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(153670)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(153670)

### `20_insumos/idps6b2024_rbd_preliminar.xlsx`
- origen=raiz · año-nombre=2024 · grado=6b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (28344×22)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `agno`, `rbd`, `ind`, `prom`, `dif`, `sigdif`, `difgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2024} vs año-nombre=2024 · grado-dato={6b} · rbd duplicados=21258 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2024(28344)
  - `rbd`: NA=0 (0%), distintos=7086; alta cardinalidad (7086), rango[10..9999]
  - `ind`: NA=0 (0%), distintos=4; VALORES: AM(7086), CC(7086), HV(7086), PF(7086)
  - `prom`: NA=2325 (8.2%), distintos=63; MEDIDA min=27 max=100 media=75.5 fuera0-100=0
  - `dif`: NA=7653 (27%), distintos=58
  - `sigdif`: NA=7653 (27%), distintos=3; VALORES: 0(9563), -1(5665), 1(5463)
  - `difgru`: NA=5818 (20.5%), distintos=47
  - `sigdifgru`: NA=5818 (20.5%), distintos=3; VALORES: 0(12688), 1(5523), -1(4315)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(7000), 9(3052), 5(3000), 8(2604), 10(2476), 7(2220), 6(1748), 4(1736), 14(1228), 16(1128), 2(544), 1(440), 3(412), 15(300), 11(232), 12(224)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=345; alta cardinalidad (345), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 1(12516), 2(11448), 4(2452), 3(1928)
  - `cod_grupo`: NA=492 (1.7%), distintos=5; VALORES: 2(9848), 1(6732), 3(6648), 4(2596), 5(2028)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18092), 2(10252)
  - `codigo_bdd`: NA=0 (0%), distintos=1; VALORES: preliminar20240422v1(28344)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20250422(28344)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 6b(28344)

### `20_insumos/idps2m2025_rbd_dim_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (32989×21)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `id_indicador`, `id_dimension`, `agno`, `prom`, `dif`, `sigdif`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={2m} · rbd duplicados=29990 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2999; alta cardinalidad (2999), rango[1..9986]
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 2(8997), 3(8997), 4(8997), 1(5998)
  - `id_dimension`: NA=0 (0%), distintos=11; VALORES: 11(2999), 12(2999), 21(2999), 22(2999), 23(2999), 31(2999), 32(2999), 33(2999), 41(2999), 42(2999), 43(2999)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(32989)
  - `prom`: NA=34 (0.1%), distintos=63; MEDIDA min=32 max=100 media=74.1 fuera0-100=0
  - `dif`: NA=3922 (11.9%), distintos=56
  - `sigdif`: NA=3922 (11.9%), distintos=3; VALORES: 0(19656), -1(5207), 1(4204)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(11583), 5(4290), 8(2772), 9(1980), 7(1958), 10(1804), 4(1749), 6(1749), 16(1067), 2(946), 14(935), 1(660), 3(440), 15(396), 12(352), 11(308)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=335; alta cardinalidad (335), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(18392), 1(6039), 3(4961), 4(3597)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(9350), 3(7975), 1(6589), 5(5049), 4(4026)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(31097), 2(1892)
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(32989)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(32989)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(32989)

### `20_insumos/idps2m2025_rbd_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (11996×24)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `id_indicador`, `prom`, `dif`, `mdif`, `sigdif`, `difgru`, `mdifgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={2m} · rbd duplicados=8997 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2999; alta cardinalidad (2999), rango[1..9986]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(11996)
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 1(2999), 2(2999), 3(2999), 4(2999)
  - `prom`: NA=12 (0.1%), distintos=51; MEDIDA min=43 max=99 media=74.1 fuera0-100=0
  - `dif`: NA=1425 (11.9%), distintos=39; VALORES: 0(1118), -1(1101), 1(1034), -2(975), 2(915), -3(785), 3(776), -4(610), 4(533), -5(443), 5(430), -6(346), 6(271), -7(219), 7(190), -8(156), -9(117), 8(116), -10(82), 9(81), -11(58), -12(33), 11(32), 10(30), 12(22), -13(15), 13(15), 14(14), -14(12), -15(10), 15(10), -16(8), -18(5), 16(3), 18(2), -19(1), -22(1), -23(1), -28(1)
  - `mdif`: NA=10571 (88.1%), distintos=2; VALORES: /(1405), <U+00AC>(20)
  - `sigdif`: NA=1425 (11.9%), distintos=3; VALORES: 0(7092), -1(1921), 1(1558)
  - `difgru`: NA=67 (0.6%), distintos=44
  - `mdifgru`: NA=11929 (99.4%), distintos=1; VALORES: <U+00AC>(67)
  - `sigdifgru`: NA=67 (0.6%), distintos=3; VALORES: 0(7574), 1(2318), -1(2037)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(4212), 5(1560), 8(1008), 9(720), 7(712), 10(656), 4(636), 6(636), 16(388), 2(344), 14(340), 1(240), 3(160), 15(144), 12(128), 11(112)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=335; alta cardinalidad (335), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(6688), 1(2196), 3(1804), 4(1308)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(3400), 3(2900), 1(2396), 5(1836), 4(1464)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(11308), 2(688)
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(11996)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(11996)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(11996)

### `20_insumos/idps2m2025_rbd_subdim_niveles_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=2m · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (65956×14)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `rbd`, `id_subdimension`, `agno`, `id_indicador`, `id_dimension`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={2m} · rbd duplicados=62958 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=2998; alta cardinalidad (2998), rango[1..9986]
  - `id_subdimension`: NA=0 (0%), distintos=22; VALORES: 111(2998), 112(2998), 121(2998), 122(2998), 211(2998), 212(2998), 221(2998), 222(2998), 231(2998), 232(2998), 311(2998), 312(2998), 321(2998), 322(2998), 323(2998), 331(2998), 411(2998), 412(2998), 421(2998), 422(2998), 431(2998), 432(2998)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(65956)
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 2(17988), 3(17988), 4(17988), 1(11992)
  - `id_dimension`: NA=0 (0%), distintos=11; VALORES: 32(8994), 11(5996), 12(5996), 21(5996), 22(5996), 23(5996), 31(5996), 41(5996), 42(5996), 43(5996), 33(2998)
  - `niv_mbajo_por`: NA=65013 (98.6%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=65270 (99%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=65013 (98.6%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_bajo_por`: NA=943 (1.4%), distintos=4176; MEDIDA min=0 max=100 media=41.2 fuera0-100=0
  - `niv_medio_por`: NA=18674 (28.3%), distintos=3229; MEDIDA min=0 max=100 media=38.9 fuera0-100=0
  - `niv_alto_por`: NA=943 (1.4%), distintos=3655; MEDIDA min=0 max=100 media=30.6 fuera0-100=0
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(65956)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(65956)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 2m(65956)

### `20_insumos/idps4b2025_rbd_dim_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (77319×21)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `id_indicador`, `id_dimension`, `agno`, `prom`, `dif`, `sigdif`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={4b} · rbd duplicados=70290 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7029; alta cardinalidad (7029), rango[10..9999]
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 2(21087), 3(21087), 4(21087), 1(14058)
  - `id_dimension`: NA=0 (0%), distintos=11; VALORES: 11(7029), 12(7029), 21(7029), 22(7029), 23(7029), 31(7029), 32(7029), 33(7029), 41(7029), 42(7029), 43(7029)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(77319)
  - `prom`: NA=4881 (6.3%), distintos=82; MEDIDA min=5 max=100 media=75.2 fuera0-100=0
  - `dif`: NA=18809 (24.3%), distintos=72; alta cardinalidad (72), rango[-1..9]
  - `sigdif`: NA=18809 (24.3%), distintos=3; VALORES: 0(30421), 1(14244), -1(13845)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(19173), 9(8426), 5(8294), 8(7062), 10(6512), 7(6061), 6(4829), 4(4774), 14(3157), 16(3102), 2(1496), 3(1188), 1(1177), 15(836), 11(616), 12(616)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(31075), 1(26928), 4(13959), 3(5357)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(26411), 3(19503), 1(17754), 4(7964), 5(5687)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(49621), 2(27698)
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(77319)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(77319)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(77319)

### `20_insumos/idps4b2025_rbd_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (26868×24)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `id_indicador`, `prom`, `dif`, `mdif`, `sigdif`, `difgru`, `mdifgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={4b} · rbd duplicados=20151 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=6717; alta cardinalidad (6717), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(26868)
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 1(6717), 2(6717), 3(6717), 4(6717)
  - `prom`: NA=540 (2%), distintos=65; MEDIDA min=26 max=99 media=75.1 fuera0-100=0
  - `dif`: NA=5599 (20.8%), distintos=59
  - `mdif`: NA=21269 (79.2%), distintos=2; VALORES: <U+00AC>(2959), /(2640)
  - `sigdif`: NA=5599 (20.8%), distintos=3; VALORES: 0(10903), 1(5275), -1(5091)
  - `difgru`: NA=4035 (15%), distintos=48
  - `mdifgru`: NA=22833 (85%), distintos=1; VALORES: <U+00AC>(4035)
  - `sigdifgru`: NA=4035 (15%), distintos=3; VALORES: 0(12315), 1(5517), -1(5001)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(6968), 5(2988), 9(2836), 8(2464), 10(2096), 7(2088), 6(1728), 4(1528), 14(1060), 16(1044), 2(536), 3(416), 1(412), 15(280), 11(212), 12(212)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=343; alta cardinalidad (343), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(11096), 1(9104), 4(4720), 3(1948)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(9372), 3(6944), 1(5632), 4(2852), 5(2068)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18040), 2(8828)
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(26868)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(26868)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(26868)

### `20_insumos/idps4b2025_rbd_subdim_niveles_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=4b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (154814×14)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `rbd`, `id_subdimension`, `agno`, `id_indicador`, `id_dimension`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={4b} · rbd duplicados=147777 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=7037; alta cardinalidad (7037), rango[10..9999]
  - `id_subdimension`: NA=0 (0%), distintos=22; VALORES: 111(7037), 112(7037), 121(7037), 122(7037), 211(7037), 212(7037), 221(7037), 222(7037), 231(7037), 232(7037), 311(7037), 312(7037), 321(7037), 322(7037), 323(7037), 331(7037), 411(7037), 412(7037), 421(7037), 422(7037), 431(7037), 432(7037)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(154814)
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 2(42222), 3(42222), 4(42222), 1(28148)
  - `id_dimension`: NA=0 (0%), distintos=11; VALORES: 32(21111), 11(14074), 12(14074), 21(14074), 22(14074), 23(14074), 31(14074), 41(14074), 42(14074), 43(14074), 33(7037)
  - `niv_mbajo_por`: NA=114630 (74%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=125638 (81.2%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=114630 (74%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_bajo_por`: NA=40184 (26%), distintos=3478; MEDIDA min=0 max=100 media=29.6 fuera0-100=0
  - `niv_medio_por`: NA=71398 (46.1%), distintos=2554; MEDIDA min=0 max=100 media=32.5 fuera0-100=0
  - `niv_alto_por`: NA=40184 (26%), distintos=3553; MEDIDA min=0 max=100 media=46.7 fuera0-100=0
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(154814)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(154814)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 4b(154814)

### `20_insumos/idps8b2025_rbd_dim_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=8b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (65989×21)
- **NIVEL DE INFORME: D** · formato: largo
- columnas: `rbd`, `id_indicador`, `id_dimension`, `agno`, `prom`, `dif`, `sigdif`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={8b} · rbd duplicados=59990 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=5999; alta cardinalidad (5999), rango[10..9999]
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 2(17997), 3(17997), 4(17997), 1(11998)
  - `id_dimension`: NA=0 (0%), distintos=11; VALORES: 11(5999), 12(5999), 21(5999), 22(5999), 23(5999), 31(5999), 32(5999), 33(5999), 41(5999), 42(5999), 43(5999)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(65989)
  - `prom`: NA=903 (1.4%), distintos=64; MEDIDA min=26 max=100 media=75.4 fuera0-100=0
  - `dif`: NA=10385 (15.7%), distintos=78; alta cardinalidad (78), rango[-1..9]
  - `sigdif`: NA=10385 (15.7%), distintos=3; VALORES: 0(25661), -1(15471), 1(14472)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(18997), 5(7678), 8(6072), 9(5775), 7(5071), 10(4840), 6(4026), 4(3531), 16(2530), 14(2079), 2(1474), 1(1045), 3(979), 15(726), 12(616), 11(550)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(28226), 1(20801), 4(11704), 3(5258)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(23463), 3(17094), 1(13090), 4(6820), 5(5522)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(50105), 2(15884)
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(65989)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(65989)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(65989)

### `20_insumos/idps8b2025_rbd_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=8b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (23844×24)
- **NIVEL DE INFORME: I** · formato: largo
- columnas: `rbd`, `agno`, `id_indicador`, `prom`, `dif`, `mdif`, `sigdif`, `difgru`, `mdifgru`, `sigdifgru`, `nom_rbd`, `cod_reg_rbd`, `nom_reg_rbd`, `cod_pro_rbd`, `nom_pro_rbd`, `cod_com_rbd`, `nom_com_rbd`, `nom_deprov_rbd`, `cod_depe2`, `cod_grupo`, `cod_rural_rbd`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={8b} · rbd duplicados=17883 · cod_depe2 numérico/ausente={1,2,3,4}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=5961; alta cardinalidad (5961), rango[10..9999]
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(23844)
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 1(5961), 2(5961), 3(5961), 4(5961)
  - `prom`: NA=179 (0.8%), distintos=55; MEDIDA min=38 max=100 media=75.3 fuera0-100=0
  - `dif`: NA=3649 (15.3%), distintos=59
  - `mdif`: NA=20195 (84.7%), distintos=2; VALORES: /(2336), <U+00AC>(1313)
  - `sigdif`: NA=3649 (15.3%), distintos=3; VALORES: 0(9205), -1(5678), 1(5312)
  - `difgru`: NA=1507 (6.3%), distintos=48
  - `mdifgru`: NA=22337 (93.7%), distintos=1; VALORES: <U+00AC>(1507)
  - `sigdifgru`: NA=1507 (6.3%), distintos=3; VALORES: 0(12197), 1(6021), -1(4119)
  - `cod_reg_rbd`: NA=0 (0%), distintos=16; VALORES: 13(6904), 5(2784), 8(2204), 9(2080), 7(1820), 10(1720), 6(1464), 4(1280), 16(908), 14(756), 2(532), 1(376), 3(356), 15(264), 12(208), 11(188)
  - `cod_pro_rbd`: NA=0 (0%), distintos=56; alta cardinalidad (56), rango[101..92]
  - `cod_com_rbd`: NA=0 (0%), distintos=344; alta cardinalidad (344), rango[10101..9211]
  - `cod_depe2`: NA=0 (0%), distintos=4; VALORES: 2(10240), 1(7504), 4(4192), 3(1908)
  - `cod_grupo`: NA=0 (0%), distintos=5; VALORES: 2(8492), 3(6196), 1(4696), 4(2456), 5(2004)
  - `cod_rural_rbd`: NA=0 (0%), distintos=2; VALORES: 1(18212), 2(5632)
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(23844)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(23844)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(23844)

### `20_insumos/idps8b2025_rbd_subdim_niveles_preliminar.xlsx`
- origen=raiz · año-nombre=2025 · grado=8b · patrón `final/preliminar`: TRUE
- hojas: `Hoja1` · hoja datos=`Hoja1` (132044×14)
- **NIVEL DE INFORME: S** · formato: largo
- columnas: `rbd`, `id_subdimension`, `agno`, `id_indicador`, `id_dimension`, `niv_mbajo_por`, `niv_mmedio_por`, `niv_malto_por`, `niv_bajo_por`, `niv_medio_por`, `niv_alto_por`, `codigo_bbdd`, `fecha_bbdd`, `grado`
- cruce: agno-dato={2025} vs año-nombre=2025 · grado-dato={8b} · rbd duplicados=126042 · cod_depe2 numérico/ausente={}
- perfilado de códigos/medidas:
  - `rbd`: NA=0 (0%), distintos=6002; alta cardinalidad (6002), rango[10..9999]
  - `id_subdimension`: NA=0 (0%), distintos=22; VALORES: 111(6002), 112(6002), 121(6002), 122(6002), 211(6002), 212(6002), 221(6002), 222(6002), 231(6002), 232(6002), 311(6002), 312(6002), 321(6002), 322(6002), 323(6002), 331(6002), 411(6002), 412(6002), 421(6002), 422(6002), 431(6002), 432(6002)
  - `agno`: NA=0 (0%), distintos=1; VALORES: 2025(132044)
  - `id_indicador`: NA=0 (0%), distintos=4; VALORES: 2(36012), 3(36012), 4(36012), 1(24008)
  - `id_dimension`: NA=0 (0%), distintos=11; VALORES: 32(18006), 11(12004), 12(12004), 21(12004), 22(12004), 23(12004), 31(12004), 41(12004), 42(12004), 43(12004), 33(6002)
  - `niv_mbajo_por`: NA=114710 (86.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_mmedio_por`: NA=119447 (90.5%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_malto_por`: NA=114710 (86.9%), distintos=1; MEDIDA min=<e2><80><94> max=<e2><80><94> media=<e2><80><94> fuera0-100=0 marcadores:<U+00AB>
  - `niv_bajo_por`: NA=17334 (13.1%), distintos=3737; MEDIDA min=0 max=100 media=39.1 fuera0-100=0
  - `niv_medio_por`: NA=48609 (36.8%), distintos=2903; MEDIDA min=0 max=100 media=37.3 fuera0-100=0
  - `niv_alto_por`: NA=17334 (13.1%), distintos=3373; MEDIDA min=0 max=100 media=33.8 fuera0-100=0
  - `codigo_bbdd`: NA=0 (0%), distintos=1; VALORES: v12025(132044)
  - `fecha_bbdd`: NA=0 (0%), distintos=1; VALORES: 20260423(132044)
  - `grado`: NA=0 (0%), distintos=1; VALORES: 8b(132044)

## Fase C — Mapa de cobertura del universo

### C1. Matriz maestra año × grado × nivel de informe
| grado | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 4b | I | I | I | I | I·D | — | ·pand· | ·pand· | I·D | I·D·S | I·D·S | I·D·S |
| 6b | I | I | I | — | I·D | — | ·pand· | ·pand· | — | — | I·D·S | — |
| 8b | I | I | — | I | — | I | ·pand· | ·pand· | — | — | — | I·D·S |
| 2m | I | I | I | I | I·D | — | ·pand· | ·pand· | I·D | I·D·S | I·D·S | I·D·S |
: I=indicador, D=dimensión, S=subdimensión/niveles. `·pand·`=hueco pandemia (esperado). `—`=sin dato.

### C2. Esquemas estructurales encontrados
- (detalle de columnas por archivo en Fase B). Resumen de niveles por año:
  - **2014**: niveles {I}
  - **2015**: niveles {I}
  - **2016**: niveles {I}
  - **2017**: niveles {I}
  - **2018**: niveles {D,I}
  - **2019**: niveles {I}
  - **2022**: niveles {D,I}
  - **2023**: niveles {D,I,S}
  - **2024**: niveles {D,I,S}
  - **2025**: niveles {D,I,S}

### C4. Catálogo de activos por nivel (conservación: nada se marca descartable)
- **Indicador (I):** 2m·2014, 4b·2014, 6b·2014, 8b·2014, 2m·2015, 4b·2015, 6b·2015, 8b·2015, 2m·2016, 4b·2016, 6b·2016, 2m·2017, 4b·2017, 8b·2017, 2m·2018, 4b·2018, 6b·2018, 8b·2019, 2m·2022, 4b·2022, 2m·2023, 4b·2023, 2m·2024, 4b·2024, 6b·2024, 2m·2025, 4b·2025, 8b·2025
- **Dimensión (D):** 2m·2018, 4b·2018, 6b·2018, 2m·2022, 4b·2022, 2m·2023, 4b·2023, 2m·2024, 4b·2024, 6b·2024, 2m·2025, 4b·2025, 8b·2025
- **Subdimensión/niveles (S):** 2m·2023, 4b·2023, 2m·2024, 4b·2024, 6b·2024, 2m·2025, 4b·2025, 8b·2025

### C5. Duplicados / ajeno / ruido (informativo, sin recomendar borrado)
- Duplicados 2022/2023 en `historico/`: 10 archivos (ver byte-check Fase A).
- Material 2024 en `historico/`: 9 datos (algunos únicos, ver Fase A).
- `.DS_Store`: 27 (ruido de sistema).

### C3. Mapeo de columnas origen → esquema canónico de `idps_largo`

| col. canónica | mínimo 2014-16 | texto 2017 | 2018 (con dim) | 2019 | largo texto 2022-24 | largo id 2025 |
|---|---|---|---|---|---|---|
| rbd | rbd | rbd | rbd | rbd | rbd | rbd |
| agno | agno | agno | **(ausente→del nombre)** | agno | agno | agno |
| grado | grado | grado | grado | grado | grado | grado |
| id_indicador | pivot ind_am/cc/pf/hv | pivot ind_* | pivot ind_*_rbd | pivot ind_* | ind (texto) | id_indicador |
| id_dimension | — (no hay) | — | **pivot dim_*_rbd** | — | dim (texto) | id_dimension |
| id_subdimension | — | — | — | — | sdim (2023-24) | id_subdimension (2025) |
| prom | valor de ind_* | ind_* | ind_*_rbd / dim_*_rbd | ind_* | prom | prom |
| dif/sigdif/difgru/sigdifgru | — (sin significancia) | — | — | — | dif/sigdif/… | dif/sigdif/… |
| niv_*_por | — | — | — | — | niv_*_por (2023-24) | niv_*_por (2025) |
| cod_grupo | — | cod_grupo (**texto**) | cod_grupo (num) | cod_grupo (num) | cod_grupo | cod_grupo |
| cod_depe2 | — | cod_depe2 (**texto**) | cod_depe2 (num, con 4 en 2m) | cod_depe2 (num) | cod_depe2 | cod_depe2 |
| geo (cod/nom_*_rbd) | — | presente | **nombres distintos** (nom_regi_n…) | presente | presente | presente |
: `—` = no existe en ese esquema (quedaría NA al poblar). El histórico NO trae significancia (dif/sig/difgru/sigdifgru): quedará NA en todo 2014-2019.

### C6. Decisiones detectadas para el titular (insumo neutral, NO se resuelven ni se recomienda podar)

**D1 — Mapeo sufijo `dim_*` 2018 → `id_dimension` (A VALIDAR POR EL TITULAR).** La glosa 2018 NO documenta las columnas `dim_*_rbd` (0 celdas las mencionan); el mapeo se propone por el sufijo de 2 letras contra el crosswalk `catalogo_idps`:

| columna 2018 | dimensión propuesta | id_dimension |
|---|---|---|
| dim_am_aa_rbd | Autopercepción y autovaloración académica | 11 |
| dim_am_me_rbd | Motivación escolar | 12 |
| dim_cc_ar_rbd | Ambiente de respeto | 21 |
| dim_cc_ao_rbd | Ambiente organizado | 22 |
| dim_cc_as_rbd | Ambiente seguro | 23 |
| dim_pf_pa_rbd | Participación | 31 |
| dim_pf_vd_rbd | Vida democrática | 32 |
| dim_pf_sp_rbd | Sentido de pertenencia | 33 |
| dim_hv_ha_rbd | Hábitos alimenticios | 41 |
| dim_hv_va_rbd | Hábitos de vida activa | 42 |
| dim_hv_ac_rbd | Hábitos de autocuidado | 43 |
: **A validar** — derivado del sufijo + crosswalk, no de la glosa 2018 (que no los define).

**D2 — `cod_depe2`/`cod_grupo`/geo en TEXTO en 2017** (vs numérico el resto): requiere conversión texto→código al homologar. Reportado, no resuelto.
**D3 — `agno` ausente en 2018:** derivar el año del nombre (el pipeline ya deriva el grado del nombre). Reportado.
**D4 — geo 2018 con nombres distintos** (`nom_regi_n`, `nom_provincia`, `nom_comuna`, `cod_deprov`): requiere renombrado al homologar geo.
**D5 — `cod_depe2`=4 en `2m_2018`:** posible SLEP temprano (primeros traspasos 2018); decidir interpretación/mapeo.
**D6 — migración de esquema texto↔id:** 2022-2024 usan `ind/dim/sdim` (texto); 2025 usa `id_indicador/id_dimension/id_subdimension` (numérico). Homologación ya prevista por el crosswalk del proyecto; se reporta para el histórico.
**D7 — Subdimensión/niveles (S) solo desde 2023:** la serie S no es construible antes de 2023 (ni en histórico). Indicador (I) sí en todo el rango con dato; Dimensión (D) en 2018 + 2022→.

