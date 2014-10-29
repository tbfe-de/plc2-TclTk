#!/usr/bin/tclsh
# ====================================================
# Rudimentary Demo Program Implementing a 24h Clock
# ====================================================
# This only prepares the more realistic 2nd step that
# also implements subroutines for handling the data.

namespace eval mclock {

    # ---------------- global variables in a namespace

    variable time [expr 20*60 - 3]
    variable 20_00__is__19_60 false

    # (any access from outside the namespace needs to
    # prefix the namespace name 'mclock::')

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
    set mm [expr $mclock::time % 60]
    set hh [expr $mclock::time / 60 % 24]
    if {$mclock::20_00__is__19_60
     && $hh == 20 && $mm == 0} {
        set hh 19
        set mm 60
    }
    puts [format "%02d:%02d" $hh $mm]
    after $delay  ;# delay for some milliseconds
    incr mclock::time
}
