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

cat body.source >> index.html



echo "</body>" >> index.html
echo "</html>" >> index.html
