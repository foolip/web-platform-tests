#!/bin/bash
set -e

echo "travis_fold:start:report_base64"
echo "-----BEGIN WPT REPORT-----"
cat "$1" | gzip -9 | base64 -b 64 | sed '/^$/d'
echo "-----END WPT REPORT-----"
echo "travis_fold:end:report_base64"
