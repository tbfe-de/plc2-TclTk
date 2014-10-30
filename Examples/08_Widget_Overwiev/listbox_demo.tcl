#!/usr/bin/wish
#
listbox .test -selectmode multiple
for {set i 1} {$i < 200} {incr i} {
	.test insert end "Item $i"
}


pack .test
	
