#!/usr/bin/tclsh
#

socket -server acc_con 1234

proc acc_con {fd args} {
	while ![eof $fd] {
		gets $fd r
		append request $r<br />\n
		if {[string length $r] == 0} break
	}
	puts $fd "<html>"
	puts $fd "<head><title>$args</title></head>"
	puts $fd "<body><tt>"
	puts $fd "----<br />"
	puts $fd "$request"
	puts $fd "----<br />"
	puts $fd "</tt></body>"
	puts $fd "</html>"
	close $fd
}

vwait forever
