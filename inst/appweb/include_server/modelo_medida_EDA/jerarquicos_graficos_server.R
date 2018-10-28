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
output$dendrogramMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  hc_data <- stats::hclust(stats::dist(cast_data, method = "euclidean"), method = "average")
  dendro_data <- as.dendrogram(hc_data)
  #
  dendro_data <- stats::dendrapply(dendro_data, function(x) {
    base::attr(x, 'nodePar') <- list(ruta = sample(LETTERS[1:3], 1))
    base::attr(x, 'edgePar') <- list(ruta = sample(LETTERS[1:3], 1))
    x
  })
  #
  ggp <- ggraph(graph = dendro_data, layout = 'dendrogram', circular = input$dendrogramMedidaCircleCheck)
  #
  if(input$dendrogramMedidaCurvasCheck) {
    ggp <- ggp + geom_edge_diagonal(aes(colour = ruta)) + geom_node_point(aes(filter = leaf))

  } else
    ggp <- ggp + geom_edge_elbow2(aes(colour = ruta)) + geom_node_point(aes(filter = leaf))
  #
  if(input$dendrogramMedidaCircleCheck) {
    ggp <- ggp + coord_fixed()
  }
  return(ggp)
})
#
output$dendroInterMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  hc_data <- stats::hclust(stats::dist(cast_data, method = "euclidean"), method = "average")
  dendro_inter <- as.dendrogram(hc_data)
  #
  k_num <- input$dendroInterMedidaClusters
  k_colors <- rainbow(k_num)
  #
  if(input$dendroInterMedidaTriangCheck) {
    line_type <- "triangle"
    dendro_inter %>% set("branches_k_color", k=k_num) %>%
       set("branches_lwd", c(1.5,1,1.5))   %>%
       set("branches_lty", c(1,1,3,1,1,2)) %>%
       set("labels_colors") %>% set("labels_cex", c(.9,1.2)) -> dendro_inter
  } else {
    line_type <- "rectangle"
    dendro_inter %>% set("labels_col", value = k_colors, k=k_num) %>%
       set("branches_k_color", value = k_colors, k = k_num) %>%
       set("leaves_pch", 19)  %>% set("nodes_cex", 0.7) %>% set("nodes_col", "orange") -> dendro_inter
  }
  #
  if(input$dendroInterMedidaHorizCheck) {
    plot_horiz.dendrogram(dendro_inter, side=F, axes=T, xlab="Altura", type=line_type)
  } else {
    plot(dendro_inter, horiz=input$dendroInterMedidaHorizCheck, axes=T, ylab = "Altura", type=line_type)
    k2 <- dendextend::cutree(dendro_inter, k = k_num)  # Se usa el dendrogram como param... stats:: usa el hclust
    cols2 <- k_colors[k2]
    colored_bars(cbind(cols2), dendro_inter, rowLabels = c(paste(k_num,"Grupos")))
  }
})
#
output$dendroCompaMedidaPlotOut<- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  #
  hc1 <- stats::hclust(stats::dist(cast_data[1], method = "euclidean"), method = "average")
  dendro1 <- as.dendrogram(hc1)
  hc2 <- stats::hclust(stats::dist(cast_data[2], method = "euclidean"), method = "average")
  dendro2 <- as.dendrogram(hc2)
  # Custom these kendo, and place them in a list
  k_num <- input$dendroCompaMedidaClusters
  k_colors <- rainbow(k_num)
  #
  dl <- dendlist(
    dendro1 %>% ladderize %>%
      set("labels_col", value = k_colors, k=k_num) %>%
      set("branches_lty", 1) %>%
      set("branches_k_color", value = k_colors, k = k_num),
    dendro2 %>% ladderize %>%
      set("labels_col", value = k_colors, k=k_num) %>%
      set("branches_lty", 1) %>%
      set("branches_k_color", value = k_colors, k = k_num)
  )

  # Plot los dendrogramas lado a lado, para comparacion:
  tanglegram(dl,
     common_subtrees_color_lines=F, highlight_distinct_edges=T, highlight_branches_lwd=F, center=T,
     margin_inner=2, lwd=1.5, lab.cex=c(1,1.2), edge.lwd=1.5, main = "Agrupamiento", color_lines= c("black"),
     main_left = colnames(cast_data)[1], main_right = colnames(cast_data)[2], sub = "Alturas",
     type = if_else(input$dendroCompaMedidaTriangCheck, "triangle", "rectangle"), faster=T
  )
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
# output$collapsibleTreeMedidaPlotOut <- renderCollapsibleTree({
#   # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
#   req(input$grafoModeloMedicionOut_selectedNodes)
#   #
#   cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
#   #
#   hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
#   hc_data$labels <- seq(1, nrow(cast_data)) # adicionar row_id como "label"
#   dendro_data <- as.dendrogram(hc_data)
#   tree_data <- as.Node(dendro_data)
#   #
#   # NOTA:Funcionan OK para asignar el color u otra operacion con atributos!
#   # tree_data$Do(function(x) x$color <- "red")
#   tree_data$Set(color = "cadetblue", filterFun = isNotLeaf)
#   tree_data$Set(color = "orange", filterFun = isLeaf)
#   #
#   collapsibleTree(tree_data, tooltip = T, fill = "color",
#                   collapsed = !input$collapsibleTreeMedidaExpandirCheck)
#   #
# })
#
# output$radialnetMedidaPlotOut <- renderRadialNetwork({
#   # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
#   req(input$grafoModeloMedicionOut_selectedNodes)
#   #
#   cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
#   #
#   hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
#   hc_data$labels <- seq(1, nrow(cast_data)) # adicionar row_id como "label"
#   #
#   radialNetwork(as.radialNetwork(hc_data), width = NULL, height = NULL, linkColour = "#aaa")
#   #
# })
