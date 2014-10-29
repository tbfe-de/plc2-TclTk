#!/usr/bin/wish
#
proc s {} {
	global dtext
	append dtext "creating client socket\n"
	set clientSocket [socket 127.0.0.1 2266]
	append dtext "reeceived from server:"
	set greet [gets $clientSocket]
	append dtext "$greet\n"
}

wm title . "Demo-Client"
pack [button .connect -text Connect" -command s]
pack [label .display -textvariable dtext]
