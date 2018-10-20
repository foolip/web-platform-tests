#!/bin/bash

PORT=55555
"/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver" -p $PORT &
PID=$!
# safaridriver isn't immediately responsive, so loop
TMPFILE=$(mktemp)
while true; do
    # https://superuser.com/a/442395
    http_code=$(curl -s -S -o $TMPFILE -w "%{http_code}" "http://localhost:$PORT/status")
    if [ "$http_code" == "200" ]; then
        echo "safaridriver status OK"
        break
    fi
    cat $TMPFILE
    sleep 1
done
kill $PID
