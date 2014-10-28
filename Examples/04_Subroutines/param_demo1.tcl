#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================


# Globale Variable -- Funktionsdefinition
#
proc prtable {} {
	global start end step	;# Schleifensteuerung
	global functions	;# Liste der Funktion

	for {set grad $start} {$grad <= $end} {incr grad $step} {
		foreach f $functions {
			# Umrechnung ins Bogenmass
			set rad [expr $grad*4*acos(0)/360]
			set val [expr ${f}($rad)]
			puts -nonewline [format "%10.4f" $val]
		}
		puts ""
	}
}

# Globale Variable -- Funktionsaufruf
# ---------------------------------------------------------------
set start 0
set end 180
set step 30
set functions {sin cos tan}
prtable
puts ""
# ---------------------------------------------------------------
set step 3
set end 30
prtable
# ---------------------------------------------------------------

