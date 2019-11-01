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
             choices = c("ML   [Maximum Likelihood. * Asume normalidad Multivariada]" = 1,
               "GLS  [Generalized Least Squares. * Usando datos completos]" = 2,
               "WLS  [Weighted Least Squares. * Usando datos completos]" = 3,
               "ULS  [Unweighted Least Squares]" = 4,
               "DWLS [Diagonally Weighted Least Squares]" = 5
             ),
             selected = 1
          ),
          actionBttn("runSEMBtn", "Ejecutar...", style = "gradient", color = "primary")
        )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(
        tabBox(width = "100%", height = "100%",
               title = tagList(shiny::icon("calculator"), "Estimaci\u00F3n por medio de LAVAAN"),
          tabPanel("Resumen General",h4("Informaci\u00F3n General (Estimaci\u00F3n del Modelo)"),
            # Input: Indica el uso de datos estandarizados ----
            awesomeCheckbox("modSEMStandChk", "Estandarizado", TRUE),
            verbatimTextOutput("modeloSEMLavaanTxtOut") %>% withSpinner()
          ),
          tabPanel("Puntuaciones (Score)",
            h4("Puntuaciones (Score) estimadas para variables Observadas y Latentes:"),
            DTOutput('semScoreDataDTOut', width = "100%", height = "100%") %>% withSpinner()
          )
        ) # FIN tabBox
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
