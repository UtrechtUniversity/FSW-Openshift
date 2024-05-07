#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "
# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate --seed

echo "⭐️ generate key";
php artisan key:generate

# run apache in foreground
apache2-foreground
