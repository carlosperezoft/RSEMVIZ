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
      tabPanel("Ajuste Absoluto",icon=icon("adjust"), h4("Criterios de Referencia para el Ajuste Absoluto"),
         # Para que fucionen los BOX(...) se debe usar un fluidRow layout que los contenga:
         fluidRow(
           # NOTA: NO usar box(..) para contener un elemento tipo valueBoxOutput(..)
           #       El valueBoxOutput se activa cuando el SEM model ha sido estimado (tiene datos)
           column(3,
             bsPopover(id = "statChi2Out", title="Prueba Chi Cuadrado", placement = "top", trigger = "hover",
                       content=paste("El ajuste se considera aceptable al tener un valor cercano a los",
                                     "grados de libertad del modelo. Los valores muy altos indican un ajuste no aceptable.")),
             shinydashboard::valueBoxOutput("statChi2Out", width = NULL) %>%
             helper(type = "inline", title = "Prueba Chi Cuadrado", colour = "black",
                    content=paste("El ajuste se considera aceptable al tener un valor cercano a los",
                                  "grados de libertad del modelo. Los valores muy altos indican un ajuste no aceptable."),
                    size = "s")
           ),
           column(3,
             bsPopover(id = "pValueChi2Out", title="Valor p para Chi Cuadrado", placement = "top", trigger = "hover",
                       content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                                     "del modelo es cercano a la matriz de covarianza real de los datos.",
                                     "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula.")),
             shinydashboard::valueBoxOutput("pValueChi2Out", width = NULL) %>%
             helper(type = "inline", title = "Valor p para Chi Cuadrado", colour = "black",
                    content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                              "del modelo es cercano a la matriz de covarianza real de los datos.",
                              "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula."),
                size = "s")
           ),
           column(3,
             bsPopover(id = "statRazonChi2Out", title="Raz\u00F3n Chi cuadrado / Grados de Libertad",
                       placement="top",trigger="hover",
                       content=paste("Se considera aceptable al tener un valor inferior o cercano a 3.",
                                     "Con ajuste medio al ser menor de 5. Un valor superior a 5 indican un ajuste no aceptable.")),
             shinydashboard::valueBoxOutput("statRazonChi2Out", width = NULL) %>%
             helper(type = "inline", title = "Raz\u00F3n Chi cuadrado / Grados de Libertad", colour = "black",
                content=paste("Se considera aceptable al tener un valor inferior o cercano a 3.",
                              "Con ajuste medio al ser menor de 5. Un valor superior a 5 indican un ajuste no aceptable."),
                size = "s")
           ),
           column(3,
               bsPopover(id = "gradosLibertadOut", title="Grados de Libertad",
                       content = "Grados de libertad del modelo.", placement = "top", trigger = "hover"),
               infoBoxOutput("gradosLibertadOut", width = NULL)
           )
         ),
         fluidRow(
           uiOutput("gfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("rmseaBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("srmrBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("agfiBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Incremental", icon=icon("arrow-up"),
         h4("Criterios de Referencia para el Ajuste Incremental (Comparativo)"),
         fluidRow(
           uiOutput("nfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("tliBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("cfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("gfiCmpBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Parsimonioso", height = 200, icon=icon("recycle"),
         h4("Criterios de Referencia para el Ajuste Parsimonioso"),
         fluidRow(
           column( 3,
             bsPopover(id = "pgfiBoxOut", title="Parsimony Goodness-of-Fit Index (PGFI)",placement="top",trigger="hover",
                   content = "Se establece como aceptable al estar entre el intervalo [0.50, 0.70]."),
             shinydashboard::valueBoxOutput("pgfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "Indice de Bondad de Ajuste de Parsimonia", colour = "black",
                    content=paste("Se establece como aceptable al estar entre el intervalo [0.50, 0.70]."),
                    size = "s")
           ),
           column(3,
             bsPopover(id = "pnfiBoxOut", title="Parsimony Normed Fit Index (PNFI)",placement = "top",trigger="hover",
                   content = "Se establece como aceptable al ser mayor de 0.90. De ajuste medio si no es menor de 0.60."),
             shinydashboard::valueBoxOutput("pnfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "Indice normalizado de Ajuste de Parsimonia", colour = "black",
                    content=paste("Se establece como aceptable al ser mayor de 0.90. De ajuste medio si no es menor de 0.60."),
                    size = "s")
           ),
           column(3,
             bsPopover(id = "aicInfoOut", title="AKAIKE Information Criterion (AIC)",placement = "top", trigger = "hover",
                   content="Se establece como aceptable un valor menor de 50. De ajuste medio si no es mayor a 100."),
             shinydashboard::valueBoxOutput("aicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "Criterio de Informaci\u00F3n de AKAIKE", colour = "black",
                    content=paste("Se establece como aceptable un valor menor de 50. De ajuste medio si no es mayor a 100"),
                    size = "s")
           ),
           column(3,
             bsPopover(id = "bicInfoOut", title="Bayesian Information Criterion (BIC)",placement="top",trigger="hover",
                   content = "Se establece como aceptable un valor menor de 50. De ajuste medio si no es mayor a 100"),
             shinydashboard::valueBoxOutput("bicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "Criterio de Informaci\u00F3n Bayesiano", colour = "black",
                    content=paste("Se establece como aceptable un valor menor de 50. De ajuste medio si no es mayor a 100"),
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
