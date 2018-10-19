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
