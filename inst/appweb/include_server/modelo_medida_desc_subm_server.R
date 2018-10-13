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
output$nodeSelectedTxtOut <- renderUI({
  req(input$grafoModeloMedicionOut_selectedNodes) # verifica que tenga informacion...
  #
  nodesListTxt <- paste(input$grafoModeloMedicionOut_selectedNodes, collapse = ",")
  # NOTA: La info para HTML(..) debe ser resultado de un paste(..):
  HTML(paste(tags$b("Modelo SEM[nodos seleccionados]:"), nodesListTxt))
})
#
output$splomPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  # ::ggpairs(..)
  # DEFINIR SENTIDO: matriz de duo entre: valores orginales de las OBS,
  #   valores de las cargas (coef betas) de cada factor, valores de los score de cada factor? (la corr no da mucho)
  pm <- GGally::ggduo(semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes])
  ggplotly(pm)
})
#
# NOTA: FUNCION USADA DE PRUEBA PARA FILTRAR EN GRAFICOS CON DE PUEDA APLICAR ELEMENTOS AGRUPADOS POR LATENTE/OBSERVADA
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
output$violinMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  ggplotly(ggplot(melt_data, aes(x = variable, y = score)) + geom_violin(aes(fill = variable)))
})
# El grafico de densidad, es como un histograma (frecuencia acumnulada de los score) "suavizado":
output$densidad2DMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # alpha: 0.2 (colores claros) / 0.55 (colores intermedios),
  # es el parametro para el nivel de transparencia de las densidades presentadas:
  ggplotly(ggplot(melt_data, aes(x = score, group = variable, fill = variable)) + geom_density(alpha=0.55))
})
# El grafico histograma es una frecuencia acumnulada de los score:
output$histogramaMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # El histograma presenta la frecuencia acumulada de todos los score de las variables seleccionadas,
  # no agrupa por el nombre de la variable como "factor".
  # binwidth = 0.2: indica el ancho de la barra (bin="compartimiento"), al cual recolecta los score que caen alli.
  ggplotly(ggplot(melt_data, aes(x = score)) + geom_histogram(aes(binwidth = 0.2, fill = ..count..)))
})
#
output$boxplotMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # ggplot(melt_data, aes(x=variable, y=score, fill=variable)) + geom_boxplot(alpha=0.3) # ok !
  # qplot( x=variable , y=score , data=melt_data , geom=c("boxplot","jitter") , fill=variable, alpha=0.45) # ok !
  # NOTA: alpha: 0.3 (colores claros) / 0.45 (colores intermedios).
  geom_box = c("boxplot")
  if(input$boxplotMedidaJitterCheck == TRUE) {
    geom_box = c("boxplot","jitter")
  }
  ggplotly(qplot(x=variable, y=score, data=melt_data, geom=geom_box, fill=variable))
})
#
# IMPORTANTE: Se debe usar la version mas reciente de ggplot2 v 3.0.0
# -- Adicionalmente, plotly no tiene actualmente el WRAPPER para este tipo de grafico
#    por eso usa un "plotOut" estandar.
output$ridgelineMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # En "R" se debe usar el operador "+" en la misma linea del item base, y en la siguiente linea lo demas:
  #
  ggplot(melt_data, aes(x = score, y = variable, group = variable, fill = variable)) +
    geom_density_ridges(alpha=0.55, quantile_lines = TRUE, jittered_points = TRUE,
                         position = position_points_jitter(width = 0.05, height = 0),
                         point_shape = '|', point_size = 5, point_alpha = 1) +
    theme_ridges() + theme(legend.position = "none") +
    scale_y_discrete(expand=c(0.01, 0)) +
    scale_x_continuous(expand=c(0.01, 0))
})
