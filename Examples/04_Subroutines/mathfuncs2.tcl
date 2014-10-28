#!/usr/local/bin/tclsh

# Second Example:
# What was held in global variables is now put into
# function arguments

proc printf {fmtspec args} {
	puts -nonewline [eval format {$fmtspec} $args]
}

proc mathfuncs {lower step upper funcs} {
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

mathfuncs -1.6 0.2 1.6 {sin cos tan abs}
