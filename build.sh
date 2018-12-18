echo "Generating temporary HTML file..."
template="index.dev.html"
cp $template /tmp
tempfile="/tmp/$template"
echo "Temporary HTML file: $tempfile"
echo "Downloading Font Face Observer..."
loadFonts=`curl -Ls https://unpkg.com/fontfaceobserver/fontfaceobserver`
echo "Done."
echo "Generating HTML meta tags..."
metatags=`cat data.json | html-meta-tags`
echo "Gathering email..."
emailSecret=`echo ${EMAIL:-} | sed -e "s/@/\[at\]/g" -e "s/\./\[dot\]/g"`
echo "Done."
echo "Replacing variables..."
replace --silent "{metatags}" "$metatags" $tempfile
replace --silent "{loadFonts}" "$loadFonts" $tempfile
replace --silent "{email}" "${EMAIL:-}" $tempfile
replace --silent "{emailSecret}" "$emailSecret" $tempfile
echo "Done."
echo "Compressing HTML file..."
html-minifier --collapse-boolean-attributes \
              --collapse-whitespace  \
              --remove-attribute-quotes \
              --remove-attribute-quotes  \
              --remove-comments  \
              --remove-empty-attributes \
              --remove-empty-elements \
              --remove-optional-tags  \
              --remove-redundant-attributes  \
              --remove-script-type-attributes  \
              --remove-tag-whitespace \
              --sort-attributes \
              --sort-class-name \
              --use-short-doctype  \
              --minify-css true \
              --minify-js true \
              --output index.html \
              $tempfile
echo "Done."
