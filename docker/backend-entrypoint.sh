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

# run apache in foreground
apache2-foreground