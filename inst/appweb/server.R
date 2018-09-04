# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# NOTA: las inclusiones son relativas a la ubicion del archivo. "server.R"
#
# NOTA1: Inicializa los listeners del paquete shinyhelper, para
# asociar ayura en linea con ".md" files. Esto en la ubicacion
# relativa al "server.R"; en el directorio: "/helpfiles/" (nombre por defecto).
# El nombre del directorio puede cambiarse, y especificar en la invocacion.
# --> La invocacion a "observe_helpers" debe hacerse en el archivo "server.R",
# --> siempre dentro de la funcion "shinyServer(..)".
#
# NOTA2: Es posible crear el directorio por defecto de archivos de ayuda con
# la fincion propia del paquete shinyhelper:
# create_help_files(files = c("controls_help", "plot_help"), help_dir = "helpfiles")
# Esto crea el dir "helpfiles" por defecto en el directorio actual de la consola de $R>.
# Debe quedar o ser movido al mismo nivel del archivo "server.R", ya que el acceso en
# tiempo de ejecucion de relativo dicho elemento.
# -------------------------------------------------------------------
source('include_server/utils_server.R', local=TRUE)

# INICIO SERVER
shinyServer(function(input, output, session) {
  # INIT listener de elementos de "textos de ayuda":
  observe_helpers(help_dir = "helpfiles")

  # ELEMENTOS SET DE DATOS
  source('include_server/set_datos_subm_server.R', local=TRUE)
  # FIN SET DE DATOS

  # ESPECIFICAR MODELO SEM SINTAXIS LAVAAN
  source('include_server/modelo_sem_server.R', local=TRUE)
  # FIN MODELO SEM LAVAAN

  # FINALIZACION DE SESION WEB ----------------------------------------------
  # Finaliza la ejecucion de la APP en R-Studio al cerrar la Ventana PPAL:
  session$onSessionEnded(function() {
    stopApp()
  })

## FIN SERVER
})

