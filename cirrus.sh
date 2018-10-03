#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

sudo hdiutil attach SafariTechnologyPreview.dmg
sudo installer -pkg "/Volumes/Safari Technology Preview/Safari Technology Preview.pkg" -target /
/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" "/Applications/Safari Technology Preview.app/Contents/Info.plist"

# https://github.com/web-platform-tests/wpt/blob/master/docs/_running-tests/safari.md
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically 1
security add-trusted-cert -k "$(security default-keychain | cut -d\" -f2)" tools/certs/cacert.pem

no_proxy='*' ./wpt run --webdriver-binary "/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver" --install-fonts --log-wptreport=wpt_report.json safari infrastructure/
