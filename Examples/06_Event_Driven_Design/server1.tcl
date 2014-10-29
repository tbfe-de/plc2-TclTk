#!/usr/bin/tclsh
#
# Einfachstes Demo-Programm fuer Socket-Kommunikation
# (nur Verbindungsaufbau, kein Datenaustausch)

set p 2233	;# IP-port fuer Client-Connects

# Reaktion fuer ankommende Verbindungswuensche
#
proc s {sock adr port} {
	puts "connected to ip-adr $adr, port-no $port"
	close $sock
}

# Socket anlegen und auf Verbindungen warten
#
puts "creating server socket"
socket -server s $p
puts "waiting for requests at port-no $p"
vwait forever

# Hinweis: Der Server laeuft nun so lange, bis man den
# Prozess, der die tclsh ausfuehrt, zwangsweise beendet,
# z.B. durch CTRL-C.
