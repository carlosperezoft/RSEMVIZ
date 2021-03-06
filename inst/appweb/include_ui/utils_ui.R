# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# NOTA: Esta opcion de invicacion de menu de ayuda es generica usando el tipo
# predefinido de "notifications". Es limitado pues no permite usar un TAB panel o una OututUI.
# -- Se puede en su defecto invocar una pagina HTML externa con el window.open(..).
# -- Tambien se puede invocar un elemento en "localhost" ubicado en la carpeta "www" de la
#    la aplicacion WEB Shiny dashboard (en este caso se probo con /ayuda/*)
#
# Opcion de user panel para el menu principal (izquierda)
cperezUsrPanel <- sidebarUserPanel(name = a("Carlos A. P\u00E9rez Moncada", target = "_blank_",
   href = "https://www.linkedin.com/in/carlos-alberto-perez-moncada-07b6b630/"),
   subtitle = "Ingeniero de Sistemas.",
   image = "images/Foto_CPEREZ.png"
)

# LinkedIn Sharing link
linkedInHead <- tags$li(class = "dropdown",
    tags$a(href = "https://www.linkedin.com/in/carlos-alberto-perez-moncada-07b6b630/",
           target = "_blank",
           tags$img(height = "18px", src = "images/linkedin.png")
  )
)

msgHelpMenu <- dropdownMenu(
  type = "notifications",
  icon = icon("question-circle", "fa-1x"), # Para ampliar se usa fa-2x...
  badgeStatus = NULL,
  headerText = "AYUDA GENERAL SEMVIZ:",

  notificationItem("Acerca de", icon = icon("copyright"),
        href = "javascript:window.open('/ayuda/semviz.html', '_blank')"),
  notificationItem("Modelos SEM, TUTORIAL", icon = icon("gears"),
        href = "javascript:window.open('http://www.structuralequations.org/', '_blank')"),
  notificationItem("R lavaan, TUTORIAL", icon = icon("paint-brush"),
        href = "javascript:window.open('http://lavaan.ugent.be/', '_blank')"),
  notificationItem("shinydashboard, Estructura UTIL!", icon = icon("desktop"),
        href = "javascript:window.open('https://rstudio.github.io/shinydashboard/structure.html', '_blank')"),
  notificationItem("SALIR...", icon = icon("power-off"),
                   href = "javascript:setTimeout(function(){window.close();},500);")

)
