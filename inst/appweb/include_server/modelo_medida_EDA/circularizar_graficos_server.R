# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 31/10/2018 16:36:28 p.m.
#
output$circlePackOneLevelMedidaPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  if(!existenColumnas(semModelScoreData(), input$grafoModeloMedicionOut_selectedNodes)) {
    return(NULL)
  }
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
  # rutasModeloSEM: Se deben filtrar los enlaces circulares:
  #
  edgesVis <- rutasModeloSEM(fitModel) %>% filter(from != to, type == "regression")
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
  if(!existenColumnas(semModelScoreData(), input$grafoModeloMedicionOut_selectedNodes)) {
    return(NULL)
  }
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
output$circlePackSunMedidaPlotOut <- renderPlot({
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
  edgesVis <- rutasModeloSEM(fitModel) %>% filter(from != to, type == "regression")
  print(edgesVis)
  #
  links <- data.frame(target=edgesVis$to, source=edgesVis$from, value=(edgesVis$val))
  # nodes <- data.frame(name=c(as.character(links$source), as.character(links$target)) %>% unique())
  # NOTA:
  # "vertices" es un data.frame con meta datos de los nodos (name, etc), o NULL para que la funcion
  # calcule los nodos a partir de la primera columna de "links". Usamos aqui "target" con la columna
  # de "to" ya que en "lavaan" es la que proporciona el nombre de los nodos que se involucran en todos
  # los "links".
  gr <- graph_from_data_frame(links, vertices = NULL, directed = T)
  #
  gg1 <- ggraph(gr, layout = 'partition') + geom_node_tile(aes(y = -y, fill = depth))
  gg2 <- ggraph(gr, layout = 'partition', circular = TRUE) +
               geom_node_arc_bar(aes(fill = depth)) + coord_fixed()
  #
  gg3 <- ggraph(gr, layout = 'partition', circular = TRUE) +
    geom_edge_diagonal(aes(width = ..index.., alpha = ..index..), lineend = 'round') +
    scale_edge_width(range = c(0.2, 1.5)) +
    geom_node_point(aes(colour = depth)) +
    coord_fixed()
  #
  gg4 <- ggraph(gr, 'dendrogram') + geom_edge_diagonal()
  # Se crea un panel de 4 graficos en dos filas, util en analisis comparativo:
  grid.arrange(gg1, gg2, gg3, gg4, nrow = 2) # funcion de gridExtra (ggplot2)
  #
})
#
output$chordCoefiMedidaPlotOut <- renderPlot({
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
  # "directional" = 1, indica que la direccion del arco es de las filas hacia las columnas (desde "from" hacia "to")
  # "directional" = -1, indica que la direccion del arco es de las columnas hacia las filas (desde "to" hacia "from")
  circos.clear()
  circlize::chordDiagram(edgesVis, directional = -1, direction.type = "arrows", link.arr.type = "big.arrow")
         # direction.type = c("diffHeight", "arrows"), # presenta un espacio en el eje de la fuente
         # link.arr.type = "big.arrow", link.arr.length = 0.2) #  sin "big.arrow", se muestra una "flecha"
  #
})
#
output$chordCorrMedidaPlotOut <- renderPlot({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  fitModel <- paramsSemFit()
  # Matriz de correlacion para las variables latentes y observadas
  corMat <- lavInspect(semFitLocal(), "cor.all")
  #
  circos.clear()
  col_fun = colorRamp2(c(-1, 0, 1), c("red", "white", "green"))
  circlize::chordDiagram(corMat, symmetric = TRUE, col = col_fun)
  #
})
#
