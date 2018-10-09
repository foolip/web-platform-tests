#!/bin/bash
set -e

echo "-----BEGIN WPT REPORT-----"
cat "$1" | gzip -9 | base64 -b 64
echo "-----END WPT REPORT-----"
