#!/usr/bin/env bash

echo "⭐️ Clean install ${ENVIRONMENT}";

echo "⭐️ Copy .env file";
cp /var/www/docker/docker.env /var/www/.env

echo "⭐️ generate key";
php artisan key:generate

# move to webroot directory
cd /var/www

# run composer
echo "⭐️ Run composer install";
composer install

# make sure folder permissions are set
echo "⭐️ Set folder access Laravel";
chown www-data /var/www/storage -R
chmod a+w -R /var/www/storage
chmod a+w -R /var/www/vendor

# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate --seed



# run apache in foreground
apache2-foreground
