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
             helper(type = "inline", title = "Ajuste Chi Cuadrado", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           ),
           column(3, valueBoxOutput("pValueChi2Out", width = NULL) %>%
                 helper(type = "inline", title = "Valor p para Chi Cuadrado", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           ),
           column(3, valueBoxOutput("statRazonChi2Out", width = NULL) %>%
                 helper(type = "inline", title = "Razon Chi cuadrado / Grados de Libertad", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           ),
           column(3, infoBoxOutput("gradosLibertadOut", width = NULL) %>%
               helper(type = "inline", title = "Grados de Libertad", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           )
         ),
         fluidRow(
           uiOutput("gfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("rmseaBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("srmrBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("agfiBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Incremental",
         h4("Criterios de Referencia para el Ajuste Incremental (Comparativo)"),
         fluidRow(
           uiOutput("nfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("tliBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("cfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("gfiCmpBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Parsimonioso", height = 200, h4("Criterios de Referencia para el Ajuste Parsimonioso"),
         fluidRow(
           column( 3, valueBoxOutput("pgfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "Indice de Bondad de Ajuste de Parsimonia", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           ),
           column(3, valueBoxOutput("pnfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "Indice normalizado de Ajuste de Parsimonia", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           ),
           column(3, valueBoxOutput("aicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "Criterio de Información de AKAIKE", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
           ),
           column(3, valueBoxOutput("bicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "Criterio de Información Bayesiano", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                        "del modelo, indicando que tan cercano es a la matriz de covarianza real de los datos.",
                        "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                    size = "s")
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
