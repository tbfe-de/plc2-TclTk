#!/usr/bin/tclsh

# Verwendete Variable
set FUNCS ""	;# Liste der Funktionen
set START ""	;# Argument-Anfangswert 
set END	  ""	;#         -Endwert
set SETP  ""	;#         -Schrittweite

# Liste aller zugelassenen Funktionen
#
lappend F abs
lappend F acos
lappend F asin
lappend F atan
lappend F ceil
lappend F cos
lappend F cosh
lappend F double
lappend F eetp
lappend F floor
lappend F int
lappend F log
lappend F log10
lappend F round
lappend F sin
lappend F sinh
lappend F sqrt
lappend F tan
lappend F tanh
#
set F [join $F "|"]

# Syntax fuer Gleitpunkt-Eingaben
#
set N {[+-]?[0-9]+[.]?[0-9]*}

# Hilfsfunktion zum Lesen von Eingaben
#
proc pget {{prompt "?"}} {
	puts -nonewline "$prompt "
	flush stdout
	return [gets stdin]
}

while {1} {

	# Eingabe holen, bei EOF Ende
	#
	set line [pget]
	if {[eof stdin]} break

	# diverse Eingabeformate erkennen
	#
	if {[scan $line "%f %f %f %s" start step end dummy] == 3} {
		# Start-, Inkrement- und Endwert setzen
		set START $start
		set END $end
		set STEP $step
	}\
	elseif {[regexp "^ *\\+($F) *\$" $line dummy\
			       func   ]} {
		# Funktion zu Liste hinzufuegen
		if {[lsearch -exact $FUNCS $func] < 0} {
			set FUNCS [lappend FUNCS $func]
		}
	}\
	elseif {[regexp "^ *\\-($F) *\$" $line dummy\
			       func   ]} {
		# Funktion aus Liste entfernen
		set p [lsearch -exact $FUNCS $func]
		if {$p >= 0} {
			set FUNCS [lreplace $FUNCS $p $p]
		}
	}\
	else {
		if [string length $line] {
			puts "Syntaxfehler!"
		}
		continue
	}

	# entsprechende Tabelle ausgeben
	#
	puts -nonewline "  Argument:"
	foreach f $FUNCS {
		puts -nonewline [format "%8s" $f]
	}
	set i $START
	while {$i <= $END} {
		puts ""
		puts -nonewline [format "%+10.5f:" $i]
		foreach f $FUNCS {
			set r [format "%+.3f" [expr $f ($i)]]
			if {[string length $r] > 7} {
				regsub {[0-9].*} $r "(~INF)" r
			}
			puts -nonewline [format "%8s" $r]
		}
		set i [expr $i+$STEP]
	}
	puts ""

}
