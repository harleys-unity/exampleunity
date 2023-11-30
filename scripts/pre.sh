#!/bin/sh

file=test.txt
echo "We can write files via Bash" > $file
value=`cat $file`
echo "TADA! $value"