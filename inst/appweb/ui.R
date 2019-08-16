# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# NOTA: las inclusiones son relativas a la ubicion del archivo. "ui.R"
source('include_ui/utils_ui.R', local=TRUE)
# ------------------------------------------------------------------------------
# Declaracion del encabezado para la aplicacion WEB:
# Se activa el dashboardHeader/dashboardHeaderPlus caso de usar "rightsidebar".
# IMPORTANTE: dashboardPagePlus permite presenrar el menu abreviado de iconos
# a la izquierda al minimizar el encabezado
# ------------------------------------------------------------------------------
header <- dashboardHeaderPlus( # dashboardHeaderPlus(
  # El titulo usado aqui es el presentado en el menu de la app web:
  title = tagList(shiny::icon("gear"), "SEMVIZ \u00AE"),
  titleWidth = "260px", disable = FALSE, linkedInHead, msgHelpMenu
# , enable_rightsidebar = FALSE
# , rightSidebarIcon = "gears"
)

# menu_general ------------------------------------------------------------
#
# SE USA LA FUNCION source(..) con el acceso especifico al $value; para evitar que se
# procese el contenido, pues causa que se genere el codigo HTML respectivo...
# Se debe incluir el tabItem completo, sino el include .R genera errores de validacion:
#
# menu_general ------------------------------------------------------------
#
sidebar <- dashboardSidebar(width = "260px",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  # Definicion del PANEL MENU A LA IZQUIERDA:
  source("include_ui/sidebar_menu_ui.R", local = TRUE)$value,
  hr(),
  cperezUsrPanel
) # /dashboardSidebar


# TABS ASOCIADOS A CADA MENU ITEM DEL SIDE BAR PARA LA APPWEB -----------------
body <- dashboardBody(setShadow("box"), useShinyjs(),
  tabItems(
    # MENU ITEM PARA EL MENU ITEM: INICIO
    source("include_ui/home_tab.R", local = TRUE)$value,
    source("include_ui/casos_estudio_tab.R", local = TRUE)$value,
    source("include_ui/set_datos_subm_tab.R", local = TRUE)$value,
    source("include_ui/modelo_sem_tab.R", local = TRUE)$value,
    source("include_ui/dashbas_subm_tab.R", local = TRUE)$value,
    source("include_ui/dashavan_subm_tab.R", local = TRUE)$value,
    source("include_ui/hipotesis_tab.R", local = TRUE)$value,
    source("include_ui/modelo_medida_desc_subm_tab.R", local = TRUE)$value,
    source("include_ui/mod_estruct_predic_subm_tab.R", local = TRUE)$value
  ) # /tabItems
) # /dashboardBody

# DEFINICION ELEMENTO DASHBOARD -------------------------------------------------
# El titulo usado aqui es el presentado en la pagina de Navegador WEB:
# Se activa el dashboardPage/dashboardPagePlus caso de usar "rightsidebar".
# IMPORTANTE: dashboardPagePlus permite presenrar el menu abreviado de iconos
# a la izquierda al minimizar el encabezado
# -------------------------------------------------------------------------------
dashboardPagePlus(title = "SEMVIZ", header, sidebar, body, skin = "green"
  # ,rightsidebar = rightSidebar(
  #   background = "dark", width = 260,
  #   rightSidebarTabContent(
  #     id = 1,
  #     title = "Modelo SEM",
  #     icon = "desktop",
  #     active = TRUE,
  #     sliderInput(
  #       "obs",
  #       "Number of observations:",
  #       min = 0, max = 1000, value = 500
  #     )
  #   ),
  #   rightSidebarTabContent(
  #     id = 2,
  #     title = "Tab 2",
  #     textInput("caption", "Caption", "Data Summary")
  #   ),
  #   rightSidebarTabContent(
  #     id = 3,
  #     icon = "paint-brush",
  #     title = "Tab 3",
  #     numericInput("obs", "Observations:", 10, min = 1, max = 100)
  #   )
  # )
)
