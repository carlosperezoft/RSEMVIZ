# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
#
tabItem(tabName = "modeloSEMTab",
  h2(":: MODELO SEM"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("Especificar el Modelo SEM para el an\u00E1lisis"),

    sidebarLayout(

      # Sidebar panel for inputs ----
      sidebarPanel(
        fluidRow(
          textAreaInput("modeloSEMTxt", label = h4("Usar sint\u00E1xis tipo R-Lavaan:"),
                        value = "", cols = 2, rows = 10),

          # Input: Indica el tipo de Estimacion ----
          radioButtons("tipoEstimacionSEM", "Tipo de Estimaci\u00F3n:",
             choices = c("ML   [Maximum Likelihood]" = 1,
               "GLS  [Generalized Least Squares. * Usando datos completos]" = 2,
               "WLS  [Weighted Least Squares. * Usando datos completos]" = 3,
               "ULS  [Unweighted Least Squares]" = 4,
               "DWLS [Diagonally Weighted Least Squares]" = 5
             ),
             selected = 1
          ),
          actionButton("runSEMBtn", "Ejecutar...")
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(
        wellPanel(
          h2("General Tabular (Estimaci\u00F3n del Modelo)"),
          # Input: Indica el uso de datos estandarizados ----
          checkboxInput("modSEMStandChk", "Estandarizado", TRUE),
          verbatimTextOutput("modeloSEMLavaanTxtOut") %>% withSpinner()
        ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
