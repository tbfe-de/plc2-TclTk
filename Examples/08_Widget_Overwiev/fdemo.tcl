#!/usr/bin/wish

# pending has    read-  in-    changed |
# update  focus  only   valid  value   | STATE
# ------------------------------------------------
#   no	   no     no     no     no     | 0x00
#   no     no     no     no     YES    | 0x01
#   no     no     no     YES    no     | 0x02
#   no     no     no     YES    YES    | 0x03
#   no     no     YES    no     no     | 0x04
#   no     no     YES    no     YES    | 0x05
#   no     YES    no     no     no     | 0x08
#   no     YES    no     no     YES    | 0x09
#   no     YES    no     YES    no     | 0x0A
#   no     YES    no     YES    YES    | 0x0B
#   YES    no     no     no     no     | 0x10
#   YES    no     no     no     YES    | 0x11
#   YES    no     YES    no     no     | 0x14
#   YES    no     YES    no     YES    | 0x15

proc getVisualAttributes {s} {
	switch -exact -- [format "0x%02X" [expr $s]] {
	0x00 {return "white     black     sunken"}
	0x01 {return "bisque    black     sunken"}
	0x02 {return "pink      white     sunken"}
	0x03 {return "pink      black     sunken"}
	0x04 {return "lightgrey white     groove"}
	0x05 {return "lightgrey black     groove"}
	0x08 {return "white     black     sunken"}
	0x09 {return "yellow    black     sunken"}
	0x0A {return "red       white     sunken"}
	0x0B {return "red       black     sunken"}
	0x10 {return "gold      white     sunken"}
	0x11 {return "gold      black     sunken"}
	0x14 {return "gold      white     groove"}
	0x15 {return "gold      black     groove"}
	}
}

proc visualizeEntryState {b s} {
	set attr [getVisualAttributes $s]
	$b configure\
		-background [lindex $attr 0]\
		-foreground [lindex $attr 1]\
		-relief [lindex $attr 2]
}

foreach {x t} {
	0  "xxxxx" 
 	1  "xxxxC"
	2  "xxxIx"
	3  "xxxIC"
	4  "xxRxx"
	5  "xxRxC"
	8  "xFxxx"
	9  "xFxxC"
	10 "xFxIx"
	11 "xFxIC"
	16 "Uxxxx"
	17 "UxxxC"
	20 "UxRxx"
	21 "UxRxC"
} {
	pack [entry .b$x -borderwidth 5 -width 30 -font {Helvetica 12}]
	pack [frame .f$x -height 8]
	.b$x insert end $t
	visualizeEntryState .b$x $x
	if [expr $x & 0x4] {.b$x configure -state disabled}
}

