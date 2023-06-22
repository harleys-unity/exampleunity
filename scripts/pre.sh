echo "Script start"
pwd

echo "Display contents of root dir"
ls -alsR /

echo "Display contents of $ANDROID_HOME"
ls -alsR $ANDROID_HOME

echo "Display contents of $ANDROID_NDK_ROOT"
ls -alsR $ANDROID_NDK_ROOT

# ls "C:\Users\buildbot\.gradle\.gsdk_plugin"
# ls "/Users/buildbot/.gradle/.gsdk_plugin"
echo "Script end"