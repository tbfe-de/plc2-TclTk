#!/usr/bin/tclsh

proc putslow {chan text ttime} {
	set nchars [string length $text]
	set delay [expr int(1000*$ttime / $nchars)]
	for {set i 0} {$i < $nchars} {incr i} {
		puts -nonewline $chan [string index $text $i]
		flush $chan
		after $delay
	}
}
putslow stdout "hello, world\n" 4
