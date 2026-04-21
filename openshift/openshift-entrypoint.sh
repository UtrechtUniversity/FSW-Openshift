#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "

# Cache config with runtime environment variables (APP_URL, ASSET_URL, etc.)
echo "⭐️ Run artisan optimize (caching config with runtime env vars)";
php artisan optimize

# run artisan migrate & seed
echo "⭐️ Run artisan db show";
php artisan db:show
# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate

php-fpm