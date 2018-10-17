# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 17/10/2018 11:59:28 a. m.
#
output$barrasMedidaPlotOut<- renderAmCharts({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
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
