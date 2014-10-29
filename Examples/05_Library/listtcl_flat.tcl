#!/usr/bin/tclsh

# ================================================================
# List all Tcl-Files in current directory
# ================================================================

foreach fname [glob *.tcl] {
    puts [string repeat "/" [expr [string length $fname] + 8]]
    puts "| File: $fname"
    puts [string repeat "\\" [expr [string length $fname] + 8]]
    if {[catch {open $fname} chan]} {
        puts "ERROR: $chan
        continue
    }
    set nr 0
    while {[gets $chan line] >= 0} {
        puts [format {%6d: %s} [incr nr] $line]
    }
    close $chan
    puts ""
}
