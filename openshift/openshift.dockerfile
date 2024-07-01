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
RUN apt-get -qq install -y curl gnupg git

# install mysql
RUN docker-php-ext-install pdo_mysql mysqli

# install additional PHP extensions
RUN  apt-get -qq install -y libmcrypt-dev \
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

# install & run composer
#COPY ./docker/auth.json /root/.composer/auth.json

#RUN echo ${ COMPOSER_AUTH }
#RUN echo ${ env.COMPOSER_AUTH }
RUN cat /root/.composer/auth.json
RUN echo ${COMPOSER_AUTH} > /root/.composer/auth.json
RUN cat /root/.composer/auth.json
#RUN echo ${COMPOSER_AUTH_JSON}
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# run composer
#RUN composer config --global --auth github-oauth.github.com ${COMPOSER_AUTH}
RUN  composer install --prefer-dist --no-suggest --no-progress --no-interaction
#RUN composer install --prefer-dist --no-suggest --no-progress

COPY ./openshift/openshift.env /var/www/.env

RUN chmod -R a+rw /var/www/storage
RUN chmod -R a+rw /var/www/bootstrap/cache
RUN php artisan key:generate

# entrypoint
COPY ./openshift/openshift-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

RUN php artisan optimize

ENTRYPOINT /entrypoint.sh

CMD ["php-fpm"]

