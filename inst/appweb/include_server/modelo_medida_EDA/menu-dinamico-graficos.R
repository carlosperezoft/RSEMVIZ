# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 14/08/2019 07:50:28 p.m.
#
# Funcionalidad para el manejo de la preguntas de analisis y
# presentar las opciones de menu esperadas.
# NOTA: navbarPage usa el inputId, para el target se maneja el menuName en un navbarMenu y el
# title en un tabPanel.
#
observeEvent(input$preguntasBaseSel, {
  if(input$preguntasBaseSel == 1) {
      showTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      hideTab(inputId = "medidaDescMenu", target = "correlaMenu")
      hideTab(inputId = "medidaDescMenu", target = "barrasMenu")
      hideTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      hideTab(inputId = "medidaDescMenu", target = "redesMenu")
      hideTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      hideTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
  else if(input$preguntasBaseSel == 2) {
      hideTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      showTab(inputId = "medidaDescMenu", target = "correlaMenu")
      hideTab(inputId = "medidaDescMenu", target = "barrasMenu")
      hideTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      hideTab(inputId = "medidaDescMenu", target = "redesMenu")
      hideTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      hideTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
  else if(input$preguntasBaseSel == 3) {
      hideTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      hideTab(inputId = "medidaDescMenu", target = "correlaMenu")
      showTab(inputId = "medidaDescMenu", target = "barrasMenu")
      hideTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      hideTab(inputId = "medidaDescMenu", target = "redesMenu")
      hideTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      hideTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
  else if(input$preguntasBaseSel == 4) {
      hideTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      hideTab(inputId = "medidaDescMenu", target = "correlaMenu")
      hideTab(inputId = "medidaDescMenu", target = "barrasMenu")
      showTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      hideTab(inputId = "medidaDescMenu", target = "redesMenu")
      hideTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      hideTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
  else if(input$preguntasBaseSel == 5) {
      hideTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      hideTab(inputId = "medidaDescMenu", target = "correlaMenu")
      hideTab(inputId = "medidaDescMenu", target = "barrasMenu")
      hideTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      showTab(inputId = "medidaDescMenu", target = "redesMenu")
      hideTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      hideTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
  else if(input$preguntasBaseSel == 6) {
      hideTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      hideTab(inputId = "medidaDescMenu", target = "correlaMenu")
      hideTab(inputId = "medidaDescMenu", target = "barrasMenu")
      hideTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      hideTab(inputId = "medidaDescMenu", target = "redesMenu")
      showTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      hideTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
  else if(input$preguntasBaseSel == 7) {
      hideTab(inputId = "medidaDescMenu", target = "distribMenu") # navbarMenu
      hideTab(inputId = "medidaDescMenu", target = "correlaMenu")
      hideTab(inputId = "medidaDescMenu", target = "barrasMenu")
      hideTab(inputId = "medidaDescMenu", target = "jerarqMenu")
      hideTab(inputId = "medidaDescMenu", target = "redesMenu")
      hideTab(inputId = "medidaDescMenu", target = "evolucionMenu")
      showTab(inputId = "medidaDescMenu", target = "circularMenu")
  }
})
#
