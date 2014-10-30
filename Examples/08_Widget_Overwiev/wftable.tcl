# ===============================================
# Erzeugen einer Tabelle der Winkelfunktionen
# ===============================================

# Ueber globale Variablen steuerbar:
set start 0		;# Anfangswinkel in Grad
set end 360		;# Endwinkel in Grad
set step 30		;# Schrittweite in Grad
set funcs(sin) 1	;# Auswahl der Funktionen
set funcs(cos) 1	;#
set funcs(tan) 0	;#

# Ergebnis in globaler Variable
set table ""		;# Tabelle als Text (mit
			;# Zeilenvorschueben)

# Erzeugung der Tabelle:
proc wftable {} {
	global start end step funcs table
	set table ""
	for {set grd $start} {$grd <= $end} {incr grd $step} {
		append table [format "%3d: " $grd]
		set rad [expr $grd*4*acos(0)/360]
		foreach f [array names funcs] {
			if {$funcs($f)} {
				set val [expr ${f}($rad)]
				set fval [format "%.2f" $val]
				if {[string length $fval] > 6} {
					set fval "~(oo)"
				}
				append table [format " %6s" $fval]		
			}
		}
		append table "\n"
	}

	return ""
}

