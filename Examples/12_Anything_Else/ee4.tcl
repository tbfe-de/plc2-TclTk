#!/usr/local/bin/tclsh

# 4. Beispiel -- eine Zwischenvariable fuer das
# Ergebnis (wie im letzten Beispiel "erg" macht
# die Sache wahrscheinlich lesbarer, prinzipiell
# ist sie jedoch nicht erforderlich, da die eckigen
# Klammern auch geschachtelt werden duerfen:

for {set i 1} {$i <= 10} {incr i} {
	for {set j 1} {$j <= 10} {incr j} {
		puts -nonewline [format %4d [expr $i * $j]]
	}
	puts ""
}
