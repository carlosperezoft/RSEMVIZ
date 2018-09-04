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
    ":: BASES",
    menuItem(text = "Gesti\u00F3n de Datos", icon = icon("database"),
       menuSubItem(text = "Seleccionar SET de DATOS", tabName = "setDatosSubMTab", icon = icon("file")),
       menuSubItem(text = "An\u00E1lisis Exploratorio de DATOS", tabName = "EDASubMTab", icon = icon("search"))
    ),
    menuItem(text = "Especificar el Modelo", tabName = "modeloSEMTab", icon = icon("edit"),
             badgeLabel = "SEM", badgeColor = "orange"),
    ":: GENERAL",
    menuItem(text = "An\u00E1lisis MODELO SEM", icon = icon("superscript"),
       menuSubItem(text = "Tablero BASICO", tabName = "dashBASSubMTab", icon = shiny::icon("stats", lib = "glyphicon")),
       menuSubItem(text = "Tablero AVANZADO", tabName = "dashAVANSubMTab", icon = icon("wrench"))
    ),
    menuItem(text = "An\u00E1lisis de Hip\u00F3tesis", tabName = "hipotesisTab", icon = icon("check-circle"),
             badgeLabel = "PARAMS", badgeColor = "blue"),
    ":: AVANZADO",
    menuItem(text = "An\u00E1lisis Modelo de Medici\u00F3n", icon = icon("list-ol"),
       menuSubItem(text = "Descriptivo (Caracterizaci\u00F3n)", tabName = "modMedDesSubMTab", icon = icon("pencil")),
       menuSubItem(text = "Pos-estimaci\u00F3n (Predicci\u00F3n)", tabName = "modMedPosSubMTab", icon = icon("paper-plane")),
       menuSubItem(text = "Sensibilidad (BOOTSTRAP?)", tabName = "modeMedSenSubMTab", icon = icon("thumbs-up"))
    ),
    menuItem(text = "An\u00E1lisis Modelo Estructural", icon = icon("sitemap"),
       menuSubItem(text = "Descriptivo (Caracterizaci\u00F3n)", tabName = "modEstDesSubMTab", icon = icon("pencil")),
       menuSubItem(text = "Pos-estimaci\u00F3n (Predicci\u00F3n)", tabName = "modEstPosSubMTab", icon = icon("paper-plane")),
       menuSubItem(text = "Sensibilidad (BOOTSTRAP?)", tabName = "modeEstSenSubMTab", icon = icon("thumbs-up"))
    ),
    "::",
    # FIN SECCION
    #
    # NOTA: El uso de "href", es excluyente con el uso de "tabName" y de "subitems". Se debe usar uno de ellos.
    # El atributo "newtab" se utiliza para activar una nueva pestaña o popup al cargar el "href"
    menuItem("Ayuda SEMVIZ", icon = icon("question-circle"), badgeLabel = "HELP",
             badgeColor = "purple", href = "/ayuda/semviz.html", newtab = TRUE)

) # /FIN sidebarMenu
