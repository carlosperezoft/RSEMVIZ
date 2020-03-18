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
      tabPanel("Ajuste Absoluto",icon=icon("adjust"),
         h4(tags$a("Criterios de Referencia para el Ajuste Absoluto")) %>%
            popify(title="Ajuste Absoluto",placement="top",trigger="hover",
                   content = paste(
                     "El ajuste absoluto eval\u00FAa la capacidad explicativa del modelo (representativo de los datos).",
                     "Fundamentalmente se validan: el estad\u00EDstico X^2, y los \u00EDndices: ",
                     "GFI, RMSEA, CFI y SRMR (Residuales)."
                      )
         ),
         # Para que fucionen los BOX(...) se debe usar un fluidRow layout que los contenga:
         fluidRow(
           # NOTA: NO usar box(..) para contener un elemento tipo valueBoxOutput(..)
           #       El valueBoxOutput se activa cuando el SEM model ha sido estimado (tiene datos)
           column(3,
             bsPopover(id = "statChi2Out", title="Prueba Chi Cuadrado", placement = "top", trigger = "hover",
                       content=paste("El ajuste se considera aceptable al tener un valor cercano a los",
                                     "grados de libertad del modelo. Es sensible al tama\u00F1o de la muestra.",
                                     "Por tanto es recomendable usar la raz\u00F3n Chi2/df como criterio complementario.",
                                     "Referencia: Joreskong (1969).")),
             shinydashboard::valueBoxOutput("statChi2Out", width = NULL) %>%
             helper(type = "markdown", colour = "black",
                    size = "m", content="Chi2-description-help"
             )
           ),
           column(3,
             bsPopover(id = "pValueChi2Out", title="Valor p para Chi Cuadrado", placement = "top", trigger = "hover",
                       content=paste("Evalua la Hip\u00F3tesis Nula: La cual indica que el estimador de la matriz de covarianza",
                                     "del modelo es cercano a la matriz de covarianza real de los datos.",
                                     "Por lo cual es preferible un p mayor a 0.05 para no rechazar H. nula.")),
             shinydashboard::valueBoxOutput("pValueChi2Out", width = NULL) %>%
             helper(type = "inline", title = "Valor p para Chi Cuadrado", colour = "black", size = "m",
                    content=paste(
                      "Evaluar la Hip\u00F3tesis Nula bas\u00E1ndose s\u00F3lo en el valor de p es desaconsejable, ",
                      "aunque es pertinente reportarlo siempre. Un mejor indicador es la raz\u00F3n Chi2/df.")
              )
           ),
           column(3,
             bsPopover(id = "statRazonChi2Out", title="Raz\u00F3n Chi cuadrado / Grados de Libertad",
                       placement="top",trigger="hover",
                       content=paste("Se considera aceptable al tener un valor inferior o cercano a 3.",
                                     "Con ajuste medio al ser menor de 5. Un valor superior a 5 indican un ajuste no aceptable.",
                                     "Referencia: Joreskong (1969).")),
             shinydashboard::valueBoxOutput("statRazonChi2Out", width = NULL) %>%
             helper(type = "inline", title = "Raz\u00F3n Chi cuadrado / Grados de Libertad", colour = "black", size = "m",
                content=paste("Es posible analizar la raz\u00F3n Chi2/df como una proporci\u00F3n, en este caso se han propuesto: ",
                              "Una relaci\u00F3n 2:1 es considerada aceptable por Tabachnik y Fidell (2007) y ",
                              "una relaci\u00F3n 3:1 es considerada aceptable por Kline (2005).",
                              "Es sensible al tama\u00F1o de la muestra y es penalizado por la complejidad del modelo.")
                )
           ),
           column(3,
               bsPopover(id = "gradosLibertadOut", title="Grados de Libertad (GL). Observ. (N)",
                         content = "Grados de libertad del modelo (GL). N\u00FAmero de obsevaciones (N).", placement = "top",
                         trigger = "hover"),
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
         h4(tags$a("Criterios de Referencia para el Ajuste Incremental (Comparativo)")) %>%
            popify(title="Ajuste Incremental (Comparativo)",placement="top",trigger="hover",
                   content = paste(
                     "El ajuste incremental eval\u00FAa la diferencia entre el ajuste del ",
                     "modelo te\u00F3rico con el ajuste del modelo independiente (o nulo), en el cual todas las ",
                     "variables son independientes (no hay relaciones causales establecidas)."
                      )
         ),
         fluidRow(
           uiOutput("nfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("tliBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("cfiBoxOut") %>% withSpinner(type=7, color="cadetblue"),
           uiOutput("gfiCmpBoxOut") %>% withSpinner(type=7, color="cadetblue")
         )
      ),
      tabPanel("Ajuste Parsimonioso", height = 200, icon=icon("recycle"),
         h4(tags$a("Criterios de Referencia para el Ajuste Parsimonioso")) %>%
            popify(title="Ajuste Parsimonioso",placement="top",trigger="hover",
                   content = paste(
                       "Se considera que un modelo es mejor mientras m\u00E1s parsimonioso sea.",
                       "Lo anterior indica que necesita de menos relaciones causales para explicar los mismos",
                       "fen\u00F3menos; es decir, que cuantos menos par\u00E1metros se tenga que estimar, ",
                       "mejor se considera el modelo."
                     )
         ),
         fluidRow(
           column( 3,
             bsPopover(id = "pgfiBoxOut", title="Parsimony Goodness-of-Fit Index (PGFI)",placement="top",trigger="hover",
                   content = "Se establece como aceptable al ser mayor de 0.90. De ajuste medio si no es menor de 0.60. Es sensible al tama\u00F1o de la muestra."),
             shinydashboard::valueBoxOutput("pgfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "Indice de Bondad de Ajuste de Parsimonia", colour = "black",
                    content=paste("Se considera que a mayor valor (cercano a 1), mayor parsimonia del modelo.",
                                  "Normalmente es menor que otros \u00EDndices y es sensible al tama\u00F1o de la muestra."),
                    size = "m")
           ),
           column(3,
             bsPopover(id = "pnfiBoxOut", title="Parsimony Normed Fit Index (PNFI)",placement = "top",trigger="hover",
                   content = "Se establece como aceptable al ser mayor de 0.90. De ajuste medio si no es menor de 0.60."),
             shinydashboard::valueBoxOutput("pnfiBoxOut", width = NULL) %>%
                 helper(type = "inline", title = "Indice normalizado de Ajuste de Parsimonia", colour = "black",
                    content=paste("Se establece como aceptable al ser mayor de 0.90. De ajuste medio si no es menor de 0.60."),
                    size = "m")
           ),
           column(3,
             bsPopover(id = "aicInfoOut", title="AKAIKE Information Criterion (AIC)",placement = "top", trigger = "hover",
                   content="Es usado en comparaci\u00F3n de modelos SEM, mientras menor sea; se considera mejor."),
             shinydashboard::valueBoxOutput("aicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "Criterio de Informaci\u00F3n de AKAIKE", colour = "black",
                    content=paste("Se establece como aceptable un valor menor de 5000. De ajuste medio si no es mayor a 10000. Es usado en comparaci\u00F3n de modelos SEM, mientras menor sea se considera mejor."),
                    size = "m")
           ),
           column(3,
             bsPopover(id = "bicInfoOut", title="Bayesian Information Criterion (BIC)",placement="top",trigger="hover",
                   content = "Es usado en comparaci\u00F3n de modelos SEM, mientras menor sea; se considera mejor."),
             shinydashboard::valueBoxOutput("bicInfoOut", width = NULL) %>%
                 helper(type = "inline", title = "Criterio de Informaci\u00F3n Bayesiano", colour = "black",
                    content=paste("Se establece como aceptable un valor menor de 5000. De ajuste medio si no es mayor a 10000. Es usado en comparaci\u00F3n de modelos SEM, mientras menor sea se considera mejor. BIC es recomendado al usar muestras grandes o cuando los par\u00E1metros del modelo son pocos."),
                    size = "m")
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
