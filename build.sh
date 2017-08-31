# Just so I don't have to apt-get md5sum
hashify() {
    node -p "require('crypto').createHash('md5').update(require('fs').readFileSync('$1')).digest('hex')"
}

echo "Generating temporary HTML file..."
template="index.dev.html"
cp $template /tmp
tempfile="/tmp/$template"
echo "Temporary HTML file: $tempfile"
echo "Downloading CSS loader..."
loadCSS=`curl -Ls https://unpkg.com/fg-loadcss`
echo "Done."
echo "Hashing external CSS..."
externalCSSHash=`hashify external.css`
externalCSS="$externalCSSHash.css"
cp external.css $externalCSS
echo "External CSS file: $externalCSS"
echo "Done."
echo "Generating HTML meta tags..."
metatags=`cat data.json | node meta-tags.js`
echo "Done."
echo "Replacing variables..."
replace -s "{metatags}" "$metatags" $tempfile
replace -s "{externalCSS}" "$externalCSS" $tempfile
replace -s "{loadCSS}" "$loadCSS" $tempfile
echo "Done."
echo "Compressing HTML file..."
htmlmin $tempfile > index.html
echo "Done."
