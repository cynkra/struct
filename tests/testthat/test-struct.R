test_that("snapshot tests", {
  x1 <- tibble(
    a = 1:2,
    b = list(tibble(c = 3:4, d = 5:6)),
    c = tibble(e = 7:8, f = 9:10)
  )
  l1 <- list(
    a = 1:2,
    b = tibble(c = 3:4, d = 5:6)
  )

  x2 <- struct(x1)
  l2 <- struct(l1)

  expect_snapshot({
    x2$a <- 11:12
    x2$b <- list(tibble(c = 13:14, d = 15:16))
    x2$c <- tibble(e = 17:18, f = 19:20)
    x2$c$e <- 21:22
    x2
    l2$a <- 11:12
    l2$b <- tibble(c = 13:14, d = 15:16)
    l2
  })

  expect_snapshot(error = TRUE, {
    x2$a <- c("a", "b")
    l2$a <- c("a", "b")
  })

  expect_snapshot(error = TRUE, {
    x2$b <- list("a", "b")
    l2$b <- list("a", "b")
  })

  expect_snapshot(error = TRUE, {
    x2$b <- 1
    l2$b <- 1
  })

  expect_snapshot(error = TRUE, {
    x2[["z"]]
    l2[["z"]]
  })
})
