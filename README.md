# Brechas socioeconomicas entre las regiones del mundo 

Entrega final del trabajo de CIencia de Datos para Economia y Negocios
## Alumnas: 
- Acebedo María Victoria 
- Gorra Cerveny Aylen Lujan 

## Objetivo 
Demostrar la divergencia y el desarrollo socioeconomico de las regiones del mundo entre el 2016 y el 2025, para ver si las brechas históricamente establecidas entre las regiones de menor desarrollo y las de mayor desarrollo siguen manteniendo sus patrones o disminuyeron significativamente.

## Hipótesis de trabajo

- H1: Las regiones periféricas registraron avances en distintos indicadores de desarrollo, sin embargo, estos progresos no resultaron suficientes para reducir significativamente las brechas con respecto a las regiones centrales, manteniendo patrones de desigualdad económica y social históricamente establecidos. Se toma como regiones de mayor desarrollo "Norte América" Y "Europa y Asia Central", mientras que "África Subsariana" y "Asia Meridional" se consideran con menor desarrollo.  
Se toma como referencia el período de 2016 - 2025.

- H2: Las regiones de desarrollo intermedio y heterógeno entre países "América Latina y El Caribe" y "Asia Oriental y El Pacífico" en el mismo período (2016 - 2025) presentan diferentes trayectorias en la evolución de indicadores económicos y sociales, observándose una mejora más acelerada en "Asia Oriental y El Pacífico" en pobreza y crecimiento, mientras que "América Latina y El Caribe" tuvo una mejora más lenta, lo cuál se debe a la desigualdad estructural e inestabilidad macroeconómica.

## Estructura del repositorio

```
├── auxiliar/  -> bases auxiliares.
        ├── sin bases auxiliares.R      
├── input/  -> datos limpios y procesados.
        ├── base_limpia.csv
        ├── base_limpia_boxplot.csv
        ├── base_limpia_scatterplot.csv
        ├── base_paises_testt.csv
        ├── base_testt.csv 
├── output/  -> resultados del analisis (graficos, tablas y valores obtenidos).
        ├── estadisticas descriptivas.xlsx
        ├── boxplot_indice_compuesto.png
        ├── grafico_exploratorio.png
        ├── resultados_anova_tukey.txt
        ├── resultados_medianas_scatterplot.txt
        ├── resultados_test_t.txt
├── raw/  -> base cruda
        ├── P_Data_Extract_From_World_Development_Indicators.xlsx
├── scripts/ -> todos los codigos del trabajo.
        ├── 01_limpieza.R
        ├── 02_grafico_exploratorio.R
        ├── 03_boxplot_grafico_comunicacional.R
        ├── 04_Test_T_pareado.R
        ├── 05_anova.R   
├── utils/  -> funciones personalizadas
        ├── utils.R   
└── README.md
```

## Datos utilizados
[WDI]https://databank.worldbank.org/source/world-development-indicators
| Base | Fuente | Unidad de observación | Período | Ubicación en el repo |
|---|---|---|---|---|
| P_Data_Extract_From_World_Development_Indicators.xlsx | Banco Mundial | países y regiones | 2016 - 2025 | `raw/P_Data_Extract_From_World_Development_Indicators.xlsx` |

## Cómo correr el proyecto

Los scripts deben ejecutarse en orden.

| Orden | Script | Qué hace | Como ejecutarlo | Qué genera | 
|---|---|---|---|---|
| 1 | `scripts/01_limpieza.R` | Limpia y procesa la base cruda, trata faltantes/outliers | 1º cargar la base cruda 2º correr el codigo |`input/base_limpia.csv`|
| 2 | `scripts/02_grafico exploratorio.R` | Grafico exploratorio Scatterplot | 1º cargar la base limpia 2º correr el codigo | `output/grafico_exploratorio.png` -`output/resultados_medianas_scatterplot.txt` - `input/base_limpia_scatterplot.csv`|
| 3 | `scripts/03_boxplot, gráfico comunicacional.R].R` | Grafico comunicacional, boxplot | 1º  cargar la base CRUDA 2º correr el codigo| `output/boxplot_indice_compuesto.png` - `input/base_limpia_boxplot.csv` |
| 4 | `scripts/04_test T pareado.R` | Script para obtener los resultados del Test-T | 1º cargar la base limpia 2º correr el codigo | `output/resultados_test_t.txt` - `input/base_paises_testt.csv` (base con variaciones) - `input/base_testt.csv` (base con promedios|
| 5 | `scripts/05_anova.R` | Script para obtener los resultados del ANOVA y Tukey HSD | 1º cargar la base CRUDA 2º correr el codigo |`output/resultados_anova_tukey.txt` |


## Requisitos

- R install.packages(c("tidyverse", "readxl", "countrycode", "ggplot", "car"))
- Todas las rutas son relativas; el proyecto debe abrirse desde la raíz del repositorio (idealmente como proyecto de RStudio, `.Rproj`).
