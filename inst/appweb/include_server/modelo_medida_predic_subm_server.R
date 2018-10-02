# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 12/09/2018 10:47:28 a. m.
gruposInvestData <- DATOS_GRUPOS_INVEST_UdeA[,5:31]
gruposLatenteData <- GRUPOS_VAR_LATENTES_UdeA

constructosList <- split(gruposLatenteData$id_var, gruposLatenteData$latente)
#
# NOTA: Es necesario especificar un ancho y un alto para el Plot,
# ya sea en la UI o en el server. Aqui se ha sado 500 en ambos.
output$personBig5Plot <- renderPlot({
  qG <- qgraph(cor(gruposInvestData), minimum = 0.25, cut = 0.4, vsize = 1.5, layout = "circular",
               groups = constructosList, legend = TRUE, borders = FALSE)
  title("Grupos de Investigaci\u00F3n U. de A.[Correlaci\u00F3n - ESTRELLA]", line = 2.5)

}, width = 800, height = 600)

# NOTA: Es necesario especificar un ancho y un alto para el Plot,
# ya sea en la UI o en el server. Aqui se especificado desde la UI.
output$personClusterPlot <- renderPlot({
  Q <- qgraph(cor(gruposInvestData), minimum = 0.25, cut = 0.4, vsize = 1.5, DoNotPlot = TRUE,
              groups = constructosList, legend = TRUE, borders = FALSE)

  # Layout Spring es tipo nube-cluster
  Q <- qgraph(Q, layout = "spring", overlay = TRUE, DoNotPlot = FALSE,
              posCol = "green", negCol = "red")
  title("Grupos de Investigaci\u00F3n U. de A. - CLUSTER", line = 2.5)
})

output$personPSICOPlot <- renderPlot({

  cor_bfi <- cor_auto(gruposInvestData)
  graph_glas <- qgraph(cor_bfi, graph = "glasso", sampleSize = nrow(bfi),
                       layout = "spring", legend.cex =0.6, groups = constructosList) # ok: util con grupos

  # NOTA: El titulo debe AGREGARSE luego de generar el grafico, para que sea visualizado!
  title("Grupos de Investigaci\u00F3n U. de A. (GLASSO)", line = 2.5)
  #
}, width = 500, height = 500)

output$personPSICOFactorPlot <- renderPlot({

  cor_bfi <- cor_auto(gruposInvestData)
  graph_factor <- qgraph(cor_bfi, graph = "concentration", sampleSize = nrow(bfi),
                         layout = "spring", legend.cex =0.6, groups = constructosList) # ok: util con grupos

  # NOTA: El titulo debe AGREGARSE luego de generar el grafico, para que sea visualizado!
  title("Grupos de Investigaci\u00F3n U. de A. (Concentration)", line = 2.5)
  #
}, width = 500, height = 500)

output$personPSICOCentraPlot <- renderPlot({

  cor_bfi <- cor_auto(gruposInvestData)
  graph_glas <- qgraph(cor_bfi, graph = "glasso", sampleSize = nrow(bfi),
                       groups = constructosList, DoNotPlot = TRUE)
  # usar graph = "glasso" o graph = "concentration"
  graph_cor <- qgraph(cor_bfi, graph = "concentration", groups = constructosList, DoNotPlot = TRUE)

  # Se visualiza el utilmo grafico generado...
  centralityPlot(list(concentration = graph_cor, glasso = graph_glas))
  #
}, width = 500, height = 500)


output$personGraDirPlot <- renderPlot({
  fitModel <- paramsSemFit()
  param_edges <- rutasModeloSEM(fitModel)
  # Trivial example of manually specifying edge color and widths:
  E <- as.matrix(data.frame(from = param_edges$to, to = param_edges$from, width = param_edges$val))
  qB <- qgraph(E, mode = "direct", edge.color = rainbow(3))

  # NOTA: El titulo debe AGREGARSE luego de generar el grafico, para que sea visualizado!
  title("Grupos de Investigaci\u00F3n U. de A. - Grafo Dirigido", line = 2.5)
  #

}, width = 500, height = 500)
