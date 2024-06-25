#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "

echo "⭐️ Load Laravel environment";
pwd

/var/www/openshift/scripts/setup.sh


# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate --seed
##composer install --no-dev --no-scripts
npm run build

#php artisan serve --host=0.0.0.0 --port=8080
php-fpm
