#!/usr/bin/tclsh
#
# Einfaches Demo-Programm fuer Socket-Kommunikation
# (nur Verbindungsaufbau, kein Datenaustausch)

set p  2233	;# IP-port des zugehoerigen Servers

puts "connecting to server socket"
set s [socket 127.0.0.1 $p]
puts "server accepted connection"
close $s

# Hinweis: in der gezeigten Form muessen Client und Server
# auf der selben Maschine laufen (die verwendete IP-Adresse
# 127.0.0.1 steht immer fuer den lokalen Host); mit einer
# anderen IP-Adresse kann das Programm jedoch auch einen
# auf einer anderen Maschine laufenden Server ansprechen.
