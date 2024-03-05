# vctrs::vec_cast has a couple flaws:
# * it doesn't see types in regular lists that are not list_ofs (and not all lists can be list_ofs)
# * it can't cast an arbitrary class to another (for instance a list to a list_struct, or an atomic to a scalar)
# Thus we need our own casting mecanism on top of vctrs

struct_cast <- function(old, new, ...) {
  UseMethod("struct_cast")
}

#' @export
struct_cast.default <- function(old, new, ...) {
  # find uses of struct classes
  ind1 <- find_indexes(old)
  ind2 <- find_indexes(new)

  # strip them off
  new <- deep_unstruct(new)
  old <- deep_unstruct(old)

  # cas with vctrs
  new <- vctrs::vec_cast(new, old)

  # reapply the classes
  for (ind in union(ind1$list_struct, ind2$list_struct)) {
    if (!length(ind)) {
      new <- as_list_struct(new)
      next
    }
    new[[ind]] <- as_list_struct(new[[ind]])
  }
  for (ind in union(ind2$tibble_struct, ind2$tibble_struct)) {
    if (!length(ind)) {
      new <- as_list_struct(new)
      next
    }
    new[[ind]] <- as_list_struct(new[[ind]])
  }
  new
}

#' @export
struct_cast.scalar <- function(old, new, ...) {
  if (length(new) != 1) {
    rlang::abort("not a scalar")
  }
  new <- un_scalar(new)
  old <- un_scalar(old)
  scalar(NextMethod())
}

#' @export
struct_cast.list_struct <- function(old, new, ...) {
  # We cannot validate a list containing different types with list_of
  #   so we have to validate its component individually
  # Names need to match unambiguously, we allow shuffled name order when all
  #   elements are named

  if (length(old) != length(new)) {
    rlang::abort("length mismatch")
  }
  if (!setequal(names(old), names(new))) {
    rlang::abort("incompatible names")
  }
  if (!identical(names(old), names(new))) {
    if ("" %in% names(old)) {
      rlang::abort("ambiguous name order")
    }
    new <- new[names(old)]
  }
  as_list_struct(Map(struct_cast.default, old, new))
}
