# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
#
tabItem(tabName = "modeloSEMTab",
  h2(":: MODELO EN SINTAXIS LAVAAN"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("Especificar el MODELO SEM:"),

    sidebarLayout(

      # Sidebar panel for inputs ----
      sidebarPanel(
        fluidRow(
          textAreaInput("modeloSEMTxt", label = h3("Modelo SEM a Procesar:"),
                        value = "", cols = 2, rows = 10),

          # Input: Indica el uso de datos estandarizados ----
          checkboxInput("modeloSEMTab", "Estandarizado", TRUE),


          # Input: Indica el tipo de Estimacion ----
          radioButtons("tipoEstimacionSEM", "Tipo de Estimaci\u00F3n:",
               choices = c(auto = "auto", ML = "ML", GLS = "GLS", WLS = "WLS",
                           ULS = "ULS", DWLS = "DWLS"),
               selected = 'auto'),
          actionButton("runSEMBtn", "Ejecutar...")
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(
        wellPanel(
          h2("General Tabular (Estimaci\u00F3n del Modelo)"),
          verbatimTextOutput("modeloSEMLavaanTxtOut") %>% withSpinner()
        ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
