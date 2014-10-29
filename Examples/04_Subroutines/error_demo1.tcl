#!/usr/bin/tclsh

# 1. Beispiel -- Demonstration der Wirkung von
# 'error' und 'catch':
# In einer Kette von Funktionsaufrufen
#	foo --> bar --> xxx --> yyy
# loest 'yyy' einen Fehler aus, falls die Variable
# 'a' nicht gesetzt ist.  (Darueberhinaus enthalten
# die Funktionen nur Kontrollausgaben.)

proc foo {} {
	puts "foo gestartet"
	bar
	puts "foo beendet"
}

proc bar {} {
	puts "bar gestartet"
	xxx
	puts "bar beendet"
}

proc xxx {} {
	puts "xxx gestartet"
	yyy
	puts "xxx beendet"
}

proc yyy {} {
	global a
	puts "yyy gestartet"
	unset a
	puts "yyy beendet"
}

# Zunaechst wird die Variable 'a' gesetzt ...
set a 42

# ... der erste Aufruf kehrt somit normal zurueck ...
puts "--- 1. Aufruf von foo"
foo

# ... aber der zweite fuehrt zum Programmabruch.
puts "--- 2. Aufruf von foo"
foo

