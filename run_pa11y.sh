#!/bin/bash

mix assets.deploy
cp -r priv/static/assets/js/ test/axe_html/assets
cp -r priv/static/assets/css/ test/axe_html/assets

DIR=./test/axe_html/

for f in $(find $DIR -iname "*.html"); do
	if [ ! -d "$f" ]; then
		sed -i 's|/assets/css/app.css|./assets/css/app.css|g' $f
		sed -i 's|/assets/js/app.js|./assets/js/app.js|g' $f
		node assets/node_modules/pa11y/bin/pa11y.js $f
	fi
done
