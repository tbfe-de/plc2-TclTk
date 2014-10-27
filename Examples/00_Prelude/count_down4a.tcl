#!/usr/bin/tclsh

set text { Ready Steady Go! }
for {set i 0} {$i < [llength $text]} {incr i} {
	puts [lindex $text $i]
	after 3000
}
