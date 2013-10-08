#!/usr/bin/env sh
#
# Luca Cappelletti (c) 2013
# 
# <mutek@riseup.net>
#
# Public Domain
# li nei paesi dove il Public Domain risulta vago o piu restrittivo allora applicare la licenza:
# Do What The Fuck You Want License
# 0. Just Do What The Fuck You Want

EPOCA_UNIX="$(date +%s)"
ATOM_MAIN_UPDATED="$(date +%Y-%M-%dT%H:%M:%SZ)"

# Legge un eventuale file di configurazione dove è possibile configurare variabili che verranno usate qua e la
[ -f ./CONFIG ] && . ./CONFIG

# cosmesi inutile
echo "Titolo: "$Titolo

# prima linea di un documento HTML che facciamo passare via http
cat model/doctype.source > index.html
printf .
# Tag standard universali
echo "<html>" >> index.html
echo "<head>" >> index.html

# Sorgente HTML della sezione HEAD
. ./model/head.source
printf .
# Tag standard
echo "</head>" >> index.html
echo "<body>" >> index.html

# Sorgente HTML della sezione HEADER
. ./model/header.source
printf .

# Sorgente HTML della sezione BODY la parte di testa 
cat model/body.header.source >> index.html
printf .

# ATOM
# Sorgente Atom header del file
cat << ATOM_HEADER > atom.xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

ATOM_HEADER

. ./model/atom_header.source

# Riempimento automatico dei post testuali nel BODY 
for post in $(ls -c source)
do

# basename $post .txt significa dammi il basename di $post togliendo il postfix .txt se esiste
# poi passa al vaglio di transalte per sostituirmi tuttel le occorrenze del carattere _ con uno spazio
TITOLO="$(basename $post .txt | tr '_' ' ')"

cat << POST >> index.html
        <h3>
	<a name="$TITOLO" class="anchor" href="#$TITOLO"><span class="octicon octicon-link"></span></a>$TITOLO</h3>	
	<p>
POST

	# un po di magia
	cat source/$post | sed  ':a;N;$!ba;s/\n/\<\/br\>/g' > $post.tmp
	sed -i 's/ at / at /g' $post.tmp
	sed -i 's/[[:cntrl:]]/ /g' $post.tmp
	sed -i 's/^[[:space:]]*$//g' $post.tmp 
	sed -i '/^$/{'"$NL"'N'"$NL"'/^\n$/D'"$NL"'}' $post.tmp
	sed -i 's/^$/<\/ul><p>/g' $post.tmp
	sed -i '/<p>$/{'"$NL"'N'"$NL"'s/\n//'"$NL"'}' $post.tmp
	sed -i 's/<p>[[:space:]]*"/<p><ul>"/' $post.tmp
	sed -i 's/^[[:space:]]*-/<br> -/g' $post.tmp
	sed -i 's/http:\/\/[[:graph:]\.\/]*/<a href="&">&<\/a> /g' $post.tmp

	cat $post.tmp >> index.html
	echo "	</p>" >> index.html

	printf .

##########
# ATOM entry
##########
ATOM_ENTRY_UPDATED="$(stat source/$post | grep Change | cut -d"." -f 1 | cut -d " " -f 2,3 | tr ' ' 'T')Z"
ATOM_ENTRY_SUMMARY="$(head -n 5 source/$post)"
cat << ATOM_ENTRY >> atom.xml
<entry>
    <title>$TITOLO</title>
    <link href="$Url/#$TITOLO"/>
    <!-- id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id -->
    <updated>$ATOM_ENTRY_UPDATED</updated>
    <summary>$ATOM_ENTRY_SUMMARY</summary>
    <content>

ATOM_ENTRY

cat $post.tmp >> atom.xml
echo "</content></entry>" >> atom.xml
	printf .
	unlink  $post.tmp

done

# Sorgente HTML del BODY la parte di coda 
cat model/body.footer.source >> index.html
printf .

# Tag standard universali di chiusura documento
echo "</body>" >> index.html
echo "</html>" >> index.html

cat model/atom_footer.source >> atom.xml

printf .
echo ""

# TODO
# in futuro accettare markdown e parserizzare con un parser rocksolid se esiste altrimenti passar eil text cosi come si trova
# il markdown viene riconosciuto solo dall'estensione del file senza magic dentro al testo...
# con l'estensione il produttore esplicita la volonta di trattarlo come tale (piu facile chiaro e lineare per tutti)