#!/usr/bin/tclsh

socket -server sendpage 8082

proc dir_content {pn} {
	set result ""
	foreach fname [glob $pn/*] {
		append result "<a href='$fname'>$fname</a><br />\n"
	}
	return $result
}

proc file_content {pn} {
	set fd [open $pn r]
	set result [read $fd]
	close $fd
	return "<pre>$result</pre>"
}

proc sendpage {sock - -} {
	global counter
	while {[gets $sock rline] > 0} {
		if {[info exists pname]} continue
		regexp {^GET[ \t]+/([^ \t]*)} $rline - pname
	}
	if {![info exists pname]} {
		puts -nonewline $sock "HTTP/1.1 400 Bad Request\r\n"
		close $sock
		return
	}
	if {[string length $pname] == 0} {
		set pname .
	}
	if {[file isdir $pname]} {
		set page [dir_content $pname]
	}
	if {[file isfile $pname]} {
		set page [file_content $pname]
	}
	if {![info exists page]} {
		puts -nonewline $sock "HTTP/1.1 404 Not Found\r\n"
		close $sock
		return
	}
	puts -nonewline $sock \
		"HTTP/1.1 200 OK\r\n
		 <html>
		 <head><title>$pname</title></head>
		 <body>$page</body>
		 </html>\r\n"
	close $sock
}

vwait forever
