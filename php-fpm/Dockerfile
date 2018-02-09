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

RUN set -xe \
        && cd /tmp \
        && curl -L https://github.com/Whissi/realpath_turbo/releases/download/v2.0.0/realpath_turbo-2.0.0.tar.bz2 > realpath_turbo-2.0.0.tar.bz2  \
        && tar -vxf realpath_turbo-2.0.0.tar.bz2 \
        && cd realpath_turbo-2.0.0 \
        && phpize \
        && ./configure \
        && make \
        && make test NO_INTERACTION=1 \
        && make install

# install new relic
RUN apt-get update && \
    apt-get install -y \
    libyaml-dev \
    python-pip \
    python-dev \
    wget && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/newrelic
WORKDIR /opt/newrelic
RUN wget -r -nd --no-parent -Alinux.tar.gz \
         http://download.newrelic.com/php_agent/release/ >/dev/null 2>&1 \
         && tar -xzf newrelic-php*.tar.gz --strip=1
ENV NR_INSTALL_SILENT true
ENV NR_INSTALL_PHPLIST /usr/local/bin/
RUN bash newrelic-install install
WORKDIR /
RUN pip install newrelic-plugin-agent
RUN mkdir -p /var/log/newrelic
RUN mkdir -p /var/run/newrelic

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php

RUN mkdir -p /var/tmp/php/opcache
RUN chown www-data:www-data /var/tmp/php/opcache
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY realpath_turbo.ini /usr/local/etc/php/conf.d/realpath_turbo.ini
COPY php.ini /usr/local/etc/php/php.ini

COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# # install Ioncube
# RUN set -xe \
#         && cd /tmp \
#         && curl -o ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
#         && tar -zxf ioncube.tar.gz \
#         && mv ioncube/ioncube_loader_lin_7.1.so /usr/local/lib/php/extensions/* \
#         && rm -Rf ioncube.tar.gz ioncube \
#         && echo "zend_extension=ioncube_loader_lin_7.1.so" > /usr/local/etc/php/conf.d/00-ioncube-loader.ini

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
