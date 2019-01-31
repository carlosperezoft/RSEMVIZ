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
output$mediacionRegreSerie2BPlotOut <- renderDygraph({
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
output$mediacionRegreSerie3CPlotOut <- renderDygraph({
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
#
output$medRegSer1AFrom <- renderText({
  paste0(req(input$mediacionRegreSerie1APlotOut_date_window[[1]]))
})
#
output$medRegSer1ATo <- renderText({
  paste0(req(input$mediacionRegreSerie1APlotOut_date_window[[2]]))
})
#
output$medRegSer1AClicked <- renderText({
  req(input$mediacionRegreSerie1APlotOut_click$x)
  paste0(casoEstudioData()[input$mediacionRegreSerie1APlotOut_click$x,]$row_label)
})
#
output$medRegSer1APoint <- renderText({
  paste0('X = ', req(input$mediacionRegreSerie1APlotOut_click$x_closest_point),
         '; Y = ', req(input$mediacionRegreSerie1APlotOut_click$y_closest_point))
})
#
output$medRegSer2BClicked <- renderText({
  req(input$mediacionRegreSerie2BPlotOut_click$x)
  paste0(casoEstudioData()[input$mediacionRegreSerie2BPlotOut_click$x,]$row_label)
})
#
output$medRegSer2BPoint <- renderText({
  paste0('X = ', req(input$mediacionRegreSerie2BPlotOut_click$x_closest_point),
         '; Y = ', req(input$mediacionRegreSerie2BPlotOut_click$y_closest_point))
})
#
output$medRegSer3CClicked <- renderText({
  req(input$mediacionRegreSerie3CPlotOut_click$x)
  paste0(casoEstudioData()[input$mediacionRegreSerie3CPlotOut_click$x,]$row_label)
})
#
output$medRegSer3CPoint <- renderText({
  paste0('X = ', req(input$mediacionRegreSerie3CPlotOut_click$x_closest_point),
         '; Y = ', req(input$mediacionRegreSerie3CPlotOut_click$y_closest_point))
})
#
