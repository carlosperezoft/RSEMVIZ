# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 20/10/2018 18:36:28 p. m.
#
output$treemapMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  dendro_data <- as.dendrogram(hclust(dist(cast_data, method = "euclidean"), method = "average"))
  dendro_igraph <- den_to_igraph(dendro_data)
  #
  ggraph(graph = dendro_igraph, layout = 'treemap') +
         geom_node_tile(aes(fill = depth), size = 0.25) +
         scale_fill_distiller(palette="Spectral", direction=-1)
  #
})
#
output$dendrogramMedidaPlotOut <- renderDendroNetwork({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
  hc_data$labels <- seq(1, nrow(cast_data)) # adicionar row_id como "label"
  #
  dendroNetwork(hc_data, width = NULL, height = NULL, zoom = T, # <-- activa uso de "zoom" y "panoramica"
                treeOrientation = if_else(input$dendrogramMedidaHorizCheck == T, "horizontal", "vertical"),
                linkType = if_else(input$dendrogramMedidaCurvasCheck == T, "diagonal", "elbow")
                )
  #
})
#
output$radialnetMedidaPlotOut <- renderRadialNetwork({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
  hc_data$labels <- seq(1, nrow(cast_data)) # adicionar row_id como "label"
  #
  radialNetwork(as.radialNetwork(hc_data), width = NULL, height = NULL, linkColour = "#aaa")
  #
})
#
output$clusterMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  #
  kmeans_data <- kmeans(cast_data, centers = 3)
  cast_data$cluster <- factor(kmeans_data$cluster)
  centers <- as.data.frame(kmeans_data$centers)
  colnames(centers) <- c("V1", "V2")
  #
  ggp <- ggplot(data=cast_data, aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2], color="cluster")) +
      geom_point() +
      geom_point(data=centers, aes(x=V1, y=V2, color="center"), show.legend = FALSE) +
      geom_point(data=centers, aes(x=V1, y=V2, color="center"), size=52, alpha=.3, show.legend = FALSE)
  #
  ggplotly(ggp)
})
#
output$collapsibleTreeMedidaPlotOut <- renderCollapsibleTree({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
  hc_data$labels <- seq(1, nrow(cast_data)) # adicionar row_id como "label"
  dendro_data <- as.dendrogram(hc_data)
  tree_data <- as.Node(dendro_data)
  #
  # NOTA:Funcionan OK para asignar el color u otra operacion con atributos!
  # tree_data$Do(function(x) x$color <- "red")
  tree_data$Set(color = "cadetblue", filterFun = isNotLeaf)
  tree_data$Set(color = "orange", filterFun = isLeaf)
  #
  collapsibleTree(tree_data, tooltip = T, fill = "color",
                  collapsed = !input$collapsibleTreeMedidaExpandirCheck)
  #
})
#
