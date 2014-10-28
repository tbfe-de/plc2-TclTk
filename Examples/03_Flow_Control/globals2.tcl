#!/usr/bin/tclsh
# ====================================================
# Rudimentary Demo Program Implementin a 24h Clock
# ====================================================
# In the following global variables and subroutines
# are used. A potential problem here are accidental
# name clashes, i.e. in a large program the global
# names may be used elsewhere for different purposes.

# ------------- global variables outside any namespace
#
set time [expr 20*60 - 3]
set 20_00__is__19_60 false

# ----------- global subroutines outside any namespace
#
proc time_to_string {} {
    global time
    global 20_00__is__19_60
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
    global time
    if {[incr time] == 24*60} {
        set time 0
    }
}

# ----------- the code below is only for demo purposes

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
    puts [time_to_string]
    after $delay  ;# delay for some milliseconds
    time_advance
}
