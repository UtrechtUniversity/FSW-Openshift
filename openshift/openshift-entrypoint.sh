#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "

php artisan config:clear

# run artisan migrate & seed
echo "⭐️ Run artisan db show";
php artisan db:show
# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate

php-fpm