install.packages("stringr")

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# (esta resolución me la dió el chat, me pareció bastante buena por más que no
# lo hayamos visto así en clase)

#cargo base de datos

datos <- read_excel("(raw)P_Data_Extract_From_World_Development_Indicators (1).xlsx")


# Nombres exactos tal como aparecen en la columna "Series Name" de la base
VAR_MAP <- c(
  "GDP per capita growth (annual %)"                                        = "gdp_pc_growth",
  "Inflation, consumer prices (annual %)"                                   = "inflation",
  "Life expectancy at birth, total (years)"                                 = "life_expectancy",
  "Mortality rate, infant (per 1,000 live births)"                          = "infant_mortality",
  "Government expenditure on education, total (% of GDP)"                   = "edu_expenditure",
  "Gini index"                                                               = "gini",
  "Multidimensional poverty headcount ratio (World Bank) (% of population)" = "poverty_multi"
)

# Variables con peso negativo
# Se invierten DESPUÉS de normalizar
NEGATIVE_VARS <- c("inflation", "infant_mortality", "gini", "poverty_multi")

# no existe humano que tenga la paciencia de hacer esta parte de definir las regiones
region_map <- c(
  # East Asia & Pacific
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
  # Europe & Central Asia
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
  # Latin America & Caribbean
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
  # Middle East & North Africa
  SAU="Middle East & North Africa", IRN="Middle East & North Africa", IRQ="Middle East & North Africa",
  ARE="Middle East & North Africa", ISR="Middle East & North Africa", EGY="Middle East & North Africa",
  DZA="Middle East & North Africa", MAR="Middle East & North Africa", TUN="Middle East & North Africa",
  LBY="Middle East & North Africa", YEM="Middle East & North Africa", SYR="Middle East & North Africa",
  JOR="Middle East & North Africa", LBN="Middle East & North Africa", KWT="Middle East & North Africa",
  QAT="Middle East & North Africa", BHR="Middle East & North Africa", OMN="Middle East & North Africa",
  PSE="Middle East & North Africa", DJI="Middle East & North Africa",
  # North America
  USA="North America", CAN="North America",
  # South Asia
  IND="South Asia", PAK="South Asia", BGD="South Asia", NPL="South Asia",
  LKA="South Asia", AFG="South Asia", BTN="South Asia", MDV="South Asia",
  # Sub-Saharan Africa
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




#en esta parte acomodo los años de la base, que están en columnas
year_cols <- names(datos)[str_detect(names(datos), "YR")]

clean_year_names <- str_extract(year_cols, "^\\d{4}")
names(datos)[names(datos) %in% year_cols] <- clean_year_names

# Filtro las variables de interés
datos <- datos %>%
  filter(`Series Name` %in% names(VAR_MAP)) %>%
  # tratamiento de datos faltantes
  mutate(across(all_of(clean_year_names), ~ na_if(as.character(.), ".."))) %>%
  mutate(across(all_of(clean_year_names), as.numeric)) %>%
  # renombro
  mutate(variable = VAR_MAP[`Series Name`])

df_long <- datos %>%
  select(`Country Name`, `Country Code`, variable, all_of(clean_year_names)) %>%
  pivot_longer(cols = all_of(clean_year_names),
               names_to  = "year",
               values_to = "value")

df_panel <- df_long %>%
  pivot_wider(names_from  = variable,
              values_from = value)

# Agrego región
df_panel <- df_panel %>%
  mutate(region = region_map[`Country Code`]) %>%
  filter(!is.na(region))

# normalizo con min-max
min_max <- function(x) {
  rng <- range(x, na.rm = TRUE)
  if (diff(rng) == 0) return(rep(0.5, length(x)))
  (x - rng[1]) / diff(rng)
}

all_vars <- unname(VAR_MAP)

df_norm <- df_panel %>%
  # Normalizo las variables
  mutate(across(all_of(all_vars), min_max, .names = "{.col}_n")) %>%
  # Invierto las variables negativas
  mutate(across(paste0(NEGATIVE_VARS, "_n"), ~ 1 - .))

# Calculo dimensiones
df_norm <- df_norm %>%
  rowwise() %>%
  mutate(
    dim_economica = mean(c(gdp_pc_growth_n, inflation_n),                          na.rm = TRUE),
    dim_social    = mean(c(life_expectancy_n, infant_mortality_n, edu_expenditure_n), na.rm = TRUE),
    dim_equidad   = mean(c(gini_n, poverty_multi_n),                               na.rm = TRUE)
  ) %>%
  # peso de 1/3 a cada dimensión
  mutate(
    indice_compuesto = mean(c(dim_economica, dim_social, dim_equidad), na.rm = TRUE)
  ) %>%
  ungroup() %>%
  filter(!is.nan(indice_compuesto))

cat("Observaciones con índice calculado:", nrow(df_norm), "\n")
print(df_norm %>%
        group_by(region) %>%
        summarise(n    = n(),
                  media  = round(mean(indice_compuesto), 3),
                  mediana = round(median(indice_compuesto), 3),
                  sd    = round(sd(indice_compuesto), 3)))

#visualización

# Orden de regiones (de menor a mayor mediana aproximada)
region_order <- c(
  "Sub-Saharan Africa",
  "South Asia",
  "Latin America & Caribbean",
  "East Asia & Pacific",
  "North America",
  "Middle East & North Africa",
  "Europe & Central Asia"
)

# Etiquetas en español para el eje X
region_labels <- c(
  "Sub-Saharan Africa"        = "África\nSub-sahariana",
  "South Asia"                = "Asia\nMeridional",
  "Latin America & Caribbean" = "América Latina\n& Caribe",
  "East Asia & Pacific"       = "Asia Oriental\n& Pacífico",
  "North America"             = "América\ndel Norte",
  "Middle East & North Africa"= "Medio Oriente\n& N. África",
  "Europe & Central Asia"     = "Europa &\nAsia Central"
)

# Colores por región
region_colors <- c(
  "Sub-Saharan Africa"         = "#D62728",
  "South Asia"                 = "#FF7F0E",
  "Latin America & Caribbean"  = "#2CA02C",
  "East Asia & Pacific"        = "#17BECF",
  "North America"              = "#9467BD",
  "Middle East & North Africa" = "#BCBD22",
  "Europe & Central Asia"      = "#1F77B4"
)

# Contar observaciones por región para anotación
n_obs <- df_norm %>%
  filter(region %in% region_order) %>%
  count(region) %>%
  mutate(region = factor(region, levels = region_order),
         label  = paste0("n=", n))

df_plot <- df_norm %>%
  filter(region %in% region_order) %>%
  mutate(region = factor(region, levels = region_order))

p <- ggplot(df_plot, aes(x = region, y = indice_compuesto, fill = region)) +
  geom_boxplot(
    outlier.size   = 1.8,
    outlier.alpha  = 0.45,
    width          = 0.6,
    color          = "#333333",
    linewidth      = 0.5
  ) +
  # Cantidad de obs debajo de cada caja
  geom_text(data = n_obs,
            aes(x = region, y = -0.02, label = label),
            inherit.aes = FALSE,
            size = 3, color = "#666666") +
  scale_fill_manual(values = region_colors) +
  scale_x_discrete(labels = region_labels) +
  scale_y_continuous(
    limits = c(-0.04, 1.05),
    breaks = seq(0, 1, 0.2),
    expand = c(0, 0)
  ) +
  labs(
    title    = "Índice Compuesto de Calidad de Vida por Región (2016–2024)",
    subtitle = "Dimensiones: Económica · Social · Equidad  |  Normalización Min-Max · Pesos iguales (1/3)",
    x        = NULL,
    y        = "Índice Compuesto de Calidad de Vida (0–1)",
    caption  = paste0(
      "Dim. Económica: Crecimiento PBI pc (+) · Inflación (−)\n",
      "Dim. Social: Expectativa de vida (+) · Mortalidad infantil (−) · Gasto en educación (+)\n",
      "Dim. Equidad: Índice de Gini (−) · Pobreza multidimensional (−)\n",
      "Fuente: World Development Indicators (WDI), Banco Mundial"
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background    = element_rect(fill = "#F8F9FA", color = NA),
    panel.background   = element_rect(fill = "#F8F9FA", color = NA),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_line(color = "#CCCCCC", linetype = "dashed"),
    legend.position    = "none",
    plot.title         = element_text(face = "bold", size = 14),
    plot.subtitle      = element_text(color = "#555555", size = 9.5),
    plot.caption       = element_text(color = "#444444", size = 8, hjust = 0, face = "italic"),
    axis.text.x        = element_text(face = "bold", size = 10),
    axis.title.y       = element_text(size = 11, margin = margin(r = 10))
  )

print(p)

# Guardado
ggsave("boxplot_indice_compuesto.png", plot = p,
       width = 13, height = 9, dpi = 180, bg = "#F8F9FA")

cat("Gráfico guardado como boxplot_indice_compuesto.png\n")
