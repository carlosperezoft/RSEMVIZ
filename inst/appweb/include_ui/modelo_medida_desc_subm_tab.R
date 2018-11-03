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
# Flujo: Sankey, Series (DYGRAPH Comparativo), Streamgraph, ArmsChart Multivariados
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
        visNetworkOutput("grafoModeloMedicionOut", height = 400) %>% withSpinner(type=8, color="cadetblue"),
        title = tagList(shiny::icon("gears"), "Modelo SEM"), width = NULL, # Ancho igual a NULL, ajusta el Box a su contenedor
        collapsible = TRUE, status = "primary", solidHeader = TRUE
    ),
    htmlOutput("nodeSelectedTxtOut"),
    navbarPage("Men\u00FA de Tipos",
       navbarMenu("Distribuci\u00F3n",
         tabPanel("Violin",icon = icon("music"), h4("Violin"),
            plotlyOutput("violinMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
         ),
         tabPanel("Densidad 2D", icon = icon("pause"),h4("Densidad 2D"),
            plotlyOutput("densidad2DMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
         ),
         tabPanel("Histograma", icon = icon("signal"),h4("Histograma"),
            dropdownButton(inputId = "histogramaMedidaOpsBtn",
               tags$h4("Opciones de Presentaci\u00F3n:"),
               awesomeCheckbox(inputId = "histogramaMedidaCheck",
                               label = "Separar Histogramas", value = FALSE, status = "success"),
               selectInput(inputId = 'histogramaMedidaBarraType', label = 'Tipo de Barra',
                           choices = c( "group", "stack", "overlay"), selected = "group"),
               tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
               circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
               size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
            ),
            plotlyOutput("histogramaMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
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
            plotlyOutput("boxplotMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
         ),
         tabPanel("Ridgeline", icon = icon("arrow-right"),h4("Ridgeline (formalmente: Joyplot)"),
            # IMPORTANTE: Para Ridgeline se debe usar la version mas reciente de ggplot2 v 3.0.0
            # -- Adicionalmente, plotly/svgPanZoomOutput no tiene actualmente el WRAPPER para este
            #    tipo de grafico de "ggplot"; por eso usa un "plotOutput" estandar.
            plotOutput("ridgelineMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
         )
       ),
       navbarMenu("Correlaci\u00F3n",
          tabPanel("Dispersi\u00F3n (Scatter)",icon = icon("braille"), h4("Dispersi\u00F3n (Scatter)"),
            plotlyOutput("scatterMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
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
             plotOutput("scatterRegresMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Matriz de Dispersi\u00F3n (SPLOM)",icon = icon("th"), h4("Matriz de Dispersi\u00F3n (SPLOM)"),
             plotlyOutput("splomMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Heatmap", icon = icon("qrcode"),h4("Heatmap"),
             dropdownButton(inputId = "heatmapMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = "heatmapMedidaTransType", label = "Aplicar transformaci\u00F3n",
                            choices = c("Ninguna", "Escalar", "Normalizar", "Porcentualizar"),
                            selected = "Ninguna"),
                selectInput(inputId = 'heatmapMedidaDendroType', label = 'Ver Dendrograma',
                            choices = c('none', 'row', 'column','both'), selected = "none"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotlyOutput("heatmapMedidaPlotOut", width = "100%", height = "700") %>% withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Correlograma", icon = icon("th-large"),h4("Correlograma"),
             dropdownButton(inputId = "correlogramaMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'correlogramaMedidaMethod', label = 'Estilo de Representaci\u00F3n',
                            choices = c("circle", "square", "ellipse", "number", "pie"),
                            selected = "ellipse"),
                selectInput(inputId = 'correlogramaMedidaSection', label = 'Ver Secci\u00F3n',
                            choices = c("full", "lower", "upper"), selected = "upper"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             # IMPORTANTE: corrplot genera un grafico estandar para el cual plotly no tiene WRAPPER...
             plotOutput("correlogramaMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Burbujas", icon = icon("comments"),h4("Burbujas"),
             plotlyOutput("bubleMedidaPlotOut", width = "100%", height = "700") %>% withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Contorno (Densidad 2D)", icon = icon("pause"),h4("Contorno (Densidad 2D)"),
             dropdownButton(inputId = "contornoMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'contornoMedidaMethod', label = 'Estilo de Representaci\u00F3n',
                            choices = c("Poligono", "Contorno", "Espectral"), selected = "Espectral"),
                awesomeCheckbox(inputId = "contornoMedidaPuntosCheck",
                                label = "Ver Puntos de Score", value = FALSE, status = "success"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotlyOutput("contourMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          )
       ),
       navbarMenu("Barras",
          tabPanel("Barras",icon = icon("signal"), h4("Barras"),
             dropdownButton(inputId = "barrasMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "barrasMedidaSortCheck", label = "Ordenar Score",
                               value = FALSE, status = "info", right = TRUE),
                materialSwitch(inputId = "barrasMedidaHorizCheck", label = "Vista Horizontal",
                               value = FALSE, status = "success", right = TRUE),
                materialSwitch(inputId = "barrasMedidaStackCheck", label = "Apilar Barras",
                               value = FALSE, status = "primary", right = TRUE),
                materialSwitch(inputId = "barrasMedidaCursorCheck", label = "Usar cursor Comparativo",
                               value = FALSE, status = "danger", right = TRUE),
                materialSwitch(inputId = "barrasMedidaScrollCheck", label = "Usar barra Horizontal (Zoom)",
                               value = FALSE, status = "warning", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             amChartsOutput("barrasMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Histograma Circular (b\u00E1sico)", icon = icon("stop-circle"), h4("Barras Circulares (b\u00E1sico)"),
             plotOutput("histoBarMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Barras Circular (b\u00E1sico)", icon = icon("stop-circle"), h4("Barras Circulares (b\u00E1sico)"),
             plotOutput("circleBarMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Lollipop", icon = icon("map-pin"), h4("Lollipop"),
             dropdownButton(inputId = "lollipopMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "lollipopMedidaEjesCheck", label = "Intercambiar ejes",
                               value = FALSE, status = "success", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotlyOutput("lollipopMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Coordenadas Paralelas", icon = icon("tasks"), h4("Coordenadas Paralelas"),
             dropdownButton(inputId = "paralelasMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "paralelasMedidaRownameCheck", label = "Usar coordenada de filas",
                               value = FALSE, status = "success", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             parcoordsOutput("paralelasMedidaPlotOut", width = "100%", height = "500") %>%
                 withSpinner(type=4, color="cadetblue") %>%
                 helper(type = "markdown", title = "SEMVIZ: Coordenadas Paralelas", colour = "red",
                        content = "paralelasMedidaPlot_help", size = "m") # size: define el ancho (s,m,l) del "popup"
          )
       ),
       navbarMenu("Jer\u00E1rquicos",
          tabPanel("Treemap",icon = icon("tree"),
             h4("An\u00E1lisis Jer\u00E1rquico de los Score seleccionados del Modelo SEM (Treemap)"),
             plotOutput("treemapMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Dendrograma B\u00E1sico", icon = icon("sitemap"),
             h4("An\u00E1lisis Jer\u00E1rquico para los Score de los elementos seleccionados (Dendrograma-B\u00E1sico)"),
             dropdownButton(inputId = "dendrogramMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "dendrogramMedidaCircleCheck", label = "Vista Circular",
                               value = FALSE, status = "warning", right = TRUE),
                materialSwitch(inputId = "dendrogramMedidaCurvasCheck", label = "Suavizar Enlaces",
                               value = FALSE, status = "info", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             wellPanel(style = "background-color: #ffffff;",
                plotOutput("dendrogramMedidaPlotOut", width = "100%", height = "500") %>%
                      withSpinner(type=5, color="cadetblue")
             )
          ),
          tabPanel("Dendrograma Exploratorio", icon = icon("sitemap"),
             h4("An\u00E1lisis Jer\u00E1rquico para los Score de los elementos seleccionados (Dendrograma-Interactivo)"),
             dropdownButton(inputId = "dendroInterMedidaOpsBtn",
                  tags$h4("Opciones de Presentaci\u00F3n:"),
                  materialSwitch(inputId = "dendroInterMedidaHorizCheck", label = "Vista Horizontal",
                                 value = FALSE, status = "warning", right = TRUE),
                  materialSwitch(inputId = "dendroInterMedidaTriangCheck", label = "Vista Triangular",
                                 value = FALSE, status = "info", right = TRUE),
                  sliderInput(inputId = 'dendroInterMedidaClusters', label = 'N\u00FAmero de Grupos',
                              value = 3, min = 1, max = 7),
                  tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                  circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                  size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             wellPanel(style = "background-color: #ffffff;",
                  plotOutput("dendroInterMedidaPlotOut", width = "100%", height = "600") %>%
                            withSpinner(type=4, color="cadetblue")
             )
          ),
          tabPanel("Dendrograma Comparativo", icon = icon("sitemap"),
             h4("An\u00E1lisis Jer\u00E1rquico para los Score de los elementos seleccionados (Dendrograma-Comparativo)"),
             dropdownButton(inputId = "dendroCompaMedidaOpsBtn",
                  tags$h4("Opciones de Presentaci\u00F3n:"),
                  materialSwitch(inputId = "dendroCompaMedidaTriangCheck", label = "Vista Triangular",
                                 value = FALSE, status = "warning", right = TRUE),
                  sliderInput(inputId = 'dendroCompaMedidaClusters', label = 'N\u00FAmero de Grupos',
                              value = 3, min = 1, max = 7),
                  tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                  circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                  size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             wellPanel(style = "background-color: #ffffff;",
                  plotOutput("dendroCompaMedidaPlotOut", width = "100%", height = "600") %>%
                         withSpinner(type=5, color="cadetblue")
             )
          ),
          tabPanel("Cluster Comparativo", icon = icon("object-group"),
             h4("An\u00E1lisis de Cluster para los Score de los elementos seleccionados (Cluster-Comparativo)"),
             plotlyOutput("clusterMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
          )
       ),
       navbarMenu("Redes",
          tabPanel("Red de Correlaci\u00F3n",icon = icon("connectdevelop"),
             h4("Red de Correlaci\u00F3n (an\u00E1lisis exploratorio/confirmatorio para las variables OBSERVADAS iniciales)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: OBSERVADA"),
             dropdownButton(inputId = "corrnetMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'corrnetMedidaLayout', label = 'Estilo de Representaci\u00F3n',
                            choices = c("circle", "groups", "spring"), selected = "spring"),
                selectInput(inputId = 'corrnetMedidaGraph', label = 'M\u00E9todo de Optimizaci\u00F3n',
                            choices = c("Ninguno", "assosciation", "concentration", "glasso"), selected = "Ninguno"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotOutput("corrnetMedidaPlotOut", width = "600", height = "600") %>%
                         withSpinner(type=4, color="cadetblue") %>%
             helper(type = "markdown", title = "SEMVIZ: Red de Correlaci\u00F3n", colour = "red",
                    content = "redCorrelacionMedidaPlot_help", size = "m") # size: define el ancho (s,m,l) del "popup"
          ),
          tabPanel("Red Hive (Nodos en ejes)", icon = icon("forumbee"),
             h4("Red Hive (Nodos en ejes -- An\u00E1lisis para las variables OBSERVADAS iniciales)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: OBSERVADA"),
             plotOutput("hiveMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Arcos", icon = icon("random"),
             h4("Red Arcos (Nodos en ejes -- An\u00E1lisis para las variables OBSERVADAS iniciales)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: OBSERVADA"),
             plotOutput("arcosMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue")
          )
       ),
       navbarMenu("Evoluci\u00F3n",
          tabPanel("Flujo de cargas de coeficientes (Sankey)",icon = icon("key"),
             h4("An\u00E1lisis de Flujo de cargas de coeficientes del Modelo SEM (Representaci\u00F3n tipo Sankey)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: LATENTE"),
             dropdownButton(inputId = "sankeyMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "sankeyMedidaVerticalCheck", label = "Vista Vertical",
                               value = FALSE, status = "danger", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotlyOutput("sankeyMedidaPlotOut", width = "100%", height = "500") %>%
                                withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("An\u00E1lisis tipo Series (Comparativo)", icon = icon("server"),
             h4("An\u00E1lisis de Flujo de los Score para elementos del Modelo SEM tipo Series (Comparativo)"),
             dropdownButton(inputId = "seriesMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "seriesMedidaStepCheck", label = "Curva paso a paso",
                               value = FALSE, status = "info", right = TRUE),
                materialSwitch(inputId = "seriesMedidaPointCheck", label = "Resaltar puntos",
                               value = FALSE, status = "warning", right = TRUE),
                materialSwitch(inputId = "seriesMedidaAreaCheck", label = "Ver \u00E1reas",
                               value = FALSE, status = "success", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             wellPanel(style = "background-color: #ffffff;",
                 dygraphOutput("seriesMedidaPlotOut", width = "100%", height = "500") %>%
                               withSpinner(type=5, color="cadetblue")
             )
          ),
          tabPanel("An\u00E1lisis tipo Score-Streamgraph", icon = icon("recycle"),
             h4("An\u00E1lisis de Flujo de los Score para elementos del Modelo SEM (Streamgraph)"),
             dropdownButton(inputId = "streamgraphMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                materialSwitch(inputId = "streamgraphMedidaLinealCheck", label = "Flujo Lineal",
                               value = FALSE, status = "success", right = TRUE),
                materialSwitch(inputId = "streamgraphMedidaApilarCheck", label = "Centrar flujos",
                               value = FALSE, status = "warning", right = TRUE),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             wellPanel(style = "background-color: #ffffff;",
                streamgraphOutput("streamgraphMedidaPlotOut", width = "100%", height = "500") %>%
                                   withSpinner(type=5, color="cadetblue")
             )
          ),
          tabPanel("An\u00E1lisis tipo Score-Se\u00F1al", icon = icon("road"),
             h4("An\u00E1lisis de Flujo de los Score para elementos del Modelo SEM (Tipo Se\u00F1al)"),
             plotlyOutput("signalMedidaPlotOut", width = "100%", height = "500") %>%
                           withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("An\u00E1lisis tipo Score-\u00C1reas", icon = icon("align-right"),
             h4("An\u00E1lisis de Flujo de los Score para elementos del Modelo SEM (\u00C1reas apiladas)"),
             plotlyOutput("stackedAreaMedidaPlotOut", width = "100%", height = "500") %>%
                           withSpinner(type=5, color="cadetblue")
          )
       ),
       navbarMenu("Circularizar",
          tabPanel("Circular Packing de un Nivel", icon = icon("circle"),
             h4("An\u00E1lisis Circular Packing de un nivel para los Score de los elementos seleccionados"),
             plotlyOutput("circlePackOneLevelMedidaPlotOut", width = "100%", height = "500") %>%
                         withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Circular Packing Jer\u00E1rquico", icon = icon("circle"),
             h4("An\u00E1lisis Jer\u00E1rquico del Flujo de cargas de coeficientes del Modelo SEM (Circular Packing)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: LATENTE"),
             circlepackeROutput("circlePackJerarqMedidaPlotOut", width = "100%", height = "500") %>%
                                withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Circular Packing (Dendrograma)",icon = icon("pause-circle"),
              h4("An\u00E1lisis Jer\u00E1rquico para los Score de los elementos seleccionados (Dendrograma-Comparativo)"),
              circlepackeROutput("circlePackDendroMedidaPlotOut", width = "100%", height = "500") %>%
                                withSpinner(type=4, color="cadetblue")
          ),
          tabPanel("Sunburst Jer\u00E1rquico", icon = icon("instagram"),
              h4("An\u00E1lisis Jer\u00E1rquico del Flujo de cargas de coeficientes del Modelo SEM (Sunburst-Comparativo)"),
              tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: LATENTE"),
              plotOutput("circlePackSunMedidaPlotOut", width = "100%", height = "500") %>%
                         withSpinner(type=5, color="cadetblue")
          ),
          tabPanel("Diagrama de Cuerdas", icon = icon("life-ring"),
              h4("An\u00E1lisis del Flujo de cargas de coeficientes del Modelo SEM (Flujo entre Cuerdas)"),
              tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: LATENTE"),
              fluidRow(
                box(
                  title = "Cargas de Coeficientes", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput("chordCoefiMedidaPlotOut", width = "100%", height = "400") %>%
                            withSpinner(type=4, color="cadetblue")
                ),
                box(
                  title = "Correlaciones por variable", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput("chordCorrMedidaPlotOut", width = "100%", height = "400") %>%
                            withSpinner(type=4, color="cadetblue")
                )
              ) # FIN fluidRow
          )
       )
    )  # FIN PANEL navbarPage
  ) # FIN PANEL fluidPage
) # FIN PANEL tabItem
