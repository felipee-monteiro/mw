ARG PHP_VERSION=8.5

FROM serversideup/php:${PHP_VERSION}-fpm-nginx

ENV JQ_VERSION=1.8.1
ENV NVM_VERSION=v0.40.3
ENV NVM_DIR=/home/www-data/.nvm
ENV BASH_ENV=/home/www-data/.bash_env

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --chown=www-data:www-data install-required-extensions.sh /usr/local/bin/install-required-extensions
COPY --chown=www-data:www-data .tmux.conf /home/www-data/.tmux.conf

ADD --chown=www-data:www-data https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 /usr/local/bin/jq

RUN mkdir -p /home/www-data \
    && touch "${BASH_ENV}" \
    && chmod +x /usr/local/bin/install-required-extensions \
	&& chmod +x /usr/local/bin/jq \
    && echo '. "${BASH_ENV}"' >> /home/www-data/.bashrc 

RUN apt-get update -q -y && apt-get install -y \
    curl \
    git \
    tmux \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${NVM_DIR} \
    && chown -R www-data:www-data ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | PROFILE="${BASH_ENV}" bash

ENV HOME=/home/www-data/
