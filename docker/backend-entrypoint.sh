#!/usr/bin/env bash
echo "  ⭐️️️️️⭐️️️️️⭐️️️️️⭐️ VERSIE: 1 "
# run artisan migrate & seed
echo "⭐️ Run artisan migrate";
php artisan migrate --seed

echo "⭐️ Set folder access";
chmod a+w -R /var/www/bootstrap/cache
chmod a+w -R /var/www/public
chmod a+w -R /var/www/vendor
chmod a+w -R /var/www/storage

#php artisan serve --host=0.0.0.0 --port=8080
php-fpm