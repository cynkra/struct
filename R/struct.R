# turn tibble into struct tibble

#' @export
struct <- function(x) {
  # no op on non tibbles
  if (!is.list(x)) return(x)
  # recurse into tibble columns
  x[] <- purrr::map(x, struct)
  if (rlang::is_bare_list(x)) x <- vctrs::as_list_of(x)
  structure(x, class = union("struct", class(x)))
}

unstruct <- function(x) {
  class(x) <- setdiff(class(x), "struct")
  x
}

# safe subset

subset2 <- function(x, ...) {
  x <- .subset2(x, ...)
  # tibbles and nests can't have NULL elements so NULL means inexistent
  if (is.null(x)) {
    rlang::abort("invalid index")
  }
  x
}

#' @export
`[[.struct` <- function(x, ...) {
  subset2(x, ...)
}

#' @export
`[[.nest` <- function(x, ...) {
  subset2(x, ...)
}

# safe update

set1 <- function(x, ..., value) {
  # cast non struct inputs to struct
  value <- struct(value)
  old <- x[...]
  # unclass and reclass to avoid recursion issues
  cl <- class(x)
  x <- unclass(x)
  x[...] <- vctrs::vec_cast(value, old)
  class(x) <- cl
  x
}

set2 <- function(x, ..., value) {
  # cast non struct inputs to struct
  value <- struct(value)
  old <- x[[...]]
  # unclass and reclass to avoid recursion issues
  cl <- class(x)
  x <- unclass(x)
  x[[...]] <- vctrs::vec_cast(value, old)
  class(x) <- cl
  x
}

#' @export
`[<-.struct` <- function(x, ..., value) {
  set1(x, ..., value = value)
}

#' @export
`[[<-.struct` <- function(x, ..., value) {
  set2(x, ..., value = value)
}

#' @export
`$<-.struct` <- function(x, name, value) {
  set2(x, name, value = value)
}
