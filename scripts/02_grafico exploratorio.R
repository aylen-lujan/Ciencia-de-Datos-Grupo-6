library(tidyverse)
library(countrycode)
Base_grafico<-base_limpia %>% select(nombre_pais, anio, `Crecimiento del PIB (% anual)`, "Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)", region)
Base_grafico<-Base_grafico %>% filter(region %in% c("América Latina y el Caribe", "Asia Oriental y el Pacífico"))
Base_grafico<-Base_grafico%>% group_by(nombre_pais, region)
Base_grafico<-Base_grafico %>% summarise(PBI_INICIAL = `Crecimiento del PIB (% anual)`[anio >= 2016 & anio<= 2018 & !is.na(`Crecimiento del PIB (% anual)`)] [1], PBI_ULTIMO = `Crecimiento del PIB (% anual)`[anio >= 2021 & anio <= 2025 & !is.na(`Crecimiento del PIB (% anual)`)] %>% tail(1) %>% c(NA) %>% head(1), POB_INICIAL = `Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)`[anio >= 2016 & anio<= 2018 & !is.na(`Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)`)] [1], POB_ULTIMO = `Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)`[anio >= 2021 & anio <= 2025 & !is.na(`Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)`)] %>% tail(1) %>% c(NA) %>% head(1), .groups = "drop")
Base_grafico<-Base_grafico %>% mutate(variacion_pbi = ((PBI_ULTIMO - PBI_INICIAL) / PBI_INICIAL), variacion_pobreza = (POB_ULTIMO - POB_INICIAL) / POB_INICIAL)
Base_grafico<-Base_grafico%>% mutate(variacion_pobreza =  as.numeric(as.character(variacion_pobreza)), POB_ULTIMO= as.numeric (as.character(POB_ULTIMO)), POB_INICIAL=as.numeric(as.character(POB_INICIAL)))
Base_grafico<-Base_grafico%>% mutate(variacion_pobreza = case_when(!is.na(variacion_pobreza) ~ variacion_pobreza, is.na(variacion_pobreza) & !is.na(POB_ULTIMO) ~ POB_ULTIMO, is.na(variacion_pobreza) & is.na(POB_ULTIMO) & !is.na(POB_INICIAL) ~ POB_INICIAL, TRUE ~ NA_real_))
library(scales)
library(ggplot2)

mediana_x <- median(Base_grafico$variacion_pbi, na.rm = TRUE)
mediana_y <- median(Base_grafico$variacion_pobreza, na.rm = TRUE)


Grafico_Exploratorio<-ggplot(Base_grafico, aes(x=variacion_pbi, y=variacion_pobreza)) + 
geom_point(aes(color = region), size = 3.5, alpha = 0.6) +
geom_vline(xintercept = mediana_x, linetype = "dashed", color = "grey40", size = 0.6) +
geom_hline(yintercept = mediana_y, linetype = "dashed", color = "grey40", size = 0.6) +
scale_color_manual(values = c ("América Latina y el Caribe" = "#FFC1C1", "Asia Oriental y el Pacífico" = "#90EE90" )) +
labs(title = "Variación del PBI y la pobreza a traves de los años -\ncuatro cuadrantes", subtitle = "Variaciones en 10 años,lineas en la mediana.\nCada cuadrante define un tipo de pais", x="Variación del PBI", y="Variación de la Pobreza", color="Region") +
scale_x_continuous(labels = scales::percent_format(accuracy = 1), limits = c(-3, 3)) + scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(-3, 3)) +
theme_minimal() + theme(plot.title = element_text(face = "bold", size = 15, color = "#2C3E50", margin = margin(b = 5)),plot.subtitle = element_text(color = "grey50", size = 11, margin = margin(b = 15)), legend.position = "bottom", legend.direction = "horizontal", panel.grid.minor = element_blank()) +
#lo siguiente fue dado por el chat:
annotate("text", x = -3, y = 3, label = "Baja var. PIB\nAlta var. pobreza", hjust = 0, vjust = 1, color = "grey30", size = 3.5) +
annotate("text", x = 3, y = 3, label = "Alta var. PIB\nAlta var. pobreza", hjust = 1, vjust = 1, color = "grey30", size = 3.5) +
annotate("text", x = -3, y = -3, label = "Baja var. PIB\nBaja var. pobreza", hjust = 0, vjust = 0, color = "grey30", size = 3.5) +
annotate("text", x = 3, y = -3, label = "Alta var. PIB\nBaja var. pobreza", hjust = 1, vjust = 0, color = "grey30", size = 3.5) + 
annotate("text", x = min(Base_grafico$variacion_pbi, na.rm=T), y = max(Base_grafico$variacion_pobreza, na.rm=T), label = "Baja var. PIB\nAlta var. pobreza", hjust = 0, vjust = 1, color = "grey30", size = 3.5) +
annotate("text", x = max(Base_grafico$variacion_pbi, na.rm=T), y = max(Base_grafico$variacion_pobreza, na.rm=T), label = "Alta var. PIB\nAlta var. pobreza", hjust = 1, vjust = 1, color = "grey30", size = 3.5) +
annotate("text", x = min(Base_grafico$variacion_pbi, na.rm=T), y = min(Base_grafico$variacion_pobreza, na.rm=T), label = "Baja var. PIB\nBaja var. pobreza", hjust = 0, vjust = 0, color = "grey30", size = 3.5) +
annotate("text", x = max(Base_grafico$variacion_pbi, na.rm=T), y = min(Base_grafico$variacion_pobreza, na.rm=T), label = "Alta var. PIB\nBaja var. pobreza", hjust = 1, vjust = 0, color = "grey30", size = 3.5)
write_csv(Base_grafico, "input/Base_grafico.csv")
ggsave(filename = "output/Grafico_Exploratorio.png", plot = Grafico_Exploratorio, width = 8, height = 6, dpi = 300)