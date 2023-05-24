FROM larapine AS deploy
COPY src/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html/storage
RUN chown root:www-data .env
RUN chmod 640 .env