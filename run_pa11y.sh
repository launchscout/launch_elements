#!/bin/bash

DIR=test/axe_html/
STATUS=0

pa11y_test() {
	sed -i 's|/assets/css/app.css|./assets/css/app.css|g' $1
	sed -i 's|/assets/js/app.js|./assets/js/app.js|g' $1
	node assets/node_modules/pa11y/bin/pa11y.js $1
	local -i status=($?)
	if ((status > 0)); then
		STATUS=($(echo $status))
	fi
}

for f in $(find $DIR -iname "*.html"); do
	if [ ! -d "$f" ]; then
		pa11y_test $f
	fi
done

(exit $STATUS)
