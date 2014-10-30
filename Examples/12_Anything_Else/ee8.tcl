#!/usr/local/bin/tclsh

# 8. Beispiel -- fuer Prozedurparameter sind
# auch Defaultwerte erlaubt.  Die Syntax des
# zweiten proc-Arguments sollte man dabei am
# Anfang vielleicht eher als "Kochrezept" sehen,
# aus Sicht von Tcl handelt es sich naemlich
# um eine "Liste von Listen" ...:

proc einmaleins {{Z 10} {S 10}} {
	for {set i 1} {$i <= $Z} {incr i} {
		for {set j 1} {$j <= $S} {incr j} {
			puts -nonewline [format %4d [expr $i * $j]]
		}
		puts ""
	}
}

einmaleins  8 12
einmaleins


