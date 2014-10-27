# Ackermann function in Tcl
proc ackermann {n m} {
    expr { $n == 0 ? $m+1
         : $m == 0 ? [ackermann [expr $n-1] 1]
         : [ackermann [expr $n-1]\
                      [ackermann $n [expr $m-1]]] 
    }
}
