#!/usr/bin/tclsh

# 1. Beispiel -- einige Regulaere Ausdruecke sowie
# eine einfache kleine Testumgebung zum Ausprobieren.

proc getinp {prompt var} {
    upvar $var rline
    puts -nonewline $prompt
    flush stdout
    set res [gets stdin rline]
    return [expr $res != -1]
}

while {[getinp "--> " text]} {

    # TO-DO (statt der Punkte ergaenzen und Kommentar entfernen:
#   regsub ... $text "" text
    # Fuehrendes und abschliessendes white space wegwerfen:
    # !! Kuemmern Sie sich bitte um DIESES TO-DO ZULETZT !!
        # Es ist NICHT erforlich, um die gewuenschte Funktionalitaet
    # zu bieten - es dient lediglich etwas mehr Komfort bei der
    # Eingabe.

    if [regexp {^[+-]?[0-9]+$} $text] {
        puts "Ganzzahl mit optionalem Vorzeichen"
    }

    # TO-DO: setzen Sie ab hier in den if-Anweisung statt der
    # Punkte die passenden regulaeren Ausdruecke ein, mit denen
    # genau die Pruefung stattfindet, die dem ausgegebenen
    # Text entspricht.

    if [regexp {^...$} $text] {
        puts "Hexzahl mit optionalem umgebenden White Space"
    }

    if [regexp {^...$} $text] {
        puts "Gleitpunktzahl mit optionalem Vor-/Nachkommateil"
    }

    if [regexp {^...$} $text] {
        puts "Gleitpunktzahl mit optionalem Punkt und Nachkommateil"
    }

    if [regexp {^(DM|EUR)[ \t]+[0-9]+(,[0-9][0-9])?$}\
               $text dummy dm_eur dez] {
        puts -nonewline "Betragsangabe in $dm_eur "
        if {[string length $dezimal] == 0} {
            puts "ohne Dezimalteil"
        } else {
            puts "mit Dezimalteil $dez"
        }
    }

    # Hinweis: gemaess dem vorangegangenen Beispiel muessen auch
    # hier im regulaeren Ausdruck klammern verwendet werden, damit
    # jeweils die passenden Teile an die angegebenen Variablen
    # 'mark' und 'pfennig' zuegewiesen werden.

    if [regexp {^DM ...$} $text dummy mark pfennig] {
        puts "$mark Mark und $pfennig Pfennig"
    }
        
    if [regexp {^EUR ...$} $text dummy euro cent] {
        puts "$euro Euro und $cent Cent"
    }

}
