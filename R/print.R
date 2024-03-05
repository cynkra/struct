#' @export
print.list_struct <- function(x, ...) {
  # leverage the pillar stuff by converting to tibble, but keep the object
  # a list so we cannot use data frame ops on it
  x2 <- tibble::as_tibble(lapply(x, function(elt) structure(list(elt), class = c("list_struct_elt", "list"))))
  x2 <- as_list_struct(x2)
  writeLines(format(x2))
  invisible(x)
}

#' @export
tbl_sum.list_struct <- function(x, ...) {
  c("list_struct object" = sprintf("%s element(s)", length(x)))
}

#' @export
type_sum.list_struct_elt <- function(x, ...) {
  pillar::type_sum(un_list_struct(un_scalar(.subset2(x, 1))))
}

#' print tree structure of object
#'
#' Not quite right yet. We want to be able to check easily the structure of an
#' object. Doesn't dive deep into lists unless they are named. Ultimately should
#' dive into the list_of ptypes though, and look prettier.
#' @param x object
#' @export
print_tree <- function(x) {
  nm <- rlang::englue("{{ x }}")
  writeLines(sprintf("█─ %s <%s>", nm, pillar::type_sum(x)))
  print_tree_impl(x, 0)
}

print_tree_impl <- function(x, n_indent) {
  indent <- strrep(" ", n_indent)
  for (nm in names(x)) {
    if (is.list(x[[nm]])) { # || is.data.frame(x[[nm]])
      writeLines(sprintf("%s├─█─ %s <%s>", indent, nm, pillar::type_sum(x[[nm]])))
      print_tree_impl(x[[nm]], n_indent = n_indent + 2)
      next
    }
    writeLines(sprintf("%s├─── %s <%s>", indent, nm, pillar::type_sum(x[[nm]])))
  }
}
