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
         tabPanel("Violin",icon = icon("music"), h3("Violin"),
            plotlyOutput("violinMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Densidad 2D", icon = icon("pause"),h3("Densidad 2D"),
            plotlyOutput("densidad2DMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Histograma", icon = icon("signal"),h3("Histograma"),
            plotlyOutput("histogramaMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Boxplot", icon = icon("square"), h3("Boxplot"),
            # NOTA: Size of the button: lg, sm, xs.
            #       status like: 'info', 'primary', 'danger', 'warning' or 'success'.
            dropdownButton(inputId = "boxplotMedidaOpsBtn",
               tags$h4("Opciones de Presentaci\u00F3n:"),
               awesomeCheckbox(inputId = "boxplotMedidaJitterCheck",
                               label = "Ver Puntos de Score", value = TRUE, status = "success"),
               tags$h5("Usar la opciones gr\u00E1ficas..."),
               circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
               size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
            ),
            plotlyOutput("boxplotMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         ),
         tabPanel("Ridgeline", icon = icon("arrow-right"),h3("Ridgeline (formalmente: Joyplot)"),
            # IMPORTANTE: Se debe usar la version mas reciente de ggplot2 v 3.0.0
            # -- Adicionalmente, plotly no tiene actualmente el WRAPPER para este tipo de grafico
            #    por eso usa un "plotOut" estandar.
            plotOutput("ridgelineMedidaPlotOut", width = "100%", height = "500") %>% withSpinner()
         )
       ),
       navbarMenu("Correlaci\u00F3n",
          tabPanel("Scatter (SPLOM, Biplot)",icon = icon("th"), h3("Scatter (SPLOM, Biplot)"),
             plotlyOutput("splomPlotOut", width = "500", height = "500") %>% withSpinner()
          ),
          tabPanel("Heatmap", icon = icon("qrcode"),h3("Heatmap")
                   # ...
          ),
          tabPanel("Correlograma", icon = icon("th-large"),h3("Correlograma")
                   # ...
          ),
          tabPanel("Burbujas", icon = icon("comments"),h3("Burbujas")
                   # ...
          ),
          tabPanel("Densidad 2D", icon = icon("pause"),h3("Densidad 2D")
                   # ...
          )
       ),
       navbarMenu("Barras",
          tabPanel("Barras",icon = icon("signal"), h3("Barras")
                   #  ...
          ),
          tabPanel("Coordenadas Paralelas (estatico)", icon = icon("tasks"),h3("Coordenadas Paralelas (estatico)")
                   # ...
          ),
          tabPanel("Circular Barplot (basico)", icon = icon("stop-circle"),h3("Circular Barplot (b\u00E1sico)")
                   # ...
          ),
          tabPanel("Lollipop", icon = icon("map-pin"),h3("Lollipop")
                   # ...
          )
       ),
       navbarMenu("Jer\u00E1rquicos",
          tabPanel("Treemap",icon = icon("tree"), h3("Treemap")
                   #  ...
          ),
          tabPanel("Dendrograma", icon = icon("sitemap"),h3("Dendrograma")
                   # ...
          ),
          tabPanel("Cluster", icon = icon("object-group"),h3("Cluster")
                   # ...
          ),
          tabPanel("QQ-Plot (odenando ASC score)", icon = icon("minus-square"),h3("QQ-Plot (odenando ASC score)")
                   # ...
          )
       ),
       navbarMenu("Redes",
          tabPanel("qgraph (CORR, SPRING, LASSO)",icon = icon("connectdevelop"), h3("qgraph (CORR, SPRING, LASSO)")
                   #  ...
          ),
          tabPanel("Hive (3-lineas)", icon = icon("forumbee"),h3("Hive (3-lineas)")
                   # ...
          ),
          tabPanel("Arcos", icon = icon("random"),h3("Arcos")
                   # ...
          )
       ),
       navbarMenu("Evoluci\u00F3n",
          tabPanel("Sandkey",icon = icon("key"), h3("Sandkey")
                   #  ...
          ),
          tabPanel("Series (DYGRAPH Comparativo)", icon = icon("server"),h3("Series (DYGRAPH Comparativo)")
                   # ...
          ),
          tabPanel("Streamgraph", icon = icon("road"),h3("Streamgraph")
                   # ...
          ),
          tabPanel("ArmsChart Multivariados", icon = icon("pause"),h3("ArmsChart Multivariados")
                   # ...
          )
       ),
       navbarMenu("Circularizar",
          tabPanel("Circular Barplot (avanzado)",icon = icon("pause-circle"), h3("Circular Barplot (avanzado)")
                   #  ...
          ),
          tabPanel("Circular Packing", icon = icon("circle"),h3("Circular Packing")
                   # ...
          ),
          tabPanel("Sunburst", icon = icon("instagram"),h3("Sunburst")
                   # ...
          ),
          tabPanel("Diagrama de Cuerdas", icon = icon("life-ring"),h3("Diagrama de Cuerdas")
                   # ...
          ),
          tabPanel("visNetwork (Cirular Layout)", icon = icon("exclamation-circle"),h3("visNetwork (Cirular Layout)")
                   # ...
          ),
          tabPanel("Circular Dendrograma (avanzado)", icon = icon("question-circle"),h3("Circular Dendrograma (avanzado)")
                   # ...
          )
       )
    )  # FIN PANEL navbarPage
  ) # FIN PANEL fluidPage
) # FIN PANEL tabItem
