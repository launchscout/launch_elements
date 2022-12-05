#!/bin/bash
mix deps.get --only prod
MIX_ENV=prod mix compile

npm install --prefix assets/
mix assets.deploy
MIX_ENV=prod mix release --overwrite