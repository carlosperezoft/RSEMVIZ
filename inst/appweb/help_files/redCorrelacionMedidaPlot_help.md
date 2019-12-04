### Red de Correlaci&oacute;n

##  Descripci&oacute;n

La Red de Correlaci&oacute;n permite realizar un an&aacute;lisis gr&aacute;fico de las relaciones entre las
variables observadas, esto por medio de un grafo cuyos nodos son las variables en cuesti&oacute;n y
los arcos son uniones de correlaci&oacute;n (con ancho y color seg&uacute;n el peso y signo de su coeficiente).

##  Modo de uso del gr&aacute;fico
- **Estilo de Representaci&oacute;n**: Indica la forma gr&aacute;fica de presentaci&oacute;n del grafo. En el caso
    particular de `Spring` permite el agrupamiento de los nodos con mayor correlaci&oacute;n.
- **M&eacute;todo de Optimizaci&oacute;n**: Indica la forma en se optimiza el calc&uacute;lo y la selecci&oacute;n de los coeficientes para las correlaciones de los nodos. **En particular**:
    1. *association*  : Usa una red de Correlaciones normal,
    1. _concentration_: Usa una red de Correlaciones Parciales,
    1. _glasso_       : Usa el operador Graphical LASSO sobre una red de Correlaciones Parciales.

## Referencias
```
Paquete de R utilizado: qgraph version 1.5
[Graph Plotting Methods, Psychometric Data Visualization and Graphical Model Estimation]
```
