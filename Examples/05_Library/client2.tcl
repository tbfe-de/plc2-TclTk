#!/usr/bin/wish
#
# 2. Beispiel fuer einfachen Client (wish-Applikation)
# der Client baut beim Betaetigen des "CONNECT"-Buttons
# eine Socket-Verbindung zum Server auf und liest eine
# Textzeile, die der Server ihm schickt.

set p 2234

wm title . "Demo-Client"

pack [button .connect -text "Connect to Server"]
pack [label .display -textvariable displaytext]

.connect configure -command {
	set sock [socket 127.0.0.1 $p]
	fconfigure $sock -buffering line
	gets $sock displaytext
	close $sock
}
