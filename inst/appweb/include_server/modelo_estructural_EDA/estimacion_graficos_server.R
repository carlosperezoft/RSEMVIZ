# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 04/11/2018 1:55:31 p. m.
#
output$seriesEstructuralPlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedNodes)
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selectedNodes)]
  obser_data <- datasetInput()[input$grafoModeloEstructuralOut_selectedNodes]
  #
  obs_names <- paste(colnames(obser_data), "OBS", sep="_")
  scr_names <- paste(colnames(score_data), "SCR", sep="_")
  #
  colnames(obs_names) <- obs_names
  colnames(scr_names) <- scr_names
  all_data <- data.frame(scr_names, obs_names)
  #
  dygraph(all_data, main = "Flujo de los Score", xlab = "Fila", ylab = "Score por Variable") %>%
     dyRangeSelector() %>% dyUnzoom() %>%
     dyCrosshair(direction = "both") %>%
     # dyLegend(show = if_else(input$seriesMedidaPointCheck, "follow", "always"), width = 400) %>%
     # dyOptions(drawGrid = input$seriesMedidaPointCheck, stepPlot = input$seriesMedidaStepCheck,
     #           drawPoints = input$seriesMedidaPointCheck, pointSize = 4,
     #           fillGraph = input$seriesMedidaAreaCheck,
     #           pointShape = if_else(input$seriesMedidaPointCheck, "circle", "dot"),
     #           colors = RColorBrewer::brewer.pal(9, "Set1")) %>%
     dyHighlight(highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.2,
                 highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = T)
  #
})
#
output$barrasEstructuralPlotOut<- renderAmCharts({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedNodes)
  #
  score_data <- semModelScoreData()[input$grafoModeloEstructuralOut_selectedNodes]
  obser_data <- datasetInput()[input$grafoModeloEstructuralOut_selectedNodes]
  #
  obs_names <- paste(colnames(obser_data), "OBS", sep="_")
  scr_names <- paste(colnames(score_data), "SCR", sep="_")
  #
  colnames(obs_names) <- obs_names
  colnames(scr_names) <- scr_names
  all_data <- data.frame(scr_names, obs_names)
  #
  # Valida ordenamiento de los score en los datos seleccionados:
  # if(input$barrasMedidaSortCheck == TRUE){
  #   # ordena los datos de menor a mayor por columna !
  #   all_data <- all_data %>% dplyr::arrange_all()
  # }
  #
  # Create a vector of n contiguous colors. Alpha [0, 1], escala de claridad del color, 0 la mas baja, 1 oscuro
  # Lisra de funciones predefinidas en R-base:
  # --> el atributo "zoom" activa el cursor comparativo, equivale al uso de: .. %>% setChartCursor()
  # --> el atributo "precision" define el numero de decimales en los datos numericos
  amBarplot(y = colnames(all_data), data = all_data, xlab = "Fila", ylab = "Score por Variable",
            groups_color = rainbow(ncol(all_data), alpha = 0.7),
            horiz = F, #input$barrasMedidaHorizCheck,
            # stack_type = if_else(input$barrasMedidaStackCheck == TRUE, "regular", "none"),
            legend = TRUE, show_values = FALSE, zoom = T, #input$barrasMedidaCursorCheck,
            #scrollbar = input$barrasMedidaScrollCheck,
            precision = 3)
  #
})
#
