#!/usr/bin/wish
# =======================================
# Berechnung einer Tabelle des Einmaleins
# =======================================

# Programm-Status (Daten)
# -----------------------
set zeilen 10
set spalten 10
set tabelle ""

# Programm-Aktivitäten
# --------------------
proc einmaleins {} {
	global zeilen spalten   ;# IN
	global tabelle          ;# OUT
	set tabelle ""
	for {set i 1} {$i <= $zeilen} {incr i} {
		for {set j 1} {$j <= $spalten} {incr j} {
			set p [expr $i*$j]
			append tabelle [format " %3d" $p]
		}
		append tabelle "\n"
	}
}

# Benutzer-Interface
# ------------------
frame .oben -bg yellow
label .oben.zl -text "Zeilen:" -bg yellow
entry .oben.ze -width 5 -textvariable zeilen
label .oben.sl -text "Spalten:" -bg yellow
entry .oben.se -width 5 -textvariable spalten

frame .rechts -relief ridge -borderwidth 3
button .rechts.br -text RUN -bg green -command einmaleins
button .rechts.be -text END -bg red -command exit

label .tab -font fixed -textvariable tabelle

# Visuelle Anordnung
# ------------------
pack .oben -side top -ipadx 5 -ipady 5 -fill x
pack .oben.zl .oben.ze .oben.sl .oben.se -side left
pack .rechts -side right -fill y
pack .rechts.br .rechts.be -side top -fill both -expand 1
pack .tab -fill both -expand 1

