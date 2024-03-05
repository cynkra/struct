# list_struct ------------------------------------------------------------------

#' struct classes
#'
#' Functions to convert to and from struct classes or to test objects.
#' @export
#' @param x object
#' @param ... elements of the object to build
list_struct <- function(...) as_list_struct(list(...))

#' @export
#' @rdname list_struct
as_list_struct <- function(x) structure(x, class = union("list_struct", class(x)))

#' @export
#' @rdname list_struct
un_list_struct <-  function(x) {
  # scalar might add the implicit class so un_scalar needs to remove it as well
  if (identical(class(x), c("list_struct", "list"))) return(unclass(x))
  structure(x, class = setdiff(oldClass(x), "list_struct"))
}

#' @export
#' @rdname list_struct
is_list_struct <- function(x) inherits(x, "list_struct")

# tibble_struct ----------------------------------------------------------------

#' @export
#' @rdname list_struct
tibble_struct <- function(...) as_tibble_struct(tibble::tibble(...))

#' @export
#' @rdname list_struct
as_tibble_struct <- function(x) {
  x <- tibble::as_tibble(x)
  structure(x, class = union("tibble_struct", class(x)))
}

#' @export
#' @rdname list_struct
un_tibble_struct <- function(x) structure(x, class = setdiff(oldClass(x), "tibble_struct"))

#' @export
#' @rdname list_struct
is_tibble_struct <- function(x) inherits(x, "tibble_struct")

# scalar -----------------------------------------------------------------------

#' @export
#' @rdname list_struct
scalar <- function(x) structure(x, class = union("scalar", class(x)))

#' @export
#' @rdname list_struct
un_scalar <- function(x) {
  # scalar might add the implicit class so un_scalar needs to remove it as well
  if (identical(class(x), c("scalar", class(unclass(x))))) return(unclass(x))
  structure(x, class = setdiff(oldClass(x), "scalar"))
}

#' @export
#' @rdname list_struct
is_scalar <- function(x) inherits(x, "scalar")
