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
          box(visNetworkOutput("grafoAvanzSEMOut", height = 600) %>% withSpinner(type=8, color="cadetblue"),
              title = tagList(shiny::icon("gears"), "Modelo SEM"), width = NULL,
              collapsible = TRUE, status = "primary", solidHeader = TRUE)
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
        wellPanel(
          h3("Elementos Detallados"),
          tabsetPanel(type = "tabs",
            tabPanel("Correlaci\u00F3n",h4("An\u00E1lisis de Correlaciones del Modelo SEM"),
               dropdownButton(inputId = "corrOpsBtn",
                 tags$h4("Opciones de Presentaci\u00F3n:"),
                 selectInput(inputId = 'corType', label = 'Datos Correlaci\u00F3n',
                            choices = c("cor.lv", "cor.ov"), selected = "cor.ov"),
                 selectInput(inputId = 'corMethod', label = 'Estilo de Representaci\u00F3n',
                            choices = c("circle", "square", "ellipse", "number", "pie"),
                            selected = "ellipse"),
                 selectInput(inputId = 'corSection', label = 'Ver Secci\u00F3n',
                             choices = c("full", "lower", "upper"),
                             selected = "upper"),
                 tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                 circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                 size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotOutput("correlogramSEMOut", width = "100%", height = "500") %>% withSpinner()
            ),
            tabPanel("Heatmap",h4("An\u00E1lisis de Matrices del Modelo SEM"),
               dropdownButton(inputId = "heatmapOpsBtn",
                 tags$h4("Opciones de Presentaci\u00F3n:"),
                 selectInput(inputId = 'heatmapType', label = 'Matriz: Covariaza / Correlaci\u00F3n',
                             choices = c("cov.ov", "cov.lv", "cor.ov", "cor.lv"), selected = "cor.ov"),
                 selectInput(inputId = 'showDendrogram', label = 'Ver Dendrograma',
                             choices = c('none', 'row', 'column','both'), selected = "none"),
                 tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                 circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                 size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
               ),
               plotlyOutput("heatmapSEMOut", width = "500", height = "500") %>% withSpinner()
            ),
            tabPanel("Informaci\u00F3n por Variable",
              actionButton("getNodesSelBtn", "Actualizar gr\u00E1ficos asociados..."),
              h4("NODOs SELECCIONADOs ACTUALMENTE:"),
              verbatimTextOutput("nodesListTxtOut"),
              formattableOutput("tablaGeneralSEMOut", width = "100%") %>% withSpinner()
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
