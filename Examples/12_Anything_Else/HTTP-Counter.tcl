#!/usr/bin/tclsh

socket -server sendpage 8081

set counter 0

proc sendpage {sock - -} {
	global counter
	while {[gets $sock rline] > 0} {
		switch -glob -- $rline {
		{GET*/plus*}	{incr counter}
		{GET*/minus*}	{incr counter -1}
		{GET*/reset*}	{set counter 0}
		}
	}
	puts -nonewline $sock \
		"HTTP/1.1 200 OK\r\n\r\n
		 <html>
		 <head><title>Counter-Server</title></head>
	         <body>
			<h1>Counter: $counter</h6></p>
			<h3>\[<a href=\"plus\">\UP</a>]
			    \[<a href=\"minus\">\DOWN</a>]
			    \[<a href=\"reset\">\ZERO</a>]
			</h3>
		 </body>
	         </html>\r\n"
	close $sock
}

vwait forever
