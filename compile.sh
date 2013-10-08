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

	cat source/$post >> index.html
	echo "	</p>" >> index.html
	printf .
done

# Sorgente HTML del BODY la parte di coda 
cat model/body.footer.source >> index.html
printf .

# Tag standard universali di chiusura documento
echo "</body>" >> index.html
echo "</html>" >> index.html

# Sostituisci in blocco tutti gli /n con dei </br>
sed -i ':a;N;$!ba;s/\n/\<\/br\>/g' index.html
printf .

# TODO
# in futuro accettare markdown e parserizzare con un parser rocksolid se esiste altrimenti passar eil text cosi come si trova
# il markdown viene riconosciuto solo dall'estensione del file senza magic dentro al testo...
# con l'estensione il produttore esplicita la volonta di trattarlo come tale (piu facile chiaro e lineare per tutti)