#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================

# Gemeinsamer Listenparameter -- Funktionsdefinition
#
proc prtable {args} {
	set start [lindex $args 0]
	set end [lindex $args 1]
	set step [lindex $args 2]
	set functions [lreplace $args 0 2]

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

# Gemeinsamer Listenparameter -- Funktionsaufruf
# ---------------------------------------------------------------
prtable 0 180 30 sin cos tan
puts ""
# ---------------------------------------------------------------
prtable 0 30 3 sin cos tan
puts ""
# ---------------------------------------------------------------

