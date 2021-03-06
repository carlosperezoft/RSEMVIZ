# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 19/09/2018 17:08:28 p. m.
#
# Se usa "reactive" para auto-reprocesar la "funcion" cuando cambie algun "input" !
# IMPORTANTE: El modelo SEM se visualiza con los datos estimados en formato estandarizado.
paramsSemFit <- reactive({
  lavaan::standardizedSolution(semFitLocal())
})
#
# Se usa "reactive" para auto-reprocesar la "funcion" cuando cambie algun "input" interno !
getGrafoModelSEMBase <- reactive({
  fitModel <- paramsSemFit()
  nodesLabels <- datasetLabelsInput()
  visNetwork(nodosGrafoSEM(fitModel, nodesLabels), rutasGrafoSEM(fitModel),
    main = "Graphical Analysis Driven SEM", width = "100%") %>%
    # darkblue square with shadow for group "LATENTE" (la figura es un "circulo" que escala con el "value" del nodo)
    visGroups(groupname = "LATENTE", color = "orange", shape = "dot") %>%
    # red triangle for group "OBSERVADA" (la figura es un "cuadrado" que escala con el "value" del nodo)
    visGroups(groupname = "OBSERVADA", color = "lightblue", shape = "square") %>%
    # OPCIONES PARA TEMAS DE RENDIMIENTO AL GRAFICAR:
    visLayout(randomSeed = 1409) %>%
    visPhysics(stabilization = FALSE) %>%
    # Opciones generales para las rutas
    # NOTA: "smooth", controla el procesamiento elastico de las flechas,
    #       "activo" puede ser lento en grafos de muchos nodos, pero genera un grafico mejor distribuido !!
    visEdges(smooth = TRUE, scaling = list(min=3, max=6)) %>%
    # Opciones generales para los nodos:
    visNodes(shadow = TRUE) %>%
    # OPCIONES DE INTERACCION PARA USO DE TECLADO (multiselect=TRUE para seleccionar nodos uno a uno con CTRL-CLIC sostenido):
    visInteraction(navigationButtons = TRUE, keyboard = TRUE, multiselect = TRUE) %>%
    # OPCIONES DE FILTRO PARA LOS NODOS VISUALIZADOS:
    visOptions(selectedBy = "group", nodesIdSelection = TRUE,
               highlightNearest = list(enabled = TRUE, degree = 2, hover = TRUE))
})
#
