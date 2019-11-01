# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 01/09/2018 5:47:28 p. m.
#
## Cargar las funciones propias del paquete semviz ubicadas en /include_server dir base:
##
# Funcion para obtener un data.frame con los elementos asociamos con el modelo sem
# obtenido por medio de lavaan.
# Parametro: fitModel, el modelo sem calculado.
#
# IMPORTANTE: Estas funciones de utilidad usan el modelo SEM estimado (fitModel), el cual se actualiza
# por medio de la funcion "Reactiva" semFitLocal(..) definida en el archivo: "modelo_sem_server.R".
# -- Esto implica que son llamadas solo cuando la estimacion del modelo cambia al usar el boton: "input$runSEMBtn"
#    del TAB en al UI: "modelo_sem_tab.R"
#
#
rutasModeloSEM <- function(fitModel) {
  param_edges <- fitModel %>% # "op" se refiere a la columa "operator"
    # Usando el filtro con o sin nodos iguales (lhs != rhs), en SEM se usa para correlaciones
    # filter(op %in% c("=~", "~", "~~"), lhs != rhs, pvalue < .10) %>%
    filter(op %in% c("=~", "~", "~~"), pvalue < .10) %>%
    transmute(from = rhs, to = lhs,
              val = est.std, # En standardizedSolution(..) toma todas las estimaciones estandarizadas...
              type = dplyr::case_when(
                op == "=~" ~ "loading",
                op == "~"  ~ "regression",
                op == "~~" ~ "correlation",
                TRUE ~ NA_character_))
  #
  return(param_edges)
}
#
latentesModeloSEM <- function(fitModel) {
  latent_nodes <- rutasModeloSEM(fitModel) %>%
    filter(type == "loading") %>%
    distinct(to) %>%
    transmute(node_name = to, latent = TRUE)
  #
  return(latent_nodes)
}
#
nodosModeloSEM <- function(fitModel) {
  model_nodes <- fitModel %>%
    filter(lhs == rhs) %>%
    transmute(node_name = lhs, e = est.std) %>%
    left_join(latentesModeloSEM(fitModel)) %>%
    mutate(latent = if_else(is.na(latent), FALSE, latent))
  #
  return(model_nodes)
}

# Las propiedades aqui especificadas aplican SOLO al nodo de forma individual.
# Para que sea de aplicacion a todos los NODOS debe usarse: visNodes(..)
# al crear el grafo con visNetwork(..)
#
nodosGrafoSEM <- function(fitModel, nodes_labels = NULL) {
  param_nodes <- nodosModeloSEM(fitModel)
  nodesVis <- data.frame(
    id = param_nodes$node_name,
    label = param_nodes$node_name, # No se asigna el LABEL directamente debido al orden de aparicion, es diferente!
    group = if_else(param_nodes$latent, "LATENTE", "OBSERVADA"),
    # La figura escala con el "value" del nodo, verificar que valor usar en cada caso LAT/OBS?
    # POR_HACER: Sumar las cargas (beta) de las OBRs que explica el factor y asignar aqui para LAT.
    #            En caso de OBR, calcular su comunalidad (beta est.std^2), y asignar aqui.
    value = param_nodes$e +  10,
    # title equivale a un TOOLTIP !
    title = NA, # paste0("<p><b>", param_nodes$node_name,"</b><br>VAR_EST:",format(round(param_nodes$e, 3), nsmall=3),"</p>"),
    # SHAPE aqui tiene prioridad sobre el visGroups(..)
    #shape = if_else(param_nodes$latent, "dot", "square"),
    # COLOR aqui tiene prioridad sobre el visGroups(..), el atributo color por Nodo debe ser solo un valor.
    #color = if_else(param_nodes$latent, "orange", "lightblue")
    # Propiedades de color que aplican solo a nivel de nodo cuando se usa la funcion visNodes(..)
    color.highlight = "red",
    color.hover = "grey",
    stringsAsFactors=FALSE
    #shadow = param_nodes$latent
  )
  # Se actualiza el Titulo descriptivo usado en cada NODO:
  for(i in 1:nrow(nodesVis)) {
    if(!is.null(nodes_labels)) { # TODO: probar esta verificacion del NULL, es para los casos NO default
      desc <- nodes_labels %>% filter(variable == nodesVis[i,]$label) %>% select("desc") # variable: es columna del nodes_labels
      nodesVis[i,]$title <- paste0("<p><b>", nodesVis[i,]$label,"</b><br>",desc,"</p>")
    }
  }
  #
  return(nodesVis)
}
#
getNodeLabel <- function(nodes_labels, node_name){ # variable: es columna del nodes_labels
  label <- nodes_labels %>% filter(variable == node_name) %>% select("desc")
  return(label)
}
#
#
# Las propiedades aqui especificadas aplican SOLO a la ruta de forma individual.
# Para que sea de aplicacion a todos las RUTAS debe usarse: visEdges(..) al crear el grafo con visNetwork(..)
#
rutasGrafoSEM <- function(fitModel) {
  param_edges <- rutasModeloSEM(fitModel)
  edgesVis <- data.frame(
    from = param_edges$from,
    to = param_edges$to,
    type = param_edges$type, # usado en menu medicion: Redes>>Hive
    # La flecha escala con la magnitud de "value"!
    value  = param_edges$val,  # El value es usado para escalar el ancho del arco (edge), se controla con scaling en "visEdges"
    length = param_edges$val * 200, # Se multiplica debido a que el "valor" esta en el intervalo [0,1]
    # width  = param_edges$val, # Para aumentar el ancho de la linea en el arco...
    # NO es recomendable el LABEL, pues oculta mucho la "flecha"
    # label = paste("PAR", format(round(param_edges$val, 2), nsmall=2)),
    # title = paste("PAR:", format(round(param_edges$val, 3), nsmall=3)),
    title = dplyr::case_when(
      param_edges$type == "loading" ~ paste("lambda:", format(round(param_edges$val, 3), nsmall=3)),
      param_edges$type == "regression"  ~ paste("beta:", format(round(param_edges$val, 3), nsmall=3)),
      param_edges$type == "correlation" ~ paste("corr.:", format(round(param_edges$val, 3), nsmall=3))
    ),
    # El "case" de la flecha segun el "type" es para ubicar la "cabeza" de la flecha en el extremo indicado:
    arrows = dplyr::case_when(
      param_edges$type == "loading" ~ "from",
      param_edges$type == "regression"  ~ "to",
      param_edges$type == "correlation" ~ "middle"
    ),
     # Se ajusta aqui el gradiente de color para el arco, segun la carga del factor o predictor:
    color = dplyr::case_when(
      param_edges$type == "loading" ~ if_else(param_edges$val < 0.5, "pink", "red"),
      param_edges$type == "regression"  ~ if_else(param_edges$val < 0.5, "cadetblue", "blue"),
      param_edges$type == "correlation" ~ if_else(param_edges$val < 0.5, "purple4", "purple")
    ),
    stringsAsFactors=FALSE
  )
  return(edgesVis)
}
# Utilizado en Hipotesis Model Server.R
getParamEstimatesByName <- function(fitModel, paramName) {
  paramData <- fitModel %>% # "op" se refiere a la columa "operator"
    # Usando el filtro:
    filter(lhs == paramName) %>%
    filter(op %in% c("=~", "~", "~~")) %>% # ,pvalue < .10
    transmute(desde = lhs,
      tipo = dplyr::case_when(
        op == "=~" ~ "carga-factor",
        op == "~"  ~ "regresi\u00F3n",
        op == "~~" ~ "correl./varianza",
        TRUE ~ NA_character_),
      hacia = rhs, est.base = est, est.stand = std.all,
      ic.inf = ci.lower, ic.sup = ci.upper,
      error = se, valor_p = pvalue, valor_z = z
    )
  return(paramData)
}
# Funcion para generar "n" cadenas de caracteres de longitud "lenght"
makeRandomString <- function(n=1, lenght=12){
  randomString <- c(1:n)  # initialize vector
  for (i in 1:n)  {  # "sample" es una funcion de muestreo aleatorio de R
    randomString[i] <- paste(sample(c(0:9, letters, LETTERS),
                             lenght, replace=TRUE), collapse="")
  }
  return(randomString)
}
# Funcion que permite validar si un data.frame tiene un conjunto de columnas,
# esto para evitar errores al consultarlas en dicho DF.
# TIP: all() funcion de R que valida si TODOS los valores en un
# "logical vector" (%in% retorna uno, p.ej: c(T,T,F)) son "true" o no.
#
existenColumnas <- function(dataFrame, columnas) {
  return(all(columnas %in% colnames(dataFrame)))
}
#
