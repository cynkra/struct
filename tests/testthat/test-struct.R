test_that("snapshot tests", {
  x1 <- list(
    a = 1,
    b = list(tibble(c = 3:4, d = 5:6)),
    c = tibble(e = 7:8, f = 9:10),
    y = list(z = c("a", "b"))
  )
  x2 <- deep_struct(x1)

  expect_snapshot({
    x2$a <- 1
    x2$b <- list(tibble(c = 13:14, d = 15:16))
    x2$c <- tibble(e = 17:18, f = 19:20)
    x2$c$e <- 21:22
    x2
    x2$c
  })

  expect_snapshot(error = TRUE, {
    x2$a <- 1:2
  })

  expect_snapshot(error = TRUE, {
    x2$a <- "a"
  })

  expect_snapshot(error = TRUE, {
    x2$b <- list("a", "b")
  })

  expect_snapshot(error = TRUE, {
    x2$c <- 1
  })

  expect_snapshot(error = TRUE, {
    x2[["z"]]
  })
})

test_that("deep_struct", {
  x1 <- list(
    a = 1,
    b = list(tibble(c = 3:4, d = 5:6)),
    c = tibble(e = 7:8, f = 9:10),
    y = list(z = c("a", "b"))
  )

  x2 <- deep_struct(x1)
  x3 <- list_struct(
    a = scalar(1),
    b = vctrs::list_of(tibble_struct(c = 3:4, d = 5:6)),
    c = tibble_struct(e = 7:8, f = 9:10),
    y = list_struct(z = c("a", "b"))
  )
  x4 <- deep_unstruct(x2, un_list_of = TRUE)

  expect_identical(x2, x3)
  expect_identical(x4, x1)
})

test_that("no_struct", {
  x1 <- list(
    a = 1,
    b = list(tibble(c = 3:4, d = 5:6)),
    c = tibble(e = 7:8, f = 9:10)
  )

  x2 <- deep_struct(x1)

  expect_snapshot({
    with_no_struct({
      x2$a <- "a"
    })
    x2$a
    fun <- function(x) {
      local_no_struct()
      x$a <- list()
      x
    }
    x2 <- fun(x2)
    x2$a
  })
})


test_that("bind and extract", {
  x1 <- list(
    a = 1,
    b = list(tibble(c = 3:4, d = 5:6)),
    c = tibble(e = 7:8, f = 9:10)
  )
  x2 <- deep_struct(x1)
  df <- bind_structs(x2, x2)
  expect_identical(x2, df[extract=1])
  expect_identical(x2, df[extract= c(TRUE, FALSE)])

  expect_snapshot({
    df
    df[1,]
    df[1]
  })
})

test_that("print_tree", {
  x1 <- list(
    a = 1,
    b = list(tibble(c = 3:4, d = 5:6)),
    c = tibble(e = 7:8, f = 9:10),
    y = list(z = c("a", "b"))
  )
  x2 <- deep_struct(x1)
  print_tree(x2)
})
