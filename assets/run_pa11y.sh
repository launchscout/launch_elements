#!/bin/bash
FILES=../test/axe_html/*

for f in $FILES; do
	node node_modules/pa11y/bin/pa11y.js $f
done
