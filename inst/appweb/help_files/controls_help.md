# :: SEMVIZ -- CASO DE ESTUDIO <img src="images/UdeA_Escudo.jpg" align="right"/>


[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/shinyhelper)](https://cran.r-project.org/package=shinyhelper)
[![CRAN_Downloads](https://cranlogs.r-pkg.org/badges/shinyhelper)](https://cran.r-project.org/package=shinyhelper)
[![Travis-CI Build Status](https://travis-ci.org/cwthom/shinyhelper.svg?branch=master)](https://travis-ci.org/cwthom/shinyhelper)

CASO DE ESTUDIO: Grupos de Investigaci&oacute;n U. de A.

Diagrama elaborado en JAVA ONIX:

* Presentado con valores de estimaci&oacute;n de prueba:

<img src="images/ONIX_SEM_GRUPOS_Invest_UdeA.png" width = "900px", height = "500px" align="center"/>

## Installation

**shinyhelper 0.3.0 now on CRAN!** Go to: [https://cran.r-project.org/package=shinyhelper](https://cran.r-project.org/package=shinyhelper) 
You can install the package with:
```
install.packages("shinyhelper")
```

To get the latest development version, you can use the `devtools` package to install from GitHub directly:
```
devtools::install_github("cwthom/shinyhelper")
```

In both cases, then load the package in with:
```
library(shinyhelper)
```

## Demo

There is a live demo hosted on shinyapps.io. [Click here to go to the demo!](https://cwthom94.shinyapps.io/shinyhelper-demo/)

Alternatively, run the demo locally with:

```
library(shinyhelper)

shinyhelper_demo()
```


## Usage

You can add help files to any shiny element, including all inputs and outputs, with a simple call to `helper()`:
```
# load the package
library(shinyhelper)

...
# For elements in your ui you wish to add a help icon to
helper(plotOutput(outputId = "plot"))

# if you have %>% loaded, you can do plotOutput(outputId = "plot") %>% helper()

...
# In your server script, include:
observe_helpers()

# this triggers the modal dialogs when the user clicks an icon
# specify the name of your directory of help markdown files here

# e.g. observe_helpers(help_dir = "help_mds") will look for a directory called help_mds

## Credits

Obviously, this package would not be possible (or indeed meaningful) without the incredible [shiny](https://github.com/rstudio/shiny) package. Full credit to the authors of shiny for doing all of the actual work!

UNIVERSIDAD DE ANTIOQUIA 2018.
