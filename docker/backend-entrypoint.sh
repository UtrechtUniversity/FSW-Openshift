#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "
# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate --seed

php-fpm