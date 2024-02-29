# safe subset

subset2 <- function(x, i, ...) {
  elt <- .subset2(x, i)
  # tibbles and nests can't have NULL elements so NULL means inexistent
  if (is.null(elt)) {
    rlang::abort("invalid index")
  }
  elt[[1]]
}

subset2_df <- function(x, i, ...) {
  elt <- .subset2(x, i)
  # tibbles and nests can't have NULL elements so NULL means inexistent
  if (is.null(elt)) {
    rlang::abort("invalid index")
  }
  elt
}


# safe update

set1 <- function(x, ..., value) {
  # cast non struct inputs to struct
  value <- struct(value)
  # unclass and reclass to avoid recursion issues
  cl <- class(x)
  x <- unclass(x)
  x[...] <- purrr::map2(x[...], value, function(old, new) vctrs::vec_cast(new, old))
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
  x[[...]] <- list_of(vctrs::vec_cast(value, old))
  class(x) <- cl
  x
}

set2_df <- function(x, ..., value) {
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
