FROM nginxinc/nginx-unprivileged:stable-alpine
# entrypoint

RUN echo "  ⭐️️️️️Bind entrypoint"

ADD ./docker/vhost.conf /etc/nginx/conf.d/default.conf
