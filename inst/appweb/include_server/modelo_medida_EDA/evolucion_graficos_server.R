# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 22/10/2018 16:17:28 p. m.
#
output$sandkeyMedidaPlotOut <- renderSankeyNetwork({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  fitModel <- paramsSemFit()
  nodesVis <- nodosGrafoSEM(fitModel)
  edgesVis <- rutasGrafoSEM(fitModel)
  #
  nodes <- data.frame(name=c(as.character(edgesVis$from), as.character(edgesVis$to)) %>% unique())
  edgesVis$IDsrc <- match(edgesVis$from, nodesVis$label) - 1
  edgesVis$IDtar <- match(edgesVis$to, nodesVis$label) - 1
  #
  sankeyNetwork(Links = edgesVis, Nodes = nodesVis, Source = "IDsrc",
                Target = "IDtar", Value = "value", NodeID = "label",
                fontSize = 12, nodeWidth = 30)
  #
})
#
output$streamgraphPlot <- renderStreamgraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # # key = category column
  year1 <- rep(seq(1990,2016) , each=10)
  name1 <- rep(letters[1:10] , 27)
  value1 <- sample( seq(0,1,0.0001) , length(year))
  data1 <- data.frame(year1, name1, value1)

  data1 %>%
    streamgraph(key="name1", value="value1", date="year1") %>%
    sg_fill_brewer("PuOr")
  # #
  # year1 <- rep(seq(1990,2016) , each=10)
  # name1 <- rep(letters[1:10] , 27)
  # value1 <- sample( seq(0,1,0.0001) , length(year))
  # data1 <- data.frame(year1, name1, value1)
  #
  # # Stream graph with a legend
  # streamgraph::streamgraph(data1, key="name1", value="value1", date="year1" ) %>%
  #   sg_legend(show=TRUE, label="names: ")
})
