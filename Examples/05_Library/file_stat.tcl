#!/usr/bin/tclsh

foreach dir $argv {
    foreach file [glob $dir] {
        puts "[string repeat = 12] $file"
        file stat $file info
        foreach {k v} [array get info] {
            puts [format "%-11s: %s" $k $v]
        }
    }
}
