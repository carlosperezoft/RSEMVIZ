# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 24/09/2018 12:20:28 p. m.
#
### elementos de bondad de ajuste:
output$statChi2Out <- renderValueBox({
  chi2Value <- getMedidaAjusteValue("chisq")
  gradosLib <- getMedidaAjusteValue("df")
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
  shinydashboard::valueBox(
    value = sprintf("%.2f", chi2Value),
    subtitle = paste("Ajuste Chi2:", subTChi2),
    icon = icon("superscript"),
    color = colorChi2, width = NULL
  )
})
#
output$pValueChi2Out <- renderValueBox({
  pValue <- getMedidaAjusteValue("pvalue")
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
  shinydashboard::valueBox(
    value = sprintf("%.3f", pValue),
    subtitle = paste("P-Value:", subT_pVal),
    icon = shiny::icon(icon_pVal),
    color = color_pVal, width = NULL
  )
})
#
output$statRazonChi2Out <- renderValueBox({
  chi2Value <- getMedidaAjusteValue("chisq")
  gradosLib <- getMedidaAjusteValue("df")
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
  shinydashboard::valueBox(
    value = sprintf("%.2f", razonChi2),
    subtitle = paste("Raz\u00F3n (Chi2 / GL):", subTChi2),
    icon = shiny::icon(iconChi2),
    color = colorChi2, width = NULL
  )
})
#
output$gradosLibertadOut <- renderInfoBox({
  infoBox(
    "(GL) Grados de Libertad", getMedidaAjusteValue("df"),
    icon = icon("plus-square"),
    color = "light-blue", fill = TRUE
  )
})
# INICIO ELEMENTOS FLEX_GAUGE, AM_GAUGE, AM_BULLET:
output$gfiBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("gfi")
  #
  if(item_val >= 0.95)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val >= 0.75) {
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
                 paste("Goodness of Fit Index (GFI): Presenta el nivel de bondad de ajuste del modelo.",
                 "Un nivel por encima de 0.95 es muy recomendado (aceptable). Niveles no inferiores a 0.75 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    )
  )
})
#
shinyjs::onclick("gfiHelpSwitch", shinyjs::toggle(id = "gfiHelpTxt", anim = TRUE, animType = "fade"))
#
output$tipoGraficoOut <- renderUI({
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
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("gfi")),
       min = 0, max = 100, symbol = '%', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(95, 100), warning = c(75,95), danger = c(0, 75),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("gfi")),
       min = 0, max = 1,  symbol = '', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(0.95, 1), warning = c(0.75,0.95), danger = c(0, 0.75),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$gfiAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 75, 95), end = c(75, 95, 100),
                      #         "danger", "warning", "success"
                      color = c("#ea3838", "#ffac29", "#00CC00"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("gfi"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "GFI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$gfiBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 95, label = "GFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.95, label = "GFI")
  }
})
####### NUEVOS - FALTANTES
output$rmseaBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("rmsea")
  #
  if(item_val <= 0.05)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val <= 0.10) {
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
    graficoUI <- flexdashboard::gaugeOutput("rmseaGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("rmseaAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("rmseaBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "RMSEA: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, # Usa el amChartsOutput dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Aproximaci\u00F3n del Error de la Ra\u00EDz de la Media Cuadr\u00E1tica (RMSEA)"),
      awesomeCheckbox(inputId = "rmseaHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "rmseaHelpTxt",
                 paste("Root Mean Square Error of	Approximation (RMSEA): Aproximaci\u00F3n del error cuadr\u00E1tico medio.",
                 "Un nivel por debajo de 0.05 es muy recomendado (aceptable). Niveles inferiores a 0.10 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("rmseaHelpSwitch", shinyjs::toggle(id = "rmseaHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico:
#
output$rmseaGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("rmsea")),
       min = 0, max = 100, symbol = '%', label = paste("RMSEA"),
       flexdashboard::gaugeSectors(success = c(0, 5), warning = c(5,10), danger = c(10, 100),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("rmsea")),
       min = 0, max = 1,  symbol = '', label = paste("RMSEA"),
       flexdashboard::gaugeSectors(success = c(0, 0.05), warning = c(0.05,0.10), danger = c(0.10, 1),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$rmseaAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 5, 10), end = c(5, 10, 100),
                      #         "success", "warning", "danger"
                      color = c("#00CC00", "#ffac29", "#ea3838"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("rmsea"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "RMSEA", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$rmseaBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("rmsea"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 5, label = "RMSEA") # Error aceptable debajo del 5%
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("rmsea"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.05, label = "RMSEA")
  }
})
#
output$srmrBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("srmr")
  #
  if(item_val <= 0.08)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val <= 0.15) {
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
    graficoUI <- flexdashboard::gaugeOutput("srmrGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("srmrAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("srmrBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "SRMR: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, # amChartsOutput UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("(Estandarizada) Ra\u00EDz de la Media Cuadr\u00E1tica de los Residuales (SRMR)"),
      awesomeCheckbox(inputId = "srmrHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "srmrHelpTxt",
                 paste("(Standardized) Root Mean Square Residual (SRMR): Error medio cuadr\u00E1tico de los residuales.",
                 "Un nivel por debajo de 0.08 es muy recomendado (aceptable). Niveles inferiores a 0.15 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("srmrHelpSwitch", shinyjs::toggle(id = "srmrHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "srmrBoxOut"
output$srmrGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("srmr")),
       min = 0, max = 100, symbol = '%', label = paste("SRMR"),
       flexdashboard::gaugeSectors(success = c(0,8), warning = c(8,15), danger = c(15,100),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("srmr")),
       min = 0, max = 1,  symbol = '', label = paste("SRMR"),
       flexdashboard::gaugeSectors(success = c(0,0.08), warning = c(0.09,0.15), danger = c(0.16,1),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$srmrAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 8, 15), end = c(8, 15, 100),
                      color = c("#00CC00", "#ffac29", "#ea3838"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("srmr"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "SRMR", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$srmrBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("srmr"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 8, label = "SRMR") # Error aceptable debajo del 5%
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("srmr"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.08, label = "SRMR")
  }
})
#
output$cfiBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("cfi")
  #
  if(item_val >= 0.95)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val >= 0.75) {
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
    graficoUI <- flexdashboard::gaugeOutput("cfiGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("cfiAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("cfiBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "CFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, #  UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de Ajsute Comparativo (CFI)"),
      awesomeCheckbox(inputId = "cfiHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "cfiHelpTxt",
                 paste("Comparative	Fit	Index (CFI): Indice de ajuste comparativo.",
                 "Un nivel por encima de 0.95 es muy recomendado (aceptable). Niveles no inferiores a 0.75 son de ajuste medio.."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("cfiHelpSwitch", shinyjs::toggle(id = "cfiHelpTxt", anim = TRUE, animType = "fade"))
#
# UI dinamico: "cfiBoxOut"
output$cfiGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("cfi")),
       min = 0, max = 100, symbol = '%', label = paste("CFI"),
       flexdashboard::gaugeSectors(success = c(95, 100), warning = c(75,95), danger = c(0, 75),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("cfi")),
       min = 0, max = 1,  symbol = '', label = paste("CFI"),
       flexdashboard::gaugeSectors(success = c(0.95, 1), warning = c(0.75,0.95), danger = c(0, 0.75),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$cfiAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 75, 95), end = c(75, 95, 100),
                      color = c("#ea3838", "#ffac29", "#00CC00"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("cfi"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "CFI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$cfiBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("cfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 95, label = "CFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("cfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.95, label = "CFI")
  }
})
#
output$nfiBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("nfi")
  #
  if(item_val >= 0.95)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val >= 0.75) {
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
    graficoUI <- flexdashboard::gaugeOutput("nfiGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("nfiAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("nfiBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "NFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, # amChartsOutput UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de ajuste normalizado (NFI)"),
      awesomeCheckbox(inputId = "nfiHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "nfiHelpTxt",
                 paste("Normed Fit Index (NFI): Indice de ajuste normalizado.",
                 "Un nivel por encima de 0.95 es muy recomendado (aceptable). Niveles no inferiores a 0.75 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("nfiHelpSwitch", shinyjs::toggle(id = "nfiHelpTxt", anim = TRUE, animType = "fade"))
#
# UI dinamico: "nfiBoxOut"
#
output$nfiGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("nfi")),
       min = 0, max = 100, symbol = '%', label = paste("NFI"),
       flexdashboard::gaugeSectors(success = c(95, 100), warning = c(75,95), danger = c(0, 75),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("nfi")),
       min = 0, max = 1,  symbol = '', label = paste("NFI"),
       flexdashboard::gaugeSectors(success = c(0.95, 1), warning = c(0.75,0.95), danger = c(0, 0.75),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$nfiAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 75, 95), end = c(75, 95, 100),
                      color = c("#ea3838", "#ffac29", "#00CC00"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("nfi"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "NFI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$nfiBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("nfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 95, label = "NFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("nfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.95, label = "NFI")
  }
})
#
output$tliBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("tli")
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
    graficoUI <- flexdashboard::gaugeOutput("tliGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("tliAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("tliBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "TLI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, # UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de ajuste NO normalizado - Tucker Lewis (NNFI-TLI)"),
      awesomeCheckbox(inputId = "tliHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "tliHelpTxt",
                 paste("Non-normed Fit Index - Tucker-Lewis Index (NNFI-TLI): Indice Tucker-Lewis (Indice de ajuste no normalizado).",
                 "Un nivel por encima de 0.90 es muy recomendado (aceptable). Niveles no inferiores a 0.70 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("tliHelpSwitch", shinyjs::toggle(id = "tliHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "tliBoxOut"
#
output$tliGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("tli")),
       min = 0, max = 100, symbol = '%', label = paste("TLI"),
       flexdashboard::gaugeSectors(success = c(95, 100), warning = c(75,95), danger = c(0, 75),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("tli")),
       min = 0, max = 1,  symbol = '', label = paste("TLI"),
       flexdashboard::gaugeSectors(success = c(0.95, 1), warning = c(0.75,0.95), danger = c(0, 0.75),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$tliAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 75, 95), end = c(75, 95, 100),
                      color = c("#ea3838", "#ffac29", "#00CC00"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("tli"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "TLI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$tliBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("tli"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 95, label = "TLI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("tli"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.95, label = "TLI")
  }
})
#
output$agfiBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("agfi")
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
    graficoUI <- flexdashboard::gaugeOutput("agfiGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("agfiAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("agfiBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "AGFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, # UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de bondad de ajuste corregido (AGFI)"),
      awesomeCheckbox(inputId = "agfiHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "agfiHelpTxt",
                 paste("Adjusted Goodness-of-Fit Index (AGFI): Indice de Bondad de Ajuste ajustado.",
                 "Un nivel por encima de 0.90 es muy recomendado (aceptable). Niveles no inferiores a 0.70 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("agfiHelpSwitch", shinyjs::toggle(id = "agfiHelpTxt", anim = TRUE, animType = "fade"))
#
# UI dinamico: "agfiBoxOut"
output$agfiGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("agfi")),
       min = 0, max = 100, symbol = '%', label = paste("AGFI"),
       flexdashboard::gaugeSectors(success = c(90, 100), warning = c(70,90), danger = c(0, 70),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("agfi")),
       min = 0, max = 1,  symbol = '', label = paste("AGFI"),
       flexdashboard::gaugeSectors(success = c(0.90, 1), warning = c(0.70,0.90), danger = c(0, 0.70),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$agfiAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 70, 90), end = c(70, 90, 100),
                      color = c("#ea3838", "#ffac29", "#00CC00"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("agfi"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "AGFI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$agfiBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("agfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 90, label = "AGFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("agfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.90, label = "AGFI")
  }
})
#
output$gfiCmpBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("gfi")
  #
  if(item_val >= 0.95)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val >= 0.75) {
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
    graficoUI <- flexdashboard::gaugeOutput("gfiCmpGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Angular-Gauge") {
    graficoUI <- amChartsOutput("gfiCmpAngularGaugeOut", height = "150")
  } else if(input$grafPorcentRadio == "Bullet") {
    graficoUI <- amChartsOutput("gfiCmpBulletOut", height = "150")
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "GFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    graficoUI, # UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de bondad de ajuste (GFI)"),
      awesomeCheckbox(inputId = "gfiCmpHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "gfiCmpHelpTxt",
                 paste("Goodness-of-Fit Index (GFI): Indice de Bondad de Ajuste.",
                 "Un nivel por encima de 0.95 es muy recomendado (aceptable). Niveles no inferiores a 0.75 son de ajuste medio."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("gfiCmpHelpSwitch", shinyjs::toggle(id = "gfiCmpHelpTxt", anim = TRUE, animType = "fade"))
#
# UI dinamico: "gfiCmpOut"
output$gfiCmpGaugeOut <- flexdashboard::renderGauge({
  if(input$indPorcentSwitch) { # Gauge en Porcentaje
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("gfi")),
       min = 0, max = 100, symbol = '%', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(95, 100), warning = c(75,95), danger = c(0, 75),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("gfi")),
       min = 0, max = 1,  symbol = '', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(0.95, 1), warning = c(0.75,0.95), danger = c(0, 0.75),
                                   colors = c("success", "warning", "danger")))
  }
})
#
output$gfiCmpAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 75, 95), end = c(75, 95, 100),
                      #         "danger", "warning", "success"
                      color = c("#ea3838", "#ffac29", "#00CC00"), stringsAsFactors = FALSE)
  #
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*getMedidaAjusteValue("gfi"))),
                 bands = bands, text = "%", textSize = 10,
                 main = "GFI", mainColor = "#68838B", mainSize = 16,
                 creditsPosition = "bottom-right")
})
#
output$gfiCmpBulletOut <- renderAmCharts({
  if(input$indPorcentSwitch) { # Bullet en Porcentaje
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 95, label = "GFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.95, label = "GFI")
  }
})
#
output$pgfiBoxOut <- renderValueBox({
  item_val <- getMedidaAjusteValue("pgfi")
  #
  if((item_val >= 0.50) && (item_val <= 0.70))  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "green"
  } else {
    item_subT <- "NO Aceptable"
    item_icon <- "thumbs-down"
    item_color <- "red"
  }
  #
  shinydashboard::valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Indice de bondad de ajuste de parsimonia (PGFI):", item_subT),
    icon = icon(item_icon),
    color = item_color, width = NULL
  )
})
#
output$pnfiBoxOut <- renderValueBox({
  item_val <- getMedidaAjusteValue("pnfi")
  #
  if(item_val >= 0.90)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "green"
  } else if(item_val >= 0.60) {
    item_subT <- "Ajuste Medio"
    item_icon <- "thumbs-up"
    item_color <- "orange"
  } else {
    item_subT <- "NO Aceptable"
    item_icon <- "thumbs-down"
    item_color <- "red"
  }
  #
  shinydashboard::valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Indice normalizado de ajuste de parsimonia (PNFI):", item_subT),
    icon = icon(item_icon),
    color = item_color, width = NULL
  )
})
#
output$aicInfoOut <- renderValueBox({
  item_val <- getMedidaAjusteValue("aic")
  if(item_val <= 50)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "green"
  } else if(item_val <= 100) {
    item_subT <- "Ajuste Medio"
    item_icon <- "thumbs-up"
    item_color <- "orange"
  } else {
    item_subT <- "NO Aceptable"
    item_icon <- "thumbs-down"
    item_color <- "red"
  }
  #
  shinydashboard::valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Criterio de Informaci\u00F3n de Akaike (AIC):", item_subT),
    icon = icon(item_icon),
    color = item_color, width = NULL
  )
})
#
output$bicInfoOut <- renderValueBox({
  item_val <- getMedidaAjusteValue("bic")
  if(item_val <= 50)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "green"
  } else if(item_val <= 100) {
    item_subT <- "Ajuste Medio"
    item_icon <- "thumbs-up"
    item_color <- "orange"
  } else {
    item_subT <- "NO Aceptable"
    item_icon <- "thumbs-down"
    item_color <- "red"
  }
  #
  shinydashboard::valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Criterio de Informaci\u00F3n Bayesiano (BIC):", item_subT),
    icon = icon(item_icon),
    color = item_color, width = NULL
  )
})
#
output$barrasMedidasAjustePlotOut <- renderAmCharts({
  cast_data <- semModelMedidasAjusteData() %>% filter(is_indice == T) %>%
                                               mutate(name = toupper(name), value = value * 100)
  #
  if(input$barrasMedidasAjusteSortCheck == TRUE){
    # ordena los datos de menor a mayor por columna !
    cast_data <- cast_data %>% dplyr::arrange_at("value")
  }
  #
  amBarplot(x = "name", y = "value", data = cast_data, xlab = "INDICE", ylab = "VALOR (%)",
            horiz = input$barrasMedidasAjusteHorizCheck, main = "Bondad de Ajuste - Comparaci\u00F3n de Indices",
            stack_type = if_else(input$barrasMedidasAjusteStackCheck == TRUE, "regular", "none"),
            legend=F, show_values=T, zoom=T, scrollbar=T, precision=3)
})
