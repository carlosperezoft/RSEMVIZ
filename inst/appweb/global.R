# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# Inclusion de la librerias propias para la ejecucion de la aplicacion
# Shiny WEB semviz:
#
library(markdown)
library(shinydashboard)
library(shinycssloaders)
library(shinyhelper)
library(DT)
library(dplyr)
library(htmlwidgets)
library(jsonlite)
library(RColorBrewer)
library(dygraphs)
library(streamgraph)
library(qgraph)
library(psych)
library(plotly)
library(forecast)
library(lavaan)

# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:18:51 p. m.
#
## Cargar las funciones propias del paquete semviz ubicadas en /R dir base:
#
for (file in list.files(system.file("R", package = "semviz"), pattern = "\\.(r|R)$", full.names = TRUE)) {
  source(file, local = TRUE)
}
