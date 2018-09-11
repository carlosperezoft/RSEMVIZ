# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 05/09/2018 14:08:28 p. m.
#
paramsSemFit <- function() {
  lavaan::standardizedSolution(semFitLocal())
}

getGrafoModelSEMBase <- function() {
  fitModel <- paramsSemFit()
  visNetwork(nodosGrafoSEM(fitModel), rutasGrafoSEM(fitModel), main = "Graphical Analysis Driven SEM", width = "100%") %>%
    # darkblue square with shadow for group "LATENTE" (la figura es un "circulo" que escala con el "value" del nodo)
    visGroups(groupname = "LATENTE", color = "orange", shape = "dot") %>%
    # red triangle for group "OBSERVADA" (la figura es un "cuadrado" que escala con el "value" del nodo)
    visGroups(groupname = "OBSERVADA", color = "lightblue", shape = "square") %>%
    # OPCIONES PARA TEMAS DE RENDIMIENTO AL GRAFICAR:
    visLayout(randomSeed = 1409) %>%
    visPhysics(stabilization = FALSE) %>%
    # Opciones generales para las rutas
    # NOTA: "smooth", controla el procesamiento elastico de las flechas, "activo" puede ser lento en grafos de muchos nodos!
    visEdges(smooth = TRUE) %>%
    # Opciones generales para los nodos:
    visNodes(shadow = TRUE) %>%
    # OPCIONES DE INTERACCION PARA USO DE TECLADO (multiselect=TRUE para seleccionar nodos uno a uno con CTRL-CLIC sostenido):
    visInteraction(navigationButtons = TRUE, keyboard = TRUE, multiselect = TRUE) %>%
    # OPCIONES DE FILTRO PARA LOS NODOS VISUALIZADOS:
    visOptions(selectedBy = "group", nodesIdSelection = TRUE,
               highlightNearest = list(enabled = TRUE, degree = 2, hover = TRUE))

}

output$grafoModeloSEMOut <- renderVisNetwork({
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
  visNetworkProxy("grafoModeloSEMOut") %>% visGetSelectedNodes()
})

# paste0(..) es una funcion vetorizadas, luego recorre _selectedNodes
# por cada item que tenga y concatenda por cada fila:
output$nodesListTxtOut <- renderPrint({
  paste0("{", input$grafoModeloSEMOut_selectedNodes,
         "} NODO_POR_ID = (", input$grafoModeloSEMOut_selected,
         ") POR_GRUPO = ", input$grafoModeloSEMOut_selectedBy)
})


