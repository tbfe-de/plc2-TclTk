# 'mproc' is a tool to process free text info like receits
# it is controlled by
#	- matchers
# and
#	- contexts

# defining a matcher: to define a matcher the following
# command must be called.  the meaning of its arguments
# is:
#	- name	(uniquely names that matcher)
#	- regex	(determines matching input)
#	- vlist	(list of variables for submatches)
#	
#
proc matcher {name regex vlist} {
	global _~ _=
	if {[info exists _~($name)]} {
		error "matcher: name already used: $name"
	}
	set _~($name) $regex
	set _=($name) $vlist
}

foreach n [array names _~] {
	puts -nonewline "$n: look for [set _~($n)] "
	if {[string length [set _=($n)]] > 0} {
		puts -nonewline " (store to [set _=($n)])"
	}
	puts ""
}

# defining a context: to define a context the following
# command must be called.  the meaning of the arguments
# is:
#	- name	(uniqely names the context)
#		context is instantiated)
#	- entry	(entry action, executed whenever the
#		context is instantiated)
#	- exit	(exit action, executed whenever the
#		context is discarded)
#	- match	(any matcher to try in this context)
#	- body	(any action assigned to the match)
# note that the last two (match and body) may be repeated
# as often as required.
#

+RECH
						Kunden-Nr.	Rechnungs-Nr.	Datum
						83-852323-87	12-5706242	10.05.2001

			RECHNUNG

				Ihre Abonnement-Bestellung vom: 09.01.2000

+				1	Ausgabe				41,96	41,69
					 Nr. 04/2001 (Juni/Juli)
				Der Windows-Berater
-
							Versandkostenanteil	 3,00

							Rechnungsbetrag
			7%	2,94	DM	24.05.2001			44,96

		#bezahlt:
		#TAN:
		#PG/2001: 3-1.3
		#:FO:
-



matcher xxx ".*" {}
matcher yyy ".*" {}
matcher zzz ".(.)(.*)" { a b }

