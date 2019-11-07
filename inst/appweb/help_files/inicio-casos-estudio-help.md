## <img src="images/UdeA_Escudo.jpg" align="right"/>

## Inicio de la Aplicación SEMVIZ 

## Selección de un caso de estudio predefinido

##  Descripción
La aplicación SEMVIZ tiene para su iniciación de uso dos casos de estudio donde se ha aplicado
un modelo SEM.

Dichos casos de estudio tienen el modelo SEM definido por medio de ecuaciones tipo LAVAAN, ya
que éste es el paquete de R utilizado para la estimación del modelo. Adicionalmente, se tienen dos
SET de datos; uno que corresponde a las mediciones de las variables obervadas y otro que corresponde
a las etiquetas de cada una de las variables (_observadas y latentes_) utilizadas en el modelo SEM.

<img src="images/semviz-select-casoe.png" width = "100%", height = "500px" align="center"/>

_Figura 1_: Selección de un caso de estudio por defecto para ser analizado en la aplicación SEMVIZ.

La figura 1 presenta la opción de menú de __casos de estudio__, de allí el sistema presenta el formulario
donde se especifican los casos de estudio disponibles en SEMVIZ. Dado el caso, se debe activar
la caja de selección _Usar Caso de Estudio seleccionado en SEMVIZ_ con el objetivo que éste sea
tomado como base actual para el análisis dentro de la aplicación.

## Información sobre el caso de estudio seleccionado
Sobre el caso de estudio seleccionado se presentan dos secciones (_pestañas_):

- DETALLES: Se presenta de manera general la información contextual del caso de estudio y la definición de cada variable 
usada en el modelo SEM respectivo.

- RESUMEN: Se presenta un resumen tabular de los medidas de tendencia central de cada variable asocidada al modelo SEM, 
complemetada por valores de los cuartiles.
