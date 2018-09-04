# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 03/09/2018 04:47:28 p. m.
#
tabItem(tabName = "setDatosSubMTab",
    h2(":: SET de DATOS"),
    # Elementos de Carga de informacion para el SET de DATOS:
    fluidPage(
      titlePanel("Selecci\u00F3n de la fuente:"),

      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(
            fileInput("fileSEMData", "Seleccionar Archivo CSV", placeholder = "datos...",
                      buttonLabel = "Buscar...", multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),

            # Horizontal line ----
            tags$hr(),
            fluidRow(
              # Input: Checkbox if file has header ----
              checkboxInput("fileSEMheader", "Encabezado", TRUE),

              # Input: Select separator ----
              radioButtons("fileSEMsep", "Separador",
                           choices = c(Coma = ",",
                                       "Punto y Coma" = ";",
                                       Espacio = ""),
                           selected = ","),

              # Input: Select quotes ----
              radioButtons("fileSEMquote", "Comillas",
                           choices = c(Ninguna = "",
                                       "Dobles" = '"',
                                       "Sencillas" = "'"),
                           selected = '"'),

              # Horizontal line ----
              # Input: Select number of rows to display ----
              radioButtons("fileSEMdisp", "Presentar",
                           choices = c(Parcial = "head",
                                       Todos = "all"),
                           selected = "all")
            )
        ), # fin sidebarPanel

        # Main panel for displaying outputs ----
        mainPanel(
          wellPanel(
            DTOutput('semDataDTOut', width = "100%", height = "100%")
          ) # FIN wellpanel
        ) # fin main panel
      ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
