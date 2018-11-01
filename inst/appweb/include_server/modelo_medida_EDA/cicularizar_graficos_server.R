# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 31/10/2018 16:36:28 p.m.
#
output$circlePackOneLevelMedidaPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  packing <- circleProgressiveLayout(abs(melt_data$score), sizetype='area')
  circle_data = cbind(melt_data, packing)
  dat.gg <- circleLayoutVertices(packing, npoints=50)
  #
  ggp <- ggplot() +
    # Make the bubbles
    geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)), colour = "black", alpha = 0.6) +
    # Add text in the center of each bubble + control its size
    geom_text(data = circle_data, aes(x, y, size=score, label = variable)) +
    scale_size_continuous(range = c(1,4)) +
    # General theme:
    theme_void() +
    theme(legend.position="none") +
    coord_equal()
  #
  ggplotly(ggp)
  #
})
#
output$circlePackJerarqMedidaPlotOut <- renderCirclepackeR({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  fitModel <- paramsSemFit()
  # rutasModeloSEM: Se deben filrtar los enlaces circulares:
  edgesVis <- rutasModeloSEM(fitModel) %>% filter(from != to)
  # FromDataFrameNetwork crea un objeto data.tree a partir de un data.frame tipo [from, to, value]
  tree_net <- FromDataFrameNetwork(edgesVis, "val")
  # es necesario asignar un valor a size!
  circlepackeR(tree_net, size = "val")
  #
})
#
output$circlePackDendroMedidaPlotOut <- renderCirclepackeR({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
  dendro_data <- as.dendrogram(hc_data)
  tree_data <- as.Node(dendro_data)
  #
  # es necesario asignar un valor a size!
  tree_data$Set(value = 1)
  circlepackeR(tree_data, size = "value")
  #
})
#
output$circlePackSunMedidaPlotOut  <- renderPlot({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  fitModel <- paramsSemFit()
  # rutasModeloSEM: Se deben filrtar los enlaces circulares:
  edgesVis <- rutasModeloSEM(fitModel) %>% filter(from != to)
  #
  # links <- data.frame(source=edgesVis$from, target=edgesVis$to, value=(edgesVis$val))
  # nodes <- data.frame(name=c(as.character(links$source), as.character(links$target)) %>% unique())
  #
  gr <- graph_from_data_frame(edgesVis, vertices = NULL, directed = T)
  #
  ggraph(gr, layout = 'partition') + geom_node_tile(aes(y = -y, fill = depth))
  #
  ##subplot(gr, gr, shareX = TRUE, titleX = TRUE, shareY = TRUE, titleY = TRUE, nrows = 2)
})
