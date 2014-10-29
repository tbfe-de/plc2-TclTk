#!/usr/bin/tclsh

# 3. Beispiel -- In der Kette von Funktionsaufrufen
#	foo --> bar --> xxx --> yyy
# faengt 'foo' in der typischen Art und Weise ab, die
# notwendig ist, wenn der fehlerfreie und fehlerhafte
# Ablauf in unterschiedlichen Zweige einer if-Anweisung
# fuehren soll.

proc foo {} {
	puts "foo gestartet"
	if [catch {
		bar
	}] {
		puts "bar hat sich MIT Fehler beendet"
	} else {
		puts "bar hat sich OHNE Fehler beendet"
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

set a 42
puts "--- 1. Aufruf von foo"
foo
puts "--- 2. Aufruf von foo"
foo
