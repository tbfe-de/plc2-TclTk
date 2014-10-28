#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================

# Listenparameter auch fuer Bereich -- Funktionsdefinition
#
proc prtable {range functions} {
	set start [lindex $range 0]
	set end [lindex $range 1]
	set step [lindex $range 2]

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

# Listenparameter auch fuer Bereich -- Funktionsaufruf
# ---------------------------------------------------------------
prtable {0 180 30} {sin cos tan}
puts ""
# ---------------------------------------------------------------
prtable {0 30 3} {sin cos tan}
puts ""
# ---------------------------------------------------------------

