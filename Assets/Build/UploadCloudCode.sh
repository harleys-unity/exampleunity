#!/bin/bash

environment="${1:?Missing Deploy Environment}"
npm install --silent -g ugs

ugs status
ugs env list

solutions=$(find ./CloudCodeModules -name '*.sln')

for solution in $solutions; do
	echo "Uploading $solution"
	ugs deploy $solution -e $environment -j
done

