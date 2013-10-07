#!/usr/bin/env sh

[ -f ./CONFIG ] && . ./CONFIG

echo "Titolo: "$Titolo

cat doctype.source > index.html

echo "<html>" >> index.html
echo "<head>" >> index.html
. ./head.source
echo "</head>" >> index.html

echo "<body>" >> index.html


cat 2.1_header.html >> index.html

cat 2.0_body.html >> index.html



echo "</body>" >> index.html
echo "</html>" >> index.html
