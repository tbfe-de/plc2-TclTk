#!/usr/bin/wish
#
# 2. Beispiel fuer einfachen Server (wish-Applikation)
# der Server dem Client nach Aufbau der Verbindung den
# Text "hello!"

set p 2234

wm title . "Demo-Server"
pack [label .display -textvariable displaytext]

proc newWin {w c} {
	toplevel $w
	wm title $w "Connection: $c"
	label $w.received "(received)"
	entry $w.to_send" -width 20
	button $w.send -text "SEND" -command send $w
}

proc p {sock adr port} {
	global displaytext
	append displaytext "accepted connection from $adr\n"
	puts $sock "hello!"
	append displaytext "greeting sent to client\n"
	close $sock
	newWin .$sock
}

socket -server p $p
append displaytext "waiting for connection at port $p\n"
vwait forever
