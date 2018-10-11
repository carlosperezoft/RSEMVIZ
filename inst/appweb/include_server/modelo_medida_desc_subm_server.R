# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/10/2018 17:36:28 a. m.
#
output$splomFactorOut <- renderPlotly({
  req(input$grafoModeloMedicionOut_selectedNodes) # verifica que tenga informacion...
  # ::ggpairs(..)
  # PRUEBA: usamos los score de las Xs del Factor "ind60"
  # DEFINIR SENTIDO: matriz de duo entre: valores orginales de las OBS,
  #                  valores de las cargas (coef betas) de cada factor, valores de los score de cada factor? (la corr no da mucho)
  pm <- GGally::ggduo(semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes])
  ggplotly(pm)
})
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
  # unlist(input$grafoModeloMedicionOut_selectedNodes)
  nodesListTxt <- paste(input$grafoModeloMedicionOut_selectedNodes, collapse = ",")
  # NOTA: La info para HTML(..) debe ser resultado de un paste(..):
  HTML(paste(tags$b("grafoModeloMedicionOut_selectedNodes:"), nodesListTxt))
})
#
