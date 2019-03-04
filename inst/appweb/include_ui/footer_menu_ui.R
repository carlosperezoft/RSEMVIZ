# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
# DEFINICION DE PIE DE PAGINA para PANEL DE MENU IZQUIERDA:
tags$footer(tags$div(tags$b("* SEMVIZ Developer *"),
     a(href= "https://www.linkedin.com/in/carlos-alberto-perez-moncada-07b6b630/",
       target="_blank",icon("linkedin-square", "fa-1x")),
     br(), "- GPLv3 Licence.", br(), "- Copyright \u00A9 2019 U. de A.", br(),
     "- Medell\u00EDn - Colombia."
     # , br(),
     # "--------", icon("power-off", "fa-1x"), "--------",
     # tags$button(id = 'closeApp', type = "button", class = "btn action-button",
     #     onclick = "setTimeout(function(){window.close();},500);",
     #     # close browser
     #     "SALIR..."
     # )
  ) # FIN DIV
) # FIN FOOTER
