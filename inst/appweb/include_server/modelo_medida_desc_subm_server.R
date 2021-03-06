# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/10/2018 17:36:28 a. m.
#
output$grafoModeloMedicionOut <- renderVisNetwork({
  getGrafoModelSEMBase()
})
#
observeEvent(input$selectedNodesModMedicionBtn, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  visNetworkProxy("grafoModeloMedicionOut") %>% visGetSelectedNodes() # actualiza contenedores...
})
#
output$medicionSelectedNodesTxtOut <- renderUI({
  req(input$grafoModeloMedicionOut_selectedNodes) # verifica que tenga informacion...
  #
  nodesListTxt <- paste(input$grafoModeloMedicionOut_selectedNodes, collapse = ",")
  # NOTA: La info para HTML(..) debe ser resultado de un paste(..):
  HTML(paste(tags$b("Variables SEM:"), nodesListTxt))
})
#
output$convenModelMedicionTablaOut <- renderFormattable({
   varFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
   descFormat <- formatter("span", style = style(color = "blue", font.weight = "bold"))
   nodesLabels <- datasetLabelsInput()
   #
   #  Multiples condiciones en el filtro equivalen a un AND,
   #  por tanto se debe usar el operador: & (and) u | (or).
   #  NOTA: Se filtra por 'grafoModeloMedicionOut_selectedNodes' ya que contiene la lista de
   #  los nombres de los nodos seleccionados.
   selected_labels <- nodesLabels %>%
                      filter(variable %in% input$grafoModeloMedicionOut_selectedNodes) %>% arrange(variable)
   #
   formattable(selected_labels, list(variable = varFormat, desc = descFormat))
})
#
observeEvent(input$convenModelMedicionSwitch, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  shinyjs::toggle(id = "convenModelMedicionDIV", anim = TRUE, animType = "slide")
})
#
# NOTA: FUNCION USADA DE PRUEBA PARA FILTRAR EN GRAFICOS CON SE PUEDA APLICAR ELEMENTOS AGRUPADOS POR LATENTE/OBSERVADA
# output$splomFactorOut <- renderPlotly({
#   # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
#   req(input$grafoModeloMedicionOut_selectedBy)
#   param_nodes <- nodosModeloSEM(paramsSemFit())
#   if("LATENTE" == input$grafoModeloMedicionOut_selectedBy) {
#     nodes_selected <- param_nodes %>% filter(latent == TRUE) %>% select("node_name")
#     pm <- GGally::ggduo(semModelScoreData()[nodes_selected$node_name])
#   } else {
#     nodes_selected <- param_nodes %>% filter(latent == FALSE) %>% select("node_name")
#     pm <- GGally::ggduo(semModelScoreData()[nodes_selected$node_name])
#   }
#   # ::ggpairs(..)
#   # DEFINIR SENTIDO: matriz de duo entre: valores orginales de las OBS,
#   #   valores de las cargas (coef betas) de cada factor, valores de los score de cada factor? (la corr no da mucho)
#   ggplotly(pm)
#})
#
# Presentacion de menu grafico de forma dinamica, segun la pregunta de analisis seleccionada:
source('include_server/modelo_medida_EDA/menu-dinamico-graficos.R', local=TRUE)
#
# Graficos para el menu de Distribucion en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/distribucion_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Correlacion en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/correlacion_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Barras en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/barras_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Jerarquicos en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/jerarquicos_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Redes en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/redes_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Evolucion en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/evolucion_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Cicularizar en el Modelo de Medicion:
source('include_server/modelo_medida_EDA/circularizar_graficos_server.R', local=TRUE)
#
