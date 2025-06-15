
<!-- README.md is generated from README.Rmd. Please edit that file -->

# struct

{struct} provides ways to modify objects more strictly, guaranteeing
that we keep the type of the modified element, where type is defined by
`vctrs::vec_ptype()`.

The `struct()` function gives a subclass “struct” to the objects if its
internal type is list (thus including data frames), and recursively to
its list components.

When assigning new values, we give it the “struct” subclass if relevant
then use `vctrs::vec_cast()` to check the compatibility of the input
with the output, and apply coercion if necessary.

## Installation

Install with:

``` r
# install.packages("pak")
pak::pak("cynkra/struct")
```

## Example

``` r
library(struct)
library(tibble)

x1 <- list(
  a = 1,
  b = list(tibble(c = 3:4, d = 5:6)),
  c = tibble(e = 7:8, f = 9:10),
  y = list(z = c("a", "b"))
)
x2 <- deep_struct(x1)

x2
#> # list_struct object: 4 element(s)
#>   a            b                        c                  y             
#> * <dbl>        <list<tbbl_str[,2]>>     <tbbl_str[,2]>     <named list>  
#> 1 <scalar [1]> <list<tbbl_str[,2]> [1]> <tbbl_str [2 × 2]> <lst_strc [1]>

print_tree(x2)
#> █─ x2 <lst_strc>
#> ├─── a <scalar>
#> ├─█─ b <list<tbbl_str[,2]>>
#> ├─█─ c <tbbl_str[,2]>
#>   ├─── e <int>
#>   ├─── f <int>
#> ├─█─ y <lst_strc>
#>   ├─── z <chr>

# works
x2$a <- 11
x2$b <- list(tibble(c = 13:14, d = 15:16))
x2$c <- tibble(e = 17:18, f = 19:20)

# fails
x2$a <- c(11, 12)
#> Error in `struct_cast()` at struct/R/modify.R:8:3:
#> ! not a scalar
x2$a <- "a"
#> Error in `structure()` at struct/R/classes.R:52:11:
#> ! Can't convert `new` <character> to <double>.
x2$b <- list("a", "b")
#> Error in `struct_cast()` at struct/R/modify.R:8:3:
#> ! Can't convert `..1` <character> to <tibble_struct>.
x2$c <- 1
#> Error in `struct_cast()` at struct/R/modify.R:8:3:
#> ! Can't convert `new` <double> to <tbl_df>.
x2[["z"]]
#> Error in `x2[["z"]]`:
#> ! Invalid index
#> ✖ element `z` not found
```
