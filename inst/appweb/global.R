# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# Inclusion de la librerias propias para la ejecucion de la aplicacion
# Shiny WEB semviz:
#
suppressPackageStartupMessages({
  library(markdown, quietly=TRUE)
  library(shinydashboard, quietly=TRUE)
  library(shinydashboardPlus, quietly=TRUE)
  library(shinyjs, quietly=TRUE)
  library(shinycssloaders, quietly=TRUE)
  library(shinyhelper, quietly=TRUE)
  library(DT, quietly=TRUE)
  library(dplyr, quietly=TRUE)
  library(htmlwidgets, quietly=TRUE)
  library(shinyWidgets, quietly = TRUE)
  library(jsonlite, quietly=TRUE)
  library(RColorBrewer, quietly=TRUE)
  library(dygraphs, quietly=TRUE)
  library(streamgraph, quietly=TRUE)
  library(qgraph, quietly=TRUE)
  library(psych, quietly=TRUE)
  library(ggplot2, quietly=TRUE)
  library(plotly, quietly=TRUE)
  library(forecast, quietly=TRUE)
  library(lavaan, quietly=TRUE)
  library(visNetwork, quietly=TRUE)
  library(formattable, quietly=TRUE)
  library(rAmCharts, quietly=TRUE)
})

# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:18:51 p. m.
#
## Cargar las funciones propias del paquete semviz ubicadas en /R dir base:
#
for (file in list.files(system.file("R", package = "semviz"), pattern = "\\.(r|R)$", full.names = TRUE)) {
  source(file, local = TRUE)
}
#
# Se especifica el numero de digitos por defecto al visualizar datos numericos
# NOTA: El valor de 4 conserva el estandar de lavaan en los datos numericos.
options(digits=4)
#
