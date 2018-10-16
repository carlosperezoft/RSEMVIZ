# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 15/10/2018 11:58:28 a. m.
#
output$scatterMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  # NOTA: La notacion cast_data[, 1]; toma los valores de todas las filas para la columna 1.
  # -- Se cambia el uso de especificacion de la estica "aes(..)" por "aes_string(..)",
  # -- ya que permite el paso de nombres de las variables (columnas en "cast_data").
  ggp <- ggplot(cast_data,
                aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2], color=colnames(cast_data)[2])) +
    geom_point() + geom_rug(col="steelblue", alpha=0.3, size=1.5) +
    scale_color_gradientn(colours = rainbow(5))
  # Se usa el objeto "ggp" para una invocacion mas limpia...
  ggplotly(ggp)
})
#
# IMPORTANTE: plotly actualmente no tiene el WRAPPER para ggExtra (ggMarginal).
# --> Por eso usa un "plotOutput" estandar.
output$scatterRegresMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  # IMPORTANTE: Se cambia el uso de especificacion de la estica "aes(..)" por "aes_string(..)",
  # --> ya que permite el paso de nombres de las variables (columnas en "cast_data").
  scatPlot <- ggplot(cast_data,
                     aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2], color=colnames(cast_data)[2])) +
    geom_point() + geom_rug(col="steelblue", alpha=0.5, size=1.5) +
    geom_smooth(method=lm , color="red", se=TRUE) +
    scale_colour_gradient(low = "blue", high = "orange")
  # Se adicionan elementos al margen del scatter plot:
  ggMarginal(scatPlot, type = input$scatterRegresMedidaType,
             margins = input$scatterRegresMedidaMargins, color = "green")
})

#
output$splomMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  # ::ggpairs(..)
  # DEFINIR SENTIDO: matriz de duo entre: valores orginales de las OBS,
  #   valores de las cargas (coef betas) de cada factor, valores de los score de cada factor? (la corr no da mucho)
  pm <- GGally::ggpairs(semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes],
                        lower = list(continuous = "smooth"),
                        mapping = ggplot2::aes(colour=I("cadetblue"))
  ) # FIN GGally
  ggplotly(pm)
})
#
output$heatmapMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  if(input$heatmapMedidaTransType == "Normalizar") {
    cast_data <- heatmaply::normalize(cast_data)
  } else if(input$heatmapMedidaTransType == "Porcentualizar") {
    cast_data <- heatmaply::percentize(cast_data)
  }
  #
  if(input$heatmapMedidaTransType == "Escalar") {
    hpy <- heatmaply(cast_data, scale = "column", margins = c(60,100,40,20),
              main = paste("Transformaci\u00F3n aplicada:", input$heatmapMedidaTransType),
              xlab = "Variable", ylab = "Score", k_col = 2, k_row = 3, dendrogram = input$heatmapMedidaDendroType)
  } else {
    hpy <- heatmaply(cast_data, margins = c(60,100,40,20), k_col = 2, k_row = 3,
              main = paste("Transformaci\u00F3n aplicada:", input$heatmapMedidaTransType),
              xlab = "Variable", ylab = "Score", dendrogram = input$heatmapMedidaDendroType)
  }
  return(hpy)
})
#
output$correlogramaMedidaPlotOut <- renderPlot({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  corrplot(cor(semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]),
           method = input$correlogramaMedidaMethod, type = input$correlogramaMedidaSection,  mar = c(1, 1, 2, 1))
})
#
output$bubleMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  #
  ggplotly(ggplot(cast_data, aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2],
                  color=colnames(cast_data)[2], size=colnames(cast_data)[2])) + geom_point(alpha=0.5) +
     # Se controla el rango maximo del circulo, y se usa la funcion exp(onencial) para tener mas visibilidad:
     scale_size_continuous(trans="exp", range=c(1, 25)) +
     #scale_colour_continuous(guide = FALSE))  # Escala en un solo color
     #scale_colour_gradient(low = "blue", high = "orange")) # Escala de azul a naranja
     scale_color_gradientn(colours = rainbow(5))) # Escala en arcoiris, OK!
  #
})
#
output$contourMedidaPlotOut <- renderPlotly({
  # verifica que tenga informacion. Cancela la invocacion dado el caso, y evita cualquier proceso "reactive" asociado
  req(input$grafoModeloMedicionOut_selectedNodes)
  #
  cast_data <- semModelScoreData()[input$grafoModeloMedicionOut_selectedNodes]
  #
  shiny::validate(
    shiny::need(ncol(cast_data) == 2, "Este tipo de gr\u00E1fico aplica a DOS elementos solamente.")
  )
  #
  #
  ggp <- ggplot(cast_data, aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2])) +
    # geom_bin2d(bins = round(nrow(cast_data) / 5)) +
     #geom_hex(bins = round(nrow(cast_data) / 5)) +
     #scale_fill_gradient(low = "blue", high = "orange")
    # theme_bw()
    #stat_density_2d(aes(fill = ..level..), geom = "polygon") +
    stat_density_2d(aes(fill = ..level..), geom = "polygon", colour="white")
    # scale_fill_gradientn(colours = terrain.colors(10))
    #stat_density_2d(aes(fill = ..density..), geom = "raster", contour = TRUE) + geom_point(colour = "white")
    # scale_x_continuous(expand = c(0, 0)) +
    # scale_y_continuous(expand = c(0, 0)) +
    # theme(
    #   legend.position='none'
    # )
  # ggp <- ggplot(cast_data, aes_string(x=colnames(cast_data)[1], y=colnames(cast_data)[2])) +
  #        stat_density2d(geom="tile", aes(fill = ..density..), contour = FALSE) + geom_point(colour = "white")
  #
  ggplotly(ggp)
})
