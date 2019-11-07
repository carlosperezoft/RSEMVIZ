## <img src="images/UdeA_Escudo.jpg" align="right"/>

## Especificación de datos y Estimación del modelo SEM para usar en SEMVIZ

## Datos por defecto en caso de selección de un caso de estudio predefinido

##  Descripción
La aplición SEMVIZ debe utilizar dos SET de datos para el procesamiento de un modelo SEM.

Dichos SET de datos corresponden: uno al conjunto de mediciones recopiladas para las variables
explicativas (_observadas_) y el otro tiene la descripciones de cada una de las variables usadas 
en el modelo SEM (_observadas y latentes_).

<img src="images/semviz-datos-casoe.png" width = "100%", height = "500px" align="center"/>

_Figura 1_: SET de datos a ser usados en el modelo SEM. En caso de ser un caso de estudio se presentan los SETs preestablecidos.

La figura 1 presenta la opción de menú de __casos de estudio__, de allí el sistema presenta el formulario
donde se especifican los casos de estudio disponibles en SEMVIZ. Adicionalmente, se debe activar
la caja de selección _Usar Caso de Estudio seleccionado en SEMVIZ_ con el objetivo que éste sea
tomado como base actual para el análisis dentro de la aplicación.

## Especificar el Modelo SEM para el análisis

<img src="images/semviz-estimar-casoe.png" width = "100%", height = "500px" align="center"/>

_Figura 2_: Opciones de estimación para el modelo SEM actual, para ello se utiliza el paquete R LAVAAN.

Sobre el caso de uso seleccionado se presentan dos secciones (_pestañas_):

- DETALLES: Se presenta de manera general la información contextual del caso de estudio y la definición de cada variable 
usada en el modelo SEM respectivo.

- RESUMEN: Se presenta un resumen tabular de los medias de tendencia central de cada variable asocidada al modelo SEM, 
complemetada por valores de los cuartiles.
