echo "Generating HTML meta tags..."
metatags=`cat data.json | html-meta-tags`

echo "Downloading Font Face Observer..."
loadFonts=`curl -Ls https://unpkg.com/fontfaceobserver/fontfaceobserver`

echo "Gathering email..."
emailSecret=`echo ${EMAIL:-} | sed -e "s/@/\[at\]/g" -e "s/\./\[dot\]/g"`

echo "Processing template files:"
ls *.dev.html

for template in *.dev.html
do
  echo "\nGenerating temporary HTML file..."
  cp $template /tmp
  tempfile="/tmp/$template"
  echo "Temporary HTML file: $tempfile"

  echo "Replacing variables..."
  replace --silent "{metatags}" "$metatags" $tempfile
  replace --silent "{loadFonts}" "$loadFonts" $tempfile
  replace --silent "{phone}" "${PHONE:-}" $tempfile
  replace --silent "{email}" "${EMAIL:-}" $tempfile
  replace --silent "{emailSecret}" "$emailSecret" $tempfile

  output=`basename $template | sed -e 's/\.dev//'`

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
                --output $output \
                $tempfile
  echo "Generated file '$output'"
done

echo "Done"
