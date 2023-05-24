FROM alpine:3.17.3 AS larapine

LABEL maintainer="Ivan Maruca"

WORKDIR /var/www/html

ENV TZ=UTC

RUN apk update

RUN apk add gnupg su-exec curl ca-certificates zip unzip supervisor sqlite libcap libpng-dev bind-tools librsvg
RUN apk add php81 php81-cli php81-dev php81-pgsql php81-sqlite3 php81-gd php81-pecl-imagick php81-curl php81-imap \
    php81-mysqli php81-mbstring php81-xml php81-zip php81-bcmath php81-soap php81-intl \
    php81-ldap php81-pecl-msgpack php81-pecl-igbinary php81-pecl-redis php81-pecl-swoole \
    php81-fpm php81-opcache php81-pecl-memcached php81-pecl-xdebug \
    php81-pdo php81-pdo_mysql php81-pdo_pgsql php81-pdo_sqlite \
    php81-phar php81-tokenizer php81-dom php81-xmlwriter php81-fileinfo
RUN apk add nodejs npm yarn

RUN apk add nginx

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN rm -rf /var/cache/apk/*

COPY www.conf /etc/php81/php-fpm.d/www.conf
RUN mkdir -p /etc/supervisor/conf.d
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint /usr/local/bin/docker-entrypoint
COPY php.ini /etc/php81/conf.d/99_larapine.ini
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY nginx/conf.d/default.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /etc/periodic/1min
RUN echo -e "#!/bin/sh\nphp /var/www/html/artisan schedule:run >> /dev/null 2>&1" > /etc/periodic/1min/laravel-schedule.sh
RUN chmod +x /etc/periodic/1min/laravel-schedule.sh
RUN crontab -l | { cat; echo "*    *   *   *   *   run-parts /etc/periodic/1min"; } | crontab -

RUN adduser -u 1000 -D -S -H -G www-data www-data

EXPOSE 80 9000

ENTRYPOINT [ "docker-entrypoint" ]
