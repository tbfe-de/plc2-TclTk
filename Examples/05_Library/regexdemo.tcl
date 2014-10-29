#!/usr/bin/wish

text .a
bind .a <KeyRelease> ck_regex
pack .a -side left -fill both -expand 1


foreach r {1 2 3 4 5} {
	entry .r$r -width 30
	bind .r$r <KeyRelease> [list ck_regex $r]
	pack .r$r -side top -fill x
}

proc ck_regex {{n {1 2 3 4 5}}} {	
	set t [.a get 1.0 end]
	foreach r $n {
		set e [.r$r get]
		if {[catch {
			if {[regexp ^$e$ $t]} {
				.r$r configure -background green
			} elseif {[regexp $e $t]} {
				.r$r configure -background yellow
			} else {
				.r$r configure -background red
			}
		}]} {
			.r$r configure -background lightgrey
		}
	}
}

ck_regex
