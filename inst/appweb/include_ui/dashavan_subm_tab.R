# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 19/09/2018 17:08:28 p. m.
#
tabItem(tabName = "dashAVANSubMTab",
  h2(":: Dashboard Avanzado para el MODELO SEM"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("Modelo SEM para an\u00E1lisis Detallado"),
    sidebarLayout(
      # Sidebar panel for inputs ----
      # NOTA: Es posible indicar el numero de columnas para el sidebarPanel y el mainPanel,
      #       esto con el fin de ajustarse al tamaño de los elementos contenidos en cada panel.
      #      * IMPORTANTE el total son 12 columnas para ajustar los dos Paneles,
      #      * se ha usado 5 en el sidebar (grafo) y 7 en el main (tablas).
      sidebarPanel(width = 5, style="background-color: #FFFFFF;",
        fluidRow(
          box(actionButton("dashAvanzSEMBtn", "Actualizar Informaci\u00F3n por Variable..."),
            visNetworkOutput("grafoAvanzSEMOut", height = 600) %>% withSpinner(type=8, color="cadetblue"),
                title = tagList(shiny::icon("gears"), "Modelo SEM"), width = NULL,
                collapsible = TRUE, status = "primary", solidHeader = TRUE
          ) %>%
          popify(title = "Modelo SEM Interactivo",
            content = "Seleccione usando CTRL+clic los elementos que desea analizar...",
            placement = "top", trigger = "hover")
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
        wellPanel(
          h3("Elementos Detallados"),
          tabBox(width = "100%", height = "100%",#tabsetPanel(type = "tabs",
                 title = tagList(shiny::icon("wrench"), "Detalles"),
            tabPanel("Por Variable",
              h4("An\u00E1lisis seleccionando Elementos en el modelo SEM (estandarizado):"),
              materialSwitch(inputId = "convenNodosSwitch", label = tags$b("Ver Convenciones"),
                             status = "info", right = TRUE, value = FALSE),
              verbatimTextOutput("nodesListTxtOut"),
              formattableOutput("tablaGeneralSEMOut", width = "100%") %>% withSpinner(color="cadetblue"),
              shinyjs::hidden( # Inicialmente oculta las convenciones:
                 # Usar el DIV es mejor para shiny-js y el materialSwitch:
                 div(id="convenNodosDIV", tags$b("Convenciones de Elementos SEM presentados:"),
                     formattableOutput("convenNodosTablaOut", width = "100%") %>% withSpinner(type=5, color="cadetblue")
                 )
              )
            ),
            tabPanel("Correlograma",h4("An\u00E1lisis elementos del Modelo SEM por medio de un Correlograma"),
               dropdownButton(inputId = "corrOpsBtn",
                 tags$h4("Opciones de Presentaci\u00F3n:"),
                 selectInput(inputId = 'corType', label = 'Datos del Correlograma',
                            choices = c("Covar. Observadas"="cov.ov","Covar. Latentes"="cov.lv",
                                        "Corr. Observadas"="cor.ov","Corr. Latentes"="cor.lv","Residuales"="residual"),
                                         selected = "cor.ov"),
                 selectInput(inputId = 'corMethod', label = 'Estilo de Representaci\u00F3n',
                            choices = c("C\u00EDrculo"="circle","Cuadrado"="square",
                                        "Elipse"="ellipse","Num\u00E9rico"="number","Torta"="pie"),
                            selected = "ellipse"),
                 selectInput(inputId = 'corSection', label = 'Ver Secci\u00F3n',
                             choices = c("Completo"="full","Inferior"="lower","Superior"="upper"),
                             selected = "upper"),
                 tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                 circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                 size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
               ),
               plotOutput("correlogramSEMOut", width = "100%", height = "800") %>% withSpinner()
            ),
            tabPanel("Heatmap",h4("An\u00E1lisis de Matrices del Modelo SEM"),
               dropdownButton(inputId = "heatmapOpsBtn",
                 tags$h4("Opciones de Presentaci\u00F3n:"),
                 selectInput(inputId = 'heatmapType', label = 'Matriz: Covariaza / Correlaci\u00F3n',
                             choices = c("Covar. Observadas"="cov.ov","Covar. Latentes"="cov.lv",
                                         "Corr. Observadas"="cor.ov","Corr. Latentes"="cor.lv","Residuales"="residual"),
                             selected = "cor.ov"),
                 selectInput(inputId = 'showDendrogram', label = 'Ver Dendrograma',
                             choices = c("Ninguno"='none',"Filas"='row',"Columnas"='column',"Ambos"='both'),
                             selected = "row"),
                 tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                 circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                 size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
               ),
               plotlyOutput("heatmapSEMOut", width = "100%", height = "800") %>% withSpinner(type=5, color="cadetblue")
            ),
            tabPanel("Elementos internos SEM", h3("Valores de indicadores de ajuste obtenidos"),
               # Adicionar un SELECT para especificar que elementos leer del FIT SEM:
               verbatimTextOutput("fitElementSEMTxtOut")
            )
          )
        ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
