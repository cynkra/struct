# Subseting a struct is standard, just stricter.
# We do checks then apply NextMethod()
# Additionally `[.tibble_struct` has an `extract` arg to extract a row into a list_struct
# The global variable globals$activate_struct allows standard free subsetting
# (see `with_no_struct()` and `local_no_struct()`)

#' @export
`[.tibble_struct` <- function(x, i, j, ..., extract) {
  if (!globals$activate_struct) return(NextMethod())
  call <- sys.call()
  if ("extract" %in% names(call)) {
    extract <- eval(substitute(extract), x, parent.frame())
    if (is.logical(extract)) extract <- which(extract)
    if (length(extract) != 1) rlang::abort("`extract` should match a single row")
    row <- un_tibble_struct(x)[extract,]
    struct1 <- lapply(row, function(col) if (is.list(col)) col[[1]] else scalar(col))
    struct2 <- as_list_struct(struct1)
    return(struct2)
  }
  NextMethod()
}

#' @export
`$.list_struct` <- function(x, nm) {
  if (!globals$activate_struct) return(NextMethod())
  if (!nm %in% names(x)) {
    msg <- "Invalid index"
    info <- sprintf("element `%s` not found", nm)
    rlang::abort(c(msg, x = info))
  }
  NextMethod()
}

#' @export
`$.tibble_struct` <- function(x, nm) {
  if (!globals$activate_struct) return(NextMethod())
  if (!nm %in% names(x)) {
    msg <- "Invalid index"
    info <- sprintf("Element `%s` not found", nm)
    rlang::abort(c(msg, x = info))
  }
  NextMethod()
}

#' @export
`[[.list_struct` <- function(x, i, ...) {
  if (!globals$activate_struct) return(NextMethod())
  if (!length(i)) {
    msg <- "Invalid index"
    info <- "Index should have length > 1"
    rlang::abort(c(msg, x = info))
  }
  tail <- i[-1]
  i <- i[[1]]
  if (is.character(i) && !i %in% names(x)) {
    msg <- "Invalid index"
    info <- sprintf("element `%s` not found", i)
    rlang::abort(c(msg, x = info))
  }
  out <- NextMethod()
  if (length(tail)) {
    out[[tail]]
  }
  out
}

#' @export
`[[.tibble_struct` <- function(x, i, ...) {
  if (!globals$activate_struct) return(NextMethod())
  if (!length(i)) {
    msg <- "Invalid index"
    info <- "Index should have length > 1"
    rlang::abort(c(msg, x = info))
  }
  tail <- i[-1]
  i <- i[[1]]
  if (is.character(i) && !i %in% names(x)) {
    msg <- "Invalid index"
    info <- sprintf("element `%s` not found", i)
    rlang::abort(c(msg, x = info))
  }
  out <- NextMethod()
  if (length(tail)) {
    out[[tail]]
  }
  out
}
