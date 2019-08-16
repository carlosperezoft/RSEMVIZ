# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 14/08/2019 07:50:28 p.m.
#
# Funcionalidad para el manejo de la preguntas de analisis y
# presentar las opciones de menu esperadas.
# NOTA: navbarPage usa el inputId, para el target se maneja el menuName en un navbarMenu y el
# title en un tabPanel.
#
observeEvent(input$pregEstructuralSel, {
  if(input$pregEstructuralSel == 1) {
      showTab(inputId = "estructRegMenu", target = "estimaMenu") # navbarMenu
      hideTab(inputId = "estructRegMenu", target = "predicMenu")
      hideTab(inputId = "estructRegMenu", target = "mediacMenu")
  }
  else if(input$pregEstructuralSel == 2) {
      hideTab(inputId = "estructRegMenu", target = "estimaMenu") # navbarMenu
      showTab(inputId = "estructRegMenu", target = "predicMenu")
      hideTab(inputId = "estructRegMenu", target = "mediacMenu")
  }
  else if(input$pregEstructuralSel == 3) {
      hideTab(inputId = "estructRegMenu", target = "estimaMenu") # navbarMenu
      hideTab(inputId = "estructRegMenu", target = "predicMenu")
      showTab(inputId = "estructRegMenu", target = "mediacMenu")
  }
})
#
