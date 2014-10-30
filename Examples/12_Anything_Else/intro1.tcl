#!/usr/bin/tclsh

# ============================================
# Hilfsfunktionen
# ============================================

# Gemaess 'format' formatierte Ausgabe des
# Wertes 'value' (ohne Zeilenvorschub)
#
proc putfmt1 {format value} {
	puts -nonewline [format $format $value]
}

# Ausgabe einer Zeile aus 'length' mal dem
# Zeichen 'lchar' (ohne Zeilenvorschub)
#
proc putnchr {length {lchar "-"}} {
	for {set i 0} {$i < $length} {incr i} {
		append line $lchar
	}
	puts -nonewline $line
}

# Ausgabe eines Zeilenvorschubs
#
proc putln {} {
	puts ""
}

# Eingabeaufforderung 'prompt' ausgeben
# und (Text-) Eingabe holen
#
proc pget {{prompt "?"}} {
	puts -nonewline "$prompt "
	flush stdout
	return [gets stdin]
}

# Eingabeaufforderung 'prompt' ausgeben,
# Ganzzahl-Eingabe holen und pruefen
#
proc pgetnum {{prompt "Ganzzahl?"}} {
	while {![regexp {^[0-9]+$} [set value [pget $prompt]]]} {
		puts "Fehlerhafte Eingabe!"
	}
	return $value
}

# Ausgabe einer Tabelle des Einmaleins mit
# waehlbarer Zahl von 'zeilen' und 'spalten'
#
proc einmaleins {zeilen spalten} {
	# Tabelle des "Einmaleins" ausgeben
	putfmt1 "%3s|" "1x1"
	for {set j 1} {$j <= $spalten} {incr j} {
		putfmt1 " %3d" $j
	}
	putln
	putnchr [expr 4*($spalten+1)]
	for {set i 1} {$i <= $zeilen} {incr i} {
		putln
		putfmt1 "%3d|" $i
		for {set j 1} {$j <= $spalten} {incr j} {
			putfmt1 " %3d" [expr $j*$i]
		}
	}
	putln
}

# ============================================
# HAUPTPROGRAMM
# ============================================

einmaleins \
	[pgetnum "Zeilen:" ]\
	[pgetnum "Spalten:"]

