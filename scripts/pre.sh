#!/bin/sh

# echo "Script start"
# pwd

# echo "Display contents of root dir"
# ls -als /

# echo "Display contents of $ANDROID_HOME"
# ls -als $ANDROID_HOME

# echo "Display contents of $ANDROID_NDK_ROOT"
# ls -als $ANDROID_NDK_ROOT

# # ls "C:\Users\buildbot\.gradle\.gsdk_plugin"
# # ls "/Users/buildbot/.gradle/.gsdk_plugin"
# echo "Script end"

file=test.txt

echo "We can write files via Bash" > $file
value=`cat $file`
echo "TADA! $value"