#!/usr/bin/tclsh
#
socket -server acc_con 1234

proc p {tag what} {
	 return "<$tag>$what</$tag>"
}

proc acc_con {fd client -} {
	set req "req from $client"
	while {[gets $fd r] > 0} {
		regexp {^GET +/([^ ]*)} $r - cmd
	}
	regsub -all {%20|\+} $cmd { } cmd
	catch {eval exec $cmd} output
	regsub -all \n $output {<br />} output
	puts $fd\
		[p html "
			[p head\
				[p title $req]
			]
			[p body\
				[p tt $output]
			]
			"
		]
	close $fd
}

vwait forever
