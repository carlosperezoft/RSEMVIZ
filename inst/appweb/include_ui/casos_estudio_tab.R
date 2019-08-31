# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 11/09/2018 10:08:28 a. m.
#
tabItem(tabName = "casosEstudioTab",
  h2(":: Casos de Estudio SEM Aplicado"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("An\u00E1lisis de proyectos predefinidos"),
    materialSwitch(inputId = "casosEstudioSwitch", label = tags$b("Ocultar selector de Casos..."),
                   value = FALSE, status = "danger", right = TRUE),
    sidebarLayout(
      # Sidebar panel for inputs ----
      # NOTA: Es posible indicar el numero de columnas para el sidebarPanel y el mainPanel,
      #       esto con el fin de ajustarse al tamaño de los elementos contenidos en cada panel.
      #      * IMPORTANTE el total son 12 columnas para ajustar los dos Paneles,
      #      * se ha usado 5 en el sidebar (grafo) y 7 en el main (tablas).
      div(id ="casosEstudioTab", # Se debe usar el DIV en el caso de sidebarPanel, para el Shiny-JS
      sidebarPanel(width = 4,
         fluidRow(
           selectInput("casoEstudioSelect", tags$b("Casos de Estudio:"), selected = "Seleccionar...", width="100%",
              choices = c("Seleccionar...",
                 "BOLLEN: Pol\u00EDtica Democr\u00E1tica de pa\u00EDses en v\u00EDa de Desarrollo" = "Political_Democracy",
                 "U. de A.: Grupos de Investigaci\u00F3n en la Universidad" = "Grupos_INVESTIGACION"
              )
           ),
           checkboxInput("usarCasoEstudioChk", "Usar Caso de Estudio seleccionado en SEMVIZ", value = FALSE)
         )
      )), # fin sidebarPanel
      # Main panel for displaying outputs ----
      mainPanel(width = 8,
        wellPanel(
          h3("Informaci\u00F3n sobre el Caso de Estudio seleccionado:"),
          ##
          tabsetPanel(type = "tabs",
            tabPanel("DETALLES", h3("Destalles propios del Caso de Estudio"),
              htmlOutput("detalleCasoEstudioHTMLOut")
            ),
            tabPanel("RESUMEN", h2("Resumen informativo sobre los datos asociados"),
              verbatimTextOutput("resumenCasoEstudoTxtOut")
            )
          )
          ##
        ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
#
