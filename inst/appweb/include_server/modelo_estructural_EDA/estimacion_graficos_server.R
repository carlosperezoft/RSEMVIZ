# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 04/11/2018 1:55:31 p. m.
#
output$seriesEstructuralPlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedNodes)
  #
  if(!existenColumnas(semModelScoreData(), input$grafoModeloEstructuralOut_selectedNodes)) {
    return(NULL)
  }
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selectedNodes)]
  #
  scr_names <- paste(colnames(score_data), "SCR", sep=".")
  colnames(score_data) <- scr_names
  #
  # Se ejecuta filtro por nodo que NO sea LATENTE, ya que no hay datos OBSERVADOS para ellas:
  fitModel <- paramsSemFit()
  obser_sel <- (nodosModeloSEM(fitModel) %>%
                   dplyr::filter(node_name %in% input$grafoModeloEstructuralOut_selectedNodes, latent == FALSE))
  #
  obser_data <- datasetInput()[obser_sel$node_name]
  if(nrow(obser_sel) > 0) {
    obs_names <- paste(colnames(obser_data), "OBS", sep=".")
    colnames(obser_data) <- obs_names
  }
  #
  all_data <- data.frame(score_data, obser_data)
  #
  dygraph(all_data, main = "Flujo de los Score", xlab = "Fila", ylab = "Observado vs Score") %>%
     dyRangeSelector() %>% dyUnzoom() %>%
     dyCrosshair(direction = "both") %>%
     dyLegend(show = if_else(input$seriesEstructPointCheck, "follow", "always"), width = 400) %>%
     dyOptions(drawGrid = input$seriesEstructPointCheck, stepPlot = input$seriesEstructStepCheck,
               drawPoints = input$seriesEstructPointCheck, pointSize = 2,
               fillGraph = input$seriesEstructAreaCheck,
               pointShape = if_else(input$seriesEstructPointCheck, "circle", "dot"),
               colors = RColorBrewer::brewer.pal(9, "Set1")) %>%
     dyHighlight(highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.2,
                 highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = TRUE)
  #
})
#
output$barrasEstructuralPlotOut<- renderAmCharts({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedNodes)
  #
  score_data <- semModelScoreData()[input$grafoModeloEstructuralOut_selectedNodes]
  scr_names <- paste(colnames(score_data), "SCR", sep=".")
  colnames(score_data) <- scr_names
  #
  # Se ejecuta filtro por nodo que NO sea LATENTE, ya que no hay datos OBSERVADOS para ellas:
  fitModel <- paramsSemFit()
  obser_sel <- (nodosModeloSEM(fitModel) %>%
                   dplyr::filter(node_name %in% input$grafoModeloEstructuralOut_selectedNodes, latent == FALSE))
  #
  obser_data <- datasetInput()[obser_sel$node_name]
  if(nrow(obser_sel) > 0) {
    obs_names <- paste(colnames(obser_data), "OBS", sep=".")
    colnames(obser_data) <- obs_names
  }
  #
  all_data <- data.frame(score_data, obser_data)
  #
  # Valida ordenamiento de los score en los datos seleccionados:
  if(input$barrasEstructSortCheck == TRUE){
    # ordena los datos de menor a mayor por columna !
    all_data <- all_data %>% dplyr::arrange_all()
  }
  #
  # Create a vector of n contiguous colors. Alpha [0, 1], escala de claridad del color, 0 la mas baja, 1 oscuro
  # Lisra de funciones predefinidas en R-base:
  # --> el atributo "zoom" activa el cursor comparativo, equivale al uso de: .. %>% setChartCursor()
  # --> el atributo "precision" define el numero de decimales en los datos numericos
  amBarplot(y = colnames(all_data), data = all_data, xlab = "Fila", ylab = "Observado vs Score",
            groups_color = rainbow(ncol(all_data), alpha = 0.7),
            horiz = input$barrasEstructHorizCheck,
            stack_type = if_else(input$barrasEstructStackCheck == TRUE, "regular", "none"),
            legend = TRUE, show_values = FALSE, zoom = input$barrasEstructCursorCheck,
            scrollbar = input$barrasEstructScrollCheck, precision = 3)
  #
})
#
output$densidad2DEstructPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selectedNodes)
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selectedNodes)]
  scr_names <- paste(colnames(score_data), "SCR", sep=".")
  colnames(score_data) <- scr_names
  #
  # Se ejecuta filtro por nodo que NO sea LATENTE, ya que no hay datos OBSERVADOS para ellas:
  fitModel <- paramsSemFit()
  obser_sel <- (nodosModeloSEM(fitModel) %>%
                   dplyr::filter(node_name %in% input$grafoModeloEstructuralOut_selectedNodes, latent == FALSE))
  #
  obser_data <- datasetInput()[obser_sel$node_name]
  if(nrow(obser_sel) > 0) {
    # Se adiciona la columna de: row_id, para el proceso "melt"
    obser_data$row_id <- seq(1:(nrow(obser_data)))
    #
    obs_names <- paste(colnames(obser_data), "OBS", sep=".")
    colnames(obser_data) <- obs_names
    #
    obser_melt_data <- melt(obser_data, id = "row_id.OBS", variable.name = "variable", value.name = "obser")
    obser_lines <- ggplot(obser_melt_data, aes(x=row_id.OBS, y=obser)) +
                          labs(x = "Fila.OBS", y = "Dato/Score") +
                          geom_line(aes(group=variable, colour=variable), alpha = 0.6)
    #
    obser_density <- ggplot(obser_melt_data, aes(x=row_id.OBS, y=obser)) +
                            labs(x = "Fila.OBS", y = "Densidad") +
                            theme(legend.position = "none") + geom_hex() # geom_bin2d()
  }
  #
  score_melt_data <- melt(score_data, id = "row_id.SCR", variable.name = "variable", value.name = "score")
  score_lines <- ggplot(score_melt_data, aes(x=row_id.SCR, y=score)) +
                        labs(x = "Fila.SCR", y = "Score Estimado") +
                        geom_line(aes(group=variable, colour=variable), alpha = 0.6)
  #
  score_density <- ggplot(score_melt_data, aes(x=row_id.SCR, y=score)) +
                          labs(x = "Fila.SCR", y = "Densidad") +
                          theme(legend.position = "none") + geom_hex()
  #
  if(nrow(obser_sel) > 0) {
     # NOTA: Se ubica "score_lines" de ultimo para que "plotly" active la seleccion por "leyenda"
     plotly::subplot(obser_density, score_density, obser_lines, score_lines,
                     nrows = 2, shareX = TRUE, shareY = TRUE, titleY = TRUE, titleX = TRUE)
     # NOTA: Es posible usar un SUBPLOT con subplots, pero en este caso no fue muy util...
     # sp2 <- plotly::subplot(obser_density, score_density, # obser_lines, score_lines,
     #                 nrows = 1, shareX = TRUE, shareY = TRUE, titleY = T, titleX = T)
     # plotly::subplot(sp1, sp2, nrows = 2, shareX = TRUE, shareY = TRUE, titleY = T, titleX = T)
     #
  } else {
     # NOTA: Se ubica "score_lines" de ultimo para que "plotly" active la seleccion por "leyenda"
     plotly::subplot(score_density, score_lines,
                     nrows = 1, shareX = TRUE, shareY = TRUE, titleY = TRUE, titleX = TRUE)
  }
  #
})
#
output$prediccionSeriesEstructPlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selected)
  # Se ejecuta filtro para que el nodo sea VAR.LATENTE, con el objetivo de validar Regresion:
  fitModel <- paramsSemFit()
  nodo_sel <- (nodosModeloSEM(fitModel) %>%
                   dplyr::filter(node_name == input$grafoModeloEstructuralOut_selected))
  #
  shiny::validate(
    shiny::need(nodo_sel[1,"latent"] == TRUE, "Este tipo de gr\u00E1fico aplica a UNA variable LANTENTE solamente.")
  )
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selected)]
  #
  dygraph(score_data, main = "Flujo del Score", xlab = "Fila.SCR",
                      ylab = paste("Score Estimado:", colnames(score_data)[2])) %>%
     dyRangeSelector() %>% dyUnzoom() %>% dyCrosshair(direction="both") %>%
     dyLegend(show="follow", width=110) %>%
     dyOptions(drawPoints=TRUE, pointSize=2, pointShape="circle") %>%
     dyHighlight(highlightCircleSize = 4, highlightSeriesBackgroundAlpha = 0.2,
                 highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = TRUE)
  #
})
#
output$prediccionScatterEstructPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloEstructuralOut_selected)
  # Se ejecuta filtro para que el nodo sea VAR.LATENTE, con el objetivo de validar Regresion:
  fitModel <- paramsSemFit()
  nodo_sel <- (nodosModeloSEM(fitModel) %>%
                   dplyr::filter(node_name == input$grafoModeloEstructuralOut_selected))
  #
  shiny::validate(
    shiny::need(nodo_sel[1,]$latent == TRUE, "Este tipo de gr\u00E1fico aplica a UNA variable LANTENTE solamente.")
  )
  #
  score_data <- semModelScoreData()[c("row_id", input$grafoModeloEstructuralOut_selected)]
  #
  scatPlot <- ggplot(score_data,
                     aes_string(x=colnames(score_data)[1], y=colnames(score_data)[2], color=colnames(score_data)[2])) +
    labs(x = "Fila.SCR", y = paste("Score Estimado:", colnames(score_data)[2])) +
    geom_point() + geom_rug(col="steelblue", alpha=0.5, size=1.5) +
    # al usar poly(..) se tiene una curva con mejor ajuste en el smooth:
    geom_smooth(method=lm , formula = y ~ poly(x, 3), color="red", se=TRUE) +
    scale_colour_gradient(low = "blue", high = "orange")
  #
  ggplotly(scatPlot)
  #
})
