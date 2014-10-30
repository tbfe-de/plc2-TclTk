#!/usr/in/wish

# ---------------------------------------------------------------------
# general utilities
# ---------------------------------------------------------------------

# find ordering number for key in list (may also add new key)
#
proc keyOrdnum {k key {add 0}} {
	upvar $k klist	;# the key list
	#        key	;# key to look up
	#	 add	;# add if missing

	# find position f key in list ...
	set p [lsearch -exact $klist $key]
	# ... add it if new and so requested
	if {$p < 0 && $add} {
		set p [llength $klist]
		lappend klist $key
	}

	# return the ordering number
	return $p
}

# ---------------------------------------------------------------------
# i/o utilities
# ---------------------------------------------------------------------

# read a single line, skipping comments
#
proc readLine {fid line} {
	upvar $line lref
	while {[gets $fid lref] >= 0 && [regexp {^[ \t]*#} $lref]} {
		# skip comments
	}
	return [expr ![eof $fid]]
}

# ---------------------------------------------------------------------
# managing single entries
# ---------------------------------------------------------------------
# NOTE: entries are stored as arrays, indexed by the key (excluding
#       the colon); further there is a special entry with index colon,
#	that contains a the list of all keys

# initialize entry
#
proc entryInit {e args} {
	upvar $e entry	;# names the entry
	#	 args	;# list of key/value-pairs

	# delete old entry
	set entry(:) {}
	# set values to new entry
	foreach {k v} $args {
		set entry(:$k) $v
		keyOrdnum entry(:) $k 1
	}

	# return list of keys
	return entry(:)
}

# set value in entry for given key (may also add new key)
#
proc entrySet {e key {val {}}} {
	upvar $e entry	;# names the entry
	#        key	;# key to look up
	#	 val	;# new value

	keyOrdnum entry(:) $key 1
	set entry(:$key) $val

	# return new value set
	# (implicitely)
}

# read a single entry
#
proc entryRead {e {chan stdin}} {
	upvar $e entry	;# names the entry
	#        chan	;# chanel to read

	# initialize counter and key list ...
	set ngrp 0
	set entry(:) {}
	# ... then go on reading line by line
	while {[readLine $chan line]} {
		if {[regexp {^[ \t]*$} $line]} {
			# empty line
			if {$ngrp} break
		} elseif {[regexp {^([^:]+):[ 	]*(.*)$} $line dummy key val]} {
			entrySet entry $key $val
			set ngrp [llength $entry(:)]
		} else {
			error "bad input format"
		}
	}

	# return number of keys read
	return $ngrp
}

# print out entry (or keys matching pattern)
#
proc entryPrint {e {kpat "*"} {chan stdout}} {
	upvar $e entry	;# names the entry
	#	 kpat	;# pattern to select keys
	#	 chan	;# output channel

	# initialize counter ...
	set cnt 0
	# ... run through entries ...
	foreach k $entry(:) {
		# ... if selected ...
		if {[string match "$kpat" $k]} {
			# ... add newline before first ...
			if {[incr cnt] == 1} {
				puts $chan ""
			}
			# ... and print key/value pair
			puts $chan "$k: $entry(:$k)"
		}
	}

	# return number of matching (printed) keys
	return $cnt
}

# ---------------------------------------------------------------------
# managing tables of entries
# ---------------------------------------------------------------------
# NOTE: tables are stored as arrays, indexed by a colon-separated pair
#	of row number and key; the row number followed by a colon only
#	is a special entry that contains a list of all the keys for
#	that row.
#	rows are nombered starting with 1, row 0 is special as it may
#	contain default values for initializing new entries.
#	there are two further special entries, containing information
#	about the table in total: first at indexed colon contains there
#	is a list that holds the union of all keys for that table,
#	second the empty index is the nomber of rows.

# initialize the table (clearing its old contents)
#
proc tabInit {t args} {
	upvar $t table	;# names the table
	#	 args	;# list of key/value-pairs for default

	# clear old contents, ignoring errors if not yet existant
	catch {unset table}

	# initlalize special entries
	set table() 0
	set table(:) {}

	# set default values
	set table(0:) {}
	foreach {k v} $args {
		set table(0:$k) $v
		keyOrdnum table(0:) $v 1
	}
	set table(:) $table(0:)

	# return list of default keys
	# (implicitely)

}

# return the number of entries in a table
#
proc tabSize {t} {
	upvar $t table	;# names the table

	# return size (see comment above)
	return $table()
}

# get entry from row in table
#
proc tabGetEntry {t row e} {
	upvar $t table	;# names the table
	#	 row	;# selects row
	upvar $e entry	;# names the entry

	# make sure row exists in table
	if {$row > [tabSize table]} {
		error "row does not exist"
	}

	# clear old values in entry ...
	catch {unset entry}
	# ... then copy, key by key
	foreach k [set entry(:) $table($row:)] {
		set entry(:$k) $table($row:$k)
	}

	# return list of keys
	# (implicitely)
}

# set row in table to new entry
#
proc tabSetEntry {t row e} {
	upvar $t table	;# names the table
	#	 row	;# selects row
	upvar $e entry	;# names the entry

	# make sure row exists in table
	if {$row > [tabSize table]} {
		error "row does not exist"
	}

	# copy entry to row, key by key ...
	foreach k $entry(:) {
		set table($row:$k) $entry(:$k)
		keyOrdnum table(:) $k 1
	}
	# ... then delete inactive keys ...
	foreach k $table($row:) {
		if {[lsearch $entry(:) $k] == -1} {
			unset $table($row:$k)
		}
	}
	# .. and set new list of active keys
	set table($row:) $entry(:)

	# return list of active keys
	# (implicitely)
}

# add new entry to table
#
proc tabAddEntry {t e} {
	upvar $t table	;# names the table
	upvar $e entry	;# names the entry

	# initialize list and
	set table($table():) {}
	# ... copy values over
	tabSetEntry table $table() entry
	incr table()

	# return list of keys
	# (implicitely)
}

# read a table in the whole
#
proc tabRead {file t} {
	upvar $t table	;# names the table
	#	 entry	:# temporary

	# open file
	if {[catch {open $file r} chan]} {
		error "cannot open file $file ($chan)"
	}

	# read entries, one by one ...
	while {[entryRead entry $chan]} {
		# ... and add to table
		tabAddEntry table entry
	}

	# close file
	close $chan

	# nothing useful to return
	return
}

# print out single entry (or entries matching pattern)
#
proc tabPrint {t row {kpat "*"}} {
	upvar $t table	;# names the table
	#	 row	;# row in table
	#	 entry	;# temporary

	tabGetEntry table $row entry
	entryPrint entry $kpat

	# nothing useful to return
	return
}

# print out all entries (or entries matching pattern)
#
proc tabPrintAll {t {kpat "*"}} {
	upvar $t table	;# names the table

	for {set row 0} {$row < [tabSize table]} {incr row} {
		tabPrint table $row $kpat
	}

	# nothing useful to return
	return
}

# ---------------------------------------------------------------------
# create a visualizer for entry
# ---------------------------------------------------------------------
# NOTE: A visualizer is a window that shows the content
#	of an entry.

proc crEntryVisualizer {fwid e {idpfx {}} {dummy w}} {
	upvar $e ename	;# name of entry structure

	# at first, destroy childs (if there are any)
	foreach s [grid slaves $fwid] {
		destroy $s
	}

	# then create new children according to entry
	set i 0
	foreach k $ename($idpfx:) {
		incr i
		label $fwid.label$i -anchor e -text "$k:"
		entry $fwid.entry$i -textvariable ${e}($idpfx:$k)
		grid $fwid.label$i $fwid.entry$i -sticky news
	}
	grid columnconfigure $fwid 1 -weight 1
}

proc activateButtons {fwid} {
	global t current
	if {$current == 0} {
		.b.prev configure -state disabled
	} else {
		.b.prev configure -state normal
	}
	if {$current == [tabSize t]-1} {
		.b.next configure -state disabled
	} else {
		.b.next configure -state normal
	}
	crEntryVisualizer $fwid t $current t
}

proc getNext {fwid} {
	global current
	incr current +1
	activateButtons $fwid
}

proc getPrev {fwid} {
	global current
	incr current -1
	activateButtons $fwid
}

frame .e
frame .b
label .b.num -background white -width 5 -textvariable current
button .b.next -text "Weiter" -command {getNext .e}
button .b.prev -text "Zurück" -command {getPrev .e}
pack .b.num -side left
pack .b.next .b.prev -side right
pack .b .e -side top -fill x

tabInit t
tabRead [lindex $argv 0] t
tabPrintAll t

set current 0
activateButtons .e


