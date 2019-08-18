# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
# - actualizacion para adicion del set de datos de las etiquetas del modelo SEM
# 17/08/2019 11:00 a.m.
#
# Funciones para el manejo de los datos de las variables explicativas del modelo SEM:
datasetInput <- reactive({# Se usa "reactive" para reprocesar la "funcion" que algun "input" cambie...
  fileSEMdf <- NULL
  if((input$usarCasoEstudioChk == TRUE) &&
     (input$casoEstudioSelect  != "Seleccionar...")) {
    fileSEMdf <- casoEstudioData()
  } else {
    # input$fileSEMData es nulo incialmente. Por lo cual
    # es necesario usar el este bloque, luego de la seleccion
    # inicial del usuario los datos seran presentados adecuadamente.
    #
    req(input$fileSEMData)

    fileSEMdf <- read.csv(input$fileSEMData$datapath,
                   header = input$fileSEMheader,
                   sep = input$fileSEMsep,
                   quote = input$fileSEMquote)
  }
  if(input$fileSEMdisp == "head") {
    return(head(fileSEMdf))
  }
  else {
    return(fileSEMdf)
  }

})
#
# Asignacion del SET de DATOS a la tabla dinamica:
# NOTA: se usa el atributo scrollX para activar la barra horizontal.
output$semDataDTOut <- renderDT({
   datasetInput()
}, options = list(scrollX = TRUE))
#
# Funciones para el manejo de las etiquetas de las variables del modelo SEM:
datasetLabelsInput <- reactive({# Se usa "reactive" para reprocesar la "funcion" que algun "input" cambie...
  dfFileLabels <- NULL
  if((input$usarCasoEstudioChk == TRUE) &&
     (input$casoEstudioSelect  != "Seleccionar...")) {
    dfFileLabels <- casoEstudioLabels()
  } else {
    # input$fileSEMData es nulo incialmente. Por lo cual
    # es necesario usar el este bloque, luego de la seleccion
    # inicial del usuario los datos seran presentados adecuadamente.
    #
    req(input$fileSEMDataLabels)

    dfFileLabels <- read.csv(input$fileSEMDataLabels$datapath,
                   header = input$fileSEMheaderLabels,
                   sep = input$fileSEMsepLabels,
                   quote = input$fileSEMquoteLabels)
  }
  if(input$fileSEMdispLabels == "head") {
    return(head(dfFileLabels))
  }
  else {
    return(dfFileLabels)
  }

})
#
# Asignacion del SET de DATOS de LABELS a la tabla dinamica:
# NOTA: se usa el atributo scrollX para activar la barra horizontal.
output$semDataLabelsDTOut <- renderDT({
   datasetLabelsInput()
}, options = list(scrollX = TRUE))
#

