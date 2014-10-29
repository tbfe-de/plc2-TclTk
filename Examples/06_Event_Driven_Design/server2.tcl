#!/usr/bin/wish
#
# 2. Beispiel fuer einfachen Server (wish-Applikation)
# der Server dem Client nach Aufbau der Verbindung den
# Text "hello!" und eine laufende Nummer.

set p 2234

wm title . "Demo-Server"
pack [label .display -textvariable displaytext]

set count 0
proc say_hello {sock adr port} {
	global count
	puts $sock "hello! ([incr count])"
	close $sock

	# Server-Aktivitaet in Window anzeigen
	global displaytext
	append displaytext "\nmessage sent to $adr ($count)"
}

set listener [socket -server say_hello $p]
wm protocol . WM_DELETE_WINDOW {
	close $listener
	exit
}

set displaytext "waiting for connection at port $p"
vwait forever
