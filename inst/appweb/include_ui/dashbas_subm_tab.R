# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 05/09/2018 14:08:28 p. m.
#
tabItem(tabName = "dashBASSubMTab",
  h2(":: Tablero b\u00E1sico tabular del MODELO SEM"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("Modelo SEM para an\u00E1lisis"),

    sidebarLayout(

      # Sidebar panel for inputs ----
      # NOTA: Es posible indicar el numero de columnas para el sidebarPanel y el mainPanel,
      #       esto con el fin de ajustarse al tamaño de los elementos contenidos en cada panel.
      #      * IMPORTANTE el total son 12 columnas para ajustar los dos Paneles,
      #      * se ha usado 5 en el sidebar (grafo) y 7 en el main (tablas).
      sidebarPanel(width = 5,
        fluidRow(
          visNetworkOutput("grafoModeloSEMOut", height = 600) %>% withSpinner()
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
        wellPanel(
          h2("Elementos Detallados"),
          tabsetPanel(type = "tabs",
              tabPanel("Bases - General",h3("Tabla General - PRUEBA"),
                       formattableOutput("tablaGeneralSEMOut", width = "100%")),
              tabPanel("Indices de Ajuste", h3("Valores de indicadores de ajuste obtenidos"),
                       verbatimTextOutput("indicesAjusteSEMTxtOut") %>% withSpinner()),
              tabPanel("SELECCION de NODOS",
                       actionButton("getNodesSelBtn", "LEER Nodos Seleccionados..."),
                       h4("NODOs SELECCIONADOs ACTUALMENTE:"),
                       verbatimTextOutput("nodesListTxtOut") %>% withSpinner())

          )
        ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
