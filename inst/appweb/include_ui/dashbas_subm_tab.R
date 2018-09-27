# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 05/09/2018 14:08:28 p. m.
#
tabItem(tabName = "dashBASSubMTab",
  h2(":: Dashboard de Resultados B\u00E1sicos"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("Medidas de Bondad de Ajuste"),
    tags$b("Usar \u00EDndices en porcentaje"),
    switchInput(inputId = "indPorcentSwitch", onLabel = "Si", offLabel = "No", size = "mini",
                onStatus = "success", offStatus = "danger", label = "%", value = TRUE),
    uiOutput("tipoGraficoOut"),
    tabBox(width = "100%", height = "100%",
      title = tagList(shiny::icon("random"), "Clasificaci\u00F3n por tipo"),
      tabPanel("Ajuste Absoluto",h4("Criterios de Referencia para el Ajuste Absoluto"),
         # Para que fuciones los BOX(...) se debe usar un fluidRow layout que los contenga:
         fluidRow(
           # NOTA: NO usar box(..) para contener un elemento tipo valueBoxOutput(..)
           #       El valueBoxOutput se activa cuando el SEM model ha sido estimado (tiene datos)
           valueBoxOutput("statChi2Out", width = 3),
           valueBoxOutput("pValueChi2Out", width = 3),
           valueBoxOutput("statRazonChi2Out", width = 3),
           infoBoxOutput("gradosLibertadOut", width = 3)
         ),
         fluidRow(
           uiOutput("gfiBoxOut")
         )
      ),
      tabPanel("Ajuste Incremental", h4("Criterios de Referencia para el Ajuste Incremental"),
         verbatimTextOutput("indicesAjusteSEMTxtOut1"),
         fluidRow(
           # NOTA: NO usar box(..) para contener un elemento tipo valueBoxOutput(..)
           #       El valueBoxOutput se activa cuando el SEM model ha sido estimado (tiene datos)
           box(flexdashboard::gaugeOutput("RMSEAIdx") %>% withSpinner(),
               title = tagList(shiny::icon("thumbs-down"), "GFI"), width = 4,
               collapsible = TRUE, status = "danger", solidHeader = TRUE),
           box(flexdashboard::gaugeOutput("RMSEApvalue") %>% withSpinner() %>%
                 helper(type = "inline", title = "NFI", colour = "red",
                        content = "Criterio de informaci\u00F3n de AKAIKE. Un valor peque\u00F3o indica parsimonia",
                        size = "s"), "Informacion extra del elemento", width = 4,
               title = tagList(shiny::icon("thumbs-up"), "P-value RMSEA"),
               collapsible = TRUE, status = "success", solidHeader = TRUE)
         ),
         h4("Prueba GAUGE [rAmCharts]:"),
         fluidRow(
           boxPlus(amChartsOutput(outputId = "gaugeAMCOut1", width = "180", height = "180")
               %>% withSpinner() %>% helper(type = "inline", title = "TLI", colour = "blue",
                            content = "Criterio de informaci\u00F3n de AKAIKE. Un valor pequeño indica parsimonia",
                                            size = "s"),
               title=tagList(shiny::icon("thumbs-down"), "boxPLUS:TLI"),
               collapsible = TRUE, closable = FALSE,  status = "danger", solidHeader = TRUE,
               width = 3, footer = tagList(
                 checkboxInput("somevalue", "Some value", FALSE),
                 helpText("Estadistico Ratio de verosimilitud. Validacion >= 0.90"),
                 sliderInput(
                   "slider_boxsidebar",
                   "Number of observations:",
                   min = 0,
                   max = 1000,
                   value = 500
                 )
               )
           ),
           gradientBox(amChartsOutput(outputId = "gaugeAMCOut2", width = "250", height = "110") %>% withSpinner()
               %>% helper(type = "inline", title = "AIC!", colour = "red",
                          content = "Criterio de informaci\u00F3n de AKAIKE. Un valor pequeño indica parsimonia",
                          size = "s", icon = "question"),
               title=tagList(shiny::icon("thumbs-up"), "gaugeAMCOut2"), collapsible = TRUE,  width = 4,
               gradientColor = "green", footer = "Validacion >= 0.90"),
           gradientBox(amChartsOutput(outputId = "gaugeAMCOut3", width = "250", height = "110") %>% withSpinner()
               %>% helper(type = "inline", title = "AIC!", colour = "red", icon = "exclamation",
                          content = "Criterio de informaci\u00F3n de AKAIKE. Un valor pequeño indica parsimonia",
                          size = "s"),
               title="gaugeAMCOut3", collapsible = TRUE, gradientColor = "red", width = 4,
               icon = shiny::icon("thumbs-down"), footer = "Validacion >= 0.90")
         )
      ),
      tabPanel("Ajuste Parsimonioso",
        h4("Criterios de Referencia para el Ajuste Parsimonioso")
      )
    )
  ) ## fin fluidPage ===========
)
