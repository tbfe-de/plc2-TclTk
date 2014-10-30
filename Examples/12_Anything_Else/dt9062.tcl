#!/usr/bin/wish

array set mapping {
        1  {    RS232   Auto    DC      AC      }
        2  {    a1      a6      a5      S       }
        3  {    a2      a7      a3      a4      }
        4  {    b1      b6      b5      p1      }
        5  {    b2      b7      b3      b4      }
        6  {    c1      c6      c5      p2      }
        7  {    c2      c7      c3      c4      }
        8  {    d1      d6      d5      p3      }
        9  {    d2      d7      d3      d4      }
        10 {    Dio     K       n       µ       }
        11 {    Ton     M       %       m       }
        12 {    Hold    Ohm     Duty    F       }
        13 {    Batt    Hz      V       A       }
        14 {    {}      HFE     °C      {}      }
}

set info {Batt RS232 Auto DC AC Dio Ton Hold HFE}
set unit {Ohm Duty F Hz V A °C}
set umod {K n µ M % m} 

frame .sign -height 5 -width 20

proc makeDigit {f {p 0}} {
        set length 40
        set thickness 4
        set dotsize 6
        frame $f
        frame $f.1 -height $thickness -width $length -bg grey
        frame $f.2 -height $length -width $thickness -bg grey
        frame $f.3 -height $length -width $thickness -bg grey
        frame $f.4 -height $thickness -width $length -bg grey
        frame $f.5 -height $length -width $thickness -bg grey
        frame $f.6 -height $length -width $thickness -bg grey
        frame $f.7 -height $thickness -width $length -bg grey
        grid $f.1 -column 1 -row 0
        grid $f.2 -column 2 -row 1
        grid $f.3 -column 2 -row 3
        grid $f.4 -column 1 -row 4
        grid $f.5 -column 0 -row 3
        grid $f.6 -column 0 -row 1
        grid $f.7 -column 1 -row 2
        if {$p} {
                frame .p$p -height $dotsize -width $dotsize -bg grey
                grid .p$p -in $f -padx {8 0} -row 3 -column 3 -sticky s
        }
}

frame .info
set n -1
foreach s $info {
        label .info.[incr n] -text $s -fg grey
        pack .info.$n -side left -padx 3
}

makeDigit .a 1
makeDigit .b 2
makeDigit .c 3
makeDigit .d

label .umod -font {Sans 25}
label .unit -font {Sans 25}

grid .info - - - - .umod .unit
grid .sign .a .b .c .d  ^ ^ -padx 3

set fd [open /dev/ttyS0]
fconfigure $fd\
        -mode 2400,n,8,1\
        -translation binary
fileevent $fd readable "display $fd"

proc display {fd} {
        global mapping info unit umod
        if {[eof $fd]} {
                close $fd
                return
        }
        set x [read $fd 1]
        scan $x %c x
        set n [expr ($x >> 4) & 0xF]
        if {![info exists mapping($n)]} return
        foreach w $mapping($n) {
                if {[regexp {^([abcd])([1-7])$} $w - b z]} {
                        .$b.$z configure -bg grey
                }
                if {[regexp {^p([1-3])$} $w - z]} {
                        .p$z configure -bg grey
                }
                if {[set p [lsearch $info $w]] >= 0} {
                        .info.$p configure -fg grey
                }
                if {[string equal $w [.umod cget -text]]} {
                        .umod configure -text ""
                }
                if {[string equal $w S]} {
                        .sign configure -bg grey
                }
        }
        for {set i 0} {$i < 4} {incr i} {
                if {[expr ($x & (1<<$i))]} {
                        set w [lindex $mapping($n) $i]
                        if {[regexp {^([abcd])([1-7])$} $w - b z]} {
                                .$b.$z configure -bg black
                        }
                        if {[regexp {^p([1-3])$} $w - z]} {
                                .p$z configure -bg black
                        }
                        if {[set p [lsearch $info $w]] >= 0} {
                                .info.$p configure -fg black
                        }
                        if {[string equal $w S]} {
                                .sign configure -bg black
                        }
                        if {[lsearch $umod $w] != -1} {
                                .umod configure -text $w
                        }
                        if {[lsearch $unit $w] != -1} {
                                .unit configure -text $w
                        }
                }
        }
        update idletasks
}
