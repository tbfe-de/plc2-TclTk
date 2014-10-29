#!/usr/bin/wish8.0

label .b
entry .e -width 30
label .ascii -text ASCII -anchor e -width 10
label .ascii_c -anchor w -background white
label .number -text Number -anchor e -width 10
label .number_c -anchor w -background white
label .code -text Code -anchor e -width 10
label .code_c -anchor w -background white
label .symbol -text T-Symbol -anchor e -width 10
label .symbol_c -anchor w -background white
label .nsymbol -text N-Symbol -anchor e -width 10
label .nsymbol_c -anchor w -background white


grid .b -
grid .e -
grid .ascii .ascii_c -sticky ew
grid .number .number_c -sticky ew
grid .code .code_c -sticky ew
grid .symbol .symbol_c -sticky ew
grid .nsymbol .nsymbol_c -sticky ew
grid columnconfigure . 1 -weight 1

.b configure -text [concat "<KeyPress>:" [bind Entry <KeyPress>]]
bind .e <Key> {kpress %A %b %k %K %N}

proc kpress {ascii number code symbol nsymbol} {
	if {$ascii != "" && ![string is graph $ascii]} {
		scan $ascii "%c" ascii
		set ascii [format "\\%o" $ascii]
	}
	.ascii_c configure -text $ascii
	.number_c configure -text $number
	.code_c configure -text $code
	.symbol_c configure -text $symbol
	.nsymbol_c configure -text $nsymbol
}
