# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
#
observeEvent(input$runSEMBtn, {
  req(input$modeloSEMTxt)
  semLocal <- lavaan::sem(input$modeloSEMTxt, data=PoliticalDemocracy)
  output$modeloSEMLavaanTxtOut <- renderPrint({ summary(semLocal, fit.measures=TRUE, standardized = TRUE)})
})
