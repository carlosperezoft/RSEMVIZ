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
output$violinMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  ggp <- ggplot(melt_data, aes(x = variable, y = score)) + geom_violin(aes(fill = variable))
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
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
  ggp <- ggplot(melt_data, aes(x = score, group = variable, fill = variable)) + geom_density(alpha=0.55)
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
})
# El grafico histograma es una frecuencia acumulada de los score:
output$histogramaMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # El histograma presenta la frecuencia acumulada de todos los score de las variables seleccionadas,
  # no agrupa por el nombre de la variable como "factor".
  # binwidth = 0.2: indica el ancho de la barra (bin="compartimiento"), al cual recolecta los score que caen alli.
  ggp <- ggplot(melt_data, aes(x = score)) + geom_histogram(aes(binwidth = 0.2, fill = ..count..)) +
                scale_fill_gradient(low="blue", high="orange")
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
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
  ggp <- qplot(x=variable, y=score, data=melt_data, geom=geom_box, fill=variable)
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
})
#
# IMPORTANTE: Para Ridgeline se debe usar la version mas reciente de ggplot2 v 3.0.0
# -- Adicionalmente, plotly/renderSvgPanZoom no tiene actualmente el WRAPPER para este
#    tipo de grafico de "ggplot" por eso usa un "renderPlot" estandar.
output$ridgelineMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  # En "R" se debe usar el operador "+" en la misma linea del item base, y en la siguiente linea lo demas:
  #
  ggplot(melt_data, aes(x = score, y = variable, group = variable, fill = variable)) +
    geom_density_ridges(alpha=0.55, quantile_lines = TRUE, jittered_points = TRUE,
                         position = position_points_jitter(width = 0.05, height = 0),
                         point_shape = '|', point_size = 5, point_alpha = 1) +
    theme_ridges() + theme(legend.position = "none") +
    scale_y_discrete(expand=c(0.01, 0)) +
    scale_x_continuous(expand=c(0.01, 0))
  #
})
#
output$scatterMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  # NOTA: La notacion cast_data[, 1]; toma los valores de todas las filas para la columna 1.
  # -- Se cambia el uso de especificacion de la estica "aes(..)" por "aes_string(..)",
  # -- ya que permite el paso de nombres de las variables (columnas en "cast_data").
  ggp <- ggplot(cast_data,
             aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2], color=colnames(cast_data)[2])) +
             geom_point() + geom_rug(col="steelblue", alpha=0.3, size=1.5) +
             scale_color_gradientn(colours = rainbow(5))
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
})
#
# IMPORTANTE: plotly actualmente no tiene el WRAPPER para ggExtra (ggMarginal).
# --> Por eso usa un "plotOutput" estandar.
output$scatterRegresMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  # IMPORTANTE: Se cambia el uso de especificacion de la estica "aes(..)" por "aes_string(..)",
  # --> ya que permite el paso de nombres de las variables (columnas en "cast_data").
  scatPlot <- ggplot(cast_data,
                    aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2], color=colnames(cast_data)[2])) +
                    geom_point() + geom_rug(col="steelblue", alpha=0.5, size=1.5) +
                    geom_smooth(method=lm , color="red", se=TRUE) +
                    scale_color_gradientn(colours = rainbow(5))
  # Se adicionan elementos al margen del scatter plot:
  ggMarginal(scatPlot, type = input$scatterRegresMedidaType,
                       margins = input$scatterRegresMedidaMargins, color = "green")
})

#
output$splomMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  # ::ggpairs(..)
  # DEFINIR SENTIDO: matriz de duo entre: valores orginales de las OBS,
  #   valores de las cargas (coef betas) de cada factor, valores de los score de cada factor? (la corr no da mucho)
  pm <- GGally::ggpairs(semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes],
            lower = list(continuous = "smooth"),
            mapping = ggplot2::aes(colour=I("cadetblue"))
  ) # FIN GGally
  ggplotly(pm)
})
# IMPORTANTE: tener en cuenat este plot para BURBUJAS !! con alpha y size del punto
# ggplotly(ggplot(cast_data, aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2],
#                                       color=colnames(cast_data)[2], size=colnames(cast_data)[2])) +
#            geom_point(alpha=0.6) + scale_color_gradientn(colours = rainbow(5)))

