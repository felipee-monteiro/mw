#!/bin/bash

alias required-extensions="(composer check-platform-reqs --lock --no-ansi --format=json 2>/dev/null || true) \ 
        | jq -r 'map(.name) | .[] | select(startswith("ext-")) | sub("^ext-"; "")'";

exec /init;