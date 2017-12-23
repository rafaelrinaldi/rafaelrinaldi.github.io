echo "Generating temporary HTML file..."
template="index.dev.html"
cp $template /tmp
tempfile="/tmp/$template"
echo "Temporary HTML file: $tempfile"
echo "Downloading Font Face Observer..."
loadFonts=`curl -Ls https://unpkg.com/fontfaceobserver`
echo "Done."
echo "Generating HTML meta tags..."
metatags=`cat data.json | html-meta-tags`
echo "Gathering email..."
emailSecret=`echo $EMAIL | sed -e "s/@/\[at\]/g" -e "s/\./\[dot\]/g"`
echo "Done."
echo "Replacing variables..."
replace -s "{metatags}" "$metatags" $tempfile
replace -s "{loadFonts}" "$loadFonts" $tempfile
replace -s "{email}" "$EMAIL" $tempfile
replace -s "{emailSecret}" "$emailSecret" $tempfile
echo "Done."
echo "Compressing HTML file..."
htmlmin $tempfile > index.html
echo "Done."
