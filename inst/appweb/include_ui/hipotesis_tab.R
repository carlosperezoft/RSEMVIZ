# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 10/09/2018 18:08:28 p. m.
#
tabItem(tabName = "hipotesisTab",
  h2(":: Hip\u00F3tesis MODELO SEM"),
  # Elementos de Carga de informacion para el SET de DATOS:
  fluidPage(
    titlePanel("An\u00E1lisis de hip\u00F3tesis asociadas"),
    sidebarLayout(
      # Sidebar panel for inputs ----
      # NOTA: Es posible indicar el numero de columnas para el sidebarPanel y el mainPanel,
      #       esto con el fin de ajustarse al tamaño de los elementos contenidos en cada panel.
      #      * IMPORTANTE el total son 12 columnas para ajustar los dos Paneles,
      #      * se ha usado 5 en el sidebar (grafo) y 7 en el main (tablas).
      sidebarPanel(id="hipotSidebarPanel", width = 5, style="background-color: white;",
         fluidRow(
           box(actionButton("dashHipotSEMBtn", "Actualizar Informaci\u00F3n por Variable..."),
             visNetworkOutput("grafoHipotSEMOut", height = 600) %>% withSpinner(type=8, color="cadetblue"),
                title = tagList(shiny::icon("gears"), "Modelo SEM"), width = NULL,
                collapsible = TRUE, status = "success", solidHeader = TRUE
           ) %>%
          popify(title = "Modelo SEM Interactivo",
            content = "Seleccione usando CTRL+clic los elementos que desea analizar...",
            placement = "top", trigger = "hover")
         )
      ), # fin sidebarPanel

      # Main panel for displaying outputs ----
      mainPanel(width = 7,
          wellPanel(
            h3("Validaci\u00F3n de H0 y H1:"),
            tabBox(width = "100%", height = "100%", # tabsetPanel(type = "tabs",
                   title = tagList(shiny::icon("check-circle"), "Inferencias"),
              tabPanel("H0 vs H1 - FACTORES",
                 h4("Tabla Estimaci\u00F3n Modelo de Medici\u00F3n"),
                 materialSwitch(inputId = "convenNodosHipoFacSwitch", label = tags$b("Ver Convenciones"),
                                status = "info", right = TRUE, value = FALSE),
                 bsPopover(id="tablaHipotesisModeloOut", title="Hip\u00F3tesis a nivel de Factores",placement="top",trigger="hover",
                           content = paste("Revisar los coeficientes estandarizados (lambda) de los factores que deben ser > 0.5.",
                                  "Dichos coeficientes deben ser significativos: p-value <= 0.05.",
                                  "Adicionalmente validar el R\u00B2 para cada variable observada y su respectivo factor (>= 0.70).")),
                 formattableOutput("tablaHipotesisModeloOut", width = "100%") %>% withSpinner(type=7, color="cadetblue"),
                 tags$b("R\u00B2 para los elementos presentados:"), br(),
                 formattableOutput("r2HipoFacTablaOut", width = "50%") %>% withSpinner(type=7, color="cadetblue"),
                 htmlOutput("ecuacionFactHipoTxtOut"), br(), # antes: verbatimTextOutput(..)
                 shinyjs::hidden( # Inicialmente oculta las convenciones:
                   # Usar el DIV es mejor para shiny-js y el materialSwitch:
                   div(id="convenNodosHipoFacDIV", tags$b("Convenciones de Elementos SEM presentados:"),
                      formattableOutput("convenNodosHipoFacTablaOut", width = "100%") %>% withSpinner(type=7, color="cadetblue")
                   )
                 )
              ),
              tabPanel("H0 vs H1 - ESTRUCTURAL",
                 h4("Tabla Estimaci\u00F3n Modelo Estructural (Regresiones)"),
                 materialSwitch(inputId = "convenNodosHipoRegSwitch", label = tags$b("Ver Convenciones"),
                                status = "info", right = TRUE, value = FALSE),
                 bsPopover(id="tablaHipotesisParamsOut", title="Hip\u00F3tesis a nivel de Constructos",placement="top",trigger="hover",
                           content = paste("Revisar los coeficientes estandarizados (betas) de las regresiones que deben ser > 0.5.",
                                       "Dichos coeficientes deben ser significativos: p-value <= 0.05.",
                                       "Adicionalmente validar el R\u00B2 para cada variable latente (>= 0.70).")),
                 formattableOutput("tablaHipotesisParamsOut", width = "100%") %>% withSpinner(type=7, color="cadetblue"),
                 tags$b("R\u00B2 para los elementos presentados:"), br(),
                 formattableOutput("r2HipoEstrTablaOut", width = "50%") %>% withSpinner(type=7, color="cadetblue"),
                 htmlOutput("ecuacionEstrHipoTxtOut"), br(), # antes: verbatimTextOutput(..)
                 shinyjs::hidden( # Inicialmente oculta las convenciones:
                   # Usar el DIV es mejor para shiny-js y el materialSwitch:
                   div(id="convenNodosHipoRegDIV", tags$b("Convenciones de Elementos SEM presentados:"),
                      formattableOutput("convenNodosHipoRegTablaOut", width = "100%") %>% withSpinner(type=7, color="cadetblue")
                   )
                 )
              )
            )
          ) # FIN wellpanel
      ) # fin main panel
    ) # fin sidebarLayout
  ) ## fin fluidPage ===========
)
