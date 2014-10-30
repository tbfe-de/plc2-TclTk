#!/usr/bin/tclsh
# ====================================================
# Rudimentary Demo Program Implementing a 24h Clock
# ====================================================
# In this step the program starts to use Tk: the time
# is displayed as text of a label.

namespace eval mclock {

    # ----------------------- variables in a namespace

    variable time [expr 12*60]
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

if {[string equal [lindex $argv 0] "20:00=19:60"]} {
    set mclock::20_00__is__19_60 true
    # remove processed argument
    set argv [lreplace $argv 0 0]
}

if {[regexp {^([01][0-9]|[2][03]):([0-5][0-9])$} [lindex $argv 0] - hh mm]} {
    set mclock::time [expr 60*$hh + $mm]
    # remove processed argument
    set argv [lreplace $argv 0 0]
}

if {[llength $argv] == 0} {
    set delay [expr 60*1000]
} elseif {[catch { expr 0+[lindex $argv 0] } delay]} {
    puts stderr "Usage: $argv0 \[20:00=19:60] \[hh:mm] \[<millisec-delay>]"
    exit 1
} else {
    # remove processed argument
    set argv [lreplace $argv 0 0]
}

# define what must be done repeatedly 
#
proc runstep {} {
    # display the current time value
    .timedisplay configure -text [mclock::time_to_string]
    # for repetition the event-loop is used
    global delay
    after $delay {
        mclock::time_advance
        runstep
    }
}

# load Tk to get a GUI window
#
package require Tk

# create the label to display the time ...
#
pack [label .timedisplay -font {Sans 100} -bg black -fg yellow]

# ... and startup the contious display
#
runstep
