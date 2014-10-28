#!/usr/bin/tclsh
# ====================================================
# Rudimentary Demo Program Implementing a 24h Clock
# ====================================================
# In the following instead of global variables and
# subroutines, everything that deals with the clock
# implementation is put inside the namespace 'mclock'.

namespace eval mclock {

    # ----------------------- variables in a namespace

    variable time [expr 20*60 - 3]
    variable 20_00__is__19_60 false

    # --------------------- subroutines in a namespace

    proc time_to_string {} {
        variable time
        variable 20_00__is__19_60
        set mm [expr $time % 60]
        set hh [expr $time / 60 % 24]
        if {$20_00__is__19_60
         && $hh == 20 && $mm == 0} {
            set hh 19
            set mm 60
        }
        return [format %02d:%02d $hh $mm]
    }

    proc time_advance {} {
        variable time
        if {[incr time] == 24*60} {
            set time 0
        }
    }

}

# ----------- the code below is only for demo purposes

if {$argc > 0 && [lindex $argv 0] == "-s"} {
    set mclock::20_00__is__19_60 true
    set argv [lreplace $argv 0 0]
}

if {[llength $argv] == 0} {
    set delay 1000
} elseif {[catch { expr 0+[lindex $argv 0] } delay]} {
    puts stderr "Usage: $argv0 \[-s] <millisec-delay>"
    exit 1
}

while {1} {
    # subroutines called must be qualified with
    # with the namespace name 'mclock::'
    puts [mclock::time_to_string]
    after $delay  ;# delay for some milliseconds
    mclock::time_advance
}
