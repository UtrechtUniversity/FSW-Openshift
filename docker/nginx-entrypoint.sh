#!/usr/bin/env sh

if [ "$APP_ENV" = "local" ]; then
    cp ./docker/vhost.conf /etc/nginx/conf.d/default.conf
fi
