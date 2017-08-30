echo "Generating temporary HTML file..."
tempfile=`cp -v index.dev.html /tmp | cut -d'>' -f2 | tr -d [:space:]`
echo "Temporary HTML file: $tempfile"
echo "Downloading CSS loader..."
loadCSS=`curl -Ls https://unpkg.com/fg-loadcss`
echo "Done."
echo "Hashing external CSS..."
externalCSSHash=`cat external.css | md5sum | cut -d" " -f1`
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
