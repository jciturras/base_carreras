# base_carreras


# Instrucciones
Además hay que considerar estos 2 papers para definir el tema de los puntajes de corte. El paper de Hallsten es mejor.

La información mínima que se requiere de las carreras para hacer el análisis con rank order logit es la siguiente:

* Salario de carrera (mediana para la carrera, no nos interesa la institución)
* Proporción mujeres en la carrera (se puede calcular con PSU matricula año anterior)
* Tipo de universidades (tradicional, privada, o nivel de selectivad)

* (todo lo que tiene puntaje hay que hacerlo en base al año anterior, elijan algunas de estas medidas no todas)

* Puntaje de corte de la carrera año anterior (ver como se calcula en paper de Di Prete y Hallsten, como medida de aversion al riesgo, preguntar si hay dudas)
* N de vacantes /N° de postulantes a año (como medida de competitividad), pero esto podría ser medida como puntaje de corte?
* Puntaje de ultimo seleccionado-matriculado
* Puntaje promedio de la carrera – medida de dispersión o de homogeneidad de la carrera

## Año 2016
Solo si es posible incluir:

* Costo de la carrera (arancel)


# Filtros

- Dejar universitarias con ingreso PSU
- Dejar universidades con puntaje PSU matemática y lenguaje > 0


# Datos

- Empleabilidad, Ingresos = buscador_estadísticas_por_carrera_2018_2019


- Año 2016 es el más relevante
# Mi futuro - info carreras
 - % PSU
- mifut18 <- readxl::read_excel(here("data","MiFuturo","buscador_de_carreras_2018.xlsx")) #Bases Mi Futuro 
# Titulados 
  - Información de Mercado Laboral  
  - Salarios
  - Empleabilidad
  - titu1   <- fread(here("data","Titulados","TITULADO_2007_al_2017_web_10072018.csv"))
# Oferta Acaemica 
   -  Arancel, Pje. Corte
   - % PSU por cada carrera
   -  oferta1 <- fread(here("data","OfertaAcademica","OFICIAL_OA_2010_AL_2019_21_01_2019_V1.csv")) 

# Matricula  - info Carreras 
   - % por género
   - Seleccionar agno 2016
- matr1   <- fread(here("data","Matricula","MATRICULA_2007_AL_2018_SIES_28062018.csv"))       

