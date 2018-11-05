# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 04/11/2018 1:12:31 p. m.
#
tabItem(tabName = "modEstPredSubMTab",
  h2(":: Modelo de Estructural - SEM"),
  fluidPage(
    titlePanel("An\u00E1lisis de Puntuaciones (Score) para variables Latentes End\u00F3genas (Regresi\u00F3n)"),
    materialSwitch(inputId = "modeloLinealPanelToggle", label = tags$b("USAR An\u00E1lisis Detallado..."),
                   value = FALSE, status = "success", right = TRUE),
    fluidRow(id="modeloLinealTabSet",
       box(actionButton("selectedNodesEstructuralBtn", "Actualizar Nodos Seleccionados..."),
          visNetworkOutput("grafoModeloEstructuralOut", height=400) %>% withSpinner(type=8, color="cadetblue"),
          title = tagList(shiny::icon("gears"), "Modelo SEM"),  status = "success",
          collapsible = TRUE, solidHeader = TRUE, width = 6 # width: es por columnas en Shiny, de 1 a 12
        ),
        tabBox(height = 400,
          title = tagList(shiny::icon("gear"), "Observado vs Score"),
          tabPanel("Flujo (Series)",
             dygraphOutput("seriesEstructuralPlotOut", width = "100%", height = "500") %>%
                          withSpinner(type=6, color="cadetblue")
          ),
          tabPanel("Barras",
             amChartsOutput("barrasEstructuralPlotOut", width = "100%", height = "500") %>%
                           withSpinner(type=7, color="cadetblue")
          )
       )
    ),
    box(htmlOutput("estructuralSelectedNodesTxtOut"),
        title = tagList(shiny::icon("list"), "Nodos SEM Seleccionados"), status="warning",
        collapsible=TRUE, solidHeader=TRUE, width=NULL # NULL, ajusta el Box a su contenedor
    ),
    navbarPage("An\u00E1lisis Gr\u00E1fico:",
      navbarMenu("Estimaci\u00F3n",
        tabPanel("Violin",icon = icon("music"), h4("Violin")
           #plotlyOutput("violinMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=6, color="cadetblue")
        ),
        tabPanel("Densidad 2D", icon = icon("pause"),h4("Densidad 2D")
           #plotlyOutput("densidad2DMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=7, color="cadetblue")
        )
      ),
      navbarMenu("Predicci\u00F3n",
        tabPanel("Violin",icon = icon("music"), h4("Violin")
          #plotlyOutput("violinMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=6, color="cadetblue")
        ),
        tabPanel("Densidad 2D", icon = icon("pause"),h4("Densidad 2D")
          #plotlyOutput("densidad2DMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=7, color="cadetblue")
        )
      )
    )  # FIN PANEL navbarPage
  ) # FIN PANEL fluidPage
) # FIN PANEL tabItem
