# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 22/10/2018 16:17:28 p. m.
#
output$sankeyMedidaPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedBy)
  #
  shiny::validate(
    shiny::need(input$grafoModeloMedicionOut_selectedBy == "LATENTE",
                "Este tipo de gr\u00E1fico aplica solamente para el conjunto de variables LATENTES")
  )
  #
  fitModel <- paramsSemFit()
  # Se deben filrtar los enlaces circulares, el plotly sankey NO permire loops (entiendo..):
  edgesVis <- rutasModeloSEM(fitModel) %>% filter(from != to)
  #
  # Es posible multiplicar el "edgesVis$val" por algun valor. Pero con el formato "valueformat = ".3r" es lo adecuado
  links=data.frame(source=edgesVis$from, target=edgesVis$to, value=(edgesVis$val))
  nodes=data.frame(name=c(as.character(links$source), as.character(links$target)) %>% unique())
  # El sankey usa 0-index para los enlaces:
  links$IDsource=match(links$source, nodes$name)-1
  links$IDtarget=match(links$target, nodes$name)-1
  #
  plot_ly(type = "sankey", domain = list(x =  c(0,1), y =  c(0,1)), # el domain indica el rango de los valores..
      orientation = if_else(input$sankeyMedidaVerticalCheck, "v", "h"),
      valueformat = ".3r", valuesuffix = "std", # formato con redondeo a 3 decimales, y con sufijo de "estandarizado"
      node = list(label = nodes$name, pad = 15, thickness = 20,
        line = list(color = "black", width = 0.5)
      ),
      link = list(
        source = links$IDsource,
        target = links$IDtarget,
        value  = links$value
      )
    ) %>% layout(title = "Cargas de coeficientes entre variables", font = list(size = 10),
          xaxis = list(showgrid = T, zeroline = T),
          yaxis = list(showgrid = T, zeroline = T)
    )
})
#
output$streamgraphMedidaPlotOut <- renderStreamgraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  streamgraph(data = melt_data, key="variable", value="score", date="row_id", scale = "continuous", # al usar ID como date...
              interpolate = if_else(input$streamgraphMedidaLinealCheck, "linear", "cardinal"),
              offset = if_else(input$streamgraphMedidaApilarCheck, "zero", "silhouette")) %>%
              sg_legend(TRUE, "Variable: ") %>% sg_fill_brewer("Set2")
  #
})
#
output$signalMedidaPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  ggp <- ggplot(melt_data, aes(x = row_id, y = score, group = variable, fill = variable)) +
         stat_steamgraph() + labs(x = "Fila", y = "Score por variable") +
         scale_fill_brewer(palette = "Set1") + theme_bw()
  #
  ggplotly(ggp)
})
#
output$stackedAreaMedidaPlotOut <- renderPlotly({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  melt_data <- melt(semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)],
                    id = "row_id", variable.name = "variable", value.name = "score")
  #
  ggp <- ggplot(melt_data, aes(x=row_id, y=score, fill=variable)) +
         geom_area() + labs(x = "Fila", y = "Score por variable") +
         scale_fill_brewer(palette = "Set3", breaks=rev(levels(melt_data$variable))) + theme_bw()
  #
  ggplotly(ggp)
})
#
output$seriesMedidaPlotOut <- renderDygraph({
  # Verifica el objeto indicado. Dado el caso NULL: cancela cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[c("row_id", input$grafoModeloMedicionOut_selectedNodes)]
  #
  # PENDIENTE: add boton de opciones con temas de:
  # http://rstudio.github.io/dygraphs/gallery-series-options.html
  # y un opcion extra para "dyHighlight" como : Usar resaltar lineas
  dygraph(cast_data, main = "Flujo de los Score", xlab = "Fila", ylab = "Score por Variable") %>%
         dyRangeSelector() %>% dyUnzoom() %>%
         dyOptions(drawGrid = T, colors = RColorBrewer::brewer.pal(3, "Set1")) %>%
         dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2,
                     highlightSeriesOpts = list(strokeWidth = 3), hideOnMouseOut = T)
  #
})
