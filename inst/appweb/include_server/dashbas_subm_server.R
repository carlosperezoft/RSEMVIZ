# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 05/09/2018 14:08:28 p. m.
#
output$grafoBasicoSEMOut <- renderVisNetwork({
  getGrafoModelSEMBase()
})

output$tablaGeneralSEMOut1 <- renderFormattable({
  # ESPECIFICACIONES DE FORMATO Y PRESENTACION PARA LA TABLA SEM DE LAVAAN:
  latentFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
  obsFormat <- formatter("span", style = style(color = "red", font.weight = "bold"))
  zetaFormat <- formatter("span",
                          style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
                          x ~ sprintf("%.2f (rank: %02d)", x, rank(-x)))
  pvalueFormat <- formatter("span",
                            style = x ~ style(color = ifelse(x <= 0.05, "green", "red")),
                            x ~ icontext(ifelse(x <= 0.05, "ok", "remove"),
                                         ifelse(x <= 0.05, "Yes", "No")))
  ciLFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFormat <- formatter("span",x~ style(digits(x,3)))
  ciUFmt <- x ~ round(x, digits=2)
  #
  formattable(paramsSemFit(), list(
    lhs = latentFormat, rhs = obsFormat,
    area(col = c(est.std)) ~ normalize_bar("pink", 0.2),
    area(col = c(se)) ~ proportion_bar(),
    z = zetaFormat,
    pvalue = pvalueFormat,
    ci.lower = ciLFormat,
    ci.upper = ciUFmt
  ))
})

output$indicesAjusteSEMTxtOut1 <- renderPrint({
  fitMeasures(semFitLocal())
})

observe({
  input$getNodesSelBtn1
  visNetworkProxy("grafoBasicoSEMOut") %>% visGetSelectedNodes()
})

# paste0(..) es una funcion vetorizadas, luego recorre _selectedNodes
# por cada item que tenga y concatenda por cada fila:
output$nodesListTxtOut1 <- renderPrint({
  paste0("{", input$grafoBasicoSEMOut_selectedNodes,
         "} NODO_ID = (", input$grafoBasicoSEMOut_selected,
         ") POR_GRUPO = ", input$grafoBasicoSEMOut_selectedBy)
})
### elementos de bondad de ajuste:
output$aicIdx <- renderValueBox({
  semLocal <- semFitLocal()
  valueBox(
    value = sprintf("%.3f", AIC(semLocal)),
    subtitle = sprintf("AIC (%s)", "Ajustado"),
    icon = icon("thumbs-up"),
    color = "green"
  )
})

output$BIC_SEM_IDX <- renderValueBox({
  semLocal <- semFitLocal()
  valueBox(
    value = sprintf("%.3f", BIC(semLocal)),
    subtitle = sprintf("BIC (%s)", "NO Ajustado"),
    icon = icon("thumbs-down"),
    color = "red"
  )
})

output$CHI_2_SEM_INDX <- renderValueBox({
  semLocal <- semFitLocal()
  valueBox(
    value = sprintf("%.3f", fitMeasures(semLocal, "chisq")),
    subtitle = sprintf("CHI^2 (p-value: %.3f%%)", fitMeasures(semLocal, "pvalue")),
    icon = icon("thumbs-up"),
    color = "green"
  )
})

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

bands <- data.frame(start = c(0, 40, 60), end = c(40, 60, 100) , #, c(0, 0.40, 0.60), end = c(0.40, 0.60, 1)
                    color = c("#00CC00", "#ffac29", "#ea3838"),
                    stringsAsFactors = FALSE)
#
output$gaugeAMCOut1 <- renderAmCharts({
  amAngularGauge(x = as.numeric(sprintf("%.1f", 100*fitMeasures(semFitLocal(), "tli"))),
                 bands = bands, text = "%", textSize = 10,
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
