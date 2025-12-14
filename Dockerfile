FROM serversideup/php:8.4-fpm-nginx

ENV NVM_VERSION=v0.40.3
ENV NVM_DIR=/home/www-data/.nvm
ENV BASH_ENV=/home/www-data/.bash_env

USER root

SHELL ["/bin/bash", "--login", "-o", "pipefail", "-c"]

COPY --chown=www-data:www-data . .

RUN mkdir -p /home/www-data \
    && touch "${BASH_ENV}" \
    && echo '. "${BASH_ENV}"' >> /home/www-data/.bashrc

RUN apt-get update -q -y && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${NVM_DIR} \
    && chown -R www-data:www-data ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | PROFILE="${BASH_ENV}" bash \
    && install-php-extensions intl xdebug gd

USER www-data

ENV HOME=/home/www-data/

RUN nvm install --default
