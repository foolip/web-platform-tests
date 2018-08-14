#!/usr/bin/env sh

find * -maxdepth 0 -type d | while read d; do
    if [ -f "json/$d.json" ]; then
        cat > "$d/cssharness.html" << EOF
<!doctype html>
<script src=/resources/testharness.js></script>
<script src=/resources/testharnessreport.js></script>
<script src=/resources/cssharness.js></script>
<script>css_test('$d');</script>
EOF
    fi
done
