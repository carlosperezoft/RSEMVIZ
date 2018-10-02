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

  # ELEMENTOS CASOS DE ESTUDIO
  source('include_server/casos_estudio_server.R', local=TRUE)
  # FIN CASOS DE ESTUDIO

  # ELEMENTOS SET DE DATOS
  source('include_server/set_datos_subm_server.R', local=TRUE)
  # FIN SET DE DATOS

  # ESPECIFICAR MODELO SEM SINTAXIS LAVAAN
  source('include_server/modelo_sem_server.R', local=TRUE)
  # FIN MODELO SEM LAVAAN

  # FUNCIONES SEMVIZ UTIL PARA EL GRAFO CON VIZNETWORK
  source('include_server/grafo_semviz_util_server.R', local=TRUE)
  # FIN SEMVIZ UTIL GRAFO CON VIZNETWORK

  # vISNETWORK PARA RESULTADOS MODELO SEM BASICO
  source('include_server/dashbas_subm_server.R', local=TRUE)
  # FIN vISNETWORK RESULTADO BASICO

  # vISNETWORK PARA RESULTADOS MODELO SEM AVANZADO
  source('include_server/dashavan_subm_server.R', local=TRUE)
  # FIN vISNETWORK RESULTADO AVANZADO

  # vISNETWORK PARA ANALISIS DE HIPOTESIS
  source('include_server/hipotesis_model_server.R', local=TRUE)
  # FIN ANALISIS DE HIPOTESIS

  # ANALISIS DE MENU DESCRIPTIVO DEL MODELO DE MEDICION - SEM
  source('include_server/modelo_medida_desc_subm_server.R', local=TRUE)
  # FIN DESCRIPTIVO DEL MODELO DE MEDICION

  # QGRAPH PARA ANALISIS REDES PSICOMETRIA - SEM
  source('include_server/modelo_medida_predic_subm_server.R', local=TRUE)
  # FIN ANALISIS REDES PSICOMETRIA - SEM


  # FINALIZACION DE SESION WEB ----------------------------------------------
  # Finaliza la ejecucion de la APP en R-Studio al cerrar la Ventana PPAL:
  session$onSessionEnded(function() {
    stopApp()
  })

## FIN SERVER
})

