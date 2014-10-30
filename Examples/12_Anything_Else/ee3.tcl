#!/usr/local/bin/tclsh

# 3. Beispiel -- ... oder man verwendet die
# format-Anweisung von tcl, die ganz aehnlich
# wie printf in C funktioniert, das Ergebnis
# aber als Rueckkehrwert liefert, d.h. man
# muss nach wie vor puts verwenden, um es
# tatsaechlich auszugeben:

for {set i 1} {$i <= 10} {incr i} {
	for {set j 1} {$j <= 10} {incr j} {
		set erg [expr $i * $j]
		puts -nonewline [format %4d $erg]
	}
	puts ""
}
