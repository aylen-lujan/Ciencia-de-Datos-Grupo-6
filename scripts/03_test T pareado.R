library(tidyverse)
library(countrycode)
library(dplyr)
#modificamos nuestra base limpia para poder comenzar con nuestro analisis
base_testt<-base_limpia %>% select(nombre_pais,region,anio,`Crecimiento del PIB (% anual)`,`Crecimiento del PIB per cápita (% anual)`,"Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)") 

#Forzamos a R para que entienda las variables de la base como numeros reales
base_testt<-base_testt %>% mutate(pbi=as.numeric(as.character(`Crecimiento del PIB (% anual)`)), pbi_pc=as.numeric(as.character(`Crecimiento del PIB per cápita (% anual)`)), pob=as.numeric(as.character(`Índice de recuento de la pobreza multidimensional (Banco Mundial) (% de la población)`)))

#A partir de aca tuve que crear una base nueva donde no se eliminen paises y poder hacer el group_by reconociendolos, desde aca obtenemos los promedios
base_paises_testt<- base_testt %>% group_by(nombre_pais, region) %>% summarise(pbi_inicial = pbi[anio >= 2016 & anio <= 2018 & !is.na(pbi)][1],
                                                                        pbi_final= pbi[anio >= 2021 & anio <= 2025 & !is.na(pbi)] %>% tail(1) %>% c(NA) %>% head(1), 
                                                                        pbi_pc_inicial = pbi_pc[anio >= 2016 & anio <= 2018 & !is.na(pbi_pc)][1], 
                                                                        pbi_pc_final= pbi_pc[anio >= 2021 & anio <= 2025 & !is.na(pbi_pc)] %>% tail(1) %>% c(NA) %>% head(1), 
                                                                        pob_inicial = pob[anio >= 2016 & anio <= 2018 & !is.na(pob)][1], 
                                                                        pob_final= pob[anio >= 2021 & anio <= 2025 & !is.na(pob)] %>% tail(1) %>% c(NA) %>% head(1), .groups = "drop") #en esta parte hicimos lo mismo que tuvimos que hacer para el grafico de Scatterplot, filtramos los años para evitar que haya NA. Como año incial podiamos tomar el primer año entre 2016 y 2018 con datos y como año final podiamos tomar el ultimo año entre 2025 y 2021 con datos.  

#El siguiente filtro lo hacemos antes de correr los demas Test ya que si lo hacemos una vez hechos, nos va a saltar un error diciendo que los datos no son suficientes para hacer comparaciones.
base_latam_testt<-base_paises_testt %>% filter(region == "América Latina y el Caribe"); base_asia_testt<-base_paises_testt %>% filter(region == "Asia Oriental y el Pacífico")


#Comenzamos a realizar el Test-T para la hipotesis principal
#1- Test-T para PBI
test_pbi <- t.test(base_paises_testt$`pbi_final`, base_paises_testt$`pbi_inicial`, paired = TRUE, alternative = "two.sided")
print("RESULTADOS TEST-T: PBI")
print(test_pbi)

#2- Test-T para PBI PERCAPITA
test_pbi_pc <- t.test(base_paises_testt$pbi_pc_final, base_paises_testt$pbi_pc_inicial, paired = TRUE, alternative = "two.sided")
print("RESULTADOS TEST-T: PBI PER-CAPITA")
print(test_pbi_pc)

#3- Test-T para Pobreza
test_pob <- t.test(base_paises_testt$pob_final, base_paises_testt$pob_inicial, paired = TRUE, alternative = "two.sided")
print("RESULTADOS TEST-T: POBREZA")
print(test_pob)

#Ahora vamos a realizar el Test-T para la hipotesis secundaria, filtrando solo las regiones de America Latina y el Cariba y Asia Oriental y el Pacifico
#AMERICA LATINA Y EL CARIBE:

#1- Test-T para PBI
test_pbi_latam <- t.test(base_latam_testt$pbi_final, base_latam_testt$pbi_inicial, paired = TRUE)
print("PBI AMERIcA LATINA")
print(test_pbi_latam)

#2- Test-T para Pobreza
test_pob_latam <- t.test(base_latam_testt$pob_final, base_latam_testt$pob_inicial, paired = TRUE)
print("POBREZA AMERICA LATINA ")
print(test_pob_latam)

#ASIA ORIENTAL Y EL PACIFICO:

#1- Test-T para PBI
test_pbi_asia <- t.test(base_asia_testt$pbi_final, base_asia_testt$pbi_inicial, paired= TRUE)
print("PBI ASIA")
print(test_pbi_asia)
#2- Test-T para Pobreza
test_pob_asia <- t.test(base_asia_testt$pob_final, base_asia_testt$pob_inicial, paired=TRUE)
print("POBREZA ASIA")
print(test_pob_asia)




