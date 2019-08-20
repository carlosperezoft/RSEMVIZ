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
    # std.lv: activa estandarizacion para las variables latentes.
    # std.ov: activa estandarizacion para las variables observadas.
    #         Esta en falso al asumir que los datos tienen alguna transformacion valida.
    # meanstructure: activa la estimacion de los "interceptos" para cada ecuacion de regresion asociada.
    # * En estimadorList: Se debe usar un entero como indice.El input$tipoEstimacionSEM tiene valor tipo String.
    #
    lavaanFit <- lavaan::sem(model = input$modeloSEMTxt, data = datasetInput(), mimic = "lavaan",
                             std.ov = FALSE, std.lv=TRUE, meanstructure=TRUE, likelihood = "wishart",
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
#
output$modeloSEMLavaanTxtOut <- renderPrint({
  summary(semFitLocal(), fit.measures=TRUE, standardized = input$modSEMStandChk)
})
#
semModelScoreData <- reactive({
  # Metodo de Lavaan para estimar los "score" de cada factor del modelo de SEM:
  # ov: Estimado de los Score de Var. Observadas.
  # lv: Estimado de los Score de Var. Latentes.
  estimated_data <- data.frame(lavPredict(semFitLocal(), type = "ov", method = "regression"),
                               lavPredict(semFitLocal(), type = "lv", method = "regression"))
  # Se adiciona explicitamente la columna el numero de fila como "row_id",
  # Esto para el uso de row_id como key en las operaciones de "melt" de los datos:
  estimated_data$row_id <- seq(1:(nrow(estimated_data)))
  return(estimated_data)
})
#
#
# Asignacion del SET de DATOS a la tabla dinamica:
# NOTA: se usa el atributo scrollX para activar la barra horizontal.
output$semScoreDataDTOut <- renderDT({
  semModelScoreData()
}, options = list(scrollX = TRUE))
#
# PENDIENTE: AJUSTAR LOS INDICES concretos por tipo de ajuste: 07-nov-2018
semModelMedidasAjusteData <- reactive({
  indlist <- lavaan::fitMeasures(semFitLocal(), c("chisq", "df", "pvalue", "gfi", "nfi", "tli", "pgfi", "rmsea",
                                "srmr", "cfi", "agfi", "mfi", "pnfi", "nnfi", "aic", "bic"))
  indDFrame <- data.frame(name=c("chisq", "df", "pvalue", "gfi", "nfi", "tli", "pgfi", "rmsea",
                                 "srmr", "cfi","agfi", "mfi", "pnfi", "nnfi", "aic", "bic"),
                    value=c(indlist[["chisq"]], indlist[["df"]], indlist[["pvalue"]], indlist[["gfi"]],
                            indlist[["nfi"]], indlist[["tli"]], indlist[["pgfi"]], indlist[["rmsea"]],
                            indlist[["srmr"]], indlist[["cfi"]], indlist[["agfi"]], indlist[["mfi"]],
                            indlist[["pnfi"]], indlist[["nnfi"]], indlist[["aic"]], indlist[["bic"]]),
                    is_indice=c(F,F,F,T,T,T,T,F,F,T,T,F,T,T,F,F)
               ) # NOTA: se toman como indices: c("gfi", "nfi", "tli", "pgfi", "cfi", agfi", "pnfi", "nnfi")
  #
  # Data Frame con las medidas (indices) de bondad de ajuste del modelo:
  return(indDFrame)
})
# Funcion para obtener el valor puntual de una
getMedidaAjusteValue <- function(indiceName = "") {
  semModelMedidasAjusteData() %>% filter(name == indiceName) %>% select(value)
}
#

