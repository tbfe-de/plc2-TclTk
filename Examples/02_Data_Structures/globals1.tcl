#!/usr/bin/tclsh
# ====================================================
# Rudimentary Demo Program Implementing a 24h Clock
# ====================================================
# This is only the first step which does not make that
# much sense in practice. As soon as subroutines are
# added in the 2nd step it gets more realistic ...

# -------------- global variable outside of namespaces
#
set time [expr 20*60 - 3]
set 20_00__is__19_60 false

# ------------ the code below is only for demo purposes

if {$argc > 0 && [lindex $argv 0] == "-s"} {
    set 20_00__is__19_60 true
    set argv [lreplace $argv 0 0]
}

if {[llength $argv] == 0} {
    set delay 1000
} elseif {[catch { expr 0+[lindex $argv 0] } delay]} {
    puts stderr "Usage: $argv0 \[-s] <millisec-delay>"
    exit 1
}

while {1} {
    set mm [expr $time % 60]
    set hh [expr $time / 60 % 24]
    if {$20_00__is__19_60
     && $hh == 20 && $mm == 0} {
        set hh 19
        set mm 60
    }
    puts [format "%02d:%02d" $hh $mm]
    after $delay  ;# delay for some milliseconds
    if {[incr time] == 24*60} {
        set time 0
    }
}
