#!/usr/bin/tclsh
# Say hello via Browser
set page "\
HTTP/1.1 200 OK
Content-Type:text/html

<html>
     <head><title>%s</title></head>
     <body><h1>Salve !</h1></body>
</html>
"
proc say_hello {fd ip port} {
    global page
    puts "incomming request from $ip:$port"
    puts $fd [format $page $ip:$port]
    close $fd
}
socket -server say_hello 12345
vwait forever
