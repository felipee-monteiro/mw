#!/bin/bash

if [ -f composer.lock ]; then
    EXTENSIONS=$(
        (composer check-platform-reqs --lock --no-ansi --format=json 2>/dev/null || true) \
        | jq -r '.[] | select(.name | startswith("ext-")) | .name | sub("^ext-"; "")'
    )

    if [ -n "$EXTENSIONS" ]; then
        install-php-extensions $EXTENSIONS
    fi
else
    composer install --no-scripts --ignore-platform-reqs --no-ansi

    EXTENSIONS=$(
        (composer check-platform-reqs --lock --no-ansi --format=json 2>/dev/null || true) \
        | jq -r '.[] | select(.name | startswith("ext-")) | .name | sub("^ext-"; "")'
    )

    if [ -n "$EXTENSIONS" ]; then
        install-php-extensions $EXTENSIONS
        rm -rf vendor
        rm -f composer.lock
        composer install --no-ansi
    fi
fi