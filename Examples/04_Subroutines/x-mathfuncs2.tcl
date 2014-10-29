#!/usr/bin/tclsh

# Second Example:
# What was held in global variables is now put into
# function arguments

proc printf {fmtspec args} {
	puts -nonewline [eval format {$fmtspec} $args]
}

# TO-DO: specify formal argument list in place of dots
#
proc mathfuncs ... {
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

# TO-DO: specify actual arguments in place of dots
#
mathfuncs ...
