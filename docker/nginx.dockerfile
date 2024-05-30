FROM nginxinc/nginx-unprivileged:stable-alpine
# entrypoint

RUN echo "  ⭐️️️️️Bind entrypoint"

# ADD ./docker/vhost.conf /etc/nginx/conf.d/default.conf
USER root
RUN chown -R nginx:nginx /usr/share/nginx/html
RUN chown -R nginx:nginx /var/cache/nginx/client_temp
RUN chown -R nginx:nginx /etc/nginx/nginx.conf
USER nginx
