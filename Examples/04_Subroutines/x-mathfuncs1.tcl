#!/usr/local/bin/tclsh

# First Example:
# A table of trigonometric functions will be generated.
# Both dimensions are made easily adaptable. i.e.
# - number of lines (= lower limit, step, upper limit)
# - number of columns (= list of functions)
#
# Here global variables are used to transfer that
# information to the sub-routine mathfuncs.

proc printf {fmtspec args} {
    puts -nonewline [eval format {$fmtspec} $args]
}

set lower 0.0
set step  0.2
set upper 3.2
set funcs {sin cos tan abs}

proc mathfuncs {} {
    # TO-DO: make global variables accessible in place of dots
    #
    ...
    # --------------------------- Ueberschriftzeile
    printf "%7s :" "arg"
    foreach f $funcs {
        printf "%8s  " ${f}
    }
    printf "\n"
    # ----------------------------- Funktionstabelle
    for {set v $lower} {$v <= $upper} {set v [expr $v + $step]} {
        # -------------------- Funktionsargument
        printf "%7.2f :" $v
        foreach f $funcs {
            # ------- -------- Funktionswert
            printf "%8.3f  " [expr ${f}($v)]
        }
        printf "\n"
    }
}

mathfuncs
