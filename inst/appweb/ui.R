# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# NOTA: las inclusiones son relativas a la ubicion del archivo. "ui.R"
source('include_ui/utils_ui.R', local=TRUE)

# Declaracion del encabezado para la aplicacion WEB:
header <- dashboardHeader(
  # El titulo usado aqui es el presentado en el menu de la app web:
  title = tagList(shiny::icon("gear"), "SEMVIZ \u00AE"),
  titleWidth = "250px", disable = FALSE, msgHelpMenu
)

# menu_general ------------------------------------------------------------
#
# SE USA LA FUNCION source(..) con el acceso especifico al $value; para evitar que se
# procese el contenido, pues causa que se genere el codigo HTML respectivo...
# Se debe incluir el tabItem completo, sino el include .R genera errores de validacion:
#
# menu_general ------------------------------------------------------------
#
sidebar <- dashboardSidebar(width = "250px",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  # Definicion del PANEL MENU A LA IZQUIERDA:
  source("include_ui/sidebar_menu_ui.R", local = TRUE)$value,
  br(),
  # Definicion del FOOTER MENU A LA IZQUIERDA:
  source("include_ui/footer_menu_ui.R", local = TRUE)$value
) # /dashboardSidebar


# TABS ASOCIADOS A CADA MENU ITEM DEL SIDE BAR PARA LA APPWEB -----------------
body <- dashboardBody(
  tabItems(
    # MENU ITEM PARA EL MENU ITEM: INICIO
    source("include_ui/home_tab.R", local = TRUE)$value,
    source("include_ui/set_datos_subm_tab.R", local = TRUE)$value,
    source("include_ui/modelo_sem_tab.R", local = TRUE)$value,
    tabItem(tabName = "ayudaTab", href = "/ayuda/semviz.html", newtab = TRUE)
  ) # /tabItems
) # /dashboardBody

# DEFINICION ELEMENTO DASHBOARD -------------------------------------------------
# El titulo usado aqui es el presentado en la pagina de Navegador WEB:
dashboardPage(title = "SEMVIZ", header, sidebar, body, skin = "blue")
