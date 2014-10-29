#!/usr/bin/tclsh

# 3. Beispiel -- Liste von moeglichen
# Funktionsnamen anlegen (koennte in der
# Praxis vielleicht auch aus einer Datei
# eingelesen werden)
#
set funcs ""
lappend funcs "abs"
lappend funcs "tan"
lappend funcs "cos"
lappend funcs "sin"
lappend funcs "floor"
lappend funcs "exp"
lappend funcs "atan"

# Listenelemente nun mit "|" verbinden
#
set funcs "([join $funcs |])"

# Regulaeren Ausdruck fuer verpflichtenden
# White-Space definieren
#
set white {[ \t]+}

# Regulaeren Ausdruck fuer nicht leere Liste
# aus den moeglichen Funktionsnamen, getrennt
# durch White Space definieren, als 'Railroad-
# Diagramm' # also folgendes:
#
#        +--> sin --+
#        |          |
#        +--> cos --+
#        |          |
#  ------+--> tan --+----+----->
#   ^    |          |    |
#   |    +    ...   +    |
#   |    |          |    |
#   |    +-> floor -+    |
#   |                    |
#   |                    |
#   +-------- ws <-------+
#     (Wiederholung mit
#       Trennzeichen)
#
set listre "^${funcs}(${white}${funcs})*$"

# Hinweis: Dieser Regulaere Ausdruck entspricht
# dem nachfolgenden, zu obigem aequivalenten
# Diagramm:
#
#                            (optional)
#      (einmal)    +------------------------+
#                  |                        |
#    +--> sin --+  |         +--> sin --+   |
#    |          |  |         |          |   |
#    +--> cos --+  |         +--> cos --+   |
#    |          |  |         |          |   v
# ---+--> tan --+--+---> ws -+--> tan --+-+--->
#    |          |    ^       |          | |
#    +    ...   +    |       +    ...   + |
#    |          |    |       |          | |
#    +-> floor -+    |       +-> floor -+ |
#                    |                    |
#                    +--------------------+
#                        (beliebig oft)

# ======================================================
# Test- und Demoprogramm

proc getinp {prompt var} {
	upvar $var rline
	puts -nonewline $prompt
	flush stdout
	set res [gets stdin rline]
	return [expr $res != -1]
}

while {[getinp "--> " text]} {
	if [regexp $listre $text] {puts OK} else {puts ERROR}
}

