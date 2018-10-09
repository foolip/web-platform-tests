#!/bin/bash
set -ex

which pip || sudo easy_install pip

pip install -U setuptools
pip install -U requests
pip install -U virtualenv

# Use STP 65, as safaridriver is broken in 66
HOMEBREW_NO_AUTO_UPDATE=1 brew cask install https://raw.githubusercontent.com/Homebrew/homebrew-cask-versions/e73cea88817b781d59beb25fb2640681a1ef4da8/Casks/safari-technology-preview.rb
# https://web-platform-tests.org/running-tests/safari.html
sudo "/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver" --enable
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically 1
# https://github.com/web-platform-tests/results-collection/blob/master/src/scripts/trust-root-ca.sh
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain tools/certs/cacert.pem
./wpt make-hosts-file | sudo tee -a /etc/hosts
