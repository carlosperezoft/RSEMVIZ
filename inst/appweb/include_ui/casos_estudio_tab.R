# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 11/09/2018 10:08:28 a. m.
#
tabItem(tabName = "casosEstudioTab",
  h2(":: Casos de Estudio SEM Aplicado"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("An\u00E1lisis de proyectos predefinidos"),

    sidebarLayout(

      # Sidebar panel for inputs ----
      # NOTA: Es posible indicar el numero de columnas para el sidebarPanel y el mainPanel,
      #       esto con el fin de ajustarse al tamaño de los elementos contenidos en cada panel.
      #      * IMPORTANTE el total son 12 columnas para ajustar los dos Paneles,
      #      * se ha usado 5 en el sidebar (grafo) y 7 en el main (tablas).
      sidebarPanel(width = 5,
         fluidRow(
           selectInput("casoEstudioSelect", "Casos de Estudio:", selected = "Seleccionar...",
             choices = c("Seleccionar...", "Political_Democracy",
                         "Grupos_INVESTIGACION", "Universidades_Estatales")
           ),
           checkboxInput("usarCasoEstudioChk", "Usar Caso de Estudio en SEMVIZ", value = FALSE)
         )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
        wellPanel(
          h3("Informaci\u00F3n sobre el Caso de Estudio seleccionado:"),
          ##
          tabsetPanel(type = "tabs",
            tabPanel("DETALLES", h3("Destalles propios del Caso de Estudio"),
              htmlOutput("detalleCasoEstudioHTMLOut")
            ),
            tabPanel("REMUMEN", h3("Resumen informativo del modelo y los datos asociados"),
              verbatimTextOutput("resumenCasoEstudoTxtOut")
            )
          )
          ##
        ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
