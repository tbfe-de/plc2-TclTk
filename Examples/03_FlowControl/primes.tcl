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

set primes [list]

for {set i 1} {$i <= $count} {incr i} {
    switch -exact [llength $primes] {
        0 {
            lappend primes 2
        }
        1 {
            lappend primes 3
        }
        default {
            set candidate [expr [lindex $primes end]]
            while {1} {
                incr candidate 2
                set isprime 1 ;# assume it's prime ...
                foreach p $primes {
                    if {[expr ($candidate % $p) == 0]} {
                        # ... NO, it is NOT prime
                        set isprime 0
                        break
                    }
                }
                if {$isprime} {
    	            lappend primes $candidate
                    break
                }
            }
        }
    }
    puts [lindex $primes end]
}
