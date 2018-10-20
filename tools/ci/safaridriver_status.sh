#!/bin/bash

PORT=55555
"/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver" -p $PORT &
PID=$!
# safaridriver isn't immediately responsive, so loop
while true; do
    # https://superuser.com/a/442395
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/status")
    if [ "$http_code" == "200" ]; then
        echo "safaridriver status OK"
        break
    fi
    echo "waiting for safaridriver to start"
    sleep 1
done
kill $PID
