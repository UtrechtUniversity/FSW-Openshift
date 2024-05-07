#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "
# run artisan migrate & seed

if [ "$APP_ENV" = "local" ]; then
    echo "⭐️ Run artisan migrate";
    php artisan migrate --seed

    echo "⭐️ generate key";
    php artisan key:generate
fi
# run apache in foreground
apache2-foreground
