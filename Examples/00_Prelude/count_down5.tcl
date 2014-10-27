#!/usr/bin/wish

proc count_down {} {
	foreach w { Ready Steady Go! } {
		.b configure -text $w
		update
		after 3000
	}
	exit
}
button .b\
	-text "Click to Start"\
	-command count_down
pack .b -expand 1 -fill both
wm geometry . 250x250

