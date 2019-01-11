# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 11/09/2018 13:55:28 p. m.
#
casoEstudioData <- reactive({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = poli_dem_data, # SET de datos de Caso SEM en lavaan
     "Grupos_INVESTIGACION" = DATOS_GRUPOS_INVEST_UdeA,
     "Universidades_Estatales" = DATOS_GRUPOS_INVEST_UdeA
     )
})

casoEstudioLabels <- reactive({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = poli_dem_labels,
     "Grupos_INVESTIGACION" = grupos_invest_udea_model,
     "Universidades_Estatales" = grupos_invest_udea_model
  )
})

casoEstudioModel <- reactive({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = political_democracy_model,
     "Grupos_INVESTIGACION" = grupos_invest_udea_model,
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
  dataset <- casoEstudioData() # [c("profes", "est", "salario")]
  summary(dataset)
})

output$detalleCasoEstudioHTMLOut <- renderPrint({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = includeMarkdown("help_files/plot_help.md"),
     "Grupos_INVESTIGACION" = includeMarkdown("help_files/controls_help.md"),
     "Universidades_Estatales" = includeMarkdown("help_files/plot_help.md")
  )
})
