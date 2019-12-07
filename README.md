
<!-- README.md is generated from README.Rmd. Please edit that file -->

# flowers

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/flowers)](https://CRAN.R-project.org/package=flowers)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

Flowers is a package for generating flower plots. It was derived from
code from Jim Regetz at NCEAS, and then rewritten and extended by the
OHI project. This package formalizes the approach into an easily
re-usable function for generating custom flower plots for multiple
scenarios.

## Quick Start

This is a basic example which shows you how to create a flower plot from
an appropriately structured data set:

``` r
library(flowers)
data(ohi)
plot_flower(ohi, "OHI Example Flower")
```

<img src="man/figures/README-example-1.png" width="70%" />

Currently `plot_flower()` expects particular column names and semantics,
but this could be made more flexible. See the structure of OHI for an
example. In particular, it uses columns `score`, `weight`,
`name_flower`, and `name_supra` to create the plot.

By default the flower petals are colored proportionally to the `score`
values as show in the OHI example above. One can provide a color palette
(`colors`) to the `plot_flower()` function to control the gradient used.

The `weight` variable controls the relative widths of the petals, and
should range from 0 to 1. The petal labels are taken from the
`name_flower` variable, and the grouping category labels are taken from
the `name_supra` variable. Other columsn in the data frame are ignored.

    #> 'data.frame':    13 obs. of  6 variables:
    #>  $ goal       : chr  "FIS" "MAR" "AO" "NP" ...
    #>  $ score      : num  50.5 NA 79.3 95.2 81.9 ...
    #>  $ order      : num  1.1 1.2 2 3 5 6 7.1 7.2 8.1 8.2 ...
    #>  $ weight     : num  0.5 0.5 1 1 1 1 0.5 0.5 0.5 0.5 ...
    #>  $ name_supra : chr  "Food Provision" "Food Provision" NA NA ...
    #>  $ name_flower: chr  "Fisheries" "Mariculture" "Artisanal Needs" "Marine Mammal Harvest" ...

Alternatively, by setting `fixed_colors = TRUE` you can also color the
petals with discrete colors determined by the `name_flower` categories,
in which case you will likely want to provide a `colors` palette with at
least as many colors as you have petals in the plot. Here’s an example
with four fixed petals, in which we also provide only missing values to
`name_supra` so that no grouping labels are used:

``` r
    library(dplyr)
    df <- data.frame(order = c(1, 4, 3, 2),
                        score = c(90, 80, 70, 60),
                        weight = c(1, 1, 1, 1),
                        goal = c("F", "A", "I", "R"),
                        name_flower = c("Findable", "Accessible", "Interoperable", "Reusable"),
                        name_supra = c(NA, NA, NA, NA),
                        stringsAsFactors = FALSE) %>% arrange(order)
    d1_colors <- c( "#c70a61", "#ff582d", "#1a6379", "#60c5e4")
    plot_flower(df, title = "FAIR Metrics", fixed_colors=TRUE, colors = d1_colors)
```

<img src="man/figures/README-fair_plot-1.png" width="70%" />

## Installation

You can install the development version of flowers from
[GitHub](https://github.com/mbjones/flowers) with:

``` r
devtools::install_github("mbjones/flowers")
```

You can install the released version of flowers from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("flowers")
```
