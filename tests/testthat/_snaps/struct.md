# snapshot tests

    Code
      x2$a <- 1
      x2$b <- list(tibble(c = 13:14, d = 15:16))
      x2$c <- tibble(e = 17:18, f = 19:20)
      x2$c$e <- 21:22
      x2
    Output
      # list_struct object: 4 element(s)
        a            b                        c                y             
      * <dbl>        <list<tbbl_str[,2]>>     <tibble[,2]>     <named list>  
      1 <scalar [1]> <list<tbbl_str[,2]> [1]> <tibble [2 x 2]> <lst_strc [1]>
    Code
      x2$c
    Output
      # A tibble: 2 x 2
            e     f
        <int> <int>
      1    21    19
      2    22    20

---

    Code
      x2$a <- 1:2
    Condition
      Error in `struct_cast()`:
      ! not a scalar

---

    Code
      x2$a <- "a"
    Condition
      Error in `structure()`:
      ! Can't convert `new` <character> to <double>.

---

    Code
      x2$b <- list("a", "b")
    Condition
      Error in `struct_cast()`:
      ! Can't convert `..1` <character> to <tibble_struct>.

---

    Code
      x2$c <- 1
    Condition
      Error in `struct_cast()`:
      ! Can't convert `new` <double> to <tbl_df>.

---

    Code
      x2[["z"]]
    Condition
      Error in `x2[["z"]]`:
      ! Invalid index
      x element `z` not found

# no_struct

    Code
      with_no_struct({
        x2$a <- "a"
      })
      x2$a
    Output
      [1] "a"
    Code
      fun <- (function(x) {
        local_no_struct()
        x$a <- list()
        x
      })
      x2 <- fun(x2)
      x2$a
    Output
      list()

# bind and extract

    Code
      df
    Output
      # A tibble: 2 x 3
            a b                        c                 
      * <dbl> <list>                   <list>            
      1     1 <list<tbbl_str[,2]> [1]> <tbbl_str [2 x 2]>
      2     1 <list<tbbl_str[,2]> [1]> <tbbl_str [2 x 2]>
    Code
      df[1, ]
    Output
      # A tibble: 1 x 3
            a b                        c                 
        <dbl> <list>                   <list>            
      1     1 <list<tbbl_str[,2]> [1]> <tbbl_str [2 x 2]>
    Code
      df[1]
    Output
      # A tibble: 2 x 1
            a
        <dbl>
      1     1
      2     1

