## <img src="images/UdeA_Escudo.jpg" align="right"/>

## Políticas Democráticas 

## Estudio relacionado con Industrialización y Políticas Democráticas

##  Descripción

El caso de estudio corresponde a un estudio de fenomenos de Industrializción y de Políticas Democráticas en países
en vía de desarrollo durante los períodos de 1960 y 1965. Este estudio fue realizado y documentado por Kenneth A. Bollen en 1989
en su libro __Structural Equations with Latent Variables__.

El enfoque principal del estudio consiste en validar cómo la industrialización y las políticas democráticas en 1960 
influyen a mediano plazo en los logros de políticas democráticas en los respectivos países cinco años después (1965).

<img src="images/Poli-Demo-SEM-lavaan.png" width = "600px", height = "500px" align="center"/>

_Figura 1_: Modelo SEM que especifica las relaciones entre variables observadas y los constructos de este caso de estudio.

## Definición de las variables de medición

Se tiene un SET de Datos (R data frame) de 75 observaciones (países en vía de desarrollo) con un 
conjunto de 11 variables. Dichas variables se definen a continuación:

### Variables observadas (explicativas)

## y1
Calificaciones de expertos sobre la libertad de prensa en 1960

## y2
La libertad de oposición política en 1960

## y3
La equidad de las elecciones en 1960

## y4
La efectividad de la legislatura elegida en 1960

## y5
Calificaciones de expertos sobre la libertad de prensa en 1965

## y6
La libertad de oposición política en 1965

## y7
La equidad de las elecciones en 1965

## y8
La efectividad de la legislatura elegida en 1965

## x1
El producto nacional bruto (PNB) per cápita en 1960

## x2
El consumo inanimado de energía per cápita en 1960

## x3
El porcentaje de la fuerza laboral en la industria en 1960

### Constructos (variables latentes)

## dem60
Variable Latente: Indicadores y1 - y4 de la política democrática en 1960

## dem65
Variable Latente: Indicadores y5 - y8 de la política democrática en 1965

## ind60
Variable Latente: Indicadores x1 - x3 de la industrialización en 1960

### Fuente
La información dispobible de este caso de estudio fue tomada del paqute R LAVAAN, que lo utiliza como un caso
de ejemplo para sus diferentes análisis.

### Referencias

Bollen, K. A. (1989). Structural Equations with Latent Variables. Wiley Series in Probability and Mathematical Statistics. New York: Wiley.

Bollen, K. A. (1979). Political democracy and the timing of development. American Sociological Review, 44, 572-587.

Bollen, K. A. (1980). Issues in the comparative measurement of political democracy. American Sociological Review, 45, 370-390.
