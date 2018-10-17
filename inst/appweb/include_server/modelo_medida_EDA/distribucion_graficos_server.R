# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 15/10/2018 11:52:28 a. m.
#
output$violinMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  # ggp <- ggplot(melt_data, aes(x = variable, y = score)) + geom_violin(aes(fill = variable))
  # FUNCIONA OK!, pero se mejoro con lo siguiente...
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  # ggplotly(ggp)
  #
  gpy <- melt_data %>%
    plot_ly(x = ~variable, y = ~score, split = ~variable, type = "violin",
            box = list(visible = T), meanline = list(visible = T)
    ) %>% layout(xaxis = list(title = "variable"), yaxis = list(title = "score", zeroline = T))
   #
   return(gpy)
})
# El grafico de densidad, es como un histograma (frecuencia acumnulada de los score) "suavizado":
output$densidad2DMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # alpha: 0.2 (colores claros) / 0.55 (colores intermedios),
  # es el parametro para el nivel de transparencia de las densidades presentadas:
  ggp <- ggplot(melt_data, aes(x = score, group = variable, fill = variable)) + geom_density(alpha=0.55)
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
})
# El grafico histograma es una frecuencia acumulada de los score:
output$histogramaMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # El histograma presenta la frecuencia acumulada de todos los score de las variables seleccionadas,
  # no agrupa por el nombre de la variable como "factor".
  # binwidth = 0.2: indica el ancho de la barra (bin="compartimiento"), al cual recolecta los score que caen alli.
  # ggp <- ggplot(melt_data, aes(x = score)) + geom_histogram(aes(binwidth = 0.2, fill = ..count..)) +
  #        scale_fill_gradient(low="blue", high="orange")  # FUNCIONA OK", pero se mejoro con lo siguiente:
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  # ggplotly(ggp)
  if(input$histogramaMedidaCheck) { # Presentar los histogramas separados...
    # NOTA:El operador %>% realiza la invocacion del siguiente elemento
    #      usando como primer parametro el elemento de la izquierda:
    melt_data %>%
        split(.$variable) %>%
        lapply(histogramByOne_plot) %>%
        subplot(shareX = TRUE, titleX = TRUE, shareY = TRUE, titleY = TRUE, nrows = 2) # Se retorna el subplot final...
  }
  else { # Presentar los histogramas unidos ...
    plot_ly(melt_data, x = ~score, color = ~variable, alpha = 0.6) %>%
            add_histogram() %>% layout(barmode = input$histogramaMedidaBarraType, yaxis = list(title = "Frecuencia"))
  }
  #
})
# Funcion de utileria para la presentacion de Histogramas en "histogramaMedidaPlotOut":
histogramByOne_plot <- function(byOneData) {
  plot_ly(byOneData, x = ~score, color = ~variable, alpha = 0.9) %>% add_histogram() %>%
          layout(yaxis = list(title = "Frecuencia"))
}
#
output$boxplotMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  # ggplot(melt_data, aes(x=variable, y=score, fill=variable)) + geom_boxplot(alpha=0.3) # ok !
  # qplot( x=variable , y=score , data=melt_data , geom=c("boxplot","jitter") , fill=variable, alpha=0.45) # ok !
  # NOTA: alpha: 0.3 (colores claros) / 0.45 (colores intermedios).
  geom_box = c("boxplot")
  if(input$boxplotMedidaJitterCheck == TRUE) {
    geom_box = c("boxplot","jitter")
  }
  ggp <- qplot(x=variable, y=score, data=melt_data, geom=geom_box, fill=variable)
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
})
#
# IMPORTANTE: Para Ridgeline se debe usar la version mas reciente de ggplot2 v 3.0.0
# -- Adicionalmente, plotly/renderSvgPanZoom no tiene actualmente el WRAPPER para este
#    tipo de grafico de "ggplot" por eso usa un "renderPlot" estandar.
output$ridgelineMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  # En "R" se debe usar el operador "+" en la misma linea del item base, y en la siguiente linea lo demas:
  #
  ggplot(melt_data, aes(x = score, y = variable, group = variable, fill = variable)) +
    geom_density_ridges(alpha=0.55, quantile_lines = TRUE, jittered_points = TRUE,
                        position = position_points_jitter(width = 0.05, height = 0),
                        point_shape = '|', point_size = 5, point_alpha = 1) +
    theme_ridges() + theme(legend.position = "none") +
    scale_y_discrete(expand=c(0.01, 0)) +
    scale_x_continuous(expand=c(0.01, 0))
  #
})
#
