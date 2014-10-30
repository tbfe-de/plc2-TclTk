#!/usr/local/bin/tclsh

# 10. Beispiel -- ist der NAME des letzten
# Arguments "args", nimmt tcl die Definition
# einer Prozedur mit variabler Zahl von
# Argumenten an.  Man braucht so etwas nicht
# sehr haeufig, kann damit aber beispielsweise
# ein "printf" ganz wie in C definieren:

proc printf {fmtspec args} {
	puts -nonewline [eval format {$fmtspec} $args]
}

proc einmaleins {{Z 10} {S -}} {
	if {$S == "-"} {set S $Z}
	for {set i 1} {$i <= $Z} {incr i} {
		for {set j 1} {$j <= $S} {incr j} {
			printf "%4d" [expr $i * $j]
		}
		printf "\n"
	}
}

einmaleins 8
