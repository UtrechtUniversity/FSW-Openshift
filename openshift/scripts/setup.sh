#!/bin/bash
echo "⭐️ Load Laravel Setup";
# Load libraries
. /var/www/openshift/scripts/liblaravel.sh

# Load Laravel environment
. /var/www/openshift/scripts/laravel-env.sh
. /var/www/openshift/scripts/liblog.sh

# Ensure Laravel environment variables are valid
laravel_validate


