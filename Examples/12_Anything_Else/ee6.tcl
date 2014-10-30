#!/usr/local/bin/tclsh

# 6. Beispiel -- wenn man nun noch die beiden
# for-Schleifen als Prozedur ablegt, kann man
# leicht unterschiedliche Ausgaben erzeugen:

proc einmaleins {} {
	global Z	;# Anzahl der Zeilen
	global S	;# Anzahl der Spalten
	for {set i 1} {$i <= $Z} {incr i} {
		for {set j 1} {$j <= $S} {incr j} {
			puts -nonewline [format %4d [expr $i * $j]]
		}
		puts ""
	}
}

set Z  8; set S 12; einmaleins
set Z 10; set S 10; einmaleins


