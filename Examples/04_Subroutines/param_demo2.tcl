#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================

# Wertparameter -- Funktionsdefinition
#
proc prtable {start end step functions} {

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

# Wertparameter -- Funktionsaufruf
# ---------------------------------------------------------------
prtable 0 180 30 {sin cos tan}
puts ""
# ---------------------------------------------------------------
prtable 0 30 3 {sin cos tan}
puts ""
# ---------------------------------------------------------------

