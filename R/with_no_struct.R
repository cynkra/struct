globals <- new.env()
globals$activate_struct <- TRUE

#' @export
with_no_struct <- function(expr) {
  globals$activate_struct <- FALSE
  on.exit(globals$activate_struct <- TRUE)
  expr
}

#' @export
local_no_struct <- function() {
  globals$activate_struct <- FALSE
  do.call(on.exit, alist(globals$activate_struct <- TRUE, TRUE), envir = parent.frame())
  invisible(NULL)
}

