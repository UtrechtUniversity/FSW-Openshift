FROM php:8.2-fpm

COPY composer.lock composer.json /var/www/
# set workdir
WORKDIR /var/www

# upgrades!
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y zip

RUN apt-get install -y sudo nano

# install additional PHP extensions
RUN  apt-get install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.7 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt

RUN apt-get clean -y

# set corrent TimeZone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# copy webapp files
COPY .. /var/www

# install composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# run composer

RUN composer install

COPY ./docker/openshift.env /var/www/.env

RUN chmod -R a+rw /var/www/storage
RUN php artisan key:generate

# entrypoint
COPY ./docker/backend-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

RUN php artisan optimize

# Expose port 8443 and start php-fpm server
EXPOSE 8080

ENTRYPOINT /entrypoint.sh

CMD ["php-fpm"]

