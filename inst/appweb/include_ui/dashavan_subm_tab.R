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
      sidebarPanel(width = 5,
        fluidRow(
          visNetworkOutput("grafoAvanzSEMOut", height = 600) %>% withSpinner()
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
        wellPanel(
          h3("Elementos Detallados"),
          tabsetPanel(type = "tabs",
            tabPanel("Matrices Modelo SEM",h3("An\u00E1lsis de Correlaciones del Modelo SEM"),
              svgPanZoomOutput("correlogramSEMOut", width = "100%", height = "500") %>% withSpinner(),
              verbatimTextOutput("corrMatSEMTxtOut")
            ),
            tabPanel("Informaci\u00F3n por Variable",
              actionButton("getNodesSelBtn", "LEER Nodos Seleccionados..."),
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
