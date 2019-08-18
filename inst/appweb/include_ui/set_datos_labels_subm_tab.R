# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# - actualizacion para adicion del set de datos de las etiquetas del modelo SEM
# 17/08/2019 11:00 a.m.
#
tabItem(tabName = "setDatosLabelSubMTab",
    h2(":: Etiquetas para las variables del modelo SEM"),
    # Elementos de Carga de informacion para el SET de DATOS:
    fluidPage(
      titlePanel("Selecci\u00F3n de la fuente:"),

      sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(width = 3,
            fileInput("fileSEMDataLabels", "Seleccionar Archivo CSV", placeholder = "datos...",
                      buttonLabel = "Buscar...", multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),

            # Horizontal line ----
            tags$hr(),
            fluidRow(
              # Input: Checkbox if file has header ----
              checkboxInput("fileSEMheaderLabels", "Encabezado", TRUE),

              # Input: Select separator ----
              radioButtons("fileSEMsepLabels", "Separador",
                           choices = c(Coma = ",",
                                       "Punto y Coma" = ";",
                                       Espacio = ""),
                           selected = ","),

              # Input: Select quotes ----
              radioButtons("fileSEMquoteLabels", "Comillas",
                           choices = c(Ninguna = "",
                                       "Dobles" = '"',
                                       "Sencillas" = "'"),
                           selected = '"'),

              # Horizontal line ----
              # Input: Select number of rows to display ----
              radioButtons("fileSEMdispLabels", "Presentar",
                           choices = c(Parcial = "head",
                                       Todos = "all"),
                           selected = "all")
            )
        ), # fin sidebarPanel

        # Main panel for displaying outputs ----
        mainPanel(width = 9,
          wellPanel(
            DTOutput('semDataLabelsDTOut', width = "100%", height = "100%")
          ) # FIN wellpanel
        ) # fin main panel
      ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
#
