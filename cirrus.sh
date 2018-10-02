#!/bin/bash

sudo hdiutil attach SafariTechnologyPreview.dmg
sudo installer -pkg "/Volumes/Safari Technology Preview/Safari Technology Preview.pkg" -target /
/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" "/Applications/Safari Technology Preview.app/Contents/Info.plist"
