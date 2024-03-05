x <- list_struct(
  a = 1,
  b = scalar(2),
  c = list_struct(
    d = scalar(3),
    e = 4,
    f = list_struct(g = 5, h = 6)
  )
)
x <- deep_struct(x)

x$c <- list(
  d = 13,
  e = 14,
  f = list(g = 15, h = 16)
)
x$c$f$g

x$c <- list(
  d = "a",
  e = 14,
  f = list(g = 15, h = 16)
)

without_struct(
  x$c <- list(
    d = "a",
    e = 14,
    f = list(g = 15, h = 16)
  )
)

x_attr <- struct_to_attr(x)
attr_to_struct(x_attr)

y <- list(a = 11, b = scalar(12), c = list(d = 13, e = scalar(14)))
y <- deep_struct(y)

x$b <- c(1,2)
x$c$e <- c(1,2)
x$c <- list(d = 13, e = scalar(14))

bound <- bind_structs(x, y)
bound
bound[2,]
bound[2]
bound[extract = 2]

x$b <- c(1,2)
bind_structs(x, x)[extract = 1]

as_tibble_struct(cars)[extract = 3]

foo <- function() {
  x <- list_struct(
    a = 1,
    b = scalar(2),
    c = list_struct(
      d = scalar(3),
      e = 4,
      f = list(g = 5, h = 6)
    )
  )
  local_no_struct()

  x$c <- list(
    d = 13,
    e = 14,
    f = list(g = 15, h = 16)
  )
  x$c <- list(
    d = "a",
    e = 14,
    f = list(g = 15, h = 16)
  )
  x
}

class(foo()$c)
x

