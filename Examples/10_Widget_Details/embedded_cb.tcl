#!/usr/bin/wish

pack [text .t]
checkbutton .t.ok\
	-text OK\
	-variable ok\
	-command {colorize $ok}
.t insert end "A checkbutton here?" bgc " "
.t window create end -window .t.ok
proc colorize {x} {
	set red_green [lindex {red green} $x]
	.t tag config bgc -background $red_green
}
colorize 0
