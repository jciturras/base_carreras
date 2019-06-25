# Codigo carreras -  jciturra@uc.cl 

library(dplyr)
library(data.table)
library(here)
rm(list=ls())
#******************************************************************************************
 # - Año 2016 es el más relevante
#******************************************************************************************

# Oferta Académica 2010 - 2019
  # - Arancel 
  # - Costo de Titulación
  # - Puntaje Corte
  # - % PSU por cada carrera
  # - Matricula Anual
  # - Vacante Semestre 01 y 02
oferta1 <- fread(here("data","OfertaAcademica","OFICIAL_OA_2010_AL_2019_21_01_2019_V1.csv")) 

# Matricula  - info Carreras 2007 - 2018
# - % por género
# - Seleccionar agno 2016
matr1   <- fread(here("data","Matricula","MATRICULA_2007_AL_2018_SIES_28062018.csv"))  

# Mi futuro - Mercado laboral -  Estadísticas por carrera
# - Tramos de Ingreso año 1 a 5 
    # - Los ingresos al 1er año después de su titulación corresponden al promedio de ingresos percibidos por las cohortes de titulados 2014, 2015 y ***2016*** 
# - Empleabilidad año **1** y 2
estcarreras18 <- readxl::read_excel(here("data","MiFuturo","estadisticas_por_carrera_2018b.xlsx")) 

# Mi futuro - info carreras  2018
  # - % PSU
  # - N matricula por género
  # - Arancel Anual
  # - Costo de Titulación
  # - Titulación por género
  # - Rango de ingresos al Primero año de titulación

mifut18 <- readxl::read_excel(here("data","MiFuturo","buscador_de_carreras_2018.xlsx")) 
mifut19 <- readxl::read_excel(here("data","MiFuturo","buscador_de_carreras_2019.xlsx")) 

# Mi futuro - Mercado laboral
# - Empleabilidad al primer año
# - Ingreso Promedio al 4to año de titulación
merlab18 <- readxl::read_excel(here("data","MiFuturo","buscador_empleabilidad_e_ingresos_2018.xlsx")) 

#******************************************************************************************************************************** 
# CODIGO ************************************************************************************************************************
#********************************************************************************************************************************

of1 <- oferta1 %>% filter(PONDERACION_LENGUAJE>0 & PONDERACION_MATEMATICAS>0 & A�O==2016 & NIVEL_GLOBAL=="Pregrado" & TIPO_IES %in% c("A","B","C") & TIPO_CARRERA == "Plan Regular" )
instituciones <- of1 %>% group_by(CODIGO_IES,NOMBRE_IES) %>% summarise(n=n()) 

# - 43 instituciones Universitarias 

codigos             <- of1 %>% select(starts_with(match = "COD"), JORNADA,VERSION,NOMBRE_IES, NOMBRE_CARRERA) 
carreras            <- of1 %>% group_by(NOMBRE_CARRERA) %>% summarise(n=n()) %>% select(-n)
carreras            <- tibble::rowid_to_column(carreras, "ID_CARRERA")
carreras$ID_CARRERA <- stringr::str_pad(carreras$ID_CARRERA,width = 4, pad = "0")

xlsx::write.xlsx(carreras,file = "output/cod_carrera.xlsx")
# PJCL: lo guarde en output.

of1_a <- left_join(x = of1,y = carreras,"NOMBRE_CARRERA") 
# - Ahora tenemos un ID_CARRERA independiente de la institución

xlsx::write.xlsx(of1_a,file = "output/oferta2016_filtrada_carrera_ind_inst.xlsx")
# PJCL: lo guarde en output para empezar a pegarle cosas.

areascon <- of1_a %>% group_by(NOMBRE_CARRERA,ID_CARRERA,OECD_SUBAREA) %>% summarise(n=n()) 
# -  Con esta base se pueden ordenar las áreas que necesita Andrea

# NOTA: A. Canales está usando 9 categorías de área de conocimiento.

# 01	Administración y Comercio	
# 02	Agropecuaria
# 03	Arte y Arquitectura	
# 04	Ciencias Básicas	
# 05	Ciencias Sociales	
# 06	Derecho
# 07	Educación	
# 08	Humanidades
# 09	Salud	
# 10  Tecnología	

# ---------- 1997--- 
# Educación..........................................
# Humanidades y Arte.................................
# Ciencias sociales, educación comercial y derecho...
# Ciencias...........................................
# Ingeniería, industria y construcción...............
# Agricultura........................................
# Salud y servicios..................................
# servicios..........................................

# ---------- 2013--- 
# 00 Generic programmes and qualifications ..........
# 01 Education ......................................
# 02 Arts and Humanities ............................
# 03 Social Sciences, Journalism and Information ....
# 04 Business, Administration and Law ...............
# 05 Natural Sciences, Mathematics and Statistics ...
# 06 Information and Communication Technologies .....
# 07 Engineering, Manufacturing and Construction ....
# 08 Agriculture, Forestry, Fisheries and Veterinary. 
# 09 Health and Welfare .............................
# 10 Services .......................................

