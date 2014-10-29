#!/usr/bin/tclsh
# ==============================================================
# Demo-Programm fuer Uebergabe von Funktionsparametern
# ==============================================================

# Optionsparameter fuer Bereich -- Funktionsdefinition
#
proc prtable {args} {
	set r(-start) 0
	set r(-end) 360
	set r(-step) 30
	set SYNTAX "wrong # args: should be\
		?-start val?\
		?-end val?\
		?-step val?\
		func ...
	"
	foreach {opt val} $args {
                switch -glob $opt {
                    -* {}
                    * break
                }
		if ![info exists r($opt)] {
			error "$SYNTAX"
		}
		set r($opt) $val
		set args [lreplace $args 0 1]
	}
	if ![llength $args] {
		error "$SYNTAX"
	}

	for {set grad $r(-start)} {$grad <= $r(-end)} {incr grad $r(-step)} {
		foreach f $args {
			# Umrechnung ins Bogenmass
			set rad [expr $grad*4*acos(0)/360]
			set val [expr ${f}($rad)]
			puts -nonewline [format "%10.4f" $val]
		}
		puts ""
	}
}

# Optionsparameter fuer Bereich -- Funktionsaufruf
# ---------------------------------------------------------------
prtable -end 180 sin cos tan
puts ""
# ---------------------------------------------------------------
prtable -end 30 -step 3 sin cos tan
puts ""
# ---------------------------------------------------------------

