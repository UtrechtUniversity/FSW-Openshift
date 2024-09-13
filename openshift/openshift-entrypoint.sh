#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "

php artisan config:clear

echo "⭐️ develop branch????";
# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate --seed
##composer install --no-dev --no-scripts
npm run build

#php artisan serve --host=0.0.0.0 --port=8080
php-fpm
