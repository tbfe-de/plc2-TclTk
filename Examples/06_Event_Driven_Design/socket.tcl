#!/usr/bin/tclsh
# ===================================================
# Fetch a Web-Page with a Tcl Command
# ===================================================

# --------------------------------------- open socket
#
set so [socket "tbfe.de" 80]

# ---------------------------------- send get request
#
puts $so "GET /wElCoMeTcL.txt HTTP/1.0\n\n"
flush $so

# ----------------------- show what has been received
#
puts [read $so]
