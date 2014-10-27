#!/usr/bin/tclsh

if { $argc > 0 } {
	set x [lindex $argv 0]
} else {
	set x 10
}
while { $x > 0 } {
	puts -nonewline ".."; flush stdout
	after 1000 ;# delay for one second
	puts -nonewline [incr x -1]
}
puts ""
