# Estructura actual — slep_idps

- **Raiz:** `/Users/tomgc/Projects/slep_idps`
- **Fecha:** 2026-06-21 12:19:53
- **Totales:** 25 carpetas, 154 archivos
- **Nota:** todos los datos son publicos (Agencia de Calidad) y se versionan en el repo.

## Arbol

```
slep_idps/
├── .claude/
│   ├── launch.json  (246)
│   └── settings.local.json  (88)
├── 10_utils/
│   ├── 10_configuracion.R  (10.2K)
│   ├── 10_utils.R  (1.68K)
│   ├── d3.min.js  (273K)
│   └── pako.min.js  (45.8K)
├── 20_insumos/
│   ├── auxiliares/
│   │   ├── referencias_idps/
│   │   │   ├── articles-239257_recurso.pdf  (2.24M)
│   │   │   ├── articles-90116_recurso_2.pdf  (131K)
│   │   │   ├── articles-90146_recurso_2.pdf  (87.8K)
│   │   │   ├── articles-90152_recurso_2.pdf  (88.7K)
│   │   │   ├── articles-90157_recurso_2.pdf  (91.8K)
│   │   │   ├── idps_corpus_conceptual.json  (73.7K)
│   │   │   ├── idps_corpus_conceptual.md  (63.8K)
│   │   │   ├── marco_evaluacion_idps_2025.pdf  (519K)
│   │   │   ├── metodologia_calculo_idps.pdf  (3.58M)
│   │   │   ├── otros_indicadores_calidad_2014.pdf  (909K)
│   │   │   ├── otros_indicadores_calidad_2019.pdf  (357K)
│   │   │   └── subdimensiones_idps.pdf  (2.8M)
│   │   ├── .DS_Store  (6K)
│   │   ├── caracterizacion_establecimientos.xlsx  (16.5K)
│   │   ├── diccionario_territorios.xlsx  (16.8K)
│   │   ├── directorio_oficial_ee.csv  (3.6M)
│   │   ├── directorio_oficial_ee_publico.csv  (3.42M)
│   │   ├── glosas_directorio_oficial_ee.pdf  (457K)
│   │   ├── idps2m2023_GLOSAS_rbd_pu<cc><81>blico_final.xlsx  (NA)
│   │   ├── idps2m2024_GLOSAS_web_final.xlsx  (34K)
│   │   ├── idps2m2025_GLOSAS_web_preliminar.xlsx  (34.4K)
│   │   ├── idps4b2023_GLOSAS_rbd_pu<cc><81>blico_final.xlsx  (NA)
│   │   ├── idps4b2025_GLOSAS_web_preliminar.xlsx  (34.4K)
│   │   ├── idps6b2024_GLOSAS_web_final.xlsx  (34K)
│   │   ├── idps8b2025_GLOSAS_web_preliminar.xlsx  (34.3K)
│   │   ├── listado_slep_2026.xlsx  (55.5K)
│   │   ├── rex_1440.pdf  (995K)
│   │   └── rex_1459.pdf  (3.16M)
│   ├── .DS_Store  (8K)
│   ├── .gitkeep  (0)
│   ├── idps2m2022_rbd_dim_final.xlsx  (2M)
│   ├── idps2m2022_rbd_final.xlsx  (659K)
│   ├── idps2m2022_rbd_glosa_pu<cc><81>blica_final.xlsx  (NA)
│   ├── idps2m2023_niveles_final.xlsx  (3.44M)
│   ├── idps2m2023_rbd_dim_final.xlsx  (1.99M)
│   ├── idps2m2023_rbd_final.xlsx  (735K)
│   ├── idps2m2024_rbd_dim_final.xlsx  (2.01M)
│   ├── idps2m2024_rbd_final.xlsx  (1.06M)
│   ├── idps2m2024_rbd_niveles_final.xlsx  (3.35M)
│   ├── idps2m2025_rbd_dim_preliminar.xlsx  (2.2M)
│   ├── idps2m2025_rbd_preliminar.xlsx  (976K)
│   ├── idps2m2025_rbd_subdim_niveles_preliminar.xlsx  (3.2M)
│   ├── idps4b2022_rbd_dim_final.xlsx  (4.78M)
│   ├── idps4b2022_rbd_final.xlsx  (1.53M)
│   ├── idps4b2022_rbd_glosa_pu<cc><81>blica_final.xlsx  (NA)
│   ├── idps4b2023_niveles_final.xlsx  (7.59M)
│   ├── idps4b2023_rbd_dim_final.xlsx  (4.69M)
│   ├── idps4b2023_rbd_final.xlsx  (1.68M)
│   ├── idps4b2025_rbd_dim_preliminar.xlsx  (5.08M)
│   ├── idps4b2025_rbd_preliminar.xlsx  (2.09M)
│   ├── idps4b2025_rbd_subdim_niveles_preliminar.xlsx  (7.01M)
│   ├── idps6b2024_rbd_dim_preliminar.xlsx  (4.7M)
│   ├── idps6b2024_rbd_niveles_preliminar.xlsx  (7.42M)
│   ├── idps6b2024_rbd_preliminar.xlsx  (2.41M)
│   ├── idps8b2025_rbd_dim_preliminar.xlsx  (4.38M)
│   ├── idps8b2025_rbd_preliminar.xlsx  (1.88M)
│   └── idps8b2025_rbd_subdim_niveles_preliminar.xlsx  (6.18M)
├── 30_procesamiento/
│   ├── .gitkeep  (0)
│   ├── 31_depurar_directorio_oficial.R  (3.55K)
│   ├── 32_censo_insumos.R  (9.37K)
│   ├── 33_construir_catalogos.R  (15.2K)
│   ├── 34_leer_normalizar_idps.R  (17.5K)
│   ├── 35_generar_motor_html.R  (23.4K)
│   └── 35_motor_template.html  (105K)
├── 40_salidas/
│   ├── intermedios/
│   │   ├── .gitkeep  (0)
│   │   ├── catalogo_idps.parquet  (42.2K)
│   │   ├── censo_insumos.md  (3.58K)
│   │   ├── censo_insumos.parquet  (7.23K)
│   │   ├── comunas_chile.parquet  (7.18K)
│   │   ├── establecimientos_chile.parquet  (260K)
│   │   ├── idps_largo.parquet  (5.61M)
│   │   └── sleps_chile.parquet  (58.7K)
│   ├── .DS_Store  (6K)
│   └── motor_idps.html  (4.66M)
├── 50_documentacion/
│   ├── activa/
│   │   ├── decisiones/
│   │   │   ├── .gitkeep  (0)
│   │   │   ├── 20260611_decision_gobernanza_insumos_publicos.md  (3.23K)
│   │   │   └── 20260612_decision_ponderacion_idps.md  (7.21K)
│   │   ├── prototipos/
│   │   │   └── idps_radar_prototipo.jsx  (12.9K)
│   │   ├── encargo_claude_code_idps_cierre_v05.md  (6.72K)
│   │   ├── encargo_claude_code_idps_pestana_slep_selector.md  (14.5K)
│   │   ├── encargo_claude_code_idps_producto_deploy.md  (14K)
│   │   ├── encargo_claude_code_idps_vista_historica_barras.md  (16.2K)
│   │   ├── POLITICA_PROYECTO.md  (29.7K)
│   │   ├── prompt_nuevo_proyecto_idps.md  (9.73K)
│   │   └── SETTINGS_Y_PROMPTS_OPERACIONALES.md  (24.7K)
│   ├── andamios/
│   │   ├── diseno/
│   │   │   ├── entity_modal/
│   │   │   │   ├── EntityModal.jsx  (11.2K)
│   │   │   │   └── entitymodal_estilos.css  (4.06K)
│   │   │   ├── motor_idps/
│   │   │   │   ├── fonts/
│   │   │   │   │   ├── gobCL_Heavy.otf  (43.7K)
│   │   │   │   │   ├── gobCL_Light.otf  (37.1K)
│   │   │   │   │   ├── gobCL_Regular.otf  (35.7K)
│   │   │   │   │   ├── MuseoSans-100.otf  (61K)
│   │   │   │   │   ├── MuseoSans-300.otf  (61.5K)
│   │   │   │   │   ├── MuseoSans_500.otf  (61K)
│   │   │   │   │   └── MuseoSans_700.otf  (62.1K)
│   │   │   │   ├── screenshots/
│   │   │   │   │   └── dual-default.png  (39.2K)
│   │   │   │   ├── idps-app.jsx  (18K)
│   │   │   │   ├── idps-charts.jsx  (19.9K)
│   │   │   │   ├── idps-controls.jsx  (16.3K)
│   │   │   │   ├── idps-data.js  (16.6K)
│   │   │   │   ├── Motor IDPS.html  (28.6K)
│   │   │   │   ├── PROMPT.md  (9.01K)
│   │   │   │   └── slep_idps_fuente_completa.md  (100K)
│   │   │   ├── rediseno_3pantallas/
│   │   │   │   ├── img/
│   │   │   │   │   ├── 01-territorial.png  (36K)
│   │   │   │   │   ├── 02-ficha.png  (42.6K)
│   │   │   │   │   ├── 03-comparar.png  (42.2K)
│   │   │   │   │   └── 04-historica.png  (43K)
│   │   │   │   ├── .DS_Store  (6K)
│   │   │   │   ├── Handout IDPS.html  (23.9K)
│   │   │   │   ├── idps-demo.js  (34K)
│   │   │   │   ├── PROMPT para Claude.md  (7K)
│   │   │   │   └── Propuesta IDPS.html  (28K)
│   │   │   └── .DS_Store  (10K)
│   │   ├── logs/
│   │   │   ├── 20260619_sesion6_encargo2_log.md  (23.5K)
│   │   │   ├── 20260620_auditoria_fidelidad_p3.md  (22.5K)
│   │   │   ├── 20260620_rediseno_fase1_log.md  (8.04K)
│   │   │   ├── 20260620_rediseno_fase2_log.md  (13.7K)
│   │   │   ├── 20260620_rediseno_fase3_log.md  (16.1K)
│   │   │   ├── 20260620_rediseno_fase4_log.md  (5.47K)
│   │   │   ├── 20260621_pestana_slep_selector_log.md  (7.08K)
│   │   │   └── 20260621_vista_historica_barras_log.md  (8.07K)
│   │   ├── .DS_Store  (10K)
│   │   └── .gitkeep  (0)
│   ├── estructura/
│   │   ├── .gitkeep  (0)
│   │   ├── 20260620_230506_estructura.md  (9.35K)
│   │   ├── 20260620_230506_estructura.txt  (9.43K)
│   │   ├── 20260620_230927_estructura.md  (9.4K)
│   │   ├── 20260620_230927_estructura.txt  (9.49K)
│   │   ├── estructura_actual.md  (9.4K)
│   │   └── estructura_actual.txt  (9.49K)
│   ├── traspasos/
│   │   ├── .gitkeep  (0)
│   │   ├── traspaso_cierre_v01.md  (16.4K)
│   │   ├── traspaso_cierre_v02.md  (22.8K)
│   │   ├── traspaso_cierre_v03.md  (23.9K)
│   │   ├── traspaso_cierre_v04.md  (26.2K)
│   │   ├── traspaso_cierre_v05.md  (33.8K)
│   │   ├── traspaso_cierre_v06.md  (15.7K)
│   │   ├── traspaso_cierre_v07.md  (30.3K)
│   │   └── traspaso_cierre_v08.md  (24.9K)
│   └── .DS_Store  (10K)
├── docs/
│   └── index.html  (4.66M)
├── tests/
│   └── .gitkeep  (0)
├── .DS_Store  (14K)
├── .gitignore  (759)
├── 00_build.R  (6.91K)
├── 00_escanear_proyecto.R  (8.99K)
├── CLAUDE.md  (5.5K)
├── README.md  (1.74K)
└── slep_idps.Rproj  (195)
```

## Conteo por extension

| Extension | Archivos |
|---|---|
| xlsx | 37 |
| md | 35 |
| (sin extension) | 17 |
| pdf | 13 |
| r | 9 |
| otf | 7 |
| html | 6 |
| parquet | 6 |
| jsx | 5 |
| png | 5 |
| js | 4 |
| json | 3 |
| txt | 3 |
| csv | 2 |
| css | 1 |
| rproj | 1 |
