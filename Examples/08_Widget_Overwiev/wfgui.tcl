!
source "wftable.tcl"

# Rahmen fuer die steuernden Kontroll-Elemente
#
frame .control -borderwidth 3 -relief ridge
#
# Steuernde Kontroll-Elemente und zugeordnete Texte
#
label .control.start_label -text "Anfangswert:"\
	-justify right
entry .control.start_entry\
	-width 5\
	-textvariable start
scale .control.start\
	-from 0 -to 360\
	-showvalue 0\
	-orient horizontal\
	-variable start
label .control.end_label -text "Endwert:"\
	-anchor e
entry .control.end_entry\
	-width 5\
	-textvariable end
scale .control.end\
	-from 0 -to 360\
	-showvalue 0\
	-orient horizontal\
	-variable end
label .control.step_label -text "Schrittweite:"\
	-justify right
entry .control.step_entry\
	-width 5\
	-textvariable step
scale .control.step\
	-from 1 -to 90\
	-showvalue 0\
	-orient horizontal\
	-variable step
label .control.funcs_label -text "Funktionen:" 
frame .control.funcs
checkbutton .control.funcs.sin -text Sinus\
	-variable funcs(sin)
checkbutton .control.funcs.cos -text Cosinus\
	-variable funcs(cos)
checkbutton .control.funcs.tan -text Tangens\
	-variable funcs(tan)
# Funktionsauswahlen nebeneinander
pack .control.funcs.sin -side left
pack .control.funcs.cos -side left
pack .control.funcs.tan -side left
#
# Anordnung der steuernden Kontroll-Elemente
#
grid .control.start_label .control.start_entry .control.start -sticky we
grid .control.end_label   .control.end_entry   .control.end   -sticky we
grid .control.step_label  .control.step_entry  .control.step  -sticky we 
grid .control.funcs_label .control.funcs        -             -sticky we

grid columnconfigure .control 0 -weight 0 
grid columnconfigure .control 1 -weight 0 
grid columnconfigure .control 2 -weight 1 

# Rahmen fuer die ausloesenden Kontroll-Elemente
frame .action -bg white
#
# Ausloesende Kontroll-Elemente
button .action.go -text "GO!"\
	-bg green\
	-command wftable
button .action.quit -text "QUIT"\
	-bg red\
	-command exit
#
# Anordnung der ausloesenden Kontroll-Elemente
#
pack .action.go -side top -fill both -expand 1
pack .action.quit -side top -fill both -expand 1

# Rahmen fuer die anzeigenden Kontroll-Elemente
#
frame .display
#
# Anzeigende Kontroll-Elemente
#
text .display.text\
	-height 10 -width 30\
	-state disabled\
	-font courier\
	-wrap none\
	-yscrollcommand ".display.bar set"
scrollbar .display.bar\
	-command ".display.text yview"
trace variable table w set_table
proc set_table {d1 d2 d3} {
	global table
	.display.text configure -state normal
	.display.text delete 1.0 end
	.display.text insert end $table
	.display.text configure -state normal
}
#
# Anordnung der anzeigenden Kontroll-Elemente 
#
pack .display.bar -fill y -side left
pack .display.text -fill both -expand 1

# Anordnung der Rahmen fuer die Kontroll-Elemente
#
pack .control -side top -fill x
pack .action -side right -fill y
pack .display -fill both -expand y

