# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 10/09/2018 18:55:28 p. m.
#
# IMPORTANTE: Validar el caso de que trae los datos NO estandarizados (hipotSEMFit) para su validación:
# ** El modelo SEM se visualiza con los datos estimados en formato estandarizado.
hipotSEMFit <- function() {
  lavaan::parameterEstimates(semFitLocal(), standardized = TRUE, rsquare = FALSE)
  #lavaan::standardizedSolution(semFitLocal()) # Validar si usar siempre estandarizado, se deden ajustar las ecuaciones!
}
#
output$grafoHipotSEMOut <- renderVisNetwork({
  getGrafoModelSEMBase()
})
# Se usa el objeto visNetworkProxy para establecer los elementos seleccionados en el Grafo:
# visNetwork crea un objeto "input_extra" asociadado al "input_visNet" por cada elemento
# tipo de contenedor, esto es: _selectedNodes, _selected, _selectedBy
# input$grafoHipotSEMOut_selectedNodes # Verifica nodos seleccionados
# input$grafoHipotSEMOut_selected      # Verifica nodo (por nombre-ID) seleccionado
# input$grafoHipotSEMOut_selectedBy   # Verifica grupo (por nombre-ID) seleccionado
# observeEvent(input$grafoHipotSEMOut_selected, {  # Util en caso de un solo elemento...
# eventReactive(..), no funciona con el tipo "_selected"
# Aqui se observan cambios en la seleccion de un solo NODO (para varios se debe usar un Boton):
observeEvent(input$dashHipotSEMBtn, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  visNetworkProxy("grafoHipotSEMOut") %>% visGetSelectedNodes() # actualiza contenedores...
})
#
output$tablaHipotesisModeloOut <- renderFormattable({
  # ESPECIFICACIONES DE FORMATO Y PRESENTACION PARA LA TABLA SEM DE LAVAAN:
  latentFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
  typeFormat <- formatter("span", style = style(color = "teal", font.weight = "bold"))
  obsFormat <- formatter("span", style = style(color = "red", font.weight = "bold"))
  pvalueFormat <- formatter("span",
                            style = x ~ style(color = ifelse(x <= 0.05, "green", "red")),
                            x ~ icontext(ifelse(x <= 0.05, "ok", "remove"),
                                         ifelse(x <= 0.05, paste("Si:", digits(x,3)), paste("No:", digits(x,3))))
                            )
  ciLFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFormat <- formatter("span",x~ style(digits(x,3)))
  # ciUFmt <- x ~ round(x, digits=2)
  # Se filtran los elementos por medio de la lista de nodos seleccionados en el grafo:
  # IMPORTANTE: Validar el caso de que trae los datos NO estandarizados (hipotSEMFit) para su validación:
  param_data <- hipotSEMFit() %>%
                     filter(lhs %in% input$grafoHipotSEMOut_selectedNodes) %>%
                     transmute(desde = lhs,
                        tipo = dplyr::case_when(
                          op == "=~" ~ "carga-factor",
                          op == "~"  ~ "regresi\u00F3n",
                          op == "~~" ~ "correl./varianza",
                          op == "~1" ~ "intercepto",
                          TRUE ~ NA_character_),
                      hacia = rhs, estimado = est,
                      ic.inferior = ci.lower, ic.superior = ci.upper,
                      error = se, valor_p = pvalue, valor_z = z)
  #
  formattable(param_data, list(
      desde = latentFormat, tipo = typeFormat, hacia = obsFormat,
      area(col = c(estimado)) ~ normalize_bar("lightblue", 0.2),
      ic.inferior = ciLFormat,
      ic.superior = ciUFormat,
      area(col = c(error)) ~ proportion_bar("pink"),
      valor_p = pvalueFormat
  ))
})
#
output$tablaHipotesisParamsOut <- renderFormattable({
  # ESPECIFICACIONES DE FORMATO Y PRESENTACION PARA LA TABLA SEM DE LAVAAN:
  latentFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
  typeFormat <- formatter("span", style = style(color = "teal", font.weight = "bold"))
  obsFormat <- formatter("span", style = style(color = "red", font.weight = "bold"))
  pvalueFormat <- formatter("span",
                            style = x ~ style(color = ifelse(x <= 0.05, "green", "red")),
                            x ~ icontext(ifelse(x <= 0.05, "ok", "remove"),
                                         ifelse(x <= 0.05, paste("Si:", digits(x,3)), paste("No:", digits(x,3))))
                            )
  ciLFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFormat <- formatter("span",x~ style(digits(x,3)))
  #pValFmt <- x ~ round(x, digits=3)
  # Se filtra la tabla solo por un elemento seleccionado en el grafo:
  formattable(getParamEstimatesByName(hipotSEMFit(), input$grafoHipotSEMOut_selected),
    list(
      desde = latentFormat, tipo = typeFormat, hacia = obsFormat,
      area(col = c(estimado)) ~ normalize_bar("lightblue", 0.2),
      ic.inferior = ciLFormat,
      ic.superior = ciUFormat,
      area(col = c(error)) ~ proportion_bar("pink"),
      valor_p = pvalueFormat
  ))
})
# IMPORTANTE: Validar si usar siempre estandarizado, se deden ajustar las ecuaciones.
# En estandarizado el valor estimado de las cargas es: est.std (de lo contrario: est)
output$ecuacionFactHipoTxtOut <- renderUI({
  req(input$grafoHipotSEMOut_selected) # verifica que tenga informacion...
  #
  varX <- input$grafoHipotSEMOut_selected # Nodo seleccionado para presentar ecuaciones...
  datosBase <-(hipotSEMFit() %>% # Se ejecuta filtro por nodo seleccionado:
               dplyr::filter(rhs == varX, op %in% c("=~","~~"))
              )[c("lhs", "op", "est", "se", "z", "pvalue")] # se seleccionan columnas...
  #
  # El intercepto debe ser consultado de forma individual con fitros difentes al base:
  varInt <-(hipotSEMFit() %>% dplyr::filter(lhs == varX, op == "~1"))[c("est")] # intercepto
  #
  varFac <-(datosBase %>% dplyr::filter(op == "=~")) # Factores
  varcor <-(datosBase %>% dplyr::filter(lhs == varX, op == "~~"))  # Varianza / Correlacion
  #
  ## ECUACION DE CARGA DE FACTOR PARA LA VAR OBSERVADA:
  ecuFac <- paste0(varX, " = (", round(varInt$est, 3), ") + ") # intercepto en ecuFac!
  if(length(varFac$lhs) > 0) { # Forma la ecuacion del Factores formando las observadas
    for(i in 1:length(varFac$lhs)){
      ecuFac <- paste0(ecuFac , "(", round(varFac$est[i], 3), ")*", varFac$lhs[i])
      if(i < length(varFac$lhs)) {
         ecuFac <- paste0(ecuFac , " + ")
      }
    }
    ecuFac <- paste0(ecuFac, " + var(", round(varcor$est, 3), ")") # var/cor en ecuFac!
  } else {
    ecuFac <- "NO Disponible para Var. Latentes."
  }
  HTML(paste(tags$b("Ecuaci\u00F3n Var. Observada:"), ecuFac, sep="<br/>"))
})
# IMPORTANTE: Validar si usar siempre estandarizado, se deden ajustar las ecuaciones.
# En estandarizado el valor estimado de las cargas es: est.std (de lo contrario: est)
output$ecuacionEstrHipoTxtOut <- renderUI({  # antes: renderText(..)
  req(input$grafoHipotSEMOut_selected) # verifica que tenga informacion...
  #
  varX <- input$grafoHipotSEMOut_selected # Nodo seleccionado para presentar ecuaciones...
  datosBase <- (hipotSEMFit() %>% # Se ejecuta filtro por nodo seleccionado:
                 dplyr::filter(lhs == varX, op %in% c("=~","~","~1"))
               )[c("rhs", "op", "est", "se", "z", "pvalue")] # se seleccionan columnas...
  #
  varObs <-(datosBase %>% dplyr::filter(op == "=~")) # Var. Observadas
  varLat <-(datosBase %>% dplyr::filter(op == "~"))  # latentes (regresion)
  varInt <-(datosBase %>% dplyr::filter(op == "~1")) # intercepto (es prueba, en este caso siempre es 0)
  #
  ecuFac <- paste0(varX, " =~ (", round(varInt$est, 3), ") + ") # intercepto en ecuFac!
  if(length(varObs$rhs) > 0) {  # Forma la ecuacion del Factor reflejando sobre las observadas
    for(i in 1:length(varObs$rhs)){
      ecuFac <- paste0(ecuFac, "(", round(varObs$est[i], 3), ")*", varObs$rhs[i])
      if(i < length(varObs$rhs)) {
        ecuFac <- paste0(ecuFac, " + ")
      }
    }
  } else {
    ecuFac <- "NO Disponible para Var. Observadas."
  }
  #
  ecuLat <- paste0(varX, " ~ ")
  if(length(varLat$rhs) > 0) {  # Forma la ecuacion de Constructo formado por regresion de latentes exo
    for(i in 1:length(varLat$rhs)){
      ecuLat <- paste0(ecuLat, "(", round(varLat$est[i], 3), ")*", varLat$rhs[i])
      if(i < length(varLat$rhs)) {
        ecuLat <- paste0(ecuLat, " + ")
      }
    }
  } else {
    ecuLat <- "NO Disponible."
  }
  #
  HTML(paste(tags$b("Ecuaci\u00F3n Latente Ex\u00F3gena (FACTOR):"), ecuFac, "----",
             tags$b("Ecuaci\u00F3n Latente End\u00F3gena (CONSTRUCTO):"), ecuLat, sep = "<br/>")
       ) # antes: sep = "\n"
  #
})
#
output$convenNodosHipoRegTablaOut <- renderFormattable({
  convencionesHipotesis()
})
#
observeEvent(input$convenNodosHipoRegSwitch, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  shinyjs::toggle(id="convenNodosHipoRegDIV", anim = TRUE, animType = "fade")
})
#
output$convenNodosHipoFacTablaOut <- renderFormattable({
  convencionesHipotesis()
})
#
observeEvent(input$convenNodosHipoFacSwitch, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  shinyjs::toggle(id="convenNodosHipoFacDIV", anim = TRUE, animType = "fade")
})
#
#
convencionesHipotesis <- function() {
   varFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
   descFormat <- formatter("span", style = style(color = "blue", font.weight = "bold"))
   nodesLabels <- datasetLabelsInput()
   #
   param_data <- hipotSEMFit() %>% filter(lhs %in% input$grafoHipotSEMOut_selectedNodes)
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
}
#
