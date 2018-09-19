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
  formattable(paramsSemFit(), list(
    lhs = latentFormat, rhs = obsFormat,
    area(col = c(est.std)) ~ normalize_bar("pink", 0.2),
    area(col = c(se)) ~ proportion_bar(),
    z = zetaFormat,
    pvalue = pvalueFormat,
    ci.lower = ciLFormat,
    ci.upper = ciUFmt
  ))
})

output$indicesAjusteSEMTxtOut <- renderPrint({
  fitMeasures(semFitLocal())
})

observe({
  input$getNodesSelBtn
  visNetworkProxy("grafoAvanzSEMOut") %>% visGetSelectedNodes()
})

# paste0(..) es una funcion vetorizadas, luego recorre _selectedNodes
# por cada item que tenga y concatenda por cada fila:
output$nodesListTxtOut <- renderPrint({
  paste0("{", input$grafoAvanzSEMOut_selectedNodes,
         "} NODO_ID = (", input$grafoAvanzSEMOut_selected,
         ") POR_GRUPO = ", input$grafoAvanzSEMOut_selectedBy)
})
