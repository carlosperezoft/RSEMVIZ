## <img src="images/UdeA_Escudo.jpg" align="right"/>

## Validación del modelo SEM estimado y posterior interpretación de los resultados 

#### _Se tiene un conjunto de gráficos para el análisis del modelo de medición y del modelo estructural_

## Descripción
> La aplición SEMVIZ permite el análisis de los resultados de un modelo SEM luego de su estimación
por medio de un amplio conjunto de gráficos interactivos.

Dichos gráficos interactivos permiten fundamentalmente la validación de resultados a nivel de:
- Índices de bondad de ajuste (_Absoluto, Incremental y Parsimonioso_)
- Análisis de pruebas de Hipótesis
- Modelo de Medición (_Variables Observadas_-Factores)
- Modelo Estructural (_Variables Latentes_-Regresión)

Las opciones de menú disponibles en SEMVIZ para el análisis (evaluación) e interpretación se presentan a continuación:

## Análisis de Bondad de Ajuste
Está sección presenta en un formato tipo __dashboard__ la posibilidad de evaluar rápidamente el ajuste
del modelo SEM en cuestión y establecer sí es valido realizar análisis de interpretación confiables en las
siguientes secciones.

<img src="images/semviz-resultados-casoe.png" width = "80%", height = "400px" align="center"/>

_Figura 1: Se presenta el dashboard de Bondad de Ajuste del modelo SEM. Adicionalmente, las demás opciones de análisis en SEMVIZ._

La figura 1 resalta las opciones disponibles en SEMVIZ para el análisis de resultados del modelo SEM luego de su estimación.
En particular, se presenta el dashboard de la bondad de ajuste con los elementos tipo _INFO BOX_, que de forma directa
presentan en verde, naranja o rojo los niveles de aceptación para cada uno de los índices de ajuste del modelo. Adicionalmente,
se presenta el valor directo o como porcentaje de cada índice y con elementos explicativos de la forma en que se evaluan.

Los índices son agrupados por su tipo como:
- Ajuste absoluto
- Ajuste Incremental
- Ajuste Parsimonioso

## Análisis de Hipótesis [Pruebas]
Esta sección permite al analista validar las pruebas de hipótesis que se hayan planteado con respecto a los
factores del modelo de medición y con respecto a las variables latentes (constructos) del modelo estructural (regresión).

<img src="images/semviz-hipotesis-casoe.png" width = "80%", height = "400px" align="center"/>

_Figura 2: Se presenta la visualización de coeficientes estimados para el modelo SEM procesado en SEMVIZ._

La figura 2 presenta el módulo de SEMVIZ para facilitar el anáisis de _pruebas de hipótesis_, se usa el 
grafo dirigido del modelo SEM (_Graphical Analysis Driven SEM_) como driver para las selección de elementos
que luego son procesados de forma tabular, donde se presenta información apropidada para validar planteamientos
de prueba de hipótesis como lo son: estimación de coeficiente normal, coeficiente estandarizado, intevalo
de confianza, valor-p (significancia), y el R-Cuadrado.

## Análisis SEM Medición [Factores]
Esta sección permite al analista realizar la interpretación de resultados del modelo SEM estimado, esto a nivel de factores
y variables observadas (*modelo de medición*). Igualmente, se tienen opciones de análisis para las relaciones entre contructos
por medio de sus __score__ estimados usando algunos gráficos especializados para dichos casos.

<img src="images/semviz-mod-medicion-casoe.png" width = "80%", height = "400px" align="center"/>

_Figura 3: Sección de análisis para el modelo de medición, usando el modelo SEM como driver gráfico para una visualización tipo SANKEY._

El análisis del módelo de medición se logra por medio de la selección de uno o varios elementos en el 
grafo dirigido del modelo SEM (_Graphical Analysis Driven SEM_), de allí seleccionando una pregunta agrupadora
(*preguntas de análisis*) para el proceso de **representación visual**, de allí se tiene acceso a los siguientes 
conjuntos de gráficos según sea la pregunta contextual seleccionada:

1. **Distribución** [boxplot, densidad 2D, histograma, ridge-line, violín]
2. **Correlación** [burbujas, contorno 2D, correlograma, dispersión-regresión, dispersión-scatter, heatmap, splom-matriz]
3. **Barras** [barras-circular, barras, coordenadas paralelas, lollipop]
4. **Jerárquicos** [cluster-comparativo, dendrograma-básico, dendrograma-comparativo, dendrogrma-interactivo, treemap]
5. **Redes** [red-arcos, red-correlaciones, red-hive]
6. **Evolución** [flujo-serie-área-apilada, flujo-series-score, flujos-sankey, flujo-streamgraph-score, flujo-tipo-señal]
7. **Circularizar** [circular-packing, circular-packing-jerárquico, dendrograma-circularizado, flujo-circular-cuerdas, sunburst-comparativo]

Luego SEMVIZ presenta el gráfico interactivo respectivo, permitiendo al analista de negocio o investigador
variar la forma de presentación del gráfico por medio del ajuste dinámico de la propiedades del mismo.

## Análisis SEM Estructural [Regresión]
Esta sección permite al analista realizar la interpretación de resultados del modelo SEM estimado, esto a nivel de variables
latentes (*constructo del modelo estructural*). Igualmente, se tienen opciones de análisis para las relaciones entre variables
observadas y contructos por medio de sus __score__ estimados algunos gráficos especializados para dichos casos.

<img src="images/semviz-mod-estructural-casoe.png" width = "80%", height = "400px" align="center"/>

_Figura 4: Sección de análisis para el modelo estructural, usando el modelo SEM como driver gráfico para una visualización tipo Series._

El análisis del módelo estructural se logra por medio de la selección de uno o varios elementos en el 
grafo dirigido del modelo SEM (_Graphical Analysis Driven SEM_), de allí seleccionando una pregunta agrupadora
(*preguntas de análisis*) para el proceso de **representación visual**, de allí se tiene acceso a los siguientes 
conjuntos de gráficos según sea la pregunta contextual seleccionada:

1. **Estimación** [Dendisdad 2D]
2. **Predicción** [Predicción Lantentes]
3. **Mediación** [Mediación-Regresión Latentes]

Luego SEMVIZ presenta el gráfico interactivo respectivo, permitiendo al analista de negocio o investigador
variar la forma de presentación del gráfico por medio del ajuste dinámico de la propiedades del mismo.
