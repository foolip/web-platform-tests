#!/bin/bash
set -ex

WPT_ROOT=$(cd $(dirname "$0")/../.. && pwd -P)
cd $WPT_ROOT

which pip || sudo easy_install pip

sudo pip install -U setuptools
sudo pip install -U requests
sudo pip install -U virtualenv

HOMEBREW_NO_AUTO_UPDATE=1 brew cask install https://raw.githubusercontent.com/Homebrew/homebrew-cask-versions/e73cea88817b781d59beb25fb2640681a1ef4da8/Casks/safari-technology-preview.rb
# https://web-platform-tests.org/running-tests/safari.html
sudo "/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver" --enable
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically 1
# https://github.com/web-platform-tests/results-collection/blob/master/src/scripts/trust-root-ca.sh
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain tools/certs/cacert.pem
./wpt make-hosts-file | sudo tee -a /etc/hosts

# https://github.com/web-platform-tests/results-collection/issues/218 workaround
sudo cp fonts/Ahem.ttf /Library/Fonts
