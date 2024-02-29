# struct -----------------------------------------------------------------------

#' @export
`[[.struct` <- function(x, ...) {
  subset2(x, ...)
}

#' @export
`$.struct` <- function(x, ...) {
  subset2(x, ...)
}

#' @export
`[[<-.struct` <- function(x, ..., value) {
  set2(x, ..., value = value)
}

#' @export
`[<-.struct` <- function(x, ..., value) {
  set1(x, ..., value = value)
}

#' @export
`$<-.struct` <- function(x, ..., value) {
  set2(x, ..., value = value)
}

# n_struct ---------------------------------------------------------------------

#' @export
`[[.n_struct` <- function(x, ...) {
  subset2_df(x, ...)
}

#' @export
`[.n_struct` <- function(x, i, j, ..., extract = NULL) {
  if (!is.null(extract) && (!missing(i) || !missing(j))) {
    abort("`extract` cannot be combined with other indexes")
  }
  cl <- class(x)
  class(x) <- setdiff(class(x), "n_struct")
  if (!is.null(extract)) {
    out <- struct(as.list(x[extract,]))
  } else if (missing(j)) {
    if (length(sys.call()) > 3) {
      out <- structure(x[i,], class = cl)
    } else {
      out <- structure(x[i], class = cl)
    }
  } else {
    out <- structure(x[i, j], class = cl)
  }
  out
}

#' @export
`[[<-.n_struct` <- function(x, ..., value) {
  set2_df(x, ..., value = value)
}

#' @export
`$<-.n_struct` <- function(x, ..., value) {
  set2_df(x, ..., value = value)
}

#' @export
print.struct <- function(x, ...) {
  # leverage the pillar stuff by converting to tibble, but keep the object
  # a list so we cannot use data frame ops on it
  x2 <- as_tibble(unclass(x))
  x2 <- structure(x2, class = union("struct", class(x2)))
  writeLines(format(x2))
  invisible(x)
}

#' @export
tbl_sum.struct <- function(x, ...) {
  c("struct object" = sprintf("%s element(s)", length(x)))
}

# struct_elt -------------------------------------------------------------------

#' @export
type_sum.struct_elt <- function(x, ...) {
  type_sum(.subset2(x, 1))
}
