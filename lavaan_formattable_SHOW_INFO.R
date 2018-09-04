#
# [04-SEP-2018]
# Pruebas con paquete de formato de datos en data.frame
# autor:
# carlos.perez7@udea.edu.co
#
suppressMessages({
  library(tidyverse, quietly=TRUE)
  library(lavaan, quietly=TRUE)
  library(formattable, quietly=TRUE)
})
#
semModel <- '
ind60 =~ x1 + x2 + x3
dem60 =~ y1 + y2 + y3 + y4
dem65 =~ y5 + y6 + y7 + y8

dem60 ~ ind60
dem65 ~ ind60 + dem60

y1 ~~ y5
y2 ~~ y4 + y6
y3 ~~ y7
y4 ~~ y8
y6 ~~ y8
'
#
fitSem <- sem(semModel, data=PoliticalDemocracy, std.lv=T, meanstructure=T)
summary(fitSem, fit.measures=T, standardized=T)
#
params_std <- lavaan::standardizedSolution(fitSem) # UTIL !
params_std
# ESPECIFICACIONES DE FORMATO Y PRESENTACION PARA LA TABLA SEM DE LAVAAN:
latentFormat <- formatter("span", style = style(color = "green", font.weight = "bold"))
obsFormat <- formatter("span", style = style(color = "red", font.weight = "bold"))
zetaFormat <- formatter("span",
                        style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
                        x ~ sprintf("%.2f (rank: %02d)", x, rank(-x)))
pvalueFormat <- formatter("span",
                        style = x ~ style(color = ifelse(x <= 0.05, "green", "red")),
                        x ~ icontext(ifelse(x <= 0.05, "ok", "remove"),
                                     ifelse(x <= 0.05, "Yes", "No")))
ciLFormat <- formatter("span",x~ style(digits(x,3)))
ciUFormat <- formatter("span",x~ style(digits(x,3)))
ciUFmt <- x ~ round(x, digits=2)
#
# especifica el numero de digitos por defecto al visualizar datos numericos
# NOTA: El valor de 4 conserva el estandar de lavaan en los datos numericos.
options(digits=4)
# Es posible usar la funcio: round(x, digits=2), para aplicar individualmente!
#
formattable(params_std, list(
            lhs = latentFormat, rhs = obsFormat,
            area(col = c(est.std)) ~ normalize_bar("pink", 0.2),
            area(col = c(se)) ~ proportion_bar(),
            z = zetaFormat,
            pvalue = pvalueFormat,
            ci.lower = ciLFormat,
            ci.upper = ciUFmt
          ))
#
param_edges <- params_std %>% # "op" se refiere a la columa "operator"
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
#
param_edges
#
#
formattable(param_edges, list(
  to = formatter("span", style = style(color = "green", font.weight = "bold")),
  from = formatter("span", style = style(color = "purple", font.weight = "bold")),
  val = color_tile("lightgray", "yellow"), # UTIL: presenta un GRADIENTE de color por valor!
  #val = color_text("green", "red") # UTIL: presenta el texto en color cambiando por valor!
  #val = color_bar("lightblue") # UTIL: presenta una Barra de fondo proporcional al valor!
  #val = normalize_bar("lightblue") # UTIL: presenta una Barra de fondo proporcional al valor!
  type = formatter("span", style = style(color = "orange", font.weight = "bold"))
))
#
latent_nodes <- param_edges %>%
  filter(type == "loading") %>%
  distinct(to) %>%
  transmute(metric = to, latent = TRUE)
#
latent_nodes
#
# Node properties
param_nodes <- params_std %>%
  filter(lhs == rhs) %>%
  transmute(metric = lhs, e = est.std) %>%
  left_join(latent_nodes) %>%
  mutate(latent = if_else(is.na(latent), FALSE, latent))
#
formattable(param_nodes, list(
  # Se hace el control del ifelse con la columna explicita del data.frame: param_nodes$latent
  metric = formatter("span", style = ifelse(param_nodes$latent,
                             style(color = "green", font.weight = "bold"), NA)),
  #e = color_tile("white", "orange"),
  e = color_bar("orange"), # Barra de tamaño proporcional al valor !
  latent = formatter("span", style = x ~ style(color = ifelse(x, "green", "red")),
                         x ~ icontext(ifelse(x, "stats", "save"), ifelse(x, "Yes", "No")))
))
#
