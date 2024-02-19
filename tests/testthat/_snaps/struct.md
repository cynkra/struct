# snapshot tests

    Code
      x2$a <- 11:12
      x2$b <- list(tibble(c = 13:14, d = 15:16))
      x2$c <- tibble(e = 17:18, f = 19:20)

---

    Code
      x2$a <- c("a", "b")
    Condition
      Error in `set2()`:
      ! Can't convert `value` <character> to <integer>.

---

    Code
      x2$b <- list("a", "b")
    Condition
      Error in `set2()`:
      ! Can't convert `value` <struct> to <struct>.

---

    Code
      x2$c <- 1
    Condition
      Error in `set2()`:
      ! Can't convert `value` <double> to <struct>.

---

    Code
      x2[["z"]]
    Condition
      Error in `subset2()`:
      ! invalid index

