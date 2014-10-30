#!/usr/local/bin/tclsh8.0

lappend auto_path "."

# Ausgabe einer Tabelle von mathematischen Funktionen
#
proc mathfuncs {sse funcs} {
	set start [lindex $sse 0]
	set step  [lindex $sse 1]
	set end   [lindex $sse 2]
	printf "         |"
	foreach f $funcs {
		printf "%8s  " $f
	}
	printf "\n---------+%s\n" [linie [expr 10*[llength $funcs]]]
	for {set i $start} {$i <= $end} {set i [expr $i+$step]} {
		printf "%8.2f |" $i
		foreach f $funcs {
			set p [expr $f ($i)]
			printf "%9.2f " $p
		}
		printf "\n"
	}
}

# Erzeugen eines beliebig langen Strings aus
# Minus-Zeichen.
#
proc linie {{laenge} {zeichen "-"}} {
	set result ""
	while {[incr laenge -1] >= 0} {
		append result $zeichen
	}
	return $result
}

# Prompt ausgeben (Default ?) und solange
# Benutzereingabe holen, bis Pruefung mit
# regulaerem Ausdruck (Default .*) O.K.
#
proc eingabe {{prompt "?"} {pruef ".*"}} {
	# uebergebenen Pruef-Ausdruck modifizieren
	set pruef [format {^[ \t]*%s[ \t]*$} $pruef]
	# von Anfang an ---|              |--- bis Ende
	# white space ------||||||  ||||||
	# Pruef-Ausdruck ---------||

	set done 0	;# ersten Durchlauf erzwingen
	while {!$done} {
		puts -nonewline "$prompt "
		flush stdout
		gets stdin eing
		set done [regexp $pruef $eing]
	}
	return $eing
}

# Hilfsvariablen fuer charakteristische Teile der
# nachfolgend spezifiyierten Pruef-Ausdruecke
#
set GPZ {[+-]?([0-9]+[.][0-9]*|[0-9]*[.][0-9]+)}
set HWS {[ \t]}
set FNC {sin|cos|tan|abs}

# Regulaere Ausdruecke fuer die eigentlichen Pruefungen
# -----------------------------------------------------
# Drei Gleitpunktzahlen
#
set RANGE "${GPZ}${HWS}+${GPZ}${HWS}+${GPZ}"
# erste ---||||||
# white space ---||||||
# zweite ---------------||||||
# white space --------------|||||||||
# und dritte Zahl -------------------||||||
# -----------------------------------------------------
# Beliebig lange Liste von Funktionsnamen (nicht leer)
#
set MFUNC "(${FNC})(${HWS}+(${FNC}))*"
# erster --||||||
# white space ----||||||
# weiterer --------------||||||
# 0 bis n mal ---|.............||

proc test1 {} {
	global RANGE
	global MFUNC
	mathfuncs	 				\
		[eingabe "Start Schritt Ende:" $RANGE]	\
		[eingabe "Funktionen:"	       $MFUNC]	\
		;
}

proc test2 {} {
	global HWS
	global GPZ
	global FNC
	set start 0.0
	set step 0.1
	set end 1.0
	set funcs "sin cos"
	while {![eof stdin]} {
		# Eingabe lesen ...
		set line [eingabe ">>"]
		regsub "^${HWS}*" $line "" line
		# ... Leerzeichen entfernen ...
		regsub "${HWS}*$" $line "" line
		# ... und pruefen
		switch -regexp -- $line ^$ {} \
		^${GPZ}${HWS}+${GPZ}\$ {
				scan $line "%f %f" start end
			} \
		^${GPZ}${HWS}+${GPZ}${HWS}+${GPZ}\$ {
				scan $line "%f %f %f" start step end
			} \
		^(\\+|-)${HWS}*(${FNC})\$ {
				regexp "${FNC}" $line f
				set p [lsearch $funcs $f]
				switch -glob -- $line {
				+* {
						if {$p == -1} {
							lappend funcs $f
						}
					}
				-* {
						if {$p != -1} {
							set funcs [lreplace\
								 $funcs $p $p]
						}
					}
				}
			} \
		^go$ {		;# print table
				mathfuncs "$start $step $end" $funcs
			} \
		^(H|h|\\?) {	;# show syntax help
				puts "usage: start end"
				puts " -or-  start step end"
				puts " -or-  +function"
				puts " -or-  -function"
			} \
		^(Q|q|E|e) {	;# quit (end) the function
				puts "bye, bye"
				return
			} \
		default {
				puts "sorry: $line ??"
			} \
		;
		
	}
}
