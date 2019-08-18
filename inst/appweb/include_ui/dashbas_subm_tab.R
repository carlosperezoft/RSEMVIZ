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
    switchInput(inputId = "indPorcentSwitch", onLabel = "Si", offLabel = "No",  label = "%",
            onStatus = "success", offStatus = "danger", value = TRUE, size = "small"), # 'mini', 'small',
    uiOutput("tipoGraficoOut"),
    tabBox(width = "100%", height = "100%",
      title = tagList(shiny::icon("random"), "Clasificaci\u00F3n por tipo"),
      tabPanel("Ajuste Absoluto",h4("Criterios de Referencia para el Ajuste Absoluto"),
         # Para que fucionen los BOX(...) se debe usar un fluidRow layout que los contenga:
         fluidRow(
           # NOTA: NO usar box(..) para contener un elemento tipo valueBoxOutput(..)
           #       El valueBoxOutput se activa cuando el SEM model ha sido estimado (tiene datos)
           column(3, valueBoxOutput("statChi2Out", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: statChi2Out", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           ),
           column(3, valueBoxOutput("pValueChi2Out", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: pValueChi2Out", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           ),
           column(3, valueBoxOutput("statRazonChi2Out", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: statRazonChi2Out", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           ),
           column(3, infoBoxOutput("gradosLibertadOut", width = NULL) %>%
               helper(type = "inline", title = "SEMVIZ: gradosLibertadOut", colour = "black",
                      size = "s", content = paste("gradosLibertadOut: Eval\u00FAa si el modelo debe ser ajustado.",
                                                  "Entre m\u00E1s se acerque a cero (0) indica un MAL ajuste.")
               )
           )
         ),
         fluidRow(
           uiOutput("gfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("rmseaBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("rmrBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("ecviBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Incremental",
         h4("Criterios de Referencia para el Ajuste Incremental (Comparativo), presentado en porcentaje (%)"),
         fluidRow(
           uiOutput("nfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("tliBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("agfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("gfiCmpBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Parsimonioso", height = 200, h4("Criterios de Referencia para el Ajuste Parsimonioso"),
         fluidRow(
           column( 3, valueBoxOutput("pgfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: pgfiBoxOut", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           ),
           column(3, valueBoxOutput("pnfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: pnfiBoxOut", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           ),
           column(3, valueBoxOutput("aicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: aicInfoOut", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           ),
           column(3, valueBoxOutput("bicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "SEMVIZ: bicInfoOut", colour = "black",
                        content = "redCorrelacionMedidaPlot_help", size = "m")
           )
         ),
         dropdownButton(inputId = "barrasMedidasAjusteOpsBtn",
            tags$h4("Opciones de Presentaci\u00F3n:"),
            materialSwitch(inputId = "barrasMedidasAjusteSortCheck", label = "Ordenar Valores",
                           value = FALSE, status = "info", right = TRUE),
            materialSwitch(inputId = "barrasMedidasAjusteHorizCheck", label = "Vista Horizontal",
                           value = FALSE, status = "success", right = TRUE),
            materialSwitch(inputId = "barrasMedidasAjusteStackCheck", label = "Ajustar Barras",
                           value = FALSE, status = "warning", right = TRUE),
            tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
            circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
            size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
         ),
         amChartsOutput("barrasMedidasAjustePlotOut", width = "100%", height = "500") %>%
                       withSpinner(type=6, color="cadetblue")
      )
    )
  ) ## fin fluidPage ===========
)
#
