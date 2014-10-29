#!/usr/bin/tclsh

file stat ~ info
foreach el [array names info] {
	puts [format "%-10s: %s" $el $info($el)]
}
