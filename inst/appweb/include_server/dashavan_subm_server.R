# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 19/09/2018 17:08:28 p. m.
#
output$grafoAvanzSEMOut <- renderVisNetwork({
  getGrafoModelSEMBase()
})

output$tablaGeneralSEMOut <- renderFormattable({
  # ESPECIFICACIONES DE FORMATO Y PRESENTACION PARA LA TABLA SEM DE LAVAAN:
  latentFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
  typeFormat <- formatter("span", style = style(color = "teal", font.weight = "bold"))
  obsFormat <- formatter("span", style = style(color = "red", font.weight = "bold"))
  # zetaFormat <- formatter("span",
  #                         style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
  #                         x ~ sprintf("%.2f (rank: %02d)", x, rank(-x)))
  pvalueFormat <- formatter("span",
                            style = x ~ style(color = ifelse(x <= 0.05, "green", "red")),
                            x ~ icontext(ifelse(x <= 0.05, "ok", "remove"),
                                         ifelse(x <= 0.05, paste("Si:", digits(x,3)), paste("No:", digits(x,3))))
                            )
  ciLFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFormat <- formatter("span",x~ style(digits(x,3)))
  # Se filtran los elementos por medio de la lista de nodos seleccionados en el grafo:
  param_data <- paramsSemFit() %>%
                filter(lhs %in% input$grafoAvanzSEMOut_selectedNodes) %>%
                transmute(desde = lhs,
                  tipo = dplyr::case_when(
                    op == "=~" ~ "carga-factor",
                    op == "~"  ~ "regresi\u00F3n",
                    op == "~~" ~ "correl./varianza",
                    op == "~1" ~ "intercepto",
                    TRUE ~ NA_character_),
                  hacia = rhs, est.stand = est.std,
                  ic.inf = ci.lower, ic.sup = ci.upper,
                  error = se, valor_p = pvalue, valor_z = z
               )
  #
  formattable(param_data,
    list(
      desde = latentFormat, tipo = typeFormat, hacia = obsFormat,
      area(col = c(est.stand)) ~ normalize_bar("lightblue", 0.2),
      ic.inf = ciLFormat,
      ic.sup = ciUFormat,
      area(col = c(error)) ~ proportion_bar("pink"),
      valor_p = pvalueFormat
  ))
})

output$fitElementSEMTxtOut <- renderPrint({
  # fitMeasures(semFitLocal())
  lavInspect(semFitLocal(),"std")
  # lavInspect(semFitLocal(),"coef")
  #residuals(semFitLocal(), type="standardized")$cov
})
# Se usa el objeto visNetworkProxy para establecer los elementos seleccionados en el Grafo:
# Para actualizar la seleccion de varios nodos, se hace necesario el Boton:
# observe({
#   input$getNodesSelBtn
#   visNetworkProxy("grafoAvanzSEMOut") %>% visGetSelectedNodes()
# })
#
# Aqui se observan cambios en la seleccion de un solo NODO (para varios se debe usar un Boton):
observeEvent(input$dashAvanzSEMBtn, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  visNetworkProxy("grafoAvanzSEMOut") %>% visGetSelectedNodes() # actualiza contenedores...
})
#
# paste0(..) es una funcion vetorizadas, luego recorre _selectedNodes
# por cada item que tenga y concatenada por cada fila:
output$nodesListTxtOut <- renderText({
  nodesListTxt <- paste(input$grafoAvanzSEMOut_selectedNodes, collapse = ",")
  # NOTA: La info para HTML(..) debe ser resultado de un paste(..):
  HTML(paste("Variables SEM:", nodesListTxt))
})
#
output$correlogramSEMOut <- renderPlot({
  # Se valida el tipo de datos a presentar:
  if(input$corType == "residual") {
    corMat <- lavaan::residuals(semFitLocal())$cov
  } else {
    corMat <- lavInspect(semFitLocal(), input$corType)
  }
  # Se usa el atributo is.corr = FALSE, indicando que NO es una matriz de correlación, con datos en: [-1,1]
  if(input$corType %in% c("cov.ov","cov.lv","residual")) {
    corrplot(corMat, is.corr = FALSE, title = input$corType,
             method = input$corMethod, type = input$corSection,  mar = c(1, 1, 2, 1))
  } else {
    # NOTA: numero de lineas para margenes del titulo en el grafico -> mar = c(bottom, left, top, right)
    corrplot(corMat, title = input$corType, method = input$corMethod,
             type = input$corSection,  mar = c(1, 1, 2, 1))
  }
})
#
output$heatmapSEMOut <- renderPlotly({
  # Se valida el tipo de datos a presentar:
  if(input$heatmapType == "residual") {
    corMat <- lavaan::residuals(semFitLocal())$cov
  } else {
    corMat <- lavInspect(semFitLocal(), input$heatmapType)
  }
  if(input$heatmapType %in% c("cov.ov","cov.lv","residual")) {
    heatmaply(corMat, colors = Oranges, margins = c(80, 80), # Margenes del grafico para titulos
               main = input$heatmapType, k_col = 2, k_row = 2, dendrogram = input$showDendrogram)
  } else {
    # Funcion de heatmaply adecuada para matrices de correlacion:
    heatmaply_cor(corMat, margins = c(80, 80), # Margenes del grafico para titulos
               main = input$heatmapType, k_col = 2, k_row = 2, dendrogram = input$showDendrogram)
  }
})
#
output$convenNodosTablaOut <- renderFormattable({
   varFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
   descFormat <- formatter("span", style = style(color = "blue", font.weight = "bold"))
   nodesLabels <- datasetLabelsInput()
   #
   param_data <- paramsSemFit() %>% filter(lhs %in% input$grafoAvanzSEMOut_selectedNodes)
   #
   #  Multiples condiciones en el filtro equivalen a un AND,
   #  por tanto se debe usar el operador: & (and) u | (or):
   #  TIP: "variable" es una columna de nodesLabels.
   #  NOTA: Se filtra por 'lhs' y 'rhs' debido a las columnas 'desde' y 'hacia' de la
   #        tabla presentada que contienen nombres de variables.
   selected_labels <- nodesLabels %>%
                      filter(variable %in% param_data$lhs |
                             variable %in% param_data$rhs) %>% arrange(variable)
   #
   formattable(selected_labels, list(variable = varFormat, desc = descFormat))
})
#
#shinyjs::onclick("convenNodosSwitch", shinyjs::toggle(id = "convenNodosDIV", anim = TRUE, animType = "fade"))
# NOTA: Se ha usado "observeEvent" para que SOLO al hacer clic en el "materialSwitch" se realice el "toggle"
observeEvent(input$convenNodosSwitch, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  shinyjs::toggle(id = "convenNodosDIV", anim = TRUE, animType = "fade")
})
#

