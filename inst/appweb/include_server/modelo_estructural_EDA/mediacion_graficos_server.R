# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 20/02/2019 11:50:31 a.m.
#
#
output$mediacionRegreSerie1APlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloEstructuralOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  shiny::validate( # NOTA: La mediacion deben ser 3 var latentes seleccionadas !
     shiny::need(sum(lengths(input$grafoModeloEstructuralOut_selectedNodes)) == 3,
                 "Este tipo de gr\u00E1fico aplica para TRES variables solamente.")
  )
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selectedNodes[1])]
  #
  dygraph(score_data, main = "Flujo del Score A", xlab = "Fila.SCR", group = "mediacionRegreSerieGroup",
                      ylab = paste("Score Estimado:", colnames(score_data)[2])) %>%
     dyRangeSelector() %>% dyUnzoom() %>% dyCrosshair(direction="both") %>%
     dyLegend(show="follow", width=110) %>%
     dyOptions(drawPoints=TRUE, pointSize=2, pointShape="circle") %>%
     dyHighlight(highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.2,
                 highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = TRUE)
  #
})
#
output$mediacionRegreSerie1ABPlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloEstructuralOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  shiny::validate( # NOTA: La mediacion deben ser 3 var latentes seleccionadas !
     shiny::need(sum(lengths(input$grafoModeloEstructuralOut_selectedNodes)) == 3,
                 "Este tipo de gr\u00E1fico aplica para TRES variables solamente.")
  )
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selectedNodes[2])]
  #
  dygraph(score_data, main = "Flujo del Score B", xlab = "Fila.SCR", group = "mediacionRegreSerieGroup",
                      ylab = paste("Score Estimado:", colnames(score_data)[2])) %>%
     dyRangeSelector() %>% dyUnzoom() %>% dyCrosshair(direction="both") %>%
     dyLegend(show="follow", width=110) %>%
     dyOptions(drawPoints=TRUE, pointSize=2, pointShape="circle") %>%
     dyHighlight(highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.2,
                 highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = TRUE)
  #
})
#
output$mediacionRegreSerie1ACPlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloEstructuralOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  shiny::validate( # NOTA: La mediacion deben ser 3 var latentes seleccionadas !
     shiny::need(sum(lengths(input$grafoModeloEstructuralOut_selectedNodes)) == 3,
                 "Este tipo de gr\u00E1fico aplica para TRES variables solamente.")
  )
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selectedNodes[3])]
  #
  dygraph(score_data, main = "Flujo del Score B", xlab = "Fila.SCR", group = "mediacionRegreSerieGroup",
                      ylab = paste("Score Estimado:", colnames(score_data)[2])) %>%
     dyRangeSelector() %>% dyUnzoom() %>% dyCrosshair(direction="both") %>%
     dyLegend(show="follow", width=110) %>%
     dyOptions(drawPoints=TRUE, pointSize=2, pointShape="circle") %>%
     dyHighlight(highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.2,
                 highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = TRUE)
  #
})
