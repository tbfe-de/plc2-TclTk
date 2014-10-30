#!/usr/bin/tclsh

if {$argc != 1} {
	puts stderr "Usage: $argv0 file"
	exit 1
}

set fname [lindex $argv 0]

if {[catch {set infile [open $fname r]}]} {
	puts stderr "$argv0: cannot open file: $fname"
	exit 2
}

set lnum 0
while {1} {
	gets $infile line
	if [eof $infile] break
	incr lnum
	puts "$lnum\t$line"
}
exit 0
