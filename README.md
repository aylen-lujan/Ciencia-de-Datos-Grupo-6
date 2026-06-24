# Ciencia de Datos, entrega final, grupo 6

Entrega final del trabajo de CIencia de Datos para Economia y Negocios
Alumnas: Acebedo María Victoria y Gorra Cerveny Aylen Lujan
[1-2 párrafos: de qué trata el trabajo, qué pregunta/hipótesis se busca responder, y por qué es relevante. Esto es el "elevator pitch" del proyecto.]

## Hipótesis de trabajo

- H1: Las regiones periféricas registraron avances en distintos avances en distintos indicadores de desarrollo, sin embaro, estos progresos no resultaron suficientes para reducir significativamente las brechas con respecto a las regionres centrales, manteniendo patrones de desigualdad económica y social históricamente establecidos. Se toma como regionres de mayor desarrollo "Norte América" Y "Europa y Asia Central", mientras que "África Subsariana" y "Asia Meridional" se consideran con menor desarrollo.
  Se toma como referencia el período de 2016 - 2025.

- H2: Las regiones de desarrollo intermedio y heterógeno entre países "América Latina y El Caribe" y "Asia Oriental y El Pacífico" en el mismo período (2016 - 2025) presentan diferentes trayectorias en la evolución de indicadores económicos y sociales, observándose unaa mejora más acelerada en "Asia Oriental y El Pacífico" en pobreza y crecimiento, mientras que "América Latina y El Caribe" tuvo una mejora más lenta, lo cuál se debe a la desigualdad estructural e inestabilidad macroeconómica.

## Estructura del repositorio

```
├── raw/         
├── input/     
├── auxiliar/     
├── utils/       
├── output/      
├── scripts/     
└── README.md
```

## Datos utilizados
https://databank.worldbank.org/source/world-development-indicators
| Base | Fuente | Unidad de observación | Período | Ubicación en el repo |
|---|---|---|---|---|
| P_Data_Extract_From_World_Development_Indicators.xlsx | Banco Mundial | [países/personas/etc.] | 2016 - 2025 | `raw/P_Data_Extract_From_World_Development_Indicators.xlsx` |

## Cómo correr el proyecto

Los scripts deben ejecutarse en orden. Cada uno guarda sus resultados en `input/` u `output/`, por lo que pueden corrEr de forma independiente siempre que los archivos previos ya existan en el repo.

| Orden | Script | Qué hace | Qué genera |
|---|---|---|---|
| 1 | `scripts/01_limpieza.R` | Limpia y procesa la base cruda, trata faltantes/outliers | `input/base_limpia.csv` |
| 2 | `scripts/02_descriptivos.R` | Estadísticas descriptivas y visualizaciones exploratorias | `output/tabla_descriptivos.csv`, `output/grafico_X.png` |
| 3 | `scripts/03_[metodo].R` | [ej: regresión, ANOVA, etc.] | `output/...` |
| ... | ... | ... | ... |

## Requisitos

- R [versión] con los paquetes: `tidyverse`, `[otros]`...
- Todas las rutas son relativas; el proyecto debe abrirse desde la raíz del repositorio (idealmente como proyecto de RStudio, `.Rproj`).

## Presentación

La presentación se encuentra en [`presentacion/nombre_archivo.pdf`].

## Próximos pasos

[Breve resumen de limitaciones y posibles extensiones — se desarrolla en detalle en la presentación.]
