#!/usr/local/bin/tclsh

# 7. Beispiel -- in umfangreicheren Programmen
# sind allzuviele globale Variable allerdings
# eher stoerend.  Deshalb sollte man fuer die
# Grenzen der Schleifen besser Prozedurparameter
# verwenden:

proc einmaleins {Z S} {
	for {set i 1} {$i <= $Z} {incr i} {
		for {set j 1} {$j <= $S} {incr j} {
			puts -nonewline [format %4d [expr $i * $j]]
		}
		puts ""
	}
}

einmaleins  8 12
einmaleins 10 10


