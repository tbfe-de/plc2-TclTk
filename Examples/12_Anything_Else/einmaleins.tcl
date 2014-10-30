#!/usr/bin/wish

lappend auto_path "."

# Ausgabe des "1x1" mit beliebiger Zahl von Zeilen
# und Spalten sowie Linien und einer Beschriftung
# am oberen und am linken Rand.
#
proc einmaleins {zeilen spalten} {
	if {$zeilen < 0} {error "Zeilenzahl negativ!"}
	if {$spalten < 0} {error "Spaltenzahl negativ!"}
	printf "1x1 |"
	for {set j 1} {$j <= $spalten} {incr j} {
		printf "%4d" $j
	}
	printf "\n----+%s\n" [linie [expr 4*$spalten]]
	for {set i 1} {$i <= $zeilen} {incr i} {
		printf "%3d |" $i
		for {set j 1 } {$j <= $spalten} {incr j} {
			set p [expr $i * $j]
			printf "%4d" $p
		}
		printf "\n"
	}
}

# Prompt ausgeben (Default ?) und solange
# Benutzereingabe holen, bis Pruefung mit
# regulaerem Ausdruck (Default .*) O.K.
#
proc eingabe {{prompt "?"} {pruef ".*"}} {
	set done 0
	while {!$done} {
		puts -nonewline "$prompt "
		flush stdout
		gets stdin eing
		set done [regexp ^$pruef\$ $eing]
	}
	return $eing
}

proc test1 {} {
	einmaleins  				\
		[eingabe "Spalten:" {[0-9]+}]	\
		[eingabe "Zeilen:"  {[0-9]+}]	\
		;
}

set ZEILEN 10
set SPALTEN 10
set OUTPUT ""

proc test2 {} {
	global ZEILEN SPALTEN OUTPUT
	proc ee {{z 0} {s 0}} {
		global ZEILEN SPALTEN OUTPUT
		if $z { set ZEILEN $z }
		if $s { set SPALTEN $s }
		set OUTPUT ""
		einmaleins $ZEILEN $SPALTEN
	}

	pack [frame .menubar -relief raised -bd 2] -side top -fill x
	menubutton .menubar.main -text "Main" -menu .menubar.main.menu
	menu .menubar.main.menu -tearoff 0
	.menubar.main.menu add command -label "Kleines 1x1"\
			-command {ee 10 10}
	.menubar.main.menu add command -label "Einmaleins"\
			-command ee

	pack .menubar.main -side left

	pack [frame .oben]   -side top   -fill x
	pack [frame .rechts] -side right -fill y

	label .oben.lz -text "Zeilen:"
	entry .oben.ez -textvariable ZEILEN
	bind  .oben.ez <Return> ee
	scale .oben.sz -orient h -showvalue false\
			 -from 1 -to 15 -variable ZEILEN
	label .oben.ls -text "Spalten:"
	entry .oben.es -textvariable SPALTEN
	bind  .oben.es <Return> ee
	scale .oben.ss -orient h -showvalue false\
			-from 1 -to 15 -variable SPALTEN

	# Spalte  0       1        2       3
	grid  .oben.lz .oben.ez .oben.ls .oben.es -sticky nws
	grid  .oben.sz     -    .oben.ss    -     -sticky nwse

	grid columnconfigure .oben 1 -weight 1
	grid columnconfigure .oben 3 -weight 1

	button .run -text "1x1" -bg green -command run
	
	button .end -text "END" -bg red -command exit

	pack .run -in .rechts -side top -fill both -expand yes
	pack .end -in .rechts -side top -fill both -expand yes

	message .output -width 80c -font *fixed* -bg yellow\
		-textvariable OUTPUT
	pack .output -fill both -expand yes

	# quick and dirty: printf so definieren, dass
	# die Ausgabe in das message-Widget geht
	proc printf {fmt args} {
		global OUTPUT
		append OUTPUT [eval format {$fmt} $args]
	}
}

test2
