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
  obsFormat <- formatter("span", style = style(color = "red", font.weight = "bold"))
  zetaFormat <- formatter("span",
                          style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
                          x ~ sprintf("%.2f (rank: %02d)", x, rank(-x)))
  pvalueFormat <- formatter("span",
                            style = x ~ style(color = ifelse(x <= 0.05, "green", "red")),
                            x ~ icontext(ifelse(x <= 0.05, "ok", "remove"),
                                         ifelse(x <= 0.05, "Yes", "No")))
  ciLFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFmt <- x ~ round(x, digits=2)
  #
  param_data <- paramsSemFit() %>%
                filter(lhs %in% input$grafoAvanzSEMOut_selectedNodes)
  #
  formattable(param_data,
    list(
      lhs = latentFormat, rhs = obsFormat,
      area(col = c(est.std)) ~ normalize_bar("pink", 0.2),
      area(col = c(se)) ~ proportion_bar(),
      z = zetaFormat,
      pvalue = pvalueFormat,
      ci.lower = ciLFormat,
      ci.upper = ciUFmt
  ))
})

output$fitElementSEMTxtOut <- renderPrint({
  # fitMeasures(semFitLocal())
  lavInspect(semFitLocal(),"std")
  # lavInspect(fit2,"coef")
  # lavInspect(fit2,"rsquare")
  # residuals(fit2)
})
#
observe({
  input$getNodesSelBtn
  visNetworkProxy("grafoAvanzSEMOut") %>% visGetSelectedNodes()
})

# paste0(..) es una funcion vetorizadas, luego recorre _selectedNodes
# por cada item que tenga y concatenda por cada fila:
output$nodesListTxtOut <- renderPrint({
  paste0(input$grafoAvanzSEMOut_selectedNodes, ":by:",
         #input$grafoAvanzSEMOut_selected, "::",
         input$grafoAvanzSEMOut_selectedBy)
})
#
output$correlogramSEMOut <- renderSvgPanZoom({
  # POSIBLE USO PARA PRESENTAR LA MATRIZ C
  # ## visualize a  matrix in [-100, 100]
  # ran <- round(matrix(runif(225, -100,100), 15))
  # corrplot(ran, is.corr = FALSE)
  # corrplot(ran, is.corr = FALSE, cl.lim = c(-100, 100))
  # IMPORTANTE: con panEnabled "activo", es posible manipular la imagen en ZOOM.
  # Con viewBox "incativo" el objeto SVG queda contenido correctamente en el elemento UI
  # asociado, y usa los elementos de ancho y alto de dicha UI.
  svgPanZoom(controlIconsEnabled = TRUE, panEnabled = TRUE, viewBox = FALSE,
    svglite:::inlineSVG({
      corMat <- lavInspect(semFitLocal(), input$corType)
      corrplot(corMat, title = input$corType, method = input$corMethod)
    })
  )
})
#
output$heatmapSEMOut <- renderPlotly({
  # Funcion de heatmaply adecuda para matrices de correlacion:
  heatmaply_cor(lavInspect(semFitLocal(), input$heatmapType), margins = c(80, 80),
               main = input$heatmapType, k_col = 2, k_row = 2, dendrogram = input$showDendrogram)
})
#
