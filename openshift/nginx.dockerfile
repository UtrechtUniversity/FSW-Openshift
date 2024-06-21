FROM nginxinc/nginx-unprivileged:stable-alpine

ADD ./openshift/vhost.conf /etc/nginx/conf.d/default.conf


# Expose port 8443 and start php-fpm server
EXPOSE 8080
# entrypoint
COPY ./docker/backend-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh

RUN php artisan optimize

# Expose port 8443 and start php-fpm server
EXPOSE 8080

ENTRYPOINT /entrypoint.sh

CMD ["nginx", "-g", "daemon off;"]