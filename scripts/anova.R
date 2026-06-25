install.packages("car")
library(car)

#### ============================================================
#### PROYECTO: Desigualdad en el desarrollo global (WDI)
#### Script base: carga de datos -> indice compuesto -> ANOVA + Tukey
#### ============================================================

library(tidyverse)  
library(readxl)
library(car)        

#### 1. CARGA DE DATOS -------------------------------------------

datos <- read_excel("(raw)P_Data_Extract_From_World_Development_Indicators (1).xlsx",
                    sheet = "Data")

#### 2. MAPEO DE VARIABLES Y REGIONES ------------------------------

VAR_MAP <- c(
  "GDP per capita growth (annual %)"                                        = "gdp_pc_growth",
  "Inflation, consumer prices (annual %)"                                   = "inflation",
  "Life expectancy at birth, total (years)"                                 = "life_expectancy",
  "Mortality rate, infant (per 1,000 live births)"                          = "infant_mortality",
  "Government expenditure on education, total (% of GDP)"                   = "edu_expenditure",
  "Gini index"                                                               = "gini",
  "Multidimensional poverty headcount ratio (World Bank) (% of population)" = "poverty_multi"
)

NEGATIVE_VARS <- c("inflation", "infant_mortality", "gini", "poverty_multi")

region_map <- c(
  CHN="East Asia & Pacific", JPN="East Asia & Pacific", KOR="East Asia & Pacific",
  AUS="East Asia & Pacific", NZL="East Asia & Pacific", IDN="East Asia & Pacific",
  MYS="East Asia & Pacific", PHL="East Asia & Pacific", THA="East Asia & Pacific",
  VNM="East Asia & Pacific", MMR="East Asia & Pacific", KHM="East Asia & Pacific",
  LAO="East Asia & Pacific", MNG="East Asia & Pacific", FJI="East Asia & Pacific",
  PNG="East Asia & Pacific", WSM="East Asia & Pacific", TON="East Asia & Pacific",
  VUT="East Asia & Pacific", FSM="East Asia & Pacific", KIR="East Asia & Pacific",
  MHL="East Asia & Pacific", PLW="East Asia & Pacific", SLB="East Asia & Pacific",
  TLS="East Asia & Pacific", BRN="East Asia & Pacific", SGP="East Asia & Pacific",
  PRK="East Asia & Pacific", TWN="East Asia & Pacific", HKG="East Asia & Pacific",
  MAC="East Asia & Pacific", ASM="East Asia & Pacific", GUM="East Asia & Pacific",
  MNP="East Asia & Pacific", NCL="East Asia & Pacific", PYF="East Asia & Pacific",
  NRU="East Asia & Pacific", TUV="East Asia & Pacific",
  DEU="Europe & Central Asia", FRA="Europe & Central Asia", GBR="Europe & Central Asia",
  ITA="Europe & Central Asia", ESP="Europe & Central Asia", POL="Europe & Central Asia",
  NLD="Europe & Central Asia", BEL="Europe & Central Asia", SWE="Europe & Central Asia",
  AUT="Europe & Central Asia", CHE="Europe & Central Asia", DNK="Europe & Central Asia",
  NOR="Europe & Central Asia", FIN="Europe & Central Asia", GRC="Europe & Central Asia",
  PRT="Europe & Central Asia", CZE="Europe & Central Asia", HUN="Europe & Central Asia",
  ROU="Europe & Central Asia", BGR="Europe & Central Asia", HRV="Europe & Central Asia",
  SVK="Europe & Central Asia", SVN="Europe & Central Asia", LTU="Europe & Central Asia",
  LVA="Europe & Central Asia", EST="Europe & Central Asia", BLR="Europe & Central Asia",
  UKR="Europe & Central Asia", MDA="Europe & Central Asia", RUS="Europe & Central Asia",
  KAZ="Europe & Central Asia", UZB="Europe & Central Asia", TKM="Europe & Central Asia",
  KGZ="Europe & Central Asia", TJK="Europe & Central Asia", AZE="Europe & Central Asia",
  ARM="Europe & Central Asia", GEO="Europe & Central Asia", TUR="Europe & Central Asia",
  ALB="Europe & Central Asia", BIH="Europe & Central Asia", MKD="Europe & Central Asia",
  MNE="Europe & Central Asia", SRB="Europe & Central Asia", XKX="Europe & Central Asia",
  LUX="Europe & Central Asia", IRL="Europe & Central Asia", ISL="Europe & Central Asia",
  LIE="Europe & Central Asia", MCO="Europe & Central Asia", SMR="Europe & Central Asia",
  AND="Europe & Central Asia", MLT="Europe & Central Asia", CYP="Europe & Central Asia",
  FRO="Europe & Central Asia", GIB="Europe & Central Asia", IMN="Europe & Central Asia",
  CHI="Europe & Central Asia", GRL="Europe & Central Asia",
  BRA="Latin America & Caribbean", MEX="Latin America & Caribbean", ARG="Latin America & Caribbean",
  COL="Latin America & Caribbean", CHL="Latin America & Caribbean", PER="Latin America & Caribbean",
  VEN="Latin America & Caribbean", ECU="Latin America & Caribbean", BOL="Latin America & Caribbean",
  PRY="Latin America & Caribbean", URY="Latin America & Caribbean", GTM="Latin America & Caribbean",
  HND="Latin America & Caribbean", SLV="Latin America & Caribbean", NIC="Latin America & Caribbean",
  CRI="Latin America & Caribbean", PAN="Latin America & Caribbean", DOM="Latin America & Caribbean",
  CUB="Latin America & Caribbean", HTI="Latin America & Caribbean", JAM="Latin America & Caribbean",
  TTO="Latin America & Caribbean", BRB="Latin America & Caribbean", GUY="Latin America & Caribbean",
  SUR="Latin America & Caribbean", BLZ="Latin America & Caribbean", BHS="Latin America & Caribbean",
  DMA="Latin America & Caribbean", GRD="Latin America & Caribbean", LCA="Latin America & Caribbean",
  VCT="Latin America & Caribbean", ATG="Latin America & Caribbean", KNA="Latin America & Caribbean",
  ABW="Latin America & Caribbean", CUW="Latin America & Caribbean", SXM="Latin America & Caribbean",
  TCA="Latin America & Caribbean", VGB="Latin America & Caribbean", CYM="Latin America & Caribbean",
  MSR="Latin America & Caribbean", BMU="Latin America & Caribbean", PRI="Latin America & Caribbean",
  VIR="Latin America & Caribbean", GLP="Latin America & Caribbean", MTQ="Latin America & Caribbean",
  GUF="Latin America & Caribbean", BLM="Latin America & Caribbean", MAF="Latin America & Caribbean",
  SAU="Middle East & North Africa", IRN="Middle East & North Africa", IRQ="Middle East & North Africa",
  ARE="Middle East & North Africa", ISR="Middle East & North Africa", EGY="Middle East & North Africa",
  DZA="Middle East & North Africa", MAR="Middle East & North Africa", TUN="Middle East & North Africa",
  LBY="Middle East & North Africa", YEM="Middle East & North Africa", SYR="Middle East & North Africa",
  JOR="Middle East & North Africa", LBN="Middle East & North Africa", KWT="Middle East & North Africa",
  QAT="Middle East & North Africa", BHR="Middle East & North Africa", OMN="Middle East & North Africa",
  PSE="Middle East & North Africa", DJI="Middle East & North Africa",
  USA="North America", CAN="North America",
  IND="South Asia", PAK="South Asia", BGD="South Asia", NPL="South Asia",
  LKA="South Asia", AFG="South Asia", BTN="South Asia", MDV="South Asia",
  NGA="Sub-Saharan Africa", ETH="Sub-Saharan Africa", COD="Sub-Saharan Africa",
  TZA="Sub-Saharan Africa", KEN="Sub-Saharan Africa", ZAF="Sub-Saharan Africa",
  UGA="Sub-Saharan Africa", GHA="Sub-Saharan Africa", MOZ="Sub-Saharan Africa",
  MDG="Sub-Saharan Africa", CMR="Sub-Saharan Africa", CIV="Sub-Saharan Africa",
  AGO="Sub-Saharan Africa", NER="Sub-Saharan Africa", BFA="Sub-Saharan Africa",
  MLI="Sub-Saharan Africa", MWI="Sub-Saharan Africa", SOM="Sub-Saharan Africa",
  ZMB="Sub-Saharan Africa", SEN="Sub-Saharan Africa", TCD="Sub-Saharan Africa",
  GIN="Sub-Saharan Africa", RWA="Sub-Saharan Africa", BEN="Sub-Saharan Africa",
  BDI="Sub-Saharan Africa", SSD="Sub-Saharan Africa", ERI="Sub-Saharan Africa",
  SLE="Sub-Saharan Africa", TGO="Sub-Saharan Africa", CAF="Sub-Saharan Africa",
  MRT="Sub-Saharan Africa", COG="Sub-Saharan Africa", LBR="Sub-Saharan Africa",
  ZWE="Sub-Saharan Africa", NAM="Sub-Saharan Africa", BWA="Sub-Saharan Africa",
  LSO="Sub-Saharan Africa", GMB="Sub-Saharan Africa", GAB="Sub-Saharan Africa",
  GNB="Sub-Saharan Africa", GNQ="Sub-Saharan Africa", MUS="Sub-Saharan Africa",
  SWZ="Sub-Saharan Africa", CPV="Sub-Saharan Africa", COM="Sub-Saharan Africa",
  STP="Sub-Saharan Africa", SYC="Sub-Saharan Africa", SDN="Sub-Saharan Africa"
)

# Region (WDI default) -> grupo de la hipotesis (centro/periferia/intermedia)
# AJUSTAR si en su hipotesis lo definieron distinto
grupo_map <- c(
  "North America"               = "central",
  "Europe & Central Asia"       = "central",
  "East Asia & Pacific"         = "intermedia",
  "Middle East & North Africa"  = "intermedia",
  "Latin America & Caribbean"   = "periferica",
  "South Asia"                  = "periferica",
  "Sub-Saharan Africa"          = "periferica"
)

#### 3. LIMPIEZA Y RESHAPE A FORMATO LARGO -------------------------

year_cols <- names(datos)[str_detect(names(datos), "YR")]
clean_year_names <- str_extract(year_cols, "^\\d{4}")
names(datos)[names(datos) %in% year_cols] <- clean_year_names

datos <- datos %>%
  filter(`Series Name` %in% names(VAR_MAP)) %>%
  mutate(across(all_of(clean_year_names), ~ na_if(as.character(.), ".."))) %>%
  mutate(across(all_of(clean_year_names), as.numeric)) %>%
  mutate(variable = VAR_MAP[`Series Name`])

df_long <- datos %>%
  select(`Country Name`, `Country Code`, variable, all_of(clean_year_names)) %>%
  pivot_longer(cols = all_of(clean_year_names), names_to = "year", values_to = "value")

df_panel <- df_long %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(region = region_map[`Country Code`]) %>%
  filter(!is.na(region))

#### 4. NORMALIZACION Y CONSTRUCCION DEL INDICE COMPUESTO ----------

min_max <- function(x) {
  rng <- range(x, na.rm = TRUE)
  if (diff(rng) == 0) return(rep(0.5, length(x)))
  (x - rng[1]) / diff(rng)
}

all_vars <- unname(VAR_MAP)

df_norm <- df_panel %>%
  mutate(across(all_of(all_vars), min_max, .names = "{.col}_n")) %>%
  mutate(across(paste0(NEGATIVE_VARS, "_n"), ~ 1 - .))

df_norm <- df_norm %>%
  rowwise() %>%
  mutate(
    dim_economica = mean(c(gdp_pc_growth_n, inflation_n), na.rm = TRUE),
    dim_social    = mean(c(life_expectancy_n, infant_mortality_n, edu_expenditure_n), na.rm = TRUE),
    dim_equidad   = mean(c(gini_n, poverty_multi_n), na.rm = TRUE)
  ) %>%
  mutate(indice_compuesto = mean(c(dim_economica, dim_social, dim_equidad), na.rm = TRUE)) %>%
  ungroup() %>%
  filter(!is.nan(indice_compuesto))

#### 5. VISTA RAPIDA DEL INDICE -----------------------------------

# Tabla completa
# View(df_norm)

# Resumen por region y año
df_norm %>%
  group_by(region, year) %>%
  summarise(media_indice = mean(indice_compuesto, na.rm = TRUE), .groups = "drop")

# Boxplot exploratorio
ggplot(df_norm, aes(x = region, y = indice_compuesto, fill = region)) +
  geom_boxplot() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  labs(title = "Indice de Calidad de Vida por region", x = "", y = "Indice")

#### 6. ARMADO DE LA BASE PARA EL ANOVA (PAISES INDIVIDUALES) ------
#### NOTA: 2025 no tiene cobertura de datos en la base WDI descargada.
#### Se usa 2022 como "año final" (mejor cobertura disponible para
#### Gini y pobreza multidimensional, las variables mas restrictivas).

ANIO_FINAL <- "2022"

df_anova <- df_norm %>%
  filter(year == ANIO_FINAL) %>%
  mutate(grupo = grupo_map[region]) %>%
  filter(!is.na(grupo)) %>%
  mutate(grupo = factor(grupo, levels = c("periferica", "intermedia", "central")))

cat("Paises incluidos en el ANOVA:", nrow(df_anova), "\n")
df_anova %>% count(grupo)

#### 7. CHEQUEO DE SUPUESTOS --------------------------------------

shapiro.test(df_anova$indice_compuesto)
leveneTest(indice_compuesto ~ grupo, data = df_anova)

#### 8. ANOVA + TUKEY HSD ------------------------------------------

modelo <- aov(indice_compuesto ~ grupo, data = df_anova)
summary(modelo)

TukeyHSD(modelo)

# Visualizacion de las comparaciones de Tukey
plot(TukeyHSD(modelo))

summary(modelo)
TukeyHSD(modelo)
