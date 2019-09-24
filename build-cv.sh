echo "Generating temporary HTML file..."
template="cv.dev.html"
cp $template /tmp
tempfile="/tmp/$template"
echo "Temporary HTML file: $tempfile"
echo "Replacing variables..."
replace --silent "{email}" "$EMAIL" $tempfile
replace --silent "{phone}" "$PHONE" $tempfile
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
              --output cv.html \
              $tempfile
echo "Done."
