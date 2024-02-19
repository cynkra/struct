
<!-- README.md is generated from README.Rmd. Please edit that file -->

# struct

{struct} provides ways to modify objects more strictly, guaranteeing
that we keep the type of the modified element, where type is defined by
`vctrs::vec_ptype()`.

This is designed to work with nested tibbles

## Installation

Install with:

``` r
remotes::install_github("cynkra/struct")
```

## Example

``` r
library(struct)
library(tibble)

x1 <- tibble(
  a = 1:2,
  b = list(tibble(c = 3:4, d = 5:6)),
  c = tibble(e = 7:8, f = 9:10)
)

x2 <- struct(x1)

# works
x2$a <- 11:12
x2$b <- list(tibble(c = 13:14, d = 15:16))
x2$c <- tibble(e = 17:18, f = 19:20)

# fails
x2$a <- c("a", "b")
#> Error in `set2()` at struct/R/struct.R:77:3:
#> ! Can't convert `value` <character> to <integer>.
x2$b <- list("a", "b")
#> Error in `set2()` at struct/R/struct.R:77:3:
#> ! Can't convert `value` <struct> to <struct>.
x2$c <- 1
#> Error in `set2()` at struct/R/struct.R:77:3:
#> ! Can't convert `value` <double> to <struct>.
x2[["z"]]
#> Error in `subset2()` at struct/R/struct.R:31:3:
#> ! invalid index
```
