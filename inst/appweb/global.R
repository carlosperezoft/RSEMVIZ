# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# Inclusion de la librerias propias para la ejecucion de la aplicacion
# Shiny WEB semviz:
#
# Se inicializa esta variable de entorno en R-Studio para que permita un tope maximo
# de DLLs (WINDOWS) cargadas por Session LOCAL de R:
Sys.setenv(R_MAX_NUM_DLLS = 512)
#
suppressPackageStartupMessages({
  library(markdown, quietly=TRUE)
  library(shinydashboard, quietly=TRUE)
  library(shinydashboardPlus, quietly=TRUE)
  # NOTA: flexdashboard define un valueBox, no debe usarse explicitamente. Pues causa un conflicto con el valueBox
  #       del shinydashboard. Actualmente funciona en ambos casos pues se usa la invocacion cualificada:
  #       shinydashboard::valueBox(..)
  #library(flexdashboard, quietly=TRUE)
  library(shinyjs, quietly=TRUE)
  library(shinyBS, quietly=TRUE)
  library(shinycssloaders, quietly=TRUE)
  library(shinyhelper, quietly=TRUE)
  #library(shinyjqui, quietly=TRUE)
  library(DT, quietly=TRUE)
  library(dplyr, quietly=TRUE)
  library(parcoords, quietly=TRUE)
  library(htmlwidgets, quietly=TRUE)
  library(shinyWidgets, quietly = TRUE)
  library(jsonlite, quietly=TRUE)
  library(RColorBrewer, quietly=TRUE)
  library(dygraphs, quietly=TRUE)
  library(streamgraph, quietly=TRUE)
  library(qgraph, quietly=TRUE)
  #library(psych, quietly=TRUE)
  library(ggplot2, quietly=TRUE)
  library(plotly, quietly=TRUE)
  #library(forecast, quietly=TRUE)
  library(lavaan, quietly=TRUE)
  library(visNetwork, quietly=TRUE)
  library(formattable, quietly=TRUE)
  library(rAmCharts, quietly=TRUE)
  library(corrplot, quietly = TRUE)
  library(heatmaply, quietly=TRUE)
  library(GGally, quietly=TRUE)
  library(reshape2, quietly=TRUE)
  library(ggridges, quietly=TRUE)
  library(ggExtra, quietly=TRUE)
  library(circlize, quietly=TRUE)
  library(ggraph, quietly=TRUE)
  library(igraph, quietly=TRUE)
  library(data.tree, quietly=TRUE)
  library(ggTimeSeries, quietly=TRUE)
  #library(dygraphs, quietly=TRUE)
  library(dendextend, quietly=TRUE)
  library(packcircles, quietly=TRUE)
  library(circlepackeR, quietly=TRUE)
  library(gridExtra, quietly=TRUE)
  # Se desactivan por incompatibilidad con D3.js
  #library(networkD3, quietly=TRUE)
  #library(collapsibleTree, quietly=TRUE) # usa D3.js
  # Se desactivan por NO uso actualmente...
  # library(svgPanZoom, quietly=TRUE)
  # library(svglite, quietly=TRUE)
})
#
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
# Se establece el tema de fondo por defecto para los graficos con ggplot:
theme_set(theme_bw())  # tema black_white !
#
# se invoca esta opcion de devtools para que se inicialice correctamente los DATOS del paquete:
#  devtools::load_all(".")
#
semviz_data_path <- "C:\\PEREZOFT_MAESTRIA\\4_SEMESTRE_2018_2\\1_RSEMVIZ_DLLO\\semviz\\data\\"
load(paste0(semviz_data_path,"poli_dem_data.rda"))
load(paste0(semviz_data_path,"poli_dem_labels.rda"))
load(paste0(semviz_data_path,"political_democracy_model.rda"))
load(paste0(semviz_data_path,"DATOS_GRUPOS_INVEST_UdeA.rda"))
load(paste0(semviz_data_path,"GRUPOS_UdeA_VAR_Labels.rda"))
load(paste0(semviz_data_path,"grupos_invest_udea_model.rda"))
#
