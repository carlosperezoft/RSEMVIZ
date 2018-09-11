# autor -------------------------------------------------------------------
# carlos.perez7@udea.edu.co
# 10/09/2018 18:55:28 p. m.
#
hipotSEMFit <- function() {
  lavaan::parameterEstimates(semFitLocal())
}

output$grafoHipotSEMOut <- renderVisNetwork({
  getGrafoModelSEMBase()
})

output$tablaHipostesisModeloOut <- renderFormattable({
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
  formattable(hipotSEMFit(), list(
    lhs = latentFormat, rhs = obsFormat,
    area(col = c(est)) ~ normalize_bar("pink", 0.2),
    area(col = c(se)) ~ proportion_bar(),
    z = zetaFormat,
    pvalue = pvalueFormat,
    ci.lower = ciLFormat,
    ci.upper = ciUFmt
  ))
})

output$tablaHipostesisParamsOut <- renderFormattable({
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
  formattable(getParamEstimatesByName(hipotSEMFit(), "IMPINT"), list(
    to = latentFormat, from = obsFormat,
    area(col = c(val)) ~ normalize_bar("pink", 0.2),
    type = latentFormat
  ))
})
