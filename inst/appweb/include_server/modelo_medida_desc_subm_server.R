# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/10/2018 17:36:28 a. m.
#
factorScoreData <- reactive({
  # Metodo de Lavaan para estimar los "score" de cada factor del modelo de medicion:
  data.frame(lavPredict(semFitLocal(), type = "ov", method = "regression"))
})
#
output$splomFactorOut <- renderPlotly({
  # ::ggpairs(..)
  # PRUEBA: usamos los score de las Xs del Factor "ind60"
  # DEFINIR SENTIDO: matriz de duo entre: valores orginales de las OBS,
  #                  valorers de las cargas (coef betas) de cada factor, valores de los score de cada factor? (la corr no da mucho)
  pm <- GGally::ggduo(factorScoreData()[c("x1","x2","y1", "y2")])
  ggplotly(pm)
})
