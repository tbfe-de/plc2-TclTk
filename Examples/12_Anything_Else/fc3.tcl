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

set _ {[ \t]}	;# white space (fuer REs)

set lnum 0
set errs 0
set check ".*"
while {1} {
	gets $infile line
	if [eof $infile] break
	incr lnum
	regexp "^$_*#$_*CHECK:$_+(.*)$_*$" $line dummy\
                                 check
	if [regexp "^$_*(#.*)?$_*$" $line] continue
	if ![regexp $check $line] {
		puts "$fname\[$lnum\]: $line"
		incr errs
	}
}
exit [expr $errs ? 0 : 1]
