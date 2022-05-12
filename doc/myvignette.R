## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=FALSE, tidy = TRUE, size="tiny"------------------------------------
#  library(devtools)
#  devtools::install_github("karlapenag/cpdb", build_vignettes = TRUE)

## ----setup--------------------------------------------------------------------
library(cpdb)

## -----------------------------------------------------------------------------
get_contacts("4q21", "A", 15, 6)

## -----------------------------------------------------------------------------
plot_closest("4q21", "A", 15, 8)

