#!/usr/local/bin/tclsh

# 1. Beispiel -- um "das kleine Einmaleins"
# auszugeben, kann man zwei geschachtelte
# for-Schleifen verwenden:

for {set i 1} {$i <= 10} {incr i} {
	for {set j 1} {$j <= 10} {incr j} {
		puts -nonewline " [expr $i * $j]"
		# ohne Newline + ^-- mit Blank getrennt
	}
	puts ""	;# nur Newline
}
