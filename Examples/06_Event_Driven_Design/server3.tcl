#!/usr/bin/wish

set topcnt 0

proc p {sock adr port} {
	global topcnt
	set win [format ".conn%s" [incr topcnt]]
	wm title $win "Connection $add:$port"
	label $win.r -relief sunken -background lightgrey\
		-textvariable received
	entry $win.s -width 30\
		-textvariable to_send
	button $win.b -text "SEND" -command s

	global dtext
	append dtext "accepted connection from $adr\n"
	puts $sock "hello!"
	append dtext "greeting sent to client\n"
	close $sock
}

wm title . "Demo-Server"
pack [label .display -textvariable dtext]
append dtext "creating server socket\n"
socket -server p 2266
append dtext "waiting for connection\n"
vwait forever
