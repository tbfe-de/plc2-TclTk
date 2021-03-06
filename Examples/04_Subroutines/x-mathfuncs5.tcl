#!/usr/bin/tclsh

# Fifth Example:
# Incrementing the value is now done by a helper function
# 'fincr' that is like the standard function 'incr' but can
# also handle floating point arguments.
# Like 'incr' this function should accept either one or two
# arguments, where
# - the first is the name of a variable that must exists in
#   the caller's scope
# - the second is an optional increment (which may also be
#   negative) and shall have the default '1' (if it is not
#   specified)

proc printf {fmtspec args} {
    puts -nonewline [eval format {$fmtspec} $args]
}

proc fincr {var {inc 1}} {
    # TO-DO: implement this function by first calling 'incr'
    # (assuming this is more performant for integral values),
    ...
    # catch possible errors (which 'incr' throws when its
    # arguments are not integral) and do a floating point
    # calculation with 'expr' otherweise
    #
    ...
}

proc mathfuncs {range funcs} {
    # Bereichs-Argument analysieren
    set step -
    switch -exact [llength $range] {
        1 { set lower 0
            set upper [lindex $range 0] }
        2 { set lower [lindex $range 0] 
            set upper [lindex $range 1] }
        3 { set lower [lindex $range 0] 
            set step  [lindex $range 1]
            set upper [lindex $range 2] }
        # TO-DO: add some error handling in place of dots
        ...
    }
    switch -exact [llength $funcs] {
        0    { error "no elements in second arg" }
    }
    if {$step == "-"} {
        set step [expr (double($upper) - double($lower)) / 10]
    }
    # TO-DO: add a test in place of dots to provide some error
    # handling if 'lower' cannot reach 'upper' when repeatedly
    # incremented by 'step'
    if { ... } {
        error "step does not move lower towards upper"
    }
    # --------------------------- Ueberschriftzeile
    printf "%7s |" "arg"
    foreach f $funcs {
        printf "%8s  " ${f}
    }
    printf "\n"
    # ----------------------------- Funktionstabelle
    for {set v $lower} {($step>0) ? $v <= $upper 
                                  : $v >= $upper} {fincr v $step} {
        # -------------------- Funktionsargument
        printf "%7.2f |" $v
        foreach f $funcs {
            # ------- -------- Funktionswert
            printf "%8.3f  " [expr ${f}($v)]
        }
        printf "\n"
    }
}

mathfuncs {-1.6 .4 1.6} {sin cos}
puts ""
mathfuncs {-1 1} {abs}
puts ""
mathfuncs {100} {sqrt}
