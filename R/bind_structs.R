bind_structs <- function(...) {
  elts <- rlang::list2(...)
  elts <- lapply(elts, as_n_struct)
  do.call(rbind, elts)
}
