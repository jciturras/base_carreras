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

***

The outcome measure investigated is field of study choice’, which was coded following UNESCO´s classification (ISCED, 2013). Because of our large data sample, we use a disaggregate definition of fields of study comprising a 14- category classification including: a) education; b) art and humanities; c) social sciences; d) economics, business and administration; e) law; f) life sciences; g) physics and chemistry (physical sciences); h) mathematics and statistics; i) computing; j) engineering; k) architecture; l) agriculture, veterinary, and environmental science; m) nursing and social work; and n) medicine and dentistry. We merged mathematics/statistics to physical sciences, since these programs are taught by the same university departments in Chile. Consequently, our analyses are conducted with 13 areas of study

Codigo en Stata:

label variable fieldofstudy_ "area de estudio" 

label define fieldofstudy_ 1"Educacion" 2"Humanidades y Artes" 3"Ciencias sociales" 4"Ciencias de la vida" 5"Ingenieria" 6"Agricultura" 7"Salud y trabajo social" 8"Servicios" 9"Medicina" 10"Leyes" 11"Arquitectura" 12 "Administracion y Negocios" 13" Ciencias Computacion" 14"Ciencias físicas" 15"Matematicas"                                                                                                  

recode fieldofstudy_ (14/15=14)
