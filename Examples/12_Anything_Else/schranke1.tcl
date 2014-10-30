#!/usr/bin/wish

# ================================================================================
# Simulation: Parkhaus-Schranke mit FSM
# ================================================================================
#
set HELP {
  Das Programm demonstriert die Funktionalität einer "Finite-State-Machine" (FSM)
  zur Steuerung einer Parkhaus-Schranke. Das GUI zeigt den "Grundriss" der Szene,
  bestehend aus
  	einer Ampel links oben (rot/gruen),
	einer Schranke (in der Mitte, querliegend) mit
	zwei zugehörigen Endeschaltern (linkes/rechtes Schrankenende, braun),
	zwei Lichtschranken (je eine vor und hinter der Schranke, gelb) und
	einer Kartenbox (links unten, blau)

  Der Normalablauf ist wie folgt:
  - ein Fahrzeug stoppt vor der Schranke und durchbricht die "Lichtschranke 1"
    (= Klick in die zugehörige Check-Box);
  - die Kartenbox bietet darauf hin ein Ticket zur Entnahme an
    (= Anzeige "K", Entnahme durch Klick);
  - die Schranke öffnet, danach schaltet die Ampel auf grün;
  - das Fahrzeug fährt ein und durchbricht die "Lichschranke 2"
    (= Klick in die zugehörige Check-Box)
  - die Ampel schaltet auf rot zurück
  - das Fahrzeug gibt die "Lichschschranke 1" und die "Lichtschranke 2" frei
    (= Klick in die zugehörigen Check-Boxen)
  - die Schranke schließt wieder
  (In der Titelzeile wird dabei jeweils der aktuelle Zustand der FSM angezeigt.)

  Öffnen und Schließen der Schranke erfolgt dabei einerseits autonom, wird aber
  andererseits - realitätsnah - durch zwei Endeschalter gesteuert. Da diese auch
  mit der Hand (= Maus) "berührbar" sind, lässt sich die Schranke ggf. im nicht
  vollständig geöffneten oder geschlossenen Zustand anhalten. (Da die Steuerung
  nicht "sehen" kann, muss sie auf die Rückmeldung der Endeschalter vertrauen.)

  Ansatzweise ist auch bereits eine Fehlerbehandlung implementiert, die Zurzeit
  aber lediglich erkennt, ob der "falsche" Endeschalter der Schranke anspricht.
  In diesem Fall geht die FSM in einen Fehlerzustand, erkennbar daran, dass die
  Schrankenbewegung angehalten und die Ampel komplett ausgeschaltet wird.

  Die Aufhebung des Fehlerzustands ist derzeit nur über den Befehl
	FSM RESET
  im Test- und Debug-Fenster des Programms möglich. Dieses wird durch Klick mit
  der rechten Maustaste an irgend eine Stelle im Haupt-Fenster geöffnet. Es
  enthält eine Eingabezeile, in der sich über Kommandos wie
  	schranke oeffnen
	schranke schliessen
	ampel rot
	ampel gruen
	ampel aus
  auch Teilfunktionalitäten durchspielen kann. In einer Statuszeile unterhalb
  der Eingabezeile werden dabei ggf. weitere Meldungen angezeigt.

  Prinzipiell sind in der Eingabezeile beliebige Tcl-Befehle möglich, z.B. lässt
  sich durch die Eingabe
	set schranke_(geschwindigkeit) 100
  oder
	set schranke_(geschwindigkeit) 25
  das Öffnen und Schließen der Schranke beschleunigen oder verlangsamen. Die
  Statuszeile zeigt dabei den Return-Wert (oder eine evtl. Fehlermeldungen)
  des eingegebenen Tcl-Befehls.

  Abschlusstipp: Eine "weichere" Bewegung der Schranke lässt sich um den Preis
  von etwas mehr CPU-Last leicht erreichen, in dem beim VRS-Aufruf (ganz am Ende
  dieses Programms) kleinere Wert angegeben werden. Umgekehrt verringern größere
  Werte die CPU-Last und führen zu einem "sprunghafteren" Bewegungsablauf.
}

# --------------------------------------------------------------------------------
#                                                                   Hilfe anzeigen
bind . <F1> {
	if {[winfo exists .help]} {
		raise .help
	} else {
		toplevel .help
		wm title .help "Schranke: Bedienung"
		wm protocol .help WM_DELETE_WINDOW {destroy .help; focus .}
		pack [label .help.text -justify left -textvariable HELP]
	}
}

# --------------------------------------------------------------------------------
#                                                                Hardware-Sensoren
proc EA {} {
	DBG_status "Endeschalter Schranke AUF"
	FSM EA
}
proc EZ {} {
	DBG_status "Endeschalter Schranke ZU"
	FSM EZ
}
proc KB {} {
	DBG_status "Parkschein entnommen"
	FSM KB
}
proc L1 {s} {
	DBG_status "Lichtschranke 1 $s"
	FSM L1 $s
}
proc L2 {s} {
	DBG_status "Lichtschranke 2 $s"
	FSM L2 $s
}

# --------------------------------------------------------------------------------
#                                                                 Hardware-Aktoren
array set ampel_ {
	rot	aus
	gruen	aus
}
proc ampel {c} {
	global ampel_
	switch -- $c {
		a - aus {
			set ampel_(rot)   aus
			set ampel_(gruen) aus
		}
		r - rot {
			set ampel_(rot)   ein
			set ampel_(gruen) aus
		}
		g - gruen {
			set ampel_(rot)   aus
			set ampel_(gruen) ein
		}
	}
}

array set schranke_ {
	motor		 ""
	geschwindigkeit  50
}
proc schranke {c} {
	global schranke_
	switch -- $c {
		h - halt {
			set schranke_(motor) ""
		}
		o - oeffnen {
			set schranke_(motor) links
		}
		s - schliessen {
			set schranke_(motor) rechts
		}
	}
}

array set kartenbox_ {
	ticket "*"
}
proc kartenbox {c} {
	global kartenbox_
	switch -- $c {
		a - anbieten {
			set kartenbox_(ticket) "K"
		}
		e - entnommen {
			set kartenbox_(ticket) "*"
		}
	}
}

# --------------------------------------------------------------------------------
#                                                             Finite State Machine
proc FSM {event {p -}} {
	global FSM_state
	switch -glob -- $FSM_state:$event {
		0:0 {
			ampel rot
			schranke schliessen
			set FSM_state INIT
		}
		INIT:EZ {
			schranke halt
			set FSM_state BEREIT
		}
		BEREIT:L1 {
			if {$p == "unterbrochen"} {
				kartenbox anbieten
				set FSM_state TICKET
			}
		}
		TICKET:KB {
			kartenbox entnommen
			schranke oeffnen
			set FSM_state OEFFNEN
		}
		OEFFNEN:EA {
			schranke halt
			ampel gruen
			set FSM_state EINFAHRT
		}
		EINFAHRT:L2 {
			if {$p == "unterbrochen"} {
				ampel rot
			}
			if {$p == "frei"} {
				schranke schliessen
				set FSM_state SCHLIESSEN
			}
		}
		SCHLIESSEN:EZ {
			schranke halt
			set FSM_state BEREIT
		}
		OEFFNEN:EZ -
		SCHLIESSEN:EA {
			schranke halt
			ampel aus
			set FSM_state FEHLER
		}
		FEHLER:RESET {
			schranke schliessen
			ampel rot
			set FSM_state INIT
		}
	}
}

# --------------------------------------------------------------------------------
#                                                                GUI mit Animation
proc GUI_ampel {} {
	frame .ampel -borderwidth 3 -relief raised
	frame .ampel.oben\
			-borderwidth 3 -relief sunken\
			-height 16 -width 16
	frame .ampel.unten\
			-borderwidth 3 -relief sunken\
			-height 16 -width 16
	pack .ampel.oben .ampel.unten -fill both -expand 1
	return ".ampel"
}
proc GUI_ls {i} {
	checkbutton .ls_$i\
		-text "Lichtschranke $i"\
		-onvalue "unterbrochen"\
		-offvalue "frei"\
		-bg yellow -command "
			switch -glob \$ls_$i {
			f* {.ls_$i configure -bg yellow}
			u* {.ls_$i configure -bg grey}
			}
			L$i \$ls_$i
		"
	return ".ls_$i"
}
proc GUI_schranke {} {
	frame .schranke
	pack [frame .schranke.ende_auf -width 10 -bg brown] -fill y -side left
	pack [frame .schranke.ende_zu  -width 10 -bg brown] -fill y -side right
	pack [frame .schranke.leer1 -width 260 -height 3]\
	     [frame .schranke.durchfahrt]\
	     [frame .schranke.leer2 -width 260 -height 3]\
	     	-fill x -side top
	frame .schranke.durchfahrt.balken -width 260 -height 6 -bg black
	pack .schranke.durchfahrt.balken -side left
	bind .schranke.ende_auf <Enter> EA
	bind .schranke.ende_zu <Enter> EZ
	return ".schranke"
}
proc GUI_kartenbox {} {
	button .kartenbox\
		-bd 5 -width 1 -relief raised\
		-bg blue -fg white -state disabled\
		-command {KB}
	return ".kartenbox"
}
proc GUI {} {
	grid [GUI_ampel]	-sticky  e
	grid [GUI_ls 2]     -	-sticky news
	grid [GUI_schranke] -
	grid [GUI_ls 1]	    -	-sticky news
	grid [GUI_kartenbox]  
	grid columnconfigure . 1 -weight 1

	bind . <Button-3> DBG
	wm title . "Schranke"
}

# --------------------------------------------------------------------------------
#                                                          Debug- und Test-Fenster
proc DBG {} {
	if {[winfo exists .dbgwin]} return
	toplevel .dbgwin
	wm title .dbgwin "Schranken-Test"
	entry .dbgwin.command -width 40 -bg white
	bind .dbgwin.command <Return> DBG_command
	label .dbgwin.output
	pack .dbgwin.command -fill x
	pack .dbgwin.output -fill x
}
proc DBG_command {} {
	global schranke_ ampel_
	set cmd [.dbgwin.command get]
	if {[catch {eval $cmd} ret]} {
		DBG_status "ERROR: $ret"
	} else {
		DBG_status "=> $ret"
	}
	.dbgwin.command selection range 0 end

}
proc DBG_status {message} {
	if {[winfo exists .dbgwin]} {
		.dbgwin.output configure -text $message
	}
}

# --------------------------------------------------------------------------------
#                                                       Virtual Reality Simulation
proc VRS_kartenbox {tm} {
	global kartenbox_
	switch -- $kartenbox_(ticket) {
		"K" {
			.kartenbox configure -state normal
		}
		"*" {
			.kartenbox configure -state disabled
		}
	}
	.kartenbox configure -text $kartenbox_(ticket)
}
proc VRS_ampel {tm} {
	global ampel_
	switch $ampel_(rot) {
		aus {.ampel.oben configure -bg lightgrey}
		ein {.ampel.oben configure -bg red}
	}
	switch $ampel_(gruen) {
		aus {.ampel.unten configure -bg lightgrey}
		ein {.ampel.unten configure -bg green}
	}
}
proc VRS_schranke {tm} {
	global schranke_
	set max [.schranke.leer1 cget -width]
	set min [expr $max/10+1]
	set pos [.schranke.durchfahrt.balken cget -width]
	set stp [expr $schranke_(geschwindigkeit)*$tm/1000*$max/100 + 1]
	switch $schranke_(motor) {
		links {
			if {[incr pos -$stp] <= $min} {
				set pos $min
				EA
			}
		}
		rechts {
			if {[incr pos +$stp] >= $max} {
				set pos $max
				EZ
			}
		}
	}
	.schranke.durchfahrt.balken configure -width $pos
}
proc VRS {tm} {
	global FSM_state
	wm title . "Schranke ($FSM_state)"
	VRS_ampel $tm
	VRS_schranke $tm
	VRS_kartenbox $tm
	after $tm VRS $tm
}

# --------------------------------------------------------------------------------
#                                                                   HAUPT-PROGRAMM
GUI			;# Grafisches User-Interface anlegen
FSM [set FSM_state 0]	;# Finite State Machine initialisieren
VRS 50			;# Virtual Reality Simulation starten
if {$argc == 1 &&
    [lindex $argv 0] == "--dbgwin"} DBG	;# DBG-Window bei Start

#END#
