#!/usr/local/bin/tclsh

# 2. Beispiel -- um eine schoenere Formatierung
# zu erreichen, kann man umstaendlich zu Fuss
# die richtige Zahl von Blanks einfuegen ...:

for {set i 1} {$i <= 10} {incr i} {
	for {set j 1} {$j <= 10} {incr j} {
		set erg [expr $i * $j]
		if {$erg < 100} { puts -nonewline " " }
		if {$erg <  10} { puts -nonewline " " }
		puts -nonewline " $erg"
	}
	puts ""
}
