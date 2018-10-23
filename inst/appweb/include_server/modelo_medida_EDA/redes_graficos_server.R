# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 21/10/2018 17:22:28 p. m.
#
output$corrnetMedidaPlotOut <- renderPlot({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "OBSERVADA",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables OBSERVADAS")
  )
  # Asigna conjunto de datos de VAR obervadas originales:
  cast_data <- datasetInput()
  #
  # INICIO IMPORTANTE:
  # Estas lineas han sido pruebas para tratar de formar GRUPOS de las variables usando
  # analisis de CLUSTER, fuciona correctamente como base.
  # --> El caso es que en "qgraph" los grupos deben ser de igual tamaño y se usan como parametro
  #     adicional. Por ahora no se usan aqui para evitar errores. Pero puede ser util en otros graficos.
  #
  # hc_data <- hclust(dist(cast_data, method = "euclidean"), method = "average")
  # groups_id <- cutree(hc_data, k=3)
  # NOTA: Permite asociar una columan con los ID del cluster de cada dato!
  # cast_data <- cbind(cast_data, groups_id) # en qgraph, se usa por separado!
  # subgrupo1 <- subset(cast_data, groups_id == 1) # obtiene los elementos por ID del grupo, dado el caso!
  # subgrupo2 <- subset(cast_data, groups_id == 2)
  # subgrupo3 <- subset(cast_data, groups_id == 3)
  # grupos_list <- list(g1=rownames(subgrupo1), g2=rownames(subgrupo2), g3=rownames(subgrupo3))
  # grupos_list <- list(g1=which(grepl(1, groups_id)), g2=which(grepl(2, groups_id)), g3=which(grepl(3, groups_id)))
  # overlay = T: aplica para resaltar los grupos, lo cual implica el uso de grupos, de lo contrario falla.
  # FIN NOTA INPORTANTE..
  # ------------------------------------------------------------------------
  # layout: circle, groups, spring
  # graph: default: no aplica coorrelacion extra,
  #        association: correlation network,
  #        concentration: partial correlation network,
  #        glasso: optimal sparse estimate of the partial correlation matrix
  #        ("graph" obliga el uso de "sampleSize")
  #
  if(input$corrnetMedidaGraph == "Ninguno") {
     qgraph(cor(cast_data), layout=input$corrnetMedidaLayout, posCol="darkgreen", negCol="darkred")
  } else {
     qgraph(cor(cast_data), layout=input$corrnetMedidaLayout, posCol="darkgreen", negCol="darkred",
            graph = input$corrnetMedidaGraph, sampleSize = nrow(cast_data))
  }
  #
  # OPCIONAL: Analisis factorial exploratorio:
  # fitModel <- paramsSemFit()
  # latentes_nodes <- latentesModeloSEM(fitModel)
  #
  # Se ha usado el numero de var latentes 3. Lo que implica teoricamente se usan 3 observadas por latente (9 total)
  # qgraph.efa hace un Analysis Fact. Explo  basico de orden 1, usando las cargas factoriales mas altas para agrupar:
  # qgraph.efa(dat = cast_data, factors = nrow(latentes_nodes), corMat = F, rotation = "varimax", layout="spring")
  # FIN OPCIONAL...
  # -----------------------------------------
  # NOTA: El titulo debe AGREGARSE luego de generar el grafico, para que sea visualizado!
  title("Enclaces -> Verde: positivo | Rojo: negativo", line = 1.5)
  #
}, width = 600, height = 600)
#
output$hiveMedidaPlotOut <- renderPlot({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "OBSERVADA",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables OBSERVADAS")
  )
  #
  ggraph(makeHiveArcNet(), layout = 'hive', axis = 'depende', sort.by = 'degree') +
      geom_edge_hive(aes(colour = type)) +  # alpha = ..index..
      geom_axis_hive(aes(colour = depende), size = 3, label = T) +
      coord_fixed()
  #
  #
  # NOTA: intento de usar un DENDROGRAMA como base para el hive, pero no se logra encajar con un solo nodo RAIZ...
  #   ---> Queda util obtener informacion de un Dendrograma por medio de "igraph" o data.tree (as.Node)
  # factData <-  datasetInput()
  # semDendro <- as.dendrogram(hclust(dist(factData)))
  # semTree <- as.Node(semDendro)
  # igraph_base <- den_to_igraph(semDendro)
  # hive_net <- graph_from_data_frame(d=as_data_frame(igraph_base, what="edges"),
  #                                   vertices=as_data_frame(igraph_base, what="vertices"), directed=T)
  #
})
#
output$arcosMedidaPlotOut <- renderPlot({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "OBSERVADA",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables OBSERVADAS")
  )
  #
  ggraph(makeHiveArcNet(), layout = 'linear') + geom_edge_arc(aes(colour = type))
  #
})
#
makeHiveArcNet <- reactive({
  #
  fitModel <- paramsSemFit()
  nodesVis <- nodosGrafoSEM(fitModel)
  edgesVis <- rutasGrafoSEM(fitModel)
  #
  hive_net <- graph_from_data_frame(d=edgesVis, vertices=nodesVis, directed=T)
  #
  V(hive_net)$degree <- degree(hive_net, mode = 'in')
  V(hive_net)$depende <- ifelse(V(hive_net)$degree < 2, 'poco',
                                ifelse(V(hive_net)$degree >= 4, 'mucho', 'medio'))
  return(hive_net)
})
