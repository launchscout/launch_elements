#!/bin/bash

npm install --prefix assets/
mix assets.deploy
MIX_ENV=prod mix release --overwrite