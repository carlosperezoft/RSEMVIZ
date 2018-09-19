# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# NOTA: Un menuItem con "subItems" NO permite invocar su propio elmento "tabName", es decir;
#       solo los subItems activan la invocacion a un elemento "tabName".
##
# NOTA: Para el decorado "badgeColor", los colores validos son: red, yellow, aqua, blue,
#       light-blue, green, navy, teal, olive, lime, orange, fuchsia, purple, maroon, black.
#
# NOTA: Los atributos "badgeLabel" y "badgeColor" NO aplican en un menuSubItem !
#
sidebarMenu(id = "sidebarMenu",
    menuItem(text = "Inicio", tabName = "homeTab", icon = icon("home"),
             badgeLabel = "HOME", badgeColor = "green", selected = TRUE),
    #
    # SECCION DE MENUS OPERATIVOS PARA EL USO DE SEM GUIADO POR EL ANALISIS GRAFICO
    hr(), # ":: BASES"
    menuItem(text = "Casos de Estudio", tabName = "casosEstudioTab", icon = icon("desktop"),
             badgeLabel = "CASOS", badgeColor = "yellow"),
    menuItem(text = "Gesti\u00F3n de Datos", icon = icon("database"),
       menuSubItem(text = "SET de Datos", tabName = "setDatosSubMTab", icon = icon("file")),
       menuSubItem(text = "An\u00E1lisis Exploratorio", tabName = "EDASubMTab", icon = icon("search"))
    ),
    menuItem(text = "Especificar Modelo SEM", tabName = "modeloSEMTab", icon = icon("edit"),
             badgeLabel = "SEM", badgeColor = "orange"),
    hr(), # ":: GENERAL"
    menuItem(text = "An\u00E1lisis de Resultados", icon = icon("superscript"),
       menuSubItem(text = "Tablero BASICO", tabName = "dashBASSubMTab", icon = shiny::icon("stats", lib = "glyphicon")),
       menuSubItem(text = "Tablero AVANZADO", tabName = "dashAVANSubMTab", icon = icon("wrench"))
    ),
    menuItem(text = "An\u00E1lisis de Hip\u00F3tesis", tabName = "hipotesisTab", icon = icon("check-circle"),
             badgeLabel = "PARAMS", badgeColor = "blue"),
    hr(), #":: AVANZADO"
    menuItem(text = "An\u00E1lisis SEM Medici\u00F3n", icon = icon("list-ol"),
       menuSubItem(text = "1. Descriptivo", tabName = "modMedDesSubMTab", icon = icon("pencil")),
       menuSubItem(text = "2. Predicci\u00F3n", tabName = "modMedPosSubMTab", icon = icon("paper-plane")),
       menuSubItem(text = "3. Sensibilidad", tabName = "modeMedSenSubMTab", icon = icon("thumbs-up"))
    ),
    menuItem(text = "An\u00E1lisis SEM Estructural", icon = icon("sitemap"),
       menuSubItem(text = "1. Descriptivo", tabName = "modEstDesSubMTab", icon = icon("pencil")),
       menuSubItem(text = "2. Predicci\u00F3n", tabName = "modEstPosSubMTab", icon = icon("paper-plane")),
       menuSubItem(text = "3. Sensibilidad", tabName = "modeEstSenSubMTab", icon = icon("thumbs-up"))
    ),
    "::",
    # FIN SECCION
    #
    # NOTA: El uso de "href", es excluyente con el uso de "tabName" y de "subitems". Se debe usar uno de ellos.
    # El atributo "newtab" se utiliza para activar una nueva pestaña o popup al cargar el "href"
    menuItem("Salir SEMVIZ", icon = icon("power-off"), badgeLabel = "CERRAR",
             badgeColor = "red", href = "javascript:setTimeout(function(){window.close();},500);", newtab = FALSE)

) # /FIN sidebarMenu
