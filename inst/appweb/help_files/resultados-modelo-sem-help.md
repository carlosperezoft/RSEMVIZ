## <img src="images/UdeA_Escudo.jpg" align="right"/>

## Validación del modelo SEM estimado y posterior interpretación de los resultados 

## Se tiene disponible un conjunto de gráficos para el análisis del modelo de medición y del estructural

##  Descripción
La aplición SEMVIZ tiene para su iniciación de uso dos casos de estudio donde se ha aplicado
un modelo SEM.

Dichos casos de estudio tienen el modelo SEM definido por medio de ecuaciones tipo LAVAAN, ya
que este es el paquete de R utilizado para la estimación del modelo. Adicionalmente se tienen dos
SET de datos; uno que corresponde a las mediciones de las variables obervadas y otro que correponde
a la etiquetas de cada una de las variables (_observadas y latentes_) utilizadas en el modelo SEM.

<img src="images/semviz-resultados-casoe.png" width = "100%", height = "500px" align="center"/>

_Figura 1_: Se presenta el dashboard de bondad de ajustes del modelo SEM. Adicionalmente, las demás opciones de análisis en SEMVIZ.

La figura 1 presenta la opción de menú de __casos de estudio__, de allí el sistema presenta el formulario
donde se especifican los casos de estudio disponibles en SEMVIZ. Adicionalmente, se debe activar
la caja de selección _Usar Caso de Estudio seleccionado en SEMVIZ_ con el objetivo que éste sea
tomado como base actual para el análisis dentro de la aplicación.

## Información sobre el caso de estudio seleccionado
Sobre el caso de uso seleccionado se presentan dos secciones (_pestañas_):

- DETALLES: Se presenta de manera general la información contextual del caso de estudio y la definición de cada variable 
usada en el modelo SEM respectivo.

- RESUMEN: Se presenta un resumen tabular de los medias de tendencia central de cada variable asocidada al modelo SEM, 
complemetada por valores de los cuartiles.
