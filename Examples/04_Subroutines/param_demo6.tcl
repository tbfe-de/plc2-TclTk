#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================

# Array-Parameter fuer Bereich -- Funktionsdefinition
#
proc prtable {range functions} {
	upvar $range r

	for {set grad $r(start)} {$grad <= $r(end)} {incr grad $r(step)} {
		foreach f $functions {
			# Umrechnung ins Bogenmass
			set rad [expr $grad*4*acos(0)/360]
			set val [expr ${f}($rad)]
			puts -nonewline [format "%10.4f" $val]
		}
		puts ""
	}
}

# Array-Parameter fuer Bereich -- Funktionsaufruf
# ---------------------------------------------------------------
set rg(start) 0
set rg(end) 180
set rg(step) 30
prtable rg {sin cos tan}
puts ""
# ---------------------------------------------------------------
set rg(end) 30
set rg(step) 3
prtable rg {sin cos tan}
puts ""
# ---------------------------------------------------------------

