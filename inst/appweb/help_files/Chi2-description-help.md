
##  An&aacute;lisis de bondad de Ajuste con la prueba Chi-Cuadrado (X&sup2;) 

Se debe tener en cuenta que valores elevados de **X&sup2;** generalmente son asociados a niveles de
significaci&oacute;n bajos `(p < 0.05)`, lo cual sugiere rechazar la hip&oacute;tesis nula y por tanto el modelo.

Ahora, valores bajos de **X&sup2;** son asociados a niveles de significaci&oacute;n apreciables `(p > 0.10)`;
lo cual implica que no es posible rechazar la hip&oacute;tesis nula y esto sugiere la aceptacion del modelo.

##  Usar una combinaci&oacute;n

De forma complementaria, se debe tener en cuenta que la prueba **X&sup2;** se basa en el supuesto de normalidad
multivariada de los datos y que es sensible al tama&nacute;o de la muestra `(N)` en los extremos; es decir,
se ve afectada por muestras peque&nacute;as `(N < 50)` y muestras grandes `(N > 800)`. Cabe resaltar que no
es penalizado por la complejidad del modelo.

- De lo anterior, para evaluar la bondad de ajuste autores como **Kline** sugieren el uso combinado de: 

1. **X&sup2;**
2. **RMSEA**
3. **CFI** 
4. **SRMR** (_Residuales_)
                    
## Referencias
```
Autores sobre SEM: Jöreskog & Sörbom (1969), Kline (2005).
```
