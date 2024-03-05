
#' @export
deep_struct <- function(x, detect_scalar = TRUE, detect_list_of = TRUE) {
  # atomics are returned unchanged unless they're detected as scalars
  if (!is.list(x)) {
    if (detect_scalar && is.atomic(x) && length(x) == 1) return(scalar(x))
    return(x)
  }

  # data frames are converted to tibble structs, we recurse into them
  # but leave atomic columns as they are
  if (is.data.frame(x)) {
    x[] <- lapply(x, function(x) {
      if (is.atomic(x)) return(x)
      deep_struct(x, detect_scalar, detect_list_of)
    })
    return(as_tibble_struct(as_tibble(x)))
  }

  # we recurse into lists, if they are unnamed and convertible to list_of
  # we do so if relevant, otherwise convert to list_struct
  x[] <- lapply(x, deep_struct, detect_scalar, detect_list_of)
  if (is.null(names(x)) || all(names(x) == "")) {
    if (!detect_list_of) return(x)
    rlang::try_fetch(vctrs::as_list_of(x), error = function(e) x)
  } else {
    as_list_struct(x)
  }
}

#' @export
deep_unstruct <- function(x, un_list_of = FALSE) {
  if (!is.list(x)) return(un_scalar(x))
  if (un_list_of && vctrs::is_list_of(x)) {
    x <- as.list(x)
  }
  x <- un_list_struct(un_tibble_struct(x))
  x[] <- lapply(x, deep_unstruct, un_list_of)
  x
}

#' bind objects into a tibble_struct
#' @export
bind_structs <- function(...) {
  structs <- rlang::list2(...)
  structs2 <- lapply(structs, function(struct) {
    struct <- lapply(unclass(struct), function(elt) {
      if (is_scalar(elt)) un_scalar(elt) else list(elt)
    })
    tibble::as_tibble(struct)
  })
  structs3 <- do.call(rbind, structs2)
  as_tibble_struct(structs3)
}

find_indexes <- function(x, p = list(list_struct = is_list_struct, tibble_struct = is_tibble_struct, scalar = is_scalar)) {
  if (!is.list(p)) p <- list(p)
  ind <- rep_len(list(), length(p))
  names(ind) <- names(p)
  find_indexes_impl <- function(x, i) {
    for (j in seq_along(p)) {
      if (p[[j]](x)) ind[[j]] <<- c(ind[[j]], list(i))
    }
    if (!is.list(x)) return(invisible(NULL))
    Map(find_indexes_impl, x, lapply(seq_along(x), function(x) c(i, x)))
  }
  find_indexes_impl(x, integer())
  ind
}
