FROM debian:stretch-slim

ENV PHP_URL="https://secure.php.net/get/php-7.1.26.tar.gz/from/this/mirror"

ENV PHP_VERSION 7.1.26

WORKDIR /opt

RUN mkdir -p /opt/php-src \
    && mkdir -p /etc/php.d

RUN apt-get update && apt-get install -y \
        curl \
        wget \
        make \
        vim-tiny \
        gcc \
        g++ \
        libc-dev \
        libxml2-dev \
        gdb \
        autoconf \
        && apt-get clean \
        && apt-get autoremove

RUN wget -O php.tar.gz "$PHP_URL" \
    && mkdir -p php-src \
    && tar -zxvf php.tar.gz -C php-src --strip-components=1 \
    && rm php.tar.gz \
    && cd php-src \
    && ./configure --enable-debug --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d \
    && make -j$(nproc) \
    && make install \
    && cp php.ini-development php.ini

ENTRYPOINT [ "./docker-php-entrypoint" ]

CMD [ "php", "-a" ]
