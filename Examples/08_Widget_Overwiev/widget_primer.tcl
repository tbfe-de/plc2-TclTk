#!/usr/bin/wish

proc x - { global a b r; set r [expr $a*$b] }
scale .a -orient horizontal\
    -from 1 -to 10 -variable a -command x
scale .b -orient vertical\
    -from 1 -to 10 -variable b -command x
label .r -font {Arial 30} -textvariable r
label .m -background darkgrey -text "×"
grid .m .a
grid .b .r
