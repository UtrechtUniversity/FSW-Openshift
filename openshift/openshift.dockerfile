FROM php:8.3-fpm

RUN apt-get update && apt-get install -y nodejs npm

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

COPY composer.lock composer.json /var/www/
# set workdir
WORKDIR /var/www

# upgrades!
RUN apt-get -y dist-upgrade
RUN apt-get -qq install -y zip

RUN apt-get -qq install -y sudo nano
RUN apt-get -qq install -y libonig-dev
RUN apt-get -qq install -y curl gnupg git

# testing fpm:
RUN apt-get -qq install -y libfcgi0ldbl procps

# install additional PHP extensions
RUN  apt-get -qq install -y libmcrypt-dev
RUN  apt-get -qq install -y libmagickwand-dev --no-install-recommends
RUN  pecl install mcrypt-1.0.7
RUN  docker-php-ext-enable mcrypt

# install postgres
# Install system dependencies
RUN apt-get update && apt-get install -y libpq-dev
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo intl pdo_pgsql pgsql

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get clean -y

# set corrent TimeZone
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# copy webapp files
COPY .. /var/www

COPY ./openshift/openshift.env /var/www/.env

RUN chmod -R a+rw /var/www/storage
RUN chmod -R a+rw /var/www/bootstrap/cache
RUN php artisan key:generate

# entrypoint
COPY ./openshift/openshift-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

RUN php artisan optimize

ENTRYPOINT /entrypoint.sh

RUN npm install

EXPOSE 8080
EXPOSE 9000

CMD ["php-fpm"]

