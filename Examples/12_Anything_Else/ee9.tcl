#!/usr/local/bin/tclsh

# 9. Beispiel -- sich im Default fuer das
# zweite Argument auf das erste zu beziehen,
# erfordert einen kleilen Kunstgriff, denn
#	proc einmaleins {{Z 10} {S $Z}} {
#		....
#	}
# funktioniert leider nicht wie erwartet:

proc einmaleins {{Z 10} {S -}} {
	if {$S == "-"} {set S $Z}
	for {set i 1} {$i <= $Z} {incr i} {
		for {set j 1} {$j <= $S} {incr j} {
			puts -nonewline [format %4d [expr $i * $j]]
		}
		puts ""
	}
}

einmaleins 3 4
einmaleins 6
einmaleins


