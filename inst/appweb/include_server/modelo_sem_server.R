# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
#
semFitLocal <- eventReactive(input$runSEMBtn, {
  # Funcion que permite presentar: input$modeloSEMTxt
  # NOTA: finaliza al ejecucion en este punto en caso de fallar la validacion.
  shiny::validate(
    shiny::need(input$modeloSEMTxt != "", "<-- NO se ha ingresado el Modelo SEM ...")
  )
  # Funcion que verifica la existencia o que tenga datos el: input$modeloSEMTxt
  # NOTA: finaliza al ejecucion en este punto en caso de fallar la validacion.
  req(input$modeloSEMTxt)

  # Se inicializa el FIT en null para evitar quedar indefinido en caso de error.
  lavaanFit <- NULL
  tryCatch({
    # estimadorList: Define el vector de metodos de estimacion basicos en Lavaan:
    estimadorList <- c("ML","GLS","WLS", "ULS","DWLS")
    #
    # mimic: aplica para la presentacion de los resultados
    # * En estimadorList: Se debe usar un entero como indice.El input$tipoEstimacionSEM tiene valor tipo String.
    #
    lavaanFit <- lavaan::sem(model = input$modeloSEMTxt, data = datasetInput(), mimic = "lavaan",
                             estimator = estimadorList[as.integer(input$tipoEstimacionSEM)])
    },
    error = function(e) {
      print("NO fue posible estimar el MODELO SEM.* Favor verificar la sint\u00E1xis o los DATOS asociados. *")
      print(sprintf("[ERROR_INFO]: %s", e))
    },
    warning = function(e) {
      print("NO fue posible estimar el MODELO SEM.* Favor verificar la sint\u00E1xis o los DATOS asociados. *")
      print(sprintf("[WARNING_INFO]: %s", e))
    },
    finally = {
      print("* ESTIMACION DEL MODELO FINALIZADA *")
    }
  )
  return(lavaanFit)
})

output$modeloSEMLavaanTxtOut <- renderPrint({
  summary(semFitLocal(), fit.measures=TRUE, standardized = input$modSEMStandChk)
})
