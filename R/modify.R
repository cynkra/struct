# Modifying in struct is casting then appling regular modification (NextMethod)
# The global variable globals$activate_struct allows standard free modification
# (see `with_no_struct()` and `local_no_struct()`)

#' @export
`$<-.list_struct` <- function(x, nm, value) {
  if (!globals$activate_struct) return(NextMethod())
  value <- struct_cast(x[[nm]], value)
  NextMethod()
}

#' @export
`[[<-.liststruct` <- function(x, i, ..., value) {
  if (!globals$activate_struct) return(NextMethod())
  value <- struct_cast(x[[i]], value)
  NextMethod()
}

#' @export
`$<-.tibble_struct` <- function(x, nm, value) {
  if (!globals$activate_struct) return(NextMethod())
  value <- struct_cast(x[[nm]], value)
  NextMethod()
}

#' @export
`[[<-.tibble_struct` <- function(x, i, ..., value) {
  if (!globals$activate_struct) return(NextMethod())
  value <- struct_cast(x[[i]], value)
  NextMethod()
}
