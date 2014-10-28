#!/usr/bin/tclsh

switch -exact $argc {
    0 {
        set count 10
    }
    1 {
        if {[catch {expr [lindex $argv 0]} count]} {
            puts stderr "argument is not an integer"
            exit 1
        }
        if {$count < 1} {
            puts stderr "argument must be 1 or greater"
            exit 2
        }
    }
    default {
            puts stderr "at most one argument is allowed"
            exit 3
    }
}

for {set i 1} {$i <= $count} {incr i} {
    if {$i == 1} {
        puts [set last2 1]
    } elseif {$i == 2} {
        puts [set last 1]
    } else {
        puts [set fib [expr $last2+$last]]
        set last2 $last
        set last $fib
    }
}
