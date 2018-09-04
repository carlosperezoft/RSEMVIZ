# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
tabItem(tabName = "homeTab",
  h2("* Aplicaci\u00F3n SEMVIZ *. v 1.0.0"), # Este titulo es para la seccion completa
  fluidRow(
    tabBox(title = tagList(shiny::icon("sitemap"), "Instrucciones de USO -- INICIO"), # Este titulo es solo para el TABSET
           width = "250px", height = "550px",
        # Lista de TABs:
        # NOTA: Se debe usar un tabPanel para elementos con contenido HTML para que sea procesado correctamente
        tabPanel(id="acerdaDeTab", title = "ACERCA DE", # Titulo solo para la pestaña del TAB Panel
          h2("Visualizaci\u00F3n de alto nivel para el an\u00E1lisis e interpretaci\u00F3n de Modelos de Ecuaciones Estructurales"),
          wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
            helpText(tags$b("Autor:"),
               br(), "Carlos Alberto P\u00E9rez Moncada", icon("copyright", "fa-2x"),
               br(), tags$b("Correo electr\u00F3nico:"),
               br(), tags$a("carlos.perez7@udea.edu.co", # NO usar el atributo "title=" impide que se active el link!
                            href= "https://www.linkedin.com/in/carlos-alberto-perez-moncada-07b6b630/",
                            # NO usar el atributo "icon=" explicitamente, impide que se active el icono!
                            target="_blank",icon("linkedin-square", "fa-2x")), br(),
               br(), tags$b("Director del Proyecto: John Freddy Duitama"),
               br(), tags$b("CO-Director del Proyecto: Juan Delgado Lastra"),
               hr(), tags$b("Grupo de Investigaci\u00F3n: Ingenier\u00EDa y Software"),
               br(), tags$b("Programa: Maestr\u00EDa en Ingenier\u00EDa con \u00E9nfasis en Inform\u00E1tica")
            ),
            # La imagen se debe ubicar en una carpeta "/www",
            # al mismo nivel del archivo "ui.R". Alli se puede crear: "www/images"
            hr(), img(src = "images/UdeA_Escudo.jpg")
         ) # FIN wellPanel
       ),
       tabPanel(id="instruccionesUsoTab", title = "Instrucciones de Uso",
          h3("Visualizaci\u00F3n de alto nivel para el an\u00E1lisis e interpretaci\u00F3n de Modelos de Ecuaciones Estructurales"),
          navlistPanel(
            "SEMVIZ: Intrucciones de USO",
            tabPanel(title = "INTRO", icon = icon("plug"), h3("INTRO"),
                     wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
                       # la funcion helpText aplica estilos propios al texto HTML proporcionado
                       includeMarkdown("help_files/controls_help.md")
                     )
            ),
            tabPanel(title = "DATOS", icon = icon("database"), h3("DATOS"),
                     wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
                       # la funcion helpText aplica estilos propios al texto HTML proporcionado
                       includeMarkdown("help_files/controls_help.md")
                     )
            ),
            "-- SECCION SEM --",
            tabPanel(title = "SEM TEST", icon = icon("laptop"), h3("SEM TEST"),
                     wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
                       # la funcion helpText aplica estilos propios al texto HTML proporcionado
                       includeMarkdown("help_files/controls_help.md")
                     )
            )
          ) # FIN navlistPanel
       )
    ) # fin tabBox
  ) # fin fluidRow
)
