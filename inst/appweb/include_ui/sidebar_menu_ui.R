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
             badgeLabel = "HOME", badgeColor = "teal", selected = TRUE),
    "- BASES -",
    # SECCION DE MENUS OPERATIVOS PARA EL USO DE SEM GUIADO POR EL ANALISIS GRAFICO
    menuItem(text = "Casos de Estudio", tabName = "casosEstudioTab", icon = icon("book"),
             badgeLabel = "CASOS", badgeColor = "orange"),
    menuItem(text = "Gesti\u00F3n SET de Datos", icon = icon("database"),
    #        tabName = "setDatosSubMTab", badgeLabel = "DATOS", badgeColor = "purple"),
       menuSubItem(text = "Variables Explicativas", tabName = "setDatosObsSubMTab", icon = icon("columns")), # <- "file"
       menuSubItem(text = "Etiquetas del Modelo", tabName = "setDatosLabelSubMTab", icon = icon("tags"))
    ),
    menuItem(text = "Especificar y Estimar", tabName = "modeloSEMTab", icon = icon("edit"),
             badgeLabel = "Modelo SEM", badgeColor = "green"),
    hr(), "- RESULTADOS Visual-Interactivo -",
    menuItem(text = "An\u00E1lisis Bondad de Ajuste", icon = icon("superscript"),
       menuSubItem(text = "Ajuste del Modelo", tabName = "dashBASSubMTab", icon = shiny::icon("stats", lib = "glyphicon")),
       menuSubItem(text = "Complementos Ajuste", tabName = "dashAVANSubMTab", icon = icon("wrench"))
    ),
    menuItem(text = "An\u00E1lisis de Hip\u00F3tesis", tabName = "hipotesisTab", icon = icon("check-circle"),
             badgeLabel = "PARAMS", badgeColor = "maroon"),
    hr(), # ":: AVANZADO",
    menuItem(text = "An\u00E1lisis SEM Medici\u00F3n", icon = icon("list-ol"),
       tabName = "modMedDesSubMTab", badgeLabel = "Factores", badgeColor = "blue"
       #menuSubItem(text = "1. Factores Explicativos", tabName = "modMedDesSubMTab", icon = icon("pencil"))
       #,menuSubItem(text = "2. Distribuci\u00F3n", tabName = "modMedSenSubMTab", icon = icon("thumbs-up"))
    ),
    menuItem(text = "An\u00E1lisis SEM Estructural", icon = icon("sitemap"),
       tabName = "modEstPredSubMTab", badgeLabel = "Regresi\u00F3n", badgeColor = "green"
       #menuSubItem(text = "1. Predicci\u00F3n - Regresi\u00F3n", tabName = "modEstPredSubMTab", icon = icon("paper-plane"))
       #,menuSubItem(text = "2. Distribuci\u00F3n", tabName = "modEstSenSubMTab", icon = icon("thumbs-up")) # Pos-estimacion
    ), hr(),
    # FIN SECCION
    #
    # NOTA: El uso de "href", es excluyente con el uso de "tabName" y de "subitems". Se debe usar uno de ellos.
    # El atributo "newtab" se utiliza para activar una nueva pestaña o popup al cargar el "href"
    menuItem("Salir SEMVIZ", icon = icon("power-off"), badgeLabel = "CERRAR",
             badgeColor = "red", href = "javascript:setTimeout(function(){window.close();},500);", newtab = FALSE)

) # /FIN sidebarMenu
