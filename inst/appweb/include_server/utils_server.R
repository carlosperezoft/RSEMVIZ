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

nodosGrafoSEM <- function(fitModel) {
  param_nodes <- nodosModeloSEM(fitModel)
  nodesVis <- data.frame(
    id = param_nodes$metric,
    label = param_nodes$metric,
    group = if_else(param_nodes$latent, "LATENTE", "OBSERVADA"),
    value = param_nodes$e,
    # SHAPE aqui tiene prioridad sobre el visGroups(..)
    shape = if_else(param_nodes$latent, "ellipse", "box"),
    title = paste0("<p><b>", param_nodes$metric,"</b><br>VAL:",param_nodes$e,"</p>"),
    # COLOR aqui tiene prioridad sobre el visGroups(..)
    color = if_else(param_nodes$latent, "orange", "grey"),
    shadow = param_nodes$latent
  )
  return(nodesVis)
}

rutasGrafoSEM <- function(fitModel) {
  param_edges <- rutasModeloSEM(fitModel)
  edgesVis <- data.frame(
    from = param_edges$from,
    to = param_edges$to,
    # NO es recomendable el LABEL, pues oculta mucho la "flecha"
    #label = paste("VAL", format(round(param_edges$val, 2), nsmall=2)),
    title = paste("VAL", format(round(param_edges$val, 2), nsmall=2)),
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
