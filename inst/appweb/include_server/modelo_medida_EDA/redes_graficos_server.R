# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 21/10/2018 17:22:28 p. m.
#
output$corrnetMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes] # datasetInput()
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
  #
  # layout: circle, groups, spring
  # graph: default: no aplica coorelacion extra,
  #       association: correlation network, concentration:  partial correlation network,
  #       glasso:  optimal sparse estimate of the partial correlation matrix
  #       ("graph" obliga el uso de "sampleSize")
  # overlay: aplica para resaltar los grupos, lo cual implica el uso de grupos, de lo contrario falla.
  # qgraph(cov(cast_data), layout="circle", graph = "glasso", sampleSize = nrow(cast_data))
  #
  qgraph(cor(cast_data), layout="circle", posCol="darkgreen", negCol="darkred")
  # fitModel <- paramsSemFit()
  # latentes_nodes <- latentesModeloSEM(fitModel)
  # qgraph.efa(dat = datasetInput(), factors = nrow(latentes_nodes), groups = grupos_list,
  #            corMat = F, rotation = "varimax", layout="spring")
  #
  #
  # NOTA: El titulo debe AGREGARSE luego de generar el grafico, para que sea visualizado!
  title("Enclaces--> Verde: positivo | Rojo: negativo", line = 1.5)
  #
}, width = 600, height = 600)
#
