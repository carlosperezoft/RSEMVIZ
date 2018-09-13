# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 12/09/2018 10:47:28 a. m.
#
tabItem(tabName = "modMedDesSubMTab",
  h2(":: Uso de Redes Psicometricas"),
  fluidPage(

    titlePanel("An\u00E1lisis de elementos del modelo SEM"),

    navlistPanel(
      "--- An\u00E1lisis General ---",
      # NOTA: Es necesario especificar un ancho y un alto para el Plot,
      # ya sea en la UI o en el server. Aqui se ha usado "auto" en ambios.
      tabPanel("Grafo por Grupos", h3("Variables Observadas como nodos, agrupadas por Constructo"),
               plotOutput("personBig5Plot",'auto','auto') %>% withSpinner()),

      # NOTA: Es necesario especificar un ancho y un alto para el Plot,
      # ya sea en la UI o en el server. Aqui se ha usado 100% en ancho, y 500 en alto.
      tabPanel("Grafo tipo Cluster", h3("Variables Observadas como nodos, agrupadas por Constructo"),
               plotOutput("personClusterPlot",width = "750px", height = "600px") %>% withSpinner()),
      "--- An\u00E1lisis Especifico ---",
      tabPanel("Grafo PSICO: GLASSO", h3("Variables Observadas como nodos, agrupadas por Constructo"),
               plotOutput("personPSICOPlot",width = "100%", height = "500px") %>% withSpinner()),
      tabPanel("Grafo RED PSICO :: Concentraci\u00F3n de Nodos",
               h3("Variables Observadas como nodos, agrupadas por Constructo"),
               plotOutput("personPSICOFactorPlot",width = "100%", height = "500px") %>% withSpinner()),
      tabPanel("Grafo PSICO :: Centralidad",
               h3("Variables Observadas como nodos, agrupadas por Constructo"),
               plotOutput("personPSICOCentraPlot",width = "100%", height = "500px") %>% withSpinner()),
      tabPanel("Grafo Dirigido del Modelo SEM", h3("RED de grafo dirigido simple"),
               plotOutput("personGraDirPlot",width = "600px", height = "600px") %>% withSpinner())

    )
  )
)
