FROM alpine:3.20.1 AS larapine

LABEL maintainer="Ivan Maruca"

WORKDIR /var/www/html

ENV TZ=UTC

RUN apk update

RUN apk add gnupg su-exec curl ca-certificates zip unzip supervisor sqlite libcap libpng-dev bind-tools librsvg
RUN apk add php83 php83-cli php83-dev php83-pgsql php83-sqlite3 php83-gd php83-pecl-imagick php83-curl php83-imap \
    php83-mysqli php83-mbstring php83-xml php83-zip php83-bcmath php83-soap php83-intl \
    php83-ldap php83-pecl-msgpack php83-pecl-igbinary php83-pecl-redis php83-pecl-swoole \
    php83-fpm php83-opcache php83-pecl-memcached php83-pecl-xdebug \
    php83-pdo php83-pdo_mysql php83-pdo_pgsql php83-pdo_sqlite \
    php83-phar php83-tokenizer php83-dom php83-xmlwriter php83-xmlreader php83-fileinfo \
    php83-sodium php83-iconv php83-simplexml \
    php83-exif php83-ftp
RUN apk add nodejs npm yarn

RUN apk add nginx

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN rm -rf /var/cache/apk/*

COPY www.conf /etc/php83/php-fpm.d/www.conf
RUN mkdir -p /etc/supervisor/conf.d
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint /usr/local/bin/docker-entrypoint
COPY php.ini /etc/php83/conf.d/99_larapine.ini
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/http.d/default.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /etc/periodic/1min
RUN echo -e "#!/bin/sh\nphp /var/www/html/artisan schedule:run >> /dev/null 2>&1" > /etc/periodic/1min/laravel-schedule.sh
RUN chmod +x /etc/periodic/1min/laravel-schedule.sh
RUN crontab -l | { cat; echo "*    *   *   *   *   run-parts /etc/periodic/1min"; } | crontab -

RUN adduser -u 1000 -D -S -H -G www-data www-data

EXPOSE 80 9000

ENTRYPOINT [ "docker-entrypoint" ]
