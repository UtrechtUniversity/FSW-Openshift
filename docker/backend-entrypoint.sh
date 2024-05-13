#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "
# run artisan migrate & seed

if [ "$APP_ENV" = "local" ]; then
    ## in de dockerfile worden de dev packages verwijderd, dus die moeten we eerst installeren
    php composer.phar install

    echo "⭐️ Run artisan migrate";
    php artisan migrate --seed

    echo "⭐️ generate key";
    php artisan key:generate
fi
php-fpm
