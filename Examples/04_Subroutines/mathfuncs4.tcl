#!/usr/local/bin/tclsh

# Fourth Example:
# For a more convenient client interface the range can now
# be specified with one to three numbers
# - if only one value is given it is used as upper limit
#   with a lower limit of 0
# - if two values are given they are taken as lower and
#   upper limit
# - if three values are given the third is the step width,
#   otherwise the step width is chosen so that there are
#   ten intervals between lower and upper limit

proc printf {fmtspec args} {
    puts -nonewline [eval format {$fmtspec} $args]
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
    }
    if {$step == "-"} {
        set step [expr (double($upper) - double($lower)) / 10]
    }
    # --------------------------- Ueberschriftzeile
    printf "%7s |" "arg"
    foreach f $funcs {
        printf "%8s  " ${f}
    }
    printf "\n"
    # ----------------------------- Funktionstabelle
    for {set v $lower} {$v <= $upper} {set v [expr $v + $step]} {
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
mathfuncs {-1 1} {abs}
mathfuncs {100} {sqrt}
