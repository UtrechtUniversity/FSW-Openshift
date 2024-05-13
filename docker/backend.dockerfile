FROM php:8.2-fpm

COPY composer.lock composer.json /var/www/
# set workdir
WORKDIR /var/www

# upgrades!
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y zip

RUN apt-get install -y sudo nano
#RUN apt-get install -y git
#RUN apt-get install -y zip unzip libzip-dev
#RUN apt-get install -y wget
#RUN apt-get install -y sudo
#RUN apt-get install -y iputils-ping
#RUN apt-get install -y locales locales-all
# RUN apt-get install -y netcat

#RUN apt-get install -y libxml2-dev libzip-dev libpng-dev
#
### run apache as non-root user
## https://takac.dev/docker-run-apache-as-non-root-user-based-on-the-official-image/
#RUN apt-get install -y libcap2-bin procps
#RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2
#RUN chown -R www-data:www-data /var/log/apache2
# RUN chown -R www-data:www-data /usr/local/bin/apache2-foreground

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
## TODO eigenlijk wil je een image zonder  dev packages.
##RUN composer install --no-dev --no-scripts

# install self signed certifcates to thrust other local dev environments
#COPY ./docker/certificates/docker.dev.crt /usr/local/share/ca-certificates
#RUN cd /usr/local/share/ca-certificates && update-ca-certificates

COPY ./docker/docker.env /var/www/.env

RUN php artisan key:generate

# entrypoint
COPY ./docker/backend-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

RUN php artisan optimize


# Expose port 8990 and start php-fpm server
EXPOSE 8990
CMD ["php-fpm"]

ENTRYPOINT /entrypoint.sh
