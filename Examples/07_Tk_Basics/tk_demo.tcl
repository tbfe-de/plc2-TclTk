#!/usr/bin/wish

# Programm-Status
#
set data 0

# Programm-Aktivitäteten
#
proc setcolor {} {
	global data
	if {$data >= 100}   { .v configure -bg red }\
	elseif {$data <= 0} { .v configure -bg blue }\
	else                { .v configure -bg green }
}
#
proc newvalue {} {
	global data
	set data [expr -.27*$data + 100]
	setcolor
}

# Definition und Verknüpfug der Widgets
#
label  .v -text VALUE
entry  .e -textvariable data
bind   .e <FocusOut> setcolor
button .a -text "ACTION" -command newvalue

# Aufbau des Bildschirm-Layouts
#
pack .a -side bottom -fill both
pack .v -side left -fill y
pack .e -side right -fill y -expand 1

# Initialisierung der Daten und Praesentation
#
set data 123
setcolor

