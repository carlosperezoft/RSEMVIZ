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
  valueBox(
    value = sprintf("%.2f", chi2Value),
    subtitle = paste("Ajuste Chi2:", subTChi2),
    icon = icon("superscript"),
    color = colorChi2
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
  valueBox(
    value = sprintf("%.3f", pValue),
    subtitle = paste("P-Value:", subT_pVal),
    icon = shiny::icon(icon_pVal),
    color = color_pVal
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
  valueBox(
    value = sprintf("%.2f", razonChi2),
    subtitle = paste("Raz\u00F3n (Chi2 / GL):", subTChi2),
    icon = shiny::icon(iconChi2),
    color = colorChi2
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
    flexdashboard::gauge(value = sprintf("%.1f", 100*getMedidaAjusteValue("gfi")),
       min = 0, max = 100, symbol = '%', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(90, 100), warning = c(70,89), danger = c(0, 69),
                                   colors = c("success", "warning", "danger")))
  } else {
    flexdashboard::gauge(value = sprintf("%.3f", getMedidaAjusteValue("gfi")),
       min = 0, max = 1,  symbol = '', label = paste("GFI"),
       flexdashboard::gaugeSectors(success = c(0.90, 1), warning = c(0.70,0.89), danger = c(0, 0.69),
                                   colors = c("success", "warning", "danger")))

  }
})
#
output$gfiAngularGaugeOut <- renderAmCharts({
  bands <- data.frame(start = c(0, 40, 60), end = c(40, 60, 100),
                      color = c("#00CC00", "#ffac29", "#ea3838"), stringsAsFactors = FALSE)

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
             min = 0, max = 100, limit = 90, label = "GFI")
  } else {
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.8, label = "GFI")
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
  boxPlus(title = tagList(shiny::icon(item_icon), "RMSEA: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("rmseaBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Error de Aproximaci\u00F3n Cuadr\u00E1tico Medio (RMSEA)"),
      awesomeCheckbox(inputId = "rmseaHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "rmseaHelpTxt",
                 paste("?? (RMSEA): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("rmseaHelpSwitch", shinyjs::toggle(id = "rmseaHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "rmseaBoxOut"
output$rmseaBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("rmsea"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.05, label = "RMSEA")
})
#
output$rmrBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("rmr")
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
  boxPlus(title = tagList(shiny::icon(item_icon), "RMR: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("rmrBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de Error Cuadr\u00E1tico Medio (RMR)"),
      awesomeCheckbox(inputId = "rmrHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "rmrHelpTxt",
                 paste("?? (RMR): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("rmrHelpSwitch", shinyjs::toggle(id = "rmrHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "rmrBoxOut"
output$rmrBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("rmr"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 1, limit = 0.05, label = "RMR")
})
#
output$ecviBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("ecvi")
  #
  if(item_val <= 2)  {
    item_subT <- "Aceptable"
    item_icon <- "thumbs-up"
    item_color <- "success"
  } else if(item_val <= 4) {
    item_subT <- "Ajuste Medio"
    item_icon <- "thumbs-up"
    item_color <- "warning"
  } else {
    item_subT <- "NO Aceptable"
    item_icon <- "thumbs-down"
    item_color <- "danger"
  }
  #
  boxPlus(title = tagList(shiny::icon(item_icon), "ECVI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("ecviBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de Validaci\u00F3n Cruzada Esperada (ECVI)"),
      awesomeCheckbox(inputId = "ecviHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "ecviHelpTxt",
                 paste("?? (ECVI): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("ecviHelpSwitch", shinyjs::toggle(id = "ecviHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "ecviBoxOut"
output$ecviBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", getMedidaAjusteValue("ecvi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 6, limit = 2, label = "ECVI")
})
#
output$nfiBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("nfi")
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
  boxPlus(title = tagList(shiny::icon(item_icon), "NFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("nfiBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de ajuste normalizado (NFI)"),
      awesomeCheckbox(inputId = "nfiHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "nfiHelpTxt",
                 paste("?? (NFI): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("nfiHelpSwitch", shinyjs::toggle(id = "nfiHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "nfiBoxOut"
output$nfiBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("nfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 90, label = "NFI")
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
  boxPlus(title = tagList(shiny::icon(item_icon), "TLI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("tliBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de ajuste NO normalizado - Tucker Lewis (NNFI-TLI)"),
      awesomeCheckbox(inputId = "tliHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "tliHelpTxt",
                 paste("?? (NNFI-TLI): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
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
output$tliBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("tli"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 90, label = "TLI")
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
  boxPlus(title = tagList(shiny::icon(item_icon), "AGFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("agfiBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de bondad de ajuste corregido (AGFI)"),
      awesomeCheckbox(inputId = "agfiHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "agfiHelpTxt",
                 paste("?? (AGFI): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("agfiHelpSwitch", shinyjs::toggle(id = "agfiHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "agfiBoxOut"
output$agfiBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("agfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 90, label = "AGFI")
})
#
output$gfiCmpBoxOut <- renderUI({
  item_val <- getMedidaAjusteValue("gfi")
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
  boxPlus(title = tagList(shiny::icon(item_icon), "GFI: ", item_subT), width = 3,
    collapsible = TRUE, status = item_color, solidHeader = TRUE, closable = FALSE,
    amChartsOutput("gfiCmpBulletOut", height = "150"), # Es necesario usar un amChartsOutput... por el UI dinamico!
    footer = tagList( # SECCION DE EXPLICACION DEL CRITERIO:
      tags$b("Indice de bondad de ajuste (GFI)"),
      awesomeCheckbox(inputId = "gfiCmpHelpSwitch", label = "Ver Criterio",
                      value = FALSE, status = item_color),
      shinyjs::hidden( # Oculta el criterio inicialmente
        helpText(id = "gfiCmpHelpTxt",
                 paste("?? (GFI): Eval\u00FAa si el modelo debe ser ajustado.",
                 "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste."
                 )
        )
      ) # cierra hidden
    ) # FIN footer
  )
})
#
shinyjs::onclick("gfiCmpHelpSwitch", shinyjs::toggle(id = "gfiCmpHelpTxt", anim = TRUE, animType = "fade"))
#
# amBullet usado en el UI dinamico: "gfiCmpBulletOut"
output$gfiCmpBulletOut <- renderAmCharts({
    amBullet(value = as.numeric(sprintf("%.3f", 100*getMedidaAjusteValue("gfi"))),
             val_color = "blue", limit_color = "black",
             min = 0, max = 100, limit = 90, label = "GFI")
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
  valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Indice de bondad de ajuste de parsimonia (PGFI):", item_subT),
    icon = icon(item_icon),
    color = item_color
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
  valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Indice normalizado de ajuste de parsimonia (PNFI):", item_subT),
    icon = icon(item_icon),
    color = item_color
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
  valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Criterio de Informaci\u00F3n de Akaike (AIC):", item_subT),
    icon = icon(item_icon),
    color = item_color
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
  valueBox(
    value = sprintf("%.2f", item_val),
    subtitle = paste("Criterio de Informaci\u00F3n Bayesiano (BIC):", item_subT),
    icon = icon(item_icon),
    color = item_color
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
