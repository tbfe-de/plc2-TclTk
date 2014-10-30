proc sendcommand {cmd} {
	global value
	set s [socket 127.0.0.1 8081]
	puts $s "GET /$cmd HTTP/1.0\n"
	flush $s
	while {[gets $s line] >= 0} {
		if {[regsub {.*Counter:[ \t]*(-?[0-9]+).*} $line {\1} v]} {
			set value $v
		}
	}
	close $s
}

sendcommand x
label .v -font {SansSerif 40} -textvariable value
button .p -text UP   -command { sendcommand plus  }
button .m -text DOWN -command { sendcommand minus }
button .r -text ZERO -command { sendcommand reset }
pack .v -side top -fill both -expand 1
pack .p .m .r -side left -expand 1 -fill x
