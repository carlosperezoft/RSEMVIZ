# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:18:51 p. m.
#
# launchApp
# Funcion de prueba para ejecutar la app web R-Shiny
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

launchApp <- function() {
  ## NOTA: Se pueden inicializar las propiedades de ejecucion
  ## dese la consola de R, esto deja las opciones a nivel GLOBAL en la instancia de R.
  options(shiny.launch.browser = TRUE)
  options(shiny.host = "127.0.0.1")
  options(shiny.port = 9090)
  #
  # NOTA: De manera directa en la invocacion se pueden usar en el runApp(..)
  shiny::runApp(appDir = system.file("appweb", package = "semviz"),
                launch.browser = TRUE, host = "127.0.0.1", port = 9090)
}
