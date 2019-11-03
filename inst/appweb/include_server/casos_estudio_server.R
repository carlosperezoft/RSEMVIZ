# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 11/09/2018 13:55:28 p. m.
#
casoEstudioData <- reactive({
  # El valor retornado es el SET de Datos:
  switch(input$casoEstudioSelect,
     "Political_Democracy" = poli_dem_data, # SET de datos de Caso SEM en lavaan
     "Grupos_INVESTIGACION" = DATOS_GRUPOS_INVEST_UdeA
     )
  #
})
#
casoEstudioLabels <- reactive({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = poli_dem_labels,
     "Grupos_INVESTIGACION" = GRUPOS_UdeA_VAR_Labels
  )
})
#
casoEstudioModel <- reactive({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = political_democracy_model,
     "Grupos_INVESTIGACION" = grupos_invest_udea_model
  )
})
#
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
  dataset <- casoEstudioData()[,-1] # Se evita la columna row_label
  summary(dataset)
})
#
output$detalleCasoEstudioHTMLOut <- renderPrint({
  switch(input$casoEstudioSelect,
     "Political_Democracy" = includeMarkdown("help_files/caso-poli-dem-help.md"),
     "Grupos_INVESTIGACION" = includeMarkdown("help_files/caso-grupos-invest-help.md")
  )
})
#
shinyjs::onclick("casosEstudioSwitch",
  if(input$casosEstudioSwitch) {
    shinyjs::hide(id = "casosEstudioTab", anim = TRUE, animType = "fade")
  } else {
    shinyjs::show(id = "casosEstudioTab", anim = TRUE, animType = "fade")
  }
)
#
