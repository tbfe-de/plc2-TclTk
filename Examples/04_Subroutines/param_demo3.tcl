#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================

# Wertparameter mit Defaults -- Funktionsdefinition
#
proc prtable {start end {step 30} {functions {sin cos tan}}} {

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

# Wertparameter mit Defaults -- Funktionsaufruf
# ---------------------------------------------------------------
prtable 0 180
puts ""
# ---------------------------------------------------------------
prtable 0 30 3 {sin cos tan}
puts ""
# ---------------------------------------------------------------

