#!/usr/bin/env sh

[ -f ./CONFIG ] && . ./CONFIG

echo "Titolo: "$Titolo

cat doctype.source > index.html

echo "<html>" >> index.html
echo "<head>" >> index.html
. ./head.source
echo "</head>" >> index.html

echo "<body>" >> index.html


cat header.source >> index.html

## body.builder
cat body.header.source >> index.html

for post in $(ls -c source)
do

TITOLO="$(basename $post .txt | tr '_' ' ')"

cat << POST >> index.html
        <h3>
	<a name="$TITOLO" class="anchor" href="#$TITOLO"><span class="octicon octicon-link"></span></a>$TITOLO</h3>	
	<p>
POST

	cat source/$post >> index.html
	echo "	</p>" >> index.html

done

cat body.footer.source >> index.html



echo "</body>" >> index.html
echo "</html>" >> index.html
