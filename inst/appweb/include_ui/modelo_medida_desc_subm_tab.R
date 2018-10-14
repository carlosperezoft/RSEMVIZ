# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/10/2018 17:36:28 a. m.
#
# Distribuci\u00F3n: Violin, Densidad (2D), Histograma, Boxplot, Ridgeline
# Correlaci\u00F3n (Matrices): Scatter (SPLOM, Biplot), Heatmap, Correlograma, Burbujas, Densidad 2D, Scatter ptos-conectadas-lineas
# Barras: Barras, Coordenadas Paralelas (estatico), Circular Barplot (basico), Lollipop
# Jerárquicos: Treemap, Dendrograma, Cluster, QQ-Plot (odenando ASC score)
# Redes: qgraph (CORR, SPRING, LASSO), Hive (3-lineas), Arcos
# Evoluci\u00F3n: Stacked Area, Lineas, Lineas+Areas, Coordenadas Paralelas (interactivo)
# Flujo: Sandkey, Series (DYGRAPH Comparativo), Streamgraph, ArmsChart Multivariados
# Circularizar: Circular Barplot (avanzado), Circular Packing, Sunburst, Diagrama de Cuerdas,
# visNetwork (Cirular Layout), Circular Dendrograma (avanzado)
#
# Factor
# Descripci\u00F3n (Score Analysis):
#   Score Observadas, Score Factor
# Predicci\u00F3n (Simulaci\u00F3n):
#
# Structural
# Descripci\u00F3n (Score Analysis):
#   Score Regression
# Predicci\u00F3n (Simulaci\u00F3n):
#
#
tabItem(tabName = "modMedDesSubMTab",
  h2(":: Modelo de Medici\u00F3n - SEM"),
  fluidPage(
    titlePanel("An\u00E1lisis de Puntuaciones (Score) para variables Latentes Ex\u00F3genas y variables Observadas"),
    box(actionButton("selectedNodesModMedicionBtn", "Actualizar Nodos Seleccionados..."),
        visNetworkOutput("grafoModeloMedicionOut", height = 400) %>% withSpinner(),
        title = tagList(shiny::icon("gears"), "Modelo SEM"), width = NULL, # Ancho igual a NULL, ajusta el Box a su contenedor
        collapsible = TRUE, status = "primary", solidHeader = TRUE
    ),
    htmlOutput("nodeSelectedTxtOut"),
    navbarPage("Men\u00FA de Tipos",
       navbarMenu("Distribuci\u00F3n",
         tabPanel("Violin",icon = icon("music"), h4("Violin"),
            plotlyOutput("violinMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Densidad 2D", icon = icon("pause"),h4("Densidad 2D"),
            plotlyOutput("densidad2DMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Histograma", icon = icon("signal"),h4("Histograma"),
            plotlyOutput("histogramaMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Boxplot", icon = icon("square"), h4("Boxplot"),
            # NOTA: Size of the button: lg, sm, xs.
            #       status like: 'info', 'primary', 'danger', 'warning' or 'success'.
            dropdownButton(inputId = "boxplotMedidaOpsBtn",
               tags$h4("Opciones de Presentaci\u00F3n:"),
               awesomeCheckbox(inputId = "boxplotMedidaJitterCheck",
                               label = "Ver Puntos de Score", value = TRUE, status = "success"),
               tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
               circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
               size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
            ),
            plotlyOutput("boxplotMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Ridgeline", icon = icon("arrow-right"),h4("Ridgeline (formalmente: Joyplot)"),
            # IMPORTANTE: Para Ridgeline se debe usar la version mas reciente de ggplot2 v 3.0.0
            # -- Adicionalmente, plotly/svgPanZoomOutput no tiene actualmente el WRAPPER para este
            #    tipo de grafico de "ggplot"; por eso usa un "plotOutput" estandar.
            plotOutput("ridgelineMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         )
       ),
       navbarMenu("Correlaci\u00F3n",
          tabPanel("Dispersi\u00F3n (Scatter)",icon = icon("braille"), h4("Dispersi\u00F3n (Scatter)"),
            plotlyOutput("scatterMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
          ),
          tabPanel("Dispersi\u00F3n (Regresi\u00F3n)",icon = icon("braille"), h4("Dispersi\u00F3n (Regresi\u00F3n)"),
             dropdownButton(inputId = "scatterRegresMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'scatterRegresMedidaType', label = 'Complemantos al margen',
                            choices = c("density", "histogram", "boxplot", "violin"), selected = "density"),
                selectInput(inputId = 'scatterRegresMedidaMargins', label = 'Usar margen',
                            choices = c("both", "x", "y"), selected = "both"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             # IMPORTANTE: plotly actualmente no tiene el WRAPPER para ggExtra (ggMarginal).
             # --> Por eso usa un "plotOutput" estandar.
             plotOutput("scatterRegresMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
          ),
          tabPanel("Matriz de Dispersi\u00F3n (SPLOM)",icon = icon("th"), h4("Matriz de Dispersi\u00F3n (SPLOM)"),
             plotlyOutput("splomMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
          ),
          tabPanel("Heatmap", icon = icon("qrcode"),h4("Heatmap")
                   # ...
          ),
          tabPanel("Correlograma", icon = icon("th-large"),h4("Correlograma")
                   # ...
          ),
          tabPanel("Burbujas", icon = icon("comments"),h4("Burbujas")
                   # ...
          ),
          tabPanel("Densidad 2D", icon = icon("pause"),h4("Densidad 2D")
                   # ...
          )
       ),
       navbarMenu("Barras",
          tabPanel("Barras",icon = icon("signal"), h4("Barras")
                   #  ...
          ),
          tabPanel("Coordenadas Paralelas (estatico)", icon = icon("tasks"),h4("Coordenadas Paralelas (estatico)")
                   # ...
          ),
          tabPanel("Circular Barplot (basico)", icon = icon("stop-circle"),h4("Circular Barplot (b\u00E1sico)")
                   # ...
          ),
          tabPanel("Lollipop", icon = icon("map-pin"),h4("Lollipop")
                   # ...
          )
       ),
       navbarMenu("Jer\u00E1rquicos",
          tabPanel("Treemap",icon = icon("tree"), h4("Treemap")
                   #  ...
          ),
          tabPanel("Dendrograma", icon = icon("sitemap"),h4("Dendrograma")
                   # ...
          ),
          tabPanel("Cluster", icon = icon("object-group"),h4("Cluster")
                   # ...
          ),
          tabPanel("QQ-Plot (odenando ASC score)", icon = icon("minus-square"),h4("QQ-Plot (odenando ASC score)")
                   # ...
          )
       ),
       navbarMenu("Redes",
          tabPanel("qgraph (CORR, SPRING, LASSO)",icon = icon("connectdevelop"), h4("qgraph (CORR, SPRING, LASSO)")
                   #  ...
          ),
          tabPanel("Hive (3-lineas)", icon = icon("forumbee"),h4("Hive (3-lineas)")
                   # ...
          ),
          tabPanel("Arcos", icon = icon("random"),h4("Arcos")
                   # ...
          )
       ),
       navbarMenu("Evoluci\u00F3n",
          tabPanel("Sandkey",icon = icon("key"), h4("Sandkey")
                   #  ...
          ),
          tabPanel("Series (DYGRAPH Comparativo)", icon = icon("server"),h4("Series (DYGRAPH Comparativo)")
                   # ...
          ),
          tabPanel("Streamgraph", icon = icon("road"),h4("Streamgraph")
                   # ...
          ),
          tabPanel("ArmsChart Multivariados", icon = icon("pause"),h4("ArmsChart Multivariados")
                   # ...
          )
       ),
       navbarMenu("Circularizar",
          tabPanel("Circular Barplot (avanzado)",icon = icon("pause-circle"), h4("Circular Barplot (avanzado)")
                   #  ...
          ),
          tabPanel("Circular Packing", icon = icon("circle"),h4("Circular Packing")
                   # ...
          ),
          tabPanel("Sunburst", icon = icon("instagram"),h4("Sunburst")
                   # ...
          ),
          tabPanel("Diagrama de Cuerdas", icon = icon("life-ring"),h4("Diagrama de Cuerdas")
                   # ...
          ),
          tabPanel("visNetwork (Cirular Layout)", icon = icon("exclamation-circle"),h4("visNetwork (Cirular Layout)")
                   # ...
          ),
          tabPanel("Circular Dendrograma (avanzado)", icon = icon("question-circle"),h4("Circular Dendrograma (avanzado)")
                   # ...
          )
       )
    )  # FIN PANEL navbarPage
  ) # FIN PANEL fluidPage
) # FIN PANEL tabItem
