# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 11/09/2018 13:55:28 p. m.
#
casoEstudioData <- reactive({
  switch(input$casoEstudioSelect,
     "Grupos_INVEST" = DATOS_GRUPOS_INVEST_UdeA[c("profes", "est", "salario")],
     "Universidades_Estatales" = DATOS_GRUPOS_INVEST_UdeA[c("especie", "lineas", "jovinpre")]
     )
})

casoEstudioModel <- reactive({
  switch(input$casoEstudioSelect,
     "Grupos_INVEST" = grupos_invest_udea_model,
     "Universidades_Estatales" = grupos_invest_udea_model
  )
})

observe({
  if((input$usarCasoEstudioChk == TRUE) &&
     (input$casoEstudioSelect  != "Seleccionar...")) {
    updateTextInput(session, "modeloSEMTxt", value = casoEstudioModel())
  } else {
    updateTextInput(session, "modeloSEMTxt", value = "")
  }
})

# Generate a summary of the dataset ----
output$resumenCasoEstudoTxtOut <- renderPrint({
  dataset <- casoEstudioData()
  summary(dataset)
})

output$detalleCasoEstudioHTMLOut <- renderPrint({
  switch(input$casoEstudioSelect,
     "Grupos_INVEST" = includeMarkdown("help_files/controls_help.md"),
     "Universidades_Estatales" = includeMarkdown("help_files/plot_help.md")
  )
})
