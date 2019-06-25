# Codigo carreras genericas -  pjcarozzi@uc.cl 

library(dplyr)
library(stringr)
library(tidyr)
library(data.table)
library(here)
rm(list=ls())

notallna <- function(x) {!all(is.na(x))}

unwanted_array <- list(   'S'='S', 's'='s', 'Z'='Z', 'z'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A', 'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E',
                          'Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I', 'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O', 'Ù'='U',
                          'Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a', 'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c',
                          'è'='e', 'é'='e', 'ê'='e', 'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o', 'ô'='o', 'õ'='o',
                          'ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y', 'þ'='b', 'ÿ'='y' )
# Para transformar
# chartr(paste(names(unwanted_array), collapse=''),
#        paste(unwanted_array, collapse=''),
#        string)

# Identificar carreras genericas segun Mi Futuro,
# Por nombre de carrera y universidad

# Bases:
# las bases de empleabilidad contienen datos por Carrera/Institución.
# Tienen el nombre de carrera y carrera genérica, pero los datos de ingreso
# estan por tramo
# Las bases de estadísticas tienen calculado el ingreso medio por año, mas los 
# Cuartiles de ingreso por año, pero tienen menos carreras y no traen
# el nombre de la carrera/institucion


# Empleabilidad 2018
emp18 <- readxl::read_excel(here("data","MiFuturo","buscador_empleabilidad_e_ingresos_2018.xlsx"), n_max=1742, na="s/i") %>% 
  mutate_at(vars("Nombre carrera genérica"), funs(ifelse(.=="Derecho*","Derecho",.)))

# Empleabilidad 2018 2019
emp1819 <- readxl::read_excel(here("data","MiFuturo","buscador_empleabilidad_e_ingresos_2018_2019.xlsx"), n_max=1575, na="s/i") 

# Estadisticas por carrera 2018
headers <- readxl::read_excel(here("data","MiFuturo","estadisticas_por_carrera_2018.xlsx"), n_max = 2, col_names = F)
headers <- data.frame(t(headers)) %>% 
  mutate(X1=case_when(grepl("Ingreso promedio bruto", X1) ~ "IPB",
                      grepl("Tramos de ingreso bruto", X1) ~ "TIB",
                      grepl("Empleabilidad", X1) ~ "EMP",
                      grepl("Evolución de ingresos", X1) ~ "EIB",
                      grepl("Titulados", X1) ~ "TIT",
                      grepl("Duración", X1) ~ "DUR",
                      grepl("Matrícula 1er año", X1) ~ "MAT1",
                      grepl("Matrícula Total", X1) ~ "MATT",
                      grepl("Retención", X1) ~ "RET",
                      grepl("Rangos", X1) ~ "RAR",
                      grepl("Distribución", X1) ~ "DEO",
                      TRUE ~ NA_character_)) %>% 
  mutate(var=rep(1:15, times = c(1,1,1,1,5,10,2,10,3,2,3,3,2,7,4))) %>% 
  group_by(var) %>% fill(X1) %>% ungroup() %>% 
  unite(var,X1,X2, sep="_", remove = F) %>% mutate(var=ifelse(is.na(X1),as.character(X2),var)) %>% pull(var)

est18 <- readxl::read_excel(here("data","MiFuturo","estadisticas_por_carrera_2018.xlsx"), skip=2, col_names = headers, n_max = 264, na=c("s/i","n/a")) %>% 
  mutate_at(vars("Carrera genérica"), funs(ifelse(.=="Derecho (*)","Derecho",.)))

# Extadisticas por carrera 2018 - 2019
est1819 <- readxl::read_excel(here("data","MiFuturo","buscador_estadísticas_por_carrera_2018_2019.xlsx"), skip=2, col_names = headers, n_max = 249, na=c("s/i","n/a")) %>% 
  mutate_at(vars("Carrera genérica"), funs(ifelse(.=="Derecho*","Derecho",.)))
  
# Base filtrada Jules
oferta <- readxl::read_excel(here("output","oferta2016_filtrada_carrera_ind_inst.xlsx"))



# 1
# Reunir nombres carrera generica
ncg1 <- emp18 %>% select("Nombre carrera genérica") %>% rename(NCG="Nombre carrera genérica") %>% distinct() %>% mutate(emp18=1)

ncg2 <- emp1819 %>% select("Nombre carrera genérica") %>% rename(NCG="Nombre carrera genérica") %>% distinct() %>% mutate(emp1819=1)

ncg3 <- est18 %>% select("Carrera genérica") %>% rename(NCG="Carrera genérica") %>% distinct() %>% mutate(est18=1)

ncg4 <- est1819 %>% select("Carrera genérica") %>% rename(NCG="Carrera genérica") %>% distinct() %>% mutate(est1819=1)

ncg <- full_join(ncg1,ncg2, by="NCG") %>% full_join(.,ncg3, by="NCG") %>% full_join(.,ncg4, by="NCG")
rm(ncg1,ncg2,ncg3,ncg4)

# 2
# Estadisticas por carrera. Si no hay datos para 2018, pegar 2018/2019
est_a <- filter(ncg, !is.na(est18)) %>% left_join(.,est18, by=c("NCG"="Carrera genérica"))
est_b <- filter(ncg, is.na(est18)) %>% left_join(.,est1819, by=c("NCG"="Carrera genérica"))
est <- bind_rows(est_a, est_b)
rm(est_a,est_b)


# 3
# Pegarle datos empleabilidad. Si no hay datos para 2018, pegar 2018/2019
emp18 <- rename(emp18, NCG="Nombre carrera genérica")
emp1819 <- rename(emp1819, NCG="Nombre carrera genérica")

emp_a_1 <- filter(est, !is.na(ID) & !is.na(emp18)) %>% left_join(.,emp18, by=c("NCG","Tipo de institución"))
emp_a_2 <- filter(est, !is.na(ID) & is.na(emp18))
emp_b_1 <- filter(est, is.na(ID) & !is.na(emp18)) %>% left_join(.,emp18, by="NCG")
emp_b_2 <- filter(est, is.na(ID) & is.na(emp18)) %>% left_join(.,emp1819, by="NCG")

ing_emp <- bind_rows(emp_a_1, emp_a_2, emp_b_1, emp_b_2)
rm(emp_a_1, emp_a_2, emp_b_1, emp_b_2)


# 4
# Quitar variables con sufijo
ing_emp <- ing_emp %>% 
  mutate_at(vars("Área"),funs(ifelse(is.na(.),`Área.y`,.))) %>% 
  mutate_at(vars("Área"),funs(ifelse(is.na(.),`Área.x`,.))) %>% 
  mutate_at(vars("Tipo de institución"),funs(ifelse(is.na(.),`Tipo de institución.y`,.))) %>% 
  select(-Área.y,-Área.x,-`Tipo de institución.y`,-`Tipo de institución.x`) %>% 
  select(NCG,emp18,emp1819,est18,est1819,ID,Área,`Tipo de institución`,everything())

xlsx::write.xlsx(ing_emp,file = "output/empleabilidad_ingreso_carrera.xlsx")

# 5
# Filtrar (universidades, c/ncg, s/ncg)
ing_emp_u <- ing_emp %>% filter(`Tipo de institución`=="Universidades")

headers <- headers[-3]
ing_emp_ncg <- ing_emp_u %>% filter(!is.na(ID)) %>% select(1:59) %>% distinct() %>% select(1:5,one_of(headers))

ing_emp_ncg_na <- ing_emp_u %>% filter(is.na(ID)) %>% select(1:5,Área,`Tipo de institución`,60:73) %>% 
  rename("EMP_Empleabilidad 1er año"=14,
         "RET_Retención 1er año"=12) %>% 
  group_by(NCG) %>% mutate(n = n())
# ver si pegamos estas categorias 

# 6 
# Ver si calza con oferta
ing_emp_ncg_of <- full_join(ing_emp_ncg,oferta, by = c("NCG"="AREA_CARRERA_GENERICA")) %>% filter(!is.na(ID))
ing_emp_ncg_ofna <- full_join(ing_emp_ncg,oferta, by = c("NCG"="AREA_CARRERA_GENERICA")) %>% filter(is.na(ID)) %>% select_if(notallna)

ing_emp_ncg_ofna <- mutate_at(vars(`Nombre de institución`,`Nombre carrera`),
                              funs(chartr(paste(names(unwanted_array), collapse=''),
                                          paste(unwanted_array, collapse=''),.)))

# En vola estos se pueden recuperar al hacer cruce con carrera institucion.
