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
    echo "O arquivo composer.lock é necessário para a instalação correta das extensões. Versione-o e tente novamente"
fi
