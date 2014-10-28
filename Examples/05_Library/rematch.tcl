#!/usr/bin/wish

entry .regex -textvariable regex -font {courier 24}
entry .input -textvariable input -font {courier 24}
frame .match -bg white
label .match.text -textvariable match -font {courier 24}
label .match.pos -textvariable indexlist -font {courier 24}
label .match.start -textvariable start -font {courier 24}
label .match.length -textvariable length -font {courier 24}

pack .match.text -side left
pack .match.length .match.start -side right

pack .regex .input .match -side top -fill x -expand 1

proc evaluate {} {
	global input regex start length match
	if {[catch {regexp -- $regex $input match} result]} {
		.match configure -bg white
		set match $result
	} else {
		if {$result} {
			.match configure -bg green
			regexp -indices -- $regex $input indexlist
			set start [expr [lindex $indexlist 0] + 1]
			set length [expr [lindex $indexlist 1] - $start + 2]
		} else {
			set match ""
			set start ""
			set length ""
			.match configure -bg red
		}
	}
}

bind .input <Return> evaluate
bind .regex <Return> evaluate
