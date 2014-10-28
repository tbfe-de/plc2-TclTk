#!/usr/bin/tclsh

# 2. Beispiel -- eine allgemeine Eingabefunktion
# sowie eine Reihe von Hilfsfunktionen (ueberwiegend
# basierend auf Regulaeren Ausdruecken) fuer haeufig
# erforderliche Tests.

proc send_prompt {p} {
	puts -nonewline stdout $p
	flush stdout
}

proc get_input {t} {
	upvar $t text
	gets stdin text
	if {[eof stdin]} {
		# Ende der Eingabedaten erreicht
		error "premature EOF while reading stdin"
	}
	# Einige oft sinnvolle Vorverarbeitungsschritte
	# 1. Fuehrendes und abschliessendes White-Space
	#    wegwerfen:
	regsub {^[ \t]*} $text "" text
	regsub {[ \t]*$} $text "" text
	# 2. Folgen von White-Space zu GENAU EINEM Blank
	#    komprimieren:
	regsub -all {[ \t]+} $text " " text
	# 3. Leerzeichen dort entfernen, wo nicht
	#    Buchstaben-, Ziffern- oder Sonderzeichen-
	#    Gruppen verschmolzen werden
	# regsub -all {([a-zA-Z0-9]) ([^a-zA-Z0-9])} $text {\1\2} text
	# regsub -all {([^a-zA-Z0-9]) ([a-zA-Z0-9])} $text {\1\2} text
}

proc getinp {prompt var check} {
	upvar $var rline
	set done 0
	while {!$done} {
		send_prompt $prompt
		get_input rline
		if {[$check $rline]} {
			set done 1
		} else {
			puts "invalid input -- try again"
		}
	}
	return 1
}

# Einige Hilfsvariablen fuer die Prueffunktionen
#
set S  {[+-]}
set O  {[0-7]}
set D  {[0-9]}
set D1 {[1-9]}
set X  {[0-9A-Fa-f]}
set E  {[eE]}
set P  {[.]}

proc any_check {dummy} {
	return 1
}

proc int_check {inp} {
	global S D D1 O X
	return [regexp "^($S?$D1$D*|0$O+|0(x|X)$X+)$" $inp]
	# Vorz. opt. -----\_/\_/|/  |\_/ \____/\_/
	# Ziffer (keine 0) ---+ |  :| | :  |    |
	# Dez.-Ziffern ---------+  :| | :  |    |
	#    ODER - - - - - - - - -+| | :  |    |
	# Praefix 0 ----------------+ | :  |    |
	# Okt.-Ziffern----------------+ :  |    |
	#    ODER - - - - - - - - - - - +  |    |
	# Praefix 0x oder 0X --------------+    |
	# Hex.-Ziffern -------------------------+
}

proc float_check {inp} {
	global S D E P
	set exp "($E$S?$D+)" ;# Exponentialteil
	return [regexp "^$S?((($D+$P$D*|$D*$P$D+)$exp?)|$D+$P?$D*$exp)$" $inp]
	#   Vorz. opt. --\_/   \______/ \______/ \___/  \|/\___/\__/
	# Ziffern vor Punkt--------+   :    |      |   : |   |   |
	#  oder - - - - - - - - - - - -+    |      |   : |   |   |
	# Ziffern nach Punkt----------------+      |   : |   |   |
	# Exponentialteil optional-----------------+   : |   |   |
	#     ODER - - - - - - - - - - - - - - - - - - + |   |   |
	# Ziffern vor Punkt------------------------------+   |   |
	# Punkt und Ziffern nach Punkt optional--------------+   |
	# Exponentialteil (NICHT optional)-----------------------+
}

proc telno_check {inp} {
	global D
	set DINgrp "($D$D?)( $D$D)*" ;# Zweiergruppen von rechts
	return [regexp "^(\\(${DINgrp}\\) )?${DINgrp}(-$D+)?$" $inp]
	#   Vorwahl------\______________/|  \_______/ | \_/
	#   und Leerzeichen------------+ :      |     |  | :
	#     optional - - - - - - - - - +      |     |  | :
	# ANSCHLUSSNUMMER-----------------------+     |  | :
	#   Bindestrich-------------------------------+  | :
	#   und Durchwahl--------------------------------+ :
	#     optional - - - - - - - - - - - - - - - - - - +
}

# ================================================================
# Test- und Demo-Anwendung

set ITYPE "any int float telno"

if {$argc == 0} {
	puts stderr "Usage: $argv0 {[join $ITYPE |]}"
	exit 1
}
set itype [lindex $argv 0]
if {[lsearch $ITYPE $itype]} {
	puts stderr "$argv0: invalid input type: $itype"
	exit 2
}

puts "Check all inputfor type '$itype'"

if {[
	catch {
		while {[getinp "--> " text ${itype}_check]} {
			puts "  = $text"
		}
	}
]} {
	puts "bye, bye"
}
	
