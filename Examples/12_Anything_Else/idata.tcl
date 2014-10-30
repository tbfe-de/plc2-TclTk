#!/usr/bin/wish

proc clearLength {-} {
	.input.n configure -text ""
}

proc makeBackup {n1 n2} {
	set f1 [open $n1 r]
	set f2 [open $n2 w]
	puts -nonewline $f2 [read $f1]
	close $f2
	close $f1
}

proc writeAsCSV {fid} {
	global data
	puts $fid [join $data(fields) ";"]
	for {set i 1} {$i < $data(total)} {incr i} {
		puts $fid [join $data($i) ";"]
	}
}

proc saveToFile {} {
	global data
	set name [tk_getSaveFile -initialfile $data(FILE)\
			-filetypes {
				{{Text Files} .txt}
				{{CSV Files} .csv}
				{{All Files} * ""}
			}]
	if {[string length $name] == 0} return
	if {[file exists $name]} {
		makeBackup $name $name.bak
	}
	set fid [open $name w]
	writeAsCSV $fid
	close $fid
	wm title . "Saved: [set data(FILE) $name]"
}

proc destroyEditArea {} {
	global data
	for {set i [llength $data(fields)]} {$i > 0} {incr i -1} {
		.input delete 1.0 end
	}
}

proc buildEditArea {} {
	global data
	set i 0
	.input configure -height [llength $data(fields)]
	foreach f $data(fields) {
		incr i
		label .input.f_$i -text "$f"
		entry .input.e_$i -width 20 -font fixed -background white
		checkbutton .input.c_$i
		label .input.n_$i
		.input insert end \t
		.input window create end -window .input.f_$i
		.input insert end \t
		.input window create end -window .input.e_$i
		.input window create end -window .input.c_$i
		.input insert end " ("
		.input window create end -window .input.n_$i
		.input insert end ")\n"
		bind .input.e_$i <KeyRelease> {updateFieldState %W}
		bind .input.e_$i <Return> {applyChanges}
		bind .input.e_$i <Control-BackSpace> {undoChanges; break}
	}
}

proc readAsCSV {fid} {
	global data
	catch {unset data}
	set data(fields) [split [gets $fid] ";"]
	set data(total) 1
	set data(current) 1
	while {[gets $fid line] >= 0} {
		set data($data(total)) [split $line ";"]
		incr data(total)
	}
	set data($data(total)) [list]
}

proc loadFile {{name ""}} {
	global data
	if {[string length $name] == 0} {
		set name [tk_getOpenFile -initialfile $name\
			-filetypes {
				{{Text Files} .txt}
				{{CSV Files} .csv}
				{{All Files} *}
			}]
	}
	if {[string length $name] == 0} return
	.input configure -state normal
	destroyEditArea
	set fid [open $name r]
	readAsCSV $fid
	close $fid
	buildEditArea
	.input configure -state disabled
	updateNumberOfRecords
	updateEditArea
	wm title . "Loaded: [set data(FILE) $name]"
}

proc editAreaChanged {} {
	global data
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		if {[string compare [.input.e_$i get] [lindex $data($data(current)) [expr $i-1]]]} {
			return 1
		}
	}
	return 0
}

proc editAreaClear {} {
	global data
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		if {[string length [.input.e_$i get]]} {
			return 0
		}
	}
	return 1
}

proc updateButtonState {} {
	global data 
	set ec [editAreaChanged]
	.controls.load configure -state [expr $ec ?"disabled":"normal"]
	.controls.save configure -state [expr $ec ?"disabled":"normal"]
	.controls.exit configure -state [expr $ec ?"disabled":"normal"]

	.controls.clear configure -state [expr $ec ?"disabled":"normal"]
	.controls.undo configure -state [expr !$ec ?"disabled":"normal"]
	.controls.apply configure -state [expr !$ec ?"disabled":"normal"]

	.current.rec configure -state [expr $ec ?"disabled":"normal"]
	.current.prev configure -state [expr $ec || $data(current) == 1 ?"disabled":"normal"]
	.current.next configure -state [expr $ec || $data(current) == $data(total) ?"disabled":"normal"]
	.current.rec configure -background [expr $ec ?"bisque":"white"]
	.current.prev configure -background [expr $ec ?"bisque":"white"]
	.current.next configure -background [expr $ec ?"bisque":"white"]

}

proc updateNumberOfRecords {} {
	global data 
	.current.rec configure -to $data(total)
	if {$data(current) > $data(total)} {
		set data(current) $data(total)
	}
	updateButtonState
}

proc updateFieldState {win} {
	global data
	scan $win ".input.e_%d" i
	set d [lindex $data($data(current)) [expr $i-1]]
	set c [string compare [$win get] $d]
	.input.e_$i configure -background [expr $c ?"bisque":"white"]
	.input.n_$i configure -text [string length [$win get]]
	updateButtonState
}

proc updateEditArea {} {
	global data
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		.input.e_$i configure -background white
		.input.e_$i delete 0 end
		set d [lindex $data($data(current)) [expr $i-1]]
		.input.e_$i insert 0 $d
		.input.n_$i configure -text [string length $d]
	}
	updateButtonState
}

proc changeRecord {} {
	switch -- [tk_messageBox -type okcancel -icon question -default ok\
		-message "Change current Record"] { cancel return }
	global data
	set data($data(current)) [list]
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		lappend data($data(current)) [.input.e_$i get]
	}
	wm title . "Edited: $data(FILE)"
}

proc deleteRecord {} {
	switch -- [tk_messageBox -type okcancel -icon question -default ok\
		-message "Delete current Record"] { cancel return }
	global data
	for {set t $data(current)} {$t < $data(total)} {incr t} {
		set data($t) $data([expr $t+1])
	}
	unset data($data(total))
	incr data(total) -1
	updateNumberOfRecords
	updateEditArea
	wm title . "Edited: $data(FILE)"
}

proc appendRecord {} {
	switch -- [tk_messageBox -type okcancel -icon question -default ok\
		-message "Append new Record"] { cancel return }
	global data
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		lappend data($data(total)) [.input.e_$i get]
		.input.e_$i configure -background white
	}
	set data([incr data(total)]) [list]
	set data(current) $data(total)
	updateNumberOfRecords
	updateEditArea
	wm title . "Edited: $data(FILE)"
}

proc setCurrentRecord {c} {
	global data
	set data(current) $c
	updateEditArea
}

proc incrementCurrentRecord {} {
	global data
	.current.rec set [expr $data(current)+1]
}
	
proc decrementCurrentRecord {} {
	global data
	.current.rec set [expr $data(current)-1]
}

proc clearEditArea {} {
	global data
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		.input.e_$i delete 0 end
		set c [string length [lindex $data($data(current)) [expr $i-1]]]
		.input.e_$i configure -background [expr $c ?"bisque":"white"]
		.input.n_$i configure -text "0"
	}
	updateButtonState
}

proc undoChanges {} {
	global data
	for {set i 1} {$i <= [llength $data(fields)]} {incr i} {
		.input.e_$i delete 0 end
		.input.e_$i insert 0 [lindex $data($data(current)) [expr $i-1]]
		.input.e_$i configure -background white
	}
	updateButtonState
}

proc applyChanges {} {
	global data
	if {[editAreaChanged]} {
		if {$data(current) == $data(total)} {
			if {![editAreaClear]} {
				appendRecord
			}
		} else {
			if {[editAreaClear]} {
				deleteRecord
			} else {
				changeRecord
			}
		}
	}
	updateEditArea
}

frame .current
scale .current.rec -from 1 -to 1 -background white -orient horizontal -command setCurrentRecord
button .current.prev -text "-" -background white -foreground grey -command { decrementCurrentRecord }
button .current.next -text "+" -background white -foreground grey -command { incrementCurrentRecord }
pack .current.prev -side left -fill y
pack .current.next -side right -fill y
pack .current.rec -fill both -expand 1

text .input -width 80 -wrap none -relief flat -tabs {5.2c right 2.4c left} -cursor "" -font fixed -yscrollcommand {.scroll set}
scrollbar .scroll -command {.input yview}
frame .controls

pack .controls -side right -fill y
pack .current -side bottom -fill x
pack .scroll -side right -fill y
pack .input -side top -fill both -expand 1

pack [button .controls.load -text "LOAD" -background pink -command loadFile] -fill x
pack [button .controls.save -text "SAVE" -background pink -command saveToFile ] -fill x
pack [button .controls.exit -text "EXIT" -background pink -command exit] -fill x
pack [button .controls.apply -text "APPLY" -background green -command applyChanges] -side bottom -fill x
pack [button .controls.undo -text "UNDO" -background red -command undoChanges] -side bottom -fill x
pack [button .controls.clear -text "CLEAR" -background lightblue -command clearEditArea] -side bottom -fill x
pack [frame .controls.wspacexit -height 15] -fill both

set data(fields) [list]
loadFile [lindex $argv 0]
