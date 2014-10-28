#!/usr/local/bin/tclsh

# Third Example:
# Instead of individual arguments for lower limit, step,
# and upper limit here the three values are put into
# (another) list

proc printf {fmtspec args} {
	puts -nonewline [eval format {$fmtspec} $args]
}

proc mathfuncs {range funcs} {
	set lower [lindex $range 0]
	set step  [lindex $range 1]
	set upper [lindex $range 2]
	# --------------------------- Ueberschriftzeile
	printf "%7s |" "arg"
	foreach f $funcs {
		printf "%8s  " ${f}
	}
	printf "\n"
	# ----------------------------- Funktionstabelle
	for {set v $lower} {$v <= $upper} {set v [expr $v + $step]} {
		# -------------------- Funktionsargument
		printf "%7.2f |" $v
		foreach f $funcs {
			# ------- -------- Funktionswert
			printf "%8.3f  " [expr ${f}($v)]
		}
		printf "\n"
	}
}

mathfuncs {-1.6 0.2 1.6} {sin cos tan abs}
