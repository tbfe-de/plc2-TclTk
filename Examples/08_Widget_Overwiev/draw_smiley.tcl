#!/usr/bin/wish

pack [canvas .c]
.c create oval 30 30 120 120\
	-fill yellow -outline black
.c create oval 50 55 70 60\
	-fill blue
.c create oval 90 55 100 65\
	-fill blue
.c create arc 50 50 100 100\
	-style arc -start 200 -extent 140\
	-width 5 -outline red
