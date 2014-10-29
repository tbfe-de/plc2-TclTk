#!/usr/bin/tclsh

proc listdir {{names .}} {
	global argv0
	foreach name $names {
		if {[file isdirectory $name]} {
			set subnames [glob -nocomplain "$name/*"]
			if {[set x [lsearch -exact $subnames .]] != -1} {
				set subnames [lreplace $subnames $x $x]
			}
			if {[set x [lsearch -exact $subnames ..]] != -1} {
				set subnames [lreplace $subnames $x $x]
			}
			listdir $subnames
		} elseif {[file exists $name]} {
			file stat $name info
			puts [format "%8d %s\n" $info(size) $name]

		} else {
			puts stderr "$argv0: file does not exist: $name"
		}
	}
}

listdir $argv
