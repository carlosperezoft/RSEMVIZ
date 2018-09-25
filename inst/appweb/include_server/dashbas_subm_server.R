# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 24/09/2018 12:20:28 p. m.
#
### elementos de bondad de ajuste:
output$statChi2Out <- renderValueBox({
  chi2Value <- fitMeasures(semFitLocal(), "chisq")
  gradosLib <- fitMeasures(semFitLocal(), "df")
  #
  razonChi2 <- chi2Value / gradosLib
  if(razonChi2 <= 3)  {
    subTChi2 <- "Aceptable"
    colorChi2 <- "green"
  } else if(razonChi2 <= 5) {
    subTChi2 <- "Bajo"
    colorChi2 <- "orange"
  } else {
    subTChi2 <- "NO Aceptable"
    colorChi2 <- "red"
  }
  #
  valueBox(
    value = sprintf("%.2f", chi2Value),
    subtitle = paste("Ajuste Chi2:", subTChi2),
    icon = icon("superscript"),
    color = colorChi2
  )
})
#
output$pValueChi2Out <- renderInfoBox({
  pValue <- fitMeasures(semFitLocal(), "pvalue")
  # siginificacion con alfa mayor a 0.05, rechaza H0:
  # The null hypothesis is -- the postulated model holds in the population, i.e.,
  # the implied (sample)covariance matrix = population covariance matrix.
  # ** The researcher hopes NOT to reject the null hypothesis,
  # in contrast to traditional statistical procedures.
  # -
  if(pValue > 0.05)  {
    subT_pVal <- "Significativo"
    icon_pVal <- "thumbs-up"
    color_pVal <- "green"
  } else {
    subT_pVal <- "NO Significativo"
    icon_pVal <- "thumbs-down"
    color_pVal <- "red"
  }
  valueBox(
    value = sprintf("%.3f", pValue),
    subtitle = paste("P-Value:", subT_pVal),
    icon = shiny::icon(icon_pVal),
    color = color_pVal
  )
})
#
output$gradosLibertadOut <- renderInfoBox({
  infoBox(
    "(GL) Grados de Libertad", fitMeasures(semFitLocal(), "df"),
    icon = icon("plus-square"),
    color = "light-blue", fill = TRUE
  )
})
#
output$statRazonChi2Out <- renderValueBox({
  chi2Value <- fitMeasures(semFitLocal(), "chisq")
  gradosLib <- fitMeasures(semFitLocal(), "df")
  #
  razonChi2 <- chi2Value / gradosLib
  if(razonChi2 <= 3)  {
    subTChi2 <- "Aceptable"
    iconChi2 <- "thumbs-up"
    colorChi2 <- "green"
  } else if(razonChi2 <= 5) {
    subTChi2 <- "Bajo"
    iconChi2 <- "thumbs-up"
    colorChi2 <- "orange"
  } else {
    subTChi2 <- "NO Aceptable"
    iconChi2 <- "thumbs-down"
    colorChi2 <- "red"
  }
  #
  valueBox(
    value = sprintf("%.2f", razonChi2),
    subtitle = paste("Raz\u00F3n (Chi2 / GL):", subTChi2),
    icon = shiny::icon(iconChi2),
    color = colorChi2
  )
})
#  INICIO ELEMENTOS FLEX_GAUGE, AM_GAUGE, AM_BULLET:
output$gfiBoxOut <- renderUI({
  item_val <- fitMeasures(semFitLocal(), "gfi")
  #
  if(item_val >= 0.90)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val >= 0.70) {
    item_subT <- "Ajuste Medio"
    item_icon <- "thumbs-up"
    item_color <- "warning"
  } else {
    item_subT <- "NO Aceptable"
    item_icon <- "thumbs-down"
    item_color <- "danger"
  }
  #
  req(input$grafPorcentRadio) # Valida que este activo
  #
  graficoUI <- NULL
  if(input$grafPorcentRadio == "Gauge") {
    graficoUI <- flexdashboard::gaugeOutput("gfiGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("gfiAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("gfiBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "GFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI,
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("\u00CDndice de Bondad de Ajuste (GFI)"), br(),
      awesomeCheckbox(inputId = "gfiHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "gfiHelpTxt",
                 paste("Goodness of Fit Index (GFI): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    )
  )
})
#
shinyjs::onclick("gfiHelpSwitch", shinyjs::toggle(id = "gfiHelpTxt", anim = TRUE, animType = "fade"))
#
output$tipoGraficoOut  <- renderUI({
  choicesList = NULL
  if(input$indPorcentSwitch) { # Opciones de Grafico en Porcentaje
    choicesList = c("Gauge",  "Angular-Gauge", "Bullet")
  } else {
    choicesList = c("Gauge", "Bullet")
  }
  awesomeRadio(inputId = "grafPorcentRadio", label = "Tipos de Gr\u00E1fico",
     inline = TRUE, checkbox = TRUE, choices = choicesList, selected = "Gauge"
  )
})
#
output$gfiGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*fitMeasures(semFitLocal(), "gfi")),
       min = 0, max = 100, symbol = '%', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(90, 100), warning = c(70,89), danger = c(0, 69),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", fitMeasures(semFitLocal(), "gfi")),
       min = 0, max = 1,  symbol = '', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(0.90, 1), warning = c(0.70,0.89), danger = c(0, 0.69),
                                   colors = c("success", "warning", "danger")))

  }
})
#
output$gfiAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 40, 60), end = c(40, 60, 100) ,
                      color = c("#00CC00", "#ffac29", "#ea3838"), stringsAsFactors = FALSE)

  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*fitMeasures(semFitLocal(), "gfi"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "GFI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$gfiBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*fitMeasures(semFitLocal(), "gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 90, label = "GFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", fitMeasures(semFitLocal(), "gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.8, label = "GFI")
  }
})

#######
# Lista de indicadores tipo Gauge:
output$RMSEAIdx <- flexdashboard::renderGauge({
  semLocal <- semFitLocal()
  flexdashboard::gauge(value = sprintf("%.1f", 100*fitMeasures(semLocal, "gfi")),
                       min = 0, max = 100, symbol = '%', label = paste("GFI"),
                       flexdashboard::gaugeSectors(success = c(90, 100), warning = c(41,89), danger = c(0, 40),
                                                   colors = c("success", "warning", "danger")))
})
output$RMSEApvalue <- flexdashboard::renderGauge({
  semLocal <- semFitLocal()
  flexdashboard::gauge(value = sprintf("%.3f", fitMeasures(semLocal, "nfi")), min = 0, max = 1,
                       label = paste("NFI"), flexdashboard::gaugeSectors(
                         danger = c(0, 0.40), warning = c(0.41,0.89), success = c(0.90, 1),
                         colors = c("danger", "warning", "success")
                       ))
})

bandsExt <- data.frame(start = c(0, 40, 60), end = c(40, 60, 100) , #, c(0, 0.40, 0.60), end = c(0.40, 0.60, 1)
                    color = c("#00CC00", "#ffac29", "#ea3838"),
                    stringsAsFactors = FALSE)
#
output$gaugeAMCOut1 <- renderAmCharts({
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*fitMeasures(semFitLocal(), "tli"))),
                 bands = bandsExt, text = "%", textSize = 10,
                 main = "TLI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
output$gaugeAMCOut2 <- renderAmCharts({
  amBullet(value = as.numeric(sprintf("%.3f", 100*fitMeasures(semFitLocal(), "tli"))),
           val_color = "green", limit_color = "red",
           min = 0, max = 100, limit = 90, label = "TLI")
})
output$gaugeAMCOut3 <- renderAmCharts({
  amBullet(value = as.numeric(sprintf("%.3f", fitMeasures(semFitLocal(), "pgfi"))),
           val_color = "red", limit_color = "black",
           min = 0, max = 1, limit = 0.8, label = "PGFI")
})

#######

