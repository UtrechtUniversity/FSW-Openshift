FROM php:8.2-fpm

COPY composer.lock composer.json /var/www/
# set workdir
WORKDIR /var/www

# upgrades!
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -qq install -y zip

RUN apt-get -qq install -y sudo nano
RUN apt-get -qq install -y mariadb-client

RUN apt-get -qq install -y libonig-dev
RUN apt-get -qq install -y ca-certificates curl gnupg

# required for sending mail.
RUN apt-get -qq install -y sendmail
RUN apt-get -qq install -y libzip-dev
RUN apt-get -qq install -y zlib1g-dev

# install mysql
RUN docker-php-ext-install pdo_mysql mysqli

# install additional PHP extensions
RUN  apt-get -qq install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.7 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt

RUN apt-get clean -y

# email configuration
RUN echo "sendmail_path='/usr/sbin/sendmail -t -i --smtp-addr=\"mail.docker:1025\"'" >> /usr/local/etc/php/conf.d/sendmail.ini
RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint
RUN sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint

# set corrent TimeZone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# copy webapp files
COPY .. /var/www

# install & run composer
    #COPY ./docker/auth.json /root/.composer/auth.json
RUN echo "COMPOSER_TOKEN"
RUN echo "COMPOSER_TOKEN"
RUN echo $(COMPOSER_TOKEN)
RUN echo "GITHUB_TOKEN"
RUN echo $(GITHUB_TOKEN)
RUN echo "COMPOSER_AUTH"
RUN echo $(COMPOSER_AUTH) > /root/.composer/auth.json

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# run composer

RUN composer install

# install self signed certifcates to thrust other local dev environments
COPY ./docker/certificates/docker.dev.crt /usr/local/share/ca-certificates
RUN cd /usr/local/share/ca-certificates && update-ca-certificates

COPY ./docker/docker.env /var/www/.env

RUN chmod -R a+rw /var/www/storage
RUN php artisan key:generate

# entrypoint
COPY ./docker/backend-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

RUN php artisan optimize

ENTRYPOINT /entrypoint.sh
EXPOSE 9000

CMD ["php-fpm"]
