## <img src="images/UdeA_Escudo.jpg" align="right"/>

## Especificación de datos y Estimación del modelo SEM para usar en SEMVIZ

#### _Usa datos por defecto en caso de selección de un caso de estudio predefinido_

##  Descripción
> La aplicación SEMVIZ debe utilizar dos SET de datos para el procesamiento de un modelo SEM.

Dichos SET de datos corresponden: 

- Uno al conjunto de mediciones recopiladas para las variables
explicativas (_observadas_) 

- Y el otro tiene las descripciones de cada una de las variables usadas 
en el modelo SEM (_observadas y latentes_).

<img src="images/semviz-datos-casoe.png" width = "90%", height = "500px" align="center"/>

_Figura 1: SET de datos a ser usados en el modelo SEM. En caso de ser un caso de estudio se presentan los SETs preestablecidos._

La figura 1 presenta las opciones de asignación de SET de datos en SEMVIZ, tanto para las Varibles explicativas, como
para las etiquestas del modelo.

- Los datos de las _variables explicativas_ deben tener una columna especial, que es la primera y debe ser nombrada
__row_label__. Los valores de ésta por cada fila son utilizados como _etiquetas_ representativas en los grápficos de análisis
utilizados posteriormente en SEMVIZ. Las demás columnas deben tener por nombre los correspondientes a las variables
usadas en el modelo LAVAAN respectivo.

* Los datos de las _etiquetas del modelo_ corresponden a los valores descriptivos de cada variable usada en el modelo
SEM (_representado con la sintáxis de LAVAAN_). En particular se tienen puntualmente dos columnas: 

 * __variable__: nombre usado para la variable en el modelo SEM (tener en cuenta la sintáxis LAVAAN).
 * __desc__: texto plano que explica de forma breve el significado de la varible a nivel del contexto de negocio o investigativo.

## Especificar el Modelo SEM para el análisis
Debido a que la aplicación SEMVIZ necesita un modelo SEM estimado para el análisis de sus resultados
(_el cual es su objetivo principal_), es necesario realizar la estimación del modelo SEM para el cual
se han especificado los SET de datos indicados anteriormente.

<img src="images/semviz-estimar-casoe.png" width = "90%", height = "500px" align="center"/>

_Figura 2: Opciones de estimación para el modelo SEM actual, para ello se utiliza el paquete R LAVAAN._

La figura 2 presenta el formulario de ingreso del modelo SEM usando la sintáxis LAVAAN (en caso de ser un caso de estudio,
se presenta el respectivo modelo SEM preestablecido); por medio del cual se definene las ecuaciones del modelo de medición (_factores_) y
del modelo estructural (_regresión entre constructos_). Igualmente, allí se debe seleccionar el método de estimación a usar
por medio de LAVAAN para estimar los resultados del modelo (por lo regular se selecciona Máxima Verosimilitud - ML por su
sigla en inglés).

> Finalmente, se procede a __ejecutar__ la estimación por medio del paquete LAVAAN usando el modelo SEM especificado y el
el tipo de estimación indicado. Luego de completar exitosamente la estimación, se presenta en el lado derecho las dos
_secciones_ siguientes:

- __Resumen General__: Se presenta de manera general en texto plano y en formato tabular el resultado principal de la
estimación del modelo SEM usando LAVAAN. La salida presentada corresponde a la forma impresa en que la LAVAAN
genera el reporte luego de estimar un modelo SEM. Adicionalmente, se tiene la opción de indicar que la información
presentada esté en formato _estandarizado_.

- __Puntuaciones (Score)__: Aquí se presentan las puntuaciones (_score_) estimadas tanto para las variables explicativas 
(modelo de medición - factores), como para las variables latentes (modelo estructural - regresión). Estos valores son
las base fundamental para el análisis gráfico junto con los índices de ajsute del modelo SEM.
