#!/usr/bin/wish

# 1. Beispiel -- Erzeugen einer Oberflaeche
# fuer das Programm zur Ausgabe mathematischer
# Funtionen:

frame	.knopfleiste
pack 	.knopfleiste -side right -fill y
button 	.knopfleiste.go\
		-text "GO"\
		-bg green
button	.knopfleiste.end\
		-text "END"\
		-bg red
pack 	.knopfleiste.end .knopfleiste.go -side bottom -fill both -expand true


foreach i {Start Step Stop} {
	frame	.eingabe_$i -bg yellow
	pack	.eingabe_$i -side top -fill x -anchor n
	label	.eingabe_$i.label -text $i -borderwidth 0 -bg yellow
	entry	.eingabe_$i.entry -width 10
	pack	.eingabe_$i -side top -fill x -anchor n
	pack	.eingabe_$i.entry -side right\
			-padx 8 -pady 2
	pack	.eingabe_$i.label -side right -anchor e -expand true\
			-padx 8 -pady 2
}

text .output -state disabled -width 40 -height 10
pack .output -fill both -expand true

