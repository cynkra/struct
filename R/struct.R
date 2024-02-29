# turn tibble into struct tibble

#' @export
struct <- function(x) {
  # no op on non lists and struct objects
  if (is_struct(x) || !is.list(x)) return(x)

  # to struct a data.frame, we struct all its columns and give it a class
  if (is.data.frame(x)) {
    browser()
    return(as_n_struct(x))
  }

  if (rlang::is_named(x)) {
    return(struct_named_list(x))
  }

  struct_unnamed_list(x)
}

is_struct <- function(x) {
  inherits(x, "struct")
}

as_n_struct <- function(x) {
  if (inherits(x, "n_struct")) return(x)
  x[] <- lapply(x, struct)
  structure(x, class = union("n_struct", class(x)))
}

struct_unnamed_list <- function(x) {
  rlang::try_fetch(
    as_list_of(x),
    vctrs_error_ptype2 = function(cnd) {
      msg <- "Can't convert object to a struct"
      info <- "List elements must be either fully named to be converted to struct or of consistent type to be converted to list_of"
      rlang::abort(c(msg, i = info), parent = cnd)
    }
  )
}

struct_named_list <- function(x) {
  # lists are turned into one row tibbles, we nest every element, not just
  # those of length > 1
  attrs <- attributes(x)
  x[] <- lapply(x, function(elt) {
    nested_elt <- if (is.null(elt)) list(NULL) else list_of(struct(elt))
    structure(nested_elt, class = union("struct_elt", class(nested_elt)))
  })
  structure(x, class = union("struct", class(x)))
}

unstruct <- function(x) {
  class(x) <- setdiff(class(x), "struct")
  x
}
