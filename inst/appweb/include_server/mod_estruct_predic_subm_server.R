# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 04/11/2018 1:55:31 p. m.
#
output$grafoModeloEstructuralOut <- renderVisNetwork({
   getGrafoModelSEMBase()
})
#
observeEvent(input$selectedNodesEstructuralBtn, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  visNetworkProxy("grafoModeloEstructuralOut") %>% visGetSelectedNodes() # actualiza contenedores...
})
#
output$estructuralSelectedNodesTxtOut <- renderUI({
  req(input$grafoModeloEstructuralOut_selectedNodes) # verifica que tenga informacion...
  #
  nodesListTxt <- paste(input$grafoModeloEstructuralOut_selectedNodes, collapse = ",")
  # NOTA: La info para HTML(..) debe ser resultado de un paste(..):
  HTML(paste(tags$b("Variables SEM:"), nodesListTxt))
})
#
# INVOCACION EXTERNA:
# shinyjs::onclick("modeloLinealPanelToggle", shinyjs::toggle(id = "modeloLinealTabSet", anim = TRUE))
# NOTA: Se ha usado "observeEvent" para que SOLO al hacer clic en el "materialSwitch" se realice el "toggle"
observeEvent(input$modeloLinealPanelToggle, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  shinyjs::toggle(id = "modeloLinealTabSet", anim = TRUE)
})
#
# Graficos para el menu de Distribucion en el Modelo de Medicion:
source('include_server/modelo_estructural_EDA/estimacion_graficos_server.R', local=TRUE)
#
