# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 05/09/2018 14:08:28 p. m.
#
paramsSemFit <- function() {
  lavaan::standardizedSolution(semFitLocal())
}

output$grafoModeloSEMOut <- renderVisNetwork({
  fitModel <- paramsSemFit()
  visNetwork(nodosGrafoSEM(fitModel), rutasGrafoSEM(fitModel), main = "MODELO SEM", width = "100%") %>%
    # darkblue square with shadow for group "LATENTE"
    # visGroups(groupname = "LATENTE", color = "darkblue", shape = "square", shadow = list(enabled = TRUE)) %>%
    # red triangle for group "OBSERVADA"
    # visGroups(groupname = "OBSERVADA", color = "red", shape = "triangle") %>%
    # OPCIONES PARA TEMAS DE RENDIMIENTO AL GRAFICAR:
    visLayout(randomSeed = 9090) %>%
    visPhysics(stabilization = FALSE) %>%
    visEdges(smooth = FALSE) %>%
    # OPCIONES DE INTERACCION PARA USO DE TECLADO:
    visInteraction(navigationButtons = TRUE, keyboard = TRUE) %>%
    # OPCIONES DE FILTRO PARA LOS NODOS VISUALIZADOS:
    visOptions(selectedBy = "group", nodesIdSelection = TRUE,
               highlightNearest = list(enabled = T, degree = 2, hover = T))

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

