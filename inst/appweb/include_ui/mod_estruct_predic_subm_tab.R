# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 04/11/2018 1:12:31 p. m.
#
tabItem(tabName = "modEstPredSubMTab",
  h2(":: Modelo de Estructural - SEM"),
  fluidPage(
    titlePanel("An\u00E1lisis de Puntuaciones (Score) para variables Latentes End\u00F3genas (Regresi\u00F3n)"),
    materialSwitch(inputId = "modeloLinealPanelToggle", label = tags$b("VER Preguntas de An\u00E1lisis..."),
                   value = FALSE, status = "success", right = TRUE),
    fluidRow(id="modeloLinealTabSet",
       box(actionButton("selectedNodesEstructuralBtn", "Actualizar gr\u00E1ficos asociados..."),
          visNetworkOutput("grafoModeloEstructuralOut", height=400) %>% withSpinner(type=8, color="cadetblue"),
          title = tagList(shiny::icon("gears"), "Modelo SEM"),  status = "success",
          collapsible = TRUE, solidHeader = TRUE, width = 5 # width: es por columnas en Shiny, de 1 a 12
        ),
        tabBox(height = 400, width = 7,
          title = tagList(shiny::icon("gear"), "Observado vs Score"),
          tabPanel("Flujo (Series)",
             dropdownButton(inputId = "seriesEstructOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "seriesEstructStepCheck", label = "Curva paso a paso",
                               value = FALSE, status = "info", right = TRUE),
                materialSwitch(inputId = "seriesEstructPointCheck", label = "Resaltar puntos",
                               value = FALSE, status = "warning", right = TRUE),
                materialSwitch(inputId = "seriesEstructAreaCheck", label = "Ver \u00E1reas",
                               value = FALSE, status = "success", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             dygraphOutput("seriesEstructuralPlotOut", width = "100%", height = "500") %>%
                          withSpinner(type=6, color="cadetblue")
          ),
          tabPanel("Barras",
             dropdownButton(inputId = "barrasEstructOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "barrasEstructSortCheck", label = "Ordenar Datos",
                               value = FALSE, status = "info", right = TRUE),
                materialSwitch(inputId = "barrasEstructHorizCheck", label = "Vista Horizontal",
                               value = FALSE, status = "success", right = TRUE),
                materialSwitch(inputId = "barrasEstructStackCheck", label = "Apilar Barras",
                               value = FALSE, status = "primary", right = TRUE),
                materialSwitch(inputId = "barrasEstructCursorCheck", label = "Usar cursor Comparativo",
                               value = FALSE, status = "danger", right = TRUE),
                materialSwitch(inputId = "barrasEstructScrollCheck", label = "Usar barra Horizontal (Zoom)",
                               value = FALSE, status = "warning", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             amChartsOutput("barrasEstructuralPlotOut", width = "100%", height = "500") %>%
                           withSpinner(type=7, color="cadetblue")
          )
       )
    ),
    box(htmlOutput("estructuralSelectedNodesTxtOut"), hr(),
      tags$div(tags$style(HTML( ".selectize-dropdown, .selectize-dropdown.form-control{z-index:10000;}"))),
      selectInput("pregEstructuralSel", tags$b("Preguntas de an\u00E1lisis:"), width = "60%",
        choices = c("1. \u00BFLos score estimados tienen diferencias significativas con respecto a los valores observados?"=1,
          "2. \u00BFLos valores de predicci\u00F3n para los constructos permiten obtener inferencias importantes?"=2,
          "3. \u00BFQu\u00E9 tipos y niveles de significancia se tienen entre las mediaciones de los constructos?"=3
        )
      ), title = tagList(shiny::icon("list"), "Nodos SEM Seleccionados"), status="warning",
         collapsible=TRUE, solidHeader=TRUE, width=NULL # NULL, ajusta el Box a su contenedor
    ),
    navbarPage("An\u00E1lisis Gr\u00E1fico:", id = "estructRegMenu",
      navbarMenu("Estimaci\u00F3n", menuName="estimaMenu",
        tabPanel("Densidad 2D", icon = icon("pause"),
           h4("An\u00E1lisis de densidad 2D para datos Observados (izquierda) vs Score Estimados (derecha)"),
           plotlyOutput("densidad2DEstructPlotOut", width = "100%", height = "500") %>%
                        withSpinner(type=6, color="cadetblue")
        )
      ),
      navbarMenu("Predicci\u00F3n", menuName="predicMenu",
        tabPanel("Predicci\u00F3n Latentes", icon = icon("paper-plane"),
           h4("An\u00E1lisis de Predicci\u00F3n sobre las variables LANTENTES del Modelo SEM"),
           tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM una variable LATENTE"),
           fluidRow(
              box(title = "Flujo de Latente.Score", status = "success", solidHeader = TRUE, collapsible = TRUE,
                dygraphOutput("prediccionSeriesEstructPlotOut", width = "100%", height = "400") %>%
                              withSpinner(type=6, color="cadetblue")
              ),
              box(title = "Dispersi\u00F3n de Latente.Score con curva de ajuste", status = "primary",
                  solidHeader = TRUE, collapsible = TRUE,
                  plotlyOutput("prediccionScatterEstructPlotOut", width = "100%", height = "400") %>%
                              withSpinner(type=7, color="cadetblue")
              )
           ) # FIN fluidRow
        )
      ),
      navbarMenu("Mediaci\u00F3n", menuName="mediacMenu",
        tabPanel("Mediaci\u00F3n-Regresi\u00F3n Latentes", icon = icon("recycle"),
           h4("An\u00E1lisis de Mediaci\u00F3n-Regresi\u00F3n sobre las variables LANTENTES del Modelo SEM"),
           tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM tres variables LATENTES"),
           fluidRow(
              box(title = "Flujo de Latente.Score A", status = "success", solidHeader = TRUE, collapsible = TRUE,
                dygraphOutput("mediacionRegreSerie1APlotOut", width = "100%", height = "400") %>%
                              withSpinner(type=6, color="cadetblue")
              ),
              box(title = "Flujo de Latente.Score B", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                dygraphOutput("mediacionRegreSerie2BPlotOut", width = "100%", height = "400") %>%
                              withSpinner(type=7, color="cadetblue")
              ),
              box(title = "Flujo de Latente.Score C", status = "warning", solidHeader = TRUE, collapsible = TRUE,
                dygraphOutput("mediacionRegreSerie3CPlotOut", width = "100%", height = "400") %>%
                              withSpinner(type=6, color="cadetblue")
              ),
              box(title = "Datos Seleccionados Mediaci\u00F3n-Regresi\u00F3n", status = "danger",
                solidHeader = TRUE, collapsible = TRUE,
                div(strong("Desde: "), textOutput("medRegSer1AFrom", inline = TRUE)),
                div(strong("Hasta: "), textOutput("medRegSer1ATo", inline = TRUE)),
                ">> Latente.Score A <<",
                div(strong("Observaci\u00F3n seleccionada: "), textOutput("medRegSer1AClicked", inline = TRUE)),
                div(strong("Score seleccionado: "), textOutput("medRegSer1APoint", inline = TRUE)),
                ">> Latente.Score B <<",
                div(strong("Observaci\u00F3n seleccionada: "), textOutput("medRegSer2BClicked", inline = TRUE)),
                div(strong("Score seleccionado: "), textOutput("medRegSer2BPoint", inline = TRUE)),
                ">> Latente.Score C <<",
                div(strong("Observaci\u00F3n seleccionada: "), textOutput("medRegSer3CClicked", inline = TRUE)),
                div(strong("Score seleccionado: "), textOutput("medRegSer3CPoint", inline = TRUE))
              )
           ) # FIN fluidRow
        )
      )
    )  # FIN PANEL navbarPage
  ) # FIN PANEL fluidPage
) # FIN PANEL tabItem
