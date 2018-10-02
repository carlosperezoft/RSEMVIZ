# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/10/2018 17:36:28 a. m.
#
tabItem(tabName = "modMedDesSubMTab",
  h2(":: Modelo de Medici\u00F3n - SEM"),
  fluidPage(

    titlePanel("An\u00E1lisis Factorial (Confirmatorio) del Modelo SEM Estimado"),
    ## POR HACER: MENUS EN DROPDAOWN-PRUEBAS para--> DENSIDAD, BOXPLOT, MATRICES(HEAT, CORR, SPLOM),
    ##           REDES (COR, SPRING, LASSO), BIPLOTS, DENDROGRAMAS(CIRCULAR, CURVA, RECTAGUL), ARCOS(DENSIDAD), HIVE(3-LINEAS),
    ##           SERIES(COMPARAR DYGRAPH, STREAMGRAPH), CORR PARALEL, CICULARIZAR INFO(SUNBURST, SANKEY, RADAR?),
    ##           JERARQUICOS(ARBOLES, circlepack, treemap), CLUSTER(K-MEANS)
    navbarPage("Men\u00FA AFC",
       tabPanel(
         "Matrices",
         icon = icon("desktop"),
         h3("Matriz SPLOM"),
         plotlyOutput("splomFactorOut", width = "500", height = "500") %>% withSpinner()
       ),
       tabPanel(
         "Redes Psico",
         icon = icon("gear"),
         h3("PREDICCION CON FORECAST VISUAL"),
         ###
         tabBox(width = "100%", height = "100%",
            title = tagList(shiny::icon("random"), "Clasificaci\u00F3n por tipo"),
            tabPanel("Ajuste 1",
               h4("Criterios de Referencia 1")
            ),
            tabPanel("Ajuste 2",
               h4("Criterios de Referencia 2")
            )
         )
         ###
       ),
       tabPanel(
         "MOSAICO DE VARIAS GRAFICAS",
         icon = icon("desktop"),
         h3("PANEL DE GRAFICOS CON SUBPLOT ARRAY"),
         sidebarLayout(
           sidebarPanel(width = 4,
             h3("CUADRANTE DE GRAFICOS:")

           ),
           mainPanel(
             h3("DATOS PRESENTADOS")

           )
         )
       ),
       navbarMenu(
         "EXTRA WIDGESTS PLOTLY",
         tabPanel(
           "PAR COORD INTERACTIVAS",
           icon = icon("tasks"),
           h3("COORDENADAS PARALELAS INTERACTIVAS")

         ),
         tabPanel(
           "COORDENADAS PARALELAS ESTATICAS",
           icon = icon("desktop"),
           h3("Cordenadas PREDEFINIDAS")

         )
       )
    )
  )
)
