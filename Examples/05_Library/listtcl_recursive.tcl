#!/usr/bin/tclsh

# ================================================================
# List all Tcl-Files in current directory
# ================================================================

proc list_tcl {dir} {
    foreach subdir [glob -nocomplain -directory $dir -type d *] {
        list_tcl $subdir
    }
    foreach fname [lsort [glob -nocomplain -directory $dir *.tcl]] {
        puts [string repeat "/" [expr [string length $fname] + 8]]
        puts "| File: $fname"
        puts [string repeat "\\" [expr [string length $fname] + 8]]
        if {[catch {open $fname} chan]} {
            puts "ERROR: $chan"
            continue
        }
        set nr 0
        while {[gets $chan line] >= 0} {
            puts [format {%6d: %s} [incr nr] $line]
        }
        close $chan
        puts ""
    }
}

if {$argc == 0}\
then {list_tcl .}\
else {foreach d $argv {list_tcl $d}}
