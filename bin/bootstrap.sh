#!/bin/bash

## Create directories
[ -d 'tmp' ] || ( mkdir -p tmp/vendor/bin; mkdir -p tmp/vendor/bundle; ln -sv ./vendor/cache ./tmp/vendor/cache )

## Install Gems
bundle install --binstubs=tmp/vendor/bin --path=tmp/vendor/bundle

# Run Cucumber
tmp/vendor/bin/rake tests
