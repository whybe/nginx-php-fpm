#!/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ]; then

    if [ ! -z "$NEWRELIC_KEY" ]; then

        sed -i -e 's/;extension = "newrelic.so"/extension = "newrelic.so"/g' /usr/local/etc/php/conf.d/newrelic.ini
        # sed -i -e 's/zend_extension=xdebug.so/;zend_extension=xdebug.so/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
        sed -i -e 's/;newrelic.transaction_tracer.detail = 1/newrelic.transaction_tracer.detail = 1/g' /usr/local/etc/php/conf.d/newrelic.ini

        if [ "$NEWRELIC_KEY" ]; then
            sed -i -e "s/REPLACE_WITH_REAL_KEY/$NEWRELIC_KEY/g" /usr/local/etc/php/conf.d/newrelic.ini
        fi

        if [ "$NEWRELIC_APP_NAME" ]; then
            sed -i -e "s/PHP Application/$NEWRELIC_APP_NAME/g" /usr/local/etc/php/conf.d/newrelic.ini
        fi
    fi

    # if [ ! -z "$XDEBUG" ]; then
    #     sed -i -e 's/;zend_extension=xdebug.so/zend_extension=xdebug.so/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    #     sed -i -e 's/xdebug.default_enable = 0/xdebug.default_enable = 1/g' /usr/local/etc/php/conf.d/xdebug.ini
    #     sed -i -e 's/extension = "newrelic.so"/;extension = "newrelic.so"/g' /usr/local/etc/php/conf.d/newrelic.ini
    #     sed -i -e 's/zend_extension=opcache.so/;zend_extension=opcache.so/g' /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
    # fi

fi

exec "$@"
