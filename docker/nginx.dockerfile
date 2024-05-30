FROM nginxinc/nginx-unprivileged:stable-alpine
# entrypoint

RUN echo "  ⭐️️️️️Bind entrypoint"

# ADD ./docker/vhost.conf /etc/nginx/conf.d/default.conf
USER root
RUN chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx/client_temp /etc/nginx/nginx.conf
USER nginx
