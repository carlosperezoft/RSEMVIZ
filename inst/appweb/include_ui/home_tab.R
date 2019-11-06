# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
tabItem(tabName = "homeTab",
  h3("Aplicaci\u00F3n SEMVIZ. v 1.0"), # Este titulo es para la seccion completa
  fluidRow(
    tabBox(title = tagList(shiny::icon("sitemap"), "HOME"), # Este titulo es solo para el TABSET
           width = "250px", height = "650px",
        # Lista de TABs:
        tabPanel(id="inicioTab", title = tagList(shiny::icon("home"), "INICIO"),
          tags$img(
            src = "images/Creador-Energia-Biblioteca.jpg",
            style = 'position: absolute'
          )
        ),
        # NOTA: Se debe usar un tabPanel para elementos con contenido HTML para que sea procesado correctamente
        tabPanel(id="acerdaDeTab", title = tagList(shiny::icon("copyright"), "ACERCA DE"), # Titulo solo para la pestaña del TAB Panel
          h4("Visualizaci\u00F3n de alto nivel para el an\u00E1lisis e interpretaci\u00F3n de Modelos de Ecuaciones Estructurales"),
          wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
            helpText(tags$b("Autor:"),
               br(), "Carlos Alberto P\u00E9rez Moncada", icon("copyright", "fa-1x"),
               br(), tags$b("Correo electr\u00F3nico:"),
               br(), tags$a("carlos.perez7@udea.edu.co / carlos.perezoft@gmail.com",
                            # NO usar el atributo "title=" impide que se active el link!
                            href= "http://www.gmail.com",
                            # NO usar el atributo "icon=" explicitamente, impide que se active el icono!
                            target="_blank", tags$img(height = "20px", src = "images/email.png")), br(),
               br(), tags$b("Director del Proyecto: John Freddy Duitama"),
               br(), tags$b("CO-Director del Proyecto: Juan Delgado Lastra"),
               br(), tags$b("Grupo de Investigaci\u00F3n: Ingenier\u00EDa y Software"),
               br(), tags$b("Programa: Maestr\u00EDa en Ingenier\u00EDa con \u00E9nfasis en Inform\u00E1tica")
            ),
            # La imagen se debe ubicar en una carpeta "/www",
            # al mismo nivel del archivo "ui.R". Alli se puede crear: "www/images"
            br(), img(src = "images/UdeA_Escudo.jpg"),
            # Definicion del FOOTER - LICENCIA :
            source("include_ui/footer_menu_ui.R", local = TRUE)$value
         ) # FIN wellPanel
       )
      , tabPanel(id="instruccionesUsoTab", title = tagList(shiny::icon("question-circle"), "Instrucciones de Uso"),
          h4("Visualizaci\u00F3n de alto nivel para el an\u00E1lisis e interpretaci\u00F3n de Modelos de Ecuaciones Estructurales"),
          tabsetPanel(type = "tabs",
            tabPanel(title = "Inicio - Casos de Estudio", icon = icon("plug"),
               wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
                 # la funcion helpText aplica estilos propios al texto HTML proporcionado
                 includeMarkdown("help_files/inicio-casos-estudio-help.md")
               )
            ),
            tabPanel(title = "Datos y Estimaci\u00F3n", icon = icon("database"),
               wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
                 # la funcion helpText aplica estilos propios al texto HTML proporcionado
                 includeMarkdown("help_files/datos-estimacion-help.md")
               )
            ),
            tabPanel(title = "Resultados Modelo SEM", icon = icon("laptop"),
               wellPanel(# El wellPanel adiciona un "contorno Gris" a los elementos contenidos
                 # la funcion helpText aplica estilos propios al texto HTML proporcionado
                 includeMarkdown("help_files/resultados-modelo-sem-help.md")
               )
            )
          ) # FIN navlistPanel
       )
    ) # fin tabBox
  ) # fin fluidRow
)
