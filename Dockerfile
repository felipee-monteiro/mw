FROM serversideup/php:8.4-fpm-nginx

ENV NVM_VERSION=v0.40.3
ENV NVM_DIR=/home/www-data/.nvm
ENV BASH_ENV=/home/www-data/.bash_env

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --chown=www-data:www-data . .
COPY --chown=www-data:www-data install-required-extensions.sh /usr/local/bin/install-required-extensions

RUN mkdir -p /home/www-data \
    && touch "${BASH_ENV}" \
    && chmod +x /usr/local/bin/install-required-extensions \
    && echo '. "${BASH_ENV}"' >> /home/www-data/.bashrc

RUN apt-get update -q -y && apt-get install -y \
    curl \
    git \
    jq \
    tmux \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${NVM_DIR} \
    && chown -R www-data:www-data ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | PROFILE="${BASH_ENV}" bash

ENV HOME=/home/www-data/

RUN nvm install --default

