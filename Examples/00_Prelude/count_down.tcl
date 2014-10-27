#!/usr/bin/tclsh
# ------------------------------------------
# count-down to zero
# ------------------------------------------

set x 10
while { $x > 0 } {
	puts -nonewline ".."; flush stdout
	after 1000 ;# delay for one second
	puts -nonewline [incr x -1]
}
puts ""
