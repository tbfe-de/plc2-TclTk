#!/usr/local/bin/wish

# 2. Beispiel -- Erzeugen einer Oberflaeche
# fuer das Programm zur Ausgabe mathematischer
# Funtionen, hier werden die beiden Geometry-
# Manager "pack" und "grid" gemischt verwendet:

frame	.knopfleiste
pack 	.knopfleiste -side right -fill y
button 	.knopfleiste.go\
		-text "GO"\
		-bg green
button	.knopfleiste.end\
		-text "END"\
		-bg red
pack 	.knopfleiste.end .knopfleiste.go -side bottom -fill both -expand true


frame	.eingabefelder -bg yellow
pack	.eingabefelder -side top -fill x -anchor n
set n 0
foreach i {Start Step Stop} {
	label	.eingabefelder.label_$i -text $i -borderwidth 0 -bg yellow
	entry	.eingabefelder.entry_$i -width 10
	grid	.eingabefelder.label_$i -column 0 -row $n -sticky e
	grid	.eingabefelder.entry_$i -column 1 -row $n
	incr n
}
grid	columnconfigure .eingabefelder 0 -weight 1

text .output -state disabled -width 40 -height 10
pack .output -fill both -expand true

