#!/usr/bin/tclsh

# 1. Beispiel -- einige Regulaere Ausdruecke sowie
# eine einfache kleine Testumgebung zum Ausprobieren.

proc getinp {prompt var} {
	upvar $var rline
	puts -nonewline $prompt
	flush stdout
	set res [gets stdin rline]
	return [expr $res != -1]
}

while {[getinp "--> " text]} {

	# evtl. regsub um fuehrendes und abschliessendes
	# white space wegzuwerfen

	if [regexp {^[+-]?[0-9]+$} $text] {
		puts "Ganzzahl mit optionalem Vorzeichen"
	}

	if [regexp {^[ \t]*0[xX][0-9a-fA-F]+[ \t]*$} $text] {
		puts "Hexzahl mit optionalem umgebenden White Space"
	}

	if [regexp {^([0-9]*[.][0-9]+|[0-9]+[.][0-9]*)$} $text] {
		puts "Gleitpunktzahl mit optionalem Vor-/Nachkommateil"
	}

	if [regexp {^[0-9]+([.][0-9]*)?$} $text] {
		puts "Gleitpunktzahl mit optionalem Punkt und Nachkommateil"
	}

	if [regexp {^(DM|EUR)[ \t]+[0-9]+([.][0-9][0-9])?$} $text] {
		puts "Betragsangabe in D-Mark oder Euro"
	}

	if [regexp {^DM ([0-9]+)[.]([0-9][0-9])$} $text dummy mark pfennig] {
		puts "$mark Mark und $pfennig Pfennig"
	}
		
	if [regexp {^EUR[ \t]+([0-9]+)[.]([0-9][0-9])$} $text dummy euro cent] {
		puts "$euro Euro und $cent Cent"
	}

}
