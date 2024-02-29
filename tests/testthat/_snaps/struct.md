# snapshot tests

    Code
      x2$a <- 11:12
      x2$b <- list(tibble(c = 13:14, d = 15:16))
      x2$c <- tibble(e = 17:18, f = 19:20)
    Output
      Called from: struct(value)
      debug at /Users/Antoine/git/struct/R/struct.R#11: return(as_n_struct(x))
    Code
      x2$c$e <- 21:22
    Output
      Called from: struct(value)
      debug at /Users/Antoine/git/struct/R/struct.R#11: return(as_n_struct(x))
    Code
      x2
    Output
      # A tibble: 2 x 3
            a                  b   c$e    $f
      * <int> <list<tibble[,2]>> <int> <int>
      1    11            [2 x 2]    21    19
      2    12            [2 x 2]    22    20
    Code
      l2$a <- 11:12
      l2$b <- tibble(c = 13:14, d = 15:16)
    Output
      Called from: struct(value)
      debug at /Users/Antoine/git/struct/R/struct.R#11: return(as_n_struct(x))
    Code
      l2
    Output
      # struct object: 2 element(s)
                  a                    b
      * <list<int>> <list<n_struct[,2]>>
      1         [2]              [2 x 2]

---

    Code
      x2$a <- c("a", "b")
    Condition
      Error in `set2_df()`:
      ! Can't convert `value` <character> to <integer>.
    Code
      l2$a <- c("a", "b")
    Condition
      Error in `set2()`:
      ! Can't convert `value` <character> to <integer>.

---

    Code
      x2$b <- list("a", "b")
    Condition
      Error in `set2_df()`:
      ! Can't convert `..1` <character> to <tbl_df>.
    Code
      l2$b <- list("a", "b")
    Condition
      Error in `set2()`:
      ! Can't convert `value` <list_of<character>> to <n_struct>.

---

    Code
      x2$b <- 1
    Condition
      Error in `set2_df()`:
      ! Can't convert `value` <double> to <list_of<
        tbl_df<
          c: integer
          d: integer
        >
      >>.
    Code
      l2$b <- 1
    Condition
      Error in `set2()`:
      ! Can't convert `value` <double> to <n_struct>.

---

    Code
      x2[["z"]]
    Condition
      Error in `subset2_df()`:
      ! invalid index
    Code
      l2[["z"]]
    Condition
      Error in `subset2()`:
      ! invalid index

