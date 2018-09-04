# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
#
datasetInput <- reactive({
  # input$fileSEMData es nulo incialmente. Por lo cual
  # es necesario usar el este bloque, luego de la seleccion
  # inicial del usuario los datos seran presentados adecuadamente.
  #
  req(input$fileSEMData)

  fileSEMdf <- read.csv(input$fileSEMData$datapath,
                 header = input$fileSEMheader,
                 sep = input$fileSEMsep,
                 quote = input$fileSEMquote)

  if(input$fileSEMdisp == "head") {
    return(head(fileSEMdf))
  }
  else {
    return(fileSEMdf)
  }

})

# Asignacion del SET de DATOS a la tabla dinamica:
output$semDataDTOut = renderDT({
   datasetInput()
}, options = list(scrollX = TRUE))

