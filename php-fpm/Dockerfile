FROM php:7.1-fpm

# install the PHP extensions we need
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
            libjpeg62-turbo-dev \
            libpng12-dev \
            ; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli opcache; \
    \
    apt-get clean autoclean; \
    apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*

# TODO consider removing the *-dev deps and only keeping the necessary lib* packages

# install Ioncube
RUN set -xe \
        && cd /tmp \
        && curl -o ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
        && tar -zxf ioncube.tar.gz \
        && mv ioncube/ioncube_loader_lin_7.1.so /usr/local/lib/php/extensions/* \
        && rm -Rf ioncube.tar.gz ioncube \
        && echo "zend_extension=ioncube_loader_lin_7.1.so" > /usr/local/etc/php/conf.d/00-ioncube-loader.ini

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
        echo 'post_max_size=256M'; \
        echo 'upload_max_filesize=256M'; \
        echo 'memory_limit=256M'; \
        echo 'variables_order="EGPCS"'; \
    } > /usr/local/etc/php/conf.d/uploads.ini

COPY www.conf /usr/local/etc/php-fpm.d/www.conf