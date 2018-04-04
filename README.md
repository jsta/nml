
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/nml)](https://cran.r-project.org/package=nml)

<!-- README.md is generated from README.Rmd. Please edit that file -->
nml
===

An R parser of Fortran namelist files.

Installation
------------

You can install nml from github with:

``` r
# install.packages("devtools")
devtools::install_github("jsta/nml")
```

Example
-------

``` r
library(nml)
read_nml("tests/testthat/sample.nml")
#> $config_nml
#> $config_nml$input
#> [1] "wind.nc"
#> 
#> $config_nml$steps
#> [1] 864
#> 
#> $config_nml$layout
#> [1]  8 16
#> 
#> $config_nml$visc
#> [1] 1e-04
#> 
#> $config_nml$use_biharmonic
#> [1] FALSE
#> 
#> 
#> attr(,"class")
#> [1] "nml"
```

Prior Art
---------

This package was inspired by [f90nml](https://github.com/marshallward/f90nml) and [glmtools](https://github.com/USGS-R/glmtools).
