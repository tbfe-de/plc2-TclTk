#!/usr/bin/tclsh

foreach w { Ready Steady Go! } {
	puts $w
	after 3000
}
