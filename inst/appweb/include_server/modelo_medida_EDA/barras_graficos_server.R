# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 17/10/2018 11:59:28 a. m.
#
output$barrasMedidaPlotOut<- renderAmCharts({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  # Valida ordenamiento de los score en los datos seleccionados:
  if(input$barrasMedidaSortCheck == TRUE){
    # ordena los datos de menor a mayor por columna !
    cast_data <- cast_data %>% dplyr::arrange_all()
  }
  #
  # Create a vector of n contiguous colors. Alpha [0, 1], escala de claridad del color, 0 la mas baja, 1 oscuro
  # Lisra de funciones predefinidas en R-base:
  # rainbow(n, alpha = 1)
  # heat.colors(n, alpha = 1)
  # terrain.colors(n, alpha = 1)
  # topo.colors(n, alpha = 1)
  # cm.colors(n, alpha = 1)
  # --> el atributo "zoom" activa el cursor comparativo, equivale al uso de: .. %>% setChartCursor()
  # --> el atributo "precision" define el numero de decimales en los datos numericos
  amBarplot(y = colnames(cast_data), data = cast_data, xlab = "Fila", ylab = "Score por Variable",
            groups_color = rainbow(ncol(cast_data), alpha = 0.7), horiz = input$barrasMedidaHorizCheck,
            stack_type = if_else(input$barrasMedidaStackCheck == TRUE, "regular", "none"),
            legend = TRUE, show_values = FALSE, zoom = input$barrasMedidaCursorCheck,
            scrollbar = input$barrasMedidaScrollCheck, precision = 3)
  #
})
#
output$circleBarMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)]
  #
  shiny::validate( # NOTA: el "row_id" mas el nodo seleccionado !
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica para una variable solamente.")
  )
  #
  id <- cast_data[c("row_id")]
  score <- cast_data[, 2]
  tmp_data <- data.frame(id, score)
  colnames(tmp_data) <- c("id", "score")
  #
  ggplot(tmp_data, aes(x=as.factor(id), y=score, fill=as.factor(id))) +
    labs(x = "Fila", y = paste("Score para", colnames(cast_data)[2])) +  # Asigna explicitamente los nombres a los ejes !
    geom_bar(stat="identity", alpha = 0.7) +
    ylim(-15, 10) +  # Escala para los score, el valor negativo genera espacio en el centro
    theme_light() +
    theme(
      axis.text = element_blank(),
      #axis.title = element_blank(),
      legend.position = 'none' #,
      #panel.grid = element_blank()
      #plot.margin = unit(rep(-2,4), "cm")
    ) + coord_polar(start = 0)
})
#
output$histoBarMedidaPlotOut <- renderPlot({
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                               id = "row_id", variable.name = "variable", value.name = "score")
  #
  circos.clear()
  circos.par("track.height" = 0.4)
  circos.initialize(factors = melt_data$variable, x = melt_data$score)
  circos.trackPlotRegion(factors = melt_data$variable, ylim = c(-10, 30),
    panel.fun = function(x, y) {
      circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] - uy(10, "mm"), CELL_META$sector.index)
      # circos.text(5, 10, get.cell.meta.data("sector.index"))
      circos.axis(labels.cex=0.8, labels.font=3, lwd=0.5)
  })
  colList = rainbow(length(input$grafoModeloMedicionOut_selectedNodes), alpha = 0.7)
  circos.trackHist(melt_data$variable, melt_data$score, col = colList, bg.col = "grey78")
  #
})
#
output$lollipopMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  # NOTA: usar get(..) permite leer el "string" como parametro.
  #dplyr::arrange(cast_data, get(colnames(cast_data)[2]))
  #
  ggp <- ggplot(cast_data, aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2])) +
    geom_segment(aes_string(x=colnames(cast_data)[1], xend=colnames(cast_data)[1],
                            y=0, yend=colnames(cast_data)[2]), color="cadetblue") +
    geom_point(size=4, color="red", fill=alpha("orange", 0.3), alpha=0.7, shape=21, stroke=1) +
    theme_bw() +
    theme(
      panel.grid.major.x = element_blank(),
      panel.border = element_blank(),
      axis.ticks.x = element_blank()
    )
  #
  # Verifica intercambio de ejes:
  if(input$lollipopMedidaEjesCheck) {
    ggp <- ggp + coord_flip()
  }
  #
  ggplotly(ggp)
})
#
output$paralelasMedidaPlotOut <- renderParcoords({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  parcoords(cast_data, rownames=input$paralelasMedidaRownameCheck, brushMode="1D-axes",
            alpha=0.9, alphaOnBrushed=0.1, reorderable=T, autoresize=T,
            # colorBy: Con "paste0(..)" genera el "string" del nombre. Se uso get(..) pero no funciono!
            color = list(colorBy = paste0(colnames(cast_data)[1]),
              colorScale = htmlwidgets::JS('d3.scale.category10()')
            )
  )
  #
})
#

