# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 10/09/2018 18:08:28 p. m.
#
tabItem(tabName = "hipotesisTab",
  h2(":: Hip\u00F3tesis MODELO SEM"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("An\u00E1lisis de hip\u00F3tesis asociadas"),
    sidebarLayout(
      # Sidebar panel for inputs ----
      # NOTA: Es posible indicar el numero de columnas para el sidebarPanel y el mainPanel,
      #       esto con el fin de ajustarse al tamaño de los elementos contenidos en cada panel.
      #      * IMPORTANTE el total son 12 columnas para ajustar los dos Paneles,
      #      * se ha usado 5 en el sidebar (grafo) y 7 en el main (tablas).
      sidebarPanel(id="hipotSidebarPanel", width = 5, style="background-color: white;",
         fluidRow(
           box(visNetworkOutput("grafoHipotSEMOut", height = 600) %>% withSpinner(type=8, color="cadetblue"),
              title = tagList(shiny::icon("gears"), "Modelo SEM"), width = NULL,
              collapsible = TRUE, status = "success", solidHeader = TRUE
           )
         )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
          wellPanel(
            h3("Validaci\u00F3n de H0 y H1:"),
            tabsetPanel(type = "tabs",
              tabPanel("H0 vs H1 - FACTORES", h4("Tabla Estimaci\u00F3n Factorial Confirmatorio"), br(),
                 formattableOutput("tablaHipotesisModeloOut", width = "100%") %>% withSpinner(),
                 htmlOutput("ecuacionFactHipoTxtOut")
              ),
              tabPanel("H0 vs H1 - ESTRUCTURAL ",
                 h4("Tabla Estimaci\u00F3n Modelo Estructural (Regresiones)"), br(),
                 formattableOutput("tablaHipotesisParamsOut", width = "100%") %>% withSpinner(),
                 htmlOutput("ecuacionEstrHipoTxtOut") # antes: verbatimTextOutput(..)
              )
            )
          ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
