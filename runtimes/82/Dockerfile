FROM alpine:3.19.1 AS larapine

LABEL maintainer="Ivan Maruca"

WORKDIR /var/www/html

ENV TZ=UTC

RUN apk update

RUN apk add gnupg su-exec curl ca-certificates zip unzip supervisor sqlite libcap libpng-dev bind-tools librsvg
RUN apk add php82 php82-cli php82-dev php82-pgsql php82-sqlite3 php82-gd php82-pecl-imagick php82-curl php82-imap \
    php82-mysqli php82-mbstring php82-xml php82-zip php82-bcmath php82-soap php82-intl \
    php82-ldap php82-pecl-msgpack php82-pecl-igbinary php82-pecl-redis php82-pecl-swoole \
    php82-fpm php82-opcache php82-pecl-memcached php82-pecl-xdebug \
    php82-pdo php82-pdo_mysql php82-pdo_pgsql php82-pdo_sqlite \
    php82-phar php82-tokenizer php82-dom php82-xmlwriter php82-xmlreader php82-fileinfo \
    php82-sodium php82-iconv php82-simplexml \
    php82-exif
RUN apk add nodejs npm yarn

RUN apk add nginx

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN rm -rf /var/cache/apk/*

COPY www.conf /etc/php82/php-fpm.d/www.conf
RUN mkdir -p /etc/supervisor/conf.d
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /var/run/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint /usr/local/bin/docker-entrypoint
COPY php.ini /etc/php82/conf.d/99_larapine.ini
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
