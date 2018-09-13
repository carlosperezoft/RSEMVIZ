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
rutasModeloSEM <- function(fitModel) {
  param_edges <- fitModel %>% # "op" se refiere a la columa "operator"
    # Usando el filtro con o sin nodos iguales (lhs != rhs), en SEM se usa para correlaciones
    # filter(op %in% c("=~", "~", "~~"), lhs != rhs, pvalue < .10) %>%
    filter(op %in% c("=~", "~", "~~"), pvalue < .10) %>%
    transmute(to = lhs,
              from = rhs,
              val = est.std,
              type = dplyr::case_when(
                op == "=~" ~ "loading",
                op == "~"  ~ "regression",
                op == "~~" ~ "correlation",
                TRUE ~ NA_character_))
  return(param_edges)
}

latentesModeloSEM <- function(fitModel) {
  latent_nodes <- rutasModeloSEM(fitModel) %>%
    filter(type == "loading") %>%
    distinct(to) %>%
    transmute(metric = to, latent = TRUE)
  return(latent_nodes)
}

nodosModeloSEM <- function(fitModel) {
  param_edges <- fitModel %>%
    filter(lhs == rhs) %>%
    transmute(metric = lhs, e = est.std) %>%
    left_join(latentesModeloSEM(fitModel)) %>%
    mutate(latent = if_else(is.na(latent), FALSE, latent))
  return(param_edges)
}

# Las propiedades aqui especificadas aplican SOLO al nodo de forma individual.
# Para que sea de aplicacion a todos los NODOS debe usarse: visNodes(..) al crear el grafo con visNetwork(..)
#
nodosGrafoSEM <- function(fitModel) {
  param_nodes <- nodosModeloSEM(fitModel)
  nodesVis <- data.frame(
    id = param_nodes$metric,
    label = param_nodes$metric,
    group = if_else(param_nodes$latent, "LATENTE", "OBSERVADA"),
    # La figura escala con el "value" del nodo, varficar que valor usar en cada caso LAT/OBS?
    value = param_nodes$e,
    # title equivale a un TOOLTIP !
    title = paste0("<p><b>", param_nodes$metric,"</b><br>Err:",format(round(param_nodes$e, 3), nsmall=3),"</p>"),
    # SHAPE aqui tiene prioridad sobre el visGroups(..)
    #shape = if_else(param_nodes$latent, "dot", "square"),
    # COLOR aqui tiene prioridad sobre el visGroups(..), el atributo color por Nodo debe ser solo un valor.
    #color = if_else(param_nodes$latent, "orange", "lightblue")
    # Propiedades de color que aplican solo a nivel de nodo cuando se usa la funcion visNodes(..)
    color.highlight = "red",
    color.hover = "grey"
    #shadow = param_nodes$latent
  )
  return(nodesVis)
}

# Las propiedades aqui especificadas aplican SOLO a la ruta de forma individual.
# Para que sea de aplicacion a todos las RUTAS debe usarse: visEdges(..) al crear el grafo con visNetwork(..)
#
rutasGrafoSEM <- function(fitModel) {
  param_edges <- rutasModeloSEM(fitModel)
  edgesVis <- data.frame(
    from = param_edges$from,
    to = param_edges$to,
    # NO es recomendable el LABEL, pues oculta mucho la "flecha"
    #label = paste("PAR", format(round(param_edges$val, 2), nsmall=2)),
    #title = paste("PAR:", format(round(param_edges$val, 3), nsmall=3)),
    title = dplyr::case_when(
      param_edges$type == "loading" ~ paste("lamda:", format(round(param_edges$val, 3), nsmall=3)),
      param_edges$type == "regression"  ~ paste("beta:", format(round(param_edges$val, 3), nsmall=3)),
      param_edges$type == "correlation" ~ paste("phi:", format(round(param_edges$val, 3), nsmall=3))
    ),
    arrows = dplyr::case_when(
      param_edges$type == "loading" ~ "from",
      param_edges$type == "regression"  ~ "to",
      param_edges$type == "correlation" ~ "middle"
    ),
    color = dplyr::case_when(
      param_edges$type == "loading" ~ "red",
      param_edges$type == "regression"  ~ "blue",
      param_edges$type == "correlation" ~ "purple"
    )
  )
  return(edgesVis)
}

getParamEstimatesByName <- function(fitModel, paramName) {
  paramData <- fitModel %>% # "op" se refiere a la columa "operator"
    # Usando el filtro:
    filter(lhs == paramName) %>%
    filter(op %in% c("=~", "~", "~~"), pvalue < .10) %>%
    transmute(to = lhs,
              from = rhs,
              val = est,
              type = dplyr::case_when(
                op == "=~" ~ "loading",
                op == "~"  ~ "regression",
                op == "~~" ~ "correlation",
                TRUE ~ NA_character_))
  return(paramData)
}
