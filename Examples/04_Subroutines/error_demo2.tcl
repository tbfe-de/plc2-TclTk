#!/usr/local/bin/tclsh

# 2. Beispiel -- In der Kette von Funktionsaufrufen
#	foo --> bar --> xxx --> yyy
# faengt 'foo' den von 'yyy' ausgeloesten Fehler ab.

proc foo {} {
	puts "foo gestartet"
	catch {
		puts "bar wird gleich gestartet"
		bar
		puts "bar hat sich ohne Fehler beendet"
	}
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

# ... der zweite ebenso, da 'foo' den Fehler faengt.
puts "--- 2. Aufruf von foo"
foo

