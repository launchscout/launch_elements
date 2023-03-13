#!/bin/bash

DIR=/home/runner/work/launch_cart/launch_cart/test/axe_html/

for f in $(find $DIR -iname "*.html"); do
	if [ ! -d "$f" ]; then
		sed -i 's|/assets/css/app.css|./assets/css/app.css|g' $f
		sed -i 's|/assets/js/app.js|./assets/js/app.js|g' $f
		node assets/node_modules/pa11y/bin/pa11y.js $f
	fi
done
