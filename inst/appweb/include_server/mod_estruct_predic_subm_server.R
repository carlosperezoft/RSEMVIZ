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
  shinyjs::toggle(id = "modeloLinealTabSet", anim = TRUE, animType = "slide")
})
#
output$convenModelEstructTablaOut <- renderFormattable({
   varFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
   descFormat <- formatter("span", style = style(color = "blue", font.weight = "bold"))
   nodesLabels <- datasetLabelsInput()
   #
   #  Multiples condiciones en el filtro equivalen a un AND,
   #  por tanto se debe usar el operador: & (and) u | (or):
   #  NOTA: Se filtra por 'grafoModeloEstructuralOut_selectedNodes' ya que contiene la lista de
   #  los nombres de los nodos seleccionados.
   selected_labels <- nodesLabels %>%
                      filter(variable %in% input$grafoModeloEstructuralOut_selectedNodes) %>% arrange(variable)
   #
   formattable(selected_labels, list(variable = varFormat, desc = descFormat))
})
#
observeEvent(input$convenModelEstructSwitch, ignoreNULL = TRUE, ignoreInit = TRUE,
{
  shinyjs::toggle(id = "convenModelEstructDIV", anim = TRUE, animType = "slide")
})
#
# Presentacion de menu grafico de forma dinamica, segun la pregunta de analisis seleccionada:
source('include_server/modelo_estructural_EDA/menu-dinamico-graficos.R', local=TRUE)
#
# Graficos para el menu de Estimacion en el Modelo Estructural:
source('include_server/modelo_estructural_EDA/estimacion_graficos_server.R', local=TRUE)
#
# Graficos para el menu de Mediacion en el Modelo Estructural:
source('include_server/modelo_estructural_EDA/mediacion_graficos_server.R', local=TRUE)
#
