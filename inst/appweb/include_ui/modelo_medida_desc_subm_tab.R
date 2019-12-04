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
    box(actionButton("selectedNodesModMedicionBtn", "Actualizar gr\u00E1ficos asociados..."),
        visNetworkOutput("grafoModeloMedicionOut", height=350) %>% withSpinner(type=8, color="cadetblue"),
        title = tagList(shiny::icon("gears"), "Modelo SEM"), status="primary",
        collapsible=TRUE, solidHeader=TRUE, width=NULL # NULL, ajusta el Box a su contenedor
    ) %>%
    popify(title = "Modelo SEM Interactivo",
        content = "Seleccione usando CTRL+clic los elementos que desea analizar...",
        placement = "top", trigger = "hover"),
    box(htmlOutput("medicionSelectedNodesTxtOut"), hr(),
      materialSwitch(inputId = "convenModelMedicionSwitch", label = tags$b("Ver Convenciones"),
                     status = "info", right = TRUE, value = FALSE),
      shinyjs::hidden( # Inicialmente oculta las convenciones:
        # Usar el DIV es mejor para shiny-js y el materialSwitch:
        div(id="convenModelMedicionDIV", tags$b("Convenciones de Elementos SEM presentados:"),
            formattableOutput("convenModelMedicionTablaOut", width = "70%") %>% withSpinner(type=5, color="cadetblue")
        )
      ),
      tags$div(tags$style(HTML( ".selectize-dropdown, .selectize-dropdown.form-control{z-index:10000;}"))),
      selectInput("preguntasBaseSel", tags$b("Preguntas de an\u00E1lisis:"),
                   width = "60%", selected = 0,
        choices = c("NO TENGO Dudas..."=0,
          "1. \u00BFC\u00F3mo ser\u00E1n las distribuciones de los Score estimados?"=1,
          "2. \u00BFLas correlaciones entre los score estimados son significativas?"=2,
          "3. \u00BFAl comparar los score por ranquin hay diferencias significativas?"=3,
          "4. \u00BFC\u00F3mo son las agrupaciones de los score de forma jer\u00E1rquica?"=4,
          "5. \u00BFLas variables observadas confirman dependencias entre constructos?"=5,
          "6. \u00BFLas cargas de factores y constructos sobre sus variables dependientes son significativas?"=6,
          "7. \u00BFLos patrones de asociaci\u00F3n entre variables son significativos?"=7
        )
      ), title = tagList(shiny::icon("list"), "Nodos SEM Seleccionados"), status="warning",
      collapsible=TRUE, solidHeader=TRUE, width=NULL # NULL, ajusta el Box a su contenedor
    ),
    navbarPage("An\u00E1lisis Gr\u00E1fico:", id = "medidaDescMenu",
       navbarMenu("Distribuci\u00F3n", menuName="distribMenu",
         tabPanel("Viol\u00EDn",icon = icon("music"), h4("Viol\u00EDn"),
            plotlyOutput("violinMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
            bsPopover(id="violinMedidaPlotOut", title = "Viol\u00EDn-Plot", placement = "top", trigger = "hover",
                   content = "Se presenta: Un Box-Plot enmarcado con una distribuci\u00F3n de densidad suavizada (Kernel Density).")
         ),
         tabPanel("Densidad 2D", icon = icon("pause"), h4("Densidad 2D"),
            plotlyOutput("densidad2DMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
            bsPopover(id="densidad2DMedidaPlotOut", title = "Densidad 2D", placement = "top", trigger = "hover",
                  content = "Se presenta: Distribuci\u00F3n de Densidad de los score por cada variable (suavizado - Kernel Density).")
         ),
         tabPanel("Histograma", icon = icon("signal"), h4("Histograma"),
            dropdownButton(inputId = "histogramaMedidaOpsBtn",
               tags$h4("Opciones de Presentaci\u00F3n:"),
               awesomeCheckbox(inputId = "histogramaMedidaCheck",
                               label = "Separar Histogramas", value = FALSE, status = "success"),
               selectInput(inputId = 'histogramaMedidaBarraType', label = 'Tipo de Barra',
                           choices = c("Grupos"="group","Apilados"="stack","Superpuestos"="overlay"), selected = "group"),
               tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
               circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
               size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
            ),
            plotlyOutput("histogramaMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
            bsPopover(id="histogramaMedidaPlotOut", title = "Histrograma", placement = "top", trigger = "hover",
                      content = "Se presenta: Histograma de frecuencia por score (intervalo, cantidad) para cada variable seleccionada. Usar *cambiar opciones...* para explorar opciones complementarias.")
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
            plotlyOutput("boxplotMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
            bsPopover(id="boxplotMedidaPlotOut", title = "Box-Plot", placement = "top", trigger = "hover",
                   content = "Se presenta: Un Box-Plot de los score para cada variable seleccionada. Usar *cambiar opciones...* para explorar opciones complementarias.")
         ),
         tabPanel("Ridgeline", icon = icon("arrow-right"),h4("Ridgeline (formalmente: Joyplot)"),
            # IMPORTANTE: Para Ridgeline se debe usar la version mas reciente de ggplot2 v 3.0.0
            # -- Adicionalmente, plotly/svgPanZoomOutput no tiene actualmente el WRAPPER para este
            #    tipo de grafico de "ggplot"; por eso usa un "plotOutput" estandar.
            plotOutput("ridgelineMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
            bsPopover(id="ridgelineMedidaPlotOut", title = "Ridgeline", placement = "top", trigger = "hover",
                   content = "Se presenta: Las distribuci\u00F3n de densidad separadas con Jitter (l\u00EDneas punteadas) de cada variable seleccionada, siendo \u00FAtil para realizar comparaciones de patrones.")
         )
       ),
       navbarMenu("Correlaci\u00F3n", menuName="correlaMenu",
          tabPanel("Dispersi\u00F3n (Scatter)",icon = icon("braille"), h4("Dispersi\u00F3n (Scatter)"),
            plotlyOutput("scatterMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
            bsPopover(id="scatterMedidaPlotOut", title = "Dispersi\u00F3n (Scatter)", placement = "top", trigger = "hover",
                   content = "Se presenta: Diagrama de dispersi\u00F3n con Jitter (l\u00EDneas punteadas) de las dos variables seleccionadas. Adecuado para detectar correlaciones fuertes (tendencias), positivas o negativas entre las variables.")
          ),
          tabPanel("Dispersi\u00F3n (Regresi\u00F3n)",icon = icon("braille"), h4("Dispersi\u00F3n (Regresi\u00F3n)"),
             dropdownButton(inputId = "scatterRegresMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'scatterRegresMedidaType', label = 'Complemantos al margen',
                            choices = c("Densidad"="density","Histograma"="histogram",
                                        "Boxplot"="boxplot","Viol\u00EDn"="violin"), selected = "density"),
                selectInput(inputId = 'scatterRegresMedidaMargins', label = 'Usar margen',
                            choices = c("Ambos"="both","X"="x","Y"="y"), selected = "both"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             # IMPORTANTE: plotly actualmente no tiene el WRAPPER para ggExtra (ggMarginal).
             # --> Por eso usa un "plotOutput" estandar.
             plotOutput("scatterRegresMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
             bsPopover(id="scatterRegresMedidaPlotOut", title = "Dispersi\u00F3n (Regresi\u00F3n)",
                   placement = "top", trigger = "hover",
                   content = "Se presenta: Diagrama de dispersi\u00F3n con una l\u00EDnea de regresi\u00F3n ajustada para las dos variables seleccionadas. Adicionalmente, se presentan las curvas de distribuci\u00F3n de densidad en los ejes. Usar *cambiar opciones...* para explorar opciones complementarias.")
          ),
          tabPanel("Matriz de Dispersi\u00F3n (SPLOM)",icon = icon("th"), h4("Matriz de Dispersi\u00F3n (SPLOM)"),
             plotlyOutput("splomMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="splomMedidaPlotOut", title = "Matriz de Dispersi\u00F3n (SPLOM)", placement = "top", trigger = "hover",
                   content = "Se presenta: Matriz de dispersi\u00F3n / correlaci\u00F3n (Scatter Plot Matrix) para las variables seleccionadas. En particular, en la diagonal principal se presentan las distribuciones de densidad.")
          ),
          tabPanel("Heatmap", icon = icon("qrcode"),h4("Heatmap"),
             dropdownButton(inputId = "heatmapMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = "heatmapMedidaTransType", label = "Aplicar transformaci\u00F3n",
                            choices = c("Ninguna", "Escalar", "Normalizar", "Porcentualizar"),
                            selected = "Ninguna"),
                selectInput(inputId = 'heatmapMedidaDendroType', label = 'Ver Dendrograma',
                            choices = c("Ninguno"='none',"Filas"='row',"Columnas"='column',"Ambos"='both'), selected = "row"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             plotlyOutput("heatmapMedidaPlotOut", width = "100%", height = "700") %>% withSpinner(type=4, color="cadetblue"),
             bsPopover(id="heatmapMedidaPlotOut", title = "Heatmap", placement = "top", trigger = "hover",
                   content = "Se presenta: Heatmap con variaciones de color para el score de las variables seleccionadas (columnas). Adicionalmente, se usa un dendrograma por filas o columnas, lo cual permite visualizar patrones. Usar *cambiar opciones...* para explorar opciones complementarias.")
          ),
          tabPanel("Correlograma", icon = icon("th-large"),h4("Correlograma"),
             dropdownButton(inputId = "correlogramaMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'correlogramaMedidaMethod', label = 'Estilo de Representaci\u00F3n',
                            choices = c("C\u00EDrculo"="circle","Cuadrado"="square",
                                        "Elipse"="ellipse","Num\u00E9rico"="number","Torta"="pie"),
                                      selected = "ellipse"),
                selectInput(inputId = 'correlogramaMedidaSection', label = 'Ver Secci\u00F3n',
                            choices = c("Completo"="full","Inferior"="lower","Superior"="upper"), selected = "upper"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             # IMPORTANTE: corrplot genera un grafico estandar para el cual plotly no tiene WRAPPER...
             plotOutput("correlogramaMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="correlogramaMedidaPlotOut", title = "Correlograma", placement = "top", trigger = "hover",
                   content = "Se presenta: Correlograma para los score de las variables seleccionadas. Adicionalmente, se permite la presentaci\u00F3n de figuras para representar gr\u00E1ficamente el nivel de la correlaci\u00F3n. Usar *cambiar opciones...* para explorar opciones complementarias.")
          ),
          tabPanel("Burbujas", icon = icon("comments"),h4("Burbujas"),
             plotlyOutput("bubleMedidaPlotOut", width = "100%", height = "700") %>% withSpinner(type=4, color="cadetblue"),
            bsPopover(id="bubleMedidaPlotOut", title = "Burbujas", placement = "top", trigger = "hover",
                   content = "Se presenta: Diagrama de dispersi\u00F3n tipo Burbujas (el di\u00E1metro corresponde a la magnitud del score) para las dos variables seleccionadas. Adecuado para detectar correlaciones fuertes (tendencias) por magnitud.")
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
             plotlyOutput("contourMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="contourMedidaPlotOut", title = "Contorno (Densidad 2D)", placement = "top", trigger = "hover",
                   content = "Se presenta: Diagrama de dispersi\u00F3n tipo Contorno-2D. En particular, se representa la densidad de puntos en una secci\u00F3n (\u00E1rea del eje) con un color tipo gradiente, permitiendo la visualizaci\u00F3n de patrones de densidad para los score. Usar *cambiar opciones...* para explorar opciones complementarias.")
          )
       ),
       navbarMenu("Barras", menuName="barrasMenu",
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
             amChartsOutput("barrasMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
             bsPopover(id="barrasMedidaPlotOut", title = "Barras", placement = "top", trigger = "hover",
                       content = "Se presenta: Diagrama de Barras donde en el eje horizontal est\u00E1n las filas asocidadas con cada variable selecionada, y en el eje vertical el valor se su respectivo score. Usar *cambiar opciones...* para explorar opciones complementarias.")
          ),
          tabPanel("Histograma Circular (b\u00E1sico)", icon = icon("stop-circle"), h4("Barras Circulares (b\u00E1sico)"),
             plotOutput("histoBarMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="histoBarMedidaPlotOut", title = "Histograma Circular (b\u00E1sico)", placement = "top", trigger = "hover",
                       content = "Se presenta: Histograma circular para los score de cada variable seleccionada. Es \u00FAtil para realizar una visi\u00F3n m\u00E1s general y alternativa de los score.")
          ),
          tabPanel("Barras Circular (b\u00E1sico)", icon = icon("stop-circle"), h4("Barras Circulares (b\u00E1sico)"),
             plotOutput("circleBarMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
             bsPopover(id="circleBarMedidaPlotOut", title = "Barras Circular (b\u00E1sico)", placement = "top", trigger = "hover",
                       content = "Se presenta: Diagrama de Barras circular para los score de una variable seleccionada. Es \u00FAtil para realizar una visi\u00F3n m\u00E1s general y alternativa de los score.")
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
             plotlyOutput("lollipopMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="lollipopMedidaPlotOut", title = "Lollipop", placement = "top", trigger = "hover",
                       content = "Se presenta: Diagrama de Barras que presenta una l\u00EDnea y un c\u00EDrculo al final del score. Es \u00FAtil para presentar de forma simple patrones de score agrupados por valores cercanos (dispersi\u00F3n).")
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
             bsPopover(id="paralelasMedidaPlotOut", title = "Coordenadas Paralelas", placement = "top", trigger = "hover",
                       content = "Se presenta: Diagrama de coordenas paralelas usando cada variable seleccionada. Es adecuado para analizar patrones de variaci\u00F3n entre los score de las variables. Usar *cambiar opciones...* para explorar opciones complementarias."),
             parcoordsOutput("paralelasMedidaPlotOut", width = "100%", height = "500") %>%
                 withSpinner(type=4, color="cadetblue") %>%
                 helper(type = "markdown", title = "SEMVIZ: Coordenadas Paralelas", colour = "red",
                        content = "paralelasMedidaPlot_help", size = "m") # size: define el ancho (s,m,l) del "popup"
          )
       ),
       navbarMenu("Jer\u00E1rquicos", menuName="jerarqMenu",
          tabPanel("Treemap",icon = icon("tree"),
             h4("An\u00E1lisis Jer\u00E1rquico de los Score seleccionados del Modelo SEM (Treemap)"),
             plotOutput("treemapMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="treemapMedidaPlotOut", title = "Treemap", placement = "top", trigger = "hover",
                       content = "Se presenta: Diagrama tipo Treemap, agrupa los score de forma Jer\u00E1rquica en un mapa de calor. Es adecuado para analizar grupos de valores anidados de forma propocional a su valor.")
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
                plotOutput("dendrogramMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
                bsPopover(id="dendrogramMedidaPlotOut", title = "Dendrograma B\u00E1sico", placement = "top", trigger = "hover",
                          content = "Se presenta: Diagrama tipo Dendrograma (\u00E1rbol), agrupa los score de forma Jer\u00E1rquica por medio de una estructura de \u00E1rbol. Es adecuado para analizar grupos de score asociados por su valor. Usar *cambiar opciones...* para explorar opciones complementarias.")
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
                  plotOutput("dendroInterMedidaPlotOut", width = "100%", height = "600") %>% withSpinner(type=4, color="cadetblue"),
                  bsPopover(id="dendroInterMedidaPlotOut", title = "Dendrograma Exploratorio", placement = "top", trigger = "hover",
                          content = "Se presenta: Diagrama tipo Dendrograma (\u00E1rbol), agrupa los score de forma Jer\u00E1rquica por medio de una estructura de \u00E1rbol. Es adecuado para analizar grupos de score asociados por su valor. Usar *cambiar opciones...* para explorar opciones complementarias.")
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
                  plotOutput("dendroCompaMedidaPlotOut", width = "100%", height = "600") %>% withSpinner(type=5, color="cadetblue"),
                  bsPopover(id="dendroCompaMedidaPlotOut", title = "Dendrograma Comparativo", placement = "top", trigger = "hover",
                            content = "Se presenta: Diagrama tipo Dendrograma (\u00E1rbol), agrupa los score de forma Jer\u00E1rquica por medio de una estructura de \u00E1rbol. Es adecuado para comparar los grupos de score de dos variables. Usar *cambiar opciones...* para explorar opciones complementarias.")
             )
          ),
          tabPanel("Cluster Comparativo", icon = icon("object-group"),
             h4("An\u00E1lisis de Cluster para los Score de los elementos seleccionados (Cluster-Comparativo)"),
             plotlyOutput("clusterMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
             bsPopover(id="clusterMedidaPlotOut", title = "Cluster Comparativo", placement = "top", trigger = "hover",
                       content = "Se presenta: Diagrama de dispersi\u00F3n, agrupa los score por medio de cl\u00FAster usando k-means. Es adecuado para establecer cl\u00FAster de datos entre los score.")
          )
       ),
       navbarMenu("Redes", menuName="redesMenu",
          tabPanel("Red de Correlaci\u00F3n",icon = icon("connectdevelop"),
             h4("Red de Correlaci\u00F3n (an\u00E1lisis exploratorio/confirmatorio para las variables OBSERVADAS iniciales)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: OBSERVADA"),
             dropdownButton(inputId = "corrnetMedidaOpsBtn",
                tags$h4("Opciones de Presentaci\u00F3n:"),
                selectInput(inputId = 'corrnetMedidaLayout', label = 'Estilo de Representaci\u00F3n',
                            choices = c("C\u00EDrculo"="circle","Grupos"="groups","Tipo Spring"="spring"), selected = "spring"),
                selectInput(inputId = 'corrnetMedidaGraph', label = 'M\u00E9todo de Optimizaci\u00F3n',
                            choices = c("Ninguno"="Ninguno","Asociaci\u00F3n"="assosciation",
                                        "Concentraci\u00F3n"="concentration","Tipo Graphical LASSO"="glasso"), selected = "Ninguno"),
                tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
             ),
             bsPopover(id="corrnetMedidaPlotOut", title = "Red de Correlaci\u00F3n", placement = "top", trigger = "hover",
                       content = "Se presenta: Red de Correlaci\u00F3n que permite realizar un an\u00E1lisis gr\u00E1fico de las correlaciones entre las variables observadas, esto por medio de un grafo. Usar *cambiar opciones...* para explorar opciones complementarias."),
             plotOutput("corrnetMedidaPlotOut", width = "600", height = "600") %>% withSpinner(type=4, color="cadetblue") %>%
             helper(type = "markdown", title = "SEMVIZ: Red de Correlaci\u00F3n", colour = "red",
                    content = "redCorrelacionMedidaPlot_help", size = "m") # size: define el ancho (s,m,l) del "popup"
          ),
          tabPanel("Red Hive (Nodos en ejes)", icon = icon("forumbee"),
             h4("Red Hive (Nodos en ejes -- An\u00E1lisis para las variables OBSERVADAS iniciales)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: OBSERVADA"),
             plotOutput("hiveMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="hiveMedidaPlotOut", title = "Red Hive (Nodos en ejes)", placement = "top", trigger = "hover",
                       content = "Se presenta: Red Hive (Nodos en ejes) que permite realizar un an\u00E1lisis gr\u00E1fico de los niveles de dependencia entre las variables observadas, esto por medio de una red simple para los tipos de asociaciones.")
          ),
          tabPanel("Arcos", icon = icon("random"),
             h4("Red Arcos (Nodos en ejes -- An\u00E1lisis para las variables OBSERVADAS iniciales)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: OBSERVADA"),
             plotOutput("arcosMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=4, color="cadetblue"),
             bsPopover(id="arcosMedidaPlotOut", title = "Arcos", placement = "top", trigger = "hover",
                       content = "Se presenta: Red tipo Arcos que permite realizar un an\u00E1lisis gr\u00E1fico de la densidad de enlaces entre las variables observadas, esto por medio de una red de arcos para los tipos de asociaciones.")
          )
       ),
       navbarMenu("Evoluci\u00F3n",menuName="evolucionMenu",
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
             plotlyOutput("sankeyMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
             bsPopover(id="sankeyMedidaPlotOut", title = "Flujo de cargas de coeficientes (Sankey)", placement = "top",
                       trigger = "hover", content = "Se presenta: Diagrama de flujo tipo Sankey que permite presentar el flujo de cargas (coeficientes estimados estandarizados) entre las variables del modelo SEM. Usar *cambiar opciones...* para explorar opciones complementarias.")
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
                 dygraphOutput("seriesMedidaPlotOut", width = "100%", height = "500") %>% withSpinner(type=5, color="cadetblue"),
                 bsPopover(id="seriesMedidaPlotOut", title = "An\u00E1lisis tipo Series (Comparativo)", placement = "top",
                           trigger = "hover", content = "Se presenta: Diagrama de flujo tipo Series que presenta una serie por valores de score para cada variable seleccionada. Usar *cambiar opciones...* para explorar opciones complementarias.")
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
                                   withSpinner(type=5, color="cadetblue"),
                bsPopover(id="streamgraphMedidaPlotOut", title = "An\u00E1lisis tipo Score-Streamgraph", placement = "top",
                           trigger = "hover", content = "Se presenta: Diagrama de flujo tipo Streamgraph (\u00E1reas apiladas) que presenta una serie por valores de score para cada variable seleccionada. Usar *cambiar opciones...* para explorar opciones complementarias.")
             )
          ),
          tabPanel("An\u00E1lisis tipo Score-Se\u00F1al", icon = icon("road"),
             h4("An\u00E1lisis de Flujo de los Score para elementos del Modelo SEM (Tipo Se\u00F1al)"),
             plotlyOutput("signalMedidaPlotOut", width = "100%", height = "500") %>%
                           withSpinner(type=4, color="cadetblue"),
             bsPopover(id="signalMedidaPlotOut", title = "An\u00E1lisis tipo Score-Se\u00F1al", placement = "top",
                           trigger = "hover", content = "Se presenta: Diagrama de flujo tipo Score-Se\u00F1al (\u00E1reas apiladas) que presenta una serie por valores de score para cada variable seleccionada.")
          ),
          tabPanel("An\u00E1lisis tipo Score-\u00C1reas", icon = icon("align-right"),
             h4("An\u00E1lisis de Flujo de los Score para elementos del Modelo SEM (\u00C1reas apiladas)"),
             plotlyOutput("stackedAreaMedidaPlotOut", width = "100%", height = "500") %>%
                           withSpinner(type=5, color="cadetblue"),
             bsPopover(id="stackedAreaMedidaPlotOut", title = "An\u00E1lisis tipo Score-\u00C1reas", placement = "top",
                           trigger = "hover", content = "Se presenta: Diagrama de flujo tipo Score-\u00C1reas (\u00E1reas apiladas) que presenta una serie por valores de score para cada variable seleccionada.")
          )
       ),
       navbarMenu("Circularizar",menuName="circularMenu",
          tabPanel("Circular Packing de un Nivel", icon = icon("circle"),
             h4("An\u00E1lisis Circular Packing de un nivel para los Score de los elementos seleccionados"),
             plotlyOutput("circlePackOneLevelMedidaPlotOut", width = "100%", height = "500") %>%
                         withSpinner(type=4, color="cadetblue"),
             bsPopover(id="circlePackOneLevelMedidaPlotOut", title = "Circular Packing de un Nivel", placement = "top",
                       trigger = "hover", content = "Se presenta: Diagrama tipo Circular Packing (treemap circular), permite visualizar organizaciones (c\u00EDrculos anidados) Jer\u00E1rquicas (tipo dendrograma) entre los score de las variables seleccionadas.")
          ),
          tabPanel("Circular Packing Jer\u00E1rquico", icon = icon("circle"),
             h4("An\u00E1lisis Jer\u00E1rquico del Flujo de cargas de coeficientes del Modelo SEM (Circular Packing)"),
             tags$i("Para activar el gr\u00E1fico seleccionar en el Modelo SEM el grupo: LATENTE"),
             circlepackeROutput("circlePackJerarqMedidaPlotOut", width = "100%", height = "500") %>%
                                withSpinner(type=5, color="cadetblue"),
             bsPopover(id="circlePackJerarqMedidaPlotOut", title = "Circular Packing Jer\u00E1rquico", placement = "top",
                       trigger = "hover", content = "Se presenta: Diagrama tipo Circular Packing Jer\u00E1rquico, permite visualizar organizaciones (c\u00EDrculos anidados) Jer\u00E1rquicas (tipo dendrograma) entre los score de las variables seleccionadas.")
          ),
          tabPanel("Circular Packing (Dendrograma)",icon = icon("pause-circle"),
              h4("An\u00E1lisis Jer\u00E1rquico para los Score de los elementos seleccionados (Dendrograma-Comparativo)"),
              circlepackeROutput("circlePackDendroMedidaPlotOut", width = "100%", height = "500") %>%
                                withSpinner(type=4, color="cadetblue"),
             bsPopover(id="circlePackDendroMedidaPlotOut", title = "Circular Packing (Dendrograma)", placement = "top",
                       trigger = "hover", content = "Se presenta: Diagrama tipo Circular Packing (Dendrograma), permite visualizar organizaciones (c\u00EDrculos anidados) Jer\u00E1rquicas (tipo dendrograma) entre los score de las variables seleccionadas.")
          ),
          # IMPORTANTE: Este diagrama no es muy claro, y tampoco se ve relevante. Considerar ocultarlo, falla con Grupos UdeA.
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
                box(title = "Cargas de Coeficientes", status = "success", solidHeader = TRUE, collapsible = TRUE,
                  dropdownButton(inputId = "chordCoefiMedidaOpsBtn",
                      tags$h4("Opciones de Presentaci\u00F3n:"),
                      selectInput(inputId = 'chordCoefiMedidaTipoCoef', label = 'Usar Coefientes de',
                                  choices = c("Factores"="loading","Constructos"="regression"), selected = "loading"),
                      tags$i("Actualizaci\u00F3n autom\u00E1tica..."),
                      circle = TRUE, status = "danger", icon = icon("gear"), width = "250px",
                      size = "xs", tooltip = tooltipOptions(title = "Cambiar opciones...")
                  ),
                  plotOutput("chordCoefiMedidaPlotOut", width = "100%", height = "400") %>%
                            withSpinner(type=4, color="cadetblue"),
                  bsPopover(id="chordCoefiMedidaPlotOut", title = "Cargas de Coeficientes", placement = "top",
                            trigger = "hover", content = "Se presenta: Diagrama de Cuerdas usando las Cargas de los Coeficientes estimados para las variables del modelo SEM. Usar *cambiar opciones...* para explorar opciones complementarias.")
                ),
                box(title = "Correlaciones por variable", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput("chordCorrMedidaPlotOut", width = "100%", height = "400") %>%
                            withSpinner(type=4, color="cadetblue"),
                  bsPopover(id="chordCorrMedidaPlotOut", title = "Correlaciones por variable", placement = "top",
                            trigger = "hover", content = "Se presenta: Diagrama de Cuerdas usando las Correlaciones estimadas entre todas las variables del modelo SEM.")
                )
              ) # FIN fluidRow
          )
       )
    )  # FIN PANEL navbarPage
  ) # FIN PANEL fluidPage
) # FIN PANEL tabItem
