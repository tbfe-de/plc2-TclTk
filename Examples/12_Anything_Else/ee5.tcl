#!/usr/local/bin/tclsh

# 5. Beispiel -- um mehr Flexibilitaet zu schaffen,
# koennte man auf die Idee kommen, auch Ober- und
# Untergrenze als Variablen abzulegen, damit sie
# leicht anpassbar sind:

set Z 8
set S 12

for {set i 1} {$i <= $Z} {incr i} {
	for {set j 1} {$j <= $S} {incr j} {
		puts -nonewline [format %4d [expr $i * $j]]
	}
	puts ""
}
