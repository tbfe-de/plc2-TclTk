#!/usr/bin/wish

set show [list\
	[list -text Ready -font {Helvetica 30}]\
	[list -text Steady -font {Helvetica 50} -bg yellow]\
	[list -text Go! -font {Helvetica 90} -bg green]\
]

proc count_down {} {
	global show
	.b configure -activebackground red
	foreach w $show {
		eval .b configure $w
		update
		after 3000
	}
	exit
}
button .b -text "Click to Start" -command count_down
pack .b -expand 1 -fill both
wm geometry . 250x250

